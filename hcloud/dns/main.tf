terraform {
  required_providers {
    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "1.0.6"
    }
  }
  required_version = ">= 0.13"
}

provider "hetznerdns" {
  apitoken = var.hetzner_dns_token
}