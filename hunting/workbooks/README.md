Hunting workbooks quickstart
====

Within Sentinel, workbooks are made available in preview form as a means to build richer and more interactive dashboards over log analytics workspaces. Workbooks can be used to build more powerful dashboards with better drill-down capabilities without having to leverage the full-power and granularity offered by Jupyter notebooks.

It is recommended to read the [official Microsoft documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-workbooks) to get an understanding of how workbooks function.


## Overview

This folder contains an Azure workbook that provides an overview of ATT&CK triggers within a selected time range. More dashboards will be added in the coming months to replicate, as much as feasible, the behaviour of [Olaf Hartong's](https://github.com/olafhartong) Splunk [ThreatHunting App](https://splunkbase.splunk.com/app/4305/).


1. Sign into your [Azure portal](https://portal.azure.com)
2. Activate workbook preview in Azure by typing https://portal.azure.com/?feature.workbooks=true in your URL bar
3. Head to the Sentinel blade and then click on workbooks under the Threat Management menu
4. Download the [ATT&CK trigger overview](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/hunting/workbooks/trigger_overview.json) provided
5. Change the {Subscription_Id}, {Resource_group} and {Workspace_name} in the JSON and insert those reflecting your environment
6. Click Add Workbooks
7. Click the edit button
8. Click on the advanced editor button "</>"
9. Within the Gallery Template type copy-paste the workbook json
10. Click Apply
11. Click on the Save button

A GIF outlining the process above can be seen at the link below:

![View GIF](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/docs/upload-workbooks.gif)
