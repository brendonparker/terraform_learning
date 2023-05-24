# IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "tf_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "DynamoDB"
    policy = data.aws_iam_policy_document.dynamodb.json
  }
}

locals {
  function_name = "tf_api"
  table_name    = "ApiTable"
}

# Lambda Source Code
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "dist"
  output_path = "api_source.zip"
}

# Lambda
resource "aws_lambda_function" "tf_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda.output_path
  function_name = local.function_name
  role          = aws_iam_role.role.arn
  handler       = "MyApi"
  runtime       = "dotnet6"
  memory_size   = 1536
  timeout       = 30

  source_code_hash = data.archive_file.lambda.output_base64sha256

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = local.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
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
    resources = ["arn:aws:dynamodb:*:*:table/${local.table_name}"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_dynamodb_table" "table" {
  name           = "ApiTable"
  hash_key       = "PK"
  write_capacity = 1
  read_capacity  = 1
  attribute {
    name = "PK"
    type = "S"
  }
}
