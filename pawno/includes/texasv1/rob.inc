/* RNS V2.1 created by Kreison */
// Defines
#define MAX_ROBNPCS 50 // Max rob NPC number
#define ALARM_STOP 120 // Time to stop alarm (in secs) ~ TO TYPES 2 AND 3
#define ROB_INTERVAL 3600 // Time interval to rob again after sucess (in secs)
#define FAILROB_INTERVAL 1800 // Time interval to rob again after failure (in secs)
#define NPC_PREFIX "Caissier" // NPC name prefix
#define NPC_SUFFIX "Vendeur" // NPC name suffix
// Variables
enum e_RobNPCInfo
{
	rnIsCon,
	rnMax,
	rnMin,
	rnInt,
	rnWorld,
	rnAlarm,
	Float: rnAng,
	rnPlayer,
	rnPay,
	rnDelay
}
new RobNPC[MAX_ROBNPCS][e_RobNPCInfo];
new RobNPCS_totaln;
new IsAlarmOn[MAX_PLAYERS];
// -- timers
new timer_aimcheck[MAX_ROBNPCS];
new timer_roubo[MAX_ROBNPCS];
new timer_int[MAX_PLAYERS];
// Stocks
stock IsRobNPC(playerid)
{
	if (IsPlayerNPC(playerid)) {
	    new i;
	    for(i = 1; i <= MAX_ROBNPCS; i++)
	    {
			if (RobNPC[i][rnIsCon] == playerid) { return i; }
		}
	}
	return 0;
}
stock rnRandom(min, max)
{
    //Credits to y_less
    new rand = random(max-min)+min;
    return rand;
}
stock rnIsPlayerInRangeOfPoint(playerid, Float:range, Float:x, Float:y, Float:z, worldid)
{
	if (IsPlayerInRangeOfPoint(playerid, range, x, y, z) && GetPlayerVirtualWorld(playerid) == worldid)
	{
	    return 1;
	}
	return 0;
}
stock AddRobNPC(skin, Float:x, Float:y, Float:z, Float:ang, worldid, interiorid, alarmtype = 0, pay = 1, min = 1000, max = 2000)
{
    if (RobNPCS_totaln >= MAX_ROBNPCS) {
		print("[Robbery NPCs system] ERROR: The actual rob npc numbers exceed the MAX_ROBNPCS number.");
		return 0;
	}
	// Timer to avoid bugs with npc id
	SetTimerEx("AddRobNPC2", 500, false, "iffffiiiiii", skin, Float:x, Float:y, Float:z, Float:ang, worldid, interiorid, alarmtype, pay, min, max);

	return 1;
}

stock PreloadRAnims(playerid)
{
	ApplyAnimation(playerid,"SHOP","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"PED","null",0.0,0,0,0,0,0);
}

stock PlayAlarm(npcid)
{
	new Float: x, Float: y, Float: z;
	MoveRNPC (npcid, x, y, z,0.0);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if (rnIsPlayerInRangeOfPoint(i, 50.0, x, y, z, GetPlayerVirtualWorld(npcid)))
		{
		    new ALARM_TYPE = RobNPC[IsRobNPC(npcid)][rnAlarm];
		    if (ALARM_TYPE == 0)
		    {
		        IsAlarmOn[i] = npcid;
				PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0);
		        timer_int[i] = SetTimerEx("IntCheck", 500, true, "ii", i, npcid);
    		} else if (ALARM_TYPE == 1) {
    		    IsAlarmOn[i] = npcid;
				PlayerPlaySound(i, 3401, x, y, z);
		        timer_int[i] = SetTimerEx("IntCheck", 500, true, "ii", i, npcid);
			} else if (ALARM_TYPE == 2) {
			    IsAlarmOn[i] = npcid;
		        PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0);
		        SetTimerEx("StopAlarm", ALARM_STOP*1000, false, "i", i);
			} else if (ALARM_TYPE == 3) {
			    IsAlarmOn[i] = npcid;
		        PlayerPlaySound(i, 3401, x, y, z);
		        SetTimerEx("StopAlarm", ALARM_STOP*1000, false, "i", i);
		    } else if (ALARM_TYPE == 4) {
		        IsAlarmOn[i] = npcid;
		        PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0);
		    } else if (ALARM_TYPE == 5) {
		        IsAlarmOn[i] = npcid;
		        PlayerPlaySound(i, 3401, x, y, z);
		    }
		}
	}
}

// Publics
forward StartRobNPCs();
public StartRobNPCs()
{
	new i;
	for(i = 1; i <= MAX_ROBNPCS; i++)
	{
		RobNPC[i][rnIsCon] = INVALID_PLAYER_ID;
	}
}

