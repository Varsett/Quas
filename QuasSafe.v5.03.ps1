# QuasSafe v5.03 - Universal Encrypted Credentials Manager
# (c) 2026 Varset & Gemini Dev
# See built-in Help (? button) or Manual_EN.md / Manual_RU.md

param (
    [switch]$Encrypt,
    [switch]$Decrypt,
    [switch]$ToReg,
    [switch]$ToFile,
    [switch]$Run,
    [switch]$Stream,
    [switch]$returnString,
    [switch]$Clip,
    [switch]$ExportSecure,
    [string]$keyName,
    [string]$payload,
    [string]$payloadFile,         # path to file with payload blob (avoids CMD quoting issues)
    [string]$hint,
    [SecureString]$pass,          # [#6] SecureString, not plaintext
    [string]$desc,
    [string]$outFile,
    [string]$lang = "RU"
)

# ============================================================
#  ИНИЦИАЛИЗАЦИЯ UI
# ============================================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

# ============================================================
#  LOCALISATION  (EN default, RU via -lang RU)
# ============================================================
$global:lang = $lang.ToUpper()
if ($global:lang -ne 'RU') { $global:lang = 'EN' }

$L = @{
    # --- Password form ---
    'wait.title'         = @{ EN='Please wait...';            RU='Подождите...' }
    'wait.msg'           = @{ EN='Too many attempts. Wait {0} sec...'; RU='Слишком много попыток. Ждите {0} сек...' }
    'unlock.title'       = @{ EN='Unlock Data';               RU='Расшифровка' }
    'unlock.hint'        = @{ EN="Hint: {0}`n`nAttempt {1}/3:"; RU="Подсказка: {0}`n`nПопытка {1}/3:" }
    'unlock.go'          = @{ EN='GO';                         RU='OK' }
    'unlock.timeout'     = @{ EN='Auto-close in {0}s';        RU='Закрытие через {0} сек' }
    # --- Errors ---
    'err.parse'          = @{ EN='Cannot parse key record.';  RU='Не удаётся прочитать запись ключа.' }
    'err.wrongpass'      = @{ EN='Wrong password or data corrupted!'; RU='Неверный пароль или данные повреждены!' }
    'err.wrongpass2'     = @{ EN='Wrong password!';           RU='Неверный пароль!' }
    'err.encrypt'        = @{ EN='Encryption error: {0}';    RU='Ошибка шифрования: {0}' }
    'err.nodata'         = @{ EN='No encrypted data found in this key.'; RU='Зашифрованные данные не найдены.' }
    'err.nofile'         = @{ EN='File not found: {0}';       RU='Файл не найден: {0}' }
    'err.wrongmaster'    = @{ EN='Wrong master password or file corrupted!'; RU='Неверный мастер-пароль или файл повреждён!' }
    # --- Clipboard ---
    'clip.msg'           = @{ EN="Copied to clipboard.`nWill be cleared in 30 seconds."; RU="Скопировано в буфер обмена.`nАвтоочистка через 30 секунд." }
    'clip.title'         = @{ EN='Clipboard';                 RU='Буфер обмена' }
    # --- Vault export ---
    'vault.empty'        = @{ EN='Registry is empty.';        RU='Реестр пуст.' }
    'vault.nokeys'       = @{ EN='No keys to export.';        RU='Нет ключей для экспорта.' }
    'vault.exp.title'    = @{ EN='Vault Export - Master Password'; RU='Экспорт хранилища - мастер-пароль' }
    'vault.exp.label'    = @{ EN='Set master password for vault.enc:'; RU='Задайте мастер-пароль для vault.enc:' }
    'vault.exp.confirm'  = @{ EN='Confirm:';                  RU='Подтвердите:' }
    'vault.exp.btn'      = @{ EN='EXPORT';                    RU='ЭКСПОРТ' }
    'vault.exp.mismatch' = @{ EN='Passwords mismatch or empty!'; RU='Пароли не совпадают или пусты!' }
    'vault.exp.ok'       = @{ EN="Vault exported to:`n{0}`n`nDecrypt with: QuasSafe5.03.ps1 -Decrypt -payloadFile vault.enc -Stream"; RU="Хранилище экспортировано в:`n{0}`n`nРасшифровка: QuasSafe5.03.ps1 -Decrypt -payloadFile vault.enc -Stream" }
    'vault.exp.oktitle'  = @{ EN='Export OK';                 RU='Готово' }
    'vault.imp.title'    = @{ EN='Vault Import - Master Password'; RU='Импорт хранилища - мастер-пароль' }
    'vault.imp.label'    = @{ EN='Enter master password:';    RU='Введите мастер-пароль:' }
    'vault.imp.btn'      = @{ EN='DECRYPT & IMPORT';          RU='РАСШИФРОВАТЬ И ИМПОРТИРОВАТЬ' }
    'vault.imp.ok'       = @{ EN='Imported {0} keys.';        RU='Импортировано ключей: {0}.' }
    'vault.imp.oktitle'  = @{ EN='Import OK';                 RU='Готово' }
    'vault.exp.keyok'    = @{ EN='Key appended to vault.txt (encrypted).'; RU='Ключ добавлен в vault.txt (зашифрован).' }
    'vault.exp.allok'    = @{ EN='All keys saved to vault.txt (encrypted).'; RU='Все ключи сохранены в vault.txt (зашифровано).' }
    # --- Copy Payload ---
    'copy.ok'            = @{ EN="Encrypted payload copied to clipboard.`n`nUse in CMD:`nset `"payload=<blob>`"`npowershell ... -Decrypt -payload `"%payload%`" -outFile set_creds.bat"; RU="Зашифрованный payload скопирован.`n`nИспользование в CMD:`nset `"payload=<blob>`"`npowershell ... -Decrypt -payload `"%payload%`" -outFile set_creds.bat" }
    'copy.oktitle'       = @{ EN='Payload Copied';            RU='Скопировано' }
    # --- Main form ---
    'main.title'         = @{ EN='QuasSafe v5.03';            RU='QuasSafe v5.03' }
    'main.keys'          = @{ EN='Registry Keys:';            RU='Ключи реестра:' }
    'main.desc'          = @{ EN=' Description ';             RU=' Описание ' }
    'btn.add'            = @{ EN='ADD NEW KEY';                RU='НОВЫЙ КЛЮЧ' }
    'btn.del'            = @{ EN='Delete Selected';            RU='Удалить' }
    'btn.del.confirm'    = @{ EN='Delete?';                    RU='Удалить?' }
    'btn.del.title'      = @{ EN='Confirm';                    RU='Подтверждение' }
    'btn.expkey'         = @{ EN='Export Key  (Txt)';          RU='Экспорт ключа (Txt)' }
    'btn.expall'         = @{ EN='Export ALL  (Txt)';          RU='Экспорт всех (Txt)' }
    'btn.expsec'         = @{ EN='Export  (Enc)';              RU='Экспорт (Enc)' }
    'btn.impsec'         = @{ EN='Import  (Enc)';              RU='Импорт (Enc)' }
    'btn.imptxt'         = @{ EN='Import  (Txt)';              RU='Импорт (Txt)' }
    'btn.view'           = @{ EN='VIEW / EDIT KEY';            RU='ПРОСМОТР / ПРАВКА' }
    'btn.dec'            = @{ EN='RUN DECRYPTOR';              RU='РАСШИФРОВАТЬ' }
    'btn.copy'           = @{ EN='Copy Payload';               RU='Копировать Payload' }
    'btn.theme'          = @{ EN='Theme';                      RU='Тема' }
    # --- Key editor ---
    'ed.create'          = @{ EN='Create Key';                 RU='Создать ключ' }
    'ed.edit'            = @{ EN='Edit Key';                   RU='Редактировать ключ' }
    'ed.name'            = @{ EN='Name *:';                    RU='Имя *:' }
    'ed.payload'         = @{ EN='Payload *:';                 RU='Payload *:' }
    'ed.outfile'         = @{ EN='Output Filename (e.g. secret.bat):'; RU='Выходной файл (напр. secret.bat):' }
    'ed.desc'            = @{ EN='Description:';               RU='Описание:' }
    'ed.hint'            = @{ EN='Hint:';                      RU='Подсказка:' }
    'ed.pass'            = @{ EN='Password *:';                RU='Пароль *:' }
    'ed.confirm'         = @{ EN='Confirm *:';                 RU='Подтверждение *:' }
    'ed.outmode'         = @{ EN=' Output mode ';              RU=' Режим вывода ' }
    'ed.stream'          = @{ EN='Stream';                     RU='Поток' }
    'ed.file'            = @{ EN='File';                       RU='Файл' }
    'ed.clipboard'       = @{ EN='Clipboard (30s)';            RU='Буфер (30 сек)' }
    'ed.saveto'          = @{ EN=' Save to ';                  RU=' Сохранить в ' }
    'ed.reg'             = @{ EN='Reg';                        RU='Реестр' }
    'ed.afterdec'        = @{ EN='After Decrypt';              RU='После расшифровки' }
    'ed.runfile'         = @{ EN='Run File';                   RU='Запустить файл' }
    'ed.save'            = @{ EN='SAVE DATA';                  RU='СОХРАНИТЬ' }
    'ed.mandatory'       = @{ EN='Fill mandatory fields!';     RU='Заполните обязательные поля!' }
    'ed.outreq'          = @{ EN='Fill Output Filename!';      RU='Укажите имя выходного файла!' }
    'ed.mismatch'        = @{ EN='Passwords mismatch!';        RU='Пароли не совпадают!' }
    'ed.unsaved'         = @{ EN="You have unsaved changes.`nClose without saving?"; RU="Есть несохранённые изменения.`nЗакрыть без сохранения?" }
    'ed.unsaved.title'   = @{ EN='Unsaved Changes';            RU='Несохранённые изменения' }
}

# Translation function: T 'key' [arg0] [arg1]
function T ([string]$key) {
    $entry = $L[$key]
    if (-not $entry) { return $key }
    $s = $entry[$global:lang]
    if (-not $s) { $s = $entry['EN'] }
    for ($i = 1; $i -lt $args.Count + 1; $i++) { $s = $s.Replace("{$($i-1)}", [string]$args[$i-1]) }
    return $s
}

