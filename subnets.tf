locals {
  subnet_name_prefix = "snet-${var.region_code}-${var.network_name}"
}

resource azurerm_subnet web {
  count = length(local.public_web_subnet_cidrs)
  name = "${local.subnet_name_prefix}-web${count.index}"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    local.public_web_subnet_cidrs[count.index]]
  #  tags = merge(map("Name", "subnet-weu-${var.network_name}-web${count.index}"), local.module_common_tags)
}

resource azurerm_subnet app {
  count = length(local.private_app_subnet_cidrs)
  name = "${local.subnet_name_prefix}-app${count.index}"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    local.private_app_subnet_cidrs[count.index]]
  #  tags = merge(map("Name", "subnet-weu-${var.network_name}-app${count.index}"), local.module_common_tags)
}

resource azurerm_subnet data {
  count = length(local.private_data_subnet_cidrs)
  name = "${local.subnet_name_prefix}-data${count.index}"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    local.private_data_subnet_cidrs[count.index]]
  #  tags = merge(map("Name", "subnet-weu-${var.network_name}-data${count.index}"), local.module_common_tags)
}

locals {
  subnet_ids = concat(azurerm_subnet.web.*.id, azurerm_subnet.app.*.id, azurerm_subnet.data.*.id)
}

# attach default security group to all subnets
resource azurerm_subnet_network_security_group_association "default" {
  count = length(local.subnet_ids)
  subnet_id = local.subnet_ids[count.index]
  network_security_group_id = azurerm_network_security_group.default.id
}