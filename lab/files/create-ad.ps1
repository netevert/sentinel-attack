# Provision domain
Import-Module ADDSDeployment
$password = ConvertTo-SecureString "fDIUH68dkjwuhd52333" -AsPlainText -Force
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName "helheim.local" -DomainNetbiosName "helheim" -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true
shutdown -r -t 10