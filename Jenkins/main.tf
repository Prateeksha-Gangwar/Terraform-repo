resource "aws_instance" "name" {
  ami           = "ami-0354c98ae10b02961"
  instance_type = "t2.micro"

  tags = {
    Name = "CloudINIDevopsecops"
  }
}
