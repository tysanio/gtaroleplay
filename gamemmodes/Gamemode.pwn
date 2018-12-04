/*   a faire

skin changer au shop de linge
version admins des commandes
 
 a continuer
continuer le foutue systeme de vehicule sinon en faire un pour creer les vehicules direct

a vérifier :
le style d'intro du serveur
le /restart que le temps saffiche pas
*/
// INCLUDES
#include <a_samp>
#include <a_mysql>
#include <foreach>
#include <easyDialog>
#include <sscanf2>
#include <zcmd>
#include <streamer>
#include <custom/callbacks>
#include <custom/GrimCasino>
#include <dini>

#include "../include/gl_common.inc"
#include "../include/gl_spawns.inc"
// CONNECTION
#define         SQL_HOST	"localhost"
#define         SQL_USER    "root"
#define         SQL_PASS    ""
#define         SQL_DB      "aaz"

//Information serveur
#define SERVER_NAME 	 														"Test Gamemode A a Z" //pour le nom du serveur
#define SERVER_URL 		 														"----------"
#define SERVER_REVISION  														"Build 0.01"
#define LANGUAGE																"Français"
#define PASSWORD																"0" // a mettre 0 pour pas de mot de passe

//gamble
#define GAMBLE_WAGER		10
#define REWARD_DOUBLEBAR	800
#define REWARD_BAR			500
#define REWARD_BELL			400
#define REWARD_CHERRY		300
#define REWARD_GRAPES		200
#define REWARD_SIXTYNINE	100

//SHORTCUTS
#define SCM SendClientMessageEx
#define script%0(%1) forward%0(%1); public%0(%1)

//max something
#define MAX_REPORTS         24
#define MAX_DYNAMIC_CARS	5000

//COLORS
#define COLOR_WHITE 		0xFFFFFFFF
#define COLOR_SERVER		0xA9C4E4FF
#define COLOR_GREY			0xAFAFAFAA
#define COLOR_PURPLE      	0xD0AEEBBB
#define COLOR_CLIENT      	0xAAC4E5BB
#define COLOR_LIME        	0x00FF00BB
#define COLOR_LIGHTRED    	0xFF6347BB
#define COLOR_PINK 			0xFFC0CBAA
#define COLOR_ADMINCHAT		0x33EE33BB

//sendclientmessage spec
#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ERREUR]:{FFFFFF} "%1)
#define SendSyntaxMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_GREY, "[SYNTAX]:{FFFFFF} "%1)
#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_SERVER, "[SERVEUR]:{FFFFFF} "%1)
#define SendAdminAction(%0,%1) \
	SendClientMessageEx(%0, COLOR_ADMINCHAT, "[ADMIN]:{FFFFFF} "%1)
	
// VARIABLES
native WP_Hash(buffer[], len, const str[]);
#define HashingPassword WP_Hash

new str1[256];

static mysql;
new LoginSeconds[MAX_PLAYERS], LoginTimer[MAX_PLAYERS];
native IsValidVehicle(vehicleid);
// ENUMS
enum InformationAccount {
	pID,
	pPassword[256],
	pLogged,
	pLevel,
	pMoney,
	Float:pVie,
	Float:pArmure,
	pSauvegarde,
	Float:PXX,
	Float:PYY,
	Float:PZZ,
	pLoopAnim,
	pShowFooter,
	pFooterTimer,
	pAdmin,
	pSkin,
	pInterior,
	pWorld,
	pSpectator,
	pKicked,
	pSpamCount,
	pMuted,
	pMuteTime,
	pFreeze,
	pFreezeTimer,
	pReportTime
}
new PlayerInfo[MAX_PLAYERS][InformationAccount];
enum td {Text:TDSpeedClock[15]}
new TextDraws[td];
new Text:TextDrawsd[MAX_PLAYERS][4];
new Text:gServerTextdraws[2];
new g_ServerRestart;
new g_RestartTime;
//pickup
new save[2];
//armes
new	gPlayerWeapons[MAX_PLAYERS][13][2];
//slotmachine
new LeftSpinner;
new MiddleSpinner;
new RightSpinner;
new GamblingMachine;
new Float:ZOff = 0.0005;
new PreSpinTimer;
new SymbolSL,SymbolSM,SymbolSR;
new Float:pX, Float:pY, Float:pZ;
new Text3D:GambleLabel[22];
new Float:Rotations[18] = {0.0, 20.0, 40.0, 60.0, 80.0, 100.0, 120.0, 140.0, 160.0, 180.0, 200.0, 220.0, 240.0, 260.0, 280.0, 300.0, 320.0, 340.0};
new ResultIDsLeft[18] = {2, 3, 1, 4, 6, 5, 6, 5, 4, 3, 4, 1, 6, 5, 3, 5, 4, 6};
new ResultIDsMiddle[18] = {3, 4, 6, 5, 2, 4, 5, 6, 4, 1, 5, 3, 6, 1, 6, 3, 4, 5};
new ResultIDsRight[18] = {5, 6, 3, 4, 5, 4, 3, 5, 6, 1, 2, 6, 4, 3, 5, 1, 4, 6};
new ResultNames[][] =
{
	"ld_slot:bar1_o",
	"ld_slot:bar2_o",
	"ld_slot:r_69",
	"ld_slot:bell",
	"ld_slot:grapes",
	"ld_slot:cherry"
};
new bool:IsGambling[MAX_PLAYERS];
new bool:movedup = false;
new bool:IsSpinning[MAX_PLAYERS] = false;
new Float:BanditLocs[22][4] =
{
    {2218.6675,1617.8453,1006.1818},
    {2218.6365,1615.4679,1006.1797},
    {2218.6467,1613.5095,1006.1797},
    {2221.9204,1603.9452,1006.1797},
    {2219.9626,1603.9191,1006.1797},
    {2218.2646,1603.9263,1006.1797},
    {2216.3064,1603.8970,1006.1819},
    {2218.6538,1593.6243,1006.1797},
    {2218.6699,1591.6659,1006.1859},
    {2218.6367,1589.3187,1006.1841},
    {2218.6531,1587.3612,1006.1827},
    {2255.1624,1608.8839,1006.1860},
    {2255.1670,1610.8419,1006.1797},
    {2255.1726,1612.9315,1006.1797},
    {2255.1494,1614.8890,1006.1797},
    {2255.1453,1616.8290,1006.1797},
    {2255.1399,1618.7893,1006.1797},
    {2268.5322,1606.6649,1006.1797},
    {2270.4905,1606.6846,1006.1797},
    {2272.5798,1606.6464,1006.1797},
    {2274.5374,1606.6764,1006.1797},
    {2218.6458,1619.8035,1006.1794}
};
enum tDraws
{
    Text:Textdraw0,Text:Textdraw1,Text:Textdraw2,
	Text:Textdraw3,Text:Textdraw4,Text:Textdraw5,
	Text:Textdraw6,Text:Textdraw7,Text:Textdraw8,
	Text:Textdraw9,Text:Textdraw10,Text:Textdraw11,
	Text:Textdraw12,Text:Textdraw13,Text:Textdraw14,
	Text:Textdraw15,Text:Textdraw16,Text:Textdraw17,
	Text:Textdraw18,Text:Textdraw19,Text:Textdraw20,
	Text:Textdraw21,Text:Textdraw22,Text:Textdraw23,
	Text:Textdraw24,Text:Textdraw25,Text:Textdraw26,
	Text:Textdraw27,Text:Textdraw28,Text:Textdraw29,
	Text:Textdraw30,Text:Textdraw31,Text:Textdraw32,
	Text:Textdraw33,Text:Textdraw34,Text:Textdraw35,
	Text:Textdraw36,Text:Textdraw37,Text:Textdraw38,
	TotalWon,
	TotalPaid,
	TotalTotal
}
new PlayerEnum[MAX_PLAYERS][tDraws];
//tuning
new spoiler[20][0] = {
	{1000},{1001},{1002},
	{1003},{1014},{1015},
	{1016},{1023},{1058},
	{1060},{1049},{1050},
	{1138},{1139},{1146},
	{1147},{1158},{1162},
	{1163},{1164}
};
new nitro[3][0] = {
    {1008},{1009},{1010}
};
new fbumper[23][0] = {
    {1117},{1152},{1153},
    {1155},{1157},{1160},
    {1165},{1167},{1169},
    {1170},{1171},{1172},
    {1173},{1174},{1175},
    {1179},{1181},{1182},
    {1185},{1188},{1189},
    {1192},{1193}
};
new rbumper[22][0] = {
    {1140},{1141},{1148},
    {1149},{1150},{1151},
    {1154},{1156},{1159},
    {1161},{1166},{1168},
    {1176},{1177},{1178},
    {1180},{1183},{1184},
    {1186},{1187},{1190},
    {1191}
};
new exhaust[28][0] = {
    {1018},{1019},{1020},
    {1021},{1022},{1028},
    {1029},{1037},{1043},
    {1044},{1045},{1046},
    {1059},{1064},{1065},
    {1066},{1089},{1092},
    {1104},{1105},{1113},
    {1114},{1126},{1127},
    {1129},{1132},{1135},
    {1136}
};
new bventr[2][0] = {
    {1042},{1044}
};
new bventl[2][0] = {
    {1043},{1045}
};
new bscoop[4][0] = {
	{1004},{1005},{1011},{1012}
};
new rscoop[13][0] = {
    {1006},{1032},{1033},
    {1035},{1038},{1053},
    {1054},{1055},{1061},
    {1067},{1068},{1088},
    {1091}
};
new lskirt[21][0] = {
    {1007},{1026},{1031},
    {1036},{1039},{1042},
    {1047},{1048},{1056},
    {1057},{1069},{1070},
    {1090},{1093},{1106},
    {1108},{1118},{1119},
    {1133},{1122},{1134}
};
new rskirt[21][0] = {
    {1017},{1027},{1030},
    {1040},{1041},{1051},
    {1052},{1062},{1063},
    {1071},{1072},{1094},
    {1095},{1099},{1101},
    {1102},{1107},{1120},
    {1121},{1124},{1137}
};
new hydraulics[1][0] = {
    {1087}
};
new base[1][0] = {
    {1086}
};
new rbbars[2][0] = {
    {1109},{1110}
};
new fbbars[2][0] = {
    {1115},{1116}
};
new wheels[17][0] = {
    {1025},{1073},{1074},
    {1075},{1076},{1077},
    {1078},{1079},{1080},
    {1081},{1082},{1083},
    {1084},{1085},{1096},
    {1097},{1098}
};
new lights1[2][0] = {
	{1013},{1024}
};
enum tInfo
{
	carid,
	mod1,
	mod2,
	mod3,
	mod4,
	mod5,
	mod6,
	mod7,
	mod8,
	mod9,
	mod10,
	mod11,
	mod12,
	mod13,
	mod14,
	mod15,
	mod16,
	mod17,
	paintjob,
	colorA,
	colorB,
}
new TuneCar[MAX_VEHICLES][tInfo];
enum reportData {
	rExists,
	rType,
	rPlayer,
	rText[128 char]
};
new ReportData[MAX_REPORTS][reportData];
// 0 forward plzzzzz
main() {}
script Connectionafaire()
{
    mysql = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
	if(mysql_errno(mysql) == 0)
	{
	    printf("SQL: Mysql ON", SQL_DB);
	}
	else
	{
   		printf("SQL: %s ne peut se connecté a %s sur %s.", SQL_USER, SQL_DB, SQL_HOST);
  		SendRconCommand("exit");
	}
	return 1;
}
script LoadAccountInfo(playerid)
{
	PlayerInfo[playerid][pID] = cache_get_field_content_int(0, "ID");
	PlayerInfo[playerid][pLevel] =	cache_get_field_content_int(0, "Level");
	PlayerInfo[playerid][pMoney] =	cache_get_field_content_int(0, "Money");
	PlayerInfo[playerid][pVie] =	cache_get_field_content_int(0, "Vie");
	PlayerInfo[playerid][pArmure] =	cache_get_field_content_int(0, "Armure");
	PlayerInfo[playerid][pSauvegarde] =	cache_get_field_content_int(0, "Sauvegarde");
	PlayerInfo[playerid][PXX] =	cache_get_field_content_float(0, "PXX");
	PlayerInfo[playerid][PYY] =	cache_get_field_content_float(0, "PYY");
	PlayerInfo[playerid][PZZ] =	cache_get_field_content_float(0, "PZZ");
	PlayerInfo[playerid][pAdmin] =	cache_get_field_content_int(0, "Admin");
	PlayerInfo[playerid][pSkin] =	cache_get_field_content_int(0, "Skin");
	PlayerInfo[playerid][pInterior] =	cache_get_field_content_int(0, "Interior");
	PlayerInfo[playerid][pWorld] =	cache_get_field_content_int(0, "World");
	PlayerInfo[playerid][pMuted] =	cache_get_field_content_int(0, "Mute");
	cache_get_field_content(0, "Password", PlayerInfo[playerid][pPassword], mysql, 256);
	TogglePlayerSpectating(playerid, 0);
	//ResetPlayerWeapons(playerid);
	CC(playerid, 5);
	format(str1, sizeof(str1), "SERVEUR: {FFFFFF}Votre compte est de niveau %d.", PlayerInfo[playerid][pLevel]);
	SCM(playerid, COLOR_SERVER, str1);
	PlayerInfo[playerid][pLogged] = 1;
	//arme
	new szTmp[64];
    for(new i = 0; i <= 12; i++)
	{
	    format(szTmp, sizeof(szTmp), "Gun%d", i);
	    gPlayerWeapons[playerid][i][0] = cache_get_field_content_int(0 , szTmp);

    	format(szTmp, sizeof(szTmp), "Ammo%d", i);
    	gPlayerWeapons[playerid][i][1] = cache_get_field_content_int(0 , szTmp);
	}
}
script RegisterAccountInfo(playerid)
{
	PlayerInfo[playerid][pID] = cache_insert_id();
	PlayerInfo[playerid][pLevel] = 1;
	PlayerInfo[playerid][pMoney] = 1000;
	PlayerInfo[playerid][pVie] = 100;
	PlayerInfo[playerid][pArmure] = 0;
	PlayerInfo[playerid][pSauvegarde] = -1;
	GivePlayerMoney(playerid,PlayerInfo[playerid][pMoney]);
	TogglePlayerSpectating(playerid, 0);
	ResetPlayerWeapons(playerid);
	CC(playerid, 5);
	format(str1, sizeof(str1), "SERVEUR: {FFFFFF}ce compte %s est enregistré", ReturnName(playerid, 0));
	SCM(playerid, COLOR_SERVER, str1);
	PlayerInfo[playerid][pLogged] = 1;
}