forward AddRobNPC2(skin, Float:x, Float:y, Float:z, Float:ang, worldid, interiorid, alarmtype, pay, min, max);
public AddRobNPC2(skin, Float:x, Float:y, Float:z, Float:ang, worldid, interiorid, alarmtype, pay, min, max)
{
	RobNPCS_totaln++;

	new npcname[24];
	format(npcname, sizeof(npcname), "%s%i_%s", NPC_PREFIX, RobNPCS_totaln, NPC_SUFFIX);
	new npcid = ConnectRNPC(npcname);

	RobNPC[RobNPCS_totaln][rnIsCon] = npcid;
	
	if (pay)
	{
	    RobNPC[RobNPCS_totaln][rnPay] = 1;
		RobNPC[RobNPCS_totaln][rnMax] = max;
		RobNPC[RobNPCS_totaln][rnMin] = min;
	} else {
	    RobNPC[RobNPCS_totaln][rnPay] = 0;
	}
	
	RobNPC[RobNPCS_totaln][rnInt] = interiorid;
	RobNPC[RobNPCS_totaln][rnWorld] = worldid;
 	
 	RobNPC[RobNPCS_totaln][rnAng] = ang;
 	RobNPC[RobNPCS_totaln][rnAlarm] = alarmtype;
	SetPlayerSkin(npcid, skin);
 	MoveRNPC(npcid, x, y, z, 0.0);
}
forward RobP1(npcid,playerid);
public RobP1(npcid,playerid)
{
	foreach (new i : Player)
	{
		new bizid = Business_Inside(playerid);
		if (GetFactionType(i) == FACTION_POLICE) {Waypoint_Set(i, "Vol en cours!", BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2]);}
	}
	new bizid = Business_Inside(playerid);
	SendFactionMessageEx(FACTION_POLICE, COLOR_RADIO, "RADIO: Un vol de magasin au %s (marquée sur la carte).", BusinessData[bizid][bizName]);
    ClearAnimations(npcid);
    timer_roubo[IsRobNPC(npcid)] = SetTimerEx("RobP2", 100, false, "i", npcid);
}

forward RobP2(npcid);
public RobP2(npcid)
{
    ClearAnimations(npcid);
 	ApplyAnimation(npcid,"SHOP","SHP_Rob_GiveCash",4.1,0,1,1,1,0,1);
    timer_roubo[IsRobNPC(npcid)] = SetTimerEx("RobP3", 3900, false, "i", npcid);
}

forward RobP3(npcid);
public RobP3(npcid)
{
	new npcnum = IsRobNPC(npcid);
    KillTimer(timer_aimcheck[npcnum]);
    
    ClearAnimations(npcid);
    ApplyAnimation(npcid,"PED","DUCK_cower",4.1,1,1,1,1,1,1);
    
	PlayAlarm(npcid);
    static bizid = -1;	
	new moneyganho;
	new playerid = RobNPC[npcnum][rnPlayer];
	if ((bizid = Business_Inside(playerid)) != -1)
	{
		if (RobNPC[npcnum][rnPay])
		{
			moneyganho = BusinessData[bizid][bizVault];
            BusinessData[bizid][bizVault] -= moneyganho;
            Business_Save(bizid);			
			new rnMsg[35];
			format(rnMsg, sizeof(rnMsg), "~g~Vous aver voler~n~$%i", moneyganho);
			GiveMoney(playerid, moneyganho);
			GameTextForPlayer(playerid, rnMsg, 2000, 0);
		} else {
			moneyganho = 0;
		}
	}
	
	CallLocalFunction("OnPlayerSucessRob", "iii", playerid, npcid, moneyganho);
	
	SetTimerEx("RobDelay", ROB_INTERVAL*1000, false, "i", npcid);
}


forward AimCheck(playerid, npcid);
public AimCheck(playerid, npcid)
{
	new targetplayer = GetPlayerTargetPlayer(playerid);
	if (targetplayer != npcid)
	{
	    new npcnum = IsRobNPC(npcid);
	    
		ClearAnimations(npcid);
		
		KillTimer(timer_roubo[npcnum]);
		KillTimer(timer_aimcheck[npcnum]);
		
		PlayAlarm(npcid);

        SetTimerEx("RobDelay", FAILROB_INTERVAL*1000, false, "i", npcid);
		SetTimerEx("AimCheck2", 100, false, "i", npcid);
		
		CallLocalFunction("OnPlayerFailRob", "ii", playerid, npcid);
	}
}


forward AimCheck2(npcid);
public AimCheck2(npcid)
{
    ApplyAnimation(npcid,"PED","DUCK_cower",4.1,1,1,1,1,1,1);
    PlayAlarm(npcid);
}


