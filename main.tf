# creating a vpc

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = var.vpc_name
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets
  map_public_ip_on_launch = true
  enable_dns_hostnames = true
  create_igw = true
  enable_nat_gateway = false
#   single_nat_gateway      = false
  enable_vpn_gateway = false

  tags = {
    Name = var.vpc_name
    Terraform = true
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }



}



# security group

module "security-group" {
    source = "terraform-aws-modules/security-group/aws"

    name = var.jenkins_security_group
    description = "security group for jenkins server"
    vpc_id = module.vpc.vpc_id 

    ingress_with_cidr_blocks = [
        {
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            description = "jenkinsPort"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port = 443
            to_port = 443
            protocol = "tcp"
            description = "https"
            cidr_blocks = "0.0.0.0/0"
        },
        {
            from_port = 80
            to_port = 80
            protocol = "tcp"
            description = "http"
            cidr_blocks = "0.0.0.0/0"
        },
        {
         from_port = 22
         to_port = 22
         protocol = "tcp"
         description = "SSH"
         cidr_blocks = "0.0.0.0/0"   
        },
        {
         from_port = 9000
         to_port = 9000
         protocol = "tcp"
         description = "SonarQubeport"
         cidr_blocks = "0.0.0.0/0"   
        }
    ]
    egress_with_cidr_blocks = [
        {
            from_port = 0
            to_port = 0 
            protocol = "-1"
            cidr_blocks = "0.0.0.0/0"
        }
    ]

    tags = {
        Name = "jenkins-sg"
    }
}

# creating ec2 module

module "ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    
    name = var.jenkins_ec2_instance
    instance_type = var.instance_type
    ami = data.aws_ami.amazon_linux.id
    key_name = "mumbai-region"
    monitoring = true
    vpc_security_group_ids = [module.security-group.security_group_id]
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address = true
    user_data = file("install_build_tools.sh")
    availability_zone = data.aws_availability_zones.azs.names[0]


    tags = {
        Name = "jenkins-server"
        Terraform = "true"
        Environment = "dev"
    }
}

resource "null_resource" "remote_provision" {
  depends_on = [module.ec2_instance]

  connection {
    type        = "ssh"
    host        = module.ec2_instance.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/install_build_tools.sh"
    destination = "/tmp/install_build_tools.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_build_tools.sh",
      "sudo /tmp/install_build_tools.sh"
    ]
  }
}


# Debugging public IP, routing, and internet access

resource "null_resource" "debug_ec2_connectivity" {
  depends_on = [module.ec2_instance]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("D:/key-pairs/mumbai-region.pem") # Adjust path if needed
      host        = module.ec2_instance.public_ip
    }

    inline = [
      "echo '[Debug] Testing metadata service (IMDSv2)'",
      "TOKEN=$(curl -X PUT \"http://169.254.169.254/latest/api/token\" -H \"X-aws-ec2-metadata-token-ttl-seconds: 21600\")",
      "PUBLIC_IP=$(curl -H \"X-aws-ec2-metadata-token: $TOKEN\" http://169.254.169.254/latest/meta-data/public-ipv4)",
      "echo '[Debug] EC2 Public IP:' $PUBLIC_IP",

      "echo '[Debug] Pinging google.com'",
      "ping -c 3 google.com",

      "echo '[Debug] Curl check to https://example.com'",
      "curl -I https://example.com || echo 'Curl failed'",

      "echo '[Debug] DNS Resolution'",
      "nslookup google.com || echo 'nslookup failed'"
    ]
  }

  triggers = {
    instance_id = module.ec2_instance.id
  }
}





