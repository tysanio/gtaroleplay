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
		$checkhouses = mysqli_query($con,"SELECT * FROM houses where houseOwner = '".$rowstats["ID"]."'") or die(mysqli_error($con));
		$house = mysqli_num_rows($checkhouses);
		
		$checkbizs = mysqli_query($con,"SELECT * FROM businesses where bizOwner = '".$rowstats["ID"]."'") or die(mysqli_error($con));
		$biz = mysqli_num_rows($checkbizs);
		
		$checkcars = mysqli_query($con,"SELECT * FROM cars where carOwner = '".$rowstats["ID"]."'") or die(mysqli_error($con));
		$cars = mysqli_num_rows($checkcars);
}
else
{
	header("location:login.php");
}
?>
<!DOCTYPE html>
<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Royal Roleplay - UCP</title>
  
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <script src="js/jquery.min2.js"></script>
  <script src="js/bootstrap.min2.js"></script>
  <script src="js/change.js"></script>
  <link href="css/main.css" rel="stylesheet" media="screen">
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
  <div class="col-md-3">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>  Information General</h3></div>
      <div class="panel-body">
        <br><h4>Nom du Personnage</h4><?php echo clean($rowstats["Character"]);?> <br><br><h4>Date de naissance</h4><?php echo $rowstats["Birthdate"];?><br><br><h4>Sexe</h4><?php switch ($rowstats["Gender"]) {
			case 1: echo "Homme"; break;
			case 2: echo "Femme";break;} ?><br><hr><h4>Argent</h4> <?php echo $rowstats["Money"];?> $<br><br><h4>Argent en banque</h4><?php echo $rowstats["BankMoney"];?> $<br><br><h4>Numero de telephone</h4><?php echo $rowstats["Phone"];?>      </div>
    </div>
  </div>

  <div class="col-md-3">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-user" aria-hidden="true"></span> <?php echo clean($rowstats["Character"]) ?></h3></div>
      <div class="panel-body">
        <?php echo'<br><img src="img/bskin/'.$rowstats["Skin"].'.png" class="img-responsive" style="margin: 0 auto; height=" 26.5%""="" width="26.5%" "=""><br><br><hr>Vie:<br><div class="progress"> <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="" aria-valuemin="0" aria-valuemax="100" style="width:'.$rowstats["Health"].'%"><span>'.$rowstats["Health"].'</span></div></div><br>Armure:<br><div class="progress"> <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" aria-valuenow="" aria-valuemin="0" aria-valuemax="100" style="width:'.$rowstats["ArmorStatus"].'%"><span>'.$rowstats["ArmorStatus"].'</span></div></div><br>      </div>';?>
    </div>
  </div>
  

  <div class="col-md-3">
    <div class="panel panel-default">
      <div class="panel-heading"><h3><span class="glyphicon glyphicon-home" aria-hidden="true"></span>  Proprieter</h3></div>
      <div class="panel-body">
        <!--<div class="panel panel-success">
          <div class="panel-heading"><h4 style="margin: 0px;">Inventory items</h4> (up to 10 items displayed)</div>
          <div class="panel-body">
          Cooked Chicken Nuggets          </div>
          </div>-->
		<?php
			if($house < 1)
			{	
				echo'
			  <div class="panel panel-success">
			  <div class="panel-heading"><h4 style="margin: 0px;">Maison</h4></div>
			  <div class="panel-body">
			  Tu as aucune maison !          </div>
			  </div>';
			}
			else
			{	
			  $rowhouse = mysqli_fetch_array($checkhouses);
			  if($rowhouse["houseLocked"] == 1)
			  {
				  $locked = "<b><p style='color:green'>Fermer</p></b>";
			  }
			  else
			  {
				  $locked = "<b><p style='color:red'>Ouvert</p></b>";
			  }
				echo'
			  <div class="panel panel-success">
			  <div class="panel-heading"><h4 style="margin: 0px;">Maison</h4></div>
			  <div class="panel-body">
			  Maison ID:<b> '.$rowhouse["houseID"].'</b>
			  <br />'.$locked.'</div>
			  </div>';
				
			}
		  
		  ?>
		  <?php
			if($biz < 1)
			{	
				echo'
			  <div class="panel panel-success">
			  <div class="panel-heading"><h4 style="margin: 0px;">Magasin</h4></div>
			  <div class="panel-body">
			  Tu as aucun magasin !          </div>
			  </div>';
			}
			else
			{	
			  $rowbiz = mysqli_fetch_array($checkbizs);
			  if($rowbiz["bizLocked"] == 1)
			  {
				  $locked = "<b><p style='color:green'>Fermer</p></b>";
			  }
			  else
			  {
				  $locked = "<b><p style='color:red'>Ouvert</p></b>";
			  }
				echo'
			  <div class="panel panel-success">
			  <div class="panel-heading"><h4 style="margin: 0px;">Magasin</h4></div>
			  <div class="panel-body">
			  Magasin ID:<b> '.$rowbiz["bizID"].'<br /></b><br />
			  Nom du Magasin: <br /><b> '.$rowbiz["bizName"].'<br /></b>
			  <b> <br />'.$locked.' </b></div>
			  </div>';
				
			}
		  ?>
		  <style>
		  .vehicle{
			  width:25%;height:25%;margin:10px;
		  }
		  </style>
		  <?php
		  //$cars = 0;
		  if($cars < 1){
			  
			echo'
          <div class="panel panel-success">
          <div class="panel-heading"><h4 style="margin: 0px;">Vehicules</h4></div>
          <div class="panel-body" style="text-align:middle;">
          Tu as aucun vehicule !          </div>
          </div>';
		  }
		  else
		  {
				include("includes/vehname.php");
			  echo'<div class="panel panel-success">
			  <div class="panel-heading"><h4 style="margin: 0px;">Vehicules</h4></div>
			  <div class="panel-body" style="text-align:middle;">';
			  $i = 1;
			  while($rowcar = mysqli_fetch_array($checkcars))
			  {
				 // echo'<p style="text-transform: capitalize;"> Vehicle <strong>#'.$i.':</strong> (<strong>'.$VehicleName[$rowcar["Model"]].'</strong>)<br /></p>';http://weedarr.wdfiles.com/local--files/veh/400.png
				 
				 echo'<img class="vehicle" src="img/veh/'.$rowcar["carModel"].'.png" title="'.$VehicleName[$rowcar["carModel"]].'"
				 alt="'.$VehicleName[$rowcar["carModel"]].'"/>';
				  $i++;
				  if($i == 4){echo '<br/>
				  <style>
		  .vehicle{
			  width:25%;height:25%;margin:0px 10px; !important
		  }
		  </style>';}
			  }
			  echo '</div>
          </div>';
		  }
		  
		  ?>
        </div>
        </div>
        </div>

      
    
  

<nav class="navbar navbar-default navbar-fixed-bottom footer">
  <div class="container">
   	Royal Roleplay - Copyright © 2018
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