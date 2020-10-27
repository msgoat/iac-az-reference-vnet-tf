# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.20"
  features {}
}

locals {
  module_common_tags = {
    Organization = var.organization_name
    Department = var.department_name
    Project = var.project_name
    Stage = var.stage
  }
  subnet_cidrs = cidrsubnets(var.network_cidr, 4, 4, 8, 8)
  public_bastion_subnet_cidrs = slice(local.subnet_cidrs, 3,4)
  public_web_subnet_cidrs = slice(local.subnet_cidrs, 2, 3)
  private_app_subnet_cidrs = slice(local.subnet_cidrs, 1, 2)
  private_data_subnet_cidrs = slice(local.subnet_cidrs, 0, 1)
}
