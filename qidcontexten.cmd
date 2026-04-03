
::@set myfiles=d:\Quest2\adb
@echo off
@chcp 65001 1>nul  2>&1
@set myfiles=%systemdrive%\Temp\SendToHeadset
@set sendtofoldercmdfolder=%systemdrive%\Temp\SendToHeadset

@setlocal enableextensions enabledelayedexpansion

call :_checkdevice
call :_SetColours

rem set hidefrstp=1^>NUL
rem set hidescndp=2^>NUL


rem set hidefrstp=1^>InstallLog.txt
rem set hidescndp=2^>ErrorsLog.txt

set "installname=%1"
rem call :_DeleteWrongSymbolsOk

For %%v In (%installname%) Do ( 
    set "PathIncludePathGame=%%~dpv"
    set "extens=%%~xv"
    set "attribs=%%~av"
    set "extname=%%~nxv"
    set "targetdir=%%~fv"
    set "dlappl=%%~fv"
    set "dlfile=%%~nxv"
    set "dlname=%%~nv"
    set "ext=%%~xv"
    set "dlfolder=%%~dpv"
)

if /i "!extens!"==".apk" goto _SingleApkInstall
if /i "!extens!"==".ab" goto _ABContextRestore
if /i "!extens!"==".apks" goto _SXApkInstall
if /i "!extens!"==".xapk" goto _SXApkInstall
if !attribs! GEQ d-------- goto _MultiApkInstall
if /i "!extname!"=="install.txt" goto :_InstallCmdCreate

@echo.
@echo.
@echo ===============================================================
@echo.
rem StartRusTextBlock
rem @echo    %_fBRed%+++ Это неподходящий для обработки файл или каталог +++
rem @echo.
rem @echo    %_fBYellow%Выберите файлы ab, apk, install.txt или каталог с игрой%_fReset%
rem @echo    Также проверьте, чтобы в имени каталогов или файлов не было восклицательных знаков.
rem EndRusTextBlock
rem StartEngTextBlock
@echo    %_fBRed%+++ This is an unsuitable file or directory for processing +++
@echo.
@echo    %_fBYellow%Select ab, apk, install.txt files or a game directory%_fReset%
rem EndEngTextBlock
@echo --------------------------------------------------------------
@echo.
goto :_exitout

:_SXApkInstall
@echo off
@echo ==========================================================
rem StartRusTextBlock
rem @echo  %_fBGreen%= Установка "!dlfile!"%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%= Installing "%dlfile%"%_fReset%
rem EndEngTextBlock
if not exist "!dlappl!" (
rem StartRusTextBlock
rem @echo  %_fBRed%= Файл не найден:%_fReset% !dlappl!
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%= File not found:%_fReset% %dlappl%
rem EndEngTextBlock
goto :_exitout
)
for %%F in ("!dlappl!") do set "ext=%%~xF"
if /I not "!ext!"==".apks" if /I not "!ext!"==".xapk" (
rem StartRusTextBlock
rem @echo  %_fBRed%= Неподдерживаемый формат:%_fReset% !ext!
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%= Unsupported format:%_fReset% %ext%
rem EndEngTextBlock
goto :_exitout
)
rem StartRusTextBlock
rem @echo  %_fBYellow%= Распаковка%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%= Unpacking%_fReset%
rem EndEngTextBlock
set "dlcat=!dlfile:~0,-5!"
set "tmpzip=%cd%\apkinstall.zip"
copy "!dlappl!" "%tmpzip%" >nul
powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Expand-Archive -LiteralPath '%tmpzip%' -DestinationPath '!dlcat!' -Force"
del /q /f "%tmpzip%" 1>nul 2>nul
rem %MYFILES%\7z.exe x "%dlappl%" -o"%dlcat%" -y >nul
if errorlevel 1 (
rem StartRusTextBlock
rem @echo  %_fBRed%= Ошибка распаковки%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%= Unpacking error%_fReset%
rem EndEngTextBlock
goto :_exitout
)
set "APK_BASE="
set "APK_LIST="
set "APK_SPLITS="
for /F "delims=" %%A in ('dir /s /b "!dlcat!\*.apk" 2^>nul') do (
if /I "%%~nxA"=="base.apk" (
set "APK_BASE="%%~fA""
) else (
set "APK_SPLITS=!APK_SPLITS! "%%~fA""
)
)
set "APK_LIST=!APK_BASE! !APK_LIST!"
if not defined APK_SPLITS if not defined APK_BASE (
rem StartRusTextBlock
rem @echo  %_fBRed%= APK не найдены%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%= APK files not found%_fReset%
rem EndEngTextBlock
goto :_exitout
)
if defined APK_BASE (
rem StartRusTextBlock
rem @echo  %_fBGreen%= base.apk найден%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBGreen%= base.apk found%_fReset%
rem EndEngTextBlock
) else (
rem StartRusTextBlock
rem @echo  %_fYellow%= base.apk не найден%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fYellow%= base.apk not found%_fReset%
rem EndEngTextBlock
)
rem ==================================================
rem  ФИНАЛЬНЫЙ СПИСОК APK
rem ==================================================
if defined APK_BASE (
    set "APK_LIST=!APK_BASE! !APK_SPLITS!"
) else (
    set "APK_LIST=!APK_SPLITS!"
)
rem StartRusTextBlock
rem @echo  %_fBCyan%= Порядок установки:%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBCyan%= Installation order:%_fReset%
rem EndEngTextBlock
for %%A in (!APK_LIST!) do echo     %%~A
@echo %_fReset%
rem ==================================================
rem  УСТАНОВКА APK
rem ==================================================
set "installLog=InstallLog.txt"
set "errorsLog=ErrorsLog.txt"

