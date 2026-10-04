variable "sca_service_stage" {
  description = "The SCA service stage to deploy the resources."
  type        = string
}

variable "sca_service_region" {
  description = "The SCA Service region to deploy the resources."
  type        = string

  validation {
    condition     = var.sca_service_region != null && var.sca_service_region != ""
    error_message = "sca_service_region must be a non-empty AWS region."
  }
}

variable "sca_service_account_id" {
  description = "The AWS account number of the SCA account."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID from where the resources are deployed."
  type        = string
}

variable "custom_role_name" {
  description = "An optional IAM role name for SCA cross-account access. When null or empty, SCARole-{account_id}-{tenant_id} is used."
  type        = string
  default     = null
  nullable    = true
}

variable "add_permissions_to_manage_cluster" {
  description = "When true, attaches EKS cluster management permissions to the SCA cross-account role."
  type        = bool
  default     = false
}
