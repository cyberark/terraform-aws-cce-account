output "sia_role_arn" {
  description = "The IAM role ARN created for SIA (Secure Infrastructure Access). Returns null if SIA is not enabled."
  value       = var.sia.enable != false ? module.sia[0].deployed_resources.main : null
}

output "sca_role_arn" {
  description = "The IAM role ARN created for SCA (Secure Cloud Access). Returns null if SCA is not enabled."
  value       = var.sca.enable != false ? module.sca[0].deployed_resources.main : null
}

output "account_onboarding_id" {
  description = "The account onboarding resource ID."
  value       = length(idsec_cce_aws_account.add_account) > 0 ? idsec_cce_aws_account.add_account[0].id : null
}
