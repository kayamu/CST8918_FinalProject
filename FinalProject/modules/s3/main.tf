variable "project_name" { type = string }

resource "aws_s3_bucket" "app_data" {
  bucket        = "${var.project_name}-app-data"
  force_destroy = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_data.bucket
}
