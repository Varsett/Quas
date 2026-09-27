[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
    [string]$WorkDir  = "",     # folder where logs are stored (for scanning)
    [string]$SavePath = "",     # folder where screenshots and CSV exports are saved
    [string]$Label         = "-",
    [string]$Interval      = "-",
    [string]$Streams       = "-",
    [string]$Duration      = "-",
    [string]$Protocol      = "-",
    [string]$TBitrate      = "-",
    [string]$WarnLoss      = "1.0",
    [string]$FileName      = "",
    [string]$AView         = "",
    [string]$BView         = "",
    [string]$CsvPath       = "",
    [switch]$AllLogs,
    [switch]$Screenshot,
    [switch]$Exit
)

# Resolve script directory
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

Add-Type -AssemblyName System.Windows.Forms, System.Windows.Forms.DataVisualization, System.Drawing
[System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($true)

# ================================================================
#  RESOLVE SCAN FOLDER
#  Priority: -WorkDir > -Path > auto-discover next to script > dialog
# ================================================================
$scanPath = ""   # folder where logs will be scanned
$outPath  = ""   # folder where screenshots/CSV exports are saved

# Clean helper
function Clean-Path([string]$p) {
    return $p.Split('-')[0].Trim().Trim('"').Trim("'").TrimEnd('\')
}

if ($WorkDir -ne "") {
    # -WorkDir: explicit log folder
    $scanPath = Clean-Path $WorkDir
    # Output: -SavePath if given, else script folder
    $outPath  = if ($SavePath -ne "") { Clean-Path $SavePath } else { $scriptDir }
} elseif ($SavePath -ne "") {
    # -SavePath only: scan script folder, save to SavePath
    $scanPath = $scriptDir
    $outPath  = Clean-Path $SavePath
} else {
    # Auto-discover: check script folder
    $autoFiles = Get-ChildItem -Path $scriptDir -File -ErrorAction SilentlyContinue |
                 Where-Object { $_.Extension -match '\.(log|txt|csv)' }
    if ($autoFiles) {
        $scanPath = $scriptDir
        $outPath  = $scriptDir
    }
    # If nothing found — open empty (no dialog)
}

# $scanPath is used by the parser; keep a $Path alias for any remaining refs
$Path = $scanPath

# ================================================================
#  PARSE DATA
# ================================================================
$allTestData = @{}
$totalsData  = @{}
$script:isTCPLog = @{}
$script:isCsvRT  = @{}   # tracks which allTestData keys came from RT-Monitor CSV

# ----------------------------------------------------------------
#  PARSE iPerf REAL-TIME MONITOR CSV
#  Expected header: Time_sec,Bitrate_Mbps,Loss_pct,Jitter_ms
#  Column order is detected from the header — order does not matter.
#  Returns $true if the file was successfully parsed and added.
#  Defined here (before the main loop) so .txt/.log files that don't
#  match the iPerf3 format can fall back to this parser.
# ----------------------------------------------------------------
function Add-CsvRTLog([System.IO.FileInfo]$csvFile) {
    # Read raw text and strip BOM if present, then split into lines.
    # This avoids encoding-related mismatches between files saved by
    # different tools/encodings.
    $rawText = [System.IO.File]::ReadAllText($csvFile.FullName)
    $rawText = $rawText.TrimStart([char]0xFEFF)   # strip UTF-8 BOM if present
    $csvLines = $rawText -split "`r`n|`r|`n" | Where-Object { $_.Trim() -ne "" }
    if ($csvLines.Count -lt 2) { return $false }

    $headers = ($csvLines[0] -split ',') | ForEach-Object { $_.Trim().ToLower() }

    $iTime    = [array]::IndexOf($headers, 'time_sec')
    $iBit     = [array]::IndexOf($headers, 'bitrate_mbps')
    $iLoss    = [array]::IndexOf($headers, 'loss_pct')
    $iJitter  = [array]::IndexOf($headers, 'jitter_ms')

    # Fallback: partial (substring) match on header names, case-insensitive
    if ($iTime   -lt 0) { for ($k=0; $k -lt $headers.Count; $k++) { if ($headers[$k] -like '*time*')   { $iTime   = $k; break } } }
    if ($iBit    -lt 0) { for ($k=0; $k -lt $headers.Count; $k++) { if ($headers[$k] -like '*bit*')    { $iBit    = $k; break } } }
    if ($iLoss   -lt 0) { for ($k=0; $k -lt $headers.Count; $k++) { if ($headers[$k] -like '*loss*')   { $iLoss   = $k; break } } }
    if ($iJitter -lt 0) { for ($k=0; $k -lt $headers.Count; $k++) { if ($headers[$k] -like '*jitter*') { $iJitter = $k; break } } }

    if ($iTime -lt 0 -or $iBit -lt 0) { return $false }

    $csvParsed = foreach ($row in ($csvLines | Select-Object -Skip 1)) {
        $cols = $row -split ','
        if ($cols.Count -le [math]::Max($iTime, $iBit)) { continue }
        try {
            $t = [math]::Round([double]$cols[$iTime].Trim(), 3)
            $b = [math]::Round([double]$cols[$iBit].Trim(),  3)
            $l = if ($iLoss   -ge 0 -and $cols.Count -gt $iLoss)   { [double]$cols[$iLoss].Trim()   } else { 0 }
            $j = if ($iJitter -ge 0 -and $cols.Count -gt $iJitter) { [double]$cols[$iJitter].Trim() } else { 0 }
            [PSCustomObject]@{ Time = $t; Bitrate = $b; Jitter = $j; Loss = $l }
        } catch { }
    }

    if (-not $csvParsed) { return $false }

    $csvKey = $csvFile.Name
    $script:allTestData[$csvKey] = $csvParsed
    $script:totalsData[$csvKey]  = $null
    $script:isTCPLog[$csvKey]    = $false
    $script:isCsvRT[$csvKey]     = $true
    return $true
}

if ($Path -ne "" -and (Test-Path -Path $Path)) {
    $item        = Get-Item -Path $Path
    $targetFiles = if ($item -is [System.IO.FileInfo]) { @($item) } else {
        Get-ChildItem -Path $Path -File |
            Where-Object { $_.Extension -match '\.(log|txt)' } | Sort-Object Name
    }

    $unitMap = @{ 'Gbits/sec' = 1000; 'Mbits/sec' = 1; 'Kbits/sec' = 0.001 }
    foreach ($file in $targetFiles) {
        $content  = Get-Content $file.FullName -Encoding UTF8
        $rawLines = $content | Where-Object {
            $_ -match '\[\s*\d+\]\s+\d+\.\d+-\d+\.\d+\s+sec' -and $_ -notmatch 'sender|receiver'
        }
        $parsed = foreach ($line in $rawLines) {
            if ($line -match '(?<interval>\d+\.\d+-\d+\.\d+).+?\s+(?<bitrate>[\d.]+)\s+(?<unit>Gbits/sec|Mbits/sec|Kbits/sec)\s+(?<jitter>\d+\.\d+)\s+ms\s+(?<lost>\d+)/(?<total>\d+)\s+\((?<percent>\d+(\.\d+)?)\%\)') {
                # UDP with jitter and loss
                $mul = $unitMap[$Matches['unit']]
                [PSCustomObject]@{
                    Time    = [math]::Round([double]($Matches['interval'].Split('-')[1]), 2)
                    Bitrate = [math]::Round([double]$Matches['bitrate'] * $mul, 3)
                    Jitter  = [double]$Matches['jitter']
                    Loss    = [double]$Matches['percent']
                    IsTCP   = $false
                }
            } elseif ($line -match '(?<interval>\d+\.\d+-\d+\.\d+).+?\s+(?<bitrate>[\d.]+)\s+(?<unit>Gbits/sec|Mbits/sec|Kbits/sec)') {
                # TCP or UDP without loss columns — bitrate only
                $mul = $unitMap[$Matches['unit']]
                [PSCustomObject]@{
                    Time    = [math]::Round([double]($Matches['interval'].Split('-')[1]), 2)
                    Bitrate = [math]::Round([double]$Matches['bitrate'] * $mul, 3)
                    Jitter  = 0.0
                    Loss    = 0.0
                    IsTCP   = $true
                }
            }
        }
        $recvLine = $content | Where-Object { $_ -match 'receiver' -and $_ -match '\d+/\d+' } | Select-Object -Last 1
        if ($recvLine -and $recvLine -match '(?<lost>\d+)/(?<total>\d+)\s+\((?<percent>\d+(\.\d+)?)\%\)') {
            $totalsData[$file.Name] = [PSCustomObject]@{
                Lost = [int]$Matches['lost']; Total = [int]$Matches['total']; Percent = [double]$Matches['percent']
            }
        } else { $totalsData[$file.Name] = $null }
        if ($parsed) {
            $allTestData[$file.Name] = $parsed
            # Mark as TCP if any point has IsTCP flag (no jitter/loss data)
            $script:isTCPLog[$file.Name] = ($parsed | Where-Object { $_.IsTCP } | Select-Object -First 1) -ne $null
        } else {
            # Not a recognizable iPerf3 log — try RT-Monitor CSV format
            # (handles .txt/.log files that are actually CSV, e.g. log_live_*.txt)
            Add-CsvRTLog $file | Out-Null
        }
    }
}

# ================================================================
#  -CsvPath / FOLDER AUTO-SCAN FOR RT-MONITOR CSV
#  (Add-CsvRTLog is defined above, before the main parsing loop)
# ================================================================

# Explicit -CsvPath — accepts a single CSV file OR a folder
if ($CsvPath -ne "" -and (Test-Path -Path $CsvPath)) {
    $csvItem = Get-Item -Path $CsvPath
    if ($csvItem -is [System.IO.FileInfo]) {
        # Single file specified directly
        Add-CsvRTLog $csvItem | Out-Null
    } elseif ($csvItem -is [System.IO.DirectoryInfo]) {
        # Folder — scan for all CSV files in it
        $csvFiles = Get-ChildItem -Path $CsvPath -File -Filter '*.csv' | Sort-Object Name
        foreach ($cf in $csvFiles) {
            if (-not $script:allTestData.ContainsKey($cf.Name)) {
                Add-CsvRTLog $cf | Out-Null
            }
        }
    }
}

# Auto-scan folder for additional RT-Monitor CSV files (.csv extension)
# (.txt/.log files with CSV content are already handled by the fallback above)
if ($Path -ne "" -and (Test-Path -Path $Path) -and (Get-Item -Path $Path) -is [System.IO.DirectoryInfo]) {
    $csvFiles = Get-ChildItem -Path $Path -File -Filter '*.csv' | Sort-Object Name
    foreach ($cf in $csvFiles) {
        if (-not $script:allTestData.ContainsKey($cf.Name)) {
            Add-CsvRTLog $cf | Out-Null
        }
    }
}

$warnLossThreshold = [double]$WarnLoss

# ================================================================
#  THEME
# ================================================================
$script:theme = @{}
function Set-Theme([bool]$dark) {
    $script:theme = if ($dark) { @{
        Bg         = [System.Drawing.Color]::FromArgb(28,28,30)
        Panel      = [System.Drawing.Color]::FromArgb(50,50,53)
        Ctrl       = [System.Drawing.Color]::FromArgb(72,72,76)
        CtrlBorder = [System.Drawing.Color]::FromArgb(115,115,120)
        Fg         = [System.Drawing.Color]::White
        FgDim      = [System.Drawing.Color]::FromArgb(185,185,190)
        Grid       = [System.Drawing.Color]::FromArgb(70,70,72)
        Bit        = [System.Drawing.Color]::DeepSkyBlue
        Jit        = [System.Drawing.Color]::Orange
        Los        = [System.Drawing.Color]::Crimson
        Bit2       = [System.Drawing.Color]::MediumSpringGreen
        Jit2       = [System.Drawing.Color]::Gold
        Los2       = [System.Drawing.Color]::HotPink
        Thresh     = [System.Drawing.Color]::FromArgb(160,160,160)
        GreenLvl   = [System.Drawing.Color]::LimeGreen
        Cursor     = [System.Drawing.Color]::Gold
        AccentA    = [System.Drawing.Color]::DeepSkyBlue
        AccentB    = [System.Drawing.Color]::MediumPurple
        AccentC    = [System.Drawing.Color]::Crimson
        LossWarn   = [System.Drawing.Color]::OrangeRed
        Sep        = [System.Drawing.Color]::FromArgb(90,90,95)
    }} else { @{
        Bg         = [System.Drawing.Color]::FromArgb(218,218,220)
        Panel      = [System.Drawing.Color]::FromArgb(185,185,190)
        Ctrl       = [System.Drawing.Color]::FromArgb(205,205,210)
        CtrlBorder = [System.Drawing.Color]::FromArgb(120,120,125)
        Fg         = [System.Drawing.Color]::Black
        FgDim      = [System.Drawing.Color]::FromArgb(60,60,65)
        Grid       = [System.Drawing.Color]::FromArgb(140,140,140)
        Bit        = [System.Drawing.Color]::MidnightBlue
        Jit        = [System.Drawing.Color]::DarkOrange
        Los        = [System.Drawing.Color]::Firebrick
        Bit2       = [System.Drawing.Color]::DarkGreen
        Jit2       = [System.Drawing.Color]::DarkGoldenrod
        Los2       = [System.Drawing.Color]::DeepPink
        Thresh     = [System.Drawing.Color]::FromArgb(64,64,64)
        GreenLvl   = [System.Drawing.Color]::DarkGreen
        Cursor     = [System.Drawing.Color]::DarkRed
        AccentA    = [System.Drawing.Color]::MidnightBlue
        AccentB    = [System.Drawing.Color]::Purple
        AccentC    = [System.Drawing.Color]::DarkRed
        LossWarn   = [System.Drawing.Color]::OrangeRed
        Sep        = [System.Drawing.Color]::FromArgb(130,130,135)
    }}
}
Set-Theme $true

# ================================================================
#  FONTS
# ================================================================
# NOTE: FlatStyle=Flat + visual styles ignores Font unless
#       SetCompatibleTextRenderingDefault(true) is called (done above).
$fntBtn   = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$fntCombo = New-Object System.Drawing.Font("Segoe UI", 10)
$fntMono  = New-Object System.Drawing.Font("Consolas", 10)
$fntMonoS = New-Object System.Drawing.Font("Consolas", 9)
$fntLabel = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$fntTitle = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)

# ================================================================
#  FORM
# ================================================================
$form               = New-Object System.Windows.Forms.Form
$form.Text          = "iPerf3 v3.48 Visual Diagnostic"
$form.Width         = 1680
$form.Height        = 970
$form.StartPosition = "CenterScreen"
$form.MinimumSize   = New-Object System.Drawing.Size(1200, 700)

$panel        = New-Object System.Windows.Forms.Panel
$panel.Height = 58
$panel.Dock   = "Top"

$statsContainer       = New-Object System.Windows.Forms.Panel
$statsContainer.Width = 250
$statsContainer.Dock  = "Right"

$chart      = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Dock = "Fill"

$toolTip                = New-Object System.Windows.Forms.ToolTip
$toolTip.ShowAlways     = $true
$toolTip.AutomaticDelay = 0
$toolTip.AutoPopDelay   = 6000
$toolTip.InitialDelay   = 0
$toolTip.ReshowDelay    = 0

$form.Controls.Add($chart)
$form.Controls.Add($statsContainer)
$form.Controls.Add($panel)

# ================================================================
#  ANALYTICS BOX
# ================================================================
$lblStatsTitle           = New-Object System.Windows.Forms.Label
$lblStatsTitle.Text      = "ANALYTICS"
$lblStatsTitle.Top       = -4; $lblStatsTitle.Left = 6
$lblStatsTitle.Width     = 240; $lblStatsTitle.Height = 24
$lblStatsTitle.TextAlign = "MiddleLeft"
$lblStatsTitle.Font      = $fntTitle
$statsContainer.Controls.Add($lblStatsTitle)

$statsBox             = New-Object System.Windows.Forms.RichTextBox
$statsBox.Top         = 22; $statsBox.Left = 5
$statsBox.Width       = 238; $statsBox.Height = 550
$statsBox.Anchor      = "Top,Left"
$statsBox.ReadOnly    = $true
$statsBox.BorderStyle = "None"
$statsBox.Font        = $fntMono
$statsContainer.Controls.Add($statsBox)

# Verdict box — Panel draws the border, RichTextBox inside has None border (no clipping)
# Arial 9 Bold: ~16px per line. 7 lines (3 + blank + 3) + 8px margin = 120px inner
# Panel adds 1px border each side = 122px total
$verdictPanelH = 110

$verdictPanel             = New-Object System.Windows.Forms.Panel
$verdictPanel.Left        = 5; $verdictPanel.Width = 238
$verdictPanel.Height      = $verdictPanelH
$verdictPanel.BorderStyle = "FixedSingle"
$statsContainer.Controls.Add($verdictPanel)

$verdictBox               = New-Object System.Windows.Forms.RichTextBox
$verdictBox.Left          = 2; $verdictBox.Top = 2
$verdictBox.Width         = $verdictPanel.Width  - 6
$verdictBox.Height        = $verdictPanel.Height - 4
$verdictBox.ReadOnly      = $true
$verdictBox.BorderStyle   = "None"
$verdictBox.Font          = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$verdictBox.ScrollBars    = "None"
$verdictBox.WordWrap      = $false
$verdictPanel.Controls.Add($verdictBox)

# Position verdict panel at bottom; statsBox fills the rest
function Reposition-Verdict {
    $h = $statsContainer.Height
    $verdictPanel.Top = $h - $verdictPanelH - 2
    $statsBox.Height  = $h - $verdictPanelH - 24
}

$statsContainer.Add_Resize({ Reposition-Verdict })

# ================================================================
#  BUTTON FACTORY
#  Height matches ComboBox default (~24px content + border = 26px)
# ================================================================
$btnH = 26   # same visual height as ComboBox

function New-Btn([string]$text, [int]$left, [int]$width, [int]$top=16) {
    $b                          = New-Object System.Windows.Forms.Button
    $b.Text                     = $text
    $b.Left                     = $left; $b.Top = $top
    $b.Height                   = $btnH; $b.Width = $width
    $b.FlatStyle                = "Flat"
    $b.Font                     = $fntBtn
    $b.UseCompatibleTextRendering = $true   # KEY: makes Font actually apply with FlatStyle
    $panel.Controls.Add($b)
    return $b
}

# ================================================================
#  TOP CONTROLS
# ================================================================
$script:sortedKeys = @($allTestData.Keys | Sort-Object)
$sortedKeys = $script:sortedKeys   # local alias for existing code

# Keys explicitly referenced get shown regardless of the All Logs toggle
$script:alwaysVisibleKeys = New-Object System.Collections.Generic.HashSet[string]
if ($CsvPath -ne "" -and (Test-Path $CsvPath)) {
    [void]$script:alwaysVisibleKeys.Add((Get-Item $CsvPath).Name)
}

# All Logs toggle — when off, RT-Monitor CSV logs are hidden from dropdowns
# unless explicitly referenced (e.g. via -CsvPath, or matched by -AView/-BView later).
# The -AllLogs switch starts the toggle already pressed (same as clicking the button).
$script:showAllLogs = $AllLogs.IsPresent

function Get-VisibleKeys {
    if ($script:showAllLogs) { return $script:sortedKeys }
    return @($script:sortedKeys | Where-Object {
        -not $script:isCsvRT[$_] -or $script:alwaysVisibleKeys.Contains($_)
    })
}

# All Logs toggle button — sits left of combo A, in the space before the Y-axis alignment zone
$btnAllLogs           = New-Btn "All Logs" 10 76
$btnAllLogs.UseCompatibleTextRendering = $true

# Combo A  — starts at ~129px to align with chart Y-axis (InnerPlotPosition.X=9%, chart ~1430px wide)
$combo               = New-Object System.Windows.Forms.ComboBox
$combo.Left          = 130; $combo.Top = 16; $combo.Width = 285; $combo.Font = $fntCombo
$combo.DropDownStyle = "DropDownList"

function Refresh-ComboItems {
    $visKeys = Get-VisibleKeys
    $prevA = if ($combo.SelectedIndex -ge 0 -and $combo.Items.Count -gt 0) { $combo.SelectedItem.ToString() } else { $null }
    $prevB = if ($combo2.SelectedIndex -gt 0 -and $combo2.Items.Count -gt 0) { $combo2.SelectedItem.ToString() } else { $null }

    $combo.Items.Clear()
    if ($visKeys.Count -eq 0) { [void]$combo.Items.Add("-- No data --") }
    foreach ($k in $visKeys) { [void]$combo.Items.Add($k) }
    $idxA = if ($prevA) { $combo.Items.IndexOf($prevA) } else { -1 }
    $combo.SelectedIndex = if ($idxA -ge 0) { $idxA } else { 0 }

    $combo2.Items.Clear()
    [void]$combo2.Items.Add("-- No Compare --")
    foreach ($k in $visKeys) { [void]$combo2.Items.Add($k) }
    $idxB = if ($prevB) { $combo2.Items.IndexOf($prevB) } else { -1 }
    $combo2.SelectedIndex = if ($idxB -ge 0) { $idxB } else { 0 }
}

$script:visKeysInit = Get-VisibleKeys
if ($script:visKeysInit.Count -eq 0) { [void]$combo.Items.Add("-- No data --") }
foreach ($k in $script:visKeysInit) { [void]$combo.Items.Add($k) }
$combo.SelectedIndex = 0
$panel.Controls.Add($combo)

# Load file button for A  [...]  sits between combo A and button A
$btnLoadA      = New-Btn "..." 418 26
$btnLoadA.Font = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
$btnLoadA.UseCompatibleTextRendering = $true
$btnLoadA.FlatAppearance.BorderSize = 1

# Button A — shifted right by 28px
$btnA              = New-Btn "A" 448 28
$btnA.ForeColor    = [System.Drawing.Color]::DeepSkyBlue
$script:showA      = $true

# Combo B — shifted right by 28px
$combo2               = New-Object System.Windows.Forms.ComboBox
$combo2.Left          = 490; $combo2.Top = 16; $combo2.Width = 285; $combo2.Font = $fntCombo
$combo2.DropDownStyle = "DropDownList"
[void]$combo2.Items.Add("-- No Compare --")
foreach ($k in (Get-VisibleKeys)) { [void]$combo2.Items.Add($k) }
$combo2.SelectedIndex = 0
$panel.Controls.Add($combo2)

# Load file button for B  [...]  sits between combo B and button B
$btnLoadB      = New-Btn "..." 778 26
$btnLoadB.Font = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
$btnLoadB.UseCompatibleTextRendering = $true
$btnLoadB.FlatAppearance.BorderSize = 1

# Button B — shifted right
$btnB              = New-Btn "B" 808 28
$btnB.ForeColor    = [System.Drawing.Color]::MediumSpringGreen
$script:showB      = $true

# Action buttons — shifted right to match
$btnSummary = New-Btn "Summary" 852  80
$btnSave    = New-Btn "Save PNG" 938  84
$btnExport  = New-Btn "CSV"      1028 52

# Zoom cluster — shifted right
$btnZoomOut      = New-Btn "-" 1088 28
$btnZoomOut.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$btnZoomOut.UseCompatibleTextRendering = $true

$lblZoom           = New-Object System.Windows.Forms.Label
$lblZoom.Text      = "Zoom"; $lblZoom.Left = 1119; $lblZoom.Top = 20
$lblZoom.Width     = 46; $lblZoom.TextAlign = "MiddleCenter"; $lblZoom.Font = $fntLabel
$panel.Controls.Add($lblZoom)

$btnZoomIn       = New-Btn "+" 1168 28
$btnZoomIn.Font  = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$btnZoomIn.UseCompatibleTextRendering = $true

# Warn label removed from top panel — verdict shown in stats column instead

# Right-side buttons: left edge of Legend aligns with Analytics label (statsContainer left+6)
# statsContainer.Left = form.Width - 250; Analytics.Left = 6 inside statsContainer
# So Legend.Left = chartRight + 6
$btnLegend = New-Btn "Legend" 1160 72
$btnHelp   = New-Btn "Help"   1238 62
$btnDark   = New-Btn "Light"  1306 60
$script:isDark = $true

function Reposition-RightButtons {
    $chartRight = $panel.Width - $statsContainer.Width
    # Legend left edge aligns with Analytics label (offset +6 inside statsContainer)
    $btnLegend.Left = $chartRight + 6
    $btnHelp.Left   = $btnLegend.Left + $btnLegend.Width + 4
    $btnDark.Left   = $btnHelp.Left   + $btnHelp.Width   + 4
}
$panel.Add_Resize({ Reposition-RightButtons })

# ================================================================
#  ANALYTICS HELPERS
# ================================================================
function Add-CL([string]$text, [System.Drawing.Color]$color) {
    $statsBox.SelectionStart = $statsBox.TextLength
    $statsBox.SelectionColor = $color
    $statsBox.AppendText($text)
}
function Get-JitterColor([double]$v) {
    if ($v -lt 0.2) { return [System.Drawing.Color]::LimeGreen }
    if ($v -lt 0.8) { return [System.Drawing.Color]::Yellow }
    if ($v -lt 1.2) { return [System.Drawing.Color]::Orange }
    return [System.Drawing.Color]::Red
}
function Get-LossColor([double]$v) {
    if ($v -eq 0)   { return [System.Drawing.Color]::LimeGreen }
    if ($v -le 1.0) { return [System.Drawing.Color]::Yellow }
    return [System.Drawing.Color]::Red
}
function Get-LostPktColor([int]$lost, [int]$total) {
    if ($total -eq 0) { return [System.Drawing.Color]::Gray }
    $p = ($lost / $total) * 100
    if ($lost -eq 0) { return [System.Drawing.Color]::LimeGreen }
    if ($p -le 0.1)  { return [System.Drawing.Color]::Yellow }
    if ($p -le 1.0)  { return [System.Drawing.Color]::Orange }
    return [System.Drawing.Color]::Red
}

function Update-Stats([array]$dataA, [string]$fnA, [array]$dataB, [string]$fnB) {
    $statsBox.Clear()
    $t  = $script:theme
    $fg = $t.Fg
    $sep = $t.Sep

    function Print-Block([array]$data, [string]$fn, [string]$tag,
                         [System.Drawing.Color]$cBit,
                         [System.Drawing.Color]$cJit,
                         [System.Drawing.Color]$cLos) {
        $isTCP = $script:isTCPLog[$fn]
        Add-CL "======================`n" $sep
        Add-CL "  [$tag] " $cBit
        Add-CL "$fn`n" $fg
        if ($isTCP) { Add-CL "  [TCP or Direct - Bitrate only]`n" $t.FgDim }
        Add-CL "----------------------`n" $sep

        $bMin = ($data.Bitrate | Measure-Object -Min).Minimum
        $bMax = ($data.Bitrate | Measure-Object -Max).Maximum
        $bAvg = [math]::Round(($data.Bitrate | Measure-Object -Average).Average, 1)
        $bMinC = if ($bMin -ge $bMax*0.90){'LimeGreen'} elseif ($bMin -ge $bMax*0.75){'Yellow'} elseif ($bMin -ge $bMax*0.50){'Orange'} else {'Red'}

        Add-CL "  BITRATE (Mbps)`n" $cBit
        Add-CL "  MIN: " $fg; Add-CL "$bMin`n" ([System.Drawing.Color]::$bMinC)
        Add-CL "  AVG: $bAvg`n" $fg
        Add-CL "  MAX: $bMax`n`n" $fg

        if (-not $isTCP) {
            $jMin = [math]::Round(($data.Jitter | Measure-Object -Min).Minimum, 3)
            $jMax = [math]::Round(($data.Jitter | Measure-Object -Max).Maximum, 3)
            $jAvg = [math]::Round(($data.Jitter | Measure-Object -Average).Average, 3)

            Add-CL "  JITTER (ms)`n" $cJit
            Add-CL "  MIN: " $fg; Add-CL "$jMin`n" (Get-JitterColor $jMin)
            Add-CL "  AVG: $jAvg`n" $fg
            Add-CL "  MAX: " $fg; Add-CL "$jMax`n`n" (Get-JitterColor $jMax)

        $lMin = [math]::Round(($data.Loss | Measure-Object -Min).Minimum, 2)
        $lMax = [math]::Round(($data.Loss | Measure-Object -Max).Maximum, 2)
        $lAvg = [math]::Round(($data.Loss | Measure-Object -Average).Average, 2)

        Add-CL "  LOSS (%)`n" $cLos
        Add-CL "  MIN: " $fg; Add-CL "$lMin %`n" (Get-LossColor $lMin)
        Add-CL "  AVG: " $fg; Add-CL "$lAvg %`n" (Get-LossColor $lAvg)
        Add-CL "  MAX: " $fg; Add-CL "$lMax %`n" (Get-LossColor $lMax)

        $td = $script:totalsData[$fn]
        Add-CL "  PKTS LOST:`n" $cLos
        Add-CL "  " $fg
        if ($null -ne $td) {
            Add-CL "$($td.Lost)" (Get-LostPktColor $td.Lost $td.Total)
            Add-CL " / $($td.Total)`n" $fg
        } else { Add-CL "n/a`n" $fg }
        }   # end if (-not $isTCP)
    }

    Print-Block $dataA $fnA "A" $t.Bit  $t.Jit  $t.Los
    if ($null -ne $dataB) {
        Print-Block $dataB $fnB "B" $t.Bit2 $t.Jit2 $t.Los2
    }

    Add-CL "======================`n" $sep
    Add-CL "  TEST INFO`n" $t.AccentB
    $pc = $t.AccentA
    Add-CL "  Label:    " $pc; Add-CL "$Label`n"         $fg
    Add-CL "  Protocol: " $pc; Add-CL "$Protocol`n"      $fg
    Add-CL "  Interval: " $pc; Add-CL "$Interval`n"      $fg
    Add-CL "  Streams:  " $pc; Add-CL "$Streams`n"       $fg
    Add-CL "  Duration: " $pc; Add-CL "$Duration`n"      $fg
    Add-CL "  Bitrate:  " $pc; Add-CL "$TBitrate`n" $fg
}

# ================================================================
#  VERDICT BOX
# ================================================================
function Get-VerdictEntry([double]$val, [string]$metric) {
    # Returns [label, color] based on metric thresholds
    switch ($metric) {
        "loss" {
            if ($val -eq 0)    { return @("PERFECT",  [System.Drawing.Color]::LimeGreen) }
            if ($val -le 0.1)  { return @("GOOD",     [System.Drawing.Color]::LimeGreen) }
            if ($val -le 1.0)  { return @("MODERATE", [System.Drawing.Color]::Yellow) }
            if ($val -le 3.0)  { return @("HIGH",     [System.Drawing.Color]::Orange) }
            return               @("CRITICAL", [System.Drawing.Color]::Red)
        }
        "jitter" {
            if ($val -lt 0.2)  { return @("EXCELLENT",[System.Drawing.Color]::LimeGreen) }
            if ($val -lt 0.8)  { return @("GOOD",     [System.Drawing.Color]::Yellow) }
            if ($val -lt 1.2)  { return @("POOR",     [System.Drawing.Color]::Orange) }
            return               @("CRITICAL", [System.Drawing.Color]::Red)
        }
        "bitrate" {
            # val is passed as ratio: actual/max
            if ($val -ge 0.90) { return @("EXCELLENT",[System.Drawing.Color]::LimeGreen) }
            if ($val -ge 0.75) { return @("GOOD",     [System.Drawing.Color]::Yellow) }
            if ($val -ge 0.50) { return @("POOR",     [System.Drawing.Color]::Orange) }
            return               @("CRITICAL", [System.Drawing.Color]::Red)
        }
    }
}

function Update-Verdict([array]$dataA, [string]$fnA, [array]$dataB, [string]$fnB) {
    $t  = $script:theme
    $verdictBox.Clear()
    $verdictBox.BackColor  = $t.Panel
    $verdictPanel.BackColor = $t.Panel

    function Add-VL([string]$text, [System.Drawing.Color]$color) {
        $verdictBox.SelectionStart = $verdictBox.TextLength
        $verdictBox.SelectionColor = $color
        $verdictBox.AppendText($text)
    }

    # Layout:
    #  A:   Loss    x.xx%   VERDICT
    #       Jitter  x.xxx ms VERDICT
    #       Bitrate xx%     VERDICT
    function Print-Verdict([array]$data, [string]$tag, [System.Drawing.Color]$tagColor) {
        $lAvg   = [math]::Round(($data.Loss   | Measure-Object -Average).Average, 2)
        $jMax   = [math]::Round(($data.Jitter | Measure-Object -Max).Maximum, 3)
        $bMin   = ($data.Bitrate | Measure-Object -Min).Minimum
        $bMax   = ($data.Bitrate | Measure-Object -Max).Maximum
        $bRatio = if ($bMax -gt 0) { $bMin / $bMax } else { 0 }
        $bPct   = [math]::Round($bRatio * 100)

        $vLoss = Get-VerdictEntry $lAvg   "loss"
        $vJit  = Get-VerdictEntry $jMax   "jitter"
        $vBit  = Get-VerdictEntry $bRatio "bitrate"

        $fgVal = [System.Drawing.Color]::FromArgb(210, 210, 215)
        $isTCP = ($data | Where-Object { $_.IsTCP } | Select-Object -First 1) -ne $null

        Add-VL " ${tag}: " $tagColor
        Add-VL "Loss    " $t.Fg
        if ($isTCP) {
#            Add-VL "  n/a (TCP)`n" $t.FgDim
            Add-VL "  n/a (TCP or Direct)`n" $t.FgDim
        } else {
            Add-VL "$($lAvg.ToString('0.00').PadLeft(5))%  " $fgVal
            Add-VL "$($vLoss[0])`n" $vLoss[1]
        }
        Add-VL "     "  $t.FgDim
        Add-VL "Jitter  " $t.Fg
        if ($isTCP) {
#            Add-VL "  n/a (TCP)`n" $t.FgDim
            Add-VL "  n/a (TCP or Direct)`n" $t.FgDim
        } else {
            Add-VL "$($jMax.ToString('0.000')) ms " $fgVal
            Add-VL "$($vJit[0])`n"  $vJit[1]
        }
        Add-VL "     "  $t.FgDim
        Add-VL "Bitrate " $t.Fg
        Add-VL "$($bPct.ToString().PadLeft(3))%      " $fgVal
        Add-VL "$($vBit[0])" $vBit[1]
    }

    # Leading blank line pushes content away from top border
    Print-Verdict $dataA "A" $t.Bit
    if ($null -ne $dataB) {
        Add-VL "`n" $t.Sep
        Add-VL " -----------------------------------------------`n" $t.Sep
        Print-Verdict $dataB "B" $t.Bit2
    }
}

# ================================================================
#  CHART ENGINE
# ================================================================
function Apply-Theme-To-Controls {
    $t = $script:theme
    $form.BackColor           = $t.Bg
    $panel.BackColor          = $t.Panel
    $statsContainer.BackColor = $t.Panel
    $statsBox.BackColor       = $t.Panel
    $lblStatsTitle.ForeColor  = $t.Fg
    $lblZoom.ForeColor        = $t.Fg
    $verdictPanel.BackColor   = $t.Panel
    $verdictBox.BackColor     = $t.Panel
    $verdictBox.ForeColor     = $t.Fg

    foreach ($c in @($btnSave, $btnHelp, $btnLegend, $btnDark, $combo, $combo2,
                     $btnZoomIn, $btnZoomOut, $btnSummary, $btnExport,
                     $btnA, $btnB, $btnAllLogs, $btnLoadA, $btnLoadB)) {
        $c.BackColor = $t.Ctrl
        $c.ForeColor = if ($c -eq $btnA) { $t.Bit }
                       elseif ($c -eq $btnB) { $t.Bit2 }
                       else { $t.Fg }
        if ($c -is [System.Windows.Forms.Button]) {
            $c.FlatAppearance.BorderColor = $t.CtrlBorder
            $c.FlatAppearance.BorderSize  = 1
        }
    }
    # All Logs toggle: highlight when active
    if ($script:showAllLogs) {
        $btnAllLogs.BackColor = $t.AccentA
        $btnAllLogs.ForeColor = $t.Bg
    }
    Reposition-RightButtons
}

function Make-ChartArea([string]$name, [string]$yTitle, [bool]$showXTitle, [bool]$showScroll) {
    $t = $script:theme
    $a = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea($name)
    $a.BackColor                  = $t.Bg
    $a.AxisX.MajorGrid.LineColor  = $t.Grid
    $a.AxisY.MajorGrid.LineColor  = $t.Grid
    $a.AxisX.LabelStyle.ForeColor = $t.Fg
    $a.AxisY.LabelStyle.ForeColor = $t.Fg
    $a.AxisX.LineColor            = $t.Grid
    $a.AxisY.LineColor            = $t.Grid
    $a.AxisX.Title                = if ($showXTitle) { "Time (seconds)" } else { "" }
    $a.AxisX.TitleForeColor       = $t.Fg
    $a.AxisY.Title                = $yTitle
    $a.AxisY.TitleForeColor       = $t.Fg
    $a.AxisX.LabelStyle.Font      = $fntMonoS
    $a.AxisY.LabelStyle.Font      = $fntMonoS
    $a.AxisX.LabelStyle.Format    = "0.##"
    $a.AxisX.ScaleView.Zoomable   = $true
    $a.CursorX.IsUserEnabled           = $false
    $a.CursorX.IsUserSelectionEnabled  = $false
    $a.CursorX.LineColor               = $t.Cursor
    $a.CursorX.LineWidth               = 2
    $a.InnerPlotPosition.Auto   = $false
    $a.InnerPlotPosition.X      = 8
    $a.InnerPlotPosition.Width  = 90
    $a.InnerPlotPosition.Y      = 6
    $a.InnerPlotPosition.Height = 82
    $a.AxisX.ScrollBar.Enabled   = $showScroll
    if ($showScroll) {
        $a.AxisX.ScrollBar.BackColor   = $t.Bg
        $a.AxisX.ScrollBar.ButtonColor = $t.Ctrl
    }
    return $a
}

function Add-StripLine([System.Windows.Forms.DataVisualization.Charting.Axis]$axis,
                        [double]$offset, [System.Drawing.Color]$color, [string]$label,
                        [double]$width=0, [System.Drawing.Color]$fillColor) {
    $sl = New-Object System.Windows.Forms.DataVisualization.Charting.StripLine
    $sl.IntervalOffset  = $offset
    $sl.BorderColor     = [System.Drawing.Color]::FromArgb(190, $color)
    $sl.BorderDashStyle = "Dash"
    $sl.Text            = "  $label"
    $sl.ForeColor       = $color
    $sl.Font            = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
    if ($width -gt 0) { $sl.StripWidth = $width; $sl.BackColor = $fillColor }
    $axis.StripLines.Add($sl)
}

function Update-Chart([string]$fileNameA, [string]$fileNameB) {
    $t     = $script:theme
    $dataA = if ($fileNameA -and $allTestData.ContainsKey($fileNameA)) { $allTestData[$fileNameA] } else { $null }
    $dataB = if ($fileNameB -and $allTestData.ContainsKey($fileNameB)) { $allTestData[$fileNameB] } else { $null }

    Apply-Theme-To-Controls

    $chart.ChartAreas.Clear()
    $chart.Series.Clear()
    $chart.Titles.Clear()
    $chart.BackColor = $t.Bg

    if ($null -eq $dataA) {
        # No data — show placeholder
        $script:titleFileA = "No data loaded"
        $script:titleFileB = $null
        $script:titleBitColor  = $t.FgDim
        $script:titleBit2Color = $t.Bit2
        $script:titleBg        = $t.Bg
        $script:titleFont      = $fntTitle
        $script:paintGen = [int]([datetime]::Now.Ticks % 1000000)
        $script:myPaintGen = $script:paintGen
        $chart.Add_PostPaint({
            param($cs, $ce)
            if ($script:myPaintGen -ne $script:paintGen) { return }
            $g = $ce.ChartGraphics.Graphics
            $br = New-Object System.Drawing.SolidBrush($script:titleBitColor)
            $sz = $g.MeasureString($script:titleFileA, $script:titleFont)
            $g.DrawString($script:titleFileA, $script:titleFont, $br, [int](($chart.Width - $sz.Width)/2), 4)
            $br.Dispose()
        })
        $verdictBox.Clear(); $verdictBox.BackColor = $t.Panel
        $verdictPanel.BackColor = $t.Panel
        $statsBox.Clear()
        Reposition-Verdict
        return
    }

    # Title drawn entirely via PostPaint (no Chart.Titles entry) so there
    # is exactly ONE rendering — no duplicate. We reserve vertical space by
    # adjusting InnerPlotPosition.Y later; the paint event covers the gap.
    $script:titleFileA     = $fileNameA
    $script:titleFileB     = if ($null -ne $dataB) { $fileNameB } else { $null }
    $script:titleBitColor  = $t.Bit
    $script:titleBit2Color = $t.Bit2
    $script:titleBitDim    = [System.Drawing.Color]::FromArgb(80, $t.Bit.R,  $t.Bit.G,  $t.Bit.B)
    $script:titleBit2Dim   = [System.Drawing.Color]::FromArgb(80, $t.Bit2.R, $t.Bit2.G, $t.Bit2.B)
    $script:titleSepColor  = $t.Sep
    $script:titleBg        = $t.Bg
    $script:titleFont      = $fntTitle

    # Remove any previously registered PostPaint handlers cleanly by rebuilding
    # the chart object isn't practical, so we guard with a flag updated each call.
    $script:paintGen = [int]([datetime]::Now.Ticks % 1000000)  # unique per Update-Chart call
    $script:myPaintGen = $script:paintGen

    $chart.Add_PostPaint({
        param($cs, $ce)
        # Only act for the generation that registered us
        if ($script:myPaintGen -ne $script:paintGen) { return }
        $g     = $ce.ChartGraphics.Graphics
        $fullW = $chart.Width
        $titleH = [int]($script:titleFont.GetHeight() + 10)

        # Vertically center title within the top margin zone (7% of chart height)
        $topZoneH = $chart.Height * 0.07
        $titleY   = [int](($topZoneH - $script:titleFont.GetHeight()) / 2)
        if ($titleY -lt 2) { $titleY = 2 }

        # Background strip
        $bgBrush = New-Object System.Drawing.SolidBrush($script:titleBg)
        $g.FillRectangle($bgBrush, 0, 0, $fullW, [int]$topZoneH)
        $bgBrush.Dispose()

        if ($null -ne $script:titleFileB) {
            # "A:" bright, filename dim, " | " sep, "B:" bright, filename dim
            $lblA   = "A: ";  $fileA = $script:titleFileA
            $sep    = "    |    "
            $lblB   = "B: ";  $fileB = $script:titleFileB

            $szLblA  = $g.MeasureString($lblA,  $script:titleFont)
            $szFileA = $g.MeasureString($fileA, $script:titleFont)
            $szSep   = $g.MeasureString($sep,   $script:titleFont)
            $szLblB  = $g.MeasureString($lblB,  $script:titleFont)
            $szFileB = $g.MeasureString($fileB, $script:titleFont)
            $szFull  = $g.MeasureString($lblA + $fileA + $sep + $lblB + $fileB, $script:titleFont)

            $startX = [int](($fullW - $szFull.Width) / 2)
            $x = $startX

            $brushA   = New-Object System.Drawing.SolidBrush($script:titleBitColor)
            $brushADim= New-Object System.Drawing.SolidBrush($script:titleBitDim)
            $brushB   = New-Object System.Drawing.SolidBrush($script:titleBit2Color)
            $brushBDim= New-Object System.Drawing.SolidBrush($script:titleBit2Dim)
            $brushSep = New-Object System.Drawing.SolidBrush($script:titleSepColor)

            $g.DrawString($lblA,  $script:titleFont, $brushA,    $x, $titleY); $x += $szLblA.Width
            $g.DrawString($fileA, $script:titleFont, $brushADim, $x, $titleY); $x += $szFileA.Width
            $g.DrawString($sep,   $script:titleFont, $brushSep,  $x, $titleY); $x += $szSep.Width
            $g.DrawString($lblB,  $script:titleFont, $brushB,    $x, $titleY); $x += $szLblB.Width
            $g.DrawString($fileB, $script:titleFont, $brushBDim, $x, $titleY)

            $brushA.Dispose(); $brushADim.Dispose()
            $brushB.Dispose(); $brushBDim.Dispose(); $brushSep.Dispose()
        } else {
            $brushA = New-Object System.Drawing.SolidBrush($script:titleBitColor)
            $szFull = $g.MeasureString($script:titleFileA, $script:titleFont)
            $startX = [int](($fullW - $szFull.Width) / 2)
            $g.DrawString($script:titleFileA, $script:titleFont, $brushA, $startX, $titleY)
            $brushA.Dispose()
        }
    })

    # Chart areas
    $areaB = Make-ChartArea "Bitrate" "Mbits/sec"   $false $false
    $areaJ = Make-ChartArea "Jitter"  "Jitter (ms)" $false $false
    $areaL = Make-ChartArea "Loss"    "Loss (%)"    $true  $true

    $maxB = ($dataA.Bitrate | Measure-Object -Max).Maximum
    if ($null -ne $dataB) {
        $maxB2 = ($dataB.Bitrate | Measure-Object -Max).Maximum
        if ($maxB2 -gt $maxB) { $maxB = $maxB2 }
    }
    if ($maxB -gt 0) {
        # Give 8% headroom above maxB so the auto-generated top Y-axis label
        # has room and doesn't collide with the file-name title above the chart
        $areaB.AxisY.Maximum = $maxB * 1.08
        Add-StripLine $areaB.AxisY $maxB           $t.Fg        "MAX ($maxB Mbps)"
        Add-StripLine $areaB.AxisY ($maxB * 0.90)  $t.GreenLvl  "90% EXCELLENT"
        Add-StripLine $areaB.AxisY ($maxB * 0.75)  ([System.Drawing.Color]::Yellow) "75% WARNING"
        Add-StripLine $areaB.AxisY ($maxB * 0.50)  ([System.Drawing.Color]::Red)    "50% CRITICAL"
    }
    $areaJ.AxisY.Maximum = 1.5
    Add-StripLine $areaJ.AxisY 0.2  $t.GreenLvl                          "0.2ms EXCELLENT"
    Add-StripLine $areaJ.AxisY 0.8  ([System.Drawing.Color]::Yellow)     "0.8ms WARNING"
    Add-StripLine $areaJ.AxisY 1.2  ([System.Drawing.Color]::Red)        "1.2ms CRITICAL"
    $areaL.AxisY.Maximum = 100
    Add-StripLine $areaL.AxisY 0   ([System.Drawing.Color]::Transparent) "" 1.0 ([System.Drawing.Color]::FromArgb(35,0,220,0))
    Add-StripLine $areaL.AxisY 1.0 $t.Thresh "LIMIT (1%)"

    $chart.ChartAreas.Add($areaB)
    $chart.ChartAreas.Add($areaJ)
    $chart.ChartAreas.Add($areaL)

    # Explicit equal-height layout for all three areas, with a top margin
    # reserved for the file-name title drawn via PostPaint.
    $topMargin    = 6.0   # % of chart height reserved for title
    $bottomMargin = 5.0   # % of chart height reserved for "Time (seconds)" label
    $rowH = (100.0 - $topMargin - $bottomMargin) / 3.0
    $i = 0
    foreach ($a in $chart.ChartAreas) {
        $a.Position.Auto   = $false
        $a.Position.X      = 0
        $a.Position.Width  = 100
        $a.Position.Y      = $topMargin + ($i * $rowH)
        $a.Position.Height = $rowH
        $i++
    }

    # Series
    function Add-Series([string]$name,[string]$area,[System.Drawing.Color]$color,
                        [array]$data,[string]$prop,[bool]$dashed=$false,[bool]$visible=$true) {
        $s = New-Object System.Windows.Forms.DataVisualization.Charting.Series($name)
        $s.ChartArea   = $area
        $s.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
        $s.BorderWidth = 2; $s.Color = $color; $s.Enabled = $visible
        if ($dashed) { $s.BorderDashStyle = [System.Windows.Forms.DataVisualization.Charting.ChartDashStyle]::Dash }
        foreach ($p in $data) { [void]$s.Points.AddXY($p.Time, $p.$prop) }
        $chart.Series.Add($s)
    }

    Add-Series "Bitrate_A" "Bitrate" $t.Bit  $dataA "Bitrate" $false $script:showA
    Add-Series "Jitter_A"  "Jitter"  $t.Jit  $dataA "Jitter"  $false $script:showA
    Add-Series "Loss_A"    "Loss"    $t.Los  $dataA "Loss"    $false $script:showA
    if ($null -ne $dataB) {
        Add-Series "Bitrate_B" "Bitrate" $t.Bit2 $dataB "Bitrate" $true $script:showB
        Add-Series "Jitter_B"  "Jitter"  $t.Jit2 $dataB "Jitter"  $true $script:showB
        Add-Series "Loss_B"    "Loss"    $t.Los2 $dataB "Loss"    $true $script:showB
    }

    # For TCP logs: hide Jitter/Loss series and annotate chart areas
    $tcpA = $script:isTCPLog[$fileNameA]
    $tcpB = if ($null -ne $dataB) { $script:isTCPLog[$fileNameB] } else { $false }

    if ($tcpA) {
        ($chart.Series | Where-Object { $_.Name -eq "Jitter_A" -or $_.Name -eq "Loss_A" }) |
            ForEach-Object { $_.Enabled = $false }
    }
    if ($tcpB) {
        ($chart.Series | Where-Object { $_.Name -eq "Jitter_B" -or $_.Name -eq "Loss_B" }) |
            ForEach-Object { $_.Enabled = $false }
    }

    # Label Jitter/Loss areas as N/A if both datasets are TCP
    if ($tcpA -and ($null -eq $dataB -or $tcpB)) {
        foreach ($aName in @("Jitter","Loss")) {
            $ca = $chart.ChartAreas | Where-Object { $_.Name -eq $aName }
            if ($ca) {
                $ann = New-Object System.Windows.Forms.DataVisualization.Charting.Title("N/A (TCP or Direct - no $aName data)")
                $ann.Font      = New-Object System.Drawing.Font("Consolas", 9)
                $ann.ForeColor = $t.FgDim
                $ann.DockedToChartArea = $aName
                $ann.IsDockedInsideChartArea = $true
                $ann.Alignment = [System.Drawing.ContentAlignment]::MiddleCenter
                $chart.Titles.Add($ann)
            }
        }
    }

    # Verdict box
    Update-Verdict $dataA $fileNameA $dataB $fileNameB
    Reposition-Verdict

    # Window title warn flag
    $avgLossA = [math]::Round(($dataA.Loss | Measure-Object -Average).Average, 2)
    $isWarn   = $avgLossA -gt $warnLossThreshold
    if ($null -ne $dataB) {
        $avgLossB = [math]::Round(($dataB.Loss | Measure-Object -Average).Average, 2)
        if ($avgLossB -gt $warnLossThreshold) { $isWarn = $true }
    }
    $form.Text = if ($isWarn) { "iPerf3 v3.48  [!] HIGH LOSS" } else { "iPerf3 v3.48 Visual Diagnostic" }

    Update-Stats $dataA $fileNameA $dataB $fileNameB
}

# ================================================================
#  TOGGLE A / B VISIBILITY
# ================================================================
function Toggle-Series([string]$prefix, [bool]$visible) {
    foreach ($s in $chart.Series) {
        if ($s.Name.StartsWith($prefix)) { $s.Enabled = $visible }
    }
    $chart.Invalidate()
}
$btnA.Add_Click({
    $script:showA = -not $script:showA
    $btnA.Text    = if ($script:showA) { "A" } else { "A-" }
    Toggle-Series "Bitrate_A" $script:showA
    Toggle-Series "Jitter_A"  $script:showA
    Toggle-Series "Loss_A"    $script:showA
})
$btnB.Add_Click({
    $script:showB = -not $script:showB
    $btnB.Text    = if ($script:showB) { "B" } else { "B-" }
    Toggle-Series "Bitrate_B" $script:showB
    Toggle-Series "Jitter_B"  $script:showB
    Toggle-Series "Loss_B"    $script:showB
})

# ================================================================
#  TOOLTIP ON MOUSE MOVE
# ================================================================
# Tooltip and drag handled in Add_MouseMove below

# ================================================================
#  SUMMARY WINDOW
#  Single click = highlight row
#  Double click = load as B and close
# ================================================================
function Show-Summary {
    $t  = $script:theme
    $sw = New-Object System.Windows.Forms.Form
    $sw.Text            = "Summary -- All Sessions"
    $sw.Width           = 920; $sw.Height = 500
    $sw.StartPosition   = "CenterParent"
    $sw.BackColor       = $t.Bg

    $hint           = New-Object System.Windows.Forms.Label
    $hint.Text      = "  Single click: select row    Double click: load as Graph B and close"
    $hint.Dock      = "Bottom"; $hint.Height = 24
    $hint.ForeColor = $t.FgDim; $hint.Font = $fntMonoS
    $hint.BackColor = $t.Panel
    $sw.Controls.Add($hint)

    $grid                         = New-Object System.Windows.Forms.DataGridView
    $grid.Dock                    = "Fill"
    $grid.ReadOnly                = $true
    $grid.AllowUserToAddRows      = $false
    $grid.BackgroundColor         = $t.Bg
    $grid.ForeColor               = $t.Fg
    $grid.GridColor               = $t.Grid
    $grid.SelectionMode           = "FullRowSelect"
    $grid.MultiSelect             = $false
    $grid.ColumnHeadersDefaultCellStyle.BackColor = $t.Panel
    $grid.ColumnHeadersDefaultCellStyle.ForeColor = $t.Fg
    $grid.ColumnHeadersDefaultCellStyle.Font      = $fntLabel
    $grid.DefaultCellStyle.BackColor = $t.Panel
    $grid.DefaultCellStyle.ForeColor = $t.Fg
    $grid.EnableHeadersVisualStyles  = $false
    $grid.BorderStyle             = "None"
    $grid.Font                    = $fntMonoS
    $grid.AllowUserToResizeRows  = $false
    $grid.RowHeadersVisible      = $false
    $grid.AutoSizeColumnsMode     = "AllCells"

    # Typed columns: string for File, double for numeric, int for packet counts
    $colDefs = @(
        @{Name="File";     Type=[string]},
        @{Name="Bit Min";  Type=[double]},
        @{Name="Bit Avg";  Type=[double]},
        @{Name="Bit Max";  Type=[double]},
        @{Name="Jit Min";  Type=[double]},
        @{Name="Jit Avg";  Type=[double]},
        @{Name="Jit Max";  Type=[double]},
        @{Name="Loss Min"; Type=[double]},
        @{Name="Loss Avg"; Type=[double]},
        @{Name="Loss Max"; Type=[double]},
        @{Name="Pkts Lost";Type=[int]},
        @{Name="Total";    Type=[int]}
    )
    foreach ($cd in $colDefs) {
        $c = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
        $c.Name = $cd.Name; $c.HeaderText = $cd.Name
        $c.SortMode = [System.Windows.Forms.DataGridViewColumnSortMode]::Automatic
        $c.ValueType = $cd.Type
        [void]$grid.Columns.Add($c)
    }

    $rowMap = @{}
    foreach ($fn in ($allTestData.Keys | Sort-Object)) {
        $d    = $allTestData[$fn]
        $bMin = ($d.Bitrate | Measure-Object -Min).Minimum
        $bAvg = [math]::Round(($d.Bitrate | Measure-Object -Average).Average, 1)
        $bMax = ($d.Bitrate | Measure-Object -Max).Maximum
        $jMin = [math]::Round(($d.Jitter | Measure-Object -Min).Minimum, 3)
        $jAvg = [math]::Round(($d.Jitter | Measure-Object -Average).Average, 3)
        $jMax = [math]::Round(($d.Jitter | Measure-Object -Max).Maximum, 3)
        $lMin = [math]::Round(($d.Loss | Measure-Object -Min).Minimum, 2)
        $lAvg = [math]::Round(($d.Loss | Measure-Object -Average).Average, 2)
        $lMax = [math]::Round(($d.Loss | Measure-Object -Max).Maximum, 2)
        $td   = $totalsData[$fn]
        # Use -1 for missing packet data (CSV/TCP logs) so column stays typed [int]
        $lost = if ($null -ne $td) { [int]$td.Lost  } else { [int]-1 }
        $tot  = if ($null -ne $td) { [int]$td.Total } else { [int]-1 }
        $ri   = $grid.Rows.Add($fn, $bMin, $bAvg, $bMax, $jMin, $jAvg, $jMax, $lMin, $lAvg, $lMax, $lost, $tot)
        $rowMap[$ri] = $fn
        $lossColor = if ($lAvg -eq 0) { [System.Drawing.Color]::FromArgb(255,30,60,30) }
                     elseif ($lAvg -le 1) { [System.Drawing.Color]::FromArgb(255,60,55,20) }
                     else { [System.Drawing.Color]::FromArgb(255,70,25,25) }
        $grid.Rows[$ri].DefaultCellStyle.BackColor = $lossColor
        # Display -1 as "—" in packet count cells
        if ($lost -eq -1) {
            $grid.Rows[$ri].Cells["Pkts Lost"].Value = [int]-1
            $grid.Rows[$ri].Cells["Pkts Lost"].Style.Format = ""
            $grid.Rows[$ri].Cells["Total"].Value = [int]-1
        }
    }
    # Format -1 as "—" via CellFormatting event
    $grid.Add_CellFormatting({
        param($gs, $ge)
        if ($ge.ColumnIndex -ge 10 -and $ge.Value -is [int] -and $ge.Value -eq -1) {
            $ge.Value = "n/a"
            $ge.FormattingApplied = $true
        }
    })

    # Double-click: load row as B
    $grid.Add_CellDoubleClick({
        param($gs, $ge)
        if ($ge.RowIndex -lt 0) { return }
        $clickedFn = $rowMap[$ge.RowIndex]
        if ($null -eq $clickedFn) { return }
        if ($script:isCsvRT[$clickedFn]) {
            [void]$script:alwaysVisibleKeys.Add($clickedFn)
            Refresh-ComboItems
        }
        $idx = $combo2.Items.IndexOf($clickedFn)
        if ($idx -ge 0) { $combo2.SelectedIndex = $idx }
        $sw.Close()
    })

    $sw.Controls.Add($grid)

    # Auto-size window to fit all columns after rows added
    $sw.Add_Shown({
        $totalW = ($grid.Columns | Measure-Object -Property Width -Sum).Sum
        $totalW += $grid.RowHeadersWidth + 20   # scrollbar margin
        $sw.Width = [math]::Max(700, [math]::Min($totalW + 20, [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - 40))
        $sw.Left  = ([System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width - $sw.Width) / 2
    })
    $sw.ShowDialog()
}

# ================================================================
#  CSV EXPORT
# ================================================================
function Export-CSV {
    $fn      = $combo.SelectedItem.ToString()
    $data    = $allTestData[$fn]
    $outDir  = if ($outPath -ne '') { $outPath } elseif (Test-Path $Path -PathType Container) { $Path } else { (Get-Item $Path).DirectoryName }
    $baseName = ($fn -replace '\.[^.]+$', '') + "_export.csv"
    $csvPath  = Join-Path $outDir $baseName
    $lines    = [System.Collections.Generic.List[string]]::new()
    $lines.Add("Time,Bitrate_Mbps,Jitter_ms,Loss_pct")
    foreach ($p in $data) { $lines.Add("$($p.Time),$($p.Bitrate),$($p.Jitter),$($p.Loss)") }
    [System.IO.File]::WriteAllLines($csvPath, $lines, [System.Text.Encoding]::UTF8)
    [System.Windows.Forms.MessageBox]::Show("CSV saved to:`n$csvPath", "Export Complete")
}

# ================================================================
#  ZOOM + MOUSE WHEEL
# ================================================================
function Get-MaxTime {
    ($allTestData[$combo.SelectedItem.ToString()].Time | Measure-Object -Max).Maximum
}
function Do-Zoom([double]$factor) {
    if ($chart.ChartAreas.Count -eq 0) { return }
    $area = $chart.ChartAreas[0]
    $maxT = Get-MaxTime
    if ($maxT -le 0) { return }

    # Get current view; if not zoomed use full range
    $isZoomed = $area.AxisX.ScaleView.IsZoomed
    $viewMin  = if ($isZoomed) { $area.AxisX.ScaleView.ViewMinimum } else { 0 }
    $viewMax  = if ($isZoomed) { $area.AxisX.ScaleView.ViewMaximum } else { $maxT }
    $range    = $viewMax - $viewMin
    if ($range -le 0) { $range = $maxT }

    $curPos  = $area.CursorX.Position
    $center  = if (-not [double]::IsNaN($curPos) -and $curPos -gt $viewMin -and $curPos -lt $viewMax) {
        $curPos
    } else {
        $viewMin + $range / 2
    }

    $newRange = $range * $factor
    if ($newRange -lt 0.1) { return }

    # Factor < 1 means zoom in; if new range >= full range -> reset
    if ($newRange -ge $maxT) {
        foreach ($a in $chart.ChartAreas) { $a.AxisX.ScaleView.ZoomReset(0) }
        $chart.Invalidate(); return
    }

    $newMin = $center - ($center - $viewMin) / $range * $newRange
    $newMin = [math]::Max(0, $newMin)
    if ($newMin + $newRange -gt $maxT) { $newMin = $maxT - $newRange }

    foreach ($a in $chart.ChartAreas) { $a.AxisX.ScaleView.Zoom($newMin, $newMin + $newRange) }
}
function Do-Scroll([double]$delta) {
    if ($chart.ChartAreas.Count -eq 0) { return }
    $area = $chart.ChartAreas[0]
    if (-not $area.AxisX.ScaleView.IsZoomed) { return }
    $viewMin = $area.AxisX.ScaleView.ViewMinimum
    $viewMax = $area.AxisX.ScaleView.ViewMaximum
    $range   = $viewMax - $viewMin
    if ($range -le 0) { return }
    $maxT    = Get-MaxTime
    $step    = $range * 0.15 * $delta
    $newMin  = [math]::Max(0, [math]::Min($viewMin + $step, $maxT - $range))
    foreach ($a in $chart.ChartAreas) { $a.AxisX.ScaleView.Zoom($newMin, $newMin + $range) }
}
$chart.Add_MouseWheel({
    param($s, $e)
    if ($chart.ChartAreas.Count -eq 0) { return }
    $ctrl     = [System.Windows.Forms.Control]::ModifierKeys -band [System.Windows.Forms.Keys]::Control
    $isZoomed = $chart.ChartAreas[0].AxisX.ScaleView.IsZoomed
    if ($ctrl) {
        if ($e.Delta -gt 0) { Do-Zoom 0.8 } else { Do-Zoom 1.25 }
    } elseif ($isZoomed) {
        if ($e.Delta -gt 0) { Do-Scroll -1 } else { Do-Scroll 1 }
    }
})

# ================================================================
#  SYNC ZOOM (AxisViewChanged only — no cursor sync needed)
# ================================================================
$script:syncLock = $false

$chart.Add_AxisViewChanged({
    param($s, $e)
    if ($null -eq $e.Axis -or $e.Axis.AxisName -ne "X") { return }
    if ($script:syncLock) { return }
    $script:syncLock = $true
    try {
        $vMin = $e.Axis.ScaleView.ViewMinimum
        $vMax = $e.Axis.ScaleView.ViewMaximum
        foreach ($a in $chart.ChartAreas) {
            if ($a.Name -ne $e.ChartArea.Name) { $a.AxisX.ScaleView.Zoom($vMin, $vMax) }
        }
    } finally { $script:syncLock = $false }
})

# ================================================================
#  MANUAL MOUSE INTERACTION
#  Left click  = snap marker to nearest data point
#  Left drag   = rubber-band select -> zoom to that time range
#  Right click = reset zoom and marker
# ================================================================
$script:dragStart    = -1.0   # data-X where drag began (-1 = no drag)
$script:dragStartPx  = -1     # pixel X where drag began
$script:dragCurPx    = -1     # current pixel X during drag (for rubber-band)
$script:isDragging   = $false

# Paint overlay — rubber-band selection rectangle during drag
$chart.Add_Paint({
    param($s, $e)
    if (-not $script:isDragging -or $script:dragStartPx -lt 0 -or $script:dragCurPx -lt 0) { return }
    $x1 = [math]::Min($script:dragStartPx, $script:dragCurPx)
    $x2 = [math]::Max($script:dragStartPx, $script:dragCurPx)
    if ($x2 - $x1 -lt 2) { return }
    $g  = $e.Graphics
    $fb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(50, 100, 180, 255))
    $g.FillRectangle($fb, $x1, 0, $x2 - $x1, $chart.Height)
    $fb.Dispose()
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 120, 200, 255), 1)
    $pen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
    $g.DrawLine($pen, $x1, 0, $x1, $chart.Height)
    $g.DrawLine($pen, $x2, 0, $x2, $chart.Height)
    $pen.Dispose()
})

