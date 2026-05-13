# Root Variables - No authentication needed (Managed Identity handles it)

# Resource Configuration
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westus2"
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy  = "Terraform"
    Automation = "Jenkins"
  }
}

# VNet Configuration
variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "main-vnet"
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "internal-subnet"
}

variable "subnet_prefix" {
  description = "Subnet address prefixes"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
  default     = "vm-nsg"
}

# VM Configuration
variable "vm_name" {
  description = "Virtual Machine name"
  type        = string
  default     = "myvm"
}

variable "vm_size" {
  description = "VM Size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "azureuser"
}

# Public IP Configuration
variable "public_ip_name" {
  description = "Public IP name"
  type        = string
  default     = "vm-public-ip"
}

variable "network_interface_name" {
  description = "Network Interface name"
  type        = string
  default     = "vm-nic"
}

variable "os_disk_name" {
  description = "OS Disk name"
  type        = string
  default     = "vm-os-disk"
}