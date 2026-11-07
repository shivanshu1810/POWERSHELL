# My PowerShell Scripts

Small PowerShell scripts I wrote to practice IT support tasks. Each script does one simple job.

## Scripts

- Get-SystemInfo.ps1 - shows computer name, Windows version, memory and disk info
- Get-TopProcesses.ps1 - shows the programs using the most CPU and memory
- Get-DiskSpaceReport.ps1 - shows if any drive is low on space
- Test-NetworkConnectivity.ps1 - checks step by step why the internet is not working
- Restart-PrintSpooler.ps1 - restarts the print spooler to fix stuck print jobs. Needs admin
- Clear-TempFiles.ps1 - deletes temp files to free up space
- New-LocalUsersFromCsv.ps1 - makes local user accounts from a CSV file. Needs admin
- Get-PasswordAge.ps1 - shows how old user passwords are

## How to run

Open PowerShell in the scripts folder and run the script you want, for example:

    .\scripts\Get-SystemInfo.ps1

If Windows blocks the script, run this first. It only applies to that one window:

    Set-ExecutionPolicy -Scope Process -Bypass

I am still learning PowerShell and I add scripts as I learn new things.
