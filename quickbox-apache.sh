#!/bin/bash
#
# [Quick Box Installation Script]
#
# GitHub:   https://github.com/JMSDOnline/quick-box
# Author:   Jason Matthews
# URL:      https://jmsolodesigns.com/code-projects/quick-box/seedbox-installer
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

function _bashrc() {
cat >/root/.bashrc<<'EOF'
case $- in
    *i*) ;;
      *) return;;
esac

BASHRCVERSION="23.2"
EDITOR=nano; export EDITOR=nano
USER=`whoami`
TMPDIR=$HOME/.tmp/
HOSTNAME=`hostname -s`
IDUSER=`id -u`
PROMPT_COMMAND='echo -ne "\033]0;${USER}(${IDUSER})@${HOSTNAME}: ${PWD}\007"'
export LS_COLORS='rs=0:di=01;33:ln=00;36:mh=00:pi=40;33:so=00;35:do=00;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.log=02;34:*.torrent=02;37:*.conf=02;34:*.sh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.tlz=00;31:*.txz=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.dz=00;31:*.gz=00;31:*.lz=00;31:*.xz=00;31:*.bz2=00;31:*.tbz=00;31:*.tbz2=00;31:*.bz=00;31:*.tz=00;31:*.tcl=00;31:*.deb=00;31:*.rpm=00;31:*.jar=00;31:*.rar=00;31:*.ace=00;31:*.zoo=00;31:*.cpio=00;31:*.7z=00;31:*.rz=00;31:*.jpg=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.pbm=00;35:*.pgm=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.tiff=00;35:*.png=00;35:*.svg=00;35:*.svgz=00;35:*.mng=00;35:*.pcx=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:*.m2v=00;35:*.mkv=00;35:*.ogm=00;35:*.mp4=00;35:*.m4v=00;35:*.mp4v=00;35:*.vob=00;35:*.qt=00;35:*.nuv=00;35:*.wmv=00;35:*.asf=00;35:*.rm=00;35:*.rmvb=00;35:*.flc=00;35:*.avi=00;35:*.fli=00;35:*.flv=00;35:*.gl=00;35:*.dl=00;35:*.xcf=00;35:*.xwd=00;35:*.yuv=00;35:*.cgm=00;35:*.emf=00;35:*.axv=00;35:*.anx=00;35:*.ogv=00;35:*.ogx=00;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
export TERM=xterm;TERM=xterm
export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/quick-box/.bin/
TPUT=`which tput`
BC=`which bc`
if [ ! -e $TPUT ]; then echo "tput is missing, please install it (yum install tput/apt-get install tput)";fi
if [ ! -e $BC ]; then echo "bc is missing, please install it (yum install bc/apt-get install bc)";fi
DFSCRIPT="${HOME}/.du.sh"
if [ ! -e $DFSCRIPT ]; then
cat >"$DFSCRIPT"<<'DS'
#!/bin/bash
ALERT=${BWhite}${On_Red};RED='\e[0;31m';YELLOW='\e[1;33m'
GREEN='\e[0;32m';RESET="\e[00m";BWhite='\e[1;37m';On_Red='\e[41m'
NCPU=$(grep -c 'processor' /proc/cpuinfo)
SLOAD=$(( 100*${NCPU} ));MLOAD=$(( 200*${NCPU} ));XLOAD=$(( 400*${NCPU} ))
function load() { SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.'); echo -n $((10#$SYSLOAD)); }
SYSLOAD=$(load)
if [ ${SYSLOAD} -gt ${XLOAD} ]; then echo -en ${ALERT}
elif [ ${SYSLOAD} -gt ${MLOAD} ]; then echo -en ${RED}
elif [ ${SYSLOAD} -gt ${SLOAD} ]; then echo -en ${YELLOW}
else echo -en ${GREEN} ;fi
let TotalBytes=0 
for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }') 
do 
   let TotalBytes=$TotalBytes+$Bytes 
done
if [ $TotalBytes -lt 1024 ]; then
     TotalSize=$(echo -e "scale=1 \n$TotalBytes \nquit" | bc)
     suffix="b"
else if [ $TotalBytes -lt 1048576 ]; then
     TotalSize=$(echo -e "scale=1 \n$TotalBytes/1024 \nquit" | bc)
     suffix="kb"
  else if [ $TotalBytes -lt 1073741824 ]; then
     TotalSize=$(echo -e "scale=1 \n$TotalBytes/1048576 \nquit" | bc)
     suffix="Mb"
else
     TotalSize=$(echo -e "scale=1 \n$TotalBytes/1073741824 \nquit" | bc)
     suffix="Gb"
fi
fi
fi
echo $TotalSize$suffix
DS
chmod u+x $DFSCRIPT
fi

alias ls='ls --color=auto'
alias dir='ls --color=auto'
alias vdir='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function normal { 
if [ `id -u` == 0 ] ; then
  DG="$(tput bold ; tput setaf 7)";LG="$(tput bold;tput setaf 7)";NC="$(tput sgr0)"
  export PS1='[\[$LG\]\u\[$NC\]@\[$LG\]\h\[$NC\]]:(\[$LG\]\[$BN\]$($DFSCRIPT)\[$NC\])\w\$ '
