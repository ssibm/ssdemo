resource "ibm_network_vlan" "private" {
  count       = "${length(var.zones)}"
  name        = "${local.pfx}-${element(var.zones, count.index)}-pri"
  datacenter  = "${element(var.zones, count.index)}"
  type        = "PRIVATE"
}

resource "ibm_network_vlan" "public" {
  count       = "${length(var.zones)}"
  name        = "${local.pfx}-${element(var.zones, count.index)}-pub"
  datacenter  = "${element(var.zones, count.index)}"
  type        = "PUBLIC"
}

resource "ibm_resource_instance" "key_protect" {
  name = "${local.pfx}-${var.keyprotect["name"]}"
  service = "kms"
  plan = "tiered-pricing"
  location = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
}

resource "ibm_container_cluster" "cluster" {
  name              = "${local.pfx}-${var.cluster_name}"
  region            = "${var.region}"
  datacenter        = "${var.zones[0]}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"

  private_vlan_id   = "${ibm_network_vlan.private.0.id}"
  public_vlan_id    = "${ibm_network_vlan.public.0.id}"

  hardware          = "shared"
  machine_type      = "u2c.2x4"
  default_pool_size = 1
  disk_encryption   = true
  kube_version      = "${var.kube_version}"
  billing           = "${var.billing}"

  depends_on        =
  [
    "ibm_network_vlan.private",
    "ibm_network_vlan.public",
    "ibm_resource_instance.key_protect"
  ]

  provisioner "local-exec" {
    command = "bash scripts/keyprotect.sh"
    environment {
      APIKEY = "${var.ibm_bx_api_key}"
      KEYPROTECT = "${ibm_resource_instance.key_protect.id}"
      KEY_NAME = "${ibm_resource_instance.key_protect.name}-key"
      KEY_DESCRIPTION = "${var.keyprotect["description"]}"
      KEY_PAYLOAD = "${var.keyprotect["payload"]}"
      CLUSTER = "${ibm_container_cluster.cluster.name}"
      REGION = "${var.region}"
    }
  }

  provisioner "local-exec"{
    command = "ibmcloud ks logging-config-create ${ibm_container_cluster.cluster.id} --logsource worker --type ibm"
  }

  provisioner "local-exec"{
    command = "ibmcloud ks logging-config-create ${ibm_container_cluster.cluster.id} --logsource kubernetes --type ibm"
  }

  provisioner "local-exec"{
    command = "ibmcloud ks logging-config-create ${ibm_container_cluster.cluster.id} --logsource ingress --type ibm"
  }
}

resource "ibm_container_worker_pool" "pool_1" {
  region            = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  cluster           = "${ibm_container_cluster.cluster.name}"

  worker_pool_name  = "${local.pfx}-shared-small"
  machine_type      = "u2c.2x4"
  hardware          = "shared"
  size_per_zone     = 1
  disk_encryption   = true
}

resource "ibm_container_worker_pool_zone_attachment" "zones_pool_1" {
  count             = "${length(var.zones)}"
  region            = "${var.region}"
  zone              = "${element(var.zones, count.index)}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  cluster           = "${ibm_container_cluster.cluster.name}"
  worker_pool       = "${element(split("/",ibm_container_worker_pool.pool_1.id),1)}"

  private_vlan_id   = "${element(ibm_network_vlan.private.*.id, count.index)}"
  public_vlan_id    = "${element(ibm_network_vlan.public.*.id, count.index)}"

  timeouts {
    create = "90m"
    update = "3h"
    delete = "30m"
  }
}

resource "ibm_container_worker_pool" "pool_2" {
  region            = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  cluster           = "${ibm_container_cluster.cluster.name}"

  worker_pool_name  = "${local.pfx}-shared-medium-1"
  machine_type      = "b2c.4x16"
  hardware          = "shared"
  size_per_zone     = 1
  disk_encryption   = true
}

resource "ibm_container_worker_pool_zone_attachment" "zones_pool_2" {
  count             = "${length(var.zones)}"
  region            = "${var.region}"
  zone              = "${element(var.zones, count.index)}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  cluster           = "${ibm_container_cluster.cluster.name}"
  worker_pool       = "${element(split("/",ibm_container_worker_pool.pool_2.id),1)}"

  private_vlan_id   = "${element(ibm_network_vlan.private.*.id, count.index)}"
  public_vlan_id    = "${element(ibm_network_vlan.public.*.id, count.index)}"

  timeouts {
    create = "90m"
    update = "3h"
    delete = "30m"
  }
}

data "ibm_container_cluster_config" "kubectl_config" {
  cluster_name_id = "${ibm_container_cluster.cluster.name}"
  config_dir = "~/"
  download = true
  depends_on = [ "ibm_container_cluster.cluster" ]
}

output "IKS Cluster:" {
  value = "${ibm_container_cluster.cluster.name}"
}
