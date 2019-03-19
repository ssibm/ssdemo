data "ibm_org" "org" {
  org = "${var.ibm_org}"
}

data "ibm_space" "spacedata" {
  space = "${var.ibm_space}"
  org   = "${var.ibm_org}"
}

data "ibm_account" "account" {
  org_guid = "${data.ibm_org.org.id}"
}

data "ibm_resource_group" "resource_group" {
  name = "${var.ibm_rg}"
}
