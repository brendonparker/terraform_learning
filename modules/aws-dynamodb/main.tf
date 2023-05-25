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

data "aws_iam_policy_document" "dynamodb" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:BatchWrite*",
      "dynamodb:Delete*",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:Update*",
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.table_name}"]
  }
}
