<#
.SYNOPSIS
    Advanced App Selector with CMD integration and Flag-file support.

.PARAMETERS
    $args[0] - Input File  : Text file (Date;Name;Package;Path)
    $args[1] - Output File : Path for saving results
    -d       - Enable Date : Use 1st column as Date
    -f       - Show Path   : Make "Full Path" column visible
    -o       - Single Mode : Allow only one selection
    -c1      - Install CFG : Show "Install Mode" (creates install.flag)
    -c2      - Extra CFG   : Show "Extra Flag" (creates extra.flag)
    
    Output Formats:
    -p       - Only packages
    -txt     - Fixed text format
    -csv     - CSV (comma separated)
    -csvq    - CSV Quoted (with "double quotes")
    -a       - Default (semicolon separated)

Синтаксис:
    .\selector4.ps1 <inputFile> <outputFile> [-d|-p|-txt|-csv|-a] [-f]

Параметры:
    <inputFile>    - путь к исходному файлу со списком приложений или бэкапов
    <outputFile>   - путь к файлу для сохранения выбранных данных
    -d             - включить колонку "Date" и кнопку "Show Latest Only"
    -p             - вывести только имена пакетов
    -txt           - вывести фиксированный текстовый формат (Date, Name, Package)
    -csv           - сохранить в CSV с заголовками
    -a (по умолчанию) - вывод в формате "Date;Name;Package" или "Name;Package", если нет даты
    -f             - входной файл содержит четвертую колонку FullPath, которая отображается по ключу -f и сохраняется в выходной файл всегда

Особенности работы интерфейса:
    • Search: фильтр по всем колонкам (Date, Name, Package, FullPath), символ ! в начале поисковой фразы инвертирует поиск - "показать все, кроме этого".
    • Select All / Clear All: действуют только на видимые строки
    • Show Latest Only / Show All: отображает только последние бэкапы по имени приложения
      (только если указан ключ -d)
    • Двойной клик на ячейку или Ctrl+C копирует её значение в буфер обмена
    • Стиль шрифта: жирный, удобный для просмотра

Особенности работы скрипта:
    • Четвёртая колонка FullPath отображается только если указан ключ -f
    • Отметка "##" в начале имени приложения выделяет строку синим цветом и удаляется из имени
    • Сортировка по колонкам доступна для всех, кроме колонки "Selected"
    • Кнопки Confirm, Cancel, Select All, Clear All доступны для удобного управления выбором

Пример формата входного файла:
    Racket Fury: Table Tennis VR;com.RacketFury.RF_GearVR
    ;com.ilmxlab.tales
    23.09.2025 01:53;##I Expect You To Die.ab;com.schellgames.ieytdquest;D:\Backups\IEYTD.ab
    23.09.2025 01:54;Resident Evil 4.ab;VRLOC.com.Armature.VR4;D:\Backups\RE4.ab

Файл outputFile формируется в зависимости от выбранного режима (-p, -txt, -csv, -a, -f).

$fixedWidth = 30   # ширина имени (первой колонки или отступа для второй) для txt
================================================================================
Модификации:
25.02.26: Заменен блок Search Filter, добавлен инверсный поиск.
26.02.26: Добавлены 3 чекбокса, добавлен ? с подсказкой, исправлен размер окна, исправлено копирование в буфер, снова добавлен ключ -o для одиночного выбора.



#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$inputFile = $args[0]
$outputFile = $args[1]
$allArgs = $args
$useDate = $allArgs -contains "-d"
$useFullPath = $allArgs -contains "-f"
$showC1 = $allArgs -contains "-c1"
$showC2 = $allArgs -contains "-c2"
$showM  = $allArgs -contains "-m"
$singleMode = $allArgs -contains "-o"

# Output Formats
$outOnlyPackage = $allArgs -contains "-p"
$outFixedTxt = $allArgs -contains "-txt"
$outCsv = $allArgs -contains "-csv"
$outCsvQuote = $allArgs -contains "-csvq"

if (-not (Test-Path $inputFile)) {
    [System.Windows.Forms.MessageBox]::Show("Input file not found:`n$inputFile", "Error")
    exit
}