else
  DG="$(tput bold;tput setaf 0)"
  LG="$(tput setaf 7)"
  NC="$(tput sgr0)"
  export PS1='[\[$LG\]\u\[$NC\]@\[$LG\]\h\[$NC\]]:(\[$LG\]\[$BN\]$($DFSCRIPT)\[$NC\])\w\$ '
fi
}

case $TERM in
  rxvt*|screen*|cygwin)
    export PS1='\u\@\h\w'
  ;;
  xterm*|linux*|*vt100*|cons25)
    normal
  ;;
  *)
    normal
        ;;
esac

function rarit() { rar a -m5 -v1m $1 $1; }
function paste() { $* | curl -F 'sprunge=<-' http://sprunge.us ; }
function disktest() { dd if=/dev/zero of=test bs=64k count=16k conv=fdatasync;rm -rf test ; }
function newpass() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
function fixhome() { chmod -R u=rwX,g=rX,o= "$HOME" ;}

transfer() { 
  if [ $# -eq 0 ]; then 
    echo "No arguments specified. Usage: transfer /tmp/test.md OR: cat /tmp/test.md | transfer test.md"
    return 1
  fi 
tmpfile=$(mktemp -t transferXXX )
if tty -s
  then 
    basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
  else 
    curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile 
fi
cat $tmpfile
rm -f $tmpfile
}

function swap() { 
local TMPFILE=tmp.$$
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1
    mv "$1" $TMPFILE; mv "$2" "$1"; mv $TMPFILE "$2"
}

if [ -e /etc/bash_completion ] ; then source /etc/bash_completion; fi
if [ -e ~/.custom ]; then source ~/.custom; fi

function changeUserpass() {
REALM=rutorrent
HTPASSWD=/etc/htpasswd
echo -n "Username: "; read user
        username=$(echo "$user"|sed 's/.*/\L&/')
        if [[ ! $(grep "^${username}" ${HTPASSWD}) ]]; then 
    echo "Username ${username} wasnt found in ${HTPASSWD} .. please try again"
    exit
  fi
        echo -n "Password: (hit enter to generate a password) "; read password
        if [[ ! -z "${password}" ]]; then
                echo "setting password to ${password}"
                passwd=${password}
                echo "${username}:${passwd}" | chpasswd >/dev/null 2>&1
                sed -i '/^${username}/d' ${HTPASSWD}
                (echo -n "${username}:${REALM}:" && echo -n "${username}:${REALM}:${passwd}" | md5sum | awk '{print $1}' ) >> "${HTPASSWD}"
        else
                echo "setting password to ${genpass}"
                sed -i '/^${username}/d' ${HTPASSWD}
                passwd=${genpass}
                echo "${username}:${passwd}" | chpasswd >/dev/null 2>&1
                (echo -n "${username}:${REALM}:" && echo -n "${username}:${REALM}:${passwd}" | md5sum | awk '{print $1}' ) >> "${HTPASSWD}"
        fi
  echo "$username : $passwd" >>/root/${username}.txt
}


function setdisk() {
echo -n "Username: "
read username
echo "Quota size for user: (EX: 500GB): "
read SIZE
case $SIZE in
  *TB)
    QUOTASIZE=$(echo $SIZE|cut -d'T' -f1)
    DISKSIZE=$(($QUOTASIZE * 1024 * 1024 * 1024))
    setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
  ;;
  *GB)
    QUOTASIZE=$(echo $SIZE|cut -d'G' -f1)
    DISKSIZE=$(($QUOTASIZE * 1024 * 1024))
    setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
  ;;
  *MB)
    QUOTASIZE=$(echo $SIZE|cut -d'M' -f1)
                DISKSIZE=$(($QUOTASIZE * 1024))
                setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
  ;;
  *)
    echo "Disk Space MUST be in GB/TB, Example: 711GB OR 2.5TB, Exiting script, type bash $0 and try again";exit 0
  ;;
