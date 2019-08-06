Hunting Jupyter notebooks quickstart
====

Within Sentinel [Jupyter notebook](https://jupyter.org/) are made available as a means to build more granular threat hunting solutions to be applied over log analytics workspaces.

It is recommended to read the [official Microsoft documentation](https://docs.microsoft.com/en-us/azure/sentinel/notebooks) to get an understanding of how Sentinel and Jupyter notebooks complement each other as well as getting to know how notebooks work.


## Overview

This folder contains a Jupyter notebook to help with process investigations and especially with drilldowns. In a nutshell this notebook helps threat hunters with:

a) gaining a high-level overview of ATT&CK tactics executed within a network and mapped against the [killchain](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html):

![demo1](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/killchain-overview.png)

b) generating a summary of ATT&CK techniques executed on a machine:

![demo2](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/technique-overview.png)

c) inspecting individual ATT&CK techniques to extract and examine processes (by event ID) executed by attackers:

![demo3](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/process-overview.png)

## Installation 

Installing this notebook is quick and easy, to do so you must follow the steps outlined in the GIF below:

![demo4](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/docs/upload-notebook.gif)

You must also ensure to upload the [config.ini](https://github.com/BlueTeamToolkit/sentinel-attack/blob/defcon/hunting/config.ini) file provided and to complete all relevant credentials.

## Caveats

This notebook is **work in progress** and will consistently receive updates and improvements.

Additionally this Jupyter notebook allows investigators to perform process drilldowns only for Sysmon logs carrying event ID 1. Support for more event IDs will be added in the future.
