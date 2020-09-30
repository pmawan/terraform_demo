
resource "bigip_ltm_node" "node" {
  name             = "/Common/kibana_node"
  address          = "10.157.146.32"
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"
}
resource "bigip_ltm_pool" "pool" {
  name                = "/Common/${var.env}.kibana-pool"
  load_balancing_mode = "round-robin"
  description         = "${var.env}.Kibana Pool"
  monitors            = ["/Common/tcp_half_open"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
resource "bigip_ltm_pool_attachment" "attach_node" {
  pool = "/Common/${var.env}.kibana-pool"
  node = "/Common/kibana_node:5601"
  depends_on = [bigip_ltm_pool.pool]
}


resource "bigip_ltm_virtual_server" "http" {
        pool = "/Common/${var.env}.kibana-pool"
        name = "/Common/${var.env}.kibana_vs_http"
        destination = "10.169.172.196"
        port = 443
        client_profiles = ["/Common/clientssl"]
        source_address_translation = "automap"
        depends_on = [bigip_ltm_pool.pool]
}
