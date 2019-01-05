<?php session_start() ?>
<?php
include("config.php");
if(isset($_SESSION["ID"])|| !empty($_SESSION["ID"]) AND isset($_SESSION["Key"])|| !empty($_SESSION["Key"]))
{
	$con=mysqli_connect(server, user, password, db) or die(mysqli_error($con));
	$id = mysqli_real_escape_string($con, $_SESSION["ID"]);
	$key = mysqli_real_escape_string($con, $_SESSION["Key"]);
	
	$checkkey = mysqli_query($con,"SELECT * FROM accounts where ID = '".$id."' AND Password = '".$key."'") or die(mysqli_error($con));
	$check = mysqli_num_rows($checkkey);
	$row = mysqli_fetch_array($checkkey);
	
	$user = $row["Username"];
	if($check < 1){
		session_destroy();
		header("location:login.php");
	}
	else
	{
		
		if(isset($_GET['char']) && !empty($_GET['char'])){
			$con=mysqli_connect(server, user, password, db) or die(mysqli_error());
			$char = mysqli_real_escape_string($con, $_GET['char']); // Set id variable          
			$getstats = mysqli_query($con,"SELECT * FROM `characters` WHERE `Character` = '".$char."' AND `Username` = '".$user."'") or die('Error: ' . mysqli_error($con));
			$statsmatch  = mysqli_num_rows($getstats);
			$rowstats = mysqli_fetch_array($getstats);
				if($statsmatch > 0){
					$statmatch = 1;
					$user = $rowstats["Username"];
					}else{
				$statsmatch = 0;
				}               
		}else{
		$statsmatch = 0;
		}
		
		if($statsmatch == 0)
		{
			header("location:char.php");
		}	
	}
}
else
{
	header("location:login.php");
}
	if(isset($_POST['submitskin'])) {
		$skin = mysqli_real_escape_string($con, $_POST['skinid']);
		$update = mysqli_query($con,"UPDATE `characters` SET Skin='".$skin."' WHERE `Character`='".$char."'") or die('Error: ' . mysqli_error($con)); 
		$skinmsg = "<p style='color:green;'> Your skin has been changed successfully.</p>";
		echo'<meta http-equiv="refresh" content="3">';
	}
	
	if(isset($_POST['submitpw'])) {
	
	$oldpw = mysqli_real_escape_string($con, $_POST['opw']);
	$pw = mysqli_real_escape_string($con, $_POST['pw']);
	$cpw = mysqli_real_escape_string($con, $_POST['cpw']);
	$hopw = hash('whirlpool',$oldpw);
	$hpw = hash('whirlpool',$pw);
	
	$search = mysqli_query($con,"SELECT * FROM accounts WHERE Username='".$user."' AND Password='".$hopw."'") or die('Error: ' . mysqli_error($con)); 
	$match  = mysqli_num_rows($search);
	
	if($match > 0)
	{
		if($pw == $cpw)
		{
			$update = mysqli_query($con,"UPDATE accounts SET Password = '".$hpw."' WHERE Username='".$user."'") or die('Error: ' . mysqli_error($con)); 
			$msg = "<br /><p style='color:green;'> Your password has been changed successfully. </p>";
		}
		else
		{
			$msg = "<br /><p style='color:red;'> Passwords don't match. </p>";
		}
	}
	else
	{
		$msg = "<br /><p style='color:red;'> Current password is incorrect. </p>";
	}
	//$row = mysqli_fetch_array($search);
}

?>
<!DOCTYPE html>
<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Royal Roleplay  - UCP</title>
  
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <script src="js/jquery.min2.js"></script>
  <script src="js/bootstrap.min2.js"></script>
  <script src="js/change.js"></script>
  <link href="css/main2.css" rel="stylesheet" media="screen">
  <!--<link href="css/css.css" rel="stylesheet" type="text/css">-->
</head>
<body>


<div id="top-nav" class="navbar navbar-inverse navbar-static-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
			<a class="navbar-brand" href="index.php">Accueil</a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="logout.php"><i class="glyphicon glyphicon-lock"></i> Deconnexion</a></li>
            </ul>
        </div>
    </div>
    <!-- /container -->
</div>



<div class="container-fluid"></div>


  
      <div class="col-md-2" style="padding-left: 10px;">
        <div class="profile-sidebar">
        <!-- SIDEBAR USERPIC -->
        <div class="profile-userpic">
          <img src="img/100skin/<?php echo $rowstats["Skin"];?>.png" class="img-responsive" alt="">        </div>
        <!-- END SIDEBAR USERPIC -->
        <!-- SIDEBAR USER TITLE -->
        <div class="profile-usertitle">
          <div class="profile-usertitle-name">
            <?php echo clean($rowstats["Username"]);?>          </div>
          <div class="profile-usertitle-job">
            Bienvenue !
          </div>
        </div>
        <!-- END SIDEBAR USER TITLE -->
        <!-- SIDEBAR BUTTONS -->
        <div class="profile-userbuttons">
          <a type="button" class="btn btn-success btn-sm" href="char.php">Changer de personnage</a>
        </div>
        <!-- END SIDEBAR BUTTONS -->
        <!-- SIDEBAR MENU -->
        <?php include_once("includes/menu.php"); ?>
        <!-- END MENU -->
      </div>
    </div>
  <div class="col-md-5">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-cog" aria-hidden="true"></span>  Change de MDP</h3></div>
      <div class="panel-body">
		  <form action='' method='post'>
		  
			<div class="form-group col-xs-12" style="text-align:center;">
			  <label for="opw">MDP Actuel:</label>
			  <input type="password" class="form-control" name="opw" required>
			  <br />
			</div>
			<div class="form-group col-xs-12">
			  <label for="pw">Nouveau MDP:</label>
			  <input type="password" class="form-control" name="pw" required>
			  <br />
			</div>
			<div class="form-group col-xs-12">
			  <label for="cpw">Confirmer Nouveau MDP:</label>
			  <input type="password" class="form-control" name="cpw" required>
			  <br />
			</div>
			<button type="submit" name="submitpw" id="submitpw" class="btn btn-primary">Envoyer</button>
			
			<?php if(isset($msg) && !empty($msg))
			{
				echo $msg;
			}?>
			
		  </form>
    </div>
  </div>
  </div>
  
    <div class="col-md-4">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-user" aria-hidden="true"></span>  Changer de Skin</h3></div>
      <div class="panel-body">
		  <form action='' method='post'>
			<div class="form-group col-xs-7">
			  <label for="skinid">Skin ID:</label>
			  <input class="form-control" name="skinid" type="number" maxlength="3" min="1" max="299" pattern="([0-9]|[0-9]|[0-9])" id="skinid">
			  <br />
			  <br />
			  <button type="submit" name="submitskin" id="submitskin" class="btn btn-primary">Envoyer</button>
			  <?php if(isset($skinmsg) && !empty($skinmsg))
			{
				echo $skinmsg;
			}?>
			</div>
			<div class="col-md-5">
			<label> Skin Preview:</label>
			<br />
			<img src="img/bskin/<?php echo $rowstats["Skin"];?>.png" style="height:290px;" alt="">
			</div>
		  </form>
    </div>
  </div>
  </div>

      
    
  

<nav class="navbar navbar-default navbar-fixed-bottom footer">
  <div class="container">
   	Royal Roleplay  - Copyright © 2018
  </div>
</nav>

<style>
.navbar-inverse .navbar-brand{
	color:#428BCA; !important
}
body{
	background-color:lightblue;
}
.profile-sidebar{
	border-style: solid;
    border-width: 1px;
	border-color: #ddd;
}
</style>

</body></html>