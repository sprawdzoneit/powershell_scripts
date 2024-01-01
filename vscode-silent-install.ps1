#Visual Studio Code silent install, add extension and create configruation file by sprawdzone.it

#region download and install VSCode

#url for user or system installer
$url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
#$url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"

#file path
$file = $env:TEMP + "\vscode.exe"

#download VSCode
Invoke-WebRequest $url -OutFile $file

#config file for silent installation - !DIR is for SYSTEM type!
$VSCCfg = @"
[Setup]
Lang=english
Dir=C:\Program Files\Microsoft VS Code
Group=Visual Studio Code
NoIcons=0
Tasks=desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath
"@ | Out-File -FilePath "$env:TEMP\Config.ini"

#start VSCode silent installation process with config file
Start-Process -Wait $file -ArgumentList "/LOADINF=$env:TEMP\Config.ini /SILENT"

#delete files after install
Remove-Item $file
Remove-Item $env:TEMP\Config.ini

#endregion

#region extension installation

#!check path to code.cmd - version for User or System
#$VSCCmdPath = "c:$env:HOMEPATH\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
$VSCCmdPath = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

$extension = 'ms-vscode.powershell'
Start-Process -wait $VSCCmdPath -ArgumentList "--install-extension $extension"

$extension2 = "vscode-icons-team.vscode-icons"
Start-Process -wait $VSCCmdPath -ArgumentList "--install-extension $extension2"

$extension3 = "wraith13.zoombar-vscode"
Start-Process -wait $VSCCmdPath -ArgumentList "--install-extension $extension3"

$extension4 = "Kipters.codeshell"
Start-Process -wait $VSCCmdPath -ArgumentList "--install-extension $extension4"

#endregion


#region VSCode configuration
#create config json file which extensions from above

$vscconfigjson = @"
{ "workbench.iconTheme": "vscode-icons",
"workbench.colorTheme": "PowerShell ISE",
"files.defaultLanguage": "powershell",
"editor.formatOnType": true,
"editor.formatOnPaste": true,
"editor.fontSize": 16,
"powershell.integratedConsole.focusConsoleOnExecute": false,
"window.zoomLevel": 0,
"editor.mouseWheelZoom": true,
"git.ignoreMissingGitWarning": true,
"vsicons.dontShowNewVersionMessage": true,
"editor.minimap.enabled": false,
"workbench.settings.applyToAllProfiles": [],
}
"@ | Out-File -FilePath "c:$env:HOMEPATH\AppData\Roaming\Code\User\settings.json" -Force -Encoding utf8

#endregion
