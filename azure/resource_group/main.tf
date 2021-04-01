terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.52.0"
    }
  }
}

resource "azurerm_resource_group" "thanos" {
  name     = "rg-thanos-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  location = local.azure_regions[var.azure_region]
}

output "rg_name" {
  value = azurerm_resource_group.thanos.name
}