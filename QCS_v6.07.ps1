param (
    [string]$ToolsPath = "",
    [string]$Lang      = "RU"   # EN or RU
)

# --- Path Processing ---
if ($ToolsPath) {
    $cleanPath = $ToolsPath.Replace('"', '').TrimEnd('\')
    $env:PATH  = "$cleanPath;" + $env:PATH
    $script:tPath = $cleanPath + "\"
} else {
    $script:tPath = ""
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------------------------------------------------------------------------
# LANGUAGE SETUP
# ---------------------------------------------------------------------------
$script:Lang = $Lang.ToUpper()
if ($script:Lang -ne "RU") { $script:Lang = "EN" }

$script:T = if ($script:Lang -eq "RU") { @{
    AppTitle        = "Quas Command Shell v6.07"
    TabNew          = "Вкладка"
    RenameTab       = "Переименовать вкладку"
    RenamePrompt    = "Новое имя вкладки:"
    LogDetachTitle  = "Quas Command Shell - Лог:"
    LogExpandTitle  = "Quas Command Shell - Расширенный лог (поиск)"
    SearchLog       = "Поиск в логе:"
    RunAt           = "--- Запуск в"
    Redirect        = "[ПЕРЕНАПРАВЛЕНИЕ] Внешняя консоль:"
    Timeout         = "[ТАЙМАУТ] Процесс завершён после 20 сек."
    TimeoutAdvice   = "СОВЕТ: Команда интерактивная. Запустите в реальной консоли CMD/PowerShell."
    BusyText        = "ЗАНЯТО"
    StopText        = "СТОП"
    ErrorPrefix     = "Ошибка:"
    HintsReloaded   = "[Хинты перезагружены:"
    HintsNotFound   = "[Хинты не найдены: hints.txt не обнаружен]"
    NoDesc          = "Описание отсутствует. Добавьте после ## в hints.txt"
    StatusPrefix    = "Вкладка:"
    StatusLines     = "Строк:"
    BtnRun          = "Запуск (F5)"
    BtnStop         = "СТОП"
    BtnPaste        = "Вставить"
    BtnClearCode    = "Очистить код"
    BtnCopyLog      = "Копировать лог"
    BtnSaveLog      = "Сохранить лог"
    BtnDetachLog    = "Открыть лог"
    BtnClearLog     = "Очистить лог"
    BtnHints        = "Хинты"
    BtnTheme        = "Тема"
    BtnExpandAll    = "+ Развернуть"
    BtnCollapseAll  = "- Свернуть"
    BtnReload       = "Обновить"
    LblLogSearch    = "Поиск в логе:"
    ChkHighlight    = "Подсветка"
    ChkTimestamps   = "Метки времени"
    BtnExtract      = "Извлечь в блокнот"
    SaveLogTitle    = "Сохранить лог Quas"
    DangerTooltip   = "[ОПАСНО]"
    CautionTooltip  = "[ОСТОРОЖНО]"
    HintCmdCount    = "команд"
} } else { @{
    AppTitle        = "Quas Command Shell v6.07"
    TabNew          = "Tab"
    RenameTab       = "Rename Tab"
    RenamePrompt    = "New tab name:"
    LogDetachTitle  = "Quas Command Shell - Log:"
    LogExpandTitle  = "Quas Command Shell - Expanded Log (Searchable)"
    SearchLog       = "Search Log:"
    RunAt           = "--- Run at"
    Redirect        = "[REDIRECT] External console:"
    Timeout         = "[TIMEOUT] Process terminated after 20s."
    TimeoutAdvice   = "ADVICE: Interactive command - run in a real CMD/PowerShell."
    BusyText        = "BUSY"
    StopText        = "STOP"
    ErrorPrefix     = "Error:"
    HintsReloaded   = "[Hints reloaded:"
    HintsNotFound   = "[Hints reload failed: hints.txt not found]"
    NoDesc          = "No description. Add one after ## in hints.txt"
    StatusPrefix    = "Tab:"
    StatusLines     = "Lines:"
    BtnRun          = "Run (F5)"
    BtnStop         = "STOP"
    BtnPaste        = "Paste"
    BtnClearCode    = "Clear Code"
    BtnCopyLog      = "Copy Log"
    BtnSaveLog      = "Save Log"
    BtnDetachLog    = "Detach Log"
    BtnClearLog     = "Clear Log"
    BtnHints        = "Hints On/Off"
    BtnTheme        = "Theme"
    BtnExpandAll    = "+ Expand"
    BtnCollapseAll  = "- Collapse"
    BtnReload       = "Reload"
    LblLogSearch    = "Log Search:"
    ChkHighlight    = "Highlight"
    ChkTimestamps   = "Timestamps"
    BtnExtract      = "Extract to Notepad"
    SaveLogTitle    = "Save Quas Log"
    DangerTooltip   = "[DANGER]"
    CautionTooltip  = "[CAUTION]"
    HintCmdCount    = "commands"
}}

$script:isStopping     = $false
$script:isDarkMode     = $true
$script:lastCodeBackup = ""
$script:lastLogBackup  = ""
$script:highlightColor = [System.Drawing.Color]::FromArgb(255, 255, 180)
$script:showTimestamps = $true
$script:tabs           = [System.Collections.Generic.List[hashtable]]::new()
$script:activeTabIdx   = 0
$script:lastTabClickTime = [System.DateTime]::MinValue
$script:lastTabClickIdx  = -1

# ---------------------------------------------------------------------------
# 1. HINTS LOADING
# ---------------------------------------------------------------------------
# Capture script directory at root scope - works for both .ps1 and ps2exe EXE
# $PSScriptRoot is reliable here at the script root level (not inside a function)
$script:scriptDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($script:scriptDir)) {
    try { $script:scriptDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path) } catch {}
}
if ([string]::IsNullOrEmpty($script:scriptDir)) {
    try {
        $exe = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
        if ($exe -match "\.exe$") { $script:scriptDir = [System.IO.Path]::GetDirectoryName($exe) }
    } catch {}
}
if ([string]::IsNullOrEmpty($script:scriptDir)) {
    $script:scriptDir = [System.IO.Directory]::GetCurrentDirectory()
}

function Find-HintsFile {
    $candidates = @()
    if ($script:tPath)       { $candidates += Join-Path $script:tPath "hints.txt" }
    if ($script:scriptDir)   { $candidates += Join-Path $script:scriptDir "hints.txt" }
    if ($script:scriptDir)   { $candidates += Join-Path $script:scriptDir "Source\hints.txt" }
    if ($env:myfiles)        { $candidates += Join-Path $env:myfiles "hints.txt" }
    foreach ($c in $candidates) {
        if (-not [string]::IsNullOrEmpty($c) -and (Test-Path $c)) { return $c }
    }
    return $null
}
$hintsFile = Find-HintsFile

function Parse-HintsFile($path) {
    $cats    = [System.Collections.Specialized.OrderedDictionary]::new()
    $current = "General"
    $cats[$current] = [System.Collections.Generic.List[string]]::new()
    if ([string]::IsNullOrEmpty($path) -or -not (Test-Path $path)) { return $cats }
    foreach ($line in (Get-Content $path)) {
        if ($line -match '^\[(.+)\]') {
            $current = $Matches[1].Trim()
            if (-not $cats.Contains($current)) { $cats[$current] = [System.Collections.Generic.List[string]]::new() }
            continue
        }
        if ($line -match '^#\s*[-=]{3,}\s*(.+?)\s*[-=]{3,}\s*$') {
            $current = $Matches[1].Trim()
            if (-not $cats.Contains($current)) { $cats[$current] = [System.Collections.Generic.List[string]]::new() }
            continue
        }
        if ([string]::IsNullOrWhiteSpace($line) -or $line.TrimStart().StartsWith('#')) { continue }
        if (-not $cats.Contains($current)) { $cats[$current] = [System.Collections.Generic.List[string]]::new() }
        # Store raw line as-is (may contain ## description)
        $cats[$current].Add($line.Trim())
    }
    $emptyKeys = @($cats.Keys | Where-Object { $cats[$_].Count -eq 0 })
    foreach ($k in $emptyKeys) { $cats.Remove($k) }
    return $cats
}
$script:hintCategories = Parse-HintsFile $hintsFile

# ---------------------------------------------------------------------------
# 2. FONTS & COLORS
# ---------------------------------------------------------------------------
$font     = New-Object System.Drawing.Font("Consolas", 11)
$uiFont   = New-Object System.Drawing.Font("Segoe UI", 10)
$boldFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$script:catColors = @(
    [System.Drawing.Color]::FromArgb(100,180,255),
    [System.Drawing.Color]::FromArgb(100,220,180),
    [System.Drawing.Color]::FromArgb(255,180, 80),
    [System.Drawing.Color]::FromArgb(220,120,120),
    [System.Drawing.Color]::FromArgb(160,210,100),
    [System.Drawing.Color]::FromArgb(190,150,255),
    [System.Drawing.Color]::FromArgb(255,220,100),
    [System.Drawing.Color]::FromArgb(130,200,230),
    [System.Drawing.Color]::FromArgb(200,170,130)
)

# ---------------------------------------------------------------------------
# 3. TREEVIEW
# ---------------------------------------------------------------------------
# Hint line prefixes (stripped before display and insert):
#   !cmd  -> red    (dangerous: deletes data, irreversible)
#   ~cmd  -> yellow (caution: changes settings/state)
#   cmd   -> normal (safe/informational)
$script:hintColorDanger  = [System.Drawing.Color]::FromArgb(255, 90,  90)
$script:hintColorCaution = [System.Drawing.Color]::FromArgb(255, 210,  60)

