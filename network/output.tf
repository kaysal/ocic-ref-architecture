# ip network ouputs
#-------------------------
output "bastion_ipnet" {
  value = "${opc_compute_ip_network.ks_bastion.name}"
}

output "vpn_ipnet" {
  value = "${opc_compute_ip_network.ks_vpn.name}"
}

output "RProxy_ipnet" {
  value = "${opc_compute_ip_network.ks_RProxy.name}"
}

output "FProxy_ipnet" {
  value = "${opc_compute_ip_network.ks_FProxy.name}"
}

output "frontEnd_ipnet" {
  value = "${opc_compute_ip_network.ks_frontEnd.name}"
}

output "midTier_ipnet" {
  value = "${opc_compute_ip_network.ks_midTier.name}"
}

output "database_ipnet" {
  value = "${opc_compute_ip_network.ks_database.name}"
}

# vnicset outputs
#-------------------------
output "bastion_vnicset" {
  value = "${opc_compute_vnic_set.ks_bastion.name}"
}

output "vpn_vnicset" {
  value = "${opc_compute_vnic_set.ks_vpn.name}"
}

output "RProxy_vnicset" {
  value = "${opc_compute_vnic_set.ks_RProxy.name}"
}

output "FProxy_vnicset" {
  value = "${opc_compute_vnic_set.ks_FProxy.name}"
}

output "frontEnd_vnicset" {
  value = "${opc_compute_vnic_set.ks_frontEnd.name}"
}

output "midTier_vnicset" {
  value = "${opc_compute_vnic_set.ks_midTier.name}"
}

output "database_vnicset" {
  value = "${opc_compute_vnic_set.ks_database.name}"
}

# SSH Key output to be used for remote state file access
#-------------------------
output "bastion_ssh_public_key" {
  value = "${opc_compute_ssh_key.bastion_ssh_public_key.name}"
}
