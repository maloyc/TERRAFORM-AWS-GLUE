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


# Create an S3 bucket
resource "aws_s3_bucket" "s3-glue-mc-test678976" {
  bucket =  "s3-glue-mc-test678976"  # Ensure this bucket name is globally unique
  tags = {
    Name        = "s3-glue-mc-test678976"
    Environment = "Dev"
  }
}



# Create a folder in the S3 bucket     #########    #
resource "aws_s3_bucket_object" "my_folder1" {
  bucket = aws_s3_bucket.s3-glue-mc-test678976.id
  key    = "glue-data/"  # Folder name; ensure it ends with a '/'
  acl    = "private"     # Set the ACL as needed

  # Optional: You can also specify metadata if desired
  metadata = {
    description = "This is a folder for storing files."
  }
}

# Create a folder in the S3 bucket     #########    #
resource "aws_s3_bucket_object" "my_folder11" {
  bucket = aws_s3_bucket.s3-glue-mc-test678976.id
  key    = "glue-data/CDR_IN/"  # Folder name; ensure it ends with a '/'
  acl    = "private"     # Set the ACL as needed

}

resource "aws_s3_bucket_object" "my_folder12" {
  bucket = aws_s3_bucket.s3-glue-mc-test678976.id
  key    = "glue-data/CDR_out/"  # Folder name; ensure it ends with a '/'
  acl    = "private"     # Set the ACL as needed

}



################
# Outputs to display information
output "vpc_id" {
  value = aws_vpc.vpc-glue.id
}

output "subnet_id" {
  value = aws_subnet.subnet-glue.id
}

output "s3_id" {
  value = aws_s3_bucket.s3-glue-mc-test678976.id
}

#########################################################

