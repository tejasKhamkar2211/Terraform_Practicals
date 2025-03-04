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

resource "aws_sns_topic" "user_updates" {
  name = "terraform"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.user_updates.arn
  protocol  = "email"
  endpoint  = "khamkartejas19@gmail.com"  # Change to your email
}

output "sns_topic_arn" {
  value = aws_sns_topic.user_updates.arn
}
