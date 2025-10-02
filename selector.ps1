# Script name: selector.ps1
# Использование:
# powershell script.ps1 input.txt output.txt -p    :: только пакеты в файл
# powershell script.ps1 input.txt output.txt -a    :: имя + пакет (по умолчанию, через ;)
# powershell script.ps1 input.txt output.txt -o    :: разрешает ставить только одну галку при выборе приложений
# powershell script.ps1 input.txt output.txt -txt  :: имя приложения + фиксированная ширина + пакет
# powershell script.ps1 input.txt output.csv -csv  :: сохранить в CSV: Name, Package
# $fixedWidth = 30   # ширина имени (первой колонки или отступа для второй) для txt



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$inputFile = $args[0]
$outputFile = $args[1]
$mode = if ($args.Count -ge 3) { $args[2] } else { "-a" }

if (-not (Test-Path $inputFile)) {
    [System.Windows.Forms.MessageBox]::Show("Input file not found:`n$inputFile", "Error")
    exit
}

$data = Get-Content $inputFile | Where-Object { $_.Trim() -ne "" } | ForEach-Object {
    if ($_ -match '^app\s*(.*?);(.*)$') {
        $name = $matches[1].Trim()
        $package = $matches[2].Trim()
        if ($package -ne "") {
            [PSCustomObject]@{
                Name = $name
                Package = $package
            }
        }
    }
} | Where-Object { $_ -ne $null } | Sort-Object Name,Package -Unique

$form = New-Object System.Windows.Forms.Form
$form.Text = "App Selection"
$form.Size = New-Object System.Drawing.Size(600, 600)
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.MinimumSize = New-Object System.Drawing.Size(400, 400)

# Label "Search:"
$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Text = "Search:"
$searchLabel.Location = New-Object System.Drawing.Point(10, 14)
$searchLabel.Size = New-Object System.Drawing.Size(60, 20)
$searchLabel.TextAlign = 'MiddleLeft'
$form.Controls.Add($searchLabel)

# Search box
$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(75, 10)
$searchBox.Size = New-Object System.Drawing.Size(495, 30)
$searchBox.Anchor = 'Top, Left, Right'
$form.Controls.Add($searchBox)

$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object System.Drawing.Point(10, 50)
$grid.Size = New-Object System.Drawing.Size(560, 440)
$grid.Anchor = 'Top, Left, Right, Bottom'
$grid.SelectionMode = 'FullRowSelect'
$grid.MultiSelect = $false
$grid.ReadOnly = $false
$grid.AutoGenerateColumns = $false
$grid.RowHeadersVisible = $false
$grid.AllowUserToResizeColumns = $false
$grid.AllowUserToResizeRows = $false
$grid.RowTemplate.Height = 25
$grid.ScrollBars = 'Vertical'
$grid.AllowUserToAddRows = $false
$form.Controls.Add($grid)

# Add checkbox column
$checkCol = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$checkCol.Name = "Selected"
$checkCol.HeaderText = ""
$checkCol.Width = 30
$checkCol.ReadOnly = $false
$grid.Columns.Add($checkCol) | Out-Null

# Add Name and Package columns (read-only)
$nameCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$nameCol.Name = "Name"
$nameCol.HeaderText = "Name"
$nameCol.AutoSizeMode = 'Fill'
$nameCol.ReadOnly = $true
$grid.Columns.Add($nameCol) | Out-Null

$pkgCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$pkgCol.Name = "Package"
$pkgCol.HeaderText = "Package"
$pkgCol.AutoSizeMode = 'Fill'
$pkgCol.ReadOnly = $true
$grid.Columns.Add($pkgCol) | Out-Null

# Add rows with bold font
foreach ($item in $data) {
    $index = $grid.Rows.Add()
    $row = $grid.Rows[$index]
    $row.Cells["Selected"].Value = $false
    $row.Cells["Name"].Value = $item.Name
    $row.Cells["Package"].Value = $item.Package

    foreach ($cell in $row.Cells) {
        $cell.Style.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    }
}

# Highlight rows when checkbox is selected
$grid.add_CurrentCellDirtyStateChanged({
    if ($grid.IsCurrentCellDirty) {
        $grid.CommitEdit([System.Windows.Forms.DataGridViewDataErrorContexts]::Commit)
    }
})

$grid.add_CellValueChanged({
    param($sender, $e)
    if ($e.ColumnIndex -eq $grid.Columns["Selected"].Index) {
        $row = $grid.Rows[$e.RowIndex]
        $isSelected = $row.Cells["Selected"].Value

        if ($isSelected) {
            if ($mode -eq "-o") {
                foreach ($otherRow in $grid.Rows) {
                    if ($otherRow.Index -ne $e.RowIndex) {
                        $otherRow.Cells["Selected"].Value = $false
                        foreach ($cell in $otherRow.Cells) {
                            $cell.Style.BackColor = [System.Drawing.Color]::White
                        }
                    }
                }
            }
            foreach ($cell in $row.Cells) {
                $cell.Style.BackColor = [System.Drawing.Color]::LightGreen
            }
        } else {
            foreach ($cell in $row.Cells) {
                $cell.Style.BackColor = [System.Drawing.Color]::White
            }
        }
    }
})

