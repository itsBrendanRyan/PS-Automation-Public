<# 
.SYNOPSIS
    Checks if Azure AD Connect service is enabled, and updates Ninja custom field azureADConnect with a yes/no status. 

.DESCRIPTION 
    Checks for service "ADSync" and gets startup type (startType). If startType is set to "Automatic", sets isADConnectServer to true. Then, sets NinjaRMM role custom field to true or false. 
 
.NOTES 
    Windows Server 2016 or later. 
    Azure AD Connect v 2.1.16.0

.COMPONENT 
    None

.LINK 
    None
 
.PARAMETER service
    The Azure AD Connect service information

.PARAMETER startType
    The service startup type setting for service

.PARAMETER isADConnectServer
    Binary value used to set NinjaRMM custom field. 1 if startType is Automatic, 0 if startType is anything other than Automatic
#>


# Check if service exists, if so, get service information and startup type
$service = Get-Service -Name ADSync -ErrorAction SilentlyContinue 
if ($service -eq $null) {
    # Service does not exist
    Ninja-Property-Set azureAdConnect 0
    exit
} else {
    # Service exists, get startup type
    $startType = $service.StartType
}

# Define additional vars as null
$isADConnectServer = $null

# Check if startup type is Automatic
if ($startType -eq "Automatic"){
    $isADConnectServer = $true
}

# Set NinjaRMM custom field 
if ($isADConnectServer) {
    Ninja-Property-Set azureAdConnect 1
}
else {
    Ninja-Property-Set azureAdConnect 0
}