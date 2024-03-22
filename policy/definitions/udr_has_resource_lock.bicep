targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'udr_has_resource_lock'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      lock: loadJsonContent('../rules/_parameters.json').lock
    }
    policyRule: {
      if: loadJsonContent('../rules/udr_is_missing_resource_lock.json').if
      then: {
        details: {
          existenceCondition: {
            field: 'Microsoft.Authorization/locks/level'
            equals: '[parameters(\'lock\')]'
          }
          type: 'Microsoft.Authorization/locks'
        }
        effect: 'auditIfNotExists'
      }
    }
  }
}
