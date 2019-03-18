data "ibm_dns_domain" "main" {
    name = "${var.dns_domain}"
}

resource "ibm_dns_record" "cname" {
    data = "${ibm_container_cluster.ibmcluster_test.ingress_hostname}."
    domain_id = "${data.ibm_dns_domain.main.id}"
    host = "${var.cname_host}"
    ttl = 900
    type = "cname"
}
