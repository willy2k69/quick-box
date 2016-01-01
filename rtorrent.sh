#!/bin/bash
#
# [Quick Box Installation Script]
#
# GitHub:   https://github.com/JMSDOnline/quick-box
# Author:   Jason Matthews
# URL:      https://jmsolodesigns.com
#
# find server IP and server hostname for nginx configuration
HOSTNAME1=$(hostname -s);
REPOURL="/root/tmp/quick-box"

#Script Console Colors
black=$(tput setaf 0);red=$(tput setaf 1);green=$(tput setaf 2);yellow=$(tput setaf 3);blue=$(tput setaf 4);magenta=$(tput setaf 5);cyan=$(tput setaf 6);white=$(tput setaf 7);on_red=$(tput setab 1);on_green=$(tput setab 2);on_yellow=$(tput setab 3);on_blue=$(tput setab 4);on_magenta=$(tput setab 5);on_cyan=$(tput setab 6);on_white=$(tput setab 7);bold=$(tput bold);dim=$(tput dim);underline=$(tput smul);reset_underline=$(tput rmul);standout=$(tput smso);reset_standout=$(tput rmso);normal=$(tput sgr0);alert=${white}${on_red};title=${standout};sub_title=${bold}${yellow};repo_title=${black}${on_green};

# Color Prompt
sed -i.bak -e 's/^#force_color/force_color/' \
 -e 's/1;34m/1;35m/g' \
 -e "\$aLS_COLORS=\$LS_COLORS:'di=0;35:' ; export LS_COLORS" /etc/skel/.bashrc


function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }

# intro function (1)
function _intro() {
  echo
  echo
  echo "  [${repo_title}quick-box${normal}] ${title} Quick Box Seedbox Installation ${normal}  "
  echo "  ${alert} Configured and tested for Ubuntu 15.04 & 15.10 ${normal}  "
  echo
  echo

  echo "${green}Checking distribution ...${normal}"
  if [ ! -x  /usr/bin/lsb_release ]; then
    echo 'You do not appear to be running Ubuntu.'
    echo 'Exiting...'
    exit 1
  fi
  echo "$(lsb_release -a)"
  echo
  dis="$(lsb_release -is)"
  rel="$(lsb_release -rs)"
  if [[ "${dis}" != "Ubuntu" ]]; then
    echo "${dis}: You do not appear to be running Ubuntu"
    echo 'Exiting...'
    exit 1
  elif [[ ! "${rel}" =~ ("15.04"|"15.10") ]]; then
    echo "${bold}${rel}:${normal} You do not appear to be running a supported Ubuntu release."
    echo 'Exiting...'
    exit 1
  fi
}

# check if root function (2)
function _checkroot() {
  if [[ $EUID != 0 ]]; then
    echo 'This script must be run with root privileges.'
    echo 'Exiting...'
    exit 1
  fi
  echo "${green}Congrats! You're running as root. Let's continue${normal} ... "
  echo
}

# check if create log function (3)
function _logcheck() {
  echo -ne "${bold}${yellow}Do you wish to write to a log file?${normal} (Default: ${green}${bold}Y${normal}) "; read input
    case $input in
      [yY] | [yY][Ee][Ss] | "" ) OUTTO="quick-box.log";echo "${bold}Output is being sent to /root/quick-box.log${normal}" ;;
      [nN] | [nN][Oo] ) OUTTO="/dev/null 2>&1";echo "${cyan}NO output will be logged${normal}" ;;
    *) OUTTO="quick-box.log";echo "${bold}Output is being sent to /root/quick-box.log${normal}" ;;
    esac
  if [[ ! -d /root/tmp ]]; then
    rm -rf /root/tmp
    mkdir /root/tmp
    sed -i 's/noexec,//g' /etc/fstab
    mount -o remount /tmp >>"${OUTTO}" 2>&1
  fi
  echo
  echo "Press ${standout}${green}ENTER${normal} when you're ready to begin" ;read input
  echo
}

# package and repo addition (c) _add signed keys_
function _keys() {
  curl -s http://nginx.org/keys/nginx_signing.key | apt-key add - > /dev/null 2>&1;
  apt-get -y --force-yes install deb-multimedia-keyring > /dev/null 2>&1;
  echo "${OK}"
}

# package and repo addition (d) _add respo sources_
function _repos() {
cat >/etc/apt/sources.list<<EOF
###### Ubuntu Main Repos
deb http://nl.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse 
deb-src http://nl.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://nl.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse 
deb http://nl.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse 
deb-src http://nl.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse 
deb-src http://nl.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse 

###### Ubuntu Partner Repo
deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner
deb-src http://archive.canonical.com/ubuntu $(lsb_release -sc) partner
deb http://www.deb-multimedia.org testing main
EOF

cat >/etc/apt/sources.list.d/nginx-mainline-$(lsb_release -sc).list<<EOF
deb http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx
EOF
  echo "${OK}"
}

