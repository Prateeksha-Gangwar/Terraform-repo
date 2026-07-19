resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "My-VPC11"
  }
}
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My-IGW11"
  }
}
resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-11"
  }
}
resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-22"
  }
}
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT11"
  }
}
resource "aws_route_table_association" "subnet1" {

  subnet_id = aws_subnet.public1.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "alb_sg" {

  name = "alb-security-group11"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ec2_sg" {

  name = "ec2-security-group11"

  vpc_id = aws_vpc.main.id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "web1" {

  ami = "ami-01edba92f9036f76e"

  instance_type = "t2.micro"

  subnet_id = aws_subnet.public1.id

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Welcome to HYDERABAD" > /var/www/html/index.html
EOF

  tags = {
    Name = "MY-SERVER"
  }
}
resource "aws_lb_target_group" "tg" {

  name = "my-target-group111"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {

    path = "/"

    protocol = "HTTP"

    healthy_threshold = 3

    unhealthy_threshold = 3

    interval = 30
  }
}
resource "aws_lb" "alb" {

  name = "my-alb-load"

  internal = false

  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}
resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "web1" {

  target_group_arn = aws_lb_target_group.tg.arn

  target_id = aws_instance.web1.id

  port = 80
}