param (
    [string]$InputFile,
    [string]$OutputFile
)

$htmlContent = Get-Content -Path $InputFile -Raw
$rowMatches = [regex]::Matches($htmlContent, '<tr>(.*?)</tr>', 'IgnoreCase')

$result = @()

foreach ($row in $rowMatches) {
    $columnMatches = [regex]::Matches($row.Value, '<td.*?>(.*?)</td>', 'IgnoreCase')

    if ($columnMatches.Count -lt 2) {
        continue
    }

    $EnvironmentVersion = $columnMatches[0].Groups[1].Value -replace '<[^>]*>', ''
    $FirmwareVersionFull = $columnMatches[1].Groups[1].Value -replace '<[^>]*>', ''

    # Обрезаем FirmwareVersion до первых четырёх чисел (например, 77.0.0.450)
    if ($FirmwareVersionFull -match '^(\d+\.\d+\.\d+\.\d+)') {
        $FirmwareVersion = $matches[1]
    } else {
        $FirmwareVersion = $FirmwareVersionFull
    }

    $result += "$EnvironmentVersion $FirmwareVersion"
}

# Сохраняем в файл
Set-Content -Path $OutputFile -Value $result -Encoding UTF8
