terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.52.0"
    }
  }
}

resource "azurerm_virtual_network" "zabbix" {
  name                = "vnet-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  location            = local.azure_regions[var.azure_region]
  resource_group_name = var.azure_resource_group_name
  address_space       = ["10.0.0.0/16", "fd00:db8:abcd::/48"]
}

resource "azurerm_subnet" "zabbix" {
  name                 = "snet-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  resource_group_name  = var.azure_resource_group_name
  virtual_network_name = azurerm_virtual_network.zabbix.name
  address_prefixes     = ["10.0.1.0/24", "fd00:db8:abcd:dead::/64"]
}

resource "azurerm_network_security_group" "zabbix" {
  name                = "nsg-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  location            = local.azure_regions[var.azure_region]
  resource_group_name = var.azure_resource_group_name

  security_rule {
    name                       = "InboundPort22Allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "zabbix_ipv4" {
  name                = "pipv4-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  location            = local.azure_regions[var.azure_region]
  resource_group_name = var.azure_resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
  ip_version          = "IPv4"
}

resource "azurerm_public_ip" "zabbix_ipv6" {
  name                = "pipv6-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  location            = local.azure_regions[var.azure_region]
  resource_group_name = var.azure_resource_group_name
  sku                 = "Standard"
  allocation_method   = "Static"
  ip_version          = "IPv6"
}

resource "azurerm_network_interface" "zabbix" {
  name                = "nic-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
  location            = local.azure_regions[var.azure_region]
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = "nicconfig_ipv4"
    primary                       = true
    subnet_id                     = azurerm_subnet.zabbix.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.zabbix_ipv4.id
  }

  ip_configuration {
    name                          = "nicconfig_ipv6"
    subnet_id                     = azurerm_subnet.zabbix.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
    public_ip_address_id          = azurerm_public_ip.zabbix_ipv6.id
  }
}

resource "azurerm_network_interface_security_group_association" "zabbix" {
  network_interface_id      = azurerm_network_interface.zabbix.id
  network_security_group_id = azurerm_network_security_group.zabbix.id
}

resource "azurerm_linux_virtual_machine" "zabbix" {
  name                  = "vmzabbix${var.env}${local.azure_regions_short[var.azure_region]}001"
  computer_name         = "vmzabbix${var.env}${local.azure_regions_short[var.azure_region]}001"
  location              = local.azure_regions[var.azure_region]
  resource_group_name   = var.azure_resource_group_name
  network_interface_ids = [azurerm_network_interface.zabbix.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "osdisk-zabbix-${var.env}-${local.azure_regions_short[var.azure_region]}-001"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "Latest"
  }

  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_key_file)
  }
}