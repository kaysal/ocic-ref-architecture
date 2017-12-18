
provider "opc" {
  user = "${var.user}"
  password	= "${var.password}"
  identity_domain = "${var.identity_domain}"
  endpoint 	= "${var.endpoint}"
}

terraform {
  backend "local" {
    path = "../../../states/mgt/bastions/terraform.tfstate"
  }
}

module "bastion-windows" {
  source = "github.com/kaysal/ocic-modules.git//services/bastion-hosts?ref=v1.0.0"
  remote_state_network_data = "../../../states/network/terraform.tfstate"
  instance_name = "ks_win_bastion"
  ip_address = "192.168.1.130"
  instance_shape = "oc3"
  boot_volume_image_list = "/Compute-${var.identity_domain}/${var.user}/Microsoft_Windows_Server_2012_R2"
  search_domains   = ["cloud.oracle.com", "oraclecloud.com"]
}
