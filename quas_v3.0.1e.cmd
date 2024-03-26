@echo off
rem @set myfiles=d:\Quest2\adb
rem @set myfiles=%~dp0\Source
@mode con:cols=100 lines=52
@color 07

@set cp=utf
::@set cp=oem

@call :_%cp%
%codepage% 1>nul

@echo.
rem @echo ADB запускается...
@echo ADB is starting..
@echo.

rem goto _beginn

rem call :_CheckRegisterKeys

if [%1]==[] goto :_begin0
if /i [%1]==[a] set right=1 && goto _adminright
if /i [%1]==[u] set right=2 && goto _userright 
if /i [%1]==[c] set right=3 && goto _uacright
if /i [%1]==[b]  goto _beginn
if /i [%1]==[h]  call :_ShowAllUndocCommands

:::_begin00

:_begin0
::@call :_CheckUserAdmin
@call :_CheckSideloadMode
@call :_CheckBootloaderMode
@call :_CheckCableMode
@call :_CheckWiFiMode
@call :_CheckDoubleOrNoDeviceMode
@call :_CheckDevMode
@call :_CheckAfterWiFiCheckMode
@call :_CheckSideloadMode
@call :_CheckBootloaderMode

:_begin1
rem @echo.
rem @echo ADB запускается...

:_tabBegin
@call :_tabGeneral
goto _tabMenu

:_beginn
@call :_hat
:_tabMenu
@color 07
@echo off
@echo.
@echo.
rem @echo      0.  Выход из программы
@echo      0.  Exit from the program
@echo.
rem @echo %r%      1.  Управление обновлениями				
@echo %e%     1.  Updates Management
rem @echo      2.  Отправка строки текста на шлем
@echo      2.  Sending a text string to the headset
rem @echo      3.  Показать скрытые настройки
@echo      3.  Show hidden settings
rem @echo      4.  Перезагрузка в разные режимы и информация о текущем
@echo      4.  Reboot into different modes and current information
rem @echo      5.  Создание скриншотов дисплея шлема
@echo      5.  Making screenshots of the headset display
rem @echo      6.  Копирование скриншотов со шлема на ПК
@echo      6.  Copying screenshots from the headset to the PC
rem @echo      7.  Подключение шлема "ADB по Wi-Fi"
@echo      7.  Connecting the headset via "ADB over Wi-Fi"
rem @echo      8.  Переподключение шлема "ADB по кабелю"
@echo      8.  Reconnecting the headset via "ADB over cable"
rem @echo      9.  Подключение шлема как съемного диска
@echo      9.  Connecting the headset as a removable disk
rem @echo      A.  Устранение ошибки OpenSSL SHA Crash Bug
@echo      A.  Fixing the OpenSSL SHA Crash Bug
rem @echo      B.  Перезапуск сервиса Oculus на ПК
@echo      B.  Restarting the Oculus service on PC
rem @echo      С.  Тестирование, диагностика, hешение различных проблем
@echo      C.  Testing, diagnostics, resolving various issues
rem @echo      D.  Открыть в шлеме настройки VPN
@echo      D.  Open VPN settings on the headset
rem @echo      E.  Cистемная информация
@echo      E.  System information
rem @echo      F.  резерв		
rem @echo      G.  Прошивка шлема и информация о прошивке
@echo      G.  Headset firmware update and firmware information
rem @echo      H.  Список дополнительных команд и параметров (Help)
@echo      H.  List of additional commands and parameters (Help)
rem @echo      I.  Прогресс скачивания/обновления, установка DNS
@echo      I.  Download/update progress, DNS setup
rem @echo      J.  Работа с приложениями
@echo      J.  Application management
rem @echo      K.  Установка уровней CPU/GPU 
@echo      K.  Setting CPU/GPU levels
rem @echo      L.  Установка нативного RefreshRate и разрешения дисплея
@echo      L.  Setting native RefreshRate and display resolution
rem @echo      M.  Управление Oculus Link/Airlink
@echo      M.  Oculus Link/Airlink management
rem @echo      N.  Создание ярлыков для копирования файлов и установки приложений
@echo      N.  Creating shortcuts for copying files and installing applications
rem @echo      O.  Установить высокий приоритет сервисам Oculus
@echo      O.  Set high priority for Oculus services
rem @echo      P.  Корректировка даты, времени и таймзоны в шлеме
@echo      P.  Adjusting date, time, and timezone on the headset
rem @echo      Q.  Резервирование данных приложений (Только Meta Quest 1/2)
@echo      Q.  App data backup (Meta Quest 1/2 only)
rem @echo      R.  Стрим видеотрансляции на ПК
@echo      R.  Stream video casting to PC
@echo.
rem @echo      X.  Открыть консоль cmd
@echo      X.  Open cmd console
rem @echo      Y.  Открыть консоль adb shell
@echo      Y.  Open ADB shell console
rem @echo      Z.  Помощь в решении проблем.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _beginn
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="00" (GOTO _ShowAllUndocCommands)
if /i "%choice%"=="1" (GOTO _updateservice)
if /i "%choice%"=="2" (GOTO _sendtext)
if /i "%choice%"=="3" (GOTO _startsettings)
if /i "%choice%"=="4" (GOTO _menurestart)
if /i "%choice%"=="5" (GOTO _screenshotmenu)
if /i "%choice%"=="6" (GOTO _scrshcopy)
if /i "%choice%"=="7" (GOTO _adbwifi)
if /i "%choice%"=="8" (GOTO _reconnect)
if /i "%choice%"=="9" (GOTO _usbflash)
if /i "%choice%"=="a" (GOTO _opensslerrorfix)
if /i "%choice%"=="b" (GOTO _ocsrvrestart)
if /i "%choice%"=="c" (GOTO _shellmenu)
if /i "%choice%"=="d" (GOTO _openvpn)
if /i "%choice%"=="e" (GOTO _syscommenu)
rem if /i "%choice%"=="f" (GOTO _autosenderr)
if /i "%choice%"=="g" (GOTO _fwmenu)
if /i "%choice%"=="gg" (GOTO _fwmenuskip)
if /i "%choice%"=="h" (GOTO _ShowAllUndocCommands)
if /i "%choice%"=="i" (GOTO _todmenu)
if /i "%choice%"=="j" (GOTO _installmenugen)
if /i "%choice%"=="k" (GOTO _menugpucpu)
if /i "%choice%"=="l" (GOTO _resolutionfix)
if /i "%choice%"=="m" (GOTO _oculuslink)
if /i "%choice%"=="n" (GOTO _qctprocedure)
if /i "%choice%"=="o" (GOTO _setpriority)
if /i "%choice%"=="p" (GOTO _datetime)
if /i "%choice%"=="q" (GOTO _backupdatamenu)
if /i "%choice%"=="r" (GOTO _streamingmenu)
if /i "%choice%"=="y" (GOTO _openshell)
if /i "%choice%"=="x" (GOTO _opencmd)
if /i "%choice%"=="z" (GOTO _helplinksmenu)
:: Egg
if /i "%choice%"=="449" (GOTO _449info)
if /i "%choice%"=="103" (GOTO _103info)
if /i "%choice%"=="квас" (GOTO _egg)
if /i "%choice%"=="QUAS" (GOTO _egg)
@cls
goto _beginn


:_ShowAllUndocCommands
cls
@echo.
@echo.
rem @echo    Дополнительные ключи и команды:
@echo    Additional keys and commands:
@echo   --------------------------------
@echo.
rem @echo 	00		= Это окно (можно набрать в Главном меню)
@echo 	00		= This window (can be chosen in the Main menu)
rem @echo 	h		= Это окно (можно набрать в Главном меню)
@echo 	h		= This window (can be chosen in the Main menu)
rem @echo 	u		= Перезапустить от имени пользователя
@echo 	u		= Restart as user
rem @echo 	c		= Перезапустить от админа с запросом UAC
@echo 	c		= Restart as admin with UAC prompt
rem @echo 	a		= Перезапустить от админа без запроса UAC
@echo 	a		= Restart as admin without UAC prompt
rem @echo 	b		= Ускоренный старт Quas: без таблицы и проверок
@echo 	b		= Quick start Quas: without table and checks (bypass)
rem @echo 	G-^>FF		= Дополнительное пояснение об инкрементальных прошивках
@echo 	G-^>FF		= Additional explanation about incremental firmware updates
rem @echo 	G-^>EE		= Сравнить версию прошивки шлема с файлом fw.txt
@echo 	G-^>EE		= Compare the headset firmware version with the fw.txt file
rem @echo 	J-^>A-^>d		= Включить установку с возможностью downgrade
@echo 	J-^>A-^>d		= Enable installation with downgrade capability
rem @echo 	J-^>A-^>v		= Включить отображение подробностей установки
@echo 	J-^>A-^>v		= Enable installation details display (verbose)
rem @echo 	J-^>A-^>l		= Включить запись в файл лога установки
@echo 	J-^>A-^>l		= Enable installation log file recording
rem @echo 	449		= Таблица разделов шлема и их размер в байтах и гигабайтах
@echo 	449		= Headset partition table and their sizes in bytes and gigabytes
rem @echo 	103		= Таблица разделов шлема и их размер в байтах и гигабайтах
@echo 	103		= Headset partition table and their sizes in bytes and gigabytes
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
@echo.
goto _returnmenu

:_shellmenu
cls
call :_hat
call :_hatmenu
@echo.
rem @echo    A.  Перезапуск оболочки шлема
@echo    A.  Restarting the headset shell
rem @echo    B.  Перезапуск оболочки шлема (второй вариант)
@echo    B.  Restarting the headset shell (second option)
rem @echo    C.  Управление Wi-Fi на шлеме				
@echo    C.  Managing Wi-Fi on the headset
rem @echo    D.  Принудительный старт домашнего окружения шлема
@echo    D.  Forcing the start of the headset's home environment
rem @echo    E.  Управление Защитной системой
@echo    E.  Managing the Guardian
rem @echo    F.  Управление датчиком приближения
@echo    F.  Proximity sensor management
rem @echo    G.  Устранить проблему перезагрузки кнопками громкости (удалить KeyMapper)
@echo    G.  Fix volume button reboot issue (remove KeyMapper)
rem @echo    H.  Перезапуск ADB сервера на ПК
@echo    H.  Restart ADB server on PC
rem @echo    I.  Встроить ADB и пакет утилит в систему, а также удалить весь этот хлам из нее
@echo    I.  Embed ADB and utility package into the system, as well as remove all this junk from it
rem @echo    K.  Восстановить настройки отключения экрана (screen timeout)
@echo    K.  Restore screen timeout settings
rem @echo    L.  Создание расшаренного ресурса на ПК
@echo    L.  Creating a shared resource on a PC
rem @echo    N.  Проверка исправности кабеля
@echo    N.  Cable functionality check
rem @echo.   O.  Проверка исправности камер (Только Quest 2)
@echo.   O.  Camera functionality check (Quest 2 only)
rem @echo    P.  Измерение скорости Wi-Fi между шлемом и ПК	[EXP]
@echo    P.  Measure Wi-Fi speed between the headset and PC [EXP]
rem @echo.   Q.  Статистика сетевых подключений (netstat)
@echo.   Q.  Network connection statistics (netstat)
rem @echo	 R.  Диагностика дисплея 
@echo    R.  Display diagnostics
@echo.
rem @echo    X.  Открыть консоль cmd
@echo    X.  Open cmd console
rem @echo    Z.  Помощь в решении проблем.
@echo.    
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _shellmenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _shellrestart)
if /i "%choice%"=="b" (GOTO _shellrestart2)
if /i "%choice%"=="c" (GOTO _wificontrol)
if /i "%choice%"=="d" (GOTO _homescreen)
if /i "%choice%"=="e" (GOTO _guardian)
if /i "%choice%"=="f" (GOTO _proxsensor)
if /i "%choice%"=="g" (GOTO _deletekm)
if /i "%choice%"=="h" (GOTO _ADBServerRestart)
if /i "%choice%"=="i" (GOTO _adbintegr)
if /i "%choice%"=="k" (GOTO _scrtimeout)
if /i "%choice%"=="l" (GOTO _setshare)
if /i "%choice%"=="n" (GOTO _TestVrUsvCopy)
if /i "%choice%"=="o" (GOTO _camtest)
if /i "%choice%"=="p" (GOTO _iperftest)
if /i "%choice%"=="q" (GOTO _shownetstat)
if /i "%choice%"=="r" (GOTO _displaydiagmain)
rem if /i "%choice%"=="s" (GOTO _displaydiag2)

if /i "%choice%"=="x" (GOTO _opencmd)
rem if /i "%choice%"=="z" (GOTO _helplinksmenu)
@cls
goto _shellmenu

:_displaydiagmain
cls
call :_hat
call :_hatmenu
@echo.
@echo.
rem @echo    1. Тест дисплея 1 вариант
@echo    1. Display test. 1 variant
rem @echo    2. Тест дисплея 2 вариант
@echo    2. Display test. 2 variant
@echo.
@echo.
@echo.
@echo.
rem @echo   После запуска на шлеме откроется страница в дефолтном браузере.
rem @echo   С ее помощью можно провести онлайн-тест дисплея.
@echo After starting, a page will open in the default browser on the helmet.
@echo With its help, you can conduct an online display test.
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
rem @echo   Наденьте шлем, в браузере будет открыта страница с тестом
@echo Put on headset, a page with the test will open in the browser.
call :_prevmenu
goto _shellmenu

:_displaydiag2
%myfiles%\adb shell am start -n "com.oculus.vrshell/.MainActivity" -d apk://com.oculus.browser -e uri https://testmyscreen.com/ 1>nul 2>nul
@echo.
@echo ----------------------------------------------------------------
rem @echo   Наденьте шлем, в браузере будет открыта страница с тестом
@echo Put on headset, a page with the test will open in the browser.
call :_prevmenu
goto _shellmenu


:_ADBServerRestart
@echo ========================================
rem @echo  Перезапускаем ADB сервер...
@echo  Restarting ADB server...
@echo. 
@%MYFILES%\adb kill-server
@%MYFILES%\adb start-server 1>nul 2>nul
@echo ----------------------------------------
rem @echo  = Сервер перезапущен
rem @echo  Можете подключить кабель к шлему
@echo  = Server restarted
@echo  You can connect the cable to the headset
@echo. 
@echo ----------------------------------------
@goto _returnmenu


:_DeleteKM

@%MYFILES%\adb shell dpm remove-active-admin io.github.sds100.keymapper.debug
call :_erlvl
@echo.
@echo --------------------------------------------------------------
rem @echo На возможное сообщение об ошибке не обращайте внимания.
@echo Ignore any potential error messages.
@echo --------------------------------------------------------------
@timeout 3 >nul
@%MYFILES%\adb shell pm disable-user io.github.sds100.keymapper.debug
@echo.
@echo --------------------------------------------------------------
rem @echo  = KeyMapper удален.
rem @echo  Если он все еще фигурирует в приложениях на шлеме, 
rem @echo  удалите его обычным образом и перезагрузитесь.
@echo  = KeyMapper removed.
@echo  If it still appears in the applications on the headset,
@echo  remove it in regular way and reboot.


@echo --------------------------------------------------------------
@echo.
goto _returnmenu



:_updateservice
call :_hat
call :_hatmenu
@echo.
rem @echo    C.  Текущий статус обновлений
rem @echo    D.  Отключение сервиса обновлений прошивки шлема
rem @echo    E.  Включение сервиса обновлений прошивки шлема
rem @echo    F.  Запретить обновления ПО Oculus Home на ПК
rem @echo    G.  Разрешить обновления ПО Оculus Home на ПК
@echo    C. Current update status
@echo    D. Disable headset firmware update service
@echo    E. Enable headset firmware update service
@echo    F. Block Oculus Home software updates on PC
@echo    G. Allow Oculus Home software updates on PC
@echo.

call :_MenuChoiceEnter
@echo.
if not defined choice goto _updateservice
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="c" (goto _UpdateStatus1)
if /i "%choice%"=="d" (GOTO _updservoff)
if /i "%choice%"=="e" (GOTO _updservon)
if /i "%choice%"=="f" (GOTO _updservocoff)
if /i "%choice%"=="g" (GOTO _updservocon)
@cls
goto _updateservice

:_UpdateStatus1
call :_cdc
%myfiles%\adb shell pm list packages -d 2>&1 | find /i "com.oculus.updater"  2>nul 1>nul
rem echo %DevModelNm%
rem if %errorlevel%==1 (set updstatus=Включены) else (set updstatus=Отключены)
if %errorlevel%==1 (set updstatus=Enabled) else (set updstatus=Disabled)
@echo ========================================
rem @echo = Обновления %updstatus%
@echo = Updates %updstatus%
@echo. 
@echo ----------------------------------------
@goto _returnmenu

:_updservoff
@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.updater
call :_erlvl
@echo ========================================
rem @echo Сервис обновлений отключен
@echo Update service disabled
@goto _returnmenu

:_updservon
@%MYFILES%\adb shell pm enable --user 0 com.oculus.updater
call :_erlvl
@echo ========================================
rem @echo  Сервис обновлений включен
@echo Update service enabled
@goto _returnmenu

:_updservocoff
@rd /q /s "C:\Program Files\Oculus\Staging" 2>nul 1>nul
@rd /q /s "C:\Program Files\Oculus\tmp" 2>nul 1>nul
@fsutil file createnew "C:\Program Files\Oculus\tmp" 0 2>nul 1>nul
@fsutil file createnew "C:\Program Files\Oculus\Staging" 0 2>nul 1>nul
@echo ========================================
rem @echo  Обновления Oculus Home не разрешены
@echo Oculus Home updates are not allowed
@goto _returnmenu

:_updservocon
@del /q "C:\Program Files\Oculus\Staging" /f 2>nul 1>nul
@del /q "C:\Program Files\Oculus\tmp" /f 2>nul 1>nul
@echo ========================================
rem @echo  Обновления Oculus Home разрешены
@echo Oculus Home updates are allowed
@goto _returnmenu

:_menugpucpu
call :_hat
call :_hatmenu
@echo.
rem @echo    C.  Установка уровня CPU
rem @echo    G.  Установка уровня GPU
rem @echo    S.  Показать текущие уровни
@echo    C. Set CPU level
@echo    G. Set GPU level
@echo    S. Show current levels
@echo.
@echo.
rem @echo    ВАЖНО:
@echo    IMPORTANT:
@echo.
rem @echo      Работает пока только на Meta Quest 2
@echo      Works only on Meta Quest 2 for now
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
@echo off
rem @echo      ----------------------------
rem @echo       ВЫБЕРИТЕ УРОВЕНЬ РАБОТЫ CPU
rem @echo      ----------------------------
rem @echo.
rem @echo    C.  Узнать текущий уровень
rem @echo    M.  Возврат в меню
rem @echo.
rem @echo    0.  Минимальный
rem @echo    1.  Низкий
rem @echo    2.  Средний
rem @echo    3.  Высокий
rem @echo    4.  Супервысокий
rem @echo    5.  Максимальный
@echo      ----------------------------
@echo       SELECT CPU PERFORMANCE LEVEL
@echo      ----------------------------
@echo.
@echo    C.  Check current level
@echo    M.  Return to menu
@echo.
@echo    0.  Minimum
@echo    1.  Low
@echo    2.  Medium
@echo    3.  High
@echo    4.  Ultra
@echo    5.  Maximum

rem @echo    6
rem @echo    7
rem @echo    A.  Авто
@echo    A.  Аuto
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
rem @echo  Параметры установлены
@echo Settings have been applied
call :_prevmenu
cls
@goto _menugpucpu

:_gpu
call :_cdc
call :_hat
@echo.
@echo off
rem @echo      ----------------------------
rem @echo       ВЫБЕРИТЕ УРОВЕНЬ РАБОТЫ GPU
rem @echo      ----------------------------
rem @echo.
rem @echo    C.  Узнать текущий уровень
rem @echo    M.  Возврат в меню
rem @echo.
rem @echo    0.  Минимальный
rem @echo    1.  Низкий
rem @echo    2.  Средний
rem @echo    3.  Высокий
rem @echo    4.  Супервысокий
rem @echo    5.  Максимальный
rem @echo    A.  Авто
@echo      ----------------------------
@echo       SELECT CPU PERFORMANCE LEVEL
@echo      ----------------------------
@echo.
@echo    C.  Check current level
@echo    M.  Return to menu
@echo.
@echo    0.  Minimum
@echo    1.  Low
@echo    2.  Medium
@echo    3.  High
@echo    4.  Ultra
@echo    5.  Maximum

rem @echo    6
rem @echo    7
rem @echo    A.  Авто
@echo    A.  Аuto
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
rem @echo  Параметры установлены
@echo Settings have been applied
call :_prevmenu
@cls
goto _menugpucpu

:_currentpu
call :_cdc
rem @echo Текущие уровни
@echo Current levels:
@echo GPU:
@%MYFILES%\adb shell getprop debug.oculus.gpuLevel
call :_erlvl
@Echo CPU:
@%MYFILES%\adb shell getprop debug.oculus.cpuLevel
@echo ========================================
rem @echo  (пустые строки или -1 означают Auto)
@echo (Blank lines or -1 indicate Auto)
@goto _returnmenu

:_setpriority
call :_hat
@echo.
@echo off
rem @echo  Cледующим процессам будет установлен приоритет Высокий:
rem @echo.
rem @echo   OculusClient.exe
rem @echo   OculusDash.exe
rem @echo   OVRServer_x64.exe
rem @echo.
rem @echo    0.  Выход из программы
rem @echo    M.  Выход в главное меню
rem @echo.
rem @echo    Y.  Установить параметры
@echo  The following processes will be set to High priority:
@echo.
@echo   OculusClient.exe
@echo   OculusDash.exe
@echo   OVRServer_x64.exe
@echo.
@echo    0.  Exit the program
@echo    M.  Return to main menu
@echo.
@echo    Y.  Apply settings

@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _setpriority
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="y" (GOTO _checkservices)
cls
goto _setpriority

:_checkservices
@sc query ovrservice 1>nul 2>&1
rem @if errorlevel == 1 @echo ======================================== ^ & @echo Сервис Oculus не установлен! & goto _returnmenu
@if errorlevel == 1 @echo ======================================== ^ & @echo The Oculus service is not installed! & goto _returnmenu

:_setprioritycpu
@cmd.exe /c wmic process where name="OculusClient.exe" call setpriority 128
@cmd.exe /c wmic process where name="OculusDash.exe" call setpriority 128
@cmd.exe /c wmic process where name="OVRServer_x64.exe" call setpriority 128
@echo ========================================
rem @echo  Параметры установлены
@echo Settings have been applied
@goto _returnmenu

:_sendtext
call :_hat
@echo.
@echo.
@echo off
rem @echo  Установите курсор в шлеме на поле, в которое хотите вставить текст
rem @echo  [ например, в адресной строке браузера или в поле ввода ключа/пароля ]
rem @echo  [ для отмены и возврата в меню введите три двоеточия подряд :::]
@echo.
@echo  Place the cursor in the field on the headset where you want to insert text
@echo  [ For example, in the browser address bar or in the key/password input field ]
@echo  [ To cancel and return to the menu, enter three colons in a row ::: ]
@echo.
rem set /p txt="Введите вставьте текст для отправки на шлем и нажмите Enter: "
set /p txt="Enter the text to send to the headset and press Enter: "

if /i "%txt%"==":::" (GOTO _beginn)
if /i "%txt%"=="(((" (GOTO _beginn)
if /i "%txt%"==")))" (GOTO _beginn)
@%MYFILES%\adb shell input text '%txt%' 1>nul 2>nul
call :_erlvl
@echo ========================================
rem @echo  Можете надеть шлем, текст должен быть вставлен в поле
@echo  You can put on the headset; the text should be inserted into the field.

@goto _returnmenu

:_startsettings
:::::::::::::::::
@%MYFILES%\adb shell am start -a android.intent.action.VIEW -n com.android.settings/.Settings >nul
call :_erlvl
@ping localhost >nul
@echo ========================================
rem @echo  Можете надеть шлем, настройки должны быть открыты
@echo  You can put on the headset; the settings should be open.

@goto _returnmenu

:_menurestart
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
@echo.
goto _eng1
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
:_eng1
@echo    C.  Standard/Default Headset Reboot.
@echo    B.  Headset Reboot into Bootloader Mode
@echo    R.  Headset Reboot into Recovery Mode
@echo    F.  Headset Reboot into Fastboot Mode
@echo    S.  Headset Reboot into Sideload Mode (Regular Variant)
@echo    T.  Headset Reboot into Sideload Mode (Alternate Variant)
@echo    K.  Determine the Current Mode of the Headset         [EXP]
@echo.   P.  Power Off Headset
@echo.
@echo   IMPORTANT:
@echo.
@echo  Not every mode can be rebooted into another mode.
@echo. If the headset does not reboot, check inside it
@echo  and select the Reboot system now option.
@echo.
@echo  Attention: From Sideload mode, you can reboot
@echo. back to standard mode only through commands in this menu or through
@echo. the Boot Device option in Bootloader mode. (Power and Volume Down)
@echo. Rebooting by the Power button will boot the headset back into Sideload.

@echo.
@echo.
@echo.

call :_MenuChoiceEnter
@echo.
if not defined choice goto _menurestart
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
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

:_reboot
rem call :_cdc
@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.name') do set IntProductName=%%a
if [%IntProductName%]==[] @fastboot reboot 1>nul 2>nul & @echo  Headset sent for reboot & goto  _returnmenu
@%MYFILES%\adb reboot
@echo ========================================
rem @echo  Шлем отправлен в перезагрузку
@echo  Headset sent for reboot.

@goto _returnmenu

:_rbootloader
@%MYFILES%\adb reboot bootloader
call :_erlvl
@echo ========================================
rem @echo  Шлем будет загружен в режим Bootloader
@echo  Headset will boot into Bootloader mode.

@goto _returnmenu

:_rrecovery
@%MYFILES%\adb reboot recovery
call :_erlvl
@echo ========================================
goto _eng2
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
:_eng2
@echo  Headset will boot into Recovery mode.
@echo.
@echo  Wait for the dead Android and "No Command" message.
@echo  (the LED will light up white, then purple)
@echo.
@echo  Then, while holding the Power button on the headset,
@echo  briefly press Volume+ (far button from the nose).
@echo.
@echo  After that, release the Power button.
@echo  A blue-yellow Android Recovery menu should appear.
@echo  If everything goes as planned, you're in the right place.
@goto _returnmenu

:_rfastboot
@%MYFILES%\adb reboot fastboot
call :_erlvl
@echo ========================================
@echo  Headset will boot into Fastboot mode.
@echo  Шлем будет загружен в режим Fastboot
@goto _returnmenu

:_rsideload
@%MYFILES%\adb.exe reboot bootloader
call :_erlvl
@echo ========================================
rem @echo  Шлем будет загружен в режим Sideload (обычный вариант)
rem @echo  Загружаемся сначала в бутлоадер.. Секундочку...
rem @echo  [ светодиод будет гореть оранжевым ]
@echo  Headset will boot into Sideload mode (regular variant).
@echo  Booting into the bootloader first... Just a moment...
@echo  [the LED will be orange]

@ping localhost -n 12 >nul
@echo.
@echo ----------------------------------------
@%MYFILES%\fastboot.exe oem reboot-sideload 1>NUL 2>&1
rem @echo   Переключаемся в режим Sideload.. Еще чуточку терпения...
rem @echo   [ светодиод загорится белым, затем фиолетовым ]
@echo  Switching to Sideload mode... Just a little more patience...
@echo  [the LED will light up white, then purple]

@ping localhost -n 14 >nul
goto _sideloadmode

:_rasideload
@%MYFILES%\adb reboot sideload
call :_erlvl
@echo ========================================
rem @echo  Шлем будет загружен в режим Sideload (альтернативный вариант)
rem @echo  [ светодиод загорится белым, затем фиолетовым ]
@echo  Headset will boot into Sideload mode (alternate variant).
@echo  [the LED will light up white, then purple]

@ping localhost -n 14 >nul
goto _sideloadmode

:_checkmode
rem call :_cdc
rem @%MYFILES%\adb devices | find "sideload" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 do (
rem @echo ========================================
rem @echo +++ Шлем в режиме Sideload +++
rem goto _returnmenu
rem )

rem @%MYFILES%\fastboot devices | find "fastboot" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 do (
rem goto _fbtbtldmode
rem ) else (
rem rem @If %ERRORLEVEL%==1 
rem @echo ========================================
rem @echo +++ Шлем в штатном режиме +++
rem goto _returnmenu

rem @%MYFILES%\fastboot devices | find "recovery" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 do (
rem call :_recoverymode
rem )
rem goto _returnmenu

@%MYFILES%\adb devices | find "sideload" 1>nul 2>nul
rem @If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo +++ Шлем в режиме Sideload +++ & goto _returnmenu
@If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo @echo +++ Headset in Sideload mode +++ & goto _returnmenu
@%MYFILES%\adb devices | findstr "device"$ 1>nul 2>nul
rem @If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo +++ Шлем в штатном режиме +++ & goto _returnmenu
@If %ERRORLEVEL%==0 @echo ======================================== ^ & @echo +++ Headset in Normal mode +++ & goto _returnmenu
@%MYFILES%\fastboot devices | find "fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==0  goto _fbtbtldmode
rem @If %ERRORLEVEL%==1 @echo ======================================== ^ & @echo +++ Шлем в режиме Recovery +++ & call :_recoverymode
@If %ERRORLEVEL%==1 @echo ======================================== ^ & @echo +++ Headset in Recovery mode +++ & call :_recoverymode
goto _returnmenu

:_fbtbtldmode
@echo ======================================== 
@echo.
rem @echo  Если на экране шлема желто-синее меню, светодиод фиолетовый и надпись FASTBOOTD - 
rem @echo      - вы в режиме +++ Fastboot +++
rem @echo.
rem @echo  Если на экране бело-синее меню, светодиод оранжевый и надпись USB Update Mode - 
rem @echo     - вы в режиме +++ Bootloader +++ 
@echo  If you see a yellow-blue menu on the headset screen, the LED is purple, and the message is FASTBOOTD - 
@echo      - you are in +++ Fastboot +++ mode.
@echo.
@echo  If you see a white-blue menu on the screen, the LED is orange, and the message is USB Update Mode - 
@echo     - you are in +++ Bootloader +++ mode.

goto _returnmenu

:_recoverymode
@echo ======================================== 
@echo.
goto _eng3
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
@echo  If the LED is purple, and on the headset display,
@echo  there's a dead Android and the message No Command - 
@echo      - you are ALMOST in +++ Recovery +++ mode.
@echo.
:_eng3
@echo  Now, while holding the Power button on the headset, 
@echo  briefly press Volume+ (far button from the nose).
@echo  After that, release the Power button.
@echo  A blue-yellow Android Recovery menu should appear.
@echo  If everything goes as planned, you're in the right place:
@echo      - in +++ Recovery +++ mode.

@exit /b

:_sideloadmode
call :_hat
@echo.
@echo.
@echo.
rem @echo     +++++ Шлем в режиме Sideload +++++
@echo     +++++ Headset in Sideload mode +++++

@echo.
@echo.
@echo.
call :_hatmenu
@echo.
goto _eng4
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
:_eng4
@echo    F.  Load firmware into headset
@echo    R.  Reboot headset
@echo.
@echo.
@echo    IMPORTANT:
@echo. 
@echo  After selecting option F and pressing Enter
@echo  firmware loading will start immediately, without confirmation.
@echo.  
@echo  The firmware file must be named update.zip
@echo  and should be located next to the program.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _sideloadmode
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="f" (GOTO _FirmwareUpload)
if /i "%choice%"=="r" (GOTO _menurestart)
cls
goto _sideloadmode

:_hsshutdown
@%MYFILES%\adb shell reboot -p 1>nul 2>nul
call :_erlvl
@echo ========================================
rem @echo  Шлем выключается....
@echo  Headset is turning off...
@goto _returnmenu

:_screenshotmenu
call :_hat
call :_hatmenu
@echo.
rem @echo    C.  Одиночный скриншот шлема
rem @echo    B.  Серия скриншотов шлема, каждый скриншот по нажатию клавиши	[EXP]
rem @echo    S.  Серия автоматических скриншотов с заданным интервалом		[EXP]
@echo    C.  Single screenshot of the headset
@echo    B.  Series of headset screenshots, one per key press    [EXP]
@echo    S.  Series of automatic screenshots with a specified interval    [EXP]

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
rem @echo  Немного терпения, создается скриншот..
@echo  Please wait, creating a screenshot...
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
rem @echo  Скриншот сохранен в текущем каталоге.
rem @echo  Через пару секунд будет открыт программой по умолчанию.
@echo  Screenshot is saved in the current directory.
@echo  It will be opened by the default program in a couple of seconds.

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
rem @echo  Немного терпения, создается скриншот..
@echo  Please wait, screenshot is being created...
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
rem @echo  Скриншот сохранен в текущем каталоге.
@echo  Screenshot saved in the current directory.
@echo 
::@start Screenshot_%mydate%_%mytime%.png
rem @echo  Нажмите Enter для создания следующего скриншота
rem @echo  Для завершения и выхода в меню введите 0 и нажмите Enter
@echo  Press Enter to create the next screenshot
@echo  To finish and return to the menu, enter 0 and press Enter

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
rem set /p intscrn="Введите интервал в секундах или 0 для выхода в меню и нажмите Enter : "
set /p intscrn="Enter the interval in seconds or 0 to return to the menu and press Enter: "

If %intscrn%==0 goto :_screenshotmenu
:_screenshotseriesauto1
call :_cdc
@cls
call :_hat
@echo.
@echo.
rem @echo  Один бип - "Приготовиться, снимаю!"
rem @echo  Два бипа - "Снято!"
@echo  One beep - "Get ready, taking the screenshot!"
@echo  Two beeps - "Screenshot has been taken!"

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
rem @echo  Один бип - "Приготовиться, снимаю!"
rem @echo  Два бипа - "Снято!"
@echo  One beep - "Get ready, taking the screenshot!"
@echo  Two beeps - "Screenshot has been taken!"
@echo.
@echo ========================================
rem @echo  Скриншот сохранен в текущем каталоге.
rem @echo ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
@echo  Screenshot was saved in the current directory.
@echo ^>^>^> Press any key to interrupt ^<^<^<

@echo 
::@ping localhost -n %intscrn% >nul
rem timeout %intscrn%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
timeout %intscrn%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure was interrupted +++ ^ & @echo. ^ & @goto _returnmenu
@goto _screenshotseriesauto1

:_scrshcopy
@%MYFILES%\adb pull "/sdcard/Oculus/Screenshots" %userprofile%\Desktop >nul
call :_erlvl
@echo ========================================
rem @echo  Скриншоты скопированы в каталог Screenshots на Рабочий стол
rem @echo  Каталог будет открыт через пару секунд
@echo  Screenshots were copied to the Screenshots directory on the Desktop
@echo  The directory will open in a couple of seconds

@ping localhost >nul
@explorer %userprofile%\Desktop\Screenshots >nul
@goto _returnmenu

:_adbwifi
call :_cdc
rem @echo  Отключаем предыдущие соединения...
@echo  Disconnecting previous connections...
@%MYFILES%\adb.exe disconnect >nul
@echo.
rem @echo  Ждем инициализаци порта...
@echo  Waiting for port initialization...
@%MYFILES%\adb tcpip 5555 >nul
@ping localhost >nul
@echo.
::@echo Подключаемся к шлему по IP %ip%...
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|find "inet "') DO set ipfull=%%G
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO set ip=%%G
@if [%ip%]==[] goto _noip
rem @echo  Подключаемся к шлему по IP %ip%...
@echo  Connecting to the headset by IP %ip%...
@%MYFILES%\adb connect %ip% 1>nul 2>nul
@echo.
@ping localhost >nul
::@%MYFILES%\adb devices
@echo ========================================
rem @echo  Отсоедините кабель, шлем подключен по Wi-Fi.
rem @echo  Имейте в виду: c подключенным кабелем у вас будет ДВА устройства:
@echo  Disconnect the cable, the headset is connected via Wi-Fi.
@echo  Note: with the cable connected, you will have TWO devices:

@echo.
@%MYFILES%\adb devices
rem @echo  Это может вызвать ошибку "error: more than one device/emulator" 
@echo  This may cause the error "error: more than one device/emulator".
@goto _exitout

:_noip
@echo ========================================
rem @echo  Шлем не получил IP адрес от роутера!
rem @echo  Проверьте подключение шлема к WiFi.
@echo  The headset did not receive an IP address from the router!
@echo  Check the headset's connection to Wi-Fi.

@goto _returnmenu

:_reconnect
rem call :_cdc
@echo.
rem @echo Секунду, идет переподключение на кабель...
@echo  One moment, reconnecting via cable...
@%MYFILES%\adb kill-server
@%MYFILES%\adb start-server 1>nul 2>nul
@echo.
if errorlevel==1 goto _notfound
rem @%MYFILES%\adb.exe devices 
@echo ========================================
rem @echo  Шлем переподключен
@echo  Headset reconnected.
@goto _returnmenu

:_usbflash
call :_cdc
@%MYFILES%\adb shell svc usb setFunctions mtp true
call :_erlvl
@start explorer.exe
@echo ========================================
rem @echo  Шлем подключен как съемный диск
@echo  Headset connected as a removable disk.

@goto _returnmenu

:_opensslerrorfix
rem @echo  Задаем системную переменную
@echo  Setting the system variable.
@echo OPENSSL_ia32cap ~0x20000000
@setx OPENSSL_ia32cap ~0x20000000 /M
@ping localhost >nul
@echo ========================================
rem @echo  Системная переменная прописана
@echo  System variable set
@goto _returnmenu

:_ocsrvrestart
rem @echo  Рестартуем сервис, немного терпения...
@echo  Restarting the service, please wait...
@net stop OVRservice 1>nul 2>nul
@net start OVRservice 1>nul 2>nul
@if ERRORLEVEL == 1 GOTO _nosrv
@echo ========================================
rem @echo  Сервис перезапущен
@echo  Service restarted
@goto _returnmenu

:_nosrv
@echo ========================================
rem @echo  Служба OVRservice не найдена! Нечего перезапускать.
@echo  OVRservice not found! Nothing to restart.
@goto _returnmenu

:_shellrestart
rem call :_cdc
rem @echo  Перезапускаем оболочку, ждите...
@echo  Restarting the shell, please wait...
@%MYFILES%\adb shell am kill com.oculus.vrshell 1>nul 2>nul
call :_erlvl
@%MYFILES%\adb shell am force-stop com.oculus.vrshel 1>nul 2>nul
@%MYFILES%\adb shell pm disable-user --user 0 com.oculus.shellenv 1>nul 2>nul
@%MYFILES%\adb shell pm enable com.oculus.shellenv 1>nul 2>nul
@ping localhost >nul
@echo.
@echo ========================================
rem @echo  Оболочка перезапущена
@echo  Shell restarted
call :_prevmenu
@goto _shellmenu

:_shellrestart2
:: --- Альтернативный вариант ---
rem @echo  Перезапускаем оболочку, ждите...
@echo  Restarting the shell, please wait...
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
rem @echo  Оболочка перезапущена
@echo  Shell restarted
call :_prevmenu
@goto _shellmenu

:_openvpn
call :_cdc
rem @echo  Открываем настройки VPN в шлеме...
@echo  Opening VPN settings on the headset...
@%MYFILES%\adb shell "am start -n 'com.android.settings/.Settings$VpnSettingsActivity'" >nul
@ping localhost >nul
@echo ========================================
rem @echo  Настройки должны быть открыты, наденьте шлем.
@echo  Settings should be open, put on the headset.

@goto _returnmenu

:_wificontrol
call :_hat
call :_hatmenu
@echo.
rem @echo    D.  Отключение Wi-Fi на шлеме
rem @echo    E.  Включение Wi-Fi на шлеме
rem @echo    F.  Рестарт Wi-Fi на шлеме
@echo    D.  Disable Wi-Fi on the headset
@echo    E.  Enable Wi-Fi on the headset
@echo    F.  Restart Wi-Fi on the headset

@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _wificontrol
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="d" (GOTO _wifidisable)
if /i "%choice%"=="e" (GOTO _wifienable)
if /i "%choice%"=="f" (GOTO _wifirestart)
@cls
goto _wificontrol

:_wifidisable
:::::::::::::::::
@%MYFILES%\adb shell "svc wifi disable"
call :_erlvl
@echo ========================================
rem @echo  Wi-Fi отключен
@echo  Wi-Fi disabled
call :_prevmenu
@goto _shellmenu

:_wifienable
:::::::::::::::::
@%MYFILES%\adb shell "svc wifi enable"
call :_erlvl
@echo ========================================
rem @echo  Wi-Fi включен
@echo  Wi-Fi enabled
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


:_autosenderr
rem @%MYFILES%\adb shell pm disable-user --user 0 com.oculus.presence
call :_erlvl
@echo ========================================
rem @echo  Опция отключения автоотправки отчетов удалена.
rem @echo  Отключить и включить ее можно через мобильное приложение:
rem @echo  Настройки гарнитуры - Расширенный настройки.
@echo  The option for disabling automatic report sending has been removed.
@echo  You can disable and enable it through the mobile application:
@echo  Headset Settings - Advanced Settings.

@goto _returnmenu

:_homescreen
@%MYFILES%\adb shell am start -a android.intent.action.MAIN -c android.intent.category.HOME 1>nul 2>nul
::@%MYFILES%\adb shell input keyevent 3
call :_erlvl
@echo ========================================
rem @echo  В шлеме вы увидите стандартное Виртуальное окружение
@echo  In the headset, you will see the standard Virtual Environment.
call :_prevmenu
@goto _shellmenu

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
:: Quest Update Tool
::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_fwmenu
cls
endlocal
@echo.
@echo.
rem @echo  ADB запускается...
@echo  ADB is starting...
@call :_SetFirmwareFileName

setlocal enableextensions enabledelayedexpansion

@call :_CheckSideloadMode
@call :_CheckBootloaderMode
::@call :_CheckCableMode
::@call :_CheckWiFiMode
::@call :_CheckDoubleOrNoDeviceMode
::@call :_CheckDevMode
::@call :_CheckAfterWiFiCheckMode
:: Меню прошивки
:_fwmenuskip
@cls
echo off
call :_hatqut
call :_hatmenu
@echo.
@echo.
@echo.
goto _eng5
@echo    A.  Полностью автоматическая прошивка
@echo        [ требуется режим разработчика ]
@echo.
@echo    B.  Кнопочная автоматическая прошивка
@echo        [ режим разработчика не требуется, но убедитесь что шлем загружен в Bootloader ]
@echo.
@echo    C.  Извлечь ссылку на прошивку из шлема   [EXP]
@echo        [ cсылка на прошивку сохранится в файл link.txt и начнется скачивание ]
@echo.
@echo    D.  Скачать различные версии прошивок для Oculus Quest 2
@echo        [ откроются сайты со списком прошивок для скачивания]
@echo.
@echo    E.  Показать текущую версию прошивки шлема и проверить актуальность
@echo.
@echo    F.  Анализатор прошивок: проверка файла %FirmwareFileName% на корректность и совместимость
@echo.       [ отображение версий прошивок шлема, файла %FirmwareFileName% и модели шлема ]
@echo    FF. [ дополнительные пояснения про инкрементальные прошивки]
@echo.
@echo    G.  Открыть сайт с прошивками
:_eng5
@echo    A.  Fully automatic firmware flashing
@echo        [developer mode required]
@echo.
@echo    B.  Button-triggered automatic firmware flashing
@echo        [developer mode not required, but ensure the headset is in Bootloader mode]
@echo.
@echo    C.  Extract firmware link from the headset   [EXP]
@echo        [the firmware link will be saved in the link.txt file and downloading will start]
@echo.
@echo    D.  Open the website with firmware versions
rem @echo    D.  Download various firmware versions for Oculus Quest 2
rem @echo        [websites with lists of firmware versions will open for downloading]
@echo.
@echo    E.  Show the current firmware version of the headset and check for updates
@echo.
@echo    F.  Firmware analyzer: check the %FirmwareFileName% file for correctness and compatibility
@echo.       [displaying headset firmware versions, %FirmwareFileName% file, and headset model]
@echo    FF. [additional explanations about incremental firmware updates]
@echo.
@echo.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _fwmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _firmwareauto)
if /i "%choice%"=="b" (GOTO _firmwarebutton)
if /i "%choice%"=="c" (GOTO _fwdownload)
::if /i "%choice%"=="cc" (GOTO _fwdownload)
rem if /i "%choice%"=="d" (GOTO _fwlinkdownload)
if /i "%choice%"=="d" (GOTO _fwsitelink)
rem if /i "%choice%"=="e" (GOTO _fversion)
if /i "%choice%"=="e" (GOTO _fwtxtcompare)
if /i "%choice%"=="f" (GOTO _CheckFirmwareUpdate)
if /i "%choice%"=="ff" (GOTO _DopHelp)
rem if /i "%choice%"=="g" (GOTO _fwsitelink)
if /i "%choice%"=="h" (call :_fwhelp)
if /i "%choice%"=="ftp" (GOTO _ftpmenu)

