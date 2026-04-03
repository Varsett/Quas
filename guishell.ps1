<#
.SYNOPSIS
    Quas GUI Shell v4.8.2
    created by Varset & Gemini Dev
.DESCRIPTION
    - Based on Golden v4.8.0 (Isolated CMD + Taskkill Watchdog).
    - Added: Visual Busy Indicator on STOP button.
    - Added: Run button lock during execution.
    - Preserved: "Cannon" ReadToEnd output.
#>

param (
    [string]$ToolsPath = ""
)

# --- Path Processing ---
if ($ToolsPath) {
    $cleanPath = $ToolsPath.Replace('"', '').TrimEnd('\')
    $env:PATH = "$cleanPath;" + $env:PATH
    $global:tPath = $cleanPath + "\"
} else {
    $global:tPath = ""
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$global:isStopping = $false
$global:isDarkMode = $true 
$global:lastCodeBackup = ""
$global:lastLogBackup = ""
$global:highlightColor = [System.Drawing.Color]::FromArgb(255, 255, 180)

# --- 1. HINTS LOADING ---
$searchDir = if ($global:tPath) { $global:tPath } else { $env:myfiles }
if (-not $searchDir) { $searchDir = "$PSScriptRoot\Source" }
$rawPath = $searchDir.ToString().Replace('"', '').TrimEnd('\')
$hintsFile = Join-Path $rawPath "hints.txt"
$global:allHints = if (Test-Path $hintsFile) { Get-Content $hintsFile | Where-Object { $_ -and -not $_.StartsWith("#") } | Sort-Object } else { @() }

# --- 2. FONTS ---
$font = New-Object System.Drawing.Font("Consolas", 11)
$uiFont = New-Object System.Drawing.Font("Segoe UI", 9)

# --- 3. FUNCTIONS ---

function Show-LogDetached {
    $detachForm = New-Object System.Windows.Forms.Form -Property @{ Text = "Quas GUI Shell - Expanded Log (Searchable)"; Size = "1000,800"; StartPosition = "CenterScreen"; BackColor = $logBox.BackColor }
    $pnlSearch = New-Object System.Windows.Forms.Panel -Property @{ Dock = "Top"; Height = 45; BackColor = $btnPanel.BackColor }
    $lblSearch = New-Object System.Windows.Forms.Label -Property @{ Text = "Search Log:"; Left = 10; Top = 14; Width = 80; ForeColor = $chkLogSearch.ForeColor }
    $detSearchBox = New-Object System.Windows.Forms.TextBox -Property @{ Left = 95; Top = 10; Width = 350; Font = $uiFont; BackColor = $searchBox.BackColor; ForeColor = $searchBox.ForeColor }
    $detachBox = New-Object System.Windows.Forms.RichTextBox -Property @{ Dock = "Fill"; ReadOnly = $true; BackColor = $logBox.BackColor; ForeColor = $logBox.ForeColor; Font = $font; BorderStyle = "None" }
    $detSearchBox.Tag = $detachBox
    $detSearchBox.Add_TextChanged({
        $box = $this.Tag; $query = $this.Text
        if ($null -eq $box) { return }
        $start = $box.SelectionStart; $box.SelectAll()
        $box.SelectionBackColor = $box.BackColor
        $box.SelectionColor = if($global:isDarkMode){[System.Drawing.Color]::White}else{[System.Drawing.Color]::Black}
        if ($query.Length -ge 3) {
            $p = 0
            while (($p = $box.Find($query, $p, [System.Windows.Forms.RichTextBoxFinds]::None)) -ge 0) {
                $box.SelectionBackColor = $global:highlightColor; $box.SelectionColor = [System.Drawing.Color]::Black; $p += $query.Length
            }
        }
        $box.Select($start, 0); $box.SelectionBackColor = $box.BackColor
    })
    $pnlSearch.Controls.AddRange(@($lblSearch, $detSearchBox)); $detachForm.Controls.AddRange(@($detachBox, $pnlSearch))
    $detachBox.Text = $logBox.Text; $detachBox.SelectionStart = $detachBox.Text.Length; $detachBox.ScrollToCaret()
    $detachForm.Show()
}

function Set-Theme {
    $darkGray = [System.Drawing.Color]::FromArgb(87, 87, 87)
    $softWhite = [System.Drawing.Color]::FromArgb(240, 240, 240)
    if ($global:isDarkMode) {
        $form.BackColor = $darkGray; $btnPanel.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
        $cmdBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45); $cmdBox.ForeColor = $softWhite
        $logBox.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 35); $logBox.ForeColor = $softWhite
        $hintList.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50); $hintList.ForeColor = $softWhite
        $hintSearch.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70); $hintSearch.ForeColor = $softWhite
        $searchBox.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70); $searchBox.ForeColor = $softWhite
        $chkLogSearch.ForeColor = $softWhite; $chkHighlight.ForeColor = $softWhite
    } else {
        $form.BackColor = [System.Drawing.Color]::WhiteSmoke; $btnPanel.BackColor = [System.Drawing.Color]::WhiteSmoke
        $cmdBox.BackColor = [System.Drawing.Color]::FromArgb(255, 251, 230); $cmdBox.ForeColor = [System.Drawing.Color]::Black
        $logBox.BackColor = [System.Drawing.Color]::FromArgb(232, 245, 233); $logBox.ForeColor = [System.Drawing.Color]::Black
        $hintList.BackColor = [System.Drawing.Color]::White; $hintList.ForeColor = [System.Drawing.Color]::Black
        $hintSearch.BackColor = [System.Drawing.Color]::FromArgb(232, 244, 220); $hintSearch.ForeColor = [System.Drawing.Color]::Black
        $searchBox.BackColor = [System.Drawing.Color]::White; $searchBox.ForeColor = [System.Drawing.Color]::Black
        $chkLogSearch.ForeColor = [System.Drawing.Color]::Black; $chkHighlight.ForeColor = [System.Drawing.Color]::Black
    }
}

