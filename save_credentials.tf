1. Using Environment Variables (Recommended)
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="your-region"

2. Using a Shared Credentials File (~/.aws/credentials)
[default]
aws_access_key_id = your-access-key
aws_secret_access_key = your-secret-key
region = your-region

provider "aws" {
  region = "us-east-1"
}

3. Using IAM Roles (for EC2 Instances)

4. Using Terraform Variables (Not Recommended for Security)
variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}


5. Using Terraform Cloud or Workspaces

7. Using the AWS Secrets Manager
data "aws_secretsmanager_secret_version" "my_secret" {
  secret_id = "my-secret-id"
}

provider "aws" {
  access_key = jsondecode(data.aws_secretsmanager_secret_version.my_secret.secret_string)["access_key"]
  secret_key = jsondecode(data.aws_secretsmanager_secret_version.my_secret.secret_string)["secret_key"]
}


