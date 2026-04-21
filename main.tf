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

data "aws_region" "current" {}

# Fetch CyberArk CCE tenant service details
data "idsec_cce_aws_tenant_service_details" "get_tenant_data" {}

# SIA (Secure Infrastructure Access) Module
module "sia" {
  source         = "./modules/sia"
  sia_account_id = data.idsec_cce_aws_tenant_service_details.get_tenant_data.services_details.dpa.service_account_id
  tenant_id      = data.idsec_cce_aws_tenant_service_details.get_tenant_data.tenant_id
  count          = var.sia.enable != false ? 1 : 0
}

# SCA (Secure Cloud Access) Module
module "sca" {
  source                 = "./modules/sca"
  sca_service_account_id = data.idsec_cce_aws_tenant_service_details.get_tenant_data.services_details.sca.service_account_id
  tenant_id              = data.idsec_cce_aws_tenant_service_details.get_tenant_data.tenant_id
  custom_role_name       = var.sca.role_name
  count                  = var.sca.enable != false ? 1 : 0
}

# Register AWS account with CyberArk CCE
resource "idsec_cce_aws_account" "add_account" {
  count                = var.sca.enable == true || var.sia.enable == true ? 1 : 0
  account_id           = var.account_id
  account_display_name = var.account_display_name
  deployment_region    = data.aws_region.current.name

  services = concat(
    # Add SIA service if enabled
    var.sia.enable != false ? [
      {
        service_name = "dpa"
        resources = {
          "DpaRoleArn" = module.sia[0].deployed_resources.main
        }
      }
    ] : [],

    # Add SCA service if enabled
    var.sca.enable != false ? [
      {
        service_name = "sca"
        resources = {
          "scaPowerRoleArn" = module.sca[0].deployed_resources.main
        }
      }
    ] : []
  )
}
