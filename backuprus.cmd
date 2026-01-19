@echo off
call :%*
exit /b

:_BackupBegin
rem call :_BakdirCreateBackupsCmd

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
@echo   = Готово. Архивация завершена
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Done. Backup comleted
rem EndEngTextBlock

@echo returnlabel > rlflag.txt
@echo.
@echo   ------------------------------------------------------
@echo.
rem StartRusTextBlock
@echo   ^>^>^> Нажмите что-нибудь для возврата в список приложений ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ^>^>^> Press any key for return to application list ^<^<^<
rem EndEngTextBlock
@pause >nul
exit

:_PackagesListApkNameParser
call :_BakdirCreateBackupsCmd
@del /q /f NotCopiedAPK.txt 1>nul 2>nul
cls
@echo.
@echo       ================================================================
rem StartRusTextBlock
@echo      %_fBYellow%Старт архивации.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       %_fBYellow%Starting selected archive process. Do not interrupt this process.%_fReset%
rem @echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
setlocal enableextensions enabledelayedexpansion
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (

set applabel=%%a
set pathname=%%b
if not defined pathname set pathname=!applabel!
rem StartRusTextBlock
@echo   ----------------------------------------------------------------
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name	: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name		: %_fCyan%!pathname!%_fReset%
rem EndEngTextBlock

for /f "tokens=*" %%a in ('%myfiles%\adb shell pm list packages -f !pathname!') do (
set pkgname=%%a
set pname=!pkgname:~8!

@for /f "tokens=1,2,3,4,5,6 delims=/,=" %%a in ("!pname!") do (
set pkgnamea=%%a
set pkgnameb=%%b
set pkgnamec=%%c
set pkgnamed=%%d
set pkgnamee=%%e
set pkgnamef=%%f

if !pkgnamea! == data (
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec!==/!pkgnamed!==/!pkgnamee! !pkgnamef!"
) else (
if !pkgnamea! == apex (
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec!/!pkgnamed!/!pkgnamee! !pkgnamef!"
) else (
if !pkgnameb! == overlay (
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec! !pkgnamed!"
set pkgnamef=!pkgnamed!
) else (
if !pkgnamea! == vendor (
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec!/!pkgnamed! !pkgnamee!"
set pkgnamef=!pkgnamee!
) else (
if !pkgnameb! == framework (
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec! !pkgnamed!"
set pkgnamef=!pkgnamed!
) else (
set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec!/!pkgnamed! !pkgnamee!"
set pkgnamef=!pkgnamee!
)
)
)
)
)
)

rem set "fullname=/!pkgnamea!/!pkgnameb!/!pkgnamec!==/!pkgnamed!==/!pkgnamee! !pkgnamef!"
if [!pkgnamef!]==[] exit /b
if [%apkbkpproc%]==[1] call :_ApkBackupProcedure
if [%obbbkpproc%]==[1] call :_OBBBackupProcedure
if [%datbkpproc%]==[1] call :_DataBackupProcedure
rem StartRusTextBlock
@echo   %_fBGreen%= Обработка приложения завершена%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Application processing completed%_fReset%
rem EndEngTextBlock
)
)
)
@md %bakdir%\Logs 1>nul 2>nul
@move "ArchiveLog-%dt%.txt" "%bakdir%\Logs\ArchiveLog-%dt%.txt" 1>nul 2>nul
exit /b


:_ApkBackupProcedure
if !pkgnamea! == android exit /b
if [!pkgnamef!]==[] exit /b
rem StartRusTextBlock
@echo   + Копирование APK...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   + APK file copying...
rem EndEngTextBlock
%myfiles%\adb pull -a !fullname!.apk  2>nul 1>nul
if errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBRed%- Не удалось скопировать файл APK%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%- Failed to copy APK file%_fReset%
rem EndEngTextBlock
@echo !fullname!.apk >> NotCopiedAPK.txt
) else (
rem StartRusTextBlock
@echo   %_fBGreen%= Файл APK скопирован успешно%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= APK file copied successfully%_fReset%
rem EndEngTextBlock
rem @echo !applabel! !pkgnamef!.apk >> CopiedAPK.txt
)
rem @FOR /F "tokens=2 delims='" %%g IN ('%myfiles%\aapt2 dump badging "!pkgnamef!.apk" 2^>nul ^| findstr /i /c:"application-label:"') DO set applabel=%%g
if [!applabel!]==[] set applabel=!pkgnamef!
if [!pkgnamef!]==[] exit /b
call :_DeleteWrongSymbolsOk
@md "%bakdir%\%dt%\!applabel!" 2>nul 1>nul
rem @ren %cd%\!pkgnamef!.apk "!applabel!.apk" 2>nul 1>nul
move "!pkgnamef!.apk" "%bakdir%\%dt%\!applabel!\!applabel!.apk" 1>nul 2>nul

rem @move "!pkgnamef!.apk" "Backups\!applabel!" 1>nul 2>nul
rem @move "!applabel!.apk" "Backups\!applabel!" 1>nul 2>nul
rem @timeout 1 >nul
exit /b

:_OBBBackupProcedure
if [!pkgnamef!]==[] exit /b
rem StartRusTextBlock
@echo   + Копирование OBB...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = OBB app copying
rem EndEngTextBlock
if [!applabel!]==[] set applabel=!pkgnamef!
@md "%bakdir%\%dt%\!applabel!\obb\!pkgnamef!" 1>nul 2>nul
%myfiles%\adb pull "/sdcard/Android/obb/!pkgnamef!" "%bakdir%\%dt%\!applabel!\obb" 1>nul 2>nul
rem if exist "%cd%\Backups\!applabel!\obb\!pkgnamef!\" (
rem     dir /b /a "%cd%\Backups\!applabel!\obb\!pkgnamef!\" | findstr . >nul && (rem) || @echo   %_fBYellow%- OBB отсутствует%_fReset%
rem ) else (
rem     @echo %_fBYellow%- Папка OBB не найдена%_fReset%
rem )
rem StartRusTextBlock
dir /b /a "%bakdir%\%dt%\!applabel!\obb\!pkgnamef!\" | findstr . >nul 
if errorlevel 1 (
@echo   %_fBYellow%- OBB отсутствует%_fReset%
) else (
@echo   %_fBGreen%= Каталог OBB скопирован успешно%_fReset%
)
rem EndRusTextBlock
rem && ver >nul | @echo   %_fBGreen%= Каталог OBB скопирован успешно%_fReset% || @echo   %_fBYellow%- OBB отсутствует%_fReset%
rem StartEngTextBlock
rem dir /b /a "%bakdir%\%dt%\!applabel!\obb\!pkgnamef!\" | findstr . >nul 
rem if errorlevel 1 (
rem @echo   %_fBYellow%- OBB is missing%_fReset%
rem ) else (
rem @echo   %_fBGreen%= OBB folder copied successfully%_fReset%
rem )
rem EndEngTextBlock
rem dir /b /a "%cd%\Backups\!applabel!\obb\!pkgnamef!\" | findstr . >nul && ver >nul || @echo   %_fBYellow%- OBB is missing%_fReset%


