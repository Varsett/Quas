<#
.SYNOPSIS
    Advanced App Selector with CMD integration and Flag-file support.
.DESCRIPTION
    $args[0] - Input File  : Text file (Date;Name;Package;Path)
    $args[1] - Output File : Path for saving results
    -d   Enable Date column (1st column is Date)
    -f   Show Full Path column
    -o   Single Mode (only one selection allowed)
    -m   Show "Mark Old" checkbox
    -c1  Show "Install" checkbox (creates install.flag)
    -c2  Show "Extract" checkbox (creates extra.flag)
    -p   Output: only package names
    -txt Output: fixed text format
    -csv Output: CSV comma-separated
    -csvq Output: CSV with double quotes
    (default) Output: semicolon-separated

Features:
    [tag] prefix in app name groups rows by color: [Games] Resident Evil 4
    ## prefix marks missing files (blue color, removed from display name)
    Search: all columns, ! = invert, /regex/ = regexp mode
    Selected count shown in window title
    Double-click or Ctrl+C copies cell to clipboard with tooltip
    Mark Old: dims older versions (requires -d)
    Show Latest Only: filters to newest per app (requires -d)
    12-color tag palette for visual grouping
    Dark/Light theme toggle

Changelog:
    25.02.26: Inverted search added
    26.02.26: Checkboxes, help button, -o flag, clipboard fix
    03.06.26: Full rewrite - tag colors, title counter, regexp search,
              row.Tag fix (no more index mismatch), date format fix in output,
              O(n) LatestDates, tooltip fix, New-FlatButton helper,
              theme init order fix, all if-in-method-arg bugs fixed
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$inputFile  = $args[0]
$outputFile = $args[1]
$allArgs    = $args

$useDate    = $allArgs -contains "-d"
$useFullPath= $allArgs -contains "-f"
$showC1     = $allArgs -contains "-c1"
$showC2     = $allArgs -contains "-c2"
$showM      = $allArgs -contains "-m"
$singleMode = $allArgs -contains "-o"

$outOnlyPackage = $allArgs -contains "-p"
$outFixedTxt    = $allArgs -contains "-txt"
$outCsv         = $allArgs -contains "-csv"
$outCsvQuote    = $allArgs -contains "-csvq"

if (-not (Test-Path $inputFile)) {
    [System.Windows.Forms.MessageBox]::Show("Input file not found:`n$inputFile", "Error")
    exit
}

# ================================================================
# UTILITY FUNCTIONS
# ================================================================

