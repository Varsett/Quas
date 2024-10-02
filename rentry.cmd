@echo off
setlocal enabledelayedexpansion

REM -----------------------------
REM  rentry.bat - Batch replica to the python version
REM  Made by github.com/agamsol/rentry
REM -----------------------------
REM          CHANGE LOG
REM        Version 1.0.0.4
REM   - Support new domain of rentry (rentry.org)
REM   - Reduced code using a BaseURL variable
REM   - New Entry Creation Format: [ URL={URL} ] [ EDIT_CODE={EDIT_CODE} ]
REM        Version 1.0.0.5
REM   - Fixed a bug where the length of the URL is not measured at all
REM   [ Thanks to https://www.dostips.com, sowgtsoi, jeb and amel27
REM         for the amazing work on the length counter function. ]


set API=1.0.0.5
set "BaseURL=https://rentry.org"

set Args.Length=0
for %%a in (%*) do (
    set /a Args.Length+=1
    set "Arg[!Args.Length!]=%%~a"
)
set temp.mode=HELP
for /L %%a in (1 1 !Args.length!) do (
    for %%b in (URL EDIT-CODE HELP NEW DELETE EDIT RAW FILE CURL IF-EXIST) do (
        if /i "!Arg[%%a]!"=="--%%~b" (
            set Arg.Next=%%a
            set /a Arg.Next+=1
            if /i "%%~b"=="url" (
                for /f "delims=" %%c in ("!Arg.Next!") do (
                    set temp.url=!Arg[%%c]!
                    if defined temp.url (
                        if "!temp.url:~1,1!"=="" set temp.url.length=1
                        for /f "tokens=1 delims= " %%d in ("!temp.url!") do set temp.url=%%d
                    )
                )
            )
            if /i "%%~b"=="edit-code" (
                for /f "delims=" %%c in ("!Arg.Next!") do (
                    set temp.edit-code=!Arg[%%c]!
                )
            )
            if /i "%%~b"=="file" (
                for /f "delims=" %%c in ("!Arg.Next!") do (
                    set temp.file=!Arg[%%c]!
                )
            )
            if /i "%%~b"=="curl" (
                for /f "delims=" %%c in ("!Arg.Next!") do (
                    if exist "!Arg[%%c]!" set temp.curl=!Arg[%%c]!
                )
            )
            for %%c in (HELP NEW DELETE EDIT RAW IF-EXIST) do if /i "%%~b"=="%%c" set temp.mode=%%c
        )
    )
)

if "!temp.mode!"=="HELP" (
    for %%a in (
        ""
        " Usage: %~nx0 { --help | --new | --delete | --edit | --raw } { --url <entry> } { --edit-code <code> } { --file "file.txt" }"
        ""
        " Commands:"
        "  --help     # View this help page"
        "  --new      # Create new entry"
        "  --edit     # Edit existing entry"
        "  --delete   # Delete existing entry"
        "  --raw      # Display a paste as RAW"
        ""
        " Options:"
        "  NOTE: The order of specified options does not matter and all options are recorded."
        "  --url <entry>        # Specify a URL"
        "  --edit-code <code>   # Specify code to edit or delete the entry"
        "  --file "^<file.txt^>"  # Specify path to file to upload or to output the RAW function"
        "  --curl "full\path\to\curl.exe"  # Specify custom curl installation file"
        ""
        " Examples:"
        " call %~nx0 --new --file "file.txt"                                  # Create new entry and POST the content inside file.txt in it."
        " call %~nx0 --new --url myurl --edit-code mycode --file file.txt     # Create new entry with custom URL and code and POST"
        " call %~nx0 --edit --url myurl --edit-code mycode --file "file.txt"  # Edit entry using its url and code and replace the content with the new one in the file"
        " call %~nx0 --delete --url myurl --edit-code mycode                  # Delete the entry using its url and code."
        " call %~nx0 --raw --url myurl                                        # Display the paste's text in the terminal"
        " call %~nx0 --raw --url myurl --file "file.txt"                      # Save the entry's content to a file."
        ""
        " NOTE: This utility is not made by the official author of rentry.org"
        "        If you would like to use the official python version please visit"
        "            https://github.com/radude/rentry"
    ) do echo:%%~a
    exit /b 0
)

