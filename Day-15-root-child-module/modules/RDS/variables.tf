variable "vpc_cidr" {}

variable "vpc_name" {}

variable "az1" {}

variable "az2" {}

variable "subnet1_cidr" {}

variable "subnet2_cidr" {}

variable "subnet1_name" {}

variable "subnet2_name" {}

variable "sg_name" {}

variable "allowed_cidr" {
  type = list(string)
}

variable "igw_name" {}

variable "route_table_name" {}

variable "db_subnet_group_name" {}

variable "storage_type" {}

variable "allocated_storage" {}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {}

variable "db_identifier" {}

variable "username" {}

variable "password" {
  sensitive = true
}

variable "publicly_accessible" {}

variable "replica_identifier" {}