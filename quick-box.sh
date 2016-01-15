#!/bin/bash
#
# [Quick Box Installation Script]
#
# GitHub:   https://github.com/JMSDOnline/quick-box
# Author:   Jason Matthews
# URL:      https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer
#
# 

# Download git for grabbing our Repo
apt-get install -y -qq --force-yes git

# Download the needed scripts for Quick Box
git clone https://github.com/JMSDOnline/quick-box.git /root/tmp/quick-box/ >/dev/null 2>&1;
cd /root/tmp/quick-box

# Convert all shell scripts to executable
chmod +x *.sh

# Start the Install
./quickbox-master.sh

