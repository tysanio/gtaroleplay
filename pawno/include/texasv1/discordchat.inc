#include <YSI\y_va>
new DCC_Channel:BotChannel;
script SendDC(channel[], const fmat[], va_args<>)
{
    new str[145];
    va_format(str, sizeof (str), fmat, va_start<2>);
    BotChannel = DCC_FindChannelById(channelnormal);
    DCC_SendChannelMessage(BotChannel, str);
}
script DCC_OnMessageCreate(DCC_Message:message)//mettre dans un autre mieux que sa et faire que sa apparais pas ailleur
{
	new string[128],string2[128],string3[128],user1[32+1],user,channel_name[100 + 1],lol,DCC_Guild:guild = DCC_FindGuildById(info_serveursetting[lol][settingdiscord]);
	if(!DCC_GetMessageChannel(message,BotChannel))
	    return 0;
	if(!DCC_GetChannelName(BotChannel, channel_name))
		return 0;
	if (guild == DCC_INVALID_GUILD)
    	return 0;
	DCC_GetMessageContent(message, string);
	DCC_GetMessageAuthor(DCC_Message:message,DCC_User:user);
	DCC_GetUserName(DCC_User:user,user1,128);
	format(string, sizeof string, "%s",string);
	format(string2, sizeof string2, "%s",user1);
	format(string3, sizeof string3, "[Discord]%s : {ffffff}%s",string2,string);
    foreach(new I : Player)
	{
		if (PlayerData[I][pDiscordChat] == 1)
		{
			SendClientMessage(I,0x667acaBB,string3);
		}
	}
	return 1;
}
CMD:dc(playerid, params[])
{
	SendErrorMessage(playerid,"Temporairement désactivé");
	/*new tmp[512], name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if (PlayerData[playerid][pDiscordChat] == 0) return SendErrorMessage(playerid,"Le chat discord n'est pas allumer /discordchat.");
	if (sscanf(params, "s[512]", tmp)) return SendSyntaxMessage(playerid, "Usage: /dc [message]");
	SendDC(channelnormal, "%s: %s", name, tmp);*/
	return 1;
}
CMD:discordchat(playerid, params[])
{
	SendErrorMessage(playerid,"Temporairement désactivé");
	/*new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	if (PlayerData[playerid][pDiscordChat] == 0)
	{
		PlayerData[playerid][pDiscordChat] = 1;
		SendServerMessage(playerid,"Chat discord mis à on /dc pour écrire!");
		SendServerMessage(playerid,"Attention /dc [texte] pour voir les messages ooc seulement!");
		SendServerMessage(playerid,"Attention le /fac [texte] fera en sorte que vous voyez les messages de votre faction seulement!");
		return 1;
	}
	else
	{
		PlayerData[playerid][pDiscordChat] = 0;
		SendServerMessage(playerid,"Chat discord mis à off vous ne recevrez plus les messages discord.");
		return 1;
	}*/
}
CMD:dcbot(playerid,params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "Vous n'êtes pas autorisé à utiliser cette commande.");
	new tmp[32];
	if (sscanf(params, "s[32]", tmp)) return SendSyntaxMessage(playerid, "Usage: /dcbot [message] [32 caratères MAX]");
	format(tmp, sizeof(tmp), "%s", tmp);
	DCC_SetBotActivity(tmp);
	SendServerMessage(playerid,"Message mis sur le bot discord : %s",tmp);
	return 1;
}