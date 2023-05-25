terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.myregion
}

locals {
  table_name    = "ApiTable"
  function_name = "tf_api"
}

module "lambda" {
  source = "./modules/aws-lambda"

  table_name    = local.table_name
  function_name = local.function_name
  handler_name = "MyApi"
  source_dir = "app/dist"
  source_arn = module.api.source_arn
}

module "api" {
  source = "./modules/aws-apigw"

  name       = "tf_api"
  region     = var.myregion
  accountId  = var.accountId
  invoke_arn = module.lambda.invoke_arn
}

module "table" {
  source = "./modules/aws-dynamodb"

  table_name = local.table_name
}

# Originally I had everything in the root module
# This is how to move things into the new module
# without them being destroyed/recreated
moved {
  from = aws_dynamodb_table.table
  to   = module.table.aws_dynamodb_table.table
}
