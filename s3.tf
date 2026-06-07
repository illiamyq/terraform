resource "aws_s3_bucket" "orders" {
  bucket        = "${var.project_name}-orders-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}