@rd /q "%bakdir%\%dt%\!applabel!\obb\!pkgnamef!" 1>nul 2>nul
@rd /q "%bakdir%\%dt%\!applabel!\obb" 1>nul 2>nul
if "!pkgnamef!"=="com.beatgames.beatsaber" @%myfiles%\adb pull "/sdcard/ModData" "%bakdir%\%dt%\!applabel!\ModData" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.doom3quest" @%myfiles%\adb pull "/sdcard/Doom3Quest" "%bakdir%\%dt%\!applabel!\Doom3Quest" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.jkxr" @%myfiles%\adb pull "/sdcard/JKXR/" "%bakdir%\%dt%\!applabel!\JKXR" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.lambda1vr" @%myfiles%\adb pull "/sdcard/XASH/" "%bakdir%\%dt%\!applabel!\XASH" 1>nul 2>nul
rem @echo   %_fBGreen%= Каталог OBB скопирован успешно%_fReset%
exit /b

:_DataBackupProcedure
if [!pkgnamef!]==[] exit /b
rem StartRusTextBlock
@echo   + Копирование данных...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Data app copying	
rem EndEngTextBlock
if [!applabel!]==[] set applabel=!pkgnamef!
@md "%bakdir%\%dt%\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@%myfiles%\adb pull "/sdcard/Android/data/!pkgnamef!" "%bakdir%\%dt%\!applabel!\data" | findstr /i /c:"permission denied"  1>nul 2>nul
if %errorlevel% == 0 (call :_BackupDataExtractData)
rem StartRusTextBlock
dir /b /a "%bakdir%\%dt%\!applabel!\data\" 2>nul | findstr . >nul && ver >nul || @echo   %_fBYellow%- Данные отсутствуют%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem dir /b /a "%cd%\Backups\!applabel!\data\" 2>nul | findstr . >nul && ver >nul || @echo   %_fBYellow%- Data is missing%_fReset%
rem EndEngTextBlock
@rd /q "%bakdir%\%dt%\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@rd /q "%bakdir%\%dt%\!applabel!\data" 1>nul 2>nul
) else (
rem StartRusTextBlock
@echo   %_fBGreen%= Каталог с данными скопирован успешно%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Data directory copied successfully%_fReset%
rem EndEngTextBlock
)
exit /b


:_ViewApkLabelInsideHeadsetPathname

set namelabel=1
set listpackages="!packagename!"

set "packagename=!pathname!"

:_ViewApkLabelInsideHeadset
setlocal enableextensions enabledelayedexpansion

set shscriptname=aaptname.sh
@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %lp% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
@echo     printf "$label;$line\n";>>%shscriptname%
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
if [!pkgnamef!]==[] set "pkgnamef=!applabel!"
call :_ViewAppLabel
)
)
@del /q /f o.txt 1>nul 2>nul
@del /q %shscriptname%
exit /b

:_ViewAppLabel
cls
setlocal enableextensions enabledelayedexpansion
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
if not defined pathname set pathname=!applabel!
)
@echo.
@echo.
@echo.
@echo.
@echo   -------------------------------------------
@echo.
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo.
@echo   = %_fBYellow%Статус приложения:%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name	: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name		: %_fCyan%!pathname!%_fReset%
rem @echo.
rem @echo   = %_fBYellow%Application status:%_fReset%
rem EndEngTextBlock
@echo.
@for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13" %%a in ('@%MYFILES%\adb shell dumpsys package !pathname! ^| findstr /i /c:"User 0: ceDataInode"') do (
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
rem StartRusTextBlock
@echo    Если имя приложения совпадает с именем пакета,
@echo    значит у приложения нет имени
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    If the application name matches the package name,
rem @echo    it means the application has no name.
rem EndEngTextBlock
call :_BackupPrevMenu
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
@echo   ^>^>^> Нажмите что-нибудь для возврата в меню приложений ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ^>^>^> Press any key for return apps menu ^<^<^<
rem EndEngTextBlock
@pause >nul
exit /b

:_BackupDataExtractData
rem @echo   ---
rem StartRusTextBlock
@echo   %_fBYellow%^^! Обнаружен запрет доступа. Запущен альтернативный метод бэкапа +++%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   +++  Permission denied detected. Launching an alternative backup +++
rem EndEngTextBlock

set noapk=no
set noobb=no
:_BackupDataExtract
@%MYFILES%\adb shell am force-stop com.android.backupconfirm 1>nul 2>nul

rem For backup with apk to stay empty
rem set noapk=
rem For backup with obb to stay empty
rem set noobb=

@rd /s /q "%bakdir%\%dt%\!applabel!\data" 1>nul 2>nul
rem @rd /s /q "%cd%\Backups\!applabel!" 1>nul 2>nul
@md "%bakdir%\%dt%\!applabel!\data\" 1>nul 2>nul
rem set "datapackagename=!applabel!"
set "datapackagename=!pathname!"
set "archivename=%datapackagename%.ab"

set shscriptname=dataextract.sh
@%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
@%myfiles%\adb shell input keyevent 224

@timeout 4 1>nul

start /min "" %myfiles%\adb backup -f "%datapackagename%.ab" -%noapk%apk -%noobb%obb "%datapackagename%"

call :_CheckBackupProcessB

rem StartRusTextBlock
@echo   + Старт архивации данных..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = AB Backup started..
rem EndEngTextBlock

rem 1>nul
timeout 4 1>nul

@%myfiles%\adb shell input keyevent 61
timeout 1 1>nul
@%myfiles%\adb shell input keyevent 61
timeout 1 1>nul
@%myfiles%\adb shell input keyevent 61
timeout 1 1>nul
@%myfiles%\adb shell input keyevent 66
rem @echo   ---
rem StartRusTextBlock
@echo   + Создание бэкапа... 
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Creating AB backup... 
rem EndEngTextBlock
call :_CheckBackupProcess
rem StartRusTextBlock
@echo   + Извлечение данных из файла бэкапа...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Extracting data from backup file...
rem EndEngTextBlock


:_SendHSExtract
timeout 3 >nul
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/%datapackagename%.ab" ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
@%myfiles%\adb push "%datapackagename%.ab" /data/local/tmp/  1>nul 2>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
rem  >log.txt 2>nul
@%myfiles%\adb pull "/data/local/tmp/apps/%datapackagename%" "%bakdir%\%dt%\!applabel!\data" 1>nul 2>nul

@%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul

@%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@del /q /f %shscriptname% 1>nul 2>nul
@del /q /f "%archivename%" 1>nul 2>nul
rem StartRusTextBlock
@echo   = Извлечение данных и копирование завершены
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Data extraction and copying completed
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
@echo Имя архива : !archivename!
<nul set /p strTemp=Имя пакета : ...Проверка...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo Archive Name : !archivename!
rem <nul set /p strTemp=Package Name : ...Checking...
rem EndEngTextBlock
rem pause > nul
<nul set /p strTemp=                                                               
rem pause > nul
<nul set /p strTemp=

