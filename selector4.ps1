<#
================================================================================
Selector4.ps1 - интерактивный выбор приложений / бэкапов

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
    • Search: фильтр по всем колонкам (Date, Name, Package, FullPath)
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
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$inputFile = $args[0]
$outputFile = $args[1]
$mode = if ($args.Count -ge 3) { $args | Where-Object { $_ -match "^-.*" } | Select-Object -First 1 } else { "-a" }
$useDate = $mode -eq "-d"
$useFullPath = $args -contains "-f"

if (-not (Test-Path $inputFile)) {
    [System.Windows.Forms.MessageBox]::Show("Input file not found:`n$inputFile", "Error")
    exit
}

# helper: try parse date string into [datetime], return $null on failure
function Try-ParseDateTime {
    param([string]$s)

    if (-not $s) { return $null }

    $formats = @(
        "dd.MM.yyyy HH:mm",
        "dd.MM.yyyy",
        "yyyy-MM-dd HH:mm",
        "yyyy-MM-dd",
        "dd.MM.yyyy H:mm",
        "d.M.yyyy H:mm"
    )

    foreach ($fmt in $formats) {
        try {
            $parsed = [datetime]::ParseExact($s, $fmt, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None)
            return $parsed
        } catch {}
    }

    try { return [datetime]::Parse($s, [System.Globalization.CultureInfo]::InvariantCulture) } catch {}
    try { return [datetime]::Parse($s) } catch {}
    return $null
}

# === Parse input file ===
$data = Get-Content $inputFile | Where-Object { $_.Trim() -ne "" } | ForEach-Object {
    $line = $_.Trim()
    $date = ""
    $name = ""
    $package = ""
    $fullPath = ""
    $isMissing = $false

    # всегда пытаемся прочитать FullPath, если он есть
    $cols = $line -split ';'
    if ($useDate -and $cols.Count -ge 3) {
        $date = $cols[0].Trim()
        $name = $cols[1].Trim()
        $package = $cols[2].Trim()
        if ($cols.Count -ge 4) { $fullPath = $cols[3].Trim() }
    } elseif ($cols.Count -ge 2) {
        $name = $cols[0].Trim()
        $package = $cols[1].Trim()
        # в некоторых вариантах третья/четвёртая колонка может быть FullPath — берем её если есть
        if ($cols.Count -ge 3) { $fullPath = $cols[2].Trim() }
        if ($cols.Count -ge 4 -and [string]::IsNullOrWhiteSpace($fullPath)) { $fullPath = $cols[3].Trim() }
    } elseif ($cols.Count -eq 1) {
        $name = ""
        $package = $cols[0].Trim()
    }

    if ($name -match '^\s*##') {
        $isMissing = $true
        $name = ($name -replace '^\s*##', '').Trim()
    }

    if ($package -and $package -ne "") {
        [PSCustomObject]@{
            Date      = $date
            Name      = $name
            Package   = $package
            FullPath  = $fullPath
            IsMissing = $isMissing
        }
    }
} | Where-Object { $_ -ne $null } | Sort-Object Date,Name,Package -Unique

# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "App Selection"
$form.Size = New-Object System.Drawing.Size(720, 620)
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.MinimumSize = New-Object System.Drawing.Size(500, 400)

# Label "Search:"
$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Text = "Search:"
$searchLabel.Location = New-Object System.Drawing.Point(10, 10)
$searchLabel.Size = New-Object System.Drawing.Size(60, 25)
$searchLabel.TextAlign = 'MiddleLeft'
$form.Controls.Add($searchLabel)

# Search box
$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(75, 10)
$searchBox.Size = New-Object System.Drawing.Size(620, 30)
$searchBox.Anchor = 'Top, Left, Right'
$form.Controls.Add($searchBox)