script SaveAccountInfo(playerid)
{
	if(PlayerInfo[playerid][pLogged] == 0) return 1;
	new tmpPlayerWeapons[13][2],tmpString[64],query[900];
	//arme
    for(new i = 0; i <= 12; i++)
	{
	    GetPlayerWeaponData(playerid, i, tmpPlayerWeapons[i][0], tmpPlayerWeapons[i][1]);
	}
	//vie armure pos
	GetPlayerHealth(playerid,PlayerInfo[playerid][pVie]);
	GetPlayerArmour(playerid,PlayerInfo[playerid][pArmure]);
	GetPlayerPos(playerid,PlayerInfo[playerid][PXX],PlayerInfo[playerid][PYY],PlayerInfo[playerid][PZZ]);
	//sql
	format(query, sizeof(query), "UPDATE `Accounts` SET `Level` = '%d'",PlayerInfo[playerid][pLevel]);
	format(query, sizeof(query), "%s, `Money` = '%d',`Vie` = '%.4f',`Armure` = '%.4f',`Sauvegarde` = '%d',`PXX` = '%.4f',`PYY` = '%.4f',`PZZ` = '%.4f',`Admin` = '%d',`Skin` = '%d',`Interior` = '%d',`World` = '%d',`Mute` = '%d' WHERE `ID` = '%d'",
	query,
	PlayerInfo[playerid][pMoney],
	PlayerInfo[playerid][pVie],
	PlayerInfo[playerid][pArmure],
	PlayerInfo[playerid][pSauvegarde],
	PlayerInfo[playerid][PXX],
	PlayerInfo[playerid][PYY],
	PlayerInfo[playerid][PZZ],
	PlayerInfo[playerid][pAdmin],
	PlayerInfo[playerid][pSkin],
	PlayerInfo[playerid][pInterior],
	PlayerInfo[playerid][pWorld],
	PlayerInfo[playerid][pMuted],
	PlayerInfo[playerid][pID]);
	mysql_tquery(mysql, query, "", "");
	for(new i = 0; i <= 12; i++)
	{
	    format(tmpString, sizeof(tmpString), "Gun%d", i);
    	mysql_format(mysql, query, sizeof(query), "UPDATE `Accounts` SET `%s`=%d WHERE `ID`=%d" ,tmpString , tmpPlayerWeapons[i][0] , PlayerInfo[playerid][pID]);
    	mysql_tquery(mysql, query, "", "");
    	format(tmpString, sizeof(tmpString), "Ammo%d", i);
    	mysql_format(mysql, query, sizeof(query), "UPDATE `Accounts` SET `%s`=%d WHERE `ID`=%d" ,tmpString , tmpPlayerWeapons[i][1] , PlayerInfo[playerid][pID]);
    	mysql_tquery(mysql, query, "", "");
	}
	return 1;
}
public OnPlayerUpdate(playerid)
{
    new Float:health,Float:armour;
    GetPlayerHealth(playerid,health);
    GetPlayerArmour(playerid,armour);
    if (health >= 100.0) {SetPlayerHealth(playerid, 100.0);}
    if (armour >= 100.0) {SetPlayerArmour(playerid, 100.0);}
	if(GetPlayerWeapon(playerid) == 35 || GetPlayerWeapon(playerid) == 36 || GetPlayerWeapon(playerid) == 37 || GetPlayerWeapon(playerid) == 38) {
	    Kick(playerid);
	    return 0;
	}
	if (GetPlayerMoney(playerid) != PlayerInfo[playerid][pMoney])
	{
	    ResetPlayerMoney(playerid);
	    GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	}
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
public OnGameModeInit()
{
    new rcon[80];
	Connectionafaire();
	mysql_log(LOG_ERROR);
	UsePlayerPedAnims();
	//DisableInteriorEnterExits();
	SetWeather(0);
	SetWorldTime(10);
	format(rcon, sizeof(rcon), "hostname %s", SERVER_NAME);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "weburl %s", SERVER_URL);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "language %s", LANGUAGE);
	SendRconCommand(rcon);
	SetGameModeText(SERVER_REVISION);
	SendRconCommand("ackslimit 5000");
    //spawn vehicule
    LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    LoadStaticVehiclesFromFile("vehicles/bone.txt");
    LoadStaticVehiclesFromFile("vehicles/flint.txt");
    LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    // LAS VENTURAS
    LoadStaticVehiclesFromFile("vehicles/lv_law.txt");
    LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
    LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
    //pickup
    save[0] = CreateDynamicPickup(1277, 3, 2025.7166,996.9984,10.8203,-1);
    save[1] = CreateDynamicPickup(1277, 3, 414.7263,2536.8547,10.0000,-1);
	//casino
	CreateCasinoMachine(CASINO_MACHINE_POKER,2031.04, 996.88, 10.66,   0.00, 0.00, 72.84);
	//slotmachine
	GamblingMachine = CreateObject(2325, 2236.6172, 1600.9479, 1000.6591 ,   0.00, 0.00, -90.00);
    for(new i = 0; i < sizeof(BanditLocs); i++)
    {GambleLabel[i] = Create3DTextLabel("Machine a sous\n type {0087FF}/jouer {FFFFFF}to\nPour commencer!", 0xFFFFFFFF, BanditLocs[i][0], BanditLocs[i][1], BanditLocs[i][2], 4.0, 0, 0);}
    //mapping
	CreateDynamicObject(4510, -2676.30, 1541.34, 64.98,   0.00, 0.00, -87.42);
	CreateDynamicObject(4511, -2687.00, 2058.20, 59.73,   0.00, 0.00, 81.72);
	CreateDynamicObject(4512, -2676.30, 1234.60, 60.70,   0.00, 0.00, -92.70);
	CreateDynamicObject(4514, 440.05, 587.45, 19.73,   0.00, 0.00, 34.14);
	CreateDynamicObject(4515, 604.52, 352.54, 19.73,   0.00, 0.00, -143.16);
	CreateDynamicObject(4516, -141.34, 468.65, 12.91,   0.00, 0.00, -16.44);
	CreateDynamicObject(4517, -193.83, 269.51, 12.89,   0.00, 0.00, -195.90);
	CreateDynamicObject(4518, 1694.32, 395.11, 31.16,   0.00, 0.00, -106.86);
	CreateDynamicObject(4519, 2766.84, 323.86, 9.16,   0.00, 0.00, -90.06);
	CreateDynamicObject(4523, -1592.78, 622.78, 42.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(4524, -1141.72, 1098.05, 39.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(4527, -1009.59, 943.81, 35.48,   0.00, 0.00, 177.78);
	//speedo
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
	// Textdraws
	gServerTextdraws[0] = TextDrawCreate(547.000000, 23.000000, "12:00 PM");
	TextDrawBackgroundColor(gServerTextdraws[0], 255);
	TextDrawFont(gServerTextdraws[0], 1);
	TextDrawLetterSize(gServerTextdraws[0], 0.360000, 1.499999);
	TextDrawColor(gServerTextdraws[0], -1);
	TextDrawSetOutline(gServerTextdraws[0], 1);
	TextDrawSetProportional(gServerTextdraws[0], 1);
	TextDrawSetSelectable(gServerTextdraws[0], 0);

    gServerTextdraws[1] = TextDrawCreate(237.000000, 409.000000, "~r~Serveur Restart:~w~ 00:00");
	TextDrawBackgroundColor(gServerTextdraws[1], 255);
	TextDrawFont(gServerTextdraws[1], 1);
	TextDrawLetterSize(gServerTextdraws[1], 0.480000, 1.300000);
	TextDrawColor(gServerTextdraws[1], -1);
	TextDrawSetOutline(gServerTextdraws[1], 1);
	TextDrawSetProportional(gServerTextdraws[1], 1);
	TextDrawSetSelectable(gServerTextdraws[1], 0);
	//mysql shit
	if (mysql_errno(mysql) != 0)
	    return 0;
	mysql_tquery(mysql,"SELECT * FROM `vehicle`", "LoadModsForAll", "");
	return 1;
}
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(pickupid == save[0])
	{
	    if(PlayerInfo[playerid][pLogged] == 0) return SCM(playerid, COLOR_SERVER, "No save for you");
	    PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
	    SCM(playerid, COLOR_SERVER, "Money time");
	    PlayerInfo[playerid][pSauvegarde] = 0;
        PlayerInfo[playerid][PXX] = 2025.7166;
        PlayerInfo[playerid][PYY] = 996.9984;
        PlayerInfo[playerid][PZZ] = 10.8203;
	    SaveAccountInfo(playerid);
	}
    if(pickupid == save[1])
	{
	    if(PlayerInfo[playerid][pLogged] == 0) return SCM(playerid, COLOR_SERVER, "No save for you");
	    PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
	    SCM(playerid, COLOR_SERVER, "Money time");
	    PlayerInfo[playerid][pSauvegarde] = 1;
		PlayerInfo[playerid][PXX] = 414.7263;
		PlayerInfo[playerid][PYY] = 2536.8547;
		PlayerInfo[playerid][PZZ] = 10.0000;
	    SaveAccountInfo(playerid);
	}
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
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	//video pocker
	if (GetPVarInt(playerid, "ss_casino_use") == 1) {
		new _machineID = GetPVarInt(playerid, "ss_casino_using");
		switch (_machines[_machineID][cm_type]) {
			case CASINO_MACHINE_POKER: {
				for (new _b=0; _b<5; _b++) {
					if (playertextid == poker_hold[playerid][_b]) {
						cPoker_button(playerid, CASINO_POKER_BTN_HOLD, _b);
					}
				}
			}
		}
	}
	if (funcidx("_gCasino_OPCPTD") != -1){
		return CallLocalFunction("_gCasino_OPCPTD", "ii", playerid, _:playertextid);
	}
	return 1;
}
public OnGameModeExit()
{
	DestroyObject(GamblingMachine);
	for(new i = 0; i < sizeof(BanditLocs); i++)
    {
        Delete3DTextLabel(GambleLabel[i]);
    }
	mysql_close(mysql);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid,0,0,0,0,0,0,0,0,0,0,0,0), SpawnPlayer(playerid);
	return 1;
}
script CheckingAccount(playerid)
{
	CC(playerid, 5);
	SetPlayerFacingAngle( playerid, 0 );
	InterpolateCameraPos(playerid, 2046.1014, 1033.3256, 12.7583 , 2046.6262, 1459.7177, 12.3383, GetSeconds(60), CAMERA_MOVE);
	InterpolateCameraLookAt(playerid,2046.1014, 1033.3256, 12.7583 ,2046.6262, 1459.7177, 12.3383, GetSeconds(60), CAMERA_MOVE);
	new rows, fields;
	cache_get_data(rows, fields, mysql);
	if(rows)
	{
		LoginSeconds[playerid] = 60;
	    LoginTimer[playerid] = SetTimerEx("LoginRemains", 1000, true, "i", playerid);
	    //INT
		PlayerInfo[playerid][pID] = cache_get_field_content_int(0, "ID");
		PlayerInfo[playerid][pLevel] =	cache_get_field_content_int(0, "Level");
		PlayerInfo[playerid][pMoney] =	cache_get_field_content_int(0, "Money");
		PlayerInfo[playerid][pVie] =	cache_get_field_content_int(0, "Vie");
		PlayerInfo[playerid][pArmure] =	cache_get_field_content_int(0, "Armure");
		PlayerInfo[playerid][pAdmin] =	cache_get_field_content_int(0, "Admin");
		PlayerInfo[playerid][pSkin] =	cache_get_field_content_int(0, "Skin");
		PlayerInfo[playerid][pInterior] =	cache_get_field_content_int(0, "Interior");
		PlayerInfo[playerid][pWorld] =	cache_get_field_content_int(0, "World");
		PlayerInfo[playerid][pMuted] =	cache_get_field_content_int(0, "Mute");
		//STRING
		cache_get_field_content(0, "Password", PlayerInfo[playerid][pPassword], mysql, 150);
		Dialog_Show(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"SERVEUR: {FFFFFF}Indentification","{FFFFFF}Bienvenu sur le serveur,\nVeuiller entrer votre mot de passe!\nVous avez {cc2a36}60{FFFFFF} secondes pour vous conenctez.","Procéder","Quitter");
	}
	else
	{
		Dialog_Show(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"SERVEUR: {FFFFFF}ENREGISTREMENT","{FFFFFF}Bienvenu sur le serveur,\n\nVous pouvez enregirstée ce compte.\nVeuiller entrer votre mot de passe!","Procéder","Quitter");
	}
}

