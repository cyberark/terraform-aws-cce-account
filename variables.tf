variable "account_id" {
  description = "The AWS account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "The account_id must be a valid 12-digit AWS account ID."
  }
}

variable "account_display_name" {
  description = "The display name of the AWS account in Connect cloud environments."
  type        = string
  default     = "AWS Account"
}

variable "sia" {
  description = "The configuration for SIA (Secure Infrastructure Access). Note: Uses DPA internally for backward compatibility."
  type = object({
    enable = optional(bool, true)
  })
  default = { enable = false }
}

variable "sca" {
  description = "The configuration for SCA (Secure Cloud Access). add_permissions_to_manage_cluster attaches optional EKS cluster management permissions to the cross-account role."
  type = object({
    enable                            = optional(bool, true)
    role_name                         = optional(string, null)
    add_permissions_to_manage_cluster = optional(bool, false)
  })
  default = {
    enable = false
  }
}

