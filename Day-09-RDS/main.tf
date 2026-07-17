resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "RDS-Migrate-VPC"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true

}
resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.name.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.0.0/24"
  tags = {
    Name = "RDS-Migrate-Subnet1"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.name.id
  availability_zone = "us-west-2b"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "RDS-Migrate-Subnet2"
  }
}

resource "aws_security_group" "name" {
  name        = "RDS-Migrate-SG"
  description = "Security group for RDS migration"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
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


resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "RDS-Migrate-IGW"
  }
}

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "RDS-Migrate-RouteTable"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
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
  name = "rds-migrate-subnet-group"

  subnet_ids = [
    aws_subnet.sub1.id,
    aws_subnet.sub2.id
  ]

  #tags = {
  # Name = "RDS-Migrate-SubnetGroup" # Tags can contain uppercase letters
  #}
}

resource "aws_db_instance" "name" {
  storage_type           = "gp2"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "mydatabasemigrate"
  db_subnet_group_name   = aws_db_subnet_group.name.id
  vpc_security_group_ids = [aws_security_group.name.id]
  username               = "admin"
  password               = "Cloud123"
  skip_final_snapshot    = true
  publicly_accessible    = true
  maintenance_window     = "Mon:00:00-Mon:03:00"

}

resource "aws_db_instance" "mysql_read_replica" {
  identifier = "mydbprateeksha-replica"

  replicate_source_db = aws_db_instance.name.id

  instance_class = "db.t3.micro"

  publicly_accessible = true

  skip_final_snapshot = true

  depends_on = [
    aws_db_instance.name
  ]

  tags = {
    Name = "mysql-read-replica"
  }
}