public OnPlayerConnect(playerid)
{
	PlayerInfo[playerid][pLogged] = 0;
	SetPlayerColor(playerid, COLOR_GREY);
	new query[256], name[MAX_PLAYER_NAME];
	TogglePlayerSpectating(playerid, 1);
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	mysql_format(mysql, query, sizeof(query),"SELECT * FROM `Accounts` WHERE `Username` = '%e'", name);
	mysql_tquery(mysql, query, "CheckingAccount", "i", playerid);
	//slotmachine
    PlayerEnum[playerid][TotalWon] = 0;
	PlayerEnum[playerid][TotalPaid] = 0;
	PlayerEnum[playerid][TotalTotal] = 0;
    LeftSpinner = CreatePlayerObject(playerid, 2347, 2236.6072, 1601.0479, 1000.6791,   5.00, 0.00, -90.00);
	MiddleSpinner = CreatePlayerObject(playerid, 2348, 2236.6072, 1600.9279, 1000.6791,   5.00, 0.00, -90.00);
	RightSpinner = CreatePlayerObject(playerid, 2349, 2236.6072, 1600.8079, 1000.6791,   5.00, 0.00, -90.00);
    new doublebar[16], bar[16], bell[16], cherry[16], grapes[16], sixtynine[16], wager[16];
	format(doublebar,sizeof(doublebar),"= $%i",REWARD_DOUBLEBAR);
	format(bar,sizeof(bar),"= $%i",REWARD_BAR);
	format(bell,sizeof(bell),"= $%i",REWARD_BELL);
	format(cherry,sizeof(cherry),"= $%i",REWARD_CHERRY);
	format(grapes,sizeof(grapes),"= $%i",REWARD_GRAPES);
	format(sixtynine,sizeof(sixtynine),"= $%i",REWARD_SIXTYNINE);
	format(wager,sizeof(wager),"~y~Wager = $%i", GAMBLE_WAGER);
	//textdraw
    PlayerEnum[playerid][Textdraw0] = TextDrawCreate(563.000000, 163.000000, "~n~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw0], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw0], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw0], 0.500000, 17.700006);
	TextDrawColor(PlayerEnum[playerid][Textdraw0], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw0], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw0], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw0], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw0], 22.000000, 140.000000);

	PlayerEnum[playerid][Textdraw1] = TextDrawCreate(319.000000, 326.000000, "~n~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw1], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw1], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw1], 2.250000, 10.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw1], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw1], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw1], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw1], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw1], -22.000000, 340.000000);

	PlayerEnum[playerid][Textdraw2] = TextDrawCreate(179.000000, 329.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw2], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw2], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw2], 0.460000, -1.500000);
	TextDrawColor(PlayerEnum[playerid][Textdraw2], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw2], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw2], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw2], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw2], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw2], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw2], 90.000000, 69.000000);

	PlayerEnum[playerid][Textdraw3] = TextDrawCreate(274.000000, 329.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw3], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw3], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw3], 0.460000, -1.500000);
	TextDrawColor(PlayerEnum[playerid][Textdraw3], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw3], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw3], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw3], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw3], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw3], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw3], 90.000000, 69.000000);

	PlayerEnum[playerid][Textdraw4] = TextDrawCreate(369.000000, 329.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw4], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw4], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw4], 0.460000, -1.500000);
	TextDrawColor(PlayerEnum[playerid][Textdraw4], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw4], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw4], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw4], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw4], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw4], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw4], 90.000000, 69.000000);

	PlayerEnum[playerid][Textdraw5] = TextDrawCreate(206.000000, 381.000000, "YOU WON!");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw5], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw5], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw5], 1.100000, 4.099998);
	TextDrawColor(PlayerEnum[playerid][Textdraw5], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw5], 1);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw5], 1);

	PlayerEnum[playerid][Textdraw6] = TextDrawCreate(493.000000, 169.000000, "ld_slot:bar2_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw6], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw6], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw6], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw6], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw6], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw6], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw6], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw6], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw6], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw6], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw7] = TextDrawCreate(518.000000, 169.000000, "ld_slot:bar2_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw7], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw7], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw7], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw7], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw7], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw7], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw7], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw7], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw7], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw7], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw8] = TextDrawCreate(543.000000, 169.000000, "ld_slot:bar2_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw8], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw8], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw8], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw8], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw8], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw8], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw8], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw8], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw8], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw8], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw9] = TextDrawCreate(493.000000, 186.000000, "ld_slot:bar1_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw9], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw9], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw9], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw9], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw9], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw9], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw9], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw9], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw9], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw9], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw10] = TextDrawCreate(518.000000, 186.000000, "ld_slot:bar1_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw10], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw10], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw10], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw10], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw10], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw10], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw10], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw10], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw10], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw10], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw11] = TextDrawCreate(543.000000, 186.000000, "ld_slot:bar1_o");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw11], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw11], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw11], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw11], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw11], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw11], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw11], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw11], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw11], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw11], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw12] = TextDrawCreate(493.000000, 203.000000, "ld_slot:bell");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw12], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw12], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw12], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw12], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw12], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw12], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw12], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw12], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw12], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw12], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw13] = TextDrawCreate(518.000000, 203.000000, "ld_slot:bell");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw13], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw13], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw13], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw13], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw13], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw13], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw13], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw13], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw13], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw13], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw14] = TextDrawCreate(543.000000, 203.000000, "ld_slot:bell");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw14], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw14], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw14], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw14], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw14], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw14], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw14], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw14], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw14], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw14], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw15] = TextDrawCreate(493.000000, 220.000000, "ld_slot:cherry");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw15], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw15], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw15], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw15], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw15], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw15], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw15], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw15], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw15], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw15], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw16] = TextDrawCreate(518.000000, 220.000000, "ld_slot:cherry");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw16], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw16], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw16], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw16], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw16], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw16], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw16], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw16], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw16], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw16], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw17] = TextDrawCreate(543.000000, 220.000000, "ld_slot:cherry");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw17], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw17], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw17], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw17], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw17], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw17], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw17], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw17], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw17], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw17], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw18] = TextDrawCreate(493.000000, 237.000000, "ld_slot:grapes");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw18], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw18], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw18], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw18], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw18], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw18], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw18], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw18], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw18], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw18], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw19] = TextDrawCreate(518.000000, 237.000000, "ld_slot:grapes");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw19], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw19], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw19], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw19], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw19], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw19], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw19], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw19], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw19], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw19], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw20] = TextDrawCreate(543.000000, 237.000000, "ld_slot:grapes");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw20], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw20], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw20], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw20], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw20], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw20], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw20], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw20], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw20], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw20], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw21] = TextDrawCreate(493.000000, 255.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw21], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw21], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw21], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw21], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw21], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw21], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw21], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw21], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw21], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw21], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw22] = TextDrawCreate(518.000000, 255.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw22], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw22], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw22], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw22], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw22], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw22], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw22], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw22], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw22], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw22], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw23] = TextDrawCreate(543.000000, 255.000000, "ld_slot:r_69");
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw23], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw23], 4);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw23], 0.500000, 1.000000);
	TextDrawColor(PlayerEnum[playerid][Textdraw23], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw23], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw23], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw23], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw23], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw23], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw23], 25.000000, 20.000000);

	PlayerEnum[playerid][Textdraw24] = TextDrawCreate(573.000000, 253.000000, sixtynine);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw24], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw24], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw24], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw24], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw24], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw24], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw24], 1);

	PlayerEnum[playerid][Textdraw25] = TextDrawCreate(573.000000, 236.000000, grapes);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw25], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw25], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw25], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw25], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw25], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw25], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw25], 1);

	PlayerEnum[playerid][Textdraw26] = TextDrawCreate(573.000000, 219.000000, cherry);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw26], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw26], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw26], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw26], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw26], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw26], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw26], 1);

	PlayerEnum[playerid][Textdraw27] = TextDrawCreate(573.000000, 202.000000, bell);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw27], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw27], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw27], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw27], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw27], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw27], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw27], 1);

	PlayerEnum[playerid][Textdraw28] = TextDrawCreate(573.000000, 185.000000, bar);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw28], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw28], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw28], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw28], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw28], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw28], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw28], 1);

	PlayerEnum[playerid][Textdraw29] = TextDrawCreate(573.000000, 168.000000, doublebar);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw29], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw29], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw29], 0.290000, 1.700000);
	TextDrawColor(PlayerEnum[playerid][Textdraw29], 1694458980);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw29], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw29], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw29], 1);

	PlayerEnum[playerid][Textdraw30] = TextDrawCreate(496.000000, 281.000000, wager);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw30], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw30], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw30], 0.439999, 2.800000);
	TextDrawColor(PlayerEnum[playerid][Textdraw30], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw30], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw30], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw30], 1);

	PlayerEnum[playerid][Textdraw31] = TextDrawCreate(563.000000, 327.000000, "~n~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw31], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw31], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw31], 0.500000, 10.700002);
	TextDrawColor(PlayerEnum[playerid][Textdraw31], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw31], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawUseBox(PlayerEnum[playerid][Textdraw31], 1);
	TextDrawBoxColor(PlayerEnum[playerid][Textdraw31], 255);
	TextDrawTextSize(PlayerEnum[playerid][Textdraw31], 22.000000, 140.000000);

	PlayerEnum[playerid][Textdraw32] = TextDrawCreate(629.000000, 342.000000, "~w~won:   ~g~$0");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw32], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw32], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw32], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw32], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw32], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw32], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw32], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw32], 1);

	PlayerEnum[playerid][Textdraw33] = TextDrawCreate(629.000000, 352.000000, "-------------------------");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw33], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw33], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw33], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw33], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw33], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw33], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw33], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw33], 1);

	PlayerEnum[playerid][Textdraw34] = TextDrawCreate(629.000000, 363.000000, "~w~total:    ~y~$0");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw34], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw34], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw34], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw34], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw34], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw34], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw34], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw34], 1);

	PlayerEnum[playerid][Textdraw35] = TextDrawCreate(629.000000, 328.000000, "~w~paid:    ~r~$0");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw35], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw35], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw35], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw35], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw35], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw35], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw35], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw35], 1);

	PlayerEnum[playerid][Textdraw36] = TextDrawCreate(631.000000, 408.000000, "~w~Stop: ~b~/stopjouer");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw36], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw36], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw36], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw36], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw36], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw36], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw36], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw36], 1);

	PlayerEnum[playerid][Textdraw37] = TextDrawCreate(585.000000, 394.000000, "~w~Spin: ~b~~k~~VEHICLE_ENTER_EXIT~");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw37], 3);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw37], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw37], 2);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw37], 0.309997, 1.799999);
	TextDrawColor(PlayerEnum[playerid][Textdraw37], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw37], 0);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw37], 1);
	TextDrawSetShadow(PlayerEnum[playerid][Textdraw37], 1);

    PlayerEnum[playerid][Textdraw38] = TextDrawCreate(327.000000, 424.000000, "~r~Footer text.");
	TextDrawAlignment(PlayerEnum[playerid][Textdraw38], 2);
	TextDrawBackgroundColor(PlayerEnum[playerid][Textdraw38], 255);
	TextDrawFont(PlayerEnum[playerid][Textdraw38], 1);
	TextDrawLetterSize(PlayerEnum[playerid][Textdraw38], 0.460000, 1.400000);
	TextDrawColor(PlayerEnum[playerid][Textdraw38], -1);
	TextDrawSetOutline(PlayerEnum[playerid][Textdraw38], 1);
	TextDrawSetProportional(PlayerEnum[playerid][Textdraw38], 1);
	TextDrawSetSelectable(PlayerEnum[playerid][Textdraw38], 0);
	return 1;
}
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if( hittype != BULLET_HIT_TYPE_NONE ) // Bullet Crashing uses just this hittype
	{
        if( !( -1000.0 <= fX <= 1000.0 ) || !( -1000.0 <= fY <= 1000.0 ) || !( -1000.0 <= fZ <= 1000.0 ) )
		{
			Kick(playerid);
			return 0;
		}
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	if(LoginTimer[playerid])
	{
		KillTimer(LoginTimer[playerid]);
	}
	Report_Clear(playerid);
	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	LoadModsForAll();
	TuneThisCar(vehicleid);
	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
    SaveModsForTune(vehicleid);
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	AntiDeAMX();
	SetPlayerScore(playerid,PlayerInfo[playerid][pLevel]);
	//camera
	SetPlayerColor(playerid, COLOR_WHITE);
	SetCameraBehindPlayer(playerid);
	//skill
	SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL_SILENCED,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_DESERT_EAGLE,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SAWNOFF_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SPAS12_SHOTGUN,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MICRO_UZI,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MP5,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_AK47,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_M4,200);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SNIPERRIFLE,200);
    //money
    GivePlayerMoney(playerid,PlayerInfo[playerid][pMoney]);
    //armes
    for(new i = 0; i <= 12; i++)
	{
	    GivePlayerWeapon(playerid, gPlayerWeapons[playerid][i][0], gPlayerWeapons[playerid][i][1]);
	}
	//vie armure
	SetPlayerHealth(playerid,PlayerInfo[playerid][pVie]);
	SetPlayerArmour(playerid,PlayerInfo[playerid][pArmure]);
	//spawn aléatoire
    new randSpawn = 0;
	if(PlayerInfo[playerid][pSauvegarde] == -1)
	{
	 	randSpawn = random(sizeof(gRandomSpawns_LasVenturas));
	 	SetPlayerPos(playerid,gRandomSpawns_LasVenturas[randSpawn][0],gRandomSpawns_LasVenturas[randSpawn][1],gRandomSpawns_LasVenturas[randSpawn][2]);
		SetPlayerFacingAngle(playerid,gRandomSpawns_LasVenturas[randSpawn][3]);
	}
	if(PlayerInfo[playerid][pSauvegarde] == 0)
	{
	    SetPlayerPos(playerid,2025.7166,996.9984,10.8203);
	}
	if(PlayerInfo[playerid][pSauvegarde] == 1)
	{
	    SetPlayerPos(playerid,2204.9749,-1075.8743,1050.4844);
	    SetPlayerInterior(playerid,1);
	}
	if(PlayerInfo[playerid][pSauvegarde] == 2)
	{
	    SetPlayerPos(playerid,2320.1692,-1008.3569,1050.2109);
	    SetPlayerInterior(playerid,9);
	}
	if(PlayerInfo[playerid][pSauvegarde] == 3)
	{
    	SetPlayerPos(playerid,414.7263,2536.8547,10.0000);
    	SetPlayerInterior(playerid,10);
	}
	if(PlayerInfo[playerid][pSauvegarde] == 4)
	{
    	SetPlayerPos(playerid,2340.6423,-1062.5875,1049.0310);
    	SetPlayerInterior(playerid,6);
    }
    if(PlayerInfo[playerid][pSauvegarde] == 5)
	{
    	SetPlayerPos(playerid,2243.6089,-1077.1472,1049.0234);
    	SetPlayerInterior(playerid,2);
	}
	if(PlayerInfo[playerid][pSauvegarde] == 6)
	{
    	SetPlayerPos(playerid,2366.3894,-1120.7546,1050.8750);
    	SetPlayerInterior(playerid,8);
    }
    if(PlayerInfo[playerid][pSauvegarde] == 7)
	{
    	SetPlayerPos(playerid,2319.9199,-1208.3369,1049.0234);
    	SetPlayerInterior(playerid,6);
    }
    //skin
    SetPlayerSkin(playerid,PlayerInfo[playerid][pSkin]);
    //world interior
    SetPlayerInterior(playerid,PlayerInfo[playerid][pInterior]);
    SetPlayerVirtualWorld(playerid,PlayerInfo[playerid][pWorld]);
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	new randSpawn = 0;
	SCM(playerid,COLOR_SERVER,"Tu est mort");
	TogglePlayerControllable(playerid,false);
	ResetPlayerWeapons(playerid);
	SetPlayerHealth(playerid,100);
	SetPlayerArmour(playerid,0);
	SetPlayerWantedLevel(playerid,0);
	randSpawn = random(sizeof(gRandomSpawns_LasVenturas));
	SetPlayerPos(playerid,gRandomSpawns_LasVenturas[randSpawn][0],gRandomSpawns_LasVenturas[randSpawn][1],gRandomSpawns_LasVenturas[randSpawn][2]);
	SetPlayerFacingAngle(playerid,gRandomSpawns_LasVenturas[randSpawn][3]);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}
