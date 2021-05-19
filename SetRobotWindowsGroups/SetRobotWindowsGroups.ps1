Param(
   [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][String]$member,
   [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][String]$makeAdminString
)

Try
{
    $RobotRoles = ('Remote Desktop Users','Users')

    $makeAdminBool = $false
    if ($makeAdminString -eq "Y" -or $makeAdminString -eq "y") {
	    $makeAdminBool = $true
    }

    #Remove all memberships
    $groups = Get-LocalGroup | select Name
    foreach ($group in $groups) {
        Remove-LocalGroupMember -Group $group -Member $member -ErrorAction SilentlyContinue
    }

    #Add needed Groups for Robot role
    foreach ($role in $RobotRoles) {
        Add-LocalGroupMember -Group $role -Member $member -ErrorAction Stop
    }

    #Add Admin?
    if ($makeAdminBool) {
        Add-LocalGroupMember -Group "Administrators" -Member $member -ErrorAction Stop
    }

    $result = 0
}

catch [Exception]
{
    $ErrorMessage = $_.Exception.Message
	Write-Error "$ErrorMessage"
    $result = 1
}
finally
{
    exit $result
}