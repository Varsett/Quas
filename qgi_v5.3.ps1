# =============================================================================
# Quest Games Informer v5.3 (Multi-language & Auto-search Edition)
# =============================================================================

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("RU", "EN")]
    [string]$Lang = "RU",

    [Parameter(Mandatory = $false)]
    [string]$AppName = "",

    [Parameter(Mandatory = $false)]
    [string]$WorkDir = ""
)

# Подгружаем библиотеки .NET для GUI и JSON
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Web.Extensions
[System.Windows.Forms.Application]::EnableVisualStyles()

# Единая точка правды для языка интерфейса — используется во всех функциях вместо
# локального пересчета "$isRu = ($script:Lang -eq 'RU' -or $Lang -eq 'RU')" в каждом месте.
$script:Lang = $Lang
$script:IsRu = ($Lang -eq "RU")

# Настройка рабочих путей
# $PSScriptRoot часто оказывается пустой строкой внутри EXE, скомпилированного через
# ps2exe — именно это и вызывало "Не удается привязать аргумент к параметру 'Path'"
# на Join-Path чуть ниже (дважды, по числу вызовов Join-Path с пустым $WorkDir).
# Запасной путь — папка процесса, который реально сейчас выполняется (для ps2exe-EXE
# это и есть сам EXE), а не $PSScriptRoot.
$WorkDir = if ($WorkDir -ne "" -and (Test-Path $WorkDir)) {
    $WorkDir.TrimEnd("\")
} elseif ($PSScriptRoot -and $PSScriptRoot -ne "") {
    $PSScriptRoot
} else {
    $fallbackDir = $null
    try {
        $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
        if ($exePath -and (Test-Path $exePath)) { $fallbackDir = Split-Path -Parent $exePath }
    } catch { }
    if (-not $fallbackDir -and $MyInvocation.MyCommand.Path) {
        $fallbackDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    if (-not $fallbackDir) { $fallbackDir = (Get-Location).Path }
    $fallbackDir
}
$SourceJson = Join-Path $WorkDir "oculus_data.json"
$IndexJson  = Join-Path $WorkDir "oculus_index.json"

# =============================================================================
# СЛОВАРЬ ЛОКАЛИЗАЦИИ (RU / EN)
# =============================================================================
$script:Loc = @{
    "RU" = @{
        Title       = "Quest Games Informer v5.3 "
        SearchLbl   = " Поиск:"
        SearchBtn   = "Найти"
        NamesBtn    = "Имена"
        DescsBtn    = "Описания"
        PackageBtn  = "Имя пакета"
        DebugBtn    = "Отладка"
        RebuildBtn  = "Индексировать"
        DownloadBtn = "Скачать базу"
        HelpBtn     = "Справка"
        LogicAll    = "Все"
        LogicAny    = "Любое"
        CategoriesBtn   = "Категории"
        CategoriesAll   = "Категории"
        CategoriesTitle = "Выбор категорий"
        CategoriesClear = "Очистить"
        CategoriesClose = "Закрыть"
        CategoriesOk    = "OK"
        HelpTitle   = "Руководство пользователя Quest Games Informer"
        ErrTitle    = "Ошибка"
        ErrLoad     = "Не удалось открыть картинку: "
        ReadyLoad   = "Готово | Загружено элементов из индекса: "
        NoIndex     = "Индекс не найден. Нажмите 'Скачать базу' или 'Индексировать'."
        DownPrompt  = "Скачать свежую базу с OculusDB и перезаписать oculus_data.json?"
        DownTitle   = "Загрузка базы данных"
        DbEmpty     = "База данных пуста. Скачайте базу или запустите индексирование."
        LoadingMem  = "Загрузка индекса в память..."
        SelectSourcePlaceholder = "Источники..."
        SelectSourcePrompt      = "  Выберите источник данных вверху, чтобы начать работу."
        SelectSourceToSearch    = "  Выберите источник для поиска."
        DbEmptyForSearch        = "  База данных пуста. Скачайте базу или нажмите 'Индексировать'."
        InResultsChk            = "В результатах"
        PcvrBtn                 = "PCVR"
        NativeBtn               = "Автономные"
        ResetBtn                = "Сброс фильтров"
        GroupSearch             = "Поиск"
        GroupDatabases          = "Управление базами"
        GroupService            = "Служебное"
        GroupTools              = "Инструменты"
        SortName                = "По названию"
        SortRating              = "По рейтингу"
        SortDate                = "По дате обновления"
        SortPrice               = "По цене"
        RandomBtn               = "Случайная игра"
        ExportBtn               = "Экспорт"
        StatsNoData             = "Нет загруженных данных"
        ExportSaveTitle         = "Сохранить результаты поиска"
        ExportNothingMsg        = "Сначала выполните поиск — экспортировать пока нечего."
        ExportDoneMsg           = "Сохранено: "
    }
    "EN" = @{
        Title       = "Quest Games Informer v5.3 "
        SearchLbl   = " Search:"
        SearchBtn   = "Search"
        NamesBtn    = "Names"
        DescsBtn    = "Descs"
        PackageBtn  = "Package"
        DebugBtn    = "Debug"
        RebuildBtn  = "Rebuild Index"
        DownloadBtn = "Download DB"
        HelpBtn     = "Help"
        LogicAll    = "All"
        LogicAny    = "Any"
        CategoriesBtn   = "Categories"
        CategoriesAll   = "Categories"
        CategoriesTitle = "Select Categories"
        CategoriesClear = "Clear"
        CategoriesClose = "Close"
        CategoriesOk    = "OK"
        HelpTitle   = "Quest Games Informer User Guide"
        ErrTitle    = "Error"
        ErrLoad     = "Failed to open image: "
        ReadyLoad   = "Ready | Loaded items from index: "
        NoIndex     = "Index not found. Click 'Download DB' or 'Rebuild Index'."
        DownPrompt  = "Download latest database from OculusDB and overwrite oculus_data.json?"
        DownTitle   = "Download Database"
        DbEmpty     = "Database is empty. Download the database or run indexing."
        LoadingMem  = "Loading index into memory..."
        SelectSourcePlaceholder = "Sources..."
        SelectSourcePrompt      = "  Select a data source above to get started."
        SelectSourceToSearch    = "  Select a source to search."
        DbEmptyForSearch        = "  Database is empty. Download the database or click 'Rebuild Index'."
        InResultsChk            = "In results"
        PcvrBtn                 = "PCVR"
        NativeBtn               = "Native"
        ResetBtn                = "Reset Filters"
        GroupSearch             = "Search"
        GroupDatabases          = "Database Management"
        GroupService            = "Service"
        GroupTools              = "Tools"
        SortName                = "By Name"
        SortRating              = "By Rating"
        SortDate                = "By Last Update"
        SortPrice               = "By Price"
        RandomBtn               = "Random Game"
        ExportBtn               = "Export"
        StatsNoData             = "No data loaded"
        ExportSaveTitle         = "Save Search Results"
        ExportNothingMsg        = "Run a search first — nothing to export yet."
        ExportDoneMsg           = "Saved: "
    }
}

$script:L = $script:Loc[$Lang]

# Палитра оформления интерфейса
$script:C = @{
    Bg         = [System.Drawing.Color]::FromArgb(22,  22,  32)
    Panel      = [System.Drawing.Color]::FromArgb(30,  30,  44)
    CardBg     = [System.Drawing.Color]::FromArgb(38,  38,  54)
    CardHeader = [System.Drawing.Color]::FromArgb(48,  48,  68)
    Accent     = [System.Drawing.Color]::FromArgb(100, 149, 237)
    Text       = [System.Drawing.Color]::FromArgb(210, 210, 225)
    Yellow     = [System.Drawing.Color]::FromArgb(220, 220, 150)
    TextDim    = [System.Drawing.Color]::FromArgb(140, 140, 170)
    Input      = [System.Drawing.Color]::FromArgb(18,  18,  28)
    Disabled   = [System.Drawing.Color]::FromArgb(28,  28,  40)
    BtnBg      = [System.Drawing.Color]::FromArgb(85,  110, 165)
    Danger     = [System.Drawing.Color]::FromArgb(252, 129, 129)
    DebugBg    = [System.Drawing.Color]::FromArgb(10,  10,  15)
    ToggleOn   = [System.Drawing.Color]::FromArgb(60,  120, 216)
    ToggleOff  = [System.Drawing.Color]::FromArgb(45,  45,  60)
}

# Шрифты
$script:F = @{
    Main  = New-Object System.Drawing.Font("Segoe UI", 9)
    Bold  = New-Object System.Drawing.Font("Segoe UI", 9,  [System.Drawing.FontStyle]::Bold)
    Title = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    Small = New-Object System.Drawing.Font("Segoe UI", 8,  [System.Drawing.FontStyle]::Bold)
    Mono  = New-Object System.Drawing.Font("Consolas", 8.5)
}

# Глобальное состояние
$script:Items = [System.Collections.Generic.List[object]]::new()
$script:Sw = New-Object System.Diagnostics.Stopwatch

# Флаги поиска
$script:SearchInNames = $true
$script:SearchInDescs = $false
$script:SearchInPackage = $false

# Активные источники поиска (тумблеры вместо выпадающего списка) — по умолчанию
# оба выключены, чтобы при старте не сканировался общий индекс без явного выбора.
$script:ActiveOculus    = $false
$script:ActiveSideQuest = $false

# Фильтр по типу игры: PCVR (поддержка ПК) / Native (только автономный Quest).
# Оба выключены по умолчанию = фильтр не действует (показываются оба типа) —
# логика та же, что и у тумблеров источников: оба вкл = тоже "показать всё".
$script:FilterPcvr   = $false
$script:FilterNative = $false

# Выбранные категории (множественный выбор через окно "Категории")
$script:SelectedCategories = New-Object System.Collections.Generic.List[string]
# Рабочий буфер выбора, используемый пока открыто окно "Категории" (применяется по Ok, отбрасывается по Закрыть)
$script:CategoriesWorking = New-Object System.Collections.Generic.List[string]

# Список категорий с шириной кнопок (px), сгруппированных по длине названия
$script:CategoriesData = @(
    @{ Width = 208; Items = @("360 Experience (non-game)", "Documentary & History", "Relaxation/Meditation") }
    @{ Width = 168; Items = @("Fitness & wellness", "Hands-On Training", "Health & Fitness", "News & Information", "Travel & exploration") }
    @{ Width = 136; Items = @("Adventure", "Art/Creativity", "Computer Link", "Exploration", "Media Player", "Music Video", "Productivity", "Role playing", "Roller Coaster", "Space/Universe", "Sports training", "World creation") }
    @{ Width = 112; Items = @("Community", "Creativity", "Dinosaurs", "Education", "Educational", "Learning", "Medical", "Medicine", "Narrative", "Party game", "Platformer", "Sandbox", "Shooter", "Shopping", "Simulation", "Strategy", "Survival", "Tabletop", "Utilities") }
    @{ Width = 88;  Items = @("Action", "Arcade", "Casual", "Events", "Fighting", "Flying", "Food", "Hangout", "Horror", "Hub", "Media", "Movie", "Music", "News", "Puzzle", "Racing", "Rhythm", "RPG", "Social", "Sports", "Travel", "Unknown", "Utility") }
)

# Разворачиваем группы в единый список {Text;Width} и сортируем по алфавиту
$script:CategoriesFlat = @(
    foreach ($group in $script:CategoriesData) {
        foreach ($name in $group.Items) {
            [pscustomobject]@{ Text = $name; Width = $group.Width }
        }
    }
) | Sort-Object -Property Text -CaseSensitive:$false

# Строит GraphicsPath скругленного прямоугольника заданного размера
function Get-RoundedPath {
    param([int]$Width, [int]$Height, [int]$Radius = 10)
    $w = $Width - 1
    $h = $Height - 1
    $d = $Radius * 2
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, $d, $d, 180, 90)
    $path.AddArc($w - $d, 0, $d, $d, 270, 90)
    $path.AddArc($w - $d, $h - $d, $d, $d, 0, 90)
    $path.AddArc(0, $h - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    return $path
}

# Задает скругленный регион кнопке (отсекает углы под прямоугольником)
function Set-RoundedButtonRegion {
    param($Button, [int]$Radius = 10)
    $path = Get-RoundedPath -Width $Button.Width -Height $Button.Height -Radius $Radius
    $Button.Region = New-Object System.Drawing.Region($path)
}

# Создает toggle-кнопку категории со скругленными углами (рамка рисуется вручную по контуру,
# чтобы не обрезаться Region'ом, как это происходит со стандартной FlatAppearance-рамкой)
function New-CategoryToggleButton {
    param([string]$Text, [int]$Width)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $Text
    $b.Width = $Width
    $b.Height = 28
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0
    $b.Margin = New-Object System.Windows.Forms.Padding(4, 4, 4, 4)
    $b.Font = $script:F.Small
    $b.UseVisualStyleBackColor = $false

    $isSelected = $script:CategoriesWorking.Contains($Text)
    $b.Tag = $isSelected
    if ($isSelected) {
        $b.BackColor = $script:C.ToggleOn
        $b.ForeColor = [System.Drawing.Color]::White
    } else {
        $b.BackColor = $script:C.ToggleOff
        $b.ForeColor = $script:C.TextDim
    }

    $b.Add_Paint({
        param($sender, $e)
        $e.Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $borderColor = if ($sender.Tag) { [System.Drawing.Color]::White } else { $script:C.Accent }
        $path = Get-RoundedPath -Width $sender.Width -Height $sender.Height -Radius 10
        $pen = New-Object System.Drawing.Pen($borderColor, 1)
        $e.Graphics.DrawPath($pen, $path)
        $pen.Dispose()
        $path.Dispose()
    })

    $b.Add_Click({
        $this.Tag = -not $this.Tag
        if ($this.Tag) {
            $this.BackColor = $script:C.ToggleOn
            $this.ForeColor = [System.Drawing.Color]::White
            if (-not $script:CategoriesWorking.Contains($this.Text)) {
                $script:CategoriesWorking.Add($this.Text)
            }
        } else {
            $this.BackColor = $script:C.ToggleOff
            $this.ForeColor = $script:C.TextDim
            [void]$script:CategoriesWorking.Remove($this.Text)
        }
        $this.Invalidate()
    })

    Set-RoundedButtonRegion -Button $b -Radius 10
    return $b
}

# Обновляет текст главной кнопки "Категории" с учетом количества выбранных
function Update-CategoriesButtonLabel {
    if (-not $script:btnCategories) { return }
    # Свой, отличный от прочих toggle-кнопок оттенок (фиолетовый) — чтобы "Категории"
    # визуально выделялась среди Имена/Описания/Имя пакета/PCVR/Автономные.
    if ($script:SelectedCategories.Count -gt 0) {
        $script:btnCategories.Text = "$($script:L.CategoriesAll) ($($script:SelectedCategories.Count))"
        $script:btnCategories.BackColor = [System.Drawing.Color]::FromArgb(150, 80, 200)
        $script:btnCategories.ForeColor = [System.Drawing.Color]::White
    } else {
        $script:btnCategories.Text = $script:L.CategoriesAll
        $script:btnCategories.BackColor = [System.Drawing.Color]::FromArgb(70, 50, 90)
        $script:btnCategories.ForeColor = [System.Drawing.Color]::FromArgb(190, 170, 210)
    }
}

# Открывает окно выбора категорий
function Show-CategoriesWindow {
    # Рабочий буфер инициализируем текущим применённым выбором
    $script:CategoriesWorking.Clear()
    $script:CategoriesWorking.AddRange($script:SelectedCategories)

    $catForm = New-Object System.Windows.Forms.Form
    $catForm.Text            = $script:L.CategoriesTitle
    $catForm.Size            = New-Object System.Drawing.Size(860, 620)
    $catForm.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $catForm.BackColor       = $script:C.Bg
    $catForm.ForeColor       = $script:C.Text
    $catForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
    $catForm.MinimumSize     = New-Object System.Drawing.Size(500, 400)

    $bottomPanel = New-Object System.Windows.Forms.Panel
    $bottomPanel.Dock      = [System.Windows.Forms.DockStyle]::Bottom
    $bottomPanel.Height    = 46
    $bottomPanel.BackColor = $script:C.Panel

    $flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $flow.Dock         = [System.Windows.Forms.DockStyle]::Fill
    $flow.WrapContents = $true
    $flow.AutoScroll   = $true
    $flow.Padding      = New-Object System.Windows.Forms.Padding(10, 10, 10, 10)
    $flow.BackColor    = $script:C.Bg

    foreach ($cat in $script:CategoriesFlat) {
        $btn = New-CategoryToggleButton -Text $cat.Text -Width $cat.Width
        $flow.Controls.Add($btn)
    }

    $btnClear = New-Object System.Windows.Forms.Button
    $btnClear.Text      = $script:L.CategoriesClear
    $btnClear.Location  = New-Object System.Drawing.Point(12, 9)
    $btnClear.Size      = New-Object System.Drawing.Size(100, 28)
    $btnClear.BackColor = $script:C.BtnBg
    $btnClear.ForeColor = $script:C.Text
    $btnClear.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnClear.Font      = $script:F.Small
    $btnClear.Add_Click({
        $script:CategoriesWorking.Clear()
        foreach ($ctrl in $flow.Controls) {
            $ctrl.Tag = $false
            $ctrl.BackColor = $script:C.ToggleOff
            $ctrl.ForeColor = $script:C.TextDim
            $ctrl.Invalidate()
        }
    })
    $bottomPanel.Controls.Add($btnClear)

    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Text      = $script:L.CategoriesClose
    $btnClose.Size      = New-Object System.Drawing.Size(100, 28)
    $btnClose.Location  = New-Object System.Drawing.Point(608, 9)
    $btnClose.BackColor = $script:C.BtnBg
    $btnClose.ForeColor = $script:C.Text
    $btnClose.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnClose.Font      = $script:F.Small
    $btnClose.Add_Click({ $catForm.Close() })
    $bottomPanel.Controls.Add($btnClose)

    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Text      = $script:L.CategoriesOk
    $btnOk.Size      = New-Object System.Drawing.Size(100, 28)
    $btnOk.Location  = New-Object System.Drawing.Point(720, 9)
    $btnOk.BackColor = $script:C.Accent
    $btnOk.ForeColor = [System.Drawing.Color]::White
    $btnOk.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnOk.Font      = $script:F.Bold
    $btnOk.Add_Click({
        $script:SelectedCategories.Clear()
        $script:SelectedCategories.AddRange($script:CategoriesWorking)
        Update-CategoriesButtonLabel
        $catForm.Close()
    })
    $bottomPanel.Controls.Add($btnOk)

    $catForm.Controls.Add($bottomPanel)
    $catForm.Controls.Add($flow)

    [void]$catForm.ShowDialog()
}
$script:MatchAllWords = $true

# Функция логирования в консоль отладки
function Log-Debug {
    param([string]$Message)
    if ($debugTb -and -not $debugTb.IsDisposed) {
        $time = (Get-Date).ToString("HH:mm:ss.fff")
        $debugTb.AppendText("[$time] $Message`r`n")
        $debugTb.SelectionStart = $debugTb.Text.Length
        $debugTb.ScrollToCaret()
    }
}

# Извлечение названия приложения
function Get-AppName {
    param($item)
    if ($null -eq $item) { return "Unknown App" }

    # Не используем .Contains()/.ContainsKey() напрямую — эта функция вызывается и с
    # OrderedDictionary (при индексации, там есть только .Contains), и с элементами
    # $script:Items — а те после JavaScriptSerializer.Deserialize оказываются generic
    # Dictionary[string,object], где .Contains скрыт за ICollection<KeyValuePair> и
    # требует не ключ, а пару ключ-значение, а .ContainsKey наоборот не существует на
    # OrderedDictionary. ".Keys -contains" — оператор PowerShell, а не метод .NET,
    # работает одинаково для любого из этих типов.
    $targetKeys = @("AppName", "appName", "displayName", "display_name", "title", "name", "applicationName", "app_name", "slug")
    foreach ($k in $targetKeys) {
        if ($item.Keys -contains $k) {
            $valStr = [string]$item[$k]
            if (-not [string]::IsNullOrWhiteSpace($valStr)) { return $valStr.Trim() }
        }
    }
    return "Unknown App"
}

# Функция предпросмотра с поддержкой WebP через WPF
function Show-ImagePreview {
    param([string]$ImageUrl, [string]$Title)

    Log-Debug $(if ($script:IsRu) { "--- Открытие превью через WPF для: $Title ---" } else { "--- Opening WPF preview for: $Title ---" })
    Log-Debug $(if ($script:IsRu) { "Целевой URL картинки: $ImageUrl" } else { "Target image URL: $ImageUrl" })

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
        
        Log-Debug $(if ($script:IsRu) { "Загрузка картинки с сервера..." } else { "Downloading image from server..." })
        $response = Invoke-WebRequest -Uri $ImageUrl -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -UseBasicParsing -TimeoutSec 10
        
        Log-Debug $(if ($script:IsRu) { "Ответ получен. Размер: $($response.Content.Length) байт" } else { "Response received. Size: $($response.Content.Length) bytes" })

        $tempFile = [System.IO.Path]::GetTempFileName() + ".webp"
        [System.IO.File]::WriteAllBytes($tempFile, $response.Content)
        
        Add-Type -AssemblyName PresentationCore, PresentationFramework

        $win = New-Object System.Windows.Window
        $win.Title                 = "Preview: $Title"
        $win.Width                 = 650
        $win.Height                = 550
        $win.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
        $win.Background            = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(30, 30, 30))

        $bmp = New-Object System.Windows.Media.Imaging.BitmapImage
        $bmp.BeginInit()
        $bmp.UriSource   = New-Object System.Uri($tempFile)
        $bmp.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bmp.EndInit()

        $img = New-Object System.Windows.Controls.Image
        $img.Source  = $bmp
        $img.Stretch = [System.Windows.Media.Stretch]::Uniform
        
        $win.Content = $img

        Log-Debug $(if ($script:IsRu) { "WPF-окно успешно создано и готово к открытию." } else { "WPF window created successfully and ready to open." })
        $null = $win.ShowDialog()

        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        Log-Debug $(if ($script:IsRu) { "Превью закрыто, временный файл удален." } else { "Preview closed, temp file removed." })

    } catch {
        Log-Debug $(if ($script:IsRu) { "ОШИБКА при открытии WPF превью: $_" } else { "ERROR opening WPF preview: $_" })
        [System.Windows.Forms.MessageBox]::Show("$($script:L.ErrLoad) $_", $script:L.ErrTitle, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Функция вывода аккуратного и подробного окна справки
# Строит одну "колонку" справки (несколько блоков подряд, каждый — название
# слева/описание справа) внутри отдельного TableLayoutPanel. Две независимые
# колонки (со своим счетчиком строк) размещаются рядом — просто потому, что
# TableLayoutPanel с общими строками для двух непересекающихся списков разной
# длины растягивал бы обе колонки под самую длинную ячейку в каждой строке.
function Build-HelpTable {
    param($ParentPanel, $Sections, [int]$NameColWidth, [int]$DescColWidth, [int]$X)

    $table = New-Object System.Windows.Forms.TableLayoutPanel
    $table.ColumnCount  = 2
    $table.AutoSize     = $true
    $table.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
    $table.Width        = $NameColWidth + $DescColWidth
    $table.Location     = New-Object System.Drawing.Point($X, 0)
    $table.BackColor    = $script:C.Bg
    $table.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, $NameColWidth))) | Out-Null
    $table.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Absolute, $DescColWidth))) | Out-Null
    $ParentPanel.Controls.Add($table)

    [int]$rowIdx = 0
    foreach ($section in $Sections) {
        $hdr = New-Object System.Windows.Forms.Label
        $hdr.Text      = $section.Title
        $hdr.AutoSize  = $false
        $hdr.Width     = $NameColWidth + $DescColWidth - 4
        $hdr.Height    = 30
        $hdr.Margin    = New-Object System.Windows.Forms.Padding(2, 14, 2, 4)
        $hdr.ForeColor = [System.Drawing.Color]::Orange
        $hdr.Font      = New-Object System.Drawing.Font("Segoe UI", 11.5, [System.Drawing.FontStyle]::Bold)
        $hdr.TextAlign = [System.Drawing.ContentAlignment]::BottomLeft
        $table.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) | Out-Null
        $table.Controls.Add($hdr, 0, $rowIdx)
        $table.SetColumnSpan($hdr, 2)
        $rowIdx++

        foreach ($it in $section.Items) {
            $nameLbl = New-Object System.Windows.Forms.Label
            $nameLbl.Text      = $it.Name
            $nameLbl.AutoSize  = $false
            $nameLbl.Width     = $NameColWidth - 6
            $nameLbl.Margin    = New-Object System.Windows.Forms.Padding(2, 6, 2, 10)
            $nameLbl.ForeColor = $script:C.Yellow
            $nameLbl.Font      = $script:F.Bold
            $nameLbl.TextAlign = [System.Drawing.ContentAlignment]::TopLeft

            $descLbl = New-Object System.Windows.Forms.Label
            $descLbl.Text        = $it.Desc
            $descLbl.AutoSize    = $true
            $descLbl.MaximumSize = New-Object System.Drawing.Size(($DescColWidth - 10), 0)
            $descLbl.Margin      = New-Object System.Windows.Forms.Padding(2, 6, 2, 10)
            $descLbl.ForeColor   = $script:C.Text
            $descLbl.Font        = $script:F.Main
            $descLbl.TextAlign   = [System.Drawing.ContentAlignment]::TopLeft

            $table.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) | Out-Null
            $table.Controls.Add($nameLbl, 0, $rowIdx)
            $table.Controls.Add($descLbl, 1, $rowIdx)
            $rowIdx++
        }
    }
}

