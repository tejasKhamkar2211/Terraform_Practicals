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
  key_name      = aws_key_pair.kp.key_name
tags = {
    Name = "testing sg"
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "tformmumbai"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.kp.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
  file_permission = "0400"
}

