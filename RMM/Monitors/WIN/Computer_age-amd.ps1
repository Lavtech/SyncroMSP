# Fetch the CPU list from GitHub
$response = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lavtech/SyncroMSP/main/RMM/cpu_list"
# Convert from JSON if not automatically parsed
if ($response -is [String]) {
    $response = $response | ConvertFrom-Json
}

# Example of accessing data
foreach ($cpu in $response.AMD) {
    Write-Host "Model: $($cpu.Model), Year: $($cpu.Year)"
}

foreach ($cpu in $response.Intel) {
    Write-Host "Model: $($cpu.Model), Year: $($cpu.Year)"
}