function Show-HelpWindow {
    $helpForm = New-Object System.Windows.Forms.Form
    $helpForm.Text            = $script:L.HelpTitle
    $helpForm.Size            = New-Object System.Drawing.Size(1300, 700)
    $helpForm.MinimumSize     = New-Object System.Drawing.Size(900, 420)
    $helpForm.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $helpForm.BackColor       = $script:C.Bg
    $helpForm.ForeColor       = $script:C.Text
    $helpForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
    $helpForm.MaximizeBox     = $true

    $titleLbl = New-Object System.Windows.Forms.Label
    $titleLbl.Text      = if ($script:IsRu) { "Руководство по управлению и кнопкам интерфейса" } else { "Interface & Controls Guide" }
    $titleLbl.Dock      = [System.Windows.Forms.DockStyle]::Top
    $titleLbl.Height    = 44
    $titleLbl.BackColor = $script:C.Panel
    $titleLbl.ForeColor = $script:C.Accent
    $titleLbl.Font      = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
    $titleLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $titleLbl.Padding   = New-Object System.Windows.Forms.Padding(15, 0, 0, 0)
    $helpForm.Controls.Add($titleLbl)

    # --- Краткий мануал внизу окна ---
    $manualPanel = New-Object System.Windows.Forms.Panel
    $manualPanel.Dock      = [System.Windows.Forms.DockStyle]::Bottom
    $manualPanel.Height    = 230
    $manualPanel.BackColor = $script:C.Panel
    $manualPanel.Padding   = New-Object System.Windows.Forms.Padding(15, 10, 15, 10)

    $manualTitleLbl = New-Object System.Windows.Forms.Label
    $manualTitleLbl.Text      = if ($script:IsRu) { "Краткая инструкция" } else { "Quick usage guide" }
    $manualTitleLbl.Dock      = [System.Windows.Forms.DockStyle]::Top
    $manualTitleLbl.Height    = 24
    $manualTitleLbl.ForeColor = [System.Drawing.Color]::Orange
    $manualTitleLbl.Font      = $script:F.Bold
    $manualPanel.Controls.Add($manualTitleLbl)

    $manualText = if ($script:IsRu) {
        "1. Прежде всего скачайте базу (или обе): включите тумблер OculusDB и/или SideQuest внизу верхней панели, затем нажмите 'Скачать базу' — это загрузит данные с сервера и сразу построит поисковый индекс. Без этого шага искать будет нечего.`n" +
        "2. Введите слово или часть названия в поле поиска и нажмите 'Найти' (или клавишу Enter).`n" +
        "3. При необходимости сузьте выдачу: категориями, ценой/лицензией у соответствующего источника, переключателями Имена/Описания/Имя пакета и Все/Любое.`n" +
        "4. Отметьте 'В результатах', чтобы следующий поиск искал только среди уже найденного, а не по всей базе заново.`n" +
        "5. Кликните по заголовку карточки, чтобы посмотреть подробности приложения — там доступны Copy, Preview и Перевод. Метка [PCVR] рядом с названием означает, что игра поддерживает подключение к ПК (Rift/Link/Air Link), а не только автономный Quest.`n" +
        "6. Если совпадений больше, чем показано — используйте кнопку 'Показать ещё' внизу списка."
    } else {
        "1. First, download the database (or both): turn on the OculusDB and/or SideQuest toggle at the bottom of the top panel, then click 'Download DB' — this fetches data from the server and builds the search index right away. Without this step there's nothing to search yet.`n" +
        "2. Type a word or part of a name into the search field and click 'Search' (or press Enter).`n" +
        "3. Narrow the results if needed: categories, price/license for the relevant source, and the Names/Descs/Package and All/Any toggles.`n" +
        "4. Check 'In results' to make the next search look only within what's already found, instead of the whole database.`n" +
        "5. Click a card header to see app details — Copy, Preview and Translate are available there. A [PCVR] tag next to the name means the game supports a PC connection (Rift/Link/Air Link), not just standalone Quest.`n" +
        "6. If there are more matches than shown, use the 'Show more' button below the list."
    }

    $footerPanel = New-Object System.Windows.Forms.Panel
    $footerPanel.Dock      = [System.Windows.Forms.DockStyle]::Bottom
    $footerPanel.Height    = 22
    $footerPanel.BackColor = $script:C.Panel
    $manualPanel.Controls.Add($footerPanel)

    $copyrightLbl = New-Object System.Windows.Forms.Label
    $copyrightLbl.Text      = "(c) 2026 Varset"
    $copyrightLbl.AutoSize  = $true
    $copyrightLbl.Location  = New-Object System.Drawing.Point(0, 3)
    $copyrightLbl.ForeColor = $script:C.TextDim
    $copyrightLbl.Font      = $script:F.Small
    $footerPanel.Controls.Add($copyrightLbl)

    $linkLbl = New-Object System.Windows.Forms.LinkLabel
    $linkLbl.Text             = if ($script:IsRu) { "Руководства (RU/EN): github.com/Varsett/QuestGamesInformer" } else { "Guides (RU/EN): github.com/Varsett/QuestGamesInformer" }
    $linkLbl.AutoSize         = $true
    $linkLbl.Location         = New-Object System.Drawing.Point(120, 3)
    $linkLbl.LinkColor        = $script:C.Accent
    $linkLbl.ActiveLinkColor  = [System.Drawing.Color]::White
    $linkLbl.VisitedLinkColor = $script:C.Accent
    $linkLbl.LinkBehavior     = [System.Windows.Forms.LinkBehavior]::HoverUnderline
    $linkLbl.Font             = $script:F.Small
    $linkLbl.Add_LinkClicked({
        Start-Process "https://github.com/Varsett/QuestGamesInformer"
    })
    $footerPanel.Controls.Add($linkLbl)

    $manualLbl = New-Object System.Windows.Forms.Label
    $manualLbl.Text      = $manualText
    $manualLbl.Dock      = [System.Windows.Forms.DockStyle]::Fill
    $manualLbl.ForeColor = $script:C.Text
    $manualLbl.Font      = $script:F.Main
    $manualLbl.TextAlign = [System.Drawing.ContentAlignment]::TopLeft
    $manualPanel.Controls.Add($manualLbl)
    $manualLbl.BringToFront()

    $helpForm.Controls.Add($manualPanel)

    # --- Две колонки блоков side-by-side, в каждом блоке: название слева, описание справа ---
    $scrollPanel = New-Object System.Windows.Forms.Panel
    $scrollPanel.Dock       = [System.Windows.Forms.DockStyle]::Fill
    $scrollPanel.AutoScroll = $true
    $scrollPanel.BackColor  = $script:C.Bg
    $scrollPanel.Padding    = New-Object System.Windows.Forms.Padding(14, 10, 14, 10)
    $helpForm.Controls.Add($scrollPanel)
    $scrollPanel.BringToFront()

    $nameColWidth = 170
    $descColWidth = 430
    $colGap = 30

    if ($script:IsRu) {
        $sections = @(
            @{
                Title = "Поиск и фильтры"
                Items = @(
                    @{ Name = "[Поиск]";       Desc = "Поле ввода + кнопка 'Найти' (или клавиша Enter). Запускает поиск по текущему индексу с учётом всех активных фильтров." },
                    @{ Name = "[Имена]";       Desc = "Включает/выключает поиск ключевых слов в названиях приложений." },
                    @{ Name = "[Описания]";    Desc = "Включает/выключает поиск ключевых слов внутри текстовых описаний и сводок — работает медленнее, чем поиск по именам." },
                    @{ Name = "[Все / Любое]"; Desc = "Логика сопоставления слов запроса. 'Все' — должны найтись все введённые слова. 'Любое' — достаточно хотя бы одного." },
                    @{ Name = "[Имя пакета]";  Desc = "Включает/выключает поиск ключевых слов по имени пакета приложения (например, com.developer.appname)." },
                    @{ Name = "[PCVR / Автономные]"; Desc = "Фильтр по типу игры. Деление есть только у OculusDB, поэтому при активной ТОЛЬКО базе SideQuest эти кнопки отключаются. Ни одна не отмечена (или отмечены обе) — фильтр не действует." },
                    @{ Name = "[Категории]";   Desc = "Открывает окно множественного выбора из 62 категорий (жанров). 'Ok' применяет выбор к фильтру, 'Закрыть' отменяет несохранённые изменения, 'Очистить' сбрасывает выбор в окне." },
                    @{ Name = "[В результатах]"; Desc = "Если отмечено — очередной поиск сужает уже показанный список результатов, а не пересканирует всю базу заново. Сбрасывается при смене источника." },
                    @{ Name = "[Сброс фильтров]"; Desc = "Возвращает всё к состоянию сразу после запуска программы: очищает поиск и результаты, отключает источники, категории, цену/лицензию, PCVR/Автономные и сортировку." }
                )
            },
            @{
                Title = "Управление базами"
                Items = @(
                    @{ Name = "[OculusDB / SideQuest]"; Desc = "Тумблеры источников — по умолчанию оба выключены (при старте ничего не сканируется). Включите один или оба сразу, чтобы искать по нужным базам." },
                    @{ Name = "[Слайдер у OculusDB]";   Desc = "Потолок цены от \$0 до \$50 — показывает записи OculusDB дешевле или равные выбранной сумме. Крайнее правое положение (50) означает 'без ограничения'." },
                    @{ Name = "[Free / Paid у SideQuest]"; Desc = "Радиокнопки — фильтр по лицензии SideQuest (там нет точной цены, только бесплатно/платно). Ни одна не отмечена — фильтр не действует." }
                )
            },
            @{
                Title = "Инструменты"
                Items = @(
                    @{ Name = "[Сортировка]"; Desc = "По названию / рейтингу / дате обновления / цене. Меняется сразу, без повторного нажатия 'Найти'." },
                    @{ Name = "[Обр]";        Desc = "Переключает выбранную сортировку на обратную (было по убыванию — станет по возрастанию, и наоборот)." },
                    @{ Name = "[Экспорт]";    Desc = "Сохраняет текущий отфильтрованный список результатов в CSV или JSON." },
                    @{ Name = "[Случайная игра]"; Desc = "Выбирает случайную запись из текущей выдачи (или всей базы, если поиск ещё не запускался) и открывает её." },
                    @{ Name = "[Статистика]"; Desc = "Число записей по каждой базе, всегда видно для обеих. Активная (включённая тумблером) база и строка 'Всего' — белым; отсутствующая, неиндексированная или неактивная база — приглушённым цветом." }
                )
            },
            @{
                Title = "База данных"
                Items = @(
                    @{ Name = "[Индексировать]";  Desc = "Пересобирает поисковый индекс для источников, чьи тумблеры сейчас включены, из уже скачанного локального файла — без обращения к серверу." },
                    @{ Name = "[Скачать базу]";   Desc = "Качает свежие данные с сервера для источников, чьи тумблеры сейчас включены (один или сразу оба), и автоматически переиндексирует. Нужно сделать хотя бы раз перед первым поиском." },
                    @{ Name = "[Отладка]";        Desc = "Показывает/скрывает техническую консоль логов внизу окна — полезно, если что-то работает не так, как ожидалось." }
                )
            },
            @{
                Title = "Карточки приложений"
                Items = @(
                    @{ Name = "[Заголовок карточки]"; Desc = "Клик по заголовку разворачивает или сворачивает подробные параметры приложения." },
                    @{ Name = "[PCVR]"; Desc = "Метка рядом с названием у игр, которые (по данным OculusDB — поле Rift среди поддерживаемых гарнитур, или SideQuest — платформа Steam) поддерживают подключение к ПК, а не только автономный Quest." },
                    @{ Name = "[ID]"; Desc = "Внутренний идентификатор записи в базе-источнике — пригождается, например, чтобы вручную открыть страницу приложения." },
                    @{ Name = "[Copy]";               Desc = "Копирует ссылку (например, на страницу в магазине) в буфер обмена." },
                    @{ Name = "[Preview]";            Desc = "Открывает изображение (иконку, обложку) во всплывающем окне, включая формат WebP." },
                    @{ Name = "[Перевод]";            Desc = "Переводит длинное текстовое описание приложения через Google Translate прямо во всплывающем окне." },
                    @{ Name = "[Показать ещё]";       Desc = "Появляется, если совпадений больше, чем показано на экране — подгружает следующую порцию результатов." }
                )
            }
        )
    } else {
        $sections = @(
            @{
                Title = "Search & Filters"
                Items = @(
                    @{ Name = "[Search]";        Desc = "Input field + 'Search' button (or Enter key). Runs a search against the current index, honoring every active filter." },
                    @{ Name = "[Names]";         Desc = "Toggles keyword searching within application names." },
                    @{ Name = "[Descs]";         Desc = "Toggles keyword searching inside descriptions and summaries — slower than searching names only." },
                    @{ Name = "[All / Any]";     Desc = "Matching logic for query words. 'All' requires every word to match. 'Any' matches if at least one word is found." },
                    @{ Name = "[Package]";       Desc = "Toggles keyword searching within the application's package name (e.g. com.developer.appname)." },
                    @{ Name = "[PCVR / Native]"; Desc = "Filters by game type. This distinction only exists for OculusDB, so these buttons are disabled when only SideQuest is active. Neither (or both) selected means no filter." },
                    @{ Name = "[Categories]";    Desc = "Opens a multi-select window with 62 categories. 'Ok' applies the selection to the filter, 'Close' discards unsaved changes, 'Clear' resets the selection inside the window." },
                    @{ Name = "[In results]";    Desc = "When checked, the next search narrows the already-shown result list instead of re-scanning the whole database. Resets automatically when the source changes." },
                    @{ Name = "[Reset Filters]"; Desc = "Returns everything to the state right after startup: clears search and results, turns off sources, categories, price/license, PCVR/Native and sorting." }
                )
            },
            @{
                Title = "Database Management"
                Items = @(
                    @{ Name = "[OculusDB / SideQuest]"; Desc = "Source toggles — both off by default (nothing is scanned on startup). Turn on one or both to search the databases you need." },
                    @{ Name = "[Slider by OculusDB]";   Desc = "Price ceiling from \$0 to \$50 — shows OculusDB items priced at or below the chosen amount. All the way right (50) means 'no limit'." },
                    @{ Name = "[Free / Paid by SideQuest]"; Desc = "Radio buttons — filters by SideQuest's license field (no exact price there, just free/paid). Neither selected means no filter." }
                )
            },
            @{
                Title = "Tools"
                Items = @(
                    @{ Name = "[Sort]";         Desc = "By name / rating / last update / price. Applies immediately, no need to click 'Search' again." },
                    @{ Name = "[Rev]";          Desc = "Flips the current sort direction (descending becomes ascending, and vice versa)." },
                    @{ Name = "[Export]";       Desc = "Saves the current filtered result list to CSV or JSON." },
                    @{ Name = "[Random Game]";  Desc = "Picks a random entry from the current results (or the whole database if you haven't searched yet) and opens it." },
                    @{ Name = "[Stats]";        Desc = "Item count for each database, always visible for both. The active (toggled-on) database and the 'Total' line are white; a missing, not-yet-indexed, or inactive database is dimmed." }
                )
            },
            @{
                Title = "Database"
                Items = @(
                    @{ Name = "[Rebuild Index]"; Desc = "Rebuilds the search index for whichever source toggle(s) are currently on, from the already-downloaded local file — no server call." },
                    @{ Name = "[Download DB]";   Desc = "Downloads fresh data from the server for whichever source toggle(s) are currently on (one or both) and re-indexes automatically. Do this at least once before your first search." },
                    @{ Name = "[Debug]";         Desc = "Shows/hides the technical log console at the bottom of the window — useful when something doesn't behave as expected." }
                )
            },
            @{
                Title = "App Cards"
                Items = @(
                    @{ Name = "[Card header]";  Desc = "Click to expand or collapse the detailed parameters of an application." },
                    @{ Name = "[PCVR]";  Desc = "Tag next to the name for games that (per OculusDB — Rift listed among supported headsets, or SideQuest — Steam platform) support a PC connection, not just standalone Quest." },
                    @{ Name = "[ID]";  Desc = "The internal identifier of the record in its source database — handy for, e.g., manually opening the app's page." },
                    @{ Name = "[Copy]";         Desc = "Copies a link (e.g. the store page URL) to the clipboard." },
                    @{ Name = "[Preview]";      Desc = "Opens an image (icon, cover art) in a popup window, including WebP format." },
                    @{ Name = "[Translate]";    Desc = "Translates a long text description via Google Translate right inside a popup window." },
                    @{ Name = "[Show more]";    Desc = "Appears when there are more matches than currently shown — loads the next batch of results." }
                )
            }
        )
    }

    # Левая колонка: Поиск и фильтры + Управление базами. Правая: Инструменты +
    # База данных + Карточки приложений — примерно поровну по числу строк.
    $leftSections  = $sections[0..1]
    $rightSections = $sections[2..($sections.Count - 1)]

    Build-HelpTable -ParentPanel $scrollPanel -Sections $leftSections -NameColWidth $nameColWidth -DescColWidth $descColWidth -X 0
    Build-HelpTable -ParentPanel $scrollPanel -Sections $rightSections -NameColWidth $nameColWidth -DescColWidth $descColWidth -X ($nameColWidth + $descColWidth + $colGap)

    [void]$helpForm.ShowDialog()
}