public OnVehicleRespray(playerid,vehicleid, color1, color2)
{
	TuneCar[vehicleid][colorA] = color1;
	TuneCar[vehicleid][colorB] = color2;
	return 1;
}
public OnVehicleMod(playerid,vehicleid,componentid)
{
	new Varz=InitComponents(componentid);
	switch (Varz)
	{
		case 1: { TuneCar[vehicleid][mod1]=componentid; }
		case 2: { TuneCar[vehicleid][mod2]=componentid; }
		case 3: { TuneCar[vehicleid][mod3]=componentid; }
		case 4: { TuneCar[vehicleid][mod4]=componentid; }
		case 5: { TuneCar[vehicleid][mod5]=componentid; }
		case 6: { TuneCar[vehicleid][mod6]=componentid; }
		case 7: { TuneCar[vehicleid][mod7]=componentid; }
		case 8: { TuneCar[vehicleid][mod8]=componentid; }
		case 9: { TuneCar[vehicleid][mod9]=componentid; }
		case 10: { TuneCar[vehicleid][mod10]=componentid; }
		case 11: { TuneCar[vehicleid][mod11]=componentid; }
		case 12: { TuneCar[vehicleid][mod12]=componentid; }
		case 13: { TuneCar[vehicleid][mod13]=componentid; }
		case 14: { TuneCar[vehicleid][mod14]=componentid; }
		case 15: { TuneCar[vehicleid][mod15]=componentid; }
		case 16: { TuneCar[vehicleid][mod16]=componentid; }
		case 17: { TuneCar[vehicleid][mod17]=componentid; }
	}
	printf("Component Added: %d",componentid);
	SaveModsForAll(vehicleid);
	return 1;
}

public OnVehiclePaintjob(playerid,vehicleid, paintjobid)
{
	TuneCar[vehicleid][paintjob]=paintjobid;
	return 1;
}
public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if (!PlayerInfo[playerid][pLogged])
	    return 0;
	if (PlayerInfo[playerid][pMuted])
	{
	    SendErrorMessage(playerid, "Vous êtes mute par le serveur.");
	    return 0;
	}
	if (PlayerInfo[playerid][pSpamCount] < 5)
	{
	    PlayerInfo[playerid][pSpamCount]++;
	    if (PlayerInfo[playerid][pSpamCount] == 5) {
	        PlayerInfo[playerid][pSpamCount] = 0;
	        PlayerInfo[playerid][pMuted] = 1;
	        PlayerInfo[playerid][pMuteTime] = 5;
	        SendServerMessage(playerid, "Vous avez été mute pour spam (5 seconds).");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a été mute automatiquement pour spam.", ReturnName(playerid, 0));
	        return 0;
		}
	}
	if(PlayerInfo[playerid][pLogged] == 1)
	{
		SendNearbyMessage(playerid, 10.0, COLOR_WHITE, "%s dit: %s", ReturnName(playerid, 0), text);
	}
	return 0;
}

