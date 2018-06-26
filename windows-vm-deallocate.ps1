$jsonBody = Invoke-RestMethod -Headers @{"Metadata"="true"} -URI http://169.254.169.254/metadata/instance?api-version=2017-08-01 -Method get

$vmname = $jsonBody.compute.name
$resourceGroupName = $jsonBody.compute.resourceGroupName
$subscriptionId = $jsonBody.compute.subscriptionId

$response = Invoke-WebRequest -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F" -Headers @{Metadata="true"}
$content =$response.Content | ConvertFrom-Json
$access_token = $content.access_token

Invoke-WebRequest -Uri https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.Compute/virtualMachines/$($vmname)/deallocate?api-version=2017-12-01 -Method POST -ContentType "application/json" -Headers @{ Authorization ="Bearer $access_token"}
