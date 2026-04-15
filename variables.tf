variable "account_id" {
  description = "The AWS account ID to onboard to CyberArk CCE"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "The account_id must be a valid 12-digit AWS account ID."
  }
}

variable "account_display_name" {
  description = "The display name for the AWS account in CyberArk CCE"
  type        = string
  default     = "AWS Account"
}

variable "sia" {
  description = "Configuration for the SIA (Secure Infrastructure Access) feature. Note: Uses DPA service internally for backward compatibility."
  type = object({
    enable = optional(bool, true)
  })
  default = { enable = false }
}

variable "sca" {
  description = "Configuration for the SCA (Secure Cloud Access) feature."
  type = object({
    enable    = optional(bool, true)
    role_name = optional(string, null)
  })
  default = { enable = false }
}

