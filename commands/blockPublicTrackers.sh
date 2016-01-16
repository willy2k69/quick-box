#!/bin/bash

function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }

function _denyhosts() {
echo -ne "Block Public Trackers?: (Default: \033[1mY\033[0m)"; read responce
case $responce in
  [yY] | [yY][Ee][Ss] | "")
echo -n "Blocking public trackers ... "
cat >/etc/trackers<<EOF
11.rarbg.com
2006.sxsw.com
2007.sxsw.com
209.50.48.13
80.190.151.40
9.rarbg.com
94.75.205.147
a.scarywater.net
alanb.yi.org
all4nothin.net
anifans.ath.cx
animex.com
anstracker.no-ip.org
anstracker2.no-ip.org
anvilofsound.com
baka-updates.com
bakabt.com
bangladeshrocks.com
bittorrent.frozen-layer.net
borft.student.utwente.nl
bt-flux.com
bt.base0.net
bt.cartoonpalace.net
bt.eastgame.net
bt.edwardk.info
bt.emuparadise.org
bt.etree.org
bt.fansub-irc.org
bt.ktxp.com
bt.peerseed.com
bt.shinsen-subs.org
bt.speedsubs.org
bt.the9.com
bt.tjgame.enorth.com
bt.ydy.com
btcomic.net
btjunkie.org
bttracker.acc.umu.se
colombo-bt.org
core-tracker.depthstrike.com
cotapers.org
crimsondays.com
csclub.uwaterloo.ca
dak180.dynalias.com
dattebayobrasil.com
deadacated.com
denis.stalker.h3q.com
dimeadozen.org
doctortorrent.com
egelteek.no-ip.org
elsewhere.org
ewheel.democracynow.org
exe64.com
exodus.1337x.org
extratorrent.com
extremebits.se
extremenova.org
eztv.tracker.prq.to
f.scarywater.net
fenopy.com
gdbt.3322.org
h33t.com
handfilms.com
harryy.us
hewgill.com
hexagon.cc
hits4.us
hypaculture.com
indytorrents.org
inferno.demonoid.com
insanity.in
irrenhaus.dyndns.dk
islamictorrents.net
isohunt.com
itpb.tracker.prq.to
jem.d-addicts.com
jem.d-addicts.net
kaa.animeconnection.net
kaoz-subs.de
livetorrents.com
mass-torrent.com
mightynova.com
monova.org
mozilla.isohunt.com
mrtwig.net
music-video-torrents.afz.biz
mw.igg.com
nanikano.no-ip.org
nemesis.1337x.org
newvoyages.us
nova9.org
nrkbeta.no
nxtgn.org
nyaatorrent.info
nyaatorrent.org
nyaatorrents.info
nyaatorrents.org
onebigtorrent.org
os.us.to
ostorr.org
pleasuredome.org
publicbt.com
publiclibrary.metamute.org
quetooter-torrents.kicks-ass.net
radioarchive.cc
rebootedc.no-ip.org
redsphereglobal.com
revision3.com
rocketredrockers.net
saiei.edwardk.info
seedler.org
seedpeer.com
server2.deadacated.com
shadowshq.yi.org
share.dmhy.org
sharereactor.com
sharetv.org
suprnova.org
team-mkv.homedns.org
thepiratebay.org
thewirdsdomain.com
tk.btcomic.net
tk.comican.com
tlm-project.org
tntvillage.org
tog.net
tokyotosho.com
top.igg.com
torrent-download.to
torrent-downloads.to
torrent.ibiblio.org
torrent.ipnm.ru
torrentat.org
torrentchannel.com
torrentraider.com
torrentreactor.net
torrentriot.net
torrentspy.com
torrentzilla.org
torrentzone.net
tracker.anirena.com
tracker.bitreactor.to
tracker.denness.net
tracker.exdesi.com
tracker.frozen-layer.net
tracker.gotwoot.net
tracker.ilibr.org
tracker.ilovetorrents.com
tracker.istole.it
tracker.mariposahd.tv
tracker.minglong.org
tracker.openbittorrent.com
tracker.se
tracker.tahise.info
tracker.tlm-project.org
tracker.to
tracker.token.ro
tracker.torrent.to
tracker.torrent411.com
tracker.torrentbay.to
tracker.torrentbox.com
tracker.torrenty.org
tracker.zaerc.com
tracker1.comicpirates.info
tracker1.finalgear.com
tracker1.torrentum.pl
tracker1.transamrit.net
tracker2.comicpirates.info
tracker2.finalgear.com
tracker2.torrentum.pl
tracker3.comicpirates.info
tracker3.finalgear.com
tracker4.finalgear.com
tracker5.zcultfm.com
trackerb.zcultfm.com
trackers.transamrit.net
transamrit.net
tvrss.net
ushiai.no-ip.org
usotsuki.info
weebl00.nl
weedy.1.vg
wrentype.hoshinet.org
www.ahashare.com
www.allotracker.com
www.bitenova.nl
www.bittorrent.am
www.bittorrentshare.com
www.bt-chat.com
www.btmon.com
www.btscene.com
www.btswarm.org
www.chomskytorrents.org
www.datorrents.com
www.deadfrog.us
www.demonoid.com
inferno.demonoid.ph
www.downloadanime.org
www.elephantsdream.org
www.eztv.it
www.fulldls.com
www.hightorrent.to
www.idealtorrent.com
www.ipodnova.tv
www.livingtorrents.com
www.mabula.net
www.mac-torrents.com
www.matrix8.com
www.mininova.org
www.mvtorrents.com
www.mybittorrent.com
www.mytorrent.pl
www.new2me.net
www.newtorrents.info
www.nitcom.com.au
www.okbt.com
www.p2pbg.com
www.peteteo.com
www.pimptorrent.com
www.point-blank.cc
www.psppirates.com
www.publicdomaintorrents.com
www.raphustle.com
www.seedleech.com
www.sitasingstheblues.com
www.slotorrent.net
www.smaragdtorrent.to
www.solidz.com
www.speedtorrent.to
www.sumotorrent.com
www.thetorrentsite.com
www.todotorrents.com
www.torrent.to
www.torrentbar.com
www.torrentbox.com
www.torrentdownloads.net
www.torrentlocomotive.com
www.torrentportal.com
www.torrentreactor.to
www.torrentum.pl
www.tracker.big-torrent.to
www.tribalmixes.com
www.tvnihon.com
www.web-torrent.com
www.worldnova.org
www.zeoez.com
www.zoektorrents.com
11.rarbg.com
10.rarbg.com
i.bandito.org
tracker.prq.to
tracker.tfile.me
exodus.desync.com
open.demonii.com
tracker.coppersurfer.tk
tracker.leechers-paradise.org
EOF
cat >>/etc/hosts<<EOF
127.0.0.1 10.rarbg.com
127.0.0.1 11.rarbg.com
127.0.0.1 2006.sxsw.com
127.0.0.1 2007.sxsw.com
127.0.0.1 209.50.48.13
127.0.0.1 80.190.151.40
127.0.0.1 9.rarbg.com
127.0.0.1 94.75.205.147
127.0.0.1 a.scarywater.net
127.0.0.1 alanb.yi.org
127.0.0.1 all4nothin.net
127.0.0.1 anifans.ath.cx
127.0.0.1 animex.com
127.0.0.1 anstracker.no-ip.org
127.0.0.1 anstracker2.no-ip.org
127.0.0.1 anvilofsound.com
127.0.0.1 baka-updates.com
127.0.0.1 bakabt.com
127.0.0.1 bangladeshrocks.com
127.0.0.1 bittorrent.frozen-layer.net
127.0.0.1 borft.student.utwente.nl
127.0.0.1 bt-flux.com
127.0.0.1 bt.base0.net
127.0.0.1 bt.cartoonpalace.net
127.0.0.1 bt.eastgame.net
127.0.0.1 bt.edwardk.info
127.0.0.1 bt.emuparadise.org
127.0.0.1 bt.etree.org
127.0.0.1 bt.fansub-irc.org
127.0.0.1 bt.ktxp.com
127.0.0.1 bt.peerseed.com
127.0.0.1 bt.shinsen-subs.org
127.0.0.1 bt.speedsubs.org
127.0.0.1 bt.the9.com
127.0.0.1 bt.tjgame.enorth.com
127.0.0.1 bt.ydy.com
127.0.0.1 btcomic.net
127.0.0.1 btjunkie.org
127.0.0.1 bttracker.acc.umu.se
127.0.0.1 colombo-bt.org
127.0.0.1 core-tracker.depthstrike.com
127.0.0.1 cotapers.org
127.0.0.1 crimsondays.com
127.0.0.1 csclub.uwaterloo.ca
127.0.0.1 dak180.dynalias.com
127.0.0.1 dattebayobrasil.com
127.0.0.1 deadacated.com
127.0.0.1 denis.stalker.h3q.com
127.0.0.1 dimeadozen.org
127.0.0.1 doctortorrent.com
127.0.0.1 egelteek.no-ip.org
127.0.0.1 elsewhere.org
127.0.0.1 ewheel.democracynow.org
127.0.0.1 exe64.com
127.0.0.1 exodus.1337x.org
127.0.0.1 extratorrent.com
127.0.0.1 extremebits.se
127.0.0.1 extremenova.org
127.0.0.1 eztv.tracker.prq.to
127.0.0.1 f.scarywater.net
127.0.0.1 fenopy.com
127.0.0.1 gdbt.3322.org
127.0.0.1 h33t.com
127.0.0.1 handfilms.com
127.0.0.1 harryy.us
127.0.0.1 hewgill.com
127.0.0.1 hexagon.cc
127.0.0.1 hits4.us
127.0.0.1 hypaculture.com
127.0.0.1 indytorrents.org
127.0.0.1 inferno.demonoid.com
127.0.0.1 insanity.in
127.0.0.1 irrenhaus.dyndns.dk
127.0.0.1 islamictorrents.net
127.0.0.1 isohunt.com
127.0.0.1 itpb.tracker.prq.to
127.0.0.1 jem.d-addicts.com
127.0.0.1 jem.d-addicts.net
127.0.0.1 kaa.animeconnection.net
127.0.0.1 kaoz-subs.de
127.0.0.1 livetorrents.com
127.0.0.1 mass-torrent.com
127.0.0.1 mightynova.com
127.0.0.1 monova.org
127.0.0.1 mozilla.isohunt.com
127.0.0.1 mrtwig.net
127.0.0.1 music-video-torrents.afz.biz
127.0.0.1 mw.igg.com
127.0.0.1 nanikano.no-ip.org
127.0.0.1 nemesis.1337x.org
127.0.0.1 newvoyages.us
127.0.0.1 nova9.org
127.0.0.1 nrkbeta.no
127.0.0.1 nxtgn.org
127.0.0.1 nyaatorrent.info
127.0.0.1 nyaatorrent.org
127.0.0.1 nyaatorrents.info
127.0.0.1 nyaatorrents.org
127.0.0.1 onebigtorrent.org
127.0.0.1 os.us.to
127.0.0.1 ostorr.org
127.0.0.1 pleasuredome.org.uk
127.0.0.1 publicbt.com
127.0.0.1 publiclibrary.metamute.org
127.0.0.1 quetooter-torrents.kicks-ass.net
127.0.0.1 radioarchive.cc
127.0.0.1 rebootedc.no-ip.org
127.0.0.1 redsphereglobal.com
127.0.0.1 revision3.com
127.0.0.1 rocketredrockers.net
127.0.0.1 saiei.edwardk.info
127.0.0.1 seedler.org
127.0.0.1 seedpeer.com
127.0.0.1 server2.deadacated.com
127.0.0.1 shadowshq.yi.org
127.0.0.1 share.dmhy.org
127.0.0.1 sharereactor.com
127.0.0.1 sharetv.org
127.0.0.1 suprnova.org
127.0.0.1 team-mkv.homedns.org
127.0.0.1 thepiratebay.org
127.0.0.1 thewirdsdomain.com
127.0.0.1 tk.btcomic.net
127.0.0.1 tk.comican.com
127.0.0.1 tlm-project.org
127.0.0.1 tntvillage.org
127.0.0.1 tog.net
127.0.0.1 tokyotosho.com
127.0.0.1 top.igg.com
127.0.0.1 torrent-download.to
127.0.0.1 torrent-downloads.to
127.0.0.1 torrent.ibiblio.org
127.0.0.1 torrent.ipnm.ru
127.0.0.1 torrentat.org
127.0.0.1 torrentchannel.com
127.0.0.1 torrentraider.com
127.0.0.1 torrentreactor.net
127.0.0.1 torrentriot.net
127.0.0.1 torrentspy.com
127.0.0.1 torrentzilla.org
127.0.0.1 torrentzone.net
127.0.0.1 tracker.anirena.com
127.0.0.1 tracker.bitreactor.to
127.0.0.1 tracker.denness.net
127.0.0.1 tracker.exdesi.com
127.0.0.1 tracker.frozen-layer.net
127.0.0.1 tracker.gotwoot.net
127.0.0.1 tracker.ilibr.org
127.0.0.1 tracker.ilovetorrents.com
127.0.0.1 tracker.istole.it
127.0.0.1 tracker.mariposahd.tv
127.0.0.1 tracker.minglong.org
127.0.0.1 tracker.openbittorrent.com
127.0.0.1 tracker.seeding.it
127.0.0.1 tracker.tahise.info
127.0.0.1 tracker.tlm-project.org
127.0.0.1 tracker.to
127.0.0.1 tracker.token.ro
127.0.0.1 tracker.torrent.to
127.0.0.1 tracker.torrent411.com
127.0.0.1 tracker.torrentbay.to
127.0.0.1 tracker.torrentbox.com
127.0.0.1 tracker.torrenty.org
127.0.0.1 tracker.zaerc.com
127.0.0.1 tracker1.comicpirates.info
127.0.0.1 tracker1.finalgear.com
127.0.0.1 tracker1.torrentum.pl
127.0.0.1 tracker1.transamrit.net
127.0.0.1 tracker2.comicpirates.info
127.0.0.1 tracker2.finalgear.com
127.0.0.1 tracker2.torrentum.pl
127.0.0.1 tracker3.comicpirates.info
127.0.0.1 tracker3.finalgear.com
127.0.0.1 tracker4.finalgear.com
127.0.0.1 tracker5.zcultfm.com
127.0.0.1 trackerb.zcultfm.com
127.0.0.1 trackers.transamrit.net
127.0.0.1 transamrit.net
127.0.0.1 tvrss.net
127.0.0.1 ushiai.no-ip.org
127.0.0.1 usotsuki.info
127.0.0.1 weebl00.nl
127.0.0.1 weedy.1.vg
127.0.0.1 wrentype.hoshinet.org
127.0.0.1 www.ahashare.com
127.0.0.1 www.allotracker.com
127.0.0.1 www.bitenova.nl
127.0.0.1 www.bittorrent.am
127.0.0.1 www.bittorrentshare.com
127.0.0.1 www.bt-chat.com
127.0.0.1 www.btmon.com
127.0.0.1 www.btscene.com
127.0.0.1 www.btswarm.org
127.0.0.1 www.chomskytorrents.org
127.0.0.1 www.datorrents.com
127.0.0.1 www.deadfrog.us
127.0.0.1 www.demonoid.com
127.0.0.1 inferno.demonoid.ph
127.0.0.1 www.downloadanime.org
127.0.0.1 www.elephantsdream.org
127.0.0.1 www.eztv.it
127.0.0.1 www.fulldls.com
127.0.0.1 www.hightorrent.to
127.0.0.1 www.idealtorrent.com
127.0.0.1 www.ipodnova.tv
127.0.0.1 www.livingtorrents.com
127.0.0.1 www.mabula.net
127.0.0.1 www.mac-torrents.com
127.0.0.1 www.matrix8.com
127.0.0.1 www.mininova.org
127.0.0.1 www.mvtorrents.com
127.0.0.1 www.mybittorrent.com
127.0.0.1 www.mytorrent.pl
127.0.0.1 www.new2me.net
127.0.0.1 www.newtorrents.info
127.0.0.1 www.nitcom.com.au
127.0.0.1 www.okbt.com
127.0.0.1 www.p2pbg.com
127.0.0.1 www.peteteo.com
127.0.0.1 www.pimptorrent.com
127.0.0.1 www.point-blank.cc
127.0.0.1 www.psppirates.com
127.0.0.1 www.publicdomaintorrents.com
127.0.0.1 www.raphustle.com
127.0.0.1 www.seedleech.com
127.0.0.1 www.sitasingstheblues.com
127.0.0.1 www.slotorrent.net
127.0.0.1 www.smaragdtorrent.to
127.0.0.1 www.solidz.com
127.0.0.1 www.speedtorrent.to
127.0.0.1 www.sumotorrent.com
127.0.0.1 www.thetorrentsite.com
127.0.0.1 www.todotorrents.com
127.0.0.1 www.torrent.to
127.0.0.1 www.torrentbar.com
127.0.0.1 www.torrentbox.com
127.0.0.1 www.torrentdownloads.net
127.0.0.1 www.torrentlocomotive.com
127.0.0.1 www.torrentportal.com
127.0.0.1 www.torrentreactor.to
127.0.0.1 www.torrentum.pl
127.0.0.1 www.tracker.big-torrent.to
127.0.0.1 www.tribalmixes.com
127.0.0.1 www.tvnihon.com
127.0.0.1 www.web-torrent.com
127.0.0.1 www.worldnova.org
127.0.0.1 www.zeoez.com
127.0.0.1 www.zoektorrents.com
127.0.0.1 11.rarbg.com
127.0.0.1 10.rarbg.com
127.0.0.1 i.bandito.org
127.0.0.1 tracker.prq.to
127.0.0.1 tracker.tfile.me
127.0.0.1 exodus.desync.com
127.0.0.1 open.demonii.com
127.0.0.1 tracker.coppersurfer.tk
127.0.0.1 tracker.leechers-paradise.org
EOF
cat >/etc/cron.daily/denypublic<<'EOF'
IFS=$'\n'
L=$(/usr/bin/sort trackers | /usr/bin/uniq)
for fn in $L; do
        /sbin/iptables -D INPUT -d $fn -j DROP
        /sbin/iptables -D FORWARD -d $fn -j DROP
        /sbin/iptables -D OUTPUT -d $fn -j DROP
        /sbin/iptables -A INPUT -d $fn -j DROP
        /sbin/iptables -A FORWARD -d $fn -j DROP
        /sbin/iptables -A OUTPUT -d $fn -j DROP
done
EOF
chmod +x /etc/cron.daily/denypublic
  echo "${OK}"
  ;;
  [nN] | [nN][Oo] ) echo "Allowing ... "
                ;;
        esac
}

_denyhosts