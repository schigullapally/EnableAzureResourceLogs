$workspaceid = "/subscriptions/gg7b9b1c-1234-4049-88b6-ff1234567/resourcegroups/nameoftheresourcegroup/providers/microsoft.operationalinsights/workspaces/nameoftheworkspace"
$subid = "subscriptionid where the resources belong to"

# Login to Azure - if already logged in, use existing credentials.
Write-Host "Authenticating to Azure..." -ForegroundColor Cyan
try
{
    $AzureLogin = Get-AzureRmSubscription 
}
catch
{
    $null = Login-AzureRmAccount
    $AzureLogin = Get-AzureRmSubscription
}

# Authenticate to Azure if not already authenticated 
# Ensure this is the subscription where your Azure Resources are you want to send diagnostic data from
If($AzureLogin)
{
   
    $SubscriptionID = Get-AzureRmSubscription -SubscriptionId $subid | Select-Object SubscriptionId

    # Get Subscriptions under the logged in account
        $ResourcesToCheck = @()
        $getnameofdiagnosticsettings = @()
        Write-Host "Selecting Azure Subscription: $($SubscriptionID.SubscriptionID) ..." -ForegroundColor Cyan
        $NULL = Select-AzureRmSubscription -SubscriptionId $($SubscriptionID.SubscriptionID)
        $ResourcesToCheck = Get-AzureRmResource | select-object ResourceId, ResourceType
        write-host "number of resources " $ResourcesToCheck.Count
        
        foreach ($resource in $ResourcesToCheck)
        {

        $resourceidtoenable = $resource.ResourceId

         write-host "$($resourceidtoenable)"
        
            
                    $getnameofdiagnosticsettings = Get-AzureRmDiagnosticSetting -ResourceId $resourceidtoenable | select-object Name

                    foreach($diagtoremove in $getnameofdiagnosticsettings)
                    {
                        #Remove-AzureRmDiagnosticSetting -ResourceId "$($resourceidtoenable)" -Name $diagtoremove.Name
                        Set-AzureRmDiagnosticSetting -ResourceId $resourceidtoenable -Name $diagtoremove.Name -Enabled $false
                    }
                    
                    write-host $resource.ResourceType.Split("/")[-1]

                    if ($resource.ResourceType.Split("/")[-1] -eq "networkSecurityGroups")
                    {
                        Set-AzureRmDiagnosticSetting -Name "Logstooms" -ResourceId $resourceidtoenable -WorkspaceId $workspaceid -Enabled $True -Categories "NetworkSecurityGroupEvent","NetworkSecurityGroupRuleCounter"
                    }

                    Set-AzureRmDiagnosticSetting -Name "Metricstooms" -ResourceId $resourceidtoenable -WorkspaceId ($workspaceid) -Enabled $True -MetricCategory "AllMetrics"

                    $setting = Get-AzureRmDiagnosticSetting -ResourceId $resourceidtoenable
                    
                    if ($setting.Logs) 
                        { 
                            $Categories = $setting.Logs.category

                            foreach ($cat in $categories) 
                            
                            {

                                write-host $cat
                                
                                Set-AzureRmDiagnosticSetting -Name "Logstooms" -ResourceId $resourceidtoenable -WorkspaceId ($workspaceid) -Enabled $True -Categories $cat



                            }
                        
                        }
                   
                
          

        }
        
 


}
