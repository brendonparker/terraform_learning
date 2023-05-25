output "rw_policy_document" {
  description = "Policy for read/write"
  value       = data.aws_iam_policy_document.dynamodb.json
}
