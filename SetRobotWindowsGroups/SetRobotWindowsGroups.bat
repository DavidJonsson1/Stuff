@echo off
::Get DIRECTORY and Filename
SET DIRECTORY=%~dp0
SET DIRECTORY=%DIRECTORY:~0,-1%
SET scriptFile=%~n0

::User input
echo for local accounts just provide the name (without domain)
SET /P "member=Robot AD Account name?: [Domain\Username]: "
SET /p "makeAdminString=make account local Admin? [y|n]: "

powershell set-executionpolicy unrestricted
powershell -file "%DIRECTORY%\%scriptFile%.ps1" -member "%member%" -makeAdminString "%makeAdminString%"
SET /A myError=%ERRORLEVEL%

echo your errorcode is %myError%
pause