targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)

resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'control_vnet_egress'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    displayName: 'Control vnet egress'
    description: 'Stop deployments of subnets without a properly configured route table.'
    parameters: {
      location: loadJsonContent('../rules/_parameters.json').location
      allowedLocations: loadJsonContent('../rules/_parameters.json').allowedLocations
      resourceGroupName: loadJsonContent('../rules/_parameters.json').resourceGroupName
      routeTableName: loadJsonContent('../rules/_parameters.json').routeTableName
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
      excludedSubnets: loadJsonContent('../rules/_parameters.json').excludedSubnets
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'vnet_in_allowed_locations')
        parameters: {
          effect: {
            value: 'deny'
          }
          allowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'subnet_is_associated_with_desired_udr')
        parameters: {
          effect: {
            value: 'deny'
          }
          location: {
            value: '[parameters(\'location\')]'
          }
          resourceGroupName: {
            value: '[parameters(\'resourceGroupName\')]'
          }
          routeTableName: {
            value: '[parameters(\'routeTableName\')]'
          }
          excludedSubnets: {
            value: '[parameters(\'excludedSubnets\')]'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'vnet_has_subnet_associated_with_desired_udr')
        parameters: {
          effect: {
            value: 'deny'
          }
          location: {
            value: '[parameters(\'location\')]'
          }
          resourceGroupName: {
            value: '[parameters(\'resourceGroupName\')]'
          }
          routeTableName: {
            value: '[parameters(\'routeTableName\')]'
          }
          excludedSubnets: {
            value: '[parameters(\'excludedSubnets\')]'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_bgp_propagation_disabled')
        parameters: {
          effect: {
            value: 'deny'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_default_route')
        parameters: {
          effect: {
            value: 'deny'
          }
          location: {
            value: '[parameters(\'location\')]'
          }
          nextHopIpAddress: {
            value: '[parameters(\'nextHopIpAddress\')]'
          }
        }
      }
    ]
  }
}
