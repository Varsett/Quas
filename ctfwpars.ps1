# This code was written by GPT Chat.

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
#Set-Content -Path $OutputFile -Value $result -utf8NoBOM
#[System.IO.File]::WriteAllLines($OutputFile, $result, [System.Text.Encoding]::UTF8)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($OutputFile, $result, $utf8NoBom)

