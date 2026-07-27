resource "aws_s3_bucket" "dev_bucket" {
  provider = aws.dev_account

  bucket = "bucketdevhbhdfbdnbcbhhdfbmkshhhhhhhhhhh"
}

resource "aws_s3_bucket" "test_bucket" {
  provider = aws.test_account

  bucket = "buckettestshgsgfjyrunbnchpppppppppppppppp"
}

resource "aws_instance" "dev_server" {
    ami = "ami-004f790b835b26145"
    instance_type = "t2.micro"
    provider = aws.dev_account
    tags = {
      Name = "Dev"
    }
  
}


resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Test-VPC"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id = aws_vpc.test_vpc.id

  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Test-Subnet"
  }
}

resource "aws_security_group" "test_sg" {
  name   = "test-sg"
  vpc_id = aws_vpc.test_vpc.id

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

  tags = {
    Name = "Test-SG"
  }
}

resource "aws_instance" "test_server" {
  ami           = "ami-077d4c57ecdca57e6"
  instance_type = "t2.medium"

  subnet_id = aws_subnet.test_subnet.id

  vpc_security_group_ids = [
    aws_security_group.test_sg.id
  ]
 provider = aws.dev_account
  tags = {
    Name = "Test"
  }
}