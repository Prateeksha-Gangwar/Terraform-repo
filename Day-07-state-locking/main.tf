resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform-Instance"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPCCCCC"
  }
}



