<#
.SYNOPSIS
    Shows key system info at a glance — the first thing you check on any support ticket.

.DESCRIPTION
    Reports computer name, OS, CPU, RAM, uptime, and disk usage in one screen.
    No admin rights needed.

.EXAMPLE
    .\Get-SystemInfo.ps1
#>

$os   = Get-CimInstance Win32_OperatingSystem
$cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

Write-Host "`n=== System Information ===" -ForegroundColor Cyan
[PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    OS           = $os.Caption
    Version      = $os.Version
    CPU          = $cpu.Name.Trim()
    RAM_GB       = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    Uptime_Days  = [math]::Round(((Get-Date) - $os.LastBootUpTime).TotalDays, 1)
    LoggedOnUser = $env:USERNAME
} | Format-List

Write-Host "=== Disks ===" -ForegroundColor Cyan
$disk | Select-Object DeviceID,
    @{N='Size_GB'; E={[math]::Round($_.Size / 1GB, 2)}},
    @{N='Free_GB'; E={[math]::Round($_.FreeSpace / 1GB, 2)}},
    @{N='Free_%';  E={[math]::Round($_.FreeSpace / $_.Size * 100, 1)}} |
    Format-Table -AutoSize
