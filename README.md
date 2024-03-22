# Azure Policy Control Routes (sample)

An example of how multiple definitions can be used together to implement a desired security control.

## Setup

To create tenant scoped deployments

1. Enable elevated global admin access https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin

2. Assign permissions on the tenant root

    ``` bash
    az role assignment create  --scope '/' --role 'Owner' --assignee-object-id $(az ad signed-in-user show --query id)
    ```

    > **Important!** Make sure to remove access once when no longer required.

## Build

There are a number of BICEP files that must be built first so that they can be read in as JSON files in policy deployments.

``` bash
az bicep build --file .\policy\templates\nsg.bicep
```

## Deploy

Deploy the policy definitions and initiatives.

``` bash
# Deploy everything
az deployment tenant create --name policyDefinitions --location australiaeast --template-file .\policy\main.bicep

# Or deploy just a single definition
az deployment mg create --name policyDefinitions --location australiaeast --management-group-id policy_definitions --template-file .\policy\definitions\udr_forces_next_hop.bicep
```

## Lock

The policy definitions can be accompanied with a deployment stack (deployed at the management group level) to create an enclave resource group for policy dependencies.

``` bash
# Use deployment stacks to create a space for policy controlled resources
az stack mg create --name 'rg_for_policy_resources' --management-group-id policy_definitions --location 'australiaeast' --template-file '.\stacks\main.bicep' --deny-settings-mode 'DenyDelete' --deny-settings-apply-to-child-scopes --deny-settings-excluded-principals '<object-id> <object-id>'
```

When deploying the enclave resource group be sure to *assign* the desired policy initiatives first. Take note of the objectId of any managed identities used for DeployIfNotExists policies and append them to the above deployment stack command.

## How it works...

We create a DeployIfNotExists policy that will in turn create a network security group when a resource group called **'policy_enforced_resource_group'** is created. The specific policy is called **'subscription_has_policy_controlled_nsg'** and is deployed as part of the **'deny__control_vnet_egress'** initiative.

Next we assign this initiative (this is done manually using the portal; this sample repo does not create any policy assignments). As the assignment is created we take note of the MSI objectId that is created for us, it is found under the Remediation section of the initiative assignment.

Finally we use a deployment stack to create the before mentioned resource group ('subscription_has_policy_controlled_nsg') and allow the MSI linked to the policy assignment to bypass the DenyDelete settings of the deployment stack. This is done through the `--deny-settings-excluded-principals` option when creating the deployment stack.

The deployment stack is also used to create a route table in the 'policy_enforced_resource_group' resource group. When the deployment is completed this route table along with the resource group cannot be modified or deleted (even as Owner of the subscription). The only way to modify or delete these is to update the deployment stack (which has been deployed at the management group level).

The creation of the resource group triggers a remediation task of the DeployIfNotExists policy. This initiates a separate deployment eventually creating an network security group in the same resource group as the route table. However, as the network security group is not controlled as part of the deployment stack, it is possible to modify and delete it without needing to update the deployment stack itself.

## Cleanup

If you wish to remove the policies.

``` powershell
# Delete assignments
az policy assignment list --scope '/providers/Microsoft.Management/managementGroups/policy_definitions' --query "[?metadata.category=='algonz'].name" --output tsv | foreach { az policy assignment delete --scope '/providers/Microsoft.Management/managementGroups/policy_definitions' --name $_ }

# Delete initiatives
az policy set-definition list --management-group policy_definitions --query "[?metadata.category=='algonz'].name" --output tsv | foreach { az policy set-definition delete --management-group policy_definitions --name $_ }

# Delete definitions
az policy definition list --management-group policy_definitions --query "[?metadata.category=='algonz'].name" --output tsv | foreach { az policy definition delete --management-group policy_definitions --name $_ }
```