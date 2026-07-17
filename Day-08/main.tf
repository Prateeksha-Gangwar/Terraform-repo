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

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Subnet-2-private"
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

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.name.id

  tags = {
    Name = "my-nat-gateway"
  }

  depends_on = [aws_internet_gateway.name]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "my-private-route-table"
  }
}

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.name.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# aws instance resource to create an EC2 instance
resource "aws_instance" "name" {
  ami                    = "ami-0fd6b4bfb40773c2d" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.name.id]

  tags = {
    Name = "my-ec2-instance"
  }
}

resource "aws_instance" "private" {
  ami                    = "ami-0fd6b4bfb40773c2d" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.name.id]

  tags = {
    Name = "my-private-ec2-instance"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "name" {
  function_name = "my-lambda-function-WILP"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "python3.14"

  filename = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      foo = "bar"
    }
  }

  tags = {
    Name = "my-lambda-function"
  }
}
