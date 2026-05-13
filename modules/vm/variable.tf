# VM Module Variables

variable "vm_config" {
  description = "VM configuration object"
  type = object({
    vm_name           = string
    location          = string
    resource_group    = string
    public_ip_name    = string
    network_interface = string
    os_disk_name      = string
    host_name         = string
    size              = string
    environment       = string
    tags              = map(string)
  })
}

variable "vm_subnet_id" {
  description = "ID of the subnet for VM deployment"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}