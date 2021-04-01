variable "azure_region" {
  default = "eu-west"
}

variable "domain" {
  type = string
}

variable "env" {
  type = string
}

variable "global_settings" {
  default = {}
}

variable "storage_accounts" {
  default = {}
}

variable "tags" {
  default = null
  type    = map(any)
}

variable "hcloud_token" {
  type    = string
  default = ""
}

variable "hcloud_thanos_server_instance_count" {
  type    = string
  default = "1"
}

variable "hetzner_dns_token" {
  type = string
}

variable "hetzner_dns_zone" {
  type = string
}