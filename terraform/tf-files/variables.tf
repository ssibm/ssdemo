# Define variables (alphabetical order)

# IBM Cloud API Key
variable apikey {
  default = "7tpAQQx8FuyytWS7fr5eRoUpAgVq8BbcJKNXgJa-_XbP"
}

# AppID instance
variable appid {
  default = "appid-hdngo-001"
}

# AppID user to be created
variable appid_user {
  type = "map"
  default = {
    "email" = "hdngo@us.ibm.com"
    "password" = "Passw0rd!"
    "first" = "Huy"
    "last" = "Ngo"
  }
}

# Cluster to be created
variable cluster {
  default = "tf-hdngo-001"
}

variable cluster_namespace {
  default = "default"
}

# Datacenter
variable dc1 {
  default = "dal12"
}

# Your Organization on IBM Cloud
variable ibm_org {
  default = "WDP Customer Success"
}

# Resource Group
variable ibm_rg {
  default = "default"
}

# Space in your Organization
variable ibm_space {
  default = "phoenix"
}

variable keyprotect {
  type = "map"
  default = {
    "name" = "kps-hdngo-001"
    "keyname" = "hdngo-key-001"
    "keydescription" = "Root key for HDNGO"
    # Leave payload blank to have a root key generated
    # To provide a key, make sure its AES key size is 128, 192 or 256 bits.
    "keypayload" = ""
  }
}

# Private VLAN to be created
variable private_vlan {
  default = "tf-pri-hdngo-001"
}

# Public VLAN to be created
variable public_vlan {
  default = "tf-pub-hdngo-001"
}

# IBM Cloud region
variable region {
  default = "us-south"
}
