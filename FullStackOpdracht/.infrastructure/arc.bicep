param name string
param location string
param appId string

resource acrResource 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource  AssignAcrPullToAks 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, name, appId, 'AssignAcrPullToContainerApp')       // want consistent GUID on each run
  scope: acrResource
  properties: {
    principalId: appId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','7f951dda-4ed3-4680-a7ca-43fe172d538d')
  }
}


output loginServer string =  acrResource.properties.loginServer