# Helper: convert pixel X on chart control to nearest data Time value
function Px-ToDataX([int]$pixelX) {
    if ($chart.ChartAreas.Count -eq 0) { return [double]::NaN }
    $area = $chart.ChartAreas[0]
    try {
        $val = $area.AxisX.PixelPositionToValue($pixelX)
        # Snap to nearest actual data point
        $fnA  = $combo.SelectedItem.ToString()
        $data = $allTestData[$fnA]
        if (-not $data) { return [math]::Round($val, 3) }
        $nearest = $data | Sort-Object { [math]::Abs($_.Time - $val) } | Select-Object -First 1
        return $nearest.Time
    } catch { return [double]::NaN }
}

# Helper: is pixel X inside any chart plot area?
function Px-InPlotArea([int]$pixelX, [int]$pixelY) {
    if ($chart.ChartAreas.Count -eq 0) { return $false }
    $chartW = [double]$chart.Width
    $chartH = [double]$chart.Height
    $xPct   = ($pixelX / $chartW) * 100.0
    $yPct   = ($pixelY / $chartH) * 100.0
    foreach ($a in $chart.ChartAreas) {
        # Use Position (outer area bounds in %)
        $p = $a.Position
        if ($xPct -ge $p.X -and $xPct -le ($p.X + $p.Width) -and
            $yPct -ge $p.Y -and $yPct -le ($p.Y + $p.Height)) {
            return $true
        }
    }
    return $false
}

