# =================================================================
# Скрипт: ADB Professional Input Manager
# Описание: Утилита для отправки текста на Android через ADB
# Версия: 3.1 (Панорамный режим: 1200x400)
# =================================================================
param (
    [string]$ToolsPath
)

# 1. ПОДГОТОВКА СРЕДЫ
$adbPath = if ($ToolsPath) { Join-Path $ToolsPath "adb.exe" } else { "adb" }
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- ЦВЕТОВАЯ СХЕМА ---
$colorBg    = [System.Drawing.Color]::FromArgb(32, 32, 32)
$colorInput = [System.Drawing.Color]::FromArgb(45, 45, 45)
$colorText  = [System.Drawing.Color]::White
$colorBlue  = [System.Drawing.Color]::FromArgb(0, 120, 215)
$colorGreen = [System.Drawing.Color]::FromArgb(34, 139, 34)
$colorGray  = [System.Drawing.Color]::FromArgb(65, 65, 65)

# --- СОЗДАНИЕ ГЛАВНОГО ОКНА ---
$form = New-Object System.Windows.Forms.Form
$form.Text            = "Quas ADB Sender  v3.1"
$form.Size            = New-Object System.Drawing.Size(1200, 430)
$form.BackColor       = $colorBg
$form.StartPosition   = "CenterScreen"
$form.MinimumSize     = New-Object System.Drawing.Size(900, 350)

# --- ПОЛЕ ВВОДА ТЕКСТА ---
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline    = $true
$textBox.WordWrap     = $true
$textBox.ScrollBars   = "Vertical"
$textBox.Location     = New-Object System.Drawing.Point(12, 12)
$textBox.Size         = New-Object System.Drawing.Size(1030, 330)
$textBox.BackColor    = $colorInput
$textBox.ForeColor    = $colorText
$textBox.Font         = New-Object System.Drawing.Font("Consolas", 11)
$textBox.BorderStyle  = "FixedSingle"
$textBox.Anchor       = "Top, Left, Right, Bottom"
$textBox.HideSelection = $false   # Сохраняет выделение при потере фокуса
$form.Controls.Add($textBox)

# --- СТАТУСНАЯ СТРОКА ---
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location  = New-Object System.Drawing.Point(12, 350)
$statusLabel.Size      = New-Object System.Drawing.Size(1030, 20)
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$statusLabel.Font      = New-Object System.Drawing.Font("Consolas", 9)
$statusLabel.Anchor    = "Bottom, Left, Right"
$statusLabel.Text      = "Ready."
$form.Controls.Add($statusLabel)

function Set-Status ([string]$msg) {
    $statusLabel.Text = $msg
    [System.Windows.Forms.Application]::DoEvents()
}

# --- ЛОГИКА ОТПРАВКИ ---
function Invoke-AdbTask ([string]$txt, [switch]$Wait) {
    if ([string]::IsNullOrWhiteSpace($txt)) { return }

    # Экранируем только одинарную кавычку — больше ничего не трогаем
    $escaped   = $txt.Trim() -replace "'", "'\''"
    $argString = "shell input text '$escaped'"

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName               = $adbPath
    $psi.Arguments              = $argString
    $psi.WindowStyle            = "Hidden"
    $psi.UseShellExecute        = $false
    $psi.RedirectStandardError  = $true   # подавляем всплывающие ошибки ADB

    $process = [System.Diagnostics.Process]::Start($psi)

    if ($Wait) {
        while (!$process.HasExited) {
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 50
        }
    }
}

# --- ВЫДЕЛЕНИЕ СТРОКИ ---
# FIX: Refresh() после Select() гарантирует перерисовку выделения;
#      кнопки с TabStop=$false не уводят фокус из TextBox.
function Set-LineHighlight ([int]$index) {
    if ($index -ge 0 -and $index -lt $textBox.Lines.Count) {
        $start  = $textBox.GetFirstCharIndexFromLine($index)
        $length = $textBox.Lines[$index].Length

        $textBox.Focus()
        $textBox.Select($start, $length)
        $textBox.ScrollToCaret()
        $textBox.Refresh()                            # <-- ключевой фикс визуального обновления
        [System.Windows.Forms.Application]::DoEvents()
    }
}

function Get-CurrentLineIndex {
    return $textBox.GetLineFromCharIndex($textBox.SelectionStart)
}

# --- ФАБРИКА КНОПОК ---
function New-StyledBtn {
    param($txt, $y, $bg, $visible=$true)
    $b = New-Object System.Windows.Forms.Button
    $b.Text       = $txt
    $b.Location   = New-Object System.Drawing.Point(1060, $y)
    $b.Size       = New-Object System.Drawing.Size(105, 35)
    $b.FlatStyle  = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor  = $bg
    $b.ForeColor  = "White"
    $b.Font       = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $b.Anchor     = "Top, Right"
    $b.Visible    = $visible
    $b.TabStop    = $false    # <-- FIX: кнопка не перехватывает фокус у TextBox
    return $b
}

# --- КНОПКА: PASTE ---
$btnPaste = New-StyledBtn "PASTE" 12 $colorBlue
$btnPaste.Add_Click({
    $textBox.Text = [System.Windows.Forms.Clipboard]::GetText()
    Set-Status ("Pasted {0} lines." -f $textBox.Lines.Count)
})

