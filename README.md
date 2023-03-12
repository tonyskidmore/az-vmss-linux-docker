# az-vmss-linux-docker

## Create

Simple creation of an Azure VM Scale Set (VMSS) to be used as an Azure DevOps Azure virtual machine scale set agent pool.
This will create a Ubuntu 20.04 Linux VMSS with Docker enabled by default to allow for container image creation and container jobs.

The below shows an example of using the defaults along with deployment specific examples:

1. Open Azure Cloud Shell at https://shell.azure.com and run a **Bash** session

2. Clone the repository and change into the code directory.

````bash

git clone https://github.com/tonyskidmore/az-vmss-linux-docker.git
cd az-vmss-linux-docker

````
3. Export the necessary environment variable to set the script behaviour.

````bash

 export AZ_VMSS_ADMIN_PASSWORD="Sup3rSecr3tssh!"
export AZ_VMSS_NAME="vmss-ado-agent-001"
export AZ_VMSS_RESOURCE_GROUP_NAME="rg-ado-agents"
export AZ_SUBSCRIPTION_ID="887e4330-e973-48af-b7de-67ad3319c57d"
export AZ_VNET_RESOURCE_GROUP_NAME="rg-networks"
export AZ_VNET_NAME="vnet-network-001"
export AZ_SUBNET_NAME="sn-ado-agents"
# add additional variables as per the table below to adjust defaults e.g.
# export AZ_VMSS_CLOUD_INIT=cloud-init/cloud-init-apps.yml

````

4. Run the script to create the Virtual Machine Scale Set.

````bash

./vmss-create.sh

````

5. Login into Azure DevOps and create the Azure virtual machine scale set agent pool.

## Update

It is possible to update the custom data after the VMSS has been initially deployed if needed.
You will still have to set the required environment variables and then run the update script.
The example below shows using the `cloud-init-apps.yml` config file to install some additional useful apps.

````bash

export AZ_VMSS_CLOUD_INIT=cloud-init/cloud-init-apps.yml
./vmss-custom-data-update.sh

````

_Note:_  
The updated `custom-data` will only apply to newly deployed VMSS instances.
To refresh any deployed instances set the `Number of agents to keep on standby` in Azure DevOps for the agent pool to `0`.
Then allow time for the existing agents to be deleted, then reapply the original value if desired.


## Tools

The `cloud-init` configs in `/cloud-init` shows examples of installing other packages as part of the VMSS instance deployments.
The tools are typically useful in Azure Pipelines jobs, the tools included in the examples are:

`cloud-init/cloud-init.yml`  
- docker-ce
- docker-ce-cli

`cloud-init/cloud-init-apps.yml`  
- apt-transport-https
- azure-cli
- ca-certificates
- curl
- docker-ce
- docker-ce-cli
- jq
- packer
- powershell
- python3
- python3-pip
- python3-venv
- software-properties-common
- terraform
- wget
- yq

_Note:_ adding packages as part of `cloud-init` increases the deployment time of instances.
For example, installiing just Docker might take ~3 minutes to deploy an instance.
Adding all of the toole above might extend that out to ~6 minutes, so choose your tools judiciously.
Only install tools in this manner that you are going to need.  
If the amount of additional tools becomes any larger consider [Store and share resources in an Azure Compute Gallery](https://learn.microsoft.com/en-us/azure/virtual-machines/azure-compute-gallery).



## Environment variables

| environment variable        | required | default                                                      | description                                                                       |
|-----------------------------|----------|--------------------------------------------------------------|-----------------------------------------------------------------------------------|
| AZ_SUBNET_NAME              | yes      |                                                              | The name of the subnet where the VMSS will be located.                            |
| AZ_SUBSCRIPTION_ID          | yes      |                                                              | The Azure subscription where the VMSS will be created.                            |
| AZ_VMSS_ADMIN_PASSWORD      | yes      |                                                              | The VMSS admin password.  You could update the script to use SSH keys if desired. |
| AZ_VMSS_NAME                | yes      |                                                              | The name of the VMSS.                                                             |
| AZ_VMSS_RESOURCE_GROUP_NAME | yes      |                                                              | The name of the resource group where the VMSS will be created.                    |
| AZ_VNET_NAME                | yes      |                                                              | Virtual network name where the AZ_SUBNET_NAME is located.                         |
| AZ_VNET_RESOURCE_GROUP_NAME | yes      |                                                              | Resource group name of where the Virtual network is located                       |
| AZ_LOCATION                 | no       | uksouth                                                      | Azure region.                                                                     |
| AZ_VMSS_VM_SKU              | no       | Standard_B2s                                                 | VMSS instance SKU - https://azure.microsoft.com/pricing/details/virtual-machines  |
| AZ_VMSS_STORAGE_SKU         | no       | Standard_LRS                                                 | The SKU of the storage account with which to persist VM.                          |
| AZ_VMSS_ADMIN_NAME          | no       | adminuser                                                    | Name for the admin user account.                                                  |
| AZ_VMSS_INSTANCE_COUNT      | no       | 0                                                            | Initial default number of VMSS instance.                                          |
| AZ_VMSS_IDENTITY            | no       | [system]                                                     | Identities created for the VMSS.                                                  |
| AZ_VMSS_IMAGE               | no       | Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest | The Ubuntu 20.04 (focal) image to use.                                            |
| AZ_VMSS_BOOT_DIAGS_ENABLED  | no       | true                                                         | Enable boot diagnostics.  This is useful for troubleshooting.                     |
| AZ_VMSS_CLOUD_INIT          | no       | cloud-init/cloud-init.yml                                    | The cloud-init data to be sent as custom-data.                                    |
