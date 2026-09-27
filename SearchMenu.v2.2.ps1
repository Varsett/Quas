param(
    [Parameter(Mandatory=$true)]
    [string]$MenuFile,

    [string]$Query,
    [string]$GoPath,
    [string]$OutFile = "menu_export.txt",
    [string]$SearchExportFile = "menu_search_results.txt",
    [int]$Indent = 3,
    [switch]$Navigate,
    [int]$Select = -1,
    [switch]$StopBeforeLast,
    [ValidateSet("RU","EN")]
    [string]$Lang = "EN"
)

# --- Локализация ---
$T = if ($Lang -eq "RU") {
    @{
        FileNotFound       = "Файл меню не найден: "
        NoMatches          = "Совпадений не найдено для: "
        SaveFullPrompt     = "Нажмите [Пробел] чтобы сохранить полное меню, или любую другую клавишу для выхода..."
        FullMenuSaved      = "Полное меню сохранено в "
        NavHint            = " [Пробел] — сохранить полное меню`n [Tab]    — сохранить результаты поиска`n [Enter]  — выход`n"
        NavInput           = "Введите номер для перехода и нажмите Enter: "
        SearchResultsSaved = "Результаты поиска сохранены в "
        Navigating         = "Переход: "
        PressEnter         = "Нажмите Enter для выхода"
    }
} else {
    @{
        FileNotFound       = "Menu file not found: "
        NoMatches          = "No matches found for: "
        SaveFullPrompt     = "Press [Space] to save full menu, or any other key to exit..."
        FullMenuSaved      = "Full menu saved to "
        NavHint            = "[Space] — save full menu`n[Tab]   — save search results`nEnter  — exit`n"
        NavInput           = "Enter number to navigate and press Enter: "
        SearchResultsSaved = "Search results saved to "
        Navigating         = "Navigating: "
        PressEnter         = "Press Enter to exit"
    }
}

if (-not (Test-Path $MenuFile)) {
    Write-Host "$($T.FileNotFound)$MenuFile"
    exit
}

$lines = Get-Content $MenuFile -Encoding UTF8
$queryLower = if ($Query) { $Query.ToLower() } else { "" }

$stack = @("MainMenu")
$found = $false
$indentStr = " " * $Indent
$results = @()
$resultPaths = @()

foreach ($line in $lines) {
    if ($line -match "^(?<markers>#+)?(?<code>[^\.]+)\. (?<title>.+)$") {
        $markers = $matches['markers']
        $level = if ($markers) { $markers.Length } else { 0 }
        $code = $matches['code'].Trim()
        $title = $matches['title'].Trim()

        while ($stack.Count -gt ($level + 1)) { $stack = $stack[0..($level)] }

        if ($stack.Count -eq ($level + 1)) {
            $stack += $code
        } else {
            $stack[$level + 1] = $code
        }

        $path = ($stack -join " > ")
        $lineOut = "$indentStr$path | $title"

        if ($Query) {
            if ($title.ToLower().Contains($queryLower)) {
                $results += $lineOut
                $navPath = ($stack[1..($stack.Count-1)] -join ">")
                $resultPaths += $navPath
                $found = $true
            }
        }
        else {
            $results += $lineOut
        }
    }
}

