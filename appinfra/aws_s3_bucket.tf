resource "aws_s3_bucket" "jwappupload" {
  bucket = "jwupload-${local.full_name}"
  force_destroy = true # Would not normally put Force Destroy Var, but for sake clean destroy for this demo

  versioning {
    enabled = true
  }

}