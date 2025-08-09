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
@del /q /f NotCopiedAPK.txt 1>nul 2>nul
cls
@echo.
@echo   ================================================================
rem StartRusTextBlock
@echo      %_fBYellow%Старт архивации.  Не прерывайте этот процесс.%_fReset%
rem @echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       Starting selected archive process. Do not interrupt this process.
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

exit /b


:_ApkBackupProcedure
if !pkgnamea! == android exit /b
if [!pkgnamef!]==[] exit /b
@echo   + Копирование APK...
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
@md "Backups\!applabel!" 2>nul 1>nul
rem @ren %cd%\!pkgnamef!.apk "!applabel!.apk" 2>nul 1>nul
@move "!pkgnamef!.apk" "Backups\!applabel!" 1>nul 2>nul
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
@md "%cd%\Backups\!applabel!\obb\!pkgnamef!" 1>nul 2>nul
%myfiles%\adb pull "/sdcard/Android/obb/!pkgnamef!" "%cd%\Backups\!applabel!\obb" 1>nul 2>nul
rem if exist "%cd%\Backups\!applabel!\obb\!pkgnamef!\" (
rem     dir /b /a "%cd%\Backups\!applabel!\obb\!pkgnamef!\" | findstr . >nul && (rem) || @echo   %_fBYellow%- OBB отсутствует%_fReset%
rem ) else (
rem     @echo %_fBYellow%- Папка OBB не найдена%_fReset%
rem )
dir /b /a "%cd%\Backups\!applabel!\obb\!pkgnamef!\" | findstr . >nul && ver >nul || @echo   %_fBYellow%- OBB отсутствует%_fReset%
@rd /q "%cd%\Backups\!applabel!\obb\!pkgnamef!" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\obb" 1>nul 2>nul
if "!pkgnamef!"=="com.beatgames.beatsaber" @%myfiles%\adb pull "/sdcard/ModData" "Backups\!applabel!\ModData" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.doom3quest" @%myfiles%\adb pull "/sdcard/Doom3Quest" "Backups\!applabel!\Doom3Quest" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.jkxr" @%myfiles%\adb pull "/sdcard/JKXR/" "Backups\!applabel!\JKXR" 1>nul 2>nul
if "!pkgnamef!"=="com.drbeef.lambda1vr" @%myfiles%\adb pull "/sdcard/XASH/" "Backups\!applabel!\XASH" 1>nul 2>nul
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
@md "%cd%\Backups\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@%myfiles%\adb pull "/sdcard/Android/data/!pkgnamef!" "%cd%\Backups\!applabel!\data" | findstr /i /c:"permission denied"  1>nul 2>nul

if %errorlevel% == 0 (call :_BackupDataExtractData)
dir /b /a "%cd%\Backups\!applabel!\data\" 2>nul | findstr . >nul && ver >nul || @echo   %_fBYellow%- Данные отсутствуют%_fReset%
@rd /q "%cd%\Backups\!applabel!\data\!pkgnamef!" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!\data" 1>nul 2>nul
@rd /q "%cd%\Backups\!applabel!" 1>nul 2>nul
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
rem For backup with apk to stay empty
rem set noapk=
rem For backup with obb to stay empty
rem set noobb=

@rd /s /q "%cd%\Backups\!applabel!\data" 1>nul 2>nul
rem @rd /s /q "%cd%\Backups\!applabel!" 1>nul 2>nul
@md "%cd%\Backups\!applabel!\data\" 1>nul 2>nul
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
@%myfiles%\adb pull "/data/local/tmp/apps/%datapackagename%" "%cd%\Backups\!applabel!\data" 1>nul 2>nul

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
if "%onlyview%" == "" call :_ExtractDataDromABFiles
)
exit /b

rem ===========================