function Try-ParseDateTime {
    param([string]$s)
    if ([string]::IsNullOrWhiteSpace($s)) { return [datetime]::MinValue }
    $formats = @("dd.MM.yyyy HH:mm", "dd.MM.yyyy", "yyyy-MM-dd HH:mm", "yyyy-MM-dd", "dd.MM.yyyy H:mm", "d.M.yyyy H:mm")
    foreach ($fmt in $formats) {
        try { return [datetime]::ParseExact($s, $fmt, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None) } catch {}
    }
    return [datetime]::MinValue
}

# === Data Parsing ===
$data = Get-Content $inputFile | Where-Object { $_.Trim() -ne "" } | ForEach-Object {
    $line = $_.Trim(); $date = ""; $name = ""; $package = ""; $fullPath = ""; $isMissing = $false
    $cols = $line -split ';'
    if ($useDate -and $cols.Count -ge 3) {
        $date = $cols[0].Trim(); $name = $cols[1].Trim(); $package = $cols[2].Trim()
        if ($cols.Count -ge 4) { $fullPath = $cols[3].Trim() }
    } elseif ($cols.Count -ge 2) {
        $name = $cols[0].Trim(); $package = $cols[1].Trim()
        if ($cols.Count -ge 3) { $fullPath = $cols[2].Trim() }
    }
    if ($name -match '^\s*##') { $isMissing = $true; $name = ($name -replace '^\s*##', '').Trim() }
    if ($package) { [PSCustomObject]@{ Date=$date; Name=$name; Package=$package; FullPath=$fullPath; IsMissing=$isMissing } }
} | Sort-Object Date,Name,Package -Unique

# === Form UI (1100x800) ===
$form = New-Object System.Windows.Forms.Form
$form.Text = if ($singleMode) { "App Selection (Single Mode)" } else { "App Selection" }
$form.ClientSize = New-Object System.Drawing.Size(1100, 800)
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.KeyPreview = $true 

[int]$fWidth = $form.ClientSize.Width
[int]$fHeight = $form.ClientSize.Height
[int]$baseY = $fHeight - 50
[int]$dupX = 640
[int]$privX = 750

$copyTip = New-Object System.Windows.Forms.ToolTip

# Search UI
$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Text = "Search:"; $searchLabel.Location = New-Object System.Drawing.Point(10, 15); $searchLabel.Size = New-Object System.Drawing.Size(60, 25)
$form.Controls.Add($searchLabel)

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(75, 12); $searchBox.Width = $fWidth - 130; $searchBox.Anchor = 'Top, Left, Right'
$form.Controls.Add($searchBox)

# Help Button "?"
$helpBtn = New-Object System.Windows.Forms.Button
$helpBtn.Text = "?"; $helpBtn.Location = New-Object System.Drawing.Point([int]($fWidth - 45), 11); $helpBtn.Size = New-Object System.Drawing.Size(30, 28)
$helpBtn.Anchor = 'Top, Right'
$helpBtn.Add_Click({
    $helpText = "HOTKEYS:`n" +
                "ENTER: Confirm & Exit`n" +
                "ESC: Cancel & Close`n" +
                "CTRL+C / Double Click: Copy cell to clipboard`n`n" +
                "SEARCH TIPS:`n" +
                "- Type to filter by Name or Package`n" +
                "- Start with '!' for Inverse search (e.g. !google)`n`n" +
                "OUTPUT FORMATS:`n" +
                "-p: Packages only`n" +
                "-csv: Comma separated`n" +
                "-csvq: Quoted CSV`n" +
                "-txt: Fixed text labels`n" +
                "-a (default): Semicolon separated"
    [System.Windows.Forms.MessageBox]::Show($helpText, "How to use")
})
$form.Controls.Add($helpBtn)

# Grid
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object System.Drawing.Point(10, 50); $grid.Width = $fWidth - 25; $grid.Height = $fHeight - 110
$grid.Anchor = 'Top, Left, Right, Bottom'
$grid.SelectionMode = 'FullRowSelect'; $grid.RowHeadersVisible = $false; $grid.AllowUserToAddRows = $false
$grid.AllowUserToResizeRows = $false; $grid.RowTemplate.Height = 28; $grid.AutoSizeColumnsMode = 'Fill'
$grid.BackgroundColor = [System.Drawing.Color]::White
$form.Controls.Add($grid)