# Grid
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object System.Drawing.Point(10, 50)
$grid.Size = New-Object System.Drawing.Size(680, 460)
$grid.Anchor = 'Top, Left, Right, Bottom'
$grid.SelectionMode = 'FullRowSelect'
$grid.MultiSelect = $false
$grid.ReadOnly = $false
$grid.AutoGenerateColumns = $false
$grid.RowHeadersVisible = $false
$grid.AllowUserToResizeColumns = $true
$grid.AllowUserToResizeRows = $false
$grid.RowTemplate.Height = 25
$grid.ScrollBars = 'Vertical'
$grid.AllowUserToAddRows = $false
$form.Controls.Add($grid)

# Checkbox column
$checkCol = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$checkCol.Name = "Selected"
$checkCol.HeaderText = ""
$checkCol.Width = 30
$checkCol.ReadOnly = $false
$grid.Columns.Add($checkCol) | Out-Null

# Date column
if ($useDate) {
    $dateCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $dateCol.Name = "Date"
    $dateCol.HeaderText = "Date"
    $dateCol.AutoSizeMode = 'Fill'
    $dateCol.ReadOnly = $true
    $dateCol.ValueType = [datetime]
    $dateCol.SortMode = [System.Windows.Forms.DataGridViewColumnSortMode]::Automatic
    $grid.Columns.Add($dateCol) | Out-Null
}

# Name column
$nameCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$nameCol.Name = "Name"
$nameCol.HeaderText = "App Name"
$nameCol.AutoSizeMode = 'Fill'
$nameCol.ReadOnly = $true
$grid.Columns.Add($nameCol) | Out-Null

# Package column
$pkgCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$pkgCol.Name = "Package"
$pkgCol.HeaderText = "Package"
$pkgCol.AutoSizeMode = 'Fill'
$pkgCol.ReadOnly = $true
$grid.Columns.Add($pkgCol) | Out-Null

# FullPath column — создаём всегда, но видимость зависит от -f
$fpCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$fpCol.Name = "FullPath"
$fpCol.HeaderText = "Full Path"
$fpCol.AutoSizeMode = 'Fill'
$fpCol.ReadOnly = $true
$fpCol.Visible = $useFullPath
$grid.Columns.Add($fpCol) | Out-Null

# Enable sorting
foreach ($col in $grid.Columns) {
    if ($col.Name -ne "Selected") { $col.SortMode = "Automatic" }
}

# Fill rows
foreach ($item in $data) {
    $index = $grid.Rows.Add()
    $row = $grid.Rows[$index]
    $row.Cells["Selected"].Value = $false

    if ($useDate) {
        $dt = Try-ParseDateTime $item.Date
        if ($dt) {
            $row.Cells["Date"].Value = $dt
            $row.Cells["Date"].Style.Format = "dd.MM.yyyy HH:mm"
        } else {
            $row.Cells["Date"].Value = $item.Date
        }
    }

    $row.Cells["Name"].Value = $item.Name
    $row.Cells["Package"].Value = $item.Package
    # пишем FullPath (значение может быть пустым) — ячейка существует всегда
    $row.Cells["FullPath"].Value = $item.FullPath

    foreach ($cell in $row.Cells) { $cell.Style.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold); $cell.Style.BackColor = [System.Drawing.Color]::White }

    if ($item.IsMissing) { foreach ($cell in $row.Cells) { $cell.Style.ForeColor = [System.Drawing.Color]::Blue }; $row.Tag = "Missing" }
    else { foreach ($cell in $row.Cells) { $cell.Style.ForeColor = [System.Drawing.Color]::Black }; $row.Tag = $null }
}

# Highlight selected rows
$grid.add_CurrentCellDirtyStateChanged({ if ($grid.IsCurrentCellDirty) { $grid.CommitEdit([System.Windows.Forms.DataGridViewDataErrorContexts]::Commit) } })
$grid.add_CellValueChanged({
    param($sender, $e)
    if ($e.ColumnIndex -eq $grid.Columns["Selected"].Index) {
        $row = $grid.Rows[$e.RowIndex]
        $bg = if ($row.Cells["Selected"].Value) { [System.Drawing.Color]::LightGreen } else { [System.Drawing.Color]::White }
        foreach ($cell in $row.Cells) { $cell.Style.BackColor = $bg }
    }
})

