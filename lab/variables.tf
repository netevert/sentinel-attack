terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.40.0"
    }
  }
}


variable "authentication" {
  type = map(string)

  default = {
    subscription_id = ""
    client_id       = ""
    client_secret   = ""
    tenant_id       = ""
  }
}

variable "location" {}

variable "accounts" {
    type = map(string)

    default = {
      # workstation account
        pc1_admin_user          = ""
        pc1_admin_password      = ""
        
      # domain controller account
      dc1_admin_user          = ""
      dc1_admin_password      = ""
  }
}

variable "vm_config" {
    type = map(string)

    default = {
      # vm image configuration
        os_manufacturer = "MicrosoftWindowsDesktop"
        os_type         = "Windows-10"
        os_sku          = "rs5-pro"
        os_version      = "latest"
        vm_size         = "Standard_B2ms"
  }
}

variable "resource_group_name" {
    type = string
    default = "testlab"
}

variable "tags" {
    type = map(string)

    default = {
        environment = "testing"
  }
}
