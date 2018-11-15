variable "product" {
  type    = "string"
}

variable "raw_product" {
  default = "ccd"
  // jenkins-library overrides product for PRs and adds e.g. pr-118-ccd
}

variable "location" {
  type    = "string"
  default = "UK South"
}

variable "env" {
  type = "string"
}

variable "subscription" {
  type = "string"
}

variable "capacity" {
  default = "1"
}

variable "common_tags" {
  type = "map"
}

variable "vm_size" {
  type = "string"
  default = "Standard_A2"
}

variable "vm_disk_type" {
  type = "string"
  default = "Standard_LRS"
}

