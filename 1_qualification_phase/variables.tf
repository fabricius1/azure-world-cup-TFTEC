variable "location" {
  description = "The location where the resources should be created"
  type        = string
  default     = "uksouth"
}

variable "password" {
  type      = string
  sensitive = true
}

variable "storage_account_name" {
  type = string
}

variable "admin_username" {
  type      = string
  sensitive = true
}

variable "machines" {
  type    = list(string)
  default = ["win", "lnx"]
}
