param(
    [string]$WorkDir = ""
)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Resolve working directory: use -WorkDir param if provided, else PSScriptRoot
$WorkDir = if ($WorkDir -ne "" -and (Test-Path $WorkDir)) { $WorkDir.TrimEnd("\") } else { $PSScriptRoot }
$IniFile  = Join-Path $WorkDir "iperf_profiles.ini"


# Win32 API for textbox placeholder text
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern IntPtr SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, string lParam);
    public const int EM_SETCUEBANNER = 0x1501;
}
"@ -Language CSharp

function Set-Placeholder {
    param([System.Windows.Forms.TextBox]$tb, [string]$hint)
    [WinAPI]::SendMessage($tb.Handle, [WinAPI]::EM_SETCUEBANNER, [IntPtr]::Zero, $hint) | Out-Null
}

# All known parameter keys - always written to INI
$AllKeys = @("host","port","protocol","direction","bitrate","duration","interval","buflen","streams","socketsize","tcpnodelay","extra")

$C = @{
    Bg        = [System.Drawing.Color]::FromArgb(22,  22,  32)
    Panel     = [System.Drawing.Color]::FromArgb(30,  30,  44)
    Card      = [System.Drawing.Color]::FromArgb(38,  38,  54)
    Border    = [System.Drawing.Color]::FromArgb(60,  60,  85)
    Text      = [System.Drawing.Color]::FromArgb(210, 210, 225)
    TextDim   = [System.Drawing.Color]::FromArgb(110, 110, 140)
    TextDark  = [System.Drawing.Color]::FromArgb(20,  20,  30)
    Input     = [System.Drawing.Color]::FromArgb(18,  18,  28)
    Accent    = [System.Drawing.Color]::FromArgb(100, 149, 237)   # CornflowerBlue
    AccentHov = [System.Drawing.Color]::FromArgb(140, 185, 255)   # lighter blue for hover
    BtnRun    = [System.Drawing.Color]::FromArgb(120, 200, 120)   # lawn green muted
    BtnRunHov = [System.Drawing.Color]::FromArgb(150, 225, 150)
    BtnNew    = [System.Drawing.Color]::FromArgb(119, 158, 203)   # SteelBlue-ish
    BtnNewHov = [System.Drawing.Color]::FromArgb(145, 185, 225)
    BtnDel    = [System.Drawing.Color]::FromArgb(188, 143, 143)   # RosyBrown / LightPink-dark
    BtnDelHov = [System.Drawing.Color]::FromArgb(210, 170, 170)
    BtnSave   = [System.Drawing.Color]::FromArgb(148, 167, 215)   # Lavender-blue
    BtnSaveHov= [System.Drawing.Color]::FromArgb(175, 192, 235)
    BtnAll    = [System.Drawing.Color]::FromArgb(130, 180, 160)   # Muted green
    BtnAllHov = [System.Drawing.Color]::FromArgb(158, 205, 185)
    BtnRel    = [System.Drawing.Color]::FromArgb(85,  110, 165)   # Medium slate blue
    BtnRelHov = [System.Drawing.Color]::FromArgb(110, 138, 195)
    Preview   = [System.Drawing.Color]::FromArgb(130, 175, 220)
}

$F = @{
    Main   = New-Object System.Drawing.Font("Consolas", 9)
    Label  = New-Object System.Drawing.Font("Consolas", 8.5)
    Title  = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
    Small  = New-Object System.Drawing.Font("Consolas", 8)
    Button = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
}