@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/!archivename!.ab" ^) ^| tar xfvz - -C /data/local/tmp/ >%shscriptname%
%myfiles%\adb push "!archivename!.ab" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell ls -1t /data/local/tmp/apps/ ^| head -1 >log.txt 2>nul
@FOR /F "tokens=*" %%a IN (%cd%\log.txt) DO set viewpn=%%a
rem StartRusTextBlock
<nul set /p strTemp=Имя пакета : !viewpn! 
rem EndRusTextBlock
rem StartEngTextBlock
rem <nul set /p strTemp=Package Name : !viewpn! 
rem EndEngTextBlock
rem @echo   Package Name	: !viewpn!
@echo.
@echo ----------------------------------------------------------
if "%onlyview%" == "" call :_ExtractDataFromABFiles
)
exit /b

rem ===========================

:_ExtractDataFromABFiles
echo %archivename%
echo %bakdir%
pause
set shscriptname=dataextract.sh
@echo Extracting data from backup file...
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/%archivename%" ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
%myfiles%\adb push "%archivename%" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >log.txt 2>nul
md "%bakdir%\%dt%\%applabel%\data"
%myfiles%\adb pull /data/local/tmp/apps "%bakdir%\%dt%\%applabel%\data" 1>nul 2>nul

del /q /f "%cd%\log.txt" 1>nul 2>nul
del /q /f "%cd%\%shscriptname%" 1>nul 2>nul
exit /b


:_BackupsABListViewer
rem StartRusTextBlock
@echo   Найденные бэкапы:
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   Found backups:
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
@%MYFILES%\adb shell am force-stop com.android.backupconfirm 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
@timeout 5 >nul
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul

@for /f "delims=" %%a in ('dir /b /a-d *.ab') do (
set "archivename=%%~na"

@echo -----------------------------------------------------------
rem StartRusTextBlock
@echo  = Восстанавливаем архив	: %_fBCyan%!archivename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Restoring archive	: %_fCyan%!archivename!%_fReset%
rem EndEngTextBlock

%myfiles%\adb shell input keyevent 224

start /min "" %myfiles%\adb restore "!archivename!.ab" 1>nul 2>>RestoreErrors.txt
@timeout 2 1>nul
rem for %%A in ("RestoreErrors.txt") do set "filesize=%%~zA"
rem if [%filesize%] GTR 3 (
rem @echo. >>RestoreErrors.txt
rem @echo  %_fBRed%= Произошла ошибка. Текст ошибки записан в файл RestoreErrors.txt%_fReset%
rem @echo.
rem ) else (
rem if %restfilesize% LSS 3 (
rem @del /q /f RestoreErrors.txt 1>nul 2>nul
rem ) else (
rem @echo.
rem )
rem )

%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
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



:_BackupReadWrite
call :_BakdirCreateBackupsCmd
cls
rem @echo.
@echo.
rem call :_BackupsDirChoice
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
call :_settime
set nomode=no
@md %bakdir%\%dt% 2>nul 1>nul
@md %bakdir%\Logs 2>nul 1>nul
%myfiles%\adb shell input keyevent 224
rem StartRusTextBlock
@echo      %_fBYellow%Снимаем запрет доступа к файлам сохранений%_fReset%
@echo   ================================================================
@echo   %_fBYellow%= Сначала бэкапим...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Removing the restriction on access to save files%_fReset%
rem @echo   ================================================================
rem @echo   %_fBYellow%= Backing up first...%_fReset%
rem EndEngTextBlock
@timeout 4 1>nul
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
set applabelmark=1
call :_BackupABProcessPS
set applabel=!applabelsave!
call :_CurrentFileSizeBigger
rem call :_CurrentFileSize
)
if not exist "%bakdir%\%dt%\!applabel!.ab" set dataout=1&&exit /b
rem if not exist !pathname! set dataout=1&&exit /b
if defined bakcuperror (
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b
) else (
call :_RestoreReadWrite
)


rem @move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_RestoreReadWrite
@echo   ----------------------------------------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Затем восстанавливаем обратно...%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Then restoring back...%_fReset%
rem EndEngTextBlock

%myfiles%\adb shell input keyevent 224

start /min "" %myfiles%\adb restore "!pathname!.ab" 1>nul 2>nul
@timeout 2 1>nul

%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
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


:_BackupChoises
cls
rem @echo.
@echo.
rem call :_BackupsDirChoice
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
call :_settime
set nomode=no
@md %bakdir%\%dt% 2>nul 1>nul
@md %bakdir%\Logs 2>nul 1>nul

rem md "%cd%\Backups\%dt%" 1>nul 2>nul
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
@echo       ================================================================
rem StartRusTextBlock
@echo      %_fBYellow%Старт архивации по выбору.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       %_fBYellow%Starting selected archive process. Do not interrupt this process.%_fReset%
rem @echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ====================================>>ArchiveLog-%dt%.txt
call :_MultiStringMessagesOutput
@timeout 4 1>nul
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
set applabelmark=1
call :_BackupABProcessPS
set applabel=!applabelsave!
rem call :_BackupsDirChoice
rem echo bdr !bakdir!
rem echo bdr %bakdir%
rem pause
call :_CurrentFileSizeBigger
rem call :_CurrentFileSize
)
@move "ArchiveLog-%dt%.txt" "%bakdir%\Logs\ArchiveLog-%dt%.txt" 1>nul 2>nul
rem @move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
del /q /f packages-list.txt 1>nul 2>nul
exit /b


:_BackupABProcessPS
@%MYFILES%\adb shell am force-stop com.android.backupconfirm 1>nul 2>nul
@start /min "" %myfiles%\adb backup -f "!pathname!.ab"  -%nomode%apk -%nomode%obb "!pathname!"
@echo   ----------------------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложенния	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = App name		: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name		: %_fCyan%!pathname!%_fReset%
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
@echo   + Создаем архив данных...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Creating backup...
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


:_BackupLists
set ListNumber=%choice:~2%
:_BackupListsSelected
cls
rem call :_BackupsDirChoice
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
set nomode=no
call :_settime
@md %bakdir%\%dt% 2>nul 1>nul
@md %bakdir%\Logs 2>nul 1>nul

rem md "%cd%\Backups\%dt%"
@echo.
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
@echo       ================================================================
rem StartRusTextBlock
@echo        %_fBYellow%Старт архивации по списку.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        %_fBYellow%Starting batch archive process. Do not interrupt this process.%_fReset%
rem @echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ====================================>>ArchiveLog-%dt%.txt
@timeout 4 1>nul
rem for /f "tokens=*" %%a in (%ListNumber%ListForBackups.txt) do (
rem set pathname=%%a

rem call :_BackupABProcess
rem call :_CurrentFileSizeBigger

rem )


for /f "usebackq delims=" %%a in ("%ListNumber%ListForBackups.txt") do (
    set "line=%%a"
    rem Проверяем первый символ
    if not "!line:~0,1!"=="#" (
        set "pathname=!line!"
        call :_BackupABProcess
        call :_CurrentFileSizeBigger
    )
)

@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@move "ArchiveLog-%dt%.txt" "%bakdir%\Logs\ArchiveLog-%dt%.txt" 1>nul 2>nul
rem @move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
del /q /f packages-list.txt 1>nul 2>nul
exit /b


:_BackupAllApps
cls
set "packageslist=-3"
set nomode=no
call :_settime
@md %bakdir%\%dt% 2>nul 1>nul
@md %bakdir%\Logs 2>nul 1>nul

