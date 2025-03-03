terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~>3.1"
    }
  }
}


variable "my_region" {
    type = string
}

variable "my_vpc_id" {
    type = string
}

variable "my_subnet_id" {
    type = string
}
variable "my_instance_type" {
    type = string
}

variable "my_ami" {
    type = string
}


provider "aws"{
    region = var.my_region
  
}



resource "aws_instance" "my_ec2"  {
  ami           = var.my_ami
  instance_type = var.my_instance_type
  subnet_id     = var.my_subnet_id
  key_name      = "mumbaiserverkey"
tags = {
    Name = "learning variables"
  }
}

output "ip" {
    value = aws_instance.my_ec2.public_ip
}

output "instance_state" {
    value = aws_instance.my_ec2.instance_state
}
