param (
    [string]$ToolPath = "."
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Command GUI Utility"
$form.Size = New-Object System.Drawing.Size(800, 620)
$form.StartPosition = "CenterScreen"
$form.MinimumSize = New-Object System.Drawing.Size(600, 400)
$form.KeyPreview = $true

$font = New-Object System.Drawing.Font("Consolas", 12)

# SplitContainer для вертикального деления
$splitContainer = New-Object System.Windows.Forms.SplitContainer
$splitContainer.Dock = 'Fill'
$splitContainer.Orientation = 'Horizontal'
$splitContainer.SplitterDistance = 150
$splitContainer.MinimumSize = New-Object System.Drawing.Size(600, 400)
$splitContainer.Panel1MinSize = 50
$splitContainer.Panel2MinSize = 50

# Командное поле
$cmdBox = New-Object System.Windows.Forms.TextBox
$cmdBox.Multiline = $true
$cmdBox.ScrollBars = 'Vertical'
$cmdBox.WordWrap = $true
$cmdBox.Dock = 'Fill'
$cmdBox.Font = $font
$cmdBox.BackColor = "#FFFBE6"

# Поле вывода
$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.ReadOnly = $true
$logBox.Dock = 'Fill'
$logBox.Font = $font
$logBox.BackColor = "#E8F5E9"

$splitContainer.Panel1.Controls.Add($cmdBox)
$splitContainer.Panel2.Controls.Add($logBox)

$form.Controls.Add($splitContainer)

# Кнопки
$btnPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$btnPanel.Dock = 'Bottom'
$btnPanel.Height = 40
$form.Controls.Add($btnPanel)

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run (F5)"
$btnRun.Width = 100

$btnCopy = New-Object System.Windows.Forms.Button
$btnCopy.Text = "Copy"
$btnCopy.Width = 100

$btnPaste = New-Object System.Windows.Forms.Button
$btnPaste.Text = "Paste"
$btnPaste.Width = 100

$btnClearCode = New-Object System.Windows.Forms.Button
$btnClearCode.Text = "Clear Code"
$btnClearCode.Width = 100

$btnClearLogs = New-Object System.Windows.Forms.Button
$btnClearLogs.Text = "Clear Logs"
$btnClearLogs.Width = 100

$btnHelp = New-Object System.Windows.Forms.Button
$btnHelp.Text = "Help"
$btnHelp.Width = 100

$btnSaveLog = New-Object System.Windows.Forms.Button
$btnSaveLog.Text = "Save Log"
$btnSaveLog.Width = 100

$btnPanel.Controls.AddRange(@(
    $btnRun, $btnCopy, $btnPaste,
    $btnClearCode, $btnClearLogs,
    $btnHelp, $btnSaveLog
))

# Интерактивные команды - регулярки для определения
$interactiveCommands = @(
    "^adb(\.exe)?\s+shell\b",
    "^cmd(\.exe)?$",
    "^powershell(\.exe)?$",
"^fastboot(\.exe)?(\s+.+)?$"
)

function Is-InteractiveCommand($line) {
    foreach ($pattern in $interactiveCommands) {
        if ($line -match $pattern) {
            return $true
        }
    }
    return $false
}

# Функция запуска команд
$runAction = {
    $commands = $cmdBox.Lines | Where-Object { $_.Trim() -ne "" }
    $toolPathTrimmed = $ToolPath.Trim('"').TrimEnd('\')

    foreach ($line in $commands) {
        $logBox.SelectionStart = $logBox.TextLength
        $logBox.SelectionColor = [System.Drawing.Color]::Blue
        $logBox.AppendText("> $line`r`n")
        $logBox.SelectionColor = $logBox.ForeColor

        $isInteractive = Is-InteractiveCommand $line

        if ($isInteractive) {
            if ($line -match "^(adb(\.exe)?\s+shell)") {
                Start-Process "cmd.exe" -ArgumentList "/k cd `"$toolPathTrimmed`" && $line"
            } elseif ($line -match "^(powershell(\.exe)?)") {
                Start-Process "powershell.exe" -ArgumentList "-NoExit", "-Command", "Set-Location -Path `"$toolPathTrimmed`" ; $line"
            } elseif ($line -match "^(cmd(\.exe)?)") {
                Start-Process "cmd.exe" -ArgumentList "/k cd `"$toolPathTrimmed`" && $line"
            } elseif ($line -match "^(fastboot(\.exe)?)$") {
                Start-Process "cmd.exe" -ArgumentList "/k cd `"$toolPathTrimmed`" && $line"
            } else {
                Start-Process "cmd.exe" -ArgumentList "/k cd `"$toolPathTrimmed`" && $line"
            }
            $logBox.SelectionColor = [System.Drawing.Color]::Green
            $logBox.AppendText("Interactive command launched in separate window.`r`n")
            $logBox.SelectionColor = $logBox.ForeColor
            continue
        }

        # Обычное выполнение команд
        try {
            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName = "cmd.exe"
            $psi.Arguments = "/c cd `"$toolPathTrimmed`" && $line"
            $psi.RedirectStandardOutput = $true
            $psi.RedirectStandardError = $true
            $psi.UseShellExecute = $false
            $psi.CreateNoWindow = $true

            $proc = [System.Diagnostics.Process]::Start($psi)
            $stdout = $proc.StandardOutput.ReadToEnd()
            $stderr = $proc.StandardError.ReadToEnd()
            $proc.WaitForExit()

            if ($stdout) {
                $logBox.SelectionColor = [System.Drawing.Color]::Black
                $logBox.AppendText("$stdout`r`n")
            }
            if ($stderr) {
                $logBox.SelectionColor = [System.Drawing.Color]::Red
                $logBox.AppendText("ERROR: $stderr`r`n")
            }
            $logBox.SelectionColor = $logBox.ForeColor
        } catch {
            $logBox.SelectionColor = [System.Drawing.Color]::Red
            $logBox.AppendText("Exception: $_`r`n")
            $logBox.SelectionColor = $logBox.ForeColor
        }
    }

    # Прокрутка в конец
    $logBox.SelectionStart = $logBox.TextLength
    $logBox.ScrollToCaret()
}

$btnRun.Add_Click($runAction)
$form.Add_KeyDown({
    if ($_.KeyCode -eq 'F5') {
        $runAction.Invoke()
    }
})

$btnCopy.Add_Click({ [System.Windows.Forms.Clipboard]::SetText($logBox.Text) })

$btnPaste.Add_Click({
    if ([Windows.Forms.Clipboard]::ContainsText()) {
        $clipText = [Windows.Forms.Clipboard]::GetText()
        $selStart = $cmdBox.SelectionStart
        $cmdBox.Text = $cmdBox.Text.Insert($selStart, $clipText)
        $cmdBox.SelectionStart = $selStart + $clipText.Length
        $cmdBox.SelectionLength = 0
    }
})

$btnClearCode.Add_Click({ $cmdBox.Clear() })
$btnClearLogs.Add_Click({ $logBox.Clear() })

$btnSaveLog.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
    $saveFileDialog.Title = "Save Log As"
    $saveFileDialog.FileName = "command_log.txt"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            [System.IO.File]::WriteAllText($saveFileDialog.FileName, $logBox.Text)
            [System.Windows.Forms.MessageBox]::Show("Log saved successfully.","Save Log",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to save log: $_","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

# Ctrl+A, Ctrl+C shortcuts
$cmdBox.Add_KeyDown({
    if ($_.Control -and $_.KeyCode -eq "A") { $cmdBox.SelectAll(); $_.Handled = $true }
    elseif ($_.Control -and $_.KeyCode -eq "C") { [System.Windows.Forms.Clipboard]::SetText($cmdBox.SelectedText) }
})
$logBox.Add_KeyDown({
    if ($_.Control -and $_.KeyCode -eq "A") { $logBox.SelectAll(); $_.Handled = $true }
    elseif ($_.Control -and $_.KeyCode -eq "C") { [System.Windows.Forms.Clipboard]::SetText($logBox.SelectedText) }
})

$helpText = @"
Enter commands in the top box, one per line.
Press Run (or F5) to execute commands.
Interactive commands (e.g. adb shell, fastboot, powershell, cmd) open in separate windows.
Buttons:
 - Copy: copy output text
 - Paste: paste clipboard into command box
 - Clear Code: clear command input
 - Clear Logs: clear output logs
 - Save Log: save current logs to a text file
"@

$btnHelp.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        $helpText,
        "Help",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

$form.ShowDialog()