set hidefrstp=1^>tmp_install.log
set hidescndp=2^>tmp_error.log

set "installLog=InstallLog.txt"
set "errorsLog=ErrorsLog.txt"
rem StartRusTextBlock
rem @echo  %_fBYellow%= Установка APK...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBYellow%= Installing APK...%_fReset%
rem EndEngTextBlock

%MYFILES%\adb install-multiple %APK_LIST% %hidefrstp% %hidescndp%
rem 1>nul 2>nul
if errorlevel 1 (
rem StartRusTextBlock
rem @echo  %_fBRed%= Ошибка установки APK%_fReset%
rem @echo  -----------------------------------------
rem @echo  %_fBYellow%Подробности содержатся в файлах %_fYellow%InstallLogt.txt%_fBYellow% и %_fYellow%ErrorsLog.txt%_fBYellow%
rem @echo  расположенных в каталоге %_fYellow%%systemdrive%\Temp\SendToHeadset%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBRed%= APK installation error%_fReset%
rem EndEngTextBlock
call :_ProcessLog "!hidefrstp:~2!" "%installLog%"
call :_ProcessLog "!hidescndp:~2!" "%errorsLog%"
rd /s /q "!dlcat!" 1>nul 2>nul
goto :_exitout
) else (
call :_ProcessLog "!hidefrstp:~2!" "%installLog%"
call :_ProcessLog "!hidescndp:~2!" "%errorsLog%"
)

rem ==================================================
rem  OBB (ТОЛЬКО ДЛЯ XAPK)
rem ==================================================
if /I "%ext%"==".xapk" (
if exist "%dlcat%\Android\obb" (
rem StartRusTextBlock
rem @echo  %_fBYellow%= Копирование OBB...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBYellow%= OBB files copying...%_fReset%
rem EndEngTextBlock
%MYFILES%\adb push "%dlcat%\Android\obb" /sdcard/Android/
) else (
rem StartRusTextBlock
rem @echo  %_fYellow%= OBB не найден%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fYellow%= OBB files not found%_fReset%
rem EndEngTextBlock
)
)
@echo.
@echo ===============================================
rem StartRusTextBlock
rem @echo      %_fBGreen%=== Установка завершена ===%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo      %_fBGreen%=== Installation complete ===%_fReset%
rem EndEngTextBlock
rd /s /q "!dlcat!" 1>nul 2>nul
goto :_exittimeout

:_MultiApkInstall
call :_SetColours
set "installLog=InstallLog.txt"
set "errorsLog=ErrorsLog.txt"

set hidefrstp=1^>tmp_install.log
set hidescndp=2^>tmp_error.log

set "installLog=InstallLog.txt"
set "errorsLog=ErrorsLog.txt"
@cls
@echo.

rem call :_DeleteWrongMark

