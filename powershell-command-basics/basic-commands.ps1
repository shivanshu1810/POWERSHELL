# PowerShell command basics - safe practice commands
# Every command here is read-only, or works only in a practice folder
# that is cleaned up at the end.
# Run it line by line while you learn, or run the whole file:
#   .\basic-commands.ps1

# Where am I, who am I, and what time is it?
Get-Location
$env:USERNAME
Get-Date

# What is in this folder?
Get-ChildItem

# Make a practice folder and a file in the current directory
New-Item -ItemType Directory -Name practice
Set-Location practice
New-Item -ItemType File -Name notes.txt
"Hello from PowerShell" | Out-File notes.txt

# Look inside the file
Get-Content notes.txt

# Search for a word in the file
Select-String -Path notes.txt -Pattern Hello

# System information - just a short summary, not the full output
Get-ComputerInfo | Select-Object CsName, WindowsProductName, WindowsVersion, OsArchitecture
Get-PSDrive

# Networking basics - ping 4 times, then stop
Test-Connection -Count 4 8.8.8.8

# Go back and clean up the practice folder
Set-Location ..
Remove-Item practice -Recurse
Write-Output "Practice done"