# Форматирование Markdown
function Format-MarkdownToRichText {
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.RichTextBox]$Rtb,
        
        [Parameter(Mandatory=$true)]
        [string]$RawText
    )

    $Rtb.Clear()
    if ([string]::IsNullOrEmpty($RawText)) { return }

    # Нормализуем переносы строк
    $cleanText = $RawText -replace '\\n', "`n" -replace '\\r', '' -replace '\\"', '"'
    $lines = $cleanText -split "`n"

    foreach ($line in $lines) {
        $trimmed = $line.Trim()

        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            $Rtb.AppendText("`n")
            continue
        }

        # 1. Если это заголовок (начинается с #)
        if ($trimmed.StartsWith("#")) {
            [int]$level = 0
            while ($level -lt $trimmed.Length -and $trimmed[$level] -eq '#') { $level++ }
            
            $headerText = $trimmed.Substring($level).Trim() -replace '\*\*', ''
            
            $Rtb.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 12.5, [System.Drawing.FontStyle]::Bold)
            $Rtb.SelectionColor = [System.Drawing.Color]::Orange
            $Rtb.AppendText("$headerText`n")
            continue
        }

        # 2. Обычный текст
        $parts = [System.Text.RegularExpressions.Regex]::Split($line, '(\*\*.*?\*\*)')

        foreach ($part in $parts) {
            if ([string]::IsNullOrEmpty($part)) { continue }

            if ($part.StartsWith("**") -and $part.EndsWith("**") -and $part.Length -gt 4) {
                $boldContent = $part.Substring(2, $part.Length - 4)
                $Rtb.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
                $Rtb.SelectionColor = [System.Drawing.Color]::White
                $Rtb.AppendText($boldContent)
            } else {
                $Rtb.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Regular)
                $Rtb.SelectionColor = [System.Drawing.Color]::FromArgb(210, 210, 210)
                $Rtb.AppendText($part)
            }
        }
        $Rtb.AppendText("`n")
    }
}

# Функция перевода текста
function Get-TranslatedText {
    param([string]$Text)
    Log-Debug $(if ($script:IsRu) { "--- Запуск перевода текста (общая длина: $($Text.Length) симв.) ---" } else { "--- Starting text translation (total length: $($Text.Length) chars) ---" })
    
    if ([string]::IsNullOrWhiteSpace($Text)) { return "" }

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
        
        $encodedText = [System.Web.HttpUtility]::UrlEncode($Text)
        $url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=ru&dt=t&q=$encodedText"
        
        Log-Debug $(if ($script:IsRu) { "Отправка запроса на публичный Google Translate API..." } else { "Sending request to the public Google Translate API..." })
        $response = Invoke-RestMethod -Uri $url -Method Get -UseBasicParsing
        
        if ($response -and $response[0]) {
            $translatedParts = foreach ($item in $response[0]) {
                if ($item[0]) { $item[0] }
            }
            $finalResult = [string]::Join("", $translatedParts)
            
            if (-not [string]::IsNullOrWhiteSpace($finalResult)) {
                Log-Debug $(if ($script:IsRu) { "Перевод через Google успешно получен (длина: $($finalResult.Length) симв.)." } else { "Google translation received successfully (length: $($finalResult.Length) chars)." })
                return $finalResult
            }
        }
        
        Log-Debug $(if ($script:IsRu) { "Не удалось распарсить ответ от Google Translate." } else { "Failed to parse the Google Translate response." })
    } catch {
        Log-Debug $(if ($script:IsRu) { "Ошибка при обращении к Google Translate API: $_" } else { "Error calling the Google Translate API: $_" })
    }
    
    Log-Debug $(if ($script:IsRu) { "Возвращаем оригинальный текст из-за ошибки." } else { "Returning the original text due to an error." })
    return $Text
}

# Окно перевода
function Show-TranslationWindow {
    param([string]$Title, [string]$OriginalText)

    $transForm = New-Object System.Windows.Forms.Form
    $transForm.Text            = if ($Lang -eq "RU") { "Перевод описания: $Title" } else { "Description Translation: $Title" }
    $transForm.Size            = New-Object System.Drawing.Size(700, 550)
    $transForm.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterParent
    $transForm.BackColor       = $script:C.Bg
    $transForm.ForeColor       = $script:C.Text
    $transForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
    $transForm.MinimizeBox     = $false

    $lblStatus = New-Object System.Windows.Forms.Label
    $lblStatus.Text      = if ($Lang -eq "RU") { "  Переводим текст по частям, пожалуйста, подождите..." } else { "  Translating text in chunks, please wait..." }
    $lblStatus.Dock      = [System.Windows.Forms.DockStyle]::Bottom
    $lblStatus.Height    = 30
    $lblStatus.BackColor = $script:C.Panel
    $lblStatus.ForeColor = $script:C.Yellow
    $lblStatus.Font      = $script:F.Small
    $lblStatus.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $transForm.Controls.Add($lblStatus)

    $rtbContainer = New-Object System.Windows.Forms.Panel
    $rtbContainer.Dock = [System.Windows.Forms.DockStyle]::Fill
    $rtbContainer.Padding = New-Object System.Windows.Forms.Padding(10, 10, 10, 10)
    
    $rtb = New-Object System.Windows.Forms.RichTextBox
    $rtb.Dock        = [System.Windows.Forms.DockStyle]::Fill
    $rtb.ReadOnly    = $true
    $rtb.BackColor   = $script:C.Input
    $rtb.ForeColor   = $script:C.Yellow
    $rtb.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $rtb.Font        = New-Object System.Drawing.Font("Segoe UI", 11)
    
    $rtbContainer.Controls.Add($rtb)
    $transForm.Controls.Add($rtbContainer)

    $transForm.Add_Shown({
        [System.Windows.Forms.Application]::DoEvents()
        
        Log-Debug $(if ($script:IsRu) { "Запрос перевода для приложения: $Title" } else { "Requesting translation for app: $Title" })
        $translated = Get-TranslatedText -Text $OriginalText
        
        $rtb.Text = $translated
        $rtb.SelectionStart = 0
        $rtb.ScrollToCaret()

        $lblStatus.Text = if ($Lang -eq "RU") { "  Перевод успешно завершен." } else { "  Translation completed successfully." }
        $lblStatus.ForeColor = $script:C.Accent
        Log-Debug $(if ($script:IsRu) { "Перевод успешно получен и выведен в окно." } else { "Translation received and displayed successfully." })
    })

    [void]$transForm.ShowDialog()
}

# -----------------------------------------------------------------------------
# 1. ИНДЕКСАЦИЯ И ЗАГРУЗКА (реестр провайдеров)
# -----------------------------------------------------------------------------

# Приводит "сырой" элемент (Hashtable из JavaScriptSerializer ИЛИ PSCustomObject из
# ConvertFrom-Json) к единому изменяемому OrderedDictionary, чтобы все мапперы
# провайдеров работали с данными одинаково, независимо от того, чем был распарсен JSON.
# Словарь понятных подписей для "сырых" полей, которые проходят в карточку как есть
# (не превращены в отдельное каноническое поле мапперами). Раньше такие поля
# показывались буквально под техническим именем (например "__OculusDBType") —
# теперь либо человекочитаемая подпись, либо (если ключа нет в словаре) само имя поля как раньше.
$script:FieldLabels = @{
    "imageLink"                = if ($script:IsRu) { "Ссылка на иконку" } else { "Icon Link" }
    "display_long_description" = if ($script:IsRu) { "Описание" } else { "Description" }
    "description"               = if ($script:IsRu) { "Описание" } else { "Description" }
    "short_description"         = if ($script:IsRu) { "Краткое описание" } else { "Short Description" }
    "summary"                   = if ($script:IsRu) { "Сводка" } else { "Summary" }
    "url"                        = if ($script:IsRu) { "Ссылка" } else { "Link" }
    "id"                         = "ID"
    "package_name"               = if ($script:IsRu) { "Пакет" } else { "Package" }
    "packagename"                = if ($script:IsRu) { "Пакет" } else { "Package" }
    "version"                    = if ($script:IsRu) { "Версия" } else { "Version" }
    "version_name"               = if ($script:IsRu) { "Версия" } else { "Version" }
    "size"                       = if ($script:IsRu) { "Размер" } else { "Size" }
    "downloads"                  = if ($script:IsRu) { "Загрузки" } else { "Downloads" }
    "download_count"             = if ($script:IsRu) { "Загрузки" } else { "Downloads" }
    "installs"                   = if ($script:IsRu) { "Установки" } else { "Installs" }
    "rating"                     = if ($script:IsRu) { "Рейтинг" } else { "Rating" }
    "average_rating"             = if ($script:IsRu) { "Рейтинг" } else { "Rating" }
    "reviews_count"              = if ($script:IsRu) { "Отзывы" } else { "Reviews" }
    "review_count"               = if ($script:IsRu) { "Отзывы" } else { "Reviews" }
    "tags"                       = if ($script:IsRu) { "Теги" } else { "Tags" }
    "created_at"                 = if ($script:IsRu) { "Создано" } else { "Created" }
    "updated_at"                 = if ($script:IsRu) { "Обновлено" } else { "Updated" }
    "date_updated"               = if ($script:IsRu) { "Обновлено" } else { "Updated" }
    "last_updated"               = if ($script:IsRu) { "Обновлено" } else { "Updated" }
}

function Get-FriendlyFieldLabel {
    param([string]$Key)
    if ($script:FieldLabels.Contains($Key)) { return $script:FieldLabels[$Key] }
    return $Key
}

function ConvertTo-ItemHashtable {
    param($Item)
    $h = [ordered]@{}
    if ($Item -is [System.Collections.IDictionary]) {
        foreach ($k in $Item.Keys) { $h[$k] = $Item[$k] }
    } else {
        foreach ($p in $Item.PSObject.Properties) { $h[$p.Name] = $p.Value }
    }
    return $h
}

# Ищет в записи поле по regex-паттерну имени ключа, извлекает значение (строку,
# либо — с -JoinArray — массив строк через ", ") и УДАЛЯЕТ найденный ключ из записи,
# чтобы то же самое сырое поле не задвоилось потом в общем проходе передачи "остальных" полей.
function Get-CandidateField {
    param(
        [System.Collections.IDictionary]$Item,
        [string]$Pattern,
        [switch]$JoinArray
    )
    foreach ($k in @($Item.Keys)) {
        $val = $Item[$k]
        if ($null -eq $val) { continue }
        if ($k -notmatch $Pattern) { continue }
        if ($val -is [string] -and $val.Trim() -ne "") {
            $Item.Remove($k)
            return $val
        } elseif ($JoinArray -and $val -is [System.Collections.ICollection]) {
            $joined = (@($val) | Where-Object { $_ -is [string] -and $_.Trim() -ne "" }) -join ", "
            if ($joined) {
                $Item.Remove($k)
                return $joined
            }
        }
    }
    return $null
}

