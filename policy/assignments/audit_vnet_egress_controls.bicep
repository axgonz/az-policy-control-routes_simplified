targetScope = 'managementGroup'

param location string = deployment().location

var config = loadJsonContent('../../config.json')
var shortLocation = config.regionPrefixLookup[location]
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'audit_vnet_egress_${shortLocation}'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    displayName: 'Control vnet egress \'${shortLocation}\' (audit only)'
    parameters: {
      location: {
        value: location
      }
      allowedLocations: {
        value: config.vnet.allowedLocations
      }
      resourceGroupName: {
        value: '${config.resourceGroupName}_${shortLocation}'
      }
      routeTableName: {
        value: '${config.routeTable.name}_${shortLocation}'
      }
      nextHopIpAddress: {
        value: config.nextHopIpAddressLookup[location]
      }
      excludedSubnets: {
        value: config.routeTable.excludedSubnets
      }
    }
    policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policySetDefinitions', 'audit_vnet_egress_controls')
  }
}
