resource "azurerm_resource_group" "elastic-resourcegroup" {
  name     = "${var.product}-logstash-${var.env}"
  location = "${var.location}"

  tags = "${merge(var.common_tags,
    map("lastUpdated", "${timestamp()}")
    )}"
}

locals {
  artifactsBaseUrl = "https://raw.githubusercontent.com/elastic/azure-marketplace/6.3.0/src"
  templateUrl = "${local.artifactsBaseUrl}/mainTemplate.json"
  elasticVnetName = "elastic-search-vnet"
  elasticSubnetName = "elastic-search-subnet"
  vNetLoadBalancerIp = "10.112.0.4"
}

data "http" "template" {
  url = "${local.templateUrl}"
}

resource "azurerm_template_deployment" "elastic-iaas" {
  name                = "${var.product}-${var.env}"
  template_body       = "${data.http.template.body}"
  resource_group_name = "${azurerm_resource_group.elastic-resourcegroup.name}"
  deployment_mode     = "Incremental"

  parameters = {
    # See https://github.com/elastic/azure-marketplace#parameters
    artifactsBaseUrl  = "${local.artifactsBaseUrl}"
    esClusterName     = "${var.product}-elastic-search-${var.env}"
    location          = "${azurerm_resource_group.elastic-resourcegroup.location}"

    esVersion         = "6.3.0"
    xpackPlugins      = "No"
    kibana            = "Yes"

    vmHostNamePrefix = "${var.product}-"

    adminUsername     = "elkadmin"
    adminPassword     = "password123!"
    securityAdminPassword = "password123!"
    securityKibanaPassword = "password123!"
    securityBootstrapPassword = ""
    securityLogstashPassword = "password123!"
    securityReadPassword = "password123!"

    vNetNewOrExisting = "new"
    vNetName          = "${local.elasticVnetName}"
    vNetNewAddressPrefix = "10.112.0.0/16"
    vNetLoadBalancerIp = "${local.vNetLoadBalancerIp}"
    vNetClusterSubnetName = "${local.elasticSubnetName}"
    vNetNewClusterSubnetAddressPrefix = "10.112.0.0/25"

    vmSizeKibana = "Standard_A2"
    vmSizeDataNodes = "Standard_A2"
    vmSizeClientNodes = "Standard_A2"
    vmSizeMasterNodes = "Standard_A2"

    esAdditionalYaml = "action.auto_create_index: .security*,.monitoring*,.watches,.triggered_watches,.watcher-history*,.ml*\n"
  }
}

data "azurerm_subnet" "elastic-subnet" {
  name                 = "${local.elasticSubnetName}"
  virtual_network_name = "${local.elasticVnetName}"
  resource_group_name  = "${azurerm_resource_group.elastic-resourcegroup.name}"
}

resource "azurerm_network_interface" "logstash" {
  name                  = "logstash-nic-${var.env}"
  location              = "${azurerm_resource_group.elastic-resourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.elastic-resourcegroup.name}"

  ip_configuration {
    name                          = "${var.product}-logstash-nic-ip-${var.env}"
    subnet_id                     = "${data.azurerm_subnet.elastic-subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "logstash" {
  name                  = "logstash-vm-${var.env}"
  location              = "${azurerm_resource_group.elastic-resourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.elastic-resourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.logstash.id}"]
  vm_size               = "Standard_A2"

  storage_image_reference {
    id = "${data.azurerm_image.logstash.id}"
  }

  storage_os_disk {
    name              = "es-logstash-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  "os_profile" {
    computer_name = "logstash-vm-${var.env}"
    admin_username = "ubuntu"
    admin_password = "password123!"
    //    custom_data = "${data.template_file.singlenode_userdata_script.rendered}"
  }

  //FIXME certificates needs to be manually copied to kibana to be able to connect to logstash
  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCh71wxQi1CNr+4p3smXJkkTvvBpY/MNz57su893dmsP3s7WHZA1EZcQAbaNPt7pw9hpl1Um9yUIxK91mReFQGYPFTVIplR6Zl62r9nPvnW/iLVaERuNNc/giv2xD5cbrv7FLOM1i9SA6s+JKUjepSXqBidOf850o1ezPnhL0qNGmPFUVu1Ze0ZkuMJXDUcNSWY43q3+/eq9RUXxXEi2ZTK6QN7iCq0i49KyfJchQFKFxPwCSQhBWAOOh09mLZ2ykY1VCY/sR3EA+vUwjo5gwOjA32zJEempe3sEV06t2kQPXZDr+QPJJpDZPx6J6rZN9efuudP3RllSjV7FTkkPVdr9vmUPV/ESfVf2s62q5ftMJEFkW2QzSa+Vqjdv9SQqs55gI4aVUZwxG4YZ6QeEgcViBx15p1VX7kmceNZsOv3MedOAKxn4lIojN7rL2VpIFFr66m37aPgltXwHMwej2YTgQHU51pvaJfGP3pKCJJddisjj2h2fhcXHhfRh0r8oAq3zExKa1uofj1oijs6Aqkq6RGnDIzMM1cbBppdnNB52+aV/u5O7W6Xsa6jsrfHLwg1ZxbbMCkTDhbvLRThsdhO+3mKNCmuhVD5qDpOJbYRpBFUPyZNMRmnkgNV1AiZHoQzXbfrekPughuqMu0ngXF3dXVzaJJnP1b9zqb9M2I1Q=="
    }
  }
}