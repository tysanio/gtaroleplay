#define OBJ_SLOT_2POOL (9)
CMD:pool2(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTRED,"[ERREUR]:{FFFFFF} Probleme de billard pour l'instant en cours de réglage.");
	/*if(GetPlayerWeapon(playerid) != 7)
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED,"[ERREUR]:{FFFFFF} Vous n'avez pas de queue de billard");
	    return 1;
	}
	if(!PlayingPool2[playerid])
	{
	    PlayingPool2[playerid] = 1;
		PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
        GivePlayerWeapon(playerid, 7, 1);
		Pool2Score[playerid] = 0;
        if(!Pool2Started)
        {
			Pool2Started = 1;
			RespawnPool2Balls(1);
        }
	}
	else
	{
	    if(Pool2Aimer != playerid)
	    {
		    PlayingPool2[playerid] = 0;
		    new
		        count = GetPool2PlayersCount();
		    if(count <= 0)
		    {
		    	Pool2Started = 0;
		    	RespawnPool2Balls();
		    }
	    }
	}*/
	return 1;
}
GetBallModel2(i)
{
	switch(i)
	{
		case 0: return 3003;
		case 1: return 3002;
		case 2: return 3001;
		case 3: return 2995;
		case 4: return 2996;
		case 5: return 3106;
		case 6: return 3105;
		case 7: return 3103;
		case 8: return 3001;
		case 9: return 3100;
		case 10: return 2997;
		case 11: return 3000;
		case 12: return 3102;
		case 13: return 2999;
		case 14: return 2998;
		case 15: return 3104;
	}
	return 0;
}
stock GetPool2BallsCount()
{
	new count;
	for(new i; i < 16; i++)
	{
		if(Pool2Ball[i][bExisting] || i == 0) count++;
	}
	return count;
}
stock GetMaxPool2Score()
{
	new scoremax = -1;
	foreach (new i : Player)
	{
		if(PlayingPool2[i])
		{
			if(Pool2Score[i] > scoremax)
			{
				scoremax = Pool2Score[i];
			}
		}
	}
	return scoremax;
}
stock SendPool2PlayersMessage(string[])
{
    foreach (new i : Player)
	{
		if(PlayingPool2[i])
		{
			SendClientMessage(i, -1, string);
		}
	}
}
stock AreAllBallsStopped2()
{
	new Float:x, Float:y, Float:z;
	for(new i; i < 16; i++)
	{
		if(Pool2Ball[i][bExisting])
		{
			PHY_GetObjectVelocity(Pool2Ball[i][bObject], x, y, z);
			if(x != 0.0 || y != 0.0)
			    return 0;
		}
	}
	return 1;
}
stock RespawnPool2Balls(init = 0)
{
    for(new i; i < 16; i++)
	{
        DestroyObject(Pool2Ball[i][bObject]);
		if(Pool2Ball[i][bExisting])
		{
        	PHY_DeleteObject(Pool2Ball[i][bObject]);
        	Pool2Ball[i][bExisting] = 0;
		}
    }
    if(Pool2Aimer != -1)
    {
        TogglePlayerControllable(Pool2Aimer, 1);
        ClearAnimations(Pool2Aimer);
		ApplyAnimation(Pool2Aimer, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0);
        SetCameraBehindPlayer(Pool2Aimer);
        Pool2Aimer = -1;
        DestroyObject(AimObject2);
        TextDrawHideForPlayer(Pool2Aimer, Pool2TD[0]);
        TextDrawHideForPlayer(Pool2Aimer, Pool2TD[1]);
        TextDrawHideForPlayer(Pool2Aimer, Pool2TD[2]);
        TextDrawHideForPlayer(Pool2Aimer, Pool2TD[3]);
    }
    CreateBalls2();
    if(init)
    {
	    for(new i; i < sizeof Pool2Ball; i++)
		    InitBall2(i);
	}
}
stock CreateBalls2()
{
	Pool2Ball[0][bObject] = CreateObject(3003, 506.50620, -84.40770, 998.86792, 0.0, 0.0, 0.0);
	Pool2Ball[1][bObject] = CreateObject(3002, 506.50620, -85.16640, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[2][bObject] = CreateObject(3101, 506.54669, -85.23260, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[3][bObject] = CreateObject(2995, 506.47571, -85.23220, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[4][bObject] = CreateObject(2996, 506.57599, -85.29530, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[5][bObject] = CreateObject(3106, 506.50620, -85.29730, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[6][bObject] = CreateObject(3105, 506.43671, -85.29920, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[7][bObject] = CreateObject(3103, 506.62311, -85.36230, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[8][bObject] = CreateObject(3001, 506.54831, -85.36600, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[9][bObject] = CreateObject(3100, 506.47461, -85.36520, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[10][bObject] = CreateObject(2997, 506.40051, -85.36360, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[11][bObject] = CreateObject(3000, 506.65921, -85.43110, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[12][bObject] = CreateObject(3102, 506.58401, -85.43050, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[13][bObject] = CreateObject(2999, 506.50620, -85.43200, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[14][bObject] = CreateObject(2998, 506.43570, -85.43260, 998.86749, 0.0, 0.0, 0.0);
	Pool2Ball[15][bObject] = CreateObject(3104, 506.36200, -85.42740, 998.86749, 0.0, 0.0, 0.0);
}
stock InitBall2(i)
{
    PHY_InitObject(Pool2Ball[i][bObject], 3003, _, _, PHY_MODE_2D);
    PHY_SetObjectFriction(Pool2Ball[i][bObject], 0.40);
    PHY_RollObject(Pool2Ball[i][bObject]);
    PHY_SetObjectWorld(Pool2Ball[i][bObject], 3);
    Pool2Ball[i][bExisting] = 1;
}
stock LoadPool2()
{
    CreateBalls2();
    SetTimer("Pool2Timer", 21, 1);
    PHY_SetWallWorld(PHY_CreateWall(505.9870 - 0.038, -85.780 - 0.038, 506.9870 + 0.038, -85.780 - 0.038), 3);
	PHY_SetWallWorld(PHY_CreateWall(506.9870 + 0.038, -85.780 - 0.038, 506.9870 + 0.038, -83.907 + 0.038), 3);
	PHY_SetWallWorld(PHY_CreateWall(506.9870 + 0.038, -83.907 + 0.038, 505.9870 - 0.038, -83.907 + 0.038), 3);
	PHY_SetWallWorld(PHY_CreateWall(505.9870 - 0.038, -83.907 + 0.038, 505.9870 - 0.038, -85.780 - 0.038), 3);

    Pool2TD[0] = TextDrawCreate(505.000000, 260.000000, "~n~~n~");
	TextDrawBackgroundColor(Pool2TD[0], 255);
	TextDrawFont(Pool2TD[0], 1);
	TextDrawLetterSize(Pool2TD[0], 0.500000, 0.439999);
	TextDrawColor(Pool2TD[0], -1);
	TextDrawSetOutline(Pool2TD[0], 0);
	TextDrawSetProportional(Pool2TD[0], 1);
	TextDrawSetShadow(Pool2TD[0], 1);
	TextDrawUseBox(Pool2TD[0], 1);
	TextDrawBoxColor(Pool2TD[0], 255);
	TextDrawTextSize(Pool2TD[0], 569.000000, -10.000000);

	Pool2TD[1] = TextDrawCreate(506.000000, 261.000000, "~n~~n~");
	TextDrawBackgroundColor(Pool2TD[1], 255);
	TextDrawFont(Pool2TD[1], 1);
	TextDrawLetterSize(Pool2TD[1], 0.500000, 0.300000);
	TextDrawColor(Pool2TD[1], -1);
	TextDrawSetOutline(Pool2TD[1], 0);
	TextDrawSetProportional(Pool2TD[1], 1);
	TextDrawSetShadow(Pool2TD[1], 1);
	TextDrawUseBox(Pool2TD[1], 1);
	TextDrawBoxColor(Pool2TD[1], 911303167);
	TextDrawTextSize(Pool2TD[1], 568.000000, 0.000000);

	Pool2TD[2] = TextDrawCreate(506.000000, 261.000000, "~n~~n~");
	TextDrawBackgroundColor(Pool2TD[2], 255);
	TextDrawFont(Pool2TD[2], 1);
	TextDrawLetterSize(Pool2TD[2], 0.500000, 0.300000);
	TextDrawColor(Pool2TD[2], -1);
	TextDrawSetOutline(Pool2TD[2], 0);
	TextDrawSetProportional(Pool2TD[2], 1);
	TextDrawSetShadow(Pool2TD[2], 1);
	TextDrawUseBox(Pool2TD[2], 1);
	TextDrawBoxColor(Pool2TD[2], -1949699841);
	TextDrawTextSize(Pool2TD[2], 501.000000, 0.000000);

	Pool2TD[3] = TextDrawCreate(503.000000, 240.000000, "Power");
	TextDrawBackgroundColor(Pool2TD[3], 255);
	TextDrawFont(Pool2TD[3], 2);
	TextDrawLetterSize(Pool2TD[3], 0.280000, 1.699999);
	TextDrawColor(Pool2TD[3], -1);
	TextDrawSetOutline(Pool2TD[3], 1);
	TextDrawSetProportional(Pool2TD[3], 1);
}
stock GetPool2PlayersCount()
{
	new count;
	if(Pool2Started)
	{
		foreach (new i : Player)
		{
			if(PlayingPool2[i])
			{
				count++;
			}
		}
	}
	return count;
}
script Pool2Timer()
{
	if(!Pool2Started) return 0;
    if(Pool2Aimer != -1)
	{
	    new playerid = Pool2Aimer,keys,ud,lr;
		GetPlayerKeys(playerid, keys, ud, lr);
	    if(!(keys & KEY_FIRE))
	    {
			if(lr)
			{
	            new Float:X,Float:Y,Float:Z,Float:Xa,Float:Ya,Float:Za,Float:x,Float:y,Float:newrot,Float:dist;
	            GetPlayerPos(playerid, X, Y ,Z);
	            GetObjectPos(Pool2Ball[0][bObject], Xa, Ya, Za);
	            newrot = AimAngle2[playerid][0] + (lr > 0 ? 0.9 : -0.9);
	            dist = GetPointDistanceToPoint(X, Y, Xa, Ya);
	            if(AngleInRangeOfAngle(AimAngle2[playerid][1], newrot, 30.0))
	            {
	                AimAngle2[playerid][0] = newrot;
	                switch(Pool2Camera[playerid])
					{
						case 0:
						{
	                        GetXYBehindObjectInAngle(Pool2Ball[0][bObject], newrot, x, y, 0.675);
	                        SetPlayerCameraPos(playerid, x, y, 998.86785888672+0.28);
	                        SetPlayerCameraLookAt(playerid, Xa, Ya, Za+0.170);
						}
	                    case 1:
						{
						    SetPlayerCameraPos(playerid, 507.84469604492, -84.831642150879, 1001.4904174805);
						    SetPlayerCameraLookAt(playerid,506.11267089844, -84.831642150879, 998.86785888672);
						}
	                    case 2:
						{
						    SetPlayerCameraPos(playerid, 504.7971496582, -84.831642150879, 1001.4904174805);
						    SetPlayerCameraLookAt(playerid,506.11267089844, -84.831642150879, 998.86785888672);
						}
					}
	                GetXYInFrontOfPos(Xa, Ya, newrot+180, x, y, 0.085);
	                SetObjectPos(AimObject2, x, y, Za);
	              	SetObjectRot(AimObject2, 7.0, 0, AimAngle2[playerid][0]+180);
	              	GetXYInFrontOfPos(Xa, Ya, newrot+180, X, Y, dist);
	                SetPlayerPos(playerid, X, Y, Z);
	                SetPlayerFacingAngle(playerid, newrot);
	            }
			}
		}
		else
		{
		    if(Pool2Dir)
		        Pool2Power -= 2.0;
			else
			    Pool2Power += 2.0;
			if(Pool2Power <= 0)
			{
			    Pool2Dir = 0;
			    Pool2Power = 2.0;
			}
			else if(Pool2Power > 100.0)
			{
			    Pool2Dir = 1;
			    Pool2Power = 98.0;
			}
			TextDrawTextSize(Pool2TD[2], 501.0 + ((67.0 * Pool2Power)/100.0), 0.0);
			TextDrawShowForPlayer(playerid, Pool2TD[2]);
		}
	}
	if(Pool2LastShooter != -1 && AreAllBallsStopped2())
	{
    	SetTimerEx("RestoreCamera", 800, 0, "d", Pool2LastShooter);
    	Pool2LastShooter = -1;
	}
    return 1;
}
stock IsBallInHole2(i)
{
    if(IsObjectInSphere(Pool2Ball[i][bObject],506.0000,-85.79737091,998.86785889,0.0825)) return 1;
	else if(IsObjectInSphere(Pool2Ball[i][bObject],507.0000,-84.84423065,998.86785889,0.0825)) return 2;
	else if(IsObjectInSphere(Pool2Ball[i][bObject],507.0000,-83.88769531,998.86785889,0.0825)) return 3;
    else if(IsObjectInSphere(Pool2Ball[i][bObject],506.0000,-83.89227295,998.86785889,0.0825)) return 4;
	else if(IsObjectInSphere(Pool2Ball[i][bObject],507.0000,-85.80107880,998.86785889,0.0825)) return 5;
	else if(IsObjectInSphere(Pool2Ball[i][bObject],506.0000,-84.84602356,998.86785889,0.0825)) return 6;
	else return 0;
}
script PlayPool2Sound(soundid)
{
	foreach(new i : Player)
	{
	    if(PlayingPool2[i])
	    {
	        PlayerPlaySound(i, soundid, 0, 0, 0);
	    }
	}
	return 1;
}