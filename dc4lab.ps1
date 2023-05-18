#create lab domain by sprawdzone.it

# add AD feature wuth tools
Add-WindowsFeature AD-Domain-Services -IncludeManagementTools

# give domain name and create it
$domainname = Read-Host -Prompt "Enter Domain Name"

Install-ADDSForest
 -CreateDnsDelegation:$false `
 -DatabasePath "C:\Windows\NTDS" `
 -DomainMode "Win2016" `
 -DomainName $domainname `
 -ForestMode "Win2016" `
 -InstallDns:$true `
 -LogPath "C:\Windows\NTDS" `
 -NoRebootOnCompletion:$false `
 -SysvolPath "C:\Windows\SYSVOL" `
 -Force:$true
