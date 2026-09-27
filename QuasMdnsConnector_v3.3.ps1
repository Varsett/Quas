[CmdletBinding()]
param(
    [string]$WorkDir = "",

    [ValidateSet('EN','RU')]
    [string]$lang = 'EN',

    # Forces console (headless) mode even when no other console-tool
    # argument is present - resolves the ambiguity a batch launcher
    # otherwise can't express (e.g. "-lang RU" alone could mean either
    # "open the GUI in Russian" or "run the console tool in Russian").
    [switch]$console,

    # Any other CLI arguments (-autoconnect 0, -adapters, -listener, ...)
    # are caught here instead of causing a parameter-binding error.
    # Their presence means the caller wants the console tool, not the
    # GUI - see the pass-through block below, right after the embedded
    # script is extracted to disk.
    #
    # [CmdletBinding()] is required here: without it, $WorkDir (having
    # no explicit Position) is still eligible for *implicit* positional
    # binding, so a bare value like the "0" in "-autoconnect 0" gets
    # silently stolen by $WorkDir instead of staying paired with
    # "-autoconnect" in $PassThroughArgs. With [CmdletBinding()],
    # parameters bind positionally ONLY if given an explicit
    # [Parameter(Position=N)] - $WorkDir has none, so it becomes
    # named-only and stops intercepting stray values.
    #
    # NOTE: do NOT also declare an explicit [switch]$Verbose here -
    # [CmdletBinding()] already adds -Verbose as a common parameter,
    # and redeclaring a parameter with the same name as a common one
    # is a hard parse-time error ("already been defined"). -Verbose
    # is instead detected below via $PSBoundParameters.
    #
    # This must be the LAST parameter in the block - PowerShell's own
    # guidance for ValueFromRemainingArguments is that it should be
    # declared last, otherwise its interaction with other named/common
    # parameters (like -Verbose) can behave inconsistently.
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$PassThroughArgs
)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# [CmdletBinding()] sets $VerbosePreference = 'Continue' automatically
# whenever -Verbose is passed, which would otherwise leak into every
# cmdlet's own Write-Verbose output (e.g. NetAdapter module import
# noise during the PC interface scan below). Nothing in this wrapper
# relies on Write-Verbose, so resetting it back loses nothing.
$VerbosePreference = 'SilentlyContinue'

$script:Lang = $lang.ToUpper()

# Bilingual text helper for the wrapper's own UI (labels, buttons,
# status bar, Help dialog) - mirrors the T() helper embedded in the
# CLI tool below. -lang RU / -lang EN controls both.
function T {
    param(
        [string]$EN,
        [string]$RU
    )

    if ($script:Lang -eq 'RU') { return $RU }
    return $EN
}

$ScriptFileName = "quas-mdns_conn.ps1"

