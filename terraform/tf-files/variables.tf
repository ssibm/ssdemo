# Define variables (alphabetical order)

variable cluster {
  # Name of Cluster to be created
  default = "tf-hdngo-001"
}

variable dc1 {
  # Name of datacenter
  default = "dal12"
}

variable ibm_org {
  # Name of Your Organization on IBM Cloud
  default = "WDP Customer Success"
}

variable ibm_rg {
  default = "default"
}

variable private_vlan {
  # Name of Private VLAN to be created
  default = "tf-pri-hdngo-001"
}

variable public_vlan {
  # Name of Public VLAN to be created
  default = "tf-pub-hdngo-001"
}
