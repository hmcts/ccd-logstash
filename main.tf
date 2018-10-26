resource "azurerm_resource_group" "logstash-resourcegroup" {
  name     = "${var.product}-logstash-${var.env}"
  location = "${var.location}"

  tags = "${merge(var.common_tags,
    map("lastUpdated", "${timestamp()}")
    )}"
}

module "logstash" {
  source = "git@github.com:hmcts/cnp-module-logstash.git?ref=master"
  product = "${var.product}"
  location = "${var.location}"
  env = "${var.env}"
  subscription = "${var.subscription}"
  common_tags = "${var.common_tags}"
  target_elastic_search_product = "ccd"
  vm_size = "${var.vm_size}"
  vm_disk_type = "${var.vm_disk_type}"
}
