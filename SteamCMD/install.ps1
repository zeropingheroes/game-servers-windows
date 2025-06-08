# Get script directory
$scriptPath = $PSScriptRoot

Write-Host "Downloading SteamCMD..."
$zipPath = Join-Path $scriptPath "steamcmd.zip"
$downloadUrl = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

Write-Host "Extracting SteamCMD..."
Expand-Archive -Path $zipPath -DestinationPath $scriptPath -Force

Write-Host "Removing SteamCMD zip file..."
Remove-Item -Path $zipPath -Force

if (Test-Path (Join-Path $scriptPath "steamcmd.exe")) {
    Write-Host "Running SteamCMD self-update..."
    Start-Process -FilePath (Join-Path $scriptPath "steamcmd.exe") -ArgumentList "+quit" -NoNewWindow -Wait
    Write-Host "SteamCMD is ready to use!"
} else {
    Write-Error "Error: Could not find steamcmd.exe"
    exit 1
}
