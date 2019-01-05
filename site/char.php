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
	
	$rowcheck = mysqli_fetch_array($checkkey);
	if($check < 1){
		session_destroy();
		header("location:login.php");
	}
	else{
		$user = $rowcheck["Username"];
		$getchars = mysqli_query($con,"SELECT * FROM `characters` where Username = '".$user."'") or die('Error: ' . mysqli_error($con));
		$check = mysqli_num_rows($getchars);
		$getcharsz = mysqli_query($con,"SELECT * FROM `characters` where Username = '".$user."'") or die('Error: ' . mysqli_error($con));
		$checkz = mysqli_num_rows($getcharsz);

		/*
		$getstats = mysqli_query($con,"SELECT Level, Money, BankMoney, Job, Origin, Gender, House, Business, PlayingHours, Admin, Tester, DonationPoints, Donator FROM characters where Username = '".$id."'") or die(mysqli_error());
		$row = mysqli_fetch_array($getstats);*/
	}
}
else
{
	header("location:login.php");
}
?>
<!doctype html>
<html lang="en-US">
<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Type" content="text/html">
  <title>Personnages</title>
  <link rel="stylesheet" type="text/css" media="all" href="css/character.css">
  <link rel="stylesheet" type="text/css" media="all" href="css/animate.css">
  <link href="styles/ihover.css" rel="stylesheet">                                                                            
  <script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Ek+Mukta">
  </head>

  
 <!-- UCP made by eazzie, UCP starts from here --> 
<body style="margin:0 auto; !important">

   

 <!-- Background image & profile image, character name at the top -->
  <div id="content2">
  
  
<div>
<?php
$iz = 1;
	while($rowgetz = mysqli_fetch_array($getcharsz))
    {
        $id1 = 'imgB1';
        $id2 = 'imgD1';
        if($iz<3)
		{
			echo'<img class="'.${'id'.$iz}.'" src="./img/100skin/'.$rowgetz["Skin"].'.png">';
		}
	$iz++;
	}
	if($checkz == 1)
	{
	echo'
		<img class=imgD1 src="./img/100skin/0.png">';
	}
?>
			
<img align=left,class=imgA1 src="./img/bannerprofile.jpg">
<!-- <img class=imgB1 src="./img/100skin/185.png"> -->
<img align=right,class=imgC1 src="./img/bannerprofile1.png">
<!-- <img class=imgD1 src="./img/100skin/223.png"> -->
</div>


<!--<div class="charname">
	<h3><strong>Eazzie Mathers</strong></h3>
</div> 
-->
</div>

 
 <!-- Full width/body/content. -->
<?php
$i = 1;
	while($rowget = mysqli_fetch_array($getchars))
    {
        $id1 = 'characterone';
        $id2 = 'charactertwo';
        if($i<2)
		{
			echo'<div id="'.${'id'.$i}.'">
			<h1 class="charactername">'.clean($rowget["Character"]).'</h1>
			<p class="characterstats">Date de naissance: '.$rowget["Birthdate"].'</p>
			<p class="characterstats">Origine: '.$rowget["Origin"].'</p>
			<p class="characterstats">Temps de jeux: '.$rowget["PlayingHours"].'</p>    
			<a href="dashboard.php?char='.$rowget["Character"].'"><button class="choosebutton">Choisir</button> </a>
			</div>';
        }
	$i++;
	}
	
	if($check == 1)
	{
		echo'
		<div id="charactertwo">
		
		<h1 class="charactername">Aucun</h1>
		<p class="characterstats">Date de naissance: N/A</p>
		<p class="characterstats">Origine: N/A</p>
		<p class="characterstats">Temps de jeux: N/A</p>
	  
		<button class="choosebutton">Choisir</button>
		
		</div>
	  ';
	}
?>
<!--
  <div id="characterone">

	  <h1 class="charactername">Test_Name</h1>
	  <p class="characterstats">DOB: 12/01/1992</p>
	  <p class="characterstats">Origin: Mexican</p>
	  <p class="characterstats">Time in Los Santos: 56</p>
	  
	  <button class="choosebutton">Choose</button>

      </div>
	  
	    <div id="charactertwo">
		
	   <h1 class="charactername">Angelo_Damce</h1>
	  <p class="characterstats">DOB: 12/01/1992</p>
	  <p class="characterstats">Origin: American</p>
	  <p class="characterstats">Time in Los Santos: 26</p>
	  
	  <button class="choosebutton">Choose</button>
		

		</div> -->
	  <!-- Properties can be found here including vehicles -->
  </div>
	</div>
  

</div>
  </div>
</form>

    </div><!-- @end #content -->
  </div><!-- @end #w -->
    <!-- @eazzie, HTML codes ends here. -->

<script type="text/javascript">
$(function(){
  $('#profiletabs ul li a').on('click', function(e){
    e.preventDefault();
    var newcontent = $(this).attr('href');
    
    $('#profiletabs ul li a').removeClass('sel');
    $(this).addClass('sel');
    
    $('#content section').each(function(){
      if(!$(this).hasClass('hidden')) { $(this).addClass('hidden'); }
    });
    
    $(newcontent).removeClass('hidden');
  });
});
</script>
</body>
<style>
body{
  align-items: center;
  justify-content: center;
  }
  </style>
</html>