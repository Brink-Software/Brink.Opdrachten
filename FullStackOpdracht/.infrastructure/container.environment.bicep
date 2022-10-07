param name string
param location string
param logClientId string
@secure()
param logClientSecret string

resource env 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logClientId
        sharedKey: logClientSecret
      }
    }
  }
}
output id string = env.id
