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
