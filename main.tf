terraform {
  required_version = ">= 1.8.5"
}

# SIA (Secure Infrastructure Access) Module
module "sia" {
  source         = "./services_modules/sia"
  sia_account_id = var.sia_account_id
  tenant_id      = var.tenant_id
  count          = var.sia.enable != false ? 1 : 0
}
