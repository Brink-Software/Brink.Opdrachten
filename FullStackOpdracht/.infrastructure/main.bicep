@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Specifies the application name for resources.')
param application string = substring('forgedemo${uniqueString(resourceGroup().id)}', 0, 15)

@description('Specifies the environment name for resources.')
param environment string = 'test'

@description('Specifies the environment name for resources.')
param applicationGroupId string = ''

@description('Specifies the tag name for container app.')
param tag string = 'v2'

var appIdName = 'id-${application}-${environment}'
var keyVaultName = 'kv-${application}-${environment}'
var acrName = 'acr${application}${environment}'
var logName = 'log-${application}-${environment}'
var containerEnvironmentName = 'ace-${application}-${environment}'
var serverName = 'sql${application}${environment}'

resource appId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  location: location
  name: appIdName
}

module log 'logs.bicep' = {
  name: 'log-analytics-workspace'
  params: {
    location: location
    name: logName
  }
}

module keyVault 'keyVault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    name: keyVaultName
    clientId: appId.properties.clientId
    tenantId: appId.properties.tenantId
    applicationGroupId: applicationGroupId
  }
}

module acr 'arc.bicep' = {
  name: 'container-registry'
  params: {
    name: acrName
    location: location
    appId: appId.properties.principalId
  }
}

module containerAppEnvironment 'container.environment.bicep' = {
  name: 'container-app-environment'
  params: {
    name: containerEnvironmentName
    location: location
    logClientId: log.outputs.clientId
    logClientSecret: log.outputs.clientSecret
  }
}

module containerApp 'container.app.bicep' = {
  name: 'container-app'
  dependsOn: [ acr ]
  params: {
    name: application
    location: location
    environmentId: containerAppEnvironment.outputs.id
    identityId: appId.id
    server:acr.outputs.loginServer
    tag: tag
  }
}

module sql 'sql.bicep' = {
  name: 'sql-server'
  params:{
     groupId: applicationGroupId
     serverName: serverName
     tenantId: appId.properties.tenantId
     location: location
     sqlDBName: 'FullstackOpdracht'
  }
}

@description('Output the login server property for later use')
output loginServer string = acr.outputs.loginServer
