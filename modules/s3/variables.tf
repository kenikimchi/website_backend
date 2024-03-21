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