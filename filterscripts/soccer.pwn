#include <a_samp>
#include <physics>
#include <foreach>
#include <streamer>
stock const
	Float:BallSpawn[3] = {2706.9944, -1802.1829,822.8372},
	Float:Corners[4][3] = {
		{2677.1453, -1748.0548,822.8372},
		{2736.6797, -1747.9595,822.8372},
		{2736.7180, -1856.2570,822.8372},
		{2677.3398, -1856.5066,822.8372}
	};
new Ball = -1,Goal = 0,LastTouch = INVALID_PLAYER_ID,pLastTick[MAX_PLAYERS],BallHolder = -1,PlayerText:pPowerTD[MAX_PLAYERS],Text:PowerTD[2];
public OnFilterScriptInit()
{
	SetTimer("PowerBar", 20, 1);
	CreateBall();
	LoadCollisions();
	LoadMap();
	LoadTextDraws();
	return 1;
}
public OnPlayerConnect(playerid)
{
    LoadPlayerTextDraws(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(BallHolder == playerid)
	     RecreateBall();
    return 1;
}
public OnPlayerSpawn(playerid)
{
    if(BallHolder == playerid)
	    RecreateBall();
	ApplyAnimation(playerid, "WAYFARER", "null", 0.0, 0, 0, 0, 0, 0); // Preloads anim lib
	ApplyAnimation(playerid, "FIGHT_D", "null", 0.0, 0, 0, 0, 0, 0); // Preloads anim lib
    return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    if(BallHolder == playerid)
	    RecreateBall();
    return 1;
}

#define PRESSED(%0) \
	(newkeys & (%0) && !(oldkeys & (%0)))

#define RELEASED(%0) \
	(!(newkeys & (%0)) && oldkeys & (%0))

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (IsPlayerInRangeOfPoint(playerid, 200.0,2706.5154,-1801.9463,822.8205))
    {
	new tick = GetTickCount(),dif;
	if (PRESSED(KEY_HANDBRAKE))
		pLastTick[playerid] = tick;
	else if (RELEASED(KEY_HANDBRAKE))
	{
	    dif = tick - pLastTick[playerid];
	    pLastTick[playerid] = -1;
	    if(dif < 2000)
	    {
		    new Float:ox, Float:oy, Float:oz,Float:x, Float:y, Float:z;
		    GetBallPos(ox, oy, oz);
		    GetPlayerPos(playerid, x, y, z);
		    if(IsPlayerInRangeOfPoint(playerid, 1.2, ox, oy, z) && floatabs(oz - z) < 1.8)
		    {
		        new Float:speed,Float:angle,Float:vx, Float:vy, Float:vz;
				if(dif > 1000)
				    dif = 2000 - dif;
		        speed = (float(dif + 400) / (1000)) * 20.0;

		        if(BallHolder != -1)
		        {
			        DestroyBall();
			        CreateBall();
			        SetObjectPos(Ball, ox, oy, oz);
			        BallHolder = -1;
			    }

		        GetPlayerFacingAngle(playerid, angle);
		        vx = speed * floatsin(-angle, degrees),
		        vy = speed * floatcos(-angle, degrees);
		        vz = (speed / 5.2);
				PHY_SetObjectVelocity(Ball, vx, vy, vz);
				if(oz > BallSpawn[2] + (1.0 - 0.875))
				    ApplyAnimation(playerid, "WAYFARER", "WF_Fwd", 4.0, 0, 0, 0, 0, 0);
				else if(dif > 300)
					ApplyAnimation(playerid, "FIGHT_D", "FightD_1", 4.1, 0, 1, 1, 0, 0);
				PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);
				LastTouch = playerid;
			}
		}
	}
	if (PRESSED(KEY_WALK))
		pLastTick[playerid] = tick;
	else if (RELEASED(KEY_WALK))
	{
	    dif = tick - pLastTick[playerid];
	    pLastTick[playerid] = -1;
	    if(dif < 2000)
	    {
		    new Float:ox, Float:oy, Float:oz,Float:x, Float:y, Float:z;
		    GetBallPos(ox, oy, oz);
		    GetPlayerPos(playerid, x, y, z);
		    if(IsPlayerInRangeOfPoint(playerid, 1.2, ox, oy, z) && floatabs(oz - z) < 1.8)
		    {
		        new Float:speed,Float:angle,Float:vx, Float:vy, Float:vz;
				if(dif > 1000)
				    dif = 2000 - dif;
		        speed = (float(dif + 400) / (1000)) * 15.0;
		        if(BallHolder != -1)
		        {
			        DestroyBall();
			        CreateBall();
			        SetObjectPos(Ball, ox, oy, oz);
			        BallHolder = -1;
			    }
		        GetPlayerFacingAngle(playerid, angle);
		        vx = speed * floatsin(-angle, degrees),
		        vy = speed * floatcos(-angle, degrees);
		        vz = speed / 1.3;
				PHY_SetObjectVelocity(Ball, vx, vy, vz);

				if(oz > BallSpawn[2] + (1.0 - 0.875))
				    ApplyAnimation(playerid, "WAYFARER", "WF_Fwd", 4.0, 0, 0, 0, 0, 0);
				else if(dif > 300)
					ApplyAnimation(playerid, "FIGHT_D", "FightD_1", 4.1, 0, 1, 1, 0, 0);
				PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);

				LastTouch = playerid;
			}
		}
	}
	if (PRESSED(KEY_SECONDARY_ATTACK))
		pLastTick[playerid] = tick;
	else if (RELEASED(KEY_SECONDARY_ATTACK))
	{
	    dif = tick - pLastTick[playerid];
	    pLastTick[playerid] = -1;
	    if(dif < 2000)
	    {
		    new Float:ox, Float:oy, Float:oz,Float:x, Float:y, Float:z;
		    GetBallPos(ox, oy, oz);
		    GetPlayerPos(playerid, x, y, z);
		    if(IsPlayerInRangeOfPoint(playerid, 1.2, ox, oy, z) && floatabs(oz - z) < 1.8)
		    {
		        new Float:speed,Float:angle,Float:vx, Float:vy, Float:vz;
				if(dif > 1000)
				    dif = 2000 - dif;
		        speed = (float(dif + 400) / (1000)) * 16.0;
		        if(BallHolder != -1)
		        {
			        DestroyBall();
			        CreateBall();
			        SetObjectPos(Ball, ox, oy, oz);
			        BallHolder = -1;
			    }
		        GetPlayerFacingAngle(playerid, angle);
		        vx = speed * floatsin(-angle, degrees),
		        vy = speed * floatcos(-angle, degrees);
		        vz = speed / 2.0;
				PHY_SetObjectVelocity(Ball, vx, vy, vz);
				if(oz > BallSpawn[2] + (1.0 - 0.875))
				    ApplyAnimation(playerid, "WAYFARER", "WF_Fwd", 4.0, 0, 0, 0, 0, 0);
				else if(dif > 300)
					ApplyAnimation(playerid, "FIGHT_D", "FightD_1", 4.1, 0, 1, 1, 0, 0);
				PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);
				LastTouch = playerid;
			}
		}
	}
	if(PRESSED(KEY_FIRE))
	{
	    new Float:ox, Float:oy, Float:oz,Float:x, Float:y, Float:z;
		GetBallPos(ox, oy, oz);
		if(BallHolder == playerid)
		{
		    DestroyBall();
			CreateBall();
			SetObjectPos(Ball, ox, oy, oz);
			BallHolder = -1;
		}
		else
		{
			GetPlayerPos(playerid, x, y, z);
			if(IsPlayerInRangeOfPoint(playerid, 1.2, ox, oy, z) && oz < z && (z - oz) < 1.2)
			{
			    GetObjectRot(Ball, ox, oy, oz);
			    AttachObjectToPlayer(Ball, playerid, 0.0, 0.6, -0.875, ox, oy, oz);
				if(BallHolder != -1)
				    PlayerPlaySound(BallHolder, 1130, 0.0, 0.0, 0.0);
				PlayerPlaySound(playerid, 1130, 0.0, 0.0, 0.0);
				BallHolder = playerid;
				LastTouch = playerid;
			}
		}
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0);
	}
	}
	return 1;
}
stock CreateBall()
{
	if(Ball != -1)
	    return;

	Ball = CreateObject(2114, BallSpawn[0], BallSpawn[1], BallSpawn[2] - 0.875, 0, 0, 0, 100.0);
	SetObjectMaterial(Ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
	PHY_InitObject(Ball, 2114);
	PHY_RollObject(Ball);
	PHY_SetObjectFriction(Ball, 7.0);
	PHY_SetObjectAirResistance(Ball, 0.2);
	PHY_SetObjectGravity(Ball, 10.0);
	PHY_SetObjectZBound(Ball, _, _, 0.5);
	PHY_ToggleObjectPlayerColls(Ball, 1, 0.6);
}
stock DestroyBall()
{
	PHY_DeleteObject(Ball);
	DestroyObject(Ball);
	Ball = -1;
}
stock GetBallPos(&Float:x, &Float:y, &Float:z)
{
	if(BallHolder != -1)
	{
	    new Float:angle;
	    GetPlayerPos(BallHolder, x, y, z);
		GetPlayerFacingAngle(BallHolder, angle);
		x += 0.6 * floatsin(-angle, degrees);
		y += 0.6 * floatcos(-angle, degrees);
		z -= 0.875;
	}
	else
		GetObjectPos(Ball, x, y, z);
}
stock RecreateBall()
{
    DestroyBall();
	CreateBall();
	BallHolder = -1;
}

stock LoadCollisions()
{
	// Field
	PHY_CreateArea(2669.03, -1864.08, 2745.12, -1740.54, _, _,824.5);
	// Goal
	PHY_CreateWall(2711.87, -1857.30, 2711.87, -1862.75, 0.5, _,825.87);
	PHY_CreateWall(2711.87, -1862.75, 2701.92, -1862.75, 0.5, _,825.87);
	PHY_CreateWall(2701.92, -1862.75, 2701.92, -1857.30, 0.5, _,825.87);
	// Crossbar
	PHY_CreateWall(2701.92, -1857.30, 2711.87, -1857.30, _,825.87 - 0.1,825.87 + 0.1);
	// Pole
	PHY_CreateCylinder(2711.87, -1857.30, 0.3, _, _,825.87);
	PHY_CreateCylinder(2701.92, -1857.30, 0.3, _, _,825.87);
	// Goal
    PHY_CreateWall(2701.92, -1747.10, 2701.92, -1741.60, 0.5, _,825.87);
	PHY_CreateWall(2701.92, -1741.60, 2711.89, -1741.60, 0.5, _,825.87);
	PHY_CreateWall(2711.89, -1741.60, 2711.89, -1747.10, 0.5, _,825.87);
	// Crossbar
	PHY_CreateWall(2711.89, -1747.10, 2701.92, -1747.10, _,825.87 - 0.1,825.87 + 0.1);
	// Pole
	PHY_CreateCylinder(2701.92, -1747.10, 0.3, _, _,825.87);
	PHY_CreateCylinder(2711.89, -1747.10, 0.3, _, _,825.87);
}

public PHY_OnObjectUpdate(objectid)
{
	if(objectid != Ball)
	    return 1;
	new Float:x, Float:y, Float:z,goal;
	GetBallPos(x, y, z);
	if(!(2669.03 < x < 2745.12 && -1864.08 < y < -1740.54))
	{
	    RecreateBall();
	}
	else if((2701.92 < x < 2711.87 && -1862.75 < y < -1857.30 && (goal = 1)) || (2701.92 < x < 2711.89 && -1747.10 < y < -1741.60 && (goal = 2)))
	{
	    PHY_SetObjectZBound(Ball, _,825.6 , 0.5);
	    if(z > 425.6)
	    {
	        RecreateBall();
	        new Float:mindist = FLOAT_INFINITY,Float:dist,closest;
	        for(new i; i < sizeof Corners; i++)
	        {
	            dist = (x - Corners[i][0]) * (x - Corners[i][0]) + (y - Corners[i][1]) * (y - Corners[i][1]);
				if(dist < mindist)
				{
				    mindist = dist;
				    closest = i;
				}
	        }
	        SetObjectPos(Ball, Corners[closest][0], Corners[closest][1], Corners[closest][2]);
	    }
	    else if(!Goal)
	    {
	        new name[MAX_PLAYER_NAME];
	        Goal = 1;
	        GetPlayerName(LastTouch, name, sizeof name);
	        foreach (new zz : Player)
	        if (IsPlayerInRangeOfPoint(zz, 200.0,2706.5154,-1801.9463,822.8205))
    		{
	        	GameTextForPlayer(zz, "~g~BUT", 10000, 4);
	        }
	        RecreateBall();
	        #pragma unused goal
	    }
	}
	else if(Goal)
	{
	    Goal = 0;
	    PHY_SetObjectZBound(Ball, _, FLOAT_INFINITY, 0.5);
	}
	return 1;
}
stock LoadMap()
{
    CreateDynamicObject(7910,2703.8125000,-1864.4963379,820.2529907,0.0000000,0.0000000,180.0000000,100); //object(vgwestbillbrd11) (1)
	CreateDynamicObject(7910,2720.6867676,-1864.4967041,820.2529907,0.0000000,0.0000000,180.0000000,100); //object(vgwestbillbrd11) (2)
	CreateDynamicObject(7910,2737.5659180,-1864.4967041,820.2529907,0.0000000,0.0000000,180.0000000,100); //object(vgwestbillbrd11) (3)
	CreateDynamicObject(7910,2686.9428711,-1864.4969482,820.2529907,0.0000000,0.0000000,180.0000000,100); //object(vgwestbillbrd11) (7)
	CreateDynamicObject(7910,2670.0625000,-1864.4974365,820.2529907,0.0000000,0.0000000,180.0000000,100); //object(vgwestbillbrd11) (8)
	CreateDynamicObject(7910,2668.4462891,-1747.9892578,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (10)
	CreateDynamicObject(7910,2668.4462891,-1764.8634033,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (11)
	CreateDynamicObject(7910,2668.4462891,-1781.7423096,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (12)
	CreateDynamicObject(7910,2668.4462891,-1798.6231689,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (13)
	CreateDynamicObject(7910,2668.4462891,-1815.4971924,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (14)
	CreateDynamicObject(7910,2668.4462891,-1832.3769531,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (15)
	CreateDynamicObject(7910,2668.4462891,-1849.2462158,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (16)
	CreateDynamicObject(7910,2668.4462891,-1866.1201172,820.2529907,0.0000000,0.0000000,90.0000000,100); //object(vgwestbillbrd11) (17)
	CreateDynamicObject(7910,2745.6035156,-1866.1269531,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (20)
	CreateDynamicObject(7910,2745.6037598,-1849.2492676,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (21)
	CreateDynamicObject(7910,2745.6037598,-1832.3682861,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (22)
	CreateDynamicObject(7910,2745.6035156,-1815.4938965,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (23)
	CreateDynamicObject(7910,2745.6035156,-1798.6142578,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (24)
	CreateDynamicObject(7910,2745.6032715,-1781.7441406,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (25)
	CreateDynamicObject(7910,2745.6035156,-1764.8703613,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (26)
	CreateDynamicObject(7910,2745.6035156,-1747.9909668,820.2529907,0.0000000,0.0000000,270.0000000,100); //object(vgwestbillbrd11) (27)
	CreateDynamicObject(7910,2750.6953125,-1740.1406250,820.2529907,0.0000000,0.0000000,0.0000000,100); //object(vgwestbillbrd11) (29)
	CreateDynamicObject(7910,2733.8164062,-1740.1406250,820.2529907,0.0000000,0.0000000,0.0000000,100); //object(vgwestbillbrd11) (30)
	CreateDynamicObject(7910,2716.9357910,-1740.1407471,820.2529907,0.0000000,0.0000000,0.0000000,100); //object(vgwestbillbrd11) (31)
	CreateDynamicObject(7910,2700.0615234,-1740.1406250,820.2529907,0.0000000,0.0000000,0.0000000,100); //object(vgwestbillbrd11) (32)
	CreateDynamicObject(7910,2683.1818848,-1740.1414795,820.2529907,0.0000000,0.0000000,0.0000000,100); //object(vgwestbillbrd11) (33)
	CreateDynamicObject(7910,2666.3115234,-1740.1416016,820.2529907,0.0000000,0.0000000,0.0000000,100); //object(vgwestbillbrd11) (34)
	CreateDynamicObject(11453,2676.1801758,-1749.0705566,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (20)
	CreateDynamicObject(11453,2676.1821289,-1753.1594238,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (21)
	CreateDynamicObject(11453,2676.1809082,-1757.2591553,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (22)
	CreateDynamicObject(11453,2676.1801758,-1761.3560791,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (23)
	CreateDynamicObject(11453,2676.1821289,-1765.4554443,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (24)
	CreateDynamicObject(11453,2676.1816406,-1769.5549316,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (25)
	CreateDynamicObject(11453,2676.1806641,-1773.6514893,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (26)
	CreateDynamicObject(11453,2676.1818848,-1777.7512207,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (27)
	CreateDynamicObject(11453,2676.1818848,-1781.8510742,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (28)
	CreateDynamicObject(11453,2676.1809082,-1785.9473877,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (29)
	CreateDynamicObject(11453,2676.1818848,-1790.0471191,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (30)
	CreateDynamicObject(11453,2676.1818848,-1794.1468506,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (31)
	CreateDynamicObject(11453,2676.1809082,-1798.2435303,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (32)
	CreateDynamicObject(11453,2678.4179688,-1747.2121582,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (33)
	CreateDynamicObject(11453,2682.2182617,-1747.2120361,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (34)
	CreateDynamicObject(11453,2686.3149414,-1747.2130127,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (35)
	CreateDynamicObject(11453,2690.4038086,-1747.2110596,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (36)
	CreateDynamicObject(11453,2694.5034180,-1747.2120361,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (37)
	CreateDynamicObject(11453,2698.6000977,-1747.2130127,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (38)
	CreateDynamicObject(11453,2702.6992188,-1747.2109375,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2706.7988281,-1747.2109375,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (40)
	CreateDynamicObject(11453,2710.8959961,-1747.2120361,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (41)
	CreateDynamicObject(11453,2714.9956055,-1747.2110596,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (42)
	CreateDynamicObject(11453,2719.0952148,-1747.2110596,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (43)
	CreateDynamicObject(11453,2723.1918945,-1747.2120361,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (44)
	CreateDynamicObject(11453,2727.2915039,-1747.2110596,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (45)
	CreateDynamicObject(11453,2731.3911133,-1747.2110596,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (46)
	CreateDynamicObject(11453,2735.4877930,-1747.2120361,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (47)
	CreateDynamicObject(11453,2678.4179688,-1802.3122559,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (48)
	CreateDynamicObject(11453,2682.2177734,-1802.3122559,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (49)
	CreateDynamicObject(11453,2686.3144531,-1802.3132324,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (50)
	CreateDynamicObject(11453,2690.4033203,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (51)
	CreateDynamicObject(11453,2694.5029297,-1802.3122559,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (52)
	CreateDynamicObject(11453,2698.5996094,-1802.3132324,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (53)
	CreateDynamicObject(11453,2702.6992188,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (54)
	CreateDynamicObject(11453,2706.7988281,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (55)
	CreateDynamicObject(11453,2710.8955078,-1802.3122559,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (56)
	CreateDynamicObject(11453,2714.9951172,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (57)
	CreateDynamicObject(11453,2719.0947266,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (58)
	CreateDynamicObject(11453,2723.1914062,-1802.3122559,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (59)
	CreateDynamicObject(11453,2727.2910156,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (60)
	CreateDynamicObject(11453,2731.3906250,-1802.3112793,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (61)
	CreateDynamicObject(11453,2735.4873047,-1802.3122559,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (62)
	CreateDynamicObject(11453,2676.1804199,-1802.3519287,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (63)
	CreateDynamicObject(11453,2676.1804199,-1806.1527100,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (64)
	CreateDynamicObject(11453,2676.1794434,-1810.2484131,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (65)
	CreateDynamicObject(11453,2676.1813965,-1814.3372803,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (66)
	CreateDynamicObject(11453,2676.1804199,-1818.4378662,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (67)
	CreateDynamicObject(11453,2676.1794434,-1822.5345459,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (68)
	CreateDynamicObject(11453,2676.1813965,-1826.6341553,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (69)
	CreateDynamicObject(11453,2676.1813965,-1830.7327881,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (70)
	CreateDynamicObject(11453,2676.1804199,-1834.8294678,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (71)
	CreateDynamicObject(11453,2676.1813965,-1838.9290771,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (72)
	CreateDynamicObject(11453,2676.1813965,-1843.0296631,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (73)
	CreateDynamicObject(11453,2676.1804199,-1847.1253662,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (74)
	CreateDynamicObject(11453,2676.1813965,-1851.2249756,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (75)
	CreateDynamicObject(11453,2676.1813965,-1855.3255615,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (76)
	CreateDynamicObject(11453,2737.5358887,-1749.0705566,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (79)
	CreateDynamicObject(11453,2737.5378418,-1753.1594238,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (80)
	CreateDynamicObject(11453,2737.5366211,-1757.2591553,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (81)
	CreateDynamicObject(11453,2737.5358887,-1761.3560791,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (82)
	CreateDynamicObject(11453,2737.5373535,-1769.5549316,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (83)
	CreateDynamicObject(11453,2737.5378418,-1765.4554443,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (84)
	CreateDynamicObject(11453,2737.5363770,-1773.6514893,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (85)
	CreateDynamicObject(11453,2737.5375977,-1777.7512207,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (86)
	CreateDynamicObject(11453,2737.5375977,-1781.8510742,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (87)
	CreateDynamicObject(11453,2737.5366211,-1785.9473877,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (88)
	CreateDynamicObject(11453,2737.5375977,-1790.0471191,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (89)
	CreateDynamicObject(11453,2737.5375977,-1794.1468506,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (90)
	CreateDynamicObject(11453,2737.5366211,-1798.2435303,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (91)
	CreateDynamicObject(11453,2737.5361328,-1802.3515625,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (92)
	CreateDynamicObject(11453,2737.5361328,-1806.1527100,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (93)
	CreateDynamicObject(11453,2737.5351562,-1810.2484131,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (94)
	CreateDynamicObject(11453,2737.5371094,-1814.3372803,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (95)
	CreateDynamicObject(11453,2737.5361328,-1818.4378662,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (96)
	CreateDynamicObject(11453,2737.5351562,-1822.5345459,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (97)
	CreateDynamicObject(11453,2737.5371094,-1826.6341553,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (98)
	CreateDynamicObject(11453,2737.5371094,-1830.7327881,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (99)
	CreateDynamicObject(11453,2737.5361328,-1834.8294678,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (100)
	CreateDynamicObject(11453,2737.5371094,-1838.9290771,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (101)
	CreateDynamicObject(11453,2737.5371094,-1843.0296631,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (102)
	CreateDynamicObject(11453,2737.5361328,-1847.1253662,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (103)
	CreateDynamicObject(11453,2737.5371094,-1851.2249756,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (104)
	CreateDynamicObject(11453,2737.5371094,-1855.3255615,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (105)
	CreateDynamicObject(11453,2678.4179688,-1857.3953857,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (108)
	CreateDynamicObject(11453,2682.2177734,-1857.3953857,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (109)
	CreateDynamicObject(11453,2686.3144531,-1857.3963623,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (110)
	CreateDynamicObject(11453,2690.4033203,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (111)
	CreateDynamicObject(11453,2694.5029297,-1857.3953857,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (112)
	CreateDynamicObject(11453,2698.5996094,-1857.3963623,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (113)
	CreateDynamicObject(11453,2702.6992188,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (114)
	CreateDynamicObject(11453,2706.7988281,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (115)
	CreateDynamicObject(11453,2710.8955078,-1857.3953857,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (116)
	CreateDynamicObject(11453,2714.9951172,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (117)
	CreateDynamicObject(11453,2719.0947266,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (118)
	CreateDynamicObject(11453,2723.1914062,-1857.3953857,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (119)
	CreateDynamicObject(11453,2727.2910156,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (120)
	CreateDynamicObject(11453,2731.3906250,-1857.3944092,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (121)
	CreateDynamicObject(11453,2735.4873047,-1857.3953857,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (122)
	CreateDynamicObject(13650,2691.2412109,-1805.9853516,829.0810852,0.0000000,0.0000000,90.0000000,100); //object(kickcrowd01) (2)
	CreateDynamicObject(13650,2719.5751953,-1805.1885986,828.6314087,0.0000000,0.0000000,90.0000000,100); //object(kickcrowd01) (4)
	CreateDynamicObject(13633,2769.1577148,-1806.4705811,827.5697937,0.0000000,0.0000000,270.0000000,100); //object(dirtouter01) (1)
	CreateDynamicObject(13633,2646.4758301,-1806.4698486,827.5198059,0.0000000,0.0000000,270.0000000,100); //object(dirtouter01) (2)
	CreateDynamicObject(12814,2701.1279297,-1914.5119629,821.8161011,0.0000000,0.0000000,0.0000000,100); //object(cuntyeland04) (2)
	CreateDynamicObject(10954,2604.8879395,-1755.7951660,842.6835938,0.0000000,0.0000000,90.0000000,100); //object(stadium_sfse) (1)
	CreateDynamicObject(10954,2604.8876953,-1877.7409668,842.6835938,0.0000000,0.0000000,270.0000000,100); //object(stadium_sfse) (2)
	CreateDynamicObject(10954,2705.7868652,-1935.2102051,842.6835938,0.0000000,0.0000000,0.0000000,100); //object(stadium_sfse) (3)
	CreateDynamicObject(10954,2807.3195801,-1819.9398193,842.6835938,0.0000000,0.0000000,90.0000000,100); //object(stadium_sfse) (4)
	CreateDynamicObject(10954,2807.3193359,-1697.9189453,842.6835938,0.0000000,0.0000000,90.0000000,100); //object(stadium_sfse) (5)
	CreateDynamicObject(10954,2720.4765625,-1684.7392578,842.6835938,0.0000000,0.0000000,179.9945068,100); //object(stadium_sfse) (6)
	CreateDynamicObject(7617,2708.9875488,-1877.5488281,854.5177002,340.0000000,0.0000000,0.0000000,100); //object(vgnbballscorebrd) (1)
	CreateDynamicObject(10954,2705.7861328,-1947.7587891,842.6835938,0.0000000,0.0000000,90.0000000,100); //object(stadium_sfse) (7)
	CreateDynamicObject(13650,2713.1459961,-1805.1883545,829.8066101,0.0000000,0.0000000,90.0000000,100); //object(kickcrowd01) (4)
	CreateDynamicObject(13650,2698.8159180,-1805.9853516,430.3810120,0.0000000,0.0000000,90.0000000,100); //object(kickcrowd01) (2)
	CreateDynamicObject(10954,2727.6489258,-1677.9151611,842.6835938,0.0000000,0.0000000,179.9945068,100); //object(stadium_sfse) (8)
	CreateDynamicObject(7416,2669.0466309,-1791.2226562,784.2138062,0.0000000,90.0000000,179.9997559,100); //object(vegasstadgrnd) (1)
	CreateDynamicObject(7416,2669.0458984,-1891.1839600,784.2138062,0.0000000,90.0000000,179.9945068,100); //object(vegasstadgrnd) (2)
	CreateDynamicObject(7416,2698.9348145,-1863.9301758,786.7239990,0.0000000,90.0000000,269.9936523,100); //object(vegasstadgrnd) (3)
	CreateDynamicObject(7416,2744.7675781,-1813.2607422,786.7239990,0.0000000,90.0000000,359.9835205,100); //object(vegasstadgrnd) (4)
	CreateDynamicObject(7416,2744.7675781,-1719.7440186,786.7239990,0.0000000,90.0000000,359.9835205,100); //object(vegasstadgrnd) (5)
	CreateDynamicObject(7416,2744.7675781,-1740.5721436,786.7239990,0.0000000,90.0000000,90.0000000,100); //object(vegasstadgrnd) (6)
	CreateDynamicObject(13637,2707.0212402,-1802.2452393,819.7579041,0.0000000,0.0000000,0.0000000,100); //object(tuberamp) (1)
	CreateDynamicObject(13637,2707.0209961,-1802.2443848,819.7579041,0.0000000,0.0000000,200.0000000,100); //object(tuberamp) (2)
	CreateDynamicObject(13637,2707.0209961,-1802.2443848,819.7579041,0.0000000,0.0000000,149.9951172,100); //object(tuberamp) (3)
	CreateDynamicObject(1286,2706.9506836,-1802.2687988,821.2839050,0.0000000,0.0000000,0.0000000,100); //object(newstandnew4) (15)
	CreateDynamicObject(974,2706.9079590,-1862.7813721,823.0520935,0.0000000,0.0000000,180.0000000,100); //object(tall_fence) (1)
	CreateDynamicObject(1286,2707.0000000,-1802.2436523,821.2839050,0.0000000,0.0000000,90.0000000,100); //object(newstandnew4) (18)
	CreateDynamicObject(1286,2707.0000000,-1802.2431641,821.2839050,0.0000000,0.0000000,140.0000000,100); //object(newstandnew4) (19)
	CreateDynamicObject(1286,2706.9750977,-1802.2181396,821.2839050,0.0000000,0.0000000,229.9987488,100); //object(newstandnew4) (20)
	CreateDynamicObject(974,2705.2575684,-1862.7819824,823.0520935,0.0000000,0.0000000,180.0000000,100); //object(tall_fence) (13)
	CreateDynamicObject(974,2708.6181641,-1862.7816162,823.0520935,0.0000000,0.0000000,180.0000000,100); //object(tall_fence) (14)
	CreateDynamicObject(974,2708.6191406,-1860.1307373,825.8019104,90.0000000,0.0000000,180.0000000,100); //object(tall_fence) (15)
	CreateDynamicObject(974,2705.2963867,-1860.1301270,825.8019104,90.0000000,0.0000000,180.0000000,100); //object(tall_fence) (16)
	CreateDynamicObject(974,2701.9577637,-1860.0325928,822.5021973,0.0000000,90.0000000,90.0000000,100); //object(tall_fence) (17)
	CreateDynamicObject(974,2711.9311523,-1860.0324707,822.5021973,0.0000000,90.0000000,90.0000000,100); //object(tall_fence) (18)
	CreateDynamicObject(7301,2736.4611816,-1879.3298340,825.6137085,0.0000000,0.0000000,316.0000000,100); //object(vgsn_addboard03) (1)
	CreateDynamicObject(7914,2720.5158691,-1878.8907471,825.5755005,0.0000000,0.0000000,178.0000000,100); //object(vgwestbillbrd15) (1)
	CreateDynamicObject(7914,2677.7072754,-1879.1651611,825.5755005,0.0000000,0.0000000,179.9949951,100); //object(vgwestbillbrd15) (2)
	CreateDynamicObject(7913,2704.2929688,-1878.6883545,825.4659119,0.0000000,0.0000000,180.0000000,100); //object(vgwestbillbrd14) (1)
	CreateDynamicObject(7913,2691.9521484,-1878.9377441,825.4659119,0.0000000,0.0000000,181.9945068,100); //object(vgwestbillbrd14) (2)
	CreateDynamicObject(1319,2711.9238281,-1857.3041992,825.3765869,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (6)
	CreateDynamicObject(1319,2711.9238281,-1857.3041992,824.3016968,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (7)
	CreateDynamicObject(1319,2701.9345703,-1747.0859375,823.2767944,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (8)
	CreateDynamicObject(1319,2711.9238281,-1857.3041992,822.3016968,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (9)
	CreateDynamicObject(1319,2701.9538574,-1857.3038330,825.3765869,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (10)
	CreateDynamicObject(1319,2701.9550781,-1857.3038330,824.3016968,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (11)
	CreateDynamicObject(1319,2701.9550781,-1857.3038330,823.2767944,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (12)
	CreateDynamicObject(1319,2701.9550781,-1857.3038330,822.3016968,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (13)
	CreateDynamicObject(1319,2702.5031738,-1857.3537598,825.8265991,90.0000000,90.0000000,0.0000000,100); //object(ws_ref_bollard) (14)
	CreateDynamicObject(1319,2703.5537109,-1857.3547363,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (15)
	CreateDynamicObject(1319,2704.6005859,-1857.3543701,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (16)
	CreateDynamicObject(1319,2705.6748047,-1857.3547363,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (17)
	CreateDynamicObject(1319,2706.7487793,-1857.3547363,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (18)
	CreateDynamicObject(1319,2707.8208008,-1857.3544922,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (19)
	CreateDynamicObject(1319,2708.8957520,-1857.3543701,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (20)
	CreateDynamicObject(1319,2709.9953613,-1857.3548584,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (21)
	CreateDynamicObject(1319,2711.0678711,-1857.3546143,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (22)
	CreateDynamicObject(1319,2711.4167480,-1857.3546143,825.8265991,90.0000000,90.0000000,359.9945068,100); //object(ws_ref_bollard) (23)
	CreateDynamicObject(11453,2712.0117188,-1855.1530762,821.0015869,0.0000000,0.0000000,90.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2702.0537109,-1855.1534424,821.0015869,0.0000000,0.0000000,90.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2704.0537109,-1853.0781250,821.0015869,0.0000000,0.0000000,180.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2708.1313477,-1853.0780029,821.0015869,0.0000000,0.0000000,180.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2709.9560547,-1853.0776367,821.0015869,0.0000000,0.0000000,180.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(974,2701.9272461,-1744.3571777,822.5021973,0.0000000,90.0000000,270.0000000,100); //object(tall_fence) (19)
	CreateDynamicObject(974,2705.2397461,-1741.6081543,823.0520935,0.0000000,0.0000000,0.0000000,100); //object(tall_fence) (20)
	CreateDynamicObject(974,2708.6005859,-1741.6081543,823.0520935,0.0000000,0.0000000,0.0000000,100); //object(tall_fence) (21)
	CreateDynamicObject(974,2706.9506836,-1741.6085205,823.0520935,0.0000000,0.0000000,0.0000000,100); //object(tall_fence) (22)
	CreateDynamicObject(974,2708.5620117,-1744.2595215,825.8019104,90.0000000,0.0000000,0.0000000,100); //object(tall_fence) (23)
	CreateDynamicObject(974,2711.9003906,-1744.3575439,822.5021973,0.0000000,90.0000000,270.0000000,100); //object(tall_fence) (24)
	CreateDynamicObject(974,2705.2392578,-1744.2595215,825.8019104,90.0000000,0.0000000,0.0000000,100); //object(tall_fence) (25)
	CreateDynamicObject(11453,2711.8049316,-1749.2364502,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2709.8046875,-1751.3116455,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2705.7270508,-1751.3116455,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2703.9028320,-1751.3116455,821.0015869,0.0000000,0.0000000,0.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(11453,2701.8466797,-1749.2365723,821.0015869,0.0000000,0.0000000,270.0000000,100); //object(des_sherrifsgn1) (39)
	CreateDynamicObject(1319,2701.9345703,-1747.0859375,822.3016968,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (24)
	CreateDynamicObject(1319,2701.9345703,-1747.0859375,824.3016968,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (25)
	CreateDynamicObject(1319,2701.9345703,-1747.0859375,825.3765869,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (26)
	CreateDynamicObject(1319,2702.2421875,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (27)
	CreateDynamicObject(1319,2703.8632812,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (28)
	CreateDynamicObject(1319,2702.7905273,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (29)
	CreateDynamicObject(1319,2704.9624023,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (30)
	CreateDynamicObject(1319,2706.0375977,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (31)
	CreateDynamicObject(1319,2707.1098633,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (32)
	CreateDynamicObject(1319,2708.1840820,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (33)
	CreateDynamicObject(1319,2709.2578125,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (34)
	CreateDynamicObject(1319,2710.3046875,-1747.0351562,825.8265991,90.0000000,90.0000000,179.9945068,100); //object(ws_ref_bollard) (35)
	CreateDynamicObject(1319,2711.3554688,-1747.0360107,825.8265991,90.0000000,90.0000000,180.0000000,100); //object(ws_ref_bollard) (36)
	CreateDynamicObject(1319,2711.9042969,-1747.0859375,825.3765869,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (37)
	CreateDynamicObject(1319,2711.9033203,-1747.0859375,824.3016968,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (38)
	CreateDynamicObject(1319,2711.9033203,-1747.0859375,823.2767944,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (39)
	CreateDynamicObject(1319,2711.9033203,-1747.0859375,822.3016968,0.0000000,0.0000000,270.0000000,100); //object(ws_ref_bollard) (40)
	CreateDynamicObject(1319,2711.9238281,-1857.3038330,823.2267151,0.0000000,0.0000000,90.0000000,100); //object(ws_ref_bollard) (41)
	CreateDynamicObject(2004,2736.7880859,-1856.7659912,821.8374939,0.0000000,90.0000000,269.9996338,100); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,2737.1379395,-1856.3420410,821.8374939,0.0000000,90.0000000,179.9989624,100); //object(cr_safe_door) (2)
	CreateDynamicObject(2004,2737.1145020,-1747.9558105,821.8374939,0.0000000,90.0000000,0.0000000,100); //object(cr_safe_door) (3)
	CreateDynamicObject(2004,2736.6909180,-1747.6058350,821.8374939,0.0000000,90.0000000,269.9996338,100); //object(cr_safe_door) (4)
	CreateDynamicObject(2004,2677.1362305,-1747.6323242,821.8374939,0.0000000,90.0000000,89.9998779,100); //object(cr_safe_door) (5)
	CreateDynamicObject(2004,2676.7863770,-1748.0561523,821.8374939,0.0000000,90.0000000,359.9995117,100); //object(cr_safe_door) (6)
	CreateDynamicObject(2004,2676.8107910,-1856.4422607,821.8374939,0.0000000,90.0000000,179.9996338,100); //object(cr_safe_door) (7)
	CreateDynamicObject(2004,2677.2346191,-1856.7923584,821.8374939,0.0000000,90.0000000,89.9991150,100);//object(cr_safe_door) (8)
	CreateDynamicObject(2993,2737.5856934,-1747.1446533,822.3048096,0.0000000,0.0000000,330.0000000,100); //object(kmb_goflag) (1)
	CreateDynamicObject(2993,2737.5854492,-1747.1444092,822.3547974,358.0000000,180.0000000,150.0000000,100); //object(kmb_goflag) (2)
	CreateDynamicObject(2993,2676.3339844,-1747.1435547,822.3547974,358.0000000,180.0000000,180.0000000,100); //object(kmb_goflag) (3)
	CreateDynamicObject(2993,2676.3342285,-1747.1437988,822.3048096,0.0000000,0.0000000,0.0000000,100); //object(kmb_goflag) (4)
	CreateDynamicObject(2993,2676.2592773,-1857.2999268,822.3547974,358.0000000,180.0000000,180.0000000,100); //object(kmb_goflag) (5)
	CreateDynamicObject(2993,2676.2595215,-1857.3001709,822.3048096,0.0000000,0.0000000,0.0000000,100); //object(kmb_goflag) (6)
	CreateDynamicObject(2993,2737.6601562,-1857.2500000,822.3547974,358.0000000,180.0000000,30.0000000,100); //object(kmb_goflag) (7)
	CreateDynamicObject(2993,2737.6604004,-1857.2502441,822.3048096,0.0000000,0.0000000,210.0000000,100); //object(kmb_goflag) (8)
	CreateDynamicObject(10954,2807.3193359,-1901.1168213,842.6835938,0.0000000,0.0000000,50.0000000,100); //object(stadium_sfse) (11)
	CreateDynamicObject(3872,2674.4592285,-1851.8292236,828.6889038,0.0000000,0.0000000,182.0000000,100); //object(ws_floodbeams) (2)
	CreateDynamicObject(3864,2667.2016602,-1852.0694580,827.9209900,0.0000000,0.0000000,181.9995117,100); //object(ws_floodlight) (2)
	CreateDynamicObject(3872,2674.4589844,-1825.8857422,828.6889038,0.0000000,0.0000000,181.9995117,100);//object(ws_floodbeams) (3)
	CreateDynamicObject(3864,2667.2514648,-1826.1259766,827.9209900,0.0000000,0.0000000,181.9995117,100); //object(ws_floodlight) (3)
	CreateDynamicObject(3872,2674.4592285,-1800.1103516,828.6889038,0.0000000,0.0000000,182.0000000,100); //object(ws_floodbeams) (4)
	CreateDynamicObject(3864,2667.2514648,-1800.3505859,827.9209900,0.0000000,0.0000000,181.9995117,100); //object(ws_floodlight) (4)
	CreateDynamicObject(3872,2674.4592285,-1774.6695557,828.6889038,0.0000000,0.0000000,182.0000000,100); //object(ws_floodbeams) (5)
	CreateDynamicObject(3864,2667.2763672,-1774.9101562,827.9209900,0.0000000,0.0000000,181.9995117,100); //object(ws_floodlight) (5)
	CreateDynamicObject(3872,2674.4592285,-1749.1297607,828.6889038,0.0000000,0.0000000,182.0000000,100); //object(ws_floodbeams) (6)
	CreateDynamicObject(3864,2667.3012695,-1749.3702393,827.9209900,0.0000000,0.0000000,181.9995117,100); //object(ws_floodlight) (6)
	CreateDynamicObject(3872,2739.3930664,-1751.2547607,828.6889038,0.0000000,0.0000000,2.0000000,100); //object(ws_floodbeams) (7)
	CreateDynamicObject(3864,2746.7246094,-1751.0126953,827.9209900,0.0000000,0.0000000,1.9995117,100); //object(ws_floodlight) (7)
	CreateDynamicObject(3872,2739.3930664,-1777.0501709,828.6889038,0.0000000,0.0000000,2.0000000,100); //object(ws_floodbeams) (8)
	CreateDynamicObject(3864,2747.0263672,-1776.8095703,827.9209900,0.0000000,0.0000000,1.9995117,100); //object(ws_floodlight) (8)
	CreateDynamicObject(3872,2739.3930664,-1802.7508545,828.6889038,0.0000000,0.0000000,2.0000000,100); //object(ws_floodbeams) (9)
	CreateDynamicObject(3864,2746.8251953,-1802.5097656,827.9209900,0.0000000,0.0000000,1.9995117,100); //object(ws_floodlight) (9)
	CreateDynamicObject(3872,2739.3925781,-1828.1005859,828.6889038,0.0000000,0.0000000,1.9995117,100); //object(ws_floodbeams) (10)
	CreateDynamicObject(3864,2746.8242188,-1827.8603516,827.9209900,0.0000000,0.0000000,1.9995117,100); //object(ws_floodlight) (10)
	CreateDynamicObject(3872,2740.3422852,-1853.6866455,828.6889038,0.0000000,0.0000000,2.0000000,100); //object(ws_floodbeams) (11)
	CreateDynamicObject(3864,2747.0263672,-1853.4462891,827.9209900,0.0000000,0.0000000,1.9995117,100); //object(ws_floodlight) (11)
	CreateDynamicObject(3872,2714.6223145,-1860.2408447,828.6889038,0.0000000,0.0000000,270.0000000,100); //object(ws_floodbeams) (12)
	CreateDynamicObject(3864,2714.6289062,-1866.9296875,827.9209900,0.0000000,0.0000000,270.0000000,100); //object(ws_floodlight) (12)
	CreateDynamicObject(3872,2699.4748535,-1860.2408447,828.6889038,0.0000000,0.0000000,270.0000000,100); //object(ws_floodbeams) (13)
	CreateDynamicObject(3864,2699.4816895,-1866.9296875,827.9209900,0.0000000,0.0000000,270.0000000,100); //object(ws_floodlight) (13)
	CreateDynamicObject(3872,2699.4748535,-1746.2641602,828.6889038,0.0000000,0.0000000,90.0000000,100); //object(ws_floodbeams) (14)
	CreateDynamicObject(3864,2699.4677734,-1739.5753174,827.9209900,0.0000000,0.0000000,90.0000000,100); //object(ws_floodlight) (14)
	CreateDynamicObject(3872,2714.2248535,-1745.2641602,828.6889038,0.0000000,0.0000000,90.0000000,100); //object(ws_floodbeams) (15)
	CreateDynamicObject(3864,2714.2177734,-1738.5753174,827.9209900,0.0000000,0.0000000,90.0000000,100); //object(ws_floodlight) (15)
	CreateDynamicObject(19381,2740.4389648,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (1)
	CreateDynamicObject(19381,2729.9643555,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (2)
	CreateDynamicObject(19381,2719.4641113,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (3)
	CreateDynamicObject(19381,2708.9667969,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (4)
	CreateDynamicObject(19381,2698.4707031,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (5)
	CreateDynamicObject(19381,2687.9892578,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (6)
	CreateDynamicObject(19381,2677.5180664,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (7)
	CreateDynamicObject(19381,2667.0180664,-1860.1474609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (8)
	CreateDynamicObject(19381,2667.0175781,-1850.5218506,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (9)
	CreateDynamicObject(19381,2667.0175781,-1840.8968506,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (10)
	CreateDynamicObject(19381,2667.0175781,-1831.2716064,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (11)
	CreateDynamicObject(19381,2667.0175781,-1821.6723633,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (12)
	CreateDynamicObject(19381,2667.0175781,-1812.0469971,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (13)
	CreateDynamicObject(19381,2667.0175781,-1802.4526367,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (14)
	CreateDynamicObject(19381,2667.0175781,-1792.8258057,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (15)
	CreateDynamicObject(19381,2667.0175781,-1783.2005615,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (16)
	CreateDynamicObject(19381,2667.0175781,-1773.6247559,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (17)
	CreateDynamicObject(19381,2667.0175781,-1764.0234375,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (18)
	CreateDynamicObject(19381,2667.0175781,-1754.4241943,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (19)
	CreateDynamicObject(19381,2667.0175781,-1744.8063965,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (20)
	CreateDynamicObject(19381,2677.5175781,-1850.5218506,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (21)
	CreateDynamicObject(19381,2688.0185547,-1850.5213623,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (22)
	CreateDynamicObject(19381,2698.4946289,-1850.5206299,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (23)
	CreateDynamicObject(19381,2708.9921875,-1850.5206299,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (24)
	CreateDynamicObject(19381,2719.4135742,-1850.5206299,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (25)
	CreateDynamicObject(19381,2729.8212891,-1850.5206299,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (26)
	CreateDynamicObject(19381,2740.2810059,-1850.5206299,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (27)
	CreateDynamicObject(19381,2748.7773438,-1840.8909912,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (29)
	CreateDynamicObject(19381,2748.7773438,-1831.2563477,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (30)
	CreateDynamicObject(19381,2748.7773438,-1821.6309814,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (31)
	CreateDynamicObject(19381,2748.7773438,-1812.0050049,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (32)
	CreateDynamicObject(19381,2748.7773438,-1802.3797607,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (33)
	CreateDynamicObject(19381,2748.7773438,-1792.7788086,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (34)
	CreateDynamicObject(19381,2748.7773438,-1783.1739502,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (35)
	CreateDynamicObject(19381,2748.7773438,-1773.5745850,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (36)
	CreateDynamicObject(19381,2748.7773438,-1764.0605469,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (37)
	CreateDynamicObject(19381,2748.7773438,-1754.5216064,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (38)
	CreateDynamicObject(19381,2748.7773438,-1744.9449463,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (39)
	CreateDynamicObject(19381,2738.2783203,-1840.9204102,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (41)
	CreateDynamicObject(19381,2738.2783203,-1831.2954102,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (42)
	CreateDynamicObject(19381,2738.2783203,-1821.7186279,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (43)
	CreateDynamicObject(19381,2738.2783203,-1812.0732422,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (44)
	CreateDynamicObject(19381,2738.2783203,-1802.4492188,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (45)
	CreateDynamicObject(19381,2738.2783203,-1792.8245850,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (46)
	CreateDynamicObject(19381,2738.2783203,-1783.2434082,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (47)
	CreateDynamicObject(19381,2738.2783203,-1773.6688232,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (48)
	CreateDynamicObject(19381,2738.2783203,-1764.0689697,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (49)
	CreateDynamicObject(19381,2738.2783203,-1754.4931641,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (50)
	CreateDynamicObject(19381,2738.2783203,-1744.9188232,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (51)
	CreateDynamicObject(19381,2727.7958984,-1840.9266357,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (52)
	CreateDynamicObject(19381,2727.7958984,-1831.3016357,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (53)
	CreateDynamicObject(19381,2727.7958984,-1821.7120361,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (54)
	CreateDynamicObject(19381,2727.7958984,-1812.1231689,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (55)
	CreateDynamicObject(19381,2727.7958984,-1802.4986572,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (56)
	CreateDynamicObject(19381,2727.7958984,-1792.8974609,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (57)
	CreateDynamicObject(19381,2727.7958984,-1783.3470459,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (58)
	CreateDynamicObject(19381,2727.7958984,-1773.7462158,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (59)
	CreateDynamicObject(19381,2727.7958984,-1764.1468506,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (60)
	CreateDynamicObject(19381,2727.7958984,-1754.5463867,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (61)
	CreateDynamicObject(19381,2727.7958984,-1744.9211426,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (62)
	CreateDynamicObject(19381,2717.3154297,-1840.8950195,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (63)
	CreateDynamicObject(19381,2717.3154297,-1831.2947998,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (64)
	CreateDynamicObject(19381,2717.3154297,-1821.6688232,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (65)
	CreateDynamicObject(19381,2717.3154297,-1812.0423584,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (66)
	CreateDynamicObject(19381,2717.3154297,-1802.4670410,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (67)
	CreateDynamicObject(19381,2717.3154297,-1792.8918457,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (68)
	CreateDynamicObject(19381,2717.3154297,-1783.3919678,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (69)
	CreateDynamicObject(19381,2717.3154297,-1773.8420410,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (70)
	CreateDynamicObject(19381,2717.3154297,-1764.3177490,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (71)
	CreateDynamicObject(19381,2717.3154297,-1754.7180176,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (72)
	CreateDynamicObject(19381,2717.3154297,-1745.1186523,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (73)
	CreateDynamicObject(19381,2677.5175781,-1840.9467773,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (74)
	CreateDynamicObject(19381,2677.5175781,-1831.3874512,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (75)
	CreateDynamicObject(19381,2677.5175781,-1821.7491455,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (76)
	CreateDynamicObject(19381,2677.5175781,-1812.2093506,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (77)
	CreateDynamicObject(19381,2677.5175781,-1802.5895996,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (79)
	CreateDynamicObject(19381,2677.5175781,-1793.0200195,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (80)
	CreateDynamicObject(19381,2677.5175781,-1783.4649658,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (81)
	CreateDynamicObject(19381,2677.5175781,-1773.8906250,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (82)
	CreateDynamicObject(19381,2677.5175781,-1764.2856445,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (83)
	CreateDynamicObject(19381,2677.5175781,-1754.7061768,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (84)
	CreateDynamicObject(19381,2677.5175781,-1745.1309814,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (85)
	CreateDynamicObject(19381,2688.0185547,-1840.8953857,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (86)
	CreateDynamicObject(19381,2688.0185547,-1831.2945557,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (87)
	CreateDynamicObject(19381,2688.0185547,-1821.6932373,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (88)
	CreateDynamicObject(19381,2688.0185547,-1812.1180420,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (89)
	CreateDynamicObject(19381,2688.0185547,-1802.5428467,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (90)
	CreateDynamicObject(19381,2688.0185547,-1792.9367676,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (91)
	CreateDynamicObject(19381,2688.0185547,-1783.3155518,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (92)
	CreateDynamicObject(19381,2688.0185547,-1773.7158203,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (93)
	CreateDynamicObject(19381,2688.0185547,-1764.1164551,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (94)
	CreateDynamicObject(19381,2688.0185547,-1754.5156250,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (95)
	CreateDynamicObject(19381,2688.0185547,-1744.9909668,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (96)
	CreateDynamicObject(19381,2698.4941406,-1840.9448242,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (97)
	CreateDynamicObject(19381,2698.4941406,-1831.3149414,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (98)
	CreateDynamicObject(19381,2698.4941406,-1821.7148438,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (99)
	CreateDynamicObject(19381,2698.4941406,-1812.0798340,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (100)
	CreateDynamicObject(19381,2698.4941406,-1802.4543457,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (101)
	CreateDynamicObject(19381,2698.4941406,-1792.9295654,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (102)
	CreateDynamicObject(19381,2698.4941406,-1783.3288574,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (103)
	CreateDynamicObject(19381,2698.4941406,-1773.7036133,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (104)
	CreateDynamicObject(19381,2698.4941406,-1764.1485596,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (105)
	CreateDynamicObject(19381,2698.4941406,-1754.5627441,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (106)
	CreateDynamicObject(19381,2698.4941406,-1744.9326172,821.7355957,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (107)
	CreateDynamicObject(19381,2708.9921875,-1840.9213867,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (109)
	CreateDynamicObject(19381,2708.9921875,-1831.3217773,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (110)
	CreateDynamicObject(19381,2708.9921875,-1821.7822266,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (111)
	CreateDynamicObject(19381,2708.9921875,-1812.2218018,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (112)
	CreateDynamicObject(19381,2708.9921875,-1802.6212158,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (113)
	CreateDynamicObject(19381,2708.9921875,-1793.0209961,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (114)
	CreateDynamicObject(19381,2708.9921875,-1783.4213867,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (115)
	CreateDynamicObject(19381,2708.9921875,-1773.8455811,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (116)
	CreateDynamicObject(19381,2708.9921875,-1764.2703857,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (117)
	CreateDynamicObject(19381,2708.9921875,-1754.6197510,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (118)
	CreateDynamicObject(19381,2708.9921875,-1745.0191650,821.7345886,0.0000000,90.0000000,0.0000000,100); //object(fescape_sfw03) (119)
}
stock LoadTextDraws()
{
    PowerTD[0] = TextDrawCreate(511.000000, 396.000000, "~n~~n~");
	TextDrawBackgroundColor(PowerTD[0], 255);
	TextDrawFont(PowerTD[0], 1);
	TextDrawLetterSize(PowerTD[0], 0.590000, 0.039999);
	TextDrawColor(PowerTD[0], -1);
	TextDrawSetOutline(PowerTD[0], 0);
	TextDrawSetProportional(PowerTD[0], 1);
	TextDrawSetShadow(PowerTD[0], 1);
	TextDrawUseBox(PowerTD[0], 1);
	TextDrawBoxColor(PowerTD[0], 255);
	TextDrawTextSize(PowerTD[0], 592.000000, -10.000000);

	PowerTD[1] = TextDrawCreate(512.000000, 397.000000, "~n~~n~");
	TextDrawBackgroundColor(PowerTD[1], 255);
	TextDrawFont(PowerTD[1], 1);
	TextDrawLetterSize(PowerTD[1], 0.500000, -0.099999);
	TextDrawColor(PowerTD[1], -1);
	TextDrawSetOutline(PowerTD[1], 0);
	TextDrawSetProportional(PowerTD[1], 1);
	TextDrawSetShadow(PowerTD[1], 1);
	TextDrawUseBox(PowerTD[1], 1);
	TextDrawBoxColor(PowerTD[1], 252645375);
	TextDrawTextSize(PowerTD[1], 591.000000, 0.000000);
}
stock LoadPlayerTextDraws(playerid)
{
    pPowerTD[playerid] = CreatePlayerTextDraw(playerid, 512.000000, 397.000000, "~n~~n~");
	PlayerTextDrawBackgroundColor(playerid, pPowerTD[playerid], 255);
	PlayerTextDrawFont(playerid, pPowerTD[playerid], 1);
	PlayerTextDrawLetterSize(playerid, pPowerTD[playerid], 0.500000, -0.099999);
	PlayerTextDrawColor(playerid, pPowerTD[playerid], -1);
	PlayerTextDrawSetOutline(playerid, pPowerTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, pPowerTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pPowerTD[playerid], 1);
	PlayerTextDrawUseBox(playerid, pPowerTD[playerid], 1);
	PlayerTextDrawBoxColor(playerid, pPowerTD[playerid], -1359019777);
	PlayerTextDrawTextSize(playerid, pPowerTD[playerid], 507.000000, 0.000000);
}
forward PowerBar();
public PowerBar()
{
	new tick = GetTickCount(),dif;
	foreach(Player, i)
	{
	    if(pLastTick[i] == -1)
	    {
	        PlayerTextDrawHide(i, pPowerTD[i]);
			TextDrawHideForPlayer(i, PowerTD[0]);
			TextDrawHideForPlayer(i, PowerTD[1]);
			pLastTick[i] = 0;
	    }
	    else if(pLastTick[i])
	    {
			dif = tick - pLastTick[i];
			if(dif > 2000)
			{
			    pLastTick[i] = -1;
			    continue;
			}
			else if(dif > 1000)
			    dif = 2000 - dif;
            PlayerTextDrawTextSize(i, pPowerTD[i], 507.0 + ((84.0 * dif)/1000.0), 0.0);
			PlayerTextDrawShow(i, pPowerTD[i]);
			TextDrawShowForPlayer(i, PowerTD[0]);
			TextDrawShowForPlayer(i, PowerTD[1]);
	    }
	}
	return 1;
}
