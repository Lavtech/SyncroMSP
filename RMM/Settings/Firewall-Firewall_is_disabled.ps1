# The firewall is Enabled and will Disable it.
#Import-Module $env:SyncroModule

Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Closing RMM ALert
Close-Rmm-Alert -Category "Firewall_Is_Enabled"