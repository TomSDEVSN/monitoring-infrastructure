variable "azure_resource_group_name" {
  type = string
}

variable "hcloud_token" {
  type    = string
  default = ""
}

variable "hcloud_thanos_server_instance_count" {
  type    = string
}

variable "domain" {
  type = string
}

variable "env" {
  type = string
}