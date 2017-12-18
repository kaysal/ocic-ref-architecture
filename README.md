# Reference Architecture - Oracle Cloud - OCI Classic

This example creates a simple reference architecture on OCI Classic Oracle Cloud. See the link for the architecture diagram:
[OCIC Architecture]


The example uses recommended Infrastructure as a Code (IAC) principles as outlined in the book *[Terraform: Up and Running]* as follows:
### Architecture Principles
- Separation of TF state files for different tiers of the architecture - in order to isolate changes to each separate tier and reduce likelihood of accidental changes to entire infrastructure
- Use of Backends and shared remote state files for team collaboration
- Modules for better code re-use
- Git versioning for stage and prod environments

The IAC blueprint is in the link below:
[IAC Blueprint]

### Running This Example
There are 2 environments *prod* and *stage*. This example only uses *stage*.

1. Run the Network configuration TF scripts in *live/stage/network first*. This will create all necessary network resources - IP Exchange, IP Networks, IP Prefix Sets, ACLs, vNICsets, Security Protocols, Security Rules. This will also create the necessary outputs that are stored in the remote state located in *live/stage/states/network/*. The remote state data will be used by the modules and also the TF scripts in *live/stage/services* and *live/stage/mgt*.

2. Run the Bastion Server configuration TF scripts in *live/stage/mgt/services/bastion-hosts/*. This uses the Bastion module in https://github.com/kaysal/ocic-modules/tree/master/services/bastion-hosts. It also uses the output data from live/stage/states/network/terraform.tfstate.

4. Run TF scripts for the remaining TF scripts for *live/stage/services/forward-proxy*, *live/stage/services/frontend-app* and *live/stage/services/reverse-proxy*. Each of the TF scripts above follows similar explanation in 2 above and are located in https://github.com/kaysal/ocic-modules/tree/master/services.


### Git Versioning

The *live* and *modules* folder should be configured as separate Git repositories. You can achieve versioning by using Git tags when committing configuration in *stage/modules/services*.

For example, we can set tags for *live/stage/mgt/services/bastion-hosts/main.tf*. The following example shows how the modules repository was uploaded initially and Git version set via tag to V1.0.0

```sh
git init
git add .
git commit -m "initial commit of modules repo"
git remote add origin https://github.com/kaysal/ocic-modules.git
git push origin master
git tag -a "v1.0.0" -m "First release of services modules for Bastion Server, Forward Proxy, and Reverse Proxy"
git push --tags
```
You can then use the versioned module in *stage* or *prod* by specifying the Git URL (with the Tag reference) in the source parameter of the Terraform module. An example of using version V1.0.0 to create a Bastion Server in *live/stage/mgt/services/bastion-hosts/main.tf*:

```sh
module "bastion-windows" {
  source = "github.com/kaysal/ocic-modules.git//services/bastion-hosts?ref=v1.0.0"
  remote_state_network_data = "../../../states/network/terraform.tfstate"
  instance_name = "ks_win_bastion"
  ip_address = "192.168.1.130"
  instance_shape = "oc3"
  boot_volume_image_list = "/Compute-${var.identity_domain}/${var.user}/Microsoft_Windows_Server_2012_R2"
  search_domains   = ["cloud.oracle.com", "oraclecloud.com"]
}
```

[OCIC Architecture]: <https://storage.googleapis.com/cloud-network-things/oracle/ocic_arch/image_8_1.png>
[IAC Blueprint]: <https://storage.googleapis.com/cloud-network-things/oracle/oci_terraform_arch/iac_blueprint_ocic.png>
[Terraform: Up and Running]: <https://www.terraformupandrunning.com/>