# Where to extract the embedded script to disk before launching it.
# Falls back to %TEMP% if -WorkDir is not supplied or not writable.
$ExtractDir = if ($WorkDir -ne "" -and (Test-Path -LiteralPath $WorkDir)) {
    $WorkDir.TrimEnd("\")
} else {
    $env:TEMP
}

# Where adb.exe is expected to live. The extracted target script
# sits in %TEMP% (no adb.exe there), so this is resolved
# separately: prefer the explicit -WorkDir, otherwise fall back
# to the folder this GUI script itself lives in.
$ToolsPath = if ($WorkDir -ne "" -and (Test-Path -LiteralPath $WorkDir)) {
    $WorkDir.TrimEnd("\")
} elseif ($PSScriptRoot -and (Test-Path -LiteralPath $PSScriptRoot)) {
    $PSScriptRoot
} else {
    ""
}

# ============================================================
# EMBEDDED TARGET SCRIPT
# The full quas-mdns tool is bundled here so the GUI has no
# external file dependency. It is written to disk once at
# startup and launched from there when Run is clicked.
# ============================================================

$EmbeddedScriptContent = @'
# ============================================================
# QUAS mDNS Connector v3.3
#
# PowerShell 5.1
#
# No external mDNS dependencies:
#   - Python          NOT required
#   - zeroconf        NOT required
#   - Bonjour         NOT required
#   - adb mdns        NOT required for discovery
#
# External dependency:
#   - adb.exe
#
# ============================================================

[CmdletBinding()]
param(
    [switch]$listener,
    [switch]$dumper,
    [switch]$adapters,
    [switch]$adbversion,
    [switch]$adbserver,
    [switch]$services,
    [switch]$help,

    [ValidateSet(0,1,2)]
    [int]$autoconnect = 0,

    [string]$IPPC = "",

    [string]$IPQuest = "",

    [ValidateRange(1,1000)]
    [int]$retries = 5,

    [ValidateRange(0,86400)]
    [int]$timeout = 0,

    [ValidateRange(0,86400)]
    [int]$retrydelay = 5,

    [string]$ToolsPath = "",

    [ValidateRange(0,3600)]
    [int]$TimeSleep = 5,

    [ValidateSet('EN','RU')]
    [string]$lang = 'EN'
)

# [CmdletBinding()] makes every parameter above named-only (no
# implicit positional binding), which is what prevents an odd
# stray value from being silently swallowed by the wrong switch
# when the arguments are splatted in from the GUI wrapper.
#
# -Verbose is intentionally NOT declared as our own [switch] above:
# [CmdletBinding()] already adds it as a common parameter, and
# redeclaring a parameter with the same name is a hard parse-time
# error ("already been defined"). Detected via $PSBoundParameters
# instead, same as -autoconnect further below.

$ErrorActionPreference = 'SilentlyContinue'

$script:Lang = $lang.ToUpper()

# Bilingual text helper - every user-facing string in this script is
# wrapped as (T "English" "Russian") so -lang RU / -lang EN switches
# the whole console output. Default is EN.
function T {
    param(
        [string]$EN,
        [string]$RU
    )

    if ($script:Lang -eq 'RU') { return $RU }
    return $EN
}

# PowerShell's built-in -Verbose is used as QUAS diagnostic mode.
# Do not let imported modules flood the console with their own verbose
# messages (e.g. "Export function ..." from Import-Module NetAdapter).
# [CmdletBinding()] sets $VerbosePreference = 'Continue' automatically
# whenever -Verbose is passed - that's what leaks into every other
# cmdlet's own Write-Verbose output. Our own diagnostics never use
# Write-Verbose (Write-Diagnostic below is plain Write-Host gated by
# $script:DiagnosticVerbose), so resetting the preference back here
# loses nothing.
$script:DiagnosticVerbose = $PSBoundParameters.ContainsKey('Verbose')
$VerbosePreference = 'SilentlyContinue'

# ============================================================
# CONSTANTS
# ============================================================

$script:ServiceType = '_adb-tls-connect._tcp.local'
$script:MulticastIP = '224.0.0.251'
$script:MDNSPort = 5353


# ============================================================
# DIAGNOSTIC OUTPUT
# ============================================================

function Write-Diagnostic {

    param(
        [string]$Message
    )

    if ($script:DiagnosticVerbose) {
        Write-Host $Message -ForegroundColor DarkGray
    }
}


# ============================================================
# EXIT / WINDOW CLOSE BEHAVIOR
# ============================================================
#
# The GUI launches this script without -NoExit so the console
# window can close itself once the work is done, instead of
# being left open and idle. -TimeSleep controls how:
#   0        - print "Press Enter to close..." and wait for it
#   1..3600  - print the close countdown and sleep that many
#              seconds, then exit on its own
#
function Wait-BeforeExit {

    Write-Host ''

    if ($TimeSleep -le 0) {
        Write-Host (T 'Press Enter to close this window...' 'Нажмите Enter, чтобы закрыть это окно...') -ForegroundColor DarkGray
        [void][Console]::In.ReadLine()
    }
    else {
        if ($script:Lang -eq 'RU') {
            Write-Host "Готово. Окно закроется автоматически через $TimeSleep сек..." -ForegroundColor DarkGray
        } else {
            $unit = if ($TimeSleep -eq 1) { 'second' } else { 'seconds' }
            Write-Host "Done. This window will close automatically in $TimeSleep $unit..." -ForegroundColor DarkGray
        }
        Start-Sleep -Seconds $TimeSleep
    }
}

function Exit-Quas {

    param(
        [int]$Code = 0
    )

    Wait-BeforeExit
    exit $Code
}


# ============================================================
# HELP
# ============================================================

function Show-Help {

    function HdrMain {
        param([string]$EN, [string]$RU)
        $t = T $EN $RU
        Write-Host ''
        Write-Host $t -ForegroundColor Yellow
        Write-Host ('-' * $t.Length) -ForegroundColor DarkGray
    }

    function HFlag {
        param([string]$Flag, [string]$EN, [string]$RU)
        Write-Host ("  {0,-24}{1}" -f $Flag, (T $EN $RU))
    }

    function HSub {
        param([string]$EN, [string]$RU)
        Write-Host ("  {0,-24}{1}" -f '', (T $EN $RU)) -ForegroundColor DarkGray
    }

    function HNote {
        param([string]$EN, [string]$RU)
        Write-Host ("  " + (T $EN $RU)) -ForegroundColor DarkGray
    }

    $border = '=' * 62

    Write-Host ''
    Write-Host $border -ForegroundColor DarkCyan
    Write-Host '  QUAS mDNS Connector v3.3 - Console commands' -ForegroundColor Cyan
    Write-Host '  (c) 2026 Varset' -ForegroundColor Blue
    Write-Host $border -ForegroundColor DarkCyan

    HdrMain 'MAIN MODES' 'ОСНОВНЫЕ РЕЖИМЫ'
    HNote 'Only ONE main mode can be selected at a time:' `
          'Одновременно может быть выбран только ОДИН основной режим:'
    Write-Host ''
    HFlag '-autoconnect 0|1|2' `
          'Discover the Quest over Wi-Fi via mDNS.' `
          'Обнаружить Quest по Wi-Fi через mDNS.'
    HSub  '0 = details only (no connect)' `
          '0 = только детали (без подключения)'
    HSub  '1 = details + connect' `
          '1 = детали + подключение'
    HSub  '2 = connect only (no details printed)' `
          '2 = только подключение (без деталей)'
    HFlag '-listener' `
          'Listen for mDNS packets (Enter to stop)' `
          'Слушать mDNS-пакеты (Enter - остановить)'
    HFlag '-dumper' `
          'Dump raw mDNS packets in hexadecimal (Enter to stop)' `
          'Дамп mDNS-пакетов в hex (Enter - остановить)'
    HFlag '-adapters' `
          'Show PC network adapters and IPv4 addresses' `
          'Показать сетевые адаптеры ПК и их IPv4-адреса'
    HFlag '-adbversion' `
          'Show ADB version information' `
          'Показать версию ADB'
    HFlag '-adbserver' `
          'Restart the ADB server and show its version' `
          'Перезапустить ADB-сервер и показать его версию'
    HFlag '-services' `
          'Show services reported by adb mdns services' `
          'Показать сервисы из adb mdns services'
    Write-Host ''
    HNote 'While -autoconnect is searching: Enter stops, Space retries now.' `
          'Во время поиска -autoconnect: Enter - стоп, Space - повтор сейчас.'
    HNote '-listener and -dumper: Enter stops.' `
          '-listener и -dumper: Enter - стоп.'

    HdrMain 'DISCOVERY OPTIONS' 'ПАРАМЕТРЫ ПОИСКА'
    HFlag '-retries <N>' `
          'Number of discovery/connection attempts' `
          'Число попыток поиска/подключения'
    HSub  'Default: 5. Requires -autoconnect.' `
          'По умолчанию: 5. Требует -autoconnect.'
    HFlag '-timeout <seconds>' `
          'Maximum time per discovery attempt' `
          'Максимальное время одной попытки'
    HSub  '0 = unlimited. Requires -autoconnect.' `
          '0 = без ограничения. Требует -autoconnect.'
    HFlag '-retrydelay <seconds>' `
          'Delay between retry attempts' `
          'Задержка между попытками'
    HSub  'Default: 5 seconds. Requires -autoconnect.' `
          'По умолчанию: 5 секунд. Требует -autoconnect.'

    HdrMain 'NETWORK OPTIONS' 'СЕТЕВЫЕ ПАРАМЕТРЫ'
    HFlag '-IPPC <IPv4>' `
          'Select the PC network interface by IPv4' `
          'Выбрать сетевой интерфейс ПК по IPv4'
    HSub  'Works with -autoconnect, -listener and -dumper.' `
          'Работает с -autoconnect, -listener и -dumper.'
    HFlag '-IPQuest <IPv4>' `
          'Accept mDNS packets only from this Quest IP' `
          'Принимать mDNS-пакеты только с этого IP Quest'
    HSub  'Works with -autoconnect, -listener and -dumper.' `
          'Работает с -autoconnect, -listener и -dumper.'

    HdrMain 'TOOLS / WINDOW' 'ИНСТРУМЕНТЫ / ОКНО'
    HFlag '-ToolsPath <path>' `
          'Folder containing adb.exe. Checked before' `
          'Папка с adb.exe. Проверяется раньше, чем'
    HSub  '%myfiles%, the script folder and PATH.' `
          '%myfiles%, папка скрипта и PATH.'
    HFlag '-TimeSleep <seconds>' `
          'Delay before the window closes itself' `
          'Задержка перед автоматическим закрытием окна'
    HSub  'after the command finishes. Default: 5.' `
          'после завершения команды. По умолчанию: 5.'
    HSub  '0 = wait for Enter instead of a timer.' `
          '0 = ждать Enter вместо таймера.'
    HFlag '-lang EN|RU' `
          'Interface language. Default: EN.' `
          'Язык интерфейса. По умолчанию: EN.'

    HdrMain 'DIAGNOSTICS' 'ДИАГНОСТИКА'
    HFlag '-Verbose' `
          'Show detailed mDNS/ADB diagnostics' `
          'Показать подробную диагностику mDNS/ADB'
    HFlag '-help' `
          'Show this help' `
          'Показать эту справку'

    HdrMain 'EXAMPLES' 'ПРИМЕРЫ'

    Write-Host ''
    Write-Host ('  ' + (T 'Discover Quest (details only):' 'Найти Quest (только детали):'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 0' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Discover and connect automatically:' 'Найти и подключиться автоматически:'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 1' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Connect only, no details printed:' 'Только подключение, без деталей:'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 2' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Discover through a specific PC interface:' 'Поиск через конкретный интерфейс ПК:'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 0 -IPPC 10.0.0.30' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Listen on a specific PC interface:' 'Прослушивание на конкретном интерфейсе:'))
    Write-Host '    .\quas-mdns.ps1 -listener -IPPC 10.0.0.30' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Listen only for packets from Quest:' 'Слушать пакеты только от Quest:'))
    Write-Host '    .\quas-mdns.ps1 -listener -IPQuest 10.0.0.64' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Dump raw packets from Quest:' 'Дамп пакетов от Quest:'))
    Write-Host '    .\quas-mdns.ps1 -dumper -IPQuest 10.0.0.64' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Discover with detailed diagnostics:' 'Поиск с подробной диагностикой:'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 0 -Verbose' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Discover with custom retry count and delay:' 'Поиск с настройкой числа попыток и задержки:'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 1 -retries 10 -retrydelay 5' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Russian interface:' 'Русский интерфейс:'))
    Write-Host '    .\quas-mdns.ps1 -autoconnect 0 -lang RU' -ForegroundColor DarkGray

    Write-Host ''
    Write-Host ('  ' + (T 'Show adapters / ADB information:' 'Информация об адаптерах / ADB:'))
    Write-Host '    .\quas-mdns.ps1 -adapters'   -ForegroundColor DarkGray
    Write-Host '    .\quas-mdns.ps1 -adbversion' -ForegroundColor DarkGray
    Write-Host '    .\quas-mdns.ps1 -adbserver'  -ForegroundColor DarkGray
    Write-Host '    .\quas-mdns.ps1 -services'   -ForegroundColor DarkGray

    Write-Host ''
    Write-Host $border -ForegroundColor DarkCyan
    Write-Host ''
}



# ============================================================
# FIND ADB
# ============================================================

function Find-Adb {

    # 1. -ToolsPath (explicit override, highest priority)
    if ($ToolsPath) {

        $candidate = Join-Path $ToolsPath 'adb.exe'

        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    # 2. %myfiles%\adb.exe
    if ($env:myfiles) {

        $candidate = Join-Path $env:myfiles 'adb.exe'

        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    # 3. adb.exe next to this script
    if ($PSScriptRoot) {

        $candidate = Join-Path $PSScriptRoot 'adb.exe'

        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    # 4. PATH
    $cmd = Get-Command adb.exe -ErrorAction SilentlyContinue

    if ($cmd) {
        return $cmd.Source
    }

    return $null
}


$script:AdbPath = Find-Adb


# ============================================================
# ADB OUTPUT ENCODING
# ============================================================

#function Get-AdbEncoding {

    # adb.exe on Windows normally uses the OEM console code page
    # for its native console output.
    #
    # This avoids UTF-8 decoding of CP866 output, which produces
    # strings such as:
    #   ¦Я¦-¦+¦¦¦¬TОTЗ¦¦¦-¦¬¦¦

#    try {
#        $codePage = (cmd.exe /c chcp) 2>$null
#        if ($codePage -match '(\d+)') {
#            $cp = [int]$Matches[1]
#            try {
#                return [System.Text.Encoding]::GetEncoding($cp)
#            }
#            catch {
#            }
#        }
#    }
#    catch {
#    }
    # Russian Windows fallback
#    try {
#        return [System.Text.Encoding]::GetEncoding(866)
#    }
#    catch {
#        return [System.Text.Encoding]::Default
#    }
#}
function Get-AdbEncoding {
    return [System.Text.Encoding]::UTF8
}


# ============================================================
# RUN ADB
# ============================================================

function Invoke-Adb {

    param(
        [string[]]$Arguments
    )

    if (-not $script:AdbPath) {

        Write-Host (T 'ERROR: adb.exe not found.' 'ОШИБКА: adb.exe не найден.') -ForegroundColor Red
        return [PSCustomObject]@{
            ExitCode = -1
            Output   = @()
        }
    }

    $encoding = Get-AdbEncoding

    $psi = New-Object System.Diagnostics.ProcessStartInfo

    $psi.FileName = $script:AdbPath
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

    # Available in .NET Framework used by PowerShell 5.1
    try {
        $psi.StandardOutputEncoding = $encoding
        $psi.StandardErrorEncoding = $encoding
    }
    catch {
    }

    foreach ($arg in $Arguments) {

        # ArgumentList isn't available on older .NET Framework,
        # so build a safely quoted command line.
        if ($arg -match '[\s"]') {
            $escaped = $arg.Replace('\','\\').Replace('"','\"')
            $psi.Arguments += '"' + $escaped + '" '
        }
        else {
            $psi.Arguments += $arg + ' '
        }
    }

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi

    try {

        [void]$process.Start()

        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        $lines = @()

        if ($stdout) {
            $lines += ($stdout -split "`r?`n")
        }

        if ($stderr) {
            $lines += ($stderr -split "`r?`n")
        }

        return [PSCustomObject]@{
            ExitCode = $process.ExitCode
            Output   = $lines | Where-Object { $_ -ne '' }
        }
    }
    catch {

        return [PSCustomObject]@{
            ExitCode = -1
            Output   = @($_.Exception.Message)
        }
    }
    finally {

        $process.Dispose()
    }
}


# ============================================================
# ADB VERSION
# ============================================================

function Show-AdbVersion {

    if (-not $script:AdbPath) {

        Write-Host (T 'ADB not found.' 'ADB не найден.') -ForegroundColor Red
        return
    }

    Write-Host ''
    Write-Host "ADB: $script:AdbPath" -ForegroundColor Cyan
    Write-Host ''

    $result = Invoke-Adb @('version')

    $result.Output | ForEach-Object {
        Write-Host $_
    }

    Write-Host ''
}


# ============================================================
# ADB SERVER RESTART
# ============================================================

function Restart-AdbServer {

    if (-not $script:AdbPath) {

        Write-Host (T 'ADB not found.' 'ADB не найден.') -ForegroundColor Red
        return
    }

    Write-Host ''
    Write-Host (T 'Stopping ADB server...' 'Остановка ADB-сервера...') -ForegroundColor Cyan

    $result = Invoke-Adb @('kill-server')

    $result.Output | ForEach-Object {
        Write-Host $_
    }

    Write-Host ''
    Write-Host (T 'Starting ADB server...' 'Запуск ADB-сервера...') -ForegroundColor Cyan

    $result = Invoke-Adb @('start-server')

    $result.Output | ForEach-Object {
        Write-Host $_
    }

    Write-Host ''
    Write-Host (T 'ADB version:' 'Версия ADB:') -ForegroundColor Cyan

    $verResult = Invoke-Adb @('version')

    $verResult.Output | ForEach-Object {
        Write-Host $_
    }

    Write-Host ''
}


# ============================================================
# ADB mDNS SERVICES
# ============================================================

function Show-AdbServices {

    if (-not $script:AdbPath) {

        Write-Host (T 'ADB not found.' 'ADB не найден.') -ForegroundColor Red
        return
    }

    Write-Host ''
    Write-Host (T 'ADB mDNS services:' 'mDNS-сервисы ADB:') -ForegroundColor Cyan
    Write-Host ''

    $result = Invoke-Adb @('mdns','services')

    if ($result.Output.Count -eq 0) {
        Write-Host (T 'No discovered mDNS services.' 'mDNS-сервисы не обнаружены.')
    }
    else {
        $result.Output | ForEach-Object {
            Write-Host $_
        }
    }

    Write-Host ''
}


# ============================================================
# NETWORK ADAPTERS
# ============================================================

function Show-NetworkAdapters {

    Write-Host ''
    Write-Host (T 'PC network adapters:' 'Сетевые адаптеры ПК:') -ForegroundColor Cyan
    Write-Host ''

    $adapters = Get-NetAdapter -ErrorAction SilentlyContinue |
        Sort-Object ifIndex

    foreach ($adapter in $adapters) {

        $addresses = @()

        try {
            $addresses = Get-NetIPAddress `
                -InterfaceIndex $adapter.ifIndex `
                -AddressFamily IPv4 `
                -ErrorAction Stop |
            Where-Object {
                $_.IPAddress -notlike '169.254.*'
            }
        }
        catch {
            # Adapters with no bound IPv4 address (disabled,
            # disconnected, or virtual) raise a CIM "no matching
            # objects" error here - that is expected, not a fault.
            $addresses = @()
        }

        Write-Host ('[{0}] {1}' -f $adapter.ifIndex, $adapter.Name) `
            -ForegroundColor Yellow

        Write-Host ("    " + (T 'Status : ' 'Статус : ') + "$($adapter.Status)")

        if ($addresses) {

            foreach ($addr in $addresses) {
                Write-Host ("    IPv4   : $($addr.IPAddress)")
            }
        }
        else {
            Write-Host '    IPv4   : -'
        }

        Write-Host ''
    }
}


# ============================================================
# GET mDNS INTERFACES
# ============================================================

function Get-MdnsInterfaces {

    $result = New-Object System.Collections.Generic.List[object]

    try {

        $adapters = Get-NetAdapter |
            Where-Object {
                $_.Status -eq 'Up'
            }

        foreach ($adapter in $adapters) {

            $addresses = Get-NetIPAddress `
                -InterfaceIndex $adapter.ifIndex `
                -AddressFamily IPv4 |
            Where-Object {
                $_.IPAddress -notlike '169.254.*' -and
                $_.IPAddress -ne '127.0.0.1'
            }

            foreach ($address in $addresses) {

                # Explicit interface selected by user
                if ($IPPC) {

                    if ($address.IPAddress -ne $IPPC) {
                        continue
                    }
                }

                # Ignore obvious virtual adapters unless explicitly
                # selected through -IPPC.
                if (-not $IPPC) {

                    $name = $adapter.Name.ToLower()

                    if (
                        $name -match 'vmware' -or
                        $name -match 'virtualbox' -or
                        $name -match 'hyper-v' -or
                        $name -match 'vethernet' -or
                        $name -match 'wsl'
                    ) {
                        continue
                    }
                }

                $result.Add(
                    [PSCustomObject]@{
                        IP      = $address.IPAddress
                        Adapter = $adapter.Name
                        Index   = $adapter.ifIndex
                    }
                )
            }
        }
    }
    catch {
    }

    return $result
}


# ============================================================
# DNS UINT16
# ============================================================

function Read-UShortBE {

    param(
        [byte[]]$Data,
        [int]$Offset
    )

    $hi = [int]$Data[$Offset]
    $lo = [int]$Data[$Offset + 1]

    return (($hi * 256) + $lo)
}


# ============================================================
# DNS UINT32
# ============================================================

function Read-UInt32BE {

    param(
        [byte[]]$Data,
        [int]$Offset
    )

    $b0 = [uint32]$Data[$Offset]
    $b1 = [uint32]$Data[$Offset + 1]
    $b2 = [uint32]$Data[$Offset + 2]
    $b3 = [uint32]$Data[$Offset + 3]

    return (
        ($b0 * 16777216) +
        ($b1 * 65536) +
        ($b2 * 256) +
        $b3
    )
}


# ============================================================
# DNS NAME
# Supports DNS compression pointers.
# ============================================================

function Read-DnsName {

    param(
        [byte[]]$Data,
        [int]$Offset
    )

    $labels = New-Object System.Collections.Generic.List[string]

    $position = $Offset
    $nextOffset = $null
    $jumped = $false

    $safety = 0

    while ($true) {

        $safety++

        if ($safety -gt 100) {
            return $null
        }

        if ($position -ge $Data.Length) {
            return $null
        }

        $length = [int]$Data[$position]

        # End of name
        if ($length -eq 0) {

            if (-not $jumped) {
                $nextOffset = $position + 1
            }

            break
        }

        # DNS compression pointer
        if (($length -band 0xC0) -eq 0xC0) {

            if (($position + 1) -ge $Data.Length) {
                return $null
            }

            $pointer = (
                (($length -band 0x3F) * 256) +
                [int]$Data[$position + 1]
            )

            if (-not $jumped) {
                $nextOffset = $position + 2
            }

            $position = $pointer
            $jumped = $true

            continue
        }

        if ($length -gt 63) {
            return $null
        }

        if (($position + $length) -ge $Data.Length) {
            return $null
        }

        $label = [System.Text.Encoding]::ASCII.GetString(
            $Data,
            $position + 1,
            $length
        )

        $labels.Add($label)

        $position += $length + 1
    }

    return [PSCustomObject]@{
        Name       = ($labels -join '.')
        NextOffset = $nextOffset
    }
}


# ============================================================
# PARSE mDNS PACKET
# ============================================================

function Parse-MdnsPacket {

    param(
        [byte[]]$Data
    )

    if ($Data.Length -lt 12) {
        return
    }

    $qdCount = Read-UShortBE $Data 4
    $anCount = Read-UShortBE $Data 6
    $nsCount = Read-UShortBE $Data 8
    $arCount = Read-UShortBE $Data 10

    $offset = 12

    $records = New-Object System.Collections.Generic.List[object]

    # --------------------------------------------------------
    # Questions
    # --------------------------------------------------------

    for ($i = 0; $i -lt $qdCount; $i++) {

        $name = Read-DnsName $Data $offset

        if (-not $name) {
            return
        }

        $offset = $name.NextOffset

        if (($offset + 4) -gt $Data.Length) {
            return
        }

        $type = Read-UShortBE $Data $offset
        $class = Read-UShortBE $Data ($offset + 2)

        $offset += 4
    }

    # --------------------------------------------------------
    # Resource records
    # --------------------------------------------------------

    $totalRecords = $anCount + $nsCount + $arCount

    for ($i = 0; $i -lt $totalRecords; $i++) {

        $name = Read-DnsName $Data $offset

        if (-not $name) {
            return
        }

        $offset = $name.NextOffset

        if (($offset + 10) -gt $Data.Length) {
            return
        }

        $type = Read-UShortBE $Data $offset
        $class = Read-UShortBE $Data ($offset + 2)
        $ttl = Read-UInt32BE $Data ($offset + 4)
        $rdLength = Read-UShortBE $Data ($offset + 8)

        $rdataOffset = $offset + 10
        $nextRecord = $rdataOffset + $rdLength

        if ($nextRecord -gt $Data.Length) {
            return
        }

        # PTR
        if ($type -eq 12) {

            $ptr = Read-DnsName $Data $rdataOffset

            if ($ptr) {

                $records.Add(
                    [PSCustomObject]@{
                        Type   = 'PTR'
                        Name   = $name.Name
                        Target = $ptr.Name
                    }
                )
            }
        }

        # SRV
        elseif ($type -eq 33 -and $rdLength -ge 7) {

            $priority = Read-UShortBE $Data $rdataOffset
            $weight   = Read-UShortBE $Data ($rdataOffset + 2)
            $port     = Read-UShortBE $Data ($rdataOffset + 4)

            $target = Read-DnsName $Data ($rdataOffset + 6)

            if ($target) {

                $records.Add(
                    [PSCustomObject]@{
                        Type     = 'SRV'
                        Name     = $name.Name
                        Priority = $priority
                        Weight   = $weight
                        Port     = $port
                        Target   = $target.Name
                    }
                )
            }
        }

        # A
        elseif ($type -eq 1 -and $rdLength -eq 4) {

            $ip = '{0}.{1}.{2}.{3}' -f `
                $Data[$rdataOffset],
                $Data[$rdataOffset + 1],
                $Data[$rdataOffset + 2],
                $Data[$rdataOffset + 3]

            $records.Add(
                [PSCustomObject]@{
                    Type    = 'A'
                    Name    = $name.Name
                    Address = $ip
                }
            )
        }

        # TXT
        elseif ($type -eq 16) {

            $records.Add(
                [PSCustomObject]@{
                    Type = 'TXT'
                    Name = $name.Name
                }
            )
        }

        $offset = $nextRecord
    }

    return $records
}


# ============================================================
# CREATE mDNS SOCKETS
# ============================================================

function New-MdnsSockets {

    $interfaces = Get-MdnsInterfaces

    if ($interfaces.Count -eq 0) {

        Write-Host ''
        Write-Host (T 'ERROR: No suitable IPv4 network interfaces found.' 'ОШИБКА: Подходящие сетевые интерфейсы IPv4 не найдены.') `
            -ForegroundColor Red

        if ($IPPC) {
            Write-Host ((T 'Requested IP: ' 'Запрошенный IP: ') + $IPPC)
        }

        return @()
    }

    $sockets = New-Object System.Collections.Generic.List[object]

    foreach ($interface in $interfaces) {

        try {

            $udp = New-Object System.Net.Sockets.UdpClient

            $udp.Client.SetSocketOption(
                [System.Net.Sockets.SocketOptionLevel]::Socket,
                [System.Net.Sockets.SocketOptionName]::ReuseAddress,
                $true
            )

            $endpoint = New-Object System.Net.IPEndPoint(
                [System.Net.IPAddress]::Any,
                $script:MDNSPort
            )

            $udp.Client.Bind($endpoint)

            $udp.JoinMulticastGroup(
                [System.Net.IPAddress]::Parse($script:MulticastIP),
                [System.Net.IPAddress]::Parse($interface.IP)
            )

            $sockets.Add(
                [PSCustomObject]@{
                    Socket  = $udp
                    IP      = $interface.IP
                    Adapter = $interface.Adapter
                }
            )

            Write-Diagnostic (
                '[mDNS] Listening: {0} ({1})' -f
                $interface.IP,
                $interface.Adapter
            )
        }
        catch {

            if ($script:DiagnosticVerbose) {

                Write-Host (
                    '[mDNS] Failed to listen on {0}: {1}' -f
                    $interface.IP,
                    $_.Exception.Message
                ) -ForegroundColor DarkYellow
            }
        }
    }

    return $sockets
}


# ============================================================
# CLOSE SOCKETS
# ============================================================

function Close-MdnsSockets {

    param(
        $Sockets
    )

    foreach ($item in $Sockets) {

        try {
            $item.Socket.Close()
        }
        catch {
        }
    }
}


# ============================================================
# RAW HEX DUMP
# ============================================================

function Show-HexDump {

    param(
        [byte[]]$Data
    )

    for ($i = 0; $i -lt $Data.Length; $i += 16) {

        $count = [Math]::Min(16, $Data.Length - $i)

        $hex = ''

        for ($j = 0; $j -lt $count; $j++) {

            $hex += '{0:X2} ' -f $Data[$i + $j]
        }

        $ascii = ''

        for ($j = 0; $j -lt $count; $j++) {

            $b = $Data[$i + $j]

            if ($b -ge 32 -and $b -le 126) {
                $ascii += [char]$b
            }
            else {
                $ascii += '.'
            }
        }

        Write-Host (
            '{0:X4}  {1,-48}  {2}' -f
            $i,
            $hex,
            $ascii
        )
    }
}


# ============================================================
# LISTENER
# ============================================================

function Start-MdnsListener {

    Write-Host ''
    Write-Host (T 'QUAS mDNS Listener' 'QUAS mDNS Слушатель') -ForegroundColor Cyan
    Write-Host ''
    Write-Host "Multicast : $script:MulticastIP`:$script:MDNSPort"

    if ($IPPC) {
        Write-Host "IPPC      : $IPPC"
    }
    else {
        Write-Host ('IPPC      : ' + (T 'automatic' 'автоматически'))
    }

    if ($IPQuest) {
        Write-Host ((T 'Filter    : ' 'Фильтр    : ') + $IPQuest)
    }
    else {
        Write-Host ('Filter    : ' + (T 'none' 'нет'))
    }

    Write-Host ''

    $sockets = New-MdnsSockets

    if ($sockets.Count -eq 0) {
        return
    }

    Write-Host ''
    Write-Host (T 'Listening for mDNS packets...' 'Прослушивание mDNS-пакетов...') -ForegroundColor Cyan
    Write-Host (T 'Press Enter to stop.' 'Нажмите Enter, чтобы остановить.')
    Write-Host ''
    Write-Host (T 'If no Quest packets appear for a while, try:' 'Если пакеты от Quest долго не появляются, попробуйте:') -ForegroundColor Yellow
    Write-Host ('  1. ' + (T 'Turn Wi-Fi off and on on the Quest.' 'Выключить и включить Wi-Fi на Quest.'))
    Write-Host ('  2. ' + (T 'Restart the ADB server.' 'Перезапустить ADB-сервер.'))
    Write-Host ('  3. ' + (T 'Reboot the Quest while leaving this program running.' 'Перезагрузить Quest, не закрывая эту программу.'))
    Write-Host ''

    try {

        while ($true) {

            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::Enter) { break }
            }

            foreach ($item in $sockets) {

                while ($item.Socket.Available -gt 0) {

                    try {

                        $remote = New-Object System.Net.IPEndPoint(
                            [System.Net.IPAddress]::Any,
                            0
                        )

                        $data = $item.Socket.Receive([ref]$remote)

                        if ($IPQuest -and $remote.Address.ToString() -ne $IPQuest) {
                            continue
                        }

                        Write-Host (
                            '[{0}] {1} ' + (T 'bytes from' 'байт от') + ' {2}' -f
                            (Get-Date -Format 'HH:mm:ss'),
                            $data.Length,
                            $remote
                        )
                    }
                    catch {
                    }
                }
            }

            Start-Sleep -Milliseconds 20
        }
    }
    finally {

        Close-MdnsSockets $sockets
    }
}


# ============================================================
# DUMPER
# ============================================================

function Start-MdnsDumper {

    Write-Host ''
    Write-Host (T 'QUAS mDNS Packet Dumper' 'QUAS mDNS Дамп пакетов') -ForegroundColor Cyan
    Write-Host ''
    Write-Host "Multicast : $script:MulticastIP`:$script:MDNSPort"

    if ($IPPC) {
        Write-Host "IPPC      : $IPPC"
    }
    else {
        Write-Host ('IPPC      : ' + (T 'automatic' 'автоматически'))
    }

    if ($IPQuest) {
        Write-Host ((T 'Filter    : ' 'Фильтр    : ') + $IPQuest)
    }
    else {
        Write-Host ('Filter    : ' + (T 'none' 'нет'))
    }

    Write-Host ''

    $sockets = New-MdnsSockets

    if ($sockets.Count -eq 0) {
        return
    }

    Write-Host ''
    Write-Host (T 'Waiting for mDNS packets...' 'Ожидание mDNS-пакетов...') -ForegroundColor Cyan
    Write-Host (T 'Press Enter to stop.' 'Нажмите Enter, чтобы остановить.')
    Write-Host ''
    Write-Host (T 'If no Quest packets appear for a while, try:' 'Если пакеты от Quest долго не появляются, попробуйте:') -ForegroundColor Yellow
    Write-Host ('  1. ' + (T 'Turn Wi-Fi off and on on the Quest.' 'Выключить и включить Wi-Fi на Quest.'))
    Write-Host ('  2. ' + (T 'Restart the ADB server.' 'Перезапустить ADB-сервер.'))
    Write-Host ('  3. ' + (T 'Reboot the Quest while leaving this program running.' 'Перезагрузить Quest, не закрывая эту программу.'))
    Write-Host ''

    try {

        while ($true) {

            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::Enter) { break }
            }

            foreach ($item in $sockets) {

                while ($item.Socket.Available -gt 0) {

                    try {

                        $remote = New-Object System.Net.IPEndPoint(
                            [System.Net.IPAddress]::Any,
                            0
                        )

                        $data = $item.Socket.Receive([ref]$remote)

                        if ($IPQuest -and $remote.Address.ToString() -ne $IPQuest) {
                            continue
                        }

                        Write-Host ''
                        Write-Host '============================================' `
                            -ForegroundColor Yellow

                        Write-Host (
                            ('FROM: {0}:{1}    ' + (T 'SIZE' 'РАЗМЕР') + ': {2} ' + (T 'bytes' 'байт')) -f
                            $remote.Address,
                            $remote.Port,
                            $data.Length
                        ) -ForegroundColor Green

                        Write-Host '============================================' `
                            -ForegroundColor Yellow

                        Show-HexDump $data
                    }
                    catch {
                    }
                }
            }

            Start-Sleep -Milliseconds 20
        }
    }
    finally {

        Close-MdnsSockets $sockets
    }
}


# ============================================================
# DISCOVER QUEST
# ============================================================

function Find-QuestMdns {

    param(
        [int]$TimeoutSeconds = 0
    )

    $sockets = New-MdnsSockets

    if ($sockets.Count -eq 0) {
        return $null
    }

    $start = Get-Date

    # Cache records because mDNS may split related records
    # across multiple packets.
    $srvCache = @{}
    $aCache = @{}
    $script:DiscoveryHintShown = $false
    $script:QuestIpDetected = $false
    $script:WaitingForSrvShown = $false

    Write-Host ''
    Write-Host (T 'Searching for Quest ADB over Wi-Fi...' 'Поиск Quest ADB по Wi-Fi...') -ForegroundColor Cyan

    if ($TimeoutSeconds -eq 0) {
        Write-Host ('Timeout    : ' + (T 'unlimited' 'без ограничения'))
    }
    else {
        Write-Host ("Timeout    : $TimeoutSeconds " + (T 'seconds' 'сек'))
    }

    if ($autoconnect -ge 1) {
        Write-Host (T 'Press Enter to stop, Space for the next attempt now.' 'Enter - остановить, Space - следующая попытка сейчас.')
    } else {
        Write-Host (T 'Press Enter to stop.' 'Нажмите Enter, чтобы остановить.')
    }
    Write-Host ''
    Write-Host (T 'Waiting for mDNS announcement...' 'Ожидание mDNS-оповещения...') -ForegroundColor DarkGray
    Write-Host ''
    Write-Host (T 'If the Quest is not detected for a while, try:' 'Если Quest долго не обнаруживается, попробуйте:') -ForegroundColor Yellow
    Write-Host ('  1. ' + (T 'Turn Wi-Fi off and on on the Quest.' 'Выключить и включить Wi-Fi на Quest.'))
    Write-Host ('  2. ' + (T 'Restart the ADB server.' 'Перезапустить ADB-сервер.'))
    Write-Host ('  3. ' + (T 'Reboot the Quest while leaving this program running.' 'Перезагрузить Quest, не закрывая эту программу.'))
    Write-Host ''

    try {

        while ($true) {

            # -----------------------------------------------
            # Timeout
            # -----------------------------------------------

            if ($TimeoutSeconds -gt 0) {

                $elapsed = (
                    (Get-Date) - $start
                ).TotalSeconds

                if ($elapsed -ge $TimeoutSeconds) {

                    Write-Host ''
                    Write-Host (T 'Discovery timeout.' 'Тайм-аут поиска.') -ForegroundColor Yellow

                    return $null
                }
            }

            # -----------------------------------------------
            # Enter stops, Space skips to the next attempt
            # -----------------------------------------------

            if ([Console]::KeyAvailable) {

                $key = [Console]::ReadKey($true)

                if ($key.Key -eq [ConsoleKey]::Enter) {

                    Write-Host ''
                    Write-Host (T 'Discovery stopped by user.' 'Поиск остановлен пользователем.') -ForegroundColor Yellow
                    return [PSCustomObject]@{ Aborted = $true }
                }
                elseif ($key.Key -eq [ConsoleKey]::Spacebar -and $autoconnect -ge 1) {

                    Write-Host ''
                    Write-Host (T 'Skipping to the next attempt...' 'Переход к следующей попытке...') -ForegroundColor Yellow
                    return [PSCustomObject]@{ SkipNext = $true }
                }
            }

            # -----------------------------------------------
            # Process packets
            # -----------------------------------------------

            foreach ($item in $sockets) {

                while ($item.Socket.Available -gt 0) {

                    try {

                        $remote = New-Object System.Net.IPEndPoint(
                            [System.Net.IPAddress]::Any,
                            0
                        )

                        $data = $item.Socket.Receive([ref]$remote)

                        if ($IPQuest -and $remote.Address.ToString() -ne $IPQuest) {
                            continue
                        }

                        $records = Parse-MdnsPacket $data

                        if (-not $records) {
                            continue
                        }

                        # -----------------------------------
                        # Store SRV records
                        # -----------------------------------

                        foreach ($record in $records) {

                            if ($record.Type -eq 'PTR') {

                                if ($record.Target -like "*$script:ServiceType") {
                                    Write-Diagnostic (
                                        '[mDNS] PTR: {0} -> {1}' -f
                                        $record.Name,
                                        $record.Target
                                    )
                                }
                            }

                            elseif ($record.Type -eq 'SRV') {

                                if (
                                    $record.Name -like "*$script:ServiceType"
                                ) {

                                    $srvCache[$record.Name] = $record

                                    Write-Diagnostic (
                                        '[mDNS] SRV: {0} -> {1}:{2}' -f
                                        $record.Name,
                                        $record.Target,
                                        $record.Port
                                    )
                                }
                            }

                            # --------------------------------
                            # Store A records
                            # --------------------------------

                            elseif ($record.Type -eq 'A') {

                                $aCache[$record.Name] = $record.Address

                                if ($record.Name -eq 'Android.local') {
                                    Write-Diagnostic (
                                        '[mDNS] A: {0} -> {1}' -f
                                        $record.Name,
                                        $record.Address
                                    )
                                }

                                if ($record.Name -eq 'Android.local' -and -not $script:QuestIpDetected) {
                                    $script:QuestIpDetected = $true
                                    Write-Diagnostic "[mDNS] Quest IP detected: $($record.Address)"
                                }
                            }
                        }

                        # -----------------------------------
                        # Try to match SRV + A
                        # -----------------------------------

                        if (
                            $script:DiagnosticVerbose -and
                            $script:QuestIpDetected -and
                            $srvCache.Count -eq 0 -and
                            -not $script:WaitingForSrvShown
                        ) {
                            $script:WaitingForSrvShown = $true
                            Write-Diagnostic '[mDNS] Waiting for _adb-tls-connect._tcp SRV record...'
                        }

                        foreach ($srvName in @($srvCache.Keys)) {

                            $srv = $srvCache[$srvName]

                            if ($srv.Port -lt 1 -or $srv.Port -gt 65535) {
                                continue
                            }

                            if ($aCache.ContainsKey($srv.Target)) {

                                $ip = $aCache[$srv.Target]

                                if (-not $ip) {
                                    continue
                                }

                                Write-Diagnostic (
                                    '[mDNS] Endpoint: {0}:{1}' -f
                                    $ip,
                                    $srv.Port
                                )

                                return [PSCustomObject]@{
                                    IP      = $ip
                                    Port    = $srv.Port
                                    Service = $srv.Name
                                    Target  = $srv.Target
                                }
                            }
                        }
                    }
                    catch {
                    }
                }
            }

            Start-Sleep -Milliseconds 20
        }
    }
    finally {

        Close-MdnsSockets $sockets
    }
}


# ============================================================
# CONNECT QUEST
# ============================================================

function Wait-RetryDelay {

    param(
        [int]$Seconds
    )

    if ($Seconds -le 0) { return 'Timeout' }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    while ($sw.Elapsed.TotalSeconds -lt $Seconds) {

        if ([Console]::KeyAvailable) {

            $key = [Console]::ReadKey($true)

            if ($key.Key -eq [ConsoleKey]::Enter) { return 'Enter' }
            if ($key.Key -eq [ConsoleKey]::Spacebar) { return 'Space' }
        }

        Start-Sleep -Milliseconds 50
    }

    return 'Timeout'
}

function Connect-Quest {

    param(
        [string]$IP,
        [int]$Port
    )
    $endpoint = "$IP`:$Port"

    Write-Host ''
    Write-Host ((T 'Connecting to ' 'Подключение к ') + "$endpoint...") -ForegroundColor Cyan
    Write-Host ''

    Write-Diagnostic "[ADB] Connecting to $endpoint"

    $result = Invoke-Adb @('connect', $endpoint)

    foreach ($line in $result.Output) {
        Write-Host $line
    }

    Write-Diagnostic "[ADB] adb connect exit code: $($result.ExitCode)" 

    if ($result.ExitCode -ne 0) {
        return $false
    }

    # Verify with adb devices
    $devices = Invoke-Adb @('devices')

    Write-Diagnostic '[ADB] Checking connection with adb devices'

    foreach ($line in $devices.Output) {

        Write-Diagnostic "[ADB] $line"

        if (
            $line -match (
                [regex]::Escape($endpoint) +
                '\s+device\b'
            )
        ) {
            return $true
        }
    }

    return $false
}


# ============================================================
# ADB CONNECTION RECOVERY
# ============================================================
function Recover-AdbConnection {
    param(
        [string]$IP,
        [int]$Port,
        [int]$Attempt
    )
    $endpoint = "$IP`:$Port"

    Write-Host ''
    Write-Host ((T '[Recovery] ADB connection failed for ' '[Восстановление] Не удалось подключить ADB к ') + "$endpoint.") -ForegroundColor DarkYellow

    if ($Attempt -eq 1) {
        Write-Host (T '[Recovery] Action: adb disconnect' '[Восстановление] Действие: adb disconnect') -ForegroundColor DarkYellow
        [void](Invoke-Adb @('disconnect', $endpoint))
    }
    elseif ($Attempt -eq 2) {
        Write-Host (T '[Recovery] Action: restart ADB server' '[Восстановление] Действие: перезапуск ADB-сервера') -ForegroundColor DarkYellow
        [void](Invoke-Adb @('disconnect', $endpoint))
        [void](Invoke-Adb @('kill-server'))
        [void](Invoke-Adb @('start-server'))
    }
    else {
        Write-Host (T '[Recovery] Action: adb disconnect' '[Восстановление] Действие: adb disconnect') -ForegroundColor DarkYellow
        [void](Invoke-Adb @('disconnect', $endpoint))
    }
}


# ============================================================
# DISCOVERY + OPTIONAL AUTOCONNECT
# ============================================================

function Start-Discovery {

    if (-not $script:AdbPath) {

        Write-Host ''
        Write-Host (T 'WARNING: adb.exe was not found.' 'ВНИМАНИЕ: adb.exe не найден.') `
            -ForegroundColor Yellow

        if ($autoconnect -ge 1) {
            Write-Host (T 'Autoconnect cannot be used without adb.exe.' 'Autoconnect невозможен без adb.exe.') `
                -ForegroundColor Red
            return
        }
    }

    $attempt = 0

    while ($true) {

        $attempt++

        # Single, authoritative cap check - every path that loops
        # back here (not found, connect failed, user skipped ahead)
        # is bounded by this one place, so the attempt count can
        # never run past -retries.
        if ($retries -gt 0 -and $attempt -gt $retries) {

            Write-Host ''
            Write-Host (T 'Maximum number of attempts reached.' 'Достигнуто максимальное число попыток.') `
                -ForegroundColor Red

            Write-Host ''
            Write-Host (T 'Troubleshooting suggestions:' 'Рекомендации по устранению неполадок:') `
                -ForegroundColor Yellow

            Write-Host ('  1. ' + (T 'Turn Wi-Fi off and on on the Quest.' 'Выключить и включить Wi-Fi на Quest.'))
            Write-Host ('  2. ' + (T 'Restart the ADB server.' 'Перезапустить ADB-сервер.'))
            Write-Host ('  3. ' + (T 'Reboot the Quest while leaving this program running.' 'Перезагрузить Quest, не закрывая эту программу.'))
            Write-Host ''

            return
        }

        if ($retries -gt 0) {

            Write-Host (
                (T 'Discovery attempt {0}/{1}' 'Попытка поиска {0}/{1}') -f
                $attempt,
                $retries
            ) -ForegroundColor DarkGray
        }

        if ($script:DiagnosticVerbose) {
            Write-Diagnostic "[mDNS] IPPC filter   : $(if ($IPPC) { $IPPC } else { 'automatic' })"
            Write-Diagnostic "[mDNS] IPQuest filter: $(if ($IPQuest) { $IPQuest } else { 'none' })"
            Write-Diagnostic "[mDNS] Timeout       : $(if ($timeout -eq 0) { 'unlimited' } else { "$timeout seconds" })"
            Write-Diagnostic "[mDNS] Retry delay   : $retrydelay seconds"
        }

        $found = Find-QuestMdns -TimeoutSeconds $timeout

        if ($found -and $found.Aborted) {
            return
        }

        if ($found -and $found.SkipNext) {
            continue
        }

        if (-not $found) {

            if ($autoconnect -eq 0) {
                return
            }

            Write-Host ''
            Write-Host (T 'Quest was not detected.' 'Quest не обнаружен.') `
                -ForegroundColor Yellow

            Write-Host ''
            Write-Host (T 'You can try:' 'Можно попробовать:')
            Write-Host ('  1. ' + (T 'Turn Wi-Fi off and on on the Quest.' 'Выключить и включить Wi-Fi на Quest.'))
            Write-Host ('  2. ' + (T 'Restart the ADB server.' 'Перезапустить ADB-сервер.'))
            Write-Host ('  3. ' + (T 'Reboot the Quest while leaving this program running.' 'Перезагрузить Quest, не закрывая эту программу.'))
            Write-Host ''

            continue
        }

        if ($autoconnect -ne 2) {
            Write-Host ''
            Write-Host (T 'Quest found!' 'Quest найден!') -ForegroundColor Green
            Write-Host ''
            Write-Host ("  IP      : $($found.IP)")
            Write-Host ("  Port    : $($found.Port)")
            Write-Host ("  " + (T 'Service' 'Сервис') + " : $($found.Service)")
            Write-Host ("  " + (T 'Target ' 'Цель   ') + " : $($found.Target)")
            Write-Host ''
        } else {
            Write-Host ((T 'Quest found: ' 'Quest найден: ') + "$($found.IP):$($found.Port) " + (T '- connecting...' '- подключение...')) -ForegroundColor Green
        }

        Write-Diagnostic "[mDNS] Quest endpoint confirmed: $($found.IP):$($found.Port)"


        # -----------------------------------------------
        # Discovery only
        # -----------------------------------------------

        if ($autoconnect -eq 0) {
            return
        }

        # -----------------------------------------------
        # Connect
        # -----------------------------------------------

        $connected = Connect-Quest `
            -IP $found.IP `
            -Port $found.Port

        if ($connected) {

            Write-Host ''
            Write-Host (T 'Quest connected successfully.' 'Quest успешно подключён.') `
                -ForegroundColor Green

            Write-Host ''

            return
        }

        # -----------------------------------------------
        # Connection failed
        # -----------------------------------------------

        Write-Host ''
        Write-Host (T 'ADB connection was not established.' 'Подключение ADB не установлено.') `
            -ForegroundColor Red

        Recover-AdbConnection -IP $found.IP -Port $found.Port -Attempt $attempt

        Write-Host ''
        Write-Host (T 'The program will continue searching for a new mDNS announcement.' 'Программа продолжит поиск нового mDNS-оповещения.') `
            -ForegroundColor Yellow

        Write-Host ''
        Write-Host (T 'If necessary:' 'При необходимости:')
        Write-Host ('  1. ' + (T 'Turn Wi-Fi off and on on the Quest.' 'Выключить и включить Wi-Fi на Quest.'))
        Write-Host ('  2. ' + (T 'Restart the ADB server.' 'Перезапустить ADB-сервер.'))
        Write-Host ('  3. ' + (T 'Reboot the Quest while leaving this program running.' 'Перезагрузить Quest, не закрывая эту программу.'))
        Write-Host ''

        if ($retrydelay -gt 0) {

            Write-Host ((T 'Waiting ' 'Ожидание ') + "$retrydelay " + (T 'seconds before the next discovery attempt (Enter to stop, Space to skip)...' 'сек до следующей попытки (Enter - стоп, Space - пропустить)...')) -ForegroundColor DarkGray

            $wait = Wait-RetryDelay -Seconds $retrydelay

            if ($wait -eq 'Enter') {
                Write-Host ''
                Write-Host (T 'Discovery stopped by user.' 'Поиск остановлен пользователем.') -ForegroundColor Yellow
                return
            }
        }
    }
}


# ============================================================
# PARAMETER VALIDATION
# ============================================================

if ($help) {
    Show-Help
    Exit-Quas 0
}

$isAutoconnectMode = $PSBoundParameters.ContainsKey('autoconnect')

$modeCount = 0

if ($isAutoconnectMode) { $modeCount++ }
if ($listener)   { $modeCount++ }
if ($dumper)     { $modeCount++ }
if ($adapters)   { $modeCount++ }
if ($adbversion) { $modeCount++ }
if ($adbserver)  { $modeCount++ }
if ($services)   { $modeCount++ }

if ($modeCount -gt 1) {

    $selectedModes = @()

    if ($isAutoconnectMode) { $selectedModes += "-autoconnect $autoconnect" }
    if ($listener)   { $selectedModes += '-listener' }
    if ($dumper)     { $selectedModes += '-dumper' }
    if ($adapters)   { $selectedModes += '-adapters' }
    if ($adbversion) { $selectedModes += '-adbversion' }
    if ($adbserver)  { $selectedModes += '-adbserver' }
    if ($services)   { $selectedModes += '-services' }

    Write-Host ''
    Write-Host (T 'ERROR: Multiple main modes specified.' 'ОШИБКА: Указано несколько основных режимов.') -ForegroundColor Red
    Write-Host ''
    Write-Host (T 'The following modes cannot be used together:' 'Следующие режимы нельзя использовать вместе:') -ForegroundColor Yellow

    foreach ($mode in $selectedModes) {
        Write-Host "  $mode"
    }

    Write-Host ''
    Write-Host (T 'Select one main mode and run the program again.' 'Выберите один основной режим и запустите программу заново.')
    Write-Host ''

    Exit-Quas 1
}

# -IPPC can be used by mDNS modes
if ($IPPC -and -not ($isAutoconnectMode -or $listener -or $dumper)) {

    Write-Host ''
    Write-Host (T 'ERROR: -IPPC can only be used with -autoconnect, -listener or -dumper.' 'ОШИБКА: -IPPC можно использовать только с -autoconnect, -listener или -dumper.') `
        -ForegroundColor Red

    Exit-Quas 1
}

# -IPQuest is used by discovery/listener/dumper
if ($IPQuest -and -not ($isAutoconnectMode -or $listener -or $dumper)) {

    Write-Host ''
    Write-Host (T 'ERROR: -IPQuest can only be used with -autoconnect, -listener or -dumper.' 'ОШИБКА: -IPQuest можно использовать только с -autoconnect, -listener или -dumper.') `
        -ForegroundColor Red

    Exit-Quas 1
}

# Validate explicit PC interface IP
if ($IPPC) {

    try {
        $ipObject = [System.Net.IPAddress]::Parse($IPPC)

        if ($ipObject.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
            throw 'IPv4 address required.'
        }
    }
    catch {
        Write-Host ''
        Write-Host ((T 'ERROR: Invalid -IPPC value: ' 'ОШИБКА: недопустимое значение -IPPC: ') + $IPPC) -ForegroundColor Red
        Write-Host (T 'Expected an IPv4 address, for example: -IPPC 10.0.0.30' 'Ожидается адрес IPv4, например: -IPPC 10.0.0.30')
        Write-Host ''
        Exit-Quas 1
    }

    try {
        $ipMatches = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop |
            Where-Object { $_.IPAddress -eq $IPPC }

        if (-not $ipMatches) {
            Write-Host ''
            Write-Host ((T 'ERROR: No local network adapter with IPv4 address ' 'ОШИБКА: локальный адаптер с IPv4-адресом ') + "$IPPC " + (T 'was found.' 'не найден.')) -ForegroundColor Red
            Write-Host (T 'Use -adapters to display available interfaces and IPv4 addresses.' 'Используйте -adapters, чтобы посмотреть доступные интерфейсы и адреса.')
            Write-Host ''
            Exit-Quas 1
        }
    }
    catch {
        Write-Host ''
        Write-Host (T 'ERROR: Unable to verify the requested PC network interface.' 'ОШИБКА: не удалось проверить запрошенный сетевой интерфейс ПК.') -ForegroundColor Red
        Write-Host ''
        Exit-Quas 1
    }
}

# -retries requires the autoconnect mode
if ($retries -ne 5 -and -not $isAutoconnectMode) {

    Write-Host ''
    Write-Host (T 'ERROR: -retries can only be used with -autoconnect.' 'ОШИБКА: -retries можно использовать только с -autoconnect.') `
        -ForegroundColor Red

    Exit-Quas 1
}

# -timeout requires the autoconnect mode
if ($timeout -ne 0 -and -not $isAutoconnectMode) {

    Write-Host ''
    Write-Host (T 'ERROR: -timeout can only be used with -autoconnect.' 'ОШИБКА: -timeout можно использовать только с -autoconnect.') `
        -ForegroundColor Red

    Exit-Quas 1
}


# -retrydelay requires the autoconnect mode
if ($retrydelay -ne 5 -and -not $isAutoconnectMode) {

    Write-Host ''
    Write-Host (T 'ERROR: -retrydelay can only be used with -autoconnect.' 'ОШИБКА: -retrydelay можно использовать только с -autoconnect.') -ForegroundColor Red
    Write-Host ''
    Exit-Quas 1
}

# ============================================================
# MAIN
# ============================================================

if ($isAutoconnectMode) {
    Start-Discovery
    Exit-Quas $LASTEXITCODE
}

if ($listener) {
    Start-MdnsListener
    Exit-Quas 0
}

if ($dumper) {
    Start-MdnsDumper
    Exit-Quas 0
}

if ($adapters) {
    Show-NetworkAdapters
    Exit-Quas 0
}

if ($adbversion) {
    Show-AdbVersion
    Exit-Quas 0
}

if ($adbserver) {
    Restart-AdbServer
    Exit-Quas 0
}

if ($services) {
    Show-AdbServices
    Exit-Quas 0
}

# No mode specified
Show-Help
Exit-Quas 0
'@

function Save-EmbeddedScript {
    $path = Join-Path $ExtractDir $ScriptFileName
    try {
        $enc = New-Object System.Text.UTF8Encoding($true)   # UTF-8 with BOM
        [System.IO.File]::WriteAllText($path, $EmbeddedScriptContent, $enc)
        return $path
    } catch {
        return $null
    }
}

$script:ExtractedScriptPath = Save-EmbeddedScript

# Diagnostic (only with -Verbose): shows exactly what the wrapper
# itself received as leftover arguments, BEFORE deciding whether to
# open the GUI or hand off to the console tool. If pass-through isn't
# triggering when you expect it to, this line shows why.
if ($PSBoundParameters.ContainsKey('Verbose')) {
    $ptCount = if ($PassThroughArgs) { $PassThroughArgs.Count } else { 0 }
    $ptJoin  = if ($PassThroughArgs) { $PassThroughArgs -join '|' } else { '' }
    Write-Host ("[debug] PassThroughArgs count=$ptCount content=[$ptJoin]") -ForegroundColor Magenta
}

# ============================================================
# CONSOLE PASS-THROUGH
# If any extra CLI arguments were given (-autoconnect 0, -adapters,
# -listener, -help, ...), run the embedded tool directly in THIS
# console and exit - the GUI never opens. No arguments at all means
# a normal GUI launch, same as before.
# ============================================================

if ($console -or ($PassThroughArgs -and $PassThroughArgs.Count -gt 0)) {

    if (-not $script:ExtractedScriptPath) {
        Write-Host ((T "ERROR: could not extract " "ОШИБКА: не удалось распаковать ") + "$ScriptFileName " + (T "to disk (" "на диск (") + "$ExtractDir).") -ForegroundColor Red
        exit 1
    }

    # A plain native array, not [System.Collections.ArrayList] - the
    # @finalArgs splat below needs a real object[]/string[] to bind
    # each element as its own "-Name"/value token the same way typed
    # command-line arguments would. $PassThroughArgs can be $null here
    # (e.g. "-console" used with no other arguments), so start from an
    # empty array rather than casting $null directly.
    $finalArgs = @()
    if ($PassThroughArgs) { $finalArgs = [string[]]$PassThroughArgs }

    # -Verbose is a common parameter here (added automatically by
    # [CmdletBinding()]), so it never lands in $PassThroughArgs -
    # check $PSBoundParameters instead and add it back manually.
    if ($PSBoundParameters.ContainsKey('Verbose') -and ($finalArgs -notcontains '-Verbose')) {
        $finalArgs += '-Verbose'
    }

    # Auto-supply -ToolsPath so adb.exe is found the same way the
    # GUI's Run button finds it, unless the caller already gave one.
    if ($ToolsPath -and ($finalArgs -notcontains '-ToolsPath')) {
        $finalArgs += @('-ToolsPath', $ToolsPath)
    }

    # Pass through our own -lang so the console tool matches, unless
    # the caller already specified their own.
    if ($finalArgs -notcontains '-lang') {
        $finalArgs += @('-lang', $script:Lang)
    }

    # Shows exactly what is being invoked - opt-in via -Verbose only,
    # so normal use stays quiet; add -Verbose to see it again.
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        Write-Host ("Running: {0} {1}" -f (Split-Path -Leaf $script:ExtractedScriptPath), ($finalArgs -join ' ')) -ForegroundColor DarkGray
    }

    # Built and run as a STRING through the real PowerShell command
    # parser (Invoke-Expression), the same way the GUI's own Run
    # button already does via Start-Process - NOT as an in-process
    # "& @array" splat. The array-splat form mis-binds these specific
    # arguments on this host (e.g. -listener ending up assigned to
    # -autoconnect), even though the array itself is provably correct
    # (see the line above); building a real command line and letting
    # it go through normal parsing avoids that entirely.
    $quotedArgs = $finalArgs | ForEach-Object {
        if ($_ -match '[\s"]') { '"' + ($_ -replace '"', '""') + '"' } else { $_ }
    }
    $cmdLine = '& "' + $script:ExtractedScriptPath + '" ' + ($quotedArgs -join ' ')

    Invoke-Expression $cmdLine
    exit $LASTEXITCODE
}

# -Verbose alone doesn't imply console intent (it's just a diagnostic
# switch), so the GUI still opens below - but that's an easy thing to
# not expect, so leave a note in the console explaining how to get
# the console tool instead.
if ($PSBoundParameters.ContainsKey('Verbose')) {
    Write-Host (T "Note: -Verbose alone has no effect here - opening the GUI. Combine it with a mode flag (e.g. -autoconnect 0) or add -console to run in the console instead." "Примечание: один -Verbose ничего не даёт - открывается GUI. Добавьте флаг режима (например, -autoconnect 0) или параметр -console, чтобы запустить в консоли.") -ForegroundColor Yellow
}

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
    AccentHov = [System.Drawing.Color]::FromArgb(140, 185, 255)
    Danger    = [System.Drawing.Color]::FromArgb(205, 92,  92)
    BtnRun    = [System.Drawing.Color]::FromArgb(120, 200, 120)
    BtnRunHov = [System.Drawing.Color]::FromArgb(150, 225, 150)
    BtnRel    = [System.Drawing.Color]::FromArgb(85,  110, 165)
    BtnRelHov = [System.Drawing.Color]::FromArgb(110, 138, 195)
    BtnDel    = [System.Drawing.Color]::FromArgb(188, 143, 143)
    BtnDelHov = [System.Drawing.Color]::FromArgb(210, 170, 170)
    Preview   = [System.Drawing.Color]::FromArgb(130, 175, 220)
}
$C["ListSel"] = [System.Drawing.Color]::FromArgb(42, 62, 90)

$F = @{
    Main   = New-Object System.Drawing.Font("Consolas", 9)
    Label  = New-Object System.Drawing.Font("Consolas", 8.5)
    Title  = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
    Small  = New-Object System.Drawing.Font("Consolas", 8)
    Button = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    BtnBig = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
}

# ============================================================
# MODE DEFINITIONS
# ============================================================

$ModeItems = @("Autoconnect","Listener","Dumper","Adapters","ADB Version","ADB Server","Services")

$ModeFlags = @{
    "Listener"    = "listener"
    "Dumper"      = "dumper"
    "Adapters"    = "adapters"
    "ADB Version" = "adbversion"
    "ADB Server"  = "adbserver"
    "Services"    = "services"
}

$ModeDescriptions = @{
    "Autoconnect" = T "Discover the Quest over Wi-Fi via mDNS, with optional autoconnect. Supports PC interface, Quest IP filter, retries, timeout, retry delay." `
                      "Обнаружение Quest по Wi-Fi через mDNS, с опциональным автоподключением. Поддерживает интерфейс ПК, фильтр IP Quest, попытки, тайм-аут, задержку повтора."
    "Listener"    = T "Listen for mDNS packets on the network (Enter to stop). Supports PC interface and Quest IP filter only." `
                      "Прослушивание mDNS-пакетов в сети (Enter - остановить). Поддерживает только интерфейс ПК и фильтр IP Quest."
    "Dumper"      = T "Dump raw mDNS packets in hexadecimal (Enter to stop). Supports PC interface and Quest IP filter only." `
                      "Дамп mDNS-пакетов в hex (Enter - остановить). Поддерживает только интерфейс ПК и фильтр IP Quest."
    "Adapters"    = T "Show PC network adapters and their IPv4 addresses. No network options apply." `
                      "Показать сетевые адаптеры ПК и их IPv4-адреса. Сетевые параметры не применяются."
    "ADB Version" = T "Show adb.exe version information. No network options apply." `
                      "Показать версию adb.exe. Сетевые параметры не применяются."
    "ADB Server"  = T "Restart the local ADB server. No network options apply." `
                      "Перезапустить локальный ADB-сервер. Сетевые параметры не применяются."
    "Services"    = T "Show services reported by 'adb mdns services'. No network options apply." `
                      "Показать сервисы из 'adb mdns services'. Сетевые параметры не применяются."
}

$ModesWithNetOptions = @("Autoconnect","Listener","Dumper")

$AutoconnectItems = @(
    (T "Select mode..." "Выберите режим..."),
    (T "0 - Details only" "0 - Только детали"),
    (T "1 - Details + Connect" "1 - Детали + подключение"),
    (T "2 - Connect only" "2 - Только подключение")
)
$script:AutoIfaceLabel = T "Auto (any interface)" "Авто (любой интерфейс)"
$script:ManualIfaceLabel = T "Enter manually..." "Ввести вручную..."

# ============================================================
# UI HELPERS
# ============================================================

function New-FlatButton {
    param([string]$Text, [int]$X, [int]$Y, [int]$W=120, [int]$H=28,
          [System.Drawing.Color]$Bg=$C.BtnRel,
          [System.Drawing.Color]$Fg=$C.TextDark,
          [System.Drawing.Color]$Hov=$C.BtnRelHov,
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
    param([int]$X, [int]$Y, [int]$W=80, [string]$Default="", [bool]$Enabled=$true)
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
        $bgColor = if ($e.State -band [System.Windows.Forms.DrawItemState]::Selected) { $C.ListSel } else { $C.Input }
        $e.Graphics.FillRectangle((New-Object System.Drawing.SolidBrush($bgColor)), $e.Bounds)
        $txt = $s.Items[$e.Index].ToString()
        $e.Graphics.DrawString($txt, $e.Font, (New-Object System.Drawing.SolidBrush($C.Text)),
            ($e.Bounds.X + 4), ($e.Bounds.Y + 2))
    })

    $cb.Add_Paint({
        param($s, $e)
        $w  = $s.Width
        $h  = $s.Height
        $aw = 18
        $arrowRect = New-Object System.Drawing.Rectangle(($w - $aw - 1), 1, ($aw), ($h - 2))
        $e.Graphics.FillRectangle((New-Object System.Drawing.SolidBrush($C.Card)), $arrowRect)
        $ax = $w - $aw/2 - 1
        $ay = $h/2
        $pts = @(
            (New-Object System.Drawing.Point(($ax - 4), ($ay - 2))),
            (New-Object System.Drawing.Point(($ax + 4), ($ay - 2))),
            (New-Object System.Drawing.Point(($ax),     ($ay + 3)))
        )
        $e.Graphics.FillPolygon((New-Object System.Drawing.SolidBrush($C.TextDim)), $pts)
        $e.Graphics.DrawRectangle(
            (New-Object System.Drawing.Pen($C.Border)),
            0, 0, ($w - 1), ($h - 1))
    })

    foreach ($i in $Items) { [void]$cb.Items.Add($i) }
    if ($Selected -and $cb.Items.Contains($Selected)) { $cb.SelectedItem = $Selected }
    elseif ($cb.Items.Count -gt 0) { $cb.SelectedIndex = 0 }
    return $cb
}

function New-Sep {
    param([int]$X, [int]$Y, [int]$W)
    $p           = New-Object System.Windows.Forms.Panel
    $p.Location  = New-Object System.Drawing.Point($X, $Y)
    $p.Size      = New-Object System.Drawing.Size($W, 2)
    $p.BackColor = $C.Border
    return $p
}

function Show-IPv4InputDialog {
    param(
        [string]$Title,
        [string]$Prompt
    )

    $dlg                 = New-Object System.Windows.Forms.Form
    $dlg.Text            = $Title
    $dlg.Size            = New-Object System.Drawing.Size(360, 168)
    $dlg.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $dlg.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $dlg.MinimizeBox     = $false
    $dlg.MaximizeBox     = $false
    $dlg.BackColor       = $C.Card
    $dlg.ForeColor       = $C.Text
    $dlg.Font            = $F.Main

    $lbl           = New-Label $Prompt 16 16 320 20 $C.TextDim
    $dlg.Controls.Add($lbl)

    $tb             = New-TextBox 16 42 320 ""
    $dlg.Controls.Add($tb)

    $lblErr           = New-Label "" 16 68 320 18 $C.Danger
    $dlg.Controls.Add($lblErr)

    $btnOK     = New-FlatButton (T "OK" "ОК")     116 96 100 30 $C.BtnRun $C.TextDark $C.BtnRunHov
    $btnCancel = New-FlatButton (T "Cancel" "Отмена") 224 96 100 30 $C.BtnRel  $C.Text     $C.BtnRelHov
    $dlg.Controls.Add($btnOK)
    $dlg.Controls.Add($btnCancel)
    $dlg.AcceptButton = $btnOK
    $dlg.CancelButton = $btnCancel

    $script:ipDialogResult = $null

    $btnOK.Add_Click({
        $val = $tb.Text.Trim()
        try {
            $ipObj = [System.Net.IPAddress]::Parse($val)
            if ($ipObj.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
                throw 'not IPv4'
            }
            $script:ipDialogResult = $val
            $dlg.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $dlg.Close()
        } catch {
            $lblErr.Text = T "Enter a valid IPv4 address." "Введите корректный IPv4-адрес."
        }
    })
    $btnCancel.Add_Click({
        $dlg.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $dlg.Close()
    })

    [void]$tb.Focus()
    [void]$dlg.ShowDialog()
    return $script:ipDialogResult
}

function Get-TS { return (Get-Date).ToString("HH:mm:ss") }

function Get-LocalIPv4List {
    $out = @()
    try {
        $adapters = Get-NetAdapter -ErrorAction Stop | Sort-Object ifIndex
        foreach ($adapter in $adapters) {
            $addresses = Get-NetIPAddress -InterfaceIndex $adapter.ifIndex `
                -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                Where-Object { $_.IPAddress -notlike '169.254.*' }
            foreach ($addr in $addresses) {
                $out += "$($addr.IPAddress)  ($($adapter.Name))"
            }
        }
    } catch {}
    return $out
}

