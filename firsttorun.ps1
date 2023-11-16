#first to run sript by sprawdzone.it


#rdp enable
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

#power profile set to High Performance
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

#set time zone
Set-TimeZone -id "Central European Standard Time"

#set network address to first physical
$ipifIndex = (Get-NetAdapter -Name * -Physical).ifIndex
$ipaddress = Read-Host -Prompt "Enter IP Address" 
$ipprefix = Read-Host -Prompt "Enter Prefix" 
$ipgateway = Read-Host -Prompt "Enter Gateway Address"
$dns1 = Read-Host -Prompt "Enter first DNS Address"
$dns2 = Read-Host -Prompt "Enter second DNS Address"
$dns = @{
InterfaceIndex = $ipifIndex
ServerAddresses = ("$dns1","$dns2")
}
New-NetIPAddress -InterfaceIndex $ipifIndex -IPAddress $ipaddress -PrefixLength $ipprefix -DefaultGateway $ipgateway
Set-DnsClientServerAddress @dns


#icmp ping IP4 / IP6
New-NetFirewallRule -DisplayName "ICMP Allow Ping V4" -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow
New-NetFirewallRule -DisplayName "ICMP Allow Ping V6" -Direction Inbound -Protocol ICMPv6 -IcmpType 8 -Action Allow

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
