
For Ubuntu 15.04 & 15.10 installs.

## Script status

![script version 0.1](http://b.repl.ca/v1/script_version-0.1-lightgrey.png)    ![script build alpha](http://b.repl.ca/v1/script_build-alpha-22A7F0.png) 

This script has the following features

* A multi-user enviroment, complete with scripts to add and delete users.
* Linux Quota, to control how much space every user can use in the box.
* Customized Seedbox Dashboard located at http://SERVER_IP/
* HTTPs Downloads directory (https://SERVER_IP/private/Downloads)

## Installed software
* ruTorrent 3.7 + official plugins
* rTorrent 0.9.4
* libTorrrent 0.13.4
* mktorrent
* Linux Quota
* SSH Server (for SSH terminal and sFTP connections)
* pureftp
* IRSSI

## Main ruTorrent plugins
autotoolscpuload, quotaspace, erasedata, extratio, extsearch, feeds, filedrop, filemanager, geoip, history, logoff, mediainfo, mediastream, ratiocolor, rss, scheduler, screenshots, theme, trafic and unpack

## Additional ruTorrent plugins
* Autodl-IRSSI (with an updated list of trackers)
* A modified version of Diskpace to support quota (by Notos)
* Filemanager (modified to handle rar, zip, unzip, tar and bzip)
* Fileupload
* Fileshare Plugin (http://forums.rutorrent.org/index.php?topic=705.0)
* MediaStream (to watch your videos right from your seedbox) ``Currently an issue (see issues)``
* Logoff 
* Theme: QuickBox ``Dark rutorrent skin``
* Colorful Ratios: Customized to match QuickBox Theme

### Full List of Plugins

**_Custom Quick Box Plugins_**

  1. **Theme**: QuickBox Dark rutorrent skin

**_Main ruTorrent Plugins_**

  1. **getdir**: This plug-in provides the possibility of comfortable navigation on a host file system.
  2. **noty**: This plugin provides the notification functionality for other plugins.
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
apt-get --yes install git curl

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
  * rutorrent-clubKynetic-dark.zip - Custom quick-box ruTorrent Skin
  * skel.tar - Default skel directory for the 'adduser' command
  * sources - Folder containing rtorrent/libtorrent
  * xmlrpc-c - xmlrpc-c source

#### Known Bugs/Fixes
  1. Fix the private flag when new torrent is made
   * ``` 
   sed -i 's/\$torrent->is_private(true);/\$torrent->is_private(false);/g' /var/www/rutorrent/plugins/create/createtorrent.php 
   ```
  2. ruTorrent Homepage failing to show running processes
   * __CAUSE:__ due to the kernel/debian version trims off usernames and appends a + at the end, causes the script to fail to grab the correct stats
   * __SOLUTION:__ ``` wget https://raw.githubusercontent.com/JMSDOnline/quick-box/master/rutorrent/home/index.php -O /srv/rutorrent/home/index.php ```

#### BUILDING ERRORS
  * If ffmpeg/rtorrent/libtorrent/xmlrpc-c fails to build.. check /etc/fstab for 'noexec' flag (_but this should be fixed_)

#### TIPS/TRICKS
  ``` 
  apt-get update && apt-get install -yy screen && wget https://raw.githubusercontent.com/JMSDOnline/quick-box/master/rutorrent-apache.sh -q && screen bash rtorrent 
  ```