function Show-QuasHelp {
    $hForm = New-Object System.Windows.Forms.Form -Property @{
        Text = "Quas GUI Shell v4.8.2 | User Manual & Reference"; 
        Size = "850,950"; 
        StartPosition = "CenterParent"; 
        BackColor = "White";
        MinimizeBox = $false;
        MaximizeBox = $false
    }
    
    $hText = New-Object System.Windows.Forms.RichTextBox -Property @{
        Dock = "Fill"; ReadOnly = $true; Font = New-Object System.Drawing.Font("Segoe UI", 10); 
        Padding = New-Object System.Windows.Forms.Padding(20); BorderStyle = "None"; BackColor = "White"
    }

    # ASCII-safe bullet point
    $dot = "-" 

    function Add-HSection($title, $body) {
        $hText.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $hText.SelectionColor = [System.Drawing.Color]::DarkSlateBlue
        $hText.AppendText("`n" + $title + "`n")
        $hText.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 10)
        $hText.SelectionColor = [System.Drawing.Color]::Black
        $hText.AppendText($body + "`n")
    }

    $hText.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Center
    $hText.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $hText.SelectionColor = [System.Drawing.Color]::MidnightBlue
    $hText.AppendText("Quas GUI Shell v4.8.2`n")
    $hText.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9)
    $hText.AppendText("Advanced ADB & Command Interface Manager`n")
    $hText.AppendText("___________________________________________________________`n")
    $hText.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Left

    Add-HSection "1. EDITOR & EXECUTION" "- [Run (F5)]: Executes commands from the editor line by line.`n$dot [STOP]: Emergency termination of the execution queue.`n$dot [Clear Code]: Wipes the editor. Use the [U] button to Undo accidental deletion."

    Add-HSection "2. SMART INTERCEPTOR (AUTO-REDIRECT)" "The system automatically detects 'heavy' or interactive commands to prevent GUI freezing:`n$dot Shells: cmd, powershell, adb shell, ftp, etc.`n$dot Streams: adb shell top, ping -t, logcat (without -d), watch, monitor.`n$dot Action: Quas redirects these to an external console for real-time interaction."

    Add-HSection "3. LOG MANAGEMENT" "- [Detach Log]: Opens the log in an expanded window with INDEPENDENT search.`n$dot [Clear Log]: Clears the output window. Use the [U] button to restore deleted logs.`n$dot [Save Log]: Exports the entire log history to a .txt file."

    Add-HSection "4. SEARCH & SOFT VISION" "$dot [Log Search]: Enables the search panel. Minimum 3 characters required.`n$dot [Highlight]: Uses 'Soft Vision' (gentle yellow tint) for eye-friendly results.`n$dot [Deep Sync]: Extracts all lines containing your search query into Notepad for deep analysis."

    Add-HSection "5. SHORTCUTS & INTERACTION" "$dot [F5]: Run current script.`n$dot [Ctrl + A]: Select all text in the editor window.`n$dot [Double-Click Hint]: Quickly inserts a command from the Hints panel into the editor."

    Add-HSection "6. CUSTOMIZATION" "$dot [Theme]: Toggles between Light and Dark visual modes.`n$dot [Hints On/Off]: Shows or hides the sidebar containing your hints.txt data."

    $hText.AppendText("`n___________________________________________________________`n")
    $hText.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Center
    $hText.AppendText("`nCreated by Varset & Gemini Dev | 2026")

    $hForm.Controls.Add($hText)
    $null = $hForm.ShowDialog()
}


