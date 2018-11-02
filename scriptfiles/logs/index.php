<?php 
header( 'content-type: text/html; charset=utf-8' );
##Pour les table log
$fichier="admin_log.txt"; $tabfich=file($fichier); 
$fichier1="ban_log.txt"; $tabfich1=file($fichier1);
$fichier2="biz_log.txt"; $tabfich2=file($fichier2);
$fichier3="car_log.txt"; $tabfich3=file($fichier3);
$fichier4="cheat_log.txt"; $tabfich4=file($fichier4);
$fichier5="craft_log.txt"; $tabfich5=file($fichier5);
$fichier6="do.txt"; $tabfich6=file($fichier6);
$fichier7="droppick.txt"; $tabfich7=file($fichier7);
$fichier8="faction_chat.txt"; $tabfich8=file($fichier8);
$fichier9="give_log.txt"; $tabfich9=file($fichier9);
$fichier10="house_log.txt"; $tabfich10=file($fichier10);
$fichier11="jail_log.txt"; $tabfich11=file($fichier11);
$fichier12="kick_log.txt"; $tabfich12=file($fichier12);
$fichier13="kill_log.txt"; $tabfich13=file($fichier13);
$fichier14="me.txt"; $tabfich14=file($fichier14);
$fichier15="mysql_log.txt"; $tabfich15=file($fichier15);
$fichier16="offer_log.txt"; $tabfich16=file($fichier16);
$fichier17="pay_log.txt"; $tabfich17=file($fichier17);
$fichier18="pm_chat.txt"; $tabfich18=file($fichier18);
$fichier19="ooc.txt"; $tabfich19=file($fichier19);
$fichier20="spawnitem.txt"; $tabfich20=file($fichier20);
$fichier21="ticket_log.txt"; $tabfich21=file($fichier21);
$fichier22="louerveh.txt"; $tabfich22=file($fichier22);
$fichier23="tax_vault.txt"; $tabfich23=file($fichier23);
$fichier24="whisper_log.txt"; $tabfich24=file($fichier24);
$fichier25="vehicule.txt"; $tabfich25=file($fichier25);
$fichier26="adminchat_log.txt"; $tabfich26=file($fichier26);
$fichier27="anpe.txt"; $tabfich27=file($fichier27);
$fichier28="storage_log.txt"; $tabfich28=file($fichier28);
$fichier29="name_log.txt"; $tabfich29=file($fichier29);
$fichier30="sms.txt"; $tabfich30=file($fichier30);
$fichier31="telephone.txt"; $tabfich31=file($fichier31);

