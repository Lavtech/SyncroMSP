# Get Windows product key using PowerShell

# Query the registry to retrieve the product key
$keyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$valueName = "DigitalProductId"

# Get the byte array value of the product key
$digitalProductId = (Get-ItemProperty -Path $keyPath).$valueName

# Decode and format the product key
$decodedKey = [System.Text.Encoding]::ASCII.GetString($digitalProductId[52..66])
$productKey = ""
for ($i = 24; $i -ge 0; $i--) {
    $r = 0
    for ($j = 14; $j -ge 0; $j--) {
        $r = ($r * 256) -bxor $digitalProductId[$j + $i]
        $digitalProductId[$j + $i] = [math]::Floor([double]($r / 24))
        $r = $r % 24
    }
    $productKey = "BCDFGHJKMPQRTVWXY2346789"[$r] + $productKey
    if (($i % 5) -eq 0 -and $i -ne 0) {
        $productKey = "-" + $productKey
    }
}

# Output the product key
Write-Output "Windows Product Key: $productKey"
