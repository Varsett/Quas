param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$InputFile,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$OutputFile
)

$adb = Join-Path $env:myfiles "adb.exe"

if (-not (Test-Path -LiteralPath $adb)) {
#    Write-Host "ERROR: adb.exe not found:"
#    Write-Host $adb
    exit 1
}

if (-not (Test-Path -LiteralPath $InputFile)) {
#    Write-Host "ERROR: Input file not found:"
#    Write-Host $InputFile
    exit 1
}

#Write-Host ""
#Write-Host "Getting package list from device..."

$allPackages = & $adb shell pm list packages -f

if ($LASTEXITCODE -ne 0) {
#    Write-Host "ERROR: Failed to get package list."
    exit 1
}

#Write-Host "Package list received."
#Write-Host ""
#Write-Host "Processing packages..."

$results = foreach ($package in Get-Content -LiteralPath $InputFile) {

    $package = $package.Trim()

    if ([string]::IsNullOrWhiteSpace($package)) {
        continue
    }

    $pattern = "^package:(.+)=$([regex]::Escape($package))$"

    $line = $allPackages |
        Where-Object { $_ -match $pattern } |
        Select-Object -First 1

    if ($line -and $line -match $pattern) {
        "$package;$($Matches[1])"
    }
    else {
        "$package;NOT_FOUND"
    }
}

$results | Set-Content -LiteralPath $OutputFile -Encoding UTF8

#Write-Host ""
#Write-Host "Done."
#Write-Host "Result: $OutputFile"