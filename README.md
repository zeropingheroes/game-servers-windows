# game-servers-windows
Windows game server configs, launchers and downloaders for our LAN parties.

## Installation

## Prerequisites

- Windows 10 or later
- PowerShell 5.1 or later
- Administrator privileges

### Enable PowerShell Script Execution

Before running the scripts, you need to enable PowerShell script execution:

1. Open PowerShell as Administrator
2. Allow local scripts to run: 
   ```
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Unblock the scripts in this repository:
   ```
   Get-ChildItem -Path . -Recurse -Filter *.ps1 | Unblock-File
   ```

## Usage

Run the main script with administrator privileges:

```powershell
.\game-servers.ps1 install <game>
.\game-servers.ps1 launch <game>
```

## Configuration

Configuration files are automatically symlinked to the server directory when launching the server.

## Troubleshooting

If you get an error about script execution being disabled, follow the steps in the "Enabling PowerShell Script Execution" section above.
