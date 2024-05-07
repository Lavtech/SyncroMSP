
$LastRebootTime = Get-WmiObject win32_operatingsystem | 
select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}

$Today = Get-Date
$DiffDays = $Today.Date - $LastRebootTime.LastBootUpTime.Date

Write-Host "Days since boot: $($DiffDays.TotalDays)" 


if($DiffDays.TotalDays -gt 30){
 Rmm-Alert -Category "uptime_trigger" -Body "This machine has been online too long! Days since boot: $($DiffDays.TotalDays)"  
}