set "gPath=%installname%"
set /a MultiCounterOk=0
set /a MultiCounterEr=0
set /a MultiCounter=1
for /r %gPath% %%a in (*.apk) do (
set "apkname=%%a"
@set "apknamefile=%%~nxa"
@set PathBeforeObbPath=%%~dpa
rem @set "apkname=%%a"
@For /f "tokens=*" %%v In ("!apkname!") Do Set "PathGame=%%~dpv"
@for /f "tokens=*" %%d in ('@%myfiles%\aapt2 dump packagename "!apkname!" 2^>nul') do set pkgname=%%d
@if not defined pkgname call :_MultiInstallApkErr
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging "!apkname!" 2^>nul ^| findstr /i /c:"application-label:"') DO set applabel=%%g
call :_MultiInstallProcess
@echo -----------------------------------------------
)
@echo ================================================
@echo.
rem StartRusTextBlock
rem @echo  %_fBGreen%+++ Установка завершена +++%_fReset%
rem @echo.
rem @echo   %_fBYellow%Установлено		: !MultiCounterOk!%_fReset%
rem @echo   %_fYellow%Не установлено	: %MultiCounterEr%%_fReset%	
rem @echo --------------------------------------------
rem @echo.
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBGreen%+++ Installation completed +++%_fReset%
@echo.
@echo   %_fBGreen%Installed		: !MultiCounterOk!%_fReset%
@echo   %_fBRed%Not installed	: %MultiCounterEr%%_fReset%
@echo --------------------------------------------
@echo.
rem EndEngTextBlock
@echo.
goto :_exittimeout

:_MultiInstallProcess
rem set hidefrstp=1^>NUL
rem set hidescndp=2^>NUL
if not defined applabel exit /b
rem StartRusTextBlock
rem @echo  %_fBYellow%%MultiCounter%%_fReset%. = Устанавливаем  "%_fBCyan%%applabel%%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBYellow%%MultiCounterOk%%_fReset%. = Installing "%_fBCyan%%applabel%%_fReset%"
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g --no-streaming "%apkname%" %hidefrstp% %hidescndp%

@IF !ERRORLEVEL!==0 (
rem set /a MultiCounterOk=%MultiCounterOk%+1
call :_ProcessLog "!hidefrstp:~2!" "%installLog%"
call :_ProcessLog "!hidescndp:~2!" "%errorsLog%"
call :_MultiCopyObbInslallApk
) else (
rem set /a MultiCounterEr=%MultiCounterEr%+1
call :_ProcessLog "!hidefrstp:~2!" "%installLog%"
call :_ProcessLog "!hidescndp:~2!" "%errorsLog%"
call :_MultiInstallApkErr
)
set /a MultiCounter=%MultiCounter%+1
set applabel=
set pkgname=
exit /b

:_MultiCopyObbInslallApk
call :_SetColours
for /r "%PathGame%" %%i in (.) do (
if /i "%%~nxi"=="%pkgname%" (
set "FoundPath=%%i"
rem StartRusTextBlock
rem @echo     = Копируем "%_fCyan%%pkgname%%_fReset%" в каталог OBB на шлем..
rem EndRusTextBlock
rem StartEngTextBlock
@echo     = Copying "%_fCyan%%pkgname%%_fReset%" to the OBB directory on the headset..
rem EndEngTextBlock
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "!FoundPath!" /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
call :_MultiInstalledOk
exit /b
)
)
call :_MultiInstalledOk
exit /b

:_MultiInstallApkErr
rem StartRusTextBlock
rem @echo     %_fBRed%+++ Ошибка установки приложения %_fBCyan%!apknamefile! %_fBRed%+++%_fReset%
rem @echo     -----
rem @echo  %_fBYellow%Подробности содержатся в файлах %_fYellow%InstallLogt.txt%_fBYellow% и %_fYellow%ErrorsLog.txt%_fBYellow%
rem @echo  расположенных в каталоге %_fYellow%%systemdrive%\Temp\SendToHeadset%_fReset%
rem @echo     -----
rem @echo     %_fCyan%= Продолжаем установку%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBRed%+++ Installation error %_fBCyan%!apknamefile! +++%_fReset%
@echo     -----
@echo  %_fBYellow%Details can be found in the files %_fYellow%InstallLogt.txt%_fBYellow% and %_fYellow%ErrorsLog.txt%_fBYellow%
@echo  located in the directory %_fYellow%%systemdrive%\Temp\SendToHeadset%_fReset%
@echo     -----
@echo  %_fBYellow%= Continuing installation%_fReset%
rem EndEngTextBlock
rem @echo  !apkname! >>%sendtofoldercmdfolder%\notinstalled.txt
set /a MultiCounterEr=%MultiCounterEr%+1
exit /b