if not defined temp.curl (
    where curl.exe >nul 2>&1
    if !errorlevel! equ 1 (
        echo ERROR: cURL not installed, you can specify custom cURL build using the "--curl" flag
        echo       You can download curl at https://curl.se/windows/
        exit /b 1
    ) else (
        set temp.curl=curl.exe
    )
)

if "!temp.mode!"=="IF-EXIST" (
    if not defined temp.url echo ERROR: You must specify URL to view the paste. & exit /b 1
    "!temp.curl!" --silent -kf "!BaseURL!/!temp.url!/raw">nul 2>&1 && (
        echo Ok
        exit /b 0
    ) || (
        echo ERROR: Invalid Entry
        exit /b 1
    )
)

call :strLen temp.url temp.url.length
if !temp.url.length! equ 1 echo ERROR: URL's length must be greater than or equal to 2 characters. [Length: !temp.url.length!] & exit /b 1
if !temp.url.length! gtr 100 echo ERROR: URL's length cannot be longer than 100 characters [Length: !temp.url.length!] & exit /b 1

if "!temp.mode!"=="NEW" (
    call :GENERATE_CERTICICATE
    if defined temp.file (
        if not exist "!temp.file!" (
            echo ERROR: File does not exist
            exit /b 1
        )
    ) else echo ERROR: File not specified. & exit /b 1
    "!temp.curl!" -k --silent -X POST --referer "!BaseURL!" --data-urlencode "csrfmiddlewaretoken=!token!" --data-urlencode "edit_code=!temp.edit-code!" --data-urlencode "url=!temp.url!" --data-urlencode "text@!temp.file!" !cookie! -o "!temp!\response.json" !BaseURL!/api/new/
    call :JsonParse "!temp!\response.json" content errors url edit_code
    if "!resp.content!"=="OK" (
        echo URL=!resp.url:rentry.co=rentry.org!
        echo EDIT_CODE=!resp.edit_code!
    ) else (
        call :CHECK_ERRORS
        exit /b 1
    )
)

"!temp.curl!" --silent -kf "!BaseURL!/!temp.url!/raw">nul 2>&1 || (
    echo ERROR: The URL specified does not exist.
    exit /b 1
)

