resource "azurerm_lb" "lb" {
    for_each = var.lb-name
  name                = each.value.lb-name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = each.value.f-name
    public_ip_address_id = data.azurerm_public_ip.pip-blk[each.key].id
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backend-pool" {
    for_each = var.lb-name
  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = each.value.b-name
}
resource "azurerm_lb_backend_address_pool_address" "bck-blk1" {
    for_each = var.lb-name
  name                    = each.value.b-name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.backend-pool-ad[each.key].id
  virtual_network_id      = data.azurerm_virtual_network.vnet-blk[each.key].id
  ip_address              = data.azurerm_network_interface.nic-blk-pp[each.key].private_ip_address 
  

}
resource "azurerm_lb_backend_address_pool_address" "bck-blk2" {
    for_each = var.lb-name
  name                    = each.value.b1-name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.backend-pool-ad[each.key].id
  virtual_network_id      = data.azurerm_virtual_network.vnet-blk[each.key].id
  ip_address              = data.azurerm_network_interface.nic-blk-kp[each.key].private_ip_address 
}

resource "azurerm_lb_rule" "lb-rule" {
    for_each = var.lb-name
  loadbalancer_id                = azurerm_lb.lb[each.key].id
  name                           = each.value.rule-name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
}

resource "azurerm_lb_probe" "hp" {
    for_each = var.lb-name
  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = "ssh-running-probe"
  port            = 80
}