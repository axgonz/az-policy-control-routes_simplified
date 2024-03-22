targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'allowed_locations'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
      allowedLocations: loadJsonContent('../rules/_parameters.json').allowedLocations
    }
    policyRule: {
      if: loadJsonContent('../rules/location_not_in_allowedLocations.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