# Copy by double click or Ctrl+C
$grid.add_CellDoubleClick({
    param($sender, $e)
    if ($e.RowIndex -ge 0 -and $e.ColumnIndex -ge 0) {
        $colName = $grid.Columns[$e.ColumnIndex].Name
        if ($colName -in @("Name","Package","FullPath")) {
            $value = $grid.Rows[$e.RowIndex].Cells[$e.ColumnIndex].Value
            if ($value) { [System.Windows.Forms.Clipboard]::SetText($value.ToString()) }
        }
    }
})

$grid.add_KeyDown({
    param($sender,$e)
    if ($e.Control -and $e.KeyCode -eq [System.Windows.Forms.Keys]::C) {
        if ($grid.CurrentCell -and $grid.CurrentCell.Value) { [System.Windows.Forms.Clipboard]::SetText($grid.CurrentCell.Value.ToString()) }
    }
})

# Form shown/resize
$form.Add_Shown({ $grid.ClearSelection(); $form.Activate(); $form.ActiveControl = $searchBox })
$form.Add_Resize({ $grid.Width = $form.ClientSize.Width - 20; $grid.Height = $form.ClientSize.Height - 120; $searchBox.Width = $form.ClientSize.Width - 20 })

# Search filter
$searchBox.Add_TextChanged({
    $filter = $searchBox.Text.ToLower()
    foreach ($row in $grid.Rows) {
        $row.Visible = $filter -eq "" -or ($useDate -and $row.Cells["Date"].Value.ToString().ToLower() -like "*$filter*") -or
                                  ($row.Cells["Name"].Value.ToString().ToLower() -like "*$filter*") -or
                                  ($row.Cells["Package"].Value.ToString().ToLower() -like "*$filter*") -or
                                  ($useFullPath -and $row.Cells["FullPath"].Value.ToString().ToLower() -like "*$filter*")
    }
})

# Buttons: Confirm, Cancel, Select All, Clear All
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "Confirm"
$okButton.Location = New-Object System.Drawing.Point(10,520)
$okButton.Size = New-Object System.Drawing.Size(110,40)
$okButton.Anchor = 'Bottom, Left'
$okButton.Add_Click({
    $selectedLines = @()
    $csvObjects = @()
    $fixedWidth = 30
    foreach ($row in $grid.Rows) {
        if ($row.Cells["Selected"].Value -eq $true) {
            $date = if ($useDate) { $row.Cells["Date"].Value } else { "" }
            $name = $row.Cells["Name"].Value
            $pkg = $row.Cells["Package"].Value
            # всегда читаем значение FullPath из ячейки (даже если колонка скрыта)
            $fp = $row.Cells["FullPath"].Value

            if ($pkg -and $pkg.Trim() -ne "") {
                switch ($mode) {
                    "-p" { $selectedLines += "$pkg" }

#                    "-txt" { $selectedLines += ("{0,-$fixedWidth}{1}{2}" -f $date,$name,$pkg) }

"-txt" {
    if ($useDate) {
        if ($fp -and $fp.Trim() -ne "") {
            $selectedLines += "{0};{1};{2};{3}" -f $date,$name,$pkg,$fp
        } else {
            $selectedLines += "{0};{1};{2}" -f $date,$name,$pkg
        }
    } else {
        if ($fp -and $fp.Trim() -ne "") {
            $selectedLines += "{0};{1};{2}" -f $name,$pkg,$fp
        } else {
            $selectedLines += "{0};{1}" -f $name,$pkg
        }
    }
}




                    "-csv" { 
                        $csvObj = if ($useDate) { [PSCustomObject]@{ Date=$date; Name=$name; Package=$pkg; FullPath=$fp } } 
                                  else { [PSCustomObject]@{ Name=$name; Package=$pkg; FullPath=$fp } }
                        $csvObjects += $csvObj
                    }
                    default { 
                        # если есть полный путь, включаем его в выходную строку; иначе — стандартный формат
                        if ($useDate) {
                            if ($fp -and $fp.Trim() -ne "") { $selectedLines += "{0};{1};{2};{3}" -f $date,$name,$pkg,$fp }
                            else { $selectedLines += "{0};{1};{2}" -f $date,$name,$pkg }
                        } else {
                            if ($fp -and $fp.Trim() -ne "") { $selectedLines += "{0};{1};{2}" -f $name,$pkg,$fp }
                            else { $selectedLines += "{0};{1}" -f $name,$pkg }
                        }
                    }
                }
            }
        }
    }
    if ($mode -eq "-csv" -and $csvObjects.Count -gt 0) {
        $csvObjects | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
    } elseif ($selectedLines.Count -gt 0) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllLines($outputFile, $selectedLines, $utf8NoBom)
    }
    $form.Close()
})

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Location = New-Object System.Drawing.Point(130,520)
$cancelButton.Size = New-Object System.Drawing.Size(110,40)
$cancelButton.Anchor = 'Bottom, Left'
$cancelButton.Add_Click({ $form.Close() })

