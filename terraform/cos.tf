# Cloud Object Storage
resource "ibm_resource_instance" "cos" {
  name              = "${local.pfx}-${var.cos_name}"
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  parameters = {
    "HMAC" = true
  }
}

resource "ibm_resource_key" "cos_key" {
  name                 = "${local.pfx}-${var.cos_name}-key"
  role                 = "Manager"
  resource_instance_id = "${ibm_resource_instance.cos.id}"
  parameters = {
    "HMAC" = true
  }
  timeouts {
    create = "15m"
    delete = "15m"
  }
}
