resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"
  instance_type = "t2.medium"
  tags = {
    Name = "Terraform-Instance-ready-template"
  }
}




