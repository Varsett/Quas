# This code was written by GPT Chat.

param (
    [string]$DataFile,
    [string]$VectorMessage,
    [string]$ExternalFile
)

$numbers = Get-Content $DataFile | ForEach-Object {[double]$_}

[System.Console]::SetWindowSize(120, 50)

$minValue = ($numbers | Measure-Object -Minimum).Minimum
$maxValue = ($numbers | Measure-Object -Maximum).Maximum

$maxBarLength = 100
$scaleFactor = $maxBarLength / $maxValue

$lineCount = $numbers.Count

$outputFile = $ExternalFile

if ($lineCount -gt 2000) {
    $outputContent = ""

    foreach ($num in $numbers) {
        $barLength = [math]::Round($num * $scaleFactor)
        $bar = '|' * $barLength
        $outputContent += "{0,5} | {1}" -f $num, $bar + "`n"
    }
    $outputContent | Out-File -FilePath $outputFile -Encoding utf8
    Write-Host " "
    Write-Host " "
    Write-Host " ------------------------------------------------------------------------------------------------------"
    Write-Host "    +++ The histogram has more 2000 lines and saved to file: $outputFile "
    Write-Host " ------------------------------------------------------------------------------------------------------"
    Write-Host " "
    Write-Host " "
    Write-Host " ------------------------------"
    Write-Host " Press key for close the window "
    Write-Host " "
    Write-Host " "
    Read-Host | Out-Null
}
else {
    Write-Host " "
    Write-Host " "
    Write-Host "    +++ $VectorMessage +++"
    Write-Host " "
    Write-Host " ------------------------------------------------------------------------------------------------------"
    Write-Host " mbit | level relative to maximum value"
    Write-Host " ------------------------------------------------------------------------------------------------------"
    foreach ($num in $numbers) {
        $barLength = [math]::Round($num * $scaleFactor)
        $bar = '|' * $barLength
        Write-Host ("{0,5} | {1}" -f $num, $bar)
    }
    Write-Host " ------------------------------------------------------------------------------------------------------"
    Write-Host " mbit | level relative to maximum value"
    Write-Host " ------------------------------------------------------------------------------------------------------"
    Write-Host " "
    Write-Host "    +++ $VectorMessage +++"
    Write-Host " "
    Write-Host " "
    Write-Host " ------------------------------"
    Write-Host " Press key for close the window "
    Write-Host " "
    Write-Host " "
    Read-Host | Out-Null
}