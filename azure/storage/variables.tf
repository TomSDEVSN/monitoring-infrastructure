variable "global_settings" {
  default = {}
}

variable "storage_accounts" {
  default = {}
}

variable "tags" {
  default   = null
  type      = map(any)
}