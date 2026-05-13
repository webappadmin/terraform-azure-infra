# Main Terraform Configuration

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = merge(var.tags, {
    Environment = var.environment
    Name        = var.resource_group_name
  })
}

# Generate random suffix for unique naming (optional)
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Deploy VNet Module
module "vnet" {
  source = "./modules/vnet"

  vnet_config = {
    name           = var.vnet_name
    address_space  = var.vnet_address_space
    subnet_name    = var.subnet_name
    subnet_prefix  = var.subnet_prefix
    nsg_name       = var.nsg_name
    location       = var.location
    resource_group = azurerm_resource_group.rg.name
    environment    = var.environment
    tags           = var.tags
  }
}

# Deploy VM Module
module "vm" {
  source = "./modules/vm"

  vm_config = {
    vm_name           = var.vm_name
    location          = var.location
    resource_group    = azurerm_resource_group.rg.name
    public_ip_name    = var.public_ip_name
    network_interface = var.network_interface_name
    os_disk_name      = var.os_disk_name
    host_name         = var.vm_name
    size              = var.vm_size
    environment       = var.environment
    tags              = var.tags
  }

  vm_subnet_id   = module.vnet.subnet_id
  admin_username = var.admin_username
}