:_ExtractDataDromABFiles
set shscriptname=dataextract.sh
@echo Extracting data from backup file...
@echo ^( printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" ; tail -c +25 "/data/local/tmp/%archivename%" ^) ^| tar xfvz - -C /data/local/tmp/>%shscriptname%
%myfiles%\adb push "%archivename%" /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb push %shscriptname% /data/local/tmp/ 1>nul 2>nul
%myfiles%\adb shell dos2unix /data/local/tmp/%shscriptname% 1>nul 2>nul
%myfiles%\adb shell sh /data/local/tmp/%shscriptname% >log.txt 2>nul
md "%cd%\Backups\%applabel%\data"
%myfiles%\adb pull /data/local/tmp/apps "%cd%\Backups\%applabel%\data" 1>nul 2>nul

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


:_BackupChoises
cls
rem @echo.
@echo.
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
call :_settime
set nomode=no
md "%cd%\Backups\%dt%" 1>nul 2>nul
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
@echo   ================================================================
rem StartRusTextBlock
@echo      %_fBYellow%Старт архивации по выбору.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo       Starting selected archive process. Do not interrupt this process.
rem @echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ====================================>>ArchiveLog-%dt%.txt
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
@move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b


:_BackupABProcessPS
@start /min "" %myfiles%\adb backup -f "!pathname!.ab"  -%nomode%apk -%nomode%obb "!pathname!"
@echo   ----------------------------------------------------------------
rem StartRusTextBlock
@echo   = Имя приложенния	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = App name		: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name	: %_fCyan%!pathname!%_fReset%
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
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
set nomode=no
call :_settime
md "%cd%\Backups\%dt%"
@echo.
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
@echo   ================================================================
rem StartRusTextBlock
@echo        %_fBYellow%Старт архивации по списку.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo        Starting batch archive process. Do not interrupt this process.
rem @echo   Archive log %dt%: >>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ====================================>>ArchiveLog-%dt%.txt
@timeout 4 1>nul
for /f "tokens=*" %%a in (%ListNumber%ListForBackups.txt) do (
set pathname=%%a

call :_BackupABProcess
call :_CurrentFileSizeBigger
rem call :_CurrentFileSize
rem call :_CheckBackupProcessAfter
)
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
@move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
exit /b


:_BackupAllApps
cls
set "packageslist=-3"
set nomode=no
call :_settime
md "%cd%\Backups\%dt%"
@echo.
call :_PackagesListApkNameParserFull
@%MYFILES%\adb shell am broadcast -a com.oculus.vrpowermanager.automation_disable 1>nul 2>nul
exit /b

:_PackagesListApkNameParserFull
%myfiles%\adb shell am broadcast -a com.oculus.vrpowermanager.prox_close 1>nul 2>nul
%myfiles%\adb shell input keyevent 224
@del /q /f ZeroSizeBackups.txt 1>nul 2>nul
@echo   ================================================================
rem StartRusTextBlock
@echo         %_fBYellow%Старт полной архивации.  Не прерывайте этот процесс.%_fReset%
@echo   Лог архивации %dt% >>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo         Starting full archive process. Do not interrupt this process.
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
@move "ArchiveLog-%dt%.txt" "%cd%\Backups\ArchiveLog-%dt%.txt" 1>nul 2>nul
exit /b

:_BackupABProcess
@start /min "" %myfiles%\adb backup -f "!pathname!.ab"  -%nomode%apk -%nomode%obb "!pathname!"
@echo   ----------------------------------------------------------------
if not defined applabelmark call :_ViewApkLabelInsideHeadsetPN
rem StartRusTextBlock
@echo   = Имя приложенния	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = App name		: %_fBCyan%!applabel!%_fReset%
rem @echo   = Package name	: %_fCyan%!pathname!%_fReset%
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
@echo  Имя приложения		: !applabel!>>ArchiveLog-%dt%.txt
@echo  Название пакета	: !pathname!>>ArchiveLog-%dt%.txt
@echo  Название архива	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = %_fBGreen%Backup !pathname! created successfully%_fReset%
rem @echo  App name	: !applabel!>>ArchiveLog-%dt%.txt
rem @echo  Package name	: !pathname!>>ArchiveLog-%dt%.txt
rem @echo  Archive name	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ------------------------------------>>ArchiveLog-%dt%.txt
call :_DeleteWrongSymbolsOk
@move "!pathname!.ab" "%cd%\Backups\%dt%\!applabel!.ab" 1>nul 2>nul
)
)
)

