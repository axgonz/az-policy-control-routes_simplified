targetScope = 'subscription'

param location string = deployment().location
param resourceGroupName string
param routeTableName string
param nextHopIpAddress string

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

module routeTable 'udr.bicep' = {
  name: 'deploy_${routeTableName}'
  scope: rg
  params: {
    name: routeTableName
    location: location
    nextHopIpAddress: nextHopIpAddress
  }
}
