variable "env" {
    type = string
    default = "dev"
}
variable "env_name" {
    type = string
    default = "dev"
}
variable "vname" {
    type = list
    default = ["natp", "dine", "disc", "rbsi", "comp", "cmps", "npyt", "nglo"]
}
variable "vpconport" {
    type = list
    default = ["98765", "98764", "98763", "98762", "98761", "98766", "98767", "98768"]
}
variable "pname" {
    type = list
    default = ["p1", "p2"]
}
variable "pcon_tns_url" {
    type = list
    default = ["e31232.a.akamaiedge.net", "jenkins.io"]
}
variable "vip_ip" {
    default = "10.10.10.20"
}
