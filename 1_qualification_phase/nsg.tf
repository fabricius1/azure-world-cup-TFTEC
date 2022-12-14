resource "azurerm_network_security_group" "nsg" {
  name                = "nsg01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.terraform_tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_associate_subnets" {
  count = 2

  subnet_id                 = local.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "nsg_inbound_rule_windows_rdp" {
  name                        = "AllowRDPWin"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "Internet"
  destination_address_prefix  = azurerm_network_interface.network_interfaces["nic-vm-win"].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "nsg_inbound_rule_linux_ssh" {
  name                        = "AllowSSHLnx"
  priority                    = 310
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "Internet"
  destination_address_prefix  = azurerm_network_interface.network_interfaces["nic-vm-lnx"].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "nsg_inbound_rule_windows_http" {
  name                        = "AllowHTTPWin"
  priority                    = 320
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = azurerm_network_interface.network_interfaces["nic-vm-win"].private_ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
