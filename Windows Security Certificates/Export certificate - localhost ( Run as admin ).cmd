@echo off 

set certPath=%~dp0
set certName=localhost

echo -------------------------------------------------------------------------------

rem makecert.exe -n "CN=%certName%" -pe -ss my -sr LocalMachine -sky exchange -m 96 -a sha1 -len 2048 -r "%certPath%\sample.cer" 
rem certutil.exe -f -addstore Root "%certPath%\sample.cer" 
certutil.exe -privatekey -exportpfx "%certName%" "%certPath%\%certName%.pfx" 

echo -------------------------------------------------------------------------------
:done
pause 
