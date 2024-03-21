# DynamoDB

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = var.tfstate_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}