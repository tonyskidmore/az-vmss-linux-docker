#!/bin/bash

# defaults
export AZ_LOCATION=${AZ_LOCATION:-uksouth}
export AZ_VMSS_VM_SKU=${AZ_VMSS_VM_SKU:-Standard_B2s}
export AZ_VMSS_STORAGE_SKU=${AZ_VMSS_STORAGE_SKU:-Standard_LRS}
export AZ_VMSS_ADMIN_NAME=${AZ_VMSS_ADMIN_NAME:-adminuser}
export AZ_VMSS_INSTANCE_COUNT=${AZ_VMSS_INSTANCE_COUNT:-0}
export AZ_VMSS_IDENTITY=${AZ_VMSS_IDENTITY:-[system]}
export AZ_VMSS_IMAGE=${AZ_VMSS_IMAGE:-Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest}
export AZ_VMSS_BOOT_DIAGS_ENABLED=${AZ_VMSS_BOOT_DIAGS_ENABLED:-true}

required_variables=("AZ_LOCATION" "AZ_VNET_RESOURCE_GROUP_NAME" "AZ_VNET_NAME" 
"AZ_SUBNET_NAME" "AZ_SUBSCRIPTION_ID" "AZ_VMSS_RESOURCE_GROUP_NAME" "AZ_VMSS_NAME" 
"AZ_VMSS_VM_SKU" "AZ_VMSS_STORAGE_SKU" "AZ_VMSS_ADMIN_NAME" "AZ_VMSS_ADMIN_PASSWORD" 
"AZ_VMSS_INSTANCE_COUNT" "AZ_VMSS_IDENTITY" "AZ_VMSS_IMAGE" "AZ_VMSS_BOOT_DIAGS_ENABLED")

for i in "${required_variables[@]}"
do
    printf "%s: %s\n" "$i" "${!i}"
    if [[ -z "${!i}" ]]
    then
      echo "Value for $i cannot be empty"
      exit 1
    fi
done

az vmss create --load-balancer "" \
  --name "$AZ_VMSS_NAME" \
  --location "$AZ_LOCATION" \
  --resource-group "$AZ_VMSS_RESOURCE_GROUP_NAME" \
  --subnet "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$AZ_VNET_RESOURCE_GROUP_NAME/providers/Microsoft.Network/virtualNetworks/$AZ_VNET_NAME/subnets/$AZ_SUBNET_NAME" \
  --image "$AZ_VMSS_IMAGE" \
  --vm-sku "$AZ_VMSS_VM_SKU" \
  --storage-sku "$AZ_VMSS_STORAGE_SKU" \
  --admin-username "$AZ_VMSS_ADMIN_NAME" \
  --admin-password "$AZ_VMSS_ADMIN_PASSWORD" \
  --instance-count "$AZ_VMSS_INSTANCE_COUNT" \
  --assign-identity "$AZ_VMSS_IDENTITY" \
  --disable-overprovision \
  --upgrade-policy-mode manual \
  --single-placement-group false \
  --platform-fault-domain-count 1 \
  --os-disk-caching readonly \
  --custom-data cloud-init \
  --output json

az resource wait --exists --ids "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$AZ_VMSS_RESOURCE_GROUP_NAME/providers/Microsoft.Compute/virtualMachineScaleSets/$AZ_VMSS_NAME"

vmss_boot_diags_enabled=$(az vmss show \
              --resource-group "$AZ_VMSS_RESOURCE_GROUP_NAME" \
              --name "$AZ_VMSS_NAME" \
              --subscription "$AZ_SUBSCRIPTION_ID" \
              --query "virtualMachineProfile.diagnosticsProfile.bootDiagnostics.enabled" \
              --output tsv)

if [[ "$AZ_VMSS_BOOT_DIAGS_ENABLED" == "true" && "$vmss_boot_diags_enabled" != "true" ]]
then
  echo "Enabling boot diagnostics on $AZ_VMSS_NAME"
  az vmss update \
    --name "$AZ_VMSS_NAME" \
    --resource-group "$AZ_VMSS_RESOURCE_GROUP_NAME" \
    --subscription "$AZ_SUBSCRIPTION_ID" \
    --set virtualMachineProfile.diagnosticsProfile='{"bootDiagnostics": {"Enabled" : "True"}}'
else
  echo "Boot diagnostics for $AZ_VMSS_NAME already enabled"
fi