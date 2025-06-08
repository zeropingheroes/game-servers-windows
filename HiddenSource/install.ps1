param(
    [Parameter(Mandatory=$false)]
    [switch]$Validate
)

# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

Write-Host "Downloading Hidden Source..."
$downloadUrl = "https://drive.usercontent.google.com/download?id=1-VEAtQemAetp360yaWqtdvO6XhYslZn9&confirm=y"
$zipPath = Join-Path $scriptPath "hsb4b-full.zip"

# Download without progress bar
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

Write-Host "Extracting Hidden Source to server directory..."
$serverPath = Join-Path $scriptPath $SERVER_DIR
if (-not (Test-Path $serverPath)) {
    New-Item -ItemType Directory -Path $serverPath -Force | Out-Null
}
Expand-Archive -Path $zipPath -DestinationPath $serverPath -Force

# Clean up
Remove-Item $zipPath -Force

Write-Host "Updating Source Dedicated Server..."
Install-SteamApp -gamePath $scriptPath -appId 205 -validate:$Validate

Write-Host "Updating Source SDK Base 2006..."
Install-SteamApp -gamePath $scriptPath -appId 215 -validate:$Validate

Write-Host "Creating config symlinks..."
CreateConfigSymlinks -gamePath $scriptPath

Write-Host "Installation complete!"
