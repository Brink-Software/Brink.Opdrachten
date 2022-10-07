param name string
param location string
param environmentId string
param identityId string
param server string

resource nginxcontainerapp 'Microsoft.App/containerApps@2022-03-01' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identityId}': {}
    }
  }
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: server
          identity: identityId
        }
      ]
    }
    template: {
      containers: [
        {
          image: 'acrforgedemowf6edetest.azurecr.io/forgedemo:v2'
          name: 'forgedemo'
          resources: {
            cpu: '0.5'
            memory: '1.0Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}
