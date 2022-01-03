<?php 

function getSalt() {
    #$charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/\\][{}\'";:?.>,<!@#$%^&*()-_=+|';
    #$charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/\\][{}\'";:?.>,<!@#%^&*()-_=+|';
    $charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/=+';
    $randStringLen = 16;

    $randString = "";
    for ($i = 0; $i < $randStringLen; $i++) {
        $randString .= $charset[mt_rand(0, strlen($charset) - 1)];
    }

    return $randString;
}

#var_dump($argv);
#nOsgGCKqIEZx1rbO
#mfJ0Eq3rIDLKG33r
#$username="manager";
#$password="wavesnake";

$username=$argv[1];
$password=$argv[2];
$type=$argv[3];

$salt_base64="nOsgGCKqIEZx1rbO";
#$salt_base64="mOsgGCKqIEZx1rbO";
#$salt_base64=getSalt(); !OBS we have to get thiw working
#echo("Saltx".$saltx_base64);
$salt=base64_decode($salt_base64);
$hash=hash("sha512",$password.$salt, true);
$hash_base64=base64_encode($hash);
if($type=="MQTT")
{
    echo($username.":$6$".$salt_base64."$".$hash_base64."\n");
} else
{
    echo("$6$".$salt_base64."$".$hash_base64."\n");
}

?>
