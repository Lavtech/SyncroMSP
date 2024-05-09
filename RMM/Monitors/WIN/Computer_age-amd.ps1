# Get CPU information
$CpuInfo = Get-WmiObject Win32_Processor

# Extract CPU name
$CpuName = $CpuInfo.Name

# Retrieve CPU list from URL
$response = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Lavtech/SyncroMSP/main/RMM/cpu_list.json"
if ($response -is [String]) {
    $response = $response | ConvertFrom-Json
}

Write-Host "CPU Name: $CpuName"

# Extract and simplify CPU model name using regex
if ($CpuInfo.Manufacturer -eq "GenuineIntel") {
    $modelMatch = $CpuInfo.Name -match '(i[3579]-\d{4,5})'
    if ($modelMatch) {
        $simplifiedModel = $matches[0]  # This uses the automatic $matches array provided by PowerShell
        Write-Host "Simplified CPU Model: $simplifiedModel"
    } else {
        Write-Host "Model not found within expected patterns."
    }
} else {
    Write-Host "CPU Manufacturer not recognized or not specified."
}

# Remove any digits or letters at the end of the number
$processedModel = $simplifiedModel -replace '\D*$'

# Output the modified model
Write-Host "Processed CPU Model: $processedModel"

# Search for CPU name in the Intel list and retrieve year
if ($CpuInfo.Manufacturer -eq "GenuineIntel") {
    $FoundCPU = $response.Intel | Where-Object { $_.Model -eq $processedModel }
    if ($FoundCPU) {
        $CpuYear = $FoundCPU.Year
        Write-Host "CPU Year: $CpuYear"
    } else {
        Write-Host "CPU model $processedModel not found in the Intel list."
    }
} else {
    Write-Host "CPU Manufacturer not recognized or not specified."
}