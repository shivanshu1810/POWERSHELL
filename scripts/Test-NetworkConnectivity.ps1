<#
.SYNOPSIS
    Quick network health check for troubleshooting "no internet" tickets.

.DESCRIPTION
    Tests, in order: local IP config, default gateway, DNS resolution,
    and internet connectivity. The first step that fails tells you
    where the problem is.

.EXAMPLE
    .\Test-NetworkConnectivity.ps1
#>

function Test-Step {
    param([string]$Name, [scriptblock]$Test)
    try {
        $result = & $Test
        if ($result) { Write-Host "[PASS] $Name" -ForegroundColor Green }
        else         { Write-Host "[FAIL] $Name" -ForegroundColor Red }
        return $result
    }
    catch {
        Write-Host "[FAIL] $Name ($($_.Exception.Message))" -ForegroundColor Red
        return $false
    }
}

Write-Host "`n=== Network Connectivity Check ===" -ForegroundColor Cyan

# 1. Do we have an IP address?
$ip = Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred |
      Where-Object { $_.IPAddress -notlike '169.254*' -and $_.PrefixOrigin -ne 'WellKnown' } |
      Select-Object -First 1
Test-Step "Has valid IP address ($($ip.IPAddress))" { $null -ne $ip }

# 2. Can we reach the default gateway? (local network OK?)
$gateway = (Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Select-Object -First 1).NextHop
Test-Step "Gateway reachable ($gateway)" { Test-Connection $gateway -Count 2 -Quiet }

# 3. Can we reach a public DNS server? (internet routing OK?)
Test-Step "Internet reachable (8.8.8.8)" { Test-Connection 8.8.8.8 -Count 2 -Quiet }

# 4. Does DNS resolution work? (name -> IP)
Test-Step "DNS resolves google.com" {
    $null -ne (Resolve-DnsName google.com -ErrorAction Stop)
}

Write-Host "`nTip: if step 2 fails, it's the local network. If 3 fails but 2 passes, it's the router/ISP. If 4 fails but 3 passes, it's a DNS problem." -ForegroundColor Yellow
