// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <a_mysql1>
#include <streamer>
#include <sscanf2>
#include <zcmd>

#include <dialogs>
#include <file-import>

#define MAX_PLAYER_POKER_UI				(47)
#define POKER_OBJECT                    (19474)

#define script%0(%1) forward%0(%1); public%0(%1)

#define COLOR_GREY        				(0xAFAFAFBB)
#define COLOR_ERROR        				(0xFF0000BB)
#define COLOR_YELLOW    	  			(0xFFFF00AA)

#define OPTION_SETUP_GAME     		(0)
#define OPTION_BUY_IN_MAX			(1)
#define OPTION_BUY_IN_MIN			(2)
#define OPTION_BLINDS				(3)
#define OPTION_PLAYERS_LIMIT		(4)
#define OPTION_SET_KEY				(5)
#define OPTION_ROUND_DELAY			(6)
#define OPTION_BUY_IN				(7)
#define OPTION_CALL					(8)
#define OPTION_RAISE     			(9)
#define OPTION_SEAT_PRICE           (10)
new Float:PokerTableMiscObjOffsets[6][6] =
{
	{-1.25, -0.470, 0.1, 0.0, 0.0, 180.0}, // (Slot 2)
	{-1.25, 0.470, 0.1, 0.0, 0.0, 180.0}, // (Slot 1)
	{0.01, 1.85, 0.1, 0.0, 0.0, 90.0},  // (Slot 6)
	{1.25, 0.470, 0.1, 0.0, 0.0, 0.0}, // (Slot 5)
	{1.25, -0.470, 0.1, 0.0, 0.0, 0.0}, // (Slot 4)
	{-0.01, -1.85, 0.1, 0.0, 0.0, -90.0} // (Slot 3)
};
enum
{
	Two = 1,
	Three,
	Four,
	Five,
	Six,
	Seven,
	Eight,
	Nine,
	Ten,
	Jack,
	Queen,
	King,
	Ace
}
enum
{
	HighCard = 1,
	Pair,
	TwoPairs,
	ThreeOfKind,
	Straight,
	Flush,
	FullHouse,
	Poker,
	StraightFlush,
	RoyalFlush
}
enum E_CARDS
{
	cardName[32],
	cardChar,
	cardValue
};
new PokerCards[52][E_CARDS] =
{
	{"ld_card:cd1c", 'c', 11},
	{"ld_card:cd2c", 'c', 2},
	{"ld_card:cd3c", 'c', 3},
	{"ld_card:cd4c", 'c', 4},
	{"ld_card:cd5c", 'c', 5},
	{"ld_card:cd6c", 'c', 6},
	{"ld_card:cd7c", 'c', 6},
	{"ld_card:cd8c", 'c', 7},
	{"ld_card:cd9c", 'c', 8},
	{"ld_card:cd10c", 'c', 9},
	{"ld_card:cd11c", 'c', 10},
	{"ld_card:cd12c", 'c', 10},
	{"ld_card:cd13c", 'c', 10},

	{"ld_card:cd1d", 'd', 1},
	{"ld_card:cd2d", 'd', 2},
	{"ld_card:cd3d", 'd', 3},
	{"ld_card:cd4d", 'd', 4},
	{"ld_card:cd5d", 'd', 5},
	{"ld_card:cd6d", 'd', 6},
	{"ld_card:cd7d", 'd', 7},
	{"ld_card:cd8d", 'd', 8},
	{"ld_card:cd9d", 'd', 9},
	{"ld_card:cd10d", 'd', 10},
	{"ld_card:cd11d", 'd', 10},
	{"ld_card:cd12d", 'd', 10},
	{"ld_card:cd13d", 'd', 10},

	{"ld_card:cd1h", 'h', 11},
	{"ld_card:cd2h", 'h', 2},
	{"ld_card:cd3h", 'h', 3},
	{"ld_card:cd4h", 'h', 4},
	{"ld_card:cd5h", 'h', 5},
	{"ld_card:cd6h", 'h', 6},
	{"ld_card:cd7h", 'h', 7},
	{"ld_card:cd8h", 'h', 8},
	{"ld_card:cd9h", 'h', 9},
	{"ld_card:cd10h", 'h', 10},
	{"ld_card:cd11h", 'h', 10},
	{"ld_card:cd12h", 'h', 10},
	{"ld_card:cd13h", 'h', 10},

	{"ld_card:cd1s", 's', 11},
	{"ld_card:cd2s", 's', 2},
	{"ld_card:cd3s", 's', 3},
	{"ld_card:cd4s", 's', 4},
	{"ld_card:cd5s", 's', 5},
	{"ld_card:cd6s", 's', 6},
	{"ld_card:cd7s", 's', 7},
	{"ld_card:cd8s", 's', 8},
	{"ld_card:cd9s", 's', 9},
	{"ld_card:cd10s", 's', 10},
	{"ld_card:cd11s", 's', 10},
	{"ld_card:cd12s", 's', 10},
	{"ld_card:cd13s", 's', 10}
};
enum E_PLAYERS
{
	pCash,
	pLogged,
	pPokerPremium,
	pTableID,
	pActionOptions,
	pActiveHand,
	pPokerStatusString[32],
	pPokerResultString[32],
	pFirstCard,
	pSecondCard,
	pPokerStatus,
	pChips,
	pActionChoice,
	pCurrentBet,
	pActiveGuest,
	pPokerTime,
	pTableDealer,
	pTableSlot,
	Float:pTableX,
	Float:pTableY,
	Float:pTableZ,
	pTableWinner,
	pPokerHide,
	pTableResult[2]
};
new PlayerInfo[MAX_PLAYERS][E_PLAYERS];
enum g_custom_objects
{
	co_database_id,
	co_price,
	Float:co_pos_x,
	Float:co_pos_y,
	Float:co_pos_z,
	Float:co_rot_x,
	Float:co_rot_y,
	Float:co_rot_z,
	co_opened,
	co_name[100],
	co_table_active,
	co_table_placed,
	Float:co_table_x,
	Float:co_table_y,
	Float:co_table_z,
	Float:co_table_rx,
	Float:co_table_ry,
	Float:co_table_rz,
	co_table_int,
	co_table_vw,
	co_table_guests,
	co_table_active_guests,
	co_table_active_hands,
	co_table_slots[6],
	co_table_key[32],
	co_table_guests_limit,
	co_table_pulse_timer,
	co_table_buy_in_max,
	co_table_buy_in_min,
	co_table_blind,
	co_table_delay,
	co_table_setdelay,
	co_table_pos,
	co_table_rot,
	co_table_slots_rot,
	co_table_active_guest,
	co_table_active_guest_slot,
	co_table_round,
	co_table_stage,
	co_table_active_bet,
	co_table_deck[52],
	co_table_cards[5],
	co_table_pot,
	co_table_winners,
	co_table_winner_id,
	co_table_seat_price
};
new g_obj[g_custom_objects];
new siz_g_obj = g_custom_objects;
//Textdraws
new PlayerText:PlayerPokerUI[MAX_PLAYERS][MAX_PLAYER_POKER_UI];
new dbHandle;
public OnFilterScriptInit()
{
	print("POKER BITCH");
    import File("mysql.ini", host[16], user[24], database[12], password[32])
    {
        dbHandle = mysql_connect(host, user, database, password);
        if(mysql_errno(dbHandle) != 0) printf("Non collegato dal database.");
    }
	mysql_log(LOG_ERROR | LOG_WARNING);
	new query[128];
	mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM furnitures WHERE world = '%d' AND object_id = '0'");
	mysql_tquery(dbHandle, query, "LoadFurnitures");

	return 1;
}
public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerConnect(playerid)
{
    PlayerInfo[playerid][pPokerPremium] = 1;
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerInfo[playerid][pLogged])
	{
		Poker_LeaveTable(playerid);
	}
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	Poker_LeaveTable(playerid);
	return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(PlayerInfo[playerid][pTableID])
	{
		new tableid = PlayerInfo[playerid][pTableID];

		if(playertextid == PlayerPokerUI[playerid][38]) switch(PlayerInfo[playerid][pActionOptions])
	 	{
			case 1: // Raise
			{
				g_obj[co_table_rot] = 0;
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
				Poker_Raise(playerid);
			}
			case 2: Poker_Call(playerid); //Call
			case 3: // Check
			{
				Poker_Check(playerid);
				Poker_RotateGuests(tableid);
			}
			default: return 1;
		}
		else if(playertextid == PlayerPokerUI[playerid][39]) switch(PlayerInfo[playerid][pActionOptions])
		{
			case 1: // Check
			{
				Poker_Check(playerid);
				Poker_RotateGuests(tableid);
			}
			case 2: // Raise
			{
				g_obj[co_table_rot] = 0;
				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
				Poker_Raise(playerid);
			}
			case 3: // Fold
			{
				Poker_Fold(playerid);
				Poker_RotateGuests(tableid);
			}
			default: return 1;
		}
		else if(playertextid == PlayerPokerUI[playerid][40]) switch(PlayerInfo[playerid][pActionOptions])
		{
			case 1: // Fold
			{
				Poker_Fold(playerid);
				Poker_RotateGuests(tableid);
			}
			case 2: // Fold
			{
				Poker_Fold(playerid);
				Poker_RotateGuests(tableid);
			}
			default: return 1;
		}
		else if(playertextid == PlayerPokerUI[playerid][41] && PlayerInfo[playerid][pTableID]) Poker_LeaveTable(playerid);
	}
	return 1;
}
//add some where
//poker_InitTable(objectid);
Dialog:DialogPSetupGame(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_LeaveTable(playerid);

	switch(listitem)
	{
		case 0: Poker_ShowMenu(playerid, OPTION_BUY_IN_MAX);
		case 1: Poker_ShowMenu(playerid, OPTION_BUY_IN_MIN);
		case 2: Poker_ShowMenu(playerid, OPTION_BLINDS);
		case 3: Poker_ShowMenu(playerid, OPTION_PLAYERS_LIMIT);
		case 4: Poker_ShowMenu(playerid, OPTION_SET_KEY);
		case 5: Poker_ShowMenu(playerid, OPTION_ROUND_DELAY);
		case 6: Poker_ShowMenu(playerid, OPTION_SEAT_PRICE);
		case 7: Poker_ShowMenu(playerid, OPTION_BUY_IN);
	}

	return 1;
}