rem md "%cd%\Backups\%dt%"
@echo.
call :_PackagesListApkNameParserFull
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_PackagesListApkNameParserFull
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
@echo       ================================================================
rem StartRusTextBlock
@echo         %_fBYellow%Старт полной архивации.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         %_fBYellow%Starting full archive process. Do not interrupt this process.%_fReset%
rem @echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ====================================>>ArchiveLog-%dt%.txt
@timeout 4 1>nul
for /f "tokens=*" %%a in ('%myfiles%\adb shell pm list packages %packageslist%') do (
set pkgname=%%a
set pathname=!pkgname:~8!
call :_BackupABProcess
call :_CurrentFileSizeBigger
rem call :_CurrentFileSize
rem call :_CheckBackupProcessAfter
)
rem @move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
@move "ArchiveLog-%dt%.txt" "%bakdir%\Logs\ArchiveLog-%dt%.txt" 1>nul 2>nul
exit /b

:_BackupABProcess
@%MYFILES%\adb shell am force-stop com.android.backupconfirm 1>nul 2>nul
@start /min "" %myfiles%\adb backup -f "!pathname!.ab"  -%nomode%apk -%nomode%obb "!pathname!"
@echo   ----------------------------------------------------------------
if not defined applabelmark call :_ViewApkLabelInsideHeadsetPN
rem StartRusTextBlock
@echo   = Имя приложенния	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = App name		: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name		: %_fCyan%!pathname!%_fReset%
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
@echo   + Создаем архив данных...
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Creating backup...
rem EndEngTextBlock


:_CheckBackupProcessAfter
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] == [com.android.backupconfirm] (timeout 1 1>nul && goto _CheckBackupProcessAfter) else (exit /b)
)
goto _CheckBackupProcessAfter


:_CheckBackupProcessBefore
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] NEQ [com.android.backupconfirm] (@timeout 1 1>nul && goto _CheckBackupProcessBefore) else (exit /b)
)
exit /b

:_CurrentFileSize
@timeout 8 1>nul
for /f "tokens=3" %%a in ('dir /-c "!pathname!.ab" ^| findstr /r /c:"[0-9][0-9]* !pathname!.ab$"') do (
set filesize=%%a
rem pause
if "!filesize!"=="47" (
rem @echo   ---
rem StartRusTextBlock
@echo   %_fBYellow%= Файл бэкапа имеет нулевой размер и будет удален%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Backup file has zero size and will be delete%_fReset%
rem EndEngTextBlock
@echo !pathname!>>ZeroSizeBackups.txt
del /q /f "!pathname!.ab"
) else (
if "!filesize!"=="0" (
rem @echo   ---
rem StartRusTextBlock
@echo   %_fBYellow%= Файл бэкапа имеет нулевой размер и будет удален%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Backup file has zero size and will be delete%_fReset%
rem EndEngTextBlock
@echo !pathname!>>ZeroSizeBackups.txt
del /q /f "!pathname!.ab"
) else (
rem StartRusTextBlock
@echo   %_fBGreen%= Архив создан успешно%_fReset%
@echo  Имя приложения	: !applabel!>>ArchiveLog-%dt%.txt
@echo  Название пакета	: !pathname!>>ArchiveLog-%dt%.txt
@echo  Название архива	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = %_fBGreen%Backup created successfully%_fReset%
rem @echo  App name	: !applabel!>>ArchiveLog-%dt%.txt
rem @echo  Package name	: !pathname!>>ArchiveLog-%dt%.txt
rem @echo  Archive name	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ------------------------------------>>ArchiveLog-%dt%.txt
call :_DeleteWrongSymbolsOk
pause
@move "!pathname!.ab" "%bakdir%\%dt%\!applabel!.ab" 1>nul 2>nul
)
)
)
exit /b

:_CurrentFileSizeBigger
set bakcuperror=
rem powershell -ExecutionPolicy Bypass -File %myfiles%\checkab.ps1 -FilePath "!pathname!.ab" -LogPath "backup_check.log"
for /f %%S in ('powershell -ExecutionPolicy Bypass -File %myfiles%\checkab.ps1 -FilePath "!pathname!.ab"') do (
set filesize=%%S
)
rem for /f "tokens=3" %%a in ('dir /-c "!pathname!.ab" ^| findstr /r /c:"[0-9][0-9]* !pathname!.ab$"') do (
rem set filesize=%%a
if not defined filesize exit /b
if !filesize! GTR 48 (
call :_DeleteWrongSymbolsOk
@move "!pathname!.ab" "%bakdir%\%dt%\!applabel!.ab" 1>nul 2>nul
if exist "%bakdir%\%dt%\!applabel!.ab" (
rem StartRusTextBlock
@echo   %_fBGreen%= Архив создан успешно%_fReset%
@echo  Название архива	: !applabel!.ab>>ArchiveLog-%dt%.txt
@echo  Имя приложения		: !applabel!>>ArchiveLog-%dt%.txt
@echo  Название пакета	: !pathname!>>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = %_fBGreen%Backup created successfully%_fReset%
rem @echo  App name	: !applabel!>>ArchiveLog-%dt%.txt
rem @echo  Package name	: !pathname!>>ArchiveLog-%dt%.txt
rem @echo  Archive name	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ------------------------------------>>ArchiveLog-%dt%.txt
) else (
rem StartRusTextBlock
set bakcuperror=1
@echo   %_fRed%= Не удалось создать бэкап%_fReset%
pause
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fRed%= Failed to create backup%_fReset%
rem EndEngTextBlock
)
rem @move "!pathname!.ab" "%cd%\Backups\%dt%\!applabel!.ab" 1>nul 2>nul
exit /b
) else (
if "!filesize!"=="47" (
rem @echo   ---
set bakcuperror=1
rem StartRusTextBlock
@echo   %_fBYellow%= Файл бэкапа имеет нулевой размер и будет удален%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Backup file has zero size and will be delete%_fReset%
rem EndEngTextBlock
@echo !applabel! !pathname!>>ZeroSizeBackups.txt
del /q /f "!pathname!.ab"
) else (
set bakcuperror=1
if "!filesize!"=="0" (
rem @echo   ---
rem StartRusTextBlock
@echo   %_fBYellow%= Файл бэкапа имеет нулевой размер и будет удален%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Backup file has zero size and will be delete%_fReset%
rem EndEngTextBlock
@echo !applabel! !pathname!>>ZeroSizeBackups.txt
del /q /f "!pathname!.ab"
exit /b
rem )
)
)
)
)
)
exit /b

rem Old


