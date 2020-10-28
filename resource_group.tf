locals {
  new_resource_group_required = var.resource_group_name == ""
}

# Create a new resource group if no resource group was specified
resource azurerm_resource_group new {
  count = local.new_resource_group_required ? 1 : 0
  name = "rg-${var.region_code}-${var.network_name}"
  location = var.region_name
  tags = merge(map("Name", "rg-${var.region_code}-${var.network_name}"), local.module_common_tags)
}

locals {
  resource_group_name = local.new_resource_group_required ? azurerm_resource_group.new[0].name : var.resource_group_name
  resource_group_location = local.new_resource_group_required ? azurerm_resource_group.new[0].location : var.resource_group_location
}
