resource azurerm_nat_gateway ngw {
  name = "ngw-${var.region_code}-${var.network_name}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  public_ip_prefix_ids = [
    azurerm_public_ip_prefix.ngw.id]
  tags = merge(map("Name", "ngw-${var.region_code}-${var.network_name}"), local.module_common_tags)
}

resource azurerm_public_ip ngw {
  name = "pip-${var.region_code}-${var.network_name}-ngw"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
  tags = merge(map("Name", "pip-${var.region_code}-${var.network_name}-ngw"), local.module_common_tags)
}

resource azurerm_public_ip_prefix ngw {
  name = "pippre-${var.region_code}-${var.network_name}-ngw"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku = "Standard"
  prefix_length = 31
  tags = merge(map("Name", "pippre-${var.region_code}-${var.network_name}-ngw"), local.module_common_tags)
}

resource azurerm_subnet_nat_gateway_association web {
  count = length(azurerm_subnet.web)
  nat_gateway_id = azurerm_nat_gateway.ngw.id
  subnet_id = azurerm_subnet.web[count.index].id
}

resource azurerm_subnet_nat_gateway_association app {
  count = length(azurerm_subnet.app)
  nat_gateway_id = azurerm_nat_gateway.ngw.id
  subnet_id = azurerm_subnet.app[count.index].id
}

resource azurerm_subnet_nat_gateway_association data {
  count = length(azurerm_subnet.data)
  nat_gateway_id = azurerm_nat_gateway.ngw.id
  subnet_id = azurerm_subnet.data[count.index].id
}