:_ViewABPackageAppName
setlocal enableextensions enabledelayedexpansion
@echo.
@del /q /f ArchivesList.txt 1>nul 2>nul
rem StartRusTextBlock
@echo    %_fBYellow%Список найденных бэкапов:%_fReset%
@echo.>>ArchivesList.txt
@echo   Список архивов>>ArchivesList.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    List of found backups:
rem @echo.>>ArchivesList.txt
rem @echo   Archives List>>ArchivesList.txt
rem EndEngTextBlock
@echo   ==================================>>ArchivesList.txt
@echo   ==================================
rem @echo   ----------------------------------
set shscriptname=dataextract.sh
@for /f "delims=" %%a in ('dir /b /a-d *.ab 2^>nul') do (
set "archivename=%%~na"
set vardefine=!archivename!

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
@echo   Имя файла	: !archivename!>>ArchivesList.txt
@echo   Имя пакета	: !viewpn!>>ArchivesList.txt
@echo   ---------------------------------->>ArchivesList.txt
@echo   Имя архива	: %_fBCyan%!archivename!%_fReset%
@echo   Имя пакета	: %_fCyan%!viewpn!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   File name	: !archivename!>>ArchivesList.txt
rem @echo   Package name	: !viewpn!>>ArchivesList.txt
rem @echo   ---------------------------------->>ArchivesList.txt
rem @echo   Archive name	: !archivename!  
rem @echo   Package name	: !viewpn!
rem EndEngTextBlock
@echo   ----------------------------------
set viewpn=
set archivename=
rem set applabel=
%MYFILES%\adb shell rm -R /data/local/tmp 1>nul 2>nul
rem %MYFILES%\adb shell rm /data/local/tmp
)
set returnmark=1
if not defined vardefine goto _NoFilesForExtract

del /q /f "%cd%\log.txt" 1>nul 2>nul
del /q /f "%cd%\%shscriptname%" 1>nul 2>nul
exit /b

:_ViewApkLabelInsideHeadsetPN
@del /q /f o.txt 1>nul 2>nul
set lp=!pathname!
set shscriptname=aaptname.sh
@echo #!/system/bin/sh>>%shscriptname%
@echo aapt^=/data/local/tmp/aapt-arm-pie2>>%shscriptname%
@echo pm list packages %lp% ^| sed 's^/^^^package://g' ^| while read line; do>>%shscriptname%
@echo     path^=$(pm path $line ^| sed 's^/^^^package^://g'^);>>%shscriptname%
@echo     label^=$($aapt d badging ^$path  ^| grep 'application: label^=' ^| cut -d "'" -f2^);>>%shscriptname%
@echo     printf "$label;$line\n";>>%shscriptname%
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

:_ViewPackageNameForExtract
rem call :_CheckHeadsetConnect
setlocal enableextensions enabledelayedexpansion
set shscriptname=dataextract.sh
@echo   --------------------------------
rem StartRusTextBlock
@echo   %_fBYellow%= Начинаем извлечение..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Start extracting..%_fReset%
rem EndEngTextBlock
@echo   --------------------------------
@for /f "delims=" %%a in ('dir /b /a-d *.ab 2^>nul' ) do (
set "applabel=%%~na"
set "archivename=!applabel!"
rem StartRusTextBlock
@echo   = Название архива	: %_fBCyan%!archivename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Archive name	: %_fBCyan%!archivename!%_fReset%
rem EndEngTextBlock

rem applabel - имя файла архива
rem archivename - имя файла архива

rem Определяем имя пакета приложения
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/!archivename!.ab" ^) ^| tar xfvz - -C /data/local/tmp/ >%shscriptname%
%myfiles%\adb push "!archivename!.ab" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell ls -1t /data/local/tmp/apps/ ^| head -1 >log.txt 2>nul 
rem powershell -ExecutionPolicy Bypass -File "%MYFILES%\selector.ps1" "apps-source.txt" "packages-list.txt" %SelectorParameters%


@FOR /F "tokens=*" %%k IN (%cd%\log.txt) DO set viewpn=%%k

@del /q /f log.txt 1>nul 2>nul

rem StartRusTextBlock
@echo   = Название пакета	: %_fCyan%!viewpn!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Package name	: %_fCyan%!viewpn!%_fReset%
rem EndEngTextBlock


@echo   ------------------------------------------------
rem >>>>>>>>>>>>>>>>>>>>>>>>>>
rem md "%cd%\Backups\!applabelsave!\data" 1>nul 2>nul

rem @%myfiles%\adb pull "/data/local/tmp/apps/!viewpn!" "%cd%\Backups\!applabelsave!\data" 1>nul 2>nul



rem md "%cd%\Backups\!archivename!\data" 1>nul 2>nul

rem @%myfiles%\adb pull "/data/local/tmp/apps/!archivename!" "%cd%\Backups\!archivename!\data" 1>nul 2>nul

rem @%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul
rem >>>>>>>>>>>>>>>>>>>>>>>>>>


rem viewpn - имя пакета приложения
rem applabelsave - имя файла архива (сохраняем)

set "applabelsave=!applabel!"
ren "%cd%\%applabel%.ab" "%viewpn%.ab" 1>nul 2>nul

rem 
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/!viewpn!.ab" ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
@%myfiles%\adb push "!viewpn!.ab" /data/local/tmp/ 1>nul 2>nul
@%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
@%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
@%myfiles%\adb shell sh /data/local/tmp/%shscriptname% 1>nul 2>nul
rem  >log.txt 2>nul

md "%bakdir%\%dt%\!applabelsave!\data" 1>nul 2>nul

@%myfiles%\adb pull "/data/local/tmp/apps/!viewpn!" "%bakdir%\%dt%\!applabelsave!\data" 1>nul 2>nul

@%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul

@%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@del /q /f %shscriptname% 1>nul 2>nul


ren "%cd%\%viewpn%.ab" "%applabelsave%.ab" 1>nul 2>nul
)
if not defined archivename goto _NoFilesForExtract
rem if not defined applabel goto _NoFilesForExtract


rem StartRusTextBlock
@echo   %_fBGreen%= Извлечение данных завершено%_fReset%
@echo   ---
@echo     Вы можете найти их здесь: %_fBYellow%%bakdir%\%dt%\%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Data extraction and copying completed%_fReset%
rem @echo   ---
rem @echo     You can find them here: %_fBYellow%%cd%\Backups\!applabelsave!\data%_fReset%
rem EndEngTextBlock
exit /b



:_ExctractDataFromDataFiles
call :_settime
%myfiles%\adb shell input keyevent 224

rem @timeout 5 >nul

%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul

for /f "tokens=1,2,3,4 delims=;" %%a in (packages-list.txt) do (
set abname=%%b
set packagename=%%c
rem set archivename=!unfull!!abname!
rem if not defined unfull 
set archivename=%%d

@echo   -------------------------------------------------------------------
rem StartRusTextBlock
@echo   = Название архива	: %_fBCyan%!abname!%_fReset%
@echo   = Название пакета	: %_fCyan%!packagename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo  = Archive name	: %_fBCyan%!abname!%_fReset%
rem @echo  = Package name	: %_fCyan%!packagename!%_fReset%
rem EndEngTextBlock

rem %myfiles%\adb shell input keyevent 224

rem call :_ExtractDataFromABFiles

call :_EstractTest


@%myfiles%\adb shell rm -R /data/local/tmp/ 1>nul 2>nul
)

@%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@del /q /f %shscriptname% 1>nul 2>nul

@echo.
rem @echo   ---
rem StartRusTextBlock
@echo   ================================================
@echo         %_fBGreen%= Извлечение данных завершено%_fReset%
@echo     Вы можете найти их здесь: %_fBYellow%%bakdir%\%dt%\%applabel%\data%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem )
rem )
rem @echo.
rem @echo   ================================================
rem @echo   %_fBGreen%= Data extraction and copying completed%_fReset%
rem @echo     You can find them here: %_fBYellow%%bakdir%\%dt%\%applabel%\data%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b

