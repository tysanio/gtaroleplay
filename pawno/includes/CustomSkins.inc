//Custom skin support Include RogueDrifter 2018-1-13
#include <a_samp>

bool: IsPlayerUsingCustomSkin(playerid)
   return GetPlayerCustomSkin(playerid)<=0 ? (false) : (true);
   
GetPlayerSkinEx(playerid)
  return IsPlayerUsingCustomSkin(playerid) ? GetPlayerCustomSkin(playerid) : GetPlayerSkin(playerid);
  
#if defined _ALS_GetPlayerSkin 
  #undef GetPlayerSkin 
#else
#define _ALS_GetPlayerSkin
#endif
#define GetPlayerSkin GetPlayerSkinEx