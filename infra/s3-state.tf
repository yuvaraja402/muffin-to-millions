module "s3-state-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.15.4"

  region = var.region

  bucket = "${var.project_name}-${var.s3_state_bucket}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}