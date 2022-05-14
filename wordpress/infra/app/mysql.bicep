param mysqlServerName string
param mysqlDatabaseName string
@secure()
param mysqlAdministratorLogin string
@secure()
param mysqlAdministratorLoginPassword string
param location string
param mysqlVmName string
param mysqlServerEdition string
param mysqlVCores int
param mysqlSkuSizeMB string
param mysqlSkuFamily string
param mysqlBackupRetentionDays int
param mysqlStorageSizeMB int
param logAnalyticsWorkspaceName string

resource mysqlServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: mysqlServerName
  location: location
  tags: {
    'AppProfile': 'Wordpress'
  }
  properties: {
    createMode: 'Default'
    administratorLogin: mysqlAdministratorLogin
    administratorLoginPassword: mysqlAdministratorLoginPassword
    version: '5.7'
    storageProfile: {
      storageMB: mysqlStorageSizeMB
      backupRetentionDays: mysqlBackupRetentionDays
      geoRedundantBackup: 'Disabled'
      storageAutogrow: 'Enabled'
    }
    sslEnforcement: 'Enabled'
  }
  sku: {
    name: mysqlVmName
    tier: mysqlServerEdition
    capacity: mysqlVCores
    size: mysqlSkuSizeMB
    family: mysqlSkuFamily
  }
  resource allowAllWindowsAzureIps 'firewallRules@2017-12-01' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }
}

resource mysql 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = {
  name: '${mysqlServer.name}/${mysqlDatabaseName}'
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'DiagnosticSettings'
  scope: mysqlServer
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'MySqlSlowLogs'
        enabled: true
      }
      {
        category: 'MySqlAuditLogs'
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

output mysqlServerName string = mysqlServer.name
output mysqlDatabaseName string = mysqlDatabaseName
