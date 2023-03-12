#!/bin/bash
set -euo pipefail

required_variables=("AZ_VMSS_CLOUD_INIT" "AZ_SUBSCRIPTION_ID" "AZ_VMSS_NAME" 
"AZ_VMSS_RESOURCE_GROUP_NAME")

for i in "${required_variables[@]}"
do
    printf "%s: %s\n" "$i" "${!i}"
    if [[ -z "${!i}" ]]
    then
      echo "Value for $i cannot be empty"
      exit 1
    fi
done

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