# Columns
$null = $grid.Columns.Add((New-Object System.Windows.Forms.DataGridViewCheckBoxColumn -Property @{Name="Selected";Width=30;AutoSizeMode='None';Resizable='False'}))
if ($useDate) { $null = $grid.Columns.Add((New-Object System.Windows.Forms.DataGridViewTextBoxColumn -Property @{Name="Date";HeaderText="Date";ReadOnly=$true})) }
$null = $grid.Columns.Add((New-Object System.Windows.Forms.DataGridViewTextBoxColumn -Property @{Name="Name";HeaderText="App Name";ReadOnly=$true}))
$null = $grid.Columns.Add((New-Object System.Windows.Forms.DataGridViewTextBoxColumn -Property @{Name="Package";HeaderText="Package";ReadOnly=$true}))
$null = $grid.Columns.Add((New-Object System.Windows.Forms.DataGridViewTextBoxColumn -Property @{Name="FullPath";HeaderText="Full Path";ReadOnly=$true;Visible=$useFullPath}))

foreach ($item in $data) {
    $index = $grid.Rows.Add()
    $row = $grid.Rows[$index]
    if ($useDate) { $row.Cells["Date"].Value = $item.Date }
    $row.Cells["Name"].Value = $item.Name; $row.Cells["Package"].Value = $item.Package; $row.Cells["FullPath"].Value = $item.FullPath
    $row.DefaultCellStyle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    if ($item.IsMissing) { $row.DefaultCellStyle.ForeColor = [System.Drawing.Color]::Blue }
}

# --- Checkboxes ---
# --- Checkboxes ---
$checkDups = New-Object System.Windows.Forms.CheckBox
$checkDups.Text = "Mark Old"; $checkDups.Location = New-Object System.Drawing.Point($dupX, [int]($baseY - 6))
$checkDups.Visible = $showM    # Теперь зависит от ключа -m
$checkDups.Anchor = 'Bottom, Left'; $checkDups.AutoSize = $true
$form.Controls.Add($checkDups)

#$checkDups = New-Object System.Windows.Forms.CheckBox
#$checkDups.Text = "Mark Old"; $checkDups.Location = New-Object System.Drawing.Point($dupX, [int]($baseY - 6))
#$checkDups.Anchor = 'Bottom, Left'; $checkDups.AutoSize = $true
#$form.Controls.Add($checkDups)

$checkInstall = New-Object System.Windows.Forms.CheckBox
$checkInstall.Text = "Install Mode"; $checkInstall.Location = New-Object System.Drawing.Point($privX, [int]($baseY - 6))
$checkInstall.Visible = $showC1; $checkInstall.Anchor = 'Bottom, Left'; $checkInstall.AutoSize = $true
$form.Controls.Add($checkInstall)

$checkExtra = New-Object System.Windows.Forms.CheckBox
$checkExtra.Text = "Extra Flag"; $checkExtra.Location = New-Object System.Drawing.Point($privX, [int]($baseY + 16))
$checkExtra.Visible = $showC2; $checkExtra.Anchor = 'Bottom, Left'; $checkExtra.AutoSize = $true
$form.Controls.Add($checkExtra)

# --- Logic: Duplicates ---
$updateDups = {
    if ($checkDups.Checked) {
        $latest = @{}
        if ($useDate) {
            foreach($r in $grid.Rows) {
                $n = $r.Cells["Name"].Value; $dt = Try-ParseDateTime($r.Cells["Date"].Value)
                if (-not $latest.ContainsKey($n) -or $dt -gt $latest[$n]) { $latest[$n] = $dt }
            }
            foreach($r in $grid.Rows) {
                $n = $r.Cells["Name"].Value; $dt = Try-ParseDateTime($r.Cells["Date"].Value)
                if ($dt -lt $latest[$n]) { $r.DefaultCellStyle.ForeColor = [System.Drawing.Color]::DarkGray }
            }
        }
    } else {
        foreach($r in $grid.Rows) { $isMiss = ($data[$r.Index].IsMissing)
            $r.DefaultCellStyle.ForeColor = if($isMiss){[System.Drawing.Color]::Blue}else{[System.Drawing.Color]::Black} }
    }
}
$checkDups.Add_CheckedChanged($updateDups)

