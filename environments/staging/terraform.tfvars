# Staging Environment Configuration

# Resource Group
resource_group_name = "company-1-staging"
location           = "eastus"          # Different region for staging
environment        = "staging"

# VNet Configuration
vnet_name          = "staging-vnet"
vnet_address_space = ["10.1.0.0/16"]    # Different IP range
subnet_name        = "staging-subnet"
subnet_prefix      = ["10.1.1.0/24"]
nsg_name           = "staging-nsg"

# VM Configuration
vm_name            = "staging-vm"
vm_size            = "Standard_B2ms"    # Larger for staging
admin_username     = "azureuser"

# Networking Resources
public_ip_name        = "staging-vm-pip"
network_interface_name = "staging-vm-nic"
os_disk_name          = "staging-vm-osdisk"

# Tags
tags = {
  Environment = "Staging"
  CostCenter  = "DevOps-Team"
  AutoShutdown = "False"
  ProvisionedBy = "Terraform"
  DataClassification = "Test"
}