<#

Параметры:

-VID <код>          : Фильтр по Vendor ID (4-значный HEX). Например: VID=2833
-PidFilter <код>    : Фильтр по Product ID (4-значный HEX). Используется вместе с VID.
-MissingClass        : Показывать только устройства с отсутствующим Class.
-ShowHardwareIDs     : Включить вывод полного поля HardwareIDs.
-ShowConsole         : Выводить результат также в консоль.
-Csv                 : Сохранять результат в CSV вместо TXT.
-NameFilter <строка> : Фильтр по подстроке в имени устройства (без учёта регистра).
-ShortOutput         : Выводить только поля Name, Hidden, DriverStatus, Class, VID; пустые заменяются на N/A.
-Help                : Показать эту справку.

Примеры использования:

1) Собрать все устройства VID=2833 в CSV:
   powershell -File vst.ps1 -VID 2833 -Csv

2) Показать только устройства с отсутствующим Class в TXT и консоли:
   powershell -File vst.ps1 -MissingClass -ShowConsole

3) Вывод короткой таблицы с фильтром по имени "Quest":
   powershell -File vst.ps1 -ShortOutput -NameFilter Quest
#>

param(
    [string]$VID = "",
    [string]$PidFilter = "",
    [switch]$MissingClass,
    [switch]$ShowHardwareIDs,
    [switch]$ShowConsole,
    [switch]$Csv,
    [string]$NameFilter = "",
    [switch]$ShortOutput
)

# Имя компьютера
$ComputerName = $env:COMPUTERNAME

# Текущая дата и время
$DateTime = Get-Date -Format "yy-MM-dd_HH-mm-ss"

# Базовое имя файла
$BaseFileName = "vidpid_info"
if ($MissingClass) {
    $BaseFileName += "_missingclass"
}
if ($ShortOutput) {
    $BaseFileName += "_short"
}

# Пути к файлам
$OutputFileTxt = "${BaseFileName}_${ComputerName}_${DateTime}.txt"
$OutputFileCsv = "${BaseFileName}_${ComputerName}_${DateTime}.csv"

# Строим регулярку
if ($VID -and $PidFilter) {
    $pattern = "VID_${VID}&PID_${PidFilter}"
}
elseif ($VID) {
    $pattern = "VID_${VID}"
}
else {
    $pattern = "VID_([0-9A-F]{4})&PID_([0-9A-F]{4})"
}

try {
    $devices = Get-PnpDevice | Where-Object { $_.InstanceId -match $pattern } | ForEach-Object {
        $vidVal = if ($VID) { $VID } else { $matches[1] }
        $pidVal = if ($PidFilter) { $PidFilter } else { $matches[2] }

        $isHidden = (-not $_.Present)
        $driverStatus = if ($_.ConfigManagerErrorCode -eq 28) { "MissingDriver" } else { "OK" }

        if ($ShortOutput) {
            [PSCustomObject]@{
                Name         = if ($_.FriendlyName) { $_.FriendlyName } else { "N/A" }
                Hidden       = if ($isHidden) { "Yes" } else { "No" }
                DriverStatus = if ($driverStatus) { $driverStatus } else { "N/A" }
                Class        = if ($_.Class) { $_.Class } else { "N/A" }
                VID          = if ($vidVal) { $vidVal } else { "N/A" }
            }
        } else {
            [PSCustomObject]@{
                Name         = $_.FriendlyName
                Hidden       = if ($isHidden) { "Yes" } else { "No" }
                DriverStatus = $driverStatus
                Class        = $_.Class
                VID          = $vidVal
                PID          = $pidVal
                DeviceID     = $_.DeviceID
                Manufacturer = $_.Manufacturer
                HardwareIDs  = ($_.HardwareID -join "; ")
            }
        }
    }

    # Фильтр по отсутствующему классу
    if ($MissingClass) {
        $devices = $devices | Where-Object { -not $_.Class }
    }

    # Фильтр по имени устройства (подстрока, без учёта регистра)
    if ($NameFilter) {
        $devices = $devices | Where-Object { $_.Name -match "(?i)$([regex]::Escape($NameFilter))" }
    }

    if ($devices) {
        if ($Csv) {
            $devices | Export-Csv -Path $OutputFileCsv -Encoding UTF8 -NoTypeInformation
            $ResultFile = $OutputFileCsv
        } else {
            "Computer Name: $ComputerName" | Out-File -FilePath $OutputFileTxt -Encoding utf8
            "Date: $DateTime" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
            "-----------------------------------------------------" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append

            $devices |
                Format-Table -Property * -Wrap -AutoSize |
                Out-String -Width 4096 |
                Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append

            $ResultFile = $OutputFileTxt
        }

        if ($ShowConsole) {
            if ($ShortOutput -or -not $ShowHardwareIDs) {
                $devices | Format-Table -Property * -AutoSize
            } else {
                $devices | Format-Table -Property Name,Hidden,DriverStatus,Class,VID,PID,DeviceID,Manufacturer,HardwareIDs -AutoSize
            }
        }
    }
    else {
        if ($Csv) {
            "No devices found for pattern: $pattern" | Out-File -FilePath $OutputFileCsv -Encoding utf8
            $ResultFile = $OutputFileCsv
        } else {
            "Computer Name: $ComputerName" | Out-File -FilePath $OutputFileTxt -Encoding utf8
            "Date: $DateTime" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
            "-----------------------------------------------------" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
            "No devices found for pattern: $pattern" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
            $ResultFile = $OutputFileTxt
        }

        if ($ShowConsole) {
            Write-Host "No devices found for pattern: $pattern"
        }
    }
}
catch {
    if ($Csv) {
        "Error while collecting devices: $_" | Out-File -FilePath $OutputFileCsv -Encoding utf8
        $ResultFile = $OutputFileCsv
    } else {
        "Computer Name: $ComputerName" | Out-File -FilePath $OutputFileTxt -Encoding utf8
        "Date: $DateTime" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
        "-----------------------------------------------------" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
        "Error while collecting devices: $_" | Out-File -FilePath $OutputFileTxt -Encoding utf8 -Append
        $ResultFile = $OutputFileTxt
    }

    if ($ShowConsole) {
        Write-Host "Error while collecting devices: $_"
    }
}

# Всегда выводим только имя итогового файла
Write-Output $ResultFile
