#create lab domain by sprawdzone.it

#install 
Add-WindowsFeature AD-Domain-Services

# give domain name and promote
$domainname = Read-Host -Prompt "Enter Domain Name"
Install-ADDSForest -DomainName $domainname -InstallDNS
