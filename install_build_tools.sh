#!/bin/bash

# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# set -x

# # ----------------------
# # Install jenkins
# #-----------------------
# sudo yum install -y wget
# sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
# sudo yum upgrade -y
# sudo yum install -y java-17-amazon-corretto-devel jenkins
# sudo systemctl daemon-reload
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
# sudo systemctl status jenkins

# # -----------------------------
# # Install Git
# # -----------------------------
# sudo yum install -y git
# git --version

# # -----------------------------
# # Install Docker
# # -----------------------------
# sudo yum update -y
# sudo yum install -y docker
# sudo usermod -aG docker ec2-user
# sudo usermod -aG docker jenkins
# sudo systemctl enable docker.service
# sudo systemctl start docker.service
# sudo systemctl status docker.service
# sudo chmod 777 /var/run/docker.sock


# # Run Docker container for SonarQube
# sleep 10
# docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# # -----------------------------
# # Skipped AWS CLI & Terraform Installation
# # As you already have them on your system
# # -----------------------------

# # -----------------------------
# # Install kubectl
# # -----------------------------
# curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl"
# chmod +x ./kubectl
# sudo mv ./kubectl /usr/local/bin/kubectl

# # -----------------------------
# # Install Trivy
# # -----------------------------
# sudo tee /etc/yum.repos.d/trivy.repo << 'EOF'
# [trivy]
# name=Trivy repository
# baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
# gpgcheck=1
# enabled=1
# gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
# EOF

# sudo yum -y update
# sudo yum -y install trivy

# # -----------------------------
# # Install Helm
# # -----------------------------
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh

# Ref - https://www.jenkins.io/doc/book/installing/linux/


# Installing jenkins
# sudo yum install wget -y
# sudo wget -O /etc/yum.repos.d/jenkins.repo \
#  https://pkg.jenkins.io/redhat/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
# sudo yum upgrade -y
# # Add required dependencies for the jenkins package
# sudo yum install java-17-amazon-corretto-devel -y
# sudo yum install jenkins -y
# sudo systemctl daemon-reload

# # Starting Jenkins
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
# sudo systemctl status jenkins
# # Ref - https://www.atlassian.com/git/tutorials/install-git

# # Installing git
# sudo yum install -y git
# git --version
# # Installing Docker
# # Ref - https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/
# sudo yum update

# sudo yum install docker -y
# sudo usermod -a -G docker ec2-user
# sudo usermod -aG docker jenkins
# # Add group membership for the default ec2-user so you can run all docker commands without using
# the sudo command:
# id ec2-user
# newgrp docker
# sudo systemctl enable docker.service
# sudo systemctl start docker.service
# sudo systemctl status docker.service
# sudo chmod 777 /var/run/docker.sock


# # Run Docker Container of Sonarqube
# docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
# # Installing AWS CLI
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# sudo apt install unzip -y
# unzip awscliv2.zip
# sudo ./aws/install
# # Ref - https://developer.hashicorp.com/terraform/cli/install/yum
# # Installing terraform
# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo
# https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
# sudo yum -y install terraform

# # Ref - https://pwittrock.github.io/docs/tasks/tools/install-kubectl/
# # Installing kubectl
# sudo curl -LO https://storage.googleapis.com/kubernetesrelease/release/v1.23.6/bin/linux/amd64/kubectl
# sudo chmod +x ./kubectl
# sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export
# PATH=$PATH:$HOME/bin

# # Installing Trivy
# # Ref - https://aquasecurity.github.io/trivy-repo/
# sudo tee /etc/yum.repos.d/trivy.repo << 'EOF'
# [trivy]
# name=Trivy repository
# baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/$basearch/
# gpgcheck=1
# enabled=1
# gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
# EOF
# sudo yum -y update
# sudo yum -y install trivy

# # Intalling Helm
# # Ref - https://helm.sh/docs/intro/install/
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh


set -e

echo "Starting setup on Amazon Linux 2023..."

# Update all packages first
sudo dnf update -y

# Install Java (required by Jenkins)
sudo dnf install -y java-17-amazon-corretto

# Jenkins install
echo "Installing Jenkins..."
sudo curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo -o /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Git
echo "Installing Git..."
sudo dnf install -y git

# Install Docker
echo "Installing Docker..."
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user

# Pull and run Sonarqube container
echo "Running Sonarqube container..."
sudo docker pull sonarqube:latest
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube:latest

# Install Terraform
echo "Installing Terraform..."
TERRAFORM_VERSION="1.5.7"
cd /tmp
curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip
unzip -o terraform.zip
sudo mv terraform /usr/local/bin/
rm terraform.zip

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install Trivy
echo "Installing Trivy..."
TRIVY_VERSION="0.50.1"
cd /tmp
curl -LO https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
sudo mv trivy /usr/local/bin/
rm trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz


# Install Helm
echo "Installing Helm..."
HELM_VERSION="v3.12.3"
curl -fsSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz
tar -zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm.tar.gz

echo "Setup complete! Please logout and log back in for Docker group changes to take effect."


echo "☁️ Installing AWS CLI v2 on Amazon Linux 2023..."

# Variables
AWS_CLI_ZIP="awscliv2.zip"
AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

# Clean up any previous downloads
rm -rf /tmp/aws /tmp/${AWS_CLI_ZIP}

# Download the AWS CLI v2 ZIP
curl -o "/tmp/${AWS_CLI_ZIP}" "${AWS_CLI_URL}"

# Unzip
unzip -q "/tmp/${AWS_CLI_ZIP}" -d /tmp

# Install
sudo /tmp/aws/install --update

# Clean up
rm -rf /tmp/aws /tmp/${AWS_CLI_ZIP}

# Verify installation
echo "✅ AWS CLI installed successfully:"
