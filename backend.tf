terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-1234"
    key = "jenkins/terraform.tfstate"
    region = "ap-south-1"
    
  }
}