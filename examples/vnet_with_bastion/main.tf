# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "~> 2.20"
  features {}
}

locals {
  main_common_tags = {
    Organization = var.organization_name
    Department = var.department_name
    Project = var.project_name
    Stage = var.stage
  }
}

# Create a new resource group if no resource group was specified
resource azurerm_resource_group owner {
  name = "rg-${var.region_code}-${var.network_name}-network"
  location = var.region_name
  tags = merge(map("Name", "rg-${var.region_code}-${var.network_name}-network"), local.main_common_tags)
}

module reference_vnet {
  source = "../.."
  region_name = var.region_name
  region_code = var.region_code
  organization_name = var.organization_name
  department_name = var.department_name
  project_name = var.project_name
  stage = var.stage
  resource_group_name = azurerm_resource_group.owner.name
  resource_group_location = azurerm_resource_group.owner.location
  network_name = var.network_name
  network_cidr = var.network_cidr
}

# Create a test virtual machine in a private subnet to check accessibility via Azure Bastion service
resource azurerm_linux_virtual_machine test {
  name                = "vm-${var.region_code}-${var.network_name}-test"
  resource_group_name = module.reference_vnet.resource_group_name
  location            = module.reference_vnet.resource_group_location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.test.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./resources/cxp-az-demo.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource azurerm_network_interface test {
  name                = "nic-${var.region_code}-${var.network_name}-test"
  resource_group_name = module.reference_vnet.resource_group_name
  location            = module.reference_vnet.resource_group_location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.reference_vnet.app_subnet_ids[0]
    private_ip_address_allocation = "Dynamic"
  }
}