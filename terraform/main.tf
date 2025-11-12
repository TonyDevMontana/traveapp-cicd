terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "travel_app_security_group" {
  name        = "terraform-security-group"
  description = "terraform-security-group"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow access to port 9100 for node exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow access to port 9100 for node exporter"
    from_port   = 9256
    to_port     = 9256
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow access to port 80(http)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "travel_app_server" {
  ami           = "ami-0360c520857e3138f" 
  instance_type = "t2.micro"   
  
  key_name      = "endeavour" 
  
  vpc_security_group_ids = [aws_security_group.travel_app_security_group.id]

  tags = {
    Name = "Terraform EC2"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.travel_app_server.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.travel_app_server.id
}