:_EstractTest
if "%packagename%" == "%abname%" set packagename=
set shscriptname=dataextract.sh
@echo   ---------------------------
rem StartRusTextBlock
@echo   - Извлекаем файлы данных..
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   - Extracting data files..
rem EndEngTextBlock
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/%abname%" ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
%myfiles%\adb push "%archivename%" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >log.txt 2>nul
md "%bakdir%\%dt%\%abname%\data"
%myfiles%\adb pull /data/local/tmp/apps/%packagename% "%bakdir%\%dt%\%abname%\data" 1>nul 2>nul
del /q /f "%cd%\log.txt" 1>nul 2>nul
del /q /f "%cd%\%shscriptname%" 1>nul 2>nul
del /q /f packages-list.txt 1>nul 2>nul
exit /b
%myfiles%\adb pull /data/local/tmp/apps "%bakdir%\%dt%\%applabel%\data" 1>nul 2>nul


:_ViewRunningApps
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Запущеные приложения%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Running apps%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
for /f "delims=" %%P in ('%myfiles%\adb shell pidof !pathname!') do (
set "pid=%%P"
if defined pid (
rem StartRusTextBlock
@echo   ------------------------------------------------
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name	: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name		: %_fCyan%!pathname!%_fReset%
rem EndEngTextBlock
@echo   = PID			: %_fBBlue%!pid!%_fReset%
@echo !pid! !applabel! !pathname!>>"RunningApps.txt"
set "pid="
)
)
)
@echo.
rem StartRusTextBlock
@echo   ================================================
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo     Список сохранен в файл %_fBYellow%RunningApps.txt%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
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
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b



:_UninstallApps
set deletedisable=1
@echo.
rem StartRusTextBlock
@echo   ================================================================
@echo      %_fBRed%+++   ВЫБРАННЫЕ ПРИЛОЖЕНИЯ БУДУТ УДАЛЕНЫ^!   +++%_fReset%
@echo.
@echo   %_fBYellow%Следует иметь в виду, что не все приложения могут буть удалены,
@echo   особенно если это системные приложения. %_fBRed%Используйте удаление
@echo   очень осторожно иначе придется сбрасывать шлем до заводских настроек.%_fReset%
@echo   ================================================================
@echo.
@echo.
@Set /p deletedisable="Подтвердите удаление нажатием Enter или введите 0 и Enter для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ================================================================
rem @echo      %_fBRed%+++   SELECTED APPLICATIONS WILL BE UNINSTALLED^!   +++%_fReset%
rem @echo.
rem @echo   %_fBYellow%Keep in mind that not all applications can be deleted,
rem @echo   especially system applications. %_fBRed%Use deletion
rem @echo   very carefully, otherwise you may have to reset the headset to factory settings.%_fReset%
rem @echo   ================================================================
rem @echo.
rem @echo.
rem @Set /p deletedisable="Confirm by pressing Enter, or enter 0 and press Enter to return to the menu: "
rem EndEngTextBlock
if not defined deletedisable goto _UninstallApps
if /i "%deletedisable%"=="0" (exit /b)
if /i "%deletedisable%"=="1" (goto _UninstallAppsCont)
goto _UninstallApps
:_UninstallAppsCont
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
if defined cachekey set "keymsg=. Кэш и данные удалены не будут"
@echo      %_fBYellow%Удаление приложений%keymsg%%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem if defined cachekey set "keymsg=. Cache and data will not be removed"
rem @echo      %_fBYellow%Application removal%keymsg%%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%- Удаление приложения..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application Name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package Name       : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%- Removing application..%_fReset%
rem EndEngTextBlock
%MYFILES%\adb shell pm uninstall -k --user 0 %cachekey% !pathname! 1>nul 2>nul
%MYFILES%\adb shell pm list packages | findstr /I "!pathname!" 1>nul 2>nul
if %errorlevel%==0 (
rem StartRusTextBlock
@echo   %_fBRed%= Не удалось удалить приложение%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%= Failed to uninstall the application%_fReset%
rem EndEngTextBlock
) else (
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение удалено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= App uninstalled%_fReset%
rem EndEngTextBlock
)
)
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b

:_ClearCacheDataApps
set cleardisable=1
@echo.
rem StartRusTextBlock
@echo   ================================================================
@echo     %_fBRed%+++   КЭШ И ДАННЫЕ ВЫБРАННЫХ ПРИЛОЖЕНИЙ БУДУТ ОЧИЩЕНЫ^!   +++%_fReset%
@echo.
@echo   %_fBYellow%Следует иметь в виду, что не все приложения могут буть очищены,
@echo   особенно если это системные приложения. %_fBRed%Используйте очистку
@echo   очень осторожно иначе придется сбрасывать шлем до заводских настроек.%_fReset%
@echo   ================================================================
@echo.
@echo.
@Set /p cleardisable="Подтвердите очистку нажатием Enter или введите 0 и Enter для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ================================================================
rem @echo     %_fBRed%+++   CACHE AND DATA OF SELECTED APPS WILL BE CLEARED^!   +++%_fReset%
rem @echo.
rem @echo   %_fBYellow%Keep in mind that not all applications can be cleared,
rem @echo   especially system applications. %_fBRed%Use cleaning
rem @echo   very carefully, otherwise you may have to reset the headset to factory settings.%_fReset%
rem @echo   ================================================================
rem @echo.
rem @echo.
rem @Set /p cleardisable="Confirm by pressing Enter, or enter 0 and press Enter to return to the menu: "
rem EndEngTextBlock
if not defined cleardisable goto _ClearCacheDataApps
if /i "%cleardisable%"=="0" (exit /b)
if /i "%cleardisable%"=="1" (goto _ClearCacheDataAppsCont)
goto _ClearCacheDataApps
:_ClearCacheDataAppsCont
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Очистка кэша и данных приложений%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Clearing app cache and data%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%- Очистка приложения..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = App Name       : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package Name   : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%- Cleaning the app..%_fReset%
rem EndEngTextBlock
%MYFILES%\ADB shell pm clear !pathname! 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Очистка завершена успешно%_fReset%
) else (
@echo   %_fBRed%= Очистка не удалась%_fReset%
)
)
@echo.
@echo   ================================================
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Cleaning completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Cleaning failed%_fReset%
rem )
rem )
rem @echo.
rem @echo   ================================================
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b

