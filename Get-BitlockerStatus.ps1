[CmdletBinding()]

Param
(

    [Parameter(Position = 0, Mandatory = $true, HelpMessage = "You must enter a vaild hostname. Duh.")]
    [ValidateNotNullOrEmpty()]
    [string]$CSHostname,  
    [string]$ErrorActionPreference = "SilentlyContinue"
   
)
BEGIN {
    try {
        . ("C:\Powershell\Classes\APIPowerUp.ps1")
    }
    catch {
        Write-Host "Error while loading supporting PowerShell Scripts" 
        break
    }
}
PROCESS {               
    $FalconID = Get-FalconHost -Filter "hostname:'$CSHostname'"

    $FalconID_Test = (Get-FalconHost -Filter "hostname:'$CSHostname'").Count
    If ($falconID_Test -gt 1 ) {
        $FalconID = Get-FalconHost -Detailed -Filter "hostname:'$CSHostname'" | Select @{N = 'ComputerName'; E = { $_.hostname } }, * | Out-GridView -Title "Select ComputerName you want, then press OK" -OutputMode Single
    }
    else {
        $FalconID = Get-FalconHost -Filter "hostname:'$CSHostname'"
    }
    (Invoke-FalconRTR -Command runscript -Arguments "-CloudFile='Bitlocker Status'" -HostIds $FalconId.device_id).stdout    
}
    
End {}
