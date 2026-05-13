# Development Environment Configuration

# Resource Group
resource_group_name = "company-1-dev"
location           = "westus2"
environment        = "dev"

# VNet Configuration
vnet_name          = "dev-vnet"
vnet_address_space = ["10.0.0.0/16"]
subnet_name        = "dev-subnet"
subnet_prefix      = ["10.0.1.0/24"]
nsg_name           = "dev-nsg"

# VM Configuration
vm_name            = "dev-vm"
vm_size            = "Standard_B2s"
admin_username     = "azureuser"

# Networking Resources
public_ip_name        = "dev-vm-pip"
network_interface_name = "dev-vm-nic"
os_disk_name          = "dev-vm-osdisk"

# Tags
tags = {
  Environment = "Development"
  CostCenter  = "DevOps-Team"
  AutoShutdown = "True"
  ProvisionedBy = "Terraform"
}