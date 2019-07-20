Quickstart: onboarding sysmon data to Azure Sentinel
====================================================

This is a quick, super terse guide to onboarding Sysmon data to Azure Sentinel. At the end of this guide you'll have a basic, yet functioning Sentinel lab to test out the [detection rules](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/detections) provided in this repository.

- Step 1: Provision a Windows 10 virtual machine in your [Azure environment](https://portal.azure.com).
  You can follow microsoft's official documentation or use the included terraform [deployment script](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/lab) to quickly provision a lab. If you use the terraform script create a variables.tfvars file in the root directory, using the [variables.tfvars.txt](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/lab/variables.tfvars.txt) file as a template and making sure to complete all fields.

- Step 2: Provision a log analytics workspace
  The second step is to provision a log analytics workspace into which an Azure Sentinel will be deployed
  
  ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/deploy-analytics.gif)


- Step 3: Deploy an Azure Sentinel instance
    <details><summary>View details</summary>
    <p>

    The third step is to deploy the Azure Sentinel SIEM instance

    ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/deploy-sentinel.gif)

    </p>
    </details>

- Step 4: Enable security events
  <details><summary>View details</summary>
    <p>

    The fourth step is to enable the collection of security events

    ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/enable-security-events.gif)

    </p>
    </details>

- Step 5: Activate windows event logs as data sources
  <details><summary>View details</summary>
    <p>

    The fifth step is to activate the collection of the correct event logs. The correct event logs are:
    - Application
    - Microsoft-Windows-Sysmon/Operational
    - Microsoft-Windows-WMI-Activity/Operational
    - System

    **Note that _Microsoft-Windows-Sysmon/Operational_ does not appear in the drop down menu. You must hit enter after inputting the data source to add it to the list**

    ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/enable-event-logs.gif)

    </p>
    </details>

- Step 6: Connect Virtual Machine(s) to Sentinel
  <details><summary>View details</summary>
    <p>

    The sixth step is to connect the virtual machine to Sentinel to being collecting sysmon data

    ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/connect-vm.gif)

    </p>
    </details>

- Step 7: Check Sysmon data transmission
  <details><summary>View details</summary>
    <p>

    The seventh step is to check that sysmon data is correctly being forwarded to sentinel, the following Kusto Query can be run to verify the correct transmission of sysmon data:

        Event | where Source == "Microsoft-Windows-Sysmon" | limit 20

    **Note that at this stage raw, unparsed data is being sent to sentinel**

    ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/data-test.gif)

    </p>
    </details>

- Step 8: Install Sysmon event parser
  <details><summary>View details</summary>
    <p>

    The final step is to install the windows event parser to ensure Sysmon events are stored and parsed according to the [OSSEM standard](https://github.com/Cyb3rWard0g/OSSEM) and to allow for compatibility with the repository's [detection rules](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/detections).

    ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/docs/install-parser.gif)

    </p>
    </details>