esac
}
function createSeedboxUser() {
OK=`echo -e "[\e[0;32mOK\e[00m]"`
realm="rutorrent"
htpasswd="/etc/htpasswd"
genpass=$(perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15)
ruconf="/srv/rutorrent/conf/users"
IRSSI_PASS=$(perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15)
IRSSI_PORT=$((RANDOM%64025+1024))
#PORT=$(($RANDOM + ($RANDOM % 2) * 32768))
PORT=$(shuf -i 2000-61000 -n 1)
PORTEND=$(($PORT + 1500))
#RPORT=$(($PORT + 1500))
RPORT=$(shuf -i 2000-61000 -n 1)
# --END HERE --
echo -n "Username: "; read username
  if grep -Fxq "$username" /etc/passwd; then
    echo "$username exists! cant proceed..."
    exit
  else
    useradd -m -k /etc/skel/ $username -s /usr/bin/lshell
    echo -n "Password: (hit enter to generate a password) ";read password
    chown $username.www-data /home/$username >/dev/null 2>&1
    cp $htpasswd /root/rutorrent-htpasswd.`date +'%d.%m.%y-%S'`
    if [[ "$password" == "" ]]; then
      echo "setting password to $genpass"
      echo "${username}:${genpass}" | chpasswd >/dev/null 2>&1
      (echo -n "$username:$realm:" && echo -n "$username:$realm:$genpass" | md5sum | awk '{print $1}' ) >> $htpasswd
      echo "${username} : $genpass" >/root/${username}.info
    else
      echo "using $password"
      echo "${username}:${password}" | chpasswd >/dev/null 2>&1
      (echo -n "$username:$realm:" && echo -n "$username:$realm:$password" | md5sum | awk '{print $1}' ) >> $htpasswd
      echo "${username} : $password " >/root/${username}.info
  fi
  echo "Quota size for user: (EX: 500GB): "
  read SIZE
  case $SIZE in
    *TB)
      QUOTASIZE=$(echo $SIZE|cut -d'T' -f1)
      DISKSIZE=$(($QUOTASIZE * 1024 * 1024 * 1024))
      setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
      echo "$SIZE" >>/root/${username}.info
    ;;
    *GB)
      QUOTASIZE=$(echo $SIZE|cut -d'G' -f1)
      DISKSIZE=$(($QUOTASIZE * 1024 * 1024))
      setquota -u ${username} ${DISKSIZE} ${DISKSIZE} 0 0 -a
      echo "$SIZE" >>/root/${username}.info
    ;;
    *)
      echo "Disk Space MUST be in GB/TB, Example: 711GB OR 2.5TB, Exiting script, type bash $0 and try again";exit 0
    ;;
  esac

echo -n "writing $username .rtorrent.rc using port-range (${PORT}-${PORTEND})..."
cat >/home/$username/.rtorrent.rc<<RC
# -- START HERE --
scgi_port = localhost:$RPORT
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
dht = yes
peer_exchange = no
check_hash = no
execute_nothrow=chmod,777,/home/${username}/.config/rpc.socket
execute_nothrow=chmod,777,/home/${username}/.sessions/
# -- END HERE --

RC
echo $OK
echo -n "setting permissions ... "
  chown $username.www-data /home/$username/{torrents,.sessions,watch,.rtorrent.rc} >/dev/null 2>&1
  usermod -a -G www-data $username >/dev/null 2>&1
  usermod -a -G $username www-data >/dev/null 2>&1
  chmod 777 /home/${username}/.sessions >/dev/null 2>&1
echo $OK
echo -n "writing $username rtorrent/irssi cron script ... "
cat >/home/${username}/.startup<<SU
#!/bin/bash
export USER=\$(id -un)
IRSSI_CLIENT=yes
RTORRENT_CLIENT=yes
ADDRESS=\$(/sbin/ifconfig | grep "inet addr" | awk -F: '{print \$2}' | awk '{print \$1}'|grep -v "^127"|head -n1)

# NO NEED TO EDIT PAST HERE!
if [ "\$IRSSI_CLIENT" == "yes" ]; then 
  (screen -ls|grep irssi > /dev/null || (screen -fa -dmS irssi irssi && false))
fi

if [ "\$RTORRENT_CLIENT" == "yes" ]; then 
  (screen -ls|grep rtorrent >/dev/null || (screen -fa -dmS rtorrent rtorrent && false))
fi
SU
  chown ${username}.${username} /home/${username}/.startup >/dev/null 2>&1
  chmod +x /home/${username}/.startup >/dev/null 2>&1
echo $OK
echo -n "enabling $username cron script ... "
  mkdir "/srv/rutorrent/conf/users/${username}" >>"${OUTTO}" 2>&1
  chown $username.$username /home/$username/.startup >/dev/null 2>&1
  sudo -u $username chmod +x /home/$username/.startup  >/dev/null 2>&1
  sudo -u $username chmod 750 /home/$username/ >/dev/null 2>&1
  chown -R $username.www-data /home/${username} >/dev/null 2>&1
echo $OK
echo -n "writing $username rutorrent config.php ... "
  mkdir $ruconf/$username >/dev/null 2>&1
cat >$ruconf/$username/config.php<<DH
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
  \$topDirectory = '/home/$username/';
  \$forbidUserSettings = false;
  \$scgi_port = $RPORT;
  \$scgi_host = "localhost";
  \$XMLRPCMountPoint = "/RPC2";
  \$pathToExternals = array("php" => '',"curl" => '',"gzip" => '',"id" => '',"stat" => '',);
  \$localhosts = array("127.0.0.1", "localhost",);
  \$profilePath = '../share';
  \$profileMask = 0777;
  \$diskuser = '/';
  \$quotaUser = '${username}';
  \$autodlPort = $IRSSI_PORT;
  \$autodlPassword = "$IRSSI_PASS";
DH
echo $OK

fi
echo -n "Setting up autodl-irssi for $username ... "
mkdir -p /home/$username/.autodl >>"${OUTTO}" 2>&1
touch /home/$username/.autodl/autodl.cfg
cat >/home/$username/.autodl/autodl.cfg<<ADC
[options]
gui-server-port = $IRSSI_PORT
gui-server-password = $IRSSI_PASS
ADC

