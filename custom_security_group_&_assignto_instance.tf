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
  vpc_security_group_ids = [aws_security_group.my_sg.id]
tags = {
    Name = "testing sg"
  }
}

resource "aws_security_group" "my_sg" {
  name        = "testing_terraform"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-02c99395c4b6dcdc3"


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
