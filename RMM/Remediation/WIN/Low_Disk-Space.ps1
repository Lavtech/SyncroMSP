#Running Disk Clean up Tool
Write-Verbose " Running Windows disk Clean up Tool" -ForegroundColor Cyan
cleanmgr /AUTOCLEAN | out-Null
Start-Process -FilePath cleanmgr /verylowdisk