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
# uncomment below if you want to adjust default behaviour and set your own values
# export AZ_VMSS_INSTANCE_COUNT=1
# export AZ_LOCATION=uksouth
# export AZ_VMSS_VM_SKU=Standard_B2s
# export AZ_VMSS_IMAGE=Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest
# export AZ_VMSS_ADMIN_NAME=adminuser
# export AZ_VMSS_BOOT_DIAGS_ENABLED=true

````

4. Run the script to create the Virtual Machine Scale Set.

````bash

./vmss-create.sh

````

5. Login into Azure DevOps and create the Azure virtual machine scale set agent pool.

## Update

## Environment variables

| environment variable        | required | default  | description                                            |
|-----------------------------|----------|----------|--------------------------------------------------------|
| AZ_VMSS_ADMIN_PASSWORD      | yes      |          |
| AZ_VMSS_NAME                | yes      |          |
| AZ_VMSS_RESOURCE_GROUP_NAME | yes      |
| AZ_SUBSCRIPTION_ID          | yes      |
| AZ_VNET_RESOURCE_GROUP_NAME | yes      |
| AZ_VNET_NAME                | yes      |
| AZ_SUBNET_NAME              | yes      |