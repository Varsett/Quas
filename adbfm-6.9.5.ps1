# Adbfm 6.9.5 - Stable 6.8 Base [No Slashes & Focus Fix]
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- INITIALIZATION ---
$rawPath = [Environment]::GetEnvironmentVariable("myfiles", "Process")
if (-not $rawPath) { $rawPath = "adb" }
$envAdb = if (Test-Path -Path $rawPath -PathType Container) { Join-Path $rawPath "adb.exe" } else { $rawPath }

$currentLocalPath = "C:\"
$currentAdbPath = "/storage/emulated/0"
$global:SelectedPaths = New-Object 'System.Collections.Generic.HashSet[string]'

# --- COLORS ---
$bgForm = [System.Drawing.Color]::FromArgb(40, 40, 40)
$bgActive = [System.Drawing.Color]::FromArgb(30, 30, 33)
$bgInactive = [System.Drawing.Color]::FromArgb(20, 20, 22)
$cursorActive = [System.Drawing.Color]::FromArgb(0, 85, 170)
$cursorInactive = [System.Drawing.Color]::FromArgb(70, 70, 70)
$markColor = [System.Drawing.Color]::Yellow

# --- FLICKER-FREE DIALOG FUNCTION ---
function Show-AdbDialog {
    param($title, $msg, $defVal=$null, $items=@(), $isHelp=$false)
    $d = New-Object System.Windows.Forms.Form
    $d.Text = $title; $d.BackColor = $bgForm; $d.ForeColor="White"; $d.FormBorderStyle = "FixedDialog"; $d.KeyPreview = $true; $d.StartPosition = "CenterParent"
    $d.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).SetValue($d, $true, $null)
    
    if ($isHelp) { $d.Size = "550,480" }
    elseif ($null -ne $defVal) { $d.Size = "450,200" }
    else { $d.Size = "450,320" }

    $rtb = New-Object System.Windows.Forms.RichTextBox
    $rtb.Location = "20,15"; $rtb.Size = "$($d.ClientSize.Width - 40), $($d.ClientSize.Height - 85)"
    $rtb.BackColor = $bgForm; $rtb.ForeColor = [System.Drawing.Color]::White; $rtb.BorderStyle = "None"; $rtb.ReadOnly = $true; $rtb.Font = New-Object System.Drawing.Font("Segoe UI", 10); $rtb.Cursor = [System.Windows.Forms.Cursors]::Arrow; $rtb.TabStop = $false
    
    $rtb.AppendText($msg + "`r`n`r`n")
    foreach($i in $items) { $rtb.SelectionColor = $markColor; $rtb.AppendText("  - $i`r`n"); $rtb.SelectionColor = [System.Drawing.Color]::White }
    $d.Controls.Add($rtb)

    $input = $null
    if ($null -ne $defVal) {
        $rtb.Visible = $false
        $lbl = New-Object System.Windows.Forms.Label; $lbl.Text = $msg; $lbl.Location = "20,25"; $lbl.Size = "410,35"; $lbl.TextAlign = "MiddleCenter"; $d.Controls.Add($lbl)
        $input = New-Object System.Windows.Forms.TextBox; $input.Location = "50,75"; $input.Width = 350; $input.Text = $defVal; $input.BackColor = [System.Drawing.Color]::FromArgb(60,60,60); $input.ForeColor = "White"
        $d.Controls.Add($input)
    }
    
    $btnOk = New-Object System.Windows.Forms.Button; $btnOk.Text = "OK"; $btnOk.Size = "90,32"; $btnOk.FlatStyle="Flat"; $btnOk.DialogResult = [System.Windows.Forms.DialogResult]::OK; $btnOk.Location = New-Object System.Drawing.Point([int](($d.ClientSize.Width/2) - 100), ($d.ClientSize.Height - 48))
    $btnCan = New-Object System.Windows.Forms.Button; $btnCan.Text = "Cancel"; $btnCan.Size = "90,32"; $btnCan.FlatStyle="Flat"; $btnCan.DialogResult = [System.Windows.Forms.DialogResult]::Cancel; $btnCan.Location = New-Object System.Drawing.Point([int](($d.ClientSize.Width/2) + 10), ($d.ClientSize.Height - 48))
    $d.Controls.AddRange(@($btnOk, $btnCan)); $d.AcceptButton = $btnOk; $d.CancelButton = $btnCan

    # --- ИСПРАВЛЕННЫЙ ФОКУС ПРИ ОТРИСОВКЕ ---
    $d.Add_Shown({ 
        if($null -ne $input){ $input.Focus(); $input.SelectAll() } 
        else { $btnOk.Focus() } 
    })

    $res = $d.ShowDialog()
    if ($res -eq [System.Windows.Forms.DialogResult]::OK) { if ($null -ne $input) { return $input.Text } else { return $true } }
    return $null
}

