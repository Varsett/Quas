param(
    [string]$VID = "VID_2833"
)

$ErrorActionPreference = "SilentlyContinue"
$buffer = ""

while ($true) {

    # --- Проверка подключения USB ---
    $device = Get-PnpDevice | Where-Object { $_.InstanceId -like "*$VID*" -and $_.Status -eq "OK" }
    if ($device) { exit 1 }  # CONNECTED

    # --- Показываем приглашение ---
    if ($buffer -eq "") { Write-Host -NoNewline "`r> " }

    # --- Чтение клавиши без блокировки ---
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)

        switch ($key.Key) {
            'Enter' {
                Write-Host ""  # перевод строки
                switch ($buffer.ToUpper()) {
                    "0"  { exit 2 }
                    "S"  { exit 3 }
                    "T"  { exit 4 }
                    "D"  { exit 5 }
                    "K"  { exit 6 }
                    "I"  { exit 7 }
                    "00" { exit 8 }
                }
                $buffer = ""
            }
            'Backspace' {
                if ($buffer.Length -gt 0) {
                    $buffer = $buffer.Substring(0, $buffer.Length - 1)
                    Write-Host -NoNewline "`b `b"
                }
            }
            default {
                $buffer += $key.KeyChar
                Write-Host -NoNewline $key.KeyChar
                if ($buffer.Length -gt 2) { $buffer = $buffer.Substring($buffer.Length - 2) }
            }
        }
    }

    Start-Sleep -Milliseconds 100
}
