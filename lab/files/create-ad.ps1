# Provision domain
Import-Module ADDSDeployment
$password = ConvertTo-SecureString "{your_admin_password}" -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName "{your_domain}" -DomainNetbiosName "{your_netbios}" -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true
shutdown -r -t 10