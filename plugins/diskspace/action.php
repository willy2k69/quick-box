<?php
//apache     ALL=(ALL:ALL) NOPASSWD: /usr/bin/quota, /usr/sbin/repquota
//%apache     ALL=(ALL:ALL) NOPASSWD: /usr/bin/quota, /usr/sbin/repquota
require_once( '../../php/util.php' );
        if (isset($quotaUser) && $quotaUser!="" && isset($diskuser) && $diskuser!="") {
			$total = shell_exec("sudo /usr/sbin/repquota ".$diskuser."|/bin/grep ^".$quotaUser."|/usr/bin/awk '{printf \$4*1024}'");
                        $free = shell_exec("sudo /usr/sbin/repquota ".$diskuser."| /bin/grep ^".$quotaUser."|/usr/bin/awk '{printf (\$4-\$3)*1024}'");
                        cachedEcho('{ "total": '.$total.', "free": '.$free.' }',"application/json");
                } else {
                        cachedEcho('{ "total": '.disk_total_space($topDirectory).', "free": '.disk_free_space($topDirectory).' }',"application/json");
                }

