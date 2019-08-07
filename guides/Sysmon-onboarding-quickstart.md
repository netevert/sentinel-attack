Quickstart: onboarding sysmon data to Azure Sentinel
====================================================

This is a quick, super terse guide to onboarding Sysmon data to Azure Sentinel. At the end of this guide you'll have a basic, yet functioning Sentinel lab to test out the [detection rules](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/detections) provided in this repository.

- **Step 1: Provision a Windows 10 virtual machine (or machines) in your [Azure environment](https://portal.azure.com).**
  
  You can follow microsoft's official documentation or use the included terraform [deployment script](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/lab) to quickly provision a lab. If you use the terraform script create a variables.tfvars file in the root directory, using the [variables.tfvars.txt](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/lab/variables.tfvars.txt) file as a template and making sure to complete all fields.

- **Step 2: Provision a log analytics workspace**
  
  The second step is to provision a log analytics workspace into which an Azure Sentinel will be deployed
  
  ![demo1](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/docs/deploy-analytics.gif)


- **Step 3: Deploy an Azure Sentinel instance**

  The third step is to deploy the Azure Sentinel SIEM instance
  
  ![View demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/deploy-sentinel.gif)

- **Step 4: Install Sysmon and load the provided sysmon configuration file on virtual machines**

  **NOTE:** If during step 1 you have deployed your lab using the included terraform [deployment script](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/lab) you can skip this step.
  
  In order for the virtual machines in your lab/network to send the correct data to Sentinel you must:

  1. Install Sysmon on the virtual machines to monitor; to do so follow the [official documentation](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
  2. Download the provided [sysmon configuration file](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/sysmonconfig.xml) on the virtual machines to monitor
  3. Load the conguration file by executing the following command within the directory containing _sysmonconfig.xml_ :

      ´´´
      sysmon -c sysmonconfig.xml
      ´´´

- **Step 5: Enable security events**
 
  The fifth step is to enable the collection of security events
  
  ![View demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/enable-security-events.gif)

- **Step 6: Activate windows event logs as data sources**
 
  The sixth step is to activate the collection of the correct event logs. The correct event logs are:
    - Application
    - Microsoft-Windows-Sysmon/Operational
    - Microsoft-Windows-WMI-Activity/Operational
    - System

  **Note that _Microsoft-Windows-Sysmon/Operational_ does not appear in the drop down menu. You must hit enter after inputting the data source to add it to the list**
  
  ![View demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/enable-event-logs.gif)


- **Step 7: Connect Virtual Machine(s) to Sentinel**
  
  The seventh step is to connect the virtual machine to Sentinel to being collecting sysmon data
  
  ![View demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/connect-vm.gif)


- **Step 8: Check Sysmon data transmission**
  
  The eighth step is to check that sysmon data is correctly being forwarded to sentinel, the following Kusto Query can be run to verify the correct transmission of sysmon data:

        Event | where Source == "Microsoft-Windows-Sysmon" | limit 20

  **Note that at this stage raw, unparsed data is being sent to sentinel**
  
  ![View demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/data-test.gif)

- **Step 9: Install Sysmon event parser**
  
  The final step is to install the windows event parser to ensure Sysmon events are stored and parsed according to the [OSSEM standard](https://github.com/Cyb3rWard0g/OSSEM) and to allow for compatibility with the repository's [detection rules](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/detections).
  
  ![View demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/install-parser.gif)

Next, you should [Install the ATT&CK telemetry dashboard on Azure](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/dashboards/README.md).
