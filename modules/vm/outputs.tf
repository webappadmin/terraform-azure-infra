# VM Module Outputs

output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.this.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.this.private_ip_address
}

output "vm_principal_id" {
  description = "Principal ID of the Managed Identity"
  value       = azurerm_linux_virtual_machine.this.identity[0].principal_id
}

output "vm_ssh_private_key" {
  description = "SSH private key"
  value       = tls_private_key.vm_ssh_key.private_key_pem
  sensitive   = true
}

output "vm_ssh_public_key" {
  description = "SSH public key"
  value       = tls_private_key.vm_ssh_key.public_key_openssh
}