public OnPlayerCommandReceived(playerid, cmdtext[]) {

	if (isnull(cmdtext))
    	return 0;

	if(PlayerInfo[playerid][pLogged] != 1) return 0;

	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if (isnull(cmdtext))
    	return 0;
    if(!strcmp(cmdtext, "/jouer", true))
    {
        for(new i = 0; i<sizeof(BanditLocs); i++)
        {
            if(IsPlayerInRangeOfPoint(playerid,1.0,BanditLocs[i][0],BanditLocs[i][1], BanditLocs[i][2]))
            {
		        if(IsGambling[playerid] == false) //If player isn't gambling
		        {
					Dialog_Show(playerid,DIALOG_STARTGAMBLE,DIALOG_STYLE_MSGBOX,"Commencer a jouer","Vous voulez vraiment jouer?","Oui","Non");
                    return 1;
				}else return SCM(playerid,COLOR_SERVER,"Vous jouez déjà!");
   			}
			else if(!IsPlayerInRangeOfPoint(playerid,1.0,BanditLocs[i][0],BanditLocs[i][1], BanditLocs[i][2]) && i == sizeof(BanditLocs) - 1)
		 	{
		 		SCM(playerid,COLOR_SERVER,"Vous n'êtes proche de aucune machine a sous.");
			}
		}
        return 1;
    }
    if(!strcmp(cmdtext, "/stopjouer", true))
    {
        if(IsGambling[playerid] == true)
        {
            if(IsSpinning[playerid] == false)
            {
            	Dialog_Show(playerid,DIALOG_STOPGAMBLE,DIALOG_STYLE_MSGBOX,"Arrêter de jouer","Vous voulez arrêter de jouer?","Oui","Non");
			}else return SCM(playerid,COLOR_SERVER,"La machine a sous tourne encore veuiller patentier.");
		}else return SCM(playerid,COLOR_SERVER,"Vous n'êtes proche de aucune machine a sous.");
        return 1;
    }
	if(!success)
	format(str1, sizeof(str1), "SERVEUR: {FFFFFF}Cette commande %s est invalide.", cmdtext),
	SendClientMessage(playerid, COLOR_SERVER, str1);

	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK)) //If player presses ENTER
    {
        if(IsGambling[playerid] == true)
        {
            if(IsSpinning[playerid] == false)
            {
	            if(GetPlayerMoney(playerid) >= GAMBLE_WAGER)
	            {
	                PlayerEnum[playerid][TotalPaid] = PlayerEnum[playerid][TotalPaid] + GAMBLE_WAGER;
	                GivePlayerMoney(playerid,GAMBLE_WAGER - GAMBLE_WAGER*2);
	                IsSpinning[playerid] = true;
			        PreSpinTimer = SetTimer("Prespin", 100, true);
			        SetTimer("SpinSpinners", 3000, false);
			        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw2]);
					TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw3]);
					TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw4]);
					TextDrawHideForPlayer(playerid, PlayerEnum[playerid][Textdraw5]);
					if(GetPlayerMoney(playerid) < GAMBLE_WAGER)
					{
					    new wager[16];
						format(wager,sizeof(wager),"~r~Wager = $%i", GAMBLE_WAGER);
						TextDrawSetString(PlayerEnum[playerid][Textdraw30],wager);
					}
					else
					{
					    new wager[16];
						format(wager,sizeof(wager),"~y~Wager = $%i", GAMBLE_WAGER);
						TextDrawSetString(PlayerEnum[playerid][Textdraw30],wager);
					}
					new doublebar[16], bar[16], bell[16], cherry[16], grapes[16], sixtynine[16];
					format(doublebar,sizeof(doublebar),"= $%i",REWARD_DOUBLEBAR);
					format(bar,sizeof(bar),"= $%i",REWARD_BAR);
					format(bell,sizeof(bell),"= $%i",REWARD_BELL);
					format(cherry,sizeof(cherry),"= $%i",REWARD_CHERRY);
					format(grapes,sizeof(grapes),"= $%i",REWARD_GRAPES);
					format(sixtynine,sizeof(sixtynine),"= $%i",REWARD_SIXTYNINE);
					TextDrawSetString(PlayerEnum[playerid][Textdraw29],doublebar);
					TextDrawSetString(PlayerEnum[playerid][Textdraw28],bar);
					TextDrawSetString(PlayerEnum[playerid][Textdraw24],sixtynine);
					TextDrawSetString(PlayerEnum[playerid][Textdraw27],bell);
					TextDrawSetString(PlayerEnum[playerid][Textdraw25],grapes);
					TextDrawSetString(PlayerEnum[playerid][Textdraw26],cherry);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw29]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw28]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw24]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw27]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw25]);
					TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw26]);
					SetPlayerWonPaid(playerid);
				}
				else return SCM(playerid,COLOR_SERVER,"You can not gamble anymore, you don't have enough money to pay the wager!");
			}else return SCM(playerid,COLOR_SERVER,"You can't spin again yet, the machine is still running. Wait until the draw is finished.");
		}
    }
    if (newkeys & KEY_SPRINT && PlayerInfo[playerid][pLoopAnim])
	{
	    ClearAnimations(playerid);
		HidePlayerFooter(playerid);
	    PlayerInfo[playerid][pLoopAnim] = false;
	}
	return 1;
}
CMD:aide(playerid, params[])
{
	SCM(playerid,COLOR_SERVER,"----------[Commande serveur]----------");
	SCM(playerid,COLOR_SERVER,"/animcmds, /rapport, /c, /me, /do, /bas, /b");
	return 1;
}
//partie commande
CMD:saveme(playerid,params[])
{
    if(PlayerInfo[playerid][pLogged] == 0) return SCM(playerid, COLOR_SERVER, "No save");
    PlayerInfo[playerid][pMoney] = GetPlayerMoney(playerid);
    PlayerInfo[playerid][pSauvegarde] = -1;
    SCM(playerid, COLOR_SERVER, "Save");
    SaveAccountInfo(playerid);
    return 1;
}
//chat
CMD:me(playerid, params[])
{

	if (isnull(params))
	    return SCM(playerid, COLOR_SERVER,"/me [action]");

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
	    return SCM(playerid, COLOR_SERVER,"/do [description]");

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
CMD:c(playerid, params[])
{

	if (isnull(params))
	    return SCM(playerid,COLOR_SERVER,"/(c)rier [texte]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s crie: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "...%s!", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s crie: %s!", ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:crier(playerid, params[])
	return cmd_c(playerid, params);
CMD:bas(playerid, params[])
{
	if (isnull(params))
	    return SCM(playerid,COLOR_SERVER,"/bas [texte]");
	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[bas] %s dit à voix basse: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[bas] %s dit à voix basse: %s", ReturnName(playerid, 0), params);
	}
	return 1;
}
CMD:b(playerid, params[])
{
	if (isnull(params))
	    return SCM(playerid,COLOR_SERVER,"/b [local OOC]");
	if (strlen(params) > 64)
	{
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s [%d]: (( %.64s", ReturnName(playerid, 0), playerid, params);
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "...%s ))", params[64]);
	}
	else
	{
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s [%d]: (( %s ))", ReturnName(playerid, 0), playerid, params);
	}
	//format(string, sizeof(string), "(( %s ))", params);
	//SetPlayerChatBubble(playerid, string, COLOR_WHITE, 10.0, 6000);
	return 1;
}
CMD:rapport(playerid, params[])
{
	new reportid = -1;
	if (isnull(params))
	{
	    SCM(playerid,COLOR_SERVER,"/rapport [raison]");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} S'il vous plaît utilisez cette commande uniquement si vous avez besoin d'aide.");
	    return 1;
	}
	if (Report_GetCount(playerid) > 5)
	    return SCM(playerid,COLOR_SERVER,"Tu a déja 5 rapport active attent un peut!!!!!!");
	if (PlayerInfo[playerid][pReportTime] >= gettime())
	    return SCM(playerid,COLOR_SERVER,"Vous devez attendre %d secondes avant le prochain rapport.", PlayerInfo[playerid][pReportTime] - gettime());
	if ((reportid = Report_Add(playerid, params)) != -1)
	{
		ShowPlayerFooter(playerid, "Votre ~g~rapport~w~ est envoyer");

		foreach (new i : Player)
		{
			if (PlayerInfo[i][pAdmin] > 0) {
				SendClientMessageEx(i, COLOR_PINK, "[RAPPORT %d]: %s (ID: %d) reporte: %s", reportid, ReturnName(playerid, 0), playerid, params);
			}
		}
		PlayerInfo[playerid][pReportTime] = gettime() + 15;
		SendServerMessage(playerid, "Rapport envoyé aux admins connectés.");
	}
	else {SCM(playerid,COLOR_SERVER,"La liste de rapport est pleine veuiller attendre.");}
	return 1;
}
//anims
CMD:animcmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /dance, /handsup, /bat, /slap, /bar, /wash, /lay, /workout, /blowjob, /bomb.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /carry, /crack, /sleep, /jump, /deal, /dancing, /eating, /puke, /gsign, /chat.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /goggles, /spray, /throw, /swipe, /office, /kiss, /knife, /cpr, /scratch, /point.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /cheer, /wave, /strip, /smoke, /reload, /taichi, /wank, /cower, /skate, /drunk.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /cry, /tired, /assis, /crossarms, /fucku, /walk, /piss, /stopanim.");
	return 1;
}
CMD:dance(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/dance [1-4]");
	if (type < 1 || type > 4)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}
CMD:piss(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}
CMD:bat(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/bat [1-5]");
	if (type < 1 || type > 5)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:bar(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/bar [1-8]");
	if (type < 1 || type > 8)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:lay(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/lay [1-5]");
	if (type < 1 || type > 5)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/workout [1-7]");
	if (type < 1 || type > 7)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/blowjob [1-4]");
	if (type < 1 || type > 4)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:carry(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/carry [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/crack [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/sleep [1-2]");
	if (type < 1 || type > 2)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
CMD:jump(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}
CMD:deal(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/deal [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/dancing [1-10]");
	if (type < 1 || type > 10)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/eating [1-3]");
	if (type < 1 || type > 3)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");

	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:gsign(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/gsign [1-15]");
	if (type < 1 || type > 15)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/chat [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:spray(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
 	ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:throw(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:swipe(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:office(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/office [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/kiss [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/knife [1-8]");
	if (type < 1 || type > 8)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}
CMD:scratch(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/scratch [1-4]");
	if (type < 1 || type > 4)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/point [1-4]");
	if (type < 1 || type > 4)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/cheer [1-8]");
	if (type < 1 || type > 8)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/strip [1-7]");
	if (type < 1 || type > 7)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/wave [1-3]");
	if (type < 1 || type > 3)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/smoke [1-3]");
	if (type < 1 || type > 3)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/reload [1-4]");
	if (type < 1 || type > 4)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:wank(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/wank [1-3]");
	if (type < 1 || type > 3)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}
CMD:skate(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/skate [1-2]");
	if (type < 1 || type > 2)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
	switch (type) {
		case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:drunk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}
CMD:cry(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}
CMD:tired(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/tired [1-2]");
	if (type < 1 || type > 2)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/assis [1-6]");
	if (type < 1 || type > 6)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
CMD:crossarms(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/crossarms [1-4]");
	if (type < 1 || type > 4)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}
CMD:walk(playerid, params[])
{
    new type;
	if (!AnimationCheck(playerid))
	    return SCM(playerid,COLOR_SERVER,"Tu ne peut faire cette animation en se moment.");
	if (sscanf(params, "d", type))
	    return SCM(playerid,COLOR_SERVER,"/walk [1-16]");
	if (type < 1 || type > 17)
	    return SCM(playerid,COLOR_SERVER,"Invalide type spécifié.");
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
//admin
CMD:mettreadmin(playerid, params[])
{
	static userid,level;
	if (PlayerInfo[playerid][pAdmin] < 3)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ud", userid, level))
		return SCM(playerid,COLOR_SERVER,"/mettreadmin [playerid/name] [level]");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	if (level < 0 || level > 3)
	    return SCM(playerid,COLOR_SERVER,"Invalide niveaux 0 a 3");
	if (level > PlayerInfo[userid][pAdmin])
	{
	    SCM(playerid,COLOR_SERVER,"Vous avez mis %s admin de niveau (%d).", ReturnName(userid, 0), level);
	    SCM(userid,COLOR_SERVER, "%s vous à mis admin de niveau (%d).", ReturnName(playerid, 0), level);
	}
	else
	{
	    SCM(playerid,COLOR_SERVER,"Vous avez mis %s admin de niveau (%d).", ReturnName(userid, 0), level);
	    SCM(userid,COLOR_SERVER, "%s vous à mis admin de niveau (%d).", ReturnName(playerid, 0), level);
	}
	PlayerInfo[userid][pAdmin] = level;
 	Log_Write("logs/admin_log.txt", "[%s] %s à mis admin %s au niveau %d.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), level);

	return 1;
}
CMD:a(playerid, params[])
{
	if (!PlayerInfo[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Vous n'êtes pas un admin");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/a [admin text]");

	if (strlen(params) > 64) {
	    if (PlayerInfo[playerid][pAdmin] < 1)
	    	SendAdminMessage(COLOR_LIME, "** %s: %.64s", ReturnName(playerid, 0), params);
		else
			SendAdminMessage(COLOR_LIME, "** %s: %.64s", ReturnName(playerid, 0), params);
		SendAdminMessage(COLOR_LIME, "...%s **", params[64]);
	}
	else {
	    SendAdminMessage(COLOR_LIME, "** %s: %s **",ReturnName(playerid, 0), params);
	}
	Log_Write("logs/adminchat_log.txt", "[%s] %s : %s", ReturnDate(),ReturnName(playerid),params);
	return 1;
}
CMD:givemoney(playerid, params[])
{
	static userid,amount;
	if (PlayerInfo[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ud", userid, amount))
		return SendSyntaxMessage(playerid, "/givecash [playerid/name] [montant]");
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Vous avez mis un [id/nom] invalide.");
	GiveMoney(userid, amount);
	SendAdminMessage(COLOR_LIME, "[ADMIN]: %s a donnée %s à %s.", ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
	SendAdminAlert(COLOR_LIGHTRED, "[ADMINALERT]: %s a donnée %s à %s.", ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
 	Log_Write("logs/admin_log.txt", "[%s] %s a given %s a %s.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
	return 1;
}
CMD:resetweps(playerid, params[])
{
	static
	    userid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/resetweps [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	ResetWeapons(userid);
	SCM(playerid,COLOR_SERVER,"Vous avez reset %s weapons.", ReturnName(userid, 0));
	return 1;
}
CMD:clearchat(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");

	for (new i = 0; i < 100; i ++) {
	    SendClientMessageToAll(-1, "");
	}
	return 1;
}
CMD:spec(playerid, params[])
{
	new userid;
	if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (!isnull(params) && !strcmp(params, "off", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
			return SCM(playerid,COLOR_SERVER,"Vous n'êtes plus en spec.");
	    PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
	    PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);
	    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][PXX], PlayerInfo[playerid][PYY], PlayerInfo[playerid][PZZ],0, 0, 0, 0, 0, 0, 0);
	    TogglePlayerSpectating(playerid, false);
	    return SendServerMessage(playerid, "Vous n'êtes plus en spec.");
	}
	if (sscanf(params, "u", userid))
		return SCM(playerid,COLOR_SERVER,"/spec [playerid/name] - Tapez \"/spec off\" pour arreté.");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		GetPlayerPos(playerid, PlayerInfo[playerid][PXX], PlayerInfo[playerid][PYY], PlayerInfo[playerid][PZZ]);
		SetPlayerFacingAngle(playerid, 0.0);
		PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
		PlayerInfo[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
	}
	SetPlayerInterior(playerid, GetPlayerInterior(userid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));
	TogglePlayerSpectating(playerid, 1);
	if (IsPlayerInAnyVehicle(userid))
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userid));
	else
		PlayerSpectatePlayer(playerid, userid);
	SendServerMessage(playerid, "Vous regardez %s (ID: %d).", ReturnName(userid, 0), userid);
	PlayerInfo[playerid][pSpectator] = userid;
	return 1;
}
CMD:kick(playerid, params[])
{
	static userid,reason[128];
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "us[128]", userid, reason))
	    return SCM(playerid,COLOR_SERVER,"/kick [playerid/nom] [raison]");
	if (userid == INVALID_PLAYER_ID || (IsPlayerConnected(userid) && PlayerInfo[userid][pKicked]))
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
    if (PlayerInfo[userid][pAdmin] > PlayerInfo[playerid][pAdmin])
	    return SCM(playerid,COLOR_SERVER,"L'admin est plus fort que toi.");
	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a kické %s raison: %s.", ReturnName(playerid, 0), ReturnName(userid, 0), reason);
	Log_Write("logs/kick_log.txt", "[%s] %s a kické %s raison: %s.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), reason);
	KickEx(userid);
	return 1;
}
CMD:mute(playerid, params[])
{
    static userid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/mute [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	if (userid == playerid)
	    return SCM(playerid,COLOR_LIGHTRED,"Tu ne peut te muté.");
	if (PlayerInfo[userid][pMuted])
	    return SCM(playerid,COLOR_SERVER,"Le joueur est déja mute.");
    if (PlayerInfo[userid][pAdmin] > PlayerInfo[playerid][pAdmin])
	    return SCM(playerid,COLOR_SERVER,"L'admin est plus fort que toi.");
	PlayerInfo[userid][pMuted] = 1;
	SCM(playerid,COLOR_SERVER,"Vous avez été mute par %s.", ReturnName(userid, 0));
	SCM(userid,COLOR_SERVER, "%s a été mute", ReturnName(playerid, 0));
	return 1;
}
CMD:unmute(playerid, params[])
{
    static userid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/unmute [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	if (!PlayerInfo[userid][pMuted])
	    return SCM(playerid,COLOR_SERVER,"Ce joueur n'est pas muté");
	PlayerInfo[userid][pMuted] = 0;
	SCM(playerid,COLOR_SERVER,"Vous avez été démute par %s", ReturnName(userid, 0));
	SCM(userid,COLOR_SERVER, "Vous avez démute %s.", ReturnName(playerid, 0));
	return 1;
}
CMD:setint(playerid, params[])
{
	static userid,interior;
	if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ud", userid, interior))
		return SCM(playerid,COLOR_SERVER,"/setint [playerid/name] [interior]");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	SetPlayerInterior(userid, interior);
	PlayerInfo[userid][pInterior] = interior;
	SendServerMessage(playerid, "Vous avez mis %s dans l'intérieur (ID %d.)", ReturnName(userid, 0), interior);
	return 1;
}
CMD:setvw(playerid, params[])
{
	static userid,world;
	if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "ud", userid, world))
		return SCM(playerid,COLOR_SERVER,"/setvw [playerid/name] [world]");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	SetPlayerVirtualWorld(userid, world);
	PlayerInfo[userid][pWorld] = world;
	SendServerMessage(playerid, "Vous avez mis %s dans le virtual world (ID %d.)", ReturnName(userid, 0), world);
	return 1;
}
CMD:vie(playerid, params[])
{
	static userid,Float:amount;
	if (PlayerInfo[playerid][pAdmin] < 3)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "uf", userid, amount))
		return SCM(playerid,COLOR_SERVER,"/vie [playerid/name] [montant]");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	SetPlayerHealth(userid, amount);
	SendServerMessage(playerid, "Vous avez mis la vie de %s a %.2f.", ReturnName(userid, 0), amount);
	return 1;
}
CMD:armure(playerid, params[])
{
	static
		userid,
	    Float:amount;
	if (PlayerInfo[playerid][pAdmin] < 3)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "uf", userid, amount))
		return SCM(playerid,COLOR_SERVER,"/armure [playerid/name] [montant]");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
    SetPlayerArmour(userid, amount);
	SendServerMessage(playerid, "Vous avez mis l'armure %s a %.2f.", ReturnName(userid, 0), amount);
	return 1;
}
CMD:freeze(playerid, params[])
{
	static userid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/freeze [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	TogglePlayerControllable(userid, 0);
	SCM(playerid,COLOR_SERVER,"Vous vener de freeze %s", ReturnName(userid, 0));
	return 1;
}
CMD:unfreeze(playerid, params[])
{
	static userid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/unfreeze [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
    PlayerInfo[playerid][pFreeze] = 0;
	TogglePlayerControllable(userid, 1);
	SCM(playerid,COLOR_SERVER,"Vous venez de defreeze %s.", ReturnName(userid, 0));
	return 1;
}
CMD:gethere(playerid, params[])
{
	static userid;
	if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/amener [playerid/nom]");
    if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	if (PlayerInfo[userid][pLogged] == 0)
		return SCM(playerid,COLOR_SERVER,"Se joueur n'est pas spawn.");
	SendPlayerToPlayer(userid, playerid);
	SendServerMessage(playerid, "Vous avez téléporté %s à vous.", ReturnName(userid, 0));
	return 1;
}
CMD:envoyera(playerid, params[])
{
	static userid,targetid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "uu", userid, targetid))
	    return SCM(playerid,COLOR_SERVER,"/envoyera [playerid/name] [playerid/nom]");
	if (userid == INVALID_PLAYER_ID || targetid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"L'id de l'utilisateur n'est pas connecté..");
	SendPlayerToPlayer(userid, targetid);
	SendServerMessage(playerid, "Vous avez teleporté %s à %s.", ReturnName(userid, 0), ReturnName(targetid));
	SendServerMessage(userid, "%s a téléporté  %s.", ReturnName(playerid, 0), ReturnName(targetid));
	return 1;
}
CMD:rapports(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
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
	    return SCM(playerid,COLOR_SERVER,"Aucun rapport.");
	SendServerMessage(playerid, "Utilisé \"/ar RID\" ou \"/dr RID\" pour accepter ou décliner le rapport.");
	return 1;
}

CMD:ar(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params))
	    return SCM(playerid,COLOR_SERVER,"/ar [rapport id] (/rapports pour la liste)");
	new reportid = strval(params),string[64];
	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SCM(playerid,COLOR_SERVER,"RID invalide, choisir un RID allant de 0 à %d.", MAX_REPORTS);
	format(string, sizeof(string), "Vous avez ~g~accepter~w~ le rapport (ID: %d.)", reportid);
	ShowPlayerFooter(playerid, string);
	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) accepte votre rapport.", ReturnName(playerid, 0), playerid);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s à accepté le rapport de %s.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
	Report_Remove(reportid);
	return 1;
}
CMD:dr(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (isnull(params))
	    return SCM(playerid,COLOR_SERVER,"/dr [rapport id] (/rapports pour la liste)");
	new reportid = strval(params), string[64];
	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SCM(playerid,COLOR_SERVER,"RID invalide, choisir un RID allant de 0 à %d.", MAX_REPORTS);
	format(string, sizeof(string), "Vous avez ~r~decliner~w~ rapport (ID: %d.)", reportid);
	ShowPlayerFooter(playerid, string);
	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) a décliné votre rapport.", ReturnName(playerid, 0), playerid);
    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a décliné le rapport de %s'.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));
    Report_Remove(reportid);
	return 1;
}
CMD:restart(playerid, params[])
{
	new time;
	if (PlayerInfo[playerid][pAdmin] < 2)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (g_ServerRestart)
	{
	    TextDrawHideForAll(gServerTextdraws[1]);
	    g_ServerRestart = 0;
	    g_RestartTime = 0;
	    return SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a commencé un restart serveur.", ReturnName(playerid, 0));
	}
	if (sscanf(params, "d", time))
	    return SCM(playerid,COLOR_SERVER,"/restart [seconds]");
	if (time < 3 || time > 120)
	    return SCM(playerid,COLOR_SERVER,"Minimum 3 et max 120 en secondes.");
    TextDrawShowForAll(gServerTextdraws[1]);
	g_ServerRestart = 1;
	g_RestartTime = time;
	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s a commencer un restart et sera effectué a %d seconds.", ReturnName(playerid, 0), time);
	//cmd_saveall(playerid, "");
	return 1;
}
/*CMD:getip(playerid, params[])
{
	static userid;
    if (PlayerInfo[playerid][pAdmin] < 2)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "u", userid))
	    return SCM(playerid,COLOR_SERVER,"/getip [playerid/nom]");
	if (userid == INVALID_PLAYER_ID)
	    return SCM(playerid,COLOR_SERVER,"Vous avez mis un [id/nom] invalide.");
	SendServerMessage(playerid, "%s IP est %s.", ReturnName(userid, 0), PlayerInfo[userid][pIP]);
	return 1;
}
CMD:amenerveh(playerid, params[])
{
	new vehicleid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", vehicleid))
	    return SCM(playerid,COLOR_SERVER,"/amenerveh [veh]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SCM(playerid,COLOR_SERVER,"ID de vehicule invalide.");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 2, y - 2, z);
 	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
	return 1;
}
CMD:entercar(playerid, params[])
{
	new vehicleid, seatid;
    if (PlayerInfo[playerid][pAdmin] < 3)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", vehicleid))
	    return SCM(playerid,COLOR_SERVER,"/entercar [veh]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SCM(playerid,COLOR_SERVER,"ID de vehicule invalide.");
	seatid = GetAvailableSeat(vehicleid, 0);
	PutPlayerInVehicle(playerid, vehicleid, seatid);
	return 1;
}
CMD:gotocar(playerid, params[])
{
	new vehicleid;
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SCM(playerid,COLOR_SERVER,"Vous n'êtes pas autorisé à utiliser cette commande.");
	if (sscanf(params, "d", vehicleid))
	    return SCM(playerid,COLOR_SERVER,"/gotocar [veh]");
	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SCM(playerid,COLOR_SERVER,"ID de vehicule invalide.");
	static Float:x,Float:y,Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	SetPlayerPosEx(playerid, x, y - 2, z + 2);
	return 1;
}*/
public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 3)
    {
        //new Float:health,idk = Car_GetID(vehicleid);
        //GetVehicleHealth(vehicleid,health);
        /*if(health > 1000)
		{*/
		SetVehicleHealth(vehicleid,1000.0);
			/*CarData[idk][carvie] = 1000.0;
		}*/
        //SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: Cheateur détecté");
        //RespawnVehicle(vehicleid);
        return 0;
    }
    return 1;
}
Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
		Kick(playerid);
		GameTextForPlayer(playerid, "~R~EXPULSER", 4000, 4);
	}
	if(response)
	{
		if(strlen(inputtext))
		{
			new query[100], pass[150];
			HashingPassword(pass, sizeof (pass), inputtext);
			if(!strcmp(pass, PlayerInfo[playerid][pPassword]))
			{
				PlayerInfo[playerid][pLogged] = 1;
				if(LoginTimer[playerid])
				{
				    KillTimer(LoginTimer[playerid]);
				}
		 		mysql_format(mysql, query, sizeof(query), "SELECT * FROM `Accounts` WHERE `Username` = '%e' LIMIT 1", ReturnName(playerid, 0));
           		mysql_tquery(mysql, query, "LoadAccountInfo", "i", playerid);
			}
			else
  			{
  			   	GameTextForPlayer(playerid, "~R~ wrong password", 4000, 4);
				Dialog_Show(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"SERVEUR: {FFFFFF}Indentification","{FFFFFF}Bienvenu sur le serveur,\nVeuiller entrer votre mot de passe!\nVous avez {cc2a36}%d{FFFFFF} secondes pour le faire.","Procéder","Quitter" , LoginSeconds[playerid]);
			}
		}
		else
  		{
			Dialog_Show(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"SERVEUR: {FFFFFF}Indentification", "{FFFFFF}Bienvenu sur le serveur,\nVeuiller entrer votre mot de passe!\nVous avez {cc2a36}%d{FFFFFF} secondes pour le faire.","Procéder","Quitter", LoginSeconds[playerid]);
		}
	}
	return 1;
}
Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if (!response)
	{
	    GameTextForPlayer(playerid, "~R~EXPULSER", 4000, 4);
		Kick(playerid);
	}
	if(response)
	{
		if(strlen(inputtext))
		{
		    new query[500], pass[150];
			HashingPassword(pass, sizeof (pass), inputtext);
			mysql_format(mysql, query, sizeof(query), "INSERT INTO `Accounts` ( `Username`, `Password`) VALUES ('%s', '%s')", ReturnName(playerid, 0), pass);
			mysql_tquery(mysql, query, "RegisterAccountInfo", "i", playerid);
		}
		else
		{
			Dialog_Show(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"SERVEUR: {FFFFFF}Enregistrement","{FFFFFF}Bienvenu sur le serveur,\n\nVous pouvez enregistré ce nom.\nVeuiller entrer votre mot de passe!","Proceed","Quit");
		}
	}
	return 1;
}
Dialog:DIALOG_STARTGAMBLE(playerid, response, listitem, inputtext[])
{
    if(response) //If player pressed the first ("Yes") button
    {
        if(GetPlayerMoney(playerid) >= GAMBLE_WAGER)
        {
	        IsGambling[playerid] = true;
	        PlayerEnum[playerid][TotalPaid] = 0;
	        PlayerEnum[playerid][TotalWon] = 0;
	        PlayerEnum[playerid][TotalTotal] = 0;
	        TogglePlayerControllable(playerid,0);
	        GetPlayerPos(playerid,pX,pY,pZ);
	        SetPlayerPos(playerid,2221.9514,1619.6721,1006.1836);
	        SetPlayerCameraPos(playerid,2235.9072, 1600.9279, 1000.8791);
	        SetPlayerCameraLookAt(playerid,2236.6072, 1600.9279, 1000.6791);
	        SetPlayerWonPaid(playerid);
	        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw0]); //black box side
	        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw1]); //Black box bottom
	        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw6]);
	        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw7]);
	        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw8]);
	        TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw9]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw10]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw11]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw12]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw13]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw14]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw15]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw16]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw17]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw18]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw19]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw20]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw21]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw22]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw23]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw24]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw25]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw26]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw27]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw28]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw29]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw30]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw31]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw32]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw33]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw34]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw35]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw36]);
			TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw37]);
		}
		else
		{
			SCM(playerid,COLOR_SERVER,"Vous n'avez pas asser d'argent pour jouer!");
		}
	    return 1;
	}
	return 1;
}
Dialog:DIALOG_STOPGAMBLE(playerid, response, listitem, inputtext[])
{
    if(response) //If player pressed the first ("Yes") button
    {
        IsGambling[playerid] = false;
        TogglePlayerControllable(playerid,1);
        SetPlayerPos(playerid,pX,pY,pZ);
        SetCameraBehindPlayer(playerid);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw0]); //black box side
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw1]); //Black box bottom
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw2]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw3]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw4]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw5]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw6]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw7]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw8]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw9]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw10]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw11]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw12]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw13]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw14]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw15]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw16]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw17]);
		TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw18]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw19]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw20]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw21]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw22]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw23]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw24]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw25]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw26]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw27]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw28]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw29]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw30]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw31]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw32]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw33]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw34]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw35]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw36]);
        TextDrawHideForPlayer(playerid,PlayerEnum[playerid][Textdraw37]);
    }
 	return 1;
}
//video pocker
public OnCasinoStart(playerid, machineid)
{
	new _type;
	if (GetMachineType(machineid, _type))
	{
		if (_type == CASINO_MACHINE_POKER)
		{
			SendClientMessage(playerid, 0xFF9900AA, "[CASINO]{FFFFFF} Bienvenue sur une des machines vidéo poker");
			SendClientMessage(playerid, 0xFF9900AA, "[CASINO]{FFFFFF} Si vous pariez 100$ vous pouvez gagner jusqu'a $400");
		}
	}
	return 1;
}
public OnCasinoEnd(playerid, machineid)
{
	SendClientMessage(playerid, 0xFF9900AA, "[CASINO]{FFFFFF} Au revoir, Merci d'avoir jouer sur cette machine!");
}
public OnCasinoMessage(playerid, machineid, message[])
{
	new _msg[128];
	format(_msg, 128, "[CASINO] %s", message);
	SendClientMessage(playerid, 0xFF9900AA, _msg);
}
public OnCasinoMoney(playerid, machineid, amount, result)
{
	new message[128];
	if (result == CASINO_MONEY_CHARGE)
	{
		GivePlayerMoney(playerid, (amount * -1));
		format(message, 128, "[CASINO]{FFFFFF}  Vous avez parier %i$", amount);
	} else if (result == CASINO_MONEY_WIN)
	{
		GivePlayerMoney(playerid, amount);
		format(message, 128, "[CASINO]{FFFFFF} Vous avez gagné %i$", amount);
	} else {/*if (result == CASINO_MONEY_NOTENOUGH) {*/
		format(message, 128, "[CASINO]{FFFFFF}  Vous n'avez pas %i$ pour jouer!", amount);
	}
	SendClientMessage(playerid, 0xFF9900AA, message);
}
//slotmachine
script Prespin(playerid)
{
	new Float:rxL, Float:ryL, Float:rzL;
	new Float:rxM, Float:ryM, Float:rzM;
	new Float:rxR, Float:ryR, Float:rzR;
	GetPlayerObjectRot(playerid,LeftSpinner,rxL, ryL, rzL);
	GetPlayerObjectRot(playerid,LeftSpinner,rxM, ryM, rzM);
	GetPlayerObjectRot(playerid,LeftSpinner,rxR, ryR, rzR);
    if(movedup == false)
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  + ZOff,0.01,rxL + 120.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791  + ZOff,0.01,rxM + 120.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  + ZOff,0.01,rxR + 120.0, 0.00,-90.0);
		movedup = true;
	}
	else
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  - ZOff,0.01,rxL + 120.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791   - ZOff,0.01,rxM + 120.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  - ZOff,0.01,rxR + 120.0, 0.00,-90.0);
		movedup = false;
	}
	return 1;
}
script SpinSpinners(playerid)
{
	KillTimer(PreSpinTimer);
	new RandSL = random(sizeof(Rotations));
	new RandSM = random(sizeof(Rotations));
	new RandSR = random(sizeof(Rotations));
	if(movedup == false)
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  + ZOff,0.1,Rotations[RandSL] + 5.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791  + ZOff,0.1,Rotations[RandSM] + 5.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  + ZOff,0.1,Rotations[RandSR] + 5.0, 0.00,-90.0);
	}
	else
	{
	    MovePlayerObject(playerid, LeftSpinner,2236.6072, 1601.0479, 1000.6791  - ZOff,0.1,Rotations[RandSL] + 5.0, 0.00,-90.0);
	    MovePlayerObject(playerid, MiddleSpinner,2236.6072, 1600.9279, 1000.6791  - ZOff,0.1,Rotations[RandSM] + 5.0, 0.00,-90.0);
		MovePlayerObject(playerid, RightSpinner,2236.6072, 1600.8079, 1000.6791  - ZOff,0.1,Rotations[RandSR]+ 5.0, 0.00,-90.0);
	}
	SymbolSL = ResultIDsLeft[RandSL];
	SymbolSM = ResultIDsMiddle[RandSM];
	SymbolSR = ResultIDsRight[RandSR];
	GiveResult(playerid);
	return 1;
}
script GiveResult(playerid)
{
    IsSpinning[playerid] = false;
	TextDrawSetString(PlayerEnum[playerid][Textdraw2],ResultNames[SymbolSL - 1]);
	TextDrawSetString(PlayerEnum[playerid][Textdraw3],ResultNames[SymbolSM - 1]);
	TextDrawSetString(PlayerEnum[playerid][Textdraw4],ResultNames[SymbolSR - 1]);
	TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw2]); //Left result
	TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw3]); //Middle result
	TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw4]); //Right result
	if(SymbolSL == SymbolSM && SymbolSM == SymbolSR && SymbolSL == SymbolSR) //If all the symbols are the same
	{
		TextDrawShowForPlayer(playerid, PlayerEnum[playerid][Textdraw5]);
		if(SymbolSL == 1) //If the first symbol (thus the other two too) is Symbol ID 1 (goldbar)
		{
		    new doublebar[16];
		    format(doublebar,sizeof(doublebar),"= ~r~~h~$%i",REWARD_DOUBLEBAR);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw29],doublebar);
            GivePlayerMoney(playerid,REWARD_DOUBLEBAR);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_DOUBLEBAR;
            PlayerPlaySound(playerid,5461,0,0,0);
		}
		else if(SymbolSL == 2)
		{
		    new bar[16];
		    format(bar,sizeof(bar),"= ~r~~h~$%i",REWARD_BAR);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw28],bar);
            GivePlayerMoney(playerid,REWARD_BAR);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_BAR;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else if(SymbolSL == 3)
		{
		    new sixtynine[16];
		    format(sixtynine,sizeof(sixtynine),"= ~r~~h~$%i",REWARD_SIXTYNINE);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw24],sixtynine);
            GivePlayerMoney(playerid,REWARD_SIXTYNINE);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_SIXTYNINE;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else if(SymbolSL == 4)
		{
		    new bell[16];
		    format(bell,sizeof(bell),"= ~r~~h~$%i",REWARD_BELL);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw27],bell);
            GivePlayerMoney(playerid,REWARD_BELL);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_BELL;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else if(SymbolSL == 5)
		{
		    new grapes[16];
		    format(grapes,sizeof(grapes),"= ~r~~h~$%i",REWARD_GRAPES);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw25],grapes);
            GivePlayerMoney(playerid,REWARD_GRAPES);
            PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_GRAPES;
            PlayerPlaySound(playerid,5448,0,0,0);
		}
		else
		{
		    new cherry[16];
		    format(cherry,sizeof(cherry),"= ~r~~h~$%i",REWARD_CHERRY);
		    TextDrawSetString(PlayerEnum[playerid][Textdraw26],cherry);
		    GivePlayerMoney(playerid,REWARD_CHERRY);
		    PlayerEnum[playerid][TotalWon] = PlayerEnum[playerid][TotalWon] + REWARD_CHERRY;
		    PlayerPlaySound(playerid,5448,0,0,0);
		}
	}
	SetPlayerWonPaid(playerid);
}
script SetPlayerWonPaid(playerid)
{
	new PaidString[32], WonString[32], TotalString[32];
	PlayerEnum[playerid][TotalTotal] = PlayerEnum[playerid][TotalWon] - PlayerEnum[playerid][TotalPaid];
	format(PaidString,sizeof(PaidString),"~w~paid:    ~r~$%i",PlayerEnum[playerid][TotalPaid]);
    format(WonString,sizeof(WonString),"~w~won:   ~g~$%i",PlayerEnum[playerid][TotalWon]);
    if(PlayerEnum[playerid][TotalTotal] > 0)
    {
        format(TotalString,sizeof(TotalString),"~w~total:    ~g~+$%i",PlayerEnum[playerid][TotalTotal]);
    }
    else if(PlayerEnum[playerid][TotalTotal] == 0)
    {
        format(TotalString,sizeof(TotalString),"~w~total:    ~y~$%i",PlayerEnum[playerid][TotalTotal]);
    }
    else if(PlayerEnum[playerid][TotalTotal] < 0)
    {
        format(TotalString,sizeof(TotalString),"~w~total:    ~r~$%i",PlayerEnum[playerid][TotalTotal]);
    }
    TextDrawSetString(PlayerEnum[playerid][Textdraw32],WonString);
    TextDrawSetString(PlayerEnum[playerid][Textdraw34],TotalString);
    TextDrawSetString(PlayerEnum[playerid][Textdraw35],PaidString);
    TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw32]);
    TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw34]);
    TextDrawShowForPlayer(playerid,PlayerEnum[playerid][Textdraw35]);
	return 1;
}
//tuning
script TuneThisCar(vehicleid)
{
		if(TuneCar[vehicleid][mod1]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod1]); }
		if(TuneCar[vehicleid][mod2]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod2]); }
		if(TuneCar[vehicleid][mod3]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod3]); }
		if(TuneCar[vehicleid][mod4]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod4]); }
		if(TuneCar[vehicleid][mod5]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod5]); }
		if(TuneCar[vehicleid][mod6]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod6]); }
		if(TuneCar[vehicleid][mod7]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod7]); }
		if(TuneCar[vehicleid][mod8]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod8]); }
		if(TuneCar[vehicleid][mod9]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod9]); }
		if(TuneCar[vehicleid][mod10]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod10]); }
		if(TuneCar[vehicleid][mod11]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod11]); }
		if(TuneCar[vehicleid][mod12]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod12]); }
		if(TuneCar[vehicleid][mod13]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod13]); }
		if(TuneCar[vehicleid][mod14]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod14]); }
		if(TuneCar[vehicleid][mod15]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod15]); }
		if(TuneCar[vehicleid][mod16]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod16]); }
		if(TuneCar[vehicleid][mod17]!=0) { AddVehicleComponent(vehicleid,TuneCar[vehicleid][mod17]); }
		if(TuneCar[vehicleid][colorA]!=0 || TuneCar[vehicleid][colorB]!=0)
		{
			ChangeVehicleColor(vehicleid,TuneCar[vehicleid][colorA],TuneCar[vehicleid][colorB]);
		}
		if(TuneCar[vehicleid][paintjob]!=0) { ChangeVehiclePaintjob(vehicleid,TuneCar[vehicleid][paintjob]); }
		return 1;
}
InitComponents(componentid)
{
	new i;
	for(i=0; i<20; i++)
	{
	    if(spoiler[i][0]==componentid) { return 1; }
	}
	for(i=0; i<3; i++)
	{
	    if(nitro[i][0]==componentid) { return 2; }
	}
	for(i=0; i<23; i++)
	{
	    if(fbumper[i][0]==componentid) { return 3; }
	}
	for(i=0; i<22; i++)
	{
	    if(rbumper[i][0]==componentid) { return 4; }
	}
	for(i=0; i<28; i++)
	{
	    if(exhaust[i][0]==componentid) { return 5; }
	}
	for(i=0; i<2; i++)
	{
	    if(bventr[i][0]==componentid) { return 6; }
	}
	for(i=0; i<2; i++)
	{
	    if(bventl[i][0]==componentid) { return 7; }
	}
	for(i=0; i<4; i++)
	{
	    if(bscoop[i][0]==componentid) { return 8; }
	}
	for(i=0; i<13; i++)
	{
	    if(rscoop[i][0]==componentid) { return 9; }
	}
	for(i=0; i<21; i++)
	{
	    if(lskirt[i][0]==componentid) { return 10; }
	}
	for(i=0; i<21; i++)
	{
	    if(rskirt[i][0]==componentid) { return 11; }
	}
	if(hydraulics[0][0]==componentid) { return 12; }
	if(base[0][0]==componentid) { return 13; }
	for(i=0; i<2; i++)
	{
	    if(rbbars[i][0]==componentid) { return 14; }
	}
	for(i=0; i<2; i++)
	{
	    if(fbbars[i][0]==componentid) { return 15; }
	}
	for(i=0; i<17; i++)
	{
	    if(wheels[i][0]==componentid) { return 16; }
	}
	for(i=0; i<2; i++)
	{
	    if(lights1[i][0]==componentid) { return 17; }
	}
	return 0;
}
script LoadModsForAll()
{
	static rows,fields;
	cache_get_data(rows, fields, mysql);
	for (new vehicleid = 0; vehicleid < rows; vehicleid ++) if (vehicleid < MAX_DYNAMIC_CARS)
	{
	    TuneCar[vehicleid][carid] = cache_get_field_int(vehicleid, "ID");
		TuneCar[vehicleid][mod1] = cache_get_field_int(vehicleid, "mod1");
		TuneCar[vehicleid][mod2] = cache_get_field_int(vehicleid, "mod2");
		TuneCar[vehicleid][mod3] = cache_get_field_int(vehicleid, "mod3");
		TuneCar[vehicleid][mod4] = cache_get_field_int(vehicleid, "mod4");
		TuneCar[vehicleid][mod5] = cache_get_field_int(vehicleid, "mod5");

		TuneCar[vehicleid][mod6] = cache_get_field_int(vehicleid, "mod6");
		TuneCar[vehicleid][mod7] = cache_get_field_int(vehicleid, "mod7");
		TuneCar[vehicleid][mod8] = cache_get_field_int(vehicleid, "mod8");
		TuneCar[vehicleid][mod9] = cache_get_field_int(vehicleid, "mod9");
		TuneCar[vehicleid][mod10] = cache_get_field_int(vehicleid, "mod10");

		TuneCar[vehicleid][mod11] = cache_get_field_int(vehicleid, "mod11");
		TuneCar[vehicleid][mod12] = cache_get_field_int(vehicleid, "mod12");
		TuneCar[vehicleid][mod13] = cache_get_field_int(vehicleid, "mod13");
		TuneCar[vehicleid][mod14] = cache_get_field_int(vehicleid, "mod14");
		TuneCar[vehicleid][mod15] = cache_get_field_int(vehicleid, "mod15");

		TuneCar[vehicleid][mod16] = cache_get_field_int(vehicleid, "mod16");
		TuneCar[vehicleid][mod17] = cache_get_field_int(vehicleid, "mod17");
		TuneCar[vehicleid][paintjob] = cache_get_field_int(vehicleid, "paintjob");
		TuneCar[vehicleid][colorA] = cache_get_field_int(vehicleid, "color1");
		TuneCar[vehicleid][colorB] = cache_get_field_int(vehicleid, "color2");
	}
	return 1;
}
script SaveModsForAll(vehicleid) //quand on descend du vehicule et plutard quand on le créer
{
	static query[900];
	mysql_format(mysql, query, sizeof(query),"INSERT INTO `vehicle` (`ID`,`Mod1`, `Mod2`, `Mod3`, `Mod4`, `Mod5`, `Mod6`, `Mod7`, `Mod8`, `Mod9`, `Mod10`, `Mod11`, `Mod12`, `Mod13`, `Mod14`, `Mod15`, `Mod16`, `Mod17`, `paintjob`, `color1`, `color2`) \
	VALUES(`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`)",
		GetPlayerVehicleID(vehicleid),
		TuneCar[vehicleid][mod1],
		TuneCar[vehicleid][mod2],
		TuneCar[vehicleid][mod3],
		TuneCar[vehicleid][mod4],
		TuneCar[vehicleid][mod5],
		TuneCar[vehicleid][mod6],
		TuneCar[vehicleid][mod7],
		TuneCar[vehicleid][mod8],
		TuneCar[vehicleid][mod9],
		TuneCar[vehicleid][mod10],
		TuneCar[vehicleid][mod11],
		TuneCar[vehicleid][mod12],
		TuneCar[vehicleid][mod13],
		TuneCar[vehicleid][mod14],
		TuneCar[vehicleid][mod15],
		TuneCar[vehicleid][mod16],
		TuneCar[vehicleid][mod17],
		TuneCar[vehicleid][paintjob],
		TuneCar[vehicleid][colorA],
		TuneCar[vehicleid][colorB]
	);
	return mysql_tquery(mysql, query);
}
script SaveModsForTune(vehicleid) //quand on tune le vehicule
{
	static query[900];
	mysql_format(mysql, query, sizeof(query),"UPDATE `vehicle` (`Mod1`, `Mod2`, `Mod3`, `Mod4`, `Mod5`, `Mod6`, `Mod7`, `Mod8`, `Mod9`, `Mod10`, `Mod11`, `Mod12`, `Mod13`, `Mod14`, `Mod15`, `Mod16`, `Mod17`, `paintjob`, `color1`, `color2`) \
	VALUES(`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d`,`%d` WHERE `ID` = '%d')",
		TuneCar[vehicleid][mod1],
		TuneCar[vehicleid][mod2],
		TuneCar[vehicleid][mod3],
		TuneCar[vehicleid][mod4],
		TuneCar[vehicleid][mod5],
		TuneCar[vehicleid][mod6],
		TuneCar[vehicleid][mod7],
		TuneCar[vehicleid][mod8],
		TuneCar[vehicleid][mod9],
		TuneCar[vehicleid][mod10],
		TuneCar[vehicleid][mod11],
		TuneCar[vehicleid][mod12],
		TuneCar[vehicleid][mod13],
		TuneCar[vehicleid][mod14],
		TuneCar[vehicleid][mod15],
		TuneCar[vehicleid][mod16],
		TuneCar[vehicleid][mod17],
		TuneCar[vehicleid][paintjob],
		TuneCar[vehicleid][colorA],
		TuneCar[vehicleid][colorB],
		TuneCar[vehicleid][carid]
	);
	return mysql_tquery(mysql, query);
}
//new callbacks
public OnPlayerPause(playerid)
{
    if(IsPlayerStreamedIn(0, playerid)) SendClientMessage(playerid, -1, "Joueur en RW/PAUSE");
	return 1;
}
public OnPlayerResume(playerid, time)
{
    if(IsPlayerStreamedIn(0, playerid)) SendClientMessage(playerid, -1, "Joueur revenue");
	return 1;
}
public OnPlayerHoldingKey(playerid, keys)
{
	if(keys == KEY_NO) return SendClientMessage(playerid,0xDEFEA1,"holding aim");
	return 1;
}
public OnPlayerReleaseKey(playerid, keys, time)
{
    if(keys == KEY_NO) return SendClientMessage(playerid,0xDEFEA1,"holding aim no more");
	return 1;
}
//stock et autre
stock GetSeconds(seconds)
{
	seconds = seconds * 1000;
	return seconds;
}