Dialog:DialogPBuyInMax(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(strval(inputtext) < 1 || strval(inputtext) > 10000) return
		Poker_ShowMenu(playerid, OPTION_BUY_IN_MAX);

	if(strval(inputtext) <= g_obj[co_table_buy_in_min]) return
		Poker_ShowMenu(playerid, OPTION_BUY_IN_MAX);

	g_obj[co_table_buy_in_max] = strval(inputtext);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPSeatPrice(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(strval(inputtext) < 0 || strval(inputtext) > 200) return
		Poker_ShowMenu(playerid, OPTION_SEAT_PRICE);

	g_obj[co_table_seat_price] = strval(inputtext);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPBuyInMin(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(strval(inputtext) < 1 || strval(inputtext) > 10000) return
		Poker_ShowMenu(playerid, OPTION_BUY_IN_MIN);

	if(strval(inputtext) >= g_obj[co_table_buy_in_max]) return
		Poker_ShowMenu(playerid, OPTION_BUY_IN_MIN);

	g_obj[co_table_buy_in_min] = strval(inputtext);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPBlinds(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];

	if(strval(inputtext) < 1 || strval(inputtext) > 10000) return
		Poker_ShowMenu(playerid, OPTION_BLINDS);

	g_obj[co_table_blind] = strval(inputtext);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPPlayersLimit(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];

	if(strval(inputtext) < 2 || strval(inputtext) > 6) return
		Poker_ShowMenu(playerid, OPTION_PLAYERS_LIMIT);

	g_obj[co_table_guests_limit] = strval(inputtext);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPKey(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];

	strmid(g_obj[co_table_key], inputtext, 0, strlen(inputtext), 32);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPDelay(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	new tableid = PlayerInfo[playerid][pTableID];

	if(strval(inputtext) < 15 || strval(inputtext) > 120) return
		Poker_ShowMenu(playerid, OPTION_ROUND_DELAY);

	g_obj[co_table_setdelay] = strval(inputtext);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_ShowMenu(playerid, OPTION_SETUP_GAME);

	return 1;
}

Dialog:DialogPBuyIn(playerid, response, listitem, inputtext[])
{
	if(!response)return
		Poker_LeaveTable(playerid);

	new tableid = PlayerInfo[playerid][pTableID];
	new amount = strval(inputtext);

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(amount < g_obj[co_table_buy_in_min] || amount > g_obj[co_table_buy_in_max] || amount > PlayerInfo[playerid][pCash])return
		Poker_ShowMenu(playerid, OPTION_BUY_IN);

	g_obj[co_table_active_guests]++;

	PlayerInfo[playerid][pChips] += amount;

	GivePlayerMoney(playerid, -amount);
	SendClientMessage(playerid,-1,"/poker chips");

	if(g_obj[co_table_active] == 3 && g_obj[co_table_round] == 0 && g_obj[co_table_delay] >= 6) PlayerInfo[playerid][pPokerStatus] = 1;
	if(g_obj[co_table_active] < 3) PlayerInfo[playerid][pPokerStatus] = 1;

	if(g_obj[co_table_active] == 1)
	{
		g_obj[co_table_active] = 2;
		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

		KillTimer(g_obj[co_table_pulse_timer]);
		g_obj[co_table_pulse_timer] = SetTimerEx("Poker_Timer", 1000, true, "d", tableid);
	}

	SelectTextDraw(playerid, COLOR_YELLOW);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	return 1;
}

Dialog:DialogPCall(playerid, response, listitem, inputtext[])
{
	PlayerInfo[playerid][pActionChoice] = 0;

	if(!response)return 0;

	new tableid = PlayerInfo[playerid][pTableID];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	new actualBet = g_obj[co_table_active_bet] - PlayerInfo[playerid][pCurrentBet];

	if(actualBet > PlayerInfo[playerid][pChips])
	{
		g_obj[co_table_pot] += PlayerInfo[playerid][pChips];
		PlayerInfo[playerid][pChips] = 0;
		PlayerInfo[playerid][pCurrentBet] = g_obj[co_table_active_bet];
	}
	else
	{
		g_obj[co_table_pot] += actualBet;
		PlayerInfo[playerid][pChips] -= actualBet;
		PlayerInfo[playerid][pCurrentBet] = g_obj[co_table_active_bet];
	}

	format(PlayerInfo[playerid][pPokerStatusString], 16, "Call");

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
	Poker_RotateGuests(tableid);

	ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);

	return 1;
}

Dialog:DialogPRaise(playerid, response, listitem, inputtext[])
{
	PlayerInfo[playerid][pActionChoice] = 0;

	if(!response)return 0;

	new tableid = PlayerInfo[playerid][pTableID];
	new actualRaise = strval(inputtext) - PlayerInfo[playerid][pCurrentBet];

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(strval(inputtext) >= g_obj[co_table_active_bet] + g_obj[co_table_blind] / 2 && strval(inputtext) <= PlayerInfo[playerid][pCurrentBet] + PlayerInfo[playerid][pChips])
	{
		g_obj[co_table_pot] += actualRaise;
		g_obj[co_table_active_bet] = strval(inputtext);

		PlayerInfo[playerid][pChips] -= actualRaise;
		PlayerInfo[playerid][pCurrentBet] = g_obj[co_table_active_bet];
		format(PlayerInfo[playerid][pPokerStatusString], 16, "Raise");

		g_obj[co_table_rot] = 0;

		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
		Poker_RotateGuests(tableid);

		ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
	}
	else Poker_ShowMenu(playerid, OPTION_RAISE);

	return 1;
}

Dialog:DialogPEnter(playerid, response, listitem, inputtext[])
{
	if(!response)return
		PlayerInfo[playerid][pTableID] = 0;

	new objectid = PlayerInfo[playerid][pTableID];
    Streamer_GetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
	if(isnull(inputtext) || strcmp(g_obj[co_table_key], inputtext, false) > 0)return
	    Dialog_Show(playerid, DialogPEnter, DIALOG_STYLE_PASSWORD, "Poker - Entra", "Password errata.\n\nInserisci la password per entrare nella partita di poker:", "Entra", "Annulla");

	Poker_JoinTable(playerid, objectid);

	return 1;
}
CMD:poker(playerid, params[])
{
	if(isnull(params) || strlen(params) > 24)return
	    SendClientMessageEx(playerid, COLOR_GREY, "/poker <entra - esci>");
	new query[90],VW = GetPlayerVirtualWorld(playerid);
	if(!strcmp(params, "entra", true))
	{
		if(PlayerInfo[playerid][pTableID])return
		    SendClientMessageEx(playerid, COLOR_ERROR, "Stai già giocando a poker.");

		mysql_format(dbHandle, query, sizeof(query), "SELECT * FROM furnitures WHERE world = %d AND model = %d", VW, POKER_OBJECT);
		mysql_tquery(dbHandle, query, "OnFurnitureOptions", "dd", playerid, 2);
	}
	else if(!strcmp(params, "esci", true))
	{
		if(!PlayerInfo[playerid][pTableID])return
		    SendClientMessageEx(playerid, COLOR_ERROR, "Non stai giocando a poker.");

		Poker_LeaveTable(playerid);
	}
	else return
	    SendClientMessageEx(playerid, COLOR_ERROR, "Parametro inesistente.");

	return 1;
}
//Poker System
Poker_WinnerHand(cards[5], hands[2], &p_value, &p_kicker)
{
	new best_value;
	new best_kicker;

	new value;
	new kicker;

	for(new i; i < 21; i++)
	{
		switch(i)
		{
			case 0: Poker_AnalyzeHand(cards[0], cards[1], cards[2], cards[3], cards[4], value, kicker);
			case 1: Poker_AnalyzeHand(cards[0], cards[1], cards[2], hands[0], hands[1], value, kicker);
			case 2: Poker_AnalyzeHand(cards[0], cards[1], cards[3], hands[0], hands[1], value, kicker);
			case 3: Poker_AnalyzeHand(cards[0], cards[1], cards[4], hands[0], hands[1], value, kicker);
			case 4: Poker_AnalyzeHand(cards[0], cards[2], cards[3], hands[0], hands[1], value, kicker);
			case 5: Poker_AnalyzeHand(cards[0], cards[2], cards[4], hands[0], hands[1], value, kicker);
			case 6: Poker_AnalyzeHand(cards[0], cards[3], cards[4], hands[0], hands[1], value, kicker);
			case 7: Poker_AnalyzeHand(cards[1], cards[2], cards[3], hands[0], hands[1], value, kicker);
			case 8: Poker_AnalyzeHand(cards[1], cards[2], cards[4], hands[0], hands[1], value, kicker);
			case 9: Poker_AnalyzeHand(cards[1], cards[3], cards[4], hands[0], hands[1], value, kicker);
			case 10: Poker_AnalyzeHand(cards[2], cards[3], cards[4], hands[0], hands[1], value, kicker);
			case 11: Poker_AnalyzeHand(cards[0], cards[1], cards[2], cards[3], hands[0], value, kicker);
			case 12: Poker_AnalyzeHand(cards[0], cards[1], cards[2], cards[4], hands[0], value, kicker);
			case 13: Poker_AnalyzeHand(cards[0], cards[1], cards[3], cards[4], hands[0], value, kicker);
			case 14: Poker_AnalyzeHand(cards[0], cards[2], cards[3], cards[4], hands[0], value, kicker);
			case 15: Poker_AnalyzeHand(cards[1], cards[2], cards[3], cards[4], hands[0], value, kicker);
			case 16: Poker_AnalyzeHand(cards[0], cards[1], cards[2], cards[3], hands[1], value, kicker);
			case 17: Poker_AnalyzeHand(cards[0], cards[1], cards[2], cards[4], hands[1], value, kicker);
			case 18: Poker_AnalyzeHand(cards[0], cards[1], cards[3], cards[4], hands[1], value, kicker);
			case 19: Poker_AnalyzeHand(cards[0], cards[2], cards[3], cards[4], hands[1], value, kicker);
			case 20: Poker_AnalyzeHand(cards[1], cards[2], cards[3], cards[4], hands[1], value, kicker);
		}

        if(value > best_value)
        {
			best_value = value;
			best_kicker = kicker;
        }
        else if(value == best_value && kicker > best_kicker) best_kicker = kicker;
	}

	p_value = best_value;
	p_kicker = best_kicker; return 1;
}

Poker_AnalyzeHand(card_1, card_2, card_3, card_4, card_5, &value, &kicker)
{
    new card[5];
	new card_suit[5];
	new card_value[5];

	card[0] = card_1;
	card[1] = card_2;
	card[2] = card_3;
	card[3] = card_4;
	card[4] = card_5;

	for(new i; i < 5; i++)
	{
	    new tmp_card = card[i];

		card_suit[i] = PokerCards[tmp_card][cardChar];
		card_value[i] = PokerCards[tmp_card][cardValue];
	}

	ArraySort(card_value, 5);

	if(card_value[0] == card_value[1] - 1 && card_value[1] == card_value[2] - 1 && card_value[2] == card_value[3] - 1 && card_value[3] == card_value[4] - 1 &&
	card_suit[0] == card_suit[1] && card_suit[1] == card_suit[2] && card_suit[2] == card_suit[3] && card_suit[3] == card_suit[4])
	{
		value = (card_value[4] == Ace) ? RoyalFlush : StraightFlush;
		kicker = (card_value[4] == Ace) ? Ace : card_value[4];
	}
	else if(card_value[0] == Two && card_value[1] == Three && card_value[2] == Four && card_value[3] == Five && card_value[4] == Ace &&
	card_suit[0] == card_suit[1] && card_suit[1] == card_suit[2] && card_suit[2] == card_suit[3] && card_suit[3] == card_suit[4])
	{
		value = StraightFlush;
		kicker = Five;
	}
	else if(card_value[0] == card_value[1] && card_value[1] == card_value[2] && card_value[2] == card_value[3])
	{
		value = Poker;
		kicker = card_value[0] * 20 + card_value[4];
	}
	else if(card_value[1] == card_value[2] && card_value[2] == card_value[3] && card_value[3] == card_value[4])
	{
		value = Poker;
		kicker = card_value[1] * 20 + card_value[0];
	}
	else if(card_value[0] == card_value[1] && card_value[2] == card_value[3] && card_value[3] == card_value[4])
	{
		value = FullHouse;
		kicker = card_value[0] + card_value[2] * 20;
	}
	else if(card_value[0] == card_value[1] && card_value[1] == card_value[2] && card_value[3] == card_value[4])
	{
		value = FullHouse;
		kicker = card_value[0] * 20 + card_value[3];
	}
	else if(card_suit[0] == card_suit[1] && card_suit[1] == card_suit[2] && card_suit[2] == card_suit[3] && card_suit[3] == card_suit[4])
	{
		value = Flush;
		kicker = card_value[4] * 160000 + card_value[3] * 8000 + card_value[2] * 400 + card_value[1] * 20 + card_value[0];
	}
	else if(card_value[0] == card_value[1] - 1 && card_value[1] == card_value[2] - 1 && card_value[2] == card_value[3] - 1 && card_value[3] == card_value[4] - 1)
	{
		value = Straight;
		kicker = card_value[4];
	}
	else if(card_value[0] == Two && card_value[1] == Three && card_value[2] == Four && card_value[3] == Five && card_value[4] == Ace)
	{
		value = Straight;
	    kicker = Five;
	}
	else if(card_value[0] == card_value[1] && card_value[1] == card_value[2])
	{
		value = ThreeOfKind;
		kicker = card_value[0] * 400 + card_value[3] + card_value[4] * 20;
	}
	else if(card_value[1] == card_value[2] && card_value[2] == card_value[3])
	{
		value = ThreeOfKind;
		kicker = card_value[1] * 400 + card_value[0] + card_value[4] * 20;
	}
	else if(card_value[2] == card_value[3] && card_value[3] == card_value[4])
	{
		value = ThreeOfKind;
		kicker = card_value[1] * 400 + card_value[0] + card_value[1] * 20;
	}
	else if(card_value[0] == card_value[1] && card_value[2] == card_value[3])
	{
		value = TwoPairs;
		kicker = card_value[0] * 20 + card_value[2] * 400 + card_value[4];
	}
	else if(card_value[0] == card_value[1] && card_value[3] == card_value[4])
	{
		value = TwoPairs;
		kicker = card_value[0] * 20 + card_value[3] * 400 + card_value[2];
	}
	else if(card_value[1] == card_value[2] && card_value[3] == card_value[4])
	{
		value = TwoPairs;
		kicker = card_value[1] * 20 + card_value[3] * 400 + card_value[0];
	}
	else if(card_value[0] == card_value[1])
	{
		value = Pair;
		kicker = card_value[0] * 8000 + card_value[2] + card_value[3] * 20 + card_value[4] * 400;
	}
	else if(card_value[1] == card_value[2])
	{
		value = Pair;
		kicker = card_value[1] * 8000 + card_value[0] + card_value[3] * 20 + card_value[4] * 400;
	}
	else if(card_value[2] == card_value[3])
	{
		value = Pair;
		kicker = card_value[2] * 8000 + card_value[0] + card_value[1] * 20 + card_value[4] * 400;
	}
	else if(card_value[3] == card_value[4])
	{
		value = Pair;
		kicker = card_value[3] * 8000 + card_value[0] + card_value[1] * 20 + card_value[2] * 400;
	}
	else
	{
		value = HighCard;
		kicker = card_value[4] * 160000 + card_value[3] * 8000 + card_value[2] * 400 + card_value[1] * 20 + card_value[0];
	}

	return 1;
}

Poker_Timer(tableid); public Poker_Timer(tableid)
{
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(!g_obj[co_table_active])return KillTimer(g_obj[co_table_pulse_timer]);
	if(g_obj[co_table_guests] <= 0)return Reset_ResetTable(tableid);

	for(new i = 0; i < 6; i++)  if(g_obj[co_table_slots][i] != -1)
	{
		new playerid = g_obj[co_table_slots][i];
		new idleRandom = random(100);

		SetPlayerArmedWeapon(playerid, 0);

		if(idleRandom >= 90)
		{
			SetPlayerPosObjectOffset(tableid, playerid, PokerTableMiscObjOffsets[i][0], PokerTableMiscObjOffsets[i][1], PokerTableMiscObjOffsets[i][2]);
			SetPlayerFacingAngle(playerid, PokerTableMiscObjOffsets[i][5] + 90.0);
			SetPlayerInterior(playerid, g_obj[co_table_int]);
			SetPlayerVirtualWorld(playerid, g_obj[co_table_vw]);

			if(PlayerInfo[playerid][pActiveHand])  ApplyAnimation(playerid, "CASINO", "cards_loop", 4.1, 0, 1, 1, 1, 1, 1);
		}
		else continue;
	}

	if(g_obj[co_table_active_guests] >= 2 && g_obj[co_table_active] == 2)  for(new i = 0; i < 6; i++)
	{
		new playerid = g_obj[co_table_slots][i];

		if(playerid != -1 && PlayerInfo[playerid][pChips])
		{
			g_obj[co_table_active] = 3;
			g_obj[co_table_delay] = g_obj[co_table_setdelay]; break;
		}
		else continue;
	}

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(g_obj[co_table_guests] < 2) if(g_obj[co_table_active] == 3 || g_obj[co_table_active] == 4)  for(new i = 0; i < 6; i++)
	{
		new playerid = g_obj[co_table_slots][i];

		if(playerid != -1 && PlayerInfo[playerid][pChips])
		{
			PlayerInfo[playerid][pChips] += g_obj[co_table_pot];

			Poker_LeaveTable(playerid);
		}
		else continue;
	}

	if(g_obj[co_table_active] == 4)
	{
		if(g_obj[co_table_delay] == 20)  for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
		{
			PlayerPlaySound(g_obj[co_table_slots][i], 5826, 0.0, 0.0, 0.0);
			Poker_ShowOptions(g_obj[co_table_slots][i], 0);
		}

		if(g_obj[co_table_delay] > 0)
		{
			g_obj[co_table_delay]--;

			if(g_obj[co_table_delay] <= 5 && g_obj[co_table_delay] > 0) for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1) PlayerPlaySound(g_obj[co_table_slots][i], 1139, 0.0, 0.0, 0.0);
			if(g_obj[co_table_delay] == 0) return Poker_ResetTableRound(tableid);
		}

		if(g_obj[co_table_delay] == 19)
		{
			new cards[5];
			new hands[2];

			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
				new playerid = g_obj[co_table_slots][i];

				if(PlayerInfo[playerid][pActiveHand])
				{
					for(new c; c < 5; c++)
						cards[c] = g_obj[co_table_cards][c];

					hands[0] = PlayerInfo[playerid][pFirstCard];
					hands[1] = PlayerInfo[playerid][pSecondCard];

					Poker_WinnerHand(cards, hands, PlayerInfo[playerid][pTableResult][0], PlayerInfo[playerid][pTableResult][1]);
				}
				else continue;
			}

			new best_value;
			new best_kicker;

			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
				new playerid = g_obj[co_table_slots][i];

				if(!PlayerInfo[playerid][pActiveHand])continue;

				if(PlayerInfo[playerid][pTableResult][0] > best_value)
    			{
    			    best_value = PlayerInfo[playerid][pTableResult][0];
    			    best_kicker = PlayerInfo[playerid][pTableResult][1];
				}
				else if(PlayerInfo[playerid][pTableResult][0] == best_value && PlayerInfo[playerid][pTableResult][1] > best_kicker) best_kicker = PlayerInfo[playerid][pTableResult][1];
			}

			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
			    new playerid = g_obj[co_table_slots][i];

				if(PlayerInfo[playerid][pTableResult][0] == best_value && PlayerInfo[playerid][pTableResult][1] == best_kicker) g_obj[co_table_winners]++;
			}

			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
				new playerid = g_obj[co_table_slots][i];

				if(PlayerInfo[playerid][pTableResult][0] == best_value && PlayerInfo[playerid][pTableResult][1] == best_kicker)
				{
					switch(best_value)
					{
						case HighCard: format(PlayerInfo[playerid][pPokerResultString], 32, "Carta alta");
						case Pair: format(PlayerInfo[playerid][pPokerResultString], 32, "Coppia");
						case TwoPairs: format(PlayerInfo[playerid][pPokerResultString], 32, "Doppia coppia");
						case ThreeOfKind: format(PlayerInfo[playerid][pPokerResultString], 32, "Tris");
						case Straight: format(PlayerInfo[playerid][pPokerResultString], 32, "Scala");
						case Flush: format(PlayerInfo[playerid][pPokerResultString], 32, "Colore");
						case FullHouse: format(PlayerInfo[playerid][pPokerResultString], 32, "Full");
						case Poker: format(PlayerInfo[playerid][pPokerResultString], 32, "Poker");
						case StraightFlush: format(PlayerInfo[playerid][pPokerResultString], 32, "Scala colore");
						case RoyalFlush: format(PlayerInfo[playerid][pPokerResultString], 32, "Scala reale");
					}

					new splitPot = g_obj[co_table_pot] / g_obj[co_table_winners];

					if(g_obj[co_table_winners] < 2)
					{
						splitPot = g_obj[co_table_pot];
						g_obj[co_table_winner_id] = playerid;
						PlayerPlaySound(playerid, 5847, 0.0, 0.0, 0.0);
					}
					else PlayerPlaySound(playerid, 5821, 0.0, 0.0, 0.0);

					PlayerInfo[playerid][pTableWinner] = 1;
					PlayerInfo[playerid][pChips] += splitPot;
				}
				else PlayerPlaySound(playerid, 31202, 0.0, 0.0, 0.0);
			}
			else continue;
		}

		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
	}

	if(g_obj[co_table_active] == 3)
	{
		if(g_obj[co_table_active_hands] == 1 && g_obj[co_table_round] == 1)
		{
			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
				new playerid = g_obj[co_table_slots][i];

				if(PlayerInfo[playerid][pActiveHand])
					PlayerInfo[playerid][pPokerHide] = 1;
			}

			g_obj[co_table_stage] = 0;
			g_obj[co_table_active] = 4;
			g_obj[co_table_delay] = 20 + 1;
		}

		if(g_obj[co_table_delay] > 0)
		{
			g_obj[co_table_delay]--;

			if(g_obj[co_table_delay] <= 5 && g_obj[co_table_delay] > 0) for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1) PlayerPlaySound(g_obj[co_table_slots][i], 1139, 0.0, 0.0, 0.0);
		}

		if(g_obj[co_table_round] == 0 && g_obj[co_table_delay] == 5)
		{
			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
				new playerid = g_obj[co_table_slots][i];
				PlayerInfo[playerid][pPokerStatus] = 1;
			}

			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
			Poker_AssignBlinds(tableid);
		}

		if(g_obj[co_table_round] == 0 && g_obj[co_table_delay] == 0)
		{
			g_obj[co_table_round] = 1;

			for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
			{
				new playerid = g_obj[co_table_slots][i];
				PlayerInfo[playerid][pPokerStatusString] = '\0';
			}

			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
			Poker_ShuffleDeck(tableid);
			Poker_RotateGuests(tableid);
		}

		for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
		{
			new playerid = g_obj[co_table_slots][i];

			if(PlayerInfo[playerid][pActiveGuest])
			{
				PlayerInfo[playerid][pPokerTime]--;

				if(PlayerInfo[playerid][pPokerTime])continue;

				if(PlayerInfo[playerid][pActionChoice])
				{
					PlayerInfo[playerid][pActionChoice] = 0;
					Dialog_Close(playerid);
				}

				Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
				Poker_Fold(playerid);
				Poker_RotateGuests(tableid);
			}
			else continue;
		}

		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
	}

	for(new i = 0; i < 6; i++)
	{
		new playerid = g_obj[co_table_slots][i];
		new tmpString[128];
		new tmp_value[6] = {0, 5, 10, 15, 20, 25};

		if(playerid != -1)
		{
			new name[MAX_PLAYER_NAME];
			strmid(name, ReturnRoleplayName(playerid),0, MAX_PLAYER_NAME);

			for(new td = 0; td < 6; td++)
			{
				new pid = g_obj[co_table_slots][td];
				if(pid != -1) PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 0], name);
			}

			if(PlayerInfo[playerid][pChips] > 0) format(tmpString, sizeof(tmpString), "~y~$%d", PlayerInfo[playerid][pChips]);
			if(PlayerInfo[playerid][pChips] < 0) format(tmpString, sizeof(tmpString), "~r~$%d", PlayerInfo[playerid][pChips]);

			for(new td = 0; td < 6; td++)
			{
				new pid = g_obj[co_table_slots][td];
				if(pid != -1) PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 1], tmpString);
			}

			for(new td = 0; td < 6; td++) if(g_obj[co_table_slots][td] != -1)
			{
				new pid = g_obj[co_table_slots][td];

				if(PlayerInfo[playerid][pActiveHand])
				{
					if(playerid != pid)
					{
						if(g_obj[co_table_active] == 4 && g_obj[co_table_delay] <= 19 && PlayerInfo[playerid][pPokerHide] != 1)
						{
							strmid(tmpString, PokerCards[PlayerInfo[playerid][pFirstCard] + 0][cardName], 0, 32);
							PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 2], tmpString);

							strmid(tmpString, PokerCards[PlayerInfo[playerid][pSecondCard] + 0][cardName], 0, 32);
							PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 3], tmpString);
						}
						else
						{
							PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 2], "LD_CARD:cdback");
							PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 3], "LD_CARD:cdback");
						}

						continue;
					}

					strmid(tmpString, PokerCards[PlayerInfo[playerid][pFirstCard] + 0][cardName], 0, 32);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][tmp_value[i] + 2], tmpString);

					strmid(tmpString, PokerCards[PlayerInfo[playerid][pSecondCard] + 0][cardName], 0, 32);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][tmp_value[i] + 3], tmpString);
				}
				else
				{
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 2], " ");
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 3], " ");
				}

				continue;
			}

			if(g_obj[co_table_active] < 3)  format(tmpString, sizeof(tmpString), " ");
			else if(PlayerInfo[playerid][pActiveGuest] && g_obj[co_table_active] == 3) format(tmpString, sizeof(tmpString), "0:%d", PlayerInfo[playerid][pPokerTime]);
			else
			{
				if(g_obj[co_table_active] == 3 && g_obj[co_table_delay] > 5)  PlayerInfo[playerid][pPokerStatusString] = '\0';
				if(g_obj[co_table_active] == 4 && g_obj[co_table_delay] == 19)
				{
					if(g_obj[co_table_winners] == 1)
					{
						if(PlayerInfo[playerid][pTableWinner])
						{
							format(tmpString, sizeof(tmpString), "+ $%d", g_obj[co_table_pot]);
							format(PlayerInfo[playerid][pPokerStatusString], 32, tmpString);
						}
						else format(tmpString, sizeof(tmpString), "- $%d", PlayerInfo[playerid][pCurrentBet]);
					}
					else
					{
						if(g_obj[co_table_winners] > 1)
						{
							new splitPot = g_obj[co_table_pot] / g_obj[co_table_winners];
							format(tmpString, sizeof(tmpString), "+ $%d", splitPot);
							format(PlayerInfo[playerid][pPokerStatusString], 32, tmpString);
						}
						else format(tmpString, sizeof(tmpString), "- $%d", PlayerInfo[playerid][pCurrentBet]);
					}

					format(PlayerInfo[playerid][pPokerStatusString], 32, tmpString);
				}

				if(g_obj[co_table_active] == 4 && g_obj[co_table_delay] == 19)
				{
					if(PlayerInfo[playerid][pTableWinner] && PlayerInfo[playerid][pActiveHand] && PlayerInfo[playerid][pPokerHide] != 1)
						format(PlayerInfo[playerid][pPokerStatusString], 32, PlayerInfo[playerid][pPokerResultString]);
				}

				if(g_obj[co_table_active] == 4 && g_obj[co_table_delay] == 10)
				{
					if(g_obj[co_table_winners] == 1)
					{
						if(PlayerInfo[playerid][pTableWinner])
						{
							format(tmpString, sizeof(tmpString), "+ $%d", g_obj[co_table_pot]);
							format(PlayerInfo[playerid][pPokerStatusString], 32, tmpString);
						}
						else  format(tmpString, sizeof(tmpString), "- $%d", PlayerInfo[playerid][pCurrentBet]);
					}
					else
					{
						if(PlayerInfo[playerid][pTableWinner])
						{
							new splitPot = g_obj[co_table_pot]/g_obj[co_table_winners];
							format(tmpString, sizeof(tmpString), "+ $%d", splitPot);
							format(PlayerInfo[playerid][pPokerStatusString], 32, tmpString);
						}
						else  format(tmpString, sizeof(tmpString), "- $%d", PlayerInfo[playerid][pCurrentBet]);
					}

					format(PlayerInfo[playerid][pPokerStatusString], 32, tmpString);
				}

				format(tmpString, 32, PlayerInfo[playerid][pPokerStatusString]);
			}

			for(new td = 0; td < 6; td++)
			{
				new pid = g_obj[co_table_slots][td];
				if(pid != -1) PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 4], tmpString);
			}

			if(g_obj[co_table_active] == 3)
			{
				format(tmpString, sizeof(tmpString), "Piatto: ~y~$%d", g_obj[co_table_pot]);
				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], tmpString);
			}
			else if(g_obj[co_table_active] == 4 && g_obj[co_table_delay] < 19)
			{
				if(g_obj[co_table_winner_id] != -1)
					format(tmpString, sizeof(tmpString), "~y~%s ~w~ha vinto ~y~$%d", ReturnRoleplayName(g_obj[co_table_winner_id]), g_obj[co_table_pot]);

				else if(g_obj[co_table_winners] > 1)
				{
					new splitPot = g_obj[co_table_pot]/g_obj[co_table_winners];
					format(tmpString, sizeof(tmpString), "~y~%d ~w~giocatori hanno vinto ~y~$%d", g_obj[co_table_winners], splitPot);
				}

				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], tmpString);
			}
			else PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], "Texas Holdem Poker");

			if(g_obj[co_table_delay] > 0 && g_obj[co_table_active] == 3)
			{
				format(tmpString, sizeof(tmpString), "La mano comincia tra ~r~%d~w~...", g_obj[co_table_delay]);
				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			}
			else if(g_obj[co_table_active] == 2)
			{
				format(tmpString, sizeof(tmpString), "In attesa di altri giocatori...", g_obj[co_table_pot]);
				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			}
			else if(g_obj[co_table_active] == 3)
			{
				format(tmpString, sizeof(tmpString), "Puntata: ~y~$%d", g_obj[co_table_active_bet]);
				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			}
			else if(g_obj[co_table_active] == 4)
			{
				format(tmpString, sizeof(tmpString), "La mano termina tra ~r~%d~w~...", g_obj[co_table_delay]);
				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			}
			else PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], "Texas Holdem Poker");

			switch(g_obj[co_table_stage])
			{
				case 0:
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], "LD_CARD:cdback");
				}
				case 1:
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], PokerCards[g_obj[co_table_cards][0] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], PokerCards[g_obj[co_table_cards][1] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], PokerCards[g_obj[co_table_cards][2] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], "LD_CARD:cdback");
				}
				case 2:
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], PokerCards[g_obj[co_table_cards][0] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], PokerCards[g_obj[co_table_cards][1] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], PokerCards[g_obj[co_table_cards][2] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], PokerCards[g_obj[co_table_cards][3] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], "LD_CARD:cdback");
				}
				case 3, 4:
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], PokerCards[g_obj[co_table_cards][0] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], PokerCards[g_obj[co_table_cards][1] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], PokerCards[g_obj[co_table_cards][2] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], PokerCards[g_obj[co_table_cards][3] + 0][cardName]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], PokerCards[g_obj[co_table_cards][4] + 0][cardName]);
				}
				default: continue;
			}

			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
		}

		else for(new td = 0; td < 6; td++) if(g_obj[co_table_slots][td] != -1)
		{
			new pid = g_obj[co_table_slots][td];

			PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 0], " ");
			PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 1], " ");
			PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 2], " ");
			PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 3], " ");
			PlayerTextDrawSetString(pid, PlayerPokerUI[pid][tmp_value[i] + 4], " ");
		}
		continue;
	}

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
}