@cls
goto _fwmenu

:_fwsitelink
@start " " "https://cocaine.trade/"
goto :_fwmenuskip

:_fwhelp
::@echo.
::@echo.
@echo.
@echo.
@echo ----------------------------------------------------------------------
rem @echo    ee	: Сравнить версии, если новее, записать в fw.txt и выгрузить
rem @echo    ff	: Дополнительный help по инкрементным прошивкам
rem @echo    ftp	: Загрузить/выгрузить файлы fw и alllimks
@echo    ee	: Compare versions, if newer, write to fw.txt and download
@echo    ff	: Additional help on incremental firmware updates
@echo    ftp	: Upload/download fw and all links files
@echo ----------------------------------------------------------------------
@echo.
@echo.
call :_prevmenu
exit /b


:_ftpmenu
cls
call :_hat
call :_hatmenu
@echo.
@echo.
goto _eng6
@echo       +++  СЕРВИСНОЕ МЕНЮ^^^! +++
@echo  ИСПОЛЬЗУЕТСЯ ТОЛЬКО ДЛЯ СЛУЖЕБНЫХ ЦЕЛЕЙ.
@echo.
@echo.
@echo    A.   Скачать fw.txt
@echo    A1.  Скачать fw1.txt
@echo    A2.  Скачать fw2.txt
@echo    A3.  Скачать fw3.txt
@echo    AP.  Скачать fwp.txt
@echo    AA.  Скачать все fw.txt разом
@echo.
@echo    B.   Залить fw.txt на FTP
@echo    B1.  Залить fw1.txt на FTP
@echo    B2.  Залить fw2.txt на FTP
@echo    B3.  Залить fw3.txt на FTP
@echo    BP.  Залить fwp.txt на FTP
@echo.
@echo    C.  Скачать allinls.txt
@echo    D.  Залить alllinks.txt на FTP
@echo    E.  Скачать alllinks.txt, удалить дубли строк и залить на FTP
@echo.
@echo    F.  Меню прошивки
@echo    G.  Скачать и забэкапить все файлы
:_eng6
@echo       +++  SERVICE MENU^^^! +++
@echo  FOR SERVICE PURPOSES ONLY.
@echo.
@echo.
@echo    A.   Download fw.txt
@echo    A1.  Download fw1.txt
@echo    A2.  Download fw2.txt
@echo    A3.  Download fw3.txt
@echo    AP.  Download fwp.txt
@echo    AA.  Download all fw.txt at once
@echo.
@echo    B.   Upload fw.txt to FTP
@echo    B1.  Upload fw1.txt to FTP
@echo    B2.  Upload fw2.txt to FTP
@echo    B3.  Upload fw3.txt to FTP
@echo    BP.  Upload fwp.txt to FTP
@echo.
@echo    C.  Download allinls.txt
@echo    D.  Upload alllinks.txt to FTP
@echo    E.  Download alllinks.txt, remove duplicate lines, and upload to FTP
@echo.
@echo    F.  Firmware menu
@echo    G.  Download and backup all files

@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _ftpmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (set fwtxt=fw.txt && call :_GetFTPfwtxt)
if /i "%choice%"=="a1" (set fwtxt=fw1.txt && call :_GetFTPfwtxt)
if /i "%choice%"=="a2" (set fwtxt=fw2.txt && call :_GetFTPfwtxt)
if /i "%choice%"=="a3" (set fwtxt=fw3.txt && call :_GetFTPfwtxt)
if /i "%choice%"=="ap" (set fwtxt=fwp.txt && call :_GetFTPfwtxt)
if /i "%choice%"=="aa" (goto _DownloadAllFWfiles)
if /i "%choice%"=="b" (set fwtxt=fw.txt && call :_PutFTPfwtxt)
if /i "%choice%"=="b1" (set fwtxt=fw1.txt && call :_PutFTPfwtxt)
if /i "%choice%"=="b2" (set fwtxt=fw2.txt && call :_PutFTPfwtxt)
if /i "%choice%"=="b3" (set fwtxt=fw3.txt && call :_PutFTPfwtxt)
if /i "%choice%"=="bp" (set fwtxt=fwp.txt && call :_PutFTPfwtxt)
if /i "%choice%"=="c" (call :_GetFTPalllinks)
if /i "%choice%"=="d" (call :_PutFTPlllinks)
if /i "%choice%"=="e" (call :_AlllinksNoDoubles)
if /i "%choice%"=="f" (GOTO _fwmenu)
if /i "%choice%"=="g" (GOTO _fwtxtbackup)
@cls
goto _ftpmenu

:_DownloadAllFWfiles
set fwtxt=fw.txt
call :_GetFTPfwtxt
set fwtxt=fw1.txt
call :_GetFTPfwtxt
set fwtxt=fw2.txt
call :_GetFTPfwtxt
set fwtxt=fw3.txt
call :_GetFTPfwtxt
set fwtxt=fwp.txt
call :_GetFTPfwtxt
@echo ---------------
rem @echo = Все fw.txt скачаны
@echo = All fw.txt files downloaded

@echo.
call :_prevmenu
goto _ftpmenu

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
@%myfiles%\7z.exe a -mx7 -t7z ftpfiles-%dt%.7z %~dp0\ftp
@move ftpfiles-%dt%.7z d:\P\Dropbox\SecureWallet\HomeDevices\Quest\Backups\
@rd /s /q %~dp0\ftp
echo ---------------------------------
rem echo  = Готово
echo  = Done
echo.
goto _prevmenu
goto _ftpmenu


:: FTPfw
:_GetFTPfw
call :_SetFWtxtFileName
:_GetFTPfwtxt
set ftpfile=%fwtxt%
call :_GetFTP
@echo ---------------
rem @echo = %fwtxt% скачан
@echo  = %fwtxt% downloaded
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
rem @echo = %fwtxt% залит на FTP
@echo = %fwtxt% uploaded to FTP

@echo.
call :_prevmenu
exit /b

::FTPalllinks
:_GetFTPalllinks
set ftpfile=alllinks.txt
call :_GetFTP
@echo ---------------
rem @echo = alllinks.txt скачан
@echo = alllinks.txt downloaded
@echo.
call :_prevmenu
exit /b

:_PutFTPlllinks
set ftpfile=alllinks.txt
call :_PutFTP
@echo ---------------
rem @echo = allinks.txt залит на FTP
@echo = allinks.txt uploaded to FTP
@echo.
call :_prevmenu
exit /b

:_AlllinksNoDoubles
set ftpfile=alllinks.txt
call :_GetFTP
ren alllinks.txt alllinksdoubles.txt
@for /f "tokens=*" %%a in (alllinksdoubles.txt) do (
@findstr /l /c:"%%a" alllinks.txt 1>nul 2>nul || @echo %%a>>alllinks.txt
)
call :_PutFTP
@del alllinks.txt /q /f 1>nul 2>nul
@del alllinksdoubles.txt /q /f 1>nul 2>nul
@echo ---------------
rem @echo = allinks.txt очищен от дублирующих строк
@echo = alllinks.txt cleaned from duplicate lines
@echo.
@echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
@echo ^>^>^> Press anything to return to the previous menu ^<^<^<

@pause 1>nul 2>nul
exit /b
goto _ftpmenu

:_CheckFirmwareUpdate
@echo off
setlocal enableextensions enabledelayedexpansion
:: Проверка на корректность файла прошивки
::if exist "%FirmwareFileName%.zip" ren "%FirmwareFileName%.zip" "%FirmwareFileName%"
::echo %FirmwareFileName%
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
rem @echo     +++++ С файлом %FirmwareFileName% что-то не так +++++
@echo     +++++ Something is wrong with the %FirmwareFileName% file +++++
::@echo.
@echo.
@echo.
rem @echo  ТЕКСТ ОШИБКИ:
@echo  ERROR TEXT:
@echo -----------------------------------------------------
@type error.txt
@echo -----------------------------------------------------
@echo.
@del error.txt /f /q
goto _returnmenu

:_ViewFirmware
@echo.
rem @echo +++ Минутку, анализируем данные...
@echo +++ Just a moment, analyzing the data...
call :_ExtractBuildVersionsNumbers
call :_ExtractFirmwareVersion
call :_ExtractPreBuildNumber
call :_CheckBuildsFullInc
call :_ViewAndCompateDeviceName
call :_CompareVersion
rem cls

::!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@if %fwpreb%==----------- (set incfull=-Full) else (set incfull=-inc-for-%fwpreb%)
rem @ren update.zip %fmfilename%-%fwnfilename%%incfull%.zip 2>nul 1>nul
rem @ren update.zip %fmfilename%-!fwpostn!%incfull%.zip 2>nul 1>nul
@ren update.zip %fmfilename%-%fwpostn%%incfull%.zip 2>nul 1>nul
call :_hat
@echo.
rem @echo					=== АНАЛИЗАТОР ПРОШИВОК ===
@echo					=== FIRMWARE ANALYZER ===
@echo.
@echo  --------------------------------------------------------------------------------------------------
rem @echo. Версия прошивки шлема		: %fwver%	: %headbuild%	: Модель шлема	: %DevModelNm%
rem @echo. Версия файла прошивки		: !fwpostn!	: %postbuild%	: Прошивка для	: %UpzModelNm%
rem @echo. Версия подложки инкремента	: !fwpreb!	: %prebuild%	: Совместимость	: %IntPrdCompt%
rem @echo. Полная/Инкрементная		: %setfullinc%	:			:
@echo. Headset firmware version		: %fwver%	: %headbuild%	: Headset model	: %DevModelNm%
@echo. Firmware file version		: !fwpostn!	: %postbuild%	: Firmware for	: %UpzModelNm%
@echo. Increment base version		: !fwpreb!	: %prebuild%	: Compatibility	: %IntPrdCompt%
@echo. Full/Incremental			: %setfullinc%	:			:
@echo  --------------------------------------------------------------------------------------------------
@echo.
goto _eng7
@echo  Версия подложки инкремента - это Версия прошивки шлема, 
@echo  для которой предназначен именно этот инкремент.
@echo.
@echo  Иначе говоря, Версия прошивки шлема: 	[ %fwver% ]
@echo  и Версия подложки инкремента: 		[ %fwpreb% ] 
@echo  должны быть одинаковыми.
@echo.
@echo  Если прошивка полная, версия инкремента не отображается
@echo.
@echo  А версия файла %FirmwareFileName% должна быть выше версии прошивки шлема.
@echo  Мы же собираемся обновлять прошивку, не так ли?
@echo.
@echo  ----------------------------------------------
@echo  == РЕЗУЛЬТАТ ПРОВЕРКИ:
:_eng7
@echo  The increment base version is the headset firmware version 
@echo  for which this increment is intended.
@echo.
@echo  In other words, Headset firmware version: 	[ %fwver% ]
@echo  and Increment base version: 			[ %fwpreb% ] 
@echo  should be the same.
@echo.
@echo  If the firmware is uptodate, the increment version is not displayed.
@echo.
@echo  And the version of the %FirmwareFileName% file should be newer than the headset firmware version.
@echo  After all, we are going to update the firmware, aren't we?
@echo.
@echo  ----------------------------------------------
@echo  == CHECK RESULT:
::@echo.
rem rem @del fw.txt 2>&1 1> nul | find /V "" 1> nul 2>&1
@del %fwtxt% 2>&1 1> nul | find /V "" 1> nul 2>&1
if %errorlevel%==0 goto _NoInternetMessage
::@del fw.txt /q 1>NUL 2>&1
if not [%bl%]==[] goto _blmessage
@For /F %%r In ('@%myfiles%\adb shell getprop ro.boot.serialno') Do set sn=%%r
if [%sn%]==[] goto _NoHeadsetMessage
if %IntProductName% NEQ %UpZipIntProductName% goto _Uncompatible

call :_ChoiceFunctions

:_ExtractBuildVersionsNumbers
@%myfiles%\7z.exe e %FirmwareFileName% metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"post-build-incremental" metadata') DO @set postbuild=%%k
@FOR /F "tokens=2 delims==" %%t IN ('@FINDstr /c:"pre-build-incremental" metadata') DO @set prebuild=%%t
@For /F %%f In ('@%MYFILES%\adb shell getprop ro.build.version.incremental') Do set headbuild=%%f
if [%prebuild%]==[] set prebuild=-----------------
if [%headbuild%]==[] set headbuild=-----------------
del metadata /q
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
rem IF %errorlevel% == 0 goto _fw
rem %MYFILES%\wget -q --no-hsts "https://drive.google.com/uc?export=download&id=1qu2UsiYv-4_72-SAqZXqV7ruUb0P3bjH" -O fw.txt  1>NUL 2>&1
rem IF %errorlevel% == 0 goto _fw
rem %MYFILES%\wget -q --no-hsts https://www.dropbox.com/s/fusen2ueqgw7rtp/fw.txt  1>NUL 2>&1
rem IF %errorlevel% == 0 goto _fw
rem %MYFILES%\wget -q --no-hsts https://www.dropbox.com/s/zy94s45hrfa3pbj/fw.txt  1>NUL 2>&1
rem IF %errorlevel% == 0 goto _fw

:_fw
echo off
@For /F "tokens=1,2 delims= " %%a In (%fwtxt%) Do (
@set fwpostbuildfile=%%a
@set fwpostn=%%b
if !postbuild! == !fwpostbuildfile! (
exit /b
) else (
rem echo %fwtxt%
rem echo fwpbf !fwpostbuildfile!
rem echo fwp !fwpostn!
rem pause
rem @set "fwpostn=Неизвестно"
set fwpostn=Unknown
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
rem @set "fwpreb=Неизвестно"
@set "fwpreb=Unknown"
)
)
exit /b

:_CheckBuildsFullInc
::@if not exist fw.txt set fwpreb=Интернет йок & set fwpostn=Интернет йок
rem rem @if not exist fw.txt set fwpreb=No Internet. & set fwpostn=No Internet.
@if not exist %fwtxt% set fwpreb=No Internet. & set fwpostn=No Internet.

if %prebuild%==----------------- (
rem set setfullinc=Полная
@set setfullinc=Full

) else (
rem set setfullinc=Инкрементная
@set setfullinc=Incremental

)
exit /b

:_ChoiceFunctions
if %prebuild%==----------------- (
call :_CompareHeadPostbuild
) else (
call :_CompareHeadPrebuild
)
exit /b

:_CompareHeadPostbuild
set num1=%headbuild%
set num2=%postbuild%
set "tmp1=                 %num1%"
set "tmp2=                 %num2%"
set headpad="%tmp1:~-17%"
set postpad="%tmp2:~-17%"
if %postpad% == %headpad% (
@echo.
@echo  -----------------------------------------------------------------
rem @echo  ^|   +++ На шлеме и в файле %FirmwareFileName% одинаковые прошивки +++   ^|
@echo  ^|   +++ The headset and %FirmwareFileName% file have the same firmware versions +++   ^|
@echo  -----------------------------------------------------------------
@echo.
rem @echo   Прошить не получится.
@echo   Firmware flashing is not possible.
goto _FlashMenuNo
) else (
if %headpad% gtr %postpad% (
@echo.
@echo  ---------------------------------------------------------------------
rem @echo  ^|   +++ На шлеме более новая прошивка, чем в файле %FirmwareFileName% +++   ^|
@echo  ^|   +++ The headset has a newer firmware version than in the %FirmwareFileName% file +++   ^|
@echo  ---------------------------------------------------------------------
@echo.
rem @echo   Прошить не получится.
@echo   Firmware flashing is not possible.
goto _FlashMenuNo
) else (
@echo.
@echo  --------------------------------------------------------------------
rem @echo  ^|   +++ В файле %FirmwareFileName% более новая прошивка, чем в шлеме +++   ^|
@echo  ^|   +++ The %FirmwareFileName% file has a newer firmware version than the headset +++   ^|
@echo  --------------------------------------------------------------------
@echo.
rem @echo   Можно прошивать.
@echo   Firmware update is possible.
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
rem @echo  ^|   +++ Версия подложки инкремента совпадает с версией прошивки шлема +++   ^|
@echo  ^|   +++ Increment base version matches the headset firmware version +++   ^|
@echo  -----------------------------------------------------------------------------
@echo.
@echo   Можно прошивать.
goto _FlashMenuYes
) else (
@echo.
@echo  --------------------------------------------------------------------------------
rem @echo  ^|   +++ Версия подложки инкремента не совпадает с версией прошивки шлема +++   ^|
@echo  ^|   +++ Increment base version does not match the headset firmware version +++   ^|
@echo  --------------------------------------------------------------------------------
@echo.
rem @echo   Прошить не получится.
@echo   Firmware flashing is not possible.
goto _FlashMenuNo
)

:_FlashMenuNo
@echo.
rem @echo   Но вы можете попробовать прошиться, на свой страх и риск.
rem @echo   Ничего критичного быть не должно, шлем просто не прошьется.
@echo   But you can try to flash it at your own risk.
@echo   There shouldn't be anything critical, the headset just won't be flashed.

@echo.
:_FlashMenuYes
@echo.
@echo.
@echo. %veryold1%
@echo. %veryold2%
@echo. %veryold3%
@echo.
@echo.
rem @echo ^>^>^> Нажмите любую кнопку для возврата в меню прошивки ^<^<^<
@echo ^>^>^> Press any key to return to the firmware menu ^<^<^<
@pause >nul
goto :_fwmenuskip
::exit

:_CompareVersion
::set fwver="37.0.0.137
rem if %fwver:~1,2% GTR 38 (
rem exit /b
rem ) else (
rem set veryold1=Прошивка слишком старая. 
rem set veryold2=В этом случае следует шить в таком порядке:
rem set veryold3=Сначала обновление до v.50, затем можно самую последнюю.
exit /b
rem )


:_fwlinkdownload
@start " " "https://quest2vr.ru/прошивки-для-quest-2/"
@start " " "https://cocaine.trade/"
@start " " "https://app.koofr.net/links/9dcb7fff-03a5-4ad0-7b96-04258c02be15"
@echo.
@echo.
goto :_fwmenuskip
rem @echo ^>^>^> Нажмите любую кнопку для возврата в меню прошивки ^<^<^<
@echo ^>^>^> Press any key to return to the firmware menu ^<^<^<
@pause >nul

:_DopHelp
goto _eng8
@echo. >>dophelp.txt
@echo. >>dophelp.txt
@echo   Допустим, у нас прошивка в шлеме: 10.10 >>dophelp.txt
@echo. >>dophelp.txt
@echo   А шить мы собираемся такую: 20.10 >>dophelp.txt
@echo. >>dophelp.txt
@echo   И если она инкрементая, то есть - частичная, ее можно прошивать >>dophelp.txt
@echo   только на определенную версию в шлеме. >>dophelp.txt
@echo. >>dophelp.txt
@echo   Для этого в файле прошивки дополнительно указывается номер >>dophelp.txt
@echo   версии прошивки шлема,на которую можно прошивать. >>dophelp.txt
@echo   Эта версия и есть подложка инкремента. >>dophelp.txt
@echo. >>dophelp.txt
@echo   Например, у нас есть файл прошивки с версией 20.10 >>dophelp.txt
@echo   она новее, чем в шлеме (10.10). >>dophelp.txt
@echo   но при этом подложка у файла версии 10.50. >>dophelp.txt
@echo. >>dophelp.txt
@echo   И выходит, что версия файла прошивки хоть и выше шлемовой, >>dophelp.txt
@echo   но данный апдейт предназначен ТОЛЬКО для шлемов с версией 10.50, >>dophelp.txt
@echo   а у нас шлем с прошивкой 10.10 >>dophelp.txt
@echo. >>dophelp.txt
@echo   Стало быть, прошить не получится. >>dophelp.txt
@echo. >>dophelp.txt
@echo. >>dophelp.txt
@echo. >>dophelp.txt
:_eng8
@echo. >>dophelp.txt
@echo. >>dophelp.txt
@echo   For example, we have firmware in the headset: 10.10 >>dophelp.txt
@echo. >>dophelp.txt
@echo   And we are going to flash such firmware: 20.10 >>dophelp.txt
@echo. >>dophelp.txt
@echo   And if it is incremental, i.e., partial, it can be flashed >>dophelp.txt
@echo   only to a certain version in the headset. >>dophelp.txt
@echo. >>dophelp.txt
@echo   For this purpose, the firmware file additionally specifies the version >>dophelp.txt
@echo   of the headset firmware that can be flashed. >>dophelp.txt
@echo   This version is the increment base. >>dophelp.txt
@echo. >>dophelp.txt
@echo   For example, we have a firmware file with version 20.10 >>dophelp.txt
@echo   it is newer than the headset firmware (10.10). >>dophelp.txt
@echo   but the increment base for the file is version 10.50. >>dophelp.txt
@echo. >>dophelp.txt
@echo   And it turns out that the firmware file version is higher than the headset firmware version, >>dophelp.txt
@echo   but this update is ONLY intended for headsets with version 10.50, >>dophelp.txt
@echo   and we have a headset with firmware version 10.10 >>dophelp.txt
@echo. >>dophelp.txt
@echo   So, flashing won't work. >>dophelp.txt
@echo. >>dophelp.txt
@echo. >>dophelp.txt
@echo. >>dophelp.txt

:: @start cmd /c @%MYFILES%\adb shell
rem @start cmd /k "type dophelp.txt && @echo Для закрытия окна нажмите любую кнопку && @pause 1>nul && exit"
@start cmd /k "type dophelp.txt && @echo Press any key to close the window && @pause >nul && exit"
@ping localhost -n 2 2>nul 1>nul
@del dophelp.txt /f /q 2>nul 1>nul
goto _fwmenu

:_ViewAndCompateDeviceName
set IntProductName=
@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.name') do set IntProductName=%%a
:: Использовать эту, если не подойдет предыдущая
::@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.device') do set IntProductName=%%a
@%myfiles%\7z.exe e %FirmwareFileName% metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"pre-device" metadata') do @set UpZipIntProductName=%%k
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
rem set DeviceModelName=Неясно
set UpZipModelName=Unknown
set DevModelNm=------------
exit /b

:_SetCompareUpZipModelName
if %UpZipIntProductName%==monterey set UpzModelNm=Quest 1 &&set fmfilename=Q1&&set fwtxt=fw1.txt&& exit /b
if %UpZipIntProductName%==hollywood set UpzModelNm=Quest 2 &&set fmfilename=Q2&&set fwtxt=fw2.txt&& exit /b
if %UpZipIntProductName%==seacliff set UpzModelNm=Quest Pro &&set fmfilename=QP&&set fwtxt=fwp.txt&& exit /b
if %UpZipIntProductName%==eureka set UpzModelNm=Quest 3 &&set fmfilename=Q3&&set fwtxt=fw3.txt&& exit /b
:: Здесь первый символ слова "Неясно" - латинская "H"
rem set UpZipModelName=Hеясно
set UpZipModelName=Unknown
set DevModelNm=------------
exit /b

:_CompareUpZipAndProductName
if %IntProductName% NEQ %UpZipIntProductName% (
rem set "IntPrdCompt=Нет"
set "IntPrdCompt=No"
exit /b
) else (
rem set "IntPrdCompt=Да"
set "IntPrdCompt=Yes"
exit /b
)
exit /b

:_SetFWtxtFileName
@%myfiles%\7z.exe e %FirmwareFileName% metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"pre-device" metadata') do @set UpZipIntProductName=%%k
if [%UpZipIntProductName%]==[] set UpZipIntProductName=----------
if %UpZipIntProductName%==monterey set DevModelNm=Quest 1&&set fmfilename=Q1&&set UpzModelNm=Quest 1 &&set fwtxt=fw1.txt&& exit /b
if %UpZipIntProductName%==hollywood set DevModelNm=Quest 2&&set fmfilename=Q2&& set UpzModelNm=Quest 2 &&set fwtxt=fw2.txt&& exit /b
if %UpZipIntProductName%==seacliff set DevModelNm=Quest Pro&&set fmfilename=QP&&set UpzModelNm=Quest Pro &&set fwtxt=fwp.txt&& exit /b
if %UpZipIntProductName%==eureka set DevModelNm=Quest 3&&set fmfilename=Q3&&set UpzModelNm=Quest 3 &&set fwtxt=fw3.txt&& exit /b
:: Здесь первый символ слова "Неясно" - латинская "H"
rem set UpZipModelName=Hеясно
set UpZipModelName=Unknown
exit /b


:_Uncompatible
@echo.
@echo  ---------------------------------------------------------------
rem @echo  ^|   +++ Файл прошивки %FirmwareFileName% от другой модели шлема +++   ^|
@echo  ^|   +++ Firmware file %FirmwareFileName% from another headset model +++   ^|
@echo  ---------------------------------------------------------------
@echo.
rem @echo   Прошить не получится.
@echo   Firmware flashing is not possible.
goto _FlashMenuYes

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_firmwareauto
call :_cdc
call :_hat
@echo.
@echo off
call :_setfwtxt
rem if "%model%" EQU "Неизвестно" (
if "%model%" EQU "Unknown" (
set model=---------
rem set model1=+++ Подключено неизвестное устройство! +++
rem set umodel2=Продолжайте только если вы точно знаете, что делаете.
set model1=+++ Unknown device connected! +++
set umodel2=Continue only if you are absolutely sure what you are doing.
goto _CheckUpdateZip
) else (
rem set model1=+++ Подключено устройство: %model% +++
set model1=+++ Device connected: %model% +++
)
)

:_CheckUpdateZip
if exist %FirmwareFileName%.zip ren %FirmwareFileName%.zip %FirmwareFileName%
if not exist %FirmwareFileName% goto _NOTEXIST
@%MYFILES%\7z.exe l %FirmwareFileName% | findstr payload.bin >nul
@If %ERRORLEVEL% EQU 1 GOTO _FWWRONG
@echo.
@echo.
::@echo.
@echo.
goto _eng9
@echo          +++ Файл прошивки найден +++
@echo.
@echo.
@echo.   %model1% ^ & @echo. ^ & @echo. ^ & @echo. %umodel2%
@echo.
@echo.
@echo		0. Выход из программы
@echo		M. Выход в Главное меню
@echo		F. Выход в меню прошивки
@echo		T. Проверить файл %FirmwareFileName% на совместимость
@echo	    Enter. Начать прошивку
@echo.
@echo.
@echo.
@echo -----------------------------------------------------
@echo  Нажмите Enter для начала прошивки устройства
@echo  или выберите пункт меню и затем Enter
:_eng9
@echo          +++ Firmware file found +++
@echo.
@echo.
@echo.   %model1% ^ & @echo. ^ & @echo. ^ & @echo. %umodel2%
@echo.
@echo.
@echo		0. Exit the program
@echo		M. Exit to Main Menu
@echo		F. Exit to Firmware Menu
@echo		T. Check %FirmwareFileName% file compatibility
@echo	    Enter. Start device flashing
@echo.
@echo.
@echo.
@echo -----------------------------------------------------
@echo  Press Enter to start device flashing
@echo  or choose a menu item and then press Enter

:_fwmenu1
echo off
@set "choice="
@Set "choice=1"
@echo.
@Set /p choice=">> "
@echo.
if not defined choice goto _fwmenu1
if "%choice%"=="1" (GOTO _contfw1)
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="f" (GOTO _fwmenuskip)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _CheckFirmwareUpdate)
goto _fwmenu1

:_contfw1
@echo.
@echo  ----------
rem @echo  = Загружаемся в бутлоадер..
rem @echo    [светодиод загорится оранжевым]
@echo  = Booting into bootloader..
@echo    [LED will light up orange]
@echo.
@%MYFILES%\adb.exe reboot bootloader 1>NUL 2>&1
@ping localhost -n 12 >nul
@echo  ----------
rem @echo  = Переключаемся в режим загрузки прошивки..
rem @echo    [ светодиод загорится белым, затем фиолетовым ]
@echo  = Switching to firmware loading mode..
@echo    [LED will light up white, then purple]
@echo.
@%MYFILES%\fastboot.exe oem reboot-sideload 1>NUL 2>&1
@ping localhost -n 14 >nul

:_FirmwareUpload
@echo  ----------
rem @echo  = Загружаем прошивку в шлем..
rem @echo    [ на 94^%% может на минуту замререть, это нормально ]
@echo  = Loading firmware into the headset..
@echo    [At 94%% it may freeze for a minute, this is normal]
@echo.
@%MYFILES%\adb.exe sideload %FirmwareFileName%
@If ERRORLEVEL==1 goto _loadfwerror
@echo.
@echo.
@echo  ---------------------------------------------------
goto _eng10
@echo  ^|     +++  Загрузка прошивки завершена  +++       ^|
@echo  ---------------------------------------------------
@echo.
@echo  Обратите внимание на сообщение после загрузки: 
@echo   Total xfer 1.00x - вы шьете ту же самую или более раннюю версию прошивки  
@echo   Total xfer 2.00x - новая прошивка успешно загружена в шлем
@echo.
@echo  Вскоре устройство будет перезагружено.
@echo  Установка новой прошивки продолжится автоматически.
@echo.
@echo  Не трогайте шлем, пока боковой светодиод не станет желтым или зеленым. 
@echo  Загрузка в окружение может занять до десяти минут, будьте терпеливы.
:_eng10
@echo  ^|     +++  Firmware loading complete  +++       ^|
@echo  ---------------------------------------------------
@echo.
@echo  Pay attention to the message after loading:
@echo   Total xfer 1.00x - you are flashing the same or earlier firmware version
@echo   Total xfer 2.00x - new firmware successfully loaded into the headset
@echo.
@echo  The device will be rebooted shortly.
@echo  Installing the new firmware will continue automatically.
@echo.
@echo  Do not touch the headset until the side LED turns yellow or green.
@echo  Loading into the environment may take up to ten minutes, please be patient.
@ping localhost -n 5 >nul
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
@echo -----------------------------------------------------
goto _returnmenu

:_firmwarebutton
endlocal
@call :_SetFirmwareFileName
@echo off
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
rem @echo     +++++  Файл прошивки найден  +++++
@echo     +++++  Firmware file found  +++++
@echo.
@echo.
@echo.
@%MYFILES%\fastboot devices | find "fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==1 goto _nobootloader
@echo.
::@echo    Для получения информации о файле %FirmwareFileName%  
::@echo    выйдите в основное меню и выберите пункт F.
@echo -----------------------------------------------------
@echo.
@echo.
rem @echo		0. Выход из программы 
rem @echo		M. Выход в Главное меню 
rem @echo		F. Выход в меню прошивки
rem @echo		T. Проанализировать файл прошивки
rem @echo	    Enter. Начать прошивку
@echo		0. Exit the program
@echo		M. Exit to Main Menu
@echo		F. Exit to Firmware Menu
@echo		T. Analyze firmware file
@echo	    Enter. Start flashing

:_fwmenu2
echo off
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
rem @echo  = Переключаемся в режим загрузки прошивки..
rem @echo    [ светодиод загорится белым, затем фиолетовым ]
@echo  = Switching to firmware loading mode..
@echo    [LED will light up white, then purple]
::@echo.
@%MYFILES%\fastboot.exe oem reboot-sideload 1>NUL 2>&1
@@ping localhost -n 14 >nul
@echo.
@echo  ----------
rem @echo  = Загружаем прошивку в шлем..
rem @echo    [ на 94^%% на минуту замрёт, не волнуйтесь ]
@echo  = Loading firmware into the headset..
@echo    [At 94%% it may freeze for a minute, this is normal]
@echo.
@%MYFILES%\adb.exe sideload %FirmwareFileName%
@If %ERRORLEVEL%==1 goto _loadfwerror
@echo.
@echo  ---------------------------------------------------
goto _eng11
@echo  ^|     +++  Загрузка прошивки завершена  +++       ^|
@echo  ---------------------------------------------------
@echo.
@echo  Обратите внимание на сообщение после загрузки: 
@echo   Total xfer 1.00x - вы шьете ту же самую или более раннюю версию прошивки
@echo   Total xfer 2.00x - новая прошивка успешно загружена в шлем
@echo.
@echo  Вскоре устройство будет перезагружено.
@echo  Установка новой прошивки продолжится автоматически.
@echo.
@echo  Не трогайте шлем, пока боковой светодиод не станет желтым или зеленым. 
@echo  Загрузка в окружение может занять 10-15  минут, будьте терпеливы.
:_eng11
@echo  ^|     +++  Firmware loading complete  +++       ^|
@echo  ---------------------------------------------------
@echo.
@echo  Pay attention to the message after loading:
@echo   Total xfer 1.00x - you are flashing the same or earlier firmware version
@echo   Total xfer 2.00x - new firmware successfully loaded into the headset
@echo.
@echo  The device will be rebooted shortly.
@echo  Installing the new firmware will continue automatically.
@echo.
@echo  Do not touch the headset until the side LED turns yellow or green.
@echo  Loading into the environment may take up to ten minutes, please be patient.@ping localhost -n 5 >nul
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
goto _returnmenu