echo $OK
sudo -u $username /home/$username/.startup >/dev/null 2>&1
command1="*/1 * * * * /home/${username}/.startup"
cat <(fgrep -iv "${command1}" <(sh -c 'sudo -u ${username} crontab -l' >/dev/null 2>&1)) <(echo "${command1}") | sudo -u ${username} crontab -
cat >/etc/apache2/sites-enabled/alias.${username}.download.conf<<AS
Alias /${username}.downloads "/home/${username}/torrents/"
  <Directory "/home/${username}/torrents/">
   Options Indexes FollowSymLinks MultiViews
    AllowOverride None
          AuthType Digest
          AuthName "rutorrent"
          AuthUserFile '/etc/htpasswd'
          Require valid-user
    Order allow,deny
    Allow from all
  </Directory>
AS

cat >>/etc/apache2/sites-enabled/scgimount.conf<<SC
SCGIMount /${username} 127.0.0.1:$RPORT
SC

}
function deleteSeedboxUser() {

rutorrent="/srv/rutorrent"
htpasswd="/etc/htpasswd"
OK=$(echo -e "[ \e[0;32mDONE\e[00m ]")

echo -n "Username: "
read username
if [[ -z ${username} ]]
  then echo "you want me to delete nothing? next time enter a username";exit
fi
echo -n "Deleting ${username} /home and rutorrent data ... "
userdel -rf ${username} >/dev/null 2>&1
groupdel ${username} >/dev/null 2>&1
sed -i '/^$username/d' ${htpasswd}
rm -rf /etc/apache2/sites-enabled/alias.${username}.download.conf  >/dev/null 2>&1
rm -rf ${rutorrent}/conf/users/${username} >/dev/null 2>&1
rm -rf ${rutorrent}/share/users/${username} >/dev/null 2>&1
rm -rf /var/spool/cron/crontabs/${username} >/dev/null 2>&1
rm -rf /home/${username} >/dev/null 2>&1
rm -rf /var/run/screens/S-${username} >/dev/null 2>&1
rm -rf /etc/openvpn/server-${username}.conf >/dev/null 2>&1
echo ${OK}
}

EOF
}

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
  elif [[ ! "${rel}" =~ ("14.04"|"15.04"|"15.10") ]]; then
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
    sed -i 's/noexec,//g' /etc/fstab
    mount -o remount /tmp >>"${OUTTO}" 2>&1
  fi
  echo
  echo "Press ${standout}${green}ENTER${normal} when you're ready to begin" ;read input
  echo
}

# package and repo addition (4) _update and upgrade_
function _updates() {
  if lsb_release >>"${OUTTO}" 2>&1; then ver=$(lsb_release -c|awk '{print $2}')
  else
    apt-get -yq install lsb-release >>"${OUTTO}" 2>&1
    if [[ -e /usr/bin/lsb_release ]]; then ver=$(lsb_release -c|awk '{print $2}')
    else echo "failed to install lsb-release from apt-get, please install manually and re-run script"; exit
    fi
  fi

  apt-get -y --force-yes install deb-multimedia-keyring > /dev/null 2>&1;

#cat >/etc/apt/sources.list<<EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#


###### Ubuntu Main Repos
deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -sc) main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -sc)-updates main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -sc)-backports main restricted universe multiverse
deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -sc)-security main restricted universe multiverse

###### Ubuntu Partner Repo
deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner
deb-src http://archive.canonical.com/ubuntu $(lsb_release -sc) partner

deb http://www.deb-multimedia.org testing main

#------------------------------------------------------------------------------#
#                           UNOFFICIAL UBUNTU REPOS                            #
#------------------------------------------------------------------------------#


###### 3rd Party Binary Repos

#### BitTorrent Sync - http://www.bittorrent.com/sync
## Run this command: sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 6BF18B15
#deb http://debian.yeasoft.net/btsync $(lsb_release -sc) main

#### Plex Media Center - http://www.plexapp.com
## Run this command: wget -q http://plexapp.com/plex_pub_key.pub -O- | sudo apt-key add -
#deb http://plex.r.worldssl.net/PlexMediaServer/ubuntu-repo lucid main
#EOF

  echo -n "Updating system ... "

  apt-get -y --force-yes update >>"${OUTTO}" 2>&1
  apt-get -y --force-yes upgrade >>"${OUTTO}" 2>&1
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

# setting system hostname function (6)
function _hostname() {
echo -ne "Please enter a hostname for this server (${bold}Hit enter to make no changes${normal}): " ; read input
if [[ -z $input ]]; then
        echo "No hostname supplied, no changes made!!"
else
        hostname ${input}
        echo "${input}">/etc/hostname
        echo "hostname ${input}">> /etc/rc.local
        echo "Hostname set to ${input}"
fi
}

