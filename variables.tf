variable "aws_region" {
    description = "The region where the infrastructure should be deployed to"
    type = string
  
}

variable "aws_account_id" {
  description = "aws account id"
  type = string
}

variable "backend_jenkins_bucket" {
  description = "S3 bucket where jenkins terraform state file will be stored"
  type = string
}

variable "backend_jenkins_bucket_key" {
  description = "bucket key for the jenkins terraform state file"
  type = string
}

variable "vpc_name" {
    description = "Name of the vpc"
    type = string
    default = "jenkins-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the vpc"
  type = string
#   default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type = list(string)
#   default = [ "10.0.0.0/24", "10.0.0.0/24" ]
}

variable "jenkins_security_group" {
  description = "Name of the Jenkins security group"
  type = string
#   default = "jenkins-sg"
}

variable "protocol" {
  type        = string
  description = "Protocol for security group rule"
  default     = "tcp"
}


variable "jenkins_ec2_instance" {
  description = "Name of the Jenkins EC2 instance"
  type        = string
#   default     = "jenkins-instance"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
#   default     = "t3.micro"
}

variable "private_key_path" {
  description = "EC2 instance type"
  type        = string
  #default = "D:/key-pairs/mumbai-region.pem"
}