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
		
		$getbans = mysqli_query($con,"SELECT * FROM blacklist") or die('Error: ' . mysqli_error($con)); 
		$bannum  = mysqli_num_rows($getbans);
	}
}
else
{
	header("location:login.php");
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
          <a type="button" class="btn btn-success btn-sm" href="char.php">Changer de Personnage</a>
        </div>
        <!-- END SIDEBAR BUTTONS -->
        <!-- SIDEBAR MENU -->
        <?php include_once("includes/menu.php"); ?>
        <!-- END MENU -->
      </div>
    </div>
  <div class="col-md-9">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-ban-circle" aria-hidden="true"></span> Bans (<?php echo $bannum?>)</h3></div>
      <div class="panel-body">
	  
	  <?php if($statsmatch == 1 && $rowstats["Admin"] >= 0){
			  echo'
	       
	<div class="row-fluid">
		<div class="span12">
			<table class="table table-striped table-advance table-hover">
                           <tbody>
                              <tr>
                                 <th><i class="icon_folder-open"></i> IP</th>
                                 <th><i class="icon_tag"></i> Name</th>
								 <th><i class="icon_tag"></i> Banned By</th>
								 <th><i class="icon_tag"></i> Reason</th>
                                 <th><i class="icon_calendar"></i> Date</th>
								 <th><i class="icon_cogs"></i> Action</th>
                              </tr>
							 ';
							 
								while($rowban = mysqli_fetch_array($getbans))
								{
								$deletemsg = "Are you sure, you want to delete?";
								//$content = mb_strimwidth($row["news_desc"],0,55, "...");
							echo'
                              <tr>
                                 <td>'.$rowban["IP"].'</td>
                                 <td>'.$rowban["Username"].'</td>
                                 <td>'.$rowban["BannedBy"].'</td>
								 <td>'.$rowban["Reason"].'</td>
								 <td>'.$rowban["Date"].'</td>
                                 <td>
                                  <div class="btn-group">
                                      <a class="btn btn-danger" href="deleteban.php?char='.$char.'&nid='.$rowban["Username"].'" onclick ="return confirm (\'Are You Sure You Want To Delete This Ban?\')"><i class="icon_close_alt2"></i></a>
                                  </div>
                                  </td>
                              </tr>	';
								}
							echo'	                            
                           </tbody>
                        </table>
</div>'; }
		  else
		  {
			  header("location:dashboard.php");
		  }?>
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

<link href="css/tstyle.css" rel="stylesheet" />
<link href="css/styles3.css" rel="stylesheet" />
	<link href="./css/elegant-icons-style.css" rel="stylesheet" />
	
</body></html>
<?php
if ($_SERVER['REQUEST_METHOD']=='POST')
{
	$nname = mysqli_real_escape_string($con, $_POST['nname']);
	$ndesc = mysqli_real_escape_string($con, $_POST['ndesc']);
	$nby = mysqli_real_escape_string($con, $_POST['nby']);
	//$content = $_POST['content'];
	
	mysqli_query($con,"INSERT INTO `news` (`news_name`, `news_desc`, `news_postedby`) VALUES ('".$nname."', '".$ndesc."',  '".$nby."');")or die('Error: ' . mysqli_error($con));
	
	$char = mysqli_real_escape_string($con, $_GET['char']); // Set id variable 
	header("location:news.php?char=".$char."");
	
}
?>