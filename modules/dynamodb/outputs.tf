output "tfstate_table_arn" {
  value = aws_dynamodb_table.tfstate_lock.arn
}

output "pagecount_database_arn" {
  value = aws_dynamodb_table.page_count.arn
}