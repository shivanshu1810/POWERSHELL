<#
.SYNOPSIS
    Reset-NetworkStack.ps1 - First-response fix for "no internet" tickets.

.DESCRIPTION
    Runs the standard Tier 1 network reset sequence on a Windows PC and
    logs every step before and after:

      1. Shows the current IP configuration
      2. Releases and renews the DHCP lease  (ipconfig /release, /renew)
      3. Flushes the DNS resolver cache      (ipconfig /flushdns)
      4. Resets the Winsock catalog          (netsh winsock reset)
      5. Resets the TCP/IP stack             (netsh int ip reset)
      6. Shows the new IP configuration

    Steps 4 and 5 need a reboot before they fully take effect, so the
    script ends by offering to restart the computer (default: No).

    Must be run as Administrator. If it is not elevated, the script says
    so and stops before changing anything.

.PARAMETER LogPath
    Optional folder for the transcript log. Default: the current user's
    Desktop. The log is named "NetworkReset-<ComputerName>-<yyyyMMdd-HHmm>.log".

.EXAMPLE
    .\Reset-NetworkStack.ps1
    Runs the reset and saves the log on the Desktop.

.NOTES
    Author : Shivanshu Sharma
    Purpose: Portfolio / service desk troubleshooting helper
#>

[CmdletBinding()]
param(
    [string]$LogPath = [Environment]::GetFolderPath('Desktop')
)

# --- Admin check ---------------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning 'This script must be run as Administrator. Right-click PowerShell and choose "Run as administrator", then run it again.'
    return
}

# --- Start logging ---------------------------------------------------------
if (-not (Test-Path $LogPath)) { New-Item -ItemType Directory -Path $LogPath | Out-Null }
$logFile = Join-Path $LogPath ('NetworkReset-{0}-{1}.log' -f $env:COMPUTERNAME, (Get-Date -Format 'yyyyMMdd-HHmm'))
Start-Transcript -Path $logFile -Append | Out-Null

try {
    Write-Host ''
    Write-Host '=== Network stack reset - ' -NoNewline
    Write-Host (Get-Date -Format 'yyyy-MM-dd HH:mm') '==='

    Write-Host ''
    Write-Host '--- IP configuration BEFORE ---'
    Get-NetIPConfiguration | Where-Object { $_.IPv4Address } | ForEach-Object {
        Write-Host (" {0}: {1}  (Gateway: {2}, DNS: {3})" -f $_.InterfaceAlias,
            ($_.IPv4Address.IPAddress -join ', '),
            ($_.IPv4DefaultGateway.NextHop -join ', '),
            ($_.DNSServer.ServerAddresses -join ', '))
    }

    Write-Host ''
    Write-Host '--- Releasing and renewing DHCP lease ---'
    ipconfig /release  | Out-Host
    ipconfig /renew    | Out-Host

    Write-Host ''
    Write-Host '--- Flushing DNS cache ---'
    ipconfig /flushdns | Out-Host

    Write-Host ''
    Write-Host '--- Resetting Winsock catalog ---'
    netsh winsock reset | Out-Host

    Write-Host ''
    Write-Host '--- Resetting TCP/IP stack ---'
    netsh int ip reset  | Out-Host

    Write-Host ''
    Write-Host '--- IP configuration AFTER ---'
    Get-NetIPConfiguration | Where-Object { $_.IPv4Address } | ForEach-Object {
        Write-Host (" {0}: {1}  (Gateway: {2}, DNS: {3})" -f $_.InterfaceAlias,
            ($_.IPv4Address.IPAddress -join ', '),
            ($_.IPv4DefaultGateway.NextHop -join ', '),
            ($_.DNSServer.ServerAddresses -join ', '))
    }

    Write-Host ''
    Write-Host 'Quick check - pinging the default gateway and 1.1.1.1:'
    $gw = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4DefaultGateway.NextHop
    if ($gw) { Test-Connection -ComputerName $gw -Count 2 -Quiet | ForEach-Object { Write-Host ("  Gateway {0} reachable: {1}" -f $gw, $_) } }
    Test-Connection -ComputerName '1.1.1.1' -Count 2 -Quiet | ForEach-Object { Write-Host ("  1.1.1.1 reachable: {0}" -f $_) }

    Write-Host ''
    Write-Host 'Done. The Winsock and TCP/IP resets need a REBOOT to finish.'
    $answer = Read-Host 'Restart the computer now? (y/N)'
    if ($answer -match '^(y|yes)$') {
        Write-Host 'Restarting in 10 seconds...'
        Restart-Computer -Force -Delay 10
    } else {
        Write-Host 'No restart. Please reboot the PC before testing the connection again.'
    }
}
finally {
    Stop-Transcript | Out-Null
    Write-Host "Log saved to: $logFile"
}
