output "deployed_resources" {
  description = "A map of deployed SIA resources including the main IAM role ARN."
  value       = { main = aws_iam_role.dpa_role.arn }
}

output "module_ready" {
  description = "A list of all SIA module resource identifiers that indicates the module is ready."
  value = [
    aws_iam_role.dpa_role.arn,
    aws_iam_policy.dpa_policy.arn,
    aws_iam_role_policy_attachment.dpa_policy_attach.id
  ]
}

