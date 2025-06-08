# Constants
$SERVER_DIR = "server"
$CONFIG_DIR = "configs"

function Install-SteamApp {
    param (
        [string]$gamePath,
        [string]$appId,
        [string]$steamUsername = "anonymous",
        [bool]$validate = $false
    )
    
    $steamCmdPath = Join-Path $PSScriptRoot "SteamCMD\steamcmd.exe"
    $serverPath = Join-Path $gamePath $SERVER_DIR
    
    # Create "server" directory if it doesn't exist
    if (-not (Test-Path $serverPath)) {
        New-Item -ItemType Directory -Path $serverPath -Force | Out-Null
    }

    if ($validate) {
        $validateFlag = "validate"
    } else {
        $validateFlag = ""
    }
    
    # Install or update Steam app
    try {
        $steamCmdArgs = @(
            "+force_install_dir", $serverPath,
            "+login", $steamUsername,
            "+app_update", $appId,
            $validateFlag,
            "+quit"
        ) | Where-Object { $_ -ne "" }
        
        $steamCmdProcess = Start-Process -FilePath $steamCmdPath -ArgumentList $steamCmdArgs -NoNewWindow -PassThru
        $steamCmdProcess.WaitForExit()
    }
    catch {
        if ($steamCmdProcess) {
            $steamCmdProcess.Kill()
        }
        throw
    }
}

function CreateConfigSymlinks {
    param (
        [string]$gamePath
    )
    
    $configPath = Join-Path $gamePath $CONFIG_DIR
    $serverPath = Join-Path $gamePath $SERVER_DIR
    
    # Skip if config directory doesn't exist
    if (-not (Test-Path $configPath)) {
        Write-Host "No config directory found at $configPath - skipping symlink creation"
        return
    }
    
    # Get all config files
    $configFiles = Get-ChildItem -Path $configPath -File
    
    foreach ($file in $configFiles) {
        $sourcePath = $file.FullName
        $targetPath = Join-Path $serverPath $file.Name
        
        # Remove existing file/symlink if it exists
        if (Test-Path $targetPath) {
            Remove-Item $targetPath -Force
        }
        
        # Create symlink
        New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath -Force | Out-Null
        Write-Host "Created symlink for $($file.Name)"
    }
}