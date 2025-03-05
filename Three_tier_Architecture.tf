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
#vpc creation
resource "aws_vpc" "three_tier_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
  }
}
#internet getway creation
resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "3tier_igw"
  }
}
#subnet creation
resource "aws_subnet" "web_subnet" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "three_tier_web_subnet"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "three_tier_app_subnet"
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id     = aws_vpc.three_tier_vpc.id
  cidr_block = "10.0.2.0/24"
 availability_zone = "ap-south-1c"

  tags = {
    Name = "three_tier_db_subnet"
  }
}
#aws route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }

  
  tags = {
    Name = "three_tier_public_rt"
  }
}

resource "aws_route_table" "privet_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id
  tags = {
    Name = "three_tier_privet_rt"
  }
}

#route table association
resource "aws_route_table_association" "web_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "app_association" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.privet_rt.id
}
resource "aws_route_table_association" "db_association" {
  subnet_id      = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.privet_rt.id
}

#create security groups
resource "aws_security_group" "web_sg" {
  name        = "three_tier_web_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.three_tier_vpc.id


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
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "three_tier_app_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.three_tier_vpc.id


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
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["10.0.0.0/24"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "three_tier_db_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.three_tier_vpc.id


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
    cidr_blocks      = ["10.0.0.0/16"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["10.0.1.0/24"]
  }
}

resource "aws_instance" "web_ec2" {
  ami                    = "ami-0d682f26195e9ec0f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = "mumbaiserverkey"
  subnet_id = aws_subnet.web_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "web_instance"
  }
}
resource "aws_instance" "app_ec2" {
  ami                    = "ami-0d682f26195e9ec0f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name = "mumbaiserverkey"
  subnet_id = aws_subnet.app_subnet.id
  associate_public_ip_address = false
  tags = {
    Name = "app_instance"
  }
}
#create db_instancd
resource "aws_db_instance" "db_rds" {
  allocated_storage    = 10
  name                 = "three_tire_db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "root"
  password             = "Satara123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_gp.name
}
resource "aws_db_subnet_group" "my_db_subnet_gp" {
  name       = "threetierdb"
  subnet_ids = [aws_subnet.app_subnet.id, aws_subnet.db_subnet.id]

  tags = {
    Name = "threetierdb"
  }
}
