resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-SERVER-INSTANCE"
}

 lifecycle {
   create_before_destroy = true
    prevent_destroy = true
    ignore_changes = [tags]
  }
}