# INI Helpers
function Read-IniFile {
    param([string]$Path)
    $result = [System.Collections.Specialized.OrderedDictionary]::new()
    if (-not (Test-Path $Path)) { return $result }
    $curName   = $null
    $curData   = $null
    $curActive = $false
    foreach ($line in (Get-Content $Path -Encoding UTF8)) {
        if ($line -match '^===(.+)$') {
            # Active profile header: ===ProfileName
            if ($curName) { $result[$curName] = @{ Active=$curActive; Data=$curData } }
            $curName   = $Matches[1].Trim()
            $curData   = @{}
            $curActive = $true
        } elseif ($line -match '^;===(.+)$') {
            # Inactive profile header: ;===ProfileName
            if ($curName) { $result[$curName] = @{ Active=$curActive; Data=$curData } }
            $curName   = $Matches[1].Trim()
            $curData   = @{}
            $curActive = $false
        } elseif ($curName -and $line -match '^([^=;][^=]*)=(.*)$') {
            # Active key=value
            $curData[$Matches[1].Trim()] = $Matches[2].Trim()
        } elseif ($curName -and -not $curActive -and $line -match '^;([^=;][^=]*)=(.*)$') {
            # Inactive key=value (prefixed with ;)
            $curData[$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }
    if ($curName) { $result[$curName] = @{ Active=$curActive; Data=$curData } }
    return $result
}

function Write-IniFile {
    param([string]$Path, [System.Collections.Specialized.OrderedDictionary]$Profiles)
    $lines = @()
    $first = $true
    foreach ($name in $Profiles.Keys) {
        if (-not $first) { $lines += "" }
        $first = $false
        $p = $Profiles[$name]
        if ($p.Active) {
            $lines += "===$name"
            foreach ($key in $AllKeys) {
                $val = if ($p.Data.Contains($key)) { $p.Data[$key] } else { "" }
                $lines += "$key=$val"
            }
        } else {
            $lines += ";===$name"
            foreach ($key in $AllKeys) {
                $val = if ($p.Data.Contains($key)) { $p.Data[$key] } else { "" }
                $lines += ";$key=$val"
            }
        }
    }
    # Save as UTF-8 without BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllLines($Path, $lines, $utf8NoBom)
}

# UI Helpers
function New-FlatButton {
    param([string]$Text, [int]$X, [int]$Y, [int]$W=120, [int]$H=28,
          [System.Drawing.Color]$Bg=$C.BtnSave,
          [System.Drawing.Color]$Fg=$C.TextDark,
          [System.Drawing.Color]$Hov=$C.BtnSaveHov,
          [System.Drawing.Font]$Font=$null)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text      = $Text
    $btn.Location  = New-Object System.Drawing.Point($X, $Y)
    $btn.Size      = New-Object System.Drawing.Size($W, $H)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize         = 0
    $btn.FlatAppearance.MouseOverBackColor = $Hov
    $btn.BackColor = $Bg
    $btn.ForeColor = $Fg
    $btn.Font      = if ($Font) { $Font } else { $F.Button }
    $btn.Cursor    = [System.Windows.Forms.Cursors]::Hand
    return $btn
}

function New-Label {
    param([string]$Text, [int]$X, [int]$Y, [int]$W=140, [int]$H=20,
          [System.Drawing.Color]$Color=$C.TextDim)
    $lbl           = New-Object System.Windows.Forms.Label
    $lbl.Text      = $Text
    $lbl.Location  = New-Object System.Drawing.Point($X, $Y)
    $lbl.Size      = New-Object System.Drawing.Size($W, $H)
    $lbl.ForeColor = $Color
    $lbl.Font      = $F.Label
    $lbl.BackColor = [System.Drawing.Color]::Transparent
    return $lbl
}

function New-TextBox {
    param([int]$X, [int]$Y, [int]$W=80, [string]$Default="", [bool]$Enabled=$true, [string]$Placeholder="")
    $tb             = New-Object System.Windows.Forms.TextBox
    $tb.Location    = New-Object System.Drawing.Point($X, $Y)
    $tb.Size        = New-Object System.Drawing.Size($W, 22)
    $tb.BackColor   = $C.Input
    $tb.ForeColor   = $C.Text
    $tb.Font        = $F.Main
    $tb.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $tb.Text        = $Default
    $tb.Enabled     = $Enabled
    return $tb
}

function New-CheckBox {
    param([string]$Text, [int]$X, [int]$Y, [bool]$Checked=$false, [int]$W=80)
    $cb             = New-Object System.Windows.Forms.CheckBox
    $cb.Text        = $Text
    $cb.Location    = New-Object System.Drawing.Point($X, $Y)
    $cb.Size        = New-Object System.Drawing.Size($W, 22)
    $cb.Checked     = $Checked
    $cb.Font        = $F.Small
    $cb.Appearance  = [System.Windows.Forms.Appearance]::Button
    $cb.FlatStyle   = [System.Windows.Forms.FlatStyle]::Flat
    $cb.FlatAppearance.BorderSize         = 1
    $cb.FlatAppearance.BorderColor        = $C.Border
    $cb.FlatAppearance.CheckedBackColor   = $C.Accent
    $cb.FlatAppearance.MouseOverBackColor = $C.Border
    $cb.BackColor   = $C.Card
    $cb.ForeColor   = $C.TextDim
    $cb.TextAlign   = [System.Drawing.ContentAlignment]::MiddleCenter
    $cb.Cursor      = [System.Windows.Forms.Cursors]::Hand
    $cb.Add_CheckedChanged({
        if ($this.Checked) {
            $this.ForeColor = $C.TextDark
            $this.FlatAppearance.MouseOverBackColor = $C.AccentHov
        } else {
            $this.ForeColor = $C.TextDim
            $this.FlatAppearance.MouseOverBackColor = $C.Border
        }
    })
    return $cb
}

function New-ComboBox {
    param([int]$X, [int]$Y, [int]$W=140, [string[]]$Items, [string]$Selected="")
    $cb               = New-Object System.Windows.Forms.ComboBox
    $cb.Location      = New-Object System.Drawing.Point($X, $Y)
    $cb.Size          = New-Object System.Drawing.Size($W, 22)
    $cb.BackColor     = $C.Input
    $cb.ForeColor     = $C.Text
    $cb.Font          = $F.Main
    $cb.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $cb.FlatStyle     = [System.Windows.Forms.FlatStyle]::Flat
    $cb.DrawMode      = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
    $cb.ItemHeight    = 16

    $cb.Add_DrawItem({
        param($s, $e)
        if ($e.Index -lt 0) { return }
        # Background
        $bgColor = if ($e.State -band [System.Windows.Forms.DrawItemState]::Selected) { $C.ListSel } else { $C.Input }
        $e.Graphics.FillRectangle((New-Object System.Drawing.SolidBrush($bgColor)), $e.Bounds)
        # Text
        $txt = $s.Items[$e.Index].ToString()
        $e.Graphics.DrawString($txt, $e.Font, (New-Object System.Drawing.SolidBrush($C.Text)),
            ($e.Bounds.X + 4), ($e.Bounds.Y + 2))
        # Draw dropdown arrow area background (covers white native button)
        $arrowRect = New-Object System.Drawing.Rectangle(($e.Bounds.Right - 18), $e.Bounds.Y, 18, $e.Bounds.Height)
    })

    # Paint event to redraw the button area of collapsed combobox
    $cb.Add_Paint({
        param($s, $e)
        # Cover the native white dropdown arrow with our own
        $w  = $s.Width
        $h  = $s.Height
        $aw = 18
        $arrowRect = New-Object System.Drawing.Rectangle(($w - $aw - 1), 1, ($aw), ($h - 2))
        $e.Graphics.FillRectangle((New-Object System.Drawing.SolidBrush($C.Card)), $arrowRect)
        # Draw a simple down-arrow in accent color
        $ax = $w - $aw/2 - 1
        $ay = $h/2
        $pts = @(
            (New-Object System.Drawing.Point(($ax - 4), ($ay - 2))),
            (New-Object System.Drawing.Point(($ax + 4), ($ay - 2))),
            (New-Object System.Drawing.Point(($ax),     ($ay + 3)))
        )
        $e.Graphics.FillPolygon((New-Object System.Drawing.SolidBrush($C.TextDim)), $pts)
        # Border around whole control
        $e.Graphics.DrawRectangle(
            (New-Object System.Drawing.Pen($C.Border)),
            0, 0, ($w - 1), ($h - 1))
    })

    foreach ($i in $Items) { [void]$cb.Items.Add($i) }
    if ($Selected -and $cb.Items.Contains($Selected)) { $cb.SelectedItem = $Selected }
    elseif ($cb.Items.Count -gt 0) { $cb.SelectedIndex = 0 }
    return $cb
}

# ListSel color for combobox dropdown highlight
$C["ListSel"] = [System.Drawing.Color]::FromArgb(42, 62, 90)

function New-Sep {
    param([int]$X, [int]$Y, [int]$W)
    $p           = New-Object System.Windows.Forms.Panel
    $p.Location  = New-Object System.Drawing.Point($X, $Y)
    $p.Size      = New-Object System.Drawing.Size($W, 1)
    $p.BackColor = $C.Border
    return $p
}

# Main Form
$form                 = New-Object System.Windows.Forms.Form
$form.Text            = "iperf3 Profile Configurator"
$form.ClientSize      = New-Object System.Drawing.Size(800, 666)
$form.MinimumSize     = New-Object System.Drawing.Size(800, 666)
$form.BackColor       = $C.Bg
$form.ForeColor       = $C.Text
$form.Font            = $F.Main
$form.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox     = $false

# Title
$titleLbl           = New-Object System.Windows.Forms.Label
$titleLbl.Text      = "  iperf3 Profile Configurator"
$titleLbl.Location  = New-Object System.Drawing.Point(0, 0)
$titleLbl.Size      = New-Object System.Drawing.Size(800, 34)
$titleLbl.ForeColor = $C.Accent
$titleLbl.Font      = $F.Title
$titleLbl.BackColor = $C.Panel
$titleLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$form.Controls.Add($titleLbl)

# Left panel
$leftPanel           = New-Object System.Windows.Forms.Panel
$leftPanel.Location  = New-Object System.Drawing.Point(0, 34)
$leftPanel.Size      = New-Object System.Drawing.Size(218, 608)
$leftPanel.BackColor = $C.Panel
$form.Controls.Add($leftPanel)

$leftPanel.Controls.Add((New-Label "PROFILES" 12 8 140 18 $C.TextDim))

$profileList              = New-Object System.Windows.Forms.CheckedListBox
$profileList.Location     = New-Object System.Drawing.Point(10, 28)
$profileList.Size         = New-Object System.Drawing.Size(198, 506)
$profileList.BackColor    = $C.Card
$profileList.ForeColor    = $C.Text
$profileList.Font         = $F.Main
$profileList.BorderStyle  = [System.Windows.Forms.BorderStyle]::None
$profileList.CheckOnClick = $false
$leftPanel.Controls.Add($profileList)

# Separator above buttons
$leftPanel.Controls.Add((New-Sep 10 538 198))

# Buttons same height as right panel buttons, aligned at y=530
$btnAdd    = New-FlatButton "New"      10  542  95 28 $C.BtnNew  $C.TextDark $C.BtnNewHov
$btnDelete = New-FlatButton "Delete"   113 542  95 28 $C.BtnDel  $C.TextDark $C.BtnDelHov
$leftPanel.Controls.Add($btnAdd)
$leftPanel.Controls.Add($btnDelete)

# Right panel
$rightPanel           = New-Object System.Windows.Forms.Panel
$rightPanel.Location  = New-Object System.Drawing.Point(218, 34)
$rightPanel.Size      = New-Object System.Drawing.Size(572, 608)
$rightPanel.BackColor = $C.Bg
$form.Controls.Add($rightPanel)

# Profile name row
$rightPanel.Controls.Add((New-Label "Profile name:" 16 12 110 20 $C.TextDim))
$txtName = New-TextBox 132 10 260
$txtName.Add_TextChanged({
    if (-not $script:suppressEvents) { $script:dirty = $true }
})
$rightPanel.Controls.Add($txtName)

# Templates dropdown
$rightPanel.Controls.Add((New-Label "Template:" 16 42 110 20 $C.TextDim))
$cmbTemplate = New-ComboBox 132 40 260 @("-- Custom --","Virtual Desktop","Air Link","Steam Link","ALVR","Standard 0","Standard 600")
$rightPanel.Controls.Add($cmbTemplate)

# Template definitions
$templates = @{
    "Virtual Desktop" = @{
        name="TEST_UDP_VD"; protocol="UDP"; buflen="1450"; bitrate="300"
        socketsize="2"; duration="180"; interval="0.1"; streams="1"
        direction="Direct"; tcpnodelay=$false
    }
    "Air Link" = @{
        name="TEST_UDP_AirLink"; protocol="UDP"; buflen="1440"; bitrate="200"
        socketsize="4"; duration="180"; interval="0.1"; streams="1"
        direction="Direct"; tcpnodelay=$false
    }
    "Steam Link" = @{
        name="TEST_UDP_SteamLink"; protocol="UDP"; buflen="1400"; bitrate="300"
        socketsize="1"; duration="180"; interval="0.1"; streams="1"
        direction="Direct"; tcpnodelay=$false
    }
    "ALVR" = @{
        name="TEST_UDP_ALVR"; protocol="UDP"; buflen="1440"; bitrate="400"
        socketsize="1"; duration="180"; interval="0.1"; streams="1"
        direction="Direct"; tcpnodelay=$false
    }
    "Standard 0" = @{
        name="TEST_UDP_STD_0"; protocol="UDP"; buflen="1460"; bitrate="0"
        socketsize="1"; duration="180"; interval="0.1"; streams="1"
        direction="Direct"; tcpnodelay=$false
    }
    "Standard 600" = @{
        name="TEST_UDP_STD_600"; protocol="UDP"; buflen="1460"; bitrate="600"
        socketsize="1"; duration="180"; interval="0.1"; streams="1"
        direction="Direct"; tcpnodelay=$false
    }
}

$cmbTemplate.Add_SelectedIndexChanged({
    if ($script:suppressEvents) { return }
    $sel = $cmbTemplate.SelectedItem.ToString()
    if ($sel -eq "-- Custom --") { return }
    if (-not $templates.ContainsKey($sel)) { return }
    $t = $templates[$sel]
    $script:suppressEvents = $true

    # Apply name
    $txtName.Text = $t.name

    # Apply protocol
    $rowProto.cb.SelectedItem = $t.protocol
    # Apply direction
    $rowDir.cb.SelectedItem = $t.direction

    # Apply numeric fields (enable manual + set value)
    foreach ($pair in @(
        @($rowBufLen,   $t.buflen),
        @($rowBitrate,  $t.bitrate),
        @($rowWindow,   $t.socketsize),
        @($rowDuration, $t.duration),
        @($rowInterval, $t.interval),
        @($rowStreams,   $t.streams)
    )) {
        $row = $pair[0]; $val = $pair[1]
        $row.tb.ForeColor = $C.Text
        $row.tb.Text      = $val
        $row.chk.Checked  = $true
        $row.tb.Enabled   = $true
    }

    # Update buflen hint based on template protocol
    $hint = if ($t.protocol -eq "UDP") { "1460" } else { "131072" }
    if (-not $rowBufLen.chk.Checked) {
        $rowBufLen.tb.ForeColor = $C.TextDim
        $rowBufLen.tb.Text      = $hint
        $rowBufLen.tb.Tag       = $hint
    }

    # TCP_NODELAY
    $chkNodelay.Checked = $t.tcpnodelay
    if ($t.protocol -eq "UDP") {
        $chkNodelay.Checked = $false
        $chkNodelay.Enabled = $false
    } else {
        $chkNodelay.Enabled = $true
    }

    # Restore detected IP to host field (templates don't set host)
    Apply-HostIP
    $script:suppressEvents = $false
    $script:dirty = $true
    Update-Preview
})

$rightPanel.Controls.Add((New-Sep 10 68 542))

# Build parameter rows
$y    = 80
$rowH = 30
$LX   = 16    # label x
$LW   = 130   # label width
$TX   = 150   # textbox / combo x
$TW   = 85    # textbox width
$CX   = 244   # checkbox x

function Add-NumRow {
    param([string]$Lbl, [string]$Key, [string]$Hint, [ref]$YRef)
    $yv = $YRef.Value
    $rightPanel.Controls.Add((New-Label $Lbl $LX ($yv+4) $LW 18))
    $tb             = New-TextBox $TX $yv $TW "" $false
    $tb.Tag         = $Hint   # Tag stores hint for placeholder simulation
    $tb.ForeColor   = $C.TextDim
    $tb.Text        = $Hint
    $rightPanel.Controls.Add($tb)
    $chk        = New-CheckBox "manual" $CX $yv $false 80
    $chk.Tag    = $tb
    $chk.Add_CheckedChanged({
        $field = $this.Tag
        if ($this.Checked) {
            # Enabling: clear hint if showing
            if ($field.ForeColor -eq $C.TextDim) {
                $field.Text      = ""
                $field.ForeColor = $C.Text
            }
            $field.Enabled = $true
            $field.Focus()
            $field.SelectAll()
        } else {
            $field.Enabled = $false
            # Show hint if empty
            if ($field.Text.Trim() -eq "") {
                $field.ForeColor = $C.TextDim
                $field.Text      = $field.Tag
            }
        }
    })
    $rightPanel.Controls.Add($chk)
    $YRef.Value += $rowH
    return @{ tb=$tb; chk=$chk; key=$Key; hint=$Hint }
}

function Add-ComboRow {
    param([string]$Lbl, [string]$Key, [string[]]$Items, [ref]$YRef)
    $yv = $YRef.Value
    $rightPanel.Controls.Add((New-Label $Lbl $LX ($yv+4) $LW 18))
    $cb      = New-ComboBox $TX $yv 148 $Items
    $cb.Tag  = $Key
    $rightPanel.Controls.Add($cb)
    $YRef.Value += $rowH
    return @{ cb=$cb; key=$Key }
}

$yRef = [ref]$y

$rowProto    = Add-ComboRow "Protocol:"         "protocol"  @("TCP","UDP")        $yRef
$rowDir      = Add-ComboRow "Direction:"        "direction" @("Direct","Reverse")  $yRef
$rightPanel.Controls.Add((New-Sep 10 $yRef.Value 542))
$yRef.Value += 8

$rowHost     = Add-NumRow   "Host / IP:"        "host"     ""                   $yRef
$rowPort     = Add-NumRow   "Port:"             "port"     "5201"               $yRef
$rowBitrate  = Add-NumRow   "Bitrate (Mbps):"   "bitrate"  "100"                $yRef
$rowDuration = Add-NumRow   "Duration (sec):"   "duration" "10"                 $yRef
$rowInterval = Add-NumRow   "Interval (sec):"   "interval" "1"                  $yRef
$rowBufLen   = Add-NumRow   "Buf len (bytes):"    "buflen"     "131072"           $yRef
$rowStreams   = Add-NumRow   "Streams:"          "streams"  "1"                  $yRef
$rowWindow   = Add-NumRow   "Socket buf (MB):"  "socketsize" "1"                $yRef
# TCP_NODELAY row
$lblNodelay = New-Label "TCP_NODELAY:" $LX ($yRef.Value+4) $LW 18
$rightPanel.Controls.Add($lblNodelay)

$chkNodelay = New-CheckBox "manual" $CX $yRef.Value $false 80
$chkNodelay.Add_CheckedChanged({
    if ($this.Checked -and $rowProto.cb.SelectedItem -ne "TCP") {
        $this.Checked = $false
        return
    }
    if (-not $script:suppressEvents) { $script:dirty = $true }
    Update-Preview
})

# Label showing TCP_NODELAY text (read-only hint)
$lblNDVal = New-Object System.Windows.Forms.TextBox
$lblNDVal.Location    = New-Object System.Drawing.Point($TX, $yRef.Value)
$lblNDVal.Size        = New-Object System.Drawing.Size(80, 22)
$lblNDVal.Text        = "-N"
$lblNDVal.ForeColor   = $C.TextDim
$lblNDVal.BackColor   = $C.Input
$lblNDVal.Font        = $F.Main
$lblNDVal.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$lblNDVal.ReadOnly    = $true
$lblNDVal.TabStop     = $false
$rightPanel.Controls.Add($lblNDVal)
$rightPanel.Controls.Add($chkNodelay)
$yRef.Value += 30

$rightPanel.Controls.Add((New-Sep 10 $yRef.Value 542))
$yRef.Value += 8

# Extra params
$rightPanel.Controls.Add((New-Label "Extra params:" $LX ($yRef.Value+4) $LW 18))
$txtExtra = New-TextBox $TX $yRef.Value 382
$rightPanel.Controls.Add($txtExtra)
$yRef.Value += $rowH + 2

$rightPanel.Controls.Add((New-Sep 10 $yRef.Value 542))
$yRef.Value += 8

# Preview
$rightPanel.Controls.Add((New-Label "Command preview:" $LX $yRef.Value 150 18 $C.TextDim))
$yRef.Value += 20
$txtPreview             = New-Object System.Windows.Forms.TextBox
$txtPreview.Location    = New-Object System.Drawing.Point($LX, $yRef.Value)
$txtPreview.Size        = New-Object System.Drawing.Size(538, 38)
$txtPreview.BackColor   = $C.Card
$txtPreview.ForeColor   = $C.Preview
$txtPreview.Font        = $F.Small
$txtPreview.Multiline   = $true
$txtPreview.ReadOnly    = $true
$txtPreview.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$rightPanel.Controls.Add($txtPreview)
$yRef.Value += 46

$rightPanel.Controls.Add((New-Sep 10 $yRef.Value 542))
$yRef.Value += 8

# Bottom buttons — same row, same height as left panel buttons (y=530 in left = $yRef.Value here)
$btnSave    = New-FlatButton "Save Profile"  $LX         $yRef.Value  90 28 $C.BtnSave $C.TextDark $C.BtnSaveHov
$btnReload  = New-FlatButton "Reload INI"   ($LX+92)    $yRef.Value  90 28 $C.BtnRel  $C.TextDark $C.BtnRelHov
$btnSaveAll = New-FlatButton "Save INI"     ($LX+184)   $yRef.Value  90 28 $C.BtnAll  $C.TextDark $C.BtnAllHov
$rightPanel.Controls.Add($btnSave)
$rightPanel.Controls.Add($btnReload)
$rightPanel.Controls.Add($btnSaveAll)

# Help button (square, right of Save All)
$btnRun     = New-FlatButton "Run"          ($LX+286)   $yRef.Value  85 28 $C.BtnRun  $C.TextDark $C.BtnRunHov
$btnRunLive = New-FlatButton "Run Live"     ($LX+373)   $yRef.Value  85 28 $C.BtnRun  $C.TextDark $C.BtnRunHov
$btnHelp = New-FlatButton "?" (526) $yRef.Value 28 28 $C.BtnRel $C.Text $C.BtnRelHov
$rightPanel.Controls.Add($btnRun)
$rightPanel.Controls.Add($btnRunLive)
$rightPanel.Controls.Add($btnHelp)

# Help dialog with RichTextBox for bold formatting
$FlagFile = Join-Path $WorkDir "runtest.flag"

$btnRun.Add_Click({
    if ($script:dirty) {
        $res = [System.Windows.Forms.MessageBox]::Show(
            "You have unsaved changes not written to INI file." + [char]10 +
            "Save INI file before running tests?",
            "Unsaved Changes",
            [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            $ok = Save-CurrentProfile
            if (-not $ok) { return }
            Write-IniFile $IniFile $script:profiles
            $script:dirty = $false
        } elseif ($res -eq [System.Windows.Forms.DialogResult]::Cancel) {
            return
        }
    }
    Set-Content -Path $FlagFile -Value "1" -Encoding ASCII
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Run flag created: $FlagFile"
    $statusLbl.ForeColor = $C.BtnRun
    $form.Close()
})

$btnRunLive.Add_Click({
    if ($script:dirty) {
        $res = [System.Windows.Forms.MessageBox]::Show(
            "You have unsaved changes not written to INI file." + [char]10 +
            "Save INI file before running live test?",
            "Unsaved Changes",
            [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            $ok = Save-CurrentProfile
            if (-not $ok) { return }
            Write-IniFile $IniFile $script:profiles
            $script:dirty = $false
        } elseif ($res -eq [System.Windows.Forms.DialogResult]::Cancel) {
            return
        }
    }
    $liveFlagFile = Join-Path $WorkDir "runlive.flag"
    Set-Content -Path $liveFlagFile -Value "1" -Encoding ASCII
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Live flag created: $liveFlagFile"
    $statusLbl.ForeColor = $C.BtnRun
    $form.Close()
})

$btnHelp.Add_Click({
    $dlg                 = New-Object System.Windows.Forms.Form
    $dlg.Text            = "iperf3 Configurator - Help"
#    $dlg.Size            = New-Object System.Drawing.Size(880, 1040)
    $dlg.Size            = New-Object System.Drawing.Size(880, 900)
    $dlg.MinimizeBox     = $false
    $dlg.MaximizeBox     = $false
    $dlg.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $dlg.BackColor       = $C.Card
    $dlg.ForeColor       = $C.Text
    $dlg.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

    $rtbL = New-Object System.Windows.Forms.RichTextBox
    $rtbL.Location    = New-Object System.Drawing.Point(12, 12)
    $rtbL.Size        = New-Object System.Drawing.Size(410, 900)
    $rtbL.BackColor   = $C.Card
    $rtbL.ForeColor   = $C.Text
    $rtbL.ReadOnly    = $true
    $rtbL.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $rtbL.ScrollBars  = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $rtbL.Font        = New-Object System.Drawing.Font("Segoe UI", 9)
    $dlg.Controls.Add($rtbL)

    $div           = New-Object System.Windows.Forms.Panel
    $div.Location  = New-Object System.Drawing.Point(420, 12)
#    $div.Size      = New-Object System.Drawing.Size(1, 960)
    $div.Size      = New-Object System.Drawing.Size(1, 900)
    $div.BackColor = $C.Border
    $dlg.Controls.Add($div)

    $rtbR = New-Object System.Windows.Forms.RichTextBox
    $rtbR.Location    = New-Object System.Drawing.Point(427, 12)
    $rtbR.Size        = New-Object System.Drawing.Size(430, 900)
    $rtbR.BackColor   = $C.Card
    $rtbR.ForeColor   = $C.Text
    $rtbR.ReadOnly    = $true
    $rtbR.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $rtbR.ScrollBars  = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $rtbR.Font        = New-Object System.Drawing.Font("Segoe UI", 9)
    $dlg.Controls.Add($rtbR)



    function W {
        param([System.Windows.Forms.RichTextBox]$rtb,
              [string]$Text,
              [bool]$Bold = $false,
              [bool]$NL   = $true)
        $s = $rtb.TextLength
        $rtb.AppendText($Text)
        $rtb.Select($s, $Text.Length)
        $fs = if ($Bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
        $rtb.SelectionFont  = New-Object System.Drawing.Font("Segoe UI", 9, $fs)
        $rtb.SelectionColor = if ($Bold) { $C.Accent } else { $C.Text }
        if ($NL) { $rtb.AppendText("`n") }
    }

    W $rtbL "PROFILES" $true
    W $rtbL "  Checkbox = active/inactive state."
    W $rtbL "  Checked  " $true $false; W $rtbL "===Name in INI, parsed by CMD." $false
    W $rtbL "  Unchecked" $true $false; W $rtbL ";===Name in INI, whole block skipped." $false
    W $rtbL "  Click name to load profile into editor."
    W $rtbL ""
    W $rtbL "CREATING A PROFILE" $true
    W $rtbL "  Option A: click " $false $false; W $rtbL "New" $true $false; W $rtbL ", edit name and params, " $false $false; W $rtbL "Save Profile" $true $false; W $rtbL "." $false
    W $rtbL "  Option B: type name in Profile name field,"
    W $rtbL "  configure params, click " $false $false; W $rtbL "Save Profile" $true $false; W $rtbL " (auto-creates)." $false
    W $rtbL "  Changing the name saves as a NEW profile."
    W $rtbL "  The original profile stays unchanged."
    W $rtbL ""
    W $rtbL "PARAMETERS" $true
    W $rtbL "  " $false $false; W $rtbL "manual" $true $false; W $rtbL " toggle: " $false $false; W $rtbL "Gray" $true $false; W $rtbL "=default  " $false $false; W $rtbL "Blue" $true $false; W $rtbL "=manual." $false
    W $rtbL "  Clicking it moves keyboard focus to the field."
    W $rtbL "  Gray numbers in fields are hints only, not saved."
    W $rtbL "  Protocol and Direction: no manual toggle needed."
    W $rtbL ""
    W $rtbL "  Protocol  " $true $false; W $rtbL "TCP or UDP. INI: empty or -u." $false
    W $rtbL "  Direction " $true $false; W $rtbL "Direct/Reverse. INI: empty or -R." $false
    W $rtbL "  Host/IP   " $true $false; W $rtbL "(-c) Auto-detected at startup. Enabled" $false
    W $rtbL "             by default, shown in preview. " $false $false; W $rtbL "manual" $true $false; W $rtbL " to change." $false
    W $rtbL "  Port      " $true $false; W $rtbL "(-p) Default: 5201." $false
    W $rtbL "  Bitrate   " $true $false; W $rtbL "(-b) Mbps. TCP: unlimited, UDP def: 1M." $false
    W $rtbL "  Duration  " $true $false; W $rtbL "(-t) Seconds. Default: 10." $false
    W $rtbL "  Interval  " $true $false; W $rtbL "(-i) Report interval sec. Default: 1." $false
    W $rtbL "  Buf len   " $true $false; W $rtbL "(-l) Bytes. TCP hint: 131072, UDP: 1460." $false
    W $rtbL "  Streams   " $true $false; W $rtbL "(-P) Parallel streams. Default: 1." $false
    W $rtbL "  Socket buf" $true $false; W $rtbL "(-w) MB. Socket buffer size. Default: 1." $false
    W $rtbL "  TCP_NODELAY" $true $false; W $rtbL "(-N) Disables Nagle. TCP only." $false
    W $rtbL "             Blue = -N in command and INI." $false
    W $rtbL "             Auto-disabled when UDP selected." $false
    W $rtbL "  Extra     " $true $false; W $rtbL "Appended verbatim to the command line." $false
    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
    W $rtbL "BUTTONS" $true
    W $rtbL "  New           " $true $false; W $rtbL "New empty profile (timestamped name)." $false
    W $rtbL "  Delete        " $true $false; W $rtbL "Delete selected profile (with confirm)." $false
    W $rtbL "  Save Profile  " $true $false; W $rtbL "Save to memory only (not to disk)." $false
    W $rtbL "  Reload INI    " $true $false; W $rtbL "Reload from disk. Unsaved changes lost." $false
    W $rtbL "  Save INI      " $true $false; W $rtbL "Write all profiles to disk (UTF-8, no BOM)." $false
    W $rtbL "  Run           " $true $false; W $rtbL "Save INI, create runtest.flag, close." $false
    W $rtbL "  Run Live      " $true $false; W $rtbL "Save INI, create runlive.flag, close." $false
    W $rtbL "  On close with unsaved changes: Yes/No/Cancel prompt."
    W $rtbL "  Status bar shows timestamp [HH:mm:ss] for each op."
    W $rtbL ""
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
#    W $rtbL "" $false
    W $rtbL "" $false
    W $rtbL "" $false
    W $rtbL "" $false
    W $rtbL "(c) 2026 Varset & Gemini Dev  |  v1.53 by Claude" $false
    W $rtbL "" $false
    W $rtbL "Extended Rus/Eng Manual:" $false
    $s = $rtbL.TextLength
    $rtbL.AppendText("https://github.com/Varsett/iPerfConfigurator`n")
    $rtbL.Select($s, 46)
    $rtbL.SelectionColor = $C.Accent
    $rtbL.SelectionFont  = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Underline)
    $rtbL.Add_LinkClicked({
        Start-Process "https://github.com/Varsett/iPerfConfigurator"
    })

#    W $rtbR "BUTTONS" $true
#    W $rtbR "  New           " $true $false; W $rtbR "New empty profile (timestamped name)." $false
#    W $rtbR "  Delete        " $true $false; W $rtbR "Delete selected profile (with confirm)." $false
#    W $rtbR "  Save Profile  " $true $false; W $rtbR "Save to memory only (not to disk)." $false
#    W $rtbR "  Reload INI    " $true $false; W $rtbR "Reload from disk. Unsaved changes lost." $false
#    W $rtbR "  Save INI      " $true $false; W $rtbR "Write all profiles to disk (UTF-8, no BOM)." $false
#    W $rtbR "  Run           " $true $false; W $rtbR "Save INI, create runtest.flag, close." $false
#    W $rtbR "  Run Live      " $true $false; W $rtbR "Save INI, create runlive.flag, close." $false
#    W $rtbR "  On close with unsaved changes: Yes/No/Cancel prompt."
#    W $rtbR "  Status bar shows timestamp [HH:mm:ss] for each op."
#    W $rtbR ""
    W $rtbR "TEMPLATES" $true
    W $rtbR "  Dropdown below profile name. Presets:" $false
    W $rtbR "  Custom       " $true $false; W $rtbR "no preset, manual mode." $false
    W $rtbR "  Virtual Desktop" $true $false; W $rtbR " UDP 300M buf 1450 sock 2MB 180s" $false
    W $rtbR "  Air Link       " $true $false; W $rtbR " UDP 200M buf 1440 sock 4MB 180s" $false
    W $rtbR "  Steam Link     " $true $false; W $rtbR " UDP 300M buf 1400 sock 1MB 180s" $false
    W $rtbR "  ALVR           " $true $false; W $rtbR " UDP 400M buf 1440 sock 1MB 180s" $false
    W $rtbR "  Standard 0     " $true $false; W $rtbR " UDP 0M buf 1460 sock 1MB 180s" $false
    W $rtbR "  Standard 600   " $true $false; W $rtbR " UDP 600M buf 1460 sock 1MB 180s" $false
    W $rtbR "  Fields stay editable after template is applied."
    W $rtbR ""
    W $rtbR "INI FILE FORMAT" $true
    W $rtbR "  ===ProfileName  " $true $false; W $rtbR "Active profile." $false
    W $rtbR "  ;===ProfileName " $true $false; W $rtbR "Inactive (whole block prefixed with ;)." $false
    W $rtbR "  key=value       " $true $false; W $rtbR "Parameter. Empty value = iperf3 default." $false
    W $rtbR "  protocol=       " $true $false; W $rtbR "empty=TCP, -u=UDP." $false
    W $rtbR "  direction=      " $true $false; W $rtbR "empty=Direct, -R=Reverse." $false
    W $rtbR "  tcpnodelay=     " $true $false; W $rtbR "-N=enabled, empty=disabled." $false
    W $rtbR "  INI keys: host port protocol direction" $false
    W $rtbR "  bitrate duration interval buflen" $false
    W $rtbR "  streams socketsize tcpnodelay extra" $false
    W $rtbR ""
    W $rtbR "CMD INTEGRATION" $true
    W $rtbR "  Paste iperf_parse.cmd into your main script."
    W $rtbR "  Run      -> runtest.flag -> :_RunTest per profile"
    W $rtbR "  Run Live -> runlive.flag -> :_RunLive per profile"
    W $rtbR "  Close    -> no flags -> CMD continues normally"
    W $rtbR ""
    W $rtbR "  Variables in :_RunTest / :_RunLive:"
    W $rtbR "  %host% %port% %protocol% %direction%"
    W $rtbR "  %bitrate% %duration% %interval%"
    W $rtbR "  %buflen% %streams% %socketsize%"
    W $rtbR "  %tcpnodelay% %extra%"
    W $rtbR ""
    W $rtbR "  INI parsing uses temp files to avoid nested"
    W $rtbR "  setlocal issues. Each profile is flushed to"
    W $rtbR "  %TEMP%\ipc_*.tmp and deleted after use."
    W $rtbR ""
    W $rtbR "  Launch from CMD (pass working dir explicitly):"
    W $rtbR "  powershell -ExecutionPolicy Bypass" $true $false; W $rtbR "" $false
    W $rtbR "    -File conf.ps1 -WorkDir ""%~dp0""" $true $false; W $rtbR "" $false
    W $rtbR "  -WorkDir sets where INI and flag files are created." $false
    W $rtbR "  If omitted, files go next to the .ps1 script." $false
    W $rtbR "  Use %~dp0 so files stay with your CMD/EXE," $false
    W $rtbR "  not in %TEMP% when launched from a packed exe."
    W $rtbR ""
    W $rtbR "  Without -WorkDir:"
    W $rtbR "  powershell -ExecutionPolicy Bypass -File conf.ps1 -WorkDir ""%~dp0"""

    $rtbL.SelectionStart = 0
    $rtbR.SelectionStart = 0
    [void]$dlg.ShowDialog()
})


# Status bar
$statusLbl           = New-Object System.Windows.Forms.Label
$statusLbl.Location  = New-Object System.Drawing.Point(0, 642)
$statusLbl.Size      = New-Object System.Drawing.Size(800, 24)
$statusLbl.BackColor = $C.Panel
$statusLbl.ForeColor = $C.TextDim
$statusLbl.Font      = New-Object System.Drawing.Font("Segoe UI", 8.5)
$statusLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLbl.Text      = "  Ready  |  " + $IniFile
$form.Controls.Add($statusLbl)


function Apply-HostIP {
    param([bool]$Activate = $false)
    $ip = $script:detectedIP
    if ($ip -and $ip -ne "") {
        $rowHost.tb.Tag       = $ip
        $rowHost.tb.Text      = $ip
        $rowHost.tb.ForeColor = $C.Text
        if ($Activate) {
            $rowHost.tb.Enabled = $true
        } else {
            $rowHost.tb.Enabled = $false
        }
    } else {
        if (-not $Activate) {
            $rowHost.tb.ForeColor = $C.TextDim
            $rowHost.tb.Text      = ""
            $rowHost.tb.Tag       = ""
        }
    }
}

# Timestamp helper
function Get-TS { return (Get-Date).ToString("HH:mm:ss") }

function Get-LocalIP {
    # Find the IP of the adapter that has a default gateway
    # Excludes APIPA (169.254.x.x) - assigned when DHCP is unavailable
    try {
        $routes = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction Stop |
                  Sort-Object RouteMetric
        foreach ($gw in $routes) {
            $ip = Get-NetIPAddress -InterfaceIndex $gw.InterfaceIndex `
                      -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                  Where-Object { $_.IPAddress -notlike "169.254.*" } |
                  Select-Object -First 1
            if ($ip) { return $ip.IPAddress }
        }
    } catch {}
    # Fallback: first non-loopback, non-APIPA IPv4
    try {
        $ip = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
              Where-Object { $_.AddressFamily -eq "InterNetwork" -and
                             $_.ToString() -notlike "127.*" -and
                             $_.ToString() -notlike "169.254.*" } |
              Select-Object -First 1
        if ($ip) { return $ip.ToString() }
    } catch {}
    return ""
}

# State
$script:profiles       = Read-IniFile $IniFile
$script:currentProfile = $null
$script:suppressEvents = $false
$script:dirty          = $false   # tracks unsaved changes

# Helpers
function Refresh-ProfileList {
    param([string]$SelectName = "")
    $script:suppressEvents = $true
    $profileList.Items.Clear()
    foreach ($name in $script:profiles.Keys) {
        $idx = $profileList.Items.Add($name)
        $profileList.SetItemChecked($idx, [bool]$script:profiles[$name].Active)
    }
    $target = if ($SelectName) { $SelectName } else { $script:currentProfile }
    if ($target) {
        for ($i = 0; $i -lt $profileList.Items.Count; $i++) {
            if ($profileList.Items[$i].ToString() -eq $target) {
                $profileList.SelectedIndex = $i; break
            }
        }
    }
    $script:suppressEvents = $false
}

function Update-Preview {
    $parts = @("iperf3")
    $h = $rowHost.tb.Text.Trim()
    # Include host in preview if it has a value and is not showing a hint (dimmed)
    if ($h -and $rowHost.tb.ForeColor -ne $C.TextDim) { $parts += ("-c " + $h) }
    $pt = $rowPort.tb.Text.Trim()
    if ($rowPort.chk.Checked -and $pt) { $parts += ("-p " + $pt) }
    if ($rowProto.cb.SelectedItem -eq "UDP")    { $parts += "-u" }
    if ($rowDir.cb.SelectedItem  -eq "Reverse") { $parts += "-R" }
    if ($rowBitrate.chk.Checked  -and $rowBitrate.tb.Text.Trim())  { $parts += ("-b " + $rowBitrate.tb.Text.Trim()  + "M") }
    if ($rowDuration.chk.Checked -and $rowDuration.tb.Text.Trim()) { $parts += ("-t " + $rowDuration.tb.Text.Trim()) }
    if ($rowInterval.chk.Checked -and $rowInterval.tb.Text.Trim()) { $parts += ("-i " + $rowInterval.tb.Text.Trim()) }
    if ($rowBufLen.chk.Checked   -and $rowBufLen.tb.Text.Trim())   { $parts += ("-l " + $rowBufLen.tb.Text.Trim()) }
    if ($rowStreams.chk.Checked   -and $rowStreams.tb.Text.Trim())  { $parts += ("-P " + $rowStreams.tb.Text.Trim()) }
    if ($rowWindow.chk.Checked   -and $rowWindow.tb.Text.Trim())   { $parts += ("-w " + $rowWindow.tb.Text.Trim()   + "M") }
    if ($chkNodelay.Checked -and $rowProto.cb.SelectedItem -eq "TCP") { $parts += "-N" }
    $ex = $txtExtra.Text.Trim()
    if ($ex) { $parts += $ex }
    $txtPreview.Text = ($parts -join " ")
}

function Load-Profile {
    param([string]$Name)
    $script:currentProfile = $Name
    $p = $script:profiles[$Name].Data
    $script:suppressEvents = $true
    $txtName.Text = $Name

    # Numeric rows with manual checkbox
    foreach ($row in @($rowHost,$rowPort,$rowBitrate,$rowDuration,$rowInterval,$rowBufLen,$rowStreams,$rowWindow)) {
        $key  = $row.key
        $val  = if ($p.Contains($key)) { $p[$key] } else { "" }
        $hint = $row.hint
        if ($val -ne "") {
            $row.tb.ForeColor = $C.Text
            $row.tb.Text      = $val
            if ($row.key -eq "host") {
                # Host: show value read-only, manual button stays gray
                $row.chk.Checked = $false
                $row.tb.Enabled  = $false
            } else {
                $row.chk.Checked = $true
                $row.tb.Enabled  = $true
            }
        } else {
            $row.chk.Checked  = $false
            $row.tb.Enabled   = $false
            $row.tb.ForeColor = $C.TextDim
            $row.tb.Text      = $hint
        }
    }

    $proto = if ($p.Contains("protocol") -and $p["protocol"] -eq "-u") { "UDP" } else { "TCP" }
    $dir   = if ($p.Contains("direction") -and $p["direction"] -eq "-R") { "Reverse" } else { "Direct" }
    $rowProto.cb.SelectedItem = $proto
    $rowDir.cb.SelectedItem   = $dir
    # Load tcpnodelay
    $chkNodelay.Checked = ($p.Contains("tcpnodelay") -and $p["tcpnodelay"] -eq "-N")
    # Update Block size hint to match loaded protocol
    if (-not $rowBufLen.chk.Checked) {
        $hint = if ($proto -eq "UDP") { "1460" } else { "131072" }
        $rowBufLen.tb.ForeColor = $C.TextDim
        $rowBufLen.tb.Text      = $hint
        $rowBufLen.tb.Tag       = $hint
    }
    $txtExtra.Text = if ($p.Contains("extra") -and $p["extra"] -ne "") { $p["extra"] } else { "" }

    $script:suppressEvents = $false
    Update-Preview
}

function Save-CurrentProfile {
    # Recover from list selection if needed
    if (-not $script:currentProfile) {
        $idx = $profileList.SelectedIndex
        if ($idx -ge 0) { $script:currentProfile = $profileList.Items[$idx].ToString() }
    }
    # Manual entry: create new profile from name field
    if (-not $script:currentProfile) {
        $typedName = $txtName.Text.Trim()
        if (-not $typedName) {
            [System.Windows.Forms.MessageBox]::Show(
                "Please enter a profile name before saving.",
                "Name Required",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning)
            $txtName.Focus()
            return $false
        }
        $script:profiles[$typedName] = @{ Active=$true; Data=@{} }
        $script:currentProfile = $typedName
        Refresh-ProfileList $typedName
    }

    $oldName = $script:currentProfile
    $newName = $txtName.Text.Trim()
    if (-not $newName) {
            [System.Windows.Forms.MessageBox]::Show(
                "Please enter a profile name before saving.",
                "Name Required",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning)
            $txtName.Focus()
            return $false
    }

    # Collect data — always write all keys, empty = default
    $data = @{}
    foreach ($row in @($rowHost,$rowPort,$rowBitrate,$rowDuration,$rowInterval,$rowBufLen,$rowStreams,$rowWindow)) {
        if ($row.key -eq "host") {
            # Host: save if field has real value (not hint color, not empty)
            $val = $row.tb.Text.Trim()
            if ($val -ne "" -and $row.tb.ForeColor -ne $C.TextDim -and $val -ne "Enter server IP") {
                $data[$row.key] = $val
            } else {
                $data[$row.key] = ""
            }
        } elseif ($row.chk.Checked) {
            $val = $row.tb.Text.Trim()
            $data[$row.key] = $val
        } else {
            $data[$row.key] = ""
        }
    }
    $data["protocol"]  = if ($rowProto.cb.SelectedItem -eq "UDP") { "-u" } else { "" }
    $data["direction"] = if ($rowDir.cb.SelectedItem  -eq "Reverse") { "-R" } else { "" }
    $data["tcpnodelay"] = if ($chkNodelay.Checked -and $rowProto.cb.SelectedItem -eq "TCP") { "-N" } else { "" }
    $data["extra"]     = $txtExtra.Text.Trim()

    # Read active state from list
    $isActive = $true
    for ($i = 0; $i -lt $profileList.Items.Count; $i++) {
        if ($profileList.Items[$i].ToString() -eq $oldName) {
            $isActive = $profileList.GetItemChecked($i); break
        }
    }

    if ($oldName -ne $newName) {
        # Name changed -> save as NEW profile, keep the old one intact
        if ($script:profiles.Contains($newName)) {
            $res = [System.Windows.Forms.MessageBox]::Show(
                "Profile " + $newName + " already exists. Overwrite it?",
                "Profile exists",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Warning)
            if ($res -ne [System.Windows.Forms.DialogResult]::Yes) { return $false }
        }
        $script:profiles[$newName] = @{ Active=$isActive; Data=$data }
        $script:currentProfile     = $newName
    } else {
        $script:profiles[$newName] = @{ Active=$isActive; Data=$data }
    }

    $script:dirty        = $true
    Refresh-ProfileList $newName
    Update-Preview
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Profile [" + $newName + "] saved in memory. Use Save INI to write to disk."
    $statusLbl.ForeColor = $C.BtnSave
    return $true
}
# Events
$profileList.Add_SelectedIndexChanged({
    if ($script:suppressEvents) { return }
    $idx = $profileList.SelectedIndex
    if ($idx -lt 0) { return }
    Load-Profile $profileList.Items[$idx].ToString()
    # If host was empty in profile, fill with detected IP
    if ($rowHost.tb.ForeColor -eq $C.TextDim -or $rowHost.tb.Text.Trim() -eq "") {
        Apply-HostIP
        Update-Preview
    }
})

$profileList.Add_ItemCheck({
    param($s, $e)
    if ($script:suppressEvents) { return }
    $name = $profileList.Items[$e.Index].ToString()
    if ($script:profiles.Contains($name)) {
        $script:profiles[$name].Active = ($e.NewValue -eq [System.Windows.Forms.CheckState]::Checked)
        $script:dirty = $true
    }
})

$btnAdd.Add_Click({
    $newName = "Profile_" + [datetime]::Now.ToString("HHmmss")
    $script:profiles[$newName] = @{ Active=$true; Data=@{} }
    Refresh-ProfileList $newName
    Load-Profile $newName
    Apply-HostIP   # restore detected IP after Load-Profile resets field
    Update-Preview
    $txtName.Focus(); $txtName.SelectAll()
})

$btnDelete.Add_Click({
    if (-not $script:currentProfile) { return }
    $msg = "Delete profile: " + $script:currentProfile + "?"
    $res = [System.Windows.Forms.MessageBox]::Show($msg, "Confirm Delete",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning)
    if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
        $script:profiles.Remove($script:currentProfile)
        $script:currentProfile = $null
        $script:dirty = $true
        Refresh-ProfileList
        $statusLbl.Text      = "  [" + (Get-TS) + "]  Profile deleted."
        $statusLbl.ForeColor = $C.BtnDel
    }
})

$btnSave.Add_Click({ Save-CurrentProfile })

$btnReload.Add_Click({
    $script:profiles       = Read-IniFile $IniFile
    $script:currentProfile = $null
    $script:dirty          = $false
    Refresh-ProfileList
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Profiles reloaded from disk."
    $statusLbl.ForeColor = $C.Accent
})

$btnSaveAll.Add_Click({
    $ok = Save-CurrentProfile
    if (-not $ok) { return }
    Write-IniFile $IniFile $script:profiles
    $script:dirty        = $false
    $statusLbl.Text      = "  [" + (Get-TS) + "]  INI saved: " + $IniFile
    $statusLbl.ForeColor = $C.BtnAll
})

# Live preview wiring + dirty tracking
foreach ($ctl in @($rowHost.tb,$rowPort.tb,$rowBitrate.tb,$rowDuration.tb,$rowInterval.tb,$rowBufLen.tb,$rowStreams.tb,$rowWindow.tb,$txtExtra)) {
    $ctl.Add_TextChanged({
        if (-not $script:suppressEvents) { $script:dirty = $true }
        Update-Preview
    })
}
foreach ($chk in @($rowPort.chk,$rowBitrate.chk,$rowDuration.chk,$rowInterval.chk,$rowBufLen.chk,$rowStreams.chk,$rowWindow.chk)) {
    $chk.Add_CheckedChanged({
        if (-not $script:suppressEvents) { $script:dirty = $true }
        Update-Preview
    })
}

# Host/IP manual button: activate for editing
$rowHost.chk.Add_CheckedChanged({
    if ($script:suppressEvents) { return }
    $script:dirty = $true
    if ($this.Checked) {
        # Enable editing - use detected IP, or re-detect, or keep current text
        $ip = if ($script:detectedIP -and $script:detectedIP -ne "") { $script:detectedIP } else { Get-LocalIP }
        if ($ip -ne "") {
            $rowHost.tb.ForeColor = $C.Text
            $rowHost.tb.Text      = $ip
        } else {
            # Nothing detected - clear prompt text if showing
            if ($rowHost.tb.ForeColor -eq $C.Danger) {
                $rowHost.tb.Text = ""
            }
            $rowHost.tb.ForeColor = $C.Text
        }
        $rowHost.tb.Enabled = $true
        $rowHost.tb.Focus()
        $rowHost.tb.SelectAll()
        $statusLbl.Text      = "  [" + (Get-TS) + "]  Host IP editable."
        $statusLbl.ForeColor = $C.Accent
    } else {
        # Deactivate - restore detected IP as read-only display
        $ip = if ($script:detectedIP -and $script:detectedIP -ne "") { $script:detectedIP } else { "" }
        if ($ip -ne "") {
            $rowHost.tb.Text      = $ip
            $rowHost.tb.ForeColor = $C.Text
            $rowHost.tb.Enabled   = $false
        } else {
            $rowHost.tb.Text      = "Enter server IP"
            $rowHost.tb.ForeColor = $C.Danger
            $rowHost.tb.Enabled   = $true
            $script:suppressEvents = $true
            $rowHost.chk.Checked  = $true   # keep active if no IP
            $script:suppressEvents = $false
        }
    }
    Update-Preview
})
$rowProto.cb.Add_SelectedIndexChanged({
    if (-not $script:suppressEvents) { $script:dirty = $true }
    # Update Buf len hint based on selected protocol
    if (-not $rowBufLen.chk.Checked) {
        $hint = if ($rowProto.cb.SelectedItem -eq "UDP") { "1460" } else { "131072" }
        $rowBufLen.tb.ForeColor = $C.TextDim
        $rowBufLen.tb.Text      = $hint
        $rowBufLen.tb.Tag       = $hint
    }
    # Disable TCP_NODELAY toggle when UDP selected
    if ($rowProto.cb.SelectedItem -eq "UDP") {
        $chkNodelay.Checked = $false
        $chkNodelay.Enabled = $false
        $lblNDVal.ForeColor = $C.TextDim
    } else {
        $chkNodelay.Enabled = $true
    }
    Update-Preview
})
$rowDir.cb.Add_SelectedIndexChanged({
    if (-not $script:suppressEvents) { $script:dirty = $true }
    Update-Preview
})


# Set placeholder texts after handles are created
$form.Add_Shown({
    Set-Placeholder $txtName  "Enter profile name"
    Set-Placeholder $txtExtra "--get-server-output --logfile out.txt ..."

    # Show ready state immediately, detect IP after UI is fully painted
    $statusLbl.Text      = "  Ready  |  " + $IniFile + "   Detecting local IP..."
    $statusLbl.ForeColor = $C.TextDim

    # Use a one-shot timer so IP detection runs after full UI render
    $script:ipTimer = New-Object System.Windows.Forms.Timer
    $script:ipTimer.Interval = 150
    $script:ipTimer.Add_Tick({
        param($sender, $e)
        $sender.Stop()
        $sender.Dispose()
        $script:ipTimer = $null

        $script:detectedIP = Get-LocalIP
        Apply-HostIP
        if ($script:detectedIP -ne "") {
            $statusLbl.Text      = "  Ready  |  " + $IniFile + "   Local IP: " + $script:detectedIP
            $statusLbl.ForeColor = $C.TextDim
            Update-Preview
        } else {
            $rowHost.tb.Text      = "Enter server IP"
            $rowHost.tb.ForeColor = $C.Danger
            $rowHost.tb.Enabled   = $true
            $script:suppressEvents = $true
            $rowHost.chk.Checked  = $true
            $script:suppressEvents = $false
            $statusLbl.Text      = "  Ready  |  " + $IniFile + "   Could not detect local IP - enter manually."
            $statusLbl.ForeColor = $C.Danger
        }
    })
    $script:ipTimer.Start()
})

# Initial load
Refresh-ProfileList
if ($profileList.Items.Count -gt 0) {
    $profileList.SelectedIndex = 0
    Load-Profile $profileList.Items[0].ToString()
}

$form.Add_FormClosing({
    param($s, $e)
    if ($script:dirty) {
        $res = [System.Windows.Forms.MessageBox]::Show(
            "You have unsaved changes. Save INI file before closing?",
            "Unsaved Changes",
            [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        if ($res -eq [System.Windows.Forms.DialogResult]::Yes) {
            $ok = Save-CurrentProfile
            if (-not $ok) { return }
            Write-IniFile $IniFile $script:profiles
            $script:dirty = $false
        } elseif ($res -eq [System.Windows.Forms.DialogResult]::Cancel) {
            $e.Cancel = $true
        }
    }
})

[void]$form.ShowDialog()