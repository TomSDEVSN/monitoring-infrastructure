module "azure_compute" {
    source = "./azure/compute"
}

module "azure_storage" {
  source = "./azure/storage"
}

module "hcloud_compute" {
    source = "./hcloud/compute"
}

module "hcloud_dns" {
  source = "./hcloud/dns"
}