# --- Маппер OculusDB: сырой элемент oculus_data.json -> каноническая запись ---
$script:OculusMapper = {
    param($RawItem)
    if ($RawItem -isnot [System.Collections.IDictionary]) { return $null }
    $h = ConvertTo-ItemHashtable -Item $RawItem

    $entry = [ordered]@{}
    $entry["AppName"] = Get-AppName -item $h

    $appId = $null
    foreach ($k in @("id", "appId", "id_str")) {
        if ($h.Contains($k) -and $h[$k]) { $appId = $h[$k]; $h.Remove($k); break }
    }
    if ($null -ne $appId) {
        $entry["ID"] = [string]$appId
        $entry["Store URL"] = "https://www.meta.com/experiences/$appId"
        $entry["Image URL"] = "https://oculusdb-rewrite.rui2015.me/assets/app/$appId"
    }

    $imageLinkVal = Get-CandidateField -Item $h -Pattern "^imageLink$"
    if ($imageLinkVal) { $entry["imageLink"] = $imageLinkVal }

    $pkg = Get-CandidateField -Item $h -Pattern "package|bundle"
    if ($pkg) { $entry["Package Name"] = $pkg }

    # Реальное поле схемы OculusDB — publisher_name (snake_case), не publisherName.
    # Прежний паттерн этого не ловил ни разу — Developer у OculusDB не заполнялся.
    $dev = Get-CandidateField -Item $h -Pattern "^(developerName|developer_name|developer|publisherName|publisher_name|publisherNames|studio)$" -JoinArray
    if ($dev) { $entry["Developer"] = $dev }

    # Реальное поле схемы OculusDB — genre_names (snake_case), не genreNames.
    # Прежний паттерн этого не ловил ни разу — Categories у OculusDB не заполнялся.
    $cats = Get-CandidateField -Item $h -Pattern "^(genreNames|genre_names|genres|genre|category|categories)$" -JoinArray
    if ($cats) { $entry["Categories"] = $cats }

    if ($h.Contains("priceOffsetNumerical") -and $null -ne $h["priceOffsetNumerical"]) {
        [double]$numPrice = 0.0
        $rawPriceVal = [string]$h["priceOffsetNumerical"]
        if ([double]::TryParse($rawPriceVal, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$numPrice)) {
            if ($numPrice -gt 20 -and $rawPriceVal -notmatch "\.") { $numPrice = $numPrice / 100.0 }
            $entry["PriceValue"] = [string]$numPrice
            $entry["Price"] = if ($numPrice -eq 0) { "Free" } else { "€" + $numPrice.ToString("0.##", [System.Globalization.CultureInfo]::InvariantCulture) }
        }
        $h.Remove("priceOffsetNumerical")
    }

    # --- Новые поля, подтверждённые реальной схемой DBApplication.cs (репозиторий OculusDB) ---

    # Рейтинг (quality_rating_aggregate, 0.0-5.0)
    if ($h.Contains("quality_rating_aggregate") -and $h["quality_rating_aggregate"]) {
        [double]$ratingVal = 0.0
        if ([double]::TryParse([string]$h["quality_rating_aggregate"], [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$ratingVal) -and $ratingVal -gt 0) {
            $entry["Rating"] = $ratingVal.ToString("0.0", [System.Globalization.CultureInfo]::InvariantCulture) + " / 5"
        }
        $h.Remove("quality_rating_aggregate")
    }

    # Дата релиза (release_date, Unix-время в секундах) — на практике почти всегда
    # 1970-01-01 (эпоха Unix, т.е. поле в реальности пустое у OculusDB), но раз оно
    # изредка всё же бывает заполнено — оставляем как есть, просто не используем
    # для сортировки (см. __lastUpdated ниже, он куда надежнее).
    if ($h.Contains("release_date") -and $h["release_date"]) {
        [long]$relTs = 0
        if ([long]::TryParse([string]$h["release_date"], [ref]$relTs) -and $relTs -gt 0) {
            try {
                $entry["Release Date"] = [DateTimeOffset]::FromUnixTimeSeconds($relTs).UtcDateTime.ToString("yyyy-MM-dd")
            } catch { }
        }
        $h.Remove("release_date")
    }

    # Дата последнего обновления записи (__lastUpdated) — формат заранее не известен
    # (может быть Unix-время или ISO-строка), пробуем оба варианта по очереди.
    if ($h.Contains("__lastUpdated") -and $h["__lastUpdated"]) {
        $rawUpdated = [string]$h["__lastUpdated"]
        $parsedUpdated = $null

        [long]$updTs = 0
        if ([long]::TryParse($rawUpdated, [ref]$updTs) -and $updTs -gt 0) {
            try { $parsedUpdated = [DateTimeOffset]::FromUnixTimeSeconds($updTs).UtcDateTime } catch { }
        }
        if (-not $parsedUpdated) {
            [datetime]$dtOut = [datetime]::MinValue
            if ([datetime]::TryParse($rawUpdated, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$dtOut) -and $dtOut -gt [datetime]::MinValue) {
                $parsedUpdated = $dtOut
            }
        }
        if ($parsedUpdated) {
            $entry["Last Updated"] = $parsedUpdated.ToString("yyyy-MM-dd")
        }
        $h.Remove("__lastUpdated")
    }

    # Требуемое место (required_space_adjusted, байты)
    if ($h.Contains("required_space_adjusted") -and $h["required_space_adjusted"]) {
        [double]$bytesVal = 0.0
        if ([double]::TryParse([string]$h["required_space_adjusted"], [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$bytesVal) -and $bytesVal -gt 0) {
            $entry["Size"] = if ($bytesVal -ge 1GB) {
                ($bytesVal / 1GB).ToString("0.##", [System.Globalization.CultureInfo]::InvariantCulture) + " GB"
            } else {
                ($bytesVal / 1MB).ToString("0.#", [System.Globalization.CultureInfo]::InvariantCulture) + " MB"
            }
        }
        $h.Remove("required_space_adjusted")
    }
    $h.Remove("total_installed_space")  # дублирует Size по смыслу, отдельно не показываем

    # App Lab (is_concept = ранний доступ, не полноценный релиз в сторе)
    if ($h.Contains("is_concept")) {
        $isConcept = [string]$h["is_concept"]
        $entry["App Lab"] = if ($isConcept -eq "True" -or $isConcept -eq "true" -or $isConcept -eq "1") {
            if ($script:IsRu) { "Да" } else { "Yes" }
        } else {
            if ($script:IsRu) { "Нет" } else { "No" }
        }
        $h.Remove("is_concept")
    }

    # Содержит рекламу (has_in_app_ads)
    if ($h.Contains("has_in_app_ads")) {
        $hasAds = [string]$h["has_in_app_ads"]
        if ($hasAds -eq "True" -or $hasAds -eq "true" -or $hasAds -eq "1") {
            $entry["Contains Ads"] = if ($script:IsRu) { "Да" } else { "Yes" }
        }
        $h.Remove("has_in_app_ads")
    }

    # Поддерживаемые гарнитуры (supported_hmd_platforms — список строк)
    $headsets = Get-CandidateField -Item $h -Pattern "^supported_hmd_platforms$" -JoinArray
    if ($headsets) { $entry["Headsets"] = $headsets }

    # PCVR: подтверждено исходниками OculusDB — Meta принудительно добавляет "RIFT"
    # в supported_hmd_platforms для игр с PC-биндарником (binaryType = PCBinary),
    # так что наличие RIFT в уже собранном поле Headsets — надежный признак PC-VR игры.
    if ($headsets -and $headsets -match "RIFT") {
        $entry["PCVR"] = if ($script:IsRu) { "Да" } else { "Yes" }
    }

    # Сайт разработчика/игры (website_url) — оставляем "url" в имени поля,
    # чтобы попасть под общую детекцию URL-полей (кликабельная ссылка + Copy)
    $website = Get-CandidateField -Item $h -Pattern "^website_url$"
    if ($website) { $entry["Website URL"] = $website }

    # Служебные/малополезные поля схемы OculusDB, которые не показываем вообще —
    # внутренние идентификаторы, дублирующиеся или неинформативные в офлайн-снапшоте
    $noiseKeys = @(
        "__OculusDBType", "__sn", "blocked", "canonicalName",
        "platform", "is_approved", "is_enterprise_enabled", "priceLimboDetected",
        "appCanBeBought", "currency", "group", "binaryType", "hmd",
        "supported_hmd_platforms_enum", "discountEndTime"
    )
    foreach ($nk in $noiseKeys) { $h.Remove($nk) }

    $excludeKeys = "^(appName|displayName|title|name|applicationName|display_name|app_name)$"
    foreach ($key in @($h.Keys)) {
        if ($key -match $excludeKeys) { continue }
        $val = $h[$key]
        if ($null -eq $val) { continue }
        if ($val -isnot [System.Collections.IDictionary] -and $val -isnot [System.Collections.ICollection]) {
            $entry[$key] = [string]$val
        }
    }
    return $entry
}

# --- Маппер SideQuest: сырой элемент sidequest_data.json -> каноническая запись ---
# ВНИМАНИЕ: имена полей price/genre/developer/image в bulk-ответе api.sidequestvr.com/search-apps
# определены по аналогии, без живого образца ответа — при первом реальном запуске стоит
# свериться с логом (Log-Debug пишет пропущенные "сырые" поля) и при необходимости
# расширить паттерны ниже.
$script:SideQuestMapper = {
    param($RawItem)
    $h = ConvertTo-ItemHashtable -Item $RawItem

    $entry = [ordered]@{}
    $appName = if ($h.Contains("name") -and $h["name"]) { [string]$h["name"] } else { "Unknown App" }
    $entry["AppName"] = $appName.Trim()
    $h.Remove("name")

    $appId = $null
    if ($h.Contains("apps_id") -and $h["apps_id"]) { $appId = $h["apps_id"] }
    $h.Remove("apps_id")
    if ($null -ne $appId) {
        $entry["ID"] = [string]$appId
        $entry["Store URL"] = "https://sidequestvr.com/app/$appId"
    }

    $img = Get-CandidateField -Item $h -Pattern "^(image|thumbnail|icon|cover|banner|screenshot)"
    if ($img) { $entry["Image URL"] = $img }

    $pkg = Get-CandidateField -Item $h -Pattern "package|bundle"
    if ($pkg) { $entry["Package Name"] = $pkg }

    $dev = Get-CandidateField -Item $h -Pattern "^(developer|author|owner|creator|studio)" -JoinArray
    if ($dev) { $entry["Developer"] = $dev }

    $cats = Get-CandidateField -Item $h -Pattern "^(genre|genres|category|categories|tag|tags)" -JoinArray
    if ($cats) { $entry["Categories"] = $cats }

    $priceRaw = Get-CandidateField -Item $h -Pattern "^(price|cost)"
    if ($priceRaw) {
        [double]$numPrice = 0.0
        $cleanNum = ($priceRaw -replace '[^\d\.,]', '') -replace ',', '.'
        if ($cleanNum -and [double]::TryParse($cleanNum, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$numPrice)) {
            $entry["PriceValue"] = [string]$numPrice
        }
        $entry["Price"] = if ($priceRaw -match "^(0|0\.0+|free)$") { "Free" } else { $priceRaw }
    } else {
        # Подтверждено вживую: у SideQuest нет числовой цены — есть поле "license"
        # со значениями "free"/"paid" (сайт тоже фильтрует только по этим двум состояниям).
        $freeFlag = Get-CandidateField -Item $h -Pattern "^(license|type|price_type|pricing_type|is_free|free|paid)$"
        if ($freeFlag) {
            $isFree = $freeFlag -match "^(free|true|1|yes)$"
            $entry["PriceValue"] = if ($isFree) { "0" } else { "" }
            $entry["Price"] = if ($isFree) { "Free" } else { if ($script:IsRu) { "Платно" } else { "Paid" } }
        }
    }

    # Кросс-платформенность листинга (SideQuest индексирует не только свои прямые
    # сайдлоады, но и ссылки на версии для Steam/Meta) — точное имя поля не подтверждено.
    $platform = Get-CandidateField -Item $h -Pattern "^(platform|store|source_platform)$"
    if ($platform) {
        $entry["Platform"] = $platform
        # Steam VR — по определению PC-VR, а не автономный Quest-контент
        if ($platform -match "steam") {
            $entry["PCVR"] = if ($script:IsRu) { "Да" } else { "Yes" }
        }
    }

    # Best-effort: точные имена полей в bulk-ответе api.sidequestvr.com/search-apps
    # не подтверждены вживую (см. предупреждение выше) — если после переиндексации
    # эти поля не заполнились, смотрите Log-Debug на предмет реальных сырых имен.
    $rating = Get-CandidateField -Item $h -Pattern "^(rating|average_rating|avg_rating|reviews_avg)"
    if ($rating) { $entry["Rating"] = $rating }

    $downloads = Get-CandidateField -Item $h -Pattern "^(downloads|download_count|installs)"
    if ($downloads) { $entry["Downloads"] = $downloads }

    foreach ($key in @($h.Keys)) {
        $val = $h[$key]
        if ($null -eq $val) { continue }
        if ($val -isnot [System.Collections.IDictionary] -and $val -isnot [System.Collections.ICollection]) {
            $entry[$key] = [string]$val
        }
    }
    return $entry
}

# --- Реестр провайдеров: добавление нового источника = один элемент этого массива ---
$script:Providers = @(
    @{
        Name      = "OculusDB"
        RawFile   = (Join-Path $WorkDir "oculus_data.json")
        IndexFile = (Join-Path $WorkDir "oculus_index.json")
        FastParse = $true   # JavaScriptSerializer — быстрее на большом oculus_data.json
        Mapper    = $script:OculusMapper
    },
    @{
        Name      = "SideQuest"
        RawFile   = (Join-Path $WorkDir "sidequest_data.json")
        IndexFile = (Join-Path $WorkDir "sidequest_index.json")
        FastParse = $false  # ConvertFrom-Json, как и раньше
        Mapper    = $script:SideQuestMapper
    }
)

function Get-Provider {
    param([string]$Name)
    return $script:Providers | Where-Object { $_.Name -eq $Name } | Select-Object -First 1
}

# Единая функция индексации: строит {provider}_index.json из {provider}_data.json,
# прогоняя каждый сырой элемент через Mapper этого провайдера.
function Build-ProviderIndex {
    param([Parameter(Mandatory = $true)][string]$ProviderName)

    $provider = Get-Provider -Name $ProviderName
    if (-not $provider) {
        Log-Debug $(if ($script:IsRu) { "Неизвестный провайдер: $ProviderName" } else { "Unknown provider: $ProviderName" })
        return
    }

    if (-not (Test-Path $provider.RawFile)) {
        $statusLbl.Text = "  Error: $(Split-Path $provider.RawFile -Leaf) not found! Click 'Download DB'."
        $statusLbl.ForeColor = $script:C.Danger
        return
    }

    Log-Debug "Starting index rebuild for provider: $($provider.Name)..."
    $script:Sw.Reset()
    $script:Sw.Start()
    $timerLbl.Text = "0.0s"

    $statusLbl.Text = "  Indexing $($provider.Name)... Please wait."
    $statusLbl.ForeColor = $script:C.Accent
    $guiTimer.Start()

    try {
        $rawText = Get-Content $provider.RawFile -Raw -Encoding UTF8
        $rawText = $rawText.TrimStart([char]0xFEFF)
        [System.Windows.Forms.Application]::DoEvents()

        $serializer = $null
        if ($provider.FastParse) {
            $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
            $serializer.MaxJsonLength = [int]::MaxValue
            $parsed = $serializer.Deserialize($rawText, [object[]])
        } else {
            $parsed = $rawText | ConvertFrom-Json
        }
        [System.Windows.Forms.Application]::DoEvents()

        if ($null -eq $parsed) {
            Log-Debug "Error: Failed to parse $($provider.RawFile) or it's empty."
            $guiTimer.Stop()
            $script:Sw.Stop()
            return
        }

        $cleanList = [System.Collections.Generic.List[object]]::new()
        [int]$counter = 0
        foreach ($item in $parsed) {
            $counter++
            if ($counter % 500 -eq 0) { [System.Windows.Forms.Application]::DoEvents() }
            if ($null -eq $item) { continue }

            if ($counter -eq 1) {
                # Разовая диагностика: реальные имена полей самой первой сырой записи —
                # без этого приходится вслепую угадывать структуру ответа источника
                $rawKeys = if ($item -is [System.Collections.IDictionary]) { $item.Keys -join ", " } else { ($item.PSObject.Properties | ForEach-Object { $_.Name }) -join ", " }
                Log-Debug $(if ($script:IsRu) { "$($provider.Name): поля первой сырой записи -> $rawKeys" } else { "$($provider.Name): fields of the first raw item -> $rawKeys" })
            }

            $entry = & $provider.Mapper $item
            if ($null -ne $entry) {
                $entry["Source Database"] = $provider.Name
                $cleanList.Add($entry)
            }
        }

        $jsonOut = if ($serializer) { $serializer.Serialize($cleanList) } else { ConvertTo-Json -InputObject $cleanList -Depth 10 -Compress }
        [System.IO.File]::WriteAllText($provider.IndexFile, $jsonOut, [System.Text.Encoding]::UTF8)

        $guiTimer.Stop()
        $script:Sw.Stop()
        $elapsedSec = [math]::Round($script:Sw.Elapsed.TotalSeconds, 1)
        $timerLbl.Text = "$elapsedSec" + "s"

        Log-Debug "$($provider.Name) index rebuilt. Items count: $($cleanList.Count)"
        if (-not $script:LastCounts) { $script:LastCounts = @{} }
        $script:LastCounts[$provider.Name] = $cleanList.Count
        if ($script:lblDbStats) { Update-DbStatsLabel }
        Load-Data

    } catch {
        Log-Debug "$($provider.Name) Indexation Error: $_ | at: $($_.InvocationInfo.PositionMessage -replace '\s+', ' ')"
        $guiTimer.Stop()
        $script:Sw.Stop()
        $statusLbl.Text = "  Index error: $_"
        $statusLbl.ForeColor = $script:C.Danger
    }
}

# Обёртки для обратной совместимости — старые имена продолжают работать
# везде, где они уже вызываются (кнопка "Индексировать", загрузчики и т.д.)
function Build-FastIndex { Build-ProviderIndex -ProviderName "OculusDB" }
function Build-SideQuestIndex { Build-ProviderIndex -ProviderName "SideQuest" }

function Build-AllSourcesIndex {
    $oculusIndexJson = Join-Path $WorkDir "oculus_index.json"
    $sqIndexJson     = Join-Path $WorkDir "sidequest_index.json"
    $allIndexJson    = Join-Path $WorkDir "all_sources_index.json"

    if (-not (Test-Path $oculusIndexJson)) {
        Log-Debug $(if ($script:IsRu) { "oculus_index.json не найден. Сначала создаем индекс OculusDB..." } else { "oculus_index.json not found. Building OculusDB index first..." })
        Build-ProviderIndex -ProviderName "OculusDB"
    }

    if (-not (Test-Path $sqIndexJson)) {
        Log-Debug $(if ($script:IsRu) { "sidequest_index.json не найден. Сначала создаем индекс SideQuest..." } else { "sidequest_index.json not found. Building SideQuest index first..." })
        Build-ProviderIndex -ProviderName "SideQuest"
    }

    Log-Debug "Starting All Sources index build..."
    $script:Sw.Reset()
    $script:Sw.Start()
    $timerLbl.Text = "0.0s"

    $localIsRu = ($script:Lang -eq "RU" -or $Lang -eq "RU")
    $statusText = if ($localIsRu) { "  Сборка общего индекса (Все источники)... Пожалуйста, подождите." } else { "  Building All Sources index... Please wait." }
    $statusLbl.Text = $statusText
    $statusLbl.ForeColor = $script:C.Accent
    $guiTimer.Start()

    try {
        # NB: пока просто конкатенация индексов провайдеров (без дедупликации —
        # это Этап 3 плана, слияние по Package Name / AppName+Developer / Store URL).
        $combinedList = [System.Collections.Generic.List[object]]::new()

        foreach ($provider in $script:Providers) {
            if (Test-Path $provider.IndexFile) {
                $raw = Get-Content $provider.IndexFile -Raw -Encoding UTF8
                $parsed = $raw | ConvertFrom-Json
                if ($parsed) {
                    foreach ($item in $parsed) {
                        $item | Add-Member -NotePropertyName "Source Database" -NotePropertyValue $provider.Name -Force
                        $combinedList.Add($item)
                    }
                }
            }
        }

        $jsonOut = ConvertTo-Json -InputObject $combinedList -Depth 10 -Compress
        [System.IO.File]::WriteAllText($allIndexJson, $jsonOut, [System.Text.Encoding]::UTF8)

        $guiTimer.Stop()
        $script:Sw.Stop()

        $elapsedSec = [math]::Round($script:Sw.Elapsed.TotalSeconds, 1)
        $timerLbl.Text = "$elapsedSec" + "s"

        Log-Debug "All Sources index built successfully. Total items: $($combinedList.Count)"
        Load-Data

    } catch {
        Log-Debug "All Sources Indexation Error: $_ | at: $($_.InvocationInfo.PositionMessage -replace '\s+', ' ')"
        $guiTimer.Stop()
        $script:Sw.Stop()
        $statusLbl.Text = "  Index error: $_"
        $statusLbl.ForeColor = $script:C.Danger
    }
}

function Load-Data {
    $localIsRu = $script:IsRu
    $ocOn = $script:ActiveOculus
    $sqOn = $script:ActiveSideQuest

    # Ни один тумблер источника не активен — ничего не сканируем и не строим,
    # ровно как раньше делал плейсхолдер "Источники..." в выпадающем списке.
    if (-not $ocOn -and -not $sqOn) {
        $script:Items.Clear()
        $script:CachedMatches = [System.Collections.Generic.List[object]]::new()
        $statusLbl.Text = $script:L.SelectSourcePrompt
        $statusLbl.ForeColor = $script:C.TextDim
        if ($script:lblDbStats) { Update-DbStatsLabel }
        return
    }

    $selectedSource = if ($ocOn -and $sqOn) { if ($localIsRu) { "Все источники" } else { "All Sources" } }
                       elseif ($sqOn) { "SideQuest" }
                       else { "OculusDB" }

    # При ОБОИХ активных источниках читаем оба собственных индекса заново и склеиваем
    # в памяти, а не полагаемся на заранее собранный all_sources_index.json — тот файл
    # легко устаревает (например, если пересобрать отдельно только OculusDB) и тогда
    # "оба источника" внезапно показывают МЕНЬШЕ записей, чем один OculusDB — именно
    # так и проявлялся этот баг.
    $filesToLoad = @()
    if ($ocOn) { $filesToLoad += [pscustomobject]@{ Name = "OculusDB"; Path = (Join-Path $WorkDir "oculus_index.json") } }
    if ($sqOn) { $filesToLoad += [pscustomobject]@{ Name = "SideQuest"; Path = (Join-Path $WorkDir "sidequest_index.json") } }

    $missingFiles = @($filesToLoad | Where-Object { -not (Test-Path $_.Path) })
    if ($missingFiles.Count -gt 0) {
        $msgNotFound = if ($localIsRu) { 
            "Индекс не найден для $selectedSource. Нажмите 'Скачать базу' или 'Индексировать'." 
        } else { 
            "Index not found for $selectedSource. Click 'Download DB' or 'Rebuild Index'." 
        }
        $statusLbl.Text = "  " + $msgNotFound
        $statusLbl.ForeColor = $script:C.Accent
        $script:Items.Clear()
        if ($script:lblDbStats) { Update-DbStatsLabel }
        return
    }

    Log-Debug "Loading data from index(es): $($filesToLoad.Path -join ', ')"
    $script:Sw.Reset()
    $script:Sw.Start()
    
    $statusLbl.Text = if ($localIsRu) { "  Загрузка индекса в память..." } else { "  Loading index into memory..." }
    $statusLbl.ForeColor = $script:C.Accent
    [System.Windows.Forms.Application]::DoEvents()

    try {
        $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
        $serializer.MaxJsonLength = [int]::MaxValue

        $script:Items.Clear()
        foreach ($fileEntry in $filesToLoad) {
            $rawText = Get-Content $fileEntry.Path -Raw -Encoding UTF8
            $rawText = $rawText.TrimStart([char]0xFEFF)
            $parsed = $serializer.Deserialize($rawText, [object[]])
            [int]$countForThis = 0
            if ($parsed) {
                foreach ($item in $parsed) {
                    if ($null -ne $item) {
                        $script:Items.Add($item)
                        $countForThis++
                    }
                }
            }
            if (-not $script:LastCounts) { $script:LastCounts = @{} }
            $script:LastCounts[$fileEntry.Name] = $countForThis
            [System.Windows.Forms.Application]::DoEvents()
        }
        if ($script:lblDbStats) { Update-DbStatsLabel }

        $script:Sw.Stop()
        $elapsedSec = [math]::Round($script:Sw.Elapsed.TotalSeconds, 1)
        
        $readyMsg = if ($localIsRu) { "Готово | Загружено элементов из индекса ($selectedSource): " } else { "Ready | Loaded items from index ($selectedSource): " }
        $statusLbl.Text = "  " + $readyMsg + $script:Items.Count
        $statusLbl.ForeColor = $script:C.TextDim
        
        Log-Debug $(if ($script:IsRu) { "Индекс успешно загружен. Элементов в памяти: $($script:Items.Count)" } else { "Index loaded successfully. Items in memory: $($script:Items.Count)" })

    } catch {
        $script:Sw.Stop()
        $statusLbl.Text = "  Error loading index: $_"
        $statusLbl.ForeColor = $script:C.Danger
        Log-Debug "Load-Data Error: $_"
    }
}

# -----------------------------------------------------------------------------
# 3. ПОИСК И ПОСТРОЕНИЕ КАРТОЧЕК
# -----------------------------------------------------------------------------
function Perform-Search {
    param(
        [int]$PageLimit = 500,
        [int]$CurrentOffset = 0
    )

    if ($script:Items.Count -eq 0) {
        if (-not $script:ActiveOculus -and -not $script:ActiveSideQuest) {
            $statusLbl.Text = $script:L.SelectSourceToSearch
        } else {
            $statusLbl.Text = $script:L.DbEmptyForSearch
        }
        $statusLbl.ForeColor = $script:C.Danger
        return
    }

    $rawQuery = $searchTb.Text.Trim()
    $hasQuery = -not [string]::IsNullOrWhiteSpace($rawQuery)

    $selectedCategories = $script:SelectedCategories
    $hasCategories = ($selectedCategories.Count -gt 0)

    # Цена — своя логика на каждый источник, они никогда не спорят за одну и ту же
    # карточку (см. блок фильтрации ниже): SideQuest смотрит на радиокнопки Free/Paid,
    # OculusDB — на слайдер-потолок цены.
    $sqPriceFilter = if ($script:radioSqFree -and $script:radioSqFree.Checked) { "Free" }
                      elseif ($script:radioSqPaid -and $script:radioSqPaid.Checked) { "Paid" }
                      else { $null }
    $ocMaxPrice = if ($script:sliderOculusPrice) { $script:sliderOculusPrice.Value } else { 50 }
    $ocPriceFilterActive = ($ocMaxPrice -lt 50)
    $hasPriceFilter = ($null -ne $sqPriceFilter) -or $ocPriceFilterActive
    $hasTypeFilter = ($script:FilterPcvr -xor $script:FilterNative)

    if (-not $hasQuery -and -not $hasCategories -and -not $hasPriceFilter -and -not $hasTypeFilter -and $CurrentOffset -eq 0) {
        $statusLbl.Text = if ($script:IsRu) { "  Введите поисковый запрос или выберите фильтр." } else { "  Please enter search terms or select a filter." }
        $statusLbl.ForeColor = $script:C.Yellow
        return
    }

    $priceLogDesc = if ($sqPriceFilter -and $ocPriceFilterActive) { "SideQuest=$sqPriceFilter, OculusDB<=`$$ocMaxPrice" }
                     elseif ($sqPriceFilter) { "SideQuest=$sqPriceFilter" }
                     elseif ($ocPriceFilterActive) { "OculusDB<=`$$ocMaxPrice" }
                     else { if ($script:IsRu) { "любая" } else { "any" } }

    Log-Debug $(if ($script:IsRu) { "Запуск поиска/фильтрации. Запрос: '$rawQuery', Категории: '$($selectedCategories -join ', ')', Цена: '$priceLogDesc', Offset: $CurrentOffset" } else { "Starting search/filter. Query: '$rawQuery', Categories: '$($selectedCategories -join ', ')', Price: '$priceLogDesc', Offset: $CurrentOffset" })
    $script:Sw.Reset()
    $script:Sw.Start()
    $timerLbl.Text = "0.0s"
    if ($CurrentOffset -eq 0) {
        $statusLbl.Text = if ($script:IsRu) { "  Идет фильтрация... Пожалуйста, подождите." } else { "  Filtering in progress... Please wait." }
        $statusLbl.ForeColor = $script:C.Accent
        $cardsPanel.Controls.Clear()
        $cardsPanel.AutoScrollPosition = New-Object System.Drawing.Point(0, 0)
    }
    
    $guiTimer.Start()
    [System.Windows.Forms.Application]::DoEvents()

    $words = if ($hasQuery) { $rawQuery.ToLower().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries) } else { @() }

    # "В результатах" — сужаем поиск по уже отфильтрованному и выведенному списку,
    # а не пересканируем весь текущий индекс с нуля. Источник нужно зафиксировать
    # ДО того, как ниже перезапишется $script:CachedMatches.
    $searchInResults = ($script:cbInResults -and $script:cbInResults.Checked -and $script:CachedMatches -and $script:CachedMatches.Count -gt 0)
    $searchSourceItems = if ($searchInResults) { $script:CachedMatches } else { $script:Items }
    if ($searchInResults) {
        Log-Debug $(if ($script:IsRu) { "Поиск в результатах: сужаем по $($script:CachedMatches.Count) уже найденным записям." } else { "Search in results: narrowing within $($script:CachedMatches.Count) already found items." })
    }

    if ($CurrentOffset -eq 0) {
        $cardsPanel.SuspendLayout()
        $script:CachedMatches = [System.Collections.Generic.List[object]]::new()
        [int]$processedCount = 0

        foreach ($item in $searchSourceItems) {
            $processedCount++
            if ($processedCount % 300 -eq 0) {
                [System.Windows.Forms.Application]::DoEvents()
            }

            # 1. Текст
            [bool]$textMatched = $true
            if ($hasQuery) {
                $appName = Get-AppName -item $item
                $appNameLower = $appName.ToLower()
                $descTextLower = ""
                if ($script:SearchInDescs) {
                    foreach ($key in $item.Keys) {
                        if ($key -match "description|summary" -or ($item[$key] -is [string] -and $item[$key].Length -gt 100)) {
                            $descTextLower += " " + ([string]$item[$key]).ToLower()
                        }
                    }
                }
                $packageLower = ""
                if ($script:SearchInPackage -and $item.ContainsKey("Package Name") -and $item["Package Name"]) {
                    $packageLower = ([string]$item["Package Name"]).ToLower()
                }
                [int]$matchedWordsCount = 0
                foreach ($w in $words) {
                    [bool]$wordFound = $false
                    if ($script:SearchInNames -and $appNameLower.Contains($w)) { $wordFound = $true }
                    if (-not $wordFound -and $script:SearchInDescs -and $descTextLower.Contains($w)) { $wordFound = $true }
                    if (-not $wordFound -and $script:SearchInPackage -and $packageLower.Contains($w)) { $wordFound = $true }
                    if ($wordFound) { $matchedWordsCount++ }
                }
                if ($script:MatchAllWords) {
                    if ($matchedWordsCount -ne $words.Count) { $textMatched = $false }
                } else {
                    if ($matchedWordsCount -eq 0) { $textMatched = $false }
                }
            }
            if (-not $textMatched) { continue }

            # 2. Категории (множественный выбор, совпадение по любой из выбранных)
            if ($hasCategories) {
                [bool]$categoryMatched = $false
                foreach ($key in $item.Keys) {
                    if ($null -ne $item[$key] -and $item[$key] -is [string]) {
                        $valStr = [string]$item[$key]
                        foreach ($cat in $selectedCategories) {
                            if ($valStr -like "*$cat*") {
                                $categoryMatched = $true
                                break
                            }
                        }
                        if ($categoryMatched) { break }
                    }
                }
                if (-not $categoryMatched) { continue }
            }

            # 3. Цена — раздельно по источнику записи, фильтры друг другу не мешают,
            # т.к. каждый применяется только к карточкам "своего" источника.
            if ($hasPriceFilter) {
                $itemSource = if ($item.ContainsKey("Source Database")) { [string]$item["Source Database"] } else { "" }

                if ($itemSource -eq "SideQuest" -and $sqPriceFilter) {
                    $itemPriceText = if ($item.ContainsKey("Price")) { [string]$item["Price"] } else { "" }
                    if ($sqPriceFilter -eq "Free" -and $itemPriceText -ne "Free") { continue }
                    if ($sqPriceFilter -eq "Paid" -and $itemPriceText -eq "Free") { continue }
                }
                elseif ($itemSource -eq "OculusDB" -and $ocPriceFilterActive) {
                    [double]$numPrice = 0.0
                    [bool]$hasNumPrice = $false

                    if ($item.ContainsKey("PriceValue") -and $null -ne $item["PriceValue"]) {
                        # Каноническое поле (заполняется мапперами провайдеров)
                        $rawPriceVal = [string]$item["PriceValue"]
                        if ([double]::TryParse($rawPriceVal, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$numPrice)) {
                            $hasNumPrice = $true
                        }
                    } elseif ($item.ContainsKey("priceOffsetNumerical") -and $null -ne $item["priceOffsetNumerical"]) {
                        # Fallback для индексов, собранных до появления PriceValue
                        $rawPriceVal = [string]$item["priceOffsetNumerical"]
                        if ([double]::TryParse($rawPriceVal, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$numPrice)) {
                            if ($numPrice -gt 20 -and $rawPriceVal -notmatch "\.") {
                                $numPrice = $numPrice / 100.0
                            }
                            $hasNumPrice = $true
                        }
                    }

                    if (-not $hasNumPrice -or $numPrice -gt $ocMaxPrice) { continue }
                }
                # Карточки из источников без своего ценового фильтра (пока таких нет) не трогаем
            }

            # 4. PCVR / Native — оба тумблера выключены = фильтр не действует (как и
            # у тумблеров источников, "оба включены" тоже равнозначно "показать всё").
            if ($script:FilterPcvr -and -not $script:FilterNative) {
                $isPcvrItem = $item.ContainsKey("PCVR") -and $item["PCVR"]
                if (-not $isPcvrItem) { continue }
            } elseif ($script:FilterNative -and -not $script:FilterPcvr) {
                $isPcvrItem = $item.ContainsKey("PCVR") -and $item["PCVR"]
                if ($isPcvrItem) { continue }
            }

            $script:CachedMatches.Add($item)
        }

        if ($script:CachedMatches.Count -gt 0) {
            $sortMode = if ($script:cmbSort) { $script:cmbSort.SelectedItem } else { $null }

            # "Естественное" направление для каждого режима (рейтинг/дата — сперва
            # новое/лучшее; имя/цена — по возрастанию), кнопка "Обр" его инвертирует.
            $naturalDesc = ($sortMode -eq $script:L.SortRating) -or ($sortMode -eq $script:L.SortDate)
            $effectiveDesc = $naturalDesc -xor $script:SortDescending

            $sortedArray = if ($sortMode -eq $script:L.SortRating) {
                @($script:CachedMatches | Sort-Object -Descending:$effectiveDesc {
                    $r = $_["Rating"]
                    $ratingVal = -1.0
                    if ($r) {
                        $rm = [regex]::Match([string]$r, '^([\d\.]+)')
                        if ($rm.Success) { [double]::TryParse($rm.Groups[1].Value, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$ratingVal) | Out-Null }
                    }
                    $ratingVal
                })
            } elseif ($sortMode -eq $script:L.SortDate) {
                @($script:CachedMatches | Sort-Object -Descending:$effectiveDesc {
                    if ($_.ContainsKey("Last Updated") -and $_["Last Updated"]) { [string]$_["Last Updated"] } else { "0000-00-00" }
                })
            } elseif ($sortMode -eq $script:L.SortPrice) {
                @($script:CachedMatches | Sort-Object -Descending:$effectiveDesc {
                    $priceVal = [double]::MaxValue
                    if ($_.ContainsKey("PriceValue") -and $_["PriceValue"]) {
                        [double]$pv = 0.0
                        if ([double]::TryParse([string]$_["PriceValue"], [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$pv)) { $priceVal = $pv }
                    }
                    $priceVal
                })
            } else {
                @($script:CachedMatches | Sort-Object -Descending:$effectiveDesc { Get-AppName -item $_ })
            }

            $newList = [System.Collections.Generic.List[object]]::new()
            foreach ($it in $sortedArray) { $newList.Add($it) }
            $script:CachedMatches = $newList
        }
    }

    $toTake = [Math]::Min($PageLimit, $script:CachedMatches.Count - $CurrentOffset)
    if ($toTake -lt 0) { $toTake = 0 }
    
    $matches = if ($toTake -gt 0) { @($script:CachedMatches | Select-Object -Skip $CurrentOffset -First $toTake) } else { @() }

    $guiTimer.Stop()
    $script:Sw.Stop()
    $elapsedSec = [math]::Round($script:Sw.Elapsed.TotalSeconds, 1)
    $timerLbl.Text = "$elapsedSec" + "s"

    $totalShown = $CurrentOffset + $matches.Count
    if ($script:CachedMatches.Count -gt $totalShown) {
        $statusLbl.Text = if ($script:IsRu) { "  Найдено: $($script:CachedMatches.Count). Показано: $totalShown. Используйте кнопку внизу." } else { "  Found: $($script:CachedMatches.Count). Shown: $totalShown. Use the button below to load more." }
        $statusLbl.ForeColor = $script:C.Yellow
    } else {
        $statusLbl.Text = if ($script:IsRu) { "  Найдено совпадений: $($script:CachedMatches.Count) (отсортировано по алфавиту)" } else { "  Matches found: $($script:CachedMatches.Count) (sorted alphabetically)" }
        $statusLbl.ForeColor = $script:C.TextDim
    }
    
    [int]$mCount = $matches.Count
    Log-Debug $(if ($script:IsRu) { "Поиск/выгрузка завершена за $elapsedSec с. Показано элементов: $mCount" } else { "Search/render completed in $elapsedSec s. Items shown: $mCount" })

    [int]$y = if ($CurrentOffset -gt 0) { $cardsPanel.Controls.Count } else { 10 }
    if ($CurrentOffset -gt 0 -and $cardsPanel.Controls.Count -gt 0) {
        $lastCtrl = $cardsPanel.Controls[$cardsPanel.Controls.Count - 1]
        if ($lastCtrl.Tag -eq "LoadMoreButton") {
            $cardsPanel.Controls.Remove($lastCtrl)
            $y = $lastCtrl.Location.Y
        }
    }

    foreach ($item in $matches) {
        $displayName = Get-AppName -item $item
        $isPcvr = $item.ContainsKey("PCVR") -and $item["PCVR"]
        $headerText = "  [+] $displayName"
        
        [int]$scrollBarWidth = [System.Windows.Forms.SystemInformation]::VerticalScrollBarWidth
        [int]$cardWidth = $cardsPanel.ClientSize.Width - 24 - $scrollBarWidth
        if ($cardWidth -lt 540) { $cardWidth = 540 }

        $card = New-Object System.Windows.Forms.Panel
        $card.Location    = New-Object System.Drawing.Point(10, $y)
        $card.Width       = $cardWidth
        $card.Height      = 32
        $card.BackColor   = $script:C.CardBg
        $card.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $card.Anchor      = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right

        $header = New-Object System.Windows.Forms.Label
        $header.Text      = $headerText
        $header.Dock      = [System.Windows.Forms.DockStyle]::Top
        $header.Height    = 30
        $header.BackColor = $script:C.CardHeader
        $header.ForeColor = $script:C.Accent
        $header.Font      = $script:F.Title
        $header.Cursor    = [System.Windows.Forms.Cursors]::Hand
        $header.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
        $header.Tag       = $item
        $card.Controls.Add($header)

        if ($isPcvr) {
            $pcvrLbl = New-Object System.Windows.Forms.Label
            $pcvrLbl.Text      = "[PCVR]"
            $pcvrLbl.AutoSize  = $true
            $pcvrLbl.BackColor = $script:C.CardHeader
            $pcvrLbl.ForeColor = [System.Drawing.Color]::FromArgb(255, 165, 0)
            $pcvrLbl.Font      = $script:F.Bold
            $pcvrLbl.Location  = New-Object System.Drawing.Point(($cardWidth - 75), 8)
            $pcvrLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
            # Важно: метка — дочерний элемент HEADER, а не CARD. Обработчик клика
            # ниже определяет "тело карточки ещё не построено?" по $card.Controls.Count
            # (должно быть ровно 1 — только header, до первого разворачивания).
            # Если добавить метку как отдельного ребёнка $card, счетчик собьётся и
            # код спутает саму метку с телом карточки — ровно так это и ломалось.
            $header.Controls.Add($pcvrLbl)
            $pcvrLbl.BringToFront()
        }

        $header.Add_Click({
            param($sender, $e)
            $pCard = $sender.Parent
            $appData = $sender.Tag
            $nameHeader = Get-AppName -item $appData
            
            if ($pCard.Controls.Count -gt 1) {
                $pBody = $pCard.Controls[0]
                if ($pBody.Visible) {
                    $pBody.Visible = $false
                    $pCard.Height  = 32
                    $sender.Text   = "  [+] " + $nameHeader
                } else {
                    $pBody.Visible = $true
                    $pCard.Height  = $pCard.Tag
                    $sender.Text   = "  [-] " + $nameHeader
                }
            } else {
                $body = New-Object System.Windows.Forms.Panel
                $body.Dock    = [System.Windows.Forms.DockStyle]::Fill
                $body.Padding = New-Object System.Windows.Forms.Padding(10)
                $body.Visible = $false

                $pCard.Controls.Add($body)
                $body.BringToFront()

                [int]$fy = 5
                $descriptions = @()
                [int]$rowWidth = $pCard.Width - 25

                foreach ($key in $appData.Keys) {
                    if ($key -eq "AppName") { continue }
                    if ($key -match "unproce") { continue }

                    $valStr = [string]$appData[$key]
                    if ($key -match "price") {
                        $valStr = $valStr -replace '\\u20AC', '' -replace '[^\d\.,]', ''
                    }

                    if ($key -match "description|summary|info|details" -or $valStr.Length -gt 120) {
                        $descriptions += @{ Key = $key; Value = $valStr }
                        continue
                    }

                    $isImageField = ($key -match "image|icon|banner|logo|hero|cover")
                    $isUrlField   = ($key -match "Store URL|Link to Meta|url|uri") -or $isImageField

                    $displayUrl = $valStr
                    if ($isImageField -and $displayUrl.StartsWith("/")) {
                        $displayUrl = "https://oculusdb.rui2015.me" + $displayUrl
                    }

                    $rowPanel = New-Object System.Windows.Forms.Panel
                    $rowPanel.Location = New-Object System.Drawing.Point(10, $fy)
                    $rowPanel.Size = New-Object System.Drawing.Size($rowWidth, 24)

                    [int]$lblWidth = 210
                    $lbl = New-Object System.Windows.Forms.Label
                    $lbl.Text      = (Get-FriendlyFieldLabel -Key $key) + ":"
                    $lbl.Location  = New-Object System.Drawing.Point(0, 2)
                    $lbl.Size      = New-Object System.Drawing.Size($lblWidth, 20)
                    $lbl.ForeColor = [System.Drawing.Color]::White
                    $lbl.Font      = $script:F.Bold
                    $lbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
                    $rowPanel.Controls.Add($lbl)

                    [int]$valLeft = 215
                    [int]$btnWidth = 60
                    [int]$rightMargin = 12
                    [int]$btnX = $rowWidth - $btnWidth - $rightMargin
                    [int]$fieldWidth = $btnX - $valLeft - 5

                    if ($isUrlField) {
                        if (-not $isImageField) {
                            [int]$btnWidth = 80
                            [int]$btnX = $rowWidth - $btnWidth - $rightMargin
                            $copyBtn = New-Object System.Windows.Forms.Button
                            $copyBtn.Text      = "Copy"
                            $copyBtn.Location  = New-Object System.Drawing.Point($btnX, 0)
                            $copyBtn.Size      = New-Object System.Drawing.Size($btnWidth, 24)
                            $copyBtn.BackColor = $script:C.CardHeader
                            $copyBtn.ForeColor = $script:C.Text
                            $copyBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                            $copyBtn.Font      = $script:F.Small
                            $copyBtn.Tag       = $displayUrl
                            
                            $copyBtn.Add_Click({
                                param($sBtn, $eArgs)
                                if ($sBtn.Tag) {
                                    try {
                                        [System.Windows.Forms.Clipboard]::SetText([string]$sBtn.Tag)
                                        $statusLbl.Text = "  Copied to clipboard: $($sBtn.Tag)"
                                        $statusLbl.ForeColor = [System.Drawing.Color]::LightGreen
                                    } catch {
                                        $statusLbl.Text = "  Copied (clipboard locked)"
                                        $statusLbl.ForeColor = $script:C.Yellow
                                    }
                                }
                            })
                            $rowPanel.Controls.Add($copyBtn)
                        } else {
                            [int]$btnWidth = 80
                            [int]$btnX = $rowWidth - $btnWidth - $rightMargin
                            $previewBtn = New-Object System.Windows.Forms.Button
                            $previewBtn.Text      = "Preview"
                            $previewBtn.Location  = New-Object System.Drawing.Point($btnX, 0)
                            $previewBtn.Size      = New-Object System.Drawing.Size($btnWidth, 24)
                            $previewBtn.BackColor = [System.Drawing.Color]::FromArgb(60, 120, 216)
                            $previewBtn.ForeColor = [System.Drawing.Color]::White
                            $previewBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                            $previewBtn.Font      = $script:F.Small
                            $previewBtn.Tag       = $displayUrl

                            $previewBtn.Add_Click({
                                param($sBtn, $eArgs)
                                if ($sBtn.Tag) {
                                    Show-ImagePreview -ImageUrl $sBtn.Tag -Title $nameHeader
                                }
                            })
                            $rowPanel.Controls.Add($previewBtn)
                        }

                        $link = New-Object System.Windows.Forms.LinkLabel
                        $link.Text        = $displayUrl
                        $link.Location    = New-Object System.Drawing.Point($valLeft, 3)
                        $link.Size        = New-Object System.Drawing.Size($fieldWidth, 20)
                        $link.ActiveLinkColor = [System.Drawing.Color]::Orange
                        $link.LinkColor   = $script:C.Accent
                        $link.Font        = $script:F.Main
                        $link.Tag         = $displayUrl
                        
                        $link.Add_LinkClicked({
                            param($sLink, $eArgs)
                            try {
                                $psi = New-Object System.Diagnostics.ProcessStartInfo
                                $psi.FileName = [string]$sLink.Tag
                                $psi.UseShellExecute = $true
                                $psi.CreateNoWindow = $true
                                [System.Diagnostics.Process]::Start($psi) | Out-Null
                            } catch {}
                        })
                        $rowPanel.Controls.Add($link)

                    } else {
                        $tb = New-Object System.Windows.Forms.TextBox
                        $tb.Text        = $valStr
                        $tb.Location    = New-Object System.Drawing.Point($valLeft, 0)
                        $tb.Size        = New-Object System.Drawing.Size(($fieldWidth + $btnWidth + 5), 23)
                        $tb.ReadOnly    = $true
                        $tb.BackColor   = $script:C.Disabled
                        $tb.ForeColor   = $script:C.Text
                        $tb.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
                        $rowPanel.Controls.Add($tb)
                    }

                    $body.Controls.Add($rowPanel)
                    $fy = [int]($fy + 28)
                }

                foreach ($desc in $descriptions) {
                    $descHeaderPanel = New-Object System.Windows.Forms.Panel
                    $descHeaderPanel.Location = New-Object System.Drawing.Point(10, $fy)
                    $descHeaderPanel.Size = New-Object System.Drawing.Size($rowWidth, 24)

                    $lblDesc = New-Object System.Windows.Forms.Label
                    $lblDesc.Text      = (Get-FriendlyFieldLabel -Key $desc.Key) + ":"
                    $lblDesc.Location  = New-Object System.Drawing.Point(0, 2)
                    $lblDesc.Size      = New-Object System.Drawing.Size(200, 20)
                    $lblDesc.ForeColor = $script:C.Accent
                    $lblDesc.Font      = $script:F.Bold
                    $descHeaderPanel.Controls.Add($lblDesc)

                    [int]$actionBtnWidth = 80
                    [int]$rightMargin = 12
                    [int]$actionBtnX = $rowWidth - $actionBtnWidth - $rightMargin
                    
                    $transBtn = New-Object System.Windows.Forms.Button
                    $transBtn.Text      = if ($isRu) { "Перевод" } else { "Translate" }
                    $transBtn.Location  = New-Object System.Drawing.Point($actionBtnX, 0)
                    $transBtn.Size      = New-Object System.Drawing.Size($actionBtnWidth, 24)
                    $transBtn.BackColor = [System.Drawing.Color]::FromArgb(46, 139, 87)
                    $transBtn.ForeColor = [System.Drawing.Color]::White
                    $transBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                    $transBtn.Font      = $script:F.Small
                    $transBtn.Tag       = $desc.Value
                    
                    $transBtn.Add_Click({
                        param($sBtn, $eArgs)
                        if ($sBtn.Tag) {
                            Show-TranslationWindow -Title $displayName -OriginalText ([string]$sBtn.Tag)
                        }
                    })
                    $descHeaderPanel.Controls.Add($transBtn)
                    $body.Controls.Add($descHeaderPanel)

                    $rtbDesc = New-Object System.Windows.Forms.RichTextBox
                    $rtbDesc.Location    = New-Object System.Drawing.Point(10, [int]($fy + 26))
                    $rtbDesc.Size        = New-Object System.Drawing.Size($rowWidth, 110)
                    $rtbDesc.ReadOnly    = $true
                    $rtbDesc.BackColor   = $script:C.Disabled
                    $rtbDesc.ForeColor   = $script:C.Yellow
                    $rtbDesc.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
                    
                    if (Get-Command "Format-MarkdownToRichText" -ErrorAction SilentlyContinue) {
                        Format-MarkdownToRichText -Rtb $rtbDesc -RawText $desc.Value
                    } else {
                        $rtbDesc.Text = $desc.Value
                    }

                    $body.Controls.Add($rtbDesc)
                    $fy = [int]($fy + 144)
                }

                [int]$totalHeight = $fy + 45
                $pCard.Tag    = $totalHeight
                $body.Visible = $true
                $pCard.Height = $totalHeight
                $sender.Text  = "  [-] " + $nameHeader
            }
        })

        $cardsPanel.Controls.Add($card)
        $y = [int]($y + $card.Height + 12)
    }

    if ($script:CachedMatches.Count -gt ($CurrentOffset + $matches.Count)) {
        [int]$scrollBarWidth = [System.Windows.Forms.SystemInformation]::VerticalScrollBarWidth
        [int]$btnWidth = $cardsPanel.ClientSize.Width - 24 - $scrollBarWidth
        if ($btnWidth -lt 540) { $btnWidth = 540 }

        $loadMoreBtn = New-Object System.Windows.Forms.Button
        $loadMoreBtn.Text      = if ($isRu) { "Показать следующие 500 результатов (Осталось: $($script:CachedMatches.Count - ($CurrentOffset + $matches.Count)))" } else { "Show next 500 results (Remaining: $($script:CachedMatches.Count - ($CurrentOffset + $matches.Count)))" }
        $loadMoreBtn.Location  = New-Object System.Drawing.Point(10, $y)
        $loadMoreBtn.Size      = New-Object System.Drawing.Size($btnWidth, 40)
        $loadMoreBtn.BackColor = $script:C.CardHeader
        $loadMoreBtn.ForeColor = $script:C.Accent
        $loadMoreBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $loadMoreBtn.Font      = $script:F.Bold
        $loadMoreBtn.Cursor    = [System.Windows.Forms.Cursors]::Hand
        $loadMoreBtn.Tag       = "LoadMoreButton"

        $nextOffset = $CurrentOffset + $matches.Count
        $loadMoreBtn.Add_Click({
            Perform-Search -PageLimit 500 -CurrentOffset $nextOffset
        })

        $cardsPanel.Controls.Add($loadMoreBtn)
    }

    if ($CurrentOffset -eq 0) {
        $cardsPanel.ResumeLayout()
    }
    [System.Windows.Forms.Application]::DoEvents()
}

# -----------------------------------------------------------------------------
# 2. ИНТЕРФЕЙС ГЛАВНОГО ОКНА
# -----------------------------------------------------------------------------
$form = New-Object System.Windows.Forms.Form
$form.Text            = $script:L.Title
$form.BackColor       = $script:C.Bg
$form.ForeColor       = $script:C.Text
$form.Font            = $script:F.Main
$form.Size            = New-Object System.Drawing.Size(950, 750)
$form.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterScreen

$topPanel = New-Object System.Windows.Forms.Panel
$topPanel.Dock      = [System.Windows.Forms.DockStyle]::Top
$topPanel.Height    = 192
$topPanel.BackColor = $script:C.Panel

$statusLbl = New-Object System.Windows.Forms.Label
$statusLbl.Dock      = [System.Windows.Forms.DockStyle]::Bottom
$statusLbl.Height    = 25
$statusLbl.BackColor = $script:C.Panel
$statusLbl.ForeColor = $script:C.TextDim
$statusLbl.Font      = $script:F.Small
$statusLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft

$debugTb = New-Object System.Windows.Forms.TextBox
$debugTb.Dock        = [System.Windows.Forms.DockStyle]::Bottom
$debugTb.Height      = 130
$debugTb.Multiline   = $true
$debugTb.ScrollBars  = [System.Windows.Forms.ScrollBars]::Vertical
$debugTb.BackColor   = $script:C.DebugBg
$debugTb.ForeColor   = [System.Drawing.Color]::LightGreen
$debugTb.Font        = $script:F.Mono
$debugTb.ReadOnly    = $true
$debugTb.Visible     = $false

$cardsPanel = New-Object System.Windows.Forms.Panel
$cardsPanel.Dock       = [System.Windows.Forms.DockStyle]::Fill
$cardsPanel.AutoScroll = $true
$cardsPanel.BackColor  = $script:C.Bg

$form.Controls.Add($statusLbl)
$form.Controls.Add($debugTb)
$form.Controls.Add($topPanel)
$form.Controls.Add($cardsPanel)
$cardsPanel.BringToFront()

# --- Группа 1: Поиск ---
$grpSearch = New-Object System.Windows.Forms.GroupBox
$grpSearch.Text      = $script:L.GroupSearch
$grpSearch.Location  = New-Object System.Drawing.Point(8, 4)
$grpSearch.Size      = New-Object System.Drawing.Size(614, 92)
$grpSearch.BackColor = $script:C.Panel
$grpSearch.ForeColor = $script:C.Accent
$grpSearch.Font      = $script:F.Small
$topPanel.Controls.Add($grpSearch)

$script:searchTb = New-Object System.Windows.Forms.TextBox
$script:searchTb.Location    = New-Object System.Drawing.Point(10, 20)
$script:searchTb.Size        = New-Object System.Drawing.Size(270, 23)
$script:searchTb.BackColor   = $script:C.Input
$script:searchTb.ForeColor   = $script:C.Text
$script:searchTb.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$grpSearch.Controls.Add($script:searchTb)

$searchBtn = New-Object System.Windows.Forms.Button
$searchBtn.Text      = $script:L.SearchBtn
$searchBtn.Location  = New-Object System.Drawing.Point(288, 19)
$searchBtn.Size      = New-Object System.Drawing.Size(68, 25)
$searchBtn.BackColor = $script:C.BtnBg
$searchBtn.ForeColor = $script:C.Text
$searchBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$searchBtn.Font      = $script:F.Bold
$grpSearch.Controls.Add($searchBtn)

$script:cbInResults = New-Object System.Windows.Forms.CheckBox
$script:cbInResults.Text      = $script:L.InResultsChk
$script:cbInResults.Location  = New-Object System.Drawing.Point(364, 21)
$script:cbInResults.Size      = New-Object System.Drawing.Size(125, 22)
$script:cbInResults.BackColor = $script:C.Panel
$script:cbInResults.ForeColor = $script:C.Accent
$script:cbInResults.Font      = $script:F.Bold
$script:cbInResults.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:cbInResults.FlatAppearance.BorderSize = 0

# Полностью самостоятельная отрисовка (штатные BackColor/ForeColor/FlatAppearance
# не позволяют независимо задать три разных цвета: текст / заливка квадратика /
# сама галочка — ForeColor красит текст и галочку одним и тем же значением).
# Тут рисуем каждый элемент отдельно и явно нужными цветами.
$script:cbInResults.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Перекрываем стандартную отрисовку своим фоном (цвет панели, как и раньше)
    $g.Clear($sender.BackColor)

    # Квадратик-глиф: фиксированный размер, по центру по вертикали, слева
    $boxSize = 14
    $boxY = [int](($sender.Height - $boxSize) / 2)
    $boxRect = New-Object System.Drawing.Rectangle(0, $boxY, $boxSize, $boxSize)

    # Заливка квадратика — всегда чёрная, в любом состоянии
    $blackBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)
    $g.FillRectangle($blackBrush, $boxRect)
    $blackBrush.Dispose()

    $whitePen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 1)
    $g.DrawRectangle($whitePen, $boxRect)
    $whitePen.Dispose()

    # Галочка — белая, рисуется только когда отмечено
    if ($sender.Checked) {
        $tickPen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2)
        # Каждая точка отдельным вызовом (не внутри одного @(...) через запятую) —
        # New-Object Type(args) без -ArgumentList внутри общего списка парсится
        # ненадёжно, отсюда и была ошибка "не удается найти позиционный параметр"
        $tp1 = New-Object System.Drawing.Point(3, ($boxY + 7))
        $tp2 = New-Object System.Drawing.Point(6, ($boxY + 10))
        $tp3 = New-Object System.Drawing.Point(11, ($boxY + 3))
        $tickPoints = @($tp1, $tp2, $tp3)
        $g.DrawLines($tickPen, $tickPoints)
        $tickPen.Dispose()
    }

    # Текст — приглушённый синий (Accent), справа от квадратика
    $textBrush = New-Object System.Drawing.SolidBrush($sender.ForeColor)
    $textRect = New-Object System.Drawing.RectangleF(($boxSize + 6), 0, ($sender.Width - $boxSize - 6), $sender.Height)
    $sf = New-Object System.Drawing.StringFormat
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($sender.Text, $sender.Font, $textBrush, $textRect, $sf)
    $textBrush.Dispose()
    $sf.Dispose()
})