$chart.Add_MouseDown({
    param($s, $e)
    if (-not (Px-InPlotArea $e.X $e.Y)) { return }

    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $script:dragStartPx = $e.X
        $script:dragStart   = Px-ToDataX $e.X
        $script:isDragging  = $false
    }
})

$chart.Add_MouseMove({
    param($s, $e)
    # Tooltip (always)
    try {
        if ($chart.ChartAreas.Count -gt 0 -and (Px-InPlotArea $e.X $e.Y)) {
            $xVal    = $chart.ChartAreas[0].AxisX.PixelPositionToValue($e.X)
            $fnA     = $combo.SelectedItem.ToString()
            $nearest = $allTestData[$fnA] | Sort-Object { [math]::Abs($_.Time - $xVal) } | Select-Object -First 1
            if ($nearest) {
                $tip = "--- A ---`nT = $($nearest.Time) s`nBitrate: $($nearest.Bitrate) Mbps`nJitter:  $($nearest.Jitter) ms`nLoss:    $($nearest.Loss) %"
                $fnB = if ($combo2.SelectedIndex -gt 0) { $combo2.SelectedItem.ToString() } else { $null }
                if ($fnB -and $allTestData.ContainsKey($fnB)) {
                    $nb = $allTestData[$fnB] | Sort-Object { [math]::Abs($_.Time - $xVal) } | Select-Object -First 1
                    if ($nb) { $tip += "`n--- B ---`nT = $($nb.Time) s`nBitrate: $($nb.Bitrate) Mbps`nJitter:  $($nb.Jitter) ms`nLoss:    $($nb.Loss) %" }
                }
                $toolTip.SetToolTip($chart, $tip)
            }
        } else { $toolTip.SetToolTip($chart, "") }
    } catch {}

    # Drag detection — mark as dragging after 4px movement
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left -and $script:dragStart -ge 0) {
        if ([math]::Abs($e.X - $script:dragStartPx) -gt 4) {
            $script:isDragging = $true
        }
        if ($script:isDragging) {
            $script:dragCurPx = $e.X
            # Show cursor line at current position
            $curX = Px-ToDataX $e.X
            if (-not [double]::IsNaN($curX)) {
                foreach ($a in $chart.ChartAreas) { $a.CursorX.Position = $curX }
            }
            $chart.Invalidate()
        }
    }
})

