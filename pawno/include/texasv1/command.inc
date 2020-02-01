CMD:sa(playerid, params[])
	return cmd_stopanim(playerid, params);
/*CMD:d(playerid, params[])
	return cmd_dept(playerid, params);*/
CMD:fequip(playerid, params[])
	return cmd_fequipement(playerid, params);
CMD:rac(playerid, params[])
	return cmd_racrocher(playerid, params);
CMD:radio(playerid, params[])
	return cmd_r(playerid, params);
CMD:ooc(playerid, params[])
	return cmd_o(playerid, params);
CMD:f(playerid, params[])
	return cmd_fac(playerid, params);
CMD:megaphone(playerid, params[])
	return cmd_m(playerid, params);
CMD:crier(playerid, params[])
	return cmd_c(playerid, params);
CMD:admin(playerid, params[])
	return cmd_a(playerid, params);
CMD:w(playerid, params[])
	return cmd_whisper(playerid, params);
CMD:casque(playerid, params[])
	return cmd_ceinture(playerid, params);
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

CMD:plaque(playerid, params[])
{
    new vehicleid,string[32],facass = PlayerData[playerid][pFaction];
    vehicleid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule.");
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (!IsACruiser(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans une véhicule de police.");
	if(vehiclecallsign[GetPlayerVehicleID(playerid)] == 1)
	{
 		Delete3DTextLabel(vehicle3Dtext[vehicleid]);
	    vehiclecallsign[vehicleid] = 0;
	    SendClientMessage(playerid, COLOR_RED, "Numéro de plaque enlevé.");
	    return 1;
	}
	if(sscanf(params, "s[32]",string)) return SendErrorMessage(playerid, "Tu doit entré un numéro.");
	if(vehiclecallsign[GetPlayerVehicleID(playerid)] == 0)
	{
		vehicle3Dtext[vehicleid] = Create3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, 0.0, 10.0, 0, 1);
		Attach3DTextLabelToVehicle(vehicle3Dtext[vehicleid], vehicleid, 0.0, -2.8, 0.0);
		vehiclecallsign[vehicleid] = 1;
	}
	return 1;
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
CMD:b(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/b [local OOC]");
	if (strlen(params) > 64)
	{
	    if(PlayerData[playerid][pAdminDuty] == 1)
	    {
	        SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{33EE33}%s{FFFFFF} [%d]: (( %.64s", ReturnName(playerid, 0), playerid, params);
	    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "...%s ))", params[64]);
	        return 1;
		}
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s [%d]: (( %.64s", ReturnName(playerid, 0), playerid, params);
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "...%s ))", params[64]);
	}
	else
	{
	    if(PlayerData[playerid][pAdminDuty] == 1)
	    {
	        SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{33EE33}%s{FFFFFF} [%d]: (( %s ))", ReturnName(playerid, 0), playerid, params);
			return 1;
		}
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s [%d]: (( %s ))", ReturnName(playerid, 0), playerid, params);
	}
	return 1;
}
CMD:me(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/me [action]");
	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %s", ReturnName(playerid, 0), params);
	}
	Log_Write("logs/me.txt", "[%s] [ME] %s : %s.", ReturnDate(), ReturnName(playerid, 0), params);
	return 1;
}
CMD:do(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/do [description]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %.64s", params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "...%s (( %s ))", params[64], ReturnName(playerid, 0));
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnName(playerid, 0));
	}
	Log_Write("logs/do.txt", "[%s] [DO] %s : %s.", ReturnDate(), ReturnName(playerid, 0), params);
	return 1;
}
CMD:ame(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ame [description]");
 	SendNearbyMessage(playerid,30.0, COLOR_PURPLE,"* %s", params);
	return 1;
}
CMD:ado(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ado [description]");
 	SendNearbyMessage(playerid,30.0, COLOR_PURPLE,"* %s", params);
	return 1;
}
CMD:c(playerid, params[])
{

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(c)rie [texte]");
	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s crie: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "...%s!", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s crie: %s!", ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:bas(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/bas [texte]");
	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[bas] %s dit à voix basse: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[bas] %s dit à voix basse: %s", ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:o(playerid, params[])
{
	new serveurinfo;
	if(info_serveursetting[serveurinfo][settingoocactive] == 1) return SendErrorMessage(playerid,"Le OOC est désactivé");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/o [global OOC]");
	if (PlayerData[playerid][pDisableOOC])
	    return SendErrorMessage(playerid, "Vous devez avoir mis le chat ooc on.");
    if (strlen(params) > 64)
	{
        foreach (new i : Player) if (!PlayerData[i][pDisableOOC] && PlayerData[i][pCreated]) {
		    SendClientMessageEx(i, 0xAAC4E5FF, "(( [OOC] %s: %.64s", ReturnName(playerid, 0), params);
		    SendClientMessageEx(i, 0xAAC4E5FF, "...%s ))", params[64]);
		}
	}
	else
	{
        foreach (new i : Player) if (!PlayerData[i][pDisableOOC] && PlayerData[i][pCreated]) {
		    SendClientMessageEx(i, 0xAAC4E5FF, "(( [OOC] %s: %s ))", ReturnName(playerid, 0), params);
		}
	}
	Log_Write("logs/ooc.txt", "[%s] [OOC] %s: %s",ReturnDate(),ReturnName(playerid, 0), params);
	return 1;
}
 
CMD:aide(playerid, params[])
{
	if (PlayerData[playerid][pFactionMod])
	    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /creerfaction, /editfaction, /supfaction.");
    if (PlayerData[playerid][pTester] > 0) {SendClientMessage(playerid, COLOR_CLIENT, "SUPPORTER:{FFFFFF} /a, /tduty, /ar, /dr, /jail, /rapports, /spec");}
	if (PlayerData[playerid][pAdmin] > 0) {SendClientMessage(playerid, COLOR_CLIENT, "STAFF:{FFFFFF} /(a)dmin, /ahelp.");}
	Dialog_Show(playerid,aidemenu,DIALOG_STYLE_LIST,"Menu d'aide","Aide Chat\nAide Maison\nAide Magasin\nAide Vehicule\nAide Faction\nAide Divers\nAide General","Quitter","");
	return 1;
}
CMD:ahelp(playerid, params[])
{
	if (!PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Tu n'est pas dans les admins.");
	if (PlayerData[playerid][pAdmin] >= 1) {
	    SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /a, /rapports, /spec, /jail, /dejail, /gotocar.");
	    SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /warn, /goto, /envoyera, /clearchat, /aduty, /ban, /aremovecall.");
	    SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /masked, /amenerveh, /acceptname, /declinename, /a.");
		SendClientMessage(playerid, COLOR_GREY, "[LEVEL 1]:{FFFFFF} /x /y /z /renvoyer, /caissedetat, /stockdetat, /gotoactor.");
 	}
	if (PlayerData[playerid][pAdmin] >= 2) {
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 2]:{FFFFFF} /entercar, /flipcar, /proche, /healall, /tracenumber, /blacklist.");
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 2]:{FFFFFF} /afire, /akillfire, /adestroybox, /addseat, /unban.");
	}
	if (PlayerData[playerid][pAdmin] >= 3) {
        SendClientMessage(playerid, COLOR_RED, "[LEVEL 3]:{FFFFFF} /asellmaison, /asellbiz, /jetpack, /setweather, /setfuel, /setcarhp, /spawnitem.");
        SendClientMessage(playerid, COLOR_RED, "[LEVEL 3]:{FFFFFF} /setquantity, /supitem, /setinventory, /arepair, /givewep, /baninfo, /setitem.");
	}
	if (PlayerData[playerid][pAdmin] >= 4) {
        SendClientMessage(playerid, COLOR_BLUE, "[LEVEL 4]:{FFFFFF} /dynamichelp, /restart, /mcreate");
		SendClientMessage(playerid, COLOR_BLUE, "[LEVEL 4]:{FFFFFF} /salaireanpe, /supaccount, /supperso, /panel, /serveur.");
	}
	return 1;
}
CMD:dynamichelp(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return 1;
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creermaison, /creerbiz, /creerentrer, /creerpump, /creercrate, /creerfaction, /creerbot,");
    SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creergate, /creercar, /creeratm, /creervendor, /creergarbage,/creerdetector, /creerrack, /creercaisse.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creerbillboard, /creerspeed, /creergraffiti, /editrack, /editbillboard, /editentrer, /editfaction, /editgate, /editcaisse.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /editpump, /supentrer, /supump, /supcrate, /supfaction, /supgate, /supcaisse, /supgraffiti.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /supatm, /supgarbage, /suprack,  /supspeed, /supbiz, /suphouse, /supcrate.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /suplant, /supdetector, /supbillboard, /bizstate, /setpump.");
	return 1;
}
CMD:caissedetat(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
    	return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new string[4096], moneyentrepriseid;
	format(string, sizeof(string), "{FFFFFF}Police : %s{2EFE2E}${FFFFFF}\nFBI : %s{2EFE2E}${FFFFFF}\nSWAT : %s{2EFE2E}${FFFFFF}\nMédecin : %s{2EFE2E}${FFFFFF}\nMairie LS : %s{2EFE2E}${FFFFFF}\nFermier : %s{2EFE2E}${FFFFFF}\nBanque : %s{2EFE2E}${FFFFFF}",FormatNumber(argent_entreprise[moneyentrepriseid][argentpolice]),FormatNumber(argent_entreprise[moneyentrepriseid][argentfbi]),FormatNumber(argent_entreprise[moneyentrepriseid][argentswat]),FormatNumber(argent_entreprise[moneyentrepriseid][argentmedecin]),FormatNumber(argent_entreprise[moneyentrepriseid][argentmairie]),FormatNumber(argent_entreprise[moneyentrepriseid][argentfermier]),FormatNumber(argent_entreprise[moneyentrepriseid][argentbanque]));
	format(string, sizeof(string),"%s",string);
	Dialog_Show(playerid, Caissedetat, DIALOG_STYLE_MSGBOX, "Les caisses des factions", string, " X ", "");
	return 1;
}
CMD:stockdetat(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
    	return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new string[4096],string1[512], string2[512], string3[512], string4[512], string5[512], stockjobinfoid;
	format(string1, sizeof(string1), "{FFFFFF}Bois : %s\nViande : %s\nMeuble : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfobois]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoviande]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfomeuble]));
	format(string2, sizeof(string2), "Central 1 : %s\nCentral 2 : %s\nCentral 3 : %s\nCentral 4 : %s\nCentral 5 : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral2]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral3]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral4]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfocentral5]));
	format(string3, sizeof(string3),"Electronique : %s\nPétrol: %s\nL'essence Générateur : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfopetrol]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator]));
	format(string4, sizeof(string4),"Bois meuble : %s\nMagasin stock: %s\nCaisse des dock : %s\n",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockdock]));
    format(string5, sizeof(string5),"Caisse manutentionnaire : %s\nCaisse cariste: %s\nPierre miner : %s\nStock d'arme : %s",FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockminer]),FormatNumber(info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes]));
	format(string, sizeof(string),"%s%s%s%s%s",string1,string2,string3,string4,string5);
	Dialog_Show(playerid, Caissedetat, DIALOG_STYLE_MSGBOX, "Les stock de l'état", string, " X ", "");
	return 1;
}
CMD:changermdp(playerid, params[])
{
	Dialog_Show(playerid, ChangePassword, DIALOG_STYLE_PASSWORD, "Changer votre mot de passe", "Entrer votre mot de passe actuel:", "Valider", "Annuler");
	return 1;
}
CMD:dernierefois(playerid, params[])
{
	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/dernierefois [nom de l'utilisateur]");
	static query[128];
	format(query, sizeof(query), "SELECT `LoginDate` FROM `accounts` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnLoginDate", "ds", playerid, params);
 	return 1;
}
CMD:demarrer(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new id = Car_GetID(vehicleid);
    if (GetVehicleModel(vehicleid) == 530)
 	{
     	switch (GetEngineStatus(vehicleid))
  		{
   			case false:
   			{
    			SetEngineStatus(vehicleid, true);
    			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s démarre le moteur.", ReturnName(playerid, 0));
   			}
   			case true:
   			{
    			SetEngineStatus(vehicleid, false);
    			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s éteint le moteur.", ReturnName(playerid, 0));
   			}
  		}
		return 1;
 	}
    if(id == -1)
	    return SendErrorMessage(playerid, "Véhicule invalide.");

	if (!IsEngineVehicle(vehicleid) && !IsABike(vehicleid))
		return SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Vous devez êtres le conducteur.");

	if (CarData[id][carfuel] < 1)
	    return SendErrorMessage(playerid, "Panne d'essence.");

	if (ReturnVehicleHealth(vehicleid) <= 300)
	    return SendErrorMessage(playerid, "Véhicule cramer.");

    if (CarData[id][carLoca] > 0 && CarData[id][carID] != PlayerData[playerid][pLocaID])
		return SendErrorMessage(playerid, "Vous n'avez pas louer se véhicule.");
	
    if (CarData[id][carSabot] != 0 && GetEngineStatus(vehicleid) == 0)
		return SendErrorMessage(playerid, "Ce véhicule a un sabot, Utilisez /payersabot pour le retirer ($%d)",CarData[id][carSabPri]);
	if (Car_IsOwner(playerid, id) || (PlayerData[playerid][pFaction] != -1 && CarData[id][carFaction] == PlayerData[playerid][pFaction]) || CarData[id][carDouble] == PlayerData[playerid][pID] || CarData[id][carLocaID] == PlayerData[playerid][pID])
	{
		switch (GetEngineStatus(vehicleid) && !IsAVelo(vehicleid))
		{
			case true:
			{
				SetEngineStatus(vehicleid, false);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s éteint le moteur.", ReturnName(playerid, 0));
			}
			case false:
			{
				SetTimerEx("starter", 2500, false, "d", playerid);
			}
		}
	}
	return 1;
}

CMD:phare(playerid, params[])
{
    static engine,lights,alarm,doors,bonnet,boot,objective;
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsEngineVehicle(vehicleid))
		return SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Vous devez êtres le conducteur.");

	switch (GetLightStatus(vehicleid))
	{
	    case false:
	    {
	        SetLightStatus(vehicleid, true);
	        ShowPlayerFooter(playerid, "Vous avez ~g~allumer~w~ les phares!");
	        if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
         	{
         		new trailer = GetVehicleTrailer(GetPlayerVehicleID(playerid));
         		GetVehicleParamsEx(trailer,engine,lights,alarm,doors,bonnet,boot,objective);
         		SetVehicleParamsEx(trailer,engine,VEHICLE_PARAMS_ON,alarm,doors,bonnet,boot,objective);
         	}
		}
		case true:
		{
		    SetLightStatus(vehicleid, false);
		    ShowPlayerFooter(playerid, "Vous avez ~r~eteint~w~ les phares!");
		    if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
      		{
      			new trailer = GetVehicleTrailer(GetPlayerVehicleID(playerid));
      			GetVehicleParamsEx(trailer,engine,lights,alarm,doors,bonnet,boot,objective);
      			SetVehicleParamsEx(trailer,engine,VEHICLE_PARAMS_OFF,alarm,doors,bonnet,boot,objective);
      		}
		}
	}
	return 1;
}

CMD:capot(playerid, params[])
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
	    if (!IsDoorVehicle(i))
	        return SendErrorMessage(playerid, "Ce véhicule n'a pas de capot.");

	    if (!GetHoodStatus(i))
		{
	        SetHoodStatus(i, true);
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a ouvert le capot du véhicule.", ReturnName(playerid, 0));
	        ShowPlayerFooter(playerid, "Vous avez ~gouvert~w~ le capot!");
		}
		else
		{
			SetHoodStatus(i, false);
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a fermer le capot du véhicule.", ReturnName(playerid, 0));
	        ShowPlayerFooter(playerid, "Vous avez ~g~fermer~w~ le capot!");
		}
	    return 1;
	}
	SendErrorMessage(playerid, "Vous n'est pas proche d'un véhicule.");
	return 1;
}
CMD:vitre(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsWindowedVehicle(vehicleid))
		return SendErrorMessage(playerid, "Ce vehicule n'a pas de fenêtre");
	switch (CoreVehicles[vehicleid][vehWindowsDown])
	{
	    case false:
	    {
			if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
			{
				CoreVehicles[vehicleid][vehWindowsDown] = true;
				if(GetPlayerVehicleSeat(playerid) == 0) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_OFF,1,1,1);
				if(GetPlayerVehicleSeat(playerid) == 1) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),1,VEHICLE_PARAMS_OFF,1,1);
				if(GetPlayerVehicleSeat(playerid) == 2) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),1,1,VEHICLE_PARAMS_OFF,1);
				if(GetPlayerVehicleSeat(playerid) == 3) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),1,1,1,VEHICLE_PARAMS_OFF);
				//SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s appuie sur le bouton pour baisser la vitre du véhicule.", ReturnName(playerid, 0));
			}
		}
		case true:
		{
			if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
			{
				CoreVehicles[vehicleid][vehWindowsDown] = false;
				if(GetPlayerVehicleSeat(playerid) == 0) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),VEHICLE_PARAMS_ON,1,1,1);
				if(GetPlayerVehicleSeat(playerid) == 1) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),1,VEHICLE_PARAMS_ON,1,1);
				if(GetPlayerVehicleSeat(playerid) == 2) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),1,1,VEHICLE_PARAMS_ON,1);
				if(GetPlayerVehicleSeat(playerid) == 3) SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid),1,1,1,VEHICLE_PARAMS_ON);
				//SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s appuie sur le bouton pour remonter la vitre du véhicule.", ReturnName(playerid, 0));
			}
		}
	}
	return 1;
}
CMD:a(playerid, params[])
{
	if (!PlayerData[playerid][pTester] && !PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Vous n'êtes pas un admin ou helpeur");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/a [admin text]");

	if (strlen(params) > 64) {
	    if (PlayerData[playerid][pAdmin])
	    	SendTesterMessage(COLOR_ADMINCHAT, "** Staff %s: %.64s", ReturnName(playerid, 0), params);
		else
			SendTesterMessage(COLOR_ADMINCHAT, "** Helpeur %s: %.64s", ReturnName(playerid, 0), params);
		SendTesterMessage(COLOR_ADMINCHAT, "...%s **", params[64]);
	}
	else {
	    SendAdminAlert(COLOR_ADMINCHAT, "**Staff %s: %s **",ReturnName(playerid, 0), params);
	}
	SendDC(channelstaff,"[Staff] %s: %s",ReturnName(playerid, 0), params);
	Log_Write("logs/adminchat_log.txt", "[%s] %s : %s", ReturnDate(),ReturnName(playerid),params);
	return 1;
}
CMD:n(playerid, params[])
{
	new serveurinfo;
	if(info_serveursetting[serveurinfo][settingnouveau] == 1) return SendErrorMessage(playerid,"Le chat nouveau est désactivé");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/n [nouveau] text]");
	if (strlen(params) > 64) {
	    if (PlayerData[playerid][pAdmin] || PlayerData[playerid][pTester] || PlayerData[playerid][pPlayingHours] <= 5)
	    	SendHelperMessage(COLOR_LIGHTRED, "** [Aide] %s: %.64s", ReturnName(playerid, 0), params);
		SendTesterMessage(COLOR_LIGHTRED, "...%s **", params[64]);
	}
	else {
	    if (PlayerData[playerid][pAdmin] || PlayerData[playerid][pTester] || PlayerData[playerid][pPlayingHours] <= 5)
	    	SendHelperMessage(COLOR_LIGHTRED, "** [Aide]  %s: %s", ReturnName(playerid, 0), params);
	}
	SendDC(channelaide, "[Canal Aide]  %s: %s", ReturnName(playerid, 0), params);
	Log_Write("logs/nouveau_log.txt", "[%s] %s : %.100s", ReturnDate(),ReturnName(playerid),params);
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
		SendClientMessageToAllEx(COLOR_GREEN, "** %s est en service admin (/rapport pour assistance). **", ReturnName(playerid, 0));
	}
	else
	{
	    SetPlayerColor(playerid, DEFAULT_COLOR);
		PlayerData[playerid][pAdminDuty] = 0;
		SendServerMessage(playerid, "Vous n'est plus en service admin.");
	}
	return 1;
}
CMD:rapport(playerid, params[])
{
	new reportid = -1;
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/rapport [raison]");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} S'il vous plaît utilisez cette commande uniquement si vous avez besoin d'aide.");
	    return 1;
	}
	if (Report_GetCount(playerid) > 1)
	    return SendErrorMessage(playerid, "Tu a déja 1 rapport active attent un peut!!!!!!");
	if (PlayerData[playerid][pReportTime] >= gettime())
	    return SendErrorMessage(playerid, "Vous devez attendre %d secondes avant le prochain rapport.", PlayerData[playerid][pReportTime] - gettime());
	if ((reportid = Report_Add(playerid, params)) != -1)
	{
		ShowPlayerFooter(playerid, "Votre ~g~rapport~w~ est envoyer");
		foreach (new i : Player)
		{
			if (PlayerData[i][pAdmin] > 0 && PlayerData[i][pAdminDuty]) {
				SendClientMessageEx(i, COLOR_PINK, "[RAPPORT %d]: %s (ID: %d) reporte: %s", reportid, ReturnName(playerid, 0), playerid, params);
			}
			if(PlayerData[i][pTester] > 0){
				SendClientMessageEx(i, COLOR_PINK, "[RAPPORT %d]: %s (ID: %d) reporte: %s", reportid, ReturnName(playerid, 0), playerid, params);
			}
			if(PlayerData[i][pDiscordChat] == 1){
			SendDC(channelaide, "[RAPPORT %d]: %s (ID: %d) reporte: %s",reportid, ReturnName(playerid, 0), playerid, params);
			}
		}
		PlayerData[playerid][pReportTime] = gettime() + 60;
		SendServerMessage(playerid, "Rapport envoyé aux admins connectés et sur discord si vous avez activé l'option.");
	}
	else {SendErrorMessage(playerid, "La liste de rapport est pleine veuiller attendre.");}
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
	new reportid = strval(params),string[64];
	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SendErrorMessage(playerid, "RID invalide, choisir un RID allant de 0 à %d.", MAX_REPORTS);
	format(string, sizeof(string), "Vous avez ~g~accepter~w~ le rapport (ID: %d.)", reportid);
	ShowPlayerFooter(playerid, string);
	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) accepte votre rapport.", ReturnName(playerid, 0), playerid);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s à accepté le rapport de %s.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	if(PlayerData[playerid][pDiscordChat] == 1){
	SendDC(channelaide,"[ADMIN]: %s à accepté le rapport de %s.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));}
	Report_Remove(reportid);
	return 1;
}
CMD:dr(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/dr [rapport id] (/rapports pour la liste)");
	new reportid = strval(params),string[64];
	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SendErrorMessage(playerid, "RID invalide, choisir un RID allant de 0 à %d.", MAX_REPORTS);
	format(string, sizeof(string), "Vous avez ~r~decliner~w~ rapport (ID: %d.)", reportid);
	ShowPlayerFooter(playerid, string);
	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) a décliné votre rapport.", ReturnName(playerid, 0), playerid);
    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a décliné le rapport de %s'.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	if(PlayerData[playerid][pDiscordChat] == 1){
	SendDC(channelaide,"[ADMIN]: %s a décliné le rapport de %s'.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));}
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
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));
	TogglePlayerSpectating(playerid, 1);
	if (IsPlayerInAnyVehicle(userid))
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userid));
	else
		PlayerSpectatePlayer(playerid, userid);
	SendServerMessage(playerid, "Vous regardez %s (ID: %d).", ReturnName(userid, 0), userid);
	PlayerData[playerid][pSpectator] = userid;
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
	Log_Write("logs/jail_log.txt", "[%s] %s a mis en prison admin %s pour %d minutes, raison: %s.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), minutes, reason);
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
	Log_Write("logs/jail_log.txt", "[%s] %s a libéré %s .", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0));
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
	Log_Write("logs/ban_log.txt", "[%s] %s a été banni par %s raison: %s.", ReturnDate(), ReturnName(userid, 0), ReturnName(playerid, 0), reason);
	Blacklist_Add(PlayerData[userid][pIP], PlayerData[userid][pUsername], PlayerData[playerid][pUsername], reason);
	KickEx(userid);
	return 1;
}
CMD:utilisateur(playerid, params[])
{
	if (isnull(params) || strlen(params) > 24)
		return SendSyntaxMessage(playerid, "/utilisateur [character name]");
	static query[128];
	format(query, sizeof(query), "SELECT `Username` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnResolveUsername", "ds", playerid, params);
	return 1;
}
CMD:stats(playerid, params[])
{
	ShowStatsForPlayer(playerid, playerid);
	return 1;
}
CMD:acc(playerid, params[])
{
	new string[96];
	format(string, sizeof(string), "Lunette: %s\nChapeau: %s\nBandana: %s", (PlayerData[playerid][pGlasses]) ? ("Oui") : ("Non"), (PlayerData[playerid][pHat]) ? ("Oui") : ("Non"), (PlayerData[playerid][pBandana]) ? ("Oui") : ("Non"));
	Dialog_Show(playerid, Accessory, DIALOG_STYLE_LIST, "Accessoires", string, "Valider", "Annuler");
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
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} prison, house, business, entrance, job, gate, interior, billboard");
		return 1;
	}
    if (id == INVALID_PLAYER_ID)
	{
	    if (sscanf(params, "s[24]S()[64]", type, string))
		{
		    SendSyntaxMessage(playerid, "/goto [player or name]");
			SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} car, prison, house, business, entrance, job, gate, interior, billboard");
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
		else if (!strcmp(type, "business", true))
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
		else if (!strcmp(type, "entrance", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [entrance] [entrance ID]");
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
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} prison");
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

CMD:inventory(playerid, params[])
{
	if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut le faire maintenant.");
	if (PlayerData[playerid][pJailTime] > 0)
		return SendErrorMessage(playerid, "Taulard.");
	OpenInventory(playerid);
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
	    Log_Write("logs/ban_log.txt", "[%s] %s a débanni \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
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
	 	SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} ban, banip, unbanip");
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
	    Log_Write("logs/ban_log.txt", "[%s] %s a banni \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
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
	    Log_Write("logs/ban_log.txt", "[%s] %s a banni IP \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
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
	if (weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
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
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supmaison [id]");
	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID invalide.");
	House_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes la maison (ID: %d.)", id);
	return 1;
}
CMD:bizon(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	static bizid = -1;
	if ((bizid = Business_Nearest(playerid)) != -1)
	{
		BusinessData[bizid][bizchancevole] = 0;
		Business_Save(bizid);
		if(FactionData[factionid][factionacces][1] == 1)
		{ SendServerMessage(playerid, "%s a réautorisé le biz %s a avoir des clients.",ReturnName(playerid),BusinessData[bizid][bizName]);}
	}
	return 1;
}
CMD:acheter(playerid, params[])
{
	static id = -1;
	if ((id = House_Nearest(playerid)) != -1)
	{
		if (House_GetCount(playerid) >= MAX_OWNABLE_SOMETHING)
			return SendErrorMessage(playerid, "Vous pouvez avoir que %d maison en même temps.", MAX_OWNABLE_SOMETHING);
		if (HouseData[id][houseOwner] != 0)
		    return SendErrorMessage(playerid, "Cette maison est déjas vendu.");
		if (HouseData[id][housePrice] > GetMoney(playerid))
		    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent.");
		new id1 = Inventory_Add(playerid,"Clef de maison",11746);
	    if (id1 == -1)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	    HouseData[id][houseOwner] = GetPlayerSQLID(playerid);
		House_Refresh(id);
		House_Save(id);
	    GiveMoney(playerid, -HouseData[id][housePrice]);
	    new moneyentrepriseid;
		argent_entreprise[moneyentrepriseid][argentmairie] += HouseData[id][housePrice];
		moneyentreprisesave(moneyentrepriseid);
	    SendServerMessage(playerid, "Vous avez acheté \"%s\" pour %s!", HouseData[id][houseAddress], FormatNumber(HouseData[id][housePrice]));
		ShowPlayerFooter(playerid, "Vous avez ~g~acheter~w~ une maison!");
	    Log_Write("logs/house_log.txt", "[%s] %s a acheté la maison ID: %d pour %s.", ReturnDate(), ReturnName(playerid), id, FormatNumber(HouseData[id][housePrice]));
	}
	else if ((id = Business_Nearest(playerid)) != -1)
	{
	    if (Business_GetCount(playerid) >= MAX_OWNABLE_SOMETHING)
			return SendErrorMessage(playerid, "Vous pouver avoir max %d biz en même temps.", MAX_OWNABLE_SOMETHING);
		if (BusinessData[id][bizOwner] != 0)
		    return SendErrorMessage(playerid, "Ce biz est déja prit pour le moment.");
		if (BusinessData[id][bizPrice] > GetMoney(playerid))
		    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent.");
		new id1 = Inventory_Add(playerid,"Clef de magasin",11746);
	    if (id1 == -1)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	    BusinessData[id][bizOwner] = GetPlayerSQLID(playerid);
		Business_Refresh(id);
		Business_Save(id);
	    GiveMoney(playerid, -BusinessData[id][bizPrice]);
	    new moneyentrepriseid;
		argent_entreprise[moneyentrepriseid][argentmairie] += BusinessData[id][bizPrice];
		moneyentreprisesave(moneyentrepriseid);
	    SendServerMessage(playerid, "Vous avez acheter \"%s\" pour %s$!", BusinessData[id][bizName], FormatNumber(BusinessData[id][bizPrice]));
		ShowPlayerFooter(playerid, "Vous avez ~g~acheter~w~ un magasin!");
	    Log_Write("logs/biz_log.txt", "[%s] %s a acheté un magasin ID: %d pour %s.", ReturnDate(), ReturnName(playerid), id, FormatNumber(BusinessData[id][bizPrice]));
	}
	else if ((id = Business_Inside(playerid)) != -1)
	{
		if (BusinessData[id][bizLocked] != 0 || !BusinessData[id][bizOwner])
		    return SendErrorMessage(playerid, "Ce magasin est fermé!");
		if (BusinessData[id][bizType] == 5) {
			if(!Inventory_HasItem(playerid,"permis de conduire") && PlayerData[playerid][pPlayingHours] < 5)
			{SendErrorMessage(playerid,"Il vous faut un permis de conduire pour acheter un vehicule. et 5 heures de jeux");}
			else {
			Business_CarMenu(playerid, id);
			}
		} else {
			Business_PurchaseMenu(playerid, id);
		}
	}
	return 1;
}
CMD:abandonner(playerid, params[])
{
	static id = -1;
    if (!IsPlayerInAnyVehicle(playerid) && (id = House_Nearest(playerid)) != -1 && House_IsOwner(playerid, id))
	{
	    if (isnull(params) || (!isnull(params) && strcmp(params, "confirmer", true) != 0))
	    {
	        SendSyntaxMessage(playerid, "/abandonner [confirmer]");
	        SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} Vous êtes sur le point d'abandonner votre maison sans remboursement.");
		}
		else if (!strcmp(params, "confirmer", true))
		{
			if (!Inventory_HasItem(playerid, "Clef de maison"))
				return SendErrorMessage(playerid, "Vous n'avez pas la clef de maison pour l'abandoner.");
			Inventory_Remove(playerid, "Clef de maison",1);
			new sell,moneyentrepriseid;
			HouseData[id][houseOwner] = 0;
			sell = HouseData[id][housePrice] / 10;
			GiveMoney(playerid,sell);		
			argent_entreprise[moneyentrepriseid][argentmairie] -=sell;
			moneyentreprisesave(moneyentrepriseid);
			House_Refresh(id);
			House_Save(id);
			SendServerMessage(playerid, "Vous avez abandoner votre maison: %s.", HouseData[id][houseAddress]);
			Log_Write("logs/house_log.txt", "[%s] %s à abandoner sa maison (ID: %d.)", ReturnDate(), ReturnName(playerid), id);
		}
	}
	else if (!IsPlayerInAnyVehicle(playerid) && (id = Business_Nearest(playerid)) != -1 && Business_IsOwner(playerid, id))
	{
	    if (isnull(params) || (!isnull(params) && strcmp(params, "confirmer", true) != 0))
	    {
	        SendSyntaxMessage(playerid, "/abandonner [confirmer]");
	        SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} Vous êtes sur le point d'abandonner votre magasin sans remboursement.");
		}
		else if (!strcmp(params, "confirmer", true))
		{
			new sell,moneyentrepriseid;
			if (!Inventory_HasItem(playerid, "Clef de magasin"))
				return SendErrorMessage(playerid, "Vous n'avez pas la clef du magasin pour l'abandonner.");
			Inventory_Remove(playerid, "Clef de magasin",1);
			BusinessData[id][bizOwner] = 0;
			sell = BusinessData[id][bizPrice] / 10;
			GiveMoney(playerid,sell);
			argent_entreprise[moneyentrepriseid][argentmairie] -= sell;
			moneyentreprisesave(moneyentrepriseid);
			Business_Refresh(id);
			Business_Save(id);
			SendServerMessage(playerid, "Vous avez abandoner votre magasin: %s.", BusinessData[id][bizName]);
			Log_Write("logs/biz_log.txt", "[%s] %s à abandoner son magasin (ID: %d.)", ReturnDate(), ReturnName(playerid), id);
		}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas proche d'un magasin ou d'une maison.");
	return 1;
}
CMD:lumiere(playerid, params[])
{
	static id = -1;
	new stockjobinfoid;
	if ((id = House_Inside(playerid)) != -1)
	{
		if (!HouseData[id][houseLights])
		{
     		if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
		    foreach (new i : Player) if (House_Inside(i) == id) {
		        PlayerTextDrawHide(i, PlayerData[i][pTextdraws][62]);
		    }
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s allume les lumières de la maison.", ReturnName(playerid, 0));
		    HouseData[id][houseLights] = true;
		    //generateur
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 5;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 5;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 5;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 5;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 5;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
			stockjobinfosave(stockjobinfoid);
		}
		else
		{
		    foreach (new i : Player) if (House_Inside(i) == id) {
		        PlayerTextDrawShow(i, PlayerData[i][pTextdraws][62]);
		    }
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s éteint les lumières de la maison.", ReturnName(playerid, 0));
		    HouseData[id][houseLights] = false;
		}
	}
	else {SendErrorMessage(playerid, "Tu doit être dans une maison.");}
	return 1;
}
CMD:delouermaison(playerid, params[])
{
	new id = -1;
	id = House_Nearest(playerid);
	if(PlayerData[playerid][pLocaMaisonID] == 0) return SendServerMessage(playerid,"Vous ne louez pas de maison.");
	if (!Inventory_HasItem(playerid, "Clef de maison"))
		return SendErrorMessage(playerid, "Vous n'avez pas la clef de maison pour la délouer.");
	PlayerData[playerid][pLocaMaisonID] = HouseData[id][houseID];
	HouseData[id][houseLocNum] -= 1;
	PlayerData[playerid][pLocaMaisonID] = 0;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	ShowPlayerFooter(playerid, "~r~Vous ne louer plus de maison");
	Inventory_Remove(playerid, "Clef de maison",1);
	House_Save(id);
	return 1;
}
CMD:porte(playerid, params[])
{
	static id = -1;
	if (!IsPlayerInAnyVehicle(playerid) && (id = (House_Inside(playerid) == -1) ? (House_Nearest(playerid)) : (House_Inside(playerid))) != -1 && House_IsOwner(playerid, id))
	{
		if(Inventory_HasItem(playerid,"Clef de maison"))
		{
			if (!HouseData[id][houseLocked])
			{
				HouseData[id][houseLocked] = true;
				House_Save(id);
				ShowPlayerFooter(playerid, "Vous avez ~r~fermee~w~ votre maison!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				HouseData[id][houseLocked] = false;
				House_Save(id);
				ShowPlayerFooter(playerid, "Vous avez ~g~ouvert~w~ votre maison!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
		else SendErrorMessage(playerid,"Vous n'avez pas la clef de cette maison");
	}
	else if (!IsPlayerInAnyVehicle(playerid) && (id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1)
	{
		if(Inventory_HasItem(playerid,"Clef de magasin"))
		{
			if (Business_IsOwner(playerid, id))
			{
				if (!BusinessData[id][bizLocked])
				{
					BusinessData[id][bizLocked] = true;
					Business_Refresh(id);
					Business_Save(id);
					ShowPlayerFooter(playerid, "Vous avez ~r~fermee~w~ votre magasin!");
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				}
				else
				{
					BusinessData[id][bizLocked] = false;
					Business_Refresh(id);
					Business_Save(id);
					ShowPlayerFooter(playerid, "Vous avez ~g~ouvert~w~ votre magasin!");
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				}
			}
		}
		else SendErrorMessage(playerid,"Vous n'avez pas de clef de ce magasin");
	}
	else if ((id = Car_Nearest(playerid)) != -1)
	{
	    static engine,lights,alarm,doors,bonnet,boot,objective;
	    GetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
	    if (Car_IsOwner(playerid, id) || (PlayerData[playerid][pFaction] != -1 && CarData[id][carFaction] == PlayerData[playerid][pFaction]) || CarData[id][carDouble] == PlayerData[playerid][pID] || CarData[id][carLocaID] == PlayerData[playerid][pID])
	    {
			if (!CarData[id][carLocked])
			{
				CarData[id][carLocked] = true;
				Car_Save(id);
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					PlayerTextDrawColor(playerid,PlayerData[playerid][pTextdraws][90], -16776961);
					PlayerTextDrawShow(playerid,PlayerData[playerid][pTextdraws][90]);
				}
				ShowPlayerFooter(playerid, "Porte: ~r~fermee");
				SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, 0, 1, bonnet, boot, objective);
			}
			else
			{
				CarData[id][carLocked] = false;
				Car_Save(id);
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					PlayerTextDrawColor(playerid,PlayerData[playerid][pTextdraws][90], 0x2eff00);
					PlayerTextDrawShow(playerid,PlayerData[playerid][pTextdraws][90]);
				}
				ShowPlayerFooter(playerid, "Porte: ~g~ouvert");
				SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, 0, 0, bonnet, boot, objective);
			}
		}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas proche d'un véhicule, magasin ou d'une maison.");
	return 1;
}
CMD:vendre(playerid, params[])
{
	static targetid,type[24],string[128];
	new facass = PlayerData[playerid][pFaction];
	if (sscanf(params, "us[24]S()[128]", targetid, type, string))
	{
	    SendSyntaxMessage(playerid, "/vendre [playerid/name] [nom]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} maison, magasin, vehicule, servicemecano");
	    return 1;
	}
	if (targetid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
		SendErrorMessage(playerid, "Ce joueur est déconnecté ou pas proche de toi.");
		return 1;
	}
	if (targetid == playerid)
	{
		SendErrorMessage(playerid, "Tu ne peut vendre a toi même.");
		return 1;
	}
	if (!strcmp(type, "maison", true))
	{
		static price,houseid = -1;
		if (sscanf(string, "d",price))
			return SendSyntaxMessage(playerid, "/vendre [playerid/name] [maison]");
		if (price < 1)
		    return SendErrorMessage(playerid, "Prix minimun de 1$.");
		if ((houseid = House_Nearest(playerid)) != -1 && House_IsOwner(playerid, houseid)) {
			PlayerData[targetid][pHouseSeller] = playerid;
			PlayerData[targetid][pHouseOffered] = houseid;
			PlayerData[targetid][pHouseValue] = price;
		    SendServerMessage(playerid, "Vous avez demander a %s d'acheter votre maison (%s $).", ReturnName(targetid, 0), FormatNumber(price));
            SendServerMessage(targetid, "%s vous vend sa maison pour %s $ (écriver \"/accepter maison\" pour accepté).", ReturnName(playerid, 0), FormatNumber(price));
		}
		else SendErrorMessage(playerid, "Vous n'êtes proche de rien");
	}
	else if (!strcmp(type, "magasin", true))
	{
		static price,bizid = -1;
		if (sscanf(string, "dd", price))
			return SendSyntaxMessage(playerid, "/vendre [playerid/name] [magasin]");
		if (price < 1)
		    return SendErrorMessage(playerid, "Prix minimun de 1$.");
		if ((bizid = Business_Nearest(playerid)) != -1 && Business_IsOwner(playerid, bizid)) {
			PlayerData[targetid][pBusinessSeller] = playerid;
			PlayerData[targetid][pBusinessOffered] = bizid;
			PlayerData[targetid][pBusinessValue] = price;
		    SendServerMessage(playerid, "Vous avez demander a %s d'acheter votre biz (%s).", ReturnName(targetid, 0), FormatNumber(price));
            SendServerMessage(targetid, "%s vous vend son magasin pour %s $ (écriver \"/accepter magasin\" pour accepté).", ReturnName(playerid, 0), FormatNumber(price));
		}
		else SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	}
	else if (!strcmp(type, "vehicule", true))
	{
		static price,carid = -1;
		if (sscanf(string, "d", price))
			return SendSyntaxMessage(playerid, "/vendre [playerid/name] [prix]");
		if (price < 1)
		    return SendErrorMessage(playerid, "Prix minimun de 1$.");
		if ((carid = Car_Inside(playerid)) != -1 && Car_IsOwner(playerid, carid)) {
			PlayerData[targetid][pCarSeller] = playerid;
			PlayerData[targetid][pCarOffered] = carid;
			PlayerData[targetid][pCarValue] = price;
		    SendVehiculeMessage(playerid, "Vous avez demander a %s d'acheter votre %s (%s).", ReturnName(targetid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
            SendVehiculeMessage(targetid, "%s vous vend son véhicule %s pour %s $ (écriver \"/accepter vehicule\" pour accepté).", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
		}
		else SendErrorMessage(playerid, "Vous devez être a l'intérieur de votre véhicule.");
	}
	else if (!strcmp(type, "servicemecano", true))
	{
		static price;
		if (FactionData[facass][factionacces][9] == 0)
			return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");		
		if (sscanf(string, "d", price))
			return SendSyntaxMessage(playerid, "/vendre [playerid/name] [servicemecano] [prix]");
		if (price < 50)
		    return SendErrorMessage(playerid, "Prix minimun de 50$.");
		PlayerData[targetid][pMecanoSeller] = playerid;
		PlayerData[targetid][pMecanoValue] = price;
		SendServerMessage(playerid, "Vous avez demander a %s d'acheter un service de mécanicien pour (%s).", ReturnName(targetid, 0), FormatNumber(price));
        SendServerMessage(targetid, "%s vous vend un service de mécanicien pour %s $ (écriver \"/accepter servicemecano3\" pour accepté).", ReturnName(playerid, 0), FormatNumber(price));
	}
	return 1;
}

CMD:accepter(playerid, params[])
{
	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/accepter [name]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} maison, magasin, vehicule, food, faction, greet, fouille, servicemecano1, servicemecano2, servicemecano3, servicemecano4, mappel");
		return 1;
	}
	if (!strcmp(params, "maison", true) && PlayerData[playerid][pHouseSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pHouseSeller],
	        houseid = PlayerData[playerid][pHouseOffered],
	        price = PlayerData[playerid][pHouseValue];
		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent pour acheter cette maison.");
		if (House_Nearest(playerid) != houseid)
		    return SendErrorMessage(playerid, "Vous dever être proche de la maison pour l'acheté.");
		if (!House_IsOwner(sellerid, houseid))
		    return SendErrorMessage(playerid, "Cette offre n'est plus valide.");
		SendServerMessage(playerid, "Vous avez avec succès acheté la maison %s pour %s $.", ReturnName(sellerid, 0), FormatNumber(price));
		SendServerMessage(sellerid, "%s à acheté votre maison pour %s $.", ReturnName(playerid, 0), FormatNumber(price));
		HouseData[houseid][houseOwner] = GetPlayerSQLID(playerid);
		House_Save(houseid);
		GiveMoney(playerid, -price);
		GiveMoney(sellerid, price);
		Log_Write("logs/offer_log.txt", "[%s] %s (%s) has sold a house a %s (%s) pour %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));
		PlayerData[playerid][pHouseSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pHouseOffered] = -1;
		PlayerData[playerid][pHouseValue] = 0;
	}
	if (!strcmp(params, "mappel", true))
	{

		if (MecanoApel == -1) {ShowPlayerFooter(playerid, "Il n'y a aucun appel"); return 1;}
		SendEntrepriseMessage(playerid, "Vous avez l'appel de votre client %s.", ReturnName(MecanoApel, 0));
		SendEntrepriseMessage(MecanoApel, "%s a accepté votre appel", ReturnName(playerid, 0));
		static Float:X,Float:Y,Float:Z;
		GetPlayerPos(MecanoApel, X, Y, Z);
		SetPlayerCheckpoint(playerid, X, Y, Z, 5);
		MecanoApel = -1;
	}
	if (!strcmp(params, "magasin", true) && PlayerData[playerid][pBusinessSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pBusinessSeller],
	        bizid = PlayerData[playerid][pBusinessOffered],
	        price = PlayerData[playerid][pBusinessValue];
		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent pour acheter ce magasin.");
		if (Business_Nearest(playerid) != bizid)
		    return SendErrorMessage(playerid, "Vous dever être proche de magasin pour l'acheté.");
		if (!Business_IsOwner(sellerid, bizid))
		    return SendErrorMessage(playerid, "Ce magasin n'est plus valide");
		SendServerMessage(playerid, "Vous avez avec succès acheté le magasin %s pour %s $.", ReturnName(sellerid, 0), FormatNumber(price));
		SendServerMessage(sellerid, "%s à  acheté votre magasin pour %s $.", ReturnName(playerid, 0), FormatNumber(price));
		BusinessData[bizid][bizOwner] = GetPlayerSQLID(playerid);
		Business_Save(bizid);
		GiveMoney(playerid, -price);
		GiveMoney(sellerid, price);
		Log_Write("logs/offer_log.txt", "[%s] %s (%s) has sold a biz a %s (%s) pour %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));
		PlayerData[playerid][pBusinessSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pBusinessOffered] = -1;
		PlayerData[playerid][pBusinessValue] = 0;
	}
	if (!strcmp(params, "vehicule", true) && PlayerData[playerid][pCarSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pCarSeller],
	        carid = PlayerData[playerid][pCarOffered],
	        price = PlayerData[playerid][pCarValue];
		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent pour acheter cette vehicle.");
		if (Car_Nearest(playerid) != carid)
		    return SendErrorMessage(playerid, "Vous dever être proche de vehicle pour l'acheté.");
		if (!Car_IsOwner(sellerid, carid))
		    return SendErrorMessage(playerid, "ce vehicule n'est plus valide.");
		SendVehiculeMessage(playerid, "Vous avez avec succès acheté %s %s pour %s.", ReturnName(sellerid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
		SendVehiculeMessage(sellerid, "%s à acheté votre %s pour %s.", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
		CarData[carid][carOwner] = GetPlayerSQLID(playerid);
		Car_Save(carid);
		GiveMoney(playerid, -price);
		GiveMoney(sellerid, price);
		Log_Write("logs/offer_log.txt", "[%s] %s (%s) a vendu un(e) %s a %s (%s) pour %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnVehicleModelName(CarData[carid][carModel]), ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));
		PlayerData[playerid][pCarSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pCarOffered] = -1;
		PlayerData[playerid][pCarValue] = 0;
	}
	if (!strcmp(params, "food", true) && PlayerData[playerid][pFoodSeller] != INVALID_PLAYER_ID)
	{
	    new sellerid = PlayerData[playerid][pFoodSeller],type = PlayerData[playerid][pFoodType],price = PlayerData[playerid][pFoodPrice],count;
		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "Vous avez insufficient funds for the food.");
		switch (type)
		{
		    case 1:
		    {
				new id = Inventory_Add(playerid, "eau", 2958);
				if (id == -1)
				    return SendErrorMessage(playerid, "Vous n'en avez plus dans l'inventaire.");
		        SendServerMessage(playerid, "Vous avez acheté une bouteille d'eau à %s pour %d$ (ajouter dans l'inventaire).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s a acheté une bouteille d'eau %d$.", ReturnName(playerid, 0), price);
		        GiveMoney(playerid, -price);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][11] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
				{
					new aye = price / count;
					if(FactionData[ii][factionacces][11] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			case 2:
		    {
				new id = Inventory_Add(playerid, "Soda", 1543);
				if (id == -1)
				    return SendErrorMessage(playerid, "Vous n'en avez plus dans l'inventaire.");
		        SendServerMessage(playerid, "Vous avez acheté une bouteille de soda à %s pour %d$ (ajouter dans l'inventaire).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s a acheté une bouteille de soda %d$.", ReturnName(playerid, 0), price);
		        GiveMoney(playerid, -price);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][11] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
				{
					new aye = price / count;
					if(FactionData[ii][factionacces][11] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			case 3:
		    {
				new id = Inventory_Add(playerid, "Burger cuit", 2703);
				if (id == -1)
				    return SendErrorMessage(playerid, "Vous n'en avez plus dans l'inventaire.");
		        SendServerMessage(playerid, "Vous avez acheté un burger de %s pour à %d$ (ajouter dans l'inventaire).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s a acheté le burger pour %d$.", ReturnName(playerid, 0), price);
		        GiveMoney(playerid, -price);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][11] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
				{
					new aye = price / count;
					if(FactionData[ii][factionacces][11] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			case 4:
		    {
				new id = Inventory_Add(playerid, "Pizza cuite", 2702);
				if (id == -1)
				    return SendErrorMessage(playerid, "Vous n'en avez plus dans l'inventaire.");
		        SendServerMessage(playerid, "Vous avez acheté une de pizza à %s pour %d$ (ajouter dans l'inventaire).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s a acheté la pizza pour %d$.", ReturnName(playerid, 0), price);
		        GiveMoney(playerid, -price);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][11] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
				{
					new aye = price / count;
					if(FactionData[ii][factionacces][11] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			case 5:
		    {
				new id = Inventory_Add(playerid, "Poulet", 2663);
				if (id == -1)
				    return SendErrorMessage(playerid, "Vous n'en avez plus dans l'inventaire.");
		        SendServerMessage(playerid, "Vous avez acheté du poulet à %s pour %d$ (ajouter dans l'inventaire).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s a acheté le poulet pour %d$.", ReturnName(playerid, 0), price);
		        GiveMoney(playerid, -price);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][11] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
				{
					new aye = price / count;
					if(FactionData[ii][factionacces][11] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			case 6:
		    {
				new id = Inventory_Add(playerid, "Chargeur telephone", 19087);
				if (id == -1)
				    return SendErrorMessage(playerid, "Vous n'en avez plus dans l'inventaire.");
		        SendServerMessage(playerid, "Vous avez acheté un chargeur à %s pour %d$ (ajouter dans l'inventaire).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s a acheté un chargeur pour %d$.", ReturnName(playerid, 0), price);
		        GiveMoney(playerid, -price);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][11] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
				{
					new aye = price / count;
					if(FactionData[ii][factionacces][11] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
		}
		PlayerData[playerid][pFoodSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pFoodType] = 0;
		PlayerData[playerid][pFoodPrice] = 0;
	}
	if (!strcmp(params, "faction", true) && PlayerData[playerid][pFactionOffer] != INVALID_PLAYER_ID)
	{
	    new
	        targetid = PlayerData[playerid][pFactionOffer],
	        factionid = PlayerData[playerid][pFactionOffered];
		if (!FactionData[factionid][factionExists] || PlayerData[targetid][pFactionRank] < FactionData[PlayerData[targetid][pFaction]][factionRanks] - 1)
	   	 	return SendErrorMessage(playerid, "The faction offer is no longer available.");
		SetFaction(playerid, factionid);
		PlayerData[playerid][pFactionRank] = 1;
		SendServerMessage(playerid, " Vous avez accepter l'offre de %s pour rejoindre la faction \"%s\".", ReturnName(targetid, 0), Faction_GetName(targetid));
		SendServerMessage(targetid, "%s a accepté votre offre de rejoindre la faction \"%s\".", ReturnName(playerid, 0), Faction_GetName(targetid));
        PlayerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
        PlayerData[playerid][pFactionOffered] = -1;
	}
	if (!strcmp(params, "ck", true) && PlayerData[playerid][pck] != INVALID_PLAYER_ID)
	{
	    new targetid = PlayerData[playerid][pck],query[256];
	    if (!IsPlayerNearPlayer(playerid, targetid, 3.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		mysql_format(g_iHandle,query, sizeof(query), "DELETE FROM `inventory` WHERE `ID` = %d",PlayerData[playerid][pID]);
		mysql_tquery(g_iHandle, query);
		mysql_format(g_iHandle,query, sizeof(query), "DELETE FROM `characters` WHERE `ID` = %d",PlayerData[playerid][pID]);
		mysql_tquery(g_iHandle, query);
		mysql_format(g_iHandle,query, sizeof(query), "DELETE FROM `contacts` WHERE `ID` = %d",PlayerData[playerid][pID]);
		mysql_tquery(g_iHandle, query);
		mysql_format(g_iHandle,query, sizeof(query), "DELETE FROM `tickets` WHERE `ID` = %d",PlayerData[playerid][pID]);
		mysql_tquery(g_iHandle, query);
		Dialog_Show(playerid, NULLED, DIALOG_STYLE_MSGBOX, "CK de votre personnage", "Votre personnage a été tué, et vous avez accepté sa mort.\nDonc il sera supprimé et vous aller devoir en créer un nouveau.\nVous allez être déconnecté pour faire cela", "Quitter", "");
		KickEx(playerid);
	}
	if (!strcmp(params, "greet", true) && PlayerData[playerid][pShakeOffer] != INVALID_PLAYER_ID)
	{
	    new
	        targetid = PlayerData[playerid][pShakeOffer],
	        type = PlayerData[playerid][pShakeType];
        if (!IsPlayerNearPlayer(playerid, targetid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		SetPlayerToFacePlayer(playerid, targetid);
		SetPlayerToFacePlayer(targetid, playerid);
		PlayerData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
		PlayerData[playerid][pShakeType] = 0;
		switch (type)
		{
		    case 1:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 2:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 3:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 4:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 5:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 6:
			{
			    ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
			    ApplyAnimation(targetid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
			}
	    }
	    SendServerMessage(playerid, "Vous avez accepté la poigné de main de %s.", ReturnName(targetid, 0));
	    SendServerMessage(targetid, "%s a accepté votre poingé de main.", ReturnName(playerid, 0));
	}
	if (!strcmp(params, "fouille", true) && PlayerData[playerid][pFriskOffer] != INVALID_PLAYER_ID)
	{
	    new targetid = PlayerData[playerid][pFriskOffer];
	    if (!IsPlayerNearPlayer(playerid, targetid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		new
		    models[MAX_INVENTORY],
		    amount[MAX_INVENTORY];

		for (new i = 0; i < PlayerData[playerid][pCapacity]; i ++)
		{
	 		if (InventoryData[playerid][i][invExists]) {
	   			models[i] = InventoryData[playerid][i][invModel];
	   			amount[i] = InventoryData[playerid][i][invQuantity];
			}
			else {
			    models[i] = -1;
			    amount[i] = -1;
			}
		}
		PlayerData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
		ShowModelSelectionMenu(targetid, ReturnName(playerid), MODEL_SELECTION_FRISK, models, sizeof(models), 0.0, 0.0, 0.0, 1.0, -1, true, amount);
	}
	if (!strcmp(params, "servicemecano", true) && PlayerData[playerid][pMecanoSeller] != INVALID_PLAYER_ID)
	{
	    new sellerid = PlayerData[playerid][pMecanoSeller],price = PlayerData[playerid][pMecanoValue];
		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "Vous n'êtes pas proche de ce joueur.");
		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent pour acheter ce service de mécanicien.");
		SendServerMessage(playerid, "Vous avez avec succès acheté un service mécanicien a %s pour %s $.", ReturnName(sellerid, 0), FormatNumber(price));
		SendServerMessage(sellerid, "%s a avec succès acheté votre service mécanicien pour %s $.", ReturnName(playerid, 0), FormatNumber(price));
		GiveMoney(playerid, -price);
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][13] == 1)
		{
			if(FactionData[ii][factionacces][14] == 1)
			{
				FactionData[ii][factioncoffre] += price;
				Faction_Save(ii);
			}
		}
		Log_Write("logs/offer_log.txt", "[%s] %s (%s) has sold mecano service %s (%s) pour %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));
	}	
	return 1;
}
CMD:editmaison(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editmaison [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, price, address, type");
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
    if ((id = ATM_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche de ATM (ID: %d.)", id);
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
    /*if ((id = OpenWorldMaisonNearest(playerid)) != -1)
	    SendServerMessage(playerid, "Vous êtes proche du open world (ID: %d.)", id);*/
	return 1;
}
CMD:editbiz(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbiz [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, deliver, name, price, stock, type, cars, spawn, heures");
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
	else if (!strcmp(type, "deliver", true))
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
	else if (!strcmp(type, "price", true))
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
	else if (!strcmp(type, "name", true))
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
			SendSyntaxMessage(playerid,"[TYPES]: 1: Retail | 2: Weapons | 3: Clothes | 4: Fast Food | 5: Dealership | 6: Gas Station | 7: Furniture | 8 : Bar | 9 : Épicerie | 10: Quincaillerie");
			return 1;
		}
		if (typeint < 1 || typeint > 10)
			return SendErrorMessage(playerid, "Le type doit être entre 1 et 10.");
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
CMD:produits(playerid, params[])
{
	static bizid = -1;
	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid)) {
	    Business_ProductMenu(playerid, bizid);
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place.");
	return 1;
}
CMD:creerbiz(playerid, params[])
{
    static type, price,id;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "dd", type, price))
 	{
	 	SendSyntaxMessage(playerid, "/creerbiz [type] [price]");
    	SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Retail | 2: Weapons | 3: Clothes | 4: Fast Food | 5: Dealership | 6: Gas Station | 7: Furniture | 8 : Bar | 9 : Épicerie | 10 : Quincaillerie");
    	return 1;
	}
	if (type < 1 || type > 10)
	    return SendErrorMessage(playerid, "Type invalide. Essayer entre 1 et 10.");
	id = Business_Create(playerid, type, price);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès biz (ID: %d.)", id);
	return 1;
}
CMD:bheures(playerid,params[])
{
	static bizid = -1,heure1,heure2;
	if (!IsPlayerInAnyVehicle(playerid) && (bizid = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1)
	{
		if(Inventory_HasItem(playerid,"Clef de magasin"))
		{
			if (Business_IsOwner(playerid,bizid))
			{
				if (sscanf(params, "dd", heure1,heure2))
					return SendSyntaxMessage(playerid, "/bheures [heure1] [heure2]");
				if ((heure1 < 0 || heure1 > 24))
					return SendErrorMessage(playerid, "Vous avez spécifier une heure invalide.");
				if ((heure2 < 0 || heure2 > 24))
					return SendErrorMessage(playerid, "Vous avez spécifier une heure invalide.");
				BusinessData[bizid][biztime1] = heure1;
				BusinessData[bizid][biztime2] = heure2;
				Business_Refresh(bizid);
				Business_Save(bizid);	
				SendServerMessage(playerid,"Entre %d et %d votre magasin sera ouvert.",heure1,heure2);
			}
		}
	}
	return 1;
}
CMD:bizstate(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/bizstate [biz id]");
	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	BusinessData[id][bizOwner] = 99999999;
	Business_Refresh(id);
	Business_Save(id);
	SendServerMessage(playerid, "Ce magasin est maintenant a l'état (/bizcmds).", id);
	return 1;
}
CMD:supbiz(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supbiz [biz id]");
	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID biz invalide.");
	Business_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes le magasin (ID: %d.)", id);
	return 1;
}
CMD:boire(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/drink [water/soda]");
	if (PlayerData[playerid][pDrinking])
	    return SendErrorMessage(playerid, "Vous buver déja quelque chose.");
	if (!strcmp(params, "soda", true))
	{
	    if (!Inventory_HasItem(playerid, "Soda"))
	    	return SendErrorMessage(playerid, "Vous n'avez pas de bouteille sur vous.");
		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "Vous n'avez pas soif maintenant.");
        PlayerData[playerid][pDrinking] = 1;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);
        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);
		Inventory_Add(playerid, "Bouteille vide", 1484);
		Inventory_Remove(playerid, "Soda");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une bouteille et l'ouvre.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Appuyer ~y~LMB~w~ pour boire.");
	}
	else if (!strcmp(params, "eau", true))
	{
	    if (!Inventory_HasItem(playerid, "eau"))
	    	return SendErrorMessage(playerid, "Vous n'avez pas de bouteille d'eau sur vous.");
		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "Vous n'avez pas soif maintenant.");
        PlayerData[playerid][pDrinking] = 2;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);
        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);
		Inventory_Add(playerid, "Bouteille vide", 1484);
		Inventory_Remove(playerid, "eau");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une bouteille et l'ouvre.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Appuyer ~y~LMB~w~ pour boire.");
	}
	else if (!strcmp(params, "aBTool", true))
	{
	    if (!Inventory_HasItem(playerid, "aBTool"))
	    	return SendErrorMessage(playerid, "Vous n'avez pas de bouteille d'aBTool sur vous.");
		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "Vous n'avez pas soif maintenant.");
        PlayerData[playerid][pDrinking] = 2;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);
        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);
		Inventory_Add(playerid, "Bouteille vide", 1484);
		Inventory_Remove(playerid, "aBTool");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une bouteille et l'ouvre.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Appuyer ~y~LMB~w~ pour boire.");
	}
	else if (!strcmp(params, "jus de pomme", true))
	{
	    if (!Inventory_HasItem(playerid, "jus de pomme"))
	    	return SendErrorMessage(playerid, "Vous n'avez pas de jus de pomme sur vous.");
		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "Vous n'avez pas soif maintenant.");
        PlayerData[playerid][pDrinking] = 2;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);
        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);
		Inventory_Add(playerid,"Boite de carton", 928);
		Inventory_Remove(playerid, "jus de pomme");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une bouteille et l'ouvre.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Appuyer ~y~LMB~w~ pour boire.");
	}
	else if (!strcmp(params, "jus dorange", true))
	{
	    if (!Inventory_HasItem(playerid, "jus dorange"))
	    	return SendErrorMessage(playerid, "Vous n'avez pas de jus de d'orange sur vous.");
		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "Vous n'avez pas soif maintenant.");
        PlayerData[playerid][pDrinking] = 2;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);
        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);
		Inventory_Add(playerid, "Boite de carton", 928);
		Inventory_Remove(playerid, "jus dorange");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une bouteille et l'ouvre.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Appuyer ~y~LMB~w~ pour boire.");
	}
	else if (!strcmp(params, "cafe", true))
	{
	    if (!Inventory_HasItem(playerid, "cafe"))
	    	return SendErrorMessage(playerid, "Vous n'avez pas de café sur vous.");
		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "Vous n'avez pas soif maintenant.");
        PlayerData[playerid][pDrinking] = 2;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);
        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);
		Inventory_Remove(playerid, "cafe");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un café.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Appuyer ~y~LMB~w~ pour boire.");
	}
	return 1;
}
CMD:cuisiner(playerid, params[])
{
	new houseid = House_Inside(playerid);
	if (houseid == -1)
	    return SendErrorMessage(playerid, "Vous devez être a l'intérieur d'une maison pour cela");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/cuisiner [burger/pizza/jambon/sandwich jambon/sandwich steak/sandwich poulet]");
    if (PlayerData[playerid][pCuffed])
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (!strcmp(params, "burger", true))
	{
	    if (!Inventory_HasItem(playerid, "Burger surgele"))
	        return SendErrorMessage(playerid, "Vous n'avez pas d'aliment.");
		if (PlayerData[playerid][pCooking])
		    return SendErrorMessage(playerid, "Vous préparez déja un repas.");
		Inventory_Add(playerid, "Boite de carton", 928);
		PlayerData[playerid][pCooking] = 1;
		PlayerData[playerid][pCookingTime] = 20;
		PlayerData[playerid][pCookingHouse] = houseid;
		Inventory_Remove(playerid, "Burger surgele");
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s se prépare un repas. (20 seconds).", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "pizza", true))
	{
	    if (!Inventory_HasItem(playerid, "Pizza surgele"))
	        return SendErrorMessage(playerid, "Vous n'avez pas d'aliment.");
		if (PlayerData[playerid][pCooking])
		    return SendErrorMessage(playerid, "Vous préparez déja un repas.");
        Inventory_Add(playerid, "Boite de carton", 928);
		PlayerData[playerid][pCooking] = 2;
		PlayerData[playerid][pCookingTime] = 55;
		PlayerData[playerid][pCookingHouse] = houseid;
        Inventory_Remove(playerid, "Pizza surgele");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s se prépare un repas. (55 seconds).", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "jambon", true))
	{
	    if (!Inventory_HasItem(playerid, "jambon"))
	        return SendErrorMessage(playerid, "Vous n'avez pas d'aliment.");
		if (PlayerData[playerid][pCooking])
		    return SendErrorMessage(playerid, "Vous préparez déja un repas.");
		PlayerData[playerid][pCooking] = 3;
		PlayerData[playerid][pCookingTime] = 60;
		PlayerData[playerid][pCookingHouse] = houseid;
        Inventory_Remove(playerid, "jambon");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s se prépare un repas. (60 seconds).", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:veste(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (!Inventory_HasItem(playerid, "Gilet par balles"))
	    return SendErrorMessage(playerid, "Vous avez pas de gilet par-balle.");
	if (ReturnArmour(playerid) > 80)
	    return SendErrorMessage(playerid, "Vous avez déja un gilet par-balle");
	SetPlayerArmour(playerid, 100.0);
	Inventory_Remove(playerid, "Gilet par balles");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend un gilet par-balle et l'enfiller.", ReturnName(playerid, 0));
	return 1;
}
CMD:bcoffre(playerid, params[])
{
    static bizid = -1,type[24],str[12],amount;
	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid))
	{
	    if (sscanf(params, "s[24]S()[12]", type, str))
	    {
			SendSyntaxMessage(playerid, "/bcoffre [name] (%s valide)", FormatNumber(BusinessData[bizid][bizVault]));
	        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} retirer, deposer, balance");
	        return 1;
		}
		if (!strcmp(type, "retirer", true))
		{
		    if (sscanf(str, "d", amount))
		        return SendSyntaxMessage(playerid, "/bcoffre [withdraw] [montant]");
			if (amount < 1 || amount > BusinessData[bizid][bizVault])
			    return SendErrorMessage(playerid, "Montant invalide.");
            BusinessData[bizid][bizVault] -= amount;
            Business_Save(bizid);
            GiveMoney(playerid, amount);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a retiré %s du coffre du magasin.", ReturnName(playerid, 0), FormatNumber(amount));
		}
		else if (!strcmp(type, "deposer", true))
		{
		    if (sscanf(str, "d", amount))
		        return SendSyntaxMessage(playerid, "/bcoffre [deposit] [montant]");
			if (amount < 1 || amount > GetMoney(playerid))
			    return SendErrorMessage(playerid, "Montant invalide.");
            BusinessData[bizid][bizVault] += amount;
            Business_Save(bizid);
            GiveMoney(playerid, -amount);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a déposé %s dans le coffre du magasin.", ReturnName(playerid, 0), FormatNumber(amount));
		}
		else if (!strcmp(type, "balance", true))
		{SendServerMessage(playerid, "\"%s\" Total: %s.", BusinessData[bizid][bizName], FormatNumber(BusinessData[bizid][bizVault]));}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas dans votre magasin.");
	return 1;
}
CMD:passerpermis4321(playerid, params[])
{
	new serveurinfo;
	if (PlayerData[playerid][pDrivingTest])
	    return SendErrorMessage(playerid, "Vous avez déja commencer le test!");
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2035.0946,-117.3694,1035.1719))
	    return SendErrorMessage(playerid, "Vous n'êtes pas à l'auto école");
	if (Inventory_HasItem(playerid, "permis de conduire"))
	    return SendErrorMessage(playerid, "Vous avez déjà votre permis.");
	if (GetMoney(playerid) < 500)
	    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent (500$)");
    PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
   	PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
 	GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);
	if(info_serveursetting[serveurinfo][settingvilleactive] == 1)
	{ PlayerData[playerid][pTestCar] = CreateVehicle(410, -2047.1056, -87.7183, 34.8219, 0.1447, -1, -1, -1); }
	if(info_serveursetting[serveurinfo][settingvilleactive] == 5)//ugmp
	{ PlayerData[playerid][pTestCar] = CreateVehicle(410,859.2825,-1857.2244,8.9857,89.7378, -1, -1, -1);}
    PlayerData[playerid][pTestWarns] = 0;
	if (PlayerData[playerid][pTestCar] != INVALID_VEHICLE_ID)
	{
		PlayerData[playerid][pDrivingTest] = true;
	    PlayerData[playerid][pTestStage] = 0;
		ResetVehicle(PlayerData[playerid][pTestCar]);
	    SetPlayerVirtualWorld(playerid,0);
	    SetVehicleVirtualWorld(PlayerData[playerid][pTestCar], 0);
		PutPlayerInVehicle(playerid, PlayerData[playerid][pTestCar], 0);
		SetPlayerCheckpoint(playerid, g_arrDrivingCheckpoints[0][0], g_arrDrivingCheckpoints[0][1], g_arrDrivingCheckpoints[0][2], 3.0);
		SendPermisMessage(playerid, "Vous avez commencer votre test de conduite.");
		SendPermisMessage(playerid, "Ne dépasser pas les 60 km/h.");
		SendPermisMessage(playerid, "Faite attention au véhicule. (Dommage moins de 40 pourcent)");
		SendPermisMessage(playerid, "N'oubliez pas votre ceinture.");
		SetPlayerInterior(playerid, 0);
		new voicar = GetPlayerVehicleID(playerid);
		SetEngineStatus(voicar, true);
		ResetVehicle(PlayerData[playerid][pTestCar]);
	    SetPlayerVirtualWorld(playerid, (2000 + playerid));
	    SetVehicleVirtualWorld(PlayerData[playerid][pTestCar], (2000 + playerid));
		PutPlayerInVehicle(playerid, PlayerData[playerid][pTestCar], 0);
		GiveMoney(playerid, -500);
		new moneyentrepriseid;
		argent_entreprise[moneyentrepriseid][argentmairie] += 500;
		moneyentreprisesave(moneyentrepriseid);
		ShowPlayerFooter(playerid, "Vous avez payez ~r~500$~w~ pour passer le teste.");
	}
	return 1;
}
CMD:creerentrer(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4)
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
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editentrer [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, password, name, porte, mapicon, type, custom, virtual");
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
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté licon map de  l'entrée ID: %d a %d.", ReturnName(playerid, 0), id, icon);
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
            	EntranceData[id][entranceInt][2] = 802.5010;
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supentrer [entrance id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !EntranceData[id][entranceExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une entrée invalide ID.");
	Entrance_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes l'entrée (ID: %d.)", id);
	return 1;
}
CMD:chargeur(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	new weaponid = 0;
	if (Inventory_HasItem(playerid, "Munition"))
	{
		switch ((weaponid = GetWeapon(playerid)))
		{
			case 22, 23, 24: GiveWeaponToPlayer(playerid, weaponid, 68);
			case 25, 26, 27: GiveWeaponToPlayer(playerid, weaponid, 20);
			case 28, 31, 32: GiveWeaponToPlayer(playerid, weaponid, 200);
			case 29, 30: GiveWeaponToPlayer(playerid, weaponid, 120);
			case 33, 34: GiveWeaponToPlayer(playerid, weaponid, 20);
			case 35..37: GiveWeaponToPlayer(playerid, weaponid, 4);
			case 38: GiveWeaponToPlayer(playerid, weaponid, 500);
			default: return SendErrorMessage(playerid, "Tu ne peut utiliser de chargeur.");
		}
		Inventory_Remove(playerid, "Munition");
	}
	if (Inventory_HasItem(playerid, "douille de shotgun"))
	{
		switch ((weaponid = GetWeapon(playerid)))
		{
			case 25, 26, 27: GiveWeaponToPlayer(playerid, weaponid, 20);
			default: return SendErrorMessage(playerid, "Tu ne peut utiliser de douille de shotgun.");
		}
		Inventory_Remove(playerid, "douille de shotgun");
	}
	PlayReloadAnimation(playerid, weaponid);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un chargeur pour son %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
	return 1;
}
CMD:atm(playerid, params[])
{
	new stockjobinfoid;
	if (ATM_Nearest(playerid) == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche d'un atm.");
    if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
	/*Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, "Guichet automatique", "Compte en banque: %s$\nCompte épargne: %s$", "Valider", "Quitter", FormatNumber(PlayerData[playerid][pBankMoney]), FormatNumber(PlayerData[playerid][pSavings]));*/
	SelectTextDraw(playerid, 0xA3B4C5FF);
	for (new x=0 ; x<20 ;x++)
	PlayerTextDrawShow(playerid, atmklik[playerid][x]);
	ApplyAnimationEx(playerid,"PED","ATM",4.1,0,1,1,1,1);
	//generateur
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 1;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 1;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 1;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 1;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 1;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
	if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
	stockjobinfosave(stockjobinfoid);
	return 1;
}	
CMD:banque(playerid, params[])
{
	if (!IsPlayerInBank(playerid))
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, "Compte banquaire", "Compte en banque: %s$\nCompte épargne: %s$", "Valider", "Quitter", FormatNumber(PlayerData[playerid][pBankMoney]), FormatNumber(PlayerData[playerid][pSavings]));
	return 1;
}
CMD:sdfghjklloikjiujytr(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	if (!carid)
	    return SendErrorMessage(playerid, "Vous devez être dans un véhicule.");
    if (IsVehicleImpounded(carid))
    	return SendErrorMessage(playerid, "Ce véhicule est a la fourrière.");
	if ((carid = Car_GetID(carid)) != -1)
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return 0;
	    static g_arrSeatData[10] = {INVALID_PLAYER_ID, ...},g_arrDamage[4],Float:health,seatid;
        for (new i = 0; i < 14; i ++) {
			CarData[carid][carMods][i] = GetVehicleComponentInSlot(CarData[carid][carVehicle], i);
	    }
		GetVehicleDamageStatus(CarData[carid][carVehicle], g_arrDamage[0], g_arrDamage[1], g_arrDamage[2], g_arrDamage[3]);
		GetVehicleHealth(CarData[carid][carVehicle], health);
		foreach (new i : Player) if (IsPlayerInVehicle(i, CarData[carid][carVehicle])) {
		    seatid = GetPlayerVehicleSeat(i);
		    g_arrSeatData[seatid] = i;
		}
		GetVehiclePos(CarData[carid][carVehicle], CarData[carid][carPos][0], CarData[carid][carPos][1], CarData[carid][carPos][2]);
		GetVehicleZAngle(CarData[carid][carVehicle], CarData[carid][carPos][3]);
		if(health > 1000) return CarData[carid][carvie] == 1000;
		else CarData[carid][carvie] = health;
		Car_Save(carid);
		SendVehiculeMessage(playerid, "Vous avez garé votre véhicule (%s).", ReturnVehicleName(CarData[carid][carVehicle]));
        UpdateVehicleDamageStatus(CarData[carid][carVehicle], g_arrDamage[0], g_arrDamage[1], g_arrDamage[2], g_arrDamage[3]);
		cmd_limiteur(playerid, "0");
	}
	else SendErrorMessage(playerid, "Vous devez être a l'intérieur d'un vehicule réelle");
	return 1;
}
CMD:creerpump(playerid, params[])
{
	static id,bizid = -1;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
CMD:remplir(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new idk = Car_GetID(vehicleid);
	if (PlayerData[playerid][pRefill] != INVALID_VEHICLE_ID)
	{
	    BusinessData[PlayerData[playerid][pGasStation]][bizVault] += PlayerData[playerid][pRefillPrice];
		Business_Save(PlayerData[playerid][pGasStation]);
        GiveMoney(playerid, -PlayerData[playerid][pRefillPrice]);
		SendVehiculeMessage(playerid, "Vous avez remplie votre vehicule pour %d$.", PlayerData[playerid][pRefillPrice]);
		TogglePlayerControllable(playerid,1);
        StopRefilling(playerid);
        return 1;
	}
	if (!vehicleid)
	    return SendErrorMessage(playerid, "Vous devez être dans un véhicule.");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Vous devez être le chauffeur du véhicule.");
	if (GetEngineStatus(vehicleid))
	    return SendErrorMessage(playerid, "Le moteur doit être éteint s'il vous plait.");
	new id = Pump_Nearest(playerid);
	if (id != -1)
	{
		if (IsPumpOccupied(id))
		    return SendErrorMessage(playerid, "Cette pompe est occupé.");
		if (PumpData[id][pumpFuel] < 1)
   			return SendErrorMessage(playerid, "Cette pompe n'a plus d'essence.");
		PlayerData[playerid][pGasPump] = id;
		PlayerData[playerid][pGasStation] = PumpData[id][pumpBusiness];
		PlayerData[playerid][pRefill] = idk;
		TogglePlayerControllable(playerid,0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s fait le plein de son véhicule.", ReturnName(playerid, 0));
	}
	else {SendErrorMessage(playerid, "Vous n'êtes proche de rien.");}
	return 1;
}
CMD:enlevertunning(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	if (!carid)
	    return SendErrorMessage(playerid, "Vous devez être dans un véhicule.");
    if (IsVehicleImpounded(carid))
    	return SendErrorMessage(playerid, "Ce véhicule est à la fourrière.");
	if ((carid = Car_GetID(carid)) != -1 && Car_IsOwner(playerid, carid))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendErrorMessage(playerid, "Vous devez être le chauffeur du véhicule.");
		for (new i = 0; i < 14; i ++) {
		    RemoveVehicleComponent(CarData[carid][carVehicle], CarData[carid][carMods][i]);
		    CarData[carid][carMods][i] = 0;
		}
		Car_Save(carid);
		SendVehiculeMessage(playerid, "Vous avez enlevé toute les modifications du véhicule");
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule modifiable.");
	return 1;
}
CMD:atamere(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	if (!carid)
	    return SendErrorMessage(playerid, "Vous devez être dans un véhicule.");
	if(!PlayerData[playerid][pAdmin]) return SendErrorMessage(playerid,"Tu doit être dans les admins");
	if ((carid = Car_GetID(carid)) != -1)
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendErrorMessage(playerid, "Vous devez être le chauffeur du véhicule.");
		for (new i = 0; i < 14; i ++) {
		    RemoveVehicleComponent(CarData[carid][carVehicle], CarData[carid][carMods][i]);
		    CarData[carid][carMods][i] = 0;
		}
		CarData[carid][carMods][carPaintjob] = 0;
		CarData[carid][carMods][carColor1] = 0;
		CarData[carid][carMods][carColor2] = 0;
		SetVehicleColor(carid, CarData[carid][carColor1], CarData[carid][carColor2]);
		SetVehiclePaintjob(carid, CarData[carid][carPaintjob]);
		Car_Save(carid);
		SendVehiculeMessage(playerid, "Vous avez enlevé toute les modifications du véhicule");
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule modifiable.");
	return 1;
}
CMD:vcoffre(playerid, params[])
{
	new id = -1,coffre;
    static engine, lights, alarm, doors, bonnet, boot, objective;
	if ((id = Car_Nearest(playerid)) != -1)
	{
	    if (IsVehicleImpounded(CarData[id][carVehicle]))
	        return SendErrorMessage(playerid, "Ce véhicule est à la fourrière.");
	    if (IsPlayerInAnyVehicle(playerid))
	        return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
		if (!IsDoorVehicle(CarData[id][carVehicle]))
		    return SendErrorMessage(playerid, "Ce véhicule n'a pas de coffre.");
		if (CarData[id][carLocked])
		    return SendErrorMessage(playerid, "Le coffre est fermé.");
		GetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
		if(coffre == 0)
		{
			SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, 1, objective);
			coffre = 1;
			Car_ShowTrunk(playerid, id);
		}
		if(coffre == 1)
		{
			SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, 0, objective);
			coffre = 0;
		}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas proche d'un véhicule.");
	return 1;
}
CMD:bnom(playerid, params[])
{
	new id = -1;
    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id))
	{
		if (isnull(params))
		    return SendSyntaxMessage(playerid, "/bnom [nouveau nom]");
		if (strlen(params) > 32)
		    return SendErrorMessage(playerid, "32 caractère maxmium.");
		format(BusinessData[id][bizName], 32, params);
		Business_Refresh(id);
		Business_Save(id);
		SendServerMessage(playerid, "Nom du magasin: \"%s\".", params);
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas à votre magasin.");
	return 1;
}
CMD:bmessage(playerid, params[])
{
	new id = -1;
    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id))
	{
		if (isnull(params))
		    return SendSyntaxMessage(playerid, "/bmessage [message] - Tapez \"non\" pour désactiver.");
		if (!strcmp(params, "non", true))
		{
		    BusinessData[id][bizMessage][0] = '\0';
			Business_Save(id);
			SendServerMessage(playerid, "Vous avez enlevé le message de votre magasin.");
		}
		else
		{
			format(BusinessData[id][bizMessage], 128, params);
			Business_Save(id);
			SendServerMessage(playerid, "Le message de votre magasin est: \"%s\".", params);
		}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas à votre magasin.");
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
CMD:mcoffre(playerid, params[])
{
	static houseid = -1;
	new facass = PlayerData[playerid][pFaction];
	if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || FactionData[facass][factionacces][1] == 1)) {
	    House_OpenStorage(playerid, houseid);
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas dans votre maison.");
	return 1;
}
CMD:fourniture(playerid, params[])
{
    static houseid = -1;
	if ((houseid = House_Inside(playerid)) != -1 && House_IsOwner(playerid, houseid))
	{
        new count = 0,string[MAX_FURNITURE * 24];
        for (new i = 0; i != MAX_FURNITURE; i ++) if (count < MAX_HOUSE_FURNITURE && FurnitureData[i][furnitureExists] && FurnitureData[i][furnitureHouse] == houseid) {
    		ListedFurniture[playerid][count++] = i;
    		format(string, sizeof(string), "%s%s (%.2f metres)\n", string, FurnitureData[i][furnitureName], GetPlayerDistanceFromPoint(playerid, FurnitureData[i][furniturePos][0], FurnitureData[i][furniturePos][1], FurnitureData[i][furniturePos][2]));
		}
		if (count) {
			Dialog_Show(playerid, ListedFurniture, DIALOG_STYLE_LIST, "Liste fourniture", string, "Valider", "Annuler");
     	}
     	else SendErrorMessage(playerid, "Aucune fourniture ici.");
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas chez vous.");
	return 1;
}
CMD:creerjob(playerid, params[])
{
	static type,id = -1;
	if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editjob [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, type, point, deliver");
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
CMD:quitjob(playerid, params[])
{
	if (PlayerData[playerid][pJob] != 0)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (PlayerData[playerid][pMinedRock])
		{
	    	PlayerData[playerid][pMinedRock] = 0;
			PlayerData[playerid][pMineCount] = 0;
			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid, 4);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
		if (PlayerData[playerid][pWoodRock])
		{
			PlayerData[playerid][pWoodCount] = 0;
			PlayerData[playerid][pWoodRock] = 0;
			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid, 4);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
		if (PlayerData[playerid][pPetrolRock])
		{
	    	PlayerData[playerid][pPetrolRock] = 0;
			PlayerData[playerid][pPetrolCount] = 0;
			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid, 4);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
		if (PlayerData[playerid][pJob] == JOB_COURIER)
		{
			if (PlayerData[playerid][pUnloading] != -1)
			{
	   		 	PlayerData[playerid][pUnloading] = -1;
	    		PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;
	    		DisablePlayerCheckpoint(playerid);
			}
			if (PlayerData[playerid][pDeliverShipment])
			{
			    PlayerData[playerid][pShipment] = -1;
			    PlayerData[playerid][pDeliverShipment] = 0;
			    DisablePlayerCheckpoint(playerid);
			}
			if (PlayerData[playerid][pLoading])
			{
	   	 		PlayerData[playerid][pLoading] = 0;
	    		PlayerData[playerid][pLoadType] = 0;
	    		DisablePlayerCheckpoint(playerid);
			}
			if (PlayerData[playerid][pLoadCrate])
 			{
  				PlayerData[playerid][pLoadCrate] = 0;
				RemovePlayerAttachedObject(playerid, 4);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
		}
		if (IsPlayerInWarehouse(playerid) && GetVehicleModel(vehicleid) == 530 && CoreVehicles[vehicleid][vehLoadType] == 7)
		{
 			CoreVehicles[vehicleid][vehLoadType] = 0;
   			DestroyObject(CoreVehicles[vehicleid][vehCrate]);
			CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
			DisablePlayerCheckpoint(playerid);
		}
		SendServerMessage(playerid, "Vous avez quitté votre travail \"%s\".", Job_GetName(PlayerData[playerid][pJob]));
		Updatestocksorter();
		PlayerData[playerid][pJob] = 0;
	}
	else SendErrorMessage(playerid, "Tu n'a pas de travail.");
	return 1;
}
CMD:prendrejob(playerid, params[])
{
	static id = -1;
	if ((id = Job_Nearest(playerid)) != -1)
	{
	    if (PlayerData[playerid][pJob] == JobData[id][jobType])
	        return SendErrorMessage(playerid, "Vous avez déja ce job.");
	    PlayerData[playerid][pJob] = JobData[id][jobType];
		SendJOBMessage(playerid,"Attention certain job ne fonctionne pas avec certain joueur merci de ne pas le rapporté.");
		SendJOBMessage(playerid,"Le développeur est déjà au courant de tout il essai de faire fonctionner pour tous.");
		SendJOBMessage(playerid,"Merci de ne pas rapporté qu'un job ne fonctionne pas avec vous.");
	    return SendServerMessage(playerid, "Vous êtes maintenant un(e) %s - Tapez \"/jobcmds\" pour avoir les commandes.", Job_GetName(JobData[id][jobType]));
	}
    SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	return 1;
}
CMD:livrermarchandise(playerid, params[])
{
	new id = Business_NearestDeliver(playerid),vid = GetPlayerVehicleID(playerid),factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][6] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
    if (id == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
 	if (!IsLoadableVehicle(vid))
  		return SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule de livraison.");
	if (!CoreVehicles[vid][vehLoadType] || CoreVehicles[vid][vehLoads] < 1)
	    return SendErrorMessage(playerid, "Rien de chargé dans ce véhicule.");
	if (PlayerData[playerid][pUnloading] != -1)
	    return SendErrorMessage(playerid, "Tu décharge déja des truc.");
	if (PlayerData[playerid][pShipment] != -1 && id != PlayerData[playerid][pShipment])
	    return SendErrorMessage(playerid, "Tu n'a pas accepté de transport pour ce magasin.");
	switch (CoreVehicles[vid][vehLoadType])
 	{
	 	case 1:
	 	{
	 	    if (BusinessData[id][bizType] != 1 && BusinessData[id][bizType] != 6)
	 	        return SendErrorMessage(playerid, "Ce magasin n'accepte pas ce type de marchandise.");
		}
		case 2..4:
		{
		    if (BusinessData[id][bizType] != CoreVehicles[vid][vehLoadType])
	 	        return SendErrorMessage(playerid, "Ce magasin n'accepte pas ce type de marchandise.");
		}
		case 5:
		{
		    if (BusinessData[id][bizType] != 6)
	 	        return SendErrorMessage(playerid, "Ce magasin n'accepte pas ce type de marchandise.");
		}
		case 6:
		{
		    if (BusinessData[id][bizType] != 7)
	 	        return SendErrorMessage(playerid, "Ce magasin n'accepte pas ce type de marchandise.");
		}
		case 7:
		{
		    if (BusinessData[id][bizType] != 8)
	 	        return SendErrorMessage(playerid, "Ce magasin n'accepte pas ce type de marchandise.");
		}
		case 8:
		{
		    if (BusinessData[id][bizType] != 9)
	 	        return SendErrorMessage(playerid, "Ce magasin n'accepte pas ce type de marchandise.");
		}
	}
	static Float:fX,Float:fY,Float:fZ;
	DisableWaypoint(playerid);
	GetVehicleBoot(vid, fX, fY, fZ);
	RemovePlayerFromVehicle(playerid);
	PlayerData[playerid][pUnloading] = id;
	PlayerData[playerid][pUnloadVehicle] = vid;
	SetPlayerCheckpoint(playerid, fX, fY, fZ, 1.0);
	SendServerMessage(playerid, "Veuillez décharger votre marchandise aux point rouge.");
	return 1;
}
CMD:reparermoteur(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
	if (!Inventory_HasItem(playerid, "Boite a outils"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de Boite a outils sur vous.");
	if (PlayerData[playerid][pRepairTime] > gettime())
	    return SendErrorMessage(playerid, "Vous devez attendre %d secondes avant de refaire cela.", PlayerData[playerid][pRepairTime] - gettime());
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
	    if (!IsEngineVehicle(i))
	        return SendErrorMessage(playerid, "Ce véhicule ne peut etre réparé.");
        if (CoreVehicles[i][vehRepairing])
            return SendErrorMessage(playerid, "Ce vehicule est déja réparé.");
		Inventory_Remove(playerid, "Boite a outils");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
        CoreVehicles[i][vehRepairing] = true;
        SetTimerEx("RepairCarMoteur", 5000, false, "dd", playerid, i);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend sa caisse d'outil et commence a réparer le moteur du véhicule.", ReturnName(playerid, 0));
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Reparation moteur...~w~ veuiller attendre", 5500, 3);
		return 1;
	}
	SendErrorMessage(playerid, "Vous n'est pas proche d'un capot de vehicule.");
	return 1;
}
CMD:reparercaro(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
	if (!Inventory_HasItem(playerid, "Boite a outils"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de Boite a outils sur toi.");
	if (PlayerData[playerid][pRepairTime] > gettime())
	    return SendErrorMessage(playerid, "Vous devez attendre %d secondes avant de refaire cela.", PlayerData[playerid][pRepairTime] - gettime());
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
		new stockjobinfoid;
		if(info_stockjobinfo[stockjobinfoid][stocktunningcaro] == 0) return SendErrorMessage(playerid,"Il n'y a plus de pièce de ce type dans la réserve.");
		if( info_stockjobinfo[stockjobinfoid][stocktunningcaro] > 0) {info_stockjobinfo[stockjobinfoid][stocktunningcaro] -= 1;}
		if( info_stockjobinfo[stockjobinfoid][stocktunningcaro] < 0) {info_stockjobinfo[stockjobinfoid][stocktunningcaro] = 0;}
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
        CoreVehicles[i][vehRepairing] = true;
        SetTimerEx("RepairCarCaro", 5000, false, "dd", playerid, i);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend sa caisse d'outil et commence a réparer la carrosserie du véhicule.", ReturnName(playerid, 0));
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Reparation carrosserie...~w~ veuiller attendre", 5500, 3);
		return 1;
	}
	SendErrorMessage(playerid, "Vous n'est pas proche d'un capot de vehicule.");
	return 1;
}
CMD:nitros(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
	if (!Inventory_HasItem(playerid, "Bonbonne de NOS"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de NOS canister sur toi.");
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
	    if (!IsEngineVehicle(i) || IsABike(i) || IsABoat(i) || IsAPlane(i) || IsAHelicopter(i))
	        return SendErrorMessage(playerid, "Tu ne peut ajouter de nitros à ce véhicule.");
	    if (!GetHoodStatus(i))
	        return SendErrorMessage(playerid, "Vous devez ouvrir le capot pour ajouté la nitros.");
		Inventory_Remove(playerid, "Bonbonne de NOS");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		AddComponent(i, 1010);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ajoute de la nitro dans le véhicule.", ReturnName(playerid, 0));
		return 1;
	}
	SendErrorMessage(playerid, "Vous n'est pas proche d'un véhicule.");
	return 1;
}
CMD:peindre(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (PlayerData[playerid][pCuffed])
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	new vehicleid = GetNearestVehicle(playerid);
	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "Tu n'est pas proche d'un véhicule.");
	if (!Inventory_HasItem(playerid, "Bombe de peinture"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de bombe de peinture.");
	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
	static
 		colors[256];
	for (new i = 0; i < sizeof(colors); i ++) {
		colors[i] = i;
   	}
   	ShowColorSelectionMenu(playerid, MODEL_SELECTION_COLOR, colors);
	return 1;
}
CMD:acceptertaxi(playerid, params[])
{
    new facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][13] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (!PlayerData[playerid][pTaxiDuty])
	    return SendErrorMessage(playerid, "Tu doit être dans un taxi et êtres en service (/taxi).");
	Taxi_ShowCalls(playerid);
	return 1;
}
CMD:taxi(playerid, params[])
{
	new modelid = GetVehicleModel(GetPlayerVehicleID(playerid)),facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][13] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (modelid != 438 && modelid != 420)
	    return SendErrorMessage(playerid, "Tu doit être dans un taxi.");
	if (PlayerData[playerid][pTaxiDuty])
	{
	    foreach (new i : Player) if (PlayerData[i][pTaxiPlayer] == playerid && IsPlayerInVehicle(i, GetPlayerVehicleID(playerid))) {
	        LeaveTaxi(i, playerid);
	    }
	    SetPlayerColor(playerid, DEFAULT_COLOR);
        PlayerData[playerid][pTaxiDuty] = false;
        SendServerMessage(playerid, "Vous n'êtes plus en service!");
	}
	else
	{
		SetPlayerColor(playerid, 0xF5DEB300);
	    PlayerData[playerid][pTaxiDuty] = true;
	    SendClientMessageToAllEx(COLOR_GREEN, "[TAXI]: %s est en service. Appellez le 1222 pour joindre un taxi.", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:trousse(playerid, params[])
{
	if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (PlayerData[playerid][pFirstAid])
	    return SendErrorMessage(playerid, "Tu utilise déja une trousse de soin.");
	if (!Inventory_HasItem(playerid, "Trousse de soin"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de trousse de soin.");
	if (ReturnHealth(playerid) > 50)
	    return SendErrorMessage(playerid, "Pas besoin maintenant.");
	if (!IsPlayerInAnyVehicle(playerid))
	    ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
    PlayerData[playerid][pFirstAid] = true;
    PlayerData[playerid][pAidTimer] = SetTimerEx("FirstAidUpdate", 1000, true, "d", playerid);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s utilise une trousse de soin.", ReturnName(playerid, 0));
    Inventory_Remove(playerid, "Trousse de soin");
    ShowPlayerFooter(playerid, "Vous avez utiliser votre ~g~trousse de soin!");
    return 1;
}
CMD:tel(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Telephone"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de téléphone.");
    if(PlayerData[playerid][pAcom] <= 0) return SendErrorMessage(playerid,"{FF0000}Votre batterie est déchargée!");
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	static str[32];
	PlayerData[playerid][pAcom] -= 1;
	format(str, sizeof(str), "Tel (#%d) | Bat %d%", PlayerData[playerid][pPhone],PlayerData[playerid][pAcom]);
	if (PlayerData[playerid][pPhoneOff]) {
		Dialog_Show(playerid, MyPhone, DIALOG_STYLE_LIST, str, "Allumé le téléphone", "Valider", "Annuler");
	}
	else {
	    Dialog_Show(playerid, MyPhone, DIALOG_STYLE_LIST, str, "Eteindre le téléphone\nComposer un numéro\nEnvoyer un SMS\nMes contacts", "Valider", "Annuler");
	}
	return 1;
}
CMD:decrocher(playerid, params[])
{
	if (!PlayerData[playerid][pIncomingCall])
	    return SendErrorMessage(playerid, "Aucun appelle.");
	if (PlayerData[playerid][pCuffed])
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
    if (PlayerData[playerid][pPhoneOff])
    	return SendErrorMessage(playerid, "Votre téléphone est éteinds.");
    if(PlayerData[playerid][pAcom] == 0) return SendErrorMessage(playerid,"{FF0000}Votre batterie est déchargée!");
	new targetid = PlayerData[playerid][pCallLine];
	PlayerData[playerid][pIncomingCall] = 0;
	PlayerData[targetid][pIncomingCall] = 0;
	SendClientMessage(playerid, COLOR_YELLOW, "[SERVER]:{FFFFFF} Vous avez répondu.");
	SendClientMessage(targetid, COLOR_YELLOW, "[SERVER]:{FFFFFF} Il à accepté l'appelle.");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à accepté un appelle.", ReturnName(playerid, 0));
	SetPlayerAttachedObject(playerid, 7, 330, 6,0.068,0.002,0.028999,-91.000205,0.400055,177.100051,1,1,1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_USECELLPHONE);
	return 1;
}
CMD:racrocher(playerid, params[])
{
	new targetid = PlayerData[playerid][pCallLine];
	if (PlayerData[playerid][pEmergency] || PlayerData[playerid][pPlaceAd])
	{
	    PlayerData[playerid][pEmergency] = 0;
	    PlayerData[playerid][pPlaceAd] = 0;
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s raccroche son téléphone", ReturnName(playerid, 0));
        return 1;
	}
	if (PlayerData[playerid][pIncomingCall])
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Vous n'avez pas répondu");
	    SendClientMessage(targetid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Aucune réponse.");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a décliné un appelle.", ReturnName(playerid, 0));
	}
	else
	{
        SendClientMessage(playerid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Vous avez raccroché votre téléphone.");
	    SendClientMessage(targetid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Il/elle a raccroché.");
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s raccroche son téléphone.", ReturnName(playerid, 0));
	    SendNearbyMessage(targetid, 30.0, COLOR_PURPLE, "** %s raccroche son téléphone.", ReturnName(targetid, 0));
	}
	if (targetid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Il n'y a pas d'appels.");
	PlayerData[playerid][pIncomingCall] = 0;
	PlayerData[targetid][pIncomingCall] = 0;
	PlayerData[playerid][pCallLine] = INVALID_PLAYER_ID;
	PlayerData[targetid][pCallLine] = INVALID_PLAYER_ID;
	RemovePlayerAttachedObject(playerid, 7);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}
CMD:sms(playerid, params[])
{
    if (!Inventory_HasItem(playerid, "Telephone"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de téléphone.");
    if (PlayerData[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Votre téléphone est éteinds.");
    if (PlayerData[playerid][pPhoneOff])
    	return SendErrorMessage(playerid, "Votre téléphone est éteinds.");
    if(PlayerData[playerid][pAcom] == 0) return SendErrorMessage(playerid,"{FF0000}Votre batterie est déchargée!");
	static targetid,number,text[128];
	if (sscanf(params, "ds[128]", number, text))
	    return SendSyntaxMessage(playerid, "/sms [numéro de téléphone] [message]");
	if (!number)
	    return SendErrorMessage(playerid, "Le numéro que vous tenter de joindre n'est pas en service..");
	if ((targetid = GetNumberOwner(number)) != INVALID_PLAYER_ID)
	{
	    if (targetid == playerid)
	        return SendErrorMessage(playerid, "Tu ne peut t'envoyer un sms à toi même.");
		if (PlayerData[targetid][pPhoneOff])
		    return SendErrorMessage(playerid, "Son téléphone est probablement éteinds");
        GiveMoney(playerid, -1);
		ShowPlayerFooter(playerid, "Tu a ~r~payer~w~ $1 pour l'envoi du sms.");
		PlayerData[playerid][pAcom] -= 2;
		SendClientMessageEx(targetid, COLOR_YELLOW, "[SMS]: %s - %s (%d)", text, ReturnName(playerid, 0), PlayerData[playerid][pPhone]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS]: %s - %s (%d)", text, ReturnName(playerid, 0), PlayerData[playerid][pPhone]);
        PlayerPlaySoundEx(targetid, 21001);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s envoi un sms.", ReturnName(playerid, 0));
	}
	else {SendErrorMessage(playerid, "Le numéro que vous tentez de joindre n'est pas en service..");}
	return 1;
}
CMD:id(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/id [playerid/nom]");
	if (strlen(params) < 3)
		return SendErrorMessage(playerid, "3 caractètre minimun.");
	new count;
	foreach (new i : Player)
	{
	    if (strfind(ReturnName(i), params, true) != -1)
	    {
	        SendClientMessageEx(playerid, COLOR_WHITE, "** %s - ID: %d", ReturnName(i), i);
	        count++;
		}
	}
	if (!count)
	    return SendErrorMessage(playerid, "Aucun utilisateur trouver: \"%s\".", params);
	return 1;
}
CMD:binfo(playerid, params[])
{
    new id = -1;
    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id)) {
     	SendServerMessage(playerid, "ID: %d | Biz: %s | Produits: %d |Coffre: %s $", id, BusinessData[id][bizName], BusinessData[id][bizProducts], FormatNumber(BusinessData[id][bizVault]));
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place.");
	return 1;
}
CMD:chargerboite(playerid, params[])
{
	new vehid = GetPlayerVehicleID(playerid);
	SetEngineStatus(vehid, true);
	if (PlayerData[playerid][pJob] != JOB_UNLOADER)
	    return SendErrorMessage(playerid, "Vous n'avez pas le job approprié.");
	if (!IsPlayerInWarehouse(playerid))
	    return SendErrorMessage(playerid, "Vous devez être a l'intérieur d'un entrepot pour faire cela.");
	if (GetVehicleModel(vehid) != 530)
	    return SendErrorMessage(playerid, "Vous devez être à l'intérieur d'un forklift.");
	if (CoreVehicles[vehid][vehLoadType] == 7)
	    return SendErrorMessage(playerid, "Chargé.");
	if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1260.3976, -20.0215, 1001.0234))
	    return SendErrorMessage(playerid, "Vous devez être proche du point de chargement.");
	if (PlayerData[playerid][pLoading])
	    return SendErrorMessage(playerid, "Vous chargé déja.");
	PlayerData[playerid][pLoading] = 1;
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Charge une caisse...", 3200, 3);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s charge une caisse en bois sur son forklift.", ReturnName(playerid, 0));
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("ForkliftUpdate", 3000, false, "dd", playerid, vehid);
	return 1;
}
CMD:mine(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_MINER)
	    return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
	if (!IsPlayerNearMine(playerid))
	    return SendErrorMessage(playerid, "Vous devez être proche du lieu de minage.");
	if (PlayerData[playerid][pMining])
	{
	    PlayerData[playerid][pMining] = false;
	    PlayerData[playerid][pMineCount] = 0;
		RemovePlayerAttachedObject(playerid, 4);
	    SendServerMessage(playerid, "Vous avez fini votre job.");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else
	{
	    PlayerData[playerid][pMining] = true;
        PlayerData[playerid][pMineCount] = 0;
	    SendServerMessage(playerid, "Vous avez recupéré une pioche, utilisez le bouton de tir pour piocher!");
	    SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.156547, 0.039423, 0.026570, 198.109115, 6.364907, 262.997558, 1.000000, 1.000000, 1.000000);
	}
	return 1;
}
CMD:bucheron(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_BUCHERON)
	    return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
	if (!IsPlayerNearWoodcut(playerid))
	    return SendErrorMessage(playerid, "Vous devez être proche du lieu de bucheron.");
	new blabla;
	stockjobinfosave(blabla);
	Job_Refresh(8);
	if (PlayerData[playerid][pWoodcutting])
	{
	    PlayerData[playerid][pWoodcutting] = false;
	    PlayerData[playerid][pWoodCount] = 0;
		RemovePlayerAttachedObject(playerid, 4);
	    SendServerMessage(playerid, "Vous avez fini votre job.");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else
	{
	    PlayerData[playerid][pWoodcutting] = true;
        PlayerData[playerid][pWoodCount] = 0;
	    SendServerMessage(playerid, "Vous avez recupéré une chainsaw, utilisez le bouton de tir pour couper le bois!");
	    SetPlayerAttachedObject(playerid, 4, 341, 6, 0.156547, 0.039423, 0.026570, 198.109115, 6.364907, 262.997558, 1.000000, 1.000000, 1.000000);
	}
	return 1;
}
CMD:vendrefood(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][11] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 423 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 588)
 		return SendErrorMessage(playerid, "Vous devez être à l'intérieur d'un food truck.");
	static userid,food[24],price;
	if (sscanf(params, "us[24]d", userid, food, price))
	{
	    SendSyntaxMessage(playerid, "/vendrefood [playerid/name] [nom du produit] [prix]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} eau, soda, burger, pizza, chicken, chargeur");
	    return 1;
	}
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 7.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (price < 1 || price > 20)
	    return SendErrorMessage(playerid, "Le prix doit être entre 1 et 20$.");
	if (!strcmp(food, "eau", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 1;
	    PlayerData[userid][pFoodPrice] = price;
		SendServerMessage(userid, "%s vous a offert une bouteille d'eau pour %d$ (Tapez \"/accepter food\" pour accepté).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "Vous avez offert une bouteille d'eau à %s pour %d$.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "soda", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 2;
	    PlayerData[userid][pFoodPrice] = price;
		SendServerMessage(userid, "%s vous a offert un soda pour %d$ (Tapez \"/accepter food\" pour accepté).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "Vous avez offert un soda à %s pour %d$.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "burger", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 3;
	    PlayerData[userid][pFoodPrice] = price;
		SendServerMessage(userid, "%s vous a offert un burger pour %d$ (Tapez \"/accepter food\" pour accepté).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "Vous avez offert un burger à %s pour %d$.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "pizza", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 4;
	    PlayerData[userid][pFoodPrice] = price;
		SendServerMessage(userid, "%s vous a offert une pizza pour %d$ (Tapez \"/accepter food\" pour accepté).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "Vous avez offert une pizza à %s pour %d$.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "Poulet", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 5;
	    PlayerData[userid][pFoodPrice] = price;
		SendServerMessage(userid, "%s vous a offert une chicken pour %d$ (Tapez \"/accepter food\" pour accepté).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "Vous avez offert un chicken à %s pour %d$.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "chargeur", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 5;
	    PlayerData[userid][pFoodPrice] = price;
		SendServerMessage(userid, "%s vous a offert un chargeur pour %d$ (Tapez \"/accepter food\" pour accepté).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "Vous avez offert un chargeur à %s pour %d$.", ReturnName(userid, 0), price);
	}
	return 1;
}
CMD:creercrate(playerid, params[])
{
	static id = -1,type;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creercrate [type]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]: 1: Melee | 2: Pistol Parts | 3: SMG Parts | 4: Shotgun Parts | 5: Rifle Parts | 6: Drugs | 7: Munitions | 8: Cocktail Molotov | 9: Piece de frontbumper | 10: Piece de rearbumper | 11: Piece de roof | 12: Piece de hood | 13: Piece de spoiler | 14: Piece d'extra | 15: Piece d'hydraulics | 16: Piece de roue | 17: Piece de carrosserie");
		return 1;
	}
	if (type < 1 || type > 20)
	    return SendErrorMessage(playerid, "Type invalide. Essayer entre 1 a 20.");
	id = Crate_Create(playerid, type);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès crate (ID: %d.)", id);
	return 1;
}

CMD:supcrate(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supcrate [crate id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !CrateData[id][crateExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID boite invalide.");

	Crate_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes crate (ID: %d.)", id);
	return 1;
}
CMD:boite(playerid, params[])
{
	static string[512];
	string[0] = '\0';
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsLoadableVehicle(i) && IsPlayerNearBoot(playerid, i))
	{
	    if (GetVehicleCrates(i) < 1)
	        return SendErrorMessage(playerid, "There are no crates in ce vehicule.");
		for (new j = 0; j != MAX_DYNAMIC_OBJ; j ++) if (CrateData[j][crateExists] && CrateData[j][crateVehicle] == i) {
			format(string, sizeof(string), "%sCrate #%d: %s Parts\n", string, j, Crate_GetType(CrateData[j][crateType]));
		}
		PlayerData[playerid][pCrateVehicle] = i;
		return Dialog_Show(playerid, Crates, DIALOG_STYLE_LIST, "Vehicle Crates", string, "Take", "Annuler");
	}
	SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	return 1;
}
CMD:creerarme(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][13] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
    if (!IsPlayerInRangeOfPoint(playerid, 5.0,FactionData[facass][factionaction1Pos][0],FactionData[facass][factionaction1Pos][1],FactionData[facass][factionaction1Pos][2])) return SendErrorMessage(playerid,"Vous n'êtes pas à la bonne place.");
	if (PlayerData[playerid][pCarryCrate] == -1)
	    return SendErrorMessage(playerid, "Tu n'as pas de boite dans les mains.");
	if (PlayerData[playerid][pCrafting])
	    return SendErrorMessage(playerid, "Tu à déja une boite.");
	if (CrateData[PlayerData[playerid][pCarryCrate]][crateType] < 1 || CrateData[PlayerData[playerid][pCarryCrate]][crateType] > 8)
	    return SendErrorMessage(playerid, "Il n'y a pas d'arme dans la boite.");
    PlayerData[playerid][pCrafting] = 1;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s commence à construire des %s.", ReturnName(playerid, 0), Crate_GetType(CrateData[PlayerData[playerid][pCarryCrate]][crateType]));
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Crafting parts...", 11000, 3);
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("CraftParts", 8000, false, "dd", playerid, PlayerData[playerid][pCarryCrate]);
	return 1;
}
CMD:ouvrircargaison(playerid, params[])
{
	new id = Crate_Nearest(playerid);
	if (id == -1 || CrateData[id][crateType] != 6)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	if (!Inventory_HasItem(playerid, "Pied de biche"))
		return SendErrorMessage(playerid, "Vous n'avez pas de pied de biche.");
	if (PlayerData[playerid][pOpeningCrate])
	    return SendErrorMessage(playerid, "Tu ouvre déja une boite.");
	PlayerData[playerid][pOpeningCrate] = 1;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend son pied de biche et force l'ouverture de la cargaison ", ReturnName(playerid, 0));
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Ouverture de boite...", 3000, 3);
 	TogglePlayerControllable(playerid, 0);
  	ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.0, 1, 1, 1, 1, 0, 1);
	DestroyActor(missionactor);
	mission[playerid] = 0;
	switch (random(30))
	{
	   	case 0: missionactor = CreateActor(179,2507.4971,-2043.9542,13.5500,172.2477);
	   	case 1: missionactor = CreateActor(179,2509.2068,-1978.2653,13.4334,105.5648);
	   	case 2: missionactor = CreateActor(179,1095.3033,-873.7767,43.3906,1.4719);
	   	case 3: missionactor = CreateActor(179,880.2112,-1381.2468,25.2025,269.2101);
	   	case 4: missionactor = CreateActor(179,2346.2256,-1239.5133,22.5000,0.5437);
	   	case 5: missionactor = CreateActor(179,984.6139,-1613.4885,13.4954,93.7949);
		case 6: missionactor = CreateActor(179,977.0787,-942.4401,41.1425,38.4210); // bot1
		case 7: missionactor = CreateActor(179,779.0912,-1717.4033,4.9766,72.3261); // bot2
		case 8: missionactor = CreateActor(179,1431.6185,-1095.8884,17.5793,332.3431); // bot3
		case 9: missionactor = CreateActor(179,1680.5024,-1238.6655,14.9538,312.8443); // bot4
		case 10: missionactor = CreateActor(179,2124.2429,-1194.6682,23.9642,87.6751); // bot5
		case 11: missionactor = CreateActor(179,2083.6416,-1023.6044,33.1627,151.9735); // bot6
		case 12: missionactor = CreateActor(179,2507.0671,-1471.7194,24.0394,280.6100); // bot7
		case 13: missionactor = CreateActor(179,1516.8875,-1506.0033,13.5547,324.2364); // bot8
		case 14: missionactor = CreateActor(179,2621.9009,-2057.9226,13.5500,178.9987); // bot9
		case 15: missionactor = CreateActor(179,2738.2170,-1829.5782,11.8430,351.1509); // bot10
		case 16: missionactor = CreateActor(179,2668.5574,-1539.2067,25.1203,195.6187); // bot11
		case 17: missionactor = CreateActor(179,2762.1509,-1285.7408,41.7197,225.5658); // bot12
		case 18: missionactor = CreateActor(179,2767.0271,-1192.7881,69.4097,357.0363); // bot13
		case 19: missionactor = CreateActor(179,2788.7820,-1467.7402,40.0625,321.8119); // bot14
		case 20: missionactor = CreateActor(179,2791.5862,-1079.5629,30.7188,48.8802); // bot15
		case 21: missionactor = CreateActor(179,2412.8145,-1208.6603,29.3274,2.2453); // bot16
		case 22: missionactor = CreateActor(179,2331.0620,-1336.5182,24.0639,203.7363); // bot17
		case 23: missionactor = CreateActor(179,1972.8481,-1304.1487,20.8297,224.8212); // bot18
		case 24: missionactor = CreateActor(179,1228.0179,-1889.8441,13.7815,28.0432); // bot19
		case 25: missionactor = CreateActor(179,1615.5521,-1779.6171,13.5315,111.6386); // bot20
		case 26: missionactor = CreateActor(179,1668.6542,-1641.1974,22.5251,319.7593); // bot22
		case 27: missionactor = CreateActor(179,1668.6469,-1632.4844,22.5217,204.6605); // bot23
		case 28: missionactor = CreateActor(179,1740.5454,-1540.5977,13.5511,311.0774); // bot24
		case 29: missionactor = CreateActor(179,1403.7306,-1298.5013,13.5460,236.3440); // bot25
	}
	SetTimerEx("OpenCrate", 3000, false, "dd", playerid, id);
    return 1;
}
CMD:planter(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/plant [weed/cocaine/heroin]");
	if (Plant_Nearest(playerid) != -1)
	    return SendErrorMessage(playerid, "Tu ne peut planter.");
	if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0) return SendErrorMessage(playerid, "Seulement a l'extérieur.");
	if (!strcmp(params, "weed", true))
	{
	    if (Inventory_Count(playerid, "Graine marijuana") < 20)
	        return SendErrorMessage(playerid, "Tu a besoin de 20 graine de marijuana.");
		Inventory_Remove(playerid, "Graine marijuana", 20);
		Plant_Create(playerid, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s plante de la marijuana au sol.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "cocaine", true))
	{
	    if (Inventory_Count(playerid, "Graine cocaine") < 15)
	        return SendErrorMessage(playerid, "Tu a besoin de 15 graine de cocaine.");
		Inventory_Remove(playerid, "Graine cocaine", 15);
		Plant_Create(playerid, 2);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s plante de la cocaine au sol.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "heroin", true))
	{
	    if (Inventory_Count(playerid, "Graine Heroin Opium") < 10)
	        return SendErrorMessage(playerid, "Tu a besoin de 10 graine d'héroine.");
		Inventory_Remove(playerid, "Graine Heroin Opium", 10);
		Plant_Create(playerid, 3);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s plante de l'héroine au sol.", ReturnName(playerid, 0));
	}
	else {SendSyntaxMessage(playerid, "/plant [weed/cocaine/heroin]");}
	return 1;
}
CMD:recolter(playerid, params[])
{
	new id = Plant_Nearest(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "Du doit être proche d'une plante.");
	if (PlantData[id][plantDrugs] < Plant_MaxGrams(PlantData[id][plantType]))
	    return SendErrorMessage(playerid, "Cette plante n'a pas fini de poussé.");
	if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
	    return SendErrorMessage(playerid, "Accroupi-toi.");
	if (PlayerData[playerid][pHarvesting])
	    return SendErrorMessage(playerid, "Tu fait déja sa.");
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Recolte...", 3100, 3);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s commence a récolté une plante.", ReturnName(playerid, 0));
	PlayerData[playerid][pHarvesting] = 1;
	SetTimerEx("HarvestPlant", 3000, false, "dd", playerid, id);
	return 1;
}
CMD:creerfaction(playerid, params[])
{
	static id = -1,name[32];
    if (PlayerData[playerid][pAdmin] < 4 || !PlayerData[playerid][pFactionMod])
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
CMD:open(playerid, params[])
{
	new id = Gate_Nearest(playerid),stockjobinfoid,facass = PlayerData[playerid][pFaction];
	if (id != -1)
	{
		if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
		//generateur
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 2;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 2;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 2;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 2;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 2;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
		stockjobinfosave(stockjobinfoid);
		if (strlen(GateData[id][gatePass]))
		{Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT, "Mot de passe", "Veuiller entrée le mot de passe:", "Valider", "Annuler");}
		else
		{
		    if (GateData[id][gateFaction] != -1 && PlayerData[playerid][pFaction] != GetFactionByID(GateData[id][gateFaction]))
				return SendErrorMessage(playerid, "Tu ne peux pas ouvrir cette porte.");
			Gate_Operate(id);
			switch (GateData[id][gateOpened])
			{
			    case 0: ShowPlayerFooter(playerid, "Vous avez ~r~fermer~w~ la porte!");
                case 1: ShowPlayerFooter(playerid, "Vous avez ~g~ouvert~w~ la porte!");
			}
		}
	}
	else if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonDoors][0]))
	{
	    if (FactionData[facass][factionacces][1] == 0)
	        return SendErrorMessage(playerid, "Tu doit être officer de police pour ouvrir la porte..");
	    if (!PrisonData[prisonDoorOpened][0])
		{
			SetDynamicObjectRot(PrisonData[prisonDoors][0], 0.0, 0.0, -90.0);
			PrisonData[prisonDoorOpened][0] = true;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ouvre une porte de prison.", ReturnName(playerid, 0));
		}
		else
		{
		    SetDynamicObjectRot(PrisonData[prisonDoors][0], 0.0, 0.0, 0.0);
			PrisonData[prisonDoorOpened][0] = false;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ferme une porte de prison.", ReturnName(playerid, 0));
		}
	}
	else if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonDoors][1]))
	{
	    if (FactionData[facass][factionacces][1] == 0)
	        return SendErrorMessage(playerid, "Tu doit être officer de police pour ouvrir la porte..");
	    if (!PrisonData[prisonDoorOpened][1])
		{
			SetDynamicObjectRot(PrisonData[prisonDoors][1], 0.0, 0.0, 0.0);
			PrisonData[prisonDoorOpened][1] = true;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ouvre une porte de prison.", ReturnName(playerid, 0));
		}
		else
		{
		    SetDynamicObjectRot(PrisonData[prisonDoors][1], 0.0, 0.0, 90.0);
			PrisonData[prisonDoorOpened][1] = false;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ferme une porte de prison.", ReturnName(playerid, 0));
		}
	}
	else if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonDoors][2]))
	{
	    if (FactionData[facass][factionacces][1] == 0)
	        return SendErrorMessage(playerid, "Tu doit être officer de police pour ouvrir la porte.");
	    if (!PrisonData[prisonDoorOpened][2])
		{
			SetDynamicObjectRot(PrisonData[prisonDoors][2], 0.0, 0.0, -90.0);
			PrisonData[prisonDoorOpened][2] = true;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ouvre une porte de prison.", ReturnName(playerid, 0));
		}
		else
		{
		    SetDynamicObjectRot(PrisonData[prisonDoors][2], 0.0, 0.0, 0.0);
			PrisonData[prisonDoorOpened][2] = false;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ferme une porte de prison.", ReturnName(playerid, 0));
		}
	}
	for (new i = 0; i < 24; i ++) if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonCells][i], 3.0))
	{
	    if (FactionData[facass][factionacces][1] == 0)
	        return SendErrorMessage(playerid, "Tu doit être officer de police pour ouvrir la porte.");
		if (!PrisonData[prisonCellOpened][i])
		{
			MoveDynamicObject(PrisonData[prisonCells][i], PrisonCells[i][0], PrisonCells[i][1] + 1.6, PrisonCells[i][2], 3.0);
		    PrisonData[prisonCellOpened][i] = true;
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ouvre the prison cell.", ReturnName(playerid, 0));
		}
		else
		{
		    MoveDynamicObject(PrisonData[prisonCells][i], PrisonCells[i][0], PrisonCells[i][1], PrisonCells[i][2], 3.0);
		    PrisonData[prisonCellOpened][i] = false;
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend c'est clés et ferme the prison cell.", ReturnName(playerid, 0));
		}
		break;
	}
	return 1;
}
CMD:jeter(playerid, params[])
{
	new weaponid = 0;
    if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid))
    	return SendErrorMessage(playerid, "Tu ne peut pas faire cela.");
	if ((weaponid = GetWeapon(playerid)) == 0)
	    return SendErrorMessage(playerid, "Ta pas d'arme sur toi");
	if (weaponid == 23 && PlayerData[playerid][pTazer])
	    return SendErrorMessage(playerid, "Tu ne peut pas jeté le tazer");
    if (weaponid == 25 && PlayerData[playerid][pflashball])
	    return SendErrorMessage(playerid, "Tu ne peut pas jeté ton arme non lethal.");
	static Float:x,Float:y,Float:z,Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	x += 1.5 * floatsin(-angle, degrees);
	y += 1.5 * floatcos(-angle, degrees);
    DropItem(ReturnWeaponName(weaponid), ReturnName(playerid, 0), GetWeaponModel(weaponid), 1, x, y, z - 1, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), weaponid, GetPlayerAmmo(playerid));
	ResetWeapon(playerid, weaponid);
    ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s jette son arme.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
 	Log_Write("logs/droppick.txt", "[%s] %s jette un(e) %s.", ReturnDate(), ReturnName(playerid, 0), ReturnWeaponName(weaponid));
	return 1;
}
CMD:editfaction(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 4 || !PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editfaction [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} name, models, locker, ranks, maxranks, acces[1 a 15], action[1 a 3]");
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
	    new discordid[20];
	    if (sscanf(string, "s[20]", discordid))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [discordchat] [discord id]");
		format(FactionData[id][factiondiscord],20,discordid);
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté le discord chat a %s pour la faction %d.", ReturnName(playerid, 0),discordid,id);
	}
	else if (!strcmp(type, "acces1", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces1 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][1] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 1 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces2", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces2 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][2] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 2 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces3", true))
	{
		new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces3 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][3] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 3 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces4", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces4 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][4] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 4 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces5", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces5 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][5] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 5 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces6", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces6 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][6] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 6 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces7", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces7 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][7] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 7 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces8", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces8 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][8] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 8 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces9", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces9 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][9] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 9 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces10", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces10 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][10] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 10 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces11", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces11 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][11] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 11 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces12", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces12 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][12] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 12 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces13", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces13 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][13] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 13 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces14", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces14 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][14] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 14 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
	}
	else if (!strcmp(type, "acces15", true))
	{
	    new acces;
	    if (sscanf(string, "d", acces))
	        return SendSyntaxMessage(playerid, "/editfaction [id] acces15 [o/n]");
		if (acces < 0 || acces > 1)
		    return SendErrorMessage(playerid," 0 = non, 1 = oui.");
	    FactionData[id][factionacces][15] = acces;
	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "[ADMIN]: %s a ajusté l'acces faction 14 de la faction ID: %d a %d.", ReturnName(playerid, 0), id, acces);
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
CMD:color(playerid, params[])
{
	static  color;
	if (sscanf(params, "h", color)) {
	 	SendSyntaxMessage(playerid, "/color [hex color]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[EXAMPLE]:{FFFFFF} 0xFFFFFFFF is white, 0xFF0000FF is red, etc.");
	}
	else {
	    SendClientMessageEx(playerid, color, "This is a test message, testing color 0x%06xFF.", color >>> 8);
	}
	return 1;
}
CMD:fequipement(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
 	if (factionid == -1)
	    return SendErrorMessage(playerid, "Tu doit être dans une faction.");
	if (!IsNearFactionLocker(playerid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche de votre point d'équipement.");
	if (FactionData[factionid][factionacces][1] == 1 || FactionData[factionid][factionacces][3] == 1 || FactionData[factionid][factionacces][7] == 1 || FactionData[factionid][factionacces][4] == 1)
		Dialog_Show(playerid, Locker, DIALOG_STYLE_LIST, "Equipement", "Se mettre en service\nVêtements\nArmes\nRegarder CV", "Valider", "Annuler");
	else Dialog_Show(playerid, Locker, DIALOG_STYLE_LIST, "Equipement", "Vêtements\nArmes\nRegarder CV\nCoffre", "Valider", "Annuler");
	return 1;
}
CMD:membres(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
 	if (factionid == -1)
	    return SendErrorMessage(playerid, "Tu doit être membre d'une faction.");
	SendClientMessage(playerid, COLOR_SERVER, "Membres en ligne:");
	foreach (new i : Player) 
		if (PlayerData[i][pFaction] == factionid && PlayerData[i][pOnDuty] == 1) 
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "[ID: %d] %s - %s (%d), en service", i, ReturnName(i, 0), Faction_GetRank(i), PlayerData[i][pFactionRank]);
		}
		else if(PlayerData[i][pFaction] == factionid && PlayerData[i][pOnDuty] == 0)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "[ID: %d] %s - %s (%d)", i, ReturnName(i, 0), Faction_GetRank(i), PlayerData[i][pFactionRank]);
		}
	return 1;
}
CMD:fac(playerid, params[])
{
    new factionid = PlayerData[playerid][pFaction];
 	if (factionid == -1)
	    return SendErrorMessage(playerid, "Tu doit être dans une faction.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(f)ac [message]");
    if (PlayerData[playerid][pDisableFaction])
	    return SendErrorMessage(playerid, "Tu doit mettre le chat faction ON.");
	SendFactionMessage(factionid, COLOR_FACTION, "(( (%d) %s %s: %s ))", PlayerData[playerid][pFactionRank], Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	Log_Write("logs/faction_chat.txt", "[%s] %s %s: %s", ReturnDate(), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	if(FactionData[factionid][factiondiscord] >0) { SendDC(FactionData[factionid][factiondiscord], "[Faction]  %s: %s", ReturnName(playerid, 0), params); }
	return 1;
}
CMD:finviter(playerid, params[])
{
	new userid;
	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "Tu doit être dans une faction.");
	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/finviter [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
	if (PlayerData[userid][pFaction] == PlayerData[playerid][pFaction])
	    return SendErrorMessage(playerid, "Ce joueur fait déja partie de votre faction.");
    if (PlayerData[userid][pFaction] != -1)
	    return SendErrorMessage(playerid, "Ce joueur est déjas dans une faction.");
	PlayerData[userid][pFactionOffer] = playerid;
    PlayerData[userid][pFactionOffered] = PlayerData[playerid][pFaction];
    SendServerMessage(playerid, "Vous avez demander à %s de rejoindre votre faction \"%s\".", ReturnName(userid, 0), Faction_GetName(playerid));
    SendServerMessage(userid, "%s vous propose de rejoindre la faction  \"%s\"(écriver \"/accepter faction\").", ReturnName(playerid, 0), Faction_GetName(playerid));
	return 1;
}
CMD:fexclure(playerid, params[])
{
    new userid;
	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "Tu doit être dans une faction.");
	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/fexclure [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
	if (PlayerData[userid][pFaction] != PlayerData[playerid][pFaction])
	    return SendErrorMessage(playerid, "Ce joueur ne fait pas partie de votre faction.");
    SendServerMessage(playerid, "Vous avez enlever %s de \"%s\".", ReturnName(userid, 0), Faction_GetName(playerid));
    SendServerMessage(userid, "%s vous sa éjecté de \"%s\".", ReturnName(playerid, 0), Faction_GetName(playerid));
    ResetFaction(userid);
	return 1;
}
CMD:frang(playerid, params[])
{
    new userid,rankid;
	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "Tu doit être dans une faction.");
	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	if (sscanf(params, "ud", userid, rankid))
	    return SendSyntaxMessage(playerid, "/frang [playerid/name] [rang (1-%d)]", FactionData[PlayerData[playerid][pFaction]][factionRanks]);
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut pas changer ton rang.");
	if (PlayerData[userid][pFaction] != PlayerData[playerid][pFaction])
	    return SendErrorMessage(playerid, "Ce joueur n'est pas de votre faction.");
	if (rankid < 0 || rankid > FactionData[PlayerData[playerid][pFaction]][factionRanks])
	    return SendErrorMessage(playerid, "Rang non valide spécifié. Rangs vont de 1 a %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks]);
	PlayerData[userid][pFactionRank] = rankid;
    SendServerMessage(playerid, "Vous avez promus %s a %s (%d).", ReturnName(userid, 0), Faction_GetRank(userid), rankid);
    SendServerMessage(userid, "%s a promus %s (%d).", ReturnName(playerid, 0), Faction_GetRank(userid), rankid);
	return 1;
}
CMD:tazer(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (!PlayerData[playerid][pTazer])
	{
	    PlayerData[playerid][pTazer] = 1;
	    GetPlayerWeaponData(playerid, 2, PlayerData[playerid][pGuns][2], PlayerData[playerid][pAmmo][2]);
		GivePlayerWeapon(playerid, 23, 17);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un tazer de son étuie..", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[playerid][pTazer] = 0;
		SetWeapons(playerid);
		SetPlayerArmedWeapon(playerid, PlayerData[playerid][pGuns][2]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s range son tazer dans son étuie..", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:flashball(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (!PlayerData[playerid][pflashball])
	{
	    PlayerData[playerid][pflashball] = 1;
	    GetPlayerWeaponData(playerid, 3, PlayerData[playerid][pGuns][3], PlayerData[playerid][pAmmo][3]);
		GivePlayerWeapon(playerid, 25, 30);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un(e) flashball shotgun.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[playerid][pflashball] = 0;
		SetWeapons(playerid);
		SetPlayerArmedWeapon(playerid, PlayerData[playerid][pGuns][3]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s range son flashball shotgun.", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:menotter(playerid, params[])
{
    new userid,facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/menotter [playerid/nom]");
	if (!Inventory_HasItem(playerid, "Menottes"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de menotte sur vous.");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
    if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te menotté toi même.");
	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Du doit être proche de ce joueur.");
    if (PlayerData[userid][pStunned] < 0 && GetPlayerSpecialAction(userid) != SPECIAL_ACTION_HANDSUP && !IsPlayerIdle(userid))
	    return SendErrorMessage(playerid, "Le joueur doit être inactif ou étourdi.");
	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendErrorMessage(playerid, "Ce joueur doit être a pied avant de le menotté.");
    if (PlayerData[userid][pCuffed])
        return SendErrorMessage(playerid, "Ce joueur est déja menotté en se moment.");
	static string[64];
	if (PlayerData[userid][pDrinking])
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
		PlayerData[userid][pDrinking] = 0;
	}
	if (start1[playerid] != 0) {start1[playerid] = 0; KillTimer(timerrob[playerid]);return 1;}
	if (PlayerData[userid][pHoldWeapon] > 0) {HoldWeapon(userid, 0);}
    PlayerData[userid][pCuffed] = 1;
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);
	Inventory_Remove(playerid,"Menottes");
	format(string, sizeof(string), "Tu a ete ~r~menotter~w~ par %s.", ReturnName(playerid, 0));
    ShowPlayerFooter(userid, string);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s décroche les menottes de sa ceinture et menotte %s a l'aide de ses deux mains.", ReturnName(playerid, 0), ReturnName(userid, 0));
    return 1;
}

CMD:demenotter(playerid, params[])
{
    new userid,facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/demenotter [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
    if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te démennotté toi même.");
    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Du doit être proche de ce joueur.");
    if (!PlayerData[userid][pCuffed])
        return SendErrorMessage(playerid, "Ce joueur n'est pas menotté en se moment.");
	if (Inventory_Items(playerid) >= MAX_INVENTORY - 1)
	    return SendErrorMessage(playerid, "Vous ne pouvez pas démenotter cette personne et prendre les menottes. (pas de paBTe dans l'inventaire)");
	static string[64];
    PlayerData[userid][pCuffed] = 0;
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
	format(string, sizeof(string), "Tu a ete ~g~demenotter~w~ par %s.", ReturnName(playerid, 0));
	Inventory_Add(playerid, "Menottes",19418, 1);
    ShowPlayerFooter(userid, string);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s démenotte %s et accroche ses menottes à sa ceinture a l'aide de ses deux mains.", ReturnName(playerid, 0), ReturnName(userid, 0));
    return 1;
}
CMD:trainer(playerid, params[])
{
	new userid;
    if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/trainer [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
    if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut traînée toi même.");
	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Du doit être proche de ce joueur.");
    if (!PlayerData[userid][pCuffed] && !PlayerData[userid][pStunned])
        return SendErrorMessage(playerid, "Ce joueur n'est pas menotter ou assomer.");
	if (PlayerData[userid][pDragged])
	{
	    PlayerData[userid][pDragged] = 0;
	    PlayerData[userid][pDraggedBy] = INVALID_PLAYER_ID;
	    KillTimer(PlayerData[userid][pDragTimer]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s lache %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	else
	{
	    PlayerData[userid][pDragged] = 1;
	    PlayerData[userid][pDraggedBy] = playerid;
	    PlayerData[userid][pDragTimer] = SetTimerEx("DragUpdate", 200, true, "dd", playerid, userid);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend %s et le traîne.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	return 1;
}
CMD:forcer(playerid, params[])
{
	new userid,vehicleid = GetNearestVehicle(playerid),facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/forcer [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté.");
    if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te forcer toi même.");
    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Du doit être proche de ce joueur.");
    if (!PlayerData[userid][pCuffed])
        return SendErrorMessage(playerid, "Ce joueur n'est pas menotter.");
	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "Tu n'est proche d'aucun véhicule..");
	if (GetVehicleMaxSeats(vehicleid) < 2)
  	    return SendErrorMessage(playerid, "Tu ne peut forcer ce joueur dans ce véhicule.");
	if (IsPlayerInVehicle(userid, vehicleid))
	{
		TogglePlayerControllable(userid, 1);
		RemoveFromVehicle(userid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ouvre la porte et sort %s du véhicule.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	else
	{
		new seatid = GetAvailableSeat(vehicleid, 2);
		if (seatid == -1)
		    return SendErrorMessage(playerid, "Il n'y a plus de sièges libre.");
		new string[64];
		format(string, sizeof(string), "Tu a ete ~r~forcer~w~ par %s.", ReturnName(playerid, 0));
		TogglePlayerControllable(userid, 0);
		StopDragging(userid);
		PutPlayerInVehicle(userid, vehicleid, seatid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ouvre la porte et mets %s dans le véhicule.", ReturnName(playerid, 0), ReturnName(userid, 0));
		ShowPlayerFooter(userid, string);
	}
	return 1;
}
CMD:creerarrest(playerid, params[])
{
	static id = -1,Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suparrest [point id]");
	if ((id < 0 || id >= MAX_ARREST_POINTS) || !ArrestData[id][arrestExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID d'arrestation invalide.");
	Arrest_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes arrest point (ID: %d.)", id);
	return 1;
}
CMD:mdc(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (!IsACruiser(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans une voiture de police.");
	Dialog_Show(playerid, MainMDC, DIALOG_STYLE_LIST, "Mobile Data Computer", "Activer la recherche\nPlace charges\nVoir charges\nVoir amandes d'une personne", "Valider", "Annuler");
	return 1;
}
CMD:arrest(playerid, params[])
{
	static userid,time;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "ud", userid, time))
	    return SendSyntaxMessage(playerid, "/arrest [playerid/name] [minutes]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur est déconnecté ou pas proche de toi.");
	if (time < 1 || time > 120)
	    return SendErrorMessage(playerid, "Le temps doit être entre 1 et max 120.");
	if (!PlayerData[userid][pCuffed])
	    return SendErrorMessage(playerid, "Le joueur doit être menotter pour cela.");
	if (!IsPlayerNearArrest(playerid))
	    return SendErrorMessage(playerid, "Vous devez être à la prison.");
	PlayerData[userid][pPrisoned] = 1;
	PlayerData[userid][pJailTime] = time * 60;
	StopDragging(userid);
	SetPlayerInPrison(userid);
	ResetWeapons(userid);
	ResetPlayer(userid);
	PlayerData[userid][pWarrants] = 0;
	PlayerData[userid][pCuffed] = 0;
	PlayerTextDrawShow(userid, PlayerData[userid][pTextdraws][70]);
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "[PRISON] %s a été emprisonné pour %d jours.", ReturnName(userid, 0), time);
    return 1;
}
CMD:seizeplant(playerid, params[])
{
	static plantid;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if ((plantid = Plant_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche d'une plante.");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s saisie la plante %s et peut voir %d de grammes.", ReturnName(playerid, 0), Plant_GetType(PlantData[plantid][plantType]), PlantData[plantid][plantDrugs]);
	Plant_Delete(plantid);
	return 1;
}
CMD:mort(playerid, params[])
{
	if (!PlayerData[playerid][pInjured])
	    return SendErrorMessage(playerid, "Tu n'est pas blessé ou mort.");
	SetPlayerHealth(playerid, 0.0);
	SendServerMessage(playerid, "Vous accepté votre mort..");
	GiveMoney(playerid, -500);
	new moneyentrepriseid;
	argent_entreprise[moneyentrepriseid][argentmedecin] +=500;
	moneyentreprisesave(moneyentrepriseid);
	return 1;
}
CMD:chargermalade(playerid, params[])
{
	static userid, seatid;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0)
	    return SendErrorMessage(playerid, "Tu doit être cher les urgentiste.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/chargermalade [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 10.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te chargé toi-même dans une ambulance.");
	if (!PlayerData[userid][pInjured])
	    return SendErrorMessage(playerid, "Ce joueur n'est pas blessé.");
	for (new i = 0; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i) && GetVehicleModel(i) == 416)
	{
	    seatid = GetAvailableSeat(i, 2);
	    if (seatid == -1)
	        return SendErrorMessage(playerid, "Il a plus de place dans l'amublance.");
		ClearAnimations(userid);
		PlayerData[userid][pInjured] = 2;
		PutPlayerInVehicle(userid, i, seatid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ouvre les portes de l'ambulance et charge %s dans l'ambulance.", ReturnName(playerid, 0), ReturnName(userid, 0));
		TogglePlayerControllable(userid, 0);
		SetPlayerHealth(userid, 100.0);
		return 1;
	}
	SendErrorMessage(playerid, "Du doit être proche du'une ambulance.");
	return 1;
}
CMD:dechargermalade(playerid, params[])
{
	static userid;
	new facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][5] == 0)
	    return SendErrorMessage(playerid, "Tu dois être dans la faction médical.");
    if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/dechargermalade [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerInVehicle(playerid, GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut deliver toi-même a l'hopital.");
	if (!PlayerData[userid][pInjured])
	    return SendErrorMessage(playerid, "Ce joueur n'est pas blessé.");
	for (new i = 0; i < sizeof(arrHospitalDeliver); i ++) if (IsPlayerInRangeOfPoint(playerid, 5.0, arrHospitalDeliver[i][0], arrHospitalDeliver[i][1], arrHospitalDeliver[i][2]))
	{
	    ClearAnimations(userid);
	    SetPlayerInterior(userid, 3);
	    SendServerMessage(playerid, "Vous avez ammener %s a un hopital.", ReturnName(userid, 0));
	    SetPlayerPosEx(userid, -204.5867, -1740.7955, 675.7687);
    	SetPlayerFacingAngle(userid, 0.0000);
		TogglePlayerControllable(userid, 1);
  		SetCameraBehindPlayer(userid);
		SetPlayerVirtualWorld(userid, i + 5000);
  		PlayerData[userid][pHospitalInt] = i;
	  	PlayerData[userid][pHospital] = -1;
    	PlayerData[userid][pHospitalTime] = 0;
    	SendServerMessage(userid, "Vous avez été soiné au plus proche hopital.");
  		ShowHungerTextdraw(userid, 1);
  		PlayerData[userid][pInjured] = 0;
		TextDrawHideForPlayer(userid, gServerTextdraws[2]);
		return 1;
	}
	SendErrorMessage(playerid, "Du doit être proche du point de déchargement des malades.");
	return 1;
}
CMD:m(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(m)egaphone [message]");
	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 50.0, COLOR_YELLOW, "[POLICE]: %.64s", params);
	    SendNearbyMessage(playerid, 50.0, COLOR_YELLOW, "...%s", params[64]);
	}
	else {SendNearbyMessage(playerid, 50.0, COLOR_YELLOW, "[POLICE]: %s",params);}
	return 1;
}
CMD:bandage(playerid, params[])
{
    static userid;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0)
	    return SendErrorMessage(playerid, "Tu doit faire partie de la faction des médecin.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/bandage [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne faire sa sur toi méme.");
	if (PlayerData[userid][pFirstAid])
	    return SendErrorMessage(playerid, "Ce joueur est déja entraine d'utiliser un bandage.");
    if (ReturnHealth(userid) > 99)
	    return SendErrorMessage(playerid, "Ce joueur n'est pas blessé.");
    PlayerData[userid][pFirstAid] = true;
    PlayerData[userid][pAidTimer] = SetTimerEx("FirstAidUpdate", 1000, true, "d", userid);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ouvre son kit de soins et soigne %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
    return 1;
}
CMD:diffuser(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][10] == 0)
		return SendErrorMessage(playerid, "Tu doit faire partie du san news.");
	if (!IsNewsVehicle(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "Vous devez être à l'intérieur du van sand news.");
	if (!PlayerData[playerid][pBroadcast])
	{
	    PlayerData[playerid][pBroadcast] = true;
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a commencé une séance.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Vous avez commencé une nouvelle émission ou diffusion (utiliser \"/bc [texte]\" pour diffuser).");
	}
	else
	{
	    PlayerData[playerid][pBroadcast] = false;
		foreach (new i : Player) if (PlayerData[i][pNewsGuest] == playerid) {
		    PlayerData[i][pNewsGuest] = INVALID_PLAYER_ID;
		}
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a fini une séance.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Vous avez stoppé votre séance.");
	}
	return 1;
}
CMD:bc(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][10] == 0)
		return SendErrorMessage(playerid, "Tu doit faire partie du san news.");
    if (isnull(params))
	    return SendSyntaxMessage(playerid, "/bc [broadcast text]");
	if (!IsNewsVehicle(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "Vous devez être à l'intérieur du van sand news ou de l'hélicoptère.");
	if (!PlayerData[playerid][pBroadcast])
	    return SendErrorMessage(playerid, "Tu doit être en séance pour utilisé cette commande.");
	if (strlen(params) > 64) {
	    foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "[NEWS] Reporteur %s: %.64s", ReturnName(playerid, 0), params);
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "...%s", params[64]);
		}
	}
	else {
        foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "[NEWS] Reporter %s: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}
CMD:inviterpersonne(playerid, params[])
{
	static userid;
	new facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][10] == 0)
		return SendErrorMessage(playerid, "Tu doit faire partie du sand news.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/inviterpersonne [playerid/nom]");
    if (!PlayerData[playerid][pBroadcast])
	    return SendErrorMessage(playerid, "Tu doit être en diffusion pour inviter une personne.");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
 	if (userid == playerid)
		return SendErrorMessage(playerid, "Tu ne peut t'inviter toi-même.");
	if (PlayerData[userid][pNewsGuest] == playerid)
	    return SendErrorMessage(playerid, "Ce joueur est déja invité dans votre séance");
	if (PlayerData[userid][pNewsGuest] != INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Ce joueur est déja dans une autre séance.");
	PlayerData[userid][pNewsGuest] = playerid;
	SendServerMessage(playerid, "Vous avez ajouté %s dans votre séance.", ReturnName(userid, 0));
	SendServerMessage(userid, "%s vous a ajouté dans sa séance en tanque invité.", ReturnName(userid, 0));
	return 1;
}
CMD:enleverpersonne(playerid, params[])
{
	static userid;
	new facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][10] == 0)
		return SendErrorMessage(playerid, "Vous devez faire partie du sand news.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/enleverpersonne [playerid/nom]");
    if (!PlayerData[playerid][pBroadcast])
	    return SendErrorMessage(playerid, "Vous devez être en diffusion.");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est pas la.");
 	if (userid == playerid)
		return SendErrorMessage(playerid, "Vous ne pouvez vous enlevez vous même.");
	if (PlayerData[userid][pNewsGuest] != playerid)
	    return SendErrorMessage(playerid, "Ce joueur n'est pas dans votre séance.");
	PlayerData[userid][pNewsGuest] = INVALID_PLAYER_ID;
	SendServerMessage(playerid, "Vous avez retirer %s de votre séance.", ReturnName(userid, 0));
	SendServerMessage(userid, "%s vous à éjecté de sa séance.", ReturnName(userid, 0));
	return 1;
}
CMD:payer(playerid, params[])
{
	static userid,amount;
	if (sscanf(params, "ud", userid, amount))
	    return SendSyntaxMessage(playerid, "/payer [playerid/name] [montant]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est pas la.");
	if (userid == playerid)
		return SendErrorMessage(playerid, "Vous ne pouvez vous donnez de l'argent a toi-même.");
	if (amount < 1)
	    return SendErrorMessage(playerid, "Minimun 1 dollar.");
	if (amount > 100 && PlayerData[playerid][pPlayingHours] < 5)
	    return SendErrorMessage(playerid, "Vous ne pouvez donnée plus de 100$ en moins de 5 heures de jeu.");
	if (amount > GetMoney(playerid))
	    return SendErrorMessage(playerid, "Vous n'avez pas assez sur vous..");
	static string[72];
	GiveMoney(playerid, -amount);
	GiveMoney(userid, amount);
	format(string, sizeof(string), "Vous avez recu ~g~%s~w~$ de %s.", FormatNumber(amount), ReturnName(playerid, 0));
	ShowPlayerFooter(userid, string);
	format(string, sizeof(string), "Vous avez donner ~r~%s~w~$ à %s.", FormatNumber(amount), ReturnName(userid, 0));
	ShowPlayerFooter(playerid, string);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend son portefeuille et sort %s$ et les donnes à %s.", ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
	Log_Write("logs/pay_log.txt", "[%s] %s (%s) has paid %s a %s (%s).", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], FormatNumber(amount), ReturnName(userid, 0), PlayerData[userid][pIP]);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a payer %s$ a %s.",ReturnName(playerid, 0),FormatNumber(amount), ReturnName(userid, 0));
	return 1;
}
CMD:factions(playerid, params[])
{
	ViewFactions(playerid);
	return 1;
}
CMD:dept(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/dept [department radio]");
	foreach (new i : Player)
	{
		new factionid = PlayerData[i][pFaction];
		if(FactionData[factionid][factionacces][1] == 0 || FactionData[factionid][factionacces][7] == 0 || FactionData[factionid][factionacces][3] == 0 || FactionData[factionid][factionacces][4] == 0 || FactionData[factionid][factionacces][5] == 0)
			return SendErrorMessage(playerid, "Tu doit être en dans une faction gourvernemental.");
		if(FactionData[factionid][factionacces][1] == 1 ||FactionData[factionid][factionacces][2] == 1 || FactionData[factionid][factionacces][3] == 1 || FactionData[factionid][factionacces][7] == 1 || FactionData[factionid][factionacces][5] == 1 || FactionData[factionid][factionacces][4] == 1)
		{
			SendFactionMessage(i, COLOR_DEPARTMENT, "[%s] %s %s: %s", GetInitials(Faction_GetName(playerid)), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
		}
		Log_Write("logs/faction_chat.txt", "[%s] [/dept] %s %s: %s", ReturnDate(), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:annonce(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
    if (isnull(params))
	    return SendSyntaxMessage(playerid, "/annonce [texte]");
	if (strlen(params) > 64) {
	    foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "[Annonce Policière] %s: %.64s", ReturnName(playerid, 0), params);
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "...%s", params[64]);
		}
	}
	else {
        foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "[Annonce Policière] %s: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}
CMD:gps(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Systeme GPS"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de gps.");
	if (PlayerData[playerid][pInjured] || PlayerData[playerid][pLoading] > 0 || PlayerData[playerid][pUnloading] != -1 || PlayerData[playerid][pDeliverShipment] > 0)
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	Dialog_Show(playerid, MainGPS, DIALOG_STYLE_LIST, "GPS Systeme", "Trouver une maison\nTrouver un magasin\nTrouver une Entrée\nTrouver un travail\nPersonalisé", "Valider", "Annuler");
	return 1;
}
CMD:jerrican(playerid, params[])
{
	new vehicleid = GetNearestVehicle(playerid);
	new idk = Car_GetID(vehicleid);
	if (IsPlayerInAnyVehicle(playerid) || vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche d'un véhicule.");
	if (!Inventory_HasItem(playerid, "Jerrican"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de jerrican sur vous.");
	if (GetEngineStatus(vehicleid))
	    return SendErrorMessage(playerid, "Il faut éteindre le moteur avant.");
	if (CarData[idk][carfuel] > 95)
	    return SendErrorMessage(playerid, "Ce véhicule ne manque pas d'essence.");
	if (PlayerData[playerid][pFuelCan])
	    return SendErrorMessage(playerid, "Vous utilisez déjàs un jerrican.");
    PlayerData[playerid][pFuelCan] = 1;
	Inventory_Remove(playerid, "Jerrican");
	TogglePlayerControllable(playerid,0);
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Remplissage...", 5200, 3);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ouvre son jerrican et remplie son véhicule.", ReturnName(playerid, 0));
	SetTimerEx("RefillUpdate", 5000, false, "dd", playerid, vehicleid);
	return 1;
}
CMD:pm(playerid, params[])
{
	static userid, text[128];
	new serveurinfo;
	if(info_serveursetting[serveurinfo][settingpmactive] == 1 && PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1) return SendErrorMessage(playerid,"Les PM est désactivé");
	if (sscanf(params, "us[128]", userid, text))
	    return SendSyntaxMessage(playerid, "/pm [playerid/name] [message]");
	if (PlayerData[playerid][pDisablePM])
		return SendErrorMessage(playerid, "Vous devez activé la réception de message privé.");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Vous ne pouvez vous envoyer un message privée à vous même.");
	if (PlayerData[userid][pDisablePM])
	    return SendErrorMessage(playerid, "Ce joueur a désactivé la réception de message privé.");
	GameTextForPlayer(userid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~Nouveau Message!", 3000, 3);
	PlayerPlaySound(userid, 1085, 0.0, 0.0, 0.0);
	SendClientMessageEx(userid, COLOR_YELLOW, "(( PM de %s (%d): %s ))", ReturnName(playerid, 0), playerid, text);
	SendClientMessageEx(playerid, COLOR_YELLOW, "(( PM a %s (%d): %s ))", ReturnName(userid, 0), userid, text);
	Log_Write("logs/pm_chat.txt", "[%s] [PM] DE %s a %s : %s ))",ReturnDate(),ReturnName(playerid, 0), ReturnName(userid, 0), text);
	return 1;
}
CMD:tog(playerid, params[])
{
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/tog [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} ooc, pm, faction, Helpeur, broadcast, hud");
	    return 1;
	}
	//new vehicleid = GetPlayerVehicleID(playerid);
	if (!strcmp(params, "ooc", true))
	{
	    if (!PlayerData[playerid][pDisableOOC])
	    {
	        PlayerData[playerid][pDisableOOC] = 1;
         	SendServerMessage(playerid, "Vous avez déactivé OOC chat (/tog pour le réactivé).");
		}
		else
		{
  			PlayerData[playerid][pDisableOOC] = 0;
  			SendServerMessage(playerid, "Vous avez activé OOC chat.");
		}
	}
	else if (!strcmp(params, "pm", true))
	{
	    if (!PlayerData[playerid][pDisablePM])
	    {
			PlayerData[playerid][pDisablePM] = 1;
   			SendServerMessage(playerid, "Vous avez déactivé message privées (/tog pour le réactivé).");
		}
		else
		{
  			PlayerData[playerid][pDisablePM] = 0;
     		SendServerMessage(playerid, "Vous avez activé message privées.");
		}
	}
	else if (!strcmp(params, "faction", true))
	{
	    if (PlayerData[playerid][pFaction] == -1)
	        return SendErrorMessage(playerid, "Tu ne fait pas partie d'aucun faction faction.");

	    if (!PlayerData[playerid][pDisableFaction])
	    {
	        PlayerData[playerid][pDisableFaction] = 1;
			SendServerMessage(playerid, "Vous avez déactivé faction chat (/tog pour le réactivé).");
		}
		else
		{
  			PlayerData[playerid][pDisableFaction] = 0;
     		SendServerMessage(playerid, "Vous avez activé faction chat.");
		}
	}
	else if (!strcmp(params, "Helpeur", true))
	{
	    if (!PlayerData[playerid][pTester])
	        return SendErrorMessage(playerid, "Vous n'êtes pas un helpeur");
	    if (!PlayerData[playerid][pDisableTester])
	    {
	        PlayerData[playerid][pDisableTester] = 1;
			SendServerMessage(playerid, "Vous avez déactivé le helpeur chat (/tog pour le réactivé).");
		}
		else
		{
  			PlayerData[playerid][pDisableTester] = 0;
     		SendServerMessage(playerid, "Vous avez activé le helpeur chat.");
		}
	}
	else if (!strcmp(params, "broadcast", true))
	{
	    if (!PlayerData[playerid][pDisableBC])
	    {
	        PlayerData[playerid][pDisableBC] = 1;
			SendServerMessage(playerid, "Vous avez déactivé les séances de diffusion (/tog pour le réactivé).");
		}
		else
		{
  			PlayerData[playerid][pDisableBC] = 0;
     		SendServerMessage(playerid, "Vous avez activé les séances de diffusion.");
		}
	}	
	else if (!strcmp(params, "hud",true))
	{
		if(PlayerData[playerid][pHUD] == 1)
		{
			ShowHungerTextdraw(playerid, 0);
			PlayerData[playerid][pHUD] = 0;
		}
		else 
		{
			PlayerData[playerid][pHUD] = 1;
			ShowHungerTextdraw(playerid, 1);
		}
	}
	return 1;
}
CMD:123(playerid, params[])
{
	new targetid;
	static string[MAX_PLAYER_TICKETS * 64];
	string[0] = 0;
	if(sscanf(params, "u", targetid)) SendSyntaxMessage(playerid, "{DEAD61}INFO: {FFFFFF}/123 <Prénom_Nom/ID>");
	for (new i = 0; i < MAX_PLAYER_TICKETS; i ++)
	{
	    if (TicketData[targetid][i][ticketExists])
	        format(string, sizeof(string), "%s%s (%s - %s)\n", string, TicketData[targetid][i][ticketReason], FormatNumber(TicketData[targetid][i][ticketFee]), TicketData[targetid][i][ticketDate]);
		else format(string, sizeof(string), "%s Vide\n", string);
	}
	return Dialog_Show(playerid, 123mm, DIALOG_STYLE_LIST, "Les amendes", string, "X", "");
}
CMD:amende(playerid, params[])
{
	static userid,price,reason[64];
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "uds[64]", userid, price, reason))
		return SendSyntaxMessage(playerid, "/amende [Joueur ID/Nom] [prix] [raison]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Vous ne pouvez pas vous donnez une amende.");
	if (price < 1 || price > 10000)
	    return SendErrorMessage(playerid, "Minimum $1 et max $10,000.");
	new id = Ticket_Add(userid, price, reason);
	if (id != -1) {
	    SendServerMessage(playerid, "Vous avez donner une amende à %s pour le prix %s$, raison: %s", ReturnName(userid, 0), FormatNumber(price), reason);
	    SendServerMessage(userid, "%s vous donnez une amende avec le prix a payer %s$, raison: %s ", ReturnName(playerid, 0), FormatNumber(price), reason);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s donne une amende à %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	    Log_Write("logs/ticket_log.txt", "[%s] %s a written a %s ticket a %s, raison: %s", ReturnDate(), ReturnName(playerid, 0), FormatNumber(price), ReturnName(userid, 0), reason);
	}
	else {SendErrorMessage(playerid, "Ce joueur a déjà %d amendes à payer.", MAX_PLAYER_TICKETS);}
	return 1;
}
CMD:amendes(playerid, params[])
{
	static string[MAX_PLAYER_TICKETS * 64];
	string[0] = 0;
	for (new i = 0; i < MAX_PLAYER_TICKETS; i ++)
	{
	    if (TicketData[playerid][i][ticketExists])
	        format(string, sizeof(string), "%s%s (%s - %s)\n", string, TicketData[playerid][i][ticketReason], FormatNumber(TicketData[playerid][i][ticketFee]), TicketData[playerid][i][ticketDate]);
		else format(string, sizeof(string), "%s Vide\n", string);
	}
	return Dialog_Show(playerid, MyTickets, DIALOG_STYLE_LIST, "Mes amendes", string, "Payer", "Annuler");
}
CMD:gouvretirer(playerid, params[])
{
	static amount;
	new moneyentrepriseid,factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
	if (sscanf(params, "d", amount))
		return SendSyntaxMessage(playerid, "/gouvretirer [montant] (%s valide)", FormatNumber(argent_entreprise[moneyentrepriseid][argentmairie]));
	if (!IsPlayerInCityHall(playerid))
	    return SendErrorMessage(playerid, "Vous devez être a l'intérieur de la mairie pour faire cela.");
	if (amount < 1 || amount > argent_entreprise[moneyentrepriseid][argentmairie])
	    return SendErrorMessage(playerid, "Montant non valide.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Vous devez être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Tax_AddMoney(-amount);
	GiveMoney(playerid, amount);
	moneyentreprisesave(moneyentrepriseid);
	SendServerMessage(playerid, "Vous avez retiré %s de la trésorerie (%s valide).", FormatNumber(amount), FormatNumber(argent_entreprise[moneyentrepriseid][argentmairie]));
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a retiré %s de la trésorerie.", ReturnName(playerid, 0), FormatNumber(amount));
	Log_Write("logs/tax_vault.txt", "[%s] %s a retiré %s de la trésorerie.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount));
	return 1;
}
CMD:gouvdeposer(playerid, params[])
{
	static amount;
	new moneyentrepriseid,factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas du gouvernement.");
	if (sscanf(params, "d", amount))
		return SendSyntaxMessage(playerid, "/gouvdeposer [montant] (%s valide)", FormatNumber(argent_entreprise[moneyentrepriseid][argentmairie]));
    if (!IsPlayerInCityHall(playerid))
	    return SendErrorMessage(playerid, "Vous devez être a l'intérieur de la mairie pour faire cela.");
	if (amount < 1 || amount > GetMoney(playerid))
	    return SendErrorMessage(playerid, "Montant non valide.");
	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Vous devez être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Tax_AddMoney(amount);
	GiveMoney(playerid, -amount);
	moneyentreprisesave(moneyentrepriseid);
	SendServerMessage(playerid, "Vous avez déposé %s dans la trésorerie (%s valide).", FormatNumber(amount), FormatNumber(argent_entreprise[moneyentrepriseid][argentmairie]));
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a déposé %s dans la trésorerie.", ReturnName(playerid, 0), FormatNumber(amount));
	Log_Write("logs/tax_vault.txt", "[%s] %s a déposé %s dans la trésorerie.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount));
	return 1;
}
CMD:herse(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/herse [option]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[OPTIONS]:{FFFFFF} poser, enlever, detruire");
		return 1;
	}
	static Float:fX,Float:fY,Float:fZ,Float:fA;
    GetPlayerPos(playerid, fX, fY, fZ);
    GetPlayerFacingAngle(playerid, fA);
	if (!strcmp(params, "poser", true))
	{
	    if (IsPlayerInAnyVehicle(playerid))
	        return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
	    for (new i = 0; i != MAX_BARRICADES; i ++) if (!BarricadeData[i][cadeExists])
	    {
            BarricadeData[i][cadeExists] = true;
            BarricadeData[i][cadeType] = 1;
            BarricadeData[i][cadePos][0] = fX;
            BarricadeData[i][cadePos][1] = fY;
            BarricadeData[i][cadePos][2] = fZ;
            BarricadeData[i][cadeObject] = CreateDynamicObject(2899, fX, fY, fZ - 0.8, 0.0, 0.0, fA + 90.0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a placé une herse a l'aide de ses deux mains.", ReturnName(playerid, 0));
			SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s à poser une herse à %s.", ReturnName(playerid, 0), GetLocation(fX, fY, fZ));
			return 1;
		}
		SendErrorMessage(playerid, "MAX LIMITES spikestrips.");
	}
	else if (!strcmp(params, "enlever", true))
	{
        for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, BarricadeData[i][cadePos][0], BarricadeData[i][cadePos][1], BarricadeData[i][cadePos][2]))
	    {
            BarricadeData[i][cadeExists] = 0;
            BarricadeData[i][cadeType] = 0;
            DestroyDynamicObject(BarricadeData[i][cadeObject]);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s récupère la herse a l'aide de ses deux mains.", ReturnName(playerid, 0));
			SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s à enlever une herse à %s.", ReturnName(playerid, 0), GetLocation(fX, fY, fZ));
			return 1;
		}
		SendErrorMessage(playerid, "Vous n'êtes pas proche d'une herse.");
	}
	else if (!strcmp(params, "detruire", true))
	{
        for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 1)
	    {
            BarricadeData[i][cadeExists] = 0;
            BarricadeData[i][cadeType] = 0;
			DestroyDynamicObject(BarricadeData[i][cadeObject]);
		}
		SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s à détruit toute les herses.", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:changename(playerid, params[])
{
	Dialog_Show(playerid, ChangeName, DIALOG_STYLE_INPUT, "Changer votre Nom en jeux", "Entrer votre nouveau nom IG", "Valider", "Annuler");
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
    if (PlayerData[playerid][pAdmin] < 4)
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
CMD:sonner(playerid, params[])
{
	new id = House_Nearest(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "Tu doit être proche d'une maison.");
	foreach (new i : Player) if (House_Inside(i) == id) {
	    SendClientMessage(i, COLOR_PURPLE, "** Vous entender sonner a la porte.");
	    PlayerPlaySound(i, 20801, 0, 0, 0);
	}
	PlayerPlaySoundEx(playerid, 20801);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sonne a une porte.", ReturnName(playerid, 0));
	return 1;
}
CMD:creergate(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editgate [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, speed, radius, time, model, pos, move, pass, linkid, faction");
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
CMD:creerbatiement(playerid, params[])
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
CMD:supbatiement(playerid, params[])
{
	static id = 0;
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suppbatiement [batiement id]");
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un object invalide.");
	batiement_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes l'object(ID: %d.)", id);
	return 1;
}
CMD:editbatiement(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbatiement [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, model, pos");
		return 1;
	}
	if ((id < 0 || id >= MAX_batiementS) || !batiementData[id][batiementExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier une porte invalide.");
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
CMD:udrogue(playerid, params[])
{
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/udrugue [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} marijuana, cocaine, heroin, steroids");
		return 1;
	}
	if (PlayerData[playerid][pDrugTime] > 0)
	    return SendErrorMessage(playerid, "Attendre que les effets se dissipe.");
	if (!strcmp(params, "marijuana", true))
	{
	    if (Inventory_Count(playerid, "Marijuana") < 2)
	        return SendErrorMessage(playerid, "Tu a besoin de 2 grams of marijuana.");
		if (!Inventory_HasItem(playerid, "briquet"))
		return SendErrorMessage(playerid, "Vous n'avez pas de briquet.");
        PlayerData[playerid][pDrugTime] = 20;
		PlayerData[playerid][pDrugUsed] = 1;
		Inventory_Remove(playerid, "Marijuana", 2);
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
		Inventory_Remove(playerid, "briquet",1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un briquet de sa poche, se roule un joint et l'allume.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "cocaine", true))
	{
	    if (Inventory_Count(playerid, "Cocaine") < 2)
	        return SendErrorMessage(playerid, "Tu a besoin de 2 grammes de cocaines.");
        PlayerData[playerid][pDrugTime] = 35;
		PlayerData[playerid][pDrugUsed] = 2;
		Inventory_Remove(playerid, "Cocaine", 2);
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une certaine dose de cocaine de sa poche, se prépare une ligne de cocaine et la snif.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "heroin", true))
	{
	    if (Inventory_Count(playerid, "Heroin") < 2)
	        return SendErrorMessage(playerid, "Tu a besoin de 2 grammes d'héroines.");
        PlayerData[playerid][pDrugTime] = 30;
		PlayerData[playerid][pDrugUsed] = 3;
		Inventory_Remove(playerid, "Heroin", 2);
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une certaine dose d'héroine de sa poche et se l'injecte a l'aide d'une seringue.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "steroids", true))
	{
	    if (!Inventory_HasItem(playerid, "Steroids"))
	        return SendErrorMessage(playerid, "Tu a besoin de one steroid pill.");
		if (ReturnHealth(playerid) <= 5)
		    return SendErrorMessage(playerid, "Votre vie est trop basse pour prendre des stéroides.");
        PlayerData[playerid][pDrugTime] = 60;
		PlayerData[playerid][pDrugUsed] = 4;
		SetPlayerHealth(playerid, ReturnHealth(playerid) - 5);
		Inventory_Remove(playerid, "Steroids", 2);
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend une dose de stéroides et les avales.", ReturnName(playerid, 0));
	}
	return 1;
}
CMD:analyser(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (PlayerData[playerid][pFingerTime] > 0)
	    return SendErrorMessage(playerid, "Tu utilise déja le scanner d'empreinte digitale.");
    for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2])) {
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s utilise le scanner d'empreinte digitale.", ReturnName(playerid, 0));
        PlayerData[playerid][pFingerTime] = 3;
        PlayerData[playerid][pFingerItem] = i;
        return 1;
	}
	SendErrorMessage(playerid, "Aucun objet proche.");
	return 1;
}
CMD:creercar(playerid, params[])
{
	static model[32],color1,color2,id = -1,type = 0,loca = 0;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
    /*if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Vous devez êtres le conducteur.");*/
	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{id = GetPlayerVehicleID(playerid);}
		else return SendSyntaxMessage(playerid, "/supcar");
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
CMD:sacados(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Backpack"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de backpack sur toi.");
	Backpack_Open(playerid);
	return 1;
}
/*CMD:dropbackpack(playerid, params[])
{
	new id = GetPlayerBackpack(playerid);
	if (!Inventory_HasItem(playerid, "Backpack") || id == -1)
	    return SendErrorMessage(playerid, "Vous n'avez pas de backpack sur toi.");
	if (!Backpack_GetItems(id))
	    return SendErrorMessage(playerid, "Tu ne peut drop un backpack vide.");
    if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid))
    	return SendErrorMessage(playerid, "Tu ne peut drop votre backpack maintenant.");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
	BackpackData[id][backpackPlayer] = 0;
    BackpackData[id][backpackPos][0] = x;
    BackpackData[id][backpackPos][1] = y;
    BackpackData[id][backpackPos][2] = z;
    BackpackData[id][backpackInterior] = GetPlayerInterior(playerid);
    BackpackData[id][backpackWorld] = GetPlayerVirtualWorld(playerid);
	Backpack_Refresh(id);
	Backpack_Save(id);
	Inventory_Remove(playerid, "Backpack");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a jeté son backpack.", ReturnName(playerid, 0));
	SetAccessories(playerid);
	return 1;
}*/
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
	static string[2000];
	if (!strlen(string)) {
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) {
			format(string, sizeof(string), "%s%s\n", string, g_aInventoryItems[i][e_InventoryItem]);
		}
	}
	return Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, "List of Items", string, "Valider", "Annuler");
}
CMD:creerimpound(playerid, params[])
{
	static id = -1,Float:x,Float:y,Float:z;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editimpound [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, release");
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
CMD:vfourriere(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 438.3406,129.9807,1008.3976))
	    return SendErrorMessage(playerid, "Vous devez être dans les bureau de la fourrière pour faire cela.");
	new string[32 * MAX_OWNABLE_SOMETHING],count;
	for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (count < MAX_OWNABLE_SOMETHING && CarData[i][carExists] && Car_IsOwner(playerid, i) && CarData[i][carImpounded] != -1)
	{
		format(string, sizeof(string), "%s%d: %s (%s)\n", string, count + 1, ReturnVehicleName(CarData[i][carVehicle]), FormatNumber(CarData[i][carImpoundPrice]));
        ListedVehicles[playerid][count++] = i;
	}
	if (!count)
	    SendErrorMessage(playerid, "Vous n'avez pas de vehicules a la fourrièrre.");
	else Dialog_Show(playerid, ReleaseCar, DIALOG_STYLE_LIST, "Véhicule en fourrière", string, "Valider", "Annuler");
	return 1;
}
CMD:remorquer(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][9] == 0)
		return SendErrorMessage(playerid, "Vous n'êtes pas des mécano");
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans une dépanneuse.");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Vous n'êtes pas le chauffeur.");
	new vehicleid = GetVehicleFromBehind(GetPlayerVehicleID(playerid));
	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "Ce vehicle n'est pas proche.");
	if (/*!IsDoorVehicle(vehicleid) ||*/ IsAPlane(vehicleid) || IsABoat(vehicleid) || IsAHelicopter(vehicleid))
	    return SendErrorMessage(playerid, "Vous ne pouvez remorquer ce véhicule.");
	AttachTrailerToVehicle(vehicleid, GetPlayerVehicleID(playerid));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à remorquer le véhicule %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
	return 1;
}
CMD:untow(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][9] == 0)
		return SendErrorMessage(playerid, "Vous n'êtes pas des mécano");
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	    return SendErrorMessage(playerid, "Tu ne conduit pas un towtruck.");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Tu ne conduit pas.");
	new trailerid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
    if (!trailerid)
	    return SendErrorMessage(playerid, "Il n'a aucun vehicule de prit.");
	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a déattaché le véhicule %s.", ReturnName(playerid, 0), ReturnVehicleName(trailerid));
	return 1;
}
CMD:fourriere(playerid, params[])
{
	new price,id = Impound_Nearest(playerid),vehicleid = GetPlayerVehicleID(playerid),facass = PlayerData[playerid][pFaction];
    if (FactionData[facass][factionacces][9] == 0)
		return SendErrorMessage(playerid, "Vous n'êtes pas des mécano");
    if (sscanf(params, "d", price))
        return SendSyntaxMessage(playerid, "/fourriere [prix]");
	if (price < 1 || price > 1000)
	    return SendErrorMessage(playerid, "Le prix ne peut pas être au-dessus 1$ et au dessus de 1000$.");
	if (GetVehicleModel(vehicleid) != 525)
	    return SendErrorMessage(playerid, "Vous ne conduisez pas une dépanneuse.");
	if (id == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	if (!GetVehicleTrailer(vehicleid))
	    return SendErrorMessage(playerid, "Il n'y à aucun véhicule accroché.");
 	vehicleid = Car_GetID(GetVehicleTrailer(vehicleid));
	if (vehicleid == -1)
	    return SendErrorMessage(playerid, "Vous ne pouvez remorquer ce véhicule.");
	if (CarData[vehicleid][carImpounded] != -1)
	    return SendErrorMessage(playerid, "ce véhicule est déja en fourriére.");
	CarData[vehicleid][carImpounded] = ImpoundData[id][impoundID];
	CarData[vehicleid][carImpoundPrice] = price;
	Tax_AddMoney(price);
	GetVehiclePos(CarData[vehicleid][carVehicle], CarData[vehicleid][carPos][0], CarData[vehicleid][carPos][1], CarData[vehicleid][carPos][2]);
	Car_Save(vehicleid);
	SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s a mit en fourriere %s pour %s$.", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[vehicleid][carModel]), FormatNumber(price));
 	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	return 1;
}
CMD:channel(playerid, params[])
{
	new channel;
	if (!Inventory_HasItem(playerid, "Talkie-Walkie"))
	    return SendErrorMessage(playerid, "Tu doit avoir un(e) radio portable.");
	if (sscanf(params, "d", channel))
 	{
	 	SendSyntaxMessage(playerid, "/channel [radio channel] (0 pour faire annuler)");
	 	if (PlayerData[playerid][pChannel] > 0)
			SendClientMessageEx(playerid, COLOR_YELLOW, "[NOTE]:{FFFFFF} votre cannaux est %d.", PlayerData[playerid][pChannel]);
		return 1;
	}
	if (channel < 0 || channel > 999999)
	    return SendErrorMessage(playerid, "Le cannal est minimum 0 et max 999,999.");
	PlayerData[playerid][pChannel] = channel;
	if (channel == 0)
	    SendServerMessage(playerid, "Vous avez désactivé votre radio portable.");
	else SendServerMessage(playerid, "Vous avez régler votre radio au canal %d (/r [texte])", channel);
	return 1;
}
CMD:r(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/r [Radio IC]");
    if (!Inventory_HasItem(playerid, "Talkie-Walkie"))
	    return SendErrorMessage(playerid, "Vous devez avoir une radio portable.");
	if(PlayerData[playerid][pChannel] == 911 && FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Ceci est la fréquence de département de la police seulement.");
	if (!PlayerData[playerid][pChannel])
	    return SendErrorMessage(playerid, "Votre radio n'est pas configurée (/channel).");
	static string[128];
	if (strlen(params) > 64)
	{
		format(string, sizeof(string), "** [RADIO: %d] %s: %.64s",PlayerData[playerid][pChannel],ReturnName(playerid, 0), params);
		SendRadioMessage(PlayerData[playerid][pChannel], COLOR_SERVER, string);
		format(string, sizeof(string), "...%s **",params[64]);
		SendRadioMessage(PlayerData[playerid][pChannel], COLOR_SERVER, string);
		SendNearbyMessage(playerid, 5.0, COLOR_PURPLE, "** (Parle dans sa radio) %s: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 5.0, COLOR_PURPLE, "...%s **", params[64]);
	}
	else {
		format(string, sizeof(string),"** [RADIO: %d] %s: %s **", PlayerData[playerid][pChannel],ReturnName(playerid, 0), params);
		SendRadioMessage(PlayerData[playerid][pChannel], COLOR_SERVER, string);
		SendNearbyMessage(playerid, 5.0, COLOR_PURPLE, "** (Parle dans sa radio) %s: %s", ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:jobcmds(playerid, params[])
{
	switch (PlayerData[playerid][pJob])
	{
		case 2: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
	    case 3: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /mine.");
		case 4: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /trier.");
	    case 6: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /commencermeuble, /quittermeuble.");
		case 7: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
		case 8: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
		case 9: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /commencerboucher, /quitterboucher.");
		case 10: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /gason, /gasoff.");
	    case 11: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
	    case 12: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
		case 13: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
	    case 14: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} Aucune commande tout se fait sur place.");
	    default: SendErrorMessage(playerid, "Vous n'avez pas de job en se moment.");
	}
	return 1;
}
CMD:creeratm(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = ATM_Create(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
	SendServerMessage(playerid, "Créer avec succès ATM (ID: %d.)", id);
	return 1;
}
CMD:supatm(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supatm [atm id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !ATMData[id][atmExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID ATM invalide.");
	ATM_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes ATM (ID: %d.)", id);
	return 1;
}
CMD:enlevercp(playerid, params[])
{
	if (PlayerData[playerid][pDrivingTest])
	    return SendErrorMessage(playerid, "Tu ne peut enlever le point du test.");
	new vehicleid = GetPlayerVehicleID(playerid);
	PlayerData[playerid][pCP] = 0;
	if (PlayerData[playerid][pSorting] != -1)
	{
	    PlayerData[playerid][pSorting] = -1;
		PlayerData[playerid][pSortCrate] = 0;
		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (PlayerData[playerid][pMinedRock])
	{
	    PlayerData[playerid][pMinedRock] = 0;
		PlayerData[playerid][pMineCount] = 0;
		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (PlayerData[playerid][pPetrolRock])
	{
	    PlayerData[playerid][pPetrolRock] = 0;
		PlayerData[playerid][pPetrolCount] = 0;
		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (PlayerData[playerid][pWoodRock])
	{
	    PlayerData[playerid][pWoodRock] = 0;
		PlayerData[playerid][pWoodCount] = 0;
		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (PlayerData[playerid][pUnloading] != -1)
	{
	    PlayerData[playerid][pUnloading] = -1;
	    PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;
	}
	if (PlayerData[playerid][pLoading])
	{
	    PlayerData[playerid][pLoading] = 0;
	    PlayerData[playerid][pLoadType] = 0;
	}
	if (PlayerData[playerid][pLoadCrate])
 	{
  		PlayerData[playerid][pLoadCrate] = 0;
		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (IsPlayerInWarehouse(playerid) && GetVehicleModel(vehicleid) == 530 && CoreVehicles[vehicleid][vehLoadType] == 7)
	{
 		CoreVehicles[vehicleid][vehLoadType] = 0;
 		CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
   		DestroyObject(CoreVehicles[vehicleid][vehCrate]);
	}
    DisablePlayerCheckpoint(playerid);
    SendServerMessage(playerid, "Vous avez déactivé le checkpoints.");
    return 1;
}
CMD:restart(playerid, params[])
{
	new time;
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (g_ServerRestart)
	{
	    TextDrawHideForAll(gServerTextdraws[3]);
	    g_ServerRestart = 0;
	    g_RestartTime = 0;
	    return SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a commencé un restart serveur.", ReturnName(playerid, 0));
	}
	if (sscanf(params, "d", time))
	    return SendSyntaxMessage(playerid, "/restart [seconds]");
	if (time < 2 || time > 120)
	    return SendErrorMessage(playerid, "Minimum 2 et max 120.");
    TextDrawShowForAll(gServerTextdraws[3]);
	g_ServerRestart = 1;
	g_RestartTime = time;
	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a commencer un restart et sera effectué a %d seconds.", ReturnName(playerid, 0), time);
	//cmd_saveall(playerid, "");
	return 1;
}
CMD:proprieter(playerid, params[])
{
	new count;
	for (new i = 0; i < MAX_HOUSES; i ++) if (House_IsOwner(playerid, i) && HouseData[i][houseOwner] != 0) {
	    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "** Maison ID: %d | Addresse: %s | Position: %s", i, HouseData[i][houseAddress], GetLocation(HouseData[i][housePos][0], HouseData[i][housePos][1], HouseData[i][housePos][2]));
	    count++;
	}
	for (new i = 0; i < MAX_BUSINESSES; i ++) if (Business_IsOwner(playerid, i) && BusinessData[i][bizOwner] != 99999999) {
	    SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Magasin ID: %d | Nom: %s | Position: %s", i, BusinessData[i][bizName], GetLocation(BusinessData[i][bizPos][0], BusinessData[i][bizPos][1], BusinessData[i][bizPos][2]));
	    count++;
	}
	for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (Car_IsOwner(playerid, i) && CarData[i][carOwner] != 0) {
	    SendClientMessageEx(playerid, COLOR_YELLOW, "** Vehicule ID: %d | Modele: %s | Position: %s", CarData[i][carVehicle], ReturnVehicleModelName(CarData[i][carModel]), GetLocation(CarData[i][carPos][0], CarData[i][carPos][1], CarData[i][carPos][2]));
	    count++;
	}
	if (!count) return SendErrorMessage(playerid, "Vous ne possédez pas de propriétés.");
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
CMD:donnerlicense(playerid, params[])
{
	new userid,moneyentrepriseid,facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/donnerlicense [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te donner une license d'arme.");
	if (GetMoney(userid) < 15000)
	    return SendErrorMessage(playerid, "Le joueur n.a pas asser d'argent (15000$)");
	if (Inventory_HasItem(userid, "License arme"))
	    return SendErrorMessage(playerid, "Ce joueur a déjà une License d'arme.");
	Inventory_Add(userid, "License arme", 19792);
	GiveMoney(userid,-15000);
	argent_entreprise[moneyentrepriseid][argentpolice] += 15000;
	moneyentreprisesave(moneyentrepriseid);
	SendServerMessage(playerid, "Vous avez donner une license d'arme à %s.", ReturnName(userid, 0));
	SendServerMessage(userid, "Tu à reçu une license d'arme par %s.", ReturnName(playerid, 0));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à donner à %s une license d'arme.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}
CMD:enleverlicense(playerid, params[])
{
    new userid,facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/enleverlicense [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut t'enlever ta license d'arme.");
	if (!Inventory_HasItem(userid, "License arme"))
	    return SendErrorMessage(playerid, "Ce joueur n'a pas de license d'arme.");
	Inventory_Remove(userid, "License arme");
	SendServerMessage(playerid, "Vous avez enlever à %s sa license d'arme.", ReturnName(userid, 0));
	SendServerMessage(userid, "Votre license d'arme à été enlever par %s.", ReturnName(playerid, 0));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à enlevé à %s sa license d'arme.", ReturnName(playerid, 0), ReturnName(userid, 0));
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
    if (PlayerData[playerid][pAdmin] < 4)
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
	    return SendErrorMessage(playerid, "Le montant ne peut être plus bas que 3000.0");
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
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editcar [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, faction, color1, color2, reset, carowner,four");
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
	return 1;
}
CMD:creergarbage(playerid, params[])
{
	static id = -1,type;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creergarbage [type]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Dumpster | 2: Trash Can| 3: Poubelle interieur");
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supgarbage [garbage id]");
	if ((id < 0 || id >= MAX_DYNAMIC_TRASH) || !GarbageData[id][garbageExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID poubelle invalide.");
	Garbage_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes garbage bin (ID: %d.)", id);
	return 1;
}
CMD:prendrepoubelle(playerid, params[])
{
	new id = Garbage_Nearest(playerid),string[64],factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (id == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	if (GarbageData[id][garbageCapacity] < 1)
	    return SendErrorMessage(playerid, "cette poubelle est vide.");
	if (PlayerData[playerid][pCarryTrash])
	    return SendErrorMessage(playerid, "Tu est déja entrain de transporté déja une poubelle");
    GarbageData[id][garbageCapacity]--;
   	Garbage_Save(id);
	PlayerData[playerid][pCarryTrash] = 1;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une sac de poubelle de la poubelle.", ReturnName(playerid, 0), string);
	format(string, sizeof(string), "[Poubelle %d]\n{FFFFFF}Capacité: %d/20", id, GarbageData[id][garbageCapacity]);
  	UpdateDynamic3DTextLabelText(GarbageData[id][garbageText3D], COLOR_DARKBLUE, string);
  	SetPlayerAttachedObject(playerid, 4, 1264, 6, 0.000000, 0.000000, 0.000000, 0.000000, 270.000000, 90.000000, 0.500000, 0.500000, 0.500000);
	ShowPlayerFooter(playerid, "Appuyer ~y~'N'~w~ pour charger la poubelle.");
	return 1;
}
CMD:viderpoubelle(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid),id = Job_NearestPoint(playerid, 5.0),factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (GetVehicleModel(vehicleid) != 408)
	    return SendErrorMessage(playerid, "Tu doit conduire un camion poubelle.");
	if (id == -1 || JobData[id][jobType] != JOB_GARBAGE)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	if (CoreVehicles[vehicleid][vehTrash] < 1)
	    return SendErrorMessage(playerid, "Aucune poubelle dans ce véhicule.");
	//GiveMoney(playerid, (CoreVehicles[vehicleid][vehTrash] * 25));
	new moneyentrepriseid;
	argent_entreprise[moneyentrepriseid][argentmairie] += CoreVehicles[vehicleid][vehTrash] * 25;
	moneyentreprisesave(moneyentrepriseid);
	ShowPlayerFooter(playerid, "Vous avez ~g~videz~w~ les poubelles!");
	SendServerMessage(playerid, "Vous avez fait gagné %d$  à l'entreprise, pour avoir vidé les %d sacs de poubelles.", (CoreVehicles[vehicleid][vehTrash] * 15), CoreVehicles[vehicleid][vehTrash]);
	CoreVehicles[vehicleid][vehTrash] = 0;
	return 1;
}
CMD:creervendor(playerid, params[])
{
	static
	    id = -1,
		type;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creervendor [type]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Food | 2: Soda");
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supvendor [vendor id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !VendorData[id][vendorExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID vendeur invalide.");
	Vendor_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes vendor (ID: %d.)", id);
	return 1;
}
CMD:animcmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /dance, /handsup, /bat, /slap, /bar, /wash, /lay, /workout, /blowjob, /bomb.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /carry, /crack, /sleep, /jump, /deal, /dancing, /eating, /puke, /gsign, /chat.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /goggles, /spray, /throw, /swipe, /office, /kiss, /knife, /cpr, /scratch, /point.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /cheer, /wave, /strip, /smoke, /reload, /taichi, /wank, /cower, /skate, /drunk.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /cry, /tired, /assis, /crossarms, /fucku, /walk, /piss, /lean, /stopanim.");
	return 1;
}
CMD:dance(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/dance [1-4]");
	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
	    case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
	    case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
	    case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	}
	return 1;
}
CMD:handsup(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}
CMD:piss(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}
CMD:bat(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/bat [1-5]");
	if (type < 1 || type > 5)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 0, 1, 1, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BASEBALL", "Bat_2", 4.1, 0, 1, 1, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BASEBALL", "Bat_3", 4.1, 0, 1, 1, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:slap(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:bar(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/bar [1-8]");
	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BAR", "Barserve_in", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "BAR", "Barserve_order", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "BAR", "BARman_idle", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:wash(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:lay(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/lay [1-5]");
	if (type < 1 || type > 5)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:workout(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/workout [1-7]");
	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0, 1);
	    case 3: ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_A", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_B", 4.1, 0, 0, 0, 1, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:blowjob(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/blowjob [1-4]");
	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:bomb(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:carry(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/carry [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:crack(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/crack [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:sleep(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/sleep [1-2]");
	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:jump(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}
CMD:deal(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/deal [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:dancing(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/dancing [1-10]");
	if (type < 1 || type > 10)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
	    case 9: ApplyAnimationEx(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
	    case 10: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:eating(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/eating [1-3]");
	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:puke(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");

	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:gsign(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/gsign [1-15]");
	if (type < 1 || type > 15)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 10: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 11: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 12: ApplyAnimation(playerid, "GANGS", "Invite_No", 4.1, 0, 0, 0, 0, 0, 1);
		case 13: ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 0, 0, 1);
		case 14: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.1, 0, 0, 0, 0, 0, 1);
		case 15: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:chat(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/chat [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:goggles(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:spray(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
 	ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:throw(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:swipe(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:office(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/office [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Drink", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Watch", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:kiss(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/kiss [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:knife(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/knife [1-8]");
	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "KNIFE", "knife_1", 4.1, 0, 1, 1, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KNIFE", "knife_2", 4.1, 0, 1, 1, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KNIFE", "knife_4", 4.1, 0, 1, 1, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "KNIFE", "WEAPON_knifeidle", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Player", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Damage", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:cpr(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:scratch(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/scratch [1-4]");
	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
    	case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:point(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/point [1-4]");
	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
    	case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:cheer(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/cheer [1-8]");
	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:strip(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/strip [1-7]");
	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "STRIP", "strip_F", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:wave(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/wave [1-3]");
	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:smoke(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/smoke [1-3]");
	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:reload(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/reload [1-4]");
	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:taichi(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:wank(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/wank [1-3]");
	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:cower(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}
CMD:skate(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/skate [1-2]");
	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:drunk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}
CMD:cry(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}
CMD:tired(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/tired [1-2]");
	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:assis(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/assis [1-6]");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0);
		case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0);
		case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
		case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);
		case 6: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
	}
	return 1;
}
CMD:lean(playerid, params[])
{
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid,"GANGS","leanIDLE", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:crossarms(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/crossarms [1-4]");
	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
	}
	return 1;
}
CMD:fucku(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}
CMD:walk(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/walk [1-16]");
	if (type < 1 || type > 17)
	    return SendErrorMessage(playerid, "Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "FAT", "FatWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 2: ApplyAnimationEx(playerid, "MUSCULAR", "MuscleWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
	    case 9: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
	    case 10: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
	    case 11: ApplyAnimationEx(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:tunning(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans un véhicule.");
	if (!IsDoorVehicle(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "Tu ne peut tuné ce véhicule.");
	Dialog_Show(playerid, TuneVehicle, DIALOG_STYLE_LIST, "Tune Vehicule", "Changer roues\nAjouter hydrolique", "Valider", "Annuler");
	return 1;
}
CMD:colorcar(playerid, params[])
{
	static color1,color2;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans un vehicule.");
	if (!Inventory_HasItem(playerid, "Bombe de peinture"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de bombe de peinture.");
	if (sscanf(params, "dd", color1, color2))
	    return SendSyntaxMessage(playerid, "/colorcar [color 1] [color 2]");
	if (color1 < 0 || color1 > 255)
	    return SendErrorMessage(playerid, "Premiere couleur entre 0 et max 255.");
    if (color2 < 0 || color2 > 255)
	    return SendErrorMessage(playerid, "Seconde couleur entre 0 et max 255.");
	SetVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
	Inventory_Remove(playerid, "Bomb de peinture",1);
	SendVehiculeMessage(playerid, "Vous avez changé la couleurs de ce vehicule a %d, %d.", color1, color2);
	return 1;
}
CMD:paintjob(playerid, params[])
{
	static paintjobid;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans un vehicule.");
	if (!Inventory_HasItem(playerid, "Bombe de peinture"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de bombe de peinture.");
	if (sscanf(params, "d", paintjobid))
	    return SendSyntaxMessage(playerid, "/paintjob [paintjob ID] (-1 a disable)");
	if (paintjobid < -1 || paintjobid > 5)
	    return SendErrorMessage(playerid, "Le numéro du paintjob ne peut être -1 et max 5.");
	if (paintjobid == -1)
		paintjobid = 6;
	SetVehiclePaintjob(GetPlayerVehicleID(playerid), paintjobid);
	Inventory_Remove(playerid, "Bomb de peinture",1);
	SendVehiculeMessage(playerid, "Vous avez changé le paintjob de ce vehicule a %d.", paintjobid);
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
CMD:spawnitem(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/spawnitem [item name] (/itemlist for a list)");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], params, true))
	{
	    new id = DropItem(g_aInventoryItems[i][e_InventoryItem], "Admin", g_aInventoryItems[i][e_InventoryModel], 1, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	    if (id == -1)
	        return SendErrorMessage(playerid, "MAX LIMITE.");
        Log_Write("logs/spawnitem.txt", "[%s] %s a créer %s", ReturnDate(), ReturnName(playerid, 0), g_aInventoryItems[i][e_InventoryItem]);
		SendServerMessage(playerid, "Vous avez créer un(e) \"%s\" (écriver /setquantity a set the quantity).", g_aInventoryItems[i][e_InventoryItem]);
		return 1;
	}
    SendErrorMessage(playerid, "Nom invalide (use /itemlist for a list).");
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
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
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
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
    SendServerMessage(playerid, "Vous avez supprimé un(e) \"%s\".", DroppedItems[id][droppedItem]);
    Item_Delete(id);
    return 1;
}
CMD:boombox(playerid, params[])
{
	static
	    type[24],
	    string[128];
	if (!Inventory_HasItem(playerid, "Boombox"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de boombox sur toi.");
	if (sscanf(params, "s[24]S()[128]", type, string))
	{
	    SendSyntaxMessage(playerid, "/boombox [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} place, prendre, url");
	    return 1;
	}
	if (!strcmp(type, "place", true))
	{
	    if (BoomboxData[playerid][boomboxPlaced])
	        return SendErrorMessage(playerid, "Vous avez déja placer une boombox.");
		if (Boombox_Nearest(playerid) != INVALID_PLAYER_ID)
		    return SendErrorMessage(playerid, "Vous êtes dans la place d'une autre boombox.");
		if (IsPlayerInAnyVehicle(playerid))
		    return SendErrorMessage(playerid, "Vous devez êtres hors du véhicule.");
		Boombox_Place(playerid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une boombox et la pose au sol.", ReturnName(playerid, 0));
		SendServerMessage(playerid, "Vous avez déja placer votre boombox (Tapez \"/boombox\" pour plus d'options).");
	}
	else if (!strcmp(type, "prendre", true))
	{
	    if (!BoomboxData[playerid][boomboxPlaced])
	        return SendErrorMessage(playerid, "Vous n'avez pas de boombox déployer.");
		if (!IsPlayerInRangeOfPoint(playerid, 3.0, BoomboxData[playerid][boomboxPos][0], BoomboxData[playerid][boomboxPos][1], BoomboxData[playerid][boomboxPos][2]))
		    return SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place de la boombox.");
		Boombox_Destroy(playerid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à prit sa boombox.", ReturnName(playerid, 0));
	}
	else if (!strcmp(type, "url", true))
	{
	    if (sscanf(string, "s[128]", string))
	        return SendSyntaxMessage(playerid, "/boombox [url] [song url]");
        if (!BoomboxData[playerid][boomboxPlaced])
	        return SendErrorMessage(playerid, "Vous n'avez pas de boombox déployer.");
		if (!IsPlayerInRangeOfPoint(playerid, 3.0, BoomboxData[playerid][boomboxPos][0], BoomboxData[playerid][boomboxPos][1], BoomboxData[playerid][boomboxPos][2]))
		    return SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place d'une boombox.");
		Boombox_SetURL(playerid, string);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s change de station.", ReturnName(playerid, 0));
	}
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
	SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	return 1;
}
CMD:trouverpoubelle(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	new id = GetClosestGarbage(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "Il ya pas de poubelle proche de vous.");
	PlayerData[playerid][pCP] = 1;
	SetPlayerCheckpoint(playerid, GarbageData[id][garbagePos][0], GarbageData[id][garbagePos][1], GarbageData[id][garbagePos][2], 2.5);
	SendServerMessage(playerid, "Une poubelle est indiquée sur votre carte.");
	return 1;
}
CMD:search(playerid, params[])
{
	new userid;
	if (sscanf(params, "u", userid))
	{
		SendSyntaxMessage(playerid, "/search [playerid/nom]");
		SendClientMessage(playerid, COLOR_YELLOW, "[HINT]:{FFFFFF} Tape /searchbp Une recherche le sac à dos d'un joueur.");
		return 1;
	}
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (Inventory_HasItem(userid, "Graine marijuana"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana Seeds (%d)", Inventory_Count(userid, "Graine marijuana"));
    if (Inventory_HasItem(userid, "Graine cocaine"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine Seeds (%d)", Inventory_Count(userid, "Graine cocaine"));
    if (Inventory_HasItem(userid, "Graine Heroin Opium"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin Opium Seeds (%d)", Inventory_Count(userid, "Graine Heroin Opium"));
	if (Inventory_HasItem(userid, "Steroids"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Steroids (%d)", Inventory_Count(userid, "Steroids"));
    if (Inventory_HasItem(userid, "Marijuana"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana (%d)", Inventory_Count(userid, "Marijuana"));
    if (Inventory_HasItem(userid, "Cocaine"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine (%d)", Inventory_Count(userid, "Cocaine"));
    if (Inventory_HasItem(userid, "Heroin"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin (%d)", Inventory_Count(userid, "Heroin"));
	for (new i = 0; i < 12; i ++) if (PlayerData[userid][pGuns][i] && PlayerData[userid][pAmmo][i] > 0) {
	    SendClientMessageEx(playerid, COLOR_LIGHTRED, "** %s", ReturnWeaponName(PlayerData[userid][pGuns][i]));
	}
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s commence une recherche %s pour les articles illégaux.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}
CMD:searchbp(playerid, params[])
{
    new userid, backpack;
	if (sscanf(params, "u", userid))
		return SendSyntaxMessage(playerid, "/searchbp [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (!Inventory_HasItem(userid, "Backpack") || (backpack = GetPlayerBackpack(userid)) == -1)
	    return SendErrorMessage(playerid, "Ce joueur n'a pas de sac à dos.");
    if (Backpack_HasItem(backpack, "Graine marijuana"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana Seeds (%d)", Backpack_Count(backpack, "Graine marijuana"));
    if (Backpack_HasItem(backpack, "Graine cocaine"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine Seeds (%d)", Backpack_Count(backpack, "Graine cocaine"));
    if (Backpack_HasItem(backpack, "Graine Heroin Opium"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin Opium Seeds (%d)", Backpack_Count(backpack, "Graine Heroin Opium"));
	if (Backpack_HasItem(backpack, "Steroids"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Steroids (%d)", Backpack_Count(backpack, "Steroids"));
    if (Backpack_HasItem(backpack, "Marijuana"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana (%d)", Backpack_Count(backpack, "Marijuana"));
    if (Backpack_HasItem(backpack, "Cocaine"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine (%d)", Backpack_Count(backpack, "Cocaine"));
    if (Backpack_HasItem(backpack, "Heroin"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin (%d)", Backpack_Count(backpack, "Heroin"));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s un recherché %s sac à dos pour articles illégaux.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}
CMD:confisquer(playerid, params[])
{
	new userid,string[128],facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/confisquer [playerid/nom]");
    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (GetWeaponCount(userid) > 0)
		strcat(string, "Take Weapons\n");
	if (Inventory_HasItem(userid, "Graine marijuana") || Inventory_HasItem(userid, "Graine cocaine") || Inventory_HasItem(userid, "Graine Heroin Opium"))
	    strcat(string, "Take Seeds\n");
	if (Inventory_HasItem(userid, "Marijuana") || Inventory_HasItem(userid, "Cocaine") || Inventory_HasItem(userid, "Heroin") || Inventory_HasItem(userid, "Steroids"))
	    strcat(string, "Take Drugs\n");
    if (Inventory_HasItem(userid, "Talkie-Walkie"))
	    strcat(string, "Take Radio\n");
	if (Inventory_HasItem(userid, "Backpack") && GetPlayerBackpack(userid) != -1)
	    strcat(string, "Take Backpack\n");
    if (Inventory_HasItem(userid, "License arme"))
	    strcat(string, "Take License arme\n");
   	if (Inventory_HasItem(userid, "permis de conduire"))
	    strcat(string, "Take permis de conduire\n");
	if (!strlen(string))
	    return SendErrorMessage(playerid, "Ce joueur n'a pas d'articles illégaux.");
	PlayerData[playerid][pTakeItems] = userid;
	Dialog_Show(playerid, TakeItems, DIALOG_STYLE_LIST, "Prendre objets", string, "Prendre", "Annuler");
	return 1;
}
CMD:defoncerporte(playerid, params[])
{
	static id = -1;
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][4] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas du FBI ou du Swat");
	if ((id = House_Nearest(playerid)) != -1)
	{
	    if (!HouseData[id][houseLocked])
	        return SendErrorMessage(playerid, "Cette maison est déja ouvert.");
	    ShowPlayerFooter(playerid, "Tu ~r~casse~w~ une porte...");
	    ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.0, 0, 0, 0, 0, 0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s essai de défoncé une porte de maison.", ReturnName(playerid, 0));
	    SetTimerEx("KickHouse", 1500, false, "dd", playerid, id);
	}
	else if ((id = Business_Nearest(playerid)) != -1)
	{
		if (!BusinessData[id][bizLocked])
		    return SendErrorMessage(playerid, "Ce magasin est déja ouvert.");
		ShowPlayerFooter(playerid, "Tu ~r~casse~w~ une porte...");
        ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.0, 0, 0, 0, 0, 0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s essai de défoncé une porte de magasin.", ReturnName(playerid, 0));
	    SetTimerEx("KickBusiness", 1500, false, "dd", playerid, id);
	}
	else {SendErrorMessage(playerid, "Tu doit être proche d'une maison ou d'un magasin.");}
	return 1;
}
CMD:acheteretagere(playerid, params[])
{
	new houseid = House_Inside(playerid),moneyentrepriseid;
	if (houseid == -1 || !House_IsOwner(playerid, houseid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place.");
	if (isnull(params) || (!isnull(params) && strcmp(params, "confirmer", true) != 0))
		return SendSyntaxMessage(playerid, "/acheteretagere [confirmer] (50,000$ frais)");
	if (Rack_Count(playerid) >= 4)
	    return SendErrorMessage(playerid, "votre maison peut seulement avoir 4 weapon racks.");
	if (Rack_Nearest(playerid) != -1)
	    return SendErrorMessage(playerid, "Tu ne peut utilise cette commande proche d'un autre rack.");
	if (GetMoney(playerid) < 50000)
	    return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent.");
	new id = Rack_Create(playerid, houseid);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
    ResetEditing(playerid);
	PlayerData[playerid][pEditRack] = id;
	EditDynamicObject(playerid, RackData[id][rackObjects][4]);
    GiveMoney(playerid, -50000);
    argent_entreprise[moneyentrepriseid][argentpolice] +=50000;
	moneyentreprisesave(moneyentrepriseid);
	SendServerMessage(playerid, "Vous avez acheté un weapon rack pour $50,000.");
	return 1;
}
CMD:armeetagere(playerid, params[])
{
	new id = Rack_Nearest(playerid);
	if (id == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	Rack_ShowGuns(playerid, id);
	return 1;
}
CMD:supetagere(playerid, params[])
{
	new
		id = -1,
		houseid = House_Inside(playerid);
	if (houseid == -1 || !House_IsOwner(playerid, houseid))
	    return SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place house interior.");
	if ((id = Rack_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
	Rack_Delete(id);
	GiveMoney(playerid, 20000);
	SendServerMessage(playerid, "Vous avez supprimer le rack d'arme de votre maison.");
	return 1;
}
CMD:creerrack(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = Rack_Create(playerid, -1);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES");
    ResetEditing(playerid);
    PlayerData[playerid][pEditRack] = id;
	EditDynamicObject(playerid, RackData[id][rackObjects][4]);
	SendServerMessage(playerid, "Créer avec succès rack (ID: %d.)", id);
	return 1;
}

CMD:editrack(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suprack [rack id]");
	if ((id < 0 || id >= MAX_WEAPON_RACKS) || !RackData[id][rackExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID rack invalide.");
	Rack_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes weapon rack (ID: %d.)", id);
	return 1;
}
CMD:tracenumber(playerid, params[])
{
	new number;
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", number))
	    return SendSyntaxMessage(playerid, "/tracenumber [phone number]");
	if (number == 0)
	    return SendErrorMessage(playerid, "Vous avez spécifier un numéro invalide.");
	if (GetNumberOwner(number) != INVALID_PLAYER_ID)
	    return SendServerMessage(playerid, "Le numero de téléphone %d est a %s.", number, ReturnName(GetNumberOwner(number), 0));
	SendErrorMessage(playerid, "Aucun joueur online avec ce numero.");
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supspeed [speed id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !SpeedData[id][speedExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID radar invalide.");
	Speed_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes speed camera (ID: %d.)", id);
	return 1;
}
CMD:admins(playerid, params[])
{
	new count = 0;
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    foreach (new i : Player) if (PlayerData[i][pAdmin] > 0 && PlayerData[i][pAdminHide] < 1)
	{
        if (PlayerData[i][pAdminDuty])
			SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(Level: %d) {33CC33}(On Duty)", ReturnName(i, 0), PlayerData[i][pAdmin]);

		else
		    SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(Level: %d) {FF6347}(Off Duty)", ReturnName(i, 0), PlayerData[i][pAdmin]);
        count++;
	}
	if (!count) {
	    SendClientMessage(playerid, COLOR_WHITE, "* Pas d'admins en ligne.");
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}
CMD:supporteurs(playerid, params[])
{
	new count = 0;
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    foreach (new i : Player) if (PlayerData[i][pTester] > 0)
	{
        if (PlayerData[i][pTesterDuty])
			SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(On Duty)", ReturnName(i, 0));
		else SendClientMessageEx(playerid, COLOR_WHITE, "* %s {FF6347}(Off Duty)", ReturnName(i, 0));
        count++;
	}
	if (!count) {
	    SendClientMessage(playerid, COLOR_WHITE, "* Pas de supporters en ligne.");
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}
CMD:montrerpermis(playerid, params[])
{
	static userid;
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/montrerpermis [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
		return SendErrorMessage(playerid, "Tu ne peut montré tes lisence a toi même.");
	SendClientMessage(userid, COLOR_GREY, "-----------------------------------------------------------");
	if (Inventory_HasItem(playerid, "permis de conduire")) SendClientMessageEx(userid, COLOR_WHITE, "* Permis de conduire {33CC33}(Passer)");
 	else SendClientMessageEx(userid, COLOR_WHITE, "* Permis de conduire {AA3333}(Pas passer)");
	if (Inventory_HasItem(playerid, "License arme")) SendClientMessageEx(userid, COLOR_WHITE, "* Permis de port d'arme {33CC33}(Passer)");
	else SendClientMessageEx(userid, COLOR_WHITE, "* Permis de port d'arme {AA3333}(Pas passer)");
	SendClientMessage(userid, COLOR_GREY, "-----------------------------------------------------------");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend ces license et les montres a %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
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
CMD:stopchargement(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][6] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (!PlayerData[playerid][pLoading] && !PlayerData[playerid][pLoadType])
	    return SendErrorMessage(playerid, "Tu n'est pas entrain de chargé de la marchandise en se moment.");
	PlayerData[playerid][pLoading] = 0;
	PlayerData[playerid][pLoadType] = 0;
    PlayerData[playerid][pLoadCrate] = 0;
	RemovePlayerAttachedObject(playerid, 4);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	DisablePlayerCheckpoint(playerid);
	SendServerMessage(playerid, "Tu ne charge plus de marchandise.");
	return 1;
}
CMD:chargermarchandise(playerid, params[])
{
 	new id = Job_NearestPoint(playerid),stockjobinfoid,factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][6] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (id == -1 || JobData[id][jobType] != JOB_COURIER)
	    return SendErrorMessage(playerid, "Vous n'êtes pas proche de la position.");
	Job_Refresh(id);
    if(info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] < 10)
		return SendErrorMessage(playerid,"Il n'y a pas assez de marchandise pour livrer");
	if (PlayerData[playerid][pLoadType] > 0)
	    return SendErrorMessage(playerid, "Vous avez déja commencé à livrer.");
    if (IsPlayerInAnyVehicle(playerid))
    	return SendErrorMessage(playerid, "Vous devez êtres hors du vehicule.");
	Dialog_Show(playerid, StartDelivery, DIALOG_STYLE_LIST, "Type de marchandise", "24/7\nArmurerie\nVêtement\nAlimentation\nEssence\nMobilier\nBar\nEpicerie\nQuincaillerie", "Ok", "Annuler");
	return 1;
}
CMD:accepterlivraison(playerid, params[])
{
    new id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid)),facass = PlayerData[playerid][pFaction];
    if (id == -1 || !Business_IsOwner(playerid, id))
        return SendErrorMessage(playerid, "Vous n'êtes pas au bon magasin.");
	if (BusinessData[id][bizType] == 5)
	    return SendErrorMessage(playerid, "Tu ne peut faire de livraison pour ce magasin.");
	if (BusinessData[id][bizShipment])
	{
	    foreach (new i : Player) if (PlayerData[i][pShipment] == id)
		{
	        CancelShipment(i);
	        SendServerMessage(i, "La livraison a été annulé.");
	    }
	    BusinessData[id][bizShipment] = 0;
	    Business_Save(id);
	    SendServerMessage(playerid, "votre magasin ne requiere plus de livraison.");
		if(FactionData[facass][factionacces][6] == 1)
		{ SendServerMessage(playerid, "** %s ne veux plus de livraison pour %s. **", ReturnName(playerid, 0), BusinessData[id][bizName]);}
	}
	else
	{
	    if (BusinessData[id][bizDeliver][0] == 0.0 && BusinessData[id][bizDeliver][1] == 0.0 && BusinessData[id][bizDeliver][2] == 0.0)
	        return SendErrorMessage(playerid, "Le point de livraison pour votre magasin n'est pas fait.");
	    BusinessData[id][bizShipment] = 1;
	    Business_Save(id);
	    SendServerMessage(playerid, "Vous avez demander une livraison pour votre magasin.");
		if(FactionData[facass][factionacces][6] == 1)
		{ SendServerMessage(playerid, "** %s à demander une livraison pour sont magasin %s (/fairelivraison pour accepter). **", ReturnName(playerid, 0), BusinessData[id][bizName]);}
	}
	return 1;
}
CMD:refuserlivraison(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][6] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (PlayerData[playerid][pShipment] == -1)
	    return SendErrorMessage(playerid, "Vous n'avez pas accepté de livraison.");
	CancelShipment(playerid);
	SendServerMessage(playerid, "Vous avez annulé une livraison");
	return 1;
}
CMD:fairelivraison(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
    if (FactionData[factionid][factionacces][6] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (PlayerData[playerid][pShipment] != -1)
	    return SendErrorMessage(playerid, "Vous avez déja accepté une livraison (Tapez /refuserlivraison pour annuler).");
	ShowShipments(playerid);
	return 1;
}
CMD:usemag(playerid, params[])
{
	new weaponid = PlayerData[playerid][pHoldWeapon];
	if (!weaponid)
	    return SendErrorMessage(playerid, "Tu na pas d'arme vide sur toi.");
	if (PlayerData[playerid][pUsedMagazine])
	    return SendErrorMessage(playerid, "Vous avez déja utiliser un chargeur pour votre arme.");
	if (Inventory_HasItem(playerid, "Chargeur"))
	{
		switch (weaponid)
		{
			case 22:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 24:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 28:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 29:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 32:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 30:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 31:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}		
			case 33:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 34:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "Chargeur");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recharge son arme.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			default:
				return SendErrorMessage(playerid, "Tu ne peut chargé cette arme.");
		}
	}
	if (Inventory_HasItem(playerid, "douille de shotgun"))
	{
		switch (weaponid)
		{
			case 25:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "douille de shotgun");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mets quelque cartouche.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 26:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "douille de shotgun");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mets quelque cartouche.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			case 27:
			{
				PlayerPlaySoundEx(playerid, 1131);
				PlayerData[playerid][pUsedMagazine] = 1;
				Inventory_Remove(playerid, "douille de shotgun");
				PlayReloadAnimation(playerid, 24);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mets quelque cartouche.", ReturnName(playerid, 0));
				ShowPlayerFooter(playerid, "Appuyer ~y~'H'~w~ pour charger l'arme.");
			}
			default:
				return SendErrorMessage(playerid, "Tu ne peut chargé cette arme.");
		}
	}
	return 1;
}
CMD:etape(playerid, params[])
{
	if (!IsTaskActive(playerid))
	    return 1;
	new string[128];
	if (!PlayerData[playerid][pBankTask])
		strcat(string, "Visité une banque (en cours)\n");
	if (!PlayerData[playerid][pStoreTask])
	    strcat(string, "Visité un 24/7 (en cours)\n");
	if (!PlayerData[playerid][pTestTask])
	    strcat(string, "Visité une auto-école (en cours)\n");
	Dialog_Show(playerid, NewTasks, DIALOG_STYLE_LIST, "Task List", string, "Valider", "Annuler");
	return 1;
}
CMD:warnings(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "Warnings (%d/2)", PlayerData[playerid][pWarnings]);
    if (PlayerData[playerid][pWarnings] >= 1 && strlen(PlayerData[playerid][pWarn1]))
        SendClientMessageEx(playerid, COLOR_WHITE, "* 1er Warning: \"%s\"", PlayerData[playerid][pWarn1]);
    if (PlayerData[playerid][pWarnings] >= 2 && strlen(PlayerData[playerid][pWarn2]))
        SendClientMessageEx(playerid, COLOR_WHITE, "* 2e Warning: \"%s\"", PlayerData[playerid][pWarn2]);
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}
CMD:trier(playerid, params[])
{
	new id = -1;
	if (PlayerData[playerid][pJob] != JOB_SORTER)
	    return SendErrorMessage(playerid, "Vous n'avez pas le job approprié.");
    if ((id = Job_NearestPoint(playerid)) == -1 || JobData[id][jobType] != JOB_SORTER)
		return SendErrorMessage(playerid, "Vous n'êtes proche de rien.");
 	switch (PlayerData[playerid][pSorting])
 	{
	 	case -1:
 	    {
 	        PlayerData[playerid][pSorting] = id;
 	        PlayerData[playerid][pSortCrate] = 1;
			SendServerMessage(playerid, "Vous avez récuperé une boite. Allez la deposer au prochain marqueur.");
 	        SetPlayerAttachedObject(playerid, 4, 1220, 5, 0.137832, 0.176979, 0.151424, 96.305931, 185.363006, 20.328088, 0.699999, 0.800000, 0.699999);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
			SetPlayerCheckpoint(playerid, JobData[id][jobDeliver][0], JobData[id][jobDeliver][1], JobData[id][jobDeliver][2], 1.0);
		}
		default:
		{
		    PlayerData[playerid][pSorting] = -1;

		    if (PlayerData[playerid][pSortCrate] != 0)
		    {
		        PlayerData[playerid][pSortCrate] = 0;
		        RemovePlayerAttachedObject(playerid, 4);
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
 	        }
 	        DisablePlayerCheckpoint(playerid);
 	        SendServerMessage(playerid, "Vous arrêtez de travailler.");
 	    }
	}
	Updatestocksorter();
	return 1;
}
CMD:donnerarme(playerid, params[])
{
	new weaponid = GetWeapon(playerid),ammo = GetPlayerAmmo(playerid),userid;
	if (!weaponid)
	    return SendErrorMessage(playerid, "Tu n'est pas d'arme sur toi.");
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/donnerarme [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
		return SendErrorMessage(playerid, "Tu ne peut donner a toi-même a weapon.");
	if (PlayerData[userid][pGuns][g_aWeaponSlots[weaponid]] != 0)
	    return SendErrorMessage(playerid, "Ce joueur a déja une arme dans se slot.");
	ResetWeapon(playerid, weaponid);
	GiveWeaponToPlayer(userid, weaponid, ammo);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s passe son %s a %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnName(userid, 0));
	Log_Write("logs/give_log.txt", "[%s] %s (%s) has given a %s with %d ammo a %s (%s).", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnWeaponName(weaponid), ammo, ReturnName(userid, 0), PlayerData[userid][pIP]);
	return 1;
}
CMD:vw(playerid, params[]) {
	SendClientMessageEx(playerid, COLOR_CLIENT, "Virtual World: %d", GetPlayerVirtualWorld(playerid));
	return 1;
}
CMD:tduty(playerid, params[])
{
	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "Vous n'êtes pas un helpeur");
	if (!PlayerData[playerid][pTesterDuty])
	{
		SetPlayerColor(playerid, 0xFF634700);
		PlayerData[playerid][pTesterDuty] = 1;
		SendClientMessageToAllEx(COLOR_LIGHTRED, "** %s est maintenant en service pour aider (/rapport pour de l'aide).", ReturnName(playerid, 0));
	}
	else
	{
	    SetPlayerColor(playerid, DEFAULT_COLOR);
		PlayerData[playerid][pTesterDuty] = 0;
		SendServerMessage(playerid, "Tu n'est plus en duty.");
	}
	return 1;
}
CMD:time(playerid, params[])
{
	static string[128],month[12],date[6];
	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);
	switch (date[1]) {
	    case 1: month = "Janvier";
	    case 2: month = "Fevrier";
	    case 3: month = "Mars";
	    case 4: month = "Avril";
	    case 5: month = "Mai";
	    case 6: month = "Juin";
	    case 7: month = "Juillet";
	    case 8: month = "Aout";
	    case 9: month = "Septembre";
	    case 10: month = "Octobre";
	    case 11: month = "Novembre";
	    case 12: month = "Decembre";
	}
	format(string, sizeof(string), "%d/60 minutes avant de toucher votre salaire.",PlayerData[playerid][pMinutes]);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "~g~%s %02d %d~n~~b~%02d:%02d:%02d", month, date[0], date[2], date[3], date[4], date[5]);
	GameTextForPlayer(playerid, string, 6000, 1);
	return 1;
}

CMD:healall(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	foreach (new i : Player) {
	    SetPlayerHealth(i, 100.0);
	}
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a soigné tout le monte.", ReturnName(playerid, 0));
	return 1;
}
CMD:whisper(playerid, params[])
{
	new userid, text[128];
    if (sscanf(params, "us[128]", userid, text))
	    return SendSyntaxMessage(playerid, "/(w)hisper [playerid/name] [text]");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "Ce joueur n'est point la.");
	if (userid == playerid)
		return SendErrorMessage(playerid, "Tu ne peut chuchotter toi même.");
    if (strlen(text) > 64) {
	    SendClientMessageEx(userid, COLOR_YELLOW, "** Chuchotte %s (%d): %.64s", ReturnName(playerid, 0), playerid, text);
	    SendClientMessageEx(userid, COLOR_YELLOW, "...%s **", text[64]);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "** Chuchotte à %s (%d): %.64s", ReturnName(userid, 0), userid, text);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "...%s **", text[64]);
	}
	else {
	    SendClientMessageEx(userid, COLOR_YELLOW, "** Chuchotte %s (%d): %s **", ReturnName(playerid, 0), playerid, text);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "** Chuchottement a %s (%d): %s **", ReturnName(userid, 0), userid, text);
	}
	Log_Write("logs/whisper_log.txt", "[%s] [Chuchottement] %s à %s et dit : %s .", ReturnDate(),ReturnName(playerid, 0),ReturnName(userid, 0),text);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s chuchotte à %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}
CMD:masque(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Masque"))
		return SendErrorMessage(playerid, "Vous n'avez pas de masque.");
	switch (PlayerData[playerid][pMaskOn])
	{
		case 0:
		{
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un(e) masque et le met.", ReturnName(playerid, 0));
		    PlayerData[playerid][pMaskOn] = 1;
		}
		case 1:
		{
		    PlayerData[playerid][pMaskOn] = 0;
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s enleve son masque.", ReturnName(playerid, 0));
		}
	}
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
CMD:gyrophare(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
	new vehicleid = GetPlayerVehicleID(playerid);
	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "Vous devez être a l'intérieur d'un vehicle.");
	switch (CoreVehicles[vehicleid][vehSirenOn])
	{
	    case 0:
	    {
			static
        		Float:fSize[3],
        		Float:fSeat[3];
		    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]); // need height (z)
    		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, fSeat[0], fSeat[1], fSeat[2]); // need pos (x, y)
            CoreVehicles[vehicleid][vehSirenOn] = 1;
			CoreVehicles[vehicleid][vehSirenObject] = CreateDynamicObject(18646, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);
		    AttachDynamicObjectToVehicle(CoreVehicles[vehicleid][vehSirenObject], vehicleid, -fSeat[0], fSeat[1], fSize[2] / 2.0, 0.0, 0.0, 0.0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ouvre la fenetre et pose le girophare sur le toit du véhicule a l'aide de sa main gauche.", ReturnName(playerid, 0));
		}
		case 1:
		{
		    CoreVehicles[vehicleid][vehSirenOn] = 0;
			DestroyDynamicObject(CoreVehicles[vehicleid][vehSirenObject]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s récupère le girophare a l'aide de sa main gauche.", ReturnName(playerid, 0));
		}
	}
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
CMD:breakcuffs(playerid, params[])
{
	static userid;
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/breakcuffs [playerid/nom]");
	if (!Inventory_HasItem(playerid, "Pied de biche"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de crowbar.");
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendErrorMessage(playerid, "Le numéro du player est déconnecté ou pas proche de toi");
	if (!PlayerData[userid][pCuffed])
	    return SendErrorMessage(playerid, "Le numéro du joueur n'est pas menotté.");
	if (userid == playerid)
	    return SendErrorMessage(playerid, "Tu ne peut te défaie de tes menottes.");
	SetTimerEx("BreakCuffs", 3000, false, "dd", playerid, userid);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s essai d'enlevé des menottes.", ReturnName(playerid, 0));
	return 1;
}
CMD:dice(playerid, params[])
{
	new number = random(6) + 1;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s roulle un dé et obtienr %d.", ReturnName(playerid, 0), number);
	return 1;
}
CMD:serrermain(playerid, params[])
{
	static
	    userid,
	    type;
	if (sscanf(params, "ud", userid, type))
	    return SendSyntaxMessage(playerid, "/serrermain [playerid/name] [type]");
    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "Le numéro du player est déconnecté ou pas proche de toi.");
    if (userid == playerid)
		return SendErrorMessage(playerid, "Tu ne peut te serré ta mains.");
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Tu doit spécifié un type de 1 a 6.");
	PlayerData[userid][pShakeOffer] = playerid;
	PlayerData[userid][pShakeType] = type;

	SendServerMessage(userid, "%s vous a offert une poigné de mains $ (écriver \"/accepter greet\").", ReturnName(playerid, 0));
	SendServerMessage(playerid, "Vous avez offert une poigné de mains a %s.", ReturnName(userid, 0));
	return 1;
}
CMD:fouiller(playerid, params[])///////// wtf cossé sa osti
{
	static userid;
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/fouiller [playerid/nom]");
    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "Le numéro du player est déconnecté ou pas proche de toi.");
    if (userid == playerid)
		return SendErrorMessage(playerid, "Tu ne peut te fouiller toi même.");
	PlayerData[userid][pFriskOffer] = playerid;
	SendServerMessage(userid, "%s veux vous fouillez. (écriver \"/accepter fouille\").", ReturnName(playerid, 0));
	SendServerMessage(playerid, "Vous voulez fouiller %s.", ReturnName(userid, 0));
	return 1;
}
CMD:setradio(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "Tu n'est pas conducteur.");
	if (!IsEngineVehicle(vehicleid))
	    return SendErrorMessage(playerid, "Ce vehicule n'a pas de radio.");
	Dialog_Show(playerid, Radio, DIALOG_STYLE_LIST, "Station de Radio", "Cultural\nOldies\nOther\nPop\nRhythm & Blues\nRock\nTalk\nUrban\nElectric\nTurn Radio Off", "Valider", "Annuler");
	return 1;
}
CMD:creergraffiti(playerid, params[])
{
	static id = -1,Float:x,Float:y,Float:z,Float:angle;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supgraffiti [graffiti id]");
	if ((id < 0 || id >= MAX_GRAFFITI_POINTS) || !GraffitiData[id][graffitiExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID graffiti tage invalide.");
	Graffiti_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes graffiti (ID: %d.)", id);
	return 1;
}
CMD:fspray(playerid, params[])
{
	new id = Graffiti_Nearest(playerid),facass = PlayerData[playerid][pFaction];
	if (id == -1)
	    return SendErrorMessage(playerid, "Tu n'est pas proche de graffiti point.");
	if (FactionData[facass][factionacces][8] == 1)
	{
		/*if (!Inventory_HasItem(playerid, "Bombe de peinture"))
				return SendErrorMessage(playerid, "Vous n'avez pas de spray can sur vous.");*/
		Dialog_Show(playerid, GraffitiColor, DIALOG_STYLE_LIST, "Sélection des couleurs", "{FFFFFF}Blanc\n{FF0000}Rouge\n{FFFF00}Jaune\n{33CC33}Vert\n{33CCFF}Bleu clair\n{FFA500}Orange\n{1394BF}Blue sombre", "Valider", "Annuler");
	}
	else SendErrorMessage(playerid, "Tu n'est pas membre d'une faction type gang.");
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
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	switch (PlayerData[playerid][pAdminHide])
	{
	    case 0:
	    {
	        PlayerData[playerid][pAdminHide] = 2;
	        SendServerMessage(playerid, "Tu a été donner le pouvoir de devenir invisible sans les maluces!");
		}
		case 1:
	    {
	        PlayerData[playerid][pAdminHide] = 0;
	        SendServerMessage(playerid, "Tu est maintenant visible de la liste d'admin.");
		}
	}
	return 1;
}
CMD:creerdetector(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supdetector [detector id]");
	if ((id < 0 || id >= MAX_METAL_DETECTORS) || !MetalDetectors[id][detectorExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID detecteur invalide.");
	Detector_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes detector (ID: %d.)", id);
	return 1;
}
CMD:crocheterporte(playerid, params[])
{
	new id = Car_Nearest(playerid);
	if (!Inventory_HasItem(playerid, "Pied de biche"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de pied de biche et d'un tournevis.");
	if (!Inventory_HasItem(playerid, "Tournevis"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de pied de biche et d'un tournevis.");
	if (id == -1)
	    return SendErrorMessage(playerid, "Vous n'est pas proche d'un vehicule.");
	if (!CarData[id][carLocked])
	    return SendErrorMessage(playerid, "Ce vehicule n'est pas fermé.");
	PlayerData[playerid][pPicking] = 1;
	PlayerData[playerid][pPickCar] = id;

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un pied de biche et défait une porte", ReturnName(playerid, 0));
	SendVehiculeMessage(playerid, "Attendez 120 secondes pour crocheter");
	return 1;
}
CMD:supplant(playerid, params[])
{
	static id = 0;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/suppplant [plant id]");
	if ((id < 0 || id >= MAX_DRUG_PLANTS) || !PlantData[id][plantExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID plante invalide");
	Plant_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes plant (ID: %d.)", id);
	return 1;
}
CMD:resetvw(playerid, params[])
{
	if (GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) > 0)
	{
	    SetPlayerVirtualWorld(playerid, 0);
	    SendServerMessage(playerid, "Vous avez fixed votre virtual world.");
	}
	else SendErrorMessage(playerid, "Votre monde virtuel n'est pas bug maintenant.");
	return 1;
}
CMD:stopanim(playerid, params[])
{
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "Tu a pas besoin de cette commande maintenant.");
	ClearAnimations(playerid, 1);
    HidePlayerFooter(playerid);
	PlayerData[playerid][pLoopAnim] = 0;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	SendServerMessage(playerid, "Vous avez stop une animation.");
	return 1;
}
CMD:editbillboard(playerid, params[])
{
	static id,type[24],string[128];
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbillboard [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, name, price, message, owner, range");
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
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/supbillboard [bb id]");
	if ((id < 0 || id >= MAX_DYNAMIC_OBJ) || !BillBoardData[id][bbExists])
	    return SendErrorMessage(playerid, "Vous avez spécifier un ID panneau d'affichage invalide.");
	Billboard_Delete(id);
	SendServerMessage(playerid, "Vous avez supprimé avec succes billboard (ID: %d.)", id);
	return 1;
}

CMD:appeler(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction],moneyentrepriseid;
    if (!Inventory_HasItem(playerid, "Telephone"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de téléphone sur vous.");
    if (PlayerData[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Votre téléphone est éteinds.");
    if(PlayerData[playerid][pAcom] == 0) return SendErrorMessage(playerid,"{FF0000}Votre batterie est déchargée!");
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	static targetid,number;
	if (sscanf(params, "d", number))
 	   return SendSyntaxMessage(playerid, "/appeler [Numéro] (Taxi: 1222, Urgences: 911, San news: 222, Publicité: 223, Mécanicien: 555, Livreur: 1001, Commande: 1002)");
	if (!number)
	    return SendErrorMessage(playerid, "Le numéro que vous tenter de joindre n'est pas en service..");
	if (number == 911)
	{
		PlayerData[playerid][pEmergency] = 1;
		PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son téléphone puis compose un numéro.", ReturnName(playerid, 0));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPÉRATEUR]:{FFFFFF} Quel service avez vous besoin ?: \"police\" ou \"medecin\"?");
		PlayerData[playerid][pAcom] -= 2;
	}
	else if(number == 910)
    {
		if (FactionData[factionid][factionacces][1] == 0)
			return SendServerMessage(playerid, "Vous êtes qui vous?");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d pour commander des kevlars.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		if (argent_entreprise[moneyentrepriseid][argentpolice] < 5000)
		    return SendErrorMessage(playerid, "Vous n'avez pas asser d'argent dans le coffre pour cette transation. (minimum 5000$)");
		if(mercco < 1) {ShowPlayerFooter(playerid, " Il n'a pas de livreur de marchandise"); return 1;}
		Dialog_Show(playerid, kevlar, DIALOG_STYLE_MSGBOX,"Vous-vouler commander quoi?","Est-ce que vous vouler commander des Kevlar (10) ?", "Oui", "Non");
	}
	else if (number == 1222)
	{
	    PlayerData[playerid][pTaxiCalled] = 1;
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son téléphone puis compose un numéro.", ReturnName(playerid, 0));
		SendClientMessage(playerid, COLOR_YELLOW, "[OPÉRATEUR]:{FFFFFF} Les chauffeurs de taxi ont reçu votre appel. Ne Bougez pas.");
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s décroche son téléphone.", ReturnName(playerid, 0));
        PlayerData[playerid][pAcom] -= 3;
		foreach (new i : Player)
		{
			new facass1 = PlayerData[i][pFaction];
			if(FactionData[facass1][factionacces][13] == 1)
			{ SendServerMessage(i, "** %s a appellé un taxi, il se trouve à %s (Tapez /acceptertaxi pour accepter).", ReturnName(playerid, 0), GetPlayerLocation(playerid));}
		}
		cmd_racrocher(playerid, "\1");
	}
	else if (number == 555)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "OPÉRATEUR:{FFFFFF} Un service de mécanicien a été prévenu de votre appel.");
		MecanoApel = playerid;
		PlayerData[playerid][pAcom] -= 3;
		foreach (new i : Player)
		{
			new facass1 = PlayerData[i][pFaction];
			if(FactionData[facass1][factionacces][14] == 1 || FactionData[facass1][factionacces][15] == 1)
			{ SendServerMessage(i, "Une personne a besoin d'un mécanicien, utilisez /accepter mappel.");}
		}
		cmd_racrocher(playerid, "\1");
	}
	else if (number == 222)
	{
	    PlayerData[playerid][pPlaceAd] = 1;
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son téléphone puis compose un numéro.", ReturnName(playerid, 0));
		PlayerData[playerid][pAcom] -= 3;
		if (PlayerData[playerid][pPlayingHours] < 4) {
            SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Vous devez jouer 4 heures pour faire cela.");
		    cmd_racrocher(playerid, "\1");
		}
		else if (PlayerData[playerid][pAdTime] < 1) {
			SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Dite \"Oui\" Si vous souhaitez diffuser votre PUB pour 500$.");
			PlayerData[playerid][pAcom] -= 3;
		}
		else {
		    SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Déja fait veuiller attendre 2 minutes.");
		    PlayerData[playerid][pAcom] -= 3;
		    cmd_racrocher(playerid, "\1");
		}
	}
	else if (number == 223)
	{
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son téléphone puis compose un numéro.", ReturnName(playerid, 0));
		PlayerData[playerid][pAcom] -= 3;
		if (PlayerData[playerid][pPlayingHours] < 4) {
            SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Vous devez jouer 4 heures pour faire cela.");
		    cmd_racrocher(playerid, "\1");
		}
		SendClientMessageEx(playerid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Bienvenue, L'agence de panneaux publicitaire vous propose différent choix!");
		ViewBillboards(playerid);
	}
	else if (number == 1001)
	{	
		if (FactionData[factionid][factionacces][6] == 0) return SendErrorMessage(playerid, "Vous n'est pas camionneur");
		DisablePlayerCheckpoint(playerid);
		livraisonjob[playerid] = -1;
		quantiterdejob[playerid] = 0;
		Dialog_Show(playerid, Livraison, DIALOG_STYLE_LIST,"Veuiller choisir le type de livraison","Bois\nBaril de pétrole\nViande\nCaisse dock\nCaisse carriste\nCaisse Manutentionnaire\nPierre de la mine\nPiece électronique\nPièce d'armes\nMeuble","Valider", "Quitter");
	}
	else if (number == 1002)
	{
		if (FactionData[factionid][factionacces][14] == 0)
			return SendTelephoneMessage(playerid, "Téléphone : Vous êtes qui vous?");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
			return SendErrorMessage(playerid, "Tu doit être minimum rang %d pour commander des pièces.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		Dialog_Show(playerid, commande, DIALOG_STYLE_LIST,"Vous-vouler commander quoi?","Commander pièce de tunning avant\nCommander pièce de tunning arrière\nCommander pièce de tunning toit\nCommander pièce de tunning capot\nCommander pièce de tunning aileron\nCommander pièce de tunning d'extra\nCommander pièce de tunning sideskirt2\nCommander pièce de tunning wheel\nCommander pièce de tunning hydraulics\nCommander pièce de tunning roue\nCommander pièce de tunning carrosserie\nCommander bombe de peinture\nCommander des boites a outils\nCommander des bonbonne de NOS\nSavoir le stock", "Fermer", "");

	}
	else if ((targetid = GetNumberOwner(number)) != INVALID_PLAYER_ID)
	{
	    if (targetid == playerid)
	        return SendErrorMessage(playerid, "Tu ne peut t'appeller toi-même!");//scyzo
		if (PlayerData[targetid][pPhoneOff])
		    return SendErrorMessage(playerid, "Son téléphone est probablement éteinds");
		PlayerData[targetid][pIncomingCall] = 1;
		PlayerData[playerid][pIncomingCall] = 1;
		PlayerData[targetid][pCallLine] = playerid;
		PlayerData[playerid][pCallLine] = targetid;
		SendClientMessageEx(playerid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Vous appeller #%d, attendez une réponse...", number);
		SendClientMessageEx(targetid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Numéro #%d (écriver \"/decrocher\" pour décrocher).", PlayerData[playerid][pPhone]);
        PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
        PlayerData[playerid][pAcom] -= 3;
        PlayerPlaySoundEx(targetid, 23000);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son téléphone puis compose un numéro.", ReturnName(playerid, 0));
		SetPlayerAttachedObject(playerid, 7, 330, 6,0.068,0.002,0.028999,-91.000205,0.400055,177.100051,1,1,1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	}
	else {SendErrorMessage(playerid, "Le numéro que vous tenter de joindre n'est pas en service..");}
	for (new i = 0; i != MAX_HOUSES; i ++)
	{
		if (number == 51399+HouseData[i][houseID])
		{
			PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
			PlayerData[playerid][pAcom] -= 3;
			PlayerData[targetid][pCallLine] = i;
			SendClientMessageEx(playerid, COLOR_YELLOW, "[Téléphone]:{FFFFFF} Vous appeller la maison #%d, attendez une réponse...", i);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son téléphone puis compose un numéro.", ReturnName(playerid, 0));
			SetPlayerAttachedObject(playerid, 7, 330, 6,0.068,0.002,0.028999,-91.000205,0.400055,177.100051,1,1,1);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			new id = House_Nearest(playerid);
			foreach (new idd : Player) if (House_Inside(idd) == id)
			{
				SendClientMessage(idd, COLOR_PURPLE, "** Vous entendez le téléphone sonner.");
				PlayerPlaySound(idd, 20801, 0, 0, 0);
			}
		}
	}
	
	return 1;
}
CMD:infob(playerid, params[])
{
    new id = -1,factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][6] == 0) return SendErrorMessage(playerid, "Vous n'est pas camionneur");
    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1) {
     	SendServerMessage(playerid, "ID: %d | Biz: %s | Produits: %d", id, BusinessData[id][bizName], BusinessData[id][bizProducts]);
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place.");
	return 1;
}
CMD:creerbillboard(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	id = Billboard_Create(playerid, -1);
	if (id == -1)
	    return SendErrorMessage(playerid, "MAX LIMITES billboards.");
	SendServerMessage(playerid, "Créer avec succès billboard (ID: %d.)", id);
	return 1;
}
CMD:billboards(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1)
	{
	    SendErrorMessage(playerid, "Tu n'est pas autorisé a use this command");
	    return 1;
	}
	ViewBillboards(playerid);
	return 1;
}
CMD:monpanneau(playerid, params[])
{
	if(PlayerData[playerid][pOwnsBillboard] == -1)
	{
	    SendErrorMessage(playerid, "Tu n'a pas de panneau d'affichage");
	    return 1;
	}
    Dialog_Show(playerid, MyBillboardMenu, DIALOG_STYLE_LIST, "Gérer panneau d'affichage", "Editer panneau d'affichage\nDélouer panneau d'affichage", "Ok", "Quitter");
    return 1;
}
//job meuble
CMD:commencermeuble(playerid, params[])
{
	new stockjobinfoid;
    if (PlayerData[playerid][pJob] != JOB_MEUBLE)
	    return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1603.1254, -1811.8577, 1013.7048)) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous n'êtes pas dans l'entrepôt de menuiserie.");
	if(info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] == 0) return SendErrorMessage(playerid,"Il n'y a plus de stock de bois");
	if(GetPVarInt(playerid,"HaciendoMueble") == 1) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous n'êtes pas à l'usine de menuiserie");
	if(GetPVarInt(playerid,"TomoCarpintero") == 1) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous avez pris le job");
	SetPVarInt(playerid,"TomoCarpintero",1);
	SetPVarInt(playerid,"MueblesCreados",0);
	SkinAntes[playerid] = GetPlayerSkin(playerid);
	SetPlayerSkin(playerid, 16);
	//devant tas de bois
	SetPlayerCheckpoint(playerid,1600.1904, -1806.7262, 13.4863, 2.0);
	SetPlayerAttachedObject(playerid,4,18635,6,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	SendJOBMessage(playerid,"{c7a24a}»{FFFFFF} Vous vous êtes mis en tenue de travail, saisit du bois et aller devant une tables pour commencer à construire un meubles!");
	SendJOBMessage(playerid,"Click gauche sur le tas de bois pour le prendre");
	ClearAnimations(playerid);
	return 1;
}
CMD:quittermeuble(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1603.1254, -1811.8577, 1013.7048)) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous n'êtes pas dans l'entrepôt de menuiserie.");
	if(GetPVarInt(playerid,"HaciendoMueble") == 1) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous n'avez pas le travail de menuisier");
	new salairejobinfoid,meubleprix = info_salairejobinfo[salairejobinfoid][salairejobinfomenuisier],interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
	SetPVarInt(playerid,"TomoCarpintero",0);
	SetPVarInt(playerid,"Trabajando",0);
	SetPVarInt(playerid,"MueblesCreados",0);
	SetPlayerSkin(playerid, SkinAntes[playerid]);
	interettaxejob = floatround((float(MueblesCreados[playerid]*meubleprix) / 100) * taxerevenue);
	argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
	tamere = (MueblesCreados[playerid]*meubleprix) - interettaxejob;
	GivePlayerCash(playerid,tamere);
	moneyentreprisesave(moneyentrepriseid);
	SendJOBMessage(playerid, "Vous avez gagné %d dollars.", tamere);
	Mueble[playerid] = 0;
	MueblesCreados[playerid] = 0;
	if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
	if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
	return 1;
}
//camera helico
CMD:camheli(playerid, params[])
{
	new vehi = GetPlayerVehicleID( playerid );
	if( IsPlayerInAnyVehicle(playerid) ) // Vérification si le joueur trouve dans un véhicule du tout
	{
		if( GetVehicleModel( vehi ) == 497 ) // Si le joueur était dans le véhicule, nous vérifions maintenant si il est en hélicoptère de la police
		{
			if( GetPlayerVehicleSeat(playerid) == 1 ) // Vérifier si il est dans le siège du passager
			{
				if( GetPVarInt( playerid, "ThermalActive" ) == 0 ) // Si le joueur n'a pas thermale active
				{
					THERMALON( playerid, vehi ); // Nous mettons maintenant le joueur en mode thermique.
				}
				else // SI il était pas en mode thermique
				{
					THERMALOFF( playerid ); // Nous mettons aujourd'hui l'acteur de retour à la normale
				}
			}
			else return SendClientMessage(playerid,COLOR_LIGHTRED,"[ERREUR]: Ceci est pour seulement co-pilotes. ((Passager avant))" );
		}
		else return SendClientMessage(playerid, COLOR_LIGHTRED,"[ERREUR]: Ce véhicule est pas prise en charge d'une caméra thermique.");
	}
	else return SendClientMessage(playerid,COLOR_LIGHTRED,"[ERREUR]: Vous n'êtes pas dans un véhicule.");
	return 1;
}
CMD:livrercourier(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
    if (FactionData[factionid][factionacces][6] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas de l'entreprise.");
    Dialog_Show(playerid,jobcoursier,DIALOG_STYLE_MSGBOX,"Bureau","Voulez vous commencez votre travail?","Oui","Non");
    return 1;
}
CMD:gouvtaxe(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvTaxe, DIALOG_STYLE_INPUT, "Gouvernement les taxes", "Entrée un pourcentage de taxe:", "Continuer", " X ");
	return 1;
}
CMD:gouvtaxeentreprise(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvTaxeEntreprise, DIALOG_STYLE_INPUT, "Gouvernement les taxes entreprise", "Entrée un pourcentage de taxe pour les entreprises:", "Continuer", " X ");
	return 1;
}
CMD:gouvtaxerevenue(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvTaxeRevenue, DIALOG_STYLE_INPUT, "Gouvernement les taxes du revenue", "Entrée un pourcentage de taxe sur le revenue:", "Continuer", " X ");
	return 1;
}
CMD:gouvchommage(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvChommage, DIALOG_STYLE_INPUT, "Gouvernement le chommage", "Entrée un montant pour le chommage:", "Continuer", " X ");
	return 1;
}
CMD:gouvsubpolice(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvSubPolice, DIALOG_STYLE_INPUT, "Gouvernement subvention Police", "Entrée un montant pour une subvention pour la police:", "Continuer", " X ");
	return 1;
}
CMD:gouvsubfbi(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvSubFBI, DIALOG_STYLE_INPUT, "Gouvernement subvention FBI", "Entrée un montant pour une subvention pour le FBI:", "Continuer", " X ");
	return 1;
}
CMD:gouvsuburgentiste(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvSubUrgentiste, DIALOG_STYLE_INPUT, "Gouvernement subvention Urgences", "Entrée un montant pour une subvention pour les ugernces:", "Continuer", " X ");
	return 1;
}
CMD:gouvsubswat(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvSubSwat, DIALOG_STYLE_INPUT, "Gouvernement subvention SWAT", "Entrée un montant pour une subvention pour le SWAT:", "Continuer", " X ");
	return 1;
}
CMD:gouvaidebanque(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, GouvAideBanque, DIALOG_STYLE_INPUT, "Gouvernement Aide la Banque", "Entrée un montant pour une aide de la banque:", "Continuer", " X ");
	return 1;
}
CMD:gouvbizhouse(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, gouvebizhouse, DIALOG_STYLE_INPUT, "Gouvernement taxe combiné", "Entrée un montant pour la taxe:", "Continuer", " X ");
	return 1;
}
CMD:gouvmaison(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, gouvehouse, DIALOG_STYLE_INPUT, "Gouvernement Taxe maison", "Entrée un montant pour la taxe:", "Continuer", " X ");
	return 1;
}
CMD:gouvbiz(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, gouvebiz, DIALOG_STYLE_INPUT, "Gouvernement Taxe biz", "Entrée un montant pour la taxe:", "Continuer", " X ");
	return 1;
}
CMD:taxe(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	Dialog_Show(playerid, taxedugouvernement, DIALOG_STYLE_LIST,"Gestion du Gouvernement", "Taxe\nTaxe entreprise\nTaxe revenue\nChomage\nSubvention police\nSubvention Militaire\nSubvention urgentiste\nSubvention swat\nAider la banque\nTax Maison + Biz\nTaxe Maison\nTaxe Biz", "Valider", "Quitter");
	return 1;
}
//cv
CMD:cvfbi(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, fbicv, DIALOG_STYLE_MSGBOX, "C.V - Militaire", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvfbi` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvjournaliste(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Journaliste", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvjournaliste` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvurgentiste(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - urgentiste", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvurgentiste` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvlivraisonbiz(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Livreur de magasin", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvlivraisonbiz` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvmairie(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Mairie", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvmairie` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvmecanozone3(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Mécanicien zone 3", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvmecanozone3` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvmecanozone4(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Mécanicien zone 4", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvmecanozone4` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvpetitlivreur(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Petit livreur", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvpetitlivreur` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvpolice(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Police", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvpolice` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvswat(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Swat", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvswat` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvtaxi(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pénom - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Taxi", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvtaxi` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cvvendeurrue(playerid, params[])
{
	new query[900], szString[900];
	static name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(szString, sizeof(szString), "{FFFFFF}Nom Pén  om - {FF8000}%s{FFFFFF}\n{FFFFFF}Téléphone - {FF8000}%d{FFFFFF}\n{FFFFFF}Date de naissance - {FF8000}%s{FFFFFF}\n{FFFFFF}Sexe - {FF8000}%d{FFFFFF}\n{FFFFFF}Origine - {FF8000}%s{FFFFFF}", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	Dialog_Show(playerid, cvnews, DIALOG_STYLE_MSGBOX, "C.V - Vendeur de rue", szString, "Ok", "");
	format(query, sizeof(query), "INSERT INTO `cvvendeurrue` (`pseudo`, `telephone`, `naissance`, `sexe`, `origine`) VALUES('%s', '%d', '%s', '%d', '%s')", name, PlayerData[playerid][pPhone], PlayerData[playerid][pBirthdate], PlayerData[playerid][pGender], PlayerData[playerid][pOrigin]);
	mysql_tquery(g_iHandle, query, "", "");
	return 1;
}
CMD:cv(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 5.0, 314.2601,138.2111,1011.7645))
		return SendErrorMessage(playerid, "Vous n'êtes pas a l'anpe");
	Dialog_Show(playerid, cv, DIALOG_STYLE_LIST,"Curriculum vitae",  "Militaire\nJournaliste\nLivreur de magasin\nMairie\nMécanicien zone 3\nMécanicien zone 4\nPolice\nSwat\nTaxi\nVendeur de rue\nUrgentiste", "Valider", "Quitter");
	return 1;
}
//salaire gouv
CMD:gouvrang1(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank1, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 1", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang2(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank2, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 2", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang3(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank3, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 3", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang4(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank4, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 4", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang5(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank5, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 5", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang6(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank6, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 6", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang7(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank7, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 7", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang8(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank8, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 8", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang9(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank9, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 9", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang10(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank10, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 10", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang11(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank11, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 11", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang12(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank12, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 12", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang13(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank13, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 13", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang14(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank14, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 14", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:gouvrang15(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][7] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du gouvernement ou le leader.");
	Dialog_Show(playerid, GouvRank15, DIALOG_STYLE_INPUT, "Gouvernement Salaire Rang 15", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
//salaire fbi
CMD:fbirang1(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank1, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 1", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang2(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank2, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 2", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang3(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank3, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 3", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang4(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank4, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 4", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang5(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank5, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 5", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang6(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank6, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 6", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang7(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank7, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 7", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang8(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank8, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 8", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang9(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank9, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 9", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang10(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank10, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 10", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang11(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank11, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 11", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang12(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank12, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 12", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang13(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank13, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 13", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang14(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank14, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 14", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:fbirang15(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du Militaire ou le leader.");
	Dialog_Show(playerid, FBIRank15, DIALOG_STYLE_INPUT, "Militaire Salaire Rang 15", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
//salaire police
CMD:policerang1(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank1, DIALOG_STYLE_INPUT, "Police Salaire Rang 1", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang2(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank2, DIALOG_STYLE_INPUT, "Police Salaire Rang 2", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang3(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank3, DIALOG_STYLE_INPUT, "Police Salaire Rang 3", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang4(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank4, DIALOG_STYLE_INPUT, "Police Salaire Rang 4", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang5(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank5, DIALOG_STYLE_INPUT, "Police Salaire Rang 5", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang6(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank6, DIALOG_STYLE_INPUT, "Police Salaire Rang 6", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang7(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank7, DIALOG_STYLE_INPUT, "Police Salaire Rang 7", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang8(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank8, DIALOG_STYLE_INPUT, "Police Salaire Rang 8", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang9(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank9, DIALOG_STYLE_INPUT, "Police Salaire Rang 9", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang10(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank10, DIALOG_STYLE_INPUT, "Police Salaire Rang 10", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang11(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank11, DIALOG_STYLE_INPUT, "Police Salaire Rang 11", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang12(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank12, DIALOG_STYLE_INPUT, "Police Salaire Rang 12", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang13(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank13, DIALOG_STYLE_INPUT, "Police Salaire Rang 13", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang14(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank14, DIALOG_STYLE_INPUT, "Police Salaire Rang 14", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:policerang15(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 1 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du police ou le leader.");
	Dialog_Show(playerid, policeRank15, DIALOG_STYLE_INPUT, "Police Salaire Rang 15", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang1(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank1, DIALOG_STYLE_INPUT, "swat Salaire Rang 1", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang2(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank2, DIALOG_STYLE_INPUT, "swat Salaire Rang 2", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang3(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank3, DIALOG_STYLE_INPUT, "swat Salaire Rang 3", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang4(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank4, DIALOG_STYLE_INPUT, "swat Salaire Rang 4", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang5(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank5, DIALOG_STYLE_INPUT, "swat Salaire Rang 5", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang6(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank6, DIALOG_STYLE_INPUT, "swat Salaire Rang 6", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang7(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank7, DIALOG_STYLE_INPUT, "swat Salaire Rang 7", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang8(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank8, DIALOG_STYLE_INPUT, "swat Salaire Rang 8", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang9(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank9, DIALOG_STYLE_INPUT, "swat Salaire Rang 9", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang10(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank10, DIALOG_STYLE_INPUT, "swat Salaire Rang 10", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang11(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank11, DIALOG_STYLE_INPUT, "swat Salaire Rang 11", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang12(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank12, DIALOG_STYLE_INPUT, "swat Salaire Rang 12", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang13(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank13, DIALOG_STYLE_INPUT, "swat Salaire Rang 13", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang14(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank14, DIALOG_STYLE_INPUT, "swat Salaire Rang 14", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:swatrang15(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du swat ou le leader.");
	Dialog_Show(playerid, swatRank15, DIALOG_STYLE_INPUT, "swat Salaire Rang 15", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
//salaire uregent
CMD:urgentisterang1(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank1, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 1", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang2(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank2, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 2", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang3(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank3, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 3", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang4(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank4, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 4", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang5(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank5, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 5", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang6(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank6, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 6", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang7(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank7, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 7", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang8(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank8, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 8", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang9(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank9, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 9", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang10(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank10, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 10", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang11(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank11, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 11", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang12(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank12, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 12", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang13(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank13, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 13", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang14(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank14, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 14", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:urgentisterang15(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][5] == 0 && PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "Tu n'est pas du urgentiste ou le leader.");
	Dialog_Show(playerid, urgentisteRank15, DIALOG_STYLE_INPUT, "urgentiste Salaire Rang 15", "Entrée un montant pour le salaire:", "Continuer", " X ");
	return 1;
}
CMD:commencerboucher(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_BOUCHER)
   		return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 961.2307,2102.3398,1011.0276)) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous n'êtes pas dans les locaux.");
	SendClientMessage(playerid,0xF6808EF6, "Vous obtenez un emploi, allez à la boutique.");
	OldSkin[playerid] = GetPlayerSkin(playerid);
	SetPlayerSkin(playerid, 168);
	SetPlayerAttachedObject( playerid, 0, 335, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
	PlayerInJob[playerid] = 1;
	PlayerCheckPointToMeat(playerid);
    return 1;
}
CMD:quitterboucher(playerid, params[])
{
    //new stringer[900];
	new salairejobinfoid,boucherprix = info_salairejobinfo[salairejobinfoid][salairejobinfoboucher];
	new interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
	interettaxejob = floatround((float(meats[playerid]*boucherprix) / 100) * taxerevenue);
	argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
	tamere = (meats[playerid]*boucherprix) - interettaxejob;
	GivePlayerCash(playerid,tamere);
    if (PlayerData[playerid][pJob] != JOB_BOUCHER)
   		return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 961.2307,2102.3398,1011.0276)) return SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Vous n'êtes pas dans les locaux.");
    if(!PlayerInJob[playerid]){ SendClientMessage(playerid, 0xF6F6F6F6, "Vous n'avez pas commencé à travailler"); return 1; }
	PlayerInJob[playerid] = 0;
	SendJOBMessage(playerid, "Vous avez gagné %d dollars.",tamere);
	SetPlayerSkin(playerid,PlayerData[playerid][pSkin]);
	RemovePlayerAttachedObject(playerid,0);
	RemovePlayerAttachedObject(playerid,2);
	SetPVarInt(playerid, "meatbhp",0);
	meats[playerid] = 0;
	meatprocces[playerid] = 0;
	DisablePlayerCheckpoint(playerid);
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
CMD:ceinture(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
	{
        SendClientMessage(playerid, COLOR_WHITE, "Vous n'êtes pas dans un véhicule!");
        return 1;
    }
    if(IsPlayerInAnyVehicle(playerid) == 1 && SeatbeltStatus[playerid] == 0)
	{
        SeatbeltStatus[playerid] = 1;
        if(IsAMotorBike(GetPlayerVehicleID(playerid)))
		{
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s met le casque a l'aide de ses deux mains.", ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "Vous avez mis votre casque.");
			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][92]);
			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][93]);
			ApplyAnimation(playerid,"SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
			SetPlayerAttachedObject(playerid, 6, 18978, 2,0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000);
			EditAttachedObject(playerid, 6);
			
        }
        else
		{
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Attache sa ceinture a l'aide de sa main droite.", ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "Vous avez mis votre ceinture de sécurité.");
			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][92]);
			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][94]);
			SetPlayerAttachedObject(playerid, 6, 18634, 7,0.00, 0.10, 0.35, -35.224993, 45.215, 1.50, 5.00,1.500, 1.50,0xAFAFAFAA);

        }

    }
    else if(IsPlayerInAnyVehicle(playerid) == 1 && SeatbeltStatus[playerid] == 1)
	{
        SeatbeltStatus[playerid] = 0;
		if(IsAMotorBike(GetPlayerVehicleID(playerid)))
		{
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s enleve sont casque a l'aide de ses deux mains.", ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "Vous avez enlevé votre casque.");
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][93]);
			RemovePlayerAttachedObject(playerid, 6);
        }
        else
		{
            //format(string, sizeof(string), "* %s atteint pour leur ceinture de sécurité, et il déboucle.", GetPlayerName(playerid));
            //SCBubble(playerid,string,true,0xFFFF00AA,10,5000);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s détache sa ceinture a l'aide de sa main droite.", ReturnName(playerid, 0));
			SendClientMessage(playerid, COLOR_WHITE, "Vous avez détacher votre ceinture de sécurité.");
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][94]);
			RemovePlayerAttachedObject(playerid, 6);
        }
    }
    return 1;
}
CMD:mettrelefeu(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][8] == 0)
	    return SendErrorMessage(playerid, "Tu n'est pas membre d'une faction illégale.");
	if (!Inventory_HasItem(playerid, "Jerrican"))
		return SendErrorMessage(playerid,"Tu n'a pas de jerrican.");
	static Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	//mettre les position de feu + la mission + enlever le jerrican apres chaque truc de feux + envoie de message pour retour au bot
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1271.6312,295.0221,19.5547) && mission1[playerid] == 1)//feu 1
	{
		g_aFireObjects[0] = CreateDynamicObject(18691, 1275.4296,297.2122,17.2547, 0.0, 0.0, 0.0);//17.2547
		g_aFireObjects[1] = CreateDynamicObject(18691, 1270.1641,299.4117,17.2547, 0.0, 0.0, 0.0);
		g_aFireObjects[2] = CreateDynamicObject(18691, 1267.6176,293.3184,17.2547, 0.0, 0.0, 0.0);
		g_aFireObjects[3] = CreateDynamicObject(18691, 1272.7574,291.2477,17.2547, 0.0, 0.0, 0.0);
		g_aFireObjects[4] = CreateDynamicObject(18691, 1269.9258,293.8344,17.2547, 0.0, 0.0, 0.0);
		g_aFireObjects[5] = CreateDynamicObject(18691, 1272.5771,296.9686,17.2547, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s met le feu a l'endroit", ReturnName(playerid, 0));
		Inventory_Remove(playerid, "Jerrican");
		SendServerMessage(playerid, "Aller revoir le bot pour récuperer votre argent.");
		mission1[playerid] = 2;
		GetDynamicObjectPos(g_aFireObjects[0], x, y, z);
		foreach (new i : Player)
		{
			if (FactionData[facass][factionacces][5] == 1) {Waypoint_Set(i, "AU FEU!", x, y, z);}
		}
		CreateExplosion(x, y, z, 12, 5.0);
		if(FactionData[facass][factionacces][5] == 1)
		{ SendServerMessage(playerid, "RADIO: Un incendie a été repéré au %s (marquée sur la carte).", GetLocation(x,y,z));}
	}
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 1393.7836,462.0495,20.3864)&& mission1[playerid] == 1)//feu 2
	{
		g_aFireObjects[0] = CreateDynamicObject(18691, 1395.1378,464.5277,17.8457, 0.0, 0.0, 0.0);
		g_aFireObjects[1] = CreateDynamicObject(18691, 1394.2600,460.4635,17.8930, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s met le feu a l'endroit", ReturnName(playerid, 0));
		Inventory_Remove(playerid, "Jerrican");
		SendServerMessage(playerid, "Aller revoir le bot pour récuperer votre argent.");
		mission1[playerid] = 2;
		GetDynamicObjectPos(g_aFireObjects[0], x, y, z);
		foreach (new i : Player)
		{
			if (FactionData[facass][factionacces][5] == 1) {Waypoint_Set(i, "AU FEU!", x, y, z);}
		}
		CreateExplosion(x, y, z, 12, 5.0);
		if(FactionData[facass][factionacces][5] == 1)
		{ SendServerMessage(playerid, "RADIO: Un incendie a été repéré au %s (marquée sur la carte).", GetLocation(x,y,z));}
	}
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 245.1169,-43.5079,1.5853)&& mission1[playerid] == 1)//feu 3
	{
		g_aFireObjects[0] = CreateDynamicObject(18691, 243.9383,-45.6670,-0.8853, 0.0, 0.0, 0.0);
		g_aFireObjects[1] = CreateDynamicObject(18691, 246.8790,-43.1316,-0.8853, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s met le feu a l'endroit", ReturnName(playerid, 0));
		Inventory_Remove(playerid, "Jerrican");
		SendServerMessage(playerid, "Aller revoir le bot pour récuperer votre argent.");
		mission1[playerid] = 2;
		GetDynamicObjectPos(g_aFireObjects[0], x, y, z);
		foreach (new i : Player)
		{
			if (FactionData[facass][factionacces][5] == 1) {Waypoint_Set(i, "AU FEU!", x, y, z);}
		}
		CreateExplosion(x, y, z, 12, 5.0);
		if(FactionData[facass][factionacces][5] == 1)
		{ SendServerMessage(playerid, "RADIO: Un incendie a été repéré au %s (marquée sur la carte).", GetLocation(x,y,z));}

	}
	if(IsPlayerInRangeOfPoint(playerid, 5.0,246.7708,-288.1205,1.5836)&& mission1[playerid] == 1)//feu 4
	{
		g_aFireObjects[0] = CreateDynamicObject(18691, 248.6673,-287.1047,-0.8836, 0.0, 0.0, 0.0);
		g_aFireObjects[1] = CreateDynamicObject(18691, 248.0654,-290.4258,-0.8781, 0.0, 0.0, 0.0);
		g_aFireObjects[2] = CreateDynamicObject(18691, 247.9062,-284.6511,-0.8836, 0.0, 0.0, 0.0);
		g_aFireObjects[3] = CreateDynamicObject(18691, 241.9393,-288.0827,-0.8781, 0.0, 0.0, 0.0);
		g_aFireObjects[4] = CreateDynamicObject(18691, 253.2502,-290.7008,-0.8781, 0.0, 0.0, 0.0);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s met le feu a l'endroit", ReturnName(playerid, 0));
		Inventory_Remove(playerid, "Jerrican");
		SendServerMessage(playerid, "Aller revoir le bot pour récuperer votre argent.");
		mission1[playerid] = 2;
		GetDynamicObjectPos(g_aFireObjects[0], x, y, z);
		foreach (new i : Player)
		{
			if (FactionData[facass][factionacces][5] == 1) {Waypoint_Set(i, "AU FEU!", x, y, z);}
		}
		CreateExplosion(x, y, z, 12, 5.0);
		if(FactionData[facass][factionacces][5] == 1)
		{ SendServerMessage(playerid, "RADIO: Un incendie a été repéré au %s (marquée sur la carte).", GetLocation(x,y,z));}
	}
	return 1;
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
CMD:creermatos(playerid,params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][13] == 0)
		return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if(!IsPlayerInRangeOfPoint(playerid, 8.0,2580.9214,-1219.2292,1022.0316)) return SendErrorMessage(playerid,"Vous n'est pas dans l'entrepòt.");
	Dialog_Show(playerid,creermatos,DIALOG_STYLE_TABLIST,"Création d'arme la liste","{ffffff}AK-47: \t{ff3300}Matos : 200{ffffff}\n{ffffff}M4: \t{ff3300}Matos : 250{ffffff}\n{ffffff}MP5: \t{ff3300}Matos : 150{ffffff}\n{ffffff}Sniper: \t{ff3300}Matos : 550{ffffff}\n{ffffff}Rifle: \t{ff3300}Matos : 450{ffffff}\n{ffffff}Chargeur x 10: \t{ff3300}Matos : 100{ffffff}\n{ffffff}Boite de munitions x 10: \t{ff3300}Matos : 150{ffffff}\n{ffffff}Shot-Gun: \t{ff3300}Matos : 150{ffffff}\n{ffffff}Tec-9: \t{ff3300}Matos : 100{ffffff}\n{ffffff}UZI: \t{ff3300}Matos : 100{ffffff}\n{ffffff}Colt .45: \t{ff3300}Matos : 50{ffffff}\n{ffffff}Dynamite: \t{ff3300}Matos : 1000{ffffff}\n{ffffff}Decodeur: \t{ff3300}Matos : 1000{ffffff}","Créer","Fermer");	
	return 1;
}
CMD:rem(playerid,params[])
{
    new currentveh;
    currentveh = GetPlayerVehicleID(playerid);
    DetachTrailerFromVehicle(currentveh);
    return 1;
}
CMD:credits(playerid,params[])
{
	Dialog_Show(playerid,CREDITS,DIALOG_STYLE_MSGBOX,"Crédits","Script South-Central 0.21 par Emmet\nModification Fait par Tysanio\nAnciennement cjeje84  & Thecycy2a , communauté russe et autre qui on aidé par le passé\nMerci a Lokii pour le systeme de Stamina\nMapping Gang ajouter fait par Kova\nMerci pour l'équipe de UG pour se tout nouveau serveur sur Vice-City","Fermer","");
	return 1;
}
//dynamite
CMD:dynamite(playerid, params[])
{
	if (IsPlayerInRangeOfPoint(playerid,4.0,1435.3141, -980.7271, 983.0049))
	{
		if (!Inventory_HasItem(playerid, "Dynamite")) return SendErrorMessage(playerid, "Vous n'avez pas de dynamite.");
        if(start1[playerid] != 0) return SendErrorMessage(playerid, "Braquage déja en cours...");
        SendClientMessage(playerid, 0xFF8000AA, "{62B81F}Sa va pété dans 12 secondes a l'abrie!");
        ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
        new Float:x, Float:y, Float:z, Float:angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);
        x += floatsin(-angle, degrees);
        y += floatcos(-angle, degrees);
        Inventory_Remove(playerid, "Dynamite",1); start1[playerid] = 1;
		objectbank[playerid] = CreateDynamicObject(1654, x, y, z-0.5, 0, 0, 0);
		SetTimerEx("startonboom",12000,0,"d",playerid);
	}
	else
	{
		if (!Inventory_HasItem(playerid, "Dynamite"))
			return SendErrorMessage(playerid, "Vous n'avez pas de dynamite.");
		Inventory_Remove(playerid, "Dynamite",1);
		GetPointInAngleOfPlayer(playerid, Float:dx, Float:dy, Float:dz, 0.7, 0.0);
		dynamiteobject = CreateDynamicObject(1654, Float:dx, Float:dy, Float:dz-0.9414, 338.00000, -91.00000, -127.00000);
		dynamite_Timer = SetTimer("DynamiteTime", 30000, false);
		SendServerMessage(playerid,"30 secondes avant explosion");
		ApplyAnimation(playerid,"BOMBER","BOM_Plant_2Idle",4.1,0,0,0,0,0,1);
	}
	return 1;
}
CMD:decodeur(playerid,params[])
{
	if (!Inventory_HasItem(playerid, "Decodeur"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de decodeur.");
	Dialog_Show(playerid, decodeur, DIALOG_STYLE_LIST, "Decoder le mot de passe", "Voulez-vous décodé le mot de passe  d'une gate?\nVoler un atm?", "Valider", "Annuler");
	return 1;
}
//serveur setting
CMD:serveur(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
    	return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new serveurinfo;
	Dialog_Show(playerid,serveur,DIALOG_STYLE_TABLIST,"Serveur setting",serveursetting1,"Valider","Fermer",info_serveursetting[serveurinfo][settingoocactive],info_serveursetting[serveurinfo][settingpmactive],info_serveursetting[serveurinfo][settingbraquagenpcactive],info_serveursetting[serveurinfo][settingbraquagebankactive],info_serveursetting[serveurinfo][settingafkactive],info_serveursetting[serveurinfo][settingafktime],info_serveursetting[serveurinfo][settingmotd],info_serveursetting[serveurinfo][settingvilleactive],info_serveursetting[serveurinfo][settingnouveau],info_serveursetting[serveurinfo][settingpolice],info_serveursetting[serveurinfo][settingswat],info_serveursetting[serveurinfo][settingwl]);
	return 1;
}
//bracelet electronic
CMD:blocaliser(playerid, params[])
{
	if (IsACopf(playerid))
	{ShowPlayerFooter(playerid, "Vous devez être un agent du LSPD.");return 1;}

	if (PlayerData[playerid][pFactionRank] < 3)
	{ShowPlayerFooter(playerid, "Vous n'avez pas la permission d'utiliser cette commande, il faut être rang 3.");return 1;}
    static userid;
	if (sscanf(params, "u", userid))
	return SendSyntaxMessage(playerid, "/blocaliser <Prénom_Nom/ID>");
	if (PlayerData[userid][pBracelet] == 0)
	{ShowPlayerFooter(playerid, "Cette personne n'a pas de  bracelet");return 1;}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(userid, x, y, z);

	SetPlayerCheckpoint(playerid, x, y, z, 4.0);
	SendServerMessage(playerid, "Ce bracelet est localisé à %s (Checkpoint)",GetLocation(x, y, z));
	return 1;
}
CMD:bracelet(playerid, params[])
{
	if (IsACopf(playerid))
	{ShowPlayerFooter(playerid, "Vous devez être un agent du LSPD.");return 1;}
	if (PlayerData[playerid][pFactionRank] < 3)
	{ShowPlayerFooter(playerid, "Vous n'avez pas la permission d'utiliser cette commande, il faut être rang 3.");return 1;}
    static userid,prox;
	if (sscanf(params, "ud", userid,prox))
	return SendSyntaxMessage(playerid, "/bracelet <Prénom_Nom/ID> <Proximité>");

	if (PlayerData[userid][pBracelet] != 0)
	{ShowPlayerFooter(playerid, "Cette personne a déjà un  bracelet");return 1;}

	if (playerid == userid)
	{ShowPlayerFooter(playerid, "Vous ne pouvez pas vous mettre un bracelet vous même.");return 1;}

	if (prox < 1 || prox > 3 )
	{ShowPlayerFooter(playerid, "Proximité 1(Petite 1500 Mètre) Proximité 2(Moyenne 2500 Mètre) Proximité 3(Grande 3500 Mètre)");return 1;}

	PlayerData[userid][pBracelet] = 1;
	PlayerData[userid][pBraceletProx] = prox;

	SendServerMessage(playerid, "Vous avez attaché un bracelet éléctronique à %s avec une distance du comico à %s", ReturnName(userid),ProxMax(prox));
	SendServerMessage(userid, "L'agent %s vous a  attaché un bracelet éléctronique avec une distance du comico à %s (/disatancec)", ReturnName(playerid),ProxMax(prox));
	return 1;
}

CMD:distancec(playerid, params[]) return SendServerMessage(playerid, "Vous êtes à %.0f mètres du commissariat faîtes attention.", GetPlayerDistanceFromComico(playerid));
CMD:ebracelet(playerid, params[])
{
	if (IsACopf(playerid))
	{ShowPlayerFooter(playerid, "Vous devez être un agent du LSPD.");return 1;}
	if (PlayerData[playerid][pFactionRank] < 3)
	{ShowPlayerFooter(playerid, "Vous n'avez pas la permission d'utiliser cette commande, il faut être rang 3.");return 1;}
	static userid;
	if (sscanf(params, "u", userid))
	return SendSyntaxMessage(playerid, "/ebracelet <Prénom_Nom/ID>");
	if (playerid == userid)
	{ShowPlayerFooter(playerid, "Vous ne pouvez pas vous enlevez un bracelet vous même.");return 1;}
	if (PlayerData[userid][pBracelet] == 0)
	{ShowPlayerFooter(playerid, "Cette personne n'a pas de  bracelet");return 1;}
	PlayerData[userid][pBracelet] = 0;
	PlayerData[userid][pBraceletProx] = 0;
	//SQL_SaveCharacter(userid);
	SendServerMessage(playerid, "Vous avez dettaché un bracelet éléctronique à %s ", ReturnName(userid));
	SendServerMessage(userid, "L'agent %s vous a dettaché un bracelet éléctronique.", ReturnName(playerid));
	return 1;
}
//louer veh
CMD:louerveh(playerid, params[])
{
	new voicar = GetPlayerVehicleID(playerid),id = Car_GetID(voicar),count;
	if (PlayerData[playerid][pLocaID] > 0) return SendVehiculeMessage(playerid, "Vous louez déjà un véhicule (/delouerveh)");
	if (GetPlayerMoney(playerid) < 200) return SendVehiculeMessage(playerid,"Vous devez avoir $200 pour louer un véhicule.");
	if(CarData[id][carLoca] == 0) return SendVehiculeMessage(playerid,"Ce véhicule n'est pas louable.");
	if (CarData[id][carfuel] < 1)
		return SendErrorMessage(playerid, "Ce vehicule est en panne d'essence.");
	if(CarData[id][carLocaID] > 0) return SendVehiculeMessage(playerid,"Ce véhicule a été louer par une autre personne.");

	PlayerData[playerid][pLocaID] = CarData[id][carID];
	CarData[id][carLocaID] = PlayerData[playerid][pID];
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	TSM(playerid, "~r~/delouerveh pour delouer le vehicule\n~w~Oublier pas de delouer quand vous avez fini avec!\nProche de l'auto-ecole", "Location", 5000, 0x00000088, 20.0000, 110.000000, 130.000000);
	GiveMoney(playerid,-200);
	for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[i][factionExists] && FactionData[i][factionacces][13] == 1) {
		count++;
	}
	for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][13] == 1)
	{
		new aye = 200 / count;
		if(FactionData[ii][factionacces][13] == 1)
		{
			FactionData[ii][factioncoffre] += aye;
			Faction_Save(ii);
		}
		SendServerMessage(playerid,"%d nombre de faction qui a le 12 et sa fait %d",count,aye);
	}
    //DernieVehLoc[playerid]=voicar;
    //DernieVehLocID[playerid]=id;
	Car_Save(id);
    Log_Write("logs/louerveh.txt", "[%s] %s a louer le vehicule id %d.", ReturnDate(), ReturnName(playerid, 0), GetPlayerVehicleID(playerid));
	return 1;
}

CMD:delouerveh(playerid, params[])
{
	new voicar = GetPlayerVehicleID(playerid),id = Car_GetID(voicar);
	if (!IsPlayerInRangeOfPoint(playerid, 20.0,2055.8477,-1912.5133,13.5469) && !PlayerData[playerid][pAdmin]) return SendVehiculeMessage(playerid,"Veuillez remettre le véhicule a coté de l'auto-école.");
	if (PlayerData[playerid][pLocaID] == 0) return SendVehiculeMessage(playerid,"Vous ne louez pas de véhicule.");
	if (PlayerData[playerid][pLocaID] != CarData[id][carID]) return SendVehiculeMessage(playerid, "Vous ne louez pas ce véhicule.");
	if (CarData[id][carfuel] < 15)
		return SendErrorMessage(playerid, "Ce vehicule manque d'essence un minimun de 15 pourcent est requis pour le délouer.");
	PlayerData[playerid][pLocaID] = 0;
	CarData[id][carLocaID] = 0;
	CarData[DernieVehLocID[playerid]][carLocked] = 0;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SetEngineStatus(voicar, false);
	TSM(playerid, "~r~Vehicule delouer", "Location", 5000, 0x00000088, 20.0000, 110.000000, 130.000000);
    //DernieVehLoc[playerid]=-1;
    //DernieVehLocID[playerid]=-1;
	Car_Save(id);
	Log_Write("logs/louerveh.txt", "[%s] %s a délouer le vehicule id %d.", ReturnDate(), ReturnName(playerid, 0), CarData[id][carID]);
	//SetVehicleParamsEx(id, 0, lights, alarm, doors, bonnet, boot, objective);
	return 1;
}
//micro pour le FBI
CMD:micro(playerid, params[])
{
	new targetid,choose[30],factionid = PlayerData[playerid][pFaction];
	if (FactionData[factionid][factionacces][3] == 0) {ShowPlayerFooter(playerid, "Vous devez être un agent du FBI."); return 1;}
	if(sscanf(params, "us[30]", targetid, choose)) SendSyntaxMessage(playerid, "{DEAD61}INFO: {FFFFFF}/micro <Prénom_Nom/ID> [on/off]");
	else
	{
		if (playerid == targetid) return SendErrorMessage(playerid, "Vous ne pouvez pas sur vous même.");
		if (!IsPlayerConnected(targetid)) return SendErrorMessage(playerid,, "Ce joueur n'est pas connecté.");
		if(IsPlayerNearPlayer(playerid,targetid,5.0))
		{
			if(strcmp(choose, "on", true) == 0)
			{
				SendServerMessage(playerid, "Micro placé sur %s.", ReturnName(targetid, 0));
				SendServerMessage(targetid, "%s a placé un micro sur vous.", ReturnName(playerid, 0));
				micro[targetid] = 1;
				micropl[targetid] = playerid;
			}
			else if(strcmp(choose, "off", true) == 0)
			{
				SendServerMessage(playerid, "Vous avez retiré le micro qui était placé sur %s.", ReturnName(targetid, 0));
				SendServerMessage(targetid, "%s a retiré le micro que vous avez sur vous.", ReturnName(playerid, 0));
				micro[targetid] = 0;
				micropl[targetid] = -1;
			}
		}
		else SendErrorMessage(playerid,"Vous n'êtes pas assez près de ce joueur.");
	}
	return 1;
}
CMD:retirermicro(playerid, params[])
{
	if (micro[playerid] == 0) return SendErrorMessage(playerid, "Vous n'avez pas de micro sur vous.");
	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "%s vien de retirer le micro placer sur lui.", ReturnName(playerid, 0));
	if(IsPlayerConnected(micro[playerid])) SendClientMessage(micro[playerid], COLOR_PURPLE,"* Des bruits statiques du micro ce font entendre, comme si il avait était arracher  *");
	micro[playerid] = 0;
	micropl[playerid] = -1;
	return 1;
}
//prêt de vehicule
CMD:vpreter(playerid, params[])
{
	new Float:fX,Float:fY,Float:fZ;
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	if (PlayerData[playerid][pCarD] > 0) {
	new voit = PlayerData[playerid][pCarD];
    new id = Car_GetID(voit);
	GetVehiclePos(CarData[id][carVehicle], fX, fY, fZ);
	SendClientMessageEx(playerid, COLOR_YELLOW, "*Véhicule preté ID: %d | Modèle: %s | Localisation: %s", CarData[id][carVehicle], ReturnVehicleModelName(CarData[id][carModel]), GetLocation(fX, fY, fZ));
	}
	else
	SendClientMessage(playerid, COLOR_WHITE, "Vous ne possédez pas de véhicules prété");
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}
CMD:vdouble(playerid, params[])
{
	static userid,idcar;
	if (sscanf(params, "ud", userid,idcar))
	return SendSyntaxMessage(playerid, "/vdouble <Prénom_Nom/ID> <ID du véhicule - /proprieter>");
	if (userid == INVALID_PLAYER_ID || userid == playerid )
	return SendErrorMessage(playerid, "Ce joueur n'est pas valide.");
	if (CarData[idcar][carDouble] > 0)
	return SendErrorMessage(playerid, "Vous avez déjà passer le double à cette personne.");
	if (CarData[idcar][carOwner] != PlayerData[playerid][pID] && !IsValidVehicle(idcar))
	return SendErrorMessage(playerid, "Ce n'est pas ton véhicule");
	if (PlayerData[userid][pCarD] > 0)
	return SendErrorMessage(playerid, "Cette personne a déjà un véhicule preté");
	if (idcar < 1 || idcar > MAX_VEHICLES || !IsValidVehicle(idcar))
	return SendErrorMessage(playerid, "Mauvais vehicle ID.");
	new id = Car_GetID(idcar);
	if (id != -1)
	{
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s préte les clefs de sa %s à %s.", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[idcar][carModel]), ReturnName(userid, 0));
		CarData[id][carDouble] = PlayerData[userid][pID];
		PlayerData[userid][pCarD] = idcar;
		Car_Save(id);
		//SQL_SaveCharacter(userid);
	}
	return 1;
}
CMD:vjeter(playerid, params[])
{
	new cle = PlayerData[playerid][pCarD];
	new id = Car_GetID(cle);
	if (PlayerData[playerid][pCarD] <= 0)
	return SendErrorMessage(playerid,"Vous n'avez pas de clés préter.");
	if (id != -1)
	{
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s a jeter les double de clef de la %s", ReturnName(playerid, 0), ReturnVehicleModelName(cle));
		CarData[id][carDouble] = 0;
		PlayerData[playerid][pCarD] = 0;
		Car_Save(id);
		//SQL_SaveCharacter(playerid);
	}
	return 1;
}
//sabot veh
CMD:sabot(playerid, params[])
{
	new id = -1,prix,facass = PlayerData[playerid][pFaction];
	if ((id = Car_Nearest(playerid)) != -1)
	{
		if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");

		if (PlayerData[playerid][pFactionRank] < 3)
		return SendErrorMessage(playerid, "Vous n'avez pas la permission d'utiliser cette commande, il faut être rang 3.");

		if(sscanf(params, "d",prix)) return
		SendSyntaxMessage(playerid, "/sabot <prix ($1 à $1000)>");

		if (CarData[id][carOwner] == 0)
		return SendErrorMessage(playerid, "Ce véhicule ne peut contenir un sabot.");

		if (CarData[id][carSabot] != 0 )
		return SendErrorMessage(playerid, "Ce véhicule a déjà un sabot.");
		
		if (prix < 1 || prix > 1000)
		return SendErrorMessage(playerid, "Pas en dessous de $1 ou plus de $1,000.");
		
		CarData[id][carSabot] = 1;
		CarData[id][carSabPri] = prix;
		Car_Save(id);
		if(FactionData[facass][factionacces][1] == 1)
		{ SendServerMessage(playerid, "%s a placé un sabot sur le véhicule ID: %d.",ReturnName(playerid, 0), CarData[id][carVehicle]);}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas près d'un véhicule.");
	return 1;
}

CMD:rsabot(playerid, params[])
{
	new id = -1,facass = PlayerData[playerid][pFaction];
	if ((id = Car_Nearest(playerid)) != -1)
	{
		if (FactionData[facass][factionacces][1] == 0) return SendErrorMessage(playerid, "Vous n'êtes n'avez pas l'acces a cette commande.");
		if (PlayerData[playerid][pFactionRank] < 3)
		return SendErrorMessage(playerid, "Vous n'avez pas la permission d'utiliser cette commande, il faut être rang 3.");
		if (CarData[id][carSabot] == 0)
		return SendErrorMessage(playerid, "Ce véhicule n'as pas de sabot");
		CarData[id][carSabot] = 0;
		CarData[id][carSabPri] = 0;
		Car_Save(id);
		if(FactionData[facass][factionacces][1] == 1)
		{ SendServerMessage(playerid, "%s a retiré un sabot sur le véhicule ID: %d.",ReturnName(playerid, 0), CarData[id][carVehicle]);}
	}
	else SendErrorMessage(playerid, "Vous n'êtes pas près d'un véhicule.");
	return 1;
}

CMD:payersabot(playerid, params[])
{
	new id = -1,moneyentrepriseid,facass = PlayerData[playerid][pFaction];
	if ((id = Car_Nearest(playerid)) != -1)
	{
		if (GetMoney(playerid) < CarData[id][carSabPri])
		return SendErrorMessage(playerid, "Vous n'avez pas assez d'argent pour payer.");
		if (CarData[id][carSabot] == 0)
		return SendErrorMessage(playerid, "Ce véhicule n'as pas de sabot");
		for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[facass][factionacces][1] == 1) argent_entreprise[moneyentrepriseid][argentmairie] += CarData[id][carSabPri];
	    GiveMoney(playerid,-CarData[id][carSabPri]);
		SendVehiculeMessage(playerid, "Vous avez payez le sabot pour %d$",CarData[id][carSabPri]);
		CarData[id][carSabot] = 0;
		CarData[id][carSabPri] = 0;
		Car_Save(id);

	}
	else SendErrorMessage(playerid, "Vous n'êtes pas près d'un véhicule.");
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
//voler veh
CMD:trafiquerfils(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid),id = Car_GetID(vehicleid);
	if (!IsEngineVehicle(vehicleid))
		return SendErrorMessage(playerid, "Vous devez être dans un véhicule.");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "Vous devez être conducteur pour utiliser cette commande.");
	if (Car_IsOwner(playerid, id) || CarData[id][carDouble] == PlayerData[playerid][pID])
		return SendErrorMessage(playerid, "Vous ne pouvez pas trafiquer un véhicule qui vous appartient/preté.");
	if (CarData[id][carSabot] != 0 && GetEngineStatus(vehicleid) == 0)
		return SendErrorMessage(playerid, "Ce véhicule a un sabot, Utilisez /payersabot pour le retirer ($%d)",CarData[id][carSabPri]);
	if(CarData[id][carLoca] == 1)
		return SendErrorMessage(playerid, "Vous ne pouvez pas trafiqué un véhicule de location.");
    if (CarData[id][carfuel] < 1)
		return SendVehiculeMessage(playerid, "Le reservoir est vide..");
	if (ReturnVehicleHealth(vehicleid) <= 300)
	{
        ShowPlayerFooter(playerid, "Le vehicule ~r~est HS~w~");
        return 1;
 	}
 	if(TrafiqueFilsTimer[playerid] != 0)
 	    return SendErrorMessage(playerid, "Vous êtes déjà en train de trafiquer les fils.");
    switch (GetEngineStatus(vehicleid))
	{
		case false:
		{
			SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s déchire les fils, puis tente de faire démarrer le véhicule..", ReturnName(playerid, 0));
     		TrafiqueFilsTimer[playerid] = 60;
			TrafiqueFilsKillTimer[playerid] = SetTimerEx("TrafiqueFils", 1000, false, "i", playerid);
			GameTextForPlayer(playerid, "~r~60 ~w~secondes ...", 2000, 5);
		}
		case true:
		{
		    SendErrorMessage(playerid, "Le véhicule est déjà démarrer.");
		}
	}
	return 1;
}
//annonce admin
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
//location maison
CMD:locaprix(playerid, params[])
{
	new houseid = -1,prix;
	houseid = House_Nearest(playerid);
	if (sscanf(params, "d", prix))
	return SendSyntaxMessage(playerid, "/locaprix [1$-2000$] (0 pour desactiver la location)");
	if ((houseid = (House_Inside(playerid) == -1) ? (House_Nearest(playerid)) : (House_Inside(playerid))) != -1 && House_IsOwner(playerid, houseid))
	{
		if (prix < -1 || prix > 2000)
			return SendErrorMessage(playerid, "Prix entre 0$ et 2000$ (0 pour desactiver la location).");
		else
		{
			HouseData[houseid][houseLocation] = prix;
			House_Save(houseid);
			if (prix > 0) {SendServerMessage(playerid, "La location est maintenant à %d$", prix);}
			else { SendServerMessage(playerid, "La location est maintenant désactivée");}
		}
	}
	else return SendErrorMessage(playerid, "Tu n'est pas à coté de ta maison");
	return 1;
}
CMD:locamax(playerid, params[])
{
	new houseid = -1,locamax;
	houseid = House_Nearest(playerid);

	if (sscanf(params, "d", locamax))
	return SendSyntaxMessage(playerid, "/locamax [nombre max]");
	
	if ((houseid = (House_Inside(playerid) == -1) ? (House_Nearest(playerid)) : (House_Inside(playerid))) != -1 && House_IsOwner(playerid, houseid))
	{
		if (locamax < -1 || locamax > 20)
			return SendErrorMessage(playerid, "Le nombre de locataire max est trops élévé");
		else
		{
			HouseData[houseid][houseMaxLoc] = locamax;
			House_Save(houseid);
			SendServerMessage(playerid, "Le nombre de locataire maximum est maintenant à %d", locamax);
		}
	}
	else return SendErrorMessage(playerid, "Tu n'est pas à coté de ta maison");
	return 1;
}
CMD:resetlocamax(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	return SendErrorMessage(playerid, "Vous n'avez pas la permission d'utiliser cette commande.");
	for (new i = 0; i < MAX_HOUSES; i ++)
	{
		HouseData[i][houseMaxLoc] = 0;
		HouseData[i][houseLocation] = 0;
		House_Save(i);
	}
	SendServerMessage(playerid, "Tu a reset le nombre max ne le fait plus !");
	return 1;
}
CMD:louermaison(playerid, params[])
{
	if (Inventory_Items(playerid) >= MAX_INVENTORY - 1)
		return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour louer une maison");
	new id = -1,id1 = Inventory_Add(playerid,"Clef de maison",11746);
	id = House_Nearest(playerid);
	if (PlayerData[playerid][pLocaMaisonID] > 0) return SendServerMessage(playerid, "Vous louez déjà une maison (/delouermaison)");
	if(HouseData[id][houseMaxLoc] == HouseData[id][houseLocNum] ||  HouseData[id][houseMaxLoc] == 0) return SendServerMessage(playerid,"Cette maison n'est pas louable.");
	if (id1 == -1)
	    return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	PlayerData[playerid][pLocaMaisonID] = HouseData[id][houseID];
	HouseData[id][houseLocNum] += 1;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	ShowPlayerFooter(playerid, "~r~/delouermaison pour delouer la maison");
	House_Save(id);
	return 1;
}
//carte d'identier
CMD:carte(playerid, params[])
{
	static userid,string[260];

	if (sscanf(params, "u", userid))
	return SendSyntaxMessage(playerid, "/(c)arte <Prénom_Nom/ID>");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	return SendErrorMessage(playerid, "Ce joueur n'est pas près de vous.");

	SendClientMessage(userid, COLOR_GREY, "-----------------------------------------------------------");

	format(string, sizeof(string), "{FFFFFF}Nom:{C4E5FF} %s {FFFFFF}",ReturnName(playerid, 0));
	SendClientMessageEx(userid, COLOR_WHITE, string);

	format(string, sizeof(string), "{FFFFFF}Sexe:{C4E5FF} %s {FFFFFF}| Naissance:{C4E5FF} %s {FFFFFF}| Origine:{C4E5FF} %s", (PlayerData[playerid][pGender] == 2) ? ("Femme") : ("Homme"), PlayerData[playerid][pBirthdate], PlayerData[playerid][pOrigin]);
	SendClientMessageEx(userid, COLOR_WHITE, string);

	SendClientMessage(userid, COLOR_GREY, "-----------------------------------------------------------");
	SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "%s récupère sa carte d'identité qu'il montre à %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}
//limiteur
CMD:limiteur(playerid,params[])
{
	new szam;
	if(sscanf(params,"i",szam)) return SendClientMessage(playerid,-1,"INFO: /limiteur [vitesse]");
	seb[playerid] = szam;
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid,"Vous devez ètre conducteur");
	new str[128];
	format(str,128,"Le limiteur de vitesse est à : %i",szam);
	SendClientMessage(playerid,-1,str);
	return 1;
}
//batterie telephone
CMD:recharger(playerid, params[])
{
	new stockjobinfoid,id = House_Inside(playerid),vehicleid = GetPlayerVehicleID(playerid);
	if (!IsEngineVehicle(vehicleid))
	if (!Inventory_HasItem(playerid, "Chargeur telephone"))
	    return SendErrorMessage(playerid, "Vous n'avez pas de chargeur de téléphone sur toi.");
	if (id != -1)
	{
     	if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
		PlayerData[playerid][pAcom] = 100;
		SendServerMessage(playerid, "Votre Batterie a été recharger");
		//generateur
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 5;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 5;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 5;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 5;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 5;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
		stockjobinfosave(stockjobinfoid);
	}
	else if(IsEngineVehicle(vehicleid))
	{
		PlayerData[playerid][pAcom] = 100;
		SendServerMessage(playerid, "Votre Batterie a été recharger dans votre vehicule.");
	}
	else {SendErrorMessage(playerid, "Tu doit être dans une maison ou dans un vehicule.");}
	return 1;
}
CMD:poserboite(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas dans cette entreprise.");
	if (PlayerData[playerid][pCarryCrate] == -1)
	    return SendErrorMessage(playerid, "Tu n'as pas de boite dans les mains.");
	if (PlayerData[playerid][pCrafting])
	    return SendErrorMessage(playerid, "Tu à déja une boite.");
	if (CrateData[PlayerData[playerid][pCarryCrate]][crateType] < 9 || CrateData[PlayerData[playerid][pCarryCrate]][crateType] > 19)
	    return SendErrorMessage(playerid, "Il n'y a pas de pièce dans la boite.");
    PlayerData[playerid][pCrafting] = 1;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s pose une boite et ouvre des %s.", ReturnName(playerid, 0), Crate_GetType(CrateData[PlayerData[playerid][pCarryCrate]][crateType]));
	TogglePlayerControllable(playerid, 0);
	SetTimerEx("CraftParts", 12000, false, "dd", playerid, PlayerData[playerid][pCarryCrate]);
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
CMD:tme(playerid, params[])
{
	static string[128];
	if (isnull(params))
	return SendSyntaxMessage(playerid, "/tme <action>");
	format(string, sizeof(string), "%s", params);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 1000000);
	SendClientMessageEx(playerid, COLOR_PURPLE, "Message afficher au dessus de votre tête » %s", params);
	return 1;
}
CMD:tmeoff(playerid, params[])
{
	static string[128];
	format(string, sizeof(string), "%s", params);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 100);
	SendClientMessageEx(playerid, COLOR_PURPLE, "Vous avez retirer le message qui s'afficher au dessus de votre personnage.");
	return 1;
}
//barriere
CMD:barriere(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0 && FactionData[facass][factionacces][5] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas de cette faction.");
	if(IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_GREY, "Vous ne pouvez pas être à l'intérieur d'un véhicule lors de l'utilisation de cette commande.");
		return 1;
	}
	for(new i; i<MAX_CADES; i++)
	{
		if(cade[i] == 0)
		{
			Dialog_Show(playerid, DIALOGCADES, DIALOG_STYLE_LIST, "Barricade Deployment", "Water Barrel\nDetour Sign\nSmall Roadblock\nNormal Roadblock\nNormal Barricade\nLarge Barricade", "Select", "Cancel");
			SetPVarInt(playerid, "cadeid", i);
		}
	}
	return 1;
}
CMD:destroybarriere(playerid, params[])
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][1] == 0 && FactionData[facass][factionacces][5] == 0)
	    return SendErrorMessage(playerid, "Vous n'êtes pas de cette faction.");
	if(IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_GREY, "Vous ne pouvez pas être à l'intérieur d'un véhicule lors de l'utilisation de cette commande.");
		return 1;
	}
	for(new i; i<MAX_CADES; i++)
	{
		GetDynamicObjectPos(cade[i], Position[0], Position[1], Position[2]);
		if(IsPlayerInRangeOfPoint(playerid, 5.0, Position[0], Position[1], Position[2]))
		{
			DestroyDynamicObject(cade[i]);
			cade[i] = 0;
		}
	}
	return 1;
}
//bowling
CMD:bowling(playerid,params[])
{
 	if(AbleToPlay[playerid] == 1)
	{
 		if(IsAtBowlingRoad(playerid))
 		{
       		if(BowlingStatus[playerid] != N_BOWLING_THROW)
 			{
 			    CreateBall(playerid);
				BallGoing[playerid] = SetTimerEx("BallGoingTimer",1000,false,"d",playerid);
				ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",2.2,0,0,0,0,0,1);
    		}
    		else
    		{
    		    SendErrorMessage(playerid,"Attendez les quilles!.");
    		}
		}
		else
		{
		    SendErrorMessage(playerid,"Vous êtes trop loin de l'aller.");
		}
	}
	else
	{
	    SendErrorMessage(playerid,"Aucune partie lancer!");
	}
	return 1;
}
CMD:bowlingstats(playerid,params[])
{
	new str[128];
	format(str,128,"{00CC00}Meilleur résultat: {EEEEEE}%i\n{00CC00}Strikes: {EEEEEE}%i",PlayerData[playerid][pBestScore],PlayerData[playerid][pStrike]);
	Dialog_Show(playerid,bowlingstats, DIALOG_STYLE_MSGBOX, "Vos stats du bowling", str, "Ok", "");
	return 1;
}
//caisse
CMD:creercaisse(playerid, params[])
{
	static id = -1;
    if (PlayerData[playerid][pAdmin] < 4)
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
    if (PlayerData[playerid][pAdmin] < 4)
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
	if (PlayerData[playerid][pAdmin] < 4)
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
//horse
CMD:regardercourse(playerid, params[])
{
	if(IsPlayerInPMU(playerid))
	{
		if (Prepared == 1 && RaceStarted == 1)
		{
			TogglePlayerControllable(playerid, 0);
			TextDrawShowForPlayer(playerid,BG2);
			TextDrawShowForPlayer(playerid,BG1);
			TextDrawShowForPlayer(playerid,Start2);
			TextDrawShowForPlayer(playerid,Finish2);
			TextDrawShowForPlayer(playerid,Horse1);
			TextDrawShowForPlayer(playerid,Horse2);
			TextDrawShowForPlayer(playerid,Horse3);
			TextDrawShowForPlayer(playerid,Horse4);
			TextDrawShowForPlayer(playerid,HorseNum1);
			TextDrawShowForPlayer(playerid,HorseNum2);
			TextDrawShowForPlayer(playerid,HorseNum3);
			TextDrawShowForPlayer(playerid,HorseNum4);
			TextDrawShowForPlayer(playerid,Start);
			TextDrawShowForPlayer(playerid,Finish);
			Watching[playerid] = 1;
			SendServerMessage(playerid,"Vous regardez maintenant la course.");
		}
		else return SendErrorMessage(playerid,"La course na pas commencer. Taper /parier pour parier sur un cheval.");
	}
	else return SendErrorMessage(playerid,"Vous n'êtes pas dans le PMU");
	return 1;
}
CMD:parier(playerid, params[])
{
    new horse, cash,count;
    if(!sscanf(params,"ii",horse, cash) && horse < 5 && horse > 0 && cash <= CashHigherBounds && cash >= CashLowerBounds)
    {
		if(IsPlayerInPMU(playerid))
		{
			if (GetPlayerMoney(playerid) >= cash)
			{
				if (RaceStarted == 1) return SendErrorMessage(playerid,"La course a déja commencer, Vous ne pouvez plus parier.");
				if(MoneyBet[playerid] > 0) return SendErrorMessage(playerid,"vous avez déja miser! Tapez /parier pour voir combien et sur quel cheval vous avez parier.");
				else
				{
					MoneyBet[playerid] = cash;
					GiveMoney(playerid, -cash);
					for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
						count++;
					}
					for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
					{
						new aye = cash / count;
						if(FactionData[ii][factionacces][12] == 1)
						{
							FactionData[ii][factioncoffre] += aye;
							Faction_Save(ii);
						}
					}
					BetOnHorse[playerid] = horse;
					SendServerMessage(playerid,"Vous avez miser %d $ sur le cheval %d. Attendez que la course soit fini pour voir si vous avez gagné",MoneyBet[playerid],BetOnHorse[playerid]);
				}
			}
			else return SendErrorMessage(playerid,"Vous n'avez pas asser d'argent");
		}
		else return SendErrorMessage(playerid,"Vous n'êtes pas dans le PMU");
	}
	else return SendSyntaxMessage(playerid,"/bet [cheval(1-4)][montant(%d-%d]",CashLowerBounds,CashHigherBounds);
	return 1;
}
//roulette
CMD:roulette(playerid, params[])
{
	if (PlayerData[playerid][pPlayingHours] < 50) {
		SendErrorMessage(playerid, "La roulette est bloquer il vous faut un certain nombre d'heure de jeux.");
		SendErrorMessage(playerid, "Si vous trouver cela abusif fait /abus.");
	}
	if(IsPlayerInRangeOfPoint(playerid, 5.0, -233.4578,-30.9058,1004.1461))
	{
		new moneyentrepriseid;
		if (argent_entreprise[moneyentrepriseid][argentmafiazone1] >= 500000) return SendErrorMessage(playerid,"La roulette est bloquée veuillez jouer aux autres jeux.");
		if(Actived[playerid] == 0)
		{
			SetPlayerCameraPos(playerid, -234.1554, -31.9613, 1006.1018);
			SetPlayerCameraLookAt(playerid, -233.2308, -31.5840, 1005.0424);
			ShowTd(playerid);
			SelectTextDraw(playerid, 0x9999BBBB);
			Actived[playerid] = 1;
			TogglePlayerControllable(playerid, 0);
			SendServerMessage(playerid, "La pièce mauve x 5$");
			SendServerMessage(playerid, "La pièce orange x 10$");
			return 1;
		}
		if(Actived[playerid] == 1)
		{
			TogglePlayerControllable(playerid, 1);
			SetCameraBehindPlayer(playerid);
			CancelSelectTextDraw(playerid);
			Actived[playerid] = 0;
			HideTd(playerid);
			for(new i;i<50;i++)
			{
				if(test[i] == true)
				{
					PlayerTextDrawDestroy(playerid,PlayerData[playerid][C_TD][i]);
					test[i] = false;
				}
				idy=-1;
			}
			return 1;
		}
	}
	else return SendErrorMessage(playerid,"Vous n'etes pas a la bonne position pour jouer a la roulette");
	return 1;
}
CMD:stoproulette(playerid,params[])
{
	StopTimery[playerid]  = SetTimerEx("StopRulet",10,1,"i",playerid);
	return 1;
}
//lowrider
CMD:organisateur(playerid, params[]) 
{
	if(organisateur[playerid] == 0)
	{
		SendServerMessage(playerid,"Vous êtes maintenant organisateur.");
		organisateur[playerid] = 1;
	}
	else 
	{
		SendServerMessage(playerid,"Vous n'êtes plus organisateur.");
		organisateur[playerid] = 0;
	}
	return 1;
}
CMD:rejoindrelowrider(playerid, params[]) 
{
	if(InContest[playerid] == false)
	{
		static userid;
	    //SetPlayerCheckpoint(playerid,1940.2808,-1775.7992,13.3906,10.0);
		SendServerMessage(playerid,"Rend-toi proche de l'organisateur");
	    InContest[playerid] = true;
	    JustJoined[playerid] = true;
		if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 20.0) && organisateur[userid] != 1)
		{
			SendErrorMessage(playerid, "Ce joueur n'est pas l'organisateur");
			return 1;
		}
		else
		{
			if(InContest[playerid] == true) {
				if(!IsPlayerInAnyVehicle(playerid)) return SendServerMessage(playerid, "Vous devez être dans un vehicule");
				if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid),GetVehicleComponentType(1087)) == 1087) {BeginContestForPlayer(playerid);}
				else return SendServerMessage(playerid, "Vous n'avez pas d'hydraulic");
			}
		}
	}
	else
	{
	    InContest[playerid] = false;
	    JustJoined[playerid] = false;
	    TextDrawHideForPlayer(playerid, ContestText);
		TextDrawDestroy(ContestText);
	    DisablePlayerCheckpoint(playerid);
	    SetCameraBehindPlayer(playerid);
	    CurrentNote[playerid] = -1;
		SendServerMessage(playerid, "Fin du concours");
	}
	return 1;
}
//musculation
CMD:bras(playerid,params[])
{
	if(PlayerData[playerid][prepetitions] <= 5000 && PlayerData[playerid][prepetitions] >= 2001) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Monsieur/Madame univers au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= 2000 && PlayerData[playerid][prepetitions] >= 1001) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Bien musclé au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= 1000 && PlayerData[playerid][prepetitions] >= 501) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Musclé au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= 500 && PlayerData[playerid][prepetitions] >= 1) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Maigrement musclé au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= 0 && PlayerData[playerid][prepetitions] >= -501) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Maigre au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= -502 && PlayerData[playerid][prepetitions] >= -1500) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Quelque bourlets au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= -1501 && PlayerData[playerid][prepetitions] >= -2000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Surplus de poids au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= -2001 && PlayerData[playerid][prepetitions] >= -3000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Gros/Grosse au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= -3001 && PlayerData[playerid][prepetitions] >= -4000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Obèse au niveau du haut du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][prepetitions] <= -4001 && PlayerData[playerid][prepetitions] >= -5000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Obèse morbide au niveau du haut du corps.",ReturnName(playerid,0));
	else
	{
		SendServerMessage(playerid,"Votre musclation des bras est à %d",PlayerData[playerid][prepetitions]);
	}
	return 1;
}
CMD:jambes(playerid,params[])
{
	if(PlayerData[playerid][pparcouru] <= 5000 && PlayerData[playerid][pparcouru] >= 2001) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Monsieur/Madame univers au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= 2000 && PlayerData[playerid][pparcouru] >= 1001) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Bien musclé au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= 1000 && PlayerData[playerid][pparcouru] >= 501) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Musclé au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= 500 && PlayerData[playerid][pparcouru] >= 1) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Maigrement musclé au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= 0 && PlayerData[playerid][pparcouru] >= -501) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Maigre au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= -502 && PlayerData[playerid][pparcouru] >= -1500) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Quelque bourlets au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= -1501 && PlayerData[playerid][pparcouru] >= -2000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Surplus de poids au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= -2001 && PlayerData[playerid][pparcouru] >= -3000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Gros/Grosse au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= -3001 && PlayerData[playerid][pparcouru] >= -4000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Obèse au niveau du bas du corps.",ReturnName(playerid,0));
	if(PlayerData[playerid][pparcouru] <= -4001 && PlayerData[playerid][pparcouru] >= -5000) return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s est considérer comme une personne : Obèse morbide au niveau du bas du corps.",ReturnName(playerid,0));
	else
	{
		SendServerMessage(playerid,"Votre musclation des jambes est à %d",PlayerData[playerid][pparcouru]);
	}
	return 1;
}
//ck
CMD:ck(playerid, params[])
{
	static userid;
	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/ck [playerid/nom]");
    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendErrorMessage(playerid, "Le numéro du player est déconnecté ou pas proche de toi.");
	PlayerData[userid][pck] = playerid;
	if (PlayerData[playerid][pPlayingHours] <= 10 && PlayerData[userid][pPlayingHours] >= 5)
	{
		SendErrorMessage(playerid, "Vous ne pouvez pas ck (besoin de 10 heures de jeux) et la personne que vous vouler ck doit avoir 5 heures de jeux minimun");
	}
	SendServerMessage(userid, "%s veux vous ck. (écriver \"/accepter ck\").", ReturnName(playerid, 0));
	SendServerMessage(userid, "Si vous accepté votre personnage sera tué définitivement et vous serez inviter a refaire un nouveau personnage");
	SendServerMessage(playerid, "Vous voulez ck %s.", ReturnName(userid, 0));
	return 1;
}
//fumer
CMD:fumer(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (!Inventory_HasItem(playerid, "cigarette"))
		return SendErrorMessage(playerid, "Vous n'avez pas de cigarette.");
	if (!Inventory_HasItem(playerid, "briquet"))
		return SendErrorMessage(playerid, "Vous n'avez pas de briquet.");
	Inventory_Remove(playerid, "cigarette",1);
	Inventory_Remove(playerid, "briquet",1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort une cigarette et l'allume.", ReturnName(playerid, 0));	
	return 1;		
}
CMD:cigarette1(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (!Inventory_HasItem(playerid, "paquet de cigarette cs"))
		return SendErrorMessage(playerid, "Vous n'avez pas de paquet de cigarette cs.");
	new id = Inventory_Add(playerid, "cigarette", 19625,15);
    if (id == -1)
        return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	Inventory_Remove(playerid, "paquet de cigarette cs",1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un paquet de cigarette de marque cs et le vide.", ReturnName(playerid, 0));		
	return 1;
}
CMD:cigarette2(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "Tu ne peut utiliser cette commande maintenant.");
	if (!Inventory_HasItem(playerid, "paquet de cigarette ck"))
		return SendErrorMessage(playerid, "Vous n'avez pas de paquet de cigarette ck.");
    new id = Inventory_Add(playerid, "cigarette", 19625,20);
    if (id == -1)
		return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	Inventory_Remove(playerid, "paquet de cigarette ck",1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort un paquet de cigarette de marque ck et le vide.", ReturnName(playerid, 0));		
	return 1;
}
CMD:souris(playerid, params[])
{
	SetTimerEx("SelectTD", 200, false, "d", playerid);
	return 1;
}
CMD:tarlouze(playerid,params[])
{
	new vehicleid = GetPlayerVehicleID(playerid),idk = Car_GetID(vehicleid);
	SendVehiculeMessage(playerid,"Vous avez %d en essence",CarData[idk][carfuel]);
	return 1;
}
CMD:bbalise(playerid,params[])
{
	foreach (new i : Player)
	{
		new factionid = PlayerData[i][pFaction],Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		SetFactionMarker(playerid, 0x00ffc5FF);
		if(FactionData[factionid][factionacces][1] == 1 ||FactionData[factionid][factionacces][2] == 1 || FactionData[factionid][factionacces][3] == 1 || FactionData[factionid][factionacces][7] == 1 || FactionData[factionid][factionacces][5] == 1 || FactionData[factionid][factionacces][4] == 1)
		{
			SendServerMessage(i,"{BABABA}%s demande du renfort. (Localisation: {FFFFFF}%s{BABABA})", ReturnName(playerid), GetLocation(x, y, z));
		}
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s active sa balise.", ReturnName(playerid, 0));
	}
	return 1;
}
//blackjack
CMD:bjstart(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid,2.0,-238.3116,-26.3283,1004.14615) && !IsPlayerInRangeOfPoint(playerid,5.0,-236.7883,-31.4460,1004.1461))
		return SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place pour faire cela");
    SendBlackJackMessage(playerid,"BlackJack commencer");
    PlayerTextDrawShow(playerid,BlackJackTD[0][playerid]);
    PlayerTextDrawShow(playerid,BlackJackTD[6][playerid]);
    PlayerTextDrawShow(playerid,BlackJackTD[7][playerid]);
    PlayerTextDrawShow(playerid,BlackJackTD[9][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[11][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[12][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[13][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[14][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[15][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[16][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[17][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[19][playerid]);
	PlayerTextDrawShow(playerid,BlackJackTD[20][playerid]);
	SelectTextDraw(playerid, -1);
    return 1;
}
CMD:bjstop(playerid, params[])
{
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	BlackJack[playerid][sommejouer] = 0;
	PlayerTextDrawHide(playerid,BlackJackTD[0][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[6][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[7][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[9][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[11][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[12][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[13][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[14][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[15][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[16][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[17][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[19][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[20][playerid]);
    SendBlackJackMessage(playerid,"BlackJack fini");
    CancelSelectTextDraw(playerid);
    return 1;
}
//dé
CMD:des(playerid,params[])
{
	if (Inventory_Count(playerid, "des") > 2) return SendErrorMessage(playerid, "Vous n'avez pas de dés pour jouer (x2).");
	new  randResult[2];
	randResult[0] = random(6) + 1;
	randResult[1] = random(6) + 1;
	SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s lance les dés et obtient %d et %d", ReturnName(playerid, 0),randResult[0],randResult[1]);
	return 1;
}
//voler item
CMD:voleritem(playerid,params[])
{
	static bizid = -1,serveurinfo;
	new facass = PlayerData[playerid][pFaction];
	if ((bizid = Business_Inside(playerid)) != -1)
	{
		if (bizid == -1 || !BusinessData[bizid][bizExists])
			return 0;
		if(info_serveursetting[serveurinfo][settingbraquagenpcactive] == 1) {ShowPlayerFooter(playerid, "Les braquages sont desactiver");return 1;}
		if(cop_nbrCops < info_serveursetting[serveurinfo][settingpolice]) {ShowPlayerFooter(playerid, " Il n'a pas assez de ~r~police~w~ en ville"); return 1;}
		switch (BusinessData[bizid][bizType])
		{
			case 1, 6:
			{
				switch(BusinessData[bizid][bizchancevole])
				{
					case 0 .. 10: BusinessData[bizid][bizchancevole] += 2;
					case 11 .. 25: BusinessData[bizid][bizchancevole] += 5;
					case 26 .. 50: BusinessData[bizid][bizchancevole] += 10;
					case 51 .. 75: BusinessData[bizid][bizchancevole] += 15;
					case 76 .. 100:
					{
						BusinessData[bizid][bizchancevole] += 20;
						if(BusinessData[bizid][bizchancevole] >= 100)
						{
							BusinessData[bizid][bizchancevole] = 100;
						}
					}
				}
				switch(random(6))
				{
					case 0:
					{
						if (Inventory_HasItem(playerid, "Systeme GPS"))
							return SendErrorMessage(playerid, "Tu a déjà un GPS.");
						new id = Inventory_Add(playerid, "Systeme GPS", 18875);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un systeme gps.");
						BusinessData[bizid][bizProducts]--;
					}
					case 1:
					{
						if (PlayerHasWeapon(playerid, 43))
							return SendErrorMessage(playerid, "Vous avez déjà cette item.");
						GiveWeaponToPlayer(playerid, 43, 100);
						SendServerMessage(playerid,"Tu a réussi a voler une caméra.");
						BusinessData[bizid][bizProducts]--;
					}
					case 2:
					{
					    if (Inventory_Count(playerid, "Chargeur telephone") >= 1)
							return SendErrorMessage(playerid, "Tu a déja un chargeur, tu ne peut plus en voler");
						new id = Inventory_Add(playerid, "Chargeur telephone",19087);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un chargeur de téléphone.");
						BusinessData[bizid][bizProducts]--;
					}
					case 3:
					{
						if (Inventory_HasItem(playerid, "Talkie-Walkie"))
							return SendErrorMessage(playerid, "Vous avez déjà cette item.");
						new id = Inventory_Add(playerid, "Talkie-Walkie", 18868);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un talkie-walkie.");
						BusinessData[bizid][bizProducts]--;
					}
					case 4:
					{
						if (Inventory_Count(playerid, "Jerrican") >= 3)
							return SendErrorMessage(playerid, "Vous avez déjà cette item. (x3)");
						new id = Inventory_Add(playerid, "Jerrican", 1650);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un jerrican.");
						BusinessData[bizid][bizProducts]--;
					}
					case 5:
					{
						new id = Inventory_Add(playerid, "des", 1851);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un des a jouer.");
						BusinessData[bizid][bizProducts]--;
					}
				}
				Business_Save(bizid);
			}
			case 9:
			{
				switch(BusinessData[bizid][bizchancevole])
				{
					case 0 .. 10: BusinessData[bizid][bizchancevole] += 2;
					case 11 .. 25: BusinessData[bizid][bizchancevole] += 5;
					case 26 .. 50: BusinessData[bizid][bizchancevole] += 10;
					case 51 .. 75: BusinessData[bizid][bizchancevole] += 15;
					case 76 .. 100:
					{
						BusinessData[bizid][bizchancevole] += 20;
						if(BusinessData[bizid][bizchancevole] >= 100)
						{
							BusinessData[bizid][bizchancevole] = 100;
						}
					}
				}
				switch(random(6))
				{
					case 0:
					{
						new id = Inventory_Add(playerid, "briquet", 19998,200);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un briquet");
						BusinessData[bizid][bizProducts]--;
					}
					case 1:
					{
						if (Inventory_Count(playerid, "Pizza surgele") >= 3)
							return SendErrorMessage(playerid, "Tu a 3 part de pizzas, tu ne peut plus en voler.");
						new id = Inventory_Add(playerid, "Pizza surgele", 2814);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler une pizza surgelé.");
						BusinessData[bizid][bizProducts]--;
					}
					case 2:
					{
						if (Inventory_Count(playerid, "Burger surgele") >= 5)
							return SendErrorMessage(playerid, "Tu a 5 burgers, tu ne peut plus en voler.");
						new id = Inventory_Add(playerid, "Burger surgele", 2768);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un burger surgelé.");
						BusinessData[bizid][bizProducts]--;
					}
					case 3:
					{
						if (Inventory_Count(playerid, "jus de pomme") >= 5)
							return SendErrorMessage(playerid, "Tu a 5 jus de pomme, tu ne peut plus en voler");
						new id = Inventory_Add(playerid, "jus de pomme", 19564);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un jus de pomme");
						BusinessData[bizid][bizProducts]--;
					}
					case 4:
					{
						if (Inventory_Count(playerid, "jus dorange") >= 5)
							return SendErrorMessage(playerid, "Tu a 5 jus d'orange, tu ne peut plus en voler.");
						new id = Inventory_Add(playerid, "jus dorange", 19563);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						BusinessData[bizid][bizProducts]--;
					}
					case 5:
					{
						if (Inventory_Count(playerid, "jambon") >= 5)
							return SendErrorMessage(playerid, "Tu a 5 jambon, tu ne peut plus en voler.");
						new id = Inventory_Add(playerid, "jambon", 2804);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un jambon");
						BusinessData[bizid][bizProducts]--;
					}
					case 6:
					{
						if (Inventory_Count(playerid, "orange") >= 5)
							return SendErrorMessage(playerid, "Tu a 5 orange, tu ne peut plus en voler.");
						new id = Inventory_Add(playerid, "orange", 19574);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler une orange");
						BusinessData[bizid][bizProducts]--;
					}
				}
				Business_Save(bizid);
			}			
			case 10:
			{
				switch(BusinessData[bizid][bizchancevole])
				{
					case 0 .. 10: BusinessData[bizid][bizchancevole] += 2;
					case 11 .. 25: BusinessData[bizid][bizchancevole] += 5;
					case 26 .. 50: BusinessData[bizid][bizchancevole] += 10;
					case 51 .. 75: BusinessData[bizid][bizchancevole] += 15;
					case 76 .. 100:
					{
						BusinessData[bizid][bizchancevole] += 20;
						if(BusinessData[bizid][bizchancevole] >= 100)
						{
							BusinessData[bizid][bizchancevole] = 100;
						}
					}
				}
				switch(random(3))
				{
					case 0:
					{
						new id = Inventory_Add(playerid, "Pied de biche",18634);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un pied de biche.");
						BusinessData[bizid][bizProducts]--;
					}
					case 1:
					{
						new id = Inventory_Add(playerid, "Tournevis",18644);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler un tournevis.");
						BusinessData[bizid][bizProducts]--;
					}
					case 2:
					{
						if (Inventory_Count(playerid, "Bombe de peinture") >= 5)
							return SendErrorMessage(playerid, "Tu a 5 bombe de peinture, tu ne peut plus en voler");
						new id = Inventory_Add(playerid, "Bombe de peinture", 365);
						if (id == -1)
							return SendErrorMessage(playerid, "Inventaire plein.");
						SendServerMessage(playerid,"Tu a réussi a voler une bombe de peinture.");
						BusinessData[bizid][bizProducts]--;
					}
				}
				Business_Save(bizid);
			}
		}
		foreach (new y : Player)
		{
			if (FactionData[facass][factionacces][1] == 1)
			{
				Waypoint_Set(y, "Vol en cours!", BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2]);
			}
		}
		if(FactionData[facass][factionacces][1] == 1)
		{ SendServerMessage(playerid, "RADIO: Un vol de magasin au %s (marquée sur la carte).", BusinessData[bizid][bizName]);}
	}
	else return SendErrorMessage(playerid,"Vous n'est pas dans un magasin.");
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
CMD:abus(playerid,params[])
{
	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "Donc vous avez fait /abus.","Vous trouver que d'attendre X nombres d'heures est injuste?\nDit vous qu'il y a des gens qui abusent des scripts mis en place pour le serveur et\nqui en abusent donc on doit sanctionner tout le monde a cause de certaines personnes.\nVous pouvez vous plaindre sur le forum %s,\n mais à cause de gens qui abusent les actions entreprises par le staff et les développeurs peut être lourd ou injuste.\nNe soyer par surprit des réponses données.\nMerci de votre compréension et bonne journée.\nL'équipe de développement du serveur."," X ", "",SERVER_URL);
	return 1;
}
CMD:minutecheck(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	MinuteCheck();
	return 1;
}
CMD:louerbillard(playerid,params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 5.0, 511.8775,-76.5869,998.7578))
	    return SendErrorMessage(playerid, "Vous devez être proche du point de location.");
	if(GetPlayerMoney(playerid) <= 10) return GameTextForPlayer(playerid, "~r~Vous n'avez pas assez d'argent", 2000, 3);
	SendServerMessage(playerid,"Vous avez louer la queue de billard au cout de 10$.");
	SendServerMessage(playerid,"Faites /pool pour commencer a jouer sur la première table un ding! se fera attendre.");
	SendServerMessage(playerid,"Faites /pool2 pour commencer a jouer sur la deuxième table un ding! se fera attendre.");
	GiveMoney(playerid, -10);
	GiveWeaponToPlayer(playerid, 7, 1);
	return 1;
}
CMD:delouerbillard(playerid,params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 5.0, 511.8775,-76.5869,998.7578))
	    return SendErrorMessage(playerid, "Vous devez être proche du point de location.");
	if(GetPlayerWeapon(playerid) != 7)
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED,"[ERREUR]:{FFFFFF} Vous n'avez pas de queue de billard");
	    return 1;
	}
	SendServerMessage(playerid,"Vous avez fini votre location de la queue de billard. Voila vos 10$.");
	GiveMoney(playerid, 10);
	ResetWeapon(playerid, 7);
	return 1;
}
CMD:soins(playerid,params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 5.0,-212.8441,-1745.4980,675.7687))
	    return SendErrorMessage(playerid, "Vous devez être proche du point.");
	if(GetPlayerMoney(playerid) <= 2500) return GameTextForPlayer(playerid, "~r~Vous n'avez pas assez d'argent", 2000, 3);
	SendServerMessage(playerid, "Vous avez accepté les soins des médecins.");
	GiveMoney(playerid, -2500);
	new moneyentrepriseid;
	argent_entreprise[moneyentrepriseid][argentmedecin] +=2500;
	moneyentreprisesave(moneyentrepriseid);
	SetPlayerHealth(playerid,100.0);
	return 1;
}
CMD:resetveh(playerid,params[])
{
	new string[80];
	if (PlayerData[playerid][pAdmin] < 4)
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
	if (PlayerData[playerid][pAdmin] < 4)
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
//job gaz
CMD:gaz(playerid, params[])
{
	new id = Job_NearestPoint(playerid),string[128],kanistrab = 20,stockjobinfoid;
    if(OnGener[playerid] == 0 || JobData[id][jobType] != JOB_GENERATEUR) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Vous n'avez pas commencé à travailler.");
    if(OnBenz[playerid] == 1) return 1;
    if(info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator] <= 0) return SendErrorMessage(playerid,"Il n'y a plus d'essence dans les citerne");
    format(string, sizeof(string), "Vous avez remplis votre bidon d'essence de %d litres.",kanistrab);
    SendClientMessage(playerid, COLOR_WHITE, string);
    info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator] -= kanistrab;
	stockjobinfosave(stockjobinfoid);
	Updateessencegenerator();
    SetPlayerAttachedObject(playerid,3, 1650, 6, 0.013610, -0.021393, -0.144862, 2.354303, 354.413848, 0.219168, 3.034477, 3.000000, 3.000000);
    OnBenz[playerid] = 1;
	return 1;
}
//salaire faction
CMD:salairefaction(playerid,params[])
{
	static id,idd;
	new factionid = PlayerData[playerid][pFaction];
	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)  return SendErrorMessage(playerid,"Vous n'avez pas acces a cette option.");
	Dialog_Show(playerid,salairefaction,DIALOG_STYLE_TABLIST,"Salaire de votre faction","Salaire rang 1\t %d $/h\t","Valider","Fermer",FactionData[factionid][factionsalaire][1]);
	if(sscanf(params, "dd",idd,id)) return SendClientMessage(playerid, -1, "Utilisation: /salairefaction rank entre 1 et 2500");
	if (idd < 1 || idd > 15) return SendErrorMessage(playerid,"Erreur Le rang est entre 1 et 15");
	if (id < 1 || id > 2500) return SendErrorMessage(playerid,"Erreur le salaire du rang %d doit être comprie entre 1 et 2500$",idd);
	FactionData[factionid][factionsalaire][idd] = id;
	SendServerMessage(playerid,"Vous avez modifier le salaire du rang %d a %d $",idd,id);
	Faction_Save(factionid);
	return 1;
}
//craft
CMD:craft(playerid,params[])
{
	static type[64];
	new varitems = random(sizeof(g_aInventoryItems))+19;
	if (sscanf(params, "s[64]",type))
	{
	    SendSyntaxMessage(playerid, "/craft [option]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} caisse pomme verte,caisse pomme rouge,object contaminer");
		return 1;
	}
	else if (!strcmp(type, "caisse pomme verte", true))
	{
		if (Inventory_Count(playerid, "pomme verte") <= 70)
			return SendErrorMessage(playerid, "Tu as pas asser de pommes verte.");
		if (Inventory_Count(playerid, "Boite de carton") <= 1)
			return SendErrorMessage(playerid, "Tu as pas de boite de carton.");
		Inventory_Remove(playerid, "pomme verte",70);
		Inventory_Remove(playerid, "Boite de carton",1);
		Inventory_Add(playerid, "caisse pomme verte", 19637);
		SendServerMessage(playerid,"Vous avez créer une caisse de pommes verte.");
	}
	else if (!strcmp(type, "caisse pomme rouge", true))
	{
		if (Inventory_Count(playerid, "pomme rouge") <= 70)
			return SendErrorMessage(playerid, "Tu as pas asser de pommes rouge.");
		if (Inventory_Count(playerid, "Boite de carton") <= 1)
			return SendErrorMessage(playerid, "Tu as pas une boite de carton.");
		Inventory_Remove(playerid, "pomme rouge",70);
		Inventory_Remove(playerid, "Boite de carton",1);
		Inventory_Add(playerid, "caisse pomme rouge", 19636);
		SendServerMessage(playerid,"Vous avez créer une caisse de pommes rouge.");
	}
	else if (!strcmp(type, "object contaminer", true))
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 270.2714,1879.1141,-30.3906))
		{
			if (Inventory_Count(playerid, "object contaminer") < 0)
				return SendErrorMessage(playerid, "Tu as d'object contaminé sur toi.");
			Inventory_Remove(playerid, "object contaminer",1);
			Inventory_Add(playerid,g_aInventoryItems[varitems][e_InventoryItem],g_aInventoryItems[varitems][e_InventoryModel]);
			SendServerMessage(playerid,"Vous avez reçus un item après l'avoir décontaminer.");
		}
		else SendErrorMessage(playerid,"Vous devez être au centre de l'arena 51.");
	}
	return 1;
}
//stamina
CMD:sub(playerid, params[])
{
    SetPlayerStaminaSubVal(playerid, strval(params));
    return 1;
}
//gold bar exchange
CMD:echanger(playerid,params[])
{
	if(!Inventory_HasItem(playerid,"gold bar")) return SendErrorMessage(playerid,"Il vous faut une gold bar minimun pour accéder a ce menu.");
	Dialog_Show(playerid,echanger,DIALOG_STYLE_TABLIST,"Menu d'échange","Argent 100$\t 1 Gold bar\nArgent 200$\t 2 Gold bars\nArgent 300$\t 3 Gold bars\nArgent 400$\t 4 Gold bars\nArgent 500$\t 5 Gold bars\nHeure de jeux 1\t 1 Gold bar\nHeure de jeux 5\t 5 Gold bars\nHeure de jeux 10\t 10 Gold bars\nDouble personnage autorisé\t 100 gold bars\nAjouter capacité d'inventaire (35 places)\t 25 gold bars","Valider","Quitter");
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
CMD:lang(playerid,params[])
{
	Dialog_Show(playerid,Language1,DIALOG_STYLE_LIST,"Choose Language","You understand? Click me!\nTu me comprend? Clic ici!","OK","");
	return 1;
}
CMD:aie(playerid,params[])
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(z > 400) return SetPlayerPos(playerid,2096.7385,-1687.4127,13.4706);
	return 1;
}
CMD:vetement(playerid,params[])
{
	if(Inventory_HasItem(playerid,"Vetement 0")) {Inventory_Remove(playerid,"Vetement 0"); SetPlayerSkin(playerid,0);}
	if(Inventory_HasItem(playerid,"Vetement 1")) {Inventory_Remove(playerid,"Vetement 1"); SetPlayerSkin(playerid,1);}
	if(Inventory_HasItem(playerid,"Vetement 2")) {Inventory_Remove(playerid,"Vetement 2"); SetPlayerSkin(playerid,2);}
	if(Inventory_HasItem(playerid,"Vetement 3")) {Inventory_Remove(playerid,"Vetement 3"); SetPlayerSkin(playerid,3);}
	if(Inventory_HasItem(playerid,"Vetement 4")) {Inventory_Remove(playerid,"Vetement 4"); SetPlayerSkin(playerid,4);}
	if(Inventory_HasItem(playerid,"Vetement 5")) {Inventory_Remove(playerid,"Vetement 5"); SetPlayerSkin(playerid,5);}
	if(Inventory_HasItem(playerid,"Vetement 6")) {Inventory_Remove(playerid,"Vetement 6"); SetPlayerSkin(playerid,6);}
	if(Inventory_HasItem(playerid,"Vetement 7")) {Inventory_Remove(playerid,"Vetement 7"); SetPlayerSkin(playerid,7);}
	if(Inventory_HasItem(playerid,"Vetement 8")) {Inventory_Remove(playerid,"Vetement 8"); SetPlayerSkin(playerid,8);}
	if(Inventory_HasItem(playerid,"Vetement 9")) {Inventory_Remove(playerid,"Vetement 9"); SetPlayerSkin(playerid,9);}
	if(Inventory_HasItem(playerid,"Vetement 10")) {Inventory_Remove(playerid,"Vetement 10"); SetPlayerSkin(playerid,10);}
	if(Inventory_HasItem(playerid,"Vetement 11")) {Inventory_Remove(playerid,"Vetement 11"); SetPlayerSkin(playerid,11);}
	if(Inventory_HasItem(playerid,"Vetement 12")) {Inventory_Remove(playerid,"Vetement 12"); SetPlayerSkin(playerid,12);}
	if(Inventory_HasItem(playerid,"Vetement 13")) {Inventory_Remove(playerid,"Vetement 13"); SetPlayerSkin(playerid,13);}
	if(Inventory_HasItem(playerid,"Vetement 14")) {Inventory_Remove(playerid,"Vetement 14"); SetPlayerSkin(playerid,14);}
	if(Inventory_HasItem(playerid,"Vetement 15")) {Inventory_Remove(playerid,"Vetement 15"); SetPlayerSkin(playerid,15);}
	if(Inventory_HasItem(playerid,"Vetement 16")) {Inventory_Remove(playerid,"Vetement 16"); SetPlayerSkin(playerid,16);}
	if(Inventory_HasItem(playerid,"Vetement 17")) {Inventory_Remove(playerid,"Vetement 17"); SetPlayerSkin(playerid,17);}
	if(Inventory_HasItem(playerid,"Vetement 18")) {Inventory_Remove(playerid,"Vetement 18"); SetPlayerSkin(playerid,18);}
	if(Inventory_HasItem(playerid,"Vetement 19")) {Inventory_Remove(playerid,"Vetement 19"); SetPlayerSkin(playerid,19);}
	if(Inventory_HasItem(playerid,"Vetement 20")) {Inventory_Remove(playerid,"Vetement 20"); SetPlayerSkin(playerid,20);}
	if(Inventory_HasItem(playerid,"Vetement 21")) {Inventory_Remove(playerid,"Vetement 21"); SetPlayerSkin(playerid,21);}
	if(Inventory_HasItem(playerid,"Vetement 22")) {Inventory_Remove(playerid,"Vetement 22"); SetPlayerSkin(playerid,22);}
	if(Inventory_HasItem(playerid,"Vetement 23")) {Inventory_Remove(playerid,"Vetement 23"); SetPlayerSkin(playerid,23);}
	if(Inventory_HasItem(playerid,"Vetement 24")) {Inventory_Remove(playerid,"Vetement 24"); SetPlayerSkin(playerid,24);}
	if(Inventory_HasItem(playerid,"Vetement 25")) {Inventory_Remove(playerid,"Vetement 25"); SetPlayerSkin(playerid,25);}
	if(Inventory_HasItem(playerid,"Vetement 26")) {Inventory_Remove(playerid,"Vetement 26"); SetPlayerSkin(playerid,26);}
	if(Inventory_HasItem(playerid,"Vetement 27")) {Inventory_Remove(playerid,"Vetement 27"); SetPlayerSkin(playerid,27);}
	if(Inventory_HasItem(playerid,"Vetement 28")) {Inventory_Remove(playerid,"Vetement 28"); SetPlayerSkin(playerid,28);}
	if(Inventory_HasItem(playerid,"Vetement 29")) {Inventory_Remove(playerid,"Vetement 29"); SetPlayerSkin(playerid,29);}
	if(Inventory_HasItem(playerid,"Vetement 30")) {Inventory_Remove(playerid,"Vetement 30"); SetPlayerSkin(playerid,30);}
	if(Inventory_HasItem(playerid,"Vetement 31")) {Inventory_Remove(playerid,"Vetement 31"); SetPlayerSkin(playerid,31);}
	if(Inventory_HasItem(playerid,"Vetement 32")) {Inventory_Remove(playerid,"Vetement 32"); SetPlayerSkin(playerid,32);}
	if(Inventory_HasItem(playerid,"Vetement 33")) {Inventory_Remove(playerid,"Vetement 33"); SetPlayerSkin(playerid,33);}
	if(Inventory_HasItem(playerid,"Vetement 34")) {Inventory_Remove(playerid,"Vetement 34"); SetPlayerSkin(playerid,34);}
	if(Inventory_HasItem(playerid,"Vetement 35")) {Inventory_Remove(playerid,"Vetement 35"); SetPlayerSkin(playerid,35);}
	if(Inventory_HasItem(playerid,"Vetement 36")) {Inventory_Remove(playerid,"Vetement 36"); SetPlayerSkin(playerid,36);}
	if(Inventory_HasItem(playerid,"Vetement 37")) {Inventory_Remove(playerid,"Vetement 37"); SetPlayerSkin(playerid,37);}
	if(Inventory_HasItem(playerid,"Vetement 38")) {Inventory_Remove(playerid,"Vetement 38"); SetPlayerSkin(playerid,38);}
	if(Inventory_HasItem(playerid,"Vetement 39")) {Inventory_Remove(playerid,"Vetement 39"); SetPlayerSkin(playerid,39);}
	if(Inventory_HasItem(playerid,"Vetement 40")) {Inventory_Remove(playerid,"Vetement 40"); SetPlayerSkin(playerid,40);}
	if(Inventory_HasItem(playerid,"Vetement 41")) {Inventory_Remove(playerid,"Vetement 41"); SetPlayerSkin(playerid,41);}
	if(Inventory_HasItem(playerid,"Vetement 42")) {Inventory_Remove(playerid,"Vetement 42"); SetPlayerSkin(playerid,42);}
	if(Inventory_HasItem(playerid,"Vetement 43")) {Inventory_Remove(playerid,"Vetement 43"); SetPlayerSkin(playerid,43);}
	if(Inventory_HasItem(playerid,"Vetement 44")) {Inventory_Remove(playerid,"Vetement 44"); SetPlayerSkin(playerid,44);}
	if(Inventory_HasItem(playerid,"Vetement 45")) {Inventory_Remove(playerid,"Vetement 45"); SetPlayerSkin(playerid,45);}
	if(Inventory_HasItem(playerid,"Vetement 46")) {Inventory_Remove(playerid,"Vetement 46"); SetPlayerSkin(playerid,46);}
	if(Inventory_HasItem(playerid,"Vetement 47")) {Inventory_Remove(playerid,"Vetement 47"); SetPlayerSkin(playerid,47);}
	if(Inventory_HasItem(playerid,"Vetement 48")) {Inventory_Remove(playerid,"Vetement 48"); SetPlayerSkin(playerid,48);}
	if(Inventory_HasItem(playerid,"Vetement 49")) {Inventory_Remove(playerid,"Vetement 49"); SetPlayerSkin(playerid,49);}
	if(Inventory_HasItem(playerid,"Vetement 50")) {Inventory_Remove(playerid,"Vetement 50"); SetPlayerSkin(playerid,50);}
	if(Inventory_HasItem(playerid,"Vetement 51")) {Inventory_Remove(playerid,"Vetement 51"); SetPlayerSkin(playerid,51);}
	if(Inventory_HasItem(playerid,"Vetement 52")) {Inventory_Remove(playerid,"Vetement 52"); SetPlayerSkin(playerid,52);}
	if(Inventory_HasItem(playerid,"Vetement 53")) {Inventory_Remove(playerid,"Vetement 53"); SetPlayerSkin(playerid,53);}
	if(Inventory_HasItem(playerid,"Vetement 54")) {Inventory_Remove(playerid,"Vetement 54"); SetPlayerSkin(playerid,54);}
	if(Inventory_HasItem(playerid,"Vetement 55")) {Inventory_Remove(playerid,"Vetement 55"); SetPlayerSkin(playerid,55);}
	if(Inventory_HasItem(playerid,"Vetement 56")) {Inventory_Remove(playerid,"Vetement 56"); SetPlayerSkin(playerid,56);}
	if(Inventory_HasItem(playerid,"Vetement 57")) {Inventory_Remove(playerid,"Vetement 57"); SetPlayerSkin(playerid,57);}
	if(Inventory_HasItem(playerid,"Vetement 58")) {Inventory_Remove(playerid,"Vetement 58"); SetPlayerSkin(playerid,58);}
	if(Inventory_HasItem(playerid,"Vetement 59")) {Inventory_Remove(playerid,"Vetement 59"); SetPlayerSkin(playerid,59);}
	if(Inventory_HasItem(playerid,"Vetement 60")) {Inventory_Remove(playerid,"Vetement 60"); SetPlayerSkin(playerid,60);}
	if(Inventory_HasItem(playerid,"Vetement 61")) {Inventory_Remove(playerid,"Vetement 61"); SetPlayerSkin(playerid,61);}
	if(Inventory_HasItem(playerid,"Vetement 62")) {Inventory_Remove(playerid,"Vetement 62"); SetPlayerSkin(playerid,62);}
	if(Inventory_HasItem(playerid,"Vetement 60")) {Inventory_Remove(playerid,"Vetement 60"); SetPlayerSkin(playerid,60);}
	if(Inventory_HasItem(playerid,"Vetement 61")) {Inventory_Remove(playerid,"Vetement 61"); SetPlayerSkin(playerid,61);}
	if(Inventory_HasItem(playerid,"Vetement 62")) {Inventory_Remove(playerid,"Vetement 62"); SetPlayerSkin(playerid,62);}
	if(Inventory_HasItem(playerid,"Vetement 63")) {Inventory_Remove(playerid,"Vetement 63"); SetPlayerSkin(playerid,63);}
	if(Inventory_HasItem(playerid,"Vetement 64")) {Inventory_Remove(playerid,"Vetement 64"); SetPlayerSkin(playerid,64);}
	if(Inventory_HasItem(playerid,"Vetement 65")) {Inventory_Remove(playerid,"Vetement 65"); SetPlayerSkin(playerid,65);}
	if(Inventory_HasItem(playerid,"Vetement 66")) {Inventory_Remove(playerid,"Vetement 66"); SetPlayerSkin(playerid,66);}
	if(Inventory_HasItem(playerid,"Vetement 67")) {Inventory_Remove(playerid,"Vetement 67"); SetPlayerSkin(playerid,67);}
	if(Inventory_HasItem(playerid,"Vetement 68")) {Inventory_Remove(playerid,"Vetement 68"); SetPlayerSkin(playerid,68);}
	if(Inventory_HasItem(playerid,"Vetement 69")) {Inventory_Remove(playerid,"Vetement 69"); SetPlayerSkin(playerid,69);}
	if(Inventory_HasItem(playerid,"Vetement 70")) {Inventory_Remove(playerid,"Vetement 70"); SetPlayerSkin(playerid,70);}
	if(Inventory_HasItem(playerid,"Vetement 71")) {Inventory_Remove(playerid,"Vetement 71"); SetPlayerSkin(playerid,71);}
	if(Inventory_HasItem(playerid,"Vetement 72")) {Inventory_Remove(playerid,"Vetement 72"); SetPlayerSkin(playerid,72);}
	if(Inventory_HasItem(playerid,"Vetement 73")) {Inventory_Remove(playerid,"Vetement 73"); SetPlayerSkin(playerid,73);}
	if(Inventory_HasItem(playerid,"Vetement 74")) {Inventory_Remove(playerid,"Vetement 74"); SetPlayerSkin(playerid,74);}
	if(Inventory_HasItem(playerid,"Vetement 75")) {Inventory_Remove(playerid,"Vetement 75"); SetPlayerSkin(playerid,75);}
	if(Inventory_HasItem(playerid,"Vetement 76")) {Inventory_Remove(playerid,"Vetement 76"); SetPlayerSkin(playerid,76);}
	if(Inventory_HasItem(playerid,"Vetement 77")) {Inventory_Remove(playerid,"Vetement 77"); SetPlayerSkin(playerid,77);}
	if(Inventory_HasItem(playerid,"Vetement 78")) {Inventory_Remove(playerid,"Vetement 78"); SetPlayerSkin(playerid,78);}
	if(Inventory_HasItem(playerid,"Vetement 79")) {Inventory_Remove(playerid,"Vetement 79"); SetPlayerSkin(playerid,79);}
	if(Inventory_HasItem(playerid,"Vetement 80")) {Inventory_Remove(playerid,"Vetement 80"); SetPlayerSkin(playerid,80);}
	if(Inventory_HasItem(playerid,"Vetement 81")) {Inventory_Remove(playerid,"Vetement 81"); SetPlayerSkin(playerid,81);}
	if(Inventory_HasItem(playerid,"Vetement 82")) {Inventory_Remove(playerid,"Vetement 82"); SetPlayerSkin(playerid,82);}
	if(Inventory_HasItem(playerid,"Vetement 83")) {Inventory_Remove(playerid,"Vetement 83"); SetPlayerSkin(playerid,83);}
	if(Inventory_HasItem(playerid,"Vetement 84")) {Inventory_Remove(playerid,"Vetement 84"); SetPlayerSkin(playerid,84);}
	if(Inventory_HasItem(playerid,"Vetement 85")) {Inventory_Remove(playerid,"Vetement 85"); SetPlayerSkin(playerid,85);}
	if(Inventory_HasItem(playerid,"Vetement 86")) {Inventory_Remove(playerid,"Vetement 86"); SetPlayerSkin(playerid,86);}
	if(Inventory_HasItem(playerid,"Vetement 87")) {Inventory_Remove(playerid,"Vetement 87"); SetPlayerSkin(playerid,87);}
	if(Inventory_HasItem(playerid,"Vetement 88")) {Inventory_Remove(playerid,"Vetement 88"); SetPlayerSkin(playerid,88);}
	if(Inventory_HasItem(playerid,"Vetement 89")) {Inventory_Remove(playerid,"Vetement 89"); SetPlayerSkin(playerid,89);}
	if(Inventory_HasItem(playerid,"Vetement 90")) {Inventory_Remove(playerid,"Vetement 90"); SetPlayerSkin(playerid,90);}
	if(Inventory_HasItem(playerid,"Vetement 91")) {Inventory_Remove(playerid,"Vetement 91"); SetPlayerSkin(playerid,91);}
	if(Inventory_HasItem(playerid,"Vetement 92")) {Inventory_Remove(playerid,"Vetement 92"); SetPlayerSkin(playerid,92);}
	if(Inventory_HasItem(playerid,"Vetement 93")) {Inventory_Remove(playerid,"Vetement 93"); SetPlayerSkin(playerid,93);}
	if(Inventory_HasItem(playerid,"Vetement 94")) {Inventory_Remove(playerid,"Vetement 94"); SetPlayerSkin(playerid,94);}
	if(Inventory_HasItem(playerid,"Vetement 95")) {Inventory_Remove(playerid,"Vetement 95"); SetPlayerSkin(playerid,95);}
	if(Inventory_HasItem(playerid,"Vetement 96")) {Inventory_Remove(playerid,"Vetement 96"); SetPlayerSkin(playerid,96);}
	if(Inventory_HasItem(playerid,"Vetement 97")) {Inventory_Remove(playerid,"Vetement 97"); SetPlayerSkin(playerid,97);}
	if(Inventory_HasItem(playerid,"Vetement 98")) {Inventory_Remove(playerid,"Vetement 98"); SetPlayerSkin(playerid,98);}
	if(Inventory_HasItem(playerid,"Vetement 99")) {Inventory_Remove(playerid,"Vetement 99"); SetPlayerSkin(playerid,99);}
	if(Inventory_HasItem(playerid,"Vetement 100")) {Inventory_Remove(playerid,"Vetement 100"); SetPlayerSkin(playerid,100);}
	if(Inventory_HasItem(playerid,"Vetement 101")) {Inventory_Remove(playerid,"Vetement 101"); SetPlayerSkin(playerid,101);}
	if(Inventory_HasItem(playerid,"Vetement 102")) {Inventory_Remove(playerid,"Vetement 102"); SetPlayerSkin(playerid,102);}
	if(Inventory_HasItem(playerid,"Vetement 103")) {Inventory_Remove(playerid,"Vetement 103"); SetPlayerSkin(playerid,103);}
	if(Inventory_HasItem(playerid,"Vetement 104")) {Inventory_Remove(playerid,"Vetement 104"); SetPlayerSkin(playerid,104);}
	if(Inventory_HasItem(playerid,"Vetement 105")) {Inventory_Remove(playerid,"Vetement 105"); SetPlayerSkin(playerid,105);}
	if(Inventory_HasItem(playerid,"Vetement 106")) {Inventory_Remove(playerid,"Vetement 106"); SetPlayerSkin(playerid,106);}
	if(Inventory_HasItem(playerid,"Vetement 107")) {Inventory_Remove(playerid,"Vetement 107"); SetPlayerSkin(playerid,107);}
	if(Inventory_HasItem(playerid,"Vetement 108")) {Inventory_Remove(playerid,"Vetement 108"); SetPlayerSkin(playerid,108);}
	if(Inventory_HasItem(playerid,"Vetement 109")) {Inventory_Remove(playerid,"Vetement 109"); SetPlayerSkin(playerid,109);}
	if(Inventory_HasItem(playerid,"Vetement 110")) {Inventory_Remove(playerid,"Vetement 110"); SetPlayerSkin(playerid,110);}
	if(Inventory_HasItem(playerid,"Vetement 111")) {Inventory_Remove(playerid,"Vetement 111"); SetPlayerSkin(playerid,111);}
	if(Inventory_HasItem(playerid,"Vetement 112")) {Inventory_Remove(playerid,"Vetement 112"); SetPlayerSkin(playerid,112);}
	if(Inventory_HasItem(playerid,"Vetement 113")) {Inventory_Remove(playerid,"Vetement 113"); SetPlayerSkin(playerid,113);}
	if(Inventory_HasItem(playerid,"Vetement 114")) {Inventory_Remove(playerid,"Vetement 114"); SetPlayerSkin(playerid,114);}
	if(Inventory_HasItem(playerid,"Vetement 115")) {Inventory_Remove(playerid,"Vetement 115"); SetPlayerSkin(playerid,115);}
	if(Inventory_HasItem(playerid,"Vetement 116")) {Inventory_Remove(playerid,"Vetement 116"); SetPlayerSkin(playerid,116);}
	if(Inventory_HasItem(playerid,"Vetement 117")) {Inventory_Remove(playerid,"Vetement 117"); SetPlayerSkin(playerid,117);}
	if(Inventory_HasItem(playerid,"Vetement 118")) {Inventory_Remove(playerid,"Vetement 118"); SetPlayerSkin(playerid,118);}
	if(Inventory_HasItem(playerid,"Vetement 119")) {Inventory_Remove(playerid,"Vetement 119"); SetPlayerSkin(playerid,119);}
	if(Inventory_HasItem(playerid,"Vetement 120")) {Inventory_Remove(playerid,"Vetement 120"); SetPlayerSkin(playerid,120);}
	if(Inventory_HasItem(playerid,"Vetement 121")) {Inventory_Remove(playerid,"Vetement 121"); SetPlayerSkin(playerid,121);}
	if(Inventory_HasItem(playerid,"Vetement 122")) {Inventory_Remove(playerid,"Vetement 122"); SetPlayerSkin(playerid,122);}
	if(Inventory_HasItem(playerid,"Vetement 123")) {Inventory_Remove(playerid,"Vetement 123"); SetPlayerSkin(playerid,123);}
	if(Inventory_HasItem(playerid,"Vetement 124")) {Inventory_Remove(playerid,"Vetement 124"); SetPlayerSkin(playerid,124);}
	if(Inventory_HasItem(playerid,"Vetement 125")) {Inventory_Remove(playerid,"Vetement 125"); SetPlayerSkin(playerid,125);}
	if(Inventory_HasItem(playerid,"Vetement 126")) {Inventory_Remove(playerid,"Vetement 126"); SetPlayerSkin(playerid,126);}
	if(Inventory_HasItem(playerid,"Vetement 127")) {Inventory_Remove(playerid,"Vetement 127"); SetPlayerSkin(playerid,127);}
	if(Inventory_HasItem(playerid,"Vetement 128")) {Inventory_Remove(playerid,"Vetement 128"); SetPlayerSkin(playerid,128);}
	if(Inventory_HasItem(playerid,"Vetement 129")) {Inventory_Remove(playerid,"Vetement 129"); SetPlayerSkin(playerid,129);}
	if(Inventory_HasItem(playerid,"Vetement 130")) {Inventory_Remove(playerid,"Vetement 130"); SetPlayerSkin(playerid,130);}
	if(Inventory_HasItem(playerid,"Vetement 131")) {Inventory_Remove(playerid,"Vetement 131"); SetPlayerSkin(playerid,131);}
	if(Inventory_HasItem(playerid,"Vetement 132")) {Inventory_Remove(playerid,"Vetement 132"); SetPlayerSkin(playerid,132);}
	if(Inventory_HasItem(playerid,"Vetement 133")) {Inventory_Remove(playerid,"Vetement 133"); SetPlayerSkin(playerid,133);}
	if(Inventory_HasItem(playerid,"Vetement 134")) {Inventory_Remove(playerid,"Vetement 134"); SetPlayerSkin(playerid,134);}
	if(Inventory_HasItem(playerid,"Vetement 135")) {Inventory_Remove(playerid,"Vetement 135"); SetPlayerSkin(playerid,135);}
	if(Inventory_HasItem(playerid,"Vetement 136")) {Inventory_Remove(playerid,"Vetement 136"); SetPlayerSkin(playerid,136);}
	if(Inventory_HasItem(playerid,"Vetement 137")) {Inventory_Remove(playerid,"Vetement 137"); SetPlayerSkin(playerid,137);}
	if(Inventory_HasItem(playerid,"Vetement 138")) {Inventory_Remove(playerid,"Vetement 138"); SetPlayerSkin(playerid,138);}
	if(Inventory_HasItem(playerid,"Vetement 139")) {Inventory_Remove(playerid,"Vetement 139"); SetPlayerSkin(playerid,139);}
	if(Inventory_HasItem(playerid,"Vetement 140")) {Inventory_Remove(playerid,"Vetement 140"); SetPlayerSkin(playerid,140);}
	if(Inventory_HasItem(playerid,"Vetement 141")) {Inventory_Remove(playerid,"Vetement 141"); SetPlayerSkin(playerid,141);}
	if(Inventory_HasItem(playerid,"Vetement 142")) {Inventory_Remove(playerid,"Vetement 142"); SetPlayerSkin(playerid,142);}
	if(Inventory_HasItem(playerid,"Vetement 143")) {Inventory_Remove(playerid,"Vetement 143"); SetPlayerSkin(playerid,143);}
	if(Inventory_HasItem(playerid,"Vetement 144")) {Inventory_Remove(playerid,"Vetement 144"); SetPlayerSkin(playerid,144);}
	if(Inventory_HasItem(playerid,"Vetement 145")) {Inventory_Remove(playerid,"Vetement 145"); SetPlayerSkin(playerid,145);}
	if(Inventory_HasItem(playerid,"Vetement 146")) {Inventory_Remove(playerid,"Vetement 146"); SetPlayerSkin(playerid,146);}
	if(Inventory_HasItem(playerid,"Vetement 147")) {Inventory_Remove(playerid,"Vetement 147"); SetPlayerSkin(playerid,147);}
	if(Inventory_HasItem(playerid,"Vetement 148")) {Inventory_Remove(playerid,"Vetement 148"); SetPlayerSkin(playerid,148);}
	if(Inventory_HasItem(playerid,"Vetement 149")) {Inventory_Remove(playerid,"Vetement 149"); SetPlayerSkin(playerid,149);}
	if(Inventory_HasItem(playerid,"Vetement 150")) {Inventory_Remove(playerid,"Vetement 150"); SetPlayerSkin(playerid,150);}
	if(Inventory_HasItem(playerid,"Vetement 151")) {Inventory_Remove(playerid,"Vetement 151"); SetPlayerSkin(playerid,151);}
	if(Inventory_HasItem(playerid,"Vetement 152")) {Inventory_Remove(playerid,"Vetement 152"); SetPlayerSkin(playerid,152);}
	if(Inventory_HasItem(playerid,"Vetement 153")) {Inventory_Remove(playerid,"Vetement 153"); SetPlayerSkin(playerid,153);}
	if(Inventory_HasItem(playerid,"Vetement 154")) {Inventory_Remove(playerid,"Vetement 154"); SetPlayerSkin(playerid,154);}
	if(Inventory_HasItem(playerid,"Vetement 155")) {Inventory_Remove(playerid,"Vetement 155"); SetPlayerSkin(playerid,155);}
	if(Inventory_HasItem(playerid,"Vetement 156")) {Inventory_Remove(playerid,"Vetement 156"); SetPlayerSkin(playerid,156);}
	if(Inventory_HasItem(playerid,"Vetement 157")) {Inventory_Remove(playerid,"Vetement 157"); SetPlayerSkin(playerid,157);}
	if(Inventory_HasItem(playerid,"Vetement 158")) {Inventory_Remove(playerid,"Vetement 158"); SetPlayerSkin(playerid,158);}
	if(Inventory_HasItem(playerid,"Vetement 159")) {Inventory_Remove(playerid,"Vetement 159"); SetPlayerSkin(playerid,159);}
	if(Inventory_HasItem(playerid,"Vetement 160")) {Inventory_Remove(playerid,"Vetement 160"); SetPlayerSkin(playerid,160);}
	if(Inventory_HasItem(playerid,"Vetement 161")) {Inventory_Remove(playerid,"Vetement 161"); SetPlayerSkin(playerid,161);}
	if(Inventory_HasItem(playerid,"Vetement 162")) {Inventory_Remove(playerid,"Vetement 162"); SetPlayerSkin(playerid,162);}
	if(Inventory_HasItem(playerid,"Vetement 160")) {Inventory_Remove(playerid,"Vetement 160"); SetPlayerSkin(playerid,160);}
	if(Inventory_HasItem(playerid,"Vetement 161")) {Inventory_Remove(playerid,"Vetement 161"); SetPlayerSkin(playerid,161);}
	if(Inventory_HasItem(playerid,"Vetement 162")) {Inventory_Remove(playerid,"Vetement 162"); SetPlayerSkin(playerid,162);}
	if(Inventory_HasItem(playerid,"Vetement 163")) {Inventory_Remove(playerid,"Vetement 163"); SetPlayerSkin(playerid,163);}
	if(Inventory_HasItem(playerid,"Vetement 164")) {Inventory_Remove(playerid,"Vetement 164"); SetPlayerSkin(playerid,164);}
	if(Inventory_HasItem(playerid,"Vetement 165")) {Inventory_Remove(playerid,"Vetement 165"); SetPlayerSkin(playerid,165);}
	if(Inventory_HasItem(playerid,"Vetement 166")) {Inventory_Remove(playerid,"Vetement 166"); SetPlayerSkin(playerid,166);}
	if(Inventory_HasItem(playerid,"Vetement 167")) {Inventory_Remove(playerid,"Vetement 167"); SetPlayerSkin(playerid,167);}
	if(Inventory_HasItem(playerid,"Vetement 168")) {Inventory_Remove(playerid,"Vetement 168"); SetPlayerSkin(playerid,168);}
	if(Inventory_HasItem(playerid,"Vetement 169")) {Inventory_Remove(playerid,"Vetement 169"); SetPlayerSkin(playerid,169);}
	if(Inventory_HasItem(playerid,"Vetement 170")) {Inventory_Remove(playerid,"Vetement 170"); SetPlayerSkin(playerid,170);}
	if(Inventory_HasItem(playerid,"Vetement 171")) {Inventory_Remove(playerid,"Vetement 171"); SetPlayerSkin(playerid,171);}
	if(Inventory_HasItem(playerid,"Vetement 172")) {Inventory_Remove(playerid,"Vetement 172"); SetPlayerSkin(playerid,172);}
	if(Inventory_HasItem(playerid,"Vetement 173")) {Inventory_Remove(playerid,"Vetement 173"); SetPlayerSkin(playerid,173);}
	if(Inventory_HasItem(playerid,"Vetement 174")) {Inventory_Remove(playerid,"Vetement 174"); SetPlayerSkin(playerid,174);}
	if(Inventory_HasItem(playerid,"Vetement 175")) {Inventory_Remove(playerid,"Vetement 175"); SetPlayerSkin(playerid,175);}
	if(Inventory_HasItem(playerid,"Vetement 176")) {Inventory_Remove(playerid,"Vetement 176"); SetPlayerSkin(playerid,176);}
	if(Inventory_HasItem(playerid,"Vetement 177")) {Inventory_Remove(playerid,"Vetement 177"); SetPlayerSkin(playerid,177);}
	if(Inventory_HasItem(playerid,"Vetement 178")) {Inventory_Remove(playerid,"Vetement 178"); SetPlayerSkin(playerid,178);}
	if(Inventory_HasItem(playerid,"Vetement 179")) {Inventory_Remove(playerid,"Vetement 179"); SetPlayerSkin(playerid,179);}
	if(Inventory_HasItem(playerid,"Vetement 180")) {Inventory_Remove(playerid,"Vetement 180"); SetPlayerSkin(playerid,180);}
	if(Inventory_HasItem(playerid,"Vetement 181")) {Inventory_Remove(playerid,"Vetement 181"); SetPlayerSkin(playerid,181);}
	if(Inventory_HasItem(playerid,"Vetement 182")) {Inventory_Remove(playerid,"Vetement 182"); SetPlayerSkin(playerid,182);}
	if(Inventory_HasItem(playerid,"Vetement 183")) {Inventory_Remove(playerid,"Vetement 183"); SetPlayerSkin(playerid,183);}
	if(Inventory_HasItem(playerid,"Vetement 184")) {Inventory_Remove(playerid,"Vetement 184"); SetPlayerSkin(playerid,184);}
	if(Inventory_HasItem(playerid,"Vetement 185")) {Inventory_Remove(playerid,"Vetement 185"); SetPlayerSkin(playerid,185);}
	if(Inventory_HasItem(playerid,"Vetement 186")) {Inventory_Remove(playerid,"Vetement 186"); SetPlayerSkin(playerid,186);}
	if(Inventory_HasItem(playerid,"Vetement 187")) {Inventory_Remove(playerid,"Vetement 187"); SetPlayerSkin(playerid,187);}
	if(Inventory_HasItem(playerid,"Vetement 188")) {Inventory_Remove(playerid,"Vetement 188"); SetPlayerSkin(playerid,188);}
	if(Inventory_HasItem(playerid,"Vetement 189")) {Inventory_Remove(playerid,"Vetement 189"); SetPlayerSkin(playerid,189);}
	if(Inventory_HasItem(playerid,"Vetement 190")) {Inventory_Remove(playerid,"Vetement 190"); SetPlayerSkin(playerid,190);}
	if(Inventory_HasItem(playerid,"Vetement 191")) {Inventory_Remove(playerid,"Vetement 191"); SetPlayerSkin(playerid,191);}
	if(Inventory_HasItem(playerid,"Vetement 192")) {Inventory_Remove(playerid,"Vetement 192"); SetPlayerSkin(playerid,192);}
	if(Inventory_HasItem(playerid,"Vetement 193")) {Inventory_Remove(playerid,"Vetement 193"); SetPlayerSkin(playerid,193);}
	if(Inventory_HasItem(playerid,"Vetement 194")) {Inventory_Remove(playerid,"Vetement 194"); SetPlayerSkin(playerid,194);}
	if(Inventory_HasItem(playerid,"Vetement 195")) {Inventory_Remove(playerid,"Vetement 195"); SetPlayerSkin(playerid,195);}
	if(Inventory_HasItem(playerid,"Vetement 196")) {Inventory_Remove(playerid,"Vetement 196"); SetPlayerSkin(playerid,196);}
	if(Inventory_HasItem(playerid,"Vetement 197")) {Inventory_Remove(playerid,"Vetement 197"); SetPlayerSkin(playerid,197);}
	if(Inventory_HasItem(playerid,"Vetement 198")) {Inventory_Remove(playerid,"Vetement 198"); SetPlayerSkin(playerid,198);}
	if(Inventory_HasItem(playerid,"Vetement 199")) {Inventory_Remove(playerid,"Vetement 199"); SetPlayerSkin(playerid,199);}
	if(Inventory_HasItem(playerid,"Vetement 200")) {Inventory_Remove(playerid,"Vetement 200"); SetPlayerSkin(playerid,200);}
	if(Inventory_HasItem(playerid,"Vetement 201")) {Inventory_Remove(playerid,"Vetement 201"); SetPlayerSkin(playerid,201);}
	if(Inventory_HasItem(playerid,"Vetement 202")) {Inventory_Remove(playerid,"Vetement 202"); SetPlayerSkin(playerid,202);}
	if(Inventory_HasItem(playerid,"Vetement 203")) {Inventory_Remove(playerid,"Vetement 203"); SetPlayerSkin(playerid,203);}
	if(Inventory_HasItem(playerid,"Vetement 204")) {Inventory_Remove(playerid,"Vetement 204"); SetPlayerSkin(playerid,204);}
	if(Inventory_HasItem(playerid,"Vetement 205")) {Inventory_Remove(playerid,"Vetement 205"); SetPlayerSkin(playerid,205);}
	if(Inventory_HasItem(playerid,"Vetement 206")) {Inventory_Remove(playerid,"Vetement 206"); SetPlayerSkin(playerid,206);}
	if(Inventory_HasItem(playerid,"Vetement 207")) {Inventory_Remove(playerid,"Vetement 207"); SetPlayerSkin(playerid,207);}
	if(Inventory_HasItem(playerid,"Vetement 208")) {Inventory_Remove(playerid,"Vetement 208"); SetPlayerSkin(playerid,208);}
	if(Inventory_HasItem(playerid,"Vetement 209")) {Inventory_Remove(playerid,"Vetement 209"); SetPlayerSkin(playerid,209);}
	if(Inventory_HasItem(playerid,"Vetement 210")) {Inventory_Remove(playerid,"Vetement 210"); SetPlayerSkin(playerid,210);}
	if(Inventory_HasItem(playerid,"Vetement 211")) {Inventory_Remove(playerid,"Vetement 211"); SetPlayerSkin(playerid,211);}
	if(Inventory_HasItem(playerid,"Vetement 212")) {Inventory_Remove(playerid,"Vetement 212"); SetPlayerSkin(playerid,212);}
	if(Inventory_HasItem(playerid,"Vetement 213")) {Inventory_Remove(playerid,"Vetement 213"); SetPlayerSkin(playerid,213);}
	if(Inventory_HasItem(playerid,"Vetement 214")) {Inventory_Remove(playerid,"Vetement 214"); SetPlayerSkin(playerid,214);}
	if(Inventory_HasItem(playerid,"Vetement 215")) {Inventory_Remove(playerid,"Vetement 215"); SetPlayerSkin(playerid,215);}
	if(Inventory_HasItem(playerid,"Vetement 216")) {Inventory_Remove(playerid,"Vetement 216"); SetPlayerSkin(playerid,216);}
	if(Inventory_HasItem(playerid,"Vetement 217")) {Inventory_Remove(playerid,"Vetement 217"); SetPlayerSkin(playerid,217);}
	if(Inventory_HasItem(playerid,"Vetement 218")) {Inventory_Remove(playerid,"Vetement 218"); SetPlayerSkin(playerid,218);}
	if(Inventory_HasItem(playerid,"Vetement 219")) {Inventory_Remove(playerid,"Vetement 219"); SetPlayerSkin(playerid,219);}
	if(Inventory_HasItem(playerid,"Vetement 220")) {Inventory_Remove(playerid,"Vetement 220"); SetPlayerSkin(playerid,220);}
	if(Inventory_HasItem(playerid,"Vetement 221")) {Inventory_Remove(playerid,"Vetement 221"); SetPlayerSkin(playerid,221);}
	if(Inventory_HasItem(playerid,"Vetement 222")) {Inventory_Remove(playerid,"Vetement 222"); SetPlayerSkin(playerid,222);}
	if(Inventory_HasItem(playerid,"Vetement 223")) {Inventory_Remove(playerid,"Vetement 223"); SetPlayerSkin(playerid,223);}
	if(Inventory_HasItem(playerid,"Vetement 224")) {Inventory_Remove(playerid,"Vetement 224"); SetPlayerSkin(playerid,224);}
	if(Inventory_HasItem(playerid,"Vetement 225")) {Inventory_Remove(playerid,"Vetement 225"); SetPlayerSkin(playerid,225);}
	if(Inventory_HasItem(playerid,"Vetement 226")) {Inventory_Remove(playerid,"Vetement 226"); SetPlayerSkin(playerid,226);}
	if(Inventory_HasItem(playerid,"Vetement 227")) {Inventory_Remove(playerid,"Vetement 227"); SetPlayerSkin(playerid,227);}
	if(Inventory_HasItem(playerid,"Vetement 228")) {Inventory_Remove(playerid,"Vetement 228"); SetPlayerSkin(playerid,228);}
	if(Inventory_HasItem(playerid,"Vetement 229")) {Inventory_Remove(playerid,"Vetement 229"); SetPlayerSkin(playerid,229);}
	if(Inventory_HasItem(playerid,"Vetement 230")) {Inventory_Remove(playerid,"Vetement 230"); SetPlayerSkin(playerid,230);}
	if(Inventory_HasItem(playerid,"Vetement 231")) {Inventory_Remove(playerid,"Vetement 231"); SetPlayerSkin(playerid,231);}
	if(Inventory_HasItem(playerid,"Vetement 232")) {Inventory_Remove(playerid,"Vetement 232"); SetPlayerSkin(playerid,232);}
	if(Inventory_HasItem(playerid,"Vetement 233")) {Inventory_Remove(playerid,"Vetement 233"); SetPlayerSkin(playerid,233);}
	if(Inventory_HasItem(playerid,"Vetement 234")) {Inventory_Remove(playerid,"Vetement 234"); SetPlayerSkin(playerid,234);}
	if(Inventory_HasItem(playerid,"Vetement 235")) {Inventory_Remove(playerid,"Vetement 235"); SetPlayerSkin(playerid,235);}
	if(Inventory_HasItem(playerid,"Vetement 236")) {Inventory_Remove(playerid,"Vetement 236"); SetPlayerSkin(playerid,236);}
	if(Inventory_HasItem(playerid,"Vetement 237")) {Inventory_Remove(playerid,"Vetement 237"); SetPlayerSkin(playerid,237);}
	if(Inventory_HasItem(playerid,"Vetement 238")) {Inventory_Remove(playerid,"Vetement 238"); SetPlayerSkin(playerid,238);}
	if(Inventory_HasItem(playerid,"Vetement 239")) {Inventory_Remove(playerid,"Vetement 239"); SetPlayerSkin(playerid,239);}
	if(Inventory_HasItem(playerid,"Vetement 240")) {Inventory_Remove(playerid,"Vetement 240"); SetPlayerSkin(playerid,240);}
	if(Inventory_HasItem(playerid,"Vetement 241")) {Inventory_Remove(playerid,"Vetement 241"); SetPlayerSkin(playerid,241);}
	if(Inventory_HasItem(playerid,"Vetement 242")) {Inventory_Remove(playerid,"Vetement 242"); SetPlayerSkin(playerid,242);}
	if(Inventory_HasItem(playerid,"Vetement 243")) {Inventory_Remove(playerid,"Vetement 243"); SetPlayerSkin(playerid,243);}
	if(Inventory_HasItem(playerid,"Vetement 244")) {Inventory_Remove(playerid,"Vetement 244"); SetPlayerSkin(playerid,244);}
	if(Inventory_HasItem(playerid,"Vetement 245")) {Inventory_Remove(playerid,"Vetement 245"); SetPlayerSkin(playerid,245);}
	if(Inventory_HasItem(playerid,"Vetement 246")) {Inventory_Remove(playerid,"Vetement 246"); SetPlayerSkin(playerid,246);}
	if(Inventory_HasItem(playerid,"Vetement 247")) {Inventory_Remove(playerid,"Vetement 247"); SetPlayerSkin(playerid,247);}
	if(Inventory_HasItem(playerid,"Vetement 248")) {Inventory_Remove(playerid,"Vetement 248"); SetPlayerSkin(playerid,248);}
	if(Inventory_HasItem(playerid,"Vetement 249")) {Inventory_Remove(playerid,"Vetement 249"); SetPlayerSkin(playerid,249);}
	if(Inventory_HasItem(playerid,"Vetement 250")) {Inventory_Remove(playerid,"Vetement 250"); SetPlayerSkin(playerid,250);}
	if(Inventory_HasItem(playerid,"Vetement 251")) {Inventory_Remove(playerid,"Vetement 251"); SetPlayerSkin(playerid,251);}
	if(Inventory_HasItem(playerid,"Vetement 252")) {Inventory_Remove(playerid,"Vetement 252"); SetPlayerSkin(playerid,252);}
	if(Inventory_HasItem(playerid,"Vetement 253")) {Inventory_Remove(playerid,"Vetement 253"); SetPlayerSkin(playerid,253);}
	if(Inventory_HasItem(playerid,"Vetement 254")) {Inventory_Remove(playerid,"Vetement 254"); SetPlayerSkin(playerid,254);}
	if(Inventory_HasItem(playerid,"Vetement 255")) {Inventory_Remove(playerid,"Vetement 255"); SetPlayerSkin(playerid,255);}
	if(Inventory_HasItem(playerid,"Vetement 256")) {Inventory_Remove(playerid,"Vetement 256"); SetPlayerSkin(playerid,256);}
	if(Inventory_HasItem(playerid,"Vetement 257")) {Inventory_Remove(playerid,"Vetement 257"); SetPlayerSkin(playerid,257);}
	if(Inventory_HasItem(playerid,"Vetement 258")) {Inventory_Remove(playerid,"Vetement 258"); SetPlayerSkin(playerid,258);}
	if(Inventory_HasItem(playerid,"Vetement 259")) {Inventory_Remove(playerid,"Vetement 259"); SetPlayerSkin(playerid,259);}
	if(Inventory_HasItem(playerid,"Vetement 260")) {Inventory_Remove(playerid,"Vetement 260"); SetPlayerSkin(playerid,260);}
	if(Inventory_HasItem(playerid,"Vetement 261")) {Inventory_Remove(playerid,"Vetement 261"); SetPlayerSkin(playerid,261);}
	if(Inventory_HasItem(playerid,"Vetement 262")) {Inventory_Remove(playerid,"Vetement 262"); SetPlayerSkin(playerid,262);}
	if(Inventory_HasItem(playerid,"Vetement 260")) {Inventory_Remove(playerid,"Vetement 260"); SetPlayerSkin(playerid,260);}
	if(Inventory_HasItem(playerid,"Vetement 261")) {Inventory_Remove(playerid,"Vetement 261"); SetPlayerSkin(playerid,261);}
	if(Inventory_HasItem(playerid,"Vetement 262")) {Inventory_Remove(playerid,"Vetement 262"); SetPlayerSkin(playerid,262);}
	if(Inventory_HasItem(playerid,"Vetement 263")) {Inventory_Remove(playerid,"Vetement 263"); SetPlayerSkin(playerid,263);}
	if(Inventory_HasItem(playerid,"Vetement 264")) {Inventory_Remove(playerid,"Vetement 264"); SetPlayerSkin(playerid,264);}
	if(Inventory_HasItem(playerid,"Vetement 265")) {Inventory_Remove(playerid,"Vetement 265"); SetPlayerSkin(playerid,265);}
	if(Inventory_HasItem(playerid,"Vetement 266")) {Inventory_Remove(playerid,"Vetement 266"); SetPlayerSkin(playerid,266);}
	if(Inventory_HasItem(playerid,"Vetement 267")) {Inventory_Remove(playerid,"Vetement 267"); SetPlayerSkin(playerid,267);}
	if(Inventory_HasItem(playerid,"Vetement 268")) {Inventory_Remove(playerid,"Vetement 268"); SetPlayerSkin(playerid,268);}
	if(Inventory_HasItem(playerid,"Vetement 269")) {Inventory_Remove(playerid,"Vetement 269"); SetPlayerSkin(playerid,269);}
	if(Inventory_HasItem(playerid,"Vetement 270")) {Inventory_Remove(playerid,"Vetement 270"); SetPlayerSkin(playerid,270);}
	if(Inventory_HasItem(playerid,"Vetement 271")) {Inventory_Remove(playerid,"Vetement 271"); SetPlayerSkin(playerid,271);}
	if(Inventory_HasItem(playerid,"Vetement 272")) {Inventory_Remove(playerid,"Vetement 272"); SetPlayerSkin(playerid,272);}
	if(Inventory_HasItem(playerid,"Vetement 273")) {Inventory_Remove(playerid,"Vetement 273"); SetPlayerSkin(playerid,273);}
	if(Inventory_HasItem(playerid,"Vetement 274")) {Inventory_Remove(playerid,"Vetement 274"); SetPlayerSkin(playerid,274);}
	if(Inventory_HasItem(playerid,"Vetement 275")) {Inventory_Remove(playerid,"Vetement 275"); SetPlayerSkin(playerid,275);}
	if(Inventory_HasItem(playerid,"Vetement 276")) {Inventory_Remove(playerid,"Vetement 276"); SetPlayerSkin(playerid,276);}
	if(Inventory_HasItem(playerid,"Vetement 277")) {Inventory_Remove(playerid,"Vetement 277"); SetPlayerSkin(playerid,277);}
	if(Inventory_HasItem(playerid,"Vetement 278")) {Inventory_Remove(playerid,"Vetement 278"); SetPlayerSkin(playerid,278);}
	if(Inventory_HasItem(playerid,"Vetement 279")) {Inventory_Remove(playerid,"Vetement 279"); SetPlayerSkin(playerid,279);}
	if(Inventory_HasItem(playerid,"Vetement 280")) {Inventory_Remove(playerid,"Vetement 280"); SetPlayerSkin(playerid,280);}
	if(Inventory_HasItem(playerid,"Vetement 281")) {Inventory_Remove(playerid,"Vetement 281"); SetPlayerSkin(playerid,281);}
	if(Inventory_HasItem(playerid,"Vetement 282")) {Inventory_Remove(playerid,"Vetement 282"); SetPlayerSkin(playerid,282);}
	if(Inventory_HasItem(playerid,"Vetement 283")) {Inventory_Remove(playerid,"Vetement 283"); SetPlayerSkin(playerid,283);}
	if(Inventory_HasItem(playerid,"Vetement 284")) {Inventory_Remove(playerid,"Vetement 284"); SetPlayerSkin(playerid,284);}
	if(Inventory_HasItem(playerid,"Vetement 285")) {Inventory_Remove(playerid,"Vetement 285"); SetPlayerSkin(playerid,285);}
	if(Inventory_HasItem(playerid,"Vetement 286")) {Inventory_Remove(playerid,"Vetement 286"); SetPlayerSkin(playerid,286);}
	if(Inventory_HasItem(playerid,"Vetement 287")) {Inventory_Remove(playerid,"Vetement 287"); SetPlayerSkin(playerid,287);}
	if(Inventory_HasItem(playerid,"Vetement 288")) {Inventory_Remove(playerid,"Vetement 288"); SetPlayerSkin(playerid,288);}
	if(Inventory_HasItem(playerid,"Vetement 289")) {Inventory_Remove(playerid,"Vetement 289"); SetPlayerSkin(playerid,289);}
	if(Inventory_HasItem(playerid,"Vetement 290")) {Inventory_Remove(playerid,"Vetement 290"); SetPlayerSkin(playerid,290);}
	if(Inventory_HasItem(playerid,"Vetement 291")) {Inventory_Remove(playerid,"Vetement 291"); SetPlayerSkin(playerid,291);}
	if(Inventory_HasItem(playerid,"Vetement 292")) {Inventory_Remove(playerid,"Vetement 292"); SetPlayerSkin(playerid,292);}
	if(Inventory_HasItem(playerid,"Vetement 293")) {Inventory_Remove(playerid,"Vetement 293"); SetPlayerSkin(playerid,293);}
	if(Inventory_HasItem(playerid,"Vetement 294")) {Inventory_Remove(playerid,"Vetement 294"); SetPlayerSkin(playerid,294);}
	if(Inventory_HasItem(playerid,"Vetement 295")) {Inventory_Remove(playerid,"Vetement 295"); SetPlayerSkin(playerid,295);}
	if(Inventory_HasItem(playerid,"Vetement 296")) {Inventory_Remove(playerid,"Vetement 296"); SetPlayerSkin(playerid,296);}
	if(Inventory_HasItem(playerid,"Vetement 297")) {Inventory_Remove(playerid,"Vetement 297"); SetPlayerSkin(playerid,297);}
	if(Inventory_HasItem(playerid,"Vetement 298")) {Inventory_Remove(playerid,"Vetement 298"); SetPlayerSkin(playerid,298);}
	if(Inventory_HasItem(playerid,"Vetement 299")) {Inventory_Remove(playerid,"Vetement 299"); SetPlayerSkin(playerid,299);}
	if(Inventory_HasItem(playerid,"Vetement 300")) {Inventory_Remove(playerid,"Vetement 300"); SetPlayerSkin(playerid,300);}
	if(Inventory_HasItem(playerid,"Vetement 301")) {Inventory_Remove(playerid,"Vetement 301"); SetPlayerSkin(playerid,301);}
	if(Inventory_HasItem(playerid,"Vetement 302")) {Inventory_Remove(playerid,"Vetement 302"); SetPlayerSkin(playerid,302);}
	if(Inventory_HasItem(playerid,"Vetement 303")) {Inventory_Remove(playerid,"Vetement 303"); SetPlayerSkin(playerid,303);}
	if(Inventory_HasItem(playerid,"Vetement 304")) {Inventory_Remove(playerid,"Vetement 304"); SetPlayerSkin(playerid,304);}
	if(Inventory_HasItem(playerid,"Vetement 305")) {Inventory_Remove(playerid,"Vetement 305"); SetPlayerSkin(playerid,305);}
	if(Inventory_HasItem(playerid,"Vetement 306")) {Inventory_Remove(playerid,"Vetement 306"); SetPlayerSkin(playerid,306);}
	if(Inventory_HasItem(playerid,"Vetement 307")) {Inventory_Remove(playerid,"Vetement 307"); SetPlayerSkin(playerid,307);}
	if(Inventory_HasItem(playerid,"Vetement 308")) {Inventory_Remove(playerid,"Vetement 308"); SetPlayerSkin(playerid,308);}
	if(Inventory_HasItem(playerid,"Vetement 309")) {Inventory_Remove(playerid,"Vetement 309"); SetPlayerSkin(playerid,309);}
	if(Inventory_HasItem(playerid,"Vetement 310")) {Inventory_Remove(playerid,"Vetement 310"); SetPlayerSkin(playerid,310);}
	if(Inventory_HasItem(playerid,"Vetement 311")) {Inventory_Remove(playerid,"Vetement 311"); SetPlayerSkin(playerid,311);}
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort des vetements et se change.", ReturnName(playerid, 0));
	return 1;
}
//job nouveau petrolier
CMD:petrolier(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_PETROLIER)
	    return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
	if (!IsPlayerNearPetrol(playerid))
	    return SendErrorMessage(playerid, "Vous devez être proche du lieu de prendre le pétrol");
	if (PlayerData[playerid][pPetrol])
	{
	    PlayerData[playerid][pPetrol] = false;
	    PlayerData[playerid][pPetrolCount] = 0;
		RemovePlayerAttachedObject(playerid, 4);
	    SendServerMessage(playerid, "Vous avez fini votre job.");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else
	{
	    PlayerData[playerid][pPetrol] = true;
        PlayerData[playerid][pPetrolCount] = 0;
	}
	return 1;
}
CMD:tun(playerid,params[])
{
	new car = GetPlayerVehicleID(playerid);
	if(Inventory_HasItem(playerid,"dual muffler"))
	{
		if(pmodelid[playerid] == 518||pmodelid[playerid] == 415||pmodelid[playerid] == 542||pmodelid[playerid] == 546||pmodelid[playerid] == 400||pmodelid[playerid] == 517||pmodelid[playerid] == 603||pmodelid[playerid] == 426||pmodelid[playerid] == 436||pmodelid[playerid] == 547||pmodelid[playerid] == 405||pmodelid[playerid] == 550||pmodelid[playerid] == 549 || pmodelid[playerid] == 477) // zr-350
       	{
            AddVehicleComponent(car,1019);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			Inventory_Remove(playerid, "dual muffler",1);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		}
	}
	if(Inventory_HasItem(playerid,"improved muffler"))
	{
	   	if(pmodelid[playerid] == 401 || pmodelid[playerid] == 518 || pmodelid[playerid] == 527 || pmodelid[playerid] == 542 || pmodelid[playerid] == 589 || pmodelid[playerid] == 400 || pmodelid[playerid] == 603 || pmodelid[playerid] == 436 || pmodelid[playerid] == 547 || pmodelid[playerid] == 405 || pmodelid[playerid] == 580 || pmodelid[playerid] == 550 || pmodelid[playerid] == 549 || pmodelid[playerid] == 477 || pmodelid[playerid] == 517) // majestic
        {
            AddVehicleComponent(car,1020);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "improved muffler",1);
		}
	}
	if(Inventory_HasItem(playerid,"medium muffler"))
	{
       	if(pmodelid[playerid] == 527 || pmodelid[playerid] == 542 || pmodelid[playerid] == 400 || pmodelid[playerid] == 426 || pmodelid[playerid] == 436 || pmodelid[playerid] == 547 || pmodelid[playerid] == 405 || pmodelid[playerid] == 477) // zr350
        {
            AddVehicleComponent(car,1021);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            Inventory_Remove(playerid, "medium muffler",1);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		}
	}
	if(Inventory_HasItem(playerid,"small muffler"))
	{
	   	if(pmodelid[playerid] == 436) // previon
	   	{
			AddVehicleComponent(car,1022);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            Inventory_Remove(playerid, "small muffler",1);
            SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		}
	}
	if(Inventory_HasItem(playerid,"exhaust pipe"))
	{
       	if(pmodelid[playerid] == 415 || pmodelid[playerid] == 518 || pmodelid[playerid] == 527 || pmodelid[playerid] == 542 || pmodelid[playerid] == 589 || pmodelid[playerid] == 400 || pmodelid[playerid] == 603 || pmodelid[playerid] == 546 || pmodelid[playerid] == 547 || pmodelid[playerid] == 405 || pmodelid[playerid] == 580 || pmodelid[playerid] == 550 || pmodelid[playerid] == 549 || pmodelid[playerid] == 477 || pmodelid[playerid] == 517) // majestic
       	{
			AddVehicleComponent(car,1018);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            Inventory_Remove(playerid, "exhaust pipe",1);
            SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		}
	}
	if(Inventory_HasItem(playerid,"double small pipe"))
	{
		if(pmodelid[playerid] == 562)
		{
		   	AddVehicleComponent(car,1034);
		   	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double small pipe",1);
		}
		if(pmodelid[playerid] == 565)
		{
			AddVehicleComponent(car,1046);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "double small pipe",1);
		}
		if(pmodelid[playerid] == 559)
		{
			AddVehicleComponent(car,1065);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "double small pipe",1);
		}
		if(pmodelid[playerid] == 561)
		{
			AddVehicleComponent(car,1064);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "double small pipe",1);
		}
		if(pmodelid[playerid] == 560)
		{
			AddVehicleComponent(car,1028);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "double small pipe",1);
		}
		if(pmodelid[playerid] == 558)
		{
			AddVehicleComponent(car,1089);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "double small pipe",1);
	    }
	}
	if(Inventory_HasItem(playerid,"double large pipe"))
	{
		if(pmodelid[playerid] == 562)
		{
		    AddVehicleComponent(car,1037);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double large pipe",1);
		}
		if(pmodelid[playerid] == 565)
		{
		    AddVehicleComponent(car,1045);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double large pipe",1);
		}
		if(pmodelid[playerid] == 559)
		{
		    AddVehicleComponent(car,1066);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double large pipe",1);
		}
		if(pmodelid[playerid] == 561)
		{
		    AddVehicleComponent(car,1059);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double large pipe",1);
		}
		if(pmodelid[playerid] == 560)
		{
		    AddVehicleComponent(car,1029);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double large pipe",1);
		}
		if(pmodelid[playerid] == 558)
		{
		    AddVehicleComponent(car,1092);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double large pipe",1);
		}
	}//9008
	if(Inventory_HasItem(playerid,"up pipe"))
	{
        if(pmodelid[playerid] == 575) // Brodway
        {
            AddVehicleComponent(car,1044);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
          	SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "up pipe",1);
		}
		else if(pmodelid[playerid] == 534)// Remington
		{
		    AddVehicleComponent(car,1126);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "up pipe",1);
		}
		else if(pmodelid[playerid] == 567)// Savanna
		{
		    AddVehicleComponent(car,1129);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	        SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "up pipe",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
		    AddVehicleComponent(car,1104);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "up pipe",1);
		}
		else if(pmodelid[playerid] == 535) // Slamvan
		{
 			AddVehicleComponent(car,1113);
 			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "up pipe",1);
		}
		else if(pmodelid[playerid] == 576) // Tornado
		{
		    AddVehicleComponent(car,1136);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		   	SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "up pipe",1);
		}
	}
	if(Inventory_HasItem(playerid,"double long pipe"))
	{
        if(pmodelid[playerid] == 575) // Brodway
        {
            AddVehicleComponent(car,1043);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "double long pipe",1);
		}
		else if(pmodelid[playerid] == 534)// Remington
		{
		    AddVehicleComponent(car,1127);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double long pipe",1);
		}
		else if(pmodelid[playerid] == 567)// Savanna
		{
		    AddVehicleComponent(car,1132);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double long pipe",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
		    AddVehicleComponent(car,1105);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double long pipe",1);
		}

		else if(pmodelid[playerid] == 535) // Slamvan
		{
		    AddVehicleComponent(car,1114);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double long pipe",1);
		}

		else if(pmodelid[playerid] == 576) // Tornado
		{
		    AddVehicleComponent(car,1135);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "double long pipe",1);
		}
	}
	if(Inventory_HasItem(playerid,"round light"))
	{
		if(pmodelid[playerid] == 401 || pmodelid[playerid] == 518 ||pmodelid[playerid] == 589 || pmodelid[playerid] == 400 || pmodelid[playerid] == 436 || pmodelid[playerid] == 439) // stallion
		{
			AddVehicleComponent(car,1013);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "round light",1);
		}
	}
	if(Inventory_HasItem(playerid,"square light"))
	{
       	if(pmodelid[playerid] == 589 || pmodelid[playerid] == 603 || pmodelid[playerid] == 400) // landstalker
		{
			AddVehicleComponent(car,1024);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "square light",1);
		}
	}
	if(Inventory_HasItem(playerid,"oval vents"))
	{
		if(pmodelid[playerid] == 401 || pmodelid[playerid] == 518 || pmodelid[playerid] == 546 || pmodelid[playerid] == 517 || pmodelid[playerid] == 603 || pmodelid[playerid] == 547 || pmodelid[playerid] == 439 || pmodelid[playerid] == 550 || pmodelid[playerid] == 549) //majestic primo sunrise tampa statlion phoniex intruder bucanner bravura
		{
			AddVehicleComponent(car,1142);
			AddVehicleComponent(car,1143);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "oval vents",1);
		}
	}
	if(Inventory_HasItem(playerid,"square vents"))
	{
		if(pmodelid[playerid] == 401 || pmodelid[playerid] == 518 || pmodelid[playerid] == 589 || pmodelid[playerid] == 546 || pmodelid[playerid] == 517 || pmodelid[playerid] == 603 ||pmodelid[playerid] == 439 || pmodelid[playerid] == 550 || pmodelid[playerid] == 549) //bravura buccaneer club intruder majestic phoenix stallion sunrise tampa
		{
			AddVehicleComponent(car,1144);
			AddVehicleComponent(car,1145);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "square vents",1);
		}
	}
	if(Inventory_HasItem(playerid,"stereo"))
	{
		AddVehicleComponent(car,1086);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		Inventory_Remove(playerid, "stereo",1);
	}
	if(Inventory_HasItem(playerid,"bar square"))
	{
		if(pmodelid[playerid] == 534) // Remington
		{
			AddVehicleComponent(car,1100);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "bar square",1);
		}
	}
	if(Inventory_HasItem(playerid,"bar grill"))
	{
	    if(pmodelid[playerid] == 534) // Remington
		{
			AddVehicleComponent(car,1123);
            SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "bar grill",1);
		}
	}
	if(Inventory_HasItem(playerid,"bar lights"))
	{
		if(pmodelid[playerid] == 534) // Remington
		{
			AddVehicleComponent(car,1125);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "bar lights",1);
		}
	}
	if(Inventory_HasItem(playerid,"bar solid"))
	{
		if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1117);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "bar solid",1);
		}
	}
	if(Inventory_HasItem(playerid,"hood fury"))
	{
		if(pmodelid[playerid] == 401 || pmodelid[playerid] == 518 || pmodelid[playerid] == 589 || pmodelid[playerid] == 492 || pmodelid[playerid] == 426 || pmodelid[playerid] == 550) //bravura buccaneer club greenwood premier sunrise
		{
			AddVehicleComponent(car,1005);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
           	Inventory_Remove(playerid, "hood fury",1);
		}
	}
	if(Inventory_HasItem(playerid,"hood champ"))
	{
		if(pmodelid[playerid] == 401 || pmodelid[playerid] == 546 || pmodelid[playerid] == 492 || pmodelid[playerid] == 426 || pmodelid[playerid] == 550) //bravura intruder greenwood premier sunrise
		{
			AddVehicleComponent(car,1004);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "hood champ",1);
		}
	}
	if(Inventory_HasItem(playerid,"hood race"))
	{
		if(pmodelid[playerid] == 549) // tampa
		{
			AddVehicleComponent(car,1011);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "hood race",1);
		}
	}
	if(Inventory_HasItem(playerid,"hood race"))
	{
		if(pmodelid[playerid] == 549) // tampa
		{
			AddVehicleComponent(car,1012);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "hood worx",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler win"))
	{
		if(pmodelid[playerid] == 401||pmodelid[playerid] == 518||pmodelid[playerid] == 527||pmodelid[playerid] == 415||pmodelid[playerid] == 546||pmodelid[playerid] == 603||pmodelid[playerid] == 426||pmodelid[playerid] == 436||pmodelid[playerid] == 405||pmodelid[playerid] == 477||pmodelid[playerid] == 580||pmodelid[playerid] == 550||pmodelid[playerid] == 549) // tampa
		{
			AddVehicleComponent(car,1001);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "spoiler win",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler alpha"))
	{
		if(pmodelid[playerid] == 518||pmodelid[playerid] == 415||pmodelid[playerid] == 401||pmodelid[playerid] == 517||pmodelid[playerid] == 426||pmodelid[playerid] == 436||pmodelid[playerid] == 477||pmodelid[playerid] == 547||pmodelid[playerid] == 550||pmodelid[playerid] == 549) // tampa
		{
			AddVehicleComponent(car,1003);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "spoiler alpha",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler drag"))
	{
		if(pmodelid[playerid] == 546||pmodelid[playerid] == 517) // majestic
		{
			AddVehicleComponent(car,1002);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
           	Inventory_Remove(playerid, "spoiler drag",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler race"))
	{
		if(pmodelid[playerid] == 527||pmodelid[playerid] == 542 || pmodelid[playerid] == 405) // clover
		{
			AddVehicleComponent(car,1014);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler race",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler pro"))
	{
		if(pmodelid[playerid] == 518||pmodelid[playerid] == 492||pmodelid[playerid] == 547||pmodelid[playerid] == 405) // sentinel
		{
			AddVehicleComponent(car,1000);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler pro",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler alien"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1147);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler alien",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1049);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler alien",1);
		}
		else if(pmodelid[playerid] == 559) // Jester
		{
			AddVehicleComponent(car,1162);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler alien",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1158);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler alien",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1138);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler alien",1);
		}
		else if(pmodelid[playerid] == 558) // Uranus
		{
			AddVehicleComponent(car,1164);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler alien",1);
		}
	}
	if(Inventory_HasItem(playerid,"spoiler xflow"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1146);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler xflow",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1150);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler xflow",1);
		}
		else if(pmodelid[playerid] == 559) // Jetser
		{
			AddVehicleComponent(car,1158);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler xflow",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1060);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler xflow",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1139);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "spoiler xflow",1);
		}
		else if(pmodelid[playerid] == 558)  // Uranus
		{
			AddVehicleComponent(car,1163);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendClientMessage(playerid,COLOR_WHITE,"[INFO]Component successfully added.");
			Inventory_Remove(playerid, "spoiler xflow",1);
		}
	}
	if(Inventory_HasItem(playerid,"roof scoop"))
	{
		if(pmodelid[playerid] == 401||pmodelid[playerid] == 518||pmodelid[playerid] == 589||pmodelid[playerid] == 492||pmodelid[playerid] == 546||pmodelid[playerid] == 603||pmodelid[playerid] == 426||pmodelid[playerid] == 436||pmodelid[playerid] == 580||pmodelid[playerid] == 550||pmodelid[playerid] == 477)
		{
			AddVehicleComponent(car,1006);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof scoop",1);
		}
	}
	if(Inventory_HasItem(playerid,"roof soft"))
	{
		if(pmodelid[playerid] == 567) // Savanna
		{
			AddVehicleComponent(car,1131);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof soft",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
			AddVehicleComponent(car,1103);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof soft",1);
		}
	}
	if(Inventory_HasItem(playerid,"roof hard"))
	{
        if(pmodelid[playerid] == 567) // Savanna
        {
            AddVehicleComponent(car,1130);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
            SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
            Inventory_Remove(playerid, "roof hard",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
		    AddVehicleComponent(car,1128);
            PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof hard",1);
		}
	}
	if(Inventory_HasItem(playerid,"roof xflow"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
		    AddVehicleComponent(car,1035);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof xflow",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
		    AddVehicleComponent(car,1053);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof xflow",1);
		}
		else if(pmodelid[playerid] == 559) // Jetser
		{
		    AddVehicleComponent(car,1068);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof xflow",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
		    AddVehicleComponent(car,1061);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof xflow",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
		    AddVehicleComponent(car,1033);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof xflow",1);
		}
		else if(pmodelid[playerid] == 558)  // Uranus
		{
		    AddVehicleComponent(car,1091);
		    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		    SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "roof xflow",1);
		}
	}
	if(Inventory_HasItem(playerid,"roof alien"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1038);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof alien",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1054);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof alien",1);
		}
		else if(pmodelid[playerid] == 559) // Jester
		{
			AddVehicleComponent(car,1067);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof alien",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1055);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof alien",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1032);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof alien",1);
		}
		else if(pmodelid[playerid] == 558) // Uranus
		{
			AddVehicleComponent(car,1088);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "roof alien",1);
		}
	}
	if(Inventory_HasItem(playerid,"front alien"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1171);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front alien",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1153);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front alien",1);
		}
		else if(pmodelid[playerid] == 559) // Jester
		{
			AddVehicleComponent(car,1160);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front alien",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1155);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front alien",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1169);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front alien",1);
		}
		else if(pmodelid[playerid] == 558) // Uranus
		{
			AddVehicleComponent(car,1166);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front alien",1);
		}
	}
	if(Inventory_HasItem(playerid,"front xflow"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1172);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front xflow",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1152);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front xflow",1);
		}
		else if(pmodelid[playerid] == 559) // Jetser
		{
			AddVehicleComponent(car,1173);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front xflow",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1157);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front xflow",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1170);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front xflow",1);
		}
		else if(pmodelid[playerid] == 558)  // Uranus
		{
			AddVehicleComponent(car,1165);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front xflow",1);
		}
	}
	if(Inventory_HasItem(playerid,"front chrome"))
	{
		if(pmodelid[playerid] == 575) // Brodway
		{
			AddVehicleComponent(car,1174);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front chrome",1);
		}
		else if(pmodelid[playerid] == 534)// Remington
		{
			AddVehicleComponent(car,1179);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front chrome",1);
		}
		else if(pmodelid[playerid] == 567)// Savanna
		{
			AddVehicleComponent(car,1189);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front chrome",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
			AddVehicleComponent(car,1182);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front chrome",1);
		}
		else if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1115);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front chrome",1);
		}
		else if(pmodelid[playerid] == 576) // Tornado
		{
			AddVehicleComponent(car,1191);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front chrome",1);
		}
	}
	if(Inventory_HasItem(playerid,"front slamin"))
	{
		if(pmodelid[playerid] == 575) // Brodway
		{
			AddVehicleComponent(car,1175);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front slamin",1);
		}
		else if(pmodelid[playerid] == 534)// Remington
		{
			AddVehicleComponent(car,1185);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front slamin",1);
		}
		else if(pmodelid[playerid] == 567)// Savanna
		{
			AddVehicleComponent(car,1188);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front slamin",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
			AddVehicleComponent(car,1181);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front slamin",1);
		}
		else if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1116);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front slamin",1);
		}
		else if(pmodelid[playerid] == 576) // Tornado
		{
			AddVehicleComponent(car,1190);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "front slamin",1);
		}
	}
	if(Inventory_HasItem(playerid,"sidekirts transfender"))
	{
		if(pmodelid[playerid] == 534) // Remington
		{
			AddVehicleComponent(car,1122);
			AddVehicleComponent(car,1101);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
		}
	}
	if(Inventory_HasItem(playerid,"sidekirts transfender"))
	{
		if(pmodelid[playerid] == 534) // Remington
		{
			AddVehicleComponent(car,1106);
			AddVehicleComponent(car,1124);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
		}
    }
	if(Inventory_HasItem(playerid,"sidekirts transfender"))
	{
		if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1118);
			AddVehicleComponent(car,1120);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
		}
    }
	if(Inventory_HasItem(playerid,"sidekirts transfender"))
	{

		if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1119);
			AddVehicleComponent(car,1121);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
		}
	}
	if(Inventory_HasItem(playerid,"sidekirts transfender"))
	{
		if(pmodelid[playerid] == 401||pmodelid[playerid] == 518||pmodelid[playerid] == 527||pmodelid[playerid] == 415||pmodelid[playerid] == 589||pmodelid[playerid] == 546||pmodelid[playerid] == 517||pmodelid[playerid] == 603||pmodelid[playerid] == 436||pmodelid[playerid] == 439||pmodelid[playerid] == 580||pmodelid[playerid] == 549||pmodelid[playerid] == 477)
		{
			AddVehicleComponent(car,1007);
			AddVehicleComponent(car,1017);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
		}
	}
	if(Inventory_HasItem(playerid,"sidekirts transfender"))
	{
		if(pmodelid[playerid] == 575) // Brodway
		{
			AddVehicleComponent(car,1042);
			AddVehicleComponent(car,1099);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
		}
	   	else if(pmodelid[playerid] == 567) // Savanna
		{
			AddVehicleComponent(car,1102);
			AddVehicleComponent(car,1133);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
	    	Inventory_Remove(playerid, "sidekirts transfender",1);
		}
		else if(pmodelid[playerid] == 576) // Tornado
		{
			AddVehicleComponent(car,1134);
			AddVehicleComponent(car,1137);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts transfender",1);
	    }
	    else if(pmodelid[playerid] == 536) // Blade
		{
			AddVehicleComponent(car,1108);
			AddVehicleComponent(car,1107);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
	        Inventory_Remove(playerid, "sidekirts transfender",1);

		}
	}
	if(Inventory_HasItem(playerid,"sidekirts wheebtovers"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1039);
			AddVehicleComponent(car,1041);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts wheebtovers",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1048);
			AddVehicleComponent(car,1052);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts wheebtovers",1);
		}
		else if(pmodelid[playerid] == 559) // Jetser
		{
			AddVehicleComponent(car,1070);
			AddVehicleComponent(car,1072);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts wheebtovers",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1057);
			AddVehicleComponent(car,1063);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts wheebtovers",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1031);
			AddVehicleComponent(car,1030);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts wheebtovers",1);
		}
		else if(pmodelid[playerid] == 558)  // Uranus
		{
			AddVehicleComponent(car,1093);
			AddVehicleComponent(car,1095);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts wheebtovers",1);
		}
    }
	if(Inventory_HasItem(playerid,"sidekirts chrome"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1036);
			AddVehicleComponent(car,1040);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts chrome",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1047);
			AddVehicleComponent(car,1051);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts chrome",1);
		}
		else if(pmodelid[playerid] == 559) // Jester
		{
			AddVehicleComponent(car,1069);
			AddVehicleComponent(car,1071);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendClientMessage(playerid,COLOR_WHITE,"[INFO] YComponent successfully added.");
			Inventory_Remove(playerid, "sidekirts chrome",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1056);
			AddVehicleComponent(car,1062);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts chrome",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1026);
			AddVehicleComponent(car,1027);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts chrome",1);
		}
		else if(pmodelid[playerid] == 558) // Uranus
		{
			AddVehicleComponent(car,1090);
			AddVehicleComponent(car,1094);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "sidekirts chrome",1);
		}
	}
	if(Inventory_HasItem(playerid,"rear slamin"))
	{
		if(pmodelid[playerid] == 575) // Brodway
		{
			AddVehicleComponent(car,1177);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear slamin",1);
		}
		else if(pmodelid[playerid] == 534)// Remington
		{
			AddVehicleComponent(car,1178);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear slamin",1);
		}
		else if(pmodelid[playerid] == 567)// Savanna
		{
			AddVehicleComponent(car,1186);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear slamin",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
			AddVehicleComponent(car,1183);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear slamin",1);
		}
		else if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1110);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear slamin",1);
		}
		else if(pmodelid[playerid] == 576) // Tornado
		{
			AddVehicleComponent(car,1193);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear slamin",1);
		}
	}
	if(Inventory_HasItem(playerid,"rear chrome"))
	{
		if(pmodelid[playerid] == 575) // Brodway
		{
			AddVehicleComponent(car,1176);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear chrome",1);
		}
		else if(pmodelid[playerid] == 534)// Remington
		{
			AddVehicleComponent(car,1180);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear chrome",1);
		}
		else if(pmodelid[playerid] == 567)// Savanna
		{
			AddVehicleComponent(car,1187);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear chrome",1);
		}
		else if(pmodelid[playerid] == 536) // Blade
		{
			AddVehicleComponent(car,1184);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear chrome",1);
		}
		else if(pmodelid[playerid] == 535) // Slamvan
		{
			AddVehicleComponent(car,1109);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear chrome",1);
		}
		else if(pmodelid[playerid] == 576) // Tornado
		{
			AddVehicleComponent(car,1192);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear chrome",1);
		}
	}
	if(Inventory_HasItem(playerid,"rear xflow"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
			AddVehicleComponent(car,1148);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendClientMessage(playerid,COLOR_WHITE,"[INFO] YComponent successfully added.");
			Inventory_Remove(playerid, "rear xflow",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1151);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear xflow",1);
		}
		else if(pmodelid[playerid] == 559) // Jetser
		{
			AddVehicleComponent(car,1161);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear xflow",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1156);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear xflow",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1140);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear xflow",1);
		}
		else if(pmodelid[playerid] == 558)  // Uranus
		{
			AddVehicleComponent(car,1167);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear xflow",1);
		}
	}
	if(Inventory_HasItem(playerid,"rear alien"))
	{
		if(pmodelid[playerid] == 562) // Elegy
		{
		    AddVehicleComponent(car,1149);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	        SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
		    Inventory_Remove(playerid, "rear alien",1);
		}
		else if(pmodelid[playerid] == 565) // Flash
		{
			AddVehicleComponent(car,1150);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear alien",1);
		}
		else if(pmodelid[playerid] == 559) // Jester
		{
			AddVehicleComponent(car,1159);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear alien",1);
		}
		else if(pmodelid[playerid] == 561) // Stratum
		{
			AddVehicleComponent(car,1154);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear alien",1);
		}
		else if(pmodelid[playerid] == 560) // Sultan
		{
			AddVehicleComponent(car,1141);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear alien",1);
		}
		else if(pmodelid[playerid] == 558) // Uranus
		{
			AddVehicleComponent(car,1168);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			SendServerMessage(playerid,"Pièce de tuning ajouter au vehicule.");
			Inventory_Remove(playerid, "rear alien",1);
		}
	}
	if(Inventory_HasItem(playerid,"roue offroad"))
	{
		AddVehicleComponent(car,1025);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue ",1);
	}
	if(Inventory_HasItem(playerid,"roue mega"))
	{
		AddVehicleComponent(car,1074);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue mega",1);
	}
	if(Inventory_HasItem(playerid,"roue wires"))
	{
		AddVehicleComponent(car,1076);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue wires",1);
	}
	if(Inventory_HasItem(playerid,"roue twist"))
	{
		AddVehicleComponent(car,1078);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue twist",1);
	}
	if(Inventory_HasItem(playerid,"roue grove"))
	{
		AddVehicleComponent(car,1081);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue grove",1);
	}
	if(Inventory_HasItem(playerid,"roue import"))
	{
		AddVehicleComponent(car,1082);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue import",1);
	}
	if(Inventory_HasItem(playerid,"roue atomic"))
	{
		AddVehicleComponent(car,1085);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue atomic",1);
	}
	if(Inventory_HasItem(playerid,"roue ahab"))
	{
		AddVehicleComponent(car,1096);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue ahab",1);
	}
	if(Inventory_HasItem(playerid,"roue virtual"))
	{
		AddVehicleComponent(car,1097);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue virtual",1);
	}
	if(Inventory_HasItem(playerid,"roue access"))
	{
		AddVehicleComponent(car,1098);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue access",1);
	}
	if(Inventory_HasItem(playerid,"roue trance"))
	{
		AddVehicleComponent(car,1084);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue trance",1);
	}
	if(Inventory_HasItem(playerid,"roue shadow"))
	{
		AddVehicleComponent(car,1073);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue shadow",1);
	}
	if(Inventory_HasItem(playerid,"roue rimshine"))
	{
		AddVehicleComponent(car,1075);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue rimshine",1);
	}
	if(Inventory_HasItem(playerid,"roue classic"))
	{
		AddVehicleComponent(car,1077);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue classic",1);
	}
	if(Inventory_HasItem(playerid,"roue cutter"))
	{
		AddVehicleComponent(car,1079);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue cutter",1);
	}
	if(Inventory_HasItem(playerid,"roue switch"))
	{
		AddVehicleComponent(car,1080);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue switch",1);
	}
	if(Inventory_HasItem(playerid,"roue dollar"))
	{
		AddVehicleComponent(car,1083);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SendServerMessage(playerid,"Pièce de roues ajouter au vehicule.");
		Inventory_Remove(playerid, "roue dollar",1);
	}
	return 1;
}