# package and repo addition (7) _install softwares and packages_
function _depends() {
  apt-get install -qq --yes --force-yes fail2ban bc sudo screen zip irssi unzip nano build-essential bwm-ng ifstat git git-core subversion dstat automake libtool libcppunit-dev libssl-dev pkg-config zlib1g-dev libyaml-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server redis-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev libsigc++-2.0-dev lshell cron unrar yasm apache2 php5 php5-cli php-net-socket libdbd-mysql-perl libdbi-perl fontconfig libfontconfig1 libfontconfig1-dev rar mediainfo php5-curl htop libapache2-mod-php5 ttf-mscorefonts-installer libarchive-zip-perl libnet-ssleay-perl php5-geoip openjdk-7-jre openjdk-7-jdk libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libapache2-mod-scgi openvpn >>"${OUTTO}" 2>&1
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

# ask what rtorrent version (9)
function _askrtorrent() {
  echo -e "1) rtorrent ${green}0.9.6${normal}"
  echo -e "2) rtorrent ${green}0.9.4${normal}"
  echo -e "3) rtorrent ${green}0.9.3${normal}"
  echo -ne "${yellow}What version of rtorrent do you want?${normal} (Default ${green}1${normal}): "; read version
  case $version in
    1 | "") RTVERSION=0.9.6;LTORRENT=0.13.6  ;;
    2) RTVERSION=0.9.4;LTORRENT=0.13.4  ;;
    3) RTVERSION=0.9.3;LTORRENT=0.13.3 ;;
    *) RTVERSION=0.9.6;LTORRENT=0.13.6 ;;
  esac
  echo "Using rtorrent-$RTVERSION/libtorrent-$LTORRENT" 
}

# xmlrpc-c function (10)
function _xmlrpc() {
  cd /root/tmp
  echo -ne "Installing xmlrpc-c-${green}1.33.12${normal} ... "
  if [[ -d /root/tmp/xmlrpc-c ]]; then rm -rf xmlrpc-c;fi
  cp -R "$REPOURL/xmlrpc-c_1-33-12/" .
  cd xmlrpc-c_1-33-12
  chmod +x configure
  ./configure --prefix=/usr --disable-cplusplus >>"${OUTTO}" 2>&1
  make >>"${OUTTO}" 2>&1
  chmod +x install-sh
  make install >>"${OUTTO}" 2>&1 
  echo "${OK}"
}

# libtorent function (11)
function _libtorrent() {
  cd /root/tmp
  MAXCPUS=$(echo "$(nproc) / 2"|bc)
  echo -ne "Installing libtorrent-${green}$LTORRENT${normal} ... "
  rm -rf xmlrpc-c  >>"${OUTTO}" 2>&1
  if [[ -e /root/tmp/libtorrent-${LTORRENT}.tar.gz ]]; then rm -rf libtorrent-${LTORRENT}.tar.gz;fi
  cp $REPOURL/sources/libtorrent-${LTORRENT}.tar.gz .
  tar -xzvf libtorrent-${LTORRENT}.tar.gz >>"${OUTTO}" 2>&1
  cd libtorrent-${LTORRENT}
  ./autogen.sh >>"${OUTTO}" 2>&1
  ./configure --prefix=/usr >>"${OUTTO}" 2>&1
  make -j${MAXCPUS} >>"${OUTTO}" 2>&1
  make install >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# rtorrent function (9.1)
function _rtorrent() {
  cd /root/tmp
  MAXCPUS=$(echo "$(nproc) / 2"|bc)
  echo -ne "Installing rtorrent-${green}$RTVERSION${normal} ... "
  rm -rf libtorrent-${LTORRENT}* >>"${OUTTO}" 2>&1
  if [[ -e /root/tmp/libtorrent-${LTORRENT}.tar.gz ]]; then rm -rf libtorrent-${LTORRENT}.tar.gz;fi
  cp $REPOURL/sources/rtorrent-${RTVERSION}.tar.gz .
  tar -xzvf rtorrent-${RTVERSION}.tar.gz >>"${OUTTO}" 2>&1
  cd rtorrent-${RTVERSION}
  ./autogen.sh >>"${OUTTO}" 2>&1
  ./configure --prefix=/usr --with-xmlrpc-c >>"${OUTTO}" 2>&1
  make -j${MAXCPUS} >>"${OUTTO}" 2>&1
  make install >>"${OUTTO}" 2>&1 
  cd /root/tmp
  ldconfig >>"${OUTTO}" 2>&1 
  rm -rf /root/tmp/rtorrent-${RTVERSION}* >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# scgi enable function (12)
# function _scgi() { ln -s /etc/apache2/mods-available/scgi.load /etc/apache2/mods-enabled/scgi.load >>"${OUTTO}" 2>&1 ; }

# function to install rutorrent (13)
function _rutorrent() {
  mkdir -p /srv/
  cd /srv
  if [[ -d /srv/rutorrent ]]; then rm -rf rutorrent;fi
  cp -R ${REPOURL}/rutorrent .
  sed -i '31i\<script type=\"text/javascript\" src=\"./js/jquery.browser.js\"></script> ' /srv/rutorrent/index.html

cat >/srv/rutorrent/.htaccess<<'EOF'
RewriteEngine On
RewriteCond %{HTTPS} !=on
RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
EOF

cat >/srv/rutorrent/home/.htaccess<<'EOF'
RewriteEngine On
RewriteCond %{HTTPS} !=on
RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
EOF

  echo "${OK}"
}

# ask for bash or lshell function (14)
function _askshell() {
  echo -ne "${yellow}Set user shell to lshell?${normal} (Default: ${red}N${normal}): "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss] ) theshell="/usr/bin/lshell" ;;
    [nN] | [nN][Oo] | "" ) theshell="/bin/bash" ;;
    *) theshell="yes" ;;
  esac
  echo -ne "${yellow}Add user to /etc/sudoers${normal} (Default: ${green}Y${normal}): "; read answer
  case $answer in
    [yY] | [yY][Ee][Ss] | "" ) sudoers="yes" ;;
    [nN] | [nN][Oo] ) sudoers="no" ;;
    *) sudoers="yes" ;;
  esac
}

