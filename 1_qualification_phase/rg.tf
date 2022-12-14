resource "azurerm_resource_group" "rg" {
  name     = "rg-hml"
  location = var.location

  tags = local.terraform_tags
}

resource "azurerm_resource_group" "rg_nw" {
  name     = "NetworkWatcherRG"
  location = var.location

  tags = local.terraform_tags
}