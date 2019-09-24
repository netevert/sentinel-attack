![Icon](https://github.com/netevert/sentinel-attack/blob/master/docs/logo.png)
=========

[![Maintenance](https://img.shields.io/maintenance/yes/2019.svg?style=flat-square)]()
[![GitHub last commit](https://img.shields.io/github/last-commit/BlueTeamToolkit/sentinel-attack.svg?style=flat-square)](https://github.com/BlueTeamToolkit/sentinel-attack/commit/master)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![](https://img.shields.io/badge/2019-DEF%20CON%2027-blueviolet?style=flat-square)](https://cloud-village.org/#talks?olafedoardo)

Sentinel ATT&CK aims to simplify the rapid deployment of a threat hunting capability that leverages Sysmon and MITRE ATT&CK on Azure Sentinel.

**DISCLAIMER:** This tool is not a magic bullet. It will require tuning and real investigative work to be truly effective in your environment.

 ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/docs/demo.gif)

### Overview
 Sentinel ATT&CK provides the following:
 - A [dashboard](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/dashboards/attack_telemetry.json) to monitor execution of ATT&CK techniques 
 - A [Sysmon configuration file](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/sysmonconfig.xml) mapped to specific ATT&CK techniques  
 - A [Sysmon log parser](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/parsers/Sysmon-OSSEM.txt) mapped against the [OSSEM](https://github.com/Cyb3rWard0g/OSSEM) data model
 - 117 Kusto [detection rules](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/detections) mapped against ATT&CK
 - A [Terraform](https://www.terraform.io/) script to provision a Sentinel ATT&CK test lab in Azure
 - [Hunting Jupyter notebooks](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/hunting/notebooks) and [Azure workbooks](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/hunting/workbooks) to assist with process drill-down 
 - Guides to help you leverage the materials in this repository

### Usage
Head over to the [getting started guide](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/guides/getting-started.md) to install Sentinel ATT&CK.

A copy of the DEF CON 27 presentation introducing Sentinel ATT&CK can be found [here](https://cloud-village.org/#talks?olafedoardo) and [here](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/DEFCON_attacking_the_sentinel.pdf).

### ATT&CK coverage

Sentinel ATT&CK's detection rules cover a total of 156 ATT&CK techniques:

![coverage](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/docs/sentinel_attack_coverage.JPG)

### Contributing
As this repository is constantly being updated and worked on, if you spot any problems we warmly welcome pull requests or submissions on the issue tracker.

### Authors and contributors
Sentinel ATT&CK is built with ❤ by:
- Edoardo Gerosa 
[![Twitter Follow](https://img.shields.io/twitter/follow/netevert.svg?style=social)](https://twitter.com/netevert)
- Olaf Hartong
[![Twitter Follow](https://img.shields.io/twitter/follow/olafhartong.svg?style=social)](https://twitter.com/olafhartong) 

Special thanks go to the following contributors:

- Ashwin Patil
[![Twitter Follow](https://img.shields.io/twitter/follow/ashwinpatil.svg?style=social)](https://twitter.com/ashwinpatil)
- Mor Shabi
[![Twitter Follow](https://img.shields.io/twitter/follow/Mor44574618.svg?style=social)](https://twitter.com/Mor44574618)
