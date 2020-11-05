
output "vnet_id" {
  description = "Unique identifier of the newly created VNet."
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Fully qualified name of the newly created VNet."
  value = azurerm_virtual_network.vnet.name
}

output "public_subnet_ids" {
  description = "Unique identifiers of all public subnets"
  value = azurerm_subnet.web.*.id
}

output "private_subnet_ids" {
  description = "Unique identifiers of all private subnets"
  value = concat(azurerm_subnet.app.*.id, azurerm_subnet.data.*.id)
}

output "application_gateway_subnet_id" {
  description = "Unique identifier of the application gateway subnet"
  value = azurerm_subnet.agw.id
}

output "web_subnet_ids" {
  description = "Unique identifiers of all web subnets"
  value = azurerm_subnet.web.*.id
}

output "app_subnet_ids" {
  description = "Unique identifiers of all application subnets"
  value = azurerm_subnet.app.*.id
}

output "data_subnet_ids" {
  description = "Unique identifiers of all datastore subnets"
  value = azurerm_subnet.data.*.id
}

output "resource_group_name" {
  description = "Name of the resource group hosting all network components"
  value = local.resource_group_name
}

output "resource_group_location" {
  description = "Location of the resource group hosting all network components"
  value = local.resource_group_location
}