function Try-ParseDateTime {
    param([string]$s)
    if ([string]::IsNullOrWhiteSpace($s)) { return [datetime]::MinValue }
    $fmts = @("dd.MM.yyyy HH:mm","dd.MM.yyyy","yyyy-MM-dd HH:mm","yyyy-MM-dd","dd.MM.yyyy H:mm","d.M.yyyy H:mm")
    foreach ($fmt in $fmts) {
        try {
            return [datetime]::ParseExact($s, $fmt,
                [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None)
        } catch {}
    }
    return [datetime]::MinValue
}

function Format-DateValue {
    param($v)
    if ($v -is [datetime]) { return $v.ToString("dd.MM.yyyy HH:mm") }
    return [string]$v
}

# Parse [tag] prefix: "[Games] App Name" -> Tag="Games", CleanName="App Name"
function Parse-Tag {
    param([string]$name)
    if ($name -match '^\[([^\]]+)\]\s*(.*)$') {
        return @{ Tag = $matches[1]; CleanName = $matches[2].Trim() }
    }
    return @{ Tag = ""; CleanName = $name }
}

# ================================================================
# TAG COLOR PALETTE  (12 pairs light/dark)
# ================================================================
$script:tagPalette = @(
    @{ Light="#FFF9C4"; Dark="#4A4400" },
    @{ Light="#E1F5FE"; Dark="#003A52" },
    @{ Light="#F3E5F5"; Dark="#3A0047" },
    @{ Light="#E8F5E9"; Dark="#003D09" },
    @{ Light="#FBE9E7"; Dark="#4E1300" },
    @{ Light="#E0F7FA"; Dark="#003740" },
    @{ Light="#FCE4EC"; Dark="#4A0019" },
    @{ Light="#FFFDE7"; Dark="#4A3800" },
    @{ Light="#EDE7F6"; Dark="#1A004A" },
    @{ Light="#E0F2F1"; Dark="#003330" },
    @{ Light="#FFF3E0"; Dark="#4A2000" },
    @{ Light="#F9FBE7"; Dark="#2E3500" }
)
$script:tagColorMap = @{}

function Get-TagBgColor {
    param([string]$tag, [bool]$dark)
    if ([string]::IsNullOrEmpty($tag)) { return $null }
    if (-not $script:tagColorMap.ContainsKey($tag)) {
        $idx = $script:tagColorMap.Count % $script:tagPalette.Count
        $script:tagColorMap[$tag] = $idx
    }
    $p = $script:tagPalette[$script:tagColorMap[$tag]]
    $hex = if ($dark) { $p.Dark } else { $p.Light }
    return [System.Drawing.ColorTranslator]::FromHtml($hex)
}

# ================================================================
# DATA PARSING
# ================================================================
#$data = Get-Content $inputFile |
$data = Get-Content $inputFile -Encoding UTF8 |
    Where-Object { $_.Trim() -ne "" } |
    ForEach-Object {
        $line = $_.Trim()
        $date = ""; $name = ""; $package = ""; $fullPath = ""
        $isMissing = $false

        $cols = $line -split ';', 4

        if ($useDate -and $cols.Count -ge 3) {
            $date    = $cols[0].Trim()
            $name    = $cols[1].Trim()
            $package = $cols[2].Trim()
            if ($cols.Count -ge 4) { $fullPath = $cols[3].Trim() }
        } elseif ($cols.Count -ge 2) {
            $name    = $cols[0].Trim()
            $package = $cols[1].Trim()
            if ($cols.Count -ge 3) { $fullPath = $cols[2].Trim() }
        }

        if ($name -match '^\s*##') {
            $isMissing = $true
            $name = ($name -replace '^\s*##', '').Trim()
        }

        $tagInfo   = Parse-Tag $name
        $tag       = $tagInfo.Tag
        $cleanName = $tagInfo.CleanName

        if ($package) {
            [PSCustomObject]@{
                Date      = $date
                Name      = $cleanName
                Tag       = $tag
                Package   = $package
                FullPath  = $fullPath
                IsMissing = $isMissing
            }
        }
    } |
    Sort-Object @{Expression={ Try-ParseDateTime $_.Date }; Descending=$true}, Name -Unique

# ================================================================
# THEMES
# ================================================================
$script:isDark = $false

$darkTheme = @{
    WinBack    = "#1A1A1A"
    GridBack   = "#2D2D2D"
    HeaderBack = "#252525"
    SearchBack = "#2D2D2D"
    Text       = "#CCCCCC"
    Missing    = "#007ACC"
    Cursor     = "#014573"
    MarkedBack = "#013d05"
    SelFore    = "#CCCCCC"
}
$lightTheme = @{
    WinBack    = "WhiteSmoke"
    GridBack   = "#FFFBE6"
    HeaderBack = "#D0E0D0"
    SearchBack = "#E8F5E9"
    Text       = "Black"
    Missing    = "Blue"
    Cursor     = "#ADD8E6"
    MarkedBack = "#b9f0d0"
    SelFore    = "Black"
}

# ================================================================
# FORM
# ================================================================
$form = New-Object System.Windows.Forms.Form
$baseTitle = if ($singleMode) { "App Selection (Single Mode)" } else { "App Selection" }
$form.Text        = $baseTitle
$form.ClientSize  = New-Object System.Drawing.Size(1100, 800)
$form.StartPosition = "CenterScreen"
$form.Font        = New-Object System.Drawing.Font("Segoe UI", 10)
$form.KeyPreview  = $true

[int]$fWidth  = $form.ClientSize.Width
[int]$fHeight = $form.ClientSize.Height
[int]$baseY   = $fHeight - 50
[int]$dupX    = 760
[int]$privX   = 870

$copyTip = New-Object System.Windows.Forms.ToolTip
$copyTip.AutoPopDelay = 1500
$copyTip.InitialDelay = 0
$copyTip.ReshowDelay  = 0
$copyTip.IsBalloon    = $false

# ================================================================
# SEARCH BAR
# ================================================================
$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Text     = "Search:"
$searchLabel.Location = "10,15"
$searchLabel.Size     = "60,25"
$form.Controls.Add($searchLabel)

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = "75,12"
$searchBox.Width    = $fWidth - 130
$searchBox.Anchor   = 'Top,Left,Right'
$form.Controls.Add($searchBox)

# ================================================================
# HELP BUTTON
# ================================================================
$copyright = [char]0x00A9

# Левая колонка: интерфейс
$helpCol1 = @"
BUTTONS
  Confirm        Save selection and exit
  Cancel         Exit without saving
  Select All     Check all visible rows
  Clear All      Uncheck all visible rows
  Mark Selected  Check cursor-highlighted rows
                 (Shift+Click or Ctrl+Click)
  Show Latest    Newest backup per app only
                 (requires -d)
  Theme          Toggle Dark / Light mode

________________________________________________

SEARCH BAR
  Filters all columns: Date, Name, Package, FullPath

  text        Substring match (case-insensitive)
  !text       Invert: hide matches, show the rest
  /pattern/   Regular expression   e.g. /^game/
  /pattern/i  Regex, ignore case   e.g. /unity/i

________________________________________________

KEYBOARD SHORTCUTS
  Enter        Confirm and exit
  Escape       Close window
  Ctrl+C       Copy focused cell to clipboard
  Dbl-click    Copy cell to clipboard
               Tooltip confirms the copy
"@

# Правая колонка: аргументы и формат файла
$helpCol2 = @"
INPUT FILE  (semicolon-separated columns)
  Name;Package
  Name;Package;FullPath
  Date;Name;Package;FullPath   (-d)

  Name prefixes:
  ##Name    Blue row = file is missing
  [tag]     Color group, e.g. [Games] RE4
            Up to 12 distinct color groups

________________________________________________

COMMAND-LINE FLAGS
  -d    Date column (1st col in file)
  -f    Show Full Path column
  -o    Single-selection mode
  -m    Mark Old checkbox
  -c1   Install checkbox => install.flag
  -c2   Extract checkbox => extra.flag

________________________________________________

OUTPUT FORMAT  (mutually exclusive)
  -p      Package names only, one per line
  -txt    Date: ...  Name: ...  Package: ...
  -csv    Comma-separated
  -csvq   Comma-separated, quoted fields
  (none)  Date;Name;Package;FullPath

________________________________________________

SYNTAX
  .\selector5.ps1 <in> <out> [flags]

  .\selector5.ps1 apps.txt out.txt
  .\selector5.ps1 backups.txt out.txt -d -f -m
  .\selector5.ps1 list.txt out.txt -p -o
"@

# Кнопка ? открывает кастомную форму с двумя колонками
$helpBtn = New-Object System.Windows.Forms.Button
$helpBtn.Text      = "?"
$helpBtn.Location  = "$([int]($fWidth - 45)),11"
$helpBtn.Size      = "30,28"
$helpBtn.Anchor    = 'Top,Right'
$helpBtn.FlatStyle = "Flat"
$helpBtn.BackColor = [System.Drawing.Color]::LightGray
$helpBtn.Add_Click({
    $hForm = New-Object System.Windows.Forms.Form
    $hForm.Text          = "App Selector  |  Help  |  $copyright 2026 Varset Dev"
    $hForm.ClientSize    = New-Object System.Drawing.Size(820, 480)
    $hForm.StartPosition = "CenterParent"
    $hForm.FormBorderStyle = "FixedDialog"
    $hForm.MaximizeBox   = $false
    $hForm.MinimizeBox   = $false
    $hForm.Font          = New-Object System.Drawing.Font("Consolas", 9)
    $hForm.BackColor     = [System.Drawing.Color]::WhiteSmoke

    $rtbL = New-Object System.Windows.Forms.RichTextBox
    $rtbL.Location  = New-Object System.Drawing.Point(10, 10)
    $rtbL.Size      = New-Object System.Drawing.Size(390, 425)
    $rtbL.ReadOnly  = $true
    $rtbL.BorderStyle = "None"
    $rtbL.BackColor = [System.Drawing.Color]::WhiteSmoke
    $rtbL.Text      = $helpCol1
    $rtbL.ScrollBars = "None"

    $rtbR = New-Object System.Windows.Forms.RichTextBox
    $rtbR.Location  = New-Object System.Drawing.Point(415, 10)
    $rtbR.Size      = New-Object System.Drawing.Size(390, 425)
    $rtbR.ReadOnly  = $true
    $rtbR.BorderStyle = "None"
    $rtbR.BackColor = [System.Drawing.Color]::WhiteSmoke
    $rtbR.Text      = $helpCol2
    $rtbR.ScrollBars = "None"

    # Вертикальный разделитель
    $sep = New-Object System.Windows.Forms.Label
    $sep.Location  = New-Object System.Drawing.Point(406, 10)
    $sep.Size      = New-Object System.Drawing.Size(2, 425)
    $sep.BackColor = [System.Drawing.Color]::Silver

    # Жирный шрифт для заголовков секций
    $boldFont9 = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
    foreach ($rtb in @($rtbL, $rtbR)) {
        $rtb.SelectAll()
        $rtb.SelectionFont  = $rtb.Font
        $rtb.SelectionColor = [System.Drawing.Color]::Black
        # Выделяем заголовки (строки без ведущих пробелов, не разделители)
        $lines = $rtb.Text -split "`n"
        $pos = 0
        foreach ($line in $lines) {
            $len = $line.Length + 1
            if ($line.Trim() -ne "" -and $line -notmatch "^[\s_]" -and $line -notmatch "^\s") {
                $rtb.Select($pos, $line.TrimEnd().Length)
                $rtb.SelectionFont  = $boldFont9
                $rtb.SelectionColor = [System.Drawing.Color]::DarkSlateGray
            }
            $pos += $len
        }
        $rtb.SelectionStart = 0
    }

    $hForm.Controls.AddRange(@($rtbL, $sep, $rtbR))
    $hForm.KeyPreview = $true
    $hForm.Add_KeyDown({ param($s,$e) if($e.KeyCode -eq 'Escape'){ $hForm.Close() } })
    [void]$hForm.ShowDialog()
})
$form.Controls.Add($helpBtn)

# ================================================================
# GRID
# ================================================================
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location             = "10,50"
$grid.Width                = $fWidth - 25
$grid.Height               = $fHeight - 110
$grid.Anchor               = 'Top,Left,Right,Bottom'
$grid.SelectionMode        = 'FullRowSelect'
$grid.RowHeadersVisible    = $false
$grid.AllowUserToAddRows   = $false
$grid.AllowUserToResizeRows= $false
$grid.RowTemplate.Height   = 28
$grid.AutoSizeColumnsMode  = 'Fill'
$grid.BorderStyle          = "None"
$form.Controls.Add($grid)

# Columns
$chkCol = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$chkCol.Name = "Selected"; $chkCol.Width = 30
$chkCol.AutoSizeMode = 'None'; $chkCol.Resizable = 'False'
$null = $grid.Columns.Add($chkCol)

if ($useDate) {
    $dateCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $dateCol.Name = "Date"; $dateCol.HeaderText = "Date"; $dateCol.ReadOnly = $true
    $dateCol.ValueType = [System.DateTime]
    $dateCol.DefaultCellStyle.Format = "dd.MM.yyyy HH:mm"
    $null = $grid.Columns.Add($dateCol)
}

$nameCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$nameCol.Name = "Name"; $nameCol.HeaderText = "App Name"; $nameCol.ReadOnly = $true
$null = $grid.Columns.Add($nameCol)

$pkgCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$pkgCol.Name = "Package"; $pkgCol.HeaderText = "Package"; $pkgCol.ReadOnly = $true
$null = $grid.Columns.Add($pkgCol)

$pathCol = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$pathCol.Name = "FullPath"; $pathCol.HeaderText = "Full Path"
$pathCol.ReadOnly = $true; $pathCol.Visible = $useFullPath
$null = $grid.Columns.Add($pathCol)

# Populate rows - store $item in row.Tag to avoid index mismatch bug
$boldFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
foreach ($item in $data) {
    $idx = $grid.Rows.Add()
    $row = $grid.Rows[$idx]
    $row.Tag = $item
    if ($useDate) { $row.Cells["Date"].Value = Try-ParseDateTime $item.Date }
    $row.Cells["Name"].Value     = $item.Name
    $row.Cells["Package"].Value  = $item.Package
    $row.Cells["FullPath"].Value = $item.FullPath
    $row.DefaultCellStyle.Font  = $boldFont
}

# ================================================================
# CHECKBOXES  (created BEFORE Set-Theme so theme finds them)
# ================================================================
$checkDups = New-Object System.Windows.Forms.CheckBox
$checkDups.Text     = "Mark Old"
$checkDups.Location = "$dupX,$([int]($baseY - 5))"
$checkDups.Anchor   = 'Bottom,Left'
$checkDups.AutoSize = $true
$checkDups.Visible  = $showM
$form.Controls.Add($checkDups)

$checkInstall = New-Object System.Windows.Forms.CheckBox
$checkInstall.Text     = "Install"
$checkInstall.Location = "$privX,$([int]($baseY - 5))"
$checkInstall.Anchor   = 'Bottom,Left'
$checkInstall.AutoSize = $true
$checkInstall.Visible  = $showC1
$form.Controls.Add($checkInstall)

$checkExtra = New-Object System.Windows.Forms.CheckBox
$checkExtra.Text     = "Extract"
$checkExtra.Location = "$privX,$([int]($baseY + 15))"
$checkExtra.Anchor   = 'Bottom,Left'
$checkExtra.AutoSize = $true
$checkExtra.Visible  = $showC2
$form.Controls.Add($checkExtra)

# ================================================================
# ROW COLOR LOGIC
# ================================================================

# O(n) - compute once, pass as param to Update-RowColor
function Get-LatestDates {
    $lt = @{}
    if ($useDate) {
        foreach ($r in $grid.Rows) {
            $n   = [string]$r.Cells["Name"].Value
            $val = $r.Cells["Date"].Value
            $dt  = if ($val -is [datetime]) { $val } else { Try-ParseDateTime([string]$val) }
            if (-not $lt.ContainsKey($n) -or $dt -gt $lt[$n]) { $lt[$n] = $dt }
        }
    }
    return $lt
}

function Update-RowColor {
    param($row, $latestDates = $null)
    $theme  = if ($script:isDark) { $darkTheme } else { $lightTheme }
    $item   = $row.Tag
    $isMiss = if ($item) { $item.IsMissing } else { $false }
    $tag    = if ($item) { $item.Tag }       else { "" }

    # Background: checked > tag color > default
    if ($row.Cells[0].Value) {
        $row.DefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.MarkedBack)
    } else {
        $tagColor = Get-TagBgColor $tag $script:isDark
        if ($tagColor) {
            $row.DefaultCellStyle.BackColor = $tagColor
        } else {
            $row.DefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.GridBack)
        }
    }

    # Foreground
    if ($isMiss) {
        $row.DefaultCellStyle.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Missing)
    } elseif ($checkDups.Checked -and $useDate -and $latestDates) {
        $n  = [string]$row.Cells["Name"].Value
        $val = $row.Cells["Date"].Value
        $dt = if ($val -is [datetime]) { $val } else { Try-ParseDateTime([string]$val) }
        if ($latestDates.ContainsKey($n) -and $dt -lt $latestDates[$n]) {
            $row.DefaultCellStyle.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#909090")
        } else {
            $row.DefaultCellStyle.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
        }
    } else {
        $row.DefaultCellStyle.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    }

    # Checked row: keep text readable regardless of missing/old
    if ($row.Cells[0].Value -and -not $isMiss) {
        $row.DefaultCellStyle.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.SelFore)
    }
}

