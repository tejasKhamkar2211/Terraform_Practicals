terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~>3.1"
    }
  }
}

provider "aws"{
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2"  {
  ami           = "ami-0d682f26195e9ec0f"
  instance_type = "t2.micro"
tags = {
    Name = "created by terraform"
  }
}
