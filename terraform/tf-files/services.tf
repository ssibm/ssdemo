# Create Key Protect service
resource "ibm_resource_instance" "key_protect" {
  name = "${var.keyprotect["name"]}"
  service = "kms"
  plan = "tiered-pricing"
  location = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"

  provisioner "local-exec" {
    command = "chmod +x ./appid.sh && ./appid.sh"
    environment {
      APIKEY = "${var.apikey}"
      KEYPROTECT = "${ibm_resource_instance.key_protect.id}"
      KEY_NAME = "${var.keyprotect["keyname"]}"
      KEY_DESCRIPTION = "${var.keyprotect["keydescription"]}"
      KEY_PAYLOAD = "${var.keyprotect["keypayload"]}"
      CLUSTER = "${ibm_container_cluster.cluster.name}"
      REGION = "${var.region}"
    }
  }
}

# Create IBM AppID service
resource "ibm_service_instance" "appid" {
  name = "${var.appid}"
  space_guid = "${data.ibm_space.spacedata.id}"
  service = "AppID"
  plan = "lite"

  provisioner "local-exec" {
    command = "chmod +x ./appid.sh && ./appid.sh"
    environment {
      APIKEY = "${var.apikey}"
      EMAIL = "${var.appid_user["email"]}"
      PASSWORD = "${var.appid_user["password"]}"
      FIRST = "${var.appid_user["first"]}"
      LAST = "${var.appid_user["last"]}"
      TENANT = "${ibm_service_instance.appid.id}"
      DOMAIN = "sockstore.${ibm_container_cluster.cluster.name}.${var.region}.containers.appdomain.cloud/appid_callback"
    }
  }
}
