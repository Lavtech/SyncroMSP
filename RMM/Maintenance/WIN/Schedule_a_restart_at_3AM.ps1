# Create a Scheduled Task to run once 
# Specify the account to run the script
$User= "NT AUTHORITY\SYSTEM" 
# Define the action to take (restart the computer)
$taskAction = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/r /t 120'


# Describe the scheduled task.
$description = "Scheduled Restart at 3am once"

# Define the trigger for the task (Run once at 3:00 AM)
$taskTrigger = New-ScheduledTaskTrigger -At 3AM -Once

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
Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -User $User -Description $description -RunLevel Highest -Force