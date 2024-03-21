variable "source_repository_name" {
  type        = string
  description = "Name of the Source CodeCommit repository used by the pipeline"
}

variable "source_repository_branch" {
  type        = string
  description = "Branch of the Source CodeCommit repository used in pipeline"
}

variable "repo_approvers_arn" {
  description = "ARN or ARN pattern for the IAM User/Role/Group etc that can be used for approving Pull Requests"
  type        = string
}