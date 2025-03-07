#!/bin/bash
sudo yum  update -y
sudo yum install docker.io -y
sudo service docker start
sudo systemctl enable docker.service
