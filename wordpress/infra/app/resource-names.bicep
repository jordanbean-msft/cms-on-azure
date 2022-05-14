param appName string
param region string
param env string

output managedIdentityName string = 'mi-${appName}-${region}-${env}'
output appServiceName string = 'wa-wordpress-${appName}-${region}-${env}'
output keyVaultName string = 'kv-${appName}-${region}-${env}'
output appServicePlanName string = 'asp-${appName}-${region}-${env}'
output mysqlDatabaseName string = 'mysqldb-${appName}-${region}-${env}'
output mysqlServerName string = 'mysqls-${appName}-${region}-${env}'
output wordpressAdminUsernameSecretName string = 'wordpress-admin-username-${appName}-${region}-${env}'
output wordpressAdminPasswordSecretName string = 'wordpress-admin-password-${appName}-${region}-${env}'
output mysqlAdministratorLoginSecretName string = 'mysql-administrator-login-${appName}-${region}-${env}'
output mysqlAdministratorLoginPasswordSecretName string = 'mysql-administrator-login-password-${appName}-${region}-${env}'
output wordpressAdminEmailSecretName string = 'wordpress-admin-email-${appName}-${region}-${env}'
output cdnProfileName string = 'cdn-profile-${appName}-${region}-${env}'
output cdnEndpointName string = 'cdn-endpoint-${appName}-${region}-${env}'
output storageAccountName string = 'sa${appName}${region}${env}'
output storageAccountContainerName string = 'uploads'
