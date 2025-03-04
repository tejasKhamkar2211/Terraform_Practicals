# Steps to create a Load Balancer & attach it to an EC2 instance

# 1) Create an EC2 instance and a security group for the EC2 instance.
# 2) Create a Load Balancer and a security group for the Load Balancer.
# 3) Create a Target Group and configure the health check.
# 4) Attach the Target Group to the EC2 instance.
# 5) Create a Listener for the Load Balancer.


terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~>3.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "my_ec2"  {
  ami           = "ami-0d682f26195e9ec0f"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0f8e06a916abb2b98"]
  key_name = "mumbaiserverkey"
  tags = {
    Name = "loadBalancer_instance"
  }

}

#create a loadbalancer
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-075e65a38e6fe6179", "subnet-08e4db8f1926c1a65"]

  enable_deletion_protection = false


}
#create target group
resource "aws_lb_target_group" "ec2_tg" {
  name     = "ec2targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-02c99395c4b6dcdc3"


   health_check {
    enabled  = true
    interval = 10 # health check interval
    protocol = "HTTP"  
    timeout  = 5  # timeout seconds
    path     = "/" # your health check path
  }
}

#attach to ec2 instance
resource "aws_lb_target_group_attachment" "my_ec2" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.my_ec2.id
  port             = 80


 
}
#create a listener 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }
}




resource "aws_security_group" "lb_sg" {
  name        = "tf_load_balancer"
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
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


output "lb_dns_name" {
  value = aws_lb.test.dns_name
}
