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
    enableRbacAuthorization: true
    enabledForTemplateDeployment: true
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

var keyVaultSecretsUserRoleDefinitionId = '4633458b-17de-408a-b874-0445c86b69e6'

resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(keyVaultSecretsUserRoleDefinitionId, userAssignedManagedIdentity.id, keyVault.id)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultSecretsUserRoleDefinitionId)
    principalId: userAssignedManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output keyVaultName string = keyVaultName
