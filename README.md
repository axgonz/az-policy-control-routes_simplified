# Azure Policy Control Routes (sample)

A simplified version of https://github.com/axgonz/az-policy-control-routes.

## Deployment Stack

The below command only works with Azure CLI version 2.51.0.

``` bash
# Use deployment stacks to create a space for policy controlled resources
az stack mg create --name "rg_for_policy_resources" --management-group-id "policy_definitions" --location "australiaeast" --template-file "./stacks/main.bicep" --deny-settings-mode "DenyDelete" --deny-settings-apply-to-child-scopes
```