Poker_AssignBlinds(tableid)
{
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(g_obj[co_table_pos] >= g_obj[co_table_guests]) g_obj[co_table_pos] = 0;

	new playerid;
	new tmpPos = g_obj[co_table_pos];

	g_obj[co_table_pos]++;
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(g_obj[co_table_active_guests] > 2)
	{
		playerid = Poker_FindGuestsOrder(tableid, tmpPos);

		if(playerid != -1)
		{
			PlayerInfo[playerid][pTableDealer] = 1;
			format(PlayerInfo[playerid][pPokerStatusString], 32, "Dealer");
		}
		else return Poker_AssignBlinds(tableid);

		tmpPos++;
	}

	if(g_obj[co_table_active_guests] > 1)
	{
		//Small Blind

		if(tmpPos >= g_obj[co_table_guests]) tmpPos = 0;

		playerid = Poker_FindGuestsOrder(tableid, tmpPos);

		if(playerid != -1)
		{
			format(PlayerInfo[playerid][pPokerStatusString], 32, "~r~SB -$%d", g_obj[co_table_blind] / 2);

			g_obj[co_table_pot] += (g_obj[co_table_blind] / 2 > PlayerInfo[playerid][pChips]) ? PlayerInfo[playerid][pChips] : g_obj[co_table_blind] / 2;
			PlayerInfo[playerid][pChips] = (g_obj[co_table_blind] / 2 > PlayerInfo[playerid][pChips]) ? 0 : PlayerInfo[playerid][pChips] - (g_obj[co_table_blind] / 2);

			PlayerInfo[playerid][pCurrentBet] = g_obj[co_table_blind] / 2;
			g_obj[co_table_active_bet] = g_obj[co_table_blind] / 2;

			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
		}
		else return Poker_AssignBlinds(tableid);

		//Big Blind

		tmpPos++; if(tmpPos >= g_obj[co_table_guests]) tmpPos = 0;

		playerid = Poker_FindGuestsOrder(tableid, tmpPos);

		if(playerid != -1)
		{
			format(PlayerInfo[playerid][pPokerStatusString], 32, "~r~BB -$%d", g_obj[co_table_blind]);

			g_obj[co_table_pot] += (PlayerInfo[playerid][pChips] < g_obj[co_table_blind]) ? PlayerInfo[playerid][pChips] : g_obj[co_table_blind];
			PlayerInfo[playerid][pChips] = (PlayerInfo[playerid][pChips] < g_obj[co_table_blind]) ? 0 : PlayerInfo[playerid][pChips]  - g_obj[co_table_blind];

			PlayerInfo[playerid][pCurrentBet] = g_obj[co_table_blind];
			g_obj[co_table_active_bet] = g_obj[co_table_blind];

			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
		}
		else return Poker_AssignBlinds(tableid);
	}

	return 1;
}

