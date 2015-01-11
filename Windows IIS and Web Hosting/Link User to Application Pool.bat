@echo off

set iis_app_pool=MyAppPool
set iis_app_user=DOMAIN\USERNAME
set iis_app_pass=PASSWORD

set appcmd=CALL %WINDIR%\system32\inetsrv\appcmd


echo -------------------------------------------------------------------------------
echo  Check and Verify IIS Application Pool
echo -------------------------------------------------------------------------------
if "%iis_app_pool%"=="" goto iis_app_list
goto iis_app_check


:iis_app_list
echo  - Listing all IIS nodes...
echo -------------------------------------------------------------------------------
%appcmd% list APPPOOL 
echo -------------------------------------------------------------------------------
goto iis_app_missing


:iis_app_check
echo  - Targets: %iis_app_pool%
%appcmd% list APPPOOL "%iis_app_pool%" > NUL 
IF "%ERRORLEVEL%" EQU "5" goto access_denied
IF "%ERRORLEVEL%" EQU "0" (    
    goto iis_app_found
) ELSE (    
    goto iis_app_install
)
pause
IF '%ERRORLEVEL%'=='0' goto iis_app_found
goto iis_app_install

:iis_app_install
echo  - Creating new Application pool...
%appcmd% add apppool /name:%iis_app_pool% /managedRuntimeVersion:"v4.0" /managedPipelineMode:"Integrated" > NUL 
IF "%ERRORLEVEL%" EQU "0" goto iis_app_link
goto error

:iis_app_found
echo  - Application pool already exists...
goto iis_app_link

:iis_app_missing
echo  - Warning: Please specify the name of the application pool to update...
goto done

:iis_app_link
%appcmd% list apppool "%iis_app_pool%" /text:* | findstr userName: | findstr %iis_app_user% > NUL 
IF "%ERRORLEVEL%" EQU "5" goto access_denied
IF "%ERRORLEVEL%" EQU "0" (    
    echo  - Already Linked: %iis_app_user% 
    goto done
)
echo  - Link to User: %iis_app_user% 
rem %appcmd% list apppool "%iis_app_pool%" /text:*
echo    + Changing Type... 		& %appcmd% set apppool "%iis_app_pool%" /processModel.identityType:SpecificUser > NUL 
if "%ERRORLEVEL%" NEQ "0" goto error
echo    + Updating Username... 	& %appcmd% set apppool "%iis_app_pool%" /processModel.userName:%iis_app_user% 	> NUL
if "%ERRORLEVEL%" NEQ "0" goto error
echo    + Updating Password... 	& %appcmd% set apppool "%iis_app_pool%" /processModel.password:%iis_app_pass% 	> NUL 
if "%ERRORLEVEL%" NEQ "0" goto error
goto done

:access_denied
echo  - Warning: Insufficient permissions!
goto error

:error
echo -------------------------------------------------------------------------------
echo  Warning: The script failed to run! 
echo -------------------------------------------------------------------------------
pause
goto end

:done
echo -------------------------------------------------------------------------------
echo  - Done
echo -------------------------------------------------------------------------------
TIMEOUT 5 > NUL
goto end

:end