# ============================================================
# MAIN FORM
# ============================================================

$form                 = New-Object System.Windows.Forms.Form
$form.Text            = (T "QUAS mDNS Connector  v3.3" "QUAS mDNS Коннектор  v3.3")
$form.ClientSize      = New-Object System.Drawing.Size(800, 560)
$form.MinimumSize     = New-Object System.Drawing.Size(800, 560)
$form.BackColor       = $C.Bg
$form.ForeColor       = $C.Text
$form.Font            = $F.Main
$form.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox     = $false

# Title
$titleLbl           = New-Object System.Windows.Forms.Label
$titleLbl.Text      = "  " + (T "QUAS mDNS Connector" "QUAS mDNS Коннектор")
$titleLbl.Location  = New-Object System.Drawing.Point(0, 0)
$titleLbl.Size      = New-Object System.Drawing.Size(800, 34)
$titleLbl.ForeColor = $C.Accent
$titleLbl.Font      = $F.Title
$titleLbl.BackColor = $C.Panel
$titleLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$form.Controls.Add($titleLbl)

# ------------------------------------------------------------
# Left panel - MODE list (replaces the former profile list)
# ------------------------------------------------------------
$leftPanel           = New-Object System.Windows.Forms.Panel
$leftPanel.Location  = New-Object System.Drawing.Point(0, 34)
$leftPanel.Size      = New-Object System.Drawing.Size(218, 502)
$leftPanel.BackColor = $C.Panel
$form.Controls.Add($leftPanel)

