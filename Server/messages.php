<?php
require("header.php");
if($_GET['list']==1) {
if(file_exists("cache/messages_".$_GET['name'].".dat")==false or $_GET['newcache']==1 or $_GET['unread']==1 or isset($_GET['limit'])) {
$qt="SELECT `id`, `sender`, `receiver`, `subject`, `date`, `read`, `marked`, `attachments` FROM `messages` where ((receiver='" . $_GET['name'] . "' and deletedfromreceived!=1) or (sender='" . $_GET['name'] . "' and deletedfromsent!=1)) ";
if($_GET['unread']==1)
$qt.="and (`read` is null or `read`=0)";
$qt.="order by id desc";
$q=mquery($qt);
$text = mysql_num_rows($q);
$limit=(int) $_GET['limit'];
$count=0;
while ($r = mysql_fetch_row($q)) {
++$count;
$read=(int)$r[5];
if($read>0) $read=1;
$text .= "\r\n".$r[0]."\r\n".$r[1]."\r\n".$r[2]."\r\n".$r[3]."\r\n".$r[4]."\r\n".$read."\r\n".((int) $r[6])."\r\n".$r[7];
if($limit<=$count and $limit>0)
break;
}
if($_GET['unread']!=1 and isset($_GET['limit'])==false) {
$fp=fopen("cache/messages_".$_GET['name'].".dat","w");
fwrite($fp,$text);
fclose($fp);
}
echo "0\r\n" . $text;
}
else {
echo "0\r\n".file_get_contents("cache/messages_".$_GET['name'].".dat");
}
}
if($_GET['read']==1) {
$q=mquery("SELECT `id`, `sender`, `receiver`, `subject`, `date`, `read`, `marked`, `attachments`, `message` FROM `messages` where (sender='".$_GET['name']."' or receiver='".$_GET['name']."') and id=".((int) $_GET['id']));
if(mysql_num_rows($q)==0)
die("-3");
mquery("UPDATE `messages` SET `read`=".Time()." WHERE `id`='".(int)$_GET['id']."' and receiver='".$_GET['name']."'");
$r=mysql_fetch_row($q);
if(($r[5]==0 or $r[5]==null) and file_exists("cache/messages_".$_GET['name'].".dat")) unlink("cache/messages_".$_GET['name'].".dat");
echo "0\r\n".$r[0]."\r\n".$r[1]."\r\n".$r[2]."\r\n".$r[3]."\r\n".$r[4]."\r\n".((int) $r[5])."\r\n".((int) $r[6])."\r\n".((int) $r[7])."\r\n".$r[8];
}
if($_GET['search']==1) {
$q=mquery("select id from messages where receiver='".$_GET['name']."' and deletedfromreceived!=1 and upper(message) like upper('%".mysql_real_escape_string($_GET['query'])."%')");
$text="";
while($r=mysql_fetch_row($q))
$text.="\r\n".$r[0];
echo "0".$text;
}
if($_GET['delete']==1) {
if(file_exists("cache/messages_".$_GET['name'].".dat")) unlink("cache/messages_".$_GET['name'].".dat");
mquery("update messages set deletedfromreceived=1 where id=".((int) $_GET['id'])." and receiver='".$_GET['name']."'");
mquery("update messages set deletedfromsent=1 where id=".((int) $_GET['id'])." and sender='".$_GET['name']."'");
echo "0";
}
if($_GET['mark']==1) {
if(file_exists("cache/messages_".$_GET['name'].".dat")) unlink("cache/messages_".$_GET['name'].".dat");
mquery("update messages set marked=1 where id=".((int) $_GET['id'])." and receiver='".$_GET['name']."'");
echo "0";
}
if($_GET['unmark']==1) {
if(file_exists("cache/messages_".$_GET['name'].".dat")) unlink("cache/messages_".$_GET['name'].".dat");
mquery("update messages set marked=0 where id=".((int) $_GET['id'])." and receiver='".$_GET['name']."'");
echo "0";
}
?>