# --- Logic: Clipboard with Row-Relative Tooltip ---
$copyToClipboard = {
    if ($grid.CurrentCell -and $grid.CurrentCell.Value) {
        $val = $grid.CurrentCell.Value.ToString()
        for ($i=0; $i -lt 3; $i++) {
            try { 
                [System.Windows.Forms.Clipboard]::SetText($val)
                $rect = $grid.GetCellDisplayRectangle($grid.CurrentCell.ColumnIndex, $grid.CurrentCell.RowIndex, $false)
                $copyTip.Show("Copied!", $grid, [int]($rect.X + ($rect.Width/2)), [int]($rect.Y), 1000)
                break 
            } catch { Start-Sleep -Milliseconds 100 }
        }
    }
}
$grid.Add_CellDoubleClick($copyToClipboard)
$grid.Add_KeyDown({ param($s,$e) if($e.Control -and $e.KeyCode -eq 'C'){$copyToClipboard.Invoke()} })

# Grid Management
$grid.add_CurrentCellDirtyStateChanged({ if ($grid.IsCurrentCellDirty) { $grid.CommitEdit(2) } })
$grid.add_CellValueChanged({
    param($s,$e)
    if($e.ColumnIndex -eq 0) {
        $row = $grid.Rows[$e.RowIndex]
        if ($singleMode -and $row.Cells[0].Value -eq $true) {
            foreach ($r in $grid.Rows) { if ($r.Index -ne $row.Index) { $r.Cells[0].Value = $false } }
        }
        $row.DefaultCellStyle.BackColor = if($row.Cells[0].Value){[System.Drawing.Color]::LightGreen}else{[System.Drawing.Color]::White}
    }
})

# Search Management
$searchBox.Add_TextChanged({
    $f = $searchBox.Text.ToLower(); $inv = $f.StartsWith("!"); if($inv){$f=$f.Substring(1)}; $grid.CurrentCell = $null
    foreach($r in $grid.Rows){
        $n = ($r.Cells["Name"].Value.ToString().ToLower()); $p = ($r.Cells["Package"].Value.ToString().ToLower())
        $match = ($f -eq "") -or ($n -like "*$f*") -or ($p -like "*$f*")
        $r.Visible = if($inv -and $f -ne ""){-not $match}else{$match}
    }
})

# --- Buttons & Export Logic ---
$btnSize = New-Object System.Drawing.Size(110, 35)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "Confirm"; $okButton.Location = New-Object System.Drawing.Point(10, $baseY); $okButton.Size = $btnSize; $okButton.Anchor = 'Bottom, Left'

