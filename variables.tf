variable "sia_account_id" {
  description = "The AWS account number for SIA service"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the deployment"
  type        = string
}

variable "sia" {
  description = "Configuration for the SIA (Secure Infrastructure Access) feature. Note: Uses DPA service internally for backward compatibility."
  type = object({
    enable = optional(bool, true)
  })
  default = { enable = false }
}
