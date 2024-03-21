# Terraform State Table

variable "tfstate_table_name" {
  description = "Name of the dynamodb table containing the tfsate lock data"
  type        = string
}