$chart.Add_MouseUp({
    param($s, $e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $endX = Px-ToDataX $e.X

        if ($script:isDragging -and $script:dragStart -ge 0 -and -not [double]::IsNaN($endX)) {
            # Drag ended — zoom to selected range
            $t1 = [math]::Min($script:dragStart, $endX)
            $t2 = [math]::Max($script:dragStart, $endX)
            if (($t2 - $t1) -gt 0.05) {
                foreach ($a in $chart.ChartAreas) { $a.AxisX.ScaleView.Zoom($t1, $t2) }
                # Clear cursor after zoom
                foreach ($a in $chart.ChartAreas) { $a.CursorX.Position = [double]::NaN }
            }
        } elseif (-not $script:isDragging -and $script:dragStart -ge 0) {
            # Simple click — snap marker to nearest data point
            $snapX = Px-ToDataX $e.X
            if (-not [double]::IsNaN($snapX)) {
                foreach ($a in $chart.ChartAreas) { $a.CursorX.Position = $snapX }
            }
        }

        $script:dragStart   = -1.0
        $script:dragStartPx = -1
        $script:dragCurPx   = -1
        $script:isDragging  = $false
        $chart.Invalidate()
    }

    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
        foreach ($a in $chart.ChartAreas) {
            $a.AxisX.ScaleView.ZoomReset(0)
            $a.CursorX.Position = [double]::NaN
        }
        $chart.Invalidate()
    }
})

