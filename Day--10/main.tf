resource "aws_instance" "name" {
  ami = "ami-01edba92f9036f76e"
  instance_type = "t2.micro"
  tags = {
    Name = "Server-Mirgation"
  }
   lifecycle {
    prevent_destroy = false
    ignore_changes = [ tags ]
    create_before_destroy = true
  }
}


