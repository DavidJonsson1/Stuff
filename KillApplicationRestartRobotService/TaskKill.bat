@ECHO off
::============
::Params - EDIT ME!
::============
::ProccessName. Get-process *note*
set ProccessName=notepad

::How much memory is too much? i.e when to Kill App(integer in Kb)
set /A memThreshold=200

::If we kill, then restart this process list.
::Comman seperated List
::Note: the Order within this the string matters (if the services are dependent on each other)
set ServicesList=UiPath RobotJS Service,DummyService
::============

::Get currentDir
SET currentDir=%~dp0
SET currentDir=%currentDir:~0,-1%

::Call Powershell
powershell set-executionpolicy unrestricted
echo "%currentDir%\TaskKill.ps1" -ProccessName "%ProccessName%" -memThreshold %memThreshold% -ServicesList "%ServicesList%"
powershell.exe -file "%currentDir%\TaskKill.ps1" -ProccessName "%ProccessName%" -memThreshold %memThreshold% -ServicesList "%ServicesList%" > "%currentDir%\TaskKill.log"

::return errorcode to Schedule Task
set /a ErrorCode=%ERRORLEVEL%
ECHO %sErrorCode%
exit /b %ErrorCode%



::============
::p.s
::============
::note that the processName is not(!) .exe/.dll ImageName. You can get ProcessName via powerShell, e.g:
::Get-Process *note*
::Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
::-------  ------    -----      -----     ------     --  -- -----------
::    553      32   237092     263860       3.95   2304   2 notepad
::    568      36   102540     130780      12.73   6312   2 notepad++

::Get-Process *robot*
::Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
::-------  ------    -----      -----     ------     --  -- -----------
::    349      36    26540      15548              3148   0 UiPath.RobotJS.ServiceHost
::    445      42    25312       6432       0.88   2116   2 UiPath.RobotJS.UserHost