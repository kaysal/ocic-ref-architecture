provider "opc" {
  user = "${var.user}"
  password	= "${var.password}"
  identity_domain = "${var.identity_domain}"
  endpoint 	= "${var.endpoint}"
}

terraform {
  backend "local" {
    path = "../../states/services/frontend-app/terraform.tfstate"
  }
}

module "webserver" {
  source = "github.com/kaysal/ocic-modules.git//services/frontend-app?ref=v1.0.0"
  remote_state_network_data = "../../states/network/terraform.tfstate"
  instance_name = "ks_frontEnd"
  ip_address = "10.0.1.2"
  instance_shape = "oc3"
  boot_volume_image_list = "/oracle/public/OL_7.2_UEKR4_x86_64"
  search_domains   = ["cloud.oracle.com", "oraclecloud.com"]
}
