resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e2"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2-SERVER-INSTANCE"
}

 lifecycle {
   create_before_destroy = true
  }
  lifecycle {
    prevent_destroy = true
  }
  lifecycle {
    ignore_changes = [tags]
  }
}