# --- MAIN WINDOW ---
$form = New-Object System.Windows.Forms.Form; $form.Text = "Adbfm 6.9.5 Pro"; $form.Size = "950, 680"; $form.BackColor = $bgForm; $form.KeyPreview = $true; $form.StartPosition = "CenterScreen"; $form.FormBorderStyle = "FixedSingle"
$form.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).SetValue($form, $true, $null)

$fntPath = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$labelPC = New-Object System.Windows.Forms.Label; $labelPC.Location = "15,10"; $labelPC.Size = "435,20"; $labelPC.ForeColor = "Yellow"; $labelPC.Font = $fntPath; $form.Controls.Add($labelPC)
$labelADB = New-Object System.Windows.Forms.Label; $labelADB.Location = "475,10"; $labelADB.Size = "435,20"; $labelADB.ForeColor = "Yellow"; $labelADB.Font = $fntPath; $form.Controls.Add($labelADB)

$createListBox = {
    param($loc, $defColor)
    $lb = New-Object System.Windows.Forms.ListBox; $lb.Location = $loc; $lb.Size = "450,460"; $lb.BorderStyle = "None"; $lb.DrawMode = "OwnerDrawFixed"; $lb.ItemHeight = 24; $lb.Tag = $defColor
    $lb.Add_DrawItem({
        param($s, $e)
        if ($e.Index -lt 0) { return }
        $txt = $s.Items[$e.Index].ToString()
        # --- СКРЫВАЕМ СЛЭШ ТОЛЬКО ДЛЯ ГЛАЗ (Moment of Drawing) ---
        $displayTxt = $txt -replace '/$',''
        
        $full = if ($s -eq $listBoxPC) { if($currentLocalPath -eq "DRIVES"){$txt} else {Join-Path $currentLocalPath $txt} } else { $currentAdbPath.TrimEnd('/') + "/" + $txt }
        $isSelected = ($e.State -band [System.Windows.Forms.DrawItemState]::Selected); $isFocused = ($form.ActiveControl -eq $s)
        $finalBg = if ($isSelected) { if ($isFocused) { $cursorActive } else { $cursorInactive } } else { $s.BackColor }
        $brushBg = New-Object System.Drawing.SolidBrush($finalBg)
        $finalTxtCol = if ($global:SelectedPaths.Contains($full)) { $markColor } elseif ($txt.EndsWith("/") -or $txt -eq ".. [Go Up]" -or $txt.Contains(":\")) { [System.Drawing.Color]::White } else { $s.Tag }
        $brushTxt = New-Object System.Drawing.SolidBrush($finalTxtCol)
        $e.Graphics.FillRectangle($brushBg, $e.Bounds); $e.Graphics.DrawString($displayTxt, (New-Object System.Drawing.Font("Segoe UI", 10)), $brushTxt, $e.Bounds.X, $e.Bounds.Y + 2)
        $brushBg.Dispose(); $brushTxt.Dispose()
    }); $lb.Add_DoubleClick({ & $navAction }); return $lb
}
$listBoxPC = &$createListBox "15,35" ([System.Drawing.Color]::LightGreen)
$listBoxADB = &$createListBox "475,35" ([System.Drawing.Color]::SkyBlue)
$form.Controls.AddRange(@($listBoxPC, $listBoxADB))

$statusStrip = New-Object System.Windows.Forms.Label; $statusStrip.Location = "15, 555"; $statusStrip.Size = "910, 25"; $statusStrip.ForeColor = "LightGray"; $statusStrip.TextAlign = "MiddleLeft"; $form.Controls.Add($statusStrip)

$checkAdbTimer = New-Object System.Windows.Forms.Timer; $checkAdbTimer.Interval = 3000
$checkAdbTimer.Add_Tick({
    $dev = & "$envAdb" devices | Where-Object { $_ -match "\tdevice$" }
    if ($dev) { $statusStrip.Text = "CONNECTED: $($dev.Split("`t")[0])"; $statusStrip.ForeColor = [System.Drawing.Color]::LightGreen }
    else { $statusStrip.Text = "DISCONNECTED - Check USB cable/port"; $statusStrip.ForeColor = [System.Drawing.Color]::Salmon }
})
$checkAdbTimer.Start()

# --- LOGIC ---
function Refresh-Panel {
    param($panel)
    if ($panel -eq "PC") {
        $idx = [Math]::Max(0, $listBoxPC.SelectedIndex); $labelPC.Text = $currentLocalPath; $listBoxPC.Items.Clear()
        if ($currentLocalPath -eq "DRIVES") { [System.IO.DriveInfo]::GetDrives() | Where-Object { $_.IsReady } | ForEach-Object { [void]$listBoxPC.Items.Add($_.Name) } }
        else { $listBoxPC.Items.Add(".. [Go Up]"); Get-ChildItem $currentLocalPath -ErrorAction SilentlyContinue | Sort-Object PSIsContainer, Name -Descending | ForEach-Object { if ($_.PSIsContainer) { $listBoxPC.Items.Insert(1, "$($_.Name)/") } else { $listBoxPC.Items.Add($_.Name) } } }
        if($idx -lt $listBoxPC.Items.Count){$listBoxPC.SelectedIndex = $idx} else {$listBoxPC.SelectedIndex = 0}; $listBoxPC.Invalidate()
    } else {
        $idx = [Math]::Max(0, $listBoxADB.SelectedIndex); $labelADB.Text = $currentAdbPath; $listBoxADB.Items.Clear(); $listBoxADB.Items.Add(".. [Go Up]")
        & "$envAdb" shell ls -F "`"$currentAdbPath`"" 2>$null | ForEach-Object { $c = $_.Trim(); if($c){$listBoxADB.Items.Add($c)} }
        if($idx -lt $listBoxADB.Items.Count){$listBoxADB.SelectedIndex = $idx} else {$listBoxADB.SelectedIndex = 0}; $listBoxADB.Invalidate()
    }
}

$navAction = {
    $box = if($listBoxPC.Focused -or $listBoxPC.BackColor -eq $bgActive){$listBoxPC}else{$listBoxADB}
    $sel = $box.SelectedItem; if(!$sel){return}
    $clean = $sel.ToString() -replace '[*/@]$',''
    if($sel -eq ".. [Go Up]") {
        if($box -eq $listBoxPC) {
            $folderExited = Split-Path $currentLocalPath -Leaf
            $p = Split-Path $currentLocalPath -Parent
            $script:currentLocalPath = if (!$p -or $p -eq $currentLocalPath) { "DRIVES" } else { $p }
            Refresh-Panel "PC"
            if ($folderExited) {
                $match = $listBoxPC.FindString("$folderExited/"); if ($match -lt 0) { $match = $listBoxPC.FindString($folderExited) }
                if ($match -ge 0) { $listBoxPC.SelectedIndex = $match }
            }
        } else {
            $parts = $currentAdbPath.TrimEnd('/').Split('/'); $folderExited = $parts[-1]
            $script:currentAdbPath = ($parts[0..($parts.Count-2)] -join "/"); if(!$currentAdbPath){$script:currentAdbPath="/"}
            Refresh-Panel "ADB"
            if ($folderExited) {
                $match = $listBoxADB.FindString("$folderExited/"); if ($match -lt 0) { $match = $listBoxADB.FindString($folderExited) }
                if ($match -ge 0) { $listBoxADB.SelectedIndex = $match }
            }
        }
    } else {
        if($box -eq $listBoxPC) { 
            if ($currentLocalPath -eq "DRIVES") { $script:currentLocalPath = $clean; Refresh-Panel "PC" }
            elseif (Test-Path (Join-Path $currentLocalPath $clean) -PathType Container) { $script:currentLocalPath = Join-Path $currentLocalPath $clean; Refresh-Panel "PC" } 
        } else { if($sel.EndsWith("/")){ $script:currentAdbPath = ($currentAdbPath.TrimEnd('/')+"/"+$clean); Refresh-Panel "ADB" } }
    }
    $box.Focus()
}

function Get-Selection-Files($box) {
    $res = @(); foreach($item in $box.Items) {
        $p = if($box -eq $listBoxPC){ if($currentLocalPath -eq "DRIVES"){$item} else {Join-Path $currentLocalPath $item} } else { $currentAdbPath.TrimEnd('/') + "/" + $item }
        if($global:SelectedPaths.Contains($p)){ $res += $item.ToString() }
    }
    if($res.Count -eq 0 -and $box.SelectedItem -and $box.SelectedItem -ne ".. [Go Up]"){ $res += $box.SelectedItem.ToString() }
    return $res
}

# --- ACTIONS ---
function Copy-Action {
    $box = if($listBoxPC.Focused -or $listBoxPC.BackColor -eq $bgActive){$listBoxPC}else{$listBoxADB}
    $items = Get-Selection-Files $box; if ($items.Count -eq 0) { return }
    if ($null -ne (Show-AdbDialog "Confirm Copy" "Copy following item(s)?" $null $items)) {
        foreach($i in $items) { $c = $i -replace '[*/@]$',''; $statusStrip.Text = "COPYING: $c"; $form.Update()
            if($box -eq $listBoxPC){ & "$envAdb" push (Join-Path $currentLocalPath $c) "$currentAdbPath/" } else { & "$envAdb" pull "$currentAdbPath/$c" "$currentLocalPath/" } }
        $global:SelectedPaths.Clear(); Refresh-Panel "PC"; Refresh-Panel "ADB"; $statusStrip.Text = "READY"; $box.Focus()
    }
}
function Move-Action {
    $box = if($listBoxPC.Focused -or $listBoxPC.BackColor -eq $bgActive){$listBoxPC}else{$listBoxADB}
    $sel = $box.SelectedItem; if (!$sel -or $sel -eq ".. [Go Up]") { return }
    $clean = $sel.ToString() -replace '[*/@]$',''
    $new = Show-AdbDialog "Rename / Move" "New name:" $clean
    if($null -ne $new) {
        if($box -eq $listBoxPC) { Rename-Item (Join-Path $currentLocalPath $clean) $new -ErrorAction SilentlyContinue; Refresh-Panel "PC" }
        else { & "$envAdb" shell "mv '$currentAdbPath/$clean' '$currentAdbPath/$new'"; Refresh-Panel "ADB" }
    }; $box.Focus()
}
function NewDir-Action {
    $box = if($listBoxPC.Focused -or $listBoxPC.BackColor -eq $bgActive){$listBoxPC}else{$listBoxADB}
    $new = Show-AdbDialog "New Folder" "Folder name:" "New_Folder"
    if($null -ne $new) { 
        if($box -eq $listBoxPC){ New-Item -ItemType Directory -Path (Join-Path $currentLocalPath $new) -ErrorAction SilentlyContinue; Refresh-Panel "PC" }
        else { & "$envAdb" shell "mkdir -p '$currentAdbPath/$new'"; Refresh-Panel "ADB" } 
    }; $box.Focus()
}
function Delete-Action {
    $box = if($listBoxPC.Focused -or $listBoxPC.BackColor -eq $bgActive){$listBoxPC}else{$listBoxADB}
    $items = Get-Selection-Files $box; if ($items.Count -eq 0) { return }
    if ($null -ne (Show-AdbDialog "Confirm Delete" "DELETE following item(s)?" $null $items)) {
        foreach($i in $items){ $c = $i -replace '[*/@]$',''; if($box -eq $listBoxPC){ Remove-Item (Join-Path $currentLocalPath $c) -Recurse -Force } else { & "$envAdb" shell "rm -rf '$currentAdbPath/$c'" } }
        $global:SelectedPaths.Clear(); Refresh-Panel "PC"; Refresh-Panel "ADB"; $statusStrip.Text = "READY"; $box.Focus()
    }
}
function Go-Data { $script:currentAdbPath="/storage/emulated/0/Android/data"; Refresh-Panel "ADB"; $listBoxADB.Focus() }
function Go-Obb { $script:currentAdbPath="/storage/emulated/0/Android/obb"; Refresh-Panel "ADB"; $listBoxADB.Focus() }

# --- CONTROLS & HOTKEYS ---
$btnY = 515; $btnLabels = @("F5 Copy", "F6 Move", "F7 MkDir", "F8 Delete")
for($i=0; $i -lt 4; $i++) {
    $btn = New-Object System.Windows.Forms.Button; $btn.Text = $btnLabels[$i]; $btn.Location = " $(15 + $i*95), $btnY"; $btn.Size = "90, 30"; $btn.FlatStyle = "Flat"; $btn.ForeColor = "White"; $btn.TabStop = $false
    switch($i){ 0{$btn.Add_Click({Copy-Action})} 1{$btn.Add_Click({Move-Action})} 2{$btn.Add_Click({NewDir-Action})} 3{$btn.Add_Click({Delete-Action})} }
    $form.Controls.Add($btn)
}
$btnData = New-Object System.Windows.Forms.Button; $btnData.Text="F9 Data"; $btnData.Location="475,$btnY"; $btnData.Size="80,30"; $btnData.FlatStyle="Flat"; $btnData.ForeColor="White"; $btnData.TabStop=$false; $btnData.Add_Click({Go-Data})
$btnObb = New-Object System.Windows.Forms.Button; $btnObb.Text="F10 Obb"; $btnObb.Location="565,$btnY"; $btnObb.Size="80,30"; $btnObb.FlatStyle="Flat"; $btnObb.ForeColor="White"; $btnObb.TabStop=$false; $btnObb.Add_Click({Go-Obb})
$btnHelp = New-Object System.Windows.Forms.Button; $btnHelp.Text="?"; $btnHelp.Location="890,$btnY"; $btnHelp.Size="35,30"; $btnHelp.FlatStyle="Flat"; $btnHelp.ForeColor="Yellow"; $btnHelp.TabStop=$false; 
$btnHelp.Add_Click({ 
    $h = "NAVIGATION:`r`n  ENTER / DoubleClick - Open folder or file`r`n  TAB - Switch active panel (PC <-> Android)`r`n  SPACE - Multi-select items (marked Yellow)`r`n  ESC - Close dialog or cancel`r`n`r`nCOMMANDS:`r`n  F5 - Copy selected items to the opposite panel`r`n  F6 - Rename or Move file/folder`r`n  F7 - Create a new directory`r`n  F8 / Del - Delete selected items`r`n  F9 - Jump to Android /data folder`r`n  F10 - Jump to Android /obb folder`r`n`r`nSmart Return: Cursor stays on the folder you just exited."
    Show-AdbDialog "Adbfm 6.8 - Full Help" $h $null @() $true 
    if($listBoxPC.BackColor -eq $bgActive){$listBoxPC.Focus()} else {$listBoxADB.Focus()}
})
$form.Controls.AddRange(@($btnData, $btnObb, $btnHelp))

$form.Add_KeyDown({
    param($s, $e)
    if ($e.KeyCode -eq "Tab") { $e.SuppressKeyPress = $true; if($form.ActiveControl -eq $listBoxPC){$listBoxADB.Focus()} else {$listBoxPC.Focus()}; $form.Refresh() }
    if ($e.KeyCode -eq "Space") { $box = $form.ActiveControl; if($box -is [System.Windows.Forms.ListBox] -and $box.SelectedItem -and $box.SelectedItem -ne ".. [Go Up]") {
            $p = if($box -eq $listBoxPC){ if($currentLocalPath -eq "DRIVES"){$box.SelectedItem} else {Join-Path $currentLocalPath $box.SelectedItem} } else { $currentAdbPath.TrimEnd('/')+"/"+$box.SelectedItem }
            if($global:SelectedPaths.Contains($p)){$global:SelectedPaths.Remove($p)} else {[void]$global:SelectedPaths.Add($p)}; $box.Refresh() } }
    if ($e.KeyCode -eq "Enter") { & $navAction }
    if ($e.KeyCode -eq "F5") { Copy-Action }
    if ($e.KeyCode -eq "F6") { Move-Action }
    if ($e.KeyCode -eq "F7") { NewDir-Action }
    if ($e.KeyCode -eq "F8" -or $e.KeyCode -eq "Delete") { Delete-Action }
    if ($e.KeyCode -eq "F9") { Go-Data }
    if ($e.KeyCode -eq "F10") { $e.SuppressKeyPress = $true; Go-Obb }
})

$listBoxPC.Add_Enter({ $listBoxPC.BackColor = $bgActive; $listBoxADB.BackColor = $bgInactive; $form.Refresh() })
$listBoxADB.Add_Enter({ $listBoxADB.BackColor = $bgActive; $listBoxPC.BackColor = $bgInactive; $form.Refresh() })
$form.Add_Load({ Refresh-Panel "PC"; Refresh-Panel "ADB"; $listBoxPC.Focus() })
$form.ShowDialog()