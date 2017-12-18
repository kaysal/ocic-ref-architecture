provider "opc" {
  user = "${var.user}"
  password	= "${var.password}"
  identity_domain = "${var.identity_domain}"
  endpoint 	= "${var.endpoint}"
}

terraform {
  backend "local" {
    path = "../../states/services/reverse-proxy/terraform.tfstate"
  }
}

module "reverse-proxy" {
  source = "github.com/kaysal/ocic-modules.git//services/reverse-proxy?ref=v1.0.0"
  remote_state_network_data = "../../states/network/terraform.tfstate"
  instance_name = "ks_RProxy"
  ip_address = "172.16.1.2"
  instance_shape = "oc3"
  boot_volume_image_list = "/oracle/public/OL_7.2_UEKR4_x86_64"
  search_domains   = ["cloud.oracle.com", "oraclecloud.com"]
}
