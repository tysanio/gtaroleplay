/*
    * "pHouse", "pBusiness" and "pEntrance" represent the SQL ID. Use
	  "GetHouseByID", "GetBusinessByID" and "GetEntranceByID" to get the enum ID
	  that can be used with "HouseData", "BusinessData" and "EntranceData".
	* "Inventory_Add" adds an item, "Inventory_Count" returns the quantity of the item
	  and "Inventory_Remove" removes an item. Use "Inventory_HasItem" to check if a player
	  has an item.
	Credits:
	* Emmet (original script)
 	* Apple (scripter)
 	* Risky (ran the server)
	Copyright(c) 2012-2015 Emmet Jones (All rights reserved).
*/
#include <a_samp>
#include <a_mysql1>
#include <texasv1/antiairbreak>
#include <foreach>
#include <easyDialog>
#include <eSelection>
#include <progress>
#include <progress2>
#include <sscanf2>
#include <streamer>
#include <zcmd>
#include <Encrypt> //truc a la con de marco
#include <fcnpc>
#include <ColAndreas>
#include <texasv1/discord-connector>
native IsValidVehicle(vehicleid);
//Include texas
#include <texasv1/extactor>
#include <texasv1/LB_TDBox>
#include <texasv1/define>
#include <texasv1/vars>
#include <texasv1/stock>
#include <texasv1/command>
#include <texasv1/stamina>
#include <texasv1/pop>
#include <texasv1/callback>
#include <texasv1/bowling>
#include <texasv1/GrimCasino>
#include <texasv1/zombie>
#include <texasv1/discordchat>
//#include <texasv1/vsync>
main()
{
    print(" ");
	print("88\"\"Yb  dP\"Yb  88     888888 88\"\"Yb 88        db    Yb  dP");
	print("88__dP dP   Yb 88     88__   88__dP 88       dPYb    YbdP");
	print("88\"Yb  Yb   dP 88  .o 88\"\"   88\"\"\"  88  .o  dP__Yb    8P");
	print("88  Yb  YbodP  88ood8 888888 88     88ood8 dP\"\"\"\"Yb  dP");
    print(" ");
}
script OnJailAccount(index)
{
	new string[128],name[24],rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	GetPVarString(index, "OnJailAccount", name, 24);
	//GetPVarString(index, "OnJailAccountReason", reason, 64);
	if(cache_affected_rows(g_iHandle)) {
		format(string, sizeof(string), "Vous avez emprisonné %s.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	else {
		format(string, sizeof(string), "Vous avez liberer %s.", name);
		SendClientMessageEx(index, COLOR_WHITE, string);
	}
	DeletePVar(index, "OnJailAccount");
	return 1;
}
script OnBillboardCreated(bizid)
{
	if (bizid == -1 || !BillBoardData[bizid][bbExists])
	    return 0;
	BillBoardData[bizid][bbID] = cache_insert_id(g_iHandle);
	Billboard_Save(bizid);
	return 1;
}
script Billboard_Load()
{
    new rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    BillBoardData[i][bbExists] = true;
	   	BillBoardData[i][bbID] = cache_get_field_int(i, "bbID");
		cache_get_field_content(i, "bbName", BillBoardData[i][bbName], g_iHandle, 32);
        cache_get_field_content(i, "bbMessage", BillBoardData[i][bbMessage], g_iHandle, 230);
		BillBoardData[i][bbOwner] = cache_get_field_int(i, "bbOwner");
		BillBoardData[i][bbPrice] = cache_get_field_int(i, "bbPrice");
		BillBoardData[i][bbRange] = cache_get_field_int(i, "bbRange");
		BillBoardData[i][bbPos][0] = cache_get_field_float(i, "bbPosX");
		BillBoardData[i][bbPos][1] = cache_get_field_float(i, "bbPosY");
		BillBoardData[i][bbPos][2] = cache_get_field_float(i, "bbPosZ");
		Billboard_Refresh(i);
	}
	return 1;
}
script OnViewBillboards(extraid, name[])
{
	new string[250],desc[250],rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	if (!rows)
	    return SendErrorMessage(extraid, "Pas de panneaux trouvé!");
	for (new i = 0; i < rows; i ++) {
	    cache_get_field_content(i, "bbName", desc, g_iHandle, sizeof(desc));
	    //format(string, sizeof(string), "%s{FFFFFF}%s ({FFBF00}%i{FFFFFF})\n", string, desc, i);
	    format(string, sizeof(string), "%s{FFFFFF}panneaux ({FFBF00}%i{FFFFFF}) | %s | $%d\n", string, i, desc, BillBoardData[i][bbPrice]);
	}
	format(desc, sizeof(desc), "Panneaux Publicitaire de la ville", name);
	Dialog_Show(extraid, Billboards, DIALOG_STYLE_LIST, desc, string, "Fermer", "");
	return 1;
}
script DestroyWater(objectid)
{
	if (IsValidDynamicObject(objectid))
	    DestroyDynamicObject(objectid);
	new moneyentrepriseid;
	argent_entreprise[moneyentrepriseid][argentmedecin] += random(50)+20;
	moneyentreprisesave(moneyentrepriseid);
	return 0;
}
script RandomFire()
{
	for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	{
	    g_aFireExtinguished[i] = 0;
	    if (IsValidDynamicObject(g_aFireObjects[i]))
	        DestroyDynamicObject(g_aFireObjects[i]);
	}
	switch (random(5))
	{
	    case 0:
	    {
			g_aFireObjects[0] = CreateDynamicObject(18691, 1930.4942, -1784.1799, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[1] = CreateDynamicObject(18691, 1930.5037, -1782.1473, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[2] = CreateDynamicObject(18691, 1930.5136, -1779.6364, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[3] = CreateDynamicObject(18691, 1930.5238, -1777.1058, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[4] = CreateDynamicObject(18691, 1930.5346, -1774.5141, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[5] = CreateDynamicObject(18691, 1930.5428, -1772.4306, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[6] = CreateDynamicObject(18691, 1930.5507, -1770.4219, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[7] = CreateDynamicObject(18691, 1930.5588, -1768.3559, 10.9368, 0.0, 0.0, 0.0);
			g_aFireObjects[8] = CreateDynamicObject(18691, 1929.1459, -1767.9173, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[9] = CreateDynamicObject(18691, 1928.8776, -1769.5853, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[10] = CreateDynamicObject(18691, 1928.8422, -1772.0158, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[11] = CreateDynamicObject(18691, 1928.8189, -1773.6047, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[12] = CreateDynamicObject(18691, 1928.8001, -1774.8883, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[13] = CreateDynamicObject(18691, 1928.7772, -1776.4462, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[14] = CreateDynamicObject(18691, 1928.7534, -1778.0637, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[15] = CreateDynamicObject(18691, 1928.7347, -1779.3225, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[16] = CreateDynamicObject(18691, 1928.7145, -1780.7152, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[17] = CreateDynamicObject(18691, 1928.6938, -1782.1208, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[18] = CreateDynamicObject(18691, 1928.6655, -1784.0491, 14.3093, 0.0, 0.0, 0.0);
			g_aFireObjects[19] = CreateDynamicObject(18691, 1935.3200, -1783.8045, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[20] = CreateDynamicObject(18691, 1935.2098, -1781.6428, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[21] = CreateDynamicObject(18691, 1935.0748, -1778.9934, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[22] = CreateDynamicObject(18691, 1934.9506, -1776.5572, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[23] = CreateDynamicObject(18691, 1934.8343, -1774.2791, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[24] = CreateDynamicObject(18691, 1934.7189, -1772.0156, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[25] = CreateDynamicObject(18691, 1934.6302, -1770.2773, 10.7728, 0.0, 0.0, 0.0);
			g_aFireObjects[26] = CreateDynamicObject(18691, 1934.5228, -1768.1666, 10.7728, 0.0, 0.0, 0.0);
		}
		case 1:
		{
			g_aFireObjects[0] = CreateDynamicObject(18691, 1238.8894, -1563.0980, 10.9999, 0.0, 0.0, 0.0);
			g_aFireObjects[1] = CreateDynamicObject(18691, 1241.6730, -1562.6481, 11.0068, 0.0, 0.0, 0.0);
			g_aFireObjects[2] = CreateDynamicObject(18691, 1243.2508, -1561.0845, 10.9444, 0.0, 0.0, 0.0);
			g_aFireObjects[3] = CreateDynamicObject(18691, 1245.5793, -1560.6265, 10.9450, 0.0, 0.0, 0.0);
			g_aFireObjects[4] = CreateDynamicObject(18691, 1247.4980, -1560.4841, 10.9455, 0.0, 0.0, 0.0);
			g_aFireObjects[5] = CreateDynamicObject(18691, 1249.9790, -1560.3701, 10.9539, 0.0, 0.0, 0.0);
			g_aFireObjects[6] = CreateDynamicObject(18691, 1249.5944, -1562.7432, 11.0053, 0.0, 0.0, 0.0);
			g_aFireObjects[7] = CreateDynamicObject(18691, 1247.4562, -1562.7996, 11.0045, 0.0, 0.0, 0.0);
			g_aFireObjects[8] = CreateDynamicObject(18691, 1245.7386, -1563.1572, 10.9990, 0.0, 0.0, 0.0);
			g_aFireObjects[9] = CreateDynamicObject(18691, 1243.7620, -1563.7636, 10.9896, 0.0, 0.0, 0.0);
			g_aFireObjects[10] = CreateDynamicObject(18691, 1242.2908, -1563.0959, 10.9999, 0.0, 0.0, 0.0);
			g_aFireObjects[11] = CreateDynamicObject(18691, 1242.3502, -1564.7818, 10.9740, 0.0, 0.0, 0.0);
			g_aFireObjects[12] = CreateDynamicObject(18691, 1244.8713, -1564.6507, 10.9760, 0.0, 0.0, 0.0);
			g_aFireObjects[13] = CreateDynamicObject(18691, 1246.8665, -1564.5694, 10.9772, 0.0, 0.0, 0.0);
			g_aFireObjects[14] = CreateDynamicObject(18691, 1249.1672, -1563.8638, 10.9881, 0.0, 0.0, 0.0);
			g_aFireObjects[15] = CreateDynamicObject(18691, 1250.8759, -1563.9959, 10.9861, 0.0, 0.0, 0.0);
			g_aFireObjects[16] = CreateDynamicObject(18691, 1252.2437, -1562.3538, 11.0113, 0.0, 0.0, 0.0);
			g_aFireObjects[17] = CreateDynamicObject(18691, 1252.4475, -1561.7529, 13.6369, 0.0, 0.0, 0.0);
			g_aFireObjects[18] = CreateDynamicObject(18691, 1250.9642, -1561.7822, 13.6519, 0.0, 0.0, 0.0);
			g_aFireObjects[19] = CreateDynamicObject(18691, 1248.5258, -1561.3541, 13.8278, 0.0, 0.0, 0.0);
			g_aFireObjects[20] = CreateDynamicObject(18691, 1245.9611, -1561.1191, 13.5507, 0.0, 0.0, 0.0);
			g_aFireObjects[21] = CreateDynamicObject(18691, 1242.7899, -1561.6608, 13.7519, 0.0, 0.0, 0.0);
			g_aFireObjects[22] = CreateDynamicObject(18691, 1250.3793, -1561.5445, 10.9462, 0.0, 0.0, 0.0);
			g_aFireObjects[23] = CreateDynamicObject(18691, 1252.8653, -1561.6358, 10.9468, 0.0, 0.0, 0.0);
			g_aFireObjects[24] = CreateDynamicObject(18691, 1252.9653, -1563.4675, 10.9942, 0.0, 0.0, 0.0);
			g_aFireObjects[25] = CreateDynamicObject(18691, 1252.5823, -1563.9747, 10.9864, 0.0, 0.0, 0.0);
		}
		case 2:
		{
		    g_aFireObjects[0] = CreateDynamicObject(18691, 1786.4844, -1164.2786, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[1] = CreateDynamicObject(18691, 1787.8876, -1164.3374, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[2] = CreateDynamicObject(18691, 1790.0416, -1164.8181, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[3] = CreateDynamicObject(18691, 1791.7430, -1165.1977, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[4] = CreateDynamicObject(18691, 1793.3637, -1165.5594, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[5] = CreateDynamicObject(18691, 1794.8229, -1165.8847, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[6] = CreateDynamicObject(18691, 1796.5830, -1166.2770, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[7] = CreateDynamicObject(18691, 1798.3182, -1166.6638, 21.2181, 0.0, 0.0, 0.0);
			g_aFireObjects[8] = CreateDynamicObject(18691, 1798.2283, -1166.9202, 22.1465, 0.0, 0.0, 0.0);
			g_aFireObjects[9] = CreateDynamicObject(18691, 1797.1246, -1166.2222, 22.5881, 0.0, 0.0, 0.0);
			g_aFireObjects[10] = CreateDynamicObject(18691, 1796.1480, -1165.5697, 22.5401, 0.0, 0.0, 0.0);
			g_aFireObjects[11] = CreateDynamicObject(18691, 1795.4377, -1165.1295, 22.1495, 0.0, 0.0, 0.0);
			g_aFireObjects[12] = CreateDynamicObject(18691, 1794.7139, -1164.6824, 21.4488, 0.0, 0.0, 0.0);
			g_aFireObjects[13] = CreateDynamicObject(18691, 1789.6914, -1164.0892, 22.3047, 0.0, 0.0, 0.0);
			g_aFireObjects[14] = CreateDynamicObject(18691, 1788.5687, -1163.1995, 22.3698, 0.0, 0.0, 0.0);
			g_aFireObjects[15] = CreateDynamicObject(18691, 1788.0295, -1162.8452, 21.9937, 0.0, 0.0, 0.0);
			g_aFireObjects[16] = CreateDynamicObject(18691, 1786.2319, -1163.1064, 21.8608, 0.0, 0.0, 0.0);
			g_aFireObjects[17] = CreateDynamicObject(18691, 1785.3194, -1163.1263, 21.9294, 0.0, 0.0, 0.0);
			g_aFireObjects[18] = CreateDynamicObject(18691, 1791.5643, -1163.1118, 21.3996, 0.0, 0.0, 0.0);
			g_aFireObjects[19] = CreateDynamicObject(18691, 1791.8800, -1164.3983, 22.2759, 0.0, 0.0, 0.0);
			g_aFireObjects[20] = CreateDynamicObject(18691, 1791.8519, -1165.1618, 22.5094, 0.0, 0.0, 0.0);
			g_aFireObjects[21] = CreateDynamicObject(18691, 1788.8287, -1163.4260, 22.0600, 0.0, 0.0, 0.0);
			g_aFireObjects[22] = CreateDynamicObject(18691, 1790.2512, -1164.0129, 21.2942, 0.0, 0.0, 0.0);
		}
		case 3:
		{
		    g_aFireObjects[0] = CreateDynamicObject(18691, 1315.0238, -1368.2282, 10.9438, 0.0, 0.0, 0.0);
			g_aFireObjects[1] = CreateDynamicObject(18691, 1314.0100, -1368.2265, 10.9438, 0.0, 0.0, 0.0);
			g_aFireObjects[2] = CreateDynamicObject(18691, 1312.6562, -1368.2235, 10.9399, 0.0, 0.0, 0.0);
			g_aFireObjects[3] = CreateDynamicObject(18691, 1311.8308, -1367.5294, 10.9296, 0.0, 0.0, 0.0);
			g_aFireObjects[4] = CreateDynamicObject(18691, 1310.9281, -1367.4926, 10.9273, 0.0, 0.0, 0.0);
			g_aFireObjects[5] = CreateDynamicObject(18691, 1309.7708, -1367.4902, 10.9252, 0.0, 0.0, 0.0);
			g_aFireObjects[6] = CreateDynamicObject(18691, 1308.6425, -1367.4877, 10.9232, 0.0, 0.0, 0.0);
			g_aFireObjects[7] = CreateDynamicObject(18691, 1307.3302, -1368.0213, 10.9332, 0.0, 0.0, 0.0);
			g_aFireObjects[8] = CreateDynamicObject(18691, 1306.0062, -1368.3232, 10.9355, 0.0, 0.0, 0.0);
			g_aFireObjects[9] = CreateDynamicObject(18691, 1304.3460, -1368.3197, 10.9354, 0.0, 0.0, 0.0);
			g_aFireObjects[10] = CreateDynamicObject(18691, 1304.4842, -1369.0036, 10.9451, 0.0, 0.0, 0.0);
			g_aFireObjects[11] = CreateDynamicObject(18691, 1305.8629, -1369.4384, 10.9513, 0.0, 0.0, 0.0);
			g_aFireObjects[12] = CreateDynamicObject(18691, 1307.2315, -1369.3804, 10.9512, 0.0, 0.0, 0.0);
			g_aFireObjects[13] = CreateDynamicObject(18691, 1309.0936, -1369.7593, 10.9550, 0.0, 0.0, 0.0);
			g_aFireObjects[14] = CreateDynamicObject(18691, 1310.8515, -1369.5230, 10.9544, 0.0, 0.0, 0.0);
			g_aFireObjects[15] = CreateDynamicObject(18691, 1312.0820, -1369.2214, 10.9522, 0.0, 0.0, 0.0);
			g_aFireObjects[16] = CreateDynamicObject(18691, 1309.4581, -1367.9462, 13.2241, 0.0, 0.0, 0.0);
			g_aFireObjects[17] = CreateDynamicObject(18691, 1307.8933, -1367.5498, 13.5101, 0.0, 0.0, 0.0);
			g_aFireObjects[18] = CreateDynamicObject(18691, 1307.3311, -1369.9162, 13.0364, 0.0, 0.0, 0.0);
			g_aFireObjects[19] = CreateDynamicObject(18691, 1306.5539, -1370.5288, 12.7001, 0.0, 0.0, 0.0);
			g_aFireObjects[20] = CreateDynamicObject(18691, 1310.9852, -1369.3835, 12.2585, 0.0, 0.0, 0.0);
			g_aFireObjects[21] = CreateDynamicObject(18691, 1310.3361, -1370.6992, 12.9585, 0.0, 0.0, 0.0);
			g_aFireObjects[22] = CreateDynamicObject(18691, 1313.2864, -1370.2733, 10.9708, 0.0, 0.0, 0.0);
			g_aFireObjects[23] = CreateDynamicObject(18691, 1313.3056, -1371.2634, 10.9838, 0.0, 0.0, 0.0);
			g_aFireObjects[24] = CreateDynamicObject(18691, 1311.6168, -1370.8870, 10.9735, 0.0, 0.0, 0.0);
			g_aFireObjects[25] = CreateDynamicObject(18691, 1308.9244, -1371.1181, 10.9726, 0.0, 0.0, 0.0);
			g_aFireObjects[26] = CreateDynamicObject(18691, 1306.5335, -1370.7678, 10.9712, 0.0, 0.0, 0.0);
		}
		case 4:
		{
		    g_aFireObjects[0] = CreateDynamicObject(18691, 997.7821, -910.8650, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[1] = CreateDynamicObject(18691, 998.0914, -911.5863, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[2] = CreateDynamicObject(18691, 998.2116, -913.0366, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[3] = CreateDynamicObject(18691, 998.3492, -914.6963, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[4] = CreateDynamicObject(18691, 998.4992, -916.5079, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[5] = CreateDynamicObject(18691, 998.6508, -918.3324, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[6] = CreateDynamicObject(18691, 998.7961, -920.0861, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[7] = CreateDynamicObject(18691, 998.9600, -922.0629, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[8] = CreateDynamicObject(18691, 999.1196, -923.9867, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[9] = CreateDynamicObject(18691, 999.2616, -925.7003, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[10] = CreateDynamicObject(18691, 999.4187, -927.5945, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[11] = CreateDynamicObject(18691, 999.5601, -929.3013, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[12] = CreateDynamicObject(18691, 1000.5933, -931.6047, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[13] = CreateDynamicObject(18691, 1002.6428, -931.3463, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[14] = CreateDynamicObject(18691, 1004.6893, -931.3514, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[15] = CreateDynamicObject(18691, 1007.2104, -931.1424, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[16] = CreateDynamicObject(18691, 1009.8325, -930.9251, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[17] = CreateDynamicObject(18691, 1012.1341, -930.7343, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[18] = CreateDynamicObject(18691, 1014.4911, -930.5388, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[19] = CreateDynamicObject(18691, 1014.4734, -932.3157, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[20] = CreateDynamicObject(18691, 1013.0949, -932.3657, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[21] = CreateDynamicObject(18691, 1011.4746, -932.4245, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[22] = CreateDynamicObject(18691, 1009.7496, -932.4875, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[23] = CreateDynamicObject(18691, 1008.1029, -932.5473, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[24] = CreateDynamicObject(18691, 1006.0109, -932.6234, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[25] = CreateDynamicObject(18691, 1003.9039, -932.7000, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[26] = CreateDynamicObject(18691, 1002.0654, -932.7668, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[27] = CreateDynamicObject(18691, 1002.6585, -933.5130, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[28] = CreateDynamicObject(18691, 1004.5731, -933.4433, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[29] = CreateDynamicObject(18691, 1006.4688, -933.3743, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[30] = CreateDynamicObject(18691, 1008.4611, -933.3016, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[31] = CreateDynamicObject(18691, 1010.4176, -933.2304, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[32] = CreateDynamicObject(18691, 1012.0813, -933.1698, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[33] = CreateDynamicObject(18691, 1013.1374, -933.1314, 39.5696, 0.0, 0.0, 0.0);
			g_aFireObjects[34] = CreateDynamicObject(18691, 1015.3114, -933.0523, 39.5696, 0.0, 0.0, 0.0);
		}
	}
	new Float:fX,Float:fY,Float:fZ;
	GetDynamicObjectPos(g_aFireObjects[0], fX, fY, fZ);
	foreach (new i : Player)
	{
		new facass = PlayerData[i][pFaction];
		if (FactionData[facass][factionacces][5] == 1)
		{
			Waypoint_Set(i, "Au FEU!!", fX, fY, fZ);
			SendServerMessage(i,"RADIO: Un incendie a été repéré au %s (marquée sur la carte).", GetLocation(fX, fY, fZ));
		}
	}
	CreateExplosion(fX, fY, fZ, 12, 5.0);
	return 1;
}
script BreakCuffs(playerid, userid)
{
	if (PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid) || !Inventory_HasItem(playerid, "Pied de biche") || !IsPlayerNearPlayer(playerid, userid, 6.0) || !PlayerData[userid][pCuffed])
	    return 1;
	if (random(2))
	{
	    ShowPlayerFooter(playerid, "Vous avez ~r~rater~w~ votre coup.");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s n'est pas arriver a enlever ses menottes.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[userid][pCuffed] = 0;
	    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
	    ShowPlayerFooter(playerid, "Vous avez ~g~reussi~w~ votre coup.");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à réussi à enlever les menottes de %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	return 1;
}
script SpawnTimer(playerid)
{
	if (SQL_IsLogged(playerid)) {TogglePlayerControllable(playerid, 1);}
	return 1;
}
script RemoveAttachedObject(playerid, slot)
{
	if (IsPlayerConnected(playerid) && IsPlayerAttachedObjectSlotUsed(playerid, slot)) {RemovePlayerAttachedObject(playerid, slot);}
	return 1;
}
script MineTime(playerid) {PlayerData[playerid][pMineTime] = 0;}
script WoodTime(playerid) {PlayerData[playerid][pWoodTime] = 0;}
script DestroyBlood(objectid) {DestroyDynamicObject(objectid);}
script ExpireMarker(playerid)
{
	if (!PlayerData[playerid][pMarker])
	    return 0;
	else SetPlayerColor(playerid, DEFAULT_COLOR);
	return 1;
}
script HidePlayerBox(playerid, PlayerText:boxid)
{
	if (!IsPlayerConnected(playerid) || !SQL_IsLogged(playerid))
	    return 0;
	PlayerTextDrawHide(playerid, boxid);
	PlayerTextDrawDestroy(playerid, boxid);
	return 1;
}
script Advertise(playerid)
{
	if (!SQL_IsLogged(playerid) || !strlen(PlayerData[playerid][pAdvertise]))
	    return 0;
	new text[128];
	strunpack(text, PlayerData[playerid][pAdvertise]);
	foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
	    SendClientMessageEx(i, 0x00AA00FF, "Journal: %s (contacter: %d)", text, PlayerData[playerid][pPhone]);
	}
	PlayerData[playerid][pAdvertise][0] = 0;
	return 1;
}
script KickHouse(playerid, id)
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 || House_Nearest(playerid) != id)
	    return 0;
	switch (random(6))
	{
	    case 0..2:
	    {
	        ShowPlayerFooter(playerid, "Vous n'avez pas ~r~reussi~w~ a enfoncer la porte.");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s n'a pas réussi à enfoncer la porte.", ReturnName(playerid, 0));
		}
		default:
		{
		    HouseData[id][houseLocked] = 0;
		    House_Save(id);
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a réussi à enfoncer la porte.", ReturnName(playerid, 0));
		    ShowPlayerFooter(playerid, "Appuyer surer ~y~'F'~w~ pour entrer dans la maison.");
		}
	}
	return 1;
}
script KickBusiness(playerid, id)
{
    new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][3] == 0 || Business_Nearest(playerid) != id)
	    return 0;
	switch (random(6))
	{
	    case 0..2:
	    {
	        ShowPlayerFooter(playerid, "Vous n'avez pas ~r~reussi~w~ a enfoncer la porte.");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s n'a pas réussi à enfoncer la porte.", ReturnName(playerid, 0));
		}
		default:
		{
		    BusinessData[id][bizLocked] = 0;
		    Business_Save(id);

		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a réussi à enfoncer la porte.", ReturnName(playerid, 0));
		    ShowPlayerFooter(playerid, "Appuyer surer ~y~'F'~w~ pour entrer dans le magasin.");
		}
	}
	return 1;
}
script UpdateBooth(playerid, id)
{
	if (PlayerData[playerid][pRangeBooth] != id || !g_BoothUsed[id])
	    return 0;
	if (PlayerData[playerid][pTargets] == 10)
	{
	    PlayerData[playerid][pTargets] = 0;
	    switch (PlayerData[playerid][pTargetLevel]++)
	    {
	        case 0:
	        {
	            ResetPlayerWeapons(playerid);
				GiveWeaponToPlayer(playerid, 25, 15000);
	            SendServerMessage(playerid, "Vous avancez au prochain niveau (1/5).");
	        }
	        case 1:
	        {
	            ResetPlayerWeapons(playerid);
				GiveWeaponToPlayer(playerid, 28, 15000);
	            SendServerMessage(playerid, "Vous avancez au prochain niveau (2/5).");
	        }
	        case 2:
	        {
	            ResetPlayerWeapons(playerid);
				GiveWeaponToPlayer(playerid, 29, 15000);
	            SendServerMessage(playerid, "Vous avancez au prochain niveau (3/5).");
	        }
	        case 3:
	        {
	            ResetPlayerWeapons(playerid);
				GiveWeaponToPlayer(playerid, 30, 15000);
	            SendServerMessage(playerid, "Vous avancez au prochain niveau (4/5).");
	        }
	        case 4:
	        {
	            ResetPlayerWeapons(playerid);
				GiveWeaponToPlayer(playerid, 27, 15000);
	            SendServerMessage(playerid, "Vous avancez au prochain niveau (5/5).");
	        }
	        case 5:
	        {
	            Booth_Leave(playerid);
	            SendServerMessage(playerid, "Vous avez terminé le défi de tir! Vôtre maniment d'arme a augementé");
				PlayerData[playerid][pSkill][3] +=10;
				PlayerData[playerid][pSkill][4] +=10;
				PlayerData[playerid][pSkill][6] +=10;
				PlayerData[playerid][pSkill][7] +=10;
				PlayerData[playerid][pSkill][8] +=10;
				PlayerData[playerid][pSkill][9] +=10;
	        }
	    }
	}
	Booth_Refresh(playerid);
	return 1;
}
script CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new id = -1;
	if (GateData[gateid][gateExists] && GateData[gateid][gateOpened])
 	{
	 	MoveDynamicObject(GateData[gateid][gateObject], fX, fY, fZ, speed, fRotX, fRotY, fRotZ);
	 	if ((id = GetGateByID(linkid)) != -1)
            MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], speed, GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);
		GateData[id][gateOpened] = 0;
		return 1;
	}
	return 0;
}
script SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z)
{
	if (!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z))
	    return 0;
	PlayerData[playerid][pFreeze] = 0;
	SetPlayerPos(playerid, x, y, z);
	TogglePlayerControllable(playerid, 1);
	return 1;
}
script RefillUpdate(playerid, vehicleid)
{
    new idk = Car_GetID(vehicleid);
	if (!PlayerData[playerid][pFuelCan] || GetNearestVehicle(playerid) != vehicleid)
	    return 0;
	CarData[idk][carfuel] = (CarData[idk][carfuel] + 15 >= 100) ? (100) : (CarData[idk][carfuel] + 15);
    TogglePlayerControllable(playerid,1);
	PlayerData[playerid][pFuelCan] = 0;
	SendVehiculeMessage(playerid, "Vous avez rempli votre véhicule avec un jerrican d'essence.");
	return 1;
}
script Detector_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_METAL_DETECTORS)
	{
    	MetalDetectors[i][detectorExists] = 1;
	    MetalDetectors[i][detectorID] = cache_get_field_int(i, "detectorID");
	    MetalDetectors[i][detectorPos][0] = cache_get_field_float(i, "detectorX");
	    MetalDetectors[i][detectorPos][1] = cache_get_field_float(i, "detectorY");
	    MetalDetectors[i][detectorPos][2] = cache_get_field_float(i, "detectorZ");
	    MetalDetectors[i][detectorPos][3] = cache_get_field_float(i, "detectorAngle");
	    MetalDetectors[i][detectorInterior] = cache_get_field_int(i, "detectorInterior");
	    MetalDetectors[i][detectorWorld] = cache_get_field_int(i, "detectorWorld");
		Detector_Refresh(i);
	}
	return 1;
}
script Graffiti_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_GRAFFITI_POINTS)
	{
	    cache_get_field_content(i, "graffitiText", GraffitiData[i][graffitiText], g_iHandle, 64);
    	GraffitiData[i][graffitiExists] = 1;
	    GraffitiData[i][graffitiID] = cache_get_field_int(i, "graffitiID");
	    GraffitiData[i][graffitiPos][0] = cache_get_field_float(i, "graffitiX");
	    GraffitiData[i][graffitiPos][1] = cache_get_field_float(i, "graffitiY");
	    GraffitiData[i][graffitiPos][2] = cache_get_field_float(i, "graffitiZ");
	    GraffitiData[i][graffitiPos][3] = cache_get_field_float(i, "graffitiAngle");
	    GraffitiData[i][graffitiColor] = cache_get_field_int(i, "graffitiColor");
		Graffiti_Refresh(i);
	}
	return 1;
}
script Speed_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    SpeedData[i][speedExists] = true;
	    SpeedData[i][speedID] = cache_get_field_int(i, "speedID");
	    SpeedData[i][speedRange] = cache_get_field_float(i, "speedRange");
	    SpeedData[i][speedLimit] = cache_get_field_float(i, "speedLimit");
	    SpeedData[i][speedPos][0] = cache_get_field_float(i, "speedX");
	    SpeedData[i][speedPos][1] = cache_get_field_float(i, "speedY");
	    SpeedData[i][speedPos][2] = cache_get_field_float(i, "speedZ");
	    SpeedData[i][speedPos][3] = cache_get_field_float(i, "speedAngle");
	    Speed_Refresh(i);
	}
	return 1;
}
script Rack_Load()
{
    static rows,fields,str[24];
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_WEAPON_RACKS)
	{
	    RackData[i][rackExists] = true;
	    RackData[i][rackID] = cache_get_field_int(i, "rackID");
	    RackData[i][rackHouse] = cache_get_field_int(i, "rackHouse");
     	RackData[i][rackPos][0] = cache_get_field_float(i, "rackX");
        RackData[i][rackPos][1] = cache_get_field_float(i, "rackY");
        RackData[i][rackPos][2] = cache_get_field_float(i, "rackZ");
        RackData[i][rackPos][3] = cache_get_field_float(i, "rackA");
        RackData[i][rackInterior] = cache_get_field_int(i, "rackInterior");
		RackData[i][rackWorld] = cache_get_field_int(i, "rackWorld");
		for (new j = 0; j < 4; j ++) {
		    format(str, 24, "rackWeapon%d", j + 1);
		    RackData[i][rackWeapons][j] = cache_get_field_int(i, str);
            format(str, 24, "rackAmmo%d", j + 1);
		    RackData[i][rackAmmo][j] = cache_get_field_int(i, str);
		}
		Rack_Refresh(i);
	}
	return 1;
}
script Vendor_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    VendorData[i][vendorExists] = true;
	    VendorData[i][vendorID] = cache_get_field_int(i, "vendorID");
	    VendorData[i][vendorType] = cache_get_field_int(i, "vendorType");
	    VendorData[i][vendorPos][0] = cache_get_field_float(i, "vendorX");
        VendorData[i][vendorPos][1] = cache_get_field_float(i, "vendorY");
        VendorData[i][vendorPos][2] = cache_get_field_float(i, "vendorZ");
        VendorData[i][vendorPos][3] = cache_get_field_float(i, "vendorA");
        VendorData[i][vendorInterior] = cache_get_field_int(i, "vendorInterior");
		VendorData[i][vendorWorld] = cache_get_field_int(i, "vendorWorld");
		Vendor_Refresh(i);
	}
	return 1;
}
script Garbage_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    GarbageData[i][garbageExists] = true;
	    GarbageData[i][garbageID] = cache_get_field_int(i, "garbageID");
	    GarbageData[i][garbageModel] = cache_get_field_int(i, "garbageModel");
	    GarbageData[i][garbageCapacity] = cache_get_field_int(i, "garbageCapacity");
	    GarbageData[i][garbagePos][0] = cache_get_field_float(i, "garbageX");
        GarbageData[i][garbagePos][1] = cache_get_field_float(i, "garbageY");
        GarbageData[i][garbagePos][2] = cache_get_field_float(i, "garbageZ");
        GarbageData[i][garbagePos][3] = cache_get_field_float(i, "garbageA");
        GarbageData[i][garbageInterior] = cache_get_field_int(i, "garbageInterior");
		GarbageData[i][garbageWorld] = cache_get_field_int(i, "garbageWorld");
		Garbage_Refresh(i);
	}
	return 1;
}
script ATM_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    ATMData[i][atmExists] = true;
	    ATMData[i][atmID] = cache_get_field_int(i, "atmID");
	    ATMData[i][atmPos][0] = cache_get_field_float(i, "atmX");
        ATMData[i][atmPos][1] = cache_get_field_float(i, "atmY");
        ATMData[i][atmPos][2] = cache_get_field_float(i, "atmZ");
        ATMData[i][atmPos][3] = cache_get_field_float(i, "atmA");
        ATMData[i][atmInterior] = cache_get_field_int(i, "atmInterior");
		ATMData[i][atmWorld] = cache_get_field_int(i, "atmWorld");
		ATM_Refresh(i);
	}
	return 1;
}

script Impound_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    ImpoundData[i][impoundExists] = true;
	    ImpoundData[i][impoundID] = cache_get_field_int(i, "impoundID");
	    ImpoundData[i][impoundLot][0] = cache_get_field_float(i, "impoundLotX");
        ImpoundData[i][impoundLot][1] = cache_get_field_float(i, "impoundLotY");
        ImpoundData[i][impoundLot][2] = cache_get_field_float(i, "impoundLotZ");
        ImpoundData[i][impoundRelease][0] = cache_get_field_float(i, "impoundReleaseX");
        ImpoundData[i][impoundRelease][1] = cache_get_field_float(i, "impoundReleaseY");
        ImpoundData[i][impoundRelease][2] = cache_get_field_float(i, "impoundReleaseZ");
        ImpoundData[i][impoundRelease][3] = cache_get_field_float(i, "impoundReleaseA");
		Impound_Refresh(i);
	}
	return 1;
}
script Backpack_Load()
{
    static rows,fields,str[64];
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_BACKPACKS)
	{
	    BackpackData[i][backpackExists] = true;
	    BackpackData[i][backpackID] = cache_get_field_int(i, "backpackID");
	    BackpackData[i][backpackPlayer] = cache_get_field_int(i, "backpackPlayer");
	    BackpackData[i][backpackHouse] = cache_get_field_int(i, "backpackHouse");
	    BackpackData[i][backpackVehicle] = cache_get_field_int(i, "backpackVehicle");
	    BackpackData[i][backpackPos][0] = cache_get_field_float(i, "backpackX");
	    BackpackData[i][backpackPos][1] = cache_get_field_float(i, "backpackY");
	    BackpackData[i][backpackPos][2] = cache_get_field_float(i, "backpackZ");
	    BackpackData[i][backpackInterior] = cache_get_field_int(i, "backpackInterior");
	    BackpackData[i][backpackWorld] = cache_get_field_int(i, "backpackWorld");

	    if (!BackpackData[i][backpackPlayer]) {
	        Backpack_Refresh(i);
		}
	}
	for (new i = 0; i < MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists]) {
		format(str, sizeof(str), "SELECT * FROM `backpackitems` WHERE `ID` = '%d'", BackpackData[i][backpackID]);

		mysql_tquery(g_iHandle, str, "OnLoadBackpack", "d", i);
	}
	return 1;
}
script Gate_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    GateData[i][gateExists] = true;
	    GateData[i][gateOpened] = false;
	    GateData[i][gateID] = cache_get_field_int(i, "gateID");
	    GateData[i][gateModel] = cache_get_field_int(i, "gateModel");
	    GateData[i][gateSpeed] = cache_get_field_float(i, "gateSpeed");
	    GateData[i][gateRadius] = cache_get_field_float(i, "gateRadius");
	    GateData[i][gateTime] = cache_get_field_int(i, "gateTime");
	    GateData[i][gateInterior] = cache_get_field_int(i, "gateInterior");
	    GateData[i][gateWorld] = cache_get_field_int(i, "gateWorld");
	    GateData[i][gatePos][0] = cache_get_field_float(i, "gateX");
	    GateData[i][gatePos][1] = cache_get_field_float(i, "gateY");
	    GateData[i][gatePos][2] = cache_get_field_float(i, "gateZ");
	    GateData[i][gatePos][3] = cache_get_field_float(i, "gateRX");
	    GateData[i][gatePos][4] = cache_get_field_float(i, "gateRY");
	    GateData[i][gatePos][5] = cache_get_field_float(i, "gateRZ");
        GateData[i][gateMove][0] = cache_get_field_float(i, "gateMoveX");
	    GateData[i][gateMove][1] = cache_get_field_float(i, "gateMoveY");
	    GateData[i][gateMove][2] = cache_get_field_float(i, "gateMoveZ");
	    GateData[i][gateMove][3] = cache_get_field_float(i, "gateMoveRX");
	    GateData[i][gateMove][4] = cache_get_field_float(i, "gateMoveRY");
	    GateData[i][gateMove][5] = cache_get_field_float(i, "gateMoveRZ");
        GateData[i][gateLinkID] = cache_get_field_int(i, "gateLinkID");
	    GateData[i][gateFaction] = cache_get_field_int(i, "gateFaction");
	    cache_get_field_content(i, "gatePass", GateData[i][gatePass], g_iHandle, 32);
	    GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
	}
	return 1;
}
script batiement_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_batiementS)
	{
	    batiementData[i][batiementExists] = true;
	    batiementData[i][batiementID] = cache_get_field_int(i, "batiementID");
	    batiementData[i][batiementModel] = cache_get_field_int(i, "batiementModel");
	    batiementData[i][batiementInterior] = cache_get_field_int(i, "batiementInterior");
	    batiementData[i][batiementWorld] = cache_get_field_int(i, "batiementWorld");
	    batiementData[i][batiementPos][0] = cache_get_field_float(i, "batiementX");
	    batiementData[i][batiementPos][1] = cache_get_field_float(i, "batiementY");
	    batiementData[i][batiementPos][2] = cache_get_field_float(i, "batiementZ");
	    batiementData[i][batiementPos][3] = cache_get_field_float(i, "batiementRX");
	    batiementData[i][batiementPos][4] = cache_get_field_float(i, "batiementRY");
	    batiementData[i][batiementPos][5] = cache_get_field_float(i, "batiementRZ");
	    batiementData[i][batiementObject] = CreateDynamicObject(batiementData[i][batiementModel], batiementData[i][batiementPos][0], batiementData[i][batiementPos][1], batiementData[i][batiementPos][2], batiementData[i][batiementPos][3], batiementData[i][batiementPos][4], batiementData[i][batiementPos][5], batiementData[i][batiementWorld], batiementData[i][batiementInterior]);
	}
	return 1;
}
script Arrest_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_ARREST_POINTS)
	{
	    ArrestData[i][arrestExists] = true;

	    ArrestData[i][arrestID] = cache_get_field_int(i, "arrestID");
	    ArrestData[i][arrestPos][0] = cache_get_field_float(i, "arrestX");
	    ArrestData[i][arrestPos][1] = cache_get_field_float(i, "arrestY");
	    ArrestData[i][arrestPos][2] = cache_get_field_float(i, "arrestZ");
	    ArrestData[i][arrestInterior] = cache_get_field_int(i, "arrestInterior");
	    ArrestData[i][arrestWorld] = cache_get_field_int(i, "arrestWorld");

	    Arrest_Refresh(i);
	}
	return 1;
}
script Faction_Load()
{
	static rows,fields,str[32];
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_FACTIONS)
	{
	    FactionData[i][factionExists] = true;
	    FactionData[i][factionID] = cache_get_field_int(i, "factionID");

	    cache_get_field_content(i, "factionName", FactionData[i][factionName], g_iHandle, 32);
	    FactionData[i][factionRanks] = cache_get_field_int(i, "factionRanks");
	    FactionData[i][factionLockerPos][0] = cache_get_field_float(i, "factionLockerX");
	    FactionData[i][factionLockerPos][1] = cache_get_field_float(i, "factionLockerY");
	    FactionData[i][factionLockerPos][2] = cache_get_field_float(i, "factionLockerZ");
	    FactionData[i][factionLockerInt] = cache_get_field_int(i, "factionLockerInt");
	    FactionData[i][factionLockerWorld] = cache_get_field_int(i, "factionLockerWorld");
        FactionData[i][factioncoffre] = cache_get_field_int(i, "factioncoffre");
        cache_get_field_content(i, "factiondiscord", FactionData[i][factiondiscord], g_iHandle, 20);
        
	    for (new j = 0; j < 8; j ++) {
	        format(str, sizeof(str), "factionSkin%d", j + 1);
	        FactionData[i][factionSkins][j] = cache_get_field_int(i, str);
		}
        for (new j = 0; j < 10; j ++) {
	        format(str, sizeof(str), "factionWeapon%d", j + 1);
	        FactionData[i][factionWeapons][j] = cache_get_field_int(i, str);
	        format(str, sizeof(str), "factionAmmo%d", j + 1);
			FactionData[i][factionAmmo][j] = cache_get_field_int(i, str);
		}
		for (new j = 0; j < 15; j ++) {
		    format(str, sizeof(str), "factionRank%d", j + 1);
		    cache_get_field_content(i, str, FactionRanks[i][j], g_iHandle, 32);
		}
		for (new j = 0; j < 15; j ++) {
		    format(str, sizeof(str), "factionacces%d", j + 1);
		    FactionData[i][factionacces][j] = cache_get_field_int(i, str);
		    format(str, sizeof(str), "SalaireRank%d", j + 1);
		    FactionData[i][factionsalaire][j] = cache_get_field_int(i, str);
		}
		Faction_Refresh(i);
	}
	return 1;
}

script Plant_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DRUG_PLANTS)
	{
	    PlantData[i][plantExists] = true;
	    PlantData[i][plantID] = cache_get_field_int(i, "plantID");
	    PlantData[i][plantType] = cache_get_field_int(i, "plantType");
	    PlantData[i][plantDrugs] = cache_get_field_int(i, "plantDrugs");
	    PlantData[i][plantPos][0] = cache_get_field_float(i, "plantX");
	    PlantData[i][plantPos][1] = cache_get_field_float(i, "plantY");
	    PlantData[i][plantPos][2] = cache_get_field_float(i, "plantZ");
	    PlantData[i][plantPos][3] = cache_get_field_float(i, "plantA");
	    PlantData[i][plantInterior] = cache_get_field_int(i, "plantInterior");
	    PlantData[i][plantWorld] = cache_get_field_int(i, "plantWorld");
		Plant_Refresh(i);
	}
	return 1;
}

script Crate_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    CrateData[i][crateExists] = true;
	    CrateData[i][crateID] = cache_get_field_int(i, "crateID");
	    CrateData[i][crateType] = cache_get_field_int(i, "crateType");
	    CrateData[i][cratePos][0] = cache_get_field_float(i, "crateX");
	    CrateData[i][cratePos][1] = cache_get_field_float(i, "crateY");
	    CrateData[i][cratePos][2] = cache_get_field_float(i, "crateZ");
	    CrateData[i][cratePos][3] = cache_get_field_float(i, "crateA");
	    CrateData[i][crateInterior] = cache_get_field_int(i, "crateInterior");
	    CrateData[i][crateWorld] = cache_get_field_int(i, "crateWorld");
		CrateData[i][crateVehicle] = INVALID_VEHICLE_ID;
		Crate_Refresh(i);
	}
	return 1;
}

script Job_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
    for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_JOBS)
	{
	    JobData[i][jobExists] = true;
	    JobData[i][jobID] = cache_get_field_int(i, "jobID");
	    JobData[i][jobType] = cache_get_field_int(i, "jobType");
	    JobData[i][jobPos][0] = cache_get_field_float(i, "jobPosX");
	    JobData[i][jobPos][1] = cache_get_field_float(i, "jobPosY");
	    JobData[i][jobPos][2] = cache_get_field_float(i, "jobPosZ");
	    JobData[i][jobInterior] = cache_get_field_int(i, "jobInterior");
	    JobData[i][jobWorld] = cache_get_field_int(i, "jobWorld");
        JobData[i][jobPoint][0] = cache_get_field_float(i, "jobPointX");
	    JobData[i][jobPoint][1] = cache_get_field_float(i, "jobPointY");
	    JobData[i][jobPoint][2] = cache_get_field_float(i, "jobPointZ");
	    JobData[i][jobDeliver][0] = cache_get_field_float(i, "jobDeliverX");
	    JobData[i][jobDeliver][1] = cache_get_field_float(i, "jobDeliverY");
	    JobData[i][jobDeliver][2] = cache_get_field_float(i, "jobDeliverZ");
	    JobData[i][jobPointInt] = cache_get_field_int(i, "jobPointInt");
	    JobData[i][jobPointWorld] = cache_get_field_int(i, "jobPointWorld");
 	    Job_Refresh(i);
	}
	return 1;
}
script Entrance_Load()
{
    static rows,fields;
    cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_OBJ)
	{
	    EntranceData[i][entranceExists] = true;
    	EntranceData[i][entranceID] = cache_get_field_int(i, "entranceID");

		cache_get_field_content(i, "entranceName", EntranceData[i][entranceName], g_iHandle, 32);
		cache_get_field_content(i, "entrancePass", EntranceData[i][entrancePass], g_iHandle, 32);

	    EntranceData[i][entranceIcon] = cache_get_field_int(i, "entranceIcon");
	    EntranceData[i][entranceLocked] = cache_get_field_int(i, "entranceLocked");
	    EntranceData[i][entrancePos][0] = cache_get_field_float(i, "entrancePosX");
	    EntranceData[i][entrancePos][1] = cache_get_field_float(i, "entrancePosY");
	    EntranceData[i][entrancePos][2] = cache_get_field_float(i, "entrancePosZ");
	    EntranceData[i][entrancePos][3] = cache_get_field_float(i, "entrancePosA");
	    EntranceData[i][entranceInt][0] = cache_get_field_float(i, "entranceIntX");
	    EntranceData[i][entranceInt][1] = cache_get_field_float(i, "entranceIntY");
	    EntranceData[i][entranceInt][2] = cache_get_field_float(i, "entranceIntZ");
	    EntranceData[i][entranceInt][3] = cache_get_field_float(i, "entranceIntA");
	    EntranceData[i][entranceInterior] = cache_get_field_int(i, "entranceInterior");
	    EntranceData[i][entranceExterior] = cache_get_field_int(i, "entranceExterior");
	    EntranceData[i][entranceExteriorVW] = cache_get_field_int(i, "entranceExteriorVW");
	    EntranceData[i][entranceType] = cache_get_field_int(i, "entranceType");
	    EntranceData[i][entranceCustom] = cache_get_field_int(i, "entranceCustom");
	    EntranceData[i][entranceWorld] = cache_get_field_int(i, "entranceWorld");

		if (EntranceData[i][entranceType] == 3)
		    CreateForklifts(i);

	    Entrance_Refresh(i);
	}
	return 1;
}

script Dropped_Load()
{
	static rows,fields;
    cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_DROPPED_ITEMS)
	{
	    DroppedItems[i][droppedID] = cache_get_field_int(i, "ID");

		cache_get_field_content(i, "itemName", DroppedItems[i][droppedItem], g_iHandle, 32);
		cache_get_field_content(i, "itemPlayer", DroppedItems[i][droppedPlayer], g_iHandle, 24);

		DroppedItems[i][droppedModel] = cache_get_field_int(i, "itemModel");
		DroppedItems[i][droppedQuantity] = cache_get_field_int(i, "itemQuantity");
		DroppedItems[i][droppedWeapon] = cache_get_field_int(i, "itemWeapon");
		DroppedItems[i][droppedAmmo] = cache_get_field_int(i, "itemAmmo");
		DroppedItems[i][droppedPos][0] = cache_get_field_float(i, "itemX");
		DroppedItems[i][droppedPos][1] = cache_get_field_float(i, "itemY");
		DroppedItems[i][droppedPos][2] = cache_get_field_float(i, "itemZ");
		DroppedItems[i][droppedInt] = cache_get_field_int(i, "itemInt");
		DroppedItems[i][droppedWorld] = cache_get_field_int(i, "itemWorld");

		if (IsWeaponModel(DroppedItems[i][droppedModel])) {
    	   	DroppedItems[i][droppedObject] = CreateDynamicObject(DroppedItems[i][droppedModel], DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 93.7, 120.0, 120.0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
		} else {
			DroppedItems[i][droppedObject] = CreateDynamicObject(DroppedItems[i][droppedModel], DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 0.0, 0.0, 0.0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
		}
		DroppedItems[i][droppedText3D] = CreateDynamic3DTextLabel(DroppedItems[i][droppedItem], COLOR_CYAN, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
	}
	return 1;
}

script Business_Load()
{
    static rows,fields,str[64];
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_BUSINESSES)
	{
	    BusinessData[i][bizExists] = true;
	    BusinessData[i][bizID] = cache_get_field_int(i, "bizID");
		cache_get_field_content(i, "bizName", BusinessData[i][bizName], g_iHandle, 32);
        cache_get_field_content(i, "bizMessage", BusinessData[i][bizMessage], g_iHandle, 128);
		BusinessData[i][bizOwner] = cache_get_field_int(i, "bizOwner");
		BusinessData[i][bizType] = cache_get_field_int(i, "bizType");
		BusinessData[i][bizPrice] = cache_get_field_int(i, "bizPrice");
		BusinessData[i][bizPos][0] = cache_get_field_float(i, "bizPosX");
		BusinessData[i][bizPos][1] = cache_get_field_float(i, "bizPosY");
		BusinessData[i][bizPos][2] = cache_get_field_float(i, "bizPosZ");
		BusinessData[i][bizPos][3] = cache_get_field_float(i, "bizPosA");
		BusinessData[i][bizInt][0] = cache_get_field_float(i, "bizIntX");
		BusinessData[i][bizInt][1] = cache_get_field_float(i, "bizIntY");
		BusinessData[i][bizInt][2] = cache_get_field_float(i, "bizIntZ");
		BusinessData[i][bizInt][3] = cache_get_field_float(i, "bizIntA");
		BusinessData[i][bizSpawn][0] = cache_get_field_float(i, "bizSpawnX");
		BusinessData[i][bizSpawn][1] = cache_get_field_float(i, "bizSpawnY");
		BusinessData[i][bizSpawn][2] = cache_get_field_float(i, "bizSpawnZ");
		BusinessData[i][bizSpawn][3] = cache_get_field_float(i, "bizSpawnA");
		BusinessData[i][bizDeliver][0] = cache_get_field_float(i, "bizDeliverX");
		BusinessData[i][bizDeliver][1] = cache_get_field_float(i, "bizDeliverY");
		BusinessData[i][bizDeliver][2] = cache_get_field_float(i, "bizDeliverZ");
		BusinessData[i][bizShipment] = cache_get_field_int(i, "bizShipment");
		BusinessData[i][bizInterior] = cache_get_field_int(i, "bizInterior");
		BusinessData[i][bizInteriorVW] = cache_get_field_int(i, "bizInteriorVW");
		BusinessData[i][bizExterior] = cache_get_field_int(i, "bizExterior");
		BusinessData[i][bizExteriorVW] = cache_get_field_int(i, "bizExteriorVW");
		BusinessData[i][bizLocked] = cache_get_field_int(i, "bizLocked");
		BusinessData[i][bizVault] = cache_get_field_int(i, "bizVault");
		BusinessData[i][bizProducts] = cache_get_field_int(i, "bizProducts");
        BusinessData[i][biztime1] = cache_get_field_int(i, "time1");
        BusinessData[i][biztime2] = cache_get_field_int(i, "time2");
        BusinessData[i][bizchancevole] = cache_get_field_int(i, "chancevole");
        BusinessData[i][bizdefoncer] = cache_get_field_int(i, "defoncer");
		for (new j = 0; j < 20; j ++)
		{
			format(str, 32, "bizPrice%d", j + 1);
			BusinessData[i][bizPrices][j] = cache_get_field_int(i, str);
		}
		Business_Refresh(i);
	}
	for (new i = 0; i < MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists])
	{
		if (BusinessData[i][bizType] == 5) {
			format(str, sizeof(str), "SELECT * FROM `dealervehicles` WHERE `ID` = '%d'", BusinessData[i][bizID]);
			mysql_tquery(g_iHandle, str, "Business_LoadCars", "d", i);
		}
		else if (BusinessData[i][bizType] == 6) {
			format(str, sizeof(str), "SELECT * FROM `pumps` WHERE `ID` = '%d'", BusinessData[i][bizID]);
			mysql_tquery(g_iHandle, str, "Pump_Load", "d", i);
		}
	}
	return 1;
}
script House_Load()
{
	static rows,fields,str[128];
	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_HOUSES)
	{
		HouseData[i][houseExists] = true;
		HouseData[i][houseLights] = false;
		HouseData[i][houseID] = cache_get_field_int(i, "houseID");
		HouseData[i][houseOwner] = cache_get_field_int(i, "houseOwner");
		HouseData[i][housePrice] = cache_get_field_int(i, "housePrice");
		cache_get_field_content(i, "houseAddress", HouseData[i][houseAddress], g_iHandle, 32);
		HouseData[i][housePos][0] = cache_get_field_float(i, "housePosX");
		HouseData[i][housePos][1] = cache_get_field_float(i, "housePosY");
		HouseData[i][housePos][2] = cache_get_field_float(i, "housePosZ");
		HouseData[i][housePos][3] = cache_get_field_float(i, "housePosA");
		HouseData[i][houseInt][0] = cache_get_field_float(i, "houseIntX");
		HouseData[i][houseInt][1] = cache_get_field_float(i, "houseIntY");
		HouseData[i][houseInt][2] = cache_get_field_float(i, "houseIntZ");
		HouseData[i][houseInt][3] = cache_get_field_float(i, "houseIntA");
		HouseData[i][houseInterior] = cache_get_field_int(i, "houseInterior");
		HouseData[i][houseInteriorVW] = cache_get_field_int(i, "houseInteriorVW");
		HouseData[i][houseExterior] = cache_get_field_int(i, "houseExterior");
		HouseData[i][houseExteriorVW] = cache_get_field_int(i, "houseExteriorVW");
        HouseData[i][houseLocked] = cache_get_field_int(i, "houseLocked");
        HouseData[i][houseMoney] = cache_get_field_int(i, "houseMoney");
        HouseData[i][houseLocation] = cache_get_field_int(i, "houseLocation");
		HouseData[i][houseMaxLoc] = cache_get_field_int(i, "houseMaxLoc");
		HouseData[i][houseLocNum] = cache_get_field_int(i, "houseLocNum");

        for (new j = 0; j < 10; j ++)
		{
            format(str, 24, "houseWeapon%d", j + 1);
            HouseData[i][houseWeapons][j] = cache_get_field_int(i, str);

            format(str, 24, "houseAmmo%d", j + 1);
            HouseData[i][houseAmmo][j] = cache_get_field_int(i, str);
		}
		House_Refresh(i);
	}
	for (new i = 0; i < MAX_HOUSES; i ++) if (HouseData[i][houseExists]) {
		format(str, sizeof(str), "SELECT * FROM `housestorage` WHERE `ID` = '%d'", HouseData[i][houseID]);
		mysql_tquery(g_iHandle, str, "OnLoadStorage", "d", i);
		format(str, sizeof(str), "SELECT * FROM `furniture` WHERE `ID` = '%d'", HouseData[i][houseID]);
		mysql_tquery(g_iHandle, str, "OnLoadFurniture", "d", i);
	}
	return 1;
}
script Car_Load()
{
	static rows,fields,str[128];
	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_CARS)
	{
	    CarData[i][carExists] = true;
	    CarData[i][carID] = cache_get_field_int(i, "carID");
	    CarData[i][carModel] = cache_get_field_int(i, "carModel");
	    CarData[i][carOwner] = cache_get_field_int(i, "carOwner");
	    CarData[i][carPos][0] = cache_get_field_float(i, "carPosX");
	    CarData[i][carPos][1] = cache_get_field_float(i, "carPosY");
	    CarData[i][carPos][2] = cache_get_field_float(i, "carPosZ");
	    CarData[i][carPos][3] = cache_get_field_float(i, "carPosR");
	    CarData[i][carColor1] = cache_get_field_int(i, "carColor1");
	    CarData[i][carColor2] = cache_get_field_int(i, "carColor2");
	    CarData[i][carPaintjob] = cache_get_field_int(i, "carPaintjob");
	    CarData[i][carLocked] = cache_get_field_int(i, "carLocked");
	    CarData[i][carImpounded] = cache_get_field_int(i, "carImpounded");
	    CarData[i][carImpoundPrice] = cache_get_field_int(i, "carImpoundPrice");
        CarData[i][carFaction] = cache_get_field_int(i, "carFaction");
		CarData[i][carLoca] = cache_get_field_int(i, "carLoca");
		CarData[i][carLocaID] = cache_get_field_int(i, "carLocaID");
		CarData[i][carDouble] = cache_get_field_int(i, "carDouble");
		CarData[i][carSabot] = cache_get_field_int(i, "carSabot");
		CarData[i][carSabPri] = cache_get_field_int(i, "carSabPri");
		CarData[i][carKilo] = cache_get_field_int(i, "vkilometres");
		CarData[i][carMetre] = cache_get_field_int(i, "vmetre");
		CarData[i][carfuel] = cache_get_field_int(i, "fuel");
		CarData[i][carvie] = cache_get_field_float(i, "carvie");
		for (new j = 0; j < 14; j ++)
		{
		    if (j < 5)
		    {
		        format(str, sizeof(str), "carWeapon%d", j + 1);
		        CarData[i][carWeapons][j] = cache_get_field_int(i, str);

		        format(str, sizeof(str), "carAmmo%d", j + 1);
		        CarData[i][carAmmo][j] = cache_get_field_int(i, str);
	        }
	        format(str, sizeof(str), "carMod%d", j + 1);
	        CarData[i][carMods][j] = cache_get_field_int(i, str);
	    }
	    Car_Spawn(i);
	}
	for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (CarData[i][carExists]) {
		format(str, sizeof(str), "SELECT * FROM `carstorage` WHERE `ID` = '%d'", CarData[i][carID]);
		mysql_tquery(g_iHandle, str, "OnLoadCarStorage", "d", i);
	}
	return 1;
}
script phonebook_Load()
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_PHONE)
	{
	    phoneinfo[i][phoneexists] = true;
	    phoneinfo[i][phoneid] = cache_get_field_int(i, "phonebookID");
	    phoneinfo[i][phoneobject] = cache_get_field_int(i, "phoneobject");
	    phoneinfo[i][phonepos][0] = cache_get_field_float(i, "phoneposX");
	    phoneinfo[i][phonepos][1] = cache_get_field_float(i, "phoneposY");
	    phoneinfo[i][phonepos][2] = cache_get_field_float(i, "phoneposZ");
	    phoneinfo[i][phonepos][3] = cache_get_field_float(i, "phoneposA");
	    phoneinfo[i][phoneinterior] = cache_get_field_int(i, "phoneposInterior");
	    phoneinfo[i][phonevirtual] = cache_get_field_int(i, "phoneposWorld");
		//phonebook_refresh(i);
	}
	return 1;
}
script HarvestPlant(playerid, plantid)
{
	PlayerData[playerid][pHarvesting] = 0;
	if (Plant_Nearest(playerid) != plantid || GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK || !PlantData[plantid][plantExists])
	    return 0;
	switch (PlantData[plantid][plantType])
	{
	    case 1:
	    {
	        new id = Inventory_Add(playerid, "Marijuana", 1578, PlantData[plantid][plantDrugs]);
	        if (id == -1)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a récolté %d grammes de marijuana.", ReturnName(playerid, 0), PlantData[plantid][plantDrugs]);
		}
		case 2:
	    {
	        new id = Inventory_Add(playerid, "Cocaine", 1575, PlantData[plantid][plantDrugs]);
	        if (id == -1)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a récolté %d grammes de cocaine.", ReturnName(playerid, 0), PlantData[plantid][plantDrugs]);
		}
        case 3:
	    {
	        new id = Inventory_Add(playerid, "Heroin", 1577, PlantData[plantid][plantDrugs]);
	        if (id == -1)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a récolté %d grammes de heroine.", ReturnName(playerid, 0), PlantData[plantid][plantDrugs]);
		}
	}
	Plant_Delete(plantid);
	return 1;
}

script OpenCrate(playerid, crateid)
{
	if (Crate_Nearest(playerid) != crateid || !CrateData[crateid][crateExists] || !IsPlayerSpawned(playerid) || !PlayerData[playerid][pOpeningCrate])
	    return 0;
    PlayerData[playerid][pOpeningCrate] = 0;
	ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
	if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	    return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire for 4 drug packages.");
	Inventory_Add(playerid, "Graine cocaine", 1575, 20);
	Inventory_Add(playerid, "Graine marijuana", 1578, 20);
	Inventory_Add(playerid, "Graine Heroin Opium", 1577, 10);
	Inventory_Add(playerid, "Steroids", 1241, 5);
	Crate_Delete(crateid);
	SendServerMessage(playerid, "Vous avez trouvé un assortiment de stéroïdes et les graines de drogue (ajouter dans l'invertaire).");
	return 1;
}

script CraftParts(playerid, crateid)
{
	if (PlayerData[playerid][pCarryCrate] != crateid || !CrateData[crateid][crateExists] || !IsPlayerSpawned(playerid) || !PlayerData[playerid][pCrafting])
	    return 0;
    PlayerData[playerid][pCrafting] = 0;
	PlayerData[playerid][pCarryCrate] = -1;
    TogglePlayerControllable(playerid, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 4);
    Log_Write("logs/craft_log.txt", "[%s] %s a conçu un %s caisse.", ReturnDate(), ReturnName(playerid, 0), Crate_GetType(CrateData[crateid][crateType]));
	switch (CrateData[crateid][crateType])
	{
	    case 1:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 4 parties de mêlée.");
			Inventory_Add(playerid, "Golf Club", 333);
			Inventory_Add(playerid, "Couteau", 335);
			Inventory_Add(playerid, "Pelle", 337);
			Inventory_Add(playerid, "Katana", 339);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez crée 4 armes de mêlée (ajouter dans l'invertaire).");
		}
	    case 2:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 2)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 2 pistolets.");
			Inventory_Add(playerid, "Colt 45", 346);
            Inventory_Add(playerid, "Colt 45", 346);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez créé deux pistolets à partir des pièces dans la boite (ajouter dans l'invertaire.");
		}
		case 3:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 3)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 3 SMG.");

			Inventory_Add(playerid, "Micro SMG", 352);
			Inventory_Add(playerid, "Tec-9", 372);
			Inventory_Add(playerid, "MP5", 353);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez conçu 3 armes de type SMG à partir de pièces dans la boite (ajouter dans l'invertaire).");
		}
		case 4:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 2)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 2 fusils de chasse.");

			Inventory_Add(playerid, "Shotgun", 349);
            Inventory_Add(playerid, "Spas-12", 349);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez crée un fusil de chasse à partir des pièces dans la boite (ajouter dans l'invertaire).");
		}
		case 5:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 4 Rifles.");

			Inventory_Add(playerid, "AK-47", 355);
			Inventory_Add(playerid, "M4", 356);
			Inventory_Add(playerid, "Rifle", 357);
			Inventory_Add(playerid, "Sniper", 358);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez créee 4 fusils à partir des pièces dans la boite (ajouter dans l'invertaire).");
		}
		case 7:
		{
		    if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 2 chargeur et des munitions.");

			Inventory_Add(playerid, "Munitions", 2039);
			Inventory_Add(playerid, "Munitions", 2039);
			Inventory_Add(playerid, "Chargeur", 19995);
			Inventory_Add(playerid, "Chargeur", 19995);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez crée 2 chargeur et des munitions (ajouté dans votre inventaire).");
		}
		case 8:
		{
		    if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	            return SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire pour 4 Cocktail Molotov.");
			//GiveWeaponToPlayer(playerid, 18, 2);
			Inventory_Add(playerid, "Cocktail Molotov", 18);
			Inventory_Add(playerid, "Cocktail Molotov", 18);
			Inventory_Add(playerid, "Cocktail Molotov", 18);
			Inventory_Add(playerid, "Cocktail Molotov", 18);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez crée 4 Cocktail Molotov.");
		}
	    case 9:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningfrontbumper] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de frontbumper dans la réserve.");
			return 1;
		}
	    case 10:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningrearbumper] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de rearbumper dans la réserve.");
		}
	    case 11:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningroof] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de roof dans la réserve.");
		}
	    case 12:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunninghood] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de hood dans la réserve.");
		}
	    case 13:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningspoiler] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de spoiler dans la réserve.");
		}
	    case 14:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningsideskirt] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de sideskirt1 dans la réserve.");
		}
	    case 15:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunninghydrolic] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece d'hydraulic dans la réserve.");
		}
	    case 16:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningroue] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de roue dans la réserve.");
		}
	    case 17:
	    {
	        new stockjobinfoid;
			info_stockjobinfo[stockjobinfoid][stocktunningcaro] += 5;
			stockjobinfosave(stockjobinfoid);
			Crate_Delete(crateid);
			SendServerMessage(playerid, "Vous avez mis 5 piece de carrosserie dans la réserve.");
		}
	}
	return 1;
}
script FirstAidUpdate(playerid)
{
	static Float:health;
	GetPlayerHealth(playerid, health);

    if (!IsPlayerInAnyVehicle(playerid) && GetPlayerAnimationIndex(playerid) != 1508)
    	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);

	if (health >= 51.0)
	{
	    SetPlayerHealth(playerid, 50.0);
	    SendServerMessage(playerid, "Votre trousse de premiers soins a été utilisé.");

		if (!IsPlayerInAnyVehicle(playerid)) {
	        PlayerData[playerid][pLoopAnim] = true;
			ShowPlayerFooter(playerid, "Appuyer surer ~y~SPRINT~w~ pour arrêter l'animation.");
		}
        PlayerData[playerid][pBleeding] = 0;
		PlayerData[playerid][pBleedTime] = 0;

		PlayerData[playerid][pFirstAid] = false;
		KillTimer(PlayerData[playerid][pAidTimer]);
	}
	else {
	    SetPlayerHealth(playerid, floatadd(health, 4.0));
	}
	return 1;
}
script RepairCarMoteur(playerid, vehicleid)
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0 && !IsPlayerNearHood(playerid, vehicleid)) {
		return 0;
	}
	SetVehicleHealth(vehicleid, 1000.0);
	new idk = Car_GetID(vehicleid);
	CarData[idk][carvie] = 1000.0;
	PlayerData[playerid][pRepairTime] = gettime() + 60;
	CoreVehicles[vehicleid][vehRepairing] = false;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a réussi à réparer le moteur du véhicule.", ReturnName(playerid, 0));
	return 1;
}
script RepairCarCaro(playerid, vehicleid)
{
	new facass = PlayerData[playerid][pFaction];
	if (FactionData[facass][factionacces][9] == 0 && !IsPlayerNearHood(playerid, vehicleid)) {
		return 0;
	}
	UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
	PlayerData[playerid][pRepairTime] = gettime() + 60;
	CoreVehicles[vehicleid][vehRepairing] = false;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a réussi à réparer la carrosserie du véhicule.", ReturnName(playerid, 0));
	return 1;
}
script Business_LoadCars(bizid)
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i != rows; i ++) {
		DealershipCars[bizid][i][vehID] = cache_get_field_int(i, "vehID");
		DealershipCars[bizid][i][vehModel] = cache_get_field_int(i, "vehModel");
		DealershipCars[bizid][i][vehPrice] = cache_get_field_int(i, "vehPrice");
	}
	return 1;
}
script OnLoadFurniture(houseid)
{
	static rows,fields,id = -1;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i != rows; i ++) if ((id = Furniture_GetFreeID()) != -1) {
	    FurnitureData[id][furnitureExists] = true;
	    FurnitureData[id][furnitureHouse] = houseid;
	    cache_get_field_content(i, "furnitureName", FurnitureData[id][furnitureName], g_iHandle, 32);
	    FurnitureData[id][furnitureID] = cache_get_field_int(i, "furnitureID");
	    FurnitureData[id][furnitureModel] = cache_get_field_int(i, "furnitureModel");
	    FurnitureData[id][furniturePos][0] = cache_get_field_float(i, "furnitureX");
	    FurnitureData[id][furniturePos][1] = cache_get_field_float(i, "furnitureY");
	    FurnitureData[id][furniturePos][2] = cache_get_field_float(i, "furnitureZ");
	    FurnitureData[id][furnitureRot][0] = cache_get_field_float(i, "furnitureRX");
	    FurnitureData[id][furnitureRot][1] = cache_get_field_float(i, "furnitureRY");
	    FurnitureData[id][furnitureRot][2] = cache_get_field_float(i, "furnitureRZ");
	    Furniture_Refresh(id);
	}
	return 1;
}
script OnLoadCarStorage(carid)
{
	static rows,fields,str[32];
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i != rows; i ++) {
		CarStorage[carid][i][cItemExists] = true;
		CarStorage[carid][i][cItemID] = cache_get_field_int(i, "itemID");
		CarStorage[carid][i][cItemModel] = cache_get_field_int(i, "itemModel");
		CarStorage[carid][i][cItemQuantity] = cache_get_field_int(i, "itemQuantity");
		cache_get_field_content(i, "itemName", str, g_iHandle, sizeof(str));
		strpack(CarStorage[carid][i][cItemName], str, 32 char);
	}
	return 1;
}
script OnLoadStorage(houseid)
{
	static rows,fields,str[32];
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i != rows; i ++) {
		HouseStorage[houseid][i][hItemExists] = true;
		HouseStorage[houseid][i][hItemID] = cache_get_field_int(i, "itemID");
		HouseStorage[houseid][i][hItemModel] = cache_get_field_int(i, "itemModel");
		HouseStorage[houseid][i][hItemQuantity] = cache_get_field_int(i, "itemQuantity");
		cache_get_field_content(i, "itemName", str, g_iHandle, sizeof(str));
		strpack(HouseStorage[houseid][i][hItemName], str, 32 char);
	}
	return 1;
}
script OnLoadBackpack(id)
{
	static rows,fields,itemid = -1;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i != rows; i ++) if ((itemid = Backpack_GetFreeItem()) != -1) {
		BackpackItems[itemid][bItemExists] = true;
		BackpackItems[itemid][bItemBackpack] = id;
		BackpackItems[itemid][bItemID] = cache_get_field_int(i, "itemID");
		BackpackItems[itemid][bItemModel] = cache_get_field_int(i, "itemModel");
		BackpackItems[itemid][bItemQuantity] = cache_get_field_int(i, "itemQuantity");

		cache_get_field_content(i, "itemName", BackpackItems[itemid][bItemName], g_iHandle, 32);
	}
	return 1;
}
script Pump_Load(bizid)
{
	static rows,fields,id = -1;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if ((id = Pump_GetFreeID()) != -1)
	{
	    PumpData[id][pumpExists] = true;
	    PumpData[id][pumpBusiness] = bizid;
	    PumpData[id][pumpID] = cache_get_field_int(i, "pumpID");
	    PumpData[id][pumpPos][0] = cache_get_field_float(i, "pumpPosX");
	    PumpData[id][pumpPos][1] = cache_get_field_float(i, "pumpPosY");
	    PumpData[id][pumpPos][2] = cache_get_field_float(i, "pumpPosZ");
	    PumpData[id][pumpPos][3] = cache_get_field_float(i, "pumpPosA");
	    PumpData[id][pumpFuel] = cache_get_field_int(i, "pumpFuel");

	    PumpData[id][pumpObject] = CreateDynamicObject(1676, PumpData[id][pumpPos][0], PumpData[id][pumpPos][1], PumpData[id][pumpPos][2], 0.0, 0.0, PumpData[id][pumpPos][3]);
	    Pump_Refresh(id);
	}
	return 1;
}
script OpenInventory(playerid)
{
    if (!IsPlayerConnected(playerid) || !PlayerData[playerid][pCharacter])
	    return 0;
	static items[MAX_INVENTORY],amounts[MAX_INVENTORY];
    for (new i = 0; i < PlayerData[playerid][pCapacity]; i ++)
	{
 		if (InventoryData[playerid][i][invExists]) {
   			items[i] = InventoryData[playerid][i][invModel];
   			amounts[i] = InventoryData[playerid][i][invQuantity];
		}
		else {
		    items[i] = -1;
		    amounts[i] = -1;
		}
	}
	PlayerData[playerid][pStorageSelect] = 0;
	return ShowModelSelectionMenu(playerid, "Inventaire", MODEL_SELECTION_INVENTORY, items, sizeof(items), 0.0, 0.0, 0.0, 1.0, -1, true, amounts);
}
script SelectTD(playerid)
{
	if (!IsPlayerConnected(playerid))
	    return 0;
	return SelectTextDraw(playerid, -1);
}
script DragUpdate(playerid, targetid)
{
	if (PlayerData[targetid][pDragged] && PlayerData[targetid][pDraggedBy] == playerid)
	{
	    static Float:fX,Float:fY,Float:fZ,Float:fAngle;
		GetPlayerPos(playerid, fX, fY, fZ);
		GetPlayerFacingAngle(playerid, fAngle);
		fX -= 3.0 * floatsin(-fAngle, degrees);
		fY -= 3.0 * floatcos(-fAngle, degrees);
		SetPlayerPos(targetid, fX, fY, fZ);
		SetPlayerInterior(targetid, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
	}
	return 1;
}
script KickTimer(playerid)
{
	if (PlayerData[playerid][pKicked]) {return Kick(playerid);}
	return 0;
}
script HidePlayerFooter(playerid) {

	if (!PlayerData[playerid][pShowFooter])
	    return 0;

	PlayerData[playerid][pShowFooter] = false;
	return PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][39]);
}
script OnQueryExecute(playerid, query[])
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	if (strfind(query, "Envoyer", true) != -1)
		Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, "Exécuter la requête", "Succès: MySQL retourné %d les lignes de votre requête.\n\nS'il vous plaît spécifier la requête MySQL pour exécuter ci-dessous:", "Executer", "Back", rows);
	else
		Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, "Exécuter la requête", "Succès: requête exécutée avec succès (lignes affectées: %d).\n\nS'il vous plaît spécifier la requête MySQL pour exécuter ci-dessous:", "Executer", "Back", cache_affected_rows());
	PlayerData[playerid][pExecute] = 0;
	return 1;
}
script OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	foreach (new i : Player)
	{
		if (PlayerData[i][pAdmin] >= 4 && PlayerData[i][pExecute])
		{
	    	PlayerData[i][pExecute] = 0;
	    	Dialog_Show(i, ExecuteQuery, DIALOG_STYLE_INPUT, "Exécuter la requête", "Erreur: \"%s\"\n\nS'il vous plaît spécifier la requête MySQL pour exécuter ci-dessous:", "Executer", "Back", error);
		}
	}
 	printf("** [MySQL]: %s", error);
 	printf("EID: %d | Error: %s | Query: %s", errorid, error, query);
	Log_Write("logs/mysql_log.txt", "[%s] %s: %s", ReturnDate(), (callback[0]) ? (callback) : ("n/a"), error);
	return 1;
}
script OnQueryFinished(extraid, threadid)
{
	if (!IsPlayerConnected(extraid))
	    return 0;
	static rows,fields;
	switch (threadid)
	{
	    case THREAD_CREATE_CHAR:
	    {
	        PlayerData[extraid][pID] = cache_insert_id(g_iHandle);
	        PlayerData[extraid][pLogged] = 1;
			SQL_SaveCharacter(extraid);
			PlayerData[extraid][pID] = -1;
			PlayerData[extraid][pLogged] = 0;
	    }
		case THREAD_CHECK_ACCOUNT:
		{
		    if(!IsPlayerNPC(extraid))
		    {
		    	cache_get_data(rows, fields, g_iHandle);
		    	if (rows)
				{
			    	static loginDate[36];
				    cache_get_row(0, 0, loginDate, g_iHandle);
					format(PlayerData[extraid][pLoginDate], 36, loginDate);
		  	      	Dialog_Show(extraid, LoginScreen, DIALOG_STYLE_PASSWORD, "Connexion Au Compte", "Bienvenue sur le serveur!\n\nDernière connection le: %s.\n\nS'il vous plaît entrez votre mot de passe ci-dessous pour vous connecter à votre compte:", "Connexion", "Quitter", PlayerData[extraid][pLoginDate]);
				}
				else
				{
				    Dialog_Show(extraid, RegisterScreen, DIALOG_STYLE_PASSWORD, "Enregistrer un compte", "Bienvenue sur le serveur, %s.\n\nImportant: Votre compte est pas encore inscrit. S'il vous plaît entrez votre mot de passe souhaité:", "Enregistrer", "Quitter", ReturnName(extraid));
				}
			}
    	}
    	case THREAD_LOGIN:
   		{
    	    cache_get_data(rows, fields, g_iHandle);

    	    if (!rows)
    	    {
    	        PlayerData[extraid][pLoginAttempts]++;

    	        if (PlayerData[extraid][pLoginAttempts] >= 3)
    	        {
    	            SendClientMessage(extraid, COLOR_LIGHTRED, "AVIS: Vous avez été expulsé pour l'utilisation de vos tentatives de connexion.");
    	            KickEx(extraid);
				}
				else
				{
    	        	Dialog_Show(extraid, LoginScreen, DIALOG_STYLE_PASSWORD, "Connexion Au Compte", "Bienvenue sur le serveur!\n\nDernière connection le: %s.\n\nS'il vous plaît entrez votre mot de passe ci-dessous pour vous connecter à votre compte:", "Connexion", "Quitter", PlayerData[extraid][pLoginDate]);
    	        	SendClientMessageEx(extraid, COLOR_LIGHTRED, "Avis: Mot de passe incorrect (%d/3 tentatives).", PlayerData[extraid][pLoginAttempts]);
				}
			}
			else
			{
				static query[128];
				// Update the last login date.
                format(query, sizeof(query), "UPDATE `accounts` SET `IP` = '%s', `LoginDate` = '%s' WHERE `Username` = '%s'", PlayerData[extraid][pIP], ReturnDate(), PlayerData[extraid][pUsername]);
				mysql_tquery(g_iHandle, query);
    			// Load the character data.
				format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Username` = '%s' LIMIT 2", PlayerData[extraid][pUsername]);
				mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_CHARACTERS);
			}
		}
		case THREAD_CHARACTERS:
		{
			cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows; i ++) {
			    cache_get_field_content(i, "Character", PlayerCharacters[extraid][i], g_iHandle, MAX_PLAYER_NAME);
		    }
		    SendServerMessage(extraid, "Vous vous êtes authentifié avec succès.");
            ShowCharacterMenu(extraid);
		}
		case THREAD_LOAD_CHARACTER:
		{
		    static string[128];
		    cache_get_data(rows, fields, g_iHandle);
			foreach (new i : Player)
			{
			    if (PlayerData[i][pCharacter] == PlayerData[extraid][pCharacter] && !strcmp(ReturnName(i), PlayerCharacters[extraid][PlayerData[extraid][pCharacter] - 1]) && i != extraid)
       			{
       			    ShowCharacterMenu(extraid);
				   	SendErrorMessage(extraid, "Ce personnage est déjà connecté.");
				}
			}
			switch (SetPlayerName(extraid, PlayerCharacters[extraid][PlayerData[extraid][pCharacter] - 1]))
			{
			    case -1: {
					SendClientMessageEx(extraid, COLOR_LIGHTRED, "ADVERTISEMENT: Le nom de votre personnage semble être déjà utilisée.");
				}
				default:
				{
				    if (!rows) {
				        return 0;
					}
					static query[128];
			        PlayerData[extraid][pID] = cache_get_field_int(0, "ID");
			        PlayerData[extraid][pCreated] = cache_get_field_int(0, "Created");
			        PlayerData[extraid][pGender] = cache_get_field_int(0, "Gender");

					cache_get_field_content(0, "Birthdate", PlayerData[extraid][pBirthdate], g_iHandle, 24);
			        cache_get_field_content(0, "Origin", PlayerData[extraid][pOrigin], g_iHandle, 32);

			        PlayerData[extraid][pSkin] = cache_get_field_int(0, "Skin");
			        PlayerData[extraid][pPos][0] = cache_get_field_float(0, "PosX");
			        PlayerData[extraid][pPos][1] = cache_get_field_float(0, "PosY");
			        PlayerData[extraid][pPos][2] = cache_get_field_float(0, "PosZ");
			        PlayerData[extraid][pPos][3] = cache_get_field_float(0, "PosA");
			        PlayerData[extraid][pHealth] = cache_get_field_float(0, "Health");
			        PlayerData[extraid][pInterior] = cache_get_field_int(0, "Interior");
			        PlayerData[extraid][pWorld] = cache_get_field_int(0, "World");
			        PlayerData[extraid][pHospital] = cache_get_field_int(0, "Hospital");
                    PlayerData[extraid][pHospitalInt] = cache_get_field_int(0, "HospitalInt");
			        PlayerData[extraid][pMoney] = cache_get_field_int(0, "Money");
			        PlayerData[extraid][pBankMoney] = cache_get_field_int(0, "BankMoney");
			        PlayerData[extraid][pOwnsBillboard] = cache_get_field_int(0, "OwnsBillboard");
					PlayerData[extraid][pSavings] = cache_get_field_int(0, "Savings");
			        PlayerData[extraid][pAdmin] = cache_get_field_int(0, "Admin");
			        PlayerData[extraid][pJailTime] = cache_get_field_int(0, "JailTime");
			        PlayerData[extraid][pMuted] = cache_get_field_int(0, "Muted");
			        PlayerData[extraid][pTester] = cache_get_field_int(0, "Tester");
			        PlayerData[extraid][pHouse] = cache_get_field_int(0, "House");
			        PlayerData[extraid][pBusiness] = cache_get_field_int(0, "Business");
			        PlayerData[extraid][pEntrance] = cache_get_field_int(0, "Entrance");
			        PlayerData[extraid][pPhone] = cache_get_field_int(0, "Phone");
			        PlayerData[extraid][pLottery] = cache_get_field_int(0, "Lottery");
			        PlayerData[extraid][pLottery] = cache_get_field_int(0, "LotteryB");
			        PlayerData[extraid][pHunger] = cache_get_field_int(0, "Hunger");
			        PlayerData[extraid][pThirst] = cache_get_field_int(0, "Thirst");
			        PlayerData[extraid][pPlayingHours] = cache_get_field_int(0, "PlayingHours");
			        PlayerData[extraid][pMinutes] = cache_get_field_int(0, "Minutes");
			        PlayerData[extraid][pArmorStatus] = cache_get_field_float(0, "ArmorStatus");
			        PlayerData[extraid][pJob] = cache_get_field_int(0, "Job");
			        PlayerData[extraid][pFactionID] = cache_get_field_int(0, "Faction");
			        PlayerData[extraid][pFactionRank] = cache_get_field_int(0, "FactionRank");
			        PlayerData[extraid][pPrisoned] = cache_get_field_int(0, "Prisoned");
			        PlayerData[extraid][pInjured] = cache_get_field_int(0, "Injured");
			        PlayerData[extraid][pWarrants] = cache_get_field_int(0, "Warrants");
			        PlayerData[extraid][pChannel] = cache_get_field_int(0, "Channel");
			        PlayerData[extraid][pBleeding] = cache_get_field_int(0, "Bleeding");
			        PlayerData[extraid][pAdminHide] = cache_get_field_int(0, "AdminHide");
			        PlayerData[extraid][pWarnings] = cache_get_field_int(0, "Warnings");
			        PlayerData[extraid][pMaskID] = cache_get_field_int(0, "MaskID");
			        PlayerData[extraid][pFactionMod] = cache_get_field_int(0, "FactionMod");
			        PlayerData[extraid][pCapacity] = cache_get_field_int(0, "Capacity");
			        PlayerData[extraid][pSpawnPoint] = cache_get_field_int(0, "SpawnPoint");
                    PlayerData[extraid][pBracelet] = cache_get_field_int(0, "bracelet");
					PlayerData[extraid][pBraceletProx] = cache_get_field_int(0, "braceletdist");
					PlayerData[extraid][pLocaID] = cache_get_field_int(0, "LocaID");
					PlayerData[extraid][pLocaMaisonID] = cache_get_field_int(0,"LocaMaisonID");
					PlayerData[extraid][pCarD] = cache_get_field_int(0, "CarD");
					PlayerData[extraid][pAcom] = cache_get_field_int(0, "baterietel");
					PlayerData[extraid][pBestScore] = cache_get_field_int(0, "BestScore");
					PlayerData[extraid][pStrike] = cache_get_field_int(0, "Strike");
					PlayerData[extraid][prepetitions] = cache_get_field_int(0, "Repetition");
					PlayerData[extraid][pparcouru] = cache_get_field_int(0, "Parcouru");
					PlayerData[extraid][pNoob] = cache_get_field_int(0, "Noob");
					PlayerData[extraid][pZombieKill] = cache_get_field_int(0, "ZombieKill");
					cache_get_field_content(0, "Warn1", PlayerData[extraid][pWarn1], g_iHandle, 32);
					cache_get_field_content(0, "Warn2", PlayerData[extraid][pWarn2], g_iHandle, 32);

			        for (new i = 0; i < 13; i ++) {
			            format(query, sizeof(query), "Gun%d", i + 1);
			            PlayerData[extraid][pGuns][i] = cache_get_field_int(0, query);

			            format(query, sizeof(query), "Ammo%d", i + 1);
			            PlayerData[extraid][pAmmo][i] = cache_get_field_int(0, query);
			        }
			        for (new j = 0; j < 10; j ++) {
					    format(query, sizeof(query), "skill%d", j);
					    PlayerData[extraid][pSkill][j] = cache_get_field_int(0, query);
					}
			        PlayerData[extraid][pGlasses] = cache_get_field_int(0, "Glasses");
					PlayerData[extraid][pHat] = cache_get_field_int(0, "Hat");
					PlayerData[extraid][pBandana] = cache_get_field_int(0, "Bandana");

					cache_get_field_content(0, "GlassesPos", string, g_iHandle);
					sscanf(string, "p<|>fffffffff", AccessoryData[extraid][0][0], AccessoryData[extraid][0][1], AccessoryData[extraid][0][2], AccessoryData[extraid][0][3], AccessoryData[extraid][0][4], AccessoryData[extraid][0][5], AccessoryData[extraid][0][6], AccessoryData[extraid][0][7], AccessoryData[extraid][0][8]);

					cache_get_field_content(0, "HatPos", string, g_iHandle);
					sscanf(string, "p<|>fffffffff", AccessoryData[extraid][1][0], AccessoryData[extraid][1][1], AccessoryData[extraid][1][2], AccessoryData[extraid][1][3], AccessoryData[extraid][1][4], AccessoryData[extraid][1][5], AccessoryData[extraid][1][6], AccessoryData[extraid][1][7], AccessoryData[extraid][1][8]);

					cache_get_field_content(0, "BandanaPos", string, g_iHandle);
					sscanf(string, "p<|>fffffffff", AccessoryData[extraid][2][0], AccessoryData[extraid][2][1], AccessoryData[extraid][2][2], AccessoryData[extraid][2][3], AccessoryData[extraid][2][4], AccessoryData[extraid][2][5], AccessoryData[extraid][2][6], AccessoryData[extraid][2][7], AccessoryData[extraid][2][8]);

					if (!PlayerData[extraid][pMaskID])
					    PlayerData[extraid][pMaskID] = random(90000) + 10000;

					if (!PlayerData[extraid][pCapacity])
					    PlayerData[extraid][pCapacity] = 24;
				    for (new i = 0; i < 81; i ++) {
				        if (i < 8 || (i >= 71 && i <= 80)) PlayerTextDrawHide(extraid, PlayerData[extraid][pTextdraws][i]);
					}
				    if (PlayerData[extraid][pTester] > 0)
			    	{
						SendClientMessage(extraid, COLOR_CYAN, "[SERVER]:{FFFFFF} Vous vous êtes connecté en tant que helpeur.");
				    }
				    if (PlayerData[extraid][pAdmin] > 0)
				    {
				        SendAdminAction(extraid, "Vous avez le niveau admin %d.", PlayerData[extraid][pAdmin]);
				    }
				    PlayerData[extraid][pLogged] = 1;
                    skill_set(extraid);
                    format(query, sizeof(query), "SELECT * FROM `inventory` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_INVENTORY);

                    format(query, sizeof(query), "SELECT * FROM `contacts` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_CONTACTS);

                    format(query, sizeof(query), "SELECT * FROM `tickets` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_TICKETS);

                    format(query, sizeof(query), "SELECT * FROM `gps` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_LOCATIONS);

                    if(PlayerData[extraid][pOwnsBillboard] == 0)
                    {
                        PlayerData[extraid][pOwnsBillboard] = -1;
					}
					if (PlayerData[extraid][pFactionID] != -1) {
					    PlayerData[extraid][pFaction] = GetFactionByID(PlayerData[extraid][pFactionID]);

					    if (PlayerData[extraid][pFaction] == -1) {
					        ResetFaction(extraid);
						}
					}
				    if (!PlayerData[extraid][pCreated])
				    {
				        new str[48];
						format(str, sizeof(str), "~r~Nom:~w~ %s", ReturnName(extraid));
				        PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][14], str);
                        SetTimerEx("SelectTD", 200, false, "d", extraid);
				        for (new i = 11; i < 23; i ++) {
				            PlayerTextDrawShow(extraid, PlayerData[extraid][pTextdraws][i]);
						}
						PlayerData[extraid][pSkin] = 98;
						PlayerData[extraid][pOrigin][0] = '\0';
						PlayerData[extraid][pBirthdate][0] = '\0';
						SendServerMessage(extraid, "Vous êtes maintenant tenus de faire votre carte d'identité.");
				    }
				    else
				    {
        				SetSpawnInfo(extraid, 0, PlayerData[extraid][pSkin], PlayerData[extraid][pPos][0], PlayerData[extraid][pPos][1], PlayerData[extraid][pPos][2], 0.0, 0, 0, 0, 0, 0, 0);
				        TogglePlayerSpectating(extraid, 0);
				        TogglePlayerControllable(extraid, 0);
				        CancelSelectTextDraw(extraid);
				        SetTimerEx("SpawnTimer", 1000, false, "d", extraid);
					}
					new factionid = PlayerData[extraid][pFaction];
					if (FactionData[factionid][factionacces][1] == 1) {cop_nbrCops++;}
					if (FactionData[factionid][factionacces][4] == 1) {swat_nbrCops++;}
					if (FactionData[factionid][factionacces][6] == 1) {mercco++; SendServerMessage(extraid,"Livreur de marchandise connecté (toi)");}
				}
			}
		}
		case THREAD_VERIFY_PASS:
		{
		    cache_get_data(rows, fields, g_iHandle);
		    if (rows)
				Dialog_Show(extraid, NewPass, DIALOG_STYLE_PASSWORD, "Nouveau mot de passe", "S'il vous plaît entrez votre nouveau mot de passe ci-dessous.\n\nNote: S'il vous plaît utiliser un mot de passe fort et sécuritaire pour plus de sécurité.", "Changer", "Quitter");
			else
				SendErrorMessage(extraid, "Vous avez entré un mot de passe incorrect.");
		}
		case THREAD_FIND_USERNAME:
		{
		    static query[128];
			cache_get_data(rows, fields, g_iHandle);
			if (rows)
			{
				new name[MAX_PLAYER_NAME + 1];
				cache_get_row(0, 0, name, g_iHandle);
				if (strcmp(name, PlayerData[extraid][pUsername], false) != 0)
				{
					format(PlayerData[extraid][pUsername], sizeof(name), name);
					SetPlayerName(extraid, name);
				}
		    }
		    format(query, sizeof(query), "SELECT `LoginDate` FROM `accounts` WHERE `Username` = '%s'", PlayerData[extraid][pUsername]);
			mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_CHECK_ACCOUNT);
		}
		case THREAD_LOAD_INVENTORY:
		{
		    static name[32];
		    cache_get_data(rows, fields, g_iHandle);
			for (new i = 0; i < rows && i < MAX_INVENTORY; i ++) {
			    InventoryData[extraid][i][invExists] = true;
			    InventoryData[extraid][i][invID] = cache_get_field_int(i, "invID");
			    InventoryData[extraid][i][invModel] = cache_get_field_int(i, "invModel");
                InventoryData[extraid][i][invQuantity] = cache_get_field_int(i, "invQuantity");

				cache_get_field_content(i, "invItem", name, g_iHandle, sizeof(name));
				strpack(InventoryData[extraid][i][invItem], name, 32 char);
			}
		}
		case THREAD_LOAD_CONTACTS:
		{
		    cache_get_data(rows, fields, g_iHandle);
			for (new i = 0; i < rows && i < MAX_CONTACTS; i ++) {
				cache_get_field_content(i, "contactName", ContactData[extraid][i][contactName], g_iHandle, 32);
				ContactData[extraid][i][contactExists] = true;
			    ContactData[extraid][i][contactID] = cache_get_field_int(i, "contactID");
			    ContactData[extraid][i][contactNumber] = cache_get_field_int(i, "contactNumber");
			}
		}
		case THREAD_LOAD_LOCATIONS:
		{
		    cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows && i < MAX_GPS_LOCATIONS; i ++) {
				cache_get_field_content(i, "locationName", LocationData[extraid][i][locationName], g_iHandle, 32);

				LocationData[extraid][i][locationExists] = true;
			    LocationData[extraid][i][locationID] = cache_get_field_int(i, "locationID");
			    LocationData[extraid][i][locationPos][0] = cache_get_field_float(i, "locationX");
			    LocationData[extraid][i][locationPos][1] = cache_get_field_float(i, "locationY");
			    LocationData[extraid][i][locationPos][2] = cache_get_field_float(i, "locationZ");
			}
		}
		case THREAD_LOAD_TICKETS:
		{
		    cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows && i < MAX_PLAYER_TICKETS; i ++) {
				cache_get_field_content(i, "ticketReason", TicketData[extraid][i][ticketReason], g_iHandle, 64);
				cache_get_field_content(i, "ticketDate", TicketData[extraid][i][ticketDate], g_iHandle, 36);

				TicketData[extraid][i][ticketExists] = true;
			    TicketData[extraid][i][ticketID] = cache_get_field_int(i, "ticketID");
			    TicketData[extraid][i][ticketFee] = cache_get_field_int(i, "ticketFee");
			}
		}
		case THREAD_BAN_LOOKUP:
		{
		    new reason[128],date[36],username[24];
		    cache_get_data(rows, fields, g_iHandle);

		    if (rows) {
		        cache_get_field_content(0, "Username", username, g_iHandle);
		        cache_get_field_content(0, "Date", date, g_iHandle);
				cache_get_field_content(0, "Reason", reason, g_iHandle);

				if (!strcmp(username, "null", true) || !username[0])
				{
				    Dialog_Show(extraid, ShowOnly, DIALOG_STYLE_MSGBOX, "Information de ban", "Votre adresse IP est banni de ce serveur.\n\nIP: %s\nDate: %s\nRaison: %s\n\nPour demander un déban, s'il vous plaît visitez notre site Web et faite une demande de déban.", "Fermer", "", PlayerData[extraid][pIP], date, reason);
					KickEx(extraid);
				}
				else
				{
				    Dialog_Show(extraid, ShowOnly, DIALOG_STYLE_MSGBOX, "Information de ban", "Vous êtes banni de ce serveur.\n\nUsername: %s\nDate: %s\nRaison: %s\n\nPour demander un déban, s'il vous plaît visitez notre site Web et faite une demande de déban.", "Fermer", "", PlayerData[extraid][pUsername], date, reason);
					KickEx(extraid);
				}
		    }
		}
		case THREAD_SHOW_CHARACTER:
		{
			cache_get_data(rows, fields, g_iHandle);

			if (rows)
			{
			    static skin,birthdate[16],origin[32],string[128];
			    skin = cache_get_field_int(0, "Skin");
				cache_get_field_content(0, "Birthdate", birthdate, g_iHandle);
				cache_get_field_content(0, "Origin", origin, g_iHandle);
				PlayerTextDrawSetPreviewModel(extraid, PlayerData[extraid][pTextdraws][73], skin);
				if (!strlen(birthdate)) {
				    birthdate = "Non Precise";
				}
				if (!strlen(origin)) {
				    origin = "Non Precise";
				}
				format(string, sizeof(string), "~b~Anniversaire:~w~ %s", birthdate);
				PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][74], string);

				format(string, sizeof(string), "~b~Origine:~w~ %s", origin);
				PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][75], string);

				format(string, sizeof(string), "~b~Creer le:~w~ %s", GetDuration(gettime() - cache_get_field_int(0, "CreateDate")));
				PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][76], string);

				format(string, sizeof(string), "~b~Jouer:~w~ %s", GetDuration(gettime() - cache_get_field_int(0, "LastLogin")));
				PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][77], string);

				for (new i = 0; i < 8; i ++) {
				    PlayerTextDrawHide(extraid, PlayerData[extraid][pTextdraws][i]);
				}
			    for (new i = 71; i < 81; i ++) {
			        PlayerTextDrawShow(extraid, PlayerData[extraid][pTextdraws][i]);
				}
			}
		}
	}
	return 1;
}
script OnViewCharges(extraid, name[])
{
    new factionid = PlayerData[extraid][pFaction];
	if (FactionData[factionid][factionacces][1] == 0)
	    return 0;
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	if (!rows)
	    return SendErrorMessage(extraid, "Aucun résultat trouvé pour des charges sur \"%s\".", name);

	static string[1024],desc[128],date[36];
	string[0] = 0;

	for (new i = 0; i < rows; i ++) {
	    cache_get_field_content(i, "Description", desc, g_iHandle);
	    cache_get_field_content(i, "Date", date, g_iHandle);

	    format(string, sizeof(string), "%s%s (%s)\n", string, desc, date);
	}
	format(desc, sizeof(desc), "Charges: %s", name);
	Dialog_Show(extraid, ChargeList, DIALOG_STYLE_LIST, desc, string, "Fermer", "");
	return 1;
}
script AccountCheck(playerid)
{
	SetCameraData(playerid);
	SQL_CheckAccount(playerid);
	return 1;
}
script OnResolveUsername(extraid, character[])
{
    new rows,fields,name[24];
	cache_get_data(rows, fields, g_iHandle);
	if (!rows)
 		return SendErrorMessage(extraid, "Il n'y a pas de compte lié avec le nom spécifié.");

	cache_get_row(0, 0, name, g_iHandle);
	SendServerMessage(extraid, "%s's nom d'utilisateur est: %s.", character, name);
	return 1;
}

script OnLoginDate(extraid, username[])
{
    if (!IsPlayerConnected(extraid))
	    return 0;
	static rows,fields,date[36];
	cache_get_data(rows, fields, g_iHandle);
	if (rows) {
	    cache_get_row(0, 0, date, g_iHandle);
	    SendServerMessage(extraid, "%s's dernière connexion remonte le: %s.", username, date);
	}
	else {SendErrorMessage(extraid, "Nom d'utilisateur spécifié invalide.");}
	return 1;
}
script OnCarStorageAdd(carid, itemid)
{
	CarStorage[carid][itemid][cItemID] = cache_insert_id(g_iHandle);
	return 1;
}
script OnStorageAdd(houseid, itemid)
{
	HouseStorage[houseid][itemid][hItemID] = cache_insert_id(g_iHandle);
	return 1;
}
script OnDealerCarCreated(bizid, slotid)
{
	DealershipCars[bizid][slotid][vehID] = cache_insert_id(g_iHandle);
	return 1;
}
script OnFurnitureCreated(furnitureid)
{
	FurnitureData[furnitureid][furnitureID] = cache_insert_id(g_iHandle);
	Furniture_Save(furnitureid);
	return 1;
}
script OnContactAdd(playerid, id)
{
	ContactData[playerid][id][contactID] = cache_insert_id(g_iHandle);
	return 1;
}
script OnInventoryAdd(playerid, itemid)
{
	InventoryData[playerid][itemid][invID] = cache_insert_id(g_iHandle);
	return 1;
}
script OnBanLookup(playerid, username[])
{
	if (!IsPlayerConnected(playerid))
	    return 0;
	static rows,fields,reason[128],date[36];
	cache_get_data(rows, fields, g_iHandle);
	if (rows) {
	    cache_get_field_content(0, "Reason", reason, g_iHandle);
	    cache_get_field_content(0, "Date", date, g_iHandle);
		SendServerMessage(playerid, "%s a été banni le %s, raison: %s", username, date, reason);
	}
	else {
	    SendErrorMessage(playerid, "%s est pas banni de ce serveur.", username);
	}
	return 1;
}
script OnVerifyNameChange(playerid, newname[])
{
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	if (rows)
	    return SendErrorMessage(playerid, "Le nom spécifié \"%s\" est déjà en cours d'utilisation.", newname);

	foreach (new i : Player) if (!strcmp(ReturnName(i), newname, true)) {
	    return SendErrorMessage(playerid, "Le nom spécifié \"%s\" est déjà en cours d'utilisation.", newname);
	}
	format(PlayerData[playerid][pNameChange], 24, newname);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s à demander un changement de nom pour %s (Faite \"/acceptname\" ou \"/declinename\").", ReturnName(playerid, 0), newname);
	SendServerMessage(playerid, "Votre demande de changement de nom a été envoyé aux administrateurs.");
	return 1;
}

script OnDeleteCharacter(playerid, name[])
{
	static rows,fields,query[128],id = -1;
    cache_get_data(rows, fields, g_iHandle);
	if (!rows)
	    return SendErrorMessage(playerid, "Le personnage \"%s\" est lié à aucun comptes.", name);
	if (cache_get_field_int(0, "Admin") > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à supprimer le caractère d'un administrateur supérieur.");
	id = cache_get_field_int(0, "ID");
	if (id) {
	    format(query, sizeof(query), "DELETE FROM `contacts` WHERE `ID` = '%d'", id);
     	mysql_tquery(g_iHandle, query);
		format(query, sizeof(query), "DELETE FROM `gps` WHERE `ID` = '%d'", id);
  		mysql_tquery(g_iHandle, query);
		format(query, sizeof(query), "DELETE FROM `inventory` WHERE `ID` = '%d'", id);
		mysql_tquery(g_iHandle, query);
		format(query, sizeof(query), "DELETE FROM `tickets` WHERE `ID` = '%d'", id);
  		mysql_tquery(g_iHandle, query);
	    format(query, sizeof(query), "DELETE FROM `characters` WHERE `ID` = '%d'", id);
  		mysql_tquery(g_iHandle, query);
  		SendServerMessage(playerid, "Vous avez supprimé \"%s\" avec succé.", name);
	}
	return 1;
}

script OnDeleteAccount(playerid, name[])
{
	static rows,fields,id = -1;
	cache_get_data(rows, fields, g_iHandle);
	if (!rows)
	    return SendErrorMessage(playerid, "Le nom d'utilisateur \"%s\" n'existe pas.", name);
	static query[128];
	for (new i = 0; i < rows; i ++)
	{
	    if ((id = cache_get_field_int(i, "ID")))
		{
	        format(query, sizeof(query), "DELETE FROM `contacts` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);

	        format(query, sizeof(query), "DELETE FROM `gps` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);

	        format(query, sizeof(query), "DELETE FROM `inventory` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);

            format(query, sizeof(query), "DELETE FROM `tickets` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);
		}
	}
	format(query, sizeof(query), "DELETE FROM `accounts` WHERE `Username` = '%s'", name);
    mysql_tquery(g_iHandle, query);

    format(query, sizeof(query), "DELETE FROM `characters` WHERE `Username` = '%s'", name);
    mysql_tquery(g_iHandle, query);

    SendServerMessage(playerid, "Vous avez supprimé \"%s\" de la base de données.", name);
    return 1;
}

script OnNameChange(playerid, userid, newname[])
{
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(userid))
	    return 0;
	static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	if (rows) return SendErrorMessage(playerid, "Le nom spécifié \"%s\" est en cours d'utilisation.", newname);
    new oldname[MAX_PLAYER_NAME];
	GetPlayerName(userid, oldname, sizeof(oldname));
	ChangeName(userid, newname);
    for (new i = 0, l = strlen(oldname); i != l; i ++) {
	    if (oldname[i] == '_') oldname[i] = ' ';
	}
	for (new i = 0, l = strlen(newname); i != l; i ++) {
	    if (newname[i] == '_') newname[i] = ' ';
	}
	SendServerMessage(playerid, "Tu as changé %s's pour %s.", oldname, newname);
	SendServerMessage(userid, "%s a changé de nom pour %s.", ReturnName(playerid, 0), newname);
	Log_Write("logs/name_log.txt", "[%s] %s a changé %s's pour %s.", ReturnDate(), ReturnName(playerid), oldname, newname);
	return 1;
}

script OnTicketCreated(playerid, ticketid)
{
	TicketData[playerid][ticketid][ticketID] = cache_insert_id(g_iHandle);
	return 1;
}

script OnRackCreated(rackid)
{
	if (rackid == -1 || !RackData[rackid][rackExists])
	    return 0;
	RackData[rackid][rackID] = cache_insert_id(g_iHandle);
	Rack_Save(rackid);
	return 1;
}
script OnGateCreated(gateid)
{
	if (gateid == -1 || !GateData[gateid][gateExists])
	    return 0;
	GateData[gateid][gateID] = cache_insert_id(g_iHandle);
	Gate_Save(gateid);
	return 1;
}
script OnbatiementCreated(batiementid)
{
	if (batiementid == -1 || !batiementData[batiementid][batiementExists])
	    return 0;

	batiementData[batiementid][batiementID] = cache_insert_id(g_iHandle);
	batiement_Save(batiementid);

	return 1;
}
script OnBusinessCreated(bizid)
{
	if (bizid == -1 || !BusinessData[bizid][bizExists])
	    return 0;
	BusinessData[bizid][bizID] = cache_insert_id(g_iHandle);
	Business_Save(bizid);
	return 1;
}
script OnEntranceCreated(entranceid)
{
	if (entranceid == -1 || !EntranceData[entranceid][entranceExists])
	    return 0;
	EntranceData[entranceid][entranceID] = cache_insert_id(g_iHandle);
	EntranceData[entranceid][entranceWorld] = EntranceData[entranceid][entranceID] + 7000;
	Entrance_Save(entranceid);
	return 1;
}
script OnCarCreated(carid)
{
	if (carid == -1 || !CarData[carid][carExists])
	    return 0;

	CarData[carid][carID] = cache_insert_id(g_iHandle);
	Car_Save(carid);
	return 1;
}
script OnPumpCreated(pumpid)
{
    PumpData[pumpid][pumpID] = cache_insert_id(g_iHandle);
	Pump_Save(pumpid);
	return 1;
}
script OnArrestCreated(arrestid)
{
	if (arrestid == -1 || !ArrestData[arrestid][arrestExists])
	    return 0;
	ArrestData[arrestid][arrestID] = cache_insert_id(g_iHandle);
	Arrest_Save(arrestid);
	return 1;
}
script OnPlantCreated(plantid)
{
	if (plantid == -1 || !PlantData[plantid][plantExists])
	    return 0;
	PlantData[plantid][plantID] = cache_insert_id(g_iHandle);
	Plant_Save(plantid);
	return 1;
}
script OnCrateCreated(crateid)
{
	if (crateid == -1 || !CrateData[crateid][crateExists])
	    return 0;
	CrateData[crateid][crateID] = cache_insert_id(g_iHandle);
	Crate_Save(crateid);
	return 1;
}
script OnFactionCreated(factionid)
{
	if (factionid == -1 || !FactionData[factionid][factionExists])
	    return 0;
	FactionData[factionid][factionID] = cache_insert_id(g_iHandle);
	Faction_Save(factionid);
	Faction_SaveRanks(factionid);
	return 1;
}
script OnBackpackCreated(id)
{
	if (id == -1 || !BackpackData[id][backpackExists])
	    return 0;
	BackpackData[id][backpackID] = cache_insert_id(g_iHandle);
	Backpack_Save(id);
	return 1;
}
script OnATMCreated(atmid)
{
    if (atmid == -1 || !ATMData[atmid][atmExists])
		return 0;
	ATMData[atmid][atmID] = cache_insert_id(g_iHandle);
 	ATM_Save(atmid);
	return 1;
}
script OnImpoundCreated(impoundid)
{
	if (impoundid == -1 || !ImpoundData[impoundid][impoundExists])
	    return 0;
	ImpoundData[impoundid][impoundID] = cache_insert_id(g_iHandle);
	Impound_Save(impoundid);
	return 1;
}
script OnGraffitiCreated(id)
{
	GraffitiData[id][graffitiID] = cache_insert_id(g_iHandle);
	Graffiti_Save(id);
	return 1;
}
script OnDetectorCreated(id)
{
	MetalDetectors[id][detectorID] = cache_insert_id(g_iHandle);
	return 1;
}
script OnGarbageCreated(garbageid)
{
	if (garbageid == -1 || !GarbageData[garbageid][garbageExists])
	    return 0;
	GarbageData[garbageid][garbageID] = cache_insert_id(g_iHandle);
	Garbage_Save(garbageid);
	return 1;
}
script OnVendorCreated(vendorid)
{
	if (vendorid == -1 || !VendorData[vendorid][vendorExists])
	    return 0;
	VendorData[vendorid][vendorID] = cache_insert_id(g_iHandle);
	Vendor_Save(vendorid);
	return 1;
}
script OnSpeedCreated(speedid)
{
	if (speedid == -1 || !SpeedData[speedid][speedExists])
	    return 0;
	SpeedData[speedid][speedID] = cache_insert_id(g_iHandle);
	Speed_Save(speedid);
	return 1;
}
script OnHouseCreated(houseid)
{
	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	HouseData[houseid][houseID] = cache_insert_id(g_iHandle);
	House_Save(houseid);

	return 1;
}

script OnDroppedItem(itemid)
{
	if (itemid == -1 || !DroppedItems[itemid][droppedModel])
	    return 0;

	DroppedItems[itemid][droppedID] = cache_insert_id(g_iHandle);
	return 1;
}

script OnJobCreated(jobid)
{
	if (jobid == -1 || !JobData[jobid][jobExists])
	    return 0;

	JobData[jobid][jobID] = cache_insert_id(g_iHandle);
	Job_Save(jobid);

	return 1;
}

script OnCharacterLookup(extraid, id, character[])
{
	if (!IsPlayerConnected(extraid))
	    return 0;

	static rows,fields,string[128];
	cache_get_data(rows, fields, g_iHandle);

	if (rows)
	{
	    static admin,skin,createDate,lastLogin;

		admin = cache_get_field_int(0, "Admin");
		skin = cache_get_field_int(0, "Skin");

		createDate = cache_get_field_int(0, "CreateDate");
		lastLogin = cache_get_field_int(0, "LastLogin");

		format(string, sizeof(string), "~g~Nom:~w~ %s~n~~g~Compte:~w~ %s~n~~g~Creation:~w~ %s~n~~g~Derniere Connxion:~w~ %s", character, (admin > 0) ? ("Admin") : ("Player"), GetDuration(gettime() - createDate), GetDuration(gettime() - lastLogin));
		PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][52], string);

		format(string, sizeof(string), "#%d: %s", id, character);
		PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][53], string);

		PlayerTextDrawSetPreviewModel(extraid, PlayerData[extraid][pTextdraws][54], skin);

		for (new i = 40; i < 58; i ++)
  		{
    		if (i >= 50)
      			PlayerTextDrawShow(extraid, PlayerData[extraid][pTextdraws][i]);

			else if (i < 50)
   				PlayerTextDrawHide(extraid, PlayerData[extraid][pTextdraws][i]);
   		}
		SelectTextDraw(extraid, -1);

		PlayerData[extraid][pDisplayStats] = 2;
		PlayerData[extraid][pCharacterMenu] = id;
	}
	return 1;
}

script OnCharacterCheck(extraid, character[])
{
	if (!IsPlayerConnected(extraid))
	    return 0;

	static rows,fields,query[150];
	cache_get_data(rows, fields, g_iHandle);

	if (rows)
	{
	    Dialog_Show(extraid, CreateChar, DIALOG_STYLE_INPUT, "Créer personnage", "Erreur: Le nom spécifié \"%s\" existe déjàs!\n\nS'il vous plaît entrez le nom de votre nouveau personnage ci-dessous:\n\nAttention: Votre nom doit être dans le format prénom_nom et ne pas dépasser 24 caractères.", "Créer", "Quitter", character);
	}
	else
	{
		format(query, sizeof(query), "INSERT INTO `characters` (`Username`, `Character`, `CreateDate`) VALUES('%s', '%s', '%d')", PlayerData[extraid][pUsername], character, gettime());
		mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_CREATE_CHAR);

		format(PlayerCharacters[extraid][PlayerData[extraid][pCharacter] - 1], MAX_PLAYER_NAME + 1, character);
		SendServerMessage(extraid, "Vous avez créé avec succès votre personnage \"%s\".", character);

		ShowCharacterMenu(extraid);
		PlayerData[extraid][pLogged] = 0;
	}
	return 1;
}
script FlashShowTextDrawEx(playerid, PlayerText:textid, amount)
{
    if ((IsPlayerConnected(playerid) && PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] != 0 && PlayerData[playerid][pHospital] == -1) && IsPlayerSpawned(playerid)) {
	    PlayerTextDrawShow(playerid, textid);

	    if (amount > 0) return SetTimerEx("HideTextDrawEx", 500, false, "ddd", playerid, _:textid, amount);
	}
	return 1;
}
script HideTextDrawEx(playerid, PlayerText:textid, amount)
{
    if ((IsPlayerConnected(playerid) && PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] != 0 && PlayerData[playerid][pHospital] == -1) && IsPlayerSpawned(playerid)) {
	    PlayerTextDrawHide(playerid, textid);

	    if (amount > 0) return SetTimerEx("FlashShowTextDrawEx", 500, false, "ddd", playerid, _:textid, --amount);
	}
	return 1;
}
script FlashShowTextDraw(playerid, PlayerText:textid)
{
	if ((IsPlayerConnected(playerid) && PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] != 0 && PlayerData[playerid][pHospital] == -1) && IsPlayerSpawned(playerid)) {
	    PlayerTextDrawShow(playerid, textid);
	}
	return 1;
}
script MinuteCheck()
{
	static Float:hp,gouvernementinfoid;
    foreach (new i : Player)
	{
	    if (!PlayerData[i][pLogged] && !PlayerData[i][pCharacter])
	        continue;
		PlayerData[i][pMinutes]++;
        if (PlayerData[i][pMinutes] >= 60)
       	{
       	    PlayerData[i][prepetitions] -= random(100);
			PlayerData[i][pparcouru] -= random(100);
            PlayerData[i][pparcouru] = clamp(PlayerData[i][pparcouru], -5000, 5000);
            PlayerData[i][prepetitions] = clamp(PlayerData[i][prepetitions], -5000, 5000);
            PlayerData[i][pHideTags] -= 1;
            PlayerData[i][pMinutes] = 0;
			PlayerData[i][pPlayingHours]++;
            new paycheck,moneyentrepriseid,rank,interettaxe,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],factionid = PlayerData[i][pFaction],Derp = PlayerData[i][pFactionRank];
			if (PlayerData[i][pFaction] == -1)
			{
				paycheck = info_gouvernementinfo[gouvernementinfoid][gouvernementchomage];
				argent_entreprise[moneyentrepriseid][argentmairie] -= paycheck;
			}
			else if(FactionData[factionid][factionacces][8] == 1 && argent_entreprise[moneyentrepriseid][argentmairie] >= 0)
			{
				paycheck = info_gouvernementinfo[gouvernementinfoid][gouvernementchomage];
				argent_entreprise[moneyentrepriseid][argentmairie] -= paycheck;
			}
            else if (FactionData[factionid][factionacces][1] == 1 && argent_entreprise[moneyentrepriseid][argentpolice] >= 0)
			{
	            if (PlayerData[i][pFactionRank] == 1)
				{ paycheck = info_salairepolice[rank][salairepolice1];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 2)
				{ paycheck = info_salairepolice[rank][salairepolice2];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 3)
				{ paycheck = info_salairepolice[rank][salairepolice3];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 4)
				{ paycheck = info_salairepolice[rank][salairepolice4];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 5)
				{ paycheck = info_salairepolice[rank][salairepolice5];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 6)
				{ paycheck = info_salairepolice[rank][salairepolice6];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 7)
				{ paycheck = info_salairepolice[rank][salairepolice7];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 8)
				{ paycheck = info_salairepolice[rank][salairepolice8];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 9)
				{ paycheck = info_salairepolice[rank][salairepolice9];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 10)
				{ paycheck = info_salairepolice[rank][salairepolice10];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 11)
				{ paycheck = info_salairepolice[rank][salairepolice11];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 12)
				{ paycheck = info_salairepolice[rank][salairepolice12];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 13)
				{ paycheck = info_salairepolice[rank][salairepolice13];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 14)
				{ paycheck = info_salairepolice[rank][salairepolice14];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 15)
				{ paycheck = info_salairepolice[rank][salairepolice15];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				argent_entreprise[moneyentrepriseid][argentpolice] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][3] == 1 && argent_entreprise[moneyentrepriseid][argentfbi] >= 0)
			{
	            if (PlayerData[i][pFactionRank] == 1)
				{ paycheck = info_salairefbi[rank][salairefbi1];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 2)
				{ paycheck = info_salairefbi[rank][salairefbi2];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 3)
				{ paycheck = info_salairefbi[rank][salairefbi3];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 4)
				{ paycheck = info_salairefbi[rank][salairefbi4];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 5)
				{ paycheck = info_salairefbi[rank][salairefbi5];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 6)
				{ paycheck = info_salairefbi[rank][salairefbi6];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 7)
				{ paycheck = info_salairefbi[rank][salairefbi7];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 8)
				{ paycheck = info_salairefbi[rank][salairefbi8];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 9)
				{ paycheck = info_salairefbi[rank][salairefbi9];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 10)
				{ paycheck = info_salairefbi[rank][salairefbi10];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 11)
				{ paycheck = info_salairefbi[rank][salairefbi11];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 12)
				{ paycheck = info_salairefbi[rank][salairefbi12];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 13)
				{ paycheck = info_salairefbi[rank][salairefbi13];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 14)
				{ paycheck = info_salairefbi[rank][salairefbi14];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 15)
				{ paycheck = info_salairefbi[rank][salairefbi15];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				argent_entreprise[moneyentrepriseid][argentfbi] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][4] == 1 && argent_entreprise[moneyentrepriseid][argentswat] >= 0)
			{
	            if (PlayerData[i][pFactionRank] == 1)
				{ paycheck = info_salaireswat[rank][salaireswat1];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 2)
				{ paycheck = info_salaireswat[rank][salaireswat2];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 3)
				{ paycheck = info_salaireswat[rank][salaireswat3];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 4)
				{ paycheck = info_salaireswat[rank][salaireswat4];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 5)
				{ paycheck = info_salaireswat[rank][salaireswat5];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 6)
				{ paycheck = info_salaireswat[rank][salaireswat6];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 7)
				{ paycheck = info_salaireswat[rank][salaireswat7];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 8)
				{ paycheck = info_salaireswat[rank][salaireswat8];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 9)
				{ paycheck = info_salaireswat[rank][salaireswat9];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 10)
				{ paycheck = info_salaireswat[rank][salaireswat10];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 11)
				{ paycheck = info_salaireswat[rank][salaireswat11];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 12)
				{ paycheck = info_salaireswat[rank][salaireswat12];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 13)
				{ paycheck = info_salaireswat[rank][salaireswat13];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 14)
				{ paycheck = info_salaireswat[rank][salaireswat14];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 15)
				{ paycheck = info_salaireswat[rank][salaireswat15];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				argent_entreprise[moneyentrepriseid][argentswat] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][5] == 1 && argent_entreprise[moneyentrepriseid][argentmedecin] >= 0)
			{
	            if (PlayerData[i][pFactionRank] == 1)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste1];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 2)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste2];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 3)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste3];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 4)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste4];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 5)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste5];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 6)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste6];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 7)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste7];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 8)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste8];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 9)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste9];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 10)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste10];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 11)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste11];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 12)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste12];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 13)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste13];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 14)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste14];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 15)
				{ paycheck = info_salaireurgentiste[rank][salaireurgentiste15];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				argent_entreprise[moneyentrepriseid][argentmedecin] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if(FactionData[factionid][factionacces][7] == 1 && argent_entreprise[moneyentrepriseid][argentmairie] >= 0)
			{
	            if (PlayerData[i][pFactionRank] == 1)
				{ paycheck = info_salairemairie[rank][salairemairie1];
 				  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 2)
				{ paycheck = info_salairemairie[rank][salairemairie2];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 3)
				{ paycheck = info_salairemairie[rank][salairemairie3];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 4)
				{ paycheck = info_salairemairie[rank][salairemairie4];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 5)
				{ paycheck = info_salairemairie[rank][salairemairie5];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 6)
				{ paycheck = info_salairemairie[rank][salairemairie6];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 7)
				{ paycheck = info_salairemairie[rank][salairemairie7];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 8)
				{ paycheck = info_salairemairie[rank][salairemairie8];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 9)
				{ paycheck = info_salairemairie[rank][salairemairie9];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 10)
				{ paycheck = info_salairemairie[rank][salairemairie10];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 11)
				{ paycheck = info_salairemairie[rank][salairemairie11];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 12)
				{ paycheck = info_salairemairie[rank][salairemairie12];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 13)
				{ paycheck = info_salairemairie[rank][salairemairie13];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 14)
				{ paycheck = info_salairemairie[rank][salairemairie14];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				else if (PlayerData[i][pFactionRank] == 15)
				{ paycheck = info_salairemairie[rank][salairemairie15];
		  		  interettaxe = floatround((float(paycheck) / 100) * taxerevenue);}
				argent_entreprise[moneyentrepriseid][argentmairie] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][6] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][10] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][11] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][12] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][13] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][14] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
            else if (FactionData[factionid][factionacces][15] == 1 && FactionData[factionid][factioncoffre] >= 0)
			{
				paycheck = FactionData[factionid][factionsalaire][Derp];
				interettaxe = floatround((float(paycheck) / 100) * taxerevenue);
				FactionData[factionid][factioncoffre] -= paycheck;
		  		argent_entreprise[moneyentrepriseid][argentmairie] += interettaxe;
			}
			//bracelet electronic
			if (PlayerData[i][pBracelet] != 0)
			{
				foreach (new k : Player) if (FactionData[factionid][factionacces][1] == 1) {
					new Float:x,Float:y,Float:z;
					GetPlayerPos(i, x, y, z);
					if (PlayerData[i][pBraceletProx] == 1 && GetPlayerDistanceFromComico(i) > 1500)
					{
						SendServerMessage(i, "Vous êtes à %.0f Mètre du comissariat faite attention vous avez dépassé la limite", GetPlayerDistanceFromComico(i));
						if(FactionData[factionid][factionacces][1] == 1)
						{ SendServerMessage(i,"CENTRAL: (radio): %s s'est éloigné du périmètre déterminer il est à %s (%.0fMetre)",ReturnName(i, 0), GetLocation(x, y, z),GetPlayerDistanceFromComico(i));}
						SetPlayerCheckpoint(k, x, y, z, 4.0);
					}
					if (PlayerData[i][pBraceletProx] == 2 && GetPlayerDistanceFromComico(i) > 2500)
					{
						SendServerMessage(i, "Vous êtes à %.0f Mètre du comissariat faite attention vous avez dépassé la limite", GetPlayerDistanceFromComico(i));
						if(FactionData[factionid][factionacces][1] == 1)
						{ SendServerMessage(i,"CENTRAL: (radio): %s s'est éloigné du périmètre déterminer il est à %s (%.0fMetre)",ReturnName(i, 0), GetLocation(x, y, z),GetPlayerDistanceFromComico(i));}
						SetPlayerCheckpoint(k, x, y, z, 4.0);
					}
					if (PlayerData[i][pBraceletProx] == 3 && GetPlayerDistanceFromComico(i) > 3500)
					{
						SendServerMessage(i, "Vous êtes à %.0f Mètre du comissariat faite attention vous avez dépassé la limite", GetPlayerDistanceFromComico(i));
						if(FactionData[factionid][factionacces][1] == 1)
						{ SendServerMessage(i,"CENTRAL: (radio): %s s'est éloigné du périmètre déterminer il est à %s (%.0fMetre)",ReturnName(i, 0), GetLocation(x, y, z),GetPlayerDistanceFromComico(i));}
						SetPlayerCheckpoint(k, x, y, z, 4.0);
					}
				}
			}
			PlayerData[i][pBankMoney] += paycheck;
			PlayerData[i][pBankMoney] -= interettaxe;
			moneyentreprisesave(moneyentrepriseid);
			//compte épargne
			new savingsgain = floatround((PlayerData[i][pSavings] * 0.01)),count;
			if(argent_entreprise[moneyentrepriseid][argentbanque] >= 0)
			{
			    if(savingsgain <= 10000)
			    {
					PlayerData[i][pSavings] += savingsgain;
					argent_entreprise[moneyentrepriseid][argentbanque] -= savingsgain;
					moneyentreprisesave(moneyentrepriseid);
				}
				else
				{
					PlayerData[i][pSavings] += 10000;
					savingsgain = 10000;
					argent_entreprise[moneyentrepriseid][argentbanque] -= 10000;
					moneyentreprisesave(moneyentrepriseid);
				}
			}
			if(PlayerData[i][pOwnsBillboard] >= 0)
			{
			    if(PlayerData[i][pBankMoney] >= BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice])
			    {
				    SendClientMessage(i, COLOR_GREY, "---------------------------------------");
                	//taxe des maison et magason
					if(House_GetCount(i) != 0)
					{
					    new house = info_gouvernementinfo[gouvernementinfoid][gouvernementhouse];
						new ChargeM =  House_GetCount(i)*house;
						SendSalaireMessage(i, "Charges de la maison {FF0000}-%s$", FormatNumber(ChargeM));
						PlayerData[i][pBankMoney] -= ChargeM;
						argent_entreprise[moneyentrepriseid][argentmairie] += ChargeM;
					}
					
					if(Business_GetCount(i) != 0)
					{
					    new biz = info_gouvernementinfo[gouvernementinfoid][gouvernementbiz];
						new ChargeB =  Business_GetCount(i)*biz;
						SendSalaireMessage(i, "Charges du biz {FF0000}-%s$", FormatNumber(ChargeB));
						PlayerData[i][pBankMoney] -= ChargeB;
						argent_entreprise[moneyentrepriseid][argentmairie] += ChargeB;
					}
					if(PlayerData[i][pLocaID] > 0)
					{
					    SendSalaireMessage(i, "Charges du vehicule louer {FF0000}-200$");
					    PlayerData[i][pBankMoney] -= 200;
						for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][13] == 1) {
							count++;
						}
						for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][13] == 1)
						{
							new aye = 200 / count;
							if(FactionData[ii][factionacces][13] == 1)
							{
								FactionData[ii][factioncoffre] += aye;
								Faction_Save(ii);
							}
						}
					}
	         		SendSalaireMessage(i, "Vous avez reçus votre salaire de {33CC33}%s{FFFFFF}$ il a été viré sur votre compte bancaire.", FormatNumber(paycheck));
	         		SendSalaireMessage(i, "Vous payez {FF0000}%s{FFFFFF}$ de taxe sur le revenu.", FormatNumber(interettaxe));
	         		SendSalaireMessage(i, "Vous avez touché {33CC33}%s{FFFFFF}$ sur votre compte épargne.", FormatNumber(savingsgain));
	         		SendSalaireMessage(i, "{FF0000}%s{FFFFFF}$ a été déduit de votre compte bancaire pour la location du panneau d'affichage", FormatNumber(BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice]));
					SendClientMessage(i, COLOR_GREY, "---------------------------------------");
					PlayerData[i][pBankMoney] -= BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice];
					argent_entreprise[moneyentrepriseid][argentjournaliste] += BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice];
					moneyentreprisesave(moneyentrepriseid);
					return 1;
				}
                if(PlayerData[i][pBankMoney] < BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice])
			    {
			        SendClientMessage(i, COLOR_GREY, "---------------------------------------");
		         	//taxe des maison et magason
					if(House_GetCount(i) != 0)
					{
					    new house = info_gouvernementinfo[gouvernementinfoid][gouvernementhouse];
						new ChargeM =  House_GetCount(i)*house;
						SendSalaireMessage(i, "Charges de la maison {FF0000}-%s$", FormatNumber(ChargeM));
						PlayerData[i][pBankMoney] -= ChargeM;
						argent_entreprise[moneyentrepriseid][argentmairie] += ChargeM;
					}
					if(Business_GetCount(i) != 0)
					{
					    new biz = info_gouvernementinfo[gouvernementinfoid][gouvernementbiz];
						new ChargeB =  Business_GetCount(i)*biz;
						SendSalaireMessage(i, "Charges du biz {FF0000}-%s$", FormatNumber(ChargeB));
						PlayerData[i][pBankMoney] -= ChargeB;
						argent_entreprise[moneyentrepriseid][argentmairie] += ChargeB;
					}
					if(PlayerData[i][pLocaID] > 0)
					{
					    SendSalaireMessage(i, "Charges du vehicule louer {FF0000}-200$");
					    PlayerData[i][pBankMoney] -= 200;
						for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
							count++;
						}
						for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
						{
							new aye = 200 / count;
							if(FactionData[ii][factionacces][12] == 1)
							{
								FactionData[ii][factioncoffre] += aye;
								Faction_Save(ii);
							}
						}
					}
					moneyentreprisesave(moneyentrepriseid);
	         		SendSalaireMessage(i, "Vous avez reçus votre salaire de {33CC33}%s{FFFFFF}$ il a été viré sur votre compte bancaire.", FormatNumber(paycheck));
	         		SendSalaireMessage(i, "Vous payez {FF0000}%s{FFFFFF}$ de taxe sur le revenu.", FormatNumber(interettaxe));
	         		SendSalaireMessage(i, "Vous avez touché {33CC33}%s{FFFFFF}$ sur votre compte épargne.", FormatNumber(savingsgain));
	         		SendSalaireMessage(i, "Vous ne pouvez pas payer pour votre panneau de pub, par conséquent, il a été délouer");
					SendClientMessage(i, COLOR_GREY, "---------------------------------------");
					BillBoardData[PlayerData[i][pOwnsBillboard]][bbOwner] = 0;
					Billboard_Save(PlayerData[i][pOwnsBillboard]);
					Billboard_Refresh(PlayerData[i][pOwnsBillboard]);
					PlayerData[i][pOwnsBillboard] = -1;
				}
				return 1;
			}
         	SendClientMessage(i, COLOR_GREY, "---------------------------------------");
         	//taxe des maison et magason
			if(House_GetCount(i) != 0)
			{
			    new house = info_gouvernementinfo[gouvernementinfoid][gouvernementhouse],ChargeM =  House_GetCount(i)*house;
				SendSalaireMessage(i, "Charges de(s) la(es) maison(s) {FF0000}-%s$", FormatNumber(ChargeM));
				PlayerData[i][pBankMoney] -= ChargeM;
				argent_entreprise[moneyentrepriseid][argentmairie] += ChargeM;
			}
			if(Business_GetCount(i) != 0)
			{
			    new biz = info_gouvernementinfo[gouvernementinfoid][gouvernementbiz],ChargeB =  Business_GetCount(i)*biz;
				SendSalaireMessage(i, "Charges du(es) magasin(s) {FF0000}-%s$", FormatNumber(ChargeB));
				PlayerData[i][pBankMoney] -= ChargeB;
				argent_entreprise[moneyentrepriseid][argentmairie] += ChargeB;
			}
			if(PlayerData[i][pLocaID] > 0)
			{
			    SendSalaireMessage(i, "Charges du vehicule louer {FF0000}-200$");
			    PlayerData[i][pBankMoney] -= 200;
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 200 / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			moneyentreprisesave(moneyentrepriseid);
         	SendSalaireMessage(i, "Vous avez reçus votre salaire de {33CC33}%s{FFFFFF}$ il a été viré sur votre compte bancaire.", FormatNumber(paycheck));
         	SendSalaireMessage(i, "Vous payez {FF0000}%s{FFFFFF}$ de taxe sur le revenu.", FormatNumber(interettaxe));
         	SendSalaireMessage(i, "Vous avez touché {33CC33}%s{FFFFFF}$ sur votre compte épargne.", FormatNumber(savingsgain));
			SendClientMessage(i, COLOR_GREY, "---------------------------------------");
		}
		if (PlayerData[i][pInjured])
		{
		    GetPlayerHealth(i, hp);
		    SetPlayerHealth(i, hp - 10.0);
		}
	}
	for (new i = 0; i != MAX_DRUG_PLANTS; i ++) if (PlantData[i][plantExists] && PlantData[i][plantDrugs] < Plant_MaxGrams(PlantData[i][plantType])) {
	    PlantData[i][plantDrugs]++;
	    Plant_Refresh(i);
	    Plant_Save(i);
	}
	return 1;
}
script PlayerCheck()
{
	static str[128],Float:health,id = -1;
	TotalledCheck();
	RestartCheck();
	foreach (new i : Player)
	{
	    if (!PlayerData[i][pLogged] && !PlayerData[i][pCharacter])
	        continue;
        new factionid = PlayerData[i][pFaction];
		if (PlayerData[i][pTutorial] > 0)
		{
		    PlayerData[i][pTutorialTime]--;
		    if (PlayerData[i][pTutorialTime] < 1)
		    {
		        switch (PlayerData[i][pTutorial])
		        {
		            case 8:
		            {
		                for (new j = 58; j < 62; j ++) {
		                    PlayerTextDrawHide(i, PlayerData[i][pTextdraws][j]);
						}
		                PlayerData[i][pCreated] = 1;
		                PlayerData[i][pTask] = 1;
		                PlayerData[i][pTutorial] = 0;
		                PlayerData[i][pTutorialTime] = 0;
		                SetPlayerCameraLookAt(i,1404.5933, -1594.4730, 95.4797);
						SetPlayerCameraPos(i, 1403.7042, -1594.0187, 96.0647);//nImmigrant
						Dialog_Show(i, Spawntype, DIALOG_STYLE_LIST, "D'où vous venez?", "Voyage d'affaires\nRésident ailleur\nMutation", "Accepter", "");
		            }
		        }
		    }
		}
		if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK && !PlayerData[i][pJetpack])
		{
	    	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s JETPACK HACK.", ReturnName(i, 0));
	    	Log_Write("logs/cheat_log.txt", "[%s] %s JETPACK HACK.", ReturnDate(), ReturnName(i, 0));
		}
		if (GetPlayerSpeed(i) > 210)
		{
		    if (!IsAPlane(GetPlayerVehicleID(i)) && GetPlayerState(i) != PLAYER_STATE_PASSENGER)
		    {
		        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s SPEED HACK POSSIBLE (%.0f km/h).", ReturnName(i, 0), GetPlayerSpeed(i));
		        Log_Write("logs/cheat_log.txt", "[%s] %s SPEED HACK POSSIBLE (%.0f km/h).", ReturnDate(), ReturnName(i, 0), GetPlayerSpeed(i));
                KickEx(i);
			}
		}
		if(PlayerData[i][pChannel] == 911 && FactionData[factionid][factionacces][1] == 0) {PlayerData[i][pChannel] = 0;}
		if (PlayerData[i][pPicking])
		{
			if ((id = PlayerData[i][pPickCar]) != -1)
			{
			    if (Car_Nearest(i) != id)
			    {
			        PlayerData[i][pPicking] = 0;
			        PlayerData[i][pPickCar] = -1;
			        PlayerData[i][pPickTime] = 0;
				}
				else
				{
				    PlayerData[i][pPickTime]++;
				    format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~forcage en cours... %d", 120 - PlayerData[i][pPickTime]);
					GameTextForPlayer(i, str, 1000, 3);

					if (PlayerData[i][pPickTime] >= 120)
					{
                        static engine, lights, alarm, doors, bonnet, boot, objective;
						new rand = random(4);
 						switch(rand)
						{
        					case 0 .. 2:
							{
							    GetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
								SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, 0, bonnet, boot, objective);
							}
        					case 3:
							{
							    GetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
								SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, 1, 0, bonnet, boot, objective);
							}
 						}
                        PlayerData[i][pPicking] = 0;
                        PlayerData[i][pPickCar] = -1;
                        PlayerData[i][pPickTime] = 0;
                        CarData[id][carLocked] = 0;
						Car_Save(id);
					    SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** %s a forcé le vehicule.", ReturnName(i, 0));
					    ShowPlayerFooter(i, "Tu a ~g~ouvert~w~ le vehicule.!");
					}
				}
		    }
		}
		if (!PlayerData[i][pKilled] && PlayerData[i][pHospital] != -1)
		{
			PlayerData[i][pHospitalTime]++;
			format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Repos... %d", 15 - PlayerData[i][pHospitalTime]);
			GameTextForPlayer(i, str, 1000, 3);
			ApplyAnimation(i, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);

			if (PlayerData[i][pHospitalTime] >= 15)
			{
       			SetPlayerPosEx(i, -204.5867, -1740.7955, 675.7687);
			    SetPlayerFacingAngle(i, 0.0000);
			    TogglePlayerControllable(i, 1);
			    SetCameraBehindPlayer(i);
			    SetPlayerVirtualWorld(i, PlayerData[i][pHospital] + 5000);
			    SendServerMessage(i, "Vous avez été reçus au plus proche d'un hopital.");
			    GameTextForPlayer(i, " ", 1, 3);
			    ShowHungerTextdraw(i, 1);
			    PlayerData[i][pHospitalInt] = PlayerData[i][pHospital];
			    PlayerData[i][pHospital] = -1;
			    PlayerData[i][pHospitalTime] = 0;
			}
		}
		else if (PlayerData[i][pMuted] && PlayerData[i][pMuteTime] > 0)
		{
		    PlayerData[i][pMuteTime]--;
		    if (!PlayerData[i][pMuteTime])
		    {
				PlayerData[i][pMuted] = 0;
				PlayerData[i][pMuteTime] = 0;
		    }
		}
		else if (PlayerData[i][pGraffiti] != -1 && PlayerData[i][pGraffitiTime] > 0)
		{
			if (Graffiti_Nearest(i) != PlayerData[i][pGraffiti])
			{
			    PlayerData[i][pGraffiti] = -1;
                PlayerData[i][pGraffitiTime] = 0;
			}
			else
			{
	            PlayerData[i][pGraffitiTime]--;

	            if (PlayerData[i][pGraffitiTime] < 1)
				{
				    strunpack(str, PlayerData[i][pGraffitiText]);
	                format(GraffitiData[PlayerData[i][pGraffiti]][graffitiText], 64, str);

				    GraffitiData[PlayerData[i][pGraffiti]][graffitiColor] = PlayerData[i][pGraffitiColor];

					Graffiti_Refresh(PlayerData[i][pGraffiti]);
				    Graffiti_Save(PlayerData[i][pGraffiti]);

				    ClearAnimations(i, 1);
					SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** %s jette sa spraycan.", ReturnName(i, 0));

	                PlayerData[i][pGraffiti] = -1;
	                PlayerData[i][pGraffitiTime] = 0;
				}
			}
		}
		else if (PlayerData[i][pSpamCount] > 0)
		{
		    PlayerData[i][pSpamCount]--;
		}
		else if (PlayerData[i][pCommandCount] > 0)
		{
		    PlayerData[i][pCommandCount]--;
		}
		else if (PlayerData[i][pVendorTime] > 0)
		{
		    PlayerData[i][pVendorTime]--;
		}
		else if (PlayerData[i][pDrinkTime] > 0)
		{
		    PlayerData[i][pDrinkTime]--;
		}
		else if (PlayerData[i][pAdTime] > 0)
		{
		    PlayerData[i][pAdTime]--;
		}
		else if (PlayerData[i][pSpeedTime] > 0)
		{
		    PlayerData[i][pSpeedTime]--;
		}
		else if (PlayerData[i][pBleeding] && PlayerData[i][pBleedTime] > 0)
		{
		    if (--PlayerData[i][pBleedTime] == 0)
		    {
		        SetPlayerHealth(i, ReturnHealth(i) - 3.0);
			    PlayerData[i][pBleedTime] = 10;

			    CreateBlood(i);
			    SetTimerEx("HidePlayerBox", 500, false, "dd", i, _:ShowPlayerBox(i, 0xFF000066));
			}
		}
		else if (PlayerData[i][pFingerTime] > 0)
		{
		    PlayerData[i][pFingerTime]--;

		    if (!PlayerData[i][pFingerTime] && DroppedItems[PlayerData[i][pFingerItem]][droppedModel] && IsPlayerInRangeOfPoint(i, 1.5, DroppedItems[PlayerData[i][pFingerItem]][droppedPos][0], DroppedItems[PlayerData[i][pFingerItem]][droppedPos][1], DroppedItems[PlayerData[i][pFingerItem]][droppedPos][2]))
		    {
		        SendServerMessage(i, "Le prenneur d'empreinte digital a trouver quelque chose:: %s.", DroppedItems[PlayerData[i][pFingerItem]][droppedPlayer]);
                PlayerData[i][pFingerItem] = -1;
			}
		}
		else if (PlayerData[i][pDrugUsed] != 0 && PlayerData[i][pDrugTime] > 0)
		{
		    if (--PlayerData[i][pDrugTime] && 1 <= PlayerData[i][pDrugUsed] <= 3 && GetPlayerDrunkLevel(i) < 5000) {
		        SetPlayerDrunkLevel(i, 10000);

				PlayerTextDrawShow(i, PlayerData[i][pTextdraws][8]);

				if (PlayerData[i][pDrugUsed] == 3) {
				    SetPlayerWeather(i, -67);
				    SetPlayerTime(i, 12, 12); // Set the time (the drug weather is buggy at night)
				}
			}
		    if (1 <= PlayerData[i][pDrugUsed] <= 3 && ReturnHealth(i) <= 95) {
		    	SetPlayerHealth(i, ReturnHealth(i) + 5);
			}
		    if (!PlayerData[i][pDrugTime])
		    {
		        new time[3];

        		gettime(time[0], time[1], time[2]);
				SetPlayerTime(i, time[0], time[1]);
                SetPlayerWeather(i, 0);
		        SetPlayerDrunkLevel(i, 500);
				PlayerTextDrawHide(i, PlayerData[i][pTextdraws][8]);

				PlayerData[i][pDrugUsed] = 0;
		        SendServerMessage(i, "Les effets se son dissiper.");
		    }
		}
		else if (PlayerData[i][pStunned] > 0)
		{
            PlayerData[i][pStunned]--;

			if (GetPlayerAnimationIndex(i) != 388)
            	ApplyAnimation(i, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);

            if (!PlayerData[i][pStunned])
            {
                TogglePlayerControllable(i, 1);
                ShowPlayerFooter(i, "Vous n'est plus ~r~paralyzer.");
			}
		}
		else if (PlayerData[i][pJailTime] > 0)
		{
		    static hours,minutes,seconds;
		    PlayerData[i][pJailTime]--;
			GetElapsedTime(PlayerData[i][pJailTime], hours, minutes, seconds);
			format(str, sizeof(str), "~g~Prison Admin:~w~ %02d:%02d:%02d", hours, minutes, seconds);
			PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][70], str);

		    if (!PlayerData[i][pJailTime])
		    {
		        PlayerData[i][pPrisoned] = 0;
		        new serveursettinginfoid;
				if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 1)
				{
					SetPlayerPos(i,2096.7385, -1687.4127, 13.4706);
					SetPlayerFacingAngle(i,342.7732);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
				}
				else if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 2)
				{
					SetPlayerPos(i,-1604.3302,721.8452,11.7487);
					SetPlayerFacingAngle(i,358.4156);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
				}
				else if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 3)
				{
					SetPlayerPos(i,2476.6553,1881.8040,9.7135);
					SetPlayerFacingAngle(i,358.4156);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
				}
				else if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 5)
				{
					SetPlayerPos(i,2403.1904,-1414.2330,4.5730);
					SetPlayerFacingAngle(i,358.4156);
					SetPlayerInterior(i, 0);
					SetPlayerVirtualWorld(i, 0);
				}
		        ShowHungerTextdraw(i, 1);
                TogglePlayerControllable(i, 1);
				SendServerMessage(i, "Tu as été libéré.");
		        PlayerTextDrawHide(i, PlayerData[i][pTextdraws][70]);
			}
		}
		else if (PlayerData[i][pTrackTime] > 0 && IsPlayerConnected(PlayerData[i][pMDCPlayer]) && FactionData[factionid][factionacces][1] == 1)
		{
		    PlayerData[i][pTrackTime]--;
		    if (!PlayerData[i][pTrackTime])
		    {
		        if ((id = House_Inside(PlayerData[i][pMDCPlayer])) != -1)
				{
				    PlayerData[i][pCP] = 1;

				    SetPlayerCheckpoint(i, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2], 3.0);
		            SendServerMessage(i, "%s derniere location était vers \"%s\" (sur le radar).", ReturnName(PlayerData[i][pMDCPlayer], 0), HouseData[id][houseAddress]);
		        }
		        else if ((id = Business_Inside(PlayerData[i][pMDCPlayer])) != -1)
		        {
		            PlayerData[i][pCP] = 1;

		            SetPlayerCheckpoint(i, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2], 3.0);
		            SendServerMessage(i, "%s derniere location était vers \"%s\" (sur le radar).", ReturnName(PlayerData[i][pMDCPlayer], 0), BusinessData[id][bizName]);
		        }
		        else if (GetPlayerInterior(PlayerData[i][pMDCPlayer]) == 0)
		        {
		            static Float:fX,Float:fY,Float:fZ;

		            GetPlayerPos(PlayerData[i][pMDCPlayer], fX, fY, fZ);
		            PlayerData[i][pCP] = 1;

                    SetPlayerCheckpoint(i, fX, fY, fZ, 3.0);
		            SendServerMessage(i, "%s derniere location était vers \"%s\" (sur le radar).", ReturnName(PlayerData[i][pMDCPlayer], 0), GetLocation(fX, fY, fZ));
		        }
		        else
		        {
		            SendServerMessage(i, "Incapable de localisé %s; la cible est hors de porté (dans un intérieur).", ReturnName(PlayerData[i][pMDCPlayer], 0));
				}
			}
		}
		else if (PlayerData[i][pCooking] && IsPlayerSpawned(i))
		{
		    PlayerData[i][pCookingTime]--;

		    if (House_Inside(i) == PlayerData[i][pCookingHouse])
		    {
			    format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~~h~preparation...~w~ %d seconds", PlayerData[i][pCookingTime]);
			    GameTextForPlayer(i, str, 1200, 3);
			}
		    if (PlayerData[i][pCookingTime] < 1)
		    {
		        if (House_Inside(i) != PlayerData[i][pCookingHouse])
		        {
		            SendServerMessage(i, "Ta nourriture a griller.");
		        }
		        else
				{
					switch (PlayerData[i][pCooking])
		        	{
                    	case 1:
		            	{
		               	    id = Inventory_Add(i, "Burger cuit", 2703, 1);
		               	    if (id == -1)
		               	        return SendErrorMessage(i, "vous n'avez pas de place sur vous.");
		                	SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** Le micro-ondes sonne, tu peut sentir le burger! (( %s ))", ReturnName(i, 0));
		                	SendServerMessage(i, "Le burger cuit a été ajouter dans votre inventaire.");
		            	}
			            case 2:
			            {
			                id = Inventory_Add(i, "Pizza cuite", 2702, 6);
			                if (id == -1)
		               	        return SendErrorMessage(i, "vous n'avez pas de place sur vous.");
		    	            SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** Le four sonne, tu peut sentir la pizza! (( %s ))", ReturnName(i, 0));
		    	            SendServerMessage(i, "La pizza cuit a été ajouter dans votre inventaire.");
		        	    }
			            case 3:
			            {
			                id = Inventory_Add(i,"jambon cuit", 19847,1);
			                if (id == -1)
		               	        return SendErrorMessage(i, "vous n'avez pas de place sur vous.");
		    	            SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** Le four sonne, tu peut sentir le jambon! (( %s ))", ReturnName(i, 0));
		    	            SendServerMessage(i, "Le jambon a été ajouter dans votre inventaire.");
		        	    }
					}
				}
                PlayerData[i][pCooking] = 0;
                PlayerData[i][pCookingTime] = 0;
                PlayerData[i][pCookingHouse] = -1;
		    }
		}
		else if (PlayerData[i][pDrivingTest] && IsPlayerInVehicle(i, PlayerData[i][pTestCar]))
		{
		    if (!IsPlayerInRangeOfPoint(i, 600.0, g_arrDrivingCheckpoints[PlayerData[i][pTestStage]][0], g_arrDrivingCheckpoints[PlayerData[i][pTestStage]][1], g_arrDrivingCheckpoints[PlayerData[i][pTestStage]][2]))
			{
		        CancelDrivingTest(i);
				SendClientMessage(i, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Tu a échoué car tu a quitté la zone.");
    		}
			else if (GetPlayerSpeed(i) >= 59.0)
   			{
				if (++PlayerData[i][pTestWarns] < 3)
				{
    				SendClientMessageEx(i, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Pas si vite ralentie!!!! (%d/3)", PlayerData[i][pTestWarns]);
        		}
	       		else
				{
    				CancelDrivingTest(i);
        			SendClientMessage(i, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Tu a échoué car tu roulais trop vite");
			    }
			}
		}
		else if (IsPlayerInsideTaxi(i))
		{
		    PlayerData[i][pTaxiTime]++;

		    if (PlayerData[i][pTaxiTime] == 15)
		    {
		        PlayerData[i][pTaxiTime] = 0;
		        PlayerData[i][pTaxiFee] += 10;
		    }
		    format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~$%d...~w~ %d secondes", PlayerData[i][pTaxiFee], PlayerData[i][pTaxiTime]);

			GameTextForPlayer(i, str, 1100, 3);
			GameTextForPlayer(GetVehicleDriver(GetPlayerVehicleID(i)), str, 1100, 3);
		}
		if (PlayerData[i][pCreated] && !PlayerData[i][pTutorial] && !PlayerData[i][pJailTime] && !PlayerData[i][pInjured] && PlayerData[i][pHospital] == -1 && PlayerData[i][pCreated] && IsPlayerSpawned(i))
		{
		    GetPlayerHealth(i, health);

		    if (++ PlayerData[i][pHungerTime] >= 300)
			{
				if (PlayerData[i][pHunger] > 0)
				{
    	        	PlayerData[i][pHunger]--;
    		    }
        		else if (PlayerData[i][pHunger] <= 0)
				{
    	        	SetPlayerHealth(i, health - 10);
        		}
        		PlayerData[i][pHungerTime] = 0;
        	}
	        if (++ PlayerData[i][pThirstTime] >= 280)
			{
				if (PlayerData[i][pThirst] > 0)
				{
    	        	PlayerData[i][pThirst]--;
				}
				else if (PlayerData[i][pThirst] <= 0)
				{
		        	SetPlayerHealth(i, health - 5);
        	    	FlashTextDraw(i, PlayerData[i][pTextdraws][66]);
        		}
        		PlayerData[i][pThirstTime] = 0;
			}
		}
		if ((id = Boombox_Nearest(i)) != INVALID_PLAYER_ID && PlayerData[i][pBoombox] != id && strlen(BoomboxData[id][boomboxURL]) && !IsPlayerInAnyVehicle(i))
		{
		    strunpack(str, BoomboxData[id][boomboxURL]);
		    PlayerData[i][pBoombox] = id;

		    StopAudioStreamForPlayer(i);
		    PlayAudioStreamForPlayer(i, str, BoomboxData[id][boomboxPos][0], BoomboxData[id][boomboxPos][1], BoomboxData[id][boomboxPos][2], 30.0, 1);
		}
		else if (PlayerData[i][pBoombox] != INVALID_PLAYER_ID && !IsPlayerInRangeOfPoint(i, 30.0, BoomboxData[PlayerData[i][pBoombox]][boomboxPos][0], BoomboxData[PlayerData[i][pBoombox]][boomboxPos][1], BoomboxData[PlayerData[i][pBoombox]][boomboxPos][2]))
		{
		    PlayerData[i][pBoombox] = INVALID_PLAYER_ID;
		    StopAudioStreamForPlayer(i);
		}
		if (PlayerData[i][pInjured] == 1 && GetPlayerAnimationIndex(i) != 388)
		{
			ApplyAnimation(i, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
		}
        if (PlayerData[i][pHealthTime] > 0)
        {
            PlayerData[i][pHealthTime]--;
		}
		if (PlayerData[i][pRangeBooth] != -1 && !IsPlayerInRangeOfPoint(i, 1.5, arrBoothPositions[PlayerData[i][pRangeBooth]][0], arrBoothPositions[PlayerData[i][pRangeBooth]][1], arrBoothPositions[PlayerData[i][pRangeBooth]][2]))
		{
			Booth_Leave(i);
		}
	}
	return 1;
}

script UpdateTime1()
{
	static time[3],string[64];
	gettime(time[0], time[1], time[2]);
	if (time[0] >= 12)
		format(string, 32, "%02d:%02d PM", (time[0] == 12) ? (12) : (time[0] - 12), time[1]);
	else if (time[0] < 12)
		format(string, 32, "%02d:%02d AM", (time[0] == 0) ? (12) : (time[0]), time[1]);
	if(time[0] == 5 && time[1] == 0)
	{
		TextDrawShowForAll(gServerTextdraws[3]);
		g_ServerRestart = 1;
		g_RestartTime = 120;
		SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: Le serveur a commencer un restart et sera effectué a %d seconds.",time);
	}
	TextDrawSetString(gServerTextdraws[0], string);
	foreach (new i : Player) if (PlayerData[i][pDrugUsed] != 3) {
		SetPlayerTime(i, time[0], time[1]);
	}
	SetTimer("UpdateTime1", 30000, false);
}
script RefuelCheck()
{
	new string[128];
 	foreach (new i : Player)
 	{
    	if (!PlayerData[i][pLogged] || PlayerData[i][pRefill] == INVALID_VEHICLE_ID)
         	continue;

		if (PlayerData[i][pRefill] != INVALID_VEHICLE_ID && PlayerData[i][pGasPump] != -1)
		{
      		PlayerData[i][pRefillPrice] +=2;
      		CarData[PlayerData[i][pRefill]][carfuel] += 1;
      		PumpData[PlayerData[i][pGasPump]][pumpFuel] -= 1;

			if (PumpData[PlayerData[i][pGasPump]][pumpExists])
			{
				format(string, sizeof(string), "[Pompe à essence: %d]\n{FFFFFF}Essence: %d litres", PlayerData[i][pGasPump], PumpData[PlayerData[i][pGasPump]][pumpFuel]);
				UpdateDynamic3DTextLabelText(PumpData[PlayerData[i][pGasPump]][pumpText3D], COLOR_DARKBLUE, string);
	   		}
	   		if (CarData[PlayerData[i][pRefill]][carfuel] >= 100 || GetEngineStatus(PlayerData[i][pRefill]) || !PumpData[PlayerData[i][pGasPump]][pumpExists] || PumpData[PlayerData[i][pGasPump]][pumpFuel] < 0)
	   		{
				CarData[PlayerData[i][pRefill]][carfuel] = 100;

				GiveMoney(i, -PlayerData[i][pRefillPrice]);
				SendVehiculeMessage(i, "Vous avez rempli votre véhicule pour %d dollars.", PlayerData[i][pRefillPrice]);
				TogglePlayerControllable(i,1);
				if (PumpData[PlayerData[i][pGasPump]][pumpExists])
				{
					if (PumpData[PlayerData[i][pGasPump]][pumpFuel] < 0)
		      		PumpData[PlayerData[i][pGasPump]][pumpFuel] = 0;
					BusinessData[PlayerData[i][pGasStation]][bizVault] += PlayerData[i][pRefillPrice];
		     		Business_Save(PlayerData[i][pGasStation]);
		     		Pump_Save(PlayerData[i][pGasPump]);
				}
		    	StopRefilling(i);
   			}
		}
 	}
	return 1;
}
script FuelUpdate()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsEngineVehicle(i) && GetEngineStatus(i))
	{
	    new idk = Car_GetID(i);
	    if (CarData[idk][carfuel] > 0)
	    {
	        CarData[idk][carfuel]--;

			if (CarData[idk][carfuel] >= 1 && CarData[idk][carfuel] <= 5)
			{
			    SendClientMessage(GetVehicleDriver(idk), COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Ce véhicule à presque plus de carburant. Vous devez aller à une station service!");
			}
		}
		if (CarData[idk][carfuel] <= 0)
		{
		    CarData[idk][carfuel] = 0;
		    SetEngineStatus(i, false);
		}
	}
}
script OnVehicleDeath(vehicleid)
{
	if (CoreVehicles[vehicleid][vehTemporary])
	{
	    CoreVehicles[vehicleid][vehTemporary] = false;
	    DestroyVehicle(vehicleid);
	}
	for (new i = 0; i != MAX_DYNAMIC_OBJ; i ++) if (CrateData[i][crateExists] && CrateData[i][crateVehicle] == vehicleid) {
	    Crate_Delete(i);
	}
	//clignotant
	if(Indicators_xqz[vehicleid][2]) DestroyDynamicObject(Indicators_xqz[vehicleid][2]), DestroyDynamicObject(Indicators_xqz[vehicleid][3]),DestroyDynamicObject(Indicators_xqz[vehicleid][5]),Indicators_xqz[vehicleid][2]=0;
	if(Indicators_xqz[vehicleid][0]) DestroyDynamicObject(Indicators_xqz[vehicleid][0]), DestroyDynamicObject(Indicators_xqz[vehicleid][1]),DestroyDynamicObject(Indicators_xqz[vehicleid][4]),Indicators_xqz[vehicleid][0]=0;
	return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	SetVehicleColor(vehicleid, CarData[vehicleid][carColor1], CarData[vehicleid][carColor2]);
	return 1;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	SetVehiclePaintjob(vehicleid, CarData[vehicleid][carPaintjob]);
	return 1;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	new id = Car_GetID(vehicleid),slot = GetVehicleComponentType(componentid);
	if (id != -1)
	{
	    CarData[id][carMods][slot] = componentid;
	    Car_Save(id);
	}
	return 1;
}
public OnVehicleSpawn(vehicleid)
{
	vehiclecallsign[vehicleid] = 0;
    if (CoreVehicles[vehicleid][vehTemporary])
	{
	    CoreVehicles[vehicleid][vehTemporary] = false;
	    DestroyVehicle(vehicleid);
	}
    for (new i = 0; i != MAX_DYNAMIC_OBJ; i ++) if (CrateData[i][crateExists] && CrateData[i][crateVehicle] == vehicleid) {
	    Crate_Delete(i);
	}
	if (IsValidObject(CoreVehicles[vehicleid][vehCrate]) && GetVehicleModel(vehicleid) == 530)
	    DestroyObject(CoreVehicles[vehicleid][vehCrate]);
	ResetVehicle(vehicleid);
	return 1;
}
script OnRconLoginAttempt(ip[], password[], success)
{
	if (!success)
	{
	    foreach (new i : Player) if (!strcmp(PlayerData[i][pIP], ip, true) && PlayerData[i][pAdmin] < 4) {
	        Kick(i);
	    }
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: RCON tentative de connexion a échoué \"%s\".", ip);
	    Log_Write("logs/rcon_log.txt", "[%s] RCON tentative de connexion a échoué \"%s\".", ReturnDate(), ip);
	}
	else
	{
	    foreach (new i : Player) if (!strcmp(PlayerData[i][pIP], ip, true) && PlayerData[i][pAdmin] < 4) {
	        Blacklist_Add(ip, PlayerData[i][pUsername], "Server", "Unauthorized RCON");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a été interdit pour la connexion à RCON sans autorisation.", ReturnName(i, 0));
	    	Log_Write("logs/rcon_log.txt", "[%s] %s (%s) a été interdit pour une connexion non autorisée RCON.", ReturnDate(), ReturnName(i, 0), ip);
			break;
		}
	}
	return 1;
}
script OnPlayerStreamIn(playerid, forplayerid)
{
    if (PlayerData[playerid][pMaskOn])
		ShowPlayerNameTagForPlayer(forplayerid, playerid, 0);
	else
	    ShowPlayerNameTagForPlayer(forplayerid, playerid, 1);
	return 1;
}

script OnPlayerUseItem(playerid, itemid, name[])
{
    if (IsFurnitureItem(name))
	{
		new id = House_Inside(playerid);
        if (id == -1)
            return SendErrorMessage(playerid, "Vous devez être à l'intérieur d'une maison pour placer les meubles.");
		if (!House_IsOwner(playerid, id))
		    return SendErrorMessage(playerid, "Vous pouvez placer des meubles que dans votre propre maison.");
		static Float:x,Float:y,Float:z,Float:angle;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);
        x += 5.0 * floatsin(-angle, degrees);
        y += 5.0 * floatcos(-angle, degrees);
		if (Furniture_GetCount(id) > MAX_HOUSE_FURNITURE)
		    return SendErrorMessage(playerid, "Vous ne pouvez avoir %d articles meubles dans votre maison.", MAX_HOUSE_FURNITURE);
		new furniture = Furniture_Add(id, name, InventoryData[playerid][itemid][invModel], x, y, z, 0.0, 0.0, angle);
		if (furniture == -1)
		    return SendErrorMessage(playerid, "Le serveur a atteint la limite de meubles.");
		Inventory_Remove(playerid, name);
		PlayerData[playerid][pEditFurniture] = furniture;
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à poser un(e) \"%s\".", ReturnName(playerid, 0), name);
		EditDynamicObject(playerid, FurnitureData[furniture][furnitureObject]);
	}
	else if (!strcmp(name, "cigarette", true)) {
	    cmd_fumer(playerid, "\1");
	}
	else if (!strcmp(name, "paquet de cigarette cs", true)) {
	    cmd_cigarette1(playerid, "\1");
	}
	else if (!strcmp(name, "paquet de cigarette ck", true)) {
	    cmd_cigarette2(playerid, "\1");
	}
	else if (!strcmp(name, "Chargeur", true)) {
	    cmd_usemag(playerid, "\1");
	}
	else if (!strcmp(name, "tournevis", true)) {
	    cmd_crocheterporte(playerid, "\1");
	}
	else if (!strcmp(name, "Munition", true)) {
	    cmd_chargeur(playerid, "\1");
	}
	else if (!strcmp(name, "Boombox", true)) {
	    cmd_boombox(playerid, "place");
	}
	else if (!strcmp(name, "Backpack", true)) {
	    cmd_sacados(playerid, "\1");
	}
	else if (!strcmp(name, "Trousse de soin", true)) {
        cmd_trousse(playerid, "\1");
    }
    else if (!strcmp(name, "Telephone", true)) {
        cmd_tel(playerid, "\1");
    }
    else if(!strcmp(name,"Chargeur telephone", true)) {
        cmd_recharger(playerid,"\1");
	}
    else if (!strcmp(name, "Talkie-Walkie", true)) {
        SendSyntaxMessage(playerid, "Faite \"/r [texte]\" pour discuter avec votre radio.");
    }
    else if (!strcmp(name, "Jerrican", true)) {
        cmd_jerrican(playerid, "\1");
    }
    else if (!strcmp(name, "Boite a outils", true)) {
        cmd_reparermoteur(playerid, "\1");
    }
    else if (!strcmp(name, "Bonbonne de NOS", true)) {
        cmd_nitros(playerid, "\1");
    }
    else if (!strcmp(name, "Bombe de peinture", true)) {
        cmd_peindre(playerid, "\1");
    }
    else if (!strcmp(name, "Systeme GPS", true)) {
        cmd_gps(playerid, "\1");
    }
    else if (!strcmp(name, "Marijuana", true)) {
        cmd_udrogue(playerid, "marijuana");
    }
    else if (!strcmp(name, "Cocaine", true)) {
        cmd_udrogue(playerid, "cocaine");
    }
    else if (!strcmp(name, "Heroin", true)) {
        cmd_udrogue(playerid, "heroin");
    }
    else if (!strcmp(name, "Steroids", true)) {
        cmd_udrogue(playerid, "steroids");
    }
    else if (!strcmp(name, "Soda", true)) {
        cmd_boire(playerid, "soda");
    }
    else if (!strcmp(name, "eau", true)) {
        cmd_boire(playerid, "eau");
    }
    else if (!strcmp(name, "jus de pomme", true)) {
        cmd_boire(playerid, "jus de pomme");
    }
    else if (!strcmp(name, "jus dorange", true)) {
        cmd_boire(playerid, "jus dorange");
    }
    else if (!strcmp(name, "cafe", true)) {
        cmd_boire(playerid, "cafe");
    }
    else if (!strcmp(name, "alcool", true)) {
        cmd_boire(playerid, "alcool");
    }
    else if (!strcmp(name, "Pizza surgele", true)) {
        cmd_cuisiner(playerid, "pizza");
    }
    else if (!strcmp(name, "Burger surgele", true)) {
        cmd_cuisiner(playerid, "burger");
    }
    else if (!strcmp(name, "Gilet par balles", true)) {
        cmd_veste(playerid, "\1");
    }
    else if (!strcmp(name, "Munition", true)) {
        cmd_chargeur(playerid, "\1");
    }
    else if (!strcmp(name, "Colt 45", true)) {
        EquipWeapon(playerid, "Colt 45");
    }
    else if (!strcmp(name, "Desert Eagle", true)) {
        EquipWeapon(playerid, "Desert Eagle");
    }
    else if (!strcmp(name, "Shotgun", true)) {
        EquipWeapon(playerid, "Shotgun");
    }
    else if (!strcmp(name, "Micro SMG", true)) {
        EquipWeapon(playerid, "Micro SMG");
    }
    else if (!strcmp(name, "Tec-9", true)) {
        EquipWeapon(playerid, "Tec-9");
    }
    else if (!strcmp(name, "MP5", true)) {
        EquipWeapon(playerid, "MP5");
    }
    else if (!strcmp(name, "AK-47", true)) {
        EquipWeapon(playerid, "AK-47");
    }
    else if (!strcmp(name, "M4", true)) {
        EquipWeapon(playerid, "M4");
    }
    else if (!strcmp(name, "Sawn Off", true)) {
        EquipWeapon(playerid, "Sawn Off");
    }
    else if (!strcmp(name, "Cocktail Molotov", true)) {
        EquipWeapon(playerid, "Cocktail Molotov");
    }
    else if (!strcmp(name, "Rifle", true)) {
        EquipWeapon(playerid, "Rifle");
    }
    else if (!strcmp(name, "Sniper", true)) {
        EquipWeapon(playerid, "Sniper");
    }
    else if (!strcmp(name, "Golf Club", true)) {
        EquipWeapon(playerid, "Golf Club");
    }
    else if (!strcmp(name, "Couteau", true)) {
        EquipWeapon(playerid, "Couteau");
    }
    else if (!strcmp(name, "Pelle", true)) {
        EquipWeapon(playerid, "Pelle");
    }
    else if (!strcmp(name, "Katana", true)) {
        EquipWeapon(playerid, "Katana");
    }
    else if (!strcmp(name, "Graine marijuana", true)) {
        cmd_planter(playerid, "Weed");
    }
    else if (!strcmp(name, "Graine cocaine", true)) {
        cmd_planter(playerid, "Cocaine");
    }
    else if (!strcmp(name, "Graine Heroin Opium", true)) {
        cmd_planter(playerid, "Heroin");
    }
    else if (!strcmp(name, "Dynamite", true)) {
        cmd_dynamite(playerid, "\1");
    }
    else if (!strcmp(name, "Decodeur", true)) {
        cmd_decodeur(playerid, "\1");
    }
    else if (!strcmp(name, "des", true)) {
        cmd_des(playerid, "\1");
    }
    else if (!strcmp(name, "Masque a gaz", true))
	{
		if (!Inventory_HasItem(playerid, "Masque a gaz"))
			return SendErrorMessage(playerid, "Vous n'avez pas de masque a gaz.");
		switch (PlayerData[playerid][pMaskOn])
		{
			case 0:
			{
			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son masque a gaz.", ReturnName(playerid, 0));
			    PlayerData[playerid][pMaskOn] = 2;
			    SetPlayerAttachedObject(playerid, 2,19472, 2, AccessoryData[playerid][2][0], AccessoryData[playerid][2][1], AccessoryData[playerid][2][2], AccessoryData[playerid][2][3], AccessoryData[playerid][2][4], AccessoryData[playerid][2][5], AccessoryData[playerid][2][6], AccessoryData[playerid][2][7], AccessoryData[playerid][2][8]);
			    EditAttachedObject(playerid, 2);
			}
			case 1:
			{
			    PlayerData[playerid][pMaskOn] = 0;
			    RemovePlayerAttachedObject(playerid, 2);
			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s enleve son masque a gaz.", ReturnName(playerid, 0));
			}
		}
		return 1;
	}
    else if (!strcmp(name, "Pizza cuite", true))
	{
        if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");
        if (!IsPlayerAttachedObjectSlotUsed(playerid, 4))
		{
		    SetPlayerAttachedObject(playerid, 4, 2702, 6, 0.173041, 0.049197, 0.056789, 0.000000, 274.166107, 299.057983, 1.000000, 1.000000, 1.000000);
			SetTimerEx("RemoveAttachedObject", 3000, false, "dd", playerid, 4);
		}
        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 15 > 100) ? (100) : (PlayerData[playerid][pHunger] + 15);
		Inventory_Remove(playerid, "Pizza cuite");
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend une part de pizza et la mange.", ReturnName(playerid, 0));
		PlayerData[playerid][prepetitions] -= random(75);
		PlayerData[playerid][pparcouru] -= random(75);
		if (ReturnHealth(playerid) <= 90)
		    return SetPlayerHealth(playerid, ReturnHealth(playerid) + 10);
    }
    else if (!strcmp(name, "Burger cuit", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");

		if (!IsPlayerAttachedObjectSlotUsed(playerid, 4))
		{
		    SetPlayerAttachedObject(playerid, 4, 2703, 6, 0.078287, 0.019677, -0.001004, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			SetTimerEx("RemoveAttachedObject", 3000, false, "dd", playerid, 4);
		}
        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 20 > 100) ? (100) : (PlayerData[playerid][pHunger] + 20);
		Inventory_Remove(playerid, "Burger cuit");
		PlayerData[playerid][prepetitions] -= random(75);
		PlayerData[playerid][pparcouru] -= random(75);
		if (ReturnHealth(playerid) <= 90)
		    return SetPlayerHealth(playerid, ReturnHealth(playerid) + 10);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend un hamburger cuit et le mange.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "Poulet", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");

        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 20 > 100) ? (100) : (PlayerData[playerid][pHunger] + 20);
		Inventory_Remove(playerid, "Poulet");
		if (!IsPlayerAttachedObjectSlotUsed(playerid, 4))
		{
		    SetPlayerAttachedObject(playerid, 4, 2663, 6, 0.078287, 0.019677, -0.001004, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			SetTimerEx("RemoveAttachedObject", 3000, false, "dd", playerid, 4);
		}
		PlayerData[playerid][prepetitions] -= random(50);
		PlayerData[playerid][pparcouru] -= random(50);
		if (ReturnHealth(playerid) <= 90)
		    return SetPlayerHealth(playerid, ReturnHealth(playerid) + 10);
		ApplyAnimation(playerid, "VENDING", "VEND_Eat_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend un morceau de poulet et le mange.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "jambon cuit", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");

        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 15 > 100) ? (100) : (PlayerData[playerid][pHunger] + 15);
		Inventory_Remove(playerid, "jambon cuit");
		PlayerData[playerid][prepetitions] -= random(50);
		PlayerData[playerid][pparcouru] -= random(50);
		if (ReturnHealth(playerid) <= 90)
		    return SetPlayerHealth(playerid, ReturnHealth(playerid) + 10);
		ApplyAnimation(playerid, "VENDING", "VEND_Eat_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend un morceau de jambon et le mange.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "kebab", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");

        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 15 > 100) ? (100) : (PlayerData[playerid][pHunger] + 15);
		Inventory_Remove(playerid, "kebab");
		PlayerData[playerid][prepetitions] -= random(50);
		PlayerData[playerid][pparcouru] -= random(50);
		ApplyAnimation(playerid, "VENDING", "VEND_Eat_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend son kebab et le mange.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "donuts", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");

        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 10 > 100) ? (100) : (PlayerData[playerid][pHunger] + 10);
		Inventory_Remove(playerid, "donuts");
		PlayerData[playerid][prepetitions] -= random(150);
		PlayerData[playerid][pparcouru] -= random(150);
		ApplyAnimation(playerid, "VENDING", "VEND_Eat_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend des donuts et les mange.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "orange", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "Vous n'avez pas faim.");

        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 5 > 100) ? (100) : (PlayerData[playerid][pHunger] + 5);
		Inventory_Remove(playerid, "orange");
		PlayerData[playerid][prepetitions] += random(10);
		PlayerData[playerid][pparcouru] += random(10);
		ApplyAnimation(playerid, "VENDING", "VEND_Eat_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend une orange et la mange.", ReturnName(playerid, 0));
    }
    return 1;
}
script OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    new factionid = PlayerData[playerid][pFaction];
	if ((weaponid >= 22 && weaponid <= 38) && hittype == BULLET_HIT_TYPE_OBJECT && PlayerData[playerid][pRangeBooth] != -1 && hitid == g_BoothObject[PlayerData[playerid][pRangeBooth]])
 	{
 	    static string[128];
		PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);
		PlayerData[playerid][pTargets]++;
		DestroyDynamicObject(g_BoothObject[PlayerData[playerid][pRangeBooth]]);
		format(string, sizeof(string), "~b~Cibles:~w~ %d/10", PlayerData[playerid][pTargets]);
		PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][81], string);
		SetTimerEx("UpdateBooth", 3000, false, "dd", playerid, PlayerData[playerid][pRangeBooth]);
	}
	if (weaponid == 23 && PlayerData[playerid][pTazer] && FactionData[factionid][factionacces][1] == 1) {
	    PlayerPlaySoundEx(playerid, 6003);
	}
	if ((weaponid >= 22 && weaponid <= 38) && hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
	    if (PlayerData[hitid][pRangeBooth] != -1 || PlayerData[hitid][pHospital] != -1)
	        return 0;

		if (PlayerData[hitid][pDrugUsed] == 2)
		{
		    new Float:damage = floatdiv(g_arrWeaponDamage[weaponid], 2),Float:health;
		    GetPlayerHealth(hitid, health);
		    SetPlayerHealth(hitid, floatsub(health, damage));
		    return 0;
		}
	}
	if ((22 <= weaponid <= 38) && (GetPlayerWeaponState(playerid) == WEAPONSTATE_LAST_BULLET && GetPlayerAmmo(playerid) == 1) && !IsPlayerAttachedObjectSlotUsed(playerid, 4))
 	{
  		switch (weaponid) {
 	        case 22: Inventory_Add(playerid, "Colt 45", 346);
 	        case 24: Inventory_Add(playerid, "Desert Eagle", 348);
 	        case 25: Inventory_Add(playerid, "Shotgun", 349);
 	        case 26: Inventory_Add(playerid, "Sawn Off", 350);
 	        case 27: Inventory_Add(playerid, "Spas-12", 351);
 	        case 28: Inventory_Add(playerid, "Micro SMG", 352);
 	        case 29: Inventory_Add(playerid, "MP5", 353);
 	        case 30: Inventory_Add(playerid, "AK-47", 355);
 	        case 31: Inventory_Add(playerid, "M4", 356);
 	        case 32: Inventory_Add(playerid, "Tec-9", 372);
 	        case 33: Inventory_Add(playerid, "Rifle", 357);
 	        case 34: Inventory_Add(playerid, "Sniper", 358);
		}
 	    ResetWeapon(playerid, weaponid);
 	    HoldWeapon(playerid, weaponid);
 	    SendServerMessage(playerid, "Vous devez avoir un chargeur pour cette arme (presser 'N' pour la ranger).");
	}
	if(hittype == BULLET_HIT_TYPE_OBJECT)
		if(hitid == dynamiteobject){
			KillTimer(dynamite_Timer);
		    CreateExplosion(dx, dy, dz, 0, 15.0);
		    CreateExplosion(dx, dy, dz, 1, 15.0);
		    CreateExplosion(dx+3.5, dy+3.5, dz+3.5, 1, 15.0);
		    CreateExplosion(dx-3.5, dy-3.5, dz, 1, 15.0);
		    CreateExplosion(dx+3.5, dy-3.5, dz, 1, 15.0);
		    CreateExplosion(dx-3.5, dy+3.5, dz, 1, 15.0);
		    DestroyDynamicObject(dynamiteobject);
		}
    if( hittype != BULLET_HIT_TYPE_NONE ) // Bullet Crashing uses just this hittype
	{
        if( !( -1000.0 <= fX <= 1000.0 ) || !( -1000.0 <= fY <= 1000.0 ) || !( -1000.0 <= fZ <= 1000.0 ) )
		{
			KickEx(playerid);
			return 0;
		}
	}
	return 1;
}

script OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if (PlayerData[playerid][pFirstAid])
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Vous ne pouvez pas utiliser votre trousse de soin pour le moment.");
        PlayerData[playerid][pFirstAid] = 0;
		KillTimer(PlayerData[playerid][pAidTimer]);
	}
	if(weaponid == WEAPON_FLAMETHROWER)
	{
    	OnPlayerStartBurn(playerid);
	}
	new Float:HP;
	GetPlayerHealth(playerid, HP);
	if(weaponid == 25 && PlayerData[playerid][pflashball]) SetPlayerHealth(playerid, HP-10);//Shotgun en flashball
    if(weaponid == 23 && PlayerData[playerid][pTazer]) SetPlayerHealth(playerid, HP-10);//silencieux en tazer
    if(issuerid != INVALID_PLAYER_ID) // If not self-inflicted
    {
        if(bodypart == 5) //left arm
        {//jeter arme lourde
            if(weaponid == 25 || weaponid == 27 || weaponid == 29 || weaponid == 30 || weaponid == 31 || weaponid == 33 || weaponid == 34){cmd_jeter(playerid, "\1");}
        }
        if(bodypart == 6) //right arm
        {//jeter arme legere
            if(weaponid == 16 || weaponid == 17 || weaponid == 18 || weaponid == 22 || weaponid == 23 || weaponid ==24 || weaponid == 26 || weaponid ==28 || weaponid == 32 || weaponid == 41){cmd_jeter(playerid, "\1");}
        }
        if(bodypart == 8 || bodypart == 7)
        {
            ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
        }
    }
	return 1;
}

script OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
    new factionid = PlayerData[playerid][pFaction];
	if (damagedid != INVALID_PLAYER_ID)
	{
		PlayerData[damagedid][pLastShot] = playerid;
		PlayerData[damagedid][pShotTime] = gettime();

		if (IsBleedableWeapon(weaponid) && !PlayerData[damagedid][pBleeding] && ReturnArmour(damagedid) < 1 && PlayerData[playerid][pRangeBooth] == -1 && PlayerData[damagedid][pHospital] == -1)
		{
		    if (!PlayerHasTazer(playerid) && !PlayerHasflashball(playerid))
		    {
			    PlayerData[damagedid][pBleeding] = 1;
			    PlayerData[damagedid][pBleedTime] = 10;

				CreateBlood(damagedid);
			    SetTimerEx("HidePlayerBox", 500, false, "dd", damagedid, _:ShowPlayerBox(damagedid, 0xFF000066));
			}
		}
		if (PlayerData[playerid][pDrugUsed] == 4 && (weaponid >= 0 && weaponid <= 15))
		{
		    SetPlayerHealth(damagedid, ReturnHealth(damagedid) - 6);
		}
        if (FactionData[factionid][factionacces][1] == 1 && PlayerData[playerid][pTazer] && PlayerData[damagedid][pStunned] < 1 && weaponid == 23)
        {
			if (GetPlayerState(damagedid) != PLAYER_STATE_ONFOOT)
			    return SendErrorMessage(playerid, "Le joueur doit être debout pour être étourdis.");

            if (GetPlayerDistanceFromPlayer(playerid, damagedid) > 10.0)
                return SendErrorMessage(playerid, "Vous devez être plus proche d'étourdir le joueur.");
            new string[64];
			format(string, sizeof(string), "Vous avez ete ~r~etourdi~w~ par %s.", ReturnName(playerid, 0));
			if (start1[damagedid] != 0) return start1[damagedid] = 0; KillTimer(timerrob[damagedid]);
            PlayerData[damagedid][pStunned] = 25;
            TogglePlayerControllable(damagedid, 0);

            ApplyAnimation(damagedid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
            ShowPlayerFooter(damagedid, string);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a étourdis %s avec sont tazer.", ReturnName(playerid, 0), ReturnName(damagedid, 0));
        }
        if (FactionData[factionid][factionacces][1] == 1 && PlayerData[playerid][pflashball] && PlayerData[damagedid][pStunned] < 1 && weaponid == 25)
        {
			if (GetPlayerState(damagedid) != PLAYER_STATE_ONFOOT)
			    return SendErrorMessage(playerid, "Le joueur doit être debout pour être étourdis.");

            if (GetPlayerDistanceFromPlayer(playerid, damagedid) > 10.0)
                return SendErrorMessage(playerid, "Vous devez être plus proche d'étourdir le joueur.");
            new string[64];
			format(string, sizeof(string), "Vous avez ete ~r~etourdi~w~ par %s.", ReturnName(playerid, 0));
            PlayerData[damagedid][pStunned] = 25;
            TogglePlayerControllable(damagedid, 0);
            if (start1[damagedid] != 0) return start1[damagedid] = 0; KillTimer(timerrob[damagedid]);
            ApplyAnimation(damagedid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
            ShowPlayerFooter(damagedid, string);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a étourdis %s avec sont fusil de balle en caoutchouc.", ReturnName(playerid, 0), ReturnName(damagedid, 0));
        }
	}
	return 1;
}
//is a gang de caca
script IsACop(playerid) {new facass = PlayerData[playerid][pFaction]; if (FactionData[facass][factionacces][1] == 1 && FactionData[facass][factionacces][4] == 1 && FactionData[facass][factionacces][3] == 1 && FactionData[facass][factionacces][7] == 1 && FactionData[facass][factionacces][5] == 1) return 1;return 0;}
script IsACops(playerid) {new facass = PlayerData[playerid][pFaction]; if (FactionData[facass][factionacces][1] == 1) return 1;return 0;}
script IsACopm(playerid) {new facass = PlayerData[playerid][pFaction]; if (FactionData[facass][factionacces][1] == 1 && FactionData[facass][factionacces][5] == 1) return 1;return 0;}
script IsACopf(playerid) {new facass = PlayerData[playerid][pFaction]; if (FactionData[facass][factionacces][1] == 1 && FactionData[facass][factionacces][3] == 1) return 1;return 0;}
script IsAGang(playerid) {new facass = PlayerData[playerid][pFaction]; if (FactionData[facass][factionacces][8] == 1) return 1; return 0;}
script OnPlayerDeath(playerid, killerid, reason)
{
	if (killerid != INVALID_PLAYER_ID && !IsPlayerNPC(playerid))
	{
	    if (0 <= reason <= 46) Log_Write("logs/kill_log.txt", "[%s] %s a tué %s (%s).", ReturnDate(), ReturnName(killerid), ReturnName(playerid), ReturnWeaponName(reason));
		else Log_Write("logs/kill_log.txt", "[%s] %s a tué %s (raison %d).", ReturnDate(), ReturnName(killerid), ReturnName(playerid), reason);
		if (reason == 50 && killerid != INVALID_PLAYER_ID)
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a tué %s par hélicoptère à roues alignées.", ReturnName(killerid, 0), ReturnName(playerid, 0));
        if (reason == 29 && killerid != INVALID_PLAYER_ID && GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a tué %s par des tirs de pilote.", ReturnName(killerid, 0), ReturnName(playerid, 0));
	}
    //Job boucher
	meats[playerid] = 0;
	meatprocces[playerid] = 0;
	PlayerInJob[playerid] = 0;
	start1[playerid] = 0;
	KillTimer(timerrob[playerid]);
	//bowling
    BowlingMinutes[playerid] = 0;
    BowlingSeconds[playerid] = 0;
	BowlingStatus[playerid] = F_BOWLING_THROW;
	PinsLeft[1][playerid] = 0;
	AbleToPlay[playerid] = 0;
	KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
 	BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
 	if(IsInBus[playerid] == 1) {IsInBus[playerid] = 0;}
 	if(PlayersBowlingRoad[playerid]==0)
  	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Allée 1{008800} ]\n Vide");
		DestroyPins(0);
  	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Allée 2{008800} ]\n Vide");
		DestroyPins(1);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Allée 3{008800} ]\n Vide");
		DestroyPins(2);
  	}
  	else if(PlayersBowlingRoad[playerid]==3)
   	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Allée 4{008800} ]\n Vide");
		DestroyPins(3);
   	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Allée 5{008800} ]\n Vide");
		DestroyPins(4);
	}
 	PlayersBowlingRoad[playerid] = ROAD_NONE;
 	//blackjack
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	for(new i = 0; i < 19; i++)
    {
		PlayerTextDrawHide(playerid,BlackJackTD[i][playerid]);
	}
	return 1;
}
//gym je sais pas pk mais voila ou il doit etre pour que sa fonctionne
stock static Float:run_machine_pos[ ][ ] =
{
	{ 773.4922, -2.6016,  1000.7209,180.00000 }, // Los Santos Gym's bench.
	{ 759.6328, -48.1250, 1000.7209,180.00000}, // San Fierro Gym's bench.
	{ 758.3828, -65.5078, 1000.7209,180.00000} // Las Venturas Gym's bench
};
stock static Float:bike_pos[ ][ ] =
{
	{772.172,9.41406,1000.0,90.0}, // Los Santos Gym's Bake
	{769.242,-47.8984,1000.0,90.0}, // San Fierro Gym's Bake
	{774.625,-68.6406,1000.0,90.0} // Las Venturas Gym's Bake
};
stock static Float:bench_pos[ ][ ] =
{
	{ 773.0491,1.4285,1000.7209, 269.2024 }, // Los Santos Gym's bench.
	{ 766.3170,-47.3574,1000.5859, 179.2983 }, // San Fierro Gym's bench.
	{ 764.9001,-60.5580,1000.6563, 1.9500 } // Las Venturas Gym's bench
};
stock static Float:barbell_pos[ ][ ] =
{
	{ 774.42907715,1.88309872,1000.48834229,0.00000000,270.00000000,87.99966431 }, // Los Santos Gym's BarBell
	{ 765.85528564,-48.86857224,1000.64093018,0.00000000,89.49993896,0.00000000 }, // San Fierro Gym's BarBell.
	{ 765.34039307,-59.18271637,1000.63793945,0.00000000,89.49993896,181.25012207 } // Las Venturas Gym's BarBell
};
stock static Float:dumb_pos[ ][ ] =
{
	{772.992,5.38281,999.727,270.0}, // Los Santos Gym's dumb
	{756.406,-47.9219,999.727,90.0}, // San Fierro Gym's dumb.
	{759.18,-60.0625,999.727,90.0} // Las Venturas Gym's dumb
};
stock static Float:dumb_bell_right_pos[ ][ ] =
{
	{772.992,5.18281,999.927,0.0,90.0,90.0} // Los Santos Gym's dumb right
	//{759.18,-60.0625,999.727,90.0} // Las Venturas Gym's dumb
};
stock static Float:dumb_bell_left_pos[ ][ ] =
{
	{772.992,5.62738,999.927,0.0,90.0,90.0} // Los Santos Gym's dumb left
	//{759.18,-60.0625,999.727,90.0} // Las Venturas Gym's dumb
};
new bool:TREAM_IN_USE[sizeof run_machine_pos]=false;
new PLAYER_CURRECT_TREAD[MAX_PLAYERS],
 	bool:PLAYER_INTREAM[MAX_PLAYERS]=false;
new bool:BIKE_IN_USE[sizeof bike_pos]=false;
new PLAYER_CURRECT_BIKE[MAX_PLAYERS],
 	bool:PLAYER_INBIKE[MAX_PLAYERS]=false;
new bool:BENCH_IN_USE[sizeof bench_pos]=false;
new PLAYER_CURRECT_BENCH[MAX_PLAYERS],
	bool:PLAYER_INBENCH[MAX_PLAYERS]=false;
new bool:DUMB_IN_USE[sizeof bench_pos]=false;
new PLAYER_CURRECT_DUMB[MAX_PLAYERS],
	bool:PLAYER_INDUMB[MAX_PLAYERS]=false;
new bool:BAR_CAN_BE_USED[MAX_PLAYERS]=false;
new barbell_objects[sizeof barbell_pos];
new dumbell_right_objects[sizeof dumb_bell_right_pos];
new dumbell_left_objects[sizeof dumb_bell_left_pos];
script OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PlayerData[playerid][pTutorial] || PlayerData[playerid][pHospital] != -1 || !IsPlayerSpawned(playerid) || PlayerData[playerid][pInjured])
	    return 0;
    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED && newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP))
		ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.0, 0, 1, 1, 0, 0, 1);
	if (newkeys & KEY_CROUCH && IsPlayerInAnyVehicle(playerid)) {cmd_open(playerid, "\1");}
	if (newkeys & KEY_CROUCH && (IsPlayerInRangeOfPoint(playerid, 1.5, -70.9738,-1574.2937,3.0855)||IsPlayerInRangeOfPoint(playerid,1.5,2510.9900,-1728.5364,778.3384) || IsPlayerInRangeOfPoint(playerid,1.5,1742.5693,-1948.0618,13.1172) || IsPlayerInRangeOfPoint(playerid,1.5,1646.6123,-2299.5503,-0.8559) ||  IsPlayerInRangeOfPoint(playerid,1.5,-1437.2219,-297.3453,14.6334) || IsPlayerInRangeOfPoint(playerid,1.5,-1967.6317,146.4278,28.2107) || IsPlayerInRangeOfPoint(playerid, 1.5,1646.6123,-2299.5503,-0.355) || IsPlayerInRangeOfPoint(playerid, 1.5,-1437.2219,-297.3453,14.6334) || IsPlayerInRangeOfPoint(playerid,1.5,529.4365,-1817.3754,15.3615) && PlayerData[playerid][pTutorialStage] == 1))
	{
	    DisablePlayerCheckpoint(playerid);
		PlayerData[playerid][pTutorialStage] = 2;
	    SendClientMessage(playerid, COLOR_SERVER, "Appuyer sur 'N' pour prendre un objet quand vous êtes accroupie.");
	}
	if (newkeys & KEY_YES && IsPlayerSpawned(playerid))
	{
	    if (PlayerData[playerid][pJailTime] > 0)
			return SendErrorMessage(playerid, "Vous ne pouvez ouvrir votre inventaire.");
		if (PlayerData[playerid][pCuffed] > 0 || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
		    return SendErrorMessage(playerid, "Vous ne pouvez ouvrir votre inventaire.");
		OpenInventory(playerid);
	}
	if (newkeys & KEY_FIRE && PlayerData[playerid][pMining] && IsPlayerNearMine(playerid))
	{
	    if (PlayerData[playerid][pMineTime] > 0 || PlayerData[playerid][pMinedRock])
	        return 1;
		new id = Job_NearestPoint(playerid);
		if (id != -1)
		{
		    PlayerData[playerid][pMineTime] = 1;
		    SetTimerEx("MineTime", 400, false, "d", playerid);
		    if (PlayerData[playerid][pMineCount] < 5)
	    	{
	    	    PlayerData[playerid][pMineCount]++;
	        	ApplyAnimation(playerid, "BASEBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
            	ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.0, 0, 1, 1, 0, 0, 1);
			}
			else
			{
			    PlayerData[playerid][pMinedRock] = 1;
			    PlayerData[playerid][pMineCount] = 0;
			    RemovePlayerAttachedObject(playerid, 4);
			    ApplyAnimation(playerid, "BSKTBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
            	ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 1, 1, 0, 0, 1);
			    SetPlayerAttachedObject(playerid, 4, 2936, 5, 0.044377, 0.029049, 0.161334, 265.922912, 9.904896, 21.765972, 0.500000, 0.500000, 0.500000);
				SendServerMessage(playerid, "Vous avez récuperé une roche. Allez la déposer au marqueur.");
				SetPlayerCheckpoint(playerid, JobData[id][jobDeliver][0], JobData[id][jobDeliver][1], JobData[id][jobDeliver][2],3.0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
	    }
	}
	if (newkeys & KEY_FIRE && PlayerData[playerid][pWoodcutting] && IsPlayerNearWoodcut(playerid))
	{
	    if (PlayerData[playerid][pWoodTime] > 0 || PlayerData[playerid][pWoodRock])
	        return 1;
		new id = Job_NearestPoint(playerid);
		if (id != -1)
		{
		    PlayerData[playerid][pWoodTime] = 1;
		    SetTimerEx("WoodTime", 400, false, "d", playerid);
		    if (PlayerData[playerid][pWoodCount] < 5)
	    	{
	    	    PlayerData[playerid][pWoodCount]++;
	        	ApplyAnimation(playerid, "BASEBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
            	ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.0, 0, 1, 1, 0, 0, 1);
			}
			else
			{
			    PlayerData[playerid][pWoodRock] = 1;
			    PlayerData[playerid][pWoodCount] = 0;
			    RemovePlayerAttachedObject(playerid, 4);
			    ApplyAnimation(playerid, "BSKTBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
            	ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 1, 1, 0, 0, 1);
			    SetPlayerAttachedObject(playerid, 4, 1463, 5, 0.044377, 0.029049, 0.161334, 265.922912, 9.904896, 21.765972, 0.500000, 0.500000, 0.500000);
				SendServerMessage(playerid, "Vous avez récuperé une stère de bois. Allez la déposer au marqueur.");
				SetPlayerCheckpoint(playerid, JobData[id][jobDeliver][0], JobData[id][jobDeliver][1], JobData[id][jobDeliver][2], 3.0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
	    }
	}
	if (newkeys & KEY_SPRINT && IsPlayerSpawned(playerid) && PlayerData[playerid][pLoopAnim])
	{
	    ClearAnimations(playerid);
		HidePlayerFooter(playerid);
	    PlayerData[playerid][pLoopAnim] = false;
	}
	if (newkeys & KEY_FIRE && PlayerData[playerid][pDrinking])
	{
	    if (GetPlayerAnimationIndex(playerid) != 15 && GetPlayerAnimationIndex(playerid) != 16 && !PlayerData[playerid][pDrinkTime])
     	{
		    if (GetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar]) <= 0.0)
		    {
	    	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
				PlayerData[playerid][pDrinking] = 0;
				SendServerMessage(playerid, "Tu as fini de boire ta bouteille.");
		    }
	    	else
	    	{
	    	    PlayerData[playerid][pDrinkTime] = 2;
	    	    switch (PlayerData[playerid][pDrinking])
	    	    {
					case 1: PlayerData[playerid][pThirst] = (PlayerData[playerid][pThirst] + 5 >= 100) ? (100) : (PlayerData[playerid][pThirst] + 5);
                    case 2: PlayerData[playerid][pThirst] = (PlayerData[playerid][pThirst] + 5 >= 100) ? (100) : (PlayerData[playerid][pThirst] + 5);
				}
			    SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], GetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar]) - 10.0);
			}
		}
	}
	if (newkeys == 16 && IsInBus[playerid] > 0)
	{
		new Float:X,Float:Y,Float:Z;
		GetVehiclePos(IsInBus[playerid], X, Y, Z);
		SetPlayerPos(playerid, X+4, Y, Z);
		SetPlayerInterior(playerid, 0);
		IsInBus[playerid] = 0;
	}
	else if (newkeys & KEY_SUBMISSION && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {cmd_phare(playerid,"");}
	else if (newkeys & KEY_CTRL_BACK)
	{
	    if (PlayerData[playerid][pUsedMagazine])
	    {
	        new weaponid = PlayerData[playerid][pHoldWeapon];

	        switch (weaponid)
	        {
			    case 22:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Colt 45");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 17);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 24:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Desert Eagle");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 7);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 25:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Shotgun");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 8);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend une arme et le pompe.", ReturnName(playerid, 0));
				}
				case 26:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Sawn Off");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 2);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prend une arme et le pompe.", ReturnName(playerid, 0));
				}
				case 28:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Micro SMG");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 50);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 29:
       			{
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "MP5");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 32:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Tec-9");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 50);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 30:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "AK-47");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 31:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "M4");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 31);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
				case 33:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Rifle");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 5);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
		        case 34:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);
			        Inventory_Remove(playerid, "Sniper");
					PlayReloadAnimation(playerid, weaponid);
					GiveWeaponToPlayer(playerid, weaponid, 5);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sort son arme.", ReturnName(playerid, 0));
				}
			}
			return 1;
	    }
	}
	if (newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    static string[320];
		if (PlayerData[playerid][pTutorialStage] == 2 && (IsPlayerInRangeOfPoint(playerid, 1.5,-70.9738,-1574.2937,3.0855) || IsPlayerInRangeOfPoint(playerid, 1.5,2510.9900,-1728.5364,778.3384) || IsPlayerInRangeOfPoint(playerid, 3.0,1742.7317,-1948.1010,14.5589) || IsPlayerInRangeOfPoint(playerid, 1.5,1646.6123,-2299.5503,-0.8559) || IsPlayerInRangeOfPoint(playerid, 1.5,-1437.2219,-297.3453,14.6334) ||IsPlayerInRangeOfPoint(playerid, 1.5,-1967.6317,146.4278,28.2107) || IsPlayerInRangeOfPoint(playerid, 1.5,1646.6123,-2299.5503,-0.355) ||IsPlayerInRangeOfPoint(playerid, 1.5,-1437.2219,-297.3453,14.6334) || IsPlayerInRangeOfPoint(playerid, 1.5,529.4365,-1817.3754,15.3615)))
		{
		    Inventory_Add(playerid, "Demo Soda", 1543);
		    DestroyPlayerObject(playerid, PlayerData[playerid][pTutorialObject]);
            PlayerData[playerid][pTutorialStage] = 3;
 		    SendClientMessage(playerid, COLOR_SERVER, "Appuyer sur 'Y' pour ouvrir votre inventaire et choisissez le soda.");
		    return 1;
		}
		if (PlayerData[playerid][pHoldWeapon] > 0)
		{
		    if (PlayerData[playerid][pUsedMagazine])
      			Inventory_Add(playerid, "Chargeur", 19995);
		    HoldWeapon(playerid, 0);
		    return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s lache son arme vide.", ReturnName(playerid, 0));
		}
		if (PlayerData[playerid][pLoadCrate])
		{
		    for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i))
			{
			    if (!IsLoadableVehicle(i))
			        return SendErrorMessage(playerid, "Tu ne peut chargé de boite dans ce vehicule.");
			    if (CoreVehicles[i][vehLoadType] != 0 && CoreVehicles[i][vehLoadType] != PlayerData[playerid][pLoadType])
			        return SendErrorMessage(playerid, "Ce vehicule est déjà chargé avec d'autre marchandise.");
			    if (CoreVehicles[i][vehLoads] >= 10)
			        return SendErrorMessage(playerid, "Ce vehicule ne peut contenir que 10 caisses de marchandise.");
				CoreVehicles[i][vehLoads]++;
				CoreVehicles[i][vehLoadType] = PlayerData[playerid][pLoadType];
                ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a déposé de la marchandise dans le vehicule %s.", ReturnName(playerid, 0), ReturnVehicleName(i));
                if (CoreVehicles[i][vehLoads] == 10)
                {
                    DisablePlayerCheckpoint(playerid);

					if (PlayerData[playerid][pShipment] != -1)
					{
					    PlayerData[playerid][pDeliverShipment] = 1;
					    SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Faite /livrermarchandise chez le client.");
					    SetPlayerCheckpoint(playerid, BusinessData[PlayerData[playerid][pShipment]][bizDeliver][0], BusinessData[PlayerData[playerid][pShipment]][bizDeliver][1], BusinessData[PlayerData[playerid][pShipment]][bizDeliver][2], 3.0);
					}
					else switch (PlayerData[playerid][pLoadType])
                    {
                    	case 1: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Magasin 24/7.");
                        case 2: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Magasin d'armurerie.");
                        case 3: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Magasin de vêtement.");
                        case 4: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Magasin restaurant.");
                        case 5: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle station service.");
                        case 6: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Magasin de meuble.");
                        case 7: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Bar.");
                        case 8: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Épicerie.");
                        case 9: SendServerMessage(playerid, "Vous avez chargé toute les marchandises. Écriver /livrermarchandise a n'importe quelle Magasin de Quincaillerie.");
					}
					PlayerData[playerid][pLoading] = 0;
					PlayerData[playerid][pLoadType] = 0;
                }
                PlayerData[playerid][pLoadCrate] = 0;
				RemovePlayerAttachedObject(playerid, 4);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				return 1;
			}
		}
		for (new i = 0; i != MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && !BackpackData[i][backpackPlayer] && IsPlayerInRangeOfPoint(playerid, 2.0, BackpackData[i][backpackPos][0], BackpackData[i][backpackPos][1], BackpackData[i][backpackPos][2])) {
		    return Backpack_Items(playerid, i);
		}
        if (PlayerData[playerid][pCarryTrash])
		{
			for (new i = 1; i != MAX_VEHICLES; i ++) if (GetVehicleModel(i) == 408 && IsPlayerNearBoot(playerid, i))
			{
			    if (CoreVehicles[i][vehTrash] >= 10)
			        return SendErrorMessage(playerid, "Ce véhicule est plein (limite: 10).");
				CoreVehicles[i][vehTrash]++;
				RemovePlayerAttachedObject(playerid, 4);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s charge le sac poubelle dans l'arrière du camion poubelle.", ReturnName(playerid, 0));
				PlayerData[playerid][pCarryTrash] = 0;
				break;
			}
		}
		if (PlayerData[playerid][pCarryCrate] != -1)
		{
			for (new i = 1; i != MAX_VEHICLES; i ++) if (IsLoadableVehicle(i) && IsPlayerNearBoot(playerid, i))
			{
			    if (GetVehicleCrates(i) >= GetMaxCrates(i))
			        return SendErrorMessage(playerid, "Maximum atteint (limit: %d).", GetMaxCrates(i));
				CrateData[PlayerData[playerid][pCarryCrate]][crateVehicle] = i;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(playerid, 4);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a chargé les boites dans le vehicule %s.", ReturnName(playerid, 0), ReturnVehicleName(i));
				PlayerData[playerid][pCarryCrate] = -1;
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
				break;
			}
		}
		else if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
		{
		    new count = 0,id = Item_Nearest(playerid);
		    if (id != -1)
		    {
		        string = "";
		        for (new i = 0; i < MAX_DROPPED_ITEMS; i ++) if (count < MAX_LISTED_ITEMS && DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]) && GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld]) {
		            NearestItems[playerid][count++] = i;
		            strcat(string, DroppedItems[i][droppedItem]);
		            strcat(string, "\n");
		        }
		        if (count == 1)
		        {
				    if (DroppedItems[id][droppedWeapon] != 0)
					{
				        if (PlayerData[playerid][pPlayingHours] < 5)
							return SendErrorMessage(playerid, "Tu vois avoir au moins 5 heures de jeux.");
    	   				GiveWeaponToPlayer(playerid, DroppedItems[id][droppedWeapon], DroppedItems[id][droppedAmmo]);
    	                Item_Delete(id);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recupère un(e) %s.", ReturnName(playerid, 0), ReturnWeaponName(DroppedItems[id][droppedWeapon]));
                        Log_Write("logs/droppick.txt", "[%s] %s recupère un(e) %s.", ReturnDate(), ReturnName(playerid, 0), ReturnWeaponName(DroppedItems[id][droppedWeapon]));

					}
					else if (PickupItem(playerid, id))
					{
			    		format(string, sizeof(string), "~g~%s~w~ ajouter dans votre inventaire!", DroppedItems[id][droppedItem]);
			    		ShowPlayerFooter(playerid, string);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s recupère un(e) \"%s\".", ReturnName(playerid, 0), DroppedItems[id][droppedItem]);
						Log_Write("logs/droppick.txt", "[%s] %s recupère un(e) \"%s\".", ReturnDate(), ReturnName(playerid, 0), DroppedItems[id][droppedItem]);
					}
					else
						SendErrorMessage(playerid, "Vous ne disposez pas de place dans votre inventaire.");
				}
				else Dialog_Show(playerid, PickupItems, DIALOG_STYLE_LIST, "Pickup Items", string, "Prendre", "Quitter");
			}
		}
 		if(AbleToPlay[playerid] == 1)
		{
			new stockjobinfoid;
			if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
			//generateur
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 25;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 25;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 25;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 25;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 25;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
			stockjobinfosave(stockjobinfoid);
			cmd_bowling(playerid,"");
		}
		for (new i = 0; i != MAX_caisseS; i ++) if (caisseMachineData[i][caisseExists] && IsPlayerInRangeOfPoint(playerid, 1.0, caisseMachineData[i][caissePos][0], caisseMachineData[i][caissePos][1], caisseMachineData[i][caissePos][2]))
		{
			new bizid = Business_Inside(playerid),moneyganho,serveursettinginfoid,facass = PlayerData[playerid][pFaction];
			if(info_serveursettinginfo[serveursettinginfoid][settingbraquagenpcactive] == 1) {ShowPlayerFooter(playerid, "Les braquages sont desactiver");return 1;}
			if(cop_nbrCops < info_serveursettinginfo[serveursettinginfoid][settingpolice]) {ShowPlayerFooter(playerid, " Il n'a pas assez de ~r~police~w~ en ville"); return 1;}
			foreach (new y : Player)
			{
				if (FactionData[facass][factionacces][1] == 1) {Waypoint_Set(y, "Vol en cours!", BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2]);}
			}
			if(FactionData[facass][factionacces][1] == 1)
			{ SendServerMessage(playerid,  "RADIO: Un vol de magasin au %s (marquée sur la carte).", BusinessData[bizid][bizName]);}
      		//static bizid = -1;
			if ((bizid = Business_Inside(playerid)) != -1)
			{
			    ApplyAnimationEx(playerid, "INT_SHOP", "shop_cashier", 4.1, 1, 0, 0, 0, 0,1);
				moneyganho = BusinessData[bizid][bizVault];
				new rnMsg[35];
        		BusinessData[bizid][bizVault] -= moneyganho;
        		Inventory_Add(playerid, "argent sale", 1212,moneyganho);
        		Business_Save(bizid);
				format(rnMsg, sizeof(rnMsg), "~g~Vous aver voler~n~$%i", moneyganho);
				GameTextForPlayer(playerid, rnMsg, 2000, 0);
			}
		}
	}
	if(newkeys & KEY_ACTION) {if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return cmd_demarrer(playerid,"");}
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
		static id = -1,count;
		if ((id = Vendor_Nearest(playerid)) != -1)
		{
		    switch (VendorData[id][vendorType])
		    {
		        case 1:
		        {
					if (GetMoney(playerid) < 3)
					    return SendErrorMessage(playerid, "Vous devez avoir au moins 3 dollars.");
					if (PlayerData[playerid][pVendorTime] > 0)
					    return SendErrorMessage(playerid, "S'il vous plait veuiller attendre pour faire cette action.");
					if (Inventory_Count(playerid, "kebab") >= 5)
					    return SendErrorMessage(playerid, "Vous avez déja trop de kebab dans votre inventaire.");
					id = Inventory_Add(playerid, "kebab", 2769);
					if (id != -1)
					{
					    PlayerData[playerid][pVendorTime] = 3;
					    GiveMoney(playerid, -3);
						for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
							count++;
						}
						for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
						{
							new aye = 3 / count;
							if(FactionData[ii][factionacces][11] == 1)
							{
								FactionData[ii][factioncoffre] += aye;
								Faction_Save(ii);
							}
						}
					    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
					    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a acheté un kebab du vendeur pour $3.", ReturnName(playerid, 0));
						ShowPlayerFooter(playerid, "Votre ~p~kebab~w~ a ete ajouter dans votre inventaire.");
					}
				}
				case 2:
		        {
					if (GetMoney(playerid) < 2)
					    return SendErrorMessage(playerid, "Vous devez avoir au moins 2 dollars.");
					if (PlayerData[playerid][pVendorTime] > 0)
					    return SendErrorMessage(playerid, "S'il vous plait veuiller attendre pour faire cette action.");
					new stockjobinfoid;
					if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
					//generateur
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 1;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 1;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 1;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 1;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 1;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
					if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
					stockjobinfosave(stockjobinfoid);
					if (Inventory_Count(playerid, "Soda") >= 10)
					    return SendErrorMessage(playerid, "Vous avez déja trop de canette de soda dans votre inventaire.");
					id = Inventory_Add(playerid, "Soda", 1543);
					if (id != -1)
					{
                        PlayerData[playerid][pVendorTime] = 3;
					    GiveMoney(playerid, -2);
						for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
							count++;
						}
						for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][11] == 1)
						{
							new aye = 3 / count;
							if(FactionData[ii][factionacces][11] == 1)
							{
								FactionData[ii][factioncoffre] += aye;
								Faction_Save(ii);
							}
						}
					    ApplyAnimation(playerid, "VENDING", "VEND_USE", 4.0, 0, 0, 0, 0, 0);
					    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a acheté un soda du vendeur pour $2.", ReturnName(playerid, 0));
						ShowPlayerFooter(playerid, "Votre ~p~soda~w~ a ete ajouter dans votre inventaire.");
					}
				}
			}
		}
		if (ATM_Nearest(playerid) != -1) return cmd_atm(playerid, "\1");
		if (PlayerData[playerid][pRangeBooth] != -1)
		{
		    Booth_Leave(playerid);
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a quitté la cabine de tir.", ReturnName(playerid, 0));
		}
		else for (new i = 0; i < MAX_BOOTHS; i ++) if (!g_BoothUsed[i] && IsPlayerInRangeOfPoint(playerid, 1.5, arrBoothPositions[i][0], arrBoothPositions[i][1], arrBoothPositions[i][2]))
		{
		    g_BoothUsed[i] = true;
		    PlayerData[playerid][pRangeBooth] = i;
		    UpdateWeapons(playerid);
		    ResetPlayerWeapons(playerid);
		    GiveWeaponToPlayer(playerid, 24, 15000);
			Booth_Refresh(playerid);
			PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][81], "~b~Cible:~w~ 0/10");
			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][81]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a entrée dans une cabine de tir.", ReturnName(playerid, 0));
			return 1;
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, -204.5334, -1735.3131, 675.7687) && PlayerData[playerid][pHospitalInt] != -1)
		{
			SetPlayerPosEx(playerid, arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][0], arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][1], arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][2]);
			SetPlayerFacingAngle(playerid, arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][3]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHospitalInt] = -1;
		}
		for (new i = 0; i < sizeof(arrHospitalSpawns); i ++) if (IsPlayerInRangeOfPoint(playerid, 3.0, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2]))
		{
			SetPlayerPosEx(playerid, -204.5648, -1736.1201, 675.7687);
			SetPlayerFacingAngle(playerid, 180.0000);
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, i + 5000);
			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHospitalInt] = i;
		    return 1;
	    }
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, -204.5334, -1735.3131, 675.7687) && PlayerData[playerid][pHospitalInt] != -1)
		{
			SetPlayerPosEx(playerid, arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][0], arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][1], arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][2]);
			SetPlayerFacingAngle(playerid, arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][3]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHospitalInt] = -1;
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 272.2939, 1388.8876, 11.1342))
		{
		    SetPlayerPosEx(playerid, 1206.8619, -1314.3546, 797.0880);
		    SetPlayerFacingAngle(playerid, 270.0000);
		    SetPlayerInterior(playerid, 5);
		    SetPlayerVirtualWorld(playerid, PRISON_WORLD);
		    SetCameraBehindPlayer(playerid);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 1206.8619, -1314.3546, 796.7880) && GetPlayerVirtualWorld(playerid) == PRISON_WORLD && !PlayerData[playerid][pJailTime])
		{
		    if (PlayerData[playerid][pFreeze])
			{
		        TogglePlayerControllable(playerid, 1);
		        KillTimer(PlayerData[playerid][pFreezeTimer]);
			}
		    SetPlayerPosEx(playerid, 272.2939, 1388.8876, 11.1342);
		    SetPlayerFacingAngle(playerid, 270.0000);
		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);
		    SetCameraBehindPlayer(playerid);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 1211.1923, -1354.3439, 796.7456) && GetPlayerVirtualWorld(playerid) == PRISON_WORLD)
		{
		    if (PlayerData[playerid][pFreeze])
			{
		        TogglePlayerControllable(playerid, 1);
		        KillTimer(PlayerData[playerid][pFreezeTimer]);
			}
		    SetPlayerPosEx(playerid, 201.8927, 1437.1788, 10.5950);
		    SetPlayerFacingAngle(playerid, 180.0000);
		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);
		    SetCameraBehindPlayer(playerid);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 201.8927, 1437.1788, 10.5950))
		{
		    SetPlayerPosEx(playerid, 1211.1923, -1354.3439, 797.0456);
		    SetPlayerFacingAngle(playerid, 0.0000);
		    SetPlayerInterior(playerid, 5);
		    SetPlayerVirtualWorld(playerid, PRISON_WORLD);
		    SetCameraBehindPlayer(playerid);
		}

	    if ((id = Gate_Nearest(playerid)) != -1) {cmd_open(playerid, "\1");}
	    if ((id = House_Nearest(playerid)) != -1)
	    {
	        if (HouseData[id][houseOwner] == 0)
	            {Dialog_Show(playerid, Achetermagasin, DIALOG_STYLE_MSGBOX, "Maison", "Vous voules acheter cette maison?", "Acheter", "Annuler");return 1;}
	        if (HouseData[id][houseLocked])
	            {SendErrorMessage(playerid, "Cette maison est fermée.");return 1;}
			SetPlayerPosEx(playerid, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
			SetPlayerFacingAngle(playerid, HouseData[id][houseInt][3]);
			SetPlayerInterior(playerid, HouseData[id][houseInterior]);
			SetPlayerVirtualWorld(playerid, HouseData[id][houseInteriorVW]);
			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHouse] = HouseData[id][houseID];
			return 1;
		}
		if ((id = House_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]))
	    {
			SetPlayerPosEx(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
			SetPlayerFacingAngle(playerid, HouseData[id][housePos][3] - 180.0);
			SetPlayerInterior(playerid, HouseData[id][houseExterior]);
			SetPlayerVirtualWorld(playerid, HouseData[id][houseExteriorVW]);
			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHouse] = -1;
			return 1;
		}
        if ((id = Business_Nearest(playerid)) != -1)
	    {
	        if (BusinessData[id][bizOwner] == 0)
	            {Dialog_Show(playerid, Achetermagasin, DIALOG_STYLE_MSGBOX, "Magasin", "Vous vouler acheter se magasin?", "Acheter", "Annuler");return 1;}
	        if (BusinessData[id][bizLocked])
	            {SendErrorMessage(playerid, "Ce magasin est fermé.");return 1;}
            static time[3];
			gettime(time[0], time[1], time[2]);
			if(BusinessData[id][bizchancevole] != 100)
			{
				if ((time[0] >= BusinessData[id][biztime1] && time[0] <= BusinessData[id][biztime2])/* && (BusinessData[id][biztime1] ==-1 && BusinessData[id][biztime2] ==-1)*/)
				{
					if (PlayerData[playerid][pTask] && !PlayerData[playerid][pStoreTask])
					{
					    PlayerData[playerid][pStoreTask] = 1;
					    Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "Magasin", "Ici est un magasin pour acheter plein d'objet qui pourra vous aider a progresser ici sur le serveur! Il suffit de viser le bot pour acheter l'objet désiré", "Fermer", "");
					    if (IsTaskCompleted(playerid))
						{
    						PlayerData[playerid][pTask] = 0;
							ShowPlayerFooter(playerid, "Vous avez ~g~accomplie~w~ tout vos tache!!");
						}
					}
					SetPlayerPosEx(playerid, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
					SetPlayerFacingAngle(playerid, BusinessData[id][bizInt][3]);
					SetPlayerInterior(playerid, BusinessData[id][bizInterior]);
					SetPlayerVirtualWorld(playerid, BusinessData[id][bizInteriorVW]);
					SetCameraBehindPlayer(playerid);
					PlayerData[playerid][pBusiness] = BusinessData[id][bizID];
					if (strlen(BusinessData[id][bizMessage]) && strcmp(BusinessData[id][bizMessage], "NULL", true)) {
					    SendClientMessage(playerid, COLOR_DARKBLUE, BusinessData[id][bizMessage]);
					}
				}
				else SendErrorMessage(playerid, "Ce magasin est fermé et sera ouvert entre %d et %d",BusinessData[id][biztime1],BusinessData[id][biztime2]);
			}
			else SendServerMessage(playerid,"Ce magasin est fermé du au récent vole qui a eu lieux.");
			return 1;
		}
		if ((id = Business_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.0, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]))
	    {
			SetPlayerPosEx(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2]);
			SetPlayerFacingAngle(playerid, BusinessData[id][bizPos][3] - 180.0);

			SetPlayerInterior(playerid, BusinessData[id][bizExterior]);
			SetPlayerVirtualWorld(playerid, BusinessData[id][bizExteriorVW]);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pBusiness] = -1;
			return 1;
		}
		if ((id = Entrance_Nearest(playerid)) != -1)
	    {
	        if (EntranceData[id][entranceLocked])
	            return SendErrorMessage(playerid, "Cette entrée est fermé pour le moment.");

            if (PlayerData[playerid][pTask])
			{
				if (EntranceData[id][entranceType] == 2 && !PlayerData[playerid][pBankTask])
				{
			    	PlayerData[playerid][pBankTask] = 1;
			    	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "Banque", "Voici une des nombreuse banques ici vous pouvez déposé/retirer et mettre dans votre compte épargne!", "Fermer", "");

				    if (IsTaskCompleted(playerid))
					{
				        PlayerData[playerid][pTask] = 0;
						ShowPlayerFooter(playerid, "Vous avez ~g~accomplie~w~ tout vos tache!!");
					}
				}
				else if (EntranceData[id][entranceType] == 1 && !PlayerData[playerid][pTestTask])
				{
			    	PlayerData[playerid][pTestTask] = 1;
			    	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "AUTO-ÉCOLE", "Ici l'auto-école pour passé votre permis de conduire", "Fermer", "");

				    if (IsTaskCompleted(playerid))
					{
				        PlayerData[playerid][pTask] = 0;
						ShowPlayerFooter(playerid, "Vous avez ~g~accomplie~w~ toute vos tache!!");
					}
				}
			}
			if (EntranceData[id][entranceCustom] == 2)
			{
				SetPlayerPosEx(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
				PlayerData[playerid][pEntrance] = -1;
			}
			else
			{
			    SetPlayerPosEx(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
                PlayerData[playerid][pEntrance] = EntranceData[id][entranceID];
			}
			SetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);

			SetPlayerInterior(playerid, EntranceData[id][entranceInterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceWorld]);

			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if ((id = Entrance_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]))
	    {
	        if (EntranceData[id][entranceCustom])
				SetPlayerPosEx(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
			else SetPlayerPosEx(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
			SetPlayerFacingAngle(playerid, EntranceData[id][entrancePos][3] - 180.0);
			SetPlayerInterior(playerid, EntranceData[id][entranceExterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceExteriorVW]);
			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pEntrance] = Entrance_GetLink(playerid);
			return 1;
		}
		if ((id = Crate_Nearest(playerid)) != -1 && PlayerData[playerid][pCarryCrate] == -1 && !IsCrateInUse(id))
		{
		    if ((id = Crate_Highest(id)) == -1)
		        id = Crate_Nearest(playerid);
		    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
            PlayerData[playerid][pCarryCrate] = id;
            SetPlayerAttachedObject(playerid, 4, 964, 1, -0.157020, 0.413313, 0.000000, 0.000000, 88.000000, 180.000000, 0.500000, 0.500000, 0.500000);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prendre la boite a l'aide de ses deux mains.", ReturnName(playerid, 0));
			SendServerMessage(playerid, "Vous avez une boite dans les mains. Vous pouvez la charger dans le camion en appuyant sur 'N'.");
			DestroyDynamicObject(CrateData[id][crateObject]);
			DestroyDynamic3DTextLabel(CrateData[id][crateText3D]);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			CrateData[id][crateObject] = INVALID_OBJECT_ID;
			return 1;
		}
		if (PlayerData[playerid][pCarryCrate] != -1 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY && !PlayerData[playerid][pCrafting])
		{
		    ApplyAnimation(playerid, "CARRY", "null", 4.0, 0, 0, 0, 0, 0);
		    ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

			Crate_Drop(playerid, 1.5);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s depose la boite a l'aide de ses deux mains.", ReturnName(playerid, 0));

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			return 1;
		}
	}
	//job meuble
	if(newkeys == 4)
	{
		if(GetPVarInt(playerid,"TomoCarpintero") == 1)
		{
			if(GetPVarInt(playerid,"MueblesCreados") == 0)
			{
			    new stockjobinfoid;
			    if(info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] == 0) return SendErrorMessage(playerid,"Il n'y a plus de stock de bois");
				Tronco(playerid);
				CantidadTroncos();
				return 1;
			}
		}
	}
	if(newkeys == 4)
	{
		if(GetPVarInt(playerid,"Trabajando") == 1)
		{
			if(GetPVarInt(playerid,"MueblesCreados") == 0)
			{
				HacerMueble(playerid);
				return 1;
			}
		}
	}
	//lowrider
	if(InContest[playerid] == true)
	{
		if (newkeys & KEY_ANALOG_UP && CurrentNote[playerid] == 0) {SendNoteForPlayer(playerid);}
		if (newkeys & KEY_ANALOG_DOWN && CurrentNote[playerid] == 1) {SendNoteForPlayer(playerid);}
		if (newkeys & KEY_ANALOG_RIGHT && CurrentNote[playerid] == 2) {SendNoteForPlayer(playerid);}
		if (newkeys & KEY_ANALOG_LEFT && CurrentNote[playerid] == 3) {SendNoteForPlayer(playerid);}
	}
	//clignotant
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == 2)
	{
	   	if(!IsAPlane(GetPlayerVehicleID(playerid)) && !IsABoat(GetPlayerVehicleID(playerid)) && !IsAPlane(GetPlayerVehicleID(playerid)) && !IsAHelicopter(GetPlayerVehicleID(playerid))  && !IsAVelo(GetPlayerVehicleID(playerid)))
	   	{
	      	new vid = GetPlayerVehicleID(playerid);
	  	 	if(newkeys & ( KEY_LOOK_LEFT ) && newkeys & ( KEY_LOOK_RIGHT ))
			{
		    	if(Indicators_xqz[vid][2] /*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]),DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
            	else if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]),DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
				else {
				SetVehicleIndicator(vid,1,1);
				}
				return 1;
			}
			if(newkeys & KEY_LOOK_RIGHT)
			{
	  		  	if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]), DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
      	      	else if(Indicators_xqz[vid][2]/*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]), DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
				else SetVehicleIndicator(vid,0,1);
			}
			if(newkeys & KEY_LOOK_LEFT)
			{
			    if(Indicators_xqz[vid][2]/*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]),DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
      	      	else if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]),DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
				else {
				SetVehicleIndicator(vid,1,0);
				}
			}
		}
	}
    //Job boucher
	if(newkeys & KEY_SPRINT && newkeys & KEY_JUMP || newkeys == KEY_FIRE || newkeys == KEY_JUMP || newkeys & KEY_SECONDARY_ATTACK  || (newkeys & KEY_SUBMISSION  && newkeys & KEY_SECONDARY_ATTACK))
    {
        if(GetPVarInt(playerid, "meatbhp") == 1)
        {
            SendClientMessage(playerid, 0x9BBE00F6, "Ne courez pas si vite... vous avez fait tomber la viande!");
            RemovePlayerAttachedObject(playerid,2);
            SetPVarInt(playerid, "meatbhp",0);
            meatprocces[playerid]=0;
            return PlayerCheckPointToMeat(playerid);
        }
    }
	//job doc fortcarson
	if(newkeys & KEY_JUMP || newkeys & KEY_SECONDARY_ATTACK || newkeys & KEY_FIRE || newkeys & KEY_SUBMISSION || newkeys & KEY_SPRINT)
 	{
 		if(GetPVarInt(playerid,"Yash") == 1)
 		{
 			SendClientMessage(playerid,-1,"Ne courez pas si vite... vous avez fait tomber la caisse!");
 			if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
 			DisablePlayerCheckpoint(playerid);
 			ClearAnimations(playerid);
 			SetPlayerCheckpoint(playerid, 2757.0496,-2575.8870,3.0000, 2.0);
 			SetPVarInt(playerid,"Yash",0);
		}
 	}
	//gym
	if ( ( newkeys & KEY_SECONDARY_ATTACK ) && !( oldkeys & KEY_SECONDARY_ATTACK ) )
  	{
		if(PLAYER_INTREAM[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			KillTimer(PLAYER_TREAD_TIMER[playerid]);
			GetOffTread(playerid);
	 	}
		if(PLAYER_INBIKE[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			KillTimer(PLAYER_BIKE_TIMER[playerid]);
			GetOffBIKE(playerid);
	 	}
		if(PLAYER_INBENCH[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			KillTimer(PLAYER_BENCH_TIMER[playerid]);
			GetOffBENCH(playerid);
		}
		if(PLAYER_INDUMB[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			KillTimer(PLAYER_DUMB_TIMER[playerid]);
			PutDownDUMB(playerid);
		}
	}
	if ( ( newkeys & KEY_SECONDARY_ATTACK ) && !( oldkeys & KEY_SECONDARY_ATTACK ))
	{
		for( new o; o != sizeof run_machine_pos; o ++ )
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, run_machine_pos[ o ][ 0 ], run_machine_pos[ o ][ 1 ], run_machine_pos[ o ][ 2 ] ) )
			{
				if(TREAM_IN_USE[o]==false && PLAYER_INTREAM[playerid]==false)
				{
				    if(PlayerData[playerid][pparcouru] >= 10000) return SendErrorMessage(playerid, "Vous êtes au max de vos capacité revenez plutard.");
					PLAYER_INTREAM[playerid]=true;
					TREAM_IN_USE[o]=true;
					PLAYER_CURRECT_TREAD[playerid]=o;
					PLAYER_TREAM_DIS_COUNT[playerid]=0;
					SetPlayerPos( playerid, run_machine_pos[ o ][ 0 ], run_machine_pos[ o ][ 1 ]+1.3, run_machine_pos[ o ][ 2 ] );
					SetPlayerFacingAngle( playerid, run_machine_pos[ o ][ 3 ] );
					TogglePlayerControllable( playerid, 0 );
					ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_geton", 1, 0, 0, 0, 1, 0, 1 );
					SetTimerEx( "TREAM_START", 2000, false, "ii", playerid);
					SetAntoineBarValue(player_gym_progress[playerid],50);
					SetPlayerCameraPos( playerid, run_machine_pos[ o ][ 0 ] +2, run_machine_pos[ o ][ 1 ] -2, run_machine_pos[ o ][ 2 ] + 0.5 );
					SetPlayerCameraLookAt( playerid, run_machine_pos[ o ][ 0 ], run_machine_pos[ o ][ 1 ], run_machine_pos[ o ][ 2 ]);
				}
			}
		}
		for( new b; b != sizeof bike_pos; b ++ )
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, bike_pos[ b ][ 0 ], bike_pos[ b ][ 1 ], bike_pos[ b ][ 2 ] ) )
			{
				if(BIKE_IN_USE[b]==false && PLAYER_INBIKE[playerid]==false)
				{
				    if(PlayerData[playerid][pparcouru] >= 10000) return SendErrorMessage(playerid, "Vous êtes au max de vos capacité revenez plutard.");
					BIKE_IN_USE[b]=true;
					PLAYER_INBIKE[playerid]=true;
					PLAYER_CURRECT_BIKE[playerid]=b;
					PLAYER_BIKE_DIS_COUNT[playerid]=0;
					SetAntoineBarValue(player_gym_progress[playerid],0);
					SetPlayerPos( playerid, bike_pos[ b ][ 0 ]+0.5, bike_pos[ b ][ 1 ]-0.5, bike_pos[ b ][ 2 ] );
					SetPlayerFacingAngle( playerid, bike_pos[ b ][ 3 ] );
					TogglePlayerControllable( playerid, 0 );
					ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_geton", 1, 0, 0, 0, 1, 0, 1 );
					SetTimerEx( "BIKE_START", 2000, false, "i", playerid);
					SetPlayerCameraPos( playerid, bike_pos[ b ][ 0 ] +2, bike_pos[ b ][ 1 ] -2, bike_pos[ b ][ 2 ] + 0.5 );
					SetPlayerCameraLookAt( playerid, bike_pos[ b ][ 0 ], bike_pos[ b ][ 1 ], bike_pos[ b ][ 2 ]+0.5);
				}
			}
		}
		for (new g; g != sizeof bench_pos; g ++)
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, bench_pos[ g ][ 0 ], bench_pos[ g ][ 1 ], bench_pos[ g ][ 2 ] ) )
			{
				if(BENCH_IN_USE[g]==false && PLAYER_INBENCH[playerid]==false)
				{
				    if(PlayerData[playerid][prepetitions] >= 5000) return SendErrorMessage(playerid, "Vous êtes au max de vos capacité revenez plutard.");
					BENCH_IN_USE[g]=true;
					PLAYER_INBENCH[playerid]=true;
					PLAYER_CURRECT_BENCH[playerid]=g;
					PLAYER_BENCH_COUNT[playerid]=0;
					SetAntoineBarValue(player_gym_progress[playerid],0);
					TogglePlayerControllable( playerid, 0 );
					SetPlayerPos( playerid, bench_pos[ g ][ 0 ], bench_pos[ g ][ 1 ], bench_pos[ g ][ 2 ] );
					SetPlayerFacingAngle( playerid, bench_pos[ g ][ 3 ] );
					ApplyAnimation( playerid, "benchpress", "gym_bp_geton", 1, 0, 0, 0, 1, 0, 1 );
					SetTimerEx( "BENCH_START", 3800, 0, "ii", playerid,g);
					SetPlayerCameraPos( playerid, bench_pos[ g ][ 0 ]-1.5, bench_pos[ g ][ 1 ]+1.5, bench_pos[ g ][ 2 ] + 0.5 );
					SetPlayerCameraLookAt( playerid, bench_pos[ g ][ 0 ], bench_pos[ g ][ 1 ], bench_pos[ g ][ 2 ]);
				}
			}
		}
		for (new d; d != sizeof dumb_pos; d ++)
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, dumb_pos[ d ][ 0 ], dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ] ) )
			{
				if(DUMB_IN_USE[d]==false && PLAYER_INDUMB[playerid]==false)
				{
				    if(PlayerData[playerid][prepetitions] >= 5000) return SendErrorMessage(playerid, "Vous êtes au max de vos capacité revenez plutard.");
					DUMB_IN_USE[d]=true;
					PLAYER_INDUMB[playerid]=true;
					PLAYER_CURRECT_DUMB[playerid]=d;
					PLAYER_DUMB_COUNT[playerid]=0;
					SetAntoineBarValue(player_gym_progress[playerid],0);
					TogglePlayerControllable( playerid, 0 );
					SetPlayerPos( playerid, dumb_pos[ d ][ 0 ]-1, dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ] +1);
					SetPlayerFacingAngle( playerid, dumb_pos[ d ][ 3 ] );
					ApplyAnimation( playerid, "Freeweights", "gym_free_pickup", 1, 0, 0, 0, 1, 0, 1 );
					SetTimerEx( "DUMB_START", 2500, 0, "ii", playerid);
					SetPlayerCameraPos( playerid, dumb_pos[ d ][ 0 ]+2.3, dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ]+0.3 );
					SetPlayerCameraLookAt( playerid, dumb_pos[ d ][ 0 ], dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ]+0.5);
				}
			}
		}
	}
	if ( ( newkeys & KEY_SPRINT ) && !( oldkeys & KEY_SPRINT ) )
 	{
		if(PLAYER_INTREAM[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			SetAntoineBarValue( player_gym_progress[playerid], GetAntoineBarValue( player_gym_progress[playerid] ) + 5 );
			UpdateAntoineBar( player_gym_progress[playerid], playerid );
			new LocalLabel[10];
			PLAYER_TREAM_DIS_COUNT[playerid]++;
			format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_TREAM_DIS_COUNT[playerid]);
			TextDrawSetString(gym_deslabel[playerid],LocalLabel);
			PlayerData[playerid][pparcouru] += PLAYER_TREAM_DIS_COUNT[playerid];
			AFKMin[playerid] = 0;
		}
		if(PLAYER_INBIKE[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			SetAntoineBarValue(player_gym_progress[playerid], GetAntoineBarValue(player_gym_progress[playerid] ) + 5 );
			UpdateAntoineBar( player_gym_progress[playerid], playerid );
			new LocalLabel[10];
			PLAYER_BIKE_DIS_COUNT[playerid]++;
			format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_BIKE_DIS_COUNT[playerid]);
			TextDrawSetString(gym_deslabel[playerid],LocalLabel);
			PlayerData[playerid][pparcouru] += PLAYER_TREAM_DIS_COUNT[playerid];
			AFKMin[playerid] = 0;
		}
		if(PLAYER_INBENCH[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			SetAntoineBarValue(player_gym_progress[playerid], GetAntoineBarValue(player_gym_progress[playerid] ) + 5 );
			UpdateAntoineBar( player_gym_progress[playerid], playerid );
			AFKMin[playerid] = 0;
		}
		if(PLAYER_INDUMB[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
			SetAntoineBarValue(player_gym_progress[playerid], GetAntoineBarValue(player_gym_progress[playerid] ) + 5 );
			UpdateAntoineBar( player_gym_progress[playerid], playerid );
			AFKMin[playerid] = 0;
		}
 	}
	if(newkeys & KEY_SECONDARY_ATTACK)
 	{
	 	new id = slotmachine_Nearest(playerid);
	 	if (id != -1)
	 	{
			new stockjobinfoid,count;
		    if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
			//generateur
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 1;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 1;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 1;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 1;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 1;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
			stockjobinfosave(stockjobinfoid);
	 		if(GetPlayerMoney(playerid) < MONEY_COST) return GameTextForPlayer(playerid, "~r~Vous n'avez pas assez d'argent", 2000, 3);
	 		if(repeats[playerid] != 0) return 1;
	 		ShowMachineTD(playerid);
	 		ApplyAnimation(playerid, "VENDING", "VEND_USE", 4.0, 0, 0, 0, 0, 0);
	 		timerslot[playerid] = SetTimerEx("UpdateMachineTD", 100, 1, "d", playerid);
	 		GiveMoney(playerid, -MONEY_COST);
	 		TogglePlayerControllable(playerid, 0);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = MONEY_COST / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
	 	}
	 	return 1;
	}
	if (PRESSED123(KEY_ACTION))
	{
		ShowHungerTextdraw(playerid, 1);
	}
	else if (RELEASED123(KEY_ACTION))
	{
		ShowHungerTextdraw(playerid, 0);
	}
	return 1;
}
script PutInsideVehicle(playerid, vehicleid)
{
	if (!PlayerData[playerid][pDrivingTest])
	    return 0;
	RemoveFromVehicle(vehicleid);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    return 1;
}
script OnPlayerExitVehicle(playerid, vehicleid)
{
    if (IsPlayerNPC(playerid)) return 1;
	if (PlayerData[playerid][pTaxiDuty])
	{
        foreach (new i : Player) if (PlayerData[i][pTaxiPlayer] == playerid && IsPlayerInVehicle(i, GetPlayerVehicleID(playerid))) {
	        LeaveTaxi(i, playerid);
	    }
	    SetPlayerColor(playerid, DEFAULT_COLOR);
        PlayerData[playerid][pTaxiDuty] = false;
        SendServerMessage(playerid, "Vous n'êtes plus en service de taxi!");
	}
    if (PlayerData[playerid][pDrivingTest])
	{
	    SetTimerEx("PutInsideVehicle", 500, false, "dd", playerid, vehicleid);
		Dialog_Show(playerid, LeaveTest, DIALOG_STYLE_MSGBOX, "Confirmer quitter le test", "Attention: Etes-vous sûr de vouloir quitter l'épreuve de conduite?", "Oui", "Non");
	}
	if (PlayerData[playerid][pJob] == JOB_UNLOADER && GetVehicleModel(vehicleid) == 530)
	{
	    CoreVehicles[vehicleid][vehLoadType] = 0;
		DestroyObject(CoreVehicles[vehicleid][vehCrate]);
		CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
		DisablePlayerCheckpoint(playerid);
	}
	cmd_sdfghjklloikjiujytr(playerid, "");
	//centure
    if(SeatbeltStatus[playerid] == 1)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Vous avez enlever votre ceinture de sécurité ou votre casque.");
		RemovePlayerAttachedObject(playerid, 6);
	    for (new i = 92; i < 95; i ++)
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	}
	return 1;
}
script OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (IsPlayerNPC(playerid))return 1;
	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || PlayerData[playerid][pInjured] || PlayerData[playerid][pFirstAid]) {
	    ClearAnimations(playerid);
	    return 0;
	}
	new id = Car_GetID(vehicleid);
	/*if (!ispassenger && id != -1 && CarData[id][carFaction] > 0 && GetFactionType(playerid) != CarData[id][carFaction]) {
	    ClearAnimations(playerid);
	    return SendErrorMessage(playerid, "Vous n'avez pas les clefs de ce véhicule.");
	}*/
	if (CarData[id][carLoca] == 1 && CarData[id][carLocaID] == 0)
	{
		new string[260];
		format(string, sizeof(string), "~w~Vous pouvez louer ce vehicule ~n~Prix:~w~ 200$~n~~w~pour louer, utilisez ~r~/louerveh");
		GameTextForPlayer(playerid, string, 3500, 3);
	}
	//centure
	SeatbeltStatus[playerid] = 0;
	return 1;
}
script OnPlayerEnterCheckpoint(playerid)
{
	if (PlayerData[playerid][pTutorialStage])
	{
		if (PlayerData[playerid][pTutorialStage] == 5)
		{
		    for (new i = 0; i < 5; i ++) {
		        SendClientMessage(playerid, -1, "");
			}
			new serveursettinginfoid,money = random(5000) + 5000;
			PlayerData[playerid][prepetitions] = random(500);
			PlayerData[playerid][pparcouru] = random(500);
			PlayerData[playerid][pBankMoney] = money;
			SendServerMessage(playerid,"Vous avez reçu %s$ pour vous etes connecté sur le serveur en finissant l'inscription.",FormatNumber(money));
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: Un nouveau %s est arrivé sur le serveur, origine : %s.",ReturnName(playerid),PlayerData[playerid][pOrigin]);
			//ici mettre pour réglé plutat le probleme du tuto :@
			PlayerData[playerid][pCreated] = 1;
	    	PlayerData[playerid][pTask] = 1;
  			PlayerData[playerid][pTutorial] = 0;
			PlayerData[playerid][pTutorialTime] = 0;
			PlayerData[playerid][pTutorialStage] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			PlayerData[playerid][pFreeze] = 0;
			TogglePlayerControllable(playerid, 1);
			SendServerMessage(playerid, "Un canal nouveau /n (5heures de jeux max) est disponible pour vos question.");
			if (IsPlayerInRangeOfPoint(playerid,5,2513.0457,-1729.3940, 778.4033) && info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 1)
			{
				SetPlayerPosEx(playerid,2096.7385, -1687.4127, 13.4706);
			}
			if (IsPlayerInRangeOfPoint(playerid,5,2513.0457,-1729.3940, 778.4033) && info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 2)
			{
				SetPlayerPosEx(playerid,-2042.7759,-2559.0552,30.6301);
			}
			if (IsPlayerInRangeOfPoint(playerid,5,2513.0457,-1729.3940,778.4033) && info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 5)
			{
				SetPlayerPosEx(playerid,753.0231,-923.5688,5.9172);//immigrant vc
			}
		}
	    DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(TruckingCheck[playerid] >= 1 && PlayerData[playerid][pUnloading] == -1)
	{
	    if (!IsPlayerInAnyVehicle(playerid))
		{
		    SendErrorMessage(playerid, "Vous nêtes pas dans le véhicule");
		    return 1;
		}
		new vehicleid = GetPlayerVehicleID(playerid),string[180],facass = PlayerData[playerid][pFaction];
		if (!IsLoadableVehicle(vehicleid)) {SendErrorMessage(playerid, "Vous nêtes pas dans un véhicule de livraison.");}
        format(string, sizeof(string), "Vous avez fait gagner $%d à l'entreprise!", TruckingCheck[playerid]);
    	FactionData[facass][factioncoffre]+= TruckingCheck[playerid];
        TruckingCheck[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, string);
		DisablePlayerCheckpoint(playerid);
	}
	if (PlayerData[playerid][pCP])
	{
	    DisablePlayerCheckpoint(playerid);
	    PlayerData[playerid][pCP] = 0;
	}
	if (PlayerData[playerid][pTask])
	{
	    new id = -1;

		if ((id = Entrance_Nearest(playerid)) != -1 && EntranceData[id][entranceType] == 2 && !PlayerData[playerid][pBankTask])
		    ShowPlayerFooter(playerid, "Appuyer sur ~y~'F'~w~ pour entrer dans la banque.");

        if ((id = Business_Nearest(playerid)) != -1 && BusinessData[id][bizType] == 1 && !PlayerData[playerid][pStoreTask])
		    ShowPlayerFooter(playerid, "Appuyer sur ~y~'F'~w~ pour entrer au 24/7.");

        if ((id = Entrance_Nearest(playerid)) != -1 && EntranceData[id][entranceType] == 1 && !PlayerData[playerid][pTestTask])
		    ShowPlayerFooter(playerid, "Appuyer sur ~y~'F'~w~ pour entrer a l'auto ecole.");

		DisablePlayerCheckpoint(playerid);
	}
	if (PlayerData[playerid][pDrivingTest])
	{
	    PlayerData[playerid][pTestStage]++;

	    if (PlayerData[playerid][pTestStage] < sizeof(g_arrDrivingCheckpoints)) {
			SetPlayerCheckpoint(playerid, g_arrDrivingCheckpoints[PlayerData[playerid][pTestStage]][0], g_arrDrivingCheckpoints[PlayerData[playerid][pTestStage]][1], g_arrDrivingCheckpoints[PlayerData[playerid][pTestStage]][2], 3.0);
		}
		else
		{
		    static Float:health;
		    GetVehicleHealth(GetPlayerVehicleID(playerid), health);
		    if (health < 950.0)
				SendErrorMessage(playerid, "Vous avez échoué vehicule trop endomagé!");
		    else
			{
		        Inventory_Add(playerid, "permis de conduire", 1581);
		        SendServerMessage(playerid, "Vous avez réussi votre test de conduite!.");
		        RemovePlayerAttachedObject(playerid, 6);
		    }
    		if(IsPlayerInAnyVehicle(playerid) == 1 && SeatbeltStatus[playerid] == 1) {RemovePlayerAttachedObject(playerid, 6);}
  			CancelDrivingTest(playerid);
		}
	}
	else
	{
	    new vehicleid = GetPlayerVehicleID(playerid),Float:health,facass = PlayerData[playerid][pFaction];
		if (PlayerData[playerid][pWaypoint])
		{
		    PlayerData[playerid][pWaypoint] = 0;
		    DisablePlayerCheckpoint(playerid);
		    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][69]);
		}
		else if (FactionData[facass][factionacces][6] == 1 && !IsPlayerInAnyVehicle(playerid))
		{
			if (PlayerData[playerid][pLoading] && !PlayerData[playerid][pLoadCrate] && Job_NearestPoint(playerid) != -1)
			{
			    PlayerData[playerid][pLoadCrate] = 1;
		        SetPlayerAttachedObject(playerid, 4, 3014, 1, 0.038192, 0.371544, 0.055191, 0.000000, 90.000000, 357.668670, 1.000000, 1.000000, 1.000000);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
				ShowPlayerFooter(playerid, "Appuyer sur ~y~'N'~w~ pour charger la marchandise dans le camion.");
	    		new stockjobinfoid;
				info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] -= 1;
				stockjobinfosave(stockjobinfoid);
				Updatestockmagasin();
			}
			else if (PlayerData[playerid][pUnloading] != -1)
			{
				if (!PlayerData[playerid][pLoadCrate])
				{
				    PlayerData[playerid][pLoadCrate] = 1;
				    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
			        SetPlayerAttachedObject(playerid, 4, 3014, 1, 0.038192, 0.371544, 0.055191, 0.000000, 90.000000, 357.668670, 1.000000, 1.000000, 1.000000);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
					SetPlayerCheckpoint(playerid, BusinessData[PlayerData[playerid][pUnloading]][bizPos][0], BusinessData[PlayerData[playerid][pUnloading]][bizPos][1], BusinessData[PlayerData[playerid][pUnloading]][bizPos][2], 1.0);
					ShowPlayerFooter(playerid, "Livrer la marchandise au ~r~point.");
					CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoads]--;
				}
				else
				{
				    static Float:fX,Float:fY,Float:fZ,string[64];
				    PlayerData[playerid][pLoadCrate] = 0;
				    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
				    RemovePlayerAttachedObject(playerid, 4);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
					switch (CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoadType])
					{
					    case 1:
						{
							TruckingCheck[playerid] += 35;
					        ShowPlayerFooter(playerid, "~g~$35~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 2:
						{
						    TruckingCheck[playerid] += 40;
					        ShowPlayerFooter(playerid, "~g~$40~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 3:
						{
						    TruckingCheck[playerid] += 30;
					        ShowPlayerFooter(playerid, "~g~$30~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 4:
						{
						    TruckingCheck[playerid] += 35;
					        ShowPlayerFooter(playerid, "~g~$35~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 5:
						{
						    TruckingCheck[playerid] += 40;
					        ShowPlayerFooter(playerid, "~g~$40~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 6:
						{
						    TruckingCheck[playerid] += 35;
					        ShowPlayerFooter(playerid, "~g~$35~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 7:
						{
						    TruckingCheck[playerid] += 35;
					        ShowPlayerFooter(playerid, "~g~$35~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 8:
						{
						    TruckingCheck[playerid] += 40;
					        ShowPlayerFooter(playerid, "~g~$40~w~ sera ajouter au compte de l'entreprise.");
					    }
					    case 9:
						{
						    TruckingCheck[playerid] += 35;
					        ShowPlayerFooter(playerid, "~g~$35~w~ sera ajouter au compte de l'entreprise.");
					    }
					}
					if (CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoadType] == 5)
					{
						for (new i = 0; i < MAX_DYNAMIC_OBJ; i ++) if (PumpData[i][pumpExists] && PumpData[i][pumpBusiness] == PlayerData[playerid][pUnloading]) {
						    PumpData[i][pumpFuel] += 100;

			                format(string, sizeof(string), "[Pompe: %d]\n{FFFFFF}Restant: %d litres", i, PumpData[i][pumpFuel]);
						    UpdateDynamic3DTextLabelText(PumpData[i][pumpText3D], COLOR_DARKBLUE, string);
						    Pump_Save(i);
						}
					}
					else
					{
						BusinessData[PlayerData[playerid][pUnloading]][bizProducts] += 20;
						Business_Save(PlayerData[playerid][pUnloading]);
					}
					if (CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoads] > 0)
					{
					    GetVehicleBoot(PlayerData[playerid][pUnloadVehicle], fX, fY, fZ);
					    SetPlayerCheckpoint(playerid, fX, fY, fZ, 1.0);
					}
					else
					{
					    CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoads] = 0;
					    CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoadType] = 0;
				     	PlayerData[playerid][pUnloading] = -1;
					    PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;
						DisablePlayerCheckpoint(playerid);
					    SendServerMessage(playerid, "Vous avez livrer toute les marchandises.");
					    SendServerMessage(playerid, "Retournez au dépot pour que l'entreprise soit payer.");
					    SetPlayerCheckpoint(playerid,2459.6982,-2115.7124,13.5469, 5.0);
					    if (PlayerData[playerid][pShipment] != -1)
					    {
					        foreach (new i : Player) if (Business_IsOwner(i, PlayerData[playerid][pShipment])) {
					            SendServerMessage(playerid, "%s à livrer la marchandise à %s.", ReturnName(playerid, 0), BusinessData[PlayerData[playerid][pShipment]][bizName]);
							}
							BusinessData[PlayerData[playerid][pShipment]][bizShipment] = 0;
							Business_Save(PlayerData[playerid][pShipment]);
          					PlayerData[playerid][pShipment] = -1;
          					PlayerData[playerid][pDeliverShipment] = 0;
					    }
					}
				}
			}
		}
		else if (PlayerData[playerid][pJob] == JOB_MINER && PlayerData[playerid][pMinedRock] && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
		{
		    //new money = random(20) + 5;
		    new salairejobinfoid,money = info_salairejobinfo[salairejobinfoid][salairejobinfominer],stockjobinfoid;
			SendJOBMessage(playerid, "Vous avez gagné %d$ sur cette roche.", money);
			GiveMoney(playerid, money);
			info_stockjobinfo[stockjobinfoid][stockjobinfostockminer] += 1;
			stockjobinfosave(stockjobinfoid);
			Updatestockminer();

			PlayerData[playerid][pMinedRock] = 0;
			PlayerData[playerid][pMineCount] = 0;

			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid, 4);

			SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.156547, 0.039423, 0.026570, 198.109115, 6.364907, 262.997558, 1.000000, 1.000000, 1.000000);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
		else if (PlayerData[playerid][pJob] == JOB_BUCHERON && PlayerData[playerid][pWoodRock] && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
		{
		    new salairejobinfoid,money = info_salairejobinfo[salairejobinfoid][salairejobinfobucheron],stockjobinfoid;
			SendJOBMessage(playerid, "Vous avez gagné %d$ sur cette stère de bois.", money);
			GiveMoney(playerid, money);
			info_stockjobinfo[stockjobinfoid][stockjobinfobois] += 1;
			stockjobinfosave(stockjobinfoid);
			Updatestockbois();

			PlayerData[playerid][pWoodRock] = 0;
			PlayerData[playerid][pWoodCount] = 0;

			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid, 4);

			SetPlayerAttachedObject(playerid, 4, 341, 6, 0.156547, 0.039423, 0.026570, 198.109115, 6.364907, 262.997558, 1.000000, 1.000000, 1.000000);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	    else if (PlayerData[playerid][pJob] == JOB_UNLOADER && IsPlayerInWarehouse(playerid) && GetVehicleModel(vehicleid) == 530 && CoreVehicles[vehicleid][vehLoadType] == 7)
	    {
	        GetVehicleHealth(vehicleid, health);
	        CoreVehicles[vehicleid][vehLoadType] = 0;
	        DestroyObject(CoreVehicles[vehicleid][vehCrate]);
			CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
			DisablePlayerCheckpoint(playerid);

			if (health < CoreVehicles[vehicleid][vehLoadHealth]) {
			    SendErrorMessage(playerid, "Vous avez endomamgé la boite.");
			}
			else {
			    new salairejobinfoid;
				new caristeprix = info_salairejobinfo[salairejobinfoid][salairejobinfocariste];
				//SendServerMessage(playerid, "Vous avez déchargé la caisse en bois pour 20$.");
				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", caristeprix);
				GiveMoney(playerid, caristeprix);
				new stockjobinfoid;
				info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste] += 1;
				stockjobinfosave(stockjobinfoid);
				Updatestockcariste();
			}
		}
		else if (PlayerData[playerid][pJob] == JOB_SORTER && PlayerData[playerid][pSorting] != -1)
		{
		    if (PlayerData[playerid][pSortCrate])
		    {

				new salairejobinfoid,manuprix = info_salairejobinfo[salairejobinfoid][salairejobinfomanutentionnaire];
		        PlayerData[playerid][pSortCrate] = 0;
		        RemovePlayerAttachedObject(playerid, 4);
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		        ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
		        SetPlayerCheckpoint(playerid, JobData[PlayerData[playerid][pSorting]][jobPoint][0], JobData[PlayerData[playerid][pSorting]][jobPoint][1], JobData[PlayerData[playerid][pSorting]][jobPoint][2], 1.0);

				GiveMoney(playerid, manuprix);
   				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", manuprix);
				//ShowPlayerFooter(playerid, "Vous avez gagner ~g~$10~w~ pour le paquet.");
				new stockjobinfoid;
				info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter] += 1;
				stockjobinfosave(stockjobinfoid);
				Updatestocksorter();
			}
			else
			{
                SetPlayerAttachedObject(playerid, 4, 1220, 5, 0.137832, 0.176979, 0.151424, 96.305931, 185.363006, 20.328088, 0.699999, 0.800000, 0.699999);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

				ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
				SetPlayerCheckpoint(playerid, JobData[PlayerData[playerid][pSorting]][jobDeliver][0], JobData[PlayerData[playerid][pSorting]][jobDeliver][1], JobData[PlayerData[playerid][pSorting]][jobDeliver][2], 1.0);

                PlayerData[playerid][pSortCrate] = 1;
				ShowPlayerFooter(playerid, "Veuiller aller au point pour la livraison ~r~marqueur.");
			}
		}
	}
	//job meuble
	if(GetPVarInt(playerid,"MueblesCreados") == 1)
	{
		DisablePlayerCheckpoint(playerid);
		Mueble[playerid] += 1;
		MueblesCreados[playerid] = MueblesCreados[playerid] + Mueble[playerid];
		new text[150];
		format(text,sizeof(text),"{c7a24a}»{FFFFFF} Vous venez de déposer{c7a24a} %d {FFFFFF}meuble(s).",MueblesCreados[playerid]);
		new stockjobinfoid;
		info_stockjobinfo[stockjobinfoid][stockjobinfomeuble] += 1;
		stockjobinfosave(stockjobinfoid);
		Updatestockmeuble();
		SendClientMessage(playerid,-1,text);
		SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Pour recevoir votre salaire, aller devant le bureau et faire /quittermeuble");
		SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Plus la fabrication de meuble est élevée plus vous serez payé.");
		Mueble[playerid] = 0;
		SetPVarInt(playerid,"MueblesCreados",0);
		SetPVarInt(playerid,"HaciendoMueble",0);
		SetPVarInt(playerid,"TomoCarpintero",1);
		SetPVarInt(playerid,"Trabajando",0);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
		SetPlayerAttachedObject(playerid,4,18635,6,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
		ApplyAnimation(playerid,"PED","IDLE_tired",4.1,1,0 ,0,0,1500);
		return 1;
	}
	//job entreprise coursier
 	if(check[playerid] == 1)
	{
		DisablePlayerCheckpoint(playerid);
		check[playerid] = 0;
		check2[playerid] = 1;
		SetPlayerCheckpoint(playerid,1897.4432,-2057.4128,13.5469, 4.0);
		SendClientMessage(playerid,0xADFF2FAA, "{0000FF}Montez livrer le courrier");
		return 1;
	}

	if(check2[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check2[playerid] = 0;
		check3[playerid] = 1;
		SetPlayerCheckpoint(playerid,1802.1014,-2107.8123,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}

	if(check3[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{
		DisablePlayerCheckpoint(playerid);
		check3[playerid] = 0;
		check4[playerid] = 1;
		SetPlayerCheckpoint(playerid,1763.2147,-2107.8977,13.5469, 5.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}

	if(check4[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check4[playerid] = 0;
		check5[playerid] = 1;
		SetPlayerCheckpoint(playerid,1734.4684,-2107.7139,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check5[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check5[playerid] = 0;
		check10[playerid] = 1;
		SetPlayerCheckpoint(playerid,1711.7948,-2107.8833,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check10[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check10[playerid] = 0;
		check11[playerid] = 1;
		SetPlayerCheckpoint(playerid,1694.9027,-2117.9849,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check11[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check11[playerid] = 0;
		check12[playerid] = 1;
		SetPlayerCheckpoint(playerid,1714.7600,-2117.2139,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check12[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check12[playerid] = 0;
		check13[playerid] = 1;
		SetPlayerCheckpoint(playerid,1759.1665,-2117.2258,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check13[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check13[playerid] = 0;
		check14[playerid] = 1;
		SetPlayerCheckpoint(playerid,1786.6273,-2117.1565,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check14[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check14[playerid] = 0;
		check8[playerid] = 1;
		SetPlayerCheckpoint(playerid,1803.2677,-2117.1145,13.5469, 4.0);
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{FF0000}Allez au point suivant?");
				}
	return 1;
				}
	if(check8[playerid] == 1)
	{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 462)
	{

		DisablePlayerCheckpoint(playerid);
		check8[playerid] = 0;
		check9[playerid] = 1;
		SetPlayerCheckpoint(playerid,994.3453,-1537.4506,14.0068, 2.0);
		SendClientMessage(playerid,0xADFF2FAA, "{00FF19}Retourner au bureau");
					}
	else
				{
					SendClientMessage(playerid, COLOR_RADIO, "{00FF15}[Entreprise]: {FFFFFF}Pourquoi le courier n'est pas livré?");
				}
	return 1;
				}
	if(check9[playerid] == 1)
	{
		DisablePlayerCheckpoint(playerid);
		check9[playerid] = 0;
		SendClientMessage(playerid,0xADFF2FAA, "{00FF15}[Entreprise]: {FFFFFF}Tout le courrier est livré argent gagner à l'entreprise {FFFFFF}200$");
		new facass = PlayerData[playerid][pFaction];
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
		return 1;
	}
	if(GetPVarInt(playerid, "Gjob") == 1)
    {
    	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
    	SetPlayerAttachedObject(playerid,3,2969,1,0.075578,0.407083,0.000000,1.248928,97.393852,359.645050,1.000000,1.000000,1.000000);
    	SendClientMessage(playerid, COLOR_LIGHTGREEN, "Allez sur votre établie.");
    	new gcheck = random(6);
    	if(gcheck == 0) SetPlayerCheckpoint(playerid,2324.5806, 7.2959, 1026.4464,1.5);
    	if(gcheck == 1) SetPlayerCheckpoint(playerid,2332.1421, 7.2300, 1026.4464,1.5);
    	if(gcheck == 2) SetPlayerCheckpoint(playerid,2331.8218, 3.0623, 1026.4464,1.5);
    	if(gcheck == 3) SetPlayerCheckpoint(playerid,2331.7876, -0.4087, 1026.4464,1.5);
    	if(gcheck == 4) SetPlayerCheckpoint(playerid,2331.9124, -3.3944, 1026.4464,1.5);
    	if(gcheck == 5) SetPlayerCheckpoint(playerid,2330.1165, -3.3331, 1026.4464,1.5);
    	SetPVarInt(playerid, "Gjob",2);
    	return 1;
    }
    if(GetPVarInt(playerid, "Gjob") == 2)
    {
        DisablePlayerCheckpoint(playerid);
        RemovePlayerAttachedObject(playerid,3);
        ClearAnimations(playerid);
        ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 1, 1, 1, 1, 0);
        SetPlayerAttachedObject(playerid,3,355,14,0.401943,0.011442,0.010348,106.050292,330.509094,3.293162,1.000000,1.000000,1.000000);
        SetTimerEx("Gunjobanim", 7000, false, "i", playerid);
        return 1;
    }
    if(GetPVarInt(playerid, "Gjob") == 3)
    {
        RemovePlayerAttachedObject(playerid,3);
        ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
        SetPVarInt(playerid,"GUN",GetPVarInt(playerid,"GUN")+1);
        new string [128],stockjobinfoid;
        format(string,sizeof(string),"armes collectées: {9ACD32}%d.",GetPVarInt(playerid,"GUN"));
        SendClientMessage(playerid,COLOR_WHITE,string);
        info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes] += 1;
        stockjobinfosave(stockjobinfoid);
        Updatestockinfoarme();
        SetPVarInt(playerid,"Gjob",1);
        new mcheck = random(3);
        if(mcheck == 0) SetPlayerCheckpoint(playerid,2329.0120, -1.9426, 1026.4464,1.5);
        if(mcheck == 1) SetPlayerCheckpoint(playerid,2328.6267, 1.7976, 1026.4464,1.5);
        if(mcheck == 2) SetPlayerCheckpoint(playerid,2327.8728, 6.1150, 1026.4464,1.5);
        return 1;
    }
    //Job boucher
	if(meatprocces[playerid]==1)
	{
		SetCameraBehindPlayer(playerid);
		AnimTimer = SetTimerEx("meattimer",3000,0,"%d",playerid);
		ApplyAnimation(playerid,"SHOP","SHP_Serve_End",4.1,0,1,1,1,1);
	}
	if(IsPlayerInRangeOfPoint(playerid, 1.0,958.9435,2172.8105,1011.0234))
	{
	    new stringer[900];
	    new salairejobinfoid;
	    new boucherprix = info_salairejobinfo[salairejobinfoid][salairejobinfoboucher];
		format(stringer, sizeof(stringer), "Vous avez apporté: %d viande | Vous gagnez : %d$",meats[playerid],meats[playerid]*boucherprix);
		SendClientMessage(playerid, 0xABD08EF6, stringer);
		new stockjobinfoid;
		info_stockjobinfo[stockjobinfoid][stockjobinfoviande] += 1;
		stockjobinfosave(stockjobinfoid);
		Updatestockviande();
		meatprocces[playerid]=0;
		RemovePlayerAttachedObject(playerid, 2);
		SetPlayerAttachedObject( playerid, 0, 335, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
		SetPVarInt(playerid, "meatbhp",0);
		ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
		meats[playerid]++;
		return PlayerCheckPointToMeat(playerid);
	}
    //job petrolier
    if(GetPVarInt(playerid,"pForestJob") == 1)
    {
        if (IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid,"Vous devez être hors d'un vehicule.");
        DisablePlayerCheckpoint(playerid);
        SetPlayerAttachedObject(playerid,6,18635,6);
        ApplyAnimation(playerid,"CHAINSAW","WEAPON_csaw",1.0,1,0,0,0,6000,0);
        SetTimerEx("PreWoodLoaded",4000+random(4000),false,"i",playerid);
        return 1;
    }
    if(GetPVarInt(playerid,"pForestJob") == 2)
    {
        if (IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid,"Vous devez être hors d'un vehicule.");
        DisablePlayerCheckpoint(playerid);
        RemovePlayerAttachedObject(playerid,6);
        RemovePlayerAttachedObject(playerid,4);
        ApplyAnimation(playerid,"CARRY","putdwn105",4.1,0,1,1,1,1);
        SetPVarInt(playerid,"ForestKG", GetPVarInt(playerid,"ForestKG")+1);
        SendJOBMessage(playerid, "Vous avez apporté 1 baril il contient 10 kg d'huile. Nombre de kg d'huile produits par vous: %d",GetPVarInt(playerid,"ForestKG"));
        new stockjobinfoid,P = random(sizeof(cForestJob));
		info_stockjobinfo[stockjobinfoid][stockjobinfopetrol] += 10;
		stockjobinfosave(stockjobinfoid);
		Updatepetrol();
        SetPlayerCheckpoint(playerid,cForestJob[P][0],cForestJob[P][1],cForestJob[P][2],2.0);
        SetPVarInt(playerid,"pForestJob",1);
        ClearAnimations(playerid, 1);
        return 1;
    }
    //job doc fortcarson
    if(IsPlayerInRangeOfPoint(playerid,2.0, 2757.0496,-2575.8870,3.0000))
    {
        ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
        SetPVarInt(playerid,"Yash",1);
        SetPlayerAttachedObject(playerid, 1 , 2358, 1,0.11,0.36,0.0,0.0,90.0);
        SetPlayerCheckpoint(playerid,2770.3699,-2541.3975,13.6360, 2.0);
        return true;
    }
    if(IsPlayerInRangeOfPoint( playerid,2.0,2770.3699,-2541.3975,13.6360))
    {
        new string[133],stockjobinfoid;
        ClearAnimations(playerid);
        ApplyAnimation(playerid,"PED","IDLE_tired",4.1,1,0,0,0,2500);
        ApplyAnimation(playerid,"PED","IDLE_tired",4.1,1,0,0,0,2500);
        SetPVarInt(playerid,"YASHIK", GetPVarInt(playerid,"YASHIK")+1);
        if(IsPlayerAttachedObjectSlotUsed(playerid,1)) RemovePlayerAttachedObject(playerid,1);
        SetPlayerCheckpoint(playerid, 2757.0496,-2575.8870,3.0000, 2.0);
        SetPVarInt(playerid,"Yash",0);
        format(string, sizeof(string), "{e49b0f}Caisse Déchargé:{34c924} %d.",GetPVarInt(playerid,"YASHIK"));
        switch(doks[random(sizeof(doks))][0])
        {
          case 0: prod += 10+random(10);
          case 1: topl += 10+random(10);
          case 2: boe += 20+random(10);
        }
        SendClientMessage(playerid, -1, string);
        info_stockjobinfo[stockjobinfoid][stockjobinfostockdock] += 1;
		stockjobinfosave(stockjobinfoid);
		Updatestockdock();
        return true;
    }
	if(livraisonjob[playerid] == 0)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfobois] < 10) return SendErrorMessage(playerid,"Il a pas assez de stère de bois");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 100)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
    if(livraisonjob[playerid] == 1)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfopetrol] < 50) return SendErrorMessage(playerid,"Il a pas assez de baril de pétrol");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(quantiterdejob[playerid] == 50 && livraisonjob[playerid] == 11)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 3)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfoviande] < 10) return SendErrorMessage(playerid,"Il a pas assez de caisse de viande");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 33)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 4)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfostockdock] < 10) return SendErrorMessage(playerid,"Il a pas assez de caisse des dock");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 44)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 5)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste] < 10) return SendErrorMessage(playerid,"Il a pas assez de caisse");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 55)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 6)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter] < 10) return SendErrorMessage(playerid,"Il a pas assez de caisse");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 66)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 7)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfostockminer] < 10) return SendErrorMessage(playerid,"Il a pas assez de caisse de roches");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 77)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 8)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic] < 10) return SendErrorMessage(playerid,"Il a pas assez de pièce d'électronique");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 88)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 9)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes] < 10) return SendErrorMessage(playerid,"Il a pas assez de pièce d'arme");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 99)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	if(livraisonjob[playerid] == 10)
    {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514)
	    {
	   		if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid))){ SendClientMessage(playerid,COLOR_RED,"* Vous n'avez pas la remorque!"); return 1; }
		    new stockjobinfoid;
		   	if(info_stockjobinfo[stockjobinfoid][stockjobinfomeuble] < 10) return SendErrorMessage(playerid,"Il a pas assez de meuble");
			SendEntrepriseMessage(playerid,"Chargement en cours");
      		TogglePlayerControllable(playerid, 0);
      		SetTimerEx("jobchargement", 10000, false, "d", playerid);
			return 1;
		}
		return 1;
	}
	if(livraisonjob[playerid] == 110)
	{
	    SetTimerEx("jobchargement", 10000, false, "d", playerid);
	    TogglePlayerControllable(playerid, 0);
	    return 1;
	}
	//lowrider
	/*if(InContest[playerid] == true) {
	    if(!IsPlayerInAnyVehicle(playerid)) return SendServerMessage(playerid, "Vous devez être dans un vehicule");
		if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid),GetVehicleComponentType(1087)) == 1087) {BeginContestForPlayer(playerid);}
		else return SendServerMessage(playerid, "Vous n'avez pas d'hydraulic");
	}*/
	return 1;
}
script jobchargement(playerid)
{
    new stockjobinfoid,moneyentrepriseid,facass = PlayerData[playerid][pFaction];
    if(livraisonjob[playerid] == 0)//bois
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfobois] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfobois] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 100;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de stère de bois. Aller au point de déchargement");
		SendEntrepriseMessage(playerid,"10 stère de bois chargé");
		SetPlayerCheckpoint(playerid,621.8337,-1529.5477,15.1812,12.0);
		stockjobinfosave(stockjobinfoid);
	    Updatestockbois();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 100)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
		CantidadTroncos();
	    TogglePlayerControllable(playerid, 1);
	    Updatestockmagasin();
	    return 1;
	}
	if(livraisonjob[playerid] == 1)//pétrole
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfopetrol] <= 50) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfopetrol] -= 50;
		quantiterdejob[playerid] = 50;
		livraisonjob[playerid] = 11;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de barils de pétrol. Aller au point de déchargement");
        SendEntrepriseMessage(playerid,"50 barils de pétrole chargé");
		SetPlayerCheckpoint(playerid,2494.6187,-2492.1155,13.2144,8.0);
		stockjobinfosave(stockjobinfoid);
		Updatepetrol();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 50 && livraisonjob[playerid] == 11)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 350$");
		FactionData[facass][factioncoffre] += 350;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator] += 200;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    TogglePlayerControllable(playerid, 1);
	    Updateessencegenerator();
	    return 1;
	}
	if(livraisonjob[playerid] == 3)//viande
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfoviande] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfoviande] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 33;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de viande. Aller au point de déchargement");
		SendEntrepriseMessage(playerid,"10 caisse de viande chargé");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		stockjobinfosave(stockjobinfoid);
		Updatestockviande();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 33)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 4)//caisse de dock
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfostockdock] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockdock] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 44;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de caisse des docks. Aller au point de déchargement");
        SendEntrepriseMessage(playerid,"10 caisse chargé");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		stockjobinfosave(stockjobinfoid);
		Updatestockdock();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 44)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 5)//caisse de carriste
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 55;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de caisse des carriste. Aller au point de déchargement");
        SendEntrepriseMessage(playerid,"10 caisse chargé");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		stockjobinfosave(stockjobinfoid);
		Updatestockcariste();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 55)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 6)//caisse de manu
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 66;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de caisse de manutention. Aller au point de déchargement");
        SendEntrepriseMessage(playerid,"10 caisse chargé");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		stockjobinfosave(stockjobinfoid);
		Updatestocksorter();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 66)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 7)//miner
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfostockminer] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockminer] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 77;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de caisse de roches. Aller au point de déchargement");
        SendEntrepriseMessage(playerid,"10 roches chargé");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		stockjobinfosave(stockjobinfoid);
		Updatestockminer();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 77)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 8)//éclectro
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 88;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de caisse des carriste. Aller au point de déchargement");
        SendEntrepriseMessage(playerid,"10 pièce d'électronique chargé");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		stockjobinfosave(stockjobinfoid);
		Updateelectronic();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 88)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 9)//arme
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 99;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de caisse des armes. Aller au point de déchargement");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		SendEntrepriseMessage(playerid,"10 pièce d'armes chargé");
		stockjobinfosave(stockjobinfoid);
		Updatestockinfoarme();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 99)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	if(livraisonjob[playerid] == 10)//meuble
	{
	    if(info_stockjobinfo[stockjobinfoid][stockjobinfomeuble] <= 10) return SendEntrepriseMessage(playerid,"Il n'a pas assez de stock pour faire la livraison.");
		info_stockjobinfo[stockjobinfoid][stockjobinfomeuble] -= 10;
		quantiterdejob[playerid] = 10;
		livraisonjob[playerid] = 110;
		DisablePlayerCheckpoint(playerid);
		SendEntrepriseMessage(playerid,"Votre vehicule est chargé de meubles. Aller au point de déchargement");
		SetPlayerCheckpoint(playerid,2459.7974,-2116.2842,13.5530,10.0);
		SendEntrepriseMessage(playerid,"10 meubles chargé");
		stockjobinfosave(stockjobinfoid);
		Updatestockmeuble();
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	if(quantiterdejob[playerid] == 10 && livraisonjob[playerid] == 110)
	{
		SendEntrepriseMessage(playerid,"Chargement terminer veuiller retourné au dépot");
	    SendEntrepriseMessage(playerid,"Votre entreprise a gagné 200$");
		FactionData[facass][factioncoffre] += 200;
		Faction_Save(facass);
	    info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] += 10;
	    DisablePlayerCheckpoint(playerid);
	    quantiterdejob[playerid] = 0;
	    livraisonjob[playerid] = -1;
		moneyentreprisesave(moneyentrepriseid);
	    stockjobinfosave(stockjobinfoid);
	    Updatestockmagasin();
	    TogglePlayerControllable(playerid, 1);
	    return 1;
	}
	return 1;
}
script OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (IsPlayerNPC(playerid)) return 1;
	new vehicleid = GetPlayerVehicleID(playerid),facass = PlayerData[playerid][pFaction],reason;
	if (newstate == PLAYER_STATE_WASTED && PlayerData[playerid][pJailTime] < 1)
	{
	    /*for (new i = 34; i < 39; i ++) {
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	    }*/
		switch (GetEngineStatus(vehicleid))
		{
		    case false: PlayerTextDrawHide(playerid,PlayerData[playerid][pTextdraws][90]);
			case true: PlayerTextDrawShow(playerid,PlayerData[playerid][pTextdraws][90]);
		}
	    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][82]);
	    ShowHungerTextdraw(playerid, 0);
	    PlayerData[playerid][pHealth] = 100.0;
	    ResetWeapons(playerid);
	    ResetPlayer(playerid);
	    PlayerData[playerid][pKilled] = 1;
	    ReturnWeaponName(reason);
	    if (!PlayerData[playerid][pInjured])
		{
	        PlayerData[playerid][pInjured] = 1;
	        
	        PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
	    	PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
	    	GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
	    	GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);
			foreach (new i : Player)
			{
				new factionid = PlayerData[i][pFaction],Float:x, Float:y, Float:z;
				GetPlayerPos(playerid,x,y,z);
				if(FactionData[factionid][factionacces][1] == 1 ||FactionData[factionid][factionacces][2] == 1 || FactionData[factionid][factionacces][3] == 1 || FactionData[factionid][factionacces][7] == 1 || FactionData[factionid][factionacces][5] == 1 || FactionData[factionid][factionacces][4] == 1)
				{
				    SetFactionMarker(playerid, factionid, 0x00ffc5FF);
				    PlayAudioStreamForPlayer(i,"http://hubroleplay.net/assets/bipbip.mp3");
					SendFactionMessage(facass,COLOR_RED,"[CENTRAL] L'agent de police %s est à terre, une balise automatique a été activée.",ReturnName(playerid,0));
					break;
				}
			}
			if (0 <= reason <= 8 || 10 <= reason <= 15)
				SetTimerEx("TimerNotDeadYet",120000, false, "d", playerid);
		}
		else
		{
		    TextDrawHideForPlayer(playerid, gServerTextdraws[2]);
			PlayerData[playerid][pInjured] = 0;
			PlayerData[playerid][pHospital] = GetClosestHospital(playerid);
			//KillTimer(ElektrikbyLev(playerid));
		}
		if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
		{
		    SendClientMessage(PlayerData[playerid][pCallLine], COLOR_YELLOW, "[PHONE]:{FFFFFF} La ligne est morte...");
		    CancelCall(playerid);
		}
		if (PlayerData[playerid][pCarryCrate] != -1) {Crate_Drop(playerid);}
	}
	else if (oldstate == PLAYER_STATE_DRIVER)
	{
	    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
	        return RemoveFromVehicle(playerid);
	    for (new i = 84; i < 97; i ++)
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][82]);
		RemovePlayerAttachedObject(playerid, 6);
	}
	else if (newstate == PLAYER_STATE_DRIVER)
	{
		if (IsSpeedoVehicle(vehicleid)){
			TextDrawHideForPlayer(playerid,poker_background[0]);
			TextDrawHideForPlayer(playerid,poker_background[1]);
 	    	for (new i = 84; i < 92; i ++){
				PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
				PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][96]);
			}
		}
		if (FactionData[facass][factionacces][7] == 1 && GetVehicleModel(vehicleid) == 408 && CoreVehicles[vehicleid][vehTrash] > 0)
		{
		    new pointid = -1;
		    if ((pointid = GetClosestJobPoint(playerid, 7)) != -1)
		    {
			    PlayerData[playerid][pCP] = 1;
			    SetPlayerCheckpoint(playerid, JobData[pointid][jobPoint][0], JobData[pointid][jobPoint][1], JobData[pointid][jobPoint][2], 2.5);
		    	SendServerMessage(playerid, "Ce véhicule est chargé avec %d sacs de poubelles (point pour décharger).", CoreVehicles[vehicleid][vehTrash]);
		    }
		}
		if (FactionData[facass][factionacces][6] == 11 && IsLoadableVehicle(vehicleid) && CoreVehicles[vehicleid][vehLoads] > 0)
		{
		    if (PlayerData[playerid][pLoading])
		    {
				DisablePlayerCheckpoint(playerid);
				PlayerData[playerid][pLoading] = 0;
			}
			static string[64];
		    switch (CoreVehicles[vehicleid][vehLoadType])
			{
				case 1: format(string, sizeof(string), "~b~Charger:~w~ 24/7~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
		        case 2: format(string, sizeof(string), "~b~Charger:~w~ Armurerie~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
                case 3: format(string, sizeof(string), "~b~Charger:~w~ Vetement~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
                case 4: format(string, sizeof(string), "~b~Charger:~w~ Alimentation~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
                case 5: format(string, sizeof(string), "~b~Charger:~w~ Essence~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
                case 6: format(string, sizeof(string), "~b~Charger:~w~ Mobilier~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
                case 7: format(string, sizeof(string), "~b~Charger:~w~ Bar~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
                case 8: format(string, sizeof(string), "~b~Charger:~w~ Epicerie~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);
				case 9: format(string, sizeof(string), "~b~Charger:~w~ Quincaillerie~n~~b~Marchandise charger:~w~ %d/10", CoreVehicles[vehicleid][vehLoads]);

			}
		    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][82]);
		    PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][82], string);
		}
	    if (IsVehicleImpounded(vehicleid))
	    {
	        RemovePlayerFromVehicle(playerid);
	        SendErrorMessage(playerid, "Ce véhicule est à la fourrière et vous ne pouver plus l'utiliser.");
	    }
		else if (!IsEngineVehicle(vehicleid)) {SetEngineStatus(vehicleid, true);}
		else
		{
			if (!GetEngineStatus(vehicleid))
			{
			    new stringm[900],idk = Car_GetID(vehicleid);
  				format(stringm, sizeof(stringm), "Appuyez sur ~r~~k~~VEHICLE_FIREWEAPON_ALT~~w~ pour demarrer.~n~~n~Appuyer sur ~r~~k~~TOGGLE_SUBMISSIONS~~w~ pour les phares.~n~~n~Appuyer sur ~r~~k~~VEHICLE_LOOKLEFT~ ~w~ou ~r~~k~~VEHICLE_LOOKRIGHT~~w~ pour les clignotants");
				TSM(playerid, stringm, " ", 10000, 0x00000088, 20.0000, 110.000000, 130.000000);// 110 130
			    if (CarData[idk][carfuel] < 1)
	    			ShowPlayerFooter(playerid, "Il n'a pas d'~r~essence~w~ dans ce vehicule.");
				else if (ReturnVehicleHealth(vehicleid) <= 300)
	    			ShowPlayerFooter(playerid, "Ce vehicule est ~r~endomager~w~ et a besoin de reparation.");
			}
			if (IsDoorVehicle(vehicleid) && !Inventory_HasItem(playerid, "permis de conduire") && !PlayerData[playerid][pDrivingTest])
			{
   				SendClientMessage(playerid, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} vous conduisez sans permis.");
			}
		}
		SetPlayerArmedWeapon(playerid, 0);
	}
	if ((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && PlayerData[playerid][pPlayRadio])
	{
	    PlayerData[playerid][pPlayRadio] = 0;
	    StopAudioStreamForPlayer(playerid);
 	    for (new i = 84; i < 97; i ++)
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	}
	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	    if (PlayerData[playerid][pBoombox] != INVALID_PLAYER_ID)
	    {
	        PlayerData[playerid][pBoombox] = INVALID_PLAYER_ID;
			StopAudioStreamForPlayer(playerid);
	    }
	    if (IsEngineVehicle(vehicleid) && CoreVehicles[vehicleid][vehRadio])
	    {
	        static url[128];
			strunpack(url, CoreVehicles[vehicleid][vehURL]);
			StopAudioStreamForPlayer(playerid);
			PlayAudioStreamForPlayer(playerid, url);
			PlayerData[playerid][pPlayRadio] = 1;
		}
	    foreach (new i : Player) if (PlayerData[i][pSpectator] == playerid) {PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));}
		if (PlayerData[playerid][pInjured] == 1) {RemoveFromVehicle(playerid);}
	}
	if (newstate == PLAYER_STATE_PASSENGER)
	{
	    switch (GetPlayerWeapon(playerid))
	    {
	        case 22..33: SetPlayerArmedWeapon(playerid, GetPlayerWeapon(playerid));
			default: SetPlayerArmedWeapon(playerid, 0);
		}
	    if (GetVehicleModel(vehicleid) == 431 || GetVehicleModel(vehicleid) == 437)
	    {
            SetPlayerPos(playerid, 2022.0273, 2235.2402, 2103.9536);
            SetPlayerTime(playerid, 00,00);
			SetPlayerFacingAngle(playerid, 0);
            SetCameraBehindPlayer(playerid);
            SetPlayerInterior(playerid, 1);
	        IsInBus[playerid] = vehicleid;
	    }
	}
	else if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
	    foreach (new i : Player) if (PlayerData[i][pSpectator] == playerid) {
     		PlayerSpectatePlayer(i, playerid);
		}
		RemovePlayerAttachedObject(playerid, 6);
	}
	if (newstate == PLAYER_STATE_PASSENGER && IsPlayerInsideTaxi(playerid))
	{
	    new driverid = GetVehicleDriver(GetPlayerVehicleID(playerid));

	    PlayerData[playerid][pTaxiFee] = 5;
	    PlayerData[playerid][pTaxiTime] = 0;
	    PlayerData[playerid][pTaxiPlayer] = driverid;

	    SendServerMessage(driverid, "%s est entrée dans votre taxi.", ReturnName(playerid, 0));
		SendServerMessage(playerid, "Vous êtes entrée dans le taxi de %s.", ReturnName(driverid, 0));
	}
 	if (oldstate == PLAYER_STATE_PASSENGER && PlayerData[playerid][pTaxiTime] != 0 && PlayerData[playerid][pTaxiPlayer] != INVALID_PLAYER_ID)
	{
	    LeaveTaxi(playerid, PlayerData[playerid][pTaxiPlayer]);
	}
	//camera helico
	if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT) // vérifier si le joueur était dans un véhicule
    {
        if(GetPVarInt( playerid, "ThermalActive" ) == 1) // Vérification si le joueur possède thermale active
    	{
            THERMALOFF( playerid ); // Si le joueur quitte véhicule nous avons mis son mode thermique off
     	}
    }
    //limitation de vitesse sur un véhicule abimer
    if( newstate == PLAYER_STATE_DRIVER )
	{
	    new temp;
	    temp = GetVehicleModel( GetPlayerVehicleID( playerid ) );
	    BE_Play_Check[ playerid ] = true;
	    for(new i; i != sizeof( BE_Bad_Vehs ); i++ )
	    {
	        if( temp == BE_Bad_Vehs[ i ] )
	        {
	            BE_Play_Check[ playerid ] = false;
	            break;
	        }
	    }
	}
	if( oldstate == PLAYER_STATE_DRIVER )
	{
	    BE_Play_Check[ playerid ] = false;
	}
    //vole veh
    if ((oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) && TrafiqueFilsTimer[playerid] > 0)
	{
	    KillTimer(TrafiqueFilsKillTimer[playerid]);
        TrafiqueFilsTimer[playerid] = 0;
        ShowPlayerFooter(playerid, "Le trafique a été annulé.");
	}
	if(newstate == PLAYER_STATE_DRIVER) {
	    pvehicleid[playerid] = GetPlayerVehicleID(playerid);
	    pmodelid[playerid] = GetVehicleModel(pvehicleid[playerid]);
	}
	else {
	    pvehicleid[playerid] = 0;
	    pmodelid[playerid] = 0;
	}
	return 1;
}
script OnPlayerUpdate(playerid)
{
	new zping = GetPlayerPing(playerid),Float:animX, Float:animY, Float:animZ,anim = GetPlayerAnimationIndex(playerid),serveursettinginfoid;
	if(zping >= 1500)
	{
		SendErrorMessage(playerid,"Vous avez été kick du serveur ping trop élevé");
		KickEx(playerid);
	}
	if (IsPlayerInRangeOfPoint(playerid, 200.0,2706.5154,-1801.9463,422.8205) && event == 0)
    {
        SendAdminAlert(COLOR_LIGHTRED,"%s est dans une place a event.",ReturnName(playerid, 0));
		if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 1)
		{
			SetPlayerPos(playerid,2096.7385, -1687.4127, 13.4706);
			SetPlayerFacingAngle(playerid,342.7732);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 1);
		}
		else if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 2)
		{
			SetPlayerPos(playerid,-1604.3302,721.8452,11.7487);
			SetPlayerFacingAngle(playerid,358.4156);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 1);
		}
		else if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 3)
		{
			SetPlayerPos(playerid,2476.6553,1881.8040,9.7135);
			SetPlayerFacingAngle(playerid,358.4156);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 1);
		}
		else if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 5)
		{
			SetPlayerPos(playerid,2403.1904,-1414.2330,4.5730);
			SetPlayerFacingAngle(playerid,358.4156);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			TogglePlayerControllable(playerid, 1);
		}
		SendServerMessage(playerid,"Tu a été déplacée car tu était dans une zone a event");
        return 1;
    }
	GetPlayerPos(playerid, animX, animY, animZ);
	if(GetTickCount() - armedbody_pTick[playerid] > 113){ //prefix check itter
		new weaponid[13],weaponammo[13],pArmedWeapon;
		pArmedWeapon = GetPlayerWeapon(playerid);
		GetPlayerWeaponData(playerid,1,weaponid[1],weaponammo[1]);
		GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
		GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
		GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
		if(weaponid[1] && weaponammo[1] > 0){
			if(pArmedWeapon != weaponid[1]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,10)){
					SetPlayerAttachedObject(playerid,10,GetWeaponModel(weaponid[1]),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,10)){
					RemovePlayerAttachedObject(playerid,10);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,10)){
			RemovePlayerAttachedObject(playerid,10);
		}
		if(weaponid[2] && weaponammo[2] > 0){
			if(pArmedWeapon != weaponid[2]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,7)){
					SetPlayerAttachedObject(playerid,7,GetWeaponModel1(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,7)){
					RemovePlayerAttachedObject(playerid,7);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,7)){
			RemovePlayerAttachedObject(playerid,7);
		}
		if(weaponid[4] && weaponammo[4] > 0){
			if(pArmedWeapon != weaponid[4]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,8)){
					SetPlayerAttachedObject(playerid,8,GetWeaponModel1(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,8)){
					RemovePlayerAttachedObject(playerid,8);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,8)){
			RemovePlayerAttachedObject(playerid,8);
		}
		if(weaponid[5] && weaponammo[5] > 0){
			if(pArmedWeapon != weaponid[5]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,9)){
					SetPlayerAttachedObject(playerid,7,GetWeaponModel1(weaponid[5]),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,9)){
					RemovePlayerAttachedObject(playerid,9);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,9)){
			RemovePlayerAttachedObject(playerid,9);
		}
		armedbody_pTick[playerid] = GetTickCount();
	}
	if((anim >= 1538) && (anim <= 1542) && animZ > 5 && !IsPlayerSwimming(playerid))
	{
	    SetPlayerPos(playerid,2487.0728, -1670.6014, 1140.8185);
		TogglePlayerControllable(playerid, false);
		SendClientMessage(playerid, COLOR_LIGHTRED, "[Anti-Cheat] Vous avez était kick pour Fly Hack!!!");
		KickEx(playerid);
	}
	static str[64], id = -1, keys[3], vehicleid;
	if (PlayerData[playerid][pKicked])
		return 0;

	if (GetPlayerWeapon(playerid) > 1 && (PlayerData[playerid][pHoldWeapon] > 0 || PlayerData[playerid][pMining] > 0))
	    SetPlayerArmedWeapon(playerid, 0);

	if (IsPlayerInAnyVehicle(playerid))
		vehicleid = GetPlayerVehicleID(playerid);
	else
	    vehicleid = INVALID_VEHICLE_ID;

	GetPlayerKeys(playerid, keys[0], keys[1], keys[2]);
	if (GetPlayerWeapon(playerid) != PlayerData[playerid][pWeapon])
	{
	    PlayerData[playerid][pWeapon] = GetPlayerWeapon(playerid);

		if (PlayerData[playerid][pWeapon] >= 1 && PlayerData[playerid][pWeapon] <= 45 && PlayerData[playerid][pWeapon] != 40 && PlayerData[playerid][pWeapon] != 2 && PlayerData[playerid][pGuns][g_aWeaponSlots[PlayerData[playerid][pWeapon]]] != GetPlayerWeapon(playerid) && !PlayerHasTazer(playerid) && !PlayerHasflashball(playerid) && PlayerData[playerid][pRangeBooth] == -1 && PlayerData[playerid][pCharacter] > 0)
		{
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a été banni pour arme cheat (%s).", ReturnName(playerid, 0), ReturnWeaponName(PlayerData[playerid][pWeapon]));
			Log_Write("logs/cheat_log.txt", "[%s] %s was banned for weapon hacks (%s).", ReturnDate(), ReturnName(playerid), ReturnWeaponName(PlayerData[playerid][pWeapon]));

			Blacklist_Add(PlayerData[playerid][pIP], PlayerData[playerid][pUsername], "Anticheat", "Weapon Hacks");
			Kick(playerid);

			return 0;
		}
	}
	if (GetPlayerMoney(playerid) != PlayerData[playerid][pMoney])
	{
	    ResetPlayerMoney(playerid);
	    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	}
	if (GetPlayerScore(playerid) != PlayerData[playerid][pPlayingHours])
	{
		SetPlayerScore(playerid, PlayerData[playerid][pPlayingHours]);
	}
	if (PlayerData[playerid][pWaypoint])
	{
	    format(str, sizeof(str), "~b~Point:~w~ %s (%.2f metres)", PlayerData[playerid][pLocation], GetPlayerDistanceFromPoint(playerid, PlayerData[playerid][pWaypointPos][0], PlayerData[playerid][pWaypointPos][1], PlayerData[playerid][pWaypointPos][2]));
		PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][69], str);
	}
	if (PlayerData[playerid][pMaskOn])
	{
		if (!PlayerData[playerid][pHideTags])
	    {
            foreach (new i : Player) {
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
		    format(str, sizeof(str), "Masque_#%d", PlayerData[playerid][pMaskID]);

	        PlayerData[playerid][pHideTags] = 1;
	        PlayerData[playerid][pNameTag] = CreateDynamic3DTextLabel(str, COLOR_WHITE, 0.0, 0.0, 0.2, 8.0, playerid, INVALID_VEHICLE_ID, 0, -1, -1);
	    }
	}
	if (!PlayerData[playerid][pMaskOn] && PlayerData[playerid][pHideTags])
	{
	    foreach (new i : Player) {
			ShowPlayerNameTagForPlayer(i, playerid, 1);
		}
		ResetNameTag(playerid);
	}
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    if (IsSpeedoVehicle(vehicleid))
	    {
		    static Float:fDamage,Float:fSpeed,Float:fVelocity[3];
			new speed = GetPlayerVehicleSpeed(playerid),kilo[96];
	  		GetVehicleHealth(vehicleid, fDamage);
	  		GetVehicleVelocity(vehicleid, fVelocity[0], fVelocity[1], fVelocity[2]);
	  		fDamage = floatdiv(1000 - fDamage, 10) * 1.33334;  // 1.42999;
 	  		fSpeed = floatmul(floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])), 180.0);
			if (fDamage < 0.0) fDamage = 0.0;
			else if (fDamage > 100.0) fDamage = 100.0;
			format(str, sizeof(str), "%.0f Km/h", fSpeed);
			PlayerTextDrawSetString(playerid,PlayerData[playerid][pTextdraws][88], str);
 			new idk = Car_GetID(vehicleid);
 			if(CarData[idk][carvie]  < 500) {PlayerTextDrawShow(playerid,PlayerData[playerid][pTextdraws][95]);}
 			if(CarData[idk][carvie]  > 501) {PlayerTextDrawHide(playerid,PlayerData[playerid][pTextdraws][95]);}
			CarData[idk][carMetre] += (speed)/30;
		    if(CarData[idk][carMetre] > 999)
			{
				CarData[idk][carKilo] += 1;
				CarData[idk][carMetre] = 0;
			}
			if(arrlen(CarData[idk][carKilo]) == 1)
			{format(kilo,sizeof(kilo),"000000%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			if(arrlen(CarData[idk][carKilo]) == 2)
			{format(kilo,sizeof(kilo),"00000%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			if(arrlen(CarData[idk][carKilo]) == 3)
			{format(kilo,sizeof(kilo),"0000%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			if(arrlen(CarData[idk][carKilo]) == 4)
			{format(kilo,sizeof(kilo),"000%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			if(arrlen(CarData[idk][carKilo]) == 5)
			{format(kilo,sizeof(kilo),"00%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			if(arrlen(CarData[idk][carKilo]) == 6)
			{format(kilo,sizeof(kilo),"0%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			if(arrlen(CarData[idk][carKilo]) == 7)
			{format(kilo,sizeof(kilo),"%d~r~%d", CarData[idk][carKilo], CarData[idk][carMetre]/100);}
			format(str, sizeof(str), "%s", kilo);
            PlayerTextDrawSetString(playerid,PlayerData[playerid][pTextdraws][89], str);
	        format(str, sizeof(str), "Essence: %d%", CarData[idk][carfuel], '%');
            PlayerTextDrawSetString(playerid,PlayerData[playerid][pTextdraws][96], str);
		}
		for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, BarricadeData[i][cadePos][0], BarricadeData[i][cadePos][1], BarricadeData[i][cadePos][2]))
		{
			static tires[4];
			GetVehicleDamageStatus(vehicleid, tires[0], tires[1], tires[2], tires[3]);
			if (tires[3] != 1111) {
			    UpdateVehicleDamageStatus(vehicleid, tires[0], tires[1], tires[2], 1111);
			}
			break;
		}
        if(!IsABoat(vehicleid) || !IsAPlane(vehicleid) || !IsAHelicopter(vehicleid) || !IsABike(vehicleid) || !IsAVelo(vehicleid))
		{
			if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 230)
			{
				new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z+5);
                SendErrorMessage(playerid,"Suspicion de SpeedHack");
				KickEx(playerid);
				return 1;
			}
        }
        if(IsABike(vehicleid) || IsAVelo(vehicleid))
		{
			if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 200)
			{
				new Float:x, Float:y, Float:z;
                GetPlayerPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z+5);
                SendErrorMessage(playerid,"Suspicion de SpeedHack");
				KickEx(playerid);
				return 1;
			}
        }
	}
	switch (PlayerData[playerid][pHouseLights])
	{
	    case 0:
	    {
	        if ((id = House_Inside(playerid)) != -1 && !HouseData[id][houseLights])
			{
	        	PlayerData[playerid][pHouseLights] = true;
	            PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][62]);
	        }
	        else PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][62]);
	    }
	    case 1:
	    {
	        if ((id = House_Inside(playerid)) == -1 || (id != -1 && HouseData[id][houseLights]))
			{
	            PlayerData[playerid][pHouseLights] = false;
                PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][62]);
	        }
	    }
	}
	if (PlayerData[playerid][pDrinking] && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_SPRUNK && !IsPlayerInAnyVehicle(playerid)&& GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_WINE)
	{
 		DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
 		PlayerData[playerid][pDrinking] = 0;
	}
	if ((id = Speed_Nearest(playerid)) != -1 && GetPlayerSpeed(playerid) > SpeedData[id][speedLimit] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsEngineVehicle(vehicleid) && !PlayerData[playerid][pSpeedTime])
	{
	    if (!IsACruiser(vehicleid) && !IsABoat(vehicleid) && !IsAPlane(vehicleid) && !IsAHelicopter(vehicleid) && !IsAUrgentistev(vehicleid))
	    {
			new stockjobinfoid;
			if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return 0;
			//generateur
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 3;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 3;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 3;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 3;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 3;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
			if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
			stockjobinfosave(stockjobinfoid);
	 		new price = 100 + floatround(GetPlayerSpeed(playerid) - SpeedData[id][speedLimit]);
	   		format(str, sizeof(str), "Vitesse (%.0f/%.0f km/h)", GetPlayerSpeed(playerid), SpeedData[id][speedLimit]);
	        SetTimerEx("HidePlayerBox", 500, false, "dd", playerid, _:ShowPlayerBox(playerid, 0xFFFFFF66));

			if (Ticket_Add(playerid, price, str) != -1)
			{
	    		format(str, sizeof(str), "Vous avez recus une amende de ~r~%s $~w~ pour exces de vitesse.", FormatNumber(price));
	     		ShowPlayerFooter(playerid, str);
			}
			PlayerData[playerid][pSpeedTime] = 5;
		}
	}
	if (Detector_Nearest(playerid) != -1)
	{
		if (IsPlayerArmed(playerid) && gettime() > PlayerData[playerid][pDetectorTime])
		{
			PlayerData[playerid][pDetectorTime] = gettime() + 5;

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** Le détecteur de métal sonne. (( %s ))", ReturnName(playerid, 0));
			PlayerPlaySoundEx(playerid, 43000);
		}
	}
	//anti toit
	NoRoof(playerid);
	//ceinture
	if(IsPlayerInAnyVehicle(playerid) == 1 && SeatbeltStatus[playerid] == 0)
	{
		new Float:TempCarHealth;
		GetVehicleHealth(GetPlayerVehicleID(playerid), TempCarHealth);
		new Float:Difference = floatsub(CarHealth[playerid], TempCarHealth);
		if((floatcmp(CarHealth[playerid], TempCarHealth) == 1) && (floatcmp(Difference,100.0) == 1))
		{
		    Difference = floatdiv(Difference, 10.0);
		    new Float:OldHealth;
		    GetPlayerHealth(playerid, OldHealth);
		    SetPlayerHealth(playerid, floatsub(OldHealth, Difference));
		}
		CarHealth[playerid] = TempCarHealth;
	}
	else {CarHealth[playerid] = 0.0;}
	if(IsPlayerInAnyVehicle(playerid))
 	{
 		if(seb[playerid] > 0)
 		{
 			new vehid;
 			vehid = GetPlayerVehicleID(playerid);
 			if(GetVehicleSpeed(vehid) > seb[playerid])
 			{SetVehicleSpeed(vehid,seb[playerid]);}
 		}
 	}
 	//anti fuck
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new veh = GetPlayerVehicleID(playerid),Float:health;
		GetVehicleHealth(veh, health);
		if(health > 1100)
		{
		    //Log_Write("logs/carhp_log.txt", "[%s] La vie vehicule id %d avec le joueur %s a été supérieur a 1000 [%f].", ReturnDate(),veh,ReturnName(playerid,0),health);
			SetVehicleHealth(veh, 1000);
			return 1;
		}
	}
	if (Inventory_HasItem(playerid,"object contaminer"))
	{
	    SetPlayerDrunkLevel(playerid, 15000);
	    return 1;
	}
    new Float:stamina;
    if(!IsPlayerNPC(playerid))
    {
        if(sbtime[playerid] != gettime())
        {
			if(PlayerData[playerid][pparcouru] <= 5000 && PlayerData[playerid][pparcouru] >= 2001) {SetPlayerStaminaSubVal(playerid, 2.0);}
			if(PlayerData[playerid][pparcouru] <= 2000 && PlayerData[playerid][pparcouru] >= 1001) {SetPlayerStaminaSubVal(playerid, 5.0);}
			if(PlayerData[playerid][pparcouru] <= 1000 && PlayerData[playerid][pparcouru] >= 501) {SetPlayerStaminaSubVal(playerid, 10.0);}
			if(PlayerData[playerid][pparcouru] <= 500 && PlayerData[playerid][pparcouru] >= -500) {SetPlayerStaminaSubVal(playerid, 15.0);}
			if(PlayerData[playerid][pparcouru] <= 0 && PlayerData[playerid][pparcouru] >= -501) {SetPlayerStaminaSubVal(playerid, 25.0);}
			if(PlayerData[playerid][pparcouru] <= -502 && PlayerData[playerid][pparcouru] >= -1500) {SetPlayerStaminaSubVal(playerid, 30.0);}
			if(PlayerData[playerid][pparcouru] <= -1501 && PlayerData[playerid][pparcouru] >= -2000) {SetPlayerStaminaSubVal(playerid, 35.0);}
			if(PlayerData[playerid][pparcouru] <= -2001 && PlayerData[playerid][pparcouru] >= -3000) {SetPlayerStaminaSubVal(playerid, 35.0);}
			if(PlayerData[playerid][pparcouru] <= -3001 && PlayerData[playerid][pparcouru] >= -4000) {SetPlayerStaminaSubVal(playerid, 40.0);}
			if(PlayerData[playerid][pparcouru] <= -4001 && PlayerData[playerid][pparcouru] >= -5000) {SetPlayerStaminaSubVal(playerid, 45.0);}
            GetPlayerStamina(playerid, stamina);
            SetPlayerProgressBarValue(playerid, StaminaBar[playerid], stamina);
            sbtime[playerid] = gettime();
        }
    }
	return 1;
}
script OnPlayerConnect(playerid)
{
    //Actived[playerid] = 0;
    IsInBus[playerid] = 0;
    SetPVarInt(playerid, "PType", 0);
    SetPVarInt(playerid, "PColor", 0);
    if(IsPlayerNPC(playerid)) return 1;
	if(IsPlayerNPC(playerid)) {
	    new ip_addr_npc[64+1];
	    new ip_addr_server[64+1];
	    GetServerVarAsString("bind",ip_addr_server,64);
	    GetPlayerIp(playerid,ip_addr_npc,64);
		if(!strlen(ip_addr_server)) {
		    ip_addr_server = "127.0.0.1";
		}
		if(strcmp(ip_addr_npc,ip_addr_server,true) != 0) {
		    printf("NPC: Got a remote NPC connecting from %s and I'm kicking it.",ip_addr_npc);
		    Kick(playerid);
		    return 0;
		}
	}
	/*if ((GetTickCount() - PlayerData[playerid][pLeaveTime]) < 2000 && !strcmp(ReturnIP(playerid), PlayerData[playerid][pLeaveIP]))
	{
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s (%s) a été kick pour hacks possibles.", ReturnName(playerid), ReturnIP(playerid));
	    Kick(playerid);
		return 1;
	}*/
	ResetPlayerMoney(playerid);
	ResetPlayerWeapons(playerid);
	SetPlayerArmedWeapon(playerid, 0);
	ResetEditing(playerid);
	PreloadAnimations(playerid);
	new serveursettinginfoid;
	if (g_ServerRestart) {
		TextDrawShowForPlayer(playerid, gServerTextdraws[3]);
	}
	for (new i = 0; i != MAX_PLAYER_ATTACHED_OBJECTS; i ++) {
	    RemovePlayerAttachedObject(playerid, i);
	}
    for (new i = 0; i < 24; i ++)
	{
	    PrisonData[prisonCellOpened][i] = true;
		SetDynamicObjectPos(PrisonData[prisonCells][i], PrisonCells[i][0], PrisonCells[i][1] + 1.6, PrisonCells[i][2]);
	}
	//remove inverting
	if(info_serveursettinginfo[serveursettinginfoid][settingvilleactive] == 5) {RemoveBuildingForPlayer(playerid, -1, 0.0, 0.0, 0.0, 6000.0);}
    RemoveBuildingForPlayer(playerid, 1345, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1294, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1352, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 2753, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 2369, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1514, 0.0, 0.0, 0.0, 6000.0);
	RemoveBuildingForPlayer(playerid, 1676, 0.0, 0.0, 0.0, 6000.00);
	RemoveBuildingForPlayer(playerid, 3465, 0.0, 0.0, 0.0, 6000.00);
	RemoveBuildingForPlayer(playerid, 1686, 0.0, 0.0, 0.0, 6000.00);
 	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 	0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 956, 	0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1340, 0.0, 0.0, 0.0, 6000.00);
	RemoveBuildingForPlayer(playerid, 1280, 0.0, 0.0, 0.0, 6000.0);
	//fin remove
	CancelSelectTextDraw(playerid);
	GetPlayerIp(playerid, PlayerData[playerid][pIP], 16);
	GetPlayerName(playerid, PlayerData[playerid][pUsername], MAX_PLAYER_NAME + 1);
	CreateTextDraws(playerid);
	ResetStatistics(playerid);
	/*new str12[128];
	format(str12, sizeof(str12), "SELECT * FROM `blacklist` WHERE `Username` = '%s' OR `IP` = '%s'", ReturnName(playerid), PlayerData[playerid][pIP]);
	mysql_tquery(g_iHandle, str12, "OnQueryFinished", "dd", playerid, THREAD_BAN_LOOKUP);*/
	//job meuble
	SetPVarInt(playerid,"Trabajando",0);
	SetPVarInt(playerid,"TomoCarpintero",0);
	SetPVarInt(playerid,"MueblesCreados",0);
	//lowrider
	InContest[playerid] = false;
	CurrentNote[playerid] = -1;
	PointGagner[playerid] = 0;
	JustJoined[playerid] = false;
	organisateur[playerid] = 0;
	//bowling
    BowlingMinutes[playerid] = 0;
    BowlingSeconds[playerid] = 0;
	BowlingStatus[playerid] = F_BOWLING_THROW;
	AbleToPlay[playerid] = 0;
	PlayersBowlingScore[playerid] = 0;
	PinsLeft[1][playerid] = 0;
	//discord chat
	PlayerData[playerid][pDiscordChat] = 0;
	//tunning
    pvehicleid[playerid] = GetPlayerVehicleID(playerid);
	pvehicleid[playerid] = 0;
    pmodelid[playerid] = 0;
	return 1;
}
script OnPlayerFinishedDownloading(playerid, virtualworld)
{
    new str[128];
	format(str, sizeof(str), "SELECT * FROM `blacklist` WHERE `Username` = '%s' OR `IP` = '%s'", ReturnName(playerid), PlayerData[playerid][pIP]);
	mysql_tquery(g_iHandle, str, "OnQueryFinished", "dd", playerid, THREAD_BAN_LOOKUP);
	return 1;
}
script OnPlayerDisconnect(playerid, reason)
{
	PlayerData[playerid][pLeaveTime] = GetTickCount();
	format(PlayerData[playerid][pLeaveIP], 16, PlayerData[playerid][pIP]);
    PlayerData[playerid][pLogged] = 0;
 	TerminateConnection(playerid);
 	new facass = PlayerData[playerid][pFaction];
 	if (FactionData[facass][factionacces][1] == 1) {cop_nbrCops--;}
 	if (FactionData[facass][factionacces][4] == 1) {swat_nbrCops--;}
 	if (FactionData[facass][factionacces][6] == 1) {mercco--;}
 	Zavod[playerid] = 0;
	ZavodIn[playerid] = 0;
	ZavodIn1[playerid] = 0;
	IsInBus[playerid] = 0;
	PlayerData[playerid][pDiscordChat] = 0;
    new nameStr[MAX_PLAYER_NAME],string[96];
    GetPlayerName(playerid,nameStr,sizeof(nameStr));
    //DestroyTextDraws(playerid);
	if(!IsPlayerNPC(playerid))
	{
		switch(reason)
	    {
	        case 0: format(string, sizeof(string), "* %s a quitté le serveur (Crash).", nameStr);
	        case 1: format(string, sizeof(string), "* %s a quitté le serveur.", nameStr);
	        case 2: format(string, sizeof(string), "* %s a quitté le serveur (Kick/Ban).",  nameStr);
	    }
		SendNearbyMessage(playerid,30.0,COLOR_HOSPITAL,string);
	}
	//bowling
    BowlingMinutes[playerid] = 0;
    BowlingSeconds[playerid] = 0;
	BowlingStatus[playerid] = F_BOWLING_THROW;
	AbleToPlay[playerid] = 0;
	KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
 	BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
 	if(PlayersBowlingRoad[playerid]==0)
  	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Allée 1{008800} ]\n Vide");
		DestroyPins(0);
  	}
	else if(PlayersBowlingRoad[playerid]==1)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Allée 2{008800} ]\n Vide");
		DestroyPins(1);
	}
	else if(PlayersBowlingRoad[playerid]==2)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Allée 3{008800} ]\n Vide");
		DestroyPins(2);
  	}
  	else if(PlayersBowlingRoad[playerid]==3)
   	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Allée 4{008800} ]\n Vide");
		DestroyPins(3);
   	}
	else if(PlayersBowlingRoad[playerid]==4)
	{
		UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Allée 5{008800} ]\n Vide");
		DestroyPins(4);
	}
 	PlayersBowlingRoad[playerid] = ROAD_NONE;
 	PinsLeft[1][playerid] = 0;
 	//gym
	REST_PLAYER(playerid);
	HideAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[playerid]);
	TextDrawHideForPlayer( playerid, gym_des[playerid]);
	TextDrawHideForPlayer( playerid, gym_deslabel[playerid]);
	TextDrawHideForPlayer( playerid, gym_repslabel[playerid]);
	//horse
	MoneyBet[playerid] = 0;
	BetOnHorse[playerid] = 0;
	Watching[playerid] = 0;
	//roulette
	Actived[playerid] = 0;
    //lowrider
	InContest[playerid] = false;
	CurrentNote[playerid] = -1;
	PointGagner[playerid] = 0;
	JustJoined[playerid] = false;
	organisateur[playerid] = 0;
	//stamina
	DestroyPlayerProgressBar(playerid, StaminaBar[playerid]);
	DestroyPlayerProgressBar(playerid, PlayerData[playerid][FaimBar]);
	DestroyPlayerProgressBar(playerid, PlayerData[playerid][SoifBar]);
	DestroyPlayerProgressBar(playerid, PlayerData[playerid][BrasBar]);
	DestroyPlayerProgressBar(playerid, PlayerData[playerid][JambesBar]);
    return 1;
}
script OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(PlayerData[playerid][pAdmin] > 0 || PlayerData[playerid][pTester] > 0)
	{
		SendServerMessage(playerid,"Vous avez clicker sur %s",ReturnName(clickedplayerid,0));
		AdminTarget[playerid] = clickedplayerid;
		Dialog_Show(playerid,InfomationClickedPlayer,DIALOG_STYLE_LIST,"Action a faire sur ce joueur",menuclick3,"Valider","Annuler");
	}
	else return SendErrorMessage(playerid, "Vous n'êtes pas autorisé.");
	return 1;
}
script OnGameModeInit()
{
	//partie fs oubliger
	/*SendRconCommand("unloadfs skins");
	SendRconCommand("loadfs skins");*/
	SendRconCommand("unloadfs pool");
    SendRconCommand("loadfs pool");
    SendRconCommand("unloadfs soccer");
    SendRconCommand("loadfs soccer");
    //fin des fs oubliger
    CA_Init();
    //zombie + radiation
	ZombiesTimer = SetTimer("CreateZombies", 50, true);
	SetTimer("UpdateRadiation",5000, 1);
	//fin zombie
    AntiDeAMX();
	static arrVirtualWorlds[2000]; /*id = -1;*/
	WeatherRotator();
	SQL_Connect();
	ManualVehicleEngineAndLights();
	new rcon[80];
	format(rcon, sizeof(rcon), "hostname %s", SERVER_NAME);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "weburl %s", SERVER_URL);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "language %s", LANGUAGE);
	SendRconCommand(rcon);
	SetGameModeText(SERVER_REVISION);
	SendRconCommand("ackslimit 5000");
	if (mysql_errno(g_iHandle) != 0)
	    return 0;
    mysql_tquery(g_iHandle, "SELECT * FROM `billboards`", "Billboard_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `houses`", "House_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `businesses`", "Business_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `dropped`", "Dropped_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `entrances`", "Entrance_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `cars`", "Car_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `jobs`", "Job_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `crates`", "Crate_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `plants`", "Plant_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `factions`", "Faction_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `arrestpoints`", "Arrest_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `gates`", "Gate_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `batiements`", "batiement_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `backpacks`", "Backpack_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `impoundlots`", "Impound_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `atm`", "ATM_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `garbage`", "Garbage_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `vendors`", "Vendor_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `gunracks`", "Rack_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `speedcameras`", "Speed_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `graffiti`", "Graffiti_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `detectors`", "Detector_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `caisses`", "caisse_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `actors`", "LoadActors", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `phonebook`", "phonebook_Load", "");
    SetModelPreviewRotation(18875, 90.0, 180.0, 0.0);
    SetModelPreviewRotation(2703, -105.0, 0.0, -15.0);
    SetModelPreviewRotation(2702, 90.0, 90.0, 0.0);
    SetModelPreviewRotation(2814, -90.0, 0.0, -90.0);
    SetModelPreviewRotation(2768, -15.0, 0.0, -160.0);
    SetModelPreviewRotation(19142, -20.0, -90.0, 0.0);
    SetModelPreviewRotation(1581, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(19792, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(2958, -10.0, -15.0, 0.0);
    SetModelPreviewRotation(1575, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(1577, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(1578, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(18634, 90.0, 90.0, 0.0);
    SetModelPreviewRotation(2043, 0.0, 0.0, 90.0);
    SetModelPreviewRotation(1484, -15.0, 30.0, 0.0);
    SetModelPreviewRotation(2226, 0.0, 0.0, 180.0);
	SetModelPreviewRotation(19792, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(19995, 0.0,0.0,180.0);
    SetModelPreviewRotation(1025, 0.0,0.0,90.0);
    SetModelPreviewRotation(1073, 0.0,0.0,90.0);
    SetModelPreviewRotation(1074, 0.0,0.0,90.0);
    SetModelPreviewRotation(1075, 0.0,0.0,90.0);
    SetModelPreviewRotation(1076, 0.0,0.0,90.0);
    SetModelPreviewRotation(1077, 0.0,0.0,90.0);
    SetModelPreviewRotation(1078, 0.0,0.0,90.0);
    SetModelPreviewRotation(1079, 0.0,0.0,90.0);
    SetModelPreviewRotation(1080, 0.0,0.0,90.0);
    SetModelPreviewRotation(1081, 0.0,0.0,90.0);
    SetModelPreviewRotation(1082, 0.0,0.0,90.0);
    SetModelPreviewRotation(1083, 0.0,0.0,90.0);
    SetModelPreviewRotation(1084, 0.0,0.0,90.0);
    SetModelPreviewRotation(1085, 0.0,0.0,90.0);
    SetModelPreviewRotation(1096, 0.0,0.0,90.0);
    SetModelPreviewRotation(1097, 0.0,0.0,90.0);
    SetModelPreviewRotation(1098, 0.0,0.0,90.0);
	for (new i = 0; i < sizeof(arrVirtualWorlds); i ++) {
	    arrVirtualWorlds[i] = i + 7000;
	}
	//ConnectNPC("Albert_Folker","Albert");
	//mapping oubliger
    vaultdoor = CreateDynamicObject(2634, 1435.35193, -980.29688, 984.21887, 0.00000, 0.00000, 179.04001,-1);
    Sphere[0] = CreateDynamicSphere(-1836.1292,45.6889,1445.9305, 0.5,-1); // Port?pour les bo?s ?1
	Sphere[1] = CreateDynamicSphere(-1833.8665,45.6885,1445.9305, 0.5,-1); // Port?pour les bo?s ?2
	Sphere[2] = CreateDynamicSphere(-1831.7159,45.6878,1445.9305, 0.5,-1); // Port?pour les bo?s ?3
	PrisonData[prisonDoors][0] = CreateDynamicObject(1495,1226.66210938,-1326.52929688,795.75000000,0.00000000,0.00000000,0.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
   	PrisonData[prisonDoors][1] = CreateDynamicObject(1495,1215.21997070,-1310.73999023,795.75000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonDoors][2] = CreateDynamicObject(1495,1226.76501465,-1345.71997070,795.73999023,0.00000000,0.00000000,0.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
	PrisonData[prisonCells][0] = CreateDynamicObject(19302,1205.69995117,-1328.09997559,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][1] = CreateDynamicObject(19302,1205.69995117,-1331.30004883,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][2] = CreateDynamicObject(19302,1205.69995117,-1331.30004883,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][3] = CreateDynamicObject(19302,1205.69995117,-1328.09997559,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][4] = CreateDynamicObject(19302,1215.30004883,-1328.09997559,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][5] = CreateDynamicObject(19302,1215.30004883,-1331.30004883,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][6] = CreateDynamicObject(19302,1215.30004883,-1331.30004883,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][7] = CreateDynamicObject(19302,1215.30004883,-1328.09997559,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][8] = CreateDynamicObject(19302,1215.30004883,-1334.50000000,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][9] = CreateDynamicObject(19302,1215.29980469,-1337.69921875,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][10] = CreateDynamicObject(19302,1215.30004883,-1340.90002441,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][11] = CreateDynamicObject(19302,1215.30004883,-1340.90002441,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][12] = CreateDynamicObject(19302,1215.30004883,-1337.69995117,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][13] = CreateDynamicObject(19302,1215.30004883,-1334.50000000,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][14] = CreateDynamicObject(19302,1205.69995117,-1334.50000000,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][15] = CreateDynamicObject(19302,1205.69995117,-1337.69995117,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][16] = CreateDynamicObject(19302,1205.69995117,-1340.90002441,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][17] = CreateDynamicObject(19302,1205.69995117,-1334.50000000,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][18] = CreateDynamicObject(19302,1205.69995117,-1337.69995117,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][19] = CreateDynamicObject(19302,1205.69995117,-1340.90002441,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][20] = CreateDynamicObject(19302,1215.30004883,-1344.09997559,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][21] = CreateDynamicObject(19302,1215.30004883,-1344.09997559,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][22] = CreateDynamicObject(19302,1205.69995117,-1344.09997559,800.50000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
    PrisonData[prisonCells][23] = CreateDynamicObject(19302,1205.69995117,-1344.09997559,797.00000000,0.00000000,0.00000000,90.00000000, PRISON_WORLD, 5, -1, 200.0, 100.0);
	for (new i = 0; i < 24; i ++) {
	    SetDynamicObjectMaterial(PrisonData[prisonCells][i], 0, 19302, "pd_jail_door02", "pd_jail_door02", 0xFF000000);
	    GetDynamicObjectPos(PrisonData[prisonCells][i], PrisonCells[i][0], PrisonCells[i][1], PrisonCells[i][2]);
	}
	CreateDynamicPickup(1239, 23, 1260.3976, -20.0215, 1001.0234);
	CreateDynamic3DTextLabel("[Cariste]\n{FFFFFF}Écriver /chargerboite pour commencer le chargement.", COLOR_YELLOW, 1260.3976, -20.0215, 1001.0234, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamicPickupEx(1239, 23, 438.3406,129.9807,1008.3976, 100.0, arrVirtualWorlds);
	CreateDynamic3DTextLabel("[Bureau de la fourriére]\n{FFFFFF}Écrivez /vfourriere pour libéré votre véhicule.", COLOR_DARKBLUE, 438.3406,129.9807,1008.3976, 10.0);
    CreateDynamicPickupEx(1239, 23, 288.2427,1874.4618,907.8959, 100.0, arrVirtualWorlds);
	//election
    CreateDynamic3DTextLabel("urne 1",0x9ACD32AA,-1836.1292,45.6889,1445.9305,15.0);
    CreateDynamic3DTextLabel("urne 2",0x9ACD32AA,-1833.8665,45.6885,1445.9305,15.0);
    CreateDynamic3DTextLabel("urne 3",0x9ACD32AA,-1831.7159,45.6878,1445.9305,15.0);
	//arme
    gunjob = CreateDynamicPickup(1275,2,2329.0986, 8.4453, 1026.4464,-1);
    //prison
	CreateDynamic3DTextLabel("San Andreas Prison", COLOR_DARKBLUE, 272.2939, 1388.8876, 11.1342, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
    CreateDynamicPickup(1559, 23, 1211.1923, -1354.3439, 797.4456);
	CreateDynamic3DTextLabel("Prison Yard", COLOR_DARKBLUE, 1211.1923, -1354.3439, 796.7456, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PRISON_WORLD, 5);
    CreateDynamicPickupEx(1239, 23, 288.2427,1874.4618,907.8959, 100.0, arrVirtualWorlds);
    //job boucher
    new stockjobinfoid,stringi1470[600],infostockviande = info_stockjobinfo[stockjobinfoid][stockjobinfoviande];
    format(stringi1470, sizeof(stringi1470), "{FFD700}Entrepôt de viande{FFFFFF}\nEn stock: {ff3300}%d morceaux de viande{ffffff}",infostockviande);
    CreateDynamicPickup(1239, 23, 958.9435,2172.8105,1011.0234);
    stockinfoboucherie = CreateDynamicObject(19805,962.8156, 2113.5750, 1011.7406,0.0000, 0.0000, 0.0000);
    SetDynamicObjectMaterialText(stockinfoboucherie, 0, stringi1470, OBJECT_MATERIAL_SIZE_256x128,"Arial", 20, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
    CreateDynamicPickup(1275,2,961.2307,2102.3398,1011.0276);
    CreateDynamic3DTextLabel("{FFFFFF}Pour commencé à travaillait Tapez {c7a24a}/commencerboucher\n{FFFFFF}Pour quitter votre travail Tapez {c7a24a}/quitterboucher",0xFFFFFFFC,961.2307,2102.3398,1011.0276+0.6,8.0);//Lugar
	//pool
    CreateDynamicPickup(338,23,511.8775,-76.5869,998.7578,-1,-1,-1);
    CreateDynamic3DTextLabel("{FFFFFF}Pour louer une queue de billard {c7a24a}/louerbillard\n{FFFFFF}Pour delouer la queue de billard {c7a24a}/delouerbillard",0xFFFFFFFC,511.8775,-76.5869,998.7578,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
    CreateDynamicPickup(1580,23,-212.8441,-1745.4980,675.7687,-1,-1,-1);
    CreateDynamic3DTextLabel("{FFFFFF}Pour vous soignez {c7a24a}/soins\n{FFFFFF}Au coût de 2500$",0xFFFFFFFC,-212.8441,-1745.4980,675.7687,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	//info prix job anpe
	new str15[900], str156[900], salairejobinfoid,cariste = info_salairejobinfo[salairejobinfoid][salairejobinfocariste],miner = info_salairejobinfo[salairejobinfoid][salairejobinfominer];
	new manutentionnaire = info_salairejobinfo[salairejobinfoid][salairejobinfomanutentionnaire],dock = info_salairejobinfo[salairejobinfoid][salairejobinfodock];
	new usineelectronic = info_salairejobinfo[salairejobinfoid][salairejobinfoelectronic],bucheron = info_salairejobinfo[salairejobinfoid][salairejobinfobucheron];
	new menuisier = info_salairejobinfo[salairejobinfoid][salairejobinfomenuisier],generateur = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur];
	new electricien = info_salairejobinfo[salairejobinfoid][salairejobinfoelectricien],arme = info_salairejobinfo[salairejobinfoid][salairejobinfoarme];
	new petrol = info_salairejobinfo[salairejobinfoid][salairejobinfopetrolier],boucher = info_salairejobinfo[salairejobinfoid][salairejobinfoboucher];
	infojobsalaire = CreateDynamicObject(19372, 308.36819, 140.13170, 1013.92572,   0.00000, 0.00000, 90.00000);
	infojobsalaire2 = CreateDynamicObject(19372, 312.24820, 140.13170, 1013.92572,   0.00000, 0.00000, 90.00000);
	format(str15, sizeof(str15),"{ffffff}Cariste: {ff3300}%d${ffffff}\nManutentionnaire: {ff3300}%d${ffffff}\nDock port: {ff3300}%d${ffffff}\nMiner: {ff3300}%d${ffffff}\nUsine electronic: {ff3300}%d${ffffff}\nBucheron: {ff3300}%d${ffffff}",cariste,manutentionnaire,dock,miner,usineelectronic,bucheron);
	SetDynamicObjectMaterialText(infojobsalaire, 0, str15, OBJECT_MATERIAL_SIZE_256x128,"Arial", 20, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	format(str156, sizeof(str156), "{ffffff}Menuisier: {ff3300}%d${ffffff}\nTechnicien generateur: {ff3300}%d${ffffff}\nElectricien: {ff3300}%d${ffffff}\nFabrication d'arme: {ff3300}%d${ffffff}\nPetrolier: {ff3300}%d${ffffff}\nBoucher: {ff3300}%d${ffffff}\nChasseur : A venir",menuisier,generateur,electricien,arme,petrol,boucher);
	SetDynamicObjectMaterialText(infojobsalaire2, 0, str156, OBJECT_MATERIAL_SIZE_256x128,"Arial", 20, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//stock job
	stockjobinfoload();
	//serveur setting
	serveursettinginfoload();
	//slot machine
	slotmachineload();
	//job usine
	brat[0] = CreateDynamicPickup(19135, 2, 2559.3230,-1287.3453,1044.1250);
    brat[1] = CreateDynamicPickup(19135, 2, 2551.1650,-1287.2174,1044.1250);
    brat[2] = CreateDynamicPickup(19135, 2, 2543.2117,-1287.3550,1044.1250);
    brat[3] = CreateDynamicPickup(19135, 2, 2543.0767,-1300.0945,1044.1250);
    brat[4] = CreateDynamicPickup(19135, 2, 2550.8789,-1300.0017,1044.1250);
    brat[5] = CreateDynamicPickup(19135, 2, 2558.8235,-1299.9015,1044.1250);
    brat[6] = CreateDynamicPickup(1575, 2, 2564.3374,-1292.8196,1044.1250);
    brat[8] = CreateDynamicPickup(1575, 2, 2533.9824,-1297.0844,1044.1250);
    brat[7] = CreateDynamicPickup(1275, 2, 2567.7590,-1281.4629,1044.1250);
    new str11[200],electronicstok = info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic];
    format(str11, sizeof(str11), "{FFD700}Entrepôt électronic{FFFFFF}\nEn stock: {ff3300}%d matériel électronic{ffffff}",electronicstok);
	stockinfousineelectronic = CreateDynamicObject(19805, 2652.9836, -1588.6438, 15.9040,   0.0000, 0.0000, -91.3800);
	SetDynamicObjectMaterialText(stockinfousineelectronic, 0, str11, OBJECT_MATERIAL_SIZE_256x128,"Arial", 18, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//job fabrication armes a faire
	new stringi17[900],armesstokc = info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes];
	stockinfoarme = CreateDynamicObject(19805, 2328.23804, 8.96500, 1027.65550,   0.00000, 0.00000, 0.00000);
    format(stringi17, sizeof(stringi17), "{FFD700}Entrepôt d'arme{FFFFFF}\nEn stock: {ff3300}%d armes{ffffff}",armesstokc);
    SetDynamicObjectMaterialText(stockinfoarme, 0, stringi17, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
    rabot[0] = CreateDynamicPickup(18635, 2, 2558.5774,-1291.0057,1044.1250);
    rabot[1] = CreateDynamicPickup(18635, 2, 2556.0806,-1291.0057,1044.1250);
    rabot[2] = CreateDynamicPickup(18635, 2, 2553.7920,-1291.0044,1044.1250);
    rabot[3] = CreateDynamicPickup(18635, 2, 2544.2935,-1291.0057,1044.1250);
    rabot[4] = CreateDynamicPickup(18635, 2, 2541.9478,-1291.0051,1044.1250);
    rabot[5] = CreateDynamicPickup(18635, 2, 2542.0269,-1295.8499,1044.1250);
    rabot[6] = CreateDynamicPickup(18635, 2, 2544.5146,-1295.8497,1044.1250);
    rabot[7] = CreateDynamicPickup(18635, 2, 2553.8198,-1295.8513,1044.1250);
    rabot[8] = CreateDynamicPickup(18635, 2, 2556.1992,-1295.8508,1044.1250);
    rabot[9] = CreateDynamicPickup(18635, 2, 2558.5471,-1295.8512,1044.1250);
    //job generator
    new stringi2[128];
	gen1 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral1];
	format(stringi2, sizeof(stringi2), "Pour commencer a travailler Tapez /gason\nGENERATEUR [N°1]\n\nStatut: {ff3300}Aucun service{ffffff}\n\n\nCarburant %d/300000",gen1);
	gen1text = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-956.9048,1943.4753,9.0000,15.0);
	genpickup[0] = CreateDynamicPickup(1239,23,-956.9048,1943.4753,9.0000,-1);
	format(stringi2, sizeof(stringi2), "Bénéfice du générateur [N°1]\n\n\n$%d",gen1m);
	gen1money = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-957.7098,1936.7723,9.0000,15.0);
	gen2 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral2];
	format(stringi2, sizeof(stringi2), "Pour commencer a travailler Tapez /gason\nGENERATEUR [N°2]\n\nStatut: {ff3300}Aucun service{ffffff}\n\n\nCarburant %d/300000",gen2);
	gen2text = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-956.9048,1921.7970,9.0000,15.0);
	genpickup[1] = CreateDynamicPickup(1239,23,-956.9048,1921.7970,9.0000,-1);
	format(stringi2, sizeof(stringi2), "Bénéfice du générateur [N°2]\n\n\n$%d",gen2m);
	gen2money = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-957.7279,1915.1571,9.0000,15.0);
	gen3 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral3];
	format(stringi2, sizeof(stringi2), "Pour commencer a travailler Tapez /gason\nGENERATEUR [N°3]\n\nStatut: {ff3300}Aucun service{ffffff}\n\n\nCarburant %d/300000",gen3);
	gen3text = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-956.9056,1900.1344,9.0000,15.0);
	genpickup[2] = CreateDynamicPickup(1239,23,-956.9056,1900.1344,9.0000,-1);
	format(stringi2, sizeof(stringi2), "Bénéfice du générateur [N°3]\n\n\n$%d",gen3m);
	gen3money = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-957.7267,1893.5416,9.0000,15.0);
	gen4 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral4];
	format(stringi2, sizeof(stringi2), "Pour commencer a travailler Tapez /gason\nGENERATEUR [N°4]\n\nStatut: {ff3300}Aucun service{ffffff}\n\n\nCarburant %d/300000",gen4);
	gen4text = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-956.9048,1878.6244,9.0000,15.0);
	genpickup[3] = CreateDynamicPickup(1239,23,-956.9048,1878.6244,9.0000,-1);
	format(stringi2, sizeof(stringi2), "Bénéfice du générateur [N°4]\n\n\n$%d",gen4m);
	gen4money = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-957.8751,1871.9320,9.0000,15.0);
	gen5 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral5];
	format(stringi2, sizeof(stringi2), "Pour commencer a travailler Tapez /gason\nGENERATEUR [N°5] \n\nStatut: {ff3300}Aucun service{ffffff}\n\n\nCarburant %d/300000",gen5);
	gen5text = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-956.9048,1856.8756,9.0000,15.0);
	genpickup[4] = CreateDynamicPickup(1239,23,-956.9048,1856.8756,9.0000,-1);
	format(stringi2, sizeof(stringi2), "Bénéfice du générateur [N°5] \n\n\n$%d",gen5m);
	gen5money = CreateDynamic3DTextLabel(stringi2,0xFFFF00FF,-957.6699,1850.3157,9.0000,15.0);
	threesecondtimer = SetTimer("ThreeSecondTimer", 3000, 1);
    //job petrolier
    forestJobPickUP = CreateDynamicPickup(1275,2,590.8901,1231.3318,11.7188);
    new stringi1[600],petrolstokc = info_stockjobinfo[stockjobinfoid][stockjobinfopetrol];
    format(stringi1, sizeof(stringi1), "{FFD700}Entrepôt de petrol{FFFFFF}\nEn stock: {ff3300}%d barils{ffffff}",petrolstokc);	stockinfopetrol = CreateDynamicObject(19805, 635.38892, 1243.29993, 13.19810,   0.00000, 0.00000, 119.94010);
	SetDynamicObjectMaterialText(stockinfopetrol, 0, stringi1, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
    //job electricien
    CreateDynamic3DTextLabel( "automatique.", COLOR_LEV, 817.2338,-65.2923,1000.7838, 8.0, -1,-1 );
	CreateDynamic3DTextLabel( "automatique.", COLOR_LEV, 821.8239,-65.3121,1000.7838, 8.0, -1,-1 );
	CreateDynamic3DTextLabel( "automatique.", COLOR_LEV, 826.4416,-65.3215,1000.7838, 8.0, -1,-1 );
	CreateDynamic3DTextLabel( "automatique.", COLOR_LEV, 831.1662,-65.3286,1000.7838, 8.0, -1,-1 );
    Elektrik[0] = CreateDynamicPickup(19134,2,817.2338,-65.2923,1000.7838);
	Elektrik[1] = CreateDynamicPickup(19134,2,821.8239,-65.3121,1000.7838);
	Elektrik[2] = CreateDynamicPickup(19134,2,826.4416,-65.3215,1000.7838);
	Elektrik[3] = CreateDynamicPickup(19134,2,831.1662,-65.3286,1000.7838);
	//job doc fortcarson
	port = CreateDynamicPickup(1275, 2, 2724.9541,-2574.8025,3.0000);
	new stringi40[600],infostockstockminer = info_stockjobinfo[stockjobinfoid][stockjobinfostockminer],infostockstockdock = info_stockjobinfo[stockjobinfoid][stockjobinfostockdock],infostockstockcariste = info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste];
    format(stringi40, sizeof(stringi40), "{FFD700}Entrepôt des docks{FFFFFF}\nEn stock: {ff3300}%d caisse{ffffff}",infostockstockdock);
	stockinfodock = CreateDynamicObject(19805, 2749.8098, -2549.7035, 15.2580,   0.00000, 0.00000,0.00000);
	SetDynamicObjectMaterialText(stockinfodock, 0, stringi40, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);	//job cariste stock
    format(stringi40, sizeof(stringi40), "{FFD700}Entrepôt de marchandises{FFFFFF}\nEn stock: {ff3300}%d caisse{ffffff}",infostockstockcariste);
	stockinfocariste = CreateDynamicObject(19805, 1285.1454, 7.5104, 1002.2719,   0.00000, 0.00000, 0.0000);
	SetDynamicObjectMaterialText(stockinfocariste, 0, stringi40, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//job miner stock
    format(stringi40, sizeof(stringi40), "{FFD700}Entrepôt de pierre{FFFFFF}\nEn stock: {ff3300}%d pierres{ffffff}",infostockstockminer);
	stockinfominer = CreateDynamicObject(19805, 829.43878, 862.52911, 13.33830,   0.00000, 0.00000, 23.34000);
	SetDynamicObjectMaterialText(stockinfominer, 0, stringi40, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//mission le pickup de la mission apres l,actor
	switch (random(30))
	{
	   	case 0: missionactor = CreateActor(179,2507.4971,-2043.9542,13.5500,172.2477);
	   	case 1: missionactor = CreateActor(179,2509.2068,-1978.2653,13.4334,105.5648);
	   	case 2: missionactor = CreateActor(179,1095.3033,-873.7767,43.3906,1.4719);
	   	case 3: missionactor = CreateActor(179,880.2112,-1381.2468,25.2025,269.2101);
	   	case 4: missionactor = CreateActor(179,2346.2256,-1239.5133,22.5000,0.5437);
	   	case 5: missionactor = CreateActor(179,984.6139,-1613.4885,13.4954,93.7949);
		case 6: missionactor = CreateActor(179,977.0787,-942.4401,41.1425,38.4210); // bot1
		case 7: missionactor = CreateActor(179,779.0912,-1717.4033,4.9766,72.3261); // bot2
		case 8: missionactor = CreateActor(179,1431.6185,-1095.8884,17.5793,332.3431); // bot3
		case 9: missionactor = CreateActor(179,1680.5024,-1238.6655,14.9538,312.8443); // bot4
		case 10: missionactor = CreateActor(179,2124.2429,-1194.6682,23.9642,87.6751); // bot5
		case 11: missionactor = CreateActor(179,2083.6416,-1023.6044,33.1627,151.9735); // bot6
		case 12: missionactor = CreateActor(179,2507.0671,-1471.7194,24.0394,280.6100); // bot7
		case 13: missionactor = CreateActor(179,1516.8875,-1506.0033,13.5547,324.2364); // bot8
		case 14: missionactor = CreateActor(179,2621.9009,-2057.9226,13.5500,178.9987); // bot9
		case 15: missionactor = CreateActor(179,2738.2170,-1829.5782,11.8430,351.1509); // bot10
		case 16: missionactor = CreateActor(179,2668.5574,-1539.2067,25.1203,195.6187); // bot11
		case 17: missionactor = CreateActor(179,2762.1509,-1285.7408,41.7197,225.5658); // bot12
		case 18: missionactor = CreateActor(179,2767.0271,-1192.7881,69.4097,357.0363); // bot13
		case 19: missionactor = CreateActor(179,2788.7820,-1467.7402,40.0625,321.8119); // bot14
		case 20: missionactor = CreateActor(179,2791.5862,-1079.5629,30.7188,48.8802); // bot15
		case 21: missionactor = CreateActor(179,2412.8145,-1208.6603,29.3274,2.2453); // bot16
		case 22: missionactor = CreateActor(179,2331.0620,-1336.5182,24.0639,203.7363); // bot17
		case 23: missionactor = CreateActor(179,1972.8481,-1304.1487,20.8297,224.8212); // bot18
		case 24: missionactor = CreateActor(179,1228.0179,-1889.8441,13.7815,28.0432); // bot19
		case 25: missionactor = CreateActor(179,1615.5521,-1779.6171,13.5315,111.6386); // bot20
		case 26: missionactor = CreateActor(179,1668.6542,-1641.1974,22.5251,319.7593); // bot22
		case 27: missionactor = CreateActor(179,1668.6469,-1632.4844,22.5217,204.6605); // bot23
		case 28: missionactor = CreateActor(179,1740.5454,-1540.5977,13.5511,311.0774); // bot24
		case 29: missionactor = CreateActor(179,1403.7306,-1298.5013,13.5460,236.3440); // bot25
	}
	missionactor1 = CreateActor(1, 350.6988,142.3713,5.5175,94.9310);
	switch (random(30))
	{
	   	case 0: missionactor2 = CreateActor(31,-2199.7209,-2338.7644,30.6250,77.9837);
	   	case 1: missionactor2 = CreateActor(31,-2054.5361,-2438.4902,30.6250,113.4559);
	   	case 2: missionactor2 = CreateActor(31,-1843.5271,-1627.6521,21.7677,129.3315);
	   	case 3: missionactor2 = CreateActor(31,-1620.3467,1420.2213,7.1734,132.55611);
		case 4: missionactor2 = CreateActor(31,-1743.5946,1540.8601,7.1875,4.2422); // pos 5
		case 5: missionactor2 = CreateActor(31,-1790.0234,1540.7908,7.1875,352.8316); // pos 6
		case 6: missionactor2 = CreateActor(31,-1835.5865,1540.7933,7.1875,12.6762); // pos 7
		case 7: missionactor2 = CreateActor(31,-2659.8215,1457.7629,49.5576,299.0931); // pos 8
		case 8: missionactor2 = CreateActor(31,-2237.3120,2475.0996,4.9844,182.0998); // pos 9
		case 9: missionactor2 = CreateActor(31,-2492.2644,2356.5688,10.2770,282.3647); // pos 10
		case 10: missionactor2 = CreateActor(31,-2529.0332,2352.6384,4.9844,0.2550); // pos 11
		case 11: missionactor2 = CreateActor(31,-2377.3723,2215.7188,4.9844,263.2643); // pos 12
		case 12: missionactor2 = CreateActor(31,-1723.6774,1243.2432,7.5469,65.8999); // pos 13
		case 13: missionactor2 = CreateActor(31,1516.8875,-1506.0033,13.5547,324.2364); // bot8
		case 14: missionactor2 = CreateActor(31,2621.9009,-2057.9226,13.5500,178.9987); // bot9
		case 15: missionactor2 = CreateActor(31,2738.2170,-1829.5782,11.8430,351.1509); // bot10
		case 16: missionactor2 = CreateActor(31,2668.5574,-1539.2067,25.1203,195.6187); // bot11
		case 17: missionactor2 = CreateActor(31,2762.1509,-1285.7408,41.7197,225.5658); // bot12
		case 18: missionactor2 = CreateActor(31,2767.0271,-1192.7881,69.4097,357.0363); // bot13
		case 19: missionactor2 = CreateActor(31,2788.7820,-1467.7402,40.0625,321.8119); // bot14
		case 20: missionactor2 = CreateActor(31,2791.5862,-1079.5629,30.7188,48.8802); // bot15
		case 21: missionactor2 = CreateActor(31,2412.8145,-1208.6603,29.3274,2.2453); // bot16
		case 22: missionactor2 = CreateActor(31,2331.0620,-1336.5182,24.0639,203.7363); // bot17
		case 23: missionactor2 = CreateActor(31,1972.8481,-1304.1487,20.8297,224.8212); // bot18
		case 24: missionactor2 = CreateActor(31,1228.031,-1889.8441,13.7815,28.0432); // bot19
		case 25: missionactor2 = CreateActor(31,1615.5521,-1779.6171,13.5315,111.6386); // bot20
		case 26: missionactor2 = CreateActor(31,1668.6542,-1641.1974,22.5251,319.7593); // bot22
		case 27: missionactor2 = CreateActor(31,1668.6469,-1632.4844,22.5217,204.6605); // bot23
		case 28: missionactor2 = CreateActor(31,1740.5454,-1540.5977,13.5511,311.0774); // bot24
		case 29: missionactor2 = CreateActor(31,1403.7306,-1298.5013,13.5460,236.3440); // bot25
	}
	//amendes
	actorvendeuramendes[0] = CreateActor(310,1566.5743,-1676.7462,16.1899,90);
	SetActorVirtualWorld(actorvendeuramendes[0],0);
	//permis
	actorvendeurpermis[0] = CreateActor(240,-2035.0946,-117.3694,1035.1719,272.2659);
	SetActorVirtualWorld(actorvendeurpermis[0], 7002);
	//mairie
	actorvendeurmairie[0] = CreateActor(150,-501.2239,296.4949,2001.5667,186.2353);
	SetActorVirtualWorld(actorvendeurmairie[0], 7005);
	//banque
	actorvendeurbanque[0] = CreateActor(194,1423.1012,-991.7617,996.1050,268.9151);
	actorvendeurbanque[1] = CreateActor(194,1423.1012,-993.9344,996.1050,267.3483);
	actorvendeurbanque[2] = CreateActor(194,1423.1013,-996.1403,996.1050,267.0350);
	actorvendeurbanque[3] = CreateActor(194,1423.1013,-998.3378,996.1050,268.6017);
	SetActorVirtualWorld(actorvendeurbanque[0], 7010);
	SetActorVirtualWorld(actorvendeurbanque[1], 7010);
	SetActorVirtualWorld(actorvendeurbanque[2], 7010);
	SetActorVirtualWorld(actorvendeurbanque[3], 7010);
	//anpe
	actorvendeuranpe[0] = CreateActor(290,314.2601,138.2111,1011.7645,164.0630);
	SetActorVirtualWorld(actorvendeuranpe[0],0);
	//vote
	HelpPic1[0] = CreateActor(76,-1836.1755,41.6856,1445.9305,308.5421);
	SetActorVirtualWorld(HelpPic1[0],7005);
	//bowling
	HelpPic1[1] = CreateActor(13,-1988.5654,416.6341,2.5010,175.9583);
	SetActorVirtualWorld(HelpPic1[1],7038);
	//bot commando
	piececaisse = CreateActor(111,2565.9041,-1216.2356,1026.1957,84.0109);//bot command crate
	soinbot = CreateActor(274,-196.3317, -1743.2111, 675.3954,96.44); //bot soins
	armespolice = CreateActor(267,1556.8833,-1659.7583,16.1909,270.0717);//bot arme jetter
	SetActorVirtualWorld(piececaisse, 7039);
	SetActorVirtualWorld(armespolice,0);
	SetActorVirtualWorld(soinbot,5003);
	for (new i = 0; i < sizeof(arrBoothPositions); i ++) {
	    CreateDynamic3DTextLabel("[Shooting Range]\n{FFFFFF}Press 'F' pour utiliser cette emplacement.", COLOR_DARKBLUE, arrBoothPositions[i][0], arrBoothPositions[i][1], arrBoothPositions[i][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 7);
	}
	for (new i = 0; i < sizeof(arrHospitalSpawns); i ++) {
	    CreateDynamicMapIcon(arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2], 22, 0);
		CreatePickup(1559, 23, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2] + 0.7);
		Create3DTextLabel("Hopital Général", COLOR_DARKBLUE, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2], 15.0, 0);
		CreatePickup(1240, 23, arrHospitalDeliver[i][0], arrHospitalDeliver[i][1], arrHospitalDeliver[i][2]);
		Create3DTextLabel("[Livraison d'hopital]\n{FFFFFF}/dechargermalade pour décharger le patient.", COLOR_DARKBLUE, arrHospitalDeliver[i][0], arrHospitalDeliver[i][1], arrHospitalDeliver[i][2], 15.0, 0);
	}
	// Textdraws
	gServerTextdraws[0] = TextDrawCreate(547.000000, 23.000000, "12:00 PM");
	TextDrawBackgroundColor(gServerTextdraws[0], 255);
	TextDrawFont(gServerTextdraws[0], 1);
	TextDrawLetterSize(gServerTextdraws[0], 0.360000, 1.499999);
	TextDrawColor(gServerTextdraws[0], -1);
	TextDrawSetOutline(gServerTextdraws[0], 1);
	TextDrawSetProportional(gServerTextdraws[0], 1);
	TextDrawSetSelectable(gServerTextdraws[0], 0);

	gServerTextdraws[1] = TextDrawCreate(500.000000, 6.000000, "Serveur ~r~ Roleplay");
	TextDrawBackgroundColor(gServerTextdraws[1], 255);
	TextDrawFont(gServerTextdraws[1], 1);
	TextDrawLetterSize(gServerTextdraws[1], 0.260000, 1.200000);
	TextDrawColor(gServerTextdraws[1], -1);
	TextDrawSetOutline(gServerTextdraws[1], 1);
	TextDrawSetProportional(gServerTextdraws[1], 1);
	TextDrawSetSelectable(gServerTextdraws[1], 0);

    gServerTextdraws[2] = TextDrawCreate(11.000000, 430.000000, "~r~Tu est blesser!~w~ /appeler 911 ou /mort.");
	TextDrawBackgroundColor(gServerTextdraws[2], 255);
	TextDrawFont(gServerTextdraws[2], 1);
	TextDrawLetterSize(gServerTextdraws[2], 0.300000, 1.100000);
	TextDrawColor(gServerTextdraws[2], -1);
	TextDrawSetOutline(gServerTextdraws[2], 1);
	TextDrawSetProportional(gServerTextdraws[2], 1);
	TextDrawSetSelectable(gServerTextdraws[2], 0);

    gServerTextdraws[3] = TextDrawCreate(237.000000, 409.000000, "~r~Serveur Restart:~w~ 00:00");
	TextDrawBackgroundColor(gServerTextdraws[3], 255);
	TextDrawFont(gServerTextdraws[3], 1);
	TextDrawLetterSize(gServerTextdraws[3], 0.480000, 1.300000);
	TextDrawColor(gServerTextdraws[3], -1);
	TextDrawSetOutline(gServerTextdraws[3], 1);
	TextDrawSetProportional(gServerTextdraws[3], 1);
	TextDrawSetSelectable(gServerTextdraws[3], 0);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(25.0);
	ShowPlayerMarkers(1);
	UpdateTime1();
	SetTimer("PlayerCheck", 1000, true);
	SetTimer("FuelUpdate", 50000, true);
	SetTimer("RefuelCheck", 500, true);
	SetTimer("LotteryUpdate", 2700000, true);
	SetTimer("MinuteCheck", 60000, true);
	SetTimer("WeatherRotator", 2400000, true);
	SetTimer("RandomFire", 1800000, true);
	//limitation de vitesse sur un véhicule abimer
	SetTimer("BadEngine", 500, true);
	SetTimer("SystemPolomka",60000,1);
	SetTimer("OnUnoccupiedVehicleUpdate",3000,1);
	SetTimer("Timephone",60000*15,1);
	SetTimer("GameTimeTimeTimer2",300000, 0);
	//job meuble
	new stringi147[600],infostockmeuble = info_stockjobinfo[stockjobinfoid][stockjobinfomeuble];
    format(stringi147, sizeof(stringi147), "{FFD700}Entrepôt de meuble{FFFFFF}\nEn stock: {ff3300}%d meuble{ffffff}",infostockmeuble);
    CreateDynamicPickup(1239,2,1603.2142, -1811.9705, 1013.4863,-1);
    stockinfomeublemenuiserie = CreateDynamicObject(19805,1604.7317, -1806.9548, 1014.6152,   0.00000, 0.00000, 90.000);
    SetDynamicObjectMaterialText(stockinfomeublemenuiserie, 0, stringi147, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//carpintero
	new stringi20[600],infostockboismeuble = info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble];
    format(stringi20, sizeof(stringi20), "{FFD700}Entrepôt de bois{FFFFFF}\nEn stock: {ff3300}%d bois{ffffff}",infostockboismeuble);
	stockinfoboismenuiserie = CreateDynamicObject(19805,1604.7517, -1814.6948, 1014.6152,   0.00000, 0.00000, 90.000);
    SetDynamicObjectMaterialText(stockinfoboismenuiserie, 0, stringi20, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	//carpintero = table de travail
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1607.6732, -1815.0839, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1612.6718, -1814.9323, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1617.1953, -1815.0953, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1622.8530, -1816.1132, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1623.4221, -1806.5026, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1617.3716, -1807.2134, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1612.2001, -1807.2498, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{c7a24a}Cliquez pour fabriquer des meubles\n{FFFFFF}¡D'abord, vous devez prendre du bois!",0xFFFFFFFC,1607.5315, -1807.3160, 1012.9468+0.6,4.0); //Terminar
	CreateDynamic3DTextLabel("{FFFFFF}Pour commencé à travaillait taper {c7a24a}/commencermeuble\n{FFFFFF}Pour quitter le job taper {c7a24a}/quittermeuble",0xFFFFFFFC,1603.2142, -1811.9705, 1013.4863+0.6,8.0);//Lugar
	moneyentrepriseload();
	gouvernementinfoload();
	salairejobinfoload();
	//tuningload();
	//cv
	cvjournalisteidload();
	cvlivraisonbizidload();
	cvmairieidload();
	cvmecanozone3idload();
	cvmecanozone4idload();
	cvpoliceidload();
	cvswatidload();
	cvtaxiidload();
	cvvendeurrueidload();
	cvurgentisteidload();
	salairemairieload();
	salairefbiload();
	salairepoliceload();
	salaireswatload();
	salaireurgentisteload();
	//casino fonctionne pas encore
	CreateCasinoMachine(CASINO_MACHINE_POKER,-243.57640,-19.74020,1003.98541,0.00000,0.00000,180.00000);
	CreateCasinoMachine(CASINO_MACHINE_POKER,-239.31641,-19.74020,1003.98541,0.00000,0.00000,180.00000);
	CreateCasinoMachine(CASINO_MACHINE_POKER,-231.48830,-13.06800,1003.98541,0.00000,0.00000,-90.00000);
	CreateCasinoMachine(CASINO_MACHINE_POKER,-231.48830,-17.30800,1003.98541,0.00000,0.00000,-90.00000);
	//afk
	new serveursettinginfoid;
	AFKActiver = info_serveursettinginfo[serveursettinginfoid][settingafkactive];
	if(AFKActiver == 0) {AFKTimer = SetTimer("AFK",60000,1);}
	//porte vol
	portevol = 0;
	print("Vol de banque mis a zero");
   //bowling
	BowlingRoadScreen[0] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Allée 1{008800} ]\n Vide",0xffffffff,-1974.7992,417.17291259766,4.7010, 15.0);
	BowlingRoadScreen[1] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Allée 2{008800} ]\n Vide",0xffffffff,-1974.7992,415.69528198242,4.7010, 15.0);
	BowlingRoadScreen[2] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Allée 3{008800} ]\n Vide",0xffffffff,-1974.7992,414.19616699219,4.7010, 15.0);
	BowlingRoadScreen[3] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Allée 4{008800} ]\n Vide",0xffffffff,-1974.7992,412.72177124023,4.7010, 15.0);
	BowlingRoadScreen[4] = CreateDynamic3DTextLabel("{008800}[{FFFFFF} Allée 5{008800} ]\n Vide",0xffffffff,-1974.7992,411.2473449707,4.7010, 15.0);
	//gym
	for( new o; o != sizeof barbell_pos; ++ o )
	{
		barbell_objects[o] = CreateDynamicObject( 2913, barbell_pos[ o ][ 0 ], barbell_pos[ o ][ 1 ], barbell_pos[ o ][ 2 ], barbell_pos[ o ][ 3 ], barbell_pos[ o ][ 4 ], barbell_pos[ o ][ 5 ]);//,-1,-1 );
		dumbell_right_objects[o] = CreateDynamicObject(3071,dumb_bell_right_pos[o][0],dumb_bell_right_pos[o][1],dumb_bell_right_pos[o][2],dumb_bell_right_pos[o][3],dumb_bell_right_pos[o][4],dumb_bell_right_pos[o][5]);//,-1,-1 );
		dumbell_left_objects[o] = CreateDynamicObject(3072,dumb_bell_left_pos[o][0],dumb_bell_left_pos[o][1],dumb_bell_left_pos[o][2],dumb_bell_left_pos[o][3],dumb_bell_left_pos[o][4],dumb_bell_left_pos[o][5]);//,-1,-1 );
	}
	//horse
	RaceStarted = 0;
	Prepared = 0;
	Horsemsg = 1;
	//SetTimer("GameTimeTimer2", 5000, 0);
	//blackjack
	foreach (new i : Player) BlackJackTextdraw(i);
 	format(rcon, sizeof(rcon), "password %s",PASSWORD);
	SendRconCommand(rcon);
	return 1;
}
script OnGameModeExit()
{
    foreach (new i : Player) {SQL_SaveCharacter(i);}
    //job generator
	KillTimer(threesecondtimer);
	//slot machine
	//SaveSlotMachines();
	DestroyAllSlotMachines();
	for(new i, k = GetMaxPlayers(); i < k; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		for(new j; j < sizeof(machineTD); j++) PlayerTextDrawDestroy(i, machineTD[j][i]);
		KillTimer(timerslot[i]);
	}
	//afk
	new serveursettinginfoid;
	AFKActiver = info_serveursettinginfo[serveursettinginfoid][settingafkactive];
	if(AFKActiver == 1) {KillTimer(AFKTimer);}
	//horse
    TextDrawDestroy(BG2);
    TextDrawDestroy(BG1);
    TextDrawDestroy(Start2);
    TextDrawDestroy(Finish2);
    TextDrawDestroy(Horse1);
    TextDrawDestroy(Horse2);
    TextDrawDestroy(Horse3);
    TextDrawDestroy(Horse4);
    TextDrawDestroy(HorseNum1);
    TextDrawDestroy(HorseNum2);
    TextDrawDestroy(HorseNum3);
    TextDrawDestroy(HorseNum4);
    TextDrawDestroy(Start);
    TextDrawDestroy(Finish);
    //lowrider
    TextDrawDestroy(ContestText);
	return 1;
}
script WeatherRotator()
{
	new index = random(sizeof(g_aWeatherRotations));
	SetWeather(g_aWeatherRotations[index]);
}
script LotteryUpdate()
{
	new number = random(60) + 1,jackpot = random(10000) + 100,moneyentrepriseid,gouvernementinfoid;
	foreach (new i : Player)
	{
	    if(PlayerData[i][pLotteryB] == 1)
	    {
			if (PlayerData[i][pLottery] == number)
			{
				GiveMoney(i, jackpot);
				SendServerMessage(i, "Vous avez gagné le jackpot de la lotterie qui était de %s!", FormatNumber(jackpot));
			}
			else
			{
		    	SendClientMessage(i, COLOR_WHITE, "[LOTTERIE]: Vous ne gagnez pas la lotterie cette fois.");
			}
			PlayerData[i][pLottery] = 0;
			PlayerData[i][pLotteryB] = 0;
		}
	}
	//argent_entreprise[moneyentrepriseid][argentmairie] -= jackpot;
	// les -- de la mairie
	argent_entreprise[moneyentrepriseid][argentmairie] -= info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionpolice];
	argent_entreprise[moneyentrepriseid][argentmairie] -= info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionfbi];
	argent_entreprise[moneyentrepriseid][argentmairie] -= info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionswat];
	argent_entreprise[moneyentrepriseid][argentmairie] -= info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionmedecin];
	argent_entreprise[moneyentrepriseid][argentmairie] -= info_gouvernementinfo[gouvernementinfoid][gouvernementaidebanque];
	//les ++ des subvention
	argent_entreprise[moneyentrepriseid][argentpolice] += info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionpolice];
	argent_entreprise[moneyentrepriseid][argentfbi] += info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionfbi];
	argent_entreprise[moneyentrepriseid][argentswat] += info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionswat];
	argent_entreprise[moneyentrepriseid][argentmedecin] += info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionmedecin];
	argent_entreprise[moneyentrepriseid][argentbanque] += info_gouvernementinfo[gouvernementinfoid][gouvernementaidebanque];
	moneyentreprisesave(moneyentrepriseid);
	return 1;
}

script OnPlayerRequestClass(playerid, classid)
{
	if (!PlayerData[playerid][pAccount] && !PlayerData[playerid][pKicked])
	{
	    new time[3];
        gettime(time[0], time[1], time[2]);
		SetPlayerTime(playerid, time[0], time[1]);
	    PlayerData[playerid][pAccount] = 1;
	    TogglePlayerSpectating(playerid, 1);
		SetPlayerColor(playerid, DEFAULT_COLOR);
		SetTimerEx("AccountCheck", 400, false, "d", playerid); // 400 ms
	}
	return 1;
}
script OnPlayerSpawn(playerid)
{
	if (PlayerData[playerid][pHUD])
	{
	 	TextDrawShowForPlayer(playerid, gServerTextdraws[0]);
		TextDrawShowForPlayer(playerid, gServerTextdraws[1]);
	}
    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
    Streamer_ToggleIdleUpdate(playerid, true);
	PlayerData[playerid][pKilled] = 0;
    if (PlayerData[playerid][pBleeding]) {PlayerData[playerid][pBleedTime] = 1;}
	if (PlayerData[playerid][pJailTime] > 0)//prison
	{
	    if (PlayerData[playerid][pPrisoned]) {SetPlayerInPrison(playerid);}
	    else
	    {
		    SetPlayerPosEx(playerid, 197.6346, 175.3765, 1003.0234);
		    SetPlayerInterior(playerid, 3);
		    SetPlayerVirtualWorld(playerid, (playerid + 100));
		    SetPlayerFacingAngle(playerid, 0.0);
		    SetCameraBehindPlayer(playerid);
		}
		ResetWeapons(playerid);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][70]);
	    SendServerMessage(playerid, "Tu as %d secondes de prison admin.", PlayerData[playerid][pJailTime]);
	}
	else if (PlayerData[playerid][pHospital] != -1)
	{
	    PlayerData[playerid][pHospitalTime] = 0;
	    PlayerData[playerid][pHunger] = 50;
	    PlayerData[playerid][pThirst] = 50;
		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, playerid + 100);
		SetPlayerPosEx(playerid, -211.0370, -1738.6848, 676.7153);
		SetPlayerFacingAngle(playerid, 82.0000);
		SetPlayerCameraPos(playerid, -214.236602, -1738.812133, 676.648132);
		SetPlayerCameraLookAt(playerid, -203.072738, -1738.656127, 675.768737);
        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Repos... 15", 1000, 3);
		TogglePlayerControllable(playerid, 0);
	}
	else if (!PlayerData[playerid][pCreated])
	{
	    Dialog_Show(playerid, Spawntype, DIALOG_STYLE_LIST, "D'où vous venez?", "Aéroport\nCaravane", "Accepter", "");
        SetPlayerCameraLookAt(playerid,1404.5933, -1594.4730, 95.4797);
		SetPlayerCameraPos(playerid, 1403.7042, -1594.0187, 96.0647);
	}
	else
	{
	    SetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);
	    SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
	    SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
		SetCameraBehindPlayer(playerid);
		SetAccessories(playerid);
        if (PlayerData[playerid][pWorld] == PRISON_WORLD)
		{SetPlayerPosEx(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);}
		else
		{
		    if(PlayerData[playerid][pSpawnPoint] == 3 && PlayerData[playerid][pInjured] == 0)
			{SetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);}
		}
		if (PlayerData[playerid][pInjured])
		{
		    ShowHungerTextdraw(playerid, 0);
		    SetPlayerPosEx(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);

			TextDrawShowForPlayer(playerid, gServerTextdraws[2]);
			SendClientMessage(playerid, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Vous êtes blessé vous avez besoin d'attention médical (/appeler 911).");
            SendClientMessage(playerid, COLOR_LIGHTRED, "[ATTENTION]:{FFFFFF} Si vous êtes blessé par arme autre que qu'une arme a feu attendez 2 minutes.");

			ApplyAnimation(playerid, "CRACK", "null", 4.0, 0, 0, 0, 1, 0, 1);
			ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
		}
		else
		{
			SetWeapons(playerid);
			//ShowHungerTextdraw(playerid, 1);

			SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
			SetPlayerArmour(playerid, PlayerData[playerid][pArmorStatus]);
		}
	}
	GangZoneShowForAll(zone1,COLOR_PURPLE);
	GangZoneShowForAll(zone2,COLOR_RED);
	GangZoneShowForAll(zone3,COLOR_GREEN);
	GangZoneShowForAll(zone4,COLOR_BLUE);
	//job meuble
	PreloadAnimLib(playerid,"BASEBALL");
	PreloadAnimLib(playerid,"CARRY");
	new serveursettinginfoid;
	SendAnnonceMessage(playerid, "%s.", info_serveursettinginfo[serveursettinginfoid][settingmotd]);
	SendServerMessage(playerid,"Pour communiquer avec le discord pour tout demande d'aide ou de chat nouveau /discordchat");
	//stamina
	SetPlayerStamina(playerid, 100.0);
	StaminaBar[playerid] = CreatePlayerProgressBar(playerid, 547.0, 38.5, 63.0, 5.0,-1429936641, 100.0);
    ShowPlayerProgressBar(playerid, StaminaBar[playerid]);
    //prgress bar faim soif jambes et lautre
    PlayerData[playerid][FaimBar] = CreatePlayerProgressBar(playerid, 82.000000, 317.000000, 55.500000, 3.200000, -1429936641, 100.0000, 0);
    PlayerData[playerid][SoifBar] = CreatePlayerProgressBar(playerid, 82.000000, 330.000000, 55.500000, 3.200000, -1429936641, 100.0000, 0);
    PlayerData[playerid][BrasBar] = CreatePlayerProgressBar(playerid, 82.000000, 343.000000, 55.500000, 3.200000, -1429936641, 5000.0000, 0);
    PlayerData[playerid][JambesBar] = CreatePlayerProgressBar(playerid, 82.000000, 357.000000, 55.500000, 3.200000, -1429936641, 5000.0000, 0);
	return 1;
}
script OnPlayerCommandReceived(playerid, cmdtext[])
{
	if (!SQL_IsLogged(playerid) || (PlayerData[playerid][pTutorial] > 0 || PlayerData[playerid][pTutorialStage] > 0 || PlayerData[playerid][pKilled] > 0 || PlayerData[playerid][pHospital] != -1))
	    return 0;

	if (PlayerData[playerid][pMuted] && strfind(cmdtext, "/unmute", true) != 0)
 	{
	    SendErrorMessage(playerid, "Tu est mute par le serveur.");
	    return 0;
	}
	if (PlayerData[playerid][pCommandCount] < 6)
	{
	    PlayerData[playerid][pCommandCount]++;

	    if (PlayerData[playerid][pCommandCount] == 6) {
	        PlayerData[playerid][pCommandCount] = 0;

	        PlayerData[playerid][pMuted] = 1;
	        PlayerData[playerid][pMuteTime] = 5;

	        SendServerMessage(playerid, "Tu a été mute pour spam (5 seconds).");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a été mute automatiquement pour spam.", ReturnName(playerid, 0));
	        return 0;
		}
	}
	AFKMin[playerid] = 0;
	return 1;
}
script OnPlayerCommandTextEx(playerid, cmdtext[])
{
    new factionid = PlayerData[playerid][pFaction];
	//afk
    AFKMin[playerid] = 0;
	//bank
    if(strcmp(cmdtext, "/volerbanque", true) == 0)
    {
        new serveursettinginfoid;
        if(info_serveursettinginfo[serveursettinginfoid][settingbraquagebankactive] == 1) return SendErrorMessage(playerid,"Les braquages sont désactivé pour les admins");
        if(portevol == 1) return SendErrorMessage(playerid,"Cela fait moins de une heure que la banque a été voler");
        if(info_serveursettinginfo[serveursettinginfoid][settingswat] < swat_nbrCops) {ShowPlayerFooter(playerid, " Il n'a pas assez de ~r~swat~w~ en ville"); return 1;}
        if(IsACop(playerid)) return SendErrorMessage(playerid,"Vous êtes du gouvernement mon dieu!");
        if(start1[playerid] != 1) return SendErrorMessage(playerid,"Vous n'avez pas commencer de braquage!");
        if (!IsPlayerInRangeOfPoint(playerid,10,1435.7437, -971.5178, 983.1413)) return SendErrorMessage(playerid,"Vous n'êtes pas dans le coffre!");
        ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,1,1,1,1);
        timerrob[playerid] = SetTimerEx("remplissagesac",30000,0,"d",playerid);
        SendServerMessage(playerid,"Remplissage de sac en cours...");
        return 1;
    }
	//job generator
	if(strcmp(cmdtext,"/gason",true)==0)
	{
		if(IsPlayerConnected(playerid))
		{
		    if (PlayerData[playerid][pJob] != JOB_GENERATEUR)
   				return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
			if(OnGener[playerid] >= 1)
			{
				SendClientMessage(playerid, COLOR_WHITE,"{FF0000}[ERREUR]{FFFFFF} Vous avez déjà commencé (a) le remplissage du générateur.");
				return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid,2.0,-956.9048,1943.4753,9.0000))
			{
				if(OnGen1 == 1) { SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Ce générateur a dejas un thécnicien."); return 1; }
				OnGener[playerid] = 1;
				OnBenz[playerid] = 0;
				OnGen1 = 1;
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Vous avez prit le Générateur [N°1] sous contrôle! Ne laissez pas la consommation totale du carburant tomber a Zéro.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} A l'éxtérieur, vous y trouverez le Réservoir d'essence. Allez remplir vos Bidons d'essence afin de ressourcer le générateur!.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Si vous glander .... Viré!");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Dès que vous voulez quitter votre poste et récupérer votre argent, éffectué /gasoff");
			}
			else if(IsPlayerInRangeOfPoint(playerid,2.0,-956.9048,1921.7970,9.0000))
			{
				if(OnGen2 == 1) { SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Ce générateur a dejas un thécnicien."); return 1; }
				OnGener[playerid] = 2;
				OnBenz[playerid] = 0;
				OnGen2 = 1;
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Vous avez prit le Générateur [N°2] sous contrôle! Ne laissez pas la consommation totale du carburant tomber a Zéro.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} A l'éxtérieur, vous y trouverez le Réservoir d'essence. Allez remplir vos Bidons d'essence afin de ressourcer le générateur!.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Si vous glander .... Viré!");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Dès que vous voulez quitter votre poste et récupérer votre argent, éffectué /gasoff");
			}
			else if(IsPlayerInRangeOfPoint(playerid,2.0,-956.9056,1900.1344,9.0000))
			{
				if(OnGen3 == 1) { SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Ce générateur a dejas un thécnicien."); return 1; }
				OnGener[playerid] = 3;
				OnBenz[playerid] = 0;
				OnGen3 = 1;
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Vous avez prit le Générateur [N°3] sous contrôle! Ne laissez pas la consommation totale du carburant tomber a Zéro.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} A l'éxtérieur, vous y trouverez le Réservoir d'essence. Allez remplir vos Bidons d'essence afin de ressourcer le générateur!.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Si vous glander .... Viré!");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Dès que vous voulez quitter votre poste et récupérer votre argent, éffectué /gasoff");
			}
			else if(IsPlayerInRangeOfPoint(playerid,2.0,-956.9048,1878.6244,9.0000))
			{
				if(OnGen4 == 1) { SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Ce générateur a dejas un thécnicien."); return 1; }
				OnGener[playerid] = 4;
				OnBenz[playerid] = 0;
				OnGen4 = 1;
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Vous avez prit le Générateur [N°4] sous contrôle! Ne laissez pas la consommation totale du carburant tomber a Zéro.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} A l'éxtérieur, vous y trouverez le Réservoir d'essence. Allez remplir vos Bidons d'essence afin de ressourcer le générateur!.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Si vous glander .... Viré!");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Dès que vous voulez quitter votre poste et récupérer votre argent, éffectué /gasoff");
			}
			else if(IsPlayerInRangeOfPoint(playerid,2.0,-956.9048,1856.8756,9.0000))
			{
				if(OnGen5 == 1) { SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Ce générateur a dejas un thécnicien."); return 1; }
				OnGener[playerid] = 5;
				OnBenz[playerid] = 0;
				OnGen5 = 1;
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Vous avez prit le Générateur [N°5] sous contrôle! Ne laissez pas la consommation totale du carburant tomber a Zéro.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} A l'éxtérieur, vous y trouverez le Réservoir d'essence. Allez remplir vos Bidons d'essence afin de ressourcer le générateur!.");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Si vous glander .... Viré!");
				SendClientMessage(playerid,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Dès que vous voulez quitter votre poste et récupérer votre argent, éffectué /gasoff");
			}
		}
		return 1;
	}
	if(strcmp(cmdtext,"/gasoff",true)==0)
	{
		if(IsPlayerConnected(playerid))
		{
			if (PlayerData[playerid][pJob] != JOB_GENERATEUR)
   				return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
			if(OnGener[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_WHITE,"{FF0000}[ERREUR]{FFFFFF} Vous ne l'avez pas commencer le travail.");
				return 1;
			}
			if(OnGener[playerid] == 1)
			{
				new stockjobinfoid,generatorstock1 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral1],interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
				interettaxejob = floatround((float(gen1m) / 100) * taxerevenue);
				argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
				tamere = (gen1m) - interettaxejob;
				GivePlayerCash(playerid,tamere);
				moneyentreprisesave(moneyentrepriseid);
				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", tamere);
				gen1m = 0;
				gen1 = generatorstock1;
				OnGener[playerid] = 0;
				OnBenz[playerid] = 0;
				OnGen1 = 0;

			}
			if(OnGener[playerid] == 2)
			{
				new stockjobinfoid,generatorstock2 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral2],interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
				interettaxejob = floatround((float(gen2m) / 100) * taxerevenue);
				argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
				tamere = (gen2m) - interettaxejob;
				GivePlayerCash(playerid,tamere);
				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", tamere);
				gen2m = 0;
				gen2 = generatorstock2;
				moneyentreprisesave(moneyentrepriseid);
				OnGener[playerid] = 0;
				OnBenz[playerid] = 0;
				OnGen2 = 0;

			}
			if(OnGener[playerid] == 3)
			{
				new stockjobinfoid,generatorstock3 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral3],interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
				interettaxejob = floatround((float(gen3m) / 100) * taxerevenue);
				argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
				tamere = (gen3m) - interettaxejob;
				GivePlayerCash(playerid,tamere);
				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", tamere);
				moneyentreprisesave(moneyentrepriseid);
				gen3 = generatorstock3;
				gen3m = 0;
				OnGener[playerid] = 0;
				OnBenz[playerid] = 0;
				OnGen3 = 0;
			}
			if(OnGener[playerid] == 4)
			{
				new stockjobinfoid,generatorstock4 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral4],interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
				interettaxejob = floatround((float(gen4m) / 100) * taxerevenue);
				argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
				tamere = (gen4m) - interettaxejob;
				GivePlayerCash(playerid,tamere);
				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", tamere);
				gen4 = generatorstock4;
				OnGener[playerid] = 0;
				moneyentreprisesave(moneyentrepriseid);
				OnBenz[playerid] = 0;
				gen4m = 0;
				OnGen4 = 0;
			}
			if(OnGener[playerid] == 5)
			{
				new stockjobinfoid,generatorstock5 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral5],interettaxejob,moneyentrepriseid,gouvernementinfoid,taxerevenue = info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],tamere;
				interettaxejob = floatround((float(gen5m) / 100) * taxerevenue);
				argent_entreprise[moneyentrepriseid][argentmairie] += interettaxejob;
				tamere = (gen5m) - interettaxejob;
				GivePlayerCash(playerid,tamere);
				SendJOBMessage(playerid, "Vous avez gagné %d dollars.", tamere);
				gen5 = generatorstock5;
				OnGener[playerid] = 0;
				OnBenz[playerid] = 0;
				moneyentreprisesave(moneyentrepriseid);
				OnGen5 = 0;
				gen5m = 0;
			}
		}
		return 1;
	}
	//salaire faction
 	if (strcmp("/salairegouv", cmdtext, true) == 0)
	{
	    if (FactionData[factionid][factionacces][7] == 0)
	    	return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);

		new string1[60], string2[60], string3[60],string[200];
		format(string1, sizeof(string1), "Rang 1\nRang 2\nRang 3\nRang 4\nRang 5\n");
		format(string2, sizeof(string2), "Rang 6\nRang 7\nRang 8\nRang 9\nRang 10\n");
		format(string3, sizeof(string3), "Rang 11\nRang 12\nRang 13\nRang 14\nRang 15");
		format(string, sizeof(string),"%s%s%s",string1,string2,string3);
		Dialog_Show(playerid,Salairegouv,2,"Pour le max rang faites /frang",string,"Valider","Quitter",FactionData[PlayerData[playerid][pFaction]][factionRanks]);
		return 1;
	}
 	if (strcmp("/salairefbi", cmdtext, true) == 0)
	{
	    if (FactionData[factionid][factionacces][7] == 0)
	    	return SendErrorMessage(playerid, "Tu n'est pas du gouvernement");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		new string1[60], string2[60], string3[60],string[200];
		format(string1, sizeof(string1), "Rang 1\nRang 2\nRang 3\nRang 4\nRang 5\n");
		format(string2, sizeof(string2), "Rang 6\nRang 7\nRang 8\nRang 9\nRang 10\n");
		format(string3, sizeof(string3), "Rang 11\nRang 12\nRang 13\nRang 14\nRang 15");
		format(string, sizeof(string),"%s%s%s",string1,string2,string3);
		Dialog_Show(playerid,Salairefbi,2,"Pour le max rang faites /frang",string,"Valider","Quitter",FactionData[PlayerData[playerid][pFaction]][factionRanks]);
		return 1;
	}
 	if (strcmp("/salairepolice", cmdtext, true) == 0)
	{
	    if (FactionData[factionid][factionacces][7] == 0)
	    	return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		new string1[60], string2[60], string3[60],string[200];
		format(string1, sizeof(string1), "Rang 1\nRang 2\nRang 3\nRang 4\nRang 5\n");
		format(string2, sizeof(string2), "Rang 6\nRang 7\nRang 8\nRang 9\nRang 10\n");
		format(string3, sizeof(string3), "Rang 11\nRang 12\nRang 13\nRang 14\nRang 15");
		format(string, sizeof(string),"%s%s%s",string1,string2,string3);
		Dialog_Show(playerid,Salairepolice,2,"Pour le max rang faites /frang",string,"Valider","Quitter",FactionData[PlayerData[playerid][pFaction]][factionRanks]);
		return 1;
	}
	if (strcmp("/salaireswat", cmdtext, true) == 0)
	{
	    if (FactionData[factionid][factionacces][7] == 0)
	    	return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		new string1[60], string2[60], string3[60],string[200];
		format(string1, sizeof(string1), "Rang 1\nRang 2\nRang 3\nRang 4\nRang 5\n");
		format(string2, sizeof(string2), "Rang 6\nRang 7\nRang 8\nRang 9\nRang 10\n");
		format(string3, sizeof(string3), "Rang 11\nRang 12\nRang 13\nRang 14\nRang 15");
		format(string, sizeof(string),"%s%s%s",string1,string2,string3);
		Dialog_Show(playerid,Salaireswat,2,"Pour le max rang faites /frang",string,"Valider","Quitter",FactionData[PlayerData[playerid][pFaction]][factionRanks]);
		return 1;
	}
	if (strcmp("/salaireurgentiste", cmdtext, true) == 0)
	{
	    if (FactionData[factionid][factionacces][7] == 0)
	    	return SendErrorMessage(playerid, "Tu n'est pas du gouvernement.");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		new string1[60], string2[60], string3[60],string[200];
		format(string1, sizeof(string1), "Rang 1\nRang 2\nRang 3\nRang 4\nRang 5\n");
		format(string2, sizeof(string2), "Rang 6\nRang 7\nRang 8\nRang 9\nRang 10\n");
		format(string3, sizeof(string3), "Rang 11\nRang 12\nRang 13\nRang 14\nRang 15");
		format(string, sizeof(string),"%s%s%s",string1,string2,string3);
		Dialog_Show(playerid,Salaireurgentiste,2,"Pour le max rang faites /frang",string,"Valider","Quitter",FactionData[PlayerData[playerid][pFaction]][factionRanks]);
		return 1;
	}
	if(strcmp(cmdtext, "/porteavantgauche", true) == 0)
   {
       if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
      {
		SetVehicleParamsCarDoors(GetPlayerVehicleID(playerid), 1, 0, 0, 0);
       }
       return 1;
   }
	if(strcmp(cmdtext, "/porteavantdroite", true) == 0)
   {
       if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
      {
		SetVehicleParamsCarDoors(GetPlayerVehicleID(playerid), 0, 1, 0, 0);
       }
       return 1;
   }
	if(strcmp(cmdtext, "/portearrieregauche", true) == 0)
   {
       if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
      {
		SetVehicleParamsCarDoors(GetPlayerVehicleID(playerid), 0, 0, 1, 0);
       }
       return 1;
   }
	if(strcmp(cmdtext, "/portearrieredroite", true) == 0)
   {
       if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
      {
		SetVehicleParamsCarDoors(GetPlayerVehicleID(playerid), 0, 0, 0, 1);
       }
       return 1;
   }
	if(strcmp(cmdtext, "/portetoute", true) == 0)
	{
		if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
		{
			SetVehicleParamsCarDoors(GetPlayerVehicleID(playerid), 0, 0, 0, 0);
		}
		return 1;
	}
	if(strcmp(cmdtext, "/fenetreo", true) == 0 || strcmp(cmdtext, "/opencarwindows", true) == 0)
   {
       if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
      {
         SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF);
       }
       return 1;
   }

	if(strcmp(cmdtext, "/fenetref", true) == 0 || strcmp(cmdtext, "/closecarwindows", true) == 0)
   {
       if(GetPlayerVehicleID(playerid) && GetPlayerVehicleID(playerid) != INVALID_VEHICLE_ID)
      {
         SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON);
       }
       return 1;
   }
	if(strcmp(cmdtext, "/giro",true) == 0)
	{
	    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525)
		{
			if(UCL[GetPlayerVehicleID(playerid)] == 0)
	  		{
	  			gelblicht1[GetPlayerVehicleID(playerid)] = CreateObject(19294,0,0,0,0,0,0,100);
	  			gelblicht2[GetPlayerVehicleID(playerid)] = CreateObject(19294,0,0,0,0,0,0,100);
	  			AttachObjectToVehicle(gelblicht1[GetPlayerVehicleID(playerid)],GetPlayerVehicleID(playerid),0.6,-0.5,1.4,0,0,0);
	  			AttachObjectToVehicle(gelblicht2[GetPlayerVehicleID(playerid)],GetPlayerVehicleID(playerid),-0.6,-0.5,1.4,0,0,0);
	  			UCL[GetPlayerVehicleID(playerid)] = 1;
	  			return 1;

			}
			else if(UCL[GetPlayerVehicleID(playerid)] == 1)
			{
				DestroyObject(gelblicht1[GetPlayerVehicleID(playerid)]);
				DestroyObject(gelblicht2[GetPlayerVehicleID(playerid)]);
				UCL[GetPlayerVehicleID(playerid)] = 0;
				return 1;
	        }
        }
	}
	if(!strcmp(cmdtext, "/mcharger", true))
	{
        if (PlayerData[playerid][pAdmin] < 4)
	    	return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
		slotmachineload();
		return 1;
	}
	if(!strcmp(cmdtext, "/mcreate", true))
	{
        if (PlayerData[playerid][pAdmin] < 4)
	    	return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
		new Float: P[4];
		GetPlayerPos(playerid, P[0], P[1], P[2]);
		GetPlayerFacingAngle(playerid, P[3]);
		GetXYInFrontOfPoint(P[0], P[1], P[3], 3);
		SetPlayerInterior(playerid, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));
		modelidslot++;
		machine[modelidslot][object] = CreateDynamicObject(2325, machine[modelidslot][pospos][0] = P[0], machine[modelidslot][pospos][1] = P[1],
		machine[modelidslot][pospos][2] = P[2], machine[modelidslot][pospos][3], machine[modelidslot][pospos][4], machine[modelidslot][pospos][5],machine[modelidslot][slotvw] = GetPlayerVirtualWorld(playerid),machine[modelidslot][slotint] = GetPlayerInterior(playerid));
		machine[modelidslot][created] = 1;
		EditDynamicObject(playerid, machine[modelidslot][object]);
	    return 1;
	}
	if(!strcmp(cmdtext, "/course", true))
	{
		SetTimer("GameTimeTimeTimer2", 5000, 0);
		return 1;
	}
    if(strcmp(cmdtext, "/elections", true) == 0)
    {
		if (PlayerData[playerid][pAdmin] < 4)
    		return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
        Dialog_Show(playerid, election1, DIALOG_STYLE_LIST, "{ECCC15}gestion électorale", "1. liste des candidats\n2. Ajouter candidat", "Valider", "Quitter");
		return 1;
	}
	SendErrorMessage(playerid, "La commande est inexistante, tapez /aide.");
	return 1;
}
script OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) success = OnPlayerCommandTextEx(playerid,cmdtext);
    return success;
}
script OnPlayerText(playerid, text[])
{
    new facass = PlayerData[playerid][pFaction];
	if ((!PlayerData[playerid][pLogged] && !PlayerData[playerid][pCharacter]) || PlayerData[playerid][pTutorial] > 0 || PlayerData[playerid][pTutorialStage] > 0 || PlayerData[playerid][pHospital] != -1)
	    return 0;

	if (PlayerData[playerid][pMuted])
	{
	    SendErrorMessage(playerid, "Vous êtes mute par le serveur.");
	    return 0;
	}
	if (PlayerData[playerid][pSpamCount] < 5)
	{
	    PlayerData[playerid][pSpamCount]++;

	    if (PlayerData[playerid][pSpamCount] == 5) {
	        PlayerData[playerid][pSpamCount] = 0;

	        PlayerData[playerid][pMuted] = 1;
	        PlayerData[playerid][pMuteTime] = 5;

	        SendServerMessage(playerid, "Vous avez été mute pour spam (5 seconds).");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s a été mute automatiquement pour spam.", ReturnName(playerid, 0));
	        return 0;
		}
	}
	if (PlayerData[playerid][pNewsGuest] != INVALID_PLAYER_ID && IsPlayerInAnyVehicle(playerid) && IsNewsVehicle(GetPlayerVehicleID(playerid)))
	{
	    foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
	  		SendClientMessageEx(i, COLOR_LIGHTGREEN, "[NEWS] Invité %s: %s", ReturnName(playerid, 0), text);
		}
	   	return 0;
   	}
	else
	{
		switch (PlayerData[playerid][pEmergency])
		{
			case 1:
			{
				if (!strcmp(text, "police", true))
				{
				    PlayerData[playerid][pEmergency] = 2;
				    SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPÉRATEUR]:{FFFFFF} L'appelle a été transmie au centre de police. Veuiller décrire le crime.");
				}
				else if (!strcmp(text, "medecin", true))
				{
				    PlayerData[playerid][pEmergency] = 3;
				    SendClientMessage(playerid, COLOR_HOSPITAL, "[OPÉRATEUR]:{FFFFFF} L'appelle a été transmie au centre médical. Veuiller décrire l'urgence.");
				}
				else SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPÉRATEUR]:{FFFFFF} Je ne comprend pas. Vous avez besoin de la \"police\" ou des \"medecin\"?");
			}
			case 2:
			{
				foreach (new i : Player)
				{
					new facass1 = PlayerData[i][pFaction];
					if(FactionData[facass1][factionacces][1] == 1)
					{
						SendServerMessage(i,"911 APPEL: %s (%s)", ReturnName(playerid, 0),GetPlayerLocation(playerid));
						SendServerMessage(i,"DESCRIPTION: %s", text);
						SetFactionMarker(playerid, FactionData[facass1][factionacces][1] == 1, 0x00ffc5FF);
			    		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPÉRATEUR]:{FFFFFF} Nous avons alerté tout les policier qui son dans le secteur.");
			    		cmd_racrocher(playerid, "\1");
			    		cmd_racrocher(playerid, "\1");
					}
				}
			}
			case 3:
			{
				foreach (new i : Player)
				{
					new facass1 = PlayerData[i][pFaction];
					if(FactionData[facass1][factionacces][5] == 1)
					{
						SendServerMessage(playerid, "911 APPEL: %s (%s)", ReturnName(playerid, 0), GetPlayerLocation(playerid));
						SendServerMessage(playerid, "DESCRIPTION: %s", text);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPÉRATEUR]:{FFFFFF} Nous avons alerté tout les policier qui son dans le secteur.");
			    		cmd_racrocher(playerid, "\1");
						SetFactionMarker(playerid, FactionData[facass][factionacces][5] == 1, 0x00D700FF);
					}
				}
			}
		}
		switch (PlayerData[playerid][pPlaceAd])
		{
		    case 1:
		    {
			    if (!strcmp(text, "oui", true))
		        {
		            if (GetMoney(playerid) < 500)
				    {
    	                SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Vous n'avez pas assez d'argent pour cela.");
					    cmd_racrocher(playerid, "\1");
					}
					else
					{
						PlayerData[playerid][pPlaceAd] = 2;
						SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} S'il vous plaît spécifier Votre scriptité et nous allons l'annoncer.");
					}
				}
			}
			case 2:
			{
			    if (GetMoney(playerid) < 500)
			    {
                    SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Désolé, Vous n'avez pas assez d'argent pour cela.");
				    cmd_racrocher(playerid, "\1");
				}
				else
				{
				    GiveMoney(playerid, -500);
				    new moneyentrepriseid;
					argent_entreprise[moneyentrepriseid][argentjournaliste] += 500;
					moneyentreprisesave(moneyentrepriseid);
				    SetTimerEx("Advertise", 3000, false, "d", playerid);
                    PlayerData[playerid][pAdTime] = 120;
				    strpack(PlayerData[playerid][pAdvertise], text, 128 char);
        	        SendClientMessage(playerid, COLOR_CYAN, "[OPÉRATEUR]:{FFFFFF} Votre scriptité va être diffusé sous peu.");
				    cmd_racrocher(playerid, "\1");
				}
			}
		}
		new targetid = PlayerData[playerid][pCallLine];
        if (IsPlayerInAnyVehicle(playerid) && IsWindowedVehicle(GetPlayerVehicleID(playerid)) && !CoreVehicles[GetPlayerVehicleID(playerid)][vehWindowsDown])
			SendVehicleMessage(GetPlayerVehicleID(playerid), 0xBBFFEEFF, "[Vehicule] %s dit: %s", ReturnName(playerid, 0), text);
		else
		{
		    if (!IsPlayerOnPhone(playerid))
				SendNearbyMessage(playerid, 10.0, COLOR_WHITE, "%s dit: %s", ReturnName(playerid, 0), text);
			else
			{
				SendNearbyMessage(playerid, 10.0, COLOR_WHITE, "(Téléphone) %s dit: %s",ReturnName(playerid, 0), text);
                //SendTelephoneMessage(targetid,"%s dit: %s",ReturnName(targetid, 0), text);
                Log_Write("logs/telephone.txt", "[%s] [Telephone]: %s dit: %s", ReturnDate(),ReturnName(playerid, 0), text);
			}
		}
		if (targetid != INVALID_PLAYER_ID && !PlayerData[playerid][pIncomingCall])
		{
			SendClientMessageEx(targetid, COLOR_YELLOW, "(Téléphone) %s dit: %s", ReturnName(playerid, 0), text);
		}
	}
	//afk
	AFKMin[playerid] = 0;
	return 0;
}
script OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (response == EDIT_RESPONSE_FINAL)
	{
	    if (PlayerData[playerid][pEditGraffiti] != -1 && GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiExists])
	    {
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][0] = x;
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][1] = y;
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][2] = z;
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][3] = rz;

			Graffiti_Refresh(PlayerData[playerid][pEditGraffiti]);
			Graffiti_Save(PlayerData[playerid][pEditGraffiti]);
		}
	    else if (PlayerData[playerid][pEditRack] != -1 && RackData[PlayerData[playerid][pEditRack]][rackExists])
	    {
			RackData[PlayerData[playerid][pEditRack]][rackPos][0] = x;
			RackData[PlayerData[playerid][pEditRack]][rackPos][1] = y;
			RackData[PlayerData[playerid][pEditRack]][rackPos][2] = z;
			RackData[PlayerData[playerid][pEditRack]][rackPos][3] = rz;

			Rack_Refresh(PlayerData[playerid][pEditRack]);
			Rack_Save(PlayerData[playerid][pEditRack]);
		}
	    else if (PlayerData[playerid][pEditPump] != -1 && PumpData[PlayerData[playerid][pEditPump]][pumpExists])
	    {
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][0] = x;
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][1] = y;
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][2] = z;
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][3] = rz;

			Pump_Refresh(PlayerData[playerid][pEditPump]);
			Pump_Save(PlayerData[playerid][pEditPump]);

			SendServerMessage(playerid, "Tu a modifié la position de la pompe ID: %d.", PlayerData[playerid][pEditPump]);
	    }
	    else if (PlayerData[playerid][pEditFurniture] != -1 && FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureExists])
	    {
	        new id = House_Inside(playerid);
	        if (id != -1 && House_IsOwner(playerid, id))
			{
			    FurnitureData[PlayerData[playerid][pEditFurniture]][furniturePos][0] = x;
			    FurnitureData[PlayerData[playerid][pEditFurniture]][furniturePos][1] = y;
			    FurnitureData[PlayerData[playerid][pEditFurniture]][furniturePos][2] = z;
                FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureRot][0] = rx;
                FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureRot][1] = ry;
                FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureRot][2] = rz;
				Furniture_Refresh(PlayerData[playerid][pEditFurniture]);
				Furniture_Save(PlayerData[playerid][pEditFurniture]);
				SendServerMessage(playerid, "Tu a modifié la position de l'objet\"%s\".", FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]);
			}
	    }
	    else if (PlayerData[playerid][pEditGate] != -1 && GateData[PlayerData[playerid][pEditGate]][gateExists])
	    {
	        switch (PlayerData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = PlayerData[playerid][pEditGate];
	                GateData[PlayerData[playerid][pEditGate]][gatePos][0] = x;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][1] = y;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][2] = z;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][3] = rx;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][4] = ry;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][5] = rz;
	                DestroyDynamicObject(GateData[id][gateObject]);
					GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);
					Gate_Save(id);
                    SendServerMessage(playerid, "Tu a modifié la position de la gate ID: %d.", id);
				}
				case 2:
	            {
	                new id = PlayerData[playerid][pEditGate];
	                GateData[PlayerData[playerid][pEditGate]][gateMove][0] = x;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][1] = y;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][2] = z;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][3] = rx;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][4] = ry;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][5] = rz;
	                DestroyDynamicObject(GateData[id][gateObject]);
					GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);
					Gate_Save(id);
                    SendServerMessage(playerid, "Tu a modifié la position de movement de la gate ID: %d.", id);
				}
			}
		}
	    else if (PlayerData[playerid][pEditbatiement] != -1 && batiementData[PlayerData[playerid][pEditbatiement]][batiementExists])
	    {
	        switch (PlayerData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = PlayerData[playerid][pEditbatiement];
	                batiementData[PlayerData[playerid][pEditbatiement]][batiementPos][0] = x;
	                batiementData[PlayerData[playerid][pEditbatiement]][batiementPos][1] = y;
	                batiementData[PlayerData[playerid][pEditbatiement]][batiementPos][2] = z;
	                batiementData[PlayerData[playerid][pEditbatiement]][batiementPos][3] = rx;
	                batiementData[PlayerData[playerid][pEditbatiement]][batiementPos][4] = ry;
	                batiementData[PlayerData[playerid][pEditbatiement]][batiementPos][5] = rz;
	                DestroyDynamicObject(batiementData[id][batiementObject]);
					batiementData[id][batiementObject] = CreateDynamicObject(batiementData[id][batiementModel], batiementData[id][batiementPos][0], batiementData[id][batiementPos][1], batiementData[id][batiementPos][2], batiementData[id][batiementPos][3], batiementData[id][batiementPos][4], batiementData[id][batiementPos][5], batiementData[id][batiementWorld], batiementData[id][batiementInterior]);
					batiement_Save(id);
                    SendServerMessage(playerid, "Tu a modifié la position de la batiement ID: %d.", id);
				}
			}
		}
	    else if (PlayerData[playerid][pEditcaisse] != -1)
	    {
	        switch (PlayerData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = PlayerData[playerid][pEditcaisse];

	                caisseMachineData[PlayerData[playerid][pEditcaisse]][caissePos][0] = x;
	                caisseMachineData[PlayerData[playerid][pEditcaisse]][caissePos][1] = y;
	                caisseMachineData[PlayerData[playerid][pEditcaisse]][caissePos][2] = z;
	                caisseMachineData[PlayerData[playerid][pEditcaisse]][caissePos][3] = rx;
	                caisseMachineData[PlayerData[playerid][pEditcaisse]][caissePos][4] = ry;
	                caisseMachineData[PlayerData[playerid][pEditcaisse]][caissePos][5] = rz;
	                //DestroyDynamicObject(PlayerData[playerid][pEditcaisse][caisseObject]);
					CreateDynamicObject(1514, caisseMachineData[id][caissePos][0], caisseMachineData[id][caissePos][1], caisseMachineData[id][caissePos][2], caisseMachineData[id][caissePos][3], caisseMachineData[id][caissePos][4], caisseMachineData[id][caissePos][5], caisseMachineData[id][caisseWorld], caisseMachineData[id][caisseInterior]);

					caisse_Save(id);
                    SendServerMessage(playerid, "Tu a modifié la position de la caisse ID: %d.", id);
				}
			}
		}
	}
	if (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
	{
	    if (PlayerData[playerid][pEditFurniture] != -1)//5137
			Furniture_Refresh(PlayerData[playerid][pEditFurniture]);

	    if (PlayerData[playerid][pEditPump] != -1)
			Pump_Refresh(PlayerData[playerid][pEditPump]);

        if (PlayerData[playerid][pEditRack] != -1)
			Rack_Refresh(PlayerData[playerid][pEditRack]);

        if (PlayerData[playerid][pEditGraffiti] != -1)
			Graffiti_Refresh(PlayerData[playerid][pEditGraffiti]);

	    PlayerData[playerid][pEditType] = 0;
	    PlayerData[playerid][pEditGate] = -1;
	    PlayerData[playerid][pEditbatiement] = -1;
		PlayerData[playerid][pEditPump] = -1;
		PlayerData[playerid][pGasStation] = -1;
		PlayerData[playerid][pEditFurniture] = -1;
		PlayerData[playerid][pEditGraffiti] = -1;
		PlayerData[playerid][pEditcaisse] = -1;
	}
	//slot machine
	new query[900];
    if(objectid == machine[modelidslot][object])
    {
       	if(response == EDIT_RESPONSE_FINAL)
       	{
       	    SetPlayerInterior(playerid, GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));
    		machine[modelidslot][pospos][0] = x;
    		machine[modelidslot][pospos][1] = y;
		    machine[modelidslot][pospos][2] = z;
		    machine[modelidslot][pospos][3] = rx;
		    machine[modelidslot][pospos][4] = ry;
		    machine[modelidslot][pospos][5] = rz;
		    machine[modelidslot][slotint] = GetPlayerInterior(playerid);
		    machine[modelidslot][slotvw] = GetPlayerVirtualWorld(playerid);
		    format(query, sizeof(query), "INSERT INTO `slotmachine` (`X`, `Y`, `Z`, `RX`,`RY`,`RZ`,`slotint`,`slotvw`) VALUE ('%f', '%f', '%f', '%f', '%f', '%f','%d', '%d')",x, y, z,rx,ry,rz,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
		    mysql_tquery(g_iHandle, query);
		    SetTimer("slotmachineload", 5000, 0);
    		return 1;
       	}
       	else if(response == EDIT_RESPONSE_CANCEL)
       	{
           	DestroyDynamicObject(machine[modelidslot][object]);
           	DestroyDynamic3DTextLabel(machine[modelidslot][text3d]);
           	machine[modelidslot][created] = 0;
           	return 1;
       	}
       	return 1;
    }
	return 1;
}
script OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if (response)
	{
		if (PlayerData[playerid][pEditType] != 0)
 		{
 		    AccessoryData[playerid][PlayerData[playerid][pEditType]-1][0] = fOffsetX;
       		AccessoryData[playerid][PlayerData[playerid][pEditType]-1][1] = fOffsetY;
         	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][2] = fOffsetZ;

          	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][3] = fRotX;
           	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][4] = fRotY;
           	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][5] = fRotZ;

            AccessoryData[playerid][PlayerData[playerid][pEditType]-1][6] = (fScaleX > 3.0) ? (3.0) : (fScaleX);
            AccessoryData[playerid][PlayerData[playerid][pEditType]-1][7] = (fScaleY > 3.0) ? (3.0) : (fScaleY);
			AccessoryData[playerid][PlayerData[playerid][pEditType]-1][8] = (fScaleZ > 3.0) ? (3.0) : (fScaleZ);

			switch (PlayerData[playerid][pEditType])
			{
	  			case 1:
	    		{
		            PlayerData[playerid][pEditType] = 0;
		            PlayerData[playerid][pGlasses] = modelid;

					if (!PlayerData[playerid][pCreated])
					{
		                for (new i = 23; i < 34; i ++) {
				    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
						}
						SelectTextDraw(playerid, -1);
						TogglePlayerControllable(playerid, 0);
					}
		            SendServerMessage(playerid, "Tu a confirmé tes lunettes.");
				}
				case 2:
	    		{
	                PlayerData[playerid][pEditType] = 0;
		            PlayerData[playerid][pHat] = modelid;

	                if (!PlayerData[playerid][pCreated])
					{
		                for (new i = 23; i < 34; i ++) {
				    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
						}
						SelectTextDraw(playerid, -1);
						TogglePlayerControllable(playerid, 0);
					}
		            SendServerMessage(playerid, "Tu a confirmé ton chapeau.");
				}
				case 3:
	    		{
	                PlayerData[playerid][pEditType] = 0;
		            PlayerData[playerid][pBandana] = modelid;

                 	if (!PlayerData[playerid][pCreated])
					{
		                for (new i = 23; i < 34; i ++) {
				    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
						}
						SelectTextDraw(playerid, -1);
						TogglePlayerControllable(playerid, 0);
					}
		            SendServerMessage(playerid, "Tu a confirmé ton bandana.");
				}
			}
	    }
	}
	else
	{
	    if (!PlayerData[playerid][pCreated])
		{
  			for (new i = 23; i < 34; i ++) {
			  	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			TogglePlayerControllable(playerid, 0);
			RemovePlayerAttachedObject(playerid, PlayerData[playerid][pEditType] - 1);
		}
	}
	return 1;
}
script OnModelSelectionResponse(playerid, extraid, index, modelid, response)
{
	if ((extraid >= MODEL_SELECTION_GLASSES && extraid <= MODEL_SELECTION_BANDANAS) && !PlayerData[playerid][pCreated] && !response)
	{
	    for (new i = 23; i < 34; i ++) {
    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
		}
		SetTimerEx("SelectTD", 100, false, "d", playerid);
		return 1;
	}
	if ((extraid == MODEL_SELECTION_INVENTORY && response) && InventoryData[playerid][index][invExists])
	{
	    new name[48],id = -1,backpack = GetPlayerBackpack(playerid);
		strunpack(name, InventoryData[playerid][index][invItem]);
	    PlayerData[playerid][pInventoryItem] = index;
		switch (PlayerData[playerid][pStorageSelect])
		{
		    case 1:
		    {
		    	if ((id = House_Inside(playerid)) != -1 && House_IsOwner(playerid, id))
				{
					if (InventoryData[playerid][index][invQuantity] == 1)
					{
					    if (!strcmp(name, "Backpack") && GetHouseBackpack(id) != -1)
					        return SendErrorMessage(playerid, "Tu ne peut mettre que un sac a dos dans ta maison.");

		        		House_AddItem(id, name, InventoryData[playerid][index][invModel], 1);
		        		Inventory_Remove(playerid, name);

		        		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a ranger \"%s\" dans sa maison", ReturnName(playerid, 0), name);
				 		House_ShowItems(playerid, id);

				 		if (!strcmp(name, "Backpack") && backpack != -1)
						{
					        BackpackData[backpack][backpackPlayer] = 0;
					        BackpackData[backpack][backpackHouse] = HouseData[id][houseID];

							Backpack_Save(backpack);
							SetAccessories(playerid);
					    }
		        	}
		        	else Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "Coffre maison", "Objet: %s (Quantité: %d)\n\nVeuiller entrée la quantité que vous vouler ranger pour cette objet:", "Ranger", "Retour", name, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
				}
				PlayerData[playerid][pStorageSelect] = 0;
			}
			case 2:
		    {
		    	if ((id = Car_Nearest(playerid)) != -1 && !CarData[id][carLocked])
				{
					if (InventoryData[playerid][index][invQuantity] == 1)
					{
					    if (!strcmp(name, "Backpack") && GetVehicleBackpack(id) != -1)
					        return SendErrorMessage(playerid, "Tu ne peut mettre que un sac a dos dans ton coffre de vehicule");

		        		Car_AddItem(id, name, InventoryData[playerid][index][invModel], 1);
		        		Inventory_Remove(playerid, name);

		        		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a ranger \"%s\" dans le coffre de la voiture.", ReturnName(playerid, 0), name);
				 		Car_ShowTrunk(playerid, id);

				 		if (!strcmp(name, "Backpack") && backpack != -1)
						{
					        BackpackData[backpack][backpackPlayer] = 0;
					        BackpackData[backpack][backpackVehicle] = CarData[id][carID];

							Backpack_Save(backpack);
							SetAccessories(playerid);
					    }
		        	}
		        	else Dialog_Show(playerid, CarDeposit, DIALOG_STYLE_INPUT, "Ranger dans la voiture", "Objet: %s (Quantité: %d)\n\nVeuiller entrée la quantité que vous vouler ranger pour cette objet:", "Ranger", "Retour", name, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
				}
				PlayerData[playerid][pStorageSelect] = 0;
			}
			case 3:
		    {
		        if (!strcmp(name, "Backpack"))
		            return SendErrorMessage(playerid, "Cette objet ne peut être ranger.");

		    	if (InventoryData[playerid][index][invQuantity] == 1)
				{
					Backpack_Add(GetPlayerBackpack(playerid), name, InventoryData[playerid][index][invModel], 1);
   					Inventory_Remove(playerid, name);

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a ranger \"%s\" dans son sac a dos", ReturnName(playerid, 0), name);
					Backpack_Open(playerid);
				}
   				else
	   			{
				   	Dialog_Show(playerid, BackpackDeposit, DIALOG_STYLE_INPUT, "Déposé dans le sac a dos", "Objet: %s (Quantité: %d)\n\nVeuiller entrée la quantité que vous vouler ranger pour cette objet:", "Ranger", "Retour", name, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
				}
				PlayerData[playerid][pStorageSelect] = 0;
			}
			default:
			{
			    if (PlayerData[playerid][pTutorialStage] == 3 && !strcmp(name, "Demo Soda", true))
			    {
			        SendClientMessage(playerid, COLOR_SERVER, "Appuyez sur la premiere option pour utiliser l'objet.");
			    }
		    	format(name, sizeof(name), "%s (%d)", name, InventoryData[playerid][index][invQuantity]);

		    	if (Garbage_Nearest(playerid) != -1) {
					Dialog_Show(playerid, Inventory, DIALOG_STYLE_LIST, name, "Utiliser\nDonner\nJeter dans la poubelle", "Envoyer", "Quitter");
				}
				else {
				    Dialog_Show(playerid, Inventory, DIALOG_STYLE_LIST, name, "Utiliser\nDonner\nJetter", "Envoyer", "Quitter");
				}
			}
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_GLASSES))
	{
	    if (modelid == 19300)
	    {
            for (new i = 23; i < 34; i ++) {
		    	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			PlayerData[playerid][pGlasses] = 0;

			RemovePlayerAttachedObject(playerid, 0);
			SendServerMessage(playerid, "Tu a enlever ta paire de lunettes.");
	    }
	    else
	    {
	        PlayerData[playerid][pEditType] = 1;
	        TogglePlayerControllable(playerid, 1);

			SetPlayerAttachedObject(playerid, 0, modelid, 2, 0.094214, 0.044044, -0.007274, 89.675476, 83.514060, 0.000000);
			EditAttachedObject(playerid, 0);
		}
	}
    if ((response) && (extraid == MODEL_SELECTION_HATS))
	{
	    if (modelid == 19300)
	    {
			for (new i = 23; i < 34; i ++) {
		    	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			PlayerData[playerid][pHat] = 0;

			RemovePlayerAttachedObject(playerid, 1);
			SendServerMessage(playerid, "Tu a enlever ton chapeau.");
	    }
	    else
	    {
		    PlayerData[playerid][pEditType] = 2;
		    TogglePlayerControllable(playerid, 1);

			SetPlayerAttachedObject(playerid, 1, modelid, 2, 0.1565, 0.0273, -0.0002, -7.9245, -1.3224, 15.0999);
			EditAttachedObject(playerid, 1);
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_BANDANAS))
	{
	    if (modelid == 19300)
	    {
            for (new i = 23; i < 34; i ++) {
		    	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			PlayerData[playerid][pBandana] = 0;

			RemovePlayerAttachedObject(playerid, 2);
			SendServerMessage(playerid, "Tu a enlever ton bandana.");
	    }
	    else
	    {
		    PlayerData[playerid][pEditType] = 3;
            TogglePlayerControllable(playerid, 1);

			SetPlayerAttachedObject(playerid, 2, modelid, 2, 0.099553, 0.044356, -0.000285, 89.675476, 84.277572, 0.000000);
			EditAttachedObject(playerid, 2);
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_SKIN))
	{
	    PlayerData[playerid][pSkin] = modelid;
		SetSpawnInfo(playerid, 0, PlayerData[playerid][pSkin], -2266.5588, 2818.8813, 175.6808, 270.0000, 0, 0, 0, 0, 0, 0);
		SetPlayerCameraLookAt(playerid,1404.5933, -1594.4730, 95.4797);
		SetPlayerCameraPos(playerid, 1403.7042, -1594.0187, 96.0647);
		TogglePlayerSpectating(playerid, 0);
	}
	if ((response) && (extraid == MODEL_SELECTION_VET))
	{
	    PlayerData[playerid][pSkin] = modelid;
		SetPlayerSkin(playerid,modelid);
	}
	if ((response) && (extraid == MODEL_SELECTION_CLOTHES))
	{
	    new bizid = -1,price;
	    if ((bizid = Business_Inside(playerid)) == -1 || BusinessData[bizid][bizType] != 3)
	        return 0;

		if (BusinessData[bizid][bizProducts] < 1)
		    return SendErrorMessage(playerid, "Ce biz n'a plus de produit.");
	    price = BusinessData[bizid][bizPrices][PlayerData[playerid][pClothesType] - 1];
	    if (GetMoney(playerid) < price)
	        return SendErrorMessage(playerid, "Argent insufficent.");
		GiveMoney(playerid, -price);

		BusinessData[bizid][bizProducts]--;
		BusinessData[bizid][bizVault] += Tax_Percent(price);
		Business_Save(bizid);
		Tax_AddPercent(price);

	    switch (PlayerData[playerid][pClothesType])
	    {
	        case 1:
	        {
	            PlayerData[playerid][pSkin] = modelid;
	            SetPlayerSkin(playerid, modelid);

	            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a payé %s $ reçois des vetements.", ReturnName(playerid, 0), FormatNumber(price));
			}
			case 2:
			{
			    PlayerData[playerid][pEditType] = 1;
                PlayerData[playerid][pGlasses] = modelid;

			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a payé %s $ reçois une paire de lunettes.", ReturnName(playerid, 0), FormatNumber(price));
				RemovePlayerAttachedObject(playerid, 0);

                SetPlayerAttachedObject(playerid, 0, modelid, 2, 0.094214, 0.044044, -0.007274, 89.675476, 83.514060, 0.000000);
				EditAttachedObject(playerid, 0);
			}
			case 3:
			{
			    PlayerData[playerid][pHat] = modelid;
			    PlayerData[playerid][pEditType] = 2;

			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a payé %s $ a reçu un chapeau.", ReturnName(playerid, 0), FormatNumber(price));
                RemovePlayerAttachedObject(playerid, 1);

				SetPlayerAttachedObject(playerid, 1, modelid, 2, 0.1565, 0.0273, -0.0002, -7.9245, -1.3224, 15.0999);
				EditAttachedObject(playerid, 1);
			}
			case 4:
			{
			    PlayerData[playerid][pBandana] = modelid;
			    PlayerData[playerid][pEditType] = 3;

			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a payé %s $ a reçu un bandana.", ReturnName(playerid, 0), FormatNumber(price));
			    RemovePlayerAttachedObject(playerid, 2);

			    SetPlayerAttachedObject(playerid, 2, modelid, 2, 0.099553, 0.044356, -0.000285, 89.675476, 84.277572, 0.000000);
				EditAttachedObject(playerid, 2);
			}
	    }
	}
	if ((response) && (extraid == MODEL_SELECTION_DEALER))
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
 	    {
	        if (!DealershipCars[id][index][vehModel])
	        {
	            Dialog_Show(playerid, AddVehicle, DIALOG_STYLE_LIST, "Ajouter un vehicule", "Ajout par nom\nAjout par images", "Envoyer", "Quitter");
			}
			else
			{
			    PlayerData[playerid][pDealerCar] = index;
			    Dialog_Show(playerid, CarOptions, DIALOG_STYLE_LIST, "Conssesionaire", "Set Price (%s)\nEnlever vehicule", "Envoyer", "Quitter", FormatNumber(DealershipCars[id][index][vehPrice]));
			}
	    }
	    static	bizid = -1;
		if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid))
		{
		    PlayerData[playerid][pDealerCar] = index;
	    	Dialog_Show(playerid, CarOptions, DIALOG_STYLE_LIST, "Conssesionaire", "Set Price (%s)", "Envoyer", "Quitter", FormatNumber(DealershipCars[id][index][vehPrice]));
		}
		else SendErrorMessage(playerid, "Vous n'êtes pas a la bonne place.");
	}
	if ((response) && (extraid == MODEL_SELECTION_DEALER_ADD))
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
	        for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++)
			{
				if (DealershipCars[id][i][vehModel] == modelid)
	            	return SendErrorMessage(playerid, "Ce vehicule est déja au conssesionnaire.");
			}
			PlayerData[playerid][pDealerCar] = modelid;
			Dialog_Show(playerid, DealerCarPrice, DIALOG_STYLE_INPUT, "Entrée un prix", "Veuiller entrée un prix pour '%s':", "Envoyer", "Quitter", ReturnVehicleModelName(PlayerData[playerid][pDealerCar]));
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_BUY_CAR))
	{
	    new id = Business_Inside(playerid);

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
		    if (!DealershipCars[id][index][vehModel])
		        return SendErrorMessage(playerid, "Aucun véhicule ici.");

		    if (GetMoney(playerid) < DealershipCars[id][index][vehPrice])
	    	    return SendErrorMessage(playerid, "Vous ne pouvez pas acheter ce véhicule, il vous manque (%s).", FormatNumber(DealershipCars[id][index][vehPrice]));

			PlayerData[playerid][pDealerCar] = index;
			Dialog_Show(playerid, ConfirmCarBuy, DIALOG_STYLE_MSGBOX, "Confirmation d'achat", "Voulez-vous vraiment achetez ce/cette '%s'?\n\nPour %s chez ce concessionnaire.", "Oui", "Non", ReturnVehicleModelName(modelid), FormatNumber(DealershipCars[id][index][vehPrice]));
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_FURNITURE))
	{
        new id = Business_Inside(playerid),type = PlayerData[playerid][pFurnitureType],price;

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 7)
	    {
	        price = BusinessData[id][bizPrices][type];

	        if (GetMoney(playerid) < price)
	            return SendErrorMessage(playerid, "Argent insufficent.");

			if (BusinessData[id][bizProducts] < 1)
		    	return SendErrorMessage(playerid, "Ce magasin n'a plus de produit.");

			new item = Inventory_Add(playerid, GetFurnitureNameByModel(modelid), modelid);

            if (item == -1)
   	        	return SendErrorMessage(playerid, "vous n'avez pas de place sur vous.");

			GiveMoney(playerid, -price);
			SendServerMessage(playerid, "Vous avez acheter un(e) \"%s\" pour %s %.", GetFurnitureNameByModel(modelid), FormatNumber(price));

			BusinessData[id][bizProducts]--;
			BusinessData[id][bizVault] += Tax_Percent(price);

			Business_Save(id);
			Tax_AddPercent(price);
	    }
	}
	if ((response) && (extraid == MODEL_SELECTION_COLOR))
	{
	    new vehicleid = GetNearestVehicle(playerid);

        if (vehicleid == INVALID_VEHICLE_ID)
		    return SendErrorMessage(playerid, "Vous n'êtes proche d'aucun véhicule.");

		if (!Inventory_HasItem(playerid, "Bombe de peinture"))
		    return SendErrorMessage(playerid, "vous n'avez pas de bombe de peinture.");

	    ApplyAnimation(playerid, "GRAFFITI", "null", 4.0, 0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0, 1);
        ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0, 1);

		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~peinture sur le vehicule...", 3000, 3);
		SetTimerEx("ResprayCar", 3000, false, "ddd", playerid, vehicleid, modelid);
	}
	if ((response) && (extraid == MODEL_SELECTION_SKINS))
	{
	    Dialog_Show(playerid, FactionSkin, DIALOG_STYLE_LIST, "Modifier vetement", "Ajout par Modele ID\nAjout par Image\nSupprimer", "Envoyer", "Quitter");
	    PlayerData[playerid][pSelectedSlot] = index;
	}
	if ((response) && (extraid == MODEL_SELECTION_ADD_SKIN))
	{
	    FactionData[PlayerData[playerid][pFactionEdit]][factionSkins][PlayerData[playerid][pSelectedSlot]] = modelid;
		Faction_Save(PlayerData[playerid][pFactionEdit]);

		SendServerMessage(playerid, "Vous avez défini l'ID du skin dans le slot %d pour %d.", PlayerData[playerid][pSelectedSlot], modelid);
	}
	if ((response) && (extraid == MODEL_SELECTION_FACTION_SKIN))
	{
	    new factionid = PlayerData[playerid][pFaction];
		if (factionid == -1 || !IsNearFactionLocker(playerid))
	    	return 0;
		if (modelid == 19300)
		    return SendErrorMessage(playerid, "Aucun modele dans le slot sélectionné.");
  		SetPlayerSkin(playerid, modelid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s a changé de tenue.", ReturnName(playerid, 0));
	}
	if ((response) && (extraid == MODEL_SELECTION_WHEELS))
	{
        new vehicleid = GetPlayerVehicleID(playerid);

		if (!IsPlayerInAnyVehicle(playerid) || !IsDoorVehicle(vehicleid))
	    	return 0;
		new stockjobinfoid;
		if(info_stockjobinfo[stockjobinfoid][stocktunningroue] == 0) return SendErrorMessage(playerid,"Il n'y a plus de pièce de ce type dans la réserve.");
		if( info_stockjobinfo[stockjobinfoid][stocktunningroue] > 0) {info_stockjobinfo[stockjobinfoid][stocktunningroue] -= 4;}
		if( info_stockjobinfo[stockjobinfoid][stocktunningroue] < 0) {info_stockjobinfo[stockjobinfoid][stocktunningroue] = 0;}
		stockjobinfosave(stockjobinfoid);
	    AddComponent(vehicleid, modelid);
	    SendVehiculeMessage(playerid, "Vous avez changer les roues du véhicule. Marque des roues \"%s\".", GetWheelName(modelid));
	}
	return 1;
}

script ResprayCar(playerid, vehicleid, color)
{
	if (!PlayerData[playerid][pLogged] || GetNearestVehicle(playerid) != vehicleid)
	    return 0;

	Inventory_Remove(playerid, "Bombe de peinture");
	ClearAnimations(playerid);

	SetVehicleColor(vehicleid, color, color);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s à utiliser une bombe de peinture sur un(e) %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
	return 1;
}

script OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if (clickedid == Text:INVALID_TEXT_DRAW)
	{
		if (!Dialog_Opened(playerid) && PlayerData[playerid][pDisplayStats] > 0)
	    {
	        if (PlayerData[playerid][pDisplayStats] == 2) {
	        	for (new i = 50; i < 58; i ++) PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	    	}
		    else for (new i = 40; i < 50; i ++) {
				PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			CancelSelectTextDraw(playerid);
			PlayerData[playerid][pDisplayStats] = false;
		}
	}
	return 0;
}
script OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if (!Dialog_Opened(playerid))
	{
		if (!PlayerData[playerid][pCharacter])
		{
			if (playertextid == PlayerData[playerid][pTextdraws][2])
				SelectCharacter(playerid, 1);
			else if (playertextid == PlayerData[playerid][pTextdraws][3])
				SelectCharacter(playerid, 2);
			else if (playertextid == PlayerData[playerid][pTextdraws][4])
				SelectCharacter(playerid, 3);
		}
		else
		{
		    if (playertextid == PlayerData[playerid][pTextdraws][78])
				SQL_LoadCharacter(playerid, PlayerData[playerid][pCharacter]);
			else if (playertextid == PlayerData[playerid][pTextdraws][79]) {
			    Dialog_Show(playerid, DeleteChar, DIALOG_STYLE_MSGBOX, "Supprimer personnage", "Attention: Vous vouler vraiment supprimer votre personnage? \"%s\"\n\nVous aller rien récupéré de ce personnage.", "Confirmer", "Quitter", PlayerCharacters[playerid][PlayerData[playerid][pCharacter] - 1]);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][80]) {
			    ShowCharacterMenu(playerid);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][19]) {
			    CancelSelectTextDraw(playerid);
			    Dialog_Show(playerid, Gender, DIALOG_STYLE_LIST, "Sexe", "Homme\nFemme", "Envoyer", "Quitter");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][20]) {
			    Dialog_Show(playerid, DateBirth, DIALOG_STYLE_INPUT, "Jour d'anniversere", "Jour d'anniversaire (JJ/MM/AAAA):", "Envoyer", "Quitter");
			}
            else if (playertextid == PlayerData[playerid][pTextdraws][21]) {
			    Dialog_Show(playerid, Origin, DIALOG_STYLE_INPUT, "Origine", "Votre origine:", "Envoyer", "Quitter");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][22])
			{
			    if (!strlen(PlayerData[playerid][pBirthdate]))
			        return SendClientMessage(playerid, COLOR_LIGHTRED, "Server: Vous devez entrée une date.");
				else if (!strlen(PlayerData[playerid][pOrigin]))
				    return SendClientMessage(playerid, COLOR_LIGHTRED, "Server: Vous devez entrée un origine.");
				else
				{
				    for (new i = 11; i < 23; i ++) {
						PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
					}
                    switch (PlayerData[playerid][pGender])
                    {
                        case 1: ShowModelSelectionMenu(playerid, "Vetenement", MODEL_SELECTION_SKIN, g_aMaleSkins, sizeof(g_aMaleSkins), -16.0, 0.0, -55.0);
						case 2: ShowModelSelectionMenu(playerid, "Vetenement", MODEL_SELECTION_SKIN, g_aFemaleSkins, sizeof(g_aFemaleSkins), -16.0, 0.0, -55.0);
                    }
				}
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][26])
			{
			    static arrGlasses[] = {19300, 19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022, 19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035};
				for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
				ShowModelSelectionMenu(playerid, "Glasses", MODEL_SELECTION_GLASSES, arrGlasses, sizeof(arrGlasses), 0.0, 0.0, 90.0);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][28])
			{
			    static arrHats[] = {19300, 18926, 18927, 18928, 18929, 18930, 18931, 18932, 18933, 18934, 18935, 18944, 18945, 18946, 18947, 18948, 18949, 18950, 18951};
				for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
				ShowModelSelectionMenu(playerid, "Hat", MODEL_SELECTION_HATS, arrHats, sizeof(arrHats), -20.0, -90.0, 0.0);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][30])
			{
			    static arrBandanas[] = {19300, 18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920};
				for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
				ShowModelSelectionMenu(playerid, "Bandana", MODEL_SELECTION_BANDANAS, arrBandanas, sizeof(arrBandanas), 0.0, 0.0, 90.0);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][33])
			{
			    for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
			    CancelSelectTextDraw(playerid);
			    TogglePlayerControllable(playerid, 1);
			    Dialog_Show(playerid, Spawntype, DIALOG_STYLE_LIST, "D'où vous venez?", "Aéroport\nCaravane", "Accepter", "");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][47])
			{
				new string[128];
				CancelSelectTextDraw(playerid);
				format(string, sizeof(string), "%s\n%s", (!PlayerCharacters[playerid][0][0]) ? ("Vide") : (PlayerCharacters[playerid][0]), (!PlayerCharacters[playerid][1][0]) ? ("Vide") : (PlayerCharacters[playerid][1]));
				Dialog_Show(playerid, CharList, DIALOG_STYLE_LIST, "Mon personnage", string, "Valider", "Quitter");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][48])
			{
				for (new i = 40; i < 50; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				CancelSelectTextDraw(playerid);
				PlayerData[playerid][pDisplayStats] = false;
				SetTimerEx("OpenInventory", 100, false, "d", playerid);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][49])
			{
				for (new i = 40; i < 50; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				CancelSelectTextDraw(playerid);
				PlayerData[playerid][pDisplayStats] = false;
			}
            else if (playertextid == PlayerData[playerid][pTextdraws][55])
			{
			    for (new i = 50; i < 58; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				CancelSelectTextDraw(playerid);
				PlayerData[playerid][pDisplayStats] = false;
			}
            else if (playertextid == PlayerData[playerid][pTextdraws][56])
			{
			    for (new i = 40; i < 58; i ++)
			    {
			        if (i >= 50)
				        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
					else if (i < 50)
					    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			    }
			    PlayerData[playerid][pDisplayStats] = true;
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][57])
			{
			    if (PlayerData[playerid][pCharacterMenu] == PlayerData[playerid][pCharacter])
			        return SendErrorMessage(playerid, "Tu joue avec se personnage tu ne peut le supprimé.");

                Dialog_Show(playerid, DeleteCharacter, DIALOG_STYLE_MSGBOX, "Supprimer personnage", "Attention: Vous vouler vraiment supprimer votre personnage?\"%s\"?\n\nVous aller rien récupéré de ce personnage", "Confirmer", "Quitter", PlayerCharacters[playerid][PlayerData[playerid][pCharacterMenu] - 1]);
			}
		}
	}
	if(playertextid  == atmklik[playerid][12])
	{
		if (PlayerData[playerid][pBankMoney] < 50)
			return SendErrorMessage(playerid, "Vous devez avoir au moins 50 dollars dans votre compte banquaire.");
	    new interet = floatround((float(50) / 100) * 5),moneyentrepriseid;
		PlayerData[playerid][pBankMoney] -= 50;
		PlayerData[playerid][pBankMoney] -= interet;
		argent_entreprise[moneyentrepriseid][argentbanque] += interet;
		moneyentreprisesave(moneyentrepriseid);
		GiveMoney(playerid, 50);
	    SendServerMessage(playerid, "Vous avez retiré 50$ de votre compte bancaire avec des intêrets de %s$.", FormatNumber (interet));
	}
	if(playertextid  == atmklik[playerid][13])
	{
		if (PlayerData[playerid][pBankMoney] < 100)
			return SendErrorMessage(playerid, "Vous devez avoir au moins 100 dollars dans votre compte banquaire.");
	    new interet = floatround((float(100) / 100) * 5),moneyentrepriseid;
	    PlayerData[playerid][pBankMoney] -= 100;
		PlayerData[playerid][pBankMoney] -= interet;
		argent_entreprise[moneyentrepriseid][argentbanque] += interet;
		moneyentreprisesave(moneyentrepriseid);
		GiveMoney(playerid, 100);
	    SendServerMessage(playerid, "Vous avez retiré 100$ de votre compte bancaire avec des intêrets de %s$.", FormatNumber (interet));
	}
	if(playertextid  == atmklik[playerid][14])
	{
		if (PlayerData[playerid][pBankMoney] < 200)
			return SendErrorMessage(playerid, "Vous devez avoir au moins 200 dollars dans votre compte banquaire.");
	    new interet = floatround((float(200) / 100) * 5),moneyentrepriseid;
	    PlayerData[playerid][pBankMoney] -= 200;
		PlayerData[playerid][pBankMoney] -= interet;
		argent_entreprise[moneyentrepriseid][argentbanque] += interet;
		moneyentreprisesave(moneyentrepriseid);
		GiveMoney(playerid, 200);
	    SendServerMessage(playerid, "Vous avez retiré 200$ de votre compte bancaire avec des intêrets de %s$.", FormatNumber (interet));
	}
	if(playertextid  == atmklik[playerid][15])
	{
		if (PlayerData[playerid][pBankMoney] < 400)
			return SendErrorMessage(playerid, "Vous devez avoir au moins 400 dollars dans votre compte banquaire.");
	    new interet = floatround((float(400) / 100) * 5),moneyentrepriseid;
	    PlayerData[playerid][pBankMoney] -= 400;
		PlayerData[playerid][pBankMoney] -= interet;
		argent_entreprise[moneyentrepriseid][argentbanque] += interet;
		moneyentreprisesave(moneyentrepriseid);
		GiveMoney(playerid, 400);
	    SendServerMessage(playerid, "Vous avez retiré 400$ de votre compte bancaire avec des intêrets de %s$.", FormatNumber (interet));
	}
	if(playertextid  == atmklik[playerid][16])
	{
		Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, "Guichet Automatique", "Balance du compte: %s$\n\nEntrée un montant:", "Retirer", " <-- ", FormatNumber(PlayerData[playerid][pBankMoney]));
	}
	if(playertextid  == atmklik[playerid][17])
	{
	    Dialog_Show(playerid, Transfer, DIALOG_STYLE_INPUT, "Guichet Automatique", "Balance du compte: %s$\n\nEntrée un ID ou nom:", "Continuer", " <-- ", FormatNumber(PlayerData[playerid][pBankMoney]));
	}
	if(playertextid  == atmklik[playerid][18])
	{
	    CancelSelectTextDraw(playerid);
	    for(new a=0 ; a<20 ; a++)
		PlayerTextDrawHide(playerid, atmklik[playerid][a]);
	}
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
	//roulette
	new count;
	for(new i;i<37;i++)
	{
		if(pBet[playerid][i] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
		if(playertextid == PlayerData[playerid][TD][i])
		{
	        PlayerData[playerid][Number] = i;
	        if(PlayerData[playerid][CType] == 0)
			{
    			if(GetPlayerMoney(playerid) < 10)
					return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
				pBet[playerid][i] += Frist_Bet_Value;
				GiveMoney(playerid,-Frist_Bet_Value);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = Frist_Bet_Value / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			if(PlayerData[playerid][CType] == 1)
			{
				if(GetPlayerMoney(playerid) < 5)
					return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
				pBet[playerid][i] += Second_Bet_Value;
				GiveMoney(playerid,-Second_Bet_Value);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = Second_Bet_Value / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
			}
			SendServerMessage(playerid,"Mise pour le chiffre %d : $%d",i,pBet[playerid][i]);
	        if(C_Created[playerid][i] == false)
	        {
	        	CreateChip(playerid,(cPos[i][0]-10.0),cPos[i][1]);
	        	C_Created[playerid][i] = true;
	        }
		}
	}
	if(playertextid == PlayerData[playerid][TD][37])
	{
		if(pBet[playerid][40] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][40] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][40] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_3to1] = 1;
		SendServerMessage(playerid,"Mise pour 3 a 1 : $%d",pBet[playerid][40]);
 		if(C_Created[playerid][40] == false)
		{
 			C_Created[playerid][40] = true;
 			CreateChip(playerid,555.000000, 203.000000);
		}
	}
	if(playertextid == PlayerData[playerid][TD][38])
	{
		if(pBet[playerid][41] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][41] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][41] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_3to1] = 2;
		SendServerMessage(playerid,"Mise pour 3 a 1 : $%d",pBet[playerid][41]);
 		if(C_Created[playerid][41] == false)
 		{
 			C_Created[playerid][41] = true;
 			CreateChip(playerid,555.000000, 174.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][39])
	{
		if(pBet[playerid][42] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][42] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][42] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_3to1] = 3;
		SendServerMessage(playerid,"Mise pour 3 a 1: $%d",pBet[playerid][42]);
 		if(C_Created[playerid][42] == false)
 		{
 			C_Created[playerid][42] = true;
 			CreateChip(playerid,555.000000, 145.000000);
		}
	}
	if(playertextid == PlayerData[playerid][TD][40])
	{
		if(pBet[playerid][43] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][43] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][43] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_1st12] = 1;
		SendServerMessage(playerid,"Mise pour 1st12: $%d",pBet[playerid][43]);
 		if(C_Created[playerid][43] == false)
 		{
 			C_Created[playerid][43] = true;
 			CreateChip(playerid,279.000000, 229.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][41])
	{
		if(pBet[playerid][44] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][44] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][44] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_2nd12] = 1;
		SendServerMessage(playerid,"Mise pour 2st12: $%d",pBet[playerid][44]);
 		if(C_Created[playerid][44] == false)
 		{
 			C_Created[playerid][44] = true;
 			CreateChip(playerid,379.000000, 229.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][42])
	{
		if(pBet[playerid][45] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
   			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][45] += Frist_Bet_Value;
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][45] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_3rd12] = 1;
		SendServerMessage(playerid,"Mise pour 3st12: $%d",pBet[playerid][45]);
 		if(C_Created[playerid][45] == false)
 		{
 			C_Created[playerid][45] = true;
 			CreateChip(playerid,479.000000, 229.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][43])
	{
		if(pBet[playerid][46] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
   			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][46] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][46] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_1to18] = 1;
		SendServerMessage(playerid,"Mise pour 1 a 18: $%d",pBet[playerid][46]);
 		if(C_Created[playerid][46] == false)
 		{
 			C_Created[playerid][46] = true;
 			CreateChip(playerid,254.000000, 255.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][44])
	{
		if(pBet[playerid][47] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
   			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][47] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][47] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][EVOROOD] = 1;
		SendServerMessage(playerid,"Mise pour EVEN: $%d",pBet[playerid][47]);
 		if(C_Created[playerid][47] == false)
 		{
 			C_Created[playerid][47] = true;
 			CreateChip(playerid,304.000000, 255.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][45])
	{
	    if(pBet[playerid][48] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
   			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][48] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][48] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][Color] = 1;
		SendServerMessage(playerid,"Mise pour Couleur Rouge: $%d",pBet[playerid][48]);
 		if(C_Created[playerid][48] == false)
 		{
 			C_Created[playerid][48] = true;
 			CreateChip(playerid,355.000000, 255.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][46])
	{
	    if(pBet[playerid][49] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
   			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][49] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][49] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][Color] = 2;
		SendServerMessage(playerid,"Mise pour Couleur Noir: $%d",pBet[playerid][49]);
 		if(C_Created[playerid][49] == false)
 		{
 			C_Created[playerid][49] = true;
 			CreateChip(playerid,404.000000, 255.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][47])
	{
	    if(pBet[playerid][50] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][50] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][50] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][EVOROOD] = 2;
		SendServerMessage(playerid,"Mise pour ODD : $%d",pBet[playerid][50]);
        if(C_Created[playerid][50] == false)
        {
 			C_Created[playerid][50] = true;
 			CreateChip(playerid,453.000000, 255.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][48])
	{
	    if(pBet[playerid][51] >= 1000) return SendErrorMessage(playerid, "Tu ne peut misez plus haut.");
	    if(PlayerData[playerid][CType] == 0)
		{
			if(GetPlayerMoney(playerid) < 10)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][51] += Frist_Bet_Value;
			GiveMoney(playerid,-Frist_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Frist_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
		if(PlayerData[playerid][CType] == 1)
		{
			if(GetPlayerMoney(playerid) < 5)
				return SendErrorMessage(playerid,"Vous n'avez pas assez d'argent!");
			pBet[playerid][51] += Second_Bet_Value;
			GiveMoney(playerid,-Second_Bet_Value);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = Second_Bet_Value / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] += aye;
					Faction_Save(ii);
				}
			}
		}
 		PlayerData[playerid][_19to36] = 1;
		SendServerMessage(playerid,"Mise pour 19 a 36 : $%d",pBet[playerid][51]);
 		if(C_Created[playerid][51] == false)
 		{
 			C_Created[playerid][51] = true;
 			CreateChip(playerid,502.000000, 255.000000);
 		}
	}
	if(playertextid == PlayerData[playerid][TD][51])
	{
 		for(new i=54;i<61;i++){PlayerTextDrawShow(playerid,PlayerData[playerid][TD][i]);}
 		CancelSelectTextDraw(playerid);
 		StartTimery[playerid] = SetTimerEx("StartRulet",200,1,"i",playerid);
 		StopTimery[playerid]  = SetTimerEx("StopRulet",5000,1,"i",playerid);
 		AFKMin[playerid] = 0;
	}
	if(playertextid == PlayerData[playerid][TD][50]){PlayerData[playerid][CType] = 0;}
	if(playertextid == PlayerData[playerid][TD][52]){PlayerData[playerid][CType] = 1;}
	//blackjack
    if(playertextid == BlackJackTD[12][playerid])
	{
	    Dialog_Show(playerid, BlackJackMiser, DIALOG_STYLE_INPUT, "BlackJack mise","Veuiller placé une mise pour commencer.", "Mise", "Annuler");
	}
    if(playertextid == BlackJackTD[14][playerid])
	{
        if(BlackJack[playerid][sommejouer] <= 0) return SendBlackJackMessage(playerid,"Veuiller miser pour jouer.");
        SetTimerEx("blackjackstart1",1000, false, "d", playerid);
	}
    if(playertextid == BlackJackTD[16][playerid])
	{
		if(BlackJack[playerid][somme3] == 0)
		{
    		SetTimerEx("blackjackcarte1",1000, false, "d", playerid);
    	}
    	else if(BlackJack[playerid][somme4] == 0)
 		{
    		SetTimerEx("blackjackcarte2",1000, false, "d", playerid);
    	}
    	else if(BlackJack[playerid][somme5] == 0)
 		{
    		SetTimerEx("blackjackcarte3",1000, false, "d", playerid);
    	}
	}
	if(playertextid == BlackJackTD[20][playerid])
	{
		SendBlackJackMessage(playerid,"Au croupier de jouer");
		SetTimerEx("blackjackcroupier",1000, false, "d", playerid);
	}
	return 1;
}
script StartRulet(playerid)
{
	new rand,string[128];
	rand = randomEx(0,36);
	format(string,sizeof(string),"%d",rand);
	PlayerTextDrawSetString(playerid,PlayerData[playerid][TD][56],string);
	switch(rand)
	{
	    case 0:
		{
		    PlayerTextDrawHide(playerid,PlayerData[playerid][TD][56]);
			PlayerTextDrawBoxColor(playerid,PlayerData[playerid][TD][56],0x00ff00ff);
			PlayerTextDrawShow(playerid,PlayerData[playerid][TD][56]);
		}
	    case 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36:
 	    {
 	        PlayerTextDrawHide(playerid,PlayerData[playerid][TD][56]);
 	        PlayerTextDrawBoxColor(playerid,PlayerData[playerid][TD][56],0xff0000ff);
 	        PlayerTextDrawShow(playerid,PlayerData[playerid][TD][56]);
 	    }
 	    case 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35:
 	    {
 	        PlayerTextDrawHide(playerid,PlayerData[playerid][TD][56]);
 	        PlayerTextDrawBoxColor(playerid,PlayerData[playerid][TD][56],0x000000ff);
 	        PlayerTextDrawShow(playerid,PlayerData[playerid][TD][56]);
 	    }
	}
	LastNumber[playerid] = rand;
}
script StopRulet(playerid)
{
    new string[128];
    format(string,sizeof(string),"%d",LastNumber[playerid]);
	PlayerTextDrawSetString(playerid,PlayerData[playerid][TD][56],string);
	switch(LastNumber[playerid])
	{
	    case 0:
		{
		    PlayerTextDrawHide(playerid,PlayerData[playerid][TD][56]);
			PlayerTextDrawBoxColor(playerid,PlayerData[playerid][TD][56],0x00ff00ff);
			PlayerTextDrawShow(playerid,PlayerData[playerid][TD][56]);
		}
	    case 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36:
 	    {
 	        PlayerTextDrawHide(playerid,PlayerData[playerid][TD][56]);
 	        PlayerTextDrawBoxColor(playerid,PlayerData[playerid][TD][56],0xff0000ff);
 	        PlayerTextDrawShow(playerid,PlayerData[playerid][TD][56]);
 	    }
 	    case 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35:
 	    {
 	        PlayerTextDrawHide(playerid,PlayerData[playerid][TD][56]);
 	        PlayerTextDrawBoxColor(playerid,PlayerData[playerid][TD][56],0x000000ff);
 	        PlayerTextDrawShow(playerid,PlayerData[playerid][TD][56]);
 	    }
	}
	CheckPlayer(playerid,LastNumber[playerid]);
	for(new i;i<50;i++)
	{
	    if(test[i] == true)
	    {
			PlayerTextDrawDestroy(playerid,PlayerData[playerid][C_TD][i]);
            test[i] = false;
		}
		idy=-1;
	}
	SelectTextDraw(playerid, 0x9999BBBB);
	RestartVaribles(playerid);
	KillTimer(StartTimery[playerid]);
	KillTimer(StopTimery[playerid]);
}
script CheckPlayer(playerid,number)
{
	new str[128],count;
	if(PlayerData[playerid][Number] == number)
	{
	    GiveMoney(playerid,10*pBet[playerid][number]);
	    format(str,sizeof(str),"~g~GAGNE $%d",10*pBet[playerid][number]);
	    GameTextForPlayer(playerid,str,5000,4);
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
		{
			new aye = 10*pBet[playerid][number] / count;
			if(FactionData[ii][factionacces][12] == 1)
			{
				FactionData[ii][factioncoffre] -= aye;
				Faction_Save(ii);
			}
		}
	}
	switch(number)
	{
	    case 3,6,9,12,15,18,21,24,27,30,33,36:
	    {
	        if(PlayerData[playerid][_3to1] == 3)
			{
	    		GiveMoney(playerid,3*pBet[playerid][42]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",3*pBet[playerid][42]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 3*pBet[playerid][42] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
	    }
	    case 2,5,8,11,14,17,20,23,26,29,32,35:
	    {
	        if(PlayerData[playerid][_3to1] == 2)
			{
	    		GiveMoney(playerid,3*pBet[playerid][41]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",3*pBet[playerid][41]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 3*pBet[playerid][41] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
	    }
	    case 1,4,7,10,13,16,19,22,25,28,31,34:
	    {
	        if(PlayerData[playerid][_3to1] == 1)
			{
	    		GiveMoney(playerid,3*pBet[playerid][40]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",3*pBet[playerid][40]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 3*pBet[playerid][40] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
	    }
   	}
   	switch(number)
 	{
	    case 1..12:
	    {
	        if(PlayerData[playerid][_1st12] == 1)
			{
	    		GiveMoney(playerid,3*pBet[playerid][43]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",3*pBet[playerid][43]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 3*pBet[playerid][43] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
	    }
	    case 13..24:
	    {
	        if(PlayerData[playerid][_2nd12] == 1)
			{
	    		GiveMoney(playerid,3*pBet[playerid][44]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",3*pBet[playerid][44]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 3*pBet[playerid][44] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
	    }
	    case 25..36:
	    {
	        if(PlayerData[playerid][_3rd12] == 1)
			{
	    		GiveMoney(playerid,3*pBet[playerid][45]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",3*pBet[playerid][45]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 3*pBet[playerid][45] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
	    }
	}
	switch(number)
 	{
 	    case 1..18:
 	    {
 	        if(PlayerData[playerid][_1to18] == 1)
			{
	    		GiveMoney(playerid,4*pBet[playerid][46]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",4*pBet[playerid][46]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 4*pBet[playerid][46] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
 	    }
 	    case 19..36:
 	    {
 	        if(PlayerData[playerid][_19to36] == 1)
			{
	    		GiveMoney(playerid,4*pBet[playerid][47]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",4*pBet[playerid][47]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 4*pBet[playerid][47] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
 	    }
 	}
 	switch(number)
 	{
 	    case 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36:
 	    {
 	        if(PlayerData[playerid][Color] == 1)
			{
	    		GiveMoney(playerid,4*pBet[playerid][48]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",4*pBet[playerid][48]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 4*pBet[playerid][48] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
 	    }
 	    case 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35:
 	    {
 	        if(PlayerData[playerid][Color] == 2)
			{
	    		GiveMoney(playerid,4*pBet[playerid][49]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",4*pBet[playerid][49]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 4*pBet[playerid][49] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
 	    }
 	}
 	switch(number)
 	{
 	    case 2,4,6,8,12,14,16,18,20,22,24,26,28,30,32,34,36:
 	    {
 	        if(PlayerData[playerid][EVOROOD] == 1)
			{
	    		GiveMoney(playerid,4*pBet[playerid][50]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",4*pBet[playerid][50]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 4*pBet[playerid][50] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
 	    }
 	    case 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35:
 	    {
 	        if(PlayerData[playerid][EVOROOD] == 2)
			{
	    		GiveMoney(playerid,4*pBet[playerid][51]);
	    		format(str,sizeof(str),"~g~GAGNE $%d",4*pBet[playerid][51]);
	    		GameTextForPlayer(playerid,str,5000,4);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = 4*pBet[playerid][51] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
			}
 	    }
 	}
 	for(new i;i<60;i++) {pBet[playerid][i] = 0;}
}
script ForkliftUpdate(playerid, vehid)
{
	if (PlayerData[playerid][pJob] != JOB_UNLOADER || GetVehicleModel(vehid) != 530 || !IsPlayerInWarehouse(playerid) || !PlayerData[playerid][pLoading]) {
	    return 0;
	}
	GetVehicleHealth(vehid, CoreVehicles[vehid][vehLoadHealth]);
    PlayerData[playerid][pLoading] = 0;
	CoreVehicles[vehid][vehLoadType] = 7;
	CoreVehicles[vehid][vehCrate] = CreateObject(3798, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);
	AttachObjectToVehicle(CoreVehicles[vehid][vehCrate], vehid, 0.0, 1.2, -0.05, 0.0, 0.0, 0.0);
	SetPlayerCheckpoint(playerid, 1306.3438, -45.3100, 1001.0313, 1.5);
	TogglePlayerControllable(playerid, 1);
	SendServerMessage(playerid, "Veuillez livréer la caisse sur le marqueur.");
	return 1;
}
script OnPlayerEnterDynamicArea(playerid,areaid)
{
	new string[128];
    if(areaid >= Sphere[0] && areaid <= Sphere[2] && Voting[playerid])
    {
		new String_[MAX_CANDIDATES*(MAX_PLAYER_NAME+36)];
        for(new i; i<NumberOfCandidates; i++)
        {
        	format(string, sizeof(string), "numéro de candidat %d: %s (%d votes)\n", i+1, Candidates1[i], Votes[i]);
            strcat(String_, string);
        }
        Dialog_Show(playerid, election5, DIALOG_STYLE_LIST, "{ECCC15}Qui voulez-vous pour voter?", String_, "vote", "Quitter");
    }
	return 1;
}
//job meuble
script CantidadTroncos()
{
	new stringi20[600],stockjobinfoid;
    new infostockboismeuble = info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble];
    format(stringi20, sizeof(stringi20), "{FFD700}Entrepôt de bois{FFFFFF}\nEn stock: {ff3300}%d bois{ffffff}",infostockboismeuble);
    SetDynamicObjectMaterialText(stockinfoboismenuiserie, 0, stringi20, OBJECT_MATERIAL_SIZE_256x128,"Arial", 22, 0, 0xFFFF8200, 0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	return 1;
}
script Tronco(playerid)
{
    new stockjobinfoid;
	if(Cantidad <= 0) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1.5,1600.1904, -1806.7262, 13.4863))
	{
		ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
		SetPlayerAttachedObject(playerid,3,1463,17,-0.028000,0.424000,-0.049999,-10.499997,97.500030,1.200000,0.446000,0.249000,0.490000);
		SetPVarInt(playerid,"Trabajando",1);
		SetPVarInt(playerid,"TomoCarpintero",0);
		if( info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] > 0) return  info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] -= 1;
		if( info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] < 0) return  info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] = 0;
		stockjobinfosave(stockjobinfoid);
		CantidadTroncos();
		SendClientMessage(playerid, -1, "Vous vous êtes mis en tenue de travail, saisit un troncs et aller devant une tables pour commencer à construire un meubles!");
	}
	return 1;
}
script TerminarMueble(playerid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, 3)) RemovePlayerAttachedObject(playerid, 3);
	TogglePlayerControllable(playerid,1);
	SetPlayerAttachedObject(playerid,3,ObjetoIDs[random(sizeof(ObjetoIDs))],17,-0.278000,0.187000,0.455999,-4.800001,94.299995,-0.099999,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
	SetPlayerCheckpoint(playerid, 1599.3877,-1812.6261,13.4234, 1.5);
	SendClientMessage(playerid, -1, "{c7a24a}»{FFFFFF} Votre meuble est prêt à être livré.");
}
script moneyentrepriseload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM banqueentreprise");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new moneyentrepriseid = 0; moneyentrepriseid < cache_get_row_count(); moneyentrepriseid++)
	{
	    argent_entreprise[moneyentrepriseid][argentid] = cache_get_field_content_int(moneyentrepriseid,"id");
		argent_entreprise[moneyentrepriseid][argentmecanozone3] = cache_get_field_content_int(moneyentrepriseid,"mecanozone3");
		argent_entreprise[moneyentrepriseid][argentmecanozone4] = cache_get_field_content_int(moneyentrepriseid,"mecanozone4");
		argent_entreprise[moneyentrepriseid][argentcourier] = cache_get_field_content_int(moneyentrepriseid,"livraisonzone1");
	    argent_entreprise[moneyentrepriseid][argentmafiazone1] = cache_get_field_content_int(moneyentrepriseid,"mafiazone1");
		argent_entreprise[moneyentrepriseid][argentmafiazone4] = cache_get_field_content_int(moneyentrepriseid,"mafiazone4");
		argent_entreprise[moneyentrepriseid][argentpolice] = cache_get_field_content_int(moneyentrepriseid,"police");
		argent_entreprise[moneyentrepriseid][argentfbi] = cache_get_field_content_int(moneyentrepriseid,"fbi");
		argent_entreprise[moneyentrepriseid][argentswat] = cache_get_field_content_int(moneyentrepriseid,"swat");
		argent_entreprise[moneyentrepriseid][argentmairie] = cache_get_field_content_int(moneyentrepriseid,"mairiels");
		argent_entreprise[moneyentrepriseid][argentmedecin] = cache_get_field_content_int(moneyentrepriseid,"medecin");
		argent_entreprise[moneyentrepriseid][argentfermier] = cache_get_field_content_int(moneyentrepriseid,"fermier");
		argent_entreprise[moneyentrepriseid][argentvendeur] = cache_get_field_content_int(moneyentrepriseid,"vendeur");
		argent_entreprise[moneyentrepriseid][argentjournaliste] = cache_get_field_content_int(moneyentrepriseid,"journaliste");
		argent_entreprise[moneyentrepriseid][argentbanque] = cache_get_field_content_int(moneyentrepriseid,"banque");
	}
	cache_delete(result);
	print("Chargement argent_entreprise");
}
script moneyentreprisesave(moneyentrepriseid)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE banqueentreprise SET mecanozone3=%d, mecanozone4=%d, livraisonzone1=%d, mafiazone1=%d, mafiazone4=%d, police=%d, fbi=%d, swat=%d, mairiels=%d, medecin=%d, fermier=%d, vendeur=%d, journaliste=%d, banque=%d WHERE id='1'",
	argent_entreprise[moneyentrepriseid][argentmecanozone3],
	argent_entreprise[moneyentrepriseid][argentmecanozone4],
	argent_entreprise[moneyentrepriseid][argentcourier],
	argent_entreprise[moneyentrepriseid][argentmafiazone1],
	argent_entreprise[moneyentrepriseid][argentmafiazone4],
	argent_entreprise[moneyentrepriseid][argentpolice],
	argent_entreprise[moneyentrepriseid][argentfbi],
	argent_entreprise[moneyentrepriseid][argentswat],
	argent_entreprise[moneyentrepriseid][argentmairie],
	argent_entreprise[moneyentrepriseid][argentmedecin],
	argent_entreprise[moneyentrepriseid][argentfermier],
	argent_entreprise[moneyentrepriseid][argentvendeur],
	argent_entreprise[moneyentrepriseid][argentjournaliste],
	argent_entreprise[moneyentrepriseid][argentbanque]);
    mysql_tquery(g_iHandle, query);
}
//camera helico
script THERMALON( playerid, veh )
{
	TextDrawDestroy( crosshair[playerid] ); //Détruire le réticule
	crosshair[playerid] = TextDrawCreate( 306.0, 218.0, "+" ); // Création de la croix
	TextDrawLetterSize( crosshair[playerid], 1.4 ,1.4 ); //Réglage de la taille du réticule
	TextDrawShowForPlayer( playerid, crosshair[playerid] ); //Afficher la croix pour le joueur
	objectIDs[veh] = CreateObject( 2921,0,0,0,0,0,0,80 ); // la création d'un objet léger comme il va agir comme une caméra
	AttachObjectToVehicle( objectIDs[veh], veh, 0.000000, 2.599999, -0.800000, 0.000000, 0.000000, 0.000000 ); // attacher l'objet à l'hélicoptère
	AttachCameraToObject( playerid, objectIDs[veh] ); // maintenant nous attachons notre caméra à l'objet
	SetPVarInt( playerid, "ThermalActive", 1 ); // mise thermalactive vrai
	SendClientMessage( playerid,COLOR_LIGHTRED,"[WARNING]: Vous êtes encore capable de descendre du véhicule." );
	playerveh[playerid] = veh; // Stockage de l'identification du véhicule dans une variable
	return 1;
}
script THERMALOFF(playerid)
{
	TextDrawDestroy( crosshair[playerid] ); // Détruire le réticule
	new vehid = playerveh[playerid];
	SendClientMessage( playerid,COLOR_LIGHTRED,"[NOTICE]: Vous avez quitté le mode thermique." );
	DeletePVar( playerid,"ThermalActive" ); // Suppression thermalactive de joueur
	SetCameraBehindPlayer( playerid ); // Réglage de l'appareil photo vers le joueur
	DestroyDynamicObject(objectIDs[vehid]); // Détruire la lumière de l'hélicoptère
	return 1;
}
//anti toit
script NoRoof(playerid)
{
    new carid = GetPlayerSurfingVehicleID(playerid);
    if(carid != INVALID_VEHICLE_ID ) 
    {
        new Float:speed = GetVehicleSpeed(carid); 
        new cm=GetVehicleModel(carid); 
        switch(cm)
        {
            case 430,446,452,453,454,472,473,484,493,595:{return 1;} 
            default:{}
        }
        if(speed > 30) 
        {
            new Float:slx, Float:sly, Float:slz;
            GetPlayerPos(playerid, slx, sly, slz);
            SetPlayerPos(playerid, slx, sly, slz+2.5);
            ApplyAnimation(playerid, "ped", "BIKE_fallR", 4.0, 0, 1, 0, 0, 0,0); 
            new Float:hp;
            GetPlayerHealth(playerid, hp);
            SetPlayerHealth(playerid, hp-15);
            SetTimerEx("anim2", 1100, 0, "d", playerid);
        }
    }
    return 1;
}
script anim2(playerid)
{
        ApplyAnimation(playerid, "ped", "getup", 4.0, 0, 1, 0, 0, 0,0);
        return 1;
}
//gouvernement
script gouvernementinfoload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM gouvernement");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new gouvernementinfoid = 0; gouvernementinfoid < cache_get_row_count(); gouvernementinfoid++)
	{
	    info_gouvernementinfo[gouvernementinfoid][gouvernementidd] = cache_get_field_content_int(gouvernementinfoid,"id");
	    info_gouvernementinfo[gouvernementinfoid][gouvernementtaxe] = cache_get_field_content_int(gouvernementinfoid,"taxe");
		info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue] = cache_get_field_content_int(gouvernementinfoid,"taxerevenue");
		info_gouvernementinfo[gouvernementinfoid][gouvernementtaxeentreprise] = cache_get_field_content_int(gouvernementinfoid,"taxeentreprise");
		info_gouvernementinfo[gouvernementinfoid][gouvernementchomage] = cache_get_field_content_int(gouvernementinfoid,"chomage");
		info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionpolice] = cache_get_field_content_int(gouvernementinfoid,"subventionpolice");
		info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionfbi] = cache_get_field_content_int(gouvernementinfoid,"subventionfbi");
	    info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionswat] = cache_get_field_content_int(gouvernementinfoid,"subventionmedecin");
		info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionmedecin] = cache_get_field_content_int(gouvernementinfoid,"subventionswat");
		info_gouvernementinfo[gouvernementinfoid][gouvernementaidebanque] = cache_get_field_content_int(gouvernementinfoid,"aidebanque");
		//taxe maison et biz
		info_gouvernementinfo[gouvernementinfoid][gouvernementbizhouse] = cache_get_field_content_int(gouvernementinfoid,"bizhouse");
		info_gouvernementinfo[gouvernementinfoid][gouvernementhouse] = cache_get_field_content_int(gouvernementinfoid,"maison");
		info_gouvernementinfo[gouvernementinfoid][gouvernementbiz] = cache_get_field_content_int(gouvernementinfoid,"magasin");
	}
	cache_delete(result);
	print("Chargement argent_gouvernement");
}
script gouvernementinfosave(gouvernementinfoid)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE gouvernement SET taxe=%d, taxerevenue=%d, taxeentreprise=%d, chomage=%d, subventionpolice=%d, subventionfbi=%d, subventionmedecin=%d, subventionswat=%d, aidebanque=%d, bizhouse=%d, maison=%d, magasin=%d WHERE id='1'",
	info_gouvernementinfo[gouvernementinfoid][gouvernementtaxe],
	info_gouvernementinfo[gouvernementinfoid][gouvernementtaxerevenue],
	info_gouvernementinfo[gouvernementinfoid][gouvernementtaxeentreprise],
	info_gouvernementinfo[gouvernementinfoid][gouvernementchomage],
	info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionpolice],
	info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionfbi],
	info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionswat],
	info_gouvernementinfo[gouvernementinfoid][gouvernementsubventionmedecin],
	info_gouvernementinfo[gouvernementinfoid][gouvernementaidebanque],
	info_gouvernementinfo[gouvernementinfoid][gouvernementbizhouse],
	info_gouvernementinfo[gouvernementinfoid][gouvernementhouse],
	info_gouvernementinfo[gouvernementinfoid][gouvernementbiz]);
    mysql_tquery(g_iHandle, query);
}
//cv des entreprise
script cvfbiidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvfbi");
    new Cache:result = mysql_query(g_iHandle,query);
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for(new cvfbiid = 0; cvfbiid < cache_get_row_count(); cvfbiid++)
	{
	    info_fbicv[cvfbiid][cvid] = cache_get_field_content_int(cvfbiid,"id");
	    cache_get_field_content(cvfbiid, "pseudo", info_fbicv[cvfbiid][pseudo], g_iHandle, 32);
	    info_fbicv[cvfbiid][telephone] = cache_get_field_content_int(cvfbiid,"telephone");
	    cache_get_field_content(cvfbiid, "naissance", info_fbicv[cvfbiid][naissance], g_iHandle, 24);
	    info_fbicv[cvfbiid][sexe] = cache_get_field_content_int(cvfbiid,"sexe");
	    cache_get_field_content(cvfbiid, "origine", info_fbicv[cvfbiid][origine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvjournalisteidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvjournaliste");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvjournalisteid = 0; cvjournalisteid < cache_get_row_count(); cvjournalisteid++)
	{
	    info_cvjournaliste[cvjournalisteid][cvjournalisteidd] = cache_get_field_content_int(cvjournalisteid,"id");
	    cache_get_field_content(cvjournalisteid, "pseudo", info_cvjournaliste[cvjournalisteid][cvjournalistepseudo], g_iHandle, 32);
	    info_cvjournaliste[cvjournalisteid][cvjournalistetelephone] = cache_get_field_content_int(cvjournalisteid,"telephone");
	    cache_get_field_content(cvjournalisteid, "naissance", info_cvjournaliste[cvjournalisteid][cvjournalistenaissance], g_iHandle, 24);
	    info_cvjournaliste[cvjournalisteid][cvjournalistesexe] = cache_get_field_content_int(cvjournalisteid,"sexe");
	    cache_get_field_content(cvjournalisteid, "origine", info_cvjournaliste[cvjournalisteid][cvjournalisteorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvurgentisteidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvurgentiste");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvurgentisteid = 0; cvurgentisteid < cache_get_row_count(); cvurgentisteid++)
	{
	    info_cvurgentiste[cvurgentisteid][cvurgentisteidd] = cache_get_field_content_int(cvurgentisteid,"id");
	    cache_get_field_content(cvurgentisteid, "pseudo", info_cvurgentiste[cvurgentisteid][cvurgentistepseudo], g_iHandle, 32);
	    info_cvurgentiste[cvurgentisteid][cvurgentistetelephone] = cache_get_field_content_int(cvurgentisteid,"telephone");
	    cache_get_field_content(cvurgentisteid, "naissance", info_cvurgentiste[cvurgentisteid][cvurgentistenaissance], g_iHandle, 24);
	    info_cvurgentiste[cvurgentisteid][cvurgentistesexe] = cache_get_field_content_int(cvurgentisteid,"sexe");
	    cache_get_field_content(cvurgentisteid, "origine", info_cvurgentiste[cvurgentisteid][cvurgentisteorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvlivraisonbizidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvlivraisonbiz");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvlivraisonbizid = 0; cvlivraisonbizid < cache_get_row_count(); cvlivraisonbizid++)
	{
	    info_cvlivraisonbiz[cvlivraisonbizid][cvlivraisonbizidd] = cache_get_field_content_int(cvlivraisonbizid,"id");
	    cache_get_field_content(cvlivraisonbizid, "pseudo", info_cvlivraisonbiz[cvlivraisonbizid][cvlivraisonbizpseudo], g_iHandle, 32);
	    info_cvlivraisonbiz[cvlivraisonbizid][cvlivraisonbiztelephone] = cache_get_field_content_int(cvlivraisonbizid,"telephone");
	    cache_get_field_content(cvlivraisonbizid, "naissance", info_cvlivraisonbiz[cvlivraisonbizid][cvlivraisonbiznaissance], g_iHandle, 24);
	    info_cvlivraisonbiz[cvlivraisonbizid][cvlivraisonbizsexe] = cache_get_field_content_int(cvlivraisonbizid,"sexe");
	    cache_get_field_content(cvlivraisonbizid, "origine", info_cvlivraisonbiz[cvlivraisonbizid][cvlivraisonbizorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvmairieidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvmairie");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvmairieid = 0; cvmairieid < cache_get_row_count(); cvmairieid++)
	{
	    info_cvmairie[cvmairieid][cvmairieidd] = cache_get_field_content_int(cvmairieid,"id");
	    cache_get_field_content(cvmairieid, "pseudo", info_cvmairie[cvmairieid][cvmairiepseudo], g_iHandle, 32);
	    info_cvmairie[cvmairieid][cvmairietelephone] = cache_get_field_content_int(cvmairieid,"telephone");
	    cache_get_field_content(cvmairieid, "naissance", info_cvmairie[cvmairieid][cvmairienaissance], g_iHandle, 24);
	    info_cvmairie[cvmairieid][cvmairiesexe] = cache_get_field_content_int(cvmairieid,"sexe");
	    cache_get_field_content(cvmairieid, "origine", info_cvmairie[cvmairieid][cvmairieorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvmecanozone3idload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvmecanozone3");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvmecanozone3id = 0; cvmecanozone3id < cache_get_row_count(); cvmecanozone3id++)
	{
	    info_cvmecanozone3[cvmecanozone3id][cvmecanozone3idd] = cache_get_field_content_int(cvmecanozone3id,"id");
	    cache_get_field_content(cvmecanozone3id, "pseudo", info_cvmecanozone3[cvmecanozone3id][cvmecanozone3pseudo], g_iHandle, 32);
	    info_cvmecanozone3[cvmecanozone3id][cvmecanozone3telephone] = cache_get_field_content_int(cvmecanozone3id,"telephone");
	    cache_get_field_content(cvmecanozone3id, "naissance", info_cvmecanozone3[cvmecanozone3id][cvmecanozone3naissance], g_iHandle, 24);
	    info_cvmecanozone3[cvmecanozone3id][cvmecanozone3sexe] = cache_get_field_content_int(cvmecanozone3id,"sexe");
	    cache_get_field_content(cvmecanozone3id, "origine", info_cvmecanozone3[cvmecanozone3id][cvmecanozone3origine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvmecanozone4idload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvmecanozone4");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvmecanozone4id = 0; cvmecanozone4id < cache_get_row_count(); cvmecanozone4id++)
	{
	    info_cvmecanozone4[cvmecanozone4id][cvmecanozone4idd] = cache_get_field_content_int(cvmecanozone4id,"id");
	    cache_get_field_content(cvmecanozone4id, "pseudo", info_cvmecanozone4[cvmecanozone4id][cvmecanozone4pseudo], g_iHandle, 32);
	    info_cvmecanozone4[cvmecanozone4id][cvmecanozone4telephone] = cache_get_field_content_int(cvmecanozone4id,"telephone");
	    cache_get_field_content(cvmecanozone4id, "naissance", info_cvmecanozone4[cvmecanozone4id][cvmecanozone4naissance], g_iHandle, 24);
	    info_cvmecanozone4[cvmecanozone4id][cvmecanozone4sexe] = cache_get_field_content_int(cvmecanozone4id,"sexe");
	    cache_get_field_content(cvmecanozone4id, "origine", info_cvmecanozone4[cvmecanozone4id][cvmecanozone4origine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvpoliceidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvpolice");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvpoliceid = 0; cvpoliceid < cache_get_row_count(); cvpoliceid++)
	{
	    info_cvpolice[cvpoliceid][cvpoliceidd] = cache_get_field_content_int(cvpoliceid,"id");
	    cache_get_field_content(cvpoliceid, "pseudo", info_cvpolice[cvpoliceid][cvpolicepseudo], g_iHandle, 32);
	    info_cvpolice[cvpoliceid][cvpolicetelephone] = cache_get_field_content_int(cvpoliceid,"telephone");
	    cache_get_field_content(cvpoliceid, "naissance", info_cvpolice[cvpoliceid][cvpolicenaissance], g_iHandle, 24);
	    info_cvpolice[cvpoliceid][cvpolicesexe] = cache_get_field_content_int(cvpoliceid,"sexe");
	    cache_get_field_content(cvpoliceid, "origine", info_cvpolice[cvpoliceid][cvpoliceorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvswatidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvswat");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvswatid = 0; cvswatid < cache_get_row_count(); cvswatid++)
	{
	    info_cvswat[cvswatid][cvswatidd] = cache_get_field_content_int(cvswatid,"id");
	    cache_get_field_content(cvswatid, "pseudo", info_cvswat[cvswatid][cvswatpseudo], g_iHandle, 32);
	    info_cvswat[cvswatid][cvswattelephone] = cache_get_field_content_int(cvswatid,"telephone");
	    cache_get_field_content(cvswatid, "naissance", info_cvswat[cvswatid][cvswatnaissance], g_iHandle, 24);
	    info_cvswat[cvswatid][cvswatsexe] = cache_get_field_content_int(cvswatid,"sexe");
	    cache_get_field_content(cvswatid, "origine", info_cvswat[cvswatid][cvswatorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvtaxiidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvtaxi");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvtaxiid = 0; cvtaxiid < cache_get_row_count(); cvtaxiid++)
	{
	    info_cvtaxi[cvtaxiid][cvtaxiidd] = cache_get_field_content_int(cvtaxiid,"id");
	    cache_get_field_content(cvtaxiid, "pseudo", info_cvtaxi[cvtaxiid][cvtaxipseudo], g_iHandle, 32);
	    info_cvtaxi[cvtaxiid][cvtaxitelephone] = cache_get_field_content_int(cvtaxiid,"telephone");
	    cache_get_field_content(cvtaxiid, "naissance", info_cvtaxi[cvtaxiid][cvtaxinaissance], g_iHandle, 24);
	    info_cvtaxi[cvtaxiid][cvtaxisexe] = cache_get_field_content_int(cvtaxiid,"sexe");
	    cache_get_field_content(cvtaxiid, "origine", info_cvtaxi[cvtaxiid][cvtaxiorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
script cvvendeurrueidload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM cvvendeurrue");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new cvvendeurrueid = 0; cvvendeurrueid < cache_get_row_count(); cvvendeurrueid++)
	{
	    info_cvvendeurrue[cvvendeurrueid][cvvendeurrueidd] = cache_get_field_content_int(cvvendeurrueid,"id");
	    cache_get_field_content(cvvendeurrueid, "pseudo", info_cvvendeurrue[cvvendeurrueid][cvvendeurruepseudo], g_iHandle, 32);
	    info_cvvendeurrue[cvvendeurrueid][cvvendeurruetelephone] = cache_get_field_content_int(cvvendeurrueid,"telephone");
	    cache_get_field_content(cvvendeurrueid, "naissance", info_cvvendeurrue[cvvendeurrueid][cvvendeurruenaissance], g_iHandle, 24);
	    info_cvvendeurrue[cvvendeurrueid][cvvendeurruesexe] = cache_get_field_content_int(cvvendeurrueid,"sexe");
	    cache_get_field_content(cvvendeurrueid, "origine", info_cvvendeurrue[cvvendeurrueid][cvvendeurrueorigine], g_iHandle, 32);
	}
	cache_delete(result);
}
//salaire mairie
script salairemairie(rank)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE salairemairie SET salairerang1=%d, salairerang2=%d, salairerang3=%d, salairerang4=%d, salairerang5=%d, salairerang6=%d, salairerang7=%d, salairerang8=%d, salairerang9=%d, salairerang10=%d, salairerang11=%d, salairerang12=%d, salairerang13=%d, salairerang14=%d, salairerang15=%d WHERE idfaction='1'",
	    info_salairemairie[rank][salairemairie1],
	    info_salairemairie[rank][salairemairie2],
	    info_salairemairie[rank][salairemairie3],
	    info_salairemairie[rank][salairemairie4],
	    info_salairemairie[rank][salairemairie5],
	    info_salairemairie[rank][salairemairie6],
	    info_salairemairie[rank][salairemairie7],
	    info_salairemairie[rank][salairemairie8],
	    info_salairemairie[rank][salairemairie9],
	    info_salairemairie[rank][salairemairie10],
	    info_salairemairie[rank][salairemairie11],
	    info_salairemairie[rank][salairemairie12],
	    info_salairemairie[rank][salairemairie13],
	    info_salairemairie[rank][salairemairie14],
	    info_salairemairie[rank][salairemairie15]);
    mysql_tquery(g_iHandle, query);
}
script salairemairieload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM salairemairie");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new rank = 0; rank < cache_get_row_count(); rank++)
	{
	    info_salairemairie[rank][salairemairieiddd] = cache_get_field_content_int(rank,"idfaction");
	    info_salairemairie[rank][salairemairie1] = cache_get_field_content_int(rank,"salairerang1");
	    info_salairemairie[rank][salairemairie2] = cache_get_field_content_int(rank,"salairerang2");
	    info_salairemairie[rank][salairemairie3] = cache_get_field_content_int(rank,"salairerang3");
	    info_salairemairie[rank][salairemairie4] = cache_get_field_content_int(rank,"salairerang4");
	    info_salairemairie[rank][salairemairie5] = cache_get_field_content_int(rank,"salairerang5");
	    info_salairemairie[rank][salairemairie6] = cache_get_field_content_int(rank,"salairerang6");
	    info_salairemairie[rank][salairemairie7] = cache_get_field_content_int(rank,"salairerang7");
	    info_salairemairie[rank][salairemairie8] = cache_get_field_content_int(rank,"salairerang8");
	    info_salairemairie[rank][salairemairie9] = cache_get_field_content_int(rank,"salairerang9");
	    info_salairemairie[rank][salairemairie10] = cache_get_field_content_int(rank,"salairerang10");
	    info_salairemairie[rank][salairemairie11] = cache_get_field_content_int(rank,"salairerang11");
	    info_salairemairie[rank][salairemairie12] = cache_get_field_content_int(rank,"salairerang12");
	    info_salairemairie[rank][salairemairie13] = cache_get_field_content_int(rank,"salairerang13");
	    info_salairemairie[rank][salairemairie14] = cache_get_field_content_int(rank,"salairerang14");
	    info_salairemairie[rank][salairemairie15] = cache_get_field_content_int(rank,"salairerang15");
	}
	cache_delete(result);
}
script salairefbi(rank)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE salairefbi SET salairerang1=%d, salairerang2=%d, salairerang3=%d, salairerang4=%d, salairerang5=%d, salairerang6=%d, salairerang7=%d, salairerang8=%d, salairerang9=%d, salairerang10=%d, salairerang11=%d, salairerang12=%d, salairerang13=%d, salairerang14=%d, salairerang15=%d WHERE idfaction='1'",
	    info_salairefbi[rank][salairefbi1],
	    info_salairefbi[rank][salairefbi2],
	    info_salairefbi[rank][salairefbi3],
	    info_salairefbi[rank][salairefbi4],
	    info_salairefbi[rank][salairefbi5],
	    info_salairefbi[rank][salairefbi6],
	    info_salairefbi[rank][salairefbi7],
	    info_salairefbi[rank][salairefbi8],
	    info_salairefbi[rank][salairefbi9],
	    info_salairefbi[rank][salairefbi10],
	    info_salairefbi[rank][salairefbi11],
	    info_salairefbi[rank][salairefbi12],
	    info_salairefbi[rank][salairefbi13],
	    info_salairefbi[rank][salairefbi14],
	    info_salairefbi[rank][salairefbi15]);
    mysql_tquery(g_iHandle, query);
}

script salairefbiload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM salairefbi");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new rank = 0; rank < cache_get_row_count(); rank++)
	{
	    info_salairefbi[rank][salairefbiiddd] = cache_get_field_content_int(rank,"idfaction");
	    info_salairefbi[rank][salairefbi1] = cache_get_field_content_int(rank,"salairerang1");
	    info_salairefbi[rank][salairefbi2] = cache_get_field_content_int(rank,"salairerang2");
	    info_salairefbi[rank][salairefbi3] = cache_get_field_content_int(rank,"salairerang3");
	    info_salairefbi[rank][salairefbi4] = cache_get_field_content_int(rank,"salairerang4");
	    info_salairefbi[rank][salairefbi5] = cache_get_field_content_int(rank,"salairerang5");
	    info_salairefbi[rank][salairefbi6] = cache_get_field_content_int(rank,"salairerang6");
	    info_salairefbi[rank][salairefbi7] = cache_get_field_content_int(rank,"salairerang7");
	    info_salairefbi[rank][salairefbi8] = cache_get_field_content_int(rank,"salairerang8");
	    info_salairefbi[rank][salairefbi9] = cache_get_field_content_int(rank,"salairerang9");
	    info_salairefbi[rank][salairefbi10] = cache_get_field_content_int(rank,"salairerang10");
	    info_salairefbi[rank][salairefbi11] = cache_get_field_content_int(rank,"salairerang11");
	    info_salairefbi[rank][salairefbi12] = cache_get_field_content_int(rank,"salairerang12");
	    info_salairefbi[rank][salairefbi13] = cache_get_field_content_int(rank,"salairerang13");
	    info_salairefbi[rank][salairefbi14] = cache_get_field_content_int(rank,"salairerang14");
	    info_salairefbi[rank][salairefbi15] = cache_get_field_content_int(rank,"salairerang15");
	}
	cache_delete(result);
}
script salairepolice(rank)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE salairepolice SET salairerang1=%d, salairerang2=%d, salairerang3=%d, salairerang4=%d, salairerang5=%d, salairerang6=%d, salairerang7=%d, salairerang8=%d, salairerang9=%d, salairerang10=%d, salairerang11=%d, salairerang12=%d, salairerang13=%d, salairerang14=%d, salairerang15=%d WHERE idfaction='1'",
	    info_salairepolice[rank][salairepolice1],
	    info_salairepolice[rank][salairepolice2],
	    info_salairepolice[rank][salairepolice3],
	    info_salairepolice[rank][salairepolice4],
	    info_salairepolice[rank][salairepolice5],
	    info_salairepolice[rank][salairepolice6],
	    info_salairepolice[rank][salairepolice7],
	    info_salairepolice[rank][salairepolice8],
	    info_salairepolice[rank][salairepolice9],
	    info_salairepolice[rank][salairepolice10],
	    info_salairepolice[rank][salairepolice11],
	    info_salairepolice[rank][salairepolice12],
	    info_salairepolice[rank][salairepolice13],
	    info_salairepolice[rank][salairepolice14],
	    info_salairepolice[rank][salairepolice15]);
    mysql_tquery(g_iHandle, query);
}

script salairepoliceload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM salairepolice");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new rank = 0; rank < cache_get_row_count(); rank++)
	{
	    info_salairepolice[rank][salairepoliceiddd] = cache_get_field_content_int(rank,"idfaction");
	    info_salairepolice[rank][salairepolice1] = cache_get_field_content_int(rank,"salairerang1");
	    info_salairepolice[rank][salairepolice2] = cache_get_field_content_int(rank,"salairerang2");
	    info_salairepolice[rank][salairepolice3] = cache_get_field_content_int(rank,"salairerang3");
	    info_salairepolice[rank][salairepolice4] = cache_get_field_content_int(rank,"salairerang4");
	    info_salairepolice[rank][salairepolice5] = cache_get_field_content_int(rank,"salairerang5");
	    info_salairepolice[rank][salairepolice6] = cache_get_field_content_int(rank,"salairerang6");
	    info_salairepolice[rank][salairepolice7] = cache_get_field_content_int(rank,"salairerang7");
	    info_salairepolice[rank][salairepolice8] = cache_get_field_content_int(rank,"salairerang8");
	    info_salairepolice[rank][salairepolice9] = cache_get_field_content_int(rank,"salairerang9");
	    info_salairepolice[rank][salairepolice10] = cache_get_field_content_int(rank,"salairerang10");
	    info_salairepolice[rank][salairepolice11] = cache_get_field_content_int(rank,"salairerang11");
	    info_salairepolice[rank][salairepolice12] = cache_get_field_content_int(rank,"salairerang12");
	    info_salairepolice[rank][salairepolice13] = cache_get_field_content_int(rank,"salairerang13");
	    info_salairepolice[rank][salairepolice14] = cache_get_field_content_int(rank,"salairerang14");
	    info_salairepolice[rank][salairepolice15] = cache_get_field_content_int(rank,"salairerang15");
	}
	cache_delete(result);
}
script salaireswat(rank)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE salaireswat SET salairerang1=%d, salairerang2=%d, salairerang3=%d, salairerang4=%d, salairerang5=%d, salairerang6=%d, salairerang7=%d, salairerang8=%d, salairerang9=%d, salairerang10=%d, salairerang11=%d, salairerang12=%d, salairerang13=%d, salairerang14=%d, salairerang15=%d WHERE idfaction='1'",
	    info_salaireswat[rank][salaireswat1],
	    info_salaireswat[rank][salaireswat2],
	    info_salaireswat[rank][salaireswat3],
	    info_salaireswat[rank][salaireswat4],
	    info_salaireswat[rank][salaireswat5],
	    info_salaireswat[rank][salaireswat6],
	    info_salaireswat[rank][salaireswat7],
	    info_salaireswat[rank][salaireswat8],
	    info_salaireswat[rank][salaireswat9],
	    info_salaireswat[rank][salaireswat10],
	    info_salaireswat[rank][salaireswat11],
	    info_salaireswat[rank][salaireswat12],
	    info_salaireswat[rank][salaireswat13],
	    info_salaireswat[rank][salaireswat14],
	    info_salaireswat[rank][salaireswat15]);
    mysql_tquery(g_iHandle, query);
}

script salaireswatload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM salaireswat");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new rank = 0; rank < cache_get_row_count(); rank++)
	{
	    info_salaireswat[rank][salaireswatiddd] = cache_get_field_content_int(rank,"idfaction");
	    info_salaireswat[rank][salaireswat1] = cache_get_field_content_int(rank,"salairerang1");
	    info_salaireswat[rank][salaireswat2] = cache_get_field_content_int(rank,"salairerang2");
	    info_salaireswat[rank][salaireswat3] = cache_get_field_content_int(rank,"salairerang3");
	    info_salaireswat[rank][salaireswat4] = cache_get_field_content_int(rank,"salairerang4");
	    info_salaireswat[rank][salaireswat5] = cache_get_field_content_int(rank,"salairerang5");
	    info_salaireswat[rank][salaireswat6] = cache_get_field_content_int(rank,"salairerang6");
	    info_salaireswat[rank][salaireswat7] = cache_get_field_content_int(rank,"salairerang7");
	    info_salaireswat[rank][salaireswat8] = cache_get_field_content_int(rank,"salairerang8");
	    info_salaireswat[rank][salaireswat9] = cache_get_field_content_int(rank,"salairerang9");
	    info_salaireswat[rank][salaireswat10] = cache_get_field_content_int(rank,"salairerang10");
	    info_salaireswat[rank][salaireswat11] = cache_get_field_content_int(rank,"salairerang11");
	    info_salaireswat[rank][salaireswat12] = cache_get_field_content_int(rank,"salairerang12");
	    info_salaireswat[rank][salaireswat13] = cache_get_field_content_int(rank,"salairerang13");
	    info_salaireswat[rank][salaireswat14] = cache_get_field_content_int(rank,"salairerang14");
	    info_salaireswat[rank][salaireswat15] = cache_get_field_content_int(rank,"salairerang15");
	}
	cache_delete(result);
}
script salaireurgentiste(rank)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE salaireurgentiste SET salairerang1=%d, salairerang2=%d, salairerang3=%d, salairerang4=%d, salairerang5=%d, salairerang6=%d, salairerang7=%d, salairerang8=%d, salairerang9=%d, salairerang10=%d, salairerang11=%d, salairerang12=%d, salairerang13=%d, salairerang14=%d, salairerang15=%d WHERE idfaction='1'",
	    info_salaireurgentiste[rank][salaireurgentiste1],
	    info_salaireurgentiste[rank][salaireurgentiste2],
	    info_salaireurgentiste[rank][salaireurgentiste3],
	    info_salaireurgentiste[rank][salaireurgentiste4],
	    info_salaireurgentiste[rank][salaireurgentiste5],
	    info_salaireurgentiste[rank][salaireurgentiste6],
	    info_salaireurgentiste[rank][salaireurgentiste7],
	    info_salaireurgentiste[rank][salaireurgentiste8],
	    info_salaireurgentiste[rank][salaireurgentiste9],
	    info_salaireurgentiste[rank][salaireurgentiste10],
	    info_salaireurgentiste[rank][salaireurgentiste11],
	    info_salaireurgentiste[rank][salaireurgentiste12],
	    info_salaireurgentiste[rank][salaireurgentiste13],
	    info_salaireurgentiste[rank][salaireurgentiste14],
	    info_salaireurgentiste[rank][salaireurgentiste15]);
    mysql_tquery(g_iHandle, query);
}

script salaireurgentisteload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM salaireurgentiste");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new rank = 0; rank < cache_get_row_count(); rank++)
	{
	    info_salaireurgentiste[rank][salaireurgentisteiddd] = cache_get_field_content_int(rank,"idfaction");
	    info_salaireurgentiste[rank][salaireurgentiste1] = cache_get_field_content_int(rank,"salairerang1");
	    info_salaireurgentiste[rank][salaireurgentiste2] = cache_get_field_content_int(rank,"salairerang2");
	    info_salaireurgentiste[rank][salaireurgentiste3] = cache_get_field_content_int(rank,"salairerang3");
	    info_salaireurgentiste[rank][salaireurgentiste4] = cache_get_field_content_int(rank,"salairerang4");
	    info_salaireurgentiste[rank][salaireurgentiste5] = cache_get_field_content_int(rank,"salairerang5");
	    info_salaireurgentiste[rank][salaireurgentiste6] = cache_get_field_content_int(rank,"salairerang6");
	    info_salaireurgentiste[rank][salaireurgentiste7] = cache_get_field_content_int(rank,"salairerang7");
	    info_salaireurgentiste[rank][salaireurgentiste8] = cache_get_field_content_int(rank,"salairerang8");
	    info_salaireurgentiste[rank][salaireurgentiste9] = cache_get_field_content_int(rank,"salairerang9");
	    info_salaireurgentiste[rank][salaireurgentiste10] = cache_get_field_content_int(rank,"salairerang10");
	    info_salaireurgentiste[rank][salaireurgentiste11] = cache_get_field_content_int(rank,"salairerang11");
	    info_salaireurgentiste[rank][salaireurgentiste12] = cache_get_field_content_int(rank,"salairerang12");
	    info_salaireurgentiste[rank][salaireurgentiste13] = cache_get_field_content_int(rank,"salairerang13");
	    info_salaireurgentiste[rank][salaireurgentiste14] = cache_get_field_content_int(rank,"salairerang14");
	    info_salaireurgentiste[rank][salaireurgentiste15] = cache_get_field_content_int(rank,"salairerang15");
	}
	cache_delete(result);
}
//vehicule doamge
script OnPlayerShootVehiclePart(playerid, weaponid, vehicleid,hittype)
{
    new Float:carhp;
    new veh = GetPlayerVehicleID(playerid);
    GetVehicleHealth(veh, carhp);
	if(hittype==BULLET_HIT_LEFT_FRONT_WHEEL)
	{
		if(GetVehicleTireStatus(vehicleid,VEHICLE_LEFT_FRONT_WHEEL)==0)
		{
			SetVehicleTireStatus(vehicleid,VEHICLE_LEFT_FRONT_WHEEL);
			SetVehicleHealth(veh,carhp-2);
			new idk = Car_GetID(veh);
			CarData[idk][carvie] -= 2;
			return 1;
		}
	}
	if(hittype==BULLET_HIT_RIGHT_FRONT_WHEEL)
	{
		if(GetVehicleTireStatus(vehicleid,VEHICLE_RIGHT_FRONT_WHEEL)==0)
		{
			SetVehicleTireStatus(vehicleid,VEHICLE_RIGHT_FRONT_WHEEL);
			SetVehicleHealth(veh,carhp-2);
			new idk = Car_GetID(veh);
			CarData[idk][carvie] -= 2;
			return 1;
		}
	}
	if(hittype==BULLET_HIT_LEFT_BACK_WHEEL)
	{
		if(GetVehicleTireStatus(vehicleid,VEHICLE_LEFT_BACK_WHEEL)==0)
		{
			SetVehicleTireStatus(vehicleid,VEHICLE_LEFT_BACK_WHEEL);
			SetVehicleHealth(veh,carhp-2);
			new idk = Car_GetID(veh);
			CarData[idk][carvie] -= 2;
			return 1;
		}
	}
	if(hittype==BULLET_HIT_RIGHT_BACK_WHEEL)
	{
		if(GetVehicleTireStatus(vehicleid,VEHICLE_RIGHT_BACK_WHEEL)==0)
		{
			SetVehicleTireStatus(vehicleid,VEHICLE_RIGHT_BACK_WHEEL);
			SetVehicleHealth(veh,carhp-2);
			new idk = Car_GetID(veh);
			CarData[idk][carvie] -= 2;
			return 1;
		}
	}
	if(hittype==BULLET_HIT_BODY)
	{
		SetVehicleHealth(veh,carhp-10);
		new idk = Car_GetID(veh);
		CarData[idk][carvie] -= 10;
		return 1;
	}
	return 1;
}
//limitation de vitesse sur un véhicule abimer
script BadEngine()
{
    new veh, Float:spd[3], Float:hls;
    for(new i; i != GetMaxPlayers(); i++)
    {
        if (!IsEngineVehicle(veh) && !IsABike(veh))
        {
        	if( !BE_Play_Check[i] ) { continue; }
        	veh = GetPlayerVehicleID( i );
        	if( !veh ) { continue; }
        	GetVehicleHealth( veh, hls );
        	if( hls > BE_MIN_HLS ) { continue; }
        	GetVehicleVelocity( veh, spd[0], spd[1], spd[2] );
	        if( floatabs(spd[0]) > floatabs(spd[1]) )
	        {
	            if( floatabs(spd[ 0 ]) > BE_MAX_SPD )
	            {
	                hls = BE_MAX_SPD / floatabs(spd[ 0 ]);
	                SetVehicleVelocity( veh, spd[0]*hls, spd[1]*hls, spd[2] );
	            }
	        }
	        else
	        {
	            if( floatabs(spd[ 1 ]) > BE_MAX_SPD )
	            {
	                hls = BE_MAX_SPD / floatabs(spd[ 1 ]);
	                SetVehicleVelocity( veh, spd[0]*hls, spd[1]*hls, spd[2] );
	            }
			}
        }
    }
}
//Usure du moteur
script SystemPolomka()
{
	new Float:carhealth, vehicle;
 	for(new i = 0; i < GetMaxPlayers(); i++)
 	{
 		if( GetPlayerState(i) == PLAYER_STATE_DRIVER )
 		{
 			vehicle = GetPlayerVehicleID(i);
 			GetVehicleHealth(vehicle, carhealth);
 			if(carhealth < 500)
 			{
				SendVehiculeMessage(i, "Le moteur est endommager, Appellez un mécanicien pour le réparer.");
 			}
 			if( carhealth > 300 && GetEngineStatus(vehicle) == 1)
 			{
 				SetVehicleHealth(vehicle, carhealth - 1.00 );
				new idk = Car_GetID(vehicle);
				CarData[idk][carvie] -= 1;
 			}
 		}
 	}
 	return 1;
}
script OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    //info maison pickup
    static houseid = -1,stringm[256],st[101];

	if((houseid = House_Nearest(playerid)) != -1 && pickupid == HouseData[houseid][housePickup])
	{
		format(st, sizeof(st), "~n~~w~%s  ~w~ID ~g~~h~~h~~h~%d",HouseData[houseid][houseAddress],houseid);
		format(stringm, sizeof(stringm), "~w~Etat ~g~~h~~h~~h~ %s~n~~w~Valeur ~g~~h~~h~~h~%d$~n~~w~Location ~g~~h~~h~~h~%d$~n~~w~Locataire ~p~%d~w~/~g~~h~~h~~h~%d", GetHouseStatut(houseid),HouseData[houseid][housePrice],HouseData[houseid][houseLocation],HouseData[houseid][houseLocNum],HouseData[houseid][houseMaxLoc]);
		TSM(playerid, stringm, st, 5000, 0x00000088, 20.0000, 110.000000, 130.000000);
	}
    //job doc fortcarson
    if(pickupid == port)
	{
		if(PlayerDok[playerid] == false)
        {
            if (PlayerData[playerid][pJob] != JOB_DOC)
	    		return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
			if(GetPVarInt(playerid,"JOB1") == 1) Dialog_Show(playerid,jobdock1,0,"Emploi \"chargeur\"","Voulez-vous vraiment quitter le travail?","Oui","Non");
			else Dialog_Show(playerid,jobdock2,0,"Emploi \"chargeur\"","Voulez-vous vraiment commencer le travail?\n","Oui","Non");
		}
	}
    //job petrolier
    if(pickupid == forestJobPickUP)
    {
        if (PlayerData[playerid][pJob] != JOB_PETROLIER)
	    	return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
        if(!GetPVarInt(playerid,"PForestJob")) Dialog_Show(playerid,petroljob1,0,"Travail pétrolier","{ffffff}Voulez-vous commencer le travail","Oui","Non");
        else Dialog_Show(playerid,petroljob1,0,"Travail pétrolier","{ffffff}Voulez-vous quitter le travail","Oui","Non");
    }
    //job generator
    else if(pickupid == genpickup[0])
    {
        new string[128],salairejobinfoid,generateurprix = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur],kanistrab = 200,stockjobinfoid;
        if(OnGener[playerid] != 1) return 1;
        if(OnGen1 != 1) return 1;
        if(OnBenz[playerid] != 1) return 1;
        if(gen1 >= 299880) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Attendez un peu plus...");
        format(string, sizeof(string), "Vous avez rajouter %d litres d'essence dans le générateur.",kanistrab);
        SendClientMessage(playerid, COLOR_WHITE, string);
        OnBenz[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 3);
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] +=200;
		stockjobinfosave(stockjobinfoid);
        gen1m += generateurprix;
    }
    else if(pickupid == genpickup[1])
    {
        new string[128],salairejobinfoid,generateurprix = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur],kanistrab = 200,stockjobinfoid;
        if(OnGener[playerid] != 2) return 1;
        if(OnGen2 != 1) return 1;
        if(OnBenz[playerid] != 1) return 1;
        if(gen2 >= 299880) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Attendez un peu plus...");
        format(string, sizeof(string), "Vous avez rajouter %d litres d'essence dans le générateur.",kanistrab);
        SendClientMessage(playerid, COLOR_WHITE, string);
        OnBenz[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 3);
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] +=200;
		stockjobinfosave(stockjobinfoid);
        gen2m += generateurprix;
    }
    else if(pickupid == genpickup[2])
    {
        new string[128],salairejobinfoid,generateurprix = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur],kanistrab = 200,stockjobinfoid;
        if(OnGener[playerid] != 3) return 1;
        if(OnGen3 != 1) return 1;
        if(OnBenz[playerid] != 1) return 1;
        if(gen3 >= 299880) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Attendez un peu plus...");
        format(string, sizeof(string), "Vous avez rajouter %d litres d'essence dans le générateur.",kanistrab);
        SendClientMessage(playerid, COLOR_WHITE, string);
        OnBenz[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 3);
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] +=200;
		stockjobinfosave(stockjobinfoid);
        gen3m += generateurprix;
    }
    else if(pickupid == genpickup[3])
    {
        new string[128],salairejobinfoid,generateurprix = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur],kanistrab = 200,stockjobinfoid;
        if(OnGener[playerid] != 4) return 1;
        if(OnGen4 != 1) return 1;
        if(OnBenz[playerid] != 1) return 1;
        if(gen4 >= 299880) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Attendez un peu plus...");
        format(string, sizeof(string), "Vous avez rajouter %d litres d'essence dans le générateur.",kanistrab);
        SendClientMessage(playerid, COLOR_WHITE, string);
        OnBenz[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 3);
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] +=200;
		stockjobinfosave(stockjobinfoid);
        gen4m += generateurprix;
    }
    else if(pickupid == genpickup[4])
    {
        new string[128],salairejobinfoid,generateurprix = info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur],kanistrab = 200,stockjobinfoid;
        if(OnGener[playerid] != 5) return 1;
        if(OnGen5 != 1) return 1;
        if(OnBenz[playerid] != 1) return 1;
        if(gen5 >= 299880) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}[ERREUR]{FFFFFF} Attendez un peu plus...");
        format(string, sizeof(string), "Vous avez rajouter %d litres d'essence dans le générateur.",kanistrab);
        SendClientMessage(playerid, COLOR_WHITE, string);
        OnBenz[playerid] = 0;
        RemovePlayerAttachedObject(playerid, 3);
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] +=200;
		stockjobinfosave(stockjobinfoid);
        gen5m += generateurprix;
    }
    //job electricien
    for(new i; i<4; i++)
    {
        if(pickupid == Elektrik[i])
        {
            new stockjobinfoid;
            if (PlayerData[playerid][pJob] != JOB_ELECTRICIEN)
	    		return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
            if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"Il n'y a plus d'électricité dans le pays central générateur hors service");
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 0, 0, 0, 0);
            TogglePlayerControllable(playerid, 0);
            SetTimerEx("ElektrikbyLev", 7000, false, "i", playerid);
            GameTextForPlayer(playerid, "EN COUR DE REPARATION...", 7000,3);
        }
    }
    //job usine
    if(pickupid == rabot[0])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2558.41, -1292.01, 1044.08, 0.00, 0.00, 179.09);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2558.46, -1291.99, 1044.14, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2558.51, -1292.00, 1044.13, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,180.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[1])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2556.01, -1292.00, 1044.12, 0.00, 0.00, -179.49);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2556.10, -1291.99, 1044.14, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2556.18, -1292.02, 1044.16, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,180.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[2])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2553.67, -1292.00, 1044.07, 0.00, 0.00, 177.99);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2553.86, -1292.00, 1044.13, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2553.81, -1291.98, 1044.14, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,180.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[3])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2544.31, -1291.96, 1044.06, 0.00, 0.00, 179.19);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2544.37, -1291.97, 1044.14, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2544.38, -1291.99, 1044.18, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,180.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[4])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2541.96, -1291.91, 1044.14, 0.00, 0.00, 176.69);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2542.07, -1292.01, 1044.13, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2541.90, -1292.01, 1044.14, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,180.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[5])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2542.17, -1294.95, 1044.11, 0.00, 0.00, 0.00);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2542.11, -1294.84, 1044.15, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2542.07, -1294.85, 1044.12, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,0.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[6])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2544.47, -1294.89, 1044.08, 0.00, 0.00, 0.00);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2544.41, -1294.85, 1044.13, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2544.48, -1294.85, 1044.12, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,0.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[7])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2553.85, -1294.92, 1044.07, 0.00, 0.00, 0.00);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2553.88, -1294.91, 1044.19, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2553.90, -1294.85, 1044.12, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,0.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[8])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2556.22, -1294.92, 1044.06, 0.00, 0.00, 0.00);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2556.16, -1294.85, 1044.13, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2556.16, -1294.84, 1044.16, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,0.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == rabot[9])
    {
        if(ZavodObj[playerid] > 0) return true;
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 2) return SendClientMessage(playerid,COLOR_GREY,"Vous ne disposez pas de pièces, allez au pick-up jaune.");
        SetPlayerSpecialAction(playerid,0);
        RemovePlayerAttachedObject(playerid,1);
        switch(random(2))
        {
            case 0: ZavodObj[playerid] = CreateDynamicObject(2103, 2558.48, -1294.87, 1044.03, 0.00, 0.00, 0.00);
            case 1: ZavodObj[playerid] = CreateDynamicObject(1790, 2558.56, -1294.84, 1044.15, 0.00, 0.00, 0.00);
            case 2: ZavodObj[playerid] = CreateDynamicObject(2028, 2558.61, -1294.89, 1044.19, 0.00, 0.00, 0.00);
        }
        ApplyAnimation(playerid, "OTB", "BETSLP_LOOP", 4.1, 1, 0, 0, 0, 0);
        SetPlayerAttachedObject(playerid, 2, 6, 18644);
        SetPlayerFacingAngle(playerid,0.0000);
        SetPlayerAttachedObject(playerid, 1, 18635, 5, 0.036999, 0.071999, 0.000000, 155.000000, 0.000000, 0.000000, 1.000000, 1.00, 1.000000);
        SetTimerEx("UnivPub", 20000, false, "d", playerid);
    }
    if(pickupid == brat[7])
    {
        if (PlayerData[playerid][pJob] != JOB_USINE)
  			return SendErrorMessage(playerid, "Vous avez pas le job approprié.");
        if(Zavod[playerid] > 0) Dialog_Show(playerid, jobusine, DIALOG_STYLE_MSGBOX, "Usine électronic", "{FFFFFF}Voulez vous finir de travaillé et obtenir l'argent?","Oui","Non");
        else Dialog_Show(playerid, jobusine, DIALOG_STYLE_MSGBOX, "Usine électronic", "{FFFFFF}Voulez vous commencer à travailler?","Oui","Non");
    }
    if(pickupid == brat[6] || pickupid == brat[8])
    {
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] != 3) return SendClientMessage(playerid,COLOR_GREY,"Vous n'avez rien fabriqué.");
        Zavod[playerid] = 1;
        Sklad+= 40;
        //SetTimer("updatezavod", 1000, false);
        ZavodIn[playerid]++;
        RemovePlayerAttachedObject(playerid,1);
        static const fmt_str[] = "~g~Objet fabriquer ~w~%i";
        new str[sizeof(fmt_str)+3];
        format(str, sizeof(str), fmt_str,ZavodIn[playerid]);
        GameTextForPlayer(playerid,str,500, 1);
        new stockjobinfoid;
		info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic] += 1;
		stockjobinfosave(stockjobinfoid);
		Updateelectronic();
        SetPlayerSpecialAction(playerid,0);
        //ApplyAnimation(playerid,"CARRY","PUTDWN",4.1,0,1,1,0,1);
        ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.1, 0, 0, 0, 0, 0,1);
    }
    if(pickupid >= brat[0] && pickupid <= brat[5])
    {
        if(Zavod[playerid] == 0) return SendClientMessage(playerid,COLOR_GREY,"Allez vous mettre en tenue avant de commencer a travailler.");
        if(Zavod[playerid] == 2) return SendClientMessage(playerid,COLOR_GREY,"Vous avez déjas le matériel n'esserre");
        SetPlayerAttachedObject(playerid, 1, 1575, 1, -0.073000, 0.358000, -0.032000, 0.000000, 87.999961, 0.000000, 1.000000, 1.00, 1.000000);
        SetPlayerSpecialAction(playerid,25);
        Zavod[playerid] = 2;
        SendClientMessage(playerid,COLOR_GREEN ,"Vous avez pris les pièces nécessaire pour votre fabrication, allez devant une table.");
    }
    //job
    if(pickupid == gunjob)
    {
        if (PlayerData[playerid][pJob] != JOB_FRABRIEARME)
	    return SendErrorMessage(playerid, "Vous avez pas le job de fabrication d'arme.");
        if(GetPVarInt(playerid, "Gunjob") == 0) Dialog_Show(playerid, D_GUNJOB, 0, "Collectionneur d'armes", "Voulez-vous vraiment commencer à travailler?", "Oui", "Non");
        else Dialog_Show(playerid, D_GUNCJOB, 0, "Collectionneur d'armes", "Voulez-vous vraiment quitter?", "Oui", "Non");
    }
    //bhowling
	PickupBowlingHelp(playerid,pickupid);
	return 1;
}
script Gunjobanim(playerid)
{
	RemovePlayerAttachedObject(playerid,3);
	ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
	SetPlayerAttachedObject(playerid,3,2969,1,0.075578,0.407083,0.000000,1.248928,97.393852,359.645050,1.000000,1.000000,1.000000);
	SetPVarInt(playerid, "Gjob",3);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "Armes collectées. Suivez à la boutique.");
	SetPlayerCheckpoint(playerid,2325.8608, 8.3365, 1026.4464,1.5);
	return 1;
}
//Job boucher
script meattimer(playerid)
{
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
	SetPlayerAttachedObject(playerid, 6, 2804, 5, 0.01, 0.1, 0.2, 100, 10, 85);
	RemovePlayerAttachedObject(playerid,6);
	SetPlayerCheckpoint(playerid,958.9435,2172.8105,1011.0234,1.0);
	SetPVarInt(playerid, "meatbhp",1);
	KillTimer(AnimTimer);
	return 1;
}
//bots a mettre dans vw et int 0 car sinon fonctionne pas
script LoadActors()
{
    new rows,fields,temp[50];
    cache_get_data(rows, fields);
    for (new i = 0; i < rows; i ++) if (i < MAX_ACTORS)
    {
        ActorInfo[i][aID] = cache_get_field_int(i, "ID");
        ActorInfo[i][aSkinModel] = cache_get_field_int(i, "Skinid");
        ActorInfo[i][actorint] = cache_get_field_int(i, "actorint");
		ActorInfo[i][actorvw] = cache_get_field_int(i, "actorvw");
        cache_get_field_content(i,"actorsetting",temp), ActorInfo[i][actorsetting] = strval(temp);
		cache_get_field_content(i, "Float", temp),  	sscanf(temp, "p<|>a<f>[4]", ActorInfo[i][aFloat]);
		//SetActorVirtualWorld(i,ActorInfo[i][actorvw]);
        CreateActor(ActorInfo[i][aSkinModel], ActorInfo[i][aFloat][0], ActorInfo[i][aFloat][1], ActorInfo[i][aFloat][2], ActorInfo[i][aFloat][3]);
		TotalActors++;
    }
    return true;
}
//job usine
script UnivPub(playerid)
{
    ClearAnimations(playerid);
    DestroyDynamicObject(ZavodObj[playerid]);
    Zavod[playerid] = 3;
    TogglePlayerControllable(playerid, 1);
    RemovePlayerAttachedObject(playerid,1),RemovePlayerAttachedObject(playerid,2);
    SetPlayerAttachedObject(playerid, 1, 1575, 1, -0.073000, 0.358000, -0.032000, 0.000000, 87.999961, 0.000000, 1.000000, 1.00, 1.000000);
    SetPlayerSpecialAction(playerid,25);
    SendClientMessage(playerid,COLOR_GREEN,"Assemblage des pièces terminé. Allez déposé votre produit sur la palette de stockage (sachet blanc).");
    ZavodObj[playerid] = 0;
}
//job generator
script ThreeSecondTimer()
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			if(OnGen1 == 1)
			{
				//gen1m += 2;
				gen1 -= 1;
				if(gen1 == 0)
				{
					if(OnGener[i] == 1)
					{
						SendClientMessage(i,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Par votre faute les villes au alentour non plus suffisament d'électricité! Vous êtes Viré!");
						gen1m = 0;
						new stockjobinfoid;
						new generatorstock1 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral1];
						gen1 = generatorstock1;
						OnGener[i] = 0;
						OnGen1 = 0;
						OnBenz[i] = 0;
					}
				}
			}
			if(OnGen2 == 1)
			{
				//gen2m += 2;
				gen2 -= 1;
				if(gen2 == 0)
				{
					if(OnGener[i] == 2)
					{
						SendClientMessage(i,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Par votre faute les villes au alentour non plus suffisament d'électricité! Vous êtes Viré!");
						gen2m = 0;
						new stockjobinfoid;
						new generatorstock2 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral2];
						gen2 = generatorstock2;
						OnGener[i] = 0;
						OnGen2 = 0;
						OnBenz[i] = 0;
					}
				}
			}
			if(OnGen3 == 1)
			{
				//gen3m += 2;
				gen3 -= 1;
				if(gen3 == 0)
				{
					if(OnGener[i] == 3)
					{
						SendClientMessage(i,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Par votre faute les villes au alentour non plus suffisament d'électricité! Vous êtes Viré!");
						gen3m = 0;
						new stockjobinfoid;
						new generatorstock3 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral3];
						gen3 = generatorstock3;
						OnGener[i] = 0;
						OnGen3 = 0;
						OnBenz[i] = 0;
					}
				}
			}
			if(OnGen4 == 1)
			{
				//gen4m += 2;
				gen4 -= 1;
				if(gen4 == 0)
				{
					if(OnGener[i] == 4)
					{
						SendClientMessage(i,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Par votre faute les villes au alentour non plus suffisament d'électricité! Vous êtes Viré!");
						gen4m = 0;
						new stockjobinfoid;
						new generatorstock4 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral4];
						gen4 = generatorstock4;
						OnGener[i] = 0;
						OnGen4 = 0;
						OnBenz[i] = 0;
					}
				}
			}
			if(OnGen5 == 1)
			{
				//gen5m += 2;
				gen5 -= 1;
				if(gen5 == 0)
				{
					if(OnGener[i] == 5)
					{
						SendClientMessage(i,COLOR_WHITE,"{e3be88}[Directeur]:{ffffff} Par votre faute les villes au alentour non plus suffisament d'électricité! Vous êtes Viré!");
						gen5m = 0;
						new stockjobinfoid;
						new generatorstock5 = info_stockjobinfo[stockjobinfoid][stockjobinfocentral5];
						gen5 = generatorstock5;
						OnGener[i] = 0;
						OnGen5 = 0;
						OnBenz[i] = 0;
					}
				}
			}
		}
	}
	UpdateGeneratori();
	return 1;
}
//job petrolier
script PreWoodLoaded(playerid)
{
    GameTextForPlayer(playerid, "~g~S'il-Vous-Plait, Attendez", 1000,3);
    RemovePlayerAttachedObject(playerid,6);
    RemovePlayerAttachedObject(playerid,4);
    ClearAnimations(playerid);
    SetPlayerAttachedObject(playerid, 4,935, 1, 0.350699, 0.500000, 0.000000, 259.531341, 30.949592, 0.000000, 0.476124, 0.468181, 0.470769);
    SetPVarInt(playerid,"pForestJob",2);
    SetPlayerCheckpoint(playerid,638.3510,1248.0730,11.6559,1.0);
    return 1;
}
//job electricien
script ElektrikbyLev(playerid)
{
    new x = random(3),salairejobinfoid,electricienprix = info_salairejobinfo[salairejobinfoid][salairejobinfoelectricien];
    switch(x)
	{
		case 0:
		{
			GiveMoney(playerid,electricienprix);
			SendJOBMessage(playerid, "Vous avez réussit a réparer une dès Centrale électrique, vous avez gagné %d dollars.", electricienprix);		}
		case 1:
		{
			new Float:hp;
			GetPlayerHealth(playerid,hp);
			SendJOBMessage(playerid, "Échec: Vous avez reçu un choc électrique et vous n'avez pas réussit a réparer une dès Centrale... Faite attention!!");
			SendJOBMessage(playerid, "Vous n'avez pas gagner d'argent!");
			SetPlayerHealth(playerid, hp-13);
		}
		case 2:
		{
		    GiveMoney(playerid,electricienprix);
		    SendJOBMessage(playerid, "Vous avez réussit a réparer une dès Centrale électrique, vous avez gagné %d dollars.", electricienprix);		}
	}
    TogglePlayerControllable(playerid, 1);
	ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,0,0,0,0,0,1);
}
//stock job
script stockjobinfoload()
{
    new query[900];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM factorystock");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new stockjobinfoid = 0; stockjobinfoid < cache_get_row_count(); stockjobinfoid++)
	{
	    info_stockjobinfo[stockjobinfoid][stockjobinfoidd] = cache_get_field_content_int(stockjobinfoid,"id");
	    info_stockjobinfo[stockjobinfoid][stockjobinfobois] = cache_get_field_content_int(stockjobinfoid,"bois");
		info_stockjobinfo[stockjobinfoid][stockjobinfoviande] = cache_get_field_content_int(stockjobinfoid,"viande");
		info_stockjobinfo[stockjobinfoid][stockjobinfomeuble] = cache_get_field_content_int(stockjobinfoid,"meuble");
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = cache_get_field_content_int(stockjobinfoid,"central1");
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = cache_get_field_content_int(stockjobinfoid,"central2");
	    info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = cache_get_field_content_int(stockjobinfoid,"central3");
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = cache_get_field_content_int(stockjobinfoid,"central4");
		info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = cache_get_field_content_int(stockjobinfoid,"central5");
		info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic] = cache_get_field_content_int(stockjobinfoid,"electronic");
		info_stockjobinfo[stockjobinfoid][stockjobinfopetrol] = cache_get_field_content_int(stockjobinfoid,"petrol");
		info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator] = cache_get_field_content_int(stockjobinfoid,"essencegenerator");
		info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble] = cache_get_field_content_int(stockjobinfoid,"boismeuble");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin] = cache_get_field_content_int(stockjobinfoid,"magasinstock");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockdock] = cache_get_field_content_int(stockjobinfoid,"dockstock");
		info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter] = cache_get_field_content_int(stockjobinfoid,"manutentionnairestock");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste] = cache_get_field_content_int(stockjobinfoid,"caristestock");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockminer] = cache_get_field_content_int(stockjobinfoid,"minerstock");
		info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes] = cache_get_field_content_int(stockjobinfoid,"armesstock");
	    info_stockjobinfo[stockjobinfoid][stocktunningfrontbumper] = cache_get_field_content_int(stockjobinfoid,"frontbumper");
		info_stockjobinfo[stockjobinfoid][stocktunningrearbumper] = cache_get_field_content_int(stockjobinfoid,"rearbumper");
		info_stockjobinfo[stockjobinfoid][stocktunningroof] = cache_get_field_content_int(stockjobinfoid,"roof");
		info_stockjobinfo[stockjobinfoid][stocktunninghood] = cache_get_field_content_int(stockjobinfoid,"hood");
		info_stockjobinfo[stockjobinfoid][stocktunningspoiler] = cache_get_field_content_int(stockjobinfoid,"spoiler");
		info_stockjobinfo[stockjobinfoid][stocktunningsideskirt] = cache_get_field_content_int(stockjobinfoid,"sideskirt");
		info_stockjobinfo[stockjobinfoid][stocktunninghydrolic] = cache_get_field_content_int(stockjobinfoid,"hydrolic");
		info_stockjobinfo[stockjobinfoid][stocktunningroue] = cache_get_field_content_int(stockjobinfoid,"roue");
		info_stockjobinfo[stockjobinfoid][stocktunningcaro] = cache_get_field_content_int(stockjobinfoid,"caro");
	}
	cache_delete(result);
}
script stockjobinfosave(stockjobinfoid)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE `factorystock` SET `bois`='%d', `viande`='%d', `meuble`='%d', `central1`='%d', `central2`='%d', `central3`='%d', `central4`='%d', `central5`='%d', `electronic`='%d', `petrol`='%d', `essencegenerator`=%d, `boismeuble`=%d, `magasinstock`=%d, `dockstock`=%d, `manutentionnairestock`=%d, `caristestock`=%d, `minerstock`=%d, `armesstock`=%d,`frontbumper`=%d, rearbumper=%d, roof=%d, hood=%d, spoiler=%d, sideskirt=%d, hydrolic=%d, roue=%d, caro=%d WHERE id='1'",
	info_stockjobinfo[stockjobinfoid][stockjobinfobois],
	info_stockjobinfo[stockjobinfoid][stockjobinfoviande],
	info_stockjobinfo[stockjobinfoid][stockjobinfomeuble],
	info_stockjobinfo[stockjobinfoid][stockjobinfocentral1],
	info_stockjobinfo[stockjobinfoid][stockjobinfocentral2],
	info_stockjobinfo[stockjobinfoid][stockjobinfocentral3],
	info_stockjobinfo[stockjobinfoid][stockjobinfocentral4],
	info_stockjobinfo[stockjobinfoid][stockjobinfocentral5],
	info_stockjobinfo[stockjobinfoid][stockjobinfoelectronic],
	info_stockjobinfo[stockjobinfoid][stockjobinfopetrol],
	info_stockjobinfo[stockjobinfoid][stockjobinfoessencegenerator],
	info_stockjobinfo[stockjobinfoid][stockjobinfoboismeuble],
	info_stockjobinfo[stockjobinfoid][stockjobinfostockmagasin],
	info_stockjobinfo[stockjobinfoid][stockjobinfostockdock],
	info_stockjobinfo[stockjobinfoid][stockjobinfostocksorter],
	info_stockjobinfo[stockjobinfoid][stockjobinfostockcariste],
	info_stockjobinfo[stockjobinfoid][stockjobinfostockminer],
	info_stockjobinfo[stockjobinfoid][stockjobinfostockarmes],
	info_stockjobinfo[stockjobinfoid][stocktunningfrontbumper],
	info_stockjobinfo[stockjobinfoid][stocktunningrearbumper],
	info_stockjobinfo[stockjobinfoid][stocktunningroof],
	info_stockjobinfo[stockjobinfoid][stocktunninghood],
	info_stockjobinfo[stockjobinfoid][stocktunningspoiler],
	info_stockjobinfo[stockjobinfoid][stocktunningsideskirt],
	info_stockjobinfo[stockjobinfoid][stocktunninghydrolic],
	info_stockjobinfo[stockjobinfoid][stocktunningroue],
	info_stockjobinfo[stockjobinfoid][stocktunningcaro]);
    mysql_tquery(g_iHandle, query);
}
//slot machine
script UpdateMachineTD(playerid)
{
	static slot[3];
	new string[64],count;
	repeats[playerid] += 1;
	if(repeats[playerid] <= 50)
	{
		for(new i; i < sizeof(machineTD); i++)
		{
			slot[i] = random(sizeof(TDslots));
			format(string, sizeof(string), "%s", TDslots[slot[i]]);
			PlayerTextDrawSetString(playerid, machineTD[i+1][playerid], string);
		}
		return 1;
	}
	if(repeats[playerid] >= 60)
	{
		KillTimer(timerslot[playerid]);
		for(new i; i < sizeof(machineTD); i++) PlayerTextDrawDestroy(playerid, machineTD[i][playerid]);
		repeats[playerid] = 0;
		if(slot[0] == slot[1] &&  slot[1] == slot[2])
		{
			GiveMoney(playerid, MONEY_WIN);
			GameTextForPlayer(playerid, "~g~Vous avez gagner 10 fois votre mise!", 2000, 3);
			for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
				count++;
			}
			for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
			{
				new aye = MONEY_WIN / count;
				if(FactionData[ii][factionacces][12] == 1)
				{
					FactionData[ii][factioncoffre] -= aye;
					Faction_Save(ii);
				}
			}
		}
		else {GameTextForPlayer(playerid, "~r~Vous avez perdu!", 2000, 3);}
		TogglePlayerControllable(playerid, 1);
		return 1;
	}
	return 1;
}
script slotmachineload()
{
    new query[600],string2[64];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM slotmachine");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new slotmachineid = 0; slotmachineid < cache_get_row_count(); slotmachineid++) if (slotmachineid < MAX_MACHINES)
	{
	    machine[slotmachineid][iidd] = cache_get_field_content_int(slotmachineid,"id");
		machine[slotmachineid][pospos][0] = cache_get_field_float(slotmachineid,"X");
		machine[slotmachineid][pospos][1] = cache_get_field_float(slotmachineid,"Y");
		machine[slotmachineid][pospos][2] = cache_get_field_float(slotmachineid,"Z");
		machine[slotmachineid][pospos][3] = cache_get_field_float(slotmachineid,"RX");
		machine[slotmachineid][pospos][4] = cache_get_field_float(slotmachineid,"RY");
	    machine[slotmachineid][pospos][5] = cache_get_field_float(slotmachineid,"RZ");
	    machine[slotmachineid][slotint] = cache_get_field_int(slotmachineid,"slotint");
		machine[slotmachineid][slotvw] = cache_get_field_int(slotmachineid,"slotvw");
	    //if(machine[slotmachineid][created] <= 0) {
		machine[slotmachineid][object] = CreateDynamicObject(2325, machine[slotmachineid][pospos][0], machine[slotmachineid][pospos][1], machine[slotmachineid][pospos][2], machine[slotmachineid][pospos][3], machine[slotmachineid][pospos][4], machine[slotmachineid][pospos][5],machine[slotmachineid][slotvw],machine[slotmachineid][slotint]);
		format(string2, sizeof(string2), "[Machine ID: %d]\nAppuyer sur F pour jouer", machine[slotmachineid][iidd]);
		machine[slotmachineid][text3d] = CreateDynamic3DTextLabel(string2, 0x00FF00FF, machine[slotmachineid][pospos][0], machine[slotmachineid][pospos][1], machine[slotmachineid][pospos][2]+1.0, 3,INVALID_PLAYER_ID, INVALID_VEHICLE_ID,0,machine[slotmachineid][slotvw],machine[slotmachineid][slotint]);
		//}
	}
	cache_delete(result);
}
//video pocker
script OnCasinoStart(playerid, machineid)
{
	new _type,stockjobinfoid;
	if (GetMachineType(machineid, _type))
	{
    	if(info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] == 0 && info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] == 0) return SendErrorMessage(playerid,"La machine vidéo poker est hors d'usage.");
		if (_type == CASINO_MACHINE_POKER)
		{
			SendClientMessage(playerid, 0xFF9900AA, "[CASINO]{FFFFFF} Bienvenue sur une des machines vidéo poker");
			SendClientMessage(playerid, 0xFF9900AA, "[CASINO]{FFFFFF} Si vous pariez 100$ vous pouvez gagner jusqu'a $400");
		}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] -= 1;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] -= 1;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] -= 1;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] -= 1;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] > 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] -= 1;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral1] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral2] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral3] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral4] = 0;}
		if( info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] < 0) {info_stockjobinfo[stockjobinfoid][stockjobinfocentral5] = 0;}
		stockjobinfosave(stockjobinfoid);
	}
	return 1;
}
script OnCasinoEnd(playerid, machineid)
{
	SendClientMessage(playerid, 0xFF9900AA, "[CASINO]{FFFFFF} Au revoir, Merci d'avoir jouer sur cette machine!");
	AFKMin[playerid] = 0;
}
script OnCasinoMessage(playerid, machineid, message[])
{
	new _msg[128];
	format(_msg, 128, "[CASINO] %s", message);
	SendClientMessage(playerid, 0xFF9900AA, _msg);
}
script OnCasinoMoney(playerid, machineid, amount, result)
{
	new message[128],count;
	if (result == CASINO_MONEY_CHARGE)
	{
		GiveMoney(playerid, (amount * -1));
		format(message, 128, "[CASINO]{FFFFFF}  Vous avez parier $%i", amount);
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
		{
			new aye = amount / count;
			if(FactionData[ii][factionacces][12] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
				Faction_Save(ii);
			}
		}
		AFKMin[playerid] = 0;
	}
	else if (result == CASINO_MONEY_WIN)
	{
		GiveMoney(playerid, amount);
		format(message, 128, "[CASINO]{FFFFFF} Vous avez gagné $%i", amount);
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
		{
			new aye = amount / count;
			if(FactionData[ii][factionacces][12] == 1)
			{
				FactionData[ii][factioncoffre] -= aye;
				Faction_Save(ii);
			}
		}
		AFKMin[playerid] = 0;
	}
	else if (result == CASINO_MONEY_NOTENOUGH)
	{
		format(message, 128, "[CASINO]{FFFFFF}  Vous n'avez pas $%i pour jouer!", amount);
		AFKMin[playerid] = 0;
	}
	SendClientMessage(playerid, 0xFF9900AA, message);
}
//salaire des job
script salairejobinfoload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM salairejob");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new salairejobinfoid = 0; salairejobinfoid < cache_get_row_count(); salairejobinfoid++)
	{
	    info_salairejobinfo[salairejobinfoid][salairejobinfoidd] = cache_get_field_content_int(salairejobinfoid,"id");
	    info_salairejobinfo[salairejobinfoid][salairejobinfocariste] = cache_get_field_content_int(salairejobinfoid,"salairecariste");
		info_salairejobinfo[salairejobinfoid][salairejobinfomanutentionnaire] = cache_get_field_content_int(salairejobinfoid,"salairemanutentionnaire");
		info_salairejobinfo[salairejobinfoid][salairejobinfodock] = cache_get_field_content_int(salairejobinfoid,"salairedock");
		info_salairejobinfo[salairejobinfoid][salairejobinfominer] = cache_get_field_content_int(salairejobinfoid,"salaireminer");
		info_salairejobinfo[salairejobinfoid][salairejobinfoelectronic] = cache_get_field_content_int(salairejobinfoid,"salaireusineelectronic");
		info_salairejobinfo[salairejobinfoid][salairejobinfobucheron] = cache_get_field_content_int(salairejobinfoid,"salairebucheron");
		info_salairejobinfo[salairejobinfoid][salairejobinfomenuisier] = cache_get_field_content_int(salairejobinfoid,"salairemenuisier");
		info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur] = cache_get_field_content_int(salairejobinfoid,"salairegenerateur");
		info_salairejobinfo[salairejobinfoid][salairejobinfoelectricien] = cache_get_field_content_int(salairejobinfoid,"salaireelectricien");
		info_salairejobinfo[salairejobinfoid][salairejobinfoarme] = cache_get_field_content_int(salairejobinfoid,"salairearme");
		info_salairejobinfo[salairejobinfoid][salairejobinfopetrolier] = cache_get_field_content_int(salairejobinfoid,"salairepetrolier");
		info_salairejobinfo[salairejobinfoid][salairejobinfoboucher] = cache_get_field_content_int(salairejobinfoid,"salaireboucher");
	}
	cache_delete(result);
}
script salairejobinfosave(salairejobinfoid)
{
	new query[900];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE salairejob SET salairecariste=%d, salairemanutentionnaire=%d, salairedock=%d, salaireminer=%d, salaireusineelectronic=%d, salairebucheron=%d, salairemenuisier=%d, salairegenerateur=%d, salaireelectricien=%d, salairearme=%d, salairepetrolier=%d, salaireboucher=%d WHERE id='1'",
	info_salairejobinfo[salairejobinfoid][salairejobinfocariste],
	info_salairejobinfo[salairejobinfoid][salairejobinfomanutentionnaire],
	info_salairejobinfo[salairejobinfoid][salairejobinfodock],
	info_salairejobinfo[salairejobinfoid][salairejobinfominer],
	info_salairejobinfo[salairejobinfoid][salairejobinfoelectronic],
	info_salairejobinfo[salairejobinfoid][salairejobinfobucheron],
	info_salairejobinfo[salairejobinfoid][salairejobinfomenuisier],
	info_salairejobinfo[salairejobinfoid][salairejobinfogenerateur],
	info_salairejobinfo[salairejobinfoid][salairejobinfoelectricien],
	info_salairejobinfo[salairejobinfoid][salairejobinfoarme],
	info_salairejobinfo[salairejobinfoid][salairejobinfopetrolier],
	info_salairejobinfo[salairejobinfoid][salairejobinfoboucher]);
    mysql_tquery(g_iHandle, query);
}
//afk
script AFK()
{
	new Float:x,Float:y,Float:z;
 	new serveursettinginfoid;
	foreach (new i : Player)
	{
	    if(IsPlayerConnected(i))
	    {
     		if(!IsPlayerAdmin(i) && !IsPlayerNPC(i))
       		{
       		    GetPlayerPos(i,x,y,z);
	    		if(AFKPos[i][1] == 0)
		    	{
		         	AFKPos[i][0] = x;
				  	AFKPos[i][1] = y;
			  		AFKPos[i][2] = z;
				}
				else if(x == AFKPos[i][0] && y == AFKPos[i][1] && z == AFKPos[i][2])
				{
				    AFKMaxMin = info_serveursettinginfo[serveursettinginfoid][settingafktime];
				    AFKMin[i]++;
				    if(AFKMin[i] >=  AFKMaxMin)
				    {
		   			   	SendErrorMessage(i,"Afk trop longtemps kick.");
		   			   	KickEx(i);
					}
				}
  				AFKPos[i][0] = x;
	  			AFKPos[i][1] = y;
		  		AFKPos[i][2] = z;
			}
		}
	}
	return 1;
}
//dynamite boom
script DynamiteTime(){
    CreateExplosion(Float:dx, Float:dy, Float:dz, 0, 15.0);
    CreateExplosion(Float:dx, Float:dy, Float:dz, 1, 15.0);
    CreateExplosion(Float:dx+3.5, Float:dy+3.5, Float:dz+3.5, 1, 15.0);
    CreateExplosion(Float:dx-3.5, Float:dy-3.5, Float:dz, 1, 15.0);
    CreateExplosion(Float:dx+3.5, Float:dy-3.5, Float:dz, 1, 15.0);
    CreateExplosion(Float:dx-3.5, Float:dy+3.5, Float:dz, 1, 15.0);
    DestroyDynamicObject(dynamiteobject);
}
//bank
script startonboom(playerid)
{
    new Float:oobjx, Float:oobjy, Float:oobjz,Float:ooobjx, Float:ooobjy, Float:ooobjz,factionid = PlayerData[playerid][pFaction];
    if(IsPlayerInRangeOfPoint(playerid,30.0,1435.4064,-981.1826,983.6462))
    {
	    GetObjectPos(vaultdoor, ooobjx, ooobjy, ooobjz);
	    CreateExplosion(1435.4064,-981.1826,983.6462, 1, 15.0);
	    CreateExplosion(1433.4064,-981.1826,983.6462, 1, 15.0);
	    DestroyDynamicObject(objectbank[playerid]);
	    DestroyDynamicObject(vaultdoor);
	    foreach (new i : Player)
		{
			new bizid = Entrance_Inside(playerid);
			if (IsACopm(i)) {Waypoint_Set(i, "Explosion a une banque", EntranceData[bizid][entrancePos][0], EntranceData[bizid][entrancePos][1], EntranceData[bizid][entrancePos][2]);}
			if(FactionData[factionid][factionacces][1] == 1)
			{
				SendServerMessage(playerid,"RADIO: Une explosion c'est fait entendre à %s (marquée sur la carte).", EntranceData[bizid][entranceName]);
			}
		}
    }
    GetObjectPos(objectbank[playerid], oobjx, oobjy, oobjz);
    CreateExplosion(1437.4064,-981.1826,983.6462, 1, 15.0);
    DestroyDynamicObject(objectbank[playerid]);
    SetTimerEx("vaultdoors",300000,0,"d",playerid);
}
script vaultdoors(playerid)
{
	vaultdoor = CreateDynamicObject(2634, 1435.35193, -980.29688, 984.21887, 0.00000, 0.00000, 179.04001);
	portevol = 1;
	SetTimer("volok",3600000,false);
}
script volok(){portevol = 0; print("Vol de banque mis a zero");}
script remplissagesac(playerid)
{
    if (ReturnHealth(playerid) < 0) return SendServerMessage(playerid,"Vous êtes mort donc le braquage s'arrete la."); start1[playerid] = 0;
	new moneyentrepriseid;
	if(!IsPlayerInRangeOfPoint(playerid,10,1435.7437, -971.5178, 983.1413)) return SendServerMessage(playerid,"Vous avez bouger de l'endroit braquage échouer."); start1[playerid] = 0;
    //if(start1[playerid] != 1);
	new id = Inventory_Add(playerid, "argent sale", 1212,argent_entreprise[moneyentrepriseid][argentbanque]);
	if (id == -1)
		return SendErrorMessage(playerid, "Inventaire plein.");
	SendServerMessage(playerid,"Un montant de %s$ vous avez recus en braquant la banque.",FormatNumber(argent_entreprise[moneyentrepriseid][argentbanque]));
	argent_entreprise[moneyentrepriseid][argentbanque] = 0;
	moneyentreprisesave(moneyentrepriseid);
	start1[playerid] = 0;
	return 1;
}
//vole veh
script TrafiqueFils(playerid)
{
	if(TrafiqueFilsTimer[playerid] > 1)
	{
	    KillTimer(TrafiqueFilsKillTimer[playerid]);
	    new string[60];
	    TrafiqueFilsTimer[playerid] --;
	    format(string, sizeof(string), "~r~%d ~w~secondes ...", TrafiqueFilsTimer[playerid]);
	    GameTextForPlayer(playerid, string, 2000, 5);
	    TrafiqueFilsKillTimer[playerid] = SetTimerEx("TrafiqueFils", 1000, false, "i", playerid);
	}
	else if(TrafiqueFilsTimer[playerid] <= 1)
	{
	    KillTimer(TrafiqueFilsKillTimer[playerid]);
	    new vehicleid = GetPlayerVehicleID(playerid);
	    SetEngineStatus(vehicleid, true);
	    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s a réussi à trafiquer les fils.", ReturnName(playerid, 0));
   		TrafiqueFilsTimer[playerid] = 0;
	}
}
script OnPlayerTargetActor(playerid, newtarget, oldtarget)
{
    new facass = PlayerData[playerid][pFaction],moneyentrepriseid;
    if (newtarget == missionactor)
    {
	    if (FactionData[facass][factionacces][8] == 0)
	    	return SendClientMessage(playerid, COLOR_WHITE,"Albert : Tu veux quoi toi?");
		if (FactionData[facass][factionacces][8] == 1 && mission[playerid] == 0)
			return Dialog_Show(playerid, Mission, DIALOG_STYLE_MSGBOX, "Mission", "Salut toi, Tu veux avoir un peut d'argent?\nRapporte moi une caise de type Six\nSi tu veux tu peut gardé la marchandise ou\nme la rapporté pour avoir de l'argent", "Valider", "Quitter");
		else SendClientMessage(playerid,COLOR_WHITE,"Albert : Tu veux quoi?");
		if (mission[playerid] == 1 && Inventory_Count(playerid, "Graine marijuana") < 20 && Inventory_Count(playerid, "Graine cocaine") < 20 && Inventory_Count(playerid, "Graine Heroin Opium") < 10 && Inventory_Count(playerid, "Steroids") < 5)
		{
		    SendClientMessage(playerid, COLOR_WHITE,"Albert : Tu a besoin de 20 graine de marijuana.");
	        SendClientMessage(playerid, COLOR_WHITE,"Albert : Tu a besoin de 20 graine de cocaine.");
	        SendClientMessage(playerid, COLOR_WHITE,"Albert : Tu a besoin de 10 graine d'héroine.");
	        SendClientMessage(playerid, COLOR_WHITE,"Albert : Tu a besoin de 5 Steroids.");
	        return 1;
		}
		Inventory_Remove(playerid, "Steroids", 5);
		Inventory_Remove(playerid, "Graine cocaine", 20);
		Inventory_Remove(playerid, "Graine marijuana", 20);
		Inventory_Remove(playerid, "Graine Heroin Opium", 10);
		new money = random(150) + 100;
		SendServerMessage(playerid, "Vous avez gagné %d$ pour cette mission.", money);
		GiveMoney(playerid, money);
		SendClientMessage(playerid, COLOR_WHITE,"Albert : Merci le kid à la prochaine.");
		SendClientMessage(playerid, COLOR_WHITE,"Albert aller je me barre salut!");
	    DestroyActor(missionactor);
		switch (random(6))
		{
	    	case 0: missionactor = CreateActor(179, 2440.5027,-1975.7238,13.5469,266.3473);
	    	case 1: missionactor = CreateActor(179,2209.7893,-1185.1448,33.5313,250.7436);
	    	case 2: missionactor = CreateActor(179,-1843.5271,-1627.6521,21.7677,129.3315);
	    	case 3: missionactor = CreateActor(179,-1620.3467,1420.2213,7.1734,132.55611);
	    	case 4: missionactor = CreateActor(179,2346.2256,-1239.5133,22.5000,0.5437);
	    	case 5: missionactor = CreateActor(179,984.6139,-1613.4885,13.4954,93.7949);
		}
		mission[playerid] = 0;
    }
    if(newtarget == missionactor1)
    {
	    if (FactionData[facass][factionacces][8] == 0)
	    	return SendClientMessage(playerid, COLOR_WHITE,"James : Tu veux quoi toi?");
		if (FactionData[facass][factionacces][8] == 1 && mission1[playerid] == 0)
			return Dialog_Show(playerid, Mission1, DIALOG_STYLE_MSGBOX, "Mission", "Salut toi, Tu veux avoir un peut d'argent?\nVa mettre le feu a une place", "Valider", "Quitter");
		else SendClientMessage(playerid,COLOR_WHITE,"James : Tu veux quoi?");
		if (mission1[playerid] == 1)
		{
		    SendClientMessage(playerid, COLOR_WHITE,"James : Tu n'est pas aller mettre le feu comme convenu.");
	        return 1;
		}
		new money = random(150) + 100;
		SendServerMessage(playerid, "Vous avez gagné %d$ pour cette mission.", money);
		GiveMoney(playerid, money);
		SendClientMessage(playerid, COLOR_WHITE,"James : Merci le kid à la prochaine.");
		mission1[playerid] = 0;
	}
    if(newtarget == missionactor2)
	{
		SendServerMessage(playerid,"Jasmie : Alors on veux blanchir de l'argent?");
		new short123 = Inventory_Count(playerid, "argent sale");
		GiveMoney(playerid, short123/4);
		SendServerMessage(playerid,"Jasmie : Tien voila pour toi %d$",short123/10);
		Inventory_Remove(playerid, "argent sale",short123);
		SendServerMessage(playerid,"Jasmie : Aller bye-bye!");
		DestroyActor(missionactor2);
		switch (random(30))
		{
		   	case 0: missionactor2 = CreateActor(31,-2199.7209,-2338.7644,30.6250,77.9837);
		   	case 1: missionactor2 = CreateActor(31,-2054.5361,-2438.4902,30.6250,113.4559);
		   	case 2: missionactor2 = CreateActor(31,-1843.5271,-1627.6521,21.7677,129.3315);
		   	case 3: missionactor2 = CreateActor(31,-1620.3467,1420.2213,7.1734,132.55611);
			case 4: missionactor2 = CreateActor(31,-1743.5946,1540.8601,7.1875,4.2422); // pos 5
			case 5: missionactor2 = CreateActor(31,-1790.0234,1540.7908,7.1875,352.8316); // pos 6
			case 6: missionactor2 = CreateActor(31,-1835.5865,1540.7933,7.1875,12.6762); // pos 7
			case 7: missionactor2 = CreateActor(31,-2659.8215,1457.7629,49.5576,299.0931); // pos 8
			case 8: missionactor2 = CreateActor(31,-2237.3120,2475.0996,4.9844,182.0998); // pos 9
			case 9: missionactor2 = CreateActor(31,-2492.2644,2356.5688,10.2770,282.3647); // pos 10
			case 10: missionactor2 = CreateActor(31,-2529.0332,2352.6384,4.9844,0.2550); // pos 11
			case 11: missionactor2 = CreateActor(31,-2377.3723,2215.7188,4.9844,263.2643); // pos 12
			case 12: missionactor2 = CreateActor(31,-1723.6774,1243.2432,7.5469,65.8999); // pos 13
			case 13: missionactor2 = CreateActor(31,1516.8875,-1506.0033,13.5547,324.2364); // bot8
			case 14: missionactor2 = CreateActor(31,2621.9009,-2057.9226,13.5500,178.9987); // bot9
			case 15: missionactor2 = CreateActor(31,2738.2170,-1829.5782,11.8430,351.1509); // bot10
			case 16: missionactor2 = CreateActor(31,2668.5574,-1539.2067,25.1203,195.6187); // bot11
			case 17: missionactor2 = CreateActor(31,2762.1509,-1285.7408,41.7197,225.5658); // bot12
			case 18: missionactor2 = CreateActor(31,2767.0271,-1192.7881,69.4097,357.0363); // bot13
			case 19: missionactor2 = CreateActor(31,2788.7820,-1467.7402,40.0625,321.8119); // bot14
			case 20: missionactor2 = CreateActor(31,2791.5862,-1079.5629,30.7188,48.8802); // bot15
			case 21: missionactor2 = CreateActor(31,2412.8145,-1208.6603,29.3274,2.2453); // bot16
			case 22: missionactor2 = CreateActor(31,2331.0620,-1336.5182,24.0639,203.7363); // bot17
			case 23: missionactor2 = CreateActor(31,1972.8481,-1304.1487,20.8297,224.8212); // bot18
			case 24: missionactor2 = CreateActor(31,1228.031,-1889.8441,13.7815,28.0432); // bot19
			case 25: missionactor2 = CreateActor(31,1615.5521,-1779.6171,13.5315,111.6386); // bot20
			case 26: missionactor2 = CreateActor(31,1668.6542,-1641.1974,22.5251,319.7593); // bot22
			case 27: missionactor2 = CreateActor(31,1668.6469,-1632.4844,22.5217,204.6605); // bot23
			case 28: missionactor2 = CreateActor(31,1740.5454,-1540.5977,13.5511,311.0774); // bot24
			case 29: missionactor2 = CreateActor(31,1403.7306,-1298.5013,13.5460,236.3440); // bot25
		}
    }
    //All biz
    for (new i = 0; i < MAX_DYNAMIC_OBJ; i ++)
    {
		if(newtarget == ActorInfo[i][aID])
    	{cmd_acheter(playerid, "");}
    }
	//amendes
	if(newtarget == actorvendeuramendes[0]){cmd_amendes(playerid, "");}
	//permis
	if(newtarget == actorvendeurpermis[0]){cmd_passerpermis4321(playerid, "");}
	//mairie
	if(newtarget == actorvendeurmairie[0]){cmd_changename(playerid, "");}
	//banque
	if(newtarget == actorvendeurbanque[0]){cmd_banque(playerid, "");}
	if(newtarget == actorvendeurbanque[1]){cmd_banque(playerid, "");}
	if(newtarget == actorvendeurbanque[2]){cmd_banque(playerid, "");}
	if(newtarget == actorvendeurbanque[3]){cmd_banque(playerid, "");}
	//anpe
	if(newtarget == actorvendeuranpe[0]){cmd_cv(playerid,"");}
	//vote
	if(newtarget == HelpPic1[0])
	{
        new Name1[MAX_PLAYER_NAME],query[900];
        GetPlayerName(playerid, Name1, MAX_PLAYER_NAME);
        format(query,sizeof(query), "SELECT * FROM `votes` WHERE `Name` = '%s'", Name1);
        mysql_tquery(g_iHandle, query, "OnPlayerVoting", "d", playerid);
		return 1;
	}
    if(newtarget == armespolice)
    {
		if (FactionData[facass][factionacces][1] == 0)
			return SendServerMessage(playerid, "Vous êtes qui vous?");
		Dialog_Show(playerid, armepolice, DIALOG_STYLE_MSGBOX,"Jeff","Est-ce que vous vouler que je nettoye votre arme?", "Oui", "Non");
	}
    if(newtarget == soinbot)
    {
		if (FactionData[facass][factionacces][5] == 0)
			return SendServerMessage(playerid, "Vous êtes qui vous?");
		if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    	return SendErrorMessage(playerid, "Tu doit être minimum rang %d pour commander des trouse de soins.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
		if (argent_entreprise[moneyentrepriseid][argentmedecin] < 5000)
		    return SendErrorMessage(playerid, "Vous n'avez pas asser d'argent dans le coffre pour cette transation. (minimum 5000$)");
		if(mercco < 1) {ShowPlayerFooter(playerid, " Il n'a pas de livreur de marchandise"); return 1;}
		Dialog_Show(playerid, soinssoins, DIALOG_STYLE_MSGBOX,"Vous-vouler commander quoi?","Est-ce que vous vouler commander des trousses de soins (10) ?", "Oui", "Non");
	}
    if(newtarget == piececaisse)
    {
	    if (FactionData[facass][factionacces][13] == 0)
			return SendServerMessage(playerid, "Vous êtes qui vous?");
		if (FactionData[facass][factioncoffre] < 7500)
		    return SendErrorMessage(playerid, "Vous n'avez pas asser d'argent dans le coffre pour cette transation. (minimum 7500$)");
		if(mercco < 1) {ShowPlayerFooter(playerid, " Il n'a pas de livreur de marchandise"); return 1;}
		Dialog_Show(playerid, commande1, DIALOG_STYLE_LIST,"Vous-vouler commander quoi?","Commander pièce d'arme blanche\nCommander pièce de pistolet\nCommander pièce d'smg\nCommander pièce de shotgun\nCommander pièce de rifle\nCommander Matos", "Fermer", "");
	}
	if(newtarget == HelpPic1[1])
	{
        Dialog_Show(playerid,DIALOG_BOWLING, DIALOG_STYLE_LIST, "Bowling", "{00AA00}1. {FFFFFF}Prendre une allé \n{00AA00}2. {FFFFFF}Fin de la partie \n{00AA00}3. {FFFFFF}Ajouté plus de temps ", "Ok", "Fermer");
		return 1;
	}
	static actorid;
    if (actorid != INVALID_ACTOR_ID) {cmd_acheter(playerid, "");}
    if (oldtarget != INVALID_ACTOR_ID) {ClearActorAnimations(oldtarget);}
	return 1;
}
script OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z)
{
    if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 3)
    {
        new Float:health,idk = Car_GetID(vehicleid);
        GetVehicleHealth(vehicleid,health);
        if(health > 1000)
		{
			SetVehicleHealth(vehicleid,1000.0);
			CarData[idk][carvie] = 1000.0;
		}
        //SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: Cheateur détecté");
        RespawnVehicle(vehicleid);
        return 0;
    }
    return 1;
}
//VOTAGE
forward OnPlayerVoting(playerid);
script OnPlayerVoting(playerid)
{
    if(cache_get_row_count()) return SendErrorMessage(playerid, "Vous avez déja voté");
    ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0);
    SetPlayerAttachedObject(playerid, 8, 1277, 5, 0.25, 0, 0, 0, 0, 0);
    SendServerMessage(playerid, "Aller vous placer a une urne pour voter");
    Voting[playerid] = true;
	return 1;
}
forward LoadCandidates();
script LoadCandidates()
{
    NumberOfCandidates = cache_get_row_count();
    if(NumberOfCandidates > MAX_CANDIDATES) NumberOfCandidates = MAX_CANDIDATES;
    for(new i; i<NumberOfCandidates; i++)
	{
		cache_get_field_content(i, "Name", Candidates1[i], g_iHandle, sizeof(Candidates1[]));
    	Votes[i] = cache_get_field_content_int(i, "Votes", g_iHandle);
	}
}
script OnPlayerGiveDamageActor(playerid, damaged_actorid, Float: amount, weaponid, bodypart)
{
    new attacker[MAX_PLAYER_NAME],weaponname[24];
    GetPlayerName(playerid, attacker, sizeof (attacker));
    GetWeaponName(weaponid, weaponname, sizeof (weaponname));
    Log_Write("logs/actor_log.txt","%s has made %.0f damage to actor id %d, weapon: %s", attacker, amount, damaged_actorid, weaponname);
    return 1;
}
//baterie telephone
script Timephone()
{
    foreach(Player, i)
    {
        if(PlayerData[i][pAcom] > 0)
        {
            PlayerData[i][pAcom] --;
            if( PlayerData[i][pAcom] < 0) {PlayerData[i][pAcom] = 0;}
            switch(PlayerData[i][pAcom])
            {
                case 0:
                {
                    SendClientMessage(i, COLOR_GREY, "Votre batterie est complètement déchargée!");
                    SendClientMessage(i, COLOR_GREY, "Pour recharger votre batterie, utilisez la commande /recharger.");
                }
                case 5: SendClientMessage(i, COLOR_GREY, "Il vous reste 5 pourcent de batterie!");
                case 10: SendClientMessage(i, COLOR_GREY, "Il vous reste 10 pourcent de batterie!");
                case 15: SendClientMessage(i, COLOR_GREY, "Il vous reste 15 pourcent de batterie!");
            }
        }
    }
    return 1;
}
//airbreak
script OnPlayerAirbreak(playerid)
{
    if (IsPlayerInAnyVehicle(playerid))
    {
        SendAdminAlert(COLOR_ADMINCHAT, "** %s a été expulsé pour airbreak véhicule **", ReturnName(playerid, 0));
        SendClientMessage(playerid, COLOR_LIGHTRED, "AVIS: Vous avez été expulsé pour airbreak véhicule.");
    	KickEx(playerid);
    }
    else
    {
        SendAdminAlert(COLOR_ADMINCHAT, "** %s a été expulsé pour airbreak **", ReturnName(playerid, 0));
        SendClientMessage(playerid, COLOR_LIGHTRED, "AVIS: Vous avez été expulsé pour airbreak.");
    	KickEx(playerid);
    }
    return 1;
}
//bot command
script commandlunch(playerid)
{
    static Float:x,Float:y,Float:z;
	new commando,rand = random(3),count;
	SendClientMessage(playerid,COLOR_YELLOW,"Téléphone : Livraison a un aéroport fait.");
	if(rand == 0) { x=1649.5073; y=-2664.3511; z=13.5469;}
	else if(rand == 1){ x= x = 2510.0442; y=-2671.7708; z =13.6422;}
	else if(rand == 2) { x=2755.5239; y=-2227.0139; z=16.1875;}
	commando = DropItem("Boite de matos", "Commande",2040, 1,x,y,z+0.1, 0,0);
	DroppedItems[commando][droppedQuantity] = 25;
	foreach (new i : Player)
    {
    	new facass1 = PlayerData[i][pFaction];
    	FactionData[facass1][factioncoffre] -= 5000;
		if(FactionData[facass1][factionacces][6] == 1)
		{ SendServerMessage(i, "RADIO: Des boites de matos a été livré a %s.", GetLocation(x,y,z)); }
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists])
		{Faction_Save(ii);}
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][6] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][6] == 1)
		{
			new aye = 5000 / count;
			if(FactionData[ii][factionacces][6] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
				Faction_Save(ii);
			}
		}
	}
}
script commandlunchkevlar(playerid)
{
    static Float:x,Float:y,Float:z;
	new kev,rand = random(3),count;
	SendClientMessage(playerid,COLOR_YELLOW,"Téléphone : Livraison a un aéroport fait.");
	if(rand == 0) { x=1649.5073; y=-2664.3511; z=13.5469;}
	else if(rand == 1){ x= x = 2510.0442; y=-2671.7708; z =13.6422;}
	else if(rand == 2) { x=2755.5239; y=-2227.0139; z=16.1875;}
	foreach (new i : Player)
    {
    	new facass1 = PlayerData[i][pFaction];
    	FactionData[facass1][factioncoffre] -= 5000;
		if(FactionData[facass1][factionacces][6] == 1)
		{ SendServerMessage(i, "RADIO: Des kevlar a été livré a %s.", GetLocation(x,y,z)); }
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists])
		{Faction_Save(ii);}
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][6] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][6] == 1)
		{
			new aye = 5000 / count;
			if(FactionData[ii][factionacces][6] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
				Faction_Save(ii);
			}
		}
	}
	kev = DropItem("Gilet par balles","Commande",19142, 1,x,y,z+0.1, 0,0);
	DroppedItems[kev][droppedQuantity] = 10;
}
script commandlunchsoins(playerid)
{
    static Float:x,Float:y,Float:z;
	new kev,rand = random(3),count;
	SendClientMessage(playerid,COLOR_YELLOW,"Téléphone : Livraison a un aéroport fait.");
	if(rand == 0) { x=1649.5073; y=-2664.3511; z=13.5469;}
	else if(rand == 1){ x= x = 2510.0442; y=-2671.7708; z =13.6422;}
	else if(rand == 2) { x=2755.5239; y=-2227.0139; z=16.1875;}
	foreach (new i : Player)
    {
    	new facass1 = PlayerData[i][pFaction];
    	FactionData[facass1][factioncoffre] -= 5000;
		if(FactionData[facass1][factionacces][6] == 1)
		{ SendServerMessage(i, "RADIO: Des trousses de soins a été livré a %s.", GetLocation(x,y,z)); }
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists])
		{Faction_Save(ii);}
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][6] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][6] == 1)
		{
			new aye = 5000 / count;
			if(FactionData[ii][factionacces][6] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
				Faction_Save(ii);
			}
		}
	}
	kev = DropItem("Trousse de soin","Commande",1580, 1,x,y,z+0.1, 0,0);
	DroppedItems[kev][droppedQuantity] = 10;
}
script commandlunchpaint(playerid)
{
    static Float:x,Float:y,Float:z;
	new kev,rand = random(3),count;
	SendClientMessage(playerid,COLOR_YELLOW,"Téléphone : Livraison a un aéroport fait.");
	if(rand == 0) { x=1649.5073; y=-2664.3511; z=13.5469;}
	else if(rand == 1){ x= x = 2510.0442; y=-2671.7708; z =13.6422;}
	else if(rand == 2) { x=2755.5239; y=-2227.0139; z=16.1875;}
	foreach (new i : Player)
    {
    	new facass1 = PlayerData[i][pFaction];
    	FactionData[facass1][factioncoffre] -= 5000;
		if(FactionData[facass1][factionacces][6] == 1)
		{ SendServerMessage(i, "RADIO: Des bombonnes de peinture a été livré a %s.", GetLocation(x,y,z)); }
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][6] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][6] == 1)
		{
			new aye = 5000 / count;
			if(FactionData[ii][factionacces][6] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
			}
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists])
			{Faction_Save(ii);}
	}
	kev = DropItem("Bombe de peinture","Commande",365, 1,x,y,z+0.1, 0,0);
	DroppedItems[kev][droppedQuantity] = 10;
}
script commandlunchoutils(playerid)
{
    static Float:x,Float:y,Float:z;
	new kev,rand = random(3),count;
	SendClientMessage(playerid,COLOR_YELLOW,"Téléphone : Livraison a un aéroport fait.");
	if(rand == 0) { x=1649.5073; y=-2664.3511; z=13.5469;}
	else if(rand == 1){ x= x = 2510.0442; y=-2671.7708; z =13.6422;}
	else if(rand == 2) { x=2755.5239; y=-2227.0139; z=16.1875;}
	foreach (new i : Player)
    {
    	new facass1 = PlayerData[i][pFaction];
		if(FactionData[facass1][factionacces][6] == 1)
		{ SendServerMessage(i, "RADIO: Des boites à outils a été livré a %s.", GetLocation(x,y,z)); }
		FactionData[facass1][factioncoffre] -= 5000;
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][6] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][6] == 1)
		{
			new aye = 5000 / count;
			if(FactionData[ii][factionacces][6] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
			}
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists])
			{Faction_Save(ii);}
	}
	kev = DropItem("Boite a outils","Commande",19921, 1,x,y,z+0.1, 0,0);
	DroppedItems[kev][droppedQuantity] = 10;
}
script commandlunchnos(playerid)
{
    static Float:x,Float:y,Float:z;
	new kev,rand = random(3),count;
	SendClientMessage(playerid,COLOR_YELLOW,"Téléphone : Livraison a un aéroport fait.");
	if(rand == 0) { x=1649.5073; y=-2664.3511; z=13.5469;}
	else if(rand == 1){ x= x = 2510.0442; y=-2671.7708; z =13.6422;}
	else if(rand == 2) { x=2755.5239; y=-2227.0139; z=16.1875;}
	foreach (new i : Player)
    {
    	new facass1 = PlayerData[i][pFaction];
		FactionData[facass1][factioncoffre] -= 5000;
		if(FactionData[facass1][factionacces][6] == 1)
		{ SendServerMessage(i, "RADIO: Des bonbonnes de nos a été livré a %s.", GetLocation(x,y,z)); }
		for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][6] == 1) {
			count++;
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][6] == 1)
		{
			new aye = 5000 / count;
			if(FactionData[ii][factionacces][6] == 1)
			{
				FactionData[ii][factioncoffre] += aye;
			}
		}
		for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists])
			{Faction_Save(ii);}
	}
	kev = DropItem("Bonbonne de NOS","Commande",1010, 1,x,y,z+0.1, 0,0);
	DroppedItems[kev][droppedQuantity] = 10;
}
script OnActorStreamIn(actorid, forplayerid)
{
	SetActorInvulnerable(actorid, true);
	//ResyncActor(actorid);
	SetActorRespawnTime(actorid,10000);
    return 1;
}
//bowling
script PinsWaitTimer(playerid)
{
    new Float:x,Float:y,Float:z;
    for(new pin=0; pin<=MAX_PINS; pin++)
   	{
   	    if(LastPin[PlayersBowlingRoad[playerid]][pin][playerid] == PIN_GOAWAY)
   	    {
			GetDynamicObjectPos(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,z);
			MoveDynamicObject(BowlingPins[PlayersBowlingRoad[playerid]][pin],x,y,1.7151190042496,1.0);
			BowlingPinsWaitEndTimer[playerid] = SetTimerEx("PinsWaitEnd",2000,false,"d",playerid);
		}
	}
}
script PinsWaitEnd(playerid) {BowlingStatus[playerid]=F_BOWLING_THROW;}
script BowlingCountDown(playerid)
{

	        BowlingSeconds[playerid] -= 1;
	    	new str[150];
			if(PlayersBowlingRoad[playerid]==0)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Allée 1{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==1)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Allée 2{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==2)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Allée 3{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==3)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Allée 4{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,str);
			}
			if(PlayersBowlingRoad[playerid]==4)
			{
				format(str,150,"{E32A2A}[{FFFFFF} Allée 5{E32A2A} ]\nOccupé\n{BBBB00}Joueur:{FFFFFF}%s\n{BBBB00}Temps:{FFFFFF}%02d:%02d\n{BBBB00}Points:{FFFFFF}%i",ReturnName(playerid, 0),BowlingMinutes[playerid],BowlingSeconds[playerid],PlayersBowlingScore[playerid]);
				UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,str);
			}
			if(BowlingSeconds[playerid] == 0 && BowlingMinutes[playerid] > 0 )
	    	{
	        	BowlingSeconds[playerid] = 59;
        		BowlingMinutes[playerid] -= 1;
        	}
	        else if(BowlingMinutes[playerid] == 0 && BowlingSeconds[playerid] == 0)
			{
				if(PlayersBowlingScore[playerid] > PlayerData[playerid][pBestScore])
				{
    				SendServerMessage(playerid,"{00CC00}Record Battu! Ancien score: {FFFFFF}%i!",PlayerData[playerid][pBestScore]);
 					SendServerMessage(playerid,"{00CC00}Nouveau score: {FFFFFF}%i!",PlayersBowlingScore[playerid]);
					PlayerData[playerid][pBestScore] = PlayersBowlingScore[playerid];
				}
				else {SendServerMessage(playerid,"{00CC00}Votre record est: {FFFFFF}%i!",PlayerData[playerid][pBestScore]);}
				BowlingSeconds[playerid] = 0;
				BowlingMinutes[playerid] = 0;
				AbleToPlay[playerid] = 0;
				BowlingRoadStatus[PlayersBowlingRoad[playerid]] = ROAD_EMPTY;
				KillTimer(BowlingTimer[PlayersBowlingRoad[playerid]]);
				SendServerMessage(playerid,"Temps écoulé.");
				SendServerMessage(playerid,"{FFFFFF}Votre score est de {00CC00}%i {FFFFFF}points.",PlayersBowlingScore[playerid]);
				PlayersBowlingScore[playerid] = 0;
				DestroyBall(playerid);
 				if(PlayersBowlingRoad[playerid]==0)
 				{
			 		UpdateDynamic3DTextLabelText(BowlingRoadScreen[0], 0xFFFFFF,"{008800}[{FFFFFF} Allée 1{008800} ]\n Vide");
			 		PlayersBowlingRoad[playerid] = ROAD_NONE;
			 		DestroyPins(0);
	 			}
 				else if(PlayersBowlingRoad[playerid]==1)
 				{
			 		UpdateDynamic3DTextLabelText(BowlingRoadScreen[1], 0xFFFFFF,"{008800}[{FFFFFF} Allée 2{008800} ]\n Vide");
			 		PlayersBowlingRoad[playerid] = ROAD_NONE;
			 		DestroyPins(1);
			 	}
				else if(PlayersBowlingRoad[playerid]==2)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[2], 0xFFFFFF,"{008800}[{FFFFFF} Allée 3{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(2);
				}
				else if(PlayersBowlingRoad[playerid]==3)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[3], 0xFFFFFF,"{008800}[{FFFFFF} Allée 4{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(3);
				}
				else if(PlayersBowlingRoad[playerid]==4)
				{
					UpdateDynamic3DTextLabelText(BowlingRoadScreen[4], 0xFFFFFF,"{008800}[{FFFFFF} Allée 5{008800} ]\n Vide");
					PlayersBowlingRoad[playerid] = ROAD_NONE;
					DestroyPins(4);
				}

			}
			return 1;
}
script BallGoingTimer(playerid)
{
    MoveBall(playerid);
    BallRun[playerid] = SetTimerEx("BallRunTimer",BALL_RUN_TIME,false,"d",playerid);
	return 1;
}
script BallRunTimer(playerid)
{
	if(BowlingStatus[playerid]==F_BOWLING_THROW)
    {
    	PinsKnocked(playerid);
    	BowlingStatus[playerid]=S_BOWLING_THROW;
	}
	else if(BowlingStatus[playerid]==S_BOWLING_THROW)
	{
	    LastPinsKnocked(playerid);
	    BowlingStatus[playerid]=N_BOWLING_THROW;
	    BowlingPinsWaitTimer[playerid] = SetTimerEx("PinsWaitTimer",3000,false,"d",playerid);
	}
	DestroyDynamicObject(BowlingBall[PlayersBowlingRoad[playerid]]);
	return 1;
}
//serveur setting
script serveursettinginfoload()
{
    new query[600];
    mysql_format(g_iHandle,query,sizeof(query),"SELECT * FROM serveursetting");
    new Cache:result = mysql_query(g_iHandle,query);
	for(new serveursettinginfoid = 0; serveursettinginfoid < cache_get_row_count(); serveursettinginfoid++)
	{
	    info_serveursettinginfo[serveursettinginfoid][serveursettinginfoidd] = cache_get_field_content_int(serveursettinginfoid,"id");
	 	cache_get_field_content(serveursettinginfoid, "motd", info_serveursettinginfo[serveursettinginfoid][settingmotd], g_iHandle, 128);
	    info_serveursettinginfo[serveursettinginfoid][settingafkactive] = cache_get_field_content_int(serveursettinginfoid,"afkactive");
		info_serveursettinginfo[serveursettinginfoid][settingafktime] = cache_get_field_content_int(serveursettinginfoid,"afktime");
		info_serveursettinginfo[serveursettinginfoid][settingbraquagenpcactive] = cache_get_field_content_int(serveursettinginfoid,"braquagenpcactive");
		info_serveursettinginfo[serveursettinginfoid][settingbraquagebankactive] = cache_get_field_content_int(serveursettinginfoid,"braquagebanqueactive");
		info_serveursettinginfo[serveursettinginfoid][settingoocactive] = cache_get_field_content_int(serveursettinginfoid,"oocactive");
		info_serveursettinginfo[serveursettinginfoid][settingpmactive] = cache_get_field_content_int(serveursettinginfoid,"pmactive");
		info_serveursettinginfo[serveursettinginfoid][settingvilleactive] = cache_get_field_content_int(serveursettinginfoid,"villeactive");
		info_serveursettinginfo[serveursettinginfoid][settingnouveau] = cache_get_field_content_int(serveursettinginfoid,"nouveau");
		info_serveursettinginfo[serveursettinginfoid][settingpolice] = cache_get_field_content_int(serveursettinginfoid,"police");
		info_serveursettinginfo[serveursettinginfoid][settingswat] = cache_get_field_content_int(serveursettinginfoid,"swat");
	}
	cache_delete(result);
}
script serveursettinginfosave(serveursettinginfoid)
{
	new query[600];
    mysql_format(g_iHandle, query, sizeof(query),"UPDATE serveursetting SET afkactive=%d, afktime=%d, braquagenpcactive=%d, braquagebanqueactive=%d, oocactive=%d, pmactive=%d, villeactive=%d, nouveau=%d, police=%d, swat=%d WHERE id='1'",
	info_serveursettinginfo[serveursettinginfoid][settingafkactive],
	info_serveursettinginfo[serveursettinginfoid][settingafktime],
	info_serveursettinginfo[serveursettinginfoid][settingbraquagenpcactive],
	info_serveursettinginfo[serveursettinginfoid][settingbraquagebankactive],
	info_serveursettinginfo[serveursettinginfoid][settingoocactive],
	info_serveursettinginfo[serveursettinginfoid][settingpmactive],
	info_serveursettinginfo[serveursettinginfoid][settingvilleactive],
    info_serveursettinginfo[serveursettinginfoid][settingnouveau],
    info_serveursettinginfo[serveursettinginfoid][settingpolice],
    info_serveursettinginfo[serveursettinginfoid][settingswat]);
    mysql_tquery(g_iHandle, query);
}
//caisse
script caisse_Load()
{
    static rows,fields;
	cache_get_data(rows, fields, g_iHandle);
	for (new i = 0; i < rows; i ++) if (i < MAX_caisseS)
	{
	    caisseMachineData[i][caisseExists] = true;
	    caisseMachineData[i][caisseID] = cache_get_field_int(i, "caisseID");
	    caisseMachineData[i][caisseInterior] = cache_get_field_int(i, "caisseInterior");
	    caisseMachineData[i][caisseWorld] = cache_get_field_int(i, "caisseWorld");
	    caisseMachineData[i][caissePos][0] = cache_get_field_float(i,"caisseX");
	    caisseMachineData[i][caissePos][1] = cache_get_field_float(i,"caisseY");
	    caisseMachineData[i][caissePos][2] = cache_get_field_float(i,"caisseZ");
	    caisseMachineData[i][caissePos][3] = cache_get_field_float(i,"caisseRX");
	    caisseMachineData[i][caissePos][4] = cache_get_field_float(i,"caisseRY");
	    caisseMachineData[i][caissePos][5] = cache_get_field_float(i,"caisseRZ");
		caisse_Refresh(i);
	}
	return 1;
}
script OncaisseCreated(caisseid)
{
	if (caisseid == -1 || !caisseMachineData[caisseid][caisseExists])
	    return 0;
	caisseMachineData[caisseid][caisseID] = cache_insert_id(g_iHandle);
	caisse_Save(caisseid);
	return 1;
}
//gym
script DUMB_START(playerid)
{
	BAR_CAN_BE_USED[playerid]=true;
	SetPlayerAttachedObject(playerid,5, 3072, 5);//left hand
	SetPlayerAttachedObject(playerid,6, 3071, 6);//right hand
	DestroyDynamicObject(dumbell_right_objects[PLAYER_CURRECT_DUMB[playerid]]);
	DestroyDynamicObject(dumbell_left_objects[PLAYER_CURRECT_DUMB[playerid]]);
	ShowAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawShowForPlayer( playerid, gym_power[playerid]);
	TextDrawShowForPlayer( playerid, gym_deslabel[playerid]);
	TextDrawShowForPlayer( playerid, gym_repslabel[playerid]);
	PLAYER_DUMB_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500,true,"i", playerid );
}
script BIKE_START(playerid)
{
	BAR_CAN_BE_USED[playerid]=true;
	ApplyAnimation( playerid, "GYMNASIUM", "bike_start", 1, 1, 0, 0, 1, 0, 1);
	ShowAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawShowForPlayer( playerid, gym_power[playerid]);
	TextDrawShowForPlayer( playerid, gym_des[playerid]);
	TextDrawShowForPlayer( playerid, gym_deslabel[playerid]);
	PLAYER_BIKE_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500, 1, "i", playerid );
}
script TREAM_START(playerid)
{
	BAR_CAN_BE_USED[playerid]=true;
	ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_sprint", 1, 1, 0, 0, 1, 0, 1);
	ShowAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawShowForPlayer( playerid, gym_power[playerid]);
	TextDrawShowForPlayer( playerid, gym_des[playerid]);
	TextDrawShowForPlayer( playerid, gym_deslabel[playerid]);
	PLAYER_TREAD_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500, 1, "i", playerid );
}
script BENCH_START(playerid)
{
	BAR_CAN_BE_USED[playerid]=true;
	SetPlayerAttachedObject(playerid, 5, 2913, 6);
	DestroyDynamicObject(barbell_objects[PLAYER_CURRECT_BENCH[playerid]]);
	ShowAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawShowForPlayer( playerid, gym_power[playerid]);
	TextDrawShowForPlayer( playerid, gym_repslabel[playerid]);
	TextDrawShowForPlayer( playerid, gym_deslabel[playerid]);
	PLAYER_BENCH_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500,true,"i", playerid );
}
script GYM_CHECK(playerid)
{
	if(PLAYER_INTREAM[playerid]==true)
	{TREAM_CHECK(playerid);}
	if(PLAYER_INBIKE[playerid]==true)
	{BIKE_CHECK(playerid);}
	if(PLAYER_INBENCH[playerid]==true)
	{BENCH_CHECK(playerid);}
	if(PLAYER_INDUMB[playerid]==true)
	{DUMB_CHECK(playerid);}
}
DUMB_CHECK(playerid)
{
	SetAntoineBarValue( player_gym_progress[playerid], GetAntoineBarValue( player_gym_progress[playerid] ) - 2 );
	UpdateAntoineBar( player_gym_progress[playerid], playerid );
	if(GetAntoineBarValue( player_gym_progress[playerid] ) >=90)
	{
		switch( random( 2 ) )
		{
			case 0: ApplyAnimation( playerid, "freeweights", "gym_free_A", 1, 0, 0, 0, 1, 0, 1 );
  			case 1: ApplyAnimation( playerid, "freeweights", "gym_free_B", 1, 0, 0, 0, 1, 0, 1 );
		}
		new LocalLabel[10];
		PLAYER_DUMB_COUNT[playerid]++;
		format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_DUMB_COUNT[playerid]);
		TextDrawSetString(gym_deslabel[playerid],LocalLabel);
		PlayerData[playerid][prepetitions] += PLAYER_DUMB_COUNT[playerid]/2;
		SetAntoineBarValue(player_gym_progress[playerid],0);
		SetTimerEx( "DUMB_SET_AIMSTOP",2000, false, "i", playerid);
	}

}
BENCH_CHECK(playerid)
{
	SetAntoineBarValue( player_gym_progress[playerid], GetAntoineBarValue( player_gym_progress[playerid] ) - 2 );
	UpdateAntoineBar( player_gym_progress[playerid], playerid );
	if(GetAntoineBarValue( player_gym_progress[playerid] ) >=90)
	{
		switch( random( 2 ) )
		{
			case 0: ApplyAnimation( playerid, "benchpress", "gym_bp_up_A", 1, 0, 0, 0, 1, 0, 1 );
  			case 1: ApplyAnimation( playerid, "benchpress", "gym_bp_up_B", 1, 0, 0, 0, 1, 0, 1 );
		}
		new LocalLabel[10];
		PLAYER_BENCH_COUNT[playerid] ++;
		format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_BENCH_COUNT[playerid]);
		TextDrawSetString(gym_deslabel[playerid],LocalLabel);
		SetAntoineBarValue(player_gym_progress[playerid],0);
		PlayerData[playerid][prepetitions] += PLAYER_BENCH_COUNT[playerid]/2;
		SetTimerEx( "BENCH_SET_AIMSTOP",2000, false, "i", playerid);
	}
}
script DUMB_SET_AIMSTOP(playerid)
{
	ApplyAnimation( playerid, "freeweights", "gym_free_down", 1, 0, 0, 0, 1, 0, 1 );
	UpdateAntoineBar(player_gym_progress[playerid],playerid);
}
script BENCH_SET_AIMSTOP(playerid)
{
	ApplyAnimation( playerid, "benchpress", "gym_bp_down", 1, 0, 0, 0, 1, 0, 1 );
	UpdateAntoineBar(player_gym_progress[playerid],playerid);
}
BIKE_CHECK(playerid)
{
	SetAntoineBarValue( player_gym_progress[playerid], GetAntoineBarValue( player_gym_progress[playerid] ) - 8 );
	UpdateAntoineBar( player_gym_progress[playerid], playerid );
	if(GetAntoineBarValue( player_gym_progress[playerid] ) <=0)
	{
		ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_still", 1, 1, 0, 0, 1, 0, 1);
	}else{
		ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_fast", 1, 1, 0, 0, 1, 0, 1 );
	}
}
TREAM_CHECK(playerid)
{
	SetAntoineBarValue( player_gym_progress[playerid], GetAntoineBarValue( player_gym_progress[playerid] ) - 8 );
	UpdateAntoineBar( player_gym_progress[playerid], playerid );
	if(GetAntoineBarValue( player_gym_progress[playerid] ) <=0)
	{
		KillTimer(PLAYER_TREAD_TIMER[playerid]);
		FallOffTread(playerid);
	}
}
FallOffTread(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_falloff", 1, 0, 0, 0, 1, 0, 1 );
	HideAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[playerid]);
	TextDrawHideForPlayer( playerid, gym_des[playerid]);
	TextDrawHideForPlayer( playerid, gym_deslabel[playerid]);
	SetTimerEx( "REST_PLAYER", 2000, false, "i", playerid);
}
GetOffTread(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_getoff", 1, 0, 0, 0, 1, 0, 1 );
	HideAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[playerid]);
	TextDrawHideForPlayer( playerid, gym_des[playerid]);
	TextDrawHideForPlayer( playerid, gym_deslabel[playerid]);
	SetTimerEx( "REST_PLAYER", 3500, false, "i", playerid);
}
GetOffBENCH(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 1, 0, 0, 0, 1, 0, 1 );
    HideAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[playerid]);
	TextDrawHideForPlayer( playerid, gym_repslabel[playerid]);
	TextDrawHideForPlayer( playerid, gym_deslabel[playerid]);
    SetTimerEx( "REST_PLAYER", 5000, false, "i", playerid);
}
PutDownDUMB(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation(playerid, "freeweights", "gym_free_putdown", 1, 0, 0, 0, 1, 0, 1 );
    HideAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[playerid]);
	TextDrawHideForPlayer( playerid, gym_repslabel[playerid]);
	TextDrawHideForPlayer( playerid, gym_deslabel[playerid]);
    SetTimerEx( "REST_PLAYER",3000, false, "i", playerid);
}
GetOffBIKE(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_getoff", 1, 0, 0, 0, 1, 0, 1 );
	HideAntoineBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer(playerid,gym_power[playerid]);
	TextDrawHideForPlayer(playerid,gym_des[playerid]);
	TextDrawHideForPlayer(playerid,gym_deslabel[playerid]);
	SetTimerEx( "REST_PLAYER", 2000, false, "i", playerid);
}
script REST_PLAYER(playerid)
{
	ClearAnimations(playerid,1);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid,1);
	BAR_CAN_BE_USED[playerid]=false;
	if(PLAYER_INTREAM[playerid]==true)
	{
		PLAYER_INTREAM[playerid]=false;
 		TREAM_IN_USE[PLAYER_CURRECT_TREAD[playerid]]=false;
 	}
	if(PLAYER_INBIKE[playerid]==true)
	{
		PLAYER_INBIKE[playerid]=false;
 		BIKE_IN_USE[PLAYER_CURRECT_BIKE[playerid]]=false;
 	}
  	if(PLAYER_INBENCH[playerid]==true)
  	{
  		PLAYER_INBENCH[playerid]=false;
  		BENCH_IN_USE[PLAYER_CURRECT_BENCH[playerid]]=false;
 		barbell_objects[PLAYER_CURRECT_BENCH[playerid]] = CreateDynamicObject( 2913, barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 0 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 1 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 2 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 3 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 4 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 5 ] );
    	RemovePlayerAttachedObject( playerid,5);
  	}
	if(PLAYER_INDUMB[playerid]==true)
  	{
  		PLAYER_INDUMB[playerid]=false;
  		DUMB_IN_USE[PLAYER_CURRECT_DUMB[playerid]]=false;
 		dumbell_right_objects[PLAYER_CURRECT_DUMB[playerid]] = CreateDynamicObject(3071,dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][0],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][1],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][2],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][3],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][4],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][5]);
		dumbell_left_objects[PLAYER_CURRECT_DUMB[playerid]] = CreateDynamicObject(3072,dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][0],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][1],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][2],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][3],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][4],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][5]);
		RemovePlayerAttachedObject(playerid,5);
    	RemovePlayerAttachedObject(playerid,6);
  	}
}
script starter(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	switch (GetEngineStatus(vehicleid))
	{
	    case false:
	    {
	        SetEngineStatus(vehicleid, true);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s démarre le moteur.", ReturnName(playerid, 0));
		}
	}
}
//horse
script GameTimeTimer2()
{
	foreach (new i : Player)
 	{
		if(IsPlayerInPMU(i))
		{
		    SendServerMessage(i, "La course va commencé dans 15 minutes! Plus aucun pari ne peut etre accepté!");
			new Float:X, Float:Y, Float:Z;
	 		GetPlayerPos(i, X, Y, Z);
			PlayerPlaySound(i, 5410, X, Y, Z);
		}
	}
	RaceStarted = 1;
	Prepared = 1;
	SetTimer("HorseStartTimer", 900000,0);
}
script GameTimeTimeTimer2()
{
	HorseCD = 3;
	HorseStop = 0;

	BG2 = TextDrawCreate(0, 0, "LD_OTB:bckgrnd");
    TextDrawFont(BG2, 4);
    TextDrawColor(BG2,0xFFFFFFFF);
    TextDrawTextSize(BG2,640,200);

 	BG1 = TextDrawCreate(0, 0, "LD_OTB:trees");
    TextDrawFont(BG1, 4);
    TextDrawColor(BG1,0xFFFFFFFF);
    TextDrawTextSize(BG1,640,480);

   	Start2 = TextDrawCreate(-170, 145, "LD_OTB:pole2");
    TextDrawFont(Start2, 4);
    TextDrawColor(Start2,0xFFFFFFFF);
    TextDrawTextSize(Start2,256,200);

   	Finish2 = TextDrawCreate(365, 145, "LD_OTB:pole2");
    TextDrawFont(Finish2, 4);
    TextDrawColor(Finish2,0xFFFFFFFF);
    TextDrawTextSize(Finish2,256,200);

    Horse1 = TextDrawCreate(0, 200, "LD_OTB:hrs8");
	HorseInfo(Horse1);
	HorsePosX1 = 0;

    Horse2 = TextDrawCreate(0, 250, "LD_OTB:hrs8");
	HorseInfo(Horse2);
	HorsePosX2 = 0;

    Horse3 = TextDrawCreate(0, 300, "LD_OTB:hrs8");
	HorseInfo(Horse3);
	HorsePosX3 = 0;

    Horse4 = TextDrawCreate(0, 350, "LD_OTB:hrs8");
	HorseInfo(Horse4);
    HorsePosX4 = 0;

    HorseNum1 = TextDrawCreate(15, 204, "LD_OTB2:Ric1");
    HorseNumInfo(HorseNum1);

    HorseNum2 = TextDrawCreate(15, 254, "LD_OTB2:Ric2");
    HorseNumInfo(HorseNum2);

    HorseNum3 = TextDrawCreate(15, 304, "LD_OTB2:Ric3");
    HorseNumInfo(HorseNum3);

    HorseNum4 = TextDrawCreate(15, 354, "LD_OTB2:Ric4");
    HorseNumInfo(HorseNum4);

   	Start = TextDrawCreate(-170, 338, "LD_OTB:pole2");
    TextDrawFont(Start, 4);
    TextDrawColor(Start,0xFFFFFFFF);
    TextDrawTextSize(Start,256,200);

   	Finish = TextDrawCreate(365, 338, "LD_OTB:pole2");
    TextDrawFont(Finish, 4);
    TextDrawColor(Finish,0xFFFFFFFF);
    TextDrawTextSize(Finish,256,200);

	CDTextDraw = TextDrawCreate(310,235,"3");
	TextDrawAlignment(CDTextDraw,0);
	TextDrawBackgroundColor(CDTextDraw,0x000000ff);
	TextDrawFont(CDTextDraw,2);
	TextDrawLetterSize(CDTextDraw,0.5,2);
	TextDrawColor(CDTextDraw,0x00ff0099);
	TextDrawSetOutline(CDTextDraw,1);
	TextDrawSetProportional(CDTextDraw,1);
	TextDrawSetShadow(CDTextDraw,1);

	HorseAnimCount = 1;
	Prepared = 0;
	foreach (new i : Player)
 	{
		if(IsPlayerInPMU(i))
		{
			new Float:X,Float:Y,Float:Z;
 			GetPlayerPos(i,X,Y,Z);
			PlayerPlaySound(i, 5401,X,Y,Z);
			SendServerMessage(i,"1 heure avant la course! Vous pouvez pariez avec /parier sur votre cheval !");
		}
	}
	SetTimer("GameTimeTimer2", 3600000, 0);
}
script HorseStartTimer()
{
	if (HorseCD > 0)
	{
		new string[128];
		format(string, sizeof(string), "%d",HorseCD);
		if (Horsemsg == 1)
		{
			foreach (new i : Player)
 			{
				if(IsPlayerInPMU(i))
				{SendServerMessage(i, "La course a commencer /regardercourse pour regarder la course!");}
			}
			Horsemsg = 0;
		}
		HorseCD -= 1;
		foreach (new i : Player)
		{
			if(IsPlayerInPMU(i))
			{
				new Float:X, Float:Y, Float:Z;
				GetPlayerPos(i, X, Y, Z);
				PlayerPlaySound(i, 3200, X, Y, Z);
				TextDrawColor(CDTextDraw,0xff0000ff);
				TextDrawSetString(CDTextDraw, string);
			}
		}
		SetTimer("HorseStartTimer", 2000, 0);
	}
	else
	{
		Horsemsg = 1;
  		foreach (new i : Player)
 		{
			if(IsPlayerInPMU(i))
			{
        		if (Watching[i] == 1)
        		{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					PlayerPlaySound(i, 3201, X, Y, Z);
					TextDrawColor(CDTextDraw,0x00ff00ff);
					TextDrawSetString(CDTextDraw, "Go!");
				}
            	TextDrawShowForPlayer(i,CDTextDraw);
			}
		}
		SetTimer("HorseAnimTimer", 100, 0);
	}
	SetTimer("HorseStartHideTimer", 1000, 0);
	return 1;
}
script HorseAnimTimer()
{
	new string[12], HorseWon,count;
 	format(string, sizeof(string), "LD_OTB:hrs%i", HorseAnimCount);
 	HorseAnimCount++;
 	if (HorseAnimCount == 9) HorseAnimCount = 1;

  	HorsePosX1 = HorsePosX1 + (random(500) / 100);
  	HorsePosX2 = HorsePosX2 + (random(500) / 100);
  	HorsePosX3 = HorsePosX3 + (random(500) / 100);
  	HorsePosX4 = HorsePosX4 + (random(500) / 100);

  	TextDrawDestroy(Horse1);
  	TextDrawDestroy(Horse2);
  	TextDrawDestroy(Horse3);
  	TextDrawDestroy(Horse4);
  	TextDrawDestroy(HorseNum1);
  	TextDrawDestroy(HorseNum2);
  	TextDrawDestroy(HorseNum3);
  	TextDrawDestroy(HorseNum4);

    Horse1 = TextDrawCreate(HorsePosX1, 200, string);
    HorseInfo(Horse1);
    Horse2 = TextDrawCreate(HorsePosX2, 250, string);
    HorseInfo(Horse2);
    Horse3 = TextDrawCreate(HorsePosX3, 300, string);
    HorseInfo(Horse3);
    Horse4 = TextDrawCreate(HorsePosX4, 350, string);
    HorseInfo(Horse4);
    HorseNum1 = TextDrawCreate(HorsePosX1 + 15, 204, "LD_OTB2:Ric1");
    HorseNumInfo(HorseNum1);
    HorseNum2 = TextDrawCreate(HorsePosX2 + 15, 254, "LD_OTB2:Ric2");
    HorseNumInfo(HorseNum2);
    HorseNum3 = TextDrawCreate(HorsePosX3 + 15, 304, "LD_OTB2:Ric3");
    HorseNumInfo(HorseNum3);
    HorseNum4 = TextDrawCreate(HorsePosX4 + 15, 354, "LD_OTB2:Ric4");
    HorseNumInfo(HorseNum4);
	foreach (new i : Player)
 	{
		if(IsPlayerInPMU(i))
		{
        	if (Watching[i] == 1)
        	{
       		   	TextDrawShowForPlayer(i,Horse1);
		  		TextDrawShowForPlayer(i,Horse2);
		  		TextDrawShowForPlayer(i,Horse3);
		  		TextDrawShowForPlayer(i,Horse4);
		  		TextDrawShowForPlayer(i,HorseNum1);
		  		TextDrawShowForPlayer(i,HorseNum2);
		  		TextDrawShowForPlayer(i,HorseNum3);
		  		TextDrawShowForPlayer(i,HorseNum4);
        	}
			if (HorsePosX1 >= 560)
			{
				HorseStop = 1;
				HorseWon = 1;
			}
			else if (HorsePosX2 >= 560)
			{
				HorseStop = 1;
				HorseWon = 2;
			}
			else if (HorsePosX3 >= 560)
			{
				HorseStop = 1;
				HorseWon = 3;
			}
			else if (HorsePosX4 >= 560)
			{
				HorseStop = 1;
				HorseWon = 4;
			}
			if (HorseStop == 0) {SetTimer("HorseAnimTimer", 100, 0);}
			else
			{
				HorseStop = 1;
				RaceStarted = 0;
			    TextDrawDestroy(BG2);
			    TextDrawDestroy(BG1);
				TextDrawDestroy(Start2);
				TextDrawDestroy(Finish2);
			    TextDrawDestroy(Horse1);
			    TextDrawDestroy(Horse2);
			    TextDrawDestroy(Horse3);
			    TextDrawDestroy(Horse4);
			    TextDrawDestroy(HorseNum1);
			    TextDrawDestroy(HorseNum2);
				TextDrawDestroy(HorseNum3);
			    TextDrawDestroy(HorseNum4);
				TextDrawDestroy(Start);
				TextDrawDestroy(Finish);
				if(HorseWon == 1)
				{ SendServerMessage(i,"Cheval #1 a gagner!"); }
				if(HorseWon == 2)
				{ SendServerMessage(i,"Cheval #2 a gagner!"); }
				if(HorseWon == 3)
				{ SendServerMessage(i,"Cheval #3 a gagner!"); }
				if(HorseWon == 4)
				{ SendServerMessage(i,"Cheval #4 a gagner!"); }
  				if (BetOnHorse[i] == HorseWon)
  				{
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					PlayerPlaySound(i, 5448, X, Y, Z);
		        	SendServerMessage(i,"Vous avez gagné! Votre argent est doublez!");
					GiveMoney(i, MoneyBet[i] * 2);
					for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
						count++;
					}
					for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
					{
						new aye = MoneyBet[i] / count;
						if(FactionData[ii][factionacces][12] == 1)
						{
							FactionData[ii][factioncoffre] -= aye;
							Faction_Save(ii);
						}
					}
				}
				else if (MoneyBet[i] != 0 && BetOnHorse[i] != HorseWon)
				{
  					SendServerMessage(i,"Vous n'avez pas gagné.");
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(i, X, Y, Z);
					PlayerPlaySound(i, 5453, X, Y, Z);
				}
				if (Watching[i] == 1) {TogglePlayerControllable(i, 1);}
				MoneyBet[i] = 0;
				BetOnHorse[i] = 0;
				Watching[i] = 0;
				AFKMin[i] = 0;
			}
		}
		SetTimer("GameTimeTimeTimer2", 3600000, 0);
	}
}
script HorseStartHideTimer() {TextDrawHideForAll(CDTextDraw);}
//lowrider
script SendNoteForPlayer(playerid) {
	new array[128],earned,note,randomcamera;
	PlayerPlaySound(playerid, 1130, 0.0, 0.0, 10.0);
	TextDrawHideForPlayer(playerid, ContestText);
	GetPlayerPos(playerid, Pos[0],Pos[1],Pos[2]);
	earned = random(20);
	note = random(4);
	randomcamera = random(6);
	if(JustJoined[playerid] == false) {
		PointGagner[playerid] += earned;
		format(array, 128, "Point Gagner: ~g~%d", PointGagner[playerid]);
		GameTextForPlayer(playerid, array, 8000, 4);
	}
	if(JustJoined[playerid] == true)  JustJoined[playerid] = false;
	switch(note) {
	    case 0:{
	        TextDrawSetString(ContestText, "Note: Haut");
	        CurrentNote[playerid] = 0;
	    }
	    case 1:{
	        TextDrawSetString(ContestText, "Note: Bas");
	        CurrentNote[playerid] = 1;
	    }
	    case 2:{
	       	TextDrawSetString(ContestText, "Note: Droite");
	        CurrentNote[playerid] = 2;
	    }
	    case 3:{
	        TextDrawSetString(ContestText, "Note: Gauche");
	        CurrentNote[playerid] = 3;
	    }
	}
	switch(randomcamera) {
	    case 0: {
	        SetPlayerCameraPos(playerid, Pos[0]+5,Pos[1],Pos[2]+1);
		    SetPlayerCameraLookAt(playerid, Pos[0],Pos[1],Pos[2]);
	    }
	    case 1: {
	        SetPlayerCameraPos(playerid, Pos[0]+5,Pos[1]+4,Pos[2]+1);
		    SetPlayerCameraLookAt(playerid, Pos[0],Pos[1],Pos[2]);
	    }
	    case 2: {
	        SetPlayerCameraPos(playerid, Pos[0]+3,Pos[1],Pos[2]+1);
		    SetPlayerCameraLookAt(playerid, Pos[0],Pos[1],Pos[2]);
	    }
	    case 3: {
	        SetPlayerCameraPos(playerid, Pos[0]+3,Pos[1],Pos[2]+2);
		    SetPlayerCameraLookAt(playerid, Pos[0],Pos[1],Pos[2]);
	    }
	    case 4: {
	        SetPlayerCameraPos(playerid, Pos[0],Pos[1]+2,Pos[2]+9);
		    SetPlayerCameraLookAt(playerid, Pos[0],Pos[1],Pos[2]);
	    }
	    case 5: {
	        SetPlayerCameraPos(playerid, Pos[0],Pos[1]+2,Pos[2]+2);
		    SetPlayerCameraLookAt(playerid, Pos[0],Pos[1],Pos[2]);
	    }
	}
	TextDrawShowForPlayer(playerid, ContestText);
	return 1;
}
script OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
 	if((0 <= weaponid <= 9) && Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID) == 2942)
	{
		new id = -1;
		for(new i; i < MAX_DYNAMIC_OBJ; i++)
		{
		    if(!ATMData[i][atmExists]) continue;
			if (objectid == ATMData[i][atmObject])
			{
			    id = i;
				SendServerMessage(playerid,"Tu a cassé l'atm1");
				break;
			}
			SendServerMessage(playerid,"Tu a cassé l'atm2");
		}
		if(id != -1)
		{
			SendServerMessage(playerid,"Tu a cassé l'atm3");
			Streamer_Update(playerid);
		}
		return 1;
	}
	return 1;
}
//blackjack
script blackjackstart1(playerid)
{
    new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[8];
    SendBlackJackMessage(playerid,"Votre somme est de %d",sommetotal);
   	format(string, sizeof(string), "%d",sommetotal);
    PlayerTextDrawSetString(playerid,BlackJackTD[8][playerid],string);
    PlayerTextDrawShow(playerid,BlackJackTD[8][playerid]);
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme1] = 1;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme1] = 2;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme1] = 3;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme1] = 4;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme1] = 5;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme1] = 6;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme1] = 7;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme1] = 8;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme1] = 9;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme1] = 10;
            SetTimerEx("blackjackstart2",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[1][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[1][playerid]);
		}
	}
	return 1;
}
script blackjackstart2(playerid)
{
    new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[8];
    SendBlackJackMessage(playerid,"Votre somme est de %d",sommetotal);
   	format(string, sizeof(string), "%d",sommetotal);
    PlayerTextDrawSetString(playerid,BlackJackTD[8][playerid],string);
    PlayerTextDrawShow(playerid,BlackJackTD[8][playerid]);
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme2] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme2] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme2] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme2] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme2] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme2] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme2] = 7;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme2] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme2] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme2] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[2][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[2][playerid]);
		}
	}
	return 1;
}
script blackjackstart3(playerid)
{
    new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[8];
    SendBlackJackMessage(playerid,"Votre somme est de %d",sommetotal);
   	format(string, sizeof(string), "%d",sommetotal);
    PlayerTextDrawSetString(playerid,BlackJackTD[8][playerid],string);
    PlayerTextDrawShow(playerid,BlackJackTD[8][playerid]);
    if(sommetotal > 21)
	{
		SendBlackJackMessage(playerid,"Votre main est plus haute que 21");
    	BlackJack[playerid][somme1] = 0;
		BlackJack[playerid][somme2] = 0;
		BlackJack[playerid][somme3] = 0;
		BlackJack[playerid][somme4] = 0;
		BlackJack[playerid][somme5] = 0;
		PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
		// -- l'argent au croupier
	}
    if(sommetotal == 21)
	{
		SendBlackJackMessage(playerid,"Votre main est 21!");
    	BlackJack[playerid][somme1] = 0;
		BlackJack[playerid][somme2] = 0;
		BlackJack[playerid][somme3] = 0;
		BlackJack[playerid][somme4] = 0;
		BlackJack[playerid][somme5] = 0;
		PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
		PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
		//l'argent x2
	}
    return 1;
}
script blackjackcarte1(playerid)
{
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme3] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme3] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme3] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme3] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme3] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme3] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme3] = 7;
            SetTimerEx("blackjackstar3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme3] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme3] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme3] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[3][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[3][playerid]);
		}
	}
	return 1;
}
script blackjackcarte2(playerid)
{
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme4] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme4] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme4] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme4] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme4] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme4] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme4] = 7;
            SetTimerEx("blackjackstar3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme4] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme4] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme4] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[4][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[4][playerid]);
		}
	}
	return 1;
}
script blackjackcarte3(playerid)
{
    switch (random(13))
	{
	    case 0:
	    {
            BlackJack[playerid][somme5] = 1;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd1c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 1:
	    {
            BlackJack[playerid][somme5] = 2;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd2c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 2:
	    {
            BlackJack[playerid][somme5] = 3;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd3c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 3:
	    {
            BlackJack[playerid][somme5] = 4;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd4c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 4:
	    {
            BlackJack[playerid][somme5] = 5;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd5c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 5:
	    {
            BlackJack[playerid][somme5] = 6;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd6c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 6:
	    {
            BlackJack[playerid][somme5] = 7;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd7c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 7:
	    {
            BlackJack[playerid][somme5] = 8;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd8c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 8:
	    {
            BlackJack[playerid][somme5] = 9;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd9c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 9:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd10c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 10:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd11c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 11:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd12c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
		case 12:
	    {
            BlackJack[playerid][somme5] = 10;
            SetTimerEx("blackjackstart3",1000, false, "d", playerid);
            switch (random(4))
			{
            	case 0: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13h");
            	case 1: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13s");
				case 2: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13d");
            	case 3: PlayerTextDrawSetString(playerid,BlackJackTD[5][playerid],"LD_CARD:cd13c");
			}
			PlayerTextDrawShow(playerid,BlackJackTD[5][playerid]);
		}
	}
	return 1;
}
script blackjackcroupier(playerid)
{
	BlackJack[playerid][dealercarte1] = random(10);
	new blackjackcroupierpoint = BlackJack[playerid][dealercarte2] = random(10) + BlackJack[playerid][dealercarte1];
	if(blackjackcroupierpoint >= 22)
	{
	    PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],"~r~Busted");
	    PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
	}
	else
	{
		new blackjackcroupierpoint2 = BlackJack[playerid][dealercarte3] = random(10) + blackjackcroupierpoint;
		if(blackjackcroupierpoint >= 22)
		{
	    	PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],"~r~Busted");
	    	PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
		}
		else
		{
  			new sommetotal = BlackJack[playerid][somme1] + BlackJack[playerid][somme2] + BlackJack[playerid][somme3] + BlackJack[playerid][somme4] + BlackJack[playerid][somme5],string[4],count;
    		SendBlackJackMessage(playerid,"Votre somme est de %d et le croupier est de %d",sommetotal,blackjackcroupierpoint2);
    		format(string, sizeof(string), "%d",blackjackcroupierpoint2);
    		if((sommetotal > blackjackcroupierpoint2) && blackjackcroupierpoint >= 21)
    		{
    		    SendBlackJackMessage(playerid,"Vous avez gagner votre main contre le croupier.");
    		    PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],string);
    		    PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
    		    GiveMoney(playerid, 2*BlackJack[playerid][sommejouer]);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = BlackJack[playerid][sommejouer] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] -= aye;
						Faction_Save(ii);
					}
				}
    		    //argent remis au joueur ou perdu a joueur x2
    		    SetTimerEx("finducroupier",5000,false,"d",playerid);
    		}
    		else
    		{
    		    SendBlackJackMessage(playerid,"Le croupier a gagnez");
    		    PlayerTextDrawSetString(playerid,BlackJackTD[18][playerid],string);
    		    PlayerTextDrawShow(playerid,BlackJackTD[18][playerid]);
    		    GiveMoney(playerid, -BlackJack[playerid][sommejouer]);
    		    GiveMoney(playerid, 2*BlackJack[playerid][sommejouer]);
				for (new iii = 0; iii != MAX_FACTIONS; iii ++) if (FactionData[iii][factionExists] && FactionData[iii][factionacces][12] == 1) {
					count++;
				}
				for (new ii = 0; ii != MAX_FACTIONS; ii ++) if (FactionData[ii][factionExists] && FactionData[ii][factionacces][12] == 1)
				{
					new aye = BlackJack[playerid][sommejouer] / count;
					if(FactionData[ii][factionacces][12] == 1)
					{
						FactionData[ii][factioncoffre] += aye;
						Faction_Save(ii);
					}
				}
    		    //argenr perdu du joueur a ajouter dans la banque truc
    		    SetTimerEx("finducroupier",5000,false,"d",playerid);
    		}
		}
	}
	return 1;
}
script finducroupier(playerid)
{
    PlayerTextDrawHide(playerid,BlackJackTD[1][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[2][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[3][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[4][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[5][playerid]);
	PlayerTextDrawHide(playerid,BlackJackTD[8][playerid]);
    PlayerTextDrawHide(playerid,BlackJackTD[10][playerid]);
    PlayerTextDrawHide(playerid,BlackJackTD[18][playerid]);
    BlackJack[playerid][somme1] = 0;
	BlackJack[playerid][somme2] = 0;
	BlackJack[playerid][somme3] = 0;
	BlackJack[playerid][somme4] = 0;
	BlackJack[playerid][somme5] = 0;
	BlackJack[playerid][sommejouer] = 0;
	return 1;
}
//autre fonction utilise du callback include A METTRE A LA FIN DU GM
script OnPlayerHoldingKey(playerid,keys)
{
	if ((keys ==  KEY_FIRE) && GetPlayerWeapon(playerid) == 42)
	{
        static Float:fX,Float:fY,Float:fZ;
	    for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	    {
			GetDynamicObjectPos(g_aFireObjects[i], fX, fY, fZ);
			if ((IsValidDynamicObject(g_aFireObjects[i]) && IsPlayerInRangeOfPoint(playerid, 4.0, fX, fY, fZ)) && ++ g_aFireExtinguished[i] == 36)
   			{
   			    SetTimerEx("DestroyWater", 2000, false, "d", CreateDynamicObject(18744, fX, fY, fZ - 0.2, 0.0, 0.0, 0.0));

      			DestroyDynamicObject(g_aFireObjects[i]);
	        	g_aFireExtinguished[i] = 0;
			}
		}
	}
	if ((keys == KEY_FIRE) && (GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 544))
	{
	    static Float:fX,Float:fY,Float:fZ,Float:fVector[3],Float:fCamera[3];
	    GetPlayerCameraFrontVector(playerid, fVector[0], fVector[1], fVector[2]);
	    GetPlayerCameraPos(playerid, fCamera[0], fCamera[1], fCamera[2]);
	    for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	    {
			GetDynamicObjectPos(g_aFireObjects[i], fX, fY, fZ);

			if (IsValidDynamicObject(g_aFireObjects[i]) && IsPlayerInRangeOfPoint(playerid, 3050, fX, fY, fZ))
			{
				if (++g_aFireExtinguished[i] == 64 && DistanceCameraTargetToLocation(fCamera[0], fCamera[1], fCamera[2], fX, fY, fZ + 2.5, fVector[0], fVector[1], fVector[2]) < 24.0)
   				{
   			    	SetTimerEx("DestroyWater", 2000, false, "d", CreateDynamicObject(18744, fX, fY, fZ - 0.2, 0.0, 0.0, 0.0));
	      			DestroyDynamicObject(g_aFireObjects[i]);
		        	g_aFireExtinguished[i] = 0;
				}
		  	}
	    }
	}
	return 1;
}
script OnPlayerPause(playerid)
{
    //afk
    AFKMin[playerid] = 0;
	return 1;
}
script OnPlayerResume(playerid,time)
{
	SendServerMessage(playerid,"Anti AFK remis à 0.");
	AFKMin[playerid] = 0;
	return 1;
}
script OnPlayerStartBurn(playerid)
{
    SetPlayerAttachedObject(playerid, 9, 18689, 2, 0.101, -0.0, 0.0, 4.50, 84.60, 83.7, 1, 1, 1);
    return 1;
}
script OnPlayerStopBurn(playerid)
{
    RemovePlayerAttachedObject(playerid, 9);
	return 1;
}
//stamina
script OnPlayerOutOfStamina(playerid)
{
    ApplyAnimation(playerid, "PED", "IDLE_tired", 4.1, 0, 1, 1, 0, STAMINA_UPDATE_TIME*5, 1);
    return 1;
}
script SendAdminAlert(color, const str[], {Float,_}:...)
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
			if (PlayerData[i][pTester] >= 1 || PlayerData[i][pAdmin] > 0){
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerData[i][pAdmin] >= 1) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
script SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
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
script SendFactionAlert(color, const str[], {Float,_}:...)
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
			if (PlayerData[i][pAdmin] >= 1 || PlayerData[i][pFactionMod] > 0) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerData[i][pAdmin] >= 1 || PlayerData[i][pFactionMod] > 0) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
script SendTesterMessage(color, const str[], {Float,_}:...)
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
			if ((!PlayerData[i][pDisableTester]) && (PlayerData[i][pTester] >= 1 || PlayerData[i][pAdmin] > 0)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if ((!PlayerData[i][pDisableTester]) && (PlayerData[i][pTester] >= 1 || PlayerData[i][pAdmin] > 0)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}
script SendHelperMessage(color, const str[], {Float,_}:...)
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
  				SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player)
	{
			SendClientMessage(i, color, str);
	}
	return 1;
}
script SendFactionMessage(factionid, color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		foreach (new i : Player) if (PlayerData[i][pFaction] == factionid && !PlayerData[i][pDisableFaction]) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (PlayerData[i][pFaction] == factionid && !PlayerData[i][pDisableFaction]) {
 		SendClientMessage(i, color, str);
	}
	return 1;
}
script SendJobMessage(jobid, color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		foreach (new i : Player) if (PlayerData[i][pJob] == jobid) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (PlayerData[i][pJob] == jobid) {
 		SendClientMessage(i, color, str);
	}
	return 1;
}
script SendVehicleMessage(vehicleid, color, const str[], {Float,_}:...)
{
	static args, start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		foreach (new i : Player) if (GetPlayerVehicleID(i) == vehicleid) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (GetPlayerVehicleID(i) == vehicleid) {
 		SendClientMessage(i, color, string);
	}
	return 1;
}
script SendRadioMessage(frequency, color, const str[], {Float,_}:...)
{
	static args,start,end,string[144];
	#emit LOAD.S.pri 8
	#emit STOR.pri args
	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		foreach (new i : Player) if (Inventory_HasItem(i, "Talkie-Walkie") && PlayerData[i][pChannel] == frequency) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (Inventory_HasItem(i, "Talkie-Walkie") && PlayerData[i][pChannel] == frequency) {
 		SendClientMessage(i, color, str);
	}
	return 1;
}
script SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static args,str[144];
	if ((args = numargs()) == 3) {SendClientMessage(playerid, color, text);}
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
script SendClientMessageToAllEx(color, const text[], {Float, _}:...)
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
script Log_Write(const path[], const str[], {Float,_}:...)
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
	if (!file)
	    return 0;
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
//antideamx a la fin
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
