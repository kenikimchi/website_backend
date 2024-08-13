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

variable "apigateway_cwlogs_arn" {
  description = "ARN of the cloudwatch log group"
  type        = string
}

variable "apigateway_log_format" {
  description = "Format of logs sent to CloudWatch"
  type        = string
}

variable "bikestation_integration_uri" {
  description = "HTTP URL of the bikestation API"
  type        = string
}

variable "station_location_uri" {
  description = "HTTP URL of the bikestation API for station locations"
  type        = string
}