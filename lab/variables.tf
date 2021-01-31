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
      # workstation accounts
        pc1_admin_user          = ""
        pc1_admin_password      = ""
  }
}

variable "workstations" {
    type = map(string)

    default = {
      # Image configurations
        os_manufacturer = "MicrosoftWindowsDesktop"
        os_type         = "Windows-10"
        os_sku          = "rs5-pro"
        os_version      = "latest"
        vm_size         = "Standard_B2ms"

        # Naming configurations
        pc1             = "test-vm"
  }
}

variable "prefix" {
    type = string
    default = "testlab"
}

variable "tags" {
    type = map(string)

    default = {
        environment = "testing"
  }
}
