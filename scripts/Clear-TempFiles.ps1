<#
.SYNOPSIS
    Frees disk space by emptying temp folders. Safe preview with -WhatIf.

.DESCRIPTION
    Deletes files in the user's Temp folder and (as admin) the Windows Temp
    folder, then reports how much space was recovered. Skips files that are
    currently in use instead of erroring out.

.EXAMPLE
    .\Clear-TempFiles.ps1 -WhatIf   # preview only, deletes nothing
    .\Clear-TempFiles.ps1           # actually clean
#>
[CmdletBinding(SupportsShouldProcess)]
param()

function Clear-Folder {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Host "Skipped (not found): $Path" -ForegroundColor Yellow
        return 0
    }
    $before = (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue |
               Measure-Object -Property Length -Sum).Sum

    Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    $after = (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue |
              Measure-Object -Property Length -Sum).Sum
    return ($before - $after)
}

Write-Host "`n=== Temp File Cleanup ===" -ForegroundColor Cyan

$freed = 0
$freed += Clear-Folder $env:TEMP

# Windows Temp needs admin; try it, skip gracefully without
if ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544') {
    $freed += Clear-Folder "$env:SystemRoot\Temp"
}
else {
    Write-Host "Skipped C:\Windows\Temp (run as admin to include it)" -ForegroundColor Yellow
}

Write-Host ("`nRecovered: {0} MB" -f [math]::Round($freed / 1MB, 2)) -ForegroundColor Green
