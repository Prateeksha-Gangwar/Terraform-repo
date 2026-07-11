resource "aws_instance" "name" {
    ami           = var.var1
    instance_type = var.var2
    tags = {
        Name = var.var3
    }
  
}