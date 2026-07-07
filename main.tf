terraform {
  required_version = ">= 1.15.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to the region where your AMI exists
}

resource "aws_instance" "example" {
  ami           = "ami-06067086cf86c58e6"
  instance_type = "t1.medium"

  tags = {
    Name = "webserver"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

output "private_ip" {
  value = aws_instance.example.private_ip
}
