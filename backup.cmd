@echo off
call :%*
exit /b

:_BackupBegin
@chcp 65001 >nul

setlocal enableextensions enabledelayedexpansion
@md Backups 1>nul 2>nul

@if [%allappscase%]==[1] (
call :_AllApplications
) else (
set lp=!packagename!
call :_PackagesListApkNameParser
)
@echo   ==========================================================================
@echo.
@echo   = Done. Backup comleted
@echo returnlabel > rlflag.txt
@echo.
@echo   ------------------------------------------------------
@echo.
@echo   ^>^>^> Press any key for return to application list ^<^<^<
@pause >nul
exit

:_PackagesListApkNameParser
for /f "tokens=*" %%a in ('%myfiles%\adb shell pm list packages -f %lp%') do (
set pkgname=%%a
set pathname=!pkgname:~8!
@for /f "tokens=1,2,3,4,5,6 delims=/,=" %%a in ("!pathname!") do (
set pkgnamea=%%a
set pkgnameb=%%b
set pkgnamec=%%c
set pkgnamed=%%d
set pkgnamee=%%e
set pkgnamef=%%f
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec!==/!pkgnamed!==/!pkgnamee! !pkgnamef!"
if [!pkgnamef!]==[] exit /b
@echo.
@echo   --------------------------------------------------------------------------
@echo.
@echo   = Package copying	: !pkgnamef!
if [%apkbkpproc%]==[1] call :_ApkBackupProcedure
if [%obbbkpproc%]==[1] call :_OBBBackupProcedure
if [%datbkpproc%]==[1] call :_DataBackupProcedure
@echo   -----------------
@echo   = Application Copied	: !applabel!
set applabel=
)
)
exit /b


:_ApkBackupProcedure
if [!pkgnamef!]==[] exit /b
%myfiles%\adb pull -a !fullname!.apk  2>nul 1>nul
@FOR /F "tokens=2 delims='" %%g IN ('%myfiles%\aapt2 dump badging "!pkgnamef!.apk" 2^>nul ^| findstr /i /c:"application-label:"') DO set applabel=%%g
if [!applabel!]==[] set applabel=!pkgnamef!
if [!pkgnamef!]==[] exit /b
call :_DeleteWrongSymbolsOk
@ren %cd%\!pkgnamef!.apk "!applabel!.apk" 2>nul 1>nul
@md "Backups\!applabel!" 2>nul 1>nul
@move "!applabel!.apk" "Backups\!applabel!" 1>nul 2>nul
exit /b

:_OBBBackupProcedure
if [!pkgnamef!]==[] exit /b
@echo   ---
@echo   = OBB app copying	: !pkgnamef!
if [!applabel!]==[] set applabel=!pkgnamef!
@md "%cd%\Backups\!applabel!\obb\!pkgnamef!" 1>nul 2>nul
%myfiles%\adb pull "/sdcard/Android/obb/!pkgnamef!" "%cd%\Backups\!applabel!\obb" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\obb\!pkgnamef!" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\obb" 1>nul 2>nul
if "!pkgnamef!"=="com.beatgames.beatsaber" @%myfiles%\adb pull "/sdcard/ModData" "Backups\!applabel!\ModData" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.doom3quest" @%myfiles%\adb pull "/sdcard/Doom3Quest" "Backups\!applabel!\Doom3Quest" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.jkxr" @%myfiles%\adb pull "/sdcard/JKXR/" "Backups\!applabel!\JKXR" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.lambda1vr" @%myfiles%\adb pull "/sdcard/XASH/" "Backups\!applabel!\XASH" 1>nul 2>nul
exit /b

:_DataBackupProcedure
if [!pkgnamef!]==[] exit /b
@echo   ---
@echo   = Data app copying	: !pkgnamef!
if [!applabel!]==[] set applabel=!pkgnamef!
@md "%cd%\Backups\!applabel!\data\!pkgnamef!" 1>nul 2>nul
%myfiles%\adb pull "/sdcard/Android/data/!pkgnamef!" "%cd%\Backups\!applabel!\data" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\data" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!" 1>nul 2>nul
exit /b


:_ViewApkLabelInsideHeadset
setlocal enableextensions enabledelayedexpansion
if [%allappscase%]==[1] (
@echo   +++ Select only one application +++
@echo.
call :_PressAnyKey
exit /b
) else (
set lp=!packagename!
)

set shscriptname=aaptname.sh
@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %lp% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
@echo     printf "app $label;$line\n";>>%shscriptname%
rem @echo     printf "\n";>>%shscriptname%
@echo done>>%shscriptname%
@%myfiles%\adb push %myfiles%\aapt-arm-pie2 /data/local/tmp/ 1>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb shell chmod 0755 /data/local/tmp/aapt-arm-pie2
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >o.txt 2>nul

@for /f "tokens=*" %%A in ('type o.txt ^| sort') do (
    set "line=%%A"
    set "line=!line:app =!"
    set "line=!line:&=-!"
@for /f "tokens=1,2 delims=;" %%A in ("!line!") do (
set applabel=%%A
set pkgnamef=%%B
if [!pkgnamef!]==[] set pkgnamef=!applabel!
call :_ViewAppLabel
)
)
@del /q o.txt 
@del /q %shscriptname%
exit /b

:_ViewAppLabel
@echo   -------------------------------------------
@echo.
@echo   = Package name	: !pkgnamef!
@echo   = Application name	: !applabel!
@echo.
@echo   = Application status:
@echo.
@for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13" %%a in ('@%MYFILES%\adb shell dumpsys package !pkgnamef! ^| findstr /i /c:"User 0: ceDataInode"') do (
@echo       %%d
@echo       %%e
@echo       %%f
@echo       %%h
@echo       %%i
@echo       %%j
@echo       %%k
@echo       %%l
)
@echo   ---
@echo    If the application name matches the package name,
@echo    it means the application has no name.
exit /b

:_AllApplications
set lp=
setlocal enableextensions enabledelayedexpansion
@for /f "tokens=*" %%a in (packages-list.txt) do (
set lppkgname=%%a
set lp=!lppkgname:~8!
call :_PackagesListApkNameParser
)
exit /b


:_DeleteWrongSymbolsOk
set "apknametest=%applabel%"
@for %%a in ("%apknametest%") do (
@set name=%%a
call set "name=%%name:(=%%"
call set "name=%%name:)=%%"
rem call set "name=%%name:!=%%"
rem call set "name=%%name:+=%%"
rem call set "name=%%name: =%%"
call set "name=%%name::=%%"
call set "name=%%name:&=%%"
)
set applabel=%name:~1,-1%
exit /b

:_PressAnyKey
@echo   -------------------------------------------
@echo   ^>^>^> Press any key for return apps menu ^<^<^<
@pause >nul
exit /b
