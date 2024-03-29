output "apigateway_cwlogs_arn" {
  value = aws_cloudwatch_log_group.api_gateway_log_group.arn
}