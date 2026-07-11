resource "aws_instance" "name" {
    ami           = var.ami
    instance_type = 
    tags = {
        Name = var.tags
    }
  
}