variable "sca_service_stage" {
  description = "The SCA Service stage to deploy the resources"
  type        = string
}

variable "sca_service_region" {
  description = "The SCA Service region to deploy the resources"
  type        = string

  validation {
    condition     = var.sca_service_region != null && var.sca_service_region != ""
    error_message = "sca_service_region must be a non-empty AWS region."
  }
}

variable "sca_service_account_id" {
  description = "The AWS account number for SCA account"
  type        = string
}

variable "tenant_id" {
  description = "The tenant id of deployer"
  type        = string
}

variable "custom_role_name" {
  description = "Optional IAM role name for SCA cross-account access. When null or empty, SCARole-{account_id}-{tenant_id} is used."
  type        = string
  default     = null
  nullable    = true
}