# === Copy text by double click ===
$grid.add_CellDoubleClick({
    param($sender, $e)
    if ($e.RowIndex -ge 0 -and $e.ColumnIndex -ge 0) {
        $colName = $grid.Columns[$e.ColumnIndex].Name
        if ($colName -eq "Name" -or $colName -eq "Package") {
            $value = $grid.Rows[$e.RowIndex].Cells[$e.ColumnIndex].Value
            if ($value) {
                [System.Windows.Forms.Clipboard]::SetText($value.ToString())
                [System.Windows.Forms.ToolTip]::new().Show(
                    "Copied: $value", $form, $form.PointToClient([System.Windows.Forms.Cursor]::Position), 1500
                )
            }
        }
    }
})

# === Copy text by Ctrl+C ===
$grid.add_KeyDown({
    param($sender, $e)
    if ($e.Control -and $e.KeyCode -eq [System.Windows.Forms.Keys]::C) {
        if ($grid.CurrentCell -and $grid.CurrentCell.Value) {
            $value = $grid.CurrentCell.Value.ToString()
            [System.Windows.Forms.Clipboard]::SetText($value)
            [System.Windows.Forms.ToolTip]::new().Show(
                "Copied: $value", $form, $form.PointToClient([System.Windows.Forms.Cursor]::Position), 1500
            )
        }
    }
})

$form.Add_Shown({
    $grid.ClearSelection()
    $form.Activate()
    $form.ActiveControl = $searchBox
})

$form.Add_Resize({
    $grid.Width = $form.ClientSize.Width - 20
    $grid.Height = $form.ClientSize.Height - 120
    $searchBox.Width = $form.ClientSize.Width - 20
})

$searchBox.Add_TextChanged({
    $filter = $searchBox.Text.ToLower()
    foreach ($row in $grid.Rows) {
        $visible = $true
        if ($filter -ne "") {
            $name = $row.Cells["Name"].Value.ToString().ToLower()
            $pkg = $row.Cells["Package"].Value.ToString().ToLower()
            $visible = ($name -like "*$filter*" -or $pkg -like "*$filter*")
        }
        $row.Visible = $visible
    }
})

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "Confirm"
$okButton.Location = New-Object System.Drawing.Point(10, 500)
$okButton.Size = New-Object System.Drawing.Size(110, 40)
$okButton.Anchor = 'Bottom, Left'
$okButton.Add_Click({
    $selectedLines = @()
    $csvObjects = @()
    $fixedWidth = 30   # width for txt mode
    foreach ($row in $grid.Rows) {
        if ($row.Cells["Selected"].Value -eq $true) {
            $name = $row.Cells["Name"].Value
            $pkg = $row.Cells["Package"].Value
            if ($pkg -and $pkg.Trim() -ne "") {
                switch ($mode) {
                    "-p"   { $selectedLines += "$pkg" }
                    "-txt" { $selectedLines += ("{0,-$fixedWidth}{1}" -f $name, $pkg) }
                    "-csv" { 
                        $csvObjects += [PSCustomObject]@{
                            Name    = $name
                            Package = $pkg
                        }
                    }
                    default { $selectedLines += ("{0};{1}" -f $name, $pkg) }
                }
            }
        }
    }
    if ($mode -eq "-csv" -and $csvObjects.Count -gt 0) {
        $csvObjects | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
    }
    elseif ($selectedLines.Count -gt 0) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllLines($outputFile, $selectedLines, $utf8NoBom)
    }
    $form.Close()
})

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Location = New-Object System.Drawing.Point(130, 500)
$cancelButton.Size = New-Object System.Drawing.Size(110, 40)
$cancelButton.Anchor = 'Bottom, Left'
$cancelButton.Add_Click({ $form.Close() })

$selectAllButton = New-Object System.Windows.Forms.Button
$selectAllButton.Text = "Select All"
$selectAllButton.Location = New-Object System.Drawing.Point(250, 500)
$selectAllButton.Size = New-Object System.Drawing.Size(110, 40)
$selectAllButton.Anchor = 'Bottom, Left'
$selectAllButton.Add_Click({
    foreach ($row in $grid.Rows) {
        $row.Cells["Selected"].Value = $true
    }
})

$clearSelectionButton = New-Object System.Windows.Forms.Button
$clearSelectionButton.Text = "Clear All"
$clearSelectionButton.Location = New-Object System.Drawing.Point(370, 500)
$clearSelectionButton.Size = New-Object System.Drawing.Size(110, 40)
$clearSelectionButton.Anchor = 'Bottom, Left'
$clearSelectionButton.Add_Click({
    foreach ($row in $grid.Rows) {
        $row.Cells["Selected"].Value = $false
    }
})

$form.Controls.Add($okButton)
$form.Controls.Add($cancelButton)
$form.Controls.Add($selectAllButton)
$form.Controls.Add($clearSelectionButton)

[void]$form.ShowDialog()
