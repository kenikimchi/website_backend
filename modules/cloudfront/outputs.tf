output "s3_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_distribution_hosted_zoned_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "s3_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}