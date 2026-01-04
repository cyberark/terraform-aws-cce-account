output "sia_role_arn" {
  description = "The ARN of the IAM role created for SIA service"
  value       = module.cce_onboarding.sia_role_arn
}

output "sca_role_arn" {
  description = "The ARN of the IAM role created for SCA service"
  value       = module.cce_onboarding.sca_role_arn
}
