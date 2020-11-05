locals {
  subnet_name_prefix = "snet-${var.region_code}-${var.network_name}"
  number_of_web_subnets = length(local.public_web_subnet_cidrs)
  number_of_app_subnets = length(local.private_app_subnet_cidrs)
  number_of_data_subnets = length(local.private_data_subnet_cidrs)
  empty_string = ""
}

resource azurerm_subnet agw {
  name = "${local.subnet_name_prefix}-agw"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = local.public_application_gateway_subnet_cidrs
}

resource azurerm_subnet web {
  count = local.number_of_web_subnets
  name = "${local.subnet_name_prefix}-web${local.number_of_web_subnets > 1 ? count.index : local.empty_string}"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    local.public_web_subnet_cidrs[count.index]]
}

resource azurerm_subnet app {
  count = local.number_of_app_subnets
  name = "${local.subnet_name_prefix}-app${local.number_of_app_subnets > 1 ? count.index : local.empty_string}"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    local.private_app_subnet_cidrs[count.index]]
}

resource azurerm_subnet data {
  count = local.number_of_data_subnets
  name = "${local.subnet_name_prefix}-data${local.number_of_data_subnets > 1 ? count.index : local.empty_string}"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    local.private_data_subnet_cidrs[count.index]]
}

locals {
  subnet_ids = concat(azurerm_subnet.web.*.id, azurerm_subnet.app.*.id, azurerm_subnet.data.*.id)
}

# attach default security group to all subnets
resource azurerm_subnet_network_security_group_association default {
  count = var.network_security_groups_enabled ? length(local.subnet_ids) : 0
  subnet_id = local.subnet_ids[count.index]
  network_security_group_id = azurerm_network_security_group.default[0].id
}