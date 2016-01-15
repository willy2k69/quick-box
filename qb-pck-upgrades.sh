#!/bin/bash
#
# [Quick Box Installation Script]
#
# GitHub:   https://github.com/JMSDOnline/quick-box
# Author:   Jason Matthews
# URL:      https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer
#
# 

# Download the needed upgrade scripts for Quick Box
curl -o /usr/bin/upgradeBTSync https://raw.githubusercontent.com/JMSDOnline/quick-box/master/commands/upgradeBTSync

# Convert upgrade shell scripts to executable
chmod +x /usr/bin/upgradeBTSync

# Start the Upgrade/Install
upgradeBTSync
