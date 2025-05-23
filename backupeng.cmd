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
rem StartRusTextBlock
rem @echo   = Готово. Архивация завершена
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Done. Backup comleted
rem EndEngTextBlock

@echo returnlabel > rlflag.txt
@echo.
@echo   ------------------------------------------------------
@echo.
rem StartRusTextBlock
rem @echo   ^>^>^> Нажмите что-нибудь для возврата в список приложений ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
@echo   ^>^>^> Press any key for return to application list ^<^<^<
rem EndEngTextBlock
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
rem StartRusTextBlock
rem @echo   = Копирование пакета	: !pkgnamef!
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Package copying	: !pkgnamef!
rem EndEngTextBlock
if [%apkbkpproc%]==[1] call :_ApkBackupProcedure
if [%obbbkpproc%]==[1] call :_OBBBackupProcedure
if [%datbkpproc%]==[1] call :_DataBackupProcedure
@echo   -----------------
rem StartRusTextBlock
rem @echo   = Приложение скопировано	: !applabel!
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Application Copied	: !applabel!
rem EndEngTextBlock
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
rem StartRusTextBlock
rem @echo     Копирование OBB	: !pkgnamef!
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = OBB app copying	: !pkgnamef!
rem EndEngTextBlock
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
rem StartRusTextBlock
rem @echo     Копирование данных	: !pkgnamef!
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Data app copying	: !pkgnamef!
rem EndEngTextBlock
if [!applabel!]==[] set applabel=!pkgnamef!
@md "%cd%\Backups\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@%myfiles%\adb pull "/sdcard/Android/data/!pkgnamef!" "%cd%\Backups\!applabel!\data" | findstr /i /c:"permission denied"  1>nul 2>nul

if %errorlevel% == 0 (call :_BackupDataExtractData)

@rd /q "%cd%\Backups\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\data" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!" 1>nul 2>nul
exit /b


:_ViewApkLabelInsideHeadsetPathname

set namelabel=1
set listpackages="!packagename!"

set packagename=!pathname!

:_ViewApkLabelInsideHeadset
setlocal enableextensions enabledelayedexpansion
if [%allappscase%]==[1] (
rem StartRusTextBlock
rem @echo   +++ Выберите только одно приложение +++
rem EndRusTextBlock
rem StartEngTextBlock
@echo   +++ Select only one application +++
rem EndEngTextBlock
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
@del /q /f o.txt 1>nul 2>nul
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
call set "name=%%name:^!=%%"
call set "name=%%name:+=%%"
rem call set "name=%%name: =%%"
call set "name=%%name::=%%"
call set "name=%%name:&=%%"
rem  cmd/v/c ren "%%a" "!name:%%=!"
)
set applabel=%name:~1,-1%
exit /b


:_PressAnyKey
@echo   -------------------------------------------
rem StartRusTextBlock
rem @echo   ^>^>^> Нажмите что-нибудь для возврата в меню приложений ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
@echo   ^>^>^> Press any key for return apps menu ^<^<^<
rem EndEngTextBlock
@pause >nul
exit /b

:_BackupDataExtractData
@echo   ---
rem StartRusTextBlock
rem @echo   +++  Обнаружен запрет доступа. Запущен альтернативный метод бэкапа +++
rem EndRusTextBlock
rem StartEngTextBlock
@echo   +++  Permission denied detected. Launching an alternative backup +++
rem EndEngTextBlock

set noapk=no
set noobb=no
:_BackupDataExtract
rem For backup with apk to stay empty
rem set noapk=
rem For backup with obb to stay empty
rem set noobb=

@rd /s /q "%cd%\Backups\!applabel!\data" 1>nul 2>nul
@rd /s /q "%cd%\Backups\!applabel!" 1>nul 2>nul
@md "%cd%\Backups\!applabel!\data\" 1>nul 2>nul
set datapackagename=!applabel!
set archivename=%datapackagename%.ab

set shscriptname=dataextract.sh
@%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
@%myfiles%\adb shell input keyevent 224

@ping localhost -n 4 1>nul

start /min "" %myfiles%\adb backup -f %archivename% -%noapk%apk -%noobb%obb %datapackagename%

call :_CheckBackupProcessB

@echo   ---
rem StartRusTextBlock
rem @echo   = Старт архивации..
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = AB Backup started..
rem EndEngTextBlock

rem 1>nul
@ping localhost -n 5 1>nul

@%myfiles%\adb shell input keyevent 61
@ping localhost -n 1 1>nul
@%myfiles%\adb shell input keyevent 61
@ping localhost -n 1 1>nul
@%myfiles%\adb shell input keyevent 61
@ping localhost -n 1 1>nul
@%myfiles%\adb shell input keyevent 66
@echo   ---
rem StartRusTextBlock
rem @echo   = Создание бэкапа... 
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Creating AB backup... 
rem EndEngTextBlock