Poker_ShuffleDeck(tableid)
{
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

 	for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1) PlayerPlaySound(g_obj[co_table_slots][i], 5600, 0.0, 0.0, 0.0);
	for(new i = 0; i < 52; i++) g_obj[co_table_deck][i] = i;

	new rand;
	new tmp;
	new i;

	for(i = 52; i > 1; i--)
	{
		rand = random(52) % i;
		tmp = g_obj[co_table_deck][rand];
		g_obj[co_table_deck][rand] = g_obj[co_table_deck][i - 1];
		g_obj[co_table_deck][i - 1] = tmp;
	}

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	Poker_DealHands(tableid); return 1;
}

Poker_DealHands(tableid)
{
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	new tmp = 0;

	for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1)
	{
		new playerid = g_obj[co_table_slots][i];

		if(PlayerInfo[playerid][pPokerStatus] && PlayerInfo[playerid][pChips] > 0)
		{
			PlayerInfo[playerid][pFirstCard] = g_obj[co_table_deck][tmp];
			PlayerInfo[playerid][pSecondCard] = g_obj[co_table_deck][tmp + 1];

			PlayerInfo[playerid][pActiveHand] = 1;

			g_obj[co_table_active_hands]++;

			PlayerPlaySound(playerid, 5602, 0.0, 0.0, 0.0);
			ApplyAnimation(playerid, "CASINO", "cards_in", 4.1, 0, 1, 1, 1, 1, 1);

			tmp += 2;
		}
		else continue;
	}

	for(new i = 0; i < 5; i++)
	{
		g_obj[co_table_cards][i] = g_obj[co_table_deck][tmp];
		tmp++;
	}

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
}

