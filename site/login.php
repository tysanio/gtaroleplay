<?php session_start() ?>
<?php
include("config.php");
if(isset($_SESSION["ID"])|| !empty($_SESSION["ID"]) AND isset($_SESSION["Key"])|| !empty($_SESSION["Key"]))
{
	$con=mysqli_connect(server, user, password, db) or die(mysqli_error());
	$id = mysqli_real_escape_string($con, $_SESSION["ID"]);
	$key = mysqli_real_escape_string($con, $_SESSION["Key"]);
	
	$checkkey = mysqli_query($con,"SELECT Username FROM accounts where ID = '".$id."' AND Password = '".$key."'") or die(mysqli_error());
	$check = mysqli_num_rows($checkkey);
	if($check < 1){
		session_destroy();
	}
	else
	{
		header("location:dashboard.php");
	}
}
	
	
if ($_SERVER['REQUEST_METHOD']=='POST')
{
		$con=mysqli_connect(server, user, password, db) or die(mysqli_error());
		$username = mysqli_real_escape_string($con, $_POST['name']);
		$password = mysqli_real_escape_string($con, $_POST['password']);
		$hpassword	= hash('md5',$password);
	
		$search = mysqli_query($con,"SELECT * FROM accounts WHERE Username='".$username."' AND Password='".$hpassword."'") or die('Error: ' . mysqli_error($con)); 
		$match  = mysqli_num_rows($search);
		$row = mysqli_fetch_array($search);
			if($match > 0)
			{
				$_SESSION["ID"]=$row["ID"];
				$_SESSION["Key"]=$row["Password"];
				header("location:char.php");
			}
				else
				{
					$msg = 'pseudo ou mots de pass incorrect.';
				}
	}
	else
		{
			//Nothing
		}
?>

<!DOCTYPE html>
<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Royal Roleplay - UCP</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="css/bootstrap/bootstrap.min.css">
  <script src="js/bootstrap/jquery.min.js"></script>
  <!-- <script type="text/javascript" charset="UTF-8" ch_loader="undefined">window._ext_ldr_ch_loader=true;</script><script type="text/javascript" charset="UTF-8" ch_loader="dppm_id.js">window.dppm_extensions = window.dppm_extensions || {}; window.dppm_extensions['ch_loader']=true;</script> -->
  <script src="js/bootstrap/bootstrap.min.js"></script>
  <script src="js/bootstrap/jquery-ui.min.js"></script>
  <!-- <script src="js/bootstrap/login.js"></script> -->
  <link href="css/bootstrap/loginpage.css" rel="stylesheet" media="screen">
<script type="text/javascript" charset="UTF-8" src="chrome-extension://iggdmkkkjkjbmomhnaaglcjdmfmamkca/scripts/mcsh-loader.js" ch_loader="mcsh-loader.js"></script></head>
<body id="loginPage" class=" dp-frs cf-pricer dp-rtr-ch_loader dp-cu-ch_loader prcr_not_show">

<div class="container">
  <div class="card card-container">

    <center><a href="#"><img id="profile-img" src="css/bootstrap/img/logo.png"></center> </a>
    <p id="profile-name" class="profile-name-card"></p>
      <form method="post" action="" class="form-signin" accept-charset="UTF-8" id="login-form">
        <input type="name" id="inputName" name="name" class="form-control" placeholder="Username" required="" autofocus="">
        <input type="password" id="inputPassword" name="password" class="form-control" placeholder="Password" required="">
        <div id="remember" class="checkbox">
        <label>
          <input type="checkbox" value="remember-me"> Se souvenir de moi !
        </label>
        </div>
        <input type="submit" class="btn btn-lg btn-primary btn-block btn-signin" value="Connexion" />
        <div id="resultDiv">
		<?php 
			if(isset($msg)){  // Check if $msg is not empty
				echo '<div style="color:red;">'.$msg.'</div>'; // Display our message and wrap it with a div with the class "statusmsg".
			}
		?>
		</div>
      </form><!-- /form -->

  </div><!-- /card-container -->
</div>

</body></html>