# package and repo addition (e) _update and upgrade_
function _updates() {
  export DEBIAN_FRONTEND=noninteractive &&
  apt-get -y update >>"${OUTTO}" 2>&1;
  apt-get -y upgrade >>"${OUTTO}" 2>&1;
  echo "${OK}"
}

# setting locale function (4)
function _locale() {
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/default/locale
echo "LANGUAGE=en_US.UTF-8">>/etc/default/locale
echo "LC_ALL=en_US.UTF-8" >>/etc/default/locale
  if [[ -e /usr/sbin/locale-gen ]]; then locale-gen >>"${OUTTO}" 2>&1
  else
    apt-get update >>"${OUTTO}" 2>&1
    apt-get install locales locale-gen --yes --force-yes >>"${OUTTO}" 2>&1
    locale-gen >>"${OUTTO}" 2>&1
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export LANGUAGE="en_US.UTF-8"
  fi
}

# package and repo addition (b) _install softwares and packages_
function _depends() {
  apt-get -y install nano dos2unix htop iotop bc unrar-free unzip git lshell mediainfo ifstat dstat screen curl openssl apache2-utils python-software-properties build-essential automake libtool libssl-dev libsigc++-2.0-dev zlib1g-dev libcurl4-openssl-dev libncurses5-dev libcppunit-dev libtirpc1 quota >>"${OUTTO}" 2>&1;
  cd
  rm -rf /etc/skel
  if [[ -e skel.tar ]]; then rm -rf skel.tar;fi 
  tar xf $REPOURL/sources/skel.tar -C /etc
  tar xzf $REPOURL/sources/rarlinux-x64-5.2.1.tar.gz -C ./
  mkdir -p /etc/skel/.config/deluge >/dev/null 2>&1
  cp ./rar/*rar /usr/bin
  cp ./rar/*rar /usr/sbin
  rm -rf rarlinux*.tar.gz
  rm -rf ./rar
  wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
  gunzip GeoLiteCity.dat.gz>>"${OUTTO}" 2>&1
  mkdir -p /usr/share/GeoIP>>"${OUTTO}" 2>&1
  rm -rf GeoLiteCity.dat.gz
  mv GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat>>"${OUTTO}" 2>&1
  (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan Digest::SHA1 >>"${OUTTO}" 2>&1
  (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan Digest::SHA >>"${OUTTO}" 2>&1
  sed -i 's/errors=remount-ro/usrquota,errors=remount-ro/g' /etc/fstab
  mount -o remount / >>"${OUTTO}" 2>&1 || mount -o remount /home >>"${OUTTO}" 2>&1
  quotacheck -auMF vfsv1 >>"${OUTTO}" 2>&1
  quotaon -uv / >>"${OUTTO}" 2>&1
  service quota start >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# install ffmpeg question (8)
function _askffmpeg() {
  echo -ne "${yellow}Install ffmpeg? (Used for screenshots)${normal} (Default: ${green}Y${normal}): "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss] | "" ) ffmpeg=yes ;;
    [nN] | [nN][Oo] ) ffmpeg=no ;;
    *) ffmpeg=yes ;;
  esac
}

# build function for ffmpeg (8.1)
function _ffmpeg() {
  if [[ ${ffmpeg} == "yes" ]]; then
    echo -n "Building ffmpeg from source for screenshots ... "
    MAXCPUS=$(echo "$(nproc) / 2"|bc)
    cd /root/tmp
    if [[ -d /root/tmp/ffmpeg ]]; then rm -rf ffmpeg;fi
    git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg >>"${OUTTO}" 2>&1
    cd ffmpeg
    export FC_CONFIG_DIR=/etc/fonts
    export FC_CONFIG_FILE=/etc/fonts/fonts.conf
    ./configure --enable-libfreetype --enable-filter=drawtext --enable-fontconfig >>"${OUTTO}" 2>&1
    make -j${MAXCPUS} >>"${OUTTO}" 2>&1
    make install >>"${OUTTO}" 2>&1
    cp /usr/local/bin/ffmpeg /usr/bin >>"${OUTTO}" 2>&1
    cp /usr/local/bin/ffprobe /usr/bin >>"${OUTTO}" 2>&1
    rm -rf /root/tmp/ffmpeg >>"${OUTTO}" 2>&1
    echo "${OK}"
    echo
  fi
}

# ask what rtorrent version (9.1)
function _askrtorrent() {
echo -e "1) rtorrent ${green}0.9.4${normal}"
echo -e "2) rtorrent ${green}0.9.3${normal}"
echo -ne "${yellow}What version of rtorrent do you want?${normal} (Default ${green}1${normal}): "; read version
case $version in
  1 | "") RTVERSION=0.9.4;LTORRENT=0.13.4  ;;
  2) RTVERSION=0.9.3;LTORRENT=0.13.3 ;;
  *) RTVERSION=0.9.4;LTORRENT=0.13.4 ;;
esac
echo "Using rtorrent-$RTVERSION/libtorrent-$LTORRENT" 
}

# xmlrpc-c function (9)
function _xmlrpc() {
  cd /root/tmp
  echo -ne "Installing xmlrpc-c-${green}1.33.12${normal} ... "
  if [[ -d /root/tmp/xmlrpc-c ]]; then rm -rf xmlrpc-c;fi
  cp -R "$REPOURL/xmlrpc-c" .
  cd xmlrpc-c
  ./configure --prefix=/usr --disable-cplusplus >>"${OUTTO}" 2>&1
  make >>"${OUTTO}" 2>&1
  make install >>"${OUTTO}" 2>&1 
  echo "${OK}"
}

# libtorent function (10)
function _libtorrent() {
  cd /root/tmp
  MAXCPUS=$(echo "$(nproc) / 2"|bc)
  echo -ne "Installing libtorrent-${green}$LTORRENT${normal} ... "
  rm -rf xmlrpc-c  >>"${OUTTO}" 2>&1
  if [[ -e /root/tmp/libtorrent-${LTORRENT}.tar.gz ]]; then rm -rf libtorrent-${LTORRENT}.tar.gz;fi
  cp $REPOURL/sources/libtorrent-0.13.4.tar.gz .
  tar -xzvf libtorrent-${LTORRENT}.tar.gz >>"${OUTTO}" 2>&1
  cd libtorrent-${LTORRENT}
  ./autogen.sh >>"${OUTTO}" 2>&1
  ./configure --prefix=/usr >>"${OUTTO}" 2>&1
  make -j${MAXCPUS} >>"${OUTTO}" 2>&1
  make install >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# rtorrent function (11)
function _rtorrent() {
  cd /root/tmp
  MAXCPUS=$(echo "$(nproc) / 2"|bc)
  echo -ne "Installing rtorrent-${green}$RTVERSION${normal} ... "
  rm -rf libtorrent-${LTORRENT}* >>"${OUTTO}" 2>&1
  if [[ -e /root/tmp/libtorrent-${RTVERSION}.tar.gz ]]; then rm -rf libtorrent-${RTVERSION}.tar.gz;fi
  cp $REPOURL/sources/rtorrent-0.9.4.tar.gz .
  tar -xzvf rtorrent-${RTVERSION}.tar.gz >>"${OUTTO}" 2>&1
  cd rtorrent-${RTVERSION}
  ./autogen.sh >>"${OUTTO}" 2>&1
  ./configure --prefix=/usr --with-xmlrpc-c >>"${OUTTO}" 2>&1
  make -j${MAXCPUS} >>"${OUTTO}" 2>&1
  make install >>"${OUTTO}" 2>&1 
  cd /root/tmp
  ldconfig >>"${OUTTO}" 2>&1 
  rm -rf /root/tmp/rtorrent-0.9.3* >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# function to install rutorrent (14)
function _rutorrent() {
  mkdir -p /srv/
  cd /srv
  if [[ -d /srv/rutorrent ]]; then rm -rf rutorrent;fi
  cp -R ${REPOURL}/rutorrent .
  sed -i '31i\<script type=\"text/javascript\" src=\"./js/jquery.browser.js\"></script> ' /srv/rutorrent/index.html
  echo "${OK}"
}

# ask for bash or lshell function (15)
function _asksudoer() {
  echo -ne "Add user to /etc/sudoers (Default: ${green}Y${normal}): "; read answer
    case $answer in
      [yY] | [yY][Ee][Ss] | "" ) sudoers="yes" ;;
      [nN] | [nN][Oo] ) sudoers="no" ;;
      *) sudoers="yes" ;;
    esac
}

# adduser function (16)
function _adduser() {
  theshell="/bin/bash"
  echo -n "Username: "; read user
  username=$(echo "$user"|sed 's/.*/\L&/')
  useradd "${username}" -m -G www-data -s ${theshell}
  echo -n "Password: (hit enter to generate a password) "; read password
  if [[ ! -z "${password}" ]]; then
    echo "setting password to ${password}"
    passwd=${password}
    echo "${username}:${passwd}" | chpasswd >>"${OUTTO}" 2>&1
    (echo -n "${username}:${REALM}:" && echo -n "${username}:${REALM}:${passwd}" | md5sum | awk '{print $1}' ) >> "${HTPASSWD}"
  else
    echo "setting password to ${genpass}"
    passwd=${genpass}
    echo "${username}:${passwd}" | chpasswd >>"${OUTTO}" 2>&1
    (echo -n "${username}:${REALM}:" && echo -n "${username}:${REALM}:${passwd}" | md5sum | awk '{print $1}' ) >> "${HTPASSWD}"
  fi
  if [[ $sudoers == "yes" ]]; then
    awk -v username=${username} '/^root/ && !x {print username    " ALL=(ALL:ALL) NOPASSWD: ALL"; x=1} 1' /etc/sudoers > /tmp/sudoers;mv /tmp/sudoers /etc
  fi
}