$runAction = {
    $global:isStopping = $false
    $shells = @("cmd", "powershell", "pwsh", "nslookup", "python", "node", "ssh", "telnet", "diskpart", "scrcpy", "ftp")
    
    foreach ($line in $cmdBox.Lines) {
        $trimmed = $line.Trim(); $cleanLine = $trimmed.ToLower()
        if ($global:isStopping -or [string]::IsNullOrWhiteSpace($cleanLine)) { continue }

        $finalCmd = $trimmed 
        $needsRedirect = $false
        
        foreach ($sh in $shells) {
            if ($cleanLine -eq $sh -or $cleanLine.StartsWith("$sh ")) {
                $needsRedirect = $true; break
            }
        }
        
        if (-not $needsRedirect -and $cleanLine.StartsWith("adb")) {
            if ($cleanLine -eq "adb shell" -or ($cleanLine -match "top|ping -t|watch |monitor")) { $needsRedirect = $true }
            elseif ($cleanLine -match "logcat" -and -not $cleanLine.Contains("-d")) { $needsRedirect = $true }
        }

        if ($needsRedirect) {
            $logBox.SelectionColor = [System.Drawing.Color]::Orange
            $logBox.AppendText("`n[REDIRECT] External console mode: '$trimmed'`n")
            $proc = if ($cleanLine -match "powershell|pwsh") { "powershell.exe" } else { "cmd.exe" }
            $waitFlag = if ($cleanLine.StartsWith("scrcpy") -or $cleanLine.StartsWith("adb")) { "/c" } else { "/k" }
            $args = if ($proc -eq "powershell.exe") { "-NoExit", "-Command", "& { $finalCmd }" } else { "$waitFlag $finalCmd" }
            Start-Process $proc -ArgumentList $args
            continue 
        }

# --- 3. EXECUTION IN LOGBOX (GOLDEN 4.8.2) ---
        $logBox.SelectionColor = if($global:isDarkMode){[System.Drawing.Color]::Cyan}else{[System.Drawing.Color]::Blue}
        $logBox.AppendText("`n> $line`n")
        
        # ИНДИКАЦИЯ: ВКЛЮЧАЕМ BUSY
        $btnStop.Text = "BUSY"
        $btnStop.BackColor = [System.Drawing.Color]::DeepSkyBlue
        $btnRun.Enabled = $false
        [System.Windows.Forms.Application]::DoEvents()

        try {
            # Создаем startInfo непосредственно перед запуском
            $cmdStartInfo = New-Object System.Diagnostics.ProcessStartInfo
            $cmdStartInfo.FileName = "cmd.exe"
            $cmdStartInfo.Arguments = "/c $finalCmd"
            $cmdStartInfo.RedirectStandardOutput = $true
            $cmdStartInfo.RedirectStandardError = $true
            $cmdStartInfo.UseShellExecute = $false
            $cmdStartInfo.CreateNoWindow = $true
            $cmdStartInfo.StandardOutputEncoding = [System.Text.Encoding]::GetEncoding(866)

            # ЗАПУСК
            $p = [System.Diagnostics.Process]::Start($cmdStartInfo)
            $targetId = $p.Id 

            # ВНЕШНИЙ КИЛЛЕР (Сторож на 20 секунд)
            $killerCmd = "Start-Sleep -Seconds 20; taskkill /F /PID $targetId /T"
            $killer = Start-Process "powershell.exe" -ArgumentList "-NoProfile -WindowStyle Hidden -Command `"$killerCmd`"" -PassThru -WindowStyle Hidden

            # ПУШЕЧНОЕ ЧТЕНИЕ (ReadToEnd)
            $out = $p.StandardOutput.ReadToEnd()
            $err = $p.StandardError.ReadToEnd()
            $p.WaitForExit()

            if ($killer -and -not $killer.HasExited) { 
                Stop-Process -Id $killer.Id -Force -ErrorAction SilentlyContinue 
            }

            # ВЫВОД В ЛОГ
            if ($out) { 
                $logBox.SelectionColor = if($global:isDarkMode){[System.Drawing.Color]::White}else{[System.Drawing.Color]::Black}
                $logBox.AppendText($out) 
            }
            if ($err) { 
                $logBox.SelectionColor = [System.Drawing.Color]::Red
                $logBox.AppendText($err) 
            }


# ОБРАБОТКА ТАЙМАУТА (Улучшенная версия)
            # Если код выхода не 0 (процесс убит или упал)
            if ($p.ExitCode -ne 0) {
                # Если вывода совсем нет ИЛИ там только приглашение интерактивной среды
                if (-not $out -or $out.Trim() -eq "ftp>") {
                    $logBox.SelectionColor = [System.Drawing.Color]::Orange
                    $logBox.AppendText("`n[TIMEOUT] Process $targetId was terminated after 20s.`n")
                    $logBox.SelectionColor = [System.Drawing.Color]::Gray
                    $logBox.AppendText("ADVICE: This command is interactive. Please run it in a real CMD/PowerShell.`n")
                }
            }


        } catch { 
            $logBox.SelectionColor = [System.Drawing.Color]::Red
            $logBox.AppendText("`nError: $($_.Exception.Message)") 
        } finally {
            # ИНДИКАЦИЯ: ВЫКЛЮЧАЕМ
            $btnStop.Text = "STOP"
            $btnStop.BackColor = [System.Drawing.Color]::LightPink
            $btnRun.Enabled = $true
            $logBox.ScrollToCaret()
            [System.Windows.Forms.Application]::DoEvents()
        }
    }
}

