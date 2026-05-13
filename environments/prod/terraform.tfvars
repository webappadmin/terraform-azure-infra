# Production Environment Configuration

# Resource Group
resource_group_name = "company-1-prod"
location           = "eastus2"           # Primary production region
environment        = "prod"

# VNet Configuration
vnet_name          = "prod-vnet"
vnet_address_space = ["10.2.0.0/16"]     # Production IP range
subnet_name        = "prod-subnet"
subnet_prefix      = ["10.2.1.0/24"]
nsg_name           = "prod-nsg"

# VM Configuration - Production specs
vm_name            = "prod-vm"
vm_size            = "Standard_D2s_v3"   # Production size
admin_username     = "azureuser"

# Networking Resources
public_ip_name        = "prod-vm-pip"
network_interface_name = "prod-vm-nic"
os_disk_name          = "prod-vm-osdisk"

# Tags - Production specific
tags = {
  Environment = "Production"
  CostCenter  = "DevOps-Team"
  AutoShutdown = "False"
  ProvisionedBy = "Terraform"
  DataClassification = "Confidential"
  BackupRequired = "True"
  SLA = "High"
}