function Get-HintParts($raw) {
    # Format: [!~]cmd ## EN desc. | Example: ex ##| RU desc.
    $sepIdx = $raw.IndexOf('##')
    $cmdRaw = if ($sepIdx -ge 0) { $raw.Substring(0, $sepIdx).Trim() } else { $raw.Trim() }
    $rest   = if ($sepIdx -ge 0) { $raw.Substring($sepIdx + 2).Trim() } else { "" }

    # Split EN and RU parts on ##|
    $ruSep  = $rest.IndexOf('##|')
    $desc   = if ($ruSep -ge 0) { $rest.Substring(0, $ruSep).Trim() } else { $rest.Trim() }
    $descRU = if ($ruSep -ge 0) { $rest.Substring($ruSep + 3).Trim() } else { "" }

    if ($cmdRaw.StartsWith('!')) {
        return @{ Cmd=$cmdRaw.Substring(1).TrimStart(); Desc=$desc; DescRU=$descRU; Color=$script:hintColorDanger;  Prefix="!" }
    } elseif ($cmdRaw.StartsWith('~')) {
        return @{ Cmd=$cmdRaw.Substring(1).TrimStart(); Desc=$desc; DescRU=$descRU; Color=$script:hintColorCaution; Prefix="~" }
    } else {
        return @{ Cmd=$cmdRaw; Desc=$desc; DescRU=$descRU; Color=$null; Prefix="" }
    }
}

function Populate-HintTree($tree, $filterText) {
    $tree.BeginUpdate(); $tree.Nodes.Clear()
    $q = $filterText.ToLower(); $ci = 0
    foreach ($catKey in $script:hintCategories.Keys) {
        $items    = $script:hintCategories[$catKey]
        $filtered = if ($q) {
            @($items | Where-Object {
                $hp = Get-HintParts $_
                $desc = if ($script:Lang -eq "RU") { $hp.DescRU } else { $hp.Desc }
                $hp.Cmd.ToLower().Contains($q) -or $desc.ToLower().Contains($q)
            })
        } else { @($items) }
        if ($filtered.Count -eq 0) { continue }

        $catColor = $script:catColors[$ci % $script:catColors.Count]; $ci++
        $cn = New-Object System.Windows.Forms.TreeNode
        $cn.Text = $catKey; $cn.ToolTipText = "$($filtered.Count) $($script:T.HintCmdCount)"
        $cn.Tag = $null; $cn.ForeColor = $catColor; $cn.NodeFont = $boldFont

        foreach ($raw in $filtered) {
            $parts = Get-HintParts $raw
            $nd = New-Object System.Windows.Forms.TreeNode
            $nd.Text = $parts.Cmd
            # Tag stores hashtable with Cmd and Desc for the description panel
            $activeDesc = if ($script:Lang -eq "RU" -and $parts.DescRU) { $parts.DescRU } else { $parts.Desc }
            $nd.Tag  = @{ Cmd=$parts.Cmd; Desc=$parts.Desc; DescRU=$parts.DescRU; Prefix=$parts.Prefix }
            $nd.ToolTipText = switch ($parts.Prefix) {
                "!" { "$($script:T.DangerTooltip) $($parts.Cmd)" }
                "~" { "$($script:T.CautionTooltip) $($parts.Cmd)" }
                default { if ($activeDesc) { $activeDesc } else { $parts.Cmd } }
            }
            if ($null -ne $parts.Color) { $nd.ForeColor = $parts.Color }
            [void]$cn.Nodes.Add($nd)
        }
        [void]$tree.Nodes.Add($cn)
        if ($q) { $cn.Expand() } else { $cn.Collapse() }
    }
    $tree.EndUpdate()
}

# ---------------------------------------------------------------------------
# 4. TAB HELPERS
# ---------------------------------------------------------------------------
function Get-ActiveTab {
    if ($script:tabs.Count -eq 0) { return $null }
    return $script:tabs[$script:activeTabIdx]
}
function Get-ActiveCmdBox { $t = Get-ActiveTab; if ($t) { return $t.CmdBox } else { return $null } }
function Get-ActiveLogBox { $t = Get-ActiveTab; if ($t) { return $t.LogBox } else { return $null } }

function New-TabData($name) {
    $cb = New-Object System.Windows.Forms.RichTextBox -Property @{
        Dock="Fill"; Font=$font; ScrollBars="Vertical"
        BackColor=[System.Drawing.Color]::FromArgb(45,45,45)
        ForeColor=[System.Drawing.Color]::FromArgb(240,240,240)
        BorderStyle="None"; AcceptsTab=$true
    }
    $lb = New-Object System.Windows.Forms.RichTextBox -Property @{
        Dock="Fill"; ReadOnly=$true; Font=$font
        BackColor=[System.Drawing.Color]::FromArgb(35,35,35)
        ForeColor=[System.Drawing.Color]::FromArgb(240,240,240)
        BorderStyle="None"
    }
    return @{ Name=$name; CmdBox=$cb; LogBox=$lb }
}

function Update-StatusBar {
    $t = Get-ActiveTab
    if ($null -eq $t) { $script:statusLabel.Text = "---"; return }
    $lines = $t.CmdBox.Lines.Count
    $script:statusLabel.Text = "$($script:T.StatusPrefix) $($t.Name)   $($script:T.StatusLines) $lines"
}

# Build the tab strip from scratch each time
function Refresh-TabStrip {
    $script:tabStrip.SuspendLayout()
    $script:tabStrip.Controls.Clear()

    for ($i = 0; $i -lt $script:tabs.Count; $i++) {
        $idx      = $i
        $tab      = $script:tabs[$i]
        $isActive = ($i -eq $script:activeTabIdx)

        # Tab panel
        $pnl = New-Object System.Windows.Forms.Panel -Property @{
            Width=140; Height=30
            Margin=New-Object System.Windows.Forms.Padding(2,2,0,0)
            BackColor=if($isActive){[System.Drawing.Color]::FromArgb(65,65,65)}else{[System.Drawing.Color]::FromArgb(38,38,38)}
        }

        # Tab label
        $lbl = New-Object System.Windows.Forms.Label -Property @{
            Text=$tab.Name; Left=6; Top=6; Width=104; Height=18
            ForeColor=if($isActive){[System.Drawing.Color]::White}else{[System.Drawing.Color]::FromArgb(150,150,150)}
            Font=if($isActive){$boldFont}else{$uiFont}
            Cursor="Hand"
        }
        $lbl.Tag = $idx

        # Close [x] label
        $xBtn = New-Object System.Windows.Forms.Label -Property @{
            Text="x"; Left=116; Top=6; Width=18; Height=18
            ForeColor=[System.Drawing.Color]::FromArgb(130,130,130)
            Font=$uiFont; TextAlign="MiddleCenter"; Cursor="Hand"
        }
        $xBtn.Tag = $idx

        # Active tab indicator line at bottom
        if ($isActive) {
            $bar = New-Object System.Windows.Forms.Panel -Property @{
                Left=0; Top=28; Width=140; Height=2
                BackColor=[System.Drawing.Color]::FromArgb(100,180,255)
            }
            $pnl.Controls.Add($bar)
        }

        # Events - click to switch, double-click to rename
        # We track last-click time in script scope because Refresh-TabStrip
        # recreates all labels, so we cannot rely on WinForms e.Clicks counter
        $lbl.Add_MouseDown({
            param($s,$e)
            if ($e.Button -ne [System.Windows.Forms.MouseButtons]::Left) { return }
            $now   = [System.DateTime]::Now
            $tidx  = [int]$s.Tag
            $dblMs = [System.Windows.Forms.SystemInformation]::DoubleClickTime

            if ($script:lastTabClickIdx -eq $tidx -and
                ($now - $script:lastTabClickTime).TotalMilliseconds -le $dblMs) {
                # Double-click detected - rename
                $script:lastTabClickTime = [System.DateTime]::MinValue
                $script:lastTabClickIdx  = -1
                $dlg    = New-Object System.Windows.Forms.Form -Property @{
                    Text=$script:T.RenameTab; Size="300,112"; StartPosition="CenterParent"
                    FormBorderStyle="FixedDialog"; MinimizeBox=$false; MaximizeBox=$false
                    BackColor=[System.Drawing.Color]::FromArgb(40,40,50)
                }
                $dlgTxt = New-Object System.Windows.Forms.TextBox -Property @{
                    Left=10; Top=10; Width=264; Height=24; Font=$uiFont
                    BackColor=[System.Drawing.Color]::FromArgb(60,60,70)
                    ForeColor=[System.Drawing.Color]::White
                    Text=$script:tabs[$tidx].Name
                }
                $dlgOk  = New-Object System.Windows.Forms.Button -Property @{
                    Text="OK"; Left=10; Top=44; Width=80; Height=26
                    DialogResult="OK"; FlatStyle="Flat"
                    BackColor=[System.Drawing.Color]::FromArgb(50,90,50)
                    ForeColor=[System.Drawing.Color]::White
                }
                $dlgCx  = New-Object System.Windows.Forms.Button -Property @{
                    Text="Cancel"; Left=100; Top=44; Width=80; Height=26
                    DialogResult="Cancel"; FlatStyle="Flat"
                    BackColor=[System.Drawing.Color]::FromArgb(80,40,40)
                    ForeColor=[System.Drawing.Color]::White
                }
                $dlg.AcceptButton = $dlgOk; $dlg.CancelButton = $dlgCx
                $dlg.Controls.AddRange(@($dlgTxt,$dlgOk,$dlgCx))
                $dlgTxt.SelectAll()
                $inp = if ($dlg.ShowDialog($form) -eq "OK") { $dlgTxt.Text } else { "" }
                if ($inp -and $inp.Trim()) {
                    $script:tabs[$tidx].Name = $inp.Trim()
                    Refresh-TabStrip; Update-StatusBar
                }
            } else {
                # First click - record time and switch tab
                $script:lastTabClickTime = $now
                $script:lastTabClickIdx  = $tidx
                $script:activeTabIdx     = $tidx
                Switch-Tab
            }
        })
        # Events - close
        $xBtn.Add_Click({
            param($s,$e)
            if ($script:tabs.Count -le 1) { return }
            $tidx = [int]$s.Tag
            $script:tabs.RemoveAt($tidx)
            if ($script:activeTabIdx -ge $script:tabs.Count) { $script:activeTabIdx = $script:tabs.Count - 1 }
            Switch-Tab
        })
        $xBtn.Add_MouseEnter({ $this.ForeColor = [System.Drawing.Color]::FromArgb(255,90,90) })
        $xBtn.Add_MouseLeave({ $this.ForeColor = [System.Drawing.Color]::FromArgb(130,130,130) })

        $pnl.Controls.AddRange(@($lbl, $xBtn))
        [void]$script:tabStrip.Controls.Add($pnl)
    }

    # [+] new tab button
    $addBtn = New-Object System.Windows.Forms.Label -Property @{
        Text=" + "; Width=34; Height=30
        ForeColor=[System.Drawing.Color]::FromArgb(150,150,150)
        BackColor=[System.Drawing.Color]::FromArgb(38,38,38)
        Font=$boldFont; TextAlign="MiddleCenter"; Cursor="Hand"
        Margin=New-Object System.Windows.Forms.Padding(6,2,0,0)
    }
    $addBtn.Add_Click({
        $n = $script:tabs.Count + 1
        $script:tabs.Add((New-TabData "$($script:T.TabNew) $n"))
        $script:activeTabIdx = $script:tabs.Count - 1
        Switch-Tab
    })
    $addBtn.Add_MouseEnter({ $this.ForeColor = [System.Drawing.Color]::White })
    $addBtn.Add_MouseLeave({ $this.ForeColor = [System.Drawing.Color]::FromArgb(150,150,150) })
    [void]$script:tabStrip.Controls.Add($addBtn)

    $script:tabStrip.ResumeLayout()
}

