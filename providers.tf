# Provider Configuration with Managed Identity

terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }

  # Backend configuration for remote state (using Managed Identity)
  #backend "azurerm" {
  # Values provided via backend.hcl or command line
  # No access key needed - uses Managed Identity
  #}
}

# Azure Provider - automatically uses Managed Identity from Jenkins VM
provider "azurerm" {
  features {}
  subscription_id = "0cb7c478-174b-48ad-acf6-dd18431ba9fe"
}
# Optional: Set environment if using Azure Government or China
# environment = "public"