Poker_FindGuestsOrder(tableid, index)
{
	new tmpIndex;

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	for(new i = 0; i < 6; i++)
	{
		new playerid = g_obj[co_table_slots][i];

		if(playerid != -1 && tmpIndex == index) if(PlayerInfo[playerid][pPokerStatus] == 1)return playerid;

		tmpIndex++;
	}

	return -1;
}

Poker_RotateGuests(tableid)
{
	new next_active_id = -1;
	new last_ap_id = -1;
	new last_ap_slot = -1;

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(g_obj[co_table_active_guest] != -1)
	{
		last_ap_id = g_obj[co_table_active_guest];

		for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] == last_ap_id) last_ap_slot = i;

		PlayerInfo[last_ap_id][pActiveGuest] = 0;
		PlayerInfo[last_ap_id][pPokerTime] = 0;

		Poker_ShowOptions(last_ap_id, 0);
	}

	if(g_obj[co_table_rot] == 0 && last_ap_id == -1 && last_ap_slot == -1) for(new i = 0; i < 6; i++)
	{
		new playerid = g_obj[co_table_slots][i];

		if(!PlayerInfo[playerid][pTableDealer])continue;

		next_active_id = playerid;
		g_obj[co_table_active_guest] = playerid;
		g_obj[co_table_active_guest_slot] = i;
		g_obj[co_table_rot]++;
		g_obj[co_table_slots_rot] = i;
	}
	else if(g_obj[co_table_rot] >= 6)
	{
		g_obj[co_table_rot] = 0;
		g_obj[co_table_stage]++;

		if(g_obj[co_table_stage] > 3)
		{
			g_obj[co_table_active] = 4;
			g_obj[co_table_delay] = 20 + 1;

			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
		}

		g_obj[co_table_slots_rot]++;
		g_obj[co_table_rot]++;
		if(g_obj[co_table_slots_rot] >= 6)  g_obj[co_table_slots_rot] -= 6;

		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

		new playerid = Poker_FindGuestsOrder(tableid, g_obj[co_table_slots_rot]);

		if(playerid != -1)
		{
			next_active_id = playerid;
			g_obj[co_table_active_guest] = playerid;
			g_obj[co_table_active_guest_slot] = g_obj[co_table_slots_rot];
			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
		}
		else Poker_RotateGuests(tableid);
	}
	else
	{
		g_obj[co_table_slots_rot]++;
		g_obj[co_table_rot]++;
		if(g_obj[co_table_slots_rot] >= 6) g_obj[co_table_slots_rot] -= 6;

		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

		new playerid = Poker_FindGuestsOrder(tableid, g_obj[co_table_slots_rot]);

		if(playerid != -1)
		{
			next_active_id = playerid;
			g_obj[co_table_active_guest] = playerid;
			g_obj[co_table_active_guest_slot] = g_obj[co_table_slots_rot];
			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
		}
		else Poker_RotateGuests(tableid);
	}

	if(next_active_id != -1 && PlayerInfo[next_active_id][pActiveHand])
	{
		new currentBet = PlayerInfo[next_active_id][pCurrentBet];
		new activeBet = g_obj[co_table_active_bet];

		PlayerPlaySound(next_active_id, 5809, 0.0, 0.0, 0.0);

		if(PlayerInfo[next_active_id][pChips] < 1) Poker_ShowOptions(next_active_id, 3);
		else if(currentBet >= activeBet) Poker_ShowOptions(next_active_id, 1);
		else if(currentBet < activeBet) Poker_ShowOptions(next_active_id, 2);
		else Poker_ShowOptions(next_active_id, 0);

		PlayerInfo[next_active_id][pPokerTime] = 60 + 1;
		PlayerInfo[next_active_id][pActiveGuest] = 1;
	}

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
}