function Refresh-AllRowColors {
    $lt = Get-LatestDates
    foreach ($r in $grid.Rows) { Update-RowColor $r $lt }
}

$checkDups.Add_CheckedChanged({ Refresh-AllRowColors })

# ================================================================
# TITLE COUNTER
# ================================================================
function Update-Title {
    $total    = $grid.Rows.Count
    $selected = ($grid.Rows | Where-Object { $_.Cells[0].Value -eq $true }).Count
    $form.Text = "$baseTitle  |  Selected: $selected / $total"
}

# ================================================================
# THEME
# ================================================================
function Set-Theme {
    param([hashtable]$theme)

    $form.BackColor       = [System.Drawing.ColorTranslator]::FromHtml($theme.WinBack)
    $searchLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $searchBox.BackColor  = [System.Drawing.ColorTranslator]::FromHtml($theme.SearchBack)
    $searchBox.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)

    $grid.BackgroundColor = [System.Drawing.ColorTranslator]::FromHtml($theme.GridBack)
    $grid.RowsDefaultCellStyle.BackColor          = [System.Drawing.ColorTranslator]::FromHtml($theme.GridBack)
    $grid.RowsDefaultCellStyle.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $grid.RowsDefaultCellStyle.SelectionBackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Cursor)
    $grid.RowsDefaultCellStyle.SelectionForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.SelFore)

    $grid.EnableHeadersVisualStyles = $false
    $grid.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.HeaderBack)
    $grid.ColumnHeadersDefaultCellStyle.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)

    foreach ($ctrl in @($checkDups, $checkInstall, $checkExtra)) {
        if ($null -ne $ctrl) {
            $ctrl.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
        }
    }

    Refresh-AllRowColors
}

