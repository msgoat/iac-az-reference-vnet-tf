locals {
  network_security_group_name_prefix = "nsg-${var.region_code}-${var.network_name}"
}

# Create a default network security group
resource azurerm_network_security_group default {
  count = var.network_security_groups_enabled ? 1 : 0
  name = "${local.network_security_group_name_prefix}-default"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags = merge(map("Name", "${local.network_security_group_name_prefix}-default"), local.module_common_tags)
}
