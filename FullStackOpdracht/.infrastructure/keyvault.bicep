param name string
param location string
param clientId string
param tenantId string
param applicationGroupId string


resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  location: location
  name: name
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
      {
        objectId: clientId
        tenantId: tenantId
        permissions: {
          secrets: [ 
            'get'
            'list' 
            'set'
          ]
        }
      }
    ]
  }
}

resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01' = if(!empty(applicationGroupId)) {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [
      {
        objectId: applicationGroupId
        tenantId: tenant().tenantId
        permissions: {
          secrets: [ 
            'get'
            'list' 
            'set'
          ]
        }
      } ]
  }
}