# --- 4. UI CREATION ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Quas GUI Shell v4.8.2"; $form.Size = "1300,950"; $form.StartPosition = "CenterScreen"; $form.KeyPreview = $true
$mainSplit = New-Object System.Windows.Forms.SplitContainer -Property @{Dock="Fill"; Orientation="Horizontal"; SplitterDistance=350}
$topSplit = New-Object System.Windows.Forms.SplitContainer -Property @{Dock="Fill"; Orientation="Vertical"; FixedPanel="Panel2"}
$cmdBox = New-Object System.Windows.Forms.TextBox -Property @{Multiline=$true; Dock="Fill"; ScrollBars="Vertical"; Font=$font; BackColor=[System.Drawing.Color]::FromArgb(255, 251, 230)}
$logBox = New-Object System.Windows.Forms.RichTextBox -Property @{Dock="Fill"; ReadOnly=$true; Font=$font; BackColor=[System.Drawing.Color]::FromArgb(232, 245, 233)}
$hintSearch = New-Object System.Windows.Forms.TextBox -Property @{Dock="Top"; Font=$uiFont; BackColor=[System.Drawing.Color]::FromArgb(232, 244, 220)}
$hintList = New-Object System.Windows.Forms.ListBox -Property @{Dock="Fill"; Font=New-Object System.Drawing.Font("Segoe UI", 10)}
if ($global:allHints) { [void]$hintList.Items.AddRange($global:allHints) }
$topSplit.Panel1.Controls.Add($cmdBox); $topSplit.Panel2.Controls.AddRange(@($hintList, $hintSearch))
$mainSplit.Panel1.Controls.Add($topSplit); $mainSplit.Panel2.Controls.Add($logBox); $form.Controls.Add($mainSplit)

