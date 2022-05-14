param cdnProfileName string
param cdnEndpointName string
param appServiceName string

resource cdnProfile 'Microsoft.Cdn/profiles@2020-04-15' = {
  name: cdnProfileName
  location: 'Global'
  sku: {
    name: 'Standard_Microsoft'
  }
  tags: {
    'AppProfile': 'Wordpress'
  }
}

resource cdnEndpoint 'Microsoft.Cdn/profiles/endpoints@2020-04-15' = {
  name: '${cdnProfileName}/${cdnEndpointName}'
  location: 'Global'
  properties: {
    isHttpAllowed: true
    isHttpsAllowed: true
    originHostHeader: '${appServiceName}.azurewebsites.net'
    origins: [
      {
        name: '${appServiceName}-azurewebsites-net'
        properties: {
          hostName: '${appServiceName}.azurewebsites.net'
          httpPort: 80
          httpsPort: 443
          originHostHeader: '${appServiceName}.azurewebsites.net'
          priority: 1
          weight: 1000
          enabled: true
        }
      }
    ]
    isCompressionEnabled: true
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
  }
}