:_DisableApps
set canceldisable=1
@echo.
@echo   ================================================================
rem StartRusTextBlock
@echo       %_fBRed%+++   ВЫБРАННЫЕ ПРИЛОЖЕНИЯ БУДУТ ОТКЛЮЧЕНЫ^!   +++%_fReset%
@echo   %_fBYellow%Вы можете в любой момент узнать, какие приложения отключены, а также сохранить
@echo   список отключенных приложений - в Главном меню выберите пункты J-D-2-4.
@echo.
@echo   Следует иметь в виду, что не все приложения могут буть отключены,
@echo   особенно если это системные приложения. %_fBRed%Используйте отключение
@echo   очень осторожно иначе придется сбрасывать шлем до заводских настроек.%_fReset%
@echo   ================================================================
@echo.
@Set /p canceldisable="Подтвердите отключение нажатием Enter или введите 0 и Enter для возврата в меню: "
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       %_fBRed%+++   SELECTED APPS WILL BE DISABLED^!   +++%_fReset%
rem @echo   %_fBYellow%You can view and save the list of disabled apps
rem @echo   From the Main Menu, options J-D-2-4
rem @echo.
rem @echo   Keep in mind that not all applications can be disabled,
rem @echo   especially system applications. %_fBRed%Use disabling
rem @echo   very carefully, otherwise you may have to reset the headset to factory settings.%_fReset%
rem @echo   ================================================================
rem @echo.
rem @echo.
rem @Set /p canceldisable="Confirm by pressing Enter, or enter 0 and press Enter to return to the menu: "
rem EndEngTextBlock
if not defined canceldisable goto _DisableApps
if /i "%canceldisable%"=="0" (exit /b)
if /i "%canceldisable%"=="1" (goto _DisableAppsCont)
goto _DisableApps
:_DisableAppsCont
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Отключение приложений%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Disabling applications%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%- Отключение приложения..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name       : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%- Disabling application..%_fReset%
rem EndEngTextBlock
%MYFILES%\adb shell pm disable-user --user 0 !pathname! 1>nul 2>nul
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
)
)
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b

:_EnableApps
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Включение приложений%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Enabling application%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%+ Включение приложения..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name       : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%+ Enabling application..%_fReset%
rem EndEngTextBlock
%MYFILES%\adb shell pm enable --user 0 !pathname! 1>nul 2>nul
rem %MYFILES%\adb shell pm enable --user 0 com.oculus.socialplatform 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Включение завершено успешно%_fReset%
) else (
@echo   %_fBRed%= Включение не удалось%_fReset%
)
)
@echo.
@echo   ================================================
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Enabling completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Enabling failed%_fReset%
rem )
rem )
rem @echo.
rem @echo   ================================================
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b

:_StopApps
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Остановка приложения%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Start application%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set "pid="
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%+ Останавливаем приложение..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name       : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%+ Stopping application..%_fReset%
rem EndEngTextBlock

for /f "delims=" %%P in ('"%myfiles%\adb" shell pidof !pathname! 2^>nul') do set "pid=%%P"
if not defined pid (
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение уже остановлено%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= App already stopped%_fReset%
rem EndEngTextBlock
goto _StoppingAppFinishMessage
)

:_StoppingAppProcess
%myfiles%\adb shell am force-stop "!pathname!" 1>nul 2>nul
for /f "delims=" %%P in ('"%myfiles%\adb" shell pidof !pathname! 2^>nul') do set "pid=%%P"
if not defined pid (
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение остановлено%_fReset%
) else (
@echo   %_fBRed%= Остановка приложения не удалась%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Stop completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Stopping failed%_fReset%
rem EndEngTextBlock
)
)

:_StoppingAppFinishMessage
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo         %_fBGreen%Работа с приложениями завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b


:_StartApps
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Запуск приложения%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Start application%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%+ Стартуем приложение..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name       : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%+ Starting application..%_fReset%
rem EndEngTextBlock
%myfiles%\adb shell monkey -p "!pathname!"  -c android.intent.category.LAUNCHER 1 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение запущено. Можете надеть шлем%_fReset%
) else (
@echo   %_fBRed%= Запуск приложения не удался%_fReset%
)
)
@echo.
@echo   ================================================
@echo         %_fBGreen%Работа с приложением завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Start completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Starting failed%_fReset%
rem )
rem )
rem @echo.
rem @echo   ================================================
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b


:_NoFilesForExtract
@echo   --------------------------
rem StartRusTextBlock
@echo   %_fBRed%Файлов не найдено%_fReset%
@echo   %_fYellow%Положите архивы ab рядом с программой и повторите операцию%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBRed%No files found%_fReset%
rem @echo   %_fYellow%Place the .ab archives next to the program and repeat the operation%_fReset%
rem EndEngTextBlock
echo 1 >returnmark.txt
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


:_CheckHeadsetConnect
@%myfiles%\adb shell getprop ro.boot.serialno 1>NUL 2>&1
rem @echo %errorlevel%
rem exit /b
IF %errorlevel%==1 goto _NoHeadsetConnect
exit /b

rem ver 4.3.3

:_BackupPrevMenu
@echo   -------------------------------------------
rem StartRusTextBlock
@echo   ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   ^>^>^> Press any key for return previous menu ^<^<^<
rem EndEngTextBlock
@pause >nul
exit /b

:_ViewAppListReturn
del /q /f AppsList-*.* 1>nul 2>nul 
rem if SelectorParameters==-csv (
rem ren packages-list.txt AppsList.csv
rem ) else (
rem ren packages-list.txt AppsList.txt
rem )
exit /b


:_RestartApps
cls
@echo.
@echo.
@echo   ================================================
rem StartRusTextBlock
@echo      %_fBYellow%Перезапуск приложения%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo      %_fBYellow%Application restart%_fReset%
rem EndEngTextBlock
for /f "tokens=1,2 delims=;" %%a in (packages-list.txt) do (
set applabel=%%a
set pathname=%%b
set applabelsave=!applabel!
if [!pathname!]==[] set pathname=!applabel!
@echo   ------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   %_fBYellow%+ Перезапускаем приложение..%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name       : %_fCyan%!pathname!%_fReset%
rem @echo   %_fBYellow%+ Application restarting..%_fReset%
rem EndEngTextBlock

%myfiles%\adb shell am force-stop "!pathname!" 1>nul 2>nul
%myfiles%\adb shell monkey -p "!pathname!" -c android.intent.category.LAUNCHER 1 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение перезапущено. Можете надеть шлем%_fReset%
) else (
@echo   %_fBRed%= Запуск приложения не удался%_fReset%
)
)
@echo.
@echo   ================================================
@echo         %_fBGreen%Работа с приложением завершена%_fReset%
@echo   ================================================
@echo.
@echo ^>^>^> Нажмите что-нибудь для возврата в предыдущее меню ^<^<^<
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Restart completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Starting failed%_fReset%
rem )
rem )
rem @echo.
rem @echo   ================================================
rem @echo         %_fBGreen%Work with applications completed%_fReset%
rem @echo   ================================================
rem @echo.
rem @echo ^>^>^> Press anything to return to the previous menu ^<^<^<
rem EndEngTextBlock
pause >nul
exit /b


:_RestoreApplicationDataABPS
@%MYFILES%\adb shell am force-stop com.android.backupconfirm 1>nul 2>nul

set "ERR=RestoreErrors.txt"
set "OLD=RestoreErrorsOld.txt"
REM Если есть новый лог — обрабатываем
if exist "%ERR%" (
if exist "%OLD%" (
REM Дописываем старый лог
type "%ERR%" >> "%OLD%"
del "%ERR%"
) else (
REM Старого нет — просто переименовываем
ren "%ERR%" "%OLD%"
)
)

