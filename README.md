# EnableAzureResourceLogs
Enabling Azure Resources Logs
####################################################
This script will delete the existing log profile on the resources and turn on the diagnostic logs of Azure resources in specific subscription and stream them to OMS workspace (OMS workspace can be in any subscription).
1. Diagnostic logs are divided into two types: 'Logs' and 'All Metrics'
2. Script will first turn on "All Metrics" and then it will turn on "Logs"
3. If "All Metrics" doesn't exist then it will not turn on the "Logs"
4. Script will additionally turn on NSG logs though "All Metrics" doesn't exists for them
####################################################
