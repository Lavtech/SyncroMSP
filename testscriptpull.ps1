# Define the path to the desktop and the filename
$desktopPath = [Environment]::GetFolderPath("Desktop")
$fileName = "this_script_worked.txt"
$fullPath = Join-Path -Path $desktopPath -ChildPath $fileName

# Check if the file already exists
if (-Not (Test-Path -Path $fullPath)) {
    # Create the file
    New-Item -Path $fullPath -ItemType File -Force
    "The file was created successfully." | Out-File -FilePath $fullPath
} else {
    Write-Host "The file already exists."
}
