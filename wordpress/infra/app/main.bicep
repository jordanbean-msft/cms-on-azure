param appName string
param region string
param environment string
param location string = resourceGroup().location
param vNetName string
param appSubnetName string
param logAnalyticsWorkspaceName string
param appInsightsName string
param dockerRegistryUrl string
param wordpressTitle string
param wordpressImageTag string
param wordpressSku string
param wordpressSkuCode string
param wordpressWorkerSize int
param wordpressWorkerSizeId string
param wordpressNumberOfWorkers int
param mysqlVmName string
param mysqlServerEdition string
param mysqlVCores int
param mysqlSkuSizeMB string
param mysqlSkuFamily string
param mysqlBackupRetentionDays int
param mysqlStorageSizeMB int
@secure()
param mysqlAdministratorLogin string
@secure()
param mysqlAdministratorLoginPassword string
@secure()
param wordpressAdminEmail string
@secure()
param wordpressAdminUsername string
@secure()
param wordpressAdminPassword string

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    env: environment
  }
}

module managedIdentityDeployment 'managed-identity.bicep' = {
  name: 'managed-identity-deployment'
  params: {
    managedIdentityName: names.outputs.managedIdentityName
    location: location
  }
}

module keyVaultDeployment 'key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    location: location
    userAssignedManagedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    mysqlAdministratorLoginSecretName: names.outputs.mysqlAdministratorLoginSecretName
    mysqlAdministratorLogin: mysqlAdministratorLogin
    mysqlAdministratorLoginPasswordSecretName: names.outputs.mysqlAdministratorLoginPasswordSecretName
    mysqlAdministratorLoginPassword: mysqlAdministratorLoginPassword
    wordpressAdminEmailSecretName: names.outputs.wordpressAdminEmailSecretName
    wordpressAdminEmail: wordpressAdminEmail
    wordpressAdminUsernameSecretName: names.outputs.wordpressAdminUsernameSecretName
    wordpressAdminUsername: wordpressAdminUsername
    wordpressAdminPasswordSecretName: names.outputs.wordpressAdminPasswordSecretName
    wordpressAdminPassword: wordpressAdminPassword
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module mysqlDeployment 'mysql.bicep' = {
  name: 'mysql-deployment'
  params: {
    location: location
    mysqlSkuSizeMB: mysqlSkuSizeMB
    mysqlBackupRetentionDays: mysqlBackupRetentionDays
    mysqlAdministratorLogin: mysqlAdministratorLogin
    mysqlSkuFamily: mysqlSkuFamily
    mysqlServerEdition: mysqlServerEdition
    mysqlServerName: names.outputs.mysqlServerName
    mysqlVCores: mysqlVCores
    mysqlDatabaseName: names.outputs.mysqlDatabaseName
    mysqlAdministratorLoginPassword: mysqlAdministratorLoginPassword
    mysqlVmName: mysqlVmName
    mysqlStorageSizeMB: mysqlStorageSizeMB
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}

module storageDeployment 'storage.bicep' = {
  name: 'storage-deployment'
  params: {
    location: location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    storageAccountContainerName: names.outputs.storageAccountContainerName
    storageAccountName: names.outputs.storageAccountName
  }
}

module appServiceDeployment 'app-service.bicep' = {
  name: 'app-service-deployment'
  params: {
    location: location
    dockerRegistryUrl: dockerRegistryUrl
    wordpressAdminUsernameSecretName: names.outputs.wordpressAdminUsernameSecretName
    wordpressAdminPasswordSecretName: names.outputs.wordpressAdminPasswordSecretName
    wordpressTitle: wordpressTitle
    wordpressSku: wordpressSku
    wordpressWorkerSize: wordpressWorkerSize
    mysqlUserNameSecretName: names.outputs.mysqlAdministratorLoginSecretName
    wordpressImageTag: wordpressImageTag
    wordpressNumberOfWorkers: wordpressNumberOfWorkers
    appInsightsName: appInsightsName
    mysqlServerName: mysqlDeployment.outputs.mysqlServerName
    wordpressWorkerSizeId: wordpressWorkerSizeId
    userAssignedManagedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    wordpressSkuCode: wordpressSkuCode
    appServiceName: names.outputs.appServiceName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    mysqlDatabaseName: mysqlDeployment.outputs.mysqlDatabaseName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    wordpressAdminEmail: wordpressAdminEmail
    mysqlPasswordSecretName: names.outputs.mysqlAdministratorLoginPasswordSecretName
    appServicePlanName: names.outputs.appServicePlanName
    storageAccountContainerName: storageDeployment.outputs.storageAccountContainerName
    storageAccountName: storageDeployment.outputs.storageAccountName
  }
}

module cdnDeployment 'cdn.bicep' = {
  name: 'cdn-deployment'
  params: {
    appServiceName: appServiceDeployment.outputs.appServiceName
    cdnEndpointName: names.outputs.cdnEndpointName
    cdnProfileName: names.outputs.cdnProfileName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}
