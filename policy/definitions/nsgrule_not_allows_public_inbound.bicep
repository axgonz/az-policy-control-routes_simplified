targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'nsgrule_not_allows_public_inbound'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
    }
    policyRule: {
      if: loadJsonContent('../rules/nsgrule_allows_public_inbound.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
