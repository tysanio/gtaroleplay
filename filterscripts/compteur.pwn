#include <a_samp>
enum td {Text:TDSpeedClock[15]}
new TextDraws[td];
new Text:TextDrawsd[MAX_PLAYERS][4];
public OnFilterScriptInit()
{
	AntiDeAMX();
	TextDraws[TDSpeedClock][0] = TextDrawCreate(496.000000,400.000000,"~g~20");
 	TextDraws[TDSpeedClock][1] = TextDrawCreate(487.000000,388.000000,"~g~40");
 	TextDraws[TDSpeedClock][2] = TextDrawCreate(483.000000,375.000000,"~g~60");
 	TextDraws[TDSpeedClock][3] = TextDrawCreate(488.000000,362.000000,"~g~80");
 	TextDraws[TDSpeedClock][4] = TextDrawCreate(491.000000,349.000000,"~g~100");
 	TextDraws[TDSpeedClock][5] = TextDrawCreate(508.000000,336.500000,"~g~120");
 	TextDraws[TDSpeedClock][6] = TextDrawCreate(536.000000,332.000000,"~g~140");
 	TextDraws[TDSpeedClock][7] = TextDrawCreate(567.000000,337.000000,"~g~160");
 	TextDraws[TDSpeedClock][8] = TextDrawCreate(584.000000,348.000000,"~g~180");
 	TextDraws[TDSpeedClock][9] = TextDrawCreate(595.000000,360.000000,"~g~200");
 	TextDraws[TDSpeedClock][10] = TextDrawCreate(603.000000,374.000000,"~g~220");
 	TextDraws[TDSpeedClock][11] = TextDrawCreate(594.000000,386.000000,"~g~240");
 	TextDraws[TDSpeedClock][14] = TextDrawCreate(585.000000,399.000000,"~g~260");
 	TextDraws[TDSpeedClock][12] = TextDrawCreate(534.000000,396.000000,"~g~/ \\");
 	TextDrawLetterSize(TextDraws[TDSpeedClock][12], 1.059999, 2.100000);
 	TextDraws[TDSpeedClock][13] = TextDrawCreate(548.000000,401.000000,"~w~.");
	TextDrawLetterSize(TextDraws[TDSpeedClock][13], 0.73, -2.60);
	TextDrawSetOutline(TextDraws[TDSpeedClock][13], 0);
	TextDrawSetShadow(TextDraws[TDSpeedClock][13], 1);
 	TextDrawSetShadow(TextDraws[TDSpeedClock][14], 0);
	TextDrawSetOutline(TextDraws[TDSpeedClock][0], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][1], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][2], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][3], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][4], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][5], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][6], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][7], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][8], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][9], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][10], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][11], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][12], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][13], 1);
	TextDrawSetOutline(TextDraws[TDSpeedClock][14], 1);
 	for(new i; i < 13; i++)
 		TextDrawSetShadow(TextDraws[TDSpeedClock][i], 0);
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		for(new i; i < 15; i++)
			TextDrawShowForPlayer(playerid, TextDraws[TDSpeedClock][i]);
		for(new i; i < 4; i++)
	  		TextDrawsd[playerid][i] = TextDrawCreate(555.0, 402.0, "~b~.");
	}
	else
	{
		for(new i; i < 4; i++)
		    TextDrawHideForPlayer(playerid, TextDrawsd[playerid][i]);
		for(new i; i < 15; i++)
			TextDrawHideForPlayer(playerid, TextDraws[TDSpeedClock][i]);
	}
	return 1;
}
public OnPlayerUpdate(playerid)
{
	new Float:fPos[3], Float:Pos[4][2], Float:fSpeed;
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid), fPos[0], fPos[1], fPos[2]);
		fSpeed = floatsqroot(floatpower(fPos[0], 2) + floatpower(fPos[1], 2) + floatpower(fPos[2], 2)) * 180;
		new Float:alpha = 320 - fSpeed;
		for(new i; i < 4; i++)
		{
		    TextDrawHideForPlayer(playerid, TextDrawsd[playerid][i]);
		    TextDrawDestroy(TextDrawsd[playerid][i]);
	  		GetDotXY(548, 401, Pos[i][0], Pos[i][1], alpha, (i + 1) * 8);
	  		TextDrawsd[playerid][i] = TextDrawCreate(Pos[i][0], Pos[i][1], "~b~.");
  			TextDrawLetterSize(TextDrawsd[playerid][i], 0.73, -2.60);
  			TextDrawBackgroundColor(TextDrawsd[playerid][i], 255);
			TextDrawSetOutline(TextDrawsd[playerid][i], 1);
			TextDrawSetShadow(TextDrawsd[playerid][i], 1);
			TextDrawShowForPlayer(playerid, TextDrawsd[playerid][i]);
		}
	}
	return 1;
}
stock GetDotXY(Float:StartPosX, Float:StartPosY, &Float:NewX, &Float:NewY, Float:alpha, Float:dist)
{
	 NewX = StartPosX + (dist * floatsin(alpha, degrees));
	 NewY = StartPosY + (dist * floatcos(alpha, degrees));
}
AntiDeAMX() // Add By Jeff
{
	new a[][] =
	{"Unarmed (Fist)","Brass K"};
	#pragma unused a
}
