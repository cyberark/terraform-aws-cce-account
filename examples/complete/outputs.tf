output "sia_role_arn" {
  description = "The IAM role ARN created for SIA."
  value       = module.cce_onboarding.sia_role_arn
}

output "sca_role_arn" {
  description = "The IAM role ARN created for SCA."
  value       = module.cce_onboarding.sca_role_arn
}

output "account_onboarding_id" {
  description = "The account onboarding resource ID."
  value       = module.cce_onboarding.account_onboarding_id
}
