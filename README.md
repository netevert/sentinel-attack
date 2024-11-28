[![GitHub release](https://img.shields.io/github/v/release/netevert/sentinel-attack.svg?style=flat-square)](https://github.com/netevert/sentinel-attack/releases)
[![Maintenance](https://img.shields.io/maintenance/yes/2024.svg?style=flat-square)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![](https://img.shields.io/badge/2019-DEF%20CON%2027-blueviolet?style=flat-square)](https://2019.cloud-village.org/#talks?olafedoardo)

Sentinel ATT&CK aims to simplify the rapid deployment of a threat hunting capability that leverages Sysmon and [MITRE ATT&CK](https://attack.mitre.org/) on Azure Sentinel.

**DISCLAIMER:** This tool requires tuning and investigative trialling to be truly effective in a production environment.

### Overview
 Sentinel ATT&CK provides the following tools: 
 - A [Sysmon log parser](https://github.com/netevert/sentinel-attack/blob/master/parser/Sysmon-OSSEM.txt) mapped against the [OSSEM](https://github.com/OTRF/OSSEM) data model and compatible with the [Sysmon Modular XML configuration file](https://github.com/olafhartong/sysmon-modular/blob/master/sysmonconfig.xml)
 - 117 ready-to-use Kusto [detection rules](https://github.com/netevert/sentinel-attack/tree/master/detections) covering 156 ATT&CK techniques

### Usage
Head over to the [WIKI](https://github.com/netevert/sentinel-attack/wiki) to learn how to deploy and run Sentinel ATT&CK.

A copy of the DEF CON 27 cloud village presentation introducing Sentinel ATT&CK can be found [here](https://2019.cloud-village.org/#talks?olafedoardo) and [here](https://github.com/netevert/sentinel-attack/blob/master/docs/DEFCON_attacking_the_sentinel.pdf).

### Contributing
This repository is work in progress, if you spot any problems we welcome pull requests or submissions on the issue tracker.

### Authors and contributors
Sentinel ATT&CK is built with ❤ by:
- Edoardo Gerosa 
[![Twitter Follow](https://img.shields.io/twitter/follow/edoardogerosa.svg?style=social)](https://twitter.com/edoardogerosa)

Special thanks go to the following contributors:

- Olaf Hartong
[![Twitter Follow](https://img.shields.io/twitter/follow/olafhartong.svg?style=social)](https://twitter.com/olafhartong) 
- Ashwin Patil
[![Twitter Follow](https://img.shields.io/twitter/follow/ashwinpatil.svg?style=social)](https://twitter.com/ashwinpatil)
- Mor Shabi
[![Twitter Follow](https://img.shields.io/twitter/follow/Mor44574618.svg?style=social)](https://twitter.com/Mor44574618)
- [Adrian Corona](https://github.com/temores)
