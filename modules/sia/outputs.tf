output "deployed_resources" {
  description = "Map of deployed SIA resources including the main IAM role ARN"
  value       = { main = aws_iam_role.dpa_role.arn }
}

output "module_ready" {
  description = "List of all SIA module resource identifiers indicating the module is ready"
  value = [
    aws_iam_role.dpa_role.arn,
    aws_iam_policy.dpa_policy.arn,
    aws_iam_role_policy_attachment.dpa_policy_attach.id
  ]
}

