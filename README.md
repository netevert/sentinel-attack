![Icon](https://github.com/netevert/sentinel-attack/blob/master/docs/logo.png)
=========

[![Maintenance](https://img.shields.io/maintenance/yes/2019.svg?style=flat-square)]()
[![GitHub last commit](https://img.shields.io/github/last-commit/BlueTeamToolkit/sentinel-attack.svg?style=flat-square)](https://github.com/BlueTeamToolkit/sentinel-attack/commit/master)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![](https://img.shields.io/badge/2019-DEF%20CON%2027-blueviolet?style=flat-square)](https://cloud-village.org/)

Sentinel ATT&CK aims to simplify the rapid deployment of a threat hunting capability that leverages Sysmon and MITRE ATT&CK on Azure Sentinel.

**DISCLAIMER:** The tool presented is not a magic bullet. It will require tuning and real investigative work to be truly effective in your environment.

 ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/demo.gif)

 Sentinel ATT&CK provides the following:
 - A dashboard to monitor execution of ATT&CK techniques 
 - A [Sysmon configuration file](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/sysmonconfig.xml) mapped to specific ATT&CK techniques  
 - A Sysmon log parser mapped against the [OSSEM](https://github.com/Cyb3rWard0g/OSSEM) data model
 - 119 Kusto detection rules mapped against ATT&CK
 - A [Terraform](https://www.terraform.io/) script to provision a Sentinel ATT&CK test lab in Azure
 - [Hunting Jupyter notebooks](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/hunting) to assist with process drill-down 
 - [Guides](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/guides) to help you leverage the materials in this repository

Head over to the [getting started guide](https://github.com/BlueTeamToolkit/sentinel-attack/tree/defcon/guides/getting-started.md) to install Sentinel ATT&CK.

Please note that this repository is constantly being updated. If you spot any problems within the repository we warmly welcome pull requests or issue submissions.
