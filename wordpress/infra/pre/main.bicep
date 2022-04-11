param appName string
param region string
param environment string
param location string = resourceGroup().location
param ipAddress string = ''

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    env: environment
  }
}

module vNetDeployment 'vnet.bicep' = {
  name: 'vNet-deployment'
  params: {
    appSubnetName: names.outputs.appSubnetName
    appSubnetNsgName: names.outputs.appSubnetNsgName
    bastionSubnetName: names.outputs.bastionSubnetName
    bastionSubnetNsgName: names.outputs.bastionSubnetNsgName
    ipAddress: ipAddress
    location: location
    vNetName: names.outputs.vNetName
  }
}
