variable "authentication" {
  type = "map"

  default = {
    subscription_id = ""
    client_id       = ""
    client_secret   = ""
    tenant_id       = ""
  }
}

variable "location" {}

variable "accounts" {
    type = "map"

    default = {
      # workstation accounts
        pc1_admin_user          = ""
        pc1_admin_password      = ""
  }
}

variable "workstations" {
    type = "map"

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
    type = "string"
    default = "testlab"
}

variable "tags" {
    type = "map"

    default = {
        environment = "testing"
  }
}
