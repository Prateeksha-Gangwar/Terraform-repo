resource "aws_instance" "name"{
    ami = "ami-0b826bb6d96d2afe4"
    instance_type = "t2.micro"
    for_each = toset(var.tags)
    tags = {
        Name = each.key
    }

}