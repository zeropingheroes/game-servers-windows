# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

Write-Host "Launching Hidden Source Dedicated Server..."

# Launch the server
$serverDir = Join-Path $scriptPath $SERVER_DIR
$srcdsPath = Join-Path $serverDir "srcds.exe"

$srcdsArgs = @(
    "-console",
    "-game", "hidden",
    "+exec", "server-zph.cfg",
    "+sv_lan", "1",
    "-maxplayers", "10",
    "+map", "hdn_derelict"
)

Start-Process -FilePath $srcdsPath -ArgumentList $srcdsArgs
