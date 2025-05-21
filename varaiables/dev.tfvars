aws_region = "ap-south-1"
aws_account_id = "974989334490"
backend_jenkins_bucket = "terraform-eks-cicd-1234"
backend_jenkins_bucket_key = "jenkins/terraform.tfstate"
vpc_name = "jenkins-vpc"
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
instance_type = "t3.medium"
jenkins_ec2_instance = "jenkins-build-server"
jenkins_security_group = "jenkins-sg"
private_key_path = "D:/key-pairs/mumbai-region.pem"


