terraform {
required_version = "~> 1.1"
required_providers {
aws = {
version = "~>3.1"
}
}
}


provider "aws"{
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
variable "secret_key"{
    type = string
}
variable "access_key"{
    type = string
}

variable "region" {
    type = string
}

variable "key_pair"{
    type = string

}
variable "ami"{
    type = string
}

variable "key_pair_path" {
  description = "Path to the private key file"
  type        = string
}

resource "aws_instance" "userdata_ec2" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.userdata_sg.id]
  key_name = var.key_pair
  subnet_id = "subnet-0856db2e00d42f8a1"
  count = 1
  tags = {
    Name = "terraform_instance"
  }
  
provisioner "remote-exec" {
inline=[
"sudo dnf update -y",
"sudo dnf install nginx -y",
"sudo service nginx start",
"sudo touch /usr/share/nginx/html/index.html",
"echo 'IND vs AUS HERE INDIA WON THIS MATCH !!!' | sudo tee /usr/share/nginx/html/index.html > /dev/null"
]
}
connection {
type = "ssh"
private_key = file(var.key_pair_path)
user = "ec2-user"
host = self.public_ip
}
}

variable "vpc_id"{
    type = string
}
resource "aws_security_group" "userdata_sg" {
  name        = "userData_terraform"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      =  var.vpc_id


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}

output "ip"{
    value = aws_instance.userdata_ec2[0].public_ip
}