$global:isDark = 1
$theme = @{
    Dark  = @{
        db   = [System.Drawing.Color]::FromArgb(32,32,32)
        lb   = [System.Drawing.Color]::FromArgb(45,45,48)
        fg   = [System.Drawing.Color]::FromArgb(241,241,241)
        ac   = [System.Drawing.Color]::FromArgb(0,122,204)
        gr   = [System.Drawing.Color]::FromArgb(45,100,45)
        btn  = [System.Drawing.Color]::FromArgb(72,72,76)
        gray = [System.Drawing.Color]::Gray
    }
    Light = @{
        db   = [System.Drawing.Color]::FromArgb(240,240,240)
        lb   = [System.Drawing.Color]::White
        fg   = [System.Drawing.Color]::Black
        ac   = [System.Drawing.Color]::LightBlue
        gr   = [System.Drawing.Color]::LightGreen
        btn  = [System.Drawing.Color]::FromArgb(210,210,215)
        gray = [System.Drawing.Color]::DarkGray
    }
}

$regPath = "HKCU:\Software\Quas\Credentials"

# ============================================================
#  ВСПОМОГАТЕЛЬНЫЕ UI-ФУНКЦИИ
# ============================================================
function Set-QuasIcon($form) {
    try { $form.Icon = [System.Drawing.SystemIcons]::Shield } catch { $form.ShowIcon = $false }
}

function Get-SafeFont([string]$n, [float]$s, [string]$st = "Regular") {
    return New-Object System.Drawing.Font($n, $s, [System.Drawing.FontStyle]::$st)
}

function Update-Theme {
    param($targetForm)
    $colors = if ($global:isDark) { $theme.Dark } else { $theme.Light }
    $targetForm.BackColor = $colors.db
    $targetForm.ForeColor = $colors.fg
    foreach ($ctl in $targetForm.Controls) {
        if ($ctl -is [System.Windows.Forms.Button]) {
            if ($ctl.Tag -eq "danger") {
                # Delete button - fixed red regardless of theme/language
                $ctl.BackColor = [System.Drawing.Color]::FromArgb(110,40,40)
                $ctl.ForeColor = [System.Drawing.Color]::FromArgb(255,200,200)
            } elseif ($ctl.Tag -eq "accent") {
                $ctl.BackColor = $colors.ac
                $ctl.ForeColor = if ($global:isDark) { [System.Drawing.Color]::White } else { [System.Drawing.Color]::Black }
            } elseif ($ctl.Tag -eq "green") {
                $ctl.BackColor = $colors.gr
                $ctl.ForeColor = if ($global:isDark) { [System.Drawing.Color]::White } else { [System.Drawing.Color]::Black }
            } else {
                $ctl.BackColor = $colors.btn
                $ctl.ForeColor = $colors.fg
            }
            $ctl.FlatStyle = "Flat"
            $ctl.FlatAppearance.BorderSize = 0
        }
        elseif ($ctl -is [System.Windows.Forms.ListBox] -or $ctl -is [System.Windows.Forms.TextBox]) {
            $ctl.BackColor = $colors.lb
            $ctl.ForeColor = $colors.fg
            if ($ctl -is [System.Windows.Forms.TextBox]) { $ctl.BorderStyle = "FixedSingle" }
        }
        elseif ($ctl -is [System.Windows.Forms.GroupBox]) {
            $ctl.ForeColor = $colors.fg
            foreach ($sub in $ctl.Controls) {
                if ($sub -is [System.Windows.Forms.TextBox]) {
                    $sub.BackColor = $colors.db; $sub.ForeColor = $colors.fg; $sub.BorderStyle = "None"
                }
                elseif ($sub -is [System.Windows.Forms.RadioButton] -or $sub -is [System.Windows.Forms.CheckBox]) {
                    $sub.ForeColor = if ($sub.Enabled) { $colors.fg } else { $colors.gray }
                }
            }
        }
    }
}

# ============================================================
#  [#6] HELPER: SecureString -> PlainText (с немедленной очисткой BSTR)
# ============================================================
function ConvertFrom-SecureStringPlain ([SecureString]$ss) {
    if ($null -eq $ss) { return $null }
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}

# ============================================================
#  [#4] HELPER: Затирание строки в TextBox
# ============================================================
function Clear-TextBoxSecure ([System.Windows.Forms.TextBox]$tb) {
    if ($null -eq $tb) { return }
    # Перезаписать содержимое случайными символами перед очисткой
    $tb.Text = [string]::new([char]42, [Math]::Max(1, $tb.Text.Length))
    $tb.Clear()
}

# ============================================================
#  [#1][#2][#3][#5][#8] КРИПТО-ДВИЖОК
#
#  Формат зашифрованного blob (Base64):
#    [16 bytes random Salt][16 bytes random IV][32 bytes HMAC][ciphertext]
#
#  KDF: PBKDF2-SHA256, 100 000 итераций
#  Шифр: AES-256-CBC
#  MAC:  HMAC-SHA256 over (Salt || IV || ciphertext), ключ из того же KDF
# ============================================================

$PBKDF2_ITERATIONS = 100000
$SALT_SIZE         = 16   # bytes
$IV_SIZE           = 16   # bytes
$KEY_SIZE          = 32   # bytes (AES-256)
$HMAC_SIZE         = 32   # bytes (SHA-256)

function Protect-Payload {
    param(
        [string]$plainText,
        [string]$password
    )
    $aes  = $null
    $kd   = $null
    $hmac = $null
    try {
        # [#3] Случайная соль
        $saltBytes = New-Object Byte[] $SALT_SIZE
        $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
        $rng.GetBytes($saltBytes)
        $rng.Dispose()

        # [#1] PBKDF2-SHA256 (fallback на SHA-1 если .NET < 4.7.2)
        $kd = $null
        try {
            $kd = New-Object Security.Cryptography.Rfc2898DeriveBytes(
                $password, $saltBytes, $PBKDF2_ITERATIONS,
                [Security.Cryptography.HashAlgorithmName]::SHA256
            )
        } catch {
            $kd = New-Object Security.Cryptography.Rfc2898DeriveBytes($password, $saltBytes, $PBKDF2_ITERATIONS)
        }

        # [#2] Ключи из KDF — явный каст в Byte[] обязателен для PS 5.1
        [Byte[]]$encKey = $kd.GetBytes($KEY_SIZE)
        [Byte[]]$macKey = $kd.GetBytes($KEY_SIZE)

        # [#2] Случайный IV
        $aes = [Security.Cryptography.Aes]::Create()
        $aes.Key = $encKey
        $aes.GenerateIV()
        [Byte[]]$iv = $aes.IV

        # Шифрование
        [Byte[]]$rawBytes = [Text.Encoding]::UTF8.GetBytes($plainText)
        [Byte[]]$encBytes = $aes.CreateEncryptor().TransformFinalBlock($rawBytes, 0, $rawBytes.Length)

        # [#5] HMAC-SHA256 — конкатенация через Buffer.BlockCopy (гарантированный Byte[])
        $macInput = New-Object Byte[] ($saltBytes.Length + $iv.Length + $encBytes.Length)
        [Buffer]::BlockCopy($saltBytes, 0, $macInput, 0,                                    $saltBytes.Length)
        [Buffer]::BlockCopy($iv,        0, $macInput, $saltBytes.Length,                    $iv.Length)
        [Buffer]::BlockCopy($encBytes,  0, $macInput, $saltBytes.Length + $iv.Length,       $encBytes.Length)

        $hmac = New-Object Security.Cryptography.HMACSHA256(,$macKey)
        [Byte[]]$tag = $hmac.ComputeHash($macInput)

        # Финальный blob: Salt | IV | HMAC | Ciphertext
        $blobOut = New-Object Byte[] ($saltBytes.Length + $iv.Length + $tag.Length + $encBytes.Length)
        [Buffer]::BlockCopy($saltBytes, 0, $blobOut, 0,                                                   $saltBytes.Length)
        [Buffer]::BlockCopy($iv,        0, $blobOut, $saltBytes.Length,                                   $iv.Length)
        [Buffer]::BlockCopy($tag,       0, $blobOut, $saltBytes.Length + $iv.Length,                      $tag.Length)
        [Buffer]::BlockCopy($encBytes,  0, $blobOut, $saltBytes.Length + $iv.Length + $tag.Length,        $encBytes.Length)

        return [Convert]::ToBase64String($blobOut)
    }
    finally {
        if ($aes)  { $aes.Dispose() }
        if ($kd)   { $kd.Dispose() }
        if ($hmac) { $hmac.Dispose() }
    }
}