function Switch-Tab {
    $t = Get-ActiveTab
    if ($null -eq $t) { return }
    $script:editorPanel.Controls.Clear()
    $script:logPanel.Controls.Clear()
    $script:editorPanel.Controls.Add($t.CmdBox)
    $script:logPanel.Controls.Add($t.LogBox)
    Refresh-TabStrip
    Update-StatusBar
    Apply-ThemeToTab $t
}

function Apply-ThemeToTab($t) {
    $sw = [System.Drawing.Color]::FromArgb(240,240,240)
    if ($script:isDarkMode) {
        $t.CmdBox.BackColor = [System.Drawing.Color]::FromArgb(45,45,45);  $t.CmdBox.ForeColor = $sw
        $t.LogBox.BackColor = [System.Drawing.Color]::FromArgb(35,35,35);  $t.LogBox.ForeColor = $sw
    } else {
        $t.CmdBox.BackColor = [System.Drawing.Color]::FromArgb(255,251,230); $t.CmdBox.ForeColor = [System.Drawing.Color]::Black
        $t.LogBox.BackColor = [System.Drawing.Color]::FromArgb(232,245,233); $t.LogBox.ForeColor = [System.Drawing.Color]::Black
    }
}

# ---------------------------------------------------------------------------
# 5. THEME
# ---------------------------------------------------------------------------
function Set-Theme {
    $sw = [System.Drawing.Color]::FromArgb(240,240,240)
    if ($script:isDarkMode) {
        $form.BackColor               = [System.Drawing.Color]::FromArgb(87,87,87)
        $btnPanel.BackColor           = [System.Drawing.Color]::FromArgb(60,60,60)
        $script:tabStripPanel.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
        $script:tabStrip.BackColor    = [System.Drawing.Color]::FromArgb(30,30,30)
        $hintTree.BackColor           = [System.Drawing.Color]::FromArgb(50,50,50)
        $hintTree.ForeColor           = $sw
        $hintTree.LineColor           = [System.Drawing.Color]::FromArgb(100,100,100)
        $hintDescBox.BackColor        = [System.Drawing.Color]::FromArgb(28,32,38)
        $hintDescBox.ForeColor        = [System.Drawing.Color]::FromArgb(180,180,180)
        $hintSearch.BackColor         = [System.Drawing.Color]::FromArgb(70,70,70); $hintSearch.ForeColor = $sw
        $searchBox.BackColor          = [System.Drawing.Color]::FromArgb(70,70,70); $searchBox.ForeColor  = $sw
        $lblLogSearch.ForeColor       = $sw
        $chkHighlight.ForeColor       = $sw
        $chkTimestamps.ForeColor      = $sw
        $hintToolbar.BackColor        = [System.Drawing.Color]::FromArgb(45,45,45)
        $btnExpandAll.BackColor       = [System.Drawing.Color]::FromArgb(60,60,60)
        $btnExpandAll.ForeColor       = [System.Drawing.Color]::FromArgb(200,200,200)
        $btnCollapseAll.BackColor     = [System.Drawing.Color]::FromArgb(50,50,50)
        $btnCollapseAll.ForeColor     = [System.Drawing.Color]::FromArgb(200,200,200)
        $btnReloadHints.BackColor     = [System.Drawing.Color]::FromArgb(45,65,45)
        $btnReloadHints.ForeColor     = [System.Drawing.Color]::FromArgb(160,220,160)
        $script:statusPanel.BackColor = [System.Drawing.Color]::FromArgb(28,28,28)
        $script:statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(140,140,140)
    } else {
        $form.BackColor               = [System.Drawing.Color]::WhiteSmoke
        $btnPanel.BackColor           = [System.Drawing.Color]::WhiteSmoke
        $script:tabStripPanel.BackColor = [System.Drawing.Color]::FromArgb(210,210,210)
        $script:tabStrip.BackColor    = [System.Drawing.Color]::FromArgb(210,210,210)
        $hintTree.BackColor           = [System.Drawing.Color]::White
        $hintTree.ForeColor           = [System.Drawing.Color]::Black
        $hintTree.LineColor           = [System.Drawing.Color]::Gray
        $hintDescBox.BackColor        = [System.Drawing.Color]::FromArgb(245,245,250)
        $hintDescBox.ForeColor        = [System.Drawing.Color]::FromArgb(50,50,60)
        $hintSearch.BackColor         = [System.Drawing.Color]::FromArgb(232,244,220); $hintSearch.ForeColor = [System.Drawing.Color]::Black
        $searchBox.BackColor          = [System.Drawing.Color]::White; $searchBox.ForeColor = [System.Drawing.Color]::Black
        $lblLogSearch.ForeColor       = [System.Drawing.Color]::Black
        $chkHighlight.ForeColor       = [System.Drawing.Color]::Black
        $chkTimestamps.ForeColor      = [System.Drawing.Color]::Black
        $hintToolbar.BackColor        = [System.Drawing.Color]::FromArgb(220,220,220)
        $btnExpandAll.BackColor       = [System.Drawing.Color]::FromArgb(230,230,230); $btnExpandAll.ForeColor   = [System.Drawing.Color]::Black
        $btnCollapseAll.BackColor     = [System.Drawing.Color]::FromArgb(210,210,210); $btnCollapseAll.ForeColor = [System.Drawing.Color]::Black
        $btnReloadHints.BackColor     = [System.Drawing.Color]::FromArgb(200,235,200); $btnReloadHints.ForeColor = [System.Drawing.Color]::FromArgb(0,100,0)
        $script:statusPanel.BackColor = [System.Drawing.Color]::FromArgb(220,220,220)
        $script:statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(80,80,80)
    }
    foreach ($t in $script:tabs) { Apply-ThemeToTab $t }
    Refresh-TabStrip
}

# ---------------------------------------------------------------------------
# 6. DETACH LOG
# ---------------------------------------------------------------------------
function Show-LogDetached {
    $lb = Get-ActiveLogBox; if ($null -eq $lb) { return }
    $tabName = (Get-ActiveTab).Name
    $df = New-Object System.Windows.Forms.Form -Property @{
        Text="$($script:T.LogDetachTitle) $tabName"; Size="1000,800"
        StartPosition="CenterScreen"; BackColor=$lb.BackColor
    }
    $ps  = New-Object System.Windows.Forms.Panel -Property @{ Dock="Top"; Height=45; BackColor=$btnPanel.BackColor }
    $lsl = New-Object System.Windows.Forms.Label -Property @{ Text=$script:T.SearchLog; Left=10; Top=14; Width=80; ForeColor=$lblLogSearch.ForeColor }
    $dsb = New-Object System.Windows.Forms.TextBox -Property @{ Left=95; Top=10; Width=350; Font=$uiFont; BackColor=$searchBox.BackColor; ForeColor=$searchBox.ForeColor }
    $dab = New-Object System.Windows.Forms.RichTextBox -Property @{ Dock="Fill"; ReadOnly=$true; BackColor=$lb.BackColor; ForeColor=$lb.ForeColor; Font=$font; BorderStyle="None" }
    $dsb.Tag = $dab
    $dsb.Add_TextChanged({
        $box=$this.Tag; $q=$this.Text; if($null -eq $box){return}
        $st=$box.SelectionStart
        # Reset BackColor only - do NOT touch SelectionColor/ForeColor
        $box.SelectAll()
        $box.SelectionBackColor=$box.BackColor
        if($q.Length -ge 3){
            $p=0
            while(($p=$box.Find($q,$p,[System.Windows.Forms.RichTextBoxFinds]::None)) -ge 0){
                $box.SelectionBackColor=$script:highlightColor
                $box.SelectionColor=[System.Drawing.Color]::Black
                $p+=$q.Length
            }
        }
        $box.Select($st,0); $box.SelectionBackColor=$box.BackColor
    })
    $ps.Controls.AddRange(@($lsl,$dsb)); $df.Controls.AddRange(@($dab,$ps))
    $dab.Text=$lb.Text; $dab.SelectionStart=$dab.Text.Length; $dab.ScrollToCaret()
    $df.Show()
}



