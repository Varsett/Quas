::@set myfiles=d:\Quest2\adb
@echo off
::@chcp 65001
@set myfiles=C:\Temp\SendToHeadset
@set sendtofoldercmdfolder=C:\Temp\SendToHeadset

@setlocal enableextensions enabledelayedexpansion

call :_checkdevice

set hidefrstp=1^>NUL
set hidescndp=2^>NUL

set installname=%1

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
rem @echo      +++ ��⠭���� �����襭� +++
@echo +++ Installation is complete +++
@echo.
goto :_exittimeout

:_errorfile
@echo.
@echo.
@echo ===============================================================
rem @echo       +++ �� �� ��⠫��, �� apk 䠩� � �� install.txt +++
rem @echo.
rem @echo                   ��⠭����� �� ��������
@echo +++ This is not a directory, not an apk file, and not an install.txt +++
@echo.
@echo                   Installation will not be possible
@echo --------------------------------------------------------------
@echo.
goto :_exitout

:_MultiApkInstall
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
@FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging "!apkname!" ^| find "application-label:"') DO set applabel=%%g
call :_MultiInstallProcess
@echo -----------------------------------------------
)
@echo ================================================
@echo.
rem @echo  +++ ��⠭���� �����襭� +++
rem @echo.
rem @echo   ��⠭������		: !MultiCounterOk!
rem @echo   �� ��⠭������	: %MultiCounterEr%
rem @echo --------------------------------------------
rem @echo.
rem @echo   ���᮪ �� ��⠭�������� �ਫ������ ��࠭�� � %sendtofoldercmdfolder%\notinstalled.txt
rem @echo   ���஡�� ��⠭����� �� ������. ����� ��������, �� � ����� 䠩�� ��� ��⠫���
rem @echo   ���� ��᪫��⥫�� ���� - � �⮬ ��砥 ���஡�� 㤠���� ���.
@echo +++ Installation completed +++
@echo.
@echo   Installed		: !MultiCounterOk!
@echo   Not installed	: %MultiCounterEr%
@echo --------------------------------------------
@echo.
@echo   The list of not installed applications is saved in %sendtofoldercmdfolder%\notinstalled.txt
@echo   Try installing them manually. Also, it's possible that there is an exclamation mark 
@echo   in the file name or directory - if so, try removing it.
@echo.
goto :_exittimeout

:_MultiInstallProcess
set hidefrstp=1^>NUL
set hidescndp=2^>NUL
if not defined applabel exit /b
set /a MultiCounterOk=%MultiCounterOk%+1
rem @echo  %MultiCounterOk%. ��⠭��������  "%applabel%"
@echo %MultiCounterOk%. Installing "%applabel%"
@%MYFILES%\ADB install -r -g --no-streaming "%apkname%" %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (call :_MultiCopyObbInslallApk) else (call :_MultiInstallApkErr)
set applabel=
set pkgname=
exit /b

:_MultiCopyObbInslallApk
if not exist "%PathGame%%pkgname%" call :_MultiInstalledOk && exit /b
@echo --
rem @echo = �����㥬 "%pkgname%" � ��⠫�� OBB �� 諥�..
@echo = Copying "%pkgname%" to the OBB directory on the headset..
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "%PathBeforeObbPath%%pkgname%" /sdcard/Android/obb/ %hidefrstp% %hidescndp%
call :_MultiInstalledOk
exit /b

:_MultiInstallApkErr
@echo.
@echo.
rem @echo  +++ �訡�� ��⠭���� !apknamefile! +++
rem @echo.
rem @echo  == �த������ ��⠭����
@echo  +++ Installation error !apknamefile! +++
@echo.
@echo  == Continuing installation
@echo.
@echo.
set /a MultiCounterEr=%MultiCounterEr%+1
@echo  !apkname! >>%sendtofoldercmdfolder%\notinstalled.txt
exit /b

:_MultiInstalledOk
@echo --
rem @echo = ��⠭������ �ᯥ譮
@echo = Successfully installed
exit /b

