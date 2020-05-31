![Icon](https://github.com/netevert/sentinel-attack/blob/master/docs/logo.png)
=========

[![Maintenance](https://img.shields.io/maintenance/yes/2020.svg?style=flat-square)]()
[![GitHub release](https://img.shields.io/github/release/BlueTeamLabs/sentinel-attack.svg?style=flat-square)](https://github.com/BlueTeamLabs/sentinel-attack/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![](https://img.shields.io/badge/2019-DEF%20CON%2027-blueviolet?style=flat-square)](https://cloud-village.org/#talks?olafedoardo)

Sentinel ATT&CK aims to simplify the rapid deployment of a threat hunting capability that leverages Sysmon and [MITRE ATT&CK](https://attack.mitre.org/) on Azure Sentinel.

**DISCLAIMER:** This tool requires tuning and investigative trialling to be truly effective in a production environment.

 ![demo](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/docs/demo.gif)

### Overview
 Sentinel ATT&CK provides the following set of tools: 
 - A [Sysmon configuration file](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/sysmonconfig.xml) compatible with Azure Sentinel and mapped to specific ATT&CK techniques  
 - A [Sysmon log parser](https://github.com/BlueTeamToolkit/sentinel-attack/blob/master/parser/Sysmon-OSSEM.txt) mapped against the [OSSEM](https://github.com/Cyb3rWard0g/OSSEM) data model
 - 117 ready-to-use Kusto [detection rules](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/detections) covering 156 ATT&CK techniques
 - A [Sysmon threat hunting workbook](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/hunting) inspired by the [Threat Hunting App](https://splunkbase.splunk.com/app/4305/) for Splunk to help simplify threat hunts
 - A [Terraform](https://www.terraform.io/) script to provision a lab to test Sentinel ATT&CK
 - Comprehensive guidance to help you use the materials in this repository

### Usage
Head over to the [WIKI](https://github.com/BlueTeamLabs/sentinel-attack/wiki) to learn how to deploy and run Sentinel ATT&CK.

A copy of the DEF CON 27 cloud village presentation introducing Sentinel ATT&CK can be found [here](https://cloud-village.org/#talks?olafedoardo) and [here](https://github.com/BlueTeamToolkit/sentinel-attack/tree/master/docs/DEFCON_attacking_the_sentinel.pdf).

### Contributing
As this repository is constantly being updated and worked on, if you spot any problems we warmly welcome pull requests or submissions on the issue tracker.

### Authors and contributors
Sentinel ATT&CK is built with ❤ by:
- Edoardo Gerosa 
[![Twitter Follow](https://img.shields.io/twitter/follow/netevert.svg?style=social)](https://twitter.com/netevert)

Special thanks go to the following contributors:

- Olaf Hartong
[![Twitter Follow](https://img.shields.io/twitter/follow/olafhartong.svg?style=social)](https://twitter.com/olafhartong) 
- Ashwin Patil
[![Twitter Follow](https://img.shields.io/twitter/follow/ashwinpatil.svg?style=social)](https://twitter.com/ashwinpatil)
- Mor Shabi
[![Twitter Follow](https://img.shields.io/twitter/follow/Mor44574618.svg?style=social)](https://twitter.com/Mor44574618)
- [Adrian Corona](https://github.com/temores)