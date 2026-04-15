terraform {
  required_version = ">= 1.8.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    idsec = {
      source  = "cyberark/idsec"
      version = "~> 0.2.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "idsec" {
  # Configure with your CyberArk CCE tenant credentials
  # You can set these via environment variables:
  # - IDSEC_TENANT_URL
  # - IDSEC_CLIENT_ID
  # - IDSEC_CLIENT_SECRET
  # See: https://registry.terraform.io/providers/cyberark/idsec/latest/docs
}

module "cce_onboarding" {
  source = "../.."

  account_id           = var.account_id
  account_display_name = var.account_display_name

  # Enable SIA (Secure Infrastructure Access) service
  sia = {
    enable = true
  }

  # Enable SCA (Secure Cloud Access)
  sca = {
    enable = true
  }
}

