variable "domain_name" {
  description = "Root domain of the website"
  type        = string
}

variable "pipeline_bucket" {
  description = "Name for the pipeline bucket"
  type        = string
}

variable "lambda_dependencies" {
  description = "Name for the dependencies for Lambda functions"
  type        = string
}

variable "tf_bucket_name" {
  description = "value"
  type        = string
}

variable "logging_bucket_name" {
  description = "Name of the logging bucket"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "Role arn used by codepipeline"
  type        = string
}

variable "codebuild_role_arn" {
  description = "Role arn used by codebuild"
  type        = string
}