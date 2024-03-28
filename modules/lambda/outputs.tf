output "integration_uri" {
  value = aws_lambda_function.db_writer.invoke_arn
}