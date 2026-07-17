module "s3_bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git"

  bucket = "mybucketdatapalanrdconnect"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}