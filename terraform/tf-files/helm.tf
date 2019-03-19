provider "helm" {
  kubernetes {
    config_path = "${data.ibm_container_cluster_config.cluster_config.config_dir}${sha1("${data.ibm_container_cluster_config.cluster_config.cluster_name_id}")}_${data.ibm_container_cluster_config.cluster_config.cluster_name_id}_k8sconfig/config.yml"
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
    "${file("../../sockstore/deploy/kubernetes/helm-chart/overwrite-values.yaml")}"
  ]
  set {
    name = "appid.alias"
    value = "${ibm_service_instance.appid.name}"
  }
  set {
    name = "ingress.subdomain"
    value = "sockstore"
  }
  set {
    name = "ingress.host"
    value = "${ibm_container_cluster.cluster.name}.${var.region}.containers.appdomain.cloud"
  }

  provisioner "local-exec" {
    command = "ibmcloud resource service-alias-create '${ibm_service_instance.appid.name}' --instance-name '${ibm_service_instance.appid.name}' -s '${data.ibm_space.spacedata.id}'"
  }

  provisioner "local-exec" {
    command = "ibmcloud ks cluster-service-bind ${ibm_container_cluster.cluster.name} ${var.cluster_namespace} ${ibm_service_instance.appid.name}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "ibmcloud ks cluster-service-unbind --cluster ${ibm_container_cluster.cluster.name} --namespace ${var.cluster_namespace} --service ${ibm_service_instance.appid.name}"
  }
}
