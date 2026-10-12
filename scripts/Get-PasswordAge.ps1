<#
.SYNOPSIS
    Lists local users and flags passwords that are getting old.

.DESCRIPTION
    "I got locked out / my password expired" is a daily service desk ticket.
    This shows every local account, when its password was last set, and flags
    anything older than the threshold so you can warn users proactively.

.PARAMETER OlderThanDays
    Flag passwords older than this many days. Default: 60.

.EXAMPLE
    .\Get-PasswordAge.ps1
#>
param(
    [int]$OlderThanDays = 60
)

Write-Host "`n=== Local Account Password Age ===" -ForegroundColor Cyan

Get-LocalUser | Where-Object { $_.Enabled } | ForEach-Object {
    $age = if ($_.PasswordLastSet) { [int]((Get-Date) - $_.PasswordLastSet).TotalDays } else { 'never set' }

    $line = "{0,-20} last changed: {1,-12} age: {2} days" -f $_.Name, $_.PasswordLastSet, $age

    if ($age -is [int] -and $age -gt $OlderThanDays) {
        Write-Host "$line  [OLD - remind user]" -ForegroundColor Red
    }
    else {
        Write-Host $line -ForegroundColor Green
    }
}