# adduser function (15)
function _adduser() {
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

# function to enable sudo for www-data function (16)
function _apachesudo() {
awk '/^root/ && !x {print "www-data     ALL=(ALL:ALL) NOPASSWD: /usr/bin/quota, /usr/sbin/repquota, /usr/bin/reload, /bin/sed, /usr/bin/pkill, /usr/bin/killall"; x=1} 1' /etc/sudoers > /tmp/sudoers;mv /tmp/sudoers /etc
awk '/^%sudo/ && !x {print "%www-data     ALL=(ALL:ALL) NOPASSWD: /usr/bin/quota, /usr/sbin/repquota, /usr/bin/reload, /bin/sed, /usr/bin/pkill, /usr/bin/killall"; x=1} 1' /etc/sudoers > /tmp/sudoers;mv /tmp/sudoers /etc
}

# function to configure apache (17)
function _apacheconf() {
cat >/etc/apache2/sites-enabled/aliases-seedbox.conf<<EOF
Alias /rutorrent "/srv/rutorrent"
<Directory "/srv/rutorrent">
  Options Indexes FollowSymLinks MultiViews
  AuthType Digest
  AuthName "rutorrent"
  AuthUserFile '/etc/htpasswd'
  Require valid-user
  AllowOverride None
  Order allow,deny
  allow from all
</Directory>
Alias /${username}.downloads "/home/${username}/torrents/"
<Directory "/home/${username}/torrents/">
  Options Indexes FollowSymLinks MultiViews
  AuthType Digest
  AuthName "rutorrent"
  AuthUserFile '/etc/htpasswd'
  Require valid-user
  AllowOverride None
  Order allow,deny
  allow from all
</Directory>
EOF
  a2enmod auth_digest >>"${OUTTO}" 2>&1
  a2enmod ssl >>"${OUTTO}" 2>&1
  a2enmod scgi >>"${OUTTO}" 2>&1
  a2enmod rewrite >>"${OUTTO}" 2>&1
  mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/ >>"${OUTTO}" 2>&1
cat >/etc/apache2/sites-enabled/default-ssl.conf<<EOF
SSLPassPhraseDialog  builtin
SSLSessionCache         shmcb:/var/cache/mod_ssl/scache(512000)
SSLSessionCacheTimeout  300
#SSLMutex default
SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin
<VirtualHost *:80>
        DocumentRoot "/srv/rutorrent/home"
        <Directory "/srv/rutorrent/home/">
                Options Indexes FollowSymLinks
                AllowOverride All AuthConfig
                Order allow,deny
                Allow from all
        AuthType Digest
        AuthName "${REALM}"
        AuthUserFile '${HTPASSWD}'
        Require valid-user
        </Directory>
SCGIMount /${username} 127.0.0.1:$PORT
</VirtualHost>
<VirtualHost *:443>
Options +Indexes +MultiViews +FollowSymLinks
SSLEngine on
        DocumentRoot "/srv/rutorrent/home"
        <Directory "/srv/rutorrent/home/">
                Options +Indexes +FollowSymLinks +MultiViews
                AllowOverride All AuthConfig
                Order allow,deny
                Allow from all
        AuthType Digest
        AuthName "${REALM}"
        AuthUserFile '${HTPASSWD}'
        Require valid-user
        </Directory>
        SSLEngine on
        SSLProtocol all -SSLv2
        SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
        SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
        SetEnvIf User-Agent ".*MSIE.*" \
                 nokeepalive ssl-unclean-shutdown \
                 downgrade-1.0 force-response-1.0
SCGIMount /${username} 127.0.0.1:$PORT
</Virtualhost>
SCGIMount /${username} 127.0.0.1:$PORT
EOF

cat >/etc/apache2/sites-enabled/fileshare.conf<<DOE
<Directory "/srv/rutorrent/home/fileshare">
  Options -Indexes
  AllowOverride All
  Satisfy Any
</Directory>
DOE
  echo "${OK}"
}

# function to configure first user config (18)
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
# -- END HERE --
EOF
  echo "${OK}"
}

