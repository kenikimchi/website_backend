# Kendrick Kim

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

# Modules
module "s3" {
  source = "./modules/s3"

  domain_name           = var.domain_name
  pipeline_bucket       = var.pipeline_bucket
  lambda_dependencies   = var.lambda_dependencies
  tf_bucket_name        = var.tf_bucket_name
  logging_bucket_name   = var.logging_bucket_name
  codepipeline_role_arn = module.codepipeline.codepipeline_role_arn
}

module "cloudfront" {
  source = "./modules/cloudfront"

  site_aliases              = var.site_aliases
  price_class               = var.price_class
  origin_access_type        = var.origin_access_type
  geo_restriction_locations = var.geo_restriction_locations
  root_object               = var.root_object
  www_domain_name           = module.s3.www_domain_name
  root_certificate_arn      = module.route53.root_certificate_arn
}

module "route53" {
  source = "./modules/route53"

  domain_name                     = var.domain_name
  private_zone                    = false
  s3_distribution_domain_name     = module.cloudfront.s3_distribution_domain_name
  s3_distribution_hosted_zoned_id = module.cloudfront.s3_distribution_hosted_zoned_id
}

module "codecommit" {
  source = "./modules/codecommit"

  source_repository_name   = var.source_repo_name
  source_repository_branch = var.source_repo_branch
  repo_approvers_arn       = var.repo_approvers_arn
}

module "codebuild" {
  depends_on = [module.codecommit]
  source     = "./modules/codebuild"

  environment_image             = var.environment_image
  artifacts_type                = var.artifacts_type
  image_pull_credentials_type   = var.image_pull_credentials_type
  build_stages                  = var.build_stages
  environment_type              = var.environment_type
  environment_compute_type      = var.environment_compute_type
  source_location               = var.source_location
  project_name                  = var.project_name
  codebuild_policy_name         = var.codebuild_policy_name
  codebuild_iam_role_name       = var.codebuild_iam_role_name
  pipeline_bucket_arn           = module.s3.pipeline_bucket_arn
  tfstate_table_arn             = module.dynamodb.tfstate_table_arn
  codestarconnection_github_arn = module.codecommit.codestarconnection_github_arn
}

module "codepipeline" {
  depends_on = [module.codebuild]
  source     = "./modules/codepipeline"

  stages                        = var.stages
  project_name                  = var.project_name
  full_repo_id                  = var.full_repo_id
  pipeline_bucket_arn           = module.s3.pipeline_bucket_arn
  source_repository_name        = var.source_repo_name
  codepipeline_iam_role_name    = var.codepipeline_iam_role_name
  pipeline_bucket_id            = module.s3.pipeline_bucket_id
  kms_key_arn                   = module.kms.kms_key_arn
  codestarconnection_github_arn = module.codecommit.codestarconnection_github_arn
}

# DynamoDB
module "dynamodb" {
  source = "./modules/dynamodb"

  tfstate_table_name = var.tfstate_table_name
}

# CloudWatch
module "cloudwatch" {
  source = "./modules/cloudwatch"

  pipeline_log_group_name  = var.pipeline_log_group_name
  pipeline_log_stream_name = var.pipeline_log_stream_name
}

# KMS
module "kms" {
  source = "./modules/kms"

  codepipeline_role_arn = module.codepipeline.codepipeline_role_arn
}