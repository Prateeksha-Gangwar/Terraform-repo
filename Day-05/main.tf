
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "subnet2"
  }
}




resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "myweb_sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "name" {
  ami                    = "ami-0fd6b4bfb40773c2d"
  instance_type          = "t2.medium"
  associate_public_ip_address = true
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Cloud-Computing-Instance"
  }
}

resource "aws_instance" "name2" {
  ami                    = "ami-0fd6b4bfb40773c2d"
  instance_type          = "t2.medium"
  associate_public_ip_address = true
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Cloud-Computing-Instance2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-gateway"
  }
}



resource "aws_route_table" "name" {
  vpc_id = aws_vpc.main.id
tags = {
    Name = "my-route-table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.name.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.name.id
}
