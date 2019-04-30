provider "azurerm" {
  version = "1.22.1"
}

resource "azurerm_resource_group" "logstash-resourcegroup" {
  name     = "${var.product}-logstash-${var.env}"
  location = "${var.location}"

  tags = "${merge(var.common_tags,
    map("lastUpdated", "${timestamp()}")
    )}"
}

locals {
  // Vault name
  previewVaultName = "${var.raw_product}-aat"
  nonPreviewVaultName = "${var.raw_product}-${var.env}"
  vaultName = "${(var.env == "preview" || var.env == "spreview") ? local.previewVaultName : local.nonPreviewVaultName}"

  // Shared Resource Group
  previewResourceGroup = "${var.raw_product}-shared-aat"
  nonPreviewResourceGroup = "${var.raw_product}-shared-${var.env}"
  sharedResourceGroup = "${(var.env == "preview" || var.env == "spreview") ? local.previewResourceGroup : local.nonPreviewResourceGroup}"
}

data "azurerm_key_vault" "ccd_shared_key_vault" {
  name = "${local.vaultName}"
  resource_group_name = "${local.sharedResourceGroup}"
}

data "azurerm_key_vault_secret" "ccd_elastic_search_public_key" {
  name = "ccd-ELASTIC-SEARCH-PUB-KEY"
  vault_uri = "${data.azurerm_key_vault.ccd_shared_key_vault.vault_uri}"
}

module "logstash" {
  source = "git@github.com:hmcts/cnp-module-logstash.git?ref=master"
  product = "${var.product}"
  location = "${var.location}"
  env = "${var.env}"
  subscription = "${var.subscription}"
  common_tags = "${var.common_tags}"
  vm_size = "${var.vm_size}"
  vm_disk_type = "${var.vm_disk_type}"
  target_elastic_search_product = "ccd"
  ssh_elastic_search_public_key = "${data.azurerm_key_vault_secret.ccd_elastic_search_public_key.value}"
  mgmt_subscription_id = "${var.mgmt_subscription_id}"
}



