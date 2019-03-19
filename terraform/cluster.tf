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
}

output "IKS Cluster:" {
  value = "${ibm_container_cluster.cluster.name}"
}
