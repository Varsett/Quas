param(
    [switch]$p,
    [string]$csv = "C:\Temp\data.csv",
    [string]$title = "Bitrate and Percentage Chart",
    [int]$offsetX = 0,
    [int]$offsetY = 0
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

if (-Not (Test-Path $csv)) {
    Write-Error "CSV file not found: $csv"
    exit
}

$fontName = "Arial"

$values = Get-Content -Path $csv | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
$totalPoints = $values.Count
$maxBitrate = ($values | Measure-Object -Maximum).Maximum
$initialVisiblePoints = 30

$form = New-Object System.Windows.Forms.Form
$form.Text = $title
$form.Width = 1100
$form.Height = 650
$form.StartPosition = "Manual"
$form.Location = New-Object System.Drawing.Point($offsetX, $offsetY)

$chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 1080
$chart.Height = 500
$chart.Dock = 'Top'

$chartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chartArea.AxisX.Title = ""
$chartArea.AxisY.Title = "Bitrate (Mbps)"
$chartArea.AxisX.Interval = 1
$chartArea.AxisX.Minimum = 1
$chartArea.AxisX.Maximum = $totalPoints
$chartArea.AxisY.Minimum = 0
$chartArea.AxisY.Maximum = $maxBitrate
$chartArea.AxisX.MajorGrid.LineWidth = 0

if ($p) {
    $chartArea.AxisY2.Enabled = "True"
    $chartArea.AxisY2.Minimum = 0
    $chartArea.AxisY2.Maximum = 100
    $chartArea.AxisY2.Title = "Percentage (%)"
    $chartArea.AxisY2.MajorGrid.Enabled = $false
}
else {
    $chartArea.AxisY2.Enabled = "False"
}

$chartArea.AxisX.ScrollBar.Enabled = $true
$chartArea.AxisX.ScrollBar.IsPositionedInside = $false
$chartArea.AxisX.ScrollBar.ButtonStyle = "SmallScroll"
$chartArea.AxisX.ScaleView.Size = $initialVisiblePoints
$chartArea.CursorX.IsUserEnabled = $true
$chartArea.CursorX.IsUserSelectionEnabled = $true
$chartArea.AxisX.ScaleView.Zoomable = $true

$chart.ChartAreas.Add($chartArea)

# Main chart title
$titleObj = $chart.Titles.Add($title)
$titleObj.Font = New-Object System.Drawing.Font($fontName, 12, [System.Drawing.FontStyle]::Bold)

# Main column series
$seriesMain = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$seriesMain.Name = "Bitrate"
$seriesMain.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Column
$seriesMain.Color = [System.Drawing.Color]::CornflowerBlue
$seriesMain.YAxisType = "Primary"

for ($i = 0; $i -lt $values.Count; $i++) {
    $seriesMain.Points.AddXY($i + 1, $values[$i])
}
$chart.Series.Add($seriesMain)

# Percentage line chart if -p specified
if ($p) {
    $seriesPct = New-Object System.Windows.Forms.DataVisualization.Charting.Series
    $seriesPct.Name = "Percentage"
    $seriesPct.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
    $seriesPct.Color = [System.Drawing.Color]::DarkCyan
    $seriesPct.BorderWidth = 2
    $seriesPct.YAxisType = "Secondary"

    for ($i = 0; $i -lt $values.Count; $i++) {
        $pct = [math]::Round(($values[$i] / $maxBitrate) * 100, 2)
        $seriesPct.Points.AddXY($i + 1, $pct)
    }
    $chart.Series.Add($seriesPct)
}

$trackBar = New-Object System.Windows.Forms.TrackBar
$trackBar.Minimum = 5
$trackBar.Maximum = [Math]::Min($totalPoints, 500)
$trackBar.Value = $initialVisiblePoints
$trackBar.TickFrequency = 25
$trackBar.SmallChange = 1
$trackBar.LargeChange = 25
$trackBar.Dock = 'Top'

$label = New-Object System.Windows.Forms.Label
$label.Text = "Zoom: $($trackBar.Value)"
$label.Dock = 'Top'
$label.TextAlign = "MiddleCenter"
$label.Height = 20
$label.Font = New-Object System.Drawing.Font($fontName, 10, [System.Drawing.FontStyle]::Regular)

$trackBar.Add_ValueChanged({
    $size = $trackBar.Value
    $chartArea.AxisX.ScaleView.Size = $size
    $label.Text = "Zoom: $size"
})

# Label below scrollbar
$scrollInfoLabel = New-Object System.Windows.Forms.Label
$scrollInfoLabel.Text = "Wheel Mouse - Scroll-bar    Ctrl+Wheel Mouse - Zoom"
$scrollInfoLabel.Dock = 'Top'
$scrollInfoLabel.Height = 25
$scrollInfoLabel.TextAlign = "MiddleCenter"
$scrollInfoLabel.Font = New-Object System.Drawing.Font($fontName, 9, [System.Drawing.FontStyle]::Italic)

$form.Controls.Add($scrollInfoLabel)

# Checkbox Hide Scrollbars
$chkHideScrollbars = New-Object System.Windows.Forms.CheckBox
$chkHideScrollbars.Text = "Hide Scrollbars"
$chkHideScrollbars.AutoSize = $true
$chkHideScrollbars.Location = New-Object System.Drawing.Point($form.ClientSize.Width - $chkHideScrollbars.PreferredSize.Width - 10, 45)
$chkHideScrollbars.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($chkHideScrollbars)

function UpdateFormLayout {
    if ($chkHideScrollbars.Checked) {
        $chartArea.AxisX.ScrollBar.Enabled = $false
        $trackBar.Visible = $false
        $label.Visible = $false
        $scrollInfoLabel.Visible = $false

        $form.Height = $chart.Top + $chart.Height + 1
    }
    else {
        $chartArea.AxisX.ScrollBar.Enabled = $true
        $trackBar.Visible = $true
        $label.Visible = $true
        $scrollInfoLabel.Visible = $true

        $form.Height = 650
    }
    $chkHideScrollbars.Location = New-Object System.Drawing.Point(
        $form.ClientSize.Width - $chkHideScrollbars.PreferredSize.Width - 10,
        45
    )
    $form.Invalidate()
}

$chkHideScrollbars.Add_CheckedChanged({
    UpdateFormLayout
})

$form.Add_MouseWheel({
    param($sender, $e)

    if ([System.Windows.Forms.Control]::ModifierKeys -band [System.Windows.Forms.Keys]::Control) {
        $currentSize = $chartArea.AxisX.ScaleView.Size
        $delta = if ($e.Delta -gt 0) { -5 } else { 5 }
        $newSize = [Math]::Max(5, [Math]::Min($trackBar.Maximum, $currentSize + $delta))
        $trackBar.Value = $newSize
    }
    else {
        $scrollPos = $chartArea.AxisX.ScaleView.Position
        $deltaPos = if ($e.Delta -gt 0) { -5 } else { 5 }
        $newPos = [Math]::Max(1, [Math]::Min($totalPoints - $chartArea.AxisX.ScaleView.Size, $scrollPos + $deltaPos))
        $chartArea.AxisX.ScaleView.Position = $newPos
    }
})

$form.Controls.Add($label)
$form.Controls.Add($trackBar)
$form.Controls.Add($chart)

[void]$form.ShowDialog()
