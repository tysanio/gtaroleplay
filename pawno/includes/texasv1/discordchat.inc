#include <YSI\y_va>
new DCC_Channel:BotChannel;
script SendDC(channel[], const fmat[], va_args<>)
{
    new str[145];
    va_format(str, sizeof (str), fmat, va_start<2>);
	BotChannel = DCC_FindChannelById(channel);
    return DCC_SendChannelMessage(BotChannel, str);
}
script DCC_OnChannelMessage(DCC_Channel:channel, DCC_User:author, const message[])
{
	new channel_name[100 + 1];
	if(!DCC_GetChannelName(channel, channel_name))
		return 0;
	new user_name[32 + 1];
	if (!DCC_GetUserName(author, user_name))
		return 0;
    if(channel != BotChannel) return 0;
	new str[145];
	format(str, sizeof str, "[Discord] %s :{ffffff} %s", user_name, message);
    foreach (new i : Player) {
    if (PlayerData[i][pDiscordChat] == 0) continue;
    SendClientMessage(i,0x667acaBB, str); }
	Log_Write("logs/discordchat.txt", "[%s] %s", ReturnDate(),str);
    return 1;
}
CMD:dc(playerid, params[])
{
	new tmp[512], name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if (PlayerData[playerid][pDiscordChat] == 0) return SendErrorMessage(playerid,"Le chat discord n'est pas allumer /discordchat.");
	if (sscanf(params, "s[512]", tmp)) return SendSyntaxMessage(playerid, "Usage: /dc [message]");
	SendDC(channelnormal, "%s: %s", name, tmp);
	return 1;
}
CMD:discordchat(playerid, params[])
{
	new playername[MAX_PLAYER_NAME];
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
	}
}