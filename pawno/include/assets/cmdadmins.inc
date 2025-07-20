//commande admins
CMD:ahelp(playerid, params[])
{
	if (!PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Tu n'est pas dans les admins.");
	if (PlayerData[playerid][pAdmin] >= 1) {
	    SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /a, /rapports, /spec, /jail, /dejail, /gotocar.");
	    SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /goto, /envoyera, /clearchat, /aduty, /ban, /aremovecall.");
	    SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /masked, /amenerveh, /acceptname, /declinename, /a.");
		SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /x /y /z /renvoyer, /gotoactor.");
 	}
	if (PlayerData[playerid][pAdmin] >= 2) {
	    SendSyntaxMessage(playerid, "[LEVEL 2]:{FFFFFF} /entercar, /flipcar, /proche, /healall, /tracenumber, /blacklist.");
	    SendSyntaxMessage(playerid, "[LEVEL 2]:{FFFFFF} /afire, /akillfire, /adestroybox, /unban.");
	}
	if (PlayerData[playerid][pAdmin] >= 3) {
        SendClientMessage(playerid, COLOR_RED, "[LEVEL 3]:{FFFFFF} /asellmaison, /asellbiz, /jetpack, /setweather, /setfuel, /setcarhp, /itemlist.");
        SendClientMessage(playerid, COLOR_RED, "[LEVEL 3]:{FFFFFF} /setquantity, /supitem, /setinventory, /arepair, /givewep, /baninfo, /setitem.");
	}
	if (PlayerData[playerid][pAdmin] >= 4) {
        SendClientMessage(playerid, COLOR_BLUE, "[LEVEL 4]:{FFFFFF} /dynamichelp, /restart, /mcreate, /fairemdp");
		SendClientMessage(playerid, COLOR_BLUE, "[LEVEL 4]:{FFFFFF} /salaireanpe, /supaccount, /supperso, /panel, /serveur.");
	}
	return 1;
}
CMD:dynamichelp(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return 1;
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creermaison, /creerbiz, /creerentrer, /creerpump, /creercrate, /creerfaction, /creerbot, /creerobject");
    SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creergate, /creercar, /creervendor, /creergarbage,/creerdetector, /creerrack, /creercaisse, /creergarage.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creerbillboard, /creerspeed, /creergraffiti, /editrack, /editbillboard, /editentrer, /editfaction, /editgate, /editcaisse, /editobject.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /editpump, /supentrer, /supump, /supcrate, /supfaction, /supgate, /supcaisse, /supgraffiti /supgarage, /supobject.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /supgarbage, /suprack,  /supspeed, /supbiz, /suphouse, /supcrate.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /suplant, /supdetector, /supbillboard, /bizstate, /setpump.");
	return 1;
}
CMD:x(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;
	if(PlayerData[playerid][pAdmin] >= 1)
	{
		if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Utilisation: /x [Coordination]");
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPosEx(playerid, x+npos, y, z);
		return 1;
	}
	else return SendErrorMessage(playerid, "Vous n'êtes pas autorisé.");
}
CMD:y(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;
	if(PlayerData[playerid][pAdmin] >= 1)
	{
		if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Utilisation: /y [Coordination]");
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPosEx(playerid, x, y+npos, z);
		return 1;
	}
	else return SendErrorMessage(playerid, "Vous n'êtes pas autorisé.");
}
CMD:z(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;
	if(PlayerData[playerid][pAdmin] >= 1)
	{
		if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Utilisation: /z [Coordination]");
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPosEx(playerid, x, y, z+npos);
		return 1;
	}
	else return SendErrorMessage(playerid, "Vous n'êtes pas autorisé.");
}
CMD:aremovecall(playerid, params[])
{
	new vehicleid;
	if (PlayerData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "Vous devez être dans l'équipe d'adminitration pour faire cela.");
	if(sscanf(params, "i", vehicleid)) return SendErrorMessage(playerid, "Vous devez entré un ID de véhicule.");
    if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "ID de véhicule invalide.");
	Delete3DTextLabel(vehicle3Dtext[vehicleid]);
	return 1;
}
CMD:fairemdp(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 4) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/fairemdp [nom de l'utilisateur]");
	static query[128];
	mysql_format(g_iHandle, query, sizeof(query), "UPDATE accounts SET Password=md5('123456') WHERE `Username` = '%s'",SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query);
	SendServerMessage(playerid,"Modification du mot de passe pour le joueur %s par 123456 en nouveau mot de passe");
 	return 1;
}
CMD:a(playerid, params[])
{
	if (!PlayerData[playerid][pTester] && !PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Vous n'êtes pas un admin ou helpeur");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/a [admin text]");

	if (strlen(params) > 64) {
	    SendTesterMessage(COLOR_ADMINCHAT, "Staff %s: %.64s", ReturnName(playerid, 0), params);
		SendTesterMessage(COLOR_ADMINCHAT, "...%s", params[64]);
	}
	else {
	    SendAdminAlert(COLOR_ADMINCHAT, "Staff %s: %s",ReturnName(playerid, 0), params);
	}
	static string[128],string6[128];
	format(string, sizeof(string),"[%s] [Staff] %s : %s.", ReturnDate(), ReturnName(playerid, 0), params);
	utf8encode(string6,string,sizeof(string6));
	DCC_SendChannelMessage(discordaaa,string6);
	Log_Write("logs/adminchat_log.txt", "[%s] %s : %s", ReturnDate(),ReturnName(playerid),params);
	return 1;
}
CMD:aduty(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (!PlayerData[playerid][pAdminDuty])
	{
		SetPlayerColor(playerid, 0x33CC3300);
		PlayerData[playerid][pAdminDuty] = 1;
		/*SetPlayerKnockedOffBikeState(playerid, 1);
		SetPlayerFireProof(playerid, 1);*/
		SendClientMessageToAllEx(COLOR_GREEN, "** %s est en service admin (/rapport pour assistance). **", ReturnName(playerid, 0));
	}
	else
	{
	    SetPlayerColor(playerid, DEFAULT_COLOR);
		PlayerData[playerid][pAdminDuty] = 0;
		/*SetPlayerKnockedOffBikeState(playerid, 0);
		SetPlayerFireProof(playerid, 0);*/
		SendServerMessage(playerid, "Vous n'est plus en service admin.");
	}
	return 1;
}
CMD:rapports(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new count,text[128];
	for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (!ReportData[i][rExists])
			continue;
		strunpack(text, ReportData[i][rText]);
		SendClientMessageEx(playerid, COLOR_PINK, "[RID: %d] %s (ID: %d) reporte: %s", i, ReturnName(ReportData[i][rPlayer]), ReportData[i][rPlayer], text);
		count++;
	}
	if (!count)
	    return SendErrorMessage(playerid, "Aucun rapport.");
	SendServerMessage(playerid, "Utilisé \"/ar RID\" ou \"/dr RID\" pour accepter ou décliner le rapport.");
	return 1;
}

