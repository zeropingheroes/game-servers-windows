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

function CreateConfigFileLinks {
    param (
        [string]$gamePath,
        [ValidateSet("SymbolicLink", "HardLink")]
        [string]$LinkType = "SymbolicLink"
    )
    
    $configPath = Join-Path $gamePath $CONFIG_DIR
    $serverPath = Join-Path $gamePath $SERVER_DIR
    
    # Skip if config directory doesn't exist
    if (-not (Test-Path $configPath)) {
        Write-Host "No config directory found at $configPath - skipping symlink creation"
        return
    }
    
    # Get all config files recursively
    $configFiles = Get-ChildItem -Path $configPath -File -Recurse
    
    foreach ($file in $configFiles) {
        $sourcePath = $file.FullName
        
        # Calculate relative path from config root
        $relativePath = $file.FullName.Substring($configPath.Length).TrimStart('\','/')
        
        # Construct target path with same directory structure
        $targetPath = Join-Path $serverPath $relativePath
        
        # Ensure target directory exists
        $targetDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        
        # Remove existing item if present
        if (Test-Path $targetPath) {
            Remove-Item $targetPath -Force
        }
        
        # Create link of the specified type
        New-Item -ItemType $LinkType -Path $targetPath -Target $sourcePath -Force | Out-Null
        Write-Host "Created $LinkType at $targetPath"
    }
}

