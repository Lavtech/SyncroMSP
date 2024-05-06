# Define the URLs of the scripts on GitHub
$scriptUrl1 = "https://raw.githubusercontent.com/Lavtech/SyncroMSP-Stuff/debug-test/temp_folder_cleanup.ps1"


# Download the first script content into a variable
$scriptContent1 = Invoke-WebRequest -Uri $scriptUrl1 -UseBasicParsing
# Execute the first script content
Invoke-Expression $scriptContent1.Content

# Download the second script content into a variable
$scriptContent2 = Invoke-WebRequest -Uri $scriptUrl2 -UseBasicParsing
# Execute the second script content
Invoke-Expression $scriptContent2.Content