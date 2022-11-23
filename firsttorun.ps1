#first to run sript by sprawdzone.it


#rdp enable
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

#power profile set to High Performance
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

#set time zone
Set-TimeZone -id "Central European Standard Time"

#network file & printer sharing enable
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Any

#enable winrm - attention! safety risk
winrm quickconfig -quiet

#set executionpolicy for scripts - attention! safety risk
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

#set network name
$nname = (Get-NetAdapter -Name * -Physical).Name
$lname = Read-Host -Prompt "Enter new network adapter name"
Rename-NetAdapter $nname -NewName $lname

#disable enhanced security in IE for admins
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' -name "IsInstalled" -value 0

#change hostname
$cname = Read-Host -Prompt "Enter new hostname"
Rename-Computer -NewName $cname -Restart