$leftPanel.Controls.Add((New-Label (T "MODE" "РЕЖИМ") 12 8 140 18 $C.TextDim))

$modeList              = New-Object System.Windows.Forms.ListBox
$modeList.Location     = New-Object System.Drawing.Point(10, 28)
$modeList.Size         = New-Object System.Drawing.Size(198, 328)
$modeList.BackColor    = $C.Card
$modeList.ForeColor    = $C.Text
$modeList.Font         = $F.Main
$modeList.BorderStyle  = [System.Windows.Forms.BorderStyle]::None
$modeList.DrawMode     = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$modeList.ItemHeight   = 24
foreach ($m in $ModeItems) { [void]$modeList.Items.Add($m) }
$modeList.Add_DrawItem({
    param($s, $e)
    if ($e.Index -lt 0) { return }
    $bgColor = if ($e.State -band [System.Windows.Forms.DrawItemState]::Selected) { $C.ListSel } else { $C.Card }
    $e.Graphics.FillRectangle((New-Object System.Drawing.SolidBrush($bgColor)), $e.Bounds)
    $fgColor = if ($e.State -band [System.Windows.Forms.DrawItemState]::Selected) { $C.Accent } else { $C.Text }
    $txt = $s.Items[$e.Index].ToString()
    $e.Graphics.DrawString($txt, $F.Main, (New-Object System.Drawing.SolidBrush($fgColor)),
        ($e.Bounds.X + 10), ($e.Bounds.Y + 4))
})
$leftPanel.Controls.Add($modeList)