Poker_ShowMenu(playerid, option)
{
	new tableid = PlayerInfo[playerid][pTableID];

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	switch(option)
	{
		case OPTION_CALL:
		{
		    PlayerInfo[playerid][pActionChoice] = 1;

			if(PlayerInfo[playerid][pChips] <= 0)
			{
				PlayerPlaySound(playerid, 5823, 0.0, 0.0, 0.0);
				return SendClientMessageEx(playerid, COLOR_ERROR, "DEALER: Non hai abbastanza chips.");
			}

			new actualBet = g_obj[co_table_active_bet] - PlayerInfo[playerid][pCurrentBet];

			if(actualBet > PlayerInfo[playerid][pChips])return
				Dialog_Show(playerid, DialogPCall, DIALOG_STYLE_MSGBOX, "Texas Holdem Poker - (Call)", "Sei sicuro di voler chiamare $%d e cioè All-In?", "All-In", "Indietro", actualBet);

			Dialog_Show(playerid, DialogPCall, DIALOG_STYLE_MSGBOX, "Texas Holdem Poker - (Call)", "Sei sicuro di voler chiamate $%d?", "Call", "Indietro", actualBet);
		}
		case OPTION_RAISE:
		{
			PlayerInfo[playerid][pActionChoice] = 1;

			if(PlayerInfo[playerid][pCurrentBet] + PlayerInfo[playerid][pChips] > g_obj[co_table_active_bet] + g_obj[co_table_blind] / 2)return
				Dialog_Show(playerid, DialogPRaise, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Raise)", "Inserisci la cifra per il Raise ($%d a $%d):", "Raise", "Indietro", g_obj[co_table_active_bet] + g_obj[co_table_blind] / 2, PlayerInfo[playerid][pCurrentBet] + PlayerInfo[playerid][pChips]);

			else if(PlayerInfo[playerid][pCurrentBet] + PlayerInfo[playerid][pChips] == g_obj[co_table_active_bet] + g_obj[co_table_blind] / 2)return
				Dialog_Show(playerid, DialogPRaise, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Raise)", "Inserisci la cifra per il Raise (All-In):", "All-In", "Indietro");

			SendClientMessageEx(playerid, COLOR_ERROR, "DEALER: Non hai abbastanza chips.");
			PlayerPlaySound(playerid, 5823, 0.0, 0.0, 0.0);
		}
		case OPTION_BUY_IN: Dialog_Show(playerid, DialogPBuyIn, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (BuyIn)", "Inserire il buy-in per entrare nel tavolo:\n\nSoldi a disposizione: $%d\nPoker Chips: $%d\nBuy-In da $%d a $%d", "Buy In", "Esci", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pChips], g_obj[co_table_buy_in_min], g_obj[co_table_buy_in_max]);
		case OPTION_SETUP_GAME:
		{
			Dialog_Show(playerid, DialogPSetupGame, DIALOG_STYLE_LIST, "Texas Holdem Poker - (Setup Poker Room)", "Buy-In Max\t($%d)\nBuy-In Min\t($%d)\nBlind\t\t($%d / $%d)\nLimite\t\t(%d)\nPassword\t(%s)\nRound Delay\t(%d)\nSeat Price\t($%d)\n{FF6347}>> Avvia la partita", "Seleziona", "Esci",
			g_obj[co_table_buy_in_max],
			g_obj[co_table_buy_in_min],
			g_obj[co_table_blind],
			g_obj[co_table_blind] / 2,
			g_obj[co_table_guests_limit],
			g_obj[co_table_key],
			g_obj[co_table_setdelay],
			g_obj[co_table_seat_price]);
		}
		case OPTION_BUY_IN_MAX: Dialog_Show(playerid, DialogPBuyInMax, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Buy-In Max)", "Inserire il Buy-In Max:", "Modifica", "Indietro");
		case OPTION_BUY_IN_MIN: Dialog_Show(playerid, DialogPBuyInMin, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Buy-In Min)", "Inserire il Buy-In Min:", "Modifica", "Indietro");
		case OPTION_BLINDS: Dialog_Show(playerid, DialogPBlinds, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Blinds)", "Inserire i Blinds:\n\nNota: Lo Small blind viene calcolato automaticamente (Big Blind / 2).", "Modifica", "Indietro");
		case OPTION_PLAYERS_LIMIT: Dialog_Show(playerid, DialogPPlayersLimit, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Limite)", "Inserire il Limite di giocatori (2 - 6):", "Modifica", "Indietro");
		case OPTION_SET_KEY: Dialog_Show(playerid, DialogPKey, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Password)", "Inserire la Password:\n\nNota: Lascia il campo vuoto se vuoi rendere pubblico il tavolo.", "Modifica", "Indietro");
		case OPTION_ROUND_DELAY: Dialog_Show(playerid, DialogPDelay, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Round Delay)", "Inserire il Round Delay (15 - 120 secondi):", "Modifica", "Indietro");
		case OPTION_SEAT_PRICE: Dialog_Show(playerid, DialogPSeatPrice, DIALOG_STYLE_INPUT, "Texas Holdem Poker - (Seat Price)", "Inserisci il costo per entrare all'interno della partita ($0 - $200):", "Modifica", "Indietro");
	}

	return 1;
}

Poker_Call(playerid)return Poker_ShowMenu(playerid, OPTION_CALL);

Poker_Raise(playerid)return Poker_ShowMenu(playerid, OPTION_RAISE);

Poker_Check(playerid)
{
	if(PlayerInfo[playerid][pActiveHand])
		format(PlayerInfo[playerid][pPokerStatusString], 16, "Check");

	return ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
}

Poker_Fold(playerid)
{
	if(PlayerInfo[playerid][pActiveHand] < 1) return 1;

	PlayerInfo[playerid][pFirstCard] = PlayerInfo[playerid][pSecondCard] = PlayerInfo[playerid][pActiveHand] = PlayerInfo[playerid][pPokerStatus] = 0;

	new tableid = PlayerInfo[playerid][pTableID];

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
	g_obj[co_table_active_hands]--;

	format(PlayerInfo[playerid][pPokerStatusString], 16, "Fold");

	for(new i = 0; i < 6; i++) if(g_obj[co_table_slots][i] != -1) PlayerPlaySound(g_obj[co_table_slots][i], 5602, 0.0, 0.0, 0.0);

	ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
}

Poker_InitTable(tableid)
{
	Reset_ResetTable(tableid);

	GetDynamicObjectPos(tableid, g_obj[co_table_x], g_obj[co_table_y], g_obj[co_table_z]);
	GetDynamicObjectRot(tableid, g_obj[co_table_rx], g_obj[co_table_ry], g_obj[co_table_rz]);

	g_obj[co_table_vw] = Streamer_GetIntData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_WORLD_ID);
	g_obj[co_table_int] = Streamer_GetIntData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_INTERIOR_ID);
    g_obj[co_table_placed] = 1;

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
}

Reset_ResetTable(tableid)
{
	for(new s = 0; s < 6; s++)
		g_obj[co_table_slots][s] = -1;

	g_obj[co_table_key] = EOS;
	g_obj[co_table_active] = 0;
	g_obj[co_table_guests_limit] = 6;
	g_obj[co_table_buy_in_max] = 1000;
	g_obj[co_table_buy_in_min] = 500;
	g_obj[co_table_seat_price] = 100;
	g_obj[co_table_blind] = 100;
	g_obj[co_table_pos] = 0;
	g_obj[co_table_round] = 0;
	g_obj[co_table_stage] = 0;
	g_obj[co_table_active_bet] = 0;
	g_obj[co_table_delay] = 0;
	g_obj[co_table_pot] = 0;
	g_obj[co_table_setdelay] = 15;
	g_obj[co_table_rot] = 0;
	g_obj[co_table_slots_rot] = 0;
	g_obj[co_table_winner_id] = -1;
	g_obj[co_table_winners] = 0;
	g_obj[co_table_guests] = 0;
	g_obj[co_table_active_guests] = 0;
	KillTimer(g_obj[co_table_pulse_timer]);

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj); return 1;
}

Poker_ResetTableRound(tableid)
{
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	g_obj[co_table_round] = 0;
	g_obj[co_table_stage] = 0;
	g_obj[co_table_active_bet] = 0;
	g_obj[co_table_active] = 2;
	g_obj[co_table_delay] = g_obj[co_table_setdelay];
	g_obj[co_table_pot] = 0;
	g_obj[co_table_rot] = 0;
	g_obj[co_table_slots_rot] = 0;
	g_obj[co_table_winner_id] = -1;
	g_obj[co_table_winners] = 0;
	g_obj[co_table_active_hands] = 0;

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	for(new i = 0; i < 6; i++)
	{
		new playerid = g_obj[co_table_slots][i];

		if(playerid != -1)
		{
			PlayerInfo[playerid][pTableWinner] = 0;
			PlayerInfo[playerid][pTableDealer] = 0;
			PlayerInfo[playerid][pFirstCard] = 0;
			PlayerInfo[playerid][pSecondCard] = 0;
			PlayerInfo[playerid][pActiveGuest] = 0;
			PlayerInfo[playerid][pPokerTime] = 0;
			PlayerInfo[playerid][pActiveHand] = 0;
			PlayerInfo[playerid][pCurrentBet] = 0;
			PlayerInfo[playerid][pPokerResultString] = '\0';
			PlayerInfo[playerid][pPokerHide] = 0;

			ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
		}
		else continue;
	}

	return 1;
}

