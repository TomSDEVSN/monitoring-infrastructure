terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.26.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}