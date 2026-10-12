<#
.SYNOPSIS
    Creates local user accounts in bulk from a CSV file — like onboarding new hires.

.DESCRIPTION
    Reads users.csv (Username, FullName, Group) and creates each account with
    a random temporary password the user must change at first logon.
    Requires admin rights. Great practice for the onboarding tickets you'll
    handle on a service desk.

.EXAMPLE
    .\New-LocalUsersFromCsv.ps1
    .\New-LocalUsersFromCsv.ps1 -CsvPath .\my-new-hires.csv
#>
#Requires -RunAsAdministrator
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot 'users.csv')
)

if (-not (Test-Path $CsvPath)) { throw "CSV not found: $CsvPath" }

Import-Csv $CsvPath | ForEach-Object {
    $username = $_.Username.Trim()

    if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        Write-Host "Skipped (already exists): $username" -ForegroundColor Yellow
        return
    }

    # Random 12-char temp password, must be changed at first logon
    $tempPassword = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 12 | ForEach-Object { [char]$_ })
    $securePw = ConvertTo-SecureString "$tempPassword!" -AsPlainText -Force

    New-LocalUser -Name $username -FullName $_.FullName -Password $securePw `
        -PasswordNeverExpires:$false -AccountNeverExpires | Out-Null

    if ($_.Group) {
        Add-LocalGroupMember -Group $_.Group -Member $username -ErrorAction SilentlyContinue
    }

    Write-Host "Created: $username ($($_.FullName))  temp password: $tempPassword!  -> must change at logon" -ForegroundColor Green
}

Write-Host "`nDone. Hand the temp passwords to the users securely (not by email)." -ForegroundColor Cyan
