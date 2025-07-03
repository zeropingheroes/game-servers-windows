# Get script directory
$scriptPath = $PSScriptRoot

# Import shared functions
. "$scriptPath\..\functions.ps1"

Write-Host "Launching GoldenEye Source Dedicated Server..."

# Launch the server
$serverDir = Join-Path $scriptPath $SERVER_DIR
$srcdsPath = Join-Path $serverDir "srcds.exe"

$srcdsArgs = @(
    "-game", "gesource",
    "-console",
    "+maxplayers", "32",
    "+exec", "server-zph.cfg",
    "+sv_lan", "1",
    "-ip", "0.0.0.0",
    "+map", "ge_runway"
)

Start-Process -FilePath $srcdsPath -ArgumentList $srcdsArgs
