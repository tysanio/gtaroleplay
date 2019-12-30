 /*  SA-MP threaded HTTP/1.0 client for pawn
 *
 *  (c) Copyright 2012, Sergobago, Gamster, [ADM]_Gamster
 *
 */

// Include for FS_Colpac v2.0+

/*
native ScanPlayerDosExplode(playerid);
native ScanPlayerDosDetal(playerid);
native UpperToLower(text[]);
native ScanTextAntiBag(text[]);
*/

//Защита

//Проверка использования скрипта Explode

stock ScanPlayerDosExplode(playerid){
if(IsPlayerInAnyVehicle(playerid)){
new Float:hpcar;
new panelst2,doorst2,lightst2,tirest2;
GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panelst2,doorst2,lightst2,tirest2);
GetVehicleHealth(GetPlayerVehicleID(playerid),hpcar);
if(hpcar==250.0 && doorst2==67372036){
new Float:Xban,Float:Yban,Float:Zban;
GetPlayerPos(playerid, Xban,Yban,Zban);
SetVehicleHealth(GetPlayerVehicleID(playerid),0);
SetPlayerPos(playerid,Xban,Yban,Zban+5);
SetPlayerHealth(playerid, 0);}}return 1;}

//Проверка использования скрипта Car Flood

stock ScanPlayerDosDetal(playerid){
if(IsPlayerInAnyVehicle(playerid)){
new panelst,doorst,lightst,tirest;
GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panelst,doorst,lightst,tirest);
if(panelst==858993459 && doorst==67372036 && lightst==69){
new Float:Xban,Float:Yban,Float:Zban;
GetPlayerPos(playerid, Xban,Yban,Zban);
SetPlayerPos(playerid,Xban,Yban,Zban+5);
SetPlayerHealth(playerid, 0);}}return 1;}

//Защита чата:


//Антикапс

forward UpperToLower(text[]);
public UpperToLower(text[]) {
for (new i = 0; i < strlen(text); i++) {
if (text[i] > 64 && text[i] < 91 )
text[i] += 32;
else if (text[i] > 191 && text[i] < 224 )
text[i] += 32;
else if (text[i] == 168)
text[i] = 184;}return 1;}

//Антикраш от левых групп символов в чат, (например %s в PM чат)

stock ScanTextAntiBag(text[])
{
for (new ilisy=0;ilisy<strlen(text);ilisy++){
if(text[ilisy]==37 || text[ilisy]==92 || text[ilisy]==123 || text[ilisy]==125 || text[ilisy]==126) text[ilisy]=35;}return 1;}

