variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default     = "eastus"
  description = "East US"
}

variable "rgName" {
  default     = "capic2502"
  description = "Cloud APIC resource group"
}

variable "deployName" {
  default = "capic"
}

variable "vnetName" {
  default     = "vrf1"
  description = "vnet created by Terraform"
}




variable "nsgName" {
  default = "nsg1"
}

variable "admin_username" {
  type    = string
  default = "cisco"
}

variable "admin_password" {
  type    = string
  default = "123Cisco123!"
}

variable "vmName" {
  type    = string
  default = "epg1"
}