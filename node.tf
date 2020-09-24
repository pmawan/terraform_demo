resource "bigip_ltm_node" "node" {
  name             = "/Common/kibana_node"
  address          = "10.10.10.10"
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"
  description      = "kibana_server"
  rate_limit       = "disabled"
  fqdn {
    address_family = "ipv4"
    interval       = "3000"
  }
}
