# VNet Module Resources

# Create Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_config.name
  address_space       = var.vnet_config.address_space
  location            = var.vnet_config.location
  resource_group_name = var.vnet_config.resource_group
  tags                = var.vnet_config.tags
}

# Create Subnet
resource "azurerm_subnet" "this" {
  name                 = var.vnet_config.subnet_name
  resource_group_name  = var.vnet_config.resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.vnet_config.subnet_prefix
}

# Create Network Security Group
resource "azurerm_network_security_group" "this" {
  name                = var.vnet_config.nsg_name
  location            = var.vnet_config.location
  resource_group_name = var.vnet_config.resource_group
  tags                = var.vnet_config.tags

  # SSH Access
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow SSH access"
  }

  # Jenkins Access
  security_rule {
    name                       = "Jenkins"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow Jenkins access"
  }

  # HTTP Access (optional)
  security_rule {
    name                       = "HTTP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow HTTP access"
  }

  # Outbound Internet Access
  security_rule {
    name                       = "Outbound-Internet"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
    description                = "Allow outbound internet access"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}