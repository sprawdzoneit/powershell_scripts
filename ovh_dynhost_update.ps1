#OVH DynHost update with PowerShell by sprawdzone.it

#PowerSHell script to get actual IP and update DNS record on domain handled by ovh.com. It uses the DynHost API

#get my actual IP address from ipinfo.io
$ip = (Invoke-RestMethod http://ipinfo.io/json).ip

#my domain in OVH
$domain = "domainname.ovh"

#my user and password for DynHost - password should not contain characters / " \ # @
$username = "domainname.ovh-myip"
$password = "q21.cufUMb9e3"

#create objects - webclient and credentials
$webclient = New-Object system.Net.WebClient;
$credsCache = new-object System.Net.CredentialCache
$creds = new-object System.Net.NetworkCredential($username, $password)

#login to api using objects
$credsCache.Add("https://${username}:${password}@www.ovh.com/nic/update?myip=${ip}&hostname=${domain}&system=dyndns", "Basic", $creds)
$webclient.Credentials = $credsCache
$url="https://${username}:${password}@www.ovh.com/nic/update?myip=${ip}&hostname=${domain}&system=dyndns"
write-host $url
$webclient.downloadString($url)