if "!temp.mode!"=="EDIT" (
    :EDIT_PASTE [ #DELETE ]
    if "%~1"=="#DELETE" (set temp.mode.int=delete) else set temp.mode.int=edit
    if not defined temp.url echo ERROR: You must specify URL and edit-code to !temp.mode.int!. & exit /b 1
    if not defined temp.EDIT-CODE echo ERROR: You must specify the edit-code to !temp.mode.int! this paste. & exit /b 1

    if not "%1"=="#DELETE" (
        if defined temp.file (
            if not exist "!temp.file!" (
                echo ERROR: File does not exist
                exit /b 1
            )
        ) else echo ERROR: File not specified. & exit /b 1
    )

    call :GENERATE_CERTICICATE
    "!temp.curl!" -k --silent -X POST --referer "!BaseURL!"  --data-urlencode "csrfmiddlewaretoken=!token!" --data-urlencode "edit_code=!temp.edit-code!" --data-urlencode "text@!temp.file!" !cookie! -o "!temp!\response.json" "!BaseURL!/api/edit/!temp.url!"
    call :JsonParse "!temp!\response.json" content errors status content
    if not !resp.status! equ 200 (
        call :CHECK_ERRORS
        if "%1"=="#DELETE" exit /b 101
        exit /b 1
    ) else if "!resp.content!"=="OK" (
        if "%1"=="#DELETE" exit /b 100
        echo Successfully edited the paste '!temp.url!'
        exit /b 0
    )
)

if "!temp.mode!"=="DELETE" (
    call :EDIT_PASTE #DELETE
    if !errorlevel! equ 101 exit /b 1
    call :GENERATE_CERTICICATE
    "!temp.curl!" -k --silent --referer "!BaseURL!/api/edit" --cookie "csrftoken=!token!" --data "csrfmiddlewaretoken=!token!" --data "delete=delete" --data "edit_code=!temp.edit-code!" "!BaseURL!/!temp.url!/edit"
    echo Successfully deleted the paste.
)

if "!temp.mode!"=="RAW" (
    if not defined temp.url echo ERROR: You must specify URL to view the paste. & exit /b 1
    "!temp.curl!" -k --silent !BaseURL!/api/raw/!temp.url! -o "!temp!/rentry-raw.json"
    call :JsonParse "!temp!/rentry-raw.json" status content
    if !resp.status! equ 404 (
        call :CHECK_ERRORS
        exit /b 1
    )

    if defined temp.file set "output_to_file=--create-dirs -o "!temp.file!""
    "!temp.curl!" -k --silent "!BaseURL!/!temp.url!/raw" !output_to_file!
)
exit /b 0

:CHECK_ERRORS
if "!resp.errors!"=="Entry with this url already exists." echo ERROR: URL specified is already taken.
if "!resp.errors!"=="This field is required." echo ERROR: Content to POST is not specified.
if "!resp.errors!"=="Url must consist of letters, numbers, underscores or hyphens." echo ERROR: URL must consist of letters, numbers, underscores or hyphens.
if "!resp.errors!"=="Ensure url value is greater than or equal to 2." echo ERROR: URL's length must be greater than or equal to 2 characters.
if "!resp.content!"=="Invalid edit code" echo ERROR: The edit-code specified is incorrect, try again.
if "!resp.content!"=="Entry !temp.url! does not exist" echo ERROR: The URL specified does not exist.
exit /b

:: ADDON / GENERATE CERTIFICATE TO USE RENTRY
:GENERATE_CERTICICATE
set status=
for /f "tokens=1-2 delims=:; " %%a in ('"!temp.curl!" -k --silent --head !BaseURL!/') do (
    if /i "%%a"=="Set-Cookie" (
        set cookie=--cookie "%%b"
        for /f "tokens=2 delims==" %%c in ("%%b") do (
            set "token=%%c"
        )
    )
)
exit /b

:: ADDON \ PARSE JSON KEYS FROM FILE
:JsonParse
chcp 437>nul
for %%a in ("ParseSource" "JsonKeys" "ParseKeys") do set %%~a=
set "ParseSource=%~1"
set "JsonKeys=%*"
set "JsonKeys=!JsonKeys:*%~1=!"
set "JsonKeys=!JsonKeys:~1!"
if exist "!ParseSource!" (
    for %%a in (!JsonKeys!) do (
        set "ParseKeys=!ParseKeys!; $ValuePart = '%%~a=' + $Value.%%~a ; $ValuePart"
    )
    for /f "delims=" %%a in ('powershell "$Value = (Get-Content '!ParseSource!' | Out-String | ConvertFrom-Json) !ParseKeys!"') do set "resp.%%a">nul 2>&1
) else echo ERROR: File not found.
chcp 65001>nul
del /s /q "!ParseSource!" >nul 2>&1
exit /b

:strLen string len -- returns the length of a string
(   SETLOCAL ENABLEDELAYEDEXPANSION
    set "str=A!%~1!"&rem keep the A up front to ensure we get the length and not the upper bound
                     rem it also avoids trouble in case of empty string
    set "len=0"
    for /L %%A in (12,-1,0) do (
        set /a "len|=1<<%%A"
        for %%B in (!len!) do if "!str:~%%B,1!"=="" set /a "len&=~1<<%%A"
    )
)
( ENDLOCAL & REM RETURN VALUES
    IF "%~2" NEQ "" SET /a %~2=%len%
)
EXIT /b