:_nobootloader
@echo off
@cls
call :_hat
@echo.
@echo.
@echo.
goto _eng12
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
:_eng12
@echo     +++ Headset NOT in Bootloader mode! +++
@echo.
@echo.
@echo.
@echo   To enter Bootloader mode,
@echo   hold down the Power and Volume Down buttons
@echo   simultaneously (the one closest to the nose)
@echo   until the white-blue menu appears.
@echo --------------------------------------------
@echo.
@echo   Then restart this program.
@echo.
@echo.
goto _returnmenu

:_bootloadermode
@echo off
@cls
call :_hat
@echo.
@echo.
@echo.
@echo.
goto _eng13
@echo     +++ Шлем в режиме Bootloader! +++
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
@echo      F. Выход в меню прошивки
@echo  Enter. Перейти в режим кнопочной прошивки
:_eng13
@echo     +++ Headset in Bootloader mode! +++
@echo.
@echo.
@echo.
@echo  Or in Fastboot - it depends on the LED color and what's on the display:
@echo.
@echo  If the headset displays a yellow-blue menu, the LED is purple, and the text says FASTBOOTD - 
@echo      = you're in +++ Fastboot mode +++
@echo.
@echo  If the headset displays a white-blue menu, the LED is orange, and the text says USB Update Mode - 
@echo     = you're in +++ Bootloader mode +++
@echo --------------------------------------------
@echo.
@echo.
@echo      0. Exit the program 
@echo      M. Exit to Main Menu 
@echo      F. Exit to Firmware Menu
@echo  Enter. Switch to button flashing mode
@echo.
@echo.
@echo.
@set "choice="
@Set "choice=1"
rem @Set /p choice="Выберите пункт меню или нажмите Enter: "
@Set /p choice="Select a menu number and press Enter: "
@echo.
if not defined choice goto _bootloadermode
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="1" (GOTO _firmwarebutton)
if /i "%choice%"=="f" (GOTO _fwmenuskip)
if /i "%choice%"=="m" (GOTO _beginn)
goto _bootloadermode

:_NOTEXIST
@echo off
@cls
call :_hatqut
@echo.
@echo.
@echo.
rem @echo     ++++ Файл прошивки НЕ найден ++++
@echo     +++ Firmware file NOT found ++++
@echo.
@echo.
@echo.
rem @echo   1. Поместите файл прошивки (архив zip) рядом с этой программой.
rem @echo   2. Перезапустите программу.
@echo   1. Place the firmware file (zip archive) next to this program.
@echo   2. Restart the program.
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
goto _returnmenu

:_FWWRONG
@echo off
@cls
call :_hatqut
@echo.
@echo.
@echo.
rem @echo    ++++ Файл прошивки не корректен ++++
@echo    ++++ Firmware file is not valid ++++
@echo.
@echo.
@echo.
rem @echo  Проверьте содержимое архива %FirmwareFileName%
rem @echo  Он должен иметь такую структуру:
@echo  Check the contents of the %FirmwareFileName% archive
@echo  It should have the following structure:
@echo.
@echo   META-INF
@echo	apex_info.pb
@echo   care_map.pb
@echo   payload.bin
@echo   payload_properties.txt
@echo.
rem @echo  Как только убедитесь в правильности архива, перезапустите программу.
@echo  Once you've confirmed the correctness of the archive, restart the program.
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
goto _returnmenu

:_fversion
@echo.
@echo.
@%MYFILES%\fastboot devices | find "fastboot" 1>nul 2>nul
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
rem @echo Модель шлема		: Meta %DevModelNm%
rem @echo Версия среды		: %hsenvironment%
rem @echo Версия прошивки		: %hsversion%
@echo Headset model       : Meta %DevModelNm%
@echo Environment version: %hsenvironment%
@echo Firmware version   : %hsversion%
@echo ----------------------------------------------
goto _returnmenu

:_Unknown
@echo.
@echo.
rem echo   +++ Шлем не подключен или модель не определена +++
@echo   +++ Headset is not connected or the model is not recognized +++
@echo.
@echo.
GOTO _returnmenu

:_fwtxtcompare
echo off
rem @echo Секунду, выдергиваем циферки...
@echo  Just a moment, extracting numbers...
For /F %%a In ('@%MYFILES%\adb shell getprop ro.build.version.incremental') Do set hsenvironment=%%a
call :_hsfwversionextract
call :_setfwtxt
@echo -----------------------------------------------------
rem @echo   Модель шлема			: %DevModelNm%
@echo   Headset model			: %DevModelNm%
@echo -----------------------------------------------------
rem @echo   Версия среды шлема		: %hsenvironment%
rem @echo   Версия прошивки шлема		: %hsversion%
@echo  Headset environment version	: %hsenvironment%
@echo  Headset firmware version	: %hsversion%
@echo -----------------------------------------------------
::%MYFILES%\wget -q --no-hsts "https://drive.google.com/uc?export=download&id=1qu2UsiYv-4_72-SAqZXqV7ruUb0P3bjH" -O fw.txt
rem call :_SetFWtxtFileName
set ftpfile=%fwtxt%
call :_GetFTP
if errorlevel==1 goto _errordownloadfwtxt
(for /f "delims=" %%i in ('type %fwtxt%') do @set last_string=%%i)
echo.%last_string% >ls.txt
@For /F "tokens=1,2 delims= " %%a In (ls.txt) Do (
@set lstxtenvironment=%%a
@set lstxtversion=%%b
)
set num1=%hsenvironment%
set num2=%lstxtenvironment%
set "tmp1=                 %num1%"
set "tmp2=                 %num2%"
set hsnumb="%tmp1:~-17%"
set lsnumb="%tmp2:~-17%"
rem echo   Версия среды из таблицы	: %lsnumb:~1,-1%
rem echo   Версия прошивки из таблицы	: %lstxtversion%
@echo  Environment version from table	: %lsnumb:~1,-1%
@echo  Firmware version from table	: %lstxtversion%
@echo -----------------------------------------------------
@if %hsnumb% GTR %lsnumb% (
@echo.
rem @echo +++  Прошивка в шлеме новее, чем в таблице  +++
rem @echo.
rem @echo = Дополняем таблицу соответствия версий прошивок
@echo +++ Firmware in the headset is newer than in the table +++
@echo.
@echo = Updating the firmware version mapping table
@echo %hsenvironment% %hsversion% >>%fwtxt%
call :_SetCompareDeviceModelName
rem call :_SetFWtxtFileName
set ftpfile=%fwtxt%
call :_PutFTP
del ls.txt /q /f
@echo.
goto _returnmenu
) else (
@if %hsnumb% == %lsnumb% (
@echo.
rem @echo     +++ Версия прошивки шлема актуальна +++
@echo     +++ The firmware version in the headset is up to date +++
del %fwtxt% /q /f
del ls.txt /q /f
@echo.
goto _returnmenu
) else (
@if %lsnumb% GTR %hsnumb% (
@echo.
rem @echo     +++ В шлеме устаревшая версия прошивки +++
@echo     +++ The firmware version in the headset is outdated +++
del %fwtxt% /q /f
del ls.txt /q /f
@echo.
goto _returnmenu
) else (
rem Этот блок не используется, но может быть задействован
rem @echo    +++ Файл fw.txt актуален +++
rem del %fwtxt% /q /f
rem del ls.txt /q /f
rem @echo.
rem goto _returnmenu
)
)
)
goto _returnmenu

:_errordownloadfwtxt
rem echo Ошибка скачивания
@echo Download error
@echo.
goto _returnmenu

:_GetFTP
set transfer=get
call :_ftpconnect
@del ftp_%transfer%.txt /q /f  1>nul 2>nul
exit /b

:_PutFTP
set transfer=put
call :_ftpconnect
@del ftp_%transfer%.txt /q /f 1>nul 2>nul
@del %fwtxt% /q /f 1>nul 2>nul
exit /b

:_ftpconnect
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
@Echo Off
@set arcpath=%myfiles%
@echo ===============================================================
rem @echo Создаем архив багрепорта, это займет 3-4 минуты
rem @echo Должна появиться такая строчка:
@echo Creating bugreport archive, this may take 3-4 minutes
@echo You should see a line like this:
@echo.
@echo [  1%%%] generating bugreport-...
@echo.
rem @echo Если в течении минуты не появилась, закройте программу и запустите ее снова
@echo If it doesn't appear within a minute, close the program and run it again
@echo ---------------------------------------------------------------
@echo.
@%myfiles%\adb bugreport %cd% 2>nul
if %errorlevel% == -1 goto _errorbugrepdl
@echo.
@echo ---------------------------------------------------------------
rem @echo  = Багрепорт создан, выдергиваем ссылку....
@echo  = Bugreport created, extracting the link....
@echo.
@%myfiles%\7z.exe x %cd%\bugreport*.zip -o"%cd%\bugreport" 1>NUL 2>&1

@SetLocal EnableDelayedExpansion
Set bugrepdir=.\bugreport\FS\data\misc\update_engine_log\
For /F "tokens=*" %%i In ('@Dir /S /A:-D /B "%bugrepdir%"') Do (
set fullname=%%i
@FOR /F "tokens=3" %%k IN ('@FINDstr /c:"https://" !fullname!') DO @set http=%%k & @echo !http! >>links.txt
)
@if not exist links.txt goto _EmptyLinkTxt
@findstr "^" "links.txt">nul&& echo.|| goto _EmptyLinkTxt

@ren link.txt link.old.txt 1>nul 2>nul
@for /f "tokens=*" %%a in (links.txt) do (
@findstr /l /c:"%%a" link.txt 1>nul 2>nul || @echo %%a>>link.txt
)
@if not exist link.txt goto _EmptyLinkTxt
@findstr "^" "link.txt">nul&& echo.|| goto _EmptyLinkTxt

@echo ---------------------------------------------------------------
rem @echo  = Извлечение завершено, начинаем скачивание прошивки....
rem @echo    Ссылок может быть не одна, в этом случае скачиваться они будут по-очереди.
rem @echo    Это может занять значительное время.
@echo  = Extraction completed, starting firmware download....
@echo    There may be more than one link, in which case they will be downloaded sequentially.
@echo    This may take a considerable amount of time.
@echo.

@for /f "tokens=*" %%a in (link.txt) do (
set dlink=%%a
@echo ------
rem @echo = Скачивание прошивки...
@echo  = Firmware download in progress...
call :_DownloadFirmware
)
@del metadata 2>nul 1>nul
@del links.txt 2>nul 1>nul
@del bugreport*.zip /q
@rd %cd%\bugreport /Q /S
@echo -----
rem @echo = Готово. 
rem @echo.
rem @echo   Если скачивания не было, загляните в файл link.txt,
rem @echo   созданный только что рядом с программой и вручную 
rem @echo   скопируйте ссылку на прошивку (если она там есть) в браузер.
@echo  = Done.
@echo.
@echo   If the download did not occur, check the link.txt file,
@echo   created just now next to the program, and manually
@echo   copy the firmware link (if available) into your browser.
goto _Sendlink