# --- 5. BUTTONS ---
$btnPanel = New-Object System.Windows.Forms.Panel -Property @{Dock="Bottom"; Height=95; BackColor=[System.Drawing.Color]::WhiteSmoke}
function Create-Btn($txt, $x, $y, $w=85, $clr="Control") {
    $b = New-Object System.Windows.Forms.Button -Property @{ Text=$txt; Left=$x; Top=$y; Width=$w; Height=30; FlatStyle="Flat"; BackColor=[System.Drawing.Color]::$clr }; return $b
}
$btnRun = Create-Btn "Run (F5)" 10 10 95 "LightGreen"
$btnStop = Create-Btn "STOP" 110 10 70 "LightPink"
$btnPaste = Create-Btn "Paste" 210 10 70 "White"
$btnClearCmd = Create-Btn "Clear Code" 285 10 90 "White"
$btnUndoCmd = Create-Btn "U" 375 10 30 "LightGray"
$btnCopyLog = Create-Btn "Copy Log" 440 10 85 "Lavender"
$btnSave = Create-Btn "Save Log" 530 10 85 "Lavender"
$btnDetach = Create-Btn "Detach Log" 620 10 85 "Lavender"
$btnClearLog = Create-Btn "Clear Log" 740 10 85 "Lavender"
$btnUndoLog = Create-Btn "U" 825 10 30 "LightGray"
$chkLogSearch = New-Object System.Windows.Forms.CheckBox -Property @{Text="Log Search"; Left=875; Top=12; Width=90}
$btnHintsToggle = Create-Btn "Hints On/Off" 980 10 100 "Azure"
$btnTheme = Create-Btn "Theme" 1085 10 75 "DarkGray"
$btnHelp = Create-Btn "?" 0 10 35 "LightBlue"; $btnHelp.Anchor = "Right"
$searchBox = New-Object System.Windows.Forms.TextBox -Property @{Left=10; Top=55; Width=300; Visible=$false}
$chkHighlight = New-Object System.Windows.Forms.CheckBox -Property @{Text="Highlight"; Left=320; Top=52; Width=85; Visible=$false; Checked=$true}
$btnDeep = Create-Btn "Deep Sync (Notepad)" 410 50 160 "Beige"; $btnDeep.Visible=$false
$btnPanel.Controls.AddRange(@($btnRun,$btnStop,$btnPaste,$btnClearCmd,$btnUndoCmd,$btnCopyLog,$btnSave,$btnDetach,$btnClearLog,$btnUndoLog,$chkLogSearch,$btnHintsToggle,$btnTheme,$btnHelp,$searchBox,$chkHighlight,$btnDeep))
$form.Controls.Add($btnPanel)

# --- 6. EVENTS ---
$btnRun.Add_Click($runAction); $btnStop.Add_Click({ $global:isStopping = $true })
$btnPaste.Add_Click({ $cmdBox.AppendText([System.Windows.Forms.Clipboard]::GetText()) })
$btnClearCmd.Add_Click({ if($cmdBox.Text){ $global:lastCodeBackup = $cmdBox.Text; $cmdBox.Clear() } })
$btnUndoCmd.Add_Click({ if($global:lastCodeBackup){ $cmdBox.Text = $global:lastCodeBackup } })
$btnClearLog.Add_Click({ if($logBox.Text){ $global:lastLogBackup = $logBox.Text; $logBox.Clear() } })
$btnUndoLog.Add_Click({ if($global:lastLogBackup){ $logBox.AppendText($global:lastLogBackup) } })
$btnCopyLog.Add_Click({ if($logBox.Text){[System.Windows.Forms.Clipboard]::SetText($logBox.Text)} })