if not exist packages-list.txt (
rem StartRusTextBlock
@echo %_fYellow%Файлы не выбраны. Нажмите любую кнопку для возврата в меню%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fYellow%Files not selected. Press any key to return to the menu%_fReset%
rem EndEngTextBlock
pause >nul
exit /b
)
cls
@echo.
@echo.
@echo   ===================================================================
rem StartRusTextBlock
@echo    %_fBYellow%Идет подготовка к восстановлению. Не прерывайте этот процесс.%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo    %_fBYellow%Preparing for restoration. Do not interrupt this process.%_fReset%
rem EndEngTextBlock
set "tempErr=TempRestoreErr.log"
    if exist "!tempErr!" del "!tempErr!" >nul 2>&1
%myfiles%\adb shell input keyevent 224

rem @timeout 5 >nul

%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul

for /f "tokens=1,2,3,4 delims=;" %%a in (packages-list.txt) do (
set abname=%%b
set packagename=%%c
set archivename=%%d

@echo   -------------------------------------------------------------------
rem StartRusTextBlock
@echo   = Название архива	: %_fBCyan%!abname!%_fReset%
@echo   = Название пакета	: %_fCyan%!packagename!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Archive name   : %_fBCyan%!abname!%_fReset%
rem @echo   = Package name   : %_fCyan%!packagename!%_fReset%
rem EndEngTextBlock

%myfiles%\adb shell input keyevent 224
start /min "" cmd /c "%myfiles%\adb restore "!archivename!" 1>nul 2>>"!tempErr!""
@timeout 1 1>nul
for /f %%Z in ('type "!tempErr!" ^| findstr /r /c:".*"') do (

rem StartRusTextBlock
@echo [ERROR] !date! !time! Архив: "!archivename!" >>RestoreErrors.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo [ERROR] !date! !time! Archive: "!archivename!" >>RestoreErrors.txt
rem EndEngTextBlock
        type "!tempErr!" >>RestoreErrors.txt
        echo.>>RestoreErrors.txt
        echo -------------------------------------- >>RestoreErrors.txt
        del /q /f "!tempErr!" >nul 2>&1
    )

%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 61
@timeout 1 1>nul
%myfiles%\adb shell input keyevent 66

call :_CheckBackupProcessRest
rem StartRusTextBlock
@echo   %_fBGreen%= Архив восстановлен%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Archive restored%_fReset%
rem EndEngTextBlock
)
del /q /f packages-list.txt 1>nul 2>nul
timeout 1 1>nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_CheckBackupProcessRest
@for /f "tokens=1,2,3 delims=:= " %%a in ('%myfiles%\adb.exe shell dumpsys activity activities ^| findstr /i /c:"taskAffinity"') do (
if [%%c] == [com.android.backupconfirm] (timeout 2 1>nul && goto _CheckBackupProcessRest) else (exit /b)
)


:_CopySelectedBackups
if not exist packages-list.txt (
rem StartRusTextBlock
@echo %_fYellow%Файлы не выбраны. Нажмите любую кнопку для возврата в меню%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo %_fYellow%Files not selected. Press any key to return to the menu%_fReset%
rem EndEngTextBlock
pause >nul
exit /b
)


rem set "pscommand=(Get-Item '%filePath%').LastWriteTime.ToString('yyyy-MM-dd_HH-mm-ss')"

rem call :_ps1CommandRunBackups archivedata
@echo   ==================================
md !bakdir!\SelectedBackups  1>nul 2>nul

for /f "tokens=1,2,3,4 delims=;" %%a in (packages-list.txt) do (
set abname=%%b
set packagename=%%c
set archivename=%%d
rem @echo   ---
set "pscommand=(Get-Item '!archivename!').LastWriteTime.ToString('yyyy-MM-dd_HH-mm-ss')"
call :_ps1CommandRunBackup archivedata
if defined cmmarker (
move /y "!archivename!" "!bakdir!\SelectedBackups\!archivedata!_!abname!" 1>nul 2>nul
rem StartRusTextBlock
@echo   %_fBYellow%= Перемещаем архив  %_fCyan%!abname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Moving archive %_fCyan%!abname!%_fReset%
rem EndEngTextBlock
) else (
copy /y "!archivename!" "!bakdir!\SelectedBackups\!archivedata!_!abname!" 1>nul 2>nul
rem StartRusTextBlock
@echo   %_fBYellow%= Копируем архив  %_fCyan%!abname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBYellow%= Copying archive %_fCyan%!abname!%_fReset%
rem EndEngTextBlock
)
)

if defined cmmarker (
rem StartRusTextBlock
set filesstatus=перемещены
) else (
set filesstatus=скопированы
rem EndRusTextBlock
rem StartEngTextBlock
rem set filesstatus=moved
rem ) else (
rem set filesstatus=copied
rem EndEngTextBlock
)
@echo   ==================================
@echo.
rem StartRusTextBlock
@echo   %_fBGreen%Все выбранные архивы %filesstatus%%_fReset%
@echo   %_fBYellow%Они находятся в каталоге %_fYellow%!bakdir!\SelectedBackups\%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%All selected archives have been %filesstatus%%_fReset%
rem @echo   %_fBYellow%They are located in the directory %_fYellow%!bakdir!\SelectedBackups\%_fReset%
rem EndEngTextBlock
exit /b



:_BackupsDirChoice
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BackupsDir 2^>nul') do set backupsdir=%%a
if exist %backupsdir% (
set bakdir=%backupsdir%
rem @echo   %_fBYellow%= Каталог бэкапов взят из реестра%_fReset%
) else (
set "bakdir=%cd%\Backups"
rem @echo   %_fBYellow%= Используется каталог бэкапов по умолчанию%_fReset%
)
exit /b

:_MultiStringMessagesOutput
rem === Пример для проверки ===
rem set "mess1=Этот текст не влезает в одну строку, поэтому следом идет вторая"
rem set "mess2=А это текст второй строки"
rem set "mess3=Третья строка если нужно"

if defined mess1 (
set "showmsg=1"
)
if defined mess2 (
set "showmsg=1"
)
rem if defined mess3 (
rem set "showmsg=1"
rem )


if defined showmsg (
echo --------------------------------------------------------------------
if defined mess1 (
echo %mess1%
)
if defined mess2 (
echo %mess2%
)
rem if defined mess3 (
rem echo %mess3%
rem )
echo --------------------------------------------------------------------
)
exit /b


:_BakdirCreateBackupsCmd
For /f "tokens=3" %%a in ('reg query HKEY_CURRENT_USER\Software\Quas /v BackupsDir 2^>nul') do set backupsdir=%%a
if defined backupsdir (
dir /a /b "%backupsdir%" 2>nul | findstr . >nul
if errorlevel 1 (
dir /a /b "%quaspath%Backups" 2>nul | findstr . >nul
if errorlevel 1 (
md %quaspath%Backups 1>nul 2>nul
set BAKDIR=%quaspath%Backups
) else (
set BAKDIR=%quaspath%Backups
)
) else (
set BAKDIR=%backupsdir%
)
)
rem dir /a /b "%~dp0Backups" 2>nul | findstr . >nul
rem if errorlevel 1 (echo.>nul) else (set BAKDIR=%~dp0Backups)
exit /b




:_ps1CommandRunBackup
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