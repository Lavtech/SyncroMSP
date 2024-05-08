# Fetch the CPU list from GitHub
$response = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lavtech/SyncroMSP/main/RMM/cpu_list"

# Assuming $response already contains the structured data
# Example of accessing data
foreach ($cpu in $response.AMD) {
    Write-Host "Model: $($cpu.Model), Architecture: $($cpu.Architecture), Year: $($cpu.Year)"
}

foreach ($cpu in $response.Intel) {
    Write-Host "Model: $($cpu.Model), Year: $($cpu.Year)"
}