exit /b

:_CurrentFileSizeBigger
timeout 3 >nul
for /f "tokens=3" %%a in ('dir /-c "!pathname!.ab" ^| findstr /r /c:"[0-9][0-9]* !pathname!.ab$"') do (
set filesize=%%a
if not defined filesize exit /b
timeout 1 >nul
if !filesize! GTR 48 (
timeout 1 >nul
rem StartRusTextBlock
@echo   %_fBGreen%= Архив создан успешно%_fReset%
@echo  Название архива	: !applabel!.ab>>ArchiveLog-%dt%.txt
@echo  Имя приложения		: !applabel!>>ArchiveLog-%dt%.txt
@echo  Название пакета	: !pathname!>>ArchiveLog-%dt%.txt
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = %_fBGreen%Backup !pathname! created successfully%_fReset%
rem @echo  App name	: !applabel!>>ArchiveLog-%dt%.txt
rem @echo  Package name	: !pathname!>>ArchiveLog-%dt%.txt
rem @echo  Archive name	: !applabel!.ab>>ArchiveLog-%dt%.txt
rem EndEngTextBlock
@echo  ------------------------------------>>ArchiveLog-%dt%.txt
call :_DeleteWrongSymbolsOk
@move "!pathname!.ab" "%cd%\Backups\%dt%\!applabel!.ab" 1>nul 2>nul
exit /b
) else (
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
exit /b
)
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
rem @echo   Packaje name	: !viewpn!>>ArchivesList.txt
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

md "%cd%\Backups\!applabelsave!\data" 1>nul 2>nul

@%myfiles%\adb pull "/data/local/tmp/apps/!viewpn!" "%cd%\Backups\!applabelsave!\data" 1>nul 2>nul

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
@echo     Вы можете найти их здесь: %_fBYellow%%cd%\Backups\%_fReset%
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   %_fBGreen%= Data extraction and copying completed%_fReset%
rem @echo   ---
rem @echo     You can find them here: %_fBYellow%%cd%\Backups\!applabelsave!\data%_fReset%
rem EndEngTextBlock
exit /b



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
rem StartRusTextBlock
rem EndRusTextBlock
rem StartEngTextBlock
rem @echo   = Application Name   : %_fBCyan%!applabel!%_fReset%
rem @echo   = Package Name       : %_fCyan%!pathname!%_fReset%
rem EndEngTextBlock
for /f "delims=" %%P in ('%myfiles%\adb shell pidof !pathname!') do (
set "pid=%%P"
if defined pid (
@echo   ------------------------------------------------
@echo   = Имя приложения	: %_fBCyan%!applabel!%_fReset%
@echo   = Название пакета	: %_fCyan%!pathname!%_fReset%
@echo   = PID			: %_fBBlue%!pid!%_fReset%
@echo !pid! !applabel! !pathname!>>"RunningApps.txt"
set "pid="
)
)
)
@echo.
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
%MYFILES%\adb shell pm uninstall %cachekey% !pathname! 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Удаление завершено успешно%_fReset%
) else (
@echo   %_fBRed%= Удаление не удалось%_fReset%
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
rem @echo   %_fBGreen%= Deletion completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Deletion failed%_fReset%
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
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Отключение завершено успешно%_fReset%
) else (
@echo   %_fBRed%= Отключение не удалось%_fReset%
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
rem @echo   %_fBGreen%= Disabling completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Disabling failed%_fReset%
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
%MYFILES%\adb shell pm disable-user --user 0 !pathname! 1>nul 2>nul
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

%myfiles%\adb shell am force-stop "!pathname!" 1>nul 2>nul
if not errorlevel 1 (
rem StartRusTextBlock
@echo   %_fBGreen%= Приложение остановлено%_fReset%
) else (
@echo   %_fBRed%= Остановка приложения не удалась%_fReset%
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
rem @echo   %_fBGreen%= Stop completed successfully%_fReset%
rem ) else (
rem @echo   %_fBRed%= Stopping failed%_fReset%
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