stock GetMinutes(minutes)
{
	minutes = minutes * 60 * 1000;
	return minutes;
}
script CC(playerid, linii)
{
	if (IsPlayerConnected(playerid))
	{
		for(new i=0; i< linii; i++)
		{
			SCM(playerid, COLOR_WHITE,"");
		}
	}
	return 1;
}
//video pocker
stock CasinoGetPlayerMoney(playerid)
{
	return GetPlayerMoney(playerid);
}
script LoginRemains(playerid)
{
    if(PlayerInfo[playerid][pLogged] == 1)
    {
        KillTimer(LoginTimer[playerid]);
        return 1;
    }
    LoginSeconds[playerid] --;
    if(LoginSeconds[playerid] < 1)
    {
		Dialog_Show(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"SERVEUR: {FFFFFF}LOGIN","{FFFFFF}Bienvenu sur le serveur,\nVeuiller entrer votre mot de passe!\nTu a été {cc2a36}éjecté {FFFFFF}du serveur!","Proceed","Quit", LoginSeconds[playerid]);
        KillTimer(LoginTimer[playerid]);
        Kick(playerid);
    }
    return 1;
}
script HidePlayerFooter(playerid) {

	if (!PlayerInfo[playerid][pShowFooter])
	    return 0;

	PlayerInfo[playerid][pShowFooter] = false;
	return TextDrawHideForPlayer(playerid, PlayerEnum[playerid][Textdraw38]);
}
stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static args,str[144];
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		SendClientMessage(playerid, color, str);
		#emit RETN
	}
	return 1;
}
stock Log_Write(const path[], const str[], {Float,_}:...)
{
	static args,start,end,File:file,string[1024];
	if ((start = strfind(path, "/")) != -1) {
	    strmid(string, path, 0, start + 1);

	    if (!fexist(string))
	        return printf("** Warning: Directory \"%s\" doesn't exist.", string);
	}
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	file = fopen(path, io_append);
	if (!file) return 0;
	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 1024
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
		fwrite(file, string);
		fwrite(file, "\r\n");
		fclose(file);
		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	fwrite(file, str);
	fwrite(file, "\r\n");
	fclose(file);
	return 1;
}
stock SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
        foreach (new i : Player)
		{
			if (IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
stock SendAdminMessage(color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
        foreach (new i : Player)
		{
			if (PlayerInfo[i][pAdmin] > 0) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pAdmin] > 0) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
stock SendAdminAlert(color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
        foreach (new i : Player)
		{
			if (PlayerInfo[i][pAdmin] > 0){
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pAdmin] >= 1) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
stock SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
	static args, str[144];
	if ((args = numargs()) == 2) {SendClientMessageToAll(color, text);}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		SendClientMessageToAll(color, str);
		#emit RETN
	}
	return 1;
}
ReturnDate()
{
	static date[36];
	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);
	format(date, sizeof(date), "%02d/%02d/%d, %02d:%02d", date[0], date[1], date[2], date[3], date[4]);
	return date;
}
stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static Float:fX,Float:fY,Float:fZ;
	GetPlayerPos(targetid, fX, fY, fZ);
	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}
