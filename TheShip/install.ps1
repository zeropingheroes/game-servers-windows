param(
    [Parameter(Mandatory=$false)]
    [switch]$Validate
)

# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

Write-Host "Updating The Ship Dedicated Server..."
$steamUsername = Read-Host "Enter your Steam username"
Install-SteamApp -gamePath $scriptPath -appId 2403 -steamUsername $steamUsername -validate:$Validate

Write-Host "Creating config symlinks..."
CreateConfigSymlinks -gamePath $scriptPath

Write-Host "Installation complete!"