:_hsfwversionextract
For /F %%a In ('@%MYFILES%\adb shell getprop ro.build.version.incremental') Do set hsenvironment=%%a
@%myfiles%\adb shell dumpsys DumpsysProxy VRShell >vnumb.txt
@set "file=vnumb.txt"
@for /f "tokens=* delims=" %%a in ('powershell -executionpolicy bypass -command "(get-content '%file%' | select-string '"""versionName"""') -replace '(^.+)("""versionName""":)("""[0-9\.]+""")(.+$)','$3' -replace '"""'') do (
@set hsfwversionfull="%%a"
)
@for /f "tokens=1,2,3,4 delims=." %%b in (%hsfwversionfull%) do (
@set hsversion=%%b.%%c.%%d.%%e
)
@del vnumb.txt 2>nul 1>nul
exit /b

:_Sendlink
@echo ---------------------------------------------------------------
@echo.
@echo.
rem @echo  Хотите ли вы выгрузить ссылку на прошивку автору программы?
rem @echo  Это поможет создать список серверов с целью обхода их блокировки.
rem @echo.
rem @echo  Также это даст другим пользователям возможность скачать и установить
rem @echo  новую прошивку, если она по каким-то причинам у них недоступна.
rem @echo.
rem @echo   Если да - просто нажмите Enter. Если нет - 0 и Enter.
@echo Do you want to upload the firmware link to the program author?
@echo This will help create a list of servers to bypass any blocking.
@echo.
@echo It will also allow other users to download and install
@echo the new firmware if it is not available to them for any reason.
@echo.
@echo   If yes - simply press Enter. If no - 0 and Enter.
@echo.
@echo.
@set "choice="
@set "choice=s"
@Set /p choice=">>> "
@echo.
if not defined choice goto _Sendlink
if /i "%choice%"=="s" (GOTO _Savelink)
if /i "%choice%"=="0" (GOTO _fwmenuskip)
cls
goto _Sendlink

:_SaveLink
@echo ------
rem @echo  Спасибо за помощь^^^!
@echo Thank you for your help!
set ftpfile=alllinks.txt
call :_GetFTP
@echo !http! >>alllinks.txt
set ftpfile=alllinks.txt
call :_PutFTP
@del alllinks.txt /q /f 1>nul 2>nul
@echo.
rem @echo Ссылка выгружена.
@echo Link uploaded.
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
rem @echo  К сожалению, ссылку на прошивку вытащить не удалось,
rem @echo  в багрепорте ее нет. Быть может, получится в другой раз.
@echo  Unfortunately, the firmware link couldn't be extracted from the bug report. 
@echo  Perhaps next time it will be possible.
@echo ---------------------------------------------------------------
@echo.
@echo.
goto _returnmenu

:_DownloadFirmware
%MYFILES%\wget -q --show-progress --no-hsts "%dlink%" -O fwdwnldd.zip
@%myfiles%\7z.exe e fwdwnldd.zip metadata -r -y 1>nul 2>nul
@FOR /F "tokens=2 delims==" %%k IN ('@FINDstr /c:"post-build-incremental" metadata') DO @set postbuild=%%k
@call :_SetOnlyTime
@ren fwdwnldd.zip %postbuild%_%ti%.zip
@echo.
rem @echo   Файл прошивки сохранен с именем %postbuild%_%ti%.zip
@echo The firmware file has been saved with the name %postbuild%_%ti%.zip
@echo.
exit /b

:_SetOnlyTime
set ti=%time:~0,2%-%time:~3,2%-%time:~6,2%
set ti=%ti: =0%
exit /b


:_errorbugrepdl
@echo ---------------------------------------------------------------
@echo.
rem @echo Не удалось создать архив багрепорта, 
rem @echo попробуйте еще раз через несколько минут.
@echo Failed to create the bug report archive, please try again in a few minutes.
@echo.
@echo.
goto _returnmenu

:_NoInternetMessage
@echo.
@echo  ------------------------------------------------------------------------------------------------
rem @echo  ^|   +++ Подключение к Интернет отсутствует. Информация о результатах проверки недоступна +++   ^|
@echo  ^|   +++ Internet connection is not available. Results of the check are unavailable +++   ^|
@echo  ------------------------------------------------------------------------------------------------
@echo.
goto _returnmenu


:_NoHeadsetMessage
@echo.
@echo  -------------------------------------------------------------------------------
rem @echo  ^|   +++ Шлем не подключен. Информация о результатах проверки недоступна +++   ^|
@echo  ^|   +++ The headset is not connected. Information about the test results is unavailable +++   ^|
@echo  -------------------------------------------------------------------------------
@echo.
goto _returnmenu


:_blmessage
@echo.
@echo  ---------------------------------------------------------------------
rem @echo  ^|   +++ Шлем в режиме Bootloader. Информация о нем недоступна +++   ^|
@echo  ^|   +++ The headset is in Bootloader mode. Information about it is unavailable +++   ^|
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
 call set "name=%%name:!=%%"
rem  call set "name=%%name:+=%%"
rem  call set "name=%%name: =%%"
 cmd/v/c ren "%%a" "!name:%%=!"
)
rem set FirmwareFileName=%name%
exit/b

:_hatqut
::@cls
@echo ==================================================================================================
@echo        Quest Update Tool - created by Varset - v.1.4 - 13.08.23%hatcod%
@echo ==================================================================================================
@exit /b

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_bugreportextr
call :_cdc
@Echo Off
@echo ===============================================================
rem @echo Создаем архив багрепорта, это займет 3-4 минуты
rem @echo Должна появиться такая строчка:
@echo Creating a bug report archive, this will take 3-4 minutes
@echo You should see the following line:
@echo.
@echo [  1%%%] generating bugreport-...
@echo.
rem @echo Если в течении минуты не появилась, закройте программу и запустите ее снова
@echo If it doesn't appear within a minute, close the program and run it again
@echo ---------------------------------------------------------------
@echo.
@%myfiles%\adb bugreport %cd%
@If %ERRORLEVEL% EQU 1 goto _reporterr
@Echo ===============================================================
@echo.
rem @echo Архив с багрепортом извлечен и помещен в текущий каталог
rem @echo В браузере откроется вкладка, загрузите в нее архив.
@echo The bug report archive has been extracted and placed in the current directory
@echo A browser tab will open, upload the archive there.
@echo ---------------------------------------------------------------
@ping localhost -t 3 1>nul 2>nul
rem @start " " "https://bathist.online/"
@start " " "https://bathist.ef.lc/"
@echo.
@echo.
goto _returnmenu

:_reporterr
@cls
call :_hat
@echo.
@echo.
@echo.
rem @echo +++ Не удалось извлечь багрепорт. Попробуйте зайти чуть позже +++
@echo +++ Failed to extract the bug report. Try again later +++
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
rem @echo    A.  Просмотр времени и таймзоны шлема
rem @echo    B.  Коррекция времени и таймзоны
@echo    A. View headset time and timezone
@echo    B. Time and timezone correction
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _todmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _datetime)
if /i "%choice%"=="b" (GOTO _datetimecorr)

:_datetimecorr
call :_cdc
@echo ^<job^>^<script language^="JavaScript"^> >>etime.wsf
@echo WScript.Echo^(new Date^().getTime^())^; >>etime.wsf
@echo ^<^/script^>^<^/job^> >>etime.wsf
@for /f "tokens=* usebackq" %%a in (`@start /b cscript //nologo "etime.wsf"`) do (set epochtimestamp=%%a)
@%myfiles%\adb shell service call alarm 2 i64 %epochtimestamp% 1>nul 2>nul
@del etime.wsf /q /f 1>nul 2>nul
@echo ----------------------------------------------
rem @echo = Проверяем время после коррекции...
@echo = Checking the time after correction...
@echo.
call :_checktime
@echo.
@echo ----------------------------------------------
rem @echo = Время скорректировано
@echo = Time corrected
@echo.  
@echo --- 
rem @echo Текущие значения:
@echo Current values:
@echo. 
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"`) do (set ths=%%a)
rem @echo  Дата и время на шлеме	: %ths%
@echo Date and time on the headset: %ths%
@call :_SETTIME
rem @echo  Дата и время на ПК	: %dppt%
@echo Date and time on the PC: %dppt%
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
@echo.
exit /b
) else (
@echo.
@echo  ===============================================================
rem @echo  ^|     +++      Требуется корректировка таймзоны      +++      ^|
rem @echo        Нажмите что-нибудь для перехода в меню корректировки
@echo  ^|     +++      Timezone correction required      +++      ^|
@echo        Press any key to proceed to the correction menu
)
@echo  ===============================================================
@echo.
@pause >nul
goto :_timezonecorr

:_datetime
call :_cdc
@echo off
@cls
call :_hat
call :_hatmenu
@echo.
rem @echo    C.  Скорректировать дату и время
rem @echo    T.  Скорректировать таймзону
@echo    C.  Correct date and time
@echo    T.  Correct timezone
@echo.
@echo ----------------------------------------------
call :_cdc
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell getprop persist.sys.timezone`) do (set tzhs=%%a)
rem @echo  Таймзона на шлеме	: %tzhs%
@echo  Timezone on the headset	: %tzhs%
@for /f "tokens=3 delims=()" %%a in ('wmic timezone get caption /value') do set tzpc=%%a
rem @echo  Таймзона на ПК		:%tzpc%
@echo  Timezone on the PC		:%tzpc%
@echo ---
@for /f "tokens=* usebackq" %%a in (`@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"`) do (set ths=%%a)
rem @echo  Дата и время на шлеме	: %ths%
@echo  Date and time on the headset	: %ths%
@call :_SETTIME
rem @echo  Дата и время на ПК	: %dppt%
@echo  Date and time on the PC	: %dppt%
@echo ----------------------------------------------
if %ths:~0,-3%==%dppt:~0,-3% (
@echo.
@echo.
@echo  ===============================================================
rem @echo  ^|  +++   Время правильное, корректировка не требуется   +++   ^|
@echo  ^|    +++    Time is correct, no adjustment required    +++    ^|
) else (
@echo.
@echo  ===============================================================
rem @echo  ^|  +++    Время различается, требуется корректировка    +++   ^|
@echo  ^|  +++   Time differs, adjustment is required   +++   ^|
)
@echo  ===============================================================
@echo.
@echo.
@echo.
rem @echo  Значительное отличие времени, даты и таймзоны от актуальных значений
rem @echo  может вызвать проблемы с подключением к сети Wi-Fi
@echo  Significant difference in time, date, and timezone from actual values
@echo  may cause issues with Wi-Fi network connectivity
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _datetime
if "%choice%"=="0" (exit)
if /i "%choice%"=="c" (GOTO _datetimecorr)
if /i "%choice%"=="t" (GOTO _timezonecorr)
if /i "%choice%"=="m" (GOTO _beginn)
cls
goto _datetime

:_timezonecorr
@echo off
rem @cls
call :_hat
@echo.
goto _eng14
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
:_eng14
@echo                ===  Timezone Adjustment ===
call :_hatmenu
@echo.
@echo    L.  Open timezone list in browser
@echo.   R.  Set timezone manually
@echo.
@echo.   1.   UTC +01.00	Europe/Amsterdam
@echo.   2.   UTC +02.00	Europe/Sofia
@echo.   3.   UTC +03.00	Europe/Moscow
@echo.   4.   UTC +04.00	Asia/Baku
@echo.   5.   UTC +05.00	Asia/Ashkhabad
@echo.   6.   UTC +06.00	Asia/Astana
@echo.
@echo   If your timezone is not in this list, enter L and press Enter (see menu)
@echo   A browser will open with a list of timezones, where you can select and copy yours.
@echo   Then enter R in the program, press Enter, and paste the selected timezone.
@echo.
@echo.
@echo Example: 
@echo.
@echo    You live in Vladivostok, your timezone is +10.
@echo.   In the browser, in the timezone list find Asia/Vladivostok,
@echo.   copy exactly that, press R, confirm with Enter,
@echo    and paste: Asia/Vladivostok
@echo    Then confirm again with Enter
@echo.
@echo.
@set "choice="
@Set /p choice="To set timezone, enter a number from 1 to 6 and press Enter: "
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
rem @echo  Установлена таймзона %timezonereg% (UTC +0%utc%.00)
@echo  Timezone set to %timezonereg% (UTC +0%utc%.00)
@echo.
@echo.
@echo  =======================================
rem @echo         Таймзона установлена 
rem @echo     Нажмите что-нибудь для проверки
@echo   Timezone set
@echo   Press any key to check
@echo  =======================================
@pause >nul
goto _datetime
rem goto _datetimecorrmenu

:_handesetonlytimezone
@echo ----------------
rem @echo   0. Выход
rem @echo   M. Меню таймзоны
@echo   0. Exit
@echo   M. Timezone Menu
@echo ----------------
@echo.
@echo.
@set "handtimezone="
rem @Set /p handtimezone="Вставьте сюда скопированную таймзону и нажмите Enter: "
@Set /p handtimezone="Paste the copied timezone here and press Enter: "
if "%handtimezone%"=="0" (exit)
if /i "%handtimezone%"=="m" (GOTO _timezonecorr)
@%myfiles%\adb shell service call alarm 3 s16 "%handtimezone%"
@echo.
rem @echo  Установлена таймзона %handtimezone%
@echo  Timezone set to %handtimezone%
@echo.
@echo.
goto _prevmenu
goto _datetimecorrmenu


:_todmenu
call :_hat
call :_hatmenu
@echo.
goto _eng15
@echo    A.  Просмотр прогресса скачивания				[EXP]
@echo    B.  Запись DNS серверов в шлем
@echo    C.  Автоматическй подбор DNS для скачивания обновлений	[EXP]
@echo    D.  Сброс DNS настроек шлема в дефолт
@echo    E.  Установить DNS интернет-заглушку				[EXP]
@echo        [отключение Интернет на шлеме без отключения WiFi]
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
@echo       пока не найдет подходящий DNS сервер из 81 доступного в списке и не скачает обновления.
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
:_eng15
@echo    A.  View download progress             [EXP]
@echo    B.  Record DNS servers to headset
@echo    C.  Automatic selection of DNS for downloading updates    [EXP]
@echo    D.  Reset headset DNS settings to default
@echo    E.  Set up DNS Internet blocking        [EXP]
@echo        [disconnecting the Internet on the headset without turning off WiFi]
@echo.
@echo.
@echo    IMPORTANT:
@echo.
@echo       This section is designed to simplify the initial setup of the headset.
@echo       With the Auto DNS Selection, the program will help bypass restrictions
@echo       and download updates during the initial setup.
@echo       To do this, it will automatically cycle through a list of DNS servers
@echo       and check the availability of update servers.
@echo       If the download does not start, the program will change the DNS server and retry the check.
@echo       Once a successful update start is detected, the program will stop
@echo       cycling through servers and display the current progress status. The status
@echo       is periodically updated at the set interval. The program will continue to work
@echo       until it finds a suitable DNS server out of the 81 available in the list and downloads updates.
@echo.
@echo       The program can also be used to download firmware
@echo       if the servers are not available in the usual way.
@echo.
@echo       The View download progress option will display the progress status in percentages.
@echo.
@echo       After starting from options A or C, you will be prompted to enter the interval between checks,
@echo       in seconds. You can press Enter for the default 15-second interval
@echo       or enter your own number and confirm with Enter.
@echo.      To return to this menu, enter "0" without quotes.  
@echo.
@echo       It is advisable to set the interval to no less than 10 seconds.
@echo.
@echo       If progress is not displayed, it is recommended to increase the check interval up to 30 seconds.
@echo       In this case, one check will take just over two minutes
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
if /i "%choice%"=="d" (GOTO _setdefault)
if /i "%choice%"=="e" (GOTO _dnszaglushka)
cls
goto _todmenu

:_UpdateProgressSearchBint
call :_dnsintervalswitch

:_UpdateProgressSearchB
echo off
set dnschangelist=0
call :_DelSearchUpdateFiles
@setlocal enableextensions enabledelayedexpansion

:_UpdateProgressSearchMain
set updatesearchstring=Current progress
куь set modul=первый
set modul=first
set tkn=10
call :_nuxsearch
call :_UpdateProgressSearch

set updatesearchstring=OTA applying update
rem set modul=второй
set modul=second
set tkn=11
call :_nuxsearch
call :_UpdateProgressSearch

set updatesearchstring=OTA progress updated
rem set modul=третий
set modul=third
set tkn=12
call :_nuxsearch
call :_UpdateProgressSearch

rem if %dnschangelist%==1 echo. && echo    ...меняем DNS сервер... && timeout 2 >nul && exit /b
if %dnschangelist%==1 echo. && echo    ...changing DNS server... && timeout 2 >nul && exit /b
call :_DelSearchUpdateFiles
if %dltrsize% NEQ 0 goto _UpdateProgressSearchB
goto _noprss

:_UpdateProgressSearch
set timewait=%dnsint%
call :_cdc
echo  ---------------------------------------------------------------
rem echo  =  Запущен %modul% модуль поиска "%updatesearchstring%"
rem echo  ---
rem echo  ... обновляем данные.... Ждите %timewait% секунд
rem echo  ===============================================================
rem @echo          [ для прерывания нажмите любую кнопку ]
echo  =  Running %modul% module search "%updatesearchstring%"
echo  ---
echo  ...updating data.... Please wait %timewait% seconds
echo  ===============================================================
@echo          [ Press any key to interrupt ]
echo.
call :_DelSearchUpdateFiles
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
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
@echo  ---------------------------------------------------------------------------------------
goto _eng16
@echo  = Отображен %modul% модуль поиска прогресса:	[ %updatesearchstring% ]
@echo.
@echo  =======================================================================================
@echo   Прогресс в процентах	: %gprgrs%%%%
@echo   Выполняется задача	: %trrgrs%%trprgrs2%
rem @echo   Поисковый модуль	: %updatesearchstring%
rem @echo   Текущий статус	: %otastatus%
@echo  =======================================================================================
@echo.
@echo    Вначала может показаться, что прогресс не меняется, но это не так.
@echo    Наберитесь терпения, подождите 10-15 минут.
@echo.
@echo    Изредка поглядывайте в шлем, иногда прогресс может показывать менее 100%%%,
@echo    но в шлеме кнопка Скачивание уже  поменялась на Перезагрузить и применить.
@echo.
@echo  ---------------------------------------------------------------------------------------
rem @echo.
@echo.
@echo        через %timewait% секунд статус прогресса автоматически обновится.
@echo                 [ для прерывания нажмите любую кнопку ]
:_eng16
@echo  = Displaying %modul% search progress module: [ %updatesearchstring% ]
@echo.
@echo  =======================================================================================
@echo   Progress in percentage   : %gprgrs%%%%
@echo   Task in progress         : %trrgrs%%trprgrs2%
rem @echo   Search module           : %updatesearchstring%
rem @echo   Current status          : %otastatus%
@echo  =======================================================================================
@echo.
@echo    At first it may seem like the progress is not changing, but it is not so.
@echo    Be patient, wait for 10-15 minutes.
@echo.
@echo    Occasionally glance at the headset, sometimes the progress may show less than 100%%,
@echo    but in the headset the Download button has already changed to Restart and apply.
@echo.
@echo  ---------------------------------------------------------------------------------------
rem @echo.
@echo.
@echo        The progress status will automatically refresh in %timewait% seconds.
@echo                 [ Press any key to interrupt ]

rem if %otastatus%==Completed goto _updatesComplete
@echo.
@echo. 
call :_DelSearchUpdateFiles
set dnschangelist=0
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu

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
@echo ================================================================
rem @echo  В настоящий момент ничего не скачивается и не устанавливается.
rem @echo       Можете попробовать зайти чуть позже или подождать.
rem @echo ================================================================
rem @echo.
rem @echo        через %timewait% секунд статус автоматически обновится.
rem @echo          [ для прерывания нажмите любую кнопку ]
@echo  Currently, nothing is being downloaded or installed.
@echo       You can try again later or wait.
@echo ================================================================
@echo.
@echo        The status will automatically refresh in %timewait% seconds.
@echo          [ Press any key to interrupt ]
@echo.
call :_DelSearchUpdateFiles
rem timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
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
rem @if not exist %~dp0\dnslist.txt call :_createfile
@%MYFILES%\adb shell settings put global private_dns_mode hostname
@for /f "tokens=1,2 delims= " %%a in (%cd%\dnslist.txt) do (

rem @for /f "tokens=1,2 delims= " %%a in (%~dp0\dnslist.txt) do (
set dnsnumber=%%a
set dnsname=%%b
@%MYFILES%\adb shell settings put global private_dns_specifier !dnsname!
@echo  ---------------------------------------------------------------
rem @echo   = Включен DNS сервер:  [ !dnsname! ]
rem @echo  --- 
rem @echo    Осталось серверов:    [ !dnsnumber! ] 
@echo   = DNS server enabled:  [ !dnsname! ]
@echo  --- 
@echo    Remaining servers:    [ !dnsnumber! ]
@echo  ---------------------------------------------------------------
@echo.
rem @echo  = Wi-Fi шлема настраивается на новый сервер, секунду...
@echo  = Wi-Fi headset is being configured to the new server, please wait...
@timeout 3 /NOBREAK >nul
@echo.
call :_dnscontinues
)
:_dnslistfinished
call :_DelSearchUpdateFiles
@echo =====================================================
@echo.
rem @echo        +++ Список DNS завершен +++ 
rem @echo.
rem @echo   К сожалению, придется использовать клиент VPN
rem @echo  Установить его можно из Главного меню, пункты J-E
@echo        +++ DNS list completed +++ 
@echo.
@echo   Unfortunately, you'll need to use a VPN client.
@echo   You can install it from the Main Menu, options J-E.
@echo.
@echo.
goto _returnmenu

:_dnscontinues
@echo  --- 
rem @echo  Для смены DNS нажмите Enter
rem @echo  Для завершения и выхода в меню введите 0 и нажмите Enter
@echo  To change DNS, press Enter
@echo  To finish and return to the menu, enter 0 and press Enter
@set "choice="
@Set "choice=1"
@Set /p choice=">> "
::@echo.
if not defined choice goto _dnscontinues
if "%choice%"=="0" (GOTO _beginn)
if "%choice%"=="1" (exit /b)
goto _dnscontinues
exit /b

:_SETDEFAULT
call :_cdc
@%MYFILES%\adb shell settings put global private_dns_mode opportunistic
call :_erlvl
@%MYFILES%\adb shell settings put global private_dns_specifier null
@%MYFILES%\adb shell "svc wifi disable"
@timeout 3 >nul
@%MYFILES%\adb shell "svc wifi enable"
@echo ========================================
rem @echo  Дефолтные настройки установлены.
@echo  Default settings applied.
@echo.
goto _returnmenu

:_dnschangeint
call :_dnsintervalswitch
:_dnschange
rem call :_dnsintervalswitch
setlocal enableextensions enabledelayedexpansion
set timewait=%dnsint%
rem call :_cdc
@if not exist %~dp0\dnslist.txt call :_createfile
@%MYFILES%\adb shell settings put global private_dns_mode hostname
@for /f "tokens=1,2 delims= " %%a in (%~dp0\dnslist.txt) do (
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
rem @echo    === Автоматический подбор DNS серверов ===
rem @echo.
rem @echo  ===============================================================
rem @echo  = Включен DNS сервер	: [ !dnsname! ] 
rem @echo    Осталось проверить	: [ !dnsnumber! ]
rem @echo  ---
rem @echo  = Заполняем logcat после смены сервера: Ждите %timewait% секунд
rem @echo  ===============================================================
rem @echo     [ для прерывания нажмите любую кнопку ]
@echo    === Automatic DNS Server Selection ===
@echo.
@echo  ===============================================================
@echo  = Active DNS Server	: [ !dnsname! ] 
@echo    Remaining to check	: [ !dnsnumber! ]
@echo  ---
@echo  = Filling logcat after server change: Please wait %timewait% seconds
@echo  ===============================================================
@echo     [ Press any key to interrupt ]
echo.
echo.
echo.
call :_DelSearchUpdateFiles
timeout %timewait% | >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure Interrupted +++ ^ & @echo. ^ & @goto _returnmenu
call :_UpdateProgressSearchMain
rem call :_otbor0
)
set dnschangelist=0
rem echo Finish
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
rem @echo   DNS заглушка установлена, интернет на шлеме отключен.
rem @echo   Для удаления заглушки сбросьте настройки DNS к дефолтным.
rem @echo   Это пункт D в меню, которое сейчас на экране чуть выше.
rem @echo.
rem @echo.
rem @echo ^>^>^> Нажмите что-нибудь для выхода в предыдущее меню ^<^<^<
@echo   DNS spoofing is enabled, internet access on the headset is disabled.
@echo   To remove the spoofing, reset DNS settings to default.
@echo   This is option D in the menu, which is currently displayed on the screen just above.
@echo.
@echo.
@echo ^>^>^> Press any key to return to the previous menu ^<^<^<
@pause >nul
goto _todmenu

:_createfile
@echo 81 dns.adguard.com >> dnslist.txt
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
@echo 0 dns.adguard.com
@xcopy /R /Y dnslist.txt %temp% 1>NUL 2>&1
exit /b

:_dnsintervalswitch
set dnsint=15
rem set /p dnsint="Введите интервал между проверками и нажмите Enter : "
set /p dnsint="Enter the interval between checks and press Enter: "
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
@echo off
@echo      -----------------------------
rem @echo       ВЫБЕРИТЕ РАЗРЕШЕНИЕ ДИСПЛЕЯ
rem @echo      ----------------------------
rem @echo.
rem @echo    0.  Выход из программы
rem @echo    M.  Выход в Главное меню
rem @echo.
rem @echo    R.  Узнать текущее разрешение
rem @echo.
rem @echo  Установить разрешение:
@echo       SELECT DISPLAY RESOLUTION
@echo      ----------------------------
@echo.
@echo    0.  Exit the program
@echo    M.  Main menu
@echo.
@echo    R.  Get current resolution
@echo.
@echo  Set resolution:
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
rem @echo    N. 3661 x 3328   [EXP]  (Только для Meta Quest 3/Pro^!)
rem @echo    O. 3942 x 3584   [EXP]  (Только для Meta Quest 3/Pro^!)
rem @echo    P. 4224 x 3840   [EXP]  (Только для Meta Quest 3/Pro^!)
rem @echo    Q. 4506 x 4096   [EXP]  (Только для Meta Quest 3/Pro^!)
@echo    N. 3661 x 3328   [EXP]  (Only for Meta Quest 3/Pro^!)
@echo    O. 3942 x 3584   [EXP]  (Only for Meta Quest 3/Pro^!)
@echo    P. 4224 x 3840   [EXP]  (Only for Meta Quest 3/Pro^!)
@echo    Q. 4506 x 4096   [EXP]  (Only for Meta Quest 3/Pro^!)
@echo.
@echo.
rem @echo  Установить частоту обновления (Refresh Rate):
@echo  Set refresh rate:
@echo.
@echo    S. 120Гц
@echo    T. 90Гц
@echo    U. 80Гц
@echo    V. 72Гц
@echo    X. 60Гц
@echo.
@echo.
@echo.   ===================================================================
rem @echo    ^|   Повышенное резрешение от N до Q может привести к вылету игр.  ^|
rem @echo    ^|   Устанавливайте его только если вы точно знаете что делаете!   ^|
@echo    ^|   Increased resolution from N to Q may cause game crashes.   ^|
@echo    ^|   Set it only if you know exactly what you are doing!         ^|
@echo    ===================================================================
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
rem @echo  Параметры установлены
@echo  Parameters set
call :_prevmenu
cls
goto _resolutionfix

:_currentres
call :_cdc
@echo.
rem @echo  Текущее разрешение:
@echo  Current resolution:
@echo =====
@%MYFILES%\adb shell getprop debug.oculus.textureHeight
call :_erlvl
@echo  x
@%MYFILES%\adb shell getprop debug.oculus.textureWidth
@echo =====
rem @echo  [ пустые строки означают дефолтные значения ]
@echo  [ Empty lines indicate default values ]
@echo.
call :_prevmenu
cls
goto _resolutionfix

:_installmenugen
call :_hat
call :_hatmenu
@echo.
@echo.
@echo.
goto _eng17
@echo    A.  Запустить утилиту установки приложений Quest Install Director
@echo    B.  Запустить приложения на шлеме
@echo    C.  Узнать команду ADB для запуска приложения на шлеме
@echo    D.  Показать список установленных приложений
@echo.
@echo    E.  Установка VPN клиентов и драйверов Oculus
@echo    F.  Установка медиа приложений
@echo    G.  Установка прикладных приложений
@echo.
@echo.
@echo    ВАЖНО:
@echo.
@echo       Для установки приложений требуется интернет на ПК.
:_eng17
@echo    === Application Installation Menu ===
@echo.
@echo    A.  Run Quest Install Director utility
@echo    B.  Run applications on the headset
@echo    C.  Get ADB command to launch an application on the headset
@echo    D.  Show list of installed applications
@echo.
@echo    E.  VPN clients and Oculus drivers installation
@echo    F.  Media applications installation
@echo    G.  Productivity applications installation
@echo.
@echo.
@echo    IMPORTANT:
@echo.
@echo       Internet connection on the PC is required for application installation.
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
if /i "%choice%"=="d" (GOTO _AppsInstalledList)
if /i "%choice%"=="e" (GOTO _InstallVPNClients)
if /i "%choice%"=="f" (GOTO _InstallMediaApps)
if /i "%choice%"=="g" (GOTO _InstallSoftwareApps)
@cls
goto _installmenugen


:_InstallSoftwareApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem @echo      === Установка прикладных приложений ===
@echo      === Installation of Productivity Applications ===
@echo.
@echo.
@echo    A.  = VRComm mobile client
@echo    B.  = LightningLauncher
rem @echo    C.  = Файловый менеджер+
@echo    C.  = File Manager+
@echo    D.  = Wolvic (browser with  VR support)
@echo    E.  = Bugjaeger Premium
@echo    F.  = Termux
@echo    G.  = Oculus Wireless ADB
@echo    H.  = RCX
@echo    I.  = TotalCommander
@echo    J.  = SH Script Runner
@echo    K.  = ADB GUI Tool
@echo    L.  = OVR Metrics Tool
@echo    N.  = Internet Speed Meter
@echo    O.  = Script Manager
@echo    P.  = Passthrough cam tool


@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallSoftwareApps
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _vrcomm)
if /i "%choice%"=="b" (GOTO _llauncher)
if /i "%choice%"=="c" (GOTO _fmplus)
if /i "%choice%"=="d" (GOTO _wolvic)
if /i "%choice%"=="e" (GOTO _bujaegerinst)
if /i "%choice%"=="f" (GOTO _termuxinst)
if /i "%choice%"=="g" (GOTO _ocwirelessadbinst)
if /i "%choice%"=="h" (GOTO _rcxinst)
if /i "%choice%"=="i" (GOTO _totalcomminst)
if /i "%choice%"=="j" (GOTO _shscriptinst)
if /i "%choice%"=="k" (GOTO _addguiinst)
if /i "%choice%"=="l" (GOTO _OVRMetricsTool)
if /i "%choice%"=="n" (GOTO _ismeterinst)
if /i "%choice%"=="o" (GOTO _scriptmanager)
if /i "%choice%"=="p" (GOTO _passthrough)

@cls
goto _InstallSoftwareApps


:_InstallMediaApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem @echo      === Установка медиа приложений ===
@echo      === Installation of Media Applications ===
@echo.
@echo.
@echo    A.  = Skybox VR Video Player
@echo    B.  = Moon VR Video Player
@echo    C.  = 4XVR Video Player
@echo    D.  = Pigasus VR Video Player
@echo    E.  = HereSphere VR Video Player
@echo    F.  = VLC Media Player
@echo    G.  = TorServe
rem @echo    H.  = Filmix UHD (Онлайн кинотеатр)
rem @echo    I.  = Кино HD  (Онлайн кинотеатр)
@echo.
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
rem if /i "%choice%"=="h" (GOTO _filmixinst)
rem if /i "%choice%"=="i" (GOTO _kinohdinst)
@cls
goto _InstallMediaApps

:_InstallVPNClients
call :_hat
call :_hatmenu
@echo.
@echo.
rem @echo      === Установка VPN клиентов и драйверов ===
@echo      === Installation of VPN Clients and Drivers ===
@echo.
@echo.
@echo    A.  = Ultrasurf
@echo    B.  = Winscribe
@echo    C.  = OpenVPN Connect
@echo    D.  = OutlineVPN
@echo    E.  = AdGuard VPN
@echo    F.  = Shadowsocks
@echo    G.  = Psiphon VPN
@echo    H.  = Proton VPN
@echo    I.  = Free VPN Planet
@echo.
rem @echo    P.  Установить драйверы Oculus на ПК  (Для Windows 7 )
@echo    P.  Install Oculus drivers on PC  (For Windows 7)
rem @echo    Q.  Установить драйверы Oculus на ПК  (Для Windows 10)
@echo    P.  Install Oculus drivers on PC  (For Windows 10)
@echo        [ v1.71.000014 - 02.2023 ]
rem @echo    R.  Установить драйверы Oculus на ПК  (Для Windows 10)
@echo    P.  Install Oculus drivers on PC  (For Windows 10)
@echo        [ v1.71.000017 - 09.2023 ]
@echo.
@echo.
rem @echo  ВАЖНОЕ:
rem @echo.
rem @echo.    Для приложений Shadowsocks и Outline VPN можно ввести ключи
rem @echo     доступа к серверам очень просто и непосредственно с ПК.
rem @echo     Используйте Пункт 2 в Главном меню.
@echo  IMPORTANT:
@echo.
@echo.    For Shadowsocks and Outline VPN applications, you can enter
@echo     server access keys very easily and directly from the PC.
@echo     Use Item 2 in the Main Menu.
@echo.
rem @echo     Чтобы просто открыть ссылку на страничку помощи, введите
rem @echo     сдвоенный номер пункта, например II, ii, JJ, jj и т.д.
@echo.
::@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _InstallVPNClients
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (GOTO _ultrasurf)
rem if /i "%choice%"=="aa" (GOTO _ultrasurfl)
if /i "%choice%"=="b" (GOTO _winscribe)
rem if /i "%choice%"=="bb" (GOTO _winscribel)
if /i "%choice%"=="c" (GOTO _openvpnc)
rem if /i "%choice%"=="cc" (GOTO _openvpncl)
if /i "%choice%"=="c" (GOTO _outline)
rem if /i "%choice%"=="dd" (GOTO _outlinel)
if /i "%choice%"=="e" (GOTO _adguard)
rem if /i "%choice%"=="ee" (GOTO _adguardl)
if /i "%choice%"=="f" (GOTO _shadowsocks)
rem if /i "%choice%"=="ff" (GOTO _shadowsocksl)
if /i "%choice%"=="g" (GOTO _psiphon)
rem if /i "%choice%"=="gg" (GOTO _psiphonl)
if /i "%choice%"=="h" (GOTO _proton)
rem if /i "%choice%"=="hh" (GOTO _protonl)
if /i "%choice%"=="i" (GOTO _freeplanet)
if /i "%choice%"=="p" (GOTO _setdrivers7)
if /i "%choice%"=="q" (GOTO _setdrivers14)
if /i "%choice%"=="r" (GOTO _setdrivers17)
@cls
goto _InstallVPNClients


:_AppsInstalledList

echo off
rem 
rem goto _testconv
:_AppsInstallMenu
@cls
call :_hatapps
@echo.
@echo.
goto _eng18
@echo   0. Выход из программы
@echo   M. Выход в главное меню
@echo.
@echo   1. Список всех приложений
@echo   2. Список системных приложений 
@echo   3. Список неофициальных приложений
@echo   4. Список отключенных приложений
@echo   5. Список включенных приложений
@echo   6. Список приложений c фильтрацией (по имени приложения)
@echo.
@echo.
@echo   ВАЖНО:
@echo.
@echo     Для использования этой функции на ПК должен быть интернет.
@echo     Обработка списка займет примерно минуту.
:_eng18
@echo   0. Exit the program
@echo   M. Return to the main menu
@echo.
@echo   1. List all applications
@echo   2. List system applications
@echo   3. List unofficial applications
@echo   4. List disabled applications
@echo   5. List enabled applications
@echo   6. List applications with filtering (by application name)
@echo.
@echo.
@echo   IMPORTANT:
@echo.
@echo     Internet access is required on the PC to use this function.
@echo     Processing the list will take approximately one minute.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _appsmenu
if "%choice%"=="0" (exit)
rem if "%choice%"=="1" (set listpackages=-a && set pkgchoice=all &&set pkgfiltername=всех&& goto _StartAppsInstalledScript)
rem if "%choice%"=="2" (set listpackages=-s && set pkgchoice=system &&set pkgfiltername=системных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="3" (set listpackages=-3 && set pkgchoice=thrid-party &&set pkgfiltername=неофициальных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="4" (set listpackages=-d && set pkgchoice=disabled &&set pkgfiltername=отключенных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="5" (set listpackages=-e && set pkgchoice=enabled &&set pkgfiltername=включенных&& goto _StartAppsInstalledScript)
rem if "%choice%"=="6" (set pkgfiltername=отфильтрованных&& goto _packageSearchFilter)
if "%choice%"=="1" (
    set listpackages=-a
    set pkgchoice=all
    set pkgfiltername=всех
    goto _StartAppsInstalledScript
)

if "%choice%"=="2" (
    set listpackages=-s
    set pkgchoice=system
    set pkgfiltername=системных
    goto _StartAppsInstalledScript
)

if "%choice%"=="3" (
    set listpackages=-3
    set pkgchoice=thrid-party
    set pkgfiltername=неофициальных
    goto _StartAppsInstalledScript
)

if "%choice%"=="4" (
    set listpackages=-d
    set pkgchoice=disabled
    set pkgfiltername=отключенных
    goto _StartAppsInstalledScript
)

if "%choice%"=="5" (
    set listpackages=-e
    set pkgchoice=enabled
    set pkgfiltername=включенных
    goto _StartAppsInstalledScript
)

if "%choice%"=="6" (
    set pkgchoice=filtered
    set pkgfiltername=отфильтрованных
    goto _packageSearchFilter
)
rem if "%choice%"=="R" (GOTO _menurestart)
rem if "%choice%"=="r" (GOTO _menurestart)
goto _appsmenu


:_packageSearchFilter
call :_cdc
@echo ===============================================================================
@echo.
@echo.
rem @echo     Для вывода приложений с фильтрацией введите название пакета или его часть,
rem @echo     например "facebook" или "face" без кавычек
rem @echo.
rem @echo     Для выхода в меню введите любую скобку и нажмитте Enter
@echo     To display applications with filtering, enter the package name or part of it,
@echo     for example "facebook" or "face" without quotes
@echo.
@echo     To return to the menu, enter any bracket and press Enter
@echo.
@echo.
@echo.
rem face
rem @Set /p pkgsearch="Введите название или его часть и нажмите Enter : "
@Set /p pkgsearch="Enter the name or part of it and press Enter: "
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
set "listpackages=%pkgsearch%" && set pkgchoice=filtered && goto _StartAppsInstalledScript

:_StartAppsInstalledScript
call :_cdc
@cls
call :_hatapps
setlocal enabledelayedexpansion
@echo.
rem @echo ---------------------------------------------------
rem @echo = Составляем список %pkgfiltername% приложений.
rem @echo.
rem @echo   Это займет около мминуты.
rem @echo.
rem @echo   Затем он будет выведен на экран и сохранен в файл.
rem @echo   Перелистывание списка можно делать клавишей "пробел" 
@echo = Compiling a list of %pkgchoice% applications.
@echo.
@echo   This will take about a minute.
@echo.
@echo   Then it will be displayed on the screen and saved to a file.
@echo   You can navigate the list using the "space" key.
rem @echo.
@echo --------------------------------------------------------

set shscriptname=aaptname.sh

@%MYFILES%\wget -q --no-hsts https://www.dropbox.com/scl/fi/qye8alhqdcbh56jjjqd1t/aapt-arm-pie?rlkey=rb3jblds5pn8s8up08oag3d04 -O aapt-arm-pie

@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie>>%shscriptname%
@echo pm list packages %listpackages% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
@echo     printf "app $label having package name $line\n";>>%shscriptname%
@echo     printf "\n";>>%shscriptname%
@echo done>>%shscriptname%
@%myfiles%\adb push aapt-arm-pie /data/local/tmp/ 1>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell chmod 0755 /data/local/tmp/aapt-arm-pie
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >o.txt 2>nul

rem :_testconv
rem set listpackages=-3
rem setlocal enabledelayedexpansion

@for /f "tokens=*" %%A in ('type o.txt ^| findstr /r /c:"app.*having package name" ^| sort') do (
    set "line=%%A"
    set "line=!line:app=!"
    set "line=!line:having package name= ; !"
    set "line=!line:&=-!"
@for /f "tokens=1,2 delims=;" %%A in ("!line!") do (
set first=%%A
set second=%%B
Call :EchoTab "!first!" 6 "!second!"  >>AppsInstalled-!pkgchoice!.txt 2>nul
)
)
@del /q o.txt
@del /q aapt-arm-pie
@del /q %shscriptname%
@more "AppsInstalled-%pkgchoice%.txt" 2>nul
rem if errorlevel==1 @echo. && @echo  = Список %pkgfiltername% приложений пуст && @echo  ----- && @echo. && goto _returnmenu
if errorlevel==1 @echo. && @echo  = The list of %pkgchoice% applications is empty && @echo  ----- && @echo. && goto _returnmenu
@echo.
@echo ====================================================================================
rem @echo Список %pkgfiltername% приложений сохранен в файл AppsInstalled-%pkgchoice%.txt
@echo The list of %pkgchoice% applications is saved to the file AppsInstalled-%pkgchoice%.txt
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

:_cdc
@%myfiles%\adb shell getprop ro.boot.serialno 1>NUL 2>&1
rem echo %errorlevel%
rem exit /b
IF %errorlevel%==1 goto _NoDevice
exit /b

:_hatapps
@echo ==================================================================================================
@echo        Quest Apps Viewer - created by Varset - v.1.0.0 - 02.11.23%hatcod%
@echo ==================================================================================================
exit /b



:_installqid
@echo off
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
goto _eng19
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
:_eng19
@echo    To install applications, copy and paste
@echo    below the apk file or directory containing the games.
@echo    Or simply press Enter to use the current directory
@echo. 
@echo.
@echo    IMPORTANT:
@echo. 
@echo    drag&drop may not be supported if the program is launched 
@echo    with administrator privileges. Therefore:
@echo. 
@echo    Additional parameters can be used in the program:
@echo.
@echo       u - launch with current user privileges (UAC is not triggered)
@echo       a - launch with a request for administrator privileges (UAC is always triggered)
@echo       c - launch with a request for privilege elevation (UAC is triggered if you are an admin)
@echo       d - enable the ability to install downgraded versions of applications
@echo       v - enable verbose installation process. Disabled by default.
@echo       l - log installation process to a file. Ignored if 'v' flag is set.
@echo       m - install applications with prior uninstallation and data clearing
@echo           [before uninstalling applications, data will be saved to the BackupsData directory]  
@echo       r - restore data after reinstallation. Ineffective without the 'm' flag.
@echo       s - save application data. Works independently from other options.
@echo       w - clear application data and cache. Works independently from other options.
@echo.
@echo.
@echo    Parameters should be entered BEFORE installation starts
@echo.
@echo.
@echo.
@echo    Enabled parameters will be displayed here:  [  %verbose% %logs% %mov% %rest% %dg%]
@echo.
@echo.
@echo.
@echo.
set installname=
set installname=%cd%
rem @Set /p installname="Бросьте сюда apk, каталог или введите параметр и жмите Enter >>> "
@Set /p installname="Drop the apk here, directory, or enter a parameter and press Enter >>> "
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
rem @echo    +++ Это не каталог, не apk файл и не ключ +++
rem @echo   Пожалуйста, бросьте что-нибудь более подходящее
@echo    +++ This is not a directory, not an apk file, and not a key +++
@echo              Please drop something more suitable
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
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging "!apkname!" ^| find "application-label:"') DO set applabel=%%g
call :_MultiInstallProcess
@echo -----------------------------------------------
)
@echo ================================================
@echo.
rem @echo  +++ Установка завершена +++
rem @echo.
rem @echo   Установлено		: !MultiCounterOk!
rem @echo   Не установлено	: %MultiCounterEr%
rem @echo --------------------------------------------
rem @echo.
rem @echo   Список не установленных приложений сохранен в notinstalled.txt
rem @echo   Попробуйте установить их вручную. Также возможно, что
rem @echo   в имени файла/каталога есть восклицательный знак, удалите его.
@echo  +++ Installation completed +++
@echo.
@echo   Installed	: !MultiCounterOk!
@echo   Not Installed	: %MultiCounterEr%
@echo --------------------------------------------
@echo.
@echo   The list of not installed applications is saved in notinstalled.txt
@echo   Try to install them manually. Also, it is possible that
@echo   there is an exclamation mark in the file/directory name, remove it.
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
rem @echo  %MultiCounterOk%. Устанавливаем  "%applabel%"
@echo  %MultiCounterOk%. Installing  "%applabel%"
@%MYFILES%\ADB install -r -g --no-streaming "%apkname%" %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (call :_MultiCopyObbInslallApk) else (call :_MultiInstallApkErr)
call :_restdata
set applabel=
set pkgname=
exit /b

:_MultiCopyObbInslallApk
if not exist "%PathGame%%pkgname%" call :_MultiInstalledOk && exit /b
@echo --
rem @echo     Копируем "%pkgname%" в каталог OBB на шлем..
@echo     Copying "%pkgname%" to the OBB directory on the headset..
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "%PathBeforeObbPath%%pkgname%" /sdcard/Android/obb/ %hidefrstp% %hidescndp%
call :_MultiInstalledOk
exit /b

:_MultiInstallApkErr
@echo.
@echo.
rem @echo  +++ Ошибка установки !apknamefile! +++
rem @echo.
rem @echo  == Продолжаем установку..
@echo  +++ Installation error !apknamefile! +++
@echo.
@echo  == Continuing installation..
@echo.
@echo.
set /a MultiCounterEr=%MultiCounterEr%+1
@echo  !apkname! >>notinstalled.txt
exit /b

:_MultiInstalledOk
@echo --
rem @echo   = Установлено успешно
@echo   = Successfully installed
rem pause
exit /b

:_SingleApkInstall
call :_cdc
@echo off
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
FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging !apkname! ^| find "application-label:"') DO set applabel=%%g
@echo -----------------------------------------------
if [!mov!]==[] set mov=empty
if %mov%==m call :_mov
rem @echo   Устанавливаем "%applabel%"
@echo   Installing  "%applabel%"
rem echo on
rem echo f hidefsrtp%
rem echo s %hidescndp%
rem pause
@%MYFILES%\ADB install -r -g %down% --no-streaming !apkname! %hidefrstp% %hidescndp%
rem pause
@IF !ERRORLEVEL!==0 (call :_SingleCopyObbInslallApk) else (call :_SingleErrInstallApk)
call :_restdata
@echo --
rem @echo   = Установлено успешно
@echo   = Successfully installed
@echo ===========================================
echo.
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
rem @echo   Копируем "%pkgname%" в каталог OBB в шлем...
@echo     Copying "%pkgname%" to the OBB directory on the headset..
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "%PathIncludePathGame%%pkgname%" /sdcard/Android/obb/ %hidefrstp% %hidescndp%
exit /b

:_SingleErrInstallApk
@echo ===========================================
rem @echo 	    +++ Ошибка установки +++
rem @echo  Причину можно узнать в файле error.txt
rem @echo Также можете включить l или v в начальном меню
@echo     +++ Installation error +++
@echo  You can find the reason in the error.txt file
@echo  You can also enable 'l' or 'v' in the initial menu
echo.
@goto _returnmenuqid

:: === Установка с удалением
:_mov
@call :_settime
rem @echo  ..Сохраняем данные..
@echo  ..Saving data..
echo %dt%
echo !dt!
@md %cd%\BackupsData 1>nul 2>nul
@%myfiles%\adb pull /sdcard/Android/data/!pkgname! %cd%\BackupsData %hidefrstp% %hidescndp%
::@%myfiles%\7z.exe a -mx7 -t7z -ssw !pkgname!-%dt%.7z %cd% %hidefrstp% %hidescndp%
rem @echo  ..Removing the application..
@echo  ..Удаляем приложение..
%MYFILES%\ADB shell pm clear !pkgname! %hidefrstp% %hidescndp%
%MYFILES%\adb shell pm uninstall !pkgname! %hidefrstp% %hidescndp%
::@echo.
rem @echo  ..Подчищаем остатки..
@echo  ..Cleaning up leftovers..
%MYFILES%\adb shell rm -rf sdcard/Android/obb/!pkgname! %hidefrstp% %hidescndp%
%MYFILES%\adb shell rm -rf sdcard/Android/data/!pkgname! %hidefrstp% %hidescndp%
@echo  ---------------------
exit /b

:_restdata
if [!rest!]==[] set rest=rempty
if !mov!==m if !rest!==r call :_restoredata
exit /b
:_restoredata
rem @echo  ..Восстанавливаем данные обратно..
@echo  ..Restoring data back..
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
rem @Set /p savedata="Нажмите Enter для начала сохранения данных или 0 для выхода в меню >>> "
@Set /p savedata="Press Enter to start saving data or 0 to return to the menu >>> "
if %savedata%==0 (goto _InstallMenu)
@echo -----------------------
rem @echo  ..Сохраняем данные..
@echo  ..Saving data..
@md %cd%\%dt%-BackupsData 1>nul 2>nul
@%myfiles%\adb pull /sdcard/Android/data/!pkgname! %cd%\%dt%-BackupsData %hidefrstp% %hidescndp%
@echo.
rem @echo  = Данные сохранены в каталоге %dt%-BackupsData
@echo  = Data saved in the directory %dt%-BackupsData
@echo -----
goto _returnmenuqid


:_WipeData
cls
call :_hat
@echo.
@echo.
rem @echo    Бросьте сюда apk приложения, 
rem @echo    данные которого хотите почистить, и жмите Enter
rem @echo    .. Да-да, никакой ошибки, именно так. Пока что.
@echo    Drop here the apk of the application 
@echo    whose data you want to clear, and press Enter
@echo    ..Yes, no mistake, that's right. For now.
set wipedata=
set wipedata=1
@echo.
@echo.
@echo.
@echo.
@echo.
rem @Set /p wipedata="Нажмите Enter для очистки данных или 0 для выхода в меню >>> "
@Set /p wipedata="Press Enter to clear data or 0 to exit to the menu >>> "
if %wipedata%==0 (goto _InstallMenu)
@Set "apkname=%wipedata%"
@For %%v In (!apkname!) Do Set "PathIncludePathGame=%%~dpv"
for /f "tokens=*" %%a in ('%myfiles%\aapt2 dump packagename !apkname!') do set pkgname=%%a
@echo -----------------------
rem @echo  ..Сохраняем данные..
@echo  ..Saving data..
@md %cd%\BackupsData 1>nul 2>nul
@%myfiles%\adb pull /sdcard/Android/data/!pkgname! %cd%\BackupsData %hidefrstp% %hidescndp%
@echo.
rem @echo  = Данные сохранены в каталоге BackupsData
rem @echo ---
rem @echo  ..Чистим данные и кэш..
@echo  = Data saved in the BackupsData directory
@echo ---
@echo  ..Cleaning data and cache..
%MYFILES%\ADB shell pm clear !pkgname! %hidefrstp% %hidescndp%
@echo.
rem @echo  = Данные и кэш очищены
@echo  = Data and cache cleared
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
set sz=Гб
)
rem @echo 								^| Общий объем : !aa:~,-1!!sz!
rem @echo 								^| Занято      : !bb:~,-1!!sz!
rem @echo 	0. Выход из программы					^| Свободно    : !cc:~,-1!!sz!
rem @echo 	X. Выход в меню						^| Заполнено   : !dd!
@echo 								^| Total volume	: !aa:~,-1!!sz!
@echo 								^| Occupied: !bb:~,-1!!sz!
@echo 0. Exit program 						^| Free: !cc:~,-1!!sz!
@echo X. Exit to menu 						^| Filled: !dd!
@echo 								-----------------------------
exit /b

:_returnmenuqid
@echo.
rem @echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
@echo ^>^>^> Press any key to return to the menu ^<^<^<
@pause >nul
@cls
goto _InstallMenuQid


:_StartingApps
call :_hat
call :_hatmenu
@echo.
@echo.
rem @echo    Запустить приложения на шлеме:
@echo    Launch applications on the headset:
@echo.
rem @echo    A.  = Pi Launcher Next Fix 3            = [EXP]
@echo    B.  = LightningLauncher                 = [EXP]
rem @echo    C.  = Файловый менеджер+                = [EXP]
@echo    C.  = File Manager+                = [EXP]
::@echo    D.  = Wolvic (браузер с поддержкой VR)  = [EXP]
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
rem if /i "%choice%"=="a" (GOTO _startpifix)
if /i "%choice%"=="b" (GOTO _startll)
if /i "%choice%"=="c" (GOTO _startfm)
::if /i "%choice%"=="d" (GOTO _startwv)
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
rem @echo Стартуем dipVR App Launcher..
@echo Launching dipVR App Launcher...
@%MYFILES%\adb shell am start com.threethan.launcher/com.threethan.launcher.launcher.LauncherActivitySearchable 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startfm
call :_cdc
rem @echo Стартуем Файловый менеджер+..
@echo Launching File Manager+...
@%MYFILES%\adb shell am start com.alphainventor.filemanager/.activity.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:::_startwv
::@echo Стартуем браузер Wolvic..
::@%MYFILES%\adb shell am start us.ultrasurf.mobile.ultrasurf/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
::goto _CheckInstallApp

:_startus
call :_cdc
rem @echo Стартуем Ultrasurf..
@echo Launching Ultrasurf..
@%MYFILES%\adb shell am start us.ultrasurf.mobile.ultrasurf/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startws
call :_cdc
rem @echo Стартуем Winscribe..
@echo Launching Winscribe..
@%MYFILES%\adb shell am start com.windscribe.vpn/com.windscribe.mobile.splash.SplashActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startovpn
call :_cdc
rem @echo Стартуем Open VPN Connect..
@echo Launching Open VPN Connect.. 
@%MYFILES%\adb shell am start net.openvpn.openvpn/net.openvpn.unified.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startouvpn
call :_cdc
rem @echo Стартуем Outline VPN..
@echo Launching Outline VPN..
@%MYFILES%\adb shell am start org.outline.android.client/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startag
call :_cdc
rem @echo Стартуем AdGuard VPN..
@echo Launching AdGuard VPN..
@%MYFILES%\adb shell am start com.adguard.vpn/.ui.SplashActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startss
call :_cdc
rem @echo Стартуем Shadowsocks..
@echo Launching Shadowsocks..
@%MYFILES%\adb shell am start com.github.shadowsocks/.MainActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startps
call :_cdc
rem @echo Стартуем Psiphon 3...
@echo Launching Psiphon 3...
@%MYFILES%\adb shell am start com.psiphon3/.MainActivity 2>&1 | find "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startpt
call :_cdc
rem @echo Стартуем ProtonVPN..
@echo Launching ProtonVPN..
@%MYFILES%\adb shell am start ch.protonvpn.android/com.protonvpn.android.ui.onboarding.SplashActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_startfp
call :_cdc
rem @echo Стартуем Free Planet VPN..
@echo Launching Planet VPN..
@%MYFILES%\adb shell am start com.freevpnplanet/.presentation.splash.view.SplashActivity 2>&1 | findstr "Error type 3" 2>nul 1>nul
goto _CheckInstallApp

:_CheckInstallApp
@IF %ERRORLEVEL% NEQ 0 (
@echo.
rem @echo = Наденьте шлем, программа должна быть открыта
@echo = Put on the headset, the program should be open
@echo.
@echo ==============================================================
@echo.
goto _returnmenu
) else (
@echo --------------------------------------------------------
@echo.
rem @echo     +++ Программа не установлена на шлем +++
rem @echo.
rem @echo   Нажмите любую кнопку для перехода к меню установки
@echo     +++ The program is not installed on the headset +++
@echo.
@echo   Press any key to go to the installation menu
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
rem @set /p launch="Бросьте сюда файл apk для получения информации: "
@set /p launch="Drop the apk file here to get information: "
if not defined launch goto _CommandLaunchApp
@set "launchappl=%launch%"
if "%launch%"=="0" (exit)
if /i "%launch%"=="m" (GOTO _beginn)
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %launchappl% ^| find "application-label:"') DO set applabel=%%g
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %launchappl% ^| FIND "package: name="') DO set pckgname=%%g
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %launchappl% ^| find "launchable-activity:"') DO set launchact=%%g
:_AppInfo
cls
call :_hat
@echo.
@echo.
@echo.
@echo.
@echo =============================================================================================
@echo.
rem @echo   Имя приложения:
@echo   Application name:
@echo     %applabel%
@echo  ---
rem @echo   Имя пакета:
@echo   Package name:
@echo     %pckgname%
@echo  ---
rem @echo   Строка запуска приложения:
@echo   Application launch string:
@echo     adb shell am start %pckgname%/%launchact%
@echo adb shell am start %pckgname%/%launchact% | clip
@echo.
@echo =============================================================================================
rem @echo Строка запуска скопирована в буфер, ее можно вставить в текстовый файл или консольное окно.
@echo Launch string copied to clipboard, you can paste it into a text file or console window.
@echo ---------------------------------------------------------------------------------------------
@echo.
@echo.
set launchstring=
set launchstring=1
rem @Set /p launchstring="Нажмите Enter для отправки команды на шлем или 0 для выхода в меню >>> "
@Set /p launchstring="Press Enter to send the command to the headset or 0 to return to the menu >>> "
if %launchstring%==0 (goto _installmenugen)
if %launchstring%==1 (adb shell am start %pckgname%/%launchact% 2>&1 | findstr "Error type 3" 2>nul 1>nul & goto _CheckInstallApp)
goto _AppInfo

:: Секция установки прикладных приложений
:: Section for installing application software


:_llauncher
call :_cdc
set dlappl=LightingLauncherArm64.apk
set wgetlink=https://www.dropbox.com/scl/fi/edmompfm3wavsy1uem5vp/LightingLauncherArm64.apk?rlkey=41i4usnwfiz15kmpe5n8g0qbh -O LightingLauncherArm64.apk
call :_dlandinstallnew
call :_prevmenu
goto _installmenugen

:_fmplus
call :_cdc
set dlappl=fmplus.apk
set wgetlink=https://www.dropbox.com/s/atq6zl34cyx5p50/fmplus.apk
goto :_dlandinstall

:_vrcomm
call :_cdc
set dlappl=vrcomm.apk
set wgetlink=https://www.dropbox.com/scl/fi/amadcbc0lanfnf0uwsk7f/vrcomm.apk?rlkey=r5ir8zpjcusnocrxbh79f7chu -O vrcomm.apk
goto :_dlandinstall

rem :_pilauncherfix
rem call :_cdc
rem set dlappl=PiLauncherNextHotfix3.apk
rem set wgetlink=https://www.dropbox.com/scl/fi/3p6p5kb8rvl0o0jwowpld/PiLauncherNextHotfix3.apk?rlkey=hb4d04jdy77i8whvm4baonm1k -O PiLauncherNextHotfix3.apk
rem goto :_dlandinstall

:_wolvic
call :_cdc
set dlappl=wolvic.apk
set wgetlink=https://www.dropbox.com/s/5r4jiu4or2af8wt/wolvic.apk
goto :_dlandinstall

:_OVRMetricsTool
call :_cdc
set dlappl=OVRMetricsTool_v1.6.5.apk
set wgetlink=https://www.dropbox.com/scl/fi/3o3ne0nh9bdiob5vpxhd0/OVRMetricsTool_v1.6.5.apk?rlkey=aqxrvwfx4qb66tnsuz6hnzqpf -O OVRMetricsTool_v1.6.5.apk
goto :_dlandinstall

:_bujaegerinst
call :_cdc
set dlappl=Bugjaeger-Premium-v5.0-full.apk
set wgetlink=https://www.dropbox.com/scl/fi/s098v5stzlktj91gkkpsp/Bugjaeger-Premium-v5.0-full.apk?rlkey=qp99kc6q6nm7j89r53gh5f8q0 -O Bugjaeger-Premium-v5.0-full.apk
goto :_dlandinstall

:_termuxinst
call :_cdc
set dlappl=termux-app_v0.118.0.apk
set wgetlink=https://www.dropbox.com/scl/fi/hsd3yiq0nuj86wxuih5mf/termux-app_v0.118.0.apk?rlkey=20ofy3qyiv3kzlkx3zeltj55d -O termux-app_v0.118.0.apk
goto :_dlandinstall

:_ocwirelessadbinst
call :_cdc
set dlappl=tdg.oculuswirelessadb-1.2.apk
set wgetlink=https://www.dropbox.com/scl/fi/04aodeddzojdwpkqqi2zf/tdg.oculuswirelessadb-1.2.apk?rlkey=v3gl22fr99zqfjsocoatt0lp0 -O tdg.oculuswirelessadb-1.2.apk
goto :_dlandinstall

:_rcxinst
call :_cdc
set dlappl=rcx-v1.12.2-arm64-v8a-release.apk
set wgetlink=https://www.dropbox.com/scl/fi/tdot38l2jo0t5ivrejkk2/rcx-v1.12.2-arm64-v8a-release.apk?rlkey=uk2brp08rg42obtb2r09nocja -O rcx-v1.12.2-arm64-v8a-release.apk
goto :_dlandinstall

:_totalcomminst
call :_cdc
set dlappl=tcandroid341d-universal.apk
set wgetlink=https://www.dropbox.com/scl/fi/lf4rdasnp9m1un9x78823/tcandroid341d-universal.apk?rlkey=mxgfqoasl5sov1lggi5fad83q -O tcandroid341d-universal.apk
goto :_dlandinstall

:_shscriptinst
call :_cdc
set dlappl=SHScriptRunner_1.10.apk
set wgetlink=https://www.dropbox.com/scl/fi/qfto9bm36pwfnqvnv0h63/SHScriptRunner_1.10.apk?rlkey=falgqxtj7m30eiao2cgzq9b5r -O SHScriptRunner_1.10.apk
goto :_dlandinstall

:_addguiinst
call :_cdc
set dlappl=ADB_vV3.3.154.apk
set wgetlink=https://www.dropbox.com/scl/fi/n19q1ua5i9v8sxtghb1fq/ADB_vV3.3.154.apk?rlkey=naa6lwrulz9betslygqkgdic1 -O ADB_vV3.3.154.apk
goto :_dlandinstall

:_ismeterinst
call :_cdc
set dlappl=InternetSpeedMeter+v1.5.9-pro.apk
set wgetlink=https://www.dropbox.com/scl/fi/digww6psdpwjhlhen8wqf/InternetSpeedMeter-v1.5.9-pro.apk?rlkey=56lp8ij9x0raokoqpwqjqwgz1 -O InternetSpeedMeter+v1.5.9-pro.apk
goto :_dlandinstall

:_scriptmanager
call :_cdc
set dlappl=ScriptManager_50.apk
set wgetlink=https://www.dropbox.com/scl/fi/2w1sy48v9tti4i3mdstqf/ScriptManager_50.apk?rlkey=aejdquia8mxih0llaj8e3n04p -O ScriptManager_50.apk
goto :_dlandinstall

:_passthrough
call :_cdc
set dlappl=Passthrough.apk
set wgetlink=https://www.dropbox.com/scl/fi/0ccpmjiy49dya85ex32s1/Passthrough.apk?rlkey=o9g7mxnki703x67w3jq2gzvnf -O Passthrough.apk
goto :_dlandinstall


:: Установка медиа приложений
:_skyboxinst
call :_cdc
set dlappl=xyz.skybox.player.ovr.apk
set wgetlink=https://www.dropbox.com/scl/fi/5k90nm5z01v4eal7fnvku/xyz.skybox.player.ovr.apk?rlkey=dz5jfnp7jdm7kb0xq23iq1hl0 -O xyz.skybox.player.ovr.apk
goto :_dlandinstall

:_pigasusinst
call :_cdc
set dlappl=com.hanginghatstudios.pigasus.apk
set wgetlink=https://www.dropbox.com/scl/fi/dlf05gqkkhgcn0i608sfk/com.hanginghatstudios.pigasus.apk?rlkey=dbdkjtlms140nd09s9f61wa0p -O com.hanginghatstudios.pigasus.apk
goto :_dlandinstall

:_4xplayerinst
call :_cdc
set dlappl=cn.vr4p.oculus4xvplayerov.apk
set wgetlink=https://www.dropbox.com/scl/fi/fw29ieujy510bqc6wdmjh/cn.vr4p.oculus4xvplayerov.apk?rlkey=8ehtks968uzm5ponf7mp7nnes -O cn.vr4p.oculus4xvplayerov.apk
goto :_dlandinstall

:_moonplayerinst
call :_cdc
set dlappl=com.rockvr.moonplayer.apk
set wgetlink=https://www.dropbox.com/scl/fi/298cdkddz06davz1v8vd4/com.rockvr.moonplayer.apk?rlkey=sesy5qkxtwrq7hqh0k40eybyv -O com.rockvr.moonplayer.apk
goto :_dlandinstall

:_hsphereinst
call :_cdc
set dlappl=net.heresphere.vrvideoplayer.apk
set wgetlink=https://www.dropbox.com/scl/fi/ox2ydoiy2gz7slwg05xvy/net.heresphere.vrvideoplayer.apk?rlkey=gfpm2whk470tgagenpje79nut -O net.heresphere.vrvideoplayer.apk
goto :_dlandinstall

:_vlcinst
call :_cdc
set dlappl=VLC_v.3.5.4.apk
set wgetlink=https://www.dropbox.com/scl/fi/27s1l3ufinvo7nwle42gl/VLC_v.3.5.4.apk?rlkey=z3o7t78pwa2osevjkqx31ixdp -O VLC_v.3.5.4.apk
goto :_dlandinstall

:_torserveinst
call :_cdc
set dlappl=TorrServe_MatriX.127.Client-release.apk
set wgetlink=https://www.dropbox.com/scl/fi/hjuggqqh1tkqoave1m4au/TorrServe_MatriX.127.Client-release.apk?rlkey=4wydeq9fdkhbencmwz9sjqzl1 -O TorrServe_MatriX.127.Client-release.apk
goto :_dlandinstall

:_filmixinst
call :_cdc
set dlappl=Filmix-UHD.apk
set wgetlink=https://www.dropbox.com/scl/fi/z81uwhmszn8gwyyoirqzn/Filmix-UHD.apk?rlkey=wa157oc0evsa0wz3ewpvf5mt5 -O Filmix-UHD.apk
goto :_dlandinstall

:_kinohdinst
call :_cdc
set dlappl=Kino_HD_grey-3.1.1.apk
set wgetlink=https://www.dropbox.com/scl/fi/xh79tc13c1440q3qrp8w3/Kino_HD_grey-3.1.1.apk?rlkey=4sz3qc8lkaqufudeep7bzucxb -O Kino_HD_grey-3.1.1.apk
goto :_dlandinstall


:: VPN клиенты и драйверы
:_ultrasurf
call :_cdc
set dlappl=Ultrasurf.apk
set wgetlink=https://www.dropbox.com/s/zsbsjok9vc3veyr/Ultrasurf.apk
goto :_dlandinstall

:_ultrasurfl
@echo Через секунду откроется ссылка на страничку с помощью по настройке
@start " " "https://ultrasurf.us/"
call :_prevmenu
goto _installmenugen

:_winscribe
call :_cdc
set dlappl=Windscribe.apk
set wgetlink=https://www.dropbox.com/s/hwswnf78p3l63t2/Windscribe.apk
goto :_dlandinstall

:_winscribel
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://rus.windscribe.com/knowledge-base/articles/russian-get-started-on-android"
rem call :_prevmenu
goto _installmenugen

:_openvpnc
call :_cdc
set dlappl=OpenVPNc.apk
set wgetlink=https://www.dropbox.com/s/zu6e68iwn9bydaq/OpenVPNc.apk
goto :_dlandinstall

:_openvpncl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=116398198"
rem call :_prevmenu
goto _installmenugen

:_outline
call :_cdc
set dlappl=outline.apk
set wgetlink=https://www.dropbox.com/s/lpcrtqs93ia0jxb/outline.apk
goto :_dlandinstall

:_outlinel
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://4pda.to/forum/index.php?act=findpost&pid=113691944&anchor=Spoil-113691944-10"
rem @echo А также в шлеме откроется браузер с сайтом, где можно бесплатно взять ключ
@echo A browser will open on the headset with a website where you can get a free key.
@%MYFILES%\adb shell am start -n "com.oculus.vrshell/.MainActivity" -d apk://com.oculus.browser -e uri https://outline.network/ 1>nul 2>nul
::@%MYFILES%\adb shell am start -a android.intent.action.VIEW -d https://outline.network/  1>NUL
call :_prevmenu
goto _installmenugen

:_adguard
call :_cdc
set dlappl=AdguardVPN.apk
set wgetlink=https://www.dropbox.com/s/zkoh60dpe589udt/AdguardVPN.apk
goto :_dlandinstall

:_adguardl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://adguard.com/ru/blog/introducing-adguard-vpn-for-android.html"
rem call :_prevmenu
goto _installmenugen

:_shadowsocks
call :_cdc
@echo ----------------------------------------
rem @echo Скачивание...
@echo Downloading...
set dlappl=Shadowsocks.apk
set wgetlink=https://www.dropbox.com/s/jel793qjlwrptyq/Shadowsocks.apk
rem goto :_dlandinstall
@%MYFILES%\wget -q --show-progress -t 1 -T 5 %wgetlink% 1>nul
@if not %errorlevel%==0 set ftpfile=%dlappl% && call :_GetFTP
@echo ---
rem @echo = Установка...
@echo Installing...
@%MYFILES%\ADB install -r -g --no-streaming "%dlappl%" 1>NUL
call :_erlvl
@del /Q /F %dlappl%
@echo ----------------------------------------
rem @echo Готово. Приложение "Shadowsocks" установлено.
@echo Done. The "Shadowsocks" application has been installed.
call :_prevmenu
goto _installmenugen

:_shadowsocksl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://4pda.to/forum/index.php?showtopic=744431&st=3060"
rem call :_prevmenu
goto _installmenugen

:_psiphon
call :_cdc
set dlappl=Psiphon.apk
set wgetlink=https://www.dropbox.com/s/4mrtq2eccafdlhe/Psiphon.apk
goto :_dlandinstall

:_psiphonl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://psiphon.ca/ru/psiphon-guide.html"
rem call :_prevmenu
goto _installmenugen

:_proton
call :_cdc
set dlappl=ProtonVPN.apk
set wgetlink=https://www.dropbox.com/s/og24czvmkn7p4qs/ProtonVPN.apk
goto :_dlandinstall

:_protonl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://protonvpn.com/ru/free-vpn/android"
rem call :_prevmenu
goto _installmenugen

:_freeplanet
call :_cdc
set dlappl=freevpnplanet.apk
set wgetlink=https://www.dropbox.com/s/do8n9xwvdj4oo47/freevpnplanet.apk
goto :_dlandinstall

:_freeplanetl
rem @echo Через секунду откроется ссылка на страничку с помощью по настройке
rem @start " " "https://support.freevpnplanet.com/hc/ru"
rem call :_prevmenu
goto _installmenugen

:_setdrivers7
@echo ----------------------------------------
rem @echo Скачивание...
@echo Downloading...
@%MYFILES%\wget -q --show-progress --no-hsts https://www.dropbox.com/s/ockvsja022hz2ug/ocdrv7.zip
@%myfiles%\7z.exe x %cd%\ocdrv7.zip -o"%cd%\ocdrv7\" 1>NUL 2>&1
rem @echo Установка... Ждите около минуты...
@echo Installing... Please wait for about a minute...
@start %cd%\ocdrv7\oculus-driver.exe
@ping localhost -n 50 1>nul 2>&1
@rd %cd%\ocdrv7 /Q /S
@del ocdrv7.zip /Q
@echo ----------------------------------------
rem @echo Готово. Драйверы Oculus (Для Win 7) установлены.
@echo Done. Oculus drivers (for Win 7) installed.
call :_prevmenu
goto _installmenugen

:_setdrivers14
@echo ----------------------------------------
rem @echo Скачивание...
@echo Downloading...
::set ftpfile=ocdrv10.zip
::call :_GetFTP
@%MYFILES%\wget -q --show-progress --no-hsts https://www.dropbox.com/scl/fi/jvcg2yr7eyybsds7l5j4f/ocdrv10-17114.zip?rlkey=zvcmeyat8b9s3gmbfqlfdkxio -O ocdrv10-17114.zip
rem https://www.dropbox.com/s/xfn5f6yusa9xb3y/ocdrv10.zip
@%myfiles%\7z.exe x %cd%\ocdrv10-17114.zip -o"%cd%\ocdrv10\" 1>NUL 2>&1
rem @echo Установка... Ждите около минуты...
@echo Installing... Please wait for about a minute...
@start %cd%\ocdrv10\oculus-driver.exe
@ping localhost -n 50 1>nul 2>&1
@rd %cd%\ocdrv10 /Q /S
@del ocdrv10-17114.zip /Q
@echo ----------------------------------------
rem @echo Готово. Драйверы Oculus (Для Win 10) установлены.
@echo Done. Oculus drivers (for Win 10) installed.
call :_prevmenu
goto _installmenugen

:_setdrivers17
@echo ----------------------------------------
rem @echo Скачивание...
@echo Downloading...
::set ftpfile=ocdrv10.zip
::call :_GetFTP
@%MYFILES%\wget -q --show-progress --no-hsts https://www.dropbox.com/scl/fi/8jw003gwsc5zdkt42afgq/ocdrv10-17117.zip?rlkey=01t7nfljpsi5d3mvf463f4tou -O ocdrv10-17117.zip
rem https://www.dropbox.com/s/xfn5f6yusa9xb3y/ocdrv10.zip
@%myfiles%\7z.exe x %cd%\ocdrv10-17117.zip -o"%cd%\ocdrv10\" 1>NUL 2>&1
rem @echo Установка... Ждите около минуты...
@echo Installing... Please wait for about a minute...
@start %cd%\ocdrv10\oculus-driver.exe
@ping localhost -n 50 1>nul 2>&1
@rd %cd%\ocdrv10 /Q /S
@del ocdrv10-17117.zip /Q
@echo ----------------------------------------
rem @echo Готово. Драйверы Oculus (Для Win 10) установлены.
@echo Done. Oculus drivers (for Win 10) installed.
call :_prevmenu
goto _installmenugen


:_dlandinstallnew
@echo -----------------------------------------------------
rem @echo = Скачивание...
@echo Downloading...
@%MYFILES%\wget -q --show-progress -t 1 -T 5 %wgetlink% -O %dlappl% 1>nul
@if not %errorlevel%==0 set ftpfile=%dlappl% && call :_GetFTP
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %dlappl% ^| find "application-label:"') DO set applabel=%%g
@echo ---
rem @echo = Установка...
@echo Installing...
@%MYFILES%\ADB install -r -g -d --no-streaming "%dlappl%"  1>NUL
call :_erlvl
@del /Q /F %dlappl%
@echo --------------------------------------------------------
rem @echo Готово. Приложение "%applabel%" установлено.
@echo Done. Application "%applabel%" installed.
exit /b


:_dlandinstall
@echo ------------------------------------------------------
rem @echo = Скачивание...
@echo Downloading...
@%MYFILES%\wget -q --show-progress -t 1 -T 5 %wgetlink% 1>nul
@if not %errorlevel%==0 set ftpfile=%dlappl% && call :_GetFTP
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging %dlappl% ^| find "application-label:"') DO set applabel=%%g
@echo ---
rem @echo = Установка...
@echo Installing...
@%MYFILES%\ADB install -r -g -d --no-streaming "%dlappl%" 1>NUL
call :_erlvl
@del /Q /F %dlappl%
@echo --------------------------------------------------------
rem @echo Готово. Приложение "%applabel%" установлено.
@echo Done. Application "%applabel%" installed.
call :_prevmenu
goto _installmenugen
rem exit /b

:_qctprocedure

@echo off

:_SendToMenu
set sendtolnk=
set qtarget=
set sendtofoldercmdfile=
set sendtofolder=
set sendtofoldercmdfolder=
@echo off
cls
call :_hatqct
call :_hatmenuqct
@echo.
goto _eng20
@echo  Установить ярлыки в контекстное меню Отправить:
@echo.
@echo    A.  Файлы на Quest в OBB
@echo    B.  Файлы на Quest в Movies
@echo    C.  Файлы на Quest в Download
@echo    D.  Файлы на Quest в корень Sdcard
@echo.
@echo    G.  Установка APK+OBB
@echo    I.  Установка через INSTALL.TXT
@echo.
@echo    V.  Установить все ярлыки разом
@echo.
@echo  Дополнительные действия (ярлыки не создаются):
@echo.
@echo    H.  Описание программы (help)
@echo    X.  Удалить установленные ярлыки и файлы
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
:_eng20
@echo Install shortcuts in the context menu Send To:

@echo    A. Files to Quest in OBB
@echo    B. Files to Quest in Movies
@echo    C. Files to Quest in Download
@echo    D. Files to Quest in the root Sdcard
@echo.
@echo    G. Install APK+OBB
@echo    I. Install via INSTALL.TXT
@echo.
@echo    V. Install all shortcuts together
@echo.
@echo  Additional actions (no shortcuts created):
@echo.
@echo    H. Program description (help)
@echo    X. Remove installed shortcuts and files
@echo.
@echo.
@echo IMPORTANT:
@echo.
@echo.
@echo    During installation, necessary files and command scripts
@echo    will be placed in the directory C:\Temp\SendToHeadset.
@echo.
@echo    Shortcuts are created in the directory \AppData\Microsoft\Windows\SendTo
@echo    and will be available via right-click in the Send To context menu.
@echo.
@echo    When selecting "Remove installed shortcuts and files"
@echo    all previously installed items will be completely removed:
@echo    programs, shortcuts, and the entire SendToHeadset directory.
@echo.
@echo    Application installation and copying will occur immediately after choosing
@echo    the context menu option, without additional confirmation.
@echo.
@echo.
@set "choice="
rem @Set /p choice="Выберите пункт меню и нажмите Enter (H - для помощи): "
@Set /p choice="Select a menu number and press Enter (H - help) : "
@echo.
if not defined choice goto _SendToMenu
if /i "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="a" (call :_SendToOBB && call :_InstallLnkMessage)
if /i "%choice%"=="b" (call :_SendToMovies && call :_InstallLnkMessage)
if /i "%choice%"=="c" (call :_SendToDownloads && call :_InstallLnkMessage)
if /i "%choice%"=="d" (call :_SendToSDCARD && call :_InstallLnkMessage)
if /i "%choice%"=="g" (call :_SendToInstallAPK && call :_InstallLnkMessage)
if /i "%choice%"=="i" (call :_SendToInstallTxt && call :_InstallLnkMessage)
if /i "%choice%"=="h" (call :_DescriptionContextTool)
rem if /i "%choice%"=="v" (echo  = Установка ярлыков.. && call :_SendToDownloads && call :_SendToMovies && call :_SendToOBB && call :_SendToSDCARD && call :_SendToInstallAPK && call :_SendToInstallTxt && call :_InstallLnkMessageAll)
if /i "%choice%"=="v" (@echo = Installing shortcuts... && call :_SendToDownloads && call :_SendToMovies && call :_SendToOBB && call :_SendToSDCARD && call :_SendToInstallAPK && call :_SendToInstallTxt && call :_InstallLnkMessageAll)
if /i "%choice%"=="x" (GOTO _DeleteLnksFolder)
@cls
goto _SendToMenu

::-----------------

:_SendToSDCARD
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem set sendtolnk=Файлы на Quest в корень Sdcard
rem set copyname=корень SDCARD
set sendtolnk=Files to Quest in the root of Sdcard
set copyname=root SDCARD
set qtarget=/sdcard/
set sendtofoldercmdfile=sendsd.cmd
set ico=ocwt.ico
call :_CreateCmdForLink
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b


:_SendToOBB
call :_SetVariableContext
call :_CopyOnlyADBFiles
rem set sendtolnk=Файлы на Quest в OBB
set sendtolnk=Files to Quest in OBB
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
rem set sendtolnk=Файлы на Quest в Movies
set sendtolnk=Files to Quest in Movies
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
rem set sendtolnk=Файлы на Quest в Download
set sendtolnk=Files to Quest in Download
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
call :_CopyAllFiles
rem set sendtolnk=Установка APK+OBB
set sendtolnk=APK+OBB Installation
set sendtofoldercmdfile=qidcontext%cod%.cmd
set ico=ocgr.ico
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b

:_SendToInstallTxt
call :_SetVariableContext
call :_CopyAllFiles
rem set sendtolnk=Установка через INSTALL.TXT
set sendtolnk=Installation via INSTALL.TXT
set sendtofoldercmdfile=qidcontext%cod%.cmd
set ico=ocgr.ico
call :_CreateLnkFromCmd
::goto :_InstallLnkMessage
exit /b


:_DeleteLnksFolder
::call :_SetVariableContext
@taskkill /im adb.exe /f 1>nul 2>nul
set sendtofolder=%appdata%\Microsoft\Windows\SendTo
set sendtofoldercmdfolder=C:\Temp\SendToHeadset
@ping localhost -n 2 1>nul 2>nul
rd %sendtofoldercmdfolder% /S /Q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в Movies*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в OBB*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в Download*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Файлы на Quest в корень Sdcard*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Установка APK+OBB*" /q 1>nul 2>nul
rem del "%appdata%\Microsoft\Windows\SendTo\Установка через INSTALL.TXT*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in Movies*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in OBB*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in Download*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Files to Quest in the root of Sdcard*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\APK+OBB Installation*" /q 1>nul 2>nul
del "%appdata%\Microsoft\Windows\SendTo\Installation via INSTALL.TXT*" /q 1>nul 2>nul
endlocal
@echo  =====================================================
rem @echo  = Все установленные ранее ярлыки и программы удалены
rem @echo  -----
rem @echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
@echo  = All previously installed shortcuts and programs have been removed
@echo  -----
@echo ^>^>^> Press any key to return to the menu ^<^<^<
@pause >nul
@echo.
goto :_SendToMenu

:_CreateCmdForLink
call :_SetVariableContext
@del %sendtofoldercmdfolder%\%sendtofoldercmdfile% /q 1>nul 2>nul
@echo. %codepage%>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @Echo Off>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo ADB запускается....>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ADB is starting...>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @%sendtofoldercmdfolder%\adb devices 1^>nul 2^>nul>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @FOR ^/F "skip=1 tokens=2" %%%%G IN ^('%sendtofoldercmdfolder%\adb devices ^^^| find "device"'^) DO set adbdevices=%%%%G>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @if [%%adbdevices%%]==[] goto _NF>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @cls>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @goto :_sendcopy>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_NF>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @cls>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo     +++++ Шлем не найден +++++>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo     +++++ Headset not found +++++>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo  Проверьте кабельное соединение и правильность установки драйверов.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo  Затем перезапустите эту программу снова.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo  Check the cable connection and the correctness of driver installation.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo  Then restart this program again.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @goto :_sendexit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_sendcopy>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @setlocal enableextensions enabledelayedexpansion>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @for ^/f "tokens=*" %%%%e in ^("%ap%"^) do ^( >> %sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @set file=%%%%e>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ------------->>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo = Копируем в %copyname%..>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo = Copying to %copyname%..>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @%sendtofoldercmdfolder%\adb.exe push !file! -p "%qtarget%">>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo ^)>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ^====================================================>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo ^= Копирование завершено>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ^= Copying completed>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo goto :_exittimeout>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_sendexit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo ^^^>^^^>^^^> Нажмите любую кнопку для выхода ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ^^^>^^^>^^^> Press any key to exit ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @pause ^>nul>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @exit>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo :_exittimeout>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo.>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo ^^^>^^^>^^^> Нажмите любую кнопку для выхода из программы ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
rem @echo @echo               или подождите пять секунд>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo ^^^>^^^>^^^> Press any key to exit the program ^^^<^^^<^^^<>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @echo               or wait for five seconds>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
@echo @timeout ^5>>%sendtofoldercmdfolder%\%sendtofoldercmdfile%
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

@xcopy %myfiles%\qidcontext%cod%.cmd %sendtofoldercmdfolder% /y 1>nul 2>nul
rem @xcopy %~dp0qidcontext%cod%.cmd %sendtofoldercmdfolder% /y 1>nul 2>nul

exit /b

:_InstallLnkMessage
@echo  ==================================================
rem @echo  = Установлен ярлык "%sendtolnk%"
@echo  = Shortcut "%sendtolnk%" installed
@echo  -----

:::_exitout
::@echo.
::@echo ^>^>^> Нажмите любую кнопку для выхода из программы ^<^<^<
::@pause >nul
::@exit

:_InstallLnkMessageAll
@echo  ==================================================
rem @echo  = Установлены все ярлыки.
rem @echo  -----
rem @echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
@echo  = All shortcuts installed.
@echo  -----
@echo ^>^>^> Press any key to return to the menu ^<^<^<
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
exit /b

:_DescriptionContextTool
cls
call :_hatqct
@echo.
goto _eng21
@echo   ОПИСАНИЕ ПРОГРАММЫ:
@echo.
@echo    Программа предназначена для установки ярлыков в контекстное меню.
@echo    После работы программы в меню "Отправить" станут доступны следующие опции:
@echo.
@echo      Файлы на Quest в OBB                    = отправка файлов на шлем в каталог OBB
@echo      Файлы на Quest в Movies                 = отправка файлов на шлем в каталог Movies
@echo      Файлы на Quest в Download               = отправка файлов на шлем в каталог Download
@echo      Файлы на Quest в корень Sdcard          = отправка файлов на шлем в корневой каталог
@echo      Установка APK+OBB                       = установка приложений на шлем. 
@echo      Установка через INSTALL.TXT   [EXP]     = установка приложений через сценарий install.txt
@echo.
@echo    Также в программе доступны дополнительные действия:
@echo.
@echo      Установить все ярлыки разом            = установка сразу всех шести ярлыков 
@echo      Удалить установленные ярлыки и файлы   = полное удаление всего установленного ранее
@echo.
@echo    После того, как ярлыки созданы, программа больше не требуется, ее можно отложить
@echo    в сторонку до тех пор, прока не появится необходимость добавить или удалить ярлыки.
@echo.
@echo.
@echo   ИСПОЛЬЗОВАНИЕ ФУНКЦИЙ ПОСЛЕ УСТАНОВКИ ЯРЛЫКОВ:
@echo.
@echo      Отмечаем мышью один или несколько файлов, например, фильмов. Правой кнопкой мыши
@echo      кликаем на отмеченное и в контекстном меню "Отправить" выбираем нужный пункт,
@echo      например "Файлы на Quest в Movies".
@echo      Файлы будут скопированы на шлем в соответствующий каталог.
@echo      При необходимиости можно отмечать^/копировать и каталоги тоже. 
@echo. 
@echo      Для установки приложений кликаем правой кнопкой мыши на APK файл или каталог с игрой
@echo      и в меню "Отправить" выбираем "Установка APK+OBB". Игра будет установлены на шлем. 
@echo      Если с игрой идет каталог obb, он автоматически скопируется куда нужно.
@echo      Если в каталоге несколько игр, они будут установлены поочередно.
@echo.
@echo      Иногда в каталоге с игрой лежит файл install.txt. Как правило, в нем содержатся команды
@echo      для индивидуальной или специальной установки^/переустановки некоторых игр. Например,
@echo      у игр Doom 3 или Beat Saber нет каталогов с obb, вместо них множество отдельных файлов.
@echo      У Beat Saber, к тому же, часто в комплекте идет BMBF и установка должна производиться
@echo.     в определенном порядке. Именно этот сценарий установки и находится в файле install.txt
@echo      Установка с его помощью производится так же, как и APK, но через отдельный ярлык.
@echo.
@echo.
@echo.
@echo ^>^>^> Нажмите любую кнопку для возврата в меню ^<^<^<
:_eng21
@echo   PROGRAM DESCRIPTION:
@echo.
@echo    The program is designed to install shortcuts in the context menu.
@echo    After running the program, the following options will become available in the "Send to" menu:
@echo.
@echo      Files to Quest in OBB                    = send files to the headset to the OBB directory
@echo      Files to Quest in Movies                 = send files to the headset to the Movies directory
@echo      Files to Quest in Download               = send files to the headset to the Download directory
@echo      Files to Quest in the root of Sdcard     = send files to the headset to the root directory
@echo      APK+OBB Installation                     = installation of applications on the headset. 
@echo      Installation via INSTALL.TXT   [EXP]     = installation of applications via the install.txt script
@echo.
@echo    Additional actions are also available in the program:
@echo.
@echo      Install all shortcuts at once            = installing all six shortcuts at once
@echo      Remove installed shortcuts and files    = complete removal of everything previously installed
@echo.
@echo    Once the shortcuts are created, the program is no longer needed and can be set aside
@echo    until there is a need to add or remove shortcuts.
@echo.
@echo.
@echo   USING FUNCTIONS AFTER INSTALLING SHORTCUTS:
@echo.
@echo      Select one or more files with the mouse, for example, movies. Right-click
@echo      on the selected items, and in the context menu "Send to," choose the desired option,
@echo      for example, "Files to Quest in Movies."
@echo      The files will be copied to the headset in the corresponding directory.
@echo      If necessary, directories can also be selected/copied.
@echo. 
@echo      To install applications, right-click on the APK file or the game directory
@echo      and in the "Send to" menu, select "APK+OBB Installation." The game will be installed on the headset. 
@echo      If the game comes with an obb directory, it will be automatically copied where needed.
@echo      If there are multiple games in the directory, they will be installed one by one.
@echo.
@echo      Sometimes there is an install.txt file in the game directory. Usually, it contains commands
@echo      for individual or special installation/reinstallation of some games. For example,
@echo      games like Doom 3 or Beat Saber don't have obb directories, instead, they have many individual files.
@echo      Beat Saber often comes with BMBF, and the installation must be done
@echo      in a specific order. This installation scenario is in the install.txt file
@echo      Installation using it is the same as APK but through a separate shortcut.
@echo.
@echo.
@echo.
@echo ^>^>^> Press any key to return to the menu ^<^<^<
@pause >nul
@echo.
goto :_SendToMenu

:_hatqct
@cls
@echo ==================================================================================================
@echo          Quest Context Tool - created by Varset - v.1.1 - 13.08.23%hatcod%
@echo ==================================================================================================
@exit /b

:_hatmenuqct
@echo off
@echo.
@echo.
rem @echo    0.  Выход из программы
rem @echo    M.  Выход в Главное меню
@echo    0.  Exit the program
@echo    M.  Return to the Main Menu
@exit /b

:_oculuslink
call :_hat
call :_hatmenu
@echo.
rem @echo    A.  Стартовать Oculus Link
rem @echo    B.  Отключить Oculus Link
rem @echo    C.  Включить AirLink
rem @echo    D.  Отключить AirLink
rem @echo    E.  Устранить проблему подключения Airlink (удалить файл cert_v55.pem)
rem @echo    F.  Рассчитать значения динамического битрейта
@echo    A.  Start Oculus Link
@echo    B.  Disconnect Oculus Link
@echo    C.  Enable AirLink
@echo    D.  Disable AirLink
@echo    E.  Fix AirLink connection issue (remove cert_v55.pem file)
@echo    F.  Calculate dynmaic birate
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
if /i "%choice%"=="e" (GOTO _alinkdel)
if /i "%choice%"=="f" (GOTO _offsetcalc)

@cls
goto _oculuslink

:_linkon
@%MYFILES%\adb shell am start -S com.oculus.xrstreamingclient/.MainActivity 1>nul 2>nul
call :_erlvl
@echo ========================================
rem @echo  Oculus Link запущен
@echo  Oculus Link has started
@goto _returnmenu

:_linkoff
@%MYFILES%\adb shell am force-stop com.oculus.xrstreamingclient 1>nul 2>nul
call :_erlvl
@echo ========================================
rem @echo  Oculus Link отключен
@echo  Oculus Link has been disconnected
@goto _returnmenu

:_alinkon
@%MYFILES%\adb shell am broadcast -a "com.oculus.systemux.action.TOGGLE_AIRLINK" --ez enable_airlink 1 1>nul 2>nul
call :_erlvl
@echo ========================================
rem @echo  Oculus AirLink запущен
@echo  Oculus AirLink has started
@goto _returnmenu

:_alinkoff
@%MYFILES%\adb shell am broadcast -a "com.oculus.systemux.action.TOGGLE_AIRLINK" --ez enable_airlink 0 1>nul 2>nul
call :_erlvl
@echo ======================================== 
rem @echo  Oculus AirLink отключен
@echo  Oculus AirLink has been disconnected
@goto _returnmenu

:_alinkdel
call :_cdc
@del /F /Q C:\Users\%username%\AppData\Local\Oculus\Airlink\cert*.pem  2>&1 1> nul | find /V "" 1> nul 2>&1
if %errorlevel% == 0 @echo = Файл cert*.pem не найден && @goto _returnmenu
@net stop OVRservice && @net start OVRservice
@echo ======================================== 
rem @echo       Файл cert*.pem удален
rem @echo Попробуйте снова подключиться по Airlink
@echo       The cert*.pem file has been removed
@echo Try connecting again via AirLink
@goto _returnmenu

:_offsetcalc
@echo ======================================== 
rem @echo  Процедура поможет рассчитать, какие значение следует выбирать
rem @echo  при установке динамического битрейта
@echo This procedure will help calculate which values should be selected
@echo when setting up dynamic bitrate.
@echo  ---
rem @echo  Для возврата в меню введите 0
@echo  Enter 0 for return to menu
@echo.
@echo.
@echo.
@echo.
rem @Set /p reqminbitrate="Введите желаемый минимальный битрейт: "
@Set /p reqminbitrate="Enter the desired minimal bitrate: "
if /i "%reqminbitrate%"=="0" (exit)
@set /a offsetnumber=%reqminbitrate%-10
@echo.
rem @Set /p reqmaxbitrate="Введите желаемый максимальный битрейт: "
@Set /p reqmaxbitrate="Enter the desired maximal bitrate: "
if /i "%reqmaxbitrate%"=="0" (exit)
@set /a maxbitratenumber=%reqmaxbitrate%-%offsetnumber%
@echo.
@echo ------
rem @echo Впишите следующие значения в таблицу ODT:
@echo  Enter the following values into the ODT table:
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


:_guardian
call :_hat
call :_hatmenu
@echo.
rem @echo    D.  Приостановить Защитную систему
rem @echo    E.  Возобновить Защитную систему
@echo    D.  Suspend Guardian
@echo    E.  Resume Guardian
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
@%MYFILES%\adb shell setprop debug.oculus.guardian_pause 0 1>nul 2>nul
call :_erlvl
@echo ======================================== 
rem @echo  Защитная зона приостановлена
@echo  Guardian suspended
call :_prevmenu
@goto _shellmenu

:_guardon
@%MYFILES%\adb shell setprop debug.oculus.guardian_pause 1 1>nul 2>nul
call :_erlvl
@echo ======================================== 
rem @echo  Защитная зона возобновлена
@echo  Guardian resumed
call :_prevmenu
@goto _shellmenu

:_proxsensor
call :_hat
call :_hatmenu
@echo.
goto _eng21
@echo    D.  Отключить датчик приближения
@echo    E.  Включить датчик приближения
@echo.
@echo.
@echo  ВНИМАНИЕ:
@echo.
@echo       После отключения датчика экран не будет гаснуть автоматически!
@echo       Это чревато ускоренным разрядом аккумулятора.
@echo       Не забывайте включать датчик.
:_eng21
@echo    D.  Disable Proximity Sensor
@echo    E.  Enable Proximity Sensor
@echo.
@echo.
@echo  WARNING:
@echo.
@echo       After disabling the sensor, the screen will not automatically turn off!
@echo       This can lead to accelerated battery discharge.
@echo       Don't forget to enable the sensor.
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
rem @echo  Датчик приближения отключен
@echo  Proximity sensor disabled
call :_prevmenu
@goto _shellmenu

:_proxon
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
call :_erlvl
@echo ======================================== 
@If %ERRORLEVEL% EQU 1 GOTO _errlevel
rem @echo  Датчик приближения включен
@echo  Proximity sensor enabled
call :_prevmenu
@goto _shellmenu

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

:_streamingmenu
@echo off
setlocal enableextensions enabledelayedexpansion
cls
call :_settime
call :_hat
@echo.
goto _eng22
@echo                               === МОДУЛЬ ТРАНСЛЯЦИИ ===
call :_hatmenu
@echo.
@echo.
@echo    A.  "Быстрая" трансляция: формат 1600 х 900
@echo         [ Данные трансляции: FPS=30, Bitrate=10, звук на всех устройствах ]
@echo         [ в этом режиме отключается датчик приближения! ]
@echo.
@echo    B.  "Квадратная" трансляция: кроп картинки с одного глаза без черных углов
@echo         [ Данные трансляции: FPS=60, Bitrate=30 ] 
@echo         [ подходит для создания демороликов     ]
@echo.
@echo    C.  "Прямоугольная" трансляция: формат 1600 х 900
@echo         [ Данные трансляции: FPS=60, Bitrate=30 ]
@echo         [ подходит для демонстрационных целей ]
@echo.
@echo    D.  "Стереотрансляция": ничего не кропается, картинка с обоих глаз 
@echo         [ Данные трансляции: FPS=60, Bitrate=20 ]
@echo         [ подходит для создания 3D роликов      ]
@echo.
@echo    E.  "Ручная" трансляция: выбор и установка параметров трансляции вручную.  [EXP]
@echo         [для тех, кто привык все контролировать сам]
@echo.
@echo.
@echo   ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo   После старта трансляции картинка может пропасть на 3-4 секунды,
@echo   а шлем скажет "блым". Это связано с всплывающим в шлеме ссобщением,
@echo   например, о том, что контроллеры не найдены. Увы, но вот так.
@echo. 
@echo   При необходимости можно отключить датчик приближения, пункты C -^> F в Главном меню.
@echo   Для режима ручной трансляции это можно сделать в процессе выбора параметров.
@echo.
@echo   Для запуска трансляции с сохранением в файл
@echo   введите сдвоенный номер пункта, например AA, bb и т.д.
@echo   В противном случае трансляция записана не будет.
@echo.
@echo   Когда решите прекратить трансляцию, просто закройте окно с картинкой
@echo   и нажмите любую кнопку в основном окне, это вернет вас в Главное меню,
@echo   а файл с записью (если она велась) будет сохранен в текущем каталоге.
:_eng22
@echo                               === TRANSLATION MODULE ===
call :_hatmenu
@echo.
@echo.
@echo    A.  "Fast" streaming: format 1600 x 900
@echo         [ Stream data: FPS=30, Bitrate=10, sound on all devices ]
@echo         [ in this mode the proximity sensor is disabled! ]
@echo.
@echo    B.  "Square" streaming: crop image from one eye without black corners
@echo         [ Stream data: FPS=60, Bitrate=30 ] 
@echo         [ suitable for creating demos ]
@echo.
@echo    C.  "Rectangular" streaming: format 1600 x 900
@echo         [ Stream data: FPS=60, Bitrate=30 ]
@echo         [ suitable for demonstration purposes ]
@echo.
@echo    D.  "Stereo streaming": nothing is cropped, image from both eyes 
@echo         [ Stream data: FPS=60, Bitrate=20 ]
@echo         [ suitable for creating 3D videos ]
@echo.
@echo    E.  "Manual" streaming: selection and setting of streaming parameters manually.  [EXP]
@echo         [ for those who prefer full control ]
@echo.
@echo.
@echo   PLEASE NOTE:
@echo.
@echo   After starting the streaming, the image may disappear for 3-4 seconds,
@echo   and the headset will say "blym". This is due to a popup message in the headset,
@echo   for example, about controllers not being found. Unfortunately, that's how it is.
@echo. 
@echo   If necessary, you can disable the proximity sensor, points C -^> F in the Main menu.
@echo   For manual streaming mode, this can be done during parameter selection.
@echo.
@echo   To start streaming with recording to a file
@echo   enter the double number of the item, for example, AA, bb, etc.
@echo   Otherwise, the streaming will not be recorded.
@echo.
@echo   When you decide to stop streaming, simply close the window with the picture
@echo   and press any key in the main window, this will return you to the Main menu,
@echo   and the recording file (if any) will be saved in the current directory.
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
rem if /i "%choice%"=="1" (set profnumb=1 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="2" (set profnumb=2 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="3" (set profnumb=3 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="4" (set profnumb=4 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="5" (set profnumb=5 GOTO _FastLoadIntMultiProfile)
rem if /i "%choice%"=="6" (set profnumb=6 GOTO _FastLoadIntMultiProfile)

cls
goto _streamingmenu

:_streamfast
call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
set cropset=1600:900:2017:510
set bitrateset=10M
set setfps=30
set recfile=
call :_CheckWiFiMode
set acodecset=--audio-source=mic
goto :_createvbs

:_streamfastr
call :_cdc
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
set cropset=1600:900:2017:510
set bitrateset=10M
set setfps=30
call :_RecordEnableSettings
call :_CheckWiFiMode
set acodecset=--audio-source=mic
goto :_createvbs

:_streamsquare
call :_cdc
set cropset=1584:1440:1950:250
set bitrateset=30M
set setfps=60
set recfile=
call :_CheckWiFiMode
goto :_createvbs

:_streamsquarer
call :_cdc
set cropset=1584:1440:1950:250
set bitrateset=30M
set setfps=60
call :_RecordEnableSettings
call :_CheckWiFiMode
goto :_createvbs

:_streamcircle
call :_cdc
set cropset=1600:900:2017:510
set bitrateset=30M
set setfps=60
set recfile=
call :_CheckWiFiMode
goto :_createvbs

:_streamcircler
call :_cdc
set cropset=1600:900:2017:510
set bitrateset=30M
set setfps=60
call :_RecordEnableSettings
call :_CheckWiFiMode
goto :_createvbs

:_streamstereo
call :_cdc
set cropset=3664:1920:0:0
set bitrateset=20M
set setfps=60
set recfile=
call :_CheckWiFiMode
goto :_createvbs

:_streamstereor
call :_cdc
set cropset=3664:1920:0:0
set bitrateset=20M
set setfps=60
call :_RecordEnableSettings
goto :_createvbs

:_ManualTransSettings
@echo off
cls
set aa=
set bb=
set cc=
set dd=
call :_hat
call :_hatmenu
@echo.
rem @echo    L.  Загрузить настройки из файла профиля
rem @echo    I.  Загрузить настройки из интегрированных профилей
@echo    L.  Load settings from profile file
@echo    I.  Load settings from integrated profiles
rem @echo    H.  Информация о кодеках
@echo.
@echo.
@echo.
goto _eng23
@echo   1.Битрейт  2.FPS   3.Запись сессии   4.Обрезка кадра    5.Вывод звука          
@echo  ------------------------------------------------------------------------------------------------
@echo   1. 3      1. 24    1. С записью     1. Обрезка углов    1. Звук на ПК        [записывается]
@echo   2. 5      2. 30    2. Без записи    2. Без обрезки      2. Звук на шлеме     [не записывается] 
@echo   3. 10     3. 60                     3. Режим стерео     3. ПК,микрофон,шлем  [записывается]
@echo   4. 20     4. 90                     4. 1600x900	
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
rem @echo  	8. Аудиокодек		: aac  c2.android.aac.encoder		(Пункт 2)
@echo.
@echo    число будет таким: 3221311
@echo.
@echo   Для упрощения выбора просто набирайте по одной цифре каждого пункта,
@echo   а когда наберете все шесть или семь цифр, жмите Enter.
:_eng23
@echo   1. Bitrate     2. FPS     3. Session recording    4. Frame cropping    5. Sound output          
@echo  ------------------------------------------------------------------------------------------------
@echo   1. 3          1. 24      1. With recording       1. Corner cropping   1. Sound on PC         [recorded]
@echo   2. 5          2. 30      2. Without recording    2. No cropping       2. Sound on headset     [not recorded] 
@echo   3. 10         3. 60                            3. Stereo mode        3. PC, microphone, headset  [recorded]
@echo   4. 20         4. 90                            4. 1600x900	
@echo   5. 50
@echo.
@echo.
@echo            6. Proximity sensor                     7. Video codec                                   
@echo  ------------------------------------------------------------------------------------------------
@echo          1. Disable                               1. h264 OMX.qcom.video.encoder.avc             
@echo          2. Do not disable                        2. h265 OMX.qcom.video.encoder.hevc         
@echo                                                     3. h265 OMX.qcom.video.encoder.hevc.cq	  
@echo.
@echo   Enter a six- or seven-digit number consisting of selected parameter options
@echo   You can enter only six digits, then by default, this video codec will be used:
@echo    - h264 OMX.qcom.video.encoder.avc
@echo  ------------------------------------------------------------------------------------------------
@echo.
@echo    For example, for values 
@echo.
@echo  	1. Bitrate		: 10					(Item 3)
@echo  	2. FPS			: 30					(Item 2)
@echo  	3. Session recording	: Without recording			(Item 2)
@echo  	4. Frame cropping 	: Corner cropping			(Item 1)
@echo  	5. Sound output	 	: PC, microphone, headset		(Item 3)
@echo  	6. Sensor		: Disable				(Item 1)
@echo  	7. Video codec		: h264 OMX.qcom.video.encoder.avc	(Item 1)
rem @echo  	8. Audio codec		: aac  c2.android.aac.encoder		(Item 2)
@echo.
@echo    the number will be: 3221311
@echo.
@echo   To simplify the selection, just type one digit of each item,
@echo   and when you have typed all six or seven digits, press Enter.

@echo.
rem @Set profdatanew=3221311
rem @Set /p profdatanew="Введите число или пункт меню и нажмите Enter: "
@Set /p profdatanew="Enter the number or menu item and press Enter: "
if not defined profdatanew goto _ManualTransSettings
if "%profdatanew%"=="0" (exit)
if /i "%profdatanew%"=="m" (GOTO _streamingmenu)
if /i "%profdatanew%"=="l" (call :_loadMultiprofile)
if /i "%profdatanew%"=="i" (call :_LoadIntMultiProfile)
rem if /i "%profdatanew%"=="h" (goto _CodecsHelp)

:_Choiced
cls
call :_hat
@echo.
call :_hatmenu
@echo.
@echo.
rem @echo      C.  Трансляция по кабелю
rem @echo      R.  Повторить выбор настроек или загрузить из файла профилей
rem @echo      S.  Сохранить настройки в файл профилей
rem @echo      W.  Сохранить в файл строку запуска  scrcpy с выбранными параметрами
rem @echo  Enter.  Начать трансляцию
@echo      C.  Cable transmission
@echo      R.  Repeat settings selection or load from profile file
@echo      S.  Save settings to profile file
@echo      W.  Save the scrcpy command line with selected parameters to a file
@echo  Enter.  Start transmission
@echo.
@echo.
@echo.
call :_ParsingProfDataNew
@echo.
goto _eng24
@echo  Выбраны следующие настройки:
@echo.
@echo.  Битрейт	: !bitrateset!
@echo.  FPS		: !setfps!
@echo.  Запись сессии	: !recmsg! 
@echo.  Обрезка кадра	: !cropmsg!
@echo.  Вывод звука	: !amsg!
@echo.  Датчик	: !proxmsg!
@echo.  Видеокодек	: !vcodecmsg!
rem @echo.  Аудиокодек	: !acodecmsg!
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
:_eng24
@echo  The following settings are selected:
@echo.
@echo.  Bitrate	: !bitrateset!
@echo.  FPS		: !setfps!
@echo.  Session recording	: !recmsg! 
@echo.  Frame cropping	: !cropmsg!
@echo.  Sound output	: !amsg!
@echo.  Sensor	: !proxmsg!
@echo.  Video codec	: !vcodecmsg!
rem @echo.  Audio codec	: !acodecmsg!
@echo  ---------------------------------------------
@echo   Profile	: !profname!
@echo.
@echo.
@echo.
@echo   IMPORTANT:
@echo.
@echo   By default (pressing Enter), wireless transmission will be enabled,
@echo   but the cable must be connected before starting.
@echo   And only after the start of transmission, you must disconnect the USB cable.
@echo.
@echo   If cable transmission is required, do not disconnect it,
@echo   enter C and press Enter.
@echo.
@echo.
@echo.
@Set choice2=
@Set choice2=e
rem @Set /p choice2="Для начала трансляции нажмите Enter: "
@Set /p choice2="Press Enter to start transmission: "
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
@echo ---------------------------------------------------------
rem @echo +++ Значение "%errorout%" вне диапазона пунктов меню ++++
rem @echo.
rem @echo             Выберите другое значение
rem @echo ------------------------------------------------------
rem @echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата к настройкам ^<^<^<
@echo +++ Value "%errorout%" is out of menu range ++++
@echo.
@echo             Choose another value
@echo ------------------------------------------------------
@echo.
@echo ^>^>^> Press anything to return to settings ^<^<^<
@pause 1>nul 2>nul
goto _ManualTransSettings

:_SaveProfile

@echo %profnamenew% >TransProfile.txt
@echo.
@echo ---------------------------------------------
rem @echo  +++ Настройки сохранены в файл профиля +++
rem @echo.
rem @echo  При желании его можно редактироовать вручную.
rem @echo.
rem @echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo  +++ Settings saved to profile file +++
@echo.
@echo  If desired, it can be edited manually.
@echo.
@echo.
@echo ^>^>^> Press anything to return ^<^<^<
@pause 1>nul 2>nul
goto _Choiced


:_BeginTranslation
call :_cdc
call :_CheckWiFiMode
call :_CheckADBDevices

if /i %choice2%==c (call :_ReconnectToCable && call :_CheckADBDevices && call :_SetCableSettings)
if /i %choice2%==w goto _createscrcpystring


:_ProximitySettings
if %Proximity%==0 (@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul)
rem goto _createvbs

:_createvbs
@echo strCommand = "cmd /c %MYFILES%\scrcpy.exe %connectivity% %audiomute% %acodecset% %vcodecset% --crop=%cropset% --max-size=3664 --video-bit-rate=%bitrateset% --display-buffer=50 --max-fps=%setfps% --stay-awake%recformat% --power-off-on-close%recfile%">>startstream.vbs
@echo For Each Arg In WScript.Arguments >>startstream.vbs
@echo strCommand = strCommand ^& " """ ^& replace^(Arg, """", """""""""") ^& """" >> startstream.vbs
@echo Next >>startstream.vbs
@echo CreateObject("Wscript.Shell").Run strCommand, 0, false >>startstream.vbs
::@cls
start startstream.vbs
@ping localhost -n 4 1>nul 2>nul
@del startstream.vbs /q 2>nul
@echo  ------------------------------------------------------------------
@echo.
@echo.
@echo.   %connectmsg%
@echo.
@echo.
rem @echo   После старта трансляции картинка может пропасть на 3-4 секунды,
rem @echo   а шлем скажет "блым". Это связано с всплывающим в шлеме ссобщением,
rem @echo   например, о том, что контроллеры не найдены. Увы, но вот так.
rem @echo.
rem @echo =========================================================================
rem @echo ^>^>^> Нажмите любую кнопку для возврата в Главное меню ^<^<^<
@echo   After starting the transmission, the picture may disappear for 3-4 seconds,
@echo   and the headset will say "bleem". This is due to the message that pops up in the headset,
@echo   for example, that the controllers are not found. Alas, but that's how it is.
@echo.
@echo =========================================================================
@echo ^>^>^> Press any key to return to the Main menu ^<^<^<
@pause >nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@cls
goto _beginn

:_createscrcpystring
@echo scrcpy.exe %connectivity% %audiomute% %acodecset% %vcodecset% --crop=%cropset% --max-size=3664 --video-bit-rate=%bitrateset% --display-buffer=50 --max-fps=%setfps% --stay-awake%recformat% --power-off-on-close%recfile%>scrcpyLaunchString_%dt%_%profdata%.txt
@echo -------------------------------------------------------------------------------------------
rem @echo  +++ Строка запуска сохранена в файл scrcpyLaunchString_%dt%_%profdata%.txt +++
@echo  +++ The launch string is saved to the file scrcpyLaunchString_%dt%_%profdata%.txt +++
@echo.
rem @echo  При желании его можно редактироовать вручную.
@echo.
@echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo ^>^>^> Press anything to return ^<^<^<
@pause 1>nul 2>nul
goto _Choiced

:_LoadMultiProfile
cls
@echo.
@echo.
rem @echo.
rem @echo   0. Выход из программы
rem @echo   M. Отмена выбора и возврат в предыдущее меню
@echo   0. Exit the program
@echo   M. Cancel selection and return to the previous menu
@echo.
if exist TransMultiProfiles.txt (call :_ProfilesCollection) else (goto _NoFileProfiles)
@Set profnumb=
@echo.
rem @Set /p profnumb="Выберите номер желаемого профиля и нажмите Enter для загрузки: "
@Set /p profnumb="Enter the number of the desired profile and press Enter to load: "
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
rem @echo.
rem @echo   0. Выход из программы
rem @echo   M. Отмена выбора и возврат в предыдущее меню
@echo   0. Exit the program
@echo   M. Cancel selection and return to the previous menu
@echo.
rem if exist TransMultiProfiles.txt (call :_ProfilesCollection) else (goto _NoFileProfiles)
call :_IntegratedProfiles
call :_IntProfilesCollection
@Set profnumb=
@echo.
rem @Set /p profnumb="Выберите номер желаемого профиля и нажмите Enter для загрузки: "
@Set /p profnumb="Enter the number of the desired profile and press Enter to load: "

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
rem @echo 1:Минимальный:1121121>>intprofiles.txt
rem @echo 2:Легкий:2221312>>intprofiles.txt
rem @echo 3:Сбалансированный:3314113 >>intprofiles.txt
rem @echo 4:Демонстрационный:3224321>>intprofiles.txt
rem rem @echo 5:Качественный:4314312>>intprofiles.txt
rem @echo 6:Максимальный:5411113 >>intprofiles.txt
@echo 1:Minimum:1121121>>intprofiles.txt
@echo 2:Light:2221312>>intprofiles.txt
@echo 3:Balanced:3314113 >>intprofiles.txt
@echo 4:Demo:3224321>>intprofiles.txt
@echo 5:Quality:4314312>>intprofiles.txt
@echo 6:Maximum:5411113 >>intprofiles.txt
exit /b

:_IntProfilesCollection
rem @echo.
rem @echo   = Интегрированные профили:
@echo   = Integrated profiles:
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
@echo.
@echo.
@echo.
@echo  -------------------------------------------------
rem @echo        +++ Файл профилей отсутствует +++
rem @echo.
rem @echo  Создайте вручную и сохраните хотя бы один профиль
@echo        +++ Profile file is missing +++
@echo.
@echo  Create and save at least one profile manually
@echo.
@echo.
@echo.
@echo.
@echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата к настройкам^<^<^<
@echo ^>^>^> Press anything to return to settings ^<^<^<
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
rem echo   Сохраняем настройки:
echo   Saving settings:
echo.
echo.
rem @Set /p profname="Введите имя нового профиля и нажмите Enter: "
@Set /p profname="Enter the name of the new profile and press Enter: "
@echo !pnadd!:!profname!:!profdatanew!>>TransMultiProfiles.txt 
@echo ---------------------------------------------
rem @echo  +++ Настройки сохранены в файл профиля +++
@echo  +++ Settings saved to profile file +++
@echo.
@echo.
call :_ProfilesCollection
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo ^>^>^> Press anything to return ^<^<^<
@pause 1>nul 2>nul
goto _Choiced

:_CreateNewTransProFile
@echo.
@echo -----------------------------------------------------------------
rem @echo             +++ Файл профилей отсутствует +++
rem @echo.
rem @echo Создаем новый файл профилей и сохраняем в него выбранные настройки:
@echo             +++ Profile file is missing +++
@echo.
@echo Creating a new profile file and saving the selected settings:
@echo.
@echo.
@echo.
set pn=1
rem @Set /p profnamenew="Введите имя нового профиля и нажмите Enter: "
@Set /p profnamenew="Enter the name of the new profile and press Enter: "
@echo ProfileNumber:ProfileName:ProfileData>>TransMultiProfiles.txt
@echo !pn!:!profnamenew!:!profdatanew!>>TransMultiProfiles.txt 
@echo.
@echo ---------------------------------------------
rem @echo  +++ Настройки сохранены в файл профилей +++
rem @echo.
rem @echo  При желании его можно редактироовать вручную.
@echo  +++ Settings saved to profile file +++
@echo.
@echo  If desired, it can be edited manually.
@echo.
@echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo ^>^>^> Press anything to return ^<^<^<
@pause 1>nul 2>nul
goto _Choiced

:_ProfRewrite
cls
@echo.
@echo.
rem @echo   0. Выход из программы
rem @echo   M. Отмена выбора и возврат в предыдущее меню
@echo   0. Exit the program
@echo   M. Cancel selection and return to the previous menu
@echo.
@echo.
@echo   = Сохраняемый профиль:
@echo   = Profile to be saved:
call :_tabProfilesNew
@echo   --------------------------------------------------------------------------------------
call :_ProfilesCollection
rem @echo   = К сожалению, борльше нет свободных слотов для профилей.
@echo   = Unfortunately, there are no more free slots for profiles.
@echo.
rem @Set /p pnnew="Из доступных профилей выберите номер перезаписываемого профиля и нажмите Enter: "
@Set /p pnnew="From the available profiles, enter the number of the profile to be overwritten and press Enter: "
if not defined pnnew goto _ProfRewrite
if "%pnnew%"=="0" (exit)
if /i "%pnnew%"=="m" (GOTO _ManualTransSettings)
@echo.%pnnew%|>nul findstr /rc:"[^1-4]"&&(goto _ProfRewrite)
@Set profnamenew=
rem @Set /p profnamenew="Введите имя нового профиля и нажмите Enter: "
@Set /p profnamenew="Enter the name of the new profile and press Enter: "
if "%profnamenew%" equ "" set profnamenew=NewProfile
@echo ProfileNumber:ProfileName:ProfileData>>TransMultiProfilesNew.txt
@For /F "skip=1 tokens=1,2,3 delims=:" %%a In (TransMultiProfiles.txt) Do (
@set pn=%%a
@set profname=%%b
@set profdata=%%c
if not !pnnew!==!pn! (@echo !pn!:!profname!:!profdata!>>TransMultiProfilesNew.txt) else (@echo !pnnew!:!profnamenew!:!profdatanew!>>TransMultiProfilesNew.txt)
)
@echo.
@del TransMultiProfiles.txt /q /f 1>nul 2>nul
@ren TransMultiProfilesNew.txt TransMultiProfiles.txt 1>nul 2>nul
@echo.
@echo ---------------------------------------------
rem @echo  +++ Настройки сохранены в файл профилей +++
rem @echo.
rem @echo  При желании его можно редактироовать вручную.
@echo  +++ Settings saved to profile file +++
@echo.
@echo  If desired, it can be edited manually.
@echo.
@echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo ^>^>^> Press anything to return ^<^<^<
@pause 1>nul 2>nul
goto _Choiced

:_ProfilesCollection
@echo.
rem @echo   = Сохраненные профили:
@echo   = Saved profiles:
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
rem if [%aa%]==[] set errorout=Битрейт&&goto _seterror
rem if [%bb%]==[] set errorout=FPS&&goto _seterror
rem if [%cc%]==[] set errorout=Запись сессии&&goto _seterror
rem if [%dd%]==[] set errorout=Обрезка кадра&&goto _seterror
rem if [%ee%]==[] set errorout=Вывод звука&&goto _seterror
rem if [%ff%]==[] set errorout=Датчик приближения&&goto _seterror
if [%aa%]==[] set errorout=Bitrate&&goto _seterror
if [%bb%]==[] set errorout=FPS&&goto _seterror
if [%cc%]==[] set errorout=Session recording&&goto _seterror
if [%dd%]==[] set errorout=Frame cropping&&goto _seterror
if [%ee%]==[] set errorout=Sound output&&goto _seterror
if [%ff%]==[] set errorout=Proximity sensor&&goto _seterror

if [%gg%]==[] set gg=2& set vcodecset=--video-codec=h264 --video-encoder='OMX.qcom.video.encoder.avc' & set vcodecmsg=h264 OMX.qcom.video.encoder.avc
rem if [%hh%]==[] set hh=2& set acodecset=--audio-codec=aac --audio-encoder='c2.android.aac.encoder' & set acodecmsg=c2.android.aac.encoder

rem @echo.%aa%|>nul findstr /rc:"[^1-5]"&&(set errorout=Битрейт)&&(goto _seterror)
rem @echo.%bb%|>nul findstr /rc:"[^1-4]"&&(set errorout=FPS)&&(goto _seterror)
rem @echo.%cc%|>nul findstr /rc:"[^1-2]"&&(set errorout=Запись сессии)&&(goto _seterror)
rem @echo.%dd%|>nul findstr /rc:"[^1-4]"&&(set errorout=Обрезка кадра)&&(goto _seterror)
rem @echo.%ee%|>nul findstr /rc:"[^1-3]"&&(set errorout=Вывод звука)&&(goto _seterror)
rem rem @echo.%ff%|>nul findstr /rc:"[^1-2]"&&(set errorout=Датчик приближения)&&(goto _seterror)
rem @echo.%gg%|>nul findstr /rc:"[^1-3]"&&(set errorout=Видеокодек)&&(goto _seterror)
rem @echo.%hh%|>nul findstr /rc:"[^1-3]"&&(set errorout=Аудиокодек)&&(goto _seterror)
@echo.%aa%|>nul findstr /rc:"[^1-5]"&&(set errorout=Bitrate)&&(goto _seterror)
@echo.%bb%|>nul findstr /rc:"[^1-4]"&&(set errorout=FPS)&&(goto _seterror)
@echo.%cc%|>nul findstr /rc:"[^1-2]"&&(set errorout=Session recording)&&(goto _seterror)
@echo.%dd%|>nul findstr /rc:"[^1-4]"&&(set errorout=Frame cropping)&&(goto _seterror)
@echo.%ee%|>nul findstr /rc:"[^1-3]"&&(set errorout=Sound output)&&(goto _seterror)
@echo.%ff%|>nul findstr /rc:"[^1-2]"&&(set errorout=Proximity sensor)&&(goto _seterror)
@echo.%gg%|>nul findstr /rc:"[^1-3]"&&(set errorout=Video codec)&&(goto _seterror)
rem @echo.%hh%|>nul findstr /rc:"[^1-3]"&&(set errorout=Audio codec)&&(goto _seterror)


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
if %cc%==1 set recmsg=С записью & call :_RecordEnableSettings
rem if %cc%==2 set recfile= & set recmsg=Без записи
if %cc%==2 set recfile= & set recmsg=Without recording

::Crop
rem if %dd%==1 set cropset=1584:1440:1950:250 & set cropmsg=Обрезка углов
rem if %dd%==2 set cropset=1832:1920:0:0 & set cropmsg=Без обрезки
rem if %dd%==3 set cropset=3664:1920:0:0 & set cropmsg=Режим стерео
if %dd%==1 set cropset=1584:1440:1950:250 & set cropmsg=Corner cropping
if %dd%==2 set cropset=1832:1920:0:0 & set cropmsg=No cropping
if %dd%==3 set cropset=3664:1920:0:0 & set cropmsg=Stereo mode
if %dd%==4 set cropset=1600:900:2017:510 & set cropmsg=1600x900

::Выход звука
rem if %ee%==1 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=& set amsg=Звук на ПК 
rem if %ee%==2 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=--no-audio& set amsg=Звук на шлеме
rem if %ee%==3 set acodecset=--audio-source=mic& set audiomute=& set amsg=ПК,микрофон,шлем
if %ee%==1 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=& set amsg=Sound on PC
if %ee%==2 set acodecset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=--no-audio& set amsg=Sound on headset
if %ee%==3 set acodecset=--audio-source=mic& set audiomute=& set amsg=PC, microphone, headset

rem if %ee%==1 set audioset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=& set amsg=Звук на ПК 
rem if %ee%==2 set audioset=--audio-codec=aac --audio-encoder='OMX.google.aac.encoder'& set audiomute=--no-audio& set amsg=Звук на шлеме
rem if %ee%==3 set audioset=--audio-source=mic& set audiomute=& set amsg=С микрофона 

::Prox
rem if %ff%==1 set Proximity=0 & set proxmsg=Отключить
rem if %ff%==2 set Proximity=1 & set proxmsg=Не отключать
if %ff%==1 set Proximity=0 & set proxmsg=Disable
if %ff%==2 set Proximity=1 & set proxmsg=Do not disable

::Video
if %gg%==1 set vcodecset=--video-codec=h264 --video-encoder='OMX.qcom.video.encoder.avc'& set vcodecmsg=h264 OMX.qcom.video.encoder.avc
rem if %gg%==2 set vcodecset=--video-codec=h264 --video-encoder='c2.qti.avc.encoder' & set vcodecmsg=h264 c2.qti.avc.encoder
if %gg%==2 set vcodecset=--video-codec=h265 --video-encoder='OMX.qcom.video.encoder.hevc'& set vcodecmsg=h265 OMX.qcom.video.encoder.hevc
rem if %gg%==3 set vcodecset=--video-codec=h265 --video-encoder='OMX.qcom.video.encoder.hevc' & set vcodecmsg=h265 OMX.qcom.video.encoder.hevc
if %gg%==3 set vcodecset=--video-codec=h265 --video-encoder='OMX.qcom.video.encoder.hevc.cq'& set vcodecmsg=h265 OMX.qcom.video.encoder.hevc.cq
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
rem @echo   Профиль  !pn!	: !profname!					^| !profdata!
rem @echo   --------------------------------------------------------------------------------------
rem @echo.  Битрейт	: !bitrateset!		 ^| Вывод звука	: !amsg!
rem @echo.  FPS		: !setfps!		 ^| Датчик	: !proxmsg!
rem @echo.  Запись сессии	: !recmsg!	 ^| Видеокодек	: !vcodecmsg!
rem @echo.  Обрезка кадра	: !cropmsg!	 ^|
@echo   Profile  !pn!	: !profname!					^| !profdata!
@echo   --------------------------------------------------------------------------------------
@echo.  Bitrate	: !bitrateset!		 ^| Sound output	: !amsg!
@echo.  FPS		: !setfps!		 ^| Proximity sensor	: !proxmsg!
@echo.  Session recording	: !recmsg!	 ^| Video codec	: !vcodecmsg!
@echo.  Frame cropping	: !cropmsg!	 ^|
exit /b

:_tabProfilesNew
@echo   ======================================================================================
rem @echo   Профиль  !pnnew!	: !profnamenew!					^| !profdatanew!
rem @echo   --------------------------------------------------------------------------------------
rem @echo.  Битрейт	: !bitrateset!		 ^| Вывод звука	: !amsg!
rem @echo.  FPS		: !setfps!		 ^| Датчик	: !proxmsg!
rem @echo.  Запись сессии	: !recmsg!	 ^| Видеокодек	: !vcodecmsg!
rem @echo.  Обрезка кадра	: !cropmsg!	 ^|
@echo   Profile  !pnnew!	: !profnamenew!					^| !profdatanew!
@echo   --------------------------------------------------------------------------------------
@echo.  Bitrate	: !bitrateset!		 ^| Sound output	: !amsg!
@echo.  FPS		: !setfps!		 ^| Proximity sensor	: !proxmsg!
@echo.  Session recording	: !recmsg!	 ^| Video codec	: !vcodecmsg!
@echo.  Frame cropping	: !cropmsg!	 ^|
exit /b


:_ConnectOverWiFi
set connectivity=--tcpip
exit /b


:_CheckWiFiMode
@echo off
@%MYFILES%\adb devices 2>NUL | findstr ":" 2>nul 1>nul
@IF %ERRORLEVEL% EQU 0 (
@set /A wificheck=1
set connectivity=-e
) else (
@set /A wificheck=0
set connectivity=--tcpip
rem set connectivity=-d
)
rem set connectmsg=  +++ Соединено по WiFi. Не забудьте отключить кабель +++
set connectmsg=  +++ Connected via WiFi. Don't forget to disconnect the cable +++
@exit /b

:_ReconnectToCable
@%MYFILES%\adb kill-server 1>nul 2>nul
@%MYFILES%\adb start-server 1>nul 2>nul
exit /b

:_CheckADBDevices
rem @%MYFILES%\adb devices 1>nul 2>nul
@FOR /F "skip=1 tokens=2" %%G IN ('@%MYFILES%\adb devices ^| find "device"') DO set adbdevices=%%G
@if [%adbdevices%]==[] goto _NF
exit /b
:_NF
@echo.
@echo. 
rem @echo  +++++ Подключите к шлему кабель +++++
@echo  +++++ Connect the cable to the headset +++++
@echo.
@echo. 
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo ^>^>^> Press anything to return ^<^<^<
@pause 1>nul 2>nul
goto :_ManualTransSettings

:_SetCableSettings
set connectivity=-d
set connectmsg=     +++ Соединено по кабелю, не отключайте его +++
exit /b

:_RecordEnableSettings
call :_settime
set recfile= --record=StreamRecord-%dt%.mkv
set recformat= --record-format=mkv
exit /b

:_CodecsHelp
@echo off
@cls
@echo.
goto _eng25
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
:_eng25
@echo Audio codecs:
@echo.
@echo  OMX.google.aac.encoder and c2.android.aac.encoder are identifiers for the AAC audio format codecs
@echo  (Advanced Audio Coding) for audio encoding. They belong to different implementations of the AAC codec,
@echo  which can be used on Android devices.
@echo.
@echo  OMX.google.aac.encoder is a software-based AAC codec. This means that the codec works entirely on the
@echo  device's central processing unit (CPU). This codec provides audio encoding using software.
@echo.
@echo  c2.android.aac.encoder is a hardware-based AAC codec. Unlike the software implementation, this codec
@echo  uses the device's hardware capabilities, such as the digital signal processor (DSP) or specialized
@echo  audio cores, to perform encoding operations. A codec operating at the hardware level is usually
@echo  more efficient in terms of device resource usage and can provide higher performance.
@echo.
@echo.
@echo Video codecs:
@echo.
@echo  c2.qti.hevc.encoder and c2.qti.hevc.encoder.cq are identifiers for the High Efficiency Video Coding
@echo  (HEVC), also known as H.265, video format codecs. They belong to different profiles and encoding
@echo  configurations of HEVC.
@echo.
@echo  c2.qti.hevc.encoder is the basic HEVC codec for Qualcomm Technologies Incorporated (QTI) hardware.
@echo  It is designed for hardware video encoding using the device's hardware capabilities, such as the
@echo  graphics processing unit (GPU) or video processing unit (VPU).
@echo.
@echo  c2.qti.hevc.encoder.cq is a HEVC codec configuration for constant quality (Constant Quality). This
@echo  means that the codec will maintain a constant quality of video, rather than a constant bitrate.
@echo  This can be useful if it is important to maintain a certain video quality without being tied to
@echo  a specific bitrate.
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
rem @echo ^>^>^> Нажмите что-нибудь для возврата ^<^<^<
@echo ^>^>^> Press anything to return ^<^<^<
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
rem @echo    Введите количество проходов теста и нажмите Enter.
rem @echo    По умолчанию число проходов - 20. Просто нажмите Enterю
rem @echo    Введите 0 если хотите вернуться в меню
@echo    Enter the number of test passes and press Enter.
@echo    By default, the number of passes is 20. Just press Enter.
@echo    Enter 0 if you want to return to the menu.
@echo.
@set "choice="
@set "choice=20"
rem @Set /p choice="Выберите количество проходов (1-50) и нажмите Enter: "
@Set /p choice="Enter the number of passes (1-50) and press Enter: "
if /i "%choice%"=="0" (GOTO _beginn)
@echo.%choice%|>nul findstr /rc:"[^1-50]"&&(goto _TestVrUsvCopy)
@echo.
rem if not defined choice goto _TestVrUsvCopy
rem if "%choice%"=="0" (goto _returnmenu)
rem  /i "%choice%"=="t" (GOTO _testcablerun)
@cls
rem goto _TestVrUsvCopy

:_testcablerun
@echo off
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
::@echo ("0" - возврат в Главное меню)
::if %testNum%==0 goto _beginn

::----Путь до каталога, откуда будут копироваться файлы на шлем (например C:\Temp)----::
::----Если пустой, будет использоваться каталог запуска скрипта----::
@set pathTest=.\TestFiles

:::::::::::::::::: SETTINGS END ::::::::::::::::::

::echo. 
rem @echo  Стартуем проверку USB кабеля передачей файлов на шлем. 
rem @echo  Количество проходов теста: %testNum%.
rem @echo  Подождите немного...
@echo Starting test of USB-cable using file transfer with %testNum% attempts. Please wait...
echo. 

@set /A i=1
@set /A allErr=0

:_begin
@set /A isOk=0
%adbExe% push %pathTest% /sdcard/Download/Files >_ && type _
@find "in -" _>nul
@if !errorlevel! EQU 0 (
	@set /A isOk=1
	@set /A allErr+=1
)
%adbExe% shell rm -rf sdcard/Download/Files
rem @if %!sOk! NEQ 1 echo.  !time! Тест #!i! прошел успешно.
@if %!sOk! NEQ 1 echo.  !time! Test #!i! passed successfully.
@set /A i+=1
@if !i! LEQ %testNum% goto _begin


echo. 
rem echo  Тест завершен. Время начала: %startTime%. Время завершения: %time%. Ошибки: !allErr!
echo  The test is complete. Start time: %startTime%. End time: %time%. Errors: !allErr!
echo.
del /q _
@del .\TestFiles /q >nul
@rd .\TestFiles /q >nul
@goto _returnmenu

:_opencmd
@start cmd
goto _beginn

:_openshell
@echo off
::@start cmd /c @echo. & @adb shell
@start cmd /c @%MYFILES%\adb shell
goto _beginn


:_backupdatamenu
call :_cdc
call :_hat
call :_hatmenu
@echo.
rem @echo    B.  Создать бэкап данных приложений   [EXP]
rem @echo.
rem @echo.
rem @echo.
rem @echo ОБРАТИТЕ ВНИМАНИЕ:
rem @echo.
rem @echo      Процесс может занять значительное время!
rem @echo      Со шлема будет скопирован и запакован
rem @echo      в один архив весь каталог /Android/data/
@echo    B.  Create an application data backup   [EXP]
@echo.
@echo.
@echo.
@echo PLEASE NOTE:
@echo.
@echo      The process may take a significant amount of time!
@echo      From the headset, the entire /Android/data/ directory will be copied and packed
@echo      into a single archive.
@echo.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _backupdatamenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="b" (GOTO _backupdata)
cls
goto _backupdatamenu

:_backupdata
call :_settime
@echo ----------------------------------
@echo.
rem @echo Процесс архивации запущен, ждите окончания...
@echo The archiving process has started, please wait...
@%myfiles%\adb pull /sdcard/Android/data/ 1>nul 2>nul
@%myfiles%\7z.exe a -mx7 -t7z -ssw data-%dt%.7z %cd%\data 1>NUL 2>&1
@rd %cd%\data /q /s 1>nul 2>nul
@echo ======================================== 
@echo.
rem @echo Архив сохранен в текущем каталоге с именем data-%dt%.7z
@echo The archive is saved in the current directory with the name data-%dt%.7z
@goto _returnmenu

:_helplinksmenu
call :_hat
@echo.
@echo off
@echo      ----------------------------
rem @echo       ВЫБЕРИТЕ ИНТЕРЕСУЮЩУЮ ТЕМУ
rem @echo      ----------------------------
rem @echo.
rem @echo    0.  Выход из программы
rem @echo    M.  Выход в главное меню
@echo       CHOOSE THE INTERESTING TOPIC
@echo      ----------------------------
@echo.
@echo    0.  Exit the program
@echo    M.  Return to the main menu
@echo.
rem @echo    A.  Возможные решения проблем с подключением шлема по Link и AirLink
rem @echo    B.  Первичная настройка шлема и установка обновлений
rem @echo    C.  Платные и бесплатные VPN клиенты для обхода блокировок
rem @echo    D.  Руководство по различным методам прошивки шлема
rem @echo    E.  Создание организации для включения режима разработчика
rem @echo    F.  Процедура перехода на Meta-аккаунт
rem @echo    G.  Всеобъемлющий FAQ по шлему Oculus Quest 2
rem @echo    I.  Сайт для проверки доступности адресов
@echo    I.  Website to check the availability of addresses (RU)
rem @echo    J.  Где и как скачивать игры
rem @echo    K.  Все об  Oculus Quest: прошивки, статьи, программы и многое другое
rem @echo    L.  Авторский портал о VR: vr419.ru
rem @echo    N.  Скачать последнюю версию Quas или оставить вопрос/отзыв/комментарий
rem @echo    O.  Скачать прошивки для Quest 1/2/3/Pro
rem @echo    P.  WebADB: Управление шлемом в браузере
@echo    K.  All about Oculus Quest: firmware, articles, programs, and much more (RU)
@echo    L.  Author's portal about VR: vr419.ru (RU)
@echo    N.  Download the latest version of Quas or leave a question/feedback/comment (RU)
@echo    O.  Download firmware for Quest 1/2/3/Pro
@echo    P.  WebADB: Headset management in the browser
::@echo Q. Отключить AirLink
::@echo R. Отключить AirLink
@echo.
@echo ---------------------------------------------------------------------
rem @echo  Ссылки будут открываться в браузере по умолчанию.
rem @echo  Введите сдвоенный пункт меню, если хотите принудительно
rem @echo  открыть ссылку в браузере Chrome, например aa, AA, bb, BB и т.д.
@echo  Links will open in the default browser.
@echo  Enter a double menu item if you want to forcibly
@echo  open the link in the Chrome browser, for example aa, AA, bb, BB, etc.
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _helplinksmenu
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
rem if /i "%choice%"=="a" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=111544424")
rem if /i "%choice%"=="aa" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=111544424")
rem if /i "%choice%"=="b" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=107113399")
rem if /i "%choice%"=="bb" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=107113399")
rem if /i "%choice%"=="c" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=113691944")
rem if /i "%choice%"=="cc" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=113691944")
rem if /i "%choice%"=="d" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=114175482")
rem if /i "%choice%"=="dd" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=114175482")
rem if /i "%choice%"=="e" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=118235856")
rem if /i "%choice%"=="ee" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=118235856")
rem if /i "%choice%"=="f" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=117723958")
rem if /i "%choice%"=="ff" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=117723958")
rem if /i "%choice%"=="g" (start " " "https://4pda.to/forum/index.php?showtopic=1025596")
rem if /i "%choice%"=="gg" (start " " chrome "https://4pda.to/forum/index.php?showtopic=1025596")
if /i "%choice%"=="i" (start " " "https://ping-admin.ru/free_test/")
if /i "%choice%"=="ii" (start " " chrome "https://ping-admin.ru/free_test/")
rem if /i "%choice%"=="j" (start " " "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=109158205")
rem if /i "%choice%"=="jj" (start " " chrome "https://4pda.to/forum/index.php?s=&showtopic=1025596&view=findpost&p=109158205")
if /i "%choice%"=="k" (start " " "https://vrcomm.ru")
if /i "%choice%"=="kk" (start " " chrome "https://vrcomm.ru")
if /i "%choice%"=="l" (start " " "https://vr419.ru/")
if /i "%choice%"=="ll" (start " " chrome "https://vr419.ru/")
if /i "%choice%"=="n" (start " " "https://vrcomm.ru/files/file/7-quest-adb-commands---quac-aka-"квас"/")
if /i "%choice%"=="nn" (start " " chrome "https://vrcomm.ru/files/file/7-quest-adb-commands---quas-aka-"квас"/")
if /i "%choice%"=="o" (start " " "https://cocaine.trade/)
if /i "%choice%"=="oo" (start " " chrome "https://cocaine.trade/")
rem if /i "%choice%"=="p" (start " " "https://app.webadb.com/" && @echo Через 10 секунд программа будет закрыта && @timeout 10 && goto _tk)
rem if /i "%choice%"=="pp" (start " " chrome "https://app.webadb.com/" && @echo Через 10 секунд программа будет закрыта && @timeout 10 && goto _tk)
if /i "%choice%"=="p" (start " " "https://app.webadb.com/" && @echo The program will be closed in 10 seconds && @timeout 10 && goto _tk)
if /i "%choice%"=="pp" (start " " chrome "https://app.webadb.com/" && @echo The program will be closed in 10 seconds && @timeout 10 && goto _tk)
::if /i "%choice%"=="q" (start " " "_____")
::if /i "%choice%"=="qq" (start " " chrome "_____")
::if /i "%choice%"=="r" (start " " "_____")
::if /i "%choice%"=="rr" (start " " chrome "_____")
@cls
goto _helplinksmenu

:_syscommenu
call :_settime
call :_hat
call :_hatmenu
@echo.
goto _eng26
@echo    A.  Работа с dumpsys
@echo    B.  Мониторинг нагрузки и диагностика компонентов	[EXP]
@echo    C.  Вывести все свойства шлема (getprop)
@echo    D.  Показать IP адрес шлема
@echo    E.  Сохранить список установленных пакетов (packages names)
@echo    F.  Показать серийный номер шлема
@echo    G.  Системныe настройки шлема (setting list system/global/security)
@echo    H.  Работа с Logcat
@echo    I.  Информация об аккумуляторе
@echo    K.  Извлечение багрепорта                 		[EXP]
@echo    L.  Просмотр CPU-емких приложений         		[EXP]
@echo    N.  Список файлов/каталогов и их объем    		[EXP]
@echo    O.  Показать объем занятого места         		[EXP]
@echo    P.  Журнал подключений и отключений USB устройств
@echo    Q.  Отобразить информацию об обновлениях
@echo.   R.  Сохранение всей системной информации оптом в один архив
:_eng26
@echo    A.  Work with dumpsys
@echo    B.  Load monitoring and component diagnostics [EXP]
@echo    C.  Display all headset properties (getprop)
@echo    D.  Show headset IP address
@echo    E.  Save a list of installed packages (package names)
@echo    F.  Show headset serial number
@echo    G.  Headset system settings (setting list system/global/security)
@echo    H.  Work with Logcat
@echo    I.  Battery information
@echo    K.  Bug report extraction [EXP]
@echo    L.  View CPU-intensive applications [EXP]
@echo    N.  List of files/directories and their size [EXP]
@echo    O.  Show the amount of occupied space [EXP]
@echo    P.  USB device connection and disconnection log
@echo    Q.  Show update information
@echo.   R.  Save all system information in bulk into one archive
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
if /i "%choice%"=="b" (GOTO _alltempmenu)
if /i "%choice%"=="c" (GOTO _allprop)
if /i "%choice%"=="d" (GOTO _showip)
if /i "%choice%"=="e" (GOTO _packageslist)
if /i "%choice%"=="ee" (GOTO _packagesfull)
if /i "%choice%"=="f" (GOTO _showserial)
if /i "%choice%"=="g" (GOTO _syscomm)
if /i "%choice%"=="h" (GOTO _adblogcat)
if /i "%choice%"=="i" (GOTO _batinfo)
if /i "%choice%"=="k" (GOTO _bugreportextr)
if /i "%choice%"=="l" (GOTO _cpuload)
if /i "%choice%"=="n" (GOTO _sizecheckmenu)
if /i "%choice%"=="o" (GOTO _sizeinfo)
if /i "%choice%"=="p" (GOTO _USBConnectionsList)
if /i "%choice%"=="q" (GOTO _UpdatesInfo)
if /i "%choice%"=="r" (GOTO _AllSystemFiles)




cls
goto _syscommenu

:_UpdatesInfo
call :_cdc
rem @echo =  Были установлены обновления:
@echo =  Updates have been installed:
@echo.
call :_settime
@echo off
rem !!!!!!! Узнать как называется раздел в английском dumpsys !!!!!
%myfiles%\adb shell dumpsys DumpsysProxy 'Ключевые мобильные сервисы Oculus (DumpsysLedger)' >dspo.txt

Setlocal EnableDelayedExpansion
@FOR /f "tokens=*" %%a IN (dspo.txt) do set a=%%a
@set a=!a:,= !
rem echo !a!
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
echo %%a | findstr /C:"%searchString%" >nul
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
@if not %nextLine%==[] echo %nextLine%
rem >>name.txt
rem if not %nextLine%==[] echo https://securecdn.oculus.com/binaries/download/?id=%nextLine%>>numb.txt
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
rem @echo =  Сохранение всей системной информации оптом..
@echo =  Bulk saving of all system information...
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
rem @echo =  Готово. Инфа сложена в один архив allsysteminfo-%dt%.7z
@echo =  Done. Info is packed into one archive allsysteminfo-%dt%.7z
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
rem @echo  Настройки отключения экрана восстановлены
@echo  Screen timeout settings restored
@echo.
@echo.
call :_prevmenu
goto _syscommenu


:_sysnameall
:: Наименования всех сервисов
@%MYFILES%\adb shell dumpsys -l >%cd%\servicelist-%dt%.txt 
call :_erlvl
@echo =============================
rem @echo  Наименования сервисов сохранены в текущий каталог в файл servicelist-%dt%.txt
@echo  Service names are saved to the current directory in the file servicelist-%dt%.txt
::@echo  Для вывода информации о конкретном сервисе, введите его имя в конце команды.
::@echo  Примеры:
::@echo      adb shell dumpsys wifi
::@echo      adb shell dumpsys TelemetryService
call :_prevmenu
goto _syscommenu

:_dumpsysmenu
call :_hat
call :_hatmenu
@echo.
rem @echo    A.  Сохранить полный список состояния (dumpsys)
rem @echo    B.  Поиск и выборка по определенному слову
rem @echo    C.  Поиск и выборка, ИСКЛЮЧАЯ определенное слово
rem @echo    D.  Наименование всех сервисов (dumpsys -l)
@echo    A.  Save the full state list (dumpsys)
@echo    B.  Search and selection by a specific word
@echo    C.  Search and selection, EXCLUDING a specific word
@echo    D.  Name of all services (dumpsys -l)
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
rem @echo  Секундочку, снимаем дамп... 
@echo  Just a moment, taking a dump...
@echo ----------------------------------
@%MYFILES%\adb shell dumpsys 2>nul >dumpsysfull-%dt%.txt
@echo =============================
rem @echo  Дамп сохранен в текущий каталог в файл dumpsysfull-%dt%.txt
@echo  Dump saved to the current directory in the file dumpsysfull-%dt%.txt
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
rem @echo   Будет снят полный дамп и из него будут выбраны только те строки, 
rem @echo   в которых содержится искомое слово.
rem @echo   Выборка сохранится в файл dumpsys-слово-для-поиска.txt
rem @echo.
rem @echo   Если передумали, введите 0 и нажмите Enter
rem @echo   для возврата в предыдущее меню.
@echo   A full dump will be taken and only the lines containing the search word will be selected from it.
@echo   The selection will be saved to the file dumpsys-search-word.txt
@echo.
@echo   If you changed your mind, enter 0 and press Enter
@echo   to return to the previous menu.
@echo.
@echo.
@echo.
@echo.
:: Полный список состояния системных сервисов
rem @Set /p srch=" Bведите слово для выборки и нажмите Enter: "
@Set /p srch="Enter the word for selection and press Enter: "
if %srch%==0 goto _dumpsysmenu
@echo ================================
rem @echo  Секундочку, снимаем дамп... 
@echo  Just a moment, taking a dump...
@echo.
@echo ----------------------------------
@%MYFILES%\adb shell dumpsys 2>nul >dumpsrch.txt
call :_erlvl
>nul find /i "%srch%" < dumpsrch.txt >> dumpsys-%srch%-%dt%.txt
@echo =============================
rem @echo  Дамп сохранен в текущий каталог в файл dumpsys-%srch%-%dt%.txt
@echo  Dump saved to the current directory in the file dumpsys-%srch%-%dt%.txt
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
rem @echo   Будет снят полный дамп и из него будут выбраны только те строки, 
rem @echo   в которых НЕ содержится искомое слово.
rem @echo   Выборка сохранится в файл dumpsys-слово-для-поиска.txt
rem @echo.
rem @echo   Если передумали, введите 0 и нажмите Enter
rem @echo   для возврата в предыдущее меню.
@echo   A full dump will be taken and only the lines NOT containing the search word will be selected from it.
@echo   The selection will be saved to the file dumpsys-search-word.txt
@echo.
@echo   If you changed your mind, enter 0 and press Enter
@echo   to return to the previous menu.
@echo.
@echo.
@echo.
@echo.
:: Полный список состояния системных сервисов
rem @Set /p srch=" Bведите слово для выборки и нажмите Enter: "
@Set /p srch="Enter the word for selection and press Enter: "
if %srch%==0 goto _dumpsysmenu
@echo ================================
rem @echo  Секундочку, снимаем дамп... 
@echo  Just a moment, taking a dump...
@echo.
@echo ----------------------------------
@%MYFILES%\adb shell dumpsys 2>nul >dumpsrch.txt
call :_erlvl
>nul find /i /v "%srch%" < dumpsrch.txt >> dumpsys-%srch%-%dt%.txt
@echo =============================
rem @echo  Дамп сохранен в текущий каталог в файл dumpsys-%srch%-%dt%.txt
@echo  Dump saved to the current directory in the file dumpsys-%srch%-%dt%.txt
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
rem @echo  Дополнительная информация о батарее сохранена в файл battery-%dt%.txt
@echo  Additional battery information saved to the file battery-%dt%.txt
call :_prevmenu
goto _syscommenu

:_allprop
:: Вывести все свойства
@%MYFILES%\adb shell getprop >properties-%dt%.txt
call :_erlvl
@echo =============================
rem @echo  Информация о свойствах сохранена в текущий каталог в файл properties-%dt%.txt
@echo  Properties information saved to the current directory in the file properties-%dt%.txt
call :_prevmenu
goto _syscommenu

:_showip
call :_cdc
:: Показать IP адрес шлема
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|find "inet "') DO @set ipfull=%%G
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO @set ip=%%G
rem @echo  IP адрес шлема: %ip%
@echo  Headset IP address: %ip%
call :_prevmenu
goto _syscommenu

:_packageslist
call :_cdc
call :_packages
call :_packagesfull
@echo ======================================
rem @echo  Списки пакетов сохранены в текущем каталоге:
rem @echo   - краткий список : packages-list-%dt%.txt
rem @echo   - полный список  : packages-list%fp%-%dt%.txt
@echo  Packages lists saved in the current directory:
@echo   - brief list : packages-list-%dt%.txt
@echo   - full list  : packages-list%fp%-%dt%.txt
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

:_showserial
call :_cdc
:: Показать серийный номер шлема
rem @echo Серийный номер шлема:
@echo Headset Serial Number:
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
rem @echo  Общие настройки в файле global-%dt%.txt в текущем каталоге
rem @echo  Настройки безопасности в файле secure-%dt%.txt в текущем каталоге
rem @echo  Системные настройки в файле system-%dt%.txt в текущем каталоге
@echo  General settings in the file global-%dt%.txt in the current directory
@echo  Security settings in the file secure-%dt%.txt in the current directory
@echo  System settings in the file system-%dt%.txt in the current directory
call :_prevmenu
goto _syscommenu

:_adbintegr
call :_hat
call :_hatmenu
@echo.
goto _eng27
@echo    A.  Встроить ADB и пакет утилит в систему
@echo    B.  Встроить только ADB в систему
@echo    C.  Удалить ADB и пакет утилит из системы
@echo.
@echo  ==================================================
@echo.
@echo     ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo  При встраивании пакета утилит в каталог %windir% 
@echo  будут скопированы (не установлены, а скопированы!)
@echo  следющие файлы:
@echo.
@echo 	adb.exe
@echo 	adbWinApi.dll
@echo 	AdbWinUsbApi.dll
@echo 	aapt2.exe
@echo 	devcon_x64.exe
@echo 	fastboot.exe
@echo 	7z.dll
@echo 	7z.exe
@echo 	wget.exe
@echo.
@echo  При встраивании только ADB будут скопированы 
@echo  первые три файла из этого списка.
:_eng27
@echo    A.  Embed ADB and utility package into the system
@echo    B.  Embed only ADB into the system
@echo    C.  Remove ADB and utility package from the system
@echo.
@echo  ==================================================
@echo.
@echo     PLEASE NOTE:
@echo.
@echo  When embedding the utility package into the %windir% directory,
@echo  the following files will be copied (not installed, but copied!):
@echo.
@echo 	adb.exe
@echo 	adbWinApi.dll
@echo 	AdbWinUsbApi.dll
@echo 	aapt2.exe
@echo 	devcon_x64.exe
@echo 	fastboot.exe
@echo 	7z.dll
@echo 	7z.exe
@echo 	wget.exe
@echo.
@echo  When embedding only ADB, the first three files from this list will be copied.
@echo.
@echo.
@echo.
@set "choice="
@set "choice=A"
rem @Set /p choice="Выберите пункт меню и нажмите Enter (Enter - A): "
@Set /p choice="Select a menu number and press Enter (Only Enter = A): "
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
@xcopy %MYFILES%\aapt2.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\devcon_x64.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\fastboot.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\7z.dll %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\7z.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\wget.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\adb.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinApi.dll %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinUsbApi.dll %windir%\*.* /Y 1>NUL 2>&1
@echo ===================================================
rem @echo  ADB и пакет утилит встроены в систему. 
rem @echo  Теперь в консоли cmd можно не указывать путь к adb,
rem @echo  а просто писать команду, например: adb devices
rem @echo.
rem @echo  Также можно использовать другие утилиты сразу, 
rem @echo  без необходимости указывать путь к ним.
@echo  ADB and utility package are embedded into the system.
@echo  Now in the cmd console you can omit the path to adb,
@echo  and just write the command, for example: adb devices
@echo.
@echo  You can also use other utilities immediately,
@echo  without having to specify their path.
@echo -------------------------------------------------
call :_prevmenu
goto _syscommenu

:_onlyadbintegration
@xcopy %MYFILES%\adb.exe %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinApi.dll %windir%\*.* /Y 1>NUL 2>&1
@xcopy %MYFILES%\AdbWinUsbApi.dll %windir%\*.* /Y 1>NUL 2>&1
@echo =====================================================
rem @echo  ADB встроен в систему. 
rem @echo  Теперь в консоли cmd можно не указывать путь к adb,
rem @echo  а просто писать команду, например: adb devices
@echo  ADB is embedded into the system.
@echo  Now in the cmd console you can omit the path to adb,
@echo  and just write the command, for example: adb devices
@echo ---------------------------------------------------
call :_prevmenu
goto _syscommenu

:_desadbintegration
@del %windir%\adb.exe /q /f 1>NUL 2>&1
@del %windir%\AdbWinApi.dll /q /f 1>NUL 2>&1
@del %windir%\AdbWinUsbApi.dll /q /f 1>NUL 2>&1
@del %windir%\aapt2.exe /q /f 1>NUL 2>&1
@del %windir%\devcon_x64.exe /q /f 1>NUL 2>&1
@del %windir%\fastboot.exe /q /f 1>NUL 2>&1
@del %windir%\7z.dll /q /f 1>NUL 2>&1
@del %windir%\7z.exe /q /f 1>NUL 2>&1
@del %windir%\wget.exe /q /f 1>NUL 2>&1
@echo ================================================================
rem @echo  Как заказывали: Весь интегрированный хлам удален из %windir%
@echo  As ordered: All integrated junk has been removed from %windir%
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
goto _eng28
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
@echo      MONITORING AND DIAGNOSTICS OF COMPONENTS
@echo.
@echo.
@echo.
:_eng28
@echo  Every few seconds the values are updated automatically.
@echo.
@echo  If you enter an interval with the letter "w" at the end of the number,
@echo  the readings will be saved to a csv file.
@echo.
@echo  For example, for a 10 second interval and saving to a file, enter "10w", without quotes.
@echo  By default, the interval is 5 seconds and without saving to a file.
@echo.
@echo.
@set "intervaltemp="
@set "intervaltemp=5"
rem @Set /p intervaltemp="Введите новый интервал или просто нажмите Enter: "
@Set /p intervaltemp="Enter a new interval or just press Enter: "
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

@For /f "tokens=*" %%a in ('%MYFILES%\adb.exe shell dumpsys FanMonitorService') do set fancheck=%%a
@%MYFILES%\adb.exe shell dumpsys hardware_properties >hwp.txt

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
@IF !tempvar! == !fanspedconst! set fansped=!cc!
)

cls
call :_hat
@echo.
@echo.
@echo.
goto _eng29
@echo  Мониторинг нагрузки и диагностика компонентов
@echo.
@echo --------------------------------------------
@echo  Статус вентилятора	: !fancheck:~11,-11!
@echo  Скорость вентилятора	: !fansped:~1,3!
@echo  Варнинги вентилятора	: !fancheck:~27!
@echo.
@echo  Температура CPU	: !cputemp:~1,4!°
@echo  Температура GPU	: !gputemp:~1,4!°
@echo  Температура батареи	: !battemp:~1,4!°
@echo  Температура корпуса	: !skntemp:~1,4!°
@echo.
@echo  Уровень работы CPU	: !cpulevel!
@echo  Уровень работы GPU	: !gpulevel!
@echo  Загрузка CPU		: !cpuusagesum!%%%
:_eng29
@echo  Monitoring load and component diagnostics
@echo.
@echo --------------------------------------------
@echo  Fan status            : !fancheck:~11,-11!
@echo  Fan speed             : !fansped:~1,3!
@echo  Fan warnings          : !fancheck:~27!
@echo.
@echo  CPU Temperature       : !cputemp:~1,4!°
@echo  GPU Temperature       : !gputemp:~1,4!°
@echo  Battery Temperature   : !battemp:~1,4!°
@echo  Case Temperature      : !skntemp:~1,4!°
@echo.
@echo  CPU Work Level        : !cpulevel!
@echo  GPU Work Level        : !gpulevel!
@echo  CPU Load              : !cpuusagesum!%%%
@echo --------------------------------------------
@echo.
@echo.
call :_settime
if "%intervaltemp:~-1%"=="w" @echo %dt%	!cputemp:~1,4!	!gputemp:~1,4!	!battemp:~1,4!	!skntemp:~1,4!	!cpulevel!	!gpulevel!	!fansped:~1,3!>>monitoring-%dtp%.csv
@del top.txt /q /f 1>NUL 2>&1
@del hwp.txt /q /f 1>NUL 2>&1
rem @echo Через %intervaltempsav% секунд результаты обновятся автоматически
@echo The results will automatically update every %intervaltempsav% seconds
@echo.
rem @echo  ^>^>^> Для прерывания нажмите любую кнопку ^<^<^<
@echo  To interrupt, press any key
rem @timeout %intervaltempsav%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
@timeout %intervaltempsav%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure interrupted +++ ^ & @echo. ^ & @goto _returnmenu

@echo.
rem @echo  ...Обновление значений....
@echo  ...Values updating...
@endlocal
goto _alltemp

:_CreateFileMon
@echo DATETIME	TCPU	TGPU	TBAT	TCAS	LCPU	LGPU	SFAN>monitoring-%dtp%.csv
exit /b

:_setshare
cls
call :_hat
@echo.
@echo.
@echo.
@echo.
goto _eng30
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
:_eng30
@echo  ATTENTION:
@echo.
@echo  The shared resource will be created on behalf of the current user
@echo.
@echo  Enter the folder name and the full path to it, for example D:\Video
@echo  The path and folder name can be copied from Windows Explorer
@echo  and paste it here. The path should contain only one directory,
@echo  in other words, such an option: D:\Video\Media won't work.
@echo.
@echo  The folder can be either new or already existing.
@echo  If the folder does not exist, it will be created.
@echo.
@echo  Network access rights to the folder - Read Only.
@echo.
@echo.
@echo -------------------------------------------------------
@echo  If you change your mind - enter "0" and press Enter to return to the Main menu.

@echo.
@set remoteuser=%username%
rem @Set /p fullmediafolder="Введите здесь имя папки и нажмите Enter: "
@Set /p fullmediafolder="Enter the folder name here and press Enter: "
if %fullmediafolder%==0 goto _beginn
md %fullmediafolder%
set mf=%fullmediafolder:~3%
@net share %mf%="%fullmediafolder%"
@cmd/c takeown /f "%fullmediafolder%" /r /d y 2>nul 1>&2 && icacls "%fullmediafolder%" /grant:r "%remoteuser%":(OI)(CI)F /t
@echo.
@echo ----------------------
rem @echo Готово, можно подключаться.
@echo Ready, you can connect now.
@echo.
@goto _returnmenu

:_cpuload
call :_cdc
@echo off
@echo ========================
rem @echo Снимаем дамп, секунду..
@echo Taking a dump, one moment..
@%MYFILES%\adb logcat -c 2>nul
call :_erlvl
@%MYFILES%\adb shell dumpsys binder_calls_stats -a >dump.txt 2>nul
@echo ------------------------
rem @echo Парсим дамп..
@echo Parsing the dump..
(SetLocal EnableDelayedExpansion
 set/a $ai=-1
 for /f "usebackq delims=" %%a in ("dump.txt") do @(set "$a=%%a"
 if "!$a:~,15!"=="Per-UID Summary" set/a $ai=36
 if !$ai! geq 0 set/a $ai-=1& echo:!$a!)
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
goto _eng31
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
:_eng31
@echo    S.  View occupied space   [EXP]
@echo.
@echo.
@echo Note:
@echo.
@echo      The process may take a significant amount of time!
@echo.      
@echo      The file with the results will be placed next to the program.
@echo      Upon completion of the scan, it will be opened by the default text editor.
@echo      The number at the beginning of the line is the volume of space occupied in megabytes.      
@echo      Anything less than 10 megabytes is not counted.
@echo.
@echo      Of course, not all directories are scanned, only those 
@echo      to which access is allowed. Therefore, the output data
@echo      is reliable, but not complete.
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
@echo off
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
rem @echo Дерево каталогов создано, начинаем сканирование...
@echo Directory tree created, starting scan...
>nul find /i /v "Permission denied" < "ls.txt" > "lslist.txt"

@for /f %%d in (lslist.txt) do (
@set cat=%%d
@echo ------------------------------
rem @echo  Сканируем каталог: !cat!
@echo Scanning directory: !cat!
@echo. >> sizelist.txt
@echo ======================================>> sizelist.txt
rem @echo  Каталог: !cat! >> sizelist.txt
@echo Directory: !cat! >> sizelist.txt
@echo ------------------------->> sizelist.txt
%myfiles%\adb shell "du -ham /!cat!/ &>/sdcard/dupd.txt"
::%myfiles%\adb shell "du -hacH &>/sdcard/dupd.txt"
%myfiles%\adb pull /sdcard/dupd.txt %cd%\dupd.txt 1>nul
%myfiles%\adb shell rm -f /sdcard/dupd.txt

>nul find /i /v "Permission denied" < dupd.txt >> du0.txt

@for /f "usebackq delims=" %%i in (du0.txt) do (
	@set s=%%i
	@if "!s:~1,2!" NEQ "	/" echo %%i >> sizelist.txt
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
goto _eng32
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
:_eng32
@echo +++++ Directory scanning completed ++++
@echo.
@echo.
@echo.
@echo   The file with the results is saved
@echo   in the current directory with the name sizelist.txt
@echo   and will be opened in a few seconds.
@echo   Reminder, the number at the beginning of each line
@echo   indicates the number of occupied megabytes.
@echo.
@echo.  
@echo   Example:
@echo.
@echo  ======================================
@echo   Directory: product 
@echo  -------------------------
@echo  22	/product/priv-app/Settings/Settings.apk 
@echo  22	/product/priv-app/Settings 
@echo.
@echo.
@echo  In this example, the Settings.apk file occupies 22 megabytes.
@echo  The /product/priv-app/Settings directory occupies the same amount
@echo  since there is only this file in it.
@echo.
@echo.
@echo  Press any key to open the sizelist.txt file
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

rem @echo   Общий объем : !aa:~,-1! Гб
rem @echo   Занято      : !bb:~,-1! Гб
rem @echo   Свободно    : !cc:~,-1! Гб
rem @echo   Заполнено   : !dd!
@echo   Total volume : !aa:~,-1! GB
@echo   Occupied     : !bb:~,-1! GB
@echo   Free         : !cc:~,-1! GB
@echo   Filled       : !dd!
)
@echo.
@echo.
@echo.
@goto _returnmenu

:_103info
:_449info
@echo ----------------------------------------------------------
rem @echo  Таблица разделов шлема и их размер в байтах и гигабайтах
@echo  Table of partitions of the headset and their size in bytes and gigabytes
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
@Echo Off
cls
call :_hat
SetLocal EnableDelayedExpansion
@echo.
goto _eng33
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
:_eng33
@echo  This procedure will extract from the Windows event log
@echo  and save to file the date and time of all USB connections.
@echo  So you can find out if the cable was actually disconnected
@echo  while playing or the picture was frozen for another reason.
@echo.
@echo  The file will be located next to the program and named dis-connected.txt
@echo.
@echo  The procedure does NOT work under Windows 7.
@echo --------------------------------------------------------------
@echo.
@echo ^>^>^> Press any key to start extraction ^<^<^<
@pause >nul 
@echo.
wevtutil qe Security "/q:*[System [(EventID=4798)]]" /rd:true /f:text >1.txt
>nul find /i "Date:" < 1.txt >> dc.txt
(For /F "tokens=* usebackq delims=" %%a In ("dc.txt") Do (
	Set ta=%%a
	Echo !ta:~0,-9!
))>"dis-connected.txt"
del 1.txt /q /f
del dc.txt /q /f
@echo ==============================================
rem @echo Готово. Можете открыть файл. 
@echo Ready. You can open the file.
@goto _returnmenu

:_iperftest
call :_cdc
cls
@echo off
@call :_HeadsetIP
@call :_GetIP ipaddr
if not exist ipaddr.txt call :_CreateIPaddressTxt
call :_ExtractIPaddress
call :_hat
if [%ipaddrtxt%]==[] goto :_IPaddrEmpty
@echo.
@echo    --------------------------------------------------------------------------------
@echo    ^|    +++       Wireless Connect Tester     +++    v1.5 - 19.03.24      +++     ^|
@echo    --------------------------------------------------------------------------------
goto _eng34
@echo                   - благодарю satspace за подсказку - 
call :_hatmenu
@echo.
@echo    S.  Запустить тестирование скорости Wi-Fi  [EXP]
@echo.
rem @echo.
@echo.
@echo  ОБРАТИТЕ ВНИМАНИЕ:
@echo.
@echo    IP адрес компьютера:		[ %ipaddrtxt% 	]
@echo    IP адрес гарнитуры:		[ %iphs% 	]
@echo.
@echo    IP адрес компьютера определяется автоматически, проверьте его правильность. 
@echo    Если IP адрес не соответствует вашей сетевой карте, выйдите из программы 
@echo    и укажите его в файле ipaddr.txt, только что созданном рядом с программой.
@echo.
@echo    Для проверки требуется подсоединенный к ПК и шлему USB кабель,
@echo    а также включенный Режим разработчика.
@echo.
@echo    После запуска введите количество одновременных потоков,
@echo    или просто нажмите Enter для одного потока по умолчанию.
@echo    Задайте интервал между проверками в миллисекундах:
@echo    Минимальное значение интервала - 100, по умолчанию - 1000 (1 секунда)
@echo    Также введите длительность проверки в секундах.По умолчанию - 10 секунд
@echo    Запустится сервер на ПК и клиент в шлеме,по завершении тестов оба окна закроются.
@echo.      
@echo    Будет проведено два теста: прямой и реверсивный.
@echo    Прямой тест - от шлема к ПК, реверсивный - от ПК к шлему.
@echo    После завершения тестов рядом с программой появится лог-файл с именем
@echo    WiFiConnectTest.txt. В нем будут записаны результаты тестов. 
@echo.
@echo    Если программа по какой-то причине отказывается работать
@echo    и вылетает, смотрите текст ошибки в файле error.txt
:_eng34
@echo             - thank you user "satspace" for the advice - 
call :_hatmenu
@echo.
@echo    S.  Run Wi-Fi speed test  [EXP]
@echo.
rem @echo.
@echo.
@echo  NOTE:
@echo.
@echo    Computer IP address:		[ %ipaddrtxt% 	]
@echo    Headset IP address:		[ %iphs% 	]
@echo.
@echo    The computer IP address is determined automatically, please check its correctness.
@echo    If the IP address does not match your network card, exit the program
@echo    and specify it in the ipaddr.txt file, which was just created next to the program.
@echo.
@echo    For the test, a USB cable connected to the PC and the headset is required,
@echo    as well as the Developer Mode turned on.
@echo.
@echo    After starting, enter the number of simultaneous threads,
@echo    or simply press Enter for one thread by default.
@echo    Set the interval between checks in milliseconds:
@echo    The minimum interval value is 100, by default - 1000 (1 second)
@echo    Also enter the duration of the check in seconds. By default - 10 seconds
@echo    The server will start on the PC and the client in the headset, both windows will close after the tests are completed.
@echo.      
@echo    Two tests will be conducted: direct and reverse.
@echo    Direct test - from the headset to the PC, reverse - from the PC to the headset.
@echo    After completing the tests, a log file named
@echo    WiFiConnectTest.txt will appear next to the program. The results of the tests will be recorded in it.
@echo.
@echo    If the program for some reason refuses to work
@echo    and crashes, see the error text in the error.txt file
@echo.
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _iperftest
if "%choice%"=="0" (exit)
if /i "%choice%"=="m" (GOTO _beginn)
if /i "%choice%"=="s" (GOTO _iperftestrun)
cls
goto _iperftest

:_iperftestrun
call :_cdc
@echo off & setlocal ENABLEEXTENSIONS
@call :_GetIP ipaddr
if not exist ipaddr.txt call :_CreateIPaddressTxt
call :_ExtractIPaddress
set iinterval=
rem @set /p iinterval="Введите интервал в миллисекундах и нажмите Enter: "
@set /p iinterval="Enter the interval in milliseconds and press Enter (0 - Exit) : "
if [%iinterval%]==[] set iinterval=1000
if %iinterval%==0 goto _iperftest
call :_Division
@echo.
@set qstreams=
rem @set /p qstreams="Введите количество потоков и нажмите Enter: "
@set /p qstreams="Enter the number of streams and press Enter (0 - Exit) : "
if [%qstreams%]==[] set qstreams=1
if %qstreams%==0 goto _iperftest
@echo.
set itime=
rem @set /p itime="Введите длительность проверки в секундах и нажмите Enter: "
@set /p itime="Enter the duration of the check in seconds and press Enter (0 - Exit) : "
if [%itime%]==[] set itime=10
if %itime%==0 goto _iperftest
@echo.
call :_settime
set wfclog=WiFiConnectTest
set wfclogdt=%wfclog%-%dt%.txt
@echo ------------------------------------------------------
rem @echo В окне сервера можно наблюдать процесс тестирования.
rem @echo По завершению тестов окно сервера будет закрыто
rem @echo.
rem @echo  Результаты будут сохраненые в файле WiFiConnectTest.txt
@echo In the server window, you can observe the testing process.
@echo After the tests are completed, the server window will be closed.
@echo.
@echo The results will be saved in the file WiFiConnectTest.txt.
@echo.
%MYFILES%\adb push %MYFILES%\iperf3.9 /data/local/tmp 1>nul 2>error.txt
%MYFILES%\adb shell chmod +x /data/local/tmp/iperf3.9 1>nul 2>error.txt
if %errorlevel% == 1 goto _iperferror
@start " " %MYFILES%\iperf3.exe -s
@ping localhost -n 1 1>nul 2>nul
@echo. >%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
rem @echo   Дата проверки	: %dppt%>>%wfclogdt%
@echo  Data of check	: %dppt%>>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
rem @echo +   Измерение пропускной способности Wi-Fi   + >>%wfclogdt%
rem @echo +           между шлемом и ПК                + >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo. >>%wfclogdt%
rem @echo ---------------------------------------------- >>%wfclogdt%
rem @echo  ===   Обычная проверка (от шлема к ПК)   === >>%wfclogdt%
@echo +   Measuring Wi-Fi throughput   + >>%wfclogdt%
@echo +        between the headset and PC       + >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo. >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo  ===   Regular check (from headset to PC)   === >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo. >>%wfclogdt%
%MYFILES%\adb shell /data/local/tmp/iperf3.9 -t %itime% -i %iinterval% -c %ipaddrtxt% -P %qstreams% >> %wfclogdt% 2>error.txt
if %errorlevel% == 1 goto _iperferror
rem pause
@echo. >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
rem @echo  === Реверсивная проверка (от ПК к шлему) === >>%wfclogdt%
@echo  === Reverse check (from PC to headset) === >>%wfclogdt%
@echo ---------------------------------------------- >>%wfclogdt%
@echo. >>%wfclogdt%
%MYFILES%\adb shell /data/local/tmp/iperf3.9 -t %itime% -i %iinterval% -c %ipaddrtxt% -P %qstreams% -R >> %wfclogdt% 2>error.txt
if %errorlevel% == 1 goto _iperferror
@taskkill /F /IM iperf3.exe 1>nul 2>nul
for %%A IN (%cd%\error.txt) DO (
 if %%~zA EQU 0 (del %%A)
)
%MYFILES%\adb shell rm /data/local/tmp/iperf3.9 1>nul 2>nul
goto _iperftest

:_ExtractIPaddress
@For /F "skip=1 tokens=1" %%a In (%cd%\ipaddr.txt) Do (
@set ipaddrtxt=%%a
)
exit /b

:_CreateIPaddressTxt
@echo IP address of your computer will be taken from this file >ipaddr.txt
@echo %ipaddr% >>ipaddr.txt
::@echo резерв >>settings.txt
::@echo Четвертая строка >>settings.txt
exit /b

:_GetIP ipaddr
@setlocal ENABLEEXTENSIONS & set "i=0.0.0.0" & set "j="
@for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
  if not defined j for %%b in (%%a) do set "i=%%b" & set "j=1")
endlocal & set "%1=%i%"
exit /b

:_iperferror
@taskkill /F /IM iperf3.exe 1>nul 2>nul
@echo.
@echo ------------------------------------------------
@echo.
rem @echo     +++++++ Ошибка! +++++++
@echo     +++++++ Error! +++++++
@echo.
@echo.
rem @echo Текст ошибки сохранен в файле error.txt
@echo The error text is saved in the error.txt file
@echo.
goto _exitout

:_IPaddrEmpty
@echo.
@echo ------------------------------------------------
@echo.
rem @echo     +++++++ Ошибка! +++++++
@echo     +++++++ Error! +++++++
@echo.
@echo.
rem @echo  Не удалось определить IP адрес. 
rem @echo  Пожалуйста, пропишите его вручную в файл ipaddr.txt во второй строчке.
rem @echo  Файл лежит рядом с программой.
@echo Failed to determine the IP address.
@echo Please manually enter it into the ipaddr.txt file on the second line.
@echo The file is located next to the program.
@echo.
goto _exitout

:_HeadsetIP
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|find "inet "') DO set ipfull=%%G
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO set iphs=%%G
@if [%iphs%]==[] goto _noip
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
rem Echo %nC%%nD%
set iinterval=%nC%%nD%
exit /b

::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


:_shownetstat
call :_hat
::call :_hatmenu
@echo.
rem @echo    Состояние соединений:
rem @echo.
rem @echo  LISTENING	Ожидает входящих соединений.
rem @echo  SYN_SENT	Активно пытается установить соединение.
rem @echo  SYN_RECEIVED	Идет начальная синхронизация соединения.
rem @echo  ESTABLISHED	Соединение установлено.
rem @echo  CLOSE_WAIT	Удаленная сторона отключилась; ожидание закрытия сокета.
rem @echo  FIN_WAIT_1	Сокет закрыт; отключение соединения.
rem @echo  CLOSING	Сокет закрыт, затем удаленная сторона отключилась; ожидание подтверждения.
rem @echo  LAST_ACK	Удаленная сторона отключилась, затем сокет закрыт; ожидание подтверждения.
rem @echo  FIN_WAIT_2	Сокет закрыт; ожидание отключения удаленной стороны.
rem @echo  TIME_WAIT	Сокет закрыт, но ожидает пакеты, ещё находящиеся в сети для обработки
@echo    Connection states:
@echo.
@echo  LISTENING     Waiting for incoming connections.
@echo  SYN_SENT      Actively trying to establish a connection.
@echo  SYN_RECEIVED  Initial connection synchronization.
@echo  ESTABLISHED   Connection established.
@echo  CLOSE_WAIT    Remote side has closed the connection; waiting for socket closure.
@echo  FIN_WAIT_1    Socket closed; disconnecting.
@echo  CLOSING       Socket closed, then remote side disconnected; waiting for confirmation.
@echo  LAST_ACK      Remote side disconnected, then socket closed; waiting for confirmation.
@echo  FIN_WAIT_2    Socket closed; waiting for remote side to disconnect.
@echo  TIME_WAIT     Socket closed, but waiting for packets still in the network to be processed
@echo  ----------------------------------------------------------------------------------------
@echo.
@%MYFILES%\adb shell netstat -tuw
call :_erlvl
@set "choice=1"
@echo.
@echo.
::@echo.
rem @Set /p choice="Для обновления статистики нажмите Enter (Выход в меню - 0): "
@Set /p choice="To update statistics, press Enter (Exit to the menu - 0): "
if not defined choice goto _iperftest
if "%choice%"=="0" (goto _beginn)
if "%choice%"=="1" (GOTO _shownetstat)
goto _shownetstat

:_shownetstatpc
call :_hat
::call :_hatmenu
@echo.
rem @echo    Состояние соединений:
rem @echo.
rem @echo  LISTENING	Ожидает входящих соединений.
rem @echo  SYN_SENT	Активно пытается установить соединение.
rem @echo  SYN_RECEIVED	Идет начальная синхронизация соединения.
rem @echo  ESTABLISHED	Соединение установлено.
rem @echo  CLOSE_WAIT	Удаленная сторона отключилась; ожидание закрытия сокета.
rem @echo  FIN_WAIT_1	Сокет закрыт; отключение соединения.
rem @echo  CLOSING	Сокет закрыт, затем удаленная сторона отключилась; ожидание подтверждения.
rem @echo  LAST_ACK	Удаленная сторона отключилась, затем сокет закрыт; ожидание подтверждения.
rem @echo  FIN_WAIT_2	Сокет закрыт; ожидание отключения удаленной стороны.
rem @echo  TIME_WAIT	Сокет закрыт, но ожидает пакеты, ещё находящиеся в сети для обработки
@echo    Connection states:
@echo.
@echo  LISTENING     Waiting for incoming connections.
@echo  SYN_SENT      Actively trying to establish a connection.
@echo  SYN_RECEIVED  Initial connection synchronization.
@echo  ESTABLISHED   Connection established.
@echo  CLOSE_WAIT    Remote side has closed the connection; waiting for socket closure.
@echo  FIN_WAIT_1    Socket closed; disconnecting.
@echo  CLOSING       Socket closed, then remote side disconnected; waiting for confirmation.
@echo  LAST_ACK      Remote side disconnected, then socket closed; waiting for confirmation.
@echo  FIN_WAIT_2    Socket closed; waiting for remote side to disconnect.
@echo  TIME_WAIT     Socket closed, but waiting for packets still in the network to be processed
@echo  ----------------------------------------------------------------------------------------
@echo.
rem :_netstatupdate
@netstat -f
rem @set "choice=1"
@echo.
@echo.
::@echo.
@echo ^>^>^> Press any key to interrupt ^<^<^<
rem timeout %intscrn%| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & @goto _returnmenu
timeout 5| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure was interrupted +++ ^ & @echo. ^ & @goto _returnmenu
rem @Set /p choice="Для обновления статистики нажмите Enter (Выход в меню - 0): "
rem @Set /p choice="To update statistics, press Enter (Exit to the menu - 0): "
rem if not defined choice goto _iperftest
rem if "%choice%"=="0" (goto _beginn)
rem if "%choice%"=="1" (GOTO _shownetstat)
goto _shownetstatpc



:_camtest
call :_cdc
@Echo Off
call :_hat
SetLocal EnableExtensions EnableDelayedExpansion
@echo.
@echo.
rem @echo  Исправность камер можно определить по значению температуры. 
rem @echo  Их расположение условно обозначено "изнутри", то есть
rem @echo  со стороны линз, будто шлем надет:
@echo  The condition of the cameras can be determined by the temperature value.
@echo  Their location is conventionally designated "from the inside", meaning
@echo  from the side of the lenses, as if the headset is worn:
@echo.
@echo.
@echo          ЛВ                    ПВ
@echo.   
@echo          ^(^)-------=====--------^(^)
@echo          /                      \
@echo          ^|    ***       ***     ^|
@echo          ^|   *****     *****    ^|
@echo          ^|    ***       ***     ^|
@echo          ^|                      ^|
@echo          \_^(^)_____/---\_____^(^)_/
@echo.
@echo            ЛН               ПН
@echo.
@echo.
rem @echo    Температура камер:
@echo    Camera temperatures:
@echo.
For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone68/temp') Do Set rdcam=%%~I
::@Echo Правая нижняя:  !rdcam! >>cam.txt
set /a ardcam=!rdcam!/1000
rem @echo  Правая нижняя:  %ardcam%.!rdcam:~-3!°
@echo  Bottom right camera:  %ardcam%.!rdcam:~-3!°

For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone69/temp') Do Set ldcam=%%~I
::@Echo Левая нижняя:   !ldcam! >>cam.txt
set /a aldcam=!ldcam!/1000
rem @echo  Левая нижняя:   %aldcam%.!rdcam:~-3!°
@echo  Bottom left camera:   %aldcam%.!rdcam:~-3!°
@echo.
For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone70/temp') Do Set lucam=%%~I
::@Echo Левая верхняя:  !lucam! >>cam.txt
set /a alucam=!lucam!/1000
rem @echo  Левая верхняя:  %alucam%.!lucam:~-3!°
@echo  Top left camera:  %alucam%.!lucam:~-3!°

For /F "Delims=" %%I In ('%MYFILES%\adb shell cat /sys/class/thermal/thermal_zone71/temp') Do Set rucam=%%~I
::@Echo Правая верхняя: !rucam! >>cam.txt
set /a arucam=!rucam!/1000
rem @echo  Правая верхняя: %arucam%.!rucam:~-3!°
@echo  Top right camera: %arucam%.!rucam:~-3!°
@echo.
@echo ------------------------------------------------
rem @echo  Значительные отличия в показаниях (на градус и больше)
rem @echo  означают вероятную неисправность определенной камеры,
rem @echo  поскольку при работе исправная камера хоть чуть-чуть,
rem @echo  но нагревается, а неисправная - нет.
rem @echo.
rem @echo  На разницу температур между верхними и нижними камерами
rem @echo  не обращайте внимания, она может отличаться на градус или два.
rem @echo  Имеет смысл сравнивать между собой только нижние или верхние камеры.
rem @echo.
rem @echo   ...через 10 секунд показания обновятся...
rem @echo.
rem @echo  Для прерывания и выхода в меню нажмите любую кнопку
@echo  Substantial differences in readings (by a degree or more)
@echo  may indicate a possible malfunction of a specific camera,
@echo  as a functioning camera, however slightly,
@echo  heats up, whereas a malfunctioning one does not.
@echo.
@echo  Do not pay attention to the temperature difference
@echo  between the top and bottom cameras, it can differ by a degree or two.
@echo  It makes sense to compare only the bottom or top cameras.
@echo.
@echo   ...the readings will be updated in 10 seconds...
@echo.
@echo  To interrupt and return to the menu, press any key
@echo.
rem timeout 10| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Процедура прервана +++ ^ & @echo. ^ & call :_prevmenu & @goto _syscommenu
timeout 10| >nul findstr/e [^^0-9]0 ||  @echo ============================================== ^ & @echo        +++ Procedure interrupted +++ ^ & @echo. ^ & call :_prevmenu & @goto _syscommenu
goto _camtest

:_adblogcat
call :_settime
call :_hat
call :_hatmenu
@echo.
rem @echo    A.  Logcat: последние 5 тысяч строк
rem @echo    B.  Logcat: последние 10 тысяч строк
rem @echo    C.  Logcat: количество строк вручную
rem @echo    D.  Logcat: последние 5 минут
rem @echo    E.  Logcat: последние 10 минут
rem @echo    F.  Logcat: количество минут вручную
rem @echo    G.  Logcat: безлимит [ Откроется в отдельном окне ]
rem @echo    H.  Очистить Logcat
rem @echo    I.  Весь журнал
rem @echo    J.  Поиск по logcat [ Откроется в отдельном окне ]
@echo    A.  Logcat: last 5 thousand lines
@echo    B.  Logcat: last 10 thousand lines
@echo    C.  Logcat: number of lines manually
@echo    D.  Logcat: last 5 minutes
@echo    E.  Logcat: last 10 minutes
@echo    F.  Logcat: number of minutes manually
@echo    G.  Logcat: unlimited [ Will open in a separate window ]
@echo    H.  Clear Logcat
@echo    I.  Entire Log
@echo    J.  Search in logcat [ Will open in a separate window ]

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
rem @echo Файл сохранен в текущий каталог с именем lc-5k-%dt%.txt
@echo File saved in the current directory with the name lc-5k-%dt%.txt
call :_prevmenu
goto _adblogcat


:_lctenstr
@set qstr=10000
@%myfiles%\adb logcat -t "%qstr%" >lc-10k-%dt%.txt
call :_erlvl
@echo =====================================================
rem @echo Файл сохранен в текущий каталог с именем lc-10k-%dt%.txt
@echo File saved in the current directory with the name lc-10k-%dt%.txt
call :_prevmenu
goto _adblogcat

:_lccustomstr
@Set /p custstr="Введите количество строк (в тысячах) нажмите Enter: "
@set /a qstr=custstr*1000
@%myfiles%\adb logcat -t "%qstr%" >lc-%custstr%k-%dt%.txt
call :_erlvl
@echo =====================================================
rem @echo Файл сохранен в текущий каталог с именем lc-%custstr%k-%dt%.txt
@echo File saved in the current directory with the name lc-%custstr%k-%dt%.txt
call :_prevmenu
goto _adblogcat

:_lcfivemin
@set etime=300
@call :_timefunction
@call :_settime
@%myfiles%\adb logcat -t "%odt% %lctime%" >lc-5min-%dt%.txt
call :_erlvl
@echo =====================================================
rem @echo Файл сохранен в текущий каталог с именем lc-5min-%dt%.txt
@echo File saved in the current directory with the name lc-5min-%dt%.txt
call :_prevmenu
goto _adblogcat

:_lctenmin
@set etime=600
@call :_timefunction
@call :_settime
@%myfiles%\adb logcat -t "%odt% %lctime%" >lc-10min-%dt%.txt
call :_erlvl
@echo =====================================================
rem @echo Файл сохранен в текущий каталог с именем lc-10min-%dt%.txt
@echo File saved in the current directory with the name lc-10min-%dt%.txt
call :_prevmenu
goto _adblogcat

:_lccustommin
@set etime=600
rem @Set /p mintime="Введите количество минут нажмите Enter: "
@Set /p mintime="Enter the number of minutes and press Enter: "
@set /a etime=mintime*60
@call :_timefunction
@call :_settime
@%myfiles%\adb logcat -t "%odt% %lctime%" >lc-%mintime%min-%dt%.txt
call :_erlvl
@echo =====================================================
rem @echo Файл сохранен в текущий каталог с именем lc-%mintime%min-%dt%.txt
@echo The file is saved in the current directory with the name lc-%mintime%min-%dt%.txt
call :_prevmenu
goto _adblogcat

:_lcunlimit
@start cmd /c "%MYFILES%\adb logcat >lc-unlim-%dt%.txt"
@echo =====================================================
rem @echo Как только надоест ждать - закройте второе окно.
rem @echo Файл с логами будет сохранен с именем lc-unlim-%dt%.txt"
@echo As soon as you are tired of waiting - close the second window.
@echo The log file will be saved with the name lc-unlim-%dt%.txt
call :_prevmenu
goto _adblogcat

:_lcclear
@%myfiles%\adb logcat -c 1>nul 2>nul
call :_erlvl
@echo =====================================================
@echo Logcat очищен.
call :_prevmenu
goto _adblogcat

:_adblogcatd
@%myfiles%\adb logcat -d >lc-all-%dt%.txt
call :_erlvl
@echo =====================================================
rem @echo Файл сохранен в текущий каталог с именем lc-all-%dt%.txt
@echo The file is saved in the current directory under the name lc-all-%dt%.txt
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
rem @echo   Будет запущен logcat с поиском введенного слова 
rem @echo.
rem @echo   Если передумали, введите 0 и нажмите Enter
rem @echo   для возврата в предыдущее меню.
@echo   Logcat will be started with the search for the entered word
@echo.
@echo   If you have changed your mind, enter 0 and press Enter
@echo   to return to the previous menu.
@echo.
@echo.
@echo.
@echo.
rem @Set /p lcsrch=" Bведите слово для выборки и нажмите Enter: "
@Set /p lcsrch="Enter the word for search and press Enter: "
if %lcsrch%==0 goto _adblogcat
@echo ================================
rem @echo Идет поиск....
rem @echo.
rem @echo Для завершения просто закройте второе окно консоли
@echo Searching....
@echo.
@echo To finish, simply close the second console window
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
::Echo Time                  = [%HH%:%MM%:%SS%]
@Call :SerializeTime
@Set TmpTime=%ErrorLevel%
::Echo Serialized time       =  %TmpTime%
@Call :DeserializeTime %TmpTime%
::Echo Deserialized time     = [%DHH%:%DMM%:%DSS%]
@Call :TMinus %TmpTime% %etime%
@Call :DeserializeTime %ErrorLevel%
::Echo Time - 2:30:14        = [%DHH%:%DMM%:%DSS%]
@set lctime=%DHH%:%DMM%:%DSS%.000
@Call :TPlus %TmpTime% 9014
@Call :DeserializeTime %ErrorLevel%
::Echo Time + 2:30:14        = [%DHH%:%DMM%:%DSS%]
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

:_SETTIME
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
::@echo %dt%
@exit /b

:_OFFLINE
@echo.
rem @echo  Шлем в режиме offline!
rem @echo  Пробуем устранить проблему...
@echo  Headset in offline mode!
@echo  Trying to solve the problem...
@%MYFILES%\adb kill-server
@%MYFILES%\adb start-server 1>nul 2>nul
call :_cdc
rem @%MYFILES%\adb devices | findstr 1WM 1>nul 2>nul
@If %ERRORLEVEL% EQU 1 GOTO _NOTFOUND
@%MYFILES%\adb devices | find "offline" 1>nul 2>nul
@If %ERRORLEVEL%==0 GOTO _OFFLINEISSUE
@echo ========================================
rem @echo  Проблема устранена.
@echo  Problem solved.
@goto _returnmenu

:_NOTAUTORIZED
cls
call :_hat
@echo.
@echo.
@echo.
rem @echo     ++++ Шлем не авторизован! ++++
@echo     ++++ Headset not authorized! ++++
@echo.
@echo.
@echo.
rem @echo Наденьте гарнитуру и нажмите
rem @echo [ Всегда разрешать для этого компьютера ]
rem @echo Затем перезапустите эту программу
@echo Please put on the headset and click
@echo [ Always allow for this computer ]
@echo Then restart this program
@goto _exitout

:_OFFLINEISSUE
@echo ========================================
rem @echo  Устранить ошибку не удалось. 
rem @echo  Переподключите кабель и запустите программу снова
@echo The error could not be fixed.
@echo Reconnect the cable and restart the program again
@goto _exitout

:_NoDevice
call :_hat
::@%MYFILES%\adb devices 2>NUL | findstr sideload 1>nul 2>nul
::@If %ERRORLEVEL% EQU 0 GOTO _sideloadmode
@echo.
@echo.
@echo.
rem @echo     ++++ Шлем не обнаружен! +++++
@echo ++++ The headset is not detected! ++++
@echo.
@echo.
@echo.
rem @echo  Проверьте кабельное соединение и правильность установки драйверов.
rem @echo  Затем перезапустите эту программу снова.
@echo Check the cable connection and driver installation.
@echo Then restart this program again.
@goto _RunMenuNoDevice

:_NOTFOUND
@echo.
@echo.
@echo.
rem @echo     +++++ Шлем не найден +++++
@echo     +++++ Headset not found +++++
@echo.
@echo.
@echo.
rem @echo  Проверьте кабельное соединение и правильность установки драйверов.
rem @echo  Затем перезапустите эту программу снова.
@echo     +++++ Check the cable connection and correct driver installation. +++++
@echo     +++++ Then restart this program again. +++++
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
@goto _exitout

:_returnmenu
@echo.
rem @echo ^>^>^> Нажмите любую кнопку для возврата в Главное меню ^<^<^<
@echo ^>^>^> Press any key to return to the Main menu ^<^<^<
@pause >nul
@cls
goto _beginn

:_exitout
@echo.
rem @echo ^>^>^> Нажмите любую кнопку для выхода из программы ^<^<^<
@echo ^>^>^> Press any key to exit the program ^<^<^<
@pause >nul
@exit

:_prevmenu
@echo ----------------------------------------------------------------
@echo.
rem @echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
@echo ^>^>^> Press any key to return to the previous menu ^<^<^<
@pause 1>nul 2>nul
exit /b


:_noadb
cls
call :_hat
@echo.
@echo.
@echo.
rem @echo     +++++ Шлем найден, но Режим разработчика не включен! +++++
@echo     +++++ Headset found, but Developer Mode is not enabled! +++++
@echo.
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
rem @echo              +++ Ошибка, что-то пошло не так +++
rem @echo  На всякий случай проверьте соединение со шлемом и Режим разработчика 
@echo              +++ Error, something went wrong +++
@echo  Check the connection to the headset and the Developer Mode just in case
@echo =====================================================================
goto _returnmenu
:_erlvlnot
exit /b
goto _returnmenu

:_loadfwerror
@echo.
@echo.
@echo.
rem @echo     +++++ Не удалось загрузить прошивку! +++++
@echo     +++++ Firmware failed to load! +++++
@echo.
@echo.
@echo.
rem @echo  Проверьте кабельное соединение, 
rem @echo  правильность установки драйверов
rem @echo  и режим шлема (пункт 4 в Главном меню)
rem @echo  Затем перезапустите эту программу снова.
@echo     +++++ Check the cable connection, 
@echo     driver installation correctness
@echo     and the headset mode (item 4 in the Main menu)
@echo     Then restart this program again.
@echo.
@taskkill /IM adb.exe /F 2>nul 1>nul
@goto _exitout

:_RunMenuNoDevice
@echo.
rem @echo   Тем не менее, вы можете запустить программу,
rem @echo   но некоторые функции работать не будут.
rem @echo   В этом случае вы увидите сообщение
rem @echo.
rem @echo   "adb.exe: no devices/emulators found" 
rem @echo     или 
rem @echo   "Ошибка. Проверьте соединение со шлемом"
@echo     +++++ However, you can run the program,
@echo     but some features will not work.
@echo     In this case you will see the message
@echo.
@echo     "adb.exe: no devices/emulators found" 
@echo     or 
@echo     "Error. Check the connection to the headset"
@echo ---------------------------------------------------
@echo.
rem @echo  Как поступим?
rem @echo.
rem @echo     0.  Выход из программы
rem @echo     S.  Запустить без информационной таблицы
rem @echo     T.  Запустить с таблицей
rem @echo     D.  Открыть Диспетчер устройств
@echo  What should we do?
@echo.
@echo     0.  Exit the program
@echo     S.  Run without information table
@echo     T.  Run with table
@echo     D.  Open Device Manager
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _NoDevice
if "%choice%"=="0" (goto _tk)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
if "%choice%"=="D" (start mmc.exe devmgmt.msc)
if "%choice%"=="d" (start mmc.exe devmgmt.msc)
@cls
goto :_NoDevice
rem goto _RunMenuNoDevice

:_DoubleConnect
cls
call :_hat
@echo.
@echo.
@echo.
rem @echo     ++++ Двойное подключение! ++++
@echo     ++++ Double connection! ++++
@echo.
@echo.
@echo.
rem @echo  Шлем подключен по кабелю и Wi-Fi одновременно.
rem @echo  Это может вызвать ошибку "error: more than one device/emulator" 
rem @echo. Лучше оставить какое-нибудь одно из подключений.
rem @echo.
rem @echo   Тем не менее, вы можете запустить программу,
rem @echo   но некоторые функции работать не будут.
@echo  The headset is connected via cable and Wi-Fi at the same time.
@echo  This can cause the error "error: more than one device/emulator"
@echo. It is better to leave just one of the connections.
@echo.
@echo   Nevertheless, you can run the program,
@echo   but some functions will not work.
@echo ---------------------------------------------------
@echo.
rem @echo  Как поступим?
rem @echo.
rem @echo     0.  Выход из программы
rem @echo     S.  Запустить без информационной таблицы
rem @echo     T.  Запустить с таблицей
rem @echo     R.  Отключить соединение ADB по WiFi
@echo  What will we do?
@echo.
@echo     0.  Exit the program
@echo     S.  Start without the information table
@echo     T.  Start with the table
@echo     R.  Disconnect the ADB connection via WiFi
@echo.
call :_MenuChoiceEnter
@echo.
if not defined choice goto _RunMenuNoDevice
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
if /i "%choice%"=="r" (goto _reconnect)
cls
goto _RunMenuNoDevice

:_WiFiConnected
::goto _tabBegin
cls
call :_hat
@echo.
@echo.
@echo.
rem @echo     +++ Шлем подключен по WiFi +++
@echo     +++ Headset connected via WiFi +++
@echo.
@echo.
@echo.  
rem @echo  Взаимодествие со шлемом по WiFi не гарантирует
rem @echo  полную работоспособность программы.
rem @echo.
rem @echo  Могут не работать или работать неправильно
rem @echo  некоторые функции.
@echo  Interaction with the headset via WiFi does not guarantee
@echo  the full functionality of the program.
@echo.
@echo  Some functions may not work or work incorrectly.
@echo ---------------------------------------------------
@echo.
rem @echo  Как поступим?
rem @echo.
rem @echo     0.  Выход из программы
rem @echo     S.  Запустить без информационной таблицы
rem @echo     T.  Запустить с таблицей
rem @echo.
rem @echo   По нажатию Enter программа запустится без таблицы.
@echo  What will we do?
@echo.
@echo     0.  Exit from the program
@echo     S.  Run without an information table
@echo     T.  Run with a table
@echo.
@echo   Press Enter to start the program without a table.
@echo.
@set "choice=s"
call :_MenuChoiceEnterDef
@echo.
if not defined choice goto _WiFiConnected
if "%choice%"=="0" (exit)
if /i "%choice%"=="s" (GOTO _beginn)
if /i "%choice%"=="t" (GOTO _tabBegin)
::if /i "%choice%"=="s" (exit /b)
cls
goto _WiFiConnected

:_tabGeneral
@echo off
@SetLocal EnableDelayedExpansion

:_tabSizeCheck
@For /F "skip=1 tokens=2,3,4,5" %%a In ('%MYFILES%\adb shell df -h /sdcard/') Do (
cls
@set aa=%%a
@set bb=%%b
@set cc=%%c
@set dd=%%d
set sz=Гб
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
@For /F %%r In ('%MYFILES%\adb shell getprop ro.boot.serialno') Do set sn=%%r
cls
::set sn=
if [%sn%]==[] set sn=---------------------

:_tebDatetime
@For /F %%q In ('@%MYFILES%\adb shell date +"%%Y.%%m.%%d-%%H:%%M:%%S"') Do set qdt=%%q
cls
::set qdt=
if [%qdt%]==[] set qdt=---------------------

:_tabIP
@FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb.exe shell ip addr show wlan0 ^|find "inet "') DO set ipfull=%%G
cls
@FOR /F "tokens=1 delims=/" %%G in ("%ipfull%") DO set ip=%%G

@if [%ip%]==[] set ip=-------------

:_tabConnectType
@set /a connectsum=%cablecheck%+%wificheck%
@IF %connectsum% EQU 2 set connecttype=Double & goto _tabFWdltable
@%MYFILES%\adb devices 2>NUL | findstr offline 2>nul 1>nul
@IF %errorlevel% EQU 0 set connecttype=Offline & goto _tabFWdltable
@%MYFILES%\adb devices 2>NUL | findstr ":" 2>nul 1>nul
@IF %errorlevel% EQU 0 set connecttype=Wi-Fi & goto _tabFWdltable

@FOR /F "skip=1 tokens=1" %%j IN ('%MYFILES%\adb devices') DO set sernum=%%j
cls
@if [%sernum%] NEQ [] set connecttype=Cable & goto _tabFWdltable

@set connecttype=-----

:_tabFWdltable
:_ExtractFirmwareVersion
@echo.
rem @echo Секунду, подготавливаем табличку....
@echo  Wait a second, preparing the table....
call :_hsfwversionextract
if [%hsversion%]==[] (set fwnumb=-------------) else (set fwnumb=%hsversion%)
if [%hsenvironment%]==[] (set fwsys=---------------------) else (set fwsys=%hsenvironment%)

:_teabCheckAdmin
@reg query "HKU\S-1-5-19" >NUL 2>&1 && (set adminaccess=Of coz) || (set adminaccess=Not this time)
call :_BatteryStatsCheck
call :_setfwtxt
call :_UpdateStatus
call :_hat
rem @echo  Дата в шлеме	: %qdt%	^| Общий объем : !aa:~,-1!!sz!	^| Емкость акк.	: %opcouprom%%mahh%
rem @echo  Серийный номер	: %sn%	^| Занято      : !bb:~,-1!!sz!	^| Потеряно емк.	: %izgcou%%mahh%
rem @echo  Верcия системы	: %fwsys%	^| Свободно    : !cc:~,-1!!sz!	^| Деградация	: %degostcou%%pr%
rem @echo  Прошивка	: %fwnumb%		^| Заполнено   : !dd!	^| Заряд		: %batlevel%%pr%
rem @echo  IP шлема	: %ip%     	^| Подключение : %connecttype%	^| От админа?	: %adminaccess%
rem @echo  Модель шлема	: %DevModelNm%   	^| = резерв =  :		^| Обновления    : %updstatus%
@echo  Headset date	: %qdt%	^| Total volume	: !aa:~,-1!!sz!	^| Battery capacity	: %opcouprom%%mahh%
@echo  Serial number	: %sn%	^| Occupied      : !bb:~,-1!!sz!	^| Lost capacity		: %izgcou%%mahh%
@echo  System version	: %fwsys%	^| Free space    : !cc:~,-1!!sz!	^| Degradation		: %degostcou%%pr%
@echo  FW version	: %fwnumb%		^| Filled        : !dd!	^| Charge		: %batlevel%%pr%
@echo  Headset IP	: %ip%     	^| Connection    : %connecttype%^| From admin?		: %adminaccess%
@echo  Headset model	: %DevModelNm%  	^| = reserved =  :	^| Updates         	: %updstatus%

@echo --------------------------------------------------------------------------------------------------
@exit /b

:_UpdateStatus
%myfiles%\adb shell pm list packages -d 2>&1 | find /i "com.oculus.updater" 2>nul 1>nul
rem echo %DevModelNm%
rem if %errorlevel%==1 (set updstatus=Включены) else (set updstatus=Отключены)
if %errorlevel%==1 (set updstatus=Enabled) else (set updstatus=Disabled)
if %sn%==--------------------- set updstatus=-------- && exit /b
exit /b

rem :_tabModel
call :_setfwtxt
rem exit /b

if %ERRORLEVEL% EQU 1 set uknownmodel=1
rem set model=Неизвестно
set model=Unknown
@exit /b

:_CheckAllMode

:_CheckCableMode
@echo off
@%MYFILES%\devcon_x64 find *VID_2833* | find /I "XRSP" 1>nul 2>nul
@IF %ERRORLEVEL% EQU 0 (
@set /A cablecheck=1 
) else (
@set /A cablecheck=0
)
@exit /b

:_CheckWiFiMode
@echo off
@%MYFILES%\adb devices 2>NUL | findstr ":" 2>nul 1>nul
@IF %ERRORLEVEL% EQU 0 (
@set /A wificheck=1
) else (
@set /A wificheck=0
)
@exit /b

:_CheckDoubleOrNoDeviceMode
@echo off
@set /a connectsum=%cablecheck%+%wificheck%
@IF %wificheck% GTR %cablecheck% goto _WiFiConnected
@IF %connectsum% EQU 2 call :_DoubleConnect
@IF %connectsum% EQU 0 goto _NoDevice
@exit /b

:_CheckDevMode
@echo off
@%MYFILES%\devcon_x64 find *VID_2833* | find /I "ADB" 1>nul 2>nul
IF %wificheck%==1 exit /b
@IF %ERRORLEVEL% EQU 0 (
@set /A adbcheck=1 
) else (
@set /A adbcheck=0
@call :_noadb
)
@exit /b

:_CheckAfterWiFiCheckMode
:_CheckAutorization
@echo off
@%MYFILES%\adb devices 2>NUL | find "unauthorized" 1>NUL 2>nul
@IF %ERRORLEVEL% EQU 0 (
@set /A autorizecheck=1 
goto _notautorized
) else (
@set /A autorizecheck=0
)
@exit /b

:_CheckSideloadMode
@echo off
@%MYFILES%\adb devices | find "sideload" 1>nul 2>nul
@IF %ERRORLEVEL% EQU 0 (
set /A sideloadcheck=1 
@goto _sideloadmode
) else (
@set /A sideloadcheck=0
)
@exit /b

:_CheckBootloaderMode
@%MYFILES%\fastboot devices | find "fastboot" 1>nul 2>nul
@If %ERRORLEVEL%==0 (
set bl=1
goto _bootloadermode
)
exit /b


:::_NotSupported
::call :_hat
::@echo.
::@echo.
::@echo.
::@echo  +++ Устройство на поддерживается! +++
::@echo.
::@echo.
::@echo.  
::@echo.
::@echo   Тем не менее, вы можете запустить программу,
::@echo   но некоторые функции работать не будут.
::@echo   В этом случае вы увидите сообщение
::@echo   "adb.exe: no devices/emulators found" 
::@echo   Или просто "Ошибка!"
::@echo ---------------------------------------------------
::@echo.
::@echo  Как поступим?
::@echo.
::@echo     0.  Выход из программы
::@echo     S.  Запустить программу
::@echo     D.  Открыть Диспетчер устройств
::@echo.
::@set "choice="
::@Set /p choice="Выберите пункт меню и нажмите Enter: "
::@echo.
::if not defined choice goto _RunMenuNoDevice
::if "%choice%"=="0" (exit)
::if /i "%choice%"=="s" (GOTO _beginn)
::if /i "%choice%"=="d" (start mmc.exe devmgmt.msc)
::@cls
::goto _RunMenuNoDevice


rem :_BattseryStatTab
rem call :_hat
rem @echo.
rem @echo.
rem @echo.


:_BattseryStatTab
call :_hat
call :_BatteryStatsCheck
call :_BattHealthLevel
@echo.
@echo. %biggernominal%
@echo  -----------------------------------------------------------------------------------------------
goto _eng35
@echo  		^| Остаточная емкость	^| Потеряно емкости	^| Деградация батареи	^|
@echo  -----------------------------------------------------------------------------------------
::@echo  Оценочная	^|   %batestimated%%mahe%		^|   %lostestimated%%mahp%		^|    %degostestimated%%pre%		^|
@echo  Рассчитанная	^|   %opcouprom%%mahh%		^|   %izgcou%%mahh%		^|    %degostcou%%pr%		^|
@echo  -----------------------------------------------------------------------------------------
@echo.
@echo  Оценочная емкость		: %batestimated% mAh
@echo  Последняя изученная емкость	: %batlearned% mAh
@echo  Минимальная изученная емкость	: %minbatlearned% mAh
@echo  Максимальная изученная емкость	: %maxbatlearned% mAh
@echo  Текущий заряд шлема		: %batlevel%%pr%
rem @echo.
@echo.
@echo  Статус батареи			: %batstatus%
@echo  Здоровье батареи		: %bathealth%
rem @echo.
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
::@echo  Оценочная емкость	- показатель, рассчитанный по сложному алгоритму, включающему в себя
::@echo				  диаграмму состояний, среднюю молщность для каждого из них,
::@echo				  средний ток, время резервного питания, коэффициент деградации и т.д.
::@echo				  КОРОЧЕ, ЭТО НАИБОЛЕЕ ВАЖНЫЙ ПАРАМЕТР. Хотя иногда он кривой.
::@echo			     	  Расчитан на основе статистики с момента последней зарядки.
::@echo				  [если значение емкости выше штатного, в этой строке будут прочерки]
::@echo.
@echo  Рассчитанная		- Расчет на основе текущего состояния батареи
@echo.
@echo  Изученная емкость	- Последняя/Минимальная/Максимальная.
@echo				  Совершенно бестолковые параметры, 
@echo				  но с ними список выглядит внушительней
:_eng35
@echo                     ^|  Residual capacity	^|  Lost capacity	^|  Battery degradation
@echo  -----------------------------------------------------------------------------------------------
@echo  Estimated          ^|  %batestimated%%mahe%			^|  %lostestimated%%mahp%		^|  %degostestimated%%pre%
@echo  Calculated         ^|  %opcouprom%%mahh%			^|  %izgcou%%mahh%		^|  %degostcou%%pr%
@echo  -----------------------------------------------------------------------------------------------
@echo.
@echo  Estimated capacity          : %batestimated% mAh
@echo  Last learned capacity       : %batlearned% mAh
@echo  Min learned capacity        : %minbatlearned% mAh
@echo  Max learned capacity        : %maxbatlearned% mAh
@echo  Current charge              : %batlevel%%pr%
rem @echo.
@echo.
@echo  Battery status              : %batstatus%
@echo  Battery health              : %bathealth%
rem @echo.
@echo.
@echo  Standard battery capacity   : %batfull% mAh
@echo  ===========================================
@echo.
@echo  EXPLANATION OF VALUES:
@echo.
@echo  Lost capacity       - the capacity lost by the battery over time
@echo                          [standard capacity minus statistical or calculated]
@echo.
@echo  Residual capacity   - the current capacity of the battery
@echo.                          [standard capacity minus lost]
@echo.
@echo  Battery degradation - the percentage by which the battery capacity has decreased
@echo                          [one hundred minus the ratio of standard capacity to residual]
@echo.
@echo  Standard capacity   - the initial capacity of a new battery according to the specification
@echo.
::@echo  Estimated capacity  - a parameter calculated using a complex algorithm, including
::@echo                            state diagram, average power for each of them,
::@echo                            average current, backup power time, degradation coefficient, etc.
::@echo                            IN SHORT, THIS IS THE MOST IMPORTANT PARAMETER. Although sometimes it's crooked.
::@echo                            Calculated based on statistics since the last charge.
::@echo                            [if the capacity value is higher than standard, there will be dashes in this line]
::@echo.
@echo  Calculated capacity - Calculation based on the current state of the battery
@echo.
@echo  Learned capacity    - Last/Min/Max.
@echo                            Absolutely useless parameters,
@echo                            but the list looks more impressive with them.
exit /b
::goto _exitout

:_BattHealthLevel
@%MYFILES%\adb shell dumpsys battery >battery.txt
@FOR /F "tokens=2" %%G IN ('findstr /i "health:" battery.txt') DO set health=%%G
@FOR /F "tokens=2" %%G IN ('findstr /i "status:" battery.txt') DO set status=%%G
goto _eng36
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
:_eng36
if %status%==1 set batstatus=Unknown
if %status%==2 set batstatus=Charging
if %status%==3 set batstatus=Discharging
if %status%==4 set batstatus=Not charging
if %status%==5 set batstatus=Fully charged
if [%status%]==[] set batstatus=Unknown
if %health%==1 set bathealth=Unknown
if %health%==2 set bathealth=Good
if %health%==3 set bathealth=Overheating
if %health%==4 set bathealth=Failed
if %health%==5 set bathealth=Over-voltage
if %health%==6 set bathealth=Unknown error
if %health%==7 set bathealth=Too low temperature
if [%health%]==[] set bathealth=Unknown
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
for /f "tokens=4" %%a in ('find /i "Estimated battery capacity:" charged.txt') do set batestimated=%%a
for /f "tokens=5" %%a in ('find /i "Last learned battery capacity:" charged.txt') do set batlearned=%%a
for /f "tokens=5" %%a in ('find /i "Min learned battery capacity:" charged.txt') do set minbatlearned=%%a
for /f "tokens=5" %%a in ('find /i "Max learned battery capacity:" charged.txt') do set maxbatlearned=%%a

@%MYFILES%\adb shell dumpsys battery >battery.txt
rem pause
rem @FOR /F "tokens=3" %%G IN ('@%MYFILES%\adb shell dumpsys battery ^| findstr "Charge counter:"') DO set batcounter=%%G
@FOR /F "tokens=3" %%G IN ('findstr /i "Charge counter:" battery.txt') DO set batcounter=%%G
rem @FOR /F "tokens=2" %%G IN ('@%MYFILES%\adb shell dumpsys battery ^| findstr "level:"') DO set batlevel=%%G
@FOR /F "tokens=2" %%G IN ('findstr /i "level:" battery.txt') DO set batlevel=%%G

rem pause
rem pause
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
rem set biggernominal=+++++ Оценочная емкость больше номинала! Такое бывает. Глюк-с +++++
set biggernominal=+++++ Estimated capacity is greater than nominal! This happens. Glitch-s +++++
goto _Count


:_setfwtxt
set IntProductName=
@for /f %%a in ('@%myfiles%\adb shell getprop ro.product.name') do set IntProductName=%%a
if [%IntProductName%]==[] set IntProductName=---------- && set DeviceModelName=-------- && set DevModelNm=-------------&& exit /b
if %IntProductName%==monterey set DevModelNm=Meta Quest 1&& set fmfilename=Q1&& set fwtxt=fw1.txt&& set /a batfull=3648&& set model=Quest 1 && set uknownmodel=0 && exit /b
if %IntProductName%==hollywood set DevModelNm=Meta Quest 2&& set fmfilename=Q2&& set fwtxt=fw2.txt&& set /a batfull=3710&& set model=Quest 2 && set uknownmodel=0 && exit /b
if %IntProductName%==eureka set DevModelNm=Meta Quest 3&& set fmfilename=Q3&& set fwtxt=fw3.txt&& set /a batfull=5100&&  set model=Quest 3 && set uknownmodel=0 && exit /b
if %IntProductName%==seacliff set DevModelNm=Meta Quest Pro&& set fmfilename=QP&& set fwtxt=fwp.txt&& set /a batfull=5348&&  set model=Quest Pro && set uknownmodel=0 && exit /b
set DeviceModelName=Неясно
set model=Неизвестно
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

:_egg
@cls
@echo off
color 0a
@echo.
@echo.
@echo       ## ##    ## ##   ##  ###  ####     ##  ###   ## ##   
@echo      ##   ##  ##   ##  ##   ##   ##      ##   ##  ##   ##  
@echo      ##   ##  ##       ##   ##   ##      ##   ##  ####     
@echo      ##   ##  ##       ##   ##   ##      ##   ##   #####   
@echo      ##   ##  ##       ##   ##   ##      ##   ##      ###  
@echo      ##   ##  ##   ##  ##   ##   ##  ##  ##   ##  ##   ##  
@echo       ## ##    ## ##    ## ##   ### ###   ## ##    ## ##   
@echo.                                                 
@echo     ## ##   ##  ###  ### ###   ## ##   #### ##       ## ##    
@echo    ##   ##  ##   ##   ##  ##  ##   ##  # ## ##       ##  ##   
@echo    ##   ##  ##   ##   ##      ####       ##              ##   
@echo    ##   ##  ##   ##   ## ##    #####     ##             ##    
@echo    ##   ##  ##   ##   ##          ###    ##            ##     
@echo    ##  ##   ##   ##   ##  ##  ##   ##    ##           #   ##  
@echo     ##  ##   ## ##   ### ###   ## ##    ####         ######   
@echo.                                                         
@echo   ### ###   ## ##   ### ##   ### ###  ### ###  ### ###  ### ##   
@echo    ##  ##  ##   ##   ##  ##   ##  ##   ##  ##   ##  ##   ##  ##  
@echo    ##      ##   ##   ##  ##   ##       ##  ##   ##       ##  ##  
@echo    ## ##   ##   ##   ## ##    ## ##    ##  ##   ## ##    ## ##   
@echo    ##      ##   ##   ## ##    ##       ### ##   ##       ## ##   
@echo    ##      ##   ##   ##  ##   ##  ##    ###     ##  ##   ##  ##  
@echo   ####      ## ##   #### ##  ### ###     ##    ### ###  #### ##  
@echo.                                                      
@echo.                                                      
@echo.                                                      
@echo ===================================================================
rem @echo ++++++++   Браво! Мои поздраволения, вы открыли пасхалку!  +++++++
@echo ++++++++ Congratulations! You've found an Easter egg! +++++++
@echo ===================================================================
@pause 1>nul 2>nul
goto :_beginn                                                         

:_hat
@cls
@echo ==================================================================================================
@echo        QUest ADB Scripts - created by Varset - v.3.0.1e - 19.03.24%hatcod%
@echo ==================================================================================================
@exit /b

:_hatmenu
@echo off
::@echo.
@echo.
::@echo     -------------------
::@echo      ВЫБЕРИТЕ ДЕЙСТВИЕ
::@echo     -------------------
@echo.
rem @echo    0.  Выход из программы
rem @echo    M.  Выход в Главное меню
@echo    0.  Exit from the program
@echo    M.  Exit to Main menu
@exit /b

:_MenuChoiceEnter
@set "choice="
rem @Set /p choice="Выберите пункт меню и нажмите Enter: "
@Set /p choice="Select a menu number and press Enter: "
@exit /b

:_MenuChoiceEnterDef
rem @Set /p choice="Выберите пункт меню и нажмите Enter: "
@Set /p choice="Select a menu number and press Enter: "
@exit /b



:_utf
set codepage=@chcp 65001
set cod=utf
set hatcod=             [ ver. UTF-8 ]
exit /b

:_oem
set codepage=@chcp 866
set cod=oem
set hatcod=           [ ver. OEM-866 ]
exit /b

rem :_cdc
@%myfiles%\adb shell getprop ro.boot.serialno 1>NUL 2>&1
rem echo %errorlevel%
exit /b


:_CheckRegisterKeys
For /f "skip=1 tokens=3 delims= " %%a in ('reg query HKCU\Software\Quas /v Start') do set startkey=%%a

if /i [%startkey%]==[b] (goto _beginn) else (goto _begin0)

For /f "skip=1 tokens=3 delims= " %%a in ('reg query HKCU\Software\Quas /v Rights') do set rightskey=%%a
if [%rightskey%]==[] goto _begin0
if /i %rightskey%==u goto _userright 
if /i %rightskey%==a goto _adminright
if /i %rightskey%==c goto _uacright
exit /b
