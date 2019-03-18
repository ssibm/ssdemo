data "ibm_space" "appid-spacedata" {
  space = "${var.ibm_space}"
  org   = "${var.ibm_org}"
}

# Create IBM AppId Service
resource "ibm_service_instance" "appid" {
  name = "${var.appid}"
  space_guid = "${data.ibm_space.appid-spacedata.id}"
  service    = "AppID"
  plan       = "lite"

  provisioner "local-exec" {
    command = "chmod +x ./appid.sh && ./appid.sh"
    environment {
      APIKEY = "${var.apikey}"
      EMAIL = "${var.appid_user["email"]}"
      PASSWORD = "${var.appid_user["password"]}"
      FIRST = "${var.appid_user["first"]}"
      LAST = "${var.appid_user["last"]}"
      TENANT = "${ibm_service_instance.appid.id}"
      DOMAIN = "https://${var.cname_host}.${var.dns_domain}/appid_callback"
    }
  }
}
