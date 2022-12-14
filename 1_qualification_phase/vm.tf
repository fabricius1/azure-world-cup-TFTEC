#######################################
# VIRTUAL MACHINE RESOURCES - WINDOWS #
#######################################

resource "azurerm_public_ip" "public_ips" {
  for_each = {
    for v in var.machines : "pip-vm-${v}" => "pip-vm-${v}01"
  }

  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = local.terraform_tags
}

resource "azurerm_network_interface" "network_interfaces" {
  for_each = {
    for i, v in var.machines : "nic-vm-${v}" => [i, "nic-vm-${v}01"]
  }

  name                = each.value[1]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnets[each.value[0]].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = local.public_ips[each.value[0]].id
  }

  tags = local.terraform_tags
}


# resource "azurerm_network_interface" "nic_vm_windows" {
#   name                = "nic-vm-win01"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = local.subnets[0].id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip_vm_windows.id
#   }

#   tags = local.terraform_tags
# }

# resource "azurerm_network_interface" "nic_vm_linux" {
#   name                = "nic-vm-lnx01"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = local.subnets[1].id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip_vm_linux.id
#   }

#   tags = local.terraform_tags
# }

resource "azurerm_windows_virtual_machine" "vm_windows" {
  name                = "vm-win01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.network_interfaces["nic-vm-win"].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = local.terraform_tags
}

#####################################
# VIRTUAL MACHINE RESOURCES - LINUX #
#####################################

# resource "azurerm_public_ip" "pip_vm_linux" {
#   name                = "pip-vm-lnx01"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = var.location
#   allocation_method   = "Dynamic"

#   tags = local.terraform_tags
# }

resource "azurerm_linux_virtual_machine" "vm_linux" {
  name                = "vm-lnx01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  # admin_password                  = var.password
  # disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network_interfaces["nic-vm-lnx"].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("./.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = local.terraform_tags
}