$confirmAction = {
    $selectedRows = $grid.Rows | Where-Object { $_.Cells[0].Value -eq $true }
    if ($selectedRows) {

#        if ($outCsv -or $outCsvQuote) {
#            $header = if($outCsvQuote) { 'Date,Name,Package,FullPath' } else { 'Date,Name,Package,FullPath' }
#            $content = $selectedRows | ForEach-Object {
#                $d = if($useDate){$_.Cells["Date"].Value}else{""}; $n = $_.Cells['Name'].Value; $p = $_.Cells['Package'].Value; $path = $_.Cells['FullPath'].Value
#                if ($outCsvQuote) { """$d"",""$n"",""$p"",""$path""" } else { "$d,$n,$p,$path" }
#            }
#            [System.IO.File]::WriteAllLines($outputFile, @($header) + $content)
#        }
if ($outCsv -or $outCsvQuote) {
            # Формируем только контент, без переменной $header
            $content = $selectedRows | ForEach-Object {
                $d = if($useDate){$_.Cells["Date"].Value}else{""}
                $n = $_.Cells['Name'].Value
                $p = $_.Cells['Package'].Value
                $path = $_.Cells['FullPath'].Value
                
                if ($outCsvQuote) {
                    """$d"",""$n"",""$p"",""$path"""
                } else {
                    "$d,$n,$p,$path"
                }
            }
            # Сохраняем только массив $content
            [System.IO.File]::WriteAllLines($outputFile, $content)
        }
        elseif ($outOnlyPackage) {
            $content = $selectedRows | ForEach-Object { $_.Cells["Package"].Value }
            [System.IO.File]::WriteAllLines($outputFile, $content)
        }
        elseif ($outFixedTxt) {
            $content = $selectedRows | ForEach-Object {
                $d = if($useDate){$_.Cells["Date"].Value}else{"N/A"}
                "Date: $d, Name: $($_.Cells['Name'].Value), Package: $($_.Cells['Package'].Value)"
            }
            [System.IO.File]::WriteAllLines($outputFile, $content)
        }
        else { # Default (-a)
            $content = $selectedRows | ForEach-Object {
                $d = if($useDate){$_.Cells["Date"].Value}else{""}
                "$d;$($_.Cells['Name'].Value);$($_.Cells['Package'].Value);$($_.Cells['FullPath'].Value)".Trim(';').Replace(';;',';')
            }
            [System.IO.File]::WriteAllLines($outputFile, $content)
        }
    }

    if($showC1){ if($checkInstall.Checked){New-Item "install.flag" -Force | Out-Null}else{if(Test-Path "install.flag"){Remove-Item "install.flag"}} }
    if($showC2){ if($checkExtra.Checked){New-Item "extra.flag" -Force | Out-Null}else{if(Test-Path "extra.flag"){Remove-Item "extra.flag"}} }
    $form.Close()
}
$okButton.Add_Click($confirmAction)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"; $cancelButton.Location = New-Object System.Drawing.Point(130, $baseY); $cancelButton.Size = $btnSize; $cancelButton.Anchor = 'Bottom, Left'
$cancelButton.Add_Click({ $form.Close() })

$selectAllButton = New-Object System.Windows.Forms.Button
$selectAllButton.Text = "Select All"; $selectAllButton.Location = New-Object System.Drawing.Point(250, $baseY); $selectAllButton.Size = $btnSize; $selectAllButton.Anchor = 'Bottom, Left'
$selectAllButton.Visible = -not $singleMode
$selectAllButton.Add_Click({ foreach($r in $grid.Rows){if($r.Visible){$r.Cells[0].Value=$true}} })

$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Clear All"; $clearButton.Location = New-Object System.Drawing.Point(370, $baseY); $clearButton.Size = $btnSize; $clearButton.Anchor = 'Bottom, Left'
$clearButton.Visible = -not $singleMode
$clearButton.Add_Click({ foreach($r in $grid.Rows){if($r.Visible){$r.Cells[0].Value=$false}} })

$form.Controls.AddRange(@($okButton, $cancelButton, $selectAllButton, $clearButton))

if ($useDate) {
    $hideBtn = New-Object System.Windows.Forms.Button
    $hideBtn.Text = "Show Latest Only"; $hideBtn.Location = New-Object System.Drawing.Point(490, $baseY); $hideBtn.Size = New-Object System.Drawing.Size(135, 35); $hideBtn.Anchor = 'Bottom, Left'
    $hideBtn.Add_Click({
        $grid.CurrentCell = $null
        if($hideBtn.Text -eq "Show Latest Only"){
            $lt=@{}; foreach($r in $grid.Rows){$n=$r.Cells["Name"].Value;$dt=Try-ParseDateTime($r.Cells["Date"].Value)
            if(-not $lt.ContainsKey($n) -or $dt -gt $lt[$n].D){$lt[$n]=@{R=$r;D=$dt}}}
            foreach($r in $grid.Rows){$r.Visible=$false}; foreach($e in $lt.Values){$e.R.Visible=$true}
            $hideBtn.Text = "Show All"
        } else { foreach($r in $grid.Rows){$r.Visible=$true}; $hideBtn.Text = "Show Latest Only" }
    })
    $form.Controls.Add($hideBtn)
}

# --- Global Hotkeys ---
$form.Add_KeyDown({
    param($s, $e)
    if ($e.KeyCode -eq 'Enter') { $confirmAction.Invoke() }
    if ($e.KeyCode -eq 'Escape') { $form.Close() }
})

$form.Add_Shown({ $searchBox.Focus() })
[void]$form.ShowDialog()