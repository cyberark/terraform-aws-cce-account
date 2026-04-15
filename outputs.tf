output "sia_role_arn" {
  description = "The ARN of the IAM role created for SIA (Secure Infrastructure Access) service. Returns null if SIA is not enabled."
  value       = var.sia.enable != false ? module.sia[0].deployed_resources.main : null
}

output "sca_role_arn" {
  description = "The ARN of the IAM role created for SCA (Secure Cloud Access) service. Returns null if SCA is not enabled."
  value       = var.sca.enable != false ? module.sca[0].deployed_resources.main : null
}

output "account_onboarding_id" {
  description = "The ID of the account onboarding resource"
  value       = length(idsec_cce_aws_account.add_account) > 0 ? idsec_cce_aws_account.add_account[0].id : null
}
