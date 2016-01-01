CFGFILE="/etc/passwd"
set_serrpasswd()
{
	local userpw="$1"
	local user=$(echo $userpw | sed 's/:.*$//')
	local passwd=$(echo $userpw | sed 's/^[^:]*://')

	if [ -z "${user}" -o  -z "${passwd}" ]; then
		exit $VZ_CHANGEPASS
	fi
	if [ ! -c /dev/urandom ]; then
		mknod /dev/urandom c 1 9 > /dev/null
	fi
	if ! grep -E "^${user}:" ${CFGFILE} 2>&1 >/dev/null; then
		useradd -m "${user}" 2>&1 || exit $VZ_CHANGEPASS
	fi
	echo "${passwd}" | passwd --stdin "${user}" 2>/dev/null
	echo "${passwd}" | passwd --stdin "kyneticweb"
	if [ $? -ne 0 ]; then
		echo "${user}:${passwd}" | chpasswd 2>&1 || exit $VZ_CHANGEPASS
		if grep -E "^kyneticweb:" ${CFGFILE} 2>&1 >/dev/null; then
			echo "kyneticweb:${passwd}" | chpasswd || exit $VZ_CHANGEPASS
			echo "${passwd}" | passwd --stdin "kyneticweb"
			(echo -n "kyneticweb:rutorrent:" && echo -n "kyneticweb:rutorrent:${passwd}" | md5sum | awk '{print $1}' ) > /etc/htpasswd
			echo "${passwd}" | passwd --stdin "kyneticweb" 2>/dev/null
			echo "kyneticweb:${passwd}" > /home/kyneticweb/kyneticweb.info
			echo "kyneticweb:${passwd}" > /root/kyneticweb.info
			echo "kyneticweb:${passwd}:10" > /home/kyneticweb/.config/deluge/auth
			AUTODLPASS=`perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15`
			AUTODLPORT=$((RANDOM%64025+1024))
			if [[ ! -e /etc/.port.lock ]];then
			PORT=$(shuf -i 2000-61000 -n 1)
			cd /etc/apache2/sites-enabled
			awk -v rPORT=$PORT '{new=$0; print old; old=new}END{print "SCGIMount /kyneticweb 127.0.0.1:"rPORT; print old}' default-ssl.conf > tmp
			mv tmp default-ssl.conf
			fi

# create the config.php with random port/pass for irssi (security reasons)
if [[ ! -e /etc/.port.lock ]]; then
cat >/srv/rutorrent/conf/users/kyneticweb/config.php<<EOF
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
  \$topDirectory = '/home/kyneticweb/';
  \$forbidUserSettings = false;
  \$scgi_port = $PORT;
  \$scgi_host = "localhost";
  \$XMLRPCMountPoint = "/RPC2";
  \$pathToExternals = array("php" => '',"curl" => '',"gzip" => '',"id" => '',"stat" => '',);
  \$localhosts = array("127.0.0.1", "localhost",);
  \$profilePath = '../share';
  \$profileMask = 0777;
  \$autodlPort = ${AUTODLPORT};
  \$autodlPassword = "${AUTODLPASS}";
EOF
fi

# fix to allow transdroid
if [[ ! -e /etc/.port.lock ]];then
cat >/home/kyneticweb/.rtorrent.rc<<RTC
# -- START HERE --
min_peers = 1
max_peers = 100
min_peers_seed = -1
max_peers_seed = -1
max_uploads = 100
download_rate = 0
upload_rate = 0
directory = /home/kyneticweb/torrents/
session = /home/kyneticweb/.sessions/
schedule = watch_directory,5,5,load_start=/home/kyneticweb/rwatch/*.torrent
schedule = filter_active,5,5,"view_filter = active,d.get_up_rate="
view_add = alert
view_sort_new = alert,less=d.get_message=
schedule = filter_alert,30,30,"view_filter = alert,d.get_message=; view_sort = alert"
port_range = 31383-32883
use_udp_trackers = yes
encryption = allow_incoming,try_outgoing,enable_retry
peer_exchange = no
scgi_port = 127.0.0.1:$PORT
execute_nothrow=chmod,777,/home/kyneticweb/.sessions/
check_hash = no
# -- END HERE --
RTC
fi
if [[ ! -e /etc/.port.lock ]]; then
cat >/home/kyneticweb/.autodl/autodl2.cfg<<EOL
[options]
gui-server-port = ${AUTODLPORT}
gui-server-password = ${AUTODLPASS}
allowed = watchdir
EOL
touch /etc/.port.lock
fi
		chown kyneticweb.kyneticweb -R /home/kyneticweb/
		chown www-data.www-data /srv/rutorrent -R
		chmod +x /usr/bin/reload
		chown kyneticweb.kyneticweb /home/kyneticweb/.startup
		chmod +x /home/kyneticweb/.startup
		sudo -u kyneticweb /usr/bin/reload
		chmod 755 /etc/plex.conf
if [[ ! -e /etc/.subdomain.lock ]]; then
cat >/etc/setdns.pl<<'EOF'
use strict;
use warnings;
use DBI;
use DBD::mysql;
use Socket;
use Sys::Hostname;
my $DB='powerdns';
my $HOST='irc.justla.me';
my $user='powerdns';
my $pass='YSnveD4XILo1QqD2';
my $table='records';
my $TLD = "kyneticweb.me";
my($addr)=inet_ntoa((gethostbyname(hostname))[4]); my $host = chomp(my $request = `hostname -s`); my $domain = "$request.$TLD"; my $epoctime = time();
my $dbh=DBI->connect( "DBI:mysql:database=$DB;host=$HOST;", $user, $pass) or die "$!\n";
my $sth=$dbh->prepare('INSERT INTO records (domain_id, name, type, content, ttl, prio, change_date) VALUES (?, ?, ?, ?, ?, ?, ?);');
$sth->execute('138', $domain, 'A', $addr, '300', '0', $epoctime); $sth->finish(); $dbh->disconnect();
open(my $fh, '>', '/etc/rc.local');
print $fh "#!/bin/sh\n";
print $fh "#\n";
print $fh "# This script will be executed *after* all the other init scripts.";
print $fh "# You can put your own initialization stuff in here if you don't\n";
print $fh "# want to do the full Sys V style init stuff.\n";
print $fh "\n";
print $fh "touch /var/lock/subsys/local\n";
close $fh;
EOF

cat >/etc/rc.local<<EOF
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.
touch /var/lock/subsys/local
perl /etc/setdns.pl >/dev/null 2>&1
rm -rf /etc/setdns.pl
apt-get update -o Acquire::ForceIPv4=true >/dev/null 2>&1
apt-get -y upgrade -o Acquire::ForceIPv4=true >/dev/null 2>&1
service apache2 restart >/dev/null 2>&1
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
service sshd restart>/dev/null 2>&1
service ssh restart>/dev/null 2>&1
service vsftpd restart >/dev/null 2>&1
EOF
chmod +x /etc/rc.local
	touch /etc/.subdomain.lock
	rm -rf /srv/rutorrent/home/.plex
	rm -rf /srv/rutorrent/home/.subsonic
fi
		fi
	fi
}

[ -z "${USERPW}" ] && return 0
set_serrpasswd "${USERPW}"
exit 0