# ---------------------------------------------------------------------------
# 7. HELP  (two-column compact layout)
# ---------------------------------------------------------------------------
function Show-QuasHelp {
    $hf = New-Object System.Windows.Forms.Form -Property @{
        Text="Quas Command Shell v6.07 | Quick Reference"
        Size="980,780"; StartPosition="CenterParent"
        BackColor=[System.Drawing.Color]::FromArgb(22,22,30)
        MinimizeBox=$false; MaximizeBox=$false
    }

    $fTitle = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Bold)
    $fSub   = New-Object System.Drawing.Font("Segoe UI",  9)
    $fH1    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $fBody  = New-Object System.Drawing.Font("Segoe UI",  9)
    $fCode  = New-Object System.Drawing.Font("Consolas",  9)
    $fFooter= New-Object System.Drawing.Font("Segoe UI",  9, [System.Drawing.FontStyle]::Underline)

    $cBg    = [System.Drawing.Color]::FromArgb(22,22,30)
    $cTitle = [System.Drawing.Color]::FromArgb(130,190,255)
    $cH1    = [System.Drawing.Color]::FromArgb(100,220,180)
    $cKey   = [System.Drawing.Color]::FromArgb(190,150,255)
    $cBody  = [System.Drawing.Color]::FromArgb(200,200,200)
    $cCode  = [System.Drawing.Color]::FromArgb(255,220,100)
    $cGray  = [System.Drawing.Color]::FromArgb(120,120,130)
    $cLink  = [System.Drawing.Color]::FromArgb(100,180,255)
    $cDanger= [System.Drawing.Color]::FromArgb(255,90,90)
    $cWarn  = [System.Drawing.Color]::FromArgb(255,210,60)
    $cOk    = [System.Drawing.Color]::FromArgb(120,220,120)

    # Two-column table
    $tbl = New-Object System.Windows.Forms.TableLayoutPanel
    $tbl.Dock        = "Fill"
    $tbl.ColumnCount = 2
    $tbl.RowCount    = 3
    $tbl.Padding     = New-Object System.Windows.Forms.Padding(0)
    [void]$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent",50)))
    [void]$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent",50)))
    [void]$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute",72)))   # header
    [void]$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Percent",100)))   # columns
    [void]$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute",30)))   # footer

    # Header spans both columns
    $hdrPanel = New-Object System.Windows.Forms.Panel
    $hdrPanel.Dock      = "Fill"
    $hdrPanel.BackColor = $cBg
    $hdrLbl = New-Object System.Windows.Forms.RichTextBox
    $hdrLbl.Dock        = "Fill"
    $hdrLbl.ReadOnly    = $true
    $hdrLbl.BorderStyle = "None"
    $hdrLbl.BackColor   = $cBg
    $hdrLbl.SelectionAlignment = [System.Windows.Forms.HorizontalAlignment]::Center
    $hdrLbl.SelectionFont  = $fTitle
    $hdrLbl.SelectionColor = $cTitle
    $hdrLbl.AppendText("Quas Command Shell v6.07`n")
    $hdrLbl.SelectionFont  = $fSub
    $hdrLbl.SelectionColor = $cGray
    $hdrLbl.AppendText("Advanced ADB and Command Interface Manager")
    $hdrPanel.Controls.Add($hdrLbl)
    $tbl.SetColumnSpan($hdrPanel, 2)
    $tbl.Controls.Add($hdrPanel, 0, 0)

    # Helper to make one RichTextBox column
    function Make-Col {
        $rt = New-Object System.Windows.Forms.RichTextBox
        $rt.Dock        = "Fill"
        $rt.ReadOnly    = $true
        $rt.BorderStyle = "None"
        $rt.BackColor   = $cBg
        $rt.ForeColor   = $cBody
        $rt.Font        = $fBody
        $rt.ScrollBars  = "Vertical"
        $rt.Padding     = New-Object System.Windows.Forms.Padding(6,0,6,0)
        return $rt
    }

    $col1 = Make-Col
    $col2 = Make-Col
    $tbl.Controls.Add($col1, 0, 1)
    $tbl.Controls.Add($col2, 1, 1)

    # Footer with link
    $footPanel = New-Object System.Windows.Forms.Panel
    $footPanel.Dock      = "Fill"
    $footPanel.BackColor = [System.Drawing.Color]::FromArgb(16,16,22)
    $tbl.SetColumnSpan($footPanel, 2)
    $lnk = New-Object System.Windows.Forms.LinkLabel
    $lnk.Text      = "github.com/Varsett/QuasGUIshell  |  Full manual: README.md / README_RU.md"
    $lnk.Dock      = "Fill"
    $lnk.Font      = $fFooter
    $lnk.TextAlign = "MiddleCenter"
    $lnk.BackColor = [System.Drawing.Color]::FromArgb(16,16,22)
    $lnk.LinkColor = $cLink
    $lnk.Add_LinkClicked({ Start-Process "https://github.com/Varsett/QuasGUIshell" })
    $footPanel.Controls.Add($lnk)
    $tbl.Controls.Add($footPanel, 0, 2)

    $hf.Controls.Add($tbl)

    # Write helpers
    function wl($rt,$text,$font,$color) {
        $rt.SelectionFont=$font; $rt.SelectionColor=$color; $rt.AppendText($text+"`n")
    }
    function h1($rt,$text) { wl $rt $text $fH1 $cH1 }
    function b($rt,$key,$val) {
        $rt.SelectionFont=$fCode; $rt.SelectionColor=$cKey; $rt.AppendText("  "+$key)
        $rt.SelectionFont=$fBody; $rt.SelectionColor=$cBody; $rt.AppendText("  "+$val+"`n")
    }
    function code($rt,$text) { wl $rt ("  "+$text) $fCode $cCode }
    function sep($rt) { wl $rt "" $fBody $cGray }

    # -- LEFT COLUMN ----------------------------------------------------------
    if ($script:Lang -eq "RU") {
        h1 $col1 "ЗАПУСК"
        code $col1 "powershell -File QuasCommandShell.ps1"
        code $col1 "  -ToolsPath `"C:\ADB`""
        code $col1 "  -Lang RU  (или EN)"
        wl $col1 "  -ToolsPath: папка с adb.exe, добавляется в PATH." $fBody $cGray
        sep $col1

        h1 $col1 "ВКЛАДКИ"
        b $col1 "[+] / Ctrl+T"  "Новая вкладка"
        b $col1 "[x] / Ctrl+W"  "Закрыть вкладку (минимум 1)"
        b $col1 "Клик по имени" "Переключить вкладку"
        b $col1 "Двойной клик"  "Переименовать вкладку"
        b $col1 "Ctrl+Tab"      "Следующая вкладка"
        wl $col1 "  Каждая вкладка имеет собственный редактор и лог." $fBody $cGray
        sep $col1

        h1 $col1 "РЕДАКТОР"
        b $col1 "F5 / [Запуск]"   "Выполнить все строки сверху вниз"
        b $col1 "[СТОП]"          "Прервать после текущей команды"
        b $col1 "[Вставить]"      "Вставить буфер обмена в редактор"
        b $col1 "[Очистить] + [U]" "Очистить / восстановить редактор"
        b $col1 "Ctrl+A"          "Выделить всё в редакторе"
        wl $col1 "  Пустые строки пропускаются. Таймаут 20 сек." $fBody $cGray
        sep $col1

        h1 $col1 "УМНЫЙ ПЕРЕХВАТЧИК"
        wl $col1 "  Открывает внешнюю консоль для:" $fBody $cGray
        b $col1 "Оболочки"   "cmd, powershell, adb shell, ftp, ssh..."
        b $col1 "Потоки"     "logcat (без -d), top, ping -t, watch..."
        b $col1 "Тяжёлые"   "scrcpy, diskpart, telnet"
        wl $col1 "  В логе появляется [ПЕРЕНАПРАВЛЕНИЕ]." $fBody $cGray
        sep $col1

        h1 $col1 "ЛОГ"
        b $col1 "[Копировать лог]"  "Скопировать лог в буфер обмена"
        b $col1 "[Сохранить лог]"   "Экспорт в UTF-8 .txt"
        b $col1 "[Открыть лог]"     "Открыть в отдельном окне"
        b $col1 "[Очистить]+[U]"    "Очистить / восстановить лог"
        b $col1 "[Метки времени]"   "Включить/выключить HH:mm:ss"
        sep $col1
        wl $col1 "  Цвета лога:" $fBody $cGray
        $col1.SelectionFont=$fCode; $col1.SelectionColor=$cTitle;  $col1.AppendText("  Голубой"); $col1.SelectionFont=$fBody; $col1.SelectionColor=$cBody; $col1.AppendText("  эхо команды`n")
        $col1.SelectionFont=$fCode; $col1.SelectionColor=$cDanger; $col1.AppendText("  Красный"); $col1.SelectionFont=$fBody; $col1.SelectionColor=$cBody; $col1.AppendText("  stderr (ошибки)`n")
        $col1.SelectionFont=$fCode; $col1.SelectionColor=$cWarn;   $col1.AppendText("  Оранжевый"); $col1.SelectionFont=$fBody; $col1.SelectionColor=$cBody; $col1.AppendText(" [ПЕРЕНАПРАВЛЕНИЕ] [ТАЙМАУТ]`n")
        sep $col1

        h1 $col1 "ПОИСК В ЛОГЕ"
        b $col1 "Поле поиска"       "Всегда виден, от 3 символов"
        b $col1 "[Подсветка]"       "Жёлтая подсветка совпадений"
        b $col1 "[Извлечь в блокнот]" "Строки с совпадением в Блокнот"
        sep $col1
    } else {
        h1 $col1 "LAUNCH"
        code $col1 "powershell -File QuasCommandShell.ps1"
        code $col1 "  -ToolsPath `"C:\ADB`""
        code $col1 "  -Lang EN  (or RU)"
        wl $col1 "  -ToolsPath: folder with adb.exe, prepended to PATH." $fBody $cGray
        sep $col1

        h1 $col1 "TABS"
        b $col1 "[+] / Ctrl+T"  "New tab"
        b $col1 "[x] / Ctrl+W"  "Close tab (min 1 stays)"
        b $col1 "Click name"    "Switch tab"
        b $col1 "Dbl-click"     "Rename tab"
        b $col1 "Ctrl+Tab"      "Next tab"
        wl $col1 "  Each tab has its own editor and log." $fBody $cGray
        sep $col1

        h1 $col1 "EDITOR"
        b $col1 "F5 / [Run]"    "Execute all lines top to bottom"
        b $col1 "[STOP]"        "Abort after current command"
        b $col1 "[Paste]"       "Append clipboard to editor"
        b $col1 "[Clear] + [U]" "Clear / restore editor"
        b $col1 "Ctrl+A"        "Select all in editor"
        wl $col1 "  Blank lines skipped. 20s timeout per command." $fBody $cGray
        sep $col1

        h1 $col1 "SMART INTERCEPTOR"
        wl $col1 "  Opens external console for:" $fBody $cGray
        b $col1 "Shells"   "cmd, powershell, adb shell (bare), ftp, ssh..."
        b $col1 "Streams"  "logcat (no -d), top, ping -t, watch..."
        b $col1 "Heavy"    "scrcpy, diskpart, telnet"
        wl $col1 "  Shows [REDIRECT] in log when triggered." $fBody $cGray
        sep $col1

        h1 $col1 "LOG"
        b $col1 "[Copy Log]"   "Copy log to clipboard"
        b $col1 "[Save Log]"   "Export to UTF-8 .txt"
        b $col1 "[Detach Log]" "Open in separate window"
        b $col1 "[Clear]+[U]"  "Clear / restore log"
        b $col1 "[Timestamps]" "Toggle HH:mm:ss run header"
        sep $col1
        wl $col1 "  Log colors:" $fBody $cGray
        $col1.SelectionFont=$fCode; $col1.SelectionColor=$cTitle;  $col1.AppendText("  Cyan  "); $col1.SelectionFont=$fBody; $col1.SelectionColor=$cBody; $col1.AppendText("> command echo`n")
        $col1.SelectionFont=$fCode; $col1.SelectionColor=$cDanger; $col1.AppendText("  Red   "); $col1.SelectionFont=$fBody; $col1.SelectionColor=$cBody; $col1.AppendText("stderr errors`n")
        $col1.SelectionFont=$fCode; $col1.SelectionColor=$cWarn;   $col1.AppendText("  Orange"); $col1.SelectionFont=$fBody; $col1.SelectionColor=$cBody; $col1.AppendText(" [REDIRECT] [TIMEOUT]`n")
        sep $col1

        h1 $col1 "LOG SEARCH"
        b $col1 "Search box"           "Always visible, 3+ chars to highlight"
        b $col1 "[Highlight]"          "Toggle yellow soft-vision highlight"
        b $col1 "[Extract to Notepad]" "Pull matching lines to Notepad"
        sep $col1
    }

    # -- RIGHT COLUMN ---------------------------------------------------------
    if ($script:Lang -eq "RU") {
        h1 $col2 "ПАНЕЛЬ ХИНТОВ"
        b $col2 "Клик по категории" "Развернуть / свернуть"
        b $col2 "[+ Развернуть]"    "Развернуть все"
        b $col2 "[- Свернуть]"      "Свернуть все"
        b $col2 "[Обновить]"        "Перечитать hints.txt"
        b $col2 "Поле фильтра"      "Поиск по всем категориям"
        b $col2 "Двойной клик"      "Вставить команду в редактор"
        b $col2 "[Хинты]"           "Показать / скрыть панель хинтов"
        b $col2 "[D]"               "Панель описания команды"
        sep $col2

        h1 $col2 "ЦВЕТА ХИНТОВ"
        $col2.SelectionFont=$fCode; $col2.SelectionColor=$cDanger; $col2.AppendText("  ! префикс  ")
        $col2.SelectionFont=$fBody; $col2.SelectionColor=$cBody;   $col2.AppendText("ОПАСНО - необратимо`n")
        $col2.SelectionFont=$fCode; $col2.SelectionColor=$cWarn;   $col2.AppendText("  ~ префикс  ")
        $col2.SelectionFont=$fBody; $col2.SelectionColor=$cBody;   $col2.AppendText("ОСТОРОЖНО - меняет настройки`n")
        $col2.SelectionFont=$fCode; $col2.SelectionColor=$cOk;     $col2.AppendText("  нет префикса ")
        $col2.SelectionFont=$fBody; $col2.SelectionColor=$cBody;   $col2.AppendText("Безопасно / чтение`n")
        wl $col2 "  Префикс удаляется при вставке. Тултип при наведении." $fBody $cGray
        sep $col2

        h1 $col2 "ФОРМАТ HINTS.TXT"
        code $col2 "[ Название раздела ]"
        code $col2 "adb devices ## EN описание ##| RU описание"
        code $col2 "~adb shell setprop ... ## Меняет настройку"
        code $col2 "!adb shell rm -rf ... ## Удаляет файлы!"
        code $col2 "# комментарий - пропускается"
        wl $col2 "  Файл: рядом со скриптом или в подпапке Source\." $fBody $cGray
        sep $col2

        h1 $col2 "ГОРЯЧИЕ КЛАВИШИ"
        b $col2 "F5"        "Запустить"
        b $col2 "Ctrl+A"    "Выделить всё в редакторе"
        b $col2 "Ctrl+T"    "Новая вкладка"
        b $col2 "Ctrl+W"    "Закрыть вкладку"
        b $col2 "Ctrl+Tab"  "Следующая вкладка"
        sep $col2

        h1 $col2 "ТЕМА И КОМПОНОВКА"
        b $col2 "[Тема]"    "Тёмная / светлая тема"
        b $col2 "[Хинты]"   "Показать / скрыть панель хинтов"
        b $col2 "Гориз. разделитель" "Высота редактора и лога"
        b $col2 "Верт. разделитель"  "Ширина редактора и хинтов"
        sep $col2

        h1 $col2 "РЕШЕНИЕ ПРОБЛЕМ"
        b $col2 "adb не найден"      "Укажите -ToolsPath путь к adb.exe"
        b $col2 "GUI зависает"       "Команда нужна в перехватчике"
        b $col2 "[ТАЙМАУТ] 20 сек"   "Интерактивная - перехватчик откроет консоль"
        b $col2 "Хинты не обновились" "Нажмите [Обновить] после правки hints.txt"
        b $col2 "Кракозябры"         "CMD UTF-8 vs PS 5.1 CP1251 - известное ограничение"
        sep $col2
    } else {
        h1 $col2 "HINTS PANEL"
        b $col2 "Click category" "Expand / collapse"
        b $col2 "[+ Expand]"     "Expand all"
        b $col2 "[- Collapse]"   "Collapse all"
        b $col2 "[Reload]"       "Re-read hints.txt live"
        b $col2 "Filter box"     "Live search all categories"
        b $col2 "Dbl-click cmd"  "Insert into active editor"
        b $col2 "[Hints]"        "Show / hide sidebar"
        b $col2 "[D]"            "Toggle description panel in log area"
        sep $col2

        h1 $col2 "HINT COLORS"
        $col2.SelectionFont=$fCode; $col2.SelectionColor=$cDanger; $col2.AppendText("  ! prefix  ")
        $col2.SelectionFont=$fBody; $col2.SelectionColor=$cBody;   $col2.AppendText("DANGER - irreversible`n")
        $col2.SelectionFont=$fCode; $col2.SelectionColor=$cWarn;   $col2.AppendText("  ~ prefix  ")
        $col2.SelectionFont=$fBody; $col2.SelectionColor=$cBody;   $col2.AppendText("CAUTION - changes state`n")
        $col2.SelectionFont=$fCode; $col2.SelectionColor=$cOk;     $col2.AppendText("  no prefix ")
        $col2.SelectionFont=$fBody; $col2.SelectionColor=$cBody;   $col2.AppendText("Safe / read-only`n")
        wl $col2 "  Prefix stripped before insert. Hover for tooltip." $fBody $cGray
        sep $col2

        h1 $col2 "HINTS.TXT FORMAT"
        code $col2 "[ Section Name ]"
        code $col2 "adb devices ## EN desc ##| RU desc"
        code $col2 "~adb shell setprop ... ## Changes VR setting"
        code $col2 "!adb shell rm -rf ... ## Deletes files!"
        code $col2 "# comment line - skipped"
        wl $col2 "  File: next to script or in Source\ subfolder." $fBody $cGray
        sep $col2

        h1 $col2 "SHORTCUTS"
        b $col2 "F5"        "Run"
        b $col2 "Ctrl+A"    "Select all in editor"
        b $col2 "Ctrl+T"    "New tab"
        b $col2 "Ctrl+W"    "Close tab"
        b $col2 "Ctrl+Tab"  "Next tab"
        sep $col2

        h1 $col2 "THEME & LAYOUT"
        b $col2 "[Theme]"        "Dark / Light toggle"
        b $col2 "[Hints]"        "Show / hide right sidebar"
        b $col2 "H-splitter"     "Resize editor vs log height"
        b $col2 "V-splitter"     "Resize editor vs hints width"
        sep $col2

        h1 $col2 "TROUBLESHOOTING"
        b $col2 "adb not found"   "Pass -ToolsPath to the script"
        b $col2 "GUI freeze"      "Command needs interceptor - check rules"
        b $col2 "[TIMEOUT] 20s"   "Interactive - let interceptor redirect it"
        b $col2 "Hints not fresh" "Click [Reload] after editing hints.txt"
        b $col2 "Garbled output"  "Known: CMD UTF-8 vs PS 5.1 CP1251"
        sep $col2
    }

    $col1.SelectionStart=0; $col1.ScrollToCaret()
    $col2.SelectionStart=0; $col2.ScrollToCaret()
    $null=$hf.ShowDialog()
}

