##### AWS credential defined in Environment variable
##### AWS_ACCESS_KEY_ID
##### AWS_SECRET_ACCESS_KEY

# main.tf

# AWS provider - Region = USA East OHI
provider "aws" {
  region = "us-east-2" 
}

# Create a VPC
resource "aws_vpc" "vpc-glue" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-glue"
  }
}

# Create a private subnet - I am choseing 2a AZ. 
resource "aws_subnet" "subnet-glue" {
  vpc_id                  = aws_vpc.vpc-glue.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "subnet-glue"
  }
}




################
# Outputs to display information
output "vpc_id" {
  value = aws_vpc.vpc-glue.id
}

output "subnet_id" {
  value = aws_subnet.subnet-glue.id
}

#########################################################

