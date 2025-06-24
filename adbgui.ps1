param (
    [string]$AdbPath = "."
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "ADB GUI Utility"
$form.Size = New-Object System.Drawing.Size(800, 620)
$form.StartPosition = "CenterScreen"
$form.KeyPreview = $true
$form.MinimumSize = New-Object System.Drawing.Size(600, 400)

$font = New-Object System.Drawing.Font("Consolas", 12)

$cmdBox = New-Object System.Windows.Forms.TextBox
$cmdBox.Multiline = $true
$cmdBox.ScrollBars = "Vertical"
$cmdBox.WordWrap = $true
$cmdBox.Size = New-Object System.Drawing.Size(760, 150)
$cmdBox.Location = New-Object System.Drawing.Point(10, 10)
$cmdBox.Font = $font
$cmdBox.BackColor = "#FFFBE6"

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.WordWrap = $true
$logBox.Size = New-Object System.Drawing.Size(760, 300)
$logBox.Location = New-Object System.Drawing.Point(10, 170)
$logBox.Font = $font
$logBox.BackColor = "#E8F5E9"

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run (F5)"
$btnRun.Size = New-Object System.Drawing.Size(100, 30)
$btnRun.Location = New-Object System.Drawing.Point(10, 490)

$btnCopy = New-Object System.Windows.Forms.Button
$btnCopy.Text = "Copy"
$btnCopy.Size = New-Object System.Drawing.Size(100, 30)
$btnCopy.Location = New-Object System.Drawing.Point(120, 490)

$btnPaste = New-Object System.Windows.Forms.Button
$btnPaste.Text = "Paste"
$btnPaste.Size = New-Object System.Drawing.Size(100, 30)
$btnPaste.Location = New-Object System.Drawing.Point(230, 490)

$btnClearCode = New-Object System.Windows.Forms.Button
$btnClearCode.Text = "Clear Code"
$btnClearCode.Size = New-Object System.Drawing.Size(100, 30)
$btnClearCode.Location = New-Object System.Drawing.Point(340, 490)

$btnClearLogs = New-Object System.Windows.Forms.Button
$btnClearLogs.Text = "Clear Logs"
$btnClearLogs.Size = New-Object System.Drawing.Size(100, 30)
$btnClearLogs.Location = New-Object System.Drawing.Point(450, 490)

$btnHelp = New-Object System.Windows.Forms.Button
$btnHelp.Text = "Help"
$btnHelp.Size = New-Object System.Drawing.Size(100, 30)
$btnHelp.Location = New-Object System.Drawing.Point(560, 490)

$btnSaveLog = New-Object System.Windows.Forms.Button
$btnSaveLog.Text = "Save Log"
$btnSaveLog.Size = New-Object System.Drawing.Size(100, 30)
$btnSaveLog.Location = New-Object System.Drawing.Point(670, 490)

# Anchors
$cmdBox.Anchor = "Top, Left, Right"
$logBox.Anchor = "Top, Left, Right, Bottom"
$btnRun.Anchor = "Bottom, Left"
$btnCopy.Anchor = "Bottom, Left"
$btnPaste.Anchor = "Bottom, Left"
$btnClearCode.Anchor = "Bottom, Left"
$btnClearLogs.Anchor = "Bottom, Left"
$btnHelp.Anchor = "Bottom, Left"
$btnSaveLog.Anchor = "Bottom, Left"

$helpText = @"
Enter adb commands, one per line, in the upper box.
Press Run button or F5 to execute commands.
Buttons:
 - Copy: copy output text
 - Paste: paste clipboard into commands box
 - Clear Code: clear commands input
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

$runAction = {
    $commands = $cmdBox.Lines | Where-Object { $_.Trim() -ne "" }
    $AdbPathTrimmed = $AdbPath.Trim('"').TrimEnd('\')

    foreach ($cmd in $commands) {
        $logBox.AppendText("> $cmd`r`n")
        try {
            $exe = if ($cmd -match "^fastboot") { "fastboot.exe" } else { "adb.exe" }
            $fullPath = Join-Path $AdbPathTrimmed $exe

            if (!(Test-Path $fullPath)) {
                $logBox.AppendText("Error: $fullPath not found.`r`n")
                continue
            }

            $cmdParts = $cmd -split "\s+", 2
            $args = if ($cmdParts.Length -gt 1) { $cmdParts[1] } else { "" }

            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName = $fullPath
            $psi.Arguments = $args
            $psi.RedirectStandardOutput = $true
            $psi.RedirectStandardError = $true
            $psi.UseShellExecute = $false
            $psi.CreateNoWindow = $true

            $proc = [System.Diagnostics.Process]::Start($psi)
            $stdout = $proc.StandardOutput.ReadToEnd()
            $stderr = $proc.StandardError.ReadToEnd()
            $proc.WaitForExit()

            if ($stdout) { $logBox.AppendText("$stdout`r`n") }
            if ($stderr) { $logBox.AppendText("ERROR: $stderr`r`n") }

        } catch {
            $logBox.AppendText("Exception: $_`r`n")
        }
    }
}

$btnRun.Add_Click($runAction)
$form.Add_KeyDown({ if ($_.KeyCode -eq 'F5') { & $runAction } })

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
    $saveFileDialog.FileName = "adb_log.txt"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            [System.IO.File]::WriteAllText($saveFileDialog.FileName, $logBox.Text)
            [System.Windows.Forms.MessageBox]::Show("Log saved successfully.","Save Log",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to save log: $_","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

# Клавиатурные сокращения Ctrl+A/C (но без Ctrl+V — он работает штатно)
$cmdBox.Add_KeyDown({
    if ($_.Control -and $_.KeyCode -eq "A") { $cmdBox.SelectAll(); $_.Handled = $true }
    elseif ($_.Control -and $_.KeyCode -eq "C") { [System.Windows.Forms.Clipboard]::SetText($cmdBox.SelectedText) }
})
$logBox.Add_KeyDown({
    if ($_.Control -and $_.KeyCode -eq "A") { $logBox.SelectAll(); $_.Handled = $true }
    elseif ($_.Control -and $_.KeyCode -eq "C") { [System.Windows.Forms.Clipboard]::SetText($logBox.SelectedText) }
})

$form.Controls.AddRange(@(
    $cmdBox, $logBox,
    $btnRun, $btnCopy, $btnPaste,
    $btnClearCode, $btnClearLogs, $btnHelp, $btnSaveLog
))

$form.ShowDialog()
