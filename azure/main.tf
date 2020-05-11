# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "hashi-stack" {
  name     = var.rg-name
  location =  var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "hashi-stack" {
  name                = var.vnet-name
  resource_group_name = azurerm_resource_group.hashi-stack.name
  location            = azurerm_resource_group.hashi-stack.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "hashi-stack" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.hashi-stack.name
  virtual_network_name = azurerm_virtual_network.hashi-stack.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.example.id]
