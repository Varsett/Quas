
::@set myfiles=d:\Quest2\adb
@echo off
@chcp 65001 1>nul  2>&1
@set myfiles=C:\Temp\SendToHeadset
@set sendtofoldercmdfolder=C:\Temp\SendToHeadset

@setlocal enableextensions enabledelayedexpansion

call :_checkdevice

set hidefrstp=1^>NUL
set hidescndp=2^>NUL

set installname=%1
rem call :_DeleteWrongSymbolsOk

For %%v In (!installname!) Do ( 
Set "PathIncludePathGame=%%~dpv"
@set extens=%%~xv
@set attribs=%%~av
@set extname=%%~nxv
if /i !extens!==.apk goto _SingleApkInstall
if !attribs! GEQ d-------- goto _MultiApkInstall
if /i !extname!==install.txt call :_InstallCmdCreate
)
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

:_errorfile
@echo.
@echo.
@echo ===============================================================
rem StartRusTextBlock
rem @echo       %_fBYellow%+++ Это не каталог, не apk файл и не install.txt +++
rem @echo.
rem @echo                   Установить не получится%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBYellow%+++ This is not a directory, not an apk file, and not an install.txt +++
@echo.
@echo                   Installation will not be possible%_fReset%
rem EndEngTextBlock
@echo --------------------------------------------------------------
@echo.
goto :_exitout

:_MultiApkInstall
call :_SetColours
@cls
@echo.
set "gPath=%installname%"
set /a MultiCounterOk=0
set /a MultiCounterEr=0
for /r %gPath% %%a in (*.apk) do (
set "apkname=%%a"
@set "apknamefile=%%~nxa"
@set PathBeforeObbPath=%%~dpa
@set "apkname=%%a"
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
rem @echo  %_fBGreen%+++ Установка завершена +++%_fReset%
rem @echo.
rem @echo   %_fBYellow%Установлено		: !MultiCounterOk!%_fReset%
rem @echo   %_fYellow%Не установлено	: %MultiCounterEr%%_fReset%	
rem @echo --------------------------------------------
rem @echo.
rem @echo   %_fBYellow%Список не установленных приложений сохранен в%_fReset% %_fYellow%%sendtofoldercmdfolder%\notinstalled.txt
rem @echo   %_fBYellow%Попробуйте установить их вручную. Также возможно, что в имени файла или каталога
rem @echo   есть восклицательный знак - в этом случае попробуйте удалить его.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBGreen%+++ Installation completed +++%_fReset%
@echo.
@echo   %_fBGreen%Installed		: !MultiCounterOk!%_fReset%
@echo   %_fBRed%Not installed	: %MultiCounterEr%%_fReset%
@echo --------------------------------------------
@echo.
@echo   The list of not installed applications is saved in %sendtofoldercmdfolder%\notinstalled.txt
@echo   Try installing them manually. Also, it's possible that there is an exclamation mark 
@echo   in the file name or directory - if so, try removing it.
rem EndEngTextBlock
@echo.
goto :_exittimeout

:_MultiInstallProcess
set hidefrstp=1^>NUL
set hidescndp=2^>NUL
if not defined applabel exit /b
rem StartRusTextBlock
rem @echo  %_fBYellow%%MultiCounterOk%%_fReset%. = Устанавливаем  "%_fBCyan%%applabel%%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBYellow%%MultiCounterOk%%_fReset%. = Installing "%_fBCyan%%applabel%%_fReset%"
rem EndEngTextBlock
@%MYFILES%\ADB install -r -g --no-streaming "%apkname%" %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (call :_MultiCopyObbInslallApk) else (call :_MultiInstallApkErr)
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
rem @echo   %_fBRed%  - Ошибка установки %_fBCyan%!apknamefile! +++%_fReset%
@echo.
rem @echo   %_fBYellow%  = Продолжаем установку%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  %_fBRed%  - Installation error %_fBCyan%!apknamefile! +++%_fReset%
@echo.
@echo  %_fBYellow%  = Continuing installation%_fReset%
rem EndEngTextBlock
set /a MultiCounterEr=%MultiCounterEr%+1
@echo  !apkname! >>%sendtofoldercmdfolder%\notinstalled.txt
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
call :_SetColours
rem call :_DeleteWrongSymbolsOk
set hidefrstp=1^>NUL
set hidescndp=2^>NUL
@echo off
@cls
@echo.
@SET pkgName=
@set apkname=
set enterapkname=
@Set "apkname=%installname%"
@For %%v In (!apkname!) Do Set "PathIncludePathGame=%%~dpv"
for /f "tokens=*" %%a in ('%myfiles%\aapt2 dump packagename !apkname!') do set pkgname=%%a
FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging !apkname! ^| findstr /i /c:"application-label:"') DO set applabel=%%g
@echo -----------------------------------------------
rem StartRusTextBlock
rem @echo  = Устанавливаем "%_fBCyan%%applabel%%_fReset%"
rem EndRusTextBlock
rem StartEngTextBlock
@echo = Installing "%_fBCyan%%applabel%%_fReset%"
rem EndEngTextBlock
%MYFILES%\ADB install -r -g %down% --no-streaming !apkname! %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (call :_SingleCopyObbInslallApk) else (call :_SingleErrInstallApk)
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
rem @echo 	    %_fBRed%+++ Ошибка установки +++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo %_fBRed%+++ Installation Error +++%_fReset%
rem EndEngTextBlock
echo.
@goto _exitout

:_InstallCmdCreate
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
@cmd /c "%PathIncludePathGame%install.cmd"
@del "%PathIncludePathGame%install.cmd" /q
@findstr "^" "%PathIncludePathGame%errors.txt">nul&& echo.|| @del "%PathIncludePathGame%errors.txt" /q
exit /b

:_exittimeout
@echo.
rem StartRusTextBlock
rem @echo ^>^>^> Нажмите любую кнопку для выхода из программы ^<^<^<
rem @echo               или подождите пять секунд
rem EndRusTextBlock
rem StartEngTextBlock
@echo ^>^>^> Press any key to exit the program ^<^<^< 
@echo           or wait five seconds
rem EndEngTextBlock
@timeout 5 >nul
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

