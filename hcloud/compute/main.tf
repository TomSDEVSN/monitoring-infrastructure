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

resource "random_uuid" "thanos_cluster_id" {}

resource "hcloud_ssh_key" "thanos-deploy" {
  name       = "thanos-deploy"
  public_key = file(var.ssh_key_file)
}

resource "hcloud_network" "thanos" {
  name     = "thanos-network"
  ip_range = "10.54.0.0/16"
}

resource "hcloud_network_subnet" "thanos" {
  type         = "cloud"
  network_id   = hcloud_network.thanos.id
  network_zone = "eu-central"
  ip_range     = "10.54.0.0/17"
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
    "cluster_id"            = random_uuid.thanos_cluster_id.result
    "azure/resource_group"  = var.azure_resource_group_name
    "azure/storage_account" = var.azure_storage_account_resource_name
  }

  ssh_keys = [hcloud_ssh_key.thanos-deploy.id]

  depends_on = [
    hcloud_network_subnet.thanos,
    random_uuid.thanos_cluster_id
  ]
}

resource "hcloud_load_balancer" "thanos" {
  name               = "thanos"
  load_balancer_type = "lb11"
  location           = "nbg1"
  algorithm {
    type = "least_connections"
  }
  labels = {
    "role"                 = "thanos"
    "cluster_id"           = random_uuid.thanos_cluster_id.result
    "env"                  = var.env
    "azure/resource_group" = var.azure_resource_group_name
  }
}

resource "hcloud_load_balancer_network" "thanos" {
  load_balancer_id = hcloud_load_balancer.thanos.id
  network_id       = hcloud_network.thanos.id
}

resource "hcloud_load_balancer_target" "thanos" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.thanos.id
  label_selector   = "cluster_id=${random_uuid.thanos_cluster_id.result}"
}

resource "hcloud_load_balancer_service" "thanos_http" {
  load_balancer_id = hcloud_load_balancer.thanos.id
  protocol         = "http"
}