#define BULLET_HIT_PETROL_TANK 0
#define BULLET_HIT_LEFT_FRONT_WHEEL 1
#define BULLET_HIT_RIGHT_FRONT_WHEEL 2
#define BULLET_HIT_LEFT_BACK_WHEEL 3
#define BULLET_HIT_RIGHT_BACK_WHEEL 4
#define BULLET_HIT_BODY 5

#define VEHICLE_RIGHT_BACK_WHEEL 0
#define VEHICLE_RIGHT_FRONT_WHEEL 1
#define VEHICLE_LEFT_BACK_WHEEL 2
#define VEHICLE_LEFT_FRONT_WHEEL 3

new VehicleTire[MAX_VEHICLES][4];
new EnableVehicleDamageVar=0;
new EnablePetrolCapExplosionVar=0;
new EnableWheelTirePopVar=0;
enum WS_info
{
	Float:WS_Damage
}
new WeaponShotInfo[17][WS_info] = {
	{25.0},
	{40.0},
	{70.0},
	{10.0},
	{10.0},
	{15.0},
	{20.0},
	{25.0},
	{30.0},
	{30.0},
	{20.0},
	{75.0},
	{125.0},
	{75.0},//Not Working Yet
	{75.0},//Not Working Yet
	{25.0},//Not Working Yet
	{140.0}
};

enum VS_info
{
	Float:VS_PetrolX,
	Float:VS_PetrolY,
	Float:VS_PetrolZ
}



