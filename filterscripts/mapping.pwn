#include <a_samp>
#include <streamer>

#define PRISON_WORLD 															(10000)

#include <texasv1/map> //map général
//#include <texasv1/mapls>//map pour ls
#include <texasv1/maison>//ext/int

public OnFilterScriptInit()
{
    ConnectNPC("Albert_Folker","Albert");
	print("Mapping encours de chargement");
    CreateServerObjects();
    //CreateServerObjectsLosSantos(); //map pour ls
    MaisonIntEXT(); //mapping maison
	return 1;
}
public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerConnect(playerid)
{
    MaisonIntEXTREM(playerid);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}
