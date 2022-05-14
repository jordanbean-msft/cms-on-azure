param appServicePlanName string
param appServiceName string
param location string
param keyVaultName string
param appInsightsName string
param logAnalyticsWorkspaceName string
param userAssignedManagedIdentityName string
param dockerRegistryUrl string
param mysqlServerName string
param mysqlDatabaseName string
param mysqlUserNameSecretName string
param mysqlPasswordSecretName string
param wordpressAdminEmail string
param wordpressAdminUsernameSecretName string
param wordpressAdminPasswordSecretName string
param wordpressTitle string
param wordpressImageTag string
param wordpressSku string
param wordpressSkuCode string
param wordpressWorkerSize int
param wordpressWorkerSizeId string
param wordpressNumberOfWorkers int
param storageAccountName string
param storageAccountContainerName string

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource userAssignedManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: userAssignedManagedIdentityName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2018-11-01' = {
  name: appServicePlanName
  location: location
  kind: 'app,linux,container'
  properties: {
    name: appServicePlanName
    workerSize: wordpressWorkerSize
    workerSizeId: wordpressWorkerSizeId
    numberOfWorkers: wordpressNumberOfWorkers
    reserved: true
  }
  sku: {
    name: wordpressSkuCode
    tier: wordpressSku
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    keyVaultReferenceIdentity: userAssignedManagedIdentity.id
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: true
      linuxFxVersion: wordpressImageTag
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'default'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: dockerRegistryUrl
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'true'
        }
        {
          name: 'DATABASE_HOST'
          value: '${mysqlServerName}.mysql.database.azure.com'
        }
        {
          name: 'DATABASE_NAME'
          value: mysqlDatabaseName
        }
        {
          name: 'DATABASE_USERNAME'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${mysqlUserNameSecretName})'
        }
        {
          name: 'DATABASE_PASSWORD'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${mysqlPasswordSecretName})'
        }
        {
          name: 'WORDPRESS_ADMIN_EMAIL'
          value: wordpressAdminEmail
        }
        {
          name: 'WORDPRESS_ADMIN_USER'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${wordpressAdminUsernameSecretName})'
        }
        {
          name: 'WORDPRESS_ADMIN_PASSWORD'
          value: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${wordpressAdminPasswordSecretName})'
        }
        {
          name: 'WORDPRESS_TITLE'
          value: wordpressTitle
        }
        {
          name: 'WEBSITES_CONTAINER_START_TIME_LIMIT'
          value: '900'
        }
        {
          name: 'CDN_ENABLED'
          value: 'true'
        }
        {
          name: 'CDN_ENDPOINT'
          value: 'https://${appServiceName}.azureedge.net'
        }
      ]
      azureStorageAccounts: {
        'fileShare': {
          type: 'AzureFiles'
          accountName: storageAccount.name
          shareName: storageAccountContainerName
          mountPath: '/home/site/wwwroot/wp-content/uploads'
          accessKey: storageAccount.listKeys().keys[0].value
        }
      }
      connectionStrings: []
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentity.id}': {}
    }
  }
}

resource appDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'DiagnosticSettings'
  scope: appService
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceIPSecAuditLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output appServiceName string = appService.name
