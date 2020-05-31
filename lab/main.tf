provider "azurerm" {
    version = "=1.38.0"

    subscription_id = var.authentication.subscription_id
    client_id       = var.authentication.client_id
    client_secret   = var.authentication.client_secret
    tenant_id       = var.authentication.tenant_id
}

# Create dedicated resource group
resource "azurerm_resource_group" "rg" {
    name     = "${var.prefix}-rg"
    location = var.location
    tags     = var.tags
}

# Create underlying log analytics workspace for sentinel
resource "azurerm_log_analytics_workspace" "rgcore-management-la" {
  name                = "${var.prefix}-la"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  depends_on          = [azurerm_resource_group.rg]
}

# Deploy sentinel
resource "azurerm_log_analytics_solution" "la-opf-solution-sentinel" {
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.rgcore-management-la.id
  workspace_name        = azurerm_log_analytics_workspace.rgcore-management-la.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
  depends_on            = [azurerm_log_analytics_workspace.rgcore-management-la]
}

# Create lab virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    tags                = var.tags
    depends_on          = [azurerm_log_analytics_solution.la-opf-solution-sentinel]
}

# Create network security group and rules
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.prefix}-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
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
    name                        = "${var.prefix}-subnet"
    resource_group_name         = azurerm_resource_group.rg.name
    virtual_network_name        = azurerm_virtual_network.vnet.name
    address_prefix              = "10.0.1.0/24"
    network_security_group_id   = azurerm_network_security_group.nsg.id
    depends_on                  = [azurerm_network_security_group.nsg]
}

# Create storage account
resource "azurerm_storage_account" "storageaccount" {
  name                     = "${var.prefix}sablobstrg01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  depends_on               = [azurerm_subnet.subnet]
}

# Create blob storage container for post configuration files
resource "azurerm_storage_container" "blobstorage" {
  name                  = "${var.prefix}-store1"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.storageaccount]
}

# Create storage blob for install-utilities.ps1 file
resource "azurerm_storage_blob" "utilsblob" {
  depends_on             = [azurerm_storage_container.blobstorage]
  name                   = "install-utilities.ps1"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.blobstorage.name
  type                   = "block"
  source                 =  "./files/install-utilities.ps1"
}

# Create storage blob for create-ad.ps1 file
resource "azurerm_storage_blob" "adblob" {
  depends_on             = [azurerm_storage_blob.utilsblob]
  name                   = "create-ad.ps1"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.blobstorage.name
  type                   = "block"
  source                 =  "./files/create-ad.ps1"
}

# Create blob storage container for whitelisting files
resource "azurerm_storage_container" "whiteliststorage" {
  name                  = "${var.prefix}-store2"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_blob.adblob]
}

# Create storage blob for process create whitelist file
resource "azurerm_storage_blob" "pcwhitelist" {
  depends_on             = [azurerm_storage_container.whiteliststorage]
  name                   = "process_create_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/process_create_whitelist.csv"
}

# Create storage blob for dns whitelist file
resource "azurerm_storage_blob" "dnswhitelist" {
  depends_on             = [azurerm_storage_blob.pcwhitelist]
  name                   = "dns_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/dns_whitelist.csv"
}

# Create storage blob for file access whitelist file
resource "azurerm_storage_blob" "fawhitelist" {
  depends_on             = [azurerm_storage_blob.dnswhitelist]
  name                   = "file_access_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/file_access_whitelist.csv"
}

# Create storage blob for file create whitelist file
resource "azurerm_storage_blob" "fcwhitelist" {
  depends_on             = [azurerm_storage_blob.fawhitelist]
  name                   = "file_create_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/file_create_whitelist.csv"
}


# Create storage blob for image load whitelist file
resource "azurerm_storage_blob" "ilwhitelist" {
  depends_on             = [azurerm_storage_blob.fcwhitelist]
  name                   = "image_load_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/image_load_whitelist.csv"
}

# Create storage blob for network whitelist file
resource "azurerm_storage_blob" "netwhitelist" {
  depends_on             = [azurerm_storage_blob.ilwhitelist]
  name                   = "network_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/network_whitelist.csv"
}