CMD:ar(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ar [rapport id] (/rapports pour la liste)");
	new reportid = strval(params),string[64],string1[128];
	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SendErrorMessage(playerid, "RID invalide, choisir un RID allant de 0 à %d.", MAX_REPORTS);
	format(string, sizeof(string), "Vous avez ~g~accepter~w~ le rapport (ID: %d.)", reportid);
	ShowPlayerFooter(playerid, string);
	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) accepte votre rapport.", ReturnName(playerid, 0), playerid);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s à accepté le rapport de %s.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	format(string1, sizeof(string1),"[ADMIN]: %s à accepte le rapport de %s.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	DCC_SendChannelMessage(discordaaa,string1);
	Report_Remove(reportid);
	return 1;
}
CMD:dr(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/dr [rapport id] (/rapports pour la liste)");
	new reportid = strval(params),string[64],string1[128];
	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SendErrorMessage(playerid, "RID invalide, choisir un RID allant de 0 à %d.", MAX_REPORTS);
	format(string, sizeof(string), "Vous avez ~r~decliner~w~ rapport (ID: %d.)", reportid);
	ShowPlayerFooter(playerid, string);
	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) a décliné votre rapport.", ReturnName(playerid, 0), playerid);
    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a décliné le rapport de %s'.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	format(string1, sizeof(string1),"[ADMIN]: %s a decline le rapport de %s'.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	DCC_SendChannelMessage(discordaaa,string1);
    Report_Remove(reportid);
	return 1;
}
CMD:spec(playerid, params[])
{
	new userid;
	if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (!isnull(params) && !strcmp(params, "off", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
			return SendErrorMessage(playerid, "Vous n'êtes plus en spec.");
	    PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
	    PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);
		HideSpecTextdraw(playerid);
		PlayerSpec[playerid] = INVALID_PLAYER_ID;
		SetWeapons(playerid);
	    SetSpawnInfo(playerid, 0, PlayerData[playerid][pSkin], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][3], 0, 0, 0, 0, 0, 0);
	    TogglePlayerSpectating(playerid, false);
	    return SendServerMessage(playerid, "Vous n'êtes plus en spec.");
	}
	if (sscanf(params, "u", userid))
		return SendSyntaxMessage(playerid, "/spec [playerid/name] - Tapez \"/spec off\" pour arreté.");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
		GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);
		PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
		PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
	}
	SetPlayerInterior(playerid, GetPlayerInterior(userid));
	UpdateWeapons(playerid);
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));
	TogglePlayerSpectating(playerid, 1);
	if (IsPlayerInAnyVehicle(userid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userid));
	else PlayerSpectatePlayer(playerid, userid);
	SendServerMessage(playerid, "Vous regardez %s (ID: %d).", ReturnName(userid, 0), userid);
	PlayerData[playerid][pSpectator] = userid;
	PlayerSpec[playerid] = userid;
	return 1;
}
CMD:jail(playerid, params[])
{
	static userid,minutes,reason[128];
	if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "uds[128]", userid, minutes, reason))
	    return SendSyntaxMessage(playerid, "/jail [playerid/name] [minutes] [raison]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (minutes < 1)
		return SendErrorMessage(playerid, "Tu ne peut mettre en prison pour zero minute ou moins.");
	if (minutes > 30 && PlayerData[playerid][pTester] && !PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Jail pour 30 minute max.");
	ClearAnimations(userid);
	PlayerTextDrawShow(userid, PlayerData[userid][pTextdraws][70]);
    SetPlayerPosEx(userid,2487.8855,-1668.9358,1140.8169);
    SetPlayerInterior(userid, 3);
	SetPlayerVirtualWorld(userid, (playerid + 100));
 	SetPlayerFacingAngle(userid, 0.0);
	SetCameraBehindPlayer(userid);
	TogglePlayerControllable(userid, 0);
	ResetWeapons(userid);
    ShowHungerTextdraw(userid, 0);
	ResetPlayer(userid);
	PlayerData[userid][pJailTime] = minutes * 60;
	PlayerData[userid][pPrisoned] = 0;
	SendAdminAction(playerid, "Vous avez mis en prison admin %s pour %d minutes (%s).", ReturnName(userid, 0), minutes, reason);
	SendAdminAction(userid, "%s vous à mis en prison admin pour  %d minutes (%s).", ReturnName(playerid, 0), minutes, reason);
	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s à mis en prison admin %s pour %d minutes raison: %s", ReturnName(playerid, 0), ReturnName(userid, 0), minutes, reason);
	static string[128],string6[128];
	format(string, sizeof(string),"[%s] %s a mis en prison admin %s pour %d minutes, raison: %s.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), minutes, reason);
	utf8encode(string6,string,sizeof(string6));
	DCC_SendChannelMessage(discordspam,string6);
	return 1;
}
CMD:dejail(playerid, params[])
{
	static userid;
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/dejail [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (!PlayerData[userid][pJailTime])
	    return SendErrorMessage(playerid, "Joueur non prisonnier.");
	PlayerData[userid][pJailTime] = 1;
	TogglePlayerControllable(playerid, 1);
	SendAdminAction(playerid, "Vous avez sortie de prison %s.", ReturnName(userid, 0));
	SendAdminAction(userid, "%s vous a libéré.", ReturnName(playerid, 0));
	static string[128],string6[128];
	format(string, sizeof(string),"[%s] %s a libéré %s .", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0));
	utf8encode(string6,string,sizeof(string6));
	DCC_SendChannelMessage(discordspam,string6);
	return 1;
}
CMD:respawn(playerid, params[])
{
	static userid;
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/respawn [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (!IsPlayerSpawned(userid))
	    return SendErrorMessage(playerid, "Ca ne fonctionne pas.");
	RespawnPlayer(userid);
	SendAdminAction(playerid, "Vous avez respawn %s.", ReturnName(userid, 0));
	SendAdminAction(userid, "Vous avez été respawn par %s.", ReturnName(playerid, 0));
	return 1;
}
CMD:ban(playerid, params[])
{
	static userid,reason[128];
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "us[128]", userid, reason))
	    return SendSyntaxMessage(playerid, "/ban [playerid/nom] [raison]");
    if (userid == INVALID_PLAYER_ID || (IsPlayerConnected(userid) && PlayerData[userid][pKicked]))
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te ban toi-même du serveur.");
    if (PlayerData[userid][pAdmin] > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "L'admin est plus fort que toi.");
 	foreach (new i : Player) {
		if (!strcmp(PlayerData[i][pIP], PlayerData[userid][pIP]) && i != userid) {
		    KickEx(i);
		}
	}
	Dialog_Show(userid, ShowOnly, DIALOG_STYLE_MSGBOX, "Ban", "Tu a été bannie.\n\nJoueur: %s\nRaison: %s\nL'admin qui ta ban: %s\n\nAppuyer F8 si c'est une erreur.", "Fermer", "", PlayerData[userid][pUsername], reason, ReturnName(playerid, 0));
	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a été banni par %s raison: %s.", ReturnName(userid, 0), ReturnName(playerid, 0), reason);
	static string[128],string6[128];
	format(string, sizeof(string),"[%s] %s a été banni par %s raison: %s.", ReturnDate(), ReturnName(userid, 0), ReturnName(playerid, 0), reason);
	utf8encode(string6,string,sizeof(string6));
	DCC_SendChannelMessage(discordspam,string6);
	Blacklist_Add(PlayerData[userid][pIP], PlayerData[userid][pUsername], PlayerData[playerid][pUsername], reason);
	KickEx(userid);
	return 1;
}
CMD:goto(playerid, params[])
{
	static id,type[24],string[64];
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", id))
 	{
	 	SendSyntaxMessage(playerid, "/goto [playerid/nom]");
		SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} prison, house, biz, entrance, job, gate, interior, billboard");
		return 1;
	}
    if (id == INVALID_PLAYER_ID)
	{
	    if (sscanf(params, "s[24]S()[64]", type, string))
		{
		    SendSyntaxMessage(playerid, "/goto [player or name]");
			SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} car, prison, house, business, entrer, job, gate, interior, billboard");
			return 1;
	    }
		else if (!strcmp(type, "prison", true))
		{
	        SetPlayerPosEx(playerid, 283.5930, 1413.3511, 10.4078);
	        SetPlayerFacingAngle(playerid, 180.0000);
	        SetPlayerInterior(playerid, 0);
	        SetPlayerVirtualWorld(playerid, 0);
	        return SendServerMessage(playerid, "Vous avez été téléporté a la prison.");
		}
		else if (!strcmp(type, "billboard", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [billboard] [billboard ID]");

			if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !BillBoardData[id][bbExists])
			    return SendErrorMessage(playerid, "Vous avez spécifier un ID de billboard invalide.");

		    SetPlayerPosEx(playerid, BillBoardData[id][bbPos][0], BillBoardData[id][bbPos][1], BillBoardData[id][bbPos][2]);
		    SendServerMessage(playerid, "Vous avez été téleporté au billboard (ID: %d.)", id);
		    return 1;
		}
		else if (!strcmp(type, "house", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [house] [maison ID]");
			if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
			    return SendErrorMessage(playerid, "Vous avez spécifier un ID de maison invalide.");
		    SetPlayerPosEx(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
		    SetPlayerInterior(playerid, HouseData[id][houseExterior]);
			SetPlayerVirtualWorld(playerid, HouseData[id][houseExteriorVW]);
		    SendServerMessage(playerid, "Vous avez été téleporté à la maison (ID: %d.)", id);
		    return 1;
		}
		else if (!strcmp(type, "biz", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [biz] [biz ID]");
			if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
			    return SendErrorMessage(playerid, "Vous avez spécifier un ID de biz invalide.");
		    SetPlayerPosEx(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2]);
		    SetPlayerInterior(playerid, BusinessData[id][bizExterior]);
			SetPlayerVirtualWorld(playerid, BusinessData[id][bizExteriorVW]);
		    SendServerMessage(playerid, "Vous avez été téleporté au biz (ID: %d.)", id);
		    return 1;
		}
		else if (!strcmp(type, "entrer", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [entrer] [entrance ID]");
			if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !EntranceData[id][entranceExists])
			    return SendErrorMessage(playerid, "Vous avez spécifier un ID d'entrée invalide.");
		    SetPlayerPosEx(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
		    SetPlayerInterior(playerid, EntranceData[id][entranceExterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceExteriorVW]);
		    SendServerMessage(playerid, "Vous avez été téleporté à l'entrée (ID: %d.)", id);
		    return 1;
		}
		else if (!strcmp(type, "job", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [job] [job ID]");
			if ((id < 0 || id >= MAX_DYNAMIC_JOBS) || !JobData[id][jobExists])
			    return SendErrorMessage(playerid, "Vous avez spécifier un ID de job invalide.");
		    SetPlayerPosEx(playerid, JobData[id][jobPos][0], JobData[id][jobPos][1], JobData[id][jobPos][2]);
		    SetPlayerInterior(playerid, JobData[id][jobInterior]);
			SetPlayerVirtualWorld(playerid, JobData[id][jobWorld]);
		    SendServerMessage(playerid, "Vous avez été téleporté au job (ID: %d.)", id);
		    return 1;
		}
		else if (!strcmp(type, "gate", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [gate] [gate ID]");
			if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !GateData[id][gateExists])
			    return SendErrorMessage(playerid, "Vous avez spécifier un ID de porte invalide.");
		    SetPlayerPosEx(playerid, GateData[id][gatePos][0] - (2.5 * floatsin(-GateData[id][gatePos][3], degrees)), GateData[id][gatePos][1] - (2.5 * floatcos(-GateData[id][gatePos][3], degrees)), GateData[id][gatePos][2]);
		    SetPlayerInterior(playerid, GateData[id][gateInterior]);
			SetPlayerVirtualWorld(playerid, GateData[id][gateWorld]);
		    SendServerMessage(playerid, "Vous avez été téleporté à la porte (ID: %d.)", id);
		    return 1;
		}
		else if (!strcmp(type, "interior", true))
		{
		    static str[9000];
			str[0] = '\0';
			for (new i = 0; i < sizeof(g_arrInteriorData); i ++) {
			    strcat(str, g_arrInteriorData[i][e_InteriorName]);
			    strcat(str, "\n");
		    }
		    Dialog_Show(playerid, TeleportInterior, DIALOG_STYLE_LIST, "Teleport: Liste d'intérieur", str, "Valider", "Annuler");
		    return 1;
		}
	    else return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	}
	if (!IsPlayerSpawned(id))
		return SendErrorMessage(playerid, "Tu ne peut teleport à un joueur qui spawn.");
	SendPlayerToPlayer(playerid, id);
	format(string, sizeof(string), "Vous avez ete ~y~teleporte~w~ a %s.", ReturnName(id, 0));
	ShowPlayerFooter(playerid, string);
	return 1;
}
CMD:gotocar(playerid, params[])
{
	new vehicleid;
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/gotocar [veh]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "ID de vehicule invalide.");
	static Float:x,Float:y,Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	SetPlayerPosEx(playerid, x, y - 2, z + 2);
	return 1;
}
CMD:gotoactor(playerid, params[])
{
	static actorid,string[64];
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", actorid))
 	{
	 	SendSyntaxMessage(playerid, "/gotoactor [id]");
		return 1;
	}
    if (actorid == INVALID_ACTOR_ID)
	{
		SendSyntaxMessage(playerid, "/gotoactor [id]");
		return 1;
	}
	SendPlayerToActor(playerid, actorid);
	format(string, sizeof(string), "Vous avez ete ~y~teleporte~w~ a l'actor id.", actorid);
	ShowPlayerFooter(playerid, string);
	return 1;
}
CMD:renvoyer(playerid, params[])
{
	static userid,type[24];
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "us[32]", userid, type))
 	{
	 	SendSyntaxMessage(playerid, "/renvoyer [player] [name]");
		SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} prison");
		return 1;
	}
    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (!strcmp(type, "prison", true))
	{
		SetPlayerPosEx(playerid, 283.5930, 1413.3511, 10.4078);
  		SetPlayerFacingAngle(playerid, 180.0000);
		SetPlayerInterior(playerid, 0);
  		SetPlayerVirtualWorld(playerid, 0);
		SendServerMessage(playerid, "Vous avez téléporté %s a la prison.", ReturnName(userid, 0));
		SendServerMessage(userid, "%s vous a téléporté a la prison.", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:atalk(playerid, params[])
{
	static userid,text[128];
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "us[128]", userid, text))
		return SendSyntaxMessage(playerid, "/atalk [playerid/name] [message]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	SendClientMessageEx(userid, COLOR_YELLOW, "[ADMIN]: %s dit: %s", ReturnName(playerid, 0), text);
	if (playerid != userid) {
		SendClientMessageEx(playerid, COLOR_YELLOW, "[ADMIN]: %s dit: %s", ReturnName(playerid, 0), text);
	}
	return 1;
}
CMD:envoyera(playerid, params[])
{
	static userid,targetid;
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "uu", userid, targetid))
	    return SendSyntaxMessage(playerid, "/envoyera [playerid/name] [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || targetid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "L'id de l'utilisateur n'est pas connecté..");
	SendPlayerToPlayer(userid, targetid);
	SendServerMessage(playerid, "Vous avez teleporté %s à %s.", ReturnName(userid, 0), ReturnName(targetid));
	SendServerMessage(userid, "%s a téléporté  %s.", ReturnName(playerid, 0), ReturnName(targetid));
	return 1;
}
CMD:unban(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params) || strlen(params) > 24)
	{
		SendSyntaxMessage(playerid, "/unban [nom de l'utilisateur]");
		SendClientMessage(playerid, COLOR_LIGHTRED, "[NOTE]:{FFFFFF} Type \"/username\" pour voir le nom de l'utilisateur");
	}
	else
	{
	    Blacklist_Remove(params);
	    SendServerMessage(playerid, "Vous avez débannie \"%s\" avec succès", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a débanni \"%s\".", ReturnName(playerid, 0), params);
		static string[128],string6[128];
		format(string, sizeof(string),"[%s] %s a débanni \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
		utf8encode(string6,string,sizeof(string6));
		DCC_SendChannelMessage(discordspam,string6);
	}
	return 1;
}
CMD:blacklist(playerid, params[])
{
	static type[24];
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "s[24]s[128]", type, params))
 	{
	 	SendSyntaxMessage(playerid, "/blacklist [name] [parameter]");
	 	SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} ban, banip, unbanip");
	 	return 1;
	}
	if (!strcmp(type, "ban", true))
	{
	    if (!IsValidPlayerName(params))
	        return SendErrorMessage(playerid, "Pas dans le bon format");
		foreach (new i : Player) if (!strcmp(PlayerData[i][pUsername], params) || !strcmp(ReturnName(i), params, true)) {
		    KickEx(i);
		}
		Blacklist_Add("0.0.0.0", params, PlayerData[playerid][pUsername], "Name Ban (/blacklist)");
	    SendServerMessage(playerid, "Vous avez banni \"%s\" avec succès.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a banni \"%s\".", ReturnName(playerid, 0), params);
		static string[128],string6[128];
		format(string, sizeof(string),"[%s] %s a banni \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
		utf8encode(string6,string,sizeof(string6));
		DCC_SendChannelMessage(discordspam,string6);		
	}
	else if (!strcmp(type, "banip", true))
	{
	    if (!IsAnIP(params))
	        return SendErrorMessage(playerid, "IP pas dans le bon Format.");
		foreach (new i : Player) if (!strcmp(PlayerData[i][pIP], params)) {
		    KickEx(i);
		}
		Blacklist_Add(params, "", PlayerData[playerid][pUsername], "IP Ban (/blacklist)");
	    SendServerMessage(playerid, "Vous avez banned IP \"%s\" avec succès.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a banni IP \"%s\".", ReturnName(playerid, 0), params);
		static string[128],string6[128];
		format(string, sizeof(string),"[%s] %s a banni IP \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
		utf8encode(string6,string,sizeof(string6));
		DCC_SendChannelMessage(discordspam,string6);			
	}
	else if (!strcmp(type, "unbanip", true))
	{
	    if (!IsAnIP(params))
	        return SendErrorMessage(playerid, "IP pas dans le bon Format.");
		Blacklist_RemoveIP(params);
	    SendServerMessage(playerid, "Vous avez débanni l'IP \"%s\" avec succès.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a débanni l'IP \"%s\".", ReturnName(playerid, 0), params);
	    Log_Write("logs/ban_log.txt", "[%s] %s a débanni l'IP \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:togooc(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new serveurinfo;
	if(info_serveursetting[serveurinfo][settingoocactive] == 0)
	{
	    SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: OOC OFF.");
	    info_serveursetting[serveurinfo][settingoocactive] = 1;
		serveursettinginfosave(serveurinfo);
	}
	else
	{
	    SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: OOC ON");
	    info_serveursetting[serveurinfo][settingoocactive] = 0;
		serveursettinginfosave(serveurinfo);
	}
	return 1;
}
CMD:arepair(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (vehicleid > 0 && isnull(params))
	{
		RepairVehicle(vehicleid);
		SendServerMessage(playerid, "Vous avez réparer votre véhicule actuel.");
	}
	else
	{
		if (sscanf(params, "d", vehicleid))
	    	return SendSyntaxMessage(playerid, "/arepair [vehicle ID]");

		else if (!IsValidVehicle(vehicleid))
	    	return SendErrorMessage(playerid, "ID de vehicule invalide.");

		RepairVehicle(vehicleid);
		SendServerMessage(playerid, "Vous avez réparé le vehicule (ID: %d.)", vehicleid);
	}
	Log_Write("logs/vehicule.txt", "[%s] %s a reparer le vehicule a %d.", ReturnDate(), ReturnName(playerid),vehicleid);
	return 1;
}
CMD:amenerveh(playerid, params[])
{
	new vehicleid;
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/amenerveh [veh]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "ID de vehicule invalide.");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 2, y - 2, z);
 	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
	Log_Write("logs/vehicule.txt", "[%s] %s a tp le vehicule id %d a lui.", ReturnDate(), ReturnName(playerid),vehicleid);
	return 1;
}
CMD:entercar(playerid, params[])
{
	new vehicleid, seatid;
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/entercar [veh]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "ID de vehicule invalide.");
	seatid = GetAvailableSeat(vehicleid, 0);
	/*if (seatid == -1)
	    return SendErrorMessage(playerid, "There are no seats left a enter.");*/
	PutPlayerInVehicle(playerid, vehicleid, seatid);
	Log_Write("logs/vehicule.txt", "[%s] %s a entercar le vehicule id %d.", ReturnDate(), ReturnName(playerid),vehicleid);
	return 1;
}
CMD:givewep(playerid, params[])
{
	static userid,weaponid,ammo;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "udI(500)", userid, weaponid, ammo))
	    return SendSyntaxMessage(playerid, "/givewep [playerid/name] [weaponid] [ammo]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Tu ne peut donner au joueur déconnecté.");
	if (!IsPlayerSpawned(userid))
	    return SendErrorMessage(playerid, "Tu ne peut donner au joueur non chargé.");
	if(PlayerData[userid][pPlayingHours] < 5)
		return SendErrorMessage(playerid, "Joueur n'a pas assez d'heure de jeux (5).");
	if (weaponid <= 0 || weaponid > 421 || (weaponid >= 19 && weaponid <= 21 || weaponid >= 47 && weaponid <= 99))
		return SendErrorMessage(playerid, "Vous avez spécifier une arme invalide.");
	GiveWeaponToPlayer(userid, weaponid, ammo);
	SendServerMessage(playerid, "Vous avez donné a %s un(e) %s avec %d balle.", ReturnName(userid, 0), ReturnWeaponName(weaponid), ammo);
	return 1;
}
CMD:baninfo(playerid, params[])
{
    static string[128];

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");

	if (isnull(params) || strlen(params) > 24)
	{
		SendSyntaxMessage(playerid, "/baninfo [nom de l'utilisateur]");
		SendClientMessage(playerid, COLOR_LIGHTRED, "[NOTE]:{FFFFFF} Type \"/username\" a resolve the username from a character's name.");
	}
	else
	{
	    format(string, sizeof(string), "SELECT * FROM `blacklist` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
	    mysql_tquery(g_iHandle, string, "OnBanLookup", "ds", playerid, params);
	}
	return 1;
}
CMD:clearchat(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");

	for (new i = 0; i < 100; i ++) {
	    SendClientMessageToAll(-1, "");
	}
	return 1;
}
CMD:creermaison(playerid, params[])
{
	static price,id,address[32];
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[32]", price, address))
	    return SendSyntaxMessage(playerid, "/creermaison [price] [addresse]");
	for (new i = 0; i != MAX_HOUSES; i ++) if (HouseData[i][houseExists] && !strcmp(HouseData[i][houseAddress], address, true)) {
	    return SendErrorMessage(playerid, "l'address \"%s\" iest déja la (ID: %d).", address, i);
	}
	id = House_Create(playerid, address, price);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès maison (ID: %d.)", id);
	return 1;
}
CMD:supmaison(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supmaison [id]");
	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID invalide.");
	House_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes la maison (ID: %d.)", id);
	return 1;
}
CMD:editmaison(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editmaison [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, interior, price, address, type");
		return 1;
	}
	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID de maison invalide.");
	if (!strcmp(type, "location", true))
	{
		GetPlayerPos(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][housePos][3]);
		HouseData[id][houseExterior] = GetPlayerInterior(playerid);
		HouseData[id][houseExteriorVW] = GetPlayerVirtualWorld(playerid);
		House_Refresh(id);
		House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de la maison (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][houseInt][3]);
		HouseData[id][houseInterior] = GetPlayerInterior(playerid);
		HouseData[id][houseInteriorVW] = GetPlayerVirtualWorld(playerid);
        foreach (new i : Player)
		{
			if (PlayerData[i][pHouse] == HouseData[id][houseID])
			{
				SetPlayerPosEx(i, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
				SetPlayerFacingAngle(i, HouseData[id][houseInt][3]);
				SetPlayerInterior(i, HouseData[id][houseInterior]);
				SetPlayerVirtualWorld(i, HouseData[id][houseExteriorVW]);
				SetCameraBehindPlayer(i);
			}
		}
		House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le spawn de la maison (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;
	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/editmaison [id] [price] [new price]");
	    HouseData[id][housePrice] = price;
	    House_Refresh(id);
	    House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le prix de la maison ID: %d a %s $.", ReturnName(playerid, 0), id, FormatNumber(price));
	}
	else if (!strcmp(type, "address", true))
	{
	    new address[32];
	    if (sscanf(string, "s[32]", address))
	        return SendSyntaxMessage(playerid, "/editmaison [id] [address] [new address]");
	    format(HouseData[id][houseAddress], 32, address);
	    House_Refresh(id);
	    House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'adresse de la maison ID: %d a \"%s\".", ReturnName(playerid, 0), id, address);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;
	    if (sscanf(string, "d", typeint))
	        return SendSyntaxMessage(playerid, "/editmaison [id] [type] [interior type]");
		if (typeint < 1 || typeint > sizeof(arrHouseInteriors))
			return SendErrorMessage(playerid, "Le type doit être entre 1 et  %d.", sizeof(arrHouseInteriors));
	    HouseData[id][houseInt][0] = arrHouseInteriors[typeint][eHouseX];
	    HouseData[id][houseInt][1] = arrHouseInteriors[typeint][eHouseY];
	    HouseData[id][houseInt][2] = arrHouseInteriors[typeint][eHouseZ];
	    HouseData[id][houseInt][3] = arrHouseInteriors[typeint][eHouseAngle];
        HouseData[id][houseInterior] = arrHouseInteriors[typeint][eHouseInterior];
		HouseData[id][houseInteriorVW] = HouseData[id][houseID]+1000;
		foreach (new i : Player)
		{
			if (PlayerData[i][pHouse] == HouseData[id][houseID])
			{
				SetPlayerPosEx(i, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
				SetPlayerFacingAngle(i, HouseData[id][houseInt][3]);
				SetPlayerVirtualWorld(i, (HouseData[id][houseID]+1000));
				SetPlayerInterior(i, HouseData[id][houseInterior]);
				SetCameraBehindPlayer(i);
			}
		}
	    House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le type la de maison ID: %d a %d.", ReturnName(playerid, 0), id, typeint);
	}
	return 1;
}
CMD:proche(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if ((id = House_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de maison (ID: %d.)", id);
    if ((id = Business_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de biz (ID: %d.)", id);
    if ((id = Entrance_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de entrance (ID: %d.)", id);
    if ((id = Job_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de job (ID: %d.)", id);
    if ((id = Arrest_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de arrest point (ID: %d.)", id);
    if ((id = Pump_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de pump (ID: %d.)", id);
    if ((id = Crate_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de crate (ID: %d.)", id);
    if ((id = Gate_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de gate (ID: %d.)", id);
    if ((id = Garbage_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de garbage bin (ID: %d.)", id);
    if ((id = Vendor_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de vendor (ID: %d.)", id);
	if ((id = Rack_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "Vous êtes proche de weapon rack (ID: %d.)", id);
    if ((id = Speed_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "Vous êtes proche de speed camera (ID: %d.)", id);
    if ((id = Graffiti_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "Vous êtes proche de graffiti (ID: %d.)", id);
    if ((id = Detector_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "Vous êtes proche de detector (ID: %d.)", id);
    if ((id = caisse_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "Vous êtes proche de la caisse (ID: %d.)", id);
    if ((id = Batiement_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche du batiement (ID: %d.)", id);
    if ((id = Actor_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de l'actor (ID: %d.)", id);
    /*if ((id = OpenWorldMaisonNearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche du open world (ID: %d.)", id);*/
	return 1;
}
CMD:editbiz(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbiz [id] [nom]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, interior, livraison, nom, prix, stock, type, cars, spawn, heures");
		return 1;
	}
	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	if (!strcmp(type, "location", true))
	{
 		GetPlayerPos(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][bizPos][3]);
		BusinessData[id][bizExterior] = GetPlayerInterior(playerid);
		BusinessData[id][bizExteriorVW] = GetPlayerVirtualWorld(playerid);
		Business_Refresh(id);
		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position du biz (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][bizInt][3]);
		BusinessData[id][bizInterior] = GetPlayerInterior(playerid);
		BusinessData[id][bizInteriorVW] = GetPlayerVirtualWorld(playerid);
        foreach (new i : Player)
		{
			if (PlayerData[i][pBusiness] == BusinessData[id][bizID])
			{
				SetPlayerPosEx(i, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
				SetPlayerFacingAngle(i, BusinessData[id][bizInt][3]);
				SetPlayerInterior(i, BusinessData[id][bizInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le spawn du biz (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "heures", true))
	{
		SendServerMessage(playerid,"Heures du biz (id %d) a été reset.",id);
		BusinessData[id][biztime1] = -1;
		BusinessData[id][biztime2] = -1;
		Business_Refresh(id);
		Business_Save(id);			
	}
	else if (!strcmp(type, "livraison", true))
	{
	    if (BusinessData[id][bizType] == 5)
	        return SendErrorMessage(playerid, "Ce biz accepte pas les livraisons.");
	    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	        return SendErrorMessage(playerid, "Seulement a l'extérieurs.");
	    GetPlayerPos(playerid, BusinessData[id][bizDeliver][0], BusinessData[id][bizDeliver][1], BusinessData[id][bizDeliver][2]);
		Business_Refresh(id);
		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le point de livraison du biz (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "prix", true))
	{
	    new price;
	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/editbiz [id] [price] [new price]");
	    BusinessData[id][bizPrice] = price;
	    Business_Refresh(id);
	    Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le prix du biz ID: %d a %s $.", ReturnName(playerid, 0), id, FormatNumber(price));
	}
	else if (!strcmp(type, "stock", true))
	{
	    new amount;
	    if (sscanf(string, "d", amount))
	        return SendSyntaxMessage(playerid, "/editbiz [id] [stock] [product amount]");
	    BusinessData[id][bizProducts] = amount;
	    Business_Refresh(id);
	    Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le stock du biz ID: %d a %s products.", ReturnName(playerid, 0), id, FormatNumber(amount, ""));
	}
	else if (!strcmp(type, "nom", true))
	{
	    new name[32];
	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editbiz [id] [name] [new name]");
	    format(BusinessData[id][bizName], 32, name);
	    Business_Refresh(id);
	    Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le nom du biz ID: %d a \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;
	    if (sscanf(string, "d", typeint))
	    {
	        SendSyntaxMessage(playerid, "/editbiz [id] [type] [biz type]");
			SendSyntaxMessage(playerid,"[TYPES]: 1: Retail | 2: Weapons | 3: Clothes | 4: Fast Food | 5: Dealership | 6: Gas Station | 7: Furniture | 8 : Bar | 9 : Épicerie | 10: Quincaillerie | 11: VIP");
			return 1;
		}
		if (typeint < 1 || typeint > 11)
			return SendErrorMessage(playerid, "Le type doit être entre 1 et 11.");
        BusinessData[id][bizType] = typeint;
        switch (typeint) {
            case 1: {
                BusinessData[id][bizInt][0] = -27.2829;
                BusinessData[id][bizInt][1] = -58.1948;
                BusinessData[id][bizInt][2] = 1003.0910;
                BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 6;
            }
            case 2: {
            	BusinessData[id][bizInt][0] = 316.3963;
            	BusinessData[id][bizInt][1] = -169.8375;
            	BusinessData[id][bizInt][2] = 999.6010;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 6;
			}
			case 3: {
            	BusinessData[id][bizInt][0] = 161.4801;
            	BusinessData[id][bizInt][1] = -96.5368;
            	BusinessData[id][bizInt][2] = 1001.8047;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 18;
			}
			case 4: {
            	BusinessData[id][bizInt][0] = 363.3402;
            	BusinessData[id][bizInt][1] = -74.6679;
            	BusinessData[id][bizInt][2] = 1001.5078;
            	BusinessData[id][bizInt][3] = 315.0000;
				BusinessData[id][bizInterior] = 10;
			}
			case 5: {
            	BusinessData[id][bizInt][0] = 396.5101;
            	BusinessData[id][bizInt][1] = 172.2172;
            	BusinessData[id][bizInt][2] = 1009.0739;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 3;
			}
			case 6: {
                BusinessData[id][bizInt][0] = -27.2829;
                BusinessData[id][bizInt][1] = -58.1948;
                BusinessData[id][bizInt][2] = 1003.0910;
                BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 6;
			}
			case 7: {
				BusinessData[id][bizInt][0] = 807.7578;
   				BusinessData[id][bizInt][1] = -71.3722;
			   	BusinessData[id][bizInt][2] = 997.8246;
      			BusinessData[id][bizInt][3] = 270.0000;
				BusinessData[id][bizInterior] = 6;
			}
			case 8: { //non la sur VC
               	BusinessData[id][bizInt][0] = 501.98098;
               	BusinessData[id][bizInt][1] = -69.150199;
               	BusinessData[id][bizInt][2] = 998.757812;
               	BusinessData[id][bizInt][3] = 315.0000;
				BusinessData[id][bizInterior] = 11;
				}				
			case 9: {
                BusinessData[id][bizInt][0] = -27.312299;
                BusinessData[id][bizInt][1] = -29.277599;
                BusinessData[id][bizInt][2] = 1003.557250;
                BusinessData[id][bizInt][3] = 315.0000;
				BusinessData[id][bizInterior] = 4;
			}
			case 10: {
                BusinessData[id][bizInt][0] = -27.312299;
                BusinessData[id][bizInt][1] = -29.277599;
                BusinessData[id][bizInt][2] = 1003.557250;
                BusinessData[id][bizInt][3] = 315.0000;
				BusinessData[id][bizInterior] = 4;
			}
            case 11: {
                BusinessData[id][bizInt][0] = -27.2829;
                BusinessData[id][bizInt][1] = -58.1948;
                BusinessData[id][bizInt][2] = 1003.0910;
                BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 6;
            }			
		}
		foreach (new i : Player)
		{
			if (PlayerData[i][pBusiness] == BusinessData[id][bizID])
			{
				SetPlayerPosEx(i, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
				SetPlayerFacingAngle(i, BusinessData[id][bizInt][3]);
				SetPlayerInterior(i, BusinessData[id][bizInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Business_Refresh(id);
	    Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le type de biz ID: %d a %d.", ReturnName(playerid, 0), id, typeint);
	}
	else if (!strcmp(type, "cars", true))
	{
	    if (BusinessData[id][bizType] != 5)
	        return SendErrorMessage(playerid, "Ce biz n'est pas un vendeur de voiture!");
		PlayerData[playerid][pDealership] = id;
		Business_EditCars(playerid, id);
	}
	else if (!strcmp(type, "spawn", true))
	{
	    if (BusinessData[id][bizType] != 5)
	        return SendErrorMessage(playerid, "Ce biz n'est pas un vendeur de voiture!");
	    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	        return SendErrorMessage(playerid, "Seulement a l'extérieur.");
	    GetPlayerPos(playerid, BusinessData[id][bizSpawn][0], BusinessData[id][bizSpawn][1], BusinessData[id][bizSpawn][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][bizSpawn][3]);
		BusinessData[id][bizExterior] = GetPlayerInterior(playerid);
		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le spawn des véhicules du biz (ID: %d.)", ReturnName(playerid, 0), id);
	}
	return 1;
}
CMD:creerbiz(playerid, params[])
{
    static type, price,id;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "dd", type, price))
 	{
	 	SendSyntaxMessage(playerid, "/creerbiz [type] [price]");
    	SendSyntaxMessage(playerid, "[TYPES]:{FFFFFF} 1: Retail | 2: Weapons | 3: Clothes | 4: Fast Food | 5: Dealership | 6: Gas Station | 7: Furniture | 8 : Bar | 9 : Épicerie | 10 : Quincaillerie | 11 : VIP");
    	return 1;
	}
	if (type < 1 || type > 11)
	    return SendErrorMessage(playerid, "Type invalide. Essayer entre 1 et 11.");
	id = Business_Create(playerid, type, price);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès biz (ID: %d.)", id);
	return 1;
}
CMD:supbiz(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supbiz [biz id]");
	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	Business_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes le magasin (ID: %d.)", id);
	return 1;
}
CMD:creerentrer(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params) || strlen(params) > 32)
	    return SendSyntaxMessage(playerid, "/creerentrer [name]");
	new id = Entrance_Create(playerid, params);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès entrée (ID: %d.)", id);
	return 1;
}
CMD:editentrer(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editentrer [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, interior, password, name, porte, mapicon, type, custom, virtual");
		return 1;
	}
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !EntranceData[id][entranceExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une entrée invalide ID.");
	if (!strcmp(type, "location", true))
	{
	    GetPlayerPos(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][entrancePos][3]);
		EntranceData[id][entranceExterior] = GetPlayerInterior(playerid);
		EntranceData[id][entranceExteriorVW] = GetPlayerVirtualWorld(playerid);
		Entrance_Refresh(id);
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de l'entrée (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);
		EntranceData[id][entranceInterior] = GetPlayerInterior(playerid);
        foreach (new i : Player)
		{
			if (PlayerData[i][pEntrance] == EntranceData[id][entranceID])
			{
				SetPlayerPosEx(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
				SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);

				SetPlayerInterior(i, EntranceData[id][entranceInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le spawn de l'entrée (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "custom", true))
	{
	    new status;
	    if (sscanf(string, "d", status))
	        return SendSyntaxMessage(playerid, "/editentrer [id] [custom] [0/1]");
		if (status < 0 || status > 2)
		    return SendErrorMessage(playerid, "Vous devez spécifier au minimum 0 ou 1 ou 2.");
	    EntranceData[id][entranceCustom] = status;
	    Entrance_Save(id);
	    if (status) {
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s entrée custom on pour (ID: %d.)", ReturnName(playerid, 0), id);
		}
		else {
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s entrée custom off pour (ID: %d.)", ReturnName(playerid, 0), id);
		}
	}
	else if (!strcmp(type, "virtual", true))
	{
	    new worldid;
	    if (sscanf(string, "d", worldid))
	        return SendSyntaxMessage(playerid, "/editentrer [id] [virtual] [interior world]");
	    EntranceData[id][entranceWorld] = worldid;
		foreach (new i : Player) if (Entrance_Inside(i) == id) {
			SetPlayerVirtualWorld(i, worldid);
		}
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a le VW de l'entrée ID: %d a %d.", ReturnName(playerid, 0), id, worldid);
	}
	else if (!strcmp(type, "mapicon", true))
	{
	    new icon;
	    if (sscanf(string, "d", icon))
	        return SendSyntaxMessage(playerid, "/editentrer [id] [mapicon] [map icon]");
		if (icon < 0 || icon > 63)
		    return SendErrorMessage(playerid, "Invalid map icon! Pour trouver un bon aller a \"wiki.sa-mp.com/wiki/MapIcons\".");
	    EntranceData[id][entranceIcon] = icon;
	    Entrance_Refresh(id);
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'icon map de  l'entrée ID: %d a %d.", ReturnName(playerid, 0), id, icon);
	}
	else if (!strcmp(type, "password", true))
	{
	    new password[32];

	    if (sscanf(string, "s[32]", password))
	        return SendSyntaxMessage(playerid, "/editentrer [id] [password] [entrance pass] (Utilise 'none' pour enlever)");
		if (!strcmp(password, "none", true)) {
			EntranceData[id][entrancePass][0] = 0;
		}
		else {
		    format(EntranceData[id][entrancePass], 32, password);
		}
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le MDP de l'entrée ID: %d a \"%s\".", ReturnName(playerid, 0), id, password);
	}
	else if (!strcmp(type, "porte", true))
	{
	    new locked;
	    if (sscanf(string, "d", locked))
	        return SendSyntaxMessage(playerid, "/editentrer [id] [locked] [locked 0/1]");
		if (locked < 0 || locked > 1)
		    return SendErrorMessage(playerid, "Invalide utilisation 0 pour ouvert 1 pour fermé.");
	    EntranceData[id][entranceLocked] = locked;
	    Entrance_Save(id);
	    if (locked) {
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a modifié l'entrée (ID: %d.)", ReturnName(playerid, 0), id);
		} else {
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a modifié l'entrée (ID: %d.)", ReturnName(playerid, 0), id);
		}
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];
	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editentrer [id] [name] [new name]");
	    format(EntranceData[id][entranceName], 32, name);
	    Entrance_Refresh(id);
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le nom de l'entrée ID: %d a \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	    {
	        SendSyntaxMessage(playerid, "/editentrer [id] [type] [entrance type]");
			SendServerMessage(playerid,"[TYPES]:{FFFFFF} 0: None | 1: DMV | 2: Bank | 3: Warehouse | 4: City Hall | 5: Shooting Range | 6: Casino | 7: PMU | 8: Comico | 9: Bowling | 10: Anpe");
			return 1;
		}
		if (typeint < 0 || typeint > 10)
			return SendErrorMessage(playerid, "Le type doit être entre 0 et 10.");
		if (EntranceData[id][entranceType] == 3 && typeint != 3) {
		    DestroyForklifts(id);
		}
		else if (EntranceData[id][entranceType] != 3 && typeint == 3) {
		    CreateForklifts(id);
		}
        EntranceData[id][entranceType] = typeint;
        switch (typeint) {
            case 1: {
            	EntranceData[id][entranceInt][0] = -2029.5531;
           		EntranceData[id][entranceInt][1] = -118.8003;
            	EntranceData[id][entranceInt][2] = 1035.1719;
            	EntranceData[id][entranceInt][3] = 0.0000;
				EntranceData[id][entranceInterior] = 3;
            }
			case 2: {
            	EntranceData[id][entranceInt][0] = 1456.1918;
           		EntranceData[id][entranceInt][1] = -987.9417;
            	EntranceData[id][entranceInt][2] = 996.1050;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 6;
            }
            case 3: {
                EntranceData[id][entranceInt][0] = 1291.8246;
           		EntranceData[id][entranceInt][1] = 5.8714;
            	EntranceData[id][entranceInt][2] = 1001.0078;
            	EntranceData[id][entranceInt][3] = 180.0000;
				EntranceData[id][entranceInterior] = 18;
			}
			case 4: {
			    EntranceData[id][entranceInt][0] = -1821.6859;
           		EntranceData[id][entranceInt][1] = 43.7851;
            	EntranceData[id][entranceInt][2] = 1445.9305;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 10;
			}
			case 5: {
			    EntranceData[id][entranceInt][0] = 304.0165;
           		EntranceData[id][entranceInt][1] = -141.9894;
            	EntranceData[id][entranceInt][2] = 1004.0625;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 7;
			}
			case 6: {
			    EntranceData[id][entranceInt][0] = -251.9572;
           		EntranceData[id][entranceInt][1] = -21.1579;
            	EntranceData[id][entranceInt][2] = 1004.6884;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 3;
			}
			case 7: {
			    EntranceData[id][entranceInt][0] = 833.49127;
           		EntranceData[id][entranceInt][1] = 7.32437;
            	EntranceData[id][entranceInt][2] = 1003.52393;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 3;
			}
			case 8: {
			    EntranceData[id][entranceInt][0] = 440.6800;
           		EntranceData[id][entranceInt][1] = 548.7442;
            	EntranceData[id][entranceInt][2] = 1002.4552;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 4;
			}
			case 9: {
			    EntranceData[id][entranceInt][0] = -1992.6971;
           		EntranceData[id][entranceInt][1] = 407.8793;
            	EntranceData[id][entranceInt][2] = 3.5010;
            	EntranceData[id][entranceInt][3] = 268.7060;
				EntranceData[id][entranceInterior] = 1;
			}
			case 10: {
			    EntranceData[id][entranceInt][0] = 316.8740;
           		EntranceData[id][entranceInt][1] = 119.3040;
            	EntranceData[id][entranceInt][2] = 1011.7645;
            	EntranceData[id][entranceInt][3] = 9.6120;
				EntranceData[id][entranceInterior] = 1;
			}			
		}
		foreach (new i : Player)
		{
			if (PlayerData[i][pEntrance] == EntranceData[id][entranceID])
			{
				SetPlayerPosEx(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
				SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);
				SetPlayerInterior(i, EntranceData[id][entranceInterior]);
				SetCameraBehindPlayer(i);
			}
		}
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le type de l'entrée ID: %d a %d.", ReturnName(playerid, 0), id, typeint);
	}
	return 1;
}
CMD:supentrer(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supentrer [entrance id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !EntranceData[id][entranceExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une entrée invalide ID.");
	Entrance_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes l'entrée (ID: %d.)", id);
	return 1;
}
CMD:creerpump(playerid, params[])
{
	static id,bizid = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", bizid))
	    return SendSyntaxMessage(playerid, "/creerpump [biz id]");
	if ((bizid < 0 || bizid >= MAX_BUSINESSES) || !BusinessData[bizid][bizExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	if (BusinessData[bizid][bizType] != 6)
	    return SendErrorMessage(playerid, "Ce biz n'est pas une station essence!");
    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		return SendErrorMessage(playerid, "Extérieur seulement.");
	id = Pump_Create(playerid, bizid);
	if (id == -1)
	    return SendErrorMessage(playerid, "Ce biz a le maximum de pump.");
	SendServerMessage(playerid, "Créer avec succès la pompe (ID: %d.)", id);
	EditDynamicObject(playerid, PumpData[id][pumpObject]);
	PlayerData[playerid][pEditPump] = id;
	return 1;
}
CMD:editpump(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/editpump [pump id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !PumpData[id][pumpExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID pompe invalide.");
	ResetEditing(playerid);
	PlayerData[playerid][pEditPump] = id;
	EditDynamicObject(playerid, PumpData[id][pumpObject]);
	SendServerMessage(playerid, "Tu édite maintenant edit la pump (ID: %d.)", id);
	return 1;
}
CMD:suppump(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supump [pump id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !PumpData[id][pumpExists])
	    return SendErrorMessage(playerid, "Invalid pump ID.");
	Pump_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes la pompe (ID: %d.)", id);
	return 1;
}
CMD:setpump(playerid, params[])
{
	static id = 0,amount;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "dd", id, amount))
	    return SendSyntaxMessage(playerid, "/setpump [pump id] [fuel amount]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !PumpData[id][pumpExists])
	    return SendErrorMessage(playerid, "Invalide pompe ID.");
	PumpData[id][pumpFuel] = amount;
	Pump_Refresh(id);
	Pump_Save(id);
	SendServerMessage(playerid, "Vous avez mis a %d litre pour la pompe (ID: %d.)", amount, id);
	return 1;
}
CMD:aojail(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= 1)
	{
		new string[128], name[MAX_PLAYER_NAME], minutes;
		if(sscanf(params, "s[24]ds[64]", name, minutes)) return SendClientMessageEx(playerid, COLOR_WHITE, "Utilisation: /aojail [player name] [minutes]");
		new tmpName[24], query[512];
		mysql_real_escape_string(name, tmpName);
		SetPVarString(playerid, "OnJailAccount", tmpName);
		format(string, sizeof(string), "Attempting a jail %s account for %d minutes...", tmpName, minutes);
		SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, string);
		format(query,sizeof(query),"UPDATE `characters` SET `JailTime` = %d WHERE `Admin` < %d AND `Username` = '%s'", minutes*60, PlayerData[playerid][pAdmin], tmpName);
		mysql_tquery(g_iHandle, query, "OnJailAccount", "i", playerid);
	}
	return 1;
}
CMD:creerjob(playerid, params[])
{
	static type,id = -1;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/creerjob [type]");
	if (type < 1 || type > 15)
	    return SendErrorMessage(playerid, "Type invalide. Essayer entre 1 et 15.");
	id = Job_Create(playerid, type);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès job (ID: %d.)", id);
	return 1;
}
CMD:supjob(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supjob [job id]");
	if ((id < 0 || id >= MAX_DYNAMIC_JOBS) || !JobData[id][jobExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID job invalide.");
	Job_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes le job (ID: %d.)", id);
	return 1;
}
CMD:editjob(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editjob [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, type, point, deliver");
		return 1;
	}
	if ((id < 0 || id >= MAX_DYNAMIC_JOBS) || !JobData[id][jobExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID job invalide.");
	if (!strcmp(type, "location", true))
	{
	    static Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid, x, y, z);
		JobData[id][jobPos][0] = x;
		JobData[id][jobPos][1] = y;
		JobData[id][jobPos][2] = z;
		JobData[id][jobInterior] = GetPlayerInterior(playerid);
		JobData[id][jobWorld] = GetPlayerVirtualWorld(playerid);
		Job_Refresh(id);
		Job_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position du job (ID: %d.)", ReturnName(playerid, 0), id);
	}
 	else if (!strcmp(type, "type", true))
	{
	    new typeint;
	    if (sscanf(string, "d", typeint))
	        return SendSyntaxMessage(playerid, "/editjob [id] [type] [new type]");
        if (typeint < 1 || typeint > 20)
	    	return SendErrorMessage(playerid, "Type invalide. Essayer entre 1 a 20.");
	    JobData[id][jobType] = typeint;
	    Job_Refresh(id);
	    Job_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le type du job ID: %d a %s.", ReturnName(playerid, 0), id, Job_GetName(typeint));
	}
	else if (!strcmp(type, "point", true))
	{
	    static Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid, x, y, z);
		JobData[id][jobPoint][0] = x;
		JobData[id][jobPoint][1] = y;
		JobData[id][jobPoint][2] = z;
        JobData[id][jobPointInt] = GetPlayerInterior(playerid);
        JobData[id][jobPointWorld] = GetPlayerVirtualWorld(playerid);
		Job_Refresh(id);
		Job_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le point du job (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "deliver", true))
	{
	    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	        return SendErrorMessage(playerid, "Tu ne peut place the deliver point inside interiors.");
	    static Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid, x, y, z);
		JobData[id][jobDeliver][0] = x;
		JobData[id][jobDeliver][1] = y;
		JobData[id][jobDeliver][2] = z;
		Job_Refresh(id);
		Job_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le point de livraison du job (ID: %d.)", ReturnName(playerid, 0), id);
	}
	return 1;
}
CMD:creercrate(playerid, params[])
{
	static id = -1,type;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creercrate [type]");
	    SendSyntaxMessage(playerid, "[TYPES]: 1: Melee | 2: Pistol Parts | 3: SMG Parts | 4: Shotgun Parts | 5: Rifle Parts | 6: Drugs | 7: Munitions | 8: Cocktail Molotov | 9: Piece de frontbumper | 10: Piece de rearbumper | 11: Piece de roof | 12: Piece de hood | 13: Piece de spoiler | 14: Piece d'extra | 15: Piece de muffler | 16: Piece de roue | 17: Piece de carrosserie");
		return 1;
	}
	if (type < 1 || type > 17)
	    return SendErrorMessage(playerid, "Type invalide. Essayer entre 1 a 17.");
	id = Crate_Create(playerid, type);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès crate (ID: %d.)", id);
	return 1;
}
CMD:supcrate(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supcrate [crate id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !CrateData[id][crateExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID boite invalide.");
	Crate_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes crate (ID: %d.)", id);
	return 1;
}
CMD:creerfaction(playerid, params[])
{
	static id = -1,name[32];
    if (PlayerData[playerid][pAdmin] < 3 || !PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "s[32]", name))
	{
	    SendSyntaxMessage(playerid, "/creerfaction [name]");
		return 1;
	}
	id = Faction_Create(name);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès faction (ID: %d.)", id);
	return 1;
}
CMD:supfaction(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4 || !PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supfaction [faction id]");
	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][factionExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID faction invalide.");
	Faction_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes faction (ID: %d.)", id);
	return 1;
}
CMD:editfaction(playerid, params[])
{
	static id,type[24],string[128],discordid[20];
	if (!PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editfaction [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} name, models, locker, ranks, maxranks, acces[1 a 15], action[1 a 3]");
		return 1;
	}
	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][factionExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID faction invalide.");
    if (!strcmp(type, "name", true))
	{
	    new name[32];
	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [name] [new name]");
	    format(FactionData[id][factionName], 32, name);
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le nom du faction ID: %d a \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "maxranks", true))
	{
	    new ranks;
	    if (sscanf(string, "d", ranks))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [maxranks] [maximum ranks]");
		if (ranks < 1 || ranks > 15)
		    return SendErrorMessage(playerid, "Le numéro du ranks ne peut être 1 et max 15.");
	    FactionData[id][factionRanks] = ranks;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le maximum de rang dans la faction ID: %d a %d.", ReturnName(playerid, 0), id, ranks);
	}
	else if (!strcmp(type, "discordchat", true))
	{
	    if (sscanf(string, "s[20]", discordid))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [discordchat] [discord id]");
		format(FactionData[id][factiondiscord],20,discordid);
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le discord chat a %s pour la faction %d.", ReturnName(playerid, 0),discordid,id);
	}
	else if (!strcmp(type, "role", true))
	{
	    if (sscanf(string, "s[20]", discordid))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [role] [role id]");
		format(FactionData[id][factionrole],20,discordid);
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le role a %s pour la faction %d.", ReturnName(playerid, 0),discordid,id);
	}
	else if (!strcmp(type, "acces1", true))
	{
		if (FactionData[id][factionacces][1] == 1) FactionData[id][factionacces][1] = 0;
		if (FactionData[id][factionacces][1] == 0) FactionData[id][factionacces][1] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 1 de la faction ID: %d ", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces2", true))
	{
		if (FactionData[id][factionacces][2] == 1) FactionData[id][factionacces][2] = 0;
		if (FactionData[id][factionacces][2] == 0) FactionData[id][factionacces][2] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 2 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces3", true))
	{
		if (FactionData[id][factionacces][3] == 1) FactionData[id][factionacces][3] = 0;
		if (FactionData[id][factionacces][3] == 0) FactionData[id][factionacces][3] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 3 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces4", true))
	{
		if (FactionData[id][factionacces][4] == 1) FactionData[id][factionacces][4] = 0;
		if (FactionData[id][factionacces][4] == 0) FactionData[id][factionacces][4] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 4 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces5", true))
	{
		if (FactionData[id][factionacces][5] == 1) FactionData[id][factionacces][5] = 0;
		if (FactionData[id][factionacces][5] == 0) FactionData[id][factionacces][5] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 5 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces6", true))
	{
		if (FactionData[id][factionacces][6] == 1) FactionData[id][factionacces][6] = 0;
		if (FactionData[id][factionacces][6] == 0) FactionData[id][factionacces][6] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 6 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces7", true))
	{
		if (FactionData[id][factionacces][7] == 1) FactionData[id][factionacces][7] = 0;
		if (FactionData[id][factionacces][7] == 0) FactionData[id][factionacces][7] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 7 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces8", true))
	{
		if (FactionData[id][factionacces][8] == 1) FactionData[id][factionacces][8] = 0;
		if (FactionData[id][factionacces][8] == 0) FactionData[id][factionacces][8] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 8 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces9", true))
	{
		if (FactionData[id][factionacces][9] == 1) FactionData[id][factionacces][9] = 0;
		if (FactionData[id][factionacces][9] == 0) FactionData[id][factionacces][9] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 9 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces10", true))
	{
		if (FactionData[id][factionacces][10] == 1) FactionData[id][factionacces][10] = 0;
		if (FactionData[id][factionacces][10] == 0) FactionData[id][factionacces][10] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 10 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces11", true))
	{
		if (FactionData[id][factionacces][11] == 1) FactionData[id][factionacces][11] = 0;
		if (FactionData[id][factionacces][11] == 0) FactionData[id][factionacces][11] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 11 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces12", true))
	{
		if (FactionData[id][factionacces][12] == 1) FactionData[id][factionacces][12] = 0;
		if (FactionData[id][factionacces][12] == 0) FactionData[id][factionacces][12] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 12 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces13", true))
	{
		if (FactionData[id][factionacces][13] == 1) FactionData[id][factionacces][13] = 0;
		if (FactionData[id][factionacces][13] == 0) FactionData[id][factionacces][13] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 13 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces14", true))
	{
		if (FactionData[id][factionacces][14] == 1) FactionData[id][factionacces][14] = 0;
		if (FactionData[id][factionacces][14] == 0) FactionData[id][factionacces][14] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 14 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "acces15", true))
	{
		if (FactionData[id][factionacces][15] == 1) FactionData[id][factionacces][15] = 0;
		if (FactionData[id][factionacces][15] == 0) FactionData[id][factionacces][15] = 1;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 14 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "ranks", true)) {Faction_ShowRanks(playerid, id);}
	else if (!strcmp(type, "models", true))
	{
	    static skins[8];
		for (new i = 0; i < sizeof(skins); i ++)
		    skins[i] = (FactionData[id][factionSkins][i]) ? (FactionData[id][factionSkins][i]) : (19300);
	    PlayerData[playerid][pFactionEdit] = id;
		ShowModelSelectionMenu(playerid, "Faction Skins", MODEL_SELECTION_SKINS, skins, sizeof(skins), -16.0, 0.0, -55.0);
	}
	else if (!strcmp(type, "locker", true))
	{
        PlayerData[playerid][pFactionEdit] = id;
		Dialog_Show(playerid, FactionLocker, DIALOG_STYLE_LIST, "Faction Locker", "Set Location\nLocker Weapons", "Valider", "Annuler");
	}
	else if (!strcmp(type, "action1", true))
	{
		static Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		FactionData[id][factionaction1Pos][0] = x;
		FactionData[id][factionaction1Pos][1] = y;
		FactionData[id][factionaction1Pos][2] = z;
		Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position action 1 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "action2", true))
	{
		static Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		FactionData[id][factionaction2Pos][0] = x;
		FactionData[id][factionaction2Pos][1] = y;
		FactionData[id][factionaction2Pos][2] = z;
		Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position action 2 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "action3", true))
	{
		static Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		FactionData[id][factionaction3Pos][0] = x;
		FactionData[id][factionaction3Pos][1] = y;
		FactionData[id][factionaction3Pos][2] = z;
		Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position action 3 de la faction ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "action1range", true))
	{
	    static Float:radius;
		if (sscanf(string, "f", radius))
		    return SendSyntaxMessage(playerid, "/editfaction [id] action1range [range]");
		if (radius < 0.0 || radius > 20.0)
		    return SendErrorMessage(playerid, "La portée doit être minimum 0 et max 20.");
        FactionData[id][factionaction1Pos][3] = radius;
		Faction_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la porté des commande d'action 1 de la faction ID: %d a %.4f.", ReturnName(playerid, 0), id, radius);
		return 1;
	}
	else if (!strcmp(type, "action2range", true))
	{
	    static Float:radius;
		if (sscanf(string, "f", radius))
		    return SendSyntaxMessage(playerid, "/editfaction [id] action1range [range]");
		if (radius < 0.0 || radius > 20.0)
		    return SendErrorMessage(playerid, "La portée doit être minimum 0 et max 20.");
        FactionData[id][factionaction2Pos][3] = radius;
		Faction_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la porté des commande d'action 2 de la faction ID: %d a %.4f.", ReturnName(playerid, 0), id, radius);
		return 1;
	}
	else if (!strcmp(type, "action3range", true))
	{
	    static Float:radius;
		if (sscanf(string, "f", radius))
		    return SendSyntaxMessage(playerid, "/editfaction [id] action1range [range]");
		if (radius < 0.0 || radius > 20.0)
		    return SendErrorMessage(playerid, "La portée doit être minimum 0 et max 20.");
        FactionData[id][factionaction3Pos][3] = radius;
		Faction_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la porté des commande d'action 3 de la faction ID: %d a %.4f.", ReturnName(playerid, 0), id, radius);
		return 1;
	}
	return 1;
}
CMD:creerarrest(playerid, params[])
{
	static id = -1,Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = Arrest_Create(x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès arrest point (ID: %d.)", id);
	return 1;
}
CMD:suparrest(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suparrest [point id]");
	if ((id < 0 || id >= MAX_ARREST_POINTS) || !ArrestData[id][arrestExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID d'arrestation invalide.");
	Arrest_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes arrest point (ID: %d.)", id);
	return 1;
}
CMD:acceptname(playerid, params[])
{
	static userid;
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous ne pouvez pas utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/acceptname [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (!strlen(PlayerData[userid][pNameChange]))
	    return SendErrorMessage(playerid, "Ce joueur n'a pas demander de changement de nom.");
	SendServerMessage(playerid, "Vous avez accepté %s a changer de nom pour %s.", ReturnName(userid, 0), PlayerData[userid][pNameChange]);
    SendServerMessage(userid, "%s a accepté votre changement de nom pour %s.", ReturnName(playerid, 0), PlayerData[userid][pNameChange]);
	ChangeName(userid, PlayerData[userid][pNameChange]);
	PlayerData[userid][pNameChange][0] = '\0';
	return 1;
}
CMD:declinename(playerid, params[])
{
	static userid;
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous ne pouvez pas utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/declinename [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (!strlen(PlayerData[userid][pNameChange]))
	    return SendErrorMessage(playerid, "Ce joueur n'a pas demander de changement de nom.");
	SendServerMessage(playerid, "Vous avez refuser %s de changer de nom pour %s.", ReturnName(userid, 0), PlayerData[userid][pNameChange]);
    SendServerMessage(userid, "%s a refuser votre changement de nom pour %s.", ReturnName(playerid, 0), PlayerData[userid][pNameChange]);
	PlayerData[userid][pNameChange][0] = '\0';
	return 1;
}
CMD:supaccount(playerid, params[])
{
	static query[64];
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/supaccount [nom de l'utilisateur]");
    if (!IsValidPlayerName(params))
	    return SendErrorMessage(playerid, "Vous avez spécifier un nom de format invalide.");
	foreach (new i : Player) if (!strcmp(PlayerData[i][pUsername], params, true)) {
	    return SendErrorMessage(playerid, "Tu ne peut supprimer le compte du joueur enligne!.");
	}
	format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnDeleteAccount", "ds", playerid, params);
	return 1;
}
CMD:creergate(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = Gate_Create(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès gate (ID: %d.)", id);
	return 1;
}
CMD:supgate(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supgate [gate id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !GateData[id][gateExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une porte invalide.");
	Gate_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes gate (ID: %d.)", id);
	return 1;
}
CMD:editgate(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editgate [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, speed, radius, time, model, pos, move, pass, linkid, faction");
		return 1;
	}
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !GateData[id][gateExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une porte invalide.");
    if (!strcmp(type, "location", true))
	{
		static Float:x,Float:y,Float:z,Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);
		GateData[id][gatePos][0] = x;
		GateData[id][gatePos][1] = y;
		GateData[id][gatePos][2] = z;
		GateData[id][gatePos][3] = 0.0;
		GateData[id][gatePos][4] = 0.0;
		GateData[id][gatePos][5] = angle;
		SetDynamicObjectPos(GateData[id][gateObject], x, y, z);
		SetDynamicObjectRot(GateData[id][gateObject], 0.0, 0.0, angle);
		GateData[id][gateOpened] = false;
		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de la gate (ID: %d.)", ReturnName(playerid, 0), id);
		return 1;
	}
	else if (!strcmp(type, "speed", true))
	{
	    static Float:speed;
		if (sscanf(string, "f", speed))
		    return SendSyntaxMessage(playerid, "/editgate [id] [speed] [move speed]");
		if (speed < 0.0 || speed > 20.0)
		    return SendErrorMessage(playerid, "Le numéro du speed ne peut être 0 et max 20.");
        GateData[id][gateSpeed] = speed;
		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la vitesse de la porte ID: %d a %.2f.", ReturnName(playerid, 0), id, speed);
		return 1;
	}
	else if (!strcmp(type, "radius", true))
	{
	    static Float:radius;
		if (sscanf(string, "f", radius))
		    return SendSyntaxMessage(playerid, "/editgate [id] [radius] [open radius]");
		if (radius < 0.0 || radius > 20.0)
		    return SendErrorMessage(playerid, "La portée doit être minimum 0 et max 20.");
        GateData[id][gateRadius] = radius;
		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la porté de la porte ID: %d a %.2f.", ReturnName(playerid, 0), id, radius);
		return 1;
	}
	else if (!strcmp(type, "time", true))
	{
	    static time;
		if (sscanf(string, "d", time))
		    return SendSyntaxMessage(playerid, "/editgate [id] [time] [close time] (0 pour faire annuler)");
		if (time < 0 || time > 60000)
		    return SendErrorMessage(playerid, "Le numéro du time can't be 0 et max 60,000 ms.");
        GateData[id][gateTime] = time;
		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le temps de fermeture de la porte ID: %d a %d.", ReturnName(playerid, 0), id, time);
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    static model;
		if (sscanf(string, "d", model))
		    return SendSyntaxMessage(playerid, "/editgate [id] [model] [gate model]");
		if (!IsValidobjectModel(model))
		    return SendErrorMessage(playerid, "Invalid object model.");
        GateData[id][gateModel] = model;
		DestroyDynamicObject(GateData[id][gateObject]);
		GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);
		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le model de la porte ID: %d a %d.", ReturnName(playerid, 0), id, model);
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, GateData[id][gateObject]);
		PlayerData[playerid][pEditGate] = id;
		PlayerData[playerid][pEditType] = 1;
		SendServerMessage(playerid, "Vous êtes maintenant réglez la position de de la porte (ID: %d.)", id);
		return 1;
	}
	else if (!strcmp(type, "move", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, GateData[id][gateObject]);
		PlayerData[playerid][pEditGate] = id;
		PlayerData[playerid][pEditType] = 2;
		SendServerMessage(playerid, "Vous êtes maintenant réglez la position de de mouvement de la porte (ID: %d.)", id);
		return 1;
	}
	else if (!strcmp(type, "linkid", true))
	{
	    static linkid = -1;
		if (sscanf(string, "d", linkid))
		    return SendSyntaxMessage(playerid, "/editgate [id] [linkid] [gate link] (-1 for none)");
        if ((linkid < -1 || linkid >= MAX_DYNAMIC_OBJ) || (linkid != -1 && !GateData[linkid][gateExists]))
	    	return SendErrorMessage(playerid, "Vous avez spécifier une porte invalide.");
        GateData[id][gateLinkID] = (linkid == -1) ? (-1) : (GateData[linkid][gateID]);
		Gate_Save(id);
		if (id == -1)
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la gate de la porte ID: %d a personne.", ReturnName(playerid, 0), id);
		else
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la gate de la porte ID: %d a l'(ID: %d.)", ReturnName(playerid, 0), id, linkid);
		return 1;
	}
	else if (!strcmp(type, "faction", true))
	{
	    static factionid = -1;
		if (sscanf(string, "d", factionid))
		    return SendSyntaxMessage(playerid, "/editgate [id] [faction] [gate faction] (-1 for none)");
        if ((factionid < -1 || factionid >= MAX_FACTIONS) || (factionid != -1 && !FactionData[factionid][factionExists]))
	    	return SendErrorMessage(playerid, "Vous avez spécifier un ID faction invalide.");
        GateData[id][gateFaction] = (factionid == -1) ? (-1) : (FactionData[factionid][factionID]);
		Gate_Save(id);
		if (factionid == -1)
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la faction de la porte ID: %d a aucune porte.", ReturnName(playerid, 0), id);
		else
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la faction de la porte ID: %d a \"%s\".", ReturnName(playerid, 0), id, FactionData[factionid][factionName]);
		return 1;
	}
	else if (!strcmp(type, "pass", true))
	{
	    static pass[32];
		if (sscanf(string, "s[32]", pass))
		    return SendSyntaxMessage(playerid, "/editgate [id] [pass] [gate password] (Utilise 'none' pour enlever)");
		if (!strcmp(params, "none", true))
			GateData[id][gatePass][0] = 0;
		else format(GateData[id][gatePass], 32, pass);
		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le mot de passe de la porte ID: %d a %s.", ReturnName(playerid, 0), id, pass);
		return 1;
	}
	return 1;
}
CMD:creerobject(playerid, params[])
{
	static id = -1;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = batiement_Create(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
    ResetEditing(playerid);
    PlayerData[playerid][pEditbatiement] = id;
	EditDynamicObject(playerid, batiementData[id][batiementObject]);
	SendServerMessage(playerid, "Créer avec succès object (ID: %d.)", id);
	return 1;
}
CMD:supobject(playerid, params[])
{
	static id = 0;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supobject[object id]");
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un object invalide.");
	batiement_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes l'object(ID: %d.)", id);
	return 1;
}
CMD:editobject(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editobject[id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, model, pos");
		return 1;
	}
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un object invalide.");
    if (!strcmp(type, "location", true))
	{
		static Float:x,Float:y,Float:z,Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);
		batiementData[id][batiementPos][0] = x;
		batiementData[id][batiementPos][1] = y;
		batiementData[id][batiementPos][2] = z;
		batiementData[id][batiementPos][3] = 0.0;
		batiementData[id][batiementPos][4] = 0.0;
		batiementData[id][batiementPos][5] = angle;
		SetDynamicObjectPos(batiementData[id][batiementObject], x, y, z);
		SetDynamicObjectRot(batiementData[id][batiementObject], 0.0, 0.0, angle);
		batiement_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de l'object (ID: %d.)", ReturnName(playerid, 0), id);
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    static model;
		if (sscanf(string, "d", model))
		    return SendSyntaxMessage(playerid, "/editbatiement [id] [model] [batiement model]");
        batiementData[id][batiementModel] = model;
		DestroyDynamicObject(batiementData[id][batiementObject]);
		batiementData[id][batiementObject] = CreateDynamicObject(batiementData[id][batiementModel], batiementData[id][batiementPos][0], batiementData[id][batiementPos][1], batiementData[id][batiementPos][2], batiementData[id][batiementPos][3], batiementData[id][batiementPos][4], batiementData[id][batiementPos][5], batiementData[id][batiementWorld], batiementData[id][batiementInterior]);
		batiement_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le model de l'object ID: %d a %d.", ReturnName(playerid, 0), id, model);
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, batiementData[id][batiementObject]);
		PlayerData[playerid][pEditbatiement] = id;
		PlayerData[playerid][pEditType] = 1;
		SendServerMessage(playerid, "Vous êtes maintenant réglez la position de l'object (ID: %d.)", id);
		return 1;
	}
	return 1;
}
CMD:giveplzz(playerid, params[])
{
	static userid,amount;
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ud", userid, amount))
		return SendSyntaxMessage(playerid, "/givecash [playerid/name] [montant]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	GiveMoney(userid, amount);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a given %s a %s.", ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
 	Log_Write("logs/admin_log.txt", "[%s] %s a given %s a %s.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
	return 1;
}
CMD:nuit(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	SetPlayerTime(playerid,0,0);
	SendServerMessage(playerid,"Spam: Attention ta 30 seconde de nuit avec cette commande!");
	return 1;
}
CMD:creercar(playerid, params[])
{
	static model[32],color1,color2,id = -1,type = 0,loca = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "s[32]I(-1)I(-1)I(0)I(0)", model, color1, color2, type, loca))
 	{
	 	SendSyntaxMessage(playerid, "/creercar [model id/name] [color 1] [color 2] <faction id> <location 0/1>");
	 	return 1;
	}
	if ((model[0] = GetVehicleModelByName(model)) == 0)
	    return SendErrorMessage(playerid, "Model invalid.");
	static Float:x,Float:y,Float:z,Float:angle;
    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	id = Car_Create(0, model[0], x, y, z, angle, color1, color2, type,loca);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SetPlayerPosEx(playerid, x, y, z + 2, 1000);
	SendServerMessage(playerid, "Créer avec succès vehicle (ID: %d.)", CarData[id][carVehicle]);
	Log_Write("logs/vehicule.txt", "[%s] %s a creer le vehicule a %d.", ReturnDate(), ReturnName(playerid),CarData[id][carVehicle]);
	return 1;
}
CMD:setfuel(playerid, params[])
{
	static id = 0,amount,vehicleid;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "dd", id, amount))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{
			vehicleid = GetPlayerVehicleID(playerid);
			id = Car_GetID(vehicleid);
		    if (sscanf(params, "d", amount))
		        return SendSyntaxMessage(playerid, "/setfuel [montant]");
			if (amount < 0)
			    return SendErrorMessage(playerid, "Le montant ne peut être plus bas que 0.");
			CarData[id][carfuel]= amount;
			Car_Save(id);
			SendServerMessage(playerid, "Vous avez mis l'essence du vehicule ID: %d a %d en pourcantage.", id, amount);
			return 1;
		}
		else return SendSyntaxMessage(playerid, "/setfuel [vehicle id] [montant]");
	}
	if (!IsValidVehicle(id))
	    return SendErrorMessage(playerid, "ID de vehicule invalide.");
	if (amount < 0)
 		return SendErrorMessage(playerid, "Le montant ne peut être plus bas que 0.");
	CarData[id][carfuel] = amount;
	Car_Save(id);
	SendServerMessage(playerid, "Vous avez set the fuel du vehicule ID: %d a %d en pourcantage.", id, amount);
	Log_Write("logs/vehicule.txt", "[%s] %s a modifier l'essene du vehicule a %d a %d.", ReturnDate(), ReturnName(playerid),id,amount);
	return 1;
}
CMD:supcar(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    /*if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Vous devez êtres le conducteur.");*/
	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{id = GetPlayerVehicleID(playerid);}
		else return SendSyntaxMessage(playerid, "/supcar [ID]");
	}
	if (!IsValidVehicle(id) || Car_GetID(id) == -1)
	    return SendErrorMessage(playerid, "ID de vehicule invalide.");
    RemovePlayerFromVehicle(playerid);
	RemovePlayerAttachedObject(playerid, 6);
	Car_Delete(Car_GetID(id));
	SendVehiculeMessage(playerid, "Vous avez supprimé avec succes vehicle (ID: %d.)", id);
	Log_Write("logs/vehicule.txt", "[%s] %s a supprimer le vehicule a %d.", ReturnDate(), ReturnName(playerid),CarData[id][carVehicle]);
	return 1;
}
CMD:setitem(playerid, params[])
{
	static userid,item[32],amount;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "uds[32]", userid, amount, item))
	    return SendSyntaxMessage(playerid, "/setitem [playerid/name] [montant] [item name]");
    if (IsFurnitureItem(item))
	{
	    for (new i = 0; i < sizeof(g_aFurnitureData); i ++) if (!strcmp(g_aFurnitureData[i][e_FurnitureName], item, true))
		{
	        Inventory_Set(userid, g_aFurnitureData[i][e_FurnitureName], g_aFurnitureData[i][e_FurnitureModel], amount);
			SendServerMessage(playerid, "Vous avez set %s \"%s\" a %d.", ReturnName(userid, 0), item, amount);
			return 1;
		}
	}
	else for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
	{
	    if (!strcmp(item, "Telephone", true)) {
	        PlayerData[userid][pPhone] = random(90000) + 10000;
	    }
        Inventory_Set(userid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], amount);
		return SendServerMessage(playerid, "Vous avez set %s \"%s\" a %d.", ReturnName(userid, 0), item, amount);
	}
	Log_Write("logs/spawnitem.txt", "[%s] %s a set item %s a %d ", ReturnDate(), ReturnName(userid, 0), item, amount);
	SendErrorMessage(playerid, "Nom invalide (use /itemlist for a list).");
	
	return 1;
}
CMD:itemlist(playerid, params[])
{
	static string[5500];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (!strlen(string)) {
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) {
			format(string, sizeof(string), "%s%s\n", string, g_aInventoryItems[i][e_InventoryItem]);
		}
	}
	return Dialog_Show(playerid, ShowO, DIALOG_STYLE_LIST, "List of Items", string, "Valider", "Annuler");
}
CMD:creerimpound(playerid, params[])
{
	static id = -1,Float:x,Float:y,Float:z;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
 		return SendErrorMessage(playerid, "Vous pouvez créer seulement a l'extérieur.");
	GetPlayerPos(playerid, x, y, z);
	id = Impound_Create(x, y, z);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES.");
	SendServerMessage(playerid, "Créer avec succès impound lot (ID: %d.)", id);
	return 1;
}
CMD:supimpound(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supimpound [impound id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !ImpoundData[id][impoundExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID fourrière invalide.");
	Impound_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes impound lot (ID: %d.)", id);
	return 1;
}
CMD:editimpound(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editimpound [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, release");
		return 1;
	}
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !ImpoundData[id][impoundExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID fourrière invalide.");
	if (!strcmp(type, "location", true))
	{
	    static Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid, x, y, z);
		ImpoundData[id][impoundLot][0] = x;
		ImpoundData[id][impoundLot][1] = y;
		ImpoundData[id][impoundLot][2] = z;
		Impound_Refresh(id);
		Impound_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de impound (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "release", true))
	{
	    static Float:x,Float:y,Float:z,Float:angle;
	    GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		ImpoundData[id][impoundRelease][0] = x;
		ImpoundData[id][impoundRelease][1] = y;
		ImpoundData[id][impoundRelease][2] = z;
		ImpoundData[id][impoundRelease][3] = angle;
		Impound_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le point de release du impound (ID: %d.)", ReturnName(playerid, 0), id);
	}
	return 1;
}
CMD:restart(playerid, params[])
{
	new time;
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (g_ServerRestart)
	{
	    TextDrawHideForAll(gServerTextdraws[1]);
	    g_ServerRestart = 0;
	    g_RestartTime = 0;
	    return SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a commencé un restart serveur.", ReturnName(playerid, 0));
	}
	if (sscanf(params, "d", time))
	    return SendSyntaxMessage(playerid, "/restart [seconds]");
	if (time < 2 || time > 120)
	    return SendErrorMessage(playerid, "Minimum 2 et max 120.");
    TextDrawShowForAll(gServerTextdraws[1]);
	g_ServerRestart = 1;
	g_RestartTime = time;
	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a commencer un restart et sera effectué a %d seconds.", ReturnName(playerid, 0), time);
	//cmd_saveall(playerid, "");
	return 1;
}
CMD:asellmaison(playerid, params[])
{
	new houseid = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", houseid))
	    return SendSyntaxMessage(playerid, "/asellmaison [maison ID]");
	if ((houseid < 0 || houseid >= MAX_HOUSES) || !HouseData[houseid][houseExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID maison invalide.");
	HouseData[houseid][houseOwner] = 0;
	House_Refresh(houseid);
	House_Save(houseid);
	SendServerMessage(playerid, "Vous avez vendu la maison (ID: %d.)", houseid);
	return 1;
}
CMD:asellbiz(playerid, params[])
{
	new bizid = -1;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", bizid))
	    return SendSyntaxMessage(playerid, "/asellbiz [biz ID]");
	if ((bizid < 0 || bizid >= MAX_HOUSES) || !BusinessData[bizid][bizExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	BusinessData[bizid][bizOwner] = 0;
	Business_Refresh(bizid);
	Business_Save(bizid);
	SendServerMessage(playerid, "Vous avez vendu le biz (ID: %d.)", bizid);
	return 1;
}
CMD:jetpack(playerid, params[])
{
	new userid;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
 	{
 	    PlayerData[playerid][pJetpack] = 1;
	 	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	}
	else
	{
		PlayerData[userid][pJetpack] = 1;
		SetPlayerSpecialAction(userid, SPECIAL_ACTION_USEJETPACK);
		SendServerMessage(playerid, "Vous avez spawned a jetpack pour %s.", ReturnName(userid, 0));
	}
	return 1;
}
CMD:setweather(playerid, params[])
{
	new weatherid;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", weatherid))
	    return SendSyntaxMessage(playerid, "/setweather [weather ID]");
	SetWeather(weatherid);
	SendServerMessage(playerid, "Vous avez changé la météo par (ID: %d.)", weatherid);
	return 1;
}
CMD:setcarhp(playerid, params[])
{
	static id = 0,Float:amount;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "df", id, amount))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{
		    id = GetPlayerVehicleID(playerid);
		    if (sscanf(params, "f", amount))
		        return SendSyntaxMessage(playerid, "/setcarhp [montant]");
			if (amount < 0.0)
			    return SendErrorMessage(playerid, "Le montant ne peut être plus bas que 0.");
			new idk = Car_GetID(id);
			CarData[idk][carvie] = amount;
			Car_Save(idk);
			SetVehicleHealth(id, amount);
			SendServerMessage(playerid, "Vous avez mis la vie du vehicule ID: %d a %.1f.", id, amount);
			return 1;
		}
		else return SendSyntaxMessage(playerid, "/setcarhp [vehicle id] [montant]");
	}
	if (!IsValidVehicle(id))
	    return SendErrorMessage(playerid, "ID de vehicule invalide.");
	if (amount < 300.0)
	    return SendErrorMessage(playerid, "Le montant ne peut être plus bas que 300.0");
	new idk = Car_GetID(id);
	CarData[idk][carvie] = amount;
	Car_Save(idk);
	SetVehicleHealth(id, amount);
	SendServerMessage(playerid, "Vous avez mis la vie du vehicule ID: %d a %.1f.", id, amount);
	Log_Write("logs/vehicule.txt", "[%s] %s a modifier la vie du vehicule %d a %d.", ReturnDate(), ReturnName(playerid),id,amount);
	return 1;
}
CMD:editcar(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editcar [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, faction, color1, color2, reset, carowner,four, boitier");
		return 1;
	}
	if (!IsValidVehicle(id) || Car_GetID(id) == -1)
	    return SendErrorMessage(playerid, "ID de vehicule invalide.");
	id = Car_GetID(id);
	if (!strcmp(type, "location", true))
	{
 		GetPlayerPos(playerid, CarData[id][carPos][0], CarData[id][carPos][1], CarData[id][carPos][2]);
		GetPlayerFacingAngle(playerid, CarData[id][carPos][3]);
		Car_Save(id);
		Car_Spawn(id);
		SetPlayerPosEx(playerid, CarData[id][carPos][0], CarData[id][carPos][1], CarData[id][carPos][2] + 2.0, 1000);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de vehicle (ID: %d.)", ReturnName(playerid, 0), CarData[id][carVehicle]);
	}
	else if (!strcmp(type, "four", true))
	{
	    if (CarData[id][carExists] && CarData[id][carImpounded] != -1)
	    {
            CarData[id][carPos][0] = ImpoundData[id][impoundRelease][0];
            CarData[id][carPos][1] = ImpoundData[id][impoundRelease][1];
            CarData[id][carPos][2] = ImpoundData[id][impoundRelease][2];
            CarData[id][carPos][3] = ImpoundData[id][impoundRelease][3];	
			SetVehiclePos(CarData[id][carVehicle], CarData[id][carPos][0], CarData[id][carPos][1], CarData[id][carPos][2]);
			SetVehicleZAngle(CarData[id][carVehicle], CarData[id][carPos][3]);
            CarData[id][carImpounded] = -1;
            CarData[id][carImpoundPrice] = 0;
            Car_Save(id);
	    }
	}
	else if (!strcmp(type, "faction", true))
	{
	    new typeint;
	    if (sscanf(string, "d", typeint))
     	{
     	    SendSyntaxMessage(playerid, "/editcar [id] [faction] [type]");
		 	return 1;
		}
		if (typeint < 0 || typeint > 25)
		    return SendErrorMessage(playerid, "Le type doit être minimum 0 et max 25.");
		CarData[id][carFaction] = typeint;
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le type de vehicule ID: %d a %d.", ReturnName(playerid, 0), CarData[id][carVehicle], typeint);
	}
    else if (!strcmp(type, "color1", true))
	{
	    new color1;
	    if (sscanf(string, "d", color1))
			return SendSyntaxMessage(playerid, "/editcar [id] [color1] [color 1]");
		if (color1 < 0 || color1 > 255)
		    return SendErrorMessage(playerid, "La couleur doit être minimun 0 et max 255.");
		CarData[id][carColor1] = color1;
		ChangeVehicleColor(CarData[id][carVehicle], CarData[id][carColor1], CarData[id][carColor2]);
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la couleur 1 du vehicule ID: %d a %d.", ReturnName(playerid, 0), CarData[id][carVehicle], color1);
		Log_Write("logs/vehicule.txt", "[%s] %s a ajusté le color1 a %d.", ReturnDate(), ReturnName(playerid),CarData[id][carVehicle]);
	}
    else if (!strcmp(type, "carowner", true))
	{
	    new color1;
	    if (sscanf(string, "d", color1))
			return SendSyntaxMessage(playerid, "/editcar [id] [carowner]");
		CarData[id][carOwner] =  GetPlayerSQLID(color1);
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le owner du vehicule ID: %d a %d.", ReturnName(playerid, 0), CarData[id][carVehicle], color1);
	}
    else if (!strcmp(type, "color2", true))
	{
	    new color2;
	    if (sscanf(string, "d", color2))
			return SendSyntaxMessage(playerid, "/editcar [id] [color2] [color 2]");
		if (color2 < 0 || color2 > 255)
		    return SendErrorMessage(playerid, "La couleur doit être minimun 0 et max 255.");
		CarData[id][carColor2] = color2;
		ChangeVehicleColor(CarData[id][carVehicle], CarData[id][carColor1], CarData[id][carColor2]);
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la couleur 2 du vehicule ID: %d a %d.", ReturnName(playerid, 0), CarData[id][carVehicle], color2);
		Log_Write("logs/vehicule.txt", "[%s] %s a ajuster le color2 vehicule a %d.", ReturnDate(), ReturnName(playerid),CarData[id][carVehicle]);
	}
    else if (!strcmp(type, "reset", true))
	{
		CarData[id][carFaction] = 0;
		CarData[id][carOwner] = 0;
		CarData[id][carKilo] = 0;
		CarData[id][carMetre] = 0;
		if(CarData[id][carLoca] == 1)
		{CarData[id][carLocaID] = 0;}
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a reset le vehicule ID: %d.", ReturnName(playerid, 0), CarData[id][carVehicle]);
	}
    else if (!strcmp(type, "boitier", true))
	{
	    new color1;
	    if (sscanf(string, "d", color1))
			return SendSyntaxMessage(playerid, "/editcar [id] [boitier]");
		if (color1 < 0 || color1 > 1)
		    return SendErrorMessage(playerid, "Automatique = 0, Manuel = 1.");
		CarData[id][boitier] =  color1;
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le boitier du vehicule ID: %d a %d.", ReturnName(playerid, 0), CarData[id][carVehicle], color1);
	}
	return 1;
}
CMD:creergarbage(playerid, params[])
{
	static id = -1,type;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creergarbage [type]");
	    SendSyntaxMessage(playerid, "[TYPES]:{FFFFFF} 1: Dumpster | 2: Trash Can| 3: Poubelle interieur");
		return 1;
	}
	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Le type doit être minimum 1 et max 3.");
	id = Garbage_Create(playerid, type);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès garbage bin (ID: %d.)", id);
	return 1;
}
CMD:supgarbage(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supgarbage [garbage id]");
	if ((id < 0 || id >= MAX_DYNAMIC_TRASH) || !GarbageData[id][garbageExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID poubelle invalide.");
	Garbage_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes garbage bin (ID: %d.)", id);
	return 1;
}
CMD:creervendor(playerid, params[])
{
	static id = -1,type;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creervendor [type]");
	    SendSyntaxMessage(playerid, "[TYPES]:{FFFFFF} 1: Food | 2: Soda");
		return 1;
	}
	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Le type doit être minimum 1 et max 2.");
	id = Vendor_Create(playerid, type);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès vendor (ID: %d.)", id);
	return 1;
}
CMD:supvendor(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supvendor [vendor id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !VendorData[id][vendorExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID vendeur invalide.");
	Vendor_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes vendor (ID: %d.)", id);
	return 1;
}
CMD:panel(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4 || !IsPlayerAdmin(playerid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (g_ServerLocked)
		Dialog_Show(playerid, ServerPanel, DIALOG_STYLE_LIST, "Server Panel", "Unlock Server\nSet Hostname\nExecute Query", "Valider", "Annuler");
	else Dialog_Show(playerid, ServerPanel, DIALOG_STYLE_LIST, "Server Panel", "Lock Server\nSet Hostname\nExecute Query", "Valider", "Annuler");
	return 1;
}
CMD:setquantity(playerid, params[])
{
	static
	    id = -1,
		amount;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if ((id = Item_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche du bon point pour faire cela.");
	if (sscanf(params, "d", amount))
	    return SendSyntaxMessage(playerid, "/setquantity [montant]");
	if (amount < 1)
	    return SendErrorMessage(playerid, "Le numéro du montant ne peut être que 1 minimum.");
    Item_SetQuantity(id, amount);
    Log_Write("logs/spawnitem.txt", "[%s] %s a set the quantity of %s a %d.", ReturnDate(), ReturnName(playerid, 0), DroppedItems[id][droppedItem], amount);
    SendServerMessage(playerid, "Vous avez set the quantity of \"%s\" a %d.", DroppedItems[id][droppedItem], amount);
    return 1;
}
CMD:supitem(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if ((id = Item_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche du bon point pour faire cela.");
    SendServerMessage(playerid, "Vous avez supprimé un(e) \"%s\".", DroppedItems[id][droppedItem]);
    Item_Delete(id);
    return 1;
}
CMD:adestroybox(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	foreach (new i : Player) if (BoomboxData[i][boomboxPlaced] && IsPlayerInRangeOfPoint(playerid, 3.0, BoomboxData[i][boomboxPos][0], BoomboxData[i][boomboxPos][1], BoomboxData[i][boomboxPos][2])) {
		Boombox_Destroy(i);
		SendServerMessage(playerid, "Vous avez détruie %s boombox.", ReturnName(i, 0));
		return SendServerMessage(i, "%s a détruie votre boombox.", ReturnName(playerid, 0));
	}
	SendErrorMessage(playerid, "Vous n'êtes pas proche du bon point pour faire cela.");
	return 1;
}
CMD:creerrack(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = Rack_Create(playerid, -1);
	if (id == -1) return SendErrorMessage(playerid, "MAX LIMITES");
    ResetEditing(playerid);
    PlayerData[playerid][pEditRack] = id;
	EditDynamicObject(playerid, RackData[id][rackObjects][4]);
	SendServerMessage(playerid, "Créer avec succès rack (ID: %d.)", id);
	return 1;
}
CMD:editrack(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/editrack [rack id]");
	if ((id < 0 || id >= MAX_WEAPON_RACKS) || !RackData[id][rackExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID rack invalide.");
	ResetEditing(playerid);
	PlayerData[playerid][pEditRack] = id;
	EditDynamicObject(playerid, RackData[id][rackObjects][4]);
	SendServerMessage(playerid, "Tu édite maintenant weapon rack (ID: %d.)", id);
	return 1;
}
CMD:suprack(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suprack [rack id]");
	if ((id < 0 || id >= MAX_WEAPON_RACKS) || !RackData[id][rackExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID rack invalide.");
	Rack_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes weapon rack (ID: %d.)", id);
	return 1;
}
CMD:flipcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (vehicleid > 0 && isnull(params))
	{
		FlipVehicle(vehicleid);
		SendVehiculeMessage(playerid, "Vous avez flip votre current vehicle.");
	}
	else
	{
		if (sscanf(params, "d", vehicleid))
	    	return SendSyntaxMessage(playerid, "/flipcar [vehicle ID]");
		else if (!IsValidVehicle(vehicleid))
	    	return SendErrorMessage(playerid, "ID de vehicule invalide.");
		FlipVehicle(vehicleid);
		SendVehiculeMessage(playerid, "Vous avez flip vehicle (ID: %d.)", vehicleid);
	}
	return 1;
}
CMD:creerspeed(playerid, params[])
{
	static Float:limit,Float:range;
	if (sscanf(params, "ff", limit, range))
		return SendSyntaxMessage(playerid, "/creerspeed [speed limit] [range] (default range: 30)");
	if (limit < 5.0 || limit > 150.0)
	    return SendErrorMessage(playerid, "Speed limite minimun 5 et max 150.");
	if (range < 5.0 || range > 50.0)
	    return SendErrorMessage(playerid, "Le range ne peut être 5 et max 50.");
	if (Speed_Nearest(playerid) != -1)
	    return SendErrorMessage(playerid, "Tu ne peut mettre dans le meme range d'une autre speed camera.");
	new id = Speed_Create(playerid, limit, range);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Vous avez créer speed camera (ID: %d.)", id);
	return 1;
}
CMD:supspeed(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supspeed [speed id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !SpeedData[id][speedExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID radar invalide.");
	Speed_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes speed camera (ID: %d.)", id);
	return 1;
}
CMD:supperso(playerid, params[])
{
	static query[128];
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/supperso [character name]");
    if (!IsValidPlayerName(params))
	    return SendErrorMessage(playerid, "Vous avez spécifier un nom de format invalide.");
	format(query, sizeof(query), "SELECT `ID`, `Admin` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnDeleteCharacter", "ds", playerid, params);
	return 1;
}
CMD:healall(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	foreach (new i : Player) {
	    SetPlayerHealth(i, 100.0);
	}
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a soigné tout tout les gens IG.", ReturnName(playerid, 0));
	return 1;
}
CMD:masked(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	static name[24];
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    foreach (new i : Player) if (PlayerData[i][pMaskOn]) {
        GetPlayerName(i, name, sizeof(name));
        SendClientMessageEx(playerid, COLOR_WHITE, "* %s (#%d)", name, PlayerData[i][pMaskID]);
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}
CMD:setinventory(playerid, params[])
{
	static userid,capacity;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ud", userid, capacity))
	    return SendSyntaxMessage(playerid, "/setinventory [playerid/name] [montant]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Le numéro du player est déconnecté.");
	if (capacity < 1 || capacity > 35)
	    return SendErrorMessage(playerid, "La capacité est max 35.");
	PlayerData[userid][pCapacity] = capacity;
	SendServerMessage(playerid, "Vous avez set %s inventory capacity a %d items.", ReturnName(userid, 0), capacity);
	SendServerMessage(userid, "%s a mis votre inventory capacity a %d items.", ReturnName(playerid, 0), capacity);
	return 1;
}
CMD:creergraffiti(playerid, params[])
{
	static id = -1,Float:x,Float:y,Float:z,Float:angle;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
 		return SendErrorMessage(playerid, "Tu ne peut créer de graffiti points a l'extérieur seulement.");
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	id = Graffiti_Create(x, y, z, angle);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	EditDynamicObject(playerid, GraffitiData[id][graffitiObject]);
	PlayerData[playerid][pEditGraffiti] = id;
	SendServerMessage(playerid, "Créer avec succès graffiti (ID: %d.)", id);
	return 1;
}
CMD:supgraffiti(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supgraffiti [graffiti id]");
	if ((id < 0 || id >= MAX_GRAFFITI_POINTS) || !GraffitiData[id][graffitiExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID graffiti tage invalide.");
	Graffiti_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes graffiti (ID: %d.)", id);
	return 1;
}
CMD:afire(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	static Float:fX,Float:fY,Float:fZ;
	RandomFire();
	GetDynamicObjectPos(g_aFireObjects[0], fX, fY, fZ);
	SendServerMessage(playerid, "Vous avez créer un feu aléatoire a %s.", GetLocation(fX, fY, fZ));
	return 1;
}
CMD:akillfire(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	{
	    g_aFireExtinguished[i] = 0;
	    if (IsValidDynamicObject(g_aFireObjects[i]))
	        DestroyDynamicObject(g_aFireObjects[i]);
	}
	SendServerMessage(playerid, "Vous avez tuer un feu.");
	return 1;
}
CMD:ahide(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	switch (PlayerData[playerid][pAdminHide])
	{
	    case 0:
	    {
	        PlayerData[playerid][pAdminHide] = 1;
	        SendServerMessage(playerid, "Tu est maintenant invisible de la liste d'admin");
		}
		case 1:
	    {
	        PlayerData[playerid][pAdminHide] = 0;
	        SendServerMessage(playerid, "Tu est maintenant visible de la liste d'admin.");
		}
	}
	return 1;
}
CMD:ah2(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	switch (PlayerData[playerid][pAdminHide])
	{
	    case 0:
	    {
	        PlayerData[playerid][pAdminHide] = 2;
	        SendServerMessage(playerid, "Tu a été donner le pouvoir de devenir invisible sans les maluces!");
		}
		case 2:
	    {
	        PlayerData[playerid][pAdminHide] = 0;
	        SendServerMessage(playerid, "Tu est maintenant visible de la liste d'admin.");
		}
	}
	return 1;
}
CMD:creerdetector(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	static query[255];
	for (new i = 0; i < MAX_METAL_DETECTORS; i ++) if (!MetalDetectors[i][detectorExists])
	{
	    MetalDetectors[i][detectorExists] = 1;
	    MetalDetectors[i][detectorInterior] = GetPlayerInterior(playerid);
	    MetalDetectors[i][detectorWorld] = GetPlayerVirtualWorld(playerid);
	    GetPlayerPos(playerid, MetalDetectors[i][detectorPos][0], MetalDetectors[i][detectorPos][1], MetalDetectors[i][detectorPos][2]);
	    GetPlayerFacingAngle(playerid, MetalDetectors[i][detectorPos][3]);
		format(query, sizeof(query), "INSERT INTO `detectors` (`detectorX`, `detectorY`, `detectorZ`, `detectorAngle`, `detectorInterior`, `detectorWorld`) VALUES('%.4f', '%.4f', '%.4f', '%.4f', '%d', '%d')", MetalDetectors[i][detectorPos][0], MetalDetectors[i][detectorPos][1], MetalDetectors[i][detectorPos][2], MetalDetectors[i][detectorPos][3], MetalDetectors[i][detectorInterior], MetalDetectors[i][detectorWorld]);
		mysql_tquery(g_iHandle, query, "OnDetectorCreated", "d", i);
	    Detector_Refresh(i);
	    SendServerMessage(playerid, "Vous avez créer metal detector (ID: %d.)", i);
	    return 1;
	}
	SendErrorMessage(playerid, "MAX LIMITES");
	return 1;
}
CMD:supdetector(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supdetector [detector id]");
	if ((id < 0 || id >= MAX_METAL_DETECTORS) || !MetalDetectors[id][detectorExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID detecteur invalide.");
	Detector_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes detector (ID: %d.)", id);
	return 1;
}
CMD:supplant(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suppplant [plant id]");
	if ((id < 0 || id >= MAX_DRUG_PLANTS) || !PlantData[id][plantExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID plante invalide");
	Plant_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes plant (ID: %d.)", id);
	return 1;
}
CMD:creerbillboard(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = Billboard_Create(playerid, -1);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES billboards.");
	SendServerMessage(playerid, "Créer avec succès billboard (ID: %d.)", id);
	return 1;
}
CMD:editbillboard(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbillboard [id] [name]");
	    SendSyntaxMessage(playerid, "[NAMES]:{FFFFFF} location, name, price, message, owner, range");
		return 1;
	}
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !BillBoardData[id][bbExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	if (!strcmp(type, "location", true))
	{
 		GetPlayerPos(playerid, BillBoardData[id][bbPos][0], BillBoardData[id][bbPos][1], BillBoardData[id][bbPos][2]);
		Billboard_Refresh(id);
		Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté la position de billboard (ID: %d.)", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;
	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [price] [new price]");
	    BillBoardData[id][bbPrice] = price;
	    Billboard_Refresh(id);
	    Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le prix de billboard ID: %d a %s $.", ReturnName(playerid, 0), id, FormatNumber(price));
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];
	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [name] [new name]");
	    format(BillBoardData[id][bbName], 32, name);
	    Billboard_Refresh(id);
	    Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le nom du billboard ID: %d a \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "message", true))
	{
	    new name[32];
	    if (sscanf(string, "s[230]", name))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [message] [new message] (Max Chars: 230)");
	    format(BillBoardData[id][bbMessage], 32, name);
	    Billboard_Refresh(id);
	    Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le message du billboard ID: %d a \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "owner", true))
	{
	    new giveplayerid;
	    if (sscanf(string, "d", giveplayerid))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [(remove)owner] [playerid]");
        if (giveplayerid == INVALID_PLAYER_ID)
	    	return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
		BillBoardData[id][bbOwner] = GetPlayerSQLID(giveplayerid);
	    Billboard_Refresh(id);
	    Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté the owner of billboard ID: %d", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "removeowner", true))
	{
	    if (sscanf(string, "d"))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [removeowner]");
		BillBoardData[id][bbOwner] = 0;
	    Billboard_Refresh(id);
	    Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a enlever le proprio billboard ID: %d", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "range", true))
	{
	    new range;
	    if (sscanf(string, "d", range))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [range] [new range]");
        if(range < 10)
		{
		    SendErrorMessage(playerid, "Le range doit etre entre  10-200");
		    return 1;
		}
		if(range > 200)
		{
		    SendErrorMessage(playerid, "Le range doit etre entre  10-200");
		    return 1;
		}
	    BillBoardData[id][bbRange] = range;
	    Billboard_Refresh(id);
	    Billboard_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté Le range of billboard ID: %d a %d.", ReturnName(playerid, 0), id, range);
	}
	return 1;
}
CMD:supbillboard(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supbillboard [bb id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !BillBoardData[id][bbExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID panneau d'affichage invalide.");
	Billboard_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes billboard (ID: %d.)", id);
	return 1;
}
CMD:creerbot(playerid, params[])
{
    new Float:get[4];
    if (PlayerData[playerid][pAdmin] < 4)
		return SendErrorMessage(playerid, "Vous devez être dans l'équipe d'adminitration pour faire cela.");
    GetPlayerPos(playerid, get[0], get[1], get[2]);
    GetPlayerFacingAngle(playerid, get[3]);
	SetPVarInt(playerid,"actorvw",GetPlayerVirtualWorld(playerid));
    SetPVarFloat(playerid, "acFloatX", get[0]);
    SetPVarFloat(playerid, "acFloatY", get[1]);
    SetPVarFloat(playerid, "acFloatZ", get[2]);
    SetPVarFloat(playerid, "acRotation", get[3]);
    Dialog_Show(playerid, D_ACTORCREATE, DIALOG_STYLE_INPUT, "Désigner", "Sélectionnez un skin pour votre actor", "Valider", "Quitter");
    return true;
}
CMD:salaireanpe(playerid, params[])
{
	new salairejobinfoid,cariste = info_salairejobinfo[salairejobinfoid][salairejobinfocariste],manutentionnaire = info_salairejobinfo[salairejobinfoid][salairejobinfomanutentionnaire];
	new dock = info_salairejobinfo[salairejobinfoid][salairejobinfodock],miner = info_salairejobinfo[salairejobinfoid][salairejobinfominer];
	new usineelectronic = info_salairejobinfo[salairejobinfoid][salairejobinfoelectronic],bucheron = info_salairejobinfo[salairejobinfoid][salairejobinfobucheron];
	new menuisier = info_salairejobinfo[salairejobinfoid][salairejobinfomenuisier],generateur = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur];
	new electricien = info_salairejobinfo[salairejobinfoid][salairejobinfoelectricien],arme = info_salairejobinfo[salairejobinfoid][salairejobinfoarme];
	new petrol = info_salairejobinfo[salairejobinfoid][salairejobinfopetrolier],boucher = info_salairejobinfo[salairejobinfoid][salairejobinfoboucher];
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	Dialog_Show(playerid,SalaireAnpe,DIALOG_STYLE_TABLIST,"Liste des salaires de l'anpe","{ffffff}Cariste: \t{ff3300}%d${ffffff}\nManutentionnaire: \t{ff3300}%d${ffffff}\nDock port: \t{ff3300}%d${ffffff}{ffffff}\nMineur: \t{ff3300}%d${ffffff}\nUsine eletronic: \t{ff3300}%d${ffffff}\nBucheron: \t{ff3300}%d${ffffff}\nMenuisier: \t{ff3300}%d${ffffff}\nTechnicien generateur: \t{ff3300}%d${ffffff}\nElectricien: \t{ff3300}%d${ffffff}\nFabrication d'arme: \t{ff3300}%d${ffffff}\nPetrolier: \t{ff3300}%d${ffffff}\nBoucher: \t{ff3300}%d${ffffff}","Modifier","Retour",cariste,manutentionnaire,dock,miner,usineelectronic,bucheron,menuisier,generateur,electricien,arme,petrol,boucher);	
	return 1;
}
//serveur setting
CMD:serveur(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
    	return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new serveurinfo;
	Dialog_Show(playerid,serveur,DIALOG_STYLE_TABLIST,"Serveur setting",serveursetting1,"Valider","Fermer",info_serveursetting[serveurinfo][settingoocactive],info_serveursetting[serveurinfo][settingpmactive],info_serveursetting[serveurinfo][settingbraquagenpcactive],info_serveursetting[serveurinfo][settingbraquagebankactive],info_serveursetting[serveurinfo][settingafkactive],info_serveursetting[serveurinfo][settingafktime],info_serveursetting[serveurinfo][settingvilleactive],info_serveursetting[serveurinfo][settingnouveau],info_serveursetting[serveurinfo][settingpolice],info_serveursetting[serveurinfo][settingswat],info_serveursetting[serveurinfo][settingwl]);
	return 1;
}
CMD:arsabot(playerid, params[])
{
	new id = -1;
	if ((id = Car_Nearest(playerid)) != -1)
	{
		if (PlayerData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "Vous n'avez pas la permission d'utiliser cette commande, il faut être admin 3");
		if (CarData[id][carSabot] == 0)
		return SendErrorMessage(playerid, "Ce véhicule n'as pas de sabot");
		CarData[id][carSabot] = 0;
		CarData[id][carSabPri] = 0;
		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "%s a retiré un sabot sur le véhicule ID: %d.",ReturnName(playerid, 0), CarData[id][carVehicle]);
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas près d'un véhicule.");
	return 1;
}
CMD:ao(playerid, params[])
{
	static string[256];

	if (PlayerData[playerid][pAdmin] < 1)
	return SendErrorMessage(playerid, "Vous n'avez pas la permission d'utiliser cette commande.");

	if (sscanf(params, "s[256]", string))
	return SendSyntaxMessage(playerid, "/ao <texte global>");

	SendClientMessageToAllEx(COLOR_RED, "%s (%d): %s", ReturnName(playerid, 0),PlayerData[playerid][pAdmin],string);
	return 1;
}
CMD:position(playerid, params[])
{
	static Float:x,Float:y,Float:z;
	if (PlayerData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "Vous devez être dans l'équipe d'adminitration pour faire cela.");
	if (sscanf(params, "fff", x,y,z))
	return SendSyntaxMessage(playerid, "/position <x> <y> <z>");
	if (IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
	}
	else SetPlayerPos(playerid, x, y, z+1);
	return 1;
}
//caisse
CMD:creercaisse(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = caisse_Create(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès caisse (ID: %d.)", id);
	return 1;
}
CMD:supcaisse(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supcaisse [caisse id]");
	if ((id < 0 || id >= MAX_caisseS) || !caisseMachineData[id][caisseExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une porte invalide.");
	caisse_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes caisse (ID: %d.)", id);
	return 1;
}
CMD:editcaisse(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editcaisse [id] pos");
		return 1;
	}
	if ((id < 0 || id >= MAX_caisseS) || !caisseMachineData[id][caisseExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une porte invalide.");
    else if (!strcmp(type, "pos", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, caisseMachineData[id][caisseObject]);
		PlayerData[playerid][pEditcaisse] = id;
		PlayerData[playerid][pEditType] = 1;
		SendServerMessage(playerid, "Vous êtes maintenant réglez la position de de la porte (ID: %d.)", id);
		return 1;
	}
	return 1;
}
CMD:skinstest(playerid,params[])
{
	static id,idd;
	if(PlayerData[playerid][pAdmin] == 4)
	{
		if(sscanf(params, "dd",id,idd)) return SendServerMessage(playerid,"Utilisation: /skins id idskin");
		SetPlayerSkin(id,idd);
		PlayerData[id][pSkin] = idd;
	}
	return 1;
}
CMD:minutecheck(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	MinuteCheck();
	return 1;
}
CMD:resetveh(playerid,params[])
{
	new string[80];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	foreach(new i: Player)
	{
		for (new ii = 1; i != MAX_VEHICLES; ii ++)
		{
			format(string, sizeof(string), "UPDATE `characters` SET `LocaID` = '0'");
			mysql_tquery(g_iHandle, string);
			format(string, sizeof(string), "UPDATE `cars` SET `carLocaID` = '0'");
			mysql_tquery(g_iHandle, string);
			PlayerData[i][pLocaID] = 0;
			CarData[ii][carLocaID] = 0;
			Car_Save(ii);
		}
	}
	return 1;
}
CMD:event(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if(event == 0)
	{
		event = 1;
		SendAdminAlert(COLOR_LIGHTRED,"%s a activé le mode event.",ReturnName(playerid, 0));
		return 1;
	}
	if(event == 1)
	{
		event = 0;
		SendAdminAlert(COLOR_LIGHTRED,"%s a désactivé le mode event.",ReturnName(playerid, 0));
		return 1;
	}
	return 1;
}
//compte en wl
CMD:creercompte(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	static nomjoueur[24],password[60];
	if (sscanf(params, "s[24]s[60]",nomjoueur,password))
	{
	    SendSyntaxMessage(playerid, "/creercompte [nom du compte] [mot de passe]");
		return 1;
	}
	SQL_CreateAccountWL(nomjoueur,password);
	return 1;
}
CMD:creeratm(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id = Iter_Free(ATMs),label_string[64],query[144];
	if(id == -1) return SendErrorMessage(playerid,"You cannot create more ATMs");
	ATMData[id][atmRX] = ATMData[id][atmRY] = 0.0;
	GetPlayerPos(playerid, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ]);
	GetPlayerFacingAngle(playerid, ATMData[id][atmRZ]);
	ATMData[id][atmX] += (2.0 * floatsin(-ATMData[id][atmRZ], degrees));
    ATMData[id][atmY] += (2.0 * floatcos(-ATMData[id][atmRZ], degrees));
    ATMData[id][atmZ] -= 0.3;
	ATMData[id][atmObjID] = CreateDynamicObject(19324, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
    if(IsValidDynamicObject(ATMData[id][atmObjID]))
    {
        new dataArray[E_ATMDATA];
        format(dataArray[IDString], 8, "atm_sys");
        dataArray[refID] = id;
        Streamer_SetArrayData(STREAMER_TYPE_OBJECT, ATMData[id][atmObjID], E_STREAMER_EXTRA_ID, dataArray);
        EditingATMID[playerid] = id;
        EditDynamicObject(playerid, ATMData[id][atmObjID]);
    }
	#if defined ATM_USE_MAPICON
	ATMData[id][atmIconID] = CreateDynamicMapIcon(ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], 52, 0, .streamdistance = ATM_ICON_RANGE);
	#endif
	format(label_string, sizeof(label_string), "ATM (%d)\n\n{FFFFFF}\nPresser 'F' pour utiliser", id);
	ATMData[id][atmLabel] = CreateDynamic3DTextLabel(label_string, 0x1ABC9CFF, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ] + 0.85, 5.0, .testlos = 1);
	mysql_format(g_iHandle, query, sizeof(query), "INSERT INTO bank_atms SET ID=%d, PosX='%f', PosY='%f', PosZ='%f', RotX='%f', RotY='%f', RotZ='%f'", id, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ], ATMData[id][atmRX], ATMData[id][atmRY], ATMData[id][atmRZ]);
	mysql_tquery(g_iHandle, query);
	Iter_Add(ATMs, id);
	return 1;
}
CMD:editatm(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id;
	if(sscanf(params, "i", id)) return SendSyntaxMessage(playerid,"/editatm [ATM id]");
	if(!Iter_Contains(ATMs, id)) return SendErrorMessage(playerid,"ATM ID.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, ATMData[id][atmX], ATMData[id][atmY], ATMData[id][atmZ])) return SendErrorMessage(playerid,"You're not near the ATM You want to edit.");
	if(EditingATMID[playerid] != -1) return SendErrorMessage(playerid,"You are already editing an ATM.");
	EditingATMID[playerid] = id;
	EditDynamicObject(playerid, ATMData[id][atmObjID]);
	return 1;
}
CMD:supatm(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id,query[48];
	if(sscanf(params, "i", id)) return SendSyntaxMessage(playerid,"/removeatm [ATM id]");
	if(!Iter_Contains(ATMs, id)) return SendErrorMessage(playerid,"ATM ID.");
	if(IsValidDynamicObject(ATMData[id][atmObjID])) DestroyDynamicObject(ATMData[id][atmObjID]);
	ATMData[id][atmObjID] = -1;
	#if defined ATM_USE_MAPICON
	if(IsValidDynamicMapIcon(ATMData[id][atmIconID])) DestroyDynamicMapIcon(ATMData[id][atmIconID]);
    ATMData[id][atmIconID] = -1;
    #endif
    if(IsValidDynamic3DTextLabel(ATMData[id][atmLabel])) DestroyDynamic3DTextLabel(ATMData[id][atmLabel]);
    ATMData[id][atmLabel] = Text3D: -1;
    if(ATMData[id][atmTimer] != -1) KillTimer(ATMData[id][atmTimer]);
    ATMData[id][atmTimer] = -1;
    if(IsValidDynamicPickup(ATMData[id][atmPickup])) DestroyDynamicPickup(ATMData[id][atmPickup]);
    ATMData[id][atmPickup] = -1;
    ATMData[id][atmHealth] = ATM_HEALTH;
	ATMData[id][atmRegen] = 0;
	Iter_Remove(ATMs, id);
	mysql_format(g_iHandle, query, sizeof(query), "DELETE FROM bank_atms WHERE ID=%d", id);
	mysql_tquery(g_iHandle, query);
	return 1;
}
CMD:asetowner(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    new id, owner[MAX_PLAYER_NAME],query[128];
    if(sscanf(params, "is[24]", id, owner)) return SendSyntaxMessage(playerid,"/asetowner [account id] [new owner]");
    mysql_format(g_iHandle, query, sizeof(query), "UPDATE bank_accounts SET Owner='%e' WHERE ID=%d", owner, id);
    mysql_tquery(g_iHandle, query, "OnBankAccountAdminEdit", "i", playerid);
	return 1;
}
CMD:asetpassword(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    new id, password[16],query[128];
    if(sscanf(params, "is[16]", id, password)) return SendSyntaxMessage(playerid,"/asetpassword [account id] [new password]");
    mysql_format(g_iHandle, query, sizeof(query), "UPDATE bank_accounts SET Password=md5('%e') WHERE ID=%d", password, id);
    mysql_tquery(g_iHandle, query, "OnBankAccountAdminEdit", "i", playerid);
	return 1;
}
CMD:asetbalance(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    new id, balance,query[128];
    if(sscanf(params, "ii", id, balance)) return SendSyntaxMessage(playerid,"/asetbalance [account id] [balance]");
    if(balance > ACCOUNT_LIMIT) return SendErrorMessage(playerid,"Balance you specified exceeds account money limit.");
    mysql_format(g_iHandle, query, sizeof(query), "UPDATE bank_accounts SET Balance=%d WHERE ID=%d", balance, id);
    mysql_tquery(g_iHandle, query, "OnBankAccountAdminEdit", "i", playerid);
	return 1;
}
CMD:aclearlogs(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    new id, type,query[128];
    if(sscanf(params, "iI(0)", id, type))
	{
	    SendSyntaxMessage(playerid,"/aclearlogs [account id] [log type (optional)]");
	    SendClientMessage(playerid, 0xE88732FF, "TYPES: {FFFFFF}0- All | 1- Logins | 2- Deposits | 3- Withdraws | 4- Transfers | 5- Password Changes");
		return 1;
	}
	if(type > 0) {
	    mysql_format(g_iHandle, query, sizeof(query), "DELETE FROM bank_logs WHERE AccountID=%d && Type=%d", id, type);
	}else{
	    mysql_format(g_iHandle, query, sizeof(query), "DELETE FROM bank_logs WHERE AccountID=%d", id);
	}
    mysql_tquery(g_iHandle, query, "OnBankAccountAdminEdit", "i", playerid);
	return 1;
}
CMD:aremoveaccount(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    new id,query[128];
    if(sscanf(params, "i", id)) return SendSyntaxMessage(playerid,"/aremoveaccount [account id]");
    foreach(new i : Player)
    {
        if(CurrentAccountID[i] == id) CurrentAccountID[i] = -1;
    }
    mysql_format(g_iHandle, query, sizeof(query), "UPDATE bank_accounts SET Disabled=1 WHERE ID=%d", id);
    mysql_tquery(g_iHandle, query, "OnBankAccountAdminEdit", "i", playerid);
	return 1;
}
CMD:areturnaccount(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    new id,query[128];
    if(sscanf(params, "i", id)) return SendSyntaxMessage(playerid,"/areturnaccount [account id]");
    mysql_format(g_iHandle, query, sizeof(query), "UPDATE bank_accounts SET Disabled=0 WHERE ID=%d", id);
    mysql_tquery(g_iHandle, query, "OnBankAccountAdminEdit", "i", playerid);
	return 1;
}
CMD:creerbanker(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id = Iter_Free(Bankers);
	if(id == -1) return SendErrorMessage(playerid,"Can't create any more bankers.");
	new skin,label_string[64],query[144];
	if(sscanf(params, "i", skin)) return SendSyntaxMessage(playerid,"/createbanker [skin id]");
	if(!(0 <= skin <= 311)) return SendErrorMessage(playerid,"Invalid skin ID.");
	BankerData[id][Skin] = skin;
	GetPlayerPos(playerid, BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ]);
	GetPlayerFacingAngle(playerid, BankerData[id][bankerA]);
	SetPlayerPos(playerid, BankerData[id][bankerX] + (1.0 * floatsin(-BankerData[id][bankerA], degrees)), BankerData[id][bankerY] + (1.0 * floatcos(-BankerData[id][bankerA], degrees)), BankerData[id][bankerZ]);
	BankerData[id][bankerActorID] = CreateActor(skin, BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], BankerData[id][bankerA]);
	if(IsValidActor(BankerData[id][bankerActorID])) SetActorInvulnerable(BankerData[id][bankerActorID], true);
	#if defined BANKER_USE_MAPICON
	BankerData[id][bankerIconID] = CreateDynamicMapIcon(BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], 58, 0, .streamdistance = BANKER_ICON_RANGE);
	#endif
	format(label_string, sizeof(label_string), "Banker (%d)\n\n{FFFFFF}Utiliser {F1C40F}/banque!", id);
	BankerData[id][bankerLabel] = CreateDynamic3DTextLabel(label_string, 0x1ABC9CFF, BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ] + 0.25, 5.0, .testlos = 1);
	mysql_format(g_iHandle, query, sizeof(query), "INSERT INTO bankers SET ID=%d, Skin=%d, PosX='%f', PosY='%f', PosZ='%f', PosA='%f'", id, skin, BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], BankerData[id][bankerA]);
	mysql_tquery(g_iHandle, query);
	Iter_Add(Bankers, id);
	return 1;
}
CMD:setbankerpos(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id;
	if(sscanf(params, "i", id)) return SendSyntaxMessage(playerid,"/setbankerpos [banker id]");
	if(!Iter_Contains(Bankers, id)) return SendErrorMessage(playerid,"Invalid banker ID.");
	GetPlayerPos(playerid, BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ]);
	GetPlayerFacingAngle(playerid, BankerData[id][bankerA]);
	DestroyActor(BankerData[id][bankerActorID]);
	BankerData[id][bankerActorID] = CreateActor(BankerData[id][Skin], BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], BankerData[id][bankerA]);
	if(IsValidActor(BankerData[id][bankerActorID])) SetActorInvulnerable(BankerData[id][bankerActorID], true);
	#if defined BANKER_USE_MAPICON
	Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, BankerData[id][bankerIconID], E_STREAMER_X, BankerData[id][bankerX]);
	Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, BankerData[id][bankerIconID], E_STREAMER_Y, BankerData[id][bankerY]);
	Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, BankerData[id][bankerIconID], E_STREAMER_Z, BankerData[id][bankerZ]);
	#endif
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BankerData[id][bankerLabel], E_STREAMER_X, BankerData[id][bankerX]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BankerData[id][bankerLabel], E_STREAMER_Y, BankerData[id][bankerY]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BankerData[id][bankerLabel], E_STREAMER_Z, BankerData[id][bankerZ]);	
	SetPlayerPos(playerid, BankerData[id][bankerX] + (1.0 * floatsin(-BankerData[id][bankerA], degrees)), BankerData[id][bankerY] + (1.0 * floatcos(-BankerData[id][bankerA], degrees)), BankerData[id][bankerZ]);
	new query[144];
	mysql_format(g_iHandle, query, sizeof(query), "UPDATE bankers SET PosX='%f', PosY='%f', PosZ='%f', PosA='%f' WHERE ID=%d", BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], BankerData[id][bankerA], id);
	mysql_tquery(g_iHandle, query);
	return 1;
}
CMD:setbankerskin(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id, skin;
	if(sscanf(params, "ii", id, skin)) return SendSyntaxMessage(playerid,"/setbankerskin [banker id] [skin id]");
	if(!Iter_Contains(Bankers, id)) return SendErrorMessage(playerid,"Invalid banker ID.");
	if(!(0 <= skin <= 311)) return SendErrorMessage(playerid,"Invalid skin ID.");
	BankerData[id][Skin] = skin;
	if(IsValidActor(BankerData[id][bankerActorID])) DestroyActor(BankerData[id][bankerActorID]);
	BankerData[id][bankerActorID] = CreateActor(BankerData[id][Skin], BankerData[id][bankerX], BankerData[id][bankerY], BankerData[id][bankerZ], BankerData[id][bankerA]);
	if(IsValidActor(BankerData[id][bankerActorID])) SetActorInvulnerable(BankerData[id][bankerActorID], true);
	new query[48];
	mysql_format(g_iHandle, query, sizeof(query), "UPDATE bankers SET Skin=%d WHERE ID=%d", BankerData[id][Skin], id);
	mysql_tquery(g_iHandle, query);
	return 1;
}
CMD:supbanker(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new id;
	if(sscanf(params, "i", id)) return SendSyntaxMessage(playerid,"/removebanker [banker id]");
	if(!Iter_Contains(Bankers, id)) return SendErrorMessage(playerid,"Invalid banker ID.");
	if(IsValidActor(BankerData[id][bankerActorID])) DestroyActor(BankerData[id][bankerActorID]);
	BankerData[id][bankerActorID] = -1;
	#if defined BANKER_USE_MAPICON
	if(IsValidDynamicMapIcon(BankerData[id][bankerIconID])) DestroyDynamicMapIcon(BankerData[id][bankerIconID]);
    BankerData[id][bankerIconID] = -1;
    #endif
    if(IsValidDynamic3DTextLabel(BankerData[id][bankerLabel])) DestroyDynamic3DTextLabel(BankerData[id][bankerLabel]);
    BankerData[id][bankerLabel] = Text3D: -1;
	Iter_Remove(Bankers, id);
	new query[48];
	mysql_format(g_iHandle, query, sizeof(query), "DELETE FROM bankers WHERE ID=%d", id);
	mysql_tquery(g_iHandle, query);
	return 1;
}
CMD:creergarage(playerid,params[])
{
    if (PlayerData[playerid][pAdmin] < 3) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    if(GetPlayerVehicleID(playerid) != 0)  return SendErrorMessage(playerid,"Tu doit être a pied pour cela.");
    new buyprice, size, ID;
    if (sscanf(params, "iI(0)", buyprice, size)) {
    	SendSyntaxMessage(playerid,"\"/creategarage <price> <size(défaut 0)>\"");
    	return SendSyntaxMessage(playerid,"Size: 0 - Petit Garage , 1 - Medium Garage, 2 - Grand Garage.");
    }
    if ((size < 0) || (size > 2)) return SendServerMessage(playerid,"Type de garage entre 0 et 2");
    for (ID = 1; ID < MAX_GARAGES; ID++)
        if (!IsValidDynamicPickup(GarageInfo[ID][PickupID])) break;
    if (ID == MAX_GARAGES) return SendErrorMessage(playerid,"Maximum garages!");
	if (!IsValidDynamicPickup(GarageInfo[ID][PickupID]))
	{
		new Float:x, Float:y, Float:z, Msg[128];
		GetPlayerPos(playerid, x, y, z);
		GarageInfo[ID][Owned] = 0;
		GarageInfo[ID][Owner][0] = EOS;
		GarageInfo[ID][eX] = x;
		GarageInfo[ID][eY] = y;
		GarageInfo[ID][eZ] = z;
		GarageInfo[ID][Price] = buyprice;
		GarageInfo[ID][Size] = size;
		GarageInfo[ID][Lock] = 0;
		Garage_Update(ID);
		mysql_format(g_iHandle, Msg, sizeof(Msg), "INSERT INTO `garages` (ID,eX,eY,eZ,Owner,Price,Size) VALUES (%d,%f,%f,%f,'%e',%d,%d)",ID, x,y,z,GarageInfo[ID][Owner],buyprice,size);
		mysql_tquery(g_iHandle, Msg);
		SendServerMessage(playerid,"Garage créer ID: {FFFF00}%i", ID);
	}
	else SendErrorMessage(playerid,"Maximum garages!");
    return 1;
}
CMD:supgarage(playerid, params[])
{
	new Msg[128], Name[24];
    if (PlayerData[playerid][pAdmin] < 3) return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (GetPlayerVehicleSeat(playerid) == -1)
	{
		for (new GarageID = 1; GarageID < MAX_GARAGES; GarageID++)
		{
			if (IsValidDynamicPickup(GarageInfo[GarageID][PickupID]))
			{
				if (IsPlayerInRangeOfPoint(playerid, 2.5, GarageInfo[GarageID][eX], GarageInfo[GarageID][eY], GarageInfo[GarageID][eZ]))
				{
					if (GarageInfo[GarageID][Owned] == 1)
					{
						for (new pid = 0 , j = GetPlayerPoolSize(); pid <= j; pid++)
						{
						    if (IsPlayerConnected(pid))
						    {
						        GetPlayerName(pid, Name, sizeof(Name));
								if (strcmp(GarageInfo[GarageID][Owner], Name, false) == 0) SendServerMessage(pid,"Votre garage a été supprimer");
						    }
						}
					}
					GarageInfo[GarageID][Owner][0] = EOS;
					GarageInfo[GarageID][eX] =
					GarageInfo[GarageID][eY] =
					GarageInfo[GarageID][eZ] = 0.0;
					GarageInfo[GarageID][Price] =
					GarageInfo[GarageID][Size] =
					GarageInfo[GarageID][Owned] = 0;
					GarageInfo[GarageID][Lock] = 0;
					DestroyDynamicPickup(GarageInfo[GarageID][PickupID]);
					DestroyDynamic3DTextLabel(GarageInfo[GarageID][Label]);
					GarageInfo[GarageID][PickupID] =
					mysql_format(g_iHandle, Msg, sizeof(Msg), "DELETE FROM `garages` WHERE `ID` = %i LIMIT 1" , GarageID);
					mysql_tquery(g_iHandle, Msg);
					SendServerMessage(playerid,"Vous avez supprimer le garage ID: {FFFF00}%i", GarageID);
					return 1;
				}
			}
		}
		SendErrorMessage(playerid, "Aucun garage a proximité");
	}
	else SendErrorMessage(playerid, "Tu dois être a pied pour le supprimer");
	return 1;
}
//tuto confirmé
CMD:apps(playerid, params[])
{
	static userid;
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/apps [playerid/name]");
	if(PlayerData[userid][pTutorialStage] != 5) return SendErrorMessage(playerid,"Se joueur n'est pas dans le tutoriel");
	SendServerMessage(playerid,"Voici les réponses de cette personne %s",ReturnName(userid, 0));
	SendServerMessage(playerid,"Réponse 1: %s",tuto1);
	SendServerMessage(playerid,"Réponse 2: %s",tuto2);
	SendServerMessage(playerid,"Réponse 3: %s",tuto3);
	SendServerMessage(playerid,"Réponse 4: %s",tuto4);
	SendSyntaxMessage(playerid, "/apps[a/r] accepter ou refuser");
	return 1;	
}
CMD:appsa(playerid, params[])
{
	static userid;
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/appsa [playerid/name]");
	if(PlayerData[userid][pTutorialStage] != 5) return SendErrorMessage(playerid,"Se joueur n'est pas dans le tutoriel");	
	SendServerMessage(userid,"Votre demande viens d'être accepté par %s.", ReturnName(playerid));
	TogglePlayerControllable(userid, 1);
	PlayerData[userid][pTutorialStage] = 6;
	SetPlayerCheckpoint(userid, -228.8403, 1401.1831, 27.7656, 2.0);
	tuto1 = "\0";
	tuto2 = "\0";
	tuto3 = "\0";
	tuto4 = "\0";
	return 1;	
}
CMD:appsr(playerid, params[])
{
	static userid;
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/appsr [playerid/name]");
	if(PlayerData[userid][pTutorialStage] != 5) return SendErrorMessage(playerid,"Se joueur n'est pas dans le tutoriel");
	SendServerMessage(userid,"Votre demande viens d'être refuser par %s.", ReturnName(playerid));
	KickEx(userid);
	tuto1 = "\0";
	tuto2 = "\0";
	tuto3 = "\0";
	tuto4 = "\0";
	return 1;
}