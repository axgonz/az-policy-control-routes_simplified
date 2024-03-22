targetScope = 'tenant'

resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'policy_definitions'
  properties: {
    displayName: 'Policy definitions'
  }
}
