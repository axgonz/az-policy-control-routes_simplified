targetScope = 'managementGroup'

// Contributor role
var networkContributor = '4d97b98b-1d4f-4787-a291-c67834d212e7'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'subscription_has_policy_controlled_udr'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      resourceGroupName: loadJsonContent('../rules/_parameters.json').resourceGroupName
      routeTableName: loadJsonContent('../rules/_parameters.json').routeTableName
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
    }
    policyRule: {
      if: loadJsonContent('../rules/resourceGroup.json').if
      then: {
        effect: 'deployIfNotExists'
        details: {
          evaluationDelay: 'AfterProvisioning'
          type: 'Microsoft.Network/routeTables'
          resourceGroupName: '[parameters(\'resourceGroupName\')]'
          existenceCondition: {
            field: 'name'
            equals: '[parameters(\'routeTableName\')]'
          }
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/${networkContributor}'
          ]
          deployment: {
            properties: {
              mode: 'incremental'
              template: loadJsonContent('../templates/udr.json')
              parameters: {
                name: {
                  value: '[parameters(\'routeTableName\')]'
                }
                nextHopIpAddress: {
                  value: '[parameters(\'nextHopIpAddress\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
