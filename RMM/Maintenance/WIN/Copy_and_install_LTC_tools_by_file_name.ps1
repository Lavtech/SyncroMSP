

$filelocation = "c:\programdata\ltc\dontdelete\"
$sourceURL = "https://lavtechcomputers.com/files/onboarding/"
$filename = "$FileName"
### For $filelocation include full path. Example: C:\temp\
### For $filename include file name and extension. Example: syncro.exe

#Creating file path if it doesn't already exist
if(!(Test-Path -Path $filelocation )){
    New-Item -ItemType directory -Path $filelocation
}
else
{
    New-Item -ItemType Directory -Path "c:\programdata\ltc\dontdelete"

}

#Getting start time 
$start_time = Get-Date

#Downloading the file
Start-BitsTransfer -Source $sourceURL$filename -Destination $filelocation$filename

#Confirmation Message
Write-Output "It took $((Get-Date).Subtract($start_time).Seconds) seconds to download $filename to $filelocation from this URL: $sourceURL"





#use this to bypass windows script policy restrictions and install a program
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))