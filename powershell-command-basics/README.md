# PowerShell Command Basics

Easy PowerShell commands for beginners and IT support work. Each section has the command, what it does, and a simple example.

---

## 1. First steps

| Command | What it does | Example |
|---|---|---|
| `Get-Location` | Show which folder you are in | `Get-Location` |
| `$env:USERNAME` | Show your username | `$env:USERNAME` |
| `whoami` | Show your username | `whoami` |
| `Clear-Host` | Clear the screen | `Clear-Host` |
| `Get-History` | Show commands you already typed | `Get-History` |
| `Get-Date` | Show current date and time | `Get-Date` |

## 2. Getting help

| Command | What it does | Example |
|---|---|---|
| `Get-Help` | Show help for a command | `Get-Help Get-ChildItem` |
| `Get-Help -Examples` | Show real examples for a command | `Get-Help Get-ChildItem -Examples` |
| `Get-Command` | Find a command by name or topic | `Get-Command *Service*` |
| `Get-Member` | Show what a command gives back (its properties and methods) | `Get-ChildItem \| Get-Member` |

Start with `Get-Help -Examples` whenever a command is new to you. The examples are usually the fastest way to learn it.

## 3. Moving around

| Command | What it does | Example |
|---|---|---|
| `Get-ChildItem` | List files in the current folder | `Get-ChildItem` |
| `Set-Location` | Go into a folder | `Set-Location Documents` |
| `Set-Location ..` | Go back one folder | `Set-Location ..` |
| `Set-Location ~` | Go to your home folder | `Set-Location ~` |
| `ls` | Short name (alias) for `Get-ChildItem` | `ls` |
| `dir` | Short name (alias) for `Get-ChildItem` | `dir` |
| `cd` | Short name (alias) for `Set-Location` | `cd Documents` |

## 4. Files and folders

| Command | What it does | Example |
|---|---|---|
| `New-Item -ItemType Directory` | Create a new folder | `New-Item -ItemType Directory -Name backups` |
| `New-Item -ItemType File` | Create a new empty file | `New-Item -ItemType File -Name notes.txt` |
| `Copy-Item` | Copy a file | `Copy-Item notes.txt notes-copy.txt` |
| `Move-Item` | Move a file | `Move-Item notes.txt docs\notes.txt` |
| `Rename-Item` | Rename a file | `Rename-Item notes.txt old-notes.txt` |
| `Remove-Item` | Delete a file or folder (careful, no undo) | `Remove-Item old-file.txt` |

Be careful with `Remove-Item`: deleted files do not go to the Recycle Bin by default, so there is no easy undo. Double-check the name before you press Enter, and use `-WhatIf` first if you are unsure, for example `Remove-Item old-file.txt -WhatIf`.

## 5. Reading files

| Command | What it does | Example |
|---|---|---|
| `Get-Content` | Show the whole file | `Get-Content notes.txt` |
| `Get-Content -Tail 10` | Show only the last 10 lines | `Get-Content notes.txt -Tail 10` |
| `Select-String` | Find a word inside a file | `Select-String -Path notes.txt -Pattern error` |

## 6. The pipeline and objects in simple words

The pipeline character `|` sends the output of one command into the next command, like passing a parcel down a line of people. Each person does one small job and passes it on.

