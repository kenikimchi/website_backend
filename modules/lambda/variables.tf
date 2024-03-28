variable "lambda_function_name" {
  description = "Name of the pagecount lambda function"
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "The arn of the apigateway"
  type        = string
}

variable "pagecount_database" {
  description = "Database arn of the pagecount database"
  type        = list(string)
}

variable "dependencies_bucket" {
  description = "S3 bucket arn containing the lambda dependencies"
  type        = string
}