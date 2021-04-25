terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.52.0"
    }
  }
}

resource "azurerm_storage_account" "thanos" {
  name                     = "stthanos${var.env}${local.azure_regions_short[var.azure_region]}001"
  resource_group_name      = var.azure_resource_group_name
  location                 = local.azure_regions[var.azure_region]
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  access_tier              = "Cool"
}

output "storage_account_resource_name" {
  value = azurerm_storage_account.thanos.name
}