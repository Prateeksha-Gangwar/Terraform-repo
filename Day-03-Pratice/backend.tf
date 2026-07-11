terraform {
  backend "s3" {
    bucket = "datastoragebucketinsidetfstatefiele "
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}