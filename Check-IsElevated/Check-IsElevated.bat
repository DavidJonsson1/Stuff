::Swich Dir
SET DIRECTORY=%~dp0
SET DIRECTORY=%DIRECTORY:~0,-1%

::Get sFTP files
powershell -file "%DIRECTORY%\Check-IsElevated.ps1"
pause