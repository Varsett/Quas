param(
    [string]$WorkDir = ""
)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$WorkDir = if ($WorkDir -ne "" -and (Test-Path $WorkDir)) { $WorkDir.TrimEnd("\") } else { $PSScriptRoot }
$OutFile  = Join-Path $WorkDir "multitest.txt"
$FlagFile = Join-Path $WorkDir "mt.flag"

$script:C = @{
    Bg           = [System.Drawing.Color]::FromArgb(22,  22,  32)
    Panel        = [System.Drawing.Color]::FromArgb(30,  30,  44)
    Card         = [System.Drawing.Color]::FromArgb(38,  38,  54)
    Border       = [System.Drawing.Color]::FromArgb(60,  60,  85)
    RowLine      = [System.Drawing.Color]::FromArgb(42,  42,  58)
    Accent       = [System.Drawing.Color]::FromArgb(100, 149, 237)
    AccentHov    = [System.Drawing.Color]::FromArgb(140, 185, 255)
    Text         = [System.Drawing.Color]::FromArgb(210, 210, 225)
    TextDim      = [System.Drawing.Color]::FromArgb(110, 110, 140)
    TextDark     = [System.Drawing.Color]::FromArgb(20,  20,  30)
    Input        = [System.Drawing.Color]::FromArgb(18,  18,  28)
    Disabled     = [System.Drawing.Color]::FromArgb(28,  28,  40)
    DisText      = [System.Drawing.Color]::FromArgb(65,  65,  85)
    Danger       = [System.Drawing.Color]::FromArgb(252, 129, 129)
    DangerHov    = [System.Drawing.Color]::FromArgb(255, 160, 160)
    Success      = [System.Drawing.Color]::FromArgb(104, 211, 145)
    SuccessHov   = [System.Drawing.Color]::FromArgb(140, 230, 175)
    SaveBtn      = [System.Drawing.Color]::FromArgb(148, 167, 215)
    SaveHov      = [System.Drawing.Color]::FromArgb(175, 192, 235)
    ReloadBtn    = [System.Drawing.Color]::FromArgb(85,  110, 165)
    ReloadHov    = [System.Drawing.Color]::FromArgb(110, 138, 195)
    RunBtn       = [System.Drawing.Color]::FromArgb(120, 200, 120)
    RunHov       = [System.Drawing.Color]::FromArgb(150, 225, 150)
    BtnToggleOn  = [System.Drawing.Color]::FromArgb(100, 149, 237)
    BtnToggleOff = [System.Drawing.Color]::FromArgb(45,  48,  68)
    BtnToggleHov = [System.Drawing.Color]::FromArgb(70,  80, 110)
}

$script:F = @{
    Main   = New-Object System.Drawing.Font("Segoe UI", 9)
    Bold   = New-Object System.Drawing.Font("Segoe UI", 9,  [System.Drawing.FontStyle]::Bold)
    Small  = New-Object System.Drawing.Font("Segoe UI", 8)
    Title  = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    Header = New-Object System.Drawing.Font("Segoe UI", 8,  [System.Drawing.FontStyle]::Bold)
}

$script:Cols = @(
    @{ N="Label";     W=160; D="Test1" }
    @{ N="Interval";  W=78;  D="100"  }
    @{ N="Streams";   W=72;  D="1"    }
    @{ N="Duration";  W=78;  D="180"  }
    @{ N="BandWidth"; W=86;  D="0"    }
    @{ N="Protocol";  W=82;  D="TCP"  }
)

$script:Limits = @{
    "Interval"  = @(100, 5000)
    "Streams"   = @(1,   10)
    "Duration"  = @(5,   3600)
    "BandWidth" = @(0,   2000)
}

$script:CB_W  = 26
$script:MAN_W = 62
$script:GAP   = 6
$script:PAD_L = 10
$script:PAD_T = 5
$script:ROW_H = 34
$script:HDR_H = 26
$script:TIT_H = 34
$script:BTN_H = 28

$rw = $script:PAD_L + $script:CB_W + $script:GAP
foreach ($col in $script:Cols) { $rw += $col.W + $script:GAP }
$rw += $script:MAN_W + $script:PAD_L
$script:ROW_W = $rw
$script:FORM_W = $rw + 22

$script:INIT_ROWS = 8
$script:SCR_H = $script:INIT_ROWS * $script:ROW_H + $script:PAD_T * 2
$script:SEP_Y  = $script:TIT_H + $script:HDR_H + $script:SCR_H
$script:BTN_Y  = $script:SEP_Y + 8
$script:STAT_Y = $script:BTN_Y + $script:BTN_H + 6
$script:FORM_H = $script:STAT_Y + 24 + 6

function Get-TS { (Get-Date).ToString("HH:mm:ss") }

function New-FlatBtn {
    param([string]$Text,[int]$X,[int]$Y,[int]$W=100,[int]$H=28,
          [System.Drawing.Color]$Bg=$script:C.SaveBtn,
          [System.Drawing.Color]$Fg=$script:C.TextDark,
          [System.Drawing.Color]$Hov=$script:C.SaveHov)
    $b = New-Object System.Windows.Forms.Button
    $b.Text      = $Text
    $b.Location  = New-Object System.Drawing.Point($X,$Y)
    $b.Size      = New-Object System.Drawing.Size($W,$H)
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize         = 0
    $b.FlatAppearance.MouseOverBackColor = $Hov
    $b.BackColor = $Bg; $b.ForeColor = $Fg; $b.Font = $script:F.Bold
    $b.Cursor    = [System.Windows.Forms.Cursors]::Hand
    return $b
}

function New-TB {
    param([int]$X,[int]$Y,[int]$W,[string]$Val="")
    $t = New-Object System.Windows.Forms.TextBox
    $t.Location    = New-Object System.Drawing.Point($X,$Y)
    $t.Size        = New-Object System.Drawing.Size($W,22)
    $t.BackColor   = $script:C.Disabled
    $t.ForeColor   = $script:C.DisText
    $t.Font        = $script:F.Main
    $t.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    $t.Text        = $Val
    $t.Enabled     = $false
    return $t
}

function New-ProtoCombo {
    param([int]$X,[int]$Y,[int]$W,[string]$Sel="TCP")
    $c = New-Object System.Windows.Forms.ComboBox
    $c.Location      = New-Object System.Drawing.Point($X,$Y)
    $c.Size          = New-Object System.Drawing.Size($W,22)
    $c.BackColor     = $script:C.Disabled
    $c.ForeColor     = $script:C.DisText
    $c.Font          = $script:F.Main
    $c.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $c.FlatStyle     = [System.Windows.Forms.FlatStyle]::Flat
    [void]$c.Items.Add("TCP"); [void]$c.Items.Add("UDP")
    if ($c.Items.Contains($Sel)) { $c.SelectedItem = $Sel } else { $c.SelectedIndex = 0 }
    $c.Enabled = $false
    return $c
}

function New-RowObj {
    param([bool]$Active=$true,[string]$Label="Test",
          [string]$Interval="100",[string]$Streams="1",
          [string]$Duration="180",[string]$BandWidth="0",
          [string]$Protocol="TCP",[bool]$Manual=$false)
    return @{ Active=$Active; Label=$Label; Interval=$Interval
              Streams=$Streams; Duration=$Duration
              BandWidth=$BandWidth; Protocol=$Protocol; Manual=$Manual }
}

$script:rows = [System.Collections.Generic.List[object]]::new()

# ── Form ───────────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text            = "Multitest Editor  v1.12"
$form.BackColor       = $script:C.Bg
$form.ForeColor       = $script:C.Text
$form.Font            = $script:F.Main
$form.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.MaximizeBox     = $true
$form.MinimumSize     = New-Object System.Drawing.Size(($script:FORM_W + 16), 300)
$form.ClientSize      = New-Object System.Drawing.Size($script:FORM_W, $script:FORM_H)

# Title
$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Location  = New-Object System.Drawing.Point(0,0)
$titleLbl.Size      = New-Object System.Drawing.Size($script:FORM_W, $script:TIT_H)
$titleLbl.BackColor = $script:C.Panel
$titleLbl.ForeColor = $script:C.Accent
$titleLbl.Font      = $script:F.Title
$titleLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$titleLbl.Text      = "  Multitest Editor"
$titleLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($titleLbl)

# Header
$hdrPanel = New-Object System.Windows.Forms.Panel
$hdrPanel.Location  = New-Object System.Drawing.Point(0, $script:TIT_H)
$hdrPanel.Size      = New-Object System.Drawing.Size($script:FORM_W, $script:HDR_H)
$hdrPanel.BackColor = $script:C.Panel
$hdrPanel.Anchor    = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($hdrPanel)

$hx = $script:PAD_L
$lOn = New-Object System.Windows.Forms.Label
$lOn.Text="On"; $lOn.Location=New-Object System.Drawing.Point($hx,5)
$lOn.Size=New-Object System.Drawing.Size($script:CB_W,16)
$lOn.ForeColor=$script:C.TextDim; $lOn.Font=$script:F.Header
$lOn.BackColor=[System.Drawing.Color]::Transparent
$hdrPanel.Controls.Add($lOn)
$hx += $script:CB_W + $script:GAP

foreach ($col in $script:Cols) {
    $lc = New-Object System.Windows.Forms.Label
    $lc.Text=$col.N; $lc.Location=New-Object System.Drawing.Point($hx,5)
    $lc.Size=New-Object System.Drawing.Size($col.W,16)
    $lc.ForeColor=$script:C.Accent; $lc.Font=$script:F.Header
    $lc.BackColor=[System.Drawing.Color]::Transparent
    $hdrPanel.Controls.Add($lc)
    $hx += $col.W + $script:GAP
}

$lMan = New-Object System.Windows.Forms.Label
$lMan.Text="manual"; $lMan.Location=New-Object System.Drawing.Point($hx,5)
$lMan.Size=New-Object System.Drawing.Size($script:MAN_W,16)
$lMan.ForeColor=$script:C.TextDim; $lMan.Font=$script:F.Header
$lMan.BackColor=[System.Drawing.Color]::Transparent
$hdrPanel.Controls.Add($lMan)

# Scroll panel
$scrTopY = $script:TIT_H + $script:HDR_H
$scrollPanel = New-Object System.Windows.Forms.Panel
$scrollPanel.Location   = New-Object System.Drawing.Point(0, $scrTopY)
$scrollPanel.Size       = New-Object System.Drawing.Size($script:FORM_W, $script:SCR_H)
$scrollPanel.BackColor  = $script:C.Bg
$scrollPanel.AutoScroll = $true
$scrollPanel.Anchor     = [System.Windows.Forms.AnchorStyles]::Top -bor `
                          [System.Windows.Forms.AnchorStyles]::Left -bor `
                          [System.Windows.Forms.AnchorStyles]::Right -bor `
                          [System.Windows.Forms.AnchorStyles]::Bottom
$form.Controls.Add($scrollPanel)

# Separator
$sep = New-Object System.Windows.Forms.Panel
$sep.Location  = New-Object System.Drawing.Point(0, $script:SEP_Y)
$sep.Size      = New-Object System.Drawing.Size($script:FORM_W, 1)
$sep.BackColor = $script:C.Border
$sep.Anchor    = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($sep)

# Buttons
$bx = $script:PAD_L
$btnSave   = New-FlatBtn "Save"    $bx $script:BTN_Y  90 $script:BTN_H $script:C.SaveBtn   $script:C.TextDark $script:C.SaveHov
$bx += 98
$btnReload = New-FlatBtn "Reload"  $bx $script:BTN_Y  90 $script:BTN_H $script:C.ReloadBtn $script:C.TextDark $script:C.ReloadHov
$bx += 98
$btnAdd    = New-FlatBtn "+ Add"   $bx $script:BTN_Y  80 $script:BTN_H $script:C.Success   $script:C.TextDark $script:C.SuccessHov
$bx += 88
$btnDel    = New-FlatBtn "Remove"  $bx $script:BTN_Y  80 $script:BTN_H $script:C.Danger    $script:C.TextDark $script:C.DangerHov
$bx += 98
#$btnRun    = New-FlatBtn "Run"     $bx $script:BTN_Y  76 $script:BTN_H $script:C.RunBtn    $script:C.TextDark $script:C.RunHov
$btnRun    = New-FlatBtn "Confirm"     $bx $script:BTN_Y  76 $script:BTN_H $script:C.RunBtn    $script:C.TextDark $script:C.RunHov
$form.Controls.Add($btnSave)
$form.Controls.Add($btnReload)
$form.Controls.Add($btnAdd)
$form.Controls.Add($btnDel)
$form.Controls.Add($btnRun)

$btnHelp = New-FlatBtn "?" ($script:FORM_W - 38) $script:BTN_Y 28 $script:BTN_H $script:C.Panel $script:C.TextDim $script:C.Border
$btnHelp.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($btnHelp)

foreach ($b in @($btnSave,$btnReload,$btnAdd,$btnDel,$btnRun)) {
    $b.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
}

# Status
$statusLbl = New-Object System.Windows.Forms.Label
$statusLbl.Location  = New-Object System.Drawing.Point(0, $script:STAT_Y)
$statusLbl.Size      = New-Object System.Drawing.Size($script:FORM_W, 24)
$statusLbl.BackColor = $script:C.Panel
$statusLbl.ForeColor = $script:C.TextDim
$statusLbl.Font      = $script:F.Small
$statusLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLbl.Text      = "  Ready  |  " + $OutFile
$statusLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($statusLbl)

# Resize: reposition bottom controls
$form.Add_Resize({
    $h = $form.ClientSize.Height
    $newScrH = $h - $scrTopY - ($script:FORM_H - $script:SEP_Y)
    if ($newScrH -lt $script:ROW_H) { $newScrH = $script:ROW_H }
    $scrollPanel.Height = $newScrH
    $newSepY = $scrTopY + $newScrH
    $sep.Top       = $newSepY
    $newBtnY       = $newSepY + 8
    $newStatY      = $newBtnY + $script:BTN_H + 6
    foreach ($b in @($btnSave,$btnReload,$btnAdd,$btnDel,$btnRun,$btnHelp)) { $b.Top = $newBtnY }
    $statusLbl.Top = $newStatY
})

# ── Row rendering ──────────────────────────────────────────────
$script:rowControls = [System.Collections.Generic.List[object]]::new()

function Render-Rows {
    $scrollPanel.SuspendLayout()
    $scrollPanel.Controls.Clear()
    $script:rowControls.Clear()
    $y = $script:PAD_T

    foreach ($row in $script:rows) {
        $ri   = $script:rowControls.Count
        $ctrl = @{ chk=$null; fields=@(); proto=$null; manBtn=$null }

        if ($ri -gt 0) {
            $rl = New-Object System.Windows.Forms.Panel
            $rl.Location  = New-Object System.Drawing.Point(0,($y-1))
            $rl.Size      = New-Object System.Drawing.Size($script:ROW_W,1)
            $rl.BackColor = $script:C.RowLine
            $scrollPanel.Controls.Add($rl)
        }

        $cx   = $script:PAD_L
        $cy   = $y + [int](($script:ROW_H - 22) / 2)
        $chkY = $y + [int](($script:ROW_H - 24) / 2)

        # On checkbox
        $chk = New-Object System.Windows.Forms.CheckBox
        $chk.Location  = New-Object System.Drawing.Point($cx,$chkY)
        $chk.Size      = New-Object System.Drawing.Size($script:CB_W,24)
        $chk.Checked   = $row.Active
        $chk.BackColor = [System.Drawing.Color]::Transparent
        $chk.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $chk.FlatAppearance.CheckedBackColor = $script:C.Accent
        $chk.FlatAppearance.BorderColor      = $script:C.Border
        $chk.ForeColor = [System.Drawing.Color]::Black
        $scrollPanel.Controls.Add($chk)
        $ctrl.chk = $chk
        $cx += $script:CB_W + $script:GAP

        # Data fields - all disabled until manual clicked
        $fields = @()
        foreach ($col in $script:Cols) {
            if ($col.N -eq "Protocol") {
                $cb = New-ProtoCombo $cx $cy $col.W $row.Protocol
                $scrollPanel.Controls.Add($cb)
                $ctrl.proto = $cb
            } else {
                $val = switch ($col.N) {
                    "Label"     { $row.Label     }
                    "Interval"  { $row.Interval  }
                    "Streams"   { $row.Streams   }
                    "Duration"  { $row.Duration  }
                    "BandWidth" { $row.BandWidth }
                    default     { "" }
                }
                $tb = New-TB $cx $cy $col.W $val
                $scrollPanel.Controls.Add($tb)
                $fields += $tb
            }
            $cx += $col.W + $script:GAP
        }
        $ctrl.fields = $fields

        # Manual toggle button
        $manY = $chkY
        $man  = New-Object System.Windows.Forms.CheckBox
        $man.Text       = "manual"
        $man.Location   = New-Object System.Drawing.Point($cx,$manY)
        $man.Size       = New-Object System.Drawing.Size($script:MAN_W,24)
        $man.Checked    = $false
        $man.Appearance = [System.Windows.Forms.Appearance]::Button
        $man.FlatStyle  = [System.Windows.Forms.FlatStyle]::Flat
        $man.FlatAppearance.BorderSize         = 1
        $man.FlatAppearance.BorderColor        = $script:C.Border
        $man.FlatAppearance.CheckedBackColor   = $script:C.BtnToggleOn
        $man.FlatAppearance.MouseOverBackColor = $script:C.BtnToggleHov
        $man.BackColor  = $script:C.BtnToggleOff
        $man.ForeColor  = $script:C.TextDim
        $man.Font       = $script:F.Small
        $man.TextAlign  = [System.Drawing.ContentAlignment]::MiddleCenter
        $man.Cursor     = [System.Windows.Forms.Cursors]::Hand
        $man.Tag        = $ctrl
        $scrollPanel.Controls.Add($man)
        $ctrl.manBtn = $man

        $script:rowControls.Add($ctrl)

        # Wire manual via Tag - same pattern as configurator
        $man.Add_CheckedChanged({
            $c  = $this.Tag
            $on = $this.Checked
            $this.ForeColor = if ($on) { $script:C.TextDark } else { $script:C.TextDim }
            $this.FlatAppearance.MouseOverBackColor = if ($on) { $script:C.AccentHov } else { $script:C.BtnToggleHov }
            foreach ($tb in $c.fields) {
                $tb.Enabled   = $on
                $tb.BackColor = if ($on) { $script:C.Input   } else { $script:C.Disabled }
                $tb.ForeColor = if ($on) { $script:C.Text    } else { $script:C.DisText  }
            }
            if ($c.proto) {
                $c.proto.Enabled   = $on
                $c.proto.BackColor = if ($on) { $script:C.Input   } else { $script:C.Disabled }
                $c.proto.ForeColor = if ($on) { $script:C.Text    } else { $script:C.DisText  }
            }
            if ($on -and $c.fields.Count -gt 0) {
                $c.fields[0].Focus(); $c.fields[0].SelectAll()
            }
        })

        # Restore manual state from row data (fires CheckedChanged above if true)
        $man.Checked = $row.Manual

        $y += $script:ROW_H
    }
    $scrollPanel.ResumeLayout()
    $scrollPanel.Refresh()
}

function Collect-Rows {
    $script:rows.Clear()
    foreach ($ctrl in $script:rowControls) {
        $proto = if ($ctrl.proto) { $ctrl.proto.SelectedItem.ToString() } else { "TCP" }
        $f     = $ctrl.fields
        $v0=$f[0].Text.Trim(); $v1=$f[1].Text.Trim(); $v2=$f[2].Text.Trim()
        $v3=$f[3].Text.Trim(); $v4=$f[4].Text.Trim()
        $manual = $ctrl.manBtn.Checked
        $script:rows.Add((New-RowObj $ctrl.chk.Checked $v0 $v1 $v2 $v3 $v4 $proto $manual))
    }
}

function Validate-Rows {
    $errors = @()
    $idx = 0
    foreach ($ctrl in $script:rowControls) {
        $idx++
        if (-not $ctrl.chk.Checked) { continue }
        $f = $ctrl.fields
        $colNames = @("Label","Interval","Streams","Duration","BandWidth")
        for ($ci = 1; $ci -le 4; $ci++) {
            $colName = $colNames[$ci]
            $lim     = $script:Limits[$colName]
            $raw     = $f[$ci].Text.Trim()
            $num     = 0
            if (-not [int]::TryParse($raw,[ref]$num)) {
                $errors += "Row " + $idx + " [" + $f[0].Text.Trim() + "]  " + $colName + ": not a number (got: " + $raw + ")"
                continue
            }
            if ($num -lt $lim[0] -or $num -gt $lim[1]) {
                $errors += "Row " + $idx + " [" + $f[0].Text.Trim() + "]  " + $colName + ": " + $num + " out of range [" + $lim[0] + ".." + $lim[1] + "]"
            }
        }
    }
    if ($errors.Count -gt 0) {
        $msg  = "Values out of allowed limits:" + [char]10 + [char]10
        $msg += ($errors -join [char]10) + [char]10 + [char]10
        $msg += "Allowed ranges:" + [char]10
        $msg += "  Interval:  100 .. 5000" + [char]10
        $msg += "  Streams:   1 .. 10" + [char]10
        $msg += "  Duration:  5 .. 3600" + [char]10
        $msg += "  BandWidth: 0 .. 2000"
        [System.Windows.Forms.MessageBox]::Show($msg,"Validation Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        return $false
    }
    return $true
}

function Read-File {
    $script:rows.Clear()
    if (-not (Test-Path $OutFile)) {
        $script:rows.Add((New-RowObj $true "Test1"))
        Render-Rows; return
    }
    foreach ($raw in (Get-Content $OutFile -Encoding UTF8)) {
        $line = $raw.Trim()
        if ($line -eq "" -or $line -match '^Label\b') { continue }
        $active = $true
        if ($line.StartsWith(";")) { $active=$false; $line=$line.Substring(1).TrimStart() }
        $parts = $line -split '\s+',6
        if ($parts.Count -lt 6) { continue }
        $script:rows.Add((New-RowObj $active $parts[0] $parts[1] $parts[2] $parts[3] $parts[4] $parts[5]))
    }
    if ($script:rows.Count -eq 0) { $script:rows.Add((New-RowObj $true "Test1")) }
    Render-Rows
}

function Save-File {
    if (-not (Validate-Rows)) { return }
    Collect-Rows
    $lines = @("{0,-16} {1,-8} {2,-7} {3,-8} {4,-9} {5}" -f "Label","Interval","Streams","Duration","BandWidth","Protocol")
    foreach ($row in $script:rows) {
        $line = "{0,-16} {1,-8} {2,-7} {3,-8} {4,-9} {5}" -f $row.Label,$row.Interval,$row.Streams,$row.Duration,$row.BandWidth,$row.Protocol
        if (-not $row.Active) { $line = ";" + $line }
        $lines += $line
    }
    $enc = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllLines($OutFile,$lines,$enc)
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Saved: " + $OutFile
    $statusLbl.ForeColor = $script:C.Accent
}

# Events
$btnSave.Add_Click({ Save-File })

$btnReload.Add_Click({
    Read-File
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Reloaded from disk."
    $statusLbl.ForeColor = $script:C.TextDim
})

$btnAdd.Add_Click({
    Collect-Rows
    $n = $script:rows.Count + 1
    $script:rows.Add((New-RowObj $true ("Test" + $n)))
    Render-Rows
})

$btnDel.Add_Click({
    if ($script:rows.Count -le 1) { return }
    Collect-Rows
    $script:rows.RemoveAt($script:rows.Count - 1)
    Render-Rows
})

$btnRun.Add_Click({
    Save-File
    if (-not (Test-Path $OutFile)) { return }
    $enc = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($FlagFile,"1",$enc)
    $statusLbl.Text      = "  [" + (Get-TS) + "]  Saved + mt.flag created."
    $statusLbl.ForeColor = $script:C.RunBtn
    $form.Close()
})

$btnHelp.Add_Click({
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = "Multitest Editor - Help"
    $dlg.Size            = New-Object System.Drawing.Size(500,460)
    $dlg.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $dlg.BackColor       = $script:C.Bg
    $dlg.ForeColor       = $script:C.Text
    $dlg.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $dlg.MaximizeBox     = $false; $dlg.MinimizeBox = $false

    $rtb = New-Object System.Windows.Forms.RichTextBox
    $rtb.Location    = New-Object System.Drawing.Point(12,12)
    $rtb.Size        = New-Object System.Drawing.Size(460,410)
    $rtb.BackColor   = $script:C.Bg
    $rtb.ForeColor   = $script:C.Text
    $rtb.ReadOnly    = $true
    $rtb.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $rtb.Font        = New-Object System.Drawing.Font("Segoe UI",9)
    $dlg.Controls.Add($rtb)

    function Write-HelpLine {
        param([string]$Text,[bool]$Bold=$false)
        $s = $rtb.TextLength
        $rtb.AppendText($Text + "`n")
        $rtb.Select($s,$Text.Length)
        $fs = if ($Bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
        $rtb.SelectionFont  = New-Object System.Drawing.Font("Segoe UI",9,$fs)
        $rtb.SelectionColor = if ($Bold) { $script:C.Accent } else { $script:C.Text }
    }

    Write-HelpLine "OVERVIEW" $true
    Write-HelpLine "  Creates multitest.txt with test configurations."
    Write-HelpLine "  Each row = one test run. Add as many rows as needed."
    Write-HelpLine ""
    Write-HelpLine "COLUMNS" $true
    Write-HelpLine "  On         " $true
    Write-HelpLine "             Checkbox: row active or inactive."
    Write-HelpLine "             Inactive rows saved with ; prefix, skipped by CMD."
    Write-HelpLine "  Label      " $true
    Write-HelpLine "             Test name / identifier."
    Write-HelpLine "  Interval   " $true
    Write-HelpLine "             Reporting interval (ms).  Range: 100 .. 5000"
    Write-HelpLine "  Streams    " $true
    Write-HelpLine "             Parallel streams.  Range: 1 .. 10"
    Write-HelpLine "  Duration   " $true
    Write-HelpLine "             Test duration (seconds).  Range: 5 .. 3600"
    Write-HelpLine "  BandWidth  " $true
    Write-HelpLine "             Target bandwidth (Mbps). 0 = unlimited.  Range: 0 .. 2000"
    Write-HelpLine "  Protocol   " $true
    Write-HelpLine "             TCP (default) or UDP dropdown."
    Write-HelpLine "  manual     " $true
    Write-HelpLine "             Toggle button. Gray = fields locked."
    Write-HelpLine "             Blue = fields editable. Focus goes to Label."
    Write-HelpLine ""
    Write-HelpLine "BUTTONS" $true
    Write-HelpLine "  Save    " $true
    Write-HelpLine "          Validate and save all rows to multitest.txt."
    Write-HelpLine "  Reload  " $true
    Write-HelpLine "          Reload all rows from multitest.txt."
    Write-HelpLine "  + Add   " $true
    Write-HelpLine "          Add a new empty row at the bottom."
    Write-HelpLine "  Remove  " $true
    Write-HelpLine "          Remove the last row."
    Write-HelpLine "  Run     " $true
    Write-HelpLine "          Save file, create mt.flag, close window."
    Write-HelpLine "          CMD script checks mt.flag to start tests."
    Write-HelpLine ""
    Write-HelpLine "FILE FORMAT" $true
    Write-HelpLine "  Label            Interval Streams Duration BandWidth Protocol"
    Write-HelpLine "  TestName         100      1       180      300       TCP"
    Write-HelpLine "  ;DisabledTest    100      1       60       0         UDP"
    Write-HelpLine ""
    Write-HelpLine "LAUNCH" $true
    Write-HelpLine "  powershell -File multitest-editor.ps1 -WorkDir ""%~dp0"""

    $rtb.SelectionStart = 0
    [void]$dlg.ShowDialog()
})

Read-File
[void]$form.ShowDialog()