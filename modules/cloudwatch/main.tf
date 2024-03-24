# CloudWatch Logs

resource "aws_cloudwatch_log_group" "pipeline_log_group" {
  name            = var.pipeline_log_group_name
  log_group_class = "STANDARD"
}

resource "aws_cloudwatch_log_stream" "pipeline_log_stream" {
  name           = var.pipeline_log_stream_name
  log_group_name = var.pipeline_log_group_name
}