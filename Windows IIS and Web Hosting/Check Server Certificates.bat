@echo off

set cert_ident=
set cert_path=Prototyped.pfx
set cert_store=MY
set cert_dump=%cert_store%.certdump

echo -------------------------------------------------------------------------------
echo  Check Local Certificates
echo -------------------------------------------------------------------------------
if "%cert_ident%"=="" goto cert_list
goto cert_check


:cert_list
echo  - Listing all certificates in [%cert_store%]
echo -------------------------------------------------------------------------------
certutil.exe -store %cert_store% > "%cert_dump%"
echo  - Output written to: %cert_dump%
goto done


:cert_check
echo  - Checking in store [%cert_store%]
echo  - Find: %cert_ident%
if "%cert_path%"=="" goto cert_missing
verify > nul & certutil.exe -store %cert_store% | findstr "%cert_ident%"
IF '%ERRORLEVEL%'=='0' goto cert_found
goto cert_install

:cert_install
echo  - Install Certificate...
if "%cert_path%"=="" goto cert_missing
certutil.exe -addstore -f "%cert_store%" "%cert_path%"
goto done

:cert_found
echo  - Note: Certificate already exists.
goto done

:cert_missing
echo  - Warning: Please specify a certificate to install...
goto done


:done
echo -------------------------------------------------------------------------------
echo  - Done
echo -------------------------------------------------------------------------------
pause