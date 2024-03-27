resource "aws_codebuild_project" "tfbuild" {

  count = length(var.build_stages)

  name         = "${var.project_name}-${var.build_stages[count.index]}"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = var.artifacts_type
  }

  environment {
    compute_type                = var.environment_compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    privileged_mode             = true
    image_pull_credentials_type = var.image_pull_credentials_type
  }

  logs_config {

    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = 1
    buildspec       = "./buildspec/tf-${var.build_stages[count.index]}.yaml"
  }
}

#Permission
data "aws_iam_policy_document" "codebuild_role" {
  statement {
    actions   = ["logs:*"]
    resources = ["arn:aws:logs:*"]
    effect    = "Allow"
  }

  # statement {
  #   actions = [
  #     "s3:List*",
  #     "s3:Get*",
  #     "s3:Put*",
  #     "s3:DeleteObject",
  #     "s3:DeleteObjectVersion"
  #   ]
  #   resources = [
  #     "${var.pipeline_bucket_arn}/*",
  #     var.pipeline_bucket_arn,
  #     var.tfstate_bucket_arn,
  #     "${var.tfstate_bucket_arn}/*"

  #   ]
  #   effect = "Allow"
  # }

  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "dynamodb:BatchGetItem",
  #     "dynamodb:Query",
  #     "dynamodb:PutItem",
  #     "dynamodb:UpdateItem",
  #     "dynamodb:DeleteItem",
  #     "dynamodb:BatchWriteItem",
  #     "dynamodb:Describe*",
  #     "dynamodb:Get*",
  #     "dynamodb:List*"
  #   ]
  #   resources = ["${var.tfstate_table_arn}"]
  # }

  statement {
    effect    = "Allow"
    actions   = [
      "codestar-connections:UseConnection",
      "codestar-connections:GetConnection",
      "codestar-connections:List*"
    ]
    resources = [var.codestarconnection_github_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "apigateway:*",
      "dynamodb:*",
      "cloudwatch:*",
      "route53:*",
      "route53domains:*",
      "cloudfront:*",
      "s3:*",
      "sns:*",
      "ec2:*",
      "iam:*",
      "acm:*",
      "codebuild:*",
      "codecommit:*",
      "codepipeline:*",
      "events:*",
      "lambda:*",
      "codestar-notifications:*",
      "cloudformation:*",
      "kms:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = var.codebuild_policy_name
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_role.json
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = var.codebuild_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}