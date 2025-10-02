param(
    [Parameter(Mandatory=$true)]
    [string]$MenuFile,

    [string]$Query,       # теперь необязательный параметр

    [string]$OutFile = "menu_export.txt",  # файл для сохранения полного меню
    [int]$Indent = 3      # отступ для вывода
)

if (-not (Test-Path $MenuFile)) {
    Write-Host "Menu file not found: $MenuFile"
    exit
}

# Читаем файл
$lines = Get-Content $MenuFile -Encoding UTF8
$queryLower = if ($Query) { $Query.ToLower() } else { "" }

# Стек для текущих кодов по уровням
$stack = @("MainMenu")
$found = $false

# Пробелы для отступа
$indentStr = " " * $Indent

# Список результатов (для сохранения в файл)
$results = @()

foreach ($line in $lines) {
    if ($line -match "^(?<markers>#+)?(?<code>[^\.]+)\. (?<title>.+)$") {
        $markers = $matches['markers']
        $level = if ($markers) { $markers.Length } else { 0 }  # MainMenu = 0
        $code = $matches['code'].Trim()
        $title = $matches['title'].Trim()

        # Корректируем стек по уровню
        while ($stack.Count -gt ($level + 1)) { $stack = $stack[0..($level)] }

        if ($stack.Count -eq ($level + 1)) {
            $stack[$level] = $code
        } else {
            $stack += $code
        }

        $path = ($stack -join " > ")
        $lineOut = "$indentStr$path | $title"

        # Если задан Query → ищем совпадение
        if ($Query) {
            if ($title.ToLower().Contains($queryLower)) {
                Write-Host $lineOut
                $results += $lineOut
                $found = $true
            }
        }
        else {
            # Если Query не указан → сохраняем всё меню
            $results += $lineOut
        }
    }
}

if ($Query) {
    if (-not $found) {
        Write-Host "No matches found for '$Query'"
    }
}
else {
    # Сохраняем весь результат в файл
    $results | Out-File -FilePath $OutFile -Encoding UTF8
#    Write-Host "Full menu saved to $OutFile"
}