# function to enable sudo for www-data function (17)
function _nginxsudo() {
awk '/^root/ && !x {print "www-data     ALL=(ALL:ALL) NOPASSWD: /usr/bin/quota, /usr/sbin/repquota, /usr/bin/reload, /bin/sed, /usr/bin/pkill, /usr/bin/killall"; x=1} 1' /etc/sudoers > /tmp/sudoers;mv /tmp/sudoers /etc
awk '/^%sudo/ && !x {print "%www-data     ALL=(ALL:ALL) NOPASSWD: /usr/bin/quota, /usr/sbin/repquota, /usr/bin/reload, /bin/sed, /usr/bin/pkill, /usr/bin/killall"; x=1} 1' /etc/sudoers > /tmp/sudoers;mv /tmp/sudoers /etc
}

# install nginx function (6)
function _nginx() {
  apt-get -y install nginx >>"${OUTTO}" 2>&1;
  update-rc.d nginx defaults >>"${OUTTO}" 2>&1;
  service nginx stop >>"${OUTTO}" 2>&1;
  mv /etc/nginx /etc/nginx-previous >>"${OUTTO}" 2>&1;
  wget https://github.com/JMSDOnline/hstacklet/raw/master/hstacklet-server-configs.tar.gz >/dev/null 2>&1;
  tar -zxvf hstacklet-server-configs.tar.gz >/dev/null 2>&1;
  mv hstacklet-server-configs /etc/nginx >>"${OUTTO}" 2>&1;
  rm -rf hstacklet-server-configs*
  cp /etc/nginx-previous/uwsgi_params /etc/nginx-previous/fastcgi_params /etc/nginx >>"${OUTTO}" 2>&1;
  # rename default.conf template
  cp /etc/nginx/conf.d/default.conf.save /etc/nginx/conf.d/"${username}".conf
  # build applications web root directory if sitename is provided
  mkdir -p /home/"${username}"/logs >/dev/null 2>&1;
  mkdir -p /srv/"${username}"/ssl/certs >/dev/null 2>&1;
  mkdir -p /srv/"${username}"/ssl/keys >/dev/null 2>&1;
  mkdir -p /srv/"${username}"/www >/dev/null 2>&1;
  sed -i "s/sitename/$username/" /etc/nginx/conf.d/"${username}".conf
  sed -i "s/sitename_access.log/$username_access.log/" /etc/nginx/conf.d/"${username}".conf
  sed -i "s/sitename_error.log/$username_error.log/" /etc/nginx/conf.d/"${username}".conf
  echo "${OK}"
}

