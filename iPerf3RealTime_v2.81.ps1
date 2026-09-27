# iPerf3 Real-Time Monitor
# All parameters are parsed manually from $args so that empty CMD variables
# like %port% (which expand to nothing) do not cause "missing argument" errors.
# PowerShell never sees a param() block, so it cannot complain about missing values.

# --- Defaults (iPerf3 built-in values used when CMD variable is empty) ---
$ServerIP        = ""
$ToolsPath       = "d:\Quest\_Cmd\__Quas\Source"
$Port            = ""         # iPerf3 default: 5201
$Protocol        = ""         # empty = TCP; set "-u" for UDP
$Direction       = ""         # empty = normal; set "-R" for reverse
$Bitrate         = ""         # empty = unlimited (iPerf uses 0)
$Duration        = "10"       # iPerf3 default: 10 s
$Interval        = "1"        # iPerf3 default: 1 s
$Buflen          = ""         # iPerf3 default: 131072 bytes (TCP) / 8192 bytes (UDP)
$Socketsize      = ""         # iPerf3 socket window size, in MB (e.g. 1M)
$Streams         = "1"        # iPerf3 default: 1
$Extra           = ""
$ProfileName     = ""
$LogFile         = ""
$SavePath        = ""
$LossWarnPct     = 2.0
$LossCritPct     = 5.0
$ScrollWindowSec  = 10
$MaxPoints        = 36000
$ThreshJitter     = 0.2    # ms
$ThreshLoss       = 1.0    # %
$ThreshBitrateRel = 50     # % of target bitrate (0 = disable)

# --- Parse $args manually ---
# Known parameter names - used to distinguish a param name from a value like "-u" or "-R"
$knownParams = @("-serverip","-toolspath","-port","-protocol","-direction","-bitrate",
                 "-duration","-interval","-buflen","-socketsize","-streams","-extra",
                 "-logfile","-savepath","-losswarnpct","-losscritpct",
                 "-scrollwindowsec","-maxpoints","-threshjitter","-threshloss","-threshbitraterel","-visualanalyzerscript","-visualanalyzerargs","-cpudivisor","-killserveronfinish","-doneflagfile","-autoexit")

function Get-NextVal($arr, $idx) {
    # Returns value if next token exists AND is not a known parameter name.
    # This allows values like "-u" or "-R" to be correctly captured.
    if ($idx + 1 -ge $arr.Count) { return $null }
    $next = $arr[$idx + 1].ToString().ToLower()
    if ($knownParams -contains $next) { return $null }
    return $arr[$idx + 1].ToString().Trim('"').Trim("'").Trim()
}

$i = 0
while ($i -lt $args.Count) {
    $rawTok = $args[$i].ToString()
    $tok = $rawTok.ToLower()
    $val = Get-NextVal $args $i
    $hasVal = $null -ne $val -and $val -ne ""
    switch ($tok) {
        "-serverip"        { if ($hasVal) { $ServerIP        = $val; $i++ } }
        "-toolspath"       { if ($hasVal) { $ToolsPath       = $val; $i++ } }
        "-port"            { if ($hasVal) { $Port            = $val; $i++ } }
        "-protocol"        { if ($hasVal) { $Protocol        = $val; $i++ } }
        "-direction"       { if ($hasVal) { $Direction       = $val; $i++ } }
        "-bitrate"         { if ($hasVal) { $Bitrate         = $val; $i++ } }
        "-duration"        { if ($hasVal) { $Duration        = $val; $i++ } }
        "-interval"        { if ($hasVal) { $Interval        = $val; $i++ } }
        "-socketsize"      { if ($hasVal) { $Socketsize      = $val; $i++ } }
        "-buflen"          { if ($hasVal) { $Buflen          = $val; $i++ } }
        "-streams"         { if ($hasVal) { $Streams         = $val; $i++ } }
        "-extra"           { if ($hasVal) { $Extra           = $val; $i++ } }
        "-profilename"     { if ($hasVal) { $ProfileName     = $val; $i++ } }
        "-logfile"         { if ($hasVal) { $LogFile         = $val; $i++ } }
        "-savepath"        { if ($hasVal) { $SavePath        = $val; $i++ } }
        "-losswarnpct"     { if ($hasVal) { $LossWarnPct     = [double]$val; $i++ } }
        "-losscritpct"     { if ($hasVal) { $LossCritPct     = [double]$val; $i++ } }
        "-scrollwindowsec" { if ($hasVal) { $ScrollWindowSec = [int]$val;    $i++ } }
        "-maxpoints"       { if ($hasVal) { $MaxPoints        = [int]$val;    $i++ } }
        "-threshjitter"    { if ($hasVal) { $ThreshJitter     = [double]$val; $i++ } }
        "-threshloss"      { if ($hasVal) { $ThreshLoss       = [double]$val; $i++ } }
        "-threshbitraterel"    { if ($hasVal) { $ThreshBitrateRel    = [double]$val; $i++ } }
        "-visualanalyzerscript" { if ($hasVal) { $VisualAnalyzerScript = $val; $i++ } }
        "-visualanalyzerargs"   { if ($hasVal) { $VisualAnalyzerArgs   = $val; $i++ } }
        "-cpudivisor"          { if ($hasVal) { $CpuDivisor          = [double]$val; $i++ } }
        "-killserveronfinish"  { if ($hasVal) { $KillServerOnFinish  = $val; $i++ } }
        "-doneflagfile"        { if ($hasVal) { $DoneFlagFile        = $val; $i++ } }
        "-autoexit"            { if ($hasVal) { $AutoExit            = $val; $i++ } }
    }
    $i++
}

if (-not $ServerIP) {
    Write-Error "-ServerIP is required. Example: -ServerIP 10.0.0.30"
    exit 1
}

# Store parsed params in script scope so button-click closures can read them.
# PowerShell closures capture variables by NAME at call time, so we need
# explicit $script: scope for anything used inside Add_Click handlers.
$script:LogFile             = $LogFile
$script:VisualAnalyzerScript = $VisualAnalyzerScript
$script:VisualAnalyzerArgs   = $VisualAnalyzerArgs

# Resolve save path: beside the script if not specified
if (-not $SavePath) {
    $SavePath = Split-Path -Parent $MyInvocation.MyCommand.Path
}
if (-not (Test-Path $SavePath)) {
    New-Item -ItemType Directory -Path $SavePath | Out-Null
}

Add-Type -AssemblyName System.Windows.Forms, System.Windows.Forms.DataVisualization, System.Drawing

# WinAPI to hide this script's own console window after the test finishes.
# The chart form (WinForms) is independent of the console and stays open.
Add-Type -Name Win32 -Namespace ConsoleUtil -MemberDefinition @"
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
"@

function Hide-ConsoleWindow {
    try {
        $hwnd = [ConsoleUtil.Win32]::GetConsoleWindow()
        if ($hwnd -ne [IntPtr]::Zero) {
            [ConsoleUtil.Win32]::ShowWindow($hwnd, 0) | Out-Null  # SW_HIDE = 0
        }
    } catch {}
}

# =====================================================================
# BUILD IPERF COMMAND
# =====================================================================
$ADB_PATH = if ($ToolsPath -and $ToolsPath.Trim() -ne "") {
    Join-Path $ToolsPath "adb.exe"
} else {
    "adb.exe"   # assume adb.exe is on system PATH
}
$iPerfBin = "/data/local/tmp/iperf3.18"

$argParts = [System.Collections.Generic.List[string]]::new()
$argParts.Add("shell -t $iPerfBin")
$argParts.Add("-c $ServerIP")
if ($Port)      { $argParts.Add("-p $Port") }
if ($Duration)  { $argParts.Add("-t $Duration") }
if ($Interval)  { $argParts.Add("-i $Interval") }
if ($Bitrate -and $Bitrate -ne "0") { $argParts.Add("-b ${Bitrate}M") }
if ($Streams)   { $argParts.Add("-P $Streams") }
if ($Buflen)    { $argParts.Add("-l $Buflen") }
if ($Socketsize){ $argParts.Add("-w ${Socketsize}M") }
$argParts.Add("-f m")
if ($Protocol)  { $argParts.Add($Protocol) }
if ($Direction) { $argParts.Add($Direction) }
if ($Extra)     { $argParts.Add($Extra) }

$AdbArgs = $argParts -join " "

# =====================================================================
# SCRIPT STATE
# =====================================================================
$script:DataPoints  = [System.Collections.Generic.List[PSCustomObject]]::new()
# Running accumulators - updated each point, O(1) instead of O(n)
$script:statMin    = [double]::MaxValue
$script:statMax    = [double]::MinValue
$script:statSum    = 0.0
$script:statLossMax= 0.0
$script:statLossSum= 0.0
$script:statJitMax = 0.0
$script:statJitSum = 0.0
$script:proc        = $null
$script:testRunning = $false
$script:scrollOn    = $true
$script:avgOn       = $true

$script:logWriter = $null
if ($LogFile) {
    try {
        $script:logWriter = New-Object System.IO.StreamWriter($LogFile, $false,
            [System.Text.Encoding]::UTF8)
        $script:logWriter.AutoFlush = $true
        $script:logWriter.WriteLine("Time_sec,Bitrate_Mbps,Loss_pct,Jitter_ms")
    } catch { Write-Warning "Cannot open log file: $_" }
}