function Unprotect-Payload {
    param(
        [string]$base64,
        [string]$password
    )
    $aes  = $null
    $kd   = $null
    $hmac = $null
    try {
        [Byte[]]$blob = [Convert]::FromBase64String($base64)
        $minLen = $SALT_SIZE + $IV_SIZE + $HMAC_SIZE + 1
        if ($blob.Length -lt $minLen) { throw "Blob too short" }

        # Нарезаем blob через BlockCopy — гарантированный Byte[] для PS 5.1
        [Byte[]]$saltBytes = New-Object Byte[] $SALT_SIZE
        [Byte[]]$iv        = New-Object Byte[] $IV_SIZE
        [Byte[]]$tag       = New-Object Byte[] $HMAC_SIZE
        [Byte[]]$encBytes  = New-Object Byte[] ($blob.Length - $SALT_SIZE - $IV_SIZE - $HMAC_SIZE)
        [Buffer]::BlockCopy($blob, 0,                                    $saltBytes, 0, $SALT_SIZE)
        [Buffer]::BlockCopy($blob, $SALT_SIZE,                           $iv,        0, $IV_SIZE)
        [Buffer]::BlockCopy($blob, $SALT_SIZE + $IV_SIZE,                $tag,       0, $HMAC_SIZE)
        [Buffer]::BlockCopy($blob, $SALT_SIZE + $IV_SIZE + $HMAC_SIZE,   $encBytes,  0, $encBytes.Length)

        # [#1] KDF
        $kd = $null
        try {
            $kd = New-Object Security.Cryptography.Rfc2898DeriveBytes(
                $password, $saltBytes, $PBKDF2_ITERATIONS,
                [Security.Cryptography.HashAlgorithmName]::SHA256
            )
        } catch {
            $kd = New-Object Security.Cryptography.Rfc2898DeriveBytes($password, $saltBytes, $PBKDF2_ITERATIONS)
        }
        [Byte[]]$encKey = $kd.GetBytes($KEY_SIZE)
        [Byte[]]$macKey = $kd.GetBytes($KEY_SIZE)

        # [#5] Проверка HMAC ПЕРЕД расшифровкой
        $macInput = New-Object Byte[] ($saltBytes.Length + $iv.Length + $encBytes.Length)
        [Buffer]::BlockCopy($saltBytes, 0, $macInput, 0,                              $saltBytes.Length)
        [Buffer]::BlockCopy($iv,        0, $macInput, $saltBytes.Length,              $iv.Length)
        [Buffer]::BlockCopy($encBytes,  0, $macInput, $saltBytes.Length + $iv.Length, $encBytes.Length)

        $hmac = New-Object Security.Cryptography.HMACSHA256(,$macKey)
        [Byte[]]$expectedTag = $hmac.ComputeHash($macInput)

        # Сравнение в постоянное время (XOR, без CryptographicOperations .NET 5+)
        $diff = 0
        if ($tag.Length -ne $expectedTag.Length) { $diff = 1 }
        else { for ($i = 0; $i -lt $tag.Length; $i++) { $diff = $diff -bor ($tag[$i] -bxor $expectedTag[$i]) } }
        if ($diff -ne 0) { throw "HMAC verification failed - wrong password or data tampered" }

        # Расшифровка
        $aes = [Security.Cryptography.Aes]::Create()
        $aes.Key = $encKey
        $aes.IV  = $iv
        [Byte[]]$dec = $aes.CreateDecryptor().TransformFinalBlock($encBytes, 0, $encBytes.Length)
        return [Text.Encoding]::UTF8.GetString($dec)
    }
    finally {
        if ($aes)  { $aes.Dispose() }
        if ($kd)   { $kd.Dispose() }
        if ($hmac) { $hmac.Dispose() }
    }
}


# ============================================================
#  [#7] ХРАНИЛИЩЕ: JSON-формат записи
#
#  Структура JSON-объекта одного ключа:
#  {
#    "Hint":    "...",
#    "Desc":    "...",
#    "Data":    "<Base64 blob>",
#    "OutFile": "set_creds.bat" | "STREAM_MODE",
#    "Run":     true | false,
#    "Ver":     4
#  }
# ============================================================

function ConvertTo-KeyJson {
    param($hint, $desc, $dataB64, $outFile, [bool]$run)
    return [PSCustomObject]@{
        Hint    = $hint
        Desc    = if ($desc) { $desc } else { "" }
        Data    = $dataB64
        OutFile = if ($outFile) { $outFile } else { "STREAM_MODE" }
        Run     = $run
        Ver     = 4
    } | ConvertTo-Json -Compress
}

function Read-KeyJson ([string]$raw) {
    $t = $raw.Trim()
    if ($t.StartsWith('{')) { return $t | ConvertFrom-Json }
    return $null
}

# ============================================================
#  [#10][#11] ФОРМА ВВОДА ПАРОЛЯ С RATE-LIMITING И ТАЙМАУТОМ
# ============================================================

# Задержки (секунды) перед каждой из 3 попыток
$ATTEMPT_DELAYS = @(0, 2, 5)
# Таймаут формы (мс)
$FORM_TIMEOUT_MS = 60000

function Show-PasswordForm {
    param(
        [string]$hintText,
        [int]$attempt       # 1-based
    )
    $f      = $null
    $timer  = $null
    $result = $null

    try {
        # [#10] Задержка перед показом (rate-limiting)
        $delayIdx = [Math]::Min($attempt - 1, $ATTEMPT_DELAYS.Count - 1)
        $delaySec = $ATTEMPT_DELAYS[$delayIdx]
        if ($delaySec -gt 0) {
            $waitForm = New-Object System.Windows.Forms.Form
            $waitForm.Text = T "wait.title"
            $waitForm.Size = "300,100"
            $waitForm.StartPosition = "CenterScreen"
            $waitForm.TopMost = $true
            $waitForm.FormBorderStyle = "FixedDialog"
            $waitForm.ControlBox = $false
            $lw = New-Object System.Windows.Forms.Label
            $lw.Text = T "wait.msg" $delaySec
            $lw.Location = "20,30"; $lw.AutoSize = $true
            $waitForm.Controls.Add($lw)
            $waitTimer = New-Object System.Windows.Forms.Timer
            $waitTimer.Interval = $delaySec * 1000
            $waitTimer.Add_Tick({ $waitForm.Close(); $waitTimer.Stop() })
            $waitTimer.Start()
            $waitForm.ShowDialog() | Out-Null
            $waitForm.Dispose()
        }

        $f = New-Object System.Windows.Forms.Form
        $f.Text = T "unlock.title"
        $f.Size = "360,220"
        $f.StartPosition = "CenterScreen"
        $f.TopMost = $true
        $f.FormBorderStyle = "FixedDialog"
        $f.MaximizeBox = $false
        Set-QuasIcon $f

        $lHint = New-Object System.Windows.Forms.Label
        $lHint.Text = (T "unlock.hint" $hintText $attempt)
        $lHint.Location = "20,15"; $lHint.Size = "310,50"
        $f.Controls.Add($lHint)

        $tPass = New-Object System.Windows.Forms.TextBox
        $tPass.PasswordChar = '*'
        $tPass.Location = "20,75"; $tPass.Size = "300,25"
        $f.Controls.Add($tPass)

        # [#11] Таймаут-бар
        $pbTimer = New-Object System.Windows.Forms.ProgressBar
        $pbTimer.Location = "20,110"; $pbTimer.Size = "300,8"
        $pbTimer.Minimum = 0; $pbTimer.Maximum = 100; $pbTimer.Value = 100
        $pbTimer.Style = "Continuous"
        $f.Controls.Add($pbTimer)

        $lTimeout = New-Object System.Windows.Forms.Label
        $lTimeout.Text = "Auto-close in 60s"
        $lTimeout.Location = "20,122"; $lTimeout.Size = "200,18"
        $lTimeout.Font = Get-SafeFont "Consolas" 8
        $f.Controls.Add($lTimeout)

        $btnGo = New-Object System.Windows.Forms.Button
        $btnGo.Text = T "unlock.go"
        $btnGo.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $btnGo.Location = "245,148"
        $f.Controls.Add($btnGo)
        $f.AcceptButton = $btnGo

        Update-Theme $f

        # [#11] Timer: ticks every 600 ms = 100 ticks per 60 sec.
        # Counter stored in .Tag to avoid PS 5.1 closure capture bug
        # (local $tickCount would be captured by VALUE and never increment).
        $maxTicks = 100
        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = [int]($FORM_TIMEOUT_MS / $maxTicks)
        $timer.Tag = 0
        $timer.Add_Tick({
            $timer.Tag = [int]$timer.Tag + 1
            $done      = [int]$timer.Tag
            $remaining = $maxTicks - $done
            $pbTimer.Value = [Math]::Max(0, $remaining)
            $secLeft = [int][Math]::Ceiling($remaining * $FORM_TIMEOUT_MS / $maxTicks / 1000)
            $lTimeout.Text = (T "unlock.timeout" $secLeft)
            if ($done -ge $maxTicks) {
                $timer.Stop()
                $f.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
                $f.Close()
            }
        })
        $timer.Start()

        $f.Add_Shown({ $tPass.Focus() })
        $dlg = $f.ShowDialog()
        $timer.Stop()

        if ($dlg -ne [System.Windows.Forms.DialogResult]::OK) {
            return $null
        }

        # [#6] Возвращаем SecureString, не plain string
        $ss = New-Object System.Security.SecureString
        foreach ($ch in $tPass.Text.ToCharArray()) { $ss.AppendChar($ch) }
        $ss.MakeReadOnly()

        # [#4] Сразу затираем TextBox
        Clear-TextBoxSecure $tPass

        return $ss
    }
    finally {
        if ($timer) { $timer.Stop(); $timer.Dispose() }
        if ($f)     { $f.Dispose() }
    }
}

