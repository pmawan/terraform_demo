resource "bigip_ltm_pool" "pool" {
  name                = "/Common/kibana-pool"
  load_balancing_mode = "round-robin"
  description         = "Kibana Pool"
  monitors            = [bigip_ltm_monitor.monitor.name, bigip_ltm_monitor.monitor2.name]
  allow_snat          = "yes"
  allow_nat           = "yes"
}
