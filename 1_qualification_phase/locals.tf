locals {
  terraform_tags = {
    created_by = "terraform"
  }

  subnets    = [for subnet in azurerm_subnet.subnets : subnet]
  public_ips = [for public_ip in azurerm_public_ip.public_ips : public_ip]

}