# install php function (9)
function _php() {
  apt-get -y install php5-common php5-mysqlnd php5-curl php5-gd php5-cli php5-fpm php-pear php5-dev php5-imap php5-mcrypt >>"${OUTTO}" 2>&1;
  sed -i.bak -e "s/post_max_size = 8M/post_max_size = 32M/" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" \
    -e "s/expose_php = On/expose_php = Off/" \
    -e "s/128M/512M/" \
    -e "s/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" \
    -e "s/;opcache.enable=0/opcache.enable=1/" \
    -e "s/;opcache.memory_consumption=64/opcache.memory_consumption=128/" \
    -e "s/;opcache.max_accelerated_files=2000/opcache.max_accelerated_files=4000/" \
    -e "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=240/" /etc/php5/fpm/php.ini
  # ensure opcache module is activated
  php5enmod opcache
  # ensure mcrypt module is activated
  php5enmod mcrypt
  # write checkinfo for php verification
  echo "${OK}"
}

## Puerly experiMENTAL - this comes after stability is reached with scgi
# install hhvm function (8)
# function _hhvm() {
#   apt-get -y install hhvm >>"${OUTTO}" 2>&1;
#   /usr/share/hhvm/install_fastcgi.sh >>"${OUTTO}" 2>&1;
#   update-rc.d hhvm defaults >>"${OUTTO}" 2>&1;
#   /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60 >>"${OUTTO}" 2>&1;
#   # get off the port and use socket - HStacklet nginx configurations already know this
#   sed -i "s/hhvm.server.port = 9000/hhvm.server.file_socket = \/var\/run\/hhvm\/hhvm.sock/" /etc/hhvm/server.ini
#   # make an additional request for memory limit
#   echo "memory_limit = 512M" >> /etc/hhvm/php.ini
#   echo "${OK}"
# }

