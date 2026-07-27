provider "aws" {
  alias   = "dev_account"
  profile = "dev"
  region  = "us-east-1"
}

provider "aws" {
  alias   = "test_account"
  profile = "test"
  region  = "us-west-2"
}