call :_CheckBackupProcess
@echo   ---
rem StartRusTextBlock
rem @echo   = Извлечение данных из файла бэкапа...
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Extracting data from backup file...
rem EndEngTextBlock


:_SendHSExtract
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 /data/local/tmp/%archivename% ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
@%myfiles%\adb push %archivename% /data/local/tmp/ 1>nul 2>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
rem  >log.txt 2>nul
@%myfiles%\adb pull /data/local/tmp/apps/!applabel! "%cd%\Backups\!applabel!\data" 1>nul 2>nul
@%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul

@%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@del /q /f %shscriptname% 1>nul 2>nul
@del /q /f %archivename% 1>nul 2>nul
@echo   ---
rem StartRusTextBlock
rem @echo   = Извлечение данных и копирование завершены
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Data extraction and copying completed
rem EndEngTextBlock

exit /b

:_CheckBackupProcess
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] == [com.android.backupconfirm] (timeout 2 1>nul && goto _CheckBackupProcess) else (exit /b)
)
goto _CheckBackupProcess

:_CheckBackupProcessB
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] NEQ [com.android.backupconfirm] (@timeout 1 1>nul && goto _CheckBackupProcessB) else (exit /b)
)
goto _CheckBackupProcessB

:_ViewABPackageName
@echo.
@echo.
@echo      Backups list
@echo ----------------------------------------------------------
set shscriptname=dataextract.sh
@for /f "delims=" %%a in ('dir /b /a-d *.ab') do (
set archivename=%%~na
rem StartRusTextBlock
rem @echo Имя архива : !archivename!
rem <nul set /p strTemp=Имя пакета : ...Проверка...
rem EndRusTextBlock
rem StartEngTextBlock
@echo Archive Name : !archivename!
<nul set /p strTemp=Package Name : ...Checking...
rem EndEngTextBlock
rem pause > nul
<nul set /p strTemp=                                                               
rem pause > nul
<nul set /p strTemp=

@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 /data/local/tmp/!archivename!.ab ^) ^| tar xfvz - -C /data/local/tmp/ >%shscriptname%
%myfiles%\adb push !archivename!.ab /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell ls -1t /data/local/tmp/apps/ ^| head -1 >log.txt 2>nul
@FOR /F "tokens=*" %%a IN (%cd%\log.txt) DO set viewpn=%%a
rem StartRusTextBlock
rem <nul set /p strTemp=Имя пакета : !viewpn! 
rem EndRusTextBlock
rem StartEngTextBlock
<nul set /p strTemp=Package Name : !viewpn! 
rem EndEngTextBlock
rem @echo   Package Name	: !viewpn!
@echo.
@echo ----------------------------------------------------------
if "%onlyview%" == "" call :_ExtractDataDromABFiles
)
exit /b

rem ===========================

:_ExtractDataDromABFiles
set shscriptname=dataextract.sh
@echo Extracting data from backup file...
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 /data/local/tmp/%archivename% ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
%myfiles%\adb push %archivename% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >log.txt 2>nul
md "%cd%\Backups\%applabel%\data"
%myfiles%\adb pull /data/local/tmp/apps "%cd%\Backups\%applabel%\data" 1>nul 2>nul

del /q /f %cd%\log.txt 1>nul 2>nul
del /q /f %cd%\%shscriptname% 1>nul 2>nul
exit /b


:_BackupsABListViewer
rem StartRusTextBlock
rem @echo   Найденные бэкапы:
rem EndRusTextBlock
rem StartEngTextBlock
@echo   Found backups:
rem EndEngTextBlock
@echo.
@for /f "delims=" %%a in ('dir /b /a-d *.ab') do (
set archivename=%%a
rem set applabel=!archivename!
@echo		!archivename!
)
@echo.
@echo.
exit /b

:_RestoreApplicationDataAB
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul

@for /f "delims=" %%a in ('dir /b /a-d *.ab') do (
set archivename=%%~na
@echo -----------------------------------------------------------
rem StartRusTextBlock
rem @echo  = Восстанавливаем архив	: %_fCyan%!archivename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo  = Restoring archive	: %_fCyan%!archivename!%_fReset%
rem EndEngTextBlock

rem set applabel=!archivename!

rem set archivename=re4.ab


%myfiles%\adb shell input keyevent 224

start /min "" %myfiles%\adb restore !archivename!.ab  1>nul 2>nul

timeout 2 1>nul

%myfiles%\adb shell input keyevent 61
@ping localhost -n 1 1>nul
%myfiles%\adb shell input keyevent 61
@ping localhost -n 1 1>nul
%myfiles%\adb shell input keyevent 61
@ping localhost -n 1 1>nul
%myfiles%\adb shell input keyevent 66

call :_CheckBackupProcessRest
rem @echo  = Успешно
)
timeout 1 1>nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_CheckBackupProcessRest
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] == [com.android.backupconfirm] (timeout 2 1>nul && goto _CheckBackupProcessRest) else (exit /b)
)