# Create storage blob for pipe whitelist file
resource "azurerm_storage_blob" "pipewhitelist" {
  depends_on             = [azurerm_storage_blob.netwhitelist]
  name                   = "pipe_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/pipe_whitelist.csv"
}

# Create storage blob for process access whitelist file
resource "azurerm_storage_blob" "pawhitelist" {
  depends_on             = [azurerm_storage_blob.pipewhitelist]
  name                   = "process_access_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/process_access_whitelist.csv"
}

# Create storage blob for registry whitelist file
resource "azurerm_storage_blob" "regwhitelist" {
  depends_on             = [azurerm_storage_blob.pawhitelist]
  name                   = "registry_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/registry_whitelist.csv"
}

# Create storage blob for remote thread whitelist file
resource "azurerm_storage_blob" "rtwhitelist" {
  depends_on             = [azurerm_storage_blob.pawhitelist]
  name                   = "remote_thread_whitelist.csv"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.whiteliststorage.name
  type                   = "block"
  source                 =  "./files/remote_thread_whitelist.csv"
}

# Create public ip for domain controller 1
resource "azurerm_public_ip" "dc1_publicip" {
    name                         = "${var.workstations.dc1}-external"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Dynamic"
    tags                         = var.tags
    depends_on                   = [azurerm_storage_blob.rtwhitelist]
}

# Create network interface for domain controller 1
resource "azurerm_network_interface" "dc1_nic" {
    name                      = "${var.workstations.dc1}-primary"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rg.name
    network_security_group_id = azurerm_network_security_group.nsg.id
    tags                      = var.tags

    ip_configuration {
        name                          = "${var.workstations.dc1}-nic-conf"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = azurerm_public_ip.dc1_publicip.id
    }
    depends_on = [azurerm_public_ip.dc1_publicip]
}

# Deploy domain controller 1
resource "azurerm_virtual_machine" "dc1" {
  name                          = var.workstations.dc1
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_ids         = ["${azurerm_network_interface.dc1_nic.id}"]
  vm_size                       = var.workstations.vm_size
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
    name              = "${var.workstations.dc1}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.workstations.dc1
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
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_machine_name = azurerm_virtual_machine.dc1.name
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  tags                 = var.tags
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.storageaccount.name}.blob.core.windows.net/${azurerm_storage_container.blobstorage.name}/create-ad.ps1"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File create-ad.ps1"
    }
SETTINGS
  depends_on = [azurerm_virtual_machine.dc1]
}
 
# Create public IP for workstation 1
resource "azurerm_public_ip" "pc1_publicip" {
  name                         = "${var.workstations.pc1}-external"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method            = "Dynamic"
  tags                         = var.tags
  depends_on                   = [azurerm_virtual_machine_extension.create_ad]
}

# Create network interface for workstation 1
resource "azurerm_network_interface" "pc1_nic" {
  name                      = "${var.workstations.pc1}-primary"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id
  tags                      = var.tags#
  ip_configuration {
      name                          = "${var.workstations.pc1}-nic-conf"
      subnet_id                     = azurerm_subnet.subnet.id
      private_ip_address_allocation = "dynamic"
      public_ip_address_id          = azurerm_public_ip.pc1_publicip.id
  }
  depends_on = [azurerm_public_ip.pc1_publicip]
}

# Create workstation 1
resource "azurerm_virtual_machine" "pc1" {
  name                  = var.workstations.pc1
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = ["${azurerm_network_interface.pc1_nic.id}"]
  vm_size               = var.workstations.vm_size
  tags                  = var.tags

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = var.workstations.os_manufacturer
    offer     = var.workstations.os_type
    sku       = var.workstations.os_sku
    version   = var.workstations.os_version
  }

  storage_os_disk {
    name              = "${var.workstations.pc1}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.workstations.pc1
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
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_machine_name = azurerm_virtual_machine.pc1.name
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  tags                 = var.tags
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.storageaccount.name}.blob.core.windows.net/${azurerm_storage_container.blobstorage.name}/install-utilities.ps1"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-utilities.ps1"
    }
SETTINGS
  depends_on = [azurerm_storage_blob.utilsblob]
}
