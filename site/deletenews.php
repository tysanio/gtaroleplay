<?php session_start() ?>
<?php ob_start();
include("config.php");
if(isset($_SESSION["ID"])|| !empty($_SESSION["ID"]) AND isset($_SESSION["Key"])|| !empty($_SESSION["Key"]))
{
	$con=mysqli_connect(server, user, password, db) or die(mysqli_error());
	$id = mysqli_real_escape_string($con, $_SESSION["ID"]);
	$key = mysqli_real_escape_string($con, $_SESSION["Key"]);
	$checkkey = mysqli_query($con,"SELECT Username FROM accounts where ID = '".$id."' AND Password = '".$key."'") or die(mysqli_error());
	$check = mysqli_num_rows($checkkey);
	$rowcheck = mysqli_fetch_array($checkkey);
	if($check < 1){
		session_destroy();
		header("location:login.php");
	}
	else{
		$user = $rowcheck["Username"];
		/*
		$getstats = mysqli_query($con,"SELECT Level, Money, BankMoney, Job, Origin, Gender, House, Business, PlayingHours, Admin, Tester, DonationPoints, Donator FROM characters where Username = '".$id."'") or die(mysqli_error());
		$row = mysqli_fetch_array($getstats);*/
	}
}
else
{
	header("location:login.php");
}

if(isset($_GET['nid']) && !empty($_GET['nid']) AND isset($_GET['char']) || !empty($_GET['char'])){
    $con=mysqli_connect(server, user, password, db) or die(mysqli_error());
	$char = mysqli_real_escape_string($con, $_GET['char']); // Set id variable          
	$getstats = mysqli_query($con,"SELECT * FROM `characters` WHERE `Character` = '".$char."' AND `Username` = '".$user."'") or die('Error: ' . mysqli_error($con));
	$statsmatch  = mysqli_num_rows($getstats);
	$rowstats = mysqli_fetch_array($getstats);
	$adminz = $rowstats["Admin"];
		if($statsmatch > 0){
			}else{
			header("location:dashboard.php");
			} 
	// Verify data
    $nid = mysqli_real_escape_string($con, $_GET['nid']); // Set id variable          
    $search = mysqli_query($con,"SELECT * FROM `news` where news_id = '".$nid."'") or die('Error: ' . mysqli_error($con)); 
    $match  = mysqli_num_rows($search);
       if($match > 0){
        $match = 1;
    }else{
        // No match -> invalid url or account has already been activated.
        $match = 0;
    }
                  
}else{
    // Invalid approach
    $match = 0;
}

?>

		<?php if($match > 0 AND $adminz >= 4)
		{
				$delete = mysqli_query($con,"DELETE FROM `news` WHERE news_id = ".$nid."") or die('Error: ' . mysqli_error($con));
				// Set id variable 
				header("location:news.php?char=".$char."");
		}
		
		else
		{
		header("location:dashboard.php");
	}?>