variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "build_stages" {
  description = "List of Names of the CodeBuild projects to be created"
  type        = list(string)
}

variable "environment_compute_type" {
  description = "Information about the compute resources the build project will use"
  type        = string
}

variable "environment_image" {
  description = "Docker image to use for the build project"
  type        = string
}

variable "environment_type" {
  description = "Type of build environment to use for related builds"
  type        = string
}

variable "image_pull_credentials_type" {
  description = "Type of credentials AWS CodeBuild uses to pull images in your build."
  type        = string
}

variable "artifacts_type" {
  description = "Information about the build output artifact location"
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

variable "pipeline_bucket_arn" {
  type = string
}

variable "tfstate_table_arn" {
  type = string
}

variable "tfstate_bucket_arn" {
  description = "Bucket arn where the tfstate file is stored"
  type        = string
}

variable "codestarconnection_github_arn" {
  description = "The CodeStar Connection arn connecting to GitHub"
  type        = string
}