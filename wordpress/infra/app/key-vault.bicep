param keyVaultName string
param location string
param userAssignedManagedIdentityName string
param mysqlAdministratorLoginSecretName string
@secure()
param mysqlAdministratorLogin string
param mysqlAdministratorLoginPasswordSecretName string
@secure()
param mysqlAdministratorLoginPassword string
param wordpressAdminEmailSecretName string
@secure()
param wordpressAdminEmail string
param wordpressAdminUsernameSecretName string
@secure()
param wordpressAdminUsername string
param wordpressAdminPasswordSecretName string
@secure()
param wordpressAdminPassword string
param logAnalyticsWorkspaceName string

resource userAssignedManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: userAssignedManagedIdentityName
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    enabledForTemplateDeployment: true
    accessPolicies: [
      {
        objectId: userAssignedManagedIdentity.properties.principalId
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
  resource mysqlAdministratorLoginSecret 'secrets@2021-10-01' = {
    name: mysqlAdministratorLoginSecretName
    properties: {
      value: mysqlAdministratorLogin
    }
  }
  resource mysqlAdministratorLoginPasswordSecret 'secrets@2021-10-01' = {
    name: mysqlAdministratorLoginPasswordSecretName
    properties: {
      value: mysqlAdministratorLoginPassword
    }
  }
  resource wordpressAdminEmailSecret 'secrets@2021-10-01' = {
    name: wordpressAdminEmailSecretName
    properties: {
      value: wordpressAdminEmail
    }
  }
  resource wordpressAdminUsernameSecret 'secrets@2021-10-01' = {
    name: wordpressAdminUsernameSecretName
    properties: {
      value: wordpressAdminUsername
    }
  }
  resource wordpressAdminPasswordSecret 'secrets@2021-10-01' = {
    name: wordpressAdminPasswordSecretName
    properties: {
      value: wordpressAdminPassword
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'DiagnosticSettings'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'AuditEvent'
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

output keyVaultName string = keyVaultName
