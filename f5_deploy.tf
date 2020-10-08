
resource "bigip_ltm_node" "knode" {
  name             = "/Common/kibana_node"
  address          = "10.157.146.32"
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"
  depends_on = [bigip_ltm_pool.kpool]
}
resource "bigip_ltm_pool" "kpool" {
  name                = "/Common/${var.env_name}.kibana-pool"
  load_balancing_mode = "round-robin"
  description         = "${var.env_name}.Kibana Pool"
  monitors            = ["/Common/tcp_half_open"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
resource "bigip_ltm_pool_attachment" "kattach_node" {
  pool = "/Common/${var.env_name}.kibana-pool"
  node = "/Common/kibana_node:5601"
  depends_on = [bigip_ltm_pool.kpool]
}


resource "bigip_ltm_virtual_server" "http" {
        pool = "/Common/${var.env_name}.kibana-pool"
        name = "/Common/${var.env_name}.kibana_vs_http"
        destination = "10.169.172.196"
        port = 443
        client_profiles = ["/Common/clientssl"]
        source_address_translation = "automap"
        depends_on = [bigip_ltm_pool.kpool]
}
