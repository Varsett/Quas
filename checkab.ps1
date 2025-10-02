param(
    [string]$FilePath,
    [int]$CheckInterval = 200,   # проверка каждые 200 ms
    [int]$StableCount = 3        # сколько раз подряд размер не должен изменяться
)

if (-not (Test-Path $FilePath)) {
    Write-Output -1
    exit 1
}

$lastSize = (Get-Item $FilePath).Length
$stable = 0

while ($true) {
    Start-Sleep -Milliseconds $CheckInterval
    $currentSize = (Get-Item $FilePath).Length

    if ($currentSize -eq $lastSize) {
        $stable++
    } else {
        $stable = 0
    }

    if ($stable -ge $StableCount) {
        break
    }

    $lastSize = $currentSize
}

Write-Output $currentSize
