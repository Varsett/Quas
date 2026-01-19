<#
.SYNOPSIS
    Universal memory utility for Android via adb.
Created by Varset&ChatGPT


    Supports three modes:
      -MemMon    : Continuous memory monitoring with CSV output and optional console display.
      -MemInfo   : Top-N memory-consuming processes.
      -MemUsage  : Quick summary of Total, Free, and Used RAM.


.PARAMETER MemUsage
    Показывает текущее использование памяти (Total, Free, Used).

.PARAMETER MemInfo
    Отображает список приложений и занимаемую ими память.
    Поддерживает параметры -Top, -Sys, -Usr.

.PARAMETER MemMon
    Запускает мониторинг памяти с интервалом.
    Параметры: -CsvFile, -Interval, -Count, -Console, -Top.

.NOTES
    adb берётся из переменной окружения %myfiles%.
    В BAT файле это должно выглядеть так:
        set myfiles=D:\Quest\_Cmd
        powershell -ExecutionPolicy Bypass -File memuni.ps1 -MemInfo

.PARAMETER MemMon
    Switch to run live memory monitoring mode.

.PARAMETER MemInfo
    Switch to show top-N memory-consuming processes.

.PARAMETER MemUsage
    Switch to output Total, Free, and Used RAM in one line.

.PARAMETER CsvFile
    Path to CSV file for -MemMon mode (default "mem_monitor.csv").

.PARAMETER Interval
    Interval between snapshots in seconds (default 5, -MemMon only).

.PARAMETER Count
    Number of snapshots (default 0 = infinite, -MemMon only).

.PARAMETER Console
    Switch to display snapshot in console (-MemMon only).

.PARAMETER Top
    Number of top processes to show (MemMon and MemInfo modes).

.PARAMETER Sys
    Show only system apps (MemInfo only).

.PARAMETER Usr
    Show only user apps (MemInfo only).

#>

param(
    [switch]$MemMon,
    [switch]$MemInfo,
    [switch]$MemUsage,
    [string]$CsvFile = "mem_monitor.csv",
    [int]$Interval = 5,
    [int]$Count = 0,
    [switch]$Console,
    [int]$Top = 10,
    [switch]$Sys,
    [switch]$Usr
)

# --- Validation ---
if ($Sys -and $Usr) { Write-Error "Cannot use -Sys and -Usr together"; exit 1 }
if ($Interval -lt 1 -or $Interval -gt 1800) { Write-Error "Interval must be 1-1800 seconds"; exit 1 }

# --- adb path ---
if (-not $env:myfiles) {
    Write-Error "Environment variable 'myfiles' is not set."
    exit 1
}
$adb = Join-Path $env:myfiles "adb.exe"

# --- Helper function for ESC break ---
function Wait-WithEsc($seconds) {
    $end = (Get-Date).AddSeconds($seconds)
    while ((Get-Date) -lt $end) {
        Start-Sleep -Milliseconds 200
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "Escape") {
                Write-Host "`nEsc pressed, exiting..."
                return $false
            }
        }
    }
    return $true
}

# --- Load package paths cache ---
$pkgPaths = @{}
$allPackages = & $adb shell pm list packages -f | ForEach-Object { ($_ -replace 'package:', '').Trim() }
foreach ($line in $allPackages) {
    if ($line -match '^(.*)=([^\s]+)$') {
        $path = $matches[1]; $pkg = $matches[2]
        if ($path -like "/system/*") { $pkgPaths[$pkg] = "[SYS]" }
        elseif ($path -like "/data/*") { $pkgPaths[$pkg] = "[USR]" }
        else { $pkgPaths[$pkg] = "[SYS]" }
    }
}

# ------------------------------
# --- MemUsage Mode -------------
# ------------------------------
if ($MemUsage) {
    $meminfoLines = & $adb shell dumpsys meminfo

    function Parse-Ram($pattern) {
        $line = $meminfoLines | Select-String $pattern | Select-Object -First 1
        if ($line -match '([\d,]+)\s*[Kk]\b') {
            $kb = ($matches[1] -replace ',', '') -as [double]
            return [math]::Round($kb / 1000000.0, 3).ToString([System.Globalization.CultureInfo]::InvariantCulture)
        }
        return 0
    }

    $Total = Parse-Ram 'Total RAM'
    $Free  = Parse-Ram 'Free RAM'
    $Used  = Parse-Ram 'Used RAM'
    Write-Output "$Total,$Free,$Used"
    return
}

