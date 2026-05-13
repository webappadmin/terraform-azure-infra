# Root Outputs

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.vnet.vnet_id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = module.vnet.subnet_id
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = module.vm.vm_public_ip
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = module.vm.vm_private_ip
  sensitive   = true
}

output "vm_principal_id" {
  description = "Principal ID of VM Managed Identity"
  value       = module.vm.vm_principal_id
}

output "vm_ssh_private_key" {
  description = "SSH private key for VM access"
  value       = module.vm.vm_ssh_private_key
  sensitive   = true
}