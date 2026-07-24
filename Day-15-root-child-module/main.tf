module "name" {
    source = "./modules/EC2"
    ami = var.ami
    instance_type = var.instance_type

}

module "name1" {
    source = "./modules/S3"
    bucket = var.bucket

  
}

module "name2" {
    source = "./modules/VPC"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name

  
}

module "rds" {  #RDS module

  source = "./modules/RDS"


  vpc_cidr = "10.0.0.0/16"
  vpc_name = "RDS-Migrate-VPC"


  az1 = "us-west-2a"
  az2 = "us-west-2b"


  subnet1_cidr = "10.0.0.0/24"
  subnet2_cidr = "10.0.1.0/24"


  subnet1_name = "RDS-Migrate-Subnet1"
  subnet2_name = "RDS-Migrate-Subnet2"


  sg_name = "RDS-Migrate-SG"

  allowed_cidr = [
    "0.0.0.0/0"
  ]


  igw_name = "RDS-Migrate-IGW"

  route_table_name = "RDS-Migrate-RouteTable"


  db_subnet_group_name = "rds-migrate-subnet-group"


  storage_type      = "gp2"
  allocated_storage = 20

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  db_identifier = "mydatabasemigrate"


  username = "admin"

  password = "Cloud123"


  publicly_accessible = true


  replica_identifier = "mydbprateeksha-replica"

}

module "iam" {

  source = "./modules/IAM"


  user_name = var.user_name


  policy_arn = var.policy_arn

}