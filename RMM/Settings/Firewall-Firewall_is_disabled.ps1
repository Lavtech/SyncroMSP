# The firewall is Enabled and will Disable it.
#Import-Module $env:SyncroModule
#Rmm-Alert -Category 'Firewall Enabled' -Body 'Firewall Enabled'
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
