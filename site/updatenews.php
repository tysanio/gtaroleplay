<?php session_start() ?>
<?php ob_start();
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
		
		if(isset($_GET['char']) && !empty($_GET['char']) && isset($_GET['nid']) && !empty($_GET['nid'])){
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
		
		$nid = mysqli_real_escape_string($con, $_GET['nid']);
		$search = mysqli_query($con,"SELECT * FROM `news` where news_id = '".$nid."'") or die('Error: ' . mysqli_error($con)); 
		$match  = mysqli_num_rows($search);
		$rownews = mysqli_fetch_array($search);
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

?>
<!DOCTYPE html>
<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Inner City Roleplay  - User control panel</title>
  
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
			<a class="navbar-brand" href="index.php">Home</a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="logout.php"><i class="glyphicon glyphicon-lock"></i> Log out</a></li>
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
            Welcome back!
          </div>
        </div>
        <!-- END SIDEBAR USER TITLE -->
        <!-- SIDEBAR BUTTONS -->
        <div class="profile-userbuttons">
          <a type="button" class="btn btn-success btn-sm" href="char.php">Change character</a>
        </div>
        <!-- END SIDEBAR BUTTONS -->
        <!-- SIDEBAR MENU -->
        <?php include_once("includes/menu.php"); ?>
        <!-- END MENU -->
      </div>
    </div>
  <div class="col-md-9">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-file" aria-hidden="true"></span>News</h3></div>
      <div class="panel-body">
	  <?php if($statsmatch == 1 && $rowstats["Admin"] >= 5 && $match > 0){
			  echo'
	<div class="row-fluid">
		<div class="span12">
			<form action="" method="post">
                    <div class="panel-body">
					<div class="fieldpassword">
					<label for="nname">News Name:</label><br>
					<label>
					<input class="citizen2" type="text" id="nname" name="nname" value="'.$rownews["news_name"].'"><br>
					</label>
					<br>
					<label for="ndesc">News Desc:</label><br>
					<label>
					<textarea class="ckeditor" id="ndesc" name="ndesc" cols="30" rows="10"> '.$rownews["news_desc"].' </textarea><br>
					</label>
					<br>
					<label for="nby">Posted By:</label><br>
					<label>	 
					<input class="citizen2" type="text" id="nby" name="nby" value="'.$rownews["news_postedby"].'"><br>
					</label>
					<br>
					<center><input class="submitcitizen2" type="submit" value="Update"></center>
					</div>
						
						
                    </div>
			
		</form>	
		</div>';
		}
		else
		{
			header("location:dashboard.php");
		}?>
		
			
             <?php
if ($_SERVER['REQUEST_METHOD']=='POST')
{
	$nname = mysqli_real_escape_string($con, $_POST['nname']);
	$ndesc = mysqli_real_escape_string($con, $_POST['ndesc']);
	$nby = mysqli_real_escape_string($con, $_POST['nby']);
	//$content = $_POST['content'];
	
	mysqli_query($con,"update news set news_name='$nname',news_desc='$ndesc',news_postedby='$nby' where news_id=$nid")or die('Error: ' . mysqli_error($con));
	
	$char = mysqli_real_escape_string($con, $_GET['char']); // Set id variable 
	header("location:news.php?char=".$char."");
	
}
?>
	  
	</div>
  </div>
  </div>
  

      
    
  

<nav class="navbar navbar-default navbar-fixed-bottom footer">
  <div class="container">
   	Inner City Roleplay  - Copyright © 2016
  </div>
</nav>

<style>
.navbar-inverse .navbar-brand{
	color:#428BCA; !important
}
body{
	background-color:lightyellow;
}
.profile-sidebar{
	border-style: solid;
    border-width: 1px;
	border-color: #ddd;
}
</style>

<link href="css/tstyle.css" rel="stylesheet" />
<link href="css/styles3.css" rel="stylesheet" />
	<link href="./css/elegant-icons-style.css" rel="stylesheet" />
	<script language="javascript" type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script language="javascript" type="text/javascript" src="ckeditor/config.js"></script>
	
</body></html>