# ============================================================
#  DECRYPT ENGINE
# ============================================================
function Run-DecryptorEngine {
    param(
        [string]$targetKey,
        [switch]$returnString
    )

    # Получаем raw-значение из реестра или как прямую строку
    $rawValue = $null
    if ($targetKey -match '^\{') {
        # Передана JSON-строка напрямую
        $rawValue = $targetKey
    } else {
        $rawValue = (Get-ItemProperty $regPath -Name $targetKey -ErrorAction SilentlyContinue).$targetKey
    }
    if (!$rawValue) { return $null }

    $rec = Read-KeyJson $rawValue
    if (!$rec) {
        [void][Windows.Forms.MessageBox]::Show((T "err.parse"), "Error")
        return $null
    }

    $att = 0
    while ($att -lt 3) {
        $att++
        $ss = Show-PasswordForm -hintText $rec.Hint -attempt $att
        if ($null -eq $ss) { return $null }

        # [#6] Извлекаем plaintext пароль только здесь и сразу используем
        $plainPass = ConvertFrom-SecureStringPlain $ss
        $ss.Dispose()

        try {
            $decrypted = Unprotect-Payload -base64 $rec.Data.ToString().Trim() -password $plainPass
        }
        catch {
            $plainPass = $null
            [void][System.Windows.Forms.MessageBox]::Show((T "err.wrongpass"), "Error", 0, 16)
            continue
        }
        finally {
            # [#4] Гарантированная очистка
            if ($plainPass) {
                [Runtime.InteropServices.Marshal]::ZeroFreeBSTR(
                    [Runtime.InteropServices.Marshal]::StringToBSTR($plainPass)
                ) 
                Remove-Variable plainPass -ErrorAction SilentlyContinue
            }
        }

        # Успешная расшифровка
        if ($returnString -or $rec.OutFile -eq "STREAM_MODE") {
            return $decrypted
        }

        # [#9] -Clip
        if ($Clip) {
            [System.Windows.Forms.Clipboard]::SetText($decrypted)
            [void][Windows.Forms.MessageBox]::Show((T "clip.msg"), (T "clip.title"))
            $clipClear = [System.Threading.Thread]::new([System.Threading.ThreadStart]{
                [System.Threading.Thread]::Sleep(30000)
                try { [System.Windows.Forms.Clipboard]::Clear() } catch { }
            })
            $clipClear.IsBackground = $true
            $clipClear.SetApartmentState([System.Threading.ApartmentState]::STA)
            $clipClear.Start()
            return $null
        }

        # Запись в файл
        $decrypted | Out-File $rec.OutFile -Encoding ascii

        if ($rec.Run -or $Run) {
            if ($rec.OutFile -match '\.ps1$') {
                Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$($rec.OutFile)`""
            } else {
                Start-Process $rec.OutFile
            }
        }
        return $null
    }
    return $null
}

# ============================================================
#  [#12] ЗАШИФРОВАННЫЙ ЭКСПОРТ VAULT
# ============================================================
function Export-VaultSecure ([string]$outPath) {
    # Собрать все ключи
    if (!(Test-Path $regPath)) { [void][Windows.Forms.MessageBox]::Show((T "vault.empty")); return }
    $entries = (Get-ItemProperty $regPath).PSObject.Properties |
        Where-Object { $_.Name -notmatch "^PS" } |
        ForEach-Object { "$($_.Name) = $($_.Value)" }

    if ($entries.Count -eq 0) { [void][Windows.Forms.MessageBox]::Show((T "vault.nokeys")); return }

    # Запрос мастер-пароля
    $mpForm = New-Object System.Windows.Forms.Form
    $mpForm.Text = T "vault.exp.title"
    $mpForm.Size = "360,240"; $mpForm.StartPosition = "CenterScreen"; $mpForm.TopMost = $true
    Set-QuasIcon $mpForm
    $lmp = New-Object System.Windows.Forms.Label; $lmp.Text = T "vault.exp.label"; $lmp.Location = "20,20"; $lmp.AutoSize = $true
    $t1  = New-Object System.Windows.Forms.TextBox; $t1.PasswordChar = '*'; $t1.Location = "20,50"; $t1.Size = "300,25"
    $l2  = New-Object System.Windows.Forms.Label; $l2.Text = T "vault.exp.confirm"; $l2.Location = "20,85"; $l2.AutoSize = $true
    $t2  = New-Object System.Windows.Forms.TextBox; $t2.PasswordChar = '*'; $t2.Location = "20,105"; $t2.Size = "300,25"
    $bOk = New-Object System.Windows.Forms.Button; $bOk.Text = T "vault.exp.btn"; $bOk.DialogResult = [System.Windows.Forms.DialogResult]::OK; $bOk.Location = "205,175"
    $mpForm.Controls.AddRange(@($lmp, $t1, $l2, $t2, $bOk)); $mpForm.AcceptButton = $bOk
    Update-Theme $mpForm
    if ($mpForm.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }
    if ($t1.Text -ne $t2.Text -or $t1.Text.Length -eq 0) {
        [void][Windows.Forms.MessageBox]::Show((T "vault.exp.mismatch")); return
    }
    $masterPass = $t1.Text
    Clear-TextBoxSecure $t1; Clear-TextBoxSecure $t2

    $vaultPlain = $entries -join "`n"
    $blob = $null
    try {
        $blob = Protect-Payload -plainText $vaultPlain -password $masterPass
    } catch {
        [void][Windows.Forms.MessageBox]::Show((T "err.encrypt" $_), "Error", 0, 16)
    } finally {
        Remove-Variable masterPass -ErrorAction SilentlyContinue
    }
    if (-not $blob) { return }

    $blob | Out-File $outPath -Encoding ascii -NoNewline
    [void][Windows.Forms.MessageBox]::Show((T "vault.exp.ok" $outPath), (T "vault.exp.oktitle"))
}

function Import-VaultSecure ([string]$inPath) {
    if (!(Test-Path $inPath)) { [void][Windows.Forms.MessageBox]::Show((T "err.nofile" $inPath)); return }
    $blob = Get-Content $inPath -Raw

    # Запрос мастер-пароля
    $f = New-Object System.Windows.Forms.Form
    $f.Text = T "vault.imp.title"
    $f.Size = "360,160"; $f.StartPosition = "CenterScreen"; $f.TopMost = $true
    Set-QuasIcon $f
    $l = New-Object System.Windows.Forms.Label; $l.Text = T "vault.imp.label"; $l.Location = "20,20"; $l.AutoSize = $true
    $t = New-Object System.Windows.Forms.TextBox; $t.PasswordChar = '*'; $t.Location = "20,50"; $t.Size = "300,25"
    $b = New-Object System.Windows.Forms.Button; $b.Text = T "vault.imp.btn"; $b.DialogResult = [System.Windows.Forms.DialogResult]::OK; $b.Location = "160,90"
    $f.Controls.AddRange(@($l, $t, $b)); $f.AcceptButton = $b
    Update-Theme $f
    if ($f.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }
    $masterPass = $t.Text
    Clear-TextBoxSecure $t

    try {
        $plain = Unprotect-Payload -base64 $blob -password $masterPass
        Remove-Variable masterPass
        $imported = 0
        $plain -split "`n" | ForEach-Object {
            if ($_ -match "^(.+?)\s?=\s?(.+)$") {
                if (!(Test-Path $regPath)) { New-Item $regPath -Force | Out-Null }
                Set-ItemProperty $regPath $Matches[1].Trim() $Matches[2].Trim()
                $imported++
            }
        }
        [void][Windows.Forms.MessageBox]::Show((T "vault.imp.ok" $imported), (T "vault.imp.oktitle"))
    }
    catch {
        Remove-Variable masterPass -ErrorAction SilentlyContinue
        [void][Windows.Forms.MessageBox]::Show((T "err.wrongmaster"), "Error", 0, 16)
    }
}

# ============================================================
#  CLI MODE
# ============================================================
if ($Encrypt -or $Decrypt) {

    if ($Decrypt) {
        if ($keyName) {
            $res = Run-DecryptorEngine $keyName -returnString:($Stream -or $returnString)
            if ($res) { $res | Out-Host }
        }
        else {
            # Получить raw payload: из параметра или из файла
            $rawPayload = $null
            if ($payloadFile) {
                if (!(Test-Path $payloadFile)) { Write-Error "payloadFile not found: $payloadFile"; [Environment]::Exit(1) }
                $rawPayload = (Get-Content $payloadFile -Raw -Encoding UTF8).Trim()
            } elseif ($payload) {
                $rawPayload = $payload.Trim()
            }

            if ($rawPayload) {
                $of  = if ($outFile) { $outFile } else { "decrypted.txt" }
                $r   = if ($Run) { $true } else { $false }
                $att = 0; $res = $null
                while ($att -lt 3 -and $null -eq $res) {
                    $att++
                    $ss = Show-PasswordForm -hintText $hint -attempt $att
                    if ($null -eq $ss) { break }
                    $pp = ConvertFrom-SecureStringPlain $ss; $ss.Dispose()
                    try   { $res = Unprotect-Payload -base64 $rawPayload.Trim() -password $pp }
                    catch { [void][System.Windows.Forms.MessageBox]::Show((T "err.wrongpass2"), "Error", 0, 16) }
                    finally { Remove-Variable pp -ErrorAction SilentlyContinue }
                }
                if ($res) {
                    if ($Stream -or $returnString) { $res | Out-Host }
                    else {
                        $res | Out-File $of -Encoding ascii
                        if ($r) {
                            if ($of -match '\.ps1$') { Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$of`"" }
                            else { Start-Process $of }
                        }
                    }
                }
            }
        }
    }
    elseif ($Encrypt -and $keyName -and $payload) {
        # [#6] pass - SecureString
        $plainPass = $null
        if ($pass) {
            $plainPass = ConvertFrom-SecureStringPlain $pass
        }
        else {
            # Fallback: интерактивный ввод через консоль
            $ssConsole = Read-Host "Enter encryption password" -AsSecureString
            $plainPass = ConvertFrom-SecureStringPlain $ssConsole
            $ssConsole.Dispose()
        }
        try {
            $blob   = Protect-Payload -plainText $payload.Trim() -password $plainPass
            $d_f    = if ($desc) { $desc } else { "No description" }
            $of     = if ($outFile) { $outFile } else { "STREAM_MODE" }
            $runBit = if ($Run) { $true } else { $false }
            $jsonStr = ConvertTo-KeyJson -hint $hint -desc $d_f -dataB64 $blob -outFile $of -run $runBit

            if ($ToReg) {
                if (!(Test-Path $regPath)) { New-Item $regPath -Force | Out-Null }
                Set-ItemProperty $regPath $keyName $jsonStr
            }
            if ($ToFile) { "$keyName = $jsonStr" | Out-File "vault.txt" -Append -Encoding utf8 }
            if (!$ToReg -and !$ToFile) { Write-Output $jsonStr }
        }
        finally {
            Remove-Variable plainPass -ErrorAction SilentlyContinue
        }
    }
    [Environment]::Exit(0)
}

# ============================================================
#  GUI MODE
# ============================================================
trap { continue }   # suppress all terminating errors from reaching ps2exe
$ErrorActionPreference = 'SilentlyContinue'
try {
    if (-not ([System.Management.Automation.PSTypeName]'Win32Functions.Win32ShowWindowAsync').Type) {
        Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' -Name "Win32ShowWindowAsync" -Namespace Win32Functions
    }
    [Win32Functions.Win32ShowWindowAsync]::ShowWindowAsync((Get-Process -Id $PID).MainWindowHandle, 0) | Out-Null
} catch { }

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = T "main.title"
$mainForm.Size = "600,430"
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = "FixedDialog"
$mainForm.MaximizeBox = $false
Set-QuasIcon $mainForm

# --- Заголовок ---
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = T "main.keys"
$lblTitle.Location = "20,15"; $lblTitle.AutoSize = $true
$lblTitle.Font = Get-SafeFont "Arial" 9 "Bold"

# --- Кнопки справки и темы ---
$btnHelp = New-Object System.Windows.Forms.Button
$btnHelp.Text = "?"; $btnHelp.Location = "530,12"; $btnHelp.Size = "30,22"
$btnHelp.Cursor = [System.Windows.Forms.Cursors]::Help
$btnHelp.Add_Click({
    $nl = [Environment]::NewLine
    $sep  = ("=" * 68)
    $sep2 = ("-" * 68)

    # --- RichTextBox colour helper ---
    # AppendRtf: adds text with foreground colour (ARGB) to RichTextBox
    $rtb_Append = {
        param($rtb, [string]$txt, [System.Drawing.Color]$col,
              $bold=$false, $mono=$false)
        $start = $rtb.TextLength
        $rtb.AppendText($txt)
        $rtb.Select($start, $txt.Length)
        $rtb.SelectionColor = $col
        $fName = if ($mono) { "Consolas" } else { "Consolas" }
        $fSize = if ($bold)  { 10 } else { 10 }
        $fStyle = if ($bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
        $rtb.SelectionFont = New-Object System.Drawing.Font($fName, $fSize, $fStyle)
        $rtb.SelectionLength = 0
    }

    $hf = New-Object System.Windows.Forms.Form
    $hf.Text = "QuasSafe v5.03 - Manual"
    $hf.Size = "820,780"; $hf.StartPosition = "CenterParent"
    $hf.BackColor = [System.Drawing.Color]::FromArgb(22,22,26)
    Set-QuasIcon $hf

    $rtb = New-Object System.Windows.Forms.RichTextBox
    $rtb.Dock        = "Fill"
    $rtb.ReadOnly    = $true
    $rtb.BackColor   = [System.Drawing.Color]::FromArgb(22,22,26)
    $rtb.BorderStyle = "None"
    $rtb.ScrollBars  = "Vertical"
    $rtb.WordWrap    = $true
    $rtb.Font        = New-Object System.Drawing.Font("Consolas", 10)
    $hf.Controls.Add($rtb)

    # Colour palette
    $script:cTitle  = [System.Drawing.Color]::FromArgb(86,156,214)   # blue  - section headers
    $script:cSep  = [System.Drawing.Color]::FromArgb(70,70,80)      # grey  - separators
    $script:cKey  = [System.Drawing.Color]::FromArgb(78,201,176)    # teal  - button/param names
    $script:cVal  = [System.Drawing.Color]::FromArgb(206,145,120)   # orange- values/filenames
    $script:cCode  = [System.Drawing.Color]::FromArgb(180,210,140)   # green - code examples
    $script:cBody  = [System.Drawing.Color]::FromArgb(210,210,210)   # light grey - body text
    $script:cDim  = [System.Drawing.Color]::FromArgb(120,120,130)   # dim  - separators/minor
    $script:cWarn  = [System.Drawing.Color]::FromArgb(220,80,80)     # red  - warnings
    $script:cUrl  = [System.Drawing.Color]::FromArgb(100,180,255)   # link blue - URLs
    $nl = "`n"

    # Helper: section header
    $H = { param($t)
        &$rtb_Append $rtb $nl $script:cSep
        &$rtb_Append $rtb "  $t`n" $cTitle $true
        &$rtb_Append $rtb ("  " + ([string][char]0x2500)*60 + $nl) $cSep
    }
    # Helper: key+value line
    $KV = { param($k,$v)
        &$rtb_Append $rtb "  $k" $cKey
        &$rtb_Append $rtb "  $v$nl" $cBody
    }
    # Helper: code line
    $Code = { param($t)
        &$rtb_Append $rtb "    $t$nl" $cCode
    }
    # Helper: body line
    $B = { param($t)
        &$rtb_Append $rtb "  $t$nl" $cBody
    }

    # -- TITLE ----------------------------------------------------------
    &$rtb_Append $rtb "  QuasSafe v5.03" $cTitle $true
    if ($global:lang -eq 'RU') {
        &$rtb_Append $rtb "  --  Менеджер шифрованных учётных данных$nl" $cBody
    } else {
        &$rtb_Append $rtb "  --  Universal Encrypted Credentials Manager$nl" $cBody
    }
    &$rtb_Append $rtb "  (c) 2026 Varset & Gemini Dev$nl" $cDim

    if ($global:lang -eq 'RU') {

    # -- RU HELP -----------------------------------------------------------
    &$H "ОБЗОР"
    &$B "QuasSafe шифрует произвольный текст (учётные данные, скрипты,"
    &$B "команды) и хранит их в реестре Windows или в файле-хранилище."
    &$B "Расшифровка всегда требует пароля. Утерянный пароль = данные"
    &$B "НЕВОЗМОЖНО ВОССТАНОВИТЬ."
    &$rtb_Append $rtb $nl $script:cBody

    &$H "КРИПТОГРАФИЯ"
    &$KV "Алгоритм  :" "AES-256-CBC"
    &$KV "KDF       :" "PBKDF2-SHA256, 100 000 итераций"
    &$KV "Контроль  :" "HMAC-SHA256  (Encrypt-then-MAC)"
    &$KV "Соль      :" "16 случайных байт на ключ, хранится в blob"
    &$KV "IV        :" "16 случайных байт на шифрование, хранится в blob"
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  Структура blob  " $cDim
    &$rtb_Append $rtb "[16 Б Соль]" $cVal
    &$rtb_Append $rtb " [16 Б IV]" $cVal
    &$rtb_Append $rtb " [32 Б HMAC]" $cVal
    &$rtb_Append $rtb " [Шифртекст]$nl" $cVal
    &$B "HMAC проверяется ДО расшифровки — защита от подмены данных."

    &$H "ФОРМАТ ХРАНЕНИЯ"
    &$KV "Реестр    :" "HKCU:\Software\Quas\Credentials"
    &$KV "vault.txt :" "Текстовый файл, JSON-записи (payload зашифрован AES)"
    &$KV "vault.enc :" "Весь файл зашифрован мастер-паролем"
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb ('  {"Hint":"...","Desc":"...","Data":"<Base64>","OutFile":"...","Run":false,"Ver":4}' + $nl) $script:cCode

    &$H "КНОПКИ GUI"
    &$KV "НОВЫЙ КЛЮЧ           " "Открыть редактор для создания нового ключа."
    &$KV "Удалить              " "Безвозвратно удалить выбранный ключ из реестра."
    &$KV "Экспорт ключа (Txt)  " "Добавить выбранный ключ (JSON) в vault.txt."
    &$KV "Экспорт всех (Txt)   " "Добавить все ключи в vault.txt."
    &$KV "Экспорт (Enc)        " "Зашифровать всё хранилище мастер-паролем -> vault.enc."
    &$KV "Импорт (Enc)         " "Расшифровать vault.enc и восстановить ключи."
    &$KV "Импорт (Txt)         " "Импортировать ключи из файла vault.txt."
    &$KV "ПРОСМОТР / ПРАВКА    " "Расшифровать ключ и открыть в редакторе."
    &$KV "РАСШИФРОВАТЬ         " "Расшифровать ключ и выполнить действие."
    &$KV "Копировать Payload   " "Скопировать blob в буфер обмена (для CMD)."
    &$KV "Тема                 " "Переключить тёмную / светлую тему."

    &$H "ПОЛЯ РЕДАКТОРА КЛЮЧЕЙ"
    &$KV "Имя *         " "Уникальный идентификатор ключа."
    &$KV "Payload *     " "Секретный текст для шифрования."
    &$KV "Выходной файл " "Файл, создаваемый при расшифровке (напр. set_creds.bat)."
    &$KV "Описание      " "Заметка, видимая в главном окне."
    &$KV "Подсказка     " "Текст в диалоге ввода пароля."
    &$KV "Пароль *      " "Пароль шифрования (с подтверждением)."
    &$rtb_Append $rtb "  Режим вывода:$nl" $cTitle
    &$KV "    Файл      " "Payload записывается в указанный файл."
    &$KV "    Поток     " "Вывод в консоль PowerShell, без файла."
    &$KV "    Буфер     " "Копируется в буфер обмена, автоочистка 30 сек."
    &$rtb_Append $rtb "  Сохранить в:  " $cTitle
    &$rtb_Append $rtb "Реестр (Reg) или vault.txt (File)$nl" $cBody
    &$B "  Запустить файл: открыть файл сразу после расшифровки."
    &$B "  При закрытии с несохранёнными изменениями — запрос подтверждения."

    &$H "ОКНО ВВОДА ПАРОЛЯ"
    &$KV "Попытки      :" "Максимум 3."
    &$KV "Rate-limiting:" "Задержки перед попытками: 0 с / 2 с / 5 с"
    &$KV "Автозакрытие :" "Через 60 секунд."
    &$KV "Память       :" "Строка пароля обнуляется сразу после использования."

    &$H "ФАЙЛЫ ХРАНИЛИЩА"
    &$rtb_Append $rtb "  vault.txt$nl" $cVal
    &$B "  Текстовый файл, одна запись на строку. Payload зашифрован AES."
    &$B "  Безопасно хранить и передавать. Пароли ключей по-прежнему нужны."
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  vault.enc$nl" $cVal
    &$B "  Всё хранилище зашифровано мастер-паролем."
    &$B "  Используйте Экспорт (Enc) для создания, Импорт (Enc) для восстановления."
    &$rtb_Append $rtb $nl $script:cBody
    &$B "  Расшифровка vault.enc через CLI:"
    &$Code ".\QuasSafe5.03.ps1 -Decrypt -payloadFile `"vault.enc`" -Stream"

    &$H "ПАРАМЕТРЫ CLI"
    &$KV "-Encrypt          " "Режим шифрования."
    &$KV "-Decrypt          " "Режим расшифровки."
    &$KV "-ToReg            " "Сохранить в реестр."
    &$KV "-ToFile           " "Добавить в vault.txt."
    &$KV "-keyName  <str>   " "Имя ключа в реестре."
    &$KV "-payload  <str>   " "Blob (Base64) для расшифровки."
    &$KV "-payloadFile <p>  " "Путь к файлу с blob."
    &$KV "-hint     <str>   " "Подсказка для пароля."
    &$KV "-desc     <str>   " "Описание ключа."
    &$KV "-pass     <SS>    " "Пароль как SecureString."
    &$KV "-outFile  <str>   " "Имя выходного файла."
    &$KV "-Stream           " "Вывод в консоль, без файла."
    &$KV "-Clip             " "Скопировать в буфер обмена (30 с)."
    &$KV "-Run              " "Запустить выходной файл."
    &$KV "-lang     <EN|RU> " "Язык интерфейса (по умолчанию EN)."
    &$KV "-returnString     " "Вернуть строку как объект PS."

    &$H "ПРИМЕРЫ CLI"
    &$rtb_Append $rtb "  1. Шифрование (интерактивный ввод пароля):$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Encrypt -ToReg -keyName "App" -lang RU `'
    &$Code '    -payload "set LOGIN=admin&set PASS=s3cr3t" `'
    &$Code '    -outFile "set_creds.bat" -hint "Кличка питомца"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  2. Шифрование (автоматическое, SecureString):$nl" $cBody
    &$Code '$sp = ConvertTo-SecureString "Pwd" -AsPlainText -Force'
    &$Code '.\QuasSafe5.03.ps1 -Encrypt -ToReg -keyName "App" -pass $sp `'
    &$Code '    -payload "set LOGIN=admin" -outFile "creds.bat"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  3. Расшифровка в файл (по умолчанию):$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Decrypt -keyName "App"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  4. Расшифровка в консоль:$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Decrypt -keyName "App" -Stream'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  5. Blob из переменной CMD:$nl" $cBody
    &$Code 'set "payload=<Base64 из кнопки Копировать Payload>"'
    &$Code 'powershell -NoProfile -ExecutionPolicy Bypass -File "QuasSafe5.03.ps1" ^'
    &$Code '    -Decrypt -payload "%payload%" -outFile "set_creds.bat"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  6. Расшифровка vault.enc:$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Decrypt -payloadFile "vault.enc" -Stream'

    &$H "ИНТЕГРАЦИЯ С CMD"
    &$rtb_Append $rtb "  Вариант А -- через set_creds.bat:$nl" $cBody
    &$Code ':_Decryption'
    &$Code 'powershell -NoProfile -ExecutionPolicy Bypass -File "QuasSafe5.03.ps1" ^'
    &$Code '    -Decrypt -keyName "App"'
    &$Code 'if %errorlevel% equ 0 ('
    &$Code '    if exist "set_creds.bat" ( call "set_creds.bat" & del /f /q "set_creds.bat" )'
    &$Code ') else ( echo Доступ запрещён. && pause && exit )'
    &$Code 'exit /b'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  Вариант Б -- blob в переменной CMD:$nl" $cBody
    &$Code 'set "payload=<Base64 blob>"'
    &$Code 'powershell ... -Decrypt -payload "%payload%" -outFile "set_creds.bat"'

    } else {

    # -- EN HELP -----------------------------------------------------------
    &$H "OVERVIEW"
    &$B "QuasSafe encrypts arbitrary text (credentials, scripts, commands)"
    &$B "and stores it in the Windows Registry (HKCU) or in a vault file."
    &$B "Decryption always requires a password -- nothing is stored in"
    &$B "plain text. Lost password = data is UNRECOVERABLE."
    &$rtb_Append $rtb $nl $script:cBody

    &$H "CRYPTOGRAPHY"
    &$KV "Algorithm :" "AES-256-CBC"
    &$KV "KDF       :" "PBKDF2-SHA256, 100 000 iterations"
    &$KV "Integrity :" "HMAC-SHA256  (Encrypt-then-MAC)"
    &$KV "Salt      :" "16 random bytes per key, stored inside blob"
    &$KV "IV        :" "16 random bytes per encryption, stored inside blob"
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  Blob layout  " $cDim
    &$rtb_Append $rtb "[16 B Salt]" $cVal
    &$rtb_Append $rtb " [16 B IV]" $cVal
    &$rtb_Append $rtb " [32 B HMAC]" $cVal
    &$rtb_Append $rtb " [Ciphertext]$nl" $cVal
    &$B "HMAC is verified BEFORE decryption -- tamper detection."

    &$H "STORAGE FORMAT"
    &$KV "Registry  :" "HKCU:\Software\Quas\Credentials"
    &$KV "vault.txt :" "Plain text -- one JSON record per line (payload AES-encrypted)"
    &$KV "vault.enc :" "Entire file AES-256 encrypted with a master password"
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb ('  {"Hint":"...","Desc":"...","Data":"<Base64>","OutFile":"...","Run":false,"Ver":4}' + $nl) $script:cCode

    &$H "GUI BUTTONS"
    &$KV "ADD NEW KEY      " "Open the Key Editor to create a new entry."
    &$KV "Delete Selected  " "Permanently remove the selected key from the registry."
    &$KV "Export Key (Txt) " "Append selected key (encrypted JSON) to vault.txt."
    &$KV "Export ALL (Txt) " "Append all keys (encrypted JSON) to vault.txt."
    &$KV "Export  (Enc)    " "Encrypt entire vault with a master password -> vault.enc."
    &$KV "Import  (Enc)    " "Decrypt vault.enc with master password, restore all keys."
    &$KV "Import  (Txt)    " "Import JSON keys from a plain vault.txt file."
    &$KV "VIEW / EDIT KEY  " "Decrypt selected key, open in editor. Re-save to update."
    &$KV "RUN DECRYPTOR    " "Decrypt selected key and execute stored action."
    &$KV "Copy Payload     " "Copy encrypted Data blob to clipboard (for CMD use)."
    &$KV "Theme            " "Toggle Dark / Light colour theme."

    &$H "KEY EDITOR FIELDS"
    &$KV "Name *       " "Unique key identifier (registry value name)."
    &$KV "Payload *    " "The secret text to encrypt."
    &$KV "Output File  " "Filename created on decryption (e.g. set_creds.bat)."
    &$KV "Description  " "Human-readable note visible in the main window."
    &$KV "Hint         " "Text shown in the password prompt."
    &$KV "Password *   " "Encryption password (confirmed by second field)."
    &$rtb_Append $rtb "  Output mode:$nl" $cTitle
    &$KV "    File      " "Decrypt payload into the specified Output File."
    &$KV "    Stream    " "Print decrypted text to the PowerShell console."
    &$KV "    Clipboard " "Copy to clipboard; auto-cleared after 30 seconds."
    &$rtb_Append $rtb "  Save to:  " $cTitle
    &$rtb_Append $rtb "Reg = Windows Registry  |  File = vault.txt$nl" $cBody
    &$B "  Run File: launch output file after decryption."
    &$B "  Unsaved changes prompt shown on editor close."

    &$H "PASSWORD PROMPT SECURITY"
    &$KV "Attempts   :" "3 maximum."
    &$KV "Rate-limit :" "Delay before each attempt:  0 s / 2 s / 5 s"
    &$KV "Auto-close :" "Form closes automatically after 60 seconds."
    &$KV "Memory     :" "Password string zeroed immediately after use."

    &$H "VAULT FILES"
    &$rtb_Append $rtb "  vault.txt$nl" $cVal
    &$B "  Plain text, one key per line. Payloads are AES-encrypted."
    &$B "  Safe to back up or share -- individual passwords still required."
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  vault.enc$nl" $cVal
    &$B "  Entire vault encrypted with a master password."
    &$B "  Use Export (Enc) to create, Import (Enc) to restore."
    &$rtb_Append $rtb $nl $script:cBody
    &$B "  Decrypt vault.enc via CLI:"
    &$Code ".\QuasSafe5.03.ps1 -Decrypt -payloadFile `"vault.enc`" -Stream"

    &$H "CLI PARAMETERS"
    &$KV "-Encrypt          " "Encryption mode."
    &$KV "-Decrypt          " "Decryption mode."
    &$KV "-ToReg            " "Save result to registry."
    &$KV "-ToFile           " "Append result to vault.txt."
    &$KV "-keyName  <str>   " "Key name in the registry."
    &$KV "-payload  <str>   " "Data blob (Base64) to decrypt."
    &$KV "-payloadFile <p>  " "Path to file containing the Data blob."
    &$KV "-hint     <str>   " "Password hint shown during decryption."
    &$KV "-desc     <str>   " "Description stored with the key."
    &$KV "-pass     <SS>    " "Password as SecureString."
    &$KV "-outFile  <str>   " "Output filename for decrypted data."
    &$KV "-Stream           " "Print decrypted data to console; no file."
    &$KV "-Clip             " "Copy decrypted data to clipboard (30 s)."
    &$KV "-Run              " "Execute / open the output file after decryption."
    &$KV "-lang     <EN|RU> " "Interface language (default: EN)."
    &$KV "-returnString     " "Return decrypted string as PS object."

    &$H "CLI EXAMPLES"
    &$rtb_Append $rtb "  1. Encrypt (interactive password prompt):$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Encrypt -ToReg -keyName "App" `'
    &$Code '    -payload "set LOGIN=admin&set PASS=s3cr3t" `'
    &$Code '    -outFile "set_creds.bat" -hint "Pet name"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  2. Encrypt (silent, SecureString):$nl" $cBody
    &$Code '$sp = ConvertTo-SecureString "Pwd" -AsPlainText -Force'
    &$Code '.\QuasSafe5.03.ps1 -Encrypt -ToReg -keyName "App" -pass $sp `'
    &$Code '    -payload "set LOGIN=admin" -outFile "creds.bat"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  3. Decrypt to file (default):$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Decrypt -keyName "App"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  4. Decrypt to console (Stream):$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Decrypt -keyName "App" -Stream'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  5. Decrypt blob from CMD variable:$nl" $cBody
    &$Code 'set "payload=<Base64 from Copy Payload button>"'
    &$Code 'powershell -NoProfile -ExecutionPolicy Bypass -File "QuasSafe5.03.ps1" ^'
    &$Code '    -Decrypt -payload "%payload%" -outFile "set_creds.bat"'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  6. Decrypt vault.enc:$nl" $cBody
    &$Code '.\QuasSafe5.03.ps1 -Decrypt -payloadFile "vault.enc" -Stream'

    &$H "CMD INTEGRATION"
    &$rtb_Append $rtb "  Pattern A -- via set_creds.bat:$nl" $cBody
    &$Code ':_Decryption'
    &$Code 'powershell -NoProfile -ExecutionPolicy Bypass -File "QuasSafe5.03.ps1" ^'
    &$Code '    -Decrypt -keyName "App"'
    &$Code 'if %errorlevel% equ 0 ('
    &$Code '    if exist "set_creds.bat" ( call "set_creds.bat" & del /f /q "set_creds.bat" )'
    &$Code ') else ( echo Access Denied. && pause && exit )'
    &$Code 'exit /b'
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb "  Pattern B -- blob in CMD variable:$nl" $cBody
    &$Code 'set "payload=<Base64 blob from Copy Payload>"'
    &$Code 'powershell ... -Decrypt -payload "%payload%" -outFile "set_creds.bat"'

    } # end language switch

    # -- FOOTER ------------------------------------------------------------
    &$rtb_Append $rtb $nl $script:cBody
    &$rtb_Append $rtb ("  " + ([string][char]0x2500)*60 + $nl) $script:cSep
    if ($global:lang -eq 'RU') {
        &$rtb_Append $rtb "  Пароли НИКОГДА не хранятся. Утерян пароль = утеряны данные.$nl" $script:cWarn
    } else {
        &$rtb_Append $rtb "  Passwords are NEVER stored. Lost password = lost data.$nl" $script:cWarn
    }
    &$rtb_Append $rtb ("  " + ([string][char]0x2500)*60 + $nl) $script:cSep
    &$rtb_Append $rtb $nl $script:cBody
    if ($global:lang -eq 'RU') {
        &$rtb_Append $rtb "  Полная документация (RU / EN):$nl" $script:cBody
    } else {
        &$rtb_Append $rtb "  Full documentation (RU / EN):$nl" $script:cBody
    }
    &$rtb_Append $rtb "  https://github.com/Varsett/QuasSafe$nl" $script:cUrl

    $rtb.SelectionStart = 0; $rtb.ScrollToCaret()
    $hf.ShowDialog()
})

$btnTheme = New-Object System.Windows.Forms.Button
$btnTheme.Text = T "btn.theme"; $btnTheme.Location = "450,12"; $btnTheme.Size = "75,22"
$btnTheme.Add_Click({ $global:isDark = if ($global:isDark -eq 1) { 0 } else { 1 }; Update-Theme $mainForm })

# --- Список ключей ---
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = "20,40"; $listBox.Size = "350,258"
$listBox.Font = Get-SafeFont "Consolas" 10; $listBox.BorderStyle = "FixedSingle"

# --- Описание ---
$grpDesc = New-Object System.Windows.Forms.GroupBox
$grpDesc.Text = T "main.desc"; $grpDesc.Location = "20,306"; $grpDesc.Size = "350,72"
$txtDesc = New-Object System.Windows.Forms.TextBox
$txtDesc.Location = "10,14"; $txtDesc.Size = "330,55"; $txtDesc.Multiline=$true; $txtDesc.ReadOnly=$true; $txtDesc.BorderStyle="None"
$grpDesc.Controls.Add($txtDesc)


# --- Обновление списка ---
$UpdateList = {
    $currentName = $listBox.SelectedItem
    $listBox.Items.Clear(); $txtDesc.Clear()
    if (Test-Path $regPath) {
        $props = Get-ItemProperty $regPath
        $props.PSObject.Properties |
            Where-Object { $_.Name -notmatch "PSPath|PSParentPath|PSChildName|PSDrive|PSProvider" } |
            ForEach-Object { [void]$listBox.Items.Add($_.Name) }
    }
    if ($currentName -and $listBox.Items.Contains($currentName)) { $listBox.SelectedItem = $currentName }
    elseif ($listBox.Items.Count -gt 0) { $listBox.SelectedIndex = 0 }
}

$listBox.Add_SelectedIndexChanged({
    if ($listBox.SelectedItem) {
        $val = (Get-ItemProperty $regPath -Name $listBox.SelectedItem).$($listBox.SelectedItem)
        $rec = Read-KeyJson $val
        $txtDesc.Text = if ($rec -and $rec.Desc) { $rec.Desc } else { "No description." }
    }
})

# ============================================================
#  EDITOR
# ============================================================
$ShowKeyEditor = {
    param($initData = $null)
    $a = New-Object System.Windows.Forms.Form
    $a.Text = if ($initData) { T "ed.edit" } else { T "ed.create" }
    $a.Size = "450,800"; $a.StartPosition = "CenterParent"
    Set-QuasIcon $a
    $ancLTR = [System.Windows.Forms.AnchorStyles] "Left, Top, Right"
    $colors = if ($global:isDark) { $theme.Dark } else { $theme.Light }

    $cL = { param($t,$y) $l=New-Object System.Windows.Forms.Label; $l.Text=$t; $l.Location="20,$y"; $l.AutoSize=$true; $a.Controls.Add($l); return $l }

    &$cL (T "ed.name") 10
    $tN = New-Object System.Windows.Forms.TextBox; $tN.Location="20,30"; $tN.Size="390,25"; $tN.Anchor=$ancLTR; $a.Controls.Add($tN)

    &$cL (T "ed.payload") 65
    $tP = New-Object System.Windows.Forms.TextBox; $tP.Location="20,85"; $tP.Size="390,120"; $tP.Multiline=$true; $tP.ScrollBars="Vertical"; $tP.Anchor=$ancLTR; $a.Controls.Add($tP)

    $lblOut = &$cL (T "ed.outfile") 215
    $tO = New-Object System.Windows.Forms.TextBox; $tO.Location="20,235"; $tO.Size="390,25"; $tO.Anchor=$ancLTR; $a.Controls.Add($tO)

    &$cL (T "ed.desc") 270
    $tD = New-Object System.Windows.Forms.TextBox; $tD.Location="20,290"; $tD.Size="390,40"; $tD.Multiline=$true; $tD.Anchor=$ancLTR; $a.Controls.Add($tD)

    &$cL (T "ed.hint") 340
    $tH = New-Object System.Windows.Forms.TextBox; $tH.Location="20,360"; $tH.Size="390,25"; $tH.Anchor=$ancLTR; $a.Controls.Add($tH)

    &$cL (T "ed.pass") 395
    $p1 = New-Object System.Windows.Forms.TextBox; $p1.PasswordChar='*'; $p1.Location="20,415"; $p1.Size="180,25"; $a.Controls.Add($p1)
    $lConfirm = New-Object System.Windows.Forms.Label
    $lConfirm.Text = T "ed.confirm"; $lConfirm.Location = "210,395"; $lConfirm.AutoSize = $true; $a.Controls.Add($lConfirm)
    $p2 = New-Object System.Windows.Forms.TextBox; $p2.PasswordChar='*'; $p2.Location="210,415"; $p2.Size="200,25"; $p2.Anchor=$ancLTR; $a.Controls.Add($p2)

    # Output Mode
    $grpMode = New-Object System.Windows.Forms.GroupBox; $grpMode.Text=T "ed.outmode"; $grpMode.Location="20,455"; $grpMode.Size="390,55"; $grpMode.Anchor=$ancLTR
    $rbStream   = New-Object System.Windows.Forms.RadioButton; $rbStream.Text=T "ed.stream";   $rbStream.Location="20,20";   $rbStream.AutoSize=$true
    $rbFileMode = New-Object System.Windows.Forms.RadioButton; $rbFileMode.Text=T "ed.file";   $rbFileMode.Location="120,20"; $rbFileMode.AutoSize=$true; $rbFileMode.Checked=$true
    $rbClipMode = New-Object System.Windows.Forms.RadioButton; $rbClipMode.Text=T "ed.clipboard"; $rbClipMode.Location="200,20"; $rbClipMode.AutoSize=$true
    $grpMode.Controls.AddRange(@($rbStream, $rbFileMode, $rbClipMode)); $a.Controls.Add($grpMode)

    # Save to
    $grpSave = New-Object System.Windows.Forms.GroupBox; $grpSave.Text=T "ed.saveto"; $grpSave.Location="20,520"; $grpSave.Size="190,55"
    $rbR = New-Object System.Windows.Forms.RadioButton; $rbR.Text=T "ed.reg";  $rbR.Location="10,20"; $rbR.AutoSize=$true; $rbR.Checked=$true; $grpSave.Controls.Add($rbR)
    $rbF = New-Object System.Windows.Forms.RadioButton; $rbF.Text=T "ed.file"; $rbF.Location="100,20"; $rbF.AutoSize=$true; $grpSave.Controls.Add($rbF); $a.Controls.Add($grpSave)

    # After Decrypt
    $lblAD  = New-Object System.Windows.Forms.Label; $lblAD.Text=T "ed.afterdec"; $lblAD.Location="227,520"; $lblAD.AutoSize=$true; $a.Controls.Add($lblAD)
    $grpRun = New-Object System.Windows.Forms.GroupBox; $grpRun.Text=""; $grpRun.Location="220,520"; $grpRun.Size="190,55"; $grpRun.Anchor=$ancLTR
    $cbRun  = New-Object System.Windows.Forms.CheckBox; $cbRun.Text=T "ed.runfile"; $cbRun.Location="10,20"; $cbRun.AutoSize=$true
    $grpRun.Controls.Add($cbRun); $a.Controls.Add($grpRun)

    # Toggle Stream/Clip/File
    $ToggleMode = {
        $isStream = $rbStream.Checked -or $rbClipMode.Checked
        $tO.Enabled      = !$isStream
        $grpRun.Enabled  = !$isStream
        $targetColor = if ($isStream) { $colors.gray } else { $colors.fg }
        $lblOut.ForeColor = $targetColor
        $lblAD.ForeColor  = $targetColor
        $tO.BackColor     = if ($isStream) { $colors.db } else { $colors.lb }
        Update-Theme $a
    }
    $rbStream.Add_CheckedChanged($ToggleMode)
    $rbClipMode.Add_CheckedChanged($ToggleMode)

    # --- Dirty tracking ---
    $script:editorDirty = $false
    $script:editorSaved = $false
    $markDirty = { $script:editorDirty = $true }
    $tN.Add_TextChanged($markDirty)
    $tP.Add_TextChanged($markDirty)
    $tO.Add_TextChanged($markDirty)
    $tD.Add_TextChanged($markDirty)
    $tH.Add_TextChanged($markDirty)
    $p1.Add_TextChanged($markDirty)
    $cbRun.Add_CheckedChanged($markDirty)
    $rbStream.Add_CheckedChanged($markDirty)
    $rbFileMode.Add_CheckedChanged($markDirty)
    $rbClipMode.Add_CheckedChanged($markDirty)
    $rbR.Add_CheckedChanged($markDirty)
    $rbF.Add_CheckedChanged($markDirty)

    if ($initData) {
        $tN.Text = $initData.Name; $tP.Text = $initData.Payload; $tO.Text = $initData.OutFile
        $tD.Text = $initData.Desc; $tH.Text = $initData.Hint; $cbRun.Checked = $initData.Run
        if ($initData.OutFile -eq "STREAM_MODE") { $rbStream.Checked = $true; &$ToggleMode }
        elseif ($initData.OutFile -eq "CLIPBOARD_MODE") { $rbClipMode.Checked = $true; &$ToggleMode }
    }
    # Reset dirty flag after fields are populated (init changes don't count)
    $script:editorDirty = $false

    # SAVE
    $btnS = New-Object System.Windows.Forms.Button
    $btnS.Text=T "ed.save"; $btnS.Location="20,595"; $btnS.Size="390,40"; $btnS.Tag="green"
    $btnS.Font=Get-SafeFont "Arial" 9 "Bold"; $btnS.Anchor=$ancLTR
    $btnS.Add_Click({
        if (!$tN.Text -or !$tP.Text -or !$p1.Text) { [void][Windows.Forms.MessageBox]::Show((T "ed.mandatory")); return }
        if (!$rbStream.Checked -and !$rbClipMode.Checked -and !$tO.Text) { [void][Windows.Forms.MessageBox]::Show((T "ed.outreq")); return }
        if ($p1.Text -ne $p2.Text) { [void][Windows.Forms.MessageBox]::Show((T "ed.mismatch")); return }

        $plainPass = $p1.Text.Trim()
        $blob = $null
        try {
            $blob = Protect-Payload -plainText $tP.Text.Trim() -password $plainPass
        } catch {
            [void][Windows.Forms.MessageBox]::Show((T "err.encrypt" $_), "Error", 0, 16)
        }
        # [#4] Затереть поля паролей в любом случае
        Clear-TextBoxSecure $p1; Clear-TextBoxSecure $p2
        $plainPass = $null

        if (-not $blob) { return }

        $finalOut = if ($rbStream.Checked) { "STREAM_MODE" } elseif ($rbClipMode.Checked) { "CLIPBOARD_MODE" } else { $tO.Text.Trim() }
        $runBit   = if ($cbRun.Checked -and $rbFileMode.Checked) { $true } else { $false }
        $jsonStr  = ConvertTo-KeyJson -hint $tH.Text -desc $tD.Text -dataB64 $blob -outFile $finalOut -run $runBit

        if ($rbR.Checked) {
            if (!(Test-Path $regPath)) { New-Item $regPath -Force | Out-Null }
            Set-ItemProperty $regPath $tN.Text $jsonStr
        } else {
            "$($tN.Text) = $jsonStr" | Out-File "vault.txt" -Append -Encoding utf8
        }
        $script:editorSaved = $true; $a.Close(); &$UpdateList
    })
    $a.Add_FormClosing({
        param($sender, $e)
        if ($script:editorDirty -and -not $script:editorSaved) {
            $ans = [Windows.Forms.MessageBox]::Show(
                (T "ed.unsaved"),
                (T "ed.unsaved.title"), 4, 32)
            if ($ans -ne "Yes") { $e.Cancel = $true }
        }
    })
    $a.Controls.Add($btnS); Update-Theme $a; $a.ShowDialog()
}

# ============================================================
#  КНОПКИ ГЛАВНОЙ ФОРМЫ
# ============================================================
# --- Сетка правой колонки: все кнопки одинаковые 170x28, шаг 32px ---
# ADD NEW KEY   - y=40  (выделена, чуть выше и крупнее)
# ------------- разделитель
# Delete        - y=82
# Export->txt  - y=114
# ExportALL->txt-y=146
# Export->enc  - y=178
# Import<-enc  - y=210
# Import txt    - y=242
# ------------- разделитель
# VIEW/EDIT     - y=278
# RUN DECRYPTOR - y=314

$btnAdd = New-Object System.Windows.Forms.Button
$btnAdd.Text = T "btn.add"; $btnAdd.Location = "390,40"; $btnAdd.Size = "170,35"; $btnAdd.Tag = "accent"
$btnAdd.Font = Get-SafeFont "Arial" 8 "Bold"
$btnAdd.Add_Click({ &$ShowKeyEditor })

$btnDel = New-Object System.Windows.Forms.Button
$btnDel.Text = T "btn.del"; $btnDel.Location = "390,82"; $btnDel.Size = "170,28"; $btnDel.Tag = "danger"
$btnDel.Add_Click({
    if ($listBox.SelectedItem) {
        if ([Windows.Forms.MessageBox]::Show((T "btn.del.confirm"), (T "btn.del.title"), 4, 32) -eq "Yes") {
            Remove-ItemProperty $regPath $listBox.SelectedItem; &$UpdateList
        }
    }
})

$btnExp = New-Object System.Windows.Forms.Button
$btnExp.Text = T "btn.expkey"; $btnExp.Location = "390,114"; $btnExp.Size = "170,28"
$btnExp.Add_Click({
    if ($listBox.SelectedItem) {
        $v = (Get-ItemProperty $regPath $listBox.SelectedItem).$($listBox.SelectedItem)
        "$($listBox.SelectedItem) = $v" | Out-File "vault.txt" -Append -Encoding utf8
        [void][Windows.Forms.MessageBox]::Show((T "vault.exp.keyok"))
    }
})

$btnExpA = New-Object Windows.Forms.Button
$btnExpA.Text = T "btn.expall"; $btnExpA.Location = "390,146"; $btnExpA.Size = "170,28"
$btnExpA.Add_Click({
    if (Test-Path $regPath) {
        (Get-ItemProperty $regPath).PSObject.Properties |
            Where-Object { $_.Name -notmatch "^PS" } |
            ForEach-Object { "$($_.Name) = $($_.Value)" | Out-File "vault.txt" -Append -Encoding utf8 }
        [void][Windows.Forms.MessageBox]::Show((T "vault.exp.allok"))
    }
})

# [#12] Кнопки зашифрованного vault
$btnExpSec = New-Object Windows.Forms.Button
$btnExpSec.Text = T "btn.expsec"; $btnExpSec.Location = "390,178"; $btnExpSec.Size = "170,28"
$btnExpSec.Add_Click({ Export-VaultSecure "vault.enc" })

$btnImpSec = New-Object Windows.Forms.Button
$btnImpSec.Text = T "btn.impsec"; $btnImpSec.Location = "390,210"; $btnImpSec.Size = "170,28"
$btnImpSec.Add_Click({
    $fd = New-Object Windows.Forms.OpenFileDialog; $fd.Filter = "Encrypted vault|*.enc|All files|*.*"
    if ($fd.ShowDialog() -eq "OK") { Import-VaultSecure $fd.FileName; &$UpdateList }
})

$btnImp = New-Object System.Windows.Forms.Button
$btnImp.Text = T "btn.imptxt"; $btnImp.Location = "390,242"; $btnImp.Size = "170,28"
$btnImp.Add_Click({
    $fd = New-Object Windows.Forms.OpenFileDialog; $fd.Filter = "Text vault|*.txt|All files|*.*"
    if ($fd.ShowDialog() -eq "OK") {
        Get-Content $fd.FileName | ForEach-Object {
            if ($_ -match "^(.+?)\s?=\s?(\{.+\})$") {
                $name = $Matches[1].Trim(); $json = $Matches[2].Trim()
                try {
                    $null = $json | ConvertFrom-Json   # validate JSON
                    if (!(Test-Path $regPath)) { New-Item $regPath -Force | Out-Null }
                    Set-ItemProperty $regPath $name $json
                } catch { Write-Warning "Skipped invalid entry: $name" }
            }
        }
        &$UpdateList
    }
})

$btnView = New-Object System.Windows.Forms.Button
$btnView.Text = T "btn.view"; $btnView.Location = "390,278"; $btnView.Size = "170,28"; $btnView.Tag = "accent"
$btnView.Font = Get-SafeFont "Arial" 8 "Bold"
$btnView.Add_Click({
    if ($listBox.SelectedItem) {
        $decrypted = Run-DecryptorEngine $listBox.SelectedItem -returnString
        if ($decrypted) {
            $val = (Get-ItemProperty $regPath -Name $listBox.SelectedItem).$($listBox.SelectedItem)
            $rec = Read-KeyJson $val
            $data = @{
                Name    = $listBox.SelectedItem
                Payload = $decrypted
                Hint    = $rec.Hint
                Desc    = $rec.Desc
                OutFile = $rec.OutFile
                Run     = $rec.Run
            }
            &$ShowKeyEditor $data
        }
    }
})

$btnDec = New-Object System.Windows.Forms.Button
$btnDec.Text = T "btn.dec"; $btnDec.Location = "390,314"; $btnDec.Size = "170,28"; $btnDec.Tag = "green"
$btnDec.Font = Get-SafeFont "Arial" 8 "Bold"
$btnDec.Add_Click({
    if ($listBox.SelectedItem) {
        $res = Run-DecryptorEngine $listBox.SelectedItem -returnString:($Stream -or $returnString)
        if ($res) { $res | Out-Host }
    }
})

# ============================================================
#  СБОРКА И ЗАПУСК
# ============================================================
# Кнопка копирования зашифрованного Data-blob в буфер обмена (для CMD)
$btnCopyBlob = New-Object System.Windows.Forms.Button
$btnCopyBlob.Text = T "btn.copy"; $btnCopyBlob.Location = "390,350"; $btnCopyBlob.Size = "170,28"
$btnCopyBlob.Add_Click({
    if ($listBox.SelectedItem) {
        $val = (Get-ItemProperty $regPath -Name $listBox.SelectedItem -ErrorAction SilentlyContinue).$($listBox.SelectedItem)
        if ($val) {
            $rec = Read-KeyJson $val
            if ($rec -and $rec.Data) {
                [System.Windows.Forms.Clipboard]::SetText($rec.Data)
                [void][Windows.Forms.MessageBox]::Show((T "copy.ok"), (T "copy.oktitle"))
            } else {
                [void][Windows.Forms.MessageBox]::Show((T "err.nodata"), "Error")
            }
        }
    }
})

$mainForm.Controls.AddRange(@(
    $lblTitle, $btnHelp, $btnTheme,
    $listBox, $grpDesc,
    $btnAdd, $btnDel,
    $btnExp, $btnExpA, $btnExpSec, $btnImpSec, $btnImp,
    $btnView, $btnDec, $btnCopyBlob
))

$mainForm.Add_FormClosing({
    param($sender, $e)
    $sender.DialogResult = [System.Windows.Forms.DialogResult]::OK
})
Update-Theme $mainForm
&$UpdateList
[void]$mainForm.ShowDialog()