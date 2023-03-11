#!/bin/bash


az rest -m patch -b '{
  "properties": {
    "virtualMachineProfile": {
      "osProfile": {
        "customData": "IyEvYmuL3NoCgpl.....Y2hvICJoZWxsbPi9bXAvd=="
      }
    }
  }
}' -u 'https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{group-name}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmss-name}?api-version=2022-08-01'

# https://learn.microsoft.com/en-us/rest/api/compute/virtual-machine-scale-sets/update?tabs=HTTP
# PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}?api-version=2022-11-01
# https://learn.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest#az-rest

# az rest --uri
#         [--body]
#         [--headers]
#         [--method {delete, get, head, options, patch, post, put}]
#         [--output-file]
#         [--resource]
#         [--skip-authorization-header]
#         [--uri-parameters]

# az rest --method get --uri /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}?api-version=2019-03-01

# https://learn.microsoft.com/en-us/cli/azure/vmss?view=azure-cli-latest#az-vmss-reimage

# az vmss reimage [--ids]
#                 [--instance-ids]
#                 [--name]
#                 [--no-wait]
#                 [--resource-group]
#                 [--subscription]

# az vmss reimage --name MyScaleSet --resource-group MyResourceGroup --subscription MySubscription