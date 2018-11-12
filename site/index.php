<?php
require("settings2.php"); // everything must be set in that file (server IP, variables etc.)
/*
try
{
    $rQuery = new QueryServer( $serverIP, $serverPort );

    $aInformation = $rQuery->GetInfo( );
    $aServerRules = $rQuery->GetRules( );
    $aBasicPlayer = $rQuery->GetPlayers( );
    $aTotalPlayers = $rQuery->GetDetailedPlayers( );

    $rQuery->Close( );
}
catch (QueryServerException $pError)
{
    header("Location: http://Inner City Roleplay.net/server/error.php"); // Redirects to an error page if the server is offline. Change this according to your site domain name. You can customize the error page by opening 'error.php'
}

if(isset($aInformation) && is_array($aInformation)){*/
include("config.php");
$con=mysqli_connect(server, user, password, db) or die(mysqli_error());
$getnews = mysqli_query($con,"SELECT * FROM news ORDER BY news_id DESC") or die(mysqli_error());
?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Royal Roleplay</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/style.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body style="background-color:#F5F5F5;">

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#"><?php echo 'Royal Roleplay '; ?></a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="index.php">Accueil</a></li>
			<li><a href="login.php">UCP</a></li>
                        <li><a href="http://forum.royal-roleplay.fr/">Forum</a></li>
                        <li><a href="https://discord.gg/YGEyRps">Discord</a></li>

                    </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>

    <!-- BANNER START -->
    <div class="banner-head">
      <h1><?php echo 'Royal Roleplay '; ?></h1>
      <h3><?php echo 'Roleplay'; ?></h3>
    </div>
    <!-- BANNER END -->

    <!-- SERVER STATS END -->

      <br/> 
    <!-- SERVER PLAYERS END -->
    </div>

    <!-- ANNOUNCEMENTS STARTS -->
    <div class="page-section-grey-title">
      <h2><b> Annonce & News: </b></h2>
	  </div>
	  <div class="page-section-grey-title">
	  <div class="container">
      
			<?php while($row = mysqli_fetch_array($getnews))
					{
						echo'
					<div class="col-md-12" style="float:none; !important">
						 <div class="panel panel-default">
							<div class="panel-heading">
								<h4><i class="fa fa-fw fa-comments-o" style="display:inline;"></i> '.$row["news_name"].'</h4>
								<span class="pull-right text-muted small" style="margin-top: -37px; text-align: right; display:inline;"><em><b>'.$row["news_postedby"].'</b><br>'.$row["news_date"].'</em></span>
							</div>
							<div class="panel-body">
								
								'.$row["news_desc"].'
					</div>
					</div>
					</div> 
					<br/>
		'; }?>			
						             
		</div>
		</div>
    <!-- ANNOUNCEMENTS END -->

    <!-- FOOTER START -->
    <footer>
        <div class="container">
		<!--<div class="row">
			<div class="row-md-12">
				<h1 class="page-header" style="font-size: 24px;"><i class="fa fa-list-alt fw-fa"> </i> Server updates and news</h1>
				<span>
			</div>
		</div>-->
            <div class="row">
                <div class="col-lg-12">
                    <ul class="list-inline">
                    </ul>
                    <p id="copyright">Copyright &copy; Royal Roleplay  <?php echo date("Y"); ?>, All Rights Reserved<br><br> Serveur IP: <?php echo SVRIP; ?></p>
                </div>
            </div>
        </div>
    </footer>
    <!-- FOOTER END -->

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
</body>
</html>