# Get Microsoft Office product key for versions 2013 and older using PowerShell

# Define an array to store potential registry locations
$registryLocations = @(
    "HKLM:\Software\Microsoft\Office\15.0\Registration",
    "HKLM:\Software\Microsoft\Office\14.0\Registration",
    "HKLM:\Software\Microsoft\Office\12.0\Registration"
)

# Iterate through each potential registry location to find the product key
foreach ($location in $registryLocations) {
    $officeKey = Get-ChildItem $location | ForEach-Object {
        $productCode = $_.GetValue("DigitalProductID")
        if ($productCode) {
            # Decode the product key
            $decodedKey = [System.Text.Encoding]::Convert.FromBase64String($productCode)
            $productKey = ""
            for ($i = 52; $i -le 66; $i++) {
                $productKey += [char]$decodedKey[$i]
            }
            $productKey
        }
    }
    # If product key is found, break the loop
    if ($officeKey) {
        break
    }
}

# Output the Office product key
if ($officeKey) {
    Write-Output "Microsoft Office Product Key: $officeKey"
} else {
    Write-Output "Microsoft Office product key not found."
}


Write-Host "MS Office Product Key:" $officeKey
# This can write to your Asset Custom Fields. Use it to store adhoc information that isn't currently surfaced.
#Set-Asset-Field -Name "Office_Key" -Value $officeKey