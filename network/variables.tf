# OPC provider credentials
#-------------------------
variable "user" {
  description = "username on opc environment"
}

variable "password" {
  description = "password for specified username"
}

variable "identity_domain" {
  description = "identity domain"
}

variable "endpoint" {
  description = "REST endpoint"
}

# SSH Access from Bastion to OPC Instances
#-----------------------------------------
variable "bastion_ssh_pub_key" {
  description = "path to ssh public key file for access to OPC instances from bastion"
}
