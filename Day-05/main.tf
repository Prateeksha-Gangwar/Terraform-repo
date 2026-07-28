resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}
resource "aws_subnet" "name" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "sup"
  }
}
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "IG"
  }
}
resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

}
resource "aws_route_table_association" "dev_route_table_association" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.dev_route_table.id
}
resource "aws_security_group" "dev_SG" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "mysq"
  }
  ingress {
Python

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
resource "aws_instance" "EC2-tera" {
  ami                         = "ami-01edba92f9036f76e"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.name.id
  vpc_security_group_ids      = [aws_security_group.dev_SG.id]
  tags = {
    Name = "Ec2-Terra"
  }
}
resource "aws_subnet" "sub-2" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "nayak"
  }
}
resource "aws_eip" "dev_nat" {
  domain = "vpc"
}
resource "aws_nat_gateway" "dev_nat" {
  allocation_id = aws_eip.dev_nat.id
  subnet_id     = aws_subnet.name.id
  tags = {
    Name = "Mynat"
  }
  depends_on = [aws_internet_gateway.dev-igw]
}
#availability_mode = "regional"
resource "aws_route_table" "dev_route_table2" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "RT2"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev_nat.id
  }
}
resource "aws_route_table_association" "dev_route_table_association2" {
  subnet_id      = aws_subnet.sub-2.id
  route_table_id = aws_route_table.dev_route_table2.id
}
resource "aws_instance" "EC2-tera2" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t2.micro"
  subnet_id              = aws_subnet.sub-2.id
  vpc_security_group_ids = [aws_security_group.dev_SG.id]
  tags = {
    Name = "Ec2-pop"
  }
}
resource "aws_vpc" "name2" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "pratu"
  }
}
resource "aws_iam_user" "user1" {
  name = "Roji"
}
