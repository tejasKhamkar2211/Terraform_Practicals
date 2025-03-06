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
resource "aws_s3_bucket" "my_bucket" {
  bucket = "aclenableram522025"
}
output "s3_bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
  description = "The ARN of the S3 bucket"
}
