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
  bucket = var.pipeline_bucket
}

resource "aws_s3_bucket" "lambda_dependencies" {
  bucket = var.lambda_dependencies
}

resource "aws_s3_bucket_website_configuration" "root" {
  bucket = aws_s3_bucket.root.id

  redirect_all_requests_to {
    host_name = aws_s3_bucket.www.id
    protocol  = "https"
  }
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  index_document {
    suffix = "home"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "www" {
  bucket = aws_s3_bucket.www.id
}

# Logging Bucket
resource "aws_s3_bucket" "logging_bucket" {
  bucket = var.logging_bucket_name
}

# State file bucket
resource "aws_s3_bucket" "tf_bucket" {
  bucket = var.tf_bucket_name
}

resource "aws_s3_object" "terraform_folder" {
  bucket = aws_s3_bucket.tf_bucket.id
  key    = "terraform.tfstate"
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
      type        = "AWS"
      identifiers = [var.codepipeline_role_arn]
    }

    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [aws_s3_bucket.pipeline_bucket.arn, "${aws_s3_bucket.pipeline_bucket.arn}/*"]
  }
}

# Policy for Terraform bucket
resource "aws_s3_bucket_acl" "tf_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.tf_bucket_acl_ownership]
  bucket     = aws_s3_bucket.tf_bucket.id
  acl        = "private"
}

resource "aws_s3_bucket_ownership_controls" "tf_bucket_acl_ownership" {
  bucket = aws_s3_bucket.tf_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_bucket_access" {
  bucket                  = aws_s3_bucket.tf_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}