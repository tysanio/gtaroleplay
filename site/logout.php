<?php session_start() ?>
<?php

	//setcookie("id",10,time()-1);
	session_destroy();
	//unset($_SESSION["id"]);
 	header("location:login.php");	


?>