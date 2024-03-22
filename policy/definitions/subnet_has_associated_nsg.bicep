targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'subnet_has_associated_nsg'
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
      if: loadJsonContent('../rules/subnet_has_no_nsg.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
