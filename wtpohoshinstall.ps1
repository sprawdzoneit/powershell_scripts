#Windows Terminal Oh My Posh and PowerShell 7 install by sprawdzone.it
# full automate configure Oh My Posh on Windows Terminal

# 1. download and install font
# 2. install PowerShell 7
# 3. install oh my posh 
# 4. update Windows PowerShell and PowerShell 7 profiles
# 5. update settings file



#region font

Clear-Host
Write-Host "Installing font"

#font pack URL
$fontsurl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip"

#creating a temporary folder for fonts
New-Item -Name tmpfonts -Path $env:TEMP -ItemType Directory

#font pack download
$file = $env:TEMP + "\tmpfonts\font.zip"
Invoke-WebRequest $fontsurl -OutFile $file

#font copy and register
$fontspath = $env:SystemRoot + "\Fonts"
Expand-Archive -Path $file -DestinationPath $($env:Temp + "\tmpfonts") -Force
Copy-Item "$($env:Temp+ "\tmpfonts")\CaskaydiaCoveNerdFont-Regular.ttf" -Destination $fontspath -Force
New-ItemProperty -Name "CaskaydiaCove NF" -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value "CaskaydiaCoveNerdFont-Regular.ttf"

#cleaning after font pack
Remove-Item -Path $($env:Temp + "\tmpfonts") -Recurse -Force

#endregion


#region app
Clear-Host 
Write-Host "Installing apps"
$id = "Microsoft.Powershell"
winget list -q $id --source winget  | Out-Null 
if ($?) {
    Write-Host "$id is installed."
} 
else {
    Write-Host "Installing $id"
    winget install --id $id --silent --accept-source-agreements --accept-package-agreements --source winget
}

Clear-Host
$id = $null

$id = "JanDeDobbeleer.OhMyPosh"
winget list -q $id --source winget  | Out-Null 
if ($?) {
    Write-Host "$id is installed."
} 
else {
    Write-Host "Installing $id"
    winget install --id $id --silent --accept-source-agreements --accept-package-agreements --source winget
}

#endregion


#region profile
Clear-Host
Write-Host "Updating PWSH and PS profile"

#required command in profile for oh-my-posh
$profileline = "oh-my-posh init pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression"

#paths for profiles
$pwshprofile = $($home + "\Documents\PowerShell\Microsoft.PowerShell_profile.ps1")
$psprofile = $($home + "\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1")
$pwsh = Test-Path -Path $pwshprofile
$ps = Test-Path -Path $psprofile

#adding command into pwsh profile
if (! $pwsh) {
    New-Item -path $pwshprofile -type File -force
    Add-Content -Path $pwshprofile -Value $profileline
}
else
{ Add-Content -Path $pwshprofile-Value $profileline }

#adding command into ps profile
if (! $ps) {
    New-Item -path $psprofile -type File -force
    Add-Content -Path $psprofile -Value $profileline
}
else
{ Add-Content -Path $psprofile-Value $profileline }

#endregion


#region WT settings file
Clear-Host
Write-Host "Updating Windows Terminal Settings"

#path for JSON settings file
$settingsfile = $env:USERPROFILE + "\APPDATA\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

$settings = Test-Path $settingsfile

#start terminal - to create settings file if not exist
if (! $settings) {
    #start terminal - to create settings file when not exist
    Write-Host "Restarting Windows Terminal"
    start wt.exe
    Start-Sleep 3
    Stop-Process -Name WindowsTerminal -Force
    Start-Sleep 3
}

Write-Host "Updating settings file"
#get conntent settings json file - connvert json -  add two key Font and Face - export to json
$settingsfile = $env:USERPROFILE + "\APPDATA\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$json = Get-Content $settingsfile | ConvertFrom-Json 

#add font to default profile
$json.profiles.defaults | Add-Member -NotePropertyName font -NotePropertyValue ([PSCustomObject]@{face = "CaskaydiaCove NF" })

#set default profile to PWSH
$json.defaultProfile = "{574e775e-4f2a-5b96-ac1e-a2962a402336}"

#export to json config
$json | ConvertTo-Json -Depth 10 | Set-Content $settingsfile

#endregion

Clear-Host
Write-Host "Windows Terminal is ready"
