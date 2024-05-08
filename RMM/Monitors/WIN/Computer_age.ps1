# PowerShell Script to Retrieve and Simplify CPU Information
# the way this script filters teh model versions will only work untill 19900k 
# need to change the way it filters to based on how many digits there are for older PC's

# Get CPU information
$CpuInfo = Get-WmiObject Win32_Processor

# Display full CPU details
Write-Host "Full CPU Information:"
Write-Host "Name: $($CpuInfo.Name)"
Write-Host "Manufacturer: $($CpuInfo.Manufacturer)"
Write-Host "Description: $($CpuInfo.Description)"
Write-Host "Number of Cores: $($CpuInfo.NumberOfCores)"
Write-Host "Number of Logical Processors: $($CpuInfo.NumberOfLogicalProcessors)"
Write-Host "Max Clock Speed: $($CpuInfo.MaxClockSpeed) MHz"
Write-Host "L2 Cache Size: $($CpuInfo.L2CacheSize) KB"
Write-Host "L3 Cache Size: $($CpuInfo.L3CacheSize) KB"
Write-Host "Architecture: $(switch($CpuInfo.Architecture) {
    0 {"x86"}
    1 {"MIPS"}
    2 {"Alpha"}
    3 {"PowerPC"}
    6 {"IA64"}
    9 {"x64"}
    default {"Unknown"}
})"
Write-Host "Processor ID: $($CpuInfo.ProcessorId)"

# Extract and simplify CPU model name using regex
if ($CpuInfo.Name -match 'Intel|AMD') {
    $modelMatch = $CpuInfo.Name -match '(i[3579]-\d{4,5}[A-Z]*)'
    if ($modelMatch) {
        $simplifiedModel = $matches[0]  # This uses the automatic $matches array provided by PowerShell
        Write-Host "Simplified CPU Model: $simplifiedModel"
    } else {
        Write-Host "Model not found within expected patterns."
    }
} else {
    Write-Host "CPU Manufacturer not recognized or not specified."
}

# Remove the first three characters
$processedModel = $simplifiedModel.Substring(3)

# Use regex to remove any non-numeric characters from the end of the string
$finalModel = $processedModel -replace '[^\d]+$', ''

# Output the modified model
Write-Host "Processed CPU Model: $finalModel"

# Initialize base model year as 14 for 2023 and increment by 1 starting from January 1, 2025
#$baseYear = 2024
$latestVersion = 14 + [math]::Max(0, [int][math]::Floor(([int]$currentYear - 2024) / 1))
Write-Host "latestVersion is $latestVersion "

# Extract the first two digits of the $finalModel to determine the version year
$currentVersion = [int]$finalModel.Substring(0,2)
Write-Host "Current Version is $currentVersion "

# Check if the $currentVersion needs to be adjusted
if ($currentVersion -gt 19) {
    $currentVersion = [int]$finalModel.Substring(0,1)  # Use only the first digit
}

# Calculate the age of the PC based on the model version difference
$pc_age = $latestVersion - $currentVersion
Write-Host "The computer is $pc_age years old."

Write-Host "Adding this info to the asset custom field PC_Age_In_Years"
Set-Asset-Field -Name "PC_Age_In_Years" -Value $pc_age