# ------------------------------
# --- MemInfo Mode --------------
# ------------------------------
if ($MemInfo) {
    $lines = & $adb shell dumpsys meminfo
    $start = $false
    $results = @()

    foreach ($line in $lines) {
        if ($line -match 'Total RSS by process:') { $start = $true; continue }
        if ($start) {
            if ($line -match '^\s*([\d,]+)K:\s+([^\s]+)') {
                $memKB = ($matches[1] -replace ',', '') -as [double]
                $pkg   = $matches[2]
                $memMB = [math]::Round($memKB / 1000, 2)
                $tagValue = if ($pkgPaths.ContainsKey($pkg)) { $pkgPaths[$pkg] } else { "[SYS]" }

                $results += [PSCustomObject]@{
                    Package = $pkg
                    MemMB   = $memMB
                    Tag     = $tagValue
                }
            } elseif ($line -eq '') { break }
        }
    }

    # Фильтр сначала
    if ($Sys) { $results = $results | Where-Object { $_.Tag -eq "[SYS]" } }
    elseif ($Usr) { $results = $results | Where-Object { $_.Tag -eq "[USR]" } }

    # Сортировка и топ-N после фильтра
    $results = $results | Sort-Object MemMB -Descending
    if ($Top -gt 0) { $results = $results | Select-Object -First $Top }

    foreach ($r in $results) {
        $pkgPadded = $r.Package.PadRight(50)
        $memStr = "{0:N2} MB" -f $r.MemMB
        Write-Output "$pkgPadded$memStr $($r.Tag)"
    }
    return
}

# ------------------------------
# --- MemMon Mode --------------
# ------------------------------
if ($MemMon) {

    # --- Load existing CSV ---
    $csvData = @{}
    $header = @("Package","Tag")
    if (Test-Path $CsvFile) {
        $existing = Import-Csv $CsvFile
        foreach ($row in $existing) {
            $pkg = $row.Package
            $memValues = @()
            foreach ($prop in $row.PSObject.Properties.Name) {
                if ($prop -match '^Time') { $memValues += $row.$prop }
            }
            $csvData[$pkg] = @{ Tag = $row.Tag; Mem = $memValues }
        }
        $header += ($existing[0].PSObject.Properties.Name | Where-Object { $_ -match '^Time' })
    }

    $snapIndex = if ($header.Count -le 2) { 1 } else { $header.Count -1 }
    $counted = 0

    while ($Count -eq 0 -or $counted -lt $Count) {
        $snapTime = Get-Date -Format "HH:mm:ss"

        $lines = & $adb shell dumpsys meminfo
        $start = $false
        $results = @{}

        foreach ($line in $lines) {
            if ($line -match 'Total RSS by process:') { $start = $true; continue }
            if ($start) {
                if ($line -match '^\s*([\d,]+)K:\s+([^\s]+)') {
                    $memKB = ($matches[1] -replace ',', '') -as [double]
                    $pkg   = $matches[2]
                    $memMB = [math]::Round($memKB / 1000, 2)
                    $tagValue = if ($pkgPaths.ContainsKey($pkg)) { $pkgPaths[$pkg] } else { "[SYS]" }
                    $results[$pkg] = @{ Mem = $memMB; Tag = $tagValue }
                } elseif ($line -eq '') { break }
            }
        }

        if ($Console) {
            Clear-Host
            Write-Host "Snapshot ${snapTime}: (Press Esc to exit)`n"
            $sortedResults = $results.GetEnumerator() | Sort-Object { $_.Value.Mem } -Descending
            if ($Top -gt 0) { $sortedResults = $sortedResults | Select-Object -First $Top }

            foreach ($item in $sortedResults) {
                $pkg = $item.Key
                $mem = $item.Value.Mem
                $tag = $item.Value.Tag
                Write-Host ("{0,-50} {1,7} MB {2}" -f $pkg, $mem, $tag)
            }
        }

        # --- Update csvData ---
        foreach ($pkg in $results.Keys) {
            if ($csvData.ContainsKey($pkg)) { $csvData[$pkg].Mem += $results[$pkg].Mem }
            else {
                $arr = @(); for ($i=1; $i -lt $snapIndex; $i++) { $arr += "" }
                $csvData[$pkg] = @{ Tag = $results[$pkg].Tag; Mem = $arr + @($results[$pkg].Mem) }
            }
        }

        # --- Update header ---
        $header += "Time$snapIndex"; $snapIndex++

        # --- Prepare CSV ---
        $csvOutput = @()
        foreach ($pkg in $csvData.Keys) {
            $tag = $csvData[$pkg].Tag
            $memValues = $csvData[$pkg].Mem
            $obj = [PSCustomObject]@{ Package = $pkg; Tag = $tag }
            for ($i=0; $i -lt $memValues.Count; $i++) { $obj | Add-Member -NotePropertyName "Time$($i+1)" -NotePropertyValue $memValues[$i] }
            $csvOutput += $obj
        }

        $csvOutput | Export-Csv -Path $CsvFile -NoTypeInformation -Encoding UTF8
        $counted++
        if (-not (Wait-WithEsc $Interval)) { break }
    }
}
