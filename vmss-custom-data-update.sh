#!/bin/bash
set -euo pipefail

# defaults
export AZ_LOCATION=${AZ_LOCATION:-uksouth}
export AZ_VMSS_VM_SKU=${AZ_VMSS_VM_SKU:-Standard_B2s}
export AZ_VMSS_STORAGE_SKU=${AZ_VMSS_STORAGE_SKU:-Standard_LRS}
export AZ_VMSS_ADMIN_NAME=${AZ_VMSS_ADMIN_NAME:-adminuser}
export AZ_VMSS_INSTANCE_COUNT=${AZ_VMSS_INSTANCE_COUNT:-0}
export AZ_VMSS_IDENTITY=${AZ_VMSS_IDENTITY:-[system]}
export AZ_VMSS_IMAGE=${AZ_VMSS_IMAGE:-Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest}
export AZ_VMSS_BOOT_DIAGS_ENABLED=${AZ_VMSS_BOOT_DIAGS_ENABLED:-true}
export AZ_VMSS_CLOUD_INIT=${AZ_VMSS_CLOUD_INIT:-cloud-init/cloud-init.yml}

# https://learn.microsoft.com/en-us/rest/api/compute/virtual-machine-scale-sets/update?tabs=HTTP

create_patch_data()
{
  cat <<EOF
{
  "properties": {
    "virtualMachineProfile": {
      "osProfile": {
        "customData": "$custom_data"
      }
    }
  }
}
EOF
}

custom_data=$(base64 -w 0 < "$AZ_VMSS_CLOUD_INIT")
body=$(create_patch_data)
uri="https://management.azure.com/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$AZ_VMSS_RESOURCE_GROUP_NAME/providers/Microsoft.Compute/virtualMachineScaleSets/$AZ_VMSS_NAME?api-version=2022-11-01"

printf "custom_data: %s\n" "$custom_data"
printf "uri: %s\n" "$uri"
printf "body: \n%s\n" "$body"

az rest --uri "$uri" \
        --body "$body" \
        --headers "Accept=application/json" \
        --method patch

# trying to update an existing instance and reimaging doesn't seem to work

# az vmss update --name "$AZ_VMSS_NAME"\
#                --resource-group "$AZ_VMSS_RESOURCE_GROUP_NAME" \
#                --subscription "$AZ_SUBSCRIPTION_ID" \
#                --no-wait

# az vmss reimage --name "$AZ_VMSS_NAME" \
#                 --resource-group "$AZ_VMSS_RESOURCE_GROUP_NAME" \
#                 --subscription "$AZ_SUBSCRIPTION_ID" \
#                 --no-wait