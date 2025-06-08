#Requires -Version 5.1

param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('install', 'launch')]
    [string]$Command,
    
    [Parameter(Mandatory=$true, Position=1)]
    [ValidateSet('TheShip', 'HiddenSource', 'SteamCMD')]
    [string]$Game,

    [Parameter(Mandatory=$false)]
    [switch]$Validate
)

# Set console title and colors
$Host.UI.RawUI.WindowTitle = "Zero Ping Heroes Windows Game Server Manager"

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script requires administrator privileges. Please run PowerShell as administrator."
    exit 1
}

# Import shared functions
. "$PSScriptRoot\functions.ps1"

# Get script directory
$scriptPath = $PSScriptRoot

# Get game path
$gamePath = Join-Path $scriptPath $Game

# Main script logic
try {
    switch ($Command) {
        'install' {
            # If steamcmd.exe is not found, install it
            if (-not (Test-Path (Join-Path $PSScriptRoot "SteamCMD\steamcmd.exe"))) {
                $steamCmdInstallScript = Join-Path $PSScriptRoot "SteamCMD\install.ps1"
                if (Test-Path $steamCmdInstallScript) {
                    & $steamCmdInstallScript
                } else {
                    throw "SteamCMD install script not found"
                }
            }

            # Run game-specific install script
            $installScript = Join-Path $gamePath "install.ps1"
            if (Test-Path $installScript) {
                & $installScript -Validate:$Validate
                
                # Create config symlinks if not SteamCMD
                if ($Game -ne 'SteamCMD') {
                    CreateConfigSymlinks -gamePath $gamePath
                }
            } else {
                throw "Install script not found for $Game"
            }
        }
        'launch' {
            # Run game-specific launch script
            $launchScript = Join-Path $gamePath "launch.ps1"
            if (Test-Path $launchScript) {
                & $launchScript
            } else {
                throw "Launch script not found for $Game"
            }
        }
        default {
            throw "Invalid command. Use 'install' or 'launch'."
        }
    }
} catch {
    Write-Error "Error: $_"
    exit 1
}