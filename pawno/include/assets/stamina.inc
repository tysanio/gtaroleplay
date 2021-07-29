//Made by lokii.

#include <YSI\y_hooks> 

/*
native Natives();
native
native SetPlayerStamina(playerid, Float:stamina);
native SetPlayerStaminaSubVal(playerid, Float:sub_val);
native GetPlayerStamina(playerid, &Float:stamina);
native GetPlayerStaminaSubVal(playerid);
native
native Callbacks();
native
native OnPlayerOutOfStamina(playerid);
*/


#if !defined STAMINA_UPDATE_TIME
	#define STAMINA_UPDATE_TIME (2000)
#endif

static es_timer;

static Float:g_SubStamina[MAX_PLAYERS] = {5.0,...};
static Float:g_PlayerStamina[MAX_PLAYERS] = {100.0,...};

Float:fclamp(Float:value, Float:min, Float:max)
{
	if(value < min || value > max)
	{
	    if(value < min) return min;
	    if(value > max) return max;
	}
	return value;
}

hook OnPlayerConnect(playerid)
{
    if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) return 1;
    SetPlayerStaminaSubVal(playerid, 5.0);
	return 1;
}

Float:GetSpeed(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerVelocity(playerid, x, y, z);
	return floatabs(floatsqroot(floatpower(x, 2) + floatpower(y, 2)))*181.5;
}

stock SetPlayerStaminaSubVal(playerid, Float:sub_val)
{
    if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) return 0;
    g_SubStamina[playerid] = fclamp(sub_val, 0.0, 100.0);
	return 1;
}

stock Float:GetPlayerStaminaSubVal(playerid)
{
    if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) return 0.0;
	return g_SubStamina[playerid];
}

SetPlayerStamina(playerid, Float:stamina)
{
	if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) return 0;
    g_PlayerStamina[playerid] = fclamp(stamina, 0.0, 100.0);
	return 1;
}

script es_StaminaUpdate()
{
	new animlib[32], animname[32];
	foreach(new i : Player)
	{
        GetAnimationName(GetPlayerAnimationIndex(i), animlib, 32, animname, 32);
        if(strcmp("SWIM_CRAWL", animname, true) == 0 || strcmp("SWIM_UNDER", animname, true) == 0) continue;
	    if(GetSpeed(i) > 18.0)
	    {
		    if(g_PlayerStamina[i] > 0.0)
		    {
				SetPlayerStamina(i, g_PlayerStamina[i]-g_SubStamina[i]);
			}
			else
			{
				OnPlayerOutOfStamina(i);
			}
		}
		else
		{
		    if(g_PlayerStamina[i] < 100.0)
		    {
		    	SetPlayerStamina(i, g_PlayerStamina[i]+g_SubStamina[i]);
			}
		}
	}
	return 1;
}

stock GetPlayerStamina(playerid, &Float:stamina)
{
    if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) return 0;
    stamina = g_PlayerStamina[playerid];
	return 1;
}
hook OnGameModeInit()
{
	es_timer = SetTimer("es_StaminaUpdate", STAMINA_UPDATE_TIME, true);
	return 1;
}

hook OnGameModeExit()
{
	KillTimer(es_timer);
	return 1;
}