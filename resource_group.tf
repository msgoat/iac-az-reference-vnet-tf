locals {
  new_resource_group_name_prefix = "rg-${var.region_code}"
  new_resource_group_name = "${local.new_resource_group_name_prefix}-${var.network_name}"
  new_resource_group_required = var.resource_group_name == ""
}

# Create a new resource group if no resource group was specified
resource azurerm_resource_group new {
  count = local.new_resource_group_required ? 1 : 0
  name = local.new_resource_group_name
  location = var.region_name
  tags = merge(map("Name", local.new_resource_group_name), local.module_common_tags)
}

# Retrieve given resource group if a resource group was specified
data azurerm_resource_group given {
  count = local.new_resource_group_required ? 0 : 1
  name = var.resource_group_name
}

locals {
  resource_group_name = local.new_resource_group_required ? azurerm_resource_group.new[0].name : data.azurerm_resource_group.given[0].name
  resource_group_location = local.new_resource_group_required ? azurerm_resource_group.new[0].location : data.azurerm_resource_group.given[0].location
}
