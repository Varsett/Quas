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

# Ищем пары: EnvironmentVersion (17 цифр) + FirmwareVersion
$pattern = 'class=fw-link>(\d{17})</a><td>(\d+(?:\.\d+){3,})'
$matches = [regex]::Matches($html, $pattern)

foreach ($m in $matches) {
    $envId = $m.Groups[1].Value
    $firmFull = $m.Groups[2].Value

    # Обрезаем FirmwareVersion до X.Y.Z.W
    if ($firmFull -match '^(\d+\.\d+\.\d+\.\d+)') {
        $firmShort = $matches[1]
    } else {
        $firmShort = $firmFull
    }

    $result += "$envId $firmShort"
}

# Сохраняем в UTF-8 без BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($OutputFile, $result, $utf8NoBom)
