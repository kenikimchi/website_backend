output "www_domain_name" {
  value = aws_s3_bucket.www.bucket_regional_domain_name
}