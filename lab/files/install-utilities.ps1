# Making sure all names are resolved
Resolve-DnsName www.splunk.com
Resolve-DnsName download.splunk.com
Resolve-DnsName github.com
Resolve-DnsName raw.githubusercontent.com
Resolve-DnsName live.sysinternals.com

# Purpose: Installs a handful of SysInternals tools on the host into c:\Tools\Sysinternals
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing SysInternals Tooling..."
$sysinternalsDir = "C:\Tools\Sysinternals"
$sysmonDir = "C:\ProgramData\Sysmon"
If(!(test-path $sysinternalsDir)) {
  New-Item -ItemType Directory -Force -Path $sysinternalsDir
} Else {
  Write-Host "Tools directory exists. Exiting."
}
If(!(test-path $sysmonDir)) {
  New-Item -ItemType Directory -Force -Path $sysmonDir
} Else {
  Write-Host "Sysmon directory exists. Exiting."
}
$autorunsPath = "C:\Tools\Sysinternals\Autoruns64.exe"
$sysmonPath = "C:\Tools\Sysinternals\Sysmon.exe"
$sysmonConfigPath = "$sysmonDir\sysmonConfig.xml"

# Microsoft likes TLSv1.2 as well
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Autoruns64.exe..."
(New-Object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Autoruns64.exe', $autorunsPath)
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Sysmon.exe..."
(New-Object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Sysmon.exe', $sysmonPath)


# Download Olaf Hartongs Sysmon config
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Downloading Olaf Hartong's Sysmon config..."
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/olafhartong/sysmon-configs/master/sysmonconfig-v10.xml', "$sysmonConfigPath")

# Start Sysmon
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Starting Sysmon..."
Start-Process -FilePath "$sysmonPath" -ArgumentList "-accepteula -i $sysmonConfigPath"
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Verifying that the Sysmon service is running..."
Start-Sleep 5 # Give the service time to start
If ((Get-Service -name Sysmon).Status -ne "Running")
{
  throw "The Sysmon service did not start successfully"
}


# Purpose: Installs chocolatey package manager, then installs custom utilities from Choco and adds syntax highlighting for Powershell, Batch, and Docker. Also installs Mimikatz into c:\Tools\Mimikatz.

If (-not (Test-Path "C:\ProgramData\chocolatey")) {
  Write-Host "Installing Chocolatey"
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
  Write-Host "Chocolatey is already installed."
}

Write-Host "Installing Notepad++, Chrome, 7zip, Firefox."
choco install -y NotepadPlusPlus
choco install -y GoogleChrome
choco install -y Firefox
choco install -y 7zip

Write-Host "Utilties installation complete!"

# Purpose: Installs a Splunk Universal Forwarder on the host
If (-not (Test-Path "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe")) {
  Write-Host "Downloading Splunk Universal Forwarder"
  $msiFile = $env:Temp + "\splunkforwarder-7.1.0-2e75b3406c5b-x64-release.msi"
  Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Installing & Starting Splunk"
  (New-Object System.Net.WebClient).DownloadFile('https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=windows&version=7.1.0&product=universalforwarder&filename=splunkforwarder-7.1.0-2e75b3406c5b-x64-release.msi&wget=true', $msiFile)
  Start-Process -FilePath "c:\windows\system32\msiexec.exe" -ArgumentList '/i', "$msiFile", 'DEPLOYMENT_SERVER="10.0.1.7:8089" AGREETOLICENSE=Yes SERVICESTARTTYPE=1 LAUNCHSPLUNK=1 SPLUNKPASSWORD=F4354wtlsgkgje453 /quiet' -Wait
} Else {
  Write-Host "Splunk is already installed. Moving on."
}
If ((Get-Service -name splunkforwarder).Status -ne "Running")
{
  throw "Splunk forwarder service not running"
}
Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Splunk installation complete!"

# Debloat Windows
if ($env:PACKER_BUILDER_TYPE -And $($env:PACKER_BUILDER_TYPE).startsWith("hyperv")) {
  Write-Host Skip debloat steps in Hyper-V build.
} else {
  Write-Host Downloading debloat zip
  # GitHub requires TLS 1.2 as of 2/1/2018
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $url="https://github.com/StefanScherer/Debloat-Windows-10/archive/master.zip"
  (New-Object System.Net.WebClient).DownloadFile($url, "$env:TEMP\debloat.zip")
  Expand-Archive -Path $env:TEMP\debloat.zip -DestinationPath $env:TEMP -Force

  # Disable Windows Defender
  Write-host Disable Windows Defender
  $os = (gwmi win32_operatingsystem).caption
  if ($os -like "*Windows 10*") {
    set-MpPreference -DisableRealtimeMonitoring $true
  } else {
    Uninstall-WindowsFeature Windows-Defender-Features
  }

  # Optimize Windows Update
  Write-host Optimize Windows Update
  . $env:TEMP\Debloat-Windows-10-master\scripts\optimize-windows-update.ps1
  Write-host Disable Windows Update
  Set-Service wuauserv -StartupType Disabled

  # Turn off shutdown event tracking
  if ( -Not (Test-Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability'))
  {
    New-Item -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT' -Name Reliability -Force
  }
  Set-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability' -Name ShutdownReasonOn -Value 0

  rm $env:TEMP\debloat.zip
  rm -recurse $env:TEMP\Debloat-Windows-10-master
}

# Tweaks
# Remove OneDrive from the System
Write-Host "Removing OneDrive..."
$onedrive = Get-Process onedrive -ErrorAction SilentlyContinue
if ($onedrive) {
  taskkill /f /im OneDrive.exe
}
c:\Windows\SysWOW64\OneDriveSetup.exe /uninstall

Write-Host "Running Update-Help..."
Update-Help -Force -ErrorAction SilentlyContinue

Write-Host "Removing Microsoft Store, Mail, and Edge shortcuts from the taskbar..."
$appname = "Microsoft Edge"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
$appname = "Microsoft Store"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
$appname = "Mail"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt(); $exec = $true}