$leftPanel.Controls.Add((New-Sep 10 362 198))

$leftPanel.Controls.Add((New-Label (T "DESCRIPTION" "ОПИСАНИЕ") 12 370 140 16 $C.TextDim))
$txtModeDesc             = New-Object System.Windows.Forms.TextBox
$txtModeDesc.Location    = New-Object System.Drawing.Point(10, 390)
$txtModeDesc.Size        = New-Object System.Drawing.Size(198, 106)
$txtModeDesc.Multiline   = $true
$txtModeDesc.ReadOnly    = $true
$txtModeDesc.BackColor   = $C.Panel
$txtModeDesc.ForeColor   = $C.TextDim
$txtModeDesc.Font        = $F.Small
$txtModeDesc.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$txtModeDesc.TabStop     = $false
$leftPanel.Controls.Add($txtModeDesc)

# ------------------------------------------------------------
# Right panel - parameters
# ------------------------------------------------------------
$rightPanel           = New-Object System.Windows.Forms.Panel
$rightPanel.Location  = New-Object System.Drawing.Point(218, 34)
$rightPanel.Size      = New-Object System.Drawing.Size(582, 502)
$rightPanel.BackColor = $C.Bg
$form.Controls.Add($rightPanel)

$LX   = 16
$LW   = 130
$TX   = 150
$TW   = 148
$CX   = 306
$rowH = 32

