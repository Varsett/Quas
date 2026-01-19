@ECHO OFF
REM  QBFC Project Options Begin
REM HasVersionInfo: Yes
REM Companyname: 
REM Productname: QUest ADB Scripts
REM Filedescription: Russian version
REM Copyrights: Varset
REM Trademarks: 
REM Originalname: Quas
REM Comments: 
REM Productversion:  6. 0. 0. 0
REM Fileversion:  0. 0. 0. 0
REM Internalname: 
REM ExeType: consoleold
REM Architecture: x64
REM Appicon: 
REM AdministratorManifest: No
REM  QBFC Project Options End
@ECHO ON


@if /i [%1]==[v] (set "verbecho=echo on") else (set "verbecho=echo off")
@%verbecho%
:_NormalStart
rem @echo off

rem @set myfiles=d:\Quest2\adb
rem @set myfiles=%~dp0Source
@mode con:cols=100 lines=52
@color 07

@set cp=utf
::@set cp=oem

@call :_%cp%
%codepage% 1>nul

rem call :_SetColours

@echo.
rem StartRusTextBlock
@echo  ADB запускается...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ADB is starting..
rem EndEngTextBlock
rem setlocal enabledelayedexpansion
rem call :_CheckInitialStatusKey
if /i [%1]==[a] set right=1 && goto _adminright
if /i [%1]==[u] set right=2 && goto _userright 
if /i [%1]==[c] set right=3 && goto _uacright
if /i [%1]==[h] call :_ShowAllUndocCommands
if /i [%1]==[d] goto _DiagInformation
if /i [%1]==[b] set s=NO&& goto _beginn
if /i [%1]==[f] call :_TaskkillADB

echo %1 | findstr /i "qq" >nul && call :_ExtractListNumber %1&& goto _BackupListsQCommandLine

rem (call :_CheckInitialStatusKey) else (call :_CheckInitialStatusKey)
call :_CheckInitialStatusKey
if [%1]==[] goto :_tabBegin

:_tabBegin
goto _tabGeneral

:_beginn
call :_SetColours
call :_hat

:_tabReturn

rem :_tabMenu
rem @color 07
@%verbecho%
@echo.   
rem StartRusTextBlock
@echo            %_fBYellow%ГЛАВНОЕ МЕНЮ%_fReset%
@echo.   
@echo      0.  Выход из программы
@echo.
@echo      1.  Управление обновлениями				
@echo      2.  Отправка строки текста на шлем
@echo      3.  Установка драйверов Meta Quest
@echo      4.  Перезагрузка в разные режимы и информация о текущем
@echo      5.  Создание скриншотов дисплея шлема
@echo      6.  Копирование скриншотов и видео со шлема на ПК
@echo      7.  Подключение шлема "ADB по Wi-Fi"
@echo      8.  Переподключение шлема "ADB по кабелю"
@echo      9.  Подключение шлема как съемного диска
@echo      C.  Cистемная информация
@echo      D.  Диагностическая информация
@echo      E.  Тестирование, диагностика, решение различных проблем
@echo      F.  Дополнительные опции	
@echo      G.  Прошивка шлема и информация о прошивке
@echo      I.  Прогресс скачивания/обновления, установка DNS
@echo      J.  Работа с приложениями
@echo      K.  Установка уровней CPU/GPU 
@echo      L.  Установка нативного RefreshRate и разрешения дисплея
@echo      M.  Управление Oculus Link/Airlink
@echo      N.  Создание ярлыков для копирования файлов и установки приложений
@echo      P.  Корректировка даты, времени и таймзоны в шлеме
@echo      Q.  Архивация и восстановление
@echo      R.  Стрим видеотрансляции на ПК
@echo.
@echo      %_fBCyan%S.  Поиск по опциям меню%_fReset%
@echo      H.  Список расширенных команд и параметров
@echo      W.  Связь с автором
@echo      X.  Открыть консоль cmd
@echo      Y.  Открыть графическую консоль
@echo      Z.  Помощь в решении проблем
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo            %_fBYellow%MAIN MENU%_fReset%
rem @echo. 
rem @echo      0.  Exit from the program
rem @echo.
rem @echo      1.  Updates Management
rem @echo      2.  Sending a text string to the headset
rem @echo      3.  Install Meta Quest drivers
rem @echo      4.  Reboot into different modes and current information
rem @echo      5.  Making screenshots of the headset display
rem @echo      6.  Copying screenshots and videoshots from the headset to the PC
rem @echo      7.  Connecting the headset via "ADB over Wi-Fi"
rem @echo      8.  Reconnecting the headset via "ADB over cable"
rem @echo      9.  Connecting the headset as a removable disk
rem @echo      C.  System information
rem @echo      D.  Diagnostic information
rem @echo      E.  Testing, diagnostics, resolving various issues
rem @echo      F.  Additional options
rem @echo      G.  Headset firmware update and firmware information
rem @echo      I.  Download/update progress, DNS setup
rem @echo      J.  Application management
rem @echo      K.  Setting CPU/GPU levels
rem @echo      L.  Setting native RefreshRate and display resolution
rem @echo      M.  Oculus Link/Airlink management
rem @echo      N.  Creating shortcuts for copying files and installing applications
rem @echo      P.  Adjusting date, time, and timezone on the headset
rem @echo      Q.  Backup and restore
rem @echo      R.  Stream video casting to PC
rem @echo.
rem @echo      %_fBCyan%S.  Search%_fReset%
rem @echo      H.  List of advanced commands and parameters
rem @echo      W.  Contact the author
rem @echo      X.  Open cmd console
rem @echo      Y.  Open ADB console
rem @echo      Z.  Help
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _beginn
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="1" (GOTO _updateservice)
if /i "%choice%"=="2" (GOTO _sendtext)
if /i "%choice%"=="3" (GOTO _InstallMetaQuestDrivers)
if /i "%choice%"=="4" (GOTO _menurestart)
if /i "%choice%"=="5" (GOTO _screenshotmenu)
if /i "%choice%"=="6" (GOTO _scrshcopy)
if /i "%choice%"=="7" (GOTO _adbwifimenu)
if /i "%choice%"=="77" (GOTO _ConnectRandomPort)
if /i "%choice%"=="8" (GOTO _reconnect)
if /i "%choice%"=="9" (GOTO _usbflash)
if /i "%choice%"=="c" (GOTO _syscommenu)
if /i "%choice%"=="d" (GOTO _DiagnosticInformationMenu)
if /i "%choice%"=="e" (GOTO _shellmenu)
if /i "%choice%"=="f" (GOTO _AdditionalOptionsMenu)
if /i "%choice%"=="g" (call :_CyrillicPathCheckAll&&GOTO _fwmenu)
if /i "%choice%"=="gg" (GOTO _fwmenuskip)
if /i "%choice%"=="h" (call :_ShowAllUndocCommands)
if /i "%choice%"=="i" (GOTO _todmenu)
if /i "%choice%"=="j" (GOTO _installmenugen)
if /i "%choice%"=="k" (GOTO _menugpucpu)
if /i "%choice%"=="l" (GOTO _resolutionfix)
if /i "%choice%"=="m" (GOTO _oculuslink)
if /i "%choice%"=="n" (GOTO _qctprocedure)
if /i "%choice%"=="p" (GOTO _datetime)
if /i "%choice%"=="q" (GOTO _BackupAndRestoreMenu)
if /i "%choice:~0,2%"=="qq" (goto _BackupListsQ)
if /i "%choice%"=="pt" (cls && GOTO _WiFiTestCSVAnalyzer)
if /i "%choice%"=="r" (GOTO _streamingmenu)
if /i "%choice%"=="st" (GOTO _ServiceTools)
if /i "%choice%"=="s" (GOTO _searchmenuoption)
if /i "%choice%"=="w" (GOTO _contactauthor)
if /i "%choice%"=="y" (GOTO _openshellgui)
if /i "%choice%"=="x" (GOTO _opencmd)
if /i "%choice%"=="z" (GOTO _helplinksmenu)
:: Egg
if /i "%choice%"=="449" (GOTO _449info)
if /i "%choice%"=="103" (GOTO _103info)
if /i "%choice%"=="adbe" (GOTO _onlyadbintegration)
if /i "%choice%"=="adbi" (GOTO _adbintegration)
if /i "%choice%"=="adbd" (GOTO _desadbintegration)


@cls
goto _beginn

:_searchmenuoption
cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo   Поиск производится в названиях всех меню и всех опций в программе %_fBYellow%Quas%_fReset%.
@echo   Он регистронезависимый и может искать по подстроке, то есть по части слова.
@echo.
@echo   Например, если вы хотите найти все опции меню, в которых есть слово "%_fBYellow%Приложение%_fReset%",
@echo   достаточно ввести часть слова: "%_fBYellow%прилож%_fReset%" без кавычек. Результат будет показан на экране.
@echo   Он содержит путь, по которому нужно пройти, чтобы добраться до нужной опции.
@echo.
@echo   Например, если вы видите такую строку:
@echo.
@echo      %_fBCyan%E ^> P ^> F ^| Работа с файрволлом при ошибке Bad file descriptor%_fReset%
@echo.
@echo   то чтобы добраться до пункта %_fBYellow%Работа с файрволлом при ошибке Bad file descriptor%_fReset%
@echo   следует из %_fBYellow%Главного меню%_fReset% нажать пункт %_fBYellow%E%_fReset%, затем %_fBYellow%Enter%_fReset%, потом %_fBYellow%P%_fReset% и %_fBYellow%Enter%_fReset%, и наконец %_fBYellow%F%_fReset% и %_fBYellow%Enter%_fReset%.
@echo.
@echo   Для отмены поиска введите три двоеточия подряд %_fBYellow%:::%_fReset%
@echo.
@echo   Чтобы вывести в файл полную структуру меню, не вводите ничего, а просто нажмите %_fBYellow%Enter%_fReset%
@echo.
@echo.
set "menusearch="
set menutxt=menurus.txt
set /p menusearch=" Введите строку для поиска: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   The search is performed across all menu names and all options in the %_fBYellow%Quas%_fReset% program.
rem @echo   It is case-insensitive and works by substring matching, meaning you can search by part of a word.
rem @echo.
rem @echo   For example, if you want to find all menu options that contain the word "%_fBYellow%Application%_fReset%",
rem @echo   just type part of the word: "%_fBYellow%appl%_fReset%" without quotes. The result will be shown on the screen.
rem @echo   It contains the navigation path you need to follow to reach the desired option.
rem @echo.
rem @echo   For example, if you see a line like this:
rem @echo.
rem @echo      %_fCyan%E ^> P ^> F ^| Working with firewall on Bad file descriptor error%_fReset%
rem @echo.
rem @echo   then to reach the option %_fBYellow%Working with firewall on Bad file descriptor error%_fReset%
rem @echo   you should go from the %_fBYellow%Main Menu%_fReset%, press %_fBYellow%E%_fReset%, then %_fBYellow%Enter%_fReset%, then %_fBYellow%P%_fReset% and %_fBYellow%Enter%_fReset%, and finally %_fBYellow%F%_fReset% and %_fBYellow%Enter%_fReset%.
rem @echo.
rem @echo   To cancel the search, enter three colons in a row %_fBYellow%:::%_fReset%
rem @echo.
rem @echo   To export the full menu structure to a file, just press %_fBYellow%Enter%_fReset% without typing anything.
rem @echo.
rem @echo.
rem set "menusearch="
rem set menutxt=menueng.txt
rem set /p menusearch=" Enter search string: "
rem EndEngTextBlock
cls
@echo.
if "%menusearch%"==":::" goto _beginn
if not defined menusearch (
@echo.
@echo.
rem StartRusTextBlock
@echo   %_fBYellow%Полная структура меню сохранена в файл %_fYellow%menu_export.txt%_fReset%
) else (
@echo      %_fBYellow%Результаты поиска по "%_fYellow%%menusearch%%_fBYellow%":%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%The full menu structure has been saved to the file %_fYellow%menu_export.txt%_fReset%
rem ) else (
rem @echo      %_fBYellow%Search results for "%_fYellow%%menusearch%%_fBYellow%":%_fReset%
rem EndEngTextBlock
)
@echo.
powershell -ExecutionPolicy Bypass -File %myfiles%\searchmenu.ps1 -MenuFile "%myfiles%\%menutxt%" -Query "%menusearch%"
@echo  --------------------------------------------------------
call :_returnmenu
goto _beginn



:_BackupAndRestoreMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ АРХИВАЦИИ И ВОССТАНОВЛЕНИЯ 
@echo        ===============================
@echo.
@echo.
@echo    A.  Меню архивации приложений
@echo    B.  Меню восстановления данных приложений	
@echo    C.  Меню сохранения файлов приложений	
@echo.
@echo    F.  Показать и создать список приложений
@echo    G.  Извлечение данных из файла бэкапа		
@echo    I.  Убрать запрет доступа к файлам сохранений		[EXPERIMENTAL]
@echo    J.  Установить постоянный каталог для бэкапов
@echo    K.  Включить датчик приближения
@echo    l.  Копирование или перемещение выбранных архивов в отдельный подкаталог
@echo.
@echo    %_fBYellow%H. Описание функций этого меню%_fReset%
@echo    %_fBYellow%R. Помощь по переносу сохранений%_fReset%
@echo.
@echo.
@echo.
@echo.
@echo   %_fBGreen%ОЧЕНЬ ВАЖНО: Во время бэкапа и восстановления датчик приближения будет ОТКЛЮЧЕН^^!%_fReset%
@echo                %_fBYellow%Это значит что экран шлема будет постоянно включен пока выполняется действие.
@echo                После завершения датчик будет снова включен.%_fReset%
@echo.
@echo   %_fBGreen%ПОЭТОМУ:%_fReset%     %_fBYellow%Не прерывайте процесс. А если он все-таки прервался, включите датчик
@echo                вручную, из этого меню, пункт %_fYellow%K%_fReset%
@echo.
@echo                %_fBYellow%Также очень желательно перезагрузить шлем перед архивацией или восстановлением.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        BACKUP AND RESTORIG MENU
rem @echo        ========================
rem @echo.
rem @echo.
rem @echo    A.  Backup Application Menu                     [EXPERIMENTAL]
rem @echo    B.  Restore Applications Data Menu            [EXPERIMENTAL]
rem @echo    C.  Applications File Save Menu            [EXPERIMENTAL]
rem @echo.
rem @echo    F.  Create applications list
rem @echo    G.  Extract data from a backup file
rem @echo    I.  Remove the restriction on access to save files	[EXPERIMENTAL]
rem @echo    J.  Set a permanent backup directory
rem @echo    K.  Enable the proximity sensor
rem @echo    l.  Copying or moving the selected archives into a separate subfolder
rem @echo.
rem @echo    %_fBYellow%H. Description of the functions of this menu%_fReset%
rem @echo    %_fBYellow%R. Help on Transferring Saves%_fReset%
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo   %_fBRed%VERY IMPORTANT: During backup and restore, the proximity sensor will be DISABLED^!%_fReset%
rem @echo                   %_fBYellow%This means the headset screen will remain constantly on while the operation
rem @echo                   is in progress. After completion, the sensor will be enabled again.%_fReset%
rem @echo.
rem @echo   %_fBRed%THEREFORE:%_fReset%      %_fBYellow%Do not interrupt the process. If it does get interrupted,
rem @echo                   manually enable the sensor from this menu, option %_fYellow%K%_fReset%.
rem EndEngTextBlock
@echo.
@echo.
@echo.
set searchmark=
call :_MenuChoiceEnter
@echo.
if not defined choice goto _BackupAndRestoreMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _BackupMenu)
if /i "%choice%"=="b" (GOTO _RestoreMenu)
if /i "%choice%"=="c" (GOTO _SaveDataMenu)
if /i "%choice%"=="f" (GOTO _CreateListForBackups)
if /i "%choice%"=="fa" (set appsmark=1&&GOTO _CreateListForBackups)

if /i "%choice%"=="g" (set extractmark=1&&set vbfl=1&&goto _RestoreMainProcedure)
if /i "%choice%"=="gf" (set searchmark=1&&set extractmark=1&&set vbfl=1&&goto _RestoreMainProcedure)

if /i "%choice%"=="i" (goto _AppDataReadWriteBackup)
if /i "%choice%"=="j" (set backupmenureturn=1&& goto _setbackupsdirkey)
if /i "%choice%"=="k" (goto :_ProximitySensorOn)
if /i "%choice%"=="l" (set searchmark=1&& goto :_CopyMoveToSelectedBackup)
if /i "%choice%"=="ls" (goto :_CopyMoveToSelectedBackup)

if /i "%choice%"=="t" (GOTO _testpsfilefolder)
if /i "%choice%"=="h" (call :_BackupRestoreMainMenuHelp)

if /i "%choice%"=="r" (call :_RelocateSaveData)
goto _BackupAndRestoreMenu


:_ProximitySensorOn
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
call :_erlvl
@echo ======================================== 
@If %ERRORLEVEL% EQU 1 GOTO _errlevel
rem StartRusTextBlock
@echo  Датчик приближения включен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Proximity sensor enabled
rem EndEngTextBlock
call :_prevmenu
goto _BackupAndRestoreMenu


:_BackupRestoreMainMenuHelp
cls
@echo.       
rem StartRusTextBlock
@echo        %_fBYellow%МЕНЮ АРХИВАЦИИ И ВОССТАНОВЛЕНИЯ%_fReset%
@echo       ---------------------------------
@echo.       
@echo   %_fBGreen%Опция "Меню архивации приложений"%_fReset% содержит функции создания бэкапов данных приложений
@echo.       
@echo   %_fBGreen%Опция "Меню восстановления данных приложений"%_fReset% предназачена для восстановления данных приложений
@echo.       
@echo   %_fBGreen%Опция "Меню сохранения файлов приложений"%_fReset% позволит сохранить файлы данных, apk и obb файлы
@echo.       
@echo   %_fBGreen%Опция "Показать и создать список приложений"%_fReset% позволит сохранить в файл список названий пакетов
@echo   для выбранных приложений из желаемой категории (Системные, Неофициальные и т.д.) Эту опцию 
@echo   удобно использовать для создания файла %_fBYellow%ListForBackups.txt%_fReset%. Чтобы создать список приложений
@echo   с именами и названиями пакетов, этот пункт следует выбирать двумя буквами, вот так: %_fBYellow%fa%_fReset%
@echo.
@echo   %_fBGreen%Опция "Извлечение данных из файла бэкапа"%_fReset% распаковывает файлы бэкапа и извлекает содержимое
@echo   в каталог для бэкапов с подкаталогами по именам файлов бэкапов. 
@echo   %_fBYellow%Перед использованием этой опции шлем должен быть подключен к ПК%_fReset%.
@echo.
@echo   %_fBGreen%Опция "Убрать запрет доступа к файлам сохранений"%_fReset% снимает ограничения на чтение и запись
@echo   по ADB файлов сохранений в каталоге шлема %_fBYellow%Android/data.
@echo.       
@echo   %_fBGreen%Опция "Установить постоянный каталог для бэкапов"%_fReset% позволяет прописать в реестр каталог, куда
@echo   будут сохраняться бэкапы и где будет выполняться поиск бэкапов для их восстановления.
@echo.       
@echo   %_fBGreen%Опция "Включить датчик приближения"%_fReset% просто включает датчик приближения, если процесс бэкапа
@echo   или восстановления был прерван.
@echo.       
@echo   %_fBGreen%Опция "Копирование или перемещение выбранных архивов в отдельный подкаталог"%_fReset% скопирует или
@echo   переместит выбранные архивы в подкаталог %_fBYellow%SelectedBackups%_fReset% текущего каталога бэкапов.
@echo   При этом к имени файла будет добавлена дата создания архива. Эту опцию удобно использовать
@echo   для сохранения %_fBYellow%только избранных и актуальных бэкапов%_fReset% с последующим удаленим всех остальных,
@echo   когда их накопится достаточно много и они станут не нужны.
@echo   По умолчанию используется мгновенный поиск архивов, но если требуется тщательный,
@echo   с выводом названий пакетов, эту опцию выбирайте так: %_fBYellow%ls%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fBYellow%BACKUP AND RESTORE MENU%_fReset%
rem @echo       ---------------------------------
rem @echo.       
rem @echo   %_fBGreen%The "Application Backup Menu" option%_fReset% contains functions for creating backups of application data
rem @echo.       
rem @echo   %_fBGreen%The "Application Data Restore Menu" option%_fReset% is intended for restoring application data
rem @echo.       
rem @echo   %_fBGreen%The "Application File Save Menu" option%_fReset% allows you to save data files, APK files, and OBB files
rem @echo.       
rem @echo   %_fBGreen%The "Show and create application list" option%_fReset% allows you to save a list of package names
rem @echo   for selected applications from the desired category (System, Unofficial, etc.). This option
rem @echo   is convenient for creating the %_fBYellow%ListForBackups.txt%_fReset% file. To create a list of applications
rem @echo   with app names and package names, this item should be selected with two letters, like this: %_fBYellow%fa%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Extract data from a backup file" option%_fReset% unpacks backup files and extracts their contents
rem @echo   into the backup directory with subdirectories named after the backup files.
rem @echo   %_fBYellow%Before using this option, the headset must be connected to the PC%_fReset%.
rem @echo.
rem @echo   %_fBGreen%The "Remove restriction on access to save files" option%_fReset% removes read and write restrictions
rem @echo   via ADB for save files in the headset directory %_fBYellow%Android/data.
rem @echo.       
rem @echo   %_fBGreen%The "Set a permanent backup directory" option%_fReset% allows you to write a directory to the registry
rem @echo   where backups will be saved and where backups will be searched for restoration.
rem @echo.       
rem @echo   %_fBGreen%The "Enable proximity sensor" option%_fReset% simply enables the proximity sensor if the backup
rem @echo   or restore process was interrupted.
rem @echo.       
rem @echo   %_fBGreen%The option "Copying or moving the selected archives into a separate subfolder"%_fReset% will copy or
rem @echo   move the selected archives into the %_fBYellow%SelectedBackups%_fReset% subfolder of the current backups directory.
rem @echo   In this case, the archive creation date will be added to the file name. This option is convenient
rem @echo   for keeping %_fBYellow%only selected and up-to-date backups%_fReset% with subsequent deletion of all the others,
rem @echo   when they accumulate in sufficient quantity and are no longer needed.
rem @echo   By default, instant archive search is used, but if a thorough search is required,
rem @echo   with package names displayed, select this option as follows: %_fBYellow%ls%_fReset%
rem EndEngTextBlock
@echo.       
call :_exitwindow
exit /b


:_SaveDataHelp
cls
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        %_fBYellow%ПОМОЩЬ ПО СОХРАНЕНИЮ ФАЙЛОВ%_fReset%
@echo       --------------------------------
@echo.
@echo   %_fBGreen%Опция "Сохранение APK"%_fReset% извлекает только %_fBYellow%APK%_fReset% на ПК.
@echo.
@echo   %_fBGreen%Опция "Сохранение APK+OBB"%_fReset% извлекает и копирует на ПК файлы %_fBYellow%APK и OBB%_fReset%
@echo.
@echo   %_fBGreen%Опция "Копирование данных"%_fReset% извлекает игровые данные точно так же, как и в случае %_fBGreen%Полного бэкапа%_fReset%.
@echo.
@echo   %_fBGreen%Опция "Полное сохранение приложений (APK+OBB+DATA)"%_fReset% извлекает из шлема %_fBYellow%APK, OBB и DATA%_fReset% файлы
@echo   и копирует их на ПК. Данные копируются напрямую из каталога %_fBYellow%Android/data%_fReset%. При невозможности
@echo   скопировать их "как есть", программа использует расширенный алгоритм извлечения
@echo   и копирования данных.
@echo.
@echo.
@echo      %_fBYellow%ВАЖНО:%_fReset%
@echo.
@echo   Сохранение файлов - это не бэкап, как таковой. Оно предназначено, в частности, для извлечения
@echo   файлов приложений со шлема и сохранении их на ПК. Проще говоря для создания %_fBYellow%дистрибутива
@echo   приложения%_fReset%. Копирование данных может понадобиться для последующего ручного восстановления
@echo   на шлем в каталог %_fBYellow%Android/data%_fReset%.
@echo.
@echo   Для полноценного бэкапа данных используйте %_fBYellow%Меню архивации приложений%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fBYellow%FILE SAVE HELP%_fReset%
rem @echo       --------------------------------
rem @echo.
rem @echo   %_fBGreen%The "Save APK" option%_fReset% extracts only the %_fBYellow%APK%_fReset% to the PC.
rem @echo.
rem @echo   %_fBGreen%The "Save APK+OBB" option%_fReset% extracts and copies the %_fBYellow%APK and OBB%_fReset% files to the PC.
rem @echo.
rem @echo   %_fBGreen%The "Copy data" option%_fReset% extracts game data in exactly the same way as in the %_fBGreen%Full backup%_fReset% case.
rem @echo.
rem @echo   %_fBGreen%The "Full application save (APK+OBB+DATA)" option%_fReset% extracts %_fBYellow%APK, OBB, and DATA%_fReset% files from the
rem @echo   headset and copies them to the PC. Data is copied directly from the %_fBYellow%Android/data%_fReset% directory.
rem @echo   If it is not possible to copy them "as is", the program uses an alternative method
rem @echo   of extracting and copying the data.
rem @echo.
rem @echo.
rem @echo      %_fBYellow%IMPORTANT:%_fReset%
rem @echo.
rem @echo   Saving files is not a backup as such. It is intended, among other things, for extracting
rem @echo   application files from the headset and saving them to the PC. Simply put, for creating
rem @echo   an application %_fBYellow%distribution package%_fReset%. Copying data may be required for
rem @echo   subsequent manual restoration to the headset into the %_fBYellow%Android/data%_fReset% directory.
rem @echo.
rem @echo   For a full data backup, use the %_fBYellow%Application Backup Menu%_fReset%
rem EndEngTextBlock
@echo.
@echo.
call :_exitwindow
exit /b



:_BackupHelp
cls
@echo.
rem StartRusTextBlock
@echo        %_fBYellow%ПОМОЩЬ ПО АРХИВАЦИИ%_fReset%
@echo       ---------------------
@echo.
@echo   Этот раздел предназначен для архивации данных приложений, в которых хранятся сохранения игр,
@echo   настройки и другая информация о приложении. Здесь вы сможете забэкапить эти
@echo   данные для каждого приложения и впоследствии восстановить их, например, после сброса шлема
@echo   до заводских настроек. Таким образом ваши сохранения и настройки не потеряются.
@echo   %_fBRed%Если файлы данных не содержат сохранений или они лежат в другом месте - бэкап не сохранит их%_fReset%.
@echo   Список таких приложений сохранится в файл %_fBYellow%ZeroSizeBackups.txt%_fReset%.
@echo   Для архивации используется встроенный механизм Android.
@echo.
@echo   %_fBGreen%Опция "Архивация по выбору"%_fReset% выведет весь список приложений из выбранной категории (%_fBYellow%Системные,
@echo   Неофициальные%_fReset% и т.д.). После этого выберите нужные приложения в специальном окне, отмечая их
@echo   галками, и они будут заархивированы. В этом окне также работает поиск, по нему можно
@echo   отфильтровать приложения по имени или названию пакета. Все архивы помещаются в каталог,
@echo   постоянной архивации, если он настроен в реестре, или в каталог %_fBYellow%Backups%_fReset% рядом с программой,
@echo   с подкаталогом текущей даты и времени. Имена архивов будут такими же, как и имена приложений.
@echo   Если такого каталога не существует, он будет создан.
@echo.       
@echo   %_fBGreen%Опция "Архивация по списку"%_fReset% позволяет делать выборочную архивацию, для определенных приложений. 
@echo   Для этого создайте текстовый файл с именем %_fBYellow%ListForBackups.txt%_fReset% и запишите в него названия
@echo   пакетов приложений, по одному в каждой строке, например:
@echo.       
@echo   %_fCyan%com.Armature.VR4
@echo   com.BlueBrainGames.TheHouseofDaVinciVR
@echo   com.fallen.manorquest%_fReset%
@echo.       
@echo   %_fBYellow%Архивы будут созданы только для приложений, перечисленных в файле ListForBackups.txt.%_fReset%
@echo   Вы можете создать несколько списков (количество не ограничено) для разных приложений и условий
@echo   бэкапа. Для этого в начале имени файла укажите номер, по которому будете идентифицировать
@echo   именно этот список,например: %_fCyan%34%_fBYellow%ListForBackups.txt%_fReset%. После выбора опции %_fBGreen%"Архивация по списку"%_fReset%
@echo   программа попросит вас ввести номер списка. Введите число в начале файла %_fBYellow%ListForBackups.txt%_fReset%,
@echo   в данном случае это %_fCyan%34%_fReset%, и забэкапятся только приложения именно из этого списка.
@echo   Или просто нажмите Enter и тогда будет использован файл по умолчанию: %_fBYellow%ListForBackups.txt%_fReset%
@echo   Для ускорения бэкапа можно из Главного меню ввести команду %_fBYellow%qq%_fCyan%номер_списка%_fReset%, для данного примера
@echo   это будет команда %_fBYellow%qq%_fCyan%34%_fReset% и сразу начнется процедура бэкапа по этому списку.
@echo   Список можно очень быстро корректировать - если перед названием пакета поставить символ %_fBYellow%#%_fReset%,
@echo   то это приложение не будет архивироваться.
@echo.       
@echo   %_fBGreen%Опция "Архивация всех приложений"%_fReset% предназначена для быстрого создания бэкапов всех неофициальных
@echo   приложений. После выбора и подтверждения этой опции начнется создание бэкапа данных всех
@echo   установленных на шлеме приложений. Это полезно при миграции с одного шлема на другой.
@echo.
@echo   %_fBGreen%Опция "Архивация только приложений с данными"%_fReset% выводит список только тех приложений, у которых
@echo   есть какие-то данные. Это значительно сокращает время архивации.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fBYellow%BACKUP HELP%_fReset%
rem @echo       ---------------------
rem @echo.
rem @echo   This section is intended for backing up application data that contains game saves,
rem @echo   settings, and other application-related information. Here you can back up this
rem @echo   data for each application and later restore it, for example, after resetting the headset
rem @echo   to factory settings. This way, your saves and settings will not be lost.
rem @echo   %_fBRed%If the data files do not contain saves or are located elsewhere, the backup will not include them%_fReset%.
rem @echo   A list of such applications will be saved to the %_fBYellow%ZeroSizeBackups.txt%_fReset% file.
rem @echo   The built-in Android mechanism is used for backup.
rem @echo.
rem @echo   %_fBGreen%The "Selective backup" option%_fReset% will display the full list of applications from the selected
rem @echo   category (%_fBYellow%System, Unofficial%_fReset%, etc.). After that, select the required applications in a special
rem @echo   window by checking them, and they will be backed up. Search also works in this window, allowing
rem @echo   you to filter applications by name or package name. All backups are placed into the permanent
rem @echo   backup directory if it is configured in the registry, or into the %_fBYellow%Backups%_fReset% directory next to the
rem @echo   program, with a subdirectory named by the current date and time. Archive names will be
rem @echo   the same as the application names. If such a directory does not exist, it will be created.
rem @echo.       
rem @echo   %_fBGreen%The "Backup by list" option%_fReset% allows selective backup for specific applications.
rem @echo   To do this, create a text file named %_fBYellow%ListForBackups.txt%_fReset% and write the application
rem @echo   package names into it, one per line, for example:
rem @echo.       
rem @echo   %_fCyan%com.Armature.VR4
rem @echo   com.BlueBrainGames.TheHouseofDaVinciVR
rem @echo   com.fallen.manorquest%_fReset%
rem @echo.       
rem @echo   %_fBYellow%Backups will be created only for the applications listed in the ListForBackups.txt file.%_fReset%
rem @echo   You can create multiple lists (the number is not limited) for different applications and backup
rem @echo   conditions. To do this, specify a number at the beginning of the file name that you will use
rem @echo   to identify this particular list, for example: %_fCyan%34%_fBYellow%ListForBackups.txt%_fReset%.
rem @echo   After selecting the %_fBGreen%"Backup by list"%_fReset% option, the program will ask you to enter the list number.
rem @echo   Enter the number at the beginning of the %_fBYellow%ListForBackups.txt%_fReset% file,
rem @echo   in this case it is %_fCyan%34%_fReset%, and only the applications from this list will be backed up.
rem @echo   Or simply press Enter, and the default file will be used: %_fBYellow%ListForBackups.txt%_fReset%
rem @echo   To speed up the backup, you can enter the command %_fBYellow%qq%_fCyan%list_number%_fReset% from the Main Menu;
rem @echo   for this example, it would be %_fBYellow%qq%_fCyan%34%_fReset%, and the backup procedure for this list will start immediately.
rem @echo   The list can be edited very quickly — if you put the %_fBYellow%#%_fReset% symbol before a package name,
rem @echo   that application will not be backed up.
rem @echo.       
rem @echo   %_fBGreen%The "Backup all applications" option%_fReset% is intended for quickly creating backups of all unofficial
rem @echo   applications. After selecting and confirming this option, the backup of data for all applications
rem @echo   installed on the headset will begin. This is useful when migrating from one headset to another.
rem @echo.
rem @echo   %_fBGreen%The "Backup only applications with data" option%_fReset% displays only those applications
rem @echo   that have data. This significantly reduces the backup time.
rem EndEngTextBlock
@echo.
call :_exitwindow
exit /b


:_RelocateSaveData
cls
@echo.
@echo.       
@echo.
rem StartRusTextBlock
@echo      %_fBYellow%КАК ПЕРЕНЕСТИ СОХРАНЕНИЯ НА ДРУГОЙ ШЛЕМ%_fReset%
@echo     -----------------------------------------
@echo.
@echo   Обычный бэкап и восстановление удобны, но только в том случае, если пакеты приложений 
@echo   на разных шлемах называются одинаково. В этом случае просто используйте опции 
@echo   %_fBGreen%"Архивация всех приложений"%_fReset% и %_fBGreen%"Восстановление данных приложений"%_fReset%. Но как быть, если 
@echo   пакеты называются по-разному, например у обычной версии игры %_fBYellow%Resident Evil 4%_fReset% и локализованной?
@echo   Простое копирование не всегда возможно, иногда файл сохранения недоступен для чтения,
@echo   например у той же %_fBYellow%Resident Evil 4%_fReset%. Но есть обходной путь. 
@echo.
@echo   %_fBGreen%Порядок действий такой:%_fReset%
@echo     --------------------------------------- 
@echo      %_fBYellow%1. Делаем бэкап игры с помощью опции %_fBGreen%Архивация по выбору%_fReset% %_fBYellow%из предыдущего меню.
@echo      2. Используем опцию %_fBGreen%Восстановление данных приложений%_fBYellow% из предыдущего меню.%_fReset%
@echo.  
@echo   Или сразу воспользуйтесь опцией %_fBGreen%"Убрать запрет доступа к файлам сохранений"%_fReset%.
@echo   После этого файл сохранения становится доступным для чтения и его можно скопировать
@echo   любым удобным способом из каталога в шлеме %_fBYellow%Android/data%_fReset%, например, %_fBYellow%Проводником Windows%_fReset%.
@echo.
@echo   Или используйте пункт %_fBGreen%Извлечение данных из файла бэкапа%_fReset% в предыдущем меню. После извлечения 
@echo   в подкаталоге %_fBYellow%Backups%_fReset% текущего каталога (или в том, который вы установили через реестр)
@echo   вы найдете подкаталог с текущей датой и именем бэкапа, в котором будут находиться файлы данных,
@echo   в том числе тот самый файл сохранения. Сберегите его.
@echo.
@echo   А дальше подключаете другой шлем или переустанавливаете игру, играете до момента
@echo   сохранения (будем считать его тестовым) и проделываете ту же самую процедуру из двух пунктов,
@echo   описанную чуть выше. Добираетесь опять же %_fBYellow%Проводником Windows%_fReset% до каталога %_fBYellow%Android/data%_fReset%
@echo   в шлеме, стираете тестовое сохранение и кладете на его место свой сбереженный файл сохранения.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%HOW TO TRANSFER SAVES TO ANOTHER HEADSET%_fReset%
rem @echo     -----------------------------------------
rem @echo.
rem @echo   Regular backup and restore are convenient, but only if the application package names
rem @echo   on both headsets are the same. In this case, simply use the options
rem @echo   %_fBGreen%"Backup all applications"%_fReset% and %_fBGreen%"Restore application data"%_fReset%.
rem @echo   But what if the package names are different, for example, between the standard version
rem @echo   of %_fBYellow%Resident Evil 4%_fReset% and a localized version?
rem @echo   Simple copying is not always possible — sometimes the save file is not readable,
rem @echo   as in the case of %_fBYellow%Resident Evil 4%_fReset%. However, there is a workaround.
rem @echo.
rem @echo   %_fBGreen%The procedure is as follows:%_fReset%
rem @echo     ---------------------------------------
rem @echo      %_fBYellow%1. Create a game backup using the %_fBGreen%Selective backup%_fReset% %_fBYellow%option from the previous menu.
rem @echo      2. Use the %_fBGreen%Restore application data%_fBYellow% option from the previous menu.%_fReset%
rem @echo.
rem @echo   Or simply use the %_fBGreen%"Remove access restriction to save files"%_fReset% option.
rem @echo   After that, the save file becomes readable and can be copied by any convenient method
rem @echo   from the headset directory %_fBYellow%Android/data%_fReset%, for example using the
rem @echo   %_fBYellow%Windows File Explorer%_fReset%.
rem @echo.
rem @echo   Alternatively, use the %_fBGreen%Extract data from backup file%_fReset% option in the previous menu.
rem @echo   After extraction, in the %_fBYellow%Backups%_fReset% subdirectory of the current directory
rem @echo   (or the one you configured in the registry), you will find a subdirectory with the current
rem @echo   date and the backup name. Inside it will be the data files, including the actual save file.
rem @echo   Preserve this file.
rem @echo.
rem @echo   Then connect another headset or reinstall the game, play until a save point
rem @echo   (we will consider it a test save), and perform the same two-step procedure described above.
rem @echo   Again, use the %_fBYellow%Windows File Explorer%_fReset% to navigate to the %_fBYellow%Android/data%_fReset%
rem @echo   directory on the headset, delete the test save, and place your preserved save file in its place.
rem EndEngTextBlock
call :_exitwindow
exit /b


:_RestoreHelp
cls
@echo.       
@echo.
rem StartRusTextBlock
@echo   %_fBGreen%Опция "Стандартное восстановление (тщательное сканирование бэкапов)"%_fReset% выполняет восстановление
@echo   файлов данных приложений. Перед этим будет выполнено сканирование файлов бэкапов из каталога
@echo   архивации, сохраненного в реестре или каталога %_fBYellow%Backups%_fReset%. Если ни один из этих каталогов
@echo   не найдется, программа попросит выбрать каталог с бэкапами вручную. Сканирование бэкапов
@echo   в этой опции покажет название пакета для каждого приложения и проверит - установлено ли
@echo   приложение на шлеме, для которого предназначен бэкап. Если такого приложения нет, этот бэкап
@echo   будет отмечен в окне выбора %_fCyan%синим цветом%_fReset%. Для восстановления следует отметить необходимые
@echo   приложения в окне выбора и нажать кнопку %_fBYellow%Confirm%_fReset%.
@echo.
@echo   В окне выбора работает сортировка по %_fBYellow%Дате, Имени приложения и Названию пакета%_fReset%. Также работает
@echo   контекстный поиск/фильтр в поле %_fBYellow%Search%_fReset%. Для того чтобы отобразить только последние по времени
@echo   бэкапы для каждого приложения, можно нажать кнопку %_fBYellow%Show Latest Only%_fReset%. Надпись на кнопке сменится
@echo   на %_fBYellow%Show All%_fReset%. Соответственно, чтобы отобразить полный список, следует снова на нее нажать.
@echo   Имя приложения или название пакета можно скопировать %_fBYellow%двойным кликом мыши%_fReset% или через %_fBYellow%Ctrl-C%_fReset%.
@echo.
@echo   %_fBGreen%Опция "Стандартное восстановление (мгновенное сканирование бэкапов)"%_fReset% покажет только
@echo   количество найденных бэкапов и выведет их список в окне выбора. Проверка на установленные
@echo   приложения выполнена не будет. В окне выбора отобразятся только названия файлов бэкапов,
@echo   без названий пакетов.
@echo.
@echo   %_fBGreen%Опция "Восстановление с выбором каталога бэкапов вручную"%_fReset% откроет окно выбора каталога,
@echo   где должны быть расположены файлы бэкапов. После выбора каталога нажмите %_fBYellow%Оk%_fReset% в том же окне.
@echo.
@echo   %_fBGreen%Опция "Восстановление с выбором файла бэкапа вручную"%_fReset% откроет окно выбора файла. Выберите
@echo   файл бэкапа и нажмите %_fBYellow%Ok%_fReset% в том же окне. Бэкап будет восстановлен.
@echo.
@echo   %_fBGreen%Опция "Восстановление данных приложений (старый алгоритм)"%_fReset% восстанавливает данные из созданных
@echo   ранее бэкапов. Поместите в каталог программы %_fBYellow%Quas%_fReset% архивы, которые хотите восстановить и выберите
@echo   эту опцию. После выбора программа выведет список найденных бэкапов. 
@echo   %_fBYellow%Внимательно проверьте список перед подтверждением восстановления%_fReset%.
@echo   Имена архивов могут быть какими угодно, главное чтобы расширение было %_fBYellow%ab%_fReset%
@echo   %_fBRed%ВАЖНО: В  этой опции будут восстановлены все архивы, которые программа найдет рядом с собой,
@echo          даже если сами приложения не установлены на шлем.%_fReset%
@echo.
@echo   %_fBYellow%ВНИМАНИЕ: Восстановление бэкапа на только что установленную игру имеет свои особенности^^!%_fReset%
@echo   Как правило, при первом запуске игра компилирует шейдеры или выполняет другую оптимизацию.
@echo   Поэтому восстановление на новую игру желательно выполнять так:
@echo.
@echo      %_fBYellow%1. Запустить игру, дождаться завершение первого запуска
@echo      2. Начать игру и при первой возможности выполнить сохранение или дойти 
@echo         до контрольной точки автосохранения
@echo      3. Выйти из игры%_fReset%
@echo.
@echo   После этого можно делать восстановление из бэкапа. 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%Option "Standard restore (thorough backup scan)"%_fReset% performs restoration of application data files.
rem @echo   Before that, backup files will be scanned in the backup directory saved in the registry or in the
rem @echo   %_fBYellow%Backups%_fReset% directory. If neither of these directories is found, the program will ask you
rem @echo   to manually select a folder with backups. During scanning, this option will display the package
rem @echo   name for each application and check whether the application for which the backup was created
rem @echo   is installed on the headset. If such an application is not installed, that backup will be
rem @echo   marked in the selection window %_fCyan%in blue%_fReset%. To restore, select the required applications in the
rem @echo   selection window and press the %_fBYellow%Confirm%_fReset% button.
rem @echo.
rem @echo   In the selection window, sorting by %_fBYellow%Date, Application Name, and Package Name%_fReset% is available.
rem @echo   Context search/filtering also works in the %_fBYellow%Search%_fReset% field. To display only the most recent
rem @echo   backups for each application, press the %_fBYellow%Show Latest Only%_fReset% button. The button label will
rem @echo   change to %_fBYellow%Show All%_fReset%. Press it again to display the full list. The application name
rem @echo   or package name can be copied by %_fBYellow%double-clicking the mouse%_fReset% or using %_fBYellow%Ctrl-C%_fReset%.
rem @echo.
rem @echo   %_fBGreen%Option "Standard restore (instant backup scan)"%_fReset% will only show the number of backups found and
rem @echo   display their list in the selection window. Installed application checks will not be
rem @echo   performed. The selection window will show only backup file names, without package names.
rem @echo.
rem @echo   %_fBGreen%Option "Restore with manual selection of backup directory"%_fReset% opens a directory selection window
rem @echo   where backup files should be located. After selecting the directory, press %_fBYellow%Ok%_fReset% in the same window.
rem @echo.
rem @echo   %_fBGreen%Option "Restore with manual selection of a backup file"%_fReset% opens a file selection window.
rem @echo   Select a backup file and press %_fBYellow%Ok%_fReset% in the same window. The backup will be restored.
rem @echo.
rem @echo   %_fBGreen%Option "Restore application data (old algorithm)"%_fReset% restores data from backups
rem @echo   created earlier. Place the archives you want to restore into the program directory
rem @echo   %_fBYellow%Quas%_fReset% and select this option. After selection, the program will display
rem @echo   a list of found backups. %_fBYellow%Carefully review the list before confirming the restore%_fReset%.
rem @echo   Archive names may be anything, the only requirement is the %_fBYellow%ab%_fReset% extension.
rem @echo   %_fBRed%IMPORTANT: This option will restore all archives that the program finds next to itself,
rem @echo              even if the corresponding applications are not installed on the headset.%_fReset%
rem @echo.
rem @echo   %_fBYellow%WARNING: Restoring a backup to a freshly installed game has its own specifics^^!%_fReset%
rem @echo   As a rule, during the first launch the game compiles shaders or performs other optimization.
rem @echo   Therefore, restoring to a new game is recommended to be done as follows:
rem @echo.
rem @echo      %_fBYellow%1. Launch the game and wait for the first launch to complete
rem @echo      2. Start the game and, at the first opportunity, create a save or reach
rem @echo         an autosave checkpoint
rem @echo      3. Exit the game%_fReset%
rem @echo.
rem @echo   After that, you can restore from the backup.
rem EndEngTextBlock
call :_exitwindow
exit /b


:_SaveDataMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ СОХРАНЕНИЯ ФАЙЛОВ ПРИЛОЖЕНИЙ
@echo        ================================
@echo.
@echo    A.  Полный бэкап приложений (APK+OBB+DATA)
@echo    B.  Сохранение APK
@echo    C.  Сохранение APK+OBB
@echo    D.  Копирование данных
@echo.
@echo    %_fBYellow%H. Описание функций этого меню%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        APPLICATIONS FILE SAVE MENU
rem @echo        ==========================
rem @echo.
rem @echo    A.  Full apps backup (APK+OBB+DATA)
rem @echo    B.  Save APK
rem @echo    C.  Save APK+OBB
rem @echo    D.  Data copying
rem @echo.
rem @echo    %_fBYellow%H. Description of the functions of this menu%_fReset%
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _SaveDataMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (goto _FullApplicationBackupPS)
if /i "%choice%"=="b" (goto _SaveAPKPS)
if /i "%choice%"=="c" (goto _SaveAPKOBBPS)
if /i "%choice%"=="d" (goto _SaveDATAPS)
if /i "%choice%"=="h" (call :_SaveDataHelp)
if /i "%choice%"=="r" (call :_BackupRelocateHelp)
goto _SaveDataMenu

:_BackupMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ АРХИВАЦИИ
@echo        ==============
@echo.
@echo    A.  Архивация данных по выбору					
@echo    B.  Архивация данных по списку					
@echo    C.  Архивация данных всех приложений				
@echo    D.  Архивация только приложений с данными
@echo.
@echo    %_fBYellow%H. Описание функций этого меню%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         BACKUP MENU
rem @echo        =============
rem @echo.
rem @echo    A.  Selective Backup                     [EXPERIMENTAL]
rem @echo    B.  Backup from List                     [EXPERIMENTAL]
rem @echo    C.  Backup All Applications              [EXPERIMENTAL]
rem @echo    D.  Backup only Applications with data   [EXPERIMENTAL]
rem @echo.
rem @echo    %_fBYellow%H. Description of the functions of this menu%_fReset%
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _BackupMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _BackupChoisesPS)
if /i "%choice%"=="b" (GOTO _EnterListNumber)
if /i "%choice%"=="c" (GOTO _BackupAllAppsQ)
if /i "%choice%"=="d" (GOTO _BackupOnlyAppsWithData)
if /i "%choice%"=="h" (call :_BackupHelp)
if /i "%choice%"=="r" (call :_BackupRelocateHelp)
goto _BackupMenu


:_BackupOnlyAppsWithData
rem StartRusTextBlock
set "action1=бэкапить"
set "action2=бэкапа"
@echo  -----------------------------------------------------------------------------------------
@echo  %_fBYellow%.. Идет подготовка списка, это займет несколько секунд...
@echo.
@echo  В открывшемся окне выберите приложения, которые хотите %action1%. После завершения выбора
@echo  нажмите кнопку %_fYellow%Confirm %_fBYellow%для %action2%. Для отмены нажмите кнопку %_fYellow%Cancel.
@echo.
@echo  %_fBYellow%Для поиска приложений по имени или названию пакета используйте поле в верхней части окна.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to backup"
rem set "action2=backup"
rem @echo  %_fBYellow%.. Preparing the list, this will take a few seconds...
rem @echo.
rem @echo  In the window that opens, select the applications you want %action1%. After making your selection,
rem @echo  click the %_fYellow%Confirm %_fBYellow%button %action2%. To cancel click the %_fYellow%Cancel button.
rem @echo.
rem @echo  %_fBYellow%Use the field at the top of the window to search for applications by name or package name.%_fReset%
rem EndEngTextBlock
@echo  -----------------------------------------------------------------------------------------
set "shscriptname=adl.sh"
call :_MakeAppsDataListSH
@%myfiles%\adb push %myfiles%\aapt-arm-pie2 /data/local/tmp/ 1>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell chmod 0755 /data/local/tmp/aapt-arm-pie2
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >o.txt 2>nul
@del /q /f %shscriptname%  1>nul 2>nul
powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "o.txt" "packages-list.txt"
if not exist packages-list.txt (
@echo.
rem StartRusTextBlock
@echo   %_fYellow%+++  Файлы бэкапов не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No backup files selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto :_BackupAndRestoreMenu
)
rem StartRusTextBlock
set "mess1=%_fYellow%Все игры в этом списке должны быть заархивированы.%_fReset%"
set "mess2=%_fYellow%Если какая-то игра будет пропущена, обязательно сообщите автору Quas%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "mess1=%_fYellow%All games in this list must be archived.%_fReset%"
rem set "mess2=%_fYellow%If any game is skipped, be sure to inform the author of Quas%_fReset%"
rem EndEngTextBlock
call :_BakdirCreate
call %myfiles%\backup.cmd :_BackupChoises
@del /q /f o.txt  1>nul 2>nul
goto _BackupFinishMessage


:_MakeAppsDataListSH
> %shscriptname% echo #!/system/bin/sh
>> %shscriptname% echo aapt^=/data/local/tmp/aapt-arm-pie2
>> %shscriptname% echo pm list packages -3 ^| sed 's/^^^package://g' ^| while read line; do
>> %shscriptname% echo datadir^="/sdcard/Android/data/$line"
>> %shscriptname% echo if [ -d "$datadir" ]; then
>> %shscriptname% echo size^=$(du -s "$datadir" 2^>/dev/null ^| cut -f1)
>> %shscriptname% echo if [ "$size" -gt 0 ] 2^>/dev/null; then
>> %shscriptname% echo path=$(pm path "$line" ^| sed 's/^^^package://g')
>> %shscriptname% echo label=$($aapt d badging "$path" 2^>/dev/null ^| grep "application: label=" ^| cut -d"'" -f2)
>> %shscriptname% echo if [ -n "$label" ]; then
>> %shscriptname% echo printf "%%s;%%s\n" "$label" "$line"
>> %shscriptname% echo else
>> %shscriptname% echo printf "%%s;%%s\n" "$line" "$line"
>> %shscriptname% echo fi
>> %shscriptname% echo fi
>> %shscriptname% echo fi
>> %shscriptname% echo done
exit /b

:_MakeAppsDataListSHVar
> %shscriptname% echo #!/system/bin/sh
>> %shscriptname% echo aapt^=/data/local/tmp/aapt-arm-pie2
>> %shscriptname% echo pm list packages -3 ^| sed 's/^^^package://g' ^| while read line; do
>> %shscriptname% echo datadir^="/sdcard/Android/data/$line"
>> %shscriptname% echo if [ -d "$datadir" ]; then
>> %shscriptname% echo size^=$(du -s "$datadir" 2^>/dev/null ^| cut -f1)
>> %shscriptname% echo if [ "$size" -gt 0 ] 2^>/dev/null; then
>> %shscriptname% echo path=$(pm path "$line" ^| sed 's/^^^package://g')
>> %shscriptname% echo label=$($aapt d badging "$path" 2^>/dev/null ^| grep "application: label=" ^| cut -d"'" -f2)
>> %shscriptname% echo if [ -n "$label" ]; then
>> %shscriptname% echo printf "%%s;%%s\n" "$label" "$line"
>> %shscriptname% echo else
>> %shscriptname% echo printf "%%s;%%s\n" "$line" "$line"
>> %shscriptname% echo fi
>> %shscriptname% echo fi
>> %shscriptname% echo fi
>> %shscriptname% echo done
exit /b


:_RestoreMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ ВОССТАНОВЛЕНИЯ 
@echo        ===================
@echo.
@echo    A.  Стандартное восстановление (тщательное сканирование бэкапов) 
@echo    B.  Стандартное восстановление (мгновенное сканирование бэкапов)
@echo    C.  Восстановление с выбором каталога бэкапов вручную
@echo    D.  Восстановление с выбором файла бэкапа вручную
@echo    E.  Восстановления данных приложений (старый алгоритм)
@echo.
@echo    %_fBYellow%H. Описание функций этого меню%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        RESTORE MENU 
rem @echo        ================
rem @echo.
rem @echo    A.  Standard recovery (thorough backup scan)
rem @echo    B.  Standard recovery (instant backup scan)
rem @echo    C.  Restore with manual backup directory selection
rem @echo    D.  Restore with manual backup file selection
rem @echo    E.  Restore application data (old algorithm)
rem @echo.
rem @echo    %_fBYellow%H. Description of the functions of this menu%_fReset%
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
set fullpathviewkey=
set searchmark=
call :_MenuChoiceEnter
@echo.
if not defined choice goto _RestoreMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (set searchmark=&&GOTO _RestoreMainProcedure)
if /i "%choice%"=="b" (set searchmark=1&&GOTO _RestoreMainProcedure)
if /i "%choice%"=="af" (set fullpathviewkey=-f&&set searchmark=&&GOTO _RestoreMainProcedure)
if /i "%choice%"=="bf" (set fullpathviewkey=-f&&set searchmark=1&&GOTO _RestoreMainProcedure)
if /i "%choice%"=="c" (goto _RestoreWithDirSelection)
if /i "%choice%"=="cs" (set searchmark=1&&goto _RestoreWithDirSelection)
rem if /i "%choice%"=="c" (set retmenu=_RestoreMenu&&call :_SelectiveBackupFolder&&set bakdir=%filefolder%&&goto _ViewBackupFilesList)
if /i "%choice%"=="d" (GOTO _RestoringAloneABFileMenu)
if /i "%choice%"=="e" (GOTO _Restoring)
if /i "%choice%"=="h" (call :_RestoreHelp)
if /i "%choice%"=="t" (call :_TestConf)
goto _RestoreMenu

:_TestConf
set "enterconfirmation=GOTO _beginn"
set "escapeconfirmation=GOTO _beginn"
call :_ActionConfirmationReguest
echo Hm
pause
exit

:_RestoreWithDirSelection
set retmenu=_RestoreMenu
call :_SelectiveBackupFolder
rem echo %filefolder%
rem echo %SelectedFolder%
rem pause
rem set pathmode=folder
rem set BAKDIR=%SelectedFolder%
set bakdir=%filefolder%
rem goto _ViewBackupFilesList
if defined searchmark (GOTO _ViewBackupFilesListNoScan) else (goto _ViewBackupFilesListScan)
rem goto _ViewBackupFilesListScan



:_RestoreHelp_
cls
@echo.
@echo.
rem StartRusTextBlock

rem EndRusTextBlock
rem StartEngTextBlock


rem EndEngTextBlock
@echo.
call :_exitwindow
exit /b



:_CopyMoveToSelectedBackup
set copymarker=1
call :_RestoreMainProcedure
rem StartRusTextBlock
@echo.
@echo.
@echo  -------------------------------------------------------------------
@echo   %_fBYellow%Для %_fYellow%КОПИРОВАНИЯ%_fBYellow% выбранных архивов в подкаталог %_fYellow%SelectedBackups%_fBYellow% нажмите %_fYellow%Enter%_fBYellow%
@echo.
@echo   %_fBYellow%Для %_fYellow%ПЕРЕМЕЩЕНИЯ%_fBYellow% выбранных архивов в подкаталог %_fYellow%SelectedBackups%_fBYellow% нажмите %_fYellow%Пробел%_fBYellow%
@echo  -------------------------------------------------------------------
@echo.
@echo   %_fBYellow%для возврата в меню - %_fYellow%Esc%_fReset%
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
@echo  -------------------------------------------------------------------
rem @echo   %_fBYellow%To %_fYellow%COPY%_fBYellow% the selected archives into the %_fYellow%SelectedBackups%_fBYellow% subfolder, press %_fYellow%Enter%_fBYellow%
rem @echo.
rem @echo   %_fBYellow%To %_fYellow%MOVE%_fBYellow% the selected archives into the %_fYellow%SelectedBackups%_fBYellow% subfolder, press %_fYellow%Space%_fBYellow%
@echo  -------------------------------------------------------------------
rem @echo.
rem @echo   %_fBYellow%to return to the menu — %_fYellow%Esc%_fReset%
rem @echo.
rem @echo.
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto :_BackupAndRestoreMenu
if "!KEY!"=="13" call %myfiles%\backup.cmd :_CopySelectedBackups
if "!KEY!"=="32" set cmmarker=1&& call %myfiles%\backup.cmd :_CopySelectedBackups
del /q /f packages-list.txt 1>nul 2>nul
call :_prevmenu
goto :_BackupAndRestoreMenu



:_RestoreMainProcedure
call :_cdc
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BackupsDir 2^>nul') do set backupsdir=%%a
cls
@echo.
@echo.
@echo  -------------------------------------------------------------------
if defined backupsdir (
rem StartRusTextBlock
@echo   %_fBYellow%Путь к каталогу бэкапов взят из реестра%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%The backup directory path was taken from the registry%_fReset%
rem EndEngTextBlock
rem ) else (
dir /a /b "%backupsdir%" 2>nul | findstr . >nul
if errorlevel 1 (
rem StartRusTextBlock
@echo   %_fYellow%+++  но он пуст или не существует  +++
@echo   %_fBYellow%Скорректируйте запись в реестре или путь к каталогу.%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  but it is empty or does not exist  +++
rem @echo   %_fBYellow%Adjust the registry entry or the directory path.%_fReset%
rem EndEngTextBlock
) else (
set BAKDIR=%backupsdir%

if defined searchmark (GOTO _ViewBackupFilesListNoScan) else (goto _ViewBackupFilesListScan)
)


@echo  ---
dir /a /b "%cd%\Backups" 2>nul | findstr . >nul
if errorlevel 1 (
rem StartRusTextBlock
@echo   %_fYellow%+++  Каталог по умолчанию пуст или не существует  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  The default directory is empty or does not exist  +++%_fReset%
rem EndEngTextBlock
) else (
rem StartRusTextBlock
@echo   %_fBYellow%Используется каталог по умолчанию %_fYellow%%cd%\Backups%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%The default directory %cd%\Backups is being used%_fReset%
rem EndEngTextBlock
set BAKDIR=%cd%\Backups
if defined searchmark (GOTO _ViewBackupFilesListNoScan) else (goto _ViewBackupFilesListScan)
)


@echo  ---
rem StartRusTextBlock
@echo   %_fBRed%+++  Каталоги бэкапов не обнаружены  +++%_fReset%%
@echo.
@echo  -------------------------------------------------------------------
@echo   %_fBYellow%Укажите каталог с бэкапами вручную%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%+++  Backup directories not found  +++%_fReset%
rem @echo.
rem @echo  -------------------------------------------------------------------
rem @echo   %_fBYellow%Specify the backup directory manually%_fReset%
rem EndEngTextBlock
@echo  -------------------------------------------------------------------
set pathmode=folder
call :_SelectFileFolder SelectedFolder
if defined SelectedFolder (
set BAKDIR=%SelectedFolder%
if defined searchmark (GOTO _ViewBackupFilesListNoScan) else (goto _ViewBackupFilesListScan)
)
@echo.
rem StartRusTextBlock
@echo  %_fYellow%+++  Каталог не выбран  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fYellow%+++  No directory selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto :_BackupAndRestoreMenu


:_ViewBackupFilesListScan
if defined  vbfl goto _ViewBackupFilesList
@echo  -------------------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%Идет сканирование каталогов с бэкапами, это займет некоторое время.
@echo   После появления окна отметьте архивы, которые хотите восстановить.
@echo.
@echo   Если будет найден архив для приложения, которое не установлено на шлеме,
@echo   такой архив обозначается в списке %_fCyan%синим цветом.%_fReset%
@echo.
@echo   %_fBYellow%Чтобы отобразить только последние по времени архивы для каждой игры,
@echo   нажмите кнопку %_fYellow%Show Latest Only. %_fBYellow%Отобразить полный список - %_fYellow%Show All%_fReset%
@echo.
@echo   %_fBYellow%В окне выбора работает Поиск и сортировка по имени приложения, названию пакета
@echo   или дате. Для сортировки кликните по шапке списка (поля %_fYellow%Date, App Name, Package%_fReset%)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Scanning backup directories, this may take some time.
rem @echo   After the window appears, select the archives you want to restore.
rem @echo.
rem @echo   If an archive is found for an app that is not installed on the headset,
rem @echo   such an archive is marked in the list in %_fCyan%blue.%_fReset%
rem @echo.
rem @echo   %_fBYellow%To display only the most recent archives for each game,
rem @echo   press the %_fYellow%Show Latest Only%_fBYellow% button. To display the full list – %_fYellow%Show All%_fReset%
rem @echo.
rem @echo   %_fBYellow%In the selection window, search and sorting by application name, package name,
rem @echo   or date are available. To sort, click on the list header (fields %_fYellow%Date, App Name, Package%_fReset%)
rem EndEngTextBlock
goto _ViewBackupFilesList

:_ViewBackupFilesListNoScan
if defined  vbfl goto _ViewBackupFilesList
@echo  -------------------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%Идет сканирование каталогов с бэкапами, это займет  пару секунд.
@echo   После появления окна отметьте архивы, которые хотите восстановить.
@echo.
@echo   %_fBYellow%Чтобы отобразить только последние по времени архивы для каждой игры,
@echo   нажмите кнопку %_fYellow%Show Latest Only. %_fBYellow%Отобразить полный список - %_fYellow%Show All%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Scanning backup directories, this take just a second.
rem @echo   After the window appears, select the archives you want to restore.
rem @echo.
rem @echo   %_fBYellow%To display only the most recent archives for each game,
rem @echo   press the %_fYellow%Show Latest Only%_fBYellow% button. To display the full list – %_fYellow%Show All%_fReset%
rem EndEngTextBlock


:_ViewBackupFilesList
set "OUTFILE=%cd%\backup_list.txt"
del /q /f backup_list.txt 1>nul 2>nul
@echo.
if not defined searchmark (call :_GetABFilesFromDirs) else (call :_GetABFilesFromDirsFast)
rem echo %SelectFolder%
rem echo %filefolder%
rem pause

powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "backup_list.txt" "packages-list.txt" -d %fullpathviewkey%
@del /q /f backup_list.txt 1>nul 2>nul
if not exist packages-list.txt (
@echo.
rem StartRusTextBlock
@echo   %_fYellow%+++  Файлы бэкапов не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No backup files selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto :_BackupAndRestoreMenu
)
if defined copymarker exit /b
if defined extractmark goto _ExtractionMainProcedure
@echo.
@echo  -------------------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения восстановления нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
@echo   %_fBYellow%Перед восстановлением рекомендуется проверить наличие свежих бэкапов%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For restore confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem @echo   %_fBYellow%It is recommended to check for the latest backups before restoring%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto :_BackupAndRestoreMenu
if "!KEY!"=="13" call %myfiles%\backup.cmd :_RestoreApplicationDataABPS

del /q /f packages-list.txt 1>nul 2>nul
rem === Проверка по итогу всех восстановлений ===
if exist RestoreErrors.txt (
    findstr /c:"[ERROR]" RestoreErrors.txt >nul
    if not errorlevel 1 (
@echo.
@echo   ------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBRed%При восстановлении некоторых архивов возникли ошибки^!
@echo   См. подробности в %_fYellow%RestoreErrors.txt
@echo.
@echo   %_fBYellow%Если файл архива содержит спецсимволы, попробуйте удалить их
@echo   или просто переименовать файл, используя обычные латинские буквы.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Errors occurred while restoring some archives^!
rem @echo   See details in %_fYellow%RestoreErrors.txt%_fReset%
rem @echo.
rem @echo   %_fBYellow%If the archive file contains special characters, try removing them
rem @echo   or simply rename the file using Latin characters.%_fReset%
rem EndEngTextBlock
@echo   ------------------------------------------------------
@echo.
rem         pause
rem         goto :AfterRestore
call :_prevmenu
goto :_BackupAndRestoreMenu
)
rem Если нет строк с [ERROR] — значит всё чисто
del RestoreErrors.txt >nul 2>&1
)

@echo   -------------------------------------------------------------------
@echo.
@echo.
@echo        =========================
rem StartRusTextBlock
@echo         %_fBGreen%Восстановление завершено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         %_fBGreen%Restore completed%_fReset%
rem EndEngTextBlock
@echo        =========================
call :_prevmenu
goto :_BackupAndRestoreMenu


:_ExtractionMainProcedure
rem cls
call %myfiles%\backup.cmd :_ExctractDataFromDataFiles
rem pause >nul
goto :_BackupAndRestoreMenu
rem echo Extraction finished
rem pause
rem exit


:_GetABFilesFromDirsFast
echo.
echo.
set "count=0"
for /r "%BAKDIR%" %%F in (*.ab) do (
if %%~zF geq 48 (
set /a count+=1
rem StartRusTextBlock
<nul set /p str="   %_fCyan%Найдено бэкапов: %_fBCyan%!count!%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem <nul set /p str="   %_fCyan%Backups found: %_fBCyan%!count!%_fReset%"
rem EndEngTextBlock
<nul set /p str=""
set "dt=%%~tF"
set "archivename=%%~nF"
echo !dt!;!status!%%~nxF;%%~nxF;%%F>>"%OUTFILE%"

rem echo !dt!;!status!%%F;%%~nxF>>"%OUTFILE%"
rem echo !dt!;!status!%%~nxF;%%~nxF>>"%OUTFILE%"

)
)
@echo.
@echo -------------------------------------------------
rem StartRusTextBlock
@echo %_fBYellow%Сканирование завершено. Выводим список бэкапов.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBYellow%Scanning completed. Displaying the list of backups.%_fReset%
rem EndEngTextBlock
exit /b


:_GetABFilesFromDirs
set "countbak=0"
rem echo %BAKDIR%
rem pause

for /r "%BAKDIR%" %%F in (*.ab) do (
set /a countbak+=1
)

echo.
echo.
call :_SHScriptMaker
rem StartRusTextBlock
@echo %_fBGreen%Найдено бэкапов:  %_fBCyan%!countbak!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBGreen%Backups found:  %_fBCyan%!countbak!%_fReset%
rem EndEngTextBlock
set "count=0"
for /r "%BAKDIR%" %%F in (*.ab) do (
if %%~zF geq 48 (
set /a count+=1
rem StartRusTextBlock
<nul set /p str="%_fCyan%Сканируем бэкапы: %_fBCyan%!count!%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem <nul set /p str="%_fCyan%Scanning backups: %_fBCyan%!count!%_fReset%"
rem EndEngTextBlock
<nul set /p str=""
set "dt=%%~tF"
set "archivename=%%~nF"
set "fullpath=%%F"

%myfiles%\adb push "!fullpath!" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%scriptn% '/data/local/tmp/!archivename!.ab' 1>nul 2>nul
rem if errorlevel 1
set "LOG=%TEMP%\pkg_!RANDOM!.txt"
%myfiles%\adb shell "ls -1t /data/local/tmp/apps | head -n 1" > "!LOG!" 2>nul
set "pkg="
for /f "usebackq delims=" %%k in ("!LOG!") do set "pkg=%%k"
@del /q /f "!LOG!" 1>nul 2>nul

if defined pkg (
set "viewpackagename=!pkg!"
) else (
set "viewpackagename="
)

rem === Проверяем, установлено ли приложение ===
set "pkgpath="
for /f "delims=" %%P in ('%myfiles%\adb shell pm path !pkg! 2^>nul') do set "pkgpath=%%P"
if defined pkgpath (
set "status="
) else (
set "status=##"
)

rem ) else (
rem set "viewpackagename="
rem set "status="
rem )

rem echo !dt!;!status!%%F;!viewpackagename!>>"%OUTFILE%"

echo !dt!;!status!%%~nxF;!viewpackagename!;%%F>>"%OUTFILE%"

%myfiles%\adb shell "rm -f /data/local/tmp/!archivename!.ab" 1>nul 2>nul
%myfiles%\adb shell "rm -rf /data/local/tmp/apps/*" 1>nul 2>nul
)
)
rem )
@del /q /f %scriptn% 1>nul 2>nul
@echo.
@echo -------------------------------------------------
rem StartRusTextBlock
@echo %_fBYellow%Сканирование завершено. Выводим список бэкапов.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBYellow%Scanning completed. Displaying the list of backups.%_fReset%
rem EndEngTextBlock
exit /b


:_RestoringAloneABFileMenu
setlocal enableextensions enabledelayedexpansion
set "backupabfile=c"
rem StartRusTextBlock
@echo.
@echo ---------------------------
@Set /p backupabfile="Бросьте сюда файл архива ab или нажмите Enter для выбора файла на ПК >>> "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p backupabfile="Drop the ab archive file here or type C to select a file on the PC and press Enter >>> "
rem EndEngTextBlock
@echo.
rem echo %backupabfile%
rem echo !backupabfile!
rem pause
set "backupabfile=%backupabfile:"=%"
if /i "%backupabfile%"=="0" (goto _RestoreMenu)
if /i "%backupabfile%"=="m" (GOTO _beginn)
if /i "%backupabfile%"=="c" (
set pathmode=file
call :_SelectFileFolder
set "backupabfile=!SelectedFile!"
)
rem echo %SelectedFile%
rem echo !SelectedFile!
rem echo %backupabfile%
rem echo !backupabfile!
rem pause
For %%v In ("%backupabfile%") Do ( 
Set "fullpath=%%~dpv"
@set extens=%%~xv
@set "archivename=%%~xnv"
)
if "!extens!"==".ab" set "doAb=1"

rem echo f !fullpath!
rem echo f %fullpath%
rem echo e !extens!
rem echo e %extens%
rem echo a !archivename!
rem echo a %archivename%
rem pause
if defined doAb (
rem pause
call :_GetABFilesFromFile
) else (


@echo ==========================================================
rem StartRusTextBlock
@echo      %_fBRed%+++ Файл не выбран или это не архив +++
@echo   %_fBYellow%Пожалуйста, выберите что-нибудь более подходящее%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    +++ This is not an ab file, and not a key +++
rem @echo        Please drop something more suitable
rem EndEngTextBlock
@echo ---------------------------------------------------------
)
call :_prevmenu
goto _RestoreMenu


:_GetABFilesFromFile
set OUTFILE=packages-list.txt
call :_SHScriptMaker
%myfiles%\adb push "!fullpath!!archivename!" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%scriptn% '/data/local/tmp/!archivename!' 1>nul 2>nul
set "LOG=%TEMP%\pkg_!RANDOM!.txt"
%myfiles%\adb shell "ls -1t /data/local/tmp/apps | head -n 1" > "!LOG!" 2>nul
set "pkg="
for /f "usebackq delims=" %%k in ("!LOG!") do set "pkg=%%k"
@del /q /f "!LOG!" >nul 2>nul
if defined pkg (
set "viewpackagename=!pkg!"
) else (
set "viewpackagename="
)


echo empty;%archivename%;%viewpackagename%>>"%OUTFILE%"
@echo ---------------------------------------------------------
rem StartRusTextBlock
@echo  %_fBYellow%Восстановление данных приложения:%_fReset%
@echo.
@echo  Название архива	: %_fBCyan%%archivename%%_fReset%
@echo  Название пакета	: %_fCyan%%viewpackagename%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%Restoring application data:%_fReset%
rem @echo.
rem @echo  Archive name	: %_fBCyan%%archivename%%_fReset%
rem @echo  Package name	: %_fCyan%%viewpackagename%%_fReset%
rem EndEngTextBlock
@echo ---------------------------------------------------------
@echo.
%myfiles%\adb shell "rm -f /data/local/tmp/!archivename!.ab" 1>nul 2>nul
%myfiles%\adb shell "rm -rf /data/local/tmp/apps/*" 1>nul 2>nul
del /q /f %scriptn% 1>nul 2>nul
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения восстановления нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
@echo   %_fBYellow%Перед восстановлением рекомендуется проверить наличие свежих бэкапов%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For restore confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem @echo   %_fBYellow%It is recommended to check for the latest backups before restoring%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" del /q /f packages-list.txt 1>nul 2>nul&&goto :_BackupAndRestoreMenu
if "!KEY!"=="13" call %myfiles%\backup.cmd :_RestoreApplicationDataABPS
del /q /f packages-list.txt 1>nul 2>nul
exit /b



:_SHScriptMaker
set "scriptn=extract.sh"
(
echo #!/system/bin/sh
echo ARCHIVE="$1"
echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "$ARCHIVE"^) ^| tar xfvz - -C /data/local/tmp/
) > "%scriptn%"

%myfiles%\adb push "%scriptn%" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell chmod 755 /data/local/tmp/%scriptn% 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%scriptn% 1>nul 2>nul
exit /b


:_SelectFileFolder
if /I "%pathmode%"=="file" (
set "PSKEY=-sf"
rem StartRusTextBlock
set "TITLE=Выберите файл"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "TITLE=Select a file"
rem EndEngTextBlock
) else if /I "%pathmode%"=="folder" (
set "PSKEY=-sfolder"
rem StartRusTextBlock
set "TITLE=Выберите папку"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "TITLE=Select a folder"
rem EndEngTextBlock
) else (
rem StartRusTextBlock
    echo Некорректный режим: %pathmode%
rem EndRusTextBlock
rem StartEngTextBlock
rem echo Incorrected mode: %pathmode%
rem EndEngTextBlock
    exit /b 1
)

set "PSFILE=%cd%\SelectPath_temp.ps1"

> "%PSFILE%" echo param(
>> "%PSFILE%" echo     [switch]$sf,
>> "%PSFILE%" echo     [switch]$sfolder,
>> "%PSFILE%" echo     [string]$title
>> "%PSFILE%" echo )
>> "%PSFILE%" echo Add-Type -AssemblyName System.Windows.Forms
>> "%PSFILE%" echo if ($sf) {
>> "%PSFILE%" echo     $dlg = New-Object System.Windows.Forms.OpenFileDialog
>> "%PSFILE%" echo     $dlg.Title = $title
>> "%PSFILE%" echo     if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
>> "%PSFILE%" echo         Write-Output "FILE=$($dlg.FileName)"
>> "%PSFILE%" echo     }
>> "%PSFILE%" echo }
>> "%PSFILE%" echo elseif ($sfolder) {
>> "%PSFILE%" echo     $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
>> "%PSFILE%" echo     $dlg.Description = $title
>> "%PSFILE%" echo     if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
>> "%PSFILE%" echo         Write-Output "FOLDER=$($dlg.SelectedPath)"
>> "%PSFILE%" echo     }
>> "%PSFILE%" echo }


for /f "tokens=1* delims==" %%A in ('
    powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%" %PSKEY% -title "%TITLE%"
') do (
    if "%%A"=="FILE" set "SelectedFile=%%B"
    if "%%A"=="FOLDER" set "SelectedFolder=%%B"
)

del "%PSFILE%"
rem if defined SelectedFile   echo Выбран файл: %SelectedFile%
rem if defined SelectedFolder echo Выбрана папка: %SelectedFolder%
rem pause
exit /b


:_SelectiveBackupFolder
rem Общая процедура для вызова, как пример
set pathmode=folder
call :_SelectFileFolder SelectedFolder
if not defined SelectedFolder (
rem StartRusTextBlock
@echo   %_fYellow%+++  Каталоги не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No folders selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto %retmenu%
exit /b
)
set filefolder=%SelectedFolder%
exit /b

:_SelectiveBackupFile
rem Общапя процедура для вызова, как пример
set pathmode=file
call :_SelectFileFolder SelectedFile
if not defined SelectedFile (
rem StartRusTextBlock
@echo   %_fYellow%+++  Файлы не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No files selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto %retmenu%
exit /b
)
set filefolder=%SelectedFile%
exit /b



:_testpsfilefolder

rem For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BackupsDir 2^>nul') do set backupsdir=%%a
rem @if not defined backupsdir (set "keybackupsdir=Не установлен") else (set "keybackupsdir=%backupsdir%")

rem set "pathmode=file"
rem set "pathmode=folder"
rem set "pathmode=file"
rem call :_SelectFileOrFolderPS
rem if defined SelectedFile   echo Выбран файл: %SelectedFile%
rem if defined SelectedFolder echo Выбрана папка: %SelectedFolder%
pause
exit



:_AppDataReadWriteBackup
rem Resident Evil 4
rem In Death - Unchained
rem A Fisherman Tale
rem Vader Immortal I

set "CallBackupFileProcedure=%myfiles%\backup.cmd :_BackupReadWrite"
set "datbkpproc=1"
set "quaspath=%~dp0"
Set "SelectorParameters=-o"
set "ReturnMenuLabel=_BackupAndRestoreMenu"
if not defined backuperror (
set "ScriptFinishLabel=_ReadWriteMessage"
) else (
set "ScriptFinishLabel=_ReadWriteMessageError"
)
rem StartRusTextBlock
set "action1=просмотреть"
set "action2=просмотра"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to look"
rem set "action2=looking"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


:_CreateListForBackups
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_ViewAppListReturn"
if not defined appsmark (
Set "SelectorParameters=-p"
) else (
Set "SelectorParameters="
)

set "ReturnMenuLabel=_BackupAndRestoreMenu"
set "ScriptFinishLabel=_FileSavedMesage"
rem StartRusTextBlock
set "action1=вывести"
set "action2=вывода в файл"
set "lfbmess=%_fBYellow%Его можно использовать для создания списка бэкапов, просто переименовав в %_fYellow%ListForBackups.txt%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem set "lfbmess=%_fBYellow%It can be used to create a list of backups, simply by renaming it to %_fYellow%ListForBackups.txt%_fReset%"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


:_ViewApplicatrionList
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_ViewAppListReturn"
rem Set "SelectorParameters=-csv"
if not defined returnlist (
set "ReturnMenuLabel=_AppsManagementMenu"
) else (
set "ReturnMenuLabel=_BackupAndRestoreMenu"
)
set "ScriptFinishLabel=_FileSavedMesage"
rem StartRusTextBlock
set "action1=вывести"
set "action2=вывода в файл"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=save"
rem set "action2=save to file"
rem EndEngTextBlock
set lfbmess=
goto _UniversalAppsHanflerScript


:_FullApplicationBackupPS
call :_BakdirCreate
set "apkbkpproc=1"
set "obbbkpproc=1"
set "datbkpproc=1"
set "quaspath=%~dp0"
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_PackagesListApkNameParser"
Set "SelectorParameters="
set "ReturnMenuLabel=_BackupAndRestoreMenu"
set "ScriptFinishLabel=_BackupFinishMessage"
rem StartRusTextBlock
set "action1=бэкапить"
set "action2=бэкапа"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


:_SaveDATAPS
call :_BakdirCreate
set "datbkpproc=1" 
set "quaspath=%~dp0"
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_PackagesListApkNameParser"
Set "SelectorParameters="
set "ReturnMenuLabel=_BackupAndRestoreMenu"
set "ScriptFinishLabel=_BackupFinishMessage"
rem StartRusTextBlock
set "action1=бэкапить"
set "action2=бэкапа"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


:_SaveAPKPS
call :_BakdirCreate
set "apkbkpproc=1" 
set "quaspath=%~dp0"
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_PackagesListApkNameParser"
Set "SelectorParameters="
set "ReturnMenuLabel=_BackupAndRestoreMenu"
set "ScriptFinishLabel=_BackupFinishMessage"
rem StartRusTextBlock
set "action1=бэкапить"
set "action2=бэкапа"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript



:_SaveAPKOBBPS
call :_BakdirCreate
set "apkbkpproc=1" 
set "obbbkpproc=1" 
set "quaspath=%~dp0"
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_PackagesListApkNameParser"
Set "SelectorParameters="
set "ReturnMenuLabel=_BackupAndRestoreMenu"
set "ScriptFinishLabel=_BackupFinishMessage"
rem StartRusTextBlock
set "action1=бэкапить"
set "action2=бэкапа"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript

rem Ok!
:_ViewRunningAppsPS
set appsrunning=1
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_ViewRunningApps"
Set "SelectorParameters="
set "ReturnMenuLabel=_AppsManagementMenu"
set "ScriptFinishLabel=_AppsManagementMenu"
rem StartRusTextBlock
set "action1=узнать"
set "action2=старта"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to know"
rem set "action2=start"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


rem Ok!
:_ViewAppStatusPS
rem @echo call %%myfiles%%\backup.cmd :_ViewApkLabelInsideHeadset
rem set "CallBackupFileProcedure=%myfiles%\backup.cmd :_ViewApkLabelInsideHeadset"
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_ViewAppLabel"
Set "SelectorParameters=-o"
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=просмотреть"
set "action2=просмотра"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to look"
rem set "action2=looking"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript

rem O
:_StopAppPS
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_StopApps"
if %choice% == gg (
Set "SelectorParameters="
)else (
Set "SelectorParameters=-o"
)
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=остановить"
set "action2=остановки"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to stop"
rem set "action2=for stop"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript

rem O
:_StartAppPS
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_StartApps"
Set "SelectorParameters=-o"
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=запустить"
set "action2=старта"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to launch"
rem set "action2=to start"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript

rem Ok
:_SoftUninstallAppsPS
set "cachekey=-k"

rem Ok
:_UninstallAppsPS
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_UninstallApps"
Set "SelectorParameters="
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=удалить"
set "action2=удаления"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to delete"
rem set "action2=deleting"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


rem Ok
:_ClearCacheDataAppsPS
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_ClearCacheDataApps"
Set "SelectorParameters="
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=очистить"
set "action2=очистки"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to clear"
rem set "action2=clearing"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


rem Ok
:_DisableAppsPS
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_DisableApps"
if %choice% == dd (
Set "SelectorParameters="
)else (
Set "SelectorParameters=-o"
)
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=отключить"
set "action2=отключения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to disable"
rem set "action2=disabling"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript

rem Ok
:_EnableAppsPS
rem Backup
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_EnableApps"
Set "SelectorParameters="
set "ReturnMenuLabel=_installmenugen"
set "ScriptFinishLabel=_installmenugen"
rem StartRusTextBlock
set "action1=включить"
set "action2=включения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to enable"
rem set "action2=enabling"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


rem Ok
:_BackupChoisesPS
call :_BakdirCreate
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_BackupChoises"
Set "SelectorParameters="
set "ReturnMenuLabel=_BackupAndRestoreMenu"
set "ScriptFinishLabel=_BackupFinishMessage"
rem StartRusTextBlock
set "action1=бэкапить"
set "action2=бэкапа"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


:_RestartAppsPS
set "CallBackupFileProcedure=%myfiles%\backup.cmd :_RestartApps"
Set "SelectorParameters=-o"
set "ReturnMenuLabel=_AppsManagementMenu"
set "ScriptFinishLabel=_AppsManagementMenu"
rem StartRusTextBlock
set "action1=перезапустить"
set "action2=перезапуска"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to back up"
rem set "action2=the back up"
rem EndEngTextBlock
goto _UniversalAppsHanflerScript


:_EnterListNumber
set ListNumber=
rem StartRusTextBlock
set /p "ListNumber=Введите номер списка, Enter для дефолтного списка или 0 для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem set /p "ListNumber=Enter list number, press Enter for the default list or 0 to return to the menu: "
rem EndEngTextBlock
if /i "%ListNumber%"=="0" (GOTO _BackupAndRestoreMenu)
if not exist %ListNumber%ListForBackups.txt (goto _BackupListNotFound)
call :_BakdirCreate
call %myfiles%\backup.cmd :_BackupListsSelected
goto _BackupFinishMessage


:_ExtractDataFromBackupFile
call :_cdc
call :_SetColours
call :_BakdirCreate
setlocal enableextensions enabledelayedexpansion
call %myfiles%\backup.cmd :_ViewPackageNameForExtract
@del /q /f returnmark.txt 1>nul 2>nul
call :_prevmenu
goto _BackupAndRestoreMenu


:_ListRunningAppsPS
if not defined appsrunninglist goto :_StopRunningAppsPS
call :_ListRunningAppsPSCreate
call :_ListRunningAppsPSToFile
call :_prevmenu
goto _AppsManagementMenu

:_ListRunningAppsPSCreate
cls
@echo.
@echo.
rem StartRusTextBlock
@echo  Это займет некоторое время, наберитесь терпения...
@echo.
@echo   %_fBYellow%Подготовка списка всех приложений....%_fReset% 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  This will take some time, please be patient...
rem @echo.
rem @echo   %_fBYellow%Preparing the list of all applications....%_fReset%
rem EndEngTextBlock
@echo   ----------
set listpackages=-a
set outputfile=apps-source.txt
rem call :_AppsInstallMenu
call :_AppsSourceListCreate


:_ListRunningAppsPSCreateProcess
set outputfile=apps-source.txt
for /f %%# in ('find /c /v "" ^< "%outputfile%"') do set TOTAL=%%#
set "LEFT=%TOTAL%"
rem StartRusTextBlock
@echo   %_fBYellow%Список создан. Общее количество приложений: %_fBCYan%%TOTAL%%_fReset% 
@echo   ----------
@echo   %_fCyan%Проверяем, какие из приложений запущены в данный момент...%_fReset% 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%List created. Total number of applications: %_fBCYan%%TOTAL%%_fReset% 
rem @echo   ----------
rem @echo   %_fCyan%Checking which applications are currently running...%_fReset% 
rem EndEngTextBlock
@echo   ----------
rem @echo.
for /f "tokens=1,2 delims=;" %%a in (%outputfile%) do (
set "pid="
set "applabel=%%a"
set "pathname=%%b"
if "!pathname!"=="" set "pathname=!applabel!"
for /f "delims=" %%P in ('%myfiles%\adb shell pidof !pathname! 2^>nul') do set "pid=%%P"
if defined pid echo !applabel!;!pathname!>>o.txt

set /a LEFT-=1
<nul set /p str="                                                      "
<nul set /p str=""
rem StartRusTextBlock
<nul set /p str="   %_fBYellow%Осталось приложений: %_fBCyan%!LEFT!  %_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem <nul set /p str="   %_fBYellow%Remaining applications: %_fBCyan%!LEFT!  %_fReset%"
rem EndEngTextBlock
)
exit /b


:_ListRunningAppsPSToFile
@echo.
@echo   -----------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   Выберите приложения, которые хотите внести в список
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Select the applications you want to add to the list
rem EndEngTextBlock
powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "o.txt" "packages-list.txt"
ren packages-list.txt RunningApps.txt 1>nul 2>nul
@echo.
@echo.
@del /q /f apps-source.txt 1>nul 2>nul
@del /q /f %shscriptname%  1>nul 2>nul
@del /q /f o.txt  1>nul 2>nul
@echo.
rem StartRusTextBlock
@echo   ================================================
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo     Список сохранен в файл %_fBYellow%RunningApps.txt%_fReset%
@echo   ================================================
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem )
rem )
rem @echo.
rem @echo   ================================================
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   The list saved to file %_fBYellow%RunningApps.txt%_fReset%
rem @echo   ================================================
rem @echo.
rem EndEngTextBlock
exit /b

:_AppsSourceListCreate
set shscriptname=aaptname.sh
@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %listpackages% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
rem @echo     printf "app $label having package name $line\n";>>%shscriptname%
@echo     printf "$label;$line\n";>>%shscriptname%
rem @echo     printf "\n";>>%shscriptname%
@echo done>>%shscriptname%
@%myfiles%\adb push %myfiles%\aapt-arm-pie2 /data/local/tmp/ 1>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell chmod 0755 /data/local/tmp/aapt-arm-pie2
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >%outputfile% 2>nul
exit /b


:_UniversalAppsHanflerScript
call :_AppsInstallMenu
:_UniversalAppsHanflerScriptNoAIM
call :_SetColours
@echo  -----------------------------------------------------------------------------------------
rem StartRusTextBlock
@echo  %_fBYellow%.. Идет подготовка списка, это займет несколько секунд...
@echo.
@echo  В открывшемся окне выберите приложения, которые хотите %action1%. После завершения выбора
@echo  нажмите кнопку %_fYellow%Confirm %_fBYellow%для %action2%. Для отмены нажмите кнопку %_fYellow%Cancel.
@echo.
@echo  %_fBYellow%Для поиска приложений по имени или названию пакета используйте поле в верхней части окна.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%.. Preparing the list, this will take a few seconds...
rem @echo.
rem @echo  In the window that opens, select the applications you want %action1%. After making your selection,
rem @echo  click the %_fYellow%Confirm %_fBYellow%button %action2%. To cancel click the %_fYellow%Cancel button.
rem @echo.
rem @echo  %_fBYellow%Use the field at the top of the window to search for applications by name or package name.%_fReset%
rem EndEngTextBlock
@echo  -----------------------------------------------------------------------------------------
set shscriptname=aaptname.sh
@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %listpackages% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
rem @echo     printf "app $label having package name $line\n";>>%shscriptname%
@echo     printf "$label;$line\n";>>%shscriptname%
rem @echo     printf "\n";>>%shscriptname%
@echo done>>%shscriptname%
@%myfiles%\adb push %myfiles%\aapt-arm-pie2 /data/local/tmp/ 1>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell chmod 0755 /data/local/tmp/aapt-arm-pie2
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >apps-source.txt 2>nul

if defined appsrunning (
call :_ListRunningAppsPSCreateProcess
ren apps-source.txt apps-source.txt.old 1>nul 2>nul
ren o.txt apps-source.txt 1>nul 2>nul
del /q /f apps-source.txt.old 1>nul 2>nul
)
rem @%MYFILES%\adb shell pm list packages %listpackages% >packages-list-source.txt
powershell -ExecutionPolicy Bypass -File "%MYFILES%\selector4.ps1" "apps-source.txt" "packages-list.txt" %SelectorParameters%
@del /q /f apps-source.txt 1>nul 2>nul
@del /q /f %shscriptname%  1>nul 2>nul
if not exist packages-list.txt goto %ReturnMenuLabel%
call %CallBackupFileProcedure%
rem pause
rem echo on
if "%SelectorParameters%"=="-csv" (
rem del /q /f AppsList.txt 1>nul 2>nul
set FileExtend=csv
rem ren packages-list.txt AppsList-%pkgchoice%.csv
) else (
set FileExtend=txt
rem ren packages-list.txt AppsList-%pkgchoice%.txt
)
@ren packages-list.txt AppsList-%pkgchoice%.%FileExtend% 1> nul 2>nul
@del /q /f packages-list.txt  1>nul 2>nul
goto %ScriptFinishLabel%



:_BackupListsQ
call :_SetColours
rem set ListNumber=%choice:~0,-2%%
set ListNumber=%choice:~2%
rem echo %tst:~2%

if not exist %ListNumber%ListForBackups.txt (goto _BackupListNotFound)
call :_BakdirCreate
call %myfiles%\backup.cmd :_BackupLists
goto _BackupFinishMessage


:_BackupListsQCommandLine
call :_SetColours
call :_cdc
setlocal enableextensions enabledelayedexpansion
if not exist %ListNumber%ListForBackups.txt (goto _BackupListNotFound)
call :_BakdirCreate
call %myfiles%\backup.cmd :_BackupListsSelected
@echo   =====================================
@echo.
rem StartRusTextBlock
@echo          %_fBYellow%Это окно закроется через десять секунд%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo          %_fBYellow%This window will close after ten seconds%_fReset%
rem EndEngTextBlock
@timeout 10 >nul
exit
:_BackupAllAppsQ
call :_SetColours
call %myfiles%\backup.cmd :_BackupAllApps
goto _BackupFinishMessage


:_SelectFileOrFolderPS
rem --- Установите режим: "file" или "folder" ---
rem set "MODE=file"
rem set "pathmode=folder"

rem --- Определяем ключ для PowerShell и заголовок ---
if /I "%pathmode%"=="file" (
    set "PSKEY=-sf"
rem StartRusTextBlock
    set "TITLE=Выберите файл"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "TITLE=Select a file"
rem EndEngTextBlock
) else if /I "%pathmode%"=="folder" (
    set "PSKEY=-sfolder"
rem StartRusTextBlock
    set "TITLE=Выберите папку"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "TITLE=Select a folder"
rem EndEngTextBlock
) else (
rem StartRusTextBlock
    echo Некорректный режим: %pathmode%
rem EndRusTextBlock
rem StartEngTextBlock
rem echo Incorrected mode: %pathmode%
rem EndEngTextBlock
    exit /b 1
)

rem --- Создаём временный PowerShell-скрипт рядом с батником ---
set "PSFILE=%cd%\SelectPath_temp.ps1"

> "%PSFILE%" echo param(
>> "%PSFILE%" echo     [switch]$sf,
>> "%PSFILE%" echo     [switch]$sfolder,
>> "%PSFILE%" echo     [string]$title
>> "%PSFILE%" echo )
>> "%PSFILE%" echo Add-Type -AssemblyName System.Windows.Forms
>> "%PSFILE%" echo if ($sf) {
>> "%PSFILE%" echo     $dlg = New-Object System.Windows.Forms.OpenFileDialog
>> "%PSFILE%" echo     $dlg.Title = $title
>> "%PSFILE%" echo     if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
>> "%PSFILE%" echo         Write-Output "FILE=$($dlg.FileName)"
>> "%PSFILE%" echo     }
>> "%PSFILE%" echo }
>> "%PSFILE%" echo elseif ($sfolder) {
>> "%PSFILE%" echo     $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
>> "%PSFILE%" echo     $dlg.Description = $title
>> "%PSFILE%" echo     if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
>> "%PSFILE%" echo         Write-Output "FOLDER=$($dlg.SelectedPath)"
>> "%PSFILE%" echo     }
>> "%PSFILE%" echo }

rem --- Вызываем PowerShell и парсим результат ---
for /f "tokens=1* delims==" %%A in ('
    powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%" %PSKEY% -title "%TITLE%"
') do (
    if "%%A"=="FILE" set "SelectedFile=%%B"
    if "%%A"=="FOLDER" set "SelectedFolder=%%B"
)

rem --- Удаляем временный скрипт ---
@del /q /f "%PSFILE%" 1>nul 2>nul

rem --- Вывод результата ---
rem echo ----------------------
rem if defined SelectedFile   echo Выбран файл: %SelectedFile%
rem if defined SelectedFolder echo Выбрана папка: %SelectedFolder%
rem pause
exit /b

:_BackupListNotFound
cls
@echo.
@echo.
@echo.
@echo.
@echo   ===================================================
rem StartRusTextBlock
@echo      %_fBRed%Список %_fCyan%%ListNumber%ListForBackups.txt%_fReset% %_fBRed%не найден%_fReset%.
@echo.
@echo    %_fBYellow%Проверьте наличие этого файла рядом с программой
@echo    и перезапустите процесс бэкапа%_fReset%.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBRed%The list %_fBYellow%%ListNumber%ListForBackups.txt%_fReset% %_fBRed%does not exist%_fReset%.
rem @echo    Please check if this file is located next to the program
rem @echo    and restart the backup process.
rem EndEngTextBlock
@echo   ===================================================
rem @echo.
rem @echo.
goto _returnmenu

:_ReadWriteMessage
@del /q /f "!pathname!.ab" 1>nul 2>nul
@del /q /f ArchiveLog*.txt 1>nul 2>nul
@del /q /f AppsList*.txt 1>nul 2>nul
@del /q /f ZeroFile*.txt 1>nul 2>nul
if defined dataout (
@echo   ==============================================
rem StartRusTextBlock
@echo     %_fBRed%Игра не содержит данных%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBRed%The game does not contain any data%_fReset%
rem EndEngTextBlock
@echo   ==============================================
) else (
@echo   ================================================================
rem StartRusTextBlock
@echo     %_fBGreen%Файлы сохранений теперь доступны для чтения и записи%_fReset%
@echo   ================================================================
@echo.
@echo   %_fBYellow%Можете копировать их из каталога Android/data/ или записать туда%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBGreen%Save files are now available for reading and writing%_fReset%
rem @echo   ================================================================
rem @echo.
rem @echo   %_fBYellow%You can copy them from the Android/data/ directory or write them there%_fReset%
rem EndEngTextBlock
)
goto _returnmenu


:_ReadWriteMessageError
@del /q /f "!pathname!.ab" 1>nul 2>nul
@del /q /f ArchiveLog*.txt 1>nul 2>nul
@del /q /f AppsList*.txt 1>nul 2>nul
@del /q /f ZeroFile*.txt 1>nul 2>nul
@echo.
@echo.
@echo   ==============================
rem StartRusTextBlock
@echo   Не удалось выполнить операцию
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Failed to perform the operation
rem EndEngTextBlock
@echo   ==============================
call :_prevmenu
goto _BackupAndRestoreMenu


:_FileSavedMesage
@echo   ==============================================
rem StartRusTextBlock
@echo              %_fBGreen%Создание списка завершено%_fReset%
@echo   ==============================================
@echo.
@echo   %_fBYellow%Он называется %_fYellow%AppsList-%pkgchoice%.%FileExtend% %_fBYellow%и находится рядом с программой%_fReset%
@echo.  %lfbmess%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo              %_fBGreen%List creation completed%_fReset%
rem @echo   ==============================================
rem @echo.
rem @echo   %_fBYellow%It is called %_fYellow%AppsList-%pkgchoice%.%FileExtend% %_fBYellow%and is located next to the program%_fReset%
rem @echo.  %lfbmess%
rem EndEngTextBlock
@echo.  
goto _returnmenu


:_BackupFinishMessage
@del /q /f AppsList*.txt 1>nul 2>nul
@echo.
@echo   ==============================================
rem StartRusTextBlock
@echo                %_fBGreen%Архивация завершена%_fReset%
@echo   ==============================================
@echo.
@echo   Все бэкапы расположены в этом каталоге: 
@echo.
@echo      %_fBYellow%%bakdir%\%dt%\%_fReset%
@echo.
@echo   Лог архивации сохранен в файле %_fBYellow%ArchiveLog-%dt%.txt%_fReset%
@echo   и находится в каталоге %_fBYellow%%bakdir%\Logs\%_fReset%
@echo.
@echo   Список пропущенных приложений находится в файле %_fBYellow%ZeroSizeBackups.txt%_fReset% рядом с программой.
@echo   Чтобы бэкап данных этих приложений стал возможным, запустите эти приложения хотя бы один раз. 
@echo   Если такого файла нет, значит все приложения забэкапились успешно.
@echo.
@echo   %_fBGreen%Подсказка:%_fReset% чтобы забэкапить пропущенные приложения вы можете использовать файл
@echo   %_fBYellow%ZeroSizeBackups.txt%_fReset%. Достаточно переименовать его в %_fBYellow%ListForBackups.txt%_fReset%
@echo   и в меню бэкапов выбрать опцию %_fBGreen%Архивация по списку%_fReset%.
@echo   Но прежде не забудьте запуститьприложения в этом списке, чтобы создались их данные.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo                %_fBGreen%Backup completed%_fReset%
rem @echo   ==============================================
rem @echo.
rem @echo   All backups are located in this directory:
rem @echo.
rem @echo      %_fBYellow%%bakdir%\%dt%\%_fReset%
rem @echo.
rem @echo   The list of skipped applications is in the file %_fBYellow%ZeroSizeBackups.txt%_fReset% next to the program.
rem @echo   To enable backup of these applications' data, launch these applications at least once.
rem @echo   If this file is missing, it means all applications were successfully backed up.
rem @echo.
rem @echo   %_fBGreen%Tip:%_fReset% To backup the skipped applications, you can use the file
rem @echo   %_fBYellow%ZeroSizeBackups.txt%_fReset%. Simply rename it to %_fBYellow%ListForBackups.txt%_fReset%
rem @echo   and in the backup menu, select the %_fBGreen%Backup by List%_fReset% option.
rem @echo   But don't forget to launch the applications from this list first, so their data will be created.
rem EndEngTextBlock
@echo.
goto _returnmenu


:_Restoring
cls
call %myfiles%\backup.cmd :_ViewABPackageAppName
@if exist returnmark.txt (
@del /q /f returnmark.txt 1>nul 2>nul
call :_prevmenu && goto :_BackupAndRestoreMenu
rem set /p returnmark=<returnmark.txt
) else (
set "returnmark="
)
rem @set /p returnmark=<returnmark.txt >nul 2>&1
rem @del /q /f returnmark.txt 1>nul 2>nul
rem if defined returnmark call :_prevmenu && goto :_BackupAndRestoreMenu
set choice=1
@echo.
@echo.
@echo      -------------------------------------------------------------------------------------
rem StartRusTextBlock
@echo       %_fBYellow%Список архивов с именами пакетов и названиями файлов сохранен в файл ArchivesList.txt
@echo.
@echo       Не прерывайте процесс восстановления. На время восстановления датчик приближения
@echo       будет отключен. Если процесс все-же прервался по каким-то причинам,
@echo       не забудьте включить датчик в пунктах E-F-E из Главного меню.%_fReset%
@echo      -------------------------------------------------------------------------------------
@echo.
@Set /p choice="Подтвердите восстановление нажатием Enter или введите 0 и Enter для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       %_fBYellow%Do not interrupt the restoration process. During the restoration, the proximity sensor
rem @echo       will be disabled. If the process is interrupted for any reason,
rem @echo       do not forget to enable the sensor in the E-F-E section from the Main menu.%_fReset%
rem @echo      -------------------------------------------------------------------------------------
rem @echo.
rem @Set /p choice="Confirm restoration by pressing Enter, or enter 0 and press Enter to return to the menu: "
rem EndEngTextBlock
if not defined choice goto _Restoring
if /i "%choice%"=="0" (GOTO _beginn)
rem if /i "%choice%"=="0" (exit)
@echo.
@echo.
@echo %_fBYellow%
rem StartRusTextBlock
@Set /p choice="Еще раз подтвердите восстановление нажатием Enter или введите 0 и Enter для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Confirm the restore again by pressing Enter, or enter 0 and press Enter to return to the menu: "
rem EndEngTextBlock
@echo %_fReset%
if /i "%choice%"=="0" (GOTO _beginn)
if /i "%choice%"=="1" (call %myfiles%\backup.cmd :_RestoreApplicationDataAB)
@echo. 
@echo    =============================
rem StartRusTextBlock
@echo      %_fBGreen%Все бэкапы восстановлены%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBGreen%All backups have been restored%_fReset%
rem EndEngTextBlock
@echo    =============================
@echo. 
@echo. 
goto _returnmenu

:_BakdirCreate
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BackupsDir 2^>nul') do set backupsdir=%%a
if defined backupsdir (
dir /a /b "%backupsdir%" 2>nul | findstr . >nul
if errorlevel 1 (
dir /a /b "%cd%\Backups" 2>nul | findstr . >nul
if errorlevel 1 (
md %cd%\Backups 1>nul 2>nul
set BAKDIR=%cd%\Backups
) else (
set BAKDIR=%cd%\Backups
)
) else (
set BAKDIR=%backupsdir%
)
)
rem dir /a /b "%cd%\Backups" 2>nul | findstr . >nul
rem if errorlevel 1 (echo.>nul) else (set BAKDIR=%cd%\Backups)
exit /b



:_DiagInformation
del DiagInfo.txt /q /f 2>nul 1>nul

setlocal enableextensions enabledelayedexpansion
cls
call :_hat
rem set devdiaginfo=^>^>DevDiagInfo.txt
if defined senddiaglabel (
@echo.
rem StartRusTextBlock
@echo  %_fBYellow%+ Сбор ключевой информации в сводный файл...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%+ Collecting key information into a summary file...%_fReset%
rem EndEngTextBlock
set diaginfo=^>^>DiagInfo.txt
rem set devdiaginfo=^>^>DevDiagInfo.txt
set _fBYellow=
set _fReset=
set _fBGreen=
set _fBRed=
set _fCyan=
)
@echo. %diaginfo%
@echo    === DIAGNOSTIC INFORMATION === %diaginfo%
@echo. %diaginfo%
@echo   -------- %_fCyan%Userdata%_fReset% -----------------%diaginfo%
@echo   %_fBYellow%Computer%_fReset%	: %_fBGreen%-----%computername:~-3%%_fReset%%diaginfo%

@reg query "HKU\S-1-5-19" >NUL 2>&1 && (set "adminmsg=%_fBGreen%Admin%_fReset%") || (set "adminmsg=%_fBRed%User%_fReset%")
@echo   %_fBYellow%Rights%_fReset%	: %adminmsg%%diaginfo%
set /a prf=1
@FOR /F "skip=1 tokens=1,2,3,4,5 delims={}: " %%a IN ('%myfiles%\adb shell pm list users 2^>nul') DO (
set wner=%%b
if "!wner!" == "0" set "owner=(Owner)"%diaginfo%
@echo   %_fBYellow%Profile%_fReset%	: [%prf%] %_fBGreen%!wner! !owner!%_fReset%%diaginfo%

set usrnm=%%c
set usrnm=!usrnm:~0,-3!----
@echo   %_fBYellow%Username%_fReset%	: [%prf%] %_fBGreen%!usrnm!%_fReset%%diaginfo%
rem echo %%d
@echo   %_fBYellow%Status%_fReset% 	: [%prf%] %_fBGreen%%%e%_fReset%%diaginfo%
set /a prf=!prf!+1
)
@echo. %diaginfo%
@echo   -------- %_fCyan%Headset data%_fReset% -----------------%diaginfo%
@curl.exe 1>nul 2>nul
if %errorlevel%==2 (set "curlinst=%_fBGreen%installed%_fReset%") else ("curlinst=%_fBRed%Not installed%_fReset%")
@echo   %_fBYellow%Curl%_fReset%		: %curlinst%%diaginfo%
rem @%myfiles%\adb devices | findstr "device"$ 1>nul 2>nul
@FOR /F "skip=1 tokens=*" %%G IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO set adbdevices=%%G
if not defined adbdevices @echo   %_fBYellow%ADB devices	: %_fBRed%Headset not found%_fReset%%diaginfo%&& goto _WithoutHeadset
@echo   %_fBYellow%ADB devices	: %_fBGreen%%adbdevices%%_fReset%%diaginfo%
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"`) do (set ths=%%a)
@FOR /F "tokens=*" %%G IN ('%MYFILES%\adb shell getprop ro.product.name') DO set modelname=%%G
@echo   %_fBYellow%Model name	: %_fBGreen%%modelname%%_fReset%%diaginfo%


@call :_SETTIME
if %ths:~0,-3%==%dppt:~0,-3% (
set "timecheck=%_fBGreen%Correct%_fReset%"
) else (
set "timecheck=%_fBRed%Differs %_fBYellow%(Sometimes it is wrong, try again)%_fReset%"
)
@echo   %_fBYellow%Time%_fReset%		: %timecheck%%diaginfo%
@echo.%diaginfo%
@echo   -------- %_fCyan%Firmware version %_fReset%-----------------%diaginfo%
For /F %%a In ('@%MYFILES%\adb shell getprop ro.build.version.incremental 2^>nul') Do set hsenvironment=%%a
@FOR /F "tokens=1,2 delims==" %%a IN ('@%MYFILES%\adb shell dumpsys package com.oculus.systemux 2^>nul ^| findstr /i /c:"VersionName"') DO (
@FOR /F "tokens=1,2,3,4 delims=." %%a IN ("%%b") DO set "fwnewhsversion=%%a.%%b.%%c.%%d"
)
@echo   %_fBYellow%Firmware%_fReset% 	: %_fBGreen%!fwnewhsversion!%_fReset%%diaginfo%
@echo   %_fBYellow%Environment%_fReset%	: %_fBGreen%!hsenvironment!%_fReset%%diaginfo%

@echo.%diaginfo%
@echo  -------- %_fCyan%System files version%_fReset% -------------%diaginfo%
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Integrity"') do (
rem set okintn=%%b
set okintc=%%a
)
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Core Mobile Services"') do (
rem set ocmsn=%%b
set ocmsc=%%a
)
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Library Quest"') do (
rem set olqn=%%b
set olqc=%%a
)
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Device Settings"') do (
rem set odsn=%%b
set odsc=%%a
)
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Assistant"') do (
rem set oan=%%b
set oac=%%a
)
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Quest platform apex"') do (
rem set opan=%%b
set opac=%%a
)
for /f "tokens=10 delims=|" %%a in ('@%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Presence Service"') do (
rem set opsn=%%b
set opsc=%%a
)


@echo   %_fBYellow%Oculus Integrity%_fReset%		: %_fBGreen%!okintc!%_fReset%%diaginfo%
@echo   %_fBYellow%Oculus Core Mobile Services%_fReset%	: %_fBGreen%!ocmsc!%_fReset%%diaginfo%
@echo   %_fBYellow%Oculus Library Quest%_fReset%		: %_fBGreen%!olqc!%_fReset%%diaginfo%
@echo   %_fBYellow%Oculus Device Settings%_fReset%	: %_fBGreen%!odsc!%_fReset%%diaginfo%
@echo   %_fBYellow%Oculus Assistant%_fReset%		: %_fBGreen%!oac!%_fReset%%diaginfo%
@echo   %_fBYellow%Quest platform apex%_fReset%		: %_fBGreen%!opac!%_fReset%%diaginfo%
@echo   %_fBYellow%Oculus Presence Service%_fReset%	: %_fBGreen%!opsc!%_fReset%%diaginfo%


:_WithoutHeadset
rem @echo  +++ %_fBRed%Headeset not found%_fReset% +++
@echo.%diaginfo%
rem del DevDiagInfo.txt /q /f 2>nul 1>nul
rem @echo.%devdiaginfo%
rem @echo  -------- %_fCyan%Devcon VID and PID%_fReset% --------------------------------%devdiaginfo%
rem start " " cmd /c "%myfiles%\devcon_x64 findall *VID_2833* 2>nul%diaginfo%"

rem %myfiles%\devcon_x64 findall *VID_2833* 2>nul%devdiaginfo%
rem @echo.%diaginfo%
rem @echo  -------- %_fCyan%Devcon Quest%_fReset% -----------------------------------------%diaginfo%
rem %myfiles%\devcon_x64 find *Quest* 2>nul%diaginfo%
rem @echo.%diaginfo%
@echo  -------- %_fCyan%Folders paths%_fReset% -------------------------------------%diaginfo%
@echo   %_fBYellow%This is folder %%cd%%%_fReset%	: %_fBGreen%%cd%%_fReset%%diaginfo%
@echo   %_fBYellow%This is folder %%~dp0%_fReset%	: %_fBGreen%%~dp0%_fReset%%diaginfo%
@echo   %_fBYellow%This is folder %%temp%%%_fReset%	: %_fBGreen%%temp%%_fReset%%diaginfo%
@echo.%diaginfo%
@echo  -------- %_fCyan%Check paths for cyrillic%_fReset% -----------------------------------%diaginfo%
call :_CyrillicPathCheckTemp
@echo.   %_fBRed%%cyrmsgtemp%%diaginfo%
rem @echo.   %cyrmsgdp%
@echo.   %cyrmsgtcd%%_fReset%%diaginfo%
rem @echo  ----------------------------------------------%diaginfo%
rem start "" cmd /c "type DevDiagInfo.txt & pause%devdiaginfo%"
rem start " " cmd /c type DevDiagInfo.txt
if defined senddiaglabel exit /b
rem @echo   ---------------------------------------------------------------------------------
rem @echo.


:_PressKeyForSendDevicesData
@echo.
@echo.
rem StartRusTextBlock
@echo   %_fBYellow%Для отправки данных на диагностику нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%To send data for diagnostics press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"

if "!KEY!"=="27" goto _beginn
if "!KEY!"=="13" (
set senddiaglabel=1
call :_DiagInformation


ren DiagInfo.txt DiagInfo-%dt%.txt
set uploadfile=DiagInfo-%dt%.txt
@echo  ---
rem StartRusTextBlock
@echo  %_fBYellow%= Отправка сводного файла на диагностику...%_fReset%
call :_UploadFileFeedbackCurl sendkoofrmess
@echo  ---
@echo !sendkoofrmess!
@echo    %_fBYellow%Копия файла находится рядом с программой%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%= Sending summary file for diagnostics...%_fReset%
rem call :_UploadFileFeedbackCurl sendkoofrmess
rem @echo  ---
rem @echo !sendkoofrmess!
rem @echo    %_fBYellow%A copy of the file is located next to the program%_fReset%
rem EndEngTextBlock
call :_SetColours
goto _returnmenu
)
rem goto _PressKeyForSendDevicesData
rem @echo  ----------------------------------------------
rem @echo   %_fBRed%Не удалось собрать информацию об устройствах%_fReset%
rem FА@echo  ----------------------------------------------
call :_SetColours
goto _returnmenu


@echo  =============================
@echo %_fBYellow% = Checking update servers status....%_fReset%
timeout 2 /NOBREAK >nul
::-------------------------------
@%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul
call :_AppsNumbersListCheck
set linkUpdates=https://securecdn.oculus.com/binaries/download/?id=
set toolname=wget
set shscriptname=wgt.sh
set listtxt=appsnumbers.txt
@%myfiles%\adb push %myfiles%\%toolname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell chmod +x /data/local/tmp/%toolname%
@for /f "tokens=*" %%a in (%listtxt%) do (
@echo /data/local/tmp/wget -q --no-check-certificate --spider %linkUpdates%%%a >%myfiles%\%shscriptname%
@%myfiles%\adb shell rm /data/local/tmp/%shscriptname% 1>nul 2>nul
@%myfiles%\adb push %myfiles%\%shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname%
if %errorlevel%==0 (set "updateServersStatusMsg=%_fBGreen%Available%_fReset%"&&goto _UpdServStatus)
)
set "updateServersStatusMsg=%_fBRed%Not Available%_fReset%"

:_UpdServStatus
@echo  = Update server status	: %updateServersStatusMsg%
@%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul
@del /q /f appsnumbers.txt 1>nul 2>nul
goto _returnmenu


:_ServiceTools
cls
start cmd /k "cd /d %MYFILES%"
goto _beginn

:_contactauthor
cls
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Страница автора на Github
@echo    B.  Сообщество Виаркомм			[RU]
@echo    C.  Описание работы программы
@echo    D.  Подкинуть монет: By me the coffee	[QR code]
@echo    E.  Подкинуть монет: By me the coffee	[Web browser]
@echo.
@echo    %_fBGreen%F.  Оставить отзыв или отправить файл%_fReset%
@echo.
@echo.
@echo   Примечание: Ссылки будут открыты в браузере по умолчанию
@echo.
@echo   %_fBYellow%После выбора опции %_fYellow%F %_fBYellow%появится дополнительное окно.
@echo.
@echo   Для отправки отзыва или сообщения об ошибке нажмите кнопку %_fYellow%Leave Feedback %_fBYellow%и текстовом поле
@echo   напишите все, что хотите сообщить, затем нажмите кнопку %_fYellow%Send%_fBYellow%. Текстовый файл с отзывом 
@echo   отправится автору программы и будет сохранен на вашем компьютере рядом с программой %_fYellow%Quas%_fBYellow%.
@echo.
@echo   Чтобы отправить файл (%_fYellow%например, скриншот с ошибкой%_fBYellow%), просто перетащите его мышью на это окно
@echo   или нажмите кнопку %_fYellow%Send File %_fBYellow%и выберите файл на компьютере.
@echo.
@echo   Кроме вашего текста или файла никакие другие данные не отправляются. Если вы хотите
@echo   чтобы автор связался с вами, оставьте свои контактные данные в текстовом сообщении.
@echo   В любом случае вы всегда можете написать на Виаркомм %_fYellow%(пункт B)%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Program page on Github
rem @echo    B.  VRcomm community			[RU]
rem @echo    C.  Program description
rem @echo    D.  Donate: By me the coffee		[QR code]
rem @echo    E.  Donate: By me the coffee		[Web browser]
rem @echo.
rem @echo    F.  Leave feedback or send file
rem @echo.
rem @echo.
rem @echo   Note: Links will be opened in the default browser
rem @echo.
rem @echo   %_fBYellow%After selecting option %_fYellow%F %_fBYellow%an additional window will appear. To send a file, simply drag it
rem @echo   with the mouse onto this window or click the %_fYellow%Send File %_fBYellow%button and select a file on your computer.
rem @echo.
rem @echo   To send feedback, click the %_fYellow%Leave feedback %_fBYellow%button and in the opened window write everything
rem @echo   you want to report. A text file with the feedback will be sent to the program author and
rem @echo   will also be saved on your computer next to the program %_fYellow%Quas%_fBYellow%.
rem @echo.
rem @echo   No other data besides your text or file is sent.
rem @echo   If you want me to contact you, leave your contact information in the text message.%_fReset%
rem EndEngTextBlock
@echo.    
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _contactauthor
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (start " " "https://github.com/Varsett/Quas" && goto _beginn)
if /i "%choice%"=="b" (start " " "https://vrcomm.ru/" && goto _beginn)
if /i "%choice%"=="f" (call :_UploadFileFeedbackGUI)

rem StartRusTextBlock
if /i "%choice%"=="c" (start " " "https://docs.google.com/document/d/1VOyN6Tcz5FUVwpywOZKCGdLITgTaaCWhV1pxvGWZuwc")
rem EndRusTextBlock
rem StartEngTextBlock
rem if /i "%choice%"=="c" (start " " "https://docs.google.com/document/d/1jQh_Kmpx9mXPeTnw-A334XEIQvEsqYRW2nbeboEAbYk")
rem EndEngTextBlock
if /i "%choice%"=="d" (start " " "%myfiles%\bmc_qr.png")
if /i "%choice%"=="e" (start " " "https://buymeacoffee.com/varset" && goto _beginn)
rem if /i "%choice%"=="b" (GOTO _shellrestart2)
rem if /i "%choice%"=="q" (start " " "_____")
goto _contactauthor


:_UploadFileFeedbackGUI
powershell.exe -STA -NoLogo -ExecutionPolicy Bypass -File "%myfiles%\feedback.ps1"
exit /b

rem set uploadfile=test.txt
:_UploadFileFeedbackCurl
@curl "https://app.koofr.net/content/receivers/1574cf54-aaeb-403f-8bcf-a1a9498e5e62/files/put" -X POST -F "file=@%uploadfile%" -Ss 1>nul 2>nul

if errorlevel 1 (
rem StartRusTextBlock
set "sendkoofrmess=%_fBRed% = Не удалось отправить файл%_fReset%"
) else (
set "sendkoofrmess=%_fBGreen% = Файл %filemessage% отправлен%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "sendkoofrmess=%_fBRed% = Failed to send file%_fReset%"
rem ) else (
rem set "sendkoofrmess=%_fBGreen% = File sent%_fReset%"
rem EndEngTextBlock
)
exit /b

:_DiagnosticInformationMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo       МЕНЮ СБОРА И ОТПРАВКИ ДИАГНОСТИЧЕСКОЙ ИНФОРМАЦИИ
@echo       ================================================
@echo.
@echo.
@echo    A.  Сводная диагностическая информация
@echo    B.  Информации обо всех устройствах компьютера
@echo    C.  Информации о не установленных устройствах компьютера
@echo    D.  Информация только о шлемах Quest
@echo.
@echo    K.  Сбор и отправка комплексной информации
@echo    F.  Отправить любой файл на диагностику
@echo.
@echo.
@echo   %_fCyan%ПОЯСНЕНИЕ:%_fReset%
@echo.
@echo      %_fBYellow%Диагностические данные предназначены для помощи в решении различных проблем,
@echo      связанных со шлемом.
@echo.
@echo      %_fBYellow%Сводная диагностика (%_fYellow%пункт A%_fBYellow%) собирает ключевые данные о шлеме.
@echo      Они отобразятся на экране.
@echo      Пункты %_fYellow%B,C,D %_fBYellow%собирают информацию об устройствах компьютера. Эта информация
@echo      позволит понять, есть ли на вашем ПК проблемные устройства, связанные со шлемом.
@echo.
@echo      Информация в пунктах %_fYellow%B,C,D,K %_fBYellow%по умолчанию сохраняется в текстовый файл рядом с программой.
@echo      Если требуется сохранить данные не в %_fYellow%txt%_fBYellow%, а в формате %_fYellow%csv%_fBYellow%, при выборе пункта введите
@echo      две буквы. Первая буква - %_fYellow%пункт меню%_fBYellow%, вторая - %_fYellow%С%_fBYellow%. Пример: %_fYellow%bc,cc,dc,kc%_fBYellow%.
@echo.
@echo      После создания файлов с данными программа предложит отправить их на диагностику.
@echo      Сделайте это, если сочтете нужным. Никаких конфиденциальных данных файлы не содержат.
@echo.
@echo      Комплексная отправка информации собирает и сразу отправляет на диагностику информацию
@echo      из пунктов %_fYellow%A%_fBYellow% и %_fYellow%D%_fBYellow%. 
@echo      Для отправки любого файла выберите %_fYellow%пункт F%_fBYellow%, откроется окно Windows, на которое можно
@echo      просто бросить файл мышью или нажать кнопку %_fYellow%Send file%_fBYellow% и выбрать файл на компьютере.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       DIAGNOSTIC INFORMATION COLLECTION AND SUBMISSION MENU
rem @echo       ================================================
rem @echo.
rem @echo.
rem @echo    A.  Summary diagnostic information
rem @echo    B.  Information about all computer devices
rem @echo    C.  Information about uninstalled computer devices
rem @echo    D.  Information only about Quest headsets
rem @echo.
rem @echo    K.  Collect and send comprehensive information
rem @echo    F.  Send any file for diagnostics
rem @echo.
rem @echo.
rem @echo   %_fCyan%EXPLANATION:%_fReset%
rem @echo.
rem @echo      %_fBYellow%Diagnostic data is intended to help solve various problems
rem @echo      related to the headset.
rem @echo.
rem @echo      %_fBYellow%Summary diagnostics (%_fYellow%item A%_fBYellow%) collects key data about the headset.
rem @echo      It will be displayed on the screen.
rem @echo      Items %_fYellow%B,C,D %_fBYellow%collect information about computer devices. This information
rem @echo      will help determine if there are problematic devices on your PC related to the headset.
rem @echo.
rem @echo      The information in items %_fYellow%B,C,D,K %_fBYellow%is by default saved to a text file next to the program.
rem @echo      If you want to save the data not in %_fYellow%txt%_fBYellow% but in %_fYellow%csv%_fBYellow% format, when choosing the item enter
rem @echo      two letters. The first letter is the %_fYellow%menu item%_fBYellow%, the second is %_fYellow%C%_fBYellow%. Example: %_fYellow%bc,cc,dc,kc%_fBYellow%.
rem @echo.
rem @echo      After creating the data files, the program will prompt you to send them for diagnostics.
rem @echo      Do this if you consider it necessary. The files do not contain any confidential data.
rem @echo.
rem @echo      Comprehensive information submission collects and immediately sends for diagnostics
rem @echo      the information from items %_fYellow%A%_fBYellow% and %_fYellow%D%_fBYellow%.
rem @echo      To send any file, select %_fYellow%item F%_fBYellow%, a Windows window will open, where you can
rem @echo      simply drag the file with the mouse or press the %_fYellow%Send file%_fBYellow% button and select the file
rem @echo      on your computer.%_fReset%
rem EndEngTextBlock
@echo.    
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _DiagnosticInformationMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (goto _DiagInformation)
if /i "%choice%"=="b" (goto _DiagnosticPCInformationSend)
if /i "%choice%"=="bc" (set "vpparameters=-csv"&&goto _DiagnosticPCInformationSend)
if /i "%choice%"=="c" (set "vpparameters=-MissingClass"&& goto _DiagnosticPCInformationSend)
if /i "%choice%"=="b" (goto _DiagnosticInformationSendComplex)
if /i "%choice%"=="cc" (set "vpparameters=-MissingClass -csv"&& goto _DiagnosticPCInformationSend)
if /i "%choice%"=="d" (set "vpparameters=-VID "2833""&& goto _DiagnosticPCInformationSend)
if /i "%choice%"=="dc" (set "vpparameters=-VID "2833" -csv"&& goto _DiagnosticPCInformationSend)
if /i "%choice%"=="f" (call :_UploadFileFeedbackGUI)
if /i "%choice%"=="k" (goto _DiagnosticInformationSendComplex)
if /i "%choice%"=="kc" (set csvfile=1&&goto _DiagnosticInformationSendComplex)

goto _DiagnosticInformationMenu

:_DiagnosticPCInformationSend
setlocal enableextensions enabledelayedexpansion
@echo.
@echo.
@echo   ---------------------------------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%...Собираем диагностическую информацию...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%...Collecting diagnostic information...%_fReset%
rem EndEngTextBlock
for /f "delims=" %%F in ('powershell -NoProfile -ExecutionPolicy Bypass -NoLogo -File "%myfiles%\vstn.ps1" %vpparameters%') do set "VIDPID_FILE=%%F"
if exist %VIDPID_FILE% (
@echo   ---
rem StartRusTextBlock
@echo    %_fBGreen%Информация об устройствах записана в файл: %_fGreen%%VIDPID_FILE%%_fReset%
@echo   ---------------------------------------------------------------------------------
@echo.
@echo   %_fBYellow%Для отправки файла на диагностику нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBGreen%Device information saved to file: %_fGreen%%VIDPID_FILE%%_fReset%
rem @echo   ---------------------------------------------------------------------------------
rem @echo.
rem @echo   %_fBYellow%To send the file for diagnostics press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"

if "!KEY!"=="27" goto _DiagnosticInformationMenu
if "!KEY!"=="13" (
rem StartRusTextBlock
@echo %_fBYellow%  = Отправка файла...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBYellow%  = File is sending...%_fReset%
rem EndEngTextBlock
set uploadfile=%VIDPID_FILE%
call :_UploadFileFeedbackCurl
@echo   ---
@echo  !sendkoofrmess!
rem StartRusTextBlock
@echo     Копия файла находится рядом с программой
call :_prevmenu
rem pause >nul
goto :_DiagnosticInformationMenu
)
@echo   Не удалось собрать информацию об устройствах
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     A copy of the file is located next to the program
rem call :_prevmenu
rem pause >nul
rem goto :_DiagnosticInformationMenu
rem )
rem @echo   Failed to collect device information
rem EndEngTextBlock
call :_prevmenu
rem pause >nul
goto :_DiagnosticInformationMenu

:_DiagnosticInformationSendComplex
call :_settime
setlocal enableextensions enabledelayedexpansion
@echo   ---
call :_hat
set senddiaglabel=1
call :_DiagInformation
ren DiagInfo.txt DiagInfo-%dt%.txt
set uploadfile=DiagInfo-%dt%.txt
rem StartRusTextBlock
set "filemessage=сводной диагностики"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "filemessage=summary diagnostics"
rem EndEngTextBlock
call :_UploadFileFeedbackCurl
@echo !sendkoofrmess!
rem StartRusTextBlock
@echo  %_fBYellow%+ Сбор информации об оборудовании шлема на ПК%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%+ Collecting headset hardware information on PC%_fReset%
rem EndEngTextBlock

if defined csvfile (
set "vpparameters=-VID "2833" -csv"
) else (
set "vpparameters=-VID "2833""
)
for /f "delims=" %%F in ('powershell -NoProfile -ExecutionPolicy Bypass -NoLogo -File "%myfiles%\vstn.ps1" %vpparameters%') do set "VIDPID_FILE=%%F"

set uploadfile=%VIDPID_FILE%
rem StartRusTextBlock
set "filemessage=оборудования шлема"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "filemessage=headset hardware"
rem EndEngTextBlock
call :_UploadFileFeedbackCurl
@echo !sendkoofrmess!
call :_prevmenu
rem pause >nul
goto :_DiagnosticInformationMenu



:_ShowAllUndocCommands
cls
@echo.
rem StartRusTextBlock
@echo    Параметры командной строки:
@echo   --------------------------------
@echo 	h	= Это окно (можно набрать в Главном меню)
@echo 	u	= Перезапустить от имени пользователя
@echo 	c	= Перезапустить от админа с запросом UAC
@echo 	a	= Перезапустить от админа без запроса UAC
@echo 	b	= Ускоренный старт Quas: без таблицы и проверок
@echo 	v	= Verbose: выводить полную информацию о работе скрипта
@echo 	qqX	= Автоматическая архивация данных приложений по списку с номером "X"
@echo 	d	= Сбор и отправка диагностической информации
@echo.
@echo    Скрытые команды меню:
@echo   --------------------------------
@echo 	G-FF	= Дополнительное пояснение об инкрементальных прошивках
@echo 	J-A-d	= Включить установку с возможностью downgrade
@echo 	J-A-v	= Включить отображение подробностей установки
@echo 	J-A-l	= Включить запись в файл лога установки
@echo 	J-E-dd  = Отключение приложений в пакетном режиме
@echo 	J-E-gg  = Остановка приложений в пакетном режиме
@echo 	449	= Таблица разделов шлема и их размер в байтах и гигабайтах
@echo 	103	= Таблица разделов шлема и их размер в байтах и гигабайтах
@echo 	77	= Подключение к шлему по случайному порту (аналог пунктов F-G-D)
@echo 	pt	= Отобразить результаты теста Wi-Fi из меню Диагностики или из Главного меню
@echo 	qqXX	= Быстрый бэкап по списку с номером XX	
@echo 	s	= Отладочная информация
@echo 	st	= Окно консоли Quas
@echo 	adbe	= Быстро встроить пакет ADB в систему
@echo 	adbd	= Быстро удалить пакет ADB из системы
@echo.
@echo   Последовательность G-FF означает, что следует сначала выбрать пункт G, затем пункт FF.
@echo   И аналогично J-A-d означает, что следует сначала выбрать пункт J, затем пункт A, после
@echo   этого ввести параметр d. Ключи u, c, a, b можно использовать как параметр при запуске
@echo   программы Quas, например: quas_v5.2.0.rus.exe b
@echo   --------------------------------
@echo.
@echo ^>^>^> Нажмите что-нибудь для продолжения ^<^<^<
@pause >nul
cls
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    Command line parameters:
rem @echo   --------------------------------
rem @echo 	h	= This window (can be chosen in the Main menu)
rem @echo 	u	= Restart as user
rem @echo 	c	= Restart as admin with UAC prompt
rem @echo 	a	= Restart as admin without UAC prompt
rem @echo 	b	= Quick start Quas: without table and checks (bypass)
rem @echo 	v	= Verbose: display full information about the script's operation
rem @echo 	qqX	= Automatic application data backup using the list with number "X"
rem @echo 	d	= Collecting and send diagnostic information
rem @echo.
rem @echo    Hidden menu commands:
rem @echo   --------------------------------
rem @echo 	G-^>FF	= Additional explanation about incremental firmware updates
rem @echo 	J-A-d	= Enable installation with downgrade capability
rem @echo 	J-A-v	= Enable installation details display (verbose)
rem @echo 	J-A-l	= Enable installation log file recording
rem @echo       J-E-dd  = Disable apps in the batch mode
rem @echo       J-E-gg  = Stop apps in the batch mode
rem @echo 	449	= Headset partition table and their sizes in bytes and gigabytes
rem @echo 	103	= Headset partition table and their sizes in bytes and gigabytes
rem @echo 	77	= Connect to the headset via a random port (similar to F-G-D options)
rem @echo 	pt	= Display Wi-Fi test results from the Diagnostics menu or Main menu
rem @echo 	qqXX    = Quick backup by the list with number XX
rem @echo 	s	= Debug information
rem @echo  	st	= Quas console
rem @echo 	adbe	= Quickly install the ADB package into the system
rem @echo 	adbd	= Quickly remove the ADB package from the system

rem @echo.
rem @echo   The sequence G-FF means you should first select option G,
rem @echo   then option FF. Similarly, J-A-d means you should first select option J,
rem @echo   then option A, and then enter (add) parameter d.
rem @echo   The keys u, c, a, b can be used as parameters when starting the Quas program, for example:
rem @echo   quas_v5.2.0.eng.exe b
rem EndEngTextBlock
call :_ColorTest
call :_exitwindow
exit /b

:_shellmenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ ТЕСТИРОВАНИЯ И ДИАГНОСТИКИ
@echo        ===============================
@echo.
@echo    A.  Перезапуск оболочки и виртуального окружения шлема
@echo    C.  Управление Wi-Fi на шлеме				
@echo    D.  Интерактивный тест подключения шлема к ПК
@echo    E.  Управление Защитной системой
@echo    F.  Управление датчиком приближения
@echo    G.  Устранить проблему перезагрузки кнопками громкости (удалить KeyMapper)
@echo    H.  Перезапуск ADB сервера на ПК
@echo    J.  Выполнение команд Fastboot
@echo    K.  Восстановить настройки отключения экрана (screen timeout)
@echo    L.  Отмена авторизации шлема на текущем ПК (удаление ключей ADB)
@echo    N.  Проверка исправности кабеля
@echo.   O.  Проверка исправности камер (Только Quest 2)
@echo    P.  Измерение скорости Wi-Fi между шлемом и ПК	[EXP]
@echo.   Q.  Статистика сетевых подключений (netstat)
@echo    R.  Диагностика дисплея 
@echo    S.  Управление параметрами Планирование GPU, Аппаратное ускорение и Игровой режим
@echo    T.  Проверка статуса загрузки шлема
@echo    U.  Мониторинг нагрузки и диагностика компонентов	[EXP]
@echo    V.  Информация об использовании памяти
@echo    W.  Мониторинг загрузки CPU в реальном времени
@echo.
@echo    X.  Открыть консоль cmd
@echo    Z.  Помощь в решении проблем.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        TESTING AND DIAGNOSTICS MENU
rem @echo        ===============================
rem @echo.
rem @echo    A.  Restarting the headset shell and vr environment
rem @echo    C.  Managing Wi-Fi on the headset
rem @echo    D.  Interactive test of connecting the headset to the PC
rem @echo    E.  Managing the Guardian
rem @echo    F.  Proximity sensor management
rem @echo    G.  Fix volume button reboot issue (remove KeyMapper)
rem @echo    H.  Restart ADB server on PC
rem @echo    J.  Starting Fastboot commands
rem @echo    K.  Restore screen timeout settings
rem @echo    L.  Cancel headset authorization on this PC (remove ADB keys)
rem @echo    N.  Cable functionality check
rem @echo.   O.  Camera functionality check (Quest 2 only)
rem @echo    P.  Measure Wi-Fi speed between the headset and PC [EXP]
rem @echo.   Q.  Network connection statistics (netstat)
rem @echo    R.  Display diagnostics
rem @echo    S.  Management parameters Hardware Acceleration and Game Mode
rem @echo    T.  Check boot status
rem @echo    U.  Load monitoring and component diagnostics [EXP]
rem @echo    v.  Memory usage information
rem @echo    W.  Realtime CPU monitoring
rem @echo.
rem @echo    X.  Open cmd console
rem EndEngTextBlock
@echo.    
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _shellmenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _shellrestartMenu)
rem if /i "%choice%"=="b" (GOTO _shellrestart2)
if /i "%choice%"=="c" (GOTO _wificontrol)
if /i "%choice%"=="d" (GOTO _interacttestconnect)
if /i "%choice%"=="e" (GOTO _guardian)
if /i "%choice%"=="f" (GOTO _proxsensor)
if /i "%choice%"=="g" (GOTO _deletekm)
if /i "%choice%"=="h" (GOTO _ADBServerRestart)
rem if /i "%choice%"=="i" (GOTO _adbintegr)
if /i "%choice%"=="j" (GOTO _FastbootCommandList)
if /i "%choice%"=="k" (GOTO _scrtimeout)
if /i "%choice%"=="l" (GOTO _ADBKeysDeleteMenu)
if /i "%choice%"=="n" (GOTO _TestVrUsvCopy)
if /i "%choice%"=="o" (GOTO _camtest)
if /i "%choice%"=="p" (call :_CyrillicPathCheckAll&&GOTO _iperftest)
rem if /i "%choice%"=="p" (GOTO _iperftest)
if /i "%choice%"=="pt" (cls && GOTO _WiFiTestCSVAnalyzer)
if /i "%choice%"=="q" (GOTO _shownetstatall)
if /i "%choice%"=="r" (GOTO _displaydiagmain)
if /i "%choice%"=="s" (GOTO _hwagamecontrol)
if /i "%choice%"=="t" (GOTO _bootstatusviewermenu)
if /i "%choice%"=="u" (GOTO _alltempmenu)
if /i "%choice%"=="v" (GOTO _MemoryUsageInfo)
if /i "%choice%"=="w" (GOTO _CPURealTimeMonitoring)
if /i "%choice%"=="x" (GOTO _opencmd)
@cls
goto _shellmenu


:_interacttestconnect
cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo.   1.  После запуска теста будет показан текущий статус соединения %_fBYellow%(connected / disconnected)%_fReset%
@echo    2.  Подключите или отключите кабель от ПК к шлему
@echo    3.  Наблюдайте за изменением состояния соединения %_fBYellow%(connected / disconnected)%_fReset%
@echo        При отключении кабеля вы должны увидеть сообщение %_fBYellow%disconnected%_fReset%
@echo        При подключении кабеля - %_fBYellow%connected%_fReset%
@echo    4.  Если статус соединения не меняется, замените кабель или попробуйте другой USB порт.
@echo.
@echo    Для завершения теста нажмите клавиши %_fBYellow%Q%_fReset% или %_fBYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.   1.  After starting the test, the current connection status will be shown %_fBYellow%(connected / disconnected)%_fReset%
rem @echo    2.  Connect or disconnect the cable from the PC to the headset
rem @echo    3.  Observe the change in the connection status %_fBYellow%(connected / disconnected)%_fReset%
rem @echo        When disconnecting the cable you should see the message %_fBYellow%disconnected%_fReset%
rem @echo        When connecting the cable - %_fBYellow%connected%_fReset%
rem @echo    4.  If the connection status does not change, replace the cable or try another USB port.
rem @echo.
rem @echo    To end the test, press the keys %_fBYellow%Q%_fReset% or %_fBYellow%Esc%_fReset%
rem EndEngTextBlock
@echo %_fBCyan%
powershell -NoProfile -ExecutionPolicy Bypass -NoLogo -File %myfiles%\dis-connect.ps1
@echo %_fReset%
call :_prevmenu
goto _shellmenu



:_ShellRestartMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ ПЕРЕЗАПУСКА ОБОЛОЧКИ И ВИРТУАЛЬНОГО ОКРУЖЕНИЯ
@echo        ==================================================
@echo.
@echo    A.  Перезапуск оболочки шлема
@echo    B.  Перезапуск оболочки шлема (второй вариант)
@echo    C.  Принудительный старт нижней панели приложений
@echo    D.  Принудительный старт домашнего окружения шлема
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        VR ENVIRONMENT AND SHELL RESTART MENU
rem @echo        =====================================
rem @echo.
rem @echo    A.  Restarting the headset shell
rem @echo    B.  Restarting the headset shell (second option)
rem @echo    C.  Force start of the bottom application bar
rem @echo    D.  Forcing the start of the headset's home environment
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _ShellRestartMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _shellrestart)
if /i "%choice%"=="b" (GOTO _shellrestart2)
if /i "%choice%"=="c" (GOTO _homescreen)
if /i "%choice%"=="d" (GOTO _StartApplicationsPanel)
cls
goto _ShellRestartMenu

:_ADBKeysDeleteMenu
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       %_FBRed%ВНИМАНИЕ^^!%_FReset%
@echo.
@echo   %_FBYellow%Данное действие отменит авторизацию шлема на данном ПК.
@echo   После этого при подключении шлема вы не сможете использовать
@echo   команды ADB пока заново не разрешите в шлеме отладку по USB.
@echo.
@echo   Для подтверждения отмены авторизации и удаления ключей ADB
@echo   введите в строке запроса слово "%_FYellow%ok%_FReset%%_FBYellow%" без кавычек:%_FReset%
@echo.
@echo.
@Set /p choice="Введите "ok" без кавычек для подтверждения или 0 для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       %_FBRed%WARNING^^!%_FReset%
rem @echo.
rem @echo   %_FBYellow%This action will revoke the headset authorization on this PC.
rem @echo   After that, when connecting the headset, you won't be able to use
rem @echo   ADB commands until you re-allow USB debugging on the headset.
rem @echo.
rem @echo   To confirm the deauthorization and removal of ADB keys,
rem @echo   enter the word "%_FYellow%ok%_FReset%%_FBYellow%" without quotes in the prompt:%_FReset%
rem @echo.
rem @echo.
rem @Set /p choice="Enter "ok" without quotas to confirm or 0 to return to the menu: "
rem EndEngTextBlock
if not defined choice goto _ADBKeysDeleteMenu
if "%choice%"=="0" (GOTO _beginn)
if "%choice%"=="ok" (GOTO _ADBKeysDelete)
goto _ADBKeysDeleteMenu

:_ADBKeysDelete
%myfiles%\adb shell rm -rf /data/misc/adb/  1>nul 2>nul
@del /q /f %USERPROFILE%\.android\adbkey 1>nul 2>nul
@del /q /f %USERPROFILE%\.android\adbkey.pub 1>nul 2>nul
@taskkill /im adb.exe /f 1>nul 2>nul
@echo.
@echo   ======================
rem StartRusTextBlock
@echo    %_FBGreen%Авторизация отменена%_FReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_FBGreen%Authorization revoked%_FReset%
rem EndEngTextBlock
@echo   ======================
call :_prevmenu
goto _shellmenu


:_CPURealTimeMonitoring
set intervaltempsav=5
start "ADB Top" cmd /k %MYFILES%\adb shell top -m 20 -d 2
rem StartRusTextBlock
@echo   Результаты будут обновляться каждые две секунды
@echo   Мониторинг откроется в отдельно окне. Просто закройте его, когда захотите закончить.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Results will be updated every two seconds
rem @echo   Monitoring will open in a separate window. Simply close it when you want to finish.
rem EndEngTextBlock
call :_prevmenu
goto _shellmenu


:_StartApplicationsPanel
@%MYFILES%\adb shell monkey -p com.oculus.panelapp.kiosk -c android.intent.category.LAUNCHER 1 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Панель приложений запущена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The application panel is launched
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu


:_FastbootCommandList
cls
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Fasboot devices			: Проверка доступности устройства
@echo    B.  Fastboot oem device-info		: Собрать и сохранить OEM информацию устройства
@echo    C.  Fastboot getvar all (bootloader)	: Сохранить информацию об устройстве в режиме bootloader
@echo    D.  Fastboot getvar all (fastboot)	: Сохранить информацию об устройстве в режиме fastboot
@echo    E.  Fastboot continue		: Продолжить загрузку шлема
@echo    F.  Fastboot reboot-fastboot		: Перезагрузить шлем в режим Fastboot
@echo    G.  Fastboot reboot-recovery		: Перезагрузить шлем в режим Recovery
@echo    H.  Fastboot reboot-bootloader	: Перезагрузить шлем в режим Bootloader
@echo.
@echo    K. Информация о прошивке шлема, слотах загрузки, ревизии и батарее
@echo    S. Отключить сенсоры шлема (Only Meta Quest 3)
@echo    Q. Включить сенсоры шлема (Only Meta Quest 3)
@echo.
@echo.
@echo    ВАЖНО:
@echo    Перед выполнением команд в этом меню убедитесь, что устройство может на них отвечать.
@echo    Проверьте это с помощью пункта A - команды fastboot device
@echo.
@echo    %_fBRed%Сенсоры после перезагрузки не включаются автоматически^!%_fReset%
@echo    %_fBYellow%После отключения сенсоров шлем всякий раз перез загрузкой в окружение
@echo    будет просить вас нажать кнопку Питание для включения сенсоров.
@echo    Для того чтобы они снова были включены по умолчанию, воспользуйтесь
@echo    опцией %_fYellow%Q - Включить сенсоры шлема.%_fReset%


rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Fasboot devices                  : Check device availability
rem @echo    B.  Fastboot oem device-info         : Collect and save device OEM information
rem @echo    C.  Fastboot getvar all (bootloader) : Collect device information in bootloader mode
rem @echo    D.  Fastboot getvar all (gastboot)	  : Collect device information in fastboot mode
rem @echo    E.  Fastboot continue                : Continue headset boot
rem @echo    F.  Fastboot reboot-fastboot         : Reboot headset into Fastboot mode
rem @echo    G.  Fastboot reboot-recovery         : Reboot headset into Recovery mode
rem @echo    H.  Fastboot reboot-bootloader       : Reboot headset into Bootloader mode
rem @echo.
rem @echo    K. Headset Firmware and Boot Slot Information
rem @echo    S. Disable headset sensors (Only Meta Quest 3)
rem @echo    Q. Enable headset sensors (Only Meta Quest 3)
rem @echo.
rem @echo.
rem @echo    IMPORTANT:
rem @echo    Before executing the commands in this menu, make sure the device
rem @echo    is able to respond to them. Check this using option A - fastboot device commands.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _shellmenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _fbdevices)
if /i "%choice%"=="b" (GOTO _fbgetoeminfo)
if /i "%choice%"=="c" (GOTO _fbgetvarbl)
if /i "%choice%"=="d" (GOTO _fbgetvarfb)
if /i "%choice%"=="e" (GOTO _fbcontinue)
if /i "%choice%"=="f" (GOTO _fbrebootfb)
if /i "%choice%"=="g" (GOTO _fbrebootrc)
if /i "%choice%"=="h" (GOTO _fbrebootbl)
if /i "%choice%"=="k" (set "fastbotcommand=:_FastbootFirmwareExtractCont"&&call :_FastbootCheckDevice)
if /i "%choice%"=="s" (set "fastbotcommand=:_DisableHeadsetSensorsConfirm"&&call :_FastbootCheckDevice)
if /i "%choice%"=="q" (set "fastbotcommand=:_EnableHeadsetSensors"&&call :_FastbootCheckDevice)

rem if /i "%choice%"=="g" (GOTO _guardian)
rem if /i "%choice%"=="h" (GOTO _guardian)
goto _FastbootCommandList


:_fbdevices
rem StartRusTextBlock
@%MYFILES%\fastboot devices | findstr /i /c:"fastboot" || @echo ======================================== ^ & @echo +++ Шлем не отвечает на команды fastboot +++ & call :_prevmenu & goto _FastbootCommandList
rem EndRusTextBlock
rem StartEngTextBlock
rem @%MYFILES%\fastboot devices | findstr /i /c:"fastboot" || @echo ======================================== ^ & @echo +++ Headset is not responding to fastboot commands +++ & call :_prevmenu & goto _FastbootCommandList
rem EndEngTextBlock
call :_prevmenu
goto _FastbootCommandList

:_fbgetoeminfo
setlocal enableextensions enabledelayedexpansion
call :_settime
for /f "tokens=*" %%a in ('@%myfiles%\fastboot oem device-info 2^>^&1') do (
set txt=%%a
@echo !txt! >> oem-info-%dt%.txt
)
@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot oem-info выполнена
@echo.
@echo  ----------------------------------------------------------------------
@echo  = Информация oem info сохранена в файле oem-info-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot oem-info command executed
rem @echo.
rem @echo  ----------------------------------------------------------------------
rem @echo  = oem-info information saved in oem-info-%dt%.txt file
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _FastbootCommandList

:_fbgetvarbl
setlocal enableextensions enabledelayedexpansion
@%myfiles%\fastboot reboot-bootloader 1>nul 2>nul
@timeout 3 >nul
call :_settime
for /f "tokens=*" %%a in ('@%myfiles%\fastboot getvar all 2^>^&1') do (
set txt=%%a
@echo !txt! >> getvar-all-bootloader%dt%.txt
)
@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot getvar all выполнена
@echo.
@echo  ----------------------------------------------------------------------
@echo  = Информация getvar сохранена в файле getvar-all-bootloader%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot getvar command executed
rem @echo.
rem @echo  ----------------------------------------------------------------------
rem @echo  = getvar information saved in getvar-bootloader%dt%.txt file
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _FastbootCommandList

:_fbgetvarfb
rem StartRusTextBlock
@echo  = Подождите несколько секунд...
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Just a second..
rem @echo.
rem EndEngTextBlock
setlocal enableextensions enabledelayedexpansion
@%myfiles%\fastboot reboot-fastboot 1>nul 2>nul
@timeout 4 >nul
call :_settime
for /f "tokens=*" %%a in ('@%myfiles%\fastboot getvar all 2^>^&1') do (
set txt=%%a
@echo !txt! >> getvar-all-fastboot%dt%.txt
)
@%myfiles%\fastboot reboot-bootloader 1>nul 2>nul
@timeout 3 >nul
@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot getvar all выполнена
@echo.
@echo  ----------------------------------------------------------------------
@echo  = Информация getvar сохранена в файле getvar-all-fastboot%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot getvar command executed
rem @echo.
rem @echo  ----------------------------------------------------------------------
rem @echo  = getvar information saved in getvar-fastboot%dt%.txt file
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _FastbootCommandList

:_fbcontinue
@%myfiles%\Fastboot continue
@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot continue выполнена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot continue command executed
rem EndEngTextBlock
call :_prevmenu
goto _FastbootCommandList

:_fbrebootfb
rem @%myfiles%\Fastboot reboot-fastboot
@%myfiles%\Fastboot reboot-fastboot

@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot reboot-fastboot выполнена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot reboot-fastboot command executed
rem EndEngTextBlock
call :_prevmenu
goto _FastbootCommandList

:_fbrebootrc
@%myfiles%\Fastboot reboot-recovery
@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot reboot-recovery выполнена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot reboot-recovery command executed
rem EndEngTextBlock
call :_prevmenu
goto _FastbootCommandList

:_fbrebootbl
@%myfiles%\Fastboot reboot-bootloader
@echo.
@echo ---
rem StartRusTextBlock
@echo Команда Fastboot reboot-bootloader выполнена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Fastboot reboot-bootloader command executed
rem EndEngTextBlock
call :_prevmenu
goto _FastbootCommandList

rem :_GetvarReview
rem @%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul || @echo ======================================== ^ & @echo +++ Шлем не в режиме Booloader +++ & goto  _returnmenu
rem call :_settime
rem for /f %%a in ('@%myfiles%\fastboot getvar all') do (
rem set txt=%%a
rem echo %txt%>> getvar-all-%dt%.txt
rem )
rem @echo  ----------------------------------------------------------------------
rem @echo  = Информация getvar сохранена в файле getvar-all-%dt%.txt
rem @echo.
rem @echo  ----------------------------------------------------------------------
rem call :_prevmenu
rem goto _shellmenu

:_bootstatusviewermenu
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    S.  Проверить статус загрузки шлема  [EXP]
@echo.
@echo.
@echo.
@echo  Иногда в процессе загрузки шлем отображает лого или три точки, и непонятно, он уже загрузился
@echo  или еще нет. Данная процедура поможет выяснить на каком этапе застрял шлем.
@echo.
@echo  Это очень упрощенная проверка, не ожидайте слишком много. В будущем возможна доработка.
@echo.
@echo  Вкратце загрузка в систему Андроид состоит из нескольких этапов:
@echo.
@echo    1. Загрузчик (Bootloader)
@echo    2. Загрузчик ядра (Kernel)
@echo    3. Инициализация Android (init)
@echo    4. Запуск служб (Services)
@echo    5. Установка и запуск приложений (Applications)
@echo.
@echo  Проверка выполняется начиная с третьего пункта - Инициализация Android. В этот момент
@echo  становится доступным управление по ADB - первый этап проверки. Затем второй этап
@echo  проверки: Запуск служб и приложений. И третий этап - проверка окончательного завершения загрузки.
@echo.
@echo  Если после всего этого у вас на экране по-прежнему лого, три точки или просто серый экран,
@echo  попробуйте следующие варианты:
@echo.
@echo  1. Снять силиконовую или другую накладку (если она есть) с маски шлема 
@echo.
@echo  2. Загрузиться в USB Update Mode (так называемый "бутлоадер")
@echo     Выбрать там опцию Boot Device, подождать загрузки шлема минут 10
@echo     Повторить эту операцию трижды.
@echo.
@echo  3. Из Главного меню этой программы выберит пункт Е - Тестирование, диагностика...
@echo     В этом меню пробуйте пункты A, B, D.
@echo     Если не поможет, пробуйте:
@echo     Пункт E - отключите Защитную систему
@echo     Пункт F - отключите датчик приближения
@echo     Пункт С - отключите Wi-Fi
@echo     И на всякий случай, проверьте исправность камер, пункт O (Только для Quest 2)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    S.  Check headset loading status  [EXP]
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo  Sometimes during the loading process, the headset displays a logo or three dots,
rem @echo  and it's unclear if it has already loaded or not.
rem @echo  This procedure will help determine at what stage the headset is stuck.
rem @echo.
rem @echo This is a very simplified check, do not expect too much from it.
rem @echo  In brief, the Android system loading consists of several stages:
rem @echo.
rem @echo    1. Bootloader
rem @echo    2. Kernel Loader
rem @echo    3. Android Initialization (init)
rem @echo    4. Starting Services
rem @echo    5. Installing and Starting Applications
rem @echo.
rem @echo  The check is performed starting from the third point - Android Initialization.
rem @echo  At this moment, ADB control becomes available - the first stage of the check.
rem @echo  Then the second stage of the check: Starting services and applications.
rem @echo  And the third stage - checking the final loading completion.
rem @echo.
rem @echo  If after all this you still have a logo, three dots, or just a gray screen on the display,
rem @echo  try the following options:
rem @echo.
rem @echo  1. Remove the silicone or other cover (if any) from the headset mask.
rem @echo.
rem @echo  2. Boot into USB Update Mode (the so-called "bootloader", although it is not)
rem @echo     Select the Boot Device option there.
rem @echo     Perform this operation three times.
rem @echo.
rem @echo  3. From the Main menu of this program, select item E - Testing, Diagnostics...
rem @echo     In this menu, try items A, B, D.
rem @echo     If it does not help, try:
rem @echo     Item E - disable the Protection System.
rem @echo     Item F - disable the proximity sensor.
rem @echo     Item C - disable Wi-Fi.
rem @echo     And just in case, check the functionality of the cameras, item O (Only for Quest 2).
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _bootstatusviewer
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="s" (GOTO _bootstatusviewer)
goto _bootstatusviewer
cls

:_bootstatusviewer
cls
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        Проверка статуса загрузки шлема
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        Checking headset loading status
rem EndEngTextBlock
@echo        ===============================
@echo.
@echo.
@echo.
@echo.
@echo   ------------------------------------------------------
@%myfiles%\adb devices | findstr "device"$ 1>nul 2>nul
if %errorlevel% == 0 (
rem StartRusTextBlock
@echo   = ADB доступен. Первичный этап загрузки завершен
) else (
@echo   = ADB недоступен, шлем в процессе загрузки
@echo.
@echo.
@echo.
@echo ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = ADB is available. Primary loading stage completed
rem ) else (
rem @echo   = ADB is not available, headset is in the loading process
rem @echo.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press any key to interrupt ^<^<^<
rem EndEngTextBlock
goto _updatebootstatus
)
@echo.
for /f %%c in ('@%myfiles%\adb shell getprop service.bootanim.exit_vendor 2^>nul') do set exitvendorbootstatus=%%c
if [%exitvendorbootstatus%] NEQ [1] (
@echo   ------------------------------------------------------
rem StartRusTextBlock
@echo   = Шлем в статусе загрузочной анимации. Загрузка шлема не завершена.
@echo.
@echo.
@echo.
@echo ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = headset is in loading animation status. headset loading is not complete.
rem @echo.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press any key to interrupt ^<^<^<
rem EndEngTextBlock
goto _updatebootstatus
) else (
@echo   ------------------------------------------------------
rem StartRusTextBlock
@echo   = Этап загрузочной анимации завершен успешно
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Loading animation stage completed successfully
rem EndEngTextBlock
)
@echo.
for /f %%d in ('@%myfiles%\adb shell getprop init.svc.bootanim 2^>nul') do set bootanimbootstatus=%%d
if [%bootanimbootstatus%] NEQ [stopped] (
@echo   ------------------------------------------------------
rem StartRusTextBlock
@echo   = Шлем в процессе загрузки в Виртуальное окружение
@echo.
@echo.
@echo.
@echo ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
) else (
@echo   ------------------------------------------------------
@echo   === Загрузка шлема полностью завершена ===
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = headset is in the process of loading into Virtual Environment
rem @echo.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press any key to interrupt ^<^<^<
rem ) else (
rem @echo   ------------------------------------------------------
rem @echo   === headset loading is fully completed ===
rem EndEngTextBlock
@echo.
@echo.
call :_prevmenu
goto _shellmenu
)
@echo.
@echo.
:_updatebootstatus
rem StartRusTextBlock
timeout 1| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & call :_prevmenu ^ & @goto _shellmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem timeout 1| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure was interrupted +++ ^ & @echo. ^ & call :_prevmenu ^ & @goto _shellmenu
rem EndEngTextBlock
set adbdevicebootstatus=
set bootanimbootstatus=
set exitvendorbootstatus=
goto _bootstatusviewer

:_AdditionalOptionsMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo        МЕНЮ ДОПОЛНИТЕЛЬНЫХ ОПЦИЙ
@echo        =========================
@echo.
@echo    A.  Смена имени пользователя
@echo    B.  Показать скрытые настройки
@echo    C.  Устранение ошибки OpenSSL SHA Crash Bug
@echo    D.  Перезапуск сервиса OVRService на ПК
@echo    E.  Открыть в шлеме настройки VPN
@echo    F.  Установить высокий приоритет сервисам Oculus (только Windows 10 и ниже)
@echo    G.  Комплексная установка приложения Oculus Wireless ADB
@echo    H.  Управление ключами реестра для запуска Quas
@echo    I.  Управление приложения Социальной платформы
@echo    J.  Решение проблемы с файлами fba
@echo    K.  Включить экран и отключить датчик приближения
@echo    L.  Удаление старых файлов и каталогов Quas
@echo    N.  Открыть файл hosts в редакторе Notepad
@echo    O.  Узнать код сопряжения с мобильным приложением
@echo    P.  Создание расшаренного ресурса на ПК
@echo    Q.  Отключение и включение проверки подписи драйверов
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        ADDITIONAL OPTIONS MENU
rem @echo        =========================
rem @echo.
rem @echo    A.  Change global username
rem @echo    B.  Show hidden settings
rem @echo    C.  Fixing the OpenSSL SHA Crash Bug
rem @echo    D.  Restarting the OVRservice service on PC
rem @echo    E.  Open VPN settings on the headset
rem @echo    F.  Set high priority for Oculus services (only Windows 10 and below)
rem @echo    G.  Oculus Wireless ADB complex	[EXP]
rem @echo    H.  Managing registry keys for application startup
rem @echo    I.  Social Platform management
rem @echo    J.  Solution to the problem with fba files
rem @echo    K.  Turn on the screen and disable the proximity sensor
rem @echo    L.  Delete old Quas files and directories
rem @echo    N.  Open the hosts file in Notepad
rem @echo    O.  Get the pairing code for the mobile app
rem @echo    P.  Creating a shared resource on a PC
rem @echo    Q.  Disable and enable driver signature enforcement

rem EndEngTextBlock
@echo.    
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _AdditionalOptionsMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _changeusernamemenu)
if /i "%choice%"=="b" (GOTO _startsettings)
if /i "%choice%"=="c" (GOTO _opensslerrorfix)
if /i "%choice%"=="d" (GOTO _ocsrvrestart)
if /i "%choice%"=="e" (GOTO _openvpn)
if /i "%choice%"=="f" (GOTO _setpriority)
if /i "%choice%"=="g" (GOTO _OculusWirelessADBcomplex)
if /i "%choice%"=="h" (GOTO _RegistryKeysSettings)
if /i "%choice%"=="i" (GOTO _SocialPControl)
if /i "%choice%"=="j" (GOTO _fbafixmenu)
if /i "%choice%"=="k" (GOTO _DispProxOn)
if /i "%choice%"=="l" (GOTO _DeleteOldQuasFilesMenu)
if /i "%choice%"=="n" (GOTO _OpenHosts)
if /i "%choice%"=="o" (GOTO _CheckConnectDeviceSetSerial)
if /i "%choice%"=="p" (GOTO _setshare)
if /i "%choice%"=="q" (GOTO _SignCheckControlMenu)
@cls
goto _AdditionalOptionsMenu

:_SignCheckControlMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo        КОРНТРОЛЬ ПРОВЕРКИ ПОДПИСИ ДРАЙВЕРОВ
@echo        ====================================
@echo.
@echo    A.  Отключить проверку подписи драйверов (%_fRed%не рекомендуется%_fReset%)
@echo    B.  Включить проверку подписи драйверов
@echo    C.  Перезагрузитиь ПК в режим восстановления (%_fBGreen%рекомендуется%_fReset%)
@echo.
@echo.
@echo      %_fBRed%ВАЖНО:
@echo.
@echo   %_fRed%Отключение проверки подписи драйверов пунктом A - %_fBRed%НЕ РЕКОМЕНДУЕТСЯ^^!
@echo   %_fRed%Это снизит уровень безопасности вашего компьютера. И если что-то пойдет не так,
@echo   система останется в тестовом режиме. Делайте это на свой страх и риск и только временно.
@echo   После того, как установите неподписанные драйверы, сразу же включите проверку подписи.%_fReset%
@echo.
@echo   Для применения изменений требуется обязательная перезагрузка компьютера. После отключения
@echo   проверки и перезагрузки ПК на Рабочем столе появится надпись %_fBYellow%"Test mode".
@echo.
@echo   Для работы с этими опциями требуются права администратора.
@echo.
@echo   %_fBCYan%Для отключения подписи драйверов используйте режим восстановления, это безопасно.
@echo   Выберите %_fBGreen%пункт C%_fBCYan% и после загрузки компьютера в режим восстановления последовательно
@echo   нажмимайте плитки (%_fBGreen%сделайте снимок этих пунктов на телефон%_fBCYan%):
@echo.
@echo      %_fBYellow%1. Поиск и устранение неисправностей
@echo      2. Дополнительные параметры
@echo      3. Параметры загрузки
@echo      4. Перезагрузить
@echo      После перезагрузки выберите пункт %_fYellow%7:
@echo   	Отключить обязательную проверку подписи драйверов
@echo.
@echo   %_fBCYan%После этого система перезагрузится в режим с отключенной проверкой подписи и можно установить
@echo   неподписанный драйвер. Следующая перезагрузка автоматически вернет систему в обычное состояние
@echo   и проверка подписи сама включится обратно.
@echo   %_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        DRIVER SIGNATURE ENFORCEMENT CONTROL
rem @echo        ===================================
rem @echo.
rem @echo    A.  Disable driver signature enforcement (%_fRed%not recommended%_fReset%)
rem @echo    B.  Enable driver signature enforcement
rem @echo    C.  Reboot the PC into recovery mode (%_fBGreen%recommended%_fReset%)
rem @echo.
rem @echo.
rem @echo      %_fBRed%IMPORTANT:
rem @echo.
rem @echo   %_fRed%Disabling driver signature enforcement using option A is %_fBRed%NOT RECOMMENDED^^!
rem @echo   %_fRed%This will reduce the security level of your computer. If something goes wrong,
rem @echo   the system will remain in test mode. Do this at your own risk and only temporarily.
rem @echo   After installing unsigned drivers, immediately re-enable signature enforcement.%_fReset%
rem @echo.
rem @echo   Applying the changes requires a mandatory reboot of the computer. After disabling
rem @echo   enforcement and rebooting the PC, the %_fBYellow%"Test mode"%_fReset% label will appear on the Desktop.
rem @echo.
rem @echo   Administrator privileges are required to use these options.
rem @echo.
rem @echo   %_fBCYan%To disable driver signature enforcement, use recovery mode — this is safe.
rem @echo   Select %_fBGreen%option C%_fBCYan%, and after the computer boots into recovery mode, sequentially
rem @echo   select the following tiles (%_fBGreen%take a photo of these steps on your phone%_fBCYan%):
rem @echo.
rem @echo      %_fBYellow%1. Troubleshoot
rem @echo      2. Advanced options
rem @echo      3. Startup Settings
rem @echo      4. Restart
rem @echo      After reboot, select option %_fYellow%7:
rem @echo      Disable driver signature enforcement
rem @echo.
rem @echo   %_fBCYan%After that, the system will reboot into normal mode with signature enforcement disabled,
rem @echo   and you can install the unsigned driver.
rem @echo   After the next normal reboot, signature enforcement will be enabled again automatically%_fReset%
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _SignCheckControlMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _SignCheckControlOff)
if /i "%choice%"=="b" (GOTO _SignCheckControlOn)
if /i "%choice%"=="c" (GOTO _RebootPCRecoveryMode)
goto _SignCheckControlMenu


:_SignCheckControlOff
setlocal enableextensions enabledelayedexpansion
call :_CheckAdminRights
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto _SignCheckControlMenu
if "!KEY!"=="13" powershell -Command "Start-Process bcdedit -ArgumentList '/set testsigning on' -Verb RunAs"
goto _SignCheckControlMenu

rem powershell -Command "Start-Process bcdedit -ArgumentList '/set testsigning on' -Verb RunAs"


:_SignCheckControlOn
setlocal enableextensions enabledelayedexpansion
call :_CheckAdminRights
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto _SignCheckControlMenu
if "!KEY!"=="13" powershell -Command "Start-Process bcdedit -ArgumentList '/set testsigning off' -Verb RunAs"
goto _SignCheckControlMenu

:_RebootPCRecoveryMode
setlocal enableextensions enabledelayedexpansion
call :_CheckAdminRights
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения перезагрузки нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For reboot confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto :_SignCheckControlMenu
if "!KEY!"=="13" goto _StartShutdown

:_StartShutdown
start "" shutdown /f /r /o /t 0 
goto :_SignCheckControlMenu


:_SignCheckControlStatus


:_CheckConnectDeviceSetSerial
set serial=
@for /f "tokens=1" %%i in ('%MYFILES%\fastboot devices ^| findstr /i /c:"fastboot"') do (set serial=%%i)
if not defined serial (
@For /F %%a In ('%MYFILES%\adb shell getprop ro.boot.serialno 2^<nul') Do (set serial=%%a)
if not defined serial goto :_SetSerialNumber
@echo.
@echo.
@echo.
@echo   ---------------------------------------
rem StartRusTextBlock
@echo    %_FBGreen%Шлем обнаружен%_FReset%
@echo    %_FBYellow%Определяем код сопряжения...%_FReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_FBGreen%Headset detected%_FReset%
rem @echo    %_FBYellow%Determining pairing code...%_FReset%
rem EndEngTextBlock
@echo   ---------------------------------------
goto _CheckValidSerial

:_SetSerialNumber
cls
@echo.
@echo.
@echo.
@echo   =============================================
rem StartRusTextBlock
@echo               %_FBred%Шлем не обнаружен
@echo    %_FBYellow%Автоматическое определение кода невозможно%_FReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo               %_FBred%Headset not detected
rem @echo    %_FBYellow%Automatic code detection is not possible%_FReset%
rem EndEngTextBlock
@echo   ============================================
@echo.
@echo.
@echo.

rem StartRusTextBlock
@Set /p setserial="  Введите или вставьте серийный номер и нажмите Enter (0 - Выход в меню): "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p setserial="  Enter or paste the serial number and press Enter (0 - Return to menu): "
rem EndEngTextBlock

if not defined setserial goto _SetSerialNumber
if "%setserial%"=="0" (GOTO _beginn)
set serial=%setserial%

:_CheckValidSerial
if "%serial:~0,4%" == "2G0Y" (
set "modeltype=Meta Quest 3"
goto :_ViewPairingCode
) else (
if "%serial:~0,4%" == "1WMH" (
set "modeltype=Meta Quest 2"
goto :_ViewPairingCode
) else (
if "!serial:~0,4!" == "1PAS" (
set "modeltype=Meta Quest 1"
goto :_ViewPairingCode
) else (
if "!serial:~0,3!" == "340Y" (
set "modeltype=Meta Quest 3S"
goto :_ViewPairingCode
) else (
if "!serial:~0,3!" == "230Y" (
set "modeltype=Meta Quest Pro"
goto :_ViewPairingCode
)
)
)
)
)
)
@echo.
@echo.
@echo.
@echo   ===========================================================================
rem StartRusTextBlock
@echo    %_fBRed%Невозможно определить код сопряжения
@echo    Проверьте правильность ввода серийного номера или подключение шлема к ПК.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBRed%Unable to determine the pairing code
rem @echo    Check the correctness of the serial number input or the headset connection to the PC.%_fReset%
rem EndEngTextBlock
@echo   ===========================================================================
@echo.
@echo.
goto _returnmenu

:_ViewPairingCode
for /f %%i in ('powershell -ExecutionPolicy Bypass -File "%myfiles%\pcode.ps1" -serial "%SERIAL%"') do set pairingcode=%%i
@echo.
@echo.
@echo   =======================================
rem StartRusTextBlock
@echo    %_fCyan%Модель шлема		: %_fBCyan%%modeltype%%_fReset%
@echo    %_fCyan%Серийный номер	: %_fBCyan%%serial%%_fReset%
@echo    %_fCyan%Код сопряжения	: %_fBGreen%%pairingcode%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fCyan%Headset Model        : %_fBCyan%%modeltype%%_fReset%
rem @echo    %_fCyan%Serial Number        : %_fBCyan%%serial%%_fReset%
rem @echo    %_fCyan%Pairing Code         : %_fBGreen%%pairingcode%%_fReset%
rem EndEngTextBlock
@echo   =======================================
goto _returnmenu

:_OpenHosts
rem StartRusTextBlock
@echo   --------------------------------------------------------
@echo   %_fBYellow%Через секунду файл %_fCyan%hosts%_fReset% %_fBYellow%будет открыт%_fReset%
@echo   ---
@echo   %_fBRed%Для сохранения изменений в файле %_fCyan%hosts%_fReset% 
@echo   %_fBRed%программа Quas должна быть открыта с правами администратора^!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%The hosts file will be opened in a second%_fReset%
rem @echo   ---
rem @echo   %_fBRed%To save changes to the %_fCyan%hosts file%_fReset%,
rem @echo   the Quas program must be run with administrator rights%_fReset%
rem EndEngTextBlock
@echo   --------------------------------------------------------
start "" notepad %WINDIR%\system32\drivers\etc\hosts
goto _returnmenu

:_DeleteOldQuasFilesMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  Почистить старые файлы и каталоги Quas
@echo.
@echo.
@echo.
@echo        Будут удалены каталоги вида qbE73C0B.5B и старые файлы cmd
@echo        иногда остающиеся в каталоге Temp после работы с Quas.
@echo.
@echo        После выбора опции А и нажатия Enter будет выполнен выход из программы 
@echo        для корректной работы процедуры.
@echo        По завершению просто запустите программу Quas снова.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Clean up old Quas files and directories
rem @echo.
rem @echo.
rem @echo.
rem @echo        Directories like qbE73C0B.5B and old cmd files
rem @echo        occasionally left in the Temp folder after working with Quas
rem @echo        will be deleted.
rem @echo.
rem @echo        After selecting option A and pressing Enter, the program will exit
rem @echo        to ensure proper execution of the cleanup procedure.
rem @echo        After completion, simply restart the Quas program.
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _DeleteOldQuasFilesMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _DeleteOldQuasFiles)
@cls
goto _DeleteOldQuasFilesMenu

:_DeleteOldQuasFiles
@echo off
set "perc=%%%"
@echo @Echo Off ^&Cls >second.cmd
@echo @CHCP 866 1^>nul >>second.cmd
rem @echo Set "BoxIn=c:\Temp" >>second.cmd
@echo Set "BoxIn=%perc%USERPROFILE%perc%\AppData\Local\Temp" >>second.cmd
@echo For /f "usebackq delims=" %%%%d IN (`2^^^>nul Dir /A:D /B /S "%perc%BoxIn%perc%\"^^^|findstr /R "\\qb[0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z]\.[0-9,A-Z][0-9,A-Z]$"`) Do @rd /q /s %%%%d >>second.cmd
@echo For /f "usebackq delims=" %%%%d IN (`2^^^>nul Dir /A:D /B /S "%perc%BoxIn%perc%\"^^^|findstr /R "\\qb[0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z]\.[0-9,A-Z][0-9,A-Z]$"`) Do @rd /q /s %%%%d >>second.cmd
@echo For /f "usebackq delims=" %%%%f IN (`2^^^>nul Dir /A:-D /B /S "%perc%BoxIn%perc%\"^^^|findstr /R "\\[0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z][0-9,A-Z]\.cmd$"`) Do @del /AH /q /f %%%%f >>second.cmd
@echo @CHCP 65001 1^>nul >>second.cmd
@echo start /b "" cmd /c del "%perc%~f0"^&exit /b >>second.cmd
@start "" cmd /c second.cmd
exit


:_DispProxOn
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
rem StartRusTextBlock
@echo   ======================================================
@echo   = Датчик приближения отключен
@echo   = Дисплей включен
@echo.
@echo   ======================================================
@echo.
@echo   +++ Расход аккумулятора в этом режиме очень большой! +++
@echo       Не забудьте включить датчик приближения обратно.
@echo       Это можно сделать из Главного меню, пункты E-F. 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ======================================================
rem @echo   = Proximity sensor disabled
rem @echo   = Display enabled
rem @echo.
rem @echo   ======================================================
rem @echo.
rem @echo   +++ Battery consumption in this mode is very high! +++
rem @echo       Don’t forget to re-enable the proximity sensor.
rem @echo       This can be done from the Main Menu, options E-F.
rem EndEngTextBlock
call :_prevmenu
goto _AdditionalOptionsMenu

:_fbafixmenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    F.  Прекратить спам файлов fba
@echo    S.  Поиск файлов fba на системном диске
@echo    P.  Ограничить права доступа к файлу RemoteDesktopCompanion.exe
@echo.
@echo.
@echo.
@echo    ПРИМЕЧАНИЕ:
@echo.
@echo       Файлы fba создает процесс RemoteDesktopCompanion.exe, который отвечает
@echo       за подключение приложения Remote Desktop в шлеме.
@echo       Это приложение от компании Meta, и если вы им не пользуетесь и не планируете
@echo       пользоваться в будущем, его можно спокойно отключить.
@echo.
@echo       Процедура ненадолго остановит сервис Oculus, переименует файл
@echo       RemoteDesktopCompanion.exe в RemoteDesktopCompanion.exe.old
@echo       и снова запустит сервис. Также она удалит все файлы fba на системном диске
@echo       и из несколькоих каталогов. Все действия сопровождаются пояснениями.
@echo.
@echo   УДАЛЕНИЕ МОЖЕТЬ ЗАНЯТЬ МНОГО ВРЕМЕНИ, БУДЬТЕ К ЭТОМУ ГОТОВЫ И НАБЕРИТЕСЬ ТЕРПЕНИЯ
@echo.
@echo       Ограничение прав доступа к файлу RemoteDesktopCompanion.exe не даст программе
@echo       Meta Link обновить этот файл при обновлении ПО. В ином случае файл обновится
@echo       вместе с ПО и спам файлами fba продолжится.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    F.  Stop fba file spam
rem @echo    S.  Search for fba files on the system disk
rem @echo    P.  Restrict access rights to the RemoteDesktopCompanion.exe file
rem @echo.
rem @echo.
rem @echo.
rem @echo    NOTE:
rem @echo.
rem @echo       fba files are created by the RemoteDesktopCompanion.exe process, which is responsible
rem @echo       for the connection of the Remote Desktop application on the headset.
rem @echo       This application is from Meta, and if you do not use it and do not plan to use it
rem @echo        in the future, it can be safely disabled.
rem @echo.
rem @echo       The procedure will temporarily stop the Oculus service, rename the file
rem @echo       RemoteDesktopCompanion.exe to RemoteDesktopCompanion.exe.old,
rem @echo       and will restart the service again. It will also delete all fba files on the system disk
rem @echo       and from several directories. All actions are accompanied by explanations.
rem @echo.
rem @echo   DELETION MAY TAKE A LONG TIME, BE PREPARED FOR THIS AND BE PATIENT.
rem @echo.
rem @echo       Restricting access rights to the RemoteDesktopCompanion.exe file will prevent 
rem @echo       the Meta Link program from updating this file during software updates. 
rem @echo       Otherwise, the file will be updated along with the software, 
rem @echo       and the fba file spam will continue.
rem @echo.

rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
if not defined choice goto _fbafixmenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="f" (GOTO _fbafix)
if /i "%choice%"=="s" (GOTO _fbasearching)
if /i "%choice%"=="p" (GOTO _fbarightaccess)
cls
goto _fbafixmenu


:_fbarightaccess
For /f "tokens=3" %%a in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\OVRService /v ImagePath 2^>nul') do set imagepath=%%a
@set mlpath=%imagepath:~1,1%
@echo  -------------------------
rem StartRusTextBlock
if not exist "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" (@echo  = Файл RemoteDesktopCompanion.exe отсутствует&&@call :_prevmenu&&goto _fbafixmenu)
@icacls "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" /deny "NT SERVICE\OVRLibraryService":F 1>nul
@icacls "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" /deny "*S-1-5-11":F 1>nul
@echo  ---
@echo  = Права ограничены 
rem EndRusTextBlock
rem StartEngTextBlock
rem if not exist "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" (@echo  = RemoteDesktopCompanion.exe file is missing&&@call :_prevmenu&&goto _fbafixmenu)
rem @icacls "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" /deny "NT SERVICE\OVRLibraryService":F 1>nul
rem @icacls "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" /deny "NT AUTHORITY\Authenticated Users":F 1>nul
rem @echo  ---
rem @echo  = Rights restricted
rem EndEngTextBlock
@taskkill /F /IM RemoteDesktopCompanion.exe 1>nul 2>nul
call :_prevmenu
goto _fbafixmenu


:_fbasearching
setlocal enabledelayedexpansion
@del fbadirlist.txt /q 1>nul 2>nul
@echo.
@echo.
rem StartRusTextBlock
@echo  -------------------------
@echo  = Поиск файлов fba на системном диске.. 
@echo    Это может занять некоторое время, будьте терпеливы.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Searching for fba files on the system drive.. 
rem @echo    This may take some time, please be patient.
rem EndEngTextBlock
for /f "delims=" %%a in ('dir /s /b /a-d %systemdrive%\fba*.json 2^>nul') do (
set "csvfile=%%~dpa"
rem set "csvfile=!csvfile:\=\\!"
@echo !csvfile!>>fbadirlistsrc.txt
)
if not exist fbadirlistsrc.txt (
@echo  ---
rem StartRusTextBlock
@echo  = Файлы fba не найдены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = No fba files found
rem EndEngTextBlock
@echo  ---
call :_prevmenu
goto _fbafixmenu
exit
)
chcp 866 >nul
@for /f "tokens=*" %%b in (fbadirlistsrc.txt) do (
@find /i "%%b" fbadirlist.txt 1>nul 2>nul || @echo del /q "%%bfba*.json">>fbadirlist.txt
)
@echo pause>>fbadirlist.txt
@del fbadirlistsrc.txt /q 1>nul 2>nul
chcp 65001 >nul
@echo  ---
rem StartRusTextBlock
@echo  = Поиск завершен
@echo    Список каталогов с файлами fba сохранен в файл fbadirlist.txt
@echo    Для удаления всех fba переименуйте этот файл в fbadirlist.cmd и запустите.
@echo.
@echo    Файлы fba из каталогов с названием на кириллице удалены НЕ БУДУТ.
@echo    Удалите их оттуда вручную.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Search completed
rem @echo    The list of directories containing fba files has been saved to fbadirlist.txt
rem @echo    To delete all fba files, rename this file to fbadirlist.cmd and run it.
rem @echo.
rem @echo    fba files in directories with names in Cyrillic WILL NOT be deleted.
rem @echo    Please remove them manually.
rem EndEngTextBlock
@echo  ---
call :_prevmenu
goto _fbafixmenu


:_fbafix
@echo  ========================================
For /f "tokens=3" %%a in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\OVRService /v ImagePath 2^>nul') do set imagepath=%%a
@set mlpath=%imagepath:~1,1%
rem StartRusTextBlock
if not exist "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" (@echo  = Файл RemoteDesktopCompanion.exe отсутствует&&@call :_prevmenu&&goto _fbafixmenu)
rem EndRusTextBlock
rem StartEngTextBlock
rem if not exist "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" (@echo  = Файл RemoteDesktopCompanion.exe file is missing&&@call :_prevmenu&&goto _fbafixmenu)
rem EndEngTextBlock
for %%F in ("%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe") do set rdfilesize=%%~zF
if [%rdfilesize%] == [0] (
rem StartRusTextBlock
@echo  = Заглушка уже установлена.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Stub is already installed.
rem EndEngTextBlock
call :_prevmenu
goto _fbafixmenu
)
rem StartRusTextBlock
@echo  = Остановка сервисов Oculus
@net stop OVRservice 1>nul 2>nul
@echo  = Переименование файла RemoteDesktopCompanion.exe
@ren "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" "RemoteDesktopCompanion.exe.old" 1>nul 2>nul
@echo  = Создание заглушки - пустого файла RemoteDesktopCompanion.exe
@fsutil file createnew "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" 0 2>nul 1>nul
@echo  = Удаление файлов fba из корня системного диска 
@del %SYSTEMDRIVE%\fba*.json /q 1>nul 2>nul
@echo  = Удаление файлов fba из каталога %WINDIR%\System32
@del %WINDIR%\System32\fba*.json /q 1>nul 2>nul
@echo  = Удаление файлов fba из подкаталогов Local и Roaming, включая Temp
CHCP 866 1>nul
@del "%USERPROFILE%\AppData\Local\fba*.json" /q /s 1>nul 2>nul
@del "%USERPROFILE%\AppData\Roaming\fba*.json"  /q /s 1>nul 2>nul
CHCP 65001 1>nul
@echo  = Запуск сервисов Oculus
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Stopping Oculus services
rem @net stop OVRservice 1>nul 2>nul
rem @echo  = Renaming RemoteDesktopCompanion.exe
rem @ren "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" "RemoteDesktopCompanion.exe.old" 1>nul 2>nul
rem @echo  = Creating a dummy - empty RemoteDesktopCompanion.exe file
rem @fsutil file createnew "%mlpath%:\Program Files\Oculus\Support\oculus-remote-desktop\RemoteDesktopCompanion.exe" 0 2>nul 1>nul
rem @echo  = Deleting fba files from the root of drive C
rem @del %SYSTEMDRIVE%\fba*.json /q 1>nul 2>nul
rem @echo  = Deleting fba files from the Local and Roaming directories, include Temp
rem CHCP 866 1>nul
rem @del "%USERPROFILE%\AppData\Local\fba*.json" /q /s 1>nul 2>nul
rem @del "%USERPROFILE%\AppData\Roaming\fba*.json"  /q /s 1>nul 2>nul
rem CHCP 65001 1>nul
rem @echo  = Starting Oculus services
rem EndEngTextBlock
@net start OVRservice 1>nul 2>nul
@echo  ========================================
rem StartRusTextBlock
@echo  Готово
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Done
rem EndEngTextBlock
@goto _returnmenu


:_SocialPControl
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    D.  Отключение Cоциальной платформы
@echo    E.  Включение Cоциальной платформы
@echo.
@echo.
@echo.
@echo.
@echo    ПРИМЕЧАНИЕ:
@echo.
@echo        К Социальной платформе относятся:
@echo        - Приложение Люди
@echo        - Приложение Мир Meta Horizon
@echo        - Группы в этих приложениях
@echo        - Сообщения в этих приложениях
@echo.
@echo    После отключения при загрузке шлема будет выводиться сообщение 
@echo    о недоступности Социальной платформы. 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    D.  Disable Social Platform
rem @echo    E.  Enable Social Platform
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo    NOTE:
rem @echo        The Social Platform includes:
rem @echo        - People app
rem @echo        - Meta Horizon World app
rem @echo        - groups in these apps
rem @echo        - messages in these apps
rem @echo.
rem @echo    After disabling, a message about the unavailability of the Social Platform 
rem @echo    will be displayed during headset loading.
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _socialpcontrol
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="d" (GOTO _socpdisable)
if /i "%choice%"=="e" (GOTO _socpenable)
@cls
goto _socialpcontrol

:_socpdisable
@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.socialplatform 1>nul 2>nul
@echo  ========================================
rem StartRusTextBlock
@echo  Социальная платформа отключена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Social Platform disabled
rem EndEngTextBlock
@goto _returnmenu

:_socpenable
@%MYFILES%\adb shell pm enable --user 0 com.oculus.socialplatform 1>nul 2>nul
rem StartRusTextBlock
@echo  ========================================
@echo  Социальная платформа включена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Social Platform enabled
rem EndEngTextBlock
@goto _returnmenu


:_ODTDefaultResetMenu
@cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo		0. Выход из программы
@echo		M. Выход в меню
@echo.
@echo	    Enter. Подтвердить сброс настроек
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo		0. Exit program
rem @echo		M. Exit menu
rem @echo.
rem @echo	    Enter. Confirm reset settings
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   ВАЖНО:
@echo.
@echo     При сбросе настроек будут перезапущены сервисы Oculus 
@echo     и удалены все параметры в разделе реестра HKCU\SOFTWARE\Oculus\RemoteHeadset
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   IMPORTANT:
rem @echo.
rem @echo     Resetting will restart Oculus services 
rem @echo     and deleted all settings in the registry key HKCU\SOFTWARE\Oculus\RemoteHeadset
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem set choice=
set "choice=1"
rem StartRusTextBlock
Set /p choice="Выберите опцию меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem Set /p choice="Choose menu option and press Enter: "
rem EndEngTextBlock
rem call :_MenuChoiceEnter
@echo.
if not defined choice goto _ODTDefaultResetMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="1" (GOTO _ODTDefaultReset)
goto _ODTDefaultResetMenu


:_ODTDefaultReset
@net stop OVRservice 1>nul 2>nul
@net start OVRservice 1>nul 2>nul
@if ERRORLEVEL == 1 GOTO _noodtreset
@reg delete "HKCU\SOFTWARE\Oculus\RemoteHeadset" /va /f 1>nul 2>nul
rem StartRusTextBlock
@echo  ==============================================
@echo  = Настройки сброшены к дефолтным установкам
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Settings reset to default settings
rem EndEngTextBlock
call :_prevmenu
goto _AdditionalOptionsMenu

:_noodtreset
@echo  ===========================================
rem StartRusTextBlock
@echo   +++ Сервисы Oculus отсутствуют на ПК +++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = +++ Oculus services missing on PC +++
rem EndEngTextBlock
call :_prevmenu
goto _AdditionalOptionsMenu

:_RegistryKeysSettings
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    A. Установить ключ "Bypass Info Table" в реестр
@echo    B. Установить ключ "Bypass Wireless Warning" в реестр
@echo    C. Установить ключ "Bypass Initial Status" в реестр
@echo    D. Установить ключ "iPerf Temp Dir" в реестр
@echo    E. Установить ключ "Backups Dir" в реестр

@echo.
@echo    G. Удалить ключ "Bypass Info table" из реестра
@echo    H. Удалить ключ "Bypass Wireless Warning" из реестра
@echo    I. Удалить ключ "Bypass Initial Status" из реестра
@echo    J. Удалить ключ "iPerf Temp Dir" из реестра
@echo    K. Удалить ключ "Backups Dir" из реестра
@echo.
@echo    T. Проверить наличие ключей в реестре
@echo    S. Описание ключей
@echo.
@echo    X. Удалить ветвь реестра Quas со всеми ключами (старыми и новыми)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A. Set the "Bypass Info Table" key in the registry
rem @echo    B. Set the "Bypass Wireless Warning" key in the registry
rem @echo    C. Set the "Bypass Initial Status" key in the registry
rem @echo    D. Set the "iPerf Temp Dir" key in the registry
rem @echo    E. Set the "Backups Dir" key in the registry
rem @echo.
rem @echo    G. Remove the "Bypass Info Table" key from the registry
rem @echo    H. Remove the "Bypass Wireless Warning" key from the registry
rem @echo    I. Remove the "Bypass Initial Status" key from the registry
rem @echo    J. Remove the "iPerf Temp Dir" key from the registry
rem @echo    K. Remove the "Backups Dir" key from the registry
rem @echo.
rem @echo    T. Check for the presence of keys in the registry
rem @echo    S. Keys description
rem @echo.
rem @echo    X. Remove the Quas registry branch with all keys (old and new)
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _RegistryKeysSettings
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _setbypassinfokey)
if /i "%choice%"=="b" (GOTO _setbypasswfattkey)
if /i "%choice%"=="c" (GOTO _setbypassinistatuskey)
if /i "%choice%"=="d" (GOTO _setiperfdirkey)
if /i "%choice%"=="e" (GOTO _setbackupsdirkey)


if /i "%choice%"=="g" (GOTO _delbypassinfokey)
if /i "%choice%"=="h" (GOTO _delbypasswfattkey)
if /i "%choice%"=="i" (GOTO _delbypassinistatuskey)
if /i "%choice%"=="j" (GOTO _deliperfdirkey)
if /i "%choice%"=="k" (GOTO _delbackupsdirkey)
if /i "%choice%"=="t" (GOTO _checkbypasskey)
if /i "%choice%"=="s" (call :_KeysExplain)
if /i "%choice%"=="x" (GOTO _deletehivequas)
goto _RegistryKeysSettings


:_KeysExplain
cls
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  Ключ "Bypass Info Table" позволяет не отображать информационную таблицу, и, соответственно,
@echo  пропустить некоторые начальные проверки шлема. Его можно установить в пункте A.
@echo.
@echo  Это существенно ускорит запуск программы Quas, ориентировочно на полторы секунды.
@echo  Вместо всего этого информационного барахла в левом верхнем углу программы
@echo  будет отображен буквенно-цветовой индикатор режима или статуса шлема.
@echo.
@echo  Ключ "Bypass Wireless Warning" позволит убрать предупреждающее окно, 
@echo  когда подключение установлено по Wi-Fi. 
@echo.
@echo  Ключ "Bypass Initial Status" полностью убирает все первичные проверки статуса шлема.
@echo  Программа стартует сразу. В этом режиме отсутствует информационная таблица,
@echo  а буквенно-цветовой индикатор будет таким: [NO]
@echo  Зачения индикаторов в любой момент можно узнать из Главного меню, пункт H.
@echo.
@echo  Ключ "iPerf Temp Dir" устанавливает папку "C:\Temp" каталогом запуска iPerf
@echo  на постоянной основе. После этого сервер iPerf будет запускаться только
@echo  из этого каталога.
@echo.
@echo  Ключ "Backups Dir" устанавливает каталог для бэкапов. После выбора опции
@echo  откроется окно выбора папки, укажите в нем каталог, где будут расположены
@echo  все создаваемые бэкапы. В дальнейшем при восстановлении из этих бэкапов
@echo  программа будет прежде всего искать архивы по этому пути.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The "Bypass Info Table" key allows skipping the display of the information table
rem @echo  and the initial headset checks. It can be set in section A.
rem @echo.
rem @echo  This speeds up the launch of the Quas program, approximately by one and a half seconds.
rem @echo  Instead of all this informational clutter, a letter-color indicator of the mode or status
rem @echo  of the headset will be displayed in the upper left corner of the program.
rem @echo.
rem @echo  The "Bypass Wireless Warning" key will remove the warning window
rem @echo  when the connection is established via Wi-Fi.
rem @echo.
rem @echo  The "Bypass Initial Status" key removes all initial headset status checks.
rem @echo  The program starts immediately. In this mode, the information table is absent,
rem @echo  and the letter-color indicator will be as follows: [NO]
rem @echo.
rem @echo  The "iPerf Temp Dir" key sets the "C:\Temp" folder as the iPerf launch directory
rem @echo  on a permanent basis. After that, the iPerf server will only launch
rem @echo  from this directory.
rem @echo.
rem @echo  The "Backups Dir" key sets the directory for backups. After selecting the option,
rem @echo  a folder selection window will open, where you should specify the directory
rem @echo  where all created backups will be stored. Later, when restoring from these backups,
rem @echo  the program will first look for archives in this path.
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_prevmenu
exit /b



:_setbypassinfokey
reg add "HKEY_CURRENT_USER\Software\Quas" /v BypassInfoTable /t REG_DWORD /d 0xb /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Bypass Info Table" записан в реестр
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Bypass Info Table" key is written to the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_setbypasswfattkey
reg add "HKEY_CURRENT_USER\Software\Quas" /v BypassWLWarning /t REG_DWORD /d 0xb /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Bypass Wireless Warning" записан в реестр
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Bypass Info Table" key is written to the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_setbypassinistatuskey
reg add "HKEY_CURRENT_USER\Software\Quas" /v BypassInitialStatus /t REG_DWORD /d 0xb /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Bypass Initial Status" записан в реестр
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Bypass Initial Status" key is written to the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings


:_setiperfdirkey
reg add "HKEY_CURRENT_USER\Software\Quas" /v iPerfTempDir /t REG_SZ /d "%SYSTEMDRIVE%\Temp" /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "iPerf Temp Dir" записан в реестр
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "iPerf Temp Dir" key is written to the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_setbackupsdirkey
set pathmode=folder
call :_SelectFileFolder SelectedFolder
if not defined SelectedFolder (
rem StartRusTextBlock
@echo Ключ "Backups Dir" не изменен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Backups Dir" key is not changed
rem EndEngTextBlock
call :_prevmenu
if defined backupmenureturn goto _RestoreMenu
goto _RegistryKeysSettings
)
reg add "HKEY_CURRENT_USER\Software\Quas" /v BackupsDir /t REG_SZ /d "%SelectedFolder%" /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Backups Dir" записан в реестр
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Backups Dir" key is written to the registry
rem EndEngTextBlock
call :_prevmenu
if defined backupmenureturn (
goto _RestoreMenu
) else (
goto _RegistryKeysSettings
)

:_delbypassinfokey
@reg delete "HKEY_CURRENT_USER\Software\Quas" /v BypassInfoTable /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Bypass Info Table" удален из реестра
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Bypass Info Table" key has been removed from the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_delbypasswfattkey
@reg delete "HKEY_CURRENT_USER\Software\Quas" /v BypassWLWarning /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Bypass Wireless Warning" удален из реестра
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Bypass Wireless Warning"" key has been removed from the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_delbypassinistatuskey
@reg delete "HKEY_CURRENT_USER\Software\Quas" /v BypassInitialStatus /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Bypass Initial Status" удален из реестра
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Bypass Initial Status" key has been removed from the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_deliperfdirkey
@reg delete "HKEY_CURRENT_USER\Software\Quas" /v iPerfTempDir /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "iPerf Temp Dir" удален из реестра
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "iPerf Temp Dir" key has been removed from the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings


:_delbackupsdirkey
@reg delete "HKEY_CURRENT_USER\Software\Quas" /v BackupsDir /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "Backups Dir" удален из реестра
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "Backups Dir" key has been removed from the registry
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings


:_checkbypasskey
set bpinfotable=
set bpwfatt=
set bpinitialstatus=
set iperfdir=
set backupsdir=
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BypassInfoTable 2^>nul') do set bpinfotable=%%a
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BypassWLWarning 2^>nul') do set bpwfatt=%%a
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BypassInitialStatus 2^>nul') do set bpinitialstatus=%%a
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v iPerfTempDir 2^>nul') do set iperfdir=%%a
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BackupsDir 2^>nul') do set backupsdir=%%a

@echo -----------------------------------------------------
rem StartRusTextBlock
@if [%bpinfotable%]==[] set "keyinfomess=Не установлен"
@if [%bpinfotable%]==[0xb] set "keyinfomess=Записан в реестре"
@if [%bpwfatt%]==[] set "keywfattmess=Не установлен"
@if [%bpwfatt%]==[0xb] set "keywfattmess=Записан в реестре"
@if [%bpinitialstatus%]==[] set "keyinistatus=Не установлен"
@if [%bpinitialstatus%]==[0xb] set "keyinistatus=Записан в реестре"
@if not defined iperfdir (set "keyiperfdir=Не установлен") else (set "keyiperfdir=%iperfdir%")
@if not defined backupsdir (set "keybackupsdir=Не установлен") else (set "keybackupsdir=%backupsdir%")
@echo Ключ Bypass Info Table		: %keyinfomess%
@echo Ключ Bypass Wireless Warning	: %keywfattmess%
@echo Ключ Bypass Initial Status	: %keyinistatus%
@echo Ключ iPerf Temp Dir		: %keyiperfdir%
@echo Ключ Backups Dir		: %keybackupsdir%
rem EndRusTextBlock
rem StartEngTextBlock
rem @if [%bpinfotable%]==[] set "keyinfomess=Not set"
rem @if [%bpinfotable%]==[0xb] set "keyinfomess=Written to registry"
rem @if [%bpwfatt%]==[] set "keywfattmess=Not set"
rem @if [%bpwfatt%]==[0xb] set "keywfattmess=Written to registry"
rem @if [%bpinitialstatus%]==[] set "keyinistatus=Not set"
rem @if [%bpinitialstatus%]==[0xb] set "keyinistatus=Written to registry"
rem @if not defined iperfdir (set "keyiperfdir=Not set") else (set "keyiperfdir=%iperfdir%")
rem @if not defined backupsdir (set "keybackupsdir=Not set") else (set "keybackupsdir=%backupsdir%")
rem @echo Bypass Info Table key		: %keyinfomess%
rem @echo Bypass Wireless Warning key	: %keywfattmess%
rem @echo Bypass Initial Status key	: %keyinistatus%
rem @echo iPerf Temp Dir key		: %keyiperfdir%
rem @echo Backups Dir key			: %keybackupsdir%
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_deletehivequas
@reg delete "HKEY_CURRENT_USER\Software\Quas" /f 1>nul 2>nul
@echo ---------------------------------------------
@echo.
rem StartRusTextBlock
@echo Ветвь HKEY_CURRENT_USER\Software\Quas удалена из реестра
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The branch HKEY_CURRENT_USER\Software\Quas has been removed from the registry.
rem EndEngTextBlock
call :_prevmenu
goto _RegistryKeysSettings

:_OculusWirelessADBcomplex
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    A. Установить приложение Oculus Wireless ADB
@echo    B. Установить приложение Bugjaeger ADB
@echo    C. Подключиться к шлему по порту 5555
@echo    D. Подключиться к шлему по случайному порту
@echo    E. Показать все соединения
@echo    F. Отключить все беспроводные соединения
@echo    G. Ввести IP и порт подключения вручную
@echo.
@echo    H. Дополнительная информация
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A. Install Oculus Wireless ADB app
rem @echo    B. Install Bugjaeger ADB app
rem @echo    C. Connect to the headset via port 5555
rem @echo    D. Connect to the headset using a random port
rem @echo    E. Show all connections
rem @echo    F. Disconnect all wireless connections
rem @echo    G. Enter IP and connection port manually
rem @echo.
rem @echo    H. Additional information
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo  Специальная установка Oculus Wireless ADB, предназначенная для использования внутри шлема,
@echo  без подключения к компьютеру, например, выполнение команд ADB на самом шлеме
@echo  для установки нативного разрешения или уровнеq CPU/GPU.
@echo  Именно так работает программа Quest Games Optimizer
@echo  Данный способ предоставит возможность вручную устанавливать режимы и управлять шлемом
@echo  командами ADB непосредственно с него самого.
@echo.
@echo  После установки Oculus Wireless ADB программа будет открыта на шлеме. 
@echo.
@echo  Далее следуйте инструкции:
@echo   - В приложении Oculus Wireless ADB нажмите серый квадратик TCPIP 5555
@echo   - Во всплывшем окне нажмите Ок. Квадратик станет зеленым
@echo   - Включите тумблер ADB Wireless Connect
@echo   - В окне "Разрешить беспроводную отладку для этой сети? нажмите "Разрешать всегда"
@echo   - В окне "Разрешить отладку USB?" нажмите "Разрешать всегда"
@echo.
@echo  Всплывающие окна об отладке и сети могут появляться в разном порядке и в разное время,
@echo  например, после перезагрузки они (или как минимум одно) будет всплывать снова.
@echo  В каждом случае нажимайте "Разрешать всегда".
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Special setup for Oculus Wireless ADB, intended for use inside the headset,
rem @echo  without connecting to a computer, for example, running ADB commands on the headset itself
rem @echo  to install native resolution or CPU/GPU levels.
rem @echo  This is how the Quest Games Optimizer program works.
rem @echo  This method will allow manually setting modes and controlling the headset
rem @echo  with ADB commands directly from it.
rem @echo.
rem @echo  After installing Oculus Wireless ADB, the program will open on the headset.
rem @echo.
rem @echo  Follow these instruction:
rem @echo    - In the Oculus Wireless ADB app tap the gray square TCPIP 5555
rem @echo    - In the pop-up window, tap OK. The square will turn green
rem @echo    - Turn on the ADB Wireless Connect toggle
rem @echo    - In the "Allow wireless debugging for this network?" window, click "Allow always"
rem @echo    - In the "Allow USB Debugging?" window, tap "Always Allow"
rem @echo.
rem @echo  Debugging and network pop-up windows may appear in different order and at different times,
rem @echo  for example, after reboot they (or at least one) will pop up again.
rem @echo  In each case tap "Always Allow".
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _OculusWirelessADBcomplex
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _OculusWirelessADBpackage)
if /i "%choice%"=="b" (GOTO _bugjinstaller)
if /i "%choice%"=="c" (GOTO _ConnectStdPort)
if /i "%choice%"=="d" (GOTO _ConnectRandomPort)
if /i "%choice%"=="e" (GOTO _ConnectionsCheck)
if /i "%choice%"=="f" (GOTO _alladbdisconnect)
if /i "%choice%"=="g" (GOTO _enterconportman)
if /i "%choice%"=="h" (GOTO _additionalinfo)
goto _OculusWirelessADBcomplex


:_OculusWirelessADBpackage
call :_cdc
set dlappl=tdg.oculuswirelessadb-1.2.apk
set curllink=https://www.dropbox.com/scl/fi/04aodeddzojdwpkqqi2zf/tdg.oculuswirelessadb-1.2.apk?rlkey=v3gl22fr99zqfjsocoatt0lp0
call :_dlinstall
%myfiles%\adb shell pm grant tdg.oculuswirelessadb android.permission.WRITE_SECURE_SETTINGS 1>nul 2>nul
%myfiles%\adb shell pm grant tdg.oculuswirelessadb android.permission.READ_LOGS 1>nul 2>nul
timeout 2 >nul
%myfiles%\adb tcpip 5555
timeout 3 >nul
%myfiles%\adb shell am start tdg.oculuswirelessadb/.MainActivity 1>nul 2>nul
@echo.
@echo.
rem StartRusTextBlock
@echo  = Программа открыта. Наденьте шлем и следуйте инструкциям выше
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Application was opened. Put on headset and follow manual
rem EndEngTextBlock
call :_prevmenu
goto _OculusWirelessADBcomplex

:_bugjinstaller
call :_cdc
set dlappl=Bugjaeger-Premium-v5.0-full.apk
set curllink=https://www.dropbox.com/scl/fi/s098v5stzlktj91gkkpsp/Bugjaeger-Premium-v5.0-full.apk?rlkey=qp99kc6q6nm7j89r53gh5f8q0
call :_dlinstall
call :_prevmenu
goto _OculusWirelessADBcomplex

:_ConnectStdPort
rem %myfiles%\adb disconnect
timeout 2 >nul
%myfiles%\adb tcpip 5555
if %errorlevel%==1 goto _nodevfoundconnect
call :_prevmenu
goto _OculusWirelessADBcomplex

:_ConnectRandomPort
@%MYFILES%\adb devices | findstr /i /c:"offline" 1>nul 2>nul
rem если устройство в offline то errorlevel равен 0
@If %ERRORLEVEL%==0 %myfiles%\adb disconnect && timeout 5 >nul
@For /f "tokens=*" %%a in ('%myfiles%\AndroidMdnsDiscover.exe') do set randipport=%%a
@if "%randipport%"=="No devices found" goto _nodevfoundconnect
%myfiles%\adb connect %randipport%
rem rem  1>nul 2>nul
rem rem if %errorlevel% NEQ 1 (
rem rem StartRusTextBlock
rem rem @echo Подключено: %randipport%
rem rem EndRusTextBlock
rem rem StartEngTextBlock
rem rem @echo Connected to : %randipport%
rem rem EndEngTextBlock
rem rem ) else (
rem rem StartRusTextBlock
rem rem @echo Подключение не удалось. Попробуйте еще раз
rem rem EndRusTextBlock
rem rem StartEngTextBlock
rem rem @echo Connection failed. Try once more.
rem rem EndEngTextBlock
rem )
call :_prevmenu
goto _OculusWirelessADBcomplex

:_nodevfoundconnect
@echo.
@echo ---------------------------
rem StartRusTextBlock
@echo  Шлем не обнаружен
@echo.
@echo  Наденьте шлем, запустите приложение Oculus Wireless ADB
@echo  Включите или переключите тумблер ADB Wireless Connect,
@echo  затем попробуйте подключиться снова
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset not found
rem @echo.
rem @echo  Put on headset and Start Oculus Wireless ADB application
rem @echo  Turn on or toggle the ADB Wireless Connect toggle then try connecting again
rem EndEngTextBlock
call :_prevmenu
goto _OculusWirelessADBcomplex

:_ConnectionsCheck
@echo.
%myfiles%\adb devices
@echo.
call :_prevmenu
goto _OculusWirelessADBcomplex

:_alladbdisconnect
%myfiles%\adb disconnect
call :_prevmenu
goto _OculusWirelessADBcomplex

:_enterconportman
rem StartRusTextBlock
@Set /p ip="Введите IP адрес и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Enter the IP address and press Enter: "
rem EndEngTextBlock
rem StartRusTextBlock
if not defined choice goto _OculusWirelessADBcomplex
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)

@echo.
@Set /p port="Введите номер порта и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Enter port numper and press Enter: "
rem EndEngTextBlock
if not defined choice goto _OculusWirelessADBcomplex
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
rem goto _OculusWirelessADBcomplex
@echo --------------------------------
rem StartRusTextBlock
@echo ..Пробуем подключиться...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ..Attempting to connect...
rem EndEngTextBlock
@%myfiles%\adb connect %ip%:%port%
call :_prevmenu
goto _OculusWirelessADBcomplex



:_additionalinfo
cls
rem StartRusTextBlock
@echo.
@echo.
@echo.
@echo          Дополнительная информация по использованию
@echo.
@echo.
@echo.
@echo В окне программы Oculus Wireless ADB будут показаны одинаковые IP адреса
@echo вашего шлема, но с разными портами. Можно подключаться по любому порту
@echo или по внутреннему IP адресу: 127.0.0.1. Пятизначный порт будет постоянно меняться,
@echo а порт 5555 останется неизменным.
@echo.
@echo Например, установите программу Bugjaeger, запустите и подключитесь к шлему:
@echo  - Нажмите иконку вилки со значком плюс справа вверху
@echo  - Введите IP адрес: 127.0.0.1 и порт 5555
@echo  - Нажмите Connect.
@echo  - Дождитесь надписи Connected в нижней части окна программы.
@echo.
@echo Кроме того, также можно подключаться с ПК к шлему по ADB через беспроводное соединение:
@echo  - Введите в консоли cmd команду adb connect 192.168.1.1:5555
@echo  - Вместо адреса 192.168.1.1 введите свой адрес - тот, который показан в окне программы.
@echo.
@echo  Или можете использовать подключение с помощью пунктов C или D.
@echo  В последнем случае случайный порт будет найден автоматически.
@echo.
@echo  Если подключиться не удается, перезагрузите шлем и попробуйте снова.
@echo  Также попробуйте подключиться к случайному порту или к порту 5555,
@echo  предварительно отключив все соединения в пункте F.
@echo.
@echo ВАЖНО: Беспроводное соединение будет сохраняться до тех пор, пока вы не перезагрузите шлем
@echo        или не завершите на ПК процесс adb.exe
@echo.
@echo        Еще раз отмечу, что приложение Oculus Wireless ADB предназначено, как правило,
@echo        для управления шлемом по ADB неспосредственно с самого шлема, без смартфона и ПК
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.
rem @echo.
rem @echo.
rem @echo                    Additional information on use
rem @echo.
rem @echo.
rem @echo.
rem @echo  In the Oculus Wireless ADB program window will show the same IP addresses
rem @echo  of your headset, but with different ports. You can connect to any port
rem @echo  or to the internal IP address: 127.0.0.1. The five-digit port will change constantly,
rem @echo  but port 5555 will remain unchanged.
rem @echo.
rem @echo  For example, install the Bugjaeger program, run it, and connect to the headset:
rem @echo    - Press the plug icon with a plus sign in the upper right corner
rem @echo    - Enter the IP address: 127.0.0.1 and port 5555
rem @echo    - Press Connect.
rem @echo    - Wait for the message Connected at the bottom of the program window.
rem @echo.
rem @echo  Additionally, you can also connect from a PC to the headset via ADB over wireless:
rem @echo    - Enter the command adb connect 192.168.1.1:5555 in the cmd console
rem @echo    - Instead of the address 192.168.1.1, enter your address - the one shown in the program window.
rem @echo.
rem @echo  Or you can use the connection using points C or D.
rem @echo  In the latter case, a random port will be found automatically.
rem @echo.
rem @echo  If you can't connect, reboot your headset and try again.
rem @echo  Also try connecting to a random port or port 5555
rem @echo  after first disabling all connections in point F.
rem @echo.
rem @echo  IMPORTANT: The wireless connection will remain until you restart the headset
rem @echo             or terminate the adb.exe process on the PC
rem @echo.
rem @echo             Let me note once again that the Oculus Wireless ADB application
rem @echo             is intended, as a rule, to control the headset via ADB directly 
rem @echo             from the headset itself, without a smartphone and PC
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
call :_prevmenu
goto _OculusWirelessADBcomplex
:: rem StartRusTextBlock
rem rem @start cmd /k "type dophelp.txt && @echo Для закрытия окна нажмите любую кнопку && @pause 1>nul && exit"
:: rem EndRusTextBlock
:: rem StartEngTextBlock
rem rem @start cmd /k "type dophelp.txt && @echo Press any key to close the window && @pause >nul && exit"
:: rem EndEngTextBlock
rem @ping localhost -n 2 2>nul 1>nul
rem @del dophelp.txt /f /q 2>nul 1>nul

:_displaydiagmain
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    1. Тест дисплея 1 вариант
@echo    2. Тест дисплея 2 вариант
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    1. Display test. 1 variant
rem @echo    2. Display test. 2 variant
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   После запуска на шлеме откроется страница в дефолтном браузере.
@echo   С ее помощью можно провести онлайн-тест дисплея.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo After starting, a page will open in the default browser on the heaset.
rem @echo With its help, you can conduct an online display test.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _displaydiagmain
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="1" (GOTO _displaydiag1)
if /i "%choice%"=="2" (GOTO _displaydiag2)
rem if /i "%choice%"=="z" (GOTO _helplinksmenu)
goto _displaydiagmain

:_displaydiag1
%myfiles%\adb shell am start -n "com.oculus.vrshell/.MainActivity" -d apk://com.oculus.browser -e uri https://vr.ivanik.ru/ 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
rem StartRusTextBlock
@echo   Наденьте шлем, в браузере будет открыта страница с тестом
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Put on headset, a page with the test will open in the browser.
rem EndEngTextBlock
call :_prevmenu
goto _shellmenu

:_displaydiag2
%myfiles%\adb shell am start -n "com.oculus.vrshell/.MainActivity" -d apk://com.oculus.browser -e uri https://testmyscreen.com/ 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
rem StartRusTextBlock
@echo   Наденьте шлем, в браузере будет открыта страница с тестом
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Put on headset, a page with the test will open in the browser.
rem EndEngTextBlock
call :_prevmenu
goto _shellmenu


:_ADBServerRestart
@echo ========================================
rem StartRusTextBlock
@echo  Перезапускаем ADB сервер...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Restarting ADB server...
rem EndEngTextBlock
@echo. 
@%MYFILES%\adb kill-server
@%MYFILES%\adb start-server 1>nul 2>nul
@echo ----------------------------------------
rem StartRusTextBlock
@echo  = Сервер перезапущен
@echo  Можете подключить кабель к шлему
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Server restarted
rem @echo  You can connect the cable to the headset
rem EndEngTextBlock
@echo. 
@echo ----------------------------------------
@goto _returnmenu


:_DeleteKM

@%MYFILES%\adb shell dpm remove-active-admin io.github.sds100.keymapper.debug
call :_erlvl
@echo.
@echo --------------------------------------------------------------
rem StartRusTextBlock
@echo На возможное сообщение об ошибке не обращайте внимания.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Ignore any potential error messages.
rem EndEngTextBlock
@echo --------------------------------------------------------------
@timeout 3 >nul
@%MYFILES%\adb shell pm disable-user io.github.sds100.keymapper.debug
@echo.
@echo --------------------------------------------------------------
rem StartRusTextBlock
@echo  = KeyMapper удален.
@echo  Если он все еще фигурирует в приложениях на шлеме, 
@echo  удалите его обычным образом и перезагрузитесь.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = KeyMapper removed.
rem @echo  If it still appears in the applications on the headset,
rem @echo  remove it in regular way and reboot.
rem EndEngTextBlock
@echo --------------------------------------------------------------
@echo.
goto _returnmenu

:_updateservice
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  %_fBYellow%Проверить статус обновлений%_fReset%
@echo.
@echo    %_fBRed%B%_fReset%.  Отключить сервис обновлений  (только на прошивках ниже v81)
@echo    %_fBGreen%C%_fReset%.  Включить сервис обновлений (только на прошивках ниже v81)
@echo.
@echo.
@echo.
@echo        %_fBYellow%ВАЖНО:
@echo.
@echo     %_fBRed%Meta запретила отключени обновлений начиная с прошивок верси v81.%_fReset%
rem EndRusTextBlock
rem @echo    %_fBRed%D%_fReset%.  Запретить обновление шлема по воздуху
rem @echo    %_fBGreen%E%_fReset%.  Разрешить обновление шлема по воздуху
rem @echo.
rem @echo    %_fBRed%F%_fReset%.  Запретить приложению updater использовать интернет в фоновом режиме
rem @echo    %_fBGreen%G%_fReset%.  Разрешить приложению updater использовать интернет в фоновом режиме
rem @echo.
rem @echo    %_fBRed%I%_fReset%.  Запретить все  (кроме Meta Home)
rem @echo    %_fBGreen%J%_fReset%.  Разрешить все  (кроме Meta Home)
rem @echo.
rem @echo    %_fBRed%K%_fReset%.  Запретить обновления ПО Meta Home на ПК
rem @echo    %_fBGreen%L%_fReset%.  Разрешить обновления ПО Meta Home на ПК
rem @echo.
rem @echo.
rem @echo        %_fBYellow%ВАЖНО:
rem @echo.
rem @echo   %_fBYellow%Если не срабатывает отключение %_fYellow%Сервиса обновлений %_fBYellow%(прошивка %_fYellow%v81 %_fBYellow%или выше), используйте 
rem @echo   другие два метода - %_fYellow%Запрет обновлений по воздуху%_fBYellow% и  %_fYellow% Запрет интернет в Фоновом режиме.%_fReset%
rem StartEngTextBlock
rem @echo    A.  %_fBYellow%Check update services status%_fReset%
rem @echo.
rem @echo    %_fBRed%B%_fReset%.  Disable update service  (only on firmware versions below v81)
rem @echo    %_fBGreen%C%_fReset%.  Enable update service  (only on firmware versions below v81)
rem @echo.
rem @echo.
rem @echo.
rem @echo        %_fBYellow%IMPORTANT:
rem @echo.
rem @echo     %_fBRed%Meta has prohibited disabling updates starting with firmware version v81.%_fReset%
rem EndEngTextBlock
rem @echo    %_fBRed%D%_fReset%.  Block headset OTA updates
rem @echo    %_fBGreen%E%_fReset%.  Allow headset OTA updates
rem @echo.
rem @echo    %_fBRed%F%_fReset%.  Block updater app from using internet in the background
rem @echo    %_fBGreen%G%_fReset%.  Allow updater app to use internet in the background
rem @echo.
rem @echo    %_fBRed%I%_fReset%.  Block all  (except Meta Home)
rem @echo    %_fBGreen%J%_fReset%.  Allow all  (except Meta Home)
rem @echo.
rem @echo    %_fBRed%K%_fReset%.  Block Meta Home software updates on PC
rem @echo    %_fBGreen%L%_fReset%.  Allow Meta Home software updates on PC
rem @echo.
rem @echo.
rem @echo        %_fBYellow%IMPORTANT:
rem @echo.
rem @echo     %_fBRed%Meta has prohibited disabling updates starting with firmware version v81.%_fReset%
rem @echo   %_fBYellow%If disabling the %_fYellow%Update Service %_fBYellow%does not work (firmware %_fYellow%v81 %_fBYellow%or higher), use
rem @echo   the other two methods — %_fYellow%Block OTA updates%_fBYellow% and %_fYellow%Block background internet access.%_fReset%
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _updateservice
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (call :_AllUpdatesCheck)

if /i "%choice%"=="b" (call :_updservoff)
if /i "%choice%"=="c" (call :_updservon)

rem if /i "%choice%"=="d" (call :_updservoffair)
rem if /i "%choice%"=="e" (call :_updservonair)

rem if /i "%choice%"=="f" (call :_UpdBackgroudOff)
rem if /i "%choice%"=="g" (call :_UpdBackgroudOn)

rem if /i "%choice%"=="i" (call :_AllUpdatesDisable)
rem if /i "%choice%"=="j" (call :_AllUpdatesEnable)

if /i "%choice%"=="k" (GOTO _updservocoff)
if /i "%choice%"=="l" (GOTO _updservocon)
@cls
goto _updateservice


:_AllUpdatesCheck
call :_cdc
set updcheck=1
call :_UpdateStatusCheck
rem call :_UpdateOTAStatusCheck
rem call :_UpdBackgroudCheck
call :_prevmenu
exit /b


:_AllUpdatesDisable
set updall=1
call :_cdc
call :_updservoff
call :_updservoffair
call :_UpdBackgroudOff
call :_prevmenu
exit /b


:_AllUpdatesEnable
call :_cdc
set updall=1
call :_updservon
call :_updservonair
call :_UpdBackgroudOn
call :_prevmenu
exit /b



:_UpdateStatusCheck
call :_cdc
set updstatus=
%MYFILES%\adb shell pm list packages -d 1>nul 2>nul | findstr /i /c:"com.oculus.updater" 1>nul 2>nul
@echo   ----------------------------------------
rem @echo   ========================================
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBRed%Сервис обновлений отключен%_fReset%
) else (
@echo   %_fBGreen%Сервис обновлений включен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Udpate service disabled%_fReset%
rem ) else (
rem @echo   %_fBGreen%OTA Udpate service enabled%_fReset%
rem EndEngTextBlock
)
if not defined updcheck call :_prevmenu
exit /b



:_UpdateOTAStatusCheck
call :_cdc
@%MYFILES%\adb shell pm list packages -d 2>nul | findstr /i /c:"package:com.oculus.nux.ota" 1>nul 2>nul
@echo   ----------------------------------------
rem @echo   ========================================
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBRed%Обновление по воздуху отключено%_fReset%
) else (
@echo   %_fBGreen%Обновление по воздуху включено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%OTA Udpate disabled%_fReset%
rem ) else (
rem @echo   %_fBGreen%OTA Udpate enabled%_fReset%
rem EndEngTextBlock
)
if not defined updcheck call :_prevmenu
exit /b


:_updservoff
call :_cdc
@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.updater 1>nul 2>nul
@echo   ----------------------------------------
if errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBRed%Не удалось отключить сервис обновлений
@echo   %_fBYellow%Вероятно на шлеме установлена прошивка %_fYellow%v81 %_fBYellow%или выше%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Failed to disable the update service
rem @echo   %_fBYellow%Most likely firmware %_fYellow%v81 %_fBYellow%or higher is installed on the headset%_fReset%
rem EndEngTextBlock
) else (
rem call :_erlvl
rem @echo   ========================================
rem StartRusTextBlock
@echo   %_fBRed%Сервис обновлений отключен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem   @echo Update service disabled%_fReset%
rem EndEngTextBlock
)
if not defined updall call :_prevmenu
exit /b

:_updservon
call :_cdc
@%MYFILES%\adb shell pm enable --user 0 com.oculus.updater 1>nul 2>nul
@echo   ----------------------------------------
if errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%Сервис обновлений уже включен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%Update service already enabled%_fReset%
rem EndEngTextBlock
) else (
@echo   ----------------------------------------
rem @echo   ========================================
rem StartRusTextBlock
@echo   %_fBGreen%Сервис обновлений включен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%Update service enabled%_fReset%
rem EndEngTextBlock
)
if not defined updall call :_prevmenu
exit /b


:_updservoffair
call :_cdc
@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.nux.ota  1>nul 2>nul
rem call :_erlvl
@echo   ----------------------------------------
rem @echo   ========================================
rem StartRusTextBlock
@echo   %_fBRed%Обновление по воздуху отключено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem   @echo %_fBRed%OTA Udpate disabled%_fReset%
rem EndEngTextBlock
if not defined updall call :_prevmenu
exit /b

:_updservonair
call :_cdc
@%MYFILES%\adb shell pm enable com.oculus.nux.ota 1>nul 2>nul
@echo   ----------------------------------------
rem @echo   ========================================
rem StartRusTextBlock
@echo   %_fBGreen%Обновление по воздуху включено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%OTA Udpate enabled%_fReset%
rem EndEngTextBlock
if not defined updall call :_prevmenu
exit /b


:_UpdBackgroudOff
call :_cdc
@%MYFILES%\adb shell appops set com.oculus.updater RUN_IN_BACKGROUND ignore  1>nul 2>nul
rem @%MYFILES%\adb shell appops set com.oculus.updater RUN_ANY_IN_BACKGROUND ignore  1>nul 2>nul
rem call :_erlvl
@echo   ----------------------------------------
rem @echo   ========================================
rem StartRusTextBlock
@echo   %_fBRed%Фоновый режим работы запрещен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Background mode restricted%_fReset%
rem EndEngTextBlock
if not defined updall call :_prevmenu
exit /b


:_UpdBackgroudOn
call :_cdc
@%MYFILES%\adb shell appops set com.oculus.updater RUN_IN_BACKGROUND allow 1>nul 2>nul
rem @%MYFILES%\adb shell appops set com.oculus.updater RUN_ANY_IN_BACKGROUND allow 1>nul 2>nul
@echo   ----------------------------------------
rem @echo   ========================================
rem StartRusTextBlock
@echo   %_fBGreen%Фоновый режим работы разрешен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBGreen%Background mode allowed%_fReset%
rem EndEngTextBlock
if not defined updall call :_prevmenu
exit /b


:_UpdBackgroudCheck
call :_cdc
set updbgndstatus=
for /f %%a in ('%MYFILES%\adb shell appops get com.oculus.updater 2^>nul ^| findstr /i /c:"BACKGROUND"') do set updbgndstatus=%%a
@echo   ----------------------------------------
rem @echo   ========================================
if "%updbgndstatus%"=="RUN_IN_BACKGROUND:" (
rem StartRusTextBlock
@echo   %_fBRed%Фоновый режим работы запрещен%_fReset%
) else (
@echo   %_fBGreen%Фоновый режим работы разрешен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Background mode restricted%_fReset%
rem ) else (
rem @echo   %_fBGreen%Background mode allowed%_fReset%
rem EndEngTextBlock
)
if not defined updcheck call :_prevmenu
exit /b


:_menugpucpu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    C.  Установка уровня CPU
@echo    G.  Установка уровня GPU
@echo    S.  Показать текущие уровни
@echo.
@echo.
@echo    ВАЖНО:
@echo.
@echo      Работает пока только на Meta Quest 2
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    C. Set CPU level
rem @echo    G. Set GPU level
rem @echo    S. Show current levels
rem @echo.
rem @echo.
rem @echo    IMPORTANT:
rem @echo.
rem @echo      Works only on Meta Quest 2 for now
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _menugpucpu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="c" (GOTO _cpu)
if /i "%choice%"=="g" (GOTO _gpu)
if /i "%choice%"=="s" (GOTO _currentpu)

@cls
goto _menugpucpu

:_cpu
call :_cdc
call :_hat
@echo.
@%verbecho%
rem StartRusTextBlock
@echo      ----------------------------
@echo       ВЫБЕРИТЕ УРОВЕНЬ РАБОТЫ CPU
@echo      ----------------------------
@echo.
@echo    C.  Узнать текущий уровень
@echo    M.  Возврат в меню
@echo.
@echo    0.  Минимальный
@echo    1.  Низкий
@echo    2.  Средний
@echo    3.  Высокий
@echo    4.  Супервысокий
@echo    5.  Максимальный
@echo    A.  Авто
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      ----------------------------
rem @echo       SELECT CPU PERFORMANCE LEVEL
rem @echo      ----------------------------
rem @echo.
rem @echo    C.  Check current level
rem @echo    M.  Return to menu
rem @echo.
rem @echo    0.  Minimum
rem @echo    1.  Low
rem @echo    2.  Medium
rem @echo    3.  High
rem @echo    4.  Ultra
rem @echo    5.  Maximum
rem @echo    A.  Auto
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _cpu
if "%choice%"=="0" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 0 & goto _cpusetmenu)
if "%choice%"=="1" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 1 & goto _cpusetmenu)
if "%choice%"=="2" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 2 & goto _cpusetmenu)
if "%choice%"=="3" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 3 & goto _cpusetmenu)
if "%choice%"=="4" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 4 & goto _cpusetmenu)
if "%choice%"=="5" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 5 & goto _cpusetmenu)
if "%choice%"=="6" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 6 & goto _cpusetmenu)
if "%choice%"=="7" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel 7 & goto _cpusetmenu)
if /i "%choice%"=="a" (@%MYFILES%\adb shell setprop debug.oculus.cpuLevel -1 & goto _cpusetmenu)

if /i "%choice%"=="c" (GOTO _currentpu)
if /i "%choice%"=="m" (GOTO _menugpucpu)
:_cpusetmenu
@echo ========================================
rem StartRusTextBlock
@echo  Параметры установлены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Settings have been applied
rem EndEngTextBlock
call :_prevmenu
cls
@goto _menugpucpu

:_gpu
call :_cdc
call :_hat
@echo.
@%verbecho%
rem StartRusTextBlock
@echo      ----------------------------
@echo       ВЫБЕРИТЕ УРОВЕНЬ РАБОТЫ GPU
@echo      ----------------------------
@echo.
@echo    C.  Узнать текущий уровень
@echo    M.  Возврат в меню
@echo.
@echo    0.  Минимальный
@echo    1.  Низкий
@echo    2.  Средний
@echo    3.  Высокий
@echo    4.  Супервысокий
@echo    5.  Максимальный
@echo    A.  Авто
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      ----------------------------
rem @echo       SELECT CPU PERFORMANCE LEVEL
rem @echo      ----------------------------
rem @echo.
rem @echo    C.  Check current level
rem @echo    M.  Return to menu
rem @echo.
rem @echo    0.  Minimum
rem @echo    1.  Low
rem @echo    2.  Medium
rem @echo    3.  High
rem @echo    4.  Ultra
rem @echo    5.  Maximum
rem @echo    A.  Auto
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _gpu
if "%choice%"=="0" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 0 & goto _gpusetmenu)
if "%choice%"=="1" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 1 & goto _gpusetmenu)
if "%choice%"=="2" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 2 & goto _gpusetmenu)
if "%choice%"=="3" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 3 & goto _gpusetmenu)
if "%choice%"=="4" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 4 & goto _gpusetmenu)
if "%choice%"=="5" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 5 & goto _gpusetmenu)
if "%choice%"=="6" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 6 & goto _gpusetmenu)
if "%choice%"=="7" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel 7 & goto _gpusetmenu)
if /i "%choice%"=="a" (@%MYFILES%\adb shell setprop debug.oculus.gpuLevel -1 & goto _gpusetmenu)

if /i "%choice%"=="c" (GOTO _currentpu)
if /i "%choice%"=="m" (GOTO _menugpucpu)
:_gpusetmenu
@echo ========================================
rem StartRusTextBlock
@echo  Параметры установлены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Settings have been applied
rem EndEngTextBlock
call :_prevmenu
@cls
goto _menugpucpu

:_currentpu
call :_cdc
rem StartRusTextBlock
@echo Текущие уровни
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Current levels:
rem EndEngTextBlock
@echo GPU:
@%MYFILES%\adb shell getprop debug.oculus.gpuLevel
call :_erlvl
@echo CPU:
@%MYFILES%\adb shell getprop debug.oculus.cpuLevel
@echo ========================================
rem StartRusTextBlock
@echo  (пустые строки или -1 означают Auto)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo (Blank lines or -1 indicate Auto)
rem EndEngTextBlock
@goto _returnmenu

:_setpriority
call :_hat
@echo.
@%verbecho%
rem StartRusTextBlock
@echo  Cледующим процессам будет установлен приоритет Высокий:
@echo.
@echo   OculusClient.exe
@echo   OculusDash.exe
@echo   OVRServer_x64.exe
@echo.
@echo    0.  Выход из программы
@echo    M.  Выход в главное меню
@echo.
@echo    Y.  Установить параметры
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The following processes will be set to High priority:
rem @echo.
rem @echo   OculusClient.exe
rem @echo   OculusDash.exe
rem @echo   OVRServer_x64.exe
rem @echo.
rem @echo    0.  Exit the program
rem @echo    M.  Return to main menu
rem @echo.
rem @echo    Y.  Apply settings
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _setpriority
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="y" (call :_checkservices && GOTO _checkservices)
cls
goto _setpriority

:_checkservices
@sc query ovrservice 1>nul 2>&1
rem StartRusTextBlock
@if errorlevel == 1 @echo ======================================== ^ & @echo Сервис Oculus не установлен! & goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem @if errorlevel == 1 @echo ======================================== ^ & @echo The Oculus service is not installed! & goto _returnmenu
rem EndEngTextBlock
exit /b

:_setprioritycpu
@cmd.exe /c wmic process where name="OculusClient.exe" call setpriority 128
@cmd.exe /c wmic process where name="OculusDash.exe" call setpriority 128
@cmd.exe /c wmic process where name="OVRServer_x64.exe" call setpriority 128
@echo ========================================
rem StartRusTextBlock
@echo  Параметры установлены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Settings have been applied
rem EndEngTextBlock
@goto _returnmenu

:_sendtext
call :_hat
@echo.
@echo.
@%verbecho%
rem StartRusTextBlock
@echo  Установите курсор в шлеме на поле, в которое хотите вставить текст
@echo  [ например, в адресной строке браузера или в поле ввода ключа/пароля ]
@echo  [ для отмены и возврата в меню введите три двоеточия подряд :::]
@echo.
set /p txt="Введите или вставьте текст для отправки на шлем и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Place the cursor in the field on the headset where you want to insert text
rem @echo  [ For example, in the browser address bar or in the key/password input field ]
rem @echo  [ To cancel and return to the menu, enter three colons in a row ::: ]
rem @echo.
rem set /p txt="Enter the text to send to the headset and press Enter: "
rem EndEngTextBlock
if /i "%txt%"==":::" (GOTO _beginn)
if /i "%txt%"=="(((" (GOTO _beginn)
if /i "%txt%"==")))" (GOTO _beginn)
@%MYFILES%\adb shell input text '"%txt%"' 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Можете надеть шлем, текст должен быть вставлен в поле
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  You can put on the headset; the text should be inserted into the field.
rem EndEngTextBlock
@goto _returnmenu

:_startsettings
:::::::::::::::::
rem @%MYFILES%\adb shell am start -a android.intent.action.VIEW -n com.android.settings/.Settings >nul
@echo ========================================
@%MYFILES%\adb shell am start -a android.intent.action.VIEW -n com.android.settings/.Settings 1>nul 2>nul
if errorlevel 1 (
@%MYFILES%\adb shell am start -n com.android.settings/com.android.settings.applications.InstalledAppDetails -a android.settings.APPLICATION_DETAILS_SETTINGS -d package:com.android.settings 1>nul 2>nul
rem StartRusTextBlock
@echo   %_fBYellow%Для отображения скрытых настроек нажмите кнопку %_fYellow%Открыть %_fBYellow%в окне приложения %_fYellow%"Настройки"%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   To display hidden settings, press the Open button in the "Settings" application window
rem EndEngTextBlock
) else (
@ping localhost >nul
rem StartRusTextBlock
@echo  Можете надеть шлем, настройки должны быть открыты
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  You can put on the headset; the settings should be open.
rem EndEngTextBlock
)
rem call :_erlvl
@goto _returnmenu

:_menurestart
call :_hat
call :_hatmenu
@echo.
@echo.
rem @echo.
rem @echo.
rem StartRusTextBlock
@echo    A.  Возобновление загрузки шлема из режима Bootloader
@echo    C.  Стандартная/штатная перезагрузка шлема.
@echo    B.  Перезагрузка шлема в режим Bootloader
@echo    R.  Перезагрузка шлема в режим Recovery
@echo    F.  Перезагрузка шлема в режим Fastboot
@echo    S.  Перезагрузка шлема в режим Sideload (обычный вариант)
@echo    T.  Перезагрузка шлема в режим Sideload (альтернативный вариант)
@echo    K.  Определить текущий режим шлема         [EXP]
@echo.   P.  Выключить шлем
@echo.
@echo   ВАЖНО:
@echo.
@echo  Не из каждого режима возможна перезагрузка в другой режим.
@echo. Если шлем не перезагружается, загляните в него
@echo  и выберите пункт Reboot system now.
@echo.
@echo  Будьте внимательны: из режима Sideload можно перезагрузиться
@echo. в штатный режим только через команды в этом меню или через 
@echo. пункт Boot Device в режиме Bootloader. (Питание и Громкость минус)
@echo. Перезагрузка кнопкой Питание загрузит шлем снова в Sideload.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Resuming booting from Bootloader mode
rem @echo    C.  Standard/Default Headset Reboot.
rem @echo    B.  Headset Reboot into Bootloader Mode
rem @echo    R.  Headset Reboot into Recovery Mode
rem @echo    F.  Headset Reboot into Fastboot Mode
rem @echo    S.  Headset Reboot into Sideload Mode (Regular Variant)
rem @echo    T.  Headset Reboot into Sideload Mode (Alternate Variant)
rem @echo    K.  Determine the Current Mode of the Headset         [EXP]
rem @echo.   P.  Power Off Headset
rem @echo.
rem @echo   IMPORTANT:
rem @echo.
rem @echo  Not every mode can be rebooted into another mode.
rem @echo. If the headset does not reboot, check inside it
rem @echo  and select the Reboot system now option.
rem @echo.
rem @echo  Attention: From Sideload mode, you can reboot
rem @echo. back to standard mode only through commands in this menu or through
rem @echo. the Boot Device option in Bootloader mode. (Power and Volume Down)
rem @echo. Rebooting by the Power button will boot the headset back into Sideload.
rem EndEngTextBlock
@echo.
@echo.
@echo.

call :_MenuChoiceEnter
@echo.
if not defined choice goto _menurestart
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _bootresuming)
if /i "%choice%"=="c" (GOTO _reboot)
if /i "%choice%"=="b" (GOTO _rbootloader)
if /i "%choice%"=="r" (GOTO _rrecovery)
if /i "%choice%"=="f" (GOTO _rfastboot)
if /i "%choice%"=="s" (GOTO _rsideload)
if /i "%choice%"=="t" (GOTO _rasideload)
if /i "%choice%"=="k" (GOTO _checkmode)
if /i "%choice%"=="p" (GOTO _hsshutdown)

@cls
goto _menurestart

:_bootresuming
@%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul || @echo ======================================== ^ & @echo +++ Headset is not in Booloader mode +++ & goto  _returnmenu
rem @%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 @%myfiles%\fastboot reboot & call :_rebootmessage & goto  _returnmenu
@%MYFILES%\fastboot continue 1>nul 2>nul
@echo ========================================
rem StartRusTextBlock
@echo  Загрузка шлема возобновлена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset loading resumed
rem EndEngTextBlock
@echo.
@echo.
@goto _returnmenu

:_reboot
@echo ========================================
rem StartRusTextBlock
@echo  Секунду..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Just a second..
rem EndEngTextBlock
rem call :_cdc
@%MYFILES%\adb devices | findstr /i /c:"sideload" 1>nul 2>nul
@If %ERRORLEVEL%==0 @%MYFILES%\adb reboot  1>nul 2>nul& call :_rebootmessage & goto  _returnmenu
@%MYFILES%\adb devices | findstr "device"$ 1>nul 2>nul
@If %ERRORLEVEL%==0 @%MYFILES%\adb reboot  1>nul 2>nul& call :_rebootmessage & goto  _returnmenu
@%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==0 @%myfiles%\fastboot reboot  1>nul 2>nul& call :_rebootmessage & goto  _returnmenu
:_rebootmessage
@echo  ---
rem StartRusTextBlock
@echo  Шлем отправлен в перезагрузку
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset sent for reboot.
rem EndEngTextBlock
@echo ========================================
exit /b
rem @goto _returnmenu

:_rbootloader
@%MYFILES%\adb reboot bootloader
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Шлем будет загружен в режим Bootloader
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset will boot into Bootloader mode.
rem EndEngTextBlock
@goto _returnmenu

:_rrecovery
@%MYFILES%\adb reboot recovery
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Шлем будет загружен в режим Recovery
@echo.
@echo  Дождитесь дохлого Андроида и надписи "No Command".
@echo  ( светодиод загорится белым, затем фиолетовым )
@echo.
@echo  Далее, удерживая на шлеме кнопку Питание, 
@echo  кратко нажмите Громкость+ (дальняя от носа).
@echo.
@echo  После этого отпустите кнопку Питание.
@echo  Должно появиться сине-желтое меню Android Recovery.
@echo  Если все так, это значит, что вы там, где надо.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset will boot into Recovery mode.
rem @echo.
rem @echo  Wait for the dead Android and "No Command" message.
rem @echo  (the LED will light up white, then purple)
rem @echo.
rem @echo  Then, while holding the Power button on the headset,
rem @echo  briefly press Volume+ (far button from the nose).
rem @echo.
rem @echo  After that, release the Power button.
rem @echo  A blue-yellow Android Recovery menu should appear.
rem @echo  If everything goes as planned, you're in the right place.
rem EndEngTextBlock
@goto _returnmenu

:_rfastboot
@%MYFILES%\adb reboot fastboot
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Шлем будет загружен в режим Fastboot
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset will boot into Fastboot mode.
rem EndEngTextBlock
@goto _returnmenu

:_rsideload
@%MYFILES%\adb.exe reboot bootloader
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Шлем будет загружен в режим Sideload (обычный вариант)
@echo  Загружаемся сначала в бутлоадер.. Секундочку...
@echo  [ светодиод будет гореть оранжевым ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset will boot into Sideload mode (regular variant).
rem @echo  Booting into the bootloader first... Just a moment...
rem @echo  [the LED will be orange]
rem EndEngTextBlock
@ping localhost -n 12 >nul
@echo.
@echo ----------------------------------------
@%MYFILES%\fastboot.exe oem reboot-sideload 1>NUL 2>&1
rem StartRusTextBlock
@echo   Переключаемся в режим Sideload.. Еще чуточку терпения...
@echo   [ светодиод загорится белым, затем фиолетовым ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Switching to Sideload mode... Just a little more patience...
rem @echo  [the LED will light up white, then purple]
rem EndEngTextBlock
@ping localhost -n 14 >nul
goto _sideloadmode

:_rasideload
@%MYFILES%\adb reboot sideload
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Шлем будет загружен в режим Sideload (альтернативный вариант)
@echo  [ светодиод загорится белым, затем фиолетовым ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset will boot into Sideload mode (alternate variant).
rem @echo  [the LED will light up white, then purple]
rem EndEngTextBlock
@ping localhost -n 14 >nul
goto _sideloadmode

:_checkmode
rem call :_cdc
rem @%MYFILES%\adb devices | findstr /i /c:"sideload" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 do (
rem @echo ========================================
rem @echo +++ Шлем в режиме Sideload +++
rem goto _returnmenu
rem )

rem @%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 do (
rem goto _fbtbtldmode
rem ) else (
rem rem @If %ERRORLEVEL%==1 
rem @echo ========================================
rem @echo +++ Шлем в штатном режиме +++
rem goto _returnmenu

rem @%MYFILES%\fastboot devices | findstr /i /c:"recovery" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 do (
rem call :_recoverymode
rem )
rem goto _returnmenu
rem StartRusTextBlock
@%MYFILES%\adb devices | findstr /i /c:"sideload" 1>nul 2>nul
@If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo +++ Шлем в режиме Sideload +++ & goto _returnmenu
@%MYFILES%\adb devices | findstr "device"$ 1>nul 2>nul
@If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo +++ Шлем в штатном режиме +++ & goto _returnmenu
@%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==0  goto _fbtbtldmode
@If %ERRORLEVEL%==1 @echo ======================================== ^ & @echo +++ Шлем в режиме Recovery +++ & call :_recoverymode
rem EndRusTextBlock
rem StartEngTextBlock
rem @%MYFILES%\adb devices | findstr /i /c:"sideload" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo @echo +++ Headset in Sideload mode +++ & goto _returnmenu
rem @%MYFILES%\adb devices | findstr "device"$ 1>nul 2>nul
rem @If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo +++ Headset in Normal mode +++ & goto _returnmenu
rem @%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
rem @If %ERRORLEVEL%==0  goto _fbtbtldmode
rem @If %ERRORLEVEL%==1 @echo ======================================== ^ & @echo +++ Headset in Recovery mode +++ & call :_recoverymode
rem EndEngTextBlock

goto _returnmenu

:_fbtbtldmode
@echo ======================================== 
@echo.
rem StartRusTextBlock
@echo  Если на экране шлема желто-синее меню, светодиод фиолетовый и надпись FASTBOOTD - 
@echo      - вы в режиме +++ Fastboot +++
@echo.
@echo  Если на экране бело-синее меню, светодиод оранжевый и надпись USB Update Mode - 
@echo     - вы в режиме +++ Bootloader +++ 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  If you see a yellow-blue menu on the headset screen, the LED is purple, and the message is FASTBOOTD - 
rem @echo      - you are in +++ Fastboot +++ mode.
rem @echo.
rem @echo  If you see a white-blue menu on the screen, the LED is orange, and the message is USB Update Mode - 
rem @echo     - you are in +++ Bootloader +++ mode.
rem EndEngTextBlock
goto _returnmenu

:_recoverymode
@echo ======================================== 
@echo.
rem StartRusTextBlock
@echo  Если светодиод фиолетовый, а на дисплее шлема
@echo  дохлый Андроид и надпись No Command - 
@echo      - вы ПОЧТИ в режиме +++ Recovery +++
@echo.
@echo  Сейчас, удерживая на шлеме кнопку Питание, 
@echo  кратко нажмите Громкость+ (дальняя от носа).
@echo  После этого отпустите кнопку Питание.
@echo  Должно появиться сине-желтое меню Android Recovery.
@echo  Если все так, это значит, что вы там, где надо:
@echo      - в режиме +++ Recovery +++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  If the LED is purple, and on the headset display,
rem @echo  there's a dead Android and the message No Command - 
rem @echo      - you are ALMOST in +++ Recovery +++ mode.
rem @echo.
rem @echo  Now, while holding the Power button on the headset, 
rem @echo  briefly press Volume+ (far button from the nose).
rem @echo  After that, release the Power button.
rem @echo  A blue-yellow Android Recovery menu should appear.
rem @echo  If everything goes as planned, you're in the right place:
rem @echo      - in +++ Recovery +++ mode.
rem EndEngTextBlock
@exit /b

:_sideloadmode
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     +++++ Шлем в режиме Sideload +++++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++ Headset in Sideload mode +++++
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    F.  Загрузить прошивку в шлем
@echo    R.  Перезагрузить шлем
@echo.
@echo.
@echo	ВАЖНО:
@echo. 
@echo  После выбора пункта F и нажатия Enter
@echo  загрузка прошивки начнется сразу, без подтверждения.
@echo.  
@echo  Файл с прошивкой должен называться update.zip
@echo  и лежать рядом с программой.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    F.  Load firmware into headset
rem @echo    R.  Reboot headset
rem @echo.
rem @echo.
rem @echo    IMPORTANT:
rem @echo. 
rem @echo  After selecting option F and pressing Enter
rem @echo  firmware loading will start immediately, without confirmation.
rem @echo.  
rem @echo  The firmware file must be named update.zip
rem @echo  and should be located next to the program.
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _sideloadmode
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="f" (call :_CheckFWfileExist && goto _FirmwareUpload)
if /i "%choice%"=="r" (GOTO _menurestart)
cls
goto _sideloadmode

:_hsshutdown
@%MYFILES%\adb shell reboot -p 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Шлем выключается....
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset is turning off...
rem EndEngTextBlock
@goto _returnmenu

:_screenshotmenu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    C.  Одиночный скриншот шлема
@echo    B.  Серия скриншотов шлема, каждый скриншот по нажатию клавиши	[EXP]
@echo    S.  Серия автоматических скриншотов с заданным интервалом		[EXP]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    C.  Single screenshot of the headset
rem @echo    B.  Series of headset screenshots, one per key press    [EXP]
rem @echo    S.  Series of automatic screenshots with a specified interval    [EXP]
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _screenshotmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="c" (GOTO _screenshot)
if /i "%choice%"=="b" (GOTO _screenshotseries)
if /i "%choice%"=="s" (GOTO _screenshotseriesauto)
@cls
goto _screenshotmenu

:_screenshot
call :_cdc
call :_hat
@echo.
rem StartRusTextBlock
@echo  Немного терпения, создается скриншот..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Please wait, creating a screenshot...
rem EndEngTextBlock
::@%MYFILES%\adb shell screencap -p /sdcard/screen.png
@%MYFILES%\adb exec-out screencap -p /sdcard/screen.png
call :_erlvl
@%MYFILES%\adb pull /sdcard/screen.png >nul
@%MYFILES%\adb shell rm /sdcard/screen.png
@For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
@For /f "tokens=1-3 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c)
@set mytime=%mytime: =%
@ren screen.png "Screenshot%mydate%_%mytime%.png"
@echo.
@echo ========================================
rem StartRusTextBlock
@echo  Скриншот сохранен в текущем каталоге.
@echo  Через пару секунд будет открыт программой по умолчанию.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Screenshot is saved in the current directory.
rem @echo  It will be opened by the default program in a couple of seconds.
rem EndEngTextBlock
@echo 
@ping localhost >nul
@start Screenshot%mydate%_%mytime%.png
@goto _returnmenu

:_screenshotseries
call :_cdc
@cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo  Немного терпения, создается скриншот..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Please wait, screenshot is being created...
rem EndEngTextBlock
@%MYFILES%\adb exec-out screencap -p /sdcard/screen.png
call :_erlvl
@%MYFILES%\adb pull /sdcard/screen.png >nul
@%MYFILES%\adb shell rm /sdcard/screen.png
@For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
@For /f "tokens=1-3 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c)
@set mytime=%mytime: =%
@ren screen.png "Screenshot%mydate%_%mytime%.png"
@ping localhost >nul
@cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo  Скриншот сохранен в текущем каталоге.
@echo. 
@echo  Нажмите Enter для создания следующего скриншота
@echo  Для завершения и выхода в меню введите 0 и нажмите Enter
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Screenshot saved in the current directory.
rem @echo.
rem @echo  Press Enter to create the next screenshot
rem @echo  To finish and return to the menu, enter 0 and press Enter
rem EndEngTextBlock
@set "choice="
@Set "choice=1"
@echo.
@Set /p choice=">> "
@echo.
if not defined choice goto _screenshotseries
if "%choice%"=="0" (GOTO _beginn)
if "%choice%"=="1" (GOTO _screenshotseries)
@goto _screenshotseries
@goto _returnmenu

:_screenshotseriesauto
call :_cdc
set intscrn=10
rem StartRusTextBlock
set /p intscrn="Введите интервал в секундах или 0 для выхода в меню и нажмите Enter : "
rem EndRusTextBlock
rem StartEngTextBlock
rem set /p intscrn="Enter the interval in seconds or 0 to return to the menu and press Enter: "
rem EndEngTextBlock
If %intscrn%==0 goto :_screenshotmenu
:_screenshotseriesauto1
call :_cdc
@cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo  Один бип - "Приготовиться, снимаю!"
@echo  Два бипа - "Снято!"
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  One beep - "Get ready, taking the screenshot!"
rem @echo  Two beeps - "Screenshot has been taken!"
rem EndEngTextBlock
@echo 
@echo.
@ping localhost -n 2 >nul
::@%MYFILES%\adb shell screencap -p /sdcard/screen.png
@%MYFILES%\adb exec-out screencap -p /sdcard/screen.png
call :_erlvl
@%MYFILES%\adb pull /sdcard/screen.png >nul
@%MYFILES%\adb shell rm /sdcard/screen.png
@For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
@For /f "tokens=1-3 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c)
@set mytime=%mytime: =%
@ren screen.png "Screenshot%mydate%_%mytime%.png"
@cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo  Один бип - "Приготовиться, снимаю!"
@echo  Два бипа - "Снято!"
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  One beep - "Get ready, taking the screenshot!"
rem @echo  Two beeps - "Screenshot has been taken!"
rem EndEngTextBlock
@echo.
@echo ========================================
rem StartRusTextBlock
@echo  Скриншот сохранен в текущем каталоге.
@echo ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Screenshot was saved in the current directory.
rem @echo ^>^>^> Press any key to interrupt ^<^<^<
rem EndEngTextBlock
@echo 
::@ping localhost -n %intscrn% >nul
rem StartRusTextBlock
timeout %intscrn%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem timeout %intscrn%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure was interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem EndEngTextBlock
@goto _screenshotseriesauto1

:_scrshcopy
rem StartRusTextBlock
@echo  ..Начато копирование скриншотов и видео...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo .. Copying srceenshots and videoshots started..
rem EndEngTextBlock
@chcp 866 1>nul
md "%userprofile%\Desktop\QuestMedia" 1>nul 2>nul
@%MYFILES%\adb pull "/sdcard/Oculus/Screenshots" "%userprofile%\Desktop\QuestMedia" >nul
@%MYFILES%\adb pull "/sdcard/Oculus/Videoshots" "%userprofile%\Desktop\QuestMedia" >nul
@chcp 65001 >nul
rem call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Скриншоты скопированы в каталог Screenshots на Рабочий стол
@echo  Каталог будет открыт через пару секунд
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Screenshots were copied to the Screenshots directory on the Desktop
rem @echo  The directory will open in a couple of seconds
rem EndEngTextBlock
@ping localhost >nul
@chcp 866 1>nul
@explorer "%userprofile%\Desktop\QuestMedia" >nul
@chcp 65001 >nul
@goto _returnmenu


:_adbwifimenu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo.
@echo    A.  Подключиться по Wi-Fi стандартно
@echo    B.  Подключиться по Wi-Fi через случайный порт
@echo.
@echo.
@echo   ВНИМАНИЕ:
@echo.
@echo   =============================================================
@echo   ^|  ЕСЛИ НА ШЛЕМЕ ЗАПУЩЕНо ПРИЛОЖЕНИЕ QUEST GAMEs OPTIMIZER, ^|
@echo   ^|    СТАНДАРТНОЕ Wi-Fi ПОДКЛЮЧЕНИЕ НАРУШИТ ЕГО РАБОТУ.      ^|
@echo   ^|     Если это случилось, просто перезагрузите шлем.        ^|
@echo   =============================================================
@echo.
@echo     Стандартное Wi-Fi подключение несовместимо с программой Quest Games Optimizer^!
@echo     Если вы используете эту программу, выбирайте опцию подключения по случайному порту.
@echo     В ином случае могут быть установлены сразу ДВА беспроводных подключения, что вызовет ошибки
@echo.
@echo     Если программа Quest Games Optimizer не используется или не была запущена, 
@echo     выбирайте стандартное подключение.
@echo     Но помните, что оно будет разорвано после запуска рограммы Quest Games Optimizer.
@echo     В этом случае для повторного подключения по беспроводу используйте опцию подключения
@echo     по случайному порту.
@echo.
@echo     Примечание: Подключение по случайному порту не будет работать без приложения
@echo     Quest Games Optimizer или комплекса Oculus Wireless ADB (пункты F-G-A)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Connect via standard Wi-Fi
rem @echo    B.  Connect via Wi-Fi using a random port
rem @echo.
rem @echo.
rem @echo   ATTENTION:
rem @echo.
rem @echo   =============================================================
rem @echo   ^|    IF QUEST GAMES OPTIMIZER IS RUNNING ON THE HEADSET,    ^|
rem @echo   ^|    STANDARD Wi-Fi CONNECTION WILL DISRUPT ITS OPERATION!  ^|
rem @echo   ^|        If this happens, simply reboot the headset.        ^|
rem @echo   =============================================================
rem @echo.
rem @echo     Standard Wi-Fi connection is incompatible with Quest Games Optimizer!
rem @echo     If you are using this program, choose the connection option via a random port.
rem @echo.
rem @echo     If Quest Games Optimizer is not being used or was not launched, 
rem @echo     choose the standard connection.
rem @echo     However, be aware that it will be disconnected if Quest Games Optimizer is launched.
rem @echo     In that case, to reconnect wirelessly, use the connection option via a random port.
rem @echo.
rem @echo     Note: Connection via a random port will not work without the Quest Games Optimizer 
rem @echo     app or the Oculus Wireless ADB suite (options F-G-A)
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _adbwifimenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _adbwifi)
if /i "%choice%"=="b" (GOTO _ConnectRandomPort)
rem if /i "%choice%"=="f" (GOTO _wifirestart)
@cls
goto _adbwifimenu

:_adbwifi
call :_cdc
rem StartRusTextBlock
@echo  Отключаем предыдущие соединения...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Disconnecting previous connections...
rem EndEngTextBlock
@%MYFILES%\adb.exe disconnect >nul
@echo.
rem StartRusTextBlock
@echo  Ждем инициализаци порта...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Waiting for port initialization...
rem EndEngTextBlock
@%MYFILES%\adb tcpip 5555 >nul
@ping localhost >nul
@echo.
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|findstr /i /c:"inet "') DO set ipfull=%%G
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO set ip=%%G
@if [%ip%]==[] goto _noip
rem StartRusTextBlock
@echo  Подключаемся к шлему по IP %ip%...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Connecting to the headset by IP %ip%...
rem EndEngTextBlock
@%MYFILES%\adb connect %ip% 1>nul 2>nul
@echo.
@ping localhost >nul
::@%MYFILES%\adb devices
@echo ========================================
rem StartRusTextBlock
@echo  Отсоедините кабель, шлем подключен по Wi-Fi.
@echo  Имейте в виду: c подключенным кабелем у вас будет ДВА устройства:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Disconnect the cable, the headset is connected via Wi-Fi.
rem @echo  Note: with the cable connected, you will have TWO devices:
rem EndEngTextBlock
@echo.
@%MYFILES%\adb devices
rem StartRusTextBlock
@echo  Это может вызвать ошибку "error: more than one device/emulator" 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  This may cause the error "error: more than one device/emulator".
rem EndEngTextBlock
@goto _exitout

:_noip
@echo ========================================
rem StartRusTextBlock
@echo  Шлем не получил IP адрес от роутера!
@echo  Проверьте подключение шлема к WiFi.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The headset did not receive an IP address from the router!
rem @echo  Check the headset's connection to Wi-Fi.
rem EndEngTextBlock
@goto _returnmenu

:_reconnect
rem call :_cdc
@echo.
rem StartRusTextBlock
@echo Секунду, идет переподключение на кабель...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  One moment, reconnecting via cable...
rem EndEngTextBlock
@%MYFILES%\adb kill-server
@%MYFILES%\adb start-server 1>nul 2>nul
@echo.
if errorlevel==1 goto _notfound
rem @%MYFILES%\adb.exe devices 
@echo ========================================
rem StartRusTextBlock
@echo = Шлем переподключен
@echo   Для продолжения работы подключите кабель и перезапустите программу
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset reconnected
rem @echo   To continue, connect the cable and restart the program
rem EndEngTextBlock
@goto _returnmenu

:_usbflash
call :_cdc
rem StartRusTextBlock
@echo        %_fBYellow%Вы уверены?%_fReset%
@echo   %_fBRed%===============================================================================
@echo    +++ После включения этой опции шлем можект перестать подключаться по ADB^^! +++
@echo            Для продолжения работы с ADB потребуется перезагрузка шлема
@echo   ===============================================================================%_fReset%
@echo   %_fBYellow%Для подтверждения нажмите %_fYellow%Enter%_fBYellow%. Для отмены и возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fBYellow%Are you sure?%_fReset%
rem @echo   %_fBRed%===============================================================================
rem @echo    +++ After enabling this option, the headset may stop connecting via ADB^^! +++
rem @echo            To continue working with ADB, a headset reboot will be required
rem @echo   ===============================================================================%_fReset%
rem @echo   %_fBYellow%To confirm, press %_fYellow%Enter%_fBYellow%. To cancel and return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"

if "!KEY!"=="27" goto _beginn
if "!KEY!"=="13" @%MYFILES%\adb shell svc usb setFunctions mtp true 1>nul 2>nul
call :_erlvl
@start explorer.exe
@echo ========================================
rem StartRusTextBlock
@echo  %_fBGreen%Шлем подключен как съемный диск%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset connected as a removable disk.
rem EndEngTextBlock
@goto _returnmenu

:_opensslerrorfix
rem StartRusTextBlock
@echo  Задаем системную переменную
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Setting the system variable.
rem EndEngTextBlock
@echo OPENSSL_ia32cap ~0x20000000
@setx OPENSSL_ia32cap ~0x20000000 /M
@ping localhost >nul
@echo ========================================
rem StartRusTextBlock
@echo  Системная переменная прописана
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  System variable set
rem EndEngTextBlock
@goto _returnmenu

:_ocsrvrestart
rem StartRusTextBlock
@echo  Рестартуем сервис, немного терпения...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Restarting the service, please wait...
rem EndEngTextBlock
@net stop OVRservice 1>nul 2>nul
@net start OVRservice 1>nul 2>nul
@if ERRORLEVEL == 1 GOTO _nosrv
@echo ========================================
rem StartRusTextBlock
@echo  Сервис перезапущен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Service restarted
rem EndEngTextBlock
@goto _returnmenu

:_nosrv
@echo ========================================
rem StartRusTextBlock
@echo  Служба OVRservice не найдена! Нечего перезапускать.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  OVRservice not found! Nothing to restart.
rem EndEngTextBlock
@goto _returnmenu

:_shellrestart
rem call :_cdc
rem StartRusTextBlock
@echo  Перезапускаем оболочку, ждите...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Restarting the shell, please wait...
rem EndEngTextBlock
@%MYFILES%\adb shell am kill com.oculus.vrshell 1>nul 2>nul
call :_erlvl
@%MYFILES%\adb shell am force-stop com.oculus.vrshel 1>nul 2>nul
@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.shellenv 1>nul 2>nul
@%MYFILES%\adb shell pm enable com.oculus.shellenv 1>nul 2>nul
@ping localhost >nul
@echo.
@echo ========================================
rem StartRusTextBlock
@echo  Оболочка перезапущена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Shell restarted
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_shellrestart2
:: --- Альтернативный вариант ---
rem StartRusTextBlock
@echo  Перезапускаем оболочку, ждите...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Restarting the shell, please wait...
rem EndEngTextBlock
@%MYFILES%\adb shell am kill com.oculus.shellenv 1>nul 2>nul
call :_erlvl
@%MYFILES%\adb shell am force-stop com.oculus.shellenv 1>nul 2>nul
@%MYFILES%\adb shell am start com.oculus.shellenv 1>nul 2>nul
:: --- Старый вариант ---
::@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.shellenv >nul
::@%MYFILES%\adb shell pm enable com.oculus.shellenv >nul
@ping localhost >nul
@echo.
@echo ========================================
rem StartRusTextBlock
@echo  Оболочка перезапущена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Shell restarted
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_openvpn
call :_cdc
rem StartRusTextBlock
@echo  Открываем настройки VPN в шлеме...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Opening VPN settings on the headset...
rem EndEngTextBlock
@%MYFILES%\adb shell "am start -n 'com.android.settings/.Settings$VpnSettingsActivity'" >nul
@ping localhost >nul
@echo ========================================
rem StartRusTextBlock
@echo  Настройки должны быть открыты, наденьте шлем.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Settings should be open, put on the headset.
rem EndEngTextBlock

@goto _returnmenu

:_wificontrol
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    D.  Отключение Wi-Fi на шлеме
@echo    E.  Включение Wi-Fi на шлеме
@echo    F.  Рестарт Wi-Fi на шлеме
@echo    G.  Открыть настройки Wi-Fi на шлеме
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    D.  Disable Wi-Fi on the headset
rem @echo    E.  Enable Wi-Fi on the headset
rem @echo    F.  Restart Wi-Fi on the headset
rem @echo    G.  Open Wi-Fi settings on the headset
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _wificontrol
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="d" (GOTO _wifidisable)
if /i "%choice%"=="e" (GOTO _wifienable)
if /i "%choice%"=="f" (GOTO _wifirestart)
if /i "%choice%"=="g" (GOTO _wifisettingsopen)
@cls
goto _wificontrol




:_wifidisable
:::::::::::::::::
@%MYFILES%\adb shell "svc wifi disable"
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Wi-Fi отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Wi-Fi disabled
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_wifienable
:::::::::::::::::
@%MYFILES%\adb shell "svc wifi enable"
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Wi-Fi включен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Wi-Fi enabled
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_wifirestart
@%MYFILES%\adb shell "svc wifi disable"
call :_erlvl
@timeout 3 >nul
@%MYFILES%\adb shell "svc wifi enable"
@echo ========================================
@echo  Wi-Fi restarted
call :_prevmenu
@goto _shellmenu

:_wifisettingsopen
@%MYFILES%\adb shell am start -a android.net.wifi.PICK_WIFI_NETWORK 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Настройки Wi-Fi открыты на шлеме
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Wi-Fi settings on the headset was open
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_autosenderr
rem @%MYFILES%\adb shell pm disable-user --user 0 com.oculus.presence
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Опция отключения автоотправки отчетов удалена.
@echo  Отключить и включить ее можно через мобильное приложение:
@echo  Настройки гарнитуры - Расширенный настройки.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The option for disabling automatic report sending has been removed.
rem @echo  You can disable and enable it through the mobile application:
rem @echo  Headset Settings - Advanced Settings.
rem EndEngTextBlock
@goto _returnmenu

:_homescreen
@%MYFILES%\adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME 1>nul 2>nul
::@%MYFILES%\adb shell input keyevent 3
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  В шлеме вы увидите стандартное Виртуальное окружение
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  In the headset, you will see the standard Virtual Environment.
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
:: Quest Update Tool
::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_CheckFirmwareOldVersion
rem echo on
call :_hsfwversionextract
rem set hsversion=49.0.0.368
rem set hsversion=65.0.0.368
if [%hsversion%]==[] goto _AttentionMSG
if [%hsversion:~0,2%] LSS [71] (
rem StartRusTextBlock
@echo ╔═══════════════════════════════════ %_fBRed%+++  ВНИМАНИЕ +++%_fReset%  ═════════════════════════════════════════╗
@echo ║                                                                                                ║
@echo ║     %_fBYellow%На шлеме довольно старая версия прошивки. Не обновляйтесь сразу до последней версии.%_fReset%       ║
@echo ║            %_fBYellow%Желательно сначала обновиться до v71, а потом ставить версии выше.   %_fReset%               ║
@echo ║                                                                                                ║
@echo ║              %_fBRed%ПРОШИВАЙТЕ ШЛЕМ ТОЛЬКО ЕСЛИ ВЫ ТОЧНО ЗНАЕТЕ ЧТО ДЕЛАЕТЕ%_fReset%                           ║
@echo ║                                                                                                ║
@echo ║        %_fBRed%Автор программы не несет ответственность за риск окирпичивания шлема%_fReset%                    ║
@echo ║                                                                                                ║
@echo ╚════════════════════════════════════════════════════════════════════════════════════════════════╝
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ╔═══════════════════════════════════ %_fBRed%+++  WARNING +++%_fReset%  ═════════════════════════════════════════╗
rem @echo ║                                                                                               ║
rem @echo ║   %_fBYellow%The headset has a very old firmware version. Do not update directly to the latest version.%_fReset%  ║
rem @echo ║                                                                                               ║
rem @echo ║   %_fBRed%ONLY PERFORM MANUAL FIRMWARE UPDATES IF YOU KNOW EXACTLY WHAT YOU ARE DOING%_fReset%                 ║
rem @echo ║                                                                                               ║
rem @echo ║   %_fBRed%The program author is not responsible for the risk of bricking the headset%_fReset%                  ║
rem @echo ║                                                                                               ║
rem @echo ╚═══════════════════════════════════════════════════════════════════════════════════════════════╝
rem EndEngTextBlock

exit /b
)
)

:_AttentionMSG
rem StartRusTextBlock
@echo ╔═══════════════════════════════════ %_fBRed%+++  ВНИМАНИЕ +++%_fReset%  ═════════════════════════════════════════╗
@echo ║                                                                                                ║
@echo ║              %_fBRed%ПРОШИВАЙТЕ ШЛЕМ ТОЛЬКО ЕСЛИ ВЫ ТОЧНО ЗНАЕТЕ ЧТО ДЕЛАЕТЕ%_fReset%                           ║
@echo ║                                                                                                ║
@echo ║        %_fBRed%Автор программы не несет ответственность за риск окирпичивания шлема%_fReset%                    ║
@echo ║                                                                                                ║
@echo ╚════════════════════════════════════════════════════════════════════════════════════════════════╝
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ╔═══════════════════════════════════ %_fBRed%+++  WARNING +++%_fReset%  ═════════════════════════════════════════╗
rem @echo ║                                                                                               ║
rem @echo ║   %_fBRed%ONLY PERFORM MANUAL FIRMWARE UPDATES IF YOU KNOW EXACTLY WHAT YOU ARE DOING%_fReset%                 ║
rem @echo ║                                                                                               ║
rem @echo ║   %_fBRed%The program author is not responsible for the risk of bricking the headset%_fReset%                  ║
rem @echo ║                                                                                               ║
rem @echo ╚═══════════════════════════════════════════════════════════════════════════════════════════════╝
rem EndEngTextBlock
exit /b

:_fwmenu
cls
endlocal
@echo.
@echo.
rem StartRusTextBlock
@echo  ADB запускается...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ADB is starting...
rem EndEngTextBlock
call :_SetFirmwareFileName

setlocal enableextensions enabledelayedexpansion

call :_CheckSideloadMode
call :_CheckBootloaderMode
::@call :_CheckCableMode
::@call :_CheckWiFiMode
::@call :_CheckDoubleOrNoDeviceMode
::@call :_CheckDevMode
::@call :_CheckAfterWiFiCheckMode
:: Меню прошивки
:_fwmenuskip
@cls
@%verbecho%
call :_hat
@echo.
call :_hatqut
@echo.
rem @echo.
@echo.
call :_CheckFirmwareOldVersion
@echo.
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  Полностью автоматическая прошивка
@echo    B.  Кнопочная автоматическая прошивка
@echo    C.  Извлечь ссылки на прошивки из шлема и скачать файлы прошивок   [EXP]
@echo    CC. Только извлечь ссылки на прошивки из шлема, не скачивая файлы прошивок   [EXP]
@echo    D.  Скачать различные версии прошивок для шлемов Meta Quest
@echo    E.  Показать текущую версию прошивки шлема и проверить актуальность
@echo    F.  Анализатор прошивок: проверка файла %FirmwareFileName% на корректность и совместимость
@echo    G.  Скачать таблицы соответствия версий среды версиям прошивок шлемов
@echo    I.  Дополнительные пояснения про инкрементальные прошивки
@echo.
@echo    %_fBYellow%H. Помощью по опциям%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Fully automatic firmware flashing
rem @echo    B.  Button-triggered automatic firmware flashing
rem @echo    C.  Extract firmware links from headeset and download firmware files   [EXP]
rem @echo    CC. Only extract firmware links from headset without downloading firmware files   [EXP]
rem @echo    D.  Open the website with firmware versions
rem @echo    E.  Show the current firmware version of the headset and check for updates
rem @echo    F.  Firmware analyzer: check the FW file for correctness and compatibility
rem @echo    G.  Download compatibility tables for environment versions and headset firmware versions
rem @echo    I.  Additional explanations about incremental firmware updates
rem @echo.  
rem @echo    %_fBYellow%H. Help%_fReset%
rem EndEngTextBlock
rem @echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _fwmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _firmwareautostart)
if /i "%choice%"=="b" (GOTO _firmwarebutton)
if /i "%choice%"=="c" (GOTO _fwdownload)
if /i "%choice%"=="cc" (GOTO _fwdownload)
if /i "%choice%"=="d" (GOTO _fwsitelink)
if /i "%choice%"=="e" (GOTO _fwtxtcompare)
if /i "%choice%"=="f" (GOTO _CheckFirmwareUpdate)
if /i "%choice%"=="g" (GOTO _DownloadAllFWfiles)
if /i "%choice%"=="i" (GOTO _DopHelp)
if /i "%choice%"=="h" (call :_fwhelp)
if /i "%choice%"=="ftp" (GOTO _ftpmenu)

@cls
goto _fwmenu

:_fwsitelink
@start " " "https://cocaine.trade/"
goto :_fwmenuskip

:_fwhelp
cls
@echo.
rem StartRusTextBlock
@echo   %_fBGreen%Опция "Полностью автоматическая прошивка" %_fReset%служит для прошивки шлема в автоматическом режиме.
@echo   Чтобы прошить шлем, следует положить рядом с программой файл прошивки в формате %_fBYellow%zip%_fReset%,
@echo   подключить шлем кабелем к ПК, запустить %_fBYellow%Quas%_fReset% и выбрать пункт %_fBYellow%A%_fReset% в этом разделе. После этого
@echo   %_fBYellow%Quas%_fReset% проверит файл на корректность и если все в порядке появится надпись "%_fBYellow%Файл прошивки найден%_fReset%"
@echo   и название модели подключенного устройства. Далее можно нажать кнопку %_fBYellow%Enter%_fReset% и начнется процесс
@echo   загрузки прошивки в шлем. На всем протяжении процесса будут появляться подсказки и пояснения
@echo   по каждому этапу. По завершении загрузки также появится сообщение. Процесс загрузки 
@echo   полностью автоматический и не требует каких-то дополнительных действий или вмешательств.
@echo   %_fCyan%Для прошивки этой опцией требуется включенный Режим разработчика.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Кнопочная автоматическая прошивка"%_fReset% выполняется из режима %_fBYellow%Bootloader%_fReset%, поэтому она
@echo   содержит только пояснение-подсказку о том, какие кнопки следует нажать, чтобы зайти в этот
@echo   режим. Нужно выключить шлем, затем одновременно нажать кнопки %_fBYellow%Питание%_fReset% и %_fBYellow%Громкость-минус%_fReset%
@echo   (%_fBYellow%ближняя к носу%_fReset%). Держать кнопки до появления лого, потом их можно отпустить. Через
@echo   пару секунд появится бело-синее меню %_fBYellow%USB Update Mode%_fReset%, это и есть %_fBYellow%Bootloader%_fReset%. После этого
@echo   подключите шлем кабелем к ПК и запустите программу %_fBYellow%Quas%_fReset%. Программа автоматически обнаружит
@echo   режим %_fBYellow%Bootloader%_fReset% и сообщит об этом. Далее можно нажать %_fBYellow%Enter%_fReset% для прошивки и снова %_fBYellow%Enter%_fReset%
@echo   для подтверждения. Процесс загрузки прошивки ничем не отличается от полного автоматического. 
@echo   %_fCyan%Для прошивки этим способом Режим разработчика не требуется.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Извлечь ссылки на прошивки из шлема и скачать файлы прошивок" %_fReset%скачивает прошивки,
@echo   ссылки на которые часто содержит шлем. Довольно долго они остаются в логах шлема, и %_fBYellow%Quas%_fReset%
@echo   выдергивает их оттуда. Ссылок может оказаться несколько. После скачивания %_fBYellow%Quas%_fReset% определяет
@echo   версию среды прошивки и переименовывает файлы в соответствии с этой версией. Версия среды
@echo   и ссылка на соответствующую прошивку сохраняется в файл %_fBYellow%fwlinks.txt%_fReset% рядом с программой.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Только извлечь ссылки на прошивки из шлема, не скачивая файлы прошивок" %_fReset%работает 
@echo   точно так же, сохраняя ссылки в файл %_fBYellow%Link.txt%_fReset%, но файлы прошивок не скачиваются.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Скачать различные версии прошивок для шлемов Meta Quest" %_fReset%открывает сайт, где можно
@echo   скачать все прошивки для всех моделей шлемов %_fBYellow%Meta Quest.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Показать текущую версию прошивки шлема и проверить актуальность" %_fReset%сверяет текущую версию
@echo   прошивки шлема с последней имеющейся на сайте по ссылке в предыдущем пункте. При наличии новой
@echo   прошивки будет предложено ее скачать и при утвердительном ответе %_fBYellow%Quas%_fReset% сделает это сам.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Анализатор прошивок: проверка файла прошивки на корректность и совместимость" %_fReset%служит
@echo   для анализа файла прошивки: проверяет на все, что перечислено в опции, на целостность и т.д.
@echo   Анализатор подскажет, возможна ли прошивка шлема этим файлом, и если нет, объяснит причину.
@echo   После анализа файла он будет переименован в соответствии с моделью шлема и версией прошивки.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Скачать таблицы соответствия версий среды версиям прошивок шлемов" %_fReset%скачивает таблицы,
@echo   в которых будет указан номер версии среды и соответствующий ему номер версии прошивки шлема.
@echo   Файлы скачиваются сразу для всех пяти версий шлемов %_fBYellow%Meta Quest%_fReset%. Ненужные файлы можно удалить.%_fReset%
@echo.
@echo   %_fBGreen%Опция "Дополнительные пояснения про инкрементальные прошивки" говорит сама за себя.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%The "Fully Automatic Flashing" option %_fReset%is used to flash the headset in automatic mode. To flash
rem @echo   the headset, place the %_fBYellow%Quas%_fReset% program next to the firmware file in %_fBYellow%zip%_fReset% format, connect the headset
rem @echo   to the PC with a cable, and select option %_fBYellow%A%_fReset%. After that, the program will check the file for
rem @echo   correctness, and if everything is fine, the message "%_fBYellow%Firmware file found%_fReset%" will appear, along
rem @echo   with the model name of the connected device. Then you can press %_fBYellow%Enter%_fReset% and the firmware loading
rem @echo   process will begin. Throughout the process, hints and explanations will be displayed for each
rem @echo   stage. After the upload is completed, a message will also appear. The process
rem @echo   is fully automatic and requires no additional actions or intervention.
rem @echo   %_fCyan%This option requires Developer Mode to be enabled.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Button-Controlled Automatic Flashing" option %_fReset%is performed from %_fBYellow%Bootloader%_fReset% mode, so it
rem @echo   only contains a hint explaining which buttons to press to enter this mode.
rem @echo   You need to power off the headset, then press and hold the %_fBYellow%Power%_fReset% and %_fBYellow%Volume Down%_fReset%
rem @echo   (%_fBYellow%the button closer to the nose%_fReset%) simultaneously. Hold them until the logo appears, then release.
rem @echo   After a few seconds, the white-blue %_fBYellow%USB Update Mode%_fReset% menu will appear — this is the %_fBYellow%Bootloader%_fReset%.
rem @echo   Then connect the headset to the PC with a cable and run the %_fBYellow%Quas%_fReset% program. The program will
rem @echo   automatically detect %_fBYellow%Bootloader%_fReset% mode and report it. Then you can press %_fBYellow%Enter%_fReset% to flash and press
rem @echo   %_fBYellow%Enter%_fReset% again to confirm. The flashing process is the same as in the fully automatic option.
rem @echo   %_fCyan%Developer Mode is not required for this flashing method.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Extract firmware links from the headset and download firmware files" option %_fReset%downloads FW
rem @echo   from links that the headset often contains. These links remain in the headset logs for quite a
rem @echo   long time, and %_fBYellow%Quas%_fReset% extracts them from there. There may be several links. After downloading, %_fBYellow%Quas%_fReset%
rem @echo   determines the FW environment version and renames the files accordingly. The environment version
rem @echo   and the link to the corresponding firmware are saved in the %_fBYellow%fwlinks.txt%_fReset% file next to the program.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Only extract firmware links from the headset without downloading firmware files" option %_fReset%
rem @echo   works the same way, saving the links into the %_fBYellow%Link.txt%_fReset% file, but the FW files are not downloaded.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Download different firmware versions for Meta Quest headsets" option %_fReset%opens a website
rem @echo   where you can download all firmware for all %_fBYellow%Meta Quest%_fReset% headset models.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Show the current headset FW version and check for updates" option %_fReset%compares the current FW
rem @echo   version of the headset with the latest available on the website mentioned in the previous option.
rem @echo   If a new FW is available, you will be offered to download it, %_fBYellow%Quas%_fReset% will do it automatically.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Firmware Analyzer: check FW file for validity and compatibility" option %_fReset%is used to analyze
rem @echo   a FW file: it checks everything listed in the option, including integrity, etc. The analyzer
rem @echo   will indicate whether the headset can be flashed with this file, and if not, it will explain
rem @echo   why. After the analysis, the file will be renamed according to the headset model and FW version.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Download compatibility tables of environment versions with headset firmware versions" option
rem @echo   %_fReset%downloads tables showing the environment version number and the corresponding headset FW version
rem @echo   number. Files are downloaded for all five %_fBYellow%Meta Quest%_fReset% headset models at once.%_fReset%
rem @echo.
rem @echo   %_fBGreen%The "Additional explanations about incremental firmware" option speaks for itself.%_fReset%
rem EndEngTextBlock
call :_prevmenu
exit /b


@echo ----------------------------------------------------------------------
rem StartRusTextBlock
@echo    ee	: Сравнить версии, если новее, записать в fw.txt и выгрузить
@echo    ff	: Дополнительный help по инкрементным прошивкам
@echo    ftp	: Загрузить/выгрузить файлы fw и allfwlinks
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    ee	: Compare versions, if newer, write to fw.txt and download
rem @echo    ff	: Additional help on incremental firmware updates
rem @echo    ftp	: Upload/download fw and allfwlinks files
rem EndEngTextBlock
@echo ----------------------------------------------------------------------



:_ftpmenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo       +++  СЕРВИСНОЕ МЕНЮ +++
@echo  ИСПОЛЬЗУЕТСЯ ТОЛЬКО ДЛЯ СЛУЖЕБНЫХ ЦЕЛЕЙ.
@echo.
@echo.
@echo.
@echo    A. Обновить все CT
@echo.
@echo.
@echo    C.  Скачать allfwlinks.txt
@echo    D.  Залить allfwlinks.txt на FTP
@echo    E.  Скачать allfwlinks.txt, удалить дубли строк и залить на FTP
@echo.
@echo    F.  Меню прошивки
@echo    G.  Скачать и забэкапить все файлы
@echo    Y.  Скачать firmwares.yaml

rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       +++  SERVICE MENU^! +++
rem @echo  FOR SERVICE PURPOSES ONLY.
rem @echo.
rem @echo.
rem @echo    A.   Download fw.txt
rem @echo.
rem @echo    C.  Download allfwlinks.txt
rem @echo    D.  Upload allfwlinks.txt to FTP
rem @echo    E.  Download allfwlinks.txt, remove duplicate lines, and upload to FTP
rem @echo.
rem @echo    F.  Firmware menu
rem @echo    G.  Download and backup all files
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _ftpmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (call :_CTFilesUpdate)
if /i "%choice%"=="c" (call :_GetFTPalllinks)
if /i "%choice%"=="d" (call :_PutFTPlllinks)
if /i "%choice%"=="e" (call :_AlllinksNoDoubles)
if /i "%choice%"=="f" (GOTO _fwmenu)
if /i "%choice%"=="g" (GOTO _fwtxtbackup)
if /i "%choice%"=="y" (GOTO _fwyamldl)

@cls
goto _ftpmenu


:_fwyamldl
rem https://cocaine.trade/firmwares.yaml
curl -4 -LJko firmwares.yaml --resolve cocaine.trade:443:45.150.123.10 "https://cocaine.trade/firmwares.yaml" -Ss 1>nul 2>nul
@echo Done.
call :_prevmenu
goto :_ftpmenu



:_CTFilesUpdate

for %%f in (fw2.txt fw3.txt fwp.txt fws.txt) do (
set "ftpfile=%%f"
call :_DownloadCTrade
)
@echo Готово, CT на Кофре, нужно их обновить и переименовать.
pause >nul
exit /b

:_DownloadCTrade
if %ftpfile%==fw2.txt set ctlink=Quest_2_firmware&&set CTSourceFile=ct2.txt
if %ftpfile%==fw3.txt set ctlink=Quest_3_firmware&&set CTSourceFile=ct3.txt
if %ftpfile%==fwp.txt set ctlink=Quest_Pro_firmware&&set CTSourceFile=ctp.txt
if %ftpfile%==fws.txt set ctlink=Quest_3S_firmware&&set CTSourceFile=cts.txt
curl -4 -LJko %CTSourceFile% --resolve cocaine.trade:443:45.150.123.10 "https://cocaine.trade/%ctlink%" -Ss 1>nul 2>nul
curl "https://app.koofr.net/content/receivers/408b405f-adf8-41da-a1c1-05d45ddc9c7d/files/put" -X POST -F "file=@%CTSourceFile%"  -Ss 1>nul 2>nul
exit /b



:_DownloadAllFWfiles
rem echo = fw.txt
rem set ftpfile=fw.txt
rem call :_GetFTP
echo = fw1.txt
set ftpfile=fw1.txt
call :_GetFTP
echo = fw2.txt
set ftpfile=fw2.txt
call :_GetFTP
echo = fw3.txt
set ftpfile=fw3.txt
call :_GetFTP
echo = fwp.txt
set ftpfile=fwp.txt
call :_GetFTP
echo = fws.txt
set ftpfile=fws.txt
call :_GetFTP
@echo ---------------
rem StartRusTextBlock
@echo = Все fw.txt скачаны
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = All fw.txt files downloaded
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _fwmenuskip

:_fwtxtbackup
call :_settime
@md %~dp0\ftp\ 2>nul
set ftpfile=fw.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul
set ftpfile=fw1.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul
set ftpfile=fw2.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul
set ftpfile=fw3.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul
set ftpfile=fwp.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul
set ftpfile=alllinks.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul
set ftpfile=allfwlinks.txt
call :_GetFTP
@move %ftpfile% %~dp0\ftp\ 1>nul 2>nul

@%myfiles%\7z.exe a -mx7 -t7z ftpfiles-%dt%.7z %~dp0\ftp
@move ftpfiles-%dt%.7z d:\P\Dropbox\SecureWallet\HomeDevices\Quest\Backups\
@rd /s /q %~dp0\ftp
@echo ---------------------------------
rem StartRusTextBlock
@echo  = Готово
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Done
rem EndEngTextBlock
@echo.
goto _prevmenu
goto _ftpmenu


:: FTPfw
:_GetFTPfw
call :_SetFWtxtFileName
:_GetFTPfwtxt
set ftpfile=%fwtxt%
call :_GetFTP
@echo ---------------
rem StartRusTextBlock
@echo = %fwtxt% скачан
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = %fwtxt% downloaded
rem EndEngTextBlock
@echo.
call :_prevmenu
exit /b

:_PutFTPfw
call :_SetFWtxtFileName
:_PutFTPfwtxt
set ftpfile=%fwtxt%
rem set ftpfile=fw.txt
call :_PutFTP
@echo ---------------
rem StartRusTextBlock
@echo = %fwtxt% залит на FTP
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = %fwtxt% uploaded to FTP
rem EndEngTextBlock

@echo.
call :_prevmenu
exit /b

::FTPalllinks
:_GetFTPalllinks
set ftpfile=allfwlinks.txt
call :_GetFTP
@echo ---------------
rem StartRusTextBlock
@echo = allfwlinks.txt скачан
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = allfwlinks.txt downloaded
rem EndEngTextBlock
@echo.
call :_prevmenu
exit /b

:_PutFTPlllinks
set ftpfile=allfwlinks.txt
call :_PutFTP
@echo ---------------
rem StartRusTextBlock
@echo = allfwlinks.txt залит на FTP
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = allfwlinks.txt uploaded to FTP
rem EndEngTextBlock
@echo.
call :_prevmenu
exit /b

:_AlllinksNoDoubles
set ftpfile=allfwlinks.txt
call :_GetFTP
ren allfwlinks.txt alllinksdoubles.txt
@for /f "tokens=*" %%a in (alllinksdoubles.txt) do (
@findstr /l /c:"%%a" allfwlinks.txt 1>nul 2>nul || @echo %%a>>allfwlinks.txt
)
call :_PutFTP
@del allfwlinks.txt /q /f 1>nul 2>nul
@del alllinksdoubles.txt /q /f 1>nul 2>nul
@echo ---------------
rem StartRusTextBlock
@echo = allfwlinks.txt очищен от дублирующих строк
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = allfwlinks.txt cleaned from duplicate lines
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock

@pause 1>nul 2>nul
exit /b
goto _ftpmenu

:_CheckFirmwareUpdate
@%verbecho%
setlocal enableextensions enabledelayedexpansion
:: Проверка на корректность файла прошивки
::if exist "%FirmwareFileName%.zip" ren "%FirmwareFileName%.zip" "%FirmwareFileName%"
::@echo %FirmwareFileName%
::pause

if not exist %FirmwareFileName% goto _NOTEXIST
@%myfiles%\7z.exe t %FirmwareFileName% metadata -r -y 1>nul 2>error.txt
if %errorlevel% GTR 0 goto _ArchiveError
@del error.txt /f /q
@%myfiles%\7z.exe l %FirmwareFileName%  2>error.txt | findstr payload.bin >nul
if %errorlevel% GTR 0 goto _FWWRONG
@del error.txt /f /q
goto _ViewFirmware

:_ArchiveError
@cls
@echo -----------------------------------------------------
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fBRed%+++++ С файлом %FirmwareFileName% что-то не так +++++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBRed%+++++ Something is wrong with the %FirmwareFileName% file +++++%_fReset%
rem EndEngTextBlock
::@@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  ТЕКСТ ОШИБКИ:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ERROR TEXT:
rem EndEngTextBlock
@echo -----------------------------------------------------
@type error.txt
@echo -----------------------------------------------------
@echo.
@del error.txt /f /q
goto _returnmenu

:_ViewFirmware
rem @echo.
rem StartRusTextBlock
@echo    %_fBYellow%+++ Минутку, анализируем данные...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo +++ Just a moment, analyzing the data...
rem EndEngTextBlock
call :_ExtractBuildVersionsNumbers
call :_ExtractFirmwareVersion
call :_ExtractPreBuildNumber comparemark
call :_CheckBuildsFullInc 
call :_ViewAndCompateDeviceName
call :_CompareVersion
rem cls

rem :_CompareTimeStampData
for /f "tokens=2 delims=()" %%a in ('%myfiles%\adb shell dumpsys time_detector ^| findstr "mAutoSuggestionLowerBound"') do (
set num=%%a
set /a hstimestampdata=!num:~0,-3!
goto _fwtablist
)
:_fwtablist

if "%hstimestampdata%" GEQ "%fwtimestampdata%" (
rem StartRusTextBlock
set fwtscol=%_fBRed%%fwtimestampdata% %_fRed%  [ На шлеме более новая или та же самая версия прошивки ]%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem set fwtscol=%_fBRed%%fwtimestampdata% %_fRed%  [ The headset has a newer or the same firmware version ]%_fReset%
rem EndEngTextBlock
set hstscol=%_fBGreen%%hstimestampdata%%_fReset%
) else (
set fwtscol=%_fBGreen%%fwtimestampdata%%_fReset%
set hstscol=%_fBGreen%%hstimestampdata%%_fReset%
)


rem if %headpad% gtr %postpad% (
rem echo Ok
rem ) else (
rem echo Not Ok
rem )
::!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@if %fwpreb%==----------- (set incfull=-Full) else (set incfull=-inc-for-%fwpreb%)
rem @ren update.zip %fmfilename%-%fwnfilename%%incfull%.zip 2>nul 1>nul
rem @ren update.zip %fmfilename%-!fwpostn!%incfull%.zip 2>nul 1>nul
@ren update.zip %fmfilename%-%fwpostn%%incfull%.zip 2>nul 1>nul
call :_hat
@echo.
rem StartRusTextBlock
@echo					=== АНАЛИЗАТОР ПРОШИВОК ===
@echo.
@echo  --------------------------------------------------------------------------------------------------
@echo. %_fCyan%Версия прошивки шлема%_fReset%	: %_fBCyan%%fwver%%_fReset%	: %_fBCyan%%headbuild%%_fReset%	: %_fCyan%Модель шлема%_fReset%	: %_fBCyan%%DevModelNm%
@echo. %_fCyan%Версия файла прошивки%_fReset%	: %_fBCyan%!fwpostn!%_fReset%	: %_fBCyan%%postbuild%%_fReset%	: %_fCyan%Прошивка для%_fReset%	: %_fBCyan%%UpzModelNm%
@echo. %_fCyan%Версия базы инкремента%_fReset%	: %_fBCyan%!fwpreb!%_fReset%	: %_fBCyan%%prebuild%%_fReset%	: %_fCyan%Совместимость%_fReset%	: %IntPrdCompt%
@echo. %_fCyan%Полная/Инкрементная%_fReset%	: %_fBCyan%%setfullinc%%_fReset%	:			:
@echo  --------------------------------------------------------------------------------------------------
@echo  %_fCyan%Timestamp шлема%_fReset%	: %hstscol%
@echo  %_fCyan%Timestamp прошивки%_fReset%	: %fwtscol%
@echo  --------------------------------------------------------------------------------------------------
@echo.
@echo  Версия базы инкремента - это Версия прошивки шлема, для которой предназначен именно этот инкремент.
@echo.
@echo  Иначе говоря, Версия прошивки шлема: 	[ %_fBCyan%%fwver%%_fReset% ]
@echo  и Версия базы инкремента: 		[ %_fBCyan%%fwpreb%%_fReset% ] 
@echo  должны быть одинаковыми.
@echo.
@echo  Если прошивка полная, версия инкремента не отображается
@echo  А версия файла прошивки должна быть выше текущей версии прошивки шлема.
@echo.
@echo  ----------------------------------------------
@echo  %_fBYellow%== РЕЗУЛЬТАТ ПРОВЕРКИ:%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo					=== FIRMWARE ANALYZER ===
rem @echo.
rem @echo  --------------------------------------------------------------------------------------------------
rem @echo. %_fCyan%Headset firmware version%_fReset%	: %_fBCyan%%fwver%%_fReset%	: %_fBCyan%%headbuild%%_fReset%	: %_fCyan%Headset model%_fReset%	: %_fBCyan%%DevModelNm%%_fReset%
rem @echo. %_fCyan%Firmware file version%_fReset%		: %_fBCyan%!fwpostn!%_fReset%	: %_fBCyan%%postbuild%%_fReset%	: %_fCyan%Firmware for%_fReset%	: %_fBCyan%%UpzModelNm%%_fReset%
rem @echo. %_fCyan%Increment base version%_fReset%		: %_fBCyan%!fwpreb!%_fReset%	: %_fBCyan%%prebuild%%_fReset%	: %_fCyan%Compatibility%_fReset%	: %IntPrdCompt%
rem @echo. %_fCyan%Full/Incremental%_fReset%		: %_fBCyan%%setfullinc%%_fReset%	:			:
rem @echo  --------------------------------------------------------------------------------------------------
rem @echo  %_fCyan%Headeset timestamp%_fReset%	: %hstscol%
rem @echo  %_fCyan%Firmware timestamp%_fReset%	: %fwtscol%
@echo  --------------------------------------------------------------------------------------------------
rem @echo.
rem @echo  The increment base version is the headset firmware version 
rem @echo  for which this increment is intended.
rem @echo.
rem @echo  In other words, Headset firmware version: 	[ %_fBCyan%%fwver%%_fReset% ]
rem @echo  and Increment base version: 			[ %_fBCyan%%fwpreb%%_fReset% ] 
rem @echo  should be the same.
rem @echo.
rem @echo  If the firmware is uptodate, the increment version is not displayed.
rem @echo  And the version of the %FirmwareFileName% file should be newer than the headset firmware version.
rem @echo.
rem @echo  ----------------------------------------------
rem @echo  %_fBYellow%== CHECK RESULT:%_fReset%
rem EndEngTextBlock
::@@echo.
rem rem @del fw.txt 2>&1 1> nul | findstr /V "" 1> nul 2>&1
@del %fwtxt% 2>&1 1> nul | findstr /V "" 1> nul 2>&1
if %errorlevel%==0 goto _NoInternetMessage
::@del fw.txt /q 1>NUL 2>&1
if not [%bl%]==[] goto _blmessage
@For /F %%r In ('@%myfiles%\adb shell getprop ro.boot.serialno') Do set sn=%%r
if [%sn%]==[] goto _NoHeadsetMessage
if %IntProductName% NEQ %UpZipIntProductName% goto _Uncompatible

call :_ChoiceFunctions

:_ExtractBuildVersionsNumbers
@%myfiles%\7z.exe e %FirmwareFileName% metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"post-build-incremental" metadata 2^>nul') DO @set postbuild=%%k
@FOR /F "tokens=2 delims==" %%t IN ('@FINDstr /c:"pre-build-incremental" metadata 2^>nul') DO @set prebuild=%%t
@FOR /F "tokens=2 delims==" %%s IN ('@FINDstr /c:"post-timestamp" metadata 2^>nul') DO @set fwtimestampdata=%%s
@For /F %%f In ('@%MYFILES%\adb shell getprop ro.build.version.incremental 2^>nul') Do set headbuild=%%f
if [%prebuild%]==[] set prebuild=-----------------
if [%headbuild%]==[] set headbuild=-----------------
del metadata /q 1>nul 2>nul
exit /b


::>>>>>>>>>>>>>>>>>
:_ExtractFirmwareVersion
call :_hsfwversionextract
set fwver=%hsversion%
if [%fwver%]==[] set fwver=------------
@echo.
@del %fwtxt% /q 1>NUL 2>&1
call :_SetFWtxtFileName
set ftpfile=%fwtxt%
call :_GetFTP

:_fw
echo on
@%verbecho%
@For /F "tokens=1,2 delims= " %%a In (%fwtxt%) Do (
@set fwpostbuildfile=%%a
@set fwpostn=%%b
if !postbuild! == !fwpostbuildfile! (
exit /b
) else (
rem @echo %fwtxt%
rem @echo fwpbf !fwpostbuildfile!
rem @echo fwp !fwpostn!
rem @echo !prebuild!
rem @echo !postbuild!
rem pause
rem StartRusTextBlock
@set "fwpostn=Неизвестно"
rem EndRusTextBlock
rem StartEngTextBlock
rem set fwpostn=Unknown
rem EndEngTextBlock
)
)
exit /b

@For /F "tokens=1,2 delims= " %%a In (%fwtxt%) Do (
@set fwheadbuildfile=%%a
@set fwheadn=%%b
@if !headbuild! == !fwheadbuildfile! (
exit /b
)
)
exit /b

:_ExtractPreBuildNumber
@For /F "tokens=1,2 delims= " %%a In (%fwtxt%) Do (
@set fwprebuildfile=%%a
@set fwpreb=%%b
if %prebuild%==----------------- set fwpreb=----------- && exit /b
if !prebuild! == !fwprebuildfile! (
exit /b
) else (
rem StartRusTextBlock
@set "fwpreb=Неизвестно"
rem EndRusTextBlock
rem StartEngTextBlock
rem @set "fwpreb=Unknown"
rem EndEngTextBlock
)
)
exit /b

:_CheckBuildsFullInc
::@if not exist fw.txt set fwpreb=Интернет йок & set fwpostn=Интернет йок
rem rem @if not exist fw.txt set fwpreb=No Internet. & set fwpostn=No Internet.
@if not exist %fwtxt% set fwpreb=No Internet. & set fwpostn=No Internet.

if %prebuild%==----------------- (
rem StartRusTextBlock
set setfullinc=Полная
rem EndRusTextBlock
rem StartEngTextBlock
rem @set setfullinc=Full
rem EndEngTextBlock
) else (
rem StartRusTextBlock
set setfullinc=Инкрементная
rem EndRusTextBlock
rem StartEngTextBlock
rem @set setfullinc=Incremental
rem EndEngTextBlock
)
exit /b

:_ChoiceFunctions
call :_SetColours
call :_CompareTimeStampData
if %prebuild%==----------------- (
call :_CompareHeadPostbuild
) else (
call :_CompareHeadPrebuild
)
exit /b

:_CompareTimeStampData
for /f "tokens=2 delims=()" %%a in ('%myfiles%\adb shell dumpsys time_detector ^| findstr "mAutoSuggestionLowerBound"') do (
set num=%%a
set /a hstimestampdata=!num:~0,-3!
goto _tscompare
)

:_tscompare
if %hstimestampdata% GTR %fwtimestampdata% (
rem @echo Не прошьется
@echo  -----------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|       %_fBRed%+++ Timestamp прошивки старше, чем на шлеме +++%_fReset%         ^|
@echo  -----------------------------------------------------------------
@echo.
@echo   %_fBRed%Прошить не получится.
@echo.
@echo   %_fYellow%Timestamp %_fBYellow%это время создания прошивки. 
@echo   Шлем прошьется только если %_fYellow%timestamp %_fBYellow%файла прошивки новее, чем на шлеме.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|       %_fBRed%+++ The firmware timestamp is older than on the headset +++%_fReset%         ^|
rem @echo  -----------------------------------------------------------------
rem @echo.
rem @echo   %_fBRed%Firmware flashing is not possible.%_fReset%    
rem @echo.
rem @echo   %_fYellow%Timestamp %_fBYellow%is the firmware creation time. 
rem @echo   The headset will only be flashed if the %_fYellow%timestamp %_fBYellow%of the firmware is newer than on the headset.%_fReset%
rem EndEngTextBlock
goto _FlashMenuNo
) else (
rem echo Ok
)
rem pause
exit /b

:_CompareHeadPostbuild
set num1=%headbuild%
set num2=%postbuild%
set "tmp1=                 %num1%"
set "tmp2=                 %num2%"
set headpad="%tmp1:~-17%"
set postpad="%tmp2:~-17%"
if %postpad% == %headpad% (
rem set comparemark=actual
rem @echo actual >comparemark.txt
@echo.
@echo  --------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|       %_fBRed%+++ На шлеме и в файле одинаковые прошивки +++%_fReset%       ^|
@echo  --------------------------------------------------------------
@echo.
@echo   %_fBRed%Прошить не получится.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   %_fBRed%+++ The headset and file have the same firmware versions +++%_fReset%   ^|
rem @echo  -----------------------------------------------------------------
rem @echo.
rem @echo   %_fBRed%Firmware flashing is not possible.%_fReset%
rem EndEngTextBlock

goto _FlashMenuNo
) else (
if %headpad% gtr %postpad% (
rem set comparemark=newer
rem @echo newer >comparemark.txt
@echo.
@echo  ---------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|   %_fBRed%+++ На шлеме более новая прошивка, чем в файле +++%_fReset%   ^|
@echo  ---------------------------------------------------------------------
@echo.
@echo   %_fBRed%Прошить не получится.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   %_fBRed%+++ The headset has a newer firmware version than in the file +++%_fReset%   ^|
rem @echo  ---------------------------------------------------------------------
rem @echo.
rem @echo   %_fBRed%Firmware flashing is not possible.%_fReset%
rem EndEngTextBlock
goto _FlashMenuNo
) else (
rem set comparemark=older
rem @echo older >comparemark.txt
@echo.
rem StartRusTextBlock
@echo  --------------------------------------------------------------------
@echo  ^|     %_fBGreen%+++ В файле прошивки более новая версия, чем в шлеме +++%_fReset%     ^|
@echo  --------------------------------------------------------------------
@echo.
@echo   %_fBGreen%Можно прошивать.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ----------------------------------------------------------------------
rem @echo  ^|   %_fBGreen%+++ The file has a newer firmware version than the headset +++%_fReset%   ^|
rem @echo  ----------------------------------------------------------------------
rem @echo.
rem @echo   %_fBGreen%Firmware update is possible.%_fReset%
rem EndEngTextBlock
goto _FlashMenuYes
)
)
exit /b

:_CompareHeadPrebuild
set num1=%headbuild%
set num2=%prebuild%
set "tmp1=                 %num1%"
set "tmp2=                 %num2%"
set headpad="%tmp1:~-17%"
set prepad="%tmp2:~-17%"
if %headpad% == %prepad% (
@echo.
@echo  -----------------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|    %_fBGreen%+++ Версия базы инкремента совпадает с версией прошивки шлема +++%_fReset%     ^|
@echo  -----------------------------------------------------------------------------
@echo.
@echo   %_fBGreen%Можно прошивать.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   %_fBGreen%+++ Increment base version matches the headset firmware version +++%_fReset%   ^|
rem @echo  -----------------------------------------------------------------------------
rem @echo.
rem @echo   %_fBGreen%Firmware update is possible.%_fReset%
rem EndEngTextBlock
goto _FlashMenuYes
) else (
@echo.
@echo  --------------------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|     %_fBRed%+++ Версия базы инкремента не совпадает с версией прошивки шлема +++%_fReset%     ^|
@echo  --------------------------------------------------------------------------------
@echo.
@echo   %_fBRed%Прошить не получится.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   %_fBRed%+++ Increment base version does not match the headset firmware version +++%_fReset%   ^|
rem @echo  --------------------------------------------------------------------------------
rem @echo.
rem @echo   %_fBRed%Firmware flashing is not possible.%_fReset%
rem EndEngTextBlock
goto _FlashMenuNo
)

:_FlashMenuNo
@echo.
rem StartRusTextBlock
@echo   Но вы можете попробовать прошиться, на свой страх и риск.
@echo   Ничего критичного быть не должно, шлем просто не прошьется.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   But you can try to flash it at your own risk.
rem @echo   There shouldn't be anything critical, the headset just won't be flashed.
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для возврата в меню прошивки ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to return to the firmware menu ^<^<^<
rem EndEngTextBlock
@pause >nul
goto :_fwmenuskip
:_FlashMenuYes
@echo.
@echo.
@echo. %veryold1%
@echo. %veryold2%
@echo. %veryold3%
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для возврата в меню прошивки ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to return to the firmware menu ^<^<^<
rem EndEngTextBlock
@pause >nul
goto :_fwmenuskip
::exit

:_CompareVersion
::set fwver="37.0.0.137
rem echo %fwver:~1,2%]
rem if [%fwver:~1,2%] GTR [72] (
rem exit /b
rem ) else (
rem set veryold1=Прошивка слишком старая. 
rem set veryold2=В этом случае следует шить в таком порядке:
rem set veryold3=Сначала обновление до v.50, затем можно самую последнюю.
rem exit /b
rem )
exit /b

:_fwlinkdownload
rem @start " " "https://quest2vr.ru/прошивки-для-quest-2/"
@start " " "https://cocaine.trade/"
rem @start " " "https://app.koofr.net/links/9dcb7fff-03a5-4ad0-7b96-04258c02be15"
@echo.
@echo.
goto :_fwmenuskip
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для возврата в меню прошивки ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to return to the firmware menu ^<^<^<
rem EndEngTextBlock
@pause >nul

:_DopHelp
rem @chcp 65001 1>nul 2>nul
cls
rem StartRusTextBlock
@echo.
@echo.
@echo.
@echo.
@echo   ПОЯСНЕНИЕ ОБ ИНКРЕМЕНТНЫХ ПРОШИВКАХ
@echo.
@echo   Допустим, у нас прошивка в шлеме: 10.10, а шить мы собираемся такую: 20.10
@echo   И если она инкрементая, то есть - частичная, ее можно прошивать
@echo   только на определенную базовую версию в шлеме.
@echo   Для этого в файле прошивки дополнительно указывается номер версии прошивки шлема,
@echo   на которую можно прошивать. Эта версия и есть база инкремента, то есть фундамент.
@echo.
@echo   Например, у нас есть инкрементный файл прошивки с версией 20.10 она новее,
@echo   чем в шлеме (10.10), но при этом база у этого файла для версии 10.50.
@echo   И выходит, что версия файла прошивки хоть и выше шлемовой, но данный апдейт предназначен
@echo   ТОЛЬКО для шлемов с версией базы 10.50, а у нас шлем с базовой прошивкой 10.10
@echo.
@echo   Стало быть, прошить не получится.
@echo.
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.
rem @echo.
rem @echo   For example, we have firmware in the headset: 10.10
rem @echo.
rem @echo   And we are going to flash such firmware: 20.10
rem @echo.
rem @echo   And if it is incremental, i.e., partial, it can be flashed
rem @echo   only to a certain version in the headset.
rem @echo.
rem @echo   For this purpose, the firmware file additionally specifies the version
rem @echo   of the headset firmware that can be flashed.
rem @echo   This version is the increment base.
rem @echo.
rem @echo   For example, we have a firmware file with version 20.10
rem @echo   it is newer than the headset firmware (10.10).
rem @echo   but the increment base for the file is version 10.50.
rem @echo.
rem @echo   And it turns out that the firmware file version is higher than the headset firmware version,
rem @echo   but this update is ONLY intended for headsets with version 10.50,
rem @echo   and we have a headset with firmware version 10.10
rem @echo.
rem @echo   So, flashing won't work.
rem @echo.
rem @echo.
rem @echo.
rem EndEngTextBlock

:: @start cmd /c @%MYFILES%\adb shell
:: StartRusTextBlock
:: @start cmd /k "type dophelp.txt && @echo Для закрытия окна нажмите любую кнопку && @pause 1>nul && exit"
:: EndRusTextBlock
:: StartEngTextBlock
:: @start cmd /k "type dophelp.txt && @echo Press any key to close the window && @pause >nul && exit"
:: EndEngTextBlock
:: @ping localhost -n 2 2>nul 1>nul
:: @del dophelp.txt /f /q 2>nul 1>nul

call :_prevmenu
goto _fwmenu

:_ViewAndCompateDeviceName
set IntProductName=
@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.name') do set IntProductName=%%a
:: Использовать эту, если не подойдет предыдущая
::@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.device') do set IntProductName=%%a
@%myfiles%\7z.exe e %FirmwareFileName% metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"pre-device" metadata 2^>nul') do @set UpZipIntProductName=%%k
if [%UpZipIntProductName%]==[] set UpZipIntProductName=----------
@del metadata /q 1>nul 2>nul
call :_SetCompareDeviceModelName
call :_SetCompareUpZipModelName
call :_CompareUpZipAndProductName
exit /b

:_SetCompareDeviceModelName
if [%IntProductName%]==[] set IntProductName=---------- && set DeviceModelName=-------- && exit /b
if %IntProductName%==monterey set DevModelNm=Quest 1&&set fmfilename=Q1&&set fwtxt=fw1.txt&&  exit /b
if %IntProductName%==hollywood set DevModelNm=Quest 2&&set fmfilename=Q2&&set fwtxt=fw2.txt&& exit /b
if %IntProductName%==seacliff set DevModelNm=Quest Pro&&set fmfilename=QP&&set fwtxt=fwp.txt&& exit /b
if %IntProductName%==eureka set DevModelNm=Quest 3&&set fmfilename=Q3&&set fwtxt=fw3.txt&& exit /b
if %IntProductName%==panther set DevModelNm=Quest 3S&&set fmfilename=Q3S&&set fwtxt=fws.txt&& exit /b
if %IntProductName%==xse_panther set DevModelNm=Quest 3S Xbox&&set fmfilename=Q3S&&set fwtxt=fws.txt&& exit /b
rem StartRusTextBlock
set DeviceModelName=Неясно
rem EndRusTextBlock
rem StartEngTextBlock
rem set UpZipModelName=Unknown
rem EndEngTextBlock
set DevModelNm=------------
exit /b

:_SetCompareUpZipModelName
if %UpZipIntProductName%==monterey set UpzModelNm=Quest 1 &&set fmfilename=Q1&&set fwtxt=fw1.txt&& exit /b
if %UpZipIntProductName%==hollywood set UpzModelNm=Quest 2 &&set fmfilename=Q2&&set fwtxt=fw2.txt&& exit /b
if %UpZipIntProductName%==seacliff set UpzModelNm=Quest Pro &&set fmfilename=QP&&set fwtxt=fwp.txt&& exit /b
if %UpZipIntProductName%==eureka set UpzModelNm=Quest 3 &&set fmfilename=Q3&&set fwtxt=fw3.txt&& exit /b
if %UpZipIntProductName%==panther set UpzModelNm=Quest 3S &&set fmfilename=Q3S&&set fwtxt=fws.txt&& exit /b
if %UpZipIntProductName%==xse_panther set UpzModelNm=Quest 3S Xbox&&set fmfilename=Q3S&&set fwtxt=fws.txt&& exit /b
:: Здесь первый символ слова "Неясно" - латинская "H"
rem StartRusTextBlock
set UpZipModelName=Hеясно
rem EndRusTextBlock
rem StartEngTextBlock
rem set UpZipModelName=Unknown
rem EndEngTextBlock
set DevModelNm=------------
exit /b

:_CompareUpZipAndProductName
if %IntProductName% NEQ %UpZipIntProductName% (
rem StartRusTextBlock
set "IntPrdCompt=%_fBRed%Нет%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "IntPrdCompt=%_fBRed%No%_fReset%"
rem EndEngTextBlock
exit /b
) else (
rem StartRusTextBlock
set "IntPrdCompt=%_fBGreen%Да%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "IntPrdCompt=%_fBGreen%Yes%_fReset%"
rem EndEngTextBlock
exit /b
)
exit /b

:_SetFWtxtFileName
@%myfiles%\7z.exe e %FirmwareFileName% metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"pre-device" metadata 2^>nul') do @set UpZipIntProductName=%%k
if [%UpZipIntProductName%]==[] set UpZipIntProductName=----------
if %UpZipIntProductName%==monterey set DevModelNm=Quest 1&&set fmfilename=Q1&&set UpzModelNm=Quest 1&&set fwtxt=fw1.txt&& exit /b
if %UpZipIntProductName%==hollywood set DevModelNm=Quest 2&&set fmfilename=Q2&& set UpzModelNm=Quest 2&&set fwtxt=fw2.txt&& exit /b
if %UpZipIntProductName%==seacliff set DevModelNm=Quest Pro&&set fmfilename=QP&&set UpzModelNm=Quest Pro&&set fwtxt=fwp.txt&& exit /b
if %UpZipIntProductName%==eureka set DevModelNm=Quest 3&&set fmfilename=Q3&&set UpzModelNm=Quest 3&&set fwtxt=fw3.txt&& exit /b
if %UpZipIntProductName%==panther set DevModelNm=Quest 3S&&set fmfilename=Q3S&&set UpzModelNm=Quest 3S&&set fwtxt=fws.txt&& exit /b
if %UpZipIntProductName%==xse_panther set DevModelNm=Quest 3S Xbox&&set fmfilename=Q3S&&set UpzModelNm=Quest 3S Xbox&&set fwtxt=fws.txt&& exit /b
:: Здесь первый символ слова "Неясно" - латинская "H"
rem StartRusTextBlock
set UpZipModelName=Hеясно
rem EndRusTextBlock
rem StartEngTextBlock
rem set UpZipModelName=Unknown
rem EndEngTextBlock
exit /b


:_Uncompatible
@echo.
@echo  ---------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|        %_fBRed%+++ Файл прошивки от другой модели шлема +++%_fReset%         ^|
@echo  ---------------------------------------------------------------
@echo.
@echo   %_fBRed%Прошить не получится.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ---------------------------------------------------------------
rem @echo  ^|   %_fBRed%+++ Firmware file %FirmwareFileName% from another headset model +++%_fReset%   ^|
rem @echo  ---------------------------------------------------------------
rem @echo.
rem @echo   %_fBRed%Firmware flashing is not possible.%_fReset%
rem EndEngTextBlock

goto _FlashMenuYes

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_firmwareauto
@set "choice="
rem StartRusTextBlock
@Set /p choice="%_fBRed%Для подтверждения прошивки введите "%_fBYellow%ok%_fReset%%_fBRed%" без кавычек и нажмите Enter:%_fReset% (0 - exit, m - menu)"
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="For confirmation enter "ok" without quotas and press Enter: "
rem EndEngTextBlock
if not defined choice goto _firmwareauto
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="ok" (GOTO _firmwareautostart)
goto _firmwareauto

:_firmwareautostart
rem StartRusTextBlock
@echo  %_fBYellow%...Минутку, выполняется проверка условий прошивки...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBYellow%...One moment, checking the flash conditions...%_fReset%
rem EndEngTextBlock
call :_SetFirmwareFileName
call :_BatteryStatsCheck
rem set batlevel=49
if %batlevel% LEQ 50 (
rem StartRusTextBlock
set "colorbat=%_fBRed%%batlevel%%%   %_fRed%[Зарядите шлем перед прошивкой^^!]%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "colorbat=%_fBRed%%batlevel%%%   %_fRed%[Charge the headset before flashing^^!]%_fReset%"
rem EndEngTextBlock
) else (
set "colorbat=%_fBGreen%%batlevel%%%%_fReset%"
)
)


@FOR /F "tokens=1,2 delims==" %%a IN ('@%MYFILES%\adb shell dumpsys package com.oculus.systemux 2^>nul ^| findstr /i /c:"VersionName"') DO (
@FOR /F "tokens=1,2,3,4 delims=." %%a IN ("%%b") DO set "fwnewhsversion=%%a.%%b.%%c.%%d"
)
set "hsversion=!fwnewhsversion!"
rem echo %hsversion%
call :_SetFWtxtFileName
set ftpfile=%fwtxt%
rem echo %ftpfile%
call :_GetFTP
@timeout 1 >nul
call :_ExtractBuildVersionsNumbers
call :_fw
call :_cdc
call :_hat
@echo.
@%verbecho%
for /f "tokens=2 delims=()" %%a in ('%myfiles%\adb shell dumpsys time_detector ^| findstr "mAutoSuggestionLowerBound"') do (
set num=%%a
set /a hstimestampdata=!num:~0,-3!
)


if "!hstimestampdata!" GEQ "%fwtimestampdata%" (
set fwtscol=%_fBRed%
rem StartRusTextBlock
set "needanalyze= %_fRed%[Выберите пункт %_fBRed%T%_fRed% в меню]"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "needanalyze= [Select item %_fBRed%T%_fRed% in the menu]"
rem EndEngTextBlock
) else (
set fwtscol=%_fBGreen%
)

rem StartRusTextBlock
if "%model%" EQU "Неизвестно" (
rem EndRusTextBlock
rem StartEngTextBlock
rem if "%model%" EQU "Unknown" (
rem EndEngTextBlock
set model=---------
rem StartRusTextBlock
set "model1=%_fBRed%Подключено неизвестное устройство%_fReset%"
rem rem %_fBRed%%model%%_fReset%"
set "umodel2=%_fBRed%Продолжайте только если вы точно знаете, что делаете.%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "model1=%_fBRed%Unknown device connected%_fReset%"
rem rem %_fBRed%%model%%_fReset%"
rem set "umodel2=%_fBRed%Continue only if you are absolutely sure what you are doing.%_fReset%""
rem EndEngTextBlock
goto _CheckUpdateZip
) else (
rem StartRusTextBlock
set "model1=%_fCyan%Подключено устройство%_fReset%	: %_fBGreen%%model%%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "model1=%_fCyan%Device connected%_fReset%		 : %_fBGreen%%model%%_fReset%"
rem EndEngTextBlock
)
)
@del %ftpfile% /f /q 1>nul 2>nul

:_CheckUpdateZip
if exist %FirmwareFileName%.zip ren %FirmwareFileName%.zip %FirmwareFileName% 1>nul 2>nul
if not exist %FirmwareFileName% goto _NOTEXIST
@%MYFILES%\7z.exe l %FirmwareFileName% | findstr payload.bin >nul
@If %ERRORLEVEL% EQU 1 GOTO _FWWRONG
@echo.
@echo.
@echo.
rem @echo.
@echo       -----------------------------------------
rem StartRusTextBlock
@echo        %_fCyan%Заряд батареи%_fReset%		: %colorbat%
@echo        %model1%
@echo        %_fCyan%Версия прошивки шлема%_fReset%	: %_fBCyan%%hsversion%%_fReset%
@echo        %_fCyan%Версия файла прошивки%_fReset%	: %fwtscol%!fwpostn! %needanalyze%%_fReset%
@echo       -----------------------------------------
@echo.   %umodel2%
@echo.
@echo.
@@echo           %_fYellow%Меню автоматической прошивки%_fReset%
@echo.
@echo		0. Выход из программы
@echo		M. Выход в Главное меню
@echo.
@echo		A. Проверить актуальность прошивки шлема
@echo		F. Выход в меню прошивки
@echo		T. Проанализировать файл прошивки
@echo.
@echo	    %_fYellow%Enter. %_fBYellow%Начать прошивку%_fReset%
@echo.
@echo.
@echo   %_fBWhite%ВАЖНО: Путь к файлу с прошивкой не должен содержать пробелов и кириллицы%_fReset%
@echo.
@echo.
@echo -----------------------------------------------------
@echo    %_fBYellow%Нажмите %_fYellow%Enter %_fBYellow%для начала прошивки устройства
@echo    или выберите пункт меню и затем %_fYellow%Enter%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fCyan%Battery charge%_fReset%            : %colorbat%
rem @echo        %model1%
rem @echo        %_fCyan%Headset firmware version%_fReset%  : %_fBCyan%%hsversion%%_fReset%
rem @echo        %_fCyan%Firmware file version%_fReset%     : %fwtscol%!fwpostn! %needanalyze%%_fReset%
rem @echo       -----------------------------------------
rem @echo. %umodel2%
rem @echo.
rem @echo.
rem @echo		0. Exit the program
rem @echo		M. Exit to Main Menu
rem @echo.
rem @echo		A. Check the headset firmware for updates
rem @echo		F. Exit to Firmware Menu
rem @echo		T. Analyze the firmware file
rem @echo.
rem @echo	    %_fBYellow%Enter. Start device flashing%_fReset%
rem @echo.
rem @echo.
rem @echo.
rem @echo -----------------------------------------------------
rem @echo  Press Enter to start device flashing
rem @echo  or choose a menu item and then press Enter
rem EndEngTextBlock
:_fwmenu1
@%verbecho%
@set "choice="
@Set "choice=1"
@echo.
@Set /p choice=">> "
@echo.
if not defined choice goto _fwmenu1
if "%choice%"=="1" (GOTO _contfw1)
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="a" (GOTO _fwtxtcompare)
if /i "%choice%"=="f" (GOTO _fwmenuskip)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _CheckFirmwareUpdate)
goto _fwmenu1

:_contfw1
@echo.
@echo  ----------
rem StartRusTextBlock
@echo  %_fBYellow%= Загружаемся в бутлоадер..%_fReset%
@echo    [ светодиод загорится %_fBRed%оранжевым%_fReset% ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%= Booting into bootloader..
rem @echo    [LED will light up %_fBRed%orange%_fReset% ]
rem EndEngTextBlock
@echo.
@%MYFILES%\adb.exe reboot bootloader 1>NUL 2>&1
@ping localhost -n 12 >nul
@echo  ----------
rem StartRusTextBlock
@echo  %_fBYellow%= Переключаемся в режим загрузки прошивки..%_fReset%
@echo    [ светодиод загорится %_fBWhite%белым%_fReset%, затем %_fBMag%фиолетовым%_fReset% ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%= Switching to firmware loading mode..%_fReset%
rem @echo    [LED will light up %_fBWhite%white%_fReset%, then %_fBMag%purple%_fReset% ]
rem EndEngTextBlock
@echo.
@%MYFILES%\fastboot.exe oem reboot-sideload 1>NUL 2>&1
@ping localhost -n 14 >nul

:_FirmwareUpload
@echo  ----------
rem StartRusTextBlock
@echo  %_fBYellow%= Загружаем прошивку в шлем..%_fReset%
@echo    [ на %_fCyan%94^%%%_fReset% может на минуту замереть или завершить процесс загрузки, это нормально ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%= Loading firmware into the headset..
rem @echo    [ at 94^%% it may freeze for a minute or complete the loading process, this is normal ]
rem EndEngTextBlock
@echo.
rem IF [%FirmwareFileName%] NEQ [update.zip] set FirmwareFileName=update.zip
@echo %_fCyan% 
@%MYFILES%\adb.exe sideload update.zip
@If ERRORLEVEL==1 goto _loadfwerror
@echo %_fReset% 
@echo.
@echo.
rem StartRusTextBlock
rem @echo.
@echo  ---------------------------------------------------
@echo  ^|     %_fBGreen%+++  Загрузка прошивки завершена  +++%_fReset%       ^|
@echo  ---------------------------------------------------
@echo.
@echo  %_fBYellow%Обратите внимание на сообщение после загрузки:%_fReset% 
@echo.
@echo  ---------------------------------------------------
@echo   %_fCyan%Total xfer 1.00x%_fReset% - вы шьете ту же самую или более раннюю версию прошивки  
@echo   %_fCyan%Total xfer 2.00x%_fReset% - новая прошивка успешно загружена в шлем
@echo  ---------------------------------------------------
@echo.
@echo   %_fBYellow%Если вы шьете новую прошивку но видите%_fReset% %_fCyan%Total xfer 1.00x%_fReset%, %_fBYellow%то пробуйте шить соседние версии.
@echo   Например, у вас %_fYellow%v56%_fReset%, %_fBYellow%вы прошиваете%_fReset% %_fYellow%v67%_fReset%%_fBYellow%, но процесс срывается на%_fReset% %_fYellow%47^%%%_fReset% c %_fCyan%Total xfer 1.00x%_fReset%,
@echo   %_fBYellow%проуйте прошивать%_fReset% %_fYellow%v68%_fReset% %_fBYellow%или%_fReset% %_fYellow%v66%_fReset%. %_fBYellow%Такое иногда случается, в этом нет ничего страшного%_fReset%.
@echo.
@echo   %_fBYellow%Если вы видите сообщение %_fCyan%Total xfer 2.00x%_fReset%, %_fBYellow%но прошивка в шлеме остается той же самой версии,
@echo   действуйте аналогичным образом.%_fReset%
@echo  ---------------------------------------------------
@echo.
@echo  Вскоре устройство будет перезагружено.
@echo  Установка новой прошивки продолжится автоматически.
@echo.
@echo  Не трогайте шлем, пока боковой светодиод не станет %_fBYellow%желтым%_fReset% или %_fBGreen%зеленым%_fReset%. 
@echo  Загрузка в окружение может занять до десяти минут, будьте терпеливы.
@echo  Шлем подаст звуковой сигнал, когда загрузится в Виртуальное окружение.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|     %_fBGreen%+++  Firmware loading complete  +++       ^|
rem @echo  ---------------------------------------------------
rem @echo.
rem @echo  Pay attention to the message after loading:
rem @echo   Total xfer 1.00x - you are flashing the same or earlier firmware version
rem @echo   Total xfer 2.00x - new firmware successfully loaded into the headset
rem @echo.
rem @echo  The device will be rebooted shortly.
rem @echo  Installing the new firmware will continue automatically.
rem @echo.
rem @echo  Do not touch the headset until the side LED turns yellow or green.
rem @echo  Loading into the environment may take up to ten minutes, please be patient.
rem @echo  The headset will emit a sound when it boots into the Virtual Environment.
rem EndEngTextBlock
@ping localhost -n 5 >nul
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
@echo -----------------------------------------------------
goto _returnmenu

:_CheckFWfileExist
if not exist %cd%\update.zip goto _NOTEXIST
exit /b

:_firmwarebutton
endlocal
call :_SetFirmwareFileName
@%verbecho%
@cls
call :_hat
@echo.
@echo.
if exist %FirmwareFileName%.zip ren %FirmwareFileName%.zip %FirmwareFileName%
if not exist %FirmwareFileName% goto _NOTEXIST
@%MYFILES%\7z.exe l %FirmwareFileName% | findstr payload.bin >nul
@If %ERRORLEVEL% EQU 1 GOTO _FWWRONG
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fBGreen%+++++  Файл прошивки найден  +++++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++  Firmware file found  +++++
rem EndEngTextBlock
@echo.
@echo.
@echo.
@%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==1 goto _nobootloader
@echo.
rem StartRusTextBlock
rem ::@@echo    Для получения информации о файле %FirmwareFileName%  
rem ::@@echo    выйдите в основное меню и выберите пункт F.
rem @echo -----------------------------------------------------
rem @echo.
rem @echo.
@echo		0. Выход из программы 
@echo		M. Выход в Главное меню 
@echo		F. Выход в меню прошивки
@echo		T. Проанализировать файл прошивки
@echo.
@echo	    %_fBYellow%Enter. Начать прошивку%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo		0. Exit the program
rem @echo		M. Exit to Main Menu
rem @echo		F. Exit to Firmware Menu
rem @echo		T. Analyze firmware file
rem @echo.
rem @echo	    Enter. Start flashing
rem EndEngTextBlock

:_fwmenu2
@%verbecho%
@set "choice="
@Set "choice=1"
@echo.
@Set /p choice=">> "
@echo.
if not defined choice goto _fwmenu2
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="f" (GOTO _fwmenuskip)
if /i "%choice%"=="m" (GOTO _beginn)
if "%choice%"=="1" (GOTO _contfw2)
if /i "%choice%"=="t" (GOTO _CheckFirmwareUpdate)
goto _fwmenu2

:_contfw2
@echo.
@echo  ----------
rem StartRusTextBlock
@echo  %_fBYellow%= Переключаемся в режим загрузки прошивки..%_fReset%
@echo    [ светодиод загорится %_fBWhite%белым%_fReset%, затем %_fBMag%фиолетовым%_fReset% ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Switching to firmware loading mode..
rem @echo    [LED will light up white, then purple]
rem EndEngTextBlock
::@@echo.
@%MYFILES%\fastboot.exe oem reboot-sideload 1>NUL 2>&1
@@ping localhost -n 14 >nul
@echo.
@echo  ----------
rem StartRusTextBlock
@echo  %_fBYellow%= Загружаем прошивку в шлем..%_fReset%
@echo    [ на %_fCyan%94^%%%_fReset% может на минуту замереть или завершить процесс загрузки, это нормально ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Loading firmware into the headset..
rem @echo    [ at 94^%% it may freeze for a minute or complete the loading process, this is normal ]
rem EndEngTextBlock
@echo.
@%MYFILES%\adb.exe sideload %FirmwareFileName%
@If %ERRORLEVEL%==1 goto _loadfwerror
@echo.
rem StartRusTextBlock
@echo  ---------------------------------------------------
@echo  ^|     %_fBGreen%+++  Загрузка прошивки завершена  +++%_fReset%       ^|
@echo  ---------------------------------------------------
@echo.
@echo  %_fBYellow%Обратите внимание на сообщение после загрузки:%_fReset% 
@echo.
@echo  ---------------------------------------------------
@echo   %_fCyan%Total xfer 1.00x%_fReset% - вы шьете ту же самую или более раннюю версию прошивки  
@echo   %_fCyan%Total xfer 2.00x%_fReset% - новая прошивка успешно загружена в шлем
@echo  ---------------------------------------------------
@echo.
@echo   %_fBYellow%Если вы шьете новую прошивку но видите%_fReset% %_fCyan%Total xfer 1.00x%_fReset%, %_fBYellow%то пробуйте шить соседние версии.
@echo   Например, у вас %_fYellow%v56%_fReset%, %_fBYellow%вы прошиваете%_fReset% %_fYellow%v67%_fReset%%_fBYellow%, но процесс срывается на%_fReset% %_fYellow%47^%%%_fReset% c %_fCyan%Total xfer 1.00x%_fReset%,
@echo   %_fBYellow%проуйте прошивать%_fReset% %_fYellow%v68%_fReset% %_fBYellow%или%_fReset% %_fYellow%v66%_fReset%. %_fBYellow%Такое иногда случается, в этом нет ничего страшного%_fReset%.
@echo.
@echo   %_fBYellow%Если вы видите сообщение %_fCyan%Total xfer 2.00x%_fReset%, %_fBYellow%но прошивка в шлеме остается той же самой версии,
@echo   действуйте аналогичным образом.%_fReset%
@echo  ---------------------------------------------------
@echo.
@echo  Вскоре устройство будет перезагружено.
@echo  Установка новой прошивки продолжится автоматически.
@echo.
@echo  Не трогайте шлем, пока боковой светодиод не станет %_fBYellow%желтым%_fReset% или %_fBGreen%зеленым%_fReset%. 
@echo  Загрузка в окружение может занять 10-15  минут, будьте терпеливы.
@echo  Шлем подаст звуковой сигнал, когда загрузится в Виртуальное окружение.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|     +++  Firmware loading complete  +++       ^|
rem @echo  ---------------------------------------------------
rem @echo.
rem @echo  Pay attention to the message after loading:
rem @echo   Total xfer 1.00x - you are flashing the same or earlier firmware version
rem @echo   Total xfer 2.00x - new firmware successfully loaded into the headset
rem @echo.
rem @echo  The device will be rebooted shortly.
rem @echo  Installing the new firmware will continue automatically.
rem @echo.
rem @echo  Do not touch the headset until the side LED turns yellow or green.
rem @echo  Loading into the environment may take up to ten minutes, please be patient.
rem @echo  The headset will emit a sound when it boots into the Virtual Environment.
rem EndEngTextBlock
@ping localhost -n 5 >nul
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
goto _returnmenu

:_nobootloader
@%verbecho%
@cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     +++ Шлем НЕ в режиме Bootloader! +++
@echo.
@echo.
@echo.
@echo   Для того, чтобы загрузить ся в Bootloader,
@echo   одновременно удерживайте кнопки Питание
@echo   и Громкость-минус (ближняя к носу)
@echo   до появления бело-синего меню.
@echo --------------------------------------------
@echo.
@echo   Затем перезапустите эту программу.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++ Headset NOT in Bootloader mode! +++
rem @echo.
rem @echo.
rem @echo.
rem @echo   To enter Bootloader mode,
rem @echo   hold down the Power and Volume Down buttons
rem @echo   simultaneously (the one closest to the nose)
rem @echo   until the white-blue menu appears.
rem @echo --------------------------------------------
rem @echo.
rem @echo   Then restart this program.
rem @echo.
rem @echo.
rem EndEngTextBlock
@echo.
@echo.
goto _returnmenu

:_bootloadermode
@%verbecho%
@cls
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fBlack%%_bDGray%+++ Шлем в режиме Bootloader! +++%_fReset%
@echo.
@echo.
@echo.
@echo  или в Fasboot - зависит цвета диода и от того, что на дисплее:
@echo.
@echo  Если на экране шлема желто-синее меню, светодиод фиолетовый и надпись FASTBOOTD - 
@echo      = вы в режиме +++ Fastboot +++
@echo.
@echo  Если на экране бело-синее меню, светодиод оранжевый и надпись USB Update Mode - 
@echo     = вы в режиме +++ Bootloader +++ 
@echo --------------------------------------------
@echo.
@echo.
@echo      0. Выход из программы 
@echo      M. Выход в Главное меню
@echo      R. Перезагрузка шлема
@echo      F. Выход в общее прошивочное меню прошивки
@echo      K. Информация о прошивке шлема, слотах загрузки, ревизии и батарее
@echo      S. Отключить сенсоры шлема (Only Meta Quest 3)
@echo      Q. Включить сенсоры шлема (Only Meta Quest 3)
@echo.
@echo  %_fBYellow%Enter. Перейти непосредственно к меню прошивки (Кнопочный режим)%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++ Headset in Bootloader mode! +++
rem @echo.
rem @echo.
rem @echo.
rem @echo  Or in Fastboot - it depends on the LED color and what's on the display:
rem @echo.
rem @echo  If the headset displays a yellow-blue menu, the LED is purple, and the text says FASTBOOTD - 
rem @echo      = you're in +++ Fastboot mode +++
rem @echo.
rem @echo  If the headset displays a white-blue menu, the LED is orange, and the text says USB Update Mode - 
rem @echo     = you're in +++ Bootloader mode +++
rem @echo --------------------------------------------
rem @echo.
rem @echo.
rem @echo      0. Exit the program 
rem @echo      M. Exit to Main Menu 
rem @echo      R. Reboot
rem @echo      F. Exit to Firmware Menu
rem @echo      K. Headset Firmware and Boot Slot Information
rem @echo      S. Disable headset sensors (Only Meta Quest 3)
rem @echo      Q. Enable headset sensors (Only Meta Quest 3)
rem @echo.
rem @echo  Enter. Switch to button flashing mode
rem EndEngTextBlock
@echo.
@echo.
@echo.
@set "choice="
@Set "choice=1"
rem StartRusTextBlock
@Set /p choice="Выберите пункт меню или нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Select a menu number and press Enter: "
rem EndEngTextBlock
@echo.
if not defined choice goto _bootloadermode
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="1" (GOTO _firmwarebutton)
if /i "%choice%"=="f" (GOTO _fwmenuskip)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="r" (GOTO _RebootFromBootLoader)
if /i "%choice%"=="k" (set "fastbotcommand=:_FastbootFirmwareExtractCont"&&call :_FastbootCheckDevice)
if /i "%choice%"=="s" (set "fastbotcommand=:_DisableHeadsetSensorsConfirm"&&call :_FastbootCheckDevice)
if /i "%choice%"=="q" (set "fastbotcommand=:_EnableHeadsetSensors"&&call :_FastbootCheckDevice)
if /i "%choice%"=="t" (goto _HeadsetSensorsCompatCheck)
goto _bootloadermode

:_RebootFromBootLoader
@%myfiles%\fastboot reboot  1>nul 2>nul& call :_rebootmessage & goto  _returnmenu


:_FastbootCheckDevice
cls
call :_hat
echo off
setlocal enabledelayedexpansion
@echo.
@echo.
@echo off
for /f "tokens=1" %%i in ('%MYFILES%\fastboot devices ^| findstr /i /c:"fastboot"') do (
set serial=%%i
rem StartRusTextBlock
@echo   %_fBYellow%Найдено устройство:	%_fReset% %_fBCyan%!serial!%_fReset%
for /f %%a in ('powershell -ExecutionPolicy Bypass -File "%myfiles%\pcode.ps1" -serial "!SERIAL!"') do set pairingcode=%%a
@echo   %_fBYellow%Код сопряжения:	%_fReset% %_fBCyan%!pairingcode!%_fReset%
@call %fastbotcommand%
exit /b
)
@echo ===============================================
@echo %_fBRed%+++ Шлем не отвечает на команды fastboot +++%_fReset%
@echo Загрузите его в bootloader, fastboot или recovery режимы.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Device found: %_fReset% %_fBCyan%%serial%%_fReset%
rem for /f %%a in ('powershell -ExecutionPolicy Bypass -File "%myfiles%\pcode.ps1" -serial "%SERIAL%"') do set pairingcode=%%a
rem @echo   %_fBYellow%Pairing code:%_fReset% %_fBCyan%%pairingcode%%_fReset%
rem call %fastbotcommand%
rem @exit /b
rem )
rem @echo ===============================================
rem @echo %_fBRed%+++ Headset is not responding to fastboot commands +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
exit /b 
rem goto _returnmenu

:_HeadsetSensorsCompatCheck
setlocal enabledelayedexpansion
call :_ViewCodenameBL
if not !codename:~1!==eurekaa (
echo NOk
pause
goto _bootloadermode
) else (
echo Ok
pause
goto _bootloadermode
)
goto _bootloadermode

:_ViewCodenameBL
@for /f "tokens=1,2,3 delims=:" %%a in ('@%MYFILES%\fastboot getvar product 2^>^&1') do (
set "codename=%%b"
@echo !codename:~1!
exit /b
)
exit /b


:_DisableHeadsetSensorsConfirm
@echo.
@echo.
rem StartRusTextBlock
@echo      %_fBRed%ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo          %_fBRed%Сенсоры после перезагрузки шлема не включаются автоматически^!%_fReset%
@echo.
@echo          %_fBYellow%После отключения сенсоров шлем всякий раз перез загрузкой в окружение
@echo          будет просить вас нажать кнопку %_fYellow%Питание %_fBYellow%для включения сенсоров.
@echo          Для того чтобы они снова были активны по умолчанию, воспользуйтесь
@echo          опцией %_fYellow%Q - Включить сенсоры шлема.%_fReset%
@echo.
@echo.
@Set /p choice="Подтвердите отключение нажатием Enter или введите 0 и Enter для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBRed%ATTENTION:
rem @echo.
rem @echo          %_fBRed%Sensors do not turn on automatically after rebooting the headset^!%_fReset%
rem @echo.
rem @echo          %_fBYellow%After disabling the sensors, each time you reboot into the environment,
rem @echo          the headset will ask you to press the %_fYellow%Power %_fBYellow%button to enable the sensors.
rem @echo          To make them active by default again, use the
rem @echo          option %_fYellow%Q - Enable headset sensors.%_fReset%
rem @echo.
rem @echo.
rem @Set /p choice="Confirm disabling by pressing Enter, or enter 0 and press Enter to return to the menu: "
rem EndEngTextBlock
if not defined choice call :_DisableHeadsetSensors
if /i "%choice%"=="0" (exit /b)


:_DisableHeadsetSensors
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Отключение сенсоров..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Disabling sensors..%_fReset%
rem EndEngTextBlock
%MYFILES%\fastboot reboot-bootloader 1>nul 2>nul
timeout 5 >nul
rem pause
%MYFILES%\fastboot oem set-sensorlock 1 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBYellow%= Сенсоры отключены%_fReset%
@echo     Теперь попробуйте загрузить шлем, выбрав пункт R.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Sensors disabled
rem @echo     Try to reboot the headset with R option
rem EndEngTextBlock
call :_prevmenu
exit /b
)
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBRed%= Сенсоры отключить не удалось.%_fReset%
@echo     Возможно шлем не поддерживает эту команду
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%= Failed to disable sensors.%_fReset%
rem @echo     The headset may not support this command
rem EndEngTextBlock
call :_prevmenu
exit /b


:_EnableHeadsetSensors
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Включение сенсоров..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Enabling sensors..%_fReset%
rem EndEngTextBlock
%MYFILES%\fastboot reboot-bootloader 1>nul 2>nul
timeout 5 >nul
rem pause
%MYFILES%\fastboot oem set-sensorlock 0 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBYellow%= Сенсоры включены%_fReset%
@echo     Теперь попробуйте загрузить шлем, выбрав пункт R.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Sensors enabled
rem @echo     Try to reboot the headset with R option
rem EndEngTextBlock
call :_prevmenu
exit /b
)
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBRed%= Сенсоры включить не удалось.%_fReset%
@echo     Возможно шлем не поддерживает эту команду
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%= Failed to enable sensors.%_fReset%
rem @echo     The headset may not support this command
rem EndEngTextBlock
call :_prevmenu
exit /b


:_FastbootFirmwareExtractCont
%MYFILES%\fastboot reboot-bootloader 1>nul 2>nul
@timeout 2 >nul
@echo.
@echo   -----------------------------------------------
for /f "tokens=2" %%i in ('%MYFILES%\fastboot oem battery-capacity 2^>^&1 ^| findstr /i "(bootloader)"') do set battlevel=%%i
rem StartRusTextBlock
@echo   %_fBYellow%= Уровень батареи: %_fReset%%_fBCyan%%battlevel%%%%_fReset% (данные не всегда верны)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Battery level:%_fReset%%_fBCyan%%battlevel%%%%_fReset% (data can be wrong)
rem EndEngTextBlock
%MYFILES%\fastboot oem battery-capacity 2>nul
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Извлекаем информацию о слотах и ревизии.%_fReset%
@echo     Немного терпения, это займет некоторое время..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Extracting information about the slots.%_fReset%
rem @echo     Please be patient, this will take some time..
rem EndEngTextBlock
@echo   -----------------------------------------------
for /f "tokens=*" %%A in ('%MYFILES%\fastboot getvar all 2^>^&1') do (
    echo %%A | findstr /i "slot- has-slot:boot current-slot model-revision" >nul
    if not errorlevel 1 (
        set "fp=%%A"
@echo     %_fBCyan%!fp:~12!%_fReset%

    )
)
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Переключаемся в режим fastboot%_fReset%
@echo     Придется подождать еще несколько секунд..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Switching to fastboot mode%_fReset%
rem EndEngTextBlock

%MYFILES%\fastboot reboot-fastboot 1>nul 2>nul
@timeout 3 >nul
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Извлекаем информацию о прошивке..%_fReset%
@echo     Еще немного терпения, осталоь совсем чуть-чуть..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Retrieving firmware information...%_fReset%
rem @echo     Just a second..
rem EndEngTextBlock
for /f "tokens=*" %%A in ('%MYFILES%\fastboot getvar all 2^>^&1') do (
    echo %%A | findstr /i "vendor-fingerprint" >nul
    if not errorlevel 1 (
        set "fp=%%A"
    )
)


set "fp=!fp:*vendor-fingerprint:=!"

for /f "tokens=2,6 delims=/:" %%B in ("!fp!") do (
    set "device=%%B"
    set "number=%%C"
)
call :_FastbootFirmwareTable
@del /q /f %ftpfile% 1>nul 2>nul
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo     %_fBYellow%Модель шлема%_fReset%		: %_fBCyan%Meta %DevModelNm%%_fReset%
@echo     %_fBYellow%Версия среды шлема%_fReset%		: %_fBCyan%!fbenv!%_fReset%
@echo     %_fBYellow%Версия прошивки шлема%_fReset%	: %_fBCyan%!fbfwr!%_fReset%
@echo   -----------------------------------------------
@echo   %_fBYellow%= Возвращаемся в bootloader..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Headset Model%_fReset%          	: %_fBCyan%Meta %DevModelNm%%_fReset%
rem @echo   %_fBYellow%Headset Environment Ver%_fReset%	: %_fBCyan%!fbenv!%_fReset%
rem @echo   %_fBYellow%Headset Firmware Ver%_fReset%   	: %_fBCyan%!fbfwr!%_fReset%
rem @echo   -----------------------------------------------
rem @echo   %_fBYellow%= Return to bootloader mode
rem EndEngTextBlock
%MYFILES%\fastboot reboot-bootloader 1>nul 2>nul
@echo   -----------------------------------------------
rem StartRusTextBlock
@echo     %_fBGreen%Извлечение завершено.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBGreen%Extracting complete.%_fReset%
rem EndEngTextBlock
rem @echo   -----------------------------------------------
call :_prevmenu
exit /b
rem goto _returnmenu
rem goto _beginn


:_FastbootFirmwareTable
set IntProductName=!device!
set fastbootmark=1
call :_SetCompareDeviceModelName
set ftpfile=%fwtxt%
rem StartRusTextBlock
set "fbfwr=Данные отсутствуют или недоступны"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "fbfwr=Data not available"
rem EndEngTextBlock
set "fbenv="
call :_GetFTP
if not exist %ftpfile% set fbenv=%number%&& exit /b
@for /F "tokens=1,2 delims= " %%a in (%ftpfile%) do (
    @echo %%a | findstr /i "%number%" >nul
    if not errorlevel 1 (
        set "fbenv=%%a"
        set "fbfwr=%%b"
        exit /b
    )
)
set fbenv=%number%
@del /q /f %ftpfile% 1>nul 2>nul
exit /b


:_NOTEXIST
@%verbecho%
@cls
call :_hatqut
@echo.
@echo.
@echo.
@echo           ======================================
rem StartRusTextBlock
@echo          %_fBRed%++++ Файл прошивки НЕ найден ++++%_fReset%
@echo           ======================================
@echo.
@echo.
@echo.
@echo   1. Поместите файл прошивки (архив zip) рядом с этой программой.
@echo   2. Перезапустите программу.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBRed%+++ Firmware file NOT found ++++%_fReset%
rem @echo           ======================================
rem @echo.
rem @echo.
rem @echo.
rem @echo   1. Place the firmware file (zip archive) next to this program.
rem @echo   2. Restart the program.
rem EndEngTextBlock
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
goto _returnmenu

:_FWWRONG
@%verbecho%
@cls
call :_hatqut
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo    %_fBRed%++++ Файл прошивки не корректен ++++%_fReset%
@echo.
@echo.
@echo.
@echo  Проверьте содержимое архива %FirmwareFileName%
@echo  Он должен иметь такую структуру:
@echo.
@echo     META-INF
@echo     apex_info.pb
@echo     care_map.pb
@echo     payload.bin
@echo     payload_properties.txt
@echo.
@echo  Как только убедитесь в правильности архива, перезапустите программу.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    ++++ Firmware file is not valid ++++
rem @echo.
rem @echo.
rem @echo.
rem @echo  Check the contents of the %FirmwareFileName% archive
rem @echo  It should have the following structure:
rem @echo.
rem @echo   META-INF
rem @echo	apex_info.pb
rem @echo   care_map.pb
rem @echo   payload.bin
rem @echo   payload_properties.txt
rem @echo.
rem @echo  Once you've confirmed the correctness of the archive, restart the program.
rem EndEngTextBlock
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
goto _returnmenu

:_fversion
@echo.
@echo.
@%MYFILES%\fastboot devices | findstr /i /c:"fastboot" 1>nul 2>nul
If %ERRORLEVEL%==0 goto _blmessage
rem call :_tabModel
call :_setfwtxt
If %IntProductName%==---------- goto _Unknown

rem @echo Секунду, выдергиваем циферки...
@echo  Just a moment, extracting numbers...
@For /F %%a In ('@%MYFILES%\adb shell getprop ro.build.version.incremental') Do set hsenvironment=%%a
call :_hsfwversionextract
call :_setfwtxt
@echo ----------------------------------------------
rem StartRusTextBlock
@echo Модель шлема		: Meta %DevModelNm%
@echo Версия среды		: %hsenvironment%
@echo Версия прошивки		: %hsversion%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Headset model       : Meta %DevModelNm%
rem @echo Environment version: %hsenvironment%
rem @echo Firmware version   : %hsversion%
rem EndEngTextBlock
@echo ----------------------------------------------
goto _returnmenu

:_Unknown
@echo.
@echo.
rem StartRusTextBlock
@echo   +++ Шлем не подключен или модель не определена +++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   +++ Headset is not connected or the model is not recognized +++
rem EndEngTextBlock
@echo.
@echo.
GOTO _returnmenu

:_fwtxtcompare
@%verbecho%
cls
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo Секунду, выдергиваем циферки...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Just a moment, extracting numbers...
rem EndEngTextBlock
For /F %%a In ('@%MYFILES%\adb shell getprop ro.build.version.incremental') Do set hsenvironment=%%a
call :_hsfwversionextract
call :_setfwtxt


rem StartRusTextBlock
@echo.
@echo.
@echo   -------------------------------------------------------------------
@echo     %_fCyan%Модель шлема%_fReset%				: %_fBCyan%%DevModelNm%%_fReset%
@echo   -------------------------------------------------------------------
@echo     %_fCyan%Версия среды окружения шлема%_fReset%		: %_fBCyan%%hsenvironment%%_fReset%
@echo     %_fCyan%Версия прошивки шлема%_fReset%			: %_fBCyan%%hsversion%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fCyan%Headset model%_fReset%			: %_fBCyan%%DevModelNm%%_fReset%
rem @echo   -------------------------------------------------------------------
rem @echo    %_fCyan%Headset environment version%_fReset%		: %_fBCyan%%hsenvironment%%_fReset%
rem @echo    %_fCyan%Headset firmware version%_fReset%		: %_fBCyan%%hsversion%%_fReset%
rem EndEngTextBlock
@echo   -------------------------------------------------------------------
rem call :_SetFWtxtFileName
set ftpfile=%fwtxt%
call :_GetFTP
if errorlevel==1 goto _errordownloadfwtxt
set /p firstline=<%fwtxt%
for /f "tokens=1,2 delims= " %%a in ("%firstline%") do (
    set "lstxtenvironment=%%a"
    set "lstxtversion=%%b"
)
set num1=%hsenvironment%
set num2=%lstxtenvironment%
set "tmp1=                 %num1%"
set "tmp2=                 %num2%"
set hsnumb="%tmp1:~-17%"
set lsnumb="%tmp2:~-17%"

rem set "model=Quest 3"
rem Проверка на обновление версии
rem set hsversion=81
rem set hsnumb="51312300157900520"
rem echo ls %lsnumb%
rem echo hs %hsnumb%
rem pause

rem StartRusTextBlock
@echo    %_fCyan%Версия среды из базы данных%_fReset%			: %_fBCyan%%lsnumb:~1,-1%%_fReset%
@echo    %_fCyan%Версия прошивки из базы данных%_fReset%		: %_fBCyan%%lstxtversion%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fCyan%Environment version from database%_fReset%	: %_fBCyan%%lsnumb:~1,-1%%_fReset%
rem @echo    %_fCyan%Firmware version from database%_fReset%	: %_fBCyan%%lstxtversion%%_fReset%
rem EndEngTextBlock
@echo   -------------------------------------------------------------------
if [%hsversion:~0,2%] LSS [71] (
@echo.
@echo.
rem StartRusTextBlock
@echo                %_fRed%=================
@echo                ОБРАТИТЕ ВНИМАНИЕ
@echo                =================%_fReset%
@echo.
@echo   %_fBYellow%У вашего шлема старая версия прошивки и поэтому не рекомендуется
@echo   прошивать его самой последней версией, иначе есть риск окирпичивания.
@echo.
@echo   Следует прежде всего прошить его версией %_fBCyan%v71%_fBYellow%.
@echo   Чтобы скачать эту версию, нажмите %_fYellow%Enter%_fBYellow%. Для отмены и возврата в меню - %_fYellow%Esc%_fReset%
@echo   %_fBYellow%Для скачивания самой новой версии %_fBCyan%%lstxtversion%%_fReset% %_fBYellow%нажмите %_fYellow%Пробел%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo                %_fRed%=================
rem @echo                PLEASE NOTE
rem @echo                =================%_fReset%
rem @echo.
rem @echo   %_fBYellow%Your headset has an old firmware version, therefore it is not recommended
rem @echo   to flash it with the very latest version, as there is a risk of bricking the device.
rem @echo.
rem @echo   You should first flash it with version %_fBCyan%v71%_fBYellow%.
rem @echo   To download this version, press %_fYellow%Enter%_fBYellow%. To cancel and return to the menu — %_fYellow%Esc
rem @echo   %_fBYellow%To download the latest version %_fBCyan%%lstxtversion%%_fReset% %_fBYellow%press %_fYellow%Space%_fReset%
rem EndEngTextBlock
@echo.
@echo   %_fCyan%^>^>^>%_fReset%
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto _fwmenuskip
if "!KEY!"=="32" goto _NewFirmwareDownload
if "!KEY!"=="13" (
if "!model!"=="Quest 2" set lsnumb="51203760112800150"&&set lstxtversion=71.0.0.578
if "!model!"=="Quest Pro" set lsnumb="50498930087600330"&&set lstxtversion=71.0.0.578
if "!model!"=="Quest 3" set lsnumb="50352750108500510"&&set lstxtversion=71.0.0.579
if "!model!"=="Quest 3S" set lsnumb="393100085900610"&&set lstxtversion=71.0.0.608
goto _NewFirmwareDownload
)
goto _fwmenuskip
)

@if %hsnumb% GTR %lsnumb% (
@echo.
rem StartRusTextBlock
@echo     %_fBGreen%+++ Версия прошивки шлема актуальна +++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBGreen%+++ The firmware version in the headset is up to date +++%_fReset%
rem EndEngTextBlock

rem @echo +++  Прошивка в шлеме новее, чем в базе данных  +++
rem @echo.
rem rem @echo = Дополняем локальную базу данных версий прошивок
rem @echo +++ Firmware in the headset is newer than in the table +++
rem rem @echo.
rem rem rem @echo = Updating the firmware version mapping table

rem @echo %hsenvironment% %hsversion% >>%fwtxt%
rem call :_SetCompareDeviceModelName
rem call :_SetFWtxtFileName
rem set ftpfile=%fwtxt%
rem call :_PutFTP
rem del ls.txt /q /f
@echo.
goto _returnmenu
rem ) else (
)

@if %hsnumb% == %lsnumb% (
@echo.
rem StartRusTextBlock
@echo     %_fBGreen%+++ Версия прошивки шлема актуальна +++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBGreen%+++ The firmware version in the headset is up to date +++%_fReset%
rem EndEngTextBlock
@del %fwtxt% /q /f 1>nul 2>nul
@del ls.txt /q /f 1>nul 2>nul
@echo.
goto _returnmenu
rem ) else (
)

@if %lsnumb% GTR %hsnumb% (
@del %fwtxt% /q /f 1>nul 2>nul
@echo.
rem Сделать условие определения lsnumb в зависимости от модели шлема
rem 2 51203760112800150	71.0.0.578
rem P 50498930087600330	71.0.0.578
rem 3 50352750108500510	71.0.0.579
rem 3S 393100085900610	71.0.0.608

rem 035275010850051

rem StartRusTextBlock
@echo             %_fBCyan%===================================================
@echo             +++ Доступна свежая версия прошивки: %_fBGreen%!lstxtversion!%_fReset% %_fBCyan% +++
@echo             ===================================================%_fReset%
@echo.
@echo   %_fBYellow%Для скачивания последней версии нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo             %_fBCyan%==================================================
rem @echo     %_fBYellow%+++ New firmware version available:  %_fCyan%!lstxtversion!%_fReset% %_fBCyan% +++
rem @echo             ==================================================%_fReset%
rem @echo.
rem @echo   To download the last version press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto _fwmenuskip
if "!KEY!"=="13" goto _NewFirmwareDownload
goto _fwmenuskip
)


:_NewFirmwareDownload
set ms=!model:~6!
set envnumb=!lsnumb:~1,-1!
rem set modelnumb=!model:~0,-1!
set "curllink=https://files.cocaine.trade/firmware/meta/Quest%%20!ms!/q!ms!_!envnumb!.zip"
set app=q!ms!_!envnumb!.zip
@echo   -------------------------------------------------------------------
rem StartRusTextBlock
@echo  = Скачивание версии %_fBGreen%!lstxtversion!%_fReset%...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Downloading version %_fBCyan%!lstxtversion!%_fReset%...
rem EndEngTextBlock
@curl -4 -LJko !app! --resolve files.cocaine.trade:443:45.150.123.10 !curllink! -#
@echo off
rem Получаем размер файла в байтах
for %%F in ("!app!") do set size=%%~zF
rem Проверяем, меньше ли размер 1024 байт
if %size% LSS 1024 (
rem StartRusTextBlock
@echo   %_fBRed%Скачивание не удалось. Причину смотрите в файле %_fRed%ErrorFWDownload.txt%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Download failed. Check the reason in the file %_fRed%ErrorFWDownload.txt%_fReset%
rem EndEngTextBlock
@ren !app! ErrorFWDownload.txt 1>nul 2>nul
call :_prevmenu
goto _fwmenuskip
)
@echo  --- 
ren q!ms!_!envnumb!.zip q!ms!-!lstxtversion!.zip 1>nul 2>nul
rem StartRusTextBlock
@echo  %_fBGreen%= Готово%_fReset%
@echo    %_fBYellow%Файл прошивки должен лежать рядом с программой и называться %_fYellow%q!ms!-!lstxtversion!.zip%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBGreen%= Done%_fReset%
rem @echo    %_fBYellow%The firmware file must be located next to the program and named %_fYellow%q!ms!-!lstxtversion!.zip%_fReset%
rem EndEngTextBlock
@del %fwtxt% /q /f 1>nul 2>nul
@del ls.txt /q /f 1>nul 2>nul
set FirmwareFileName=q!ms!-!lstxtversion!.zip
@echo.
call :_prevmenu
goto _fwmenuskip


:_errordownloadfwtxt
rem StartRusTextBlock
@echo Ошибка скачивания
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Download error
rem EndEngTextBlock
@echo.
goto _returnmenu

:_GetFTP
set transfer=get
call :_ftpconnect
@del ftp_%transfer%.txt /q /f  1>nul 2>nul
exit /b

rem :__GetFTP
rem if %ftpfile%==fw2.txt set %ftpfile%=fwquest2
rem if %ftpfile%==fw3.txt set %ftpfile%=fwquest3
rem if %ftpfile%==fwp.txt set %ftpfile%=fwquestp
rem if %ftpfile%==alllinks.txt set %ftpfile%=fwoldlinks
rem if %ftpfile%==allfwlinks.txt set %ftpfile%=fwalllinks
rem set %ftpfile%=fwquest1
rem set rentryurlpage=%ftpfile%
rem set rentryfilename=%rentryurlpage%.txt
rem call %myfiles%\rentry.cmd --raw --url %rentryurlpage% --file "%rentryfilename%".txt

rem :__PutFTP
rem if %ftpfile%==fw2.txt set %ftpfile%=fwquest2
rem if %ftpfile%==fw3.txt set %ftpfile%=fwquest3
rem if %ftpfile%==fwp.txt set %ftpfile%=fwquestp
rem if %ftpfile%==alllinks.txt set %ftpfile%=fwoldlinks
rem if %ftpfile%==allfwlinks.txt set %ftpfile%=fwalllinks
rem set %ftpfile%=fwquest1
rem set rentryfileupload=%ftpfile%
rem set rentryurlpage=%ftpfile%
rem set rentrycodepage=%ftpfile%
rem echo %ftpfile%
rem call %myfiles%\rentry.cmd --edit --url %rentryurlpage% --edit-code %rentrycodepage% --file "%rentryfileupload%".txt

:_PutFTP
set transfer=put
call :_ftpconnect_old
@del ftp_%transfer%.txt /q /f 1>nul 2>nul
@del %fwtxt% /q /f 1>nul 2>nul
exit /b

:_ftpconnect
rem https://cocaine.trade/firmwares.yaml

if not defined ftpfile cls&&goto _NoDevice

if %ftpfile%==fw1.txt set ctlink=Quest_firmware&&set CTSourceFile=ct1.txt
if %ftpfile%==fw2.txt set ctlink=Quest_2_firmware&&set CTSourceFile=ct2.txt
if %ftpfile%==fw3.txt set ctlink=Quest_3_firmware&&set CTSourceFile=ct3.txt
if %ftpfile%==fwp.txt set ctlink=Quest_Pro_firmware&&set CTSourceFile=ctp.txt
if %ftpfile%==fws.txt set ctlink=Quest_3S_firmware&&set CTSourceFile=cts.txt

curl -4 -LJko %CTSourceFile% --resolve cocaine.trade:443:45.150.123.10 "https://cocaine.trade/%ctlink%" -Ss 1>nul 2>nul
if errorlevel 1 (
@echo   =============================================================================
rem StartRusTextBlock
@echo    %_fBRed%Основная база данных прошивок недоступна, используем альтернативный источник%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBRed%The main firmware database is unavailable, using an alternative source%_fReset%
rem EndEngTextBlock
set "shared=e687e93c-a563-4659-8b1b-694acec1e595"
curl -LJko %CTSourceFile% https://app.koofr.net/content/links/!shared!/files/get/%CTSourceFile%?path=%%2F%CTSourceFile% -Ss 1>nul 2>nul
if defined fastbootmark (exit /b)
if errorlevel 1 (
timeout 3 >nul
@echo   =============================================================================
rem StartRusTextBlock
@echo    %_fBRed%Альтернативная база данных прошивок также недоступна%_fReset%
@echo   -----------------------------------------------------------------------------
@echo    %_fBYellow%Убедитесь, что программа запущена от имени администратора.
@echo.
@echo    Проверьте доступность сайта %_fYellow%https://cocaine.trade%_fReset%
@echo    %_fBYellow%или попробуйте использовать VPN на ПК%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBRed%The alternative firmware database is also unavailable%_fReset%
rem @echo   -----------------------------------------------------------------------------
rem @echo    %_fBYellow%Make sure the program is running as Administrator.
rem @echo.
rem @echo    Check the availability of the site %_fYellow%https://cocaine.trade%_fReset%
rem @echo    %_fBYellow%or try using a VPN on your PC%_fReset%
rem EndEngTextBlock
@del /q /f metadata 1>nul 2>nul
if defined fastbootmark (exit /b) else (call :_prevmenu && goto _fwmenu)
)
)
powershell -ExecutionPolicy Bypass -File %myfiles%\ctfwpars.ps1 -InputFile "%CTSourceFile%" -OutputFile "%ftpfile%"
@del /q /f metadata 1>nul 2>nul
@del /q /f %CTSourceFile% 1>nul 2>nul
exit /b

:_ftpconnect_old
@echo open remlink.eu 2222 >>ftp_%transfer%.txt
@echo USER upload upl0ad >>ftp_%transfer%.txt
@echo binary >>ftp_%transfer%.txt
@echo quote PASV >>ftp_%transfer%.txt
@echo cd Upload >>ftp_%transfer%.txt
@echo %transfer% %ftpfile% >>ftp_%transfer%.txt
@echo quit >>ftp_%transfer%.txt
@ftp -v -n -s:ftp_%transfer%.txt 1>nul 2>nul
exit /b

:_fwdownload
call :_cdc
@%verbecho%
@set arcpath=%myfiles%
@echo ===============================================================
rem StartRusTextBlock
@echo Создаем архив багрепорта, это займет 3-4 минуты
@echo Должна появиться такая строчка:
@echo.
@echo [  1%%%] generating bugreport-...
@echo.
@echo Если в течении минуты не появилась, закройте программу и запустите ее снова
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Creating bugreport archive, this may take 3-4 minutes
rem @echo You should see a line like this:
rem @echo.
rem @echo [  1%%%] generating bugreport-...
rem @echo.
rem @echo If it doesn't appear within a minute, close the program and run it again
rem EndEngTextBlock
@echo ---------------------------------------------------------------
rem @echo.
@%myfiles%\adb bugreport %cd% 2>nul
if %errorlevel% == -1 goto _errorbugrepdl
@echo.
@echo ---------------------------------------------------------------
rem StartRusTextBlock
@echo  = Багрепорт создан, выдергиваем ссылку....
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Bugreport created, extracting the link....
rem EndEngTextBlock
rem @echo.
@%myfiles%\7z.exe x %cd%\bugreport*.zip -o"%cd%\bugreport" 1>NUL 2>&1
@SetLocal EnableDelayedExpansion
Set bugrepdir=.\bugreport\FS\data\misc\update_engine_log\
For /F "tokens=*" %%i In ('@Dir /S /A:-D /B "%bugrepdir%"') Do (
set fullname=%%i

	for /f "tokens=*" %%a in ('findstr /i /c:"initial url: " !fullname!') do (
	set urlstr=%%a
		for /f "tokens=1,2,3 delims= " %%b in ("!urlstr!") do set urllink=%%d&@echo !urllink!>>links.txt
	)
	)

rem Вытаскиваем из Dumpsys
for /f "tokens=1,2 delims= " %%a in ('%myfiles%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"download_uri"') do set urllinkdump=%%b&@echo !urllinkdump!>>links.txt

@if not exist links.txt goto _EmptyLinkTxt
@findstr "^" "links.txt">nul&& @echo.|| goto _EmptyLinkTxt
@ren link.txt link.old.txt 1>nul 2>nul

rem Удаление дублей
@for /f "tokens=*" %%a in (links.txt) do (
@findstr /l /c:"%%a" link.txt 1>nul 2>nul || @echo %%a>>link.txt
)

if [%choice%]==[cc] goto _SaveLinkList

@echo ---------------------------------------------------------------
rem StartRusTextBlock
@echo   = Извлечение завершено, начинаем скачивание прошивки....
@echo     Ссылок может быть не одна, в этом случае скачиваться они будут по-очереди.
@echo     Это может занять значительное время.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Extraction completed, starting firmware download....
rem @echo    There may be more than one link, in which case they will be downloaded sequentially.
rem @echo    This may take a considerable amount of time.
rem rem @echo.
rem EndEngTextBlock
@echo.
@for /f "tokens=*" %%a in (link.txt) do (
set "dlink=%%a"
@echo   --------------------------------------------
rem StartRusTextBlock
@echo   = Скачивание прошивки...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Firmware download in progress...
rem EndEngTextBlock
call :_DownloadFirmware
)
@del metadata 2>nul 1>nul
@del links.txt 2>nul 1>nul
@del link.txt 2>nul 1>nul
@del bugreport*.zip /q
@rd %cd%\bugreport /Q /S
rem StartRusTextBlock
@echo   --------------------------------------------
@echo   = Проверка файлов прошивок на ошибки и дубли
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Checking firmware files for errors and duplicates
rem EndEngTextBlock
@echo.
call :_CheckFWDoubleErrors
@echo   --------------------------------------------
rem StartRusTextBlock
@echo   = Файлы проверены, дубли удалены.
@echo     Если рядом с программой лежит файл fwerrors.txt, в нем перечислены
@echo     имена прошивок, скачанных с ошибками. Их можно перекачать отдельно,
@echo     используя ссылки в этом файле.
@echo.
@echo -----
@echo = Готово. 
@echo.
@echo   Если скачивания не было, загляните в файл fwlinks.txt,
@echo   созданный только что рядом с программой и вручную 
@echo   скопируйте ссылку на прошивку (если она там есть) в браузер.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Files have been checked, duplicates removed.
rem @echo     If there is a file named fwerrors.txt next to the program, 
rem @echo     it lists the names of the firmware files that were downloaded with errors.
rem @echo     You can re-download them separately using the links provided in this file.
rem @echo.
rem @echo -----
rem @echo = Done.
rem @echo.
rem @echo   If there was no download, check the fwlinks.txt file,
rem @echo   which was just created next to the program. 
rem @echo   Manually copy the firmware link (if available) into your browser.
rem EndEngTextBlock
goto _returnmenu
rem goto _Sendlink

:_hsfwversionextract
For /F %%a In ('@%MYFILES%\adb shell getprop ro.build.version.incremental 2^>nul') Do set hsenvironment=%%a
@FOR /F "tokens=1,2 delims==" %%a IN ('@%MYFILES%\adb shell dumpsys package com.oculus.systemux 2^>nul ^| findstr /i /c:"VersionName"') DO (
@FOR /F "tokens=1,2,3,4 delims=." %%a IN ("%%b") DO set "fwnewhsversion=%%a.%%b.%%c.%%d"
)
set "hsversion=!fwnewhsversion!"
exit /b

:_SaveLinkList
rem StartRusTextBlock
@echo   ---------------------------------------------------------------
@echo   = Готово, список ссылок сохранен в файл link.txt
@echo.
@echo     Следует иметь в виду, что без скачивания прошивок
@echo     невозможно проверить ссылки на доступность этих прошивок.
@echo     Иными словами, некоторые ссылки могут быть просроченными.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Done, the list of links has been saved to the link.txt file.
rem @echo.
rem @echo     Please note that without downloading the firmware,
rem @echo     it is impossible to check the availability of these links.
rem @echo     In other words, some links may be expired.
rem @echo.
rem EndEngTextBlock
@del metadata 2>nul 1>nul
@del links.txt 2>nul 1>nul
@del bugreport*.zip /q
@rd %cd%\bugreport /Q /S
goto _returnmenu

:_Sendlink
@echo ---------------------------------------------------------------
@echo.
@echo.
rem StartRusTextBlock
@echo  Хотите ли вы выгрузить ссылку на прошивку автору программы?
@echo  Это поможет создать список серверов с целью обхода их блокировки.
@echo.
@echo  Также это даст другим пользователям возможность скачать и установить
@echo  новую прошивку, если она по каким-то причинам у них недоступна.
@echo.
@echo   Если да - просто нажмите Enter. Если нет - 0 и Enter.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Do you want to upload the firmware link to the program author?
rem @echo This will help create a list of servers to bypass any blocking.
rem @echo.
rem @echo It will also allow other users to download and install
rem @echo the new firmware if it is not available to them for any reason.
rem @echo.
rem @echo   If yes - simply press Enter. If no - 0 and Enter.
rem EndEngTextBlock
@echo.
@echo.
@set "choicesend="
@set "choicesend=savelink"
@Set /p choice=">>> "
@echo.
if not defined choicesend goto _Sendlink
if /i "%choicesend%"=="savelink" (GOTO _Savelink)
if /i "%choicesend%"=="0" (GOTO _fwmenuskip)
cls
goto _Sendlink

:_SaveLink
@echo ------
rem StartRusTextBlock
@echo  Спасибо за помощь^!
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Thank you for your help!
rem EndEngTextBlock
rem >>>>>>>>>>>>>>>
if [%choice%]==[cc] (
set fwlinks=link.txt
set allfwlinks=fwoldlinks
) else (
set fwlinks=fwlinks.txt
set allfwlinks=fwalllinks
)
rem >>>>>>>>>>>>>>
set ftpfile=%allfwlinks%
call :_GetFTP
@for /f "tokens=*" %%a in (%fwlinks%) do (
set "savelinks=%%a"
@echo !savelinks! >>%allfwlinks%.txt
)

set ftpfile=%allfwlinks%.txt
call :_PutFTP
@del %allfwlinks%.txt /q /f 1>nul 2>nul
@del alllinks.txt /q /f 1>nul 2>nul
@echo.
rem StartRusTextBlock
@echo Ссылка выгружена.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Link uploaded.
rem EndEngTextBlock
@echo ------
@echo.
goto _returnmenu



:_EmptyLinkTxt
@del rezult.txt 2>nul 1>nul
@del rezult2.txt 2>nul 1>nul
@rd %cd%\bugreport /Q /S
@del bugreport*.zip /q
@echo -----
@echo.
rem StartRusTextBlock
@echo  К сожалению, ссылку на прошивку вытащить не удалось,
@echo  в багрепорте ее нет. Быть может, получится в другой раз.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Unfortunately, the firmware link couldn't be extracted from the bugreport. 
rem @echo  Perhaps next time it will be possible.
rem EndEngTextBlock
@echo ---------------------------------------------------------------
@echo.
@echo.
goto _returnmenu

:_DownloadFirmware
@call :_SetOnlyTime
set postbuild=
@curl -LJko fwtempfile_%ti%.zip "%dlink%" -#
%myfiles%\7z.exe e fwtempfile_%ti%.zip metadata -r -y 1>nul 2>nul
if %errorlevel% NEQ 0 call :_FirmwareDownloadError & exit /b
@FOR /F "tokens=2 delims==" %%a IN ('@FINDstr /c:"post-build-incremental" metadata 2^>nul') DO @set postbuild=%%a
if [%postbuild%]==[] del fwtempfile_%ti%.zip /q 1>nul 2>nul
@ren fwtempfile_%ti%.zip %postbuild%_%ti%.zip 1>nul 2>nul
@del metadata /q 1>nul 2>nul
@echo %postbuild% !dlink!>>fwlinks.txt
rem >>>>>>>>>>>>>>>>>
rem @echo %fmfilename% [%postbuild%](!dlink!^)>>rentryfwlinks.txt
rem >>>>>>>>>>>>>>
rem StartRusTextBlock
@echo   = Файл прошивки сохранен с именем %postbuild%_%ti%.zip
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The firmware file has been saved with the name %postbuild%_%ti%.zip
rem EndEngTextBlock
rem @echo.
@timeout 1 1>nul
exit /b

:_CheckFWDoubleErrors
setlocal enabledelayedexpansion
set "fileNames="
for /f "delims=" %%a in ('dir /b /a-d *.zip 2^>nul') do (
@%myfiles%\7z.exe t %%a 2>fwerrors.txt 1>nul
for /f "tokens=1 delims=_" %%b in ("%%~na") do (
set "baseName=%%b"
if defined fileNames[!baseName!] (
set fn=%%a
call :_DeleteSameFile
) else (
set "fileNames[!baseName!]=%%a"
)
)
)
endlocal
@findstr "^" "fwerrors.txt"2>nul&& echo.|| @del /f /q fwerrors.txt 1>nul 2>nul
exit /b

:_DeleteSameFile
%myfiles%\7z.exe e "%fn%" metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%c IN ('@FINDstr /c:"post-build-incremental" metadata 2^>nul') DO @set postbuild=%%c
if [%baseName%]==[%postbuild%] @del /q /f "%fn%"
@del /q /f metadata 1>nul 2>nul
exit /b


:_FirmwareDownloadError
@echo -----------------------------
rem StartRusTextBlock
@echo   === Ошибка скачивания ===
@echo   Возможно ссылка просрочена и файл больше недоступен.
@echo   Ссылка скопирована в файл fwbrokenlinks.txt, попробуйте скачать вручную.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   === Download Error ===
rem @echo   The link might be expired, and the file may no longer be available.
rem @echo   The link has been copied to the fwbrokenlinks.txt file; please try downloading it manually.
rem EndEngTextBlock
@echo.
@echo !dlink!>>fwbrokenlinks.txt
@del /q /f fwtempfile_%ti%.zip 1>nul 2>nul
exit /b

:_SetOnlyTime
set ti=%time:~0,2%-%time:~3,2%-%time:~6,2%
set ti=%ti: =0%
exit /b


:_errorbugrepdl
@echo ---------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo Не удалось создать архив багрепорта, 
@echo попробуйте еще раз через несколько минут.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Failed to create the bugreport archive, please try again in a few minutes.
rem EndEngTextBlock
@echo.
@echo.
goto _returnmenu

:_NoInternetMessage
@echo.
@echo  ------------------------------------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|   +++ Подключение к Интернет отсутствует. Информация о результатах проверки недоступна +++   ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   +++ Internet connection is not available. Results of the check are unavailable +++   ^|
rem EndEngTextBlock
@echo  ------------------------------------------------------------------------------------------------
@echo.
goto _returnmenu


:_NoHeadsetMessage
@echo.
@echo  -------------------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|   +++ Шлем не подключен. Информация о результатах проверки недоступна +++   ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   +++ The headset is not connected. Information about the test results is unavailable +++   ^|
rem EndEngTextBlock
@echo  -------------------------------------------------------------------------------
@echo.
goto _returnmenu


:_blmessage
@echo.
@echo  ---------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^|   +++ Шлем в режиме Bootloader. Информация о нем недоступна +++   ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   +++ The headset is in Bootloader mode. Information about it is unavailable +++   ^|
rem EndEngTextBlock
@echo  ---------------------------------------------------------------------
@echo.
goto _returnmenu

:_SetFirmwareFileName
@call :_DeleteWrongSymbols
@set FirmwareFileName=
@for %%a in (*.zip) do @set FirmwareFileName=%%~nxa
@ren "%FirmwareFileName%" update.zip 1>nul 2>nul
@set FirmwareFileName=update.zip
exit /b

:_DeleteWrongSymbols
@for %%a in (*.zip) do (
set name=%%~nxa
rem call set "name=%%name:(=%%"
rem  call set "name=%%name:)=%%"
call set "name=%%name:^!=%%"
call set "name=%%name:+=%%"
call set "name=%%name: =%%"
rem call set "name=%%name::=%%"
 cmd/v/c ren "%%a" "!name:%%=!"
)
rem set FirmwareFileName=%name%
exit/b

:_hatqut
::@cls
rem @echo  ==================================================================================================
@echo          +++  Quest Update Tool - created by Varset - v.1.8 - 18.09.25  +++
rem @echo  ==================================================================================================
@exit /b

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_bugreportextr
call :_cdc
@%verbecho%
@echo ===============================================================
rem StartRusTextBlock
@echo Создаем архив багрепорта, это займет 3-4 минуты
@echo Должна появиться такая строчка:
@echo.
@echo [  1%%%] generating bugreport-...
@echo.
@echo Если в течении минуты не появилась, закройте программу и запустите ее снова
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Creating a bugreport archive, this will take 3-4 minutes
rem @echo You should see the following line:
rem @echo.
rem @echo [  1%%%] generating bugreport-...
rem @echo.
rem @echo If it doesn't appear within a minute, close the program and run it again
rem EndEngTextBlock
@echo ---------------------------------------------------------------
@echo.
@%myfiles%\adb bugreport %cd%
@If %ERRORLEVEL% EQU 1 goto _reporterr
@echo ===============================================================
@echo.
rem StartRusTextBlock
@echo Архив с багрепортом извлечен и помещен в текущий каталог
@echo В браузере откроется вкладка, загрузите в нее архив.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The bugreport archive has been extracted and placed in the current directory
rem @echo A browser tab will open, upload the archive there.
rem EndEngTextBlock
@echo ---------------------------------------------------------------
@ping localhost -t 3 1>nul 2>nul
rem @start " " "https://bathist.ef.lc/"
@start " " "https://batteryhistorian.itachi1706.com/"
@echo.
@echo.
goto _returnmenu

:_reporterr
@cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo +++ Не удалось извлечь багрепорт. Попробуйте зайти чуть позже +++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo +++ Failed to extract the bugreport. Try again later +++
rem EndEngTextBlock
@echo.
@echo.
call :_hatmenu
@echo.
@echo.
@echo.
goto _returnmenu


:_datetimecorrmenu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Просмотр времени и таймзоны шлема
@echo    B.  Коррекция времени и таймзоны
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A. View headset time and timezone
rem @echo    B. Time and timezone correction
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _datetimecorrmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _datetime)
if /i "%choice%"=="b" (GOTO _datetimecorr)

:_datetimecorr
call :_cdc
@echo ^<job^>^<script language^="JavaScript"^> >>etime.wsf
@echo WScript.echo^(new Date^().getTime^())^; >>etime.wsf
@echo ^<^/script^>^<^/job^> >>etime.wsf
@for /f "tokens=* usebackq" %%a in (`@start /b cscript //nologo "etime.wsf"`) do (set epochtimestamp=%%a)
@%myfiles%\adb shell service call alarm 2 i64 %epochtimestamp% 1>nul 2>nul
@del etime.wsf /q /f 1>nul 2>nul
@echo ----------------------------------------------
rem StartRusTextBlock
@echo = Проверяем время после коррекции...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Checking the time after correction...
rem EndEngTextBlock
@echo.
call :_checktime
rem @echo.
rem StartRusTextBlock
rem @echo ----------------------------------------------
@echo = Время скорректировано
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Time corrected
rem EndEngTextBlock
@echo.  
@echo ----------------------------------------------
rem @echo --- 
rem StartRusTextBlock
@echo Текущие значения:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Current values:
rem EndEngTextBlock
@echo. 
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"`) do (set ths=%%a)
rem StartRusTextBlock
@echo  Дата и время на шлеме	: %ths%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Date and time on the headset: %ths%
rem EndEngTextBlock
@call :_SETTIME
rem StartRusTextBlock
@echo  Дата и время на ПК	: %dppt%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Date and time on the PC: %dppt%
rem EndEngTextBlock
@echo ----------------------------------------------
@echo. 
@echo. 
@echo. 
@echo. 
goto _returnmenu

:_checktime
call :_cdc
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"`) do (set ths=%%a)
@call :_SETTIME
@echo ----------------------------------------------
if %ths:~0,-3%==%dppt:~0,-3% (
rem @echo.
exit /b
) else (
@echo.
@echo  ===============================================================
rem StartRusTextBlock
@echo  ^|     +++      Требуется корректировка таймзоны      +++      ^|
@echo        Нажмите что-нибудь для перехода в меню корректировки
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|     +++      Timezone correction required      +++      ^|
rem @echo        Press any key to proceed to the correction menu
rem EndEngTextBlock
)
@echo  ===============================================================
@echo.
@pause >nul
goto :_timezonecorr

:_datetime
call :_cdc
@%verbecho%
@cls
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    C.  Скорректировать дату и время
@echo    T.  Скорректировать таймзону
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    C.  Correct date and time
rem @echo    T.  Correct timezone
rem EndEngTextBlock
@echo.
@echo ----------------------------------------------
call :_cdc
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell getprop persist.sys.timezone`) do (set tzhs=%%a)
rem StartRusTextBlock
@echo  Таймзона на шлеме	: %tzhs%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Timezone on the headset	: %tzhs%
rem EndEngTextBlock
set "pscommand=(Get-TimeZone).DisplayName"
call :_ps1CommandRun tzpc
rem StartRusTextBlock
@echo  Таймзона на ПК		: %tzpc%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Timezone on the PC		:%tzpc%
rem EndEngTextBlock
@echo ---
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"`) do (set ths=%%a)
rem StartRusTextBlock
@echo  Дата и время на шлеме	: %ths%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Date and time on the headset	: %ths%
rem EndEngTextBlock
@call :_SETTIME
rem StartRusTextBlock
@echo  Дата и время на ПК	: %dppt%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Date and time on the PC	: %dppt%
rem EndEngTextBlock
@echo ----------------------------------------------
%MYFILES%\adb shell ping -c 2 time.android.com 1>nul 2>nul

rem StartRusTextBlock
if errorlevel 1 (set hstimeaccess=%_fBRed%Недоступен%_fReset%) else (set hstimeaccess=%_fBGreen%Доступен%_fReset%)
@echo  %_fBYellow%Сервер времени на шлеме%_fReset%	: %hstimeaccess%
rem EndRusTextBlock
rem StartEngTextBlock
rem if errorlevel 1 (set hstimeaccess=%_fBRed%Inaccessibled%_fReset%) else (set hstimeaccess=%_fBGreen%Accessibled%_fReset%)
rem @echo  %_fBYellow%Time server on headset%_fReset%	: %hstimeaccess%
rem EndEngTextBlock
if %ths:~0,-4%==%dppt:~0,-4% (
@echo.
@echo.
@echo  ===============================================================
rem StartRusTextBlock
@echo  ^|  %_fBGreen%+++   Время правильное, корректировка не требуется   +++%_fReset%   ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|    %_fBGreen%+++    Time is correct, no adjustment required%_fReset%    +++    ^|
rem EndEngTextBlock
@echo  ===============================================================
) else (
@echo.
@echo  ============================================================================
rem StartRusTextBlock
@echo  ^|  %_fBRed%+++    Время или таймзона различаются, требуется корректировка    +++%_fReset%   ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|  %_fBRed%+++   Time differs, adjustment is required%_fReset%   +++   ^|
rem EndEngTextBlock
@echo  ============================================================================
)
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  Значительное отличие времени, даты и таймзоны от актуальных значений
@echo  может вызвать проблемы с подключением к сети Wi-Fi
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Significant difference in time, date, and timezone from actual values
rem @echo  may cause issues with Wi-Fi network connectivity
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _datetime
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="c" (GOTO _datetimecorr)
if /i "%choice%"=="t" (GOTO _timezonecorr)
cls
goto _datetime


:_timezonecorr
@%verbecho%
rem @cls
call :_hat
@echo.
rem StartRusTextBlock
@echo                ===  Корректировка таймзоны ===
call :_hatmenu
@echo.
@echo    L.  Открыть в барузере список таймзон
@echo.   R.  Установить таймзону вручную
@echo.
@echo.   1.   UTC +01.00	Europe/Amsterdam
@echo.   2.   UTC +02.00	Europe/Sofia
@echo.   3.   UTC +03.00	Europe/Moscow
@echo.   4.   UTC +04.00	Asia/Baku
@echo.   5.   UTC +05.00	Asia/Ashkhabad
@echo.   6.   UTC +06.00	Asia/Astana
@echo.
@echo   Если в этом списоке нет вашей таймзоны, введите L и нажмите Enter (см. меню)
@echo   Откроется браузер со списком таймзон, в котором выберите и скопируйте вашу.
@echo   Затем введите в программе R, нажмите Enter и вставьте выбранную таймзону. 
@echo.
@echo.
@echo Пример: 
@echo.
@echo    Вы живете во Владивостоке, ваша таймзона +10.
@echo.   В браузере, в списке таймзон находите Asia/Vladivostok,
@echo.   копируете именно так, жмете R, подтверждаете Enter,
@echo    и вставляете: Asia/Vladivostok
@echo    Затем снова подтверждаете Enter
@echo.
@echo.
@set "choice="
@Set /p choice="Для установки таймзоны введите число от 1 до 6 и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo                ===  Timezone Adjustment ===
rem call :_hatmenu
rem @echo.
rem @echo    L.  Open timezone list in browser
rem @echo.   R.  Set timezone manually
rem @echo.
rem @echo.   1.   UTC +01.00	Europe/Amsterdam
rem @echo.   2.   UTC +02.00	Europe/Sofia
rem @echo.   3.   UTC +03.00	Europe/Moscow
rem @echo.   4.   UTC +04.00	Asia/Baku
rem @echo.   5.   UTC +05.00	Asia/Ashkhabad
rem @echo.   6.   UTC +06.00	Asia/Astana
rem @echo.
rem @echo   If your timezone is not in this list, enter L and press Enter (see menu)
rem @echo   A browser will open with a list of timezones, where you can select and copy yours.
rem @echo   Then enter R in the program, press Enter, and paste the selected timezone.
rem @echo.
rem @echo.
rem @echo Example: 
rem @echo.
rem @echo    You live in Vladivostok, your timezone is +10.
rem @echo.   In the browser, in the timezone list find Asia/Vladivostok,
rem @echo.   copy exactly that, press R, confirm with Enter,
rem @echo    and paste: Asia/Vladivostok
rem @echo    Then confirm again with Enter
rem @echo.
rem @echo.
rem @set "choice="
rem @Set /p choice="To set timezone, enter a number from 1 to 6 and press Enter: "
rem EndEngTextBlock
@echo.
if not defined choice goto _timezonecorr
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="1" (set timezonereg=Europe/Amsterdam && goto _setonlytimezone)
if /i "%choice%"=="2" (set timezonereg=Europe/Sofia && set utc=2&& goto _setonlytimezone)
if /i "%choice%"=="3" (set timezonereg=Europe/Moscow && set utc=3&& goto _setonlytimezone)
if /i "%choice%"=="4" (set timezonereg=Asia/Baku && set utc=4&& goto _setonlytimezone)
if /i "%choice%"=="5" (set timezonereg=Asia/Ashkhabad && set utc=5&& goto _setonlytimezone)
if /i "%choice%"=="6" (set timezonereg=Asia/Astana && set utc=6&& goto _setonlytimezone)
if /i "%choice%"=="l" (start " " "https://en.wikipedia.org/wiki/List_of_tz_database_time_zones")
if /i "%choice%"=="r" (GOTO _handesetonlytimezone)
cls
goto _datetime

:_setonlytimezone
@%myfiles%\adb shell service call alarm 3 s16 "%timezonereg%"
@echo.
rem StartRusTextBlock
@echo  Установлена таймзона %timezonereg% (UTC +0%utc%.00)
@echo.
@echo.
@echo  =======================================
@echo         Таймзона установлена 
@echo     Нажмите что-нибудь для проверки
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Timezone set to %timezonereg% (UTC +0%utc%.00)
rem @echo.
rem @echo.
rem @echo  =======================================
rem @echo   Timezone set
rem @echo   Press any key to check
rem EndEngTextBlock
@echo  =======================================
@pause >nul
goto _datetime
rem goto _datetimecorrmenu

:_handesetonlytimezone
@echo ----------------
rem StartRusTextBlock
@echo   0. Выход
@echo   M. Меню таймзоны
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   0. Exit
rem @echo   M. Timezone Menu
rem EndEngTextBlock
@echo ----------------
@echo.
@echo.
@set "handtimezone="
rem StartRusTextBlock
@Set /p handtimezone="Вставьте сюда скопированную таймзону и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p handtimezone="Paste the copied timezone here and press Enter: "
rem EndEngTextBlock
if "%handtimezone%"=="0" (exit)
if /i "%handtimezone%"=="m" (GOTO _timezonecorr)
@%myfiles%\adb shell service call alarm 3 s16 "%handtimezone%"
@echo.
rem StartRusTextBlock
@echo  Установлена таймзона %handtimezone%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Timezone set to %handtimezone%
rem EndEngTextBlock
@echo.
@echo.
goto _prevmenu
goto _datetimecorrmenu


:_todmenu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Просмотр прогресса скачивания				[EXP]
@echo    B.  Запись DNS серверов в шлем
@echo    C.  Автоматическй подбор DNS для скачивания обновлений	[EXP]
@echo    D.  Сброс DNS настроек шлема в дефолт
@echo    E.  Полностью отключить частый DNS сервер
@echo    F.  Установить DNS интернет-заглушку				[EXP]
@echo    G.  Проверка доступности обновлений на ПК			[EXP]
@echo    I.  Проверка доступности обновлений на шлеме			[EXP]
@echo    J.  Узнать статус текущего DNS сервера и его адерс
@echo.
@echo.
@echo    ВАЖНО:
@echo.
@echo       Этот раздел предназначен для упрощения первичной настройки шлема.
@echo       С помощью Автоподбора DNS серверов программа поможет обойти
@echo       блокировки и скачать обновления при начальной настройке.
@echo       Для этого она будет автоматически перебирать список DNS серверов
@echo       и проверять доступность серверов обновления.
@echo       Если закачка не начнется, программа сменит DNS сервер и повторит проверку.
@echo       Как только обнаружится начало успешного обновления, программа остановит
@echo       перебор серверов и отобразит текущий статус прогресса. Периодически статус
@echo       обновляется, с заданным интервалом. Программа будет работать до тех пор,
@echo       пока не найдет подходящий DNS сервер из 97 доступных в списке и не скачает обновления.
@echo.
@echo       Программу также можно использовать для скачивания прошивок, 
@echo       если серверы недоступны обычным способом.
@echo.
@echo       Опция Просмотр прогресса скачивания отобразит статус прогресса в процентах.
@echo.
@echo       После запуска из пунктов A или C будет предложено ввести интервал между проверками,
@echo       в секундах. Можно нажать Enter для интервала по умолчанию 15 секунд
@echo       или ввести свое число и подтвердить кнопкой Enter. 
@echo.      Для возврата в это меню введите "0" без кавычек.  
@echo.
@echo       Желательно устанавливать интервал не меньше 10 секунд.
@echo.
@echo       Если прогресс отсутствует, рекомендуется увеличить интервал проверок вплоть до 30 секунд.
@echo       В этом случае на одну проверку будет уходить чуть больше двух минут.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  View download progress             [EXP]
rem @echo    B.  Record DNS servers to headset
rem @echo    C.  Automatic selection of DNS for downloading updates    [EXP]
rem @echo    D.  Reset headset DNS settings to default
rem @echo    E.  Disable Private DNS
rem @echo    F.  Set up DNS Internet blocking        [EXP]
rem @echo    G.  Checking for updates availability on PC           [EXP]
rem @echo    I.  Checking for updates availability on headset       [EXP]
rem @echo    J.  Get the status of the current DNS server and its address
rem @echo.
rem @echo.
rem @echo    IMPORTANT:
rem @echo.
rem @echo       This section is designed to simplify the initial setup of the headset.
rem @echo       With the Auto DNS Selection, the program will help bypass restrictions
rem @echo       and download updates during the initial setup.
rem @echo       To do this, it will automatically cycle through a list of DNS servers and check the
rem @echo       availability of update servers. If the download does not start, the program will change
rem @echo       the DNS server and retry the check. Once a successful update start is detected, the program
rem @echo       will stop cycling through servers and display the current progress status. The status
rem @echo       is periodically updated at the set interval. The program will continue to work until it
rem @echo       finds a suitable DNS server out of the 81 available in the list and downloads updates.
rem @echo.
rem @echo       The program can also be used to download firmware
rem @echo       if the servers are not available in the usual way.
rem @echo.
rem @echo       The View download progress option will display the progress status in percentages.
rem @echo.
rem @echo       After starting from options A or C, you will be prompted to enter the interval between
rem @echo       checks, in seconds. You can press Enter for the default 15-second interval or enter your
rem @echo       own number and confirm with Enter. To return to this menu, enter "0" without quotes. 
rem @echo.
rem @echo       It is advisable to set the interval to no less than 10 seconds.
rem @echo.
rem @echo       If progress is not displayed, it is recommended to increase the check interval up
rem @echo       to 30 seconds. In this case, one check will take just over two minutes
rem EndEngTextBlock
@echo.      
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _todmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _UpdateProgressSearchBint)
if /i "%choice%"=="b" (GOTO _dnschangeonly)
if /i "%choice%"=="c" (call :_dnschangeint && goto _dnslistfinished)
if /i "%choice%"=="d" (GOTO _setdnsdefault)
if /i "%choice%"=="e" (GOTO _setdnsoff)
if /i "%choice%"=="f" (GOTO _dnszaglushka)
if /i "%choice%"=="g" (goto _CheckUpdatesAccessPC)
if /i "%choice%"=="i" (goto _CheckUpdatesAccessHS)
if /i "%choice%"=="j" (goto _currentdns)

cls
goto _todmenu

:_UpdateProgressSearchBint
call :_dnsintervalswitch

:_UpdateProgressSearchB
@%verbecho%
set dnschangelist=0
call :_DelSearchUpdateFiles
@setlocal enableextensions enabledelayedexpansion

:_UpdateProgressSearchMain
set updatesearchstring=Current progress
rem StartRusTextBlock
set modul=первый
rem EndRusTextBlock
rem StartEngTextBlock
rem set modul=first
rem EndEngTextBlock
set tkn=10
call :_nuxsearch
call :_UpdateProgressSearch

set updatesearchstring=OTA applying update
rem StartRusTextBlock
set modul=второй
rem EndRusTextBlock
rem StartEngTextBlock
rem set modul=second
rem EndEngTextBlock
set tkn=11
call :_nuxsearch
call :_UpdateProgressSearch

set updatesearchstring=OTA progress updated
rem StartRusTextBlock
set modul=третий
rem EndRusTextBlock
rem StartEngTextBlock
rem set modul=third
rem EndEngTextBlock
set tkn=12
call :_nuxsearch
call :_UpdateProgressSearch
rem StartRusTextBlock
if %dnschangelist%==1 @echo. && @echo    ...меняем DNS сервер... && timeout 2 >nul && exit /b
rem EndRusTextBlock
rem StartEngTextBlock
rem if %dnschangelist%==1 @echo. && @echo    ...changing DNS server... && timeout 2 >nul && exit /b
rem EndEngTextBlock
call :_DelSearchUpdateFiles
if %dltrsize% NEQ 0 goto _UpdateProgressSearchB
goto _noprss

:_UpdateProgressSearch
set timewait=%dnsint%
call :_cdc
rem StartRusTextBlock
@echo.
@echo  ---------------------------------------------------------------
@echo  =  Запущен %modul% модуль поиска "%updatesearchstring%"
@echo  ---
@echo  ... обновляем данные.... Ждите %timewait% секунд
@echo  ===============================================================
@echo          [ для прерывания нажмите любую кнопку ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  =  Running %modul% module search "%updatesearchstring%"
rem @echo  ---
rem @echo  ...updating data.... Please wait %timewait% seconds
rem @echo  ===============================================================
rem @echo          [ Press any key to interrupt ]
rem EndEngTextBlock
@echo.
call :_DelSearchUpdateFiles
rem StartRusTextBlock
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem EndEngTextBlock
set dlfile=progress.txt
set dllast=pr.txt
rem set lcfile=logcatfile.txt
%MYFILES%\adb logcat -t 10000| FINDstr /c:"%updatesearchstring%" > %dlfile%
%MYFILES%\adb logcat -t 10000| FINDstr /c:"%trackerstatus%" > %trfile%
@(for /f "delims=" %%i in ('type %trfile%') do @set tr_last_string=%%i)
@(for /f "delims=" %%i in ('type %dlfile%') do @set dl_last_string=%%i)
@echo.%dl_last_string% >%dllast%
@echo.%tr_last_string% >%trlast%
FOR /F "tokens=%tkn% delims= " %%s IN (%dllast%) DO (set gprgrs=%%s)
FOR /F "tokens=%tknnux% delims= " %%a IN (%trlast%) DO (set trrgrs=%%a & set trprgrs2=%%b)
@for %%a in ("%dlfile%") do if %%~za==0 (set /a dlsize=0) else (set /a dlsize=1)
@for %%a in ("%trfile%") do if %%~za==0 (set /a trsize=0) else (set /a trsize=1)
set /a dltrsize=%trsize%+%dlsize%
if %dltrsize%==0 exit /b
cls
call :_hat
@echo.
rem StartRusTextBlock
rem @echo  ---------------------------------------------------------------------------------------
@echo  = Отображен %modul% модуль поиска прогресса:	[ %updatesearchstring% ]
@echo.
@echo  =======================================================================================
@echo   Прогресс в процентах	: %gprgrs%%%%
@echo   Выполняется задача	: %trrgrs%%trprgrs2%
@echo   Поисковый модуль	: %updatesearchstring%
@echo   Текущий статус	: %otastatus%
@echo  =======================================================================================
@echo.
@echo    Вначала может показаться, что прогресс не меняется, но это не так.
@echo    Наберитесь терпения, подождите 10-15 минут.
@echo.
@echo    Изредка поглядывайте в шлем, иногда прогресс может показывать менее 100%%%,
@echo    но в шлеме кнопка Скачивание уже  поменялась на Перезагрузить и применить.
@echo.
@echo  ---------------------------------------------------------------------------------------
@echo.
@echo.
@echo        через %timewait% секунд статус прогресса автоматически обновится.
@echo                 [ для прерывания нажмите любую кнопку ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Displaying %modul% search progress module: [ %updatesearchstring% ]
rem @echo.
rem @echo  =======================================================================================
rem @echo   Progress in percentage   : %gprgrs%%%%
rem @echo   Task in progress         : %trrgrs%%trprgrs2%
rem @echo   Search module           : %updatesearchstring%
rem @echo   Current status          : %otastatus%
rem @echo  =======================================================================================
rem @echo.
rem @echo    At first it may seem like the progress is not changing, but it is not so.
rem @echo    Be patient, wait for 10-15 minutes.
rem @echo.
rem @echo    Occasionally glance at the headset, sometimes the progress may show less than 100%%,
rem @echo    but in the headset the Download button has already changed to Restart and apply.
rem @echo.
rem @echo  ---------------------------------------------------------------------------------------
rem @echo.
rem @echo        The progress status will automatically refresh in %timewait% seconds.
rem @echo                 [ Press any key to interrupt ]
rem EndEngTextBlock
rem if %otastatus%==Completed goto _updatesComplete
@echo.
@echo. 
call :_DelSearchUpdateFiles
set dnschangelist=0
rem StartRusTextBlock
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem EndEngTextBlock

rem if dnslistchange=1 
exit /b
rem goto _UpdateProgressSearchMain
rem :_updatesComplete
rem @echo.
rem @echo      ==============================================================
rem @echo      ^|  +++     Установка обновлений полностью завершена     +++  ^|
rem @echo      ^|        Можно надеть шлем и продолжить его настройку        ^|
rem @echo      ==============================================================
rem exit /b

:_noprss
cls
call :_hat
@echo.
rem StartRusTextBlock
rem @echo ================================================================
@echo         Данные о скачивании или обновлении отсутствуют.
@echo       Можете попробовать зайти чуть позже или подождать.
@echo ================================================================
@echo.
@echo        через %timewait% секунд статус автоматически обновится.
@echo          [ для прерывания нажмите любую кнопку ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Currently, nothing is being downloaded or installed.
rem @echo       You can try again later or wait.
rem @echo ================================================================
rem @echo.
rem @echo        The status will automatically refresh in %timewait% seconds.
rem @echo          [ Press any key to interrupt ]
rem EndEngTextBlock
@echo.
call :_DelSearchUpdateFiles
rem StartRusTextBlock
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem EndEngTextBlock
goto _UpdateProgressSearchMain

:_DelSearchUpdateFiles
@del /Q %dlfile% 1>nul 2>nul
@del /Q %dllast% 1>nul 2>nul
@del /Q %trlast% 1>nul 2>nul
@del /Q %trfile% 1>nul 2>nul
@del /Q logcatfile.txt 1>nul 2>nul
exit /b

:_nuxsearch
set trackerstatus=NuxOtaHighPriAppsUpdateTracker
set trfile=nuxogress.txt
set trlast=nux.txt
set tknnux=7,*
exit /b

:_dnschangeonly
call :_cdc
@setlocal enableextensions enabledelayedexpansion
@if not exist %cd%\dnslist.txt call :_createfile
rem @if not exist %cd%\dnslist.txt call :_createfile
@%MYFILES%\adb shell settings put global private_dns_mode hostname
@for /f "tokens=1,2 delims= " %%a in (%cd%\dnslist.txt) do (

rem @for /f "tokens=1,2 delims= " %%a in (%cd%\dnslist.txt) do (
set dnsnumber=%%a
set dnsname=%%b
@%MYFILES%\adb shell settings put global private_dns_specifier !dnsname!
@echo  ---------------------------------------------------------------
rem StartRusTextBlock
@echo   = Включен DNS сервер:  [ !dnsname! ]
@echo  --- 
@echo    Осталось серверов:    [ !dnsnumber! ] 
@echo  ---------------------------------------------------------------
@echo.
@echo  = Wi-Fi шлема настраивается на новый сервер, секунду...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = DNS server enabled:  [ !dnsname! ]
rem @echo  --- 
rem @echo    Remaining servers:    [ !dnsnumber! ]
rem @echo  ---------------------------------------------------------------
rem @echo.
rem @echo  = Wi-Fi headset is being configured to the new server, please wait...
rem EndEngTextBlock
@timeout 3 /NOBREAK >nul
rem StartRusTextBlock
@echo  = Готово. Новый DNS прописан в шлем.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Done. The new DNS has been set on the headset.
rem EndEngTextBlock
@echo.
call :_dnscontinues
)
:_dnslistfinished
call :_DelSearchUpdateFiles
@echo =====================================================
@echo.
rem StartRusTextBlock
@echo        +++ Список DNS завершен +++ 
@echo.
@echo   К сожалению, придется использовать клиент VPN
@echo  Установить его можно из Главного меню, пункты J-E
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        +++ DNS list completed +++ 
rem @echo.
rem @echo   Unfortunately, you'll need to use a VPN client.
rem @echo   You can install it from the Main Menu, options J-E.
rem EndEngTextBlock
@echo.
@echo.
goto _returnmenu

:_dnscontinues
@echo  --- 
rem StartRusTextBlock
@echo  Для смены DNS нажмите Enter
@echo  Для завершения и выхода в меню введите 0 и нажмите Enter
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  To change DNS, press Enter
rem @echo  To finish and return to the menu, enter 0 and press Enter
rem EndEngTextBlock
@set "choice="
@Set "choice=1"
@Set /p choice=">> "
::@@echo.
if not defined choice goto _dnscontinues
if "%choice%"=="0" (GOTO _todmenu)
if "%choice%"=="1" (exit /b)
goto _dnscontinues
exit /b

:_SETDNSDEFAULT
call :_cdc
@%MYFILES%\adb shell settings put global private_dns_mode opportunistic
call :_erlvl
@%MYFILES%\adb shell settings put global private_dns_specifier null
@%MYFILES%\adb shell "svc wifi disable"
@timeout 3 >nul
@%MYFILES%\adb shell "svc wifi enable"
@echo ========================================
rem StartRusTextBlock
@echo  Дефолтные настройки установлены.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Default settings applied.
rem EndEngTextBlock
@echo.
goto _returnmenu


:_SETDNSOFF
call :_cdc
@%MYFILES%\adb shell settings put global private_dns_mode off
call :_erlvl
@%MYFILES%\adb shell "svc wifi disable"
@timeout 3 >nul
@%MYFILES%\adb shell "svc wifi enable"
@echo ========================================
rem StartRusTextBlock
@echo  Частный DNS сервер отключен.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Private DNS disabled.
rem EndEngTextBlock
@echo.
goto _returnmenu



:_dnschangeint
call :_dnsintervalswitch
:_dnschange
rem call :_dnsintervalswitch
setlocal enableextensions enabledelayedexpansion
set timewait=%dnsint%
rem call :_cdc
@if not exist %cd%\dnslist.txt call :_createfile
@%MYFILES%\adb shell settings put global private_dns_mode hostname
@for /f "tokens=1,2 delims= " %%a in (%cd%\dnslist.txt) do (
set dnsnumber=%%a
set dnsname=%%b
@%MYFILES%\adb shell settings put global private_dns_specifier !dnsname!
rem @%MYFILES%\adb shell "svc wifi disable"
rem @timeout 3 >nul
rem @%MYFILES%\adb shell "svc wifi enable"
set dnschangelist=1
cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo    === Автоматический подбор DNS серверов ===
@echo.
@echo  ===============================================================
@echo  = Включен DNS сервер	: [ !dnsname! ] 
@echo    Осталось проверить	: [ !dnsnumber! ]
@echo  ---
@echo  = Заполняем logcat после смены сервера: Ждите %timewait% секунд
@echo  ===============================================================
@echo     [ для прерывания нажмите любую кнопку ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    === Automatic DNS Server Selection ===
rem @echo.
rem @echo  ===============================================================
rem @echo  = Active DNS Server	: [ !dnsname! ] 
rem @echo    Remaining to check	: [ !dnsnumber! ]
rem @echo  ---
rem @echo  = Filling logcat after server change: Please wait %timewait% seconds
rem @echo  ===============================================================
rem @echo     [ Press any key to interrupt ]
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_DelSearchUpdateFiles
rem StartRusTextBlock
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem EndEngTextBlock
call :_UpdateProgressSearchMain
rem call :_otbor0
)
set dnschangelist=0
rem @echo Finish
rem pause
exit /b

:_noprogress
rem @echo  Не скачивается, меняем DNS сервер
exit /b
rem goto _dnschange

:_dnszaglushka
call :_cdc
@%MYFILES%\adb shell settings put global private_dns_mode hostname
::@%MYFILES%\adb shell settings put global private_dns_specifier 0.0.0.0
@%MYFILES%\adb shell settings put global private_dns_specifier 127.0.0.1
@echo ===========================================================
@echo.
rem StartRusTextBlock
@echo   DNS заглушка установлена, интернет на шлеме отключен.
@echo   Для удаления заглушки сбросьте настройки DNS к дефолтным.
@echo   Это пункт D в меню, которое сейчас на экране чуть выше.
@echo.
@echo.
@echo ^>^>^> Нажмите что-нибудь для выхода в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   DNS spoofing is enabled, internet access on the headset is disabled.
rem @echo   To remove the spoofing, reset DNS settings to default.
rem @echo   This is option D in the menu, which is currently displayed on the screen just above.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press any key to return to the previous menu ^<^<^<
rem EndEngTextBlock
@pause >nul
goto _todmenu

:_CheckUpdatesAccessPC
@%verbecho%
call :_SetColours
@echo  ----------------------------------------------------------------------
rem StartRusTextBlock
@echo  ^| %_fBYellow%= Проверяем доступность обновлений с ПК%_fReset%                            ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^| %_fBYellow%= Checking for updates from PC%_fReset%                            ^|
rem EndEngTextBlock
@echo  ^|                                                                    ^|
@setlocal enableextensions enabledelayedexpansion
call :_AppsNumbersListCheck

set linkUpdates=https://securecdn.oculus.com/binaries/download/?id=
set listtxt=appsnumbers.txt
for /f "tokens=*" %%a in (%listtxt%) do (
curl --fail --head --silent %linkUpdates%%%a 1>nul 2>nul
rem @%myfiles%\wget -q --no-check-certificate --spider %linkUpdates%%%a
if !errorlevel!==0 call :_CheckUpdatesAccessGoodPC && exit /b

)
@echo  ======================================================================
rem StartRusTextBlock
@echo  ^| %_fBRed%               +++      Обновления недоступны       +++%_fReset%            ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^| %_fBRed%               +++      Updates not available       +++         %_fReset%   ^|
rem EndEngTextBlock
@echo  ======================================================================
@echo.
@echo.
@del /q /f appsnumbers.txt 1>nul 2>nul
call :_prevmenu
goto _todmenu


:_CheckUpdatesAccessGoodPC
@echo  ======================================================================
rem StartRusTextBlock
@echo  ^|   %_fBGreen%          +++   Адрес обновлений доступен   +++%_fReset%                  ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   %_fBGreen%          +++   Update address is available   +++     %_fReset%             ^|
rem EndEngTextBlock
@echo  ----------------------------------------------------------------------
rem call :_CheckFirmwareAccessPC
@echo.
@echo.
del /q /f appsnumbers.txt 1>nul 2>nul
call :_prevmenu
goto _todmenu


rem :_CheckFirmwareAccessPC
rem call :_CreateFWfileCheck
rem set linkUpdates=
rem set listtxt=fwlist.txt
rem for /f "tokens=*" %%a in (%listtxt%) do (
rem @%myfiles%\wget -q --no-check-certificate --spider %linkUpdates%%%a
rem if !errorlevel!==0 call :_CheckFirmwareAccessGoodPC && exit /b
rem )
rem @echo  ^|     %_fBRed%         +++   Адрес прошивок недоступен   +++   %_fReset%              ^|
rem @echo  ======================================================================
rem exit /b


rem :_CheckFirmwareAccessGoodPC
rem @echo  ^|   %_fBGreen%           +++   Адрес прошивок доступен   +++   %_fReset%                ^|
rem @echo  ======================================================================
rem exit /b

:_CheckUpdatesAccessHS
@%verbecho%
call :_cdc
call :_cdcbnoreg
@echo  ======================================================================
rem StartRusTextBlock
@echo  ^| %_fBYellow%= Проверяем статус Wi-Fi и IP адрес шлема, ожидание 5 секунд...%_fReset%    ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^| %_fBYellow%= Checking Wi-Fi status and headset IP address, waiting 5 seconds...%_fReset%    ^|
rem EndEngTextBlock
@echo  ^|                                                                    ^|
@echo  ----------------------------------------------------------------------
call :_CheckIPaddress
rem call :_qdshat
@%myfiles%\adb shell "svc wifi disable"
timeout 2 >nul
@%myfiles%\adb shell "svc wifi enable"
@%myfiles%\adb shell svc power stayon wireless
timeout 5 /NOBREAK >nul
rem StartRusTextBlock
@echo  ^| %_fBYellow%= Проверяем доступность обновлений....%_fReset%                             ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^| %_fBYellow%= Checking for updates....%_fReset%                             ^|
rem EndEngTextBlock
@echo  ^|                                                                    ^|
timeout 2 /NOBREAK >nul
::-------------------------------
rem :_CheckUpdatesAccessHS
call :_AppsNumbersListCheck
set linkUpdates=https://securecdn.oculus.com/binaries/download/?id=
set toolname=wget
set shscriptname=wgt.sh
set listtxt=appsnumbers.txt
@%myfiles%\adb push %myfiles%\%toolname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell chmod +x /data/local/tmp/%toolname%
@for /f "tokens=*" %%a in (%listtxt%) do (
@echo /data/local/tmp/wget -q --no-check-certificate --spider %linkUpdates%%%a >%myfiles%\%shscriptname%
@%myfiles%\adb shell rm /data/local/tmp/%shscriptname% 1>nul 2>nul
@%myfiles%\adb push %myfiles%\%shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname%
if %errorlevel%==0 call :_CheckUpdatesAccessGoodHS && exit /b
@echo  ======================================================================
rem StartRusTextBlock
@echo  ^| %_fBRed%               +++    Обновления недоступны     +++  %_fReset%                ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^| %_fBRed%               +++    Updates not available     +++  %_fReset%                ^|
rem EndEngTextBlock
@echo  ======================================================================
@echo.
@del /q %myfiles%\%shscriptname% 1>nul 2>nul
timeout 2 >nul
call :_prevmenu
goto _todmenu
)
call :_prevmenu
goto _todmenu


:_CheckUpdatesAccessGoodHS
@echo  ======================================================================
rem StartRusTextBlock
@echo  ^|   %_fBGreen%          +++   Адрес обновлений доступен   +++%_fReset%                  ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ^|   %_fBGreen%          +++   Update address is available   +++     %_fReset%             ^|
rem EndEngTextBlock
@echo  ----------------------------------------------------------------------
rem call :_CheckFirmwareAccessHS
echo.
echo   ------
del /q /f appsnumbers.txt 1>nul 2>nul
call :_prevmenu
goto _todmenu

rem :_CheckFirmwareAccessHS
rem call :_CreateFWfileCheck
rem set linkUpdates=
rem set toolname=wget
rem set shscriptname=wgt.sh
rem set listtxt=fwlist.txt
rem @%myfiles%\adb push %myfiles%\%toolname% /data/local/tmp/ 1>nul
rem @%myfiles%\adb shell chmod +x /data/local/tmp/%toolname%
rem for /f "tokens=*" %%a in (%listtxt%) do (
rem @echo /data/local/tmp/wget -q --no-check-certificate --spider %linkUpdates%%%a >%myfiles%\%shscriptname%
rem @%myfiles%\adb shell rm /data/local/tmp/%shscriptname% 1>nul 2>nul
rem @%myfiles%\adb push %myfiles%\%shscriptname% /data/local/tmp/ 1>nul
rem @%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
rem @%myfiles%\adb shell sh /data/local/tmp/%shscriptname%
rem if !errorlevel!==0 call :_CheckFirmwareAccessGoodHS && exit /b
rem del /q %myfiles%\%shscriptname%
rem )
rem @echo  ^|     %_fBRed%         +++   Адрес прошивок недоступен   +++   %_fReset%              ^|
rem @echo  ======================================================================
rem timeout 1 >nul
rem exit /b


rem :_CheckFirmwareAccessGoodHS
rem @echo  ^|   %_fBGreen%           +++   Адрес прошивок доступен   +++   %_fReset%                ^|
rem @echo  ======================================================================
rem call :_prevmenu
rem exit /b

:_CheckIPaddress
@%verbecho%
set /a countip=0
:_CheckIPaddressCounter
rem @setlocal enableextensions enabledelayedexpansion
set ip=
set ipfull=
FOR /F "tokens=2" %%G IN ('%myfiles%\adb shell ip addr show wlan0 ^|findstr /i /c:"inet "') DO set ipfull=%%G
FOR /F "tokens=1 delims=/" %%G in ("!ipfull!") DO set ip=%%G
@if [%ip%]==[] call :_WakeupHeadset
exit /b

:_WakeupHeadset
@echo.
rem cls
@echo =========================================================
rem StartRusTextBlock
@echo  %_fBRed% Шлем потерял айпишник, возможно, заснул...%_fReset%
@echo  -------------------------------------
@echo  %_fBYellow%= Пробуждаем...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBRed% Headset lost IP address, possibly asleep...%_fReset%
rem @echo  -------------------------------------
rem @echo  %_fBYellow%= Waking up...%_fReset%
rem EndEngTextBlock
@echo.
@%myfiles%\adb shell svc power stayon true
@%myfiles%\adb shell "svc wifi disable"
@echo  -------------------------------------
rem StartRusTextBlock
@echo  %_fBYellow%= Рестартуем Wi-Fi...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%= Restarting Wi-Fi...%_fReset%
rem EndEngTextBlock
@echo.
timeout 2 >nul
@%myfiles%\adb shell "svc wifi enable"
@echo  -------------------------------------
rem StartRusTextBlock
@echo  %_fBYellow%= Пауза 10 секунд для получения IP адреса...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%= Pausing for 10 seconds to obtain IP address...%_fReset%
rem EndEngTextBlock
@echo =========================================================
@echo.    
@echo.    
set /a countip=%countip%+1
rem StartRusTextBlock
@if %countip%==3 @%myfiles%\adb shell input keyevent 26 && echo ...и в третий раз забросил он в море невод... ^ & echo ...раз так, жмем кнопку питания для пробуждения.... && timeout 10 >nul && call :_CheckIPaddress
rem EndRusTextBlock
rem StartEngTextBlock
rem @if %countip%==3 @%myfiles%\adb shell input keyevent 26 && echo ...and for the third time, he cast the net into the sea... ^ & echo ...since that's the case, pressing the power button to wake up... && timeout 10 >nul && call :_CheckIPaddress
rem EndEngTextBlock

timeout 10 /nobreak >nul
call :_CheckIPaddressCounter
cls
exit /b

rem :_CreateFWfileCheck
rem @if not exist %cd%\fwlist.txt call :_CreateFWfile
rem exit /b

rem :_CreateFWfile
rem @echo https://scontent.fsof8-1.fna.fbcdn.net >> fwlist.txt
rem @echo https://scontent.fvar1-1.fna.fbcdn.net >> fwlist.txt
rem exit /b

:_currentdns
@echo  -----------------------------------------
For /F %%a In ('%myfiles%\adb shell settings get global private_dns_mode') Do set dnsstatus=%%a
if "%dnsstatus%"=="opportunistic" (
rem StartRusTextBlock
@echo  %_fBGreen%= Частный DNS сервер в автоматическом режиме%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBGreen%= Private DNS in the automatical mode%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _todmenu
)
if "%dnsstatus%"=="off" (
rem StartRusTextBlock
@echo  = %_fRed%Частный DNS сервер отключен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fRed%= Private DNS disabled%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _todmenu
)
if "%dnsstatus%"=="hostname" (
set dnsaddr=
rem StartRusTextBlock
@echo  %_fBGreen%= Текущий DNS сервер:%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBGreen%= Current DNS server:%_fReset%
rem EndEngTextBlock
@echo.
For /F %%a In ('%myfiles%\adb shell settings get global private_dns_specifier') Do set dnsaddr=%%a
)
if "%dnsaddr%" NEQ "null" (@echo    %_fBCyan%%dnsaddr%%_fReset%
) else (
rem StartRusTextBlock
@echo  %_fBYellow%Адрес DNS сервера не прописан%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBYellow%Address not found%_fReset%
rem EndEngTextBlock

)
rem @%myfiles%\adb shell settings get global private_dns_specifier
call :_prevmenu
goto _todmenu


:_AppsNumbersListCheck
@if not exist %cd%\appsnumbers.txt call :_AppsNumbersList
exit /b
:_AppsNumbersList
@echo 6921585431288199 >> appsnumbers.txt
@echo 6790841417672943 >> appsnumbers.txt
@echo 6550863581679128 >> appsnumbers.txt
@echo 6787200061401184 >> appsnumbers.txt
@echo 6552514178193322 >> appsnumbers.txt
@echo 6942335212498447 >> appsnumbers.txt
@echo 6885911831476388 >> appsnumbers.txt
@echo 6746494485418022 >> appsnumbers.txt
@echo 4506188769466810 >> appsnumbers.txt
@echo 6836488203056063 >> appsnumbers.txt
@echo 6867463123342685 >> appsnumbers.txt
@echo 23990483750543007 >> appsnumbers.txt
@echo 3772315006174186 >> appsnumbers.txt
@echo 7144235975589978 >> appsnumbers.txt
exit /b

:_createfile
@echo 97 one.one.one.one >> dnslist.txt
@echo 96 ro.resolv.flokinet.net >> dnslist.txt
@echo 95 nl.resolv.flokinet.net >> dnslist.txt
@echo 94 dns.linuxpatch.com >> dnslist.txt
@echo 93 unicast.uncensoreddns.org >> dnslist.txt
@echo 92 dot.dns-ga.de >> dnslist.txt
@echo 91 recursor01.dns.lightningwirelabs.com >> dnslist.txt
@echo 90 recursor01.dns.ipfire.org >> dnslist.txt
@echo 89 dns3.digitalcourage.de >> dnslist.txt
@echo 88 anycast.uncensoreddns.org >> dnslist.txt
@echo 87 open.dns0.eu >> dnslist.txt
@echo 86 dns.sb >> dnslist.txt
@echo 85 anycast01.ffmuc.net >> dnslist.txt
@echo 84 p0.freedns.controld.com >> dnslist.txt
@echo 83 dns.opendns.com >> dnslist.txt
@echo 82 dns.alternate-dns.com >> dnslist.txt
@echo 81 comss.dns.controld.com >> dnslist.txt
@echo 80 dns.adguard-dns.com >> dnslist.txt
@echo 79 family.adguard-dns.com >> dnslist.txt
@echo 78 unfiltered.adguard-dns.com >> dnslist.txt
@echo 77 family-filter-dns.cleanbrowsing.org >> dnslist.txt
@echo 76 adult-filter-dns.cleanbrowsing.org >> dnslist.txt
@echo 75 security-filter-dns.cleanbrowsing.org >> dnslist.txt
@echo 74 dns.google >> dnslist.txt
@echo 73 1dot1dot1dot1.cloudflare-dns.com >> dnslist.txt
@echo 72 security.cloudflare-dns.com >> dnslist.txt
@echo 71 family.cloudflare-dns.com >> dnslist.txt
@echo 70 dns.quad9.net >> dnslist.txt
@echo 69 dns10.quad9.net >> dnslist.txt
@echo 68 dns11.quad9.net >> dnslist.txt
@echo 67 dns.switch.ch >> dnslist.txt
@echo 66 dns.futuredns.me >> dnslist.txt
@echo 65 dns.comss.one >> dnslist.txt
@echo 64 dns.east.comss.one >> dnslist.txt
@echo 63 private.canadianshield.cira.ca >> dnslist.txt
@echo 62 protected.canadianshield.cira.ca >> dnslist.txt
@echo 61 protected.canadianshield.cira.ca >> dnslist.txt
@echo 60 dot-fi.blahdns.com >> dnslist.txt
@echo 59 dot-jp.blahdns.com >> dnslist.txt
@echo 58 dot-de.blahdns.com >> dnslist.txt
@echo 57 fi.dot.dns.snopyta.org >> dnslist.txt
@echo 56 dns-dot.dnsforfamily.com >> dnslist.txt
@echo 55 odvr.nic.cz >> dnslist.txt
@echo 54 dns.alidns.com >> dnslist.txt
@echo 53 dns.cfiec.net >> dnslist.txt
@echo 52 dot.360.cn >> dnslist.txt
@echo 51 public.dns.iij.jp >> dnslist.txt
@echo 50 dot.pub >> dnslist.txt
@echo 49 101.101.101.101 >> dnslist.txt
@echo 48 dot.tiar.app >> dnslist.txt
@echo 47 jp.tiar.app >> dnslist.txt
@echo 46 dns.oszx.co >> dnslist.txt
@echo 45 dns.pumplex.com >> dnslist.txt
@echo 44 dot1.applied-privacy.net >> dnslist.txt
@echo 43 dns.decloudus.com >> dnslist.txt
@echo 42 resolver-eu.lelux.fi >> dnslist.txt
@echo 41 185.222.222.222 >> dnslist.txt
@echo 40 dnsforge.de >> dnslist.txt
@echo 39 kaitain.restena.lu >> dnslist.txt
@echo 38 dot.ffmuc.net >> dnslist.txt
@echo 37 dns.digitale-gesellschaft.ch >> dnslist.txt
@echo 36 dot.libredns.gr >> dnslist.txt
@echo 35 ibksturm.synology.me >> dnslist.txt
@echo 34 getdnsapi.net >> dnslist.txt
@echo 33 dnsovertls.sinodun.com >> dnslist.txt
@echo 32 dnsovertls1.sinodun.com >> dnslist.txt
@echo 31 unicast.censurfridns.dk >> dnslist.txt
@echo 30 anycast.censurfridns.dk >> dnslist.txt
@echo 29 dns.cmrg.net >> dnslist.txt
@echo 28 dns.larsdebruin.net >> dnslist.txt
@echo 27 dns-tls.bitwiseshift.net >> dnslist.txt
@echo 26 ns1.dnsprivacy.at >> dnslist.txt
@echo 25 ns2.dnsprivacy.at >> dnslist.txt
@echo 24 dns.bitgeek.in >> dnslist.txt
@echo 23 dns.neutopia.org >> dnslist.txt
@echo 22 privacydns.go6lab.si >> dnslist.txt
@echo 21 dot.securedns.eu >> dnslist.txt
@echo 20 dot.nl.ahadns.net >> dnslist.txt
@echo 19 dot.in.ahadns.net >> dnslist.txt
@echo 18 dot.la.ahadns.net >> dnslist.txt
@echo 17 dot.ny.ahadns.net >> dnslist.txt
@echo 16 dot.pl.ahadns.net >> dnslist.txt
@echo 15 dot.it.ahadns.net >> dnslist.txt
@echo 14 dot.es.ahadns.net >> dnslist.txt
@echo 13 dot.no.ahadns.net >> dnslist.txt
@echo 12 dot.chi.ahadns.net >> dnslist.txt
@echo 11 dot.seby.io >> dnslist.txt
@echo 10 doh.dnslify.com >> dnslist.txt
@echo 9 dns.nextdns.io >> dnslist.txt
@echo 8 anycast.dns.nextdns.io >> dnslist.txt
@echo 7 max.rethinkdns.com >> dnslist.txt
@echo 6 p1.freedns.controld.com >> dnslist.txt
@echo 5 p2.freedns.controld.com >> dnslist.txt
@echo 4 p3.freedns.controld.com >> dnslist.txt
@echo 3 doh.mullvad.net >> dnslist.txt
@echo 2 adblock.doh.mullvad.net >> dnslist.txt
@echo 1 dandelionsprout.asuscomm.com:853 >> dnslist.txt
@echo 0 dns.adguard.com >> dnslist.txt
@xcopy /R /Y dnslist.txt %temp% 1>NUL 2>&1
exit /b

:_dnsintervalswitch
set dnsint=15
rem StartRusTextBlock
set /p dnsint="Введите интервал между проверками и нажмите Enter : "
rem EndRusTextBlock
rem StartEngTextBlock
rem set /p dnsint="Enter the interval between checks and press Enter: "
rem EndEngTextBlock
if "%dnsint%"=="0" (goto _todmenu)
exit /b


:_setdnsinterval
set waitdnsb=10
set waitdnst=20
set /a waitdnssum=%waitdnsb%+%waitdnst%
exit /b

:_setchkinterval
set waitchkb=10
set waitchkt=20
set /a waitchksum=%waitchkb%+%waitchkt%
exit /b

:_resolutionfix
call :_hat
@echo.
@%verbecho%
@echo      -----------------------------
rem StartRusTextBlock
@echo       ВЫБЕРИТЕ РАЗРЕШЕНИЕ ДИСПЛЕЯ
@echo      ----------------------------
@echo.
@echo    0.  Выход из программы
@echo    M.  Выход в Главное меню
@echo.
@echo    R.  Узнать текущее разрешение
@echo.
@echo  Установить разрешение:
@echo.
@echo    A. 845 x 768
@echo    B. 1127 x 1024
@echo    C. 1408 x 1280
@echo    D. 1584 x 1440 (Default for Meta Quest 2)
@echo    E. 1690 x 1536
@echo    F. 1760 x 1680 (Default for Meta Quest 3)
@echo    G. 1920 x 1800 (Default for Meta Quest Pro)
@echo    H. 1971 x 1792
@echo    I. 2253 x 2048
@echo    J. 2816 x 2560
@echo    K. 3097 x 2816
@echo    L. 3380 x 3072
@echo    N. 3661 x 3328   [EXP]  (Только для Meta Quest 3/Pro^!)
@echo    O. 3942 x 3584   [EXP]  (Только для Meta Quest 3/Pro^!)
@echo    P. 4224 x 3840   [EXP]  (Только для Meta Quest 3/Pro^!)
@echo    Q. 4506 x 4096   [EXP]  (Только для Meta Quest 3/Pro^!)
@echo.
@echo.
@echo  Установить частоту обновления (Refresh Rate):
@echo.
@echo    S. 120 Hz
@echo    T. 90 Hz
@echo    U. 80 Hz
@echo    V. 72 Hz
@echo    X. 60 Hz
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       SELECT DISPLAY RESOLUTION
rem @echo      ----------------------------
rem @echo.
rem @echo    0.  Exit the program
rem @echo    M.  Main menu
rem @echo.
rem @echo    R.  Get current resolution
rem @echo.
rem @echo  Set resolution:
rem @echo.
rem @echo    A. 845 x 768
rem @echo    B. 1127 x 1024
rem @echo    C. 1408 x 1280
rem @echo    D. 1584 x 1440 (Default for Meta Quest 2)
rem @echo    E. 1690 x 1536
rem @echo    F. 1760 x 1680 (Default for Meta Quest 3)
rem @echo    G. 1920 x 1800 (Default for Meta Quest Pro)
rem @echo    H. 1971 x 1792
rem @echo    I. 2253 x 2048
rem @echo    J. 2816 x 2560
rem @echo    K. 3097 x 2816
rem @echo    L. 3380 x 3072
rem @echo    N. 3661 x 3328   [EXP]  (Only for Meta Quest 3/Pro^!)
rem @echo    O. 3942 x 3584   [EXP]  (Only for Meta Quest 3/Pro^!)
rem @echo    P. 4224 x 3840   [EXP]  (Only for Meta Quest 3/Pro^!)
rem @echo    Q. 4506 x 4096   [EXP]  (Only for Meta Quest 3/Pro^!)
rem @echo.
rem @echo.
rem @echo  Set refresh rate:
rem @echo.
rem @echo    S. 120 Hz
rem @echo    T. 90 Hz
rem @echo    U. 80 Hz
rem @echo    V. 72 Hz
rem @echo    X. 60 Hz
rem @echo.
rem @echo.
rem @echo.   ===================================================================
rem @echo    ^|   Increased resolution from N to Q may cause game crashes.   ^|
rem @echo    ^|   Set it only if you know exactly what you are doing!         ^|
rem @echo    ===================================================================
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _resolutionfix
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="r" (GOTO _currentres)
if /i "%choice%"=="a" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 845 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 768 && goto _resmenu)
if /i "%choice%"=="b" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1127 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1024 & goto _resmenu)
if /i "%choice%"=="c" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1408 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1280 & goto _resmenu)
if /i "%choice%"=="d" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1584 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1440 & goto _resmenu)
if /i "%choice%"=="e" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1690 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1536 & goto _resmenu)
if /i "%choice%"=="f" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1760 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1680 & goto _resmenu)
if /i "%choice%"=="g" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1920 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1800 & goto _resmenu)
if /i "%choice%"=="h" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 1971 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 1792 & goto _resmenu)
if /i "%choice%"=="i" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 2253 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 2048 & goto _resmenu)
if /i "%choice%"=="j" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 2816 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 2560 & goto _resmenu)
if /i "%choice%"=="k" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 3097 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 2816 & goto _resmenu)
if /i "%choice%"=="l" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 3380 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 3072 & goto _resmenu)
if /i "%choice%"=="n" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 3661 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 3328 & goto _resmenu)
if /i "%choice%"=="o" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 3942 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 3584 & goto _resmenu)
if /i "%choice%"=="p" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 4224 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 3840 & goto _resmenu)
if /i "%choice%"=="q" (@%MYFILES%\adb shell setprop debug.oculus.textureHeight 4502 && @%MYFILES%\adb shell setprop debug.oculus.textureWidth 4096 & goto _resmenu)
if /i "%choice%"=="s" (@%MYFILES%\adb shell setprop debug.oculus.refreshRate 120 & goto _resmenu)
if /i "%choice%"=="t" (@%MYFILES%\adb shell setprop debug.oculus.refreshRate 90 & goto _resmenu)
if /i "%choice%"=="u" (@%MYFILES%\adb shell setprop debug.oculus.refreshRate 80 & goto _resmenu)
if /i "%choice%"=="v" (@%MYFILES%\adb shell setprop debug.oculus.refreshRate 72 & goto _resmenu)
if /i "%choice%"=="x" (@%MYFILES%\adb shell setprop debug.oculus.refreshRate 60 & goto _resmenu)
call :_erlvl
cls
goto _resolutionfix
:_resmenu
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Параметры установлены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Parameters set
rem EndEngTextBlock
call :_prevmenu
cls
goto _resolutionfix

:_currentres
call :_cdc
@echo.
rem StartRusTextBlock
@echo  Текущее разрешение:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Current resolution:
rem EndEngTextBlock
@echo =====
@%MYFILES%\adb shell getprop debug.oculus.textureHeight
call :_erlvl
@echo  x
@%MYFILES%\adb shell getprop debug.oculus.textureWidth
@echo =====
rem StartRusTextBlock
@echo  [ пустые строки означают дефолтные значения ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  [ Empty lines indicate default values ]
rem EndEngTextBlock
@echo.
call :_prevmenu
cls
goto _resolutionfix

:_installmenugen
call :_checkcurlexists
:_installmenugenc
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  Запустить утилиту установки приложений Quest Install Director
@echo    B.  Запустить приложения на шлеме
@echo    C.  Узнать команду ADB для запуска приложения на шлеме
@echo    D.  Отобразить и сохранить список установленных приложений
@echo    E.  Управление приложениями на шлеме	   [EXPERIMENTAL]
echo.
@echo    V.  Установка VPN клиентов для Android
@echo    W.  Установка VPN клиентов для PC
@echo    S.  Установка медиа приложений
@echo    P.  Установка прикладных приложений
@echo    R.  Установка игровых приложений
@echo    T.  Установка утилит ADB
@echo    O.  Очистка лишних приложений
@echo.
@echo    %_fCyan%X.  Установка драйверов Meta Quest%_fReset%
@echo.
@echo.
@echo    ВАЖНО:
@echo.
@echo       Для установки приложений требуется интернет на ПК.
@echo       Если какие-то приложения не скачиваются, установите последнюю версию Quas
@echo       по ссылке: https://vrcomm.ru/files/file/7-quest-adb-scripts-quas/
@echo.
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    === Application Installation Menu ===
rem @echo.
rem @echo    A.  Run Quest Install Director utility
rem @echo    B.  Run applications on the headset
rem @echo    C.  Get ADB command to launch an application on the headset
rem @echo    D.  Show list of installed applications
rem @echo    E.  Managing applications        [EXPERIMENTAL]
rem @echo.
rem @echo    V.  VPN clients installation  (for Android)
rem @echo    W.  VPN clients installation  (for PC)
rem @echo    S.  Media applications installation
rem @echo    P.  Utility applications installation
rem @echo    R.  Gaming applications installation
rem @echo    T.  ADB tools installation
rem @echo    O.  Cleanup of unnecessary applications
rem @echo.
rem @echo    %_fCyan%X.  Install Meta Quest drivers%_fReset%
rem @echo.
rem @echo.
rem @echo    IMPORTANT:
rem @echo.
rem @echo       Internet connection on the PC is required for application installation.
rem @echo       If some applications fail to download, install the latest version of Quas
rem @echo       via the link: https://vrcomm.ru/files/file/7-quest-adb-scripts-quas/
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _installmenugen
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _installqid)
if /i "%choice%"=="b" (GOTO _StartingApps)
if /i "%choice%"=="c" (GOTO _CommandLaunchApp)
if /i "%choice%"=="d" (GOTO _ApplicationActionMenu)
if /i "%choice%"=="e" (GOTO _AppsManagementMenu)
if /i "%choice%"=="v" (GOTO _InstallVPNClientsAnd)
if /i "%choice%"=="w" (GOTO _InstallVPNClientsPC)
if /i "%choice%"=="s" (GOTO _InstallMediaApps)
if /i "%choice%"=="p" (GOTO _InstallSoftwareApps)
if /i "%choice%"=="r" (GOTO _InstallGamesApps)
if /i "%choice%"=="t" (GOTO _InstallADBTools)
if /i "%choice%"=="o" (GOTO _UninstallAndStopAppsStuffMenu)
if /i "%choice%"=="x" (GOTO _InstallMetaQuestDrivers)
@cls
goto _installmenugen


:_UninstallAndStopAppsStuffMenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo        %_fBYellow%=== МЕНЮ ОЧИСТКИ ПРИЛОЖЕНИЙ ===%_fReset%
@echo.
@echo.
@echo     A.  Отключений лишних приложений
@echo     B.  Удаление лишних приложений
@echo.
@echo.
@echo          %_fBYellow%Для удобства и самостоятельной работы со списками используйте расширенные опции:%_fReset%
@echo.
@echo     E.  Экспорт списков приложений в файлы из реестра
@echo     I.  Импорт списков приложений из файлов в реестр (%_fBYellow%с добавлением записей в реестр%_fReset%)
@echo     J.  Импорт списков приложений из файлов в реестр (%_fBYellow%с очисткой записей в реестре%_fReset%)
@echo     G.  Удаление списков из реестра
@echo     K.  Открыть ветвь реестра %_fBYellow%HKCU\SOFTWARE\Quas\%_fReset%
@echo     T.  Создать текстовые файлы со списками приложений
@echo    PU.  Выбрать и добавить в список приложения для удаления
@echo    PD.  Выбрать и добавить в список приложения для отключения
@echo.
@echo    %_fBYellow%H.  Помощь и расширенная информация%_fReset%
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fBYellow%APPLICATION CLEANUP MENU%_fReset%
rem @echo        ========================
rem @echo.
rem @echo.
rem @echo     A.  Disable unnecessary applications
rem @echo     B.  Uninstall unnecessary applications
rem @echo.
rem @echo.
rem @echo          %_fBYellow%For convenience and manual manipulation of app lists, use the advanced options:%_fReset%
rem @echo.
rem @echo     E.  Export app lists to files from the registry
rem @echo     I.  Import app lists from files into the registry (%_fBYellow%adding entries to the registry%_fReset%)
rem @echo     J.  Import app lists from files into the registry (%_fBYellow%clearing registry entries%_fReset%)
rem @echo     G.  Delete lists from the registry
rem @echo     K.  Open registry branch %_fBYellow%HKCU\SOFTWARE\Quas\%_fReset%
rem @echo     T.  Create text files with application lists
rem @echo    PU.  Select and add applications to the uninstall list
rem @echo    PD.  Select and add applications to the disable list
rem @echo.
rem @echo      %_fBYellow%H.  Help and addition information%_fReset%
rem @echo.
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _UninstallAndStopAppsStuffMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (call :_DisableAppsStuff)
if /i "%choice%"=="b" (call :_UninstallAppsStuff)
if /i "%choice%"=="e" (goto _ExportDUListsFromRegistry)
if /i "%choice%"=="h" (call :_AppsClearHelp)
if /i "%choice%"=="i" (set mode=ADD&&goto _ImportDUListsToRegistry)
if /i "%choice%"=="j" (set mode=RESET&&goto _ImportDUListsToRegistry)
if /i "%choice%"=="g" (goto _DeleteDUListsFromRegistry)
if /i "%choice%"=="k" (goto :_MQDHOpenRegistry)
if /i "%choice%"=="t" (goto :_CreateUninstDisabletTxtLists)
if /i "%choice%"=="pu" (set inputlist=uninst_list.txt&& call :_UninstDisableAllAppsListCreate&& call :_UninstallAppsAdd)
if /i "%choice%"=="pd" (set inputlist=disabled_list.txt&& call :_UninstDisableAllAppsListCreate&& call :_DisableAppsAdd)
goto _UninstallAndStopAppsStuffMenu

:_AppsClearHelp
cls
@echo.
@echo.
rem StartRusTextBlock
@echo    При использовании пунктов %_fBYellow%A%_fReset% и %_fBYellow%B%_fReset% в окно выбора будет выведен небольшой список приложений,
@echo    которые можно безопасно отключить или удалить. Действие и список зависят от пункта меню.
@echo.
@echo    Списки могут быть сохранены как в текстовые файлы, так и в реестр. Вы также можете
@echo    импортировать списки из файла в реестр или экспортировать их из реестра в текстовые файлы.
@echo    Опция %_fBYellow%T%_fReset% сохранит в текстовые файлы списки, интегрированные в программу %_fBYellow%Quas%_fReset%.
@echo.
@echo    Вы можете сделать свой собственный список удаления или остановки приложений, для этого
@echo    создайте текстовый файл в формате "%_fCyan%имя приложения%_fReset%%_fYellow%;%_fBCyan%название пакета%_fReset%" без кавычек, например:
@echo.
@echo    %_fCyan%Meta Worlds%_fReset%;%_fBCyan%com.meta.worlds%_fReset%
@echo    %_fCyan%Facebook%_fReset%;%_fBCyan%com.facebook.horizon%_fReset%
@echo    %_fCyan%Instagram%_fReset%;%_fBCyan%com.oculus.igvr%_fReset%
@echo    %_fCyan%WhatsUp%_fReset%;%_fBCyan%com.whatsapp%_fReset%
@echo.
@echo    %_fBYellow%Обратите внимание:%_fReset% между именем пакета и названием приложения - %_fYellow%точка с запятой%_fReset%. Формат списков
@echo    одинаковый. Список для удаления приложений должен называться %_fYellow%uninst_list.txt%_fReset%, а список для 
@echo    остановки приложений - %_fYellow%disabled_list.txt%_fReset%. Имя приложения может быть любым, какое вам удобно.
@echo    Название пакета как у соответствующего приложения. Списки сохраните рядом с программой %_fBYellow%Quas%_fReset%.
@echo.
@echo    Для включения отключенных приложений пройдите в программе %_fBYellow%Quas%_fReset% в пункты %_fBYellow%J-E-E-4%_fReset%
@echo    затем выберите приложения, которые хотите включить. Установить удаленные приложения можно
@echo    на %_fBYellow%Главной панели%_fReset% шлема, нажав на плитку приложения, и затем - %_fBYellow%Скачать%_fReset%.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.
rem @echo.
rem @echo    When using options %_fBYellow%A%_fReset% and %_fBYellow%B%_fReset%, a small list of apps that can be safely disabled or uninstalled
rem @echo    will be displayed in the selection window. The action and the list depend on the menu option.
rem @echo.
rem @echo    The lists can be saved as text files or in the registry. You can also import lists from a file
rem @echo    into the registry or export them from the registry to text files. Option %_fBYellow%T%_fReset%
rem @echo    will save the integrated lists in text files in the %_fBYellow%Quas%_fReset% program.
rem @echo.
rem @echo    You can create your own list of apps to uninstall or stop by creating a text file in the format
rem @echo    "%_fCyan%App Name%_fReset%%_fYellow%;%_fBCyan%Package Name%_fReset%" without quotes, for example:
rem @echo.
rem @echo    %_fCyan%Meta Worlds%_fReset%;%_fBCyan%com.meta.worlds%_fReset%
rem @echo    %_fCyan%Facebook%_fReset%;%_fBCyan%com.facebook.horizon%_fReset%
rem @echo    %_fCyan%Instagram%_fReset%;%_fBCyan%com.oculus.igvr%_fReset%
rem @echo    %_fCyan%WhatsUp%_fReset%;%_fBCyan%com.whatsapp%_fReset%
rem @echo.
rem @echo    %_fBYellow%Note:%_fReset% there is a %_fYellow%semicolon%_fReset% between the app name and package name. 
rem @echo    The list format is the same. The uninstall list should be named %_fYellow%uninst_list.txt%_fReset%, and the
rem @echo    disable list - %_fYellow%disabled_list.txt%_fReset%. The app name can be anything you like, and the package
rem @echo    name should match the corresponding app. Save the lists next to the %_fBYellow%Quas%_fReset% program.
rem @echo.
rem @echo    To enable disabled apps, go to %_fBYellow%Quas%_fReset% in options %_fBYellow%J-E-E-4%_fReset%, 
rem @echo    then select the apps you want to enable. To install removed apps, use the %_fBYellow%Main Panel%_fReset% 
rem @echo    on the headset, click the app tile, and then select %_fBYellow%Download%_fReset%.
rem EndEngTextBlock
call :_prevmenu
exit /b

:_UninstallAppsStuff
setlocal enableextensions enabledelayedexpansion
rem StartRusTextBlock
set "action1=удалить"
set "action2=удаления"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to uninstall"
rem set "action2=uninstalling"
rem EndEngTextBlock
call :_ActionMessage
if not exist uninst_list.txt call :_UninstListCreate
powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "uninst_list.txt" "packages-list.txt"
if not exist packages-list.txt (
@echo.
@echo   --------------------------------------------
@echo.
rem StartRusTextBlock
@echo   %_fYellow%+++  Приложения не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No apps selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
exit /b
)
rem ====================================

for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set abname=%%a
set packagename=%%b
@echo   -------------------------------------------------------------------
rem StartRusTextBlock
@echo   = Название архива	: %_fBCyan%!abname!%_fReset%
@echo   = Название пакета	: %_fCyan%!packagename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Archive name	: %_fBCyan%!abname!%_fReset%
rem @echo   = Package name	: %_fCyan%!packagename!%_fReset%
rem EndEngTextBlock

%MYFILES%\adb shell pm list packages | findstr /I "!packagename!" 1>nul 2>nul
if !errorlevel!==1 (
rem StartRusTextBlock
@echo   %_fBYellow%= Приложение уже удалено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= The application already deleted%_fReset%
rem EndEngTextBlock
) else (
%MYFILES%\adb shell pm uninstall -k --user 0 !packagename! | findstr /I "DELETE_FAILED_INTERNAL_ERROR"  1>nul 2>nul
rem %MYFILES%\adb shell pm uninstall !packagename! 1>nul 2>nul
%MYFILES%\adb shell pm list packages | findstr /I "!packagename!" 1>nul 2>nul
if !errorlevel!==0 (
rem StartRusTextBlock
@echo   %_fBRed%= Не удалось удалить приложение%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%= Failed to uninstall the application%_fReset%
@echo !packagename! >>NotUninstalledApps.txt
rem EndEngTextBlock
) else (
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение удалено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= App uninstalled%_fReset%
@echo !packagename! >>UninstalledApps.txt
rem EndEngTextBlock
)
)
)
@echo   -------------------------------------------------------------------
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f uninst_list.txt 1>nul 2>nul
rem StartRusTextBlock
@echo   %_fBGreen%= Приложения удалены%_fReset%
@echo     %_fBYellow%Список не удаленных приложений в файле %_fYellow%NotUninstalledApps.txt%_fReset%
@echo     %_fBYellow%Удаленные приложения записаны в файле %_fYellow%UninstalledApps.txt%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Apps uninstalled%_fReset%
rem @echo     %_fBYellow%List of applications not uninstalled is in the file %_fYellow%NotUninstalledApps.txt%_fReset%
rem @echo     %_fBYellow%Uninstalled applications are recorded in the file %_fYellow%UninstalledApps.txt%_fReset%
rem EndEngTextBlock
@echo   -------------------------------------------------------------------
call :_prevmenu
exit /b

:_DisableAppsStuff
rem StartRusTextBlock
set "action1=отключить"
set "action2=отключения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to disable"
rem set "action2=disabling"
rem EndEngTextBlock
call :_ActionMessage
if not exist disabled_list.txt call :_DisabledListCreate
powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "disabled_list.txt" "packages-list.txt"
if not exist packages-list.txt (
@echo.
@echo   --------------------------------------------
@echo.
rem StartRusTextBlock
@echo        %_fYellow%+++  Приложения не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fYellow%+++  No apps selected  +++%_fReset%
rem EndEngTextBlock
call :_prevmenu
exit /b
)
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set abname=%%a
set packagename=%%b
@echo   -------------------------------------------------------------------
rem StartRusTextBlock
@echo   = Название архива	: %_fBCyan%!abname!%_fReset%
@echo   = Название пакета	: %_fCyan%!packagename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Archive name	: %_fBCyan%!abname!%_fReset%
rem @echo   = Package name	: %_fCyan%!packagename!%_fReset%
rem EndEngTextBlock
%MYFILES%\adb shell am force-stop !packagename! 1>nul 2>nul
%MYFILES%\adb shell pm disable-user --user 0 !packagename! 1>nul 2>nul
%MYFILES%\adb shell pm list packages -d | findstr /I "!packagename!" 1>nul 2>nul
if %errorlevel%==0 (
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение отключено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= App disabled%_fReset%
rem EndEngTextBlock
) else (
rem StartRusTextBlock
@echo   %_fBRed%= Не удалось отключить приложение%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%= Failed to disable the application%_fReset%
rem EndEngTextBlock
@echo !packagename! >>NotDisabled.txt
)
@echo   -------------------------------------------------------------------
)
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f disabled_list.txt 1>nul 2>nul
rem StartRusTextBlock
@echo   %_fBGreen%= Приложения отключены%_fReset%
@echo     %_fBYellow%Список не отключенных приложений в файле %_fYellow%NotDisabled.txt%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Apps disabled%_fReset%
rem @echo     %_fBYellow%List of applications not disabled is in the file %_fYellow%NotDisabled.txt%_fReset%
rem EndEngTextBlock
@echo   -------------------------------------------------------------------
call :_prevmenu
exit /b

:_CreateUninstDisabletTxtLists
call :_UninstListCreate
call :_DisabledListCreate
@echo   ---------------------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%Списки сформированы успешно
@echo   %_fBYellow%Список приложений для отключения: %_fYellow%disabled_list.txt%_fReset%
@echo   %_fBYellow%Список приложений для удаления: %_fYellow%uninst_list.txt%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%The lists have been successfully created
rem @echo   %_fBYellow%List of applications to disable: %_fYellow%disabled_list.txt%_fReset%
rem @echo   %_fBYellow%List of applications to uninstall: %_fYellow%uninst_list.txt%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto :_UninstallAndStopAppsStuffMenu


:_UninstDisableAllAppsListCreate
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f uninst.txt 1>nul 2>nul
@del /q /f disabled_list.txt 1>nul 2>nul
@del /q /f o.txt 1>nul 2>nul
@del /q /f aaptname.sh 1>nul 2>nul
@echo   ---------------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%Минутку, формируется список всех приложений...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%One moment, the list of all applications is being generated...%_fReset%
rem EndEngTextBlock
set listpackages=-a
set outputfile=%inputlist%
rem call :_AppsInstallMenu
call :_AppsSourceListCreate
exit /b


:_UninstallAppsAdd
setlocal enableextensions enabledelayedexpansion
rem StartRusTextBlock
set "action1=добавить"
set "action2=добавления"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to uninstall"
rem set "action2=uninstalling"
rem EndEngTextBlock
call :_ActionMessage
if not exist uninst_list.txt call :_UninstListCreate
powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "%inputlist%" "packages-list.txt"
if not exist packages-list.txt (
@echo.
@echo   --------------------------------------------
@echo.
rem StartRusTextBlock
@echo   %_fYellow%+++  Приложения не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No apps selected  +++%_fReset%
rem EndEngTextBlock
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f uninst.txt 1>nul 2>nul
@del /q /f disabled_list.txt 1>nul 2>nul
@del /q /f o.txt 1>nul 2>nul
@del /q /f aaptname.sh 1>nul 2>nul
call :_prevmenu
exit /b
)
set mode=ADD
set UNINST=packages-list.txt
call :_ImportDUListsToRegistryProcessC "UninstalledApps" "%UNINST%"
rem StartRusTextBlock
@echo   -------------------------------
@echo   %_fBGreen%Приложения добавлены в реестр в список удаления%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%Apps added to the registry to uninstall list%_fReset%
rem EndEngTextBlock
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f uninst.txt 1>nul 2>nul
@del /q /f disabled_list.txt 1>nul 2>nul
@del /q /f o.txt 1>nul 2>nul
@del /q /f aaptname.sh 1>nul 2>nul
call :_prevmenu
exit /b
goto _UninstallAndStopAppsStuffMenu


:_DisableAppsAdd
setlocal enableextensions enabledelayedexpansion
rem StartRusTextBlock
set "action1=добавить"
set "action2=добавления"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "action1=to uninstall"
rem set "action2=uninstalling"
rem EndEngTextBlock
call :_ActionMessage
if not exist uninst_list.txt call :_UninstListCreate
powershell -ExecutionPolicy Bypass -File "%myfiles%\selector4.ps1" "%inputlist%" "packages-list.txt"
if not exist packages-list.txt (
@echo.
@echo   --------------------------------------------
@echo.
rem StartRusTextBlock
@echo   %_fYellow%+++  Приложения не выбраны  +++%_fReset%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%+++  No apps selected  +++%_fReset%
rem EndEngTextBlock
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f uninst.txt 1>nul 2>nul
@del /q /f disabled_list.txt 1>nul 2>nul
@del /q /f o.txt 1>nul 2>nul
@del /q /f aaptname.sh 1>nul 2>nul
call :_prevmenu
exit /b
)
set mode=ADD
set DISABLED=packages-list.txt
call :_ImportDUListsToRegistryProcessC "DisabledApps" "%DISABLED%"

rem StartRusTextBlock
@echo   -------------------------------
@echo   %_fBGreen%Приложения добавлены в реестр в список отключения%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%Apps added to the registry to disable list%_fReset%
rem EndEngTextBlock
@del /q /f packages-list.txt 1>nul 2>nul
@del /q /f uninst.txt 1>nul 2>nul
@del /q /f disabled_list.txt 1>nul 2>nul
@del /q /f o.txt 1>nul 2>nul
@del /q /f aaptname.sh 1>nul 2>nul
call :_prevmenu
exit /b
goto _UninstallAndStopAppsStuffMenu


:_UninstListCreate
set ul=uninst_list.txt
> "%ul%" echo Facebook;com.oculus.facebook
>> "%ul%" echo First Encounter;com.meta.curio.toybox
>> "%ul%" echo Gallery;com.oculus.hzosgallery
>> "%ul%" echo Guidebook;com.oculus.guidebook
>> "%ul%" echo Help and Tips;com.oculus.helpcenter
>> "%ul%" echo Instagram;com.oculus.igvr
>> "%ul%" echo Layout;com.meta.curio.ruler
>> "%ul%" echo Remote Desktop;com.oculus.remotedesktop
>> "%ul%" echo Theater ElseWhere;com.facebook.arvr.quillplayer
>> "%ul%" echo Oculus TV;com.oculus.tv
>> "%ul%" echo WhatsUp;com.whatsapp
>> "%ul%" echo Messenger;com.facebook.orca
>> "%ul%" echo ##Horizon Central;com.meta.shell.env.vista.central
exit /b



:_DisabledListCreate
set dl=disabled_list.txt
> "%dl%" echo Meta Worlds;com.meta.worlds
>> "%dl%" echo Facebook Horizon;com.facebook.horizon
>> "%dl%" echo OTA Updater;com.oculus.nux.ota
>> "%dl%" echo Quest for Business;com.oculus.q4b.mdm
>> "%dl%" echo Oculus TV;com.oculus.tv
>> "%dl%" echo AvatarEditor;com.oculus.avatareditor
>> "%dl%" echo Calendar Storage;com.android.providers.calendar
>> "%dl%" echo Chats;com.oculus.socialplatform
>> "%dl%" echo Download Manager;com.android.providers.downloads
>> "%dl%" echo FirstTimeNux;com.oculus.firsttimenux
>> "%dl%" echo Horizon Feed;com.oculus.explore
>> "%dl%" echo Messenger;com.facebook.orca
>> "%dl%" echo Meta Remote Desktop Streaming Service;com.oculus.mrds
>> "%dl%" echo Meta AI Service;com.oculus.assistant
>> "%dl%" echo Phone Calls;com.android.server.telecom
>> "%dl%" echo Remote Desktop;com.oculus.remotedesktop
>> "%dl%" echo Tethering;com.android.networkstack.tethering
>> "%dl%" echo Facebook;com.oculus.facebook
>> "%dl%" echo First Encounter;com.meta.curio.toybox
>> "%dl%" echo Gallery;com.oculus.hzosgallery
>> "%dl%" echo Guidebook;com.oculus.guidebook
>> "%dl%" echo Help and Tips;com.oculus.helpcenter
>> "%dl%" echo Instagram;com.oculus.igvr
>> "%dl%" echo Layout;com.meta.curio.ruler
>> "%dl%" echo Remote Desktop;com.oculus.remotedesktop
>> "%dl%" echo Theater ElseWhere;com.facebook.arvr.quillplayer
>> "%dl%" echo WhatsUp;com.whatsapp
exit /b

:_ActionMessage
rem StartRusTextBlock
@echo  ------------------------------------
@echo  %_fBYellow%В открывшемся окне выберите приложения, которые хотите %action1%. После завершения выбора
@echo  нажмите кнопку %_fYellow%Confirm %_fBYellow%для %action2%. Для отмены нажмите кнопку %_fYellow%Cancel.
@echo.
@echo  %_fBYellow%Для поиска приложений по имени или названию пакета используйте поле в верхней части окна.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  In the window that opens, select the applications you want %action1%. After making your selection,
rem @echo  click the %_fYellow%Confirm %_fBYellow%button %action2%. To cancel click the %_fYellow%Cancel %_fBYellow%button.
rem @echo.
rem @echo  Use the field at the top of the window to search for applications by name or package name.%_fReset%
rem EndEngTextBlock
exit /b

:_ExportDUListsFromRegistry
rem Ok
set DISABLED=disabled_list.txt
set UNINST=uninst_list.txt
set REGTMP=quas_export.reg
call :_ExportDUListsFromRegistryProcess DisabledApps "%DISABLED%"
call :_ExportDUListsFromRegistryProcess UninstalledApps "%UNINST%"
del "%REGTMP%" >nul 2>&1
rem StartRusTextBlock
@echo   %_fBYellow%Списки сохранены в файлах %_fYellow%disabled_list.txt %_fBYellow%и %_fYellow%uninst_list.txt
@echo   %_fBYellow%Если такие файлы отсутствуют, значит списков в реестре нет.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%The lists have been saved to the files %_fYellow%disabled_list.txt %_fBYellow%and %_fYellow%uninst_list.txt
rem @echo   %_fBYellow%If these files are missing, it means there are no lists in the registry.%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _UninstallAndStopAppsStuffMenu

:_ExportDUListsFromRegistryProcess
rem Ok
set SECTION=%~1
set OUTFILE=%~2
set KEY=HKEY_CURRENT_USER\SOFTWARE\Quas\%SECTION%

> "%OUTFILE%" rem.

del "%REGTMP%" >nul 2>&1
reg export "%KEY%" "%REGTMP%" /y 1>nul 2>nul || exit /b

for /f "delims=" %%L in ('
    type "%REGTMP%" ^| findstr /R "^\""
') do (
    for /f "tokens=1,2 delims==" %%A in ("%%L") do (
        >>"%OUTFILE%" echo %%~A;%%~B
    )
)

:: проверяем, пустые ли файлы, и удаляем если пустые

for %%F in ("%DISABLED%" "%UNINST%") do (
    if exist "%%F" (
        if %%~zF==0 del "%%F"
    )
)

exit /b

:_ImportDUListsToRegistry
rem Ok
set DISABLED=disabled_list.txt
set UNINST=uninst_list.txt

if not exist "%DISABLED%" if not exist "%UNINST%" (
@echo   ----------------------------------------------------------------
rem StartRusTextBlock
@echo    %_fBRed%Файлы отсутствуют, невозможно импортировать данные в реестр%_fReset%
@echo    %_fBYellow%Сначала сформируйте файлы из пункта %_fYellow%T%_fBYellow% меню.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBRed%Both files are missing, unable to import data into the registry%_fReset%
rem @echo    %_fBYellow%First generate the files using menu option %_fYellow%T%_fBYellow%.%_fReset%
rem EndEngTextBlock
@echo   ----------------------------------------------------------------
call :_prevmenu
goto _UninstallAndStopAppsStuffMenu

)

if not exist "%DISABLED%" (
@echo   --------------------------------------------------
rem StartRusTextBlock
@echo    %_fBYellow%Файл %_fYellow%disabled_list.txt %_fBYellow%отсутствует — %_fBRed%пропускаем%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%File %_fYellow%disabled_list.txt %_fBYellow%is missing — %_fBRed%skipping%_fReset%
rem EndEngTextBlock
@echo   --------------------------------------------------

)

if not exist "%UNINST%" (
@echo   --------------------------------------------------
rem StartRusTextBlock
@echo    %_fBYellow%Файл %_fYellow%uninst_list.txt %_fBYellow%отсутствует — %_fBRed%пропускаем%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%File %_fYellow%uninst_list.txt %_fBYellow%is missing — %_fBRed%skipping%_fReset%
rem EndEngTextBlock
@echo   --------------------------------------------------
)


if "%mode%"=="ADD" goto _ImportDUListsToRegistryProcess
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения очистки списка в реестре нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For registry list cleaning confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto _UninstallAndStopAppsStuffMenu
if "!KEY!"=="13" goto _ImportDUListsToRegistryProcess
goto _UninstallAndStopAppsStuffMenu


:_ImportDUListsToRegistryProcess
rem Ok
call :_ImportDUListsToRegistryProcessC "DisabledApps" "%DISABLED%"
call :_ImportDUListsToRegistryProcessC "UninstalledApps" "%UNINST%"

rem StartRusTextBlock
@echo   -------------------------------
@echo   %_fBGreen%Импорт файлов в реестр выполнен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%Import of files into the registry completed%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _UninstallAndStopAppsStuffMenu

:_ImportDUListsToRegistryProcessC
rem Ok
set SECTION=%~1
set FILE=%~2
set REGKEY=HKCU\SOFTWARE\Quas\%SECTION%
rem --- создать ключ (если нет)
reg add "%REGKEY%" /f >nul

rem --- очистка, если RESET
if "%MODE%"=="RESET" (
reg delete "%REGKEY%" /va /f 1>nul 2>nul
)

rem --- добавление значений
if exist "%FILE%" (
for /f "usebackq tokens=1,2 delims=;" %%A in ("%FILE%") do (
if not "%%A"=="" (
reg add "%REGKEY%" /v "%%A" /t REG_SZ /d "%%B" /f 1>nul 2>nul
)
)
)
exit /b


:_DeleteDUListsFromRegistry
rem Ok
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения удаления списков в реестре нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For registry list deleting confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto _UninstallAndStopAppsStuffMenu
if "!KEY!"=="13" goto :_DeleteDUListsFromRegistryProcess
goto _UninstallAndStopAppsStuffMenu

:_DeleteDUListsFromRegistryProcess
reg delete "HKCU\SOFTWARE\Quas\DisabledApps" /f 1>nul 2>nul
reg delete "HKCU\SOFTWARE\Quas\UninstalledApps" /f 1>nul 2>nul
@echo  --------------------------
rem StartRusTextBlock
@echo    %_fBGreen%Разделы реестра удалены%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBGreen%Registry sections removed%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _UninstallAndStopAppsStuffMenu


:_MQDHOpenRegistry
powershell -ExecutionPolicy Bypass -Command "Stop-Process -Name regedit -ErrorAction SilentlyContinue; $path = 'HKCU\SOFTWARE\Quas'; Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit' -Name 'LastKey' -Value $path; Start-Process regedit"
goto _UninstallAndStopAppsStuffMenu


:_InstallMetaQuestDrivers
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo      %_fBYellow%=== Установка драйверов Meta Horizon (Quest) на ПК ===%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%=== Installation Meta Horizon (Quest) Drivers to PC ===%_fReset%
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  Установить версию %_fCyan%1.71  %_fBYellow%(Старые драйверы Oculus)%_fReset%
@echo    B.  Установить версию %_fCyan%1.72  %_fBYellow%(Новые драйверы Reality Labs)%_fReset%
@echo    C.  Установить версию %_fCyan%1.77  %_fBYellow%(Переработанные драйверы Reality Labs)%_fReset%
@echo.
@echo    F.  Скачать версию %_fCyan%1.71%_fReset%
@echo    G.  Скачать версию %_fCyan%1.72%_fReset%
@echo    I.  Скачать версию %_fCyan%1.77%_fReset%
@echo.
@echo.
@echo.
@echo      %_fBYellow%ВАЖНО:%_fReset%
@echo.
@echo    Версия %_fCyan%1.71%_fReset% - устаревшая, но популярная версия драйверов Oculus.
@echo                  Они все еще подходят для многих устройств. %_fBYellow%Оставлены для совместимости.%_fReset%
@echo.
@echo    Версия %_fCyan%1.72%_fReset% - новая версия драйверов, включающая в себя устройства %_fBYellow%Highwind%_fReset% и %_fBYellow%Commlib%_fReset%
@echo                  %_fBYellow%Рекомендуется устанавливать именно ее, если прошивка на шлеме достаточно новая.%_fReset%
@echo.
@echo    Версия %_fCyan%1.77%_fReset% - обновленная версия, включающая в себя устройства из всех предыдущих версий
@echo                  и несколько новых устройств, пока не выпущенных. %_fBYellow%Возможны баги.%_fReset%
@echo.
@echo    %_fBYellow%Следует иметь в виду, что эти драйверы (%_fYellow%кроме 1.71%_fReset%)%_fBYellow% - не замена драйверам из комплекта
@echo    %_fYellow%Meta Horizon Link^^! %_fBYellow%Они не поддерживают звуковые устройства шлема. Используйте их
@echo    только для подключения гарнитуры к ПК по ADB.%_fReset%
@echo.
@echo    Если по какой-то причине драйверы не устанавливаются, вы можете скачать их
@echo    и установить вручную, ПКМ на файле %_fBYellow%android_winusb.inf%_fReset% - %_fBYellow%Установить.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Install version %_fCyan%1.71  %_fBYellow%(Old Oculus drivers)%_fReset%
rem @echo    B.  Install version %_fCyan%1.72  %_fBYellow%(New Reality Labs drivers)%_fReset%
rem @echo    C.  Install version %_fCyan%1.77  %_fBYellow%(Reworked Reality Labs drivers)%_fReset%
rem @echo.
rem @echo    F.  Download version %_fCyan%1.71%_fReset%
rem @echo    G.  Download version %_fCyan%1.72%_fReset%
rem @echo    I.  Download version %_fCyan%1.77%_fReset%
rem @echo.
rem @echo.
rem @echo.
rem @echo      %_fBYellow%IMPORTANT:%_fReset%
rem @echo.
rem @echo    Version %_fCyan%1.71%_fReset% is outdated, but still the most popular driver version.
rem @echo                  It works for most devices. %_fBYellow%Kept for compatibility.%_fReset%
rem @echo.
rem @echo    Version %_fCyan%1.72%_fReset% is a new driver version that includes %_fBYellow%Highwind%_fReset% and %_fBYellow%Commlib%_fReset% devices.
rem @echo                  %_fBYellow%Recommended if the headset firmware is sufficiently up to date.%_fReset%
rem @echo.
rem @echo    Version %_fCyan%1.77%_fReset% is an updated version that includes devices from all previous versions
rem @echo                  as well as several new, not yet released devices. %_fBYellow%Bugs are possible.%_fReset%
rem @echo.
rem @echo    %_fBYellow%Please note that these drivers (%_fYellow%except 1.71%_fReset%)%_fBYellow% are NOT a replacement for the drivers included with
rem @echo    %_fYellow%Meta Horizon Link^^! %_fBYellow%They do not support the headset’s audio devices. Use them
rem @echo    only to connect the headset to a PC via ADB.%_fReset%
rem @echo.
rem @echo    If for some reason the drivers fail to install, you can download them
rem @echo    and install them manually: right-click the file %_fBYellow%android_winusb.inf%_fReset% → %_fBYellow%Install.%_fReset%
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallMetaQuestDrivers
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _setdrivers)
if /i "%choice%"=="b" (GOTO _setdriversmh172)
if /i "%choice%"=="c" (GOTO _setdriversmh177)
if /i "%choice%"=="f" (GOTO _driversdownload171)
if /i "%choice%"=="g" (GOTO _driversdownload172)
if /i "%choice%"=="i" (GOTO _driversdownload177)

@cls
goto _InstallMetaQuestDrivers


:_AppsManagementMenu
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       МЕНЮ УПРАВЛЕНИЯ ПРИЛОЖЕНИЯМИ
@echo       ============================
@echo.
@echo.
@echo    A.  Удаление приложений		
@echo    B.  Мягкое удаление приложений (кэш и данные не удаляются)
@echo    C.  Очистка кэша и данных приложений
@echo    D.  Отключение приложений
@echo    E.  Включение приложений
@echo    F.  Запуск приложения
@echo    G.  Остановка приложения
@echo    I.  Перезапуск приложения
@echo    J.  Просмотр статуса приложения
@echo    K.  Просмотр запущенных приложений
@echo    L.  Сохранить в файл список выбранных приложений
@echo.
@echo    %_fBYellow%H.  Помощь по опциям%_fReset%
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        APPLICATION MANAGEMENT MENU
rem @echo       ============================
rem @echo.
rem @echo.
rem @echo    A.  Uninstall applications		
rem @echo    B.  Soft uninstall of applications (cache and data are not deleted)
rem @echo    C.  Clear application cache and data
rem @echo    D.  Disable applications
rem @echo    E.  Enable applications
rem @echo    F.  Start application
rem @echo    G.  Stop application
rem @echo    I.  Restart app
rem @echo    J.  Apps status view
rem @echo    K.  View running apps
rem @echo    L.  Save List of Installed Applications to File
rem @echo.
rem @echo    H.  Help

rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _AppsManagementMenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (goto _UninstallAppsPS)
if /i "%choice%"=="b" (goto _SoftUninstallAppsPS)
if /i "%choice%"=="c" (goto _ClearCacheDataAppsPS)
if /i "%choice%"=="d" (goto _DisableAppsPS)
if /i "%choice%"=="dd" (goto _DisableAppsPS)
if /i "%choice%"=="e" (goto _EnableAppsPS)
if /i "%choice%"=="f" (goto _StartAppPS)
if /i "%choice%"=="g" (goto _StopAppPS)
if /i "%choice%"=="gg" (goto _StopAppPS)
if /i "%choice%"=="i" (goto _RestartAppsPS)
if /i "%choice%"=="j" (goto _ViewAppStatusPS)
rem if /i "%choice%"=="k" (goto _ViewRunningAppsPS)
if /i "%choice%"=="k" (set appsrunninglist=1&&goto :_ListRunningAppsPS)
if /i "%choice%"=="l" (Set "SelectorParameters=-txt"&&goto _ViewApplicatrionList)
if /i "%choice%"=="lc" (Set "SelectorParameters=-csv"&&goto _ViewApplicatrionList)

if /i "%choice%"=="h" (call :_AppsManagementHelp)

@cls
goto _AppsManagementMenu


:_AppsManagementHelp
cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo   Принцип работы в этом меню одинаков для всех опций:
@echo.
@echo   1. Выбираем желаемую опцию, например %_fBYellow%A. Удаление приложений.%_fReset%
@echo   2. В следующем окне выбираем категорию этих приложений - %_fBYellow%Системные, Неофициальные%_fReset% и т.д.
@echo   3. После этого появится список приложений, установленных на шлеме в этой категории
@echo      %_fBYellow%(можно использовать поиск по имени приложения или названию пакета в верхней части окна)%_fReset%
@echo   4. Отмечаем галками нужные приложения (или выбираем все - %_fBYellow%Select All%_fReset%) и жмем кнопку %_fBYellow%Confirm%_fReset%
@echo   5. Все выбранные приложения будут удалены.
@echo.
@echo   Почти все названия опций говорят сами за себя. Вот описание некоторых из них:%_fReset%
@echo.   
@echo   %_fBGreen%Опция Просмотр статуса приложений %_fReset%показывает такие параметры приложения:
@echo       %_fBYellow%Установленное
@echo       Скрытое или видимое
@echo       В спящем режиме или нет
@echo       Остановленное
@echo       Запущенное или остановленное
@echo       Включено или нет
@echo       Виртуальное или физическое
@echo.
@echo   %_fBGreen%Опция Просмотр запущенных приложений %_fReset%покажет список всех запущенных приложений
@echo   из выбранной категории. Выбирайте все приложения (%_fBYellow%Select All%_fReset%) чтобы отобразить полный список.
@echo.
@echo   %_fBGreen%Опция Сохранить в файл список выбранных приложений%_fReset% сохраняет в текстовый файл выбранные
@echo   приложения. Если требуется сохранить данные не в %_fBYellow%txt%_fReset%, а в формате %_fBYellow%csv%_fReset%, при выборе пункта
@echo   введите две буквы. Первая буква - пункт меню, вторая - С. То есть - %_fBYellow%lc
@echo.
@echo   %_fReset%В графическом окне выбора приложений можно копировать в буфер имена приложений и пакетов.
@echo   Для этого дважды кликните мышью на имя или выделите его, наведите курсор и нажмите %_fReset%Ctrl+C%_fBYellow%%_fReset%.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fReset%The working principle in this menu is the same for all options:%_fReset%
rem @echo.
rem @echo   1. Select the desired option, for example %_fBYellow%A. Remove applications.%_fReset%
rem @echo   2. Then select the category of these applications - %_fBYellow%System, Unofficial%_fReset%, etc.
rem @echo   3. After this, a list of applications installed on the headset in this category will appear
rem @echo      %_fBYellow%(you can use search by application name or package name at the top of the window)%_fReset%
rem @echo   4. Checkmark the desired applications (or select all - %_fBYellow%Select All%_fReset%) and click the %_fBYellow%Confirm%_fReset% button
rem @echo   5. All selected applications will be removed.
rem @echo.
rem @echo   Almost all option names are self-explanatory. Here is a description of some of them:%_fReset%
rem @echo.   
rem @echo   %_fBGreen%Option View application status %_fReset%shows such application parameters:%_fReset%
rem @echo       %_fBYellow%Installed
rem @echo       Hidden or visible
rem @echo       In sleep mode or not
rem @echo       Stopped
rem @echo       Running or stopped
rem @echo       Enabled or not
rem @echo       Virtual or physical
rem @echo.
rem @echo   %_fBGreen%Option View running applications %_fReset%will show a list of all running applications
rem @echo   from the selected category. Select all applications (%_fBYellow%Select All%_fReset%) to display the complete list.%_fReset%
rem @echo.
rem @echo   %_fBGreen%Option Save selected applications to file%_fReset% saves the chosen applications to a text file. To save
rem @echo   in %_fBYellow%csv%_fReset% format, enter this option with two letters - "%_fBYellow%kc%_fReset%", without quotes.%_fReset% In the graphical
rem @echo   application selection window, you can copy application and package names to the clipboard.
rem @echo   To do this, double-click on the name or select it, hover the cursor, and press %_fReset%Ctrl+C%_fBYellow%%_fReset%.
rem EndEngTextBlock
call :_exitwindow
exit /b

:_checkcurlexists
@%verbecho%
@curl.exe 1>nul 2>nul
if %errorlevel%==2 exit /b
rem StartRusTextBlock
rem @echo   =======================================================================================
@echo     %_fBRed%+++ Curl отсутствует в операционной системе, установка приложений невозможна +++%_FReset%
rem @echo   =======================================================================================
@echo   %_fBYellow%Скачайте curl по этой ссылке:   %_fCyan%https://curl.se/windows/latest.cgi?p=win64-mingw.zip
@echo   %_fBYellow%и распакуйте его в каталог Windows. Затем перезапустите эту программу.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   =================================================================================================
rem @echo   ^|  +++ Curl is missing from the operating system, application installation is impossible  +++  ^|
rem @echo   =================================================================================================
rem @echo.
rem @echo.
rem @echo   Download the curl this link:   https://curl.se/windows/latest.cgi?p=win64-mingw.zip
rem @echo   and extract it to Windows directory. After then restart the program.
rem EndEngTextBlock
call :_prevmenu
goto _installmenugenc



:_InstallGamesApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      === Установка игровых приложений ===
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      === Installation of Games Applications ===
rem EndEngTextBlock
@echo.
@echo.
@echo    A.  = qLoader
@echo    B.  = Rookie Sideloader
@echo    C.  = ARMGDDN Browser
@echo    E.  = VRP Essentials
@echo    F.  = YAAS

@echo.
@echo    I.  = ARMGDDN Autocracker
@echo    J.  = Steam Auto Crack			[ALV]
@echo    K.  = Steam Auto Crack GUI
@echo    L.  = Quest Patcher for Beat Saber
@echo    N.  = APPID
@echo.
rem StartRusTextBlock
@echo    H.  = Описание каждого приложения и небольшая инструкция
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    H.  = Description of each application and brief instructions
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallGamesApps
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _InstallqLoader)
if /i "%choice%"=="b" (GOTO _InstallRookie)
if /i "%choice%"=="c" (GOTO _InstallArmggdnz)
if /i "%choice%"=="e" (GOTO _InstalllVrpe)
if /i "%choice%"=="f" (GOTO _InstallYaas)
if /i "%choice%"=="i" (GOTO _InstallAAC)
if /i "%choice%"=="j" (GOTO _InstallSAC)
if /i "%choice%"=="k" (GOTO _InstallSACGUI)
if /i "%choice%"=="l" (GOTO _InstallQuestPatcher)
if /i "%choice%"=="n" (GOTO _InstallAppid)
if /i "%choice%"=="h" (GOTO _GameAppsAdditionalInfo)
@cls
goto _InstallGamesApps

:_GameAppsAdditionalInfo
@cls
call :_cdcbnoreg
@echo.
@echo.
rem StartRusTextBlock
@echo   %_fBGreen%= Yaas:%_fReset% %_fBYellow%Потомок qLoader%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% следовать подсказкам по установке
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://t.me/VRGamesRUS/1650432%_fReset%
@echo   ---
@echo   %_fBGreen%= qLoader:%_fReset% %_fBYellow%Для скачивания и установки пиратских игр и приложений%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% следовать подсказкам по установке
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://t.me/VRGamesRUS/16558%_fReset%
@echo   ---
@echo     %_fBGreen%= ARMGDDN Browser%_fReset%: %_fBYellow%Для скачивания PC и PCVR игр и приложений%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% на сайте разработчика
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://github.com/KaladinDMP/AGBrowser%_fReset%
@echo   ---
@echo   %_fBGreen%= Rookie Sideloader%_fReset%: %_fBYellow%Для скачивания и установки нативных пиратских игр и приложений%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% на сайте разработчика
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://wiki.vrpirates.club/Howto/Rookie-Sideloader
@echo   ---
@echo   %_fBGreen%= VRP Essentials%_fReset%: %_fBYellow%Комплекс программ для  скачивания и установки нативных пиратских игр%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% на сайте разработчика
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://wiki.vrpirates.club/Howto/VRP-Essentials%_fReset%
@echo   ---
@echo   %_fBGreen%= ARMGDDN Autocracker:%_fReset% %_fBYellow%Для отлома PC и PCVR игр от Steam%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% на сайте разработчика или в файле readme.md в архиве
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://github.com/KaladinDMP/ARMGDDN-Autocracker-OG-GSE/releases%_fReset%
@echo   ---
@echo   %_fBGreen%= SteamAutoCrack:%_fReset% %_fBYellow%Для отлома PC и PCVR игр от Steam%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% на сайте разработчика
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://github.com/oureveryday/Steam-auto-crack%_fReset%
@echo   ---
@echo   %_fBGreen%= SteamAutoCrack GUI:%_fReset% %_fBYellow%Для отлома PC и PCVR игр от Steam%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% на сайте разработчика
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://cs.rin.ru/forum/viewtopic.php?f=29^&t=117252%_fReset%
@echo   ---
@echo   %_fBGreen%= QuestPatcher for Beat Saber:%_fReset% %_fBYellow%Для пропатчивания игры Beat Saber на установку модов%_fReset%
@echo     %_fBCyan%Инструкция:%_fReset% %_fCyan%https://www.briandorey.com/post/quest-3-beat-saber-mod-questpatcher%_fReset%
@echo     %_fBCyan%Источник:%_fReset% %_fCyan%https://github.com/Lauriethefish/QuestPatcher/releases/%_fReset%
@echo   ---
@echo   %_fBGreen%= APPID:%_fReset% %_fBYellow%Для поиска идентификаторов игр Application Steam ID%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = %_fBGreen%ARMGDDN Browser%_fReset%: %_fBYellow%For downloading PC and PCVR games and applications%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Check the developer's website
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://github.com/KaladinDMP/AGBrowser%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= Rookie Sideloader%_fReset%: %_fBYellow%For downloading and installing native pirate games and applications%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Check the developer's website
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://wiki.vrpirates.club/Howto/Rookie-Sideloader%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= VRP Essentials%_fReset%: %_fBYellow%Package of programs for downloading and installing native pirate games%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Check the developer's website
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://wiki.vrpirates.club/Howto/VRP-Essentials%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= qLoader:%_fReset% %_fBYellow%For downloading and installing pirate games and applications%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Follow the installation prompts
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://t.me/VRGamesRUS/16558%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= ARMGDDN Autocracker:%_fReset% %_fBYellow%For cracking PC and PCVR games from Steam%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Check the developer's website
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://github.com/KaladinDMP/ARMGDDN-Autocracker-OG-GSE/releases%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= SteamAutoCrack:%_fReset% %_fBYellow%For cracking PC and PCVR games from Steam%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Check the developer's website
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://github.com/oureveryday/Steam-auto-crack%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= SteamAutoCrack GUI:%_fReset% %_fBYellow%For cracking PC and PCVR games from Steam%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% Check the developer's website
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://cs.rin.ru/forum/viewtopic.php?f=29^&t=117252%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= QuestPatcher for Beat Saber:%_fReset% %_fBYellow%For patching Beat Saber game to install mods%_fReset%
rem @echo     %_fBCyan%Instructions:%_fReset% %_fCyan%https://www.briandorey.com/post/quest-3-beat-saber-mod-questpatcher%_fReset%
rem @echo     %_fBCyan%Source:%_fReset% %_fCyan%https://github.com/Lauriethefish/QuestPatcher/releases/%_fReset%
rem @echo   ---
rem @echo   %_fBGreen%= APPID:%_fReset% %_fBYellow%For finding Steam game Application IDs%_fReset%
rem EndEngTextBlock
@echo   ---
@echo.
@echo.
@echo.
call :_prevmenu 
goto _InstallGamesApps


:_InstallSoftwareApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      === Установка прикладных приложений ===
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      === Installation of Productivity Applications ===
rem EndEngTextBlock
@echo.
@echo.
@echo    A.  = VRComm mobile client
@echo    B.  = LightningLauncher
@echo    C.  = File Manager+
@echo    D.  = XR File Manager  (with Data folder access)
rem @echo    E.  = Bugjaeger Premium
rem @echo    F.  = Termux
rem @echo    G.  = Oculus Wireless ADB
@echo    H.  = RCX
@echo    I.  = TotalCommander
rem @echo    J.  = SH Script Runner
@echo    K.  = ADB GUI Tool
@echo    L.  = OVR Metrics Tool
@echo    N.  = Internet Speed Meter
rem @echo    O.  = Script Manager
@echo    P.  = Passthrough cam tool
@echo    Q.  = App Cloner
@echo    R.  = Apk Tool M
@echo    S.  = MPatcher
@echo    T.  = Private Quest (only for smartphones!)
@echo    U.  = Steam Link
@echo    V.  = Auto Start Apps Manager
@echo    W.  = XR Native File Manager (with Data folder access)
rem @echo    X.  = Meta Quest Developer Hub
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallSoftwareApps
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _vrcomm)
if /i "%choice%"=="b" (GOTO _llauncher)
if /i "%choice%"=="c" (GOTO _fmplus)
if /i "%choice%"=="d" (GOTO _xrfm)
rem if /i "%choice%"=="e" (GOTO _bujaegerinst)
rem if /i "%choice%"=="f" (GOTO _termuxinst)
rem if /i "%choice%"=="g" (GOTO _ocwirelessadbinst)
if /i "%choice%"=="h" (GOTO _rcxinst)
if /i "%choice%"=="i" (GOTO _totalcomminst)
rem if /i "%choice%"=="j" (GOTO _shscriptinst)
rem if /i "%choice%"=="k" (GOTO _addguiinst)
if /i "%choice%"=="l" (GOTO _OVRMetricsTool)
if /i "%choice%"=="n" (GOTO _ismeterinst)
rem if /i "%choice%"=="o" (GOTO _scriptmanager)
if /i "%choice%"=="p" (GOTO _passthrough)
if /i "%choice%"=="q" (GOTO _apktoolm)
if /i "%choice%"=="r" (GOTO _appcloner)
if /i "%choice%"=="s" (GOTO _mpatcher)
if /i "%choice%"=="t" (GOTO _privatequest)
if /i "%choice%"=="u" (GOTO _steamlink)
if /i "%choice%"=="v" (GOTO _autostartapp)
if /i "%choice%"=="w" (GOTO _xrnativefm)
rem if /i "%choice%"=="x" (GOTO _mqdhinstall)
@cls
goto _InstallSoftwareApps

:_InstallADBTools
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      === Установка утилит для работы с ADB ===
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      === Installation ADB utilities ===
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  = Встроить пакет ADB в систему а также удалить весь этот хлам из нее
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  = Embed the ADB package into the system and also remove all this junk from it
rem EndEngTextBlock
@echo    B.  = Bugjaeger Premium
@echo    C.  = Termux
@echo    D.  = Oculus Wireless ADB
@echo    E.  = SH Script Runner
@echo    F.  = ADB GUI Tool
@echo    G.  = Script Manager
@echo    H.  = Meta Quest Developer Hub
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
if not defined choice goto _InstallADBTools
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _adbintegr)
if /i "%choice%"=="b" (GOTO _bujaegerinst)
if /i "%choice%"=="c" (GOTO _termuxinst)
if /i "%choice%"=="d" (GOTO _ocwirelessadbinst)
if /i "%choice%"=="e" (GOTO _shscriptinst)
if /i "%choice%"=="f" (GOTO _addguiinst)
if /i "%choice%"=="g" (GOTO _scriptmanager)
if /i "%choice%"=="h" (GOTO _mqdhinstall)
@cls
goto _InstallADBTools



:_InstallMediaApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      === Установка медиа приложений ===
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      === Installation of Media Applications ===
rem EndEngTextBlock
@echo.
@echo.
@echo    A.  = Skybox VR Video Player
@echo    B.  = Moon VR Video Player
@echo    C.  = 4XVR Video Player
@echo    D.  = Pigasus VR Video Player
@echo    E.  = HereSphere VR Video Player
@echo    F.  = VLC Media Player
@echo    G.  = TorServe
rem StartRusTextBlock
@echo    H.  = Filmix UHD (Онлайн кинотеатр)
@echo    I.  = Cinema HD  (Онлайн кинотеатр)
@echo    J.  = Cast Reciever High (подходит для большинства устройств)
@echo    K.  = Cast Reciever Low (устройства нижнего ценового сегмента - DNS, Yandex, Smart TV)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    H.  = Filmix UHD (Online Cinema)
rem @echo    I.  = Cinema HD  (Online Cinema)@echo.
rem @echo    J.  = Cast Receiver High (suitable for most devices)
rem @echo    K.  = Cast Receiver Low (for budget devices - DNS, Yandex, Smart TV)
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallMediaApps
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _skyboxinst)
if /i "%choice%"=="b" (GOTO _moonplayerinst)
if /i "%choice%"=="c" (GOTO _4xplayerinst)
if /i "%choice%"=="d" (GOTO _pigasusinst)
if /i "%choice%"=="e" (GOTO _hsphereinst)
if /i "%choice%"=="f" (GOTO _vlcinst)
if /i "%choice%"=="g" (GOTO _torserveinst)
if /i "%choice%"=="h" (GOTO _filmixinst)
if /i "%choice%"=="i" (GOTO _kinohdinst)
if /i "%choice%"=="j" (GOTO _CastRecieverHigh)
if /i "%choice%"=="k" (GOTO _CastRecieverLow)
@cls
goto _InstallMediaApps

:_InstallVPNClientsAnd
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      %_fBYellow%=== Установка VPN клиентов для Android ===%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%=== Installation of VPN Clients for Android ===%_fReset%
rem EndEngTextBlock
@echo.
@echo    A.  = Ultrasurf	
@echo    B.  = Windscribe			
@echo    C.  = OpenVPN Connect	
@echo    D.  = OutlineVPN			[ALV]
@echo    E.  = AdGuard VPN			[ALV]
@echo    F.  = Shadowsocks			[ALV]
@echo    G.  = Psiphon VPN			[ALV]
@echo    H.  = Proton VPN			[ALV]
@echo    I.  = Free VPN Planet		[ALV]
@echo    J.  = ByeByeDPI			[ALV]
@echo    K.  = v2rayNG VPN			[ALV]
@echo    L.  = v2rayTun VPN			[ALV]
@echo    N.  = Wireguard			[ALV]
@echo    O.  = Kakadu VPN			
@echo    P.  = Happ Proxy			[ALV]
@echo    Q.  = Samsung MAX		
@echo    R.  = Amnesia			[ALV]
@echo    S.  = X-vpn				[ALV]
@echo    T.  = Mullvad VPN			[ALV]
@echo    U.  = Hidemyname VPN			[ALV]
@echo    V.  = VPNLY				[ALV]
@echo    W.  = SurfShark			[ALV]
@echo.
rem StartRusTextBlock
@echo    %_fBYellow%Y.  = Допматериалы и помощь%_fReset%
@echo.
@echo  %_fBYellow%ВАЖНОЕ:%_fReset%
@echo     Для приложений Shadowsocks и Outline VPN можно ввести ключи доступа из пункта 2 Главного меню.
@echo.
@echo     Чтобы просто скачать приложение, без установки, выбирайте пункт меню и добавьте к нему
@echo     букву %_fBYellow%d, %_fReset%вот так: %_fBYellow%ad, bd, cd %_fReset%и так далее. Приложение скачается рядом с программой.
@echo.
@echo    %_fBCyan%[ALV]%_fReset% - %_fBYellow%Always latest version%_fReset%, Quas всегда скачивает самую последнюю версию приложения.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%Y.  = Additional materials%_fReset%
rem @echo.
rem @echo  %_fBYellow%IMPORTANT:%_fReset%
rem @echo     For the Shadowsocks and Outline VPN applications,
rem @echo     you can enter access keys from item 2 of the Main Menu.
rem @echo.
rem @echo     To just download an application without installing it, select a menu item and add
rem @echo     the letter %_fBYellow%d, %_fReset%like this: %_fBYellow%ad, bd, cd %_fReset%and so on. 
rem @echo     The application will be downloaded next to the program.
rem @echo.
rem @echo    %_fBCyan%[ALV]%_fReset% – %_fBYellow%Always latest version%_fReset%, Quas always downloads the latest version of the app.
rem EndEngTextBlock
rem @echo.
@echo.
@echo.
@echo.
@echo.
set appdlmarker=
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallVPNClientsAnd
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _ultrasurf)
if /i "%choice%"=="ad" (set appdlmarker=1&& GOTO _ultrasurf)
if /i "%choice%"=="b" (GOTO _winscribeand)
if /i "%choice%"=="bd" (set appdlmarker=1&& GOTO _winscribeand)
if /i "%choice%"=="c" (GOTO _openvpncand)
if /i "%choice%"=="cd" (set appdlmarker=1&& GOTO _openvpncand)
if /i "%choice%"=="d" (GOTO _outlineand)
if /i "%choice%"=="dd" (set appdlmarker=1&& GOTO _outlineand)
if /i "%choice%"=="e" (GOTO _adguardand)
if /i "%choice%"=="ed" (set appdlmarker=1&& GOTO _adguardand)
if /i "%choice%"=="f" (GOTO _shadowsocksand)
if /i "%choice%"=="fd" (set appdlmarker=1&& GOTO _shadowsocksand)
if /i "%choice%"=="g" (GOTO _psiphonand)
if /i "%choice%"=="gd" (set appdlmarker=1&& GOTO _psiphonand)
if /i "%choice%"=="h" (GOTO _protonand)
if /i "%choice%"=="hd" (set appdlmarker=1&& GOTO _protonand)
if /i "%choice%"=="i" (GOTO _freeplanetand)
if /i "%choice%"=="id" (set appdlmarker=1&& GOTO _freeplanetand)
if /i "%choice%"=="j" (GOTO _byebyedpiand)
if /i "%choice%"=="jd" (set appdlmarker=1&& GOTO _byebyedpiand)
if /i "%choice%"=="k" (GOTO _v2rayngand)
if /i "%choice%"=="kd" (set appdlmarker=1&& GOTO _v2rayngand)
if /i "%choice%"=="l" (GOTO _v2raytunand)
if /i "%choice%"=="ld" (set appdlmarker=1&& GOTO _v2raytunand)
if /i "%choice%"=="n" (GOTO _wireguardand)
if /i "%choice%"=="nd" (set appdlmarker=1&& GOTO _wireguardand)
if /i "%choice%"=="o" (GOTO _kakaduand)
if /i "%choice%"=="od" (set appdlmarker=1&& GOTO _kakaduand)
if /i "%choice%"=="p" (GOTO _happproxyand)
if /i "%choice%"=="pd" (set appdlmarker=1&& GOTO _happproxyand)
if /i "%choice%"=="q" (GOTO _SamsungMax)
if /i "%choice%"=="qd" (set appdlmarker=1&& GOTO _SamsungMax)
if /i "%choice%"=="r" (GOTO _amnesiavpnand)
if /i "%choice%"=="rd" (set appdlmarker=1&& GOTO _amnesiavpnand)
if /i "%choice%"=="s" (GOTO _xvpnand)
if /i "%choice%"=="sd" (set appdlmarker=1&& GOTO _xvpnand)
if /i "%choice%"=="t" (GOTO _mullvadand)
if /i "%choice%"=="td" (set appdlmarker=1&& GOTO _mullvadand)
if /i "%choice%"=="u" (GOTO _hidemynameand)
if /i "%choice%"=="ud" (set appdlmarker=1&& GOTO _hidemynameand)
if /i "%choice%"=="v" (GOTO _vpnlyand)
if /i "%choice%"=="vd" (set appdlmarker=1&& GOTO _vpnlyand)
if /i "%choice%"=="w" (GOTO _surfsharkand)
if /i "%choice%"=="wd" (set appdlmarker=1&& GOTO _surfsharkand)
if /i "%choice%"=="Y" (GOTO _additionsvpn)
@cls
goto _InstallVPNClientsAnd


:_InstallVPNClientsPC
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      %_fBYellow%=== Установка VPN клиентов для PC ===%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%=== Installation of VPN Clients for PC ===%_fReset%
rem EndEngTextBlock
@echo.
@echo    A.  = Windscribe				[ALV]
@echo    B.  = OutlineVPN				[ALV]
@echo    C.  = AdGuard VPN				[ALV]
@echo    D.  = Shadowsocks				[ALV]
@echo    E.  = Psiphon VPN				[ALV]
@echo    F.  = Free VPN Planet			[ALV]
@echo    G.  = v2rayTun VPN				[ALV]
@echo    I.  = Wireguard				[ALV]
@echo    J.  = Kakadu VPN				
@echo    K.  = Happ Proxy				[ALV]
@echo    L.  = Amnesia				[ALV]
@echo    O.  = X-vpn					[ALV]
@echo    P.  = Mullvad VPN				[ALV]
@echo    Q.  = IVPN					
@echo    R.  = Hidemyname VPN				[ALV]
@echo    S.  = VPNLY					[ALV]
@echo    T.  = ClearVPN				[ALV]
@echo    U.  = SurfSharl				[ALV]
@echo.
rem StartRusTextBlock
@echo    %_fBYellow%Y.  = Допматериалы и помощь%_fReset%
@echo.
@echo  %_fBYellow%ВАЖНОЕ:%_fReset%
@echo     Для приложений Shadowsocks и Outline VPN можно ввести ключи доступа из пункта 2 Главного меню.
@echo.
@echo     %_fBCyan%[ALV]%_fReset% - %_fBYellow%Always latest version%_fReset%, Quas всегда скачивает самую последнюю версию приложения.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%Y.  = Additional materials%_fReset%
rem @echo.
rem @echo  %_fBYellow%IMPORTANT:%_fReset%
rem @echo     For the Shadowsocks and Outline VPN applications,
rem @echo     you can enter access keys from item 2 of the Main Menu.
rem @echo.
rem @echo     %_fBCyan%[ALV]%_fReset% – %_fBYellow%Always latest version%_fReset%, Quas always downloads the latest version of the app.
rem EndEngTextBlock
rem @echo.
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallVPNClientsPC
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _winscribepc)
if /i "%choice%"=="b" (GOTO _outlinepc)
if /i "%choice%"=="c" (GOTO _adguardpc)
if /i "%choice%"=="d" (GOTO _shadowsockspc)
if /i "%choice%"=="e" (GOTO _psiphonpc)
if /i "%choice%"=="f" (GOTO _freeplanetpc)
if /i "%choice%"=="g" (GOTO _v2raytunpc)
if /i "%choice%"=="i" (GOTO _wireguardpc)
if /i "%choice%"=="j" (GOTO _kakadupc)
if /i "%choice%"=="k" (GOTO _happproxypc)
if /i "%choice%"=="l" (GOTO _amnesiavpnpc)
if /i "%choice%"=="o" (GOTO _xvpnpc)
if /i "%choice%"=="p" (GOTO _mullvadpc)
if /i "%choice%"=="q" (GOTO _ivpnpc)
if /i "%choice%"=="r" (GOTO _hidemynamepc)
if /i "%choice%"=="s" (GOTO _vpnlypc)
if /i "%choice%"=="t" (GOTO _ClearVPNpc)
if /i "%choice%"=="u" (GOTO _surfsharkpc)
if /i "%choice%"=="Y" (GOTO _additionsvpn)
@cls
goto _InstallVPNClientsPC



:_additionsvpn
@cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo   A.  Инструкция по настройка подключения с помощью хот-спота
@echo   B.  VPN Gate  [ адреса бесплатных и обновляемых VPN серверов ]
@echo   C.  Скачать VPN Gate Client   [ 200 публичных VPN серверов в списке ]
@echo   D.  Подробная инструкция по первичной активации
@echo   E.  190 VPN сервисов с описанием, характеристиками и т.д.
@echo   F.  Бесплатные ключи для VPN серверов с протоколами Outline, Vless, Trojan
@echo.
@echo   H.  Пояснения о доступе к серверам Meta
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   B.   VPN Gate
rem @echo   C.   Download VPN Gate Client   [ 200 public VPN servers ]
rem @echo   E.   190 VPN services
rem @echo   F.  Free key for VPN servers Outline, Vless, Trojan
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _additionsvpn
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (start " " "https://vrcomm.ru/forums/topic/219-первичная-настройка-шлема-и-установка-обновлений-c-помощью-хот-спота")
if /i "%choice%"=="b" (start " " "https://www.vpngate.net/en/")
if /i "%choice%"=="c" (start " " "https://www.vpngate.net/en/download.aspx")
if /i "%choice%"=="d" (start " " "https://t.me/VRPirateFAQ/6")
if /i "%choice%"=="h" (call :_additionsvpnExplain)
if /i "%choice%"=="e" (start " " "https://docs.google.com/spreadsheets/d/1L72gHJ5bTq0Djljz0P-NCAaURrXwsR1MsLpVmAt3bwg/edit?gid=0#gid=0")
if /i "%choice%"=="f" (start " " "https://outlinekeys.com/")

goto _additionsvpn


:_additionsvpnExplain
cls
@echo.
@echo.
rem StartRusTextBlock
@echo   У Меты до черта серверов различных категорий - для обновлений, магазина, ленты, миров, 
@echo   прошивок, авторизации, синхронизации времени и так далее. Шлему требуется подключение 
@echo   к ним, и если какие-то из наиболее критичных недоступны (%_fBYellow%заблокированы%_fReset%) - он не будет 
@echo   писать об этом, а просто заявит что интернет отсутствует.
@echo   Если шлем пишет: %_fBYellow%"нет интернета"%_fReset%, значит он не может получить доступ к определенной категории
@echo   серверов Меты. Если пишет %_fBYellow%"подключение ограничено"%_fReset%, это с 99% вероятностью означает,
@echo   что время на шлеме неправильное. Лечится программами %_fBYellow%Quas (пункт P) и QLoader%_fReset%. Также 
@echo   время автоматически исправляется при организации правильного доступа к серверам Меты через впн.
@echo   И даже если открываются %_fBYellow%Мета Стор%_fReset% или %_fBYellow%meta.com%_fReset%, это ничего не значит - см. первый абзац. 
@echo   По той же самой причине при логине в свой аккаунт Мета может утверждать что пароль 
@echo   неправильный, просто потому что нет доступа к серверу авторизации.
@echo. 
@echo   %_fBRed%Самое важное:%_fReset% %_fBYellow%Если вы уверены, что ваш впн в порядке, но при этом все равно получаете 
@echo   "нет интернета" и т.д. - этот впн не подходит для доступа к Мете, меняйте его. 
@echo   Даже если он платный и стоит кучу денег.%_fReset%
@echo. 
@echo   %_fBRed%Самое важное 2:%_fReset% %_fBYellow%"Правильного" и стопроцентно рабочего впн не существует. Все зависит от 
@echo   вашего провайдера - что именно он блокирует. Поэтому впн вам придется подбирать самому, 
@echo   долго и тщательно. Не работает какой-то один - ставьте и проверяйте второй, третий, двадцатый.%_fReset%
@echo. 
@echo. 
@echo               %_fBRed%ДРУГИХ РЕШЕНИЙ НЕТ^^!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Meta has a ton of servers of various categories — for updates, the store, feeds, worlds,
rem @echo   firmware, authorization, time synchronization, and so on. The headset needs access
rem @echo   to them, and if some of the most critical ones are unavailable (%_fBYellow%blocked%_fReset%) — it will not
rem @echo   report this directly, but will simply state that there is no internet.
rem @echo   If the headset says: %_fBYellow%"no internet"%_fReset%, it means it cannot access a certain category
rem @echo   of Meta servers. If it says %_fBYellow%"limited connection"%_fReset%, in 99% of cases this means
rem @echo   that the time on the headset is incorrect. This can be fixed with %_fBYellow%Quas (option P) and QLoader%_fReset%.
rem @echo   Also, the time is automatically corrected when proper access to Meta servers is set up via a VPN.
rem @echo   And even if %_fBYellow%Meta Store%_fReset% or %_fBYellow%meta.com%_fReset% opens, it means nothing — see the first paragraph.
rem @echo   For the same reason, when logging into your Meta account, it may claim that the password
rem @echo   is incorrect simply because there is no access to the authorization server.
rem @echo.
rem @echo   %_fBRed%Most important:%_fReset% %_fBYellow%If you are sure that your VPN is fine, but you still get
rem @echo   "no internet", etc. — this VPN is not suitable for accessing Meta. Change it.
rem @echo   Even if it is paid and costs a lot of money.%_fReset%
rem @echo.
rem @echo   %_fBRed%Most important #2:%_fReset% %_fBYellow%There is no "correct" or 100% working VPN. Everything depends on
rem @echo   your ISP — what exactly it blocks. Therefore, you will have to select a VPN yourself,
rem @echo   carefully and patiently. If one doesn’t work — install and test a second, a third, a twentieth.%_fReset%
rem @echo.
rem @echo.
rem @echo               %_fBRed%THERE ARE NO OTHER SOLUTIONS^^!%_fReset%
rem EndEngTextBlock
@echo.
call :_exitwindow
exit /b


:_ApplicationActionMenu
@cls
call :_hatapps
@echo.
@echo.
rem StartRusTextBlock
@echo   0. Выход из программы
@echo   M. Выход в главное меню
@echo.
@echo   1. Отобразить и сохранить списки выбранных пакетов
@echo   2. Отобразить и сохранить список выбранных пакетов с именами приложений
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   0. Exit the program
rem @echo   M. Return to the main menu
rem @echo.
rem @echo   1. Save applications list
rem @echo   2. Save applications list with label application 
rem EndEngTextBlock
set cmdsel=
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _applicationactionmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
rem if "%choice%"=="1" (goto _packageslist)
rem if "%choice%"=="2" (goto _StartAppsInstalledScript)
if "%choice%"=="1" (call :_AppsInstallMenu && goto _packageslistselmenu)
if "%choice%"=="2" (call :_AppsInstallMenu && goto _StartAppsInstalledScript)
goto _applicationactionmenu

:_packageslist
call :_cdc
call :_packages
call :_packagesfull
@echo ======================================
rem StartRusTextBlock
@echo  Списки пакетов сохранены в текущем каталоге:
@echo   - краткий список : packages-list-%dt%.txt
@echo   - полный список  : packages-list%fp%-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Packages lists saved in the current directory:
rem @echo   - brief list : packages-list-%dt%.txt
rem @echo   - full list  : packages-list%fp%-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _syscommenu

:_packagesfull
@set fullp=-f
@set fp=-fullpath

:_packages
call :_cdc
@echo All Packages >> packages-list%fp%-%dt%.txt
@echo ---  >>packages-list%fp%-%dt%.txt
@%MYFILES%\adb shell pm list packages %fullp% -a >>packages-list%fp%-%dt%.txt
call :_erlvl
@echo ======================================  >>packages-list%fp%-%dt%.txt
@echo Diasabled Packages >> packages-list%fp%-%dt%.txt
@echo ---  >>packages-list%fp%-%dt%.txt
@%MYFILES%\adb shell pm list packages %fullp% -d >>packages-list%fp%-%dt%.txt
@echo ======================================  >>packages-list%fp%-%dt%.txt
@echo Third Party Packages >> packages-list%fp%-%dt%.txt
@echo ---  >>packages-list%fp%-%dt%.txt
@%MYFILES%\adb shell pm list packages %fullp% -3 >>packages-list%fp%-%dt%.txt
@echo ======================================  >>packages-list%fp%-%dt%.txt
@echo System Packages >> packages-list%fp%-%dt%.txt
@echo ---  >>packages-list%fp%-%dt%.txt
@%MYFILES%\adb shell pm list packages %fullp% -s >>packages-list%fp%-%dt%.txt
@echo ======================================  >>packages-list%fp%-%dt%.txt
exit /b

:_packageslistselmenu
call :_packageslistsel
call :_packageslistselfull
rem StartRusTextBlock
@echo  Списки пакетов сохранены в текущем каталоге:
@echo   - краткий список : packages-list-%dt%.txt
@echo   - полный список  : packages-list%fp%-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Packages lists saved in the current directory:
rem @echo   - brief list : packages-list-%dt%.txt
rem @echo   - full list  : packages-list%fp%-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _applicationactionmenu


:_packageslistselfull
@set fullp=-f
@set fp=-fullpath

:_packageslistsel
call :_settime
@echo ======================================  >>packages-list%fp%-%dt%.txt
rem StartRusTextBlock
@echo Список %pkgfiltername% приложений>> packages-list%fp%-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo List of %pkgfiltername% applications>> packages-list%fp%-%dt%.txt
rem EndEngTextBlock
@echo ---  >>packages-list%fp%-%dt%.txt
:_packageslistselonly
@%MYFILES%\adb shell pm list packages %fullp% %listpackages% >>packages-list%fp%-%dt%.txt
@echo ======================================
exit /b


:_AppsInstalledList
@%verbecho%
rem goto _testconv
:_AppsInstallMenu
@cls
call :_hatapps
@echo.
call :_hatmenu
rem StartRusTextBlock
@echo.
@echo.
@echo     1. Все приложения
@echo     2. Системные приложения
@echo     3. Неофициальные приложения
@echo     4. Отключенные приложения
@echo     5. Включенные приложения
@echo     6. Запущеные приложения
@echo     7. Приложения c фильтрацией (по имени приложения)
@echo.
@echo.
@echo   ВАЖНО:
@echo.
@echo     Для использования этой функции на ПК должен быть интернет.
@echo.     
@echo     Выберите категорию для отображения соответствующего списка приложений.
@echo     Вероятнее всего вам требуется категория %_fBYellow%3 - Неофициальные приложения.%_fReset%
@echo     Для выбора этой категории также можно просто нажать Enter.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.
rem @echo.
rem @echo     1. All applications
rem @echo     2. System applications
rem @echo     3. Unofficial applications
rem @echo     4. Disabled applications
rem @echo     5. Enabled applications
rem @echo     6. Running applications
rem @echo     7. Applications with filtering (by application name)
rem @echo.
rem @echo.
rem @echo   IMPORTANT:
rem @echo.
rem @echo     Internet access is required on the PC to use this function.
rem @echo     Processing the list will take approximately one minute.
rem @echo.
rem @echo     Select a category to display the corresponding list of applications.
rem @echo     Most likely, you need category %_fBYellow%3 — Unofficial applications.%_fReset%
rem @echo     To select this category, you can also simply press Enter.
rem EndEngTextBlock
if [%cmdsel%] == [1] call :_CmdSelMenuText
@echo.
@echo.
set "choice=3"
@echo.
@echo.
call :_MenuChoiceEnterDef
@echo.
if not defined choice goto _AppsInstallMenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
rem if "%choice%"=="1" (set listpackages=-a && set pkgchoice=all &&set pkgfiltername=всех&& goto _StartAppsInstalledScript)
rem if "%choice%"=="2" (set listpackages=-s && set pkgchoice=system &&set pkgfiltername=системных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="3" (set listpackages=-3 && set pkgchoice=thrid-party &&set pkgfiltername=неофициальных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="4" (set listpackages=-d && set pkgchoice=disabled &&set pkgfiltername=отключенных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="5" (set listpackages=-e && set pkgchoice=enabled &&set pkgfiltername=включенных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="6" (set pkgfiltername=отфильтрованных&& goto _packageSearchFilter)

if "%choice%"=="1" (
:_ListAllApplications
    set listpackages=-a
    set pkgchoice=all
rem StartRusTextBlock
set pkgfiltername=всех
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=all
rem EndEngTextBlock
exit /b
rem    goto _StartAppsInstalledScript
)

if "%choice%"=="2" (
    set listpackages=-s
    set pkgchoice=system
rem StartRusTextBlock
set pkgfiltername=системных
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=system
rem EndEngTextBlock
exit /b
rem    goto _StartAppsInstalledScript
)

if "%choice%"=="3" (
    set listpackages=-3
    set pkgchoice=thrid-party
rem StartRusTextBlock
set pkgfiltername=неофициальных
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=thrid-party
rem EndEngTextBlock
exit /b
rem     goto _StartAppsInstalledScript
)

if "%choice%"=="4" (
    set listpackages=-d
    set pkgchoice=disabled
rem StartRusTextBlock
set pkgfiltername=отключенных
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=disabled
rem EndEngTextBlock
exit /b
rem    goto _StartAppsInstalledScript
)

if "%choice%"=="5" (
    set listpackages=-e
    set pkgchoice=enabled
rem StartRusTextBlock
set pkgfiltername=включенных
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=enabled
rem EndEngTextBlock
exit /b
rem     goto _StartAppsInstalledScript
)

if "%choice%"=="6" (
set listpackages=-a
set pkgchoice=all
rem StartRusTextBlock
set pkgfiltername=запущеных
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=running
rem EndEngTextBlock
set appsrunning=1
exit /b
rem goto :_ListRunningAppsPS
)


if "%choice%"=="7" (
    set pkgchoice=filtered
rem StartRusTextBlock
set pkgfiltername=отфильтрованных
rem EndRusTextBlock
rem StartEngTextBlock
rem set pkgfiltername=filtered
rem EndEngTextBlock
    goto _packageSearchFilter
)
rem if "%choice%"=="R" (GOTO _menurestart)
rem if "%choice%"=="r" (GOTO _menurestart)
goto _AppsInstallMenu

:_CmdSelMenuText
rem StartRusTextBlock
@echo     При выводе Всех или Системных приложений список может быть очень большим.
@echo     Если у вас установлено много неофициальных приложений, список также будет длинным.
@echo     Никаких проблем это не вызовет, но формироваться он будет чуть дольше обычного
@echo     и займет весь экран по вертикали, что доставит небольшие неудобства работы со списком.
@echo.
@echo     Чтобы добраться до конца списка, подвиньте окно вверх и уменьшите его размер по вертикали,
@echo     подвинув верхнюю кромку вниз. Затем используйте вертикальный скролл-бар справа в этом окне.
@echo.
@echo.    Если вы знаете хотя бы часть названия пакета приложения, пользуйтесь пунктом 6
@echo     в этом случае будут показаны только приложения, в которых есть эта часть названия.
@echo.
@echo     Со списком приложений работает только опция Full Application Backup
@echo     Но это не означает, что будут созданы бэкапы всех приложений в этом списке.
@echo     Это значит, что забэкапятся только те приложения, доступ к которым разрешен.
@echo.     
@echo     Остальные опции работают только с одним приложением за раз.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     When displaying All or System applications, the list can be very large.
rem @echo     If you have many unofficial applications installed, the list will also be lengthy.
rem @echo     This won't cause any issues, but the list may take a bit longer to generate
rem @echo     and will occupy the entire vertical screen space, which may be slightly inconvenient.
rem @echo.
rem @echo     To navigate to the end of the list, move the window up and decrease its vertical size
rem @echo     by dragging down the top edge. Then use the vertical scroll bar on the right side of this window.
rem @echo.
rem @echo     If you know at least part of the application package name, use option 6
rem @echo     This will display only applications that contain that part of the name.
rem @echo.
rem @echo     Only the Full Application Backup option works with the applications list.
rem @echo     However, this doesn't mean backups will be created for all applications in the list.
rem @echo     It means backups will only be created for those applications for which access is permitted.
rem @echo.
rem @echo     Other options work with only one application at a time.
rem EndEngTextBlock
exit /b



:_RunningApplicationList
call :_AppsInstallMenu



:_ListAllApplications


:_packageSearchFilter
call :_cdc
@echo ===============================================================================
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fBYellow%Для вывода приложений с фильтрацией введите название пакета или его часть,
@echo     например "%_fYellow%facebook%_fBYellow%" или "%_fYellow%face%_fBYellow%" без кавычек.%_fReset%
@echo.
@echo    %_fCyan%ОБРАТИТЕ ВНИМАНИЕ:%_fReset%
@echo.
@echo       %_fBYellow%Поиск %_fYellow%РЕГИСТРОЗАВИСИМЫЙ%_fBYellow%. Пример поиска: Предположим, название пакета "%_fYellow%com.Armature.VR4%_fBYellow%"
@echo       Поисковая фраза с частью названия "%_fYellow%arma%_fBYellow%" (без кавычек) выведет пустой список. 
@echo       Для успешного поиска фильтр следует указывать с точным регистром букв: "%_fReset%%_fYellow%Arma%_fBYellow%" (без кавычек)%_fReset%
@echo.
@echo     Для выхода в меню введите любую скобку и нажмитте Enter
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     To display applications with filtering, enter the package name or part of it,
rem @echo     for example "facebook" or "face" without quotes
rem @echo.
rem @echo     To return to the menu, enter any bracket and press Enter
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem face
rem StartRusTextBlock
@Set /p pkgsearch="Введите название или его часть и нажмите Enter : "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p pkgsearch="Enter the name or part of it and press Enter: "
rem EndEngTextBlock
@echo.
rem call :_erlvl
if not defined pkgsearch goto _AppsInstallMenu
rem if %pkgsearch%==0 goto _AppsInstallMenu
if "%pkgsearch%"=="(" (goto _AppsInstallMenu)
if "%pkgsearch%"==")" (goto _AppsInstallMenu)
if "%pkgsearch%"=="[" (goto _AppsInstallMenu)
if "%pkgsearch%"=="]" (goto _AppsInstallMenu)
if "%pkgsearch%"=="{" (goto _AppsInstallMenu)
if "%pkgsearch%"=="}" (goto _AppsInstallMenu)
rem if "%pkgsearch%"=="" (goto _AppsInstallMenu)
rem set "listpackages=%pkgsearch%" && set pkgchoice=filtered && goto _StartAppsInstalledScript
set "listpackages=%pkgsearch%" && set pkgchoice=filtered&& exit /b


:_StartAppsInstalledScript
call :_cdc
@cls
call :_hatapps
@echo.
rem StartRusTextBlock
@echo ---------------------------------------------------
@echo = Составляем список %pkgfiltername% приложений.
@echo.
@echo   Это займет около мминуты.
@echo.
@echo   Затем он будет выведен на экран и сохранен в файл.
@echo   Перелистывание списка можно делать клавишей "пробел" 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Compiling a list of %pkgchoice% applications.
rem @echo.
rem @echo   This will take about a minute.
rem @echo.
rem @echo   Then it will be displayed on the screen and saved to a file.
rem @echo   You can navigate the list using the "space" key.
rem EndEngTextBlock
rem @echo.
@echo --------------------------------------------------------
setlocal enabledelayedexpansion

set shscriptname=aaptname.sh

rem @curl -LJko aapt-arm-pie2 https://www.dropbox.com/scl/fi/vukcntk232if536s4ya8g/aapt-arm-pie2?rlkey=u3uuw2ev5tcgz81b16haqku0r -s


@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %listpackages% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
rem @echo     printf "app $label having package name $line\n";>>%shscriptname%
@echo     printf "$label;$line\n";>>%shscriptname%
rem @echo     printf "\n";>>%shscriptname%
@echo done>>%shscriptname%
@%myfiles%\adb push %myfiles%\aapt-arm-pie2 /data/local/tmp/ 1>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell chmod 0755 /data/local/tmp/aapt-arm-pie2
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >o.txt 2>nul

rem >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
rem powershell -ExecutionPolicy Bypass -File "%myfiles%\selector.ps1" "o.txt" "AppsInstalled-%pkgchoice%.txt"
rem pause

rem :_testconv
rem set listpackages=-3
rem setlocal enabledelayedexpansion
del /q /f AppsInstalled-%pkgchoice%.txt 2>nul  1>nul
@for /f "tokens=*" %%A in ('type o.txt ^| sort') do (

rem @for /f "tokens=*" %%A in ('type o.txt ^| findstr /r /c:"app.*having package name" ^| sort') do (
    set "line=%%A"
    set "line=!line:app=!"
rem     set "line=!line:having package name= ; !"
    set "line=!line:&=-!"
@for /f "tokens=1,2 delims=;" %%A in ("!line!") do (
set first=%%A
set second=%%B
Call :EchoTab "!first!" 6 "!second!"  >>AppsInstalled-%pkgchoice%.txt 2>nul
)
)

rem pause
@del /q o.txt 2>nul 1>nul
rem @del /q aapt-arm-pie2
@del /q %shscriptname%

rem @type AppsInstalled-%pkgchoice%.txt
@chcp 866 1>nul 2>nul
@more AppsInstalled-%pkgchoice%.txt 2>nul
@chcp 65001 1>nul 2>nul
rem StartRusTextBlock
if not exist AppsInstalled-%pkgchoice%.txt @echo. && @echo  = Список %pkgfiltername% приложений пуст && @echo  ----- && @echo. && goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem if errorlevel==1 @echo. && @echo  = The list of %pkgchoice% applications is empty && @echo  ----- && @echo. && goto _returnmenu
rem EndEngTextBlock
@echo.
@echo ====================================================================================
rem StartRusTextBlock
@echo Список %pkgfiltername% приложений сохранен в файл AppsInstalled-%pkgchoice%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The list of %pkgchoice% applications is saved to the file AppsInstalled-%pkgchoice%.txt
rem EndEngTextBlock
@echo ------------------------------------------------------------------------------------
@echo.
goto _returnmenu

:EchoTab
:: %1 - текст до табуляции
:: %2 - максимальное кол-во знаков табуляции в конце текста
:: %3 - текст после табуляции
  @set "text=%~1"
  @set tabs=%~2
  @for /L %%C in (7,8,200) do (
    @if "!text:~%%C,1!" neq "" (@set /A tabs-=1) else (goto ext_EchoTab)
  )
  :ext_EchoTab
  @for /L %%C in (1,1,%tabs%) do set "text=!text!	"
  @echo %text%%~3
exit /B


rem >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


:_cdc
@%myfiles%\adb shell getprop ro.boot.serialno 1>NUL 2>&1
rem @echo %errorlevel%
rem exit /b
IF %errorlevel%==1 goto _NoDevice
exit /b


:_hatapps
@echo ==================================================================================================
@echo        Quest Apps Viewer - created by Varset - v.1.0.0 - 02.11.23
@echo ==================================================================================================
exit /b



:_installqid
@%verbecho%
@setlocal enableextensions enabledelayedexpansion

set hidefrstp=1^>NUL
set hidescndp=2^>NUL

if [%1]==[] goto :_InstallMenuQid
if [%1]==[a] set right=1 && goto _adminright
if [%1]==[u] set right=2 && goto _userright 
if [%1]==[c] set right=3 && goto _uacright
if [%1]==[d] set down=-d && set dg=!down:~1!
if [%1]==[v] set hidefrstp= && set verbose=v
if [%1]==[l] set hidefrstp=1^>^>logs.txt && set logs=l
if [%1]==[m] set mov=m
if [%1]==[r] set rest=r && set mov=m
if [%1]==[s] set save=s
if [%1]==[w] set wipe=w

:_InstallMenuQid
cls
call :_hatqid
call :_tabSizeCheckQid
@echo.
rem StartRusTextBlock
@echo    Для установки приложений скопируйте и вставьте
@echo    в строку ниже apk файл или каталог, содержащий игры.
@echo    Или просто нажмите Enter для использования текущего каталога
@echo. 
@echo.
@echo	  ВАЖНО:
@echo. 
@echo      drag^&drop может не поддерживаться, если программа запущена 
@echo      с правами администратора. Поэтому:
@echo. 
@echo     В программе можно использовать дополнительные параметры:
@echo.
@echo       u - запуск с правами текущего пользователя (UAC не запускается)
@echo       a - запуск с запросом прав администратора (UAC запускается всегда)
@echo       c - запуск с запросом повышения привилегий (UAC запускается, если вы админ)
@echo       d - включение возможности установки пониженной версии приложений
@echo       v - включение подробного отображения процесса установки. По умолчанию выключено.
@echo       l - запись в файл процесса установки. Игнорируется, если установлен ключ v.
@echo       m - установка приложений с предварительным удалением и очисткой данных
@echo           [перед удалением приложений данные будут сохранены в каталог BackupsData]  
@echo       r - восстановление данных после переустановки. Не действует без ключа m.
@echo       s - сохранить данные приложений. Работает сам по себе, отдельно от остального.
@echo       w - очистить данные и кэш приложения. Работает сам по себе, отдельно от остального.
@echo.
@echo.
@echo     Параметры следует вводить ПЕРЕД началом установки 
@echo.
@echo.
@echo.
@echo    Включенные параметры будут отображены здесь:  [  %verbose% %logs% %mov% %rest% %dg%]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    To install applications, copy and paste
rem @echo    below the apk file or directory containing the games.
rem @echo    Or simply press Enter to use the current directory
rem @echo. 
rem @echo.
rem @echo    IMPORTANT:
rem @echo. 
rem @echo    drag&drop may not be supported if the program is launched 
rem @echo    with administrator privileges. Therefore:
rem @echo. 
rem @echo    Additional parameters can be used in the program:
rem @echo.
rem @echo       u - launch with current user privileges (UAC is not triggered)
rem @echo       a - launch with a request for administrator privileges (UAC is always triggered)
rem @echo       c - launch with a request for privilege elevation (UAC is triggered if you are an admin)
rem @echo       d - enable the ability to install downgraded versions of applications
rem @echo       v - enable verbose installation process. Disabled by default.
rem @echo       l - log installation process to a file. Ignored if 'v' flag is set.
rem @echo       m - install applications with prior uninstallation and data clearing
rem @echo           [before uninstalling applications, data will be saved to the BackupsData directory]  
rem @echo       r - restore data after reinstallation. Ineffective without the 'm' flag.
rem @echo       s - save application data. Works independently from other options.
rem @echo       w - clear application data and cache. Works independently from other options.
rem @echo.
rem @echo.
rem @echo    Parameters should be entered BEFORE installation starts
rem @echo.
rem @echo.
rem @echo.
rem @echo    Enabled parameters will be displayed here:  [  %verbose% %logs% %mov% %rest% %dg%]
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
set installname=
set installname=%cd%
rem StartRusTextBlock
@Set /p installname="Бросьте сюда apk, каталог или введите параметр и жмите Enter >>> "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p installname="Drop the apk here, directory, or enter a parameter and press Enter >>> "
rem EndEngTextBlock
@echo.
if /i %installname%==0 (exit)
if /i %installname%==x (goto _installmenugen)
if /i %installname%==a (goto _adminright)
if /i %installname%==u (goto _userright)
if /i %installname%==c (goto _uacright)
if /i %installname%==d (set down=-d && set dg=!down:~1! && goto _InstallMenuQid)
if /i %installname%==v (set hidefrstp= && set verbose=v && goto _InstallMenuQid)
if /i %installname%==l (set hidefrstp=1^>^>logs.txt && set logs=l && goto _InstallMenuQid)
if /i %installname%==m (set mov=m && goto _InstallMenuQid)
if /i %installname%==r (set rest=r && set mov=m && goto _InstallMenuQid)
if /i %installname%==s (set save=s && goto _SaveData)
if /i %installname%==w (set wipe=w && goto _WipeData)

rem  ==== Поправить этот кусок, экранировать спецсимволы ==============
For %%v In (!installname!) Do ( 
Set "PathIncludePathGame=%%~dpv"
set attribs=
@set extens=%%~xv
@set attribs=%%~av
rem if !extens!==.apk goto _MultiApkInstall
if !extens!==.apk goto _SingleApkInstall
rem if !attribs!==d---------- goto _MultiApkInstall
if !attribs! GEQ d-------- goto _MultiApkInstall
)
@echo ==========================================================
rem StartRusTextBlock
@echo    +++ Это не каталог, не apk файл и не ключ +++
@echo   Пожалуйста, бросьте что-нибудь более подходящее
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    +++ This is not a directory, not an apk file, and not a key +++
rem @echo              Please drop something more suitable
rem EndEngTextBlock
@echo ---------------------------------------------------------
goto :_returnmenuqid

:_MultiApkInstall
call :_cdc
@cls
call :_hat
@echo.
rem  ==== Поправить этот кусок, экранировать спецсимволы ==============
set "gPath=%installname%"
set /a MultiCounterOk=0
set /a MultiCounterEr=0
rem ЕЩЕ ПОКОВЫРЯТЬ ЦИКЛ МОЖЕТ ОН УДАЛЯЕТ ВОСКЛ ЗНАК

rem -----------------------
rem for /r %gPath% %%a in (*.*) do (
rem ------------------
for /r %gPath% %%a in (*.apk) do (
set "apkname=%%a"
@set "apknamefile=%%~nxa"
@set PathBeforeObbPath=%%~dpa
@set "apkname=%%a"
rem -------------------
rem if %%~xa==.apk call :_apkfileprocess
rem if %%~nxa==install.txt call :_installtxtprocess
rem -----------------------
rem :_apkfileprocess
rem -------------------

@For /f "tokens=*" %%v In ("!apkname!") Do Set "PathGame=%%~dpv"
@for /f "tokens=*" %%d in ('@%myfiles%\aapt2 dump packagename "!apkname!"') do set pkgname=%%d
@if not defined pkgname call :_MultiInstallApkErr
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging "!apkname!" ^| findstr /i /c:"application-label:"') DO set applabel=%%g
call :_MultiInstallProcess
@echo -----------------------------------------------
)
@echo ================================================
@echo.
rem StartRusTextBlock
@echo  +++ Установка завершена +++
@echo.
@echo   Установлено		: !MultiCounterOk!
@echo   Не установлено	: %MultiCounterEr%
@echo --------------------------------------------
@echo.
@echo   Список не установленных приложений сохранен в notinstalled.txt
@echo   Попробуйте установить их вручную. Также возможно, что
@echo   в имени файла/каталога есть восклицательный знак, удалите его.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Installation completed +++
rem @echo.
rem @echo   Installed	: !MultiCounterOk!
rem @echo   Not Installed	: %MultiCounterEr%
rem @echo --------------------------------------------
rem @echo.
rem @echo   The list of not installed applications is saved in notinstalled.txt
rem @echo   Try to install them manually. Also, it is possible that
rem @echo   there is an exclamation mark in the file/directory name, remove it.
rem EndEngTextBlock
@echo.
set mov=
set rest=
set hidefrstp=1^>NUL
set down=
set logs=
set verbose=
set dg=
@goto _returnmenuqid

:_MultiInstallProcess
if not defined applabel exit /b
if [!mov!]==[] set mov=empty
if %mov%==m (call :_mov)
set /a MultiCounterOk=%MultiCounterOk%+1
rem StartRusTextBlock
@echo  %MultiCounterOk%. Устанавливаем  "%applabel%"
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %MultiCounterOk%. Installing  "%applabel%"
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g --no-streaming "%apkname%" %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (call :_MultiCopyObbInslallApk) else (call :_MultiInstallApkErr)
call :_restdata
set applabel=
set pkgname=
exit /b

:_MultiCopyObbInslallApk
if not exist "%PathGame%%pkgname%" call :_MultiInstalledOk && exit /b
@echo --
rem StartRusTextBlock
@echo     Копируем "%pkgname%" в каталог OBB на шлем..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     Copying "%pkgname%" to the OBB directory on the headset..
rem EndEngTextBlock
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "%PathBeforeObbPath%%pkgname%" /sdcard/Android/obb/ %hidefrstp% %hidescndp%
call :_MultiInstalledOk
exit /b

:_MultiInstallApkErr
@echo.
@echo.
rem StartRusTextBlock
@echo  +++ Ошибка установки !apknamefile! +++
@echo.
@echo  == Продолжаем установку..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Installation error !apknamefile! +++
rem @echo.
rem @echo  == Continuing installation..
rem EndEngTextBlock
@echo.
@echo.
set /a MultiCounterEr=%MultiCounterEr%+1
@echo  !apkname! >>notinstalled.txt
exit /b

:_MultiInstalledOk
@echo --
rem StartRusTextBlock
@echo   = Установлено успешно
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Successfully installed
rem EndEngTextBlock
rem pause
exit /b

:_SingleApkInstall
call :_cdc
@%verbecho%
@cls
call :_hat
@echo.
@SET pkgName=
@set apkname=
set enterapkname=

rem  ==== Поправить этот кусок, экранировать спецсимволы ==============
@Set "apkname=%installname%"
@For %%v In (!apkname!) Do Set "PathIncludePathGame=%%~dpv"
for /f "tokens=*" %%a in ('%myfiles%\aapt2 dump packagename !apkname!') do set pkgname=%%a
FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging !apkname! ^| findstr /i /c:"application-label:"') DO set applabel=%%g
@echo -----------------------------------------------
if [!mov!]==[] set mov=empty
if %mov%==m call :_mov
rem StartRusTextBlock
@echo   Устанавливаем "%applabel%"
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Installing  "%applabel%"
rem EndEngTextBlock
rem @echo on
rem @echo f hidefsrtp%
rem @echo s %hidescndp%
rem pause
@%MYFILES%\ADB install -r -g %down% --no-streaming !apkname! %hidefrstp% %hidescndp%
rem pause
@IF !ERRORLEVEL!==0 (call :_SingleCopyObbInslallApk) else (call :_SingleErrInstallApk)
call :_restdata
@echo --
rem StartRusTextBlock
@echo   = Установлено успешно
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Successfully installed
rem EndEngTextBlock
@echo ===========================================
@echo.
set mov=
set rest=
set hidefrstp=1^>NUL
set down=
set logs=
set verbose=
set dg=
@goto _returnmenuqid

:_SingleCopyObbInslallApk
if not exist "%PathIncludePathGame%%pkgname%" exit /b
@echo --
rem StartRusTextBlock
@echo   Копируем "%pkgname%" в каталог OBB в шлем...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     Copying "%pkgname%" to the OBB directory on the headset..
rem EndEngTextBlock
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "%PathIncludePathGame%%pkgname%" /sdcard/Android/obb/ %hidefrstp% %hidescndp%
exit /b

:_SingleErrInstallApk
@echo ===========================================
rem StartRusTextBlock
@echo 	    +++ Ошибка установки +++
@echo  Причину можно узнать в файле error.txt
@echo Также можете включить l или v в начальном меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++ Installation error +++
rem @echo  You can find the reason in the error.txt file
rem @echo  You can also enable 'l' or 'v' in the initial menu
rem EndEngTextBlock
@echo.
@goto _returnmenuqid

:: === Установка с удалением
:_mov
@call :_settime
rem StartRusTextBlock
@echo  ..Сохраняем данные..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ..Saving data..
rem EndEngTextBlock
@echo %dt%
@echo !dt!
@md %cd%\BackupsData 1>nul 2>nul
@%myfiles%\adb pull /sdcard/Android/data/!pkgname! %cd%\BackupsData %hidefrstp% %hidescndp%
::@%myfiles%\7z.exe a -mx7 -t7z -ssw !pkgname!-%dt%.7z %cd% %hidefrstp% %hidescndp%
rem StartRusTextBlock
@echo  ..Удаляем приложение..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ..Removing the application..
rem EndEngTextBlock
%MYFILES%\ADB shell pm clear !pkgname! %hidefrstp% %hidescndp%
%MYFILES%\adb shell pm uninstall !pkgname! %hidefrstp% %hidescndp%
::@@echo.
rem StartRusTextBlock
@echo  ..Подчищаем остатки..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ..Cleaning up leftovers..
rem EndEngTextBlock
%MYFILES%\adb shell rm -rf sdcard/Android/obb/!pkgname! %hidefrstp% %hidescndp%
%MYFILES%\adb shell rm -rf sdcard/Android/data/!pkgname! %hidefrstp% %hidescndp%
@echo  ---------------------
exit /b

:_restdata
if [!rest!]==[] set rest=rempty
if !mov!==m if !rest!==r call :_restoredata
exit /b
:_restoredata
rem StartRusTextBlock
@echo  ..Восстанавливаем данные обратно..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ..Restoring data back..
rem EndEngTextBlock
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/data/!pkgname!/ %hidefrstp% %hidescndp%
@%myfiles%\adb push %cd%\BackupsData\!pkgname! /sdcard/Android/data %hidefrstp% %hidescndp%
exit /b

:_SaveData
cls
call :_hat
call :_settime
@echo.
@echo.
set savedata=
set savedata=1
rem StartRusTextBlock
@Set /p savedata="Нажмите Enter для начала сохранения данных или 0 для выхода в меню >>> "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p savedata="Press Enter to start saving data or 0 to return to the menu >>> "
rem EndEngTextBlock
if %savedata%==0 (goto _InstallMenu)
@echo -----------------------
rem @echo  ..Сохраняем данные..
@echo  ..Saving data..
@md %cd%\%dt%-BackupsData 1>nul 2>nul
@%myfiles%\adb pull /sdcard/Android/data/!pkgname! %cd%\%dt%-BackupsData %hidefrstp% %hidescndp%
@echo.
rem StartRusTextBlock
@echo  = Данные сохранены в каталоге %dt%-BackupsData
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Data saved in the directory %dt%-BackupsData
rem EndEngTextBlock
@echo -----
goto _returnmenuqid


:_WipeData
cls
call :_hat
@echo.
@echo.
rem StartRusTextBlock
@echo    Бросьте сюда apk приложения, 
@echo    данные которого хотите почистить, и жмите Enter
@echo    .. Да-да, никакой ошибки, именно так. Пока что.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    Drop here the apk of the application 
rem @echo    whose data you want to clear, and press Enter
rem @echo    ..Yes, no mistake, that's right. For now.
rem EndEngTextBlock
set wipedata=
set wipedata=1
@echo.
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@Set /p wipedata="Нажмите Enter для очистки данных или 0 для выхода в меню >>> "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p wipedata="Press Enter to clear data or 0 to exit to the menu >>> "
rem EndEngTextBlock
if %wipedata%==0 (goto _InstallMenugen)
@Set "apkname=%wipedata%"
@For %%v In (!apkname!) Do Set "PathIncludePathGame=%%~dpv"
for /f "tokens=*" %%a in ('%myfiles%\aapt2 dump packagename !apkname!') do set pkgname=%%a
@echo -----------------------
rem @echo  ..Сохраняем данные..
@echo  ..Saving data..
@md %cd%\BackupsData 1>nul 2>nul
@%myfiles%\adb pull /sdcard/Android/data/!pkgname! %cd%\BackupsData %hidefrstp% %hidescndp%
@echo.
rem StartRusTextBlock
@echo  = Данные сохранены в каталоге BackupsData
@echo ---
@echo  ..Чистим данные и кэш..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Data saved in the BackupsData directory
rem @echo ---
rem @echo  ..Cleaning data and cache..
rem EndEngTextBlock
%MYFILES%\ADB shell pm clear !pkgname! %hidefrstp% %hidescndp%
@echo.
rem StartRusTextBlock
@echo  = Данные и кэш очищены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Data and cache cleared
rem EndEngTextBlock
@echo ---
@echo.
goto _returnmenuqid


:_hatqid
@echo =============================================================================================
@echo              Quest Install Director - created by Varset - v.1.4 - 13.08.23      
@echo.
rem @echo                        Универсальный установщик приложений
@echo =============================================================================================
exit /b

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_tabSizeCheckQid
@For /F "skip=1 tokens=2,3,4,5" %%a In ('%MYFILES%\adb shell df -h /sdcard/') Do (
rem cls
@set aa=%%a
@set bb=%%b
@set cc=%%c
@set dd=%%d
set sz=Gb
)
rem StartRusTextBlock
@echo 								^| Общий объем : !aa:~,-1!!sz!
@echo 								^| Занято      : !bb:~,-1!!sz!
@echo 	0. Выход из программы					^| Свободно    : !cc:~,-1!!sz!
@echo 	X. Выход в меню						^| Заполнено   : !dd!
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo 								^| Total volume	: !aa:~,-1!!sz!
rem @echo 								^| Occupied: !bb:~,-1!!sz!
rem @echo 0. Exit program 						^| Free: !cc:~,-1!!sz!
rem @echo X. Exit to menu 						^| Filled: !dd!
rem EndEngTextBlock
@echo 								-----------------------------
exit /b

:_returnmenuqid
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to return to the menu ^<^<^<
rem EndEngTextBlock
@pause >nul
@cls
goto _InstallMenuQid


:_StartingApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    Запустить приложения на шлеме:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    Launch applications on the headset:
rem EndEngTextBlock
@echo.
@echo    B.  = LightningLauncher                 = [EXP]
@echo    C.  = File Manager+                     = [EXP]
@echo    E.  = Ultrasurf                         = [EXP]
@echo    F.  = Winscribe                         = [EXP]
@echo    G.  = OpenVPN Connect                   = [EXP]
@echo    H.  = OutlineVPN                        = [EXP]
@echo    I.  = AdGuard VPN                       = [EXP]
@echo    J.  = Shadowsocks                       = [EXP]
@echo    K.  = Psiphon VPN                       = [EXP]
@echo    L.  = Proton VPN                        = [EXP]
@echo    N.  = Free VPN Planet                   = [EXP]
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _StartingApps
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="b" (GOTO _startll)
if /i "%choice%"=="c" (GOTO _startfm)
if /i "%choice%"=="e" (GOTO _startus)
if /i "%choice%"=="f" (GOTO _startws)
if /i "%choice%"=="g" (GOTO _startovpn)
if /i "%choice%"=="h" (GOTO _startouvpn)
if /i "%choice%"=="i" (GOTO _startag)
if /i "%choice%"=="j" (GOTO _startss)
if /i "%choice%"=="k" (GOTO _startps)
if /i "%choice%"=="l" (GOTO _startpt)
if /i "%choice%"=="n" (GOTO _startfp)
@cls
goto _StartingApps

rem :_startpifix
rem call :_cdc
rem @echo Стартуем Pi Launcher..
rem @%MYFILES%\adb shell am start adb shell am start com.veticia.piLauncherNext/com.veticia.piLauncherNext.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
rem goto _CheckInstallApp

:_startll
call :_cdc
rem StartRusTextBlock
@echo Стартуем dipVR App Launcher..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching dipVR App Launcher...
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.threethan.launcher/com.threethan.launcher.launcher.LauncherActivitySearchable 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startfm
call :_cdc
rem StartRusTextBlock
@echo Стартуем Файловый менеджер+..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching File Manager+...
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.alphainventor.filemanager/.activity.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:::_startwv

::@@echo Стартуем браузер Wolvic..
::@%MYFILES%\adb shell am start us.ultrasurf.mobile.ultrasurf/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
::goto _CheckInstallApp

:_startus
call :_cdc
rem StartRusTextBlock
@echo Стартуем Ultrasurf..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Ultrasurf..
rem EndEngTextBlock
@%MYFILES%\adb shell am start us.ultrasurf.mobile.ultrasurf/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startws
call :_cdc
rem StartRusTextBlock
@echo Стартуем Winscribe..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Winscribe..
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.windscribe.vpn/com.windscribe.mobile.splash.SplashActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startovpn
call :_cdc
rem StartRusTextBlock
@echo Стартуем Open VPN Connect..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Open VPN Connect.. 
rem EndEngTextBlock
@%MYFILES%\adb shell am start net.openvpn.openvpn/net.openvpn.unified.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startouvpn
call :_cdc
rem StartRusTextBlock
@echo Стартуем Outline VPN..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Outline VPN..
rem EndEngTextBlock
@%MYFILES%\adb shell am start org.outline.android.client/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startag
call :_cdc
rem StartRusTextBlock
@echo Стартуем AdGuard VPN..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching AdGuard VPN..
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.adguard.vpn/.ui.SplashActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startss
call :_cdc
rem StartRusTextBlock
@echo Стартуем Shadowsocks..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Shadowsocks..
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.github.shadowsocks/.MainActivity 2>&1 | findstr /i /c:"Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startps
call :_cdc
rem StartRusTextBlock
@echo Стартуем Psiphon 3...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Psiphon 3...
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.psiphon3/.MainActivity 2>&1 | findstr /i /c:"Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startpt
call :_cdc
rem StartRusTextBlock
@echo Стартуем ProtonVPN..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching ProtonVPN..
rem EndEngTextBlock
@%MYFILES%\adb shell am start ch.protonvpn.android/com.protonvpn.android.ui.onboarding.SplashActivity 2>&1 | findstr /i /c:"Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startfp
call :_cdc
rem StartRusTextBlock
@echo Стартуем Free Planet VPN..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Launching Planet VPN..
rem EndEngTextBlock
@%MYFILES%\adb shell am start com.freevpnplanet/.presentation.splash.view.SplashActivity 2>&1 | findstr /i /c:"Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_CheckInstallApp
@IF %ERRORLEVEL% NEQ 0 (
@echo.
rem StartRusTextBlock
@echo = Наденьте шлем, программа должна быть открыта
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Put on the headset, the program should be open
rem EndEngTextBlock
@echo.
@echo ==============================================================
@echo.
goto _returnmenu
) else (
@echo --------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo     +++ Программа не установлена на шлем +++
@echo.
@echo   Нажмите любую кнопку для перехода к меню установки
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++ The program is not installed on the headset +++
rem @echo.
rem @echo   Press any key to go to the installation menu
rem EndEngTextBlock
@echo.
@echo ========================================================
@echo.
@pause >nul
goto _installmenugen
)
goto _returnmenu

:_CommandLaunchApp
cls
call :_hat
call :_hatmenu
@set "launchappl="
@echo.
@echo  ---
@echo.
@echo.
rem StartRusTextBlock
@set /p launch="Бросьте сюда файл apk для получения информации: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p launch="Drop the apk file here to get information: "
rem EndEngTextBlock
if not defined launch goto _CommandLaunchApp
@set "launchappl=%launch%"
if "%launch%"=="0" (exit)
if /i "%launch%"=="m" (GOTO _beginn)
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %launchappl% ^| findstr /i /c:"application-label:"') DO set applabel=%%g
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %launchappl% ^| FINDstr /i /c:"package: name="') DO set pckgname=%%g
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %launchappl% ^| findstr /i /c:"launchable-activity:"') DO set launchact=%%g
rem if [%launchact%]==[] (set launchstring=Строка запуска не найдена) else (set launchstring=adb shell am start %pckgname%/%launchact%)
if [%launchact%]==[] (set launchstring=Launchable activity not found) else (set launchstring=adb shell am start %pckgname%/%launchact%)
:_AppInfo
cls
call :_hat
@echo.
@echo.
@echo.
@echo.
@echo =============================================================================================
@echo.
rem StartRusTextBlock
@echo   Имя приложения:
@echo     %applabel%
@echo  ---
@echo   Имя пакета:
@echo     %pckgname%
@echo  ---
@echo   Строка запуска приложения:
@echo     adb shell am start %pckgname%/%launchact%
@echo     %launchstring%
@echo adb shell am start %pckgname%/%launchact% | clip
@echo.
@echo =============================================================================================
@echo Строка запуска скопирована в буфер, ее можно вставить в текстовый файл или консольное окно.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Application name:
rem @echo     %applabel%
rem @echo  ---
rem @echo   Package name:
rem @echo     %pckgname%
rem @echo  ---
rem @echo   Application launch string:
rem @echo     adb shell am start %pckgname%/%launchact%
rem @echo     %launchstring%
rem @echo adb shell am start %pckgname%/%launchact% | clip
rem @echo.
rem @echo =============================================================================================
rem @echo Launch string copied to clipboard, you can paste it into a text file or console window.
rem EndEngTextBlock
@echo ---------------------------------------------------------------------------------------------
@echo.
@echo.
set launchstring=
set launchstring=1
rem StartRusTextBlock
@Set /p launchstring="Нажмите Enter для отправки команды на шлем или 0 для выхода в меню >>> "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p launchstring="Press Enter to send the command to the headset or 0 to return to the menu >>> "
rem EndEngTextBlock
if %launchstring%==0 (goto _installmenugen)
if %launchstring%==1 (%MYFILES%\adb shell am start %pckgname%/%launchact% 2>&1 | findstr "Error type 3" 2>nul 1>nul & goto _CheckInstallApp)
goto _AppInfo


:: Секция установки игровых приложений
:_InstallqLoader
set curllink=https://dipvr.ru/get-qLoader?no-trailers
rem StartRusTextBlock
set "instmess=  Запустите скачанный файл Loader Setup.exe и следуйте его инструкциям"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Run the downloaded file Loader Setup.exe and follow its instructions"
rem EndEngTextBlock
call :_dlwingamesapps
@ren get-qLoader "Loader Setup.exe" 1>nul 2>nul
call :_prevmenu
goto _InstallGamesApps

:_InstallYaas
del /q /f YAAS-windows-x64.zip 1>nul 2>nul
set curllink=https://github.com/skrimix/yaas/releases/download/nightly/YAAS-windows-x64.zip
rem StartRusTextBlock
set "instmess=  Распакуйте архив YAAS-windows-x64.zip, запустите файл yaas.exe или launch_portable.bat  ^ & @echo   для использования программы в портативном режиме"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Unpack the aYAAS-windows-x64.zip, run the file yaas.exe or launch_portable.bat ^ & @echo   for portable mode
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps


:_InstallRookie
set curllink=https://wiki.vrpirates.club/downloads/rookie/rookie_2.29.2_portable.zip
rem StartRusTextBlock
set "instmess=  Распакуйте архив rookie_2.29.2_portable.zip, запустите файл AndroidSideloader v2.29.2.exe ^ & @echo   и следуйте дальнейшим инструкциям по установке"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Unpack the archive rookie_2.29.2_portable.zip, run the file AndroidSideloader v2.29.2.exe ^ & @echo   and follow the further installation instructions"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

:_InstallArmggdnz
set curllink=https://github.com/KaladinDMP/AGBrowser/releases/download/v6.0.0-AGB/SETUP.7z
rem StartRusTextBlock
set "instmess=  Распакуйте архив SETUP.7z, запустите файл install.bat ^ & @echo   и следуйте дальнейшим подсказкам по установке"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Unpack the archive SETUP.7z, run the file install.bat ^ & @echo   and follow the further installation prompts"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

:_InstalllVrpe
set curllink=https://github.com/VRPirates/VRPE/releases/latest/download/VRPE-Installer.exe
rem StartRusTextBlock
set "instmess=  Запустите файл VRPE-Installer.exe и следуйте дальнейшим подсказкам по установке"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Run the file VRPE-Installer.exe and follow the further installation prompts"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

rem :_InstallArmggdnftp
rem set curllink=https://dl.dropboxusercontent.com/scl/fi/6sgm21kc2pz4v8xqsc03/ARMGDDN.Zilla-FTP.7z?rlkey=zmwppr7x3edra31wlgdnk966c
rem rem StartRusTextBlock
rem rem set "instmess=  Распакуйте архив ARMGDDN.Zilla - FTP.7z, (пароль: ARMGDDNGames) ^ & @echo   запустите файл FileZillaPortable.exe"
rem rem EndRusTextBlock
rem rem StartEngTextBlock
rem rem set "instmess=  Unpack the archive ARMGDDN.Zilla - FTP.7z, (password: ARMGDDNGames)  ^ & @echo   and runun the file FileZillaPortable.exe"
rem rem EndEngTextBlock
rem call :_dlwingamesapps
rem call :_prevmenu
rem goto _InstallGamesApps

:_InstallAAC
set curllink=https://www.dropbox.com/scl/fi/nsuj19j4u8wzppeeyjjql/ARMGDDN.Autocracker.v1.0.4.7z?rlkey=drdm8eegmx70ox2nn5omni5ne
rem StartRusTextBlock
set "instmess=  Распакуйте архив ARMGDDN.Autocracker.v1.0.4.7z и запустите файл ARMGDDN.Main.exe"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Unpack the archive ARMGDDN.Autocracker.v1.0.4.7z and runun the file ARMGDDN.Main.exe"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

:_InstallSAC
set "verch=SteamAutoCrack.zip"
set curllink=https://api.github.com/repos/SteamAutoCracks/Steam-auto-crack/releases/latest 
rem StartRusTextBlock
set "instmess=  Распакуйте архив SteamAutoCrack.zip ^ & @echo   и запустите файл SteamAutoCrack.exe для использования приложения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Unpack the archive SteamAutoCrack.zip ^ & @echo   and run the file SteamAutoCrack.exe to use the application"
rem EndEngTextBlock
call :_CurlLatestGitHubSortDownloadPC
call :_prevmenu
goto _installmenugen


:_InstallSACGUI
set curllink=https://www.dropbox.com/scl/fi/xudqhxa3h18gbwe25zrp2/SACGUI-1.1.2.zip?rlkey=8hefdbgpi5hhweqxzfqpq6dkx
rem StartRusTextBlock
set "instmess=  Распакуйте архив SACGUI-1.1.2.zip и запустите файл SACGUI.exe для использования приложения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Unpack the archive SACGUI-1.1.2.zip and run the file SACGUI.exe to use the application"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

:_InstallQuestPatcher
set curllink=https://github.com/Lauriethefish/QuestPatcher/releases/download/2.8.0/QuestPatcher-windows.exe
rem StartRusTextBlock
set "instmess=  Прочитайте инструкцию по использованию в опции H этого меню ^ & @echo   и запустите файл QuestPatcher-windows.exe для установки приложения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Read the usage instructions in option H of this menu and run the file QuestPatcher-windows.exe to install the application"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

:_InstallAppid
set curllink=https://www.dropbox.com/scl/fi/s2vomiu5vfi48l69mjhc2/APPID.zip?rlkey=m51qvcokm5g9u1x80959v3y51
rem StartRusTextBlock
set "instmess=  Распакуйте архив APPID.zip и запустите файл APPID.exe для использования приложения"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=  Extract the archive APPID.zip and run the file APPID.exe to use the application"
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallGamesApps

:: Секция установки прикладных приложений
:: Section for installing application software

:_curlinstall
call :_cdc
call :_CheckAdminRights
if defined adminmsg  echo %adminmsg% && goto _returnmenu
set dlappl=curl.zip
set dlcat=%dlappl:~0,-4%
rem set dlcat=%dlappl:~0,-4%
rem StartRusTextBlock
@echo Скачивание...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
set curllink=https://www.dropbox.com/scl/fi/ikrvln73est94e165v96r/curl.zip?rlkey=r5wu5n0s7qq0dyi9c7ivwgcur
@curl -LJkO %curllink%  -# 1>nul
@%myfiles%\7z.exe x "%cd%\%dlappl%" -o"%cd%\%dlcat%\" 1>NUL 2>&1
@xcopy %cd%\%dlcat%\*.* %windir%\*.* /Y 1>NUL 2>&1
rd %cd%\%dlcat%\ /q /s 1>NUL 2>&1
@del /y /f %dlappl%  1>NUL 2>&1
rem call :_prevmenu
rem goto _InstallSoftwareApps
exit /b

:_checksystemcurl
@%verbecho%
@curl.exe 1>nul 2>nul
if %errorlevel%==2 goto _setdrivers
rem StartRusTextBlock
@echo  ================================================================================
@echo  ^|  %_fBRed%+++ Curl отсутствует в операционной системе, автоскачивание невозможно +++%_fReset%  ^|
@echo  ================================================================================
@echo.
@echo    %_fBYellow%Сначала требуется скачать и установить %_fYellow%Curl %_fBYellow%вручную.
@echo    Нажмите %_fYellow%Enter %_fBYellow%чтобы скачать с помощью браузера, 
@echo    затем распакуйте содержимое каталога %_fYellow%bin %_fBYellow%в каталог Windows.%_fReset% 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  =================================================================================================
rem @echo  ^|  +++ Curl is missing from the operating system, application installation is impossible  +++  ^|
rem @echo  =================================================================================================
rem @echo.
rem @echo  Press Enter to download, then extract the contents of the bin directory to your Windows directory
rem EndEngTextBlock
set dlcurl=
set dlcurl=1
@echo  ----------------
@echo.
rem StartRusTextBlock
@Set /p dlcurl="Нажмите Enter для скачивания или 0 для возврата >>> "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p dlcurl="Press Enter to download or 0 to return >>> "
rem EndEngTextBlock
if %dlcurl%==0 (goto :_NormalStart)
if %dlcurl%==1 (goto :_curldownloadbrowser)
goto :_checksystemcurl

:_curldownloadbrowser
start " " "https://curl.se/windows/latest.cgi?p=win64-mingw.zip"
@echo  ----------------
rem StartRusTextBlock
@echo  %_fBCyan% Распакуйте архив %_fCyan%win64-mingw.zip %_fBCyan%и содержимое каталога %_fCyan%bin %_fBCyan%скопируйте в каталог %_fCyan%Windows%_fBCyan%
@echo   Затем нажмите любую кнопку для выхода в начальное окно программы%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBCyan% Unpack the archive %_fCyan%win64-mingw.zip %_fBCyan%and copy the contents of the %_fCyan%bin %_fBCyan%folder into the %_fCyan%Windows%_fBCyan% directory
rem @echo   Then press any key to return to the main window of the program%_fReset%
rem EndEngTextBlock
pause >nul
goto _NormalStart


:_mqdhinstall
call :_cdc
rem set dlappl=Meta-Quest-Developer-Hub-5.5.0.exe.zip
rem set curllink=https://securecdn.oculus.com/binaries/download/?id=9659320600819602
set dlappl=Meta-Quest-Developer-Hub-5.8.0.exe.zip
set curllink=https://securecdn.oculus.com/binaries/download/?id=24303452959313124

rem StartRusTextBlock
set "instmess= Распакуйте архив и запустите exe файл"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess= Extract archive and run exe-file "
rem EndEngTextBlock
call :_dlwingamesapps
call :_prevmenu
goto _InstallSoftwareApps

:_llauncher
call :_cdc
set dlappl=LightningLauncher.apk
set "verch=Lightning"
rem set dlappl=LightningLauncher.apk
set curllink=https://api.github.com/repos/threethan/LightningLauncher/releases/latest
call :_CurlLatestGitHubSortDownload
call :_prevmenu
goto _InstallSoftwareApps

:_fmplus
call :_cdc
set dlappl=fmplus.apk
set curllink=https://www.dropbox.com/s/atq6zl34cyx5p50/fmplus.apk
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_xrfm
call :_cdc
set dlappl=com.marc.files.apk
set curllink=https://www.dropbox.com/scl/fi/pl9txs9q6qrsb6t1ohzfu/com.marc.files.apk?rlkey=ja9ub7hin38twntqkc37owfvg
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_xrnativefm
call :_cdc
set dlappl=com.anagan.xrnativeandroidfilemanager.apk
set curllink=https://www.dropbox.com/scl/fi/3djms9wwxjfookcxyl83e/com.anagan.xrnativeandroidfilemanager.apk?rlkey=vybqkyugkx9x36hrx15bt4pwf
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_vrcomm
rem Koofr link:
rem set URL=https://app.koofr.net/content/links/20fffde3-fc35-452f-8436-948ddf85729c/files/get/vrcomm.apk?path=%%2F^&password=545106

call :_cdc
set dlappl=vrcomm.apk
set curllink=https://www.dropbox.com/scl/fi/amadcbc0lanfnf0uwsk7f/vrcomm.apk?rlkey=r5ir8zpjcusnocrxbh79f7chu
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_OVRMetricsTool
call :_cdc
set dlappl=OVRMetricsTool_v1.6.5.apk
rem set curllink=https://securecdn.oculus.com/binaries/download/?id=9536587913048629
set curllink=https://www.dropbox.com/scl/fi/3o3ne0nh9bdiob5vpxhd0/OVRMetricsTool_v1.6.5.apk?rlkey=aqxrvwfx4qb66tnsuz6hnzqpf
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_bujaegerinst
call :_cdc
set dlappl=Bugjaeger-Premium-v5.0-full.apk
set curllink=https://www.dropbox.com/scl/fi/s098v5stzlktj91gkkpsp/Bugjaeger-Premium-v5.0-full.apk?rlkey=qp99kc6q6nm7j89r53gh5f8q0
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_termuxinst
call :_cdc
set dlappl=termux-app_v0.118.0.apk
set curllink=https://www.dropbox.com/scl/fi/hsd3yiq0nuj86wxuih5mf/termux-app_v0.118.0.apk?rlkey=20ofy3qyiv3kzlkx3zeltj55d
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_ocwirelessadbinst
call :_cdc
set dlappl=tdg.oculuswirelessadb-1.2.apk
set curllink=https://www.dropbox.com/scl/fi/04aodeddzojdwpkqqi2zf/tdg.oculuswirelessadb-1.2.apk?rlkey=v3gl22fr99zqfjsocoatt0lp0
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_rcxinst
call :_cdc
set dlappl=rcx-v1.12.2-arm64-v8a-release.apk
set curllink=https://www.dropbox.com/scl/fi/tdot38l2jo0t5ivrejkk2/rcx-v1.12.2-arm64-v8a-release.apk?rlkey=uk2brp08rg42obtb2r09nocja
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_totalcomminst
call :_cdc
set dlappl=tcandroid341d-universal.apk
set curllink=https://www.dropbox.com/scl/fi/lf4rdasnp9m1un9x78823/tcandroid341d-universal.apk?rlkey=mxgfqoasl5sov1lggi5fad83q
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_shscriptinst
call :_cdc
set dlappl=SHScriptRunner_1.10.apk
set curllink=https://www.dropbox.com/scl/fi/qfto9bm36pwfnqvnv0h63/SHScriptRunner_1.10.apk?rlkey=falgqxtj7m30eiao2cgzq9b5r
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_addguiinst
call :_cdc
set dlappl=ADB_vV3.3.154.apk
set curllink=https://www.dropbox.com/scl/fi/n19q1ua5i9v8sxtghb1fq/ADB_vV3.3.154.apk?rlkey=naa6lwrulz9betslygqkgdic1
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_ismeterinst
call :_cdc
set dlappl=InternetSpeedMeter+v1.5.9-pro.apk
set curllink=https://www.dropbox.com/scl/fi/digww6psdpwjhlhen8wqf/InternetSpeedMeter-v1.5.9-pro.apk?rlkey=56lp8ij9x0raokoqpwqjqwgz1
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_scriptmanager
call :_cdc
set dlappl=ScriptManager_50.apk
set curllink=https://www.dropbox.com/scl/fi/2w1sy48v9tti4i3mdstqf/ScriptManager_50.apk?rlkey=aejdquia8mxih0llaj8e3n04p
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_passthrough
call :_cdc
set dlappl=Passthrough.apk
set curllink=https://www.dropbox.com/scl/fi/0ccpmjiy49dya85ex32s1/Passthrough.apk?rlkey=o9g7mxnki703x67w3jq2gzvnf
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_apktoolm
call :_cdc
set dlappl=Apktool_M_v2.4.0.apk
set curllink=https://www.dropbox.com/scl/fi/kki8jgeg1ue4h1zdej0u4/Apktool_M_v2.4.0.apk?rlkey=ox6rgx6tk8mq5ohnwnhnfn6wq
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_appcloner
call :_cdc
set dlappl=AppCloner_v.2.17.14.apk
set curllink=https://www.dropbox.com/scl/fi/beg8zfmonlwa2dhrt1j69/AppCloner_v.2.17.14.apk?rlkey=qym706wduzh6al7jyg7tmcqrj
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_privatequest
call :_cdc
set dlappl=private_quest_1_1.apk
set curllink=https://www.dropbox.com/scl/fi/mx6tunr8776gjoxkcxbqx/private_quest_1_1.apk?rlkey=kgxa45smrd5xsp09u6b8egcnv
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_mpatcher
call :_cdc
set dlappl=MPatcher_v5.1.apk
set curllink=https://www.dropbox.com/scl/fi/707y1qidoxfhr534jx9cl/MPatcher_v5.1.apk?rlkey=5i0a8nc5b8euvie86dc98w5ca
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_steamlink
call :_cdc
set dlappl=com.valvesoftware.steamlinkvr.apk
set curllink=https://www.dropbox.com/scl/fi/dyyb69ijfpfo71u1l2u9k/com.valvesoftware.steamlinkvr.apk?rlkey=p3ywcdmnf4isyzbirmdjhbf00
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps

:_autostartapp
call :_cdc
set dlappl=AutoStartAppManager.apk
set curllink=https://www.dropbox.com/scl/fi/g1vqrsm1ecgyyqdxr7jsx/AutoStartAppManager.apk?rlkey=lsk7zavdnu65hcsu7uzbajlwe
call :_dlinstall
call :_prevmenu
goto _InstallSoftwareApps


:: Установка медиа приложений
:_skyboxinst
call :_cdc
set dlappl=xyz.skybox.player.ovr.apk
set curllink=https://www.dropbox.com/scl/fi/1p5wl6b5z1rxini2xwhhe/xyz.skybox.player.ovr.apk?rlkey=j64zehs9avz3r2dngzx1uv8lp
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_pigasusinst
call :_cdc
set dlappl=com.hanginghatstudios.pigasus.apk
set curllink=https://www.dropbox.com/scl/fi/hmhlrtuwlvls8ohqzotgt/com.hanginghatstudios.pigasus.apk?rlkey=v510fowbssjglb2uwb8pbg41r
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_4xplayerinst
call :_cdc
set dlappl=cn.vr4p.oculus4xvrplayerov.apk
set curllink=https://www.dropbox.com/scl/fi/wclezmxslh68d3dvggq6s/cn.vr4p.oculus4xvrplayerov.apk?rlkey=d7675l1h3acfqjvadz7boqzbu
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_moonplayerinst
call :_cdc
set dlappl=com.mrf.rockvr.moonplayer.apk
set curllink=https://www.dropbox.com/scl/fi/uqqxwcfhwvc0p3uqvu7xa/com.mrf.rockvr.moonplayer.apk?rlkey=nqy3skdaccxxclfcs2frmjfcr
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_hsphereinst
call :_cdc
set dlappl=com.heresphere.vrvideoplayer.apk
set curllink=https://www.dropbox.com/scl/fi/3h1krnmomtpbry0vdkdly/com.heresphere.vrvideoplayer.apk?rlkey=h8yskp4cst7cwf9tw3si1tzv6
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_vlcinst
call :_cdc
set dlappl=VLC_v.3.5.4.apk
set curllink=https://www.dropbox.com/scl/fi/27s1l3ufinvo7nwle42gl/VLC_v.3.5.4.apk?rlkey=z3o7t78pwa2osevjkqx31ixdp
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_torserveinst
call :_cdc
set dlappl=TorrServe_MatriX.127.Client-release.apk
set curllink=https://www.dropbox.com/scl/fi/hjuggqqh1tkqoave1m4au/TorrServe_MatriX.127.Client-release.apk?rlkey=4wydeq9fdkhbencmwz9sjqzl1
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_filmixinst
call :_cdc
set dlappl=Filmix-UHD.apk
set curllink=https://www.dropbox.com/scl/fi/z81uwhmszn8gwyyoirqzn/Filmix-UHD.apk?rlkey=wa157oc0evsa0wz3ewpvf5mt5
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_kinohdinst
call :_cdc
set dlappl=Kino_HD_grey-3.1.1.apk
set curllink=https://www.dropbox.com/scl/fi/xh79tc13c1440q3qrp8w3/Kino_HD_grey-3.1.1.apk?rlkey=4sz3qc8lkaqufudeep7bzucxb
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_CastRecieverHigh
rem Поддерживается большинством устройств
call :_cdc
set dlappl=CastReceiver-v1.6.10Premium-arm64-v8a.apk
set curllink=https://www.dropbox.com/scl/fi/y4uq3apt3bye8cxpp4p9j/CastReceiver-v1.6.10Premium-arm64-v8a.apk?rlkey=xn8dlcxaecx4rcc2mcaky2owy
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps

:_CastRecieverLow
rem Устройства нижнего ценового сегмента (ДНС яндекс смарт ТВ)
call :_cdc
set dlappl=CastReceiver-v1.6.10Premium-armeabi-v7a.apk
set curllink=https://www.dropbox.com/scl/fi/b35vzrr8tk7x3756c11ws/CastReceiver-v1.6.10Premium-armeabi-v7a.apk?rlkey=5rrjqyfnjm8drvcrurh1cuamz
call :_dlinstall
call :_prevmenu
GOTO _InstallMediaApps



:: VPN клиенты и драйверы
:_ultrasurf
call :_cdc
set dlappl=Ultrasurf.apk
set curllink=https://www.dropbox.com/s/zsbsjok9vc3veyr/Ultrasurf.apk
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_ultrasurfl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
@start " " "https://ultrasurf.us/"
call :_prevmenu
goto _installmenugen

:_winscribeand
call :_cdc
set dlappl=Windscribe.apk
set curllink=https://www.dropbox.com/scl/fi/y3x08gnkb5alxmgtc0mqv/Windscribe.apk?rlkey=ej7snop6pasapsk1y1wojeiuf
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_winscribepc
rem ALV
call :_cdc
set dlappl=Windscribe.exe
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://windscribe.com/install/desktop/windows
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_winscribel
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://rus.windscribe.com/knowledge-base/articles/russian-get-started-on-android"
rem call :_prevmenu
goto _installmenugen

:_wireguardand
rem ALV
call :_cdc
set dlappl=com.wireguard.android.apk
set curllink=https://download.wireguard.com/android-client/com.wireguard.android.apk
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_wireguardpc
rem ALV
call :_cdc
set dlappl=wireguard-installer.exe
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://download.wireguard.com/windows-client/wireguard-installer.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_openvpncand
call :_cdc
set dlappl=OpenVPNc.apk
set curllink=https://www.dropbox.com/s/zu6e68iwn9bydaq/OpenVPNc.apk
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_openvpncl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=116398198"
rem call :_prevmenu
goto _installmenugen

:_outlinepcpc
rem ALV
call :_cdc
set dlappl=openvpn-connect-v3-windows.msi
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://openvpn.net/downloads/openvpn-connect-v3-windows.msi
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_outlineand
rem ALV
call :_cdc
set dlappl=Outline-Client.apk
set curllink=https://s3.amazonaws.com/outline-releases/client/android/stable/Outline-Client.apk
call :_dlinstall
call :_outlinel
call :_prevmenu
goto _installmenugen

:_outlinepc
rem ALV
call :_cdc
set dlappl=Outline-Client.exe
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://s3.amazonaws.com/outline-releases/client/windows/stable/Outline-Client.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen


:_outlinel
@echo -----
rem StartRusTextBlock
@echo Через секунду в шлеме откроется браузер с сайтом, где можно бесплатно взять ключ
@echo Под надписью Keys Outline VPN нажмите кнопку Outline
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo In a second, the browser in the headset will open a website where you can get a key for free
rem @echo Under the title "Keys Outline VPN," click the "Outline" button
rem EndEngTextBlock
rem @echo A browser will open on the headset with a website where you can get a free key.
@%MYFILES%\adb shell am start -n "com.oculus.vrshell/.MainActivity" -d apk://com.oculus.browser -e uri https://outlinekeys.com/ 1>nul 2>nul
::@%MYFILES%\adb shell am start -a android.intent.action.VIEW -d https://outline.network/  1>NUL
exit /b
rem call :_prevmenu
rem goto _installmenugen

:_adguardand
rem ALV
call :_cdc
set dlappl=AdguardVPN.apk
set curllink=https://agrd.io/android_vpn_apk
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_adguardl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://adguard.com/ru/blog/introducing-adguard-vpn-for-android.html"
rem call :_prevmenu
goto _installmenugen

:_adguardpc
rem ALV
call :_cdc
set dlappl=adguardVPNInstaller.exe
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://download.adguardcdn.com/d/18675/adguardVPNInstaller.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_shadowsocksand
rem ALV
rem set dlappl=Shadowsocks.apk
rem set curllink=https://www.dropbox.com/s/jel793qjlwrptyq/Shadowsocks.apk
rem call :_dlinstall
rem call :_prevmenu
rem goto _installmenugen
call :_cdc
rem set curlparam=-C -
set dlappl=Shadowsocks.apk
set "verch=shadowsocks--universal"
set curllink=https://api.github.com/repos/shadowsocks/shadowsocks-android/releases/latest 
call :_CurlLatestGitHubSortDownload
call :_prevmenu
goto _installmenugen

:_shadowsocksl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://4pda.to/forum/index.php?showtopic=744431&st=3060"
rem call :_prevmenu
goto _installmenugen

:_shadowsockspc
rem ALV
set "verch=Shadowsocks"
set curllink=https://api.github.com/repos/shadowsocks/shadowsocks-windows/releases/latest 
call :_CurlLatestGitHubSortDownloadPC
call :_prevmenu
goto _installmenugen

:_psiphonand
rem ALV
call :_cdc
set dlappl=PsiphonAndroid.apk
set curllink=https://psiphon.ca/PsiphonAndroid.apk
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_psiphonl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://psiphon.ca/ru/psiphon-guide.html"
rem call :_prevmenu
goto _installmenugen

:_psiphonpc
rem ALV
call :_cdc
set dlappl=psiphon3.exe
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://psiphon.ca/psiphon3.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_protonand
rem ALV
call :_cdc
set "verch=release.apk"
set dlappl=ProtonVPN.apk
set curllink=https://api.github.com/repos/ProtonVPN/android-app/releases/latest 
call :_CurlLatestGitHubSortDownload
call :_prevmenu
goto _installmenugen

:_protonl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://protonvpn.com/ru/free-vpn/android"
rem call :_prevmenu
goto _installmenugen

:_freeplanetand
rem ALV
call :_cdc
set dlappl=planetvpn.apk
set curllink=https://cdn.freevpnplanet.com/android/planetvpn.apk
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_freeplanetl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://support.freevpnplanet.com/hc/ru"
rem call :_prevmenu
goto _installmenugen

:_freeplanetpc
rem ALV
call :_cdc
set dlappl=planetvpn.exe
rem -O имя из URL
rem -o имя вручнуюб dlappl
set oparam=-o
set curllink=https://cdn.freevpnplanet.com/win/planetvpn.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen


:_byebyedpiand
call :_cdc
set "verch=universal"
set dlappl=ByeByeDPI.apk
set curllink=https://api.github.com/repos/romanvht/ByeByeDPI/releases/latest
rem set curllink=https://www.dropbox.com/scl/fi/a8p7gi1m91wnjnmsuho8d/byedpi-1.2.0.apk?rlkey=b35bmnu7jo6xc050krgp6ubij
call :_CurlLatestGitHubSortDownload
call :_prevmenu
goto _installmenugen

:_v2rayngand
call :_cdc
set "verch=arm64-v8a"
set dlappl=v2rayNG.apk
set curllink=https://api.github.com/repos/2dust/v2rayNG/releases/latest
call :_CurlLatestGitHubSortDownload
call :_v2rayngurl
call :_prevmenu
goto _installmenugen

:_v2rayngurl
@echo -----
rem StartRusTextBlock
@echo Через секунду в шлеме откроется браузер с сайтом, где можно бесплатно взять ключ
@echo Под надписью Keys Outline VPN нажмите кнопку Vless
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo In a second, the browser in the headset will open a website where you can get a key for free
rem @echo Under the title "Keys Outline VPN," click the "Vless" button
rem EndEngTextBlock
rem @echo A browser will open on the headset with a website where you can get a free key.
@%MYFILES%\adb shell am start -n "com.oculus.vrshell/.MainActivity" -d apk://com.oculus.browser -e uri https://outlinekeys.com/ 1>nul 2>nul
exit /b


:_v2raytunand
call :_cdc
set "verch=universal"
set dlappl=v2raytun.apk
set curllink=https://api.github.com/repos/DigneZzZ/v2raytun/releases/latest 
call :_CurlLatestGitHubSortDownload
call :_prevmenu
goto _installmenugen

:_v2raytunpc
set dlappl=v2RayTun_Setup.exe
set "oparam=-o"
set "curlparam=-#"
set curllink=https://storage.v2raytun.com/v2RayTun_Setup.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_bebravpnand
call :_cdc
set dlappl=Bebra.apk
set "curlparam=-c"
set curllink=https://bebra.gs/apps/Bebra.apk
call :_dlinstall
call :_prevmenu
goto _installmenugen


:_bebravpnpc
rem set "pcsoftware=Бебра"
set dlappl=Bebra.exe
set curllink=https://yandexvpn.website.yandexcloud.net/Bebra.exe
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_kakaduand
call :_cdc
set dlappl=kakaduvpnand.apk
set "curlparam=-#"
set curllink="https://63693919-ba72-4a1a-b784-1d9da5c86017.selstorage.ru/kakadu.apk"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_kakadupc
set dlappl=kakaduvpnpc.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://storage.kakadu-vpn.com/windows/Kakadu%%20Setup%%20v1.2.3.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_amnesiavpnand
call :_cdc
rem set curlparam=-C -
set dlappl=AmneziaVPN.apk
set "verch=arm64-v8a.apk"
set curllink=https://api.github.com/repos/amnezia-vpn/amnezia-client/releases/latest
call :_CurlLatestGitHubSortDownload
call :_prevmenu
goto _installmenugen

:_amnesiavpnpc
rem set dlappl=amnezia.msi
set "verch=amneziawg-amd64"
set curllink=https://api.github.com/repos/amnezia-vpn/amneziawg-windows-client/releases/latest
call :_CurlLatestGitHubSortDownloadPC
call :_prevmenu
goto _installmenugen

:_xvpnand
call :_cdc
set dlappl=x-vpn.apk
set "curlparam=-#"
set curllink="https://xvpn.io/ru/download/vpn-andorid?isAutoDownload=true&os=android"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_xvpnpc
set dlappl=x-vpn.exe
set "oparam=-o"
set "curlparam=-#"
set curllink="https://xvpn.io/download?isAutoDownload=true&os=win"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen


:_happproxyand
call :_cdc
set dlappl=Happ.apk
set "curlparam=-#"
set curllink="https://github.com/Happ-proxy/happ-android/releases/latest/download/Happ.apk"
call :_dlinstall
call :_prevmenu
goto _installmenugen


:_happproxypc
set dlappl=setup-Happ.x64.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://github.com/Happ-proxy/happ-desktop/releases/latest/download/setup-Happ.x64.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen


:_mullvadpc
set dlappl=mullvad.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://mullvad.net/ru/download/app/exe/latest"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_mullvadand
call :_cdc
set dlappl=mullvad.apk
set "oparam=-o"
set "curlparam=-#"
set curllink="https://mullvad.net/ru/download/app/apk/latest"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_ivpnpc
set dlappl=IVPN-Client-v3.15.0.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://repo.ivpn.net/windows/bin/IVPN-Client-v3.15.0.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_hidemynameand
call :_cdc
set dlappl=hidemyname_2.1.272se5.apk
set "oparam=-o"
set "curlparam=-#"
set curllink="https://hide.mn/files/software/hidemyname_2.1.272se5.apk"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_hidemynamepc
set dlappl=hidemyname_3.3.50beta4.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://hide.mn/files/software/hidemyname_3.3.50beta4.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_vpnlyand
call :_cdc
set dlappl=vpnly.apk
set "oparam=-o"
set "curlparam=-#"
set curllink="https://s3.amazonaws.com/static.vpnly.com/android/vpnly.apk"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_vpnlypc
set dlappl=vpnly.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://s3.amazonaws.com/static.vpnly.com/win/vpnly.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_vpnlyand
call :_cdc
set dlappl=vpnly.apk
set "oparam=-o"
set "curlparam=-#"
set curllink="https://s3.amazonaws.com/static.vpnly.com/android/vpnly.apk"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_ClearVPNpc
set dlappl=SetupClearVPN.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://s3.dualstack.us-east-1.amazonaws.com/clearvpn.com/downloads/windows/SetupClearVPN.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_surfsharkand
call :_cdc
set dlappl=Surfshark.apk
set "oparam=-o"
set "curlparam=-#"
set curllink="https://downloads.surfshark.com/android/Surfshark.apk"
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_surfsharkpc
set dlappl=SurfsharkSetup.exe
set "oparam=-o"
set "curlparam=-#"
set "curllink=https://downloads.surfshark.com/windows/latest/SurfsharkSetup.exe"
call :_PCSoftwareInstall
call :_prevmenu
goto _installmenugen

:_SamsungMax
call :_cdc
set dlappl=SamsungMax4.4.18.apk
set curllink=https://www.dropbox.com/scl/fi/xdszhupfzfp7x8oap8m1b/SamsungMax4.4.18.apk?rlkey=kku3lpjmut7sstae1udwr00d0
call :_dlinstall
call :_prevmenu
goto _installmenugen

:_setdrivers
rem call :_checkcurlexists
call :_CheckAdminRights
call :_CheckOSVersion
if defined adminmsg  echo %adminmsg% && goto _returnmenu
if [%osversion%]==[10] goto _setdrivers10

:_setdrivers7
set dlappl=ocdrv7.zip
set dlcat=%dlappl:~0,-4%
set curllink=https://www.dropbox.com/s/ockvsja022hz2ug/ocdrv7.zip
set "startfile=oculus-driver.exe"
rem StartRusTextBlock
set "instmess=Готово. Драйверы установлены."
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=Done. Oculus drivers installed."
rem EndEngTextBlock
goto _dlwinapps

:_setdrivers10
set dlappl=ocdrv10-17117.zip
set dlcat=%dlappl:~0,-4%
@rd %cd%\%dlcat% /Q /S 1>nul 2>nul
@del %dlappl% /Q 1>nul 2>nul
set curllink=https://www.dropbox.com/scl/fi/8jw003gwsc5zdkt42afgq/ocdrv10-17117.zip?rlkey=01t7nfljpsi5d3mvf463f4tou
set "startfile=oculus-driver.exe"
rem StartRusTextBlock
set "instmess=Готово. Драйверы установлены."
rem EndRusTextBlock
rem StartEngTextBlock
rem set "instmess=Done. Oculus drivers installed."
rem EndEngTextBlock
goto :_DriversInstallProcess


:_setdriversmh172
set mhdrvinstver=72
set curllink=https://www.dropbox.com/scl/fi/w00buq8rwhpwbpzrd6y93/MetaHorizonDriversInst_v1.72.zip?rlkey=afyb2pm2vbe2tnr6ooz9gdjz3
goto _setdriversmhMainProcess

:_setdriversmh177
set mhdrvinstver=77
set curllink=https://www.dropbox.com/scl/fi/1ofmj5z5vdjyu1vrvuqkg/MetaHorizonDriversInst_v1.77.zip?rlkey=h09s65llwijiiu4ppa9zgxis4


:_setdriversmhMainProcess
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
set dlappl=MetaHorizonDriversInst_v1.%mhdrvinstver%.zip
set dlcat=%dlappl:~0,-4%
@rd %cd%\%dlcat% /Q /S 1>nul 2>nul
@del %dlappl% /Q 1>nul 2>nul
rem set curllink=https://www.dropbox.com/scl/fi/3xqung5wcr8kz8s3qbd7f/MetaQuestNewDrivers.zip?rlkey=8yswylvmg5v6t9p6quchkqump
@curl -LJkO %curllink% -# 1>nul
@%myfiles%\7z.exe x "%cd%\%dlappl%" -o"%cd%\%dlcat%\" 1>NUL 2>&1
set "startfile=_installdrv.cmd"
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Установка...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Installing...
rem EndEngTextBlock
@ping localhost -n 3 1>nul 2>&1
@start " " "%cd%\%dlcat%\%startfile%"
@ping localhost -n 3 1>nul 2>&1
rem @rd %cd%\%dlcat% /Q /S 1>nul 2>nul
@del %dlappl% /Q 1>nul 2>nul
@echo ----------------------------------------
goto _DriverInstalledMessage


:_DriverInstalledMessage
rem StartRusTextBlock
@echo   %_fBGreen%= Готово. Драйверы должны быть установлены.%_fReset%
@echo ----------------------------------------
@echo.
@echo      %_fBYellow%Драйверы для Highwind Interface возможно придется установить вручную:%_fReset%
@echo.
@echo   %_fBYellow%Обновить драйвер%_fReset% - %_fBYellow%Найти драйверы на этом компе%_fReset% - %_fBYellow%Выбрать драйвер из списка%_fReset% - %_fBYellow%Показать все
@echo   устройства%_fReset% - %_fBYellow%Далее%_fReset% - %_fBYellow%Установить с диска%_fReset% - %_fBYellow%Обзор%_fReset% - выбрать файл %_fBYellow%android_winusb.inf%_fReset%, выбрать
@echo   %_fBYellow%Reality Labs Composite Highwind Interface%_fReset%, в окне "%_fBYellow%Установка этого драйвера 
@echo   не рекомендуется.....Вы хотите установить этот драйвер?%_fReset%" ответить %_fBYellow%Да.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Done. Drivers must be installed.
rem @echo ----------------------------------------
rem @echo.
rem @echo      %_fBYellow%Drivers for Highwind Interface are installed manually:
rem @echo.
rem @echo   Update driver - Browse my computer for drivers - Let me pick from a list - Show all 
rem @echo   devices - Next - Install from disk - Browse - select the file android_winusb.inf, choose
rem @echo   Reality Labs Composite Highwind Interface, in the window "Installing this driver 
rem @echo   is not recommended.....Do you want to install this driver?" answer Yes.%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _installmenugen


:_driversdownload171
set dlappl=ocdrv10-17117.zip
set mhdriversver=71
set curllink=https://www.dropbox.com/scl/fi/8jw003gwsc5zdkt42afgq/ocdrv10-17117.zip?rlkey=01t7nfljpsi5d3mvf463f4tou
goto _driversdownload


:_driversdownload172
set dlappl=MetaHorizonDrivers_v1.72.zip
set mhdriversver=72
set curllink=https://www.dropbox.com/scl/fi/q7x2hx3jg6hsnvj3epez5/MetaHorizonDrivers_v1.72.zip?rlkey=pg2i3pzccwp3nc23qvkm9i4rl
goto _driversdownload


:_driversdownload177
set dlappl=MetaHorizonDrivers_v1.77.zip
set mhdriversver=77
set curllink=https://www.dropbox.com/scl/fi/qqdefi1gvn3tqln7wf3yy/MetaHorizonDrivers_v1.77.zip?rlkey=tgrmiuqq5uglmi5i54vpqlz3r


:_driversdownload
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
rem set dlappl=MetaQuestNewDrivers.zip
rem set dlappl=MetaHorizonDrivers_v1.%mhdriversver%.zip
set dlcat=%dlappl:~0,-4%
@rd %cd%\%dlcat% /Q /S 1>nul 2>nul
@del %dlappl% /Q 1>nul 2>nul
@curl -LJkO %curllink% -# 1>nul
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Готово. Драйверы должны быть скачаны.%_fReset%
@echo     Архив называется %_fCyan%%dlappl%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Done. Drivers must be downloaded%_fReset%
rem @echo     The archive is called %_fCyan%%dlappl%%_fReset%
rem EndEngTextBlock
rem call :_prevmenu
goto _returnmenu

:_dlwingamesapps
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
@curl -LJkO %curllink% -# 1>nul
rem @%myfiles%\7z.exe x "%cd%\%dlappl%" -o"%cd%\%dlcat%\" 1>NUL 2>&1
rem @start " " "%cd%\%dlcat%\%startfile%"
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Готово.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Done.
rem EndEngTextBlock
@echo.
@echo %instmess%
exit /b
rem call :_prevmenu
rem goto _installmenugen

:_dlwinapps
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
@curl -LJkO %curllink%  -# 1>nul
@%myfiles%\7z.exe x "%cd%\%dlappl%" -o"%cd%\%dlcat%\" 1>NUL 2>&1
rem if %errorlevel% NEQ 0 goto _dlwinappsend
rem StartRusTextBlock
@echo   ---
@echo   %_fByellow%= Установка... Ждите около минуты...
@echo     Если появится окно о перезагрузке, нажмите %_fyellow%"нет".%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Installing... Please wait for about a minute...
rem @echo If a reboot prompt appears, click "No".
rem EndEngTextBlock
@start " " "%cd%\%dlcat%\%startfile%"
@ping localhost -n 50 1>nul 2>&1
@rd %cd%\%dlcat% /Q /S 1>nul 2>nul
@del %dlappl% /Q 1>nul 2>nul
call :_prevmenu
goto _installmenugen

:_CurlLatestGitHubSortDownloadPC
rem Процедура не используется, оставлена на всякий случай.
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
rem @FOR /F "tokens=1,2 delims= " %%a IN ('curl %curllink% -Ss ^| findstr /i /c:"browser_download_url"') DO set bdu=%%b
for /f "tokens=* delims=" %%a in ('curl %curllink% -Ss ^| findstr /i /c:"browser_download_url" ^| findstr /i "%verch%"') do set "urlres=%%a"
set "urlres=%urlres:  "browser_download_url": =%"
set "urlres=%urlres:"=%"
set "urlres=%urlres:,=%"
set "urlres=%urlres: =%"
@curl -LJkO "%urlres%" -# 1>nul
for %%i in ("%urlres%") do set "dlappl=%%~nxi"
rem @curl -LJko %dlappl% "%bdu%" -# 1>nul
@echo   ---
rem StartRusTextBlock
@echo   %_fByellow%= Установка ПО %_fBCyan%%pcsoftware%%_fReset%
@echo   %_fByellow%  Следуйте инструкциям установщика.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Installing Meta Link on drive %disknumber%
rem @echo   Follow the Oculus installer instructions
rem EndEngTextBlock
@start " " %dlappl%
@echo.
exit /b


@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %dlappl% ^| findstr /i /c:"application-label:"') DO set applabel=%%g
@echo   ---
rem StartRusTextBlock
@echo   %_fByellow%= Установка...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Installing...
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g -d --no-streaming "%dlappl%" 1>NUL 2>&1
call :_erlvl
@del /Q /F %dlappl%
@echo --------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Готово. Приложение %_fBCyan%"%applabel%"%_fBGreen% установлено.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Done. Application "%applabel%" installed.
rem EndEngTextBlock
exit /b


:_CurlLatestGitHubSortDownload
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание %_fBCyan%%dlappl%%_fByellow%...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
for /f "tokens=* delims=" %%a in ('curl %curllink% -Ss ^| findstr /i /c:"browser_download_url" ^| findstr /i "%verch%"') do set "urlres=%%a"
set "urlres=%urlres:  "browser_download_url": =%"
set "urlres=%urlres:"=%"
set "urlres=%urlres:,=%"
set "urlres=%urlres: =%"
set "urlres=%urlres: =%"
rem @curl -LJkO AmneziaVPN.apk "%urlres%" -# 1>nul
rem echo %urlres%
@curl -LJko %dlappl% "%urlres%" -# 1>nul
rem for %%i in ("%urlres%") do set "dlapplold=%%~nxi"
rem echo %dlappl%
rem pause
rem call :_DeleteWrongSymbolsOkMain
rem echo %dlappl%
rem echo %dlapplold%
rem pause
rem set "f=%dlapplold%"
rem ren "!f:%2B=+!" "!f:%2B=+!:+=!"
rem set dlappl=%f%
rem echo %dlappl%
rem ren %dlapplold% %dlappl%
rem 1>nul 2>nul
rem pause
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging "%dlappl%" ^| findstr /i /c:"application-label:"') DO set applabel=%%g
rem pause
if defined appdlmarker goto :_CurlLatestGitHubSortDownloadOnly
@echo   ---
rem StartRusTextBlock
@echo   %_fByellow%= Установка...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Installing...
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g -d --no-streaming "%dlappl%" 1>NUL 2>&1
call :_erlvl
@del /Q /F %dlappl%
@echo --------------------------------------------------------
rem StartRusTextBlock
@echo %_fBGreen%Готово. Приложение %_fBCyan%"%applabel%" %_fBGreen%установлено.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Done. Application "%applabel%" installed.
rem EndEngTextBlock
exit /b

:_CurlLatestGitHubSortDownloadOnly
@echo --------------------------------------------------------
rem StartRusTextBlock
@echo %_fBGreen%Готово. Приложение %_fBCyan%"%applabel%" %_fBGreen%скачано.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Done. Application "%applabel%" downloaded.
rem EndEngTextBlock
exit /b

:_DriversInstallProcess
@echo ----------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
@curl -LJkO %curllink%  -# 1>nul
@%myfiles%\7z.exe x "%cd%\%dlappl%" -o"%cd%\%dlcat%\" 1>NUL 2>&1
if %errorlevel% NEQ 0 goto _dlwinappsend
rem StartRusTextBlock
@echo   ---
@echo   %_fByellow%= Установка... Ждите около минуты...
@echo     Если появится окно о перезагрузке, нажмите %_fyellow%"нет".%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Installing... Please wait for about a minute...
rem @echo If a reboot prompt appears, click "No".
rem EndEngTextBlock
@start " " "%cd%\%dlcat%\%startfile%"
@ping localhost -n 50 1>nul 2>&1
@rd %cd%\%dlcat% /Q /S 1>nul 2>nul
@del %dlappl% /Q 1>nul 2>nul
rem StartRusTextBlock
@echo   ---
@echo   %_fBGreen%= Готово. Драйверы Oculus установлены.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Done. Oculus drivers installed.%_fReset%
rem EndEngTextBlock
@echo   ---
call :_returnmenu
GOTO _tabBegin



:_dlwinappsend
@echo ----------------------------------------
rem StartRusTextBlock
@echo %_fBRed%Ошибка установки. Проверьте подключение к интернет и права администратора.%_fReset%
@echo.
@echo  %_fBYellow%Если при скачивании появляется ошибка, попробуйте установать драйверы вручную:
@echo.
@echo  1. Скачать файл %_fYellow%oculus-home-drivers-1.71.0.000017-w10.rar %_fBYellow%по ссылке: 
@echo     %_fBGreen%https://vrcomm.ru/files/file/5-драйверы-oculus-quest/
@echo  %_fBYellow%2. Распаковать архив и запустить файл %_fYellow%oculus-drivers.exe
@echo  %_fBYellow%3. Подождать ровно одну минуту.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBRed%Installation error. Please check your internet connection and administrator privileges.%_fReset%
rem @echo.
rem @echo  %_fBYellow%If an error occurs during download, try installing the drivers manually:
rem @echo.
rem @echo  1. Download the file %_fYellow%oculus-home-drivers-1.71.0.000017-w10.rar %_fBYellow%from the link: 
rem @echo     %_fBGreen%https://vrcomm.ru
rem @echo  %_fBYellow%2. Extract the archive and run the file %_fYellow%oculus-drivers.exe
rem @echo  %_fBYellow%3. Wait exactly one minute.%_fReset%
rem EndEngTextBlock
call :_returnmenu
GOTO _tabBegin

:_dlinstall
@del /Q /F %dlappl% 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание приложения %_fBCyan%%dlappl%%_fByellow%...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
@curl -LJko %dlappl% %curllink% %curlparam% -# 1>nul
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %dlappl% ^| findstr /i /c:"application-label:"') DO set applabel=%%g
if defined appdlmarker goto :_CurlLatestGitHubSortDownloadOnly
@echo   ---
rem StartRusTextBlock
@echo   %_fByellow%= Установка...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Installing...
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g -d --no-streaming "%dlappl%" 1>NUL 2>&1
call :_erlvl
@del /Q /F %dlappl%
@echo --------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Готово. Приложение %_fBCyan%"%applabel%"%_fBGreen% установлено.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Done. Application "%applabel%" installed.
rem EndEngTextBlock
exit /b


:_PCSoftwareInstall
@del /Q /F %dlappl% 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo   %_fByellow%= Скачивание %_fBCyan%%dlappl%%_fByellow%...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Downloading...
rem EndEngTextBlock
@curl -LJk %oparam% %dlappl% %curllink% -# 1>nul
@echo   ---
rem StartRusTextBlock
@echo   %_fByellow%= Установка ПО %_fBCyan%%pcsoftware%%_fReset%
@echo   %_fByellow%  Следуйте инструкциям установщика.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Installing Meta Link on drive %disknumber%
rem @echo   Follow the Oculus installer instructions
rem EndEngTextBlock
@start " " %dlappl%
@echo.
exit /b

:_dlinstallGithubRelease
@echo   ---
rem StartRusTextBlock
@echo   %_fByellow%= Установка...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Installing...
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g -d --no-streaming "%dlappl%" 1>NUL 2>&1
call :_erlvl
@del /Q /F %dlappl%
@echo --------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Готово. Приложение %_fBCyan%"%applabel%" %_fBGreen%установлено.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Done. Application "%applabel%" installed.
rem EndEngTextBlock
exit /b

:_qctprocedure

@%verbecho%

:_SendToMenu
goto _ResetEnv 

:_SendToMenuEndLocal
set sendtolnk=
set qtarget=
set sendtofoldercmdfile=
set sendtofolder=
set sendtofoldercmdfolder=
@%verbecho%
cls
call :_hatqct
call :_hatmenuqct
@echo.
rem StartRusTextBlock
@echo  Установить ярлыки в контекстное меню Отправить:
@echo.
@echo    A.  Файлы на Quest в OBB
@echo    B.  Файлы на Quest в Data
@echo    C.  Файлы на Quest в Movies
@echo    D.  Файлы на Quest в Download
@echo    E.  Файлы на Quest в корень Sdcard
@echo.
@echo    G.  Установка APK+OBB
@echo    I.  Установка через INSTALL.TXT
@echo    J.  Восстановление архива .ab
@echo.
@echo    V.  Установить все ярлыки разом
@echo.
@echo  Дополнительные действия (ярлыки не создаются):
@echo.
@echo    H.  Описание программы (help)
@echo    X.  Удалить установленные ярлыки и файлы
@echo    Y.  Вручную удалить установленные ярлыки и файлы
@echo.
@echo.
@echo  ВАЖНО:
@echo.
@echo    В процессе установки необходимые файлы и сценарии командной строки
@echo    будут размещены в каталоге C:\Temp\SendToHeadset.
@echo.
@echo    Ярлыки создаются в каталоге \AppData\Microsoft\Windows\SendTo
@echo    и станут доступны по правой кнопке мыши в контекстном меню Отправить.
@echo.
@echo    При выборе пункта "Удалить установленные ярлыки и файлы"
@echo    всё ранее установленное будет полностью удалено: 
@echo    программы, ярлыки и весь каталог SendToHeadset.
@echo.
@echo    Установка приложений и копирование выполняются сразу после выбора 
@echo    контекстной опции, без дополнительного подтверждения.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Install shortcuts in the context menu Send To:
rem @echo.
rem @echo    A. Files to Quest in OBB
rem @echo    B. Files to Quest in Data
rem @echo    C. Files to Quest in Movies
rem @echo    D. Files to Quest in Download
rem @echo    E. Files to Quest in the root Sdcard
rem @echo.
rem @echo    G. Install APK+OBB
rem @echo    I. Install via INSTALL.TXT
rem @echo    J. Restore .ab archive
rem @echo.
rem @echo    V. Install all shortcuts together
rem @echo.
rem @echo  Additional actions (no shortcuts created):
rem @echo.
rem @echo    H. Program description (help)
rem @echo    X. Remove installed shortcuts and files
rem @echo    Y. Remove installed shortcuts and files manually
rem @echo.
rem @echo.
rem @echo IMPORTANT:
rem @echo.
rem @echo.
rem @echo    During installation, necessary files and command scripts
rem @echo    will be placed in the directory C:\Temp\SendToHeadset.
rem @echo.
rem @echo    Shortcuts are created in the directory \AppData\Microsoft\Windows\SendTo
rem @echo    and will be available via right-click in the Send To context menu.
rem @echo.
rem @echo    When selecting "Remove installed shortcuts and files"
rem @echo    all previously installed items will be completely removed:
rem @echo    programs, shortcuts, and the entire SendToHeadset directory.
rem @echo.
rem @echo    Application installation and copying will occur immediately after choosing
rem @echo    the context menu option, without additional confirmation.
rem EndEngTextBlock
@echo.
@echo.
@set "choice="
rem StartRusTextBlock
@Set /p choice="Выберите пункт меню и нажмите Enter (H - для помощи): "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Select a menu number and press Enter (H - help) : "
rem EndEngTextBlock
@echo.
if not defined choice goto _SendToMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (call :_SendToOBB && call :_InstallLnkMessage)
if /i "%choice%"=="b" (call :_SendToData && call :_InstallLnkMessage)
if /i "%choice%"=="c" (call :_SendToMovies && call :_InstallLnkMessage)
if /i "%choice%"=="d" (call :_SendToDownloads && call :_InstallLnkMessage)
if /i "%choice%"=="e" (call :_SendToSDCARD && call :_InstallLnkMessage)
if /i "%choice%"=="g" (call :_SendToInstallAPK && call :_InstallLnkMessage)
if /i "%choice%"=="i" (call :_SendToInstallTxt && call :_InstallLnkMessage)
if /i "%choice%"=="j" (call :_SendToRestoreAB && call :_InstallLnkMessage)
if /i "%choice%"=="h" (call :_DescriptionContextTool)
rem StartRusTextBlock
if /i "%choice%"=="v" (@echo  = Установка ярлыков.. && call :_SendToDownloads && call :_SendToMovies && call :_SendToOBB && call :_SendToSDCARD && call :_SendToInstallAPK && call :_SendToInstallTxt && call :_SendToData && call :_InstallLnkMessageAll && call :_SendToRestoreAB)
rem EndRusTextBlock
rem StartEngTextBlock
rem if /i "%choice%"=="v" (@@echo = Installing shortcuts... && call :_SendToDownloads && call :_SendToMovies && call :_SendToOBB && call :_SendToSDCARD && call :_SendToInstallAPK && call :_SendToInstallTxt && call :_SendToData && call :_InstallLnkMessageAll)
rem EndEngTextBlock
if /i "%choice%"=="x" (GOTO _DeleteLnksFolder)
if /i "%choice%"=="y" (explorer shell:sendto & explorer c:\temp)

@cls
goto _SendToMenu

:_ResetEnv
(
  endlocal
)
goto _SendToMenuEndLocal


:_SendToSDCARD
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem StartRusTextBlock
set sendtolnk=Файлы на Quest в корень Sdcard
set copyname=корень SDCARD
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Files onto Quest to the root of Sdcard
rem set copyname=root SDCARD
rem EndEngTextBlock
set qtarget=/sdcard/
set sendtofoldercmdfile=sendsd.cmd
set ico=ocwt.ico
call :_CreateCmdForLink
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b


:_SendToData
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem StartRusTextBlock
set sendtolnk=Файлы на Quest в Data
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Files onto Quest to OBB folder
rem EndEngTextBlock
set copyname=Data
set qtarget=/sdcard/Android/data/
set sendtofoldercmdfile=senddt.cmd
set ico=ocwt.ico
call :_CreateCmdForLink
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b


:_SendToOBB
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem StartRusTextBlock
set sendtolnk=Файлы на Quest в OBB
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Files onto Quest to OBB folder
rem EndEngTextBlock
set copyname=OBB
set qtarget=/sdcard/Android/obb/
set sendtofoldercmdfile=sendob.cmd
set ico=ocwt.ico
call :_CreateCmdForLink
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b

:_SendToMovies
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem StartRusTextBlock
set sendtolnk=Файлы на Quest в Movies
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Files onto Quest to Movies folder
rem EndEngTextBlock
set copyname=Movies
set qtarget=/sdcard/Movies/
set sendtofoldercmdfile=sendmv.cmd
set ico=ocwt.ico
call :_CreateCmdForLink
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b

:_SendToDownloads
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem StartRusTextBlock
set sendtolnk=Файлы на Quest в Download
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Files onto Quest to Download folder
rem EndEngTextBlock
set copyname=Download
set qtarget=/sdcard/Download/
set sendtofoldercmdfile=senddl.cmd
set ico=ocwt.ico
call :_CreateCmdForLink
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b

:_SendToInstallAPK
call :_SetVariableContext
call :_qctlangset
call :_CopyAllFiles
rem StartRusTextBlock
set sendtolnk=Установка APK+OBB
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=APK+OBB Installation
rem EndEngTextBlock
set sendtofoldercmdfile=qidcontext%qtlang%.cmd
set ico=ocgr.ico
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b

:_SendToInstallTxt
call :_SetVariableContext
call :_qctlangset
call :_CopyAllFiles
rem StartRusTextBlock
set sendtolnk=Установка через INSTALL.TXT
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Installation via INSTALL.TXT
rem EndEngTextBlock
set sendtofoldercmdfile=qidcontext%qtlang%.cmd
set ico=ocgr.ico
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b

:_SendToRestoreAB
call :_SetVariableContext
call :_qctlangset
call :_CopyAllFiles
rem StartRusTextBlock
set sendtolnk=Восстановление архива .ab
rem EndRusTextBlock
rem StartEngTextBlock
rem set sendtolnk=Restore .ab archive
rem EndEngTextBlock
set sendtofoldercmdfile=qidcontext%qtlang%.cmd
set ico=ocgr.ico
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b


:_DeleteLnksFolder
::call :_SetVariableContext
@taskkill /im adb.exe /f 1>nul 2>nul


rem >>>>>>>>>>>>>>>>>>
rem Проверить ц Windows 11 этот путь
set sendtofolder=%appdata%\Microsoft\Windows\SendTo
rem >>>>>>>>>>>>>>>

set sendtofoldercmdfolder=%systemdrive%\Temp\SendToHeadset
@ping localhost -n 2 1>nul 2>nul
rd %sendtofoldercmdfolder% /S /Q 1>nul 2>nul
rem StartRusTextBlock
del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в Movies*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в OBB*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в Data*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в Download*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в корень Sdcard*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Установка APK+OBB*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Установка через INSTALL.TXT*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Восстановление архива .ab*" /q 1>nul 2>nul
rem EndRusTextBlock
rem StartEngTextBlock
rem del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in Movies*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in OBB*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in Data*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in Download*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in the root of Sdcard*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\APK+OBB Installation*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Installation via INSTALL.TXT*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Restore .ab archive*" /q 1>nul 2>nul
rem EndEngTextBlock
rem endlocal
@echo  =====================================================
rem StartRusTextBlock
@echo  = Все установленные ранее ярлыки и программы удалены
@echo  -----
@echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = All previously installed shortcuts and programs have been removed
rem @echo  -----
rem @echo ^>^>^> Press any key to return to the menu ^<^<^<
rem EndEngTextBlock
@pause >nul
@echo.
goto :_SendToMenu



:_CreateCmdForLink
rem endlocal 
call :_SetVariableContext
@del %sendtofoldercmdfolder%\%sendtofoldercmdfile% /q 1>nul 2>nul
@echo @echo off>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @chcp 65001 1^>nul 2^>nul>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo ADB запускается....>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo ADB is starting...>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @%sendtofoldercmdfolder%\adb devices 1^>nul 2^>nul>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @FOR ^/F "skip=1 tokens=2" %%%%G IN ^('%sendtofoldercmdfolder%\adb devices ^^^| findstr /i /c:"device"'^) DO set adbdevices=%%%%G>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @if [%%adbdevices%%]==[] goto _NF>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @cls>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @goto :_sendcopy>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_NF>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @cls>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo     +++++ Шлем не найден +++++>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo     +++++ Headset not found +++++>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo  Проверьте кабельное соединение и правильность установки драйверов.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo  Затем перезапустите эту программу снова.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo  Check the cable connection and the correctness of driver installation.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo  Then restart this program again.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @goto :_sendexit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_sendcopy>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @setlocal enableextensions enabledelayedexpansion>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @for ^/f "tokens=*" %%%%e in ^("%ap%"^) do ^( >> %sendtofoldercmdfolder%\%sendtofoldercmdfile%

@echo @set "fullpathfile=%%%%~fe">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%

rem @echo @set "file=%%%%~nxe">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ------------->>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo = Копируем в %copyname%..>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo = Copying to %copyname%..>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem rem @echo @%sendtofoldercmdfolder%\adb.exe push "!fullpathfile!!file!" -p "/sdcard/">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%

rem @echo @%sendtofoldercmdfolder%\adb.exe push -p "!fullpathfile!!file!" "%qtarget%">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @%sendtofoldercmdfolder%\adb.exe push -p "!fullpathfile!" "%qtarget%">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%

rem rem @echo @%sendtofoldercmdfolder%\adb shell mv "/sdcard/!file!" "%qtarget%">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%

@echo ^)>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ^====================================================>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo ^= Копирование завершено>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo ^= Copying completed>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo goto :_exittimeout>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_sendexit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo ^^^>^^^>^^^> Нажмите любую кнопку для выхода ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo ^^^>^^^>^^^> Press any key to exit ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @pause ^>nul>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @exit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_exittimeout>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem StartRusTextBlock
@echo @echo ^^^>^^^>^^^> Нажмите любую кнопку для выхода из программы ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo               или подождите пять секунд>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo @echo ^^^>^^^>^^^> Press any key to exit the program ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo               or wait for five seconds>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem EndEngTextBlock
@echo @timeout ^5 ^>nul>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @exit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
exit /b

:_CreateLnkFromCmd
@mshta vbscript:Execute("Set x=CreateObject(""WScript.Shell"").CreateShortcut(""%sendtofolder%\%sendtolnk%.lnk""):x.IconLocation=""%sendtofoldercmdfolder%\%ico%"":x.TargetPath=""%sendtofoldercmdfolder%\%sendtofoldercmdfile%"":x.WorkingDirectory=""%sendtofoldercmdfolder%"":x.Save():Close()")
exit /b

:_CopyAllFiles
@xcopy %myfiles%\aapt2.exe %sendtofoldercmdfolder% /y 1>nul 2>nul
:_CopyOnlyADBFiles
@xcopy %myfiles%\ocwt.ico %sendtofoldercmdfolder% /y 1>nul 2>nul
@xcopy %myfiles%\ocgr.ico %sendtofoldercmdfolder% /y 1>nul 2>nul
rem @xcopy %~dp0ocwt.ico %sendtofoldercmdfolder% /y 1>nul 2>nul
rem @xcopy %~dp0ocgr.ico %sendtofoldercmdfolder% /y 1>nul 2>nul

@xcopy %myfiles%\adb.exe %sendtofoldercmdfolder% /y 1>nul 2>nul
@xcopy %myfiles%\AdbWinApi.dll %sendtofoldercmdfolder% /y 1>nul 2>nul
@xcopy %myfiles%\AdbWinUsbApi.dll %sendtofoldercmdfolder% /y 1>nul 2>nul

@xcopy %myfiles%\qidcontext%qtlang%.cmd %sendtofoldercmdfolder% /y 1>nul 2>nul
rem @xcopy %~dp0qidcontext.cmd %sendtofoldercmdfolder% /y 1>nul 2>nul
exit /b

:_InstallLnkMessage
@echo  ==================================================
rem StartRusTextBlock
@echo  = Установлен ярлык "%sendtolnk%"
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Shortcut "%sendtolnk%" installed
rem EndEngTextBlock
@echo  -----

:_InstallLnkMessageAll
rem @setlocal enableextensions enabledelayedexpansion
@echo  ==================================================
rem StartRusTextBlock
@echo  = Установлены все ярлыки.
@echo  -----
@echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = All shortcuts installed.
rem @echo  -----
rem @echo ^>^>^> Press any key to return to the menu ^<^<^<
rem EndEngTextBlock
@pause >nul
@echo.
goto _SendToMenu

:_SetVariableContext
:: Закомментировать на релизе
rem @set myfiles=d:\Quest2\_Cmd\__Quac\2.7.0\Source

rem @set myfiles=d:\Quest2\adb
@set sendtofolder=%appdata%\Microsoft\Windows\SendTo
@set sendtofoldercmdfolder=C:\Temp\SendToHeadset
@md %sendtofoldercmdfolder% 1> nul 2>nul
@set percents=%%%
@set ap=%%%^*
rem set "exclmark=^!"
rem endlocal
exit /b

:_DescriptionContextTool
cls
call :_hatqct
@echo.
rem StartRusTextBlock
@echo   ОПИСАНИЕ ПРОГРАММЫ:
@echo.
@echo    Программа предназначена для установки ярлыков в контекстное меню.
@echo    После работы программы в меню "Отправить" станут доступны следующие опции:
@echo.
@echo      Файлы на Quest в OBB		= отправка файлов на шлем в каталог Android\OBB
@echo      Файлы на Quest в Data		= отправка файлов на шлем в каталог Android\data
@echo      Файлы на Quest в Movies		= отправка файлов на шлем в каталог Movies
@echo      Файлы на Quest в Download		= отправка файлов на шлем в каталог Download
@echo      Файлы на Quest в корень Sdcard	= отправка файлов на шлем в корневой каталог
@echo      Установка APK+OBB			= установка приложений на шлем. 
@echo      Установка через INSTALL.TXT	= установка приложений через сценарий install.txt
@echo      Восстановление .ab			= восстановление бэкапа на шлем
@echo.
@echo    Также в программе доступны дополнительные действия:
@echo.
@echo      Установить все ярлыки разом            = установка сразу всех шести ярлыков 
@echo      Удалить установленные ярлыки и файлы   = полное удаление всего установленного ранее
@echo.
@echo    После того, как ярлыки созданы, программа больше не требуется, ее можно отложить
@echo    в сторонку до тех пор, прока не появится необходимость добавить или удалить ярлыки.
@echo.
@echo   ИСПОЛЬЗОВАНИЕ ФУНКЦИЙ ПОСЛЕ УСТАНОВКИ ЯРЛЫКОВ:
@echo.
@echo      Отмечаем мышью один или несколько файлов, например, фильмов. Правой кнопкой мыши
@echo      кликаем на отмеченное и в контекстном меню "Отправить" выбираем нужный пункт, например 
@echo      "Файлы на Quest в Movies". Файлы будут скопированы на шлем в соответствующий каталог.
@echo      При необходимиости можно отмечать^/копировать и каталоги тоже. 
@echo. 
@echo      Для установки приложений кликаем правой кнопкой мыши на APK файл или каталог с игрой
@echo      и в меню "Отправить" выбираем "Установка APK+OBB". Игра будет установлены на шлем. 
@echo      Если с игрой идет каталог obb, он автоматически скопируется куда нужно.
@echo      Если в каталоге несколько игр, они будут установлены поочередно.
@echo.
@echo      Иногда в каталоге с игрой лежит файл install.txt. Как правило, в нем содержатся команды
@echo      для специальной установки некоторых игр. Например, у игр Doom 3 или Beat Saber 
@echo      нет каталогов с obb, вместо них множество отдельных файлов. Установка через install.txt
@echo      производится так же, как и APK, но через отдельный ярлык.
@echo.
@echo      Опция "Восстановление .ab" используется для быстрого восстановления бэкапа данных
@echo      приложений. Выберите архив .ab, программа его просканирует и напишет название игры
@echo      и пакета. После этого попросит подтверждения восстановления.
@echo.
@echo      Опция Удаление ярлыков вручную откроет каталоги С:\Temp и 
@echo      %userprofile%\AppData\Roaming\Microsoft\Windows\SendTo
@echo      --------------
@echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   PROGRAM DESCRIPTION:
rem @echo.
rem @echo    The program is designed to install shortcuts in the context menu.
rem @echo    After running the program, the following options will become available in the "Send to" menu:
rem @echo.
rem @echo      Files to Quest in OBB                    = send files to the headset to the OBB directory
rem @echo      Files to Quest in Movies                 = send files to the headset to the Movies directory
rem @echo      Files to Quest in Download               = send files to the headset to the Download directory
rem @echo      Files to Quest in the root of Sdcard     = send files to the headset to the root directory
rem @echo      APK+OBB Installation                     = installation of applications on the headset. 
rem @echo      Installation via INSTALL.TXT   [EXP]     = installation of applications via the install.txt script
rem @echo.
rem @echo    Additional actions are also available in the program:
rem @echo.
rem @echo      Install all shortcuts at once            = installing all six shortcuts at once
rem @echo      Remove installed shortcuts and files    = complete removal of everything previously installed
rem @echo.
rem @echo    Once the shortcuts are created, the program is no longer needed and can be set aside
rem @echo    until there is a need to add or remove shortcuts.
rem @echo.
rem @echo.
rem @echo   USING FUNCTIONS AFTER INSTALLING SHORTCUTS:
rem @echo.
rem @echo      Select one or more files with the mouse, for example, movies. Right-click
rem @echo      on the selected items, and in the context menu "Send to," choose the desired option,
rem @echo      for example, "Files to Quest in Movies."
rem @echo      The files will be copied to the headset in the corresponding directory.
rem @echo      If necessary, directories can also be selected/copied.
rem @echo. 
rem @echo      To install applications, right-click on the APK file or the game directory
rem @echo      and in the "Send to" menu, select "APK+OBB Installation." The game will be installed on the headset. 
rem @echo      If the game comes with an obb directory, it will be automatically copied where needed.
rem @echo      If there are multiple games in the directory, they will be installed one by one.
rem @echo.
rem @echo      Sometimes there is an install.txt file in the game directory. Usually, it contains commands
rem @echo      for individual or special installation/reinstallation of some games. For example,
rem @echo      games like Doom 3 or Beat Saber don't have obb directories, instead, they have many individual files.
rem @echo      Beat Saber often comes with BMBF, and the installation must be done
rem @echo      in a specific order. This installation scenario is in the install.txt file
rem @echo      Installation using it is the same as APK but through a separate shortcut.
rem @echo.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press any key to return to the menu ^<^<^<
rem EndEngTextBlock
@pause >nul
@cls
goto :_SendToMenu

:_hatqct
@cls
@echo ==================================================================================================
@echo          Quest Context Tool - created by Varset - v.1.1 - 13.08.23
@echo ==================================================================================================
@exit /b

:_hatmenuqct
@%verbecho%
@echo.
@echo.
rem StartRusTextBlock
@echo    0.  Выход из программы
@echo    M.  Выход в Главное меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    0.  Exit the program
rem @echo    M.  Return to the Main Menu
rem EndEngTextBlock
@exit /b

:_oculuslink
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Стартовать Oculus Link
@echo    B.  Отключить Oculus Link
@echo    C.  Включить AirLink
@echo    D.  Отключить AirLink
@echo    E.  Устранить проблему подключения Airlink
@echo    F.  Сделать бэкап параметров подключения Airlink
@echo    G.  Очистить остатки с компьютера после удаления Oculus ПО
@echo    H.  Рассчитать значения динамического битрейта для Oculus Debug Tool
@echo    I.  Сброс настроек Oculus Debug Tools к дефолтным установкам
@echo    J.  Скачать и запустить установщик Oculus ПО Meta Horizon Link
@echo    K.  Устранить ошибку подключения ПО Meta Link
@echo    L.  Найти и показать ошибки в логах установки Meta Link
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Start Oculus Link
rem @echo    B.  Disconnect Oculus Link
rem @echo    C.  Enable AirLink
rem @echo    D.  Disable AirLink
rem @echo    E.  Fix AirLink connection issue
rem @echo    F.  Backup AirLink parameters
rem @echo    G.  Clean after remove Oculus Home Software
rem @echo    H.  Calculate dynmaic bitrate
rem @echo    I.  Reset Oculus Debug Tools to default
rem @echo    J.  Download and run Meta Horizon Link Oculus software installer
rem @echo    K.  Fix error Meta Link connection
rem @echo    L.  Find and display errors in Meta Link installation logs

rem EndEngTextBlock
@echo.   
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _oculuslink
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _linkon)
if /i "%choice%"=="b" (GOTO _linkoff)
if /i "%choice%"=="c" (GOTO _alinkon)
if /i "%choice%"=="d" (GOTO _alinkoff)
if /i "%choice%"=="e" (GOTO _alinkdelmenu)
if /i "%choice%"=="f" (GOTO _alinkbackupmenu)
if /i "%choice%"=="g" (GOTO _oculusclean)
if /i "%choice%"=="h" (call :_offsetcalc)
if /i "%choice%"=="i" (GOTO _ODTDefaultResetMenu)
if /i "%choice%"=="j" (GOTO _MetaQuestLinkInstall)
if /i "%choice%"=="k" (GOTO _LinkConnectErrorFix)
if /i "%choice%"=="l" (GOTO _OculusSetupErrorsView)
@cls
goto _oculuslink


:_OculusSetupErrorsView
del /f /q OculusSetupErrors.txt 1>nul 2>nul
set ose=OculusSetupErrors.txt
findstr /B /L "[Error]" %LOCALAPPDATA%\Oculus\OculusSetup.log > %ose%
if not exist %LOCALAPPDATA%\Oculus\OculusSetup.log (
@echo  =========================================
rem StartRusTextBlock
@echo   %_fBYellow%Лог-файл %_fYellow%OculusSetup.log%_fBYellow% не обнаружен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Log file %_fYellow%OculusSetup.log%_fBYellow% not found%_fReset%
rem EndEngTextBlock
@echo  =========================================
call :_prevmenu
goto _oculuslink
)

for %%a in ("%ose%") do (
if %%~za==0 (
@echo  ======================================
rem StartRusTextBlock
@echo   %_fBGreen%Ошибок в логах установки  не найдено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%No errors found in the installation logs%_fReset%
rem EndEngTextBlock
@echo  ======================================
del /f /q "%ose%" 1>nul 2>nul
) else (
cls
@echo.
rem StartRusTextBlock
@echo   %_fBYellow%Найдены шибки в файле OculusSetup.log:%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Errors found in the OculusSetup.log file:%_fReset%
rem EndEngTextBlock
@echo  =========================================
type %ose%
)
)
@echo   --------------------
rem StartRusTextBlock
@echo   %_fBYellow%Этот список сохранен в файл %_fYellow%OculusSetupErrors.txt %_fBYellow%рядом с программой%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%This list has been saved to the file %_fYellow%OculusSetupErrors.txt %_fBYellow%next to the program%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto _oculuslink


:_LinkConnectErrorFix
call :_CheckAdminRights
set HOSTS=%SystemRoot%\System32\drivers\etc\hosts
set LINE=157.240.11.49 graph.oculus.com
findstr /C:"graph.oculus.com" "%HOSTS%" >nul
@echo ========================================
if %errorlevel%==0 (
rem StartRusTextBlock
@echo  %_fBYellow%Запись уже существует в файле hosts%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Entry already exists in the hosts file
rem EndEngTextBlock
) else (
@echo %LINE%>>"%HOSTS%"
ipconfig /flushdns 1>nul 2>nul
rem StartRusTextBlock
@echo  %_fBYellow%Запись добавлена в hosts
@echo  Проверьте подключение Meta Link%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Entry added to hosts
rem @echo  Check Meta Link connection
rem EndEngTextBlock
)
rem @echo 157.240.11.49 graph.oculus.com >> %SystemRoot%\System32\drivers\etc\hosts
@goto _returnmenu


:_linkon
@%MYFILES%\adb shell am start -S com.oculus.xrstreamingclient/.MainActivity 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Oculus Link запущен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Oculus Link has started
rem EndEngTextBlock
@goto _returnmenu

:_linkoff
@%MYFILES%\adb shell am force-stop com.oculus.xrstreamingclient 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Oculus Link отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Oculus Link has been disconnected
rem EndEngTextBlock
@goto _returnmenu

:_alinkon
@%MYFILES%\adb shell am broadcast -a "com.oculus.systemux.action.TOGGLE_AIRLINK" --ez enable_airlink 1 1>nul 2>nul
call :_erlvl
@echo ========================================
rem StartRusTextBlock
@echo  Oculus AirLink запущен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Oculus AirLink has started
rem EndEngTextBlock
@goto _returnmenu

:_alinkoff
@%MYFILES%\adb shell am broadcast -a "com.oculus.systemux.action.TOGGLE_AIRLINK" --ez enable_airlink 0 1>nul 2>nul
call :_erlvl
@echo  ======================================== 
rem StartRusTextBlock
@echo  = Oculus AirLink отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Oculus AirLink has been disconnected
rem EndEngTextBlock
@goto _returnmenu

:_alinkdelmenu
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo		0. Выход из программы
@echo		M. Выход в меню
@echo.
@echo	    Enter. Подтвердить удаление параметров сопряжения
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo		0. Exit program
rem @echo		M. Exit menu
rem @echo.
rem @echo	    Enter. Confirm deleting pairing settings
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  ВНИМАНИЕ!
@echo.
@echo    Процедура удалит некоторые файлы и записи реестра. 
@echo.
@echo.
@echo.
@echo  Будут удалены следующие файлы:
@echo.
@echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert.pem
@echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert_v55.pem
@echo.
@echo.
@echo  Ветки реестра и параметры:
@echo.
@echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing
@echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing_v55
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     ATTENTION!
rem @echo.
rem @echo  The procedure will remove some files and registry 
rem @echo.
rem @echo.
rem @echo.
rem @echo  The following directories and files will be deleted:
rem @echo.
rem @echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert.pem
rem @echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert_v55.pem
rem @echo.
rem @echo  Registry values and parameters will be deleted:
rem @echo.
rem @echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing
rem @echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing_v55
rem @echo.
rem @echo.
rem @echo.
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem set choice=
set "choice=1"
rem StartRusTextBlock
Set /p choice="Выберите опцию меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem Set /p choice="Choose menu option and press Enter: "
rem EndEngTextBlock
rem call :_MenuChoiceEnter
@echo.
if not defined choice goto _alinkdelmenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="1" (GOTO _alinkdel)
goto _alinkdelmenu

:_alinkdel
@del /F /Q %userprofile%\AppData\Local\Oculus\Airlink\cert*.pem  2>&1 1> nul | findstr /i /V "" 1> nul 2>&1
rem StartRusTextBlock
if %errorlevel% == 0 @echo = Файл cert*.pem не найден && @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem if %errorlevel% == 0 @echo = File cert*.pem not found && @goto _returnmenu
rem EndEngTextBlock
rem reg delete "HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing" /f
rem  1>nul 2>nul
reg delete "HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing_V55" /f
rem 1>nul 2>nul
@echo  ======================================== 
rem StartRusTextBlock
@echo  = Файл cert.pem удален
@echo  = Файл cert_v55.pem удален
@echo  = Параметры реестра удалены
@echo.
@echo  ...Перезапуск сервисов Oculus, ждите...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = File cert.pem deleted
rem @echo  = File cert_v55.pem deleted
rem @echo  = Registry parameters removed
rem @echo.
rem @echo  ...Restarting Oculus services, please wait...
rem EndEngTextBlock
call :_checkservices
@net stop OVRservice 1>nul 2>nul
@net start OVRservice  1>nul 2>nul
@echo ---
rem StartRusTextBlock
@echo  Попробуйте снова связять шлем по Airlink
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Try to reconnect the headset via Airlink
rem EndEngTextBlock
goto _returnmenu


:_alinkbackupmenu
@%verbecho%
@cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo		0. Выход из программы
@echo		M. Выход в меню
@echo.
@echo	Enter. Подтвердить бэкап настроек
@echo.
@echo.
@echo.
@echo.
@echo  ВНИМАНИЕ!
@echo.
@echo    Процедура сохранит файлы сертификатов и записи реестра. 
@echo.
@echo.
@echo.
@echo  Будут сохранены следующие файлы:
@echo.
@echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert.pem
@echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert_v55.pem
@echo.
@echo.
@echo  Ветки реестра и параметры:
@echo.
@echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing
@echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing_v55
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo		0. Exit program
rem @echo		M. Exit menu
rem @echo.
rem @echo	Enter. Confirm backup pairing settings
rem @echo.
rem @echo.
rem @echo.
rem @echo     ATTENTION!
rem @echo.
rem @echo  The procedure will save certificate files and registry entries
rem @echo.
rem @echo.
rem @echo.
rem @echo  The following directories and files will be saved:
rem @echo.
rem @echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert.pem
rem @echo      C:\Users\%username%\AppData\Local\Oculus\Airlink\cert_v55.pem
rem @echo.
rem @echo  Registry values and parameters will be saved:
rem @echo.
rem @echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing
rem @echo      HKCU\SOFTWARE\Oculus\RemoteHeadset\AirLinkPairing_v55
rem @echo.
rem @echo.
rem @echo.
rem EndEngTextBlock
rem set choice=
set "choice=1"
rem StartRusTextBlock
Set /p choice="Выберите опцию меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem Set /p choice="Choose menu option and press Enter: "
rem EndEngTextBlock
rem call :_MenuChoiceEnter
@echo.
if not defined choice goto _alinkbackupmenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="1" (GOTO _alinkbackup)
goto _alinkbackupmenu

:_alinkbackup
@echo  ----------------------------------------
@xcopy /F /Q C:\Users\%username%\AppData\Local\Oculus\Airlink\cert*.pem *.* 1>nul 2>nul
rem StartRusTextBlock
@if errorlevel == 1 echo  = Файлы сертификатов не найдены
rem EndRusTextBlock
rem StartEngTextBlock
rem @if errorlevel == 1 echo  = No certificate files found
rem EndEngTextBlock
@reg export "HKCU\SOFTWARE\Oculus\RemoteHeadset" RemoteHeadset.reg 1>nul 2>nul
rem StartRusTextBlock
if errorlevel == 1 echo  = Параметры реестра не найдены
rem EndRusTextBlock
rem StartEngTextBlock
rem @if errorlevel == 1 echo  = Registry settings not found
rem EndEngTextBlock
@echo  ======================================== 
rem StartRusTextBlock
@echo  Параметры и файлы сохранены в текущем каталоге
@echo  [если они найдены]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Settings and files are saved in the current directory
rem @echo  [if it found]
rem EndEngTextBlock
@goto _returnmenu

:_oculusclean
@%verbecho%
@cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo  ВНИМАНИЕ!
@echo.
@echo    Процедура удалит мусорные каталоги, файлы и записи реестра, оставшиеся после удаления Oculus ПО. 
@echo    Еще раз убедитесь, что вы удалили Oculus ПО и перезагрузили компьютер после этого.
@echo.
@echo  Будут удалены следующие каталоги и файлы:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     ATTENTION!
rem @echo.
rem @echo  The procedure will remove some directories, files and registry 
rem @echo  entries left after uninstalling the Oculus software.
rem @echo  Make sure you uninstall the Oculus software and restarted your computer after it.
rem @echo.
rem @echo  The following directories and files will be deleted:
rem EndEngTextBlock
@echo.
@echo      C:\Program Files\Oculus
@echo      C:\ProgramData\Oculus
@echo      %userprofile%\AppData\Local\Oculus
@echo      %userprofile%\AppData\LocalLow\Oculus
@echo      %userprofile%\AppData\Roaming\Oculus
@echo      %userprofile%\AppData\Roaming\OculusClient
@echo      %userprofile%\Documents\Dash
@echo      %userprofile%\Documents\Oculus Home
@echo      %userprofile%\AppData\Local\Oculus\Airlink\*.pem
@echo      %userprofile%\AppData\Local\Temp\Oculus
@echo.
@echo.
rem StartRusTextBlock
@echo  Ветки реестра и параметры:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Registry values and parameters will be deleted:
rem EndEngTextBlock
@echo.
@echo      HKEY_CURRENT_USER\SOFTWARE\Oculus
@echo      HKEY_CURRENT_USER\SOFTWARE\Oculus VR, LLC
@echo      HKEY_CURRENT_USER\SOFTWARE\Classes\oculus
@echo      HKEY_LOCAL_MACHINE\SOFTWARE\Oculus
@echo      HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Oculus VR, LLC
@echo      HKEY_CLASSES_ROOT\oculus
@echo      HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Oculus
@echo      HKLM\SOFTWARE\WOW6432Node\Khronos\OpenXR\1\AvailableRuntimes:
rem StartRusTextBlock
@echo        Параметр:  C:\Program Files\Oculus\Support\oculus-runtime\oculus_openxr_32.json
@echo   HKLM\SOFTWARE\Khronos\OpenXR\1\AvailableRuntimes:
@echo        Параметр:  С:\Program Files\Oculus\Support\oculus-runtime\oculus_openxr_64.json
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo          Parameter:  C:\Program Files\Oculus\Support\oculus-runtime\oculus_openxr_32.json
rem @echo      HKLM\SOFTWARE\Khronos\OpenXR\1\AvailableRuntimes:
rem @echo          Parameter:  С:\Program Files\Oculus\Support\oculus-runtime\oculus_openxr_64.json
rem EndEngTextBlock
@echo     -----
@echo.
@set "choice="
rem StartRusTextBlock
@Set /p choice="Для подтверждения удаления введите "ok" без кавычек и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="For confirmation enter "ok" without quotas and press Enter: "
rem EndEngTextBlock
if not defined choice goto _guardian
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="ok" (GOTO _oculuscleandelete)
goto _oculusclean

:_oculuscleandelete
@sc delete OculusRemoteDesktopService 1>nul 2>nul
@rd /s /q "C:\Program Files\Oculus\" 1>nul 2>nul
@rd /s /q "%userprofile%\AppData\Local\Oculus\" 1>nul 2>nul
@rd /s /q "%userprofile%\AppData\LocalLow\Oculus\" 1>nul 2>nul
@rd /s /q "%userprofile%\AppData\Roaming\Oculus\" 1>nul 2>nul
@rd /s /q "%userprofile%\AppData\Roaming\OculusClient\" 1>nul 2>nul
@rd /s /q "C:\ProgramData\Oculus\" 1>nul 2>nul
@rd /s /q "%userprofile%\Documents\Dash\" 1>nul 2>nul
@rd /s /q "%userprofile%\Documents\Oculus Home" 1>nul 2>nul
@reg delete "HKEY_CURRENT_USER\SOFTWARE\Oculus" /f 1>nul 2>nul
@reg delete "HKEY_CURRENT_USER\SOFTWARE\Oculus VR, LLC" /f 1>nul 2>nul
@reg delete "HKEY_CURRENT_USER\SOFTWARE\Classes\oculus" /f 1>nul 2>nul
@reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Oculus" /f 1>nul 2>nul
@reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Oculus VR, LLC" /f 1>nul 2>nul
@reg delete "HKEY_CLASSES_ROOT\oculus" /f 1>nul 2>nul
@reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Oculus" /f 1>nul 2>nul
@reg delete HKLM\SOFTWARE\WOW6432Node\Khronos\OpenXR\1\AvailableRuntimes /v "C:\Program Files\Oculus\Support\oculus-runtime\oculus_openxr_32.json" /f 1>nul 2>nul
@reg delete HKLM\SOFTWARE\Khronos\OpenXR\1\AvailableRuntimes /v "C:\Program Files\Oculus\Support\oculus-runtime\oculus_openxr_64.json" /f 1>nul 2>nul
@del "%userprofile%\AppData\Local\Oculus\Airlink\*.pem" /q 1>nul 2>nul
@for /d %%a in ("%userprofile%\AppData\Local\Temp\Oculus*") do @rd /s /q "%%a" 1>nul 2>nul
@echo  ======================================== 
rem StartRusTextBlock
rem @echo = Done
rem @echo   Now you can reinstall Oculus Home software
rem EndRusTextBlock
rem StartEngTextBlock
@echo  = Остатки почищены
@echo   Сейчас можно переустанавливать Oculus ПО
rem EndEngTextBlock
call :_prevmenu
goto _oculuslink


:_offsetcalc
@echo  ======================================== 
rem StartRusTextBlock
@echo  Процедура поможет рассчитать, какие значение следует выбирать
@echo  при установке динамического битрейта
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo This procedure will help calculate which values should be selected
rem @echo when setting up dynamic bitrate.
rem EndEngTextBlock
@echo  ---
rem StartRusTextBlock
@echo  Для возврата в меню введите 0
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Enter 0 for return to menu
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@Set /p reqminbitrate="Введите желаемый минимальный битрейт: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p reqminbitrate="Enter the desired minimal bitrate: "
rem EndEngTextBlock
if /i "%reqminbitrate%"=="0" (exit /b)
@set /a offsetnumber=%reqminbitrate%-10
@echo.
rem StartRusTextBlock
@Set /p reqmaxbitrate="Введите желаемый максимальный битрейт: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p reqmaxbitrate="Enter the desired maximal bitrate: "
rem EndEngTextBlock
if /i "%reqmaxbitrate%"=="0" (exit /b)
@set /a maxbitratenumber=%reqmaxbitrate%-%offsetnumber%
@echo.
@echo ------
rem StartRusTextBlock
@echo Впишите следующие значения в таблицу ODT:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Enter the following values into the ODT table:
rem EndEngTextBlock
@echo.
@echo Dynamic Offset	: %offsetnumber%
@echo Dynamic Max	: %maxbitratenumber%
@echo --------------------------------------------
@echo.
@echo.
@echo.
rem @echo ^>^>^> Нажмите любую кнопку для возврата в Главное меню ^<^<^<
rem @echo  -----
rem @echo ^>^>^> Press any key to return to the main menu ^<^<^<
rem @pause >nul
@echo.
goto _returnmenu

:_MetaQuestLinkInstall
@echo.
@echo.
if exist OculusSetup.exe goto _StartMetaQuestLinkInstall
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo = Скачивание...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Downloading...
rem EndEngTextBlock
@curl -LJko "OculusSetup.exe" https://www.oculus.com/download_app/?id=1582076955407037 -#
:_StartMetaQuestLinkInstall
rem set disknumber=%choice:~1%
rem if disknumber==r call :_setdisknumber
rem set "setdrive= /drive=%disknumber%"
rem if not defined disknumber set setdrive=

call :_setdisknumber

@echo ---
rem StartRusTextBlock
@echo = Установка Meta Quest Link на диск %disknumber%
@echo   Следуйте инструкциям установщика Oculus.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = Installing Meta Link on drive %disknumber%
rem @echo   Follow the Oculus installer instructions
rem EndEngTextBlock
@start " " OculusSetup.exe%setdrive%
@echo.
goto _returnmenu


:_setdisknumber
cls
@echo.
@echo.
set disknumber=C
rem StartRusTextBlock
@echo   Для установки по умолчанию на диск %_fBYellow%C%_fReset% просто нажмите %_fBYellow%Enter%_fReset%.
@echo   Чтобы установить Meta Link на другой диск, введите его букву и нажмите %_fBYellow%Enter%_fReset%
@echo   Для выхода в меню без установки введите %_fBYellow%0%_fReset% и нажмите %_fBYellow%Enter%_fReset%
@echo.
@echo.
@Set /p disknumber="Введите букву диска для установки (%_fBYellow%от C до Z%_fReset%) и нажмите %_fBYellow%Enter:%_fReset% "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   To install by default on disk C just press Enter.
rem @echo   To install Meta Link on another disk, enter its letter and press Enter
rem @echo   To return to the menu without installation, enter 0 and press Enter
rem @echo.
rem @echo.
rem @Set /p disknumber="Enter the disk letter for installation (from C to Z) and press Enter: "
rem EndEngTextBlock
if not defined disknumber goto _setdisknumber
if "%disknumber%"=="0" (goto _oculuslink)
@echo.%disknumber%|>nul findstr /rc:"[^c-zC-Z]"
if errorlevel 1 (
set "setdrive= /drive=%disknumber%"
exit /b
) else (
@echo.
@echo.
@echo  -------------------------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBRed%Неверный ввод! Допустимы только буквы от C до Z или 0 для выхода в меню.%_fReset%
@echo.
@echo              Нажмите любую кнопку для повтора ввода
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%Invalid input! Only letters from C to Z or 0 to return to the menu are allowed.%_fReset%
rem @echo.
rem @echo              Press any key to retry input
rem EndEngTextBlock
@echo  -------------------------------------------------------------------------
pause >nul
goto _setdisknumber
)


:_guardian
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    D.  Приостановить Защитную систему
@echo    E.  Возобновить Защитную систему
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    D.  Suspend Guardian
rem @echo    E.  Resume Guardian
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _guardian
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="d" (GOTO _guardoff)
if /i "%choice%"=="e" (GOTO _guardon)
cls
goto _guardian

:_guardoff
@%MYFILES%\adb shell setprop debug.oculus.guardian_pause 1 1>nul 2>nul
call :_erlvl
@echo ======================================== 
rem StartRusTextBlock
@echo  Защитная зона приостановлена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Guardian suspended
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_guardon
@%MYFILES%\adb shell setprop debug.oculus.guardian_pause 0 1>nul 2>nul
call :_erlvl
@echo ======================================== 
rem StartRusTextBlock
@echo  Защитная зона возобновлена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Guardian resumed
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_proxsensor
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    D.  Отключить датчик приближения
@echo    E.  Включить датчик приближения
@echo.
@echo.
@echo  ВНИМАНИЕ:
@echo.
@echo       После отключения датчика экран не будет гаснуть автоматически!
@echo       Это чревато ускоренным разрядом аккумулятора.
@echo       Не забывайте включать датчик.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    D.  Disable Proximity Sensor
rem @echo    E.  Enable Proximity Sensor
rem @echo.
rem @echo.
rem @echo  WARNING:
rem @echo.
rem @echo       After disabling the sensor, the screen will not automatically turn off!
rem @echo       This can lead to accelerated battery discharge.
rem @echo       Don't forget to enable the sensor.
rem @echo.
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _proxsensor
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="d" (GOTO _proxoff)
if /i "%choice%"=="e" (GOTO _proxon)
cls
goto _proxsensor

:_proxoff
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
call :_erlvl
@echo ======================================== 
rem StartRusTextBlock
@echo  Датчик приближения отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Proximity sensor disabled
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

:_proxon
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
call :_erlvl
@echo ======================================== 
@If %ERRORLEVEL% EQU 1 GOTO _errlevel
rem StartRusTextBlock
@echo  Датчик приближения включен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Proximity sensor enabled
rem EndEngTextBlock
call :_prevmenu
@goto _shellmenu

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_streamingmenu
@%verbecho%
setlocal enableextensions enabledelayedexpansion
call :_setfwtxt
cls
call :_settime
call :_hat
@echo.
rem StartRusTextBlock
@echo                               === МЕНЮ ТРАНСЛЯЦИИ ===
call :_hatmenu
@echo.
@echo.
@echo    A.  %_fBCyan%"Быстрая" трансляция: формат 16 х 9%_fCyan% [FPS=30, Bitrate=10]%_fReset%
@echo         [ в этом режиме отключается датчик приближения! ]
@echo.
@echo    B.  %_fBCyan%"Квадратная" трансляция: кроп с одного глаза без углов%_fCyan% [FPS=60, Bitrate=30]%_fReset%
@echo         [ подходит для создания демороликов     ]
@echo.
@echo    C.  %_fBCyan%"Прямоугольная" трансляция: 16 x 9%_fCyan%  [FPS=60, Bitrate=30 ]%_fReset%
@echo         [ подходит для демонстрационных целей ]
@echo.
@echo    D.  %_fBCyan%"Стереотрансляция": ничего не кропается, картинка с обоих глаз%_fCyan%  [FPS=60, Bitrate=20 ]%_fReset%
@echo         [ подходит для создания 3D роликов      ]
@echo.
@echo    E.  %_fBCyan%"Ручная" трансляция: выбор и установка параметров трансляции вручную.%_fReset%
@echo         [для тех, кто привык все контролировать сам]
@echo.
@echo    F.  %_fBCyan%Установка программы трансляции%_fReset%
@echo         [независимая отдельная программа, запускается ярлыком]
@echo.
@echo.
@echo   ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo   После старта трансляции картинка может пропасть на 3-4 секунды,
@echo   а шлем скажет "блым". Это связано с всплывающим в шлеме ссобщением,
@echo   например, о том, что контроллеры не найдены. Увы, но вот так.
@echo. 
@echo   При необходимости можно отключить датчик приближения, пункты E -^> F в Главном меню.
@echo   Для режима ручной трансляции это можно сделать в процессе выбора параметров.
@echo.
@echo   Для запуска трансляции с сохранением в файл
@echo   введите сдвоенный номер пункта, например AA, bb и т.д.
@echo   В противном случае трансляция записана не будет.
@echo.
@echo   Когда решите прекратить трансляцию, просто закройте окно с картинкой
@echo   и нажмите любую кнопку в основном окне, это вернет вас в Главное меню,
@echo   а файл с записью (если она велась) будет сохранен в текущем каталоге.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo                               === TRANSLATION MODULE ===
rem call :_hatmenu
rem @echo.
rem @echo.
rem @echo    A.  %_fBCyan%"Fast" streaming: format 16 x 9%_fCyan% [FPS=30, Bitrate=10, sound on all devices]%_fReset%
rem @echo         [ in this mode the proximity sensor is disabled! ]
rem @echo.
rem @echo    B.  %_fBCyan%"Square" streaming: crop image from one eye without black corners%_fCyan% [FPS=60, Bitrate=30]%_fReset%
rem @echo         [ suitable for creating demos ]
rem @echo.
rem @echo    C.  %_fBCyan%"Rectangular" streaming: format 16 x 9%_fCyan% [FPS=60, Bitrate=30]%_fReset%
rem @echo         [ suitable for demonstration purposes ]
rem @echo.
rem @echo    D.  %_fBCyan%"Stereo streaming": nothing is cropped, image from both eyes%_fCyan% [FPS=60, Bitrate=20]%_fReset%
rem @echo         [ suitable for creating 3D videos ]
rem @echo.
rem @echo    E.  %_fBCyan%"Manual" streaming: selection and setting of streaming parameters manually%_fReset%
rem @echo         [ for those who prefer full control ]
rem @echo.
rem @echo    F.  %_fBCyan%Install the casting application%_fReset%
rem @echo         [independent standalone application, launched via shortcut]
rem @echo.
rem @echo.
rem @echo   PLEASE NOTE:
rem @echo.
rem @echo   After starting the streaming, the image may disappear for 3-4 seconds,
rem @echo   and the headset will say "blym". This is due to a popup message in the headset,
rem @echo   for example, about controllers not being found. Unfortunately, that's how it is.
rem @echo. 
rem @echo   If necessary, you can disable the proximity sensor, points C -^> F in the Main menu.
rem @echo   For manual streaming mode, this can be done during parameter selection.
rem @echo.
rem @echo   To start streaming with recording to a file
rem @echo   enter the double number of the item, for example, AA, bb, etc.
rem @echo   Otherwise, the streaming will not be recorded.
rem @echo.
rem @echo   When you decide to stop streaming, simply close the window with the picture
rem @echo   and press any key in the main window, this will return you to the Main menu,
rem @echo   and the recording file (if any) will be saved in the current directory.
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _streamingmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _streamfast)
if /i "%choice%"=="aa" (GOTO _streamfastr)
if /i "%choice%"=="b" (GOTO _streamsquare)
if /i "%choice%"=="bb" (GOTO _streamsquarer)
if /i "%choice%"=="c" (GOTO _streamcircle)
if /i "%choice%"=="cc" (GOTO _streamcircler)
if /i "%choice%"=="d" (GOTO _streamstereo)
if /i "%choice%"=="dd" (GOTO _streamstereor)
if /i "%choice%"=="e" (GOTO _ManualTransSettings)
if /i "%choice%"=="f" (GOTO _MQDHCastingMenu)
rem if /i "%choice%"=="1" (set profnumb=1 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="2" (set profnumb=2 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="3" (set profnumb=3 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="4" (set profnumb=4 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="5" (set profnumb=5 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="6" (set profnumb=6 GOTO _FastLoadIntMultiProfile)

cls
goto _streamingmenu

:_MQDHCastingMenu
cls
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Установить программу трансляции Casting
@echo    B.  Удалить программу трансляции Casting
@echo    C.  Скопировать скриншоты и видеошоты из шлема на ПК
@echo.
@echo.
@echo.
@echo      %_fBYellow%ОБРАТИТЕ ВНИМАНИЕ:%_fReset%
@echo.
@echo   Программа %_fBYellow%Casting%_fReset% представляет собой отдельный модуль трансляции из приложения 
@echo   %_fBYellow%Meta Quest Developer Hub%_fReset%. Этот модуль запакован в архив с bat файлом, который отвечает
@echo   за запуск программы Casting. Периодически версия модуля будет обновляться.
@echo.
@echo   Установка программы %_fBYellow%Casting%_fReset% скачает архив с программой, распакует его в каталог %_fBYellow%%systemdrive%\Temp\Casting%_fReset%
@echo   и поместит ярлык запуска на Рабочий стол. При запуске шлем может быть подключен к ПК по WiFi,
@echo   в этом случае программа автоматически найдет шлем и запустит трансляцию по беспроводу.
@echo   В ином случае шлем должен быть подключен кабелем к ПК, а после начала трансляции кабель можно
@echo   отключить. Затем подключение всякий раз будет осуществляться по WiFi, пока шлем подсоединен к ПК
@echo   по беспроводному подключению. Кабель можно не отключать, это не помешает трансляции.
@echo.
@echo   После запуска %_fBYellow%Casting%_fReset% многие параметры трансляции можно настроить, они сохранятся в реестре.
@echo   Также программа позволяет записывать видео и делать скриншоты, которые будут сохранены на шлеме
@echo   в каталоге %_fBYellow%\sdcard\Documents%_fReset%. Их можно скопировать на ПК, они будут располагаться в каталоге
@echo   %_fBYellow%QuestMedia\Casting%_fReset%, созданном на Рабочем столе при копировании. Удаление программы сотрет
@echo   каталог %_fBYellow%%systemdrive%\Temp\Casting%_fReset% и ярлык запуска с Рабочего стола. Каталог %_fBYellow%QuestMedia\Casting%_fReset%
@echo   останется нетронутым.
@echo.
@echo   Ярлык на Рабочий можно сделать самостоятельно, например, чтобы поменять язык сообщений
@echo   программы. По умолчанию ярлык будет создан, ориентируясь на интерфейс системы.
@echo   Для смены ярлыка зайдите в каталог %_fBYellow%%systemdrive%\Temp\Casting%_fReset% и скопируйте на Рабочий стол
@echo   файл %_fBYellow%Casting_eng%_fReset% или %_fBYellow%Casting_rus%_fReset% для желаемого языка.
@echo.
@echo   После запуска трансляции можно включить управление картинкой - смещать вверх и вниз, 
@echo   поворачивать в разные стороны. Для этого нажмите иконку мыши в центре внизу окна.
@echo.
@echo   Чтобы завершить трансляцию, закройте окно крестиком справа-вверху.
@echo   Окно может не закрываться сразу, иногда требуется некоторое время на его закрытие.
@echo.
@echo   %_fBRed%Закрывайте окно не раньше чем через 10 секунд после начала трансляции, иначе процесс
@echo   %_fBYellow%Casting.exe %_fBRed%не завершится. Это может привести к медленной работе компьютера%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Install the Casting streaming application
rem @echo    B.  Uninstall the Casting streaming application
rem @echo    C.  Copy screenshots and video shots from the headset to the PC
rem @echo.
rem @echo.
rem @echo      %_fBYellow%PLEASE NOTE:%_fReset%
rem @echo.
rem @echo   The %_fBYellow%Casting%_fReset% application is a standalone streaming module from the %_fBYellow%Meta Quest Developer Hub%_fReset%
rem @echo   app. This module is packaged into an archive together with a bat file that is responsible
rem @echo   for launching the Casting application. The module version will be updated periodically.
rem @echo.
rem @echo   After launching %_fBYellow%Casting%_fReset%, many streaming parameters can be configured; they will be saved in the
rem @echo   registry. The application also allows recording video and taking screenshots, which will be
rem @echo   saved on the headset in the directory %_fBYellow%\sdcard\Documents%_fReset%. They can be copied to the PC and
rem @echo   will be placed in the %_fBYellow%QuestMedia\Casting%_fReset% directory created on the Desktop during copying.
rem @echo   Uninstalling the application will delete the directory %_fBYellow%%systemdrive%\Temp\Casting%_fReset% and the launch shortcut
rem @echo   from the Desktop. The %_fBYellow%QuestMedia\Casting%_fReset% directory will remain untouched.
rem @echo.
rem @echo   Installing the %_fBYellow%Casting%_fReset% application will download the archive with the program, extract it to the
rem @echo   directory %_fBYellow%%systemdrive%\Temp\Casting%_fReset% and place a launch shortcut on the Desktop. When launching, the
rem @echo   headset may be connected to the PC via Wi-Fi; in this case, the application will automatically
rem @echo   find the headset and start wireless streaming. Otherwise, the headset must be connected to the
rem @echo   PC via cable, and after the stream starts, the cable can be disconnected. After that, the
rem @echo   connection will be established via Wi-Fi each time, as long as the headset is connected to the
rem @echo   PC wirelessly. The cable does not have to be disconnected; it will not interfere with streaming.
rem @echo.
rem @echo   You can create a Desktop shortcut yourself, for example, to change the language of the program
rem @echo   messages. By default, the shortcut will be created based on the system interface language.
rem @echo   To change the shortcut, go to the directory %_fBYellow%%systemdrive%\Temp\Casting%_fReset% and copy to the Desktop the file
rem @echo   %_fBYellow%Casting_eng%_fReset% or %_fBYellow%Casting_rus%_fReset% for the desired language.
rem @echo.
rem @echo   After starting the stream, you can enable image control — move it up and down, and rotate it in
rem @echo   different directions. To do this, click the mouse icon in the center at the bottom of the window.
rem @echo.
rem @echo   To stop streaming, close the window using the X button in the upper-right corner.
rem @echo   The window may not close immediately; sometimes it takes a little time to close.
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto :_MQDHCastingMenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO :_MQDHCastingInstall)
if /i "%choice%"=="b" (GOTO :_MQDHCastingDeleteReq)
if /i "%choice%"=="c" (GOTO :_MQDHCastingScreensCopy)
cls
goto :_MQDHCastingMenu


:_MQDHCastingInstall
@echo   ----------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Скачивание...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBYellow%= Downloading...%_fReset%
rem EndEngTextBlock
set dlappl=Casting.zip
rem set dlcat=%dlappl:~0,-4%

rem @rd %cd%\%dlcat% /Q /S 1>nul 2>nul
rem @del %dlappl% /Q 1>nul 2>nul
set curllink=https://www.dropbox.com/scl/fi/ndb54i058lm5stzms0e2b/Casting.zip?rlkey=6xksd23fmi0eq47k921xdc9zu
@curl -LJko %dlappl% %curllink% -# 1>nul

rem set "startfile=_installdrv.cmd"
@echo   ----------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Установка...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%Installing...%_fReset%
rem EndEngTextBlock
@%myfiles%\7z.exe x "%cd%\%dlappl%" -o"%systemdrive%\Temp\" -y 1>NUL 2>nul
@chcp 866 1>nul
for /f %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\MUI\UILanguages"2^>nul') do (
set "UILANG=%%~nxA"
goto :_UILangDone
)
:_UILangDone
if /i "%UILANG%"=="ru-RU" (
@copy /y "%systemdrive%\Temp\Casting\Casting_rus.lnk" %userprofile%\Desktop\Casting.lnk 1>nul 2>nul
) else (
@copy /y "%systemdrive%\Temp\Casting\Casting_eng.lnk" %userprofile%\Desktop\Casting.lnk 1>nul 2>nul
)
@chcp 65001 >nul
@del %dlappl% /Q 1>nul 2>nul
echo.
@echo   -------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%Программа %_fGreen%Casting %_fBGreen%установлена
@echo   %_fBYellow%Для запуска используйте ярлык %_fYellow%Casting %_fBYellow%на Рабочем столе%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%The %_fGreen%Casting %_fBGreen%application has been installed
rem @echo   %_fBYellow%To launch it, use the %_fYellow%Casting %_fBYellow%shortcut on the Desktop%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto :_MQDHCastingMenu


:_MQDHCastingDeleteReq
rem StartRusTextBlock
@echo   %_fBYellow%Для подтверждения удаления нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%For delete confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto :_MQDHCastingMenu
if "!KEY!"=="13" goto :_MQDHCastingDelete
goto :_MQDHCastingMenu

:_MQDHCastingDelete
taskkill /im adb.exe /f 1>nul 2>nul
@rd  /q /s %systemdrive%\Temp\Casting\ 1>nul 2>nul
@chcp 866 1>nul
@del /q /f "%userprofile%\Desktop\Casting.lnk" 1>nul 2>nul
@chcp 65001 >nul
@echo   -------------------------------------
rem StartRusTextBlock
@echo    %_fBYellow%Программа %_fYellow%Casting %_fBYellow%удалена%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%The %_fYellow%Casting %_fBYellow%app deleted%_fReset%
rem EndEngTextBlock
call :_prevmenu
goto :_MQDHCastingMenu


:_MQDHCastingScreensCopy
rem StartRusTextBlock
@echo  %_fBYellow%..Начато копирование скриншотов и видео...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fBYellow%.. Copying srceenshots and videoshots started..%_fReset%
rem EndEngTextBlock
@echo.
@chcp 866 1>nul
set DEST=%userprofile%\Desktop\QuestMedia\Casting
:: Создать папку, если нет
md "%DEST%" 1>nul 2>nul
@chcp 65001 >nul
:: Перебираем все файлы в /sdcard/Documents
for /f "delims=" %%F in ('%MYFILES%\adb shell "ls /sdcard/Documents"') do (
rem Получаем имя файла без лишних символов
set FILE=%%F
rem Проверяем, существует ли уже такой файл
@chcp 866 1>nul
if not exist "%DEST%\!FILE!" (
@chcp 65001 >nul
rem StartRusTextBlock
@echo   %_fCyan%= Копируем %_fBCyan%!FILE!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fCyan%= Copying %_fBCyan%!FILE!%_fReset%
rem EndEngTextBlock
@chcp 866 1>nul
%MYFILES%\adb pull "/sdcard/Documents/!FILE!" "%DEST%" 1>nul 2>nul
@chcp 65001 >nul
) else (
rem StartRusTextBlock
@echo   %_fYellow%= Пропускаем %_fBCyan%!FILE! %_fBYellow%— файл существует%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fYellow%= Skipping %_fBCyan%!FILE! %_fBYellow%— file already exists%_fReset%
rem EndEngTextBlock
)
)
rem call :_erlvl
@echo ========================================
rem StartRusTextBlock
@chcp 65001 >nul
@echo  %_fBGreen%Скриншоты скопированы в каталог %_fGreen%QuestMedia\Casting %_fBGreen%на Рабочий стол
@echo  Каталог будет открыт через пару секунд%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBGreen%Screenshots were copied to the %_fGreen%QuestMedia\Casting directory %_fBGreen%on the Desktop
rem @echo  The directory will open in a couple of seconds%_fReset%
rem EndEngTextBlock
@ping localhost >nul
@chcp 866 1>nul
@explorer "%DEST%" >nul
@chcp 65001 >nul
call :_prevmenu
goto _MQDHCastingMenu


:_streamfast
rem call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1920:1200:100:400
set angleset=--angle=22
) else (
set cropset=1600:900:2017:510
)
set bitrateset=10M
set setfps=30
set recfile=
call :_CheckWiFiMode
set acodecset=--audio-source=mic
goto :_createvbs

:_streamfastr
rem call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1920:1200:100:400
set angleset=--angle=22
) else (
set cropset=1600:900:2017:510
)
set bitrateset=10M
set setfps=30
call :_RecordEnableSettings
call :_CheckWiFiMode
set acodecset=--audio-source=mic
goto :_createvbs

:_streamsquare
rem call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1584:1440:350:350
set angleset=--angle=22
) else (
set cropset=1584:1440:1950:250
)
set bitrateset=30M
set setfps=60
set recfile=
call :_CheckWiFiMode
goto :_createvbs

:_streamsquarer
rem call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1584:1440:350:350
set angleset=--angle=22
) else (
set cropset=1584:1440:1950:250
)
set bitrateset=30M
set setfps=60
call :_RecordEnableSettings
call :_CheckWiFiMode
goto :_createvbs

:_streamcircle
rem call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1920:1200:100:400
set angleset=--angle=22
) else (
set cropset=1600:900:2017:510
)
set bitrateset=30M
set setfps=60
set recfile=
call :_CheckWiFiMode
goto :_createvbs

:_streamcircler
rem call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1920:1200:100:400
set angleset=--angle=22
) else (
set cropset=1600:900:2017:510
)
set bitrateset=30M
set setfps=60
call :_RecordEnableSettings
call :_CheckWiFiMode
goto :_createvbs

:_streamstereo
rem call :_cdc
set cropset=3664:1920:0:0
set bitrateset=20M
set setfps=60
set recfile=
call :_CheckWiFiMode
goto :_createvbs

:_streamstereor
rem call :_cdc
set cropset=3664:1920:0:0
set bitrateset=20M
set setfps=60
call :_RecordEnableSettings
goto :_createvbs

:_ManualTransSettings
@%verbecho%
cls
set aa=
set bb=
set cc=
set dd=
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    L.  Загрузить настройки из файла профиля
@echo    I.  Загрузить настройки из интегрированных профилей
@echo    H.  Информация о кодеках
@echo.
@echo.
@echo.
@echo   1.Битрейт  2.FPS   3.Запись сессии   4.Обрезка кадра    5.Вывод звука          
@echo  ------------------------------------------------------------------------------------------------
@echo   1. 3      1. 24    1. С записью     1. Обрезка углов    1. Звук на ПК        [записывается]
@echo   2. 5      2. 30    2. Без записи    2. Без обрезки      2. Звук на шлеме     [не записывается] 
@echo   3. 10     3. 60                     3. Режим стерео     3. ПК,микрофон,шлем  [записывается]
@echo   4. 20     4. 90                     4. 16 x 9	
@echo   5. 50
@echo.
@echo.
@echo            6.Датчик приближения                     7.Видеокодек                                   
@echo  ------------------------------------------------------------------------------------------------
@echo          1. Отключить                               1. h264 OMX.qcom.video.encoder.avc             
@echo          2. Не отключать                            2. h265 OMX.qcom.video.encoder.hevc         
@echo                                                     3. h265 OMX.qcom.video.encoder.hevc.cq	  
@echo.
@echo   Введите шести- или семизначное число, состоящее из выбранных пунктов параметров
@echo   Можно ввести только шесть цифр, тогда по умолчанию будут использованы такой видеокодек:
@echo    - h264 OMX.qcom.video.encoder.avc
@echo  ------------------------------------------------------------------------------------------------
@echo.
@echo    Например, для значений 
@echo.
@echo  	1. Битрейт		: 10					(Пункт 3)
@echo  	2. FPS			: 30					(Пункт 2)
@echo  	3. Запись сессии	: Без записи				(Пункт 2)
@echo  	4. Обрезка кадра 	: Обрезка углов				(Пункт 1)
@echo  	5. Вывод звука	 	: ПК,микрофон,шлем			(Пункт 3)
@echo  	6. Датчик		: Отключить				(Пункт 1)
@echo  	7. Видеокодек		: h264 OMX.qcom.video.encoder.avc	(Пункт 1)
@echo.
@echo    число будет таким: 3221311
@echo.
@echo   Для упрощения выбора просто набирайте по одной цифре каждого пункта, а когда наберете все шесть
@echo   или семь цифр, жмите Enter. На следующем экране настройки можно будет сохранить в профиль.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    L.  Load settings from profile file
rem @echo    I.  Load settings from integrated profiles
rem @echo.
rem @echo.
rem @echo.
rem @echo   1. Bitrate   2. FPS   3. Session record    4. Frame crop     5. Sound output          
rem @echo  ------------------------------------------------------------------------------------------------
rem @echo   1. 3         1. 24    1. With record       1. Corner crop    1. Sound on PC              [rec]
rem @echo   2. 5         2. 30    2. Without record    2. No cropp       2. Sound on headset     [not rec] 
rem @echo   3. 10        3. 60                         3. Stereo mode    3. PC, microphone, headset  [rec]
rem @echo   4. 20        4. 90                         4. 1600x900	
rem @echo   5. 50
rem @echo.
rem @echo.
rem @echo          6. Proximity sensor                      7. Video codec                                   
rem @echo  ------------------------------------------------------------------------------------------------
rem @echo          1. Disable                               1. h264 OMX.qcom.video.encoder.avc             
rem @echo          2. Do not disable                        2. h265 OMX.qcom.video.encoder.hevc         
rem @echo                                                   3. h265 OMX.qcom.video.encoder.hevc.cq	  
rem @echo.
rem @echo   Enter a six- or seven-digit number consisting of selected parameter options
rem @echo   You can enter only six digits, then by default, this video codec will be used:
rem @echo    - h264 OMX.qcom.video.encoder.avc
rem @echo  ------------------------------------------------------------------------------------------------
rem @echo.
rem @echo    For example, for values 
rem @echo.
rem @echo  	1. Bitrate		: 10					(Item 3)
rem @echo  	2. FPS			: 30					(Item 2)
rem @echo  	3. Session recording	: Without recording			(Item 2)
rem @echo  	4. Frame cropping 	: Corner cropping			(Item 1)
rem @echo  	5. Sound output	 	: PC, microphone, headset		(Item 3)
rem @echo  	6. Sensor		: Disable				(Item 1)
rem @echo  	7. Video codec		: h264 OMX.qcom.video.encoder.avc	(Item 1)
rem @echo.
rem @echo    the number will be: 3221311
rem @echo.
rem @echo   To simplify the selection, just type one digit of each item,
rem @echo   and when you have typed all six or seven digits, press Enter.
rem EndEngTextBlock
@echo.
rem @Set profdatanew=3221311
rem StartRusTextBlock
@Set /p profdatanew="Введите число или пункт меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p profdatanew="Enter the number or menu item and press Enter: "
rem EndEngTextBlock
if not defined profdatanew goto _ManualTransSettings
if "%profdatanew%"=="0" (exit)
if /i "%profdatanew%"=="m" (GOTO _streamingmenu)
if /i "%profdatanew%"=="l" (call :_loadMultiprofile)
if /i "%profdatanew%"=="i" (call :_LoadIntMultiProfile)
if /i "%profdatanew%"=="h" (goto _CodecsHelp)

:_Choiced
cls
call :_hat
@echo.
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo      C.  Трансляция по кабелю
@echo      R.  Повторить выбор настроек или загрузить из файла профилей
@echo      S.  Сохранить настройки в файл профилей
@echo      W.  Сохранить в файл строку запуска  scrcpy с выбранными параметрами
@echo.
@echo  Enter.  Начать трансляцию
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      C.  Cable transmission
rem @echo      R.  Repeat settings selection or load from profile file
rem @echo      S.  Save settings to profile file
rem @echo      W.  Save the scrcpy command line with selected parameters to a file
rem @echo.
rem @echo  Enter.  Start transmission
rem EndEngTextBlock
@echo.
@echo.
@echo.
call :_ParsingProfDataNew
@echo.

rem StartRusTextBlock
@echo  Выбраны следующие настройки:
@echo.
@echo.  Битрейт	: !bitrateset!
@echo.  FPS		: !setfps!
@echo.  Запись сессии	: !recmsg! 
@echo.  Обрезка кадра	: !cropmsg!
@echo.  Вывод звука	: !amsg!
@echo.  Датчик	: !proxmsg!
@echo.  Видеокодек	: !vcodecmsg!
@echo  ---------------------------------------------
@echo   Профиль	: !profname!
@echo.
@echo.
@echo.
@echo   ВАЖНО:
@echo.
@echo   По умолчанию (по нажатию Enter) будет включена беспроводная трансляция,
@echo   но перед началом кабель должен быть подсоединен.
@echo   А уже после начала трансляции обязательно отсоедините USB кабель.
@echo.
@echo   Если требуется трансляция по кабелю, не отсоединяйте его,
@echo   введите C и нажмите Enter.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The following settings are selected:
rem @echo.
rem @echo.  Bitrate	: !bitrateset!
rem @echo.  FPS		: !setfps!
rem @echo.  Session recording	: !recmsg! 
rem @echo.  Frame cropping	: !cropmsg!
rem @echo.  Sound output	: !amsg!
rem @echo.  Sensor	: !proxmsg!
rem @echo.  Video codec	: !vcodecmsg!
rem @echo  ---------------------------------------------
rem @echo   Profile	: !profname!
rem @echo.
rem @echo.
rem @echo.
rem @echo   IMPORTANT:
rem @echo.
rem @echo   By default (pressing Enter), wireless transmission will be enabled,
rem @echo   but the cable must be connected before starting.
rem @echo   And only after the start of transmission, you must disconnect the USB cable.
rem @echo.
rem @echo   If cable transmission is required, do not disconnect it,
rem @echo   enter C and press Enter.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@Set choice2=
@Set choice2=e
rem StartRusTextBlock
@Set /p choice2="Для начала трансляции нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice2="Press Enter to start transmission: "
rem EndEngTextBlock
if not defined choice2 goto _choiced
if "%choice2%"=="0" (exit)
if /i "%choice2%"=="e" (set connectivity=-e&&goto _BeginTranslation)
if /i "%choice2%"=="c" (set connectivity=-d&&goto _BeginTranslation)
if /i "%choice2%"=="m" (GOTO _streamingmenu)
if /i "%choice2%"=="r" (GOTO _ManualTransSettings)
if /i "%choice2%"=="s" (GOTO _SaveMultiProfiles)
if /i "%choice2%"=="w" (GOTO _BeginTranslation)
goto _choiced

:_seterror
@echo.
rem StartRusTextBlock
rem @echo ---------------------------------------------------------
@echo +++ Значение "%errorout%" вне диапазона пунктов меню ++++
@echo.
@echo             Выберите другое значение
@echo ------------------------------------------------------
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата к настройкам ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo +++ Value "%errorout%" is out of menu range ++++
rem @echo.
rem @echo             Choose another value
rem @echo ------------------------------------------------------
rem @echo.
rem @echo ^>^>^> Press anything to return to settings ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _ManualTransSettings

:_SaveProfile

@echo %profnamenew% >TransProfile.txt
@echo.
rem StartRusTextBlock
rem @echo ---------------------------------------------
@echo  +++ Настройки сохранены в файл профиля +++
@echo.
@echo  При желании его можно редактироовать вручную.
@echo.
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Settings saved to profile file +++
rem @echo.
rem @echo  If desired, it can be edited manually.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _Choiced


:_BeginTranslation
rem if "%DevModelNm%" EQU "Meta Quest 3" set cropset=1920:1200:100:400 &set angleset=--angle=22
if "%DevModelNm%" EQU "Meta Quest 3" set angleset=--angle=22

call :_cdc
call :_CheckWiFiMode
call :_CheckADBDevices

if /i %choice2%==c (call :_ReconnectToCable && call :_CheckADBDevices && call :_SetCableSettings)
if /i %choice2%==w goto _createscrcpystring


:_ProximitySettings
if %Proximity%==0 (@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul)
rem goto _createvbs
:_createvbs
@echo strCommand = "cmd /c %MYFILES%\scrcpy.exe %connectivity% %angleset% %audiomute% %acodecset% %vcodecset% --crop=%cropset% --max-size=4128 --video-bit-rate=%bitrateset% --video-buffer=50 --render-driver=opengl --max-fps=%setfps% --stay-awake%recformat% --power-off-on-close%recfile%">>startstream.vbs
@echo For Each Arg In WScript.Arguments >>startstream.vbs
@echo strCommand = strCommand ^& " """ ^& replace^(Arg, """", """""""""") ^& """" >> startstream.vbs
@echo Next >>startstream.vbs
@echo CreateObject("Wscript.Shell").Run strCommand, 0, false >>startstream.vbs
rem goto _startstream

:_startstream
::@cls
@echo  ------------------------------------------------------------------
rem StartRusTextBlock
@echo   Координаты кропа	: %cropset%
@echo   Модель шлема		: %DevModelNm%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Crop coordinates	: %cropset%
rem @echo   Headset model		: %DevModelNm%
rem EndEngTextBlock
start startstream.vbs
@ping localhost -n 4 1>nul 2>nul
@del startstream.vbs /q 2>nul
@echo  ------------------------------------------------------------------
@echo.
@echo.
@echo.   %connectmsg%
@echo.
@echo.
rem StartRusTextBlock
@echo   После старта трансляции картинка может пропасть на 3-4 секунды,
@echo   а шлем скажет "блым". Это связано с всплывающим в шлеме ссобщением,
@echo   например, о том, что контроллеры не найдены. Увы, но вот так.
@echo.
@echo =========================================================================
@echo ^>^>^> Нажмите любую кнопку для возврата в Главное меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   After starting the transmission, the picture may disappear for 3-4 seconds,
rem @echo   and the headset will say "bleem". This is due to the message that pops up in the headset,
rem @echo   for example, that the controllers are not found. Alas, but that's how it is.
rem @echo.
rem @echo =========================================================================
rem @echo ^>^>^> Press any key to return to the Main menu ^<^<^<
rem EndEngTextBlock
@pause >nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@cls
goto _beginn

:_createscrcpystring
@echo scrcpy.exe %connectivity% %angleset% %audiomute% %acodecset% %vcodecset% --crop=%cropset% --max-size=4128 --video-bit-rate=%bitrateset% --video-buffer=50 --max-fps=%setfps% --stay-awake%recformat% --power-off-on-close%recfile%>scrcpyLaunchString_%dt%_%profdata%.txt
@echo -------------------------------------------------------------------------------------------
rem StartRusTextBlock
@echo = Строка запуска сохранена в файл scrcpyLaunchString_%dt%_%profdata%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo = The launch string is saved to the file scrcpyLaunchString_%dt%_%profdata%.txt
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _Choiced

:_LoadMultiProfile
cls
@echo.
@echo.
rem StartRusTextBlock
@echo   0. Выход из программы
@echo   M. Отмена выбора и возврат в предыдущее меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   0. Exit the program
rem @echo   M. Cancel selection and return to the previous menu
rem EndEngTextBlock
@echo.
if exist TransMultiProfiles.txt (call :_ProfilesCollection) else (goto _NoFileProfiles)
@Set profnumb=
@echo.
rem StartRusTextBlock
@Set /p profnumb="Выберите номер желаемого профиля и нажмите Enter для загрузки: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p profnumb="Enter the number of the desired profile and press Enter to load: "
rem EndEngTextBlock
if not defined profnumb goto _LoadMultiProfile
if "%profnumb%"=="0" (exit)
if /i "%profnumb%"=="m" (GOTO _ManualTransSettings)
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (TransMultiProfiles.txt) Do (

@set pn=%%a
@set profname=%%b
@set profdata=%%c
if !profnumb!==!pn! goto _ViewProfilesNew
)
goto _Choiced
::>>>>>>>>>>>>>>>>>>>>>>>
:_LoadIntMultiProfile
@del IntProfiles.txt /q 2>nul
cls
@echo.
@echo.
rem StartRusTextBlock
@echo   0. Выход из программы
@echo   M. Отмена выбора и возврат в предыдущее меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   0. Exit the program
rem @echo   M. Cancel selection and return to the previous menu
rem EndEngTextBlock
@echo.
rem if exist TransMultiProfiles.txt (call :_ProfilesCollection) else (goto _NoFileProfiles)
call :_IntegratedProfiles
call :_IntProfilesCollection
@Set profnumb=
@echo.
rem StartRusTextBlock
@Set /p profnumb="Выберите номер желаемого профиля и нажмите Enter для загрузки: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p profnumb="Enter the number of the desired profile and press Enter to load: "
rem EndEngTextBlock

:_FastLoadIntMultiProfile
rem @echo.%profnumb%|>nul findstr /rc:"[^1-6]"&&(goto _LoadIntMultiProfile)
if not defined profnumb goto _LoadMultiProfile
if "%profnumb%"=="0" (@del IntProfiles.txt /q 2>nul & exit)
if /i "%profnumb%"=="m" (@del IntProfiles.txt /q 2>nul & GOTO _ManualTransSettings)
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (IntProfiles.txt) Do (

@set pn=%%a
@set profname=%%b
@set profdata=%%c
if !profnumb!==!pn! goto _ViewProfilesNew
)
goto _Choiced

:_IntegratedProfiles
@echo ProfileNumber:ProfileName:ProfileData>>IntProfiles.txt
rem StartRusTextBlock
@echo 1:Минимальный:1121121>>intprofiles.txt
@echo 2:Легкий:2221312>>intprofiles.txt
@echo 3:Сбалансированный:3314113 >>intprofiles.txt
@echo 4:Демонстрационный:3224321>>intprofiles.txt
@echo 5:Качественный:4314312>>intprofiles.txt
@echo 6:Максимальный:5411113 >>intprofiles.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo 1:Minimum:1121121>>intprofiles.txt
rem @echo 2:Light:2221312>>intprofiles.txt
rem @echo 3:Balanced:3314113 >>intprofiles.txt
rem @echo 4:Demo:3224321>>intprofiles.txt
rem @echo 5:Quality:4314312>>intprofiles.txt
rem @echo 6:Maximum:5411113 >>intprofiles.txt
rem EndEngTextBlock
exit /b

:_IntProfilesCollection
rem StartRusTextBlock
@echo   = Интегрированные профили:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Integrated profiles:
rem EndEngTextBlock
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (IntProfiles.txt) Do (
@set pn=%%a
:: Добавление еще четырех профилей
rem if !pn!==5 @echo ---------- ^ & @echo Нажмите любую кнопку для просмотра следующего блока доступных профилей && @pause 1>nul 2>nul && cls && @echo. && @echo   = Доступные профили:
@set profname=%%b
@set profdata=%%c
call :_ParsingProfData
call :_tabProfiles
rem @echo.
)
@echo   ------------
exit /b


::>>>>>>>>>>>>>>>>>>>>>>
:_NoFileProfiles
@cls
call :_hat
@echo.
@echo.
@echo.
@echo  -------------------------------------------------
rem StartRusTextBlock
@echo        +++ Файл профилей отсутствует +++
@echo.
@echo  Создайте вручную и сохраните хотя бы один профиль
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата к настройкам^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        +++ Profile file is missing +++
rem @echo.
rem @echo  Create and save at least one profile manually
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo ^>^>^> Press anything to return to settings ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _ManualTransSettings

:_ViewProfilesNew
set profdatanew=!profdata!
call :_ParsingProfDataNew
@del IntProfiles.txt /q 2>nul
goto _Choiced

:_SaveMultiProfiles
if not exist TransMultiProfiles.txt (call :_CreateNewTransProFile)
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (TransMultiProfiles.txt) Do (
@set pn=%%a
if !pn!==4 goto _ProfRewrite
rem if !pn!==8 goto _ProfRewrite
set pnadd=!pn!
set /a pnadd=!pnadd!+1
)
@echo ---------------------------------------------
rem StartRusTextBlock
@echo   Сохраняем настройки:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Saving settings:
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@Set /p profname="Введите имя нового профиля и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p profname="Enter the name of the new profile and press Enter: "
rem EndEngTextBlock
@echo !pnadd!:!profname!:!profdatanew!>>TransMultiProfiles.txt 
@echo ---------------------------------------------
rem StartRusTextBlock
@echo  +++ Настройки сохранены в файл профиля +++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Settings saved to profile file +++
rem EndEngTextBlock
@echo.
@echo.
call :_ProfilesCollection
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _Choiced

:_CreateNewTransProFile
@echo.
@echo -----------------------------------------------------------------
rem StartRusTextBlock
@echo             +++ Файл профилей отсутствует +++
@echo.
@echo Создаем новый файл профилей и сохраняем в него выбранные настройки:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo             +++ Profile file is missing +++
rem @echo.
rem @echo Creating a new profile file and saving the selected settings:
rem EndEngTextBlock
@echo.
@echo.
@echo.
set pn=1
rem StartRusTextBlock
@Set /p profnamenew="Введите имя нового профиля и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p profnamenew="Enter the name of the new profile and press Enter: "
rem EndEngTextBlock
@echo ProfileNumber:ProfileName:ProfileData>>TransMultiProfiles.txt
@echo !pn!:!profnamenew!:!profdatanew!>>TransMultiProfiles.txt 
@echo.
@echo ---------------------------------------------
rem StartRusTextBlock
@echo  +++ Настройки сохранены в файл профилей +++
@echo.
@echo  При желании его можно редактироовать вручную.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Settings saved to profile file +++
rem @echo.
rem @echo  If desired, it can be edited manually.
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _Choiced

:_ProfRewrite
cls
@echo.
@echo.
rem StartRusTextBlock
@echo   0. Выход из программы
@echo   M. Отмена выбора и возврат в предыдущее меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   0. Exit the program
rem @echo   M. Cancel selection and return to the previous menu
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo   = Сохраняемый профиль:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Profile to be saved:
rem EndEngTextBlock
call :_tabProfilesNew
@echo   --------------------------------------------------------------------------------------
call :_ProfilesCollection
rem StartRusTextBlock
@echo   = К сожалению, борльше нет свободных слотов для профилей.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Unfortunately, there are no more free slots for profiles.
rem EndEngTextBlock
@echo.
rem StartRusTextBlock
@Set /p pnnew="Из доступных профилей выберите номер перезаписываемого профиля и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p pnnew="From the available profiles, enter the number of the profile to be overwritten and press Enter: "
rem EndEngTextBlock
if not defined pnnew goto _ProfRewrite
if "%pnnew%"=="0" (exit)
if /i "%pnnew%"=="m" (GOTO _ManualTransSettings)
@echo.%pnnew%|>nul findstr /rc:"[^1-4]"&&(goto _ProfRewrite)
@Set profnamenew=
rem StartRusTextBlock
@Set /p profnamenew="Введите имя нового профиля и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p profnamenew="Enter the name of the new profile and press Enter: "
rem EndEngTextBlock
if "%profnamenew%" equ "" set profnamenew=NewProfile
@echo ProfileNumber:ProfileName:ProfileData>>TransMultiProfilesNew.txt
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (TransMultiProfiles.txt) Do (
@set pn=%%a
@set profname=%%b
@set profdata=%%c
if not !pnnew!==!pn! (@@echo !pn!:!profname!:!profdata!>>TransMultiProfilesNew.txt) else (@@echo !pnnew!:!profnamenew!:!profdatanew!>>TransMultiProfilesNew.txt)
)
@echo.
@del TransMultiProfiles.txt /q /f 1>nul 2>nul
@ren TransMultiProfilesNew.txt TransMultiProfiles.txt 1>nul 2>nul
@echo.
@echo ---------------------------------------------
rem StartRusTextBlock
@echo  +++ Настройки сохранены в файл профилей +++
@echo.
@echo  При желании его можно редактироовать вручную.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Settings saved to profile file +++
rem @echo.
rem @echo  If desired, it can be edited manually.
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto _Choiced

:_ProfilesCollection
@echo.
rem StartRusTextBlock
@echo   = Сохраненные профили:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Saved profiles:
rem EndEngTextBlock
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (TransMultiProfiles.txt) Do (
@set pn=%%a
:: Добавление еще четырех профилей
rem if !pn!==5 @echo ---------- ^ & @echo Нажмите любую кнопку для просмотра следующего блока доступных профилей && @pause 1>nul 2>nul && cls && @echo. && @echo   = Доступные профили:
@set profname=%%b
@set profdata=%%c
call :_ParsingProfData
call :_tabProfiles
rem @echo.
)
@echo   ------------
exit /b


::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
:_ParsingProfDataNew
set aa=%profdatanew:~0,1%
set bb=%profdatanew:~1,1%
set cc=%profdatanew:~2,1%
set dd=%profdatanew:~3,1%
set ee=%profdatanew:~4,1%
set ff=%profdatanew:~5,1%
set gg=%profdatanew:~6,1%
rem set hh=%profdatanew:~7,1%
call :_ParsingNumber
exit /b



:_ParsingProfData
:: Парсинг числа настроек профиля
set aa=%profdata:~0,1%
set bb=%profdata:~1,1%
set cc=%profdata:~2,1%
set dd=%profdata:~3,1%
set ee=%profdata:~4,1%
set ff=%profdata:~5,1%
set gg=%profdata:~6,1%
rem set hh=%profdata:~7,1%
call :_ParsingNumber
exit /b


:_ParsingNumber
rem StartRusTextBlock
if [%aa%]==[] set errorout=Битрейт&&goto _seterror
if [%bb%]==[] set errorout=FPS&&goto _seterror
if [%cc%]==[] set errorout=Запись сессии&&goto _seterror
if [%dd%]==[] set errorout=Обрезка кадра&&goto _seterror
if [%ee%]==[] set errorout=Вывод звука&&goto _seterror
if [%ff%]==[] set errorout=Датчик приближения&&goto _seterror
rem EndRusTextBlock
rem StartEngTextBlock
rem if [%aa%]==[] set errorout=Bitrate&&goto _seterror
rem if [%bb%]==[] set errorout=FPS&&goto _seterror
rem if [%cc%]==[] set errorout=Session recording&&goto _seterror
rem if [%dd%]==[] set errorout=Frame cropping&&goto _seterror
rem if [%ee%]==[] set errorout=Sound output&&goto _seterror
rem if [%ff%]==[] set errorout=Proximity sensor&&goto _seterror
rem EndEngTextBlock

if [%gg%]==[] set gg=2& set vcodecset=--video-codec=h264 --video-encoder=OMX.qcom.video.encoder.avc & set vcodecmsg=h264 OMX.qcom.video.encoder.avc
rem rem if [%hh%]==[] set hh=2& set acodecset=--audio-codec=aac --audio-encoder='c2.android.aac.encoder' & set acodecmsg=c2.android.aac.encoder
rem StartRusTextBlock
@echo.%aa%|>nul findstr /rc:"[^1-5]"&&(set errorout=Битрейт)&&(goto _seterror)
@echo.%bb%|>nul findstr /rc:"[^1-4]"&&(set errorout=FPS)&&(goto _seterror)
@echo.%cc%|>nul findstr /rc:"[^1-2]"&&(set errorout=Запись сессии)&&(goto _seterror)
@echo.%dd%|>nul findstr /rc:"[^1-4]"&&(set errorout=Обрезка кадра)&&(goto _seterror)
@echo.%ee%|>nul findstr /rc:"[^1-3]"&&(set errorout=Вывод звука)&&(goto _seterror)
@echo.%ff%|>nul findstr /rc:"[^1-2]"&&(set errorout=Датчик приближения)&&(goto _seterror)
@echo.%gg%|>nul findstr /rc:"[^1-3]"&&(set errorout=Видеокодек)&&(goto _seterror)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo.%aa%|>nul findstr /rc:"[^1-5]"&&(set errorout=Bitrate)&&(goto _seterror)
rem @echo.%bb%|>nul findstr /rc:"[^1-4]"&&(set errorout=FPS)&&(goto _seterror)
rem @echo.%cc%|>nul findstr /rc:"[^1-2]"&&(set errorout=Session recording)&&(goto _seterror)
rem @echo.%dd%|>nul findstr /rc:"[^1-4]"&&(set errorout=Frame cropping)&&(goto _seterror)
rem @echo.%ee%|>nul findstr /rc:"[^1-3]"&&(set errorout=Sound output)&&(goto _seterror)
rem @echo.%ff%|>nul findstr /rc:"[^1-2]"&&(set errorout=Proximity sensor)&&(goto _seterror)
rem @echo.%gg%|>nul findstr /rc:"[^1-3]"&&(set errorout=Video codec)&&(goto _seterror)
rem EndEngTextBlock


::Bitrate
if %aa%==1 set bitrateset=3M
if %aa%==2 set bitrateset=5M
if %aa%==3 set bitrateset=10M
if %aa%==4 set bitrateset=20M
if %aa%==5 set bitrateset=50M

::FPS
if %bb%==1 set setfps=24
if %bb%==2 set setfps=30
if %bb%==3 set setfps=60
if %bb%==4 set setfps=90

::Record
rem StartRusTextBlock
if %cc%==1 set recmsg=С записью & call :_RecordEnableSettings
if %cc%==2 set recfile=&set recformat=&set recmsg=Без записи
rem EndRusTextBlock

rem StartEngTextBlock
rem if %cc%==1 set recmsg=With record & call :_RecordEnableSettings
rem if %cc%==2 set recfile= & set recmsg=Without rec
rem EndEngTextBlock

::Crop
rem StartRusTextBlock
if %dd%==1 (
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1920:1080:100:600 & set cropmsg=Обрезка углов
) else (
set cropset=1584:1440:1950:250 & set cropmsg=Обрезка углов
)
)

if %dd%==2 (
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=2000:1200:100:500 & set cropmsg=Без обрезки
) else (
set cropset=1832:1920:0:0 & set cropmsg=Без обрезки
)
)

if %dd%==3 (
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=3664:1920:0:0 & set cropmsg=Режим стерео
) else (
set cropset=4128:2208:0:0 & set cropmsg=Режим стерео
)
)

if %dd%==4 (
if "%DevModelNm%" EQU "Meta Quest 3" (
set cropset=1920:1080:200:600 & set cropmsg=16x9
) else (
set cropset=1600:900:2017:510 & set cropmsg=16x9
)
)
rem EndRusTextBlock
rem StartEngTextBlock
rem if %dd%==1 (
rem if "%DevModelNm%" EQU "Meta Quest 3" (
rem set cropset=1920:1080:100:600 & set cropmsg=Corners crop
rem ) else (
rem set cropset=1584:1440:1950:250 & set cropmsg=Corners crop
rem )
rem )

rem if %dd%==2 (
rem if "%DevModelNm%" EQU "Meta Quest 3" (
rem set cropset=2000:1200:100:500 & set cropmsg=No cropping
rem ) else (
rem set cropset=1832:1920:0:0 & set cropmsg=No cropping
rem )
rem )

rem if %dd%==3 (
rem if "%DevModelNm%" EQU "Meta Quest 3" (
rem set cropset=3664:1920:0:0 & set cropmsg=Stereo mode
rem ) else (
rem set cropset=4128:2208:0:0 & set cropmsg=Stereo mode
rem )
rem )

rem if %dd%==4 (
rem if "%DevModelNm%" EQU "Meta Quest 3" (
rem set cropset=1920:1080:200:600 & set cropmsg=16x9
rem ) else (
rem set cropset=1600:900:2017:510 & set cropmsg=16x9
rem )
rem )
rem EndEngTextBlock

::Выход звука
rem StartRusTextBlock
if %ee%==1 set acodecset=--audio-codec=aac --audio-encoder=OMX.google.aac.encoder& set audiomute=& set amsg=Звук на ПК 
if %ee%==2 set acodecset=--audio-codec=aac --audio-encoder=OMX.google.aac.encoder& set audiomute=--no-audio& set amsg=Звук на шлеме
if %ee%==3 set acodecset=--audio-source=mic& set audiomute=& set amsg=ПК,микрофон,шлем
rem EndRusTextBlock
rem StartEngTextBlock
rem if %ee%==1 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=& set amsg=Sound on PC
rem if %ee%==2 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=--no-audio& set amsg=Sound on headset
rem if %ee%==3 set acodecset=--audio-source=mic& set audiomute=& set amsg=PC, microphone, headset
rem EndEngTextBlock

rem if %ee%==1 set audioset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=& set amsg=Звук на ПК 
rem if %ee%==2 set audioset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=--no-audio& set amsg=Звук на шлеме
rem if %ee%==3 set audioset=--audio-source=mic& set audiomute=& set amsg=С микрофона 

::Prox
rem StartRusTextBlock
if %ff%==1 set Proximity=0 & set proxmsg=Отключить
if %ff%==2 set Proximity=1 & set proxmsg=Не отключать
rem EndRusTextBlock
rem StartEngTextBlock
rem if %ff%==1 set Proximity=0 & set proxmsg=Disable
rem if %ff%==2 set Proximity=1 & set proxmsg=Do not disable
rem EndEngTextBlock

::Video
if %gg%==1 set vcodecset=--video-codec=h264 --video-encoder=OMX.qcom.video.encoder.avc& set vcodecmsg=h264 OMX.qcom.video.encoder.avc
rem rem if %gg%==2 set vcodecset=--video-codec=h264 --video-encoder='c2.qti.avc.encoder' & set vcodecmsg=h264 c2.qti.avc.encoder
if %gg%==2 set vcodecset=--video-codec=h265 --video-encoder=OMX.qcom.video.encoder.hevc& set vcodecmsg=h265 OMX.qcom.video.encoder.hevc
rem rem if %gg%==3 set vcodecset=--video-codec=h265 --video-encoder='OMX.qcom.video.encoder.hevc' & set vcodecmsg=h265 OMX.qcom.video.encoder.hevc
if %gg%==3 set vcodecset=--video-codec=h265 --video-encoder=OMX.qcom.video.encoder.hevc.cq& set vcodecmsg=h265 OMX.qcom.video.encoder.hevc.cq
rem if %gg%==4 set vcodecset=--video-codec=h265 --video-encoder='OMX.qcom.video.encoder.hevc.cq' & set vcodecmsg=h265 OMX.qcom.video.encoder.hevc.cq
rem if %gg%==5 set vcodecset=--video-codec=h265 --video-encoder='c2.qti.hevc.encoder' & set vcodecmsg=h265 c2.qti.hevc.encoder
rem if %gg%==6 set vcodecset=--video-codec=h265 --video-encoder='c2.qti.hevc.encoder.cq' & set vcodecmsg=h265 c2.qti.hevc.encoder.cq

::Audio
rem set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set acodecmsg=aac OMX.google.aac.encoder
rem if %hh%==1 set acodecset=--audio-codec=opus --audio-encoder='c2.android.opus.encoder'& set acodecmsg=opus c2.android.opus.encoder
rem if %hh%==2 set acodecset=--audio-codec=aac --audio-encoder='c2.android.aac.encoder'& set acodecmsg=aac c2.android.aac.encoder
rem if %hh%==3 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set acodecmsg=aac OMX.google.aac.encoder
exit /b

:_tabProfiles
@echo   ======================================================================================
rem StartRusTextBlock
@echo   Профиль  !pn!	: !profname!					^| !profdata!
@echo   --------------------------------------------------------------------------------------
@echo.  Битрейт	: !bitrateset!		 ^| Вывод звука	: !amsg!
@echo.  FPS		: !setfps!		 ^| Датчик	: !proxmsg!
@echo.  Запись сессии	: !recmsg!	 ^| Видеокодек	: !vcodecmsg!
@echo.  Обрезка кадра	: !cropmsg!	 ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Profile  !pn!	: !profname!					^| !profdata!
rem @echo   --------------------------------------------------------------------------------------
rem @echo.  Bitrate	: !bitrateset!		 ^| Sound output	: !amsg!
rem @echo.  FPS		: !setfps!		 ^| Proximity sensor	: !proxmsg!
rem @echo.  Session rec	: !recmsg!	 ^| Video codec	: !vcodecmsg!
rem @echo.  Frame crop	: !cropmsg!	 ^|
rem EndEngTextBlock
exit /b

:_tabProfilesNew
@echo   ======================================================================================
rem StartRusTextBlock
@echo   Профиль  !pnnew!	: !profnamenew!					^| !profdatanew!
@echo   --------------------------------------------------------------------------------------
@echo.  Битрейт	: !bitrateset!		 ^| Вывод звука	: !amsg!
@echo.  FPS		: !setfps!		 ^| Датчик	: !proxmsg!
@echo.  Запись сессии	: !recmsg!	 ^| Видеокодек	: !vcodecmsg!
@echo.  Обрезка кадра	: !cropmsg!	 ^|
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Profile  !pnnew!	: !profnamenew!					^| !profdatanew!
rem @echo   --------------------------------------------------------------------------------------
rem @echo.  Bitrate	: !bitrateset!		 ^| Sound output		: !amsg!
rem @echo.  FPS		: !setfps!		 ^| Proximity sensor	: !proxmsg!
rem @echo.  Session recording	: !recmsg!	 ^| Video codec		: !vcodecmsg!
rem @echo.  Frame cropping	: !cropmsg!	 ^|
rem EndEngTextBlock
exit /b


:_ConnectOverWiFi
set connectivity=--tcpip
exit /b


:_CheckWiFiMode
@%verbecho%
@%MYFILES%\adb devices 2>NUL | findstr ":" 2>nul 1>nul
@IF %ERRORLEVEL% EQU 0 (
@set /A wificheck=1
set connectivity=-e
) else (
@set /A wificheck=0
set connectivity=--tcpip
rem set connectivity=-d
)
rem StartRusTextBlock
set connectmsg=  +++ Соединено по WiFi. Не забудьте отключить кабель +++
rem EndRusTextBlock
rem StartEngTextBlock
rem set connectmsg=  +++ Connected via WiFi. Don't forget to disconnect the cable +++
rem EndEngTextBlock
@exit /b

:_ReconnectToCable
@%MYFILES%\adb kill-server 1>nul 2>nul
@%MYFILES%\adb start-server 1>nul 2>nul
exit /b

:_CheckADBDevices
rem @%MYFILES%\adb devices 1>nul 2>nul
@FOR /F "skip=1 tokens=2" %%G IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO set adbdevices=%%G
@if [%adbdevices%]==[] goto _NF
exit /b
:_NF
@echo.
@echo. 
rem StartRusTextBlock
@echo  +++++ Подключите к шлему кабель +++++
@echo.
@echo. 
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++++ Connect the cable to the headset +++++
rem @echo.
rem @echo. 
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock

@pause 1>nul 2>nul
goto :_ManualTransSettings

:_SetCableSettings
set connectivity=-d
rem StartRusTextBlock
set connectmsg=     +++ Соединено по кабелю, не отключайте его +++
rem EndRusTextBlock
rem StartEngTextBlock
rem set connectmsg=     +++ Connected via cable. Don't detach it +++
rem EndEngTextBlock
exit /b

:_RecordEnableSettings
call :_settime
set recfile= --record=StreamRecord-%dt%.mkv
set recformat= --record-format=mkv
exit /b

:_CodecsHelp
@%verbecho%
@cls
@echo.
rem StartRusTextBlock
@echo Аудиокодеки:
@echo.
@echo  OMX.google.aac.encoder и c2.android.aac.encoder - это идентификаторы кодеков аудиоформата AAC
@echo  ^(Advanced Audio Coding^) для кодирования аудио. Они относятся к разным реализациям кодека AAC, 
@echo  которые могут быть использованы на устройствах Android.
@echo.
@echo  OMX.google.aac.encoder - это кодек AAC, реализованный программно ^(Software-based^). Это означает,
@echo  что кодек полностью работает на процессоре центрального процессора ^(CPU^) устройства. Этот кодек
@echo  обеспечивает аудиоэнкодирование с использованием программного обеспечения.
@echo.
@echo  c2.android.aac.encoder - это кодек AAC, реализованный с использованием аппаратного обеспечения
@echo  ^(Hardware-based^). В отличие от программной реализации, этот кодек использует аппаратные
@echo  возможности устройства, такие как цифровой сигнальный процессор ^(DSP^) или специализированные
@echo  аудио-ядра для выполнения операций кодирования. Кодек, работающий на аппаратном уровне, обычно
@echo  более эффективен с точки зрения использования ресурсов устройства и может обеспечивать
@echo  более высокую производительность.
@echo.
@echo.
@echo Видеокодеки:
@echo.
@echo  Кодеки c2.qti.hevc.encoder и c2.qti.hevc.encoder.cq, это идентификаторы кодеков для формата видео
@echo  HEVC ^(High Efficiency Video Coding^), также известного как H.265. Они относятся к разным профилям
@echo  и конфигурациям кодирования HEVC.
@echo.
@echo  c2.qti.hevc.encoder - это базовый кодек HEVC для аппаратного обеспечения Qualcomm Technologies
@echo  Incorporated ^(QTI^). Он предназначен для аппаратного кодирования видео с использованием аппаратных
@echo  возможностей устройства, таких как графический процессор ^(GPU^) или видеопроцессор ^(VPU^).
@echo.
@echo  c2.qti.hevc.encoder.cq - это конфигурация кодека HEVC для постоянного качества ^(Constant Quality^).
@echo  Это означает, что кодек будет поддерживать постоянное качество видео, а не постоянный битрейт.
@echo  Это может быть полезно, если важно сохранить определенное качество видео без привязки
@echo  к определенному битрейту. 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Audio codecs:
rem @echo.
rem @echo  OMX.google.aac.encoder and c2.android.aac.encoder are identifiers for the AAC audio format codecs
rem @echo  (Advanced Audio Coding) for audio encoding. They belong to different implementations of the AAC codec,
rem @echo  which can be used on Android devices.
rem @echo.
rem @echo  OMX.google.aac.encoder is a software-based AAC codec. This means that the codec works entirely on the
rem @echo  device's central processing unit (CPU). This codec provides audio encoding using software.
rem @echo.
rem @echo  c2.android.aac.encoder is a hardware-based AAC codec. Unlike the software implementation, this codec
rem @echo  uses the device's hardware capabilities, such as the digital signal processor (DSP) or specialized
rem @echo  audio cores, to perform encoding operations. A codec operating at the hardware level is usually
rem @echo  more efficient in terms of device resource usage and can provide higher performance.
rem @echo.
rem @echo.
rem @echo Video codecs:
rem @echo.
rem @echo  c2.qti.hevc.encoder and c2.qti.hevc.encoder.cq are identifiers for the High Efficiency Video Coding
rem @echo  (HEVC), also known as H.265, video format codecs. They belong to different profiles and encoding
rem @echo  configurations of HEVC.
rem @echo.
rem @echo  c2.qti.hevc.encoder is the basic HEVC codec for Qualcomm Technologies Incorporated (QTI) hardware.
rem @echo  It is designed for hardware video encoding using the device's hardware capabilities, such as the
rem @echo  graphics processing unit (GPU) or video processing unit (VPU).
rem @echo.
rem @echo  c2.qti.hevc.encoder.cq is a HEVC codec configuration for constant quality (Constant Quality). This
rem @echo  means that the codec will maintain a constant quality of video, rather than a constant bitrate.
rem @echo  This can be useful if it is important to maintain a certain video quality without being tied to
rem @echo  a specific bitrate.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press anything to return ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
goto :_ManualTransSettings

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_TestVrUsvCopy
call :_cdc
call :_hat
@echo.
@echo.
@echo.
rem call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    Введите количество проходов теста и нажмите Enter.
@echo    По умолчанию число проходов - 20. Просто нажмите Enterю
@echo    Введите 0 если хотите вернуться в меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    Enter the number of test passes and press Enter.
rem @echo    By default, the number of passes is 20. Just press Enter.
rem @echo    Enter 0 if you want to return to the menu.
rem EndEngTextBlock
@echo.
@set "choice="
@set "choice=20"
rem StartRusTextBlock
@Set /p choice="Выберите количество проходов (1-50) и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Enter the number of passes (1-50) and press Enter: "
rem EndEngTextBlock
if /i "%choice%"=="0" (GOTO _beginn)
@echo.%choice%|>nul findstr /rc:"[^1-50]"&&(goto _TestVrUsvCopy)
@echo.
rem if not defined choice goto _TestVrUsvCopy
rem if "%choice%"=="0" (goto _returnmenu)
rem  /i "%choice%"=="t" (GOTO _testcablerun)
@cls
rem goto _TestVrUsvCopy

:_testcablerun
@%verbecho%
setlocal EnableDelayedExpansion
set startTime=%time%

:::::::::::::::::: SETTINGS BEGIN ::::::::::::::::::

::----Путь до файла adb.exe (например, в составе SideQuest)----::
set adbExe=%MYFILES%\adb.exe

@del .\TestFiles /q 1>nul 2>nul
@rd .\TestFiles /q 1>nul 2>nul
@md TestFiles >nul
@fsutil file createnew .\TestFiles\1gb.bin 1000000000 1>nul 2>nul
@fsutil file createnew .\TestFiles\500mb.bin 500000000 1>nul 2>nul

::----Количество проходов теста----::
@echo ============================================
@set /A testNum=%choice%
::"Введите количество проходов теста и нажмите Enter: ("0" - возврат в Главное меню)"
::@@echo ("0" - возврат в Главное меню)
::if %testNum%==0 goto _beginn

::----Путь до каталога, откуда будут копироваться файлы на шлем (например C:\Temp)----::
::----Если пустой, будет использоваться каталог запуска скрипта----::
@set pathTest=.\TestFiles

:::::::::::::::::: SETTINGS END ::::::::::::::::::

::@echo. 
rem StartRusTextBlock
@echo  Стартуем проверку USB кабеля передачей файлов на шлем. 
@echo  Количество проходов теста: %testNum%.
@echo  Подождите немного...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Starting test of USB-cable using file transfer with %testNum% attempts. Please wait...
rem EndEngTextBlock
@echo. 

@set /A i=1
@set /A allErr=0

:_begin
@set /A isOk=0
%adbExe% push %pathTest% /sdcard/Download/Files >_ && type _
@findstr /i /c:"in -" _>nul
@if !errorlevel! EQU 0 (
	@set /A isOk=1
	@set /A allErr+=1
)
%adbExe% shell rm -rf sdcard/Download/Files
rem StartRusTextBlock
@if %!sOk! NEQ 1 @echo.  !time! Тест #!i! прошел успешно.
rem EndRusTextBlock
rem StartEngTextBlock
rem @if %!sOk! NEQ 1 @echo.  !time! Test #!i! passed successfully.
rem EndEngTextBlock
@set /A i+=1
@if !i! LEQ %testNum% goto _begin


@echo. 
rem StartRusTextBlock
@echo  Тест завершен. Время начала: %startTime%. Время завершения: %time%. Ошибки: !allErr!
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The test is complete. Start time: %startTime%. End time: %time%. Errors: !allErr!
rem EndEngTextBlock
@echo.
del /q _
@del .\TestFiles /q >nul
@rd .\TestFiles /q >nul
@goto _returnmenu

:_opencmd
@start cmd
goto _beginn

rem :_openshell
rem @%verbecho%
::@start cmd /c @echo. & @adb shell
rem @start cmd /c @%MYFILES%\adb shell
rem start " " /min powershell -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File ""%myfiles%\adbgui.ps1"" -AdbPath %myfiles%
rem goto _beginn

:_openshellgui
@%verbecho%
::@start cmd /c @echo. & @adb shell
rem @start cmd /c @%MYFILES%\adb shell
start " " /min powershell -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File ""%myfiles%\guishell.ps1"" -AdbPath %myfiles%
goto _beginn

:_helplinksmenu
call :_hat
@echo.
@%verbecho%
@echo      ----------------------------
rem StartRusTextBlock
@echo       ВЫБЕРИТЕ ИНТЕРЕСУЮЩУЮ ТЕМУ
@echo      ----------------------------
@echo.
@echo    0.  Выход из программы
@echo    M.  Выход в главное меню
@echo      ----------------------------
@echo.
@echo.
@echo    A.  Возможные решения проблем с подключением шлема по Link и AirLink
@echo    B.  Первичная настройка шлема и установка обновлений
@echo    C.  Платные и бесплатные VPN клиенты для обхода блокировок
@echo    D.  Руководство по различным методам прошивки шлема
@echo    E.  Создание организации для включения режима разработчика
@echo    F.  Процедура перехода на Meta-аккаунт
@echo    G.  Всеобъемлющий FAQ по шлему Oculus Quest 2
@echo    I.  Сайт для проверки доступности адресов
@echo    J.  Где и как скачивать игры
@echo    K.  Все об  Oculus Quest: прошивки, статьи, программы и многое другое
@echo    L.  Авторский портал о VR: vr419.ru
@echo    N.  Скачать последнюю версию Quas или оставить вопрос/отзыв/комментарий
@echo    O.  Скачать прошивки для Quest 1/2/3/Pro
@echo    P.  WebADB: Управление шлемом в браузере
@echo    Q.  Телеграм-канал VR Games RUS
@echo.
@echo    R.  Некоторые инструкции
@echo ---------------------------------------------------------------------
@echo  Ссылки будут открываться в браузере по умолчанию.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      ----------------------------
rem @echo       CHOOSE THE INTERESTING TOPIC
rem @echo      ----------------------------
rem @echo.
rem @echo    0.  Exit the program
rem @echo    M.  Return to the main menu
rem @echo.
rem @echo    I.  Website to check the availability of addresses (RU)
rem @echo    L.  Author's portal about VR: vr419.ru (RU)
rem @echo    N.  Download the latest version of Quas or leave a question/feedback/comment (RU)
rem @echo    O.  Download firmware for Quest 1/2/3/Pro
rem @echo    P.  WebADB: Headset management in the browser
rem @echo.
rem @echo    R.  Some Instructions
rem @echo ---------------------------------------------------------------------
rem @echo  Links will open in the default browser.
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _helplinksmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" start " " "https://vrcomm.ru/topic/90-возможные-решения-проблем-с-подключением-шлема-по-link-и-airlink"
if /i "%choice%"=="b" start " " "https://vrcomm.ru/topic/109-обзор-первичной-настройки-meta-quest-3"
if /i "%choice%"=="c" start " " "https://vrcomm.ru/topic/195-программы-для-упрощенного-доступа-к-различным-ресурсам"
if /i "%choice%"=="d" start " " "https://vrcomm.ru/forum/12-режим-разработчика-adb-прошивка"
if /i "%choice%"=="e" start " " "https://vrcomm.ru/topic/106-создание-организации-для-включения-режима-разработчика"
if /i "%choice%"=="f" start " " "https://vrcomm.ru/topic/107-процедура-перехода-на-meta-аккаунт"
if /i "%choice%"=="g" start " " "https://vrcomm.ru/forum/4-meta-quest-faq"
if /i "%choice%"=="i" start " " "https://ping-admin.ru/free_test"
if /i "%choice%"=="j" start " " "https://vrcomm.ru/topic/183-программы-для-скачивания-игр-и-прочего"
if /i "%choice%"=="k" start " " "https://vrcomm.ru"
if /i "%choice%"=="l" start " " "https://vr419.ru"
if /i "%choice%"=="n" start " " "https://vrcomm.ru/topic/101-quest-adb-scripts-quas"
if /i "%choice%"=="o" start " " "https://cocaine.trade
if /i "%choice%"=="q" start " " "https://t.me/VRGamesRUS"
rem StartRusTextBlock
if /i "%choice%"=="p" start " " "https://app.webadb.com/" && @echo Через 10 секунд программа будет закрыта && @timeout 10 && goto _tk
rem EndRusTextBlock
rem StartEngTextBlock
rem if /i "%choice%"=="p" (start " " "https://app.webadb.com/" && @echo The program will be closed in 10 seconds && @timeout 10 && goto _tk)
rem EndEngTextBlock
::if /i "%choice%"=="qq" (start " " chrome "_____")
::if /i "%choice%"=="r" (start " " "_____")
::if /i "%choice%"=="rr" (start " " chrome "_____")
if /i "%choice%"=="r" (goto _helpmanuals)
@cls
goto _helplinksmenu



:_helpmanuals
cls
@echo.
@echo.
rem StartRusTextBlock
@echo             ИНСТРУКЦИИ
@echo         =========================
@echo.
@echo   %_fBGreen%Как загрузить шлем в Bootloader.%_fReset%
@echo   %_fBYellow%Если шлем выключен, зажимаем кнопку %_fYellow%Громкость минус %_fBYellow%(ближняя к носу)
@echo   затем жмем и удерживаем кнопку %_fYellow%Питание%_fBYellow% до появления меню %_fYellow%USB Update Mode.
@echo   %_fBYellow%Если шлем включен, отправляем его в перезагрузку, нажимаем и удерживаем
@echo   кнопку %_fYellow%Громкость минус%_fBYellow% до появления меню %_fYellow%USB Update Mode%_fReset%
@echo.
@echo   %_fBGreen%Как загрузить шлем в Recovery.
@echo   %_fBYellow%Если шлем выключен, нажимаем и удерживаем кнопку %_fYellow%Громкость плюс %_fBYellow%(дальняя от носа), затем
@echo   жмем и удерживаем кнопку %_fYellow%Питание%_fBYellow% до появления %_fYellow%сломанного Андроида%_fBYellow% и надписи %_fYellow%No command.
@echo   %_fBYellow%Послеэтого снова держим кнопку %_fYellow%Питание%_fBYellow% и кратко жмем ту же кнопку %_fYellow%Громкость плюс.
@echo   %_fBYellow%Должно появиться сине-желтое меню %_fYellow%Android Recovery%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo             INSTRUCTIONS
rem @echo         =========================
rem @echo.
rem @echo   %_fBGreen%How to boot the headset into Bootloader.%_fReset%
rem @echo   %_fBYellow%If the headset is turned off, hold the %_fYellow%Volume Down %_fBYellow%button (the one closer to the nose)
rem @echo   and then press and hold the %_fYellow%Power%_fBYellow% button until the %_fYellow%USB Update Mode%_fBYellow% menu appears.
rem @echo   %_fBYellow%If the headset is on, initiate a reboot and hold the %_fYellow%Volume Down%_fBYellow% button
rem @echo   until the %_fYellow%USB Update Mode%_fYellow% menu appears.%_fReset%
rem @echo.
rem @echo   %_fBGreen%How to boot the headset into Recovery.
rem @echo   %_fBYellow%If the headset is turned off, press and hold the %_fYellow%Volume Up %_fBYellow%button (the one farther from the nose), then
rem @echo   press and hold the %_fYellow%Power%_fBYellow% button until you see a %_fYellow%broken Android%_fBYellow% and the message %_fYellow%No command.
rem @echo   %_fBYellow%After that, hold the %_fYellow%Power%_fBYellow% button again and briefly press the same %_fYellow%Volume Up%_fBYellow% button.
rem @echo   %_fBYellow%This should bring up the blue-yellow %_fYellow%Android Recovery%_fReset% menu.
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _helplinksmenu


:_syscommenu
call :_settime
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo         МЕНЮ СИСТЕМНОЙ ИНФОРМАЦИИ
@echo         =========================
@echo.
@echo    A.  Работа с dumpsys
@echo    B.  Анализатор памяти
@echo    C.  Сохранить в файл все свойства шлема (getprop)
@echo    D.  Показать IP адрес шлема
@echo    E.  Сохранить список установленных пакетов (packages names)
@echo    F.  Показать серийный номер шлема
@echo    G.  Сохранить списки системных настроек шлема (system/global/security)
@echo    H.  Работа с Logcat
@echo    I.  Информация об аккумуляторе
@echo    J.  Список запущенных приложений
@echo    K.  Извлечение багрепорта                 		[EXP]
@echo    L.  Просмотр CPU-емких приложений         		[EXP]
@echo    N.  Список файлов/каталогов и их объем    		[EXP]
@echo    O.  Показать объем занятого места         		[EXP]
@echo    P.  Журнал подключений и отключений USB устройств
@echo    Q.  Информация о контроллерах
@echo.   R.  Сохранение всей системной информации оптом в один архив
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         SYSTEM INFORMATION MENU
rem @echo         =======================
rem @echo.
rem @echo    A.  Work with dumpsys
rem @echo    B.  Memory analyzer
rem @echo    C.  Save to file all headset properties (getprop)
rem @echo    D.  Show headset IP address
rem @echo    E.  Save a list of installed packages (package names)
rem @echo    F.  Show headset serial number
rem @echo    G.  Save a list of system settings (system/global/security)
rem @echo    H.  Work with Logcat
rem @echo    I.  Battery information
rem @echo    J.  Running Apps List
rem @echo    K.  Bugreport extraction [EXP]
rem @echo    L.  View CPU-intensive applications [EXP]
rem @echo    N.  List of files/directories and their size [EXP]
rem @echo    O.  Show the amount of occupied space [EXP]
rem @echo    P.  USB device connection and disconnection log
rem @echo    Q.  Controllers information
rem @echo.   R.  Save all system information in bulk into one archive
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _syscommenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _dumpsysmenu)
if /i "%choice%"=="b" (GOTO _MemoryUsageInfoMenu)
if /i "%choice%"=="c" (GOTO _allprop)
if /i "%choice%"=="d" (GOTO _showip)
if /i "%choice%"=="e" (GOTO _packageslist)
if /i "%choice%"=="ee" (GOTO _packagesfull)
if /i "%choice%"=="f" (GOTO _showserial)
if /i "%choice%"=="g" (GOTO _syscomm)
if /i "%choice%"=="h" (GOTO _adblogcat)
if /i "%choice%"=="i" (GOTO _batinfo)
if /i "%choice%"=="j" (GOTO _RunningAppsListMenu)
if /i "%choice%"=="k" (GOTO _bugreportextr)
if /i "%choice%"=="l" (GOTO _cpuload)
if /i "%choice%"=="n" (GOTO _sizecheckmenu)
if /i "%choice%"=="o" (GOTO _sizeinfo)
if /i "%choice%"=="p" (GOTO _USBConnectionsList)
if /i "%choice%"=="q" (GOTO _ControllersInfo)
if /i "%choice%"=="r" (GOTO _AllSystemFiles)
cls
goto _syscommenu


:_ControllersInfo
@echo off
cls
setlocal enabledelayedexpansion
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       =============================
@echo         %_fBGreen%Информация о контроллерах%_fReset%
@echo       =============================
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ---- Controllers information ----
rem EndEngTextBlock
@echo.

rem for /f "tokens=* delims=" %%L in ('%myfiles%\adb shell dumpsys OVRRemoteService ^| findstr /i /c:"Paired device:"') do (
rem     set "line=%%L"
rem     for /f "tokens=1-30 delims=, " %%a in ("!line!") do (
rem         set "Type=%%e"
rem         set "Firmware=%%k"
rem         set "Battery=%%o"
rem         set "ExternalStatus=%%u"
rem         set "TrackingStatus=%%w"
rem         set "BrightnessLevel=%%y"
rem 	set "TypeShort=!Type:~0,1!"
rem )

rem if not defined TrackingStatus (

rem @echo  %_fBYellow%Контроллеры в спящем режиме или отключены, информация недоступна.
rem @echo  Нажмите на шлеме кнопку Питание или привяжите контроллеры к шлему и попробуйте снова.%_fReset%

rem @echo  %_fBYellow%Controllers are in sleep mode or disconnected, information unavailable.
rem @echo  Press the Power button on the headset or pair the controllers with the headset and try again.%_fReset%

rem call :_prevmenu
rem goto _syscommenu
rem )

rem StartRusTextBlock
if !Type_L!==Left set typec_l=Левый
if !Type_R!==Right set typec_r=Правый
@echo  === %_fBYellow%!typec_l!%_fReset% ===
@echo  %_fCyan%Версия прошивки%_fReset%	: %_fBCyan%!Firmware_L!%_fReset%
@echo  %_fCyan%Уровень батареи%_fReset%	: %_fBCyan%!Battery_L!%_fReset%
@echo  %_fCyan%Общий статус%_fReset%		: %_fBCyan%!ExternalStatus_L!%_fReset%
@echo  %_fCyan%Позиционный трекинг%_fReset%	: %_fBCyan%!TrackingStatus_L!%_fReset%
@echo  %_fCyan%Уровень ИК диодов%_fReset%	: %_fBCyan%!BrightnessLevel_L!%_fReset%
@echo.
@echo  === %_fBYellow%!typec_r!%_fReset% ===
@echo  %_fCyan%Версия прошивки%_fReset%	: %_fBCyan%!Firmware_R!%_fReset%
@echo  %_fCyan%Уровень батареи%_fReset%	: %_fBCyan%!Battery_R!%_fReset%
@echo  %_fCyan%Общий статус%_fReset%		: %_fBCyan%!ExternalStatus_R!%_fReset%
@echo  %_fCyan%Позиционный трекинг%_fReset%	: %_fBCyan%!TrackingStatus_R!%_fReset%
@echo  %_fCyan%Уровень ИК диодов%_fReset%	: %_fBCyan%!BrightnessLevel_R!%_fReset%
rem EndRusTextBlock
rem @echo TypeShort=!TypeShort!
rem StartEngTextBlock
rem @echo  === %_fBYellow%!Type_L!%_fReset% ===
rem @echo %_fCyan%Firmware%_fReset%		: %_fBCyan%!Firmware_l!%_fReset%
rem @echo %_fCyan%Battery Level		: %_fBCyan%!Battery_l!%_fReset%
rem @echo %_fCyan%ExternalStatus%_fReset%		: %_fBCyan%!ExternalStatus_l!%_fReset%
rem @echo %_fCyan%TrackingStatus%_fReset%		: %_fBCyan%!TrackingStatus_l!%_fReset%
rem @echo %_fCyan%BrightnessLevel%_fReset%		: %_fBCyan%!BrightnessLevel_l!%_fReset%
rem @echo.
rem @echo  === %_fBYellow%!Type_R!%_fReset% ===
rem @echo %_fCyan%Firmware%_fReset%		: %_fBCyan%!Firmware_r!%_fReset%
rem @echo %_fCyan%Battery Level		: %_fBCyan%!Battery_r!%_fReset%
rem @echo %_fCyan%ExternalStatus%_fReset%		: %_fBCyan%!ExternalStatus_r!%_fReset%
rem @echo %_fCyan%TrackingStatus%_fReset%		: %_fBCyan%!TrackingStatus_r!%_fReset%
rem @echo %_fCyan%BrightnessLevel%_fReset%		: %_fBCyan%!BrightnessLevel_r!%_fReset%
rem EndEngTextBlock
rem @echo TypeShort=!TypeShort!
@echo.
rem )

endlocal
call :_prevmenu
goto _syscommenu




:_MemoryUsageInfoMenu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Общая загрузка памяти
@echo    B.  Использование памяти по приложениям
@echo    C.  Мониторинг памяти в реальном времени (с запросом параметров)
@echo    D.  Мониторинг памяти в реальном времени (с авто параметрами)
@echo.
@echo.
@echo   %_fBYellow%Этот раздел служит для сбора статистики и анализа использования оперативной памяти шлема.
@echo.
@echo   %_fBGreen%Опция "Общая загрузка памяти" %_fReset%показывает сводные данные о состоянии оперативной памяти 
@echo   устройства: общий объём RAM, сколько используется, сколько свободно.
@echo   %_fCyan%Опция полезна для быстрой оценки загрузки системы.
@echo.
@echo   %_fBGreen%Опция "Использование памяти по приложениям" %_fReset%выводит список процессов и приложений
@echo   с указанием объёма занятой ими памяти. Есть возможность отобразить только системные 
@echo   или только пользовательские процессы, вывести список наиболее «тяжёлых» приложений.
@echo   Для выбора отображения только одного типа приложений (пользовательские или системные)
@echo   вводите двухбуквенный режим пункта %_fBYellow%B%_fReset% меню: %_fBYellow%bu%_fReset% или %_fBYellow%bs%_fReset%. После старта программа попросит
@echo   ввести количество приложений для показа. Введите желаемое количество или нажмите %_fBYellow%Enter%_fReset%
@echo   для ввода значения по умолчанию (%_fBYellow%40 приложений%_fReset%). После завершения рядом с программой
@echo   будет лежать файл %_fBYellow%meminfo.log%_fReset% с логами. Каждый тест добавляет в файл новые записи. %_fCyan%Опция
@echo   используется для поиска «прожорливых» процессов и анализа, кто именно загружает устройство.
@echo.
@echo   %_fBGreen%Опция "Мониторинг памяти в реальном времени (с запросом параметров)" %_fReset%следит за использованием
@echo   памяти приложениями. Одновременно записывает данные в CSV-файл для дальнейшего анализа,
@echo   отображает динамику памяти в консоли, дает возможность задать интервал обновления
@echo   и количество снимков, остановку мониторинга по клавише %_fBYellow%Esc%_fReset%. 
@echo   После старта программа попросит ввести количество приложений, которые будет мониторить,
@echo   количество проверок и интервал между проверками в секундах. Можно нажимать %_fBYellow%Enter%_fReset%
@echo   и будут автоматически подставлены значения по умолчанию: %_fBYellow%40 приложений и 30 проверок
@echo   с интервалом 5 секунд%_fReset%. Для возврата в меню вводите %_fBYellow%0%_fReset%. Можно прервать выполнение программы
@echo   в любой момент, нажав %_fBYellow%Esc%_fReset%. После завершения проверки рядом с программой будет лежать файл
@echo   %_fBYellow%mem_monitor_(текущая дата).csv%_fReset% с результатами мониторинга.
@echo.
@echo   %_fBGreen%Опция "Мониторинг памяти в реальном времени (с авто параметрами)" %_fReset%работает точно так же, как
@echo   предыдущая, но параметры введдутся автоматически, и после старта сразу начнется мониторинг.
@echo   Параметры точно такие же, как дефолтные - %_fBYellow%40 приложений и 30 проверк с интервалом 5 секунд. 
@echo.
@echo   %_fCyan%Опции мониторинга служат для отслеживания изменений памяти и поиска утечек.%_fReset%

rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Total memory load
rem @echo    B.  Memory usage by applications
rem @echo    C.  Real-time memory monitoring (with parameter input)
rem @echo    D.  Real-time memory monitoring (with auto parameters)
rem @echo.
rem @echo.
rem @echo   %_fBYellow%This section is used to collect statistics and analyze the use of the headset’s RAM.
rem @echo.
rem @echo   %_fBGreen%The "Total memory load" option %_fReset%shows summary data on the state of the device’s RAM:
rem @echo   total RAM size, how much is used, and how much is free.
rem @echo   %_fCyan%This option is useful for quickly assessing system load.
rem @echo.
rem @echo   %_fBGreen%The "Memory usage by applications" option %_fReset%displays a list of processes and applications
rem @echo   with the amount of memory they use. You can display only system
rem @echo   or only user processes, or output a list of the most “heavy” applications.
rem @echo   To display only one type of application (user or system),
rem @echo   enter the two-letter mode of menu item %_fBYellow%B%_fReset%: %_fBYellow%bu%_fReset% or %_fBYellow%bs%_fReset%. After starting, the program will ask
rem @echo   you to enter the number of applications to show. Enter the desired number or press %_fBYellow%Enter%_fReset%
rem @echo   to use the default value (%_fBYellow%40 applications%_fReset%). After completion, a meminfo.log file
rem @echo   will appear next to the program with logs. Each test adds new records to the file. %_fCyan%This option
rem @echo   is used to find “greedy” processes and analyze who is loading the device.
rem @echo.
rem @echo   %_fBGreen%The "Real-time memory monitoring (with parameter input)" option %_fReset%monitors application
rem @echo   memory usage. At the same time, it writes data to a CSV file for further analysis,
rem @echo   displays memory dynamics in the console, and allows you to set the update interval
rem @echo   and number of snapshots, with the option to stop monitoring using the %_fBYellow%Esc%_fReset% key. 
rem @echo   After starting, the program will ask you to enter the number of applications to monitor,
rem @echo   the number of checks, and the interval between checks in seconds. You can press %_fBYellow%Enter%_fReset%
rem @echo   and default values will be applied: %_fBYellow%40 applications and 30 checks with a 5 second interval%_fReset%.
rem @echo   To return to the menu, enter %_fBYellow%0%_fReset%. You can interrupt the program at any time by pressing Esc.
rem @echo   After the check is completed, a file %_fBYellow%mem_monitor_(current date).csv%_fReset% will appear
rem @echo   next to the program with the monitoring results.
rem @echo.
rem @echo   %_fBGreen%The "Real-time memory monitoring (with auto parameters)" option %_fReset%works exactly the same as the
rem @echo   previous one, but the parameters are entered automatically, and monitoring starts immediately.
rem @echo   Parameters are the same as the defaults: %_fBYellow%40 applications and 30 checks with a 5 second interval. 
rem @echo.
rem @echo   %_fCyan%The monitoring options are used to track memory changes and find leaks.%_fReset%
rem EndEngTextBlock
@echo   ----------------------------------------------
@echo.
set choice=
call :_MenuChoiceEnter
@echo.
if not defined choice goto _MemoryUsageInfoMenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (call :_MemUsage)
if /i "%choice%"=="b" (call :_MemInfoList)
if /i "%choice%"=="bu" (call :_MemInfoList)
if /i "%choice%"=="bs" (call :_MemInfoList)
if /i "%choice%"=="c" (call :_MemMonitoringRequestData)
if /i "%choice%"=="d" (call :_MemMonitoringAutoData)
goto _MemoryUsageInfoMenu


:_MemUsage
for /f "tokens=1,2,3 delims=," %%a in ('powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%myfiles%\memuni.ps1"  -MemUsage') do (
    set TotalRAM=%%a
    set TotalRAM=%%a
    set FreeRAM=%%b
    set UsedRAM=%%c
)
@echo.
@echo   ---------------------------
rem StartRusTextBlock
@echo    %_fBYellow%Всего памяти%_fReset%	: %_fBGreen%%TotalRAM%%_fReset%
@echo    %_fBYellow%Свободно%_fReset%	: %_fBGreen%%FreeRAM%%_fReset%
@echo    %_fBYellow%Используется%_fReset%	: %_fBGreen%%UsedRAM%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%Total memory%_fReset%	: %_fBGreen%%TotalRAM%%_fReset%
rem @echo    %_fBYellow%Free%_fReset%	        : %_fBGreen%%FreeRAM%%_fReset%
rem @echo    %_fBYellow%Used%_fReset%	        : %_fBGreen%%UsedRAM%%_fReset%
rem EndEngTextBlock
@echo   ---------------------------
call :_prevmenu
exit /b



:_MemInfoList
rem -sys
rem -usr
set typelist=
if %choice%==bu set "typelist=-usr"&&goto _MemInfoListRun
if %choice%==bs set "typelist=-sys"&&goto _MemInfoListRun
rem set "typelist="



:_MemInfoListRun
set topnumber=40
rem StartRusTextBlock
set /p topnumber="Введите количество приложений: "
rem EndRusTextBlock
rem StartEngTextBlock
rem set /p topnumber="Enter the number of applications: "
rem EndEngTextBlock
cls
@echo.
set LOGFILE=meminfo.log
@echo =======  %DATE% %TIME%  ======= >> "!LOGFILE!"
@echo --- !DevModelNm! - !fwnumb! (!sfn!) --- >> "!LOGFILE!"
rem @echo %DevModelNm%
rem @echo %fwnumb% (%sfn%)
rem @echo 
rem pause
@echo. >> "!LOGFILE!"

rem pause
rem %typelist%
rem start " " powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%myfiles%\diagram.ps1" -csv "%datafile%" -title "%VectorMessage%" %grebenka%


for /f "usebackq delims=" %%i in (`powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%myfiles%\memuni.ps1" -MemInfo !typelist! -Top !topnumber!`) do (
    set "line=%%i"
    set "color=%_fReset%"
rem @echo !line!
    :: Проверяем наличие метки и присваиваем цвет
echo !line! | find "[SYS]" >nul
if "!errorlevel!" equ "0" set "color=%_fCyan%"

echo !line! | find "[USR]" >nul
if "!errorlevel!" equ "0" set "color=%_fBCyan%"

    :: Выводим раскрашенную строку на экран
    <nul set /p= !color!!line!!_fReset!
echo.

    :: Записываем в лог без цвета
echo %%i >> "!LOGFILE!"
)

rem endlocal
rem call :_SetColours
call :_prevmenu
exit /b


:_MemMonitoringAutoData
set topnumber=40
set memcount=30
set meminterval=5
set "isconsole=-Console"
goto _StartMemMonitoringScript


:_MemMonitoringRequestData
@set topnumber=40
rem StartRusTextBlock
@set /p topnumber="Введите количество приложений и нажмите Enter (0 - Выход) : "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p topnumber="Enter the number of applications and press Enter (0 - Exit) : "
rem EndEngTextBlock
if %topnumber%==0 goto _MemoryUsageInfoMenu
@echo %topnumber%
@echo.

set memcount=30
rem StartRusTextBlock
@set /p memcount="Введите количество проверок и нажмите Enter (0 - Выход) : "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p memcount="Enter the number of checks and press Enter (0 - Exit): "
rem EndEngTextBlock
if %memcount%==0 goto _MemoryUsageInfoMenu
@echo %memcount%
@echo.

:_setmeminterval
set meminterval=5
rem StartRusTextBlock
@set /p meminterval="Введите интервал в секундах и нажмите Enter (0 - Выход) : "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p meminterval="Enter the interval in seconds and press Enter (0 - Exit) : "
rem EndEngTextBlock
if %meminterval%==0 goto _MemoryUsageInfoMenu
rem StartRusTextBlock
if %meminterval% GTR 1800 @echo   %_fRed%Максимальный интервал 1800. Повторите ввод.%_fReset%&&goto _setmeminterval
rem EndRusTextBlock
rem StartEngTextBlock
rem if %meminterval% GTR 1800 @echo   %_fRed%Maximum interval 1800%_fReset%&&goto _setmeminterval
rem EndEngTextBlock
@echo %meminterval%
@echo.

rem if %choice%==cc 
set "isconsole=-Console"

rem set topnumber=20
rem set meminterval=5
rem set memcount=10

:_StartMemMonitoringScript
call :_settime
rem StartRusTextBlock
@echo ...Старт мониторинга памяти...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ...Memory monitoring starting...
rem EndEngTextBlock
@echo.
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%myfiles%\memuni.ps1"  -MemMon -Top !topnumber! -Interval !meminterval! -Count !memcount! !isconsole! -CsvFile mem_monitor_%dt%.csv
call :_prevmenu
exit /b

:_RunningAppsListMenu
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo         МЕНЮ ЗАПУЩЕННЫХ ПРИЛОЖЕНИЙ
@echo         ==========================
@echo.
@echo    A.  Список пользовательских приложений
@echo    B.  Список системных приложений
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         RUNNING APPLICATIONS MENU
rem @echo         ==========================
rem @echo.
rem @echo    A.  List of user applications
rem @echo    B.  List of system applications
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _RunningAppsListMenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _RunningUserApps)
if /i "%choice%"=="b" (GOTO _RunningSysApps)
goto _RunningAppsListMenu

:_RunningUserApps
call :_Settime
cls
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   Информация о запущенных пользовательских приложениях
@echo.
@echo   Для перелистывания используйте клавиши Enter и Пробел.
@echo        Чтобы продолжить, нажмите любую клавишу
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Information about running user applications
rem @echo.
rem @echo   Use Enter and Space keys to scroll through.
rem @echo        Press any key to continue
rem EndEngTextBlock
@echo  -------------------------------------------------------
@pause >nul
@echo.
@%MYFILES%\adb shell ps -A | findstr u0_a | more
@%MYFILES%\adb shell ps -A | findstr u0_a >RunningUserApps%dt%.txt
@echo  -----------------------------------------------
@echo.
rem StartRusTextBlock
@echo   Эта информация сохранена в текстовый файл RunningUserApps%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   This information has been saved to the text file RunningUserApps%dt%.txt
rem EndEngTextBlock
goto _returnmenu

:_RunningSysApps
call :_Settime
cls
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   Информация о запущенных систиемных приложениях
@echo.
@echo   Для перелистывания используйте клавиши Enter и Пробел.
@echo        Чтобы продолжить, нажмите любую клавишу
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Information about running system applications
rem @echo.
rem @echo   Use Enter and Space keys to scroll through.
rem @echo        Press any key to continue
rem EndEngTextBlock
@echo  -------------------------------------------------------
@pause >nul
@echo.
@%MYFILES%\adb shell ps -A | findstr system | more
@%MYFILES%\adb shell ps -A | findstr system >RunningSysApps-%dt%.txt
@echo  -----------------------------------------------
@echo.
rem StartRusTextBlock
@echo   Эта информация сохранена в текстовый файл RunningSysApps-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   This information has been saved to the text file RunningSysApps%dt%.txt
rem EndEngTextBlock
goto _returnmenu

:_MemoryUsageInfo
call :_Settime
cls
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   Информация об использовании памяти
@echo.
@echo   Для перелистывания используйте клавиши Enter и Пробел.
@echo        Чтобы продолжить, нажмите любую клавишу
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Information about memory usage
rem @echo.
rem @echo   Use Enter and Space keys to scroll through.
rem @echo        Press any key to continue
rem EndEngTextBlock
@echo  -------------------------------------------------------
@pause >nul
@echo.
@%MYFILES%\adb shell dumpsys meminfo | more
@%MYFILES%\adb shell dumpsys meminfo >MemInfo-%dt%.txt
@echo  -----------------------------------------------
@echo.
rem StartRusTextBlock
@echo   Эта информация сохранена в текстовый файл MemInfo-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   This information has been saved to the text file MemInfo-%dt%.txt
rem EndEngTextBlock
goto _returnmenu


:_UpdatesInfo
goto _syscommenu
call :_cdc
rem StartRusTextBlock
@echo =  Были установлены обновления:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo =  Updates have been installed:
rem EndEngTextBlock
@echo.
call :_settime
@%verbecho%
rem !!!!!!! Узнать как называется раздел в английском dumpsys !!!!!
rem Oculus Core Mobile Services
rem %myfiles%\adb shell dumpsys DumpsysProxy 'Ключевые мобильные сервисы Oculus (DumpsysLedger)' >dspo.txt

Setlocal EnableDelayedExpansion
@FOR /f "tokens=*" %%a IN (dspo.txt) do set a=%%a
@set a=!a:,= !
rem @echo !a!
for %%b in (!a!) do (
@echo %%b >>list3.txt
)

set "searchString=identifier"
set "nextLine="
for /f "delims=" %%a in (list3.txt) do (
if defined nextLine (
set "nextLine=%%a"
call :_found
)
@echo %%a | findstr /C:"%searchString%" >nul
if not errorlevel 1 (
set "nextLine=true"
)
)
endlocal
@del /F /Q list3.txt 1>nul 2>nul
@del /F /Q dspo.txt 1>nul 2>nul
call :_prevmenu
goto _syscommenu


:_found
@if not %nextLine%==[] @echo %nextLine%
rem >>name.txt
rem if not %nextLine%==[] @echo https://securecdn.oculus.com/binaries/download/?id=%nextLine%>>numb.txt
set "nextLine="
exit /b
endlocal
@del /F /Q list3.txt 1>nul 2>nul
@del /F /Q dspo.txt 1>nul 2>nul
call :_prevmenu
goto _syscommenu
rem @echo =  Готово. Инфа в файле UpdateInfo-%dt%.txt
rem @echo --------------------------------------------------------------
call :_prevmenu
goto _syscommenu



:_AllSystemFiles
rem StartRusTextBlock
@echo =  Сохранение всей системной информации оптом..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo =  Bulk saving of all system information...
rem EndEngTextBlock
call :_settime
md %cd%\allsysinfo 1>NUL 2>&1
@%MYFILES%\adb shell dumpsys 2>nul >%cd%\allsysinfo\dumpsysfull-%dt%.txt
call :_erlvl
@%MYFILES%\adb shell getprop >%cd%\allsysinfo\properties-%dt%.txt
@%MYFILES%\adb shell pm list packages -f -a >%cd%\allsysinfo\packages-list-%dt%.txt
@%MYFILES%\adb shell settings list global >%cd%\allsysinfo\global-%dt%.txt
@%MYFILES%\adb shell settings list secure >%cd%\allsysinfo\secure-%dt%.txt
@%MYFILES%\adb shell settings list system >%cd%\allsysinfo\system-%dt%.txt
@%myfiles%\adb bugreport %cd%\allsysinfo
@%myfiles%\adb logcat -d >%cd%\allsysinfo\lc-all-%dt%.txt
@%myfiles%\7z.exe a -mx7 -t7z -ssw allsysinfo-%dt%.7z %cd%\allsysinfo 1>NUL 2>&1
@rd /q /s "%cd%\allsysinfo" 2>nul 1>nul
@echo.
rem StartRusTextBlock
@echo =  Готово. Инфа сложена в один архив allsysteminfo-%dt%.7z
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo =  Done. Info is packed into one archive allsysteminfo-%dt%.7z
rem EndEngTextBlock
@echo --------------------------------------------------------------
call :_prevmenu
goto _syscommenu

:_scrtimeout
@%MYFILES%\adb shell settings put system screen_off_timeout 86400000
call :_erlvl
:: 2>nul 1>nul
call :_hat
@echo.
@echo.
@echo -------------------------------------------
rem StartRusTextBlock
@echo  Настройки отключения экрана восстановлены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Screen timeout settings restored
rem EndEngTextBlock
@echo.
@echo.
call :_prevmenu
goto _shellmenu


:_sysnameall
:: Наименования всех сервисов
@%MYFILES%\adb shell dumpsys -l >%cd%\servicelist-%dt%.txt 
call :_erlvl
@echo =============================
rem StartRusTextBlock
@echo  Наименования сервисов сохранены в текущий каталог в файл servicelist-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Service names are saved to the current directory in the file servicelist-%dt%.txt
rem EndEngTextBlock
::@@echo  Для вывода информации о конкретном сервисе, введите его имя в конце команды.
::@@echo  Примеры:
::@@echo      adb shell dumpsys wifi
::@@echo      adb shell dumpsys TelemetryService
call :_prevmenu
goto _syscommenu

:_dumpsysmenu
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Сохранить полный список состояния (dumpsys)
@echo    B.  Поиск и выборка по определенному слову
@echo    C.  Поиск и выборка, ИСКЛЮЧАЯ определенное слово
@echo    D.  Наименование всех сервисов (dumpsys -l)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Save the full state list (dumpsys)
rem @echo    B.  Search and selection by a specific word
rem @echo    C.  Search and selection, EXCLUDING a specific word
rem @echo    D.  Name of all services (dumpsys -l)
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _dumpsysmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _dumpsysfull)
if /i "%choice%"=="b" (GOTO _dumpsyssrchincl)
if /i "%choice%"=="c" (GOTO _dumpsyssrchex)
if /i "%choice%"=="d" (GOTO _sysnameall)
cls
goto _dumpsysmenu

:_dumpsysfull
call :_cdc
:: Полный список состояния системных сервисов
rem StartRusTextBlock
@echo  Секундочку, снимаем дамп... 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Just a moment, taking a dump...
rem EndEngTextBlock
@echo ----------------------------------
@%MYFILES%\adb shell dumpsys 2>nul >dumpsysfull-%dt%.txt
@echo =============================
rem StartRusTextBlock
@echo  Дамп сохранен в текущий каталог в файл dumpsysfull-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Dump saved to the current directory in the file dumpsysfull-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _syscommenu

:_dumpsyssrchincl
call :_cdc
call :_settime
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   Будет снят полный дамп и из него будут выбраны только те строки, 
@echo   в которых содержится искомое слово.
@echo   Выборка сохранится в файл dumpsys-слово-для-поиска.txt
@echo.
@echo   Если передумали, введите 0 и нажмите Enter
@echo   для возврата в предыдущее меню.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   A full dump will be taken and only the lines containing the search word will be selected from it.
rem @echo   The selection will be saved to the file dumpsys-search-word.txt
rem @echo.
rem @echo   If you changed your mind, enter 0 and press Enter
rem @echo   to return to the previous menu.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
:: Полный список состояния системных сервисов
rem StartRusTextBlock
@Set /p srch=" Bведите слово для выборки и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p srch="Enter the word for selection and press Enter: "
rem EndEngTextBlock
if %srch%==0 goto _dumpsysmenu
@echo ================================
rem StartRusTextBlock
@echo  Секундочку, снимаем дамп... 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Just a moment, taking a dump...
rem EndEngTextBlock
@echo.
@echo ----------------------------------
@%MYFILES%\adb shell dumpsys 2>nul >dumpsrch.txt
call :_erlvl
>nul findstr /i /c:"%srch%" < dumpsrch.txt >> dumpsys-%srch%-%dt%.txt
@echo =============================
rem StartRusTextBlock
@echo  Дамп сохранен в текущий каталог в файл dumpsys-%srch%-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Dump saved to the current directory in the file dumpsys-%srch%-%dt%.txt
rem EndEngTextBlock
@del dumpsrch.txt /q
call :_prevmenu
goto _syscommenu

:_dumpsyssrchex
call :_cdc
call :_settime
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   Будет снят полный дамп и из него будут выбраны только те строки, 
@echo   в которых НЕ содержится искомое слово.
@echo   Выборка сохранится в файл dumpsys-слово-для-поиска.txt
@echo.
@echo   Если передумали, введите 0 и нажмите Enter
@echo   для возврата в предыдущее меню.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   A full dump will be taken and only the lines NOT containing the search word will be selected from it.
rem @echo   The selection will be saved to the file dumpsys-search-word.txt
rem @echo.
rem @echo   If you changed your mind, enter 0 and press Enter
rem @echo   to return to the previous menu.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
:: Полный список состояния системных сервисов
rem StartRusTextBlock
@Set /p srch=" Bведите слово для выборки и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p srch="Enter the word for selection and press Enter: "
rem EndEngTextBlock
if %srch%==0 goto _dumpsysmenu
@echo ================================
rem StartRusTextBlock
@echo  Секундочку, снимаем дамп... 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Just a moment, taking a dump...
rem EndEngTextBlock
@echo.
@echo ----------------------------------
@%MYFILES%\adb shell dumpsys 2>nul >dumpsrch.txt
call :_erlvl
>nul findstr /i /v /c:"%srch%" < dumpsrch.txt >> dumpsys-%srch%-%dt%.txt
@echo =============================
rem StartRusTextBlock
@echo  Дамп сохранен в текущий каталог в файл dumpsys-%srch%-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Dump saved to the current directory in the file dumpsys-%srch%-%dt%.txt
rem EndEngTextBlock
@del dumpsrch.txt /q
call :_prevmenu
goto _syscommenu

:_batinfo
call :_cdc
:: Информация о батарее
call :_BattseryStatTab
@%MYFILES%\adb shell dumpsys battery >battery-%dt%.txt
call :_erlvl
@echo ----------------------------------------------------
rem StartRusTextBlock
@echo  Дополнительная информация о батарее сохранена в файл battery-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Additional battery information saved to the file battery-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _syscommenu

:_allprop
:: Вывести все свойства
@%MYFILES%\adb shell getprop >properties-%dt%.txt
call :_erlvl
@echo =============================
rem StartRusTextBlock
@echo  Информация о свойствах сохранена в текущий каталог в файл properties-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Properties information saved to the current directory in the file properties-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _syscommenu

:_showip
call :_cdc
:: Показать IP адрес шлема
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|findstr /i /c:"inet "') DO @set ipfull=%%G
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO @set ip=%%G
rem StartRusTextBlock
@echo  IP адрес шлема: %ip%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset IP address: %ip%
rem EndEngTextBlock
call :_prevmenu
goto _syscommenu

:_showserial
call :_cdc
:: Показать серийный номер шлема
rem StartRusTextBlock
@echo Серийный номер шлема:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Headset Serial Number:
rem EndEngTextBlock
@%MYFILES%\adb shell getprop ro.boot.serialno
call :_erlvl
call :_prevmenu
goto _syscommenu

:_syscomm
call :_cdc
:: Системные команды
@%MYFILES%\adb shell settings list global >global-%dt%.txt
call :_erlvl
@%MYFILES%\adb shell settings list secure >secure-%dt%.txt
@%MYFILES%\adb shell settings list system >system-%dt%.txt
@echo ======================================
rem StartRusTextBlock
@echo  Общие настройки в файле global-%dt%.txt в текущем каталоге
@echo  Настройки безопасности в файле secure-%dt%.txt в текущем каталоге
@echo  Системные настройки в файле system-%dt%.txt в текущем каталоге
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  General settings in the file global-%dt%.txt in the current directory
rem @echo  Security settings in the file secure-%dt%.txt in the current directory
rem @echo  System settings in the file system-%dt%.txt in the current directory
rem EndEngTextBlock
call :_prevmenu
goto _syscommenu

:_adbintegr
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Встроить ADB и пакет утилит в систему
@echo    B.  Встроить только ADB в систему
@echo    C.  Удалить ADB и пакет утилит из системы
@echo.
@echo  ==================================================
@echo.
@echo     ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo   %_fBRed%Для встраивания ADB в систему требуются права администратора^!%_fReset%
@echo.
@echo.
@echo  При встраивании пакета утилит в каталог %windir% 
@echo  будут скопированы (не установлены, а скопированы!)
@echo  следующие файлы:
@echo.
@echo 	adb.exe
@echo 	adbWinApi.dll
@echo 	AdbWinUsbApi.dll
@echo 	aapt2.exe
@echo 	devcon_x64.exe
@echo 	fastboot.exe
@echo 	7z.dll
@echo 	7z.exe
@echo.
@echo  При встраивании только ADB будут скопированы 
@echo  первые три файла из этого списка.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Embed ADB and utility package into the system
rem @echo    B.  Embed only ADB into the system
rem @echo    C.  Remove ADB and utility package from the system
rem @echo.
rem @echo  ==================================================
rem @echo.
rem @echo     PLEASE NOTE:
rem @echo.
rem @echo   %_fBRed%Administrator privileges are required to embed ADB into the system^!%_fReset%
rem @echo.
rem @echo  When embedding the utility package into the %windir% directory,
rem @echo  the following files will be copied (not installed, but copied!):
rem @echo.
rem @echo 	adb.exe
rem @echo 	adbWinApi.dll
rem @echo 	AdbWinUsbApi.dll
rem @echo 	aapt2.exe
rem @echo 	devcon_x64.exe
rem @echo 	fastboot.exe
rem @echo 	7z.dll
rem @echo 	7z.exe
rem @echo.
rem @echo  When embedding only ADB, the first three files from this list will be copied.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@set "choice="
@set "choice=A"
rem StartRusTextBlock
@Set /p choice="Выберите пункт меню и нажмите Enter (Enter - A): "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Select a menu number and press Enter (Only Enter = A): "
rem EndEngTextBlock
@echo.
if not defined choice goto _adbintegr
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _adbintegration)
if /i "%choice%"=="b" (GOTO _onlyadbintegration)
if /i "%choice%"=="c" (GOTO _desadbintegration)
cls
goto _adbintegr

:_adbintegration
call :_CheckAdminRights
call :_CheckOSVersion
if defined adminmsg  echo %adminmsg% && goto _returnmenu
@xcopy %MYFILES%\aapt2.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\devcon_x64.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\fastboot.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\7z.dll %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\7z.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\adb.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinApi.dll %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinUsbApi.dll %windir%\*.* /Y 1>NUL 2>&1
@echo ===================================================
rem StartRusTextBlock
@echo  ADB и пакет утилит встроены в систему. 
@echo  Теперь в консоли cmd можно не указывать путь к adb,
@echo  а просто писать команду, например: adb devices
@echo.
@echo  Также можно использовать другие утилиты сразу, 
@echo  без необходимости указывать путь к ним.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ADB and utility package are embedded into the system.
rem @echo  Now in the cmd console you can omit the path to adb,
rem @echo  and just write the command, for example: adb devices
rem @echo.
rem @echo  You can also use other utilities immediately,
rem @echo  without having to specify their path.
rem EndEngTextBlock
@echo -------------------------------------------------
call :_prevmenu
goto _syscommenu

:_onlyadbintegration
call :_CheckAdminRights
call :_CheckOSVersion
if defined adminmsg  echo %adminmsg% && goto _returnmenu
@xcopy %MYFILES%\adb.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinApi.dll %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinUsbApi.dll %windir%\*.* /Y 1>NUL 2>&1
@echo =====================================================
rem StartRusTextBlock
@echo  ADB встроен в систему. 
@echo  Теперь в консоли cmd можно не указывать путь к adb,
@echo  а просто писать команду, например: adb devices
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ADB is embedded into the system.
rem @echo  Now in the cmd console you can omit the path to adb,
rem @echo  and just write the command, for example: adb devices
rem EndEngTextBlock
@echo ---------------------------------------------------
call :_prevmenu
goto _syscommenu

:_desadbintegration
call :_CheckAdminRights
call :_CheckOSVersion
if defined adminmsg  echo %adminmsg% && goto _returnmenu
@taskkill /im adb.exe /f 1>nul 2>nul
@del %windir%\adb.exe /q /f 1>NUL 2>&1
@del %windir%\AdbWinApi.dll /q /f 1>NUL 2>&1
@del %windir%\AdbWinUsbApi.dll /q /f 1>NUL 2>&1
@del %windir%\aapt2.exe /q /f 1>NUL 2>&1
@del %windir%\devcon_x64.exe /q /f 1>NUL 2>&1
@del %windir%\fastboot.exe /q /f 1>NUL 2>&1
@del %windir%\7z.dll /q /f 1>NUL 2>&1
@del %windir%\7z.exe /q /f 1>NUL 2>&1
@echo ================================================================
rem StartRusTextBlock
@echo  Как заказывали: Весь интегрированный хлам удален из %windir%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  As ordered: All integrated junk has been removed from %windir%
rem EndEngTextBlock
@echo ----------------------------------------------------------------

call :_prevmenu
goto _syscommenu

:_TempComponents

:_alltempmenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo      МОНИТОРИНГ И ДИАГНОСТИКА КОМПОНЕНТОВ
@echo.
@echo.
@echo.
@echo  Каждые несколько секунд значения обновляются автоматически.
@echo.
@echo  Если ввести интервал с буквой "w" в конце числа,
@echo  то показания будут сохранены в файл csv.
@echo.
@echo  Например, для интервала 10 секунд и сохранения в файл ведите "10w", без кавычек.
@echo  По умолчанию интервал 5 секунд и без записи в файл 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      MONITORING AND DIAGNOSTICS OF COMPONENTS
rem @echo.
rem @echo.
rem @echo.
rem @echo  Every few seconds the values are updated automatically.
rem @echo.
rem @echo  If you enter an interval with the letter "w" at the end of the number,
rem @echo  the readings will be saved to a csv file.
rem @echo.
rem @echo  For example, for a 10 second interval and saving to a file, enter "10w", without quotes.
rem @echo  By default, the interval is 5 seconds and without saving to a file.
rem EndEngTextBlock
@echo.
@echo.
@set "intervaltemp="
@set "intervaltemp=5"
rem StartRusTextBlock
@Set /p intervaltemp="Введите новый интервал или просто нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p intervaltemp="Enter a new interval or just press Enter: "
rem EndEngTextBlock
if not defined intervaltemp goto _beginn
if "%intervaltemp%"=="0" (exit)
if /i "%intervaltemp%"=="m" (GOTO _beginn)
if /i "%intervaltemp:~-1%"=="w" (set intervaltempsav=%intervaltemp:~0,-1%&& goto _SaveFileMonitoring)
set intervaltempsav=%intervaltemp%
goto _alltemp

:_SaveFileMonitoring
call :_settime
set dtp=%dt%
call :_CreateFileMon

:_alltemp
call :_cdc
setlocal enableextensions enabledelayedexpansion

set cputempconst=CPU temperatures:
set gputempconst=GPU temperatures:
set battempconst=Battery temperatures:
set skntempconst=Skin temperatures:
set fanspedconst=Fan speed:
set /a cpuusagesum=0

rem @For /f "tokens=*" %%a in ('%MYFILES%\adb.exe shell dumpsys FanMonitorService') do set fancheck=%%a
@%MYFILES%\adb.exe shell dumpsys hardware_properties >hwp.txt

rem >>>>>>>>>>>>>>>>>
@For /f "tokens=*" %%a in ('%MYFILES%\adb.exe shell dumpsys hardware_properties ^| find "Fan speed:"') do set fanspeed=%%a
@For /f "tokens=1,2 delims=:" %%a in ('%MYFILES%\adb.exe shell dumpsys FanMonitorService ^| findstr "pwm-tach-fan0:"') do set "fanpwm=%%b"
@For /f "tokens=1-5 delims=: " %%a in ('%MYFILES%\adb.exe shell dumpsys FanMonitorService ^| findstr /c:"fan status:"') do (
set fanstatus=%%c
set fanwarnings=%%e
)


%myfiles%\adb.exe shell top -m 20 -n 1 -d 10 -bqH >top.txt
@For /f "tokens=9 delims= " %%a in (top.txt) do (
@set cpunumb=%%a
set /a st=!cpunumb:~0,-2!
set /a cpuusagesum=!st!+!cpuusagesum!
)

For /f "tokens=*" %%a in ('%MYFILES%\adb shell getprop debug.oculus.cpuLevel') do set cpulevel=%%a
For /f "tokens=*" %%a in ('%MYFILES%\adb shell getprop debug.oculus.gpuLevel') do set gpulevel=%%a
if [%cpulevel%]==[] set cpulevel=Auto
if [%gpulevel%]==[] set gpulevel=Auto


@FOR /F "skip=1 tokens=1,2,3" %%a IN (hwp.txt) DO (
@set aa=%%a
@set bb=%%b
@set cc=%%c
@set tempvar=!aa! !bb!
@IF !tempvar! == !cputempconst! set cputemp=!cc!
@IF !tempvar! == !gputempconst! set gputemp=!cc!
@IF !tempvar! == !battempconst! set battemp=!cc!
@IF !tempvar! == !skntempconst! set skntemp=!cc!
rem @IF !tempvar! == !fanspedconst! set fansped=!cc!
)

set usbnumb=1
for /f %%a in ('@%MYFILES%\adb.exe shell dumpsys thermalservice ^| findstr /i /c:"mType=4"') do (
set "tusb=%%a"
for /f "tokens=1,2 delims=,=" %%c in ("!tusb!") do (
set tempusb!usbnumb!=%%d
)
set /a usbnumb=!usbnumb!+1
)
if %IntProductName%==monterey set "tusb2=Only for Meta Quest 3/Pro" && set "tusb1=Only for Meta Quest 3/Pro"&&set "tusb3=Only for Meta Quest 3/Pro"&&set "tusb4=Only for Meta Quest 3/Pro"&& goto _ViewTempMonitoring

if %IntProductName%==hollywood set "tusb2=Only for Meta Quest 3/Pro"&& set "tusb1=Only for Meta Quest 3/Pro"&&set "tusb3=Only for Meta Quest 3/Pro"&&set "tusb4=Only for Meta Quest 3/Pro"&& goto _ViewTempMonitoring

set "tusb2=!tempusb2:~0,4!°"
set "tusb1=!tempusb1:~0,4!°"
set "tusb3=!tempusb3:~0,4!°"
set "tusb4=!tempusb4:~0,4!°"

:_ViewTempMonitoring
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  Мониторинг нагрузки и диагностика компонентов
@echo.
@echo --------------------------------------------
@echo  PWM статус вентилятора		: %fanpwm%
@echo  Статус вентилятора		: !fanstatus!
@echo  Скорость вентилятора		: !fanspeed:~12,-1!
@echo  Варнинги вентилятора		: !fanwarnings!
@echo.
@echo  Температура CPU		: !cputemp:~1,4!°
@echo  Температура GPU		: !gputemp:~1,4!°
@echo  Температура батареи		: !battemp:~1,4!°
@echo  Температура корпуса		: !skntemp:~1,4!°
@echo  Температура USB Cached		: %tusb2%
@echo  Температура USB Cached conn	: %tusb1%
@echo  Температура USB HAL		: %tusb3%
@echo  Температура USB HAL conn	: %tusb4%
@echo.
@echo  Уровень работы CPU		: !cpulevel!
@echo  Уровень работы GPU		: !gpulevel!
@echo  Загрузка CPU			: !cpuusagesum!%%%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Monitoring load and component diagnostics
rem @echo.
rem @echo --------------------------------------------
rem @echo  PWM Fan status		: %fanpwm%
rem @echo  Fan status		: !fanstatus!
rem @echo  Fan speed		: !fanspeed:~12,-1!
rem @echo  Fan warnings		: !fanwarnings!
rem @echo.
rem @echo  CPU Temperature        : !cputemp:~1,4!°
rem @echo  GPU Temperature        : !gputemp:~1,4!°
rem @echo  Battery Temperature    : !battemp:~1,4!°
rem @echo  Case Temperature       : !skntemp:~1,4!°
rem @echo  USB Cached temp	: !tempusb2:~0,4!°
rem @echo  USB Cached conn temp 	: !tempusb1:~0,4!°
rem @echo  USB HAL temp		: !tempusb3:~0,4!°
rem @echo  USB HAL conn temp	: !tempusb4:~0,4!°
rem @echo.
rem @echo  CPU Work Level         : !cpulevel!
rem @echo  GPU Work Level         : !gpulevel!
rem @echo  CPU Load               : !cpuusagesum!%%%
rem @echo --------------------------------------------
rem EndEngTextBlock
@echo.
@echo.
call :_settime
if "%intervaltemp:~-1%"=="w" @echo %dt%	!cputemp:~1,4!	!gputemp:~1,4!	!battemp:~1,4!	!skntemp:~1,4!	!tempusb2:~0,4!	!tempusb1:~0,4!	!tempusb3:~0,4!	!tempusb4:~0,4!	!cpulevel!	!gpulevel!	!fansped:~1,3!>>monitoring-%dtp%.csv
@del top.txt /q /f 1>NUL 2>&1
@del hwp.txt /q /f 1>NUL 2>&1
rem StartRusTextBlock
@echo Через %intervaltempsav% секунд результаты обновятся автоматически
@echo.
@echo  ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
@timeout %intervaltempsav%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The results will automatically update every %intervaltempsav% seconds
rem @echo.
rem @echo  To interrupt, press any key
rem @timeout %intervaltempsav%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem EndEngTextBlock



@echo.
rem StartRusTextBlock
@echo  ...Обновление значений....
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ...Values updating...
rem EndEngTextBlock
@endlocal
goto _alltemp

:_CreateFileMon
@echo DATETIME	TCPU	TGPU	TBAT	TCAS	TUSBC	TUSBCc	TUSBH	TUSBHc	LCPU	LGPU	SFAN>monitoring-%dtp%.csv
exit /b

:_setshare
cls
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo   Расшаренный ресурс будет создан от имени текущего пользователя
@echo.
@echo   Введите имя папки и полный путь к ней, например D:\Video
@echo   Путь и имя папки можно скопировать из Проводника Windows
@echo   и вставить сюда. Путь должен содержать только один каталог, 
@echo   иначе говоря, такой вариант: D:\Video\Media не пойдет.
@echo.
@echo   Папка может быть как новой, так и уже имеющейся.
@echo   В случае отсутствия папки, она будет создана.
@echo.
@echo   Права доступа по сети на папку - Только чтение.
@echo.
@echo.
@echo -------------------------------------------------------
@echo   Если передумали - введите "0" и нажмите Enter для возврата в Главное меню.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  ATTENTION:
rem @echo.
rem @echo  The shared resource will be created on behalf of the current user
rem @echo.
rem @echo  Enter the folder name and the full path to it, for example D:\Video
rem @echo  The path and folder name can be copied from Windows Explorer
rem @echo  and paste it here. The path should contain only one directory,
rem @echo  in other words, such an option: D:\Video\Media won't work.
rem @echo.
rem @echo  The folder can be either new or already existing.
rem @echo  If the folder does not exist, it will be created.
rem @echo.
rem @echo  Network access rights to the folder - Read Only.
rem @echo.
rem @echo.
rem @echo -------------------------------------------------------
rem @echo  If you change your mind - enter "0" and press Enter to return to the Main menu.
rem EndEngTextBlock
@echo.
@set remoteuser=%username%
rem StartRusTextBlock
@Set /p fullmediafolder="Введите здесь имя папки и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p fullmediafolder="Enter the folder name here and press Enter: "
rem EndEngTextBlock
if %fullmediafolder%==0 goto _beginn
md %fullmediafolder%
set mf=%fullmediafolder:~3%
@net share %mf%="%fullmediafolder%"
@cmd/c takeown /f "%fullmediafolder%" /r /d y 2>nul 1>&2 && icacls "%fullmediafolder%" /grant:r "%remoteuser%":(OI)(CI)F /t
@echo.
@echo ----------------------
rem StartRusTextBlock
@echo Готово, можно подключаться.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Ready, you can connect now.
rem EndEngTextBlock
@echo.
@goto _returnmenu

:_cpuload
call :_cdc
@%verbecho%
@echo ========================
rem StartRusTextBlock
@echo Снимаем дамп, секунду..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Taking a dump, one moment..
rem EndEngTextBlock
@%MYFILES%\adb logcat -c 2>nul
call :_erlvl
@%MYFILES%\adb shell dumpsys binder_calls_stats -a >dump.txt 2>nul
@echo ------------------------
rem StartRusTextBlock
@echo Парсим дамп..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Parsing the dump..
rem EndEngTextBlock
(SetLocal EnableDelayedExpansion
 set/a $ai=-1
 for /f "usebackq delims=" %%a in ("dump.txt") do @(set "$a=%%a"
 if "!$a:~,15!"=="Per-UID Summary" set/a $ai=36
 if !$ai! geq 0 set/a $ai-=1& @echo:!$a!)
EndLocal)>"cpustat.txt"
@cls
@echo.
@type cpustat.txt
@del cpustat.txt
@del dump.txt
@goto _returnmenu

:_sizecheckmenu
cls
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    S.  Просмотр занимаемого места   [EXP]
@echo.
@echo.
@echo ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo      Процесс может занять значительное время!
@echo.      
@echo      Файл с результатами будет размещен рядом с программой.
@echo      По окончании сканирования он будет открыт текстовой программой по умолчанию.
@echo      Число в начале строки - объем занимаемого места в мегабайтах.      
@echo      Все, что меньше 10 мегабайт, не учитывается.
@echo.
@echo      Разумеется, каталоги сканируются не все, а только те, 
@echo      к которым резрешен доступ. Поэтому выводимые данные
@echo      хоть и достоверны, но отнюдь не полны.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    S.  View occupied space   [EXP]
rem @echo.
rem @echo.
rem @echo Note:
rem @echo.
rem @echo      The process may take a significant amount of time!
rem @echo.      
rem @echo      The file with the results will be placed next to the program.
rem @echo      Upon completion of the scan, it will be opened by the default text editor.
rem @echo      The number at the beginning of the line is the volume of space occupied in megabytes.      
rem @echo      Anything less than 10 megabytes is not counted.
rem @echo.
rem @echo      Of course, not all directories are scanned, only those 
rem @echo      to which access is allowed. Therefore, the output data
rem @echo      is reliable, but not complete.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _sizecheckmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="s" (GOTO _sizecheck)
cls
goto _sizecheckmenu

:_sizecheck
call :_cdc
@%verbecho%
@setlocal enableextensions enabledelayedexpansion

@del ls.txt /q 2>nul 1>nul
@del lslist.txt /q 2>nul 1>nul
@del dupd.txt /q 2>nul 1>nul
@del du0.txt /q 2>nul 1>nul
@del sizelist.txt /q 2>nul 1>nul

%myfiles%\adb shell "ls &>/sdcard/ls.txt"
%myfiles%\adb pull /sdcard/ls.txt %cd%\ls.txt 1>nul
%myfiles%\adb shell rm -f /sdcard/ls.txt
@echo --------------------------------------------------
rem StartRusTextBlock
@echo Дерево каталогов создано, начинаем сканирование...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Directory tree created, starting scan...
rem EndEngTextBlock
>nul findstr /i /v /c:"Permission denied" < "ls.txt" > "lslist.txt"

@for /f %%d in (lslist.txt) do (
@set cat=%%d
@echo ------------------------------
rem StartRusTextBlock
@echo  Сканируем каталог: !cat!
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Scanning directory: !cat!
rem EndEngTextBlock
@echo. >> sizelist.txt
@echo ======================================>> sizelist.txt
rem StartRusTextBlock
@echo  Каталог: !cat! >> sizelist.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Directory: !cat! >> sizelist.txt
rem EndEngTextBlock
@echo ------------------------->> sizelist.txt
%myfiles%\adb shell "du -ham /!cat!/ &>/sdcard/dupd.txt"
::%myfiles%\adb shell "du -hacH &>/sdcard/dupd.txt"
%myfiles%\adb pull /sdcard/dupd.txt %cd%\dupd.txt 1>nul
%myfiles%\adb shell rm -f /sdcard/dupd.txt

>nul findstr /i /v /c:"Permission denied" < dupd.txt >> du0.txt

@for /f "usebackq delims=" %%i in (du0.txt) do (
	@set scat=%%i
	@if "!scat:~1,2!" NEQ "	/" @echo %%i >> sizelist.txt
)
@del %cd%\dupd.txt /q
@del %cd%\du0.txt /q
)
@del ls.txt /q
@del lslist.txt /q

cls
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     +++++ Сканирование каталогов завершено ++++
@echo.
@echo.
@echo.
@echo   Файл с результатами сохранен 
@echo   в текущем каталоге с именем sizelist.txt
@echo   и через несколько секунд будет открыт.
@echo   Напоминаю, число в начале каждой строки 
@echo   означает количество занятых мегабайт.
@echo.
@echo.  
@echo   Пример:
@echo.
@echo  ======================================
@echo   Каталог: product 
@echo  -------------------------
@echo  22	/product/priv-app/Settings/Settings.apk 
@echo  22	/product/priv-app/Settings 
@echo.
@echo.
@echo  В этом примере файл Settings.apk занимает 22 мегабайта.
@echo  Каталог /product/priv-app/Settings занимает столько же,
@echo  поскольку в нем только один этот файл.
@echo.
@echo.
@echo  Нажмите любую кнопку, чтобы открыть файл sizelist.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo +++++ Directory scanning completed ++++
rem @echo.
rem @echo.
rem @echo.
rem @echo   The file with the results is saved
rem @echo   in the current directory with the name sizelist.txt
rem @echo   and will be opened in a few seconds.
rem @echo   Reminder, the number at the beginning of each line
rem @echo   indicates the number of occupied megabytes.
rem @echo.
rem @echo.  
rem @echo   Example:
rem @echo.
rem @echo  ======================================
rem @echo   Directory: product 
rem @echo  -------------------------
rem @echo  22	/product/priv-app/Settings/Settings.apk 
rem @echo  22	/product/priv-app/Settings 
rem @echo.
rem @echo.
rem @echo  In this example, the Settings.apk file occupies 22 megabytes.
rem @echo  The /product/priv-app/Settings directory occupies the same amount
rem @echo  since there is only this file in it.
rem @echo.
rem @echo.
rem @echo  Press any key to open the sizelist.txt file
rem EndEngTextBlock
@pause >nul 
@echo.
@ping localhost -t 4 1>nul 2>nul
@start sizelist.txt
@goto _returnmenu

:_sizeinfo
call :_cdc
@SetLocal EnableDelayedExpansion
cls
call :_hat
@echo.
@echo.
@echo.
@echo.
@For /F "skip=1 tokens=2,3,4,5" %%a In ('%MYFILES%\adb shell df -h /sdcard/') Do (
@set aa=%%a
@set bb=%%b
@set cc=%%c
@set dd=%%d

rem StartRusTextBlock
@echo   Общий объем : !aa:~,-1! Гб
@echo   Занято      : !bb:~,-1! Гб
@echo   Свободно    : !cc:~,-1! Гб
@echo   Заполнено   : !dd!
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Total volume : !aa:~,-1! GB
rem @echo   Occupied     : !bb:~,-1! GB
rem @echo   Free         : !cc:~,-1! GB
rem @echo   Filled       : !dd!
rem EndEngTextBlock
)
@echo.
@echo.
@echo.
@goto _returnmenu

:_103info
:_449info
rem StartRusTextBlock
rem @echo ----------------------------------------------------------
@echo  Таблица разделов шлема и их размер в байтах и гигабайтах
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Table of partitions of the headset and their size in bytes and gigabytes
rem EndEngTextBlock
@echo ----------------------------------------------------------
%MYFILES%\adb shell df
@echo --------------------------------------------------------
%MYFILES%\adb shell df -h
@echo --------------------------------------------------------
rem  /sdcard/
@echo.
@echo.
@goto _returnmenu

:_USBConnectionsList
@%verbecho%
cls
call :_hat
SetLocal EnableDelayedExpansion
@echo.
rem StartRusTextBlock
@echo  Эта процедура извлечет из журнала событий Windows
@echo  и сохранит в файл дату и время всех USB подключений.
@echo  Так вы сможете узнать, действительно ли отключался кабель
@echo  во время игры или картинка зависала по другой причине.
@echo.
@echo  Файл будет лежать рядом с программой и называться dis-connected.txt
@echo.
@echo  Процедура НЕ работает под Windows 7.
@echo --------------------------------------------------------------
@echo.
@echo ^>^>^> Нажмите любую кнопку, чтобы начать извлечение ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  This procedure will extract from the Windows event log
rem @echo  and save to file the date and time of all USB connections.
rem @echo  So you can find out if the cable was actually disconnected
rem @echo  while playing or the picture was frozen for another reason.
rem @echo.
rem @echo  The file will be located next to the program and named dis-connected.txt
rem @echo.
rem @echo  The procedure does NOT work under Windows 7.
rem @echo --------------------------------------------------------------
rem @echo.
rem @echo ^>^>^> Press any key to start extraction ^<^<^<
rem EndEngTextBlock
@pause >nul 
@echo.
wevtutil qe Security "/q:*[System [(EventID=4798)]]" /rd:true /f:text >1.txt
>nul findstr /i /c:"Date:" < 1.txt >> dc.txt
(For /F "tokens=* usebackq delims=" %%a In ("dc.txt") Do (
	Set ta=%%a
	@echo !ta:~0,-9!
))>"dis-connected.txt"
del 1.txt /q /f
del dc.txt /q /f
@echo ==============================================
rem StartRusTextBlock
@echo Готово. Можете открыть файл. 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Ready. You can open the file.
rem EndEngTextBlock
@goto _returnmenu

:_iperftest
cls
rem call :_cdc
@%verbecho%
rem @call :_GetIP ipaddr
@call :_HeadsetIP
@call :_GetIP ipaddr
if not exist ipaddr.txt call :_CreateIPaddressTxt
call :_ExtractIPaddress
if [%ipaddrtxt%]==[] goto :_IPaddrEmpty

for /f "tokens=1,2 delims=." %%a in ("%ipaddrtxt%") do set "ippcshort=%%a.%%b")
for /f "tokens=1,2 delims=." %%a in ("%iphs%") do set "iphsshort=%%a.%%b"

if "%ippcshort%"=="%iphsshort%" (
rem @echo OK
set ipc=%_fCyan%

goto _iperftestmenu
) else (
rem StartRusTextBlock
set "ipaddressmsg=IP адрес компьютера в другой подсети. Тест невозможен."
rem EndRusTextBlock
rem StartEngTextBlock
rem set "ipaddressmsg=IP address is in a different subnet. Test impossible."
rem EndEngTextBlock
set ipc=%_fBRed%
)


:_iperftestmenu
@echo off
set iperfdir=
for /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v iPerfTempDir 2^>nul') do set "iperfdir=%%a"
if defined iperfdir (
set "iperfdirview=%iperfdir%"
) else (
if defined copytotemp (
set "iperfdirview=%SYSTEMDRIVE%\Temp"
) else (
set "iperfdirview=%MYFILES%"
)
)

call :_CheckAdminWiFiTest
cls
call :_hat
call :_hatmenu
@echo.
@echo.
@echo              %_fBYellow%=======  Wireless Connect Tester  =======%_fReset%
@echo.
@echo.
rem StartRusTextBlock
@echo    %_fBGreen%A.  Автотест скорости Wi-Fi со значениями по умолчанию%_fReset% [EXP]
@echo    S.  Стандартный тест скорости Wi-Fi с выбором значений [EXP]
@echo    T.  Проанализировать результаты тестирования  [EXP]
@echo    G.  Построить гистограмму или вычислить тренд по результатам тестов  [EXP]
@echo.
@echo    %_fBYellow%H.  Дополнительные пояснения по тестам, ошибкам, логам и т.д.%_fReset%
@echo    F.  Работа с файрволлом при ошибке Bad file descriptor
@echo    C.  Сервисная проверка соединения (не для тестирования^! см. пункт H)
@echo    I.  Запустить сервер iperf отдельным процессом
@echo    V.  Временно установить %SYSTEMDRIVE%\Temp каталогом запуска сервера iperf
@echo    W.  Записать каталог %SYSTEMDRIVE%\Temp в реестр и сделать его постоянным
@echo.
@echo.
@echo    IP адрес компьютера:	[ %ipc%%ipaddrtxt%%_fReset%	] %_bRed%%_fBWhite%%ipaddressmsg%%_fReset%
@echo    IP адрес гарнитуры:	[ %_fCyan%%iphs%%_fReset% 	]
@echo    Каталог iperf:	[ %_fCyan%%iperfdirview%%_fReset% 	]
@echo.
@echo    IP адрес компьютера определяется автоматически, проверьте его правильность. 
@echo    Если IP адрес не соответствует вашей сетевой карте, или он в другой подсети,
@echo    выйдите из программы и укажите его в файле %_fCyan%ipaddr.txt%_fReset%, только что созданном рядом с программой.
@echo.
@echo    %_fBYellow%Если вы поменяли роутер или IP на ПК, удалите этот файл, чтобы Quas определил новый IP адрес%_fReset%.
@echo.
@echo    Для теста требуется подключить кабель к ПК и шлему, а также включенный Режим разработчика.
@echo    Тестирование производится по сетевому протоколу TCP, ПК -- роутер -- шлем, поэтому:
@echo    %_fBYellow%НЕ НУЖНО СПЕЦИАЛЬНО ПЕРЕКЛЮЧАТЬ ШЛЕМ НА БЕСПРОВОДНОЕ СОЕДИНЕНИЕ. ПОДКЛЮЧИТЕ ШЛЕМ К ПК КАБЕЛЕМ%_fReset%.
@echo.
@echo    Для тестирования качества WiFi соединения между ПК и шлемом используйте пункты A или S.
@echo.
@echo    Каталог iperf отображает текущее местоположение сервера iperf, из которого он будет запущен.
@echo    %_fBYellow%Если тестирование не начинается или вылетат с ошибкой, попробуйте сменить каталог из пункта V%_fReset%.
@echo    Каталог запуска iperf %SYSTEMDRIVE%\Temp с помощью ключа реестра можно сделать постоянным по умолчанию,
@echo    и он не будет сбрасываться после выхода из программы. Это делается из Главного меню пункты F-H-D
@echo. %_fBRed%%adminmsg%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBGreen%A.  Auto Wi-Fi speed test with default values%_fReset% [EXP]
rem @echo    S.  Run Wi-Fi speed test  [EXP]
rem @echo    T.  Analyze test results  [EXP]
rem @echo    G.  Build a histogram or calculate the trend based on test results  [EXP]
rem @echo.
rem @echo    %_fBYellow%H.  Additional explanations about tests, errors, logs, etc.%_fReset%
rem @echo    F.  Firewall handling for Bad file descriptor error
rem @echo    C.  Service connection check
rem @echo    I.  Start the iperf server as a separate process
rem @echo    V.  Set %SYSTEMDRIVE%\Temp as the iperf server launch directory
rem @echo.
rem @echo.
rem @echo    Computer IP address:	[ %ipc%%ipaddrtxt%%_fReset% 	]  %_bRed%%_fBWhite%%ipaddressmsg%%_fReset%
rem @echo    Headset IP address:	[ %_fCyan%%iphs%%_fReset% 	]
rem @echo    iperf directory: 	[ %_fCyan%%iperfdirview%%_fReset% 	]
rem @echo.
rem @echo    The computer IP address is determined automatically, please check its correctness.
rem @echo    If the IP address does not match your network card, exit the program
rem @echo    and specify it in the ipaddr.txt%_fReset% file, which was just created next to the program.
rem @echo.
rem @echo    %_fBYellow%If you have changed your router or the PC IP address, 
rem @echo    delete this file so that Quas can detect the new IP address%_fReset%.
rem @echo.
rem @echo    For the test, a USB cable connected to the PC and the headset is required, as well as the
rem @echo    Developer Mode turned on. The testing is conducted via TCP protocol, PC - router - headset, so:
rem @echo    %_fBYellow%DON'T SWITCH HEADSET TO WIRELESS CONNECTION. CONNECT HEADSET TO PC WITH A CABLE.%_fReset%.
rem @echo.
rem @echo    iperf directory displays current location of the iperf server from which it will be launched.
rem @echo    %_fBYellow%If testing does not start or crashes with an error, try changing the directory using option V.%_fReset%.
rem @echo    The iperf launch directory %SYSTEMDRIVE%\Temp can be set as the default permanent directory using a registry
rem @echo    key, and it will not reset after exiting the program. From the Main Menu, go to options F-H-D
rem EndEngTextBlock
@echo  ---------
set tabanalize=
call :_MenuChoiceEnter
@echo.
if not defined choice goto _iperftest
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _SetIperfAutoTesParameters)
if /i "%choice%"=="s" (GOTO _iperftestrun)
if /i "%choice%"=="t" (GOTO _WiFiTestCSVAnalyzer)
if /i "%choice%"=="g" (GOTO _BuildHistogramMenu)
if /i "%choice%"=="c" (GOTO _SetIperfAutoTesParametersTest)
if /i "%choice%"=="cc" (set tabanalize=1&&GOTO _SetIperfAutoTesParametersTest)
if /i "%choice%"=="i" (GOTO _StartIperfServerStandalone)
if /i "%choice%"=="h" (call :_GeneralWFTestHelp)
if /i "%choice%"=="f" (call :_FirewallPortSetting)
if /i "%choice%"=="d" (call :_DebugWiFiTestConnection)
if /i "%choice%"=="v" (call :_SwithIperfToTempMessage)
if /i "%choice%"=="w" (goto :_setiperfdirkeywftest)
if /i "%choice%"=="p" (GOTO _IperfLogsParsing)


cls
goto _iperftest

:_setiperfdirkeywftest
reg add "HKEY_CURRENT_USER\Software\Quas" /v iPerfTempDir /t REG_SZ /d "%SYSTEMDRIVE%\Temp" /f 1>nul 2>nul
@echo -----------------------------------------------------
rem StartRusTextBlock
@echo Ключ "iPerf Temp Dir" записан в реестр.
@echo Теперь iPerf будет запускаться только из каталога %SYSTEMDRIVE%\Temp
@echo Для удаления ключа из реестра используйте пункты F-H-J из Главного меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The "iPerf Temp Dir" key is written to the registry
rem @echo Now iPerf will run only from the %SYSTEMDRIVE%\Temp directory
rem @echo To remove the registry key, use options F–H–J from the Main Menu
rem EndEngTextBlock
call :_prevmenu
goto _iperftest


:_CheckAdminWiFiTest
rem >nul fsutil && echo есть || echo нет
rem >nul fsutil && (set "adminmsg=") || (set "adminmsg=    Программа запущена от имени пользователя. Проверьте настройки файрволла.")
rem StartRusTextBlock
@reg query "HKU\S-1-5-19" >NUL 2>&1 && (set "adminmsg=") || (set "adminmsg=    Программа запущена от имени пользователя. Вы не сможете настроить файволл.")
rem EndRusTextBlock
rem StartEngTextBlock
rem @reg query "HKU\S-1-5-19" >NUL 2>&1 && (set "adminmsg=") || (set "adminmsg=    The program is running as a user. You will not be able to configure the firewall.")
rem EndEngTextBlock
exit /b

:_GeneralWFTestHelp
cls
@echo.      
@echo.
rem StartRusTextBlock
@echo         ОБЩИЕ ПОЯСНЕНИЯ      
@echo.      
@echo   Опция Автотест (пункт A) предназначена для упрощенного запуска тестирования скорости и просадок.
@echo   Будет запущен тест с автоматически подставленными значениями по умолчанию, а по завершении теста
@echo   проанализированы результаты.
@echo.
@echo   Стандартный тест (пункт S) дает возможность ввести желаемые параметры или можно просто
@echo   жать Enter, для ввода значений по умолчанию:
@echo.      
@echo     - Интервал между проверками в миллисекундах, от 100 до 1000:	(по умолчанию - 100)
@echo     - Количество потоков, от 1 до 10: 					(по умолчанию - 1)
@echo     - Длительность каждого теста в секундах, от 1 до 3600: 		(по умолчанию - 180)
@echo.      
@echo   Чтобы прервать ввод данных и вернуться в меню, вместо значений введите 0
@echo.
@echo   Для выявления просадок и потерь пакетов, рекемендуется интервал проверок оставить по умолчанию.
@echo   Запустится сервер на ПК и клиент в шлеме,по завершении тестов окно сервера закроется.
@echo.      
@echo   Будет проведено два теста, Реверсивный: от ПК к шлему, и прямой: от шлема к ПК. После тестов
@echo   рядом с программой появятся лог-файлы WiFiConnectTestReverse и WiFiConnectTestDirect. В них 
@echo   записаны результаты тестов. В файлах *.csv содержатся данные для анализа результатов.
@echo.
@echo   Если программа не работает или вылетает, смотрите текст ошибки в файле errorcl.txt. При ошибке
@echo   Bad file descriptor отключите файрволл на ПК или воспользуйтесь меню по работе с файрволлом. 
@echo   Если ошибка повторяется, попробуйте изменить значение длительности проверки.
@echo   Ошибка unable to send control message: Broken pipe означает прерванное соединение.
@echo.
@echo   Опция "Установить %SYSTEMDRIVE%\Temp каталогом запуска сервера iperf" предназначена тогда, когда сервер
@echo   iperf стартует, но соединение не устанавливается из-за отсутствия необходимых прав доступа. 
@echo   В этом случае можно попробовать установить %SYSTEMDRIVE%\Temp каталогом запуска сервера iperf (пункт V).
@echo   После этого cервер будет запускаться не из временного каталога пользователя, как обычно,
@echo   а из %SYSTEMDRIVE%\Temp. По завершении можете удалить файлы iperf3.exe и cygwin1.dll из этого каталога.
@echo.
@echo   "Сервисная проверка соединения" предназначена ТОЛЬКО ДЛЯ ПРОВЕРКИ ПОДКЛЮЧЕНИЯ в служебных целях.
@echo   Длительность проверок 10 секунд с интервалом 1 секунда. НЕ ИСПОЛЬЗУЙТЕ ЕЕ ДЛЯ ТЕСТИРОВАНИЯ^!
@echo. 
@echo   Опция "Запустить сервер iperf отдельным процессом" запускает сервер iperf в отдельном окне
@echo   в режиме ожидания подключения клиента.
@echo.    
@echo   После каждого теста рядом с программой сохраняется скриншот с результатами тестирования.
@echo   Картинка создается для активного окна, так что не переключайтесь на другие окна во время теста.
@echo   Перед новым тестом предыдущие результаты вместе с картинкой будут  перенесены в каталог 
@echo   OldWiFiTestFiles и запакованы в архив с датой и временем тестирования в имени архива.
@echo.
@echo   После тестирования можно в любой момент проанализировать результаты с помощью пункта T в меню.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         GENERAL EXPLANATIONS      
rem @echo.      
rem @echo   The Auto Test option (option A) will automatically use default values, start the test,
rem @echo   analyze the results after the test, and display them.
rem @echo.
rem @echo   The Standard Test (option S) allows you to enter desired parameters, or you can simply
rem @echo   press Enter to use the default values:
rem @echo.      
rem @echo     - Interval between checks in milliseconds, from 100 to 1000: (default - 100)
rem @echo     - Number of threads, from 1 to 10:                           (default - 1)
rem @echo     - Duration of each test in seconds, from 1 to 3600:          (default - 180)
rem @echo.      
rem @echo   To cancel input and return to the menu, enter 0 instead of values.
rem @echo.
rem @echo   To detect drops and packet loss, it is recommended to keep the check interval at default.
rem @echo   A server will start on the PC and a client in the headset. Once tests are completed,
rem @echo   the server window will close.
rem @echo.      
rem @echo   Two tests will be conducted: Reverse (PC to headset) and Direct (headset to PC). After the tests,
rem @echo   log files WiFiConnectTestReverse and WiFiConnectTestDirect will appear next to the program.
rem @echo   These files contain test results. CSV files contain data for analysis.
rem @echo.
rem @echo   If the program does not work or crashes, check the error message in the file errorcl.txt.
rem @echo   If you encounter a "Bad file descriptor" error, disable the firewall on your PC or use
rem @echo   the firewall management menu. If the error persists, try changing the test duration value.
rem @echo   The "unable to send control message: Broken pipe" error indicates a disconnected connection.
rem @echo.
rem @echo   The option "Set %SYSTEMDRIVE%\Temp as the iperf server launch directory" is for cases where
rem @echo   the iperf server starts, but the connection fails due to insufficient access rights. 
rem @echo   In this case, you can try setting %SYSTEMDRIVE%\Temp as the iperf server directory (option V).
rem @echo   This will make the server launch from %SYSTEMDRIVE%\Temp instead of the user's temporary folder.
rem @echo   Once testing is done, you can delete the files iperf3.exe and cygwin1.dll from this directory.
rem @echo.
rem @echo   The "Service connection check" option is designed for a quick validation of connectivity
rem @echo   for service purposes. The total test duration is 10 seconds, with a 1-second check interval.
rem @echo. 
rem @echo   The "Start iperf server as a separate process" option launches the iperf server
rem @echo   in a separate window in standby mode for client connection.
rem @echo.    
rem @echo   After each test, a screenshot of the test results is saved next to the program.
rem @echo   The screenshot is created for the active window, so avoid switching to other windows during test.
rem @echo   Before a new test, previous test results along with the screenshot will be moved to the 
rem @echo   OldWiFiTestFiles folder and archived with the test date and time in the archive name.
rem @echo.
rem @echo   After testing, you can analyze the results at any time using option T in the menu.
rem EndEngTextBlock
call :_exitwindow
@echo  ---------------------- 
@echo.
exit /b


:_BuildHistogramMenu
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    R.  Гистограмма результатов реверсивной проверки (консольная)
@echo    D.  Гистограмма результатов прямой проверки (консольная)
@echo    E.  Графическая диаграмма результатов прямой реверсивной проверки с "гребенкой"
@echo    F.  Графическая диаграмма результатов прямой реверсивной проверки без "гребенки"
@echo    T.  Расчет тренда по результатам реверсивной проверки
@echo    S.  Расчет тренда по результатам прямой проверки
@echo    G.  Как построить диаграмму в Таблицах Google (инструкция)
@echo.
@echo.
@echo.
@echo.
@echo     ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo   Гистограмма предназначена для визуализации уровней просадок на протяжении всего тестирования.
@echo   Она строится вертикально, т.к. заранее неизвестна продолжительность проверки, а значит 
@echo   и количество строк с битрейтом.
@echo   Не стоит ожидать от нее красивой картинки, но детальное представление о просадках она дает.
@echo.
@echo   В первой колонке значение битрейта, во второй - уровень битрейта по отношению к максимальному.  
@echo.
@echo   Построение осуществляется на основе файлов csv с результатами. 
@echo   Файлы csv должны содержать в названии слова reverse или direct и их должно быть по одному,
@echo   иначе гистограмма будет построена по самому последнему по времени файлу csv.
@echo.
@echo   Гистограмма создается в отдельном окне, но если в исходном файле csv больше двух тысяч строк,
@echo   она сохраняется в текстовый файл histogram-имя-исходного-файла.csv.txt и показана не будет.
@echo   Ее создание займет некоторое время, зависящее от продолжительности тестов.
@echo   ---
@echo   Тренд — устойчивое направление изменений, которое проявляется в определённый период времени. 
@echo   В данном случае тренд вычисляется методом меньших квадратов и линейной аппроксимации результатов.
@echo.
@echo   Иными словами, анализируются все результаты тестов и определяется тенденция
@echo   к росту или падению битрейта на протяжении теста.
@echo   Вероятно это полная ерунда, но,таким образом есть шанс определить уменьшение 
@echo   пропускной способности роутера, к примеру, если он перегревается.
@echo.
@echo   Результатом расчетов будет число, показывающее Рост (Growth) или Падение (Decline) общей
@echo   тенденции.
@echo   Единица измерения числа - "units per step", "единица на шаг", то есть рост или уменьшение
@echo   на каждый шаг теста. За остальными подробностями добро пожаловать в Google.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    R.  Histogram of reverse test results
rem @echo    D.  Histogram of direct test results
rem @echo    E.  Graphical chart of direct reverse check results with "comb"
rem @echo    F.  Graphical chart of direct reverse check results without "comb"
rem @echo    T.  Trend calculation based on reverse test results
rem @echo    S.  Trend calculation based on direct test results
rem @echo    G.  How to Create a Chart in Google Sheets (Instructions)
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo     PLEASE NOTE:
rem @echo.
rem @echo   The histogram is designed to visualize the drop levels throughout the entire test.
rem @echo   It is built vertically, as the test duration is unknown in advance, and thus the number of rows
rem @echo   with bitrate cannot be determined. 
rem @echo   Do not expect a beautiful picture, but it provides a detailed representation of dropouts.
rem @echo.
rem @echo   The first column shows the bitrate value, 
rem @echo   the second column shows the bitrate level relative to the maximum.
rem @echo.
rem @echo   The construction is based on csv result files.
rem @echo   The csv files must contain the words reverse or direct in their names, and there should be 
rem @echo   only one file of each type. Otherwise, the histogram will be built from the latest file by time.
rem @echo.
rem @echo   The histogram will be created in a separate window.
rem @echo   Its creation will take some time, depending on the test duration.
rem @echo   ---
rem @echo   Trend — a stable direction of changes observed over a certain period of time.
rem @echo   In this case, the trend is calculated using the least squares method 
rem @echo   and linear approximation of the results.
rem @echo.
rem @echo   In other words, all test results are analyzed, and a tendency towards 
rem @echo   bitrate growth or decline is determined depending on the test duration.
rem @echo   This might be complete nonsense, but it can help detect bandwidth reduction
rem @echo   in a router if it overheats, for example.
rem @echo.
rem @echo   The calculation result will be a number indicating the overall trend as
rem @echo   Growth or Decline.
rem @echo   The unit of measurement is "units per step," meaning the increase or decrease 
rem @echo   per test step. For further details, feel free to search on Google.
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _BuildHistogramMenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="r" (set vector=reverse&&set "VectorMessage=Histogram of Reverse Test Results [From PC to Headset]"&&GOTO _BuildHistogramAction)
if /i "%choice%"=="d" (set vector=direct&&set "VectorMessage=Histogram of Direct Test Results [From Headset to PC]"&&GOTO _BuildHistogramAction)
if /i "%choice%"=="e" (goto _BuildDiagramActionG)
if /i "%choice%"=="f" (goto _BuildDiagramAction)
if /i "%choice%"=="t" (set vector=reverse&&set "VectorMessage=Trend of Reverse Test Results [From PC to Headset]"&&GOTO _TrendAction)
if /i "%choice%"=="s" (set vector=direct&&set "VectorMessage=Trend of Direct Test Results [From Headset to PC]"&&GOTO _TrendAction)
if /i "%choice%"=="g" goto _GoogleHistoManual

cls
goto _BuildHistogramMenu


:_TrendAction
setlocal enableextensions enabledelayedexpansion
if not exist *.csv goto _notestcsvfiles
rem for /r "%cd%" %%i in (*.csv) do (
rem set csvfile=%%i
for /f "delims=" %%a in ('dir /b /a-d *%vector%*.csv') do (
set csvfile=%%a
)
if "!csvfile!"==""  goto _notestcsvfiles
set "datafile=!csvfile!"
call :_BuildTrendPS
@echo   ----------------------------------
rem StartRusTextBlock
@echo   Результаты вычислений тренда открыты в отдельном окне.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   The trend calculation results are displayed in a separate window.
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _iperftestmenu


:_BuildTrendPS
@chcp 1251 >nul
start " " cmd /c "powershell.exe -ExecutionPolicy ByPass -NoProfile -File "%myfiles%\trend.ps1" -DataFile "%datafile%" -VectorMessage "%VectorMessage%""
@chcp 65001 >nul
exit /b


:_BuildHistogramAction
setlocal enableextensions enabledelayedexpansion
if not exist *.csv goto _notestcsvfiles
rem for /r "%cd%" %%i in (*.csv) do (
rem set csvfile=%%i
for /f "delims=" %%a in ('dir /b /a-d *%vector%*.csv') do (
set csvfile=%%a
)
if "!csvfile!"==""  goto _notestcsvfiles

set "datafile=!csvfile!"
set "ExternalFile=histogram-!csvfile!.txt"


call :_BuildHistogramPS
@echo   ----------------------------------
rem StartRusTextBlock
@echo   Гистограмма построена.
@echo.
@echo   Скроллируйте ее колесом мыши для просмотра просадок.
@echo   Для закрытия гистограммы нажмите любую кнопку в ее окне. 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   The histogram has been built.
rem @echo.
rem @echo   Scroll through it using the mouse wheel to view the drops.
rem @echo   To close the histogram, press any key in its window.
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _iperftestmenu


:_BuildDiagramActionG
set "grebenka=-p"

:_BuildDiagramAction
setlocal enableextensions enabledelayedexpansion
if not exist *.csv goto _notestcsvfiles

rem Reverse
set vector=reverse
set "VectorMessage=Reverse Test Results [From PC to Headset]"
for /f "delims=" %%a in ('dir /b /a-d *%vector%*.csv') do (
set csvfile=%%a
)
if not defined csvfile goto _notestcsvfiles
set "datafile=!csvfile!"
start " " powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%myfiles%\diagram.ps1" -csv "%datafile%" -title "%VectorMessage%" %grebenka%

rem Direct
set vector=direct
set "VectorMessage=Direct Test Results [From Headset to PC]"

set "offsetwindow=-offsetX 500 -offsetY 300"
for /f "delims=" %%a in ('dir /b /a-d *%vector%*.csv') do (
set csvfile=%%a
)
if not defined csvfile goto _notestcsvfiles
rem if "!csvfile!"==""  goto _notestcsvfiles
set "datafile=!csvfile!"
start " " powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%myfiles%\diagram.ps1" -csv "%datafile%" -title "%VectorMessage%" %grebenka% %offsetwindow%
call :_prevmenu
goto _iperftestmenu


:_GoogleHistoManual
cls
@echo.
@echo.
rem StartRusTextBlock
@echo   Как построить диаграмму в Таблицах Google
@echo.
@echo     - Идем по ссылке https://docs.google.com/spreadsheets (требуется регистрация)
@echo     - Или просто из аккаунта открываем Таблицы Google - жмем Пустая таблица.
@echo     - В меню выбрать Файл - Открыть - Загрузка.
@echo     - Перетащить мышью на окно любой из csv файлов с результатами тестов.
@echo     - После загрузки файла нажать Ctrl+A (выделится все) - в меню выбрать Вставить - Диаграмма.
@echo     - Справа в поле Тип диаграммы выбрать - Столбчатая диаграмма.
@echo     - Растянуть диаграмму до желаемой ширины.
@echo.
@echo    Уровень вашего битрейта будет показан по оси Y.
@echo    Можете выбрать любой тип диаграммы, который будет для вас наглядней.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   How to Create a Chart in Google Sheets
rem @echo.
rem @echo     - Go to https://docs.google.com/spreadsheets (registration required)
rem @echo     - Or simply open Google Sheets from your account and click on Blank Spreadsheet.
rem @echo     - In the menu, select File - Open - Upload.
rem @echo     - Drag and drop any of the CSV files with test results into the window.
rem @echo     - After the file is uploaded, press Ctrl+A (this will select the entire table) - then in the menu, choose Insert - Chart.
rem @echo     - On the right, in the Chart Type field, select Bar Chart.
rem @echo     - Resize the chart to the desired width.
rem @echo.
rem @echo    Your bitrate level will be displayed on the Y-axis.
rem @echo    You can choose any chart type that provides the best visualization for you.
rem EndEngTextBlock
@echo.
call :_exitwindow
@echo  ---------------------- 
@echo.
goto _BuildHistogramMenu


:_BuildHistogramPS
@chcp 1251 >nul
rem start " " cmd /c "powershell.exe -ExecutionPolicy ByPass -NoProfile -File "%myfiles%\histogram.ps1" -DataFile "%datafile%" -VectorMessage "%VectorMessage%""
start " " cmd /c "powershell.exe -ExecutionPolicy ByPass -NoProfile -File "%myfiles%\histogram.ps1" -DataFile "%datafile%" -VectorMessage "%VectorMessage%" -ExternalFile "%ExternalFile%""
@chcp 65001 >nul
exit /b


:_StartIperfServerStandalone
if "%copytotemp%"=="1" (set "iperfdir=%SYSTEMDRIVE%\Temp"&&call :_CopyingIperfToTempS) else (set iperfdir=%MYFILES%)
start cmd /c "mode con:cols=80 lines=50 &%iperfdir%\iperf3.exe -s"
@echo   --------------------------------------------------------------
rem StartRusTextBlock
@echo   = Сервер iperf запущен.
@echo     По завершении просто закройте его окно.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = The iperf server is running.
rem @echo     Once finished, simply close its window.
rem EndEngTextBlock
call :_prevmenu
goto _iperftestmenu


:_FirewallPortSetting
call :_hat
call :_hatmenu
@echo.
@echo.
rem StartRusTextBlock
@echo    A.  Отключить файрволл
@echo    B.  Включить файрволл
@echo    C.  Открыть в файрволле порт 5201 (добавить правило)
@echo    D.  Закрыть в файрволле порт 5201 (удалить правило) 
@echo    E.  Проверить порт 5201 (только Windows 10 и выше)
@echo.
@echo    W.  Вернуться к меню тестирования
@echo.
@echo.
@echo.
@echo.
@echo     ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo     Для работы теста Wi-Fi на этом ПК требуется открытый порт 5201,
@echo     по нему сервер iperf слушает клиентскую часть iperf на шлеме.   
@echo.    Вы можете выбрать - отключить файрволл совсем (и затем включить обратно)
@echo     или добавить правило, которое откроет порт 5201 на вашем ПК.
@echo     После тестиррования это правило можно будет удалить или оставить, для следующих тестов.
@echo     Правило будет называться "iperf Test Port 5201"
@echo.
@echo     %_fBRed%Для включения и отключения файрволла, а также для добавления или удаления правила
@echo     программа Quas должна быть запущена с правами администратора%_fReset%.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Disable firewall
rem @echo    B.  Enable firewall
rem @echo    C.  Open port 5201 in the firewall (add rule)
rem @echo    D.  Close port 5201 in the firewall (remove rule)
rem @echo    E.  Check port 5201 (only Windows 10 and above)
rem @echo.
rem @echo    W.  Return to testing menu
rem @echo.
rem @echo.
rem @echo.
rem @echo.
rem @echo     NOTE:
rem @echo.
rem @echo     For the Wi-Fi test to work on this PC, port 5201 must be open,
rem @echo     as the iperf server listens for the iperf client on the headset.
rem @echo.    You can choose to either disable the firewall completely (and enable it later)
rem @echo     or add a rule to open port 5201 on your PC.
rem @echo     After testing, this rule can be deleted or kept for future tests.
rem @echo     The rule will be named "iperf Test Port 5201".
rem @echo.
rem @echo     IMPORTANT: To enable or disable the firewall, or to add or remove a rule,
rem @echo                the Quas program must be run with administrator privileges.
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _FirewallPortSetting
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="w" (GOTO _iperftest)
if /i "%choice%"=="a" (GOTO _DisableFirewall)
if /i "%choice%"=="b" (GOTO _EnableFirewall)
if /i "%choice%"=="c" (GOTO _AddRuleOpenPort5201)
if /i "%choice%"=="d" (GOTO _DelRuleOpenPort5201)
if /i "%choice%"=="e" (GOTO _CheckPort5201)
cls
goto _FirewallPortSetting

:_CheckPort5201
call :_CheckAdminRights
if defined adminmsg  echo %adminmsg% && call :_prevmenu && goto _FirewallPortSetting
@echo   =======================================
SetLocal EnableExtensions  enabledelayedexpansion
@echo   = Check port status....
@echo.

start cmd /c "mode con:cols=50 lines=30 &%MYFILES%\iperf3.exe -s"
@ping localhost -n 2 1>nul 2>nul

set "ps=" & for %%X in (powerShell.exe) do set "ps=%%~$PATH:X"
@if not defined ps set "ps=%systemRoot%\system32\windowsPowerShell\v1.0\powerShell.exe"

@For /F "UseBackQ delims=" %%a in (`"cmd /c "
  "%ps%" -ExecutionPolicy ByPass -NoProfile -command "TNC localhost -Port 5201 -InformationLevel Quiet" ^| findstr /i "true"
""`) do (
set portstatusvar=%%a
)
@taskkill /F /IM iperf3.exe 1>nul 2>nul
@echo   =======================================
if "%portstatusvar%"=="False" set portstatus=Closed&&@echo   = Port status	: !portstatus!
if "%portstatusvar%"=="True" set portstatus=Opened&&@echo   = Port status	: !portstatus!
@echo   ---------------------------------------
@echo   = Check completed
@echo   =======================================
@echo.
@echo    +++ Press any key to return prev menu +++
pause >nul
goto _FirewallPortSetting



:_DisableFirewall
call :_CheckAdminRights
if defined adminmsg  echo %adminmsg% && call :_prevmenu && goto _FirewallPortSetting
@NetSh Advfirewall set allprofiles state off 1>nul 2>nul
@echo.
@echo   ---------------
rem StartRusTextBlock
@echo   = Файрволл отключен
@echo.
@echo ^>^>^> Нажмите любую кнопку для возврата в меню тестирования ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Firewall is disabled
rem @echo.
rem @echo ^>^>^> Press any key to return to the testing menu ^<^<^<
rem EndEngTextBlock
@pause >nul

GOTO _iperftest

:_EnableFirewall
call :_CheckAdminRights
if defined adminmsg  echo %adminmsg% && call :_prevmenu && goto _FirewallPortSetting
@NetSh Advfirewall set allprofiles state on 1>nul 2>nul
@echo.
@echo   ---------------
rem StartRusTextBlock
@echo   = Файрволл включен
@echo.
@echo ^>^>^> Нажмите любую кнопку для возврата в меню тестирования ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Firewall is disabled
rem @echo.
rem @echo ^>^>^> Press any key to return to the testing menu ^<^<^<
rem EndEngTextBlock
@pause >nul

GOTO _iperftest

:_AddRuleOpenPort5201
call :_CheckAdminRights
if defined adminmsg  echo %adminmsg% && call :_prevmenu && goto _FirewallPortSetting
@netsh advfirewall firewall add rule name= "iperf Test Port 5201" dir=in action=allow protocol=TCP localport=5201 1>nul 2>nul
@echo.
@echo   ---------------
rem StartRusTextBlock
@echo   = Правило добавлено
@echo.
@echo ^>^>^> Нажмите любую кнопку для возврата в меню тестирования ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Rule added
rem @echo.
rem @echo ^>^>^> Press any key to return to the testing menu ^<^<^<
rem EndEngTextBlock
@pause >nul
GOTO _iperftest

:_DelRuleOpenPort5201
call :_CheckAdminRights
if defined adminmsg  echo %adminmsg% && call :_prevmenu && goto _FirewallPortSetting
@netsh advfirewall firewall delete rule name="iperf Test Port 5201" protocol=TCP localport=5201 1>nul 2>nul
@echo.
@echo   ---------------
rem StartRusTextBlock
@echo   = Правило удалено
@echo.
@echo ^>^>^> Нажмите любую кнопку для возврата в меню тестирования ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Rule deleted
rem @echo.
rem @echo ^>^>^> Press any key to return to the testing menu ^<^<^<
rem EndEngTextBlock
@pause >nul
GOTO _iperftest

:_iperftestrun
call :_cdc
@echo off & setlocal ENABLEEXTENSIONS
@call :_GetIP ipaddr
if not exist ipaddr.txt call :_CreateIPaddressTxt
call :_ExtractIPaddress
set iinterval=
call :_SetIperTestInterval
call :_IperfTestProcedure
call :_WiFiTestCSVAnalyzer
goto _iperftest


:_SetIperTestInterval
rem StartRusTextBlock
@set /p iinterval="Введите интервал в миллисекундах и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p iinterval="Enter the interval in milliseconds and press Enter (0 - Exit) : "
rem EndEngTextBlock
if [%iinterval%]==[] set iinterval=100
if %iinterval%==0 goto _iperftest
if %iinterval% LSS 100 goto _lssinterval
set ointerval=%iinterval%
call :_Division
@echo %ointerval%
@echo.
@set qstreams=
rem StartRusTextBlock
@set /p qstreams="Введите количество потоков и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p qstreams="Enter the number of streams and press Enter (0 - Exit) : "
rem EndEngTextBlock
if [%qstreams%]==[] set qstreams=1
if %qstreams%==0 goto _iperftest
@echo %qstreams%
@echo.
set itime=
rem StartRusTextBlock
@set /p itime="Введите длительность проверки в секундах и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p itime="Enter the duration of the check in seconds and press Enter (0 - Exit) : "
rem EndEngTextBlock
if [%itime%]==[] set itime=180
if %itime%==0 goto _iperftest
@echo %itime%
@echo.

rem set bndwidth=
rem set width=
rem rem StartRusTextBlock
rem @set /p width="Введите величину ограничения битрейта в мегабитах и нажмите Enter (0 - без ограничений) : "
rem rem EndRusTextBlock
rem rem StartEngTextBlock
rem rem @set /p width="Enter the bandwidth limit and press Enter (0 - no limit) : "
rem rem EndEngTextBlock
rem set /a bndwidth=%width%*1000000
rem if [%bndwidth%]==[] set bndwidth=0
rem if %bndwidth%==0 goto _iperftest
rem @echo %bndwidth%
rem @echo.
exit /b


:_SwithIperfToTempMessage
set "iperfdirview=%SYSTEMDRIVE%\Temp"
set copytotemp=1
@echo.
@echo =================================================================================================
rem StartRusTextBlock
@echo   Изменен каталог запуска iperf, теперь он будет стартовать из каталога %SYSTEMDRIVE%\Temp
@echo   Параметры будут сохранены до выхода из программы, тесты запускаются как обычно.
@echo   После тестирования можно удалить два файла из каталога %SYSTEMDRIVE%\Temp: iperf3.exe и cygwin1.dll
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   The iperf launch directory has been changed, it will now start from %SYSTEMDRIVE%\Temp
rem @echo   The parameters will be saved until you exit the program, tests will run as usual.
rem @echo   After testing, you can delete two files from the %SYSTEMDRIVE%\Temp directory: iperf3.exe and cygwin1.dll
rem EndEngTextBlock
call :_prevmenu
goto _iperftestmenu

:_CopyingIperfToTemp
@echo.
set "iperfdir=%SYSTEMDRIVE%\Temp"
set /p iperfdir="Enter directory for iperf server (Press Enter for %SYSTEMDRIVE%\Temp) : "

:_CopyingIperfToTempS
rem rd %iperfdir% /S /Q 1>nul 2>nul
md %iperfdir% 1>nul 2>nul
@xcopy %MYFILES%\iperf3.exe %iperfdir%\*.* /Y /R 1>nul 2>nul
@xcopy %MYFILES%\cygwin1.dll %iperfdir%\*.* /Y /R 1>nul 2>nul
exit /b

:_DebugWiFiTestConnection
@echo   = pushing iperf to headset
%MYFILES%\adb push %MYFILES%\iperf3.18 /data/local/tmp 1>debuglogwf.txt 2>clientpushlog.txt
@echo   = iperf chmod 
%MYFILES%\adb shell chmod +x /data/local/tmp/iperf3.18 1>>debuglogwf.txt 2>clientchlog.txt
@echo   = copying iperf files to start directory
call :_CopyingIperfToTemp
@echo   = start server iperf

start cmd /c "mode con:cols=80 lines=50 &%iperfdir%\iperf3.exe -s"
rem start cmd /c "mode con:cols=80 lines=50 &%MYFILES%\iperf3.exe -s"

@ping localhost -n 5 1>nul 2>nul
@echo   = start client iperf
rem @echo.
set itime=5
set iinterval=1
set bndwidth=0
rem set ipaddrtxt=10.0.0.30
set qstreams=1

%MYFILES%\adb shell /data/local/tmp/iperf3.18 -t %itime% -i %iinterval% -b %bndwidth% -c %ipaddrtxt% -P %qstreams% -f m 2>errorst.txt 1>clientprclog.txt

rem %MYFILES%\adb shell /data/local/tmp/iperf3.18 -t 10 -i 1 -b 0 -c %ipaddrtxt% -P 1 -R -f m 1>clientprclog.txt 2>clientstlog.txt
@ping localhost -n 2 1>nul 2>nul
@taskkill /F /IM iperf3.exe 1>nul 2>nul
@ping localhost -n 2 1>nul 2>nul
rem rd %iperfdir% /S /Q 1>nul 2>nul
@echo   ---
@echo   = check finished. Read all logs near program
@echo.
@echo   ---
@echo   Press any key to return menu
pause >nul
exit /b

:_IperfTestProcedure

rem for /f "delims=" %%a in ('dir /b /a-d *%vector%*.csv') do (
rem set csvfile=%%a
rem )

call :_settime
rem @if exist %~dp0WiFiConnectTestReverse*.* call :_BackupPrevWiFiTestFiles
@if exist %cd%\WiFiConnectTestReverse*.* call :_BackupPrevWiFiTestFiles

setlocal enableextensions enabledelayedexpansion
rem for /f "delims=" %%a in ('dir /b /a-d %cd%\*.csv 2^>nul 1^>nul') do (

for /f "delims=" %%a in ('dir /b /a-d %cd%\*.csv 2^>nul') do (
set csvfileforren=%%a
ren !csvfileforren! !csvfileforren!.old 1>nul 2>nul
)
endlocal

rem @if exist bitrate*.csv @md OldWiFiTestFiles 1>nul 2>nul &%myfiles%\7z.exe a -mx7 -t7z WiFiTests-%dt%.7z bitrate*.csv 1>nul 2>nul
rem @if exist WiFiConnectTest*.* @md OldWiFiTestFiles 1>nul 2>nul &%myfiles%\7z.exe a -mx7 -t7z WiFiTests-%dt%.7z WiFiConnectTest*.* 1>nul 2>nul
rem @if exist WiFiTestRezult*.* @md OldWiFiTestFiles 1>nul 2>nul &%myfiles%\7z.exe a -mx7 -t7z WiFiTests-%dt%.7z WiFiTestRezult*.* 1>nul 2>nul
rem @move WiFiTests-%dt%.7z %~dp0OldWiFiTestFiles\ 1>nul 2>nul
rem @del bitrate*.csv /Q /F 1>nul 2>nul
rem @del WiFiConnectTest*.* /Q /F 1>nul 2>nul
rem @del WiFiTestRezult*.* /Q /F 1>nul 2>nul

rem @if exist bitrate*.csv @md OldWiFiTestFiles 1>nul 2>nul &@move bitrate*.* %~dp0\OldWiFiTestFiles\ 1>nul 2>nul
rem @if exist WiFiConnectTest*.* @md OldWiFiTestFiles 1>nul 2>nul &@move WiFiConnectTest*.* %~dp0\OldWiFiTestFiles\ 1>nul 2>nul
rem @if exist WiFiTestRezult*.* @md OldWiFiTestFiles 1>nul 2>nul &@move WiFiTestRezult*.* %~dp0\OldWiFiTestFiles\ 1>nul 2>nul
set wfclogd=WiFiConnectTestDirect
set wfclogdt=%wfclogd%-%dt%.txt
@echo ------------------------------------------------------
rem StartRusTextBlock
@echo В окне сервера можно наблюдать процесс тестирования.
@echo По завершению тестов окно сервера будет закрыто
@echo.
@echo  Результаты теста будут сохраненые в файлы:
@echo    WiFiConnectTestDirect-%dt%.txt
@echo    WiFiConnectTestReverse-%dt%.txt
@echo.
@echo  Анализ результатов производится на основе файлов:
@echo    bitrate-direct-%dt%.csv
@echo    bitrate-reverse-%dt%.csv
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo In the server window, you can observe the testing process.
rem @echo After the tests are completed, the server window will be closed.
rem @echo.
rem @echo The results of tests will be saved in the files:
rem @echo   WiFiConnectTestDirect-%dt%.txt
rem @echo   WiFiConnectTestReverse-%dt%.txt
rem @echo.
rem @echo  The analysis of the results is based on the following files:
rem @echo    bitrate-direct-%dt%.csv
rem @echo    bitrate-reverse-%dt%.csv
rem EndEngTextBlock
@echo.


%MYFILES%\adb push %MYFILES%\iperf3.18 /data/local/tmp 1>nul 2>errorhs.txt
%MYFILES%\adb shell chmod +x /data/local/tmp/iperf3.18 1>nul 2>errorch.txt
if %errorlevel% == 1 goto _iperferror

rem +++++++++++++++++++++++++++++++++

rem @start " " %MYFILES%\iperf3.exe -s
rem echo %copytotemp%
if "%copytotemp%"=="1" (set "iperfdir=%SYSTEMDRIVE%\Temp"&&call :_CopyingIperfToTempS) else (set iperfdir=%MYFILES%)
REM set iperfdir=%MYFILES%

rem start cmd /c "mode con:cols=80 lines=50 &C:\Temp\iperf3.exe -s"

rem pause
rem start cmd /c "mode con:cols=80 lines=50 &%MYFILES%\iperf3.exe -s"

rem start cmd /c "mode con:cols=80 lines=50 &d:\Quest\_Cmd\__Quas\Source\iperf3.exe -s"
rem echo %iperfdir%
rem pause

start cmd /c "mode con:cols=80 lines=50 &%iperfdir%\iperf3.exe -s"
rem ++++++++++++++++++++++++++++


@ping localhost -n 4 1>nul 2>nul
rem StartRusTextBlock
@echo ---------------------------------------------- >>%wfclogdt%
@echo   Дата проверки	: %dppt%>>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo +   Измерение пропускной способности Wi-Fi   + >>%wfclogdt%
@echo +           между шлемом и ПК                + >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo  ===   Обычная проверка (от шлема к ПК)   === >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo  Interval	: %ointerval% ms >>%wfclogdt%
@echo  Streams	: %qstreams% >>%wfclogdt%
@echo  Duration	: %itime% s >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo. >>%wfclogdt%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  Data of check	: %dppt%>>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo +   Measuring Wi-Fi throughput   + >>%wfclogdt%
rem @echo +   between the headset and PC   + >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  ===   Regular check (from headset to PC)   === >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  Interval		: %ointerval% ms >>%wfclogdt%
rem @echo  Streams		: %qstreams% >>%wfclogdt%
rem @echo  Duration		: %itime% s >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo. >>%wfclogdt%
rem EndEngTextBlock


rem >>>>>>>>>>>>>>>>>>>>>>
rem set bndwidth=200000000
set bndwidth=0
rem >>>>>>>>>>>>>>>>>>>>>>>


rem %MYFILES%\adb shell /data/local/tmp/iperf3.9 -t %itime% -i %iinterval% -c %ipaddrtxt% -P %qstreams% >> %wfclogdt% 2>error.txt
%MYFILES%\adb shell /data/local/tmp/iperf3.18 -t %itime% -i %iinterval% -b %bndwidth% -c %ipaddrtxt% -P %qstreams% -f m>> %wfclogdt% 2>errorst.txt

if %errorlevel% == 1 goto _iperferror
@echo. >>%wfclogdt%

set wfclogr=WiFiConnectTestReverse
set wfclogdt=%wfclogr%-%dt%.txt
rem StartRusTextBlock
@echo ---------------------------------------------- >>%wfclogdt%
@echo   Дата проверки	: %dppt%>>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo +   Измерение пропускной способности Wi-Fi   + >>%wfclogdt%
@echo +           между шлемом и ПК                + >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo  === Реверсивная проверка (от ПК к шлему) === >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo  Intervals	: %ointerval% ms >>%wfclogdt%
@echo  Streams	: %qstreams% >>%wfclogdt%
@echo  Duration	: %itime% s >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo. >>%wfclogdt%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  Data of check	: %dppt%>>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo +   Measuring Wi-Fi throughput   + >>%wfclogdt%
rem @echo +   between the headset and PC   + >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  ===   Reverse check (from PC to headset) === >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  Intervals	: %ointerval% ms >>%wfclogdt%
rem @echo  Streams	: %qstreams% >>%wfclogdt%
rem @echo  Duration	: %itime% s >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo. >>%wfclogdt%
rem EndEngTextBlock
%MYFILES%\adb shell /data/local/tmp/iperf3.18 -t %itime% -i %iinterval% -b %bndwidth% -c %ipaddrtxt% -P %qstreams% -R -f m>> %wfclogdt% 2>errorcl.txt
if %errorlevel% == 1 goto _iperferror
@taskkill /F /IM iperf3.exe 1>nul 2>nul
for /f "delims=" %%A in ('dir /b /a-d %cd%\error*.txt') do (
rem for %%A IN (%cd%\errorcl.txt) DO (
 if %%~zA EQU 0 (del %%A)
)
%MYFILES%\adb shell rm /data/local/tmp/iperf3.18 1>nul 2>nul

setlocal enableextensions enabledelayedexpansion

rem for /f "delims=" %%a in ('dir /b /a-d *.csv 2^>nul 1^>nul') do (
rem set csvfileforren=%%a
rem @ren !csvfileforren! !csvfileforren!.old 1>nul 2>nul
rem )


rem For /F "skip=16 tokens=7 eol=- delims= " %%a In (%wfclogd%-%dt%.txt) Do (

rem >>>>>>>>>>>>>>>>>>>>>>>>>>>>
rem for /f "usebackq skip=15 tokens=7" %%a in (`findstr /i /v /c:"Transfer" /c:"Sum" /c:"Connected" /c:"- - - - - -" WiFiConnectTestReverse-2025-02-12_04-47-06.txt`) do (
rem >>>>>>>>>>>>>>>>>>>>>>>>>>>>

for /f "usebackq skip=14 tokens=7" %%a in (`findstr /i /v /c:"Transfer" /c:"Sum" /c:"Connected" /c:"- - - - - -" /c:"sender" /c:"receiver" %wfclogd%-%dt%.txt`) do (
set bitrated=%%a
for /f "tokens=1,2 delims=." %%A in ("!bitrated!") do (
    set "whole=%%A"
    set "decimal=%%B"
)
if not defined decimal (
@echo !whole! >>bitrate-direct-%dt%.csv
) else (
    if !decimal! geq 5 (
        set /a whole+=1
    )
@echo !whole! >>bitrate-direct-%dt%.csv
)
)

rem For /F "skip=16 tokens=7 eol=- delims= " %%a In (%wfclogr%-%dt%.txt) Do (

for /f "usebackq skip=15 tokens=7" %%a in (`findstr /i /v /c:"Transfer" /c:"Sum" /c:"Connected" /c:"- - - - - -" /c:"sender" /c:"receiver" %wfclogr%-%dt%.txt`) do (
set bitrater=%%a
for /f "tokens=1,2 delims=." %%A in ("!bitrater!") do (
    set "whole=%%A"
    set "decimal=%%B"
)
if not defined decimal (
@echo !whole! >>bitrate-reverse-%dt%.csv
) else (
    if !decimal! geq 5 (
        set /a whole+=1
    )
@echo !whole! >>bitrate-reverse-%dt%.csv
)
)

endlocal
exit /b
rem goto _iperftest

:_IperfLogsParsing
@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%a in ('dir /b /a-d %cd%\*.csv 2^>nul') do (
set csvfileforren=%%a
ren !csvfileforren! !csvfileforren!.old 1>nul 2>nul
)

echo   ----------------
if not exist %cd%\iperflog.txt echo   = Iperf log 'iperflog.txt' not found. Press key to exit&&pause >nul&& goto _iperftestmenu
echo   = Start parsing..
for /f "usebackq tokens=7" %%a in (`findstr /i /v /c:"Transfer" /c:"Sum" /c:"Connected" /c:"- - - - - -" /c:"sender" /c:"receiver" iperflog.txt`) do (

set bitrated=%%a
for /f "tokens=1,2 delims=." %%A in ("!bitrated!") do (
    set "whole=%%A"
    set "decimal=%%B"
)
if not defined decimal (
@echo !whole! >>iperflog.csv
) else (
    if !decimal! geq 5 (
        set /a whole+=1
    )
@echo !whole! >>iperflog.csv
)
)
goto _WiFiTestCSVAnalyzer



:_SetIperfAutoTesParameters
set itime=180
set iinterval=0.1
set ointerval=100
set qstreams=1
call :_IperfTestProcedure
goto :_WiFiTestCSVAnalyzer

:_SetIperfAutoTesParametersTest
set itime=5
set iinterval=1
set ointerval=1000
set qstreams=1
call :_IperfTestProcedure
if "%tabanalize%"=="1" goto _WiFiTestCSVAnalyzer

cls
@echo.
@echo.
@echo.
@echo.
@echo =================================================================
@echo.
rem StartRusTextBlock
@echo            Проверка соединения прошла успешно. 
@echo         Можно запускать полноценное тестирование.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      Connection check completed successfully.
rem @echo         Full testing can now be started.
rem EndEngTextBlock
@echo.
call :_prevmenu
goto _iperftestmenu

:_WiFiTestCSVAnalyzer
cls
setlocal enableextensions enabledelayedexpansion
call :_cdcbnoreg
if not exist *.csv goto _notestcsvfiles
rem for /r "%cd%" %%i in (*.csv) do (
rem set csvfile=%%i
@mode con:cols=87 lines=39
for /f "delims=" %%a in ('dir /b /a-d *.csv') do (
set csvfile=%%a
set "prct=%%%"
rem StartRusTextBlock
@echo !csvfile! | findstr /i /c:"direct"  1>NUL 2>&1 && @set "vector=%_fBlack%%_bCyan%Результаты прямой проверки [от шлема к ПК]                                        %_fReset%" 2>nul 1>nul
@echo !csvfile! | findstr /i /c:"reverse" 1>NUL 2>&1 && @set "vector=%_fBlack%%_bCyan%Результаты реверсивной проверки [от ПК к шлему]                                   %_fReset%" 1>NUL 2>&1
@echo !csvfile! | findstr /i /c:"iperflog" 1>NUL 2>&1 && @set "vector=%_fBlack%%_bCyan%Парсинг логов iperf                                   %_fReset%" 1>NUL 2>&1
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo !csvfile! | findstr /i /c:"direct" > NUL 2>&1 && set "vector=%_fBlack%%_bCyan%Results of direct check [from headset to PC]                                        %_fReset%"
rem @echo !csvfile! | findstr /i /c:"reverse" > NUL 2>&1 && set "vector=%_fBlack%%_bCyan%Results of reverse check [from PC to headset]                                   %_fReset%"
rem @echo !csvfile! | findstr /i /c:"iperflog" 1>NUL 2>&1 && @set "vector=%_fBlack%%_bCyan% iperf logs parsing                                %_fReset%" 1>NUL 2>&1
rem EndEngTextBlock
call :_WifiTestTableMax
call :_WifiTestTableNumb
call :_PercentChecksNumb
call :_WifiTestTableView
call :_WiFiTestParametersExtract
)
rem StartRusTextBlock
@echo ====================================================================================
@echo  Длительность тестов: %fduration%	: Потоки: %fstreams%	: Интервал: %fintervals%
@echo ====================================================================================
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ====================================================================================
rem @echo  Tests duration : %fduration%	: Streams: %fstreams%	: Interval: %fintervals%
rem @echo ====================================================================================
rem EndEngTextBlock

call :_settime
@ping localhost -n 2 2>nul 1>nul
%myfiles%\nircmdc.exe savescreenshotwin %cd%\WiFiTestRezult-%dt%.png 1>nul 2>nul

:_tabchoice
set choice=m
rem StartRusTextBlock
@set /p choice="Для просмотра пояснений введите h и нажмите Enter. Для выхода нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @set /p choice="Enter 'h' for more information and press Enter. Press Enter to exit: "
rem EndEngTextBlock
rem @echo.
if not defined choice goto _tabchoice
if /i "%choice%"=="m" (@mode con:cols=100 lines=52&&GOTO _iperftest)
if /i "%choice%"=="h" (@mode con:cols=100 lines=52&&GOTO _WiFiTabExclamation)
cls
goto _tabchoice

:_WiFiTabExclamation
rem StartRusTextBlock
@echo  %_fBWhite%%_bBlack%ПОЯСНЕНИЕ К ТАБЛИЦЕ:%_fReset%
@echo.
@echo  Весь диапазон измерений битрейта поделен на 10 поддиапазонов, от 0 до максимального, для текущего
@echo  теста. В колонке %_fBYellow%%_bBlack%Проверки%_fReset% для каждого поддиапазона указан процент от общего количества проверок.
@echo  По нему можно понять уровень просадок. %_fBWhite%%_bBlack%Пример 1:%_fReset% если в десятом поддиапазоне число в колонке
@echo  %_fBYellow%%_bBlack%Проверки%_fReset% не 0, значит скорость просаживалась до уровня битрейта в этом поддиапазоне, то есть
@echo  %_fBlack%%_fBRed%от 0 до !numb10!%_fReset% мбит, на количество процентов в колонке %_fBYellow%%_bBlack%Проверки%_fReset%. %_fBWhite%%_bBlack%Пример 2:%_fReset% Для второго диапазона 
@echo  в колонке %_fBYellow%%_bBlack%Проверки%_fReset% число %_fBlack%%_fBGreen%!pnumb80!%prct%%_fReset%. Интервал поддиапазона %_fBlack%%_fBGreen%от !numb80! до !numb90!%_fReset% мбит, а это значит, что
@echo  битрейт %_fBlack%%_fBGreen%!pnumb80!%_fReset% процента времени был между %_fBlack%%_fBGreen%!numb80!%_fReset% и %_fBlack%%_fBGreen%!numb90!%_fReset% мбит. То есть, %_fBlack%%_fCyan%чем больше процент у высокого 
@echo  битрейта, тем лучше канал. Чем больше процент для низкого битрейта, тем сильнее просадки%_fReset%.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  %_fBWhite%%_bBlack%EXPLANATION FOR THE TABLE:%_fReset%
rem @echo.
rem @echo  The entire bitrate range is divided into 10 subranges, from 0 to the maximum, for the current
rem @echo  test. In the %_fBYellow%%_bBlack%Checks%_fReset% column, each subrange indicates the percentage of total checks to understand
rem @echo  the level of bitrate drops. %_fBWhite%%_bBlack%Example 1:%_fReset% If the number in the %_fBYellow%%_bBlack%Checks%_fReset% column for the tenth subrange
rem @echo  is not 0, it means the bitrate dropped to that subrange level, i.e. %_fBlack%%_fBRed%from 0 to !numb10!%_fReset% Mbps, for the 
rem @echo  percentage in the %_fBYellow%%_bBlack%Checks%_fReset% column. %_fBWhite%%_bBlack%Example 2:%_fReset% For the second subrange in the %_fBYellow%%_bBlack%Checks%_fReset%column, the
rem @echo  number is %_fBlack%%_fBGreen%!pnumb80!%prct%%_fReset%. The subrange interval is %_fBlack%%_fBGreen%from !numb80! to !numb90!%_fReset% Mbps, meaning that the bitrate was
rem @echo  %_fBlack%%_fBGreen%!pnumb80!%_fReset% percent of the time between %_fBlack%%_fBGreen%!numb80!%_fReset% and %_fBlack%%_fBGreen%!numb90!%_fReset% Mbps. Thus, %_fBlack%%_fCyan%the higher percentage at high bitrates,
rem @echo  the better the channel. The higher the percentage for low bitrates, the more severe the drops%_fReset%.
rem EndEngTextBlock
call :_prevmenu
rem @timeout 1 1>nul
goto _iperftestmenu


:_WiFiTestParametersExtract
if not exist WiFiConnectTestReverse*.txt exit /b
for /f "delims=" %%a in ('dir /b /a-d WiFiConnectTestReverse*.txt') do set wftestfile=%%a
for /f "tokens=1,2 delims=:" %%a in ('findstr /i /c:"Intervals" %wftestfile%') do set fintervals=%%b
for /f "tokens=1,2 delims=:" %%a in ('findstr /i /c:"Streams" %wftestfile%') do set fstreams=%%b
for /f "tokens=1,2 delims=:" %%a in ('findstr /i /c:"Duration" %wftestfile%') do set fduration=%%b
rem @echo %fintervals%
rem @echo %fstreams%
rem @echo %fduration%
)
exit /b

:_WifiTestTableMax
set exnumb=0
set qnumb=0
@for /f %%a in (%csvfile%) do (
@set /a cnumb=%%a 2>nul
@if !cnumb! GTR !exnumb! set exnumb=!cnumb!
set /a qnumb=!qnumb!+1
)
set /a maxnumb=!exnumb!

@if !maxnumb! GEQ 800 (
rem StartRusTextBlock
set "rouqua=Превосходная пропускная способность"
) else (
@if !maxnumb! GEQ 500 (
set "rouqua=Отличная пропускная способность"
) else (
@if !maxnumb! GEQ 400 (
set "rouqua=Хорошая пропускная способность"
) else (
@if !maxnumb! GEQ 300 (
set "rouqua=Неплохая пропускная способность"
) else (
@if !maxnumb! GEQ 200 (
set "rouqua=Пропускная способность маловата"
) else (
set "rouqua=Пропускная способность крайне мала"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "rouqua=Excellent bandwidth"
rem ) else (
rem @if !maxnumb! GEQ 500 (
rem set "rouqua=Great bandwidth"
rem ) else (
rem @if !maxnumb! GEQ 400 (
rem set "rouqua=Good bandwidth"
rem ) else (
rem @if !maxnumb! GEQ 300 (
rem set "rouqua=Fair bandwidth"
rem ) else (
rem @if !maxnumb! GEQ 200 (
rem set "rouqua=Bandwidth is somewhat low"
rem ) else (
rem set "rouqua=Bandwidth is extremely low"
rem EndEngTextBlock
)
)
)
)
)

set inumb0=0
set inumb10=0
set inumb20=0
set inumb30=0
set inumb40=0
set inumb50=0
set inumb60=0
set inumb70=0
set inumb80=0
set inumb90=0

set /a numb10=!maxnumb!/10
set /a numb20=!numb10!*2
set /a numb30=!numb10!*3
set /a numb40=!numb10!*4
set /a numb50=!numb10!*5
set /a numb60=!numb10!*6
set /a numb70=!numb10!*7
set /a numb80=!numb10!*8
set /a numb90=!numb10!*9
exit /b

:_WifiTestTableNumb
@for /f %%a in (%csvfile%) do (
set nextnumb=%%a
@if !nextnumb! GEQ !numb90! (
set /a inumb90=!inumb90!+1
) else (
@if !nextnumb! GEQ !numb80! (
set /a inumb80=!inumb80!+1
) else (
@if !nextnumb! GEQ !numb70! (
set /a inumb70=!inumb70!+1
) else (
@if !nextnumb! GEQ !numb60! (
set /a inumb60=!inumb60!+1
) else (
@if !nextnumb! GEQ !numb40! (
set /a inumb40=!inumb40!+1
) else (
@if !nextnumb! GEQ !numb30! (
set /a inumb30=!inumb30!+1
) else (
@if !nextnumb! GEQ !numb20! (
set /a inumb20=!inumb20!+1
) else (
@if !nextnumb! GEQ !numb10! (
set /a inumb10=!inumb10!+1
) else (
set /a inumb0=!inumb0!+1
)
)
)
)
)
)
)
)
)
exit /b

:_PercentChecksNumb

rem Считаем процент одного числа к другому.
rem 492 - максимальный битрейт.
rem 281 - битрейт, процент которого нужно узнать
rem set /A RES=(281*1000)*100/492
rem echo %RES:~0,-3%.%RES:~-3% 
endlocal
set /A pcnumb90=(%inumb90%*100)*100/%qnumb%

if [%pcnumb90:~0,-2%]==[] (
set pnumb90=0.%pcnumb90:~-2%
) else (
set pnumb90=%pcnumb90:~0,-2%.%pcnumb90:~-2%
)

set /A pcnumb80=(%inumb80%*100)*100/%qnumb%
if [%pcnumb80:~0,-2%]==[] (
set pnumb80=0.%pcnumb80:~-2%
) else (
set pnumb80=%pcnumb80:~0,-2%.%pcnumb80:~-2%
)

set /A pcnumb70=(%inumb70%*100)*100/%qnumb%
if [%pcnumb70:~0,-2%]==[] (
set pnumb70=0.%pcnumb70:~-2%
) else (
set pnumb70=%pcnumb70:~0,-2%.%pcnumb70:~-2%
)

set /A pcnumb60=(%inumb60%*100)*100/%qnumb%
if [%pcnumb60:~0,-2%]==[] (
set pnumb60=0.%pcnumb60:~-2%
) else (
set pnumb60=%pcnumb60:~0,-2%.%pcnumb60:~-2%
)

set /A pcnumb50=(%inumb50%*100)*100/%qnumb%
if [%pcnumb50:~0,-2%]==[] (
set pnumb50=0.%pcnumb50:~-2%
) else (
set pnumb50=%pcnumb50:~0,-2%.%pcnumb50:~-2%
)

set /A pcnumb40=(%inumb40%*100)*100/%qnumb%
if [%pcnumb40:~0,-2%]==[] (
set pnumb40=0.%pcnumb40:~-2%
) else (
set pnumb40=%pcnumb40:~0,-2%.%pcnumb40:~-2%
)

set /A pcnumb30=(%inumb30%*100)*100/%qnumb%
if [%pcnumb30:~0,-2%]==[] (
set pnumb30=0.%pcnumb30:~-2%
) else (
set pnumb30=%pcnumb30:~0,-2%.%pcnumb30:~-2%
)

set /A pcnumb20=(%inumb20%*100)*100/%qnumb%
if [%pcnumb20:~0,-2%]==[] (
set pnumb20=0.%pcnumb20:~-2%
) else (
set pnumb20=%pcnumb20:~0,-2%.%pcnumb20:~-2%
)

set /A pcnumb10=(%inumb20%*100)*100/%qnumb%
if [%pcnumb20:~0,-2%]==[] (
set pnumb10=0.%pcnumb10:~-2%
) else (
set pnumb10=%pcnumb10:~0,-2%.%pcnumb10:~-2%
)
set /A pcnumb0=(%inumb0%*100)*100/%qnumb%
if [%pcnumb0:~0,-2%]==[] (
set pnumb0=0.%pcnumb0:~-2%
) else (
set pnumb0=%pcnumb0:~0,-2%.%pcnumb0:~-2%
)
exit /b

:_WifiTestTableView
@echo.
@echo  %vector%
@echo  -----------------------------------------------------------------------------------
rem StartRusTextBlock
@echo  Поддиапазоны замеров битрейта	: Проверки, %prct%	: Примечание 
@echo  -----------------------------------------------------------------------------------
@echo  %_fBlack%%_fBGreen%01.    !numb90! - !maxnumb! мбит  	: !pnumb90!   	: Обычные просадки.%_fReset%
@echo  %_fBlack%%_fBGreen%02.    !numb80! - !numb90! мбит  	: !pnumb80!   	: Допустимые просадки.%_fReset%
@echo  %_fBlack%%_fBYellow%03.    !numb70! - !numb80! мбит  	: !pnumb70!   	: Не очень хорошо, но жить можно.%_fReset%
@echo  %_fBlack%%_fBYellow%04.    !numb60! - !numb70! мбит		: !pnumb60!   	: Уже хуже, но жить все еще можно.%_fReset%
@echo  %_fBlack%%_fBYellow%05.    !numb50! - !numb60! мбит		: !pnumb50!   	: Плохие просадки.%_fReset%
@echo  %_fBlack%%_fBYellow%06.    !numb40! - !numb50! мбит		: !pnumb40!   	: Существенные просадки.%_fReset%
@echo  %_fBlack%%_fBRed%07.    !numb30! - !numb40! мбит		: !pnumb30!   	: В этих четырех нижних строках%_fReset%
@echo  %_fBlack%%_fBRed%08.    !numb20! - !numb30! мбит		: !pnumb20!   	: должны быть только нулевые значения.%_fReset%
@echo  %_fBlack%%_fBRed%09.    !numb10! - !numb20! мбит		: !pnumb10!   	: Если значения отличаются от нуля,%_fReset%
@echo  %_fBlack%%_fBRed%10.    0 - !numb10! мбит		: !pnumb0!    	: значит есть серьезные просадки.%_fReset%
@echo  -----------------------------------------------------------------------------------
@echo  Максимальный битрейт		: !maxnumb! мбит	: !rouqua!
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Bitrate measurement subranges	: Checks, %prct%	: Note 
rem @echo  -----------------------------------------------------------------------------------
rem @echo  %_fBlack%%_fBGreen%01.    !numb90! - !maxnumb! Mbps		: !pnumb90!   	: Normal dips.%_fReset%
rem @echo  %_fBlack%%_fBGreen%02.    !numb80! - !numb90! Mbps		: !pnumb80!   	: Acceptable dips.%_fReset%
rem @echo  %_fBlack%%_fBYellow%03.    !numb70! - !numb80! Mbps		: !pnumb70!   	: Not great, but livable.%_fReset%
rem @echo  %_fBlack%%_fBYellow%04.    !numb60! - !numb70! Mbps		: !pnumb60!   	: Worse, but still livable.%_fReset%
rem @echo  %_fBlack%%_fBYellow%05.    !numb50! - !numb60! Mbps		: !pnumb50!   	: Bad dips.%_fReset%
rem @echo  %_fBlack%%_fBYellow%06.    !numb40! - !numb50! Mbps		: !pnumb40!   	: Significant dips.%_fReset%
rem @echo  %_fBlack%%_fBRed%07.    !numb30! - !numb40! Mbps		: !pnumb30!   	: In these bottom four rows%_fReset%
rem @echo  %_fBlack%%_fBRed%08.    !numb20! - !numb30! Mbps		: !pnumb20!   	: should only have zero values.%_fReset%
rem @echo  %_fBlack%%_fBRed%09.    !numb10! - !numb20! Mbps		: !pnumb10!   	: If non-zero, serious dips,%_fReset%
rem @echo  %_fBlack%%_fBRed%10.    0 - !numb10! Mbps		: !pnumb0!    	: indicates severe dips.%_fReset%
rem @echo  -----------------------------------------------------------------------------------
rem @echo  Maximum bitrate		: !maxnumb! Mbps	: !rouqua!
rem EndEngTextBlock
exit /b

:_notestcsvfiles
cls
@echo.
@echo.
@echo.
@echo.
@echo   ======================================================================
rem StartRusTextBlock
@echo   +++ CSV файлы с результатами тестов отсутствуют в текущем каталоге +++
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   +++ CSV files with test results are not present in the current directory +++
rem EndEngTextBlock
@echo   ======================================================================
@echo.
@echo.
@echo.
@echo.
call :_prevmenu
goto _iperftestmenu

::>>>>>>>>>>>>>>>>>

:_BackupPrevWiFiTestFiles
echo off
rem @chcp 1251 >nul
for /f %%a in ('dir /B WiFiConnectTestReverse*') do set filename=%%a

rem set "filePath=%~dp0%filename%"
set "filePath=%cd%\%filename%"

rem set filePath=d:\Quest\_Cmd\__Quas\Datetime\_tz-list.cmd

set "pscommand=(Get-Item '%filePath%').LastWriteTime.ToString('yyyy-MM-dd_HH-mm-ss')"

rem call :_psCommandRun datamodfile
rem echo %datamodfile%

call :_ps1CommandRun archivedata

rem for /f "tokens=1-2 delims==" %%a in ('wmic datafile where name^="%filePath:\=\\%" get LastModified /value ^| find "="') do (


rem for /f "tokens=1-2 delims==" %%a in ('wmic datafile where name^="%filePath:\=\\%" get CreationDate /value ^| find "="') do (
rem     set "createDate=%%b"
rem )
rem set "year=%createDate:~0,4%"
rem set "month=%createDate:~4,2%"
rem set "day=%createDate:~6,2%"
rem set "hour=%createDate:~8,2%"
rem set "minute=%createDate:~10,2%"
rem set "second=%createDate:~12,2%"
rem set archivedata=%year%-%month%-%day%_%hour%-%minute%-%second%

rem set "year=!createDate:~0,4!"
rem set "month=!createDate:~4,2!"
rem set "day=!createDate:~6,2!"
rem set "hour=!createDate:~8,2!"
rem set "minute=!createDate:~10,2!"
rem set "second=!createDate:~12,2!"
rem set archivedata=!year!-!month!-!day!_!hour!-!minute!-!second!
rem :_BackupPrevWiFiTestFiles
@md OldWiFiTestFiles 1>nul 2>nul
%myfiles%\7z.exe a -mx7 -t7z WiFiTests-%archivedata%.7z bitrate*.csv 1>nul 2>nul
%myfiles%\7z.exe a -mx7 -t7z WiFiTests-%archivedata%.7z WiFiTestRezult*.* 1>nul 2>nul
%myfiles%\7z.exe a -mx7 -t7z WiFiTests-%archivedata%.7z WiFiConnectTest*.* 1>nul 2>nul

@move WiFiTests-%archivedata%.7z %cd%\OldWiFiTestFiles\ 1>nul 2>nul
@del bitrate*.csv /Q /F 1>nul 2>nul
@del WiFiConnectTest*.* /Q /F 1>nul 2>nul
@del WiFiTestRezult*.* /Q /F 1>nul 2>nul
rem @chcp 65001 >nul
exit /b


:_ExtractIPaddress
@For /F "skip=1 tokens=1" %%a In (ipaddr.txt) Do (
@set ipaddrtxt=%%a
)
exit /b

:_CreateIPaddressTxt
rem StartRusTextBlock
@echo IP адрес вашего компьютера будет взят из этого файла >ipaddr.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The IP address of your computer will be taken from this file >ipaddr.txt
rem EndEngTextBlock
@echo %ipaddr% >>ipaddr.txt
::@@echo резерв >>settings.txt
::@@echo Четвертая строка >>settings.txt
exit /b

:_GetIP ipaddr
@setlocal ENABLEEXTENSIONS & set "iii=0.0.0.0" & set "jjj="
@for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
  if not defined jjj for %%b in (%%a) do set "iii=%%b" & set "jjj=1")
endlocal & set "%1=%iii%"
exit /b

:_iperferror
@taskkill /F /IM iperf3.exe 1>nul 2>nul
@echo.
@echo ------------------------------------------------
@echo.
rem StartRusTextBlock
@echo         +++++++ Ошибка! +++++++
@echo.
rem @echo.
@echo    Текст ошибки сохранен в файле error.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++++ Error! +++++++
rem @echo.
rem @echo.
rem @echo The error text is saved in the error.txt file
rem EndEngTextBlock
rem @echo.
call :_prevmenu
goto _iperftest

:_IPaddrEmpty
@echo.
@echo ------------------------------------------------
@echo.
rem StartRusTextBlock
@echo     +++++++ Ошибка! +++++++
@echo.
@echo.
@echo  Не удалось определить IP адрес вашего компьютера. 
@echo  Пожалуйста, пропишите его вручную в файл ipaddr.txt во второй строчке.
@echo  Файл лежит рядом с программой.
@echo. 
@echo  -------------
@echo  Нажмите любую кнопку чтобы перейти в меню тестирования
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++++ Error! +++++++
rem @echo.
rem @echo.
rem @echo Failed to determine the IP address.
rem @echo Please manually enter it into the ipaddr.txt file on the second line.
rem @echo The file is located next to the program.
rem EndEngTextBlock
@pause >nul
goto _iperftestmenu

rem _exitout

:_HeadsetIP
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|findstr /i /c:"inet "') DO set ipfull=%%G
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO set iphs=%%G
@if [%iphs%]==[] goto _IPaddrEmpty
exit /b


:_Division
Set /A Znak=3
::Введите делимое
Set /A n1=%iinterval%
::Введите делитель
Set /A n2=1000
::Разделитель целой и дробной части
Set Delim=.
Set /A nC=n1/n2
Set /A nO=%n1% %% %n2%
if %nO%==0 Goto :ret
Set /A nD=nO
For /L %%A in (1,1,%Znak%) do Set /A nD*=10
Set /A nD=nd/n2
:Trim0
Set /A rest=%nd% %% 10
if %rest%==0 (Set /A nd/=10& Goto :Trim0)
Set nd=%Delim%%nD%
:ret
rem @echo %nC%%nD%
set iinterval=%nC%%nD%
exit /b

:_lssinterval
@echo -------------------------------
rem StartRusTextBlock
@echo  +++ Интервал слишком маленький  +++
@echo     Он должен быть 100 или выше
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  +++ Interval is too small +++
rem @echo    It must be 100 and higher
rem EndEngTextBlock
@echo -------------------------------
goto _setinterval
rem exit /b

:_shownetstatall
@%verbecho%
@cls
rem call :_hat
@echo.
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  Статистика netstat для шлема:
@echo    A. Вывести всю статистику
@echo    B. Вывести только соединения ESTABLISHED
@echo    C. Вывести только соединения TIME_WAIT
@echo.
@echo  Статистика netstat для ПК:
@echo    D. Вывести всю статистику
@echo    E. Вывести только соединения ESTABLISHED
@echo    F. Вывести только соединения TIME_WAIT
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset network statistics
rem @echo.
rem @echo    A. Alll statistics
rem @echo    B. Connection with status ESTABLISHED only
rem @echo    C. Connection with status TIME_WAIT only
rem @echo.
rem @echo.
rem @echo  PC network statistics
rem @echo.
rem @echo    D. All statistics
rem @echo    E. Connection with status ESTABLISHED only
rem @echo    F. Connection with status TIME_WAIT only
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
rem @Set /p choice="Выберите пункт меню и нажмите Enter: "
if not defined choice goto _shownetstatall
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (goto _beginn)
if /i "%choice%"=="a" (GOTO _shownetstaths)
if /i "%choice%"=="b" (set "netstatstatus= | findstr ESTABLISHED" && GOTO _shownetstaths)
if /i "%choice%"=="c" (set "netstatstatus= | findstr TIME_WAIT" && GOTO _shownetstaths)

if /i "%choice%"=="d" (goto _shownetstatpc)
if /i "%choice%"=="e" (set "netstatstatus= | findstr ESTABLISHED" && GOTO _shownetstatpc)
if /i "%choice%"=="f" (set "netstatstatus= | findstr TIME_WAIT" && GOTO _shownetstatpc)

if /i "%choice%"=="z" (GOTO _helplinksmenu)

@cls
goto _shownetstatall

:_shownetstaths
call :_hat
@echo.
rem StartRusTextBlock
@echo      ----------------------------------------------
@echo      ^|    Статистика сетевых подключений шлема    ^|
@echo      ----------------------------------------------
@echo.
@echo.
@echo    Состояние соединений:
@echo.
@echo  LISTENING	Ожидает входящих соединений.
@echo  SYN_SENT	Активно пытается установить соединение.
@echo  SYN_RECEIVED	Идет начальная синхронизация соединения.
@echo  ESTABLISHED	Соединение установлено.
@echo  CLOSE_WAIT	Удаленная сторона отключилась; ожидание закрытия сокета.
@echo  FIN_WAIT_1	Сокет закрыт; отключение соединения.
@echo  CLOSING	Сокет закрыт, затем удаленная сторона отключилась; ожидание подтверждения.
@echo  LAST_ACK	Удаленная сторона отключилась, затем сокет закрыт; ожидание подтверждения.
@echo  FIN_WAIT_2	Сокет закрыт; ожидание отключения удаленной стороны.
@echo  TIME_WAIT	Сокет закрыт, но ожидает пакеты, ещё находящиеся в сети для обработки
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       -------------------------------------
rem @echo       ^|    Headset network statistics     ^|
rem @echo       -------------------------------------
rem @echo.
rem @echo.
rem @echo    Connection states:
rem @echo.
rem @echo  LISTENING     Waiting for incoming connections.
rem @echo  SYN_SENT      Actively trying to establish a connection.
rem @echo  SYN_RECEIVED  Initial connection synchronization.
rem @echo  ESTABLISHED   Connection established.
rem @echo  CLOSE_WAIT    Remote side has closed the connection; waiting for socket closure.
rem @echo  FIN_WAIT_1    Socket closed; disconnecting.
rem @echo  CLOSING       Socket closed, then remote side disconnected; waiting for confirmation.
rem @echo  LAST_ACK      Remote side disconnected, then socket closed; waiting for confirmation.
rem @echo  FIN_WAIT_2    Socket closed; waiting for remote side to disconnect.
rem @echo  TIME_WAIT     Socket closed, but waiting for packets still in the network to be processed
rem EndEngTextBlock
@echo  ----------------------------------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo  Это может занять некоторое время, ждите...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  This may take some time, please wait...
rem EndEngTextBlock
@echo.
@%MYFILES%\adb shell netstat -tw%netstatstatus%"
call :_erlvl
@set "choice=1"
@echo.
@echo.
rem StartRusTextBlock
@Set /p choice="Для обновления статистики нажмите Enter (Выход в меню - 0): "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="To update statistics, press Enter (Exit to the menu - 0): "
rem EndEngTextBlock
if not defined choice goto _shownetstaths
if "%choice%"=="0" (goto _shellmenu)
if "%choice%"=="1" (GOTO _shownetstaths)
goto _shownetstaths

:_shownetstatpc
call :_hat
@echo.
rem StartRusTextBlock
@echo      -------------------------------------------------
@echo      ^|   Статистика сетевых подключений компьютера   ^|
@echo      -------------------------------------------------
@echo.
@echo.
@echo    Состояние соединений:
@echo.
@echo  LISTENING	Ожидает входящих соединений.
@echo  SYN_SENT	Активно пытается установить соединение.
@echo  SYN_RECEIVED	Идет начальная синхронизация соединения.
@echo  ESTABLISHED	Соединение установлено.
@echo  CLOSE_WAIT	Удаленная сторона отключилась; ожидание закрытия сокета.
@echo  FIN_WAIT_1	Сокет закрыт; отключение соединения.
@echo  CLOSING	Сокет закрыт, затем удаленная сторона отключилась; ожидание подтверждения.
@echo  LAST_ACK	Удаленная сторона отключилась, затем сокет закрыт; ожидание подтверждения.
@echo  FIN_WAIT_2	Сокет закрыт; ожидание отключения удаленной стороны.
@echo  TIME_WAIT	Сокет закрыт, но ожидает пакеты, ещё находящиеся в сети для обработки
@echo  ----------------------------------------------------------------------------------------
@echo.
@echo   Вывод команды netstat отображается в отдельном окне и обновляется каждые 5 секунд
@echo   Для остановки процесса просто закройте его.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       ---------------------------------
rem @echo       ^|     PC network statistics     ^| 
rem @echo       ---------------------------------
rem @echo.
rem @echo    Connection states:
rem @echo.
rem @echo  LISTENING     Waiting for incoming connections.
rem @echo  SYN_SENT      Actively trying to establish a connection.
rem @echo  SYN_RECEIVED  Initial connection synchronization.
rem @echo  ESTABLISHED   Connection established.
rem @echo  CLOSE_WAIT    Remote side has closed the connection; waiting for socket closure.
rem @echo  FIN_WAIT_1    Socket closed; disconnecting.
rem @echo  CLOSING       Socket closed, then remote side disconnected; waiting for confirmation.
rem @echo  LAST_ACK      Remote side disconnected, then socket closed; waiting for confirmation.
rem @echo  FIN_WAIT_2    Socket closed; waiting for remote side to disconnect.
rem @echo  TIME_WAIT     Socket closed, but waiting for packets still in the network to be processed
rem EndEngTextBlock
@echo  ----------------------------------------------------------------------------------------
@echo.
@echo   The results of the Netstat command is displayed
@echo   in a separate window and is updated every 5 seconds
@echo   To stop the process, simply close it.
:: set "netstatstatus= | findstr ESTABLISHED"
:: set "netstatstatus= | findstr TIME_WAIT"
@start cmd /c "mode con:cols=120 lines=60 &netstat -f -a -p TCP 5%netstatstatus%"
@echo.
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для выхода в меню ^<^<^<
rem EndRusTextBlock

rem StartEngTextBlock
rem @echo ^>^>^> Press any key to exit menu ^<^<^<
rem EndEngTextBlock
@pause >nul
set netstatstatus=
goto _shellmenu

:_hwagamecontrol
@%verbecho%
@setlocal enableextensions enabledelayedexpansion
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo  Управление параметром Аппаратное ускорение
@echo    A.  Показать статус
@echo    B.  Включить
@echo    C.  Отключить
@echo    D.  Удалить параметр из реестра
@echo.
@echo  Управление параметром Игровой режим
@echo    E.  Показать статус
@echo    F.  Включить
@echo    G.  Отключить
@echo    H.  Удалить параметр из реестра
@echo.
@echo  Управление параметром Планировани GPU
@echo    I.  Показать статус
@echo    J.  Включить
@echo    K.  Отключить
@echo    L.  Удалить параметр из реестра (не рекомендуется)
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Hardware Accelerated parameter management
rem @echo.
rem @echo    A.  Show status
rem @echo    B.  Enable
rem @echo    C.  Disable
rem @echo    D.  Delete parameter from registry
rem @echo.
rem @echo  Game Mode parameter management
rem @echo.
rem @echo    E.  Show status
rem @echo    F.  Enable
rem @echo    G.  Disable
rem @echo    H.  Delete parameter from registry
rem @echo.
rem @echo  GPU Planning parameter management
rem @echo.
rem @echo    I.  Show status
rem @echo    J.  Enable
rem @echo    K.  Disable
rem @echo    L.  Delete parameter from registry (not recommended)
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
set hwadata=
set gmdata=
set hwastatus=
set gmstatus=
call :_MenuChoiceEnter
@echo.
if not defined choice goto _hwagamecontrol
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _parametersstatuscheck)
if /i "%choice%"=="b" (GOTO _hwaenable)
if /i "%choice%"=="c" (GOTO _hwadisable)
if /i "%choice%"=="d" (GOTO _hwadeletereg)
if /i "%choice%"=="e" (GOTO _parametersstatuscheck)
if /i "%choice%"=="f" (GOTO _gamemodeenable)
if /i "%choice%"=="g" (GOTO _gamemodedisable)
if /i "%choice%"=="h" (GOTO _gamemodedeletereg)
if /i "%choice%"=="i" (GOTO _parametersstatuscheck)
if /i "%choice%"=="j" (GOTO _gpuplanenable)
if /i "%choice%"=="k" (GOTO _gpuplandisable)
if /i "%choice%"=="l" (GOTO _gpuplandeletereg)
@cls
goto _hwagamecontrol

:_parametersstatuscheck

@For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Avalon.Graphics /v DisableHWAcceleration 2^>nul') do (set hwadata=%%a)
rem StartRusTextBlock
@if [%hwadata%]==[] (set hwastatus=Параметр не установлен && goto _GameModeCheck)
@if %hwadata%==0x1 (set hwastatus=Отключено) else (set hwastatus=Включено)
rem EndRusTextBlock
rem StartEngTextBlock
rem @if [%hwadata%]==[] (set hwastatus=Parameter or value is not set && goto _GameModeCheck)
rem @if %hwadata%==0x1 (set hwastatus=Disabled) else (set hwastatus=Enabled)
rem EndEngTextBlock

:_GameModeCheck
@For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar /v AllowAutoGameMode 2^>nul') do (set gmdata=%%a)
rem StartRusTextBlock
@if [%gmdata%]==[] (set gmstatus=Параметр не установлен  && goto _PlanningGPUCheck)
@if %gmdata%==0x1 (set gmstatus=Включен) else (set gmstatus=Отключен)
rem EndRusTextBlock
rem StartEngTextBlock
rem @if [%gmdata%]==[] (set gmstatus=Parameter or value is not set && goto _parametersstatusview)
rem @if %gmdata%==0x1 (set gmstatus=Enabled) else (set gmstatus=Disabled)
rem EndEngTextBlock

:_PlanningGPUCheck
@For /f "tokens=3" %%a in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers /v HwSchMode 2^>nul') do (set gpuplandata=%%a)
rem StartRusTextBlock
@if [%gpuplandata%]==[] (set gpuplanstatus=Параметр не установлен  && goto _parametersstatusview)
@if %gpuplandata%==0x2 (set gpuplanstatus=Включено) else (set gpuplanstatus=Отключено)
rem EndRusTextBlock
rem StartEngTextBlock
rem @if [%gpuplandata%]==[] (set gmstatus=Parameter or value is not set && goto _parametersstatusview)
rem @if %gpuplandata%==0x2 (set gpuplanstatus=Enabled) else (set gpuplanstatus=Disabled)
rem EndEngTextBlock

:_parametersstatusview
@echo.
@echo ----------------------------------------------------------------
rem StartRusTextBlock
@echo   Аппаратное ускорение	: %hwastatus%
@echo   Игровой режим		: %gmstatus%
@echo   Планирование GPU	: %gpuplanstatus%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Hardware accelerated	: %hwastatus%
rem @echo   Game Mode		: %gmstatus%
rem @echo   GPU Planning		: %gpuplanstatus%
rem EndEngTextBlock
rem @echo  ----------------------------------------------
rem @echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_hwaenable
@reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 0 /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Аппаратное ускорение включен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Parameter Hardware Accelerated has enabled
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_hwadisable
@reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 0 /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Аппаратное ускорение отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Hardware Accelerated has disabled
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_hwadeletereg
@reg delete "HKCU\SOFTWARE\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Аппаратное ускорение удален
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Hardware Accelerated has deleted
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_gamemodeenable
@reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Игровой режим включен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Game Mode has enabled
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_gamemodedisable
@reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Игровой режим отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Game Mode has disabled
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_gamemodedeletereg
@reg delete "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Игровой режим удален
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Game Mode has deleted
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_gpuplanenable
@reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Планирование GPU включен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Game Mode has enabled
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_gpuplandisable
@reg add "HHKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Планирование GPU отключен
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Game Mode has disabled
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_gpuplandeletereg
@reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /f 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Параметр Планирование GPU удален
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Parameter Game Mode has deleted
rem EndEngTextBlock
@echo.
call :_prevmenu
@cls
goto _hwagamecontrol

:_camtest
call :_cdc
@%verbecho%
call :_hat
SetLocal EnableExtensions EnableDelayedExpansion
@echo.
@echo.
rem StartRusTextBlock
@echo  Исправность камер можно определить по значению температуры. 
@echo  Их расположение условно обозначено "изнутри", то есть
@echo  со стороны линз, будто шлем надет:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  The condition of the cameras can be determined by the temperature value.
rem @echo  Their location is conventionally designated "from the inside", meaning
rem @echo  from the side of the lenses, as if the headset is worn:
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo          ЛВ                    ПВ
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo          TL                    TR
rem EndEngTextBlock
@echo.   
@echo          ^(^)-------=====--------^(^)
@echo          /                      \
@echo          ^|    ***       ***     ^|
@echo          ^|   *****     *****    ^|
@echo          ^|    ***       ***     ^|
@echo          ^|                      ^|
@echo          \_^(^)_____/---\_____^(^)_/
@echo.
rem StartRusTextBlock
@echo            ЛН               ПН
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo            BL               BR
rem EndEngTextBlock
@echo.
@echo.
rem StartRusTextBlock
@echo    Температура камер:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    Camera temperatures:
rem EndEngTextBlock
@echo.
For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone68/temp') Do Set rdcam=%%~I
::@@echo Правая нижняя:  !rdcam! >>cam.txt
set /a ardcam=!rdcam!/1000
rem StartRusTextBlock
@echo  Правая нижняя:  %ardcam%.!rdcam:~-3!°
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Bottom right camera:  %ardcam%.!rdcam:~-3!°
rem EndEngTextBlock

For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone69/temp') Do Set ldcam=%%~I
::@@echo Левая нижняя:   !ldcam! >>cam.txt
set /a aldcam=!ldcam!/1000
rem StartRusTextBlock
@echo  Левая нижняя:   %aldcam%.!rdcam:~-3!°
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Bottom left camera:   %aldcam%.!rdcam:~-3!°
rem EndEngTextBlock
@echo.
For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone70/temp') Do Set lucam=%%~I
::@@echo Левая верхняя:  !lucam! >>cam.txt
set /a alucam=!lucam!/1000
rem StartRusTextBlock
@echo  Левая верхняя:  %alucam%.!lucam:~-3!°
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Top left camera:  %alucam%.!lucam:~-3!°
rem EndEngTextBlock
For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone71/temp') Do Set rucam=%%~I
::@@echo Правая верхняя: !rucam! >>cam.txt
set /a arucam=!rucam!/1000
rem StartRusTextBlock
@echo  Правая верхняя: %arucam%.!rucam:~-3!°
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Top right camera: %arucam%.!rucam:~-3!°
rem EndEngTextBlock
@echo.
@echo ------------------------------------------------
rem StartRusTextBlock
@echo  Значительные отличия в показаниях (на градус и больше)
@echo  означают вероятную неисправность определенной камеры,
@echo  поскольку при работе исправная камера хоть чуть-чуть,
@echo  но нагревается, а неисправная - нет.
@echo.
@echo  На разницу температур между верхними и нижними камерами
@echo  не обращайте внимания, она может отличаться на градус или два.
@echo  Имеет смысл сравнивать между собой только нижние или верхние камеры.
@echo.
@echo   ...через 10 секунд показания обновятся...
@echo.
@echo  Для прерывания и выхода в меню нажмите любую кнопку
timeout 10| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & call :_prevmenu & @goto _shellmenu
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Substantial differences in readings (by a degree or more)
rem @echo  may indicate a possible malfunction of a specific camera,
rem @echo  as a functioning camera, however slightly,
rem @echo  heats up, whereas a malfunctioning one does not.
rem @echo.
rem @echo  Do not pay attention to the temperature difference
rem @echo  between the top and bottom cameras, it can differ by a degree or two.
rem @echo  It makes sense to compare only the bottom or top cameras.
rem @echo.
rem @echo   ...the readings will be updated in 10 seconds...
rem @echo.
rem @echo  To interrupt and return to the menu, press any key
rem @echo.
rem timeout 10| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure interrupted +++ ^ & @echo. ^ & call :_prevmenu & @goto _shellmenu
rem EndEngTextBlock
goto _camtest


:_changeusernamemenu
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   A.  Показать текущее глобальное имя пользователя
@echo   B.  Сменить глобальное имя пользователя
rem EndRusTextBlock

rem StartEngTextBlock
rem @echo   A.  Show current global username
rem @echo   B.  Change global username
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _changeusernamemenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _showusername)
if /i "%choice%"=="b" (GOTO _changeusername)
goto _changeusernamemenu


:_showusername
for /f %%a in ('%myfiles%\adb shell settings get global username') do set uname=%%a

rem StartRusTextBlock
@if %uname%==null set uname=Не определено
rem EndRusTextBlock

rem StartEngTextBlock
rem @if %uname%==null set uname=Not set
rem EndEngTextBlock
@echo ----------------------------------------------------------------
rem StartRusTextBlock
@echo   Текущее глобальное имя пользователя	: %uname%
rem EndRusTextBlock

rem StartEngTextBlock
rem @echo    Current global username	: %uname%
rem EndEngTextBlock
call :_prevmenu
goto _changeusernamemenu

:_changeusername
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@Set /p myusername="Введите желаемое имя пользователя и нажмите Enter: "
rem EndRusTextBlock

rem StartEngTextBlock
rem @Set /p myusername="Enter desired username and press Enter: "
rem EndEngTextBlock

@%myfiles%\adb shell settings put global username %myusername% 1>nul 2>nul

rem StartRusTextBlock
@echo Имя пользователя установлено.
rem EndRusTextBlock
@echo.
@echo.
rem StartEngTextBlock
rem @echo ----------------------------------------------------------------
rem @echo    = Username set
rem @echo.
rem goto _showusername
rem EndEngTextBlock

:_adblogcat
call :_settime
call :_hat
call :_hatmenu
@echo.
rem StartRusTextBlock
@echo    A.  Logcat: последние 5 тысяч строк
@echo    B.  Logcat: последние 10 тысяч строк
@echo    C.  Logcat: количество строк вручную
@echo    D.  Logcat: последние 5 минут
@echo    E.  Logcat: последние 10 минут
@echo    F.  Logcat: количество минут вручную
@echo    G.  Logcat: безлимит [ Откроется в отдельном окне ]
@echo    H.  Очистить Logcat
@echo    I.  Весь журнал
@echo    J.  Поиск по logcat [ Откроется в отдельном окне ]
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    A.  Logcat: last 5 thousand lines
rem @echo    B.  Logcat: last 10 thousand lines
rem @echo    C.  Logcat: number of lines manually
rem @echo    D.  Logcat: last 5 minutes
rem @echo    E.  Logcat: last 10 minutes
rem @echo    F.  Logcat: number of minutes manually
rem @echo    G.  Logcat: unlimited [ Will open in a separate window ]
rem @echo    H.  Clear Logcat
rem @echo    I.  Entire Log
rem @echo    J.  Search in logcat [ Will open in a separate window ]
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _adblogcat
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _lcfivestr)
if /i "%choice%"=="b" (GOTO _lctenstr)
if /i "%choice%"=="c" (GOTO _lccustomstr)
if /i "%choice%"=="d" (GOTO _lcfivemin)
if /i "%choice%"=="e" (GOTO _lctenmin)
if /i "%choice%"=="f" (GOTO _lccustommin)
if /i "%choice%"=="g" (GOTO _lcunlimit)
if /i "%choice%"=="h" (GOTO _lcclear)
if /i "%choice%"=="i" (GOTO _adblogcatd)
if /i "%choice%"=="j" (GOTO _adblogcatsearch)
cls
goto _adblogcat

:_lcfivestr
@set qstr=5000
@%myfiles%\adb logcat -t "%qstr%" >lc-5k-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-5k-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo File saved in the current directory with the name lc-5k-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat


:_lctenstr
@set qstr=10000
@%myfiles%\adb logcat -t "%qstr%" >lc-10k-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-10k-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo File saved in the current directory with the name lc-10k-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_lccustomstr
rem StartRusTextBlock
@Set /p custstr="Введите количество строк (в тысячах) нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p custstr="Enter the number of lines (in thousands) and press Enter: "
rem EndEngTextBlock
@set /a qstr=custstr*1000
@%myfiles%\adb logcat -t "%qstr%" >lc-%custstr%k-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-%custstr%k-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo File saved in the current directory with the name lc-%custstr%k-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_lcfivemin
@set etime=300
@call :_timefunction
@call :_settime
@%myfiles%\adb logcat -t "%odt% %lctime%" >lc-5min-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-5min-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo File saved in the current directory with the name lc-5min-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_lctenmin
@set etime=600
@call :_timefunction
@call :_settime
@%myfiles%\adb logcat -t "%odt% %lctime%" >lc-10min-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-10min-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo File saved in the current directory with the name lc-10min-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_lccustommin
@set etime=600
rem StartRusTextBlock
@Set /p mintime="Введите количество минут нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p mintime="Enter the number of minutes and press Enter: "
rem EndEngTextBlock
@set /a etime=mintime*60
@call :_timefunction
@call :_settime
@%myfiles%\adb logcat -t "%odt% %lctime%" >lc-%mintime%min-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-%mintime%min-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The file is saved in the current directory with the name lc-%mintime%min-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_lcunlimit
@start cmd /c "%MYFILES%\adb logcat >lc-unlim-%dt%.txt"
@echo =====================================================
rem StartRusTextBlock
@echo Как только надоест ждать - закройте второе окно.
@echo Файл с логами будет сохранен с именем lc-unlim-%dt%.txt"
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo As soon as you are tired of waiting - close the second window.
rem @echo The log file will be saved with the name lc-unlim-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_lcclear
@%myfiles%\adb logcat -c 1>nul 2>nul
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Logcat очищен.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Logcat cleared.
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_adblogcatd
@%myfiles%\adb logcat -d >lc-all-%dt%.txt
call :_erlvl
@echo =====================================================
rem StartRusTextBlock
@echo Файл сохранен в текущий каталог с именем lc-all-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The file is saved in the current directory under the name lc-all-%dt%.txt
rem EndEngTextBlock
call :_prevmenu
goto _adblogcat

:_adblogcatsearch
call :_cdc
call :_settime
call :_hat
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo   Будет запущен logcat с поиском введенного слова 
@echo.
@echo   Если передумали, введите 0 и нажмите Enter
@echo   для возврата в предыдущее меню.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Logcat will be started with the search for the entered word
rem @echo.
rem @echo   If you have changed your mind, enter 0 and press Enter
rem @echo   to return to the previous menu.
rem EndEngTextBlock
@echo.
@echo.
@echo.
@echo.
rem StartRusTextBlock
@Set /p lcsrch=" Bведите слово для выборки и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p lcsrch="Enter the word for search and press Enter: "
rem EndEngTextBlock
if %lcsrch%==0 goto _adblogcat
@echo ================================
rem StartRusTextBlock
@echo Идет поиск....
@echo.
@echo Для завершения просто закройте второе окно консоли
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Searching....
rem @echo.
rem @echo To finish, simply close the second console window
rem EndEngTextBlock
@echo ----------------------------------
@start cmd /c @%MYFILES%\adb shell logcat -s %lcsrch%
::@%MYFILES%\adb shell logcat -s %lcsrch%
::call :_erlvl
goto :_adblogcat
::goto _syscommenu


::=========== Sub ====================

:_timefunction

::Время разбирается на HH MM SS через For, для использования в дальнейшем, вот так:
@For /F "tokens=1,2,3 delims=:" %%A In ("%time%") Do (
@Set HH=%%A
@Set MM=%%B
@Set SS=%%C
)

:: А это сами функции для работы со временем

:: Устанавливаем время
::Set HH=23
::Set MM=15
::Set SS=00

:: Демонстрация работы
:: ===================================
::@echo Time                  = [%HH%:%MM%:%SS%]
@Call :SerializeTime
@Set TmpTime=%ErrorLevel%
::@echo Serialized time       =  %TmpTime%
@Call :DeserializeTime %TmpTime%
::@echo Deserialized time     = [%DHH%:%DMM%:%DSS%]
@Call :TMinus %TmpTime% %etime%
@Call :DeserializeTime %ErrorLevel%
::@echo Time - 2:30:14        = [%DHH%:%DMM%:%DSS%]
@set lctime=%DHH%:%DMM%:%DSS%.000
@Call :TPlus %TmpTime% 9014
@Call :DeserializeTime %ErrorLevel%
::@echo Time + 2:30:14        = [%DHH%:%DMM%:%DSS%]
:: ===================================

::===Функции работы со временем в .bat====================================
:: Anonymous, 2010
:: v 1.3
:ParseTimestamp
:: Разбирает на составляющие временную метку формата ЧЧ:ММ:СС
:: Формат:   Call :ParseTimestamp (время)
:: К примеру - Call :ParseTimestamp %time:~-0,8%
:: Вывод - в переменные HH MM и SS
For /F "tokens=1,2,3 delims=:" %%A In ("%1") Do (
    Set HH=%%A
    Set MM=%%B
    Set SS=%%C
)

:SerializeTime
:: Сериализует время из переменных HH MM и SS
:: Вывод - в ErrorLevel
Call :Cut %HH% HH&Call :Cut %MM% MM&Call :Cut %SS% SS
Set /A STime=(HH*60*60)+(MM*60)+SS
Exit /B %STime%

:DeserializeTime
:: Десериализует время, приводит его к стандартному формату
:: Формат:   Call :DeserializeTime (сериализованное время)
:: Вывод - в переменные DHH DMM и DSS
Set DHH=00&Set DMM=00&Set DSS=00
Set /A DHH=%1/60/60
Set /A DMM=(%1/60)-(DHH*60)
Set /A DSS=%1-(DHH*60*60)-(DMM*60)
If %DHH%==24 Set DHH=00
If %DHH% LSS 10 Set DHH=0%DHH%
If %DMM% LSS 10 Set DMM=0%DMM%
If %DSS% LSS 10 Set DSS=0%DSS%
Exit /B

:TMinus
:: Функция вычитания для сериализованного времени
:: Формат:   Call :TMinus (сериализованное время) (сколько секунд отнять)
:: Вывод - в ErrorLevel
Set Result=
Set /A Result=%1-%2
If %2 GTR %1 (
    Set /A Result=86400+%1-%2
)
Exit /B %Result%

:TPlus
:: Функция прибавления для сериализованного времени
:: Формат:   Call :TPlus (сериализованное время) (сколько секунд прибавить)
:: Вывод - в ErrorLevel
Set Result=
Set /A Result=%1+%2
If %Result% GTR 86400 (
    Set /A Result=%1+%2-86400
)
Exit /B %Result%

:Timer
:: Отсчитывает прошедшее с заданного момента время
:: Формат:   Call :Timer (запомненное сериализованное время)
:: Вывод - в ErrorLevel
:: Если счетчик переходит границу суток, число дней возрастает на 1
:: Дни выводятся в переменную ED (и накапливаются) // да, знаю, что костыль и быдлокод
Set OTime=%1
If "%ED%"=="" Set ED=0
Call :ParseTimestamp %time:~-0,8%
Call :SerializeTime
Set CTime=%STime%
If %OTime% GTR %CTime% (
    Set /A Timer=86400-%OTime%+%CTime%
    Set /A ED+=1
) Else (
    Set /A Timer=CTime-OTime
)
Exit /B %Timer%

:Timer2
:: Проверяет, прошел ли заданный промежуток времени
:: Формат:   Call :Timer2 (запомненное сериализованное время) (промежуток в секундах)
:: Вывод - в ErrorLevel (только 0=промежуток истёк или 1=промежуток ещё не истёк)
Call :ParseTimestamp %time:~-0,8%
Call :SerializeTime
Call :TMinus %STime% %1
If %2 GTR %Result% Set Timer2=1&Exit /B 1
Set Timer2=0&Exit /B 0

:Cut
:: Убирание ведущих нулей и пробелов
:: Формат:   Call :Cut (Двухзначное число) (Переменная, куда вывести резуьтат)
Set d=%1
If "%d:~,1%"=="0" Set %2=%d:~1%
If "%d:~,1%"==" " Set %2=%d:~1%
Exit /B

:_settime
set pscommand="Get-Date -Format 'yyyy.MM.dd-HH:mm:ss'"
call :_ps1CommandRun pcdatetime
set ti=%pcdatetime:~11,-6%-%pcdatetime:~14,-3%-%pcdatetime:~-2%
set da=%pcdatetime:~0,4%-%pcdatetime:~5,2%-%pcdatetime:~8,2%
set dt=%da%_%ti%
set dap=%pcdatetime:~0,10%
set tip=%pcdatetime:~-8%
set dppt=%pcdatetime%
set odt=%pcdatetime:~5,-12%-%pcdatetime:~8,-9%
@exit /b


:_SETTIMEOLD
rem set "pscommand=Get-Date -Format 'yyyy.MM.dd-HH:mm:ss'"
rem call :_psCommandRun pcdatetime
rem echo %pcdatetime%


@for /f %%a in ('wmic path win32_LocalTime Get Day^,Month^,Year /value') do >nul set "%%a"
set Month=00%Month%
set Month=%Month:~-2%
set Day=00%Day%
set Day=%Day:~-2%
set da=%Year%-%Month%-%Day%

::set da=%date:~6,4%-%date:~3,2%-%date:~0,2%
set ti=%time:~0,2%-%time:~3,2%-%time:~6,2%
set ti=%ti: =0%

set dap=%Year%.%Month%.%Day%
set tip=%time:~0,2%:%time:~3,2%:%time:~6,2%
set tip=%tip: =0%


set dt=%da%_%ti%
set dpt=%da%.%ti%
set dppt=%dap%-%tip%

@set odt=%date:~3,2%-%date:~0,2%
set vdate=%date:~0,2%.%date:~3,2%.%date:~6,4%
::@@echo %dt%
@exit /b

:_OFFLINE
@echo.
rem StartRusTextBlock
@echo  Шлем в режиме offline!
@echo  Пробуем устранить проблему...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Headset in offline mode!
rem @echo  Trying to solve the problem...
rem EndEngTextBlock
@%MYFILES%\adb kill-server 1>nul 2>nul
@%MYFILES%\adb start-server 1>nul 2>nul
call :_cdc
rem @%MYFILES%\adb devices | findstr 1WM 1>nul 2>nul
@If %ERRORLEVEL% EQU 1 GOTO _NOTFOUND
@%MYFILES%\adb devices | findstr /i /c:"offline" 1>nul 2>nul
@If %ERRORLEVEL%==0 GOTO _OFFLINEISSUE
@echo ========================================
rem StartRusTextBlock
@echo  Проблема устранена.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Problem solved.
rem EndEngTextBlock
@goto _returnmenu

:_NOTAUTORIZED
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       %_fBRed%++++ Шлем не авторизован! ++++%_fReset%
@echo.
@echo.
@echo.
@echo   Наденьте гарнитуру и нажмите на клавиатуре любую клавишу.
@echo   Программа отправит на шлем команду adb devices
@echo   После этого в шлеме всплывет окно, в котором нажмите на строчку:
@echo.
@echo   [ Всегда разрешать для этого компьютера ]
@echo   Затем перезапустите эту программу
@echo.
@echo   Если окно не появляется, перезагрузите шлем. Или выключите и включите снова
@echo   тумблер Режим разработчика в мобильном приложении Meta Horizon
@echo.
@echo.
@echo   = Нажмите любую кнопку для отправки команды adb на шлем =
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       ++++ The headset is not authorized! ++++
rem @echo.
rem @echo.
rem @echo.
rem @echo   Put on the headset and press any key on the keyboard.
rem @echo   The program will send the adb devices command to the headset.
rem @echo   After that, a pop-up window will appear in the headset where you should select:
rem @echo.
rem @echo   [ Always allow from this computer ]
rem @echo   Then restart this program.
rem @echo   If the window does not appear, reboot the headset
rem @echo.
rem @echo   = Press any key to send adb command =
rem @echo.
rem EndEngTextBlock
@pause >nul
@%MYFILES%\adb devices 1>nul 2>nul
@goto _exitout

:_OFFLINEISSUE
@echo ========================================
rem StartRusTextBlock
@echo  Устранить ошибку не удалось. 
@echo  Переподключите кабель и запустите программу снова
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo The error could not be fixed.
rem @echo Reconnect the cable and restart the program again
rem EndEngTextBlock
@goto _exitout

:_NoDevice
call :_hat
::@%MYFILES%\adb devices 2>NUL | findstr sideload 1>nul 2>nul
::@If %ERRORLEVEL% EQU 0 GOTO _sideloadmode
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       ==============================================================
@echo       ^|     %_fBlack%%_fBRed%           ++++ Шлем не обнаружен +++++           %_fReset%     ^|
@echo       ^|   %_fBRed%Внимательно прочитайте все что написано желтым цветом  %_fReset%  ^|
@echo       ==============================================================
@echo.
@echo       %_fCyan%Возможные решения:%_fReset%
@echo.
@echo      %_fBYellow% - проверьте работоспособность кабеля (например, смартфоном) или поменяйте на другой.
@echo       - подключите кабель от шлема к ПК в %_fYellow%задний%_fBYellow% USB порт ПК или смените порт.
@echo       - переверните разъем Type-C кабеля на 180 градусов, погладьте кота и подключите снова.
@echo       - перезагрузите шлем и компьютер
@echo       - обязательно запустите %_fBGreen%Интерактивный тест подключения%_fBYellow% из меню ниже
@echo       - откройте Диспетчер устройств и посмотрите, есть ли там устройство XSRP или Quest.
@echo         Диспетчер устройств можно открыть из меню чуть ниже, пункт D.%_fReset%
@echo.
@echo         %_fCyan%==============================================================
@echo                %_fBCyan%В 99%% СЛУЧАЕВ ПРОБЛЕМА РЕШАЕТСЯ ЗАМЕНОЙ КАБЕЛЯ
@echo         %_fCyan%==============================================================%_fReset%
@echo.
@echo       Если это происходит при прошивке шлема из режима Sideload, просто обновите драйверы
@echo       из Главного меню, пункт 3. Затем перезапустите эту программу снова.
rem @echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       ==============================================================
rem @echo       ^|  %_fBlack%%_fBRed%           ++++ Headset not detected +++++           %_fReset%     ^|
rem @echo       ==============================================================
rem @echo.
rem @echo       %_fBlack%%_fBBlue%Possible solutions:%_fBlack%
rem @echo.
rem @echo      %_fBlack%%_fBYellow% - connect the headset cable to a rear USB port on the PC
rem @echo       - check the cable for proper functionality or try another one
rem @echo       - open Device Manager and check if there's an XSRP or Quest device
rem @echo         You can open Device Manager from the menu below, option D.%_fReset%
rem @echo.
rem @echo       If this occurs while flashing the headset in Sideload mode,
rem @echo       just update the drivers from the Main Menu, options 3.
rem @echo.
rem @echo       Then restart this program again.
rem EndEngTextBlock
@goto _RunMenuNoDevice

:_HasMTPMode
call :_hat
::@%MYFILES%\adb devices 2>NUL | findstr sideload 1>nul 2>nul
::@If %ERRORLEVEL% EQU 0 GOTO _sideloadmode
@echo.
@echo.
rem StartRusTextBlock
@echo       ==============================================================
@echo       ^|     %_fBCyan%        ++++ Шлем подключен по %_fCyan%MTP%_fBCyan% +++++%_fReset%               ^|
@echo       ^|%_fBCyan%        Из-за этого он может быть недоступен для %_fCyan%ADB%_fReset%        ^|
@echo       ^|        %_fBGreen%Внимательно прочитайте все что написано ниже  %_fReset%      ^|
@echo       ==============================================================
@echo.
@echo.
@echo   %_fBYellow% Вероятнее всего это случилось когда вы нажали в шлеме на окошко или на такое уведомление:
@echo.
@echo        %_fYellow%Обнаружено устройство USB. 
@echo        Нажмите на это уведомление, чтобы получить доступ к файлам.%_fReset%
@echo.
@echo    %_fBYellow%Чтобы вернуть доступ по ADB (qLoader, Quas, SideQuest), перезагрузите шлем.
@echo    После перезагрузки %_fBRed%не нажимайте на это уведомление%_fBYellow%, если хотите сохранить доступ по ADB.
@echo    Используйте подключение по MTP только если вам действительно требуется непосредственный
@echo    доступ к папкам шлема из Проводника Windows.
@echo.
@echo    Вы также можете запретить шлему подключаться по MTP. Для этого зайдите в %_fYellow%Настройки%_fBYellow% шлема,
@echo    раздел %_fYellow%Дополнительно%_fBYellow% и включите рычажок %_fYellow%Включить настройки разработчика%_fBYellow%. Затем отключите
@echo    рычажок %_fYellow%Уведомление MTP%_fBYellow% и перезагрузите шлем. После перезагрузки и подключения кабеля к ПК,
@echo    шлем не должен отображаться в Мой компьютер и ADB станет доступен.
@echo    Если это не помогает и шлем подключается по MTP, сбросьте его до заводских настроек.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       =========================================================================
rem @echo       ^|     %_fBCyan%            ++++ Headset connected via %_fCyan%MTP%_fBCyan% +++++%_fReset%                  ^|
rem @echo       ^|%_fBCyan%       Because of this, it may not be visible on the PC via %_fCyan%ADB%_fReset%        ^|
rem @echo       ^|                %_fBGreen%Carefully read everything written below  %_fReset%              ^|
rem @echo       =========================================================================
rem @echo.
rem @echo.
rem @echo   %_fBYellow% Most likely this happened when you clicked in the headset 
rem @echo    on the window or on such a notification:
rem @echo.
rem @echo        %_fYellow%USB device detected. 
rem @echo        Tap this notification to get access to the files.%_fReset%
rem @echo.
rem @echo    %_fBYellow%To restore ADB access (qLoader, Quas, SideQuest), restart the headset.
rem @echo    After reboot do not tap this notification if you want to keep ADB access.
rem @echo    Use MTP connection only if you really need direct access
rem @echo    to the headset folders from Windows Explorer.%_fReset%
rem @echo.
rem @echo    %_fBYellow%You can also prevent the headset from connecting via MTP. To do this, go to %_fYellow%Settings%_fBYellow%
rem @echo    on the headset, the %_fYellow%Advanced%_fBYellow% section and enable the %_fYellow%Enable developer settings%_fBYellow% toggle.
rem @echo    Then disable the %_fYellow%MTP Notification%_fBYellow% toggle and restart the headset.
rem @echo    After rebooting and connecting the cable to the PC, the headset should not appear
rem @echo    in My Computer and ADB will become available.
rem @echo    If this does not help and the headset still connects via MTP, reset it to factory settings.%_fReset%
rem EndEngTextBlock
call :_RunMenuNoDeviceCall
@echo.
@echo.
call :_MenuChoiceEnter
if not defined choice goto _HasMTPMode
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
if /i "%choice%"=="k" (goto _DiagnosticInformationSendComplex)
goto _HasMTPMode



:_NOTFOUND
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       ==============================================================
@echo       ^|     %_fBlack%%_fBRed%         +++++   Шлем не найден   +++++           %_fReset%     ^|
@echo       ==============================================================
@echo.
@echo.
@echo       %_fBlack%%_fBBlue%Возможные решения:%_fBlack%
@echo.
@echo      %_fBlack%%_fBYellow% - подключите кабель от шлема к ПК в задний USB порт компьютера
@echo       - проверьте работоспособность кабеля или поменяйте на другой
@echo       - откройте Диспетчер устройств и посмотрите, есть ли там устройство XSRP или Quest%_fReset%
@echo.
@echo.
@echo.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       ==============================================================
rem @echo       ^|     %_fBlack%%_fBRed%         +++++   Headset Not Found   +++++           %_fReset%     ^|
rem @echo       ==============================================================
rem @echo.
rem @echo.
rem @echo       %_fBlack%%_fBBlue%Possible Solutions:%_fBlack%
rem @echo.
rem @echo      %_fBlack%%_fBYellow% - connect the headset to the PC using a rear USB port
rem @echo       - check if the cable is working or try a different one
rem @echo       - open Device Manager and check if there's a device named XSRP or Quest%_fReset%
rem EndEngTextBlock
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
@goto _exitout

:_noadb
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo               %_fBRed%+++++ Шлем найден, но Режим разработчика не включен! +++++%_fReset%
@echo.
@echo.
@echo.
@echo      %_fBYellow%Проверьте, включен ли рычажок %_fBlack%%_fBBlue%Режим разработчика %_fBYellow%в мобильном приложении Meta Horizon.
@echo.
@echo      Если включен, попробуйте его выключить и снова включить, а также перезагрузить шлем.
@echo      Можете также перезагрузить ПК, если это сообщение появилось после установки драйверов%_fReset%.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBlack%%_fBRed%+++++ Headset detected, but Developer Mode is not enabled! +++++%_fReset%
rem @echo.
rem @echo          %_fBlack%%_fBYellow%Please check if the %_fBlack%%_fBBlue%Developer Mode%_fReset% toggle is turned on
rem @echo          %_fBlack%%_fBYellow%in the Meta Horizon mobile app%_fReset%
rem EndEngTextBlock
@echo.
@echo.
@goto _RunMenuNoDevice

:_tk
@taskkill /IM adb.exe /F 2>nul 1>nul
@exit

:_erlvl
IF %ERRORLEVEL% NEQ 1 goto _erlvlnot
@echo.
@echo =====================================================================
rem StartRusTextBlock
@echo              %_fBRed%+++ Ошибка, что-то пошло не так +++%_fReset%
@echo  На всякий случай проверьте соединение со шлемом и Режим разработчика 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo              +++ Error, something went wrong +++
rem @echo  Check the connection to the headset and the Developer Mode just in case
rem EndEngTextBlock
@echo =====================================================================
goto _returnmenu
:_erlvlnot
exit /b
goto _returnmenu

:_loadfwerror
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fBRed%+++++ Не удалось загрузить прошивку! +++++%_fReset%
@echo.
@echo.
@echo.
@echo  Проверьте кабельное соединение, 
@echo  правильность установки драйверов
@echo  и режим шлема (пункт 4 в Главном меню)
@echo  Затем перезапустите эту программу снова.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++ Firmware failed to load! +++++
rem @echo.
rem @echo.
rem @echo.
rem @echo     +++++ Check the cable connection, 
rem @echo     driver installation correctness
rem @echo     and the headset mode (item 4 in the Main menu)
rem @echo     Then restart this program again.
rem EndEngTextBlock
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
@goto _exitout

:_RunMenuNoDevice
@echo.
rem StartRusTextBlock
@echo       Вы можете запустить программу, но некоторые функции работать не будут
@echo       из-за отсутствия подключения. В этом случае вы увидите сообщения:
@echo.
@echo   %_fBRed%"adb.exe: no devices/emulators found"%_fReset% или %_fBRed%"Ошибка. Проверьте соединение со шлемом"%_fReset%
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     %_fBYellow%S.  Запустить без информационной таблицы%_fReset%
@echo     T.  Запустить с таблицей
@echo     D.  Открыть Диспетчер устройств
@echo     K.  Собрать и отправить диагностические данные
@echo     %_fBGreen%I.  Запустить интерактивный тест подключения шлема к ПК%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++ However, you can run the program,
rem @echo     but some features will not work.
rem @echo     In this case you will see the message
rem @echo.
rem @echo     "adb.exe: no devices/emulators found" 
rem @echo     or 
rem @echo     "Error. Check the connection to the headset"
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What should we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Run without information table
rem @echo     T.  Run with table
rem @echo     D.  Open Device Manager
rem @echo     K.  Collect and send diagnostic data
rem @echo     I.  Run Interactive test of connecting the headset to the PC
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _RunMenuNoDevice
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
if /i "%choice%"=="i" (GOTO :_interacttestconnect)

if "%choice%"=="k" (goto _DiagnosticInformationSendComplex)
@cls
call :_cdc
goto _RunMenuNoDevice


:_RunMenuNoDeviceCall
@echo.
rem StartRusTextBlock
@echo       Тем не менее, вы можете запустить программу,
@echo       но некоторые функции работать не будут.
@echo       В этом случае вы увидите сообщение
@echo.
@echo       "adb.exe: no devices/emulators found" 
@echo         или 
@echo       "Ошибка. Проверьте соединение со шлемом"
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить без информационной таблицы
@echo     T.  Запустить с таблицей
@echo     D.  Открыть Диспетчер устройств
@echo     K.  Собрать и отправить диагностические данные
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++++ However, you can run the program,
rem @echo     but some features will not work.
rem @echo     In this case you will see the message
rem @echo.
rem @echo     "adb.exe: no devices/emulators found" 
rem @echo     or 
rem @echo     "Error. Check the connection to the headset"
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What should we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Run without information table
rem @echo     T.  Run with table
rem @echo     D.  Open Device Manager
rem @echo     K.  Collect and send diagnostic data
rem EndEngTextBlock
exit /b


:_DoubleConnect
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     ++++ Множественные подключения^! ++++
@echo.
@echo.
@echo   Список подключений:
@echo.
call :_ListConnections
@echo.
@echo.
@echo  Шлем подключен по кабелю и беспроводу одновременно.
@echo  Это может вызвать ошибку "error: more than one device/emulator" 
@echo. Лучше оставить какое-нибудь одно из подключений.
@echo.
@echo   Тем не менее, вы можете запустить программу,
@echo   но некоторые функции работать не будут.
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить без информационной таблицы
@echo     T.  Запустить с таблицей
@echo     R.  Отключить беспроводные соединения
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     ++++ Multiple connections^! ++++
rem @echo.
rem @echo.
rem setlocal enabledelayedexpansion
rem @echo   Connections list:
rem @echo.
rem call :_ListConnections
rem @echo.
rem @echo  The headset is connected via cable and Wi-Fi at the same time.
rem @echo  This can cause the error "error: more than one device/emulator"
rem @echo. It is better to leave just one of the connections.
rem @echo.
rem @echo   Nevertheless, you can run the program,
rem @echo   but some functions will not work.
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What will we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Start without the information table
rem @echo     T.  Start with the table
rem @echo     R.  Disconnect the ADB connection via WiFi
rem EndEngTextBlock
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _DoubleConnect
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
if /i "%choice%"=="r" (goto _reconnect)
goto _DoubleConnect

:_ListConnections
setlocal enabledelayedexpansion
FOR /F "skip=1 tokens=*" %%a IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO (
set adbdevices=%%a
@echo      !adbdevices!
)
endlocal
exit /b

:_WiFiConnected
call :_CurrentStatusOffline
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fBCyan%+++ Шлем подключен по WiFi +++%_fReset%
@echo.
@echo.
@echo.  
@echo  Взаимодействие со шлемом по WiFi не гарантирует
@echo  полную работоспособность программы.
@echo.
@echo  Могут не работать или работать неправильно
@echo  некоторые функции.
@echo.
@echo ---------------------------------------------------
@echo     %_fBGreen%= Текущий статус шлема%_fReset%	: %currstatus%
@echo.
@echo  %_fBYellow%%presspowerbutton%%_fReset%
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить без информационной таблицы
@echo     T.  Запустить с таблицей
@echo.
@echo   По нажатию Enter программа запустится без таблицы.
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     %_fBCyan%+++ Headset connected via WiFi +++%_fReset%
rem @echo.
rem @echo.
rem @echo.  
rem @echo  Interaction with the headset via WiFi does not guarantee
rem @echo  the full functionality of the program.
rem @echo.
rem @echo  Some functions may not work or work incorrectly.
rem @echo.
rem @echo ---------------------------------------------------
rem @echo     %_fBGreen%= Headset current status%_fReset%	: %currstatus%
rem @echo.
rem @echo  %_fBYellow%%presspowerbutton%%_fReset%
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What will we do?
rem @echo.
rem @echo     0.  Exit from the program
rem @echo     S.  Run without an information table
rem @echo     T.  Run with a table
rem @echo.
rem @echo   Press Enter to start the program without a table.
rem EndEngTextBlock
@echo.
@set "choice=s"
call :_MenuChoiceEnterDef
@echo.
if not defined choice goto _WiFiConnected
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (cls && GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
::if /i "%choice%"=="s" (exit /b)
cls
goto _WiFiConnected

:_CurrentStatusOffline
@%MYFILES%\adb devices | findstr /i /c:"offline" 1>nul 2>nul
@If %ERRORLEVEL%==0 (
set currstatus=%_fBlack%%_fBRed%Offline%_fReset%
rem StartRusTextBlock
set "presspowerbutton=Попробуйте нажать на шлеме кнопку Питание и перезапустите программу"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "presspowerbutton=Try pressing the Power button on the headset and restart the program"
rem EndEngTextBlock
) else (
set currstatus=%_fBlack%%_fBGreen%Online%_fReset%
)
exit /b

:_NoDriversInstalled
cls
call :_hat
rem @echo.
@echo.
@echo.
rem StartRusTextBlock
@echo       ==============================================================
@echo       ^|     %_fBRed%+++ Шлем подключен,но драйверы не установлены  +++%_fReset%     ^|
@echo       ==============================================================
@echo.
@echo      %_fBYellow%По этой же причине программа %_fYellow%qLoader%_fBYellow% может не обнаруживать ваш шлем.%_fReset%
@echo.
@echo      %_fBYellow%Установите драйверы, воспользовавшись меню чуть ниже. Вам нужен пункт %_fBGreen%I зеленого цвета.
@echo      %_fBYellow%Введите I и подтвердите клавишей Enter, после этого начнется установка драйверов.%_fReset%
@echo.
@echo      %_fBYellow%Если после установки драйверов и перезапуска Quas по-прежнему пишет о том, что драйверы
@echo      не установлены, используйте пункт меню %_fBBlue%J синего цвета.%_fReset%
@echo.
@echo.     %_fBRed%ДЛЯ УСТАНОВКИ ДРАЙВЕРОВ ТРЕБУЮТСЯ ПРАВА АДМИНИСТРАТОРА!%_fReset%
@echo.
@echo        Вы можете запустить программу не устанавливая драйверы,
@echo        но некоторые функции работать не будут.
@echo.
@echo        В этом случае вы увидите сообщение
@echo.
@echo        "adb.exe: no devices/emulators found" 
@echo         или 
@echo        "Ошибка. Проверьте соединение со шлемом"
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить без информационной таблицы
@echo     T.  Запустить с таблицей
@echo     D.  Открыть Диспетчер устройств
@echo     %_fBlack%%_fBGreen%I.  Установить драйверы%_fReset%
@echo     %_fBlack%%_fBBlue%J.  Установить новые драйверы%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       ==============================================================
rem @echo       ^|     %_fBRed%+++ Headset connected, but drivers are not installed +++%_fReset%     ^|
rem @echo       ==============================================================
rem @echo.
rem @echo      %_fBYellow%Install the drivers using the menu below. You need the %_fBGreen%green I option.
rem @echo      %_fBYellow%Type I and press Enter to begin the driver installation.%_fReset%
rem @echo.
rem @echo      %_fBYellow%If after installing the drivers and restarting Quas it still reports that the drivers
rem @echo      are not installed, use the menu item %_fBBlue%J in blue color.%_fReset%
rem @echo.
rem @echo.     %_fBRed%ADMINISTRATOR RIGHTS ARE REQUIRED TO INSTALL DRIVERS!%_fReset%
rem @echo.
rem @echo     +++++ However, you can run the program,
rem @echo     but some features will not work.
rem @echo     In this case you will see the message
rem @echo.
rem @echo     "adb.exe: no devices/emulators found" 
rem @echo     or 
rem @echo     "Error. Check the connection to the headset"
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What should we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Run without information table
rem @echo     T.  Run with table
rem @echo     D.  Open Device Manager
rem @echo     %_fBGreen%I.  Install drivers%_fReset%
rem @echo     %_fBBlue%J.  Install new drivers%_fReset%
rem EndEngTextBlock
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _NoDriversInstalled
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
if /i "%choice%"=="i" (GOTO _setdriversmh172)
if /i "%choice%"=="j" (GOTO _setdriversmh177)
@cls
goto :_NoDriversInstalled

:_NotSupported
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo     %_fYellow%+++ Подключенное утройство не выглядит как Meta Quest  +++%_fReset%
@echo.
@echo         Оно больше похоже на %_fCyan%%manuf% %prodname% %prodmodel%%_fReset%
@echo         Поэтому поддерживается лишь частично.
@echo.  
@echo.
@echo   Тем не менее, вы можете запустить программу, но некоторые функции работать не будут.
@echo   В этом случае вы увидите сообщение об ошибке обработки команд или просто "Ошибка!"
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить программу
@echo     D.  Открыть Диспетчер устройств
@echo.
@set "choice="
@Set /p choice="Выберите пункт меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo     +++ Connected device does not look like a headset +++
rem @echo.
rem @echo         It looks more like %manuf% %prodname% %prodmodel%
rem @echo         Therefore, it is only partially supported.
rem @echo.
rem @echo.
rem @echo   Nevertheless, you can run the program, but some functions will not work.
rem @echo   In this case, you will see a command processing error message or just "Error!"
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What shall we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Run the program
rem @echo     D.  Open Device Manager
rem @echo.
rem @set "choice="
rem @Set /p choice="Select a menu item and press Enter: "
rem EndEngTextBlock
@echo.
if not defined choice goto _NotSupported
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
@cls
goto _NotSupported

:_EDLModeMessage
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo           +++ Шлем находится в режиме EDL  +++
@echo.
@echo    Это специальный режим аварийной прошивки Emergency Download Mode,    
@echo    встроенный в процессоры Qualcomm, но для шлема он бесполезен.  
@echo.   
@echo   Если вы в этом режиме не намеренно, выйдите из него долгим нажатием кнопки Питание.
@echo   Также, возможно вам придетсся обратиться в специализироованный сервис-центр.
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить программу
@echo     D.  Открыть Диспетчер устройств
@echo.
@set "choice="
@Set /p choice="Выберите пункт меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo           +++ The headset is in EDL mode  +++
rem @echo.
rem @echo    This is a special Emergency Download Mode,    
rem @echo    built into Qualcomm processors, but it is useless for the headset.  
rem @echo.   
rem @echo   If you are in this mode unintentionally, exit by holding down the Power button.
rem @echo   You may also need to contact a specialized service center.
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What shall we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Run the program
rem @echo     D.  Open Device Manager
rem @echo.
rem @set "choice="
rem @Set /p choice="Select a menu item and press Enter: "
rem EndEngTextBlock
@echo.
if not defined choice goto _EDLModeMessage
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
@cls
goto _EDLModeMessage

:_PoweredOffMessage
cls
call :_hat
@echo.
@echo.
@echo.
rem StartRusTextBlock
@echo        +++ Шлем подсоединен, но выключен  +++
@echo.
@echo.
@echo ---------------------------------------------------
@echo.
@echo  Как поступим?
@echo.
@echo     0.  Выход из программы
@echo     S.  Запустить программу
@echo     D.  Открыть Диспетчер устройств
@echo.
@set "choice="
@Set /p choice="Выберите пункт меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    +++ The headset is connected but turned off +++
rem @echo.
rem @echo.
rem @echo ---------------------------------------------------
rem @echo.
rem @echo  What shall we do?
rem @echo.
rem @echo     0.  Exit the program
rem @echo     S.  Run the program
rem @echo     D.  Open Device Manager
rem @echo.
rem @set "choice="
rem @Set /p choice="Select a menu item and press Enter: "
rem EndEngTextBlock
@echo.
if not defined choice goto _PoweredOffMessage
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
@cls
goto _PoweredOffMessage

:_tabGeneral
@%verbecho%
@SetLocal EnableDelayedExpansion

:_tabSysFilesVersion
for /f "tokens=10 delims=|" %%a in ('%MYFILES%\adb.exe shell dumpsys DumpsysProxy OculusUpdater ^| findstr /i /c:"Oculus Core Mobile Services"') do (
rem set ocmsn=%%b
set ocmsc=%%a
set sfn=!ocmsc:~1,4!
)
rem set sfn=
if not defined sfn set "sfn=   %_fBYellow%0%_fReset%"

:_tabSizeCheck
@For /F "skip=1 tokens=2,3,4,5" %%a In ('%MYFILES%\adb shell df -h /sdcard/') Do (
cls
@set aa=%%a
@set bb=%%b
@set cc=%%c
@set dd=%%d
set sz=Gb
)
::@set aa=
::@set bb=
::@set cc=
::@set dd=
::set sz=-
if [%aa%]==[] @set aa=------
if [%bb%]==[] @set bb=------
if [%cc%]==[] @set cc=------
if [%dd%]==[] @set dd=-----
::if [%aa%]==[] @set sz=-

::>>>>>>>
rem call :_tabModel
call :_setfwtxt
::>>>>>>>

:_tabSN
@For /F %%r In ('%MYFILES%\adb shell getprop ro.boot.serialno 2^<nul') Do set sn=%%r
cls
::set sn=
if [%sn%]==[] set sn=---------------------
:_tebDatetime
@For /F %%q In ('@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S" 2^<nul') Do set qdt=%%q
call :_settime

cls
::set qdt=
if [%qdt%]==[] set qdt=---------------------
if [%qdt:~0,-4%]==[%dppt:~0,-4%] (set qdt=%_fBGreen%%qdt%%_fReset%) else (set set qdt=%_fBRed%%qdt%%_fReset%)

:_tabIP
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 2^<nul ^|findstr /i /c:"inet "') DO set ipfull=%%G
cls
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO set ip=%%G

@if [%ip%]==[] set ip=-------------

:_tabConnectType
rem @set /a connectsum=%cableconnect%+%wificheck%
@IF [%connectsum%] EQU [2] set "ctype=%_fBRed%Double%_fReset%  " & goto _tabFWdltable
@%MYFILES%\adb devices 2>NUL | findstr offline 2>nul 1>nul
@IF %errorlevel% EQU 0 set ctype=%_fBlack%%_fBRed%Offline%_fReset% & goto _tabFWdltable
@%MYFILES%\adb devices 2>NUL | findstr ":" 2>nul 1>nul
@IF %errorlevel% EQU 0 set "ctype=%_fYellow%Wi-Fi%_fReset%   "& goto _tabFWdltable
@FOR /F "skip=1 tokens=1" %%j IN ('%MYFILES%\adb devices 2^<nul') DO set sernum=%%j
cls
@if [%sernum%] NEQ [] set "ctype=%_fBGreen%Cable%_fReset%   "& goto _tabFWdltable

@set "ctype=-----   "

:_tabFWdltable
:_ExtractFirmwareVersion
@echo.
rem StartRusTextBlock
@echo Секунду, подготавливаем табличку....
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  Wait a second, preparing the table....
rem EndEngTextBlock
call :_hsfwversionextract
if [%hsversion%]==[] (set fwnumb=-------------) else (set fwnumb=%hsversion%)
if [%hsenvironment%]==[] (set fwsys=---------------------) else (set fwsys=%hsenvironment%)

:_teabCheckAdmin
rem @reg query "HKU\S-1-5-19" >NUL 2>&1 && (set adminaccess=Ну а то) || (set adminaccess=Не в этот раз)

rem StartRusTextBlock
@reg query "HKU\S-1-5-19" >NUL 2>&1 && (set adminaccess=%_fBGreen%Ну а то%_fReset%) || (set adminaccess=%_fBYellow%Не в этот раз%_fReset%)
rem EndRusTextBlock
rem StartEngTextBlock
rem @reg query "HKU\S-1-5-19" >NUL 2>&1 && (set adminaccess=%_fBGreen%Of coz%_fReset%) || (set adminaccess=%_fBYellow%Not this time%_fReset%)
rem EndEngTextBlock
call :_CheckEnvVarTemp
call :_BatteryStatsCheck
rem call :_setfwtxt
call :_UpdateStatus
call :_hat

rem for /f "tokens=* delims=" %%L in ('adb shell dumpsys OVRRemoteService ^| findstr /i /c:"Paired device:"') do (
rem     set "line=%%L"
rem     for /f "tokens=5,15 delims=, " %%a in ("!line!") do (
rem         set "Type=%%a"
rem         set "Battery=%%b"
rem     )
rem     if /i "!Type!"=="Left" (
rem         set "touchbatl=!Battery!"
rem     ) else if /i "!Type!"=="Right" (
rem         set "touchbatr=!Battery!"
rem     )
rem )


if %batlevel% LEQ 15 (
set "colorbat=%_fBRed%%batlevel%%%%_fReset%"
) else (
if %batlevel% LEQ 50 (
set "colorbat=%_fBYellow%%batlevel%%%%_fReset%"
) else (
set "colorbat=%_fBGreen%%batlevel%%%%_fReset%"
)
)


if %dd% GEQ 90 (
set "dc=%_fBRed%%dd%%_fReset%"
) else (
if %dd% GEQ 50 (
set "dc=%_fBYellow%%dd%%_fReset%"
) else (
set "dc=%_fBGreen%%dd%%_fReset%"
)
)


call :_ControllersInfoPS
rem pause
call :_ControllersColorBat

rem echo !LeftColor!
rem pause


rem if LeftColor not defined (if
rem set "ControllersStatus=Отключены"
rem set "ControllersStatus=Disabled"
rem ) else (
rem set "ControllersStatus=%_fCyan%L%_fReset%:%LeftColor%  %_fCyan%R%_fReset%:%RightColor%%_fReset%"
rem )
rem rem StartRusTextBlock
rem rem if not defined TrackingStatus set LeftColor=%_fBYellow%Откл%_fReset%&&set RightColor=%_fBYellow%Откл%_fReset%
rem rem if not defined RightColor set RightColor=%_fBYellow%Откл%_fReset%
rem rem EndRusTextBlock
rem rem StartEngTextBlock
rem rem if not defined LeftColor set LeftColor=%_fBYellow%Off%_fReset%
rem rem if not defined RightColor set RightColor=%_fBYellow%Off%_fReset%
rem rem EndEngTextBlock


rem set RightColor=%_fBYellow%Откл%_fReset%
rem set LeftColor=%_fBYellow%Откл%_fReset%

rem Таблица

rem set "DevModelNm=Meta Quest 3S Xbox"

rem @echo  %_fCyan%Прошивка%_fReset%	: %_fBCyan%%fwnumb% (%sfn%)%_fReset%	^| %_fCyan%Заполнено%_fReset%   : !dc!	^| %_fCyan%Заряд%_fReset%		: %_fBCyan%99%%%_fReset%F %_fBCyan%L%_fReset%30%%%_fReset% %_fBCyan%R%_fReset%60%%%_fReset%
rem StartRusTextBlock
@echo  %_fCyan%Дата в шлеме%_fReset%	: %qdt%	^| %_fCyan%Общий объем%_fReset% : %_fBCyan%!aa:~,-1!!sz!%_fReset%	^| %_fCyan%Емкость акк.%_fReset%	: %_fBCyan%%opcouprom% %mahh%%_fReset%
@echo  %_fCyan%Серийный номер%_fReset%	: %_fBCyan%%sn%%_fReset%	^| %_fCyan%Занято%_fReset%      : %_fBCyan%!bb:~,-1!!sz!%_fReset%	^| %_fCyan%Потеряно емк.%_fReset%	: %_fBCyan%%izgcou% %mahh%%_fReset%
@echo  %_fCyan%Верcия системы%_fReset%	: %_fBCyan%%fwsys%%_fReset%	^| %_fCyan%Свободно%_fReset%    : %_fBCyan%!cc:~,-1!!sz!%_fReset%	^| %_fCyan%Деградация%_fReset%	: %_fBCyan%%degostcou%%pr%%_fReset%
@echo  %_fCyan%Прошивка%_fReset%	: %_fBCyan%%fwnumb% (%sfn%%_fBCyan%)%_fReset%	^| %_fCyan%Заполнено%_fReset%   : !dc!	^| %_fCyan%Заряд%_fReset%		: %colorbat%%batinfo%
@echo  %_fCyan%IP шлема%_fReset%	: %_fBCyan%%ip%%_fReset%     	^| %_fCyan%Подключение%_fReset% : %ctype%^| %_fCyan%Контроллеры%_fReset%   : %_fCyan%L%_fReset%:%LeftColor%  %_fCyan%R%_fReset%:%RightColor%%_fReset%
@echo  %_fCyan%Модель шлема%_fReset%	: %_fBCyan%%DevModelNm%%_fReset%   	^| %_fCyan%EnvVar TEMP%_fReset% : %evt%	^| %_fCyan%От админа?%_fReset%	: %adminaccess%
@echo  %_fCyan%Драйверы%_fReset%    	: %drvmsg%       	^| reserve     : reserve	^| %_fCyan%Обновления%_fReset%    : %updstatus%


rem EndRusTextBlock

rem @echo  - reserve -	: -------------   	^| - reserve - : -----	^| %_fCyan%Обновления%_fReset%    : %updstatus%


rem @echo  %_fCyan%IP шлема%_fReset%	: %_fBCyan%%ip%%_fReset%     	^| %_fCyan%Подключение%_fReset% : %ctype%^| %_fCyan%От админа?%_fReset%	: %adminaccess%
rem @echo  %_fCyan%Модель шлема%_fReset%	: %_fBCyan%%DevModelNm%%_fReset%   	^| %_fCyan%EnvVar TEMP%_fReset% : %evt%	^| %_fCyan%Обновления%_fReset%    : %updstatus%
rem @echo  %_fCyan%IP шлема%_fReset%	: %_fBCyan%%ip%%_fReset%     	^| %_fCyan%Подключение%_fReset% : %ctype%^| %_fCyan%Контроллеры%_fReset%   : %ControllersStatus%

rem StartEngTextBlock
rem @echo  %_fCyan%Headset date%_fReset%	: %qdt%	^| %_fCyan%Total volume%_fReset%	: %_fBCyan%!aa:~,-1!!sz!%_fReset%	  ^| %_fCyan%Batt capacity%_fReset% : %_fBCyan%%opcouprom%%mahh%%_fReset%
rem @echo  %_fCyan%Serial number%_fReset%	: %_fBCyan%%sn%%_fReset%	^| %_fCyan%Occupied%_fReset%      : %_fBCyan%!bb:~,-1!!sz!%_fReset%   ^| %_fCyan%Lost capacity%_fReset% : %_fBCyan%%izgcou% %mahh%%_fReset%
rem @echo  %_fCyan%System version%_fReset%	: %_fBCyan%%fwsys%%_fReset%	^| %_fCyan%Free space%_fReset%    : %_fBCyan%!cc:~,-1!!sz!%_fReset%   ^| %_fCyan%Degradation%_fReset%	  : %_fBCyan%%degostcou%%pr%%_fReset%
rem @echo  %_fCyan%FW version%_fReset%	: %_fBCyan%%fwnumb% (%sfn%%_fBCyan%)%_fReset%	^| %_fCyan%Filled%_fReset%        : !dc!	  ^| %_fCyan%Charge%_fReset%	  : %colorbat% %batinfo%
rem @echo  %_fCyan%Headset IP%_fReset%	: %_fBCyan%%ip%%_fReset%     	^| %_fCyan%Connection%_fReset% 	: %ctype%^| %_fCyan%Controllers%_fReset%	  : %_fBCyan%L%_fReset%:%LeftColor%  %_fBCyan%R%_fReset%:%RightColor%%_fReset%
rem @echo  %_fCyan%Headset model%_fReset%	: %_fBCyan%%DevModelNm%%_fReset%  	^| %_fCyan%EnvVar TEMP%_fReset%	: %evt% ^| %_fCyan%From admin?%_fReset%	  : %adminaccess%
rem @echo  %_fCyan%Drivers%_fReset%    	: %drvmsg%       	^| reserve       : reserve ^| %_fCyan%Updates%_fReset%	  : %updstatus%
rem EndEngTextBlock

rem @echo  %_fCyan%Headset IP%_fReset%	: %_fBCyan%%ip%%_fReset%     	^| %_fCyan%Connection%_fReset% 	: %ctype%^| %_fCyan%From admin?%_fReset%	  : %adminaccess%
rem @echo  %_fCyan%Headset model%_fReset%	: %_fBCyan%%DevModelNm%%_fReset%  	^| %_fCyan%EnvVar TEMP%_fReset%	: %evt% ^| %_fCyan%Updates%_fReset%	  : %updstatus%
rem @echo  %_fCyan%Headset IP%_fReset%	: %_fBCyan%%ip%%_fReset%     	^| %_fCyan%Connection%_fReset% 	: %ctype%^| %_fCyan%Controllers%_fReset%	: %ControllersStatus%





@echo --------------------------------------------------------------------------------------------------
goto _tabReturn
rem @exit /b

:_CheckEnvVarTemp
set "perc=%%%"
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Environment /v TEMP 2^>nul') do set envvartemp=%%a
rem if /i %envvartemp%==%perc%userprofile%perc%\AppData\Local\Temp (set "evt=Std    ") else (set "evt=Non Std")
if /i %envvartemp%==%perc%userprofile%perc%\AppData\Local\Temp (set "evt=%_fBGreen%Std%_fReset%    ") else (set "evt=%_fBYellow%Non Std%_fReset%")
exit /b

:_UpdateStatus
rem %myfiles%\adb shell pm list packages -d 2>&1 | findstr /i /c:"com.oculus.updater" /c:"com.oculus.nux.ota" 2>&1


%myfiles%\adb shell pm list packages -d 2>&1 | findstr /i /c:"com.oculus.updater" 2>nul 1>nul
rem rem @echo %DevModelNm%

rem if %errorlevel%==1 (set updstatus=Включены) else (set updstatus=Отключены)

rem StartRusTextBlock
if %errorlevel%==1 (set updstatus=%_fBGreen%Включены%_fReset%) else (set updstatus=%_fBYellow%Отключены%_fReset%)
rem EndRusTextBlock
rem StartEngTextBlock
rem if %errorlevel%==1 (set updstatus=%_fBGreen%Enabled%_fReset%) else (set updstatus=%_fBYellow%Disabled%_fReset%)
rem EndEngTextBlock
if %sn%==--------------------- set updstatus=-------- && exit /b
exit /b

rem :_tabModel
call :_setfwtxt
rem exit /b

if %ERRORLEVEL% EQU 1 set uknownmodel=1
rem StartRusTextBlock
set model=Неизвестно
rem EndRusTextBlock
rem StartEngTextBlock
rem set model=Unknown
rem EndEngTextBlock
@exit /b

:_ControllersInfoPS
rem for /f "tokens=* delims=" %%L in ('%myfiles%\adb shell dumpsys OVRRemoteService 2^>nul ^| findstr /i /c:"Paired device:"') do (
rem set "line=%%L"
rem for /f "tokens=5,15 delims=, " %%a in ("!line!") do (
rem set "Type=%%a"
rem set "Battery=%%b"
rem )

for /f "usebackq tokens=1,2 delims==" %%A in (`powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$adbOutput = & %myfiles%\adb shell dumpsys OVRRemoteService 2>$null;" ^
    "foreach ($line in $adbOutput -split '`n') {" ^
    "    if ($line -match 'Paired device:') {" ^
    "        $fields = @{};" ^
    "        foreach ($pair in ($line -split ',\s*')) {" ^
    "            if ($pair -match '^(?<k>[^:]+):\s*(?<v>.*)$') {" ^
    "                $k=$matches.k.Trim();" ^
    "                $v=$matches.v.Trim();" ^
    "                if (-not $v) { $v='—' };" ^
    "                $fields[$k]=$v" ^
    "            }" ^
    "        }" ^
    "        $index = switch ($fields['Type']) { 'Left' {'L'} 'Right' {'R'} default {'_' + ($fields.Count + 1)} };" ^
    "        foreach ($key in $fields.Keys) { Write-Output ($key + '_' + $index + '=' + $fields[$key]) }" ^
    "    }" ^
    "}"`) do (
        set "%%A=%%B"
)
exit /b


rem === Вывод всех переменных для проверки ===
rem echo -------------------- Контроллеры --------------------
rem echo Left controller:
rem echo Paired device:  %Paired device_L%
rem echo Type:           %Type_L%
rem echo Model:          %Model_L%
rem echo HardwareRev:    %HardwareRev_L%
rem echo Firmware:       %Firmware_L%
rem echo ImuModel:       %ImuModel_L%
rem echo Battery:        %Battery_L%
rem echo isAttached:     %isAttached_L%
rem echo Status:         %Status_L%
rem echo ExternalStatus: %ExternalStatus_L%
rem echo TrackingStatus: %TrackingStatus_L%
rem echo BrightnessLevel:%BrightnessLevel_L%
rem echo.
rem echo Right controller:
rem echo Paired device:  %Paired device_R%
rem echo Type:           %Type_R%
rem echo Model:          %Model_R%
rem echo HardwareRev:    %HardwareRev_R%
rem echo Firmware:       %Firmware_R%
rem echo ImuModel:       %ImuModel_R%
rem echo Battery:        %Battery_R%
rem echo isAttached:     %isAttached_R%
rem echo Status:         %Status_R%
rem echo ExternalStatus: %ExternalStatus_R%
rem echo TrackingStatus: %TrackingStatus_R%
rem echo BrightnessLevel:%BrightnessLevel_R%
rem echo -------------------------------------------------------



:_ControllersColorBat
rem if /i "!Type_L!"=="Left" (

set "LeftBattery=!Battery_L!"
rem === Цвет для левого контроллера ===

if !LeftBattery! LEQ 15 (
set "LeftColor=!_fBRed!!LeftBattery!!%_fReset%"
) else (
if !LeftBattery! LEQ 50 (
set "LeftColor=!_fBYellow!!LeftBattery!!%_fReset%"
) else (
set "LeftColor=!_fBGreen!!LeftBattery!!%_fReset%"
)
)


rem ) else if /i "!Type_R!"=="Right" (
set "RightBattery=!Battery_R!"
rem === Цвет для правого контроллера ===
if !RightBattery! LEQ 15 (
set "RightColor=!_fBRed!!RightBattery!!%_fReset%"
) else (
if !RightBattery! LEQ 50 (
set "RightColor=!_fBYellow!!RightBattery!!%_fReset%"
) else (
set "RightColor=!_fBGreen!!RightBattery!!%_fReset%"
)
)
exit /b




rem >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

rem :_BattseryStatTab
rem call :_hat
rem @echo.
rem @echo.
rem @echo.


:_BattseryStatTab
cls
rem call :_hat
call :_BatteryStatsCheck
call :_BattHealthLevel
@echo.
rem @echo. %biggernominal%
@echo  -----------------------------------------------------------------------------------------------
rem StartRusTextBlock
@echo  		^| Остаточная емкость	^| Потеряно емкости	^| Деградация батареи	^|
@echo  -----------------------------------------------------------------------------------------
@echo  Оценочная	^|   %batestimated%%mahe%		^|   %lostestimated%%mahp%		^|    %degostestimated%%pre%		^|
@echo  Рассчитанная	^|   %opcouprom%%mahh%		^|   %izgcou%%mahh%		^|    %degostcou%%pr%		^|
@echo  -----------------------------------------------------------------------------------------
@echo.
@echo  Оценочная емкость		: %batestimated% mAh
@echo  Последняя изученная емкость	: %batlearned% mAh
@echo  Минимальная изученная емкость	: %minbatlearned% mAh
@echo  Максимальная изученная емкость	: %maxbatlearned% mAh
@echo  Текущий заряд шлема		: %batlevel%%pr%
@echo.
@echo  Статус батареи			: %batstatus%
@echo  Здоровье батареи		: %bathealth%
@echo.
@echo  Штатная емкость батареи	: %batfull% mAh
@echo  ===========================================
@echo.
@echo  ПОЯСНЕНИЕ ПО ЗНАЧЕНИЯМ:
@echo.
@echo  Потеряно емкости	- емкость, потерянная батареей за время использования шлема
@echo                       	  [штатная емкость минус статистическая или рассчитанная]
@echo.
@echo  Остаточная емкость	- текущая емкость батареи
@echo.                      	  [штатная емкость минус потеряно]
@echo.
@echo  Деградация батареи	- процент того, насколько уменьшилась емкость батареи
@echo                       	  [сто минус соотношение штатной емкости к остаточной]
@echo.
@echo  Штатная емкость	- начальная емкость нового аккумулятора по спецификации
@echo.
@echo  Оценочная емкость	- показатель, рассчитанный по сложному алгоритму, включающему в себя
@echo				  диаграмму состояний, среднюю молщность для каждого из них,
@echo				  средний ток, время резервного питания, коэффициент деградации и т.д.
@echo				  КОРОЧЕ, ЭТО НАИБОЛЕЕ ВАЖНЫЙ ПАРАМЕТР. Хотя иногда он кривой.
@echo			     	  Расчитан на основе статистики с момента последней зарядки.
@echo				  [если значение емкости выше штатного, в этой строке будут прочерки]
@echo.
@echo  Рассчитанная		- Расчет на основе текущего состояния батареи
@echo.
@echo  Изученная емкость	- Последняя/Минимальная/Максимальная.
@echo				  Совершенно бестолковые параметры, 
@echo				  но с ними список выглядит внушительней
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo                     ^|  Residual capacity	^|  Lost capacity	^|  Battery degradation
rem @echo  -----------------------------------------------------------------------------------------------
rem @echo  Estimated          ^|  %batestimated%%mahe%			^|  %lostestimated%%mahp%		^|  %degostestimated%%pre%
rem @echo  Calculated         ^|  %opcouprom%%mahh%			^|  %izgcou%%mahh%		^|  %degostcou%%pr%
rem @echo  -----------------------------------------------------------------------------------------------
rem @echo.
rem @echo  Estimated capacity          : %batestimated% mAh
rem @echo  Last learned capacity       : %batlearned% mAh
rem @echo  Min learned capacity        : %minbatlearned% mAh
rem @echo  Max learned capacity        : %maxbatlearned% mAh
rem @echo  Current charge              : %batlevel%%pr%
rem @echo.
rem @echo  Battery status              : %batstatus%
rem @echo  Battery health              : %bathealth%
rem @echo.
rem @echo  Standard battery capacity   : %batfull% mAh
rem @echo  ===========================================
rem @echo.
rem @echo  EXPLANATION OF VALUES:
rem @echo.
rem @echo  Lost capacity       - the capacity lost by the battery over time
rem @echo                          [standard capacity minus statistical or calculated]
rem @echo.
rem @echo  Residual capacity   - the current capacity of the battery
rem @echo.                          [standard capacity minus lost]
rem @echo.
rem @echo  Battery degradation - the percentage by which the battery capacity has decreased
rem @echo                          [one hundred minus the ratio of standard capacity to residual]
rem @echo.
rem @echo  Standard capacity   - the initial capacity of a new battery according to the specification
rem @echo.
rem @echo  Estimated capacity  - a parameter calculated using a complex algorithm, including state diagram,
rem @echo                        average power for each of them, average current, backup power time,
rem @echo                        degradation coefficient, etc. THIS IS THE MOST IMPORTANT PARAMETER.
rem @echo                        Although sometimes it's crooked. Calculated based on statistics 
rem @echo                        since the last charge.
rem @echo                        [if the capacity is higher than standard, there will be dashes in this line]
rem @echo.
rem @echo  Calculated capacity - Calculation based on the current state of the battery
rem @echo.
rem @echo  Learned capacity    - Last/Min/Max. 
rem @echo                        Absolutely useless parameters, but the list looks more impressive with them.
rem EndEngTextBlock
exit /b
::goto _exitout

:_BattHealthLevel
@%MYFILES%\adb shell dumpsys battery >battery.txt
@FOR /F "tokens=2" %%G IN ('findstr /i "health:" battery.txt') DO set health=%%G
@FOR /F "tokens=2" %%G IN ('findstr /i "status:" battery.txt') DO set status=%%G
rem StartRusTextBlock
if %status%==1 set batstatus=Неизвестно
if %status%==2 set batstatus=На зарядке
if %status%==3 set batstatus=Разряжается
if %status%==4 set batstatus=Не на зарядке
if %status%==5 set batstatus=Полностью заряжена
if [%status%]==[] set batstatus=ХЗ
if %health%==1 set bathealth=Неизвестно
if %health%==2 set bathealth=Хорошее
if %health%==3 set bathealth=Перегревается
if %health%==4 set bathealth=Неисправна
if %health%==5 set bathealth=Поревышение напряжения
if %health%==6 set bathealth=Непонятная ошибка
if %health%==7 set bathealth=Слишком низкая температура
if [%health%]==[] set bathealth=ХЗ
rem EndRusTextBlock
rem StartEngTextBlock
rem if %status%==1 set batstatus=Unknown
rem if %status%==2 set batstatus=Charging
rem if %status%==3 set batstatus=Discharging
rem if %status%==4 set batstatus=Not charging
rem if %status%==5 set batstatus=Fully charged
rem if [%status%]==[] set batstatus=Unknown
rem if %health%==1 set bathealth=Unknown
rem if %health%==2 set bathealth=Good
rem if %health%==3 set bathealth=Overheating
rem if %health%==4 set bathealth=Failed
rem if %health%==5 set bathealth=Over-voltage
rem if %health%==6 set bathealth=Unknown error
rem if %health%==7 set bathealth=Too low temperature
rem if [%health%]==[] set bathealth=Unknown
rem EndEngTextBlock
@del battery.txt /q /f
exit /b

:_BatteryStatsCheck
rem set sn=
rem @For /F %%r In ('%MYFILES%\adb shell getprop ro.boot.serialno') Do set sn=%%r
%MYFILES%\adb shell getprop ro.boot.serialno >nul
if %errorlevel%==1 (
cls
call :_EmptyBatParameters
) else (
call :_BatteryStats
)
@exit /b

:_BatteryStats
call :_setfwtxt
rem exit /b
@%MYFILES%\adb shell dumpsys batterystats --charged >charged.txt
for /f "tokens=4" %%a in ('findstr /i /c:"Estimated battery capacity:" charged.txt') do set batestimated=%%a
for /f "tokens=5" %%a in ('findstr /i /c:"Last learned battery capacity:" charged.txt') do set batlearned=%%a
for /f "tokens=5" %%a in ('findstr /i /c:"Min learned battery capacity:" charged.txt') do set minbatlearned=%%a
for /f "tokens=5" %%a in ('findstr /i /c:"Max learned battery capacity:" charged.txt') do set maxbatlearned=%%a

@%MYFILES%\adb shell dumpsys battery >battery.txt

rem @FOR /F "tokens=3" %%G IN ('@%MYFILES%\adb shell dumpsys battery ^| findstr "Charge counter:"') DO set batcounter=%%G
@FOR /F "tokens=3" %%G IN ('findstr /i "Charge counter:" battery.txt') DO set batcounter=%%G
rem @FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb shell dumpsys battery ^| findstr "level:"') DO set batlevel=%%G
@FOR /F "tokens=2" %%G IN ('findstr /i "level:" battery.txt') DO set batlevel=%%G
@FOR /F "tokens=2" %%G IN ('findstr /i "status:" battery.txt') DO set bstatus=%%G
rem StartRusTextBlock

if %bstatus%==2 set "batinfo=%_fGreen%[Зарядка]%_fReset%"
if %bstatus%==3 set "batinfo=%_fYellow%[Разряд]%_fReset%"
if %bstatus%==5 set "batinfo=%_fBGreen%[Полная]%_fReset%"
if %bstatus%==4 set "batinfo=%_fRed%[Нет зарядки]%_fReset%"

rem EndRusTextBlock
rem StartEngTextBlock
rem if %bstatus%==2 set "batinfo=%_fGreen%[Charge]%_fReset%"
rem if %bstatus%==3 set "batinfo=%_fYellow%[Discharg]%_fReset%"
rem if %bstatus%==5 set "batinfo=%_fBGreen%[Full]%_fReset%"
rem if %bstatus%==4 set "batinfo=%_fRed%[No charg]%_fReset%"
rem EndEngTextBlock
@del charged.txt /q /f
@del battery.txt /q /f
rem call :_setfwtxt
rem set /a batfull=3648
rem set /a batfull=3710
rem set /a batfull=5348
rem set /a batfull=5100
::set batestimated=3841
::IF %batestimated% GTR %batfull% goto _EmptyLearnParameters
set /a opestimated=%batestimated%*100
set /a ostestimated=%opestimated%/%batfull%
set /a degostestimated=100-%ostestimated%
set /a lostestimated=%batfull%-%batestimated%
set mahe=mAh
set mahp=mAh
set pre=%%%
rem StartRusTextBlock
if not defined degostestimated set "degostestimated=Не определена"&&set pr=&&exit /b
if %degostestimated% LEQ 0 set "degostestimated=Отсутствует"&&set pr=
rem EndRusTextBlock
rem StartEngTextBlock
rem if %degostestimated% LEQ 0 set "degostestimated=No degradation"&&set pr=
rem if not defined degostestimated set "degostestimated=Not defined"&&set pr=&&exit /b
rem EndEngTextBlock

:: ------------------------------

:_Count
::call :_EmptyLearnParameters
set /a batcount=%batcounter:~0,4%/%batlevel%
set /a opcouprom=%batcount%*100
set /a opcoupromfull=%opcouprom%*100
set /a opcou=%opcoupromfull%/%batfull%
set /a degostcou=100-%opcou%
set /a izgcou=%batfull%-%opcouprom%
set mahh=mAh
set pr=%%%
rem set degostcou=
rem StartRusTextBlock
if not defined degostcou set "degostcou=Не определена"&&set pr=&&exit /b
if %degostcou% LEQ 0 set "degostcou=Отсутствует"&&set pr=
rem EndRusTextBlock
rem StartEngTextBlock
rem if %degostcou% LEQ 0 set "degostcou=No degradation"&&set pr=
rem if not defined degostcou set "degostcou=Not defined"&&set pr=&&exit /b
rem EndEngTextBlock
@exit /b

:_EmptyBatParameters
set mahh=
set mahl=
set mahp=
set batestimated=
set opcouprom=
set lostestimated=
set izgcou=
set degostestimated
set degostcou=
set batlevel=
set mahh=---
set mahe=---
set mahp=---
set opcouprom=-----
set izgcou=-----
set degostcou=-------
set batlevel=--------
set sn=---------------------
set pr=-
set lostestimated=-----
set batestimated=-----
set degostestimated=-------
exit /b


:_EmptyLearnParameters
set lostestimated=-----
::set batestimated=-----
set degostestimated=-------
set mahe=mAh
set mahp=---
set pre=-
rem StartRusTextBlock
set biggernominal=+++++ Оценочная емкость больше номинала! Такое бывает. Глюк-с +++++
rem EndRusTextBlock
rem StartEngTextBlock
rem set biggernominal=+++++ Estimated capacity is greater than nominal! This happens. Glitch-s +++++
rem EndEngTextBlock
goto _Count


:_setfwtxt
set IntProductName=
@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.name 2^>nul') do set IntProductName=%%a
if [%IntProductName%]==[] set IntProductName=---------- && set DeviceModelName=-------- && set DevModelNm=-------------&& exit /b
if %IntProductName%==monterey set DevModelNm=Meta Quest 1&& set fmfilename=Q1&& set fwtxt=fw1.txt&& set /a batfull=3648&& set model=Quest 1&& set uknownmodel=0 && exit /b
if %IntProductName%==hollywood set DevModelNm=Meta Quest 2&& set fmfilename=Q2&& set fwtxt=fw2.txt&& set /a batfull=3710&& set model=Quest 2&& set uknownmodel=0 && exit /b
if %IntProductName%==eureka set DevModelNm=Meta Quest 3&& set fmfilename=Q3&& set fwtxt=fw3.txt&& set /a batfull=5100&&  set model=Quest 3&& set uknownmodel=0 && exit /b
if %IntProductName%==seacliff set DevModelNm=Meta Quest Pro&& set fmfilename=QP&& set fwtxt=fwp.txt&& set /a batfull=5348&&  set model=Quest Pro&& set uknownmodel=0 && exit /b
if %IntProductName%==panther set DevModelNm=Meta Quest 3S&& set fmfilename=Q3S&& set fwtxt=fws.txt&& set /a batfull=4324&&  set model=Quest 3S&& set uknownmodel=0 && exit /b
if %IntProductName%==xse_panther set DevModelNm=Meta Quest 3S Xbox&& set fmfilename=Q3S&& set fwtxt=fws.txt&& set /a batfull=4324&&  set model=Quest 3S Xbox&& set uknownmodel=0 && exit /b
rem StartRusTextBlock
set DevModelNm=Неизвестно
set DeviceModelName=Неясно
set model=Неизвестно
rem EndRusTextBlock
rem StartEngTextBlock
rem set DeviceModelName=Unknown
rem set model=Unknown
rem EndEngTextBlock
exit /b


:_packageslistcreate
rem powershell -ExecutionPolicy Bypass -File "%MYFILES%\selector.ps1" "o.txt" "packages-list.txt"
rem pause
@%MYFILES%\adb shell pm list packages %listpackages% >>packages-list-unsorted.txt
@sort packages-list-unsorted.txt > packages-list.txt
exit /b

:_SelectFileFolder
rem set "MODE=folder"
rem set "MODE=file"

rem --- Определяем ключ для PowerShell и заголовок ---
if /I "%pathmode%"=="file" (
    set "PSKEY=-sf"
rem StartRusTextBlock
set "TITLE=Выберите файл"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "TITLE=Select a file"
rem EndEngTextBlock
) else if /I "%pathmode%"=="folder" (
    set "PSKEY=-sfolder"
rem StartRusTextBlock
set "TITLE=Выберите папку"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "TITLE=Select a folder"
rem EndEngTextBlock
) else (
rem StartRusTextBlock
    echo Некорректный режим: %pathmode%
rem EndRusTextBlock
rem StartEngTextBlock
rem echo Incorrected mode: %pathmode%
rem EndEngTextBlock
    exit /b 1
)

rem --- Создаём временный PowerShell-скрипт рядом с батником ---
set "PSFILE=%cd%\SelectPath_temp.ps1"

> "%PSFILE%" echo param(
>> "%PSFILE%" echo     [switch]$sf,
>> "%PSFILE%" echo     [switch]$sfolder,
>> "%PSFILE%" echo     [string]$title
>> "%PSFILE%" echo )
>> "%PSFILE%" echo Add-Type -AssemblyName System.Windows.Forms
>> "%PSFILE%" echo if ($sf) {
>> "%PSFILE%" echo     $dlg = New-Object System.Windows.Forms.OpenFileDialog
>> "%PSFILE%" echo     $dlg.Title = $title
>> "%PSFILE%" echo     if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
>> "%PSFILE%" echo         Write-Output "FILE=$($dlg.FileName)"
>> "%PSFILE%" echo     }
>> "%PSFILE%" echo }
>> "%PSFILE%" echo elseif ($sfolder) {
>> "%PSFILE%" echo     $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
>> "%PSFILE%" echo     $dlg.Description = $title
>> "%PSFILE%" echo     if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
>> "%PSFILE%" echo         Write-Output "FOLDER=$($dlg.SelectedPath)"
>> "%PSFILE%" echo     }
>> "%PSFILE%" echo }

rem --- Вызываем PowerShell и парсим результат ---
for /f "tokens=1* delims==" %%A in ('
    powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%" %PSKEY% -title "%TITLE%"
') do (
    if "%%A"=="FILE" set "SelectedFile=%%B"
    if "%%A"=="FOLDER" set "SelectedFolder=%%B"
)

rem --- Удаляем временный скрипт ---
del "%PSFILE%"

rem --- Вывод результата ---
echo ----------------------
rem if defined SelectedFile   echo Выбран файл: %SelectedFile%
rem if defined SelectedFolder echo Выбрана папка: %SelectedFolder%
rem pause
exit /b








:_userright
::taskkill /f /im %~nx0 1>NUL 2>&1
::cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %~nx0"
@taskkill /f /im %0 1>NUL 2>&1
@cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %0"
exit

:_adminright
::taskkill /f /im %~nx0 1>NUL 2>&1
::cmd /min /C "set __COMPAT_LAYER=RunAsAdmin && start "" %~nx0"
@taskkill /f /im %0 1>NUL 2>&1
@cmd /min /C "set __COMPAT_LAYER=RunAsAdmin && start "" %0"
exit

:_uacright
::taskkill /f /im %~nx0 1>NUL 2>&1
::cmd /min /C "set __COMPAT_LAYER=RunAsHighest && start "" %~nx0"
@taskkill /f /im %0 1>NUL 2>&1
@cmd /min /C "set __COMPAT_LAYER=RunAsHighest && start "" %0"
exit

:_colhat
rem call :_cdcb

:_hat
@cls
rem @echo ==================================================================================================
@echo ╔═════════════════════════════════════════════════════════════════════════════════════════════════╗
@echo ║   %s%     %_fBWhite%QUest ADB Scripts - created by Varset - v6.0.0%_fReset% - 18.01.25        Web: %_fBBlue%%_bBlack%www.vrcomm.ru%_fReset%    ║
@echo ╚═════════════════════════════════════════════════════════════════════════════════════════════════╝

rem @echo ==================================================================================================
@exit /b

:_hatmenu
@%verbecho%
::@@echo.
@echo.
::@@echo     -------------------
::@@echo      ВЫБЕРИТЕ ДЕЙСТВИЕ
::@@echo     -------------------
@echo.
rem StartRusTextBlock
@echo    0.  Выход из программы
@echo    M.  Выход в Главное меню
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    0.  Exit from the program
rem @echo    M.  Exit to Main menu
rem EndEngTextBlock
@exit /b

:_MenuChoiceEnter
@set "choice="
rem StartRusTextBlock
@Set /p choice="Выберите пункт меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Select a menu number and press Enter: "
rem EndEngTextBlock
@exit /b

:_MenuChoiceEnterDef
rem StartRusTextBlock
@Set /p choice="Выберите пункт меню и нажмите Enter: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @Set /p choice="Select a menu number and press Enter: "
rem EndEngTextBlock
@exit /b

:_returnmenu
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для возврата в Главное меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to return to the Main menu ^<^<^<
rem EndEngTextBlock
@pause >nul
@cls
goto _beginn

:_exitout
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите любую кнопку для выхода из программы ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to exit the program ^<^<^<
rem EndEngTextBlock
@pause >nul
@exit

:_exitwindow
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для закрытия этого окна ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key for close the window ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
exit /b



:_prevmenu
@echo ----------------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo ^>^>^> Press any key to return to the previous menu ^<^<^<
rem EndEngTextBlock
@pause 1>nul 2>nul
exit /b

:_SetColours
@set _fReset=[0m

@Set _fBlack=[30m
@Set _bBlack=[40m

@Set _fBRed=[91m
@Set _bRed=[41m
@Set _bBRed=[101m
@Set _fRed=[31m

@Set _fBGreen=[92m
@Set _bGreen=[42m
@Set _bBGreen=[102m
@Set _fGreen=[32m

@set _fCyan=[36m
@Set _bBCyan=[106m
@Set _bCyan=[46m
@Set _fBCyan=[96m

@set _fBYellow=[93m
@Set _fYellow=[33m
@Set _bBYellow=[103m
@Set _bYellow=[43m

@Set _fBlue=[34m
@Set _fBBlue=[94m
@Set _bBBlue=[104m

@Set _fBMag=[95m
@Set _bBMag=[105m
@Set _bMag=[45m

@Set _bLGray=[47m
@Set _bDGray=[100m

@Set _bBWhite=[107m
@Set _fBWhite=[97m
exit /b

:_ColorTest
call :_cdcbnoreg
rem @echo.
rem @echo.
@echo. %_fReset% 
set nd=%_fBlack%%_bRed%NA%_fReset%
set cb=%_fBlack%%_bGreen%CB%_fReset%
set dv=%_fBlack%%_bBYellow%DV%_fReset%
set db=%_fBlack%%_bBBlue%DB%_fReset%
set au=%_fBlack%%_bBMag%AU%_fReset%
set wl=%_fBlack%%_bBCyan%WL%_fReset%
set dr=%_fBlack%%_bYellow%DR%_fReset%
set sl=%_fBlack%%_bDGray%SL%_fReset%
set bl=%_fBlack%%_bDGray%BL%_fReset%
set ns=%_fBlack%%_bBWhite%NS%_fReset%
set em=%_fBlack%%_bRed%EM%_fReset%
set of=%_fBlack%%_bRed%OF%_fReset%
set no=NO
rem StartRusTextBlock
@echo   Цветовые (только Win 10) и буквенные индикаторы статуса или режима подключенного устройства
@echo   Отображаются в верхнем левом углу программы. Удобно использовать с ключом Bypass (пункты F-H)
@echo.
@echo		%nd%	= Устройство не подключено
@echo		%cb%	= Устройство подключено по кабелю
@echo		%dv%	= Режим разработчика не включен
@echo		%db%	= Двойное подключение, по кабелю и Wi-Fi одновременно
@echo		%au%	= Устройство не авторизовано
@echo		%wl%	= Устройство подключено по беспроводному соединению
@echo		%dr%	= Шлем подключен, но драйверы не установлены
@echo		%sl%	= Шлем в режиме Sideload
@echo		%bl%	= Шлем в режиме Bootloader
@echo		%ns%	= Подключенное устройство не является шлемом
@echo		%em%	= Шлем в режиме EDL
@echo		%of%	= Шлем выключен
@echo		%no%	= Установлен ключ Bypass Initial Status, пропуск всех начальных проверок
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Color and letter markings for the status or mode of the connected device
rem @echo   Displayed in the top left corner of the program. 
rem @echo   Convenient to use with the Bypass option (items F-H)
rem @echo.
rem @echo		%nd%	= Device not connected
rem @echo		%cb%	= Device connected via cable
rem @echo		%dv%	= Developer mode not enabled
rem @echo		%db%	= Dual connection, via cable and Wi-Fi simultaneously
rem @echo		%au%	= Device not authorized
rem @echo		%wl%	= Device connected via Wi-Fi
rem @echo		%dr%	= Headset connected, but drivers not installed
rem @echo		%sl%	= Headset in Sideload mode
rem @echo		%bl%	= Headset in Bootloader mode
rem @echo		%ns%	= Connected device is not a headset
rem @echo		%em%	= Headset in EDL mode
rem @echo		%of%	= Headset turned off
rem @echo		%no%	= The Bypass Initial Status key is set, skipping all initial checks
rem EndEngTextBlock
exit /b

:_qctlangset
rem StartRusTextBlock
set qtlang=ru
rem EndRusTextBlock
rem StartEngTextBlock
rem set qtlang=en
rem EndEngTextBlock
exit /b

:_utf
set codepage=@chcp 65001
rem set cod=utf
rem set hatcod=          [ ver. UTF-8 ]
exit /b

:_oem
set codepage=@chcp 866
set cod=oem
set hatcod=        [ ver. OEM-866 ]
exit /b


:_ps1CommandRun
@chcp 1251 >nul
set "ps=" & for %%X in (powerShell.exe) do set "ps=%%~$PATH:X"
if not defined ps set "ps=%systemRoot%\system32\windowsPowerShell\v1.0\powerShell.exe"

For /F "UseBackQ delims=" %%a in (`"cmd /c "
  "%ps%" -ExecutionPolicy ByPass -NoProfile -command "%pscommand%"
""`) do (
set "res=%%a"
)
set "%1=%res%"
@chcp 65001 >nul
exit /b

:_CyrillicPathCheckAll
rem StartRusTextBlock
@echo   ...Проверка на кириллицу...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ...Checking for Cyrillic characters...
rem EndEngTextBlock

:_CyrillicPathCheckTemp
set "cyrpath=%temp%"
call :_CyrillicPathCheckPS
rem StartRusTextBlock
if [%cyrpathres%]==[True] (set "cyrmsgtemp=Каталог пользователя содержит кириллицу. Возможна некорректная работа")
rem EndRusTextBlock
rem StartEngTextBlock
rem if [%cyrpathres%]==[True] (set "cyrmsgtemp=The user's directory contains Cyrillic characters. Incorrect operation may occur")
rem EndEngTextBlock

:_CyrillicPathCheckDP
set "cyrpath=%~dp0"
call :_CyrillicPathCheckPS
rem StartRusTextBlock
if [%cyrpathres%]==[True] (set "cyrmsgdp=Путь к программе содержит кириллицу. Возможна некорректная работа")
rem EndRusTextBlock
rem StartEngTextBlock
rem if [%cyrpathres%]==[True] (set "cyrmsgdp=The program path contains Cyrillic characters. Incorrect operation may occur")
rem EndEngTextBlock

:_CyrillicPathCheckCD
set "cyrpath=%cd%"
call :_CyrillicPathCheckPS
rem StartRusTextBlock
if [%cyrpathres%]==[True] (set "cyrmsgcd=Текущий путь запуска содержит кириллицу. Возможна некорректная работа")
rem EndRusTextBlock
rem StartEngTextBlock
rem if [%cyrpathres%]==[True] (set "cyrmsgcd=The current launch path contains Cyrillic characters. Incorrect operation may occur")
rem EndEngTextBlock
exit /b


:_CyrillicPathCheckPS
set "pscommand='%cyrpath%' -match '[\p{IsCyrillic}]'"
call :_ps1CommandRun cyrpathres
rem if [%cyrpathres%]==[True] (set "cyrmsg=Путь к программе содержит кириллицу. Возможна некорректная работа")
@chcp 65001 1>nul
exit /b


:_CheckAdminRights
rem @reg query "HKU\S-1-5-19" >NUL 2>&1 && (set adminaccess=Ну а то) || (set adminaccess=Не в этот раз)
rem StartRusTextBlock
@reg query "HKU\S-1-5-19" >NUL 2>&1 && (set "adminmsg=") || (set "adminmsg=   %_fBlack%%_bRed%+++ Перезапустите Quas с правами администратора +++%_fReset%")
rem EndRusTextBlock
rem StartEngTextBlock
rem @reg query "HKU\S-1-5-19" >NUL 2>&1 && (set "adminmsg=") || (set "adminmsg=   Start Quas app with admin rights")
rem EndEngTextBlock
exit /b

:_CheckOSVersion
@FOR /F "tokens=1,2,3,4,5 delims=. " %%a IN ('ver.exe') DO set /a osverrr=%%d
if %osverrr% GEQ 10 set osversion=10
exit /b

:_cdcbnoreg
@FOR /F "tokens=1,2,3,4,5 delims=. " %%a IN ('ver.exe') DO set /a osverrr=%%d
if %osverrr% GEQ 10 call :_SetColours
exit /b

:_CheckAllStatusMode
rem @echo  ---
rem @echo  Проверка режимов шлема...
call :_ColorSetOS
call :_CheckPowerOff
call :_CheckEDLMode
call :_CheckSideloadMode
call :_CheckBootloaderMode
goto :_CheckTCPConnect

rem call :_CheckWiFiConnect

:_ColorSetOS
@FOR /F "tokens=1,2,3,4,5 delims=. " %%a IN ('ver.exe') DO set /a osverrr=%%d
if %osverrr% GEQ 10 call :_SetColours
exit /b

:_CheckPowerOff
@%verbecho%
%MYFILES%\devcon_x64 find * | findstr /i /c:"Linux File-Stor Gadget USB Device" 2>nul 1>nul
IF %ERRORLEVEL% == 0 (
set poweroffmode=1
set s=%_fBlack%%_bRed%OF%_fReset%
rem @echo EDL
goto _PoweredOffMessage
) else (
set poweroffmode=0
rem @echo No EDL
)
exit /b

:_CheckEDLMode
@%verbecho%
%MYFILES%\devcon_x64 find * | findstr /i /c:"QUSB_BULK_CID" 2>nul 1>nul
IF %ERRORLEVEL% == 0 (
set edlmode=1
set s=%_fBlack%%_bRed%EM%_fReset%
rem @echo EDL
goto _EDLModeWarning
) else (
set edlmode=0
rem @echo No EDL
)
exit /b

:_CheckSideloadMode
@%verbecho%
@%MYFILES%\adb devices | findstr /i /c:"sideload" 1>nul 2>nul
@IF %ERRORLEVEL% EQU 0 (
set sideloadcheck=1
set s=%_fBlack%%_bLGray%SL%_fReset%
goto _sideloadmode
)
exit /b

:_CheckBootloaderMode
@%MYFILES%\fastboot devices 2>nul | findstr /i /c:"fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==0 (
set bl=1
set s=%_fBlack%%_bDGray%BL%_fReset%
goto _bootloadermode
)
exit /b

:_CheckTCPConnect
@%MYFILES%\adb devices 2>NUL | findstr /c:"_adb-tls-connect._tcp" 2>nul 1>nul
@IF %ERRORLEVEL% == 0 (
set /A tcpcheck=1
call :_TCPDisconnect
call :_CheckWiFiConnect
) else (
set /A tcpcheck=0
call :_CheckWiFiConnect
)
exit /b

:_CheckWiFiConnect
@%verbecho%
@%MYFILES%\adb devices 2>NUL | findstr /c:":" 2>nul 1>nul
@IF %ERRORLEVEL% EQU 0 (
set /A wificheck=1
rem StartRusTextBlock
set "drvmsg=%_fYellow%Не определено%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "drvmsg=%_fYellow%Not defined%_fReset%"
rem EndEngTextBlock
call :_CheckCableDoubleConnect
) else (
set /A wificheck=0
call :_CheckCableConnect
)
exit /b

:_CheckCableDoubleConnect
@%verbecho%
%MYFILES%\devcon_x64 find *VID_2833* | findstr /i /c:"XRSP" 2>nul 1>nul
IF %ERRORLEVEL% == 0 (
set /A cableconnect=1
call :_CheckDoubleOrNoDeviceMode
) else (
set /A cableconnect=0
call :_CheckDoubleOrNoDeviceMode
)
exit /b

:_CheckCableConnect
@%MYFILES%\devcon_x64 find *VID_2833* | findstr /i /c:"XRSP" 1>nul 2>nul
@IF %ERRORLEVEL% EQU 0 (
set /A cableconnect=1
call :_CheckDriversInstalled
) else (
set /A cableconnect=0
call :_CheckDoubleOrNoDeviceMode
)
exit /b

:_CheckDriversInstalled
@%verbecho%
@%MYFILES%\devcon_x64 find *VID_2833* | findstr /i /c:"Oculus" 1>nul 2>nul
@IF %ERRORLEVEL% EQU 0 (
set /a checkdriversoс=1
rem StartRusTextBlock
set "drvmsg=%_fBYellow%Устаревшие%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "drvmsg=%_fBYellow%Outdated%_fReset%"
rem EndEngTextBlock
call :_CheckDevMode
) else (
set /a checkdriversoс=0
goto _CheckRLDriversInstalled
rem set s=%_fBlack%%_bYellow%DR%_fReset%
rem goto _NoDriversInstalled
)
exit /b

:_CheckRLDriversInstalled
@%verbecho%
@%MYFILES%\devcon_x64 find *VID_2833* | findstr /i /c:"Reality Labs" 1>nul 2>nul
@IF %ERRORLEVEL% EQU 0 (
set checkdriversrl=1
rem StartRusTextBlock
set "drvmsg=%_fBgreen%Актуальные%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "drvmsg=%_fBgreen%Up to date%_fReset%"
rem EndEngTextBlock
call :_CheckDevMode
) else (
set checkdriversrl=0
rem StartRusTextBlock
set "drvmsg=%_fBRed%Не установлены%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
rem set "drvmsg=%_fBRed%Not installed%_fReset%"
rem EndEngTextBlock
set s=%_fBlack%%_bYellow%DR%_fReset%
goto _NoDriversInstalled
)
exit /b

rem :_CheckBothDeviceName
rem @set /a checkdrvsum=%checkdriversok%+%checkdriversrl%
rem @IF %checkdrvsum% GEQ 1 (
rem goto _CheckDevMode
rem ) else (
rem set s=%_fBlack%%_bYellow%DR%_fReset%
rem goto _NoDriversInstalled
rem )
rem exit /b

:_CheckDevMode
@%verbecho%
@%MYFILES%\devcon_x64 find *VID_2833* | findstr /i /c:"ADB" 1>nul 2>nul
IF %ERRORLEVEL% EQU 0 (
set adbcheck=1
call :_setfwtxt
rem 
goto :_CheckAutorization
rem old
rem call :_CheckMTPMode
rem 
) else (
set adbcheck=0
set s=%_fBlack%%_bBYellow%DV%_fReset%
call :_noadb
)
exit /b

:_CheckMTPMode
@%verbecho%
@%myfiles%\adb shell getprop ro.boot.serialno 1>NUL 2>&1
IF %ERRORLEVEL% EQU 0 (
set mtpcheck=1
call :_setfwtxt
rem 
set s=%_fBlack%%_bGreen%CB%_fReset%
goto _CheckInfoTableKeys
rem  old
rem call :_CheckAutorization
rem 
) else (
set mtpcheck=0
call :_mtpcheck
)
exit /b


:_CheckAutorization
@%verbecho%
@%MYFILES%\adb devices 2>NUL | findstr /i /c:"unauthorized" 1>NUL 2>nul
@IF %ERRORLEVEL% EQU 0 (
set autorizecheck=1
set s=%_fBlack%%_bBMag%AU%_fReset%
goto _notautorized
) else (
set autorizecheck=0
rem 
call :_CheckMTPMode
rem  old
rem set s=%_fBlack%%_bGreen%CB%_fReset%
rem goto _CheckInfoTableKeys
rem 
)
exit /b

:_CheckDoubleOrNoDeviceMode
rem call :_SetSNConnecting
@set /a connectsum=%cableconnect%+%wificheck%+%tcpcheck%
rem echo %connectsum%
@IF [%connectsum%] == [] set s=%_fBlack%%_bRed%NA%_fReset%&& call :_CheckUnSupportDevice && goto _NoDevice
@IF %tcpcheck% GTR %cableconnect% set s=%_fBlack%%_bBCyan%WL%_fReset%&& goto _CheckWLWarningKey
@IF %wificheck% GTR %cableconnect% set s=%_fBlack%%_bBCyan%WL%_fReset%&& goto _CheckWLWarningKey
@IF %connectsum% GEQ 2 set s=%_fBlack%%_bBBlue%DB%_fReset%&& goto :_DoubleConnect
@IF %connectsum% EQU 0 set s=%_fBlack%%_bRed%NA%_fReset%&& call :_CheckUnSupportDevice && goto _NoDevice


:_CheckUnSupportDevice
@For /F %%a In ('@%MYFILES%\adb shell getprop ro.product.manufacturer 2^>nul') Do set manuf=%%a
@if [%manuf%] == [] exit /b
if [%manuf%] NEQ [Oculus] (set s=%_fBlack%%_bBWhite%NS%_fReset%) else (exit /b)
@For /F "tokens=*" %%a In ('%MYFILES%\adb shell getprop ro.semc.product.name') Do set prodname=%%a
@For /F %%a In ('%MYFILES%\adb shell getprop ro.semc.product.model') Do set prodmodel=%%a
goto :_NotSupported

:_CheckInitialStatusKey
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BypassInitialStatus 2^>nul') do set bpinitialstatus=%%a
@if [%bpinitialstatus%]==[] goto _CheckAllStatusMode
@if %bpinitialstatus%==0xb set s=NO&& call :_hat && goto _beginn
exit /b

:_CheckInfoTableKeys
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BypassInfoTable 2^>nul') do set bpinfotable=%%a
@if [%bpinfotable%]==[] goto _tabGeneral
@if %bpinfotable%==0xb  call :_hat && goto _beginn
exit /b

:_CheckWLWarningKey
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BypassWLWarning 2^>nul') do set bpwfatt=%%a
@if [%bpwfatt%]==[] goto _WiFiConnected
@if %bpwfatt%==0xb goto _CheckInfoTableKeys
exit /b

:_SetSNConnecting
setlocal enabledelayedexpansion
if [%cableconnect%]==[1] @FOR /F "skip=1 tokens=*" %%a IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO set sn=%%a && endlocal && exit /b
if [%wificheck%]==[1] @FOR /F "skip=1 tokens=*" %%a IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO set sn=%%a && endlocal && exit /b
if [%tcpcheck%]==[1] @FOR /F "skip=1 tokens=1,2 delims=." %%a IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO set sn=%%a && endlocal && exit /b
@FOR /F "skip=1 tokens=1,2 delims=." %%a IN ('@%MYFILES%\adb devices ^| findstr /i /c:"offline"') DO set sn=%%a && endlocal && exit /b
@For /F %%a In ('%MYFILES%\adb shell getprop ro.boot.serialno 2^<nul') Do set sn=%%a
exit /b

:_TCPDisconnect
if [%tcpcheck%]==[1] @FOR /F "skip=1 tokens=1,2 delims=." %%a IN ('@%MYFILES%\adb devices ^| findstr /i /c:"device"') DO set adbdevices=%%a
@%myfiles%\adb -s %adbdevices% disconnect 1>nul 2>nul
exit /b

:_ActionConfirmationReguest
rem StartRusTextBlock
set "wordaction=действия"
@echo   %_fBYellow%Для подтверждения %wordaction% нажмите %_fYellow%Enter%_fBYellow%, для возврата в меню - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem set "wordaction=action"
rem @echo   %_fBYellow%For %wordaction% confirmation press %_fYellow%Enter%_fBYellow%, to return to the menu - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo.
@echo.
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "%KEY%"=="27" %escapeconfirmation%
if "%KEY%"=="13" %enterconfirmation%
exit /b



:_ExtractListNumber
set "ListNumber=%~1"
set "ListNumber=%ListNumber:~2%"
exit /b



:_MTPCheck
setlocal enabledelayedexpansion
del vidpid_info*.csv /q /f 1>nul 2>nul
for /f "delims=" %%i in ('powershell -ExecutionPolicy Bypass -File %myfiles%\vstn.ps1 -Csv -ShortOutput -VID "2833"') do set "ResultFile=%%i"
set "FoundQuest="
set "HasNo="
for /f "skip=1 usebackq tokens=1,2,3,4,5 delims=," %%A in ("%ResultFile%") do (
     set "vid=%%~E"
     set "hidden=%%~B"
     set "vid=!vid:"=!"
     set "hidden=!hidden:"=!"
@echo !vid! | findstr /I "2833" >nul
     if not errorlevel 1 (
         set "FoundQuest=1"
         if /I "!hidden!"=="No" (
             set "HasNo=1"
         )
     )
)

if not defined FoundQuest (
@echo  Quest devices not found
rem     call :Sub1
) else if defined HasNo (
rem @echo На шлеме включен MTP
del vidpid_info*.csv /q /f 1>nul 2>nul
set s=%_fBlack%%_bBCyan%MT%_fReset%
     call :_HasMTPMode
) else (
rem @echo  ADB доступен
rem     call :Sub3
)
exit /b


rem For /f "skip=1 tokens=3 delims= " %%a in ('reg query HKCU\Software\Quas /v Rights') do set rightskey=%%a
rem if [%rightskey%]==[] goto _tabBegin
rem if /i %rightskey%==u goto _userright 
rem if /i %rightskey%==a goto _adminright
rem if /i %rightskey%==c goto _uacright
rem exit /b

:_KeyCodeEscapeEnter
for /f "usebackq delims=" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "keycode=%%K"
if "!keycode!"=="27" %escapecode%
if "!keycode!"=="13" %entercode%
exit /b


:_DeleteWrongSymbolsOkMain
set "apknametest=%dlapplold%"
@for %%a in ("%apknametest%") do (
@set name=%%a
call set "name=%%name:(=%%"
call set "name=%%name:)=%%"
call set "name=%%name:^!=%%"
call set "name=%%name:+=%%"
rem call set "name=%%name: =%%"
call set "name=%%name::=%%"
call set "name=%%name:&=%%"
call set "name=!name:%2B=!"
rem  cmd/v/c ren "%%a" "!name:%%=!"
)
set dlappl=%name:~1,-1%
exit /b

:_TaskkillADB
call :_CheckAdminRights
@echo.
@echo.
@echo.
rem @echo.    %adminmsg%
rem %myfiles%\adb kill-server
@taskkill /IM adb.exe /F 2>nul 1>nul
exit /b
