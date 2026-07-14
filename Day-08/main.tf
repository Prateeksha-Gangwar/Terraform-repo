# Terraform configuration to create a VPC, subnet, internet gateway, route table, security group, and an EC2 instance
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# aws subnet resource to create a subnet within the VPC
resource "aws_subnet" "name" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1"
  }
}

# aws internet gateway resource to create an internet gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
}

# aws route table resource to create a route table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }

  tags = {
    Name = "my-route-table"
  }
}

# aws route table association resource to associate the route table with the subnet
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

# aws security group resource to create a security group
resource "aws_security_group" "name" {
  name        = "my-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# aws instance resource to create an EC2 instance
resource "aws_instance" "name" {
  ami                    = "ami-01edba92f9036f76e" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.name.id]

  tags = {
    Name = "my-ec2-instance"
  }
}