:_SingleApkInstall
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
FOR /F "tokens=2 delims='" %%g IN ('@%MYFILES%\aapt2 dump badging !apkname! ^| find "application-label:"') DO set applabel=%%g
@echo -----------------------------------------------
rem @echo = ��⠭�������� "%applabel%"
@echo = Installing "%applabel%"
%MYFILES%\ADB install -r -g %down% --no-streaming !apkname! %hidefrstp% %hidescndp%
@IF !ERRORLEVEL!==0 (call :_SingleCopyObbInslallApk) else (call :_SingleErrInstallApk)
@echo --
rem @echo = ��⠭������ �ᯥ譮
@echo = Successfully installed
@echo ===========================================
echo.
goto :_exittimeout

:_SingleCopyObbInslallApk
if not exist "%PathIncludePathGame%%pkgname%" exit /b
@echo --
rem @echo   �����㥬 "%pkgname%" � ��⠫�� OBB � 諥�...
@echo = Copying "%pkgname%" to the OBB directory on the headset..
@%MYFILES%\ADB shell mkdir -p /sdcard/Android/obb/%pkgname% %hidefrstp% %hidescndp%
@%MYFILES%\ADB push "%PathIncludePathGame%%pkgname%" /sdcard/Android/obb/ %hidefrstp% %hidescndp%
exit /b

:_SingleErrInstallApk
@echo ===========================================
rem @echo 	    +++ �訡�� ��⠭���� +++
@echo +++ Installation Error +++
echo.
@goto _exitout

:_InstallCmdCreate
@echo  ===========================================
rem @echo  = ��⠭���� �� �業��� install.txt
rem @echo.
rem @echo    �᫨ �� �६� ��⠭���� ��������� �訡��,
rem @echo    ��� ���� ����ᠭ� � 䠩� errors.txt � ��⠫��� � ��ன.
@echo = Installation via install.txt script
@echo.
@echo    If errors occur during installation,
@echo    they will be recorded in the errors.txt file in the game directory.
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
rem @echo ^>^>^> ������ ���� ������ ��� ��室� �� �ணࠬ�� ^<^<^<
rem @echo               ��� �������� ���� ᥪ㭤
@echo ^>^>^> Press any key to exit the program ^<^<^< 
@echo           or wait five seconds
@timeout 5 >nul
::@pause >nul
@exit


:_exitout
@echo.
rem @echo ^>^>^> ������ ���� ������ ��� ��室� �� �ணࠬ�� ^<^<^<
@echo ^>^>^> Press any key to exit the program ^<^<^<
@pause >nul
@exit

rem :_DeleteWrongSymbols
rem @for /r %%a in (*.zip) do (
rem set name=%%~nxa
rem call set "name=%%name:(=%%"
rem call set "name=%%name:)=%%"
rem rem call set "name=%%name:!=%%"
rem call set "name=%%name:+=%%"
rem call set "name=%%name: =%%"
rem call set "name=%%name:&=%%"
rem  cmd/v/c ren "%%a" "!name:%%=!"
rem )
rem set installname=%name%
rem set installname=%1
rem exit/b

:_checkdevice
@echo.
rem @echo ADB ����᪠����....
@echo ADB is starting..
@adb devices 1>nul 2>nul
@FOR /F "skip=1 tokens=2" %%G IN ('%sendtofoldercmdfolder%\adb devices ^| find "device"') DO set adbdevices=%%G
@if [%adbdevices%]==[] goto _NF
@cls
exit /b
:_NF
@cls
@echo.
@echo.
@echo.
rem @echo     +++++ ���� �� ������ +++++
@echo     +++++ Headset not found +++++
@echo.
@echo.
@echo.
rem @echo  �஢���� �����쭮� ᮥ������� � �ࠢ��쭮��� ��⠭���� �ࠩ��஢.
rem @echo  ��⥬ ��१������ ��� �ணࠬ�� ᭮��.
@echo  Check the cable connection and the correctness of the driver installation.
@echo  Then restart this program again.
@echo.
@goto _exitout
