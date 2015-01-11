@echo off
set appcmd=CALL %WINDIR%\system32\inetsrv\appcmd

rem ********************************************************************************
rem Here are some of the IIS Commands that are available
rem ********************************************************************************
rem Source: http://blogs.iis.net/ksingla/archive/2007/06/17/things-you-can-do-by-piping-appcmd-commands.aspx

set iis_app_node=MyWebApp
set iis_app_pool=MyAppPool
set iis_app_path=%CD%
set iis_app_port=8080

rem %appcmd% list backups
rem %appcmd% add backup "MyBackup"
rem %appcmd% restore backup "MyBackup"

rem *** Enable 32-bit mode on application pool by name 					
rem %appcmd% list apppool /name:"$=*%iis_app_pool%*" /xml | %appcmd% set apppool /in /enable32BitAppOnWin64:true

rem *** Recycle all application pools
rem %appcmd% list apppool /xml | %appcmd% recycle apppool /in

rem *** Start / Stop application pool by name 
rem %appcmd% list apppool /name:"$=*%iis_app_pool%*" /xml | %appcmd% stop apppool /in
rem %appcmd% list apppool /name:"$=*%iis_app_pool%*" /xml | %appcmd% start apppool /in

rem *** Start all app pools that have been stopped
rem %appcmd% list apppool /state:Stopped /xml | %appcmd% start apppool /in

rem *** Start IIS web application by name
rem %appcmd% list site /name:"$=*%iis_app_pool%*" /xml | %appcmd% start site /in

rem *** Backup and restore a sites' config data to file (by name)
rem %appcmd% list backup 
rem %appcmd% list site /name:"$=*%iis_app_pool%*" /config /xml > "%iis_app_pool%.xml"
rem %appcmd% add sites /in < "%iis_app_pool%.xml"

rem *** Move website to another application pool called "MyAppPool"
rem %appcmd% list app /site.name:"%iis_app_pool%" /xml | %appcmd% set app /in /applicationPool:MyAppPool

rem *** Delete all websites usinga specific app pool
rem %appcmd% list apppool %iis_app_pool% /xml | %appcmd% list app /in /xml | %appcmd% delete app /in

rem ********************************************************************************


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