# --- КНОПКА: SEND (текущая строка) ---
$btnSend = New-StyledBtn "SEND" 55 $colorGreen
$btnSend.Add_Click({
    $idx  = Get-CurrentLineIndex
    $line = $textBox.Lines[$idx]
    Set-LineHighlight $idx
    Set-Status ("Sending line {0}: {1}" -f ($idx + 1), $line)
    Invoke-AdbTask $line
    Set-Status ("Sent line {0}." -f ($idx + 1))
})

# --- КНОПКА: NEXT (отправить текущую → перейти на следующую) ---
$btnNext = New-StyledBtn "NEXT" 100 $colorGray $false
$btnNext.Add_Click({
    $btnNext.Enabled = $false
    $idx  = Get-CurrentLineIndex
    $line = $textBox.Lines[$idx]

    # FIX: выделяем ДО отправки, Refresh() закрепляет визуал
    Set-LineHighlight $idx
    Set-Status ("Sending line {0}: {1}" -f ($idx + 1), $line)
    Invoke-AdbTask $line -Wait

    # Переходим на следующую непустую строку (или просто следующую)
    $next = $idx + 1
    if ($next -lt $textBox.Lines.Count) {
        Set-LineHighlight $next
        Set-Status ("Ready. Line {0} selected." -f ($next + 1))
    } else {
        Set-Status "Last line reached."
    }

    $btnNext.Enabled = $true
})

# --- КНОПКА: SEND ALL ---
$btnSendAll = New-StyledBtn "SEND ALL" 145 $colorGray $false
$btnSendAll.Add_Click({
    $btnSendAll.Enabled = $false
    $total = $textBox.Lines.Count

    for ($i = 0; $i -lt $total; $i++) {
        $line = $textBox.Lines[$i]

        # FIX: выделяем КАЖДУЮ строку (включая пустые — чтобы пользователь видел прогресс),
        #      но отправляем только непустые
        Set-LineHighlight $i

        if (![string]::IsNullOrWhiteSpace($line)) {
            Set-Status ("Sending line {0}/{1}: {2}" -f ($i + 1), $total, $line)
            Invoke-AdbTask $line -Wait
            Start-Sleep -Milliseconds 500
        } else {
            Set-Status ("Skipping empty line {0}/{1}." -f ($i + 1), $total)
            [System.Windows.Forms.Application]::DoEvents()
            Start-Sleep -Milliseconds 100
        }
    }

    Set-Status ("Done. Sent {0} lines." -f $total)
    $btnSendAll.Enabled = $true
})

# --- КНОПКА: HELP ---
$btnHelp = New-StyledBtn "HELP" 250 $colorGray
$btnHelp.BackColor = [System.Drawing.Color]::DimGray
$btnHelp.Anchor    = "Bottom, Right"
$btnHelp.Add_Click({
    $copyright = [char]0x00A9
    $helpText  = @"
Quas ADB Sender v3.1
--------------------------------
Instructions:

1. Connect your Android device via USB/Wi-Fi and enable ADB Debugging.
2. Place the cursor on the headset in the field where you want to enter text.
3. Paste or type your text in the main window.

4. Single Mode (Default):
   - Click SEND to input the current line under cursor.

5. Multi Mode (Checkbox):
   - NEXT  : Sends current line, then moves selection to the next one.
   - SEND ALL: Sends every line one by one with a delay.
             Empty lines are skipped but still highlighted for progress tracking.

6. Status bar (bottom) shows current operation in real time.

Note: Do not type on device manually while SEND ALL is active.
Special characters (spaces, quotes, &, |, etc.) are automatically escaped.

$copyright 2026 Varset & Gemini Dev  |  v3.1 fixes by Claude
"@
    [System.Windows.Forms.MessageBox]::Show($helpText, "How to use")
})

# --- ЧЕКБОКС MULTI MODE ---
$chkMulti = New-Object System.Windows.Forms.CheckBox
$chkMulti.Text      = "Multi Mode"
$chkMulti.ForeColor = $colorText
$chkMulti.Location  = New-Object System.Drawing.Point(1060, 300)
$chkMulti.Anchor    = "Bottom, Right"
$chkMulti.AutoSize  = $true
$chkMulti.TabStop   = $false
$chkMulti.Add_CheckedChanged({
    $btnNext.Visible    = $chkMulti.Checked
    $btnSendAll.Visible = $chkMulti.Checked
})

# --- ГОРЯЧИЕ КЛАВИШИ ---
# Ctrl+Enter → SEND текущей строки
$textBox.Add_KeyDown({
    param($s, $e)
    if ($e.Control -and $e.KeyCode -eq [System.Windows.Forms.Keys]::Return) {
        $e.SuppressKeyPress = $true
        $btnSend.PerformClick()
    }
    # Ctrl+Shift+Enter → NEXT (если Multi Mode)
    if ($e.Control -and $e.Shift -and $e.KeyCode -eq [System.Windows.Forms.Keys]::Return) {
        $e.SuppressKeyPress = $true
        if ($chkMulti.Checked) { $btnNext.PerformClick() }
    }
})

$form.Controls.AddRange(@($btnPaste, $btnSend, $btnNext, $btnSendAll, $btnHelp, $chkMulti))
$form.ShowDialog()