# ---------------------------------------------------------------------------
# 8. RUN ACTION
# ---------------------------------------------------------------------------
$runAction = {
    $t = Get-ActiveTab; if ($null -eq $t) { return }
    $cmdBox = $t.CmdBox
    $logBox = $t.LogBox

    $script:isStopping = $false
    $shells = @("cmd","powershell","pwsh","nslookup","python","node","ssh","telnet","diskpart","scrcpy","ftp")

    if ($script:showTimestamps) {
        $ts = (Get-Date).ToString("HH:mm:ss")
        $logBox.SelectionColor = [System.Drawing.Color]::FromArgb(120,120,120)
        $logBox.AppendText("`n$($script:T.RunAt) $ts ---`n")
    }

    foreach ($line in $cmdBox.Lines) {
        $trimmed   = $line.Trim()
        $cleanLine = $trimmed.ToLower()
        if ($script:isStopping -or [string]::IsNullOrWhiteSpace($cleanLine)) { continue }

        $finalCmd      = $trimmed
        $needsRedirect = $false

        foreach ($sh in $shells) {
            if ($cleanLine -eq $sh -or $cleanLine.StartsWith("$sh ")) { $needsRedirect = $true; break }
        }
        if (-not $needsRedirect -and $cleanLine.StartsWith("adb")) {
#            if ($cleanLine -eq "adb shell" -or ($cleanLine -match "top|ping -t|watch |monitor")) { $needsRedirect = $true }
            if ($cleanLine -eq "adb shell" -or ($cleanLine -match "top|ping -t|watch |monitor|getevent")) { $needsRedirect = $true }
            elseif ($cleanLine -match "logcat" -and -not $cleanLine.Contains("-d")) { $needsRedirect = $true }
        }

        if ($needsRedirect) {
            $logBox.SelectionColor = [System.Drawing.Color]::Orange
            $logBox.AppendText("`n$($script:T.Redirect) '$trimmed'`n")
            $proc     = if ($cleanLine -match "powershell|pwsh") { "powershell.exe" } else { "cmd.exe" }
            $waitFlag = if ($cleanLine.StartsWith("scrcpy") -or $cleanLine.StartsWith("adb")) { "/c" } else { "/k" }
            $procArgs = if ($proc -eq "powershell.exe") { "-NoExit", "-Command", "& { $finalCmd }" } else { "$waitFlag $finalCmd" }
            Start-Process $proc -ArgumentList $procArgs
            continue
        }

        $logBox.SelectionColor = if ($script:isDarkMode) { [System.Drawing.Color]::Cyan } else { [System.Drawing.Color]::Blue }
        $logBox.AppendText("`n> $line`n")

        $btnStop.Text = $script:T.BusyText; $btnStop.BackColor = [System.Drawing.Color]::DeepSkyBlue
        $btnRun.Enabled = $false
        Update-StatusBar
        [System.Windows.Forms.Application]::DoEvents()

        try {
            $si = New-Object System.Diagnostics.ProcessStartInfo
            $si.FileName               = "cmd.exe"
            $si.Arguments              = "/c $finalCmd"
            $si.RedirectStandardOutput = $true
            $si.RedirectStandardError  = $true
            $si.UseShellExecute        = $false
            $si.CreateNoWindow         = $true
            $si.StandardOutputEncoding = [System.Text.Encoding]::GetEncoding(866)
            $si.StandardErrorEncoding  = [System.Text.Encoding]::GetEncoding(866)

            $p        = [System.Diagnostics.Process]::Start($si)
            $outTask  = $p.StandardOutput.ReadToEndAsync()
            $errTask  = $p.StandardError.ReadToEndAsync()
            $finished = $p.WaitForExit(20000)
            if (-not $finished) { try { $p.Kill() } catch {} }

            $out = $outTask.Result; $err = $errTask.Result
            if ($out) {
                $logBox.SelectionColor = if ($script:isDarkMode) { [System.Drawing.Color]::White } else { [System.Drawing.Color]::Black }
                $logBox.AppendText($out)
            }
            if ($err) { $logBox.SelectionColor = [System.Drawing.Color]::Red; $logBox.AppendText($err) }
            if (-not $finished) {
                $logBox.SelectionColor = [System.Drawing.Color]::Orange
                $logBox.AppendText("`n$($script:T.Timeout)`n")
                $logBox.SelectionColor = [System.Drawing.Color]::Gray
                $logBox.AppendText("$($script:T.TimeoutAdvice)`n")
            }
        } catch {
            $logBox.SelectionColor = [System.Drawing.Color]::Red
            $logBox.AppendText("`n$($script:T.ErrorPrefix) $($_.Exception.Message)")
        } finally {
            $btnStop.Text = $script:T.StopText; $btnStop.BackColor = [System.Drawing.Color]::LightPink
            $btnRun.Enabled = $true; $logBox.ScrollToCaret()
            Update-StatusBar
            [System.Windows.Forms.Application]::DoEvents()
        }
    }
}



