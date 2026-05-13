# VM Module Resources

# Generate SSH Key Pair
resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Public IP
resource "azurerm_public_ip" "this" {
  name                = var.vm_config.public_ip_name
  location            = var.vm_config.location
  resource_group_name = var.vm_config.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.vm_config.tags
}

# Create Network Interface
resource "azurerm_network_interface" "this" {
  name                = var.vm_config.network_interface
  location            = var.vm_config.location
  resource_group_name = var.vm_config.resource_group
  tags                = var.vm_config.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

# Create Linux Virtual Machine with Managed Identity
resource "azurerm_linux_virtual_machine" "this" {
  name                  = var.vm_config.vm_name
  location              = var.vm_config.location
  resource_group_name   = var.vm_config.resource_group
  network_interface_ids = [azurerm_network_interface.this.id]
  size                  = var.vm_config.size
  tags                  = var.vm_config.tags

  # System-Assigned Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # OS Disk Configuration
  os_disk {
    name                 = var.vm_config.os_disk_name
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  # Source Image (Ubuntu 22.04 LTS)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # VM Configuration
  computer_name                   = var.vm_config.host_name
  admin_username                  = var.admin_username
  disable_password_authentication = true

  # SSH Key Configuration
  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm_ssh_key.public_key_openssh
  }

  # Boot Diagnostics
  boot_diagnostics {
    storage_account_uri = null  # Uses managed storage account
  }

  # Custom Data (Optional - for cloud-init)
  # custom_data = base64encode(file("${path.module}/cloud-init.sh"))
}

# Optional: Create private DNS zone for VM (for production)
resource "azurerm_private_dns_zone" "this" {
  count = var.vm_config.environment == "prod" ? 1 : 0
  
  name                = "${var.vm_config.vm_name}.private.azure.com"
  resource_group_name = var.vm_config.resource_group
  tags                = var.vm_config.tags
}

# Optional: Link private DNS zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count = var.vm_config.environment == "prod" ? 1 : 0
  
  name                  = "${var.vm_config.vm_name}-dns-link"
  resource_group_name   = var.vm_config.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.this[0].name
  virtual_network_id    = var.vm_subnet_id != "" ? split("/subnets", var.vm_subnet_id)[0] : ""
  registration_enabled  = true
}