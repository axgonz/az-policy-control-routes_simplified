targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'udr_has_bgp_propagation_disabled'
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
      if: loadJsonContent('../rules/udr_has_bgp_propagation_enabled.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