function Send-MenuKeys {
    param([string]$Path, [int]$DelayMs = 400, [switch]$StopBeforeLast)

    Add-Type -AssemblyName System.Windows.Forms

    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -Milliseconds $DelayMs

    $keys = $Path -split ">"

    if ($StopBeforeLast -and $keys.Count -gt 1) {
        $keys = $keys[0..($keys.Count-2)]
    }

    foreach ($k in $keys) {
        $k = $k.Trim()
        if ($k -ieq "Enter") {
            [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
        } else {
            $escaped = $k -replace '([+^%~(){}])', '{$1}'
            [System.Windows.Forms.SendKeys]::SendWait($escaped)
        }
        Start-Sleep -Milliseconds $DelayMs
        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
        Start-Sleep -Milliseconds $DelayMs
    }
}

function Save-FullMenu {
    param([string[]]$Lines, [string]$IndentStr, [string]$OutFile)

    $fullStack = @("MainMenu")
    $fullResults = @()

    foreach ($line in $Lines) {
        if ($line -match "^(?<markers>#+)?(?<code>[^\.]+)\. (?<title>.+)$") {
            $markers = $matches['markers']
            $level = if ($markers) { $markers.Length } else { 0 }
            $code = $matches['code'].Trim()
            $title = $matches['title'].Trim()

            while ($fullStack.Count -gt ($level + 1)) { $fullStack = $fullStack[0..($level)] }

            if ($fullStack.Count -eq ($level + 1)) {
                $fullStack += $code
            } else {
                $fullStack[$level + 1] = $code
            }

            $fullResults += "$IndentStr$($fullStack -join " > ") | $title"
        }
    }

    $fullResults | Out-File -FilePath $OutFile -Encoding UTF8
    Write-Host "$($T.FullMenuSaved)$OutFile"
    Start-Sleep -Milliseconds 1200
}

function Save-SearchResults {
    param([string[]]$Results, [string]$OutFile)

    $Results | Out-File -FilePath $OutFile -Encoding UTF8
    Write-Host "$($T.SearchResultsSaved)$OutFile"
    Start-Sleep -Milliseconds 1200
}

function Read-NavInput {
    # Возвращает: @{ Action = "navigate"|"saveAll"|"saveSearch"|"exit"; Number = <int или -1> }
    $inputChars = ""

    while ($true) {
        $key = [Console]::ReadKey($true)

        if ($key.Key -eq [ConsoleKey]::Spacebar) {
            Write-Host ""
            return @{ Action = "saveAll"; Number = -1 }
        }
        elseif ($key.Key -eq [ConsoleKey]::Tab) {
            Write-Host ""
            return @{ Action = "saveSearch"; Number = -1 }
        }
        elseif ($key.Key -eq [ConsoleKey]::Enter) {
            Write-Host ""
            if ($inputChars -match '^\d+$') {
                return @{ Action = "navigate"; Number = ([int]$inputChars - 1) }
            }
            return @{ Action = "exit"; Number = -1 }
        }
        elseif ($key.Key -eq [ConsoleKey]::Backspace) {
            if ($inputChars.Length -gt 0) {
                $inputChars = $inputChars.Substring(0, $inputChars.Length - 1)
                Write-Host -NoNewline "`b `b"
            }
        }
        elseif ($key.KeyChar -match '\d') {
            $inputChars += $key.KeyChar
            Write-Host -NoNewline $key.KeyChar
        }
    }
}

if ($Query) {
    if (-not $found) {
        Write-Host "$($T.NoMatches)'$Query'"
        if ($Navigate) {
            Write-Host ""
            Write-Host $T.SaveFullPrompt
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq [ConsoleKey]::Spacebar) {
                Save-FullMenu -Lines $lines -IndentStr $indentStr -OutFile $OutFile
            }
        }
    }
    else {
        for ($i = 0; $i -lt $results.Count; $i++) {
            $num = "{0:D2}" -f ($i + 1)
            Write-Host -NoNewline "["
            Write-Host -NoNewline $num -ForegroundColor Cyan
            Write-Host "] $($results[$i])"
        }

        Write-Host ""

        $chosen = $Select
        if ($chosen -lt 0 -and $Navigate) {
            Write-Host $T.NavHint
            Write-Host -NoNewline $T.NavInput
			$nav = Read-NavInput

            switch ($nav.Action) {
                "saveAll"    { Save-FullMenu -Lines $lines -IndentStr $indentStr -OutFile $OutFile }
                "saveSearch" { Save-SearchResults -Results $results -OutFile $SearchExportFile }
                "navigate"   { $chosen = $nav.Number }
                "exit"       { }
            }
        }

        if ($chosen -ge 0 -and $chosen -lt $results.Count) {
            Write-Host "$($T.Navigating)$($resultPaths[$chosen])"
            Send-MenuKeys -Path $resultPaths[$chosen] -StopBeforeLast:$StopBeforeLast
        }
    }
}
elseif ($GoPath) {
    Write-Host "$($T.Navigating)$GoPath"
    Send-MenuKeys -Path $GoPath -StopBeforeLast:$StopBeforeLast
}
else {
    $results | Out-File -FilePath $OutFile -Encoding UTF8
}