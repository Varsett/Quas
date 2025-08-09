param (
    [string]$serial = "0000000000000"  # Значение по умолчанию
)

# Преобразуем строку в байты
$serialBytes = [System.Text.Encoding]::UTF8.GetBytes($serial)

# SHA-256 хеш
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$digest = $sha256.ComputeHash($serialBytes)

# Создаем 8-байтовый буфер
$order = New-Object byte[] 8
[Array]::Copy($digest, 0, $order, 0, 4)

# Преобразуем в Int64 (Little Endian)
$longValue = [BitConverter]::ToInt64($order, 0)

# Вычисляем значение по модулю 100000 как целое число
$modValue = [math]::Abs([int]($longValue % 100000))

# Форматируем с ведущими нулями
$result = "{0:D5}" -f $modValue

# Выводим результат
Write-Output $result
