# Import Syncro Module if it's not already loaded

Import-Module $env:SyncroModule

# Check the status of the Firewall for all profiles
$firewallProfiles = Get-NetFirewallProfile

# Check if any firewall profile is disabled
$firewallDisabled = $firewallProfiles | Where-Object { $_.Enabled -eq $false }

# If there is any firewall profile that is disabled
if ($firewallDisabled.Count -gt 0) {
    # Send an RMM alert indicating the firewall is disabled
#    Rmm-Alert -Category 'Firewall' -Body 'Firewall is disabled'
    Write-Host "Firewall is disabled. We are all good here, Nothing to do."
} else {
    # Send an RMM alert indicating the firewall is enabled
    Rmm-Alert -Category 'Firewall_Is_Enabled' -Body 'Firewall is enabled'
    Write-Host "Firewall is enabled. Alert has been created."
}
