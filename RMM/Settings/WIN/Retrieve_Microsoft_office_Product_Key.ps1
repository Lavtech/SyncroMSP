#$officeKey = cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus | findstr /c:"Product Key"

$officeKey = (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Installer\UserData" | ForEach-Object {Get-ItemProperty -Path ("HKLM:\Software\Microsoft\Windows\CurrentVersion\Installer\UserData\" + $_.PSChildName) -Name "ProductCode"} | Select-Object -ExpandProperty "ProductCode")


Write-Host "MS Office Product Key:" $officeKey
# This can write to your Asset Custom Fields. Use it to store adhoc information that isn't currently surfaced.
Set-Asset-Field -Name "Office_Key" -Value $officeKey