# ---------------------------------------------------------------------------
# 9. UI LAYOUT  (TableLayoutPanel - no Dock magic needed)
# ---------------------------------------------------------------------------
# Form contains a single TableLayoutPanel with 3 rows:
#   Row 0 - fixed 34px  - tab strip
#   Row 1 - fill 100%   - main split (editor left, log right column, log bottom)
#   Row 2 - fixed 117px - button panel + status bar

$form = New-Object System.Windows.Forms.Form
$form.Text          = $script:T.AppTitle
$form.Size          = "1300,980"
$form.StartPosition = "CenterScreen"
$form.KeyPreview    = $true

# Root table: 1 column, 3 rows
$rootTable = New-Object System.Windows.Forms.TableLayoutPanel
$rootTable.Dock        = "Fill"
$rootTable.ColumnCount = 1
$rootTable.RowCount    = 3
$rootTable.Padding     = New-Object System.Windows.Forms.Padding(0)
$rootTable.Margin      = New-Object System.Windows.Forms.Padding(0)
[void]$rootTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent", 100)))
[void]$rootTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute", 34)))   # tab strip
[void]$rootTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Percent",  100)))  # content
[void]$rootTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute", 117)))  # buttons

# ---- Row 0: Tab strip ----
$script:tabStripPanel = New-Object System.Windows.Forms.Panel
$script:tabStripPanel.Dock      = "Fill"
$script:tabStripPanel.Margin    = New-Object System.Windows.Forms.Padding(0)
$script:tabStripPanel.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)

$script:tabStrip = New-Object System.Windows.Forms.FlowLayoutPanel
$script:tabStrip.Dock          = "Fill"
$script:tabStrip.FlowDirection = "LeftToRight"
$script:tabStrip.WrapContents  = $false
$script:tabStrip.BackColor     = [System.Drawing.Color]::FromArgb(30,30,30)
$script:tabStrip.Padding       = New-Object System.Windows.Forms.Padding(2,2,0,0)
$script:tabStripPanel.Controls.Add($script:tabStrip)
$rootTable.Controls.Add($script:tabStripPanel, 0, 0)

# ---- Row 1: Main content (SplitContainer) ----
$mainSplit = New-Object System.Windows.Forms.SplitContainer
$mainSplit.Dock        = "Fill"
$mainSplit.Orientation = "Horizontal"
$mainSplit.Margin      = New-Object System.Windows.Forms.Padding(0)

$topSplit = New-Object System.Windows.Forms.SplitContainer
$topSplit.Dock        = "Fill"
$topSplit.Orientation = "Vertical"
$topSplit.FixedPanel   = "Panel2"
$topSplit.Margin       = New-Object System.Windows.Forms.Padding(0)

$script:editorPanel = New-Object System.Windows.Forms.Panel
$script:editorPanel.Dock   = "Fill"
$script:editorPanel.Margin = New-Object System.Windows.Forms.Padding(0)

$script:logPanel = New-Object System.Windows.Forms.Panel
$script:logPanel.Dock   = "Fill"
$script:logPanel.Margin = New-Object System.Windows.Forms.Padding(0)

# Hints column - use TableLayoutPanel inside Panel2 to avoid Dock stacking issues
$hintsTable = New-Object System.Windows.Forms.TableLayoutPanel
$hintsTable.Dock        = "Fill"
$hintsTable.ColumnCount = 1
$hintsTable.RowCount    = 3
$hintsTable.Padding     = New-Object System.Windows.Forms.Padding(0)
$hintsTable.Margin      = New-Object System.Windows.Forms.Padding(0)
[void]$hintsTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent", 100)))
[void]$hintsTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute", 28)))   # filter box
[void]$hintsTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute", 28)))   # toolbar
[void]$hintsTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Percent",  100)))  # tree

$hintSearch = New-Object System.Windows.Forms.TextBox
$hintSearch.Dock      = "Fill"
$hintSearch.Font      = $uiFont
$hintSearch.Margin    = New-Object System.Windows.Forms.Padding(0)
$hintSearch.BackColor = [System.Drawing.Color]::FromArgb(232,244,220)

$hintToolbar = New-Object System.Windows.Forms.Panel
$hintToolbar.Dock   = "Fill"
$hintToolbar.Margin = New-Object System.Windows.Forms.Padding(0)

# Use a TableLayoutPanel inside toolbar so all 3 buttons fill width equally
$hintBtnTable = New-Object System.Windows.Forms.TableLayoutPanel
$hintBtnTable.Dock        = "Fill"
$hintBtnTable.ColumnCount = 3
$hintBtnTable.RowCount    = 1
$hintBtnTable.Padding     = New-Object System.Windows.Forms.Padding(0)
$hintBtnTable.Margin      = New-Object System.Windows.Forms.Padding(0)
[void]$hintBtnTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent", 33.3)))
[void]$hintBtnTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent", 33.3)))
[void]$hintBtnTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent", 33.4)))
[void]$hintBtnTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Percent", 100)))