#$btnSave.Add_Click({ $sfd = New-Object System.Windows.Forms.SaveFileDialog -Property @{Filter="Text Files|*.txt"}; if($sfd.ShowDialog() -eq "OK"){ $logBox.Text | Out-File $sfd.FileName } })
$btnSave.Add_Click({ 
    $sfd = New-Object System.Windows.Forms.SaveFileDialog -Property @{
        Filter = "Text Files|*.txt"
        Title = "Save Quas Log"
    }
    if($sfd.ShowDialog() -eq "OK") { 
        # Принудительно задаем UTF8. 
        # Теперь любой Notepad++ или VS Code скажет тебе спасибо.
        $logBox.Text | Out-File -FilePath $sfd.FileName -Encoding utf8 
    } 
})
$btnDetach.Add_Click({ Show-LogDetached })
$btnTheme.Add_Click({ $global:isDarkMode = !$global:isDarkMode; Set-Theme })
$btnHintsToggle.Add_Click({ $topSplit.Panel2Collapsed = !$topSplit.Panel2Collapsed })
$btnHelp.Add_Click({ Show-QuasHelp })
$chkLogSearch.Add_CheckedChanged({ $searchBox.Visible = $chkHighlight.Visible = $btnDeep.Visible = $chkLogSearch.Checked })

$fnHighlight = {
    $start = $logBox.SelectionStart; $logBox.SelectAll(); $logBox.SelectionBackColor = $logBox.BackColor
    $logBox.SelectionColor = if($global:isDarkMode){[System.Drawing.Color]::White}else{[System.Drawing.Color]::Black}
    if ($chkHighlight.Checked -and $searchBox.Text.Length -ge 3) {
        $find = $searchBox.Text; $p = 0
        while (($p = $logBox.Find($find, $p, [System.Windows.Forms.RichTextBoxFinds]::None)) -ge 0) {
            $logBox.SelectionBackColor = $global:highlightColor; $logBox.SelectionColor = [System.Drawing.Color]::Black; $p += $find.Length
        }
    }
    $logBox.Select($start, 0); $logBox.SelectionBackColor = $logBox.BackColor
}
$searchBox.Add_TextChanged($fnHighlight); $chkHighlight.Add_CheckedChanged($fnHighlight)

$btnDeep.Add_Click({
    $q = $searchBox.Text.ToLower(); if (!$q) { return }
    $res = $logBox.Text -split "`n" | Where-Object { $_.ToLower().Contains($q) }
    if ($res) { $tmp = [System.IO.Path]::GetTempFileName() + ".txt"; $res.Trim() | Out-File $tmp -Encoding utf8; Start-Process notepad.exe $tmp }
})
$hintSearch.Add_TextChanged({ $fStr = $hintSearch.Text.ToLower(); $hintList.Items.Clear(); foreach ($h in $global:allHints) { if ($h.ToLower().Contains($fStr)) { [void]$hintList.Items.Add($h) } } })
$hintList.Add_DoubleClick({ if ($hintList.SelectedItem) { $cmdBox.AppendText($hintList.SelectedItem.ToString() + "`r`n") } })
$form.Add_KeyDown({ param($s,$e) if($e.KeyCode -eq "F5") { &$runAction }; if($e.Control -and $e.KeyCode -eq "A") { $cmdBox.SelectAll() } })
$form.Add_Load({ $topSplit.SplitterDistance = $form.ClientSize.Width - 350; $btnHelp.Left = $btnPanel.Width - 50 })
Set-Theme
$null = $form.ShowDialog(); $form.Dispose()