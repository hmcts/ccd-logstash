module "logstash" {
  source = "git@github.com:hmcts/cnp-module-logstash.git?ref=master"
  product = "${var.product}"
  location = "${var.location}"
  env = "${var.env}"
  common_tags = "${var.common_tags}"
  target_elastic_search_resource_group = "${var.product}-elastic-search-${var.env}"
}