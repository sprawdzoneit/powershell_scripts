#winget mass install apps by sprawdzone.it

$apps = "7zip.7zip", "Mozilla.Firefox", "Adobe.Acrobat.Reader.64-bit", "mRemoteNG.mRemoteNG", "DominikReichl.KeePass", "Notepad++.Notepad++", "Microsoft.PowerShell"

foreach ($app in $apps) {
    winget list -q $app | Out-Null
    if ($?) {
        Write-Host "$app is installed"
    } 
    else { 
        winget install --id $app --source winget 
    }
}
