param (
    [string]$DataFile,
    [string]$VectorMessage
)

$values = Get-Content $DataFile | ForEach-Object { $_ -as [double] }


if ($values.Count -lt 2) {
Write-Host "Error: Insufficient data for trend analysis."

    exit 1
}

$n = $values.Count
$sumX = 0
$sumY = 0
$sumXY = 0
$sumX2 = 0

for ($i = 0; $i -lt $n; $i++) {
    $sumX += $i
    $sumY += $values[$i]
    $sumXY += $i * $values[$i]
    $sumX2 += $i * $i
}

$denominator = ($n * $sumX2 - $sumX * $sumX)
if ($denominator -eq 0) {
Write-Host "Error: Unable to determine trend."

    exit 1
}
$b = ($n * $sumXY - $sumX * $sumY) / $denominator
$b = [math]::Round($b, 5)
$b = "{0:N5}" -f $b
if ($b -eq 0.0) {
    $result = "Стабильно"
} elseif ($b -gt 0) {
$result = "Growth ($b units per step)";

} else {
$result = "Decline ($b units per step)";

}

Write-Host " "
Write-Host " "
Write-Host "    +++ $VectorMessage +++"
Write-Host " "
Write-Host "    ========================================================="
Write-Host " "
Write-Host "     Result: 	$result"
Write-Host " "
Write-Host "    ========================================================="
Write-Host " "
Write-Host "           Press key for close the window "
Write-Host " "
Write-Host " "
Read-Host | Out-Null
