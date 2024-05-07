
#### Script File Managment Section ####
# Set the file path
$filePath = "C:\ProgramData\LTC\AgentData\rebootevent.txt"
$ticketfilePath = "C:\ProgramData\LTC\AgentData\ticketid.txt"

# Check if the folder exists, and create it if it doesn't
$folderPath = Split-Path -Path $filePath -Parent
if (-not (Test-Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
}

# Check if the file exists, and create it if it doesn't
if (-not (Test-Path $filePath -PathType Leaf)) {
    New-Item -Path $filePath -ItemType File -Force | Out-Null
}


#This gets the uptime from windows
$LastRebootTime = Get-WmiObject win32_operatingsystem | 
select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}

#$Today = Get-Date
#$DiffDays = $Today.Date - $LastRebootTime.LastBootUpTime.Date


$Today = Get-Date
$Uptime = $Today - $LastRebootTime.LastBootUpTime
$DiffDays = $Today.hour - $LastRebootTime.LastBootUpTime.hour

# Clear the previous content in the file
$null | Set-Content -Path $filePath

# Writes and Append the uptime information to the log file
#$uptimeInfo = "Uptime (Days:Hours:Minutes) $($Uptime.Days):$($Uptime.Hours):$($Uptime.Minutes)"
#Add-Content -Path $filePath -Value $uptimeInfo
# Format the uptime information
$uptimeInfo = @"
Computer Uptime:
Days: $($Uptime.Days)
Hours: $($Uptime.Hours)
Minutes: $($Uptime.Minutes)
"@
Add-Content -Path $filePath -Value $uptimeInfo




#Writes to event log on the computer in the systems catagory
#Write-Host "Days since boot: $($DiffDays.TotalDays)" 
Write-Host "Days since boot: $($DiffDays.hour)"
if($DiffDays.TotalHours -gt 30){
    $eventLog = "System"
    $eventSource = "Lavtech Managed Services"
    $eventID = 2074
    $eventMessage = "System needs a rebooted due to uptime limit reached of $($DiffDays.TotalDays). Reboot will be performed by Lavtech Managed Services."

    Write-EventLog -LogName $eventLog -Source $eventSource -EventID $eventID -EntryType Warning -Message $eventMessage
 Rmm-Alert -Category "uptime_trigger" -Body "This computer has been chugging along without a break for so long, it's starting to think it's human! Days since last restart: $($DiffDays.TotalDays)"  
}

# This will create a Ticket attached to the Asset & Asset Customer.
# You can capture the value of this command to save the ticket_id or ticket.number like:
# $value = Create-Syncro-Ticket
# Write-Host $value.ticket.id
$value = Create-Syncro-Ticket -Subdomain lavtech -Subject "Machine has been powered on too long. Scheduling a reboot at 12:00pm. EventID: 2074" -IssueType "Support | Remote" -Status "In Progress" -UserIdOrEmail "149848"
$ticketID = $value.ticket.id

Create-Syncro-Ticket-Comment -Subdomain lavtech -TicketIdOrNumber $ticketID -Subject "Update" -Body "This computer: $env:COMPUTERNAME has been chugging along without a break for $($Uptime.Days) Days, it's starting to think it's human! Days since last restart: $($DiffDays.TotalDays)" -Hidden "false" -DoNotEmail "true" -UserIdOrEmail "149848"


# Clear the previous content in the file
$null | Set-Content -Path $ticketfilePath

# Write Ticket Number to txt file for future scripts
Add-Content -Path $ticketfilePath -Value $ticketID


# This will add a comment to the ticket created in this above script. it will also assign the ticket to the userID: 149848 "John". Also you can have it be "public" or "private", and email or not, and combine those.
# To find userID loginto Syncro and navagate to 
# For example you can make a Public comment (shows on PDF/etc) and have it NOT email the customer.
Create-Syncro-Ticket-Comment -Subdomain lavtech -TicketIdOrNumber $ticketID -Subject "Update" -Body "Starting automatic reslolution. Created windows task scheduler to restart PC at 12:00 am. We will check to see if the PC rebooted on the next day." -Hidden "false" -DoNotEmail "true" -UserIdOrEmail "149848"


# This logs an activity feed item on an Assets's Activity feed
Log-Activity -Message "System rebooting due to uptime limit reached of $($DiffDays.TotalDays)" -EventName "uptime_trigger EventID: 2074"

#This sends a Broadcast Message to the asset and optionally logs the activity to the asset's Recent Activity section
#Broadcast-Message -Title "Title Text" -Message "Super important message" -LogActivity "true/false"

# Create a Scheduled Task to run once 
# Specify the account to run the script
$User= "NT AUTHORITY\SYSTEM" 
$taskAction = New-ScheduledTaskAction `
    -Execute 'shutdown' `
    -Argument '-r -t 120'
$taskAction

# Describe the scheduled task.
$description = "LTC Automation Scheduled Restart at 12pm once"

$taskTrigger = New-ScheduledTaskTrigger -Once -At 12AM
$tasktrigger

# Register the new PowerShell scheduled task
# The name of your scheduled task.
$taskName = "LTCScheduledRestart"


# Special fix.  Wouldn't overwrite a task of the same name
# So the old copy has to be removed first
if(Get-ScheduledTask $taskName -ErrorAction Ignore) {
    Log-Activity -Message "Removing previous copy of command" -EventName "Task Already Exists"
    Unregister-ScheduledTask -Taskname $taskName -Confirm:$false
    }

# Register the scheduled task
Register-ScheduledTask `
    -User $User `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description









# Confirm the write operation
#Write-Host "Content written to $filePath (overwritten)"



#Add the flag below to suppress and silently continue past any warnings that would normally be displayed.
#-WarningAction SilentlyContinue