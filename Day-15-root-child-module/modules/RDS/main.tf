resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.name.id
  availability_zone = var.az1
  cidr_block        = var.subnet1_cidr

  tags = {
    Name = var.subnet1_name
  }
}


resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.name.id
  availability_zone = var.az2
  cidr_block        = var.subnet2_cidr

  tags = {
    Name = var.subnet2_name
  }
}


resource "aws_security_group" "name" {
  name        = var.sg_name
  description = "Security group for RDS migration"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = var.igw_name
  }
}


resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }

  tags = {
    Name = var.route_table_name
  }
}


resource "aws_route_table_association" "sub1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.name.id
}


resource "aws_route_table_association" "sub2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.name.id
}


resource "aws_db_subnet_group" "name" {

  name = var.db_subnet_group_name

  subnet_ids = [
    aws_subnet.sub1.id,
    aws_subnet.sub2.id
  ]
}


resource "aws_db_instance" "name" {

  storage_type         = var.storage_type
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  identifier           = var.db_identifier

  db_subnet_group_name = aws_db_subnet_group.name.id

  vpc_security_group_ids = [
    aws_security_group.name.id
  ]

  username = var.username
  password = var.password

  skip_final_snapshot = true

  publicly_accessible = var.publicly_accessible
}


resource "aws_db_instance" "mysql_read_replica" {

  identifier = var.replica_identifier

  replicate_source_db = aws_db_instance.name.id

  instance_class = var.instance_class

  publicly_accessible = var.publicly_accessible

  skip_final_snapshot = true

  depends_on = [
    aws_db_instance.name
  ]
}