output "deployed_resources" {
  description = "Map of deployed SCA resources including the main IAM role ARN"
  value       = { main = aws_iam_role.sca_cross_account_assume_role.arn }
}

output "module_ready" {
  description = "List of all SCA module resource identifiers indicating the module is ready"
  value = [
    aws_iam_role.sca_cross_account_assume_role.arn,
    aws_iam_policy.sca_cross_account_policy.arn,
    aws_iam_policy.sca_account_permissions_policy.arn,
    aws_iam_role_policy_attachment.sca_cross_account_role_attached_to_policy.id,
    aws_iam_role_policy_attachment.sca_cross_account_role_attached_to_account_permissions_policy.id,
  ]
}