:_MultiInstalledOk
rem @echo --
rem StartRusTextBlock
rem @echo     %_fBGreen%= Установлено успешно%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo     %_fBGreen%= Successfully installed%_fReset%
rem EndEngTextBlock
set /a MultiCounterOk=%MultiCounterOk%+1
exit /b

:_SingleApkInstall
@setlocal enableextensions enabledelayedexpansion
call :_SetColours
@echo off
@SET pkgName=
@set apkname=
set enterapkname=
@cls
@echo.
rem call :_DeleteWrongSymbolsOk
rem set hidefrstp=1^>NUL
rem set hidescndp=2^>NUL

set "installLog=InstallLog.txt"
set "errorsLog=ErrorsLog.txt"

set hidefrstp=1^>tmp_install.log
set hidescndp=2^>tmp_error.log

set "installLog=InstallLog.txt"
set "errorsLog=ErrorsLog.txt"

@Set "apkname=%installname%"
@For %%v In (!apkname!) Do Set "PathIncludePathGame=%%~dpv"
for /f "tokens=*" %%a in ('%myfiles%\aapt2 dump packagename !apkname! 2^>nul') do set pkgname=%%a
FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging !apkname! 2^>nul ^| findstr /i /c:"application-label:"') DO set applabel=%%g
@echo -----------------------------------------------
rem StartRusTextBlock
rem @echo  = Устанавливаем "%_fBCyan%%applabel%%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
@echo = Installing "%_fBCyan%%applabel%%_fReset%"
rem EndEngTextBlock
%MYFILES%\ADB install -r -g %down% --no-streaming !apkname! %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (
call :_ProcessLog "!hidefrstp:~2!" "%installLog%"
call :_ProcessLog "!hidescndp:~2!" "%errorsLog%"
call :_SingleCopyObbInslallApk
) else (
call :_ProcessLog "!hidefrstp:~2!" "%installLog%"
call :_ProcessLog "!hidescndp:~2!" "%errorsLog%"
call :_SingleErrInstallApk
)
rem @echo --
rem StartRusTextBlock
rem @echo  %_fBGreen%= Установлено успешно%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBGreen%= Successfully installed%_fReset%
rem EndEngTextBlock
@echo ===========================================
echo.
goto :_exittimeout

:_SingleCopyObbInslallApk
for /r "%PathIncludePathGame%" %%i in (.) do (
if /i "%%~nxi"=="%pkgname%" (
set "FoundPath=%%i"
rem @echo !FoundPath!
rem StartRusTextBlock
@echo --
rem @echo  = Копируем "%_fCyan%%pkgname%%_fReset%" в каталог OBB на шлем..
rem EndRusTextBlock
rem StartEngTextBlock
@echo  = Copying "%_fCyan%%pkgname%%_fReset%" to the OBB directory on the headset..
rem EndEngTextBlock
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
%MYFILES%\ADB push "!FoundPath!" /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
rem call :_MultiInstalledOk
exit /b
)
)
rem call :_MultiInstalledOk
exit /b


:_SingleErrInstallApk
@echo ===========================================
rem StartRusTextBlock
rem @echo      %_fBRed%+++ Ошибка установки +++
rem @echo.
rem @echo  %_fBYellow%Подробности содержатся в файлах %_fYellow%InstallLogt.txt%_fBYellow% и %_fYellow%ErrorsLog.txt%_fBYellow%
rem @echo  расположенных в каталоге %_fYellow%%systemdrive%\Temp\SendToHeadset%_fReset%
rem @echo.
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%+++ Installation Error +++%_fReset%
@echo.
@echo  %_fBYellow%Details can be found in the files %_fYellow%InstallLogt.txt%_fBYellow% and %_fYellow%ErrorsLog.txt%_fBYellow%
@echo  located in the directory %_fYellow%%systemdrive%\Temp\SendToHeadset%_fReset%
rem EndEngTextBlock
echo.
@goto _exitout

