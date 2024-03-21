output "tfstate_table_arn" {
  value = aws_dynamodb_table.tfstate_lock.arn
}