# function to configure apache (18)
function _nginxconf() {
  mkdir -p /srv/"${username}"/logs ssl
cat >/etc/nginx/aliases-seedbox.conf<<EOF
    location /rutorrent {
        try_files $uri = 404;
        root /srv/rutorrent;
            auth_basic "rutorrent";
            auth_basic_user_file /etc/htpasswd;
    }

    location /$username.downloads {
        try_files $uri = 404;
        root /home/$username/torrents/;
            auth_basic "rutorrent";
            auth_basic_user_file /etc/htpasswd;
    }

    location ^~ /scgi {
        include scgi_params;
        scgi_pass  unix:/srv/rtorrent/scgi.socket;
    }
EOF

cat >/etc/nginx/conf.d/"${username}".conf<<EOF
server {
    listen *:80;
    # listen [::]:443 ssl http2;
    # listen *:443 ssl http2;
    server_name $HOSTNAME1;

    access_log /srv/$username/logs/access.log;
    error_log /srv/$username/logs/error.log;

    # include quick-box/directive-only/ssl.conf;
    # ssl_certificate /srv/$username/ssl/$username.crt;
    # ssl_certificate_key /srv/$username/ssl/$username.key;
    root /srv/rutorrent/home;
    index index.html index.htm index.php;

    location ~ [^/]\.php(/|$) {
      # Zero-day exploit defense.
      # http://forum.nginx.org/read.php?2,88845,page=3
      # Won't work properly (404 error) if the file is not stored on this server, 
      # which is entirely possible with php-fpm/php-fcgi.
      # Comment the 'try_files' line out if you set up php-fpm/php-fcgi on another machine.  
      # And then cross your fingers that you won't get hacked.
        try_files $uri = 404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_index index.php;
        include fcgi.conf;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location / {
        try_files $uri = 404;
        index index.html index.htm index.php;
        root /srv/rutorrent/home;
            auth_basic "rutorrent";
            auth_basic_user_file /etc/htpasswd;
    }

    include aliases-seedbox.conf;

}

EOF

}

# function to configure first user config (19)
function _rconf() {
cat >"/home/${username}/.rtorrent.rc"<<EOF
# -- START HERE --
min_peers = 1
max_peers = 100
min_peers_seed = -1
max_peers_seed = -1
max_uploads = 100
download_rate = 0
upload_rate = 0
directory = /home/${username}/torrents/
session = /home/${username}/.sessions/
schedule = watch_directory,5,5,load_start=/home/${username}/rwatch/*.torrent
schedule = filter_active,5,5,"view_filter = active,d.get_up_rate="
view_add = alert
view_sort_new = alert,less=d.get_message=
schedule = filter_alert,30,30,"view_filter = alert,d.get_message=; view_sort = alert"
port_range = $PORT-$PORTEND
use_udp_trackers = yes
encryption = allow_incoming,try_outgoing,enable_retry
peer_exchange = no
scgi_port = localhost:$PORT
execute_nothrow=chmod,777,/home/${username}/.config/rpc.socket
execute_nothrow=chmod,777,/home/${username}/.sessions/
check_hash = no
encoding_list = UTF-8
scgi_local = /srv/rtorrent/scgi.socket
execute = chmod,ug=rw\,o=,/srv/rtorrent/scgi.socket
execute = chgrp,rtorrent-nginx,/srv/rtorrent/scgi.socket
# -- END HERE --
EOF
  echo "${OK}"
}

# function to install rutorrent plugins (20)
function _plugins() {
  mkdir -p "${rutorrent}plugins"; cd "${rutorrent}plugins"
  LIST="autodl-irssi autotools check_port chunks cookies create data datadir diskspace edit erasedata extratio extsearch feeds filedrop filemanager fileshare geoip _getdir history httprpc loginmgr logoff lookat mediainfo _noty ratio ratiocolor retrackers rss rssurlrewrite rutorrentMobile rutracker_check scheduler seedingtime screenshots show_peers_like_wtorrent source _task theme throttle tracklabels trafic unpack"
  for i in $LIST; do
  echo -ne "Installing Plugin: ${green}${i}${normal} ... "
  cp -R "${REPOURL}/plugins/$i" .
  echo "${OK}"
  done

cat >/srv/rutorrent/home/fileshare/.htaccess<<EOF
Satsify Any
EOF

  cp /srv/rutorrent/home/fileshare/.htaccess /srv/rutorrent/plugins/fileshare/
  cd /srv/rutorrent/home/fileshare/
  rm -rf share.php
  ln -s ../../plugins/fileshare/share.php

cat >/srv/rutorrent/plugins/fileshare/conf.php<<'EOF'
<?php
$limits['duration'] = 24;   // maximum duration hours
$limits['links'] = 0;   //maximum sharing links per user
$downloadpath = $_SERVER['HTTP_HOST'] . '/fileshare/share.php';
?>
EOF

  sed -i 's/homeDirectory/topDirectory/g' /srv/rutorrent/plugins/filemanager/flm.class.php
  sed -i 's/homeDirectory/topDirectory/g' /srv/rutorrent/plugins/filemanager/settings.js.php
  sed -i 's/showhidden: true,/showhidden: false,/g' "${rutorrent}plugins/filemanager/init.js"
  chown -R www-data.www-data "${rutorrent}"
  cd /srv/rutorrent/plugins/theme/themes/
  
  cp $REPOURL/plugins/rutorrent-clubKynetic-dark.zip .
  unzip rutorrent-clubKynetic-dark.zip >>"${OUTTO}" 2>&1
  rm -rf rutorrent-clubKynetic-dark.zip
  cd /srv/rutorrent/plugins
  perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"ClubKynetic-Dark\"\;/g" /srv/rutorrent/plugins/theme/conf.php
  rm -rf /srv/rutorrent/plugins/tracklabels/labels/nlb.png
}

# function autodl to install autodl irssi scripts (21)
function _autodl() {
  mkdir -p "/home/${username}/.irssi/scripts/autorun/" >>"${OUTTO}" 2>&1
  cd "/home/${username}/.irssi/scripts/"
  wget -qO autodl-irssi.zip http://update.autodl-community.com/autodl-irssi-community.zip
  unzip -o autodl-irssi.zip >>"${OUTTO}" 2>&1
  rm autodl-irssi.zip
  cp autodl-irssi.pl autorun/
  mkdir -p "/home/${username}/.autodl" >>"${OUTTO}" 2>&1
  touch "/home/${username}/.autodl/autodl.cfg"

cat >"/home/${username}/.autodl/autodl2.cfg"<<ADC
[options]
gui-server-port = ${IRSSI_PORT}
gui-server-password = ${IRSSI_PASS}
ADC

  chown -R "${username}.${username}" "/home/${username}/.irssi/"
  chown -R "${username}.${username}" "/home/${username}"
  echo "${OK}"
}

# function to make dirs for first user (22)
function _makedirs() {
  mkdir /home/"${username}"/{torrents,.sessions,watch} >>"${OUTTO}" 2>&1
  chown "${username}".www-data /home/"${username}"/{torrents,.sessions,watch,.rtorrent.rc,.config} >>"${OUTTO}" 2>&1
  usermod -a -G www-data "${username}" >>"${OUTTO}" 2>&1
  usermod -a -G "${username}" www-data >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# function to make crontab .statup file (23)
function _cronfile() { 
  cat >"/home/${username}/.startup"<<'EOF'
#!/bin/bash
export USER=`id -un`
IRSSI_CLIENT=yes
RTORRENT_CLIENT=yes
WIPEDEAD=yes
ADDRESS=$(/sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'|grep -v "^127"|head -n1)

if [ "$WIPEDEAD" == "yes" ]; then screen -wipe >/dev/null 2>&1; fi

if [ "$IRSSI_CLIENT" == "yes" ]; then
  (screen -ls|grep irssi > /dev/null || (screen -S irssi -d -t irssi -m irssi -h ${ADDRESS} && false))
fi

if [ "$RTORRENT_CLIENT" == "yes" ]; then
  (screen -ls|grep rtorrent >/dev/null || (screen -fa -dmS rtorrent rtorrent && false))
fi

EOF
  echo "${OK}"
}

# function to set permissions on first user (24)
function _perms() {
  chown -R ${username}.${username} /home/${username}/ >>"${OUTTO}" 2>&1
  chown ${username}.${username} /home/${username}/.startup
  sudo -u ${username} chmod 755 /home/${username}/ >>"${OUTTO}" 2>&1
  chmod +x /etc/cron.daily/denypublic >/dev/null 2>&1
  chmod 777 /home/${username}/.sessions >/dev/null 2>&1
  chown ${username}.${username} /home/${username}/.startup >/dev/null 2>&1
  chmod +x /home/${username}/.startup >/dev/null 2>&1
  echo "${OK}"
}

# function to configure first user config.php (25)
function _ruconf() {
  mkdir -p ${rutorrent}conf/users/${username}/

cat >"${rutorrent}conf/users/${username}/config.php"<<EOF
<?php
  @define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0', true);
  @define('HTTP_TIME_OUT', 30, true);
  @define('HTTP_USE_GZIP', true, true);
  \$httpIP = null;
  @define('RPC_TIME_OUT', 5, true);
  @define('LOG_RPC_CALLS', false, true);
  @define('LOG_RPC_FAULTS', true, true);
  @define('PHP_USE_GZIP', false, true);
  @define('PHP_GZIP_LEVEL', 2, true);
  \$schedule_rand = 10;
  \$do_diagnostic = true;
  \$log_file = '/tmp/errors.log';
  \$saveUploadedTorrents = true;
  \$overwriteUploadedTorrents = false;
  \$topDirectory = '/home/${username}/';
  \$forbidUserSettings = false;
  \$scgi_port = $PORT;
  \$scgi_host = "localhost";
  \$XMLRPCMountPoint = "/RPC2";
  \$pathToExternals = array("php" => '',"curl" => '',"gzip" => '',"id" => '',"stat" => '',);
  \$localhosts = array("127.0.0.1", "localhost",);
  \$profilePath = '../share';
  \$profileMask = 0777;
  \$autodlPort = ${IRSSI_PORT};
  \$autodlPassword = "${IRSSI_PASS}";
  \$diskuser = "";
  \$quotaUser = "";
EOF

  chown -R www-data.www-data "${rutorrent}conf/users/" >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# function to set first user quota (26)
function _askquota() {
echo -ne "If your going to use a quota disk system, you must hit Y (If your unsure, hit N) (Default: \033[1mN\033[0m) "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss] )
    apt-get -yy -q install quota >/dev/null 2>&1
    sed -i "/diskuser/c\$diskuser = \"\/\";" /srv/rutorrent/conf/users/${username}/config.php
    sed -i "/quotaUser/c\$quotaUser = \"${username}\";" /srv/rutorrent/conf/users/${username}/config.php
    ;;
    [nN] | [nN][Oo] | "" )
    ;;
    *) ;;
  esac
}

# create reload script (27) 
function _reloadscript() {
  cat >/usr/bin/reload<<'EOF'
#!/bin/bash
export USER=$(id -un)
killall -u $USER irssi >/dev/null 2>&1
killall -u $USER rtorrent >/dev/null 2>&1
killall -u $USER main >/dev/null 2>&1
rm -rf ~/.sessions/rtorrent.lock
EOF
  echo "${OK}"
}

# seedbox boot for first user (28)
function _boot() {
        command1="*/1 * * * * /home/${username}/.startup"
        cat <(fgrep -iv "${command1}" <(sh -c 'sudo -u ${username} crontab -l' >/dev/null 2>&1)) <(echo "${command1}") | sudo -u ${username} crontab -
  echo "${OK}"
}

# function to install pure-ftpd (30)
function _installpureftpd() {
  apt-get purge -y -q --force-yes vsftpd pure-ftpd >>"${OUTTO}" 2>&1
  apt-get install -q -y --force-yes vsftpd >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# function to configure pure-ftpd (31)
function _pureftpdconfig() {
  cat >/root/.openssl.cnf <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name
[ req_distinguished_name ]
C = US
ST = Some State
L = LOCALLY
O = SELF
OU = SELF
CN = SELF
emailAddress = dont@think.so
EOF

  openssl req -config /root/.openssl.cnf -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem >/dev/null 2>&1

  cat >/etc/vsftpd.conf<<'VSD'
listen=YES
anonymous_enable=NO
guest_enable=NO
dirmessage_enable=YES
dirlist_enable=YES
download_enable=YES
secure_chroot_dir=/var/run/vsftpd/empty
chroot_local_user=YES
chroot_list_file=/etc/vsftpd.chroot_list
passwd_chroot_enable=YES
allow_writeable_chroot=YES
pam_service_name=vsftpd
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=NO
force_local_logins_ssl=NO
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
require_ssl_reuse=NO
ssl_request_cert=YES
ssl_ciphers=HIGH
rsa_cert_file=/etc/ssl/private/vsftpd.pem
local_enable=YES
write_enable=YES
local_umask=022
max_per_ip=0
pasv_enable=YES
port_enable=YES
pasv_promiscuous=NO
port_promiscuous=NO
pasv_min_port=0
pasv_max_port=0
listen_port=5757
pasv_promiscuous=YES
port_promiscuous=YES
seccomp_sandbox=no
VSD

  echo "${OK}"
}

# function to create ssl cert for pure-ftpd (34)
function _pureftpcert() {
  /bin/true
}

# function to show finished data (35)
function _finished() {
  echo -e "\033[0mCOMPLETED in ${FIN}/min\033[0m"
  echo "Valid Commands: "
  echo;echo;echo
  echo -e "\033[1mreload\033[0m (restarts seedbox)"
  echo -e "\033[1mcreateSeedboxUser\033[0m (add seedboxuser)"
  echo -e "\033[1mchangeUserpass\033[0m (change users SSH/FTP/ruTorrent password"
  echo -e "\033[1mrestartSeedbox\033[0m (same as reload)"
  echo -e "\033[1mdeleteSeedboxUser\033[0m (really?)"
  echo -e "\033[1msetdisk\033[0m (change the quota mount of a user) ... "
  echo;echo;echo
  echo "Seedbox can be found at http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747)"
  echo "If you need to restart rtorrent/irssi, you can type 'reload'"
  echo "http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747/Deluge:19596)" > ${username}.info
  echo "Reloading: sshd, nginx, vsftpd, php5-fpm, quota"
cat >/root/information.info<<EOF
  Seedbox can be found at http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747)
  If you need to restart rtorrent/irssi, you can type 'reload'
  http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747/Deluge:19596)
EOF
  rm -rf "$0" >>"${OUTTO}" 2>&1
  for i in sshd nginx php5-fpm pure-ftpd vsftpd quota; do
    service $i restart >>"${OUTTO}" 2>&1
    systemctl enable $i >>"${OUTTO}" 2>&1
  done
}

