targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'subnet_is_associated_with_desired_udr'
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
      routeTableName: loadJsonContent('../rules/_parameters.json').routeTableName
      resourceGroupName: loadJsonContent('../rules/_parameters.json').resourceGroupName
      excludedSubnets: loadJsonContent('../rules/_parameters.json').excludedSubnets
    }
    policyRule: {
      if: loadJsonContent('../rules/subnet_is_missing_desired_udr.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
