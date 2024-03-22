targetScope = 'resourceGroup'

param location string = resourceGroup().location
param name string
param nextHopIpAddress string

resource routeTable 'Microsoft.Network/routeTables@2023-06-01' = {
  name: name
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: nextHopIpAddress
        }
      }
    ]
  }
}