# ================================================================
# CLIPBOARD + TOOLTIP
# ================================================================
$copyToClipboard = {
    if ($null -ne $grid.CurrentCell -and $null -ne $grid.CurrentCell.Value) {
        $val    = $grid.CurrentCell.Value.ToString()
        $colIdx = $grid.CurrentCell.ColumnIndex
        $rowIdx = $grid.CurrentCell.RowIndex
        for ($i = 0; $i -lt 3; $i++) {
            try {
                [System.Windows.Forms.Clipboard]::SetText($val)
                # Переводим координаты ячейки в систему формы - надёжнее чем показывать на гриде
                $rect     = $grid.GetCellDisplayRectangle($colIdx, $rowIdx, $false)
                $gridPt   = New-Object System.Drawing.Point($rect.X, $rect.Y)
                $screenPt = $grid.PointToScreen($gridPt)
                $formPt   = $form.PointToClient($screenPt)
                $tipX     = [int]($formPt.X + $rect.Width / 2)
                $tipY     = [int]($formPt.Y - 22)
                # Hide сначала - иначе повторный Show может не сработать
                $copyTip.Hide($form)
                $copyTip.Show("  Copied!  ", $form, $tipX, $tipY, 1400)
                break
            } catch { Start-Sleep -Milliseconds 100 }
        }
    }
}

