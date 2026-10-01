# Output bucket name
output "bucket_name" {
  value = aws_s3_bucket.remote_s3.bucket
}