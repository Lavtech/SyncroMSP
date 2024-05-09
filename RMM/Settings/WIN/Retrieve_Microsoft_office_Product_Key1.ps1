# Import the Microsoft Online Services Module
install-Module MSOnline

# Connect to Office 365
Connect-MsolService

# Get license information for Office 365
Get-MsolAccountSku