:_BackupAB

:_BackupChoises
set pathname=!packagename!
rem set lp=!packagename!
rem for /f "tokens=*" %%a in ('%myfiles%\adb shell pm list packages -f %lp%')
rem for /f "tokens=*" %%a in ('%myfiles%\adb shell pm list packages !packagename!') do (
rem set pkgname=%%a
rem set pathname=!pkgname:~8!
rem @echo pn !pathname!
rem pause
)
rem pause
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
call :_settime
rem set packageslist=-3
set nomode=no
md %cd%\Backups\%dt%
@echo.
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul

@echo   ================================================================
rem StartRusTextBlock
rem @echo       Старт архивации по выбору.  Не прерывайте этот процесс.
rem @echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
@echo       Starting selected archive process. Do not interrupt this process.
@echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ====================================>>ArchiveLog-%dt%.txt
@echo   ================================================================
call :_BackupABProcess
call :_CurrentFileSize
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
exit /b


:_BackupLists
set ListNumber=%choice:~2%

:_BackupListsSelected
cls
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
set nomode=no
call :_settime
md %cd%\Backups\%dt%
@echo.
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
@echo   ================================================================
rem StartRusTextBlock
rem @echo        Старт архивации по списку.  Не прерывайте этот процесс.
rem @echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
@echo        Starting batch archive process. Do not interrupt this process.
rem EndEngTextBlock
@echo   ================================================================
@echo  ====================================>>ArchiveLog-%dt%.txt
for /f "tokens=*" %%a in (%ListNumber%ListForBackups.txt) do (
rem set pkgname=%%a
set pathname=%%a
call :_BackupABProcess
call :_CurrentFileSize
rem call :_CheckBackupProcessAfter
)
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul

exit /b

rem set packageslist=-3
rem set nomode=no



:_BackupAllApps
cls
set "packageslist=-3"
set nomode=no
call :_settime
md %cd%\Backups\%dt%
@echo.
call :_PackagesListApkNameParserFull
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_PackagesListApkNameParserFull
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
@echo   ================================================================
rem StartRusTextBlock
rem @echo         Старт полной архивации.  Не прерывайте этот процесс.
rem @echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
@echo         Starting full archive process. Do not interrupt this process.
@echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo   ================================================================
@echo  ====================================>>ArchiveLog-%dt%.txt
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
for /f "tokens=*" %%a in ('%myfiles%\adb shell pm list packages %packageslist%') do (
set pkgname=%%a
set pathname=!pkgname:~8!
call :_BackupABProcess
call :_CurrentFileSize
rem call :_CheckBackupProcessAfter
)
@move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
exit /b

:_BackupABProcess

rem @echo   ---

rem @ping localhost -n 4 1>nul
@timeout 2 1>nul

rem === All backup
rem @start /min "" %myfiles%\adb backup -f !pathname!.ab -apk -obb !pathname!

rem === Only data backup
@start /min "" %myfiles%\adb backup -f !pathname!.ab  -%nomode%apk -%nomode%obb !pathname!
@echo   ----------------------------------------------
call :_ViewApkLabelInsideHeadsetPN
rem StartRusTextBlock
rem @echo   = Имя приложенния	: %_fBCyan%!applabel!%_fReset%
rem @echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = App name		: %_fBCyan%!applabel!%_fReset%
@echo   = Package name	: %_fCyan%!pathname!%_fReset%
rem EndEngTextBlock
call :_CheckBackupProcessBefore

%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 66
rem @echo   ---
rem StartRusTextBlock
rem @echo   + Создаем архив данных...
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = Creating backup...
rem EndEngTextBlock


:_CheckBackupProcessAfter
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] == [com.android.backupconfirm] (timeout 2 1>nul && goto _CheckBackupProcessAfter) else (exit /b)
)
goto _CheckBackupProcessAfter


:_CheckBackupProcessBefore
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] NEQ [com.android.backupconfirm] (@timeout 1 1>nul && goto _CheckBackupProcessBefore) else (exit /b)
)
exit /b