# Клик уже переключает Checked стандартно — нужно только явно попросить
# перерисовку, раз внешний вид теперь полностью на нашей совести
$script:cbInResults.Add_Click({ $this.Invalidate() })

$grpSearch.Controls.Add($script:cbInResults)

$btnReset = New-Object System.Windows.Forms.Button
$btnReset.Text      = $script:L.ResetBtn
$btnReset.Location  = New-Object System.Drawing.Point(493, 19)
$btnReset.Size      = New-Object System.Drawing.Size(112, 25)
$btnReset.BackColor = [System.Drawing.Color]::FromArgb(120, 40, 40)
$btnReset.ForeColor = [System.Drawing.Color]::White
$btnReset.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnReset.Font      = $script:F.Small
$grpSearch.Controls.Add($btnReset)

$btnNames = New-Object System.Windows.Forms.Button
$btnNames.Text      = $script:L.NamesBtn
$btnNames.Location  = New-Object System.Drawing.Point(10, 52)
$btnNames.Size      = New-Object System.Drawing.Size(62, 25)
$btnNames.BackColor = $script:C.ToggleOn
$btnNames.ForeColor = [System.Drawing.Color]::White
$btnNames.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnNames.Font      = $script:F.Small
$grpSearch.Controls.Add($btnNames)

