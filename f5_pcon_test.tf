resource "bigip_ltm_node" "node" {
  count = length(var.pcon_tns_url)
  name             = "/Common/YYY-${var.pcon_tns_url[count.index]}"
  address          = var.pcon_tns_url[count.index]
  connection_limit = "0"
  dynamic_ratio    = "1"

}

resource "bigip_ltm_irule" "rule" {
  name  = "/Common/${var.env_name}.outbound.gateway.mastercard.int-YYY-whitelist-rule"
  irule = file("rules_whitelist.tcl")
}

resource "bigip_ltm_pool" "pool" {
  count = length(var.vname)
  name                = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-pool"
  load_balancing_mode = "round-robin"
  monitors            = ["/Common/terraform_monitor"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

resource "bigip_ltm_pool_attachment" "attach_node" {
  count = length(var.vname)
  pool = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-pool"
  node = "/Common/${var.pcon_tns_url[0]}:${var.vpconport[count.index]}"
  depends_on = [bigip_ltm_pool.pool]
}


resource "bigip_ltm_virtual_server" "https" {
  count                      = length(var.vname)
  pool                       = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-pool"
  name                       = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-virtual"
  destination                = var.vip_ip
  port                       = var.vpconport[count.index]
  client_profiles = ["/Common/clientssl"]
  server_profiles = ["/Common/serverssl"]
  source_address_translation = "automap"
  depends_on                 = [bigip_ltm_pool.pool]
}