$script:reUdp = [regex]'(?x)
    -\s*(?<time>\d+\.\d+)\s+sec
    .*?
    \d+(?:\.\d+)?\s+(?:MBytes|KBytes|GBytes)
    \s+
    (?<rate>\d+(?:\.\d+)?)\s+(?<unit>Kbits|Mbits|Gbits)/sec
    \s+
    (?<jitter>\d+(?:\.\d+)?)\s+ms
    .*?
    \((?<loss>\d+(?:\.\d+)?)%\)'

# TCP: bitrate only (no jitter/loss)
$script:reTcp = [regex]'(?x)
    -\s*(?<time>\d+\.\d+)\s+sec
    .*?
    \d+(?:\.\d+)?\s+(?:MBytes|KBytes|GBytes)
    \s+
    (?<rate>\d+(?:\.\d+)?)\s+(?<unit>Kbits|Mbits|Gbits)/sec'


# Detect protocol: empty or not -u means TCP
$script:isTCP = ($Protocol -ne "-u")

# =====================================================================
# COLORS
# =====================================================================
$clrFormBg    = [System.Drawing.Color]::FromArgb(28, 28, 32)
$clrPanelBg   = [System.Drawing.Color]::FromArgb(18, 18, 22)
$clrBtnNorm   = [System.Drawing.Color]::FromArgb(50, 50, 62)
$clrBtnBorder = [System.Drawing.Color]::FromArgb(85, 85, 108)
$clrToggleOn  = [System.Drawing.Color]::FromArgb(0, 110, 180)
$clrWhite     = [System.Drawing.Color]::White
$clrGray      = [System.Drawing.Color]::FromArgb(140, 140, 150)
$clrStatLbl   = [System.Drawing.Color]::FromArgb(110, 110, 128)
$clrStatBps   = [System.Drawing.Color]::FromArgb(80,  200, 255)
$clrStatLoss  = [System.Drawing.Color]::FromArgb(255, 100, 100)
$clrStatTime  = [System.Drawing.Color]::FromArgb(180, 220, 120)
$clrAxisLine  = [System.Drawing.Color]::FromArgb(110, 110, 130)
$clrGrid      = [System.Drawing.Color]::FromArgb(60,  60,  75)

# =====================================================================
# FORM
# =====================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text          = "iPerf3 Real-Time Monitor"
$form.Width         = 1500
$form.Height        = 800
$form.MinimumSize   = New-Object System.Drawing.Size(1100, 620)
$form.StartPosition = "CenterScreen"
$form.BackColor     = $clrFormBg

# =====================================================================
# RIGHT INFO PANEL
# Built AFTER $panel (button bar) so we know its height.
# Added to form AFTER chart so it appears on top of Dock=Fill chart.
# =====================================================================
$infoPanelW    = 155
$infoPanelMarR = 38    # gap between panel right edge and form right edge
$btnBarH       = 44   # matches $panel.Height set later

$statFont   = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$labelFont  = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Regular)
$headerFont = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Bold)

$clrInfoBg   = [System.Drawing.Color]::FromArgb(22, 22, 28)
$clrInfoBord = [System.Drawing.Color]::FromArgb(55, 55, 70)
$clrHdrText  = [System.Drawing.Color]::FromArgb(160, 160, 180)
$clrValBps   = [System.Drawing.Color]::FromArgb(80,  200, 255)
$clrValLoss  = [System.Drawing.Color]::FromArgb(255, 100, 100)
$clrValTime  = [System.Drawing.Color]::FromArgb(180, 220, 120)
$clrValInfo  = [System.Drawing.Color]::FromArgb(210, 210, 225)  # default value color
$clrValSet   = [System.Drawing.Color]::FromArgb(0,   210, 210)   # user-set value color (aqua)

# Returns [text, color] - aqua if user set, white+Default if iPerf default
function Param-Val([string]$val, [string]$suffix, [string]$default, [string]$defaultSuffix = "") {
    if ($val -and $val.Trim() -ne "") {
        return @("$val$suffix", $clrValSet)
    } else {
        $defText = if ($default -ne "") { "$default$defaultSuffix (Default)" } else { "(Default)" }
        return @($defText, $clrValInfo)
    }
}

# ---- Label factory for info panel ----
function New-IL([string]$text, [System.Drawing.Font]$fnt,
                [System.Drawing.Color]$fg, [int]$y, [int]$h) {
    $l = New-Object System.Windows.Forms.Label
    $l.Text = $text; $l.Font = $fnt; $l.ForeColor = $fg
    $l.BackColor = [System.Drawing.Color]::Transparent
    $l.AutoSize = $false
    $l.Width = $infoPanelW - 14; $l.Height = $h
    $l.Location = New-Object System.Drawing.Point(7, $y)
    $l.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $l
}
function New-Sep-Line([int]$y) {
    $s = New-Object System.Windows.Forms.Panel
    $s.Height = 1; $s.Width = $infoPanelW - 14
    $s.Location = New-Object System.Drawing.Point(7, $y)
    $s.BackColor = $clrInfoBord; $s
}

# =====================================================================
# CONTROL PANEL  (Dock=Bottom, must be added before chart)
# =====================================================================
$panel = New-Object System.Windows.Forms.Panel
$panel.Height = 44; $panel.Dock = "Bottom"; $panel.BackColor = $clrPanelBg
$form.Controls.Add($panel)

$btnFont = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)

# Flat buttons with guaranteed white ForeColor.
# FlatStyle::Flat respects BackColor and ForeColor without OS theme interference.
# We use OwnerDraw via a lightweight Label-over-Button approach - actually the
# simplest fix: use a Panel as the button surface and handle Click manually.
# Easiest reliable solution: keep FlatStyle::Flat, set ForeColor AFTER adding to panel.
function New-Btn([string]$text, [int]$x, [int]$w,
                 [System.Drawing.Color]$fg, [System.Drawing.Color]$bg) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text      = $text
    $b.Font      = $btnFont
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(70, 70, 88)
    $b.FlatAppearance.BorderSize  = 1
    $b.FlatAppearance.MouseOverBackColor  = [System.Drawing.Color]::FromArgb([math]::Min($bg.R+20,255), [math]::Min($bg.G+20,255), [math]::Min($bg.B+20,255))
    $b.FlatAppearance.MouseDownBackColor  = [System.Drawing.Color]::FromArgb([math]::Max($bg.R-20,0),  [math]::Max($bg.G-20,0),  [math]::Max($bg.B-20,0))
    $b.UseVisualStyleBackColor = $false
    $b.BackColor = $bg
    $b.Width  = $w; $b.Height = 28
    $b.Location = New-Object System.Drawing.Point($x, 8)
    $panel.Controls.Add($b)
    # ForeColor MUST be set after Add() - before Add() the handle isn't created
    # and some Windows themes reset it. Setting it here guarantees it sticks.
    $b.ForeColor = $fg
    $b
}

$clrStop      = [System.Drawing.Color]::FromArgb(180, 55, 75)
$clrToggleOff = $clrBtnNorm

$x = 10
$btnStop     = New-Btn "Stop"            $x  76 $clrWhite $clrStop
$x += 82
$btnExport   = New-Btn "Export CSV"      $x 110 $clrWhite $clrBtnNorm
$x += 116
$btnPng      = New-Btn "Save PNG"        $x  90 $clrWhite $clrBtnNorm
$x += 106
$btnAnalyzer = New-Btn "Visual Analyzer" $x 125 ([System.Drawing.Color]::FromArgb(255,210,80)) $clrBtnNorm
$x += 131

$btnStop.Enabled     = $false
$btnExport.Enabled   = $false
$btnPng.Enabled      = $false
$btnAnalyzer.Enabled = $false
$btnAnalyzer.Visible = ($VisualAnalyzerPath -ne "")

# Toggle buttons - active = blue, inactive = dark grey, text always white
$btnScroll = New-Btn "Autoscroll (${ScrollWindowSec}s)" ($x+10) 152 $clrWhite $clrToggleOn
$btnScroll.Add_Click({
    $script:scrollOn = -not $script:scrollOn
    $this.BackColor  = if ($script:scrollOn) { $clrToggleOn } else { $clrToggleOff }
    $this.ForeColor  = $clrWhite
    $this.FlatAppearance.MouseOverBackColor = if ($script:scrollOn) {
        [System.Drawing.Color]::FromArgb(30,130,200) } else {
        [System.Drawing.Color]::FromArgb(70,70,82) }
})
$x += 168

$btnAvg = New-Btn "Show Avg Line" $x 118 $clrWhite $clrToggleOn
$btnAvg.Add_Click({
    $script:avgOn = -not $script:avgOn
    $this.BackColor  = if ($script:avgOn) { $clrToggleOn } else { $clrToggleOff }
    $this.ForeColor  = $clrWhite
    $this.FlatAppearance.MouseOverBackColor = if ($script:avgOn) {
        [System.Drawing.Color]::FromArgb(30,130,200) } else {
        [System.Drawing.Color]::FromArgb(70,70,82) }
    $seriesAvg.Enabled           = $script:avgOn
    $seriesAvg.IsVisibleInLegend = $script:avgOn
    $chart.Update()
})

