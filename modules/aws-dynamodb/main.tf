resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  hash_key       = "PK"
  write_capacity = var.write_capacity
  read_capacity  = var.read_capacity
  attribute {
    name = "PK"
    type = "S"
  }
}
