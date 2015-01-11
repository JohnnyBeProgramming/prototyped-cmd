@echo off
rem setlocal ENABLEEXTENSIONS
rem set me=%~n0
rem set parent=%~dp0

set cfg_inifile=Config.ini
set cfg_section=Version Info, Setup Environment

echo -------------------------------------------------------------------------------
echo  Load values from INI file
echo -------------------------------------------------------------------------------
echo  - Sections = %cfg_section%
echo  - FilePath = %cfg_inifile%

:init
if exist "%cfg_inifile%" (
	echo  - Loading Settings...
	call:loadConfig "%cfg_inifile%" "%cfg_section%"
	echo -------------------------------------------------------------------------------
	echo  - Settings Loaded.
	echo    + Version: %major%.%minor%.%build%.%revision%
	echo    + Primary: %primary%
	echo    + Second:  %secondary%
	echo    + Another: %another%
	goto done
) else goto warning
goto eof

:trim
set str=%~2
for /f "tokens=* delims= " %%a in ('echo %str%') do set str=%%a
set %1=%str%
goto :eof

:loadConfig
set filepath=%~1
set sections=%~2
if "%sections%"==""  call:loadSection "%filepath%" & goto :eof
for /F "tokens=1* delims=," %%f in ("%sections%") do (
    if not "%%f"=="" call:loadSection "%filepath%" "%%f"
    if not "%%g"=="" call:loadConfig  "%filepath%" "%%g"
)
goto :eof

:loadSection
set filepath=%~1
set section=%~2
if not "%section%"=="" (
	call:trim section "%section%"
)
if "%section%"=="" (
	rem *** Loads all settings (ignores headers)
	echo    + [ Loading All Settings ]
	set read=1
	set done=0
	for /f "tokens=*" %%a in (%filepath%) do (
		set skip=0 
		rem if "%done%"=="1" goto :eof
		rem if "%done%"=="0" echo Lala
		rem call:inspectLine "%read%" "%section%" "%%a" 
		echo %%a | findstr /r "\[.*\]" > nul || call:processLine %%a
	)
) else (
	rem *** Load all settings under  a specific header
	call:trim section "%section%"
	echo  + [ %section% ]
	set valid=N
	for /f "tokens=*" %%a in (%filepath%) do (
		set skip=0
		rem if "%done%"=="1" goto :eof
		rem if "%done%"=="0" echo Lala
		rem call:inspectLine "%read%" "%section%" "%%a" 
		rem echo %%a | findstr "[%section%]" > nul || set skip=1
		call:checkHeader "%section%" "%%a" & rem (echo [True]) || (echo [False])
	)
)
goto :eof

:checkHeader
if "%~2"=="" goto:eof
set found=1
echo %~2 | findstr "[%~1]" > nul || set found=0
if "%found%"=="1" (
	rem echo [#Start#]=%~2 
	set valid=Y
	goto:eof
)
set found=1
echo %~2 | findstr /r "\[.*\]" > nul || set found=0
if "%found%"=="1" (
	rem echo [#Ended#]=%~2 
	set valid=N
	goto:eof
)
if "%valid%"=="Y" (
	call:processLine %~2	
	rem echo [#VALID#]=%~2 
) else (
	rem echo [#SKIPS#]=%~2 
)
goto:eof

:processLine
set "%*"
echo    + %*
goto :eof



:warning
echo -------------------------------------------------------------------------------
echo  [ Warning ] Could not find all the required resources
echo -------------------------------------------------------------------------------
pause > nul
goto :eof

:error
echo -------------------------------------------------------------------------------
echo  [ Error ] An error occurred while executing this script
echo -------------------------------------------------------------------------------
pause > nul
goto :eof

:done
echo -------------------------------------------------------------------------------
echo  [ Done ] 
echo -------------------------------------------------------------------------------
TIMEOUT 10 
goto :eof