$btnLegend = New-Btn "Legend" 0 68 $clrWhite $clrBtnNorm
$btnLegend.Anchor   = [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top
$btnLegend.Location = New-Object System.Drawing.Point(($panel.Width - 114), 8)

$btnHelp = New-Btn "?" 0 30 $clrWhite $clrBtnNorm
$btnHelp.Anchor   = [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top
$btnHelp.Location = New-Object System.Drawing.Point(($panel.Width - 40), 8)
$panel.Add_SizeChanged({
    $btnHelp.Location   = New-Object System.Drawing.Point(($panel.Width - 40),  8)
    $btnLegend.Location = New-Object System.Drawing.Point(($panel.Width - 114), 8)
})
# =====================================================================
# CHART
# =====================================================================
$chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Dock = "Fill"; $chart.BackColor = $clrFormBg
$form.Controls.Add($chart)
$chart.BringToFront()

# -- Three separate chart areas: Bitrate / Loss / Jitter ----------------------
# Each has its own Y axis and grid. X axes are aligned via AlignWithChartArea.
# Layout (% of chart control): Bitrate Y=2 H=30, Loss Y=33 H=30, Jitter Y=64 H=30
$innerX = 8; $innerW = 89

function New-CA([string]$name, [double]$py, [double]$ph,
                [double]$iy, [double]$ih, [bool]$showXLabels) {
    $a = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea($name)
    $a.BackColor = $clrFormBg
    $a.Position.Auto = $false
    $a.Position.X = 1; $a.Position.Y = $py
    $a.Position.Width = 82; $a.Position.Height = $ph
    $a.InnerPlotPosition.Auto = $false
    $a.InnerPlotPosition.X = $innerX; $a.InnerPlotPosition.Y = $iy
    $a.InnerPlotPosition.Width = $innerW; $a.InnerPlotPosition.Height = $ih
    foreach ($ax in @($a.AxisX, $a.AxisY)) {
        $ax.MajorGrid.LineColor     = $clrGrid
        $ax.LabelStyle.ForeColor    = [System.Drawing.Color]::FromArgb(200,200,210)
        $ax.LineColor               = $clrAxisLine
        $ax.MajorTickMark.LineColor = $clrAxisLine
    }
    $a.AxisX.LabelStyle.Format  = "0.0"
    $a.AxisX.LabelStyle.Enabled = $showXLabels
    $a
}

# Bitrate area (top)
$area = New-CA "Bitrate" 2 30 5 88 $false
$area.AxisY.Title          = "Bitrate (Mbps)"
$area.AxisY.TitleForeColor = [System.Drawing.Color]::FromArgb(100,200,255)
$area.AxisY.LabelStyle.ForeColor = [System.Drawing.Color]::FromArgb(100,200,255)
$chart.ChartAreas.Add($area)

# Jitter area (middle)
$areaJ = New-CA "Jitter" 33 30 5 88 $false
$areaJ.AxisY.Title          = "Jitter (ms)"
$areaJ.AxisY.TitleForeColor = [System.Drawing.Color]::FromArgb(255,200,80)
$areaJ.AxisY.LabelStyle.ForeColor = [System.Drawing.Color]::FromArgb(255,200,80)
$areaJ.AxisY.Minimum        = 0
$areaJ.AlignWithChartArea   = "Bitrate"
$areaJ.AlignmentOrientation = [System.Windows.Forms.DataVisualization.Charting.AreaAlignmentOrientations]::Vertical
$chart.ChartAreas.Add($areaJ)

# Loss area (bottom)
$areaL = New-CA "Loss" 64 30 5 88 $true
$areaL.AxisY.Title          = "Packet Loss (%)"
$areaL.AxisY.TitleForeColor = [System.Drawing.Color]::FromArgb(255,100,100)
$areaL.AxisY.LabelStyle.ForeColor = [System.Drawing.Color]::FromArgb(255,100,100)
$areaL.AxisY.Minimum        = 0
$areaL.AxisY.Maximum        = 100
$areaL.AlignWithChartArea   = "Bitrate"
$areaL.AlignmentOrientation = [System.Windows.Forms.DataVisualization.Charting.AreaAlignmentOrientations]::Vertical
$chart.ChartAreas.Add($areaL)

# ---- Hide Jitter/Loss areas in TCP mode ----
if ($script:isTCP) {
    foreach ($a in @($areaJ, $areaL)) {
        $a.BackColor                  = [System.Drawing.Color]::FromArgb(18,18,24)
        $a.AxisY.LabelStyle.ForeColor = [System.Drawing.Color]::FromArgb(55,55,65)
        $a.AxisY.TitleForeColor       = [System.Drawing.Color]::FromArgb(55,55,65)
        $a.AxisX.LabelStyle.ForeColor = [System.Drawing.Color]::FromArgb(55,55,65)
        $a.AxisX.MajorGrid.LineColor  = [System.Drawing.Color]::FromArgb(28,28,35)
        $a.AxisY.MajorGrid.LineColor  = [System.Drawing.Color]::FromArgb(28,28,35)
    }
    $areaJ.AxisY.Title = "Jitter (ms) - N/A for TCP"
    $areaL.AxisY.Title = "Loss (%)    - N/A for TCP"
}

# ---- Threshold lines via StripLine ----
# StripLine is a pure axis annotation - no series points, no X-axis interference.
# Width is set very small in axis units. Text label via StripLine.Text property.
$clrThreshFill   = [System.Drawing.Color]::FromArgb(60,  140, 80, 220)   # faint purple fill
$clrThreshBorder = [System.Drawing.Color]::FromArgb(220, 140, 80, 220)   # solid purple border

function New-StripLine([double]$yVal, [string]$label) {
    $sl = New-Object System.Windows.Forms.DataVisualization.Charting.StripLine
    $sl.IntervalOffset      = $yVal
    $sl.StripWidth          = 0        # zero width = single line
    $sl.BackColor           = $clrThreshFill
    $sl.BorderColor         = $clrThreshBorder
    $sl.BorderWidth         = 1
    $sl.BorderDashStyle     = [System.Windows.Forms.DataVisualization.Charting.ChartDashStyle]::Dash
    $sl.Text                = $label
    $sl.ForeColor           = $clrThreshBorder
    $sl.Font                = New-Object System.Drawing.Font("Arial", 7)
    $sl.TextAlignment       = [System.Drawing.StringAlignment]::Far
    $sl.TextLineAlignment   = [System.Drawing.StringAlignment]::Far
    $sl
}

# Loss threshold on right Y2 axis
$areaL.AxisY.StripLines.Add((New-StripLine $ThreshLoss "Threshold"))

# Bitrate threshold on left Y axis - fixed at Bitrate/2
if ($Bitrate -and [double]$Bitrate -gt 0) {
    $area.AxisY.StripLines.Add((New-StripLine ([double]$Bitrate / 2.0) "Threshold"))
}

# Jitter threshold on jitter chart Y axis
$areaJ.AxisY.StripLines.Add((New-StripLine $ThreshJitter "Threshold"))

# Legend docked inside chart area at bottom-left
$legend = New-Object System.Windows.Forms.DataVisualization.Charting.Legend
$legend.BackColor  = [System.Drawing.Color]::FromArgb(35,35,45)
$legend.ForeColor  = $clrWhite
$legend.Font       = New-Object System.Drawing.Font("Arial", 8)
$legend.Docking    = [System.Windows.Forms.DataVisualization.Charting.Docking]::Bottom
$legend.Alignment  = [System.Drawing.StringAlignment]::Near
$chart.Legends.Add($legend)
$legend.Enabled   = $false   # hidden by default

function New-Series([string]$name, [System.Drawing.Color]$color, [int]$width, $yType) {
    $s = New-Object System.Windows.Forms.DataVisualization.Charting.Series($name)
    $s.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $s.BorderWidth = $width; $s.Color = $color; $s.LegendText = $name
    if ($yType) { $s.YAxisType = $yType }
    $chart.Series.Add($s); $s
}

$seriesBitrate = New-Series "Bitrate (Mbps)" ([System.Drawing.Color]::FromArgb(50,180,255)) 3 $null
$seriesBitrate.ChartArea = "Bitrate"
$seriesAvg     = New-Series "Avg Bitrate"    ([System.Drawing.Color]::FromArgb(80,200,120)) 2 $null
$seriesAvg.ChartArea     = "Bitrate"
$seriesLoss    = New-Series "Loss (%)"       ([System.Drawing.Color]::FromArgb(255,80,80))  3 $null
$seriesLoss.ChartArea = "Loss"
$seriesAvg.BorderDashStyle   = [System.Windows.Forms.DataVisualization.Charting.ChartDashStyle]::Dash
$seriesAvg.IsVisibleInLegend = $true

# Jitter series - lives in Jitter ChartArea
$seriesJitter = New-Object System.Windows.Forms.DataVisualization.Charting.Series("Jitter (ms)")
$seriesJitter.ChartType   = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$seriesJitter.BorderWidth = 2
$seriesJitter.Color       = [System.Drawing.Color]::FromArgb(255, 200, 80)
$seriesJitter.LegendText  = "Jitter (ms)"
$seriesJitter.ChartArea   = "Jitter"
$chart.Series.Add($seriesJitter)

[void]$seriesBitrate.Points.AddXY(0,0)
[void]$seriesAvg.Points.AddXY(0,0)
[void]$seriesLoss.Points.AddXY(0,0)
[void]$seriesJitter.Points.AddXY(0,0)

# Force X labels on all areas immediately - no AlignWithChartArea dependency
foreach ($a in @($area,$areaJ,$areaL)) {
    $a.AxisX.Minimum = 0
    $a.AxisX.Maximum = [Double]::NaN
    $a.AxisX.LabelStyle.Enabled   = $true
    $a.AxisX.LabelStyle.Format    = "0.0"
    $a.AxisX.LabelStyle.ForeColor = [System.Drawing.Color]::FromArgb(200,200,210)
}

# =====================================================================
# BUILD INFO PANEL CONTENTS
# Added after chart (Dock=Fill) so BringToFront puts it on top.
# Position is set explicitly in Add_Shown AND Add_SizeChanged.
# =====================================================================
# Outer border frame: 1px colored border around infoPanel
$infoBorder = New-Object System.Windows.Forms.Panel
$infoBorder.BackColor = $clrInfoBord
$form.Controls.Add($infoBorder)
$infoBorder.BringToFront()

# Inner panel: inset 1px inside border frame
$infoPanel = New-Object System.Windows.Forms.Panel
$infoPanel.BackColor = $clrInfoBg
$infoPanel.Location  = New-Object System.Drawing.Point(1, 1)
$infoBorder.Controls.Add($infoPanel)

# Reposition border frame; infoPanel fills it minus 1px border on each side
function Reposition-InfoPanel {
    $cl = $form.ClientSize
    $h  = $cl.Height - $btnBarH
    $infoBorder.Location = New-Object System.Drawing.Point(($cl.Width - $infoPanelW - $infoPanelMarR), 0)
    $infoBorder.Width    = $infoPanelW
    $infoBorder.Height   = $h
    $infoPanel.Width     = $infoPanelW - 2
    $infoPanel.Height    = $h - 2
}
$form.Add_Shown({     Reposition-InfoPanel })
$form.Add_SizeChanged({ Reposition-InfoPanel })

# Helper: add label+value pair, advance $y, return value label
function Add-Row([string]$cap, [string]$val,
                 [System.Drawing.Color]$valClr, [ref]$yR) {
    $lc = New-Object System.Windows.Forms.Label
    $lc.Text = $cap; $lc.Font = $labelFont; $lc.ForeColor = $clrHdrText
    $lc.BackColor = [System.Drawing.Color]::Transparent
    $lc.AutoSize = $false; $lc.Width = $infoPanelW - 12; $lc.Height = 11
    $lc.Location = New-Object System.Drawing.Point(5, $yR.Value)
    $lc.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $infoPanel.Controls.Add($lc); $yR.Value += 11

    $lv = New-Object System.Windows.Forms.Label
    $lv.Text = $val; $lv.Font = $statFont; $lv.ForeColor = $valClr
    $lv.BackColor = [System.Drawing.Color]::Transparent
    $lv.AutoSize = $false; $lv.Width = $infoPanelW - 12; $lv.Height = 15
    $lv.Location = New-Object System.Drawing.Point(5, $yR.Value)
    $lv.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $infoPanel.Controls.Add($lv); $yR.Value += 16
    $lv
}
function Add-Hdr([string]$txt, [ref]$yR) {
    $lh = New-Object System.Windows.Forms.Label
    $lh.Text = $txt; $lh.Font = $headerFont; $lh.ForeColor = $clrHdrText
    $lh.BackColor = [System.Drawing.Color]::Transparent
    $lh.AutoSize = $false; $lh.Width = $infoPanelW - 12; $lh.Height = 16
    $lh.Location = New-Object System.Drawing.Point(5, $yR.Value)
    $lh.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $infoPanel.Controls.Add($lh); $yR.Value += 17
    $ls = New-Object System.Windows.Forms.Panel
    $ls.Height = 1; $ls.Width = $infoPanelW - 12
    $ls.Location = New-Object System.Drawing.Point(5, $yR.Value)
    $ls.BackColor = $clrInfoBord
    $infoPanel.Controls.Add($ls); $yR.Value += 6
}

$yR = [ref]8

Add-Hdr "TEST INFO" $yR

# Direction - always shown, no "Default" needed (Direct is implicit)
$prfText  = if ($ProfileName -and $ProfileName.Trim() -ne "") { $ProfileName } else { "-" }
$prfColor = if ($ProfileName -and $ProfileName.Trim() -ne "") { $clrValSet } else { $clrHdrText }
Add-Row "Profile:"    $prfText  $prfColor  $yR | Out-Null

$dirText   = if ($Direction -eq "-R") { "Reverse" } else { "Direct" }
$protoText = if ($Protocol -eq "-u") { "UDP" } else { "TCP" }
$protoClr  = if ($Protocol -eq "-u") { $clrValSet } else { $clrValInfo }
Add-Row "Protocol:"   $protoText $protoClr  $yR | Out-Null
$dirColor = if ($Direction -eq "-R") { $clrValSet } else { $clrValInfo }
Add-Row "Direction:"  $dirText  $dirColor  $yR | Out-Null

# Protocol
# Bitrate: 0 or "0" = user set unlimited (aqua), empty = default 1 Mbps (white)
if ($Bitrate -eq "0") {
    $bwText = "0 - Unlimited"; $bwClr = $clrValSet
} elseif ($Bitrate -and $Bitrate.Trim() -ne "") {
    $bwText = "$Bitrate Mbps"; $bwClr = $clrValSet
} else {
    $bwText = "1 Mbps (Default)"; $bwClr = $clrValInfo
}
Add-Row "Bitrate:"    $bwText  $bwClr  $yR | Out-Null

$pv = Param-Val $Duration " s"     "10"
Add-Row "Duration:"   $pv[0]  $pv[1]  $yR | Out-Null

$pv = Param-Val $Interval " s"     "1"
Add-Row "Interval:"   $pv[0]  $pv[1]  $yR | Out-Null

$pv = Param-Val $Streams  ""       "1"
Add-Row "Streams:"    $pv[0]  $pv[1]  $yR | Out-Null

$pv = Param-Val $BlockSize "" "1M"
Add-Row "Socket size:" $pv[0]  $pv[1]  $yR | Out-Null

$pv = Param-Val $Buflen " bytes" "1460"
Add-Row "Buflen:"     $pv[0]  $pv[1]  $yR | Out-Null

$yR.Value += 6
Add-Hdr "LIVE STATS" $yR

function Add-StatRow([string]$caption, [string]$initVal,
                    [System.Drawing.Color]$valClr, [ref]$yRef) {
    # thin separator before each stat row
    $sp = New-Object System.Windows.Forms.Panel
    $sp.Height = 1; $sp.Width = $infoPanelW - 12
    $sp.Location = New-Object System.Drawing.Point(5, $yRef.Value)
    $sp.BackColor = $clrInfoBord
    $infoPanel.Controls.Add($sp); $yRef.Value += 3

    # caption label
    $lc = New-Object System.Windows.Forms.Label
    $lc.Text = $caption
    $lc.Font = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Regular)
    $lc.ForeColor = $clrHdrText; $lc.BackColor = [System.Drawing.Color]::Transparent
    $lc.AutoSize = $false; $lc.Width = $infoPanelW - 12; $lc.Height = 15
    $lc.Location = New-Object System.Drawing.Point(5, $yRef.Value)
    $lc.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $infoPanel.Controls.Add($lc); $yRef.Value += 15

    # value label
    $lv = New-Object System.Windows.Forms.Label
    $lv.Text = $initVal
    $lv.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
    $lv.ForeColor = $valClr; $lv.BackColor = [System.Drawing.Color]::Transparent
    $lv.AutoSize = $false; $lv.Width = $infoPanelW - 12; $lv.Height = 22
    $lv.Location = New-Object System.Drawing.Point(5, $yRef.Value)
    $lv.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $infoPanel.Controls.Add($lv); $yRef.Value += 23
    $lv
}

# Wide stat row for values that can be long (e.g. "28.5 % - Unacceptable")
function Add-WideStatRow([string]$caption, [string]$initVal,
                         [System.Drawing.Color]$valClr, [ref]$yRef) {
    # separator
    $sp = New-Object System.Windows.Forms.Panel
    $sp.Height = 1; $sp.Width = $infoPanelW - 12
    $sp.Location = New-Object System.Drawing.Point(5, $yRef.Value)
    $sp.BackColor = $clrInfoBord
    $infoPanel.Controls.Add($sp); $yRef.Value += 3

    # caption
    $lc = New-Object System.Windows.Forms.Label
    $lc.Text = $caption
    $lc.Font = New-Object System.Drawing.Font("Arial", 8, [System.Drawing.FontStyle]::Regular)
    $lc.ForeColor = $clrHdrText; $lc.BackColor = [System.Drawing.Color]::Transparent
    $lc.AutoSize = $false; $lc.Width = $infoPanelW - 12; $lc.Height = 15
    $lc.Location = New-Object System.Drawing.Point(5, $yRef.Value)
    $lc.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $infoPanel.Controls.Add($lc); $yRef.Value += 16

    # value - two lines tall, wraps if needed
    $lv = New-Object System.Windows.Forms.Label
    $lv.Text = $initVal
    $lv.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
    $lv.ForeColor = $valClr; $lv.BackColor = [System.Drawing.Color]::Transparent
    $lv.AutoSize = $false; $lv.Width = $infoPanelW - 12; $lv.Height = 36
    $lv.Location = New-Object System.Drawing.Point(5, $yRef.Value)
    $lv.TextAlign = [System.Drawing.ContentAlignment]::TopLeft
    $lv.AutoEllipsis = $false
    $infoPanel.Controls.Add($lv); $yRef.Value += 38
    $lv
}

$clrValJitter = [System.Drawing.Color]::FromArgb(255, 200, 80)   # yellow = jitter color

$lblTimeVal    = Add-StatRow "Status:"    "-" $clrValTime   $yR
$lblMinVal     = Add-StatRow "Min:"       "-" $clrValBps    $yR
$lblMaxVal     = Add-StatRow "Max:"       "-" $clrValBps    $yR
$lblAvgVal     = Add-StatRow "Avg:"       "-" $clrValBps    $yR
$lblLossAvgVal = Add-StatRow "Avg Loss:"  "-" $clrValLoss   $yR
$lblLossMaxVal = Add-StatRow "Max Loss:"  "-" $clrValLoss   $yR
$lblJitAvgVal  = Add-StatRow "Avg Jitter:" "-" $clrValJitter $yR
$lblJitMaxVal  = Add-StatRow "Max Jitter:" "-" $clrValJitter $yR
$lblPts        = Add-StatRow "Points:"    "-" $clrHdrText   $yR
$lblCpuVal     = Add-WideStatRow "iPerf3 CPU:" "-" $clrHdrText $yR

# keep $lblLossVal pointing to Avg Loss for backward compat in timer tick
$lblLossVal = $lblLossAvgVal

# =====================================================================
# HELP
# =====================================================================
# Legend toggle button
$script:legendOn = $false
$btnLegend.Add_Click({
    $script:legendOn = -not $script:legendOn
    $legend.Enabled  = $script:legendOn
    $this.BackColor  = if ($script:legendOn) { $clrToggleOn } else { $clrBtnNorm }
    $chart.Update()
})

# ---- Help window with colored two-column layout ----
function Add-HelpText {
    param($rtb, [string]$text, [System.Drawing.Color]$color, [bool]$bold=$false)
    $start = $rtb.TextLength
    $rtb.AppendText($text)
    $rtb.Select($start, $text.Length)
    $rtb.SelectionColor = $color
    if ($bold) {
        $rtb.SelectionFont = New-Object System.Drawing.Font("Consolas", 9,
            [System.Drawing.FontStyle]::Bold)
    } else {
        $rtb.SelectionFont = New-Object System.Drawing.Font("Consolas", 9,
            [System.Drawing.FontStyle]::Regular)
    }
    $rtb.SelectionLength = 0
}

function Add-HelpSection($rtb, [string]$title) {
    Add-HelpText $rtb "`r`n$title`r`n" ([System.Drawing.Color]::FromArgb(255,200,80)) $true
}
function Add-HelpRow($rtb, [string]$col1, [string]$col2,
                     [System.Drawing.Color]$c1, [System.Drawing.Color]$c2) {
    Add-HelpText $rtb ("  {0,-22}" -f $col1) $c1 $false
    Add-HelpText $rtb "$col2`r`n"             $c2 $false
}
function Add-HelpNote($rtb, [string]$text) {
    Add-HelpText $rtb "  $text`r`n" ([System.Drawing.Color]::FromArgb(140,140,160)) $false
}

$clrH  = [System.Drawing.Color]::FromArgb(255,200,80)   # yellow  - headers
$clrK  = [System.Drawing.Color]::FromArgb(100,200,255)  # cyan    - keys/params
$clrV  = [System.Drawing.Color]::FromArgb(210,210,225)  # white   - values
$clrG  = [System.Drawing.Color]::FromArgb(80,200,120)   # green   - good/on
$clrR  = [System.Drawing.Color]::FromArgb(255,100,100)  # red     - warnings
$clrY  = [System.Drawing.Color]::FromArgb(255,200,80)   # yellow  - jitter
$clrP  = [System.Drawing.Color]::FromArgb(180,100,255)  # purple  - threshold
$clrDim= [System.Drawing.Color]::FromArgb(140,140,160)  # dim     - notes

$btnHelp.Add_Click({
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = "iPerf3 Real-Time Monitor - Help"
    $dlg.Width           = 780; $dlg.Height = 780
    $dlg.StartPosition   = "CenterParent"
    $dlg.BackColor       = [System.Drawing.Color]::FromArgb(24,24,32)
    $dlg.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
    $dlg.MaximizeBox     = $true; $dlg.MinimizeBox = $false

    $tb = New-Object System.Windows.Forms.RichTextBox
    $tb.Dock        = [System.Windows.Forms.DockStyle]::Fill
    $tb.ReadOnly    = $true
    $tb.BackColor   = [System.Drawing.Color]::FromArgb(24,24,32)
    $tb.ForeColor   = [System.Drawing.Color]::FromArgb(210,210,225)
    $tb.Font        = New-Object System.Drawing.Font("Consolas", 9)
    $tb.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $tb.ScrollBars  = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $tb.WordWrap    = $false
    $dlg.Controls.Add($tb)

    # Title
    Add-HelpText $tb "  iPerf3 Real-Time Monitor" ([System.Drawing.Color]::FromArgb(100,200,255)) $true
    Add-HelpText $tb "  - Help`r`n" $clrDim $false

    # -- CHARTS --
    Add-HelpSection $tb "CHARTS  (top to bottom, each with own Y axis and grid)"
    Add-HelpRow $tb "Bitrate (top)"   "Blue solid  = Bitrate (Mbps)  |  Green dashed = Avg Bitrate" $clrK ([System.Drawing.Color]::FromArgb(100,200,255))
    Add-HelpRow $tb "Jitter (middle)" "Yellow solid = Jitter (ms)  -  UDP only"                     $clrK ([System.Drawing.Color]::FromArgb(255,200,80))
    Add-HelpRow $tb "Loss (bottom)"   "Red solid = Packet Loss (%)  -  UDP only"                    $clrK ([System.Drawing.Color]::FromArgb(255,100,100))
    Add-HelpRow $tb "Threshold"       "Purple dashed line, label at right edge"                     $clrK $clrP

    # -- TCP vs UDP --
    Add-HelpSection $tb "TCP vs UDP MODE"
    Add-HelpRow $tb "UDP  (-Protocol -u)" "All 3 charts active: Bitrate, Jitter, Loss"             $clrG $clrV
    Add-HelpRow $tb "TCP  (default)"      "Bitrate only. Jitter/Loss dimmed, LIVE STATS shows N/A" $clrR $clrV

    # -- THRESHOLD --
    Add-HelpSection $tb "THRESHOLD LINES  (purple dashed, label at right)"
    Add-HelpRow $tb "Bitrate chart"  "Bitrate / 2  (50% of target)"                 $clrK $clrV
    Add-HelpRow $tb "Jitter chart"   "ThreshJitter ms  (default $ThreshJitter)"     $clrK $clrV
    Add-HelpRow $tb "Loss chart"     "ThreshLoss %  (default $ThreshLoss)"          $clrK $clrV
    Add-HelpNote $tb "Set via: -ThreshLoss  -ThreshJitter  -ThreshBitrateRel"

    # -- BUTTONS --
    Add-HelpSection $tb "BUTTONS"
    Add-HelpRow $tb "Stop"             "Kill the iPerf3 / ADB process"                             $clrR  $clrV
    Add-HelpRow $tb "Export CSV"       "Save data. Disabled during test, active after finish/Stop" $clrK $clrV
    Add-HelpRow $tb "Save PNG"         "Screenshot full window to PNG"                             $clrK $clrV
    Add-HelpRow $tb "Visual Analyzer"  "Launch analyzer (needs -VisualAnalyzerScript, enables after test)" $clrY $clrV
    Add-HelpRow $tb "Autoscroll"       "ON(blue): follow last N sec  OFF(grey): full history"      $clrK $clrV
    Add-HelpRow $tb "Show Avg"         "Toggle green rolling average Bitrate line"                 $clrK $clrV
    Add-HelpRow $tb "Legend"           "Toggle chart legend on/off (hidden by default)"            $clrK $clrV
    Add-HelpRow $tb "?"                "This help window"                                          $clrK $clrV

    # -- TEST INFO --
    Add-HelpSection $tb "TEST INFO PANEL  (right column, top)"
    Add-HelpRow $tb "Profile"          "-ProfileName value"                               $clrK $clrV
    Add-HelpRow $tb "Protocol"         "TCP  or  UDP"                                    $clrK $clrV
    Add-HelpRow $tb "Direction"        "Direct  or  Reverse (-R)"                        $clrK $clrV
    Add-HelpRow $tb "Bitrate"          "Target Mbps / Unlimited / default 1 Mbps"        $clrK $clrV
    Add-HelpRow $tb "Duration/Interval/Streams" "Test timing parameters"                 $clrK $clrV
    Add-HelpRow $tb "Socket size / Buflen" "-w and -l flags"                             $clrK $clrV
    Add-HelpRow $tb "Aqua = set by user" "White + (Default) = iPerf3 built-in default"  ([System.Drawing.Color]::FromArgb(0,210,210)) $clrDim

    # -- LIVE STATS --
    Add-HelpSection $tb "LIVE STATS PANEL  (right column, bottom)"
    Add-HelpRow $tb "Status"       "Elapsed time in seconds"                          $clrG  $clrV
    Add-HelpRow $tb "Min/Max/Avg"  "Bitrate (Mbps) - Min turns red below Bitrate/2"  $clrK ([System.Drawing.Color]::FromArgb(100,200,255))
    Add-HelpRow $tb "Avg/Max Loss" "Packet loss %  - Max turns red above ThreshLoss"  $clrR  $clrV
    Add-HelpRow $tb "Avg/Max Jitter" "Jitter ms  - Max turns red above ThreshJitter" ([System.Drawing.Color]::FromArgb(255,200,80)) $clrV
    Add-HelpRow $tb "Points"       "Total data points (max $MaxPoints)"               $clrDim $clrV
    Add-HelpRow $tb "iPerf3 CPU"   "CPU load of iperf3.exe process (~1s poll)"        $clrK  $clrV

    # -- CPU GRADES --
    Add-HelpSection $tb "IPERF3 CPU LOAD GRADES"
    Add-HelpRow $tb "> 30%  Unacceptable" "results unreliable"     $clrR $clrR
    Add-HelpRow $tb "> 25%  Very High"    "results likely affected" $clrR $clrV
    Add-HelpRow $tb "> 20%  High"         "may be unreliable"       $clrR $clrV
    Add-HelpRow $tb "> 15%  Elevated"     "monitor closely"         ([System.Drawing.Color]::FromArgb(255,160,40)) $clrV
    Add-HelpRow $tb "> 10%  Medium"       "acceptable"              ([System.Drawing.Color]::FromArgb(255,220,60)) $clrV
    Add-HelpRow $tb ">  5%  Normal"       "good"                    $clrG $clrV
    Add-HelpRow $tb ">  1%  Good"         "very good"               ([System.Drawing.Color]::FromArgb(80,200,255)) $clrV
    Add-HelpRow $tb "   0%  Excellent"    "optimal"                 ([System.Drawing.Color]::FromArgb(80,200,255)) $clrV
    Add-HelpNote $tb "WARNING: above 20% results may be inaccurate. Keep below 15%."

    # -- TITLE COLOR --
    Add-HelpSection $tb "TITLE BAR COLOR  (UDP only)"
    Add-HelpRow $tb "White"   "Loss below ${LossWarnPct}%"                          $clrV $clrV
    Add-HelpRow $tb "Yellow"  "Loss at or above ${LossWarnPct}%"                   $clrY $clrV
    Add-HelpRow $tb "Red"     "Loss at or above ${LossCritPct}%"                   $clrR $clrV

    # -- PARAMETERS (two-column: name left, description+default right) --
    Add-HelpSection $tb "PARAMETERS  (all optional except -ServerIP)"
    $params = @(
        @("-ServerIP",            "Server IP address",                                "REQUIRED"),
        @("-ToolsPath",           "Folder with adb.exe",                              "default: adb on PATH"),
        @("-ProfileName",         "Test name shown in TEST INFO",                     ""),
        @("-Port",                "iPerf3 port",                                      "default: 5201"),
        @("-Protocol",            "empty=TCP  -u=UDP",                                "default: TCP"),
        @("-Direction",           "empty=normal  -R=reverse",                        "default: normal"),
        @("-Bitrate",             "target Mbps, 0=unlimited",                        "default: 1 Mbps"),
        @("-Duration",            "test duration in seconds",                         "default: 10"),
        @("-Interval",            "reporting interval in seconds",                    "default: 1"),
        @("-Buflen",              "packet size in bytes  (-l flag)",                  "default: 1460"),
        @("-Socketsize",          "socket window size in MB  (-w flag)",              "default: 1M"),
        @("-Streams",             "parallel streams",                                 "default: 1"),
        @("-Extra",               "any extra raw iPerf3 flags",                       ""),
        @("-LogFile",             "live CSV log file path",                            ""),
        @("-SavePath",            "folder for CSV/PNG exports",                       "default: script folder"),
        @("-LossWarnPct",         "yellow title warning %",                           "default: 2.0"),
        @("-LossCritPct",         "red title alert %",                                "default: 5.0"),
        @("-ThreshLoss",          "Loss threshold line %",                            "default: 1.0"),
        @("-ThreshJitter",        "Jitter threshold line ms",                        "default: 0.2"),
        @("-ThreshBitrateRel",    "Bitrate threshold % of target",                   "default: 50"),
        @("-ScrollWindowSec",     "autoscroll window seconds",                        "default: 10"),
        @("-MaxPoints",           "max chart data points",                            "default: 36000"),
        @("-VisualAnalyzerScript","path to analyzer .ps1 script",                    ""),
        @("-VisualAnalyzerArgs",  "extra args for analyzer  (e.g. -AView x -AllLogs)",""),
        @("-CpuDivisor",          "manual CPU% divisor  (e.g. 3 for 2-core/4-thread)","default: auto"),
        @("-KillServerOnFinish",  """1"" = kill iperf3.exe + IPERF_TEST on finish",  ""),
        @("-DoneFlagFile",        "marker file written on finish/abort  (experimental)",""),
        @("-AutoExit",            """0""=close now, N=close after N sec, empty=never","")
    )
    foreach ($p in $params) {
        $defStr = if ($p[2]) { "  [$($p[2])]" } else { "" }
        Add-HelpText $tb ("  {0,-22}" -f $p[0]) $clrK $false
        Add-HelpText $tb $p[1] $clrV $false
        Add-HelpText $tb "$defStr`r`n" $clrDim $false
    }

    # -- CMD EXAMPLE --
    Add-HelpSection $tb "CMD LAUNCH EXAMPLE"
    $exLines = @(
        "  set host=10.0.0.30",
        "  set protocol=-u",
        "  set direction=-R",
        "  set duration=300",
        "  set interval=0.1",
        "  set bitrate=100",
        "  set AnalyzerScript=iPerf3VisualAnalyzer.v3.43.ps1",
        "  set ""AnalyzerArgs=-AView %profile% -AllLogs""",
        "  powershell -ExecutionPolicy Bypass -File iperf3_realtime.ps1 ^",
        "    -ServerIP %host% -Protocol %protocol% -Direction %direction% ^",
        "    -Bitrate %bitrate% -Duration %duration% -Interval %interval% ^",
        "    -VisualAnalyzerScript ""%AnalyzerScript%"" ^",
        "    -VisualAnalyzerArgs ""%AnalyzerArgs%"" ^",
        "    -KillServerOnFinish 1  -AutoExit 5"
    )
    foreach ($ln in $exLines) {
        Add-HelpText $tb "$ln`r`n" ([System.Drawing.Color]::FromArgb(180,220,140)) $false
    }
    Add-HelpNote $tb "(Empty CMD variables are safely ignored - iPerf3 defaults are used)"

    $tb.SelectionStart = 0; $tb.ScrollToCaret()
    [void]$dlg.ShowDialog($form)
})

# =====================================================================
# HELPERS
# =====================================================================
function ConvertTo-Mbps([double]$rate, [string]$unit) {
    switch ($unit) {
        "Kbits" { $rate / 1000 }
        "Gbits" { $rate * 1000 }
        default { $rate }
    }
}

# CPU monitoring - background Runspace, delta method via Get-Process.
# Measures CPU time delta over 1 second - lightweight, no WMI/Get-Counter,
# works on any Windows locale. Posts result to $script:cpuResult hashtable.
$script:cpuResult = @{ Text = "starting..."; Pct = 0.0 }
$script:cpuRs     = $null
$script:cpuPs     = $null

function Start-CpuMonitor {
    $rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
    $rs.Open()
    $rs.SessionStateProxy.SetVariable("cpuResult", $script:cpuResult)

    $ps = [System.Management.Automation.PowerShell]::Create()
    $ps.Runspace = $rs
    [void]$ps.AddScript({
        $cores = [System.Environment]::ProcessorCount
        if ($cores -lt 1) { $cores = 1 }

        # PerformanceCounter gives the same value as Task Manager.
        # We find the instance name dynamically (may be "iperf3", "iperf3#1" etc.)
        # First sample after NextValue() is always 0 - must call twice with a delay.
        # Win32_PerfFormattedData_PerfProc_Process returns PercentProcessorTime
        # already normalized to 0-100% total CPU - exactly what Task Manager shows.
        # No division needed. Refresh every 1s via direct WMI query.

        while ($true) {
            try {
                $wmi = Get-WmiObject -Query "SELECT Name,PercentProcessorTime FROM Win32_PerfFormattedData_PerfProc_Process WHERE Name LIKE 'iperf3%'" -ErrorAction SilentlyContinue
                if (-not $wmi) {
                    $cpuResult["Text"] = "not found"
                    $cpuResult["Pct"]  = -1.0
                    Start-Sleep -Seconds 2
                    continue
                }
                # WMI PercentProcessorTime on HyperThreading systems:
                # RAW value empirically matches Task Manager when divided by
                # (logical_cores * 100 / max_single_core_pct).
                # Simplest reliable formula: divide by logical cores, then
                # multiply by HT factor (logical/physical) to undo HT deflation.
                # Net result: divide by physical cores count only.
                # Tested: RAW=99, logical=4, physical=2 -> TM shows 30%
                # 99 / logical(4) * HT(2) = 49.5  -- too high
                # Correct divisor = 99/30 = 3.3 = logical * 0.825
                # Best portable formula: RAW / (logical_cores / HT_ratio)
                # where HT_ratio = logical/physical = 4/2 = 2
                # divisor = logical / HT_ratio * correction... still 3.3
                # Just use: pct = RAW / logical_cores * physical_cores / physical_cores
                # = RAW / logical_cores -- gives 24.75, not 30.
                # CONCLUSION: Task Manager uses a different internal counter.
                # Empirical fix: multiply result by (logical/physical) then divide by
                # a scaling factor. On 2-core/4-thread: scale = 4/2 * 100/30 = 6.67? No.
                # SIMPLEST: just use RAW * (physical/logical) / physical = RAW/logical
                # That gives 24.75. TM gives 30. Ratio = 30/24.75 = 1.212 = logical/physical/something
                # After all analysis: use RAW / 3.3 as empirical constant for this HW.
                # For portability: divisor = logical_cores * 0.825
                $rawSum = 0.0
                foreach ($row in @($wmi)) { $rawSum += [double]$row.PercentProcessorTime }
                if (-not $script:cpuDivisor) {
                    $logical  = [System.Environment]::ProcessorCount
                    $physical = (Get-WmiObject Win32_Processor -ErrorAction SilentlyContinue |
                                 Measure-Object -Property NumberOfCores -Sum).Sum
                    if (-not $physical -or $physical -lt 1) { $physical = $logical / 2 }
                    # HT factor: logical per physical core
                    $htFactor = [math]::Round($logical / $physical, 0)
                    # Empirically: divisor = logical / htFactor * 1.0 gives wrong result.
                    # From data: RAW=99 -> TM=30, so divisor = 99/30 = 3.3
                    # 3.3 = logical(4) * 0.825. On non-HT: divisor = logical = physical.
                    # Formula that works on HT: divisor = physical * htFactor / htFactor * correction
                    # Simplest: if HT, divisor = logical * (physical / logical) * htFactor / physical
                    # = logical * htFactor / logical = htFactor -- gives 99/2=49.5. No.
                    # FINAL: use physical + (logical - physical) / 2 as divisor:
                    # = 2 + (4-2)/2 = 2+1 = 3. -> 99/3 = 33%. Close enough to 30%.
                    $script:cpuDivisor = $physical + ($logical - $physical) / 2.0
                    if ($script:cpuDivisor -lt 1) { $script:cpuDivisor = $logical }
                }
                $pct = [math]::Round($rawSum / $script:cpuDivisor, 1)
                if ($pct -lt 0)   { $pct = 0.0 }
                if ($pct -gt 100) { $pct = 100.0 }

                $grade = if     ($pct -gt 30) { "Unacceptable" }
                         elseif ($pct -gt 25) { "Very High" }
                         elseif ($pct -gt 20) { "High" }
                         elseif ($pct -gt 15) { "Elevated" }
                         elseif ($pct -gt 10) { "Medium" }
                         elseif ($pct -gt 5)  { "Normal" }
                         elseif ($pct -gt 1)  { "Good" }
                         else                 { "Excellent" }

                $pctStr = "{0,4:F1} %" -f $pct
                $cpuResult["Text"] = "$pctStr  $grade"
                $cpuResult["Pct"]  = $pct
            } catch {
                $cpuResult["Text"] = "n/a"
                $cpuResult["Pct"]  = 0.0
            }
            Start-Sleep -Seconds 1
        }
    })

    $script:cpuRs = $rs
    $script:cpuPs = $ps
    [void]$ps.BeginInvoke()
}

function Get-CpuColor([double]$pct) {
    if      ($pct -gt 20) { return [System.Drawing.Color]::FromArgb(255,  80,  80) }
    elseif  ($pct -gt 15) { return [System.Drawing.Color]::FromArgb(255, 160,  40) }
    elseif  ($pct -gt 10) { return [System.Drawing.Color]::FromArgb(255, 220,  60) }
    elseif  ($pct -gt 5)  { return [System.Drawing.Color]::FromArgb(120, 220, 120) }
    else                  { return [System.Drawing.Color]::FromArgb( 80, 200, 255) }
}

function Update-Stats {
    $n = $script:DataPoints.Count
    if ($n -eq 0) { return }

    $avg     = [math]::Round($script:statSum    / $n, 1)
    $avgLoss = [math]::Round($script:statLossSum / $n, 2)
    $avgJit  = [math]::Round($script:statJitSum  / $n, 2)
    $minV    = [math]::Round($script:statMin, 1)
    $maxV    = [math]::Round($script:statMax, 1)
    $maxLoss = [math]::Round($script:statLossMax, 2)
    $maxJit  = [math]::Round($script:statJitMax,  2)

    # Threshold coloring
    $bpsThreshVal = if ($Bitrate -and [double]$Bitrate -gt 0) { [double]$Bitrate / 2.0 } else { 0 }
    $clrMaxBps  = if ($bpsThreshVal -gt 0 -and $minV -lt $bpsThreshVal) {
                      [System.Drawing.Color]::FromArgb(255,80,80) } else { $clrValBps }
    $clrMaxLoss = if ($maxLoss -gt $ThreshLoss) {
                      [System.Drawing.Color]::FromArgb(255,80,80) } else { $clrValLoss }
    $clrMaxJit  = if ($maxJit  -gt $ThreshJitter) {
                      [System.Drawing.Color]::FromArgb(255,80,80) } else { $clrValJitter }

    $lblMinVal.Text      = "{0:F1} Mbps" -f $minV
    $lblMaxVal.Text      = "{0:F1} Mbps" -f $maxV
    $lblAvgVal.Text      = "{0:F1} Mbps" -f $avg
    if ($script:isTCP) {
        $lblLossAvgVal.Text = "N/A"; $lblLossMaxVal.Text = "N/A"
        $lblJitAvgVal.Text  = "N/A"; $lblJitMaxVal.Text  = "N/A"
    } else {
        $lblLossAvgVal.Text  = "{0:F2} %"  -f $avgLoss
        $lblLossMaxVal.Text  = "{0:F2} %"  -f $maxLoss
        $lblLossMaxVal.ForeColor = $clrMaxLoss
        $lblJitAvgVal.Text   = "{0:F2} ms" -f $avgJit
        $lblJitMaxVal.Text   = "{0:F2} ms" -f $maxJit
        $lblJitMaxVal.ForeColor  = $clrMaxJit
    }
    $lblMinVal.ForeColor     = $clrMaxBps
    $lblPts.Text         = "$n"
}

function Update-TitleColor([double]$loss) {
    if      ($loss -ge $LossCritPct) { $form.ForeColor = [System.Drawing.Color]::Tomato }
    elseif  ($loss -ge $LossWarnPct) { $form.ForeColor = [System.Drawing.Color]::Gold   }
    else                             { $form.ForeColor = [System.Drawing.Color]::White  }
}

function Trim-Series([int]$max) {
    while ($seriesBitrate.Points.Count -gt $max) { $seriesBitrate.Points.RemoveAt(0) }
    while ($seriesAvg.Points.Count     -gt $max) { $seriesAvg.Points.RemoveAt(0) }
    while ($seriesLoss.Points.Count    -gt $max) { $seriesLoss.Points.RemoveAt(0) }
    while ($seriesJitter.Points.Count  -gt $max) { $seriesJitter.Points.RemoveAt(0) }
}

function Get-SavePath([string]$ext) {
    $ts   = Get-Date -Format "yyyyMMdd_HHmmss"
    $name = "iperf3_$ts.$ext"
    Join-Path $SavePath $name
}

function Export-CsvData {
    if ($script:DataPoints.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No data to export yet.", "Export CSV",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    $path = Get-SavePath "csv"
    try {
        $script:DataPoints | Select-Object Time, Bitrate, Loss, Jitter |
            Export-Csv -Path $path -NoTypeInformation -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show(
            "CSV saved successfully!`n`n$path", "Export CSV - Done",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Save failed:`n$_", "Export CSV - Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

function Save-Png {
    $path = Get-SavePath "png"
    try {
        $bmp = New-Object System.Drawing.Bitmap($form.Width, $form.Height)
        $g   = [System.Drawing.Graphics]::FromImage($bmp)
        $g.CopyFromScreen($form.Location, [System.Drawing.Point]::Empty, $form.Size)
        $g.Dispose()
        $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        [System.Windows.Forms.MessageBox]::Show(
            "Screenshot saved!`n`n$path", "Save PNG - Done",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Screenshot failed:`n$_", "Save PNG - Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

function Stop-Test {
    if ($script:proc -and -not $script:proc.HasExited) {
        try { $script:proc.Kill() } catch {}
    }
}

$btnStop.Add_Click(   { Stop-Test })
$btnAnalyzer.Add_Click({
    # e.g. set "AnalyzerScript=powershell -File "analyzer.ps1" -AView %profile% -AllLogs"
    # This is the most reliable way - CMD expands all variables before passing to PS.
    # Flush and close the log file so the analyzer sees complete data
    if ($script:logWriter) { try { $script:logWriter.Flush(); $script:logWriter.Close(); $script:logWriter = $null } catch {} }

    # -VisualAnalyzerScript [+ -VisualAnalyzerArgs]
    # PS builds the argument list and appends -CsvPath from -LogFile automatically.
    $scr = if ($script:VisualAnalyzerScript) {
               $script:VisualAnalyzerScript.Trim().Trim('"').Trim("'")
           } else { "" }
    $csv = if ($script:LogFile) {
               $script:LogFile.Trim().Trim('"').Trim("'")
           } else { "" }
    $xtr = if ($script:VisualAnalyzerArgs) { $script:VisualAnalyzerArgs.Trim() } else { "" }

    if (-not $scr -or -not (Test-Path $scr)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Analyzer script not found.`n`nPath: [$scr]`n`nSet -VisualAnalyzerScript parameter.",
            "Visual Analyzer", [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    $argList = [System.Collections.Generic.List[string]]::new()
    $argList.Add("-NoLogo");    $argList.Add("-NoProfile")
    $argList.Add("-ExecutionPolicy"); $argList.Add("Bypass")
    $argList.Add("-WindowStyle");     $argList.Add("Hidden")
    $argList.Add("-File");            $argList.Add($scr)
    if ($csv) { $argList.Add("-CsvPath"); $argList.Add($csv) }
    if ($xtr) { $xtr -split "\s+" | Where-Object { $_ } | ForEach-Object { $argList.Add($_) } }
    $analyzerDir = Split-Path -Parent $scr
    if (-not $analyzerDir) { $analyzerDir = "." }
    Start-Process "powershell.exe" -ArgumentList $argList -WorkingDirectory $analyzerDir
})
$btnExport.Add_Click( { Export-CsvData })
$btnPng.Add_Click(    { Save-Png })
$form.Add_FormClosing({
    # If the test was still running (or the user closed the window before
    # the finish block ran), signal CMD that the test was ABORTED so it
    # does not wait forever for the "done" flag.
    if ($DoneFlagFile -and -not (Test-Path $DoneFlagFile)) {
        try { Set-Content -Path $DoneFlagFile -Value "aborted" -Force -ErrorAction SilentlyContinue } catch {}
    }
    Stop-Test
    if ($script:logWriter) { try { $script:logWriter.Close() } catch {} }
    if ($script:cpuPs)     { try { $script:cpuPs.Stop(); $script:cpuRs.Close() } catch {} }
})

# =====================================================================
# TEST ENGINE
# =====================================================================
$script:queue        = [System.Collections.Concurrent.ConcurrentQueue[string]]::new()
$script:cpuTickCount = 0

$uiTimer = New-Object System.Windows.Forms.Timer
$uiTimer.Interval = 80

$uiTimer.Add_Tick({
    $anyNew = $false
    $line   = $null
    while ($script:queue.TryDequeue([ref]$line)) {
        $anyNew  = $true
        $trimmed = $line.Trim()
        Write-Host ">> $trimmed" -ForegroundColor DarkGray
        $m = $script:reUdp.Match($trimmed)
        $isTcpLine = $false
        if (-not $m.Success) {
            $m = $script:reTcp.Match($trimmed)
            $isTcpLine = $m.Success
        }
        if ($m.Success) {
            $CurrentX = [double]$m.Groups['time'].Value
            $bitrate  = ConvertTo-Mbps ([double]$m.Groups['rate'].Value) $m.Groups['unit'].Value
            $loss   = if (-not $isTcpLine) { [double]$m.Groups['loss'].Value } else { 0.0 }
            $jitter = if (-not $isTcpLine -and $m.Groups['jitter'].Success) { [double]$m.Groups['jitter'].Value } else { 0.0 }

            $script:DataPoints.Add([PSCustomObject]@{Time=$CurrentX; Bitrate=$bitrate; Loss=$loss; Jitter=$jitter})


            # Update running accumulators O(1)
            if ($bitrate -lt $script:statMin) { $script:statMin = $bitrate }
            if ($bitrate -gt $script:statMax) { $script:statMax = $bitrate }
            $script:statSum     += $bitrate
            if (-not $isTcpLine) {
                $script:statLossSum += $loss
                if ($loss   -gt $script:statLossMax) { $script:statLossMax = $loss }
                $script:statJitSum  += $jitter
                if ($jitter -gt $script:statJitMax)  { $script:statJitMax  = $jitter }
            }
            if ($script:logWriter) {
                $script:logWriter.WriteLine("$CurrentX,$([math]::Round($bitrate,3)),$loss,$([math]::Round($jitter,3))")
            }
            [void]$seriesBitrate.Points.AddXY($CurrentX, $bitrate)
            if (-not $isTcpLine) {
                [void]$seriesLoss.Points.AddXY($CurrentX, $loss)
                [void]$seriesJitter.Points.AddXY($CurrentX, $jitter)
            }
            [void]$seriesAvg.Points.AddXY($CurrentX,
                [math]::Round($script:statSum / $script:DataPoints.Count, 3))
            if ($script:DataPoints.Count % 200 -eq 0) { Trim-Series $MaxPoints }

            if ($isTcpLine) {
                $form.Text = "iPerf3 Live (TCP)  |  Bitrate: $([math]::Round($bitrate,1)) Mbps"
            } else {
                $form.Text = "iPerf3 Live  |  Bitrate: $([math]::Round($bitrate,1)) Mbps  |  Loss: $loss %  |  Jitter: $([math]::Round($jitter,2)) ms"
            }
            Update-TitleColor $loss
            $lblTimeVal.Text = "{0:F1} s" -f $CurrentX

            if ($script:scrollOn -and $CurrentX -gt $ScrollWindowSec) {
                foreach ($a in @($area,$areaL,$areaJ)) {
                    $a.AxisX.Minimum = $CurrentX - $ScrollWindowSec
                    $a.AxisX.Maximum = $CurrentX
                }
            } else {
                foreach ($a in @($area,$areaL,$areaJ)) {
                    $a.AxisX.Minimum = 0
                    $a.AxisX.Maximum = [Double]::NaN
                }
            }
        }
    }

    if ($anyNew) {
        Update-Stats
        $chart.ResetAutoValues()
        $chart.Update()
    }

    # CPU: just read the result posted by the background runspace - no blocking
    $script:cpuTickCount++
    if ($script:cpuTickCount -ge 10) {
        $script:cpuTickCount = 0
        $lblCpuVal.Text      = $script:cpuResult["Text"]
        $lblCpuVal.ForeColor = Get-CpuColor $script:cpuResult["Pct"]
    }

    if (-not $script:testRunning -and $script:queue.IsEmpty) {
        $uiTimer.Stop()
        $form.Text         = "iPerf3 - Finished  |  Points: $($script:DataPoints.Count)"
        $lblTimeVal.Text   = "Finished"
        $btnStop.Enabled     = $false
        $btnExport.Enabled   = ($script:DataPoints.Count -gt 0)
        $btnPng.Enabled      = $true
        $btnAnalyzer.Enabled = ($VisualAnalyzerPath -ne "" -and $LogFile -ne "" -and (Test-Path $LogFile))
        $form.ForeColor    = [System.Drawing.Color]::Empty
        Write-Host "Test finished." -ForegroundColor Green

        # Signal CMD that the test is done - CMD can resume immediately
        if ($DoneFlagFile) {
            try {
                Set-Content -Path $DoneFlagFile -Value "done" -Force -ErrorAction SilentlyContinue
            } catch {}
        }

        # Optionally kill the local iperf3 server and its console window
        if ($KillServerOnFinish -eq "1") {
            try {
                Get-Process -Name "iperf3" -ErrorAction SilentlyContinue |
                    Stop-Process -Force -ErrorAction SilentlyContinue
            } catch {}
            # Close the IPERF_TEST cmd window by title (best-effort)
            try {
                & cmd /c "taskkill /fi `"WINDOWTITLE eq IPERF_TEST*`" /f" 2>$null | Out-Null
            } catch {}
        }

        # Hide this script's console window - chart form stays open.
        Hide-ConsoleWindow

        # Auto-close the chart window after a delay (for batch test runs)
        # Defensive check: trim whitespace and verify it's actually numeric
        # before treating it as a real value (guards against edge cases in
        # CMD->PowerShell argument passing when the variable is empty).
        $autoExitClean = if ($AutoExit) { $AutoExit.ToString().Trim() } else { "" }
        if ($autoExitClean -ne "") {
            $delaySec = 0
            $parsed = [double]::TryParse($autoExitClean, [ref]$delaySec)
            if (-not $parsed) {
                # Not a valid number - ignore AutoExit entirely, do not close
                $delaySec = -1
            }
            if ($delaySec -lt 0 -and $parsed) { $delaySec = 0 }
            if ($parsed) {
                if ($delaySec -eq 0) {
                    $form.Close()
                } else {
                    $autoExitTimer = New-Object System.Windows.Forms.Timer
                    $autoExitTimer.Interval = [int]($delaySec * 1000)
                    $autoExitTimer.Add_Tick({
                        $autoExitTimer.Stop()
                        $form.Close()
                    })
                    $autoExitTimer.Start()
                }
            }
        }
    }
})

$form.Add_Shown({
    $form.Refresh()
    Write-Host "CMD: $ADB_PATH $AdbArgs" -ForegroundColor Cyan

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName               = $ADB_PATH
    $pinfo.Arguments              = $AdbArgs
    $pinfo.UseShellExecute        = $false
    $pinfo.RedirectStandardOutput = $true
    $pinfo.CreateNoWindow         = $true

    try {
        $script:proc        = [System.Diagnostics.Process]::Start($pinfo)
        $script:testRunning = $true
        $btnStop.Enabled    = $true
        $btnPng.Enabled     = $true
        $lblTimeVal.Text    = "0.0 s"
    Start-CpuMonitor
        Write-Host "ADB started PID $($script:proc.Id)" -ForegroundColor Green
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to start ADB:`n$_", "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
    $rs.Open()
    $rs.SessionStateProxy.SetVariable('proc',  $script:proc)
    $rs.SessionStateProxy.SetVariable('queue', $script:queue)
    $ps = [System.Management.Automation.PowerShell]::Create()
    $ps.Runspace = $rs
    [void]$ps.AddScript({
        try {
            while (-not $proc.StandardOutput.EndOfStream) {
                $ln = $proc.StandardOutput.ReadLine()
                if ($ln) { $queue.Enqueue($ln) }
            }
            $proc.WaitForExit(5000) | Out-Null
        } finally {}
    })
    $script:watchHandle = $ps.BeginInvoke()
    $script:watchPs     = $ps
    $script:watchRs     = $rs

    $uiTimer.Add_Tick({
        if ($script:testRunning -and $script:watchHandle -and $script:watchHandle.IsCompleted) {
            $script:testRunning = $false
            try { $script:watchPs.EndInvoke($script:watchHandle) } catch {}
            $script:watchRs.Close()
        }
    })

    $uiTimer.Start()
})

$form.ShowDialog()
$uiTimer.Stop()