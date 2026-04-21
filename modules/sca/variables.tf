variable "sca_service_account_id" {
  description = "The AWS account number for SCA account"
  type        = string
}

variable "tenant_id" {
  description = "The tenant id of deployer"
  type        = string
}


variable "custom_role_name" {
  description = "Optional IAM role name for SCA cross-account access. When null or empty, CyberArkSCACrossAccountRole is used."
  type        = string
  default     = null
  nullable    = true
}
