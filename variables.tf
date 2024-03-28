# S3
variable "domain_name" {
  description = "Root domain of the website"
  type        = string
}

variable "pipeline_bucket" {
  description = "Name of the pipeline bucket"
  type        = string
}

variable "tf_bucket_name" {
  description = "Name of the Terraform bucket"
  type        = string
}

variable "lambda_dependencies" {
  description = "Name of the bucket that holds Lambda dependencies"
  type        = string
}

variable "logging_bucket_name" {
  description = "Name of the logging bucket"
  type        = string
}

# CloudFront
variable "origin_access_type" {
  description = "Origin access type"
  type        = string
}

variable "root_object" {
  description = "The file for the root object such as index"
  type        = string
}

variable "site_aliases" {
  description = "Alternate site address aliases"
  type        = list(string)
}

variable "geo_restriction_locations" {
  description = "Locations allowed by CloudFront"
  type        = list(string)
}

variable "price_class" {
  description = "The price class of the CloudFront distribution"
  type        = string
}

# Route53
variable "private_zone" {
  description = "Certificate private zone or not"
  type        = bool
  default     = false
}

# CodeCommit
variable "source_repo_name" {
  description = "The name of the source repository"
  type        = string
}

variable "source_repo_branch" {
  description = "Repository branch of the source repository"
  type        = string
}

variable "repo_approvers_arn" {
  description = "ARN of the approver"
  type        = string
}

# CodeBuild
variable "build_stages" {
  description = "Stages used in the pipeline"
  type        = list(string)
}

variable "project_name" {
  description = "Name of the pipeline project"
  type        = string
}

variable "artifacts_type" {
  description = "Type of artifact outputed by CodeBuild"
  type        = string
}

variable "environment_compute_type" {
  description = "Information about the compute resources CodeBuild will use"
  type        = string
}

variable "environment_image" {
  description = "The specified image of the CodeBuild environment"
  type        = string
}

variable "environment_type" {
  description = "Type of build environemnt to use for builds"
  type        = string
}

variable "image_pull_credentials_type" {
  description = "Type of credentials CodeBuild will use to pull image"
  type        = string
}

variable "source_type" {
  type    = string
  default = "CODEPIPELINE"
}

variable "source_location" {
  type = string
}

variable "codebuild_policy_name" {
  type = string
}

variable "codebuild_iam_role_name" {
  type = string
}

# CodePipeline
variable "stages" {
  description = "Stages in the pipeline"
  type        = list(map(any))
}

variable "full_repo_id" {
  description = "The full repository id"
  type        = string
}

variable "codepipeline_iam_role_name" {
  description = "Name of the pipeline role"
  type        = string
}

variable "source_provider" {
  type = string
}

# DynamoDB
variable "tfstate_table_name" {
  description = "Name of the dynamodb table containing the tfsate lock data"
  type        = string
}

variable "branch_name" {
  description = "The repository branch for the source stage to pull from"
  type        = string
}

# CloudWatch
variable "pipeline_log_group_name" {
  description = "The name of the log group for CodePipeline"
  type        = string
}

variable "pipeline_log_stream_name" {
  description = "The name of the log stream for CodePipeline"
  type        = string
}

# Lambda
variable "lambda_function_name" {
  type = string
}