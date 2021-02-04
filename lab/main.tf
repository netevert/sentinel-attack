# Set up provider
provider "azurerm" {
    features {}
    subscription_id = var.authentication.subscription_id
    client_id       = var.authentication.client_id
    client_secret   = var.authentication.client_secret
    tenant_id       = var.authentication.tenant_id
}

# Create lab virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.resource_group_name}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = var.resource_group_name
    dns_servers         = ["10.0.1.4", "8.8.8.8"]
    tags                = var.tags
}

# Create network security group and rules
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.resource_group_name}-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name
    tags                = var.tags
    depends_on          = [azurerm_virtual_network.vnet]

    security_rule {
        name                       = "RDP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SSH"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTP-inbound"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPS-inbound"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTP-outbound"
        priority                   = 104
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPS-outbound"
        priority                   = 105
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create lab subnet
resource "azurerm_subnet" "subnet" {
    name                        = "${var.resource_group_name}-subnet"
    resource_group_name         = var.resource_group_name
    virtual_network_name        = azurerm_virtual_network.vnet.name
    address_prefixes            = ["10.0.1.0/24"]
    depends_on                  = [azurerm_network_security_group.nsg]
}

# Create public ip for domain controller 1
resource "azurerm_public_ip" "dc1_publicip" {
    name                         = "${var.resource_group_name}-dc-publicip"
    location                     = var.location
    resource_group_name          = var.resource_group_name
    allocation_method            = "Dynamic"
    tags                         = var.tags
    depends_on                   = [azurerm_subnet.subnet]
}

# Create network interface for domain controller 1
resource "azurerm_network_interface" "dc1_nic" {
    name                      = "${var.resource_group_name}-dc-nic"
    location                  = var.location
    resource_group_name       = var.resource_group_name
    tags                      = var.tags

    ip_configuration {
        name                          = "${var.resource_group_name}-dc-nic-conf"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.1.4"
        public_ip_address_id          = azurerm_public_ip.dc1_publicip.id
    }
    depends_on = [azurerm_public_ip.dc1_publicip]
}

# Deploy domain controller 1
resource "azurerm_virtual_machine" "dc1" {
  name                          = "${var.resource_group_name}-dc"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  network_interface_ids         = [azurerm_network_interface.dc1_nic.id]
  vm_size                       = var.vm_config.vm_size
  tags                          = var.tags

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_group_name}-dc-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_group_name}-dc"
    admin_username = var.accounts.dc1_admin_user
    admin_password = var.accounts.dc1_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.accounts.dc1_admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.accounts.dc1_admin_user}</Username></AutoLogon>"
    }
  }
  depends_on = [azurerm_network_interface.dc1_nic]
}

# Create active directory domain forest
resource "azurerm_virtual_machine_extension" "create_ad" {
  name                 = "create_ad"
  virtual_machine_id   = azurerm_virtual_machine.dc1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  tags                 = var.tags
  protected_settings = <<PROT
    {
      "fileUris": ["https://raw.githubusercontent.com/BlueTeamLabs/sentinel-attack/master/lab/files/create-ad.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File create-ad.ps1 ${var.accounts.dc1_admin_password} ${var.resource_group_name}.com ${var.resource_group_name}"
    }
  PROT
  depends_on = [azurerm_virtual_machine.dc1]
}
 
# Create public IP for workstation 1
resource "azurerm_public_ip" "pc1_publicip" {
  name                         = "${var.resource_group_name}-pc-publicip"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = "Dynamic"
  tags                         = var.tags
  depends_on                   = [azurerm_virtual_machine_extension.create_ad]
}

# Create network interface for workstation 1
resource "azurerm_network_interface" "pc1_nic" {
  name                      = "${var.resource_group_name}-pc-nic"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tags                      = var.tags
  ip_configuration {
      name                          = "${var.resource_group_name}-pc-nic-conf"
      subnet_id                     = azurerm_subnet.subnet.id
      private_ip_address_allocation = "dynamic"
      public_ip_address_id          = azurerm_public_ip.pc1_publicip.id
  }
  depends_on = [azurerm_public_ip.pc1_publicip]
}

# Create workstation 1
resource "azurerm_virtual_machine" "pc1" {
  name                  = "${var.resource_group_name}-pc"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.pc1_nic.id]
  vm_size               = var.vm_config.vm_size
  tags                  = var.tags

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.vm_config.os_manufacturer
    offer     = var.vm_config.os_type
    sku       = var.vm_config.os_sku
    version   = var.vm_config.os_version
  }

  storage_os_disk {
    name              = "${var.resource_group_name}-pc-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_group_name}-pc"
    admin_username = var.accounts.pc1_admin_user
    admin_password = var.accounts.pc1_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.accounts.pc1_admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.accounts.pc1_admin_user}</Username></AutoLogon>"
    }
  }
  depends_on = [azurerm_network_interface.pc1_nic]
}
 
# Install utilities on workstation 1 and join domain
resource "azurerm_virtual_machine_extension" "utils_pc1" {
  name                 = "utils_pc1"
  virtual_machine_id = azurerm_virtual_machine.pc1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  tags                 = var.tags
  protected_settings = <<PROT
    {
      "fileUris": ["https://raw.githubusercontent.com/BlueTeamLabs/sentinel-attack/master/lab/files/install-utilities.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-utilities.ps1 ${var.resource_group_name}.com ${var.accounts.dc1_admin_password} ${var.resource_group_name}.com\\${var.accounts.dc1_admin_user}"
    }
  PROT
  depends_on = [azurerm_virtual_machine.pc1]
}
