
# Set the file path
$path = "C:\ProgramData\LTC\AgentData"
$filePath = "C:\ProgramData\LTC\AgentData\rebootevent.txt"
$ticketfilePath = "C:\ProgramData\LTC\AgentData\ticketid.txt"

$lastModified = (Get-Item $filePath).LastWriteTime

#This gets the uptime from windows
$LastRebootTime = Get-WmiObject win32_operatingsystem | 
select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}


$Today = Get-Date
$Uptime = $Today - $LastRebootTime.LastBootUpTime
$DiffHours = $Today.hour - $LastRebootTime.LastBootUpTime.hour

# Read the content of the file
$ticketID = Get-Content -Path $ticketfilePath
# Trim any leading or trailing whitespace
$ticketID = $ticketID.Trim()

if (-not (Test-Path -Path $path)){
    New-Item -ItemType Directory -Path $path
}

if ($DiffHours -le 8) {
    # If the computer has rebooted within the last 8 hours, log a success message
    Write-Host "Computer has rebooted successfully."
    $formattedLastRebootTime = $LastRebootTime.LastBootUpTime.ToString("MM/dd/yyyy h:mm:ss tt")
    Write-Host "Last Reboot Time: $formattedLastRebootTime"
    
    # This logs an activity feed item on an Asset's Activity feed
    Log-Activity -Message "System rebooted from Lavtech Managed Services. Last Reboot Time: $formattedLastRebootTime" -EventName "uptime_trigger EventID: 2074"

    # This closes an RMM alert in Syncro, there can only be one of each alert category per asset, so it will find the correct one.
    # If no alert exists, it will exit gracefully. You can also choose to close a ticket generated from the alert
    Close-Rmm-Alert -Category "uptime_trigger" -CloseAlertTicket "true"

    # This will add a comment to the ticket created in this above script. It will also assign the ticket to the userID: 149848 "John". Also, you can have it be "public" or "private", and email or not, and combine those.
    # To find userID, log in to Syncro and navigate to 
    # For example, you can make a Public comment (shows on PDF/etc) and have it NOT email the customer.
    Create-Syncro-Ticket-Comment -TicketIdOrNumber $ticketID -Subject "Complete" -Body "System rebooted from Lavtech remediation and is nice and fresh. Last Reboot Time: $formattedLastRebootTime" -Hidden "false" -DoNotEmail "true" -UserIdOrEmail "149848"
    
    # Simply update a ticket, only currently supports status and custom fields.
    #Update-Syncro-Ticket -TicketIdOrNumber $ticketID -Status "Resolved" -CustomFieldName "" -CustomFieldValue ""
    Update-Syncro-Ticket -TicketIdOrNumber $ticketID -Status "Resolved" -DoNotEmail "true" -UserIdOrEmail "149848"
    
    
    
} else {
    # If the computer has not rebooted within the last 8 hours, create an error message
    Write-Host "ERROR: Computer has not rebooted, please restart manually."

    # This will add a comment to the ticket created in this above script. It will also assign the ticket to the userID: 149848 "John". Also, you can have it be "public" or "private", and email or not, and combine those.
    # To find userID, log in to Syncro and navigate to 
    # For example, you can make a Public comment (shows on PDF/etc) and have it NOT email the customer.
    Create-Syncro-Ticket-Comment -TicketIdOrNumber $ticketID -Subject "Update" -Body "System has not rebooted from Lavtech remediation and needs to be manually restarted. Broadcasteda message to teh device: Your computer needs to be restarted to complete the maintenance provided by Lavtech computers managed services. To notify the client to do a restart" -Hidden "false" -DoNotEmail "true" -UserIdOrEmail "149848"

    # This displays a popup alert on the desktop.
    # Display-Alert -Message "Your computer needs to be restarted to complete the maintenance provided by Lavtech computers managed services."

    # This sends a Broadcast Message to the asset and optionally logs the activity to the asset's Recent Activity section
    Broadcast-Message -Title "Message from Lavtech Computers" -Message "Your computer needs to be restarted to complete the maintenance provided by Lavtech computers managed services." -LogActivity "false"
}

#     Need to delete the ticketid.txt

Remove-Item -Path $ticketfilePath -Force

#Add the flag below to suppress and silently continue past any warnings that would normally be displayed.
-WarningAction SilentlyContinue