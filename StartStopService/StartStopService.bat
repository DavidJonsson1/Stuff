::Swich Dir
SET DIRECTORY=%~dp0
SET DIRECTORY=%DIRECTORY:~0,-1%

::Restart Single service
powershell set-executionpolicy unrestricted
powershell -file "%DIRECTORY%\StartStopService.ps1" -ServicesList "Themes" -Action "Restart"
set /a myError=%ERRORLEVEL%

::Stop Single service
powershell set-executionpolicy unrestricted
powershell -file "%DIRECTORY%\StartStopService.ps1" -ServicesList "Themes" -Action "Stop"
set /a myError=%ERRORLEVEL%

::Restart multiple services, note: stop and start order will be reversed.
::Use Stop Order on input
powershell set-executionpolicy unrestricted
powershell -file "%DIRECTORY%\StartStopService.ps1" -ServicesList "Themes,WebClient" -Action "Restart"
set /a myError=%ERRORLEVEL%

exit /b %myError%
