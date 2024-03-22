targetScope = 'managementGroup'

param location string = deployment().location

var config = loadJsonContent('../config.json')
var shortLocation = config.regionPrefixLookup[location]

module rg 'modules/rg.bicep' = [for subscriptionId in config.stacks.targetSubscriptions: {
  name: 'deploy_${config.resourceGroupName}_${shortLocation}'
  scope: subscription(subscriptionId)
  params: {
    location: location
    resourceGroupName: '${config.resourceGroupName}_${shortLocation}'
    routeTableName: '${config.routeTable.name}_${shortLocation}'
    nextHopIpAddress: config.nextHopIpAddressLookup[location]
  }
}]
