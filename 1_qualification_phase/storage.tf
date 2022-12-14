resource "azurerm_storage_account" "sto_acc" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.terraform_tags
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "copatftec"
  storage_account_name = azurerm_storage_account.sto_acc.name
  access_tier          = "TransactionOptimized"
  quota                = 1
}
