output "sia_role_arn" {
  description = "The ARN of the IAM role created for SIA (Secure Infrastructure Access) service. Returns null if SIA is not enabled."
  value       = var.sia.enable != false ? module.sia[0].deployed_resources.main : null
}
