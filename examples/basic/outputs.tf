output "sca_role_arn" {
  description = "The IAM role ARN created for SCA."
  value       = module.cce_onboarding.sca_role_arn
}