forward RobDelay(npcid);
public RobDelay(npcid)
{
    RobNPC[IsRobNPC(npcid)][rnDelay] = 0;
    ClearAnimations(npcid);
    
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsAlarmOn[i] == npcid)
	    {
	        StopAlarm(i);
	    }
	}
}


forward IntCheck(playerid, npcid);
public IntCheck(playerid, npcid)
{
	if(GetPlayerInterior(playerid) != RobNPC[IsRobNPC(npcid)][rnInt])
	{
	    StopAlarm(playerid);
	    KillTimer(timer_int[playerid]);
	}
}


forward StopAlarm(playerid);
public StopAlarm(playerid)
{
    IsAlarmOn[playerid] = 0;
    PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
}



// Callbacks SA-MP
public OnPlayerConnect(playerid)
{
    #if defined RN_OnPlayerConnect
        RN_OnPlayerConnect(playerid);
    #endif

	if (!IsPlayerNPC(playerid)) { PreloadRAnims(playerid); }
	if (IsPlayerNPC(playerid))
	{
		// When NPC spawn, paramaters will be seted
		new npcnum = IsRobNPC(playerid);
		if(npcnum)
		{
			SetPlayerInterior(playerid, RobNPC[npcnum][rnInt]);
			SetPlayerFacingAngle(playerid, RobNPC[npcnum][rnAng]);
			SetPlayerVirtualWorld(playerid, RobNPC[npcnum][rnWorld]);
			SetRNPCHealth(playerid, 200);
			PreloadRAnims(playerid);
		}	
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    #if defined RN_OnPlayerDisconnect
        RN_OnPlayerDisconnect(playerid, reason);
    #endif
    
    if (!IsPlayerNPC(playerid)) { KillTimer(timer_int[playerid]); }
    return 1;
}


public OnPlayerUpdate(playerid)
{
    #if defined RN_OnPlayerUpdate
        RN_OnPlayerUpdate(playerid);
    #endif
    
    new targetplayer = GetPlayerTargetPlayer(playerid),npcnum = IsRobNPC(targetplayer),serveursettinginfoid;
    if(npcnum && !RobNPC[npcnum][rnDelay] && GetPlayerWeapon(playerid) >= 22 && GetPlayerWeapon(playerid) <= 38)
    {
		if(IsACop(playerid)) {ShowPlayerFooter(playerid, "Vous ne pouvez pas braquer."); return 1;}
		if(info_serveursettinginfo[serveursettinginfoid][settingbraquagenpcactive] == 1) {ShowPlayerFooter(playerid, "Les braquages sont desactiver");return 1;}
		if(cop_nbrCops < COP_MIN_COPS_BRAQUAGE) {ShowPlayerFooter(playerid, " Il n'a pas assez de ~r~police~w~ en ville"); return 1;}
		ClearAnimations(targetplayer);
		ApplyAnimation(targetplayer,"SHOP","SHP_Rob_HandsUp",4.1,0,1,1,1,0,1);
		
		RobNPC[npcnum][rnDelay] = 1;
		RobNPC[npcnum][rnPlayer] = playerid;
		
		timer_roubo[npcnum] = SetTimerEx("RobP1", 2000, false, "i", targetplayer);
		timer_aimcheck[npcnum] = SetTimerEx("AimCheck", 500, true, "ii", playerid, targetplayer);
    }
    
    return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    #if defined RN_OnPlayerDeath
        RN_OnPlayerDeath(playerid, killerid, reason);
    #endif

    if (IsAlarmOn[playerid]) { StopAlarm(playerid); }

    return 1;
}
public OnGameModeInit()
{
	#if defined RN_OnGameModeInit
        RN_OnGameModeInit();
    #endif

	StartRobNPCs();
}
// Hooks
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate RN_OnPlayerUpdate
#if defined RN_OnPlayerUpdate
    forward RN_OnPlayerUpdate(playerid);
#endif
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect RN_OnPlayerConnect
#if defined RN_OnPlayerConnect
    forward RN_OnPlayerConnect(playerid);
#endif
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect RN_OnPlayerDisconnect
#if defined RN_OnPlayerDisconnect
    forward RN_OnPlayerDisconnect(playerid, reason);
#endif

#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath RN_OnPlayerDeath
#if defined RN_OnPlayerDeath
    forward RN_OnPlayerDeath(playerid, killerid, reason);
#endif
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit RN_OnGameModeInit
#if defined RN_OnGameModeInit
    forward RN_OnGameModeInit();
#endif
// Callbacks of include
forward OnPlayerSucessRob(playerid, npcid, value);
forward OnPlayerFailRob(playerid, npcid);
