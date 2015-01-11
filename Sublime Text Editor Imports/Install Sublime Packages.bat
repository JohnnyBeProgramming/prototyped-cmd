@echo off

set target_src=.\
set target_dir=%APPDATA%\Sublime Text 3
set target_log=%APPDATA%\Sublime.Install.log

echo -------------------------------------------------------------------------------
echo  Sublime Text - Deploy Custom Syntax Higlighting Templates
echo -------------------------------------------------------------------------------

:detect
if not exist "%target_src%" goto warning
if not exist "%target_dir%" (
	rem ** Fallback to Sublime Text Edit 2 (if exists)	
	set target_dir=%APPDATA%\Sublime Text 2\Packages
)
if not exist "%target_dir%" goto warning

:begin
echo  Copying Templates... > "%target_log%"
echo  - Source: %target_src% >> "%target_log%"
echo  - Target: %target_dir% >> "%target_log%"
echo  - Installing...
pushd "%target_src%"
for /d %%d in (*) do (
	echo    + %%d 
	echo.>> "%target_log%"
	xcopy "%%d\*.*" "%target_dir%\%%d\" /Y /S >> "%target_log%" 
	if errorlevel 1 goto error
)
echo  - Done.
popd


:finish
if errorlevel 1 goto error
echo.>> "%target_log%"
echo  - Completed Successfully. >> "%target_log%"
goto success

:warning
echo  - Warning: One or more of the required resources are missing...
echo Aborted: One or more of the required resources are missing... >> "%target_log%"
echo Targets: %target_dir% >> "%target_log%"
goto error

:error
echo -------------------------------------------------------------------------------
echo  [ Error ] The current deployment failed!
echo -------------------------------------------------------------------------------
if "%silent_mode%"=="" (
	call "%target_log%"
) else (
	echo - For more detailed logs, see: 
	echo - %target_log%
)
goto done

:success
echo -------------------------------------------------------------------------------
echo  [ Success ] The current deployment succeeded!
echo -------------------------------------------------------------------------------
timeout 5
goto done

:done
