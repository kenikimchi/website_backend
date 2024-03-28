variable "apigateway_name" {
  description = "Name of the api gateway"
  type        = string
}

variable "cors_allowed_origins" {
  description = "List of allowed origins to the API"
  type        = list(string)
}

variable "api_stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}

variable "integration_uri" {
  description = "Invoke arn of the lambda function"
  type        = string
}