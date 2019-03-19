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
