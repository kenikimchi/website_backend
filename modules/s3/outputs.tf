output "www_domain_name" {
  value = aws_s3_bucket.www.bucket_regional_domain_name
}

output "pipeline_bucket_id" {
  value = aws_s3_bucket.pipeline_bucket.id
}

output "pipeline_bucket_arn" {
  value = aws_s3_bucket.pipeline_bucket.arn
}

output "tfstate_bucket_arn" {
  value = aws_s3_bucket.tf_bucket.arn
}