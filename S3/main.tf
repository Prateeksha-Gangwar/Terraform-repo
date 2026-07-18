module "s3_bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git"

  bucket = "mybucketdatapalanrdconnect"
  acl    = "private"


  versioning = {
    enabled = true
  }
}