$selectAllButton = New-Object System.Windows.Forms.Button
$selectAllButton.Text = "Select All"
$selectAllButton.Location = New-Object System.Drawing.Point(250,520)
$selectAllButton.Size = New-Object System.Drawing.Size(110,40)
$selectAllButton.Anchor = 'Bottom, Left'
$selectAllButton.Add_Click({ foreach ($row in $grid.Rows) { if ($row.Visible) { $row.Cells["Selected"].Value = $true } } })

$clearSelectionButton = New-Object System.Windows.Forms.Button
$clearSelectionButton.Text = "Clear All"
$clearSelectionButton.Location = New-Object System.Drawing.Point(370,520)
$clearSelectionButton.Size = New-Object System.Drawing.Size(110,40)
$clearSelectionButton.Anchor = 'Bottom, Left'
$clearSelectionButton.Add_Click({ foreach ($row in $grid.Rows) { if ($row.Visible) { $row.Cells["Selected"].Value = $false } } })

$form.Controls.AddRange(@($okButton,$cancelButton,$selectAllButton,$clearSelectionButton))

# Show Latest Only / Show All
if ($useDate) {
    $hideOldButton = New-Object System.Windows.Forms.Button
    $hideOldButton.Text = "Show Latest Only"
    $hideOldButton.Location = New-Object System.Drawing.Point(490,520)
    $hideOldButton.Size = New-Object System.Drawing.Size(130,40)
    $hideOldButton.Anchor = 'Bottom, Left'
    $hideOldButton.Add_Click({
        if ($hideOldButton.Text -eq "Show Latest Only") {
            $latestDict = @{}
            foreach ($row in $grid.Rows) {
                $name = $row.Cells["Name"].Value
                $dateStr = $row.Cells["Date"].Value
                $date = if ($dateStr -is [datetime]) { $dateStr } else { Try-ParseDateTime ($dateStr.ToString()) }
                if (-not $latestDict.ContainsKey($name) -or $date -gt $latestDict[$name].Date) {
                    $latestDict[$name] = @{ Row=$row; Date=$date }
                }
            }
            foreach ($row in $grid.Rows) { $row.Visible = $false }
            $filter = $searchBox.Text.ToLower()
            foreach ($entry in $latestDict.Values) {
                $row = $entry.Row
                if ($filter -eq "" -or ($row.Cells["Date"].Value.ToString().ToLower() -like "*$filter*" -or
                                         $row.Cells["Name"].Value.ToString().ToLower() -like "*$filter*" -or
                                         $row.Cells["Package"].Value.ToString().ToLower() -like "*$filter*")) {
                    $row.Visible = $true
                }
            }
            $hideOldButton.Text = "Show All"
        } else {
            $filter = $searchBox.Text.ToLower()
            foreach ($row in $grid.Rows) {
                $row.Visible = $filter -eq "" -or ($row.Cells["Date"].Value.ToString().ToLower() -like "*$filter*" -or
                                                   $row.Cells["Name"].Value.ToString().ToLower() -like "*$filter*" -or
                                                   $row.Cells["Package"].Value.ToString().ToLower() -like "*$filter*")
            }
            $hideOldButton.Text = "Show Latest Only"
        }
    })
    $form.Controls.Add($hideOldButton)
}

[void]$form.ShowDialog()
