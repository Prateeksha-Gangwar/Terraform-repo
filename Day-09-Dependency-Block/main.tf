resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
   
}
resource "aws_s3_bucket" "name" {
    bucket = "rds-migrate-bucketttttttttnnnnnn"
    depends_on = [aws_vpc.name]
}