Poker_CreateTD(playerid)
{
    PlayerPokerUI[playerid][0] = CreatePlayerTextDraw(playerid, 390.000000, 250.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][0], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][0], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][0], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][0], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][0], 0);

	PlayerPokerUI[playerid][1] = CreatePlayerTextDraw(playerid, 390.000000, 260.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][1], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][1], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][1], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][1], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][1], 0);

	PlayerPokerUI[playerid][2] = CreatePlayerTextDraw(playerid, 369.000000, 273.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][2], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][2], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][2], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][2], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][2], 20.000000, 33.000000);

	PlayerPokerUI[playerid][3] = CreatePlayerTextDraw(playerid, 392.000000, 273.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][3], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][3], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][3], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][3], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][3], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][3], 20.000000, 33.000000);

	PlayerPokerUI[playerid][4] = CreatePlayerTextDraw(playerid, 391.000000, 305.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][4], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][4], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][4], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][4], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][4], 0);

	PlayerPokerUI[playerid][5] = CreatePlayerTextDraw(playerid, 250.000000, 250.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][5], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][5], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][5], 0.159999, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][5], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][5], 0);

	PlayerPokerUI[playerid][6] = CreatePlayerTextDraw(playerid, 250.000000, 260.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][6], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][6], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][6], 0.159999, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][6], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][6], 0);

	PlayerPokerUI[playerid][7] = CreatePlayerTextDraw(playerid, 229.000000, 273.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][7], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][7], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][7], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][7], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][7], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][7], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][7], 20.000000, 33.000000);

	PlayerPokerUI[playerid][8] = CreatePlayerTextDraw(playerid, 252.000000, 273.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][8], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][8], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][8], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][8], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][8], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][8], 20.000000, 33.000000);

	PlayerPokerUI[playerid][9] = CreatePlayerTextDraw(playerid, 250.000000, 305.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][9], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][9], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][9], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][9], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][9], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][9], 0);

	PlayerPokerUI[playerid][10] = CreatePlayerTextDraw(playerid, 199.000000, 190.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][10], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][10], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][10], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][10], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][10], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][10], 0);

	PlayerPokerUI[playerid][11] = CreatePlayerTextDraw(playerid, 199.000000, 199.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][11], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][11], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][11], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][11], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][11], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][11], 0);

	PlayerPokerUI[playerid][12] = CreatePlayerTextDraw(playerid, 179.000000, 212.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][12], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][12], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][12], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][12], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][12], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][12], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][12], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][12], 20.000000, 33.000000);

	PlayerPokerUI[playerid][13] = CreatePlayerTextDraw(playerid, 202.000000, 212.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][13], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][13], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][13], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][13], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][13], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][13], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][13], 20.000000, 33.000000);

	PlayerPokerUI[playerid][14] = CreatePlayerTextDraw(playerid, 199.000000, 245.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][14], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][14], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][14], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][14], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][14], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][14], 0);

	PlayerPokerUI[playerid][15] = CreatePlayerTextDraw(playerid, 250.000000, 130.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][15], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][15], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][15], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][15], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][15], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][15], 0);

	PlayerPokerUI[playerid][16] = CreatePlayerTextDraw(playerid, 250.000000, 140.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][16], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][16], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][16], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][16], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][16], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][16], 0);

	PlayerPokerUI[playerid][17] = CreatePlayerTextDraw(playerid, 229.000000, 152.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][17], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][17], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][17], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][17], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][17], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][17], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][17], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][17], 20.000000, 33.000000);

	PlayerPokerUI[playerid][18] = CreatePlayerTextDraw(playerid, 252.000000, 152.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][18], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][18], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][18], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][18], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][18], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][18], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][18], 20.000000, 33.000000);

	PlayerPokerUI[playerid][19] = CreatePlayerTextDraw(playerid, 250.000000, 190.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][19], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][19], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][19], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][19], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][19], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][19], 0);

	PlayerPokerUI[playerid][20] = CreatePlayerTextDraw(playerid, 390.000000, 130.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][20], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][20], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][20], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][20], 0.159997, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][20], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][20], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][20], 0);

	PlayerPokerUI[playerid][21] = CreatePlayerTextDraw(playerid, 390.000000, 140.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][21], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][21], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][21], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][21], 0.159997, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][21], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][21], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][21], 0);

	PlayerPokerUI[playerid][22] = CreatePlayerTextDraw(playerid, 369.000000, 152.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][22], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][22], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][22], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][22], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][22], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][22], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][22], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][22], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][22], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][22], 20.000000, 33.000000);

	PlayerPokerUI[playerid][23] = CreatePlayerTextDraw(playerid, 392.000000, 152.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][23], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][23], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][23], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][23], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][23], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][23], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][23], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][23], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][23], 20.000000, 33.000000);

	PlayerPokerUI[playerid][24] = CreatePlayerTextDraw(playerid, 391.000000, 190.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][24], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][24], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][24], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][24], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][24], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][24], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][24], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][24], 0);

	PlayerPokerUI[playerid][25] = CreatePlayerTextDraw(playerid, 443.000000, 190.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][25], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][25], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][25], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][25], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][25], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][25], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][25], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][25], 0);

	PlayerPokerUI[playerid][26] = CreatePlayerTextDraw(playerid, 443.000000, 199.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][26], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][26], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][26], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][26], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][26], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][26], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][26], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][26], 0);

	PlayerPokerUI[playerid][27] = CreatePlayerTextDraw(playerid, 422.000000, 212.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][27], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][27], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][27], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][27], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][27], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][27], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][27], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][27], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][27], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][27], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][27], 20.000000, 33.000000);

	PlayerPokerUI[playerid][28] = CreatePlayerTextDraw(playerid, 445.000000, 212.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][28], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][28], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][28], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][28], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][28], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][28], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][28], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][28], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][28], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][28], 20.000000, 33.000000);

	PlayerPokerUI[playerid][29] = CreatePlayerTextDraw(playerid, 443.000000, 245.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][29], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][29], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][29], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][29], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][29], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][29], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][29], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][29], 0);

	PlayerPokerUI[playerid][31] = CreatePlayerTextDraw(playerid, 266.000000, 198.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][31], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][31], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][31], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][31], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][31], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][31], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][31], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][31], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][31], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][31], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][31], 20.000000, 33.000000);

	PlayerPokerUI[playerid][32] = CreatePlayerTextDraw(playerid, 288.000000, 198.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][32], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][32], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][32], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][32], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][32], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][32], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][32], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][32], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][32], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][32], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][32], 20.000000, 33.000000);

	PlayerPokerUI[playerid][33] = CreatePlayerTextDraw(playerid, 310.000000, 198.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][33], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][33], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][33], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][33], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][33], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][33], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][33], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][33], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][33], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][33], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][33], 20.000000, 33.000000);

	PlayerPokerUI[playerid][34] = CreatePlayerTextDraw(playerid, 332.000000, 198.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][34], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][34], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][34], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][34], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][34], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][34], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][34], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][34], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][34], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][34], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][34], 20.000000, 33.000000);

	PlayerPokerUI[playerid][35] = CreatePlayerTextDraw(playerid, 354.000000, 198.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][35], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][35], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][35], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][35], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][35], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][35], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][35], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][35], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][35], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][35], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][35], 20.000000, 33.000000);

	PlayerPokerUI[playerid][37] = CreatePlayerTextDraw(playerid, 318.000000, 180.000000, "Texas Holdem Poker");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][37], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][37], -1);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][37], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.199999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][37], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][37], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][37], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][37], 0);

	PlayerPokerUI[playerid][38] = CreatePlayerTextDraw(playerid, 321.000000, 253.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][38], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][38], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][38], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][38], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][38], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][38], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][38], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][38], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][38], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][38], 10.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][38], 1);

	PlayerPokerUI[playerid][39] = CreatePlayerTextDraw(playerid, 321.000000, 270.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][39], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][39], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][39], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][39], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][39], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][39], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][39], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][39], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][39], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][39], 10.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][39], 1);

	PlayerPokerUI[playerid][40] = CreatePlayerTextDraw(playerid, 321.000000, 286.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][40], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][40], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][40], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][40], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][40], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][40], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][40], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][40], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][40], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][40], 10.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][40], 1);

	PlayerPokerUI[playerid][41] = CreatePlayerTextDraw(playerid, 318.000000, 148.000000, "ESCI");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][41], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][41], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][41], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][41], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][41], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][41], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][41], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][41], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][41], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][41], 10.000000, 36.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][41], 1);

	PlayerPokerUI[playerid][42] = CreatePlayerTextDraw(playerid, 590.000000, 400.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][42], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][42], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][42], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][42], 0.500000, 2.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][42], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][42], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][42], 1);

	PlayerPokerUI[playerid][43] = CreatePlayerTextDraw(playerid, 589.000000, 396.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][43], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][43], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][43], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][43], 0.180000, 0.800000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][43], 200);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][43], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][43], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][43], 0);

	PlayerPokerUI[playerid][44] = CreatePlayerTextDraw(playerid, 588.000000, 437.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][44], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][44], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][44], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][44], 0.180000, 0.800000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][44], 200);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][44], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][44], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][44], 0);

	PlayerPokerUI[playerid][46] = CreatePlayerTextDraw(playerid, 318.000000, 235.000000, "In attesa di altri giocatori...");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][46], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][46], -1);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][46], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][46], 0.199999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][46], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][46], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][46], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][46], 0); return 1;
}

Poker_DestroyTD(playerid)
{
	for(new i = 0; i < MAX_PLAYER_POKER_UI; i++) if(i != 30 && i != 36 && i != 45)
		PlayerTextDrawDestroy(playerid, PlayerPokerUI[playerid][i]);

	return 1;
}

Poker_ShowTD(playerid)
{
	for(new i = 0; i < MAX_PLAYER_POKER_UI; i++) if(i != 30 && i != 36 && i != 45)
		PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][i]);

	return 1;
}

