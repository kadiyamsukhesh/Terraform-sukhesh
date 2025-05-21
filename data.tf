data "aws_availability_zones" "azs" {
 state= "available" 
}

# getting latest amazon linux ami

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values=["al2023-ami-*-x86_64"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}
