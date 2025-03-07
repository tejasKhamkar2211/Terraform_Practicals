#use sudo while palning & applying
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "null_resource" "exec" {
  provisioner "local-exec" {
    command = "bash ${path.module}/docker.sh"
  }
}


provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "myimg" {
  name = "nginx:latest"
}

# Create a container
resource "docker_container" "my_cont" {
  image = docker_image.myimg.image_id
  name  = "container_sh"
}
