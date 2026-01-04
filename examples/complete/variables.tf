variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "The AWS account ID to onboard to CyberArk CCE"
  type        = string
}

variable "account_display_name" {
  description = "The display name for the AWS account in CyberArk CCE"
  type        = string
  default     = "My AWS Account - Complete Setup"
}

variable "enable_sso" {
  description = "Enable AWS IAM Identity Center (SSO) integration for SCA"
  type        = bool
  default     = true
}

variable "sso_region" {
  description = "AWS region where IAM Identity Center is configured (required if enable_sso is true)"
  type        = string
  default     = "us-east-1"
}