$btnDescs = New-Object System.Windows.Forms.Button
$btnDescs.Text      = $script:L.DescsBtn
$btnDescs.Location  = New-Object System.Drawing.Point(76, 52)
$btnDescs.Size      = New-Object System.Drawing.Size(68, 25)
$btnDescs.BackColor = $script:C.ToggleOff
$btnDescs.ForeColor = $script:C.TextDim
$btnDescs.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnDescs.Font      = $script:F.Small
$grpSearch.Controls.Add($btnDescs)

$btnLogic = New-Object System.Windows.Forms.Button
$btnLogic.Text      = $script:L.LogicAll
$btnLogic.Location  = New-Object System.Drawing.Point(148, 52)
$btnLogic.Size      = New-Object System.Drawing.Size(58, 25)
$btnLogic.BackColor = $script:C.ToggleOn
$btnLogic.ForeColor = [System.Drawing.Color]::White
$btnLogic.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnLogic.Font      = $script:F.Small
$grpSearch.Controls.Add($btnLogic)

$btnPackage = New-Object System.Windows.Forms.Button
$btnPackage.Text      = $script:L.PackageBtn
$btnPackage.Location  = New-Object System.Drawing.Point(218, 52)
$btnPackage.Size      = New-Object System.Drawing.Size(90, 25)
$btnPackage.BackColor = $script:C.ToggleOff
$btnPackage.ForeColor = $script:C.TextDim
$btnPackage.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnPackage.Font      = $script:F.Small
$grpSearch.Controls.Add($btnPackage)

$btnPackage.Add_Click({
    $script:SearchInPackage = -not $script:SearchInPackage
    $btnPackage.BackColor = if ($script:SearchInPackage) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $btnPackage.ForeColor = if ($script:SearchInPackage) { [System.Drawing.Color]::White } else { $script:C.TextDim }
})

