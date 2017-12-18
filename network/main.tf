provider "opc" {
  user = "${var.user}"
  password	= "${var.password}"
  identity_domain = "${var.identity_domain}"
  endpoint 	= "${var.endpoint}"
}

terraform {
  backend "local" {
    path = "../states/network/terraform.tfstate"
  }
}

# public key used by bastion to ssh into opc instances
#-----------------------------------------------------
resource "opc_compute_ssh_key" "bastion_ssh_public_key" {
  name = "bastion_ssh_public_key"
  key = "${file(var.bastion_ssh_pub_key)}"
  enabled = true
}

#	ip exchange
#-----------------------------------
resource "opc_compute_ip_network_exchange" "ks_ipx" {
  name = "ks_ipx"
}

#	ip networks
#-----------------------------------
resource "opc_compute_ip_network" "ks_vpn" {
  name = "ks_vpn"
  description  = "VPN IP Network"
  ip_address_prefix = "192.168.1.0/25"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

resource "opc_compute_ip_network" "ks_bastion" {
  name = "ks_bastion"
  description  = "Bastion IP Network"
  ip_address_prefix = "192.168.1.128/25"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

resource "opc_compute_ip_network" "ks_RProxy" {
  name = "ks_RProxy"
  description  = "Reverse Proxy IP Network"
  ip_address_prefix = "172.16.1.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

resource "opc_compute_ip_network" "ks_FProxy" {
  name = "ks_FProxy"
  description  = "Forward Proxy IP Network"
  ip_address_prefix = "172.16.2.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

resource "opc_compute_ip_network" "ks_frontEnd" {
  name = "ks_frontEnd"
  description  = "Front End IP Network"
  ip_address_prefix = "10.0.1.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

resource "opc_compute_ip_network" "ks_midTier" {
  name = "ks_midTier"
  description  = "Mid Tier IP Network"
  ip_address_prefix = "10.0.2.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

resource "opc_compute_ip_network" "ks_database" {
  name = "ks_database"
  description  = "Database Tier IP Network"
  ip_address_prefix = "10.0.3.0/24"
  ip_network_exchange = "${opc_compute_ip_network_exchange.ks_ipx.name}"
}

#	ip prefixes
#-----------------------------------
resource "opc_compute_ip_address_prefix_set" "ks_vpn" {
  name     = "ks_vpn"
  description  = "VPN IP Prefix Set"
  prefixes = ["192.168.1.0/25"]
}

resource "opc_compute_ip_address_prefix_set" "ks_bastion" {
  name     = "ks_bastion"
  description  = "Bastion IP Prefix Set"
  prefixes = ["192.168.1.128/25"]
}

resource "opc_compute_ip_address_prefix_set" "ks_RProxy" {
  name     = "ks_RProxy"
  description  = "Reverse Proxy IP Prefix Set"
  prefixes = ["172.16.1.0/24"]
}

resource "opc_compute_ip_address_prefix_set" "ks_FProxy" {
  name     = "ks_FProxy"
  description  = "Forward Proxy IP Prefix Set"
  prefixes = ["172.16.2.0/24"]
}

resource "opc_compute_ip_address_prefix_set" "ks_frontEnd" {
  name     = "ks_frontEnd"
  description  = "Front End IP Prefix Set"
  prefixes = ["10.0.1.0/24"]
}

resource "opc_compute_ip_address_prefix_set" "ks_midTier" {
  name     = "ks_midTier"
  description  = "Middle Tier IP Prefix Set"
  prefixes = ["10.0.2.0/24"]
}

resource "opc_compute_ip_address_prefix_set" "ks_database" {
  name     = "ks_database"
  description  = "Database Tier IP Prefix Set"
  prefixes = ["10.0.3.0/24"]
}

resource "opc_compute_ip_address_prefix_set" "ks_customer" {
  name     = "ks_customer"
  description  = "On-premise IP Prefix set for customer location"
  prefixes = ["172.16.10.0/24"]
}

#	acl
#-----------------------------------
resource "opc_compute_acl" "ks_vpn" {
  name = "ks_vpn"
  description = "ACL applied to VNICset of VPN Hosts"
}

resource "opc_compute_acl" "ks_bastion" {
  name = "ks_bastion"
  description = "ACL applied to VNICset of Bastion instances"
}

resource "opc_compute_acl" "ks_RProxy" {
  name = "ks_RProxy"
  description = "ACL applied to VNICset of Reverse Proxy instances"
}

resource "opc_compute_acl" "ks_FProxy" {
  name = "ks_FProxy"
  description = "ACL applied to VNICset of Forward Proxy instances"
}

resource "opc_compute_acl" "ks_frontEnd" {
  name = "ks_frontEnd"
  description = "ACL applied to VNICset of Front End instances"
}

resource "opc_compute_acl" "ks_midTier" {
  name = "ks_midTier"
  description = "ACL applied to VNICset of Mid Tier instances"
}

resource "opc_compute_acl" "ks_database" {
  name = "ks_database"
  description = "ACL applied to VNICset of Database Tier instances"
}

#	vnicsets
#-----------------------------------
resource "opc_compute_vnic_set" "ks_vpn" {
  name = "ks_vpn"
  description = "VNICset applied to all VNICs on VPN Network"
  applied_acls = ["${opc_compute_acl.ks_vpn.name}"]
}

resource "opc_compute_vnic_set" "ks_bastion" {
  name = "ks_bastion"
  description = "VNICset applied to all VNICs on Bastion Network"
  applied_acls = ["${opc_compute_acl.ks_bastion.name}"]
}

resource "opc_compute_vnic_set" "ks_RProxy" {
  name = "ks_RProxy"
  description = "VNICset applied to all VNICs on Reverse Proxy Network"
  applied_acls = ["${opc_compute_acl.ks_RProxy.name}"]
}

resource "opc_compute_vnic_set" "ks_FProxy" {
  name = "ks_FProxy"
  description = "VNICset applied to all VNICs on Forward Proxy Network"
  applied_acls = ["${opc_compute_acl.ks_FProxy.name}"]
}

resource "opc_compute_vnic_set" "ks_frontEnd" {
  name = "ks_frontEnd"
  description = "VNICset applied to all VNICs on Front End Network"
  applied_acls = ["${opc_compute_acl.ks_frontEnd.name}"]
}

resource "opc_compute_vnic_set" "ks_midTier" {
  name = "ks_midTier"
  description = "VNICset applied to all VNICs on Middle Tier Network"
  applied_acls = ["${opc_compute_acl.ks_midTier.name}"]
}

resource "opc_compute_vnic_set" "ks_database" {
  name = "ks_database"
  description = "VNICset applied to all VNICs on Database Tier Network"
  applied_acls = ["${opc_compute_acl.ks_database.name}"]
}

#	security protocols
#-----------------------------------
resource "opc_compute_security_protocol" "ks_ssh" {
  name        = "ks_ssh"
  description = "SSH traffic"
  dst_ports   = ["22"]
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "ks_rdp" {
  name        = "ks_rdp"
  description = "RDP traffic"
  dst_ports   = ["3389"]
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "ks_icmp" {
  name        = "ks_icmp"
  description = "ICMP traffic"
  ip_protocol = "icmp"
}

resource "opc_compute_security_protocol" "ks_http" {
  name        = "ks_http"
  description = "HTTP traffic"
  dst_ports   = ["80"]
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "ks_https" {
  name        = "ks_https"
  description = "HTTPS traffic"
  dst_ports   = ["443"]
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "ks_proxy" {
  name        = "ks_proxy"
  description = "Proxy 8080 traffic"
  dst_ports   = ["8080"]
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "ks_tcp_dns" {
  name        = "ks_tcp_dns"
  description = "TCP DNS traffic"
  dst_ports   = ["53"]
  ip_protocol = "tcp"
}

resource "opc_compute_security_protocol" "ks_udp_dns" {
  name        = "ks_udp_dns"
  description = "UDP DNS traffic"
  dst_ports   = ["53"]
  ip_protocol = "udp"
}

#	security rules
#-----------------------------------
resource "opc_compute_security_rule" "ks_bastion_mgt_in" {
  name = "ks_bastion_mgt_in"
  description = "RDP and SSH access to Bastion from Internet"
  flow_direction = "ingress"
  acl = "${opc_compute_acl.ks_bastion.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_rdp.name}",
    "${opc_compute_security_protocol.ks_ssh.name}"
  ]
}

resource "opc_compute_security_rule" "ks_bastion_egress" {
  name = "ks_bastion_egress"
  description = "allow all bastion egress traffic"
  flow_direction = "egress"
  acl = "${opc_compute_acl.ks_bastion.name}"
}

resource "opc_compute_security_rule" "ks_RProxy_web_in" {
  name = "ks_RProxy_web_in"
  description = "HTTP(S) access to Reverse Proxy from Internet"
  flow_direction = "ingress"
  acl = "${opc_compute_acl.ks_RProxy.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_http.name}",
    "${opc_compute_security_protocol.ks_https.name}"
  ]
}

resource "opc_compute_security_rule" "ks_RProxy_ssh_in" {
  name = "ks_RProxy_ssh_in"
  description = "SSH Access from Bastion to Reverse Proxy"
  flow_direction = "ingress"
  src_ip_address_prefixes =[
    "${opc_compute_ip_address_prefix_set.ks_bastion.name}"
  ]
  acl = "${opc_compute_acl.ks_RProxy.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_ssh.name}"
  ]
}

resource "opc_compute_security_rule" "ks_RProxy_egress" {
  name = "ks_RProxy_egress"
  description = "allow all Reverse Proxy egress traffic"
  flow_direction = "egress"
  acl = "${opc_compute_acl.ks_RProxy.name}"
}

resource "opc_compute_security_rule" "ks_frontEnd_ssh_in" {
  name = "ks_frontEnd_ssh_in"
  description = "SSH Access to Front End by bastion and customer"
  flow_direction = "ingress"
  src_ip_address_prefixes =[
    "${opc_compute_ip_address_prefix_set.ks_bastion.name}",
    "${opc_compute_ip_address_prefix_set.ks_vpn.name}"
  ]
  acl = "${opc_compute_acl.ks_frontEnd.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_ssh.name}"
  ]
}

resource "opc_compute_security_rule" "ks_frontEnd_http_in" {
  name = "ks_frontEnd_http_in"
  description = "HTTP access from reverse proxy to Front end"
  flow_direction = "ingress"
  src_ip_address_prefixes =[
    "${opc_compute_ip_address_prefix_set.ks_RProxy.name}"
  ]
  acl = "${opc_compute_acl.ks_frontEnd.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_http.name}"
  ]
}

resource "opc_compute_security_rule" "ks_frontEnd_egress" {
  name = "ks_frontEnd_egress"
  description = "allow all FE egress traffic"
  flow_direction = "egress"
  acl = "${opc_compute_acl.ks_frontEnd.name}"
}

resource "opc_compute_security_rule" "ks_FProxy_web_in" {
  name = "ks_FProxy_web_in"
  description = "Forward Proxy access to internet for OPC instances"
  flow_direction = "ingress"
  src_ip_address_prefixes =[
    "${opc_compute_ip_address_prefix_set.ks_bastion.name}",
    "${opc_compute_ip_address_prefix_set.ks_frontEnd.name}",
    "${opc_compute_ip_address_prefix_set.ks_midTier.name}",
    "${opc_compute_ip_address_prefix_set.ks_database.name}"
  ]
  acl = "${opc_compute_acl.ks_FProxy.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_http.name}",
    "${opc_compute_security_protocol.ks_https.name}",
    "${opc_compute_security_protocol.ks_proxy.name}",
  ]
}

resource "opc_compute_security_rule" "ks_FProxy_ssh_in" {
  name = "ks_FProxy_ssh_in"
  description = "SSH access to FProxy from bastion"
  flow_direction = "ingress"
  src_ip_address_prefixes =[
    "${opc_compute_ip_address_prefix_set.ks_bastion.name}"
  ]
  acl = "${opc_compute_acl.ks_FProxy.name}"
  security_protocols = [
    "${opc_compute_security_protocol.ks_ssh.name}"
  ]
}

resource "opc_compute_security_rule" "ks_FProxy_egress" {
  name = "ks_FProxy_egress"
  description = "allow all FProxy egress traffic"
  flow_direction = "egress"
  acl = "${opc_compute_acl.ks_FProxy.name}"
}