PowerShell works with objects, not just plain text. An object is a thing with properties (details about it, like a file's name and size) that you can pick, sort, and filter.

| Command | What it does | Example |
|---|---|---|
| `\|` | Send output to the next command | `Get-ChildItem \| Select-Object Name` |
| `Where-Object` | Keep only the items that match a condition | `Get-ChildItem \| Where-Object Length -gt 1000` |
| `Select-Object` | Pick only the details you want to see | `Get-ChildItem \| Select-Object Name, Length` |
| `Sort-Object` | Sort the results | `Get-ChildItem \| Sort-Object Length` |
| `ForEach-Object` | Do the same small job for each item | `Get-ChildItem \| ForEach-Object { $_.Name }` |

One small example, putting it together: list files, keep only the big ones, and show just their names, sorted by size:

```powershell
Get-ChildItem | Where-Object Length -gt 1000 | Sort-Object Length | Select-Object Name, Length
```

## 7. System information

| Command | What it does | Example |
|---|---|---|
| `Get-ComputerInfo` | Show computer and Windows details | `Get-ComputerInfo` |
| `Get-PSDrive` | Show drives and how much space is used and free | `Get-PSDrive` |
| `Get-Volume` | Show disk volumes and free space | `Get-Volume` |
| `Get-Uptime` | How long the system has been running | `Get-Uptime` |

To see just a short summary instead of the full `Get-ComputerInfo` output, pick a few details:

```powershell
Get-ComputerInfo | Select-Object CsName, WindowsProductName, WindowsVersion, OsArchitecture
```

## 8. Processes and services

| Command | What it does | Example |
|---|---|---|
| `Get-Process` | List running programs | `Get-Process` |
| `Stop-Process` | Stop a program (use its name or ID number) | `Stop-Process -Name notepad` |
| `Get-Service` | List services and whether they are running | `Get-Service` |
| `Start-Service` | Start a service (needs admin) | `Start-Service -Name Spooler` |
| `Restart-Service` | Restart a service (needs admin) | `Restart-Service -Name Spooler` |

Starting, stopping, and restarting services usually needs an administrator (Run as Administrator) PowerShell window. Be careful with `Stop-Process`: only stop a program you recognise, and never stop a system process you are unsure about.

## 9. Networking

| Command | What it does | Example |
|---|---|---|
| `Test-Connection` | Ping, test if another machine answers | `Test-Connection 8.8.8.8` |
| `Test-Connection -Count 4` | Ping only 4 times, then stop | `Test-Connection -Count 4 google.com` |
| `Test-NetConnection` | Test a connection to a port on another machine | `Test-NetConnection google.com -Port 443` |
| `Get-NetIPAddress` | Show IP addresses of this machine | `Get-NetIPAddress` |
| `Get-NetAdapter` | Show network adapters and their status | `Get-NetAdapter` |
| `Resolve-DnsName` | Look up the IP address for a name | `Resolve-DnsName google.com` |

## 10. Event logs in brief

Event logs record what Windows and its programs have been doing, including errors and warnings. They are a good first place to look when something has gone wrong.

| Command | What it does | Example |
|---|---|---|
| `Get-WinEvent` | Read recent events from a log | `Get-WinEvent -LogName System -MaxEvents 10` |
| `Get-EventLog` | Read events the older way (Windows PowerShell only) | `Get-EventLog -LogName System -Newest 10` |

For IT support work, start small: read the last few events, look for errors, and note the time they happened before digging deeper.

## 11. Running scripts safely

An execution policy is a safety setting that controls which PowerShell scripts are allowed to run on your computer. It stops scripts from running by accident, for example when you double-click a downloaded file.

| Command | What it does | Example |
|---|---|---|
| `Get-ExecutionPolicy` | Show the current execution policy | `Get-ExecutionPolicy` |
| `Set-ExecutionPolicy RemoteSigned` | Common setting: your own scripts run, downloaded scripts must be signed (needs admin) | `Set-ExecutionPolicy RemoteSigned` |

`RemoteSigned` is the common setting for learning and IT support work. Never set a policy to bypass security carelessly, and never run a script you have not read first, especially one downloaded from the internet.

## Quick tips

- Press the Tab key to finish a command, file, or folder name automatically
- `Ctrl + C` stops a running command
- `Clear-Host` (or `cls`) clears the screen
- `.` means the current folder, `..` means the folder above
- Use the up arrow key to repeat your last commands
- When in doubt, run `Get-Help -Examples` for the command first

### Common aliases

An alias is a short name for a longer command. These are handy if you already know Linux or Command Prompt names.

| Alias | Full command | What it does |
|---|---|---|
| `ls` | `Get-ChildItem` | List files in the current folder |
| `cd` | `Set-Location` | Go into a folder |
| `cat` | `Get-Content` | Show the whole file |
| `cp` | `Copy-Item` | Copy a file |
| `mv` | `Move-Item` | Move a file |
| `rm` | `Remove-Item` | Delete a file or folder (careful, no undo) |

See also: `basic-commands.ps1` in this folder, a short practice script with safe, mostly read-only commands you can run line by line.
