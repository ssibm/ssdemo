# Create new vlans
resource "ibm_network_vlan" "private_vlan" {
   name = "${var.private_vlan}"
   datacenter = "${var.dc1}"
   type = "PRIVATE"
   router_hostname = "bcr01a.${var.dc1}"
}

resource "ibm_network_vlan" "public_vlan" {
   name = "${var.public_vlan}"
   datacenter = "${var.dc1}"
   type = "PUBLIC"
   router_hostname = "fcr01a.${var.dc1}"
}
