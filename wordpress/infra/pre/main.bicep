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

module loggingDeployment 'logging.bicep' = {
  name: 'logging-deployment'
  params: {
    location: location
    appInsightsName: names.outputs.appInsightsName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
  }
}

// module vNetDeployment 'vnet.bicep' = {
//   name: 'vNet-deployment'
//   params: {
//     appSubnetName: names.outputs.appSubnetName
//     appSubnetNsgName: names.outputs.appSubnetNsgName
//     bastionSubnetName: names.outputs.bastionSubnetName
//     bastionSubnetNsgName: names.outputs.bastionSubnetNsgName
//     ipAddress: ipAddress
//     location: location
//     vNetName: names.outputs.vNetName
//   }
// }

module containerRegistryDeployment 'acr.bicep' = {
  name: 'container-registry-deployment'
  params: {
    containerRegistryName: names.outputs.containerRegistryName
    location: location
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
  }
}
