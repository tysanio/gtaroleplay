CMD:dc(playerid,params[])
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
		SendServerMessage(playerid,"Chat discord mis à on /dc pour ecrire!");
		SendServerMessage(playerid,"Attention /dc [texte] pour voir les messages ooc seulement!");
		//SendServerMessage(playerid,"Attention le /fac [texte] fera en sorte que vous voyez les messages de votre faction seulement!");
		return 1;
	}
	else
	{
		PlayerData[playerid][pDiscordChat] = 0;
		SendServerMessage(playerid,"Chat discord mis à off vous ne recevrez plus les messages discord.");
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
	else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
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
			TextDrawHideForAll(gServerTextdraws[1]);
			g_ServerRestart = 0;
			g_RestartTime = 0;
			return SendClientMessageToAllEx(COLOR_LIGHTRED, "[DISCORD]: Un admin sur discord a commencer un restart du serveur.");
		}
		DCC_TriggerBotTypingIndicator(discordaaa);
		TextDrawShowForAll(gServerTextdraws[1]);
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
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** !jail [playerid/name] [minutes] [raison]");
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
		SendAdminAction(userid, "Un admin discord vous à mis en prison admin pour %d minutes (%s).", minutes, reason);
		SendClientMessageToAllEx(COLOR_LIGHTRED, "[Discord]: un admin discord à mis en prison admin %s pour %d minutes raison: %s", ReturnName(userid, 0), minutes, reason);
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
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** !dejail [playerid/nom]");
		if (userid == INVALID_PLAYER_ID)
			return DCC_SendChannelMessage(discordaaa,"Vous avez mis un [id/nom] invalide.");
		if (!PlayerData[userid][pJailTime])
			return DCC_SendChannelMessage(discordaaa,"Joueur non prisonnier.");
		DCC_TriggerBotTypingIndicator(discordaaa);
		PlayerData[userid][pJailTime] = 1;
		TogglePlayerControllable(userid, 1);
		format(string, sizeof(string), "Vous avez sortie de prison %s.", ReturnName(userid, 0));
		DCC_SendChannelMessage(discordaaa,string);	
		SendAdminAction(userid, "Un admin discord vous a libéré.");
		Log_Write("logs/jail_log.txt", "[%s] %s a libere %s .", ReturnDate(),ReturnDate(), ReturnDiscordName( author ), ReturnName(userid, 0));
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
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** !stats [playerid/nom]");
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
			return DCC_SendChannelMessage(discordaaa,"> **[USAGE]** !ostats [nom]");
		static query[1024];
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
		mysql_tquery(g_iHandle, query, "OnPlayerDiscordStats", "ds", INVALID_PLAYER_ID, params);
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
		DCC_TriggerBotTypingIndicator(discordaaa);
		if (isnull(params) || strlen(params) > 24) DCC_SendChannelMessage( discordaaa, "> **[USAGE]** !baninfo [nom de l'utilisateur]");
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
		format(string3, sizeof(string3),"Electronique : %s\nPétrol: %s\nL'essence Générateur : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfopetrol]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator]));
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
		    DCC_SendChannelMessage( discordaaa,"> **[USAGE]** !supprimner [type]");
			DCC_SendChannelMessage( discordaaa, "> [Type]:perso, compte");
			return 1;
	    }
		else if (!strcmp(type, "perso", true))
		{
			DCC_TriggerBotTypingIndicator(discordaaa);
			if (isnull(params) || strlen(params) > 24)
				return DCC_SendChannelMessage( discordaaa,"> **[USAGE]** !supprimer perso [nom du perso]");
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
	DCC_TriggerBotTypingIndicator(discordaaa);
	format(origin, 32, "%.16s",PlayerData[userid][pOrigin]);
	if (strlen(PlayerData[userid][pOrigin]) > 16)
		strcat(origin, "...");
	format(string1, sizeof(string1), "**Joueur IG %s (ID: %d)**", ReturnName(userid), userid);
	format(string2, sizeof(string2), "Admin: %s Testeur+: %s, Faction Manangement: %s", (PlayerData[userid][pAdmin]) ? ("Oui") : ("Non"), (PlayerData[userid][pTester]) ? ("Oui") : ("Non"), (PlayerData[userid][pFactionMod]) ? ("Oui") : ("Non"));
	format(string3, sizeof(string3), "Sexe: %s Anniv: %s Origine: %s", (PlayerData[userid][pGender] == 2) ? ("Femme") : ("Homme"),PlayerData[userid][pBirthdate], origin);
	format(string4, sizeof(string4), "Heure de jouée: %d Job: %s Inventaire: %d/%d",PlayerData[userid][pPlayingHours], Job_GetName(PlayerData[userid][pJob]), count,PlayerData[userid][pCapacity]);
	Embed = DCC_CreateEmbed(string1,"----------------------Info du personnage enligne------------------");
	DCC_AddEmbedField(Embed ,string2,string3);
	utf8encode(string44,string4,sizeof(string44));
	DCC_AddEmbedField(Embed ,string44,"");
	DCC_SetEmbedColor(Embed,0x00FF00);
	format(string, sizeof(string), "https://gtaundergroundmod.com/resources/media/skins/%d.png",PlayerData[userid][pSkin]);
	DCC_SetEmbedThumbnail(Embed,string);		
	DCC_SendChannelEmbedMessage(discordaaa, Embed);
	return 1;
}
/*script DCC_OnGuildMemberAdd(DCC_Guild:guild, DCC_User:user)
{
	DCC_SendChannelMessage(discordlog,"**[Nouveau sur discord]** !aide pour la liste des commandes, pour te faire verifier et avoir acces il faut t'inscrire IG.");
	return 1;
}*/
script OnPlayerDiscordStats( playerid, params[ ] )
{
	new	rows,fields,string[70],string1[128],string2[128],string4[128],string5[128],string7[128],string8[128],string9[128],string77[128],string99[128];
	new Admin,tester,PlayingHours,Minutes,FactionMod,MaskID,Gender,Interior,World,Job,Skin1;
	new Float:PosX,Float:PosY,Float:PosZ,Float:PosA,Origin[32],Birthdate[32];
	DCC_TriggerBotTypingIndicator(discordlog);
	cache_get_data( rows, fields );
	if ( rows )
	{	
		Admin			= cache_get_field_content_int( 0, "Admin");
		tester			= cache_get_field_content_int( 0, "Tester");
		PlayingHours	= cache_get_field_content_int( 0, "PlayingHours");
		Minutes			= cache_get_field_content_int( 0, "Minutes");
		FactionMod		= cache_get_field_content_int( 0, "FactionMod");
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
		
		
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string9, sizeof(string9), "Crée ya: %s		Dernier Login ya: %s", GetDuration1(gettime() - cache_get_field_int(0, "CreateDate")),GetDuration1(gettime() - cache_get_field_int(0, "LastLogin")));
		format(string1, sizeof(string1), "**Joueur %s**",params);
		format(string4, sizeof(string4), "Admin: %s Testeur+: %s Faction Manangement: %s",(Admin) ? ("Oui") : ("Non"),(tester) ? ("Oui") : ("Non"),(FactionMod) ? ("Oui") : ("Non"));   
		format(string2, sizeof(string2), "Sexe: %s Anniv: %s Origine: %s",(Gender == 2) ? ("Femme") : ("Homme"),Birthdate,Origin);
		format(string5, sizeof(string5), "Heures Jouer: %d	Minutes: %d	Job: %s",PlayingHours,Minutes,Job_GetName(Job));
		format(string7, sizeof(string7), "dernière pos: %.4f, %.4f, %.4f, %.4f",PosX,PosY,PosZ,PosA); 
		format(string8, sizeof(string8), "Interieur: %d	VirtualWorld: %d MaskID: %d",Interior,World,MaskID); 
		utf8encode(string99,string9,sizeof(string99));
		utf8encode(string77,string7,sizeof(string77));
		Embed = DCC_CreateEmbed(string1,string99);
		DCC_AddEmbedField(Embed ,string4,string2);
		DCC_AddEmbedField(Embed ,string5,string8);
		DCC_AddEmbedField(Embed ,string77,"");
		DCC_SetEmbedColor(Embed,0xFF0000);
		format(string, sizeof(string), "https://gtaundergroundmod.com/resources/media/skins/%d.png",Skin1);
		DCC_SetEmbedThumbnail(Embed,string);
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
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string, sizeof(string), "```Ce joueur a été banni le %s, raison: %s```", username, date, reason);
		utf8encode(string3,string,sizeof(string3));
		DCC_SendChannelMessage(discordaaa,string3); 
	}
	else {
		DCC_TriggerBotTypingIndicator(discordaaa);
		format(string, sizeof(string), "```Ce joueur n'est pas banni de ce serveur.```", username);
	    DCC_SendChannelMessage(discordaaa,string); 
	}
	return 1;
}
new DCC_Message:StatMessage = DCC_Message:0,StatTarget;
DeleteSavedStatMessage()
{
    DCC_DeleteInternalMessage(StatMessage); // We no longer need the stored message.
    StatMessage = DCC_Message:0;
}
public DCC_OnMessageReaction(DCC_Message:message, DCC_User:reaction_user, DCC_Emoji:emoji, DCC_MessageReactionType:reaction_type)
{
    new DCC_Channel:channel, bool:bot,str[1300],str1[1300];
    DCC_GetMessageChannel(message, channel);

    if(reaction_type == REACTION_ADD)
    {
        if(!DCC_IsUserBot(reaction_user, bot)) return 1;
        if(bot) return 1;

        if(StatMessage == message && _:StatMessage != 0)
        {
            new emoji_name[DCC_EMOJI_NAME_SIZE];
            DCC_GetEmojiName(emoji, emoji_name);
            new name[MAX_PLAYER_NAME];
            GetPlayerName(StatTarget, name, MAX_PLAYER_NAME);

            new DCC_Embed:embed = DCC_CreateEmbed();
            if(!strcmp("👢", emoji_name))
            {
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff1,sistaff1ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff2,sistaff2ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff3,sistaff3ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff4,sistaff4ok);
				if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
				{
					DCC_SetEmbedTitle(embed, "KICK! 👢");
					DCC_SetEmbedColor(embed, 0xFF0000);
					format(str, sizeof str, "Joueur %s (%d) a été kick du serveur!", name, StatTarget);
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					SendErrorMessage(StatTarget,"Tu as été kick via le discord");
					KickEx(StatTarget);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji");
            }
            else if(!strcmp("🔨", emoji_name))
            {
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff2,sistaff2ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff3,sistaff3ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff4,sistaff4ok);
				if (sistaff2ok || sistaff3ok || sistaff4ok)
				{
					Dialog_Show(StatTarget, ShowOnly, DIALOG_STYLE_MSGBOX, "Ban", "Tu as été bannie.\nJoueur: %s\nVia le discord\nL'admin qui ta ban: %s\n\nAppuyer F8 si c'est une erreur.", "Fermer", "", ReturnName(StatTarget,0),ReturnDiscordName( reaction_user ));
					SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a ete banni par %s via discord.", PlayerData[StatTarget][pUsername],ReturnDiscordName( reaction_user ));
					Blacklist_Add(PlayerData[StatTarget][pIP], PlayerData[StatTarget][pUsername],ReturnDiscordName( reaction_user ),"Via Discord");
					DCC_SetEmbedTitle(embed, "BANNI! 🔨");
					DCC_SetEmbedColor(embed, 0xFF0000);
					format(str, sizeof str, "Joueur %s (%d) a été banni du serveur!", name, StatTarget);
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_SetEmbedDescription(embed, str);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji");
            }
			else if(!strcmp("❄️", emoji_name)) 
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff1,sistaff1ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff2,sistaff2ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff3,sistaff3ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff4,sistaff4ok);
				if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
				{
					DCC_SetEmbedTitle(embed, "DEBUG! ❄️");
					DCC_SetEmbedColor(embed, 0xFF0000);
					SendErrorMessage(StatTarget,"Tu as été débug via le discord");
					format(str, sizeof str, "Joueur %s (%d) a été débug!", name, StatTarget);
					utf8encode(str1,str,sizeof(str1));
					SendAdminAction(StatTarget, "Un admin discord vous a debug.");
					SetPlayerVirtualWorld(StatTarget,0);
					SetPlayerInterior(StatTarget,0);
					DCC_SetEmbedDescription(embed, str1);
					DCC_SetEmbedDescription(embed, str);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji");
			}			
			else if(!strcmp("🌪️", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff1,sistaff1ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff2,sistaff2ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff3,sistaff3ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff4,sistaff4ok);
				if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
				{
					DCC_SetEmbedTitle(embed, "RESPAWN! 🌪️");
					DCC_SetEmbedColor(embed, 0xFF0000);
					format(str, sizeof str, "Joueur %s (%d) a été respawn!", name, StatTarget);
					utf8encode(str1,str,sizeof(str1));
					SendErrorMessage(StatTarget,"Tu as été respawn via le discord");
					RespawnPlayer(StatTarget);
					DCC_SetEmbedDescription(embed, str1);
					DCC_SetEmbedDescription(embed, str);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji");
			}
			else if(!strcmp("🇨", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide chat");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- /me Sert a effectuer une action,\n- /do Sert pour confirmer ou décrire une action,\n- /(c)rier Sert a crier\n- /(o)oc Sert a parlez en Out of Character,\n- /decrocher Sert a décrocher son téléphone\n- /racrocher Sert a racrocher son téléphone\n- /dc pour le chat discord\n- /discordchat pour active le chat```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}
			else if(!strcmp("🇲", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide maison");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- /vendre pour vendre une maison,\n- /abandonner Pour abandonner votre maison sans gagner d'argent dessus\n- /porte Pour fermer la porte de la maison,\n- /mcoffre Pour voir le coffre de la maison\n- /fourniture Pour pouvoir bouger vos meubles\n- /acheteretagere Pour acheter une étagère\n- /armeetagere Pour poser une arme sur une étagère\n- /supetagere Pour supprimer une étagère\n- /sonner Pour sonner a la porte d'une maison\n- /lumiere Pour allumer la lumiere dans la maison\n- /cuisiner pour cuisiner un repas congelén- /locamax pour définir le max de locataire\n- /locaprix pour définir le prix de la locations\n- /(de)louermaison pour louer une maison ou délouer celle-ci```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}			
			else if(!strcmp("🇬", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide General");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- /banque pour ouvrir le menu de la banque,\n- /payer pour payer un joueur,\n- /donnerarme pour donner une arme a un joueur,\n- /serrermain pour demander un serrage de main,\n- /volerbanque pour voler la banque,\n- /voleritem voler un item dans un magasin,\n- /ouvrircargaison pour ouvrir une boite,\n- /boombox pour mettre une musique,\n- /montrerpermis Pour montrer vos permis à un joueur,\n- /boite savoir le nombre de cargaisons dans un vehicule,\n- /planter pour pouvoir planter de la drogue,\n- /recolter Pour recolter une plante de drogue poussee\n- /trousse pour utiliser un kit de premier soin,\n- /crocheterporte pour forcer une porte d'un vehicule,\n- /fouiller pour fouiller dans l'inventaire d'un joueur,\n- /freq pour choisir le channel de votre talkie-walkie,\n- /chargeur pour charger votre arme avec des munitions,\n- /usemag pour utiliser un seul chargeur dans votre inventaire pour votre arme,\n- /carte Montrer sa carte d'indentité, \n- /tme [texte] Pour une description de votre personage (120 charactere de max)\n- /quitjob pour quitter son job actuel,\n- /tmeoff pour enlever le tme\n- /zkill pour les skills de vos armes et le nombre de zombie tuée\n- /credits pour voir les credits```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}			
			else if(!strcmp("🇩", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide Divers");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- /proprieter pour voir se que vous êtes le proprietaire,\n- /stats pour afficher les statistiques de votre personnage,\n- /changermdp pour changer de mot de passe\n- /dernièrefois Pour connaitre la dernière connection d'un joueur,\n- /acc pour enlever ou mettre vos accessoire,\n- /rapport pour rapporte un mefait,\n- /bjstart pour commencer le blackjack,\n- /bjstop pour stop le black jack,\n- /supporteurs pour avoir la liste des helpeurs disponible,\n- /roulette pour jouer a la roulette au casino\n- /monpanneau pour afficher les options du panneau\n- /enlevercp pour enlever tout checkpoint sur votre carte,\n- /stopanim pour stopper une animation en cours,\n- /animcmds Pour la liste des animations,\n- /resetvw Remet a 0 votre virtualWorld,\n- /distancec pour voir la distance du commissariat,\n- /bowlingstats pour avoir votre résultat du bowling,\n- /jeter pour jeter une arme,\n- /stylecombat choisir votre style de combat,\n- /discordverif pour se faire vérifier discord```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}			
			else if(!strcmp("🇻", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide Véhicule");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- /porte Pour fermer les portes du vehicule\n- /vendre pour vendre un véhicule,\n- /remplir Pour faire le plein de votre véhicule\n- /enlevertunning Pour enlever le tuning du véhicule\n- /vcoffre Pour ouvrir le coffre du véhicule\n- /demarrer ou appuyer sur ctrl Pour demarrer le moteur du véhicule\n- /phare ou appuyer sur é Pour allumer les phares du véhicule\n- /crocheterporte Pour forcer la porte d'un véhicule\n- /capot Pour ouvrir le capot du véhicule\n- /vitre Pour ouvrir et fermer la fenetre du véhicule\n- /ceinture pour attacher votre ceinture,\n- /trafiquerfils pour voler un véhicule,\n- /louerveh pour louer un véhicule,\n- /delouerveh pour delouer un véhicule (attention a etre a la bonne place pour cela,\n- /vpreter voir le véhicule qu'on vous a preté, \n- /vdouble Pour preter les cles de votre véhicule,\n- /vjeter pour jetter le double des clés preter,\n- /payersabot pour payer le sabot du véhicule,\n- /achetergarage pour acheter un garage,\n- /garage pour aller dans votre garage```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}			
			else if(!strcmp("🇧", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide Biz");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- /vendre pour vendre un magasin,\n- /abandonner Pour abandonner votre magasin sans gagner d'argent dessus\n- /porte Pour fermer la porte du magasin,\n- /bcoffre Pour voir le coffre du magasin\n- /produits Pour changer les prix des marchandises\n- /binfo Pour voir l'information du magasin\n- /bnom Pour changer le nom du magasin\n- /bmessage Pour changer le message du magasin\n- /accepterlivraison Faire une livraison de votre biz\n- /bheures définir les heures d'ouverture de votre magasin```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}
			else if(!strcmp("🧩", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleJoueur,simembreroleok);
				if (simembreroleok)
				{
					DCC_SetEmbedTitle(embed, "Aide Discord");
					DCC_SetEmbedColor(Embed,0x00FF00);
					format(str, sizeof(str), "```- !ostats [Nom du joueur] affiche les stats du joueur depuis la bdd\n- !stats [id] voir des stats de joueur en ligne\n- !c [texte] pour parler de façons ooc au serveur\n- !jail [id] jail un joueur IG\n- !dejail [id] déjail un joueur IG\n- !restart restart le serveur\n- !rapports voir les rapports non répondu IG\n- !voir [ID] voir un joueur IG\n- !players pour voir les joueurs connecter\n- !baninfo [nom du personage] pour voir les infos du bannie\n- !stockjob pour voir les stocks des jobs\n- !caissedetat voir l'argent de l'état\n- !supprimer pour pouvoir supprimer un compte ou un personnage\n- !ping pour savoir si le serveur est tjrs on\n- !factionlist liste des factions sur le serveur.\n- !listemort la liste des morts sur le serveur\n- !abus pour savoir pourquoi une action a été entreprise par les devs\n !apps pour voir les question au joueur nouvellement inscrie```");
					utf8encode(str1,str,sizeof(str1));
					DCC_SetEmbedDescription(embed, str1);
					DCC_EditMessage(message, "", embed);
					DCC_DeleteMessageReaction(message);
					DeleteSavedStatMessage();
				}
				else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}
			else if(!strcmp("✅", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff1,sistaff1ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff2,sistaff2ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff3,sistaff3ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff4,sistaff4ok);
				if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
				{
					if(PlayerData[StatTarget][pTutorialStage] != 5) return DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Se joueur n'est pas dans le tutoriel");	
					SendServerMessage(StatTarget,"Votre demande viens d'être accepté par un admin sur discord.");
					TogglePlayerControllable(StatTarget, 1);
					PlayerData[StatTarget][pTutorialStage] = 6;
					PlayerData[StatTarget][pNoob] = 2;
					SetPlayerCheckpoint(StatTarget, -228.8403, 1401.1831, 27.7656, 2.0);
					tuto1 = "\0";
					tuto2 = "\0";
					tuto3 = "\0";
					tuto4 = "\0";
				}
				else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}
			else if(!strcmp("❎", emoji_name))
			{
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff1,sistaff1ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff2,sistaff2ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff3,sistaff3ok);
				DCC_HasGuildMemberRole(GUILD_ID1,reaction_user,RoleStaff4,sistaff4ok);
				if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
				{
					if(PlayerData[StatTarget][pTutorialStage] != 5) return DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Se joueur n'est pas dans le tutoriel");
					SendServerMessage(StatTarget,"Votre demande viens d'être refusé par un admin sur discord.");
					PlayerData[StatTarget][pNoob] = 1;
					tuto1 = "\0";
					tuto2 = "\0";
					tuto3 = "\0";
					tuto4 = "\0";
					KickEx(StatTarget);
				}
				else DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Ta pas le droit d'utiliser cette emoji!");
				return 1;
			}
            else
            {
                DCC_DeleteEmbed(embed);
            }
        }
    }
    printf("reaction type %d", _:reaction_type);
    return 1;
}
SendErrorEmbedMessage(DCC_Channel:channel, const error_message[])
{
	new DCC_Embed:embed = DCC_CreateEmbed("ERREUR!");
    DCC_SetEmbedColor(embed, 0xFF0000);
    DCC_SetEmbedDescription(embed, error_message);
    DCC_SendChannelEmbedMessage(channel, embed);
	return 1;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
    new content[DCC_ID_SIZE], DCC_User:author;
    DCC_GetMessageContent(message, content);
    DCC_GetMessageChannel(message, discordaaa);
    DCC_GetMessageAuthor(message, author);
    
    new bool:is_bot;
	if (!DCC_IsUserBot(author, is_bot)) return 0; //invalid user

	if(is_bot) return 0;

	new command_name[25], params[150];
    if(sscanf(content, "s[25]S()[150]", command_name, params))
    {
		return 0;
    }
    if(!strcmp(command_name, "!voir", true))
    {
		new target;
        if(sscanf(params, "u", target))
        {
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
			if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
			{
				SendErrorEmbedMessage(discordaaa, "**[USAGE]** !voir [PLAYER_ID/NOM]");
			}
			else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette commande");
			return 1;
        }
        else if(target == INVALID_PLAYER_ID)
        {
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
			DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
			if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
			{
				SendErrorEmbedMessage(discordaaa, "> **[ERREUR]** Joueur non connecte!");
			}
			else DCC_SendChannelMessage(discordlog, "> **[ERREUR]** Ta pas le droit d'utiliser cette commande");            
			return 1;
        }
        
        new name[MAX_PLAYER_NAME], skin_image[200], Float:health, Float:armour, weapon_name1[30], str[50];
        GetPlayerName(target, name, MAX_PLAYER_NAME);
        GetPlayerHealth(target, health);
        GetPlayerArmour(target, armour);
        GetWeaponName(GetPlayerWeapon(target), weapon_name1, 30);
        if(!strlen(weapon_name1))
        {
			format(weapon_name1, sizeof weapon_name1, "Poing");
        }
        format(skin_image, sizeof skin_image, "https://gtaundergroundmod.com/resources/media/skins/%d.png", GetPlayerSkin(target));
        
        new DCC_Embed:embed = DCC_CreateEmbed();
        format(str, sizeof str, "%s's stats.", name);
        DCC_SetEmbedTitle(embed, str);
        DCC_SetEmbedThumbnail(embed, skin_image);
        
        format(str, sizeof str, "%0.1f", health);
        DCC_AddEmbedField(embed, "Vie", str, true);
        
        format(str, sizeof str, "%0.1f", armour);
        DCC_AddEmbedField(embed, "Armure", str, true);

        DCC_AddEmbedField(embed, "Arme", weapon_name1, true);
		DCC_AddEmbedField(embed, "", "👢 = kick \n🔨 = Ban \n❄️ = debug\n🌪 = respawn", true);

		DCC_SendChannelEmbedMessage(discordaaa, embed, "", "OnPostPlayerStat", "i", target);
		return 1;
	}
    else if(!strcmp(command_name, "!aide", true))
    {
		DCC_HasGuildMemberRole(GUILD_ID1,author,RoleJoueur,simembreroleok);
		if (simembreroleok)
		{
			new DCC_Embed:embed = DCC_CreateEmbed();
			DCC_SetEmbedTitle(embed, "Commandes d'aide");
			DCC_SetEmbedColor(Embed,0x00FF00);
			DCC_AddEmbedField(embed, "", "🇨 = Aide Chat \n🇲 = Aide Maison \n🇬 = Aide General\n🇩 = Aide Divers\n🇻 = Aide Vehicule\n🇧 Aide Biz\n🧩 = Aide Discord", true);

			DCC_SendChannelEmbedMessage(discordlog, embed, "", "OnPostAide");
		}
		else DCC_SendChannelMessage( discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
		return 1;
	}
	else if(!strcmp(command_name, "!apps", true))
	{
		static userid,string1[128],string2[1280],string22[1280];
		DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff1,sistaff1ok);
		DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff2,sistaff2ok);
		DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff3,sistaff3ok);
		DCC_HasGuildMemberRole(GUILD_ID1,author,RoleStaff4,sistaff4ok);
		if (sistaff1ok || sistaff2ok || sistaff3ok || sistaff4ok)
		{
			if (sscanf(params, "u", userid))
				return DCC_SendChannelMessage(discordaaa, "**[USAGE]** !apps [playerid/name]");
			if(PlayerData[userid][pTutorialStage] != 5) return DCC_SendChannelMessage(discordaaa, "> **[ERREUR]** Se joueur n'est pas dans le tutoriel");
			DCC_TriggerBotTypingIndicator(discordaaa);
			format(string1, sizeof(string1), "**Joueur IG %s (ID: %d)**", ReturnName(userid), userid);
			format(string2, sizeof(string2), "**Qu elle sont vos projets une fois en ville?**\n Reponse: %s\n**Qu est ce que le metagame?**\n Reponse: %s\n**Qu est ce que le powergame?**\n Reponse: %s\n**Qu est ce que le Roleplay?**\n Reponse: %s",tuto1,tuto2,tuto3,tuto4);
			Embed = DCC_CreateEmbed(string1,"----------------------Reponse de la personne------------------");
			utf8encode(string22,string2,sizeof(string22));
			DCC_AddEmbedField(Embed ,"",string22);
			DCC_SetEmbedColor(Embed,0x00FF00);
			DCC_SendChannelEmbedMessage(discordaaa, Embed, "", "OnPostJoueurApp", "i", userid);
		}
		else DCC_SendChannelMessage( discordlog, "> **[ERREUR]** Ta pas le droit de faire cette commande");
		return 1;
	}
    return 1;
}
script OnPostPlayerStat(playerid)
{
	new DCC_Message:message = DCC_GetCreatedMessage();
    if(StatMessage != DCC_Message:0 )
    {
        DCC_DeleteInternalMessage(StatMessage);
    }
	StatMessage = message;
    StatTarget = playerid;
    DCC_CreateReaction(message, DCC_CreateEmoji("👢"));
    DCC_CreateReaction(message, DCC_CreateEmoji("🔨"));
	DCC_CreateReaction(message, DCC_CreateEmoji("❄️"));  
	DCC_CreateReaction(message, DCC_CreateEmoji("🌪️"));  	
	DCC_SetMessagePersistent(message, true);
}
script OnPostAide()
{
	new DCC_Message:message = DCC_GetCreatedMessage();
    if(StatMessage != DCC_Message:0 )
    {
        DCC_DeleteInternalMessage(StatMessage);
    }
	StatMessage = message;
    DCC_CreateReaction(message, DCC_CreateEmoji("🇨"));
    DCC_CreateReaction(message, DCC_CreateEmoji("🇲"));
	DCC_CreateReaction(message, DCC_CreateEmoji("🇬"));  
	DCC_CreateReaction(message, DCC_CreateEmoji("🇩"));  	
	DCC_CreateReaction(message, DCC_CreateEmoji("🇻"));  	
	DCC_CreateReaction(message, DCC_CreateEmoji("🇧"));  	
	DCC_CreateReaction(message, DCC_CreateEmoji("🧩"));  	
	DCC_SetMessagePersistent(message, true);
}
script OnPostJoueurApp(playerid)
{
	new DCC_Message:message = DCC_GetCreatedMessage();
    if(StatMessage != DCC_Message:0 )
    {
        DCC_DeleteInternalMessage(StatMessage);
    }
	StatMessage = message;
	StatTarget = playerid;
    DCC_CreateReaction(message, DCC_CreateEmoji("✅"));
    DCC_CreateReaction(message, DCC_CreateEmoji("❎"));
	DCC_SetMessagePersistent(message, true);
}