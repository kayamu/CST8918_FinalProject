variable "project_name" { type = string }

resource "aws_s3_bucket" "app_data" {
  bucket        = lower(replace(var.project_name, "_", "-"))
  force_destroy = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_data.bucket
}
