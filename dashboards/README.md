Installing the ATT&CK telemetry dashboard in Azure
===

Uploading dashboards in Azure sentinel is quick and easy. The following steps must be done:

1. Sign into your [Azure portal](https://portal.azure.com)
2. Head to the Dashboards blade
3. Download the [ATT&CK telemetry dashboard](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/dashboards/attack_telemetry.json) provided
4. Change the {Subscription_Id}, {Resource_group} and {Workspace_name} in the JSON and insert your own
5. Click the **Upload** button on the toolbar located at the top of the webpage

See the GIF below for a full demonstration:

![demo](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/docs/upload-dashboard.gif)

Next, if needed, you should [upload selected Kusto queries into Sentinel analytics](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/detections/README.md).
