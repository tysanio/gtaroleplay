CMD:chatdc(playerid,params[])
{
    new string[65],name[MAX_PLAYER_NAME + 1],string1[65];
    GetPlayerName(playerid, name, sizeof(name));
    if (strlen(string) < 64)
	{
	    format(string, sizeof(string),"> IG %s dit : %s",name,params);
		utf8encode(string1,string,sizeof(string1));
		DCC_SendChannelMessage(discordlog,string1);
		foreach (new i : Player)  if(PlayerData[i][pDiscordChat] == 1) SendClientMessage(playerid,-1,string);
    }
    else SendClientMessage(playerid,COLOR_RED,"Max 64 caractere.");
    return 1;
}
CMD:discordchat(playerid, params[])
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	if (PlayerData[playerid][pDiscordChat] == 0)
	{
		PlayerData[playerid][pDiscordChat] = 1;
		SendServerMessage(playerid,"Chat discord mis � on /chatdc pour ecrire!");
		SendServerMessage(playerid,"Attention /chatdc [texte] pour voir les messages ooc seulement!");
		//SendServerMessage(playerid,"Attention le /fac [texte] fera en sorte que vous voyez les messages de votre faction seulement!");
		return 1;
	}
	else
	{
		PlayerData[playerid][pDiscordChat] = 0;
		SendServerMessage(playerid,"Chat discord mis � off vous ne recevrez plus les messages discord.");
		return 1;
	}
}
DISCORD:c( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		new msg[100],msg1[100],msg2[100];
		if(sscanf(params, "s[100]", msg)) return DCC_SendChannelMessage(discordlog,""DISCORD_PREFIX"c [Msg]");
		DCC_TriggerBotTypingIndicator(discordlog);
		utf8encode(msg1,msg,sizeof(msg));
		format(msg1, sizeof(msg1),"> %s: %s ", ReturnDiscordName( author ), msg);
		utf8encode(msg2,msg1,sizeof(msg2));
		DCC_SendChannelMessage(discordlog,msg2);
		format(msg1, sizeof(msg1),"[Discord] %s dit : %s",ReturnDiscordName( author ),msg);
		foreach (new i : Player)  if(PlayerData[i][pDiscordChat] == 1) SendClientMessageToAll(COLOR_RED,msg1);
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
    return 1;
}
DISCORD:players( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	new name[24],msg[144];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		DCC_SendChannelMessage(discordlog,"**__Joueurs sur le serveur__**");
		for(new i=0; i < 100; i++)
		{
			GetPlayerName(i, name, MAX_PLAYER_NAME);
			if(!IsPlayerConnected(i)) continue;
			DCC_TriggerBotTypingIndicator(discordlog);
			format(msg, sizeof(msg),"> (ID : %d) %s score %d ping %d",i, name,GetPlayerScore(i),GetPlayerPing(i));
			DCC_SendChannelMessage(discordlog,msg);
		}
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
    return 1;
}
DISCORD:kick( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		new pID1,name[24];
		if (sscanf( params, "u", pID1)) return DCC_SendChannelMessage(discordaaa, "**[USAGE]** ?kick [PLAYER_ID]" );
		if (IsPlayerConnected(pID1))
		{
            GetPlayerName(pID1, name, MAX_PLAYER_NAME);
			DCC_TriggerBotTypingIndicator(discordaaa);
			DCC_SendChannelMessage(discordaaa, "> **[KICK]** **%s** a kick **%s(%d)**.", ReturnDiscordName( author ),name, pID1);
			SendErrorMessage(pID1,"Tu as �t� kick via le discord");
			KickEx(pID1);
		}
		else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Joueur non connecte!" );
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:ban( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff2ok || sistaff3ok || sistaff4ok)
	{
		new pID1,name[24];
		if (sscanf( params, "u", pID1)) return DCC_SendChannelMessage(discordaaa, "**[USAGE]** ?ban [PLAYER_ID]" );
		if (IsPlayerConnected(pID1))
		{
            GetPlayerName(pID1, name, MAX_PLAYER_NAME);
			DCC_TriggerBotTypingIndicator(discordaaa);
			DCC_SendChannelMessage(discordaaa, "> **[BAN]** **%s** a ban **%s(%d)**.", ReturnDiscordName( author ),name, pID1);
			Dialog_Show(pID1, ShowOnly, DIALOG_STYLE_MSGBOX, "Ban", "Tu as �t� bannie.\nJoueur: %s\nVia le tabckick\nL'admin qui ta ban: %s\n\nAppuyer F8 si c'est une erreur.", "Fermer", "", ReturnName(pID1,0),ReturnDiscordName( author ));
			SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a ete banni par %s via discord.", PlayerData[pID1][pUsername],ReturnDiscordName( author ));
			Log_Write("logs/ban_log.txt", "[%s] %s a ete banni par %s via discord.",ReturnDate(),PlayerData[pID1][pUsername],ReturnDiscordName( author ));
			Blacklist_Add(PlayerData[pID1][pIP], PlayerData[pID1][pUsername],ReturnDiscordName( author ),"Via Discord");
			KickEx(pID1);
		}
		else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Joueur non connecte!" );
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:rapports( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		new count,string[144];
		DCC_TriggerBotTypingIndicator(discordaaa);
		for (new i = 0; i != MAX_REPORTS; i ++)
		{
			if (!ReportData[i][rExists]) continue;
			format(string, sizeof(string), "> [RID: %d] %s (ID: %d) a un rapport en attente IG",i,ReturnName(ReportData[i][rPlayer]), ReportData[i][rPlayer]);
			DCC_SendChannelMessage(discordaaa,string);
			count++;
		}
		if (!count) return DCC_SendChannelMessage(discordaaa, "Aucun rapport de joueurs pour le moment.");
	}
	else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:restart( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff3ok || sistaff4ok)
	{
		if (g_ServerRestart)
		{
			TextDrawHideForAll(gServerTextdraws[3]);
			g_ServerRestart = 0;
			g_RestartTime = 0;
			return SendClientMessageToAllEx(COLOR_LIGHTRED, "[DISCORD]: Un admin sur discord a commencer un restart du serveur.");
		}
		DCC_TriggerBotTypingIndicator(discordaaa);
		TextDrawShowForAll(gServerTextdraws[3]);
		g_ServerRestart = 1;
		g_RestartTime = 10;
		DCC_SendChannelMessage(discordaaa, "> **[DISCORD]** Reboot du serveur dans 10 secondes!");
		SendClientMessageToAllEx(COLOR_LIGHTRED, "[DISCORD]: Un admin sur discord a commencer un restart du serveur.");
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:jail( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static userid,minutes,reason[128],string[128];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		DCC_TriggerBotTypingIndicator(discordaaa);
		if (sscanf(params, "uds[128]", userid, minutes, reason))
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** ?jail [playerid/name] [minutes] [raison]");
		if (userid == INVALID_PLAYER_ID)
			return DCC_SendChannelMessage(discordaaa,"Vous avez mis un [id/nom] invalide.");
		if (minutes < 1)
			return DCC_SendChannelMessage(discordaaa,"Tu ne peut mettre en prison pour zero minute ou moins.");
		ClearAnimations(userid);
		DCC_TriggerBotTypingIndicator(discordaaa);
		PlayerTextDrawShow(userid, PlayerData[userid][pTextdraws][70]);
		SetPlayerPosEx(userid,2487.8855,-1668.9358,1140.8169);
		SetPlayerInterior(userid, 3);
		SetPlayerVirtualWorld(userid, (userid + 100));
		SetPlayerFacingAngle(userid, 0.0);
		SetCameraBehindPlayer(userid);
		TogglePlayerControllable(userid, 0);
		ResetWeapons(userid);
		ShowHungerTextdraw(userid, 0);
		ResetPlayer(userid);
		PlayerData[userid][pJailTime] = minutes * 60;
		PlayerData[userid][pPrisoned] = 0;
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string, sizeof(string), "Vous avez mis en prison admin %s pour %d minutes (%s).", ReturnName(userid, 0), minutes, reason);
		DCC_SendChannelMessage(discordaaa,string);		
		SendAdminAction(userid, "Un admin discord vous � mis en prison admin pour %d minutes (%s).", minutes, reason);
		SendClientMessageToAllEx(COLOR_LIGHTRED, "[Discord]: un admin discord � mis en prison admin %s pour %d minutes raison: %s", ReturnName(userid, 0), minutes, reason);
		Log_Write("logs/jail_log.txt", "[%s] %s a mis en prison admin %s pour %d minutes, raison: %s.", ReturnDate(), ReturnDiscordName( author ), ReturnName(userid, 0), minutes, reason);
		return 1;
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:dejail( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static userid,string[96];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		if (sscanf(params, "u", userid))
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** ?dejail [playerid/nom]");
		if (userid == INVALID_PLAYER_ID)
			return DCC_SendChannelMessage(discordaaa,"Vous avez mis un [id/nom] invalide.");
		if (!PlayerData[userid][pJailTime])
			return DCC_SendChannelMessage(discordaaa,"Joueur non prisonnier.");
		DCC_TriggerBotTypingIndicator(discordaaa);
		PlayerData[userid][pJailTime] = 1;
		TogglePlayerControllable(userid, 1);
		format(string, sizeof(string), "Vous avez sortie de prison %s.", ReturnName(userid, 0));
		DCC_SendChannelMessage(discordaaa,string);	
		SendAdminAction(userid, "Un admin discord vous a lib�r�.");
		Log_Write("logs/jail_log.txt", "[%s] %s a libere %s .", ReturnDate(),ReturnDate(), ReturnDiscordName( author ), ReturnName(userid, 0));
		return 1;
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:debug( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static userid,string[96],string1[96];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		if (sscanf(params, "u", userid))
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** ?debug [playerid/nom]");
		if (userid == INVALID_PLAYER_ID)
			return DCC_SendChannelMessage(discordaaa,"Vous avez mis un [id/nom] invalide.");
		SetPlayerVirtualWorld(userid,0);
		SetPlayerInterior(userid,0);
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string, sizeof(string), "Vous avez d�bug %s.", ReturnName(userid, 0));
		utf8encode(string1,string,sizeof(string1));
		DCC_SendChannelMessage(discordaaa,string1);	
		SendAdminAction(userid, "Un admin discord vous a debug.");
		return 1;
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:stats( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static userid;
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		if (sscanf(params, "u", userid))
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** ?stats [playerid/nom]");
		DCC_TriggerBotTypingIndicator(discordaaa);
		ShowStatsForDiscord(userid);
	}
	else DCC_SendChannelMessage( discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:ostats( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		if ( isnull( params ) || strlen( params ) > 24 ) 
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** ?ostats [nom]");
		static query[1024];
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
		mysql_tquery(g_iHandle, query, "OnPlayerDiscordStats", "ds", INVALID_PLAYER_ID, params);
	}
	else DCC_SendChannelMessage( discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:aide( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static type[24],string[2048],string1[2048];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
	    if (sscanf(params, "s[24]", type))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
		    DCC_SendChannelMessage( discordlog, "> **[USAGE]** ?aide [type]");
			DCC_SendChannelMessage( discordlog, "> [Type]: maison, biz, chat, vehicule, divers, general, discord");
			return 1;
	    }
		else if (!strcmp(type, "discord", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide discord]___**\n- !ostats [Nom du joueur] affiche les stats du joueur depuis la bdd\n- !stats [id] voir des stats de joueur en ligne\n- !c [texte] pour parler de fa�ons ooc au serveur\n- !jail [id] jail un joueur IG\n- !dejail [id] d�jail un joueur IG\n- !debug [ID] si un joueur a un probl�me d'interieur et de virtualworld\n- !restart restart le serveur\n- !rapports voir les rapports non repondu IG\n- !ban [ID] ban un joueur IG\n- !kick [ID] kick un joueur IG\n- !players pour voir les joueurs connecter\n- !baninfo [nom du personage] pour voir les infos du bannie\n- !stockjob pour voir les stocks des jobs\n- !caissedetat voir l'argent de l'�tat\n- !respawn [ID] respawn un joueur en difficult�\n- !supprimer pour pouvoir supprimer un compte ou un personnage\n- !ping pour savoir si le serveur est tjrs on\n- !factionlist liste des factions sur le serveur.\n- !listemort la liste des morts sur le serveur\n- !abus pour savoir pourquoi une action a �t� entreprise par les devs```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
		else if (!strcmp(type, "chat", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide chat]___**\n- /me Sert a effectuer une action,\n- /do Sert pour confirmer ou d�crire une action,\n- /(c)rier Sert a crier\n- /(o)oc Sert a parlez en Out of Character,\n- /decrocher Sert a d�crocher son t�l�phone\n- /racrocher Sert a racrocher son t�l�phone\n- /dc pour le chat discord\n- /discordchat pour active le chat```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
		else if (!strcmp(type, "maison", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide maison]___**\n- /vendre pour vendre une maison,\n- /abandonner Pour abandonner votre maison sans gagner d'argent dessus\n- /porte Pour fermer la porte de la maison,\n- /mcoffre Pour voir le coffre de la maison\n- /fourniture Pour pouvoir bouger vos meubles\n- /acheteretagere Pour acheter une �tag�re\n- /armeetagere Pour poser une arme sur une �tag�re\n- /supetagere Pour supprimer une �tag�re\n- /sonner Pour sonner a la porte d'une maison\n- /lumiere Pour allumer la lumiere dans la maison\n- /cuisiner pour cuisiner un repas congel�\n- /locamax pour d�finir le max de locataire\n- /locaprix pour d�finir le prix de la locations\n- /(de)louermaison pour louer une maison ou d�louer celle-ci```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
		else if (!strcmp(type, "biz", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide biz]___**\n- /vendre pour vendre un magasin,\n- /abandonner Pour abandonner votre magasin sans gagner d'argent dessus\n- /porte Pour fermer la porte du magasin,\n- /bcoffre Pour voir le coffre du magasin\n- /produits Pour changer les prix des marchandises\n- /binfo Pour voir l'information du magasin\n- /bnom Pour changer le nom du magasin\n- /bmessage Pour changer le message du magasin\n- /accepterlivraison Faire une livraison de votre biz\n- /bheures d�finir les heures d'ouverture de votre magasin```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
		else if (!strcmp(type, "vehicule", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide vehicule]___**\n- /porte Pour fermer les portes du vehicule\n- /vendre pour vendre un v�hicule,\n- /remplir Pour faire le plein de votre v�hicule\n- /enlevertunning Pour enlever le tuning du v�hicule\n- /vcoffre Pour ouvrir le coffre du v�hicule\n- /demarrer ou appuyer sur ctrl Pour demarrer le moteur du v�hicule\n- /phare ou appuyer sur � Pour allumer les phares du v�hicule\n- /crocheterporte Pour forcer la porte d'un v�hicule\n- /capot Pour ouvrir le capot du v�hicule\n- /vitre Pour ouvrir et fermer la fenetre du v�hicule\n- /ceinture pour attacher votre ceinture\n- /setradio pour ecouter la radio dans le v�hicule,\n- /trafiquerfils pour voler un v�hicule,\n- /louerveh pour louer un v�hicule,\n- /delouerveh pour delouer un v�hicule (attention a etre a la bonne place pour cela,\n- /vpreter voir le v�hicule qu'on vous a pret�,\n- /vdouble Pour preter les cles de votre v�hicule,\n- /vjeter pour jetter le double des cl�s preter,\n- /payersabot pour payer le sabot du v�hicule,\n- /achetergarage pour acheter un garage,\n- /garage pour aller dans votre garage```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
		else if (!strcmp(type, "divers", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide divers]___**\n- /proprieter pour voir se que vous �tes le proprietaire,\n- /stats pour afficher les statistiques de votre personnage,\n- /changermdp pour changer de mot de passe\n- /derni�refois Pour connaitre la derni�re connection d'un joueur,\n- /acc pour enlever ou mettre vos accessoire,\n- /rapport pour rapporte un mefait,\n- /bjstart pour commencer le blackjack,\n- /bjstop pour stop le black jack,\n- /supporteurs pour avoir la liste des helpeurs disponible,\n- /roulette pour jouer a la roulette au casino\n- /monpanneau pour afficher les options du panneau\n- /enlevercp pour enlever tout checkpoint sur votre carte,\n- /stopanim pour stopper une animation en cours,\n- /animcmds Pour la liste des animations,\n- /resetvw Remet a 0 votre virtualWorld,\n- /distancec pour voir la distance du commissariat,\n- /bowlingstats pour avoir votre r�sultat du bowling,\n- /jeter pour jeter une arme```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
		else if (!strcmp(type, "general", true))
		{
			DCC_TriggerBotTypingIndicator(discordlog);
			format(string, sizeof(string), "```**___[Aide general]___**\n- /banque pour ouvrir le menu de la banque,\n- /payer pour payer un joueur,\n- /donnerarme pour donner une arme a un joueur,\n- /serrermain pour demander un serrage de main,\n- /volerbanque pour voler la banque,\n- /voleritem voler un item dans un magasin,\n- /ouvrircargaison pour ouvrir une boite,\n- /boombox pour mettre une musique,\n- /montrerpermis Pour montrer vos permis � un joueur,\n- /boite savoir le nombre de cargaisons dans un vehicule,\n- /planter pour pouvoir planter de la drogue,\n- /recolter Pour recolter une plante de drogue poussee\n- /trousse pour utiliser un kit de premier soin,\n- /crocheterporte pour forcer une porte d'un vehicule,\n- /fouiller pour fouiller dans l'inventaire d'un joueur,\n- /freq pour choisir le channel de votre talkie-walkie,\n- /chargeur pour charger votre arme avec des munitions,\n- /usemag pour utiliser un seul chargeur dans votre inventaire pour votre arme,\n- /carte Montrer sa carte d'indentit�,\n- /tme [texte] Pour une description de votre personage (120 charactere de max)\n- /quitjob pour quitter son job actuel,\n- /tmeoff pour enlever le tme\n- /zkill pour les skills de vos armes et le nombre de zombie tu�e\n- /credits pour voir les credits```");
			utf8encode(string1,string,sizeof(string1));
			DCC_SendChannelMessage(discordlog,string1);
		}
	}
	else DCC_SendChannelMessage( discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:baninfo( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    static string[128];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff3ok || sistaff4ok)
	{
		DCC_TriggerBotTypingIndicator(discordlog);
		if (isnull(params) || strlen(params) > 24) DCC_SendChannelMessage( discordlog, "> **[USAGE]** ?baninfo [nom de l'utilisateur]");
		else
		{
			format(string, sizeof(string), "SELECT * FROM `blacklist` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
			mysql_tquery(g_iHandle, string, "OnBanLookupDC", "ds", INVALID_PLAYER_ID, params);
		}
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:stockjob( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    static string[4096],string1[512], string2[512], string3[512], string4[512], string5[512],string6[4096], stockjobinfoid;
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		DCC_TriggerBotTypingIndicator(discordlog);
		DCC_SendChannelMessage(discordlog,"**Stock des jobs**");
		format(string1, sizeof(string1), "Bois : %s\nViande : %s\nMeuble : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfobois]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoviande]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfomeuble]));
		format(string2, sizeof(string2), "Central 1 : %s\nCentral 2 : %s\nCentral 3 : %s\nCentral 4 : %s\nCentral 5 : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral2]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral3]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral4]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral5]));
		format(string3, sizeof(string3),"Electronique : %s\nP�trol: %s\nL'essence G�n�rateur : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfopetrol]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator]));
		format(string4, sizeof(string4),"Bois meuble : %s\nMagasin stock: %s\nCaisse des dock : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockdock]));
		format(string5, sizeof(string5),"Caisse manutentionnaire : %s\nCaisse cariste: %s\nPierre miner : %s\nStock d'arme : %s",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockminer]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes]));
		format(string, sizeof(string),"```%s%s%s%s%s```",string1,string2,string3,string4,string5);
		utf8encode(string6,string,sizeof(string6));
		DCC_SendChannelMessage(discordlog,string6);
		DCC_TriggerBotTypingIndicator(discordlog);
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
}
DISCORD:caissedetat( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		DCC_TriggerBotTypingIndicator(discordaaa);
		DCC_SendChannelMessage(discordaaa,"**Argent de l'etat**");
		new string[1024], moneyentrepriseid;
		format(string, sizeof(string), "Police : %s$\nFBI : %s$\nSWAT : %s$\nMedecin : %s$\nMairie : %s$\nFermier : %s$\nBanque : %s$",FormatNumber(argent_entreprise[moneyentrepriseid][argentpolice]),FormatNumber(argent_entreprise[moneyentrepriseid][argentfbi]),FormatNumber(argent_entreprise[moneyentrepriseid][argentswat]),FormatNumber(argent_entreprise[moneyentrepriseid][argentmedecin]),FormatNumber(argent_entreprise[moneyentrepriseid][argentmairie]),FormatNumber(argent_entreprise[moneyentrepriseid][argentfermier]),FormatNumber(argent_entreprise[moneyentrepriseid][argentbanque]));
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string, sizeof(string),"```%s```",string);
		DCC_SendChannelMessage(discordaaa,string);
		
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
}
DISCORD:respawn( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		static userid;
		DCC_TriggerBotTypingIndicator(discordaaa);
		if (sscanf(params, "u", userid))
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** ?respawn [playerid/nom]");
		if (userid == INVALID_PLAYER_ID)
			return DCC_SendChannelMessage(discordaaa,"Vous avez mis un [id/nom] invalide.");
		if (!IsPlayerSpawned(userid))
			return DCC_SendChannelMessage(discordaaa,"Ca ne fonctionne pas.");
		RespawnPlayer(userid);
		DCC_SendChannelMessage(discordaaa,"Vous avez respawn ce joueur.");
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:supprimer( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    static query[128],type[24];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff3ok || sistaff4ok)
	{
		DCC_TriggerBotTypingIndicator(discordaaa);
	    if (sscanf(params, "s[24]", type))
		{
			DCC_TriggerBotTypingIndicator(discordaaa);
		    DCC_SendChannelMessage( discordaaa,"> **[USAGE]** ?supprimner [type]");
			DCC_SendChannelMessage( discordaaa, "> [Type]:perso, compte");
			return 1;
	    }
		else if (!strcmp(type, "perso", true))
		{
			DCC_TriggerBotTypingIndicator(discordaaa);
			if (isnull(params) || strlen(params) > 24)
				return DCC_SendChannelMessage( discordaaa,"> **[USAGE]** ?supprimer perso [nom du perso]");
			if (!IsValidPlayerName(params))
				return DCC_SendChannelMessage( discordaaa,"Vous avez specifier un nom de format invalide.");
			format(query, sizeof(query), "SELECT `ID`, `Admin` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
			mysql_tquery(g_iHandle, query, "OnDeleteCharacter", "ds", INVALID_PLAYER_ID, params);
			return 1;
		}
		else if (!strcmp(type, "compte", true))
		{
			DCC_TriggerBotTypingIndicator(discordaaa);	
		    if (!IsValidPlayerName(params)) return DCC_SendChannelMessage( discordaaa,"Vous avez specifier un nom de format invalide.");
			foreach (new i : Player) if (!strcmp(PlayerData[i][pUsername], params, true)) return DCC_SendChannelMessage( discordaaa,"Tu ne peut supprimer le compte du joueur en ligne!.");
			format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
			mysql_tquery(g_iHandle, query, "OnDeleteAccount", "ds", INVALID_PLAYER_ID, params);
			return 1;
		}
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:ping( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
	if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
	{
		DCC_TriggerBotTypingIndicator(discordaaa);
		DCC_SendChannelMessage(discordaaa, "Ouais ouais je suis la tkt pas");
		DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
		DCC_SetBotActivity("Ouais ouais je suis tjrs la...");
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:factionlist( DCC_Channel: channel, DCC_User: author, params[ ] )
{
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		new string[1040],string1[1040];
		for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[i][factionExists]) {
			format(string, sizeof(string), "%s Faction (ID %i) | %s | PiD %d \n", string, i, FactionData[i][factionName],FactionData[i][factionID]);
		}
		DCC_SendChannelMessage(discordlog,"**Faction sur le serveur**");
		utf8encode(string1,string,sizeof(string1));
		DCC_SendChannelMessage(discordlog,string1);
		return 1;
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:listemort( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static string[2048];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		format(string, sizeof(string), "SELECT * FROM `death`");
		mysql_tquery(g_iHandle, string, "OnViewDeath", "","");	
	}
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
	return 1;
}
DISCORD:abus( DCC_Channel: channel, DCC_User: author, params[ ] )
{
	static string[560],string1[560];
    DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
	if (simembreroleok)
	{
		DCC_TriggerBotTypingIndicator(discordlog);
		format(string, sizeof(string), "```Donc vous avez fait !abus.\nVous trouver que d'attendre X nombres d'heures est injuste?\nDit vous qu'il y a des gens qui abusent des scripts mis en place pour le serveur et\nqui en abusent donc on doit sanctionner tout le monde a cause de certaines personnes.\nVous pouvez vous plaindre sur le discord\nmais � cause de gens qui abusent les actions entreprises par le staff et les d�veloppeurs peut �tre lourd ou injuste.\nNe soyer par surprit des r�ponses donn�es.\nMerci de votre compr�ension et bonne journ�e.\nL'�quipe de d�veloppement du serveur.```");
		utf8encode(string1,string,sizeof(string1));
		DCC_SendChannelMessage(discordlog, string1);
	}
	return 1;
}
script OnViewDeath(extraid[])
{
	new string[250],desc[25],rows,fields,desc1[50],string1[250];
	cache_get_data(rows, fields, g_iHandle);
	if (!rows) return DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Aucune mort trouver!");
	DCC_SendChannelMessage(discordlog, "**[DISCORD]** Liste des morts du serveur");
	for (new i = 0; i < rows; i ++) {
	    cache_get_field_content(i, "dName",desc, g_iHandle,32);
	    cache_get_field_content(i, "dDate", desc1, g_iHandle,32);
	    format(string, sizeof(string), "Nom : %s Date de la mort : %s \n",desc,desc1);
		utf8encode(string1,string,sizeof(string1));
		DCC_SendChannelMessage(discordlog, string);
	}
	return 1;
}	
ShowStatsForDiscord(userid)
{
    new origin[32],string[256],string1[128],string2[128],string3[128],string4[128],string44[128],count;
	for (new i = 0; i < MAX_INVENTORY; i ++) if (InventoryData[userid][i][invExists]) {
	    count++;
	}
	DCC_TriggerBotTypingIndicator(discordlog);
	format(origin, 32, "%.16s",PlayerData[userid][pOrigin]);
	if (strlen(PlayerData[userid][pOrigin]) > 16)
		strcat(origin, "...");
	format(string1, sizeof(string1), "**Joueur IG %s (ID: %d)**", ReturnName(userid), userid);
	format(string2, sizeof(string2), "Admin: %s Testeur+: %s, Faction Manangement: %s", (PlayerData[userid][pAdmin]) ? ("Oui") : ("Non"), (PlayerData[userid][pTester]) ? ("Oui") : ("Non"), (PlayerData[userid][pFactionMod]) ? ("Oui") : ("Non"));
	format(string3, sizeof(string3), "Sexe: %s Anniv: %s Origine: %s", (PlayerData[userid][pGender] == 2) ? ("Femme") : ("Homme"),PlayerData[userid][pBirthdate], origin);
	format(string4, sizeof(string4), "Heure de jou�e: %d Job: %s Inventaire: %d/%d",PlayerData[userid][pPlayingHours], Job_GetName(PlayerData[userid][pJob]), count,PlayerData[userid][pCapacity]);
	Embed = DCC_CreateEmbed(string1,"----------------------Info du personnage enligne------------------");
	DCC_AddEmbedField(Embed ,string2,string3);
	utf8encode(string44,string4,sizeof(string44));
	DCC_AddEmbedField(Embed ,string44,"-----------------------SKIN IMAGE------------------------------------");
	DCC_SetEmbedColor(Embed,0x00FF00);
	format(string, sizeof(string), "https://gtaundergroundmod.com/resources/media/skins/%d.png",PlayerData[userid][pSkin]);
	DCC_SetEmbedImage(Embed,string);
	DCC_SendChannelEmbedMessage(discordlog, Embed);
	return 1;
}
/*script DCC_OnGuildMemberAdd(DCC_Guild:guild, DCC_User:user)
{
	DCC_SendChannelMessage(discordlog,"**[Nouveau sur discord]** ?aide pour la liste des commandes, pour te faire verifier et avoir acces il faut t'inscrire IG.");
	return 1;
}*/
script OnPlayerDiscordStats( playerid, params[ ] )
{
	new	rows,fields,string[70],string1[128],string2[128],string4[128],string5[128],string7[128],string8[128],string9[128],string77[128],string99[128];
	new Admin,tester,PlayingHours,Minutes,FactionMod,ZombieKill,MaskID,Gender,Interior,World,Job,Skin1;
	new Float:PosX,Float:PosY,Float:PosZ,Float:PosA,Origin[32],Birthdate[32],Role[32];
	DCC_TriggerBotTypingIndicator(discordlog);
	cache_get_data( rows, fields );
	if ( rows )
	{	
		Admin			= cache_get_field_content_int( 0, "Admin");
		tester			= cache_get_field_content_int( 0, "Tester");
		PlayingHours	= cache_get_field_content_int( 0, "PlayingHours");
		Minutes			= cache_get_field_content_int( 0, "Minutes");
		FactionMod		= cache_get_field_content_int( 0, "FactionMod");
		ZombieKill		= cache_get_field_content_int( 0, "ZombieKill");
		MaskID			= cache_get_field_content_int( 0, "MaskID");
		Gender			= cache_get_field_content_int( 0, "Gender");
		Interior		= cache_get_field_content_int( 0, "Interior");
		World			= cache_get_field_content_int( 0, "World");
		Job				= cache_get_field_content_int( 0, "Job");
		Skin1			= cache_get_field_content_int( 0, "Skin");
		PosX			= cache_get_field_float(0, "PosX");
		PosY			= cache_get_field_float(0, "PosY");
		PosZ			= cache_get_field_float(0, "PosZ");
		PosA			= cache_get_field_float(0, "PosA");
		cache_get_field_content(0, "Origin", Origin, g_iHandle,32);
		cache_get_field_content(0, "Birthdate",Birthdate, g_iHandle,32);
		cache_get_field_content(0, "Role",Role, g_iHandle,32);
		
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string9, sizeof(string9), "Cr�e ya: %s		Dernier Login ya: %s", GetDuration1(gettime() - cache_get_field_int(0, "CreateDate")),GetDuration1(gettime() - cache_get_field_int(0, "LastLogin")));
		format(string1, sizeof(string1), "**Joueur %s**",params);
		format(string4, sizeof(string4), "Admin: %s		Testeur+: %s	Faction Manangement: %s",(Admin) ? ("Oui") : ("Non"),(tester) ? ("Oui") : ("Non"),(FactionMod) ? ("Oui") : ("Non"));   
		format(string2, sizeof(string2), "Sexe: %s		Anniv: %s		Origine: %s",(Gender) ? ("Femme") : ("Homme"),Birthdate,Origin);
		format(string5, sizeof(string5), "Heures Jouer: %d	Minutes: %d	Job: %s		MaskID: %d",PlayingHours,Minutes,Job_GetName(Job),MaskID);
		format(string7, sizeof(string7), "derni�re pos: %.4f, %.4f, %.4f, %.4f",PosX,PosY,PosZ,PosA); 
		format(string8, sizeof(string8), "Interieur: %d		VirtualWorld: %d	ZombieKill: %d	RoleID : %s",Interior,World,ZombieKill,Role); 
		utf8encode(string99,string9,sizeof(string99));
		utf8encode(string77,string7,sizeof(string77));
		Embed = DCC_CreateEmbed(string1,string99);
		DCC_AddEmbedField(Embed ,string4,string2);
		DCC_AddEmbedField(Embed ,string5,string8);
		DCC_AddEmbedField(Embed ,string77,"----------------------SKIN IMAGE------------------------------------");
		DCC_SetEmbedColor(Embed,0xFF0000);
		format(string, sizeof(string), "https://gtaundergroundmod.com/resources/media/skins/%d.png",Skin1);
		DCC_SetEmbedImage(Embed,string);
		DCC_SendChannelEmbedMessage(discordaaa, Embed);
	}
	else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Se joueur n'existe pas dans la BDD.");
	return 1;
}
script OnBanLookupDC(username[])
{
	static rows,fields,reason[128],date[36],string[196],string3[196];
	cache_get_data(rows, fields, g_iHandle);
	if (rows) {
	    cache_get_field_content(0, "Reason", reason, g_iHandle);
	    cache_get_field_content(0, "Date", date, g_iHandle);
		DCC_TriggerBotTypingIndicator(discordlog);
		format(string, sizeof(string), "```Ce joueur a �t� banni le %s, raison: %s```", username, date, reason);
		utf8encode(string3,string,sizeof(string3));
		DCC_SendChannelMessage(discordlog,string3); 
	}
	else {
		DCC_TriggerBotTypingIndicator(discordlog);
		format(string, sizeof(string), "```Ce joueur n'est pas banni de ce serveur.```", username);
	    DCC_SendChannelMessage(discordlog,string); 
	}
	return 1;
}