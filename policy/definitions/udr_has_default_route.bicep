targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'udr_has_default_route'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
      location: loadJsonContent('../rules/_parameters.json').location
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
    }
    policyRule: {
      if: loadJsonContent('../rules/udr_is_missing_desired_default_route.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
