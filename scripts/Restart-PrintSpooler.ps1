<#
.SYNOPSIS
    Restarts the Print Spooler service — the classic fix for stuck print jobs.

.DESCRIPTION
    Stuck print queue is one of the most common Tier 1 tickets. Restarting
    the spooler clears it in seconds. Requires admin rights.

.EXAMPLE
    .\Restart-PrintSpooler.ps1
#>
#Requires -RunAsAdministrator

Write-Host "`n=== Print Spooler Reset ===" -ForegroundColor Cyan

$before = (Get-Service Spooler).Status
Write-Host "Spooler status before: $before"

Restart-Service -Name Spooler -Force
Start-Sleep -Seconds 3

$after = (Get-Service Spooler).Status
if ($after -eq 'Running') {
    Write-Host "Spooler restarted successfully. Ask the user to try printing again." -ForegroundColor Green
}
else {
    Write-Host "Spooler did NOT restart (status: $after). Escalate." -ForegroundColor Red
}