$isRu = ($script:Lang -eq "RU" -or $Lang -eq "RU")

$script:btnFilterPcvr = New-Object System.Windows.Forms.Button
$script:btnFilterPcvr.Text      = $script:L.PcvrBtn
$script:btnFilterPcvr.Location  = New-Object System.Drawing.Point(320, 52)
$script:btnFilterPcvr.Size      = New-Object System.Drawing.Size(58, 25)
$script:btnFilterPcvr.BackColor = $script:C.ToggleOff
$script:btnFilterPcvr.ForeColor = $script:C.TextDim
$script:btnFilterPcvr.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:btnFilterPcvr.Font      = $script:F.Small
$grpSearch.Controls.Add($script:btnFilterPcvr)

$script:btnFilterNative = New-Object System.Windows.Forms.Button
$script:btnFilterNative.Text      = $script:L.NativeBtn
$script:btnFilterNative.Location  = New-Object System.Drawing.Point(382, 52)
$script:btnFilterNative.Size      = New-Object System.Drawing.Size(100, 25)
$script:btnFilterNative.BackColor = $script:C.ToggleOff
$script:btnFilterNative.ForeColor = $script:C.TextDim
$script:btnFilterNative.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:btnFilterNative.Font      = $script:F.Small
$grpSearch.Controls.Add($script:btnFilterNative)

$script:btnFilterPcvr.Add_Click({
    $script:FilterPcvr = -not $script:FilterPcvr
    $script:btnFilterPcvr.BackColor = if ($script:FilterPcvr) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $script:btnFilterPcvr.ForeColor = if ($script:FilterPcvr) { [System.Drawing.Color]::White } else { $script:C.TextDim }
})

$script:btnFilterNative.Add_Click({
    $script:FilterNative = -not $script:FilterNative
    $script:btnFilterNative.BackColor = if ($script:FilterNative) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $script:btnFilterNative.ForeColor = if ($script:FilterNative) { [System.Drawing.Color]::White } else { $script:C.TextDim }
})

# PCVR/Native — деление есть только у OculusDB; когда активен ТОЛЬКО SideQuest,
# эти кнопки неактуальны, отключаем их, чтобы не запутывать.
function Update-PcvrFilterAvailability {
    $available = -not ($script:ActiveSideQuest -and -not $script:ActiveOculus)
    $script:btnFilterPcvr.Enabled = $available
    $script:btnFilterNative.Enabled = $available
    if (-not $available) {
        if ($script:FilterPcvr) {
            $script:FilterPcvr = $false
            $script:btnFilterPcvr.BackColor = $script:C.ToggleOff
            $script:btnFilterPcvr.ForeColor = $script:C.TextDim
        }
        if ($script:FilterNative) {
            $script:FilterNative = $false
            $script:btnFilterNative.BackColor = $script:C.ToggleOff
            $script:btnFilterNative.ForeColor = $script:C.TextDim
        }
    }
}

$script:btnCategories = New-Object System.Windows.Forms.Button
$script:btnCategories.Location  = New-Object System.Drawing.Point(493, 52)
$script:btnCategories.Size      = New-Object System.Drawing.Size(112, 25)
$script:btnCategories.Text      = $script:L.CategoriesBtn
$script:btnCategories.BackColor = [System.Drawing.Color]::FromArgb(70, 50, 90)
$script:btnCategories.ForeColor = [System.Drawing.Color]::FromArgb(190, 170, 210)
$script:btnCategories.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:btnCategories.FlatAppearance.BorderSize = 1
$script:btnCategories.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(150, 80, 200)
$script:btnCategories.Font      = $script:F.Small
$script:btnCategories.Add_Click({ Show-CategoriesWindow })
$grpSearch.Controls.Add($script:btnCategories)
Update-CategoriesButtonLabel

# --- Группа 1.5: Инструменты (справа от блока поиска) ---
$grpTools = New-Object System.Windows.Forms.GroupBox
$grpTools.Text      = $script:L.GroupTools
$grpTools.Location  = New-Object System.Drawing.Point(630, 4)
$grpTools.Size      = New-Object System.Drawing.Size(301, 92)
$grpTools.BackColor = $script:C.Panel
$grpTools.ForeColor = $script:C.Accent
$grpTools.Font      = $script:F.Small
$topPanel.Controls.Add($grpTools)

$script:SortDescending = $false
$script:LastCounts = @{}

$script:cmbSort = New-Object System.Windows.Forms.ComboBox
$script:cmbSort.Location  = New-Object System.Drawing.Point(10, 20)
$script:cmbSort.Size      = New-Object System.Drawing.Size(115, 23)
$script:cmbSort.BackColor = $script:C.Input
$script:cmbSort.ForeColor = $script:C.Text
$script:cmbSort.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:cmbSort.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$script:cmbSort.Font      = $script:F.Small
foreach ($s in @($script:L.SortName, $script:L.SortRating, $script:L.SortDate, $script:L.SortPrice)) {
    $script:cmbSort.Items.Add($s) > $null
}
$script:cmbSort.SelectedIndex = 0
$grpTools.Controls.Add($script:cmbSort)

$script:btnReverseSort = New-Object System.Windows.Forms.Button
$script:btnReverseSort.Text      = if ($isRu) { "Обр" } else { "Rev" }
$script:btnReverseSort.Location  = New-Object System.Drawing.Point(129, 20)
$script:btnReverseSort.Size      = New-Object System.Drawing.Size(26, 23)
$script:btnReverseSort.BackColor = $script:C.ToggleOff
$script:btnReverseSort.ForeColor = $script:C.TextDim
$script:btnReverseSort.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:btnReverseSort.Font      = $script:F.Small
$grpTools.Controls.Add($script:btnReverseSort)

$script:btnReverseSort.Add_Click({
    $script:SortDescending = -not $script:SortDescending
    $script:btnReverseSort.BackColor = if ($script:SortDescending) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $script:btnReverseSort.ForeColor = if ($script:SortDescending) { [System.Drawing.Color]::White } else { $script:C.TextDim }
    if ($script:CachedMatches -and $script:CachedMatches.Count -gt 0) { Perform-Search }
})

$script:cmbSort.Add_SelectedIndexChanged({
    # Смена режима сортировки должна сразу переупорядочить уже показанный список,
    # а не молча ждать следующего нажатия "Найти"
    if ($script:CachedMatches -and $script:CachedMatches.Count -gt 0) { Perform-Search }
})

$btnExport = New-Object System.Windows.Forms.Button
$btnExport.Text      = $script:L.ExportBtn
$btnExport.Location  = New-Object System.Drawing.Point(10, 52)
$btnExport.Size      = New-Object System.Drawing.Size(68, 25)
$btnExport.BackColor = $script:C.BtnBg
$btnExport.ForeColor = $script:C.Text
$btnExport.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnExport.Font      = $script:F.Small
$grpTools.Controls.Add($btnExport)

$btnRandom = New-Object System.Windows.Forms.Button
$btnRandom.Text      = $script:L.RandomBtn
$btnRandom.Location  = New-Object System.Drawing.Point(82, 52)
$btnRandom.Size      = New-Object System.Drawing.Size(100, 25)
$btnRandom.BackColor = $script:C.BtnBg
$btnRandom.ForeColor = $script:C.Text
$btnRandom.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRandom.Font      = $script:F.Small
$grpTools.Controls.Add($btnRandom)

$script:lblDbStats = New-Object System.Windows.Forms.Label
$script:lblDbStats.Location  = New-Object System.Drawing.Point(178, 10)
$script:lblDbStats.Size      = New-Object System.Drawing.Size(106, 70)
$script:lblDbStats.BackColor = $script:C.Panel
$script:lblDbStats.ForeColor = $script:C.TextDim
$script:lblDbStats.Font      = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Regular)
$grpTools.Controls.Add($script:lblDbStats)

$btnRandom.Add_Click({
    $pool = if ($script:CachedMatches -and $script:CachedMatches.Count -gt 0) { $script:CachedMatches }
             elseif ($script:Items -and $script:Items.Count -gt 0) { $script:Items }
             else { $null }
    if (-not $pool -or $pool.Count -eq 0) {
        $statusLbl.Text = $script:L.SelectSourceToSearch
        $statusLbl.ForeColor = $script:C.Danger
        return
    }
    $randomItem = $pool[(Get-Random -Maximum $pool.Count)]
    $randomName = Get-AppName -item $randomItem
    $script:searchTb.Text = $randomName
    Perform-Search
})

$btnExport.Add_Click({
    if (-not $script:CachedMatches -or $script:CachedMatches.Count -eq 0) {
        $statusLbl.Text = $script:L.ExportNothingMsg
        $statusLbl.ForeColor = $script:C.Yellow
        return
    }

    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Title    = $script:L.ExportSaveTitle
    $saveDialog.Filter   = "CSV (*.csv)|*.csv|JSON (*.json)|*.json"
    $saveDialog.FileName = "search_results.csv"

    if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            if ($saveDialog.FileName.ToLower().EndsWith(".json")) {
                $jsonOut = ConvertTo-Json -InputObject @($script:CachedMatches) -Depth 10
                [System.IO.File]::WriteAllText($saveDialog.FileName, $jsonOut, [System.Text.Encoding]::UTF8)
            } else {
                $rows = foreach ($it in $script:CachedMatches) {
                    [pscustomobject]@{
                        AppName   = Get-AppName -item $it
                        ID        = if ($it.ContainsKey("ID")) { $it["ID"] } else { "" }
                        Developer = if ($it.ContainsKey("Developer")) { $it["Developer"] } else { "" }
                        Categories = if ($it.ContainsKey("Categories")) { $it["Categories"] } else { "" }
                        Price     = if ($it.ContainsKey("Price")) { $it["Price"] } else { "" }
                        Rating    = if ($it.ContainsKey("Rating")) { $it["Rating"] } else { "" }
                        "Store URL" = if ($it.ContainsKey("Store URL")) { $it["Store URL"] } else { "" }
                        "Source Database" = if ($it.ContainsKey("Source Database")) { $it["Source Database"] } else { "" }
                    }
                }
                $rows | Export-Csv -Path $saveDialog.FileName -NoTypeInformation -Encoding UTF8
            }
            $statusLbl.Text = "  " + $script:L.ExportDoneMsg + $saveDialog.FileName
            $statusLbl.ForeColor = $script:C.TextDim
        } catch {
            $statusLbl.Text = "  Export error: $_"
            $statusLbl.ForeColor = $script:C.Danger
        }
    }
})

# Разноцветные строки статистики (активный/присутствующий источник — белым,
# неактивный/отсутствующий — приглушенным) обычный Label одним ForeColor не
# нарисует, поэтому, как и с чекбоксом "В результатах", рисуем вручную.
$script:lblDbStats.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.Clear($sender.BackColor)
    $lines = $sender.Tag
    if (-not $lines) { return }
    $y = 0
    foreach ($ln in $lines) {
        $color = if ($ln.White) { [System.Drawing.Color]::White } else { $script:C.TextDim }
        $brush = New-Object System.Drawing.SolidBrush($color)
        $g.DrawString($ln.Text, $sender.Font, $brush, 0, $y)
        $brush.Dispose()
        $y += 13
    }
})

# Обновляет "живую" статистику: сколько записей есть у каждой базы. Показывается
# ВСЕГДА для обеих баз (не только для включенных тумблером) — для источника, чей
# индекс еще не строился/скачивался, честно пишем "нет данных"/"n/a" вместо числа.
# Активный (включенный тумблером) источник и итоговая строка красятся белым —
# неактивный или отсутствующий остается приглушенным.
function Update-DbStatsLabel {
    $providers = @(
        @{ Name = "OculusDB";  File = (Join-Path $WorkDir "oculus_index.json");   Active = $script:ActiveOculus }
        @{ Name = "SideQuest"; File = (Join-Path $WorkDir "sidequest_index.json"); Active = $script:ActiveSideQuest }
    )

    $lines = @()
    $anyData = $false

    foreach ($p in $providers) {
        if (-not $script:LastCounts.ContainsKey($p.Name)) {
            if (Test-Path $p.File) {
                try {
                    $raw = Get-Content $p.File -Raw -Encoding UTF8
                    $raw = $raw.TrimStart([char]0xFEFF)
                    $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
                    $ser.MaxJsonLength = [int]::MaxValue
                    $parsedTmp = $ser.Deserialize($raw, [object[]])
                    $script:LastCounts[$p.Name] = if ($parsedTmp) { @($parsedTmp | Where-Object { $null -ne $_ }).Count } else { 0 }
                } catch {
                    $script:LastCounts[$p.Name] = $null
                }
            } else {
                $script:LastCounts[$p.Name] = $null
            }
        }

        $countVal = $script:LastCounts[$p.Name]
        if ($null -ne $countVal) { $anyData = $true }

        $valText = if ($null -ne $countVal) { [string]$countVal } else { if ($script:IsRu) { "Нет данных" } else { "n/a" } }
        $lines += @{ Text = "$($p.Name): $valText"; White = ($p.Active -and ($null -ne $countVal)) }
    }

    $totalCount = ($script:LastCounts.Values | Where-Object { $null -ne $_ } | Measure-Object -Sum).Sum
    $totalLabel = if ($script:IsRu) { "Всего: $totalCount" } else { "Total: $totalCount" }
    $totalWhite = $anyData -and ($script:ActiveOculus -or $script:ActiveSideQuest)
    $lines += @{ Text = $totalLabel; White = $totalWhite }

    $script:lblDbStats.Tag = $lines
    $script:lblDbStats.Invalidate()
}

# --- Группа 2: Управление базами ---
$grpDatabases = New-Object System.Windows.Forms.GroupBox
$grpDatabases.Text      = $script:L.GroupDatabases
$grpDatabases.Location  = New-Object System.Drawing.Point(8, 104)
$grpDatabases.Size      = New-Object System.Drawing.Size(515, 76)
$grpDatabases.BackColor = $script:C.Panel
$grpDatabases.ForeColor = $script:C.Accent
$grpDatabases.Font      = $script:F.Small
$topPanel.Controls.Add($grpDatabases)

$script:cmbPrices = $null
$script:cmbSources = $null

$script:btnSrcOculus = New-Object System.Windows.Forms.Button
$script:btnSrcOculus.Text      = "OculusDB"
$script:btnSrcOculus.Location  = New-Object System.Drawing.Point(10, 30)
$script:btnSrcOculus.Size      = New-Object System.Drawing.Size(90, 25)
$script:btnSrcOculus.BackColor = $script:C.ToggleOff
$script:btnSrcOculus.ForeColor = $script:C.TextDim
$script:btnSrcOculus.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:btnSrcOculus.Font      = $script:F.Small
$grpDatabases.Controls.Add($script:btnSrcOculus)

$script:sliderOculusPrice = New-Object System.Windows.Forms.TrackBar
$script:sliderOculusPrice.Location  = New-Object System.Drawing.Point(105, 26)
$script:sliderOculusPrice.Size      = New-Object System.Drawing.Size(130, 30)
$script:sliderOculusPrice.Minimum   = 0
$script:sliderOculusPrice.Maximum   = 50
$script:sliderOculusPrice.Value     = 50
$script:sliderOculusPrice.TickStyle = [System.Windows.Forms.TickStyle]::None
$script:sliderOculusPrice.BackColor = $script:C.Panel
$grpDatabases.Controls.Add($script:sliderOculusPrice)

$script:lblOculusPrice = New-Object System.Windows.Forms.Label
$script:lblOculusPrice.Location  = New-Object System.Drawing.Point(240, 32)
$script:lblOculusPrice.Size      = New-Object System.Drawing.Size(55, 20)
$script:lblOculusPrice.ForeColor = $script:C.TextDim
$script:lblOculusPrice.Font      = $script:F.Small
$script:lblOculusPrice.Text      = if ($isRu) { "Любая" } else { "Any" }
$grpDatabases.Controls.Add($script:lblOculusPrice)

$script:btnSrcSideQuest = New-Object System.Windows.Forms.Button
$script:btnSrcSideQuest.Text      = "SideQuest"
$script:btnSrcSideQuest.Location  = New-Object System.Drawing.Point(300, 30)
$script:btnSrcSideQuest.Size      = New-Object System.Drawing.Size(90, 25)
$script:btnSrcSideQuest.BackColor = $script:C.ToggleOff
$script:btnSrcSideQuest.ForeColor = $script:C.TextDim
$script:btnSrcSideQuest.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$script:btnSrcSideQuest.Font      = $script:F.Small
$grpDatabases.Controls.Add($script:btnSrcSideQuest)

$script:radioSqFree = New-Object System.Windows.Forms.RadioButton
$script:radioSqFree.Text      = "Free"
$script:radioSqFree.Location  = New-Object System.Drawing.Point(395, 32)
$script:radioSqFree.Size      = New-Object System.Drawing.Size(48, 20)
$script:radioSqFree.ForeColor = $script:C.TextDim
$script:radioSqFree.Font      = $script:F.Small
$grpDatabases.Controls.Add($script:radioSqFree)

$script:radioSqPaid = New-Object System.Windows.Forms.RadioButton
$script:radioSqPaid.Text      = "Paid"
$script:radioSqPaid.Location  = New-Object System.Drawing.Point(446, 32)
$script:radioSqPaid.Size      = New-Object System.Drawing.Size(48, 20)
$script:radioSqPaid.ForeColor = $script:C.TextDim
$script:radioSqPaid.Font      = $script:F.Small
$grpDatabases.Controls.Add($script:radioSqPaid)

$script:btnSrcOculus.Add_Click({
    $script:ActiveOculus = -not $script:ActiveOculus
    $script:btnSrcOculus.BackColor = if ($script:ActiveOculus) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $script:btnSrcOculus.ForeColor = if ($script:ActiveOculus) { [System.Drawing.Color]::White } else { $script:C.TextDim }
    # Сброс "поиска в результатах" при смене набора активных источников — старые
    # CachedMatches относились к другому индексу, сужать по ним дальше бессмысленно
    if ($script:cbInResults) { $script:cbInResults.Checked = $false }
    # Только подгружаем данные в память — сам поиск запускается по кнопке "Найти"/Enter,
    # а не автоматически (иначе включение обоих тумблеров подряд = два лишних поиска)
    Load-Data
    Update-PcvrFilterAvailability
})

$script:btnSrcSideQuest.Add_Click({
    $script:ActiveSideQuest = -not $script:ActiveSideQuest
    $script:btnSrcSideQuest.BackColor = if ($script:ActiveSideQuest) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $script:btnSrcSideQuest.ForeColor = if ($script:ActiveSideQuest) { [System.Drawing.Color]::White } else { $script:C.TextDim }
    if ($script:cbInResults) { $script:cbInResults.Checked = $false }
    Load-Data
    Update-PcvrFilterAvailability
})

$script:sliderOculusPrice.Add_ValueChanged({
    $script:lblOculusPrice.Text = if ($script:sliderOculusPrice.Value -ge 50) {
        if ($isRu) { "Любая" } else { "Any" }
    } else {
        "<= `$$($script:sliderOculusPrice.Value)"
    }
})

# --- Группа 3: Служебное ---
$grpService = New-Object System.Windows.Forms.GroupBox
$grpService.Text      = $script:L.GroupService
$grpService.Location  = New-Object System.Drawing.Point(531, 104)
$grpService.Size      = New-Object System.Drawing.Size(400, 76)
$grpService.BackColor = $script:C.Panel
$grpService.ForeColor = $script:C.Accent
$grpService.Font      = $script:F.Small
$topPanel.Controls.Add($grpService)

