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

_intro
_updates

}
. shunit2-2.1.6/src/shunit2