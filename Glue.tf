##### AWS credential defined in Environment variable
##### AWS_ACCESS_KEY_ID
##### AWS_SECRET_ACCESS_KEY

# main.tf

# AWS provider - Region = USA East OHI
provider "aws" {
  region = "us-east-2" 
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-private-vpc"
  }
}

# Create a private subnet - I am choseing 2a AZ. 
resource "aws_subnet" "my_private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"  
  map_public_ip_on_launch = false
  tags = {
    Name = "my-private-subnet"
  }
}

# Security group for EC2 instance
resource "aws_security_group" "my_instance_sg" {
  vpc_id = aws_vpc.my_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"   # ALL
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"   # ALL
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access (adjust as needed)
  }
  tags = {
    Name = "my-instance-security-group"
  }
}

# EC2 instance configuration
resource "aws_instance" "my_instance" {
  ami           = "ami-09efc42336106d2f2"  # Amazon Linux 2 AMI (Free Tier)
  instance_type = "t2.micro" # Free Tier
  subnet_id     = aws_subnet.my_private_subnet.id
  #security_groups = [aws_security_group.my_instance_sg.name]
 # key_name       = "my-key-pair"  # We have to create the key pair if we want to use this. For now not using. 

  tags = {
    Name = "my-ec2-instance"
  }
}


# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-2024-4948"  # Ensure this bucket name is globally unique
  tags = {
    Name        = "my-s3-bucket"
    Environment = "Dev"
  }
}

# Create a folder in the S3 bucket     #########    #
resource "aws_s3_bucket_object" "my_folder" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "my-folder/"  # Folder name; ensure it ends with a '/'
  acl    = "private"     # Set the ACL as needed

  # Optional: You can also specify metadata if desired
  metadata = {
    description = "This is a folder for storing files."
  }
}



################
# Outputs to display information
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.my_private_subnet.id
}

output "instance_id" {
  value = aws_instance.my_instance.id
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}
#########################################################

