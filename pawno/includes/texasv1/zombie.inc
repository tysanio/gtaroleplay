//zombie include
#define MAX_ZOMBIES 250 // change this to whatever number you want
new SpawnedZombies=0, ZombiesTimer,ZombieIsAttack[MAX_PLAYERS];
new z_zombieskin[] = {20012, 20013, 20014, 20015, 20016, 20017, 20018};
script CreateZombies()
{
	new str[50];
	if(SpawnedZombies < MAX_ZOMBIES)
	{
		new thenpc_;
		format(str,sizeof(str),"Zombie[%d]",MAX_PLAYERS-(SpawnedZombies));
		thenpc_ = FCNPC_Create(str);
		FCNPC_Spawn(thenpc_,z_zombieskin[random(sizeof(z_zombieskin))],-2106.8979+random(500)-random(500),51.3692+random(1000)-random(1000),35.1641);
		//FCNPC_Spawn(thenpc_,index,2485.1643+random(5),-1668.8185+random(5),13.3438);//groove
		FCNPC_SetWeapon(thenpc_, 0);
		FCNPC_SetHealth(thenpc_, 100);
		SetTimerEx("ZombieMove",500,true,"d",thenpc_);
		SetPlayerColor(thenpc_,DEFAULT_COLOR);
		SpawnedZombies++;
	}
	else
	{
		KillTimer(ZombiesTimer);
		printf("Zombies creation done!");
	}
	return 1;
}
public FCNPC_OnDeath(npcid, killerid, reason)
{
	ZombieIsAttack[npcid] = 0;
	ApplyAnimation(npcid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
	CallLocalFunction("OnPlayerKillZombie","ii",killerid,npcid);
	PlayerData[killerid][pZombieKill] +=1;
	if (reason == 22)
	{
		switch(random(5))
		{case 0: PlayerData[killerid][pSkill][1] +=1;}
	}
	if (reason == 23)
	{
		switch(random(5))
		{case 1: PlayerData[killerid][pSkill][2] +=1;}
	}
	if (reason == 24)
	{
		switch(random(5))
		{case 2: PlayerData[killerid][pSkill][3] +=1;}
	}
	if (reason == 25)
	{
		switch(random(5))
		{case 3: PlayerData[killerid][pSkill][4] +=1;}
	}
	if (reason == 26)
	{
		switch(random(5))
		{case 4: PlayerData[killerid][pSkill][5] +=1;}
	}
	if (reason == 27)
	{
		switch(random(5))
		{case 0: PlayerData[killerid][pSkill][6] +=1;}
	}
	if (reason == 28 || reason == 32)
	{
		switch(random(5))
		{case 1: PlayerData[killerid][pSkill][7] +=1;}
	}
	if (reason == 29)
	{
		switch(random(5))
		{case 2: PlayerData[killerid][pSkill][8] +=1;}
	}
	if (reason == 30)
	{
		switch(random(5))
		{case 3: PlayerData[killerid][pSkill][9] +=1;}
	}
	if (reason == 31)
	{
		switch(random(5))
		{case 4: PlayerData[killerid][pSkill][10] +=1;}
	}
	Log_Write("logs/zombiekill.txt", "[%s] %s a tué le zombie id : %d avec un %s.", ReturnDate(), ReturnName(killerid), npcid, ReturnWeaponName(reason));
	return 1;
}
public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	if(bodypart == 9) {FCNPC_SetHealth(npcid,0);}
	return 1;
}
script ZombieMove(zombieid)
{
	new Float:xa,Float:ya,Float:za;
	if(FCNPC_IsDead(zombieid)) return 1;
	foreach(Player, playerid)
	{
		GetPlayerPos(playerid,xa,ya,za);
		if(IsPlayerInRangeOfPoint(zombieid,1.0,xa,ya,za))// here playerid not zombieid
		{
			ZombieIsAttack[zombieid] = 2;
			FCNPC_MeleeAttack(zombieid,100);
			FCNPC_SetMinHeightPosCall(zombieid, 0.2);
			break;
		}
		else if(IsPlayerInRangeOfPoint(zombieid,10.0,xa,ya,za))
		{
			if(ZombieIsAttack[zombieid] == 2 || PlayerData[playerid][pInjured] == 1)
			{
				FCNPC_Stop(zombieid);
				FCNPC_StopAttack(zombieid);
			}
			ZombieIsAttack[zombieid] = 1;
			FCNPC_GoTo(zombieid,xa,ya,za,FCNPC_MOVE_TYPE_RUN,0.4, true);
			break;
		}
		else if(IsPlayerInRangeOfPoint(zombieid,25.0,xa,ya,za))
		{
			if(ZombieIsAttack[zombieid] == 2)
			{
				FCNPC_Stop(zombieid);
				FCNPC_StopAttack(zombieid);
			}
			ZombieIsAttack[zombieid] = 1;
			FCNPC_GoToPlayerEx(zombieid, playerid,5,5,FCNPC_MOVE_TYPE_RUN);
			break;
		}
		else
		{
			ZombieIsAttack[zombieid] = 0;
		}
	}
	return 1;
}
stock FCNPC_GoToPlayerEx(npcid, playerid, Float:dist, Float:rangle, movetype = FCNPC_MOVE_TYPE_RUN)
{
	new Float:xa, Float:ya, Float:za, Float:fa;
	GetPlayerPos(playerid, xa, ya, za);
	GetPlayerFacingAngle(playerid, fa);
	rangle += fa;
	xa = (xa + dist * floatsin(-rangle,degrees));
	ya = (ya + dist * floatcos(-rangle,degrees));
    FCNPC_GoTo(npcid,xa,ya,za,movetype,0.4,FCNPC_MOVE_MODE_COLANDREAS);
    return 1;
}
script OnPlayerKillZombie(playerid,zombieid)
{
	new Float:x,Float:y,Float:z;
	FCNPC_GetPosition(zombieid,x,y,z);
	switch(random(50))
	{
		case 49: DropItem("object contamine", "Zombie Kill",1576, 1,x,y,z-1.0, 0,0);
	}
	FCNPC_Respawn(zombieid);
	return 1;
}
public FCNPC_OnRespawn(npcid)
{
	FCNPC_SetWeapon(npcid,0);
	FCNPC_ApplyAnimation(npcid, "PED", "WALK_DRUNK", 4.1, 1, 1,  1,  0,  0);
	FCNPC_SetAmmo(npcid,1);
	FCNPC_Stop(npcid);
	FCNPC_StopAttack(npcid);
	FCNPC_SetMinHeightPosCall(npcid, 0.2);
	FCNPC_SetPosition(npcid,-2106.8979+random(500)-random(500),51.3692+random(1000)-random(1000),35.1641+FCNPC_GetMinHeightPosCall(npcid));
	//FCNPC_SetPosition(npcid,2485.1643+random(10),-1668.8185+random(10),13.3438);//groove
	return 1;
}
//code de radiation a LV
script PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
		{
			return 1;
		}
	}
	return 0;
}
script UpdateRadiation()
{
	foreach (new i : Player)
   	{
   	    new Float:Vie;
		if(IsPlayerConnected(i) && PlayerData[i][pAdminDuty] == 0 && PlayerData[i][pPrisoned] == 0)
		{
			if(PlayerToPoint(1090.0, i,1915,1790,10.5048))
			{
				GetPlayerHealth(i,Vie);
				SetPlayerHealth(i,Vie-2);
		    	GameTextForPlayer(i,"~r~Zone de radiation",5000,3);
		    	new rand2 = random(10);
				PlayerData[i][pMalade] += rand2;
			}
			if(PlayerData[i][pInterior] > 0)
			{ /*rien a mettre la dedans*/ }
		}
	}
}
//skill set
script skill_set(playerid)
{
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, PlayerData[playerid][pSkill][1]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, PlayerData[playerid][pSkill][2]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, PlayerData[playerid][pSkill][3]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, PlayerData[playerid][pSkill][4]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, PlayerData[playerid][pSkill][5]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, PlayerData[playerid][pSkill][6]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, PlayerData[playerid][pSkill][7]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, PlayerData[playerid][pSkill][8]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, PlayerData[playerid][pSkill][9]);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, PlayerData[playerid][pSkill][10]);
	return false;
}
CMD:zkill(playerid,params[])
{
	SendServerMessage(playerid,"Zombies tuer : %s",PlayerData[playerid][pZombieKill]);
	return 1;
}