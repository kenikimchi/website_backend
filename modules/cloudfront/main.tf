# CloudFront distribution

locals {
  s3_origin_id = "s3OriginID"
}

resource "aws_cloudfront_origin_access_control" "primary" {
  name                              = "primary"
  origin_access_control_origin_type = var.origin_access_type
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.www.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.primary.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.root_object

  aliases = var.site_aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.root.arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}