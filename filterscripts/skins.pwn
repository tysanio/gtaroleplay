#include <a_samp>
new SERVER_DOWNLOAD[] = "http://51.38.230.12/download/";
public OnPlayerRequestDownload(playerid, type, crc)
{
    new filename[128], filefound, final_url[256];
	if(!IsPlayerConnected(playerid))
		return 0;
	if(type == DOWNLOAD_REQUEST_TEXTURE_FILE)
		filefound = FindTextureFileNameFromCRC(crc, filename, sizeof(filename));
	else if(type == DOWNLOAD_REQUEST_MODEL_FILE)
		filefound = FindModelFileNameFromCRC(crc, filename, sizeof(filename));
    if(filefound)
    {
		format(final_url, sizeof(final_url), "%s/%s", SERVER_DOWNLOAD, filename);
		RedirectDownload(playerid, final_url);
	}
	return 1;
}
public OnFilterScriptInit()
{
AntiDeAMX();
//model du personnage
AddCharModel(192, 20001, "skins/clara.dff", "skins/clara.txd");
/*AddCharModel(233, 20002, "skins/Mai_Shr.dff", "skins/Mai_Shr.txd");
AddCharModel(131, 20003, "skins/Tinaxs.dff", "skins/Tinaxs.txd");
AddCharModel(280, 20004, "skins/police1.dff", "skins/police1.txd");
AddCharModel(281, 20005, "skins/police2.dff", "skins/police2.txd");
AddCharModel(282, 20006, "skins/police3.dff", "skins/police3.txd");
AddCharModel(283, 20007, "skins/police4.dff", "skins/police4.txd");
AddCharModel(284, 20008, "skins/police5.dff", "skins/police5.txd");
AddCharModel(191, 20009, "skins/police6.dff", "skins/police6.txd");*/
AddCharModel(191, 20010, "skins/militiaf.dff", "skins/militiaf.txd");
AddCharModel(191, 20011, "skins/soldierf.dff", "skins/soldierf.txd");
//zombie skin
AddCharModel(31, 20012, "skins/zombie31.dff", "skins/zombie31.txd");
AddCharModel(31, 20013, "skins/zombie33.dff", "skins/zombie33.txd");
AddCharModel(31, 20014, "skins/zombie34.dff", "skins/zombie34.txd");
AddCharModel(31, 20015, "skins/zombie35.dff", "skins/zombie35.txd");
AddCharModel(31, 20016, "skins/zombie36.dff", "skins/zombie36.txd");
AddCharModel(31, 20017, "skins/zombie37.dff", "skins/zombie37.txd");
AddCharModel(31, 20018, "skins/zombie61.dff", "skins/zombie77.txd");
//object
return 1;
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
