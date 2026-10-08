variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "The AWS account ID."
  type        = string
}

variable "account_display_name" {
  description = "The AWS account display name in CCE."
  type        = string
  default     = "My AWS Account - Complete Setup"
}

