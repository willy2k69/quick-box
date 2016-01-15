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
curl -LO https://raw.githubusercontent.com/JMSDOnline/quick-box/master/commands/upgradeBTSync /usr/bin/ >/dev/null 2>&1;

# Convert upgrade shell scripts to executable
chmod +x /usr/bin/upgradeBTSync

# Start the Upgrade/Install
upgradeBTSync

