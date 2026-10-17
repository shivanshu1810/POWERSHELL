# IT Support PowerShell Toolkit

Small, practical PowerShell scripts for everyday Tier 1 / helpdesk tasks. Each script does **one job**, is commented so you can learn from it, and is safe to run.

## Scripts

| Script | What it does | Needs admin? |
|--------|--------------|--------------|
| `Get-SystemInfo.ps1` | Computer name, OS, CPU, RAM, uptime, disks — first thing you check on any ticket | No |
| `Get-TopProcesses.ps1` | Top 10 processes by CPU and memory — first check for "computer is slow" | No |
| `Get-DiskSpaceReport.ps1` | Flags any drive with low free space (red/green output) | No |
| `Test-NetworkConnectivity.ps1` | Step-by-step "no internet" diagnosis: IP → gateway → internet → DNS | No |
| `Restart-PrintSpooler.ps1` | Clears stuck print jobs by restarting the spooler | **Yes** |
| `Clear-TempFiles.ps1` | Empties temp folders, reports MB recovered (`-WhatIf` to preview) | Partial |
| `New-LocalUsersFromCsv.ps1` | Bulk-creates local accounts from `users.csv` (onboarding practice) | **Yes** |
| `Get-PasswordAge.ps1` | Lists accounts and flags old passwords before they expire | No |

## How to run

```powershell
# Allow local scripts for this session (PowerShell blocks them by default)
Set-ExecutionPolicy -Scope Process -Bypass

# Then run any script, e.g.
.\scripts\Get-SystemInfo.ps1
.\scripts\Clear-TempFiles.ps1 -WhatIf   # preview mode — changes nothing
```

> Scripts marked **Yes** above need an elevated PowerShell: right-click PowerShell → *Run as administrator*.

## Try it: a typical ticket workflow

1. User reports "my computer is slow" → run `Get-SystemInfo.ps1`, then `Get-TopProcesses.ps1`, then `Get-DiskSpaceReport.ps1`
2. Disk is full → run `Clear-TempFiles.ps1` to recover space
3. User reports "can't print" → run `Restart-PrintSpooler.ps1`
4. User reports "no internet" → run `Test-NetworkConnectivity.ps1` — the first failed step tells you where the problem is
5. New hire starts Monday → add them to `users.csv`, run `New-LocalUsersFromCsv.ps1`

## What I learned building this

- `Get-CimInstance` for hardware/OS inventory (the modern replacement for `Get-WmiObject`)
- `-WhatIf` / `SupportsShouldProcess` so destructive scripts can be previewed safely
- `#Requires -RunAsAdministrator` to fail fast instead of halfway through
- CSV-driven bulk operations — the same pattern real onboarding automation uses
- `Sort-Object` plus calculated properties (`@{ Name = ...; Expression = ... }`) to reshape `Get-Process` output into readable tables

## Requirements

- Windows 10/11 with PowerShell 5.1 or later (all of these use built-in cmdlets — nothing to install)
