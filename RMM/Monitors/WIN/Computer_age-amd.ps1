# PowerShell Script to Retrieve and Simplify AMD CPU Information

# Fetch the CPU list from GitHub
$response = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lavtech/SyncroMSP/main/RMM/cpu_list"

# Example of accessing data
foreach ($cpu in $response.AMD) {
    Write-Host "Model: $($cpu.Model), Architecture: $($cpu.Architecture), Year: $($cpu.Year)"
}

# Example of accessing data
foreach ($cpu in $response.Intel) {
    Write-Host "Model: $($cpu.Model), Year: $($cpu.Year)"
}