$grid.Add_CellDoubleClick($copyToClipboard)
$grid.Add_KeyDown({
    param($s, $e)
    if ($e.Control -and $e.KeyCode -eq 'C') {
        $e.Handled = $true
        $copyToClipboard.Invoke()
    }
})

# ================================================================
# GRID EVENTS
# ================================================================
$grid.Add_CurrentCellDirtyStateChanged({
    if ($grid.IsCurrentCellDirty) { $grid.CommitEdit(2) }
})

$grid.Add_CellValueChanged({
    param($s, $e)
    if ($e.ColumnIndex -eq 0) {
        $row = $grid.Rows[$e.RowIndex]
        if ($singleMode -and $row.Cells[0].Value) {
            foreach ($r in $grid.Rows) {
                if ($r.Index -ne $row.Index) { $r.Cells[0].Value = $false }
            }
        }
        $lt = Get-LatestDates
        Update-RowColor $row $lt
        Update-Title
    }
})

# ================================================================
# SEARCH  (all columns + ! invert + /regex/ mode)
# ================================================================
$searchBox.Add_TextChanged({
    $raw = $searchBox.Text
    $inv = $raw.StartsWith("!")
    $f   = if ($inv) { $raw.Substring(1) } else { $raw }

    $useRegex = $false
    $rx = $null
    if ($f -match '^/(.+)/([i]?)$') {
        $pat   = $matches[1]
        $flags = $matches[2]
        try {
            $rxOpts = [System.Text.RegularExpressions.RegexOptions]::None
            if ($flags -eq 'i') {
                $rxOpts = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
            }
            $rx = New-Object System.Text.RegularExpressions.Regex($pat, $rxOpts)
            $useRegex = $true
        } catch { $useRegex = $false }
    }

    $fLow = $f.ToLower()
    $grid.CurrentCell = $null

    foreach ($r in $grid.Rows) {
        # Collect all searchable values including Date and FullPath
        $vals = @(
            [string]$r.Cells["Name"].Value,
            [string]$r.Cells["Package"].Value,
            [string]$r.Cells["FullPath"].Value
        )
        if ($useDate) { $vals += (Format-DateValue $r.Cells["Date"].Value) }

        $match = ($f -eq "")
        if (-not $match) {
            if ($useRegex -and $null -ne $rx) {
                $match = ($vals | Where-Object { $rx.IsMatch($_) }).Count -gt 0
            } else {
                $match = ($vals | Where-Object { $_.ToLower() -like "*$fLow*" }).Count -gt 0
            }
        }
        $r.Visible = if ($inv -and $f -ne "") { -not $match } else { $match }
    }
})

