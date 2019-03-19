resource "ibm_container_cluster" "cluster" {
  name = "${var.cluster}"
  datacenter = "dal12"
  machine_type = "u2c.2x4"
  hardware = "shared"
  public_vlan_id  = "${ibm_network_vlan.public_vlan.id}"
  private_vlan_id = "${ibm_network_vlan.private_vlan.id}"
  disk_encryption = true

  # default_pool_size = 1

  account_guid = "${data.ibm_account.account.org_guid}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"

  region = "us-south"

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

resource "ibm_container_worker_pool" "worker_pool" {
  worker_pool_name = "mz_pool"
  machine_type = "u2c.2x4"
  cluster = "${ibm_container_cluster.cluster.name}"
  size_per_zone = 2
  hardware = "shared"
  disk_encryption = true

  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
}

resource "ibm_container_worker_pool_zone_attachment" "us_zone" {
  cluster = "${ibm_container_cluster.cluster.name}"
  worker_pool = "${element(split("/",ibm_container_worker_pool.worker_pool.id),1)}"
  zone = "dal12"
  region = "${var.region}"
  public_vlan_id  = "${ibm_network_vlan.public_vlan.id}"
  private_vlan_id = "${ibm_network_vlan.private_vlan.id}"

  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
}

resource "ibm_container_worker_pool_zone_attachment" "us_zone_2" {
  cluster = "${ibm_container_cluster.cluster.name}"
  worker_pool = "${element(split("/",ibm_container_worker_pool.worker_pool.id),1)}"
  zone = "dal13"
  region = "${var.region}"

  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
}

data "ibm_container_cluster_config" "cluster_config" {
  account_guid = "data.ibm_account.account.org_guid"
  cluster_name_id = "${ibm_container_cluster.cluster.name}"
  config_dir = "./"
  download = true
}
