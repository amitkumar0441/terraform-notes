# Output the bucket URL
output "s3_bucket_url" {
  value = "https://${aws_s3_bucket.mys3bucket.bucket}.s3.amazonaws.com"
}