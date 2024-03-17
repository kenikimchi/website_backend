# S3 buckets and policies

resource "aws_s3_bucket" "root" {
  bucket        = var.domain_name
  force_destroy = true
}

resource "aws_s3_bucket" "www" {
  bucket        = "www.${var.domain_name}"
  force_destroy = true
}

resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "pipeline_bucket"
}

resource "aws_s3_bucket" "lambda_dependencies" {
  bucket = "lambda_dependencies"
}

resource "aws_s3_bucket_website_configuration" "root" {
  bucket = aws_s3_bucket.root.id

  redirect_all_requests_to {
    host_name = aws_s3_bucket.www.id
  }
}

# Bucket Policies
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = aws_s3_bucket.www.id
  policy = data.aws_iam_policy_document.cloudfront_access.json
}

data "aws_iam_policy_document" "cloudfront_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "pipeline_access" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  policy = data.aws_iam_policy_document.pipeline_access.json
}

data "aws_iam_policy_document" "pipeline_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${aws_s3_bucket.pipeline_bucket.arn}/*"]
  }
}