$y = 16

# Autoconnect combo (formerly the Mode combo slot) - stays above PC interface
$rightPanel.Controls.Add((New-Label (T "Autoconnect:" "Autoconnect:") $LX ($y+4) $LW 18))
$rowAutoconn = New-ComboBox $TX $y 220 $AutoconnectItems
$rightPanel.Controls.Add($rowAutoconn)
$y += $rowH

$rightPanel.Controls.Add((New-Sep 10 $y 552))
$y += 8

# PC interface (IPPC)
$rightPanel.Controls.Add((New-Label (T "PC interface:" "Интерфейс ПК:") $LX ($y+4) $LW 18))
$rowIPPC = New-ComboBox $TX $y 220 @($script:AutoIfaceLabel)
$rightPanel.Controls.Add($rowIPPC)
$ttIPPC  = New-Object System.Windows.Forms.ToolTip
$ttIPPC.InitialDelay = 300
$ttIPPC.ReshowDelay  = 100
$ttIPPC.ShowAlways   = $true
$y += $rowH

function Add-NumRow {
    param([string]$Lbl, [string]$Key, [string]$Hint, [ref]$YRef)
    $yv = $YRef.Value
    $rightPanel.Controls.Add((New-Label $Lbl $LX ($yv+4) $LW 18))
    $tb             = New-TextBox $TX $yv $TW "" $false
    $tb.Tag         = $Hint
    $tb.ForeColor   = $C.TextDim
    $tb.Text        = $Hint
    $rightPanel.Controls.Add($tb)
    $chk        = New-CheckBox "manual" $CX $yv $false 80
    $chk.Tag    = $tb
    $chk.Add_CheckedChanged({
        $field = $this.Tag
        if ($this.Checked) {
            if ($field.ForeColor -eq $C.TextDim) {
                $field.Text      = ""
                $field.ForeColor = $C.Text
            }
            $field.Enabled = $true
            $field.Focus()
            $field.SelectAll()
        } else {
            $field.Enabled = $false
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

$yRef = [ref]$y
$rowIPQuest    = Add-NumRow (T "Quest IP filter:" "Фильтр IP Quest:")    "ipquest"    (T "(any)" "(любой)")         $yRef
$rowRetries    = Add-NumRow (T "Retries:" "Попытки:")            "retries"    "5"             $yRef
$rowTimeout    = Add-NumRow (T "Timeout:" "Тайм-аут:")      "timeout"    (T "0 sec (unlimited)" "0 сек (безлимит)") $yRef
$rowRetryDelay = Add-NumRow (T "Retry delay:" "Задержка повтора:")  "retrydelay" (T "5 sec" "5 сек")             $yRef

# Close delay - applies to every mode, not gated by Set-ModeState
$rowCloseDelay = Add-NumRow (T "Close delay:" "Задержка закрытия:") "timesleep" (T "5 sec (0=Enter)" "5 сек (0=Enter)") $yRef
$rowCloseDelay.chk.Enabled = $true

# Verbose - directly below Close delay, above the separator
$rightPanel.Controls.Add((New-Label (T "Verbose:" "Подробно:") $LX ($yRef.Value+4) $LW 18))
$rowVerbose = @{}
$rowVerbose.chk = New-CheckBox "OFF" $TX $yRef.Value $false $TW
$rowVerbose.chk.Add_CheckedChanged({ $this.Text = if ($this.Checked) { "ON" } else { "OFF" } })
$rightPanel.Controls.Add($rowVerbose.chk)
$yRef.Value += $rowH

$rightPanel.Controls.Add((New-Sep 10 $yRef.Value 552))
$yRef.Value += 8

# Extra params
$rightPanel.Controls.Add((New-Label (T "Extra args:" "Доп. аргументы:") $LX ($yRef.Value+4) $LW 18))
$txtExtra = New-TextBox $TX $yRef.Value 392
$rightPanel.Controls.Add($txtExtra)
$yRef.Value += $rowH

$rightPanel.Controls.Add((New-Sep 10 $yRef.Value 552))
$yRef.Value += 8

# Preview
$rightPanel.Controls.Add((New-Label (T "Command preview:" "Предпросмотр команды:") $LX $yRef.Value 150 18 $C.TextDim))
$yRef.Value += 20
$txtPreview             = New-Object System.Windows.Forms.TextBox
$txtPreview.Location    = New-Object System.Drawing.Point($LX, $yRef.Value)
$txtPreview.Size        = New-Object System.Drawing.Size(548, 70)
$txtPreview.BackColor   = $C.Card
$txtPreview.ForeColor   = $C.Preview
$txtPreview.Font        = $F.Small
$txtPreview.Multiline   = $true
$txtPreview.ReadOnly    = $true
$txtPreview.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$rightPanel.Controls.Add($txtPreview)

# Buttons anchored at the bottom of the right panel
$rightPanel.Controls.Add((New-Sep 10 456 552))
$btnRun   = New-FlatButton (T "Run" "Запуск")   $LX        466 230 40 $C.BtnRun $C.TextDark $C.BtnRunHov $F.BtnBig
$btnReset = New-FlatButton (T "Reset" "Сброс") ($LX+242)  466 150 40 $C.BtnDel $C.TextDark $C.BtnDelHov $F.BtnBig
$rightPanel.Controls.Add($btnRun)
$rightPanel.Controls.Add($btnReset)

$btnHelp = New-FlatButton "?" 526 466 42 40 $C.BtnRel $C.Text $C.BtnRelHov $F.BtnBig
$rightPanel.Controls.Add($btnHelp)

# Status bar
$statusLbl           = New-Object System.Windows.Forms.Label
$statusLbl.Location  = New-Object System.Drawing.Point(0, 536)
$statusLbl.Size      = New-Object System.Drawing.Size(800, 24)
$statusLbl.BackColor = $C.Panel
$statusLbl.ForeColor = $C.TextDim
$statusLbl.Font      = New-Object System.Drawing.Font("Segoe UI", 8.5)
$statusLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLbl.Text      = "  " + (T "Ready" "Готово")
$form.Controls.Add($statusLbl)

# ============================================================
# DEPENDENCY / INCOMPATIBILITY LOGIC
# ============================================================

function Set-ModeState {
    $modeName = $modeList.SelectedItem.ToString()
    $txtModeDesc.Text = $ModeDescriptions[$modeName]

    $isAutoconnectSelected = ($modeName -eq "Autoconnect")
    $acChosen  = $isAutoconnectSelected -and ($rowAutoconn.SelectedIndex -gt 0)

    # Fields unlock as soon as the Autoconnect MODE is picked on the
    # left - they don't also require a specific 0/1/2 value from the
    # dropdown first, so the user can fill in Retries/Timeout/Retry
    # delay while still deciding which Autoconnect value to use.
    # The dropdown value only gates what actually reaches the built
    # command (see Build-ArgParts) - until a real value is chosen
    # there, the preview stays empty even though the fields are live.
    $allowNet  = $isAutoconnectSelected -or $modeName -eq "Listener" -or $modeName -eq "Dumper"
    $allowDisc = $isAutoconnectSelected

    $rowAutoconn.Enabled = $isAutoconnectSelected
    if (-not $isAutoconnectSelected) { $rowAutoconn.SelectedIndex = 0 }

    $rowIPPC.Enabled = $allowNet
    if (-not $allowNet -and $rowIPPC.Items.Count -gt 0) { $rowIPPC.SelectedIndex = 0 }

    $rowIPQuest.chk.Enabled = $allowNet
    if (-not $allowNet -and $rowIPQuest.chk.Checked) { $rowIPQuest.chk.Checked = $false }
    $rowIPQuest.tb.Enabled = $allowNet -and $rowIPQuest.chk.Checked

    foreach ($row in @($rowRetries,$rowTimeout,$rowRetryDelay)) {
        $row.chk.Enabled = $allowDisc
        if (-not $allowDisc -and $row.chk.Checked) { $row.chk.Checked = $false }
        $row.tb.Enabled = $allowDisc -and $row.chk.Checked
    }

    $rowVerbose.chk.Enabled = $true
}

# ============================================================
# COMMAND BUILDING
# ============================================================

function Get-ScriptDisplayName { return ".\$ScriptFileName" }

function Build-ArgParts {
    $parts = @()
    $modeName = $modeList.SelectedItem.ToString()

    $isAutoconnectSelected = ($modeName -eq "Autoconnect")
    $acIdx     = $rowAutoconn.SelectedIndex
    $acChosen  = $isAutoconnectSelected -and ($acIdx -gt 0)

    if ($isAutoconnectSelected) {
        # No flag at all until a real value is picked from the
        # "Select mode..." combo - -discover no longer exists;
        # -autoconnect N is itself the mode switch now.
        if ($acChosen) { $parts += "-autoconnect"; $parts += "$($acIdx - 1)" }
    } else {
        $flag = $ModeFlags[$modeName]
        $parts += "-$flag"
    }

    $allowNet  = $acChosen -or $modeName -eq "Listener" -or $modeName -eq "Dumper"
    $allowDisc = $acChosen

    if ($allowNet) {
        $ippcSel = $rowIPPC.SelectedItem
        if ($ippcSel -and $ippcSel.ToString() -ne $script:AutoIfaceLabel -and $ippcSel.ToString() -ne $script:ManualIfaceLabel) {
            $ip = ($ippcSel.ToString() -split '\s+')[0]
            $parts += "-IPPC"; $parts += $ip
        }
        if ($rowIPQuest.chk.Checked -and $rowIPQuest.tb.Text.Trim()) {
            $parts += "-IPQuest"; $parts += $rowIPQuest.tb.Text.Trim()
        }
    }

    if ($allowDisc) {
        if ($rowRetries.chk.Checked -and $rowRetries.tb.Text.Trim()) {
            $parts += "-retries"; $parts += $rowRetries.tb.Text.Trim()
        }
        if ($rowTimeout.chk.Checked -and $rowTimeout.tb.Text.Trim()) {
            $parts += "-timeout"; $parts += $rowTimeout.tb.Text.Trim()
        }
        if ($rowRetryDelay.chk.Checked -and $rowRetryDelay.tb.Text.Trim()) {
            $parts += "-retrydelay"; $parts += $rowRetryDelay.tb.Text.Trim()
        }
    }

    if ($rowVerbose.chk.Checked) { $parts += "-Verbose" }

    if ($parts.Count -gt 0) {
        if ($ToolsPath) { $parts += "-ToolsPath"; $parts += $ToolsPath }
        if ($rowCloseDelay.chk.Checked -and $rowCloseDelay.tb.Text.Trim()) {
            $parts += "-TimeSleep"; $parts += $rowCloseDelay.tb.Text.Trim()
        }
        $parts += "-lang"; $parts += $script:Lang
    }

    $ex = $txtExtra.Text.Trim()
    if ($ex) { $parts += $ex }

    return $parts
}

function Update-Preview {
    $argParts = Build-ArgParts
    if ($argParts.Count -eq 0) {
        $txtPreview.Text = (Get-ScriptDisplayName) + "  " + (T "(pick a value in the Autoconnect list above to build a command)" "(выберите значение в списке Autoconnect выше, чтобы собрать команду)")
    } else {
        $txtPreview.Text = (Get-ScriptDisplayName) + " " + ($argParts -join " ")
    }
}

# ============================================================
# RESET
# ============================================================

function Reset-Form {
    $script:suppressEvents = $true

    $modeList.SelectedIndex = 0
    $rowAutoconn.SelectedIndex = 0
    if ($rowIPPC.Items.Count -gt 0) { $rowIPPC.SelectedIndex = 0 }

    foreach ($row in @($rowIPQuest,$rowRetries,$rowTimeout,$rowRetryDelay,$rowCloseDelay)) {
        $row.chk.Checked  = $false
        $row.tb.Enabled   = $false
        $row.tb.ForeColor = $C.TextDim
        $row.tb.Text      = $row.hint
    }
    $rowVerbose.chk.Checked = $false
    $txtExtra.Text = ""

    $script:suppressEvents = $false
    Set-ModeState
    Update-Preview
    $statusLbl.Text      = "  [" + (Get-TS) + "]  " + (T "Reset to defaults." "Сброшено к значениям по умолчанию.")
    $statusLbl.ForeColor = $C.TextDim
}

# ============================================================
# EVENTS
# ============================================================

$script:suppressEvents = $false

$modeList.Add_SelectedIndexChanged({
    Set-ModeState
    Update-Preview
})

$rowAutoconn.Add_SelectedIndexChanged({
    Set-ModeState
    Update-Preview
})
$rowIPPC.Add_SelectedIndexChanged({
    if ($script:suppressIPPCEvent) { return }

    if ($rowIPPC.SelectedItem -and $rowIPPC.SelectedItem.ToString() -eq $script:ManualIfaceLabel) {

        $entered = Show-IPv4InputDialog `
            -Title  (T "Enter PC interface IP" "Введите IP интерфейса ПК") `
            -Prompt (T "PC network interface IPv4 address:" "IPv4-адрес сетевого интерфейса ПК:")

        $script:suppressIPPCEvent = $true

        if ($entered) {
            $label = "$entered  (" + (T "Manual" "Вручную") + ")"

            # Reuse the existing manual entry if there is one, so
            # re-entering a new IP doesn't pile up duplicate items.
            $existingIdx = -1
            for ($i = 0; $i -lt $rowIPPC.Items.Count; $i++) {
                if ($rowIPPC.Items[$i].ToString().EndsWith("(" + (T "Manual" "Вручную") + ")")) {
                    $existingIdx = $i
                    break
                }
            }
            if ($existingIdx -ge 0) {
                $rowIPPC.Items[$existingIdx] = $label
                $rowIPPC.SelectedIndex = $existingIdx
            } else {
                $insertAt = $rowIPPC.Items.Count - 1
                $rowIPPC.Items.Insert($insertAt, $label)
                $rowIPPC.SelectedIndex = $insertAt
            }
        } else {
            $rowIPPC.SelectedIndex = 0
        }

        $script:suppressIPPCEvent = $false
    }

    if ($rowIPPC.SelectedItem) { $ttIPPC.SetToolTip($rowIPPC, $rowIPPC.SelectedItem.ToString()) }
    Update-Preview
})

foreach ($ctl in @($rowIPQuest.tb,$rowRetries.tb,$rowTimeout.tb,$rowRetryDelay.tb,$rowCloseDelay.tb,$txtExtra)) {
    $ctl.Add_TextChanged({ Update-Preview })
}
foreach ($chk in @($rowIPQuest.chk,$rowRetries.chk,$rowTimeout.chk,$rowRetryDelay.chk,$rowCloseDelay.chk,$rowVerbose.chk)) {
    $chk.Add_CheckedChanged({ Update-Preview })
}

$btnReset.Add_Click({ Reset-Form })

$btnRun.Add_Click({
    if (-not $script:ExtractedScriptPath -or -not (Test-Path -LiteralPath $script:ExtractedScriptPath)) {
        $script:ExtractedScriptPath = Save-EmbeddedScript
    }
    if (-not $script:ExtractedScriptPath) {
        [System.Windows.Forms.MessageBox]::Show(
            (T "Could not write the embedded script to disk:" "Не удалось записать встроенный скрипт на диск:") + "`n$ExtractDir`n`n" + (T "Try running as administrator or check disk space." "Попробуйте запустить от имени администратора или проверьте место на диске."),
            (T "Extraction Failed" "Ошибка распаковки"),
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $argParts  = Build-ArgParts
    $argString = $argParts -join " "

    # The embedded script now controls its own window-close
    # behavior via -TimeSleep (see Wait-BeforeExit / Exit-Quas),
    # so it is launched without -NoExit for every mode - it closes
    # itself instead of leaving an idle console behind.
    $psArgs = '-NoLogo -ExecutionPolicy Bypass -File "' + $script:ExtractedScriptPath + '" ' + $argString

    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList $psArgs `
            -WorkingDirectory (Split-Path -Parent $script:ExtractedScriptPath)
        $statusLbl.Text      = "  [" + (Get-TS) + "]  " + (T "Launched: " "Запущено: ") + (Get-ScriptDisplayName) + " " + $argString
        $statusLbl.ForeColor = $C.BtnRun
    } catch {
        $statusLbl.Text      = "  [" + (Get-TS) + "]  " + (T "ERROR: could not launch script." "ОШИБКА: не удалось запустить скрипт.")
        $statusLbl.ForeColor = $C.Danger
    }
})

$btnHelp.Add_Click({
    $dlg                 = New-Object System.Windows.Forms.Form
    $dlg.Text            = (T "QUAS mDNS Connector - Help" "QUAS mDNS Коннектор - Справка")
    $dlg.Size            = New-Object System.Drawing.Size(880, 720)
    $dlg.MinimizeBox     = $false
    $dlg.MaximizeBox     = $false
    $dlg.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $dlg.BackColor       = $C.Card
    $dlg.ForeColor       = $C.Text
    $dlg.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

    $rtbL = New-Object System.Windows.Forms.RichTextBox
    $rtbL.Location    = New-Object System.Drawing.Point(12, 12)
    $rtbL.Size        = New-Object System.Drawing.Size(410, 680)
    $rtbL.BackColor   = $C.Card
    $rtbL.ForeColor   = $C.Text
    $rtbL.ReadOnly    = $true
    $rtbL.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $rtbL.ScrollBars  = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $rtbL.Font        = New-Object System.Drawing.Font("Segoe UI", 9)
    $dlg.Controls.Add($rtbL)

    $div           = New-Object System.Windows.Forms.Panel
    $div.Location  = New-Object System.Drawing.Point(420, 12)
    $div.Size      = New-Object System.Drawing.Size(1, 680)
    $div.BackColor = $C.Border
    $dlg.Controls.Add($div)

    $rtbR = New-Object System.Windows.Forms.RichTextBox
    $rtbR.Location    = New-Object System.Drawing.Point(427, 12)
    $rtbR.Size        = New-Object System.Drawing.Size(430, 680)
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

    W $rtbL (T "MODE LIST" "СПИСОК РЕЖИМОВ") $true
    W $rtbL (T "  Left panel. Click a mode to select it; the" "  Левая панель. Кликните режим, чтобы выбрать его;")
    W $rtbL (T "  description box below updates automatically." "  описание под списком обновится автоматически.")
    W $rtbL "  Autoconnect" $true $false; W $rtbL (T "mDNS discovery, optional autoconnect." "Поиск по mDNS, опциональное автоподключение.") $false
    W $rtbL "  Listener   " $true $false; W $rtbL (T "Listen for mDNS packets (Enter to stop)." "Прослушивание mDNS-пакетов (Enter - стоп).") $false
    W $rtbL "  Dumper     " $true $false; W $rtbL (T "Dump raw mDNS packets in hex." "Дамп mDNS-пакетов в hex.") $false
    W $rtbL "  Adapters   " $true $false; W $rtbL (T "List PC network adapters." "Список сетевых адаптеров ПК.") $false
    W $rtbL "  ADB Version" $true $false; W $rtbL (T "Show adb.exe version." "Показать версию adb.exe.") $false
    W $rtbL "  ADB Server " $true $false; W $rtbL (T "Restart the ADB server." "Перезапустить ADB-сервер.") $false
    W $rtbL "  Services   " $true $false; W $rtbL (T "adb mdns services output." "Вывод adb mdns services.") $false
    W $rtbL ""
    W $rtbL (T "DEPENDENCIES" "ЗАВИСИМОСТИ") $true
    W $rtbL (T "  Retries, Timeout, Retry delay, PC interface and" "  Retries, Timeout, Retry delay, PC interface и") $false
    W $rtbL (T "  Quest IP filter unlock as soon as Autoconnect is" "  Quest IP filter разблокируются сразу при выборе") $false
    W $rtbL (T "  picked on the left - no need to also pick a" "  Autoconnect слева - выбирать конкретное значение") $false
    W $rtbL (T "  0/1/2 value first." "  0/1/2 сразу необязательно.") $false
    W $rtbL (T "  The command stays empty, though, until a real" "  Но команда останется пустой, пока в списке справа") $false
    W $rtbL (T "  0/1/2 value is picked in the list on the right." "  не будет выбрано реальное значение 0/1/2.") $false
    W $rtbL (T "  PC interface / Quest IP filter also work for" "  PC interface / Quest IP filter также работают") $false
    W $rtbL (T "  Listener and Dumper." "  для Listener и Dumper.") $false
    W $rtbL (T "  Verbose works with every mode." "  Verbose работает в любом режиме.")
    W $rtbL (T "  Switching the left-hand mode automatically" "  При смене режима слева несовместимые поля")
    W $rtbL (T "  disables and resets any incompatible field." "  автоматически отключаются и сбрасываются.")
    W $rtbL ""
    W $rtbL (T "AUTOCONNECT VALUES" "ЗНАЧЕНИЯ AUTOCONNECT") $true
    W $rtbL "  0 - Details only     " $true $false; W $rtbL (T "Print IP/port, do not connect." "Показать IP/порт, без подключения.") $false
    W $rtbL "  1 - Details + Connect" $true $false; W $rtbL (T "Print details, then connect." "Показать детали, затем подключиться.") $false
    W $rtbL "  2 - Connect only     " $true $false; W $rtbL (T "Connect silently, no details." "Подключение без вывода деталей.") $false
    W $rtbL ""
    W $rtbL (T "PARAMETERS" "ПАРАМЕТРЫ") $true
    W $rtbL "  " $false $false; W $rtbL (T "manual" "manual") $true $false; W $rtbL (T " toggle: " " переключатель: ") $false $false; W $rtbL (T "Gray" "Серый") $true $false; W $rtbL (T "=default  " "=по умолч.  ") $false $false; W $rtbL (T "Blue" "Синий") $true $false; W $rtbL (T "=manual." "=вручную.") $false
    W $rtbL (T "  Gray numbers in fields are hints only, not sent." "  Серые числа в полях - подсказки, они не отправляются.")
    W $rtbL ""
    W $rtbL "  PC interface " $true $false; W $rtbL (T "(-IPPC) Detected local IPv4" "(-IPPC) Обнаруженные локальные IPv4-") $false
    W $rtbL (T "                 addresses, or Auto to omit the flag." "                 адреса, либо Auto, чтобы не передавать флаг.") $false
    W $rtbL (T "                 Hover a long entry to see its full" "                 Наведите на длинную запись, чтобы увидеть") $false
    W $rtbL (T "                 adapter name as a tooltip." "                 полное имя адаптера во всплывающей подсказке.") $false
    W $rtbL "  Quest IP     " $true $false; W $rtbL (T "(-IPQuest) Filter by remote IP." "(-IPQuest) Фильтр по удалённому IP.") $false
    W $rtbL "  Retries      " $true $false; W $rtbL (T "(-retries) Attempts. Default: 5." "(-retries) Число попыток. По умолчанию: 5.") $false
    W $rtbL "  Timeout      " $true $false; W $rtbL (T "(-timeout) Per-attempt limit, sec." "(-timeout) Лимит на попытку, сек.") $false
    W $rtbL "  Retry delay  " $true $false; W $rtbL (T "(-retrydelay) Delay between tries." "(-retrydelay) Задержка между попытками.") $false
    W $rtbL "  Verbose      " $true $false; W $rtbL (T "(-Verbose) Detailed diagnostics." "(-Verbose) Подробная диагностика.") $false
    W $rtbL "  Close delay  " $true $false; W $rtbL (T "(-TimeSleep) Seconds before the" "(-TimeSleep) Секунды до") $false
    W $rtbL (T "                 console window closes on its own." "                 автоматического закрытия окна консоли.") $false
    W $rtbL (T "                 0 = wait for Enter instead of a timer." "                 0 = ждать Enter вместо таймера.") $false
    W $rtbL "  Extra args   " $true $false; W $rtbL (T "Appended verbatim to the command." "Добавляются в команду как есть.") $false
    W $rtbL ""

    W $rtbR (T "BUTTONS" "КНОПКИ") $true
    W $rtbR "  Run   " $true $false; W $rtbR (T "Launch the command in a new console window." "Запустить команду в новом окне консоли.") $false
    W $rtbR "  Reset " $true $false; W $rtbR (T "Restore every field to its default state." "Вернуть все поля к значениям по умолчанию.") $false
    W $rtbR ""
    W $rtbR (T "IN-CONSOLE KEYS" "КЛАВИШИ В КОНСОЛИ") $true
    W $rtbR (T "  Autoconnect search:" "  Поиск Autoconnect:") $false
    W $rtbR "  Enter " $true $false; W $rtbR (T "stops searching / retrying." "останавливает поиск / повторы.") $false
    W $rtbR "  Space " $true $false; W $rtbR (T "skips ahead to the next attempt now." "переходит к следующей попытке сейчас.") $false
    W $rtbR (T "  Listener / Dumper:" "  Listener / Dumper:") $false
    W $rtbR "  Enter " $true $false; W $rtbR (T "stops listening / dumping." "останавливает прослушивание / дамп.") $false
    W $rtbR ""
    W $rtbR (T "CONSOLE WINDOW CLOSE" "ЗАКРЫТИЕ ОКНА КОНСОЛИ") $true
    W $rtbR (T "  Controlled by " "  Управляется полем ") $false $false; W $rtbR (T "Close delay" "Close delay") $true $false; W $rtbR (T " above, sent as" " выше, передаётся как") $false
    W $rtbR (T "  -TimeSleep to the script itself - the window" "  -TimeSleep самому скрипту - окно закрывается") $false
    W $rtbR (T "  closes on its own once the command is done," "  само после завершения команды,") $false
    W $rtbR (T "  the same way for every mode." "  одинаково для любого режима.")
    W $rtbR (T "  > 0: closes automatically after that many seconds." "  > 0: закрывается автоматически через столько секунд.")
    W $rtbR "  0  : " $false $false; W $rtbR (T "shows " "показывает ") $false $false; W $rtbR (T "Press Enter to close this window..." "Press Enter to close this window...") $true $false
    W $rtbR "" $false
    W $rtbR ""
    W $rtbR (T "EMBEDDED SCRIPT" "ВСТРОЕННЫЙ СКРИПТ") $true
    W $rtbR ("  $ScriptFileName " + (T "is bundled inside this GUI" "встроен внутрь этого GUI-")) $false
    W $rtbR (T "  file - there is no external dependency to locate." "  файла - искать внешнюю зависимость не нужно.") $false
    W $rtbR (T "  On startup it is written to:" "  При старте он записывается в:") $false
    W $rtbR "  $ExtractDir" $true $false; W $rtbR "" $false
    W $rtbR (T "  and launched from there when Run is clicked." "  и запускается оттуда по нажатию Run.") $false
    W $rtbR ""
    W $rtbR (T "  Pass -WorkDir to control the extraction folder" "  Передайте -WorkDir, чтобы задать папку распаковки") $false
    W $rtbR (T "  (falls back to %TEMP% otherwise):" "  (иначе используется %TEMP%):") $false
    W $rtbR "  powershell -ExecutionPolicy Bypass" $true $false; W $rtbR "" $false
    W $rtbR "    -File conf.ps1 -WorkDir ""%~dp0""" $true $false; W $rtbR "" $false
    W $rtbR ""
    W $rtbR (T "FINDING adb.exe" "ПОИСК adb.exe") $true
    W $rtbR (T "  Every launch passes -ToolsPath automatically:" "  Каждый запуск автоматически передаёт -ToolsPath:") $false
    W $rtbR "  $ToolsPath" $true $false; W $rtbR "" $false
    W $rtbR (T "  (the -WorkDir folder, or this GUI's own folder" "  (папка -WorkDir, либо папка самого этого GUI,") $false
    W $rtbR (T "  if -WorkDir was not given). Checked before" "  если -WorkDir не задан). Проверяется раньше, чем") $false
    W $rtbR (T "  %myfiles%, next to the script and PATH." "  %myfiles%, рядом со скриптом и PATH.") $false
    W $rtbR ""
    W $rtbR (T "LANGUAGE" "ЯЗЫК") $true
    W $rtbR (T "  -lang EN|RU sets the interface language for" "  -lang EN|RU задаёт язык интерфейса для GUI") $false
    W $rtbR (T "  both this GUI and the launched console tool." "  и запускаемого консольного инструмента.") $false
    W $rtbR (T "  Default: EN." "  По умолчанию: EN.") $false
    W $rtbR ""
    W $rtbR (T "FORCE CONSOLE MODE" "ПРИНУДИТЕЛЬНАЯ КОНСОЛЬ") $true
    W $rtbR (T "  -console runs the embedded tool in this console" "  -console запускает встроенный инструмент в этой") $false
    W $rtbR (T "  even with no other console-tool argument present -" "  консоли даже без других её аргументов -") $false
    W $rtbR (T "  useful from a batch file when '-lang RU' alone" "  полезно в батниках, когда одного '-lang RU'") $false
    W $rtbR (T "  would otherwise be ambiguous (GUI or console?)." "  недостаточно, чтобы понять - нужен GUI или консоль.") $false
    W $rtbR ""
    W $rtbR (T "STATUS BAR" "СТАТУС-БАР") $true
    W $rtbR (T "  Shows a timestamp [HH:mm:ss] for the last action" "  Показывает метку времени [ЧЧ:мм:сс] последнего")
    W $rtbR (T "  and highlights errors in red." "  действия и подсвечивает ошибки красным.")
    W $rtbR ""
    W $rtbR "(c) 2026 Varset" $false

    $rtbL.SelectionStart = 0
    $rtbR.SelectionStart = 0
    [void]$dlg.ShowDialog()
})

# ============================================================
# STARTUP
# ============================================================

$modeList.SelectedIndex = 0

$form.Add_Shown({
    $statusLbl.Text      = "  " + (T "Detecting network interfaces..." "Определение сетевых интерфейсов...")
    $statusLbl.ForeColor = $C.TextDim

    $script:ipTimer = New-Object System.Windows.Forms.Timer
    $script:ipTimer.Interval = 150
    $script:ipTimer.Add_Tick({
        param($sender, $e)
        $sender.Stop()
        $sender.Dispose()
        $script:ipTimer = $null

        $ipList = Get-LocalIPv4List
        foreach ($ip in $ipList) { [void]$rowIPPC.Items.Add($ip) }
        [void]$rowIPPC.Items.Add($script:ManualIfaceLabel)
        $rowIPPC.SelectedIndex = 0

        # Widen the dropdown popup (not the closed box) so long
        # adapter names are not truncated in the open list.
        if ($ipList.Count -gt 0) {
            $maxW = $rowIPPC.Width
            foreach ($item in $rowIPPC.Items) {
                $w = [System.Windows.Forms.TextRenderer]::MeasureText($item.ToString(), $F.Main).Width + 30
                if ($w -gt $maxW) { $maxW = $w }
            }
            $rowIPPC.DropDownWidth = $maxW
            $ttIPPC.SetToolTip($rowIPPC, $rowIPPC.SelectedItem.ToString())
        }

        if ($script:ExtractedScriptPath) {
            $statusLbl.Text = "  " + (T "Ready" "Готово") + "  |  " + (T "Target: " "Цель: ") + $script:ExtractedScriptPath + "   " + (T "Found " "Найдено ") + $ipList.Count + " " + (T "interface(s)." "интерфейс(ов).")
        } else {
            $statusLbl.Text = "  " + (T "Ready" "Готово") + "  |  " + (T "WARNING: embedded script could not be extracted to disk." "ВНИМАНИЕ: не удалось распаковать встроенный скрипт на диск.")
        }
        $statusLbl.ForeColor = $C.TextDim

        Set-ModeState
        Update-Preview
    })
    $script:ipTimer.Start()
})

Set-ModeState
Update-Preview

[void]$form.ShowDialog()