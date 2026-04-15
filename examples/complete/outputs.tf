output "sia_role_arn" {
  description = "The ARN of the IAM role created for SIA service"
  value       = module.cce_onboarding.sia_role_arn
}

output "sca_role_arn" {
  description = "The ARN of the IAM role created for SCA service"
  value       = module.cce_onboarding.sca_role_arn
}

output "account_onboarding_id" {
  description = "The ID of the account onboarding resource"
  value       = module.cce_onboarding.account_onboarding_id
}