$timerLbl = New-Object System.Windows.Forms.Label
$timerLbl.Text      = "0.0s"
$timerLbl.Location  = New-Object System.Drawing.Point(10, 20)
$timerLbl.Size      = New-Object System.Drawing.Size(50, 18)
$timerLbl.Font      = $script:F.Bold
$timerLbl.ForeColor = $script:C.TextDim
$grpService.Controls.Add($timerLbl)

$rebuildBtn = New-Object System.Windows.Forms.Button
$rebuildBtn.Text      = $script:L.RebuildBtn
$rebuildBtn.Location  = New-Object System.Drawing.Point(10, 42)
$rebuildBtn.Size      = New-Object System.Drawing.Size(100, 25)
$rebuildBtn.BackColor = $script:C.CardHeader
$rebuildBtn.ForeColor = $script:C.Accent
$rebuildBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$rebuildBtn.Font      = $script:F.Small
$grpService.Controls.Add($rebuildBtn)

$helpBtn = New-Object System.Windows.Forms.Button
$helpBtn.Text      = $script:L.HelpBtn
$helpBtn.Location  = New-Object System.Drawing.Point(215, 42)
$helpBtn.Size      = New-Object System.Drawing.Size(75, 25)
$helpBtn.BackColor = $script:C.CardHeader
$helpBtn.ForeColor = $script:C.Accent
$helpBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$helpBtn.Font      = $script:F.Small
$grpService.Controls.Add($helpBtn)

$downloadBtn = New-Object System.Windows.Forms.Button
$downloadBtn.Text      = $script:L.DownloadBtn
$downloadBtn.Location  = New-Object System.Drawing.Point(115, 42)
$downloadBtn.Size      = New-Object System.Drawing.Size(95, 25)
$downloadBtn.BackColor = [System.Drawing.Color]::FromArgb(60, 179, 113)
$downloadBtn.ForeColor = [System.Drawing.Color]::White
$downloadBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$downloadBtn.Font      = $script:F.Small
$grpService.Controls.Add($downloadBtn)

$debugBtn = New-Object System.Windows.Forms.Button
$debugBtn.Text      = $script:L.DebugBtn
$debugBtn.Location  = New-Object System.Drawing.Point(295, 42)
$debugBtn.Size      = New-Object System.Drawing.Size(75, 25)
$debugBtn.BackColor = $script:C.CardHeader
$debugBtn.ForeColor = $script:C.Yellow
$debugBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$debugBtn.Font      = $script:F.Small
$grpService.Controls.Add($debugBtn)

# --- Сброс фильтров: возвращает всё к состоянию сразу после запуска программы ---
$btnReset.Add_Click({
    $script:searchTb.Text = ""

    $script:ActiveOculus = $false
    $script:btnSrcOculus.BackColor = $script:C.ToggleOff
    $script:btnSrcOculus.ForeColor = $script:C.TextDim

    $script:ActiveSideQuest = $false
    $script:btnSrcSideQuest.BackColor = $script:C.ToggleOff
    $script:btnSrcSideQuest.ForeColor = $script:C.TextDim

    $script:sliderOculusPrice.Value = 50
    $script:radioSqFree.Checked = $false
    $script:radioSqPaid.Checked = $false

    $script:FilterPcvr = $false
    $script:btnFilterPcvr.BackColor = $script:C.ToggleOff
    $script:btnFilterPcvr.ForeColor = $script:C.TextDim

    $script:FilterNative = $false
    $script:btnFilterNative.BackColor = $script:C.ToggleOff
    $script:btnFilterNative.ForeColor = $script:C.TextDim

    Update-PcvrFilterAvailability

    $script:SearchInPackage = $false
    $btnPackage.BackColor = $script:C.ToggleOff
    $btnPackage.ForeColor = $script:C.TextDim

    $script:SelectedCategories.Clear()
    Update-CategoriesButtonLabel

    $script:cbInResults.Checked = $false
    $script:cmbSort.SelectedIndex = 0
    $script:SortDescending = $false
    if ($script:btnReverseSort) {
        $script:btnReverseSort.BackColor = $script:C.ToggleOff
        $script:btnReverseSort.ForeColor = $script:C.TextDim
    }
    Update-DbStatsLabel

    $script:Items.Clear()
    $script:CachedMatches = [System.Collections.Generic.List[object]]::new()
    $cardsPanel.Controls.Clear()

    $statusLbl.Text = $script:L.SelectSourcePrompt
    $statusLbl.ForeColor = $script:C.TextDim
})

$btnNames.Add_Click({
    $script:SearchInNames = -not $script:SearchInNames
    $btnNames.BackColor = if ($script:SearchInNames) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $btnNames.ForeColor = if ($script:SearchInNames) { [System.Drawing.Color]::White } else { $script:C.TextDim }
})

$btnDescs.Add_Click({
    $script:SearchInDescs = -not $script:SearchInDescs
    $btnDescs.BackColor = if ($script:SearchInDescs) { $script:C.ToggleOn } else { $script:C.ToggleOff }
    $btnDescs.ForeColor = if ($script:SearchInDescs) { [System.Drawing.Color]::White } else { $script:C.TextDim }
})

$btnLogic.Add_Click({
    $script:MatchAllWords = -not $script:MatchAllWords
    if ($script:MatchAllWords) {
        $btnLogic.Text = $script:L.LogicAll
        $btnLogic.BackColor = $script:C.ToggleOn
    } else {
        $btnLogic.Text = $script:L.LogicAny
        $btnLogic.BackColor = $script:C.BtnBg
    }
})

$debugBtn.Add_Click({ 
    $debugTb.Visible = -not $debugTb.Visible 
    Log-Debug $(if ($script:IsRu) { "Консоль отладки переключена (видимость: $($debugTb.Visible))" } else { "Debug console toggled (visible: $($debugTb.Visible))" })
})

$helpBtn.Add_Click({ Show-HelpWindow })
$rebuildBtn.Add_Click({
    # Индексируем по тем же активным тумблерам, что и поиск/скачивание —
    # раньше эта кнопка всегда пересобирала только OculusDB независимо от выбора
    if (-not $script:ActiveOculus -and -not $script:ActiveSideQuest) {
        $statusLbl.Text = $script:L.SelectSourceToSearch
        $statusLbl.ForeColor = $script:C.Danger
        return
    }
    if ($script:ActiveOculus) { Build-ProviderIndex -ProviderName "OculusDB" }
    if ($script:ActiveSideQuest) { Build-ProviderIndex -ProviderName "SideQuest" }
})

# ==============================================================================
# Обработчик нажатия кнопки "Скачать базу" ($downloadBtn)
# ==============================================================================
$downloadBtn.Add_Click({
    # Источник определяется активными тумблерами (заменили выпадающий список)
    if (-not $script:ActiveOculus -and -not $script:ActiveSideQuest) {
        $statusLbl.Text = $script:L.SelectSourceToSearch
        $statusLbl.ForeColor = $script:C.Danger
        return
    }

    # ==========================================================================
    # ВЕТКА 1: Активен только "SideQuest"
    # ==========================================================================
    if ($script:ActiveSideQuest -and -not $script:ActiveOculus) {
        $promptText = if ($isRu) { 
            "Скачать свежую базу с SideQuest и перезаписать sidequest_data.json?" 
        } else { 
            "Download latest database from SideQuest and overwrite sidequest_data.json?" 
        }

        $msg = [System.Windows.Forms.MessageBox]::Show(
            $promptText, 
            $script:L.DownTitle, 
            [System.Windows.Forms.MessageBoxButtons]::YesNo, 
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($msg -eq [System.Windows.Forms.DialogResult]::Yes) {
            $downloadBtn.Enabled = $false
            [System.Windows.Forms.Application]::DoEvents()
            
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
                
                $statusLbl.Text = if ($isRu) { "  Скачивание базы SideQuest с сервера..." } else { "  Downloading SideQuest database..." }
                $statusLbl.ForeColor = $script:C.Yellow
                
                $script:Sw.Reset()
                $script:Sw.Start()
                $timerLbl.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 204)
                $guiTimer.Start()
                [System.Windows.Forms.Application]::DoEvents()

                $url = "https://api.sidequestvr.com/search-apps"
                $headers = @{
                    "Content-Type" = "application/json"
                    "Origin"       = "https://sidequestvr.com"
                    "User-Agent"   = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                }

                $sidequestJsonPath = Join-Path $WorkDir "sidequest_data.json"
                
                # Инициализация JSON-массива в файле
                [System.IO.File]::WriteAllText($sidequestJsonPath, "[", [System.Text.Encoding]::UTF8)

                $page = 0
                $pageSize = 100
                $totalDownloaded = 0
                $isFirstChunk = $true

                do {
                    $statusLbl.Text = if ($isRu) { "  Скачивание страницы SideQuest №$page..." } else { "  Downloading SideQuest page #$page..." }
                    [System.Windows.Forms.Application]::DoEvents()

                    $body = @{
                        limit = $pageSize
                        page  = $page
                    } | ConvertTo-Json -Compress

                    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -Headers $headers -UseBasicParsing
                    $chunk = if ($response -and $response.data) { $response.data } else { $null }

                    if ($null -eq $chunk -or $chunk.Count -eq 0) {
                        Log-Debug $(if ($script:IsRu) { "Страница $page пуста. Завершаем скачивание." } else { "Page $page is empty. Stopping download." })
                        break
                    }

                    # Сериализуем и дописываем кусок массива
                    $chunkJson = ConvertTo-Json -InputObject $chunk -Depth 10 -Compress
                    $innerJson = $chunkJson.TrimStart('[').TrimEnd(']')

                    $appendString = if ($isFirstChunk) { $innerJson } else { "," + $innerJson }
                    [System.IO.File]::AppendAllText($sidequestJsonPath, $appendString, [System.Text.Encoding]::UTF8)

                    $totalDownloaded += $chunk.Count
                    $isFirstChunk = $false

                    Log-Debug $(if ($script:IsRu) { "Страница $page записана. Элементов: $($chunk.Count). Всего сохранено: $totalDownloaded" } else { "Page $page written. Items: $($chunk.Count). Total saved: $totalDownloaded" })

                    if ($chunk.Count -lt $pageSize) { break }

                    $page++
                    Start-Sleep -Milliseconds 100

                } while ($page -lt 300)

                # Закрываем JSON-массив
                [System.IO.File]::AppendAllText($sidequestJsonPath, "]", [System.Text.Encoding]::UTF8)

                $script:Sw.Stop()
                $guiTimer.Stop()
                $timerLbl.ForeColor = $script:C.TextDim
                
                $statusLbl.Text = if ($isRu) { "  Загрузка SideQuest завершена ($totalDownloaded записей). Индексация..." } else { "  SideQuest download complete ($totalDownloaded items). Indexing..." }
                $statusLbl.ForeColor = $script:C.Accent
                [System.Windows.Forms.Application]::DoEvents()
                
                Build-SideQuestIndex
                
            } catch {
                $guiTimer.Stop()
                $script:Sw.Stop()
                $timerLbl.ForeColor = $script:C.TextDim
                $statusLbl.Text = "  Download failed: $_"
                $statusLbl.ForeColor = $script:C.Danger
                Log-Debug "SideQuest Download Error: $_"
            } finally {
                $downloadBtn.Enabled = $true
            }
        }
    }
    # ==========================================================================
    # ВЕТКА 2: Активны оба тумблера — "Все источники"
    # ==========================================================================
    elseif ($script:ActiveOculus -and $script:ActiveSideQuest) {
        $promptText = if ($isRu) { 
            "Скачать и обновить обе базы (OculusDB и SideQuest), после чего создать общий индекс?" 
        } else { 
            "Download and update both databases (OculusDB and SideQuest), then build a combined index?" 
        }

        $msg = [System.Windows.Forms.MessageBox]::Show(
            $promptText, 
            $script:L.DownTitle, 
            [System.Windows.Forms.MessageBoxButtons]::YesNo, 
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($msg -eq [System.Windows.Forms.DialogResult]::Yes) {
            $downloadBtn.Enabled = $false
            [System.Windows.Forms.Application]::DoEvents()

            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
                
                $script:Sw.Reset()
                $script:Sw.Start()
                $timerLbl.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 204)
                $guiTimer.Start()

                # --- Шаг 1: Скачиваем OculusDB ---
                $statusLbl.Text = if ($isRu) { "  [1/2] Скачивание базы OculusDB..." } else { "  [1/2] Downloading OculusDB database..." }
                $statusLbl.ForeColor = $script:C.Yellow
                [System.Windows.Forms.Application]::DoEvents()

                $oldProgressPreference = $ProgressPreference
                $ProgressPreference = 'SilentlyContinue'
                try {
                    Invoke-WebRequest -Uri "https://oculusdb.rui2015.me/api/v1/allapps" -OutFile $SourceJson -UseBasicParsing
                } finally {
                    $ProgressPreference = $oldProgressPreference
                }

                Build-FastIndex

                # --- Шаг 2: Скачиваем SideQuest ---
                $statusLbl.Text = if ($isRu) { "  [2/2] Скачивание базы SideQuest..." } else { "  [2/2] Downloading SideQuest database..." }
                [System.Windows.Forms.Application]::DoEvents()

                $url = "https://api.sidequestvr.com/search-apps"
                $headers = @{
                    "Content-Type" = "application/json"
                    "Origin"       = "https://sidequestvr.com"
                    "User-Agent"   = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                }

                $sidequestJsonPath = Join-Path $WorkDir "sidequest_data.json"
                [System.IO.File]::WriteAllText($sidequestJsonPath, "[", [System.Text.Encoding]::UTF8)

                $page = 0
                $pageSize = 100
                $totalSQDownloaded = 0
                $isFirstChunk = $true

                do {
                    $statusLbl.Text = if ($isRu) { "  [2/2] Скачивание SideQuest (стр. №$page)..." } else { "  [2/2] Downloading SideQuest (page #$page)..." }
                    [System.Windows.Forms.Application]::DoEvents()

                    $body = @{ limit = $pageSize; page = $page } | ConvertTo-Json -Compress
                    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -Headers $headers -UseBasicParsing
                    $chunk = if ($response -and $response.data) { $response.data } else { $null }

                    if ($null -eq $chunk -or $chunk.Count -eq 0) { break }

                    $chunkJson = ConvertTo-Json -InputObject $chunk -Depth 10 -Compress
                    $innerJson = $chunkJson.TrimStart('[').TrimEnd(']')

                    $appendString = if ($isFirstChunk) { $innerJson } else { "," + $innerJson }
                    [System.IO.File]::AppendAllText($sidequestJsonPath, $appendString, [System.Text.Encoding]::UTF8)

                    $totalSQDownloaded += $chunk.Count
                    $isFirstChunk = $false
                    if ($chunk.Count -lt $pageSize) { break }

                    $page++
                    Start-Sleep -Milliseconds 100

                } while ($page -lt 300)

                [System.IO.File]::AppendAllText($sidequestJsonPath, "]", [System.Text.Encoding]::UTF8)
                Build-SideQuestIndex
                # Отдельный "общий" индекс больше не строим — Load-Data теперь сама
                # склеивает oculus_index.json + sidequest_index.json заново при каждой
                # загрузке, так что промежуточный файл не может устареть

            } catch {
                $guiTimer.Stop()
                $script:Sw.Stop()
                $timerLbl.ForeColor = $script:C.TextDim
                $statusLbl.Text = "  Download failed: $_"
                $statusLbl.ForeColor = $script:C.Danger
                Log-Debug "All Sources Download Error: $_"
            } finally {
                $downloadBtn.Enabled = $true
            }
        }
    }
    # ==========================================================================
    # ВЕТКА 3: Активен только "OculusDB"
    # ==========================================================================
    elseif ($script:ActiveOculus -and -not $script:ActiveSideQuest) {
        $msg = [System.Windows.Forms.MessageBox]::Show(
            $script:L.DownPrompt, 
            $script:L.DownTitle, 
            [System.Windows.Forms.MessageBoxButtons]::YesNo, 
            [System.Windows.Forms.MessageBoxIcon]::Question
        )
        if ($msg -eq [System.Windows.Forms.DialogResult]::Yes) {
            $downloadBtn.Enabled = $false
            [System.Windows.Forms.Application]::DoEvents()
            
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
                
                $statusLbl.Text = if ($isRu) { "  Скачивание базы данных OculusDB..." } else { "  Downloading OculusDB database..." }
                $statusLbl.ForeColor = $script:C.Yellow
                
                $script:Sw.Reset()
                $script:Sw.Start()
                $timerLbl.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 204)
                $guiTimer.Start()
                [System.Windows.Forms.Application]::DoEvents()

                $oldProgressPreference = $ProgressPreference
                $ProgressPreference = 'SilentlyContinue'

                try {
                    Invoke-WebRequest -Uri "https://oculusdb.rui2015.me/api/v1/allapps" -OutFile $SourceJson -UseBasicParsing
                } finally {
                    $ProgressPreference = $oldProgressPreference
                }
                
                $script:Sw.Stop()
                $guiTimer.Stop()
                $timerLbl.ForeColor = $script:C.TextDim
                
                if (Test-Path $SourceJson) {
                    $fileSize = (Get-Item $SourceJson).Length
                    $statusLbl.Text = if ($isRu) { "  Загрузка завершена ($fileSize байт). Переиндексация..." } else { "  Download complete ($fileSize bytes). Reindexing..." }
                } else {
                    $statusLbl.Text = if ($isRu) { "  Загрузка завершена! Переиндексация..." } else { "  Download complete! Reindexing..." }
                }
                
                $statusLbl.ForeColor = $script:C.Accent
                [System.Windows.Forms.Application]::DoEvents()
                
                Build-FastIndex
                
            } catch {
                $guiTimer.Stop()
                $script:Sw.Stop()
                $timerLbl.ForeColor = $script:C.TextDim
                $statusLbl.Text = "  Download failed: $_"
                $statusLbl.ForeColor = $script:C.Danger
                Log-Debug "Download Error: $_"
            } finally {
                $downloadBtn.Enabled = $true
            }
        }
    }
})

$guiTimer = New-Object System.Windows.Forms.Timer
$guiTimer.Interval = 50
$guiTimer.Add_Tick({
    if ($script:Sw.IsRunning) {
        $timerLbl.Text = "$([math]::Round($script:Sw.Elapsed.TotalSeconds, 1))s"
    }
})

$searchBtn.Add_Click({ Perform-Search })

$searchTb.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        Perform-Search
        $e.SuppressKeyPress = $true
    }
})

$statusLbl.Text = if ($script:IsRu) { "  Загрузка..." } else { "  Loading..." }
$statusLbl.ForeColor = $script:C.TextDim

$form.Add_Shown({
    [System.Windows.Forms.Application]::DoEvents()

    Load-Data
    Log-Debug $(if ($script:IsRu) { "Приложение запущено. Язык: $Lang" } else { "Application started. Language: $Lang" })
    
    if (-not [string]::IsNullOrEmpty($AppName)) {
        Log-Debug $(if ($script:IsRu) { "Автозапуск поиска для: $AppName" } else { "Auto-search triggered for: $AppName" })
        $searchTb.Text = $AppName
        Perform-Search
    }
})

[void]$form.ShowDialog()