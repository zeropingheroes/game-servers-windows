param(
    [Parameter(Mandatory=$false)]
    [switch]$Validate
)

# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

$installerPath = Join-Path $scriptPath "GHSI.exe"

if (-not (Test-Path -Path $installerPath -PathType Leaf)) {
    Write-Host "Downloading `"Gee's Hidden Source Installer`" (GHSI.exe)..."
    $downloadUrl = "https://github.com/GeeTwentyFive/GHSI/releases/download/V6/GHSI.exe"

    # Download without progress bar
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
}

Write-Host "Running `"Gee's Hidden Source Installer`" (GHSI.exe)..."
$serverPath = Join-Path $scriptPath $SERVER_DIR
if (-not (Test-Path $serverPath)) {
    New-Item -ItemType Directory -Path $serverPath -Force | Out-Null
}
Start-Process -FilePath $installerPath -Wait

function Get-SteamRegistryProperty($propertyName) {
    $path = ""

    try {
        # Attempt to retrieve the specified path from the registry
        $path = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Valve\Steam").$propertyName
    }
    catch {
        Write-Host "Could not find $propertyName in Windows registry. Make sure Steam is installed."
        exit 1
    }

    # Ensure we found a valid path
    if (-not $path) {
        Write-Host "$propertyName is empty."
        exit 1
    }

    return $path
}

$SourceModInstallPath = Get-SteamRegistryProperty "SourceModInstallPath"

$hiddenPath1 = Join-Path -Path $SourceModInstallPath -ChildPath "hidden"
$hiddenPath2 = Join-Path -Path $SourceModInstallPath -ChildPath "hidden-4a"

Write-Host "Moving `"Hidden: Source files`" from Steam sourcemods folder to server folder"
$destinationPath1 = Join-Path -Path $serverPath -ChildPath "hidden"
$destinationPath2 = Join-Path -Path $serverPath -ChildPath "hidden-4a"
if (Test-Path $destinationPath1) {
    Remove-Item $destinationPath1 -Force -Recurse
}
if (Test-Path $destinationPath2) {
    Remove-Item $destinationPath2 -Force -Recurse
}
Move-Item -Path $hiddenPath1 -Destination $serverPath -Force
Move-Item -Path $hiddenPath2 -Destination $serverPath -Force

Write-Host "Updating Source SDK Base 2006..."
Install-SteamApp -gamePath $scriptPath -appId 215 -validate:$Validate

Write-Host "Creating config symlinks..."
CreateConfigSymlinks -gamePath $scriptPath
Write-Host "Updating Source Dedicated Server..."
Install-SteamApp -gamePath $scriptPath -appId 205 -validate:$Validate

Write-Host "Installation complete!"
