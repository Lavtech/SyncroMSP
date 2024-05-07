# This PowerShell script will allow Syncro agent to run in safe mode as well.

# Ensure the PowerShell session has administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please run this script as an Administrator!"
    Exit
}

# Path to the registry key under HKLM
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Network"

# List of services to be added
$services = @("Syncro", "SyncroLive", "SyncroOvermind")

# Add each service to the registry
foreach ($service in $services) {
    $keyPath = Join-Path -Path $registryPath -ChildPath $service
    # Create the registry key if it does not exist
    if (-not (Test-Path $keyPath)) {
        New-Item -Path $keyPath -Force
    }
    # Set the default value of the key
    Set-ItemProperty -Path $keyPath -Name "(Default)" -Value "Service"
}

Write-Host "Registry keys have been added to enable Syncro agent in Safe Mode."
