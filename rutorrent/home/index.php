<?php
session_destroy();
include '/srv/rutorrent/php/util.php';
include 'req/class.php';
$interface = "eth0";
$version = "1.6.5";
error_reporting(E_ALL);
$username = getUser();
function session_start_timeout($timeout=5, $probability=100, $cookie_domain='/') {
  ini_set("session.gc_maxlifetime", $timeout);
  ini_set("session.cookie_lifetime", $timeout);
  $seperator = strstr(strtoupper(substr(PHP_OS, 0, 3)), "WIN") ? "\\" : "/";
  $path = ini_get("session.save_path") . $seperator . "session_" . $timeout . "sec";
  if(!file_exists($path)) {
    if(!mkdir($path, 600)) {
      trigger_error("Failed to create session save path directory '$path'. Check permissions.", E_USER_ERROR);
    }
  }
  ini_set("session.save_path", $path);
  ini_set("session.gc_probability", $probability);
  ini_set("session.gc_divisor", 100);
  session_start();
  if(isset($_COOKIE[session_name()])) {
    setcookie(session_name(), $_COOKIE[session_name()], time() + $timeout, $cookie_domain);
  }
}

session_start_timeout(5);
$MSGFILE = session_id();

function processExists($processName, $username) {
  $exists= false;
  exec("ps axo user:20,pid,pcpu,pmem,vsz,rss,tty,stat,start,time,comm|grep $username | grep -iE $processName | grep -v grep", $pids);
  if (count($pids) > 0) {
    $exists = true;
  }
  return $exists;
}
$rtorrent = processExists("\"main|rtorrent\"",$username);
$irssi = processExists("irssi",$username);
$btsync = processExists("btsync",$username);
$plex = processExists("Plex",$username);

function isEnabled($search, $username){
  $string = file_get_contents('/home/'.$username.'/.startup');
  $service = $search;
  if(preg_match("/\b".$search."\b/", $string)){
    return " <div class=\"toggle-wrapper pull-right\"><div class=\"toggle-en toggle-light primary\" onclick=\"location.href='?id=77&serviceend=$service'\"></div></div>";
  } else {
    return " <div class=\"toggle-wrapper pull-right\"><div class=\"toggle-dis toggle-light primary\" onclick=\"location.href='?id=66&servicestart=$service'\"></div></div>";
  }
}

function writeMsg($message) {
  $file = $GLOBALS['MSGFILE'];
  $Handle = fopen("/tmp/" . $file, 'w');
  fwrite($Handle, $message);
  fclose($Handle);
}

function readMsg() {
  $file = $GLOBALS['MSGFILE'];
  $Handle = fopen("/tmp/" . $file, 'r');
  $output = fgets($Handle);
  fclose($Handle);
  if (isset($output)) {
    $data = $output;
    echo $data;
  } else {
    echo "error";
  }
}