# ================================================================
#  SAVE PNG
# ================================================================
function Save-FullUI {
    $form.Activate(); $form.Refresh()
    [System.Windows.Forms.Application]::DoEvents()
    $bmp  = New-Object System.Drawing.Bitmap($form.Width, $form.Height)
    $g    = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($form.Location.X, $form.Location.Y, 0, 0, $form.Size)
    $outDir   = if ($outPath -ne '') { $outPath } elseif (Test-Path $Path -PathType Container) { $Path } else { (Get-Item $Path).DirectoryName }
    $baseName = if ([string]::IsNullOrWhiteSpace($FileName)) { $combo.SelectedItem.ToString() } else { $FileName }
    $finalName = if ($baseName -notmatch '\.png$') { $baseName + ".png" } else { $baseName }
    $outPath  = Join-Path $outDir $finalName
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    return $outPath
}

# ================================================================
#  LEGEND WINDOW
# ================================================================
function Show-Legend {
    $t  = $script:theme
    $lw = New-Object System.Windows.Forms.Form
    $lw.Text            = "Chart Legend"
    $lw.Width           = 640; $lw.Height = 580
    $lw.StartPosition   = "CenterParent"
    $lw.BackColor       = $t.Bg
    $lw.FormBorderStyle = "FixedDialog"
    $lw.MaximizeBox     = $false

    # Dimmed foreground for labels (not pure white)
    $dimFg = $t.FgDim

    # Mini demo chart
    $chart2           = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
    $chart2.Width     = 600; $chart2.Height = 140
    $chart2.Left      = 15;  $chart2.Top    = 10
    $chart2.BackColor = $t.Bg

    $demoArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea("Demo")
    $demoArea.BackColor = $t.Bg
    foreach ($axis in @($demoArea.AxisX, $demoArea.AxisY)) {
        $axis.LabelStyle.ForeColor = $dimFg
        $axis.LineColor            = $t.Grid
        $axis.MajorGrid.LineColor  = $t.Grid
    }
    $demoArea.AxisX.Title = "Time (s)"; $demoArea.AxisX.TitleForeColor = $dimFg
    $chart2.ChartAreas.Add($demoArea)

    function Add-Demo([string]$name,[System.Drawing.Color]$col,[bool]$dash,[double[]]$vals) {
        $s = New-Object System.Windows.Forms.DataVisualization.Charting.Series($name)
        $s.ChartArea = "Demo"
        $s.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
        $s.BorderWidth = 3; $s.Color = $col; $s.IsVisibleInLegend = $false
        if ($dash) { $s.BorderDashStyle = [System.Windows.Forms.DataVisualization.Charting.ChartDashStyle]::Dash }
        for ($i=0; $i -lt 5; $i++) { [void]$s.Points.AddXY($i+1, $vals[$i]) }
        $chart2.Series.Add($s)
    }
    Add-Demo "A Bitrate" $t.Bit  $false @(80,85,78,90,88)
    Add-Demo "A Jitter"  $t.Jit  $false @(20,25,18,30,22)
    Add-Demo "A Loss"    $t.Los  $false @(5,8,4,10,6)
    Add-Demo "B Bitrate" $t.Bit2 $true  @(70,72,68,75,74)
    Add-Demo "B Jitter"  $t.Jit2 $true  @(30,28,35,25,32)
    Add-Demo "B Loss"    $t.Los2 $true  @(12,10,14,8,11)
    $lw.Controls.Add($chart2)

    # Swatch panel — left=50 aligns with Y-axis label area of demo chart
    $swPanel           = New-Object System.Windows.Forms.Panel
    $swPanel.Left      = 50; $swPanel.Top = 158
    $swPanel.Width     = 573; $swPanel.Height = 390
    $swPanel.BackColor = $t.Bg
    $lw.Controls.Add($swPanel)

    $fntLegRow = New-Object System.Drawing.Font("Arial", 9)
    $fntLegSep = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Bold)

    $script:swY = 0
    function Add-SwatchRow([string]$label,[System.Drawing.Color]$col,[string]$desc) {
        $row           = New-Object System.Windows.Forms.Panel
        $row.Left      = 0; $row.Top = $script:swY; $row.Width = 608; $row.Height = 23
        $row.BackColor = $t.Bg

        $sw2           = New-Object System.Windows.Forms.Panel
        $sw2.Left      = 0; $sw2.Top = 3; $sw2.Width = 16; $sw2.Height = 16
        $sw2.BackColor = $col
        $row.Controls.Add($sw2)

        $lbl2          = New-Object System.Windows.Forms.Label
        $lbl2.Left     = 22; $lbl2.Top = 2; $lbl2.Width = 584; $lbl2.Height = 20
        $lbl2.Text     = $label.PadRight(24) + $desc
        $lbl2.ForeColor = $dimFg
        $lbl2.Font     = $fntLegRow
        $row.Controls.Add($lbl2)

        $swPanel.Controls.Add($row)
        $script:swY += 23
    }
    function Add-SwatchSep([string]$text) {
        $l           = New-Object System.Windows.Forms.Label
        $l.Left      = 0; $l.Top = $script:swY + 4; $l.Width = 608; $l.Height = 17
        $l.Text      = $text; $l.ForeColor = $t.Sep; $l.Font = $fntLegSep
        $swPanel.Controls.Add($l)
        $script:swY += 22
    }

    Add-SwatchSep "-- File A  (solid lines) --------------------------"
    Add-SwatchRow "A: Bitrate  (solid) " $t.Bit  "Throughput in Mbps"
    Add-SwatchRow "A: Jitter   (solid) " $t.Jit  "Inter-packet delay variance"
    Add-SwatchRow "A: Loss     (solid) " $t.Los  "Packet loss %"
    Add-SwatchSep "-- File B  (dashed lines) -------------------------"
    Add-SwatchRow "B: Bitrate  (dashed)" $t.Bit2 "Throughput in Mbps"
    Add-SwatchRow "B: Jitter   (dashed)" $t.Jit2 "Inter-packet delay variance"
    Add-SwatchRow "B: Loss     (dashed)" $t.Los2 "Packet loss %"
    Add-SwatchSep "-- Quality thresholds -----------------------------"
    Add-SwatchRow "GREEN   (Excellent) " ([System.Drawing.Color]::LimeGreen) "Bit>90%  | Jitter<0.2ms | Loss=0%"
    Add-SwatchRow "YELLOW  (Warning)   " ([System.Drawing.Color]::Yellow)    "Bit>75%  | Jitter<0.8ms | Loss<1%"
    Add-SwatchRow "ORANGE  (Poor)      " ([System.Drawing.Color]::Orange)    "Bit>50%  | Jitter<1.2ms"
    Add-SwatchRow "RED     (Critical)  " ([System.Drawing.Color]::Red)       "Bit<50%  | Jitter>1.2ms | Loss>1%"

    $lw.ShowDialog()
}

