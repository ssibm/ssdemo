Server(Pod) Name: <?php echo gethostname() ?><br>
Server(Pod) IP: <?php echo getHostByName(getHostName()) ?><br>
Source IP:<?php echo $_SERVER['REMOTE_ADDR']?><br>
Headers:<br>
<?php
foreach($_SERVER as $key=>$val){
if (preg_match('/^HTTP_/', $key)) {
  echo $key . ': ' . $val . '<br>';
}
}
?>
