<#
.SYNOPSIS
    Collects basic system health info and saves it as an HTML report.

.DESCRIPTION
    Checks CPU, memory, disk space, uptime, and top processes on a
    Windows computer, then writes SystemHealthReport.html in the
    current folder. Useful for quick desktop support checks.
#>

$reportPath = Join-Path (Get-Location) "SystemHealthReport.html"

# CPU
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$cpuLoad = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

# Memory (values come back in KB, so convert to GB)
$os = Get-CimInstance Win32_OperatingSystem
$totalMemoryGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeMemoryGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedMemoryGB = [math]::Round($totalMemoryGB - $freeMemoryGB, 2)
$memoryUsedPercent = [math]::Round(($usedMemoryGB / $totalMemoryGB) * 100, 1)

# Uptime
$uptime = (Get-Date) - $os.LastBootUpTime
$uptimeText = "{0} days, {1} hours, {2} minutes" -f $uptime.Days, $uptime.Hours, $uptime.Minutes

# Disk space for each local drive
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $freeGB = [math]::Round($_.FreeSpace / 1GB, 2)
    $totalGB = [math]::Round($_.Size / 1GB, 2)
    $freePercent = [math]::Round(($freeGB / $totalGB) * 100, 1)
    [PSCustomObject]@{
        Drive       = $_.DeviceID
        TotalGB     = $totalGB
        FreeGB      = $freeGB
        FreePercent = $freePercent
    }
}

# Top 5 processes by memory usage
$topProcesses = Get-Process | Sort-Object WS -Descending | Select-Object -First 5 Name, Id, @{Name="MemoryMB"; Expression={[math]::Round($_.WS / 1MB, 1)}}

# Build the HTML report
$diskRows = ""
foreach ($disk in $disks) {
    $diskRows += "<tr><td>$($disk.Drive)</td><td>$($disk.TotalGB)</td><td>$($disk.FreeGB)</td><td>$($disk.FreePercent)%</td></tr>"
}

$processRows = ""
foreach ($proc in $topProcesses) {
    $processRows += "<tr><td>$($proc.Name)</td><td>$($proc.Id)</td><td>$($proc.MemoryMB)</td></tr>"
}

$html = @"
<html>
<head><title>System Health Report</title></head>
<body>
<h1>System Health Report</h1>
<p>Computer: $env:COMPUTERNAME</p>
<p>Date: $(Get-Date -Format "yyyy-MM-dd HH:mm")</p>

<h2>CPU</h2>
<p>Processor: $($cpu.Name)</p>
<p>Current load: $([math]::Round($cpuLoad, 1))%</p>

<h2>Memory</h2>
<p>Total: $totalMemoryGB GB | Used: $usedMemoryGB GB | Free: $freeMemoryGB GB ($memoryUsedPercent% used)</p>

<h2>Uptime</h2>
<p>$uptimeText</p>

<h2>Disk Space</h2>
<table border="1" cellpadding="5">
<tr><th>Drive</th><th>Total (GB)</th><th>Free (GB)</th><th>Free %</th></tr>
$diskRows
</table>

<h2>Top 5 Processes by Memory</h2>
<table border="1" cellpadding="5">
<tr><th>Name</th><th>Process ID</th><th>Memory (MB)</th></tr>
$processRows
</table>
</body>
</html>
"@

$html | Out-File -FilePath $reportPath -Encoding utf8
Write-Output "Report saved to $reportPath"