clear

PORT=$(shuf -i 2000-61000 -n 1)
PORTEND=$((${PORT} + 1500))
S=$(date +%s)
OK=$(echo -e "[ \e[0;32mDONE\e[00m ]")
genpass=$(_string)
HTPASSWD="/etc/htpasswd"
rutorrent="/srv/rutorrent/"
REALM="rutorrent"
IRSSI_PASS=$(_string)
IRSSI_PORT=$(shuf -i 2000-61000 -n 1)
ip=$(/sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'|grep -v "^127"|head -n1)
export DEBIAN_FRONTEND=noninteractive
cd

S=$(date +%s)
OK=$(echo -e "[ ${bold}${green}DONE${normal} ]")

# QUICK BOX STRUCTURE
_intro
_checkroot
_logcheck
echo -n "Installing signed keys for ffmpeg & nginx ... ";_keys
echo -n "Adding trusted repositories ... ";_repos
echo -n "Applying Updates ... ";_updates
_locale
echo -n "Installing building tools and all dependancies, please wait ... ";_depends
_askffmpeg;if [[ ${ffmpeg} == "yes" ]]; then _ffmpeg; fi
_askrtorrent;_xmlrpc;_libtorrent;_rtorrent
# echo -n "Setting sysctl.conf ... "; _sysctl
echo -n "Installing rutorrent into /srv ... ";_rutorrent;_asksudoer;_adduser;_nginxsudo
echo -n "Installing and Configuring Nginx ... ";_nginx
echo -n "Installing and Configuring php5-fpm ... ";_php
echo -n "Setting up seedbox.conf for nginx ... ";_nginxconf
echo -n "Installing .rtorrent.rc for ${username} ... ";_rconf
echo "Installing rutorrent plugins ... ";_plugins
echo -n "Installing autodl-irssi ... ";_autodl
echo -n "Making ${username} directory structure ... ";_makedirs
echo -n "Writing ${username} system crontab script ... ";_cronfile
echo -n "Writing ${username} rutorrent config.php file ... ";_ruconf;_askquota
echo -n "Writing seedbox reload script ... ";_reloadscript
echo -n "Installing VSFTPd ... ";_installpureftpd
echo -n "Setting up VSFTPd ... ";_pureftpdconfig
echo -n "Setting irssi/rtorrent to start on boot ... ";_boot
echo -n "Setting permissions on ${username} ... ";_perms

E=$(date +%s)
DIFF=$(echo "$E" - "$S"|bc)
FIN=$(echo "$DIFF" / 60|bc)
_finished