new VehicleShotInfo[212][VS_info] = {
	{-1.06,-2.07,-0.03},
	{1.25,-0.91,0.05},
	{1.11,-1.92,0.17},
	{-1.46,0.02,-0.66},
	{-1.03,-2.37,0.06},
	{-0.86,-2.16,-0.08},
	{0.00,0.00,0.00},
	{-1.07,-3.74,-0.42},
	{-1.46,1.24,-0.57},
	{-1.04,-2.82,0.14},
	{-0.96,-1.66,0.23},
	{1.06,-2.10,0.09},
	{0.00,0.00,0.00},
	{-0.46,0.53,-0.79},
	{-0.66,-0.71,-0.70},
	{-1.07,-2.06,0.05},
	{-1.16,-2.72,-0.21},
	{0.00,0.00,0.00},
	{-1.24,-1.76,0.03},
	{-1.09,-1.99,0.06},
	{-1.03,-2.14,0.08},
	{-1.02,-2.43,-0.14},
	{-0.93,-0.41,-0.19},
	{-1.13,-1.90,-0.28},
	{-1.11,-0.54,-0.10},
	{0.00,0.00,0.00},
	{-1.00,-2.16,0.06},
	{-1.27,-3.18,-0.18},
	{-1.01,-2.65,-0.56},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.32,-5.47,-0.12},
	{0.00,0.00,0.00},
	{-1.51,0.15,-0.67},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.02,-1.81,0.16},
	{-1.24,-4.98,-0.51},
	{-1.06,-1.93,-0.00},
	{-1.07,-1.50,0.07},
	{-0.89,-0.47,-0.46},
	{0.00,0.00,0.00},
	{-1.17,-2.20,0.08},
	{-1.24,1.25,-0.91},
	{0.00,0.00,0.00},
	{-1.07,-1.95,0.13},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{1.08,-1.21,-0.03},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.52,0.00,-0.74},
	{0.73,-0.05,-0.59},
	{0.00,0.00,0.00},
	{-1.11,-2.04,-0.09},
	{-0.97,-2.30,0.21},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-0.25,0.20,-0.17},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-0.92,-2.30,0.08},
	{-0.07,0.17,0.69},
	{0.00,0.00,0.00},
	{-1.17,-2.37,0.24},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.09,-1.60,0.13},
	{0.00,0.00,0.00},
	{-1.03,-1.52,0.15},
	{1.01,-0.33,0.23},
	{-1.09,-1.98,0.09},
	{-1.12,-0.88,0.14},
	{0.00,0.00,0.00},
	{1.03,-2.26,0.00},
	{0.80,-2.50,-0.05},
	{0.00,0.00,0.00},
	{-0.88,0.71,0.03},
	{-0.66,-3.17,0.58},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{1.22,-0.74,0.02},
	{0.00,0.00,0.00},
	{-1.05,-2.18,0.02},
	{-1.07,-2.09,0.17},
	{0.00,0.00,0.00},
	{-1.00,-2.20,0.14},
	{1.16,-1.91,-0.11},
	{1.08,-1.83,0.15},
	{0.00,0.00,0.00},
	{-1.21,-0.01,0.09},
	{-1.19,-1.09,-0.31},
	{-0.91,-1.70,-0.06},
	{0.00,0.00,0.00},
	{-0.96,-1.88,0.13},
	{-0.98,-2.03,0.04},
	{-1.14,-1.82,0.13},
	{1.22,-0.74,0.00},
	{0.96,-1.11,-0.11},
	{-1.08,-2.30,0.08},
	{-1.35,-3.05,-0.67},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.50,-0.88,-0.24},
	{-1.08,0.51,-1.43},
	{-1.13,-2.44,-0.01},
	{-1.11,-1.95,0.08},
	{1.09,-2.19,-0.08},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-0.17,0.13,0.52},
	{-0.14,0.18,0.53},
	{-0.18,0.24,0.49},
	{1.24,0.46,-1.06},
	{-1.31,-0.50,-0.07},
	{-0.94,-1.94,0.05},
	{-1.13,-1.70,0.16},
	{-0.51,-2.07,0.01},
	{-1.15,-2.20,0.22},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,-2.43,-0.91},
	{0.91,-1.97,0.11},
	{-1.01,-0.83,-0.20},
	{-1.13,-0.55,0.28},
	{-0.98,-1.69,0.06},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.23,-2.51,-0.03},
	{0.00,0.00,0.00},
	{-0.97,-1.92,0.31},
	{-0.96,-0.94,-0.01},
	{-1.15,2.04,0.32},
	{0.00,0.00,0.00},
	{1.22,-1.99,0.16},
	{-1.09,-2.00,0.13},
	{0.00,0.00,0.00},
	{-0.89,-1.14,0.18},
	{-1.10,-2.40,-0.02},
	{-1.03,-2.66,0.07},
	{-0.95,-0.94,0.45},
	{0.00,0.00,0.00},
	{1.27,-2.37,0.13},
	{-0.80,-1.47,0.17},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-0.84,-1.92,0.23},
	{-1.01,-1.76,0.25},
	{0.98,-1.83,0.20},
	{1.13,-2.28,0.11},
	{0.93,-0.71,0.05},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.95,-0.86,0.09},
	{1.18,-2.26,0.06},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.62,-0.37,0.46},
	{-0.35,-1.03,0.24},
	{0.00,0.00,0.00},
	{-0.59,-0.94,0.26},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.33,2.89,-0.02},
	{1.13,-2.29,0.16},
	{1.23,-1.77,0.29},
	{-0.22,0.01,0.54},
	{-0.90,0.15,-0.32},
	{-0.62,0.37,-0.12},
	{0.00,0.00,0.00},
	{1.07,-2.29,0.20},
	{0.00,0.00,0.00},
	{-1.22,-1.21,0.12},
	{-1.20,-2.12,0.23},
	{0.98,-0.89,0.10},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-0.97,-2.16,0.06},
	{-1.02,-2.16,0.07},
	{-1.08,-1.95,0.18},
	{0.00,0.00,0.00},
	{0.95,-2.01,0.06},
	{-1.36,-1.69,0.92},
	{0.97,-1.95,0.08},
	{1.24,-2.20,-0.04},
	{0.00,0.00,0.00},
	{-0.95,-0.93,-0.02},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00},
	{-1.26,-0.03,0.09},
	{0.00,0.00,0.00},
	{0.00,0.00,0.00}
};