stock ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	PlayerInfo[playerid][pLoopAnim] = true;
	ShowPlayerFooter(playerid, "Appuyer  sur ~y~SPRINT~w~ to stop the animation.");
	return 1;
}
stock AnimationCheck(playerid) {return (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT);}
stock PreloadAnimations(playerid)
{
	for (new i = 0; i < sizeof(g_aPreloadLibs); i ++) {
	    ApplyAnimation(playerid, g_aPreloadLibs[i], "null", 4.0, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
stock ShowPlayerFooter(playerid, string[], time = 5000) {
	if (PlayerInfo[playerid][pShowFooter]) {
	    TextDrawHideForPlayer(playerid, PlayerEnum[playerid][Textdraw38]);
	    KillTimer(PlayerInfo[playerid][pFooterTimer]);
	}
	TextDrawSetString(PlayerEnum[playerid][Textdraw38], string);
	TextDrawShowForPlayer(playerid, PlayerEnum[playerid][Textdraw38]);
	PlayerInfo[playerid][pShowFooter] = true;
	PlayerInfo[playerid][pFooterTimer] = SetTimerEx("HidePlayerFooter", time, false, "d", playerid);
}
ReturnName(playerid, underscore=1)
{
	static
	    name[MAX_PLAYER_NAME + 1];

	GetPlayerName(playerid, name, sizeof(name));

	if (!underscore) {
	    for (new i = 0, len = strlen(name); i < len; i ++) {
	        if (name[i] == '_') name[i] = ' ';
		}
	}
	return name;
}
ResetWeapons(playerid)
{
	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) {
		gPlayerWeapons[playerid][i][0] = 0;
		gPlayerWeapons[playerid][i][1] = 0;
	}
	return 1;
}
GiveMoney(playerid, amount)
{
	PlayerInfo[playerid][pMoney] += amount;
	GivePlayerMoney(playerid, amount);
	return 1;
}
FormatNumber(number, suffix[] = "")
{
	static value[32],length;
	format(value, sizeof(value), "%d$", (number < 0) ? (-number) : (number));
	if ((length = strlen(value)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) {
		    if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
		}
	}
	if (suffix[0] != 0)
	    strins(value,suffix,1);
	if (number < 0)
		strins(value, "-", 0);
	return value;
}
KickEx(playerid)
{
	if (PlayerInfo[playerid][pKicked])
	    return 0;
	PlayerInfo[playerid][pKicked] = 1;
	SetTimerEx("KickTimer", 200, false, "d", playerid);
	return 1;
}
Report_GetCount(playerid)
{
	new count;

    for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
	    {
	        count++;
		}
	}
	return count;
}

Report_Clear(playerid)
{
    for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
	    {
	        Report_Remove(i);
		}
	}
	return 1;
}

