param appName string
param region string
param env string

output vNetName string = 'vNet-${appName}-${region}-${env}'
output appSubnetName string = 'app'
output bastionSubnetName string = 'AzureBastionSubnet'
output appSubnetNsgName string = 'nsg-app-${appName}-${region}-${env}'
output bastionSubnetNsgName string = 'nsg-bastion-${appName}-${region}-${env}'
