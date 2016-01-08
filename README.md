| ![Quick Box - A Friendly, Fresh and Modernized Seedbox Script](https://github.com/JMSDOnline/quick-box/blob/master/img/quick-box.png "Quick Box") |
|---|
| **Quick Box - A Friendly, Fresh and Modernized Seedbox Script** |

For Ubuntu 15.04 & 15.10 installs.

## Script status

[![Version 1.0.1-development](https://img.shields.io/badge/version-1.0.1%20dev-674172.svg?style=flat-square)](https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer)
[![MIT License](https://img.shields.io/badge/license-MIT%20License-blue.svg?style=flat-square)](https://github.com/JMSDOnline/quick-box/blob/master/LICENSE)
[![Ubuntu 15.10 Passing](https://img.shields.io/badge/Ubuntu%2015.10-passing-brightgreen.svg?style=flat-square)](https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer)
[![Ubuntu 15.04 Passing](https://img.shields.io/badge/Ubuntu%2015.04-passing-brightgreen.svg?style=flat-square)](https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer)
[![Ubuntu 14.04 Testing](https://img.shields.io/badge/Ubuntu%2014.04-trials-F7CA18.svg?style=flat-square)](https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer)
[![Ubuntu 12.04 Fails](https://img.shields.io/badge/Ubuntu%2012.04-fails-F22613.svg?style=flat-square)](https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer)

---

## UPDATE as of 01/07/2016

> I am going to place all release versions of this script in development mode. You may download the repo and install, but please do so at your own risk. I will outline some changes as well as why I am making the decision to label this development. 

> **Update** The issue appears to have been with bad default mirrors when selecting from key geographic locations, i.e; US, NL, FR & DR. I have tested on a couple of different VM's and a small dedi provided via One Provider and it installs the required packages without issue. All that is required at this moment is adding in any key's that may be needed for installing said packages... however, this can be bypassed as Plex and BTSync are being built from source provided via the /sources/ directory and not using unreliable ppa's.

  1. Updating jquery for rutorrent. The included (already) addition jquery.browser.js has been updated, thus, I am running tests against this new js for any screw ups that may occur...
  2. A couple of really good requests have been made. Placing the repo into a development status (no - I don't want to use a development branch) ensures that future downloads receive full functionality... and it adds full transparency to what has been committed as additions to the script.
  3. Lesser repos have a hard time with the libcurl4-openssl-dev dependency. I am still trying to figure out why this is occurring. Although, this dependency shouldn't have any ill effects on the initial success... I do believe all should be in tact and in stable working order... something other seedbox repos are focusing on so much.
  4. I have additional time in the next couple of days to really hammer out some trials on the script. If anyone wants to join me... spin up a vm and run some tests to see what you find, open a issue or push over some fixes and I'll add them and throw all the credit your way.

### Additional notes on status::

  15.10 is successfully built. ~~However, there is an issue where rtorrent is failing to start. This is priority and it first on the list of things to fix... asap~~ FIXED. In some late night coding binge in one of these fateful commits I decided to delete a trailing '/' during the xmlrpc-c build... as a result, the directory was not moving to root for the configure/male process... this is resolved.

  15.04 same as 15.10

  14.04 libcurl dependency stops the rest of the build from happening... in this way apache fails to install etc etc. This is priority and up next on the list of fix it now **Additional note to self and anyone listening** - I don't think we'll need this dependency as a build without it passes now that the xmlrpc-c fiasco is resolved. .

  12.04 same as 14.04

---

This script has the following features

* A multi-user environment, complete with scripts to add and delete users.
* Linux Quota, to control how much space every user can use in the box.
* Customized Seedbox Dashboard located at http://SERVER_IP/
* HTTPs Downloads directory (https://SERVER_IP/private/Downloads)

## Installed software
* ruTorrent 3.7 + official plugins
* rTorrent 0.9.6
* libTorrrent 0.13.6
* mktorrent
* Linux Quota
* SSH Server (for SSH terminal and sFTP connections)
* pureftp - vsftp (CuteFTP multi-segmented download friendly ya'll)
* IRSSI
* Plex
* BTSync

### Quick Box Seedbox Dashboard
![Modern & Simple Seedbox Dashboard](https://github.com/JMSDOnline/quick-box/blob/master/img/quick-box-dashboard.png "Quick Box Modern & Simple Seedbox Dashboard")

### Quick Box Seedbox Custom ruTorrent Theme by JMSolo Designs
![New and Custom Theme by JMSolo Designs](https://github.com/JMSDOnline/quick-box/blob/master/img/quick-box-theme.png "Quick Box - New and Custom Theme by JMSolo Designs")

## Main ruTorrent plugins
autotoolscpuload, quotaspace, erasedata, extratio, extsearch, feeds, filedrop, filemanager, geoip, history, logoff, mediainfo, mediastream, ratiocolor, rss, scheduler, screenshots, theme, trafic and unpack

## Additional ruTorrent plugins
* Autodl-IRSSI (with an updated list of trackers)
* A modified version of Diskpace to support quota (by Notos)
* Filemanager (modified to handle rar, zip, unzip, tar and bzip)
* Fileupload
* Fileshare Plugin (http://forums.rutorrent.org/index.php?topic=705.0)
* MediaStream (_No longer a valid plugin due to current browser limitations on inline java_)
* Logoff 
* Theme: QuickBox ``Dark rutorrent skin``
* Colorful Ratios: Customized to match QuickBox Theme
* __rutorrentMobile__: Mobile version of ruTorrent - seriously - toss TransDroid and the pain that it is... this is a new essential plugin (IMO) _Helps usher in a future version of the Quick Box script per Nginx - **as nginx via fastcgi sockets can break Transdroid funtionality**_

### Full List of Plugins

**_Custom Quick Box Plugins_**

  1. **Theme**: QuickBox Dark rutorrent skin

**_Main ruTorrent Plugins_**

  1. **getdir**: This plug-in provides the possibility of comfortable navigation on a host file system.
  2. **noty/noty2**: This plugin provides the notification functionality for other plugins.
  3. **task**: This plugin provides the possibility of running various scripts on the host system.
  4. **autodl-irssi**: GUI for autodl-irssi-community
  5. **check_port**: This plugin adds an incoming port status indicator to the bottom bar.
  6. **cookies**: This plugin provides cookies information for authentication on trackers.
  7. **data**: This plugin allows to copy torrent data files from the host to the local machine.
  8. **diskspace**: This plugin adds an easy to read disk meter to the bottom bar.
  9. **erasedata**: This plugin allows to delete torrent data along with .torrent file.
  10. **extsearch**: This plugin allows to search many popular torrent sites for content from within ruTorrent.
  11. **filemanager**: File Manager plugin.
  12. **fileupload**: Sharing services file uploader.
  13. **history**: This plugin is designed to log a history of torrents.
  14. **ipad**: This plugin allows ruTorrent to work properly on iPad-like devices.
  15. **logoff**: The plug-in allows users to logoff from rutorrent.
  16. **mediainfo**: This plugin is intended to display media file information.
  17. **ratio**: This plugin allows to manage ratio limits for groups of torrents.
  18. **retrackers**: This plugin appends specified trackers to the trackers list of all newly added torrents.
  19. **rss**: This plugin is designed to fetch torrents via rss download links.
  20. **rutracker_check**: This plugin checks the rutracker.org tracker for updated/deleted torrents.
  21. **screenshots**: This plugin is intended to show screenshots from video files.
  22. **show_peers_like_wtorrent**: This plugin changes the format of values in columns 'Seeds' and 'Peers' in the torrents list.
  23. **theme**: This plugin allows to change the UI theme to one of several provided themes.
  24. **tracklabels**: This plugin adds tracker-based labels to the category panel.
  25. **autotools**: This plugin provides some possibilities on automation.
  26. **chunks**: This plugin shows the download status of torrent chunks.
  27. **create**: This plugin allows for the creation of new .torrent files.
  28. **datadir**: This plugin is intended for moving torrent data files.
  29. **edit**: This plugin allows to edit the list of trackers and change the comment of the current torrent.
  30. **feeds**: This plugin is intended for making RSS feeds with information of torrents.
  31. **filedrop**: This plugin allows users to drag multiple torrents from desktop to the browser (FF > 3.6 & Chrome only).
  32. **fileshare**: File share plugin.
  33. **geoip**: This plugin shows geolocation of peers for the selected torrent.
  34. **httprpc**: This plugin is a low-traffic replacement for the mod_scgi webserver module.
  35. **loginmgr**: This plugin is used to login to torrent sites in cases where cookies fail.
  36. **lookat**: This plugin allows to search for torrent name in external sources.
  37. **mediastream**: Video streaming plugin.
  38. **quotaspace**: The plug-in adds to status bar an indicator of available disk space (with quota support).
  39. **ratiocolor**: Change color of ratio column depending on ratio.
  40. **rpc**: This plugin is a replacement for the mod_scgi webserver module.
  41. **rssurlrewrite**: This plugin extends the functionality of the RSS plugin.
  42. **scheduler**: This plugin allows to define any of six rTorrent behavior types at each particular hour of 168 week hours.
  43. **seedingtime**: This plugin adds the columns 'Finished' and 'Added' to the torrents list.
  44. **source**: This plugin allows to copy the source .torrent file from the host to the local machine.
  45. **trafic**: This plugin allows to monitor rTorrent system wide and per-tracker traffic totals.
  46. **unpack**: This plugin is designed to manually or automatically unrar/unzip torrent data.

---

## Before installation
You need to have a Fresh "blank" server installation.
After that access your box using a SSH client, like PuTTY.

## Warnings

#### If you don't know Linux ENOUGH:

DO NOT attempt to install NGINX as a frontend proxy if you plan to use Transdroid (http://www.transdroid.org/). Doing so will cause the app to either not connect or crash repeatedly

DO NOT use capital letters, all the usernames should be written in lowercase.

DO NOT upgrade anything in the box, feel free to open an issue and ask before attempting this on a current (in production) server.

DO NOT try to reconfigure packages using other tutorials - this script (AS IS) is designed to work with what's included.

---

## How to install
> This script is valid for both VPS & Dedicated Environments.

**First, let's install git & curl**
```
apt-get -y install git curl

```
**Next, we clone the repo to the server and create a ~/tmp/quick-box/ directory _the script does this for you_**
```
git clone https://github.com/JMSDOnline/quick-box.git ~/tmp/quick-box/
cd tmp/quick-box

```
**Finally, run that funky script to unleash the goodies**
```
chmod +x quickbox-apache.sh
./quickbox-apache.sh

```

---

####You must be logged in as root to run this installation or use sudo on it.

## Commands
After installing you will have access to the following commands to be used directly in terminal

* createSeedboxUser
* deleteSeedboxUser
* setdisk
* reload
* restartSeedbox

---

### INFO:
---


#### Files List:
  * jquery.browser.js - update JS file
  * jquery.browser.min.js - Updated JS file
  * plugins [directory] - rutorrent plugins
  * rarlinux-x64-5.1.0.tar.gz - rar for linux
  * rtorrent.sh - quick-box seedbox installer
  * rutorrent - rutorrent web folder
  * rutorrent-quickbox-dark.zip - Custom quick-box ruTorrent kkin
  * skel.tar - Default skel directory for the 'adduser' command
  * sources [directory] - Folder containing rtorrent/libtorrent
  * commands [directory] - Folder containing various functions for user creation etc. _if you desire them_
  * xmlrpc-c - xmlrpc-c source

#### Known Bugs/Fixes
  1. Fix the private flag when new torrent is made
   ``` 
   sed -i 's/\$torrent->is_private(true);/\$torrent->is_private(false);/g' /var/www/rutorrent/plugins/create/createtorrent.php 
   ```
  2. ruTorrent Homepage failing to show running processes
   * __CAUSE:__ due to the kernel/debian version trims off usernames and appends a + at the end, causes the script to fail to grab the correct stats
   * __SOLUTION:__ ``` wget https://raw.githubusercontent.com/JMSDOnline/quick-box/master/rutorrent/home/index.php -O /srv/rutorrent/home/index.php ```

#### BUILDING ERRORS
  * If ffmpeg/rtorrent/libtorrent/xmlrpc-c fails to build.. check /etc/fstab for 'noexec' flag (_but this should be fixed_)

#### TIPS/TRICKS
  ``` 
  apt-get update && apt-get install -yy screen && wget https://raw.githubusercontent.com/JMSDOnline/quick-box/master/quickbox-apache.sh -q && screen bash quickbox-apache.sh 
  ```