locals {
  azure_regions = {
    us-west          = "West US"
    us-west-2        = "West US 2"
    us-central       = "Central US"
    us-west-central  = "West Central US"
    us-south-central = "South Central US"
    us-north-central = "North Central US"
    us-east          = "East US"
    us-east-2        = "East US 2"
    eu-north         = "North Europe"
    eu-west          = "West Europe"
    de-north         = "Germany North"
    de-west-central  = "Germany West Central"
  }

  azure_regions_short = {
    us-east          = "eus"
    us-east-2        = "eus2"
    us-central       = "cus"
    us-north-central = "ncus"
    us-south-central = "nsus"
    us-west-central  = "wcus"
    us-west          = "wus"
    us-west-2        = "wus2"
    eu-north         = "ne"
    eu-west          = "we"
    de-north         = "gn"
    de-west-central  = "gwc"
  }
}

variable "azure_region" {
  default = "eu-west"
}

variable "env" {
  type = string
}

variable "azure_resource_group_name" {
  type = string
}