
terraform {
  backend "s3" {
    bucket = "llajddhfdjee"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}