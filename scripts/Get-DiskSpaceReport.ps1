<#
.SYNOPSIS
    Checks free disk space and flags any drive running low.

.DESCRIPTION
    Loops through all fixed drives and warns (in red) when free space
    drops below the threshold. Run this before users call about a
    "slow computer" — full disks are a classic cause.

.PARAMETER WarnBelowPercent
    Warn when free space is below this percentage. Default: 20.

.EXAMPLE
    .\Get-DiskSpaceReport.ps1
    .\Get-DiskSpaceReport.ps1 -WarnBelowPercent 10
#>
param(
    [int]$WarnBelowPercent = 20
)

$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

Write-Host "`n=== Disk Space Report ===" -ForegroundColor Cyan
foreach ($d in $disks) {
    $freeGB  = [math]::Round($d.FreeSpace / 1GB, 2)
    $freePct = [math]::Round($d.FreeSpace / $d.Size * 100, 1)

    if ($freePct -lt $WarnBelowPercent) {
        Write-Host ("{0}  {1} GB free ({2}%)  [LOW - needs cleanup]" -f $d.DeviceID, $freeGB, $freePct) -ForegroundColor Red
    }
    else {
        Write-Host ("{0}  {1} GB free ({2}%)  [OK]" -f $d.DeviceID, $freeGB, $freePct) -ForegroundColor Green
    }
}
