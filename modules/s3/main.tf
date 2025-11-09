resource "aws_s3_bucket" "wordpress" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "wordpress" {
  bucket = aws_s3_bucket.wordpress.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "wordpress" {
  bucket = aws_s3_bucket.wordpress.id

  versioning_configuration {
    status = "Enabled"
  }
}