# ================================================================
# CONFIRM / SAVE
# ================================================================
$confirmAction = {
    $selectedRows = @($grid.Rows | Where-Object { $_.Cells[0].Value -eq $true })

    if ($selectedRows.Count -gt 0) {
        $lines = @()

        if ($outCsv -or $outCsvQuote) {
            $lines = $selectedRows | ForEach-Object {
                $d    = if ($useDate) { Format-DateValue $_.Cells["Date"].Value } else { "" }
                $n    = [string]$_.Cells["Name"].Value
                $p    = [string]$_.Cells["Package"].Value
                $path = [string]$_.Cells["FullPath"].Value
                if ($outCsvQuote) { """$d"",""$n"",""$p"",""$path""" }
                else { "$d,$n,$p,$path" }
            }
        } elseif ($outOnlyPackage) {
            $lines = $selectedRows | ForEach-Object { [string]$_.Cells["Package"].Value }
        } elseif ($outFixedTxt) {
            $lines = $selectedRows | ForEach-Object {
                $d = if ($useDate) { Format-DateValue $_.Cells["Date"].Value } else { "N/A" }
                "Date: $d, Name: $($_.Cells['Name'].Value), Package: $($_.Cells['Package'].Value)"
            }
        } else {
            $lines = $selectedRows | ForEach-Object {
                $d    = if ($useDate) { Format-DateValue $_.Cells["Date"].Value } else { "" }
                $n    = [string]$_.Cells["Name"].Value
                $p    = [string]$_.Cells["Package"].Value
                $path = [string]$_.Cells["FullPath"].Value
                "$d;$n;$p;$path".Trim(';') -replace ';;', ';'
            }
        }

#        [System.IO.File]::WriteAllLines($outputFile, $lines)

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($outputFile, $lines, $utf8)

    }

    if ($showC1) {
        if ($checkInstall.Checked) { New-Item "install.flag" -Force | Out-Null }
        else { if (Test-Path "install.flag") { Remove-Item "install.flag" } }
    }
    if ($showC2) {
        if ($checkExtra.Checked) { New-Item "extra.flag" -Force | Out-Null }
        else { if (Test-Path "extra.flag") { Remove-Item "extra.flag" } }
    }

    $form.Close()
}

