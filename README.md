# game-servers-windows
Windows game server configs, launchers and downloaders for our LAN parties.

## Installation

1. Run `SteamCMD/download.bat`to download SteamCMD in the default browser

2. Extract `steamcmd.zip` into `SteamCMD`

## Usage

In each of the game folders, if present, run the following batch files in this order:

1. `install.bat` - Download and install the game files (some manual extraction may be required)

2. `copy-configs.bat` - Copy configuration files from the `configs/` directory in that folder into the game server's directory

3. `launch.bat` - Launch the game server

## Editing Config files

All config files in the `configs` directory are **copied** into the game server's folder, so if you update a config file, re-run `copy-configs.bat` to allow the game server to pick up the new version of the file.
