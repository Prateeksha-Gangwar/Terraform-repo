resource "aws_instance" "name" {
   ami = "ami-01edba92f9036f76e"
   instance_type = "t2.micro"
   tags = {
     Name = "Import-server"
   }
}


resource "aws_s3_bucket" "name" {
  bucket = "buckeasdfghhkfsjskfnmccwertyu"
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.name.id

  versioning_configuration {
    status = "Enabled"    # ← Versioning disable
  }
}