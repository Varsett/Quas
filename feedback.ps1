Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Net.Http

# Ensure TLS 1.2
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

# --- Helper: Big notification window ---
function Show-Notification([string]$msg) {
    $note = New-Object System.Windows.Forms.Form
    $note.Text = "Info"
    $note.Size = New-Object System.Drawing.Size(420,180)
    $note.StartPosition = "CenterScreen"

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $msg
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 16)
    $lbl.AutoSize = $true
    $lbl.Dock = 'Fill'
    $lbl.TextAlign = 'MiddleCenter'

    $note.Controls.Add($lbl)

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 1500
    $timer.Add_Tick({ $note.Close(); $timer.Stop() })

    $timer.Start()
    $note.ShowDialog()
}

# --- Upload to Koofr using HttpClient ---
function Send-FileToKoofr([string]$filePath, [string]$remoteName = $null, [switch]$SuppressNotification) {
    try {
        if (-not (Test-Path -LiteralPath $filePath)) {
            throw "File not found: $filePath"
        }

        # Формируем имя на Koofr, если не передано
        if (-not $remoteName) {
            $stamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
            $name = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
            $ext = [System.IO.Path]::GetExtension($filePath)
            $remoteName = "$name`_$stamp$ext"
        }

#$url = 'https://app.koofr.net/content/receivers/621866d7-2b0a-4b5f-98c0-f1cdc87e8434/files/put'

#QuasUpload
#$url = 'https://app.koofr.net/content/receivers/1574cf54-aaeb-403f-8bcf-a1a9498e5e62/files/put'

#QuasUpload\Feedbacks
$url = 'https://app.koofr.net/content/receivers/dc753b2c-2e85-4847-ab5e-fa3953b2037e/files/put'
        $client  = New-Object System.Net.Http.HttpClient
        $content = New-Object System.Net.Http.MultipartFormDataContent

        $fs = [System.IO.File]::OpenRead($filePath)
        $sc = New-Object System.Net.Http.StreamContent($fs)
        $sc.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('application/octet-stream')

        $content.Add($sc, 'file', $remoteName)

        $resp = $client.PostAsync($url, $content).Result
        if (-not $resp.IsSuccessStatusCode) {
            $body = $resp.Content.ReadAsStringAsync().Result
            throw "HTTP $($resp.StatusCode) $($resp.ReasonPhrase)`n$body"
        }

        if (-not $SuppressNotification) {
            Show-Notification "File sent success"
        }
    }
    catch {
        Show-Notification "Upload error: $($_.Exception.Message)"
    }
    finally {
        if ($sc) { $sc.Dispose() }
        if ($fs) { $fs.Dispose() }
        if ($content) { $content.Dispose() }
        if ($client) { $client.Dispose() }
    }
}

# --- Main Form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Feedback & Files"
$form.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$form.Size = New-Object System.Drawing.Size(500,280)
$form.MinimumSize = New-Object System.Drawing.Size(500,280)
$form.StartPosition = "CenterScreen"
$form.AllowDrop = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = "Drop a file here or use buttons below"
$label.Font = New-Object System.Drawing.Font("Segoe UI",12)
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(70,20)
$form.Controls.Add($label)

$btnFile = New-Object System.Windows.Forms.Button
$btnFile.Text = "Send File"
$btnFile.Font = New-Object System.Drawing.Font("Segoe UI",12)
$btnFile.Size = New-Object System.Drawing.Size(180,50)
$btnFile.Location = New-Object System.Drawing.Point(40,120)

$btnFeedback = New-Object System.Windows.Forms.Button
$btnFeedback.Text = "Leave Feedback"
$btnFeedback.Font = New-Object System.Drawing.Font("Segoe UI",12)
$btnFeedback.Size = New-Object System.Drawing.Size(180,50)
$btnFeedback.Location = New-Object System.Drawing.Point(260,120)

$form.Controls.Add($btnFile)
$form.Controls.Add($btnFeedback)

$form.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [Windows.Forms.DragDropEffects]::Copy
    }
})
$form.Add_DragDrop({
    $files = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    foreach ($f in $files) { Send-FileToKoofr -filePath $f }
})

$btnFile.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = "Select file to send"
    if ($dlg.ShowDialog() -eq "OK") {
        Send-FileToKoofr -filePath $dlg.FileName
    }
})

$btnFeedback.Add_Click({
    $inputBox = New-Object System.Windows.Forms.Form
    $inputBox.Text = "Leave Feedback"
    $inputBox.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $inputBox.Size = New-Object System.Drawing.Size(680,500)
    $inputBox.MinimumSize = New-Object System.Drawing.Size(500,350)
    $inputBox.StartPosition = "CenterScreen"

    $font = New-Object System.Drawing.Font("Segoe UI", 14)

    $tlp = New-Object System.Windows.Forms.TableLayoutPanel
    $tlp.Dock = 'Fill'
    $tlp.RowCount = 2
    $tlp.ColumnCount = 3
    $null = $tlp.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $null = $tlp.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $null = $tlp.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)))
    $null = $tlp.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $null = $tlp.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Absolute, 70)))

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Multiline = $true
    $textBox.ScrollBars = "Vertical"
    $textBox.Font = $font
    $textBox.Dock = 'Fill'

    $okBtn = New-Object System.Windows.Forms.Button
    $okBtn.Text = "Send"
    $okBtn.Font = New-Object System.Drawing.Font("Segoe UI",14)
    $okBtn.AutoSize = $true
    $okBtn.Anchor = [System.Windows.Forms.AnchorStyles]::None

    $tlp.Controls.Add($textBox, 0, 0)
    $tlp.SetColumnSpan($textBox, 3)
    $tlp.Controls.Add($okBtn, 1, 1)

    $okBtn.Add_Click({
        $fb = $textBox.Text
        if ($fb.Trim()) {
            $stamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
            $fileName = "feedback_$stamp.txt"

            [System.IO.File]::WriteAllText($fileName, ("[{0:yyyy-MM-dd HH:mm:ss}]`r`n{1}" -f (Get-Date), $fb), [System.Text.Encoding]::UTF8)

            # Отправляем фидбек, подавляем уведомление о файле
            Send-FileToKoofr -filePath $fileName -remoteName $fileName -SuppressNotification

            # Показываем только сообщение для фидбека
            Show-Notification "Thank You! Feedback sent success"
        }
        $inputBox.Close()
    })

    $inputBox.Controls.Add($tlp)
    $inputBox.ShowDialog()
})

[void][System.Windows.Forms.Application]::Run($form)
