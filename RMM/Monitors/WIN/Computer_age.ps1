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


# Output the modified model
#Write-Host "Processed CPU Model: $processedModel"

# Search for CPU name in the Intel list and retrieve year
if ($CpuInfo.Manufacturer -eq "GenuineIntel") {
    $modelMatch = $CpuInfo.Name -match '(i[3579]-\d{4,5})'
    if ($modelMatch) {
        $simplifiedModel = $matches[0]  # This uses the automatic $matches array provided by PowerShell
        Write-Host "Simplified CPU Model: $simplifiedModel"
    }
        # Remove any digits or letters at the end of the number
        $processedModel = $simplifiedModel -replace '\D*$'

        $FoundCPU = $response.Intel | Where-Object { $_.Model -eq $processedModel }
        if ($FoundCPU) {
            $CpuYear = $FoundCPU.Year
            Write-Host "CPU Year: $CpuYear"

            # Get current year
            $CurrentYear = Get-Date -Format "yyyy"

            # Calculate PC age
            $PC_Age = $CurrentYear - $CpuYear
            Write-Host "PC Age: $PC_Age years"
        } else {
            # Debugging: Output all Intel models to see if there's a discrepancy
            Write-Host "All Intel models:"
            $response.Intel | ForEach-Object { Write-Host $_.Model }

            Write-Host "CPU model $processedModel not found in the Intel list."
}
} elseif ($CpuInfo.Manufacturer -eq "AuthenticAMD") {
    if ($CpuName -match '\bFX(?:.*?)(\d{4})\b') {
        $simplifiedModel = $matches[1]  # Extracting the 4-digit number from the CPU name
    } elseif ($CpuName -match '\bRyzen\s+\d+\s+(\d{4})\b') {
        $simplifiedModel = $matches[1]  # Extracting the 4-digit number from the CPU name
    }

    if ($simplifiedModel) {
        Write-Host "Simplified CPU Model: $simplifiedModel"

        $FoundCPU = $response.AMD | Where-Object { $_.Model -eq $simplifiedModel }
        if ($FoundCPU) {
            $CpuYear = $FoundCPU.Year
            Write-Host "CPU Year: $CpuYear"

            # Get current year
            $CurrentYear = Get-Date -Format "yyyy"

            # Calculate PC age
            $PC_Age = $CurrentYear - $CpuYear
            Write-Host "PC Age: $PC_Age years"
        } else {
            Write-Host "CPU model $simplifiedModel not found in the AMD list."
        }
    } else {
        Write-Host "No compatible CPU model found in the AMD list."
    }
}

Write-Host "Adding this info to the asset custom field PC_Age_In_Years"
Set-Asset-Field -Name "PC_Age_In_Years" -Value $pc_age