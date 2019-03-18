# Define variables (alphabetical order)

# GUID for IBM Cloud Account
variable account_guid {
  default = "<Your Account Guid>"
}

# IBM Cloud API Key
variable apikey {
  default = "<Your IBM Cloud API Key>"
}

variable appid {
  # Name of AppId Instance
  default = "<Name of AppId>"
}

variable appid_user {
  type = "map"
  default = {
    "email" = "<Your IBM email>"
    "password" = "<Choose a password>"
    "first" = "<your first name>"
    "last" = "<your last name>"
  }
}

variable cluster {
  # Name of Cluster to be created
  default = "<Your desired cluster name>"
}

variable cluster_namespace {
  # Namespace to deploy sockstore within cluster
  # Leave on default for now
  default = "default"
}

variable cname_host {
  # Name of subdomain to be created, and prepended before dns_domain
  default = "<Subdomain>"
}

variable dc1 {
  # Name of datacenter
  default = "dal13"
}

variable dns_domain {
  # Name of existing DNS Domain
  default = "<DNS Domain>.<Top Level Domain (.com, .net, etc.)>"
}

variable ibm_org {
  # Name of Your Organization on IBM Cloud
  default = "<IBM Organization>"
}

variable ibm_space {
  # Name of Space within Organization on IBM Cloud
  default = "<IBM Space>"
}

variable private_vlan {
  # Name of Private VLAN to be created
  default = "<Name of desired private VLAN>"
}

variable public_vlan {
  # Name of Public VLAN to be created
  default = "<Name of desired public VLAN>"
}

variable subnet_size {
  default = "32"
}

variable worker_num {
  default = "2"
}