forward OnPlayerShootVehiclePart(playerid, weaponid, vehicleid,hittype);

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    switch(hittype)
    {
        case BULLET_HIT_TYPE_VEHICLE:
        {
            new Float:fSet[9];
			new modelid = GetVehicleModel(hitid);
			GetVehicleModelInfo(modelid, VEHICLE_MODEL_INFO_PETROLCAP,fSet[0], fSet[1], fSet[2]);
			GetVehicleModelInfo(modelid, VEHICLE_MODEL_INFO_WHEELSFRONT, fSet[3], fSet[4], fSet[5]);
            GetVehicleModelInfo(modelid, VEHICLE_MODEL_INFO_WHEELSREAR,  fSet[6], fSet[7], fSet[8]);
			if(fX >= VehicleShotInfo[modelid-400][VS_PetrolX]-0.15 && fX <= VehicleShotInfo[modelid-400][VS_PetrolX]+0.15 && fY >= VehicleShotInfo[modelid-400][VS_PetrolY]-0.15 && fY <= VehicleShotInfo[modelid-400][VS_PetrolY]+0.15 && fZ >= VehicleShotInfo[modelid-400][VS_PetrolZ]-0.15 && fZ <= VehicleShotInfo[modelid-400][VS_PetrolZ]+0.15)
			{
				if(EnablePetrolCapExplosionVar==1)
				{
					new Float:vPosx,Float:vPosy,Float:vPosz;
					GetVehiclePos(hitid, vPosx,vPosy,vPosz);
					CreateExplosion(vPosx,vPosy,vPosz, 3, 30.0);
					SetVehicleToRespawn(hitid);
				}
				CallLocalFunction("OnPlayerShootVehiclePart", "iiii", playerid, weaponid, hitid,BULLET_HIT_PETROL_TANK);
			}
			else if(fX >= fSet[3]-2.4 && fX <= fSet[3] && fY >= fSet[4]-0.4 && fY <= fSet[4]+0.4 && fZ >= fSet[5]-0.4 && fZ <= fSet[5]+0.4)
			{
				if(EnableWheelTirePopVar==1)
				{
					if(GetVehicleTireStatus(hitid,VEHICLE_LEFT_FRONT_WHEEL)==0)
					{
						SetVehicleTireStatus(hitid,VEHICLE_LEFT_FRONT_WHEEL);
					}
					//else SendClientMessage(playerid,-1,"This tire is already popped!");
				}
				CallLocalFunction("OnPlayerShootVehiclePart", "iiii", playerid, weaponid, hitid,BULLET_HIT_LEFT_FRONT_WHEEL);
			}
			else if(fX >= fSet[3]-0.4 && fX <= fSet[3]+0.4 && fY >= fSet[4]-0.4 && fY <= fSet[4]+0.4 && fZ >= fSet[5]-0.4 && fZ <= fSet[5]+0.4)
			{
				if(EnableWheelTirePopVar==1)
				{
					if(GetVehicleTireStatus(hitid,VEHICLE_RIGHT_FRONT_WHEEL)==0)
					{
						SetVehicleTireStatus(hitid,VEHICLE_RIGHT_FRONT_WHEEL);
					}
					//else SendClientMessage(playerid,-1,"This tire is already popped!");
				}
				CallLocalFunction("OnPlayerShootVehiclePart", "iiii", playerid, weaponid, hitid,BULLET_HIT_RIGHT_FRONT_WHEEL);
			}
			else if(fX >= fSet[6]-2.4 && fX <= fSet[6] && fY >= fSet[7]-0.4 && fY <= fSet[7]+0.4 && fZ >= fSet[8]-0.4 && fZ <= fSet[8]+0.4)
			{
				if(EnableWheelTirePopVar==1)
				{
					if(GetVehicleTireStatus(hitid,VEHICLE_LEFT_BACK_WHEEL)==0)
					{
						SetVehicleTireStatus(hitid,VEHICLE_LEFT_BACK_WHEEL);
					}
					//else SendClientMessage(playerid,-1,"This tire is already popped!");
				}
				CallLocalFunction("OnPlayerShootVehiclePart", "iiii", playerid, weaponid, hitid,BULLET_HIT_LEFT_BACK_WHEEL);
			}
			else if(fX >= fSet[6]-0.4 && fX <= fSet[6]+0.4 && fY >= fSet[7]-0.4 && fY <= fSet[7]+0.4 && fZ >= fSet[8]-0.4 && fZ <= fSet[8]+0.4)
			{
				if(EnableWheelTirePopVar==1)
				{
					if(GetVehicleTireStatus(hitid,VEHICLE_RIGHT_BACK_WHEEL)==0)
					{
						SetVehicleTireStatus(hitid,VEHICLE_RIGHT_BACK_WHEEL);
					}
					//else SendClientMessage(playerid,-1,"This tire is already popped!");
				}
				CallLocalFunction("OnPlayerShootVehiclePart", "iiii", playerid, weaponid, hitid,BULLET_HIT_RIGHT_BACK_WHEEL);
			}
			if(EnableVehicleDamageVar==1)
			{
				if(IsVehicleOccupied(hitid)==0)
				{
					new Float:vHP;
					GetVehicleHealth(hitid,vHP);
					SetVehicleHealth(hitid,vHP-WeaponShotInfo[GetPlayerWeapon(playerid)-22][WS_Damage]);
				}
			}
			CallLocalFunction("OnPlayerShootVehiclePart", "iiii", playerid, weaponid, hitid,BULLET_HIT_BODY);
        }
    }
	#if defined hook_OnPlayerWeaponShot
        hook_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
    #endif
	return 1;
}

