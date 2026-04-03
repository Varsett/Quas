param (
    [string]$InputFile,
    [string]$OutputFile
)

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

$html = Get-Content -Path $InputFile -Raw
$result = @()

$pattern = 'class=fw-link>(\d{17})</a><td>(\d+\.\d+\.\d+\.\d+)\.\d+.*?/([^/]+):user/'

#$pattern = 'class=fw-link>(\d{17})</a><td>(\d+\.\d+\.\d+\.\d+)\.\d+.*?UP1A\.231005\.007\.A1/([^:]+):user/'

$matches = [regex]::Matches($html, $pattern, 'Singleline')

foreach ($m in $matches) {

    $envId = $m.Groups[1].Value
    $firmware = $m.Groups[2].Value
    $fingerprint = $m.Groups[3].Value

    $result += "$envId $firmware $fingerprint"
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($OutputFile, $result, $utf8NoBom)
