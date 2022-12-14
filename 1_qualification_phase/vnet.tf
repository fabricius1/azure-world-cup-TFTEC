resource "azurerm_network_watcher" "net_watcher" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = azurerm_resource_group.rg_nw.name
  location            = var.location

  tags = local.terraform_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-hml"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  depends_on = [
    azurerm_network_watcher.net_watcher
  ]

  tags = local.terraform_tags
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    for i, v in ["srv", "db"] : "subnet${i + 1}" => [i + 1, "sub-${v}01"]
  }
  name                 = each.value[1]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.${each.value[0]}.0/24"]
}