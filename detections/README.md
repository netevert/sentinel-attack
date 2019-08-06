Sentinel ATT&CK detections usage guide
===

This folder contains 119 Kusto queries than can be used to:

- Create Azure Sentinel detection rules
- Execute hunts for specific ATT&CK techniques

**DISCLAIMER:** Please note that this folder is work in progress and is constaintly updated. It is likely you will come across detections that might require some fine tuning to function 100%. If you spot any issues in the Kusto source code feel free to open an issue or submit a pull request.

### Create Azure Sentinel detection rules

The detection queries in this repository can be used to create sentinel detection rules through the analytics blade.

Each detection rule provides the following information in the rule comments:

| Information               | Description                                    |
| ------------------------- | ---------------------------------------------- |
| Name                      | Name of detection rule                         |
| Description               | Description of detection rule                  |
| Severity                  | Alert severity to set in Sentinel analytics    |
| Query frequency           | Query frequency to set in Sentinel analytics   |
| Query period              | Query period to set in Sentinel analytics      |
| Alert trigger threshold   | Alert threshold to set in Sentinel analytics   |
| Tactics                   | ATT&CK tactic addressed by detection rule      |

Creating detection rules in Azure sentinel is done like so:

![demo1](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/upload-detection-rules.gif)

### Execute hunts for specific ATT&CK techniques

The detection rules in this folder can also be used to conduct one-off threat hunts to try and discover specific ATT&CK techniques executed on a network, like so:

![demo2](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/execute-hunts.gif)

Next, if needed, you could [Upload available threat hunting Jupyter notebooks in your Sentinel Azure workspace](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/hunting/README.md).
