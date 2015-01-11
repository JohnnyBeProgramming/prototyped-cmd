@echo off


set iis_node_name="Default Web Site"
set iis_bind_type=https
set iis_bind_name=localhost
set iis_bind_port=4343
set iis_bind_cmd=%windir%\system32\inetsrv\Appcmd.exe
set iis_bind_val=%iis_bind_type%/*:%iis_bind_port%:%iis_bind_name%
set logger=Event.log
set output_dir=Bindings

echo -------------------------------------------------------------------------------
echo  Add IIS Web Bindings
echo -------------------------------------------------------------------------------
if exist "%logger%" del "%logger%" /Q > NUL

:iis_bindings_set
echo ------------------------------------------------------------------------------- >> "%logger%"
echo   Adding Additional IIS Bindings to website [ %iis_node_name% ] 				 >> "%logger%"
echo ------------------------------------------------------------------------------- >> "%logger%"
echo.>> "%logger%"
if not exist "%iis_bind_cmd%" goto iis_bindings_missing
goto iis_bindings_create

:iis_bindings_create
echo  - Add binding to '%iis_node_name%'...	
echo  - Binding: %iis_bind_val%
"%iis_bind_cmd%" set site /site.name: %iis_node_name% /+bindings.[protocol='%iis_bind_type%',bindingInformation='*:%iis_bind_port%:%iis_bind_name%'] >> "%logger%"
echo.>> "%logger%"
if errorlevel 1 goto iis_bindings_exists
goto iis_bindings_done
:iis_bindings_exists
echo  - Skipped: Could not add binding. Probably already exists... 
echo  - Warning: Could not add binding: %iis_bind_val% >> "%logger%"
goto success
:iis_bindings_missing
echo  - Command not found: %iis_bind_cmd% >> "%logger%"
goto error
:iis_bindings_done


if errorlevel 1 goto error
goto success

:error
echo -------------------------------------------------------------------------------
echo  [ Error ] The current deployment failed!
echo -------------------------------------------------------------------------------
call "%logger%"
pause
goto done

:success
echo -------------------------------------------------------------------------------
echo  [ Success ] The current deployment succeeded!
echo -------------------------------------------------------------------------------
TIMEOUT 3 > NUL
goto done
:done