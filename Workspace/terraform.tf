 #   delete    Delete a workspace
 #   list      List Workspaces
 #   new       Create a new workspace
 #   select    Select a workspace
 #   show      Show the name of the current workspace
 #create required workspace like dev, prod, test.
terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~>3.1"
    }
  }
}

provider "aws"{
  region = var.my_region
}

resource "aws_instance" "my_ec2"  {
  ami           = var.my_ami
  instance_type = lookup (var.my_inst_type,terraform.workspace)
tags = {
    Name = "learning_workspace"
  }
}
