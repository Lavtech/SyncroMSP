

# Create a Scheduled Task to run once 
# Specify the account to run the script
$User= "NT AUTHORITY\SYSTEM" 
$taskAction = New-ScheduledTaskAction `
    -Execute 'shutdown' `
    -Argument '-r -t 120'
$taskAction

# Describe the scheduled task.
$description = "LTC Automation Scheduled Restart at 12am once"

$taskTrigger = New-ScheduledTaskTrigger -Once -At 12am
$tasktrigger

# Register the new PowerShell scheduled task
# The name of your scheduled task.
$taskName = "ScheduledRestart"


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

