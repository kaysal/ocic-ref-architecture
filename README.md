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

1. Run the TF scripts in stage/live/network first. This will create all necessary network resources - IP Exchange, IP Networks, IP Prefix Sets, ACLs, vNICsets, Security Protocols, Security Rules. This will also create the necessary outputs that are stored in the remote state located in *stage/live/states/network/*. The remote state data will be used by the modules and also the TF scripts in *services* and *mgt*.

2. Run TF scripts in *stage/live/mgt/services/bastion-hosts/*. This uses the Bastion module at stage/modules/services/bastion-hosts. It also uses the output data from stage/live/states/network/terraform.tfstate.

4. Run TF scripts for the remaining TF scripts for *stage/live/services/forward-proxy*, *stage/live/services/frontend-app* and *stage/live/services/reverse-proxy*. Each of the TF scripts above follows similar explanation in 2 above.


### Git Versioning

The *live* and *modules* folder should be configured as separate Git repositories. You can achieve versioning by using Git tags when committing configuration in *stage/modules/services*.

For example, we can set tags for *stage/live/mgt/services/bastion-hosts/main.tf*. The following example shows how the modules repository was uploaded initially and Git version set via tag to V1.0.0

```sh
git init
git add .
git commit -m "initial commit of modules repo"
git remote add origin https://github.com/kaysal/ocic-modules.git
git push origin master
git tag -a "v1.0.0" -m "First release of services modules for Bastion Server, Forward Proxy, and Reverse Proxy"
git push --tags
```
You can then use the versioned module in *stage* or *prod* by specifying the Git URL (with the Tag reference) in the source parameter of the Terraform module.

[OCIC Architecture]: <https://storage.googleapis.com/cloud-network-things/oracle/ocic_arch/image_8_1.png>
[IAC Blueprint]: <https://storage.googleapis.com/cloud-network-things/oracle/oci_terraform_arch/iac_blueprint_ocic.png>
[Terraform: Up and Running]: <https://www.terraformupandrunning.com/>
