# CodePipeline Variables
variable "project_name" {
  type    = string
  default = null
}

variable "artifacts_store_type" {
  type    = string
  default = "S3"
}

variable "pipeline_bucket_arn" {
  type = string
}

variable "pipeline_bucket_id" {
  type = string
}

variable "source_provider" {
  type    = string
  default = "CodeStarSourceConnection"
}

variable "output_artifacts" {
  type    = string
  default = "tf-code"
}

variable "output_artifact_format" {
  type    = string
  default = "code_zip"
}

variable "input_artifacts" {
  type    = string
  default = "tf-code"
}

variable "full_repo_id" {
  type    = string
  default = ""
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "stages" {
  type = list(map(any))
}

# Role Variables
variable "source_repository_name" {
  type        = string
  description = "Name of the Source CodeCommit repository"
}

variable "codepipeline_iam_role_name" {
  description = "Name of the IAM role to be used by the project"
  type        = string
}

variable "create_new_role" {
  type        = bool
  description = "Flag for deciding if a new role needs to be created"
  default     = true
}

variable "kms_key_arn" {
  description = "KMS Key arn of the encryption key used for encrypting bucket objects"
  type        = string
}