$btnExpandAll = New-Object System.Windows.Forms.Button
$btnExpandAll.Text      = $script:T.BtnExpandAll
$btnExpandAll.Dock      = "Fill"
$btnExpandAll.Margin    = New-Object System.Windows.Forms.Padding(0)
$btnExpandAll.FlatStyle = "Flat"; $btnExpandAll.Font = $uiFont
$btnExpandAll.BackColor = [System.Drawing.Color]::FromArgb(60,60,60)
$btnExpandAll.ForeColor = [System.Drawing.Color]::FromArgb(200,200,200)

$btnCollapseAll = New-Object System.Windows.Forms.Button
$btnCollapseAll.Text      = $script:T.BtnCollapseAll
$btnCollapseAll.Dock      = "Fill"
$btnCollapseAll.Margin    = New-Object System.Windows.Forms.Padding(0)
$btnCollapseAll.FlatStyle = "Flat"; $btnCollapseAll.Font = $uiFont
$btnCollapseAll.BackColor = [System.Drawing.Color]::FromArgb(50,50,50)
$btnCollapseAll.ForeColor = [System.Drawing.Color]::FromArgb(200,200,200)

$btnReloadHints = New-Object System.Windows.Forms.Button
$btnReloadHints.Text      = $script:T.BtnReload
$btnReloadHints.Dock      = "Fill"
$btnReloadHints.Margin    = New-Object System.Windows.Forms.Padding(0)
$btnReloadHints.FlatStyle = "Flat"; $btnReloadHints.Font = $uiFont
$btnReloadHints.BackColor = [System.Drawing.Color]::FromArgb(45,65,45)
$btnReloadHints.ForeColor = [System.Drawing.Color]::FromArgb(160,220,160)

$hintBtnTable.Controls.Add($btnExpandAll,   0, 0)
$hintBtnTable.Controls.Add($btnCollapseAll, 1, 0)
$hintBtnTable.Controls.Add($btnReloadHints, 2, 0)
$hintToolbar.Controls.Add($hintBtnTable)

$hintTree = New-Object System.Windows.Forms.TreeView
$hintTree.Dock             = "Fill"
$hintTree.Font             = $uiFont
$hintTree.ShowLines        = $true
$hintTree.ShowPlusMinus    = $true
$hintTree.ShowRootLines    = $true
$hintTree.HideSelection    = $false
$hintTree.BorderStyle      = "None"
$hintTree.ShowNodeToolTips = $true
$hintTree.Scrollable       = $true
$hintTree.Margin           = New-Object System.Windows.Forms.Padding(0)
Populate-HintTree $hintTree ""

$hintsTable.Controls.Add($hintSearch,  0, 0)
$hintsTable.Controls.Add($hintToolbar, 0, 1)
$hintsTable.Controls.Add($hintTree,    0, 2)

# Log area: TableLayoutPanel with log on top, desc panel below (hidden by default)
$logAreaTable = New-Object System.Windows.Forms.TableLayoutPanel
$logAreaTable.Dock        = "Fill"
$logAreaTable.ColumnCount = 1
$logAreaTable.RowCount    = 2
$logAreaTable.Padding     = New-Object System.Windows.Forms.Padding(0)
$logAreaTable.Margin      = New-Object System.Windows.Forms.Padding(0)
[void]$logAreaTable.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle("Percent", 100)))
[void]$logAreaTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Percent", 100)))   # log
[void]$logAreaTable.RowStyles.Add((New-Object System.Windows.Forms.RowStyle("Absolute", 0)))    # desc panel (hidden)

# The actual logPanel that tabs swap their LogBox into
$script:logPanel = New-Object System.Windows.Forms.Panel
$script:logPanel.Dock   = "Fill"
$script:logPanel.Margin = New-Object System.Windows.Forms.Padding(0)

# Description panel - shown in log area when [D] is toggled
$hintDescBox = New-Object System.Windows.Forms.RichTextBox
$hintDescBox.Dock        = "Fill"
$hintDescBox.ReadOnly    = $true
$hintDescBox.BorderStyle = "None"
$hintDescBox.Font        = New-Object System.Drawing.Font("Segoe UI", 10)
$hintDescBox.BackColor   = [System.Drawing.Color]::FromArgb(22, 28, 36)
$hintDescBox.ForeColor   = [System.Drawing.Color]::FromArgb(180, 180, 180)
$hintDescBox.Margin      = New-Object System.Windows.Forms.Padding(0)
$hintDescBox.ScrollBars  = "Vertical"

$logAreaTable.Controls.Add($script:logPanel, 0, 0)
$logAreaTable.Controls.Add($hintDescBox,     0, 1)

$topSplit.Panel1.Controls.Add($script:editorPanel)
$topSplit.Panel2.Controls.Add($hintsTable)
$mainSplit.Panel1.Controls.Add($topSplit)
$mainSplit.Panel2.Controls.Add($logAreaTable)
$rootTable.Controls.Add($mainSplit, 0, 1)

# ---- Row 2: Button panel ----
$btnPanel = New-Object System.Windows.Forms.Panel
$btnPanel.Dock      = "Fill"
$btnPanel.Margin    = New-Object System.Windows.Forms.Padding(0)
$btnPanel.BackColor = [System.Drawing.Color]::WhiteSmoke

# Status bar at bottom of btnPanel
$script:statusPanel = New-Object System.Windows.Forms.Panel
$script:statusPanel.Dock      = "Bottom"
$script:statusPanel.Height    = 22
$script:statusPanel.BackColor = [System.Drawing.Color]::FromArgb(28,28,28)
$script:statusLabel = New-Object System.Windows.Forms.Label
$script:statusLabel.Dock      = "Fill"
$script:statusLabel.Font      = $uiFont
$script:statusLabel.TextAlign = "MiddleLeft"
$script:statusLabel.Padding   = New-Object System.Windows.Forms.Padding(8,0,0,0)
$script:statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(140,140,140)
$script:statusPanel.Controls.Add($script:statusLabel)
$btnPanel.Controls.Add($script:statusPanel)

function Create-Btn($txt,$x,$y,$w=85,$clr="Control") {
    New-Object System.Windows.Forms.Button -Property @{
        Text=$txt; Left=$x; Top=$y; Width=$w; Height=30
        FlatStyle="Flat"; BackColor=[System.Drawing.Color]::$clr
    }
}
# Row 1 - main buttons (Top=10)
$btnRun         = Create-Btn $script:T.BtnRun      10  10  95  "LightGreen"
$btnStop        = Create-Btn $script:T.BtnStop         110  10  70  "LightPink"
$btnPaste       = Create-Btn $script:T.BtnPaste        210  10  70  "White"
$btnClearCmd    = Create-Btn $script:T.BtnClearCode   285  10  90  "White"
$btnUndoCmd     = Create-Btn "U"           375  10  30  "LightGray"
$btnUndoCmd.TabStop = $false

$btnCopyLog     = Create-Btn $script:T.BtnCopyLog    440  10 100  "Lavender"
$btnSave        = Create-Btn $script:T.BtnSaveLog    543  10 100  "Lavender"
$btnDetach      = Create-Btn $script:T.BtnDetachLog  646  10 100  "Lavender"
$btnClearLog    = Create-Btn $script:T.BtnClearLog   766  10  85  "Lavender"
$btnUndoLog     = Create-Btn "U"           851  10  30  "LightGray"
$btnUndoLog.TabStop = $false
$btnHintsToggle = Create-Btn $script:T.BtnHints      960  10  90  "Azure"
$btnDescToggle  = Create-Btn "D"          1050  10  30  "LightGray"
$btnDescToggle.TabStop = $false
$btnTheme       = Create-Btn $script:T.BtnTheme      1083  10  75  "DarkGray"
# [?] right-aligned via Anchor
$btnHelp        = Create-Btn "?"          1160  10  35  "LightBlue"
$btnHelp.Anchor = [System.Windows.Forms.AnchorStyles]"Top,Right"

# Row 2 - always-visible log search bar (Top=50)
$lblLogSearch = New-Object System.Windows.Forms.Label -Property @{
    Text=$script:T.LblLogSearch; Left=10; Top=54; Width=80; Height=22; TextAlign="MiddleLeft"
}
$searchBox = New-Object System.Windows.Forms.TextBox -Property @{
    Left=92; Top=52; Width=260; Height=22; Font=$uiFont
}
$chkHighlight = New-Object System.Windows.Forms.CheckBox -Property @{
    Text=$script:T.ChkHighlight; Left=360; Top=52; Width=90; Checked=$true
}
$chkTimestamps = New-Object System.Windows.Forms.CheckBox -Property @{
    Text=$script:T.ChkTimestamps; Left=455; Top=52; Width=105; Checked=$true
}
$btnDeep = New-Object System.Windows.Forms.Button -Property @{
    Text=$script:T.BtnExtract; Left=563; Top=48; Width=183; Height=30
    FlatStyle="Flat"; BackColor=[System.Drawing.Color]::Beige
}

$btnPanel.Controls.AddRange(@(
    $btnRun,$btnStop,$btnPaste,$btnClearCmd,$btnUndoCmd,
    $btnCopyLog,$btnSave,$btnDetach,$btnClearLog,$btnUndoLog,
    $btnHintsToggle,$btnDescToggle,$btnTheme,$btnHelp,
    $lblLogSearch,$searchBox,$chkHighlight,$chkTimestamps,$btnDeep
))
$rootTable.Controls.Add($btnPanel, 0, 2)

$form.Controls.Add($rootTable)

