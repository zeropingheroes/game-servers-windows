param(
    [Parameter(Mandatory=$false)]
    [switch]$Validate
)

# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

$serverArchivePath = Join-Path $scriptPath "GoldenEye_Source_v5.0.6_full_server_windows.7z"

if (-not (Test-Path -Path $serverArchivePath -PathType Leaf)) {
    Write-Host "Downloading GoldenEye Source 5.0.6 server archive..."
    $downloadUrl = "https://drive.usercontent.google.com/download?id=15ikRfTc5TBJmSyWGo1H6_OzscPU9HGFT&confirm=y"

    # Download without progress bar
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $downloadUrl -OutFile $serverArchivePath
}

Write-Host "Extracting GoldenEye Source 5.0.6 server archive..."
$serverPath = Join-Path $scriptPath $SERVER_DIR
if (-not (Test-Path $serverPath)) {
    New-Item -ItemType Directory -Path $serverPath -Force | Out-Null
}
& ${env:ProgramFiles}\7-Zip\7z.exe x $serverArchivePath "-o$($serverPath)" -y

Write-Host "Updating Source 2007 Dedicated Server..."
Install-SteamApp -gamePath $scriptPath -appId 310 -validate:$Validate

Write-Host "Creating config hard links..."
CreateConfigFileLinks -gamePath $scriptPath -LinkType HardLink

Write-Host "Installation complete!"