function writePlex($ip) {
  $username = getUser();
  if (file_exists('.plex')) {
    $myFile = "/etc/apache2/sites-enabled/plex.conf";
    $fh = fopen($myFile, 'w') or die("can't open file");
    $stringData = "";
    fwrite($fh, $stringData);
    fclose($fh);
    unlink('.plex');
    writeMsg("Hello <b>$username</b>: Im going to disable public access for <b>Plex Media Server</b>. You may still access Plex privately on port <a href=\"http://ip:32400/web/index.html\" target=\"_blank\">32400</a>. Note however, you will need to open an SSH Tunnel to use your servers Plex Media Server.<br><br>If you do not know how, read about setting up an SSH Tunnel <a href=\"https://github.com/JMSDOnline/quick-box/wiki/F.A.Q#how-do-i-create-an-ssh-tunnel-and-connect-to-plex\" rel=\"noindex, nofollow\" target=\"_blank\">HERE</a> ... <br>");
    $message = "Hello <b>$username</b>: Im going to disable public access for <b>Plex Media Server</b>. You may still access Plex privately on port <a href=\"http://ip:32400/web/index.html\" target=\"_blank\">32400</a>. Note however, you will need to open an SSH Tunnel to use your servers Plex Media Server.<br><br>If you do not know how, read about setting up an SSH Tunnel <a href=\"https://github.com/JMSDOnline/quick-box/wiki/F.A.Q#how-do-i-create-an-ssh-tunnel-and-connect-to-plex\" rel=\"noindex, nofollow\" target=\"_blank\">HERE</a> ... <br>";
    shell_exec('sudo service apache2 reload &');
    return 'Disabling inital setup connection for plex ... ';
  } else {
    $myFile = "/etc/apache2/sites-enabled/plex.conf";
    $fh = fopen($myFile, 'w') or die("can't open file");
    $stringData = "";
    $stringData .= "LoadModule proxy_module /usr/lib/apache2/modules/mod_proxy.so\n";
    $stringData .= "LoadModule proxy_http_module /usr/lib/apache2/modules/mod_proxy_http.so\n";
    $stringData .= "<VirtualHost *:31400>\n";
    $stringData .= "ProxyRequests Off\n";
    $stringData .= "ProxyPreserveHost On\n";
    $stringData .= "<Proxy *>\n";
    $stringData .= " AddDefaultCharset Off\n";
    $stringData .= " Order deny,allow\n";
    $stringData .= " Allow from all\n";
    $stringData .= "</Proxy>\n";
    $stringData .= "ProxyPass / http://ip:32400/\n";
    $stringData .= "ProxyPassReverse / http://ip:32400/\n";
    $stringData .= "</VirtualHost>\n";
    $stringData .= "<IfModule mod_proxy.c>\n";
    $stringData .= "        Listen 31400\n";
    $stringData .= "</IfModule>\n";
    fwrite($fh, $stringData);
    fclose($fh);
    $myFile = ".plex";
    $fh = fopen($myFile, 'w') or die("can't open file");
    $stringData = "";
    fwrite($fh, $stringData);
    fclose($fh);
    writeMsg("Hello <b>$username</b>: Im going to enable public access for your <b>Plex Media Server</b> ... </a><br>");
    $message = "Hello <b>$username</b>: Im going to enable public access for your <b>Plex Media Server</b> ... </a><br>";
    shell_exec('sudo service apache2 reload & ');
    return 'Enabling inital setup connection for plex ... ';
  }
}

function chkPlex() {
  if (file_exists('.plex')) {
    return " <div class=\"toggle-wrapper pull-right\"><div class=\"toggle-en toggle-light primary\" onclick=\"location.href='?id=88'\"></div></div>";
  } else {
    return " <div class=\"toggle-wrapper pull-right\"><div class=\"toggle-dis toggle-light primary\" onclick=\"location.href='?id=88'\"></div></div>";
  }
}

$plexURL = "http://" . $_SERVER['HTTP_HOST'] . ":31400/web/";
$btsyncURL = "http://" . $_SERVER['HTTP_HOST'] . ":8888/gui/";

$reload='';
$service='';
if ($rtorrent == "1") { $rval = "RTorrent <span class=\"label label-success pull-right\">Enabled</span>"; 
} else { $rval = "RTorrent <span class=\"label label-danger pull-right\">Disabled</span>";
}

if ($irssi == "1") { $ival = "iRSSi-Autodl <span class=\"label label-success pull-right\">Enabled</span>"; 
} else { $ival = "iRSSi-Autodl <span class=\"label label-danger pull-right\">Disabled</span>";
}

if ($btsync == "1") { $bval = "BTSync <span class=\"label label-success pull-right\">Enabled</span>"; 
} else { $bval = "BTSync <span class=\"label label-danger pull-right\">Disabled</span>";
}

if (file_exists('.plex')) { $pval = "Plex Public Access <span class=\"label label-success pull-right\">Enabled</span>"; 
} else { $pval = "Plex Public Access <span class=\"label label-danger pull-right\">Disabled</span>";
}

if ($_GET['serviceend']) {
        $thisname = $_GET['serviceend'];
        $thisname = str_replace(['yes', 'no', '!!~!!'], ['!!~!!', 'yes', 'no'], $thisname);
}
if ($_GET['servicestart']) {
        $thisname=str_replace(['yes', 'no', '!!~!!'], ['!!~!!', 'yes', 'no'], $thisname);
        $thisname = $_GET['servicestart'];
}
if ($_GET['reload']) { 
        shell_exec("sudo -u " . $username . " /usr/bin/reload"); 
        $myUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] && !in_array(strtolower($_SERVER['HTTPS']),array('off','no'))) ? 'https' : 'http';
        $myUrl .= '://'.$_SERVER['HTTP_HOST'];
        $newURL = $myURL;
        header('Location: '.$newURL);
}
$base = 1024;
$location = "/home";

