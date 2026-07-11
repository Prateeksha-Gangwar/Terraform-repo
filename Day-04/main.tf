resource "aws_instance" "name" {
  ami                    = "ami-002192a70217ac181"
  instance_type          = "t2.medium"
  associate_public_ip_address = true
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Cloud-Computing-Instance"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

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
