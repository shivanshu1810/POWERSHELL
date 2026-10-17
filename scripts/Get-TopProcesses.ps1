<#
.SYNOPSIS
    Shows the top 10 processes by CPU time and by memory use.

.DESCRIPTION
    First check when a user reports "my computer is slow": a single
    runaway process is often the cause. Read-only - it changes
    nothing on the machine, so it needs no admin rights.

.EXAMPLE
    .\scripts\Get-TopProcesses.ps1
#>

Write-Host "Top 10 processes by CPU time (seconds):" -ForegroundColor Cyan
Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 10 Name, Id, CPU |
    Format-Table -AutoSize

Write-Host "Top 10 processes by memory use (MB):" -ForegroundColor Cyan
Get-Process |
    Sort-Object WorkingSet -Descending |
    Select-Object -First 10 Name, Id, @{ Name = "MemoryMB"; Expression = { [math]::Round($_.WorkingSet / 1MB, 1) } } |
    Format-Table -AutoSize