:_InstallCmdCreate
@setlocal enableextensions enabledelayedexpansion
call :_SetColours
@echo  ===========================================
rem StartRusTextBlock
rem @echo  %_fBYellow%= Установка по сценарию%_fReset% %_fYellow%install.txt%_fReset%
rem @echo.
rem @echo    %_fBYellow%Если во время установки возникнут ошибки,
rem @echo    они будут записаны в файл %_fYellow%errors.txt%_fReset% %_fBYellow%в каталоге с игрой.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBYellow%== Installation via install.txt script
@echo.
@echo    If errors occur during installation,
@echo    they will be recorded in the errors.txt file in the game directory.%_fReset%
rem EndEngTextBlock
@echo  -----
@echo @echo off>>"%PathIncludePathGame%install.cmd
@echo @echo.>>"%PathIncludePathGame%install.cmd"
@echo cd ^/D "%PathIncludePathGame%">>"%PathIncludePathGame%install.cmd"
@for /f "UseBackQ delims=" %%a in (%installname%) do (
@set newstring=%%a
@echo %myfiles%\!newstring! 2^>^>errors.txt>>"%PathIncludePathGame%install.cmd"
@echo @echo  ^----->>"%PathIncludePathGame%install.cmd"
@echo @echo.>>"%PathIncludePathGame%install.cmd"
)
pause
@cmd /c "%PathIncludePathGame%install.cmd"
@del "%PathIncludePathGame%install.cmd" /q
@findstr "^" "%PathIncludePathGame%errors.txt">nul&& echo.|| @del "%PathIncludePathGame%errors.txt" /q
@echo ================================================
@echo.
rem StartRusTextBlock
rem @echo      %_fBGreen%+++ Установка завершена +++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBGreen%+++ Installation is complete +++%_fReset%
rem EndEngTextBlock
@echo.
goto :_exittimeout
rem exit /b

:_exittimeout
@echo.
rem StartRusTextBlock
rem @echo ^>^>^> Нажмите любую кнопку для выхода из программы ^<^<^<
rem @echo               или подождите десять секунд
rem EndRusTextBlock
rem StartEngTextBlock
@echo ^>^>^> Press any key to exit the program ^<^<^< 
@echo           or wait five seconds
rem EndEngTextBlock
@timeout 10 >nul
::@pause >nul
@exit


:_exitout
@echo.
rem StartRusTextBlock
rem @echo ^>^>^> Нажмите любую кнопку для выхода из программы ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
@echo ^>^>^> Press any key to exit the program ^<^<^<
rem EndEngTextBlock
@pause >nul
@exit

:_checkdevice
@echo.
rem StartRusTextBlock
rem @echo ADB запускается....
rem EndRusTextBlock
rem StartEngTextBlock
@echo ADB is starting..
rem EndEngTextBlock
@adb devices 1>nul 2>nul
@FOR /F "skip=1 tokens=2" %%G IN ('%sendtofoldercmdfolder%\adb devices ^| findstr /i /c:"device"') DO set adbdevices=%%G
@if [%adbdevices%]==[] goto _NF
@cls
exit /b

:_NF
call :_SetColours
@cls
@echo.
@echo.
@echo.
rem StartRusTextBlock
rem @echo     %_fBRed%+++++ Шлем не найден +++++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo     %_fBRed%+++++ Headset not found +++++%_fReset%
rem EndEngTextBlock
@echo.
@echo.
@echo.
rem StartRusTextBlock
rem @echo  %_fBYellow%Проверьте кабельное соединение и правильность установки драйверов.
rem @echo  Затем перезапустите эту программу снова.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBYellow%Check the cable connection and the correctness of the driver installation.
@echo  Then restart this program again.%_fReset%
rem EndEngTextBlock
@echo.
@goto _exitout

:_DeleteWrongSymbolsOk
set "nametest=%installname%"
@for %%a in ("%nametest%") do (
@set name=%%a
call set "name=%%name:(=%%"
call set "name=%%name:)=%%"
call set "name=%%name:!=%%"
rem call set "name=%%name:+=%%"
rem call set "name=%%name: =%%"
call set "name=%%name::=%%"
call set "name=%%name:&=%%"
)
set installname=%name:~1,-1%
exit /b


:_DeleteWrongMark
setlocal DisableDelayedExpansion
set "installname=%~nx1"
set "installname=%installname:!=%"
endlocal & set "installname=%installname%"
exit /b


rem set "nametest=%installname%"
rem @for %%a in ("%nametest%") do (
rem @set name=%%a
rem call set "name=%%name:!=%%"
rem )
rem set installname=%name:~1,-1%
rem exit /b