#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot  
#else
    #define _ALS_OnPlayerWeaponShot
#endif

#define OnPlayerWeaponShot hook_OnPlayerWeaponShot

#if defined hook_OnPlayerWeaponShot
    forward hook_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

public OnVehicleSpawn(vehicleid)
{
	VehicleTire[vehicleid][0]=0;
	VehicleTire[vehicleid][1]=0;
	VehicleTire[vehicleid][2]=0;
	VehicleTire[vehicleid][3]=0;
	#if defined hook_OnVehicleSpawn
        hook_OnVehicleSpawn(vehicleid);
    #endif
	return 1;
}

#if defined _ALS_OnVehicleSpawn 
#undef OnVehicleSpawn  
#else 
#define _ALS_OnVehicleSpawn 
#endif 
#define OnVehicleSpawn hook_OnVehicleSpawn

#if defined hook_OnVehicleSpawn
    forward hook_OnVehicleSpawn(vehicleid);
#endif

stock SetVehicleTireStatus(vehicleid,tire)
{
	VehicleTire[vehicleid][tire]=1;
	new panels, doors, lights, tires;
	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	tires=encode_tires(GetVehicleTireStatus(vehicleid,0), GetVehicleTireStatus(vehicleid,1), GetVehicleTireStatus(vehicleid,2), GetVehicleTireStatus(vehicleid,3));
	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
	return 1;
}

stock GetVehicleTireStatus(vehicleid,tire)
{
	if(VehicleTire[vehicleid][tire]==1)
	{
		return 1;
	}
	return 0;
}

forward HasPetrolCap(vid);
public HasPetrolCap(vid)
{
	new modelid = GetVehicleModel(vid);
	switch(modelid)
	{
		case 400,401,402,403,404,405,407,408,409,410,411,413,414,415,416,418,419,420,421,422,423,424,426,427,428,431,433,436,437,438,439,440,442,443,445,451,455,456,458,459,463,467,468,470,475,477,478,479,480,482,483,485,486,489,491,492,494,495,496,498,499:
		{
			return 1;
		}
		case 500,502,503,504,505,506,507,508,514,515,516,517,518,521,522,523,524,525,526,527,528,529,532,533,534,535,536,540,542,543,544,546,547,539,550,551,552,554,555,558,559,560,561,562,565,566,571,572,574,578,579,580,581,582,583,585,587,588,589,596,597,598,600,601,602,603,605,609:
		{
			return 1;
		}
	}
	return 0;
}
encode_tires(tire1, tire2, tire3, tire4) return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);

stock EnableVehicleDamage(toggle)
{
	if(toggle==1)EnableVehicleDamageVar=1;
	else EnableVehicleDamageVar=0;
}

stock EnableVehiclePetrolCapExplosion(toggle)
{
	if(toggle==1)EnablePetrolCapExplosionVar=1;
	else EnablePetrolCapExplosionVar=0;
}

stock EnableVehicleWheelTirePop(toggle)
{
	if(toggle==1){EnableWheelTirePopVar=1;}
	else EnableWheelTirePopVar=0;
}

stock ToggleVehicleDamage()
{
	if(EnableVehicleDamageVar==0)EnableVehicleDamageVar=1;
	else EnableVehicleDamageVar=0;
}

stock ToggleVehiclePetrolCapExplosion()
{
	if(EnablePetrolCapExplosionVar==0)EnablePetrolCapExplosionVar=1;
	else EnablePetrolCapExplosionVar=0;
}

stock ToggleVehicleWheelTirePop()
{
	if(EnableWheelTirePopVar==0){EnableWheelTirePopVar=1;}
	else EnableWheelTirePopVar=0;
}

stock IsVehicleOccupied( vehicleid )
{
    for( new i = 0; i < MAX_PLAYERS; i++ )
    {
        if( IsPlayerConnected( i ) )
        {
            if( IsPlayerInVehicle( i, vehicleid ) ) return 1;
        }
    }
    return 0;
}