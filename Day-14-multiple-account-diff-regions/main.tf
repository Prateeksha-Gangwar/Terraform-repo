resource "aws_s3_bucket" "name" {
  bucket   = "ycvbhjnklm"
  provider = aws.dev-account

}

resource "aws_s3_bucket" "sd" {
  bucket   = "ycvbhjdddnklm"
  provider = aws.test-account

}

# resource "aws_instance" "dev" {
#   ami           = "ami-004f790b835b26145"
#   instance_type = "t2.micro"
#   provider      = aws.test-account
#   tags = {
#     Name = "EC211"
#   }
# }
# resource "aws_instance" "test" {
#   ami           = "ami-077d4c57ecdca57e6"
#   provider      = aws.dev-account
#   instance_type = "t2.micro"
#   tags = {
#     Name = "EC2-22"
#   }
# }