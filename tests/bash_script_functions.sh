testbashscriptParameters() {

function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }

# intro function (1)
function _intro() {
  echo
  echo
  echo "  [${repo_title}quick-box${normal}] ${title} Quick Box Seedbox Installation ${normal}  "
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
    echo "${dis}: ${alert} You do not appear to be running Ubuntu ${normal} "
    echo 'Exiting...'
    exit 1
  elif [[ ! "${rel}" =~ ("12.04"|"14.04"|"15.04"|"15.10") ]]; then
    echo "${bold}${rel}:${normal} You do not appear to be running a supported Ubuntu release."
    echo 'Exiting...'
    exit 1
  fi
}
# package and repo addition (4) _update and upgrade_
function _updates() {
  country=us
  if lsb_release >>"${OUTTO}" 2>&1; then ver=$(lsb_release -c|awk '{print $2}')
  else
    apt-get -yq install lsb-release >>"${OUTTO}" 2>&1
    if [[ -e /usr/bin/lsb_release ]]; then ver=$(lsb_release -c|awk '{print $2}')
    else echo "failed to install lsb-release from apt-get, please install manually and re-run script"; exit
    fi
  fi
  echo -n "Updating system ... "
  apt-get -y --force-yes install deb-multimedia-keyring > /dev/null 2>&1;

cat >/etc/apt/sources.list<<EOF
###### Ubuntu Main Repos
deb http://${country}.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse 
deb-src http://${country}.archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://${country}.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse 
deb http://${country}.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse 
deb-src http://${country}.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse 
deb-src http://${country}.archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse 

###### Ubuntu Partner Repo
deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner
deb-src http://archive.canonical.com/ubuntu $(lsb_release -sc) partner
deb http://www.deb-multimedia.org testing main
EOF

  apt-get -y --force-yes update
  apt-get -y --force-yes purge samba samba-common >>"${OUTTO}" 2>&1
  apt-get -y --force-yes upgrade
  if [[ -e /etc/ssh/sshd_config ]]; then
    echo "Port 4747" /etc/ssh/sshd_config
    sed -i 's/Port 22/Port 4747/g' /etc/ssh/sshd_config
    service sshd restart >>"${OUTTO}" 2>&1
  fi
  clear
}

# setting locale function (5)
function _locale() {
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/default/locale
echo "LANGUAGE=en_US.UTF-8">>/etc/default/locale
echo "LC_ALL=en_US.UTF-8" >>/etc/default/locale
  if [[ -e /usr/sbin/locale-gen ]]; then locale-gen >>"${OUTTO}" 2>&1
  else
    apt-get update >>"${OUTTO}" 2>&1
    apt-get install locales locale-gen -y --force-yes >>"${OUTTO}" 2>&1
    locale-gen >>"${OUTTO}" 2>&1
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export LANGUAGE="en_US.UTF-8"
  fi
}

# package and repo addition (7) _install softwares and packages_
function _depends() {
  apt-get install -qq -y --force-yes fail2ban bc sudo screen zip irssi unzip nano build-essential bwm-ng ifstat git subversion dstat automake libtool libcppunit-dev libssl-dev pkg-config libcurl4-openssl-dev libsigc++-2.0-dev lshell cron unrar curl libncurses5-dev yasm apache2 php5 php5-cli php-net-socket libdbd-mysql-perl libdbi-perl fontconfig libfontconfig1 libfontconfig1-dev rar mediainfo php5-curl htop libapache2-mod-php5 ttf-mscorefonts-installer libarchive-zip-perl libnet-ssleay-perl php5-geoip openjdk-7-jre openjdk-7-jdk libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libapache2-mod-scgi openvpn >>"${OUTTO}" 2>&1;
  cd
  rm -rf /etc/skel
  if [[ -e skel.tar ]]; then rm -rf skel.tar;fi 
  tar xf $REPOURL/sources/skel.tar -C /etc
  tar xzf $REPOURL/sources/rarlinux-x64-5.2.1.tar.gz -C ./
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
cat >/etc/lshell.conf<<'LS'
[global]
logpath         : /var/log/lshell/
loglevel        : 2

[default]
allowed         : ['cd','cp','-d','-dmS','git','irssi','ll','ls','-m','mkdir','mv','nano','pwd','-R','rm','rtorrent','rsync','-S','scp','screen','tar','unrar','unzip','nano','wget']
forbidden       : [';', '&', '|','`','>','<', '$(', '${','sudo','vi','vim','./']
warning_counter : 2
aliases         : {'ls':'ls --color=auto','ll':'ls -l'}
intro           : "== Seedbox Shell ==\nWelcome To Your Quick Box Seedbox Shell\nType '?' or 'help' to get the list of allowed commands"
home_path       : '/home/%u'
env_path        : ':/usr/local/bin:/usr/sbin'
allowed_cmd_path: ['/home/']
scp             : 1
sftp            : 1
overssh         : ['ls', 'rsync','scp']
LS
echo "${OK}"
}

_intro
_updates
_depends

}
. shunit2-2.1.6/src/shunit2