Report_Add(playerid, const text[], type = 1)
{
	for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (!ReportData[i][rExists])
	    {
	        ReportData[i][rExists] = true;
	        ReportData[i][rType] = type;
	        ReportData[i][rPlayer] = playerid;
	        strpack(ReportData[i][rText], text, 128 char);
			return i;
		}
	}
	return -1;
}
Report_Remove(reportid)
{
	if (reportid != -1 && ReportData[reportid][rExists])
	{
	    ReportData[reportid][rExists] = false;
	    ReportData[reportid][rPlayer] = INVALID_PLAYER_ID;
	}
	return 1;
}
SendPlayerToPlayer(playerid, targetid)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(targetid, x, y, z);
	if (IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
	}
	else SetPlayerPosEx(playerid, x + 1, y, z);
	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
}
stock SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, time = 1500)
{
	if (PlayerInfo[playerid][pFreeze])
	{
	    KillTimer(PlayerInfo[playerid][pFreezeTimer]);
	    PlayerInfo[playerid][pFreeze] = 0;
	    TogglePlayerControllable(playerid, 1);
	}
	SetPlayerPos(playerid, x, y, z + 0.5);
	TogglePlayerControllable(playerid, 0);
	PlayerInfo[playerid][pFreeze] = 1;
	PlayerInfo[playerid][pFreezeTimer] = SetTimerEx("SetPlayerToUnfreeze", time, false, "dfff", playerid, x, y, z);
	return 1;
}
stock GetDotXY(Float:StartPosX, Float:StartPosY, &Float:NewX, &Float:NewY, Float:alpha, Float:dist)
{
	 NewX = StartPosX + (dist * floatsin(alpha, degrees));
	 NewY = StartPosY + (dist * floatcos(alpha, degrees));
}
stock RestartCheck()
{
	static time[3],string[32];
	if (g_ServerRestart == 1 && !g_RestartTime)
	{
		foreach (new i : Player) {
			KickEx(i);
		}
		SendRconCommand("gmx");
	}
	else if (g_ServerRestart == 1) {
		GetElapsedTime(g_RestartTime--, time[0], time[1], time[2]);
		format(string, 32, "~r~Serveur Restart:~w~ %02d:%02d", time[1], time[2]);
	    TextDrawSetString(gServerTextdraws[1], string);
	}
	return 1;
}
cache_get_field_int(row, const field_name[])
{
	new str[12];
	cache_get_field_content(row, field_name, str, mysql, sizeof(str));
	return strval(str);
}
AntiDeAMX()
{
	new b;
	#emit load.s.pri b
	#emit stor.s.pri b
	#emit load.alt b
	#emit stor.alt b
	#emit load.s.alt b
	#emit stor.s.alt b
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
