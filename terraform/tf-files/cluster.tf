resource "ibm_container_cluster" "ibmcluster_test" {
  name            = "${var.cluster}"
  datacenter      = "${var.dc1}"
  machine_type    = "u2c.2x4"
  hardware        = "shared"
  public_vlan_id  = "${ibm_network_vlan.public_vlan.id}"
  private_vlan_id = "${ibm_network_vlan.private_vlan.id}"
  worker_num      = "${var.worker_num}"

  account_guid = "${var.account_guid}"
}

data "ibm_container_cluster_config" "ibmcluster_test_config" {
  account_guid = "${var.account_guid}"
  cluster_name_id = "${ibm_container_cluster.ibmcluster_test.name}"
  config_dir = "./"
  download = true
}

provider "helm" {
  kubernetes {
    config_path = "${data.ibm_container_cluster_config.ibmcluster_test_config.config_dir}${sha1("${data.ibm_container_cluster_config.ibmcluster_test_config.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_test_config.cluster_name_id}_k8sconfig/config.yml"
  }
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "stable/cert-manager"
  namespace = "kube-system"
}

resource "helm_release" "sockstore-app" {
  name       = "sockstore-app"
  repository = "../../sockstore/deploy/kubernetes"
  chart      = "helm-chart"
  namespace  = "${var.cluster_namespace}"
  values     = [
    "${file("values.yaml")}"
  ]
  set {
    name = "appid.alias"
    value = "${ibm_service_instance.appid.name}"
  }
  set {
    name = "ingress.subdomain"
    value = "${var.dns_domain}"
  }
  set {
    name = "ingress.host"
    value = "${var.cname_host}"
  }

  provisioner "local-exec" {
    command = "ibmcloud ks cluster-service-bind ${var.cluster} ${var.cluster_namespace} ${var.appid}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "ibmcloud ks cluster-service-unbind --cluster ${var.cluster} --namespace ${var.cluster_namespace} --service ${var.appid}"
  }
}