/* check for services */
switch (intval($_GET['id'])) {
case 0:
if (file_exists('/home/'.$username.'/.startup')) {
  $cbodyhello .= 'Hey <b>' . $username . '</b>: Please click switch On/Off Once and wait atleast 90 seconds for the changes to take affect ... <br><br><br>';
  $rtorrent = isEnabled("RTORRENT_CLIENT=yes", $username);
    $cbodyr .= "RTorrent ". $rtorrent;
  $irssi = isEnabled("IRSSI_CLIENT=yes", $username);
    $cbodyi .= "iRSSi-AutoDL ". $irssi;
  $btsync = isEnabled("BTSYNC=yes", $username);
    $cbodyb .= "BTSync ". $btsync;
  $plexcheck = chkPlex();
    $cbodyp .= "Plex Public Access " .$plexcheck;
  } else {
    $cbodyerr .= "error locating start up script .. feel free to open a issue at the quick box repo"; 
}

break;

/* start services */
case 66:
  $name = $_GET['servicestart'];
  $thisname=str_replace(['yes', 'no', '!!~!!'], ['!!~!!', 'yes', 'no'], $name);
    if (file_exists('/home/'.$username.'/.startup')) {
    if ($name == "BTSYNC=yes") { $servicename = "btsync"; } else { $output = substr($thisname, 0, strpos(strtolower($thisname), '_')); $servicename = strtolower($output); }
writeMsg("Hey <b>$username</b>: Im going to enable <b>$servicename</b> ... Please allow 5 minutes for it to start ... </a><br>");
$message = "Hey <b>$username</b>: Im going to enable <b>$servicename</b> ... Please allow 5 minutes for it to start ... </a><br>";
    shell_exec("sudo sed -i 's/$thisname/$name/g' /home/$username/.startup");
  $output = substr($thisname, 0, strpos(strtolower($thisname), '_'));
//writeMsg("Starting: <b> " . $servicename . "</b>");
  } else {
writeMsg("error locating .startup .. feel free to open a issue at the quick box repo");
$message = "error locating .startup .. feel free to open a issue at the quick box repo";
  }
  header('Location: https://' . $_SERVER['HTTP_HOST'] . '/');
break;

/* disable services */
case 77:
  $name = $_GET['serviceend'];
  $thisname=str_replace(['yes', 'no', '!!~!!'], ['!!~!!', 'yes', 'no'], $name);
    if (file_exists('/home/'.$username.'/.startup')) {
    if ($name == "BTSYNC=yes") { $servicename = "btsync"; } else { $output = substr($thisname, 0, strpos(strtolower($thisname), '_')); $servicename = strtolower($output);
    if (strpos($servicename,'rtorrent') !== false) { $servicename="main"; } }
writeMsg("Hello <b>$username</b>: Im going to disable <b>$servicename</b> ... </a><br>");
$message = "Hello <b>$username</b>: Im going to disable <b>$servicename</b> ... </a><br>";
    shell_exec("sudo sed -i 's/$name/$thisname/g' /home/$username/.startup");
    shell_exec("sudo -u $username pkill -9 $servicename");
  } else {
writeMsg("error locating .startup .. feel free to open an issue at the quick box repo");
$message = "error locating .startup .. feel free to open an issue at the quick box repo";
  }
  header('Location: https://' . $_SERVER['HTTP_HOST'] . '/');
break;

/* enable plex */
case 88:
//  $myip = getHostByName(getHostName());
  $myip = $_SERVER['HTTP_HOST'];
  $pbody .= writePlex($myip);
  header('Location: https://' . $_SERVER['HTTP_HOST'] . '/');
break;

}

?>

