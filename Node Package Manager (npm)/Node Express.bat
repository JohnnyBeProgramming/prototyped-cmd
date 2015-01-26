@echo off

echo - Setup express server

if not exist "%APPDATA%\npm\node_modules\express-generator" (
	echo - Installing express generator 
	call npm install express-generator -g > nul || goto:error
)
if not exist "src" (
	echo - Creating the 'src' folder
	call express src > nul || goto:error
)
cd "src"
if not exist "node_modules" (
	echo - Installing node modules...
	call npm install > nul || goto:error
)

echo - Starting server...
start chrome http://localhost:3000/
call npm start > Event.logs

:done
echo - Done. & goto:done
:error
echo - Oops! Something went wrong! & goto:done
:done
pause > nul