# ================================================================
# BUTTON HELPER
# ================================================================
function New-FlatButton {
    param(
        [string]$text,
        [int]$x, [int]$y,
        [int]$w = 110,
        [System.Drawing.Color]$color,
        [string]$anchor = 'Bottom,Left'
    )
    $b = New-Object System.Windows.Forms.Button
    $b.Text      = $text
    $b.Location  = New-Object System.Drawing.Point($x, $y)
    $b.Size      = New-Object System.Drawing.Size($w, 35)
    $b.FlatStyle = "Flat"
    $b.BackColor = $color
    $b.Anchor    = $anchor
    return $b
}

# ================================================================
# BUTTONS
# ================================================================
$okButton = New-FlatButton "Confirm" 10 $baseY -color ([System.Drawing.Color]::LightGreen)
$okButton.Add_Click($confirmAction)

$cancelButton = New-FlatButton "Cancel" 130 $baseY -color ([System.Drawing.Color]::LightBlue)
$cancelButton.Add_Click({ $form.Close() })

$selectAllButton = New-FlatButton "Select All" 250 $baseY -color ([System.Drawing.Color]::Lavender)
$selectAllButton.Visible = -not $singleMode
$selectAllButton.Add_Click({
    foreach ($r in $grid.Rows) { if ($r.Visible) { $r.Cells[0].Value = $true } }
    Update-Title
})