:_CurrentFileSize
@timeout 7 1>nul
rem pause
for /f "tokens=3" %%a in ('dir /-c "!pathname!.ab" ^| findstr /r /c:"[0-9][0-9]* !pathname!.ab$"') do (
set filesize=%%a
rem pause
if "!filesize!"=="47" (
rem @echo   ---
rem StartRusTextBlock
rem @echo   %_fBYellow%= Файл бэкапа имеет нулевой размер и будет удален%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo   %_fBYellow%= Backup file has zero size and will be delete%_fReset%
rem EndEngTextBlock
@echo !pathname!>>ZeroSizeBackups.txt
del /q /f !pathname!.ab
) else (
if "!filesize!"=="0" (
rem @echo   ---
rem StartRusTextBlock
rem @echo   %_fBYellow%= Файл бэкапа имеет нулевой размер и будет удален%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
@echo   %_fBYellow%= Backup file has zero size and will be delete%_fReset%
rem EndEngTextBlock
@echo !pathname!>>ZeroSizeBackups.txt
del /q /f !pathname!.ab
) else (
rem @echo   ---
rem StartRusTextBlock
rem @echo   %_fBGreen%= Архив создан успешно%_fReset%
rem @echo  Имя приложения		: !applabel!>>ArchiveLog-%dt%.txt
rem @echo  Название пакета	: !pathname!>>ArchiveLog-%dt%.txt
rem @echo  Название архива	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
@echo   = %_fBGreen%Backup !pathname! created successfully%_fReset%
@echo  App name	: !applabel!>>ArchiveLog-%dt%.txt
@echo  Package name	: !pathname!>>ArchiveLog-%dt%.txt
@echo  Archive name	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ------------------------------------>>ArchiveLog-%dt%.txt
call :_DeleteWrongSymbolsOk
@move "!pathname!.ab" "%cd%\Backups\%dt%\!applabel!.ab" 1>nul 2>nul
)
)
)
rem set pathname=
exit /b


rem Old

:_ViewABPackageAppName
setlocal enableextensions enabledelayedexpansion
@echo.
@del /q /f ArchivesList.txt 1>nul 2>nul
rem StartRusTextBlock
rem @echo    Список найденных бэкапов:
rem @echo.>>ArchivesList.txt
rem @echo   Список архивов>>ArchivesList.txt
rem EndRusTextBlock
rem StartEngTextBlock
@echo    List of found backups:
@echo   Archives List>>ArchivesList.txt
@echo.>>ArchivesList.txt
rem EndEngTextBlock
@echo   ==================================>>ArchivesList.txt
@echo   ==================================
rem @echo   ----------------------------------
set shscriptname=dataextract.sh
@for /f "delims=" %%a in ('dir /b /a-d *.ab') do (
set "archivename=%%~na"
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/!archivename!.ab" ^) ^| tar xfvz - -C /data/local/tmp/ >%shscriptname%
%myfiles%\adb push "!archivename!.ab" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell ls -1t /data/local/tmp/apps/ ^| head -1 >log.txt 2>nul
rem @timeout 2 1>nul
@FOR /F "tokens=*" %%k IN (%cd%\log.txt) DO set viewpn=%%k
rem call :_ViewApkLabelInsideHeadsetPN
rem @echo   Имя прил	: !applabel!  
rem StartRusTextBlock
rem @echo   Имя файла	: !archivename!>>ArchivesList.txt
rem @echo   Имя пакета	: !viewpn!>>ArchivesList.txt
rem @echo   ---------------------------------->>ArchivesList.txt
rem @echo   Имя архива	: !archivename!  
rem @echo   Имя пакета	: !viewpn!
rem EndRusTextBlock
rem StartEngTextBlock
@echo   File name	: !archivename!>>ArchivesList.txt
@echo   Packaje name	: !viewpn!>>ArchivesList.txt
@echo   ---------------------------------->>ArchivesList.txt
@echo   Archive name	: !archivename!  
@echo   Package name	: !viewpn!
rem EndEngTextBlock
@echo   ----------------------------------
set viewpn=
set archivename=
rem set applabel=
%MYFILES%\adb shell rm -R /data/local/tmp 1>nul 2>nul
rem %MYFILES%\adb shell rm /data/local/tmp
)
del /q /f %cd%\log.txt 1>nul 2>nul
del /q /f %cd%\%shscriptname% 1>nul 2>nul
exit /b

:_ViewApkLabelInsideHeadsetPN

set lp=!pathname!

set shscriptname=aaptname.sh
@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %lp% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
@echo     printf "app $label;$line\n";>>%shscriptname%
rem @echo     printf "\n";>>%shscriptname%
@echo done>>%shscriptname%
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname%
@%myfiles%\adb push %myfiles%\aapt-arm-pie2 /data/local/tmp/ 1>nul
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
rem call :_ViewAppLabel
)
)
@del /q /f o.txt 1>nul 2>nul
@del /q %shscriptname%
exit /b

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

rem ver 4.3.1.4