# ---------------------------------------------------------------------------
# 10. EVENTS
# ---------------------------------------------------------------------------
$btnRun.Add_Click($runAction)
$btnStop.Add_Click({ $script:isStopping = $true })
$btnPaste.Add_Click({ $cb=Get-ActiveCmdBox; if($cb){$cb.AppendText([System.Windows.Forms.Clipboard]::GetText())} })
$btnClearCmd.Add_Click({ $cb=Get-ActiveCmdBox; if($cb -and $cb.Text){$script:lastCodeBackup=$cb.Text;$cb.Clear()} })
$btnUndoCmd.Add_Click({ $cb=Get-ActiveCmdBox; if($cb -and $script:lastCodeBackup){$cb.Text=$script:lastCodeBackup; $cb.Focus()} })
$btnClearLog.Add_Click({ $lb=Get-ActiveLogBox; if($lb -and $lb.Text){$script:lastLogBackup=$lb.Text;$lb.Clear()} })
$btnUndoLog.Add_Click({ $lb=Get-ActiveLogBox; if($lb -and $script:lastLogBackup){$lb.AppendText($script:lastLogBackup); $lb.Focus()} })
$btnCopyLog.Add_Click({ $lb=Get-ActiveLogBox; if($lb -and $lb.Text){[System.Windows.Forms.Clipboard]::SetText($lb.Text)} })
$btnSave.Add_Click({
    $lb=Get-ActiveLogBox; if(-not $lb){return}
    $sfd=New-Object System.Windows.Forms.SaveFileDialog -Property @{Filter="Text Files|*.txt";Title=$script:T.SaveLogTitle}
    if($sfd.ShowDialog()-eq"OK"){$lb.Text|Out-File -FilePath $sfd.FileName -Encoding utf8}
})
$btnDetach.Add_Click({ Show-LogDetached })
$btnTheme.Add_Click({ $script:isDarkMode=-not $script:isDarkMode; Set-Theme })
$btnHintsToggle.Add_Click({ $topSplit.Panel2Collapsed=-not $topSplit.Panel2Collapsed })
$btnHelp.Add_Click({ Show-QuasHelp })
$chkTimestamps.Add_CheckedChanged({ $script:showTimestamps=$chkTimestamps.Checked })
# Log search is always visible - no toggle needed

$fnHighlight = {
    $lb=Get-ActiveLogBox; if(-not $lb){return}
    $st=$lb.SelectionStart
    # Reset only BackColor - do NOT touch SelectionColor/ForeColor
    # to preserve the cyan color of command echo lines ("> cmd")
    $lb.SelectAll()
    $lb.SelectionBackColor=$lb.BackColor
    if($chkHighlight.Checked -and $searchBox.Text.Length -ge 3){
        $f=$searchBox.Text; $p=0
        while(($p=$lb.Find($f,$p,[System.Windows.Forms.RichTextBoxFinds]::None))-ge 0){
            $lb.SelectionBackColor=$script:highlightColor
            $lb.SelectionColor=[System.Drawing.Color]::Black
            $p+=$f.Length
        }
    }
    $lb.Select($st,0); $lb.SelectionBackColor=$lb.BackColor
}
$searchBox.Add_TextChanged($fnHighlight); $chkHighlight.Add_CheckedChanged($fnHighlight)

$btnDeep.Add_Click({
    $lb=Get-ActiveLogBox; if(-not $lb){return}
    $q=$searchBox.Text.ToLower(); if(-not $q){return}
    $res=$lb.Text -split "`n"|Where-Object{$_.ToLower().Contains($q)}
    if($res){$tmp=[System.IO.Path]::GetTempFileName()+".txt";$res.Trim()|Out-File $tmp -Encoding utf8;Start-Process notepad.exe $tmp}
})
$hintSearch.Add_TextChanged({ Populate-HintTree $hintTree $hintSearch.Text })
$btnExpandAll.Add_Click({ $hintTree.BeginUpdate();$hintTree.ExpandAll();$hintTree.EndUpdate() })
$btnCollapseAll.Add_Click({ $hintTree.BeginUpdate();$hintTree.CollapseAll();$hintTree.EndUpdate() })
$btnReloadHints.Add_Click({
    $found = Find-HintsFile
    if ($found) {
        $script:hintCategories = Parse-HintsFile $found
        Populate-HintTree $hintTree $hintSearch.Text
        $lb = Get-ActiveLogBox
        if ($lb) {
            $lb.SelectionColor = [System.Drawing.Color]::FromArgb(120,120,120)
            $lb.AppendText("`n$($script:T.HintsReloaded) $found]`n")
        }
    } else {
        $lb = Get-ActiveLogBox
        if ($lb) {
            $lb.SelectionColor = [System.Drawing.Color]::FromArgb(255,90,90)
            $lb.AppendText("`n$($script:T.HintsNotFound)`n")
        }
    }
})
$btnDescToggle.Add_Click({
    $rs = $logAreaTable.RowStyles[1]
    if ($rs.Height -eq 0) {
        $rs.SizeType = [System.Windows.Forms.SizeType]::Absolute
        $rs.Height   = 80
        $btnDescToggle.BackColor = [System.Drawing.Color]::FromArgb(60,80,60)
        $btnDescToggle.ForeColor = [System.Drawing.Color]::FromArgb(140,220,140)
        $sel = $hintTree.SelectedNode
        if ($sel -and $sel.Tag -is [hashtable]) { Update-HintDesc $sel.Tag }
    } else {
        $rs.SizeType = [System.Windows.Forms.SizeType]::Absolute
        $rs.Height   = 0
        $btnDescToggle.BackColor = [System.Drawing.Color]::LightGray
        $btnDescToggle.ForeColor = [System.Drawing.Color]::Black
    }
    $cb = Get-ActiveCmdBox; if ($cb) { $cb.Focus() }
})

function Update-HintDesc($tag) {
    $hintDescBox.Clear()
    $cmdColor = switch ($tag.Prefix) {
        "!" { $script:hintColorDanger }
        "~" { $script:hintColorCaution }
        default { [System.Drawing.Color]::FromArgb(130, 190, 255) }
    }
    # Command line
    $hintDescBox.SelectionFont  = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
    $hintDescBox.SelectionColor = $cmdColor
    $hintDescBox.AppendText($tag.Cmd + "`n")

    $rawDesc = if ($script:Lang -eq "RU" -and $tag.DescRU) { $tag.DescRU } else { $tag.Desc }
    if ($rawDesc) {
        # Split description from example on " | "
        $parts   = $rawDesc -split '\s*\|\s*', 2
        $descTxt = $parts[0].Trim()
        $exTxt   = if ($parts.Count -gt 1) { $parts[1].Trim() } else { "" }

        # Description text
        $hintDescBox.SelectionFont  = New-Object System.Drawing.Font("Segoe UI", 10)
        $hintDescBox.SelectionColor = [System.Drawing.Color]::FromArgb(195, 195, 195)
        $hintDescBox.AppendText($descTxt)

        # Example line
        if ($exTxt) {
            $hintDescBox.AppendText("`n")
            $hintDescBox.SelectionFont  = New-Object System.Drawing.Font("Consolas", 9)
            $hintDescBox.SelectionColor = [System.Drawing.Color]::DeepSkyBlue
            $hintDescBox.AppendText($exTxt)
        }
    } else {
        $hintDescBox.SelectionFont  = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)
        $hintDescBox.SelectionColor = [System.Drawing.Color]::FromArgb(90, 90, 100)
        $hintDescBox.AppendText($script:T.NoDesc)
    }
    $hintDescBox.SelectionStart = 0
    $hintDescBox.ScrollToCaret()
}

$hintTree.Add_AfterSelect({
    param($s, $e)
    if ($null -eq $e.Node -or $null -eq $e.Node.Tag -or -not ($e.Node.Tag -is [hashtable])) {
        $hintDescBox.Clear()
        return
    }
    # Only update desc panel if it is visible
    if ($logAreaTable.RowStyles[1].Height -gt 0) {
        Update-HintDesc $e.Node.Tag
    }
})

$hintTree.Add_NodeMouseDoubleClick({
    param($s,$e)
    if ($e.Node -and ($null -ne $e.Node.Tag) -and ($e.Node.Tag -is [hashtable])) {
        $cb = Get-ActiveCmdBox
        if ($cb) { $cb.AppendText($e.Node.Tag.Cmd + "`r`n"); $cb.Focus() }
    }
})

$form.Add_KeyDown({
    param($s,$e)
    if($e.KeyCode -eq "F5")  { & $runAction }
    if($e.Control -and $e.KeyCode -eq "A") { $cb=Get-ActiveCmdBox; if($cb){$cb.SelectAll()} }
    if($e.Control -and $e.KeyCode -eq "T") {
        $n=$script:tabs.Count+1
        $script:tabs.Add((New-TabData "$($script:T.TabNew) $n"))
        $script:activeTabIdx=$script:tabs.Count-1
        Switch-Tab
    }
    if($e.Control -and $e.KeyCode -eq "W") {
        if($script:tabs.Count -le 1){return}
        $script:tabs.RemoveAt($script:activeTabIdx)
        if($script:activeTabIdx -ge $script:tabs.Count){$script:activeTabIdx=$script:tabs.Count-1}
        Switch-Tab
    }
    if($e.Control -and $e.KeyCode -eq "Tab") {
        $script:activeTabIdx=($script:activeTabIdx+1) % $script:tabs.Count
        Switch-Tab
    }
})

$form.Add_Load({
    $btnHelp.Left = $btnPanel.Width - 50
    # Create first tab
    $script:tabs.Add((New-TabData "$($script:T.TabNew) 1"))
    $script:activeTabIdx = 0
    Switch-Tab
    Set-Theme
    Update-StatusBar
})

$form.Add_Shown({
    # Set splitter distances once the form has real dimensions
    $topSplit.SplitterDistance  = [int]($mainSplit.Width * 0.73)
    $mainSplit.SplitterDistance = [int]($mainSplit.Height * 0.52)
})

$form.Add_Resize({
    $btnHelp.Left = $btnPanel.Width - 50
})

$null=$form.ShowDialog()
$form.Dispose()