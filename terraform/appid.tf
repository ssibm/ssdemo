resource "ibm_resource_instance" "appid" {
  name              = "${local.pfx}-${var.appid_name}"
  service           = "appid"
  plan              = "graduated-tier"
  location          = "${var.region}"

  provisioner "local-exec" {
    command = "sh scripts/appid.sh"
    environment {
      APIKEY = "${var.ibm_bx_api_key}"
      EMAIL = "${var.appid_user["email"]}"
      PASSWORD = "${var.appid_user["password"]}"
      FIRST = "${var.appid_user["first"]}"
      LAST = "${var.appid_user["last"]}"
      TENANT = "${ibm_resource_instance.appid.id}"
      DOMAIN = "${var.app_name}.${local.pfx}-${var.cluster_name}.${var.region}.containers.appdomain.cloud/appid_callback"
    }
  }
}