# ================================================================
#  HELP WINDOW  (two columns, selectable text)
# ================================================================
function Show-Help {
    $t  = $script:theme
    $hw = New-Object System.Windows.Forms.Form
    $hw.Text            = "iPerf3 v3.48 - Help"
    $hw.Width           = 980
    $hw.Height          = 860
    $hw.StartPosition   = "CenterParent"
    $hw.BackColor       = $t.Bg
    $hw.FormBorderStyle = "Sizable"
    $hw.MinimumSize     = New-Object System.Drawing.Size(700, 640)

    $fntH   = New-Object System.Drawing.Font("Consolas", 9)
    $fntHdr = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $fntFtr = New-Object System.Drawing.Font("Consolas", 8)

    $dim  = $t.FgDim; $fg = $t.Fg
    $acc  = $t.AccentA; $acc2 = $t.AccentB
    $link = [System.Drawing.Color]::DeepSkyBlue

    # Footer panel — fixed height at bottom
    $footerH = 44
    $footer           = New-Object System.Windows.Forms.Panel
    $footer.Dock      = "Bottom"
    $footer.Height    = $footerH
    $footer.BackColor = $t.Panel
    $hw.Controls.Add($footer)

    $lblFooter           = New-Object System.Windows.Forms.Label
    $lblFooter.Text      = "(c) 2026 Varset & Gemini Dev  |  v3.48 by Claude"
    $lblFooter.Font      = $fntFtr
    $lblFooter.ForeColor = $t.FgDim
    $lblFooter.Left      = 12; $lblFooter.Top = 4
    $lblFooter.AutoSize  = $true
    $footer.Controls.Add($lblFooter)

    # Clickable link label
    $lnk           = New-Object System.Windows.Forms.LinkLabel
    $lnk.Text      = "Extended Manual (Rus/Eng):  https://github.com/Varsett/iPerf3VisualAnalyzer"
    $lnk.Font      = $fntFtr
    $lnk.Left      = 12; $lnk.Top = 22
    $lnk.AutoSize  = $true
    $lnk.LinkColor = $link
    $lnk.ActiveLinkColor = [System.Drawing.Color]::White
    $lnk.BackColor = $t.Panel
    $lnk.Add_LinkClicked({
        Start-Process "https://github.com/Varsett/iPerf3VisualAnalyzer"
    })
    $footer.Controls.Add($lnk)

    # Two RichTextBox columns filling the space above footer
    $col1 = New-Object System.Windows.Forms.RichTextBox
    $col1.Left = 8; $col1.Top = 8; $col1.Width = 470
    $col1.Anchor = "Top,Left,Bottom"
    $col1.ReadOnly = $true; $col1.BorderStyle = "None"
    $col1.Font = $fntH; $col1.BackColor = $t.Bg; $col1.ForeColor = $t.Fg
    $col1.ScrollBars = "None"; $col1.WordWrap = $true
    $hw.Controls.Add($col1)

    $col2 = New-Object System.Windows.Forms.RichTextBox
    $col2.Left = 490; $col2.Top = 8; $col2.Width = 470
    $col2.Anchor = "Top,Left,Right,Bottom"
    $col2.ReadOnly = $true; $col2.BorderStyle = "None"
    $col2.Font = $fntH; $col2.BackColor = $t.Bg; $col2.ForeColor = $t.Fg
    $col2.ScrollBars = "None"; $col2.WordWrap = $true
    $hw.Controls.Add($col2)

    function Set-ColHeights {
        $avail = $hw.ClientSize.Height - $footerH - 16
        $col1.Height = $avail
        $col2.Height = $avail
        $col2.Width  = $hw.ClientSize.Width - $col2.Left - 8
    }
    $hw.Add_Resize({ Set-ColHeights })
    Set-ColHeights

    function Hdr([System.Windows.Forms.RichTextBox]$box, [string]$text) {
        $box.SelectionStart = $box.TextLength
        $box.SelectionFont  = $fntHdr
        $box.SelectionColor = $acc
        $box.AppendText("$text`n")
        $box.SelectionFont  = $fntH
    }
    function Lin([System.Windows.Forms.RichTextBox]$box, [string]$key, [string]$val) {
        $box.SelectionStart = $box.TextLength
        $box.SelectionColor = $acc2; $box.AppendText("  $($key.PadRight(16))")
        $box.SelectionColor = $fg;   $box.AppendText("$val`n")
    }
    function Txt([System.Windows.Forms.RichTextBox]$box, [string]$text) {
        $box.SelectionStart = $box.TextLength
        $box.SelectionColor = $dim; $box.AppendText("$text`n")
    }
    function Br([System.Windows.Forms.RichTextBox]$box) {
        $box.SelectionStart = $box.TextLength; $box.AppendText("`n")
    }

    # ════════════════════════════════════════
    #  COLUMN 1
    # ════════════════════════════════════════
    Hdr  $col1 "INTERFACE CONTROLS"
    Lin  $col1 "Left click"    "Place gold cursor marker"
    Lin  $col1 "Right click"   "Reset zoom and marker"
    Lin  $col1 "Left drag"     "Box-zoom a time interval"
    Lin  $col1 "Mouse wheel"   "Scroll left/right (when zoomed)"
    Lin  $col1 "Ctrl+wheel"    "Zoom in/out at cursor"
    Lin  $col1 "Zoom [-/+]"    "Incremental zoom buttons"
    Lin  $col1 "Button [A]"    "Toggle graph A visibility"
    Lin  $col1 "Button [B]"    "Toggle graph B visibility"
    Lin  $col1 "[...] next to A" "Browse and load a file for graph A"
    Lin  $col1 "[...] next to B" "Browse and load a file for graph B"
    Txt  $col1 "                 Accepts .txt .log .csv"
    Txt  $col1 "                 Checks format, prompts if unknown"
    Lin  $col1 "All Logs"      "Show RT-Monitor CSV logs in lists"
    Txt  $col1 "                 Off: CSVs hidden unless referenced"
    Txt  $col1 "                 by -CsvPath/-AView/-BView/Summary"
    Lin  $col1 "Combo A"       "Primary session (solid lines)"
    Lin  $col1 "Combo B"       "Comparison session (dashed lines)"
    Lin  $col1 "Summary"       "All sessions table"
    Txt  $col1 "                 Single click = select row"
    Txt  $col1 "                 Double click = load as B"
    Lin  $col1 "CSV"           "Export session A to CSV"
    Lin  $col1 "Legend"        "Color and line style guide"
    Lin  $col1 "Dark/Light"    "Toggle theme"
    Lin  $col1 "Save PNG"      "Save full UI screenshot"
    Br   $col1

    Hdr  $col1 "CLI PARAMETERS"
    Lin  $col1 "-WorkDir"      "Folder to scan for log files"
    Txt  $col1 "                 Auto-finds logs in script folder"
    Lin  $col1 "-SavePath"     "Folder for PNG and CSV output"
    Txt  $col1 "                 Default: script folder"
    Lin  $col1 "-Label"        "Session name shown in Test Info"
    Lin  $col1 "-Protocol"     "Protocol label (e.g. TCP / UDP)"
    Lin  $col1 "-Interval"     "Reporting step (e.g. 0.1s)"
    Lin  $col1 "-Streams"      "Parallel streams count (-P)"
    Lin  $col1 "-Duration"     "Total test duration (-t)"
    Lin  $col1 "-TBitrate"     "Target bandwidth (e.g. 150M)"
    Lin  $col1 "-WarnLoss"     "Loss% warning threshold (def. 1.0)"
    Lin  $col1 "-AView"        "Substring for graph A filename"
    Txt  $col1 "                 Latest match by timestamp wins"
    Lin  $col1 "-BView"        "Substring for graph B filename"
    Txt  $col1 "                 Latest match by timestamp wins"
    Lin  $col1 "-FileName"     "Custom output PNG filename"
    Lin  $col1 "-CsvPath"      "iPerf RT Monitor CSV log file"
    Txt  $col1 "                 Header: Time_sec,Bitrate_Mbps,"
    Txt  $col1 "                         Loss_pct,Jitter_ms"
    Lin  $col1 "-AllLogs"      "Show all logs incl. RT-Monitor CSVs"
    Txt  $col1 "                 Same as pressing the All Logs button"
    Lin  $col1 "-Screenshot"   "Auto-save screenshot on startup"
    Lin  $col1 "-Exit"         "Close after screenshot"
    Br   $col1

    Hdr  $col1 "AUTOMATION (.bat)"
    Txt  $col1 "  Use -Command not -File for string params!"
    Br   $col1
    Txt  $col1 "  powershell -Command `"& '%SCRIPT%'``"
    Txt  $col1 "    -Path '%LOGDIR%'``"
    Txt  $col1 "    -AView 'Direct' -BView 'Reverse'``"
    Txt  $col1 "    -FileName 'Report' -Screenshot -Exit`""

    # ════════════════════════════════════════
    #  COLUMN 2
    # ════════════════════════════════════════
    Hdr  $col2 "DATA INTERPRETATION"
    Lin  $col2 "Bitrate"       "Throughput in Mbps. Drops = congestion"
    Lin  $col2 "Jitter"        "Inter-packet delay variance. Target<0.2ms"
    Lin  $col2 "Loss"          "Packet loss %. Target 0%. >1% = artifacts"
    Br   $col2

    Hdr  $col2 "QUALITY THRESHOLDS"
    Lin  $col2 "GREEN"         "Bit>90%  | Jitter<0.2ms | Loss=0%"
    Lin  $col2 "YELLOW"        "Bit>75%  | Jitter<0.8ms | Loss<1%"
    Lin  $col2 "ORANGE"        "Bit>50%  | Jitter<1.2ms"
    Lin  $col2 "RED"           "Bit<50%  | Jitter>1.2ms | Loss>1%"
    Br   $col2

    Hdr  $col2 "VERDICT BOX  (A: = Graph A,  B: = Graph B)"
    Lin  $col2 "Loss"          ""
    Lin  $col2 "  PERFECT"     "0% loss"
    Lin  $col2 "  GOOD"        "up to 0.1%"
    Lin  $col2 "  MODERATE"    "0.1 - 1.0%"
    Lin  $col2 "  HIGH"        "1.0 - 3.0%"
    Lin  $col2 "  CRITICAL"    "above 3.0%"
    Lin  $col2 "Jitter"        ""
    Lin  $col2 "  EXCELLENT"   "< 0.2 ms"
    Lin  $col2 "  GOOD"        "0.2 - 0.8 ms"
    Lin  $col2 "  POOR"        "0.8 - 1.2 ms"
    Lin  $col2 "  CRITICAL"    "> 1.2 ms"
    Lin  $col2 "Bitrate"       "(Min vs Max of session)"
    Lin  $col2 "  EXCELLENT"   "Min >= 90% of Max"
    Lin  $col2 "  GOOD"        "Min >= 75% of Max"
    Lin  $col2 "  POOR"        "Min >= 50% of Max"
    Lin  $col2 "  CRITICAL"    "Min <  50% of Max"
    Br   $col2

    Hdr  $col2 "PACKETS LOST (receiver total)"
    Lin  $col2 "GREEN"         "0 lost. Perfect."
    Lin  $col2 "YELLOW"        "Up to 0.1%. Negligible."
    Lin  $col2 "ORANGE"        "0.1 - 1.0%. Potential lag."
    Lin  $col2 "RED"           "Above 1.0%. High risk."
    Br   $col2

    Hdr  $col2 "FILE SELECTION (-AView / -BView)"
    Txt  $col2 "  Case-insensitive substring of filename."
    Txt  $col2 "  Multiple matches: latest LastWriteTime wins."
    Txt  $col2 "  Fallback: parses YYYY-MM-DD_HH-MM-SS from name."
    Br   $col2
    Txt  $col2 "  WiFiTest-Direct-2026-05-13_01-24-51.txt"
    Txt  $col2 "    matched by -AView 'Direct'"
    Txt  $col2 "  WiFiTest-Reverse-2026-05-13_01-24-51.txt"
    Txt  $col2 "    matched by -BView 'Reverse'"

    $hw.ShowDialog()
}