$clearButton = New-FlatButton "Clear All" 370 $baseY -color ([System.Drawing.Color]::Lavender)
$clearButton.Visible = -not $singleMode
$clearButton.Add_Click({
    foreach ($r in $grid.Rows) { if ($r.Visible) { $r.Cells[0].Value = $false } }
    Update-Title
})

$markFocusedBtn = New-FlatButton "Mark Selected" 490 $baseY -color ([System.Drawing.Color]::Azure)
$markFocusedBtn.Add_Click({
    foreach ($r in $grid.SelectedRows) { $r.Cells[0].Value = $true }
    Update-Title
})

# Theme button - note: no if() inside method args
$themeBtn = New-FlatButton "Theme" ([int]($fWidth - 125)) $baseY -color ([System.Drawing.Color]::DarkGray) -anchor 'Bottom,Right'
$themeBtn.Add_Click({
    $script:isDark = -not $script:isDark
    if ($script:isDark) {
        Set-Theme $darkTheme
    } else {
        Set-Theme $lightTheme
    }
})

$form.Controls.AddRange(@($okButton, $cancelButton, $selectAllButton, $clearButton, $markFocusedBtn, $themeBtn))

# Show Latest Only - only with -d
if ($useDate) {
    $hideBtn = New-FlatButton "Show Latest Only" 610 $baseY -w 135 -color ([System.Drawing.Color]::Azure)
    $hideBtn.Add_Click({
        $grid.CurrentCell = $null
        if ($hideBtn.Text -eq "Show Latest Only") {
            $lt = @{}
            foreach ($r in $grid.Rows) {
                $n   = [string]$r.Cells["Name"].Value
                $val = $r.Cells["Date"].Value
                $dt  = if ($val -is [datetime]) { $val } else { Try-ParseDateTime([string]$val) }
                if (-not $lt.ContainsKey($n) -or $dt -gt $lt[$n].D) {
                    $lt[$n] = @{ R = $r; D = $dt }
                }
            }
            foreach ($r in $grid.Rows) { $r.Visible = $false }
            foreach ($e in $lt.Values)  { $e.R.Visible = $true }
            $hideBtn.Text = "Show All"
        } else {
            foreach ($r in $grid.Rows) { $r.Visible = $true }
            $hideBtn.Text = "Show Latest Only"
        }
    })
    $form.Controls.Add($hideBtn)
}

# ================================================================
# HOTKEYS
# ================================================================
$form.Add_KeyDown({
    param($s, $e)
    if ($e.KeyCode -eq 'Enter')  { $confirmAction.Invoke() }
    if ($e.KeyCode -eq 'Escape') { $form.Close() }
})

# ================================================================
# STARTUP  - theme applied AFTER all controls exist
# ================================================================
Set-Theme $lightTheme
Update-Title

$form.Add_Shown({ $searchBox.Focus() })
[void]$form.ShowDialog()