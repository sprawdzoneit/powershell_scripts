# DHCP role migration by sprawdzone.it

# parameters
$olddhcp = "dc11.sprawdzone.it"
$newdhcp = "dc12.sprawdzone.it"
$newdhcpip = "10.40.128.107"
$dhcpbackuppath = "C:\dhcpbackup" 
$configfile = "C:\oldDHCPconf.xml"

# export DHCP configuration from old server
Export-DhcpServer -ComputerName $olddhcp -Leases -File $configfile –Verbose

# install DHCP role on new server
Install-WindowsFeature -Name DHCP -IncludeManagementTools -ComputerName $newdhcp

# ad newserver to security groupdhcp
Add-DhcpServerSecurityGroup -ComputerName $newdhcp

# import DHCP configuration file to new server
New-Item -Path = $dhcpbackuppath -ItemType Directory
Import-DhcpServer -Leases –File $configfile -BackupPath $dhcpbackuppath -ScopeOverwrite -Force -ComputerName $newdhcp –Verbose

# authorize DHCP new server in AD
Add-DhcpServerInDC -DnsName $newdhcp -IPAddress $newdhcpip
Restart-Service DHCPServer -Force

# unauthorize old DHCP server
Remove-DhcpServerInDC -DnsName $olddhcp 

# uninstall DHCP role from old server
Uninstall-WindowsFeature -Name DHCP -IncludeManagementTools -ComputerName $olddhcp -Restart