Poker_ShowOptions(playerid, option)
{
	switch(option)
	{
		case 0:
		{
			PlayerInfo[playerid][pActionOptions] = 0;
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][40]);
		}
		case 1:
		{
			PlayerInfo[playerid][pActionOptions] = 1;
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "RAISE");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "CHECK");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][40], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][40]);
		}
		case 2:
		{
			PlayerInfo[playerid][pActionOptions] = 2;
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "CALL");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "RAISE");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][40], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][40]);
		}
		case 3:
		{
			PlayerInfo[playerid][pActionOptions] = 3;

			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "CHECK");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
		}
		default: return 1;
	}

	return 1;
}

Poker_JoinTable(playerid, tableid)
{
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(g_obj[co_table_guests] >= g_obj[co_table_guests_limit])return
		SendClientMessageEx(playerid, COLOR_ERROR, "Il limite di giocatori a questo tavolo è stato raggiunto.");

	if(g_obj[co_table_active] == 1) return
		SendClientMessageEx(playerid, COLOR_ERROR, "Qualcuno sta modificando le impostazioni del tavolo, riprova più tardi.");

	if(PlayerInfo[playerid][pCash] < g_obj[co_table_seat_price])return
	    SendClientMessageEx(playerid, COLOR_ERROR, "Non hai abbastanza soldi per entrare nel tavolo. ($%d)", g_obj[co_table_seat_price]);

	for(new s; s < 6; s++)  if(g_obj[co_table_slots][s] == -1)
	{
		GivePlayerMoney(playerid, -g_obj[co_table_seat_price]);
		SendClientMessage(playerid,-1, "/poker entra");

	    Poker_CreateTD(playerid);
		Poker_ShowTD(playerid);
		Poker_ShowOptions(playerid, 0);

		PlayerInfo[playerid][pTableID] = tableid;
		PlayerInfo[playerid][pTableSlot] = s;

		g_obj[co_table_guests]++;
		g_obj[co_table_slots][s] = playerid;

		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

		if(g_obj[co_table_guests] == 1)
		{
			g_obj[co_table_active] = 1;
			Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

			Poker_ShowMenu(playerid, OPTION_SETUP_GAME);
		}
		else Poker_ShowMenu(playerid, OPTION_BUY_IN);

		CameraRadiusSetPos(playerid, g_obj[co_table_x], g_obj[co_table_y], g_obj[co_table_z], 90.0, 4.7, 0.1);
		GetPlayerPos(playerid, PlayerInfo[playerid][pTableX], PlayerInfo[playerid][pTableY], PlayerInfo[playerid][pTableZ]);
        SetPlayerInterior(playerid, g_obj[co_table_int]);
		SetPlayerVirtualWorld(playerid, g_obj[co_table_vw]);

		ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
		TogglePlayerControllable(playerid, 0);
		SetPlayerPosObjectOffset(tableid, playerid, PokerTableMiscObjOffsets[s][0], PokerTableMiscObjOffsets[s][1], PokerTableMiscObjOffsets[s][2]);
		SetPlayerFacingAngle(playerid, PokerTableMiscObjOffsets[s][5] + 90.0);
	}
	return 1;
}
Poker_LeaveTable(playerid)
{
	new tableid = PlayerInfo[playerid][pTableID];
	if(!tableid)return 1;

	PlayerPlaySound(playerid, 5852, 0.0, 0.0, 0.0);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pChips]);
	SendClientMessage(playerid,-1, "/poker esci");

	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	g_obj[co_table_guests]--;
	if(PlayerInfo[playerid][pPokerStatus]) g_obj[co_table_active_guests]--;

	new pk_slot = PlayerInfo[playerid][pTableSlot]; g_obj[co_table_slots][pk_slot] = -1;

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(!g_obj[co_table_round] && g_obj[co_table_delay] < 5)
		Poker_ResetTableRound(tableid);

	SetPlayerInterior(playerid, g_obj[co_table_int]);
	SetPlayerVirtualWorld(playerid, g_obj[co_table_vw]);
	SetPlayerPos(playerid, PlayerInfo[playerid][pTableX], PlayerInfo[playerid][pTableY], PlayerInfo[playerid][pTableZ]+0.1);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	Dialog_Close(playerid);

	if(PlayerInfo[playerid][pActiveHand])
		g_obj[co_table_active_hands]--;

	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, tableid, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);

	if(PlayerInfo[playerid][pActiveGuest])
		Poker_RotateGuests(tableid);

	PlayerInfo[playerid][pTableID] = 0;
	PlayerInfo[playerid][pTableSlot] = 0;
	PlayerInfo[playerid][pTableWinner] = 0;
	PlayerInfo[playerid][pCurrentBet] = 0;
	PlayerInfo[playerid][pChips] = 0;
	PlayerInfo[playerid][pTableX] = 0;
	PlayerInfo[playerid][pTableY] = 0;
	PlayerInfo[playerid][pTableZ] = 0;
	PlayerInfo[playerid][pPokerStatus] = 0;
	PlayerInfo[playerid][pTableDealer] = 0;
	PlayerInfo[playerid][pFirstCard] = 0;
	PlayerInfo[playerid][pSecondCard] = 0;
	PlayerInfo[playerid][pActiveGuest] = 0;
	PlayerInfo[playerid][pActiveHand] = 0;
	PlayerInfo[playerid][pPokerHide] = 0;

	Poker_DestroyTD(playerid);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	CancelSelectTextDraw(playerid);

	if(!g_obj[co_table_guests])
		Reset_ResetTable(tableid);

	return 1;
}
//Positions System
SetPlayerPosObjectOffset(objectid, playerid, Float:offset_x, Float:offset_y, Float:offset_z)
{
	new Float:object_px,Float:object_py,Float:object_pz,Float:object_rx,Float:object_ry,Float:object_rz;
    GetDynamicObjectPos(objectid, object_px, object_py, object_pz);
    GetDynamicObjectRot(objectid, object_rx, object_ry, object_rz);
    new Float:cos_x = floatcos(object_rx, degrees),Float:cos_y = floatcos(object_ry, degrees),Float:cos_z = floatcos(object_rz, degrees),
        Float:sin_x = floatsin(object_rx, degrees),Float:sin_y = floatsin(object_ry, degrees),Float:sin_z = floatsin(object_rz, degrees);
	new Float:x, Float:y, Float:z;
    x = object_px + offset_x * cos_y * cos_z - offset_x * sin_x * sin_y * sin_z - offset_y * cos_x * sin_z + offset_z * sin_y * cos_z + offset_z * sin_x * cos_y * sin_z;
    y = object_py + offset_x * cos_y * sin_z + offset_x * sin_x * sin_y * cos_z + offset_y * cos_x * cos_z + offset_z * sin_y * sin_z - offset_z * sin_x * cos_y * cos_z;
    z = object_pz - offset_x * cos_x * sin_y + offset_y * sin_x + offset_z * cos_x * cos_y;
	SetPlayerPos(playerid, x, y, z); return 1;
}
CameraRadiusSetPos(playerid, Float:x, Float:y, Float:z, Float:degree = 0.0, Float:height = 3.0, Float:radius = 8.0)
{
	new Float:deltaToX = x + radius * floatsin(-degree, degrees),Float:deltaToY = y + radius * floatcos(-degree, degrees),Float:deltaToZ = z + height;
	SetPlayerCameraPos(playerid, deltaToX, deltaToY, deltaToZ);
	SetPlayerCameraLookAt(playerid, x, y, z); return 1;
}
ReturnRoleplayName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	for(new j; j < strlen(name); j++) if(name[j] == '_') name[j] = ' ';
	return name;
}
SendClientMessageEx(playerid, color, const text[])
{
    #define LENGHT (110)
    if(strlen(text) > LENGHT)
    {
        new firstString[LENGHT], secondString[LENGHT];
        strmid(firstString, text, 0, LENGHT);
        strmid(secondString, text, LENGHT - 1, LENGHT * 2);
        format(firstString, LENGHT, "%s...", firstString);
        format(secondString, LENGHT, "...%s", secondString);
        SendClientMessage(playerid, color, firstString);
        SendClientMessage(playerid, color, secondString);
   }
    else SendClientMessage(playerid, color, text);
    #undef LENGHT
    return 1;
}
ArraySort(array[], size)
{
    new i, j, app;
    for(i = 1; i < size; i++)
    {
        app = array[i];
        for(j = i - 1; (j >= 0) && (array[j] > app); j--)
        {
            array[j + 1 ] = array[j];
		}
        array[j + 1] = app;
   }
    return 1;
}
script LoadFurnitures()
{
	static rows, fields;
	cache_get_data(rows, fields, dbHandle);
	if(!rows)return 1;
	new model_id,Float:x1,Float:y1,Float:z1,Float:rx1,Float:ry1,Float:rz1,sz_object,property_world,property_interior;
	for(new j; j < rows; j++)
	{
	    model_id = cache_get_field_content_int(j, "model");
		x1 = cache_get_field_content_float(j, "pos_x");
		y1 = cache_get_field_content_float(j, "pos_y");
		z1 = cache_get_field_content_float(j, "pos_z");
		rx1 = cache_get_field_content_float(j, "rot_x");
		ry1 = cache_get_field_content_float(j, "rot_y");
		rz1 = cache_get_field_content_float(j, "rot_z");
		property_world = cache_get_field_content_int(j, "world");
		property_interior = cache_get_field_content_int(j, "interior");
		sz_object = CreateDynamicObject(model_id, x1, y1, z1, rx1, ry1, rz1, property_world, property_interior);
		cache_get_field_content(j, "name", g_obj[co_name], dbHandle, 100);
		g_obj[co_database_id] = cache_get_field_content_int(j, "id");
		g_obj[co_price] =  cache_get_field_content_int(j, "price");
  		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, sz_object, E_STREAMER_EXTRA_ID, g_obj, siz_g_obj);
        if(model_id == POKER_OBJECT) Poker_InitTable(sz_object);
	}
	return 1;
}