##Affichier les truc
echo "<h4> ADMIN LOG</h4>"; for( $i = 0 ; $i < count($tabfich) ; $i++ ) {echo $tabfich[$i]."</br>";}
echo "<h4> ADMIN CHAT LOG</h4>"; for( $i = 0 ; $i < count($tabfich26) ; $i++ ) {echo $tabfich26[$i]."</br>";}
echo "<h4> ANPE LOG</h4>"; for( $i = 0 ; $i < count($tabfich27) ; $i++ ) {echo $tabfich27[$i]."</br>";}
echo "<h4> BAN LOG</h4>"; for( $i = 0 ; $i < count($tabfich1) ; $i++ ) {echo $tabfich1[$i]."</br>";}
echo "<h4> BIZ LOG</h4>"; for( $i = 0 ; $i < count($tabfich2) ; $i++ ) {echo $tabfich2[$i]."</br>";}
echo "<h4> CAR LOG</h4>"; for( $i = 0 ; $i < count($tabfich3) ; $i++ ) {echo $tabfich3[$i]."</br>";}
echo "<h4> CHEAT LOG</h4>"; for( $i = 0 ; $i < count($tabfich4) ; $i++ ) {echo $tabfich4[$i]."</br>";}
echo "<h4> CRAFT LOG</h4>"; for( $i = 0 ; $i < count($tabfich5) ; $i++ ) {echo $tabfich5[$i]."</br>";}
echo "<h4> DO LOG</h4>"; for( $i = 0 ; $i < count($tabfich6) ; $i++ ) {echo $tabfich6[$i]."</br>";}
echo "<h4> DROPPICK LOG</h4>"; for( $i = 0 ; $i < count($tabfich7) ; $i++ ) {echo $tabfich7[$i]."</br>";}
echo "<h4> FACTION CHAT LOG</h4>"; for( $i = 0 ; $i < count($tabfich8) ; $i++ ) {echo $tabfich8[$i]."</br>";}
echo "<h4> GIVE LOG</h4>"; for( $i = 0 ; $i < count($tabfich9) ; $i++ ) {echo $tabfich9[$i]."</br>";}
echo "<h4> HOUSE LOG</h4>"; for( $i = 0 ; $i < count($tabfich10) ; $i++ ) {echo $tabfich10[$i]."</br>";}
echo "<h4> JAIL LOG</h4>"; for( $i = 0 ; $i < count($tabfich11) ; $i++ ) {echo $tabfich11[$i]."</br>";}
echo "<h4> KICK LOG</h4>"; for( $i = 0 ; $i < count($tabfich12) ; $i++ ) {echo $tabfich12[$i]."</br>";}
echo "<h4> KILL LOG</h4>"; for( $i = 0 ; $i < count($tabfich13) ; $i++ ) {echo $tabfich13[$i]."</br>";}
echo "<h4> LOUAGE VEH LOG</h4>"; for( $i = 0 ; $i < count($tabfich22) ; $i++ ) {echo $tabfich22[$i]."</br>";}
echo "<h4> MAIRIE LOG</h4>"; for( $i = 0 ; $i < count($tabfich23) ; $i++ ) {echo $tabfich23[$i]."</br>";}
echo "<h4> ME LOG</h4>"; for( $i = 0 ; $i < count($tabfich14) ; $i++ ) {echo $tabfich14[$i]."</br>";}
echo "<h4> MYSQL LOG</h4>"; for( $i = 0 ; $i < count($tabfich15) ; $i++ ) {echo $tabfich15[$i]."</br>";}
echo "<h4> NAME LOG</h4>"; for( $i = 0 ; $i < count($tabfich29) ; $i++ ) {echo $tabfich29[$i]."</br>";}
echo "<h4> OBJECT MAISON LOG</h4>"; for( $i = 0 ; $i < count($tabfich28) ; $i++ ) {echo $tabfich28[$i]."</br>";}
echo "<h4> OFFER LOG</h4>"; for( $i = 0 ; $i < count($tabfich16) ; $i++ ) {echo $tabfich16[$i]."</br>";}
echo "<h4> PAY LOG</h4>"; for( $i = 0 ; $i < count($tabfich17) ; $i++ ) {echo $tabfich17[$i]."</br>";}
echo "<h4> PM CHAT LOG</h4>"; for( $i = 0 ; $i < count($tabfich18) ; $i++ ) {echo $tabfich18[$i]."</br>";}
echo "<h4> OOC CHAT LOG</h4>"; for( $i = 0 ; $i < count($tabfich19) ; $i++ ) {echo $tabfich19[$i]."</br>";}
echo "<h4> SMS LOG</h4>"; for( $i = 0 ; $i < count($tabfich30) ; $i++ ) {echo $tabfich30[$i]."</br>";}
echo "<h4> SPAWN ITEM LOG</h4>"; for( $i = 0 ; $i < count($tabfich20) ; $i++ ) {echo $tabfich20[$i]."</br>";}
echo "<h4> TELEPHONE LOG</h4>"; for( $i = 0 ; $i < count($tabfich31) ; $i++ ) {echo $tabfich31[$i]."</br>";}
echo "<h4> TICKET LOG</h4>"; for( $i = 0 ; $i < count($tabfich21) ; $i++ ) {echo $tabfich21[$i]."</br>";}
echo "<h4> VEHICULE LOG</h4>"; for( $i = 0 ; $i < count($tabfich25) ; $i++ ) {echo $tabfich25[$i]."</br>";}
echo "<h4> WHISPER LOG</h4>"; for( $i = 0 ; $i < count($tabfich24) ; $i++ ) {echo $tabfich24[$i]."</br>";}
?>