$subscriptionId = "YourSubscriptionId"
$body = $null 
$TokenReturn = $(az account get-access-token --resource https://management.azure.com | convertfrom-json -depth 10).accessToken 
$HttpClient = [System.Net.Http.HttpClient]::new()
$HttpRequestMessage = [System.Net.Http.HttpRequestMessage]::new()
$HttpRequestMessage.Content = [System.Net.Http.StringContent]::new( $body, [System.Text.Encoding]::UTF8, 'application/json')
$HttpRequestMessage.Method = 'GET'
$HttpRequestMessage.Headers.Add('authorization', $('bearer ' + $TokenReturn))
$HttpRequestMessage.RequestUri = "https://management.azure.com/subscriptions/$($subscriptionId)/providers/Microsoft.Sql/servers?api-version=2022-05-01-preview"
$InvokeReturn = $HttpClient.SendAsync($HttpRequestMessage).GetAwaiter().GetResult()
If ($InvokeReturn.statuscode.Value__ -eq 200) {
    $($InvokeReturn.Content.ReadAsStringAsync().GetAwaiter().GetResult() | ConvertFrom-Json -Depth 100).value
}

EXAMPLE RETURN
{
    "kind": "v12.0",
    "properties": {
        "administratorLogin": "",
        "version": "12.0",
        "state": "Ready",
        ######### USE THIS SECTION TO QUEUE UP THE SQL SERVERS FOR THE PRIVATE ENDPOINT CREATION #########
        "fullyQualifiedDomainName": "",
        "privateEndpointConnections": [
        {
            "id": "/subscriptions//resourceGroups//providers/Microsoft.Sql/servers//privateEndpointConnections/",
            "properties": {
                "privateEndpoint": {
                    "id": "/subscriptions//resourceGroups//providers/Microsoft.Network/privateEndpoints/"
                },
                "groupIds": [
                "sqlServer"
                ],
                "privateLinkServiceConnectionState": {
                    "status": "Approved",
                    "description": "Auto-approved",
                    "actionsRequired": "None"
                },
                "provisioningState": "Ready"
            }
        }
        ],
        ######### USE THIS SECTION TO QUEUE UP THE SQL SERVERS FOR THE PRIVATE ENDPOINT CREATION #########
    }
}