:_ABContextRestore
@setlocal enableextensions enabledelayedexpansion
call :_SetColours
set "archivename=%PathIncludePathGame%"
set "filename=%extname%"
@echo.
@echo.
@echo   -------------------------------------------------------------------
rem StartRusTextBlock
rem @echo    %_fBYellow%Идет подготовка к восстановлению. Не прерывайте этот процесс.%_fReset%
rem @echo   -------------------------------------------------------------------
rem call :_PackageNameExtract
rem @echo    = Название архива	: %_fBCyan%!filename!%_fReset%
rem @echo    = Название пакета	: %_fCyan%!viewpn!%_fReset%
rem @echo   ------------------------------------------------------------------
rem @echo    %_fBYellow%Для подтверждения восстановления нажмите %_fYellow%Enter%_fBYellow%, для выхода - %_fYellow%Esc%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo    %_fBYellow%Preparing for restore. Do not interrupt this process.%_fReset%
@echo   -------------------------------------------------------------------
call :_PackageNameExtract
@echo    = Archive name	: %_fBCyan%!filename!%_fReset%
@echo    = Package name	: %_fCyan%!viewpn!%_fReset%
@echo   ------------------------------------------------------------------
@echo   %_fBYellow%For restore confirmation press %_fYellow%Enter%_fBYellow%, to exit - %_fYellow%Esc%_fReset%
rem EndEngTextBlock
@echo   ------------------------------------------------------------------
for /f "usebackq" %%K in (`powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); $key.VirtualKeyCode"`) do set "KEY=%%K"
if "!KEY!"=="27" goto exit
if "!KEY!"=="13" (
rem StartRusTextBlock
rem @echo   = Восстановление...
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Restoring...
rem EndEngTextBlock
call :_RestoreProcess
)
@echo   -------------------------------------------------------------------
rem StartRusTextBlock
rem @echo            %_fBYellow%Это окно закроется через десять секунд%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo            %_fBYellow%This window will close in ten seconds%_fReset%
rem EndEngTextBlock
timeout 10 >nul
exit

:_RestoreProcess
@%MYFILES%\adb shell am force-stop com.android.backupconfirm 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
@timeout 5 >nul
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
start /min "" %myfiles%\adb restore "!archivename!" 1>nul 2>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 66
call :_CheckBackupProcessRest
rem StartRusTextBlock
rem @echo   %_fBGreen%= Архив восстановлен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo   %_fBGreen%= Archive restored%_fReset%
rem EndEngTextBlock
)
del /q /f packages-list.txt 1>nul 2>nul
timeout 1 1>nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_CheckBackupProcessRest
for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] == [com.android.backupconfirm] (timeout 2 1>nul && goto _CheckBackupProcessRest) else (exit /b)
)

:_PackageNameExtract
set shscriptname=cont.sh
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/!filename!" ^) ^| tar xfvz - -C /data/local/tmp/ >%shscriptname%
%myfiles%\adb push "!archivename!" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell ls -1t /data/local/tmp/apps/ ^| head -1 >log.txt 2>nul 
@FOR /F "tokens=*" %%k IN (%cd%\log.txt) DO set viewpn=%%k
del /q /f log.txt 1>nul 2>nul
del /q /f %shscriptname% 1>nul 2>nul
exit /b


:_ProcessLog
set "tmpfile=%~1"
set "mainlog=%~2"

rem Проверяем, существует ли временный лог
if not exist "%tmpfile%" goto :eof

rem Проверяем, пуст ли файл
for %%A in ("%tmpfile%") do if %%~zA==0 (
    del "%tmpfile%" >nul 2>&1
    goto :eof
)

rem Добавляем дату и разделитель
>>"%mainlog%" echo ----------------------------------------
>>"%mainlog%" echo [%date% %time%]
type "%tmpfile%" >>"%mainlog%"
>>"%mainlog%" echo.

rem Удаляем временный файл
del "%tmpfile%" >nul 2>&1
goto :eof


:_SetColours
@set _fReset=[0m

@Set _fBlack=[30m
@Set _bBlack=[40m

@Set _fBRed=[91m
@Set _bRed=[41m
@Set _bBRed=[101m

@Set _fBGreen=[92m
@Set _bGreen=[42m
@Set _bBGreen=[102m

@set _fCyan=[36m
@Set _bBCyan=[106m
@Set _bCyan=[46m
@Set _fBCyan=[96m

@set _fBYellow=[93m
@Set _fYellow=[33m
@Set _bBYellow=[103m
@Set _bYellow=[43m

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

