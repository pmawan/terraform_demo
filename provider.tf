variable address {}
variable username {}
variable password {}

provider "bigip" {
  address = var.address
  username = var.username
  password = var.password
}
