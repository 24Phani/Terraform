terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.23.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "instance1" {
  ami             = "ami-0c802847a7dd848c0"
  instance_type   = "t2.micro"
  key_name        = "EC2"
  vpc_security_group_ids = [aws_security_group.default_myfirst.id,]
  tags = {
    Name = "tfInstance"
  }
}
resource "aws_security_group" "default_myfirst" {
  name = "myfirstsecuritygroup"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "myfirstsecuritygroup"
  }
}