targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)
var definitionNames = [
  'subnet_has_associated_nsg'
  'nsgrule_not_allows_public_inbound'
]

resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'audit_vnet_ingress_controls'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    displayName: 'Control vnet ingress (audit only)'
    description: 'Audit if vnet ingress traffic is controlled with a network security group.'
    parameters: {}
    policyDefinitions: [for definitionName in definitionNames: {
      policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', definitionName)
      parameters: {
        effect: {
          value: 'audit'
        }
      }
    }]
  }
}
