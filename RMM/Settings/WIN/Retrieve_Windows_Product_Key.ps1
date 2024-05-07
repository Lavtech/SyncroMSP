
$key = (Get-WmiObject -query ‘select * from SoftwareLicensingService’).OA3xOriginalProductKey
# This can write to your Asset Custom Fields. Use it to store adhoc information that isn't currently surfaced.
Set-Asset-Field -Name "Windows_Key" -Value $key