# ================================================================
#  LOAD FILE FROM DISK  (... buttons)
# ================================================================
function Load-FileIntoAnalyzer([System.Windows.Forms.ComboBox]$targetCombo, [bool]$isB) {
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title  = if ($isB) { "Load log file for Graph B" } else { "Load log file for Graph A" }
    $dlg.Filter = "All supported files (*.txt;*.log;*.csv)|*.txt;*.log;*.csv|All files (*.*)|*.*"
    $dlg.Multiselect = $false
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }

    $file = Get-Item -Path $dlg.FileName
    $key  = $file.Name

    # Already loaded?
    if ($script:allTestData.ContainsKey($key)) {
        $idx = $targetCombo.Items.IndexOf($key)
        if ($idx -ge 0) { $targetCombo.SelectedIndex = $idx; return }
    }

    # Try parsing — iPerf3 log first, then RT-CSV
    $parsed   = $null
    $isCsvLog = $false
    $unitMap  = @{ 'Gbits/sec' = 1000; 'Mbits/sec' = 1; 'Kbits/sec' = 0.001 }

    $content  = Get-Content $file.FullName -Encoding UTF8
    $rawLines = $content | Where-Object {
        $_ -match '\[\s*\d+\]\s+\d+\.\d+-\d+\.\d+\s+sec' -and $_ -notmatch 'sender|receiver'
    }
    $parsed = foreach ($line in $rawLines) {
        if ($line -match '(?<interval>\d+\.\d+-\d+\.\d+).+?\s+(?<bitrate>[\d.]+)\s+(?<unit>Gbits/sec|Mbits/sec|Kbits/sec)\s+(?<jitter>\d+\.\d+)\s+ms\s+(?<lost>\d+)/(?<total>\d+)\s+\((?<percent>\d+(\.\d+)?)\%\)') {
            $mul = $unitMap[$Matches['unit']]
            [PSCustomObject]@{ Time=$([math]::Round([double]($Matches['interval'].Split('-')[1]),2)); Bitrate=$([math]::Round([double]$Matches['bitrate']*$mul,3)); Jitter=[double]$Matches['jitter']; Loss=[double]$Matches['percent'] }
        } elseif ($line -match '(?<interval>\d+\.\d+-\d+\.\d+).+?\s+(?<bitrate>[\d.]+)\s+(?<unit>Gbits/sec|Mbits/sec|Kbits/sec)') {
            $mul = $unitMap[$Matches['unit']]
            [PSCustomObject]@{ Time=$([math]::Round([double]($Matches['interval'].Split('-')[1]),2)); Bitrate=$([math]::Round([double]$Matches['bitrate']*$mul,3)); Jitter=0.0; Loss=0.0; IsTCP=$true }
        }
    }

    if (-not $parsed) {
        # Try RT-Monitor CSV
        $ok = Add-CsvRTLog $file
        if ($ok) { $parsed = $script:allTestData[$key]; $isCsvLog = $true }
    }

    if (-not $parsed) {
        $ans = [System.Windows.Forms.MessageBox]::Show(
            "File '$($file.Name)' was not recognized as a supported iPerf3 log format.`n`nContinue trying to load anyway?",
            "Unrecognized format",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        if ($ans -ne [System.Windows.Forms.DialogResult]::Yes) { return }

        # Force-try CSV parse one more time ignoring header check
        $rawText = [System.IO.File]::ReadAllText($file.FullName)
        $rawText = $rawText.TrimStart([char]0xFEFF)
        $csvLines = $rawText -split "`r`n|`r|`n" | Where-Object { $_.Trim() -ne "" }
        $forceData = foreach ($row in ($csvLines | Select-Object -Skip 1)) {
            $cols = $row -split ','
            if ($cols.Count -lt 2) { continue }
            try {
                $t = [math]::Round([double]$cols[0].Trim(), 3)
                $b = [math]::Round([double]$cols[1].Trim(), 3)
                $l = if ($cols.Count -gt 2) { [double]$cols[2].Trim() } else { 0 }
                $j = if ($cols.Count -gt 3) { [double]$cols[3].Trim() } else { 0 }
                [PSCustomObject]@{ Time=$t; Bitrate=$b; Jitter=$j; Loss=$l }
            } catch { }
        }
        if ($forceData) {
            $parsed = $forceData; $isCsvLog = $true
        } else {
            [System.Windows.Forms.MessageBox]::Show("Could not parse any data from '$($file.Name)'.", "Parse failed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }
    }

    # Register in allTestData
    if (-not $script:allTestData.ContainsKey($key)) {
        $script:allTestData[$key]  = $parsed
        $script:totalsData[$key]   = $null
        $script:isTCPLog[$key]     = ($parsed | Where-Object { $_.IsTCP } | Select-Object -First 1) -ne $null
        $script:isCsvRT[$key]      = $isCsvLog
        # Update sortedKeys
        $script:sortedKeys = @($script:allTestData.Keys | Sort-Object)
        [void]$script:alwaysVisibleKeys.Add($key)
        Refresh-ComboItems
    }

    # Select in target combo
    $idx = $targetCombo.Items.IndexOf($key)
    if ($idx -ge 0) { $targetCombo.SelectedIndex = $idx }
}

$btnLoadA.Add_Click({ Load-FileIntoAnalyzer $combo  $false })
$btnLoadB.Add_Click({ Load-FileIntoAnalyzer $combo2 $true  })

# ================================================================
#  WIRING
# ================================================================
function Get-SelectedB {
    if ($combo2.SelectedIndex -le 0) { return $null }
    return $combo2.SelectedItem.ToString()
}

$combo.Add_SelectedIndexChanged({
    $script:showA = $true; $btnA.Text = "A"
    Update-Chart $combo.SelectedItem (Get-SelectedB)
})
$combo2.Add_SelectedIndexChanged({
    $script:showB = $true; $btnB.Text = "B"
    Update-Chart $combo.SelectedItem (Get-SelectedB)
})
$btnAllLogs.Add_Click({
    $script:showAllLogs = -not $script:showAllLogs
    Refresh-ComboItems
    Apply-Theme-To-Controls
    Update-Chart $combo.SelectedItem (Get-SelectedB)
})
$btnDark.Add_Click({
    $script:isDark = -not $script:isDark
    $btnDark.Text  = if ($script:isDark) { "Light" } else { "Dark" }
    Set-Theme $script:isDark
    Update-Chart $combo.SelectedItem (Get-SelectedB)
})
$btnZoomIn.Add_Click({  Do-Zoom 0.75 })
$btnZoomOut.Add_Click({ Do-Zoom 1.33 })
$btnSummary.Add_Click({ Show-Summary })
$btnExport.Add_Click({  Export-CSV })
$btnSave.Add_Click({
    $sp = Save-FullUI
    [System.Windows.Forms.MessageBox]::Show("Saved to:`n$sp", "Success")
})
$btnLegend.Add_Click({ Show-Legend })
$btnHelp.Add_Click({ Show-Help })

# ----------------------------------------------------------------
#  Helper: pick best matching key from allTestData by substring.
#  Case-insensitive. Among matches picks latest by LastWriteTime
#  or date pattern YYYY-MM-DD_HH-MM-SS in filename.
# ----------------------------------------------------------------
function Select-BestKey([string]$substring) {
    if ($substring -eq "" -or $allTestData.Count -eq 0) { return $null }
    # Case-insensitive substring match
    $matched = @($script:sortedKeys | Where-Object { $_.ToLower().Contains($substring.ToLower()) })
    if ($matched.Count -eq 0) { return $null }
    if ($matched.Count -eq 1) { return $matched[0] }

    # Multiple matches — pick latest
    $best = $null
    $bestTime = [datetime]::MinValue
    $baseDir = if ($scanPath -ne "" -and (Test-Path $scanPath)) { $scanPath } else { $null }

    foreach ($key in $matched) {
        $t = [datetime]::MinValue
        if ($baseDir) {
            $fp = Join-Path $baseDir $key
            if (Test-Path $fp) { $t = (Get-Item $fp).LastWriteTime }
        }
        if ($t -eq [datetime]::MinValue) {
            if ($key -match '(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})') {
                try { $t = [datetime]::ParseExact($Matches[1], 'yyyy-MM-dd_HH-mm-ss', $null) } catch {}
            }
        }
        if ($t -gt $bestTime) { $bestTime = $t; $best = $key }
    }
    return $best
}

# Resolve A and B BEFORE registering Add_Shown
$script:autoKeyA = if ($AView -ne "") { Select-BestKey $AView } else { $null }
$script:autoKeyB = if ($BView -ne "") { Select-BestKey $BView } else { $null }

# Guard: if both -AView and -BView resolve to the identical file (e.g. both
# patterns are too generic and match the same item), drop the B selection
# rather than silently comparing a file against itself.
if ($script:autoKeyA -and $script:autoKeyB -and $script:autoKeyA -eq $script:autoKeyB) {
    $script:autoKeyB = $null
}

# If a resolved key is an RT-Monitor CSV not normally shown, make it visible
foreach ($k in @($script:autoKeyA, $script:autoKeyB)) {
    if ($k -and $script:isCsvRT[$k]) { [void]$script:alwaysVisibleKeys.Add($k) }
}
Refresh-ComboItems

# Apply A selection immediately (before initial draw)
if ($script:autoKeyA) {
    $idxA = $combo.Items.IndexOf($script:autoKeyA)
    if ($idxA -ge 0) { $combo.SelectedIndex = $idxA }
}

# Initial draw (A only)
Update-Chart $combo.SelectedItem $null

# Pass switch params into script scope for closure visibility
$script:doScreenshot = $Screenshot.IsPresent
$script:doExit       = $Exit.IsPresent

# Single Add_Shown handler — runs everything in correct order
$form.Add_Shown({
    Reposition-RightButtons
    Reposition-Verdict

    # Apply B selection — must happen after form is fully shown
    if ($script:autoKeyB) {
        $idxB = $combo2.Items.IndexOf($script:autoKeyB)
        if ($idxB -ge 0) {
            $combo2.SelectedIndex = $idxB
            [System.Windows.Forms.Application]::DoEvents()
        }
    }

    # Screenshot after rendering is complete
    if ($script:doScreenshot) {
        Start-Sleep -Milliseconds 900
        [System.Windows.Forms.Application]::DoEvents()
        $f = Save-FullUI
        if ($script:doExit) { $form.Close() }
    }
})

$form.ShowDialog()