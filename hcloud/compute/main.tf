terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.26.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_network" "thanos" {
  name     = "thanos-network"
  ip_range = "10.54.0.0/16"
}

resource "hcloud_network_subnet" "thanos" {
  type          = "cloud"
  network_id    = hcloud_network.thanos.id
  network_zone  = "eu-central"
  ip_range      = "10.54.0.0/17"
}

resource "hcloud_server" "thanos" {
  count       = var.hcloud_thanos_server_instance_count
  name        = "thanos-${count.index + 1}.${var.domain}"
  server_type = "cpx21"
  image       = "ubuntu-20.04"
  location    = "nbg1"

  network {
    network_id = hcloud_network.thanos.id
  }

  labels = {
    "env"                   = var.env
    "azure/resource_group"  = var.azure_resource_group_name
#    "azure/storage_account" = azure_storage_account_name
  }

  depends_on = [
    hcloud_network_subnet.thanos
  ]
}