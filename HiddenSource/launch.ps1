# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

Write-Host "Launching Hidden Source Dedicated Server..."

# Launch the server
$serverDir = Join-Path $scriptPath $SERVER_DIR
$srcdsPath = Join-Path $serverDir "srcds.exe"

$srcdsArgs = @(
    "-game", "hidden",
    "-console"
    "+sv_lan", "1",
    "+exec", "zph-hidden.cfg"
)

Start-Process -FilePath $srcdsPath -ArgumentList $srcdsArgs