<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="">
  <!--<link rel="shortcut icon" href="../images/favicon.png" type="image/png">-->

  <title>Your Seedbox Dashboard</title>

  <link rel="stylesheet" href="lib/jquery-ui/jquery-ui.css">
  <link rel="stylesheet" href="lib/Hover/hover.css">
  <link rel="stylesheet" href="lib/jquery-toggles/toggles-full.css">
  <link rel="stylesheet" href="lib/font-awesome/font-awesome.css">
  <link rel="stylesheet" href="lib/ionicons/css/ionicons.css">
  <link rel="stylesheet" href="skins/quick.css">

  <script src="lib/modernizr/modernizr.js"></script>
  <script src="lib/jquery/jquery.js"></script>
  <script type="text/javascript" src="lib/flot/jquery.flot.js"></script>
  <script type="text/javascript" src="lib/flot/jquery.flot.time.js"></script>
  <script type="text/javascript" src="lib/flot/jquery.flot.resize.js"></script>
  <script type="text/javascript" src="lib/flot/jquery.flot.canvas.js"></script>
  <script id="source" language="javascript" type="text/javascript"> 
  $(document).ready(function() { 
      var options = { 
          lines: { show: true }, 
          border: { show: true },
          points: { show: true }, 
          xaxis: { mode: "time" } 
      }; 
      var data = []; 
      var placeholder = $("#placeholder"); 
      $.plot(placeholder, data, options); 
      var iteration = 0; 
      function fetchData() { 
          ++iteration; 
          function onDataReceived(series) { 
              // we get all the data in one go, if we only got partial 
              // data, we could merge it with what we already got 
              data = [ series ]; 
              $.plot($("#placeholder"), data, options); 
              fetchData(); 
          } 
          $.ajax({ 
              url: "req/data.php", 
              method: 'GET', 
              dataType: 'json', 
              success: onDataReceived 
          }); 
      } 
      setTimeout(fetchData, 1000); 
  }); 
  </script> 
  <script language="javascript" type="text/javascript"> 
  $(document).ready(function() {
  function uptime() {
    $.ajax({url: "req/up.php", cache:true, success: function (result) {
      $('#uptime').html(result);
      setTimeout(function(){uptime()}, 1000);
    }});
  }
  uptime();

  function sload() {
    $.ajax({url: "req/load.php", cache:true, success: function (result) {
      $('#cpuload').html(result);
      setTimeout(function(){sload()}, 1000);
    }});
  }
  sload();

  function bwtables() {
    $.ajax({url: "req/bw_tables.php", cache:false, success: function (result) {
      $('#bw_tables').html(result);
      setTimeout(function(){bwtables()}, 1000);
    }});
  }
  bwtables();

  function diskstats() {
    $.ajax({url: "req/disk_data.php", cache:false, success: function (result) {
      $('#disk_data').html(result);
      setTimeout(function(){diskstats()}, 1000);
    }});
  }
  diskstats();
  }); 
  //success: function (result)
</script> 
  <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
  <script src="../lib/html5shiv/html5shiv.js"></script>
  <script src="../lib/respond/respond.src.js"></script>
  <![endif]-->

</head>
<body>
<header>
  <div class="headerpanel">
    <div class="logopanel">
      <h2><a href="#"><img src="/img/logo.png" alt="Quick Box Seedbox" class="logo-image" height="50" /></a></h2>
    </div><!-- logopanel -->
    <div class="headerbar">
      <a id="menuToggle" class="menutoggle"><i class="fa fa-bars"></i></a>
      <div class="header-right">
        <ul class="headermenu">
          <li>
            <div class="btn-group">
              <button type="button" class="btn btn-logged">
                <span style="font-size:18px;"><?php echo "$username"; ?></span>
              </button>
            </div>
          </li>
        </ul>
      </div><!-- header-right -->
    </div><!-- headerbar -->
  </div><!-- header-->
