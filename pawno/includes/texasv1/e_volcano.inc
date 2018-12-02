/*
    Name:                                                              e_volcano
    Description:                                           Simple volcano system
    Author:                                                               ea8de1
    Version:                                                                v1.0
    Created:                                                          03.08.2014
    Updated:                                                          03.08.2014

    Functions:
     - CreateVolcano
     - DestroyVolcano
     - IsValidVolcano

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#if defined _e_volcano_included
#endinput
#endif
#define _e_volcano_included


// ---------- Settings ----------
#define E_VOLCANO_MAX     4 // Maximum number of volcanoes
#define E_VOLCANO_TIME    1000 // Time of update volcanoes timer in milliseconds
#define E_VOLCANO_CO_FUNC CreateDynamicObject // Create object function
#define E_VOLCANO_DO_FUNC DestroyDynamicObject // Destroy object function
// ------------------------------

#define E_VOLCANO_POS_X(%0) (%0 - 3.0)
#define E_VOLCANO_POS_Y(%0) (%0 + 1.0)
#define E_VOLCANO_POS_Z(%0) (%0 + 23.0)
#define E_VOLCANO_POS_H(%0) (%0 + 25.5)

forward OnVolcanoUpdate();

enum e_volcano_Info
{
	v_objectid,
	Float:v_pos_x,
	Float:v_pos_y,
	Float:v_pos_z,
	bool:v_used,
};

new Float:e_volcano_Data[E_VOLCANO_MAX][e_volcano_Info];

stock CreateVolcano(Float:pos_x,Float:pos_y,Float:pos_z)
{
	new volcanoid = -1;
	for(new i; i < E_VOLCANO_MAX; i++)
	{
		if(!IsValidVolcano(i))
		{
			volcanoid = i;
			break;
		}
	}
	if(volcanoid == -1) return print("Pas assez de slots pour volcan (utils/e_volcano)");
	e_volcano_Data[volcanoid][v_used] = true;
	e_volcano_Data[volcanoid][v_pos_x] = pos_x;
	e_volcano_Data[volcanoid][v_pos_y] = pos_y;
	e_volcano_Data[volcanoid][v_pos_z] = pos_z;
	e_volcano_Data[volcanoid][v_objectid] = E_VOLCANO_CO_FUNC(18752,pos_x,pos_y,pos_z,0.0,0.0,180.0);
	return volcanoid;
}

stock DestroyVolcano(volcanoid)
{
	if(!IsValidVolcano(volcanoid)) return false;
	e_volcano_Data[volcanoid][v_used] = false;
	e_volcano_Data[volcanoid][v_pos_x] = 0.0;
	e_volcano_Data[volcanoid][v_pos_y] = 0.0;
	e_volcano_Data[volcanoid][v_pos_z] = 0.0;
	E_VOLCANO_DO_FUNC(e_volcano_Data[volcanoid][v_objectid]);
	e_volcano_Data[volcanoid][v_objectid] = 0;
	return true;
}

stock IsValidVolcano(volcanoid)
{
	return e_volcano_Data[volcanoid][v_used];
}

public OnVolcanoUpdate()
{
	new Float:pos;
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
		GetPlayerPos(playerid,pos,pos,pos);
		for(new i; i < E_VOLCANO_MAX; i++)
		{
			if(IsValidVolcano(i) && IsPlayerInRangeOfPoint(playerid,10.0,E_VOLCANO_POS_X(e_volcano_Data[i][v_pos_x]),E_VOLCANO_POS_Y(e_volcano_Data[i][v_pos_y]),E_VOLCANO_POS_Z(e_volcano_Data[i][v_pos_z])) && pos <= E_VOLCANO_POS_H(e_volcano_Data[i][v_pos_z]) && GetPlayerState(i) == PLAYER_STATE_ONFOOT) SetPlayerHealth(playerid,0.0);
		}
	}
	return true;
}

/*public OnGameModeInit()
{
	SetTimer("OnVolcanoUpdate",E_VOLCANO_TIME,true);

    #if defined e_volcano_OnGameModeInit
        return e_volcano_OnGameModeInit();
    #else
        return 1;
    #endif
	return 0;
}
#if defined e_volcano_OnGameModeInit
    forward e_volcano_OnGameModeInit();
#endif
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit e_volcano_OnGameModeInit*/