variable ibm_bx_api_key {}
variable ibm_sl_username {}
variable ibm_sl_api_key {}

variable "region" {
  type = "string"
  description = "ibm cloud region"
  default = "us-south"
}

variable "zones" {
  type = "list"
  description = "zones in region"
  default = ["dal10", "dal12"]
}

variable "resource_group" {
  type = "string"
  description = "ibm cloud resoure group"
  default = "default"
}

variable "cf_org" {
  type = "string"
  description = "ibm cloud cf org name"
}

variable "cf_space" {
  type = "string"
  description = "ibm cloud cf space"
}

variable "pfx" {
  type = "string"
  description = "name prefix for resources created by this plan"
  default = ""
}

variable "cluster_name" {
  type = "string"
  description = "iks cluster name"
  default = "dev"
}

variable "kube_version" {
  type = "string"
  description = "kube version"
  default = "1.12.6"
}

variable "billing" {
  type = "string"
  description = "billing type"
  default = "hourly"
}

variable "keyprotect" {
  type = "map"
  description = "key protect instance info"
  default = {
    "name" = "kps"
    "description" = "root key"
    # Leave payload blank to generate root key
    # set payload to BYO-key file with AES 128/192/256 bits
    "payload" = ""
  }
}

variable "cos_name" {
  type = "string"
  description = "cloud object storage instance"
  default = "cos"
}

variable "appid_name" {
  type = "string"
  description = "appid instance"
  default = "appid"
}

variable "appid_user" {
  type = "map"
  default = {
    "first"     = "John"
    "last"      = "Doe"
    "email"     = "jdoe@noemail.com"
    "password"  = "passw0rd"
  }
}

variable "app_name" {
  type = "string"
  default = "sockstore"
}