</header>
<section>
  <div class="leftpanel">
    <div class="leftpanelinner">
      <ul class="nav nav-tabs nav-justified nav-sidebar">
        <li class="tooltips active" data-toggle="tooltip" title="Main Menu" data-placement="bottom"><a data-toggle="tab" data-target="#mainmenu"><i class="tooltips fa fa-ellipsis-h"></i></a></li>
        <li class="tooltips" data-toggle="tooltip" title="Help" data-placement="bottom"><a data-toggle="tab" data-target="#help"><i class="tooltips fa fa-question-circle"></i></a></li>
        <li class="tooltips" data-toggle="tooltip" title="Found a bug? Report it here!" data-placement="bottom"><a href="https://github.com/JMSDOnline/quick-box/issues" target="_blank"><i class="fa fa-warning"></i></a></li>
      </ul>
      <div class="tab-content">
        <!-- ################# MAIN MENU ################### -->
        <div class="tab-pane active" id="mainmenu">
          <h5 class="sidebar-title">Main Menu</h5>
          <ul class="nav nav-pills nav-stacked nav-quirk">
            <li class="active"><a href="index.php"><i class="fa fa-home"></i> <span>Dashboard</span></a></li>
            <li><a href="/rutorrent" target="_blank"><i class="fa fa-puzzle-piece"></i> <span>ruTorrent</span></a></li>
            <?php if (processExists("btsync",$username)) { echo "<li><a href=\"$btsyncURL\" target=\"_blank\"><i class=\"fa fa-retweet\"></i> <span>BTSync</span></a></li>"; } ?>
            <?php if (file_exists('.plex')) { echo "<li><a href=\"$plexURL\" target=\"_blank\"><i class=\"fa fa-play\"></i> <span>Plex</span></a></li>"; } ?>
            <li class="nav-parent nav-active">
              <a href=""><i class="fa fa-cube"></i> <span>Downloads</span></a>
              <ul class="children">
                <li><a href="/<?php echo "$username"; ?>.downloads" target="_blank">ruTorrent</a></a></li>
              </ul>
            </li>
            <li><a href="?reload=true"><i class="fa fa-refresh"></i> <span>Reload Services</span></a></li>
          </ul>
        </div><!-- tab pane -->
        <div class="tab-pane" id="help">
          <h5 class="sidebar-title">Quick System Tips</h5>
          <ul class="nav nav-pills nav-stacked nav-quirk nav-mail">
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">disktest</span><br/>
            <small>Type this command to perform a quick r/w test of your disk.</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">fixhome</span><br/>
            <small>Type this command to quickly adjusts /home directory permissions.</small></li>
          </ul>
          <h5 class="sidebar-title">Admin Commands</h5>
          <ul class="nav nav-pills nav-stacked nav-quirk nav-mail">
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">createSeedboxUser</span><br/>
            <small>Type this command in ssh to create a new seedbox user on your server.</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">deleteSeedboxUser</span><br/>
            <small>Type this command in ssh to delete a seedbox user on your server. You will need to enter the users account name, you will be prompted.</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">changeUserpass</span><br/>
            <small>Typing this command in ssh allows you to change a disired users password.</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">reload</span><br/>
            <small>Type this command in ssh to reload all services on your seedbox. These services include rTorrent and IRSSI.</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">upgradeBTSync</span><br/>
            <small>Type this command in ssh to upgrade BTSync to newest version when available.</small></li>
          </ul>
          <h5 class="sidebar-title">Essential User Commands</h5>
          <ul class="nav nav-pills nav-stacked nav-quirk nav-mail">
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">reload</span><br/>
            <small>allows user to reload their services (rtorrent and irssi)</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">screen -fa -dmS rtorrent rtorrent</span><br/>
            <small>allows user to restart/remount rtorrent from SSH</small></li>
            <li style="padding: 7px"><span style="font-size: 12px; color:#eee">screen -fa -dmS irssi irssi</span><br/>
            <small>allows user to restart/remount irssi from SSH</small></li>
          </ul>
          <div class="sidebar-btn-wrapper">
            <a href="#" class="btn btn-success btn-block" style="font-size: 10px;">Quick Box v<?php echo "$version"; ?></a>
          </div>
        </div><!-- tab-pane -->
      </div><!-- tab-content -->
    </div><!-- leftpanelinner -->
  </div><!-- leftpanel -->
  <div class="mainpanel">
    <!--<div class="pageheader">
      <h2><i class="fa fa-home"></i> Dashboard</h2>
    </div>-->
    <div class="contentpanel">
      <div class="row">
        <div class="col-sm-12 col-md-8 dash-left">
          <div class="col-sm-12 col-md-7">
            <div class="panel panel-default list-announcement">
              <div class="panel-heading">
                <h4 class="panel-title">Service Status</h4>
              </div>
              <div class="panel-body">
                <ul class="list-unstyled mb20">
                  <li>
                    <?php echo "$rval"; ?>
                  </li>
                  <li>
                    <?php echo "$ival"; ?>
                  </li>
                  <li>
                    <?php echo "$bval"; ?>
                  </li>
                  <li>
                    <?php echo "$pval"; ?>
                  </li>
                </ul>
              </div>
              <div class="panel-footer"></div>
            </div>
          </div>
          <div class="col-sm-12 col-md-5">
            <div class="panel panel-default list-announcement">
              <div class="panel-heading">
                <h4 class="panel-title">Service Controller</h4>
              </div>
              <div class="panel-body">
                <ul class="list-unstyled mb20">
                  <li>
                    <?php echo "$cbodyr"; ?>
                  </li>
                  <li>
                    <?php echo "$cbodyi"; ?>
                  </li>
                  <li>
                    <?php echo "$cbodyb"; ?>
                  </li>
                  <li>
                    <?php echo "$cbodyp"; ?>
                  </li>
                </ul>
              </div>
              <div class="panel-footer"></div>
            </div>
          </div>
        </div><!-- col-md-8 -->
        <div class="col-sm-12 col-md-4 dash-right">
          <div class="row">
            <div class="col-sm-12">
              <div class="panel panel-danger panel-weather">
                <div class="panel-heading">
                  <h4 class="panel-title">System Response</h4>
                </div>
                <div class="panel-body inverse">
                  <?php
                  $output = readMsg();
                  if (isset($output)) {
                      $data = $output;
                      //unlink('servermessage');
                      echo $data;
                  } else {
                      echo "<br>";
                  }
                  ?>
                </div>
              </div>
            </div><!-- col-sm-12 -->
          </div><!-- row -->
        </div><!-- col-md-4 -->
      </div><!-- row -->
      <div class="row">
        <div class="col-sm-12 col-md-8">
          <div class="panel panel-inverse">
            <div class="panel-heading">
              <h4 class="panel-title">Bandwidth Data</h4>
            </div>
            <div class="panel-body text-center">
              <div id="placeholder" style="width:100%;height:200px;"></div> 
            </div>
            <div class="row panel-footer panel-statistics mt10">
              <div class="col-sm-6">
                <div class="panel panel-success-full panel-updates">
                  <div class="panel-body">
                    <div class="row">
                      <div class="col-sm-7 col-md-8">
                        <h4 class="panel-title text-success">Data Sent</h4>
                        <h3><div id="snd_result"></div></h3>
                        <p>This is your upload speed</p>
                      </div>
                      <div class="col-sm-5 col-md-4 text-right">
                        <i class="fa fa-cloud-upload" style="font-size: 90px"></i>
                      </div>
                    </div>
                  </div>
                </div><!-- panel -->
              </div><!-- col-sm-6 -->
              <div class="col-sm-6">
                <div class="panel panel-primary-full panel-updates">
                  <div class="panel-body">
                    <div class="row">
                      <div class="col-sm-7 col-md-8">
                        <h4 class="panel-title text-success">Data Received</h4>
                        <h3><div id="rec_result"></div></h3>
                        <p style="color: #fff">This is your download speed</p>
                      </div>
                      <div class="col-sm-5 col-md-4 text-right">
                        <i class="fa fa-cloud-download" style="font-size: 90px"></i>
                      </div>
                    </div>
                  </div>
                </div><!-- panel -->
              </div><!-- col-sm-6 -->
              <div id="bw_tables" style="padding:0;margin:0;"></div>
            </div>
          </div>
        </div>
        <div class="col-sm-12 col-md-4 dash-right">
          <div class="row">
            <div id="disk_data"></div>
            <div class="col-sm-12">
              <div class="panel panel-inverse-full panel-updates">
                  <div class="panel-body">
                    <div class="row">
                      <div class="col-sm-9">
                        <h4 class="panel-title text-success">Server Load</h4>
                        <h3><span id="cpuload"></span></h3>
                        <p>This is your servers current load average</p>
                      </div>
                      <div class="col-sm-3 text-right">
                        <i class="fa fa-heartbeat text-danger" style="font-size: 90px"></i>
                      </div>
                      <div class="row">
                        <div class="col-sm-12 mt20 text-center">
                          <strong>Uptime:</strong> <span id="uptime"></span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div><!-- panel -->
              </div>
          </div><!-- row -->
        </div>
      </div>
    </div><!-- contentpanel -->
  </div><!-- mainpanel -->
</section>
<!--script src="js/graph.js"></script-->
<script src="js/script.js"></script>
<script src="lib/jquery-ui/jquery-ui.js"></script>
<script src="lib/bootstrap/js/bootstrap.js"></script>
<script src="lib/jquery-toggles/toggles.js"></script>
<script src="lib/jquery-knob/jquery.knob.js"></script>
<script src="js/quick.js"></script>
<!--script src="js/charts.js"></script--> 
<script>
$(function() {
  // Toggles
  $('.toggle-en').toggles({
    on: true,
    height: 26
  });
  $('.toggle-dis').toggles({
    on: false,
    height: 26
  });
});
</script>
</body>
</html>
<?php session_destroy(); ?>