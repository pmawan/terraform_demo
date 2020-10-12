locals {
  name = "world"
}
data "template_file" "irule_file"{
  template = "${file("rules_whitelist.tcl")}"
  vars = {
        r_name = "dev_rule"
  }

}
output "rlname" {

  value = "${data.template_file.irule_file.rendered}"
}

resource "bigip_ltm_node" "node" {
  count = length(var.pcon_tns_url)
  name             = "/Common/${var.pcon_tns_url[count.index]}"
  address          = var.pcon_tns_url[count.index]
  connection_limit = "0"
  dynamic_ratio    = "1"
  

}

resource "bigip_ltm_datagroup" "datagroup" {
  name = "/Common/dev.outbound.gateway.mastercard.int-YYY-whitelisted-datagroup"
  type = "ip"

  record {
    name  = "10.169.160.0/19"
    data = ""
  }

}

resource "bigip_ltm_irule" "rule" {
  name  = "/Common/${var.env_name}.outbound.gateway.mastercard.int-YYY-whitelist-rule"
  irule = <<EOF
  ${data.template_file.irule_file.rendered}
  EOF
}

resource "bigip_ltm_pool" "pool" {
  count = length(var.vname)
  name                = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-pool"
  load_balancing_mode = "round-robin"
  monitors            = ["/Common/tcp_half_open"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

resource "bigip_ltm_pool_attachment" "attach_node" {
  count = length(var.vname)
  pool = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-pool"
  node = "/Common/${var.pcon_tns_url[0]}:443"
  depends_on = [bigip_ltm_pool.pool, bigip_ltm_node.node]
}


resource "bigip_ltm_virtual_server" "https" {
  count                      = length(var.vname)
  pool                       = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-pool"
  name                       = "/Common/${var.env_name}.outbound.gateway.mastercard.int-dev-YYY-${var.vname[count.index]}-virtual"
  destination                = var.vip_ip
  port                       = var.vpconport[count.index]
  profiles        = ["/Common/tcp", "/Common/http"]
  client_profiles = ["/Common/clientssl"]
  server_profiles = ["/Common/serverssl"]
  source_address_translation = "automap"
  irules                     = ["/Common/${var.env_name}.outbound.gateway.mastercard.int-YYY-whitelist-rule"]
  depends_on                 = [bigip_ltm_pool.pool, bigip_ltm_irule.rule]
}
