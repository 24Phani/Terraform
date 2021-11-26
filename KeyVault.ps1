$servicePrincipleName = "Terraform-SP"
$resourceGroupName = "Dev5"
$location = "EastUS"
$storageAccountName = "devtfstate11"
$storageContainerName = "tstate"
$vaultName = "TF24-KV"

$azKeyVaultParams = @{
    VaultName         = $vaultName
    ResourceGroupName = $resourceGroupName
    Location          = $location
    ErrorAction       = 'Stop'
    Verbose           = $VerbosePreference
}

$ApplicationId = "0a8fde67-b276-471e-9be3-a322aac3defb"
$servicePrinciplePassword = "kXmL7jXFloOpqV7zXlSEzH_NJ67OfvO4.V"

New-AzKeyVault @azKeyVaultParams | Out-String | Write-Verbose

$storageAccessKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName
$storageAccessKey = $storageAccessKeys[0].Value # only need one of the keys
$subscription = Get-AzSubscription -ErrorAction 'Stop'

$terraformLoginVars = @{
    'ARM-SUBSCRIPTION-ID' = $subscription.Id
    'ARM-CLIENT-ID'       = $ApplicationId
    'ARM-CLIENT-SECRET'   = $servicePrinciplePassword
    'ARM-TENANT-ID'       = $subscription.TenantId
    'ARM-ACCESS-KEY'      = $storageAccessKey
}
Write-Host "`nTerraform login details:"
$terraformLoginVars | Out-String | Write-Host

#region Create KeyVault Secrets
try {
    foreach ($terraformLoginVar in $terraformLoginVars.GetEnumerator()) {
        $AzKeyVaultSecretParams = @{
            VaultName   = $vaultName
            Name        = $terraformLoginVar.Key
            SecretValue = (ConvertTo-SecureString -String $terraformLoginVar.Value -AsPlainText -Force)
            ErrorAction = 'Stop'
            Verbose     = $VerbosePreference
        }
        Set-AzKeyVaultSecret @AzKeyVaultSecretParams | Out-String | Write-Verbose
    }
}catch {
    Write-Host "ERROR!" -ForegroundColor 'Red'
    throw $_
}
Write-Host "SUCCESS!" -ForegroundColor 'Green'