terraform {
  backend "s3" {
    bucket         = "myuniquebuckteasthedataofcompany"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
   # dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}