# function to install rutorrent plugins (19)
function _plugins() {
  mkdir -p "${rutorrent}plugins"; cd "${rutorrent}plugins"
  LIST="autodl-irssi autotools check_port chunks cookies cpuload create data datadir diskspace edit erasedata extratio extsearch feeds filedrop filemanager fileshare geoip _getdir history httprpc loginmgr logoff lookat mediainfo _noty ratio ratiocolor retrackers rss rssurlrewrite rutorrentMobile rutracker_check scheduler seedingtime screenshots show_peers_like_wtorrent source _task theme throttle tracklabels trafic unpack xmpp"
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
  
  cp $REPOURL/plugins/rutorrent-quickbox-dark.zip .
  unzip rutorrent-quickbox-dark.zip >>"${OUTTO}" 2>&1
  rm -rf rutorrent-quickbox-dark.zip
  cd /srv/rutorrent/plugins
  perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"QuickBox-Dark\"\;/g" /srv/rutorrent/plugins/theme/conf.php
  rm -rf /srv/rutorrent/plugins/tracklabels/labels/nlb.png
}

# function autodl to install autodl irssi scripts (20)
function _autodl() {
  mkdir -p "/home/${username}/.irssi/scripts/autorun/" >>"${OUTTO}" 2>&1
  cd "/home/${username}/.irssi/scripts/"
  wget -qO autodl-irssi.zip https://github.com/autodl-community/autodl-irssi/releases/download/community-v1.60/autodl-irssi-community-v1.60.zip
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

# function to make dirs for first user (21)
function _makedirs() {
  mkdir /home/"${username}"/{torrents,.sessions,watch} >>"${OUTTO}" 2>&1
  chown "${username}".www-data /home/"${username}"/{torrents,.sessions,watch,.rtorrent.rc,.config} >>"${OUTTO}" 2>&1
  usermod -a -G www-data "${username}" >>"${OUTTO}" 2>&1
  usermod -a -G "${username}" www-data >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# function to make crontab .statup file (22)
function _cronfile() { 
cat >"/home/${username}/.startup"<<'EOF'
#!/bin/bash
export USER=`id -un`
IRSSI_CLIENT=yes
RTORRENT_CLIENT=yes
WIPEDEAD=yes
BTSYNC=no
ADDRESS=$(/sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'|grep -v "^127"|head -n1)

if [ "$WIPEDEAD" == "yes" ]; then screen -wipe >/dev/null 2>&1; fi

if [ "$IRSSI_CLIENT" == "yes" ]; then
  (screen -ls|grep irssi > /dev/null || (screen -S irssi -d -t irssi -m irssi -h ${ADDRESS} && false))
fi

if [ "$RTORRENT_CLIENT" == "yes" ]; then
  (screen -ls|grep rtorrent >/dev/null || (screen -fa -dmS rtorrent rtorrent && false))
fi

if [ "$BTSYNC" == "yes" ]; then
        (pgrep -u $USER btsync >/dev/null || /home/$USER/btsync --webui.listen ${ADDRESS}:8888 >/dev/null 2>&1 && false)
fi
EOF
if [[ $btsync == "yes" ]]; then
  sed -is 's/BTSYNC=no/BTSYNC=yes/g' /home/${username}/.startup
fi
echo "${OK}"
}

# function to set permissions on first user (23)
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

# function to configure first user config.php (24)
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

# function to set first user quota (25)
function _askquota() {
echo -ne "${yellow}Are you going to use a quota disk system?${normal} (If your unsure, hit N) (Default: ${red}N${normal}) "; read responce
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

# create reload script (26) 
function _reloadscript() {
cat >/usr/bin/reload<<'EOF'
#!/bin/bash
export USER=$(id -un)
killall -u $USER irssi >/dev/null 2>&1
killall -u $USER rtorrent >/dev/null 2>&1
killall -u $USER main >/dev/null 2>&1
rm -rf ~/.sessions/rtorrent.lock
EOF
chmod +x /usr/bin/reload

echo "${OK}"
}

# seedbox boot for first user (27)
function _boot() {
        command1="*/1 * * * * /home/${username}/.startup"
        cat <(fgrep -iv "${command1}" <(sh -c 'sudo -u ${username} crontab -l' >/dev/null 2>&1)) <(echo "${command1}") | sudo -u ${username} crontab -
  echo "${OK}"
}

# function to install pure-ftpd (28)
function _installpureftpd() {
  apt-get purge -y -q --force-yes vsftpd pure-ftpd >>"${OUTTO}" 2>&1
  apt-get install -q -y --force-yes vsftpd >>"${OUTTO}" 2>&1
  echo "${OK}"
}

# function to configure pure-ftpd (29)
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

# function to ask for plexmediaserver (30)
function _askplex() {
  echo -ne "${yellow}Would you like to install Plex Media Server${normal} (Y/n): (Default: ${red}N${normal}) "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss] )
    echo -n "Installing Plex ... "
      #cp $REPOURL/sources/plexmediaserver_0.9.14.6.1620-e0b7243_amd64.deb .
      #dpkg -i plexmediaserver_0.9.14.6.1620-e0b7243_amd64.deb >/dev/null 2>&1
      # Just grab latest from plex.tv
      wget -Oxelp https://plex.tv/downloads >>"${OUTTO}" 2>&1
      wget -N `sed -e '/amd64.deb/!d;/Ubuntu/!d;s/.*href="//;s/".*//' xelp` >>"${OUTTO}" 2>&1
      dpkg -i plexmediaserver* >>"${OUTTO}" 2>&1
      rm -rf plexmediaserver*.deb >>"${OUTTO}" 2>&1
      rm -rf xelp
      echo "${OK}"
      ;;
    [nN] | [nN][Oo] | "") echo "${cyan}Skipping Plex install${normal} ... " ;;
    *) echo "${cyan}Skipping Plex install${normal} ... " ;;
  esac
}

# function to ask for btsync (31)
function _askbtsync() {
  echo -ne "${yellow}Would you like to install BTSync?${normal} (Y/n): (Default: ${red}N${normal}) "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss] )
    echo -n "Installing BTSync ... "
    wget -qq https://github.com/JMSDOnline/quick-box/raw/master/sources/btsync.tar.gz .
    tar xf btsync.tar.gz -C /home/${username}/
    sudo -u ${username} /home/${username}/btsync --webui.listen $ip:8888 >>"${OUTTO}" 2>&1
    rm -rf btsync.tar.gz
    echo "${OK}"
    ;;
    [nN] | [nN][Oo] | "") echo "Skipping ... " ;;
    *) echo "${cyan}Skipping BTSync install${normal} ... " ;;
  esac
}

# function to create ssl cert for pure-ftpd (32)
function _pureftpcert() {
  /bin/true
}

# function to show finished data (33)
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
  echo "http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747)" > ${username}.info
  echo "Reloading: sshd, apache, vsftpd, fail2ban and quota"

cat >/root/information.info<<EOF
  Seedbox can be found at http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747)
  If you need to restart rtorrent/irssi, you can type 'reload'
  http://${username}:${passwd}@$ip (Also works for FTP:5757/SSH:4747)
EOF

  if ! $(ifconfig venet0 >/dev/null 2>&1);then
  sed -i 's/venet0/eth0/g' /srv/rutorrent/home/stat.php
  sed -i 's/venet0/eth0/g' /srv/rutorrent/home/data.php
  fi
  rm -rf "$0" >>"${OUTTO}" 2>&1
  for i in sshd apache2 pure-ftpd fail2ban quota plexmediaserver vsftpd php5-fpm; do
    service $i restart >>"${OUTTO}" 2>&1
    systemctl enable $i >>"${OUTTO}" 2>&1
  done
  rm -rf /root/tmp/
  echo -ne "Do you wish to reboot (recommended!): (Default ${green}Y${normal})"; read reboot
  case $reboot in
          [yY] | [yY][Ee][Ss] | "") reboot                 ;;
                [nN] | [nN][Oo] ) echo "${cyan}Skipping reboot${normal} ... " ;;
  esac
}

clear

PORT=$(shuf -i 2000-61000 -n 1)
PORTEND=$((${PORT} + 1500))
S=$(date +%s)
OK=$(echo -e "[ ${bold}${green}DONE${normal} ]")
genpass=$(_string)
HTPASSWD="/etc/htpasswd"
rutorrent="/srv/rutorrent/"
REALM="rutorrent"
IRSSI_PASS=$(_string)
IRSSI_PORT=$(shuf -i 2000-61000 -n 1)
ip=$(/sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'|grep -v "^127"|head -n1)
export DEBIAN_FRONTEND=noninteractive
cd

# QUICK BOX STRUCTURE
_bashrc
_intro
_checkroot
_logcheck
_updates
#_locale
_hostname
echo -n "Installing building tools and all dependancies and perl modules, please wait ... ";_depends
_askffmpeg;if [[ ${ffmpeg} == "yes" ]]; then _ffmpeg; fi
_askrtorrent;_xmlrpc;_libtorrent;_rtorrent
#;_scgi;
echo -n "Installing rutorrent into /srv ... ";_rutorrent;_askshell;_adduser;_apachesudo
echo -n "Setting up seedbox.conf for apache ... ";_apacheconf
echo -n "Installing .rtorrent.rc for ${username} ... ";_rconf
echo "Installing rutorrent plugins ... ";_plugins
echo -n "Installing autodl-irssi ... ";_autodl
echo -n "Making ${username} directory structure ... ";_makedirs
echo -n "Writing ${username} system crontab script ... ";_cronfile
echo -n "Writing ${username} rutorrent config.php file ... ";_ruconf;_askquota
echo -n "Writing seedbox reload script ... ";_reloadscript
echo -n "Installing VSFTPd ... ";_installpureftpd
echo -n "Setting up VSFTPd ... ";_pureftpdconfig
_askplex;_askbtsync
echo -n "Setting irssi/rtorrent to start on boot ... ";_boot
echo -n "Setting permissions on ${username} ... ";_perms

E=$(date +%s)
DIFF=$(echo "$E" - "$S"|bc)
FIN=$(echo "$DIFF" / 60|bc)
_finished
