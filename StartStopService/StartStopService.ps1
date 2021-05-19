param (
	$ServicesList,
    $Action
)

function myStopService {
    param (
    $serviceName
    )
    $Timeout = New-TimeSpan -Seconds 30

    $ServiceObj = Get-Service $serviceName -ErrorAction SilentlyContinue
    if ($ServiceObj) #run the rest of the script only if service was found
    {
		write-host "Stop: $serviceName ..." 
        if ($ServiceObj.Status -EQ "Running")
        {
            $ServiceObj | Stop-Service #or $ServiceObj.name
        
            #wait for the service to stop 
            $timeout = (Get-Date) + $Timeout
            do {
                sleep -Seconds 1
            }  until ( (($ServiceObj | Get-Service).Status -eq "Stopped") -or ( (Get-Date) -ge $timeout ) )
        }
    } else {
    Write-Warning "sorry, no such service: $serviceName Continue..."
    }
}

function myStartService {
    param (
    $serviceName
    )
    $Timeout = New-TimeSpan -Seconds 30

    $ServiceObj = Get-Service $serviceName -ErrorAction SilentlyContinue
    if ($ServiceObj) #run the rest of the script only if service was found
    {
		write-host "Start: $serviceName ..." 
        if ($ServiceObj.Status -ne "Running")
        {
            $ServiceObj | Start-Service #or $ServiceObj.name
        
            #wait for the service to start 
            $timeout = (Get-Date) + $Timeout
            do {
                sleep -Seconds 1
            }  until ( (($ServiceObj | Get-Service).Status -eq "Running") -or ( (Get-Date) -ge $timeout ) )
        }
    } else {
    Write-Warning "sorry, no such service: $serviceName Continue..."
    }
}

##=================
## main
##=================
Try
{
    $ServiceArray = $ServicesList.split(",");

    #Stop
    foreach($serviceName in $ServiceArray)
    {
        if (($Action -eq "Restart") -or ($Action -eq "Stop")) { 
	        myStopService -serviceName $serviceName
        }
    }

    ##ReverseOrder and start
    [array]::Reverse($ServiceArray)
    foreach($serviceName in $ServiceArray)
    {
        if (($Action -eq "Restart") -or ($Action -eq "Start")) { 
	        myStartService -serviceName $serviceName
        }
    }
}

Catch [Exception]
{
	$ErrorMessage = $_.Exception.Message
	Throw "$ErrorMessage";
}
Finally
{

}