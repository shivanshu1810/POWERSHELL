# System Health Report (PowerShell)

A PowerShell script for everyday desktop support work. It collects the health of a Windows computer (CPU, memory, disk space, uptime, top processes) and saves it as an HTML report you can open in a browser or send to a user.

Built as a home lab project after graduation to practise PowerShell and the kind of system checks done in IT support jobs.

## What it does

- CPU usage and processor name
- Memory: total, used, free, and usage %
- Disk space for each drive: total, free, and free %
- System uptime
- Top 5 processes by memory usage
- Saves everything to `SystemHealthReport.html` in the current folder

## How to run it

```powershell
.\Get-SystemHealthReport.ps1
```

Then open `SystemHealthReport.html` in your browser.

## Skills used

PowerShell, WMI/CIM queries, HTML report generation
