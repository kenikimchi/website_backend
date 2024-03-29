variable "pipeline_log_group_name" {
  description = "Name of the Log group for CodePipeline"
  type        = string
}

variable "pipeline_log_stream_name" {
  description = "Name of the log stream for CodePipeline"
  type        = string
}

variable "apigateway_group_name" {
  type = string
}