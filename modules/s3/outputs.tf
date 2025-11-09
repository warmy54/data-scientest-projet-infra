output "bucket_name" {
  description = "Nom du bucket WordPress"
  value       = aws_s3_bucket.wordpress.bucket
}