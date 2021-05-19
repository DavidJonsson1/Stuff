param (
	$ProccessName,
	$memThresholdKb,
	$ServicesList
)

function myRestart {
    param (
    $serviceName
    )
    $restartTimeout = New-TimeSpan -Seconds 30

    $ServiceObj = Get-Service $serviceName -ErrorAction SilentlyContinue
    if ($ServiceObj) #run the rest of the script only if bth service was found
    {
		write-host "Restart: $serviceName ..." 
        if ($ServiceObj.Status -EQ "Running")
        {
            $ServiceObj | Stop-Service #or $ServiceObj.name
        
            #wait for the service to stop 
            $timeout = (Get-Date) + $restartTimeout
            do {
                sleep -Seconds 1
            }  until ( (($ServiceObj | Get-Service).Status -eq "Stopped") -or ( (Get-Date) -ge $timeout ) )
        }
    
        $ServiceObj | Start-Service #or $ServiceObj.name
		write-host "Restart: $serviceName Done!" 
    } else {
    Write-Warning "sorry, no such service running: $serviceName Continue..."
    }
}

##=================
## main
##=================
Try
{
    $restart = $false

    if ((Get-Process -Name $ProccessName -ErrorAction SilentlyContinue)) {
        Get-Process -Name $ProccessName | ForEach-Object {
            $CurrentMb = [Math]::Round(($_.workingSet / 1mb),2)
            $thisPid = $_.Id

            write-host "notepad with PDI: $thisPid, running at mem: $CurrentMb (Mb)"

                $out = & taskkill /F /FI "memusage gt $memThresholdKb" /pid $_.Id
                if ($out.Contains("SUCCESS: The process with PID")) {
                    write-host "Killed pid: $thisPid"
                    $restart = $true
                }
        }
    } else {
        Write-Host "$ProccessName is currently not running"
    }

    if ($restart -eq $true) {
        write-host "Restart service in list: $ServicesList ..."
        $ServiceArray = $ServicesList.split(",");
        foreach($serviceName in $ServiceArray)
        {
	        myRestart -serviceName $serviceName
        }
    }
}

Catch [Exception]
{
	$ErrorMessage = $_.Exception.Message
	Throw "$ErrorMessage";
	Start-Sleep -s 3
}
Finally
{

}