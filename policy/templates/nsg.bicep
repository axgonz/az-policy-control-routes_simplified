targetScope = 'resourceGroup'

param location string = resourceGroup().location
param name string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-06-01' = {
  name: name
  location: location
}
