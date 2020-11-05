# Instantiates the Azure Bastion service
resource azurerm_bastion_host bastion {
  count = var.bastions_enabled ? 1 : 0
  name = "bst-${var.region_code}-${var.network_name}"
  location = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name = "configuration"
    subnet_id = azurerm_subnet.bastion[0].id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }

  tags = merge(map("Name", "bastion-${var.region_code}-${var.network_name}"), local.module_common_tags)
}

# Create a public IP address
resource azurerm_public_ip bastion {
  count = var.bastions_enabled ? 1 : 0
  name = "pip-${var.region_code}-${var.network_name}-bastion"
  resource_group_name = local.resource_group_name
  location = local.resource_group_location
  allocation_method = "Static"
  sku = "Standard"
  tags = merge(map("Name", "pip-${var.region_code}-${var.network_name}-bastion"), local.module_common_tags)
}

# Create a dedicated subnet for bastion hosts
resource azurerm_subnet bastion {
  count = var.bastions_enabled ? 1 : 0
  name = "AzureBastionSubnet"
  resource_group_name = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [local.public_bastion_subnet_cidrs[0]]
}