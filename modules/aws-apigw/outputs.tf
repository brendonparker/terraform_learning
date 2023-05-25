output "api_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}

output "source_arn" {
  value = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
