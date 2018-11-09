#if defined _gCasino_included
	#endinput
#endif
#define _gCasino_included

#define _gCasino_PRESSED(%0)					(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))


/*
	Grimrandomer's Casino Script
	Version: 1.0.0.2
	
	www.Grimrandomer.com
	www.LV-CNR.com

*/

#define _gCasino_KEY					KEY_SECONDARY_ATTACK //Key they press to use casino machine <Enter> / <F> by default.

#define MAX_CASINO_MACHINES				100	//MAX Number of casino machine's, adjust this based on estimated amount used for better memory use.
#define INVALID_CASINO_MACHINE_ID		-1

#define CASINO_MACHINE_POKER			0
//#define CASINO_MACHINE_SLOTS			1
//#define CASINO_MACHINE_WHEELOFORTUNE	2

#define CASINO_MACHINE_POKER_MODEL		2785

#define CASINO_MONEY_CHARGE				0
#define CASINO_MONEY_WIN				1
#define CASINO_MONEY_NOTENOUGH			2

#define GC_FREEZESTATE_UNFROZEN			0
#define GC_FREEZESTATE_FROZEN			1


enum casino_machine {
	cm_active,
	cm_type,
	Float:cm_loc[3],
	Float:cm_rot[3],
	cm_isDynamic,
	cm_objs[4]
}

new _machines[MAX_CASINO_MACHINES][casino_machine];

stock _gCasino_SetPlayerFreezeState(playerid,freezeState) {
	if (freezeState==GC_FREEZESTATE_FROZEN) {
		TogglePlayerControllable(playerid, 0);
	} else {
		TogglePlayerControllable(playerid, 1);
	}
}

stock IsValidCasinoMachineType(_type) {
	if (_type==CASINO_MACHINE_POKER)
		return 1;
		
	return 0;
}

stock freeCasinoMachineID() {
	for (new _mid=0; _mid<MAX_CASINO_MACHINES; _mid++) {
		if (_machines[_mid][cm_active] == 0) {
			return _mid;
		}
	}
	return INVALID_CASINO_MACHINE_ID;
}

stock IsValidCasinoMachineID(_machineID) {
	if (_machineID>=0 && _machineID<MAX_CASINO_MACHINES) {
		if (_machines[_machineID][cm_active]==1) {
			return true;
		}
	}
	return false;
}

stock GetMachineType(_machineID, &_type) {
	if (!IsValidCasinoMachineID(_machineID))
		return false;
	
	_type = _machines[_machineID][cm_type];
	return true;
}

stock CreateCasinoMachine(_type, Float:_lX, Float:_lY, Float:_lZ, Float:_rX, Float:_rY, Float:_rZ, useDynamicObj=0) {
	if (!IsValidCasinoMachineType(_type))
		return 0;

	new _machineID = freeCasinoMachineID();
	if (_machineID == INVALID_CASINO_MACHINE_ID)
		return 0;

	_machines[_machineID][cm_active] = 1;
	_machines[_machineID][cm_type] = _type;
	_machines[_machineID][cm_loc][0] = _lX;
	_machines[_machineID][cm_loc][1] = _lY;
	_machines[_machineID][cm_loc][2] = _lZ;
	_machines[_machineID][cm_rot][0] = _rX;
	_machines[_machineID][cm_rot][1] = _rY;
	_machines[_machineID][cm_rot][2] = _rZ;
	_machines[_machineID][cm_isDynamic] = useDynamicObj;
	
	/* CREATE OBJECTS */
	switch (_type) {
		case CASINO_MACHINE_POKER: {
			if (useDynamicObj==0) {
				_machines[_machineID][cm_objs][0] = CreateObject(CASINO_MACHINE_POKER_MODEL, _lX, _lY, _lZ, _rX, _rY, _rZ);
			} else {
				#if defined CreateDynamicObject
				_machines[_machineID][cm_objs][0] = CreateDynamicObject(CASINO_MACHINE_POKER_MODEL, _lX, _lY, _lZ, _rX, _rY, _rZ);
				#else
				_machines[_machineID][cm_objs][0] = CreateObject(CASINO_MACHINE_POKER_MODEL, _lX, _lY, _lZ, _rX, _rY, _rZ);
				#endif
			}
		}
	}

	return _machineID;
}

stock RemoveCasinoMachine(_machineID) {
	if (_machineID == INVALID_CASINO_MACHINE_ID)
		return 0;

	if ((_machineID < 0) || (_machineID>=MAX_CASINO_MACHINES))
		return 0;
		
	if (_machines[_machineID][cm_active] == 0)
		return 0;
	
	_machines[_machineID][cm_active] = 0;
	
	RemoveAllFromMachine(_machineID);

	/* REMOVE OBJECTS */
	switch (_type) {
		case CASINO_MACHINE_POKER: {
			if (useDynamicObj==0) {
				DestroyObject(_machines[_machineID][cm_objs][0]);
			} else {
				#if defined DestroyDynamicObject
				DestroyDynamicObject(_machines[_machineID][cm_objs][0]);
				#else
				DestroyObject(_machines[_machineID][cm_objs][0]);
				#endif
			}
		}
	}
}

stock IsPlayerAtAnyCasinoMachine(playerid) {
	if (SetPVarInt(playerid, "ss_casino_use") == 1)
		return 1;
		
	return 0;
}

stock IsPlayerAtCasinoMachine(playerid, _machineID) {
	if (GetPVarInt(playerid, "ss_casino_use") == 1) {
		if (GetPVarInt(playerid, "ss_casino_using") == _machineID) {
			return 1;
		}
	}
	return 0;
}

stock RemoveAllFromAllMachines() {
	for (playerid=0; playerid<MAX_PLAYERS; playerid++) {
		if (IsPlayerAtAnyCasinoMachine(playerid)) {
			closePlayerCasinoInterface(playerid);
		}
	}
}

stock RemoveAllFromMachine(_machineID) {
	for (playerid=0; playerid<MAX_PLAYERS; playerid++) {
		if (IsPlayerAtCasinoMachine(playerid, _machineID)) {
			closePlayerCasinoInterface(playerid);
		}
	}
}

stock RemoveFromMachine(playerid, _machineID) {
	if (IsPlayerAtCasinoMachine(playerid, _machineID)) {
		closePlayerCasinoInterface(playerid);
	}
	return 0;
}

stock ClosestCasinoMachine(playerid) {
	for (new _mid=0; _mid<MAX_CASINO_MACHINES; _mid++) {
		if (_machines[_mid][cm_active] == 1) {
			if(IsPlayerInRangeOfPoint(playerid,2.5,_machines[_mid][cm_loc][0],_machines[_mid][cm_loc][1],_machines[_mid][cm_loc][2])) {
				return _mid;
			}
		}
	}
	return INVALID_CASINO_MACHINE_ID;
}

stock closePlayerCasinoInterface(playerid) {
	if (GetPVarInt(playerid, "ss_casino_use") == 0)
		return 0;
		
	new _machineID = GetPVarInt(playerid, "ss_casino_using");
	SetPVarInt(playerid, "ss_casino_use", 0);
	SetPVarInt(playerid, "ss_casino_using", -1);

	// CLOSE
	switch (_machines[_machineID][cm_type]) {
		case CASINO_MACHINE_POKER: {
			cPoker_closeInterface(playerid);
		}
	}
	
	CallLocalFunction("OnCasinoEnd", "ii", playerid, _machineID);
	
	return 1;
}

stock openPlayerCasinoInterface(playerid, _machineID) {
	new moneyentrepriseid;
	if(argent_entreprise[moneyentrepriseid][argentmafiazone1] < 0) return SendErrorMessage(playerid,"Casino a sec!");
	if (GetPVarInt(playerid, "ss_casino_use") == 1)
		return 0;
	
	SetPVarInt(playerid, "ss_casino_use", 1);
	SetPVarInt(playerid, "ss_casino_using", _machineID);

	// OPEN
	switch (_machines[_machineID][cm_type]) {
		case CASINO_MACHINE_POKER: {
			cPoker_openInterface(playerid);
		}
	}
	
	CallLocalFunction("OnCasinoStart", "ii", playerid, _machineID);
	
	return 1;
}

/* POKER CODE */

#define CARD_TYPE_NONE					0
#define CARD_TYPE_CLUB					1
#define CARD_TYPE_DIAMOND				2
#define CARD_TYPE_HEART					3
#define CARD_TYPE_SPADE					4

#define CARD_JACK						11
#define CARD_QUEEN						12
#define CARD_KING						13
#define CARD_ACE						1

#define HOLD_BUTTON_DISABLED			0
#define HOLD_BUTTON_NORMAL				1
#define HOLD_BUTTON_SELECTED			2

#define CASINO_POKER_BTN_DEAL			0
#define CASINO_POKER_BTN_ADDCOIN		1
#define CASINO_POKER_BTN_HOLD			2

#define CPOKER_CHECKMODE_CARD			0
#define CPOKER_CHECKMODE_CARDSUIT		1

#define c_suitsEqual(%1,%2,%3,%4,%5)	(%1==1 && c_Equal(%1,%2,%3,%4,%5))
#define c_anySuits(%1,%2,%3,%4,%5)		(%1>CARD_TYPE_NONE && %2>CARD_TYPE_NONE && %3>CARD_TYPE_NONE && %4>CARD_TYPE_NONE &&%5>CARD_TYPE_NONE)
#define c_Equal(%1,%2,%3,%4,%5)			(%1==%2 && %2==%3 && %3==%4 && %4==%5)

#define CHECK_NONE						0
#define CHECK_ROYALFLUSH				1
#define CHECK_STRAIGHTFLUSH				2
#define CHECK_FOUROFAKIND				3
#define CHECK_FULLHOUSE					4
#define CHECK_FLUSH						5
#define CHECK_STRAIGHT					6
#define CHECK_THREEOFAKIND				7
#define CHECK_TWOPAIRS					8
#define CHECK_JACKORBETTER				9

new Text:poker_background[2];
new Text:poker_coinSelectionBG[6];
new Text:poker_coinSelectionText[6];
new Text:poker_coinHeadingText[6];
new Text:poker_deal;
new Text:poker_addCoin;
new Text:poker_coinValue;

new PlayerText:poker_card[MAX_PLAYERS][5];
new PlayerText:poker_hold[MAX_PLAYERS][5];
new PlayerText:poker_wager[MAX_PLAYERS];

new Float:cardPosX[5] = {76.0, 176.0, 274.0, 373.0, 471.0};
new Float:holdPosX[5] = {122.0, 222.0, 321.0, 419.0, 517.0};

new cPoker_winningCoinsValue[9][5] = {
	{250,500,750,1000,4000}, //ROYALFLUSH
	{50,100,150,200,250}, //STRAIGHTFLUSH
	{25,50,75,100,125}, //FOUROFAKIND
	{9,18,27,36,45}, //FULLHOUSE
	{6,12,18,24,30}, //FLUSH
	{4,8,12,16,20}, //STRAIGHT
	{3,6,9,12,15}, //THREEOFAKIND
	{2,4,6,8,10}, //TWOPAIRS
	{1,2,3,4,5} //JACKORBETTER
};

new cPoker_winningType[10][20] = {
	"Rien",
	"Suite royale",
	"Suite continue",
	"4 Pareil",
	"Main pleine",
	"Flush",
	"Suite de couleur",
	"3 pareils",
	"Deux paires",
	"Une paire"
};

new cPokerGame[MAX_PLAYERS][5][3];

cPoker_genTDs() {
	poker_background[0] = TextDrawCreate(0.000000, 0.000000, "_");
	TextDrawBackgroundColor	(poker_background[0], 255);
	TextDrawFont			(poker_background[0], 1);
	TextDrawLetterSize		(poker_background[0], 0.500000, 50.000000);
	TextDrawColor			(poker_background[0], -1);
	TextDrawSetOutline		(poker_background[0], 0);
	TextDrawSetProportional	(poker_background[0], 1);
	TextDrawSetShadow		(poker_background[0], 1);
	TextDrawUseBox			(poker_background[0], 1);
	TextDrawBoxColor		(poker_background[0], 9764863);
	TextDrawTextSize		(poker_background[0], 640.000000, 0.000000);
	TextDrawSetSelectable	(poker_background[0], 0);

	poker_background[1] = TextDrawCreate(76.000000, 57.000000, "_");
	TextDrawBackgroundColor	(poker_background[1], 255);
	TextDrawFont			(poker_background[1], 1);
	TextDrawLetterSize		(poker_background[1], 0.500000, 18.000000);
	TextDrawColor			(poker_background[1], -1);
	TextDrawSetOutline		(poker_background[1], 0);
	TextDrawSetProportional	(poker_background[1], 1);
	TextDrawSetShadow		(poker_background[1], 1);
	TextDrawUseBox			(poker_background[1], 1);
	TextDrawBoxColor		(poker_background[1], -65281);
	TextDrawTextSize		(poker_background[1], 459.000000, 0.000000);
	TextDrawSetSelectable	(poker_background[1], 0);

	poker_coinSelectionBG[0] = TextDrawCreate(77.000000, 58.000000, "_");
	TextDrawBackgroundColor	(poker_coinSelectionBG[0], 255);
	TextDrawFont			(poker_coinSelectionBG[0], 1);
	TextDrawLetterSize		(poker_coinSelectionBG[0], 0.500000, 17.800003);
	TextDrawColor			(poker_coinSelectionBG[0], -1);
	TextDrawSetOutline		(poker_coinSelectionBG[0], 0);
	TextDrawSetProportional	(poker_coinSelectionBG[0], 1);
	TextDrawSetShadow		(poker_coinSelectionBG[0], 1);
	TextDrawUseBox			(poker_coinSelectionBG[0], 1);
	TextDrawBoxColor		(poker_coinSelectionBG[0], 255);
	TextDrawTextSize		(poker_coinSelectionBG[0], 197.000000, 0.000000);
	TextDrawSetSelectable	(poker_coinSelectionBG[0], 0);

	poker_coinSelectionBG[1] = TextDrawCreate(201.000000, 58.000000, "_");
	TextDrawBackgroundColor	(poker_coinSelectionBG[1], 255);
	TextDrawFont			(poker_coinSelectionBG[1], 1);
	TextDrawLetterSize		(poker_coinSelectionBG[1], 0.500000, 17.800003);
	TextDrawColor			(poker_coinSelectionBG[1], -1);
	TextDrawSetOutline		(poker_coinSelectionBG[1], 0);
	TextDrawSetProportional	(poker_coinSelectionBG[1], 1);
	TextDrawSetShadow		(poker_coinSelectionBG[1], 1);
	TextDrawUseBox			(poker_coinSelectionBG[1], 1);
	TextDrawBoxColor		(poker_coinSelectionBG[1], 255);
	TextDrawTextSize		(poker_coinSelectionBG[1], 245.000000, 0.000000);
	TextDrawSetSelectable	(poker_coinSelectionBG[1], 0);

	poker_coinSelectionBG[2] = TextDrawCreate(249.000000, 58.000000, "_");
	TextDrawBackgroundColor	(poker_coinSelectionBG[2], 255);
	TextDrawFont			(poker_coinSelectionBG[2], 1);
	TextDrawLetterSize		(poker_coinSelectionBG[2], 0.500000, 17.800003);
	TextDrawColor			(poker_coinSelectionBG[2], -1);
	TextDrawSetOutline		(poker_coinSelectionBG[2], 0);
	TextDrawSetProportional	(poker_coinSelectionBG[2], 1);
	TextDrawSetShadow		(poker_coinSelectionBG[2], 1);
	TextDrawUseBox			(poker_coinSelectionBG[2], 1);
	TextDrawBoxColor		(poker_coinSelectionBG[2], 255);
	TextDrawTextSize		(poker_coinSelectionBG[2], 291.000000, 0.000000);
	TextDrawSetSelectable	(poker_coinSelectionBG[2], 0);

	poker_coinSelectionBG[3] = TextDrawCreate(295.000000, 58.000000, "_");
	TextDrawBackgroundColor	(poker_coinSelectionBG[3], 255);
	TextDrawFont			(poker_coinSelectionBG[3], 1);
	TextDrawLetterSize		(poker_coinSelectionBG[3], 0.500000, 17.800003);
	TextDrawColor			(poker_coinSelectionBG[3], -1);
	TextDrawSetOutline		(poker_coinSelectionBG[3], 0);
	TextDrawSetProportional	(poker_coinSelectionBG[3], 1);
	TextDrawSetShadow		(poker_coinSelectionBG[3], 1);
	TextDrawUseBox			(poker_coinSelectionBG[3], 1);
	TextDrawBoxColor		(poker_coinSelectionBG[3], 255);
	TextDrawTextSize		(poker_coinSelectionBG[3], 337.000000, 0.000000);
	TextDrawSetSelectable	(poker_coinSelectionBG[3], 0);

	poker_coinSelectionBG[4] = TextDrawCreate(341.000000, 58.000000, "_");
	TextDrawBackgroundColor	(poker_coinSelectionBG[4], 255);
	TextDrawFont			(poker_coinSelectionBG[4], 1);
	TextDrawLetterSize		(poker_coinSelectionBG[4], 0.500000, 17.800003);
	TextDrawColor			(poker_coinSelectionBG[4], -1);
	TextDrawSetOutline		(poker_coinSelectionBG[4], 0);
	TextDrawSetProportional	(poker_coinSelectionBG[4], 1);
	TextDrawSetShadow		(poker_coinSelectionBG[4], 1);
	TextDrawUseBox			(poker_coinSelectionBG[4], 1);
	TextDrawBoxColor		(poker_coinSelectionBG[4], 255);
	TextDrawTextSize		(poker_coinSelectionBG[4], 393.000000, 0.000000);
	TextDrawSetSelectable	(poker_coinSelectionBG[4], 0);

	poker_coinSelectionBG[5] = TextDrawCreate(397.000000, 58.000000, "_");
	TextDrawBackgroundColor	(poker_coinSelectionBG[5], 255);
	TextDrawFont			(poker_coinSelectionBG[5], 1);
	TextDrawLetterSize		(poker_coinSelectionBG[5], 0.500000, 17.800003);
	TextDrawColor			(poker_coinSelectionBG[5], -1);
	TextDrawSetOutline		(poker_coinSelectionBG[5], 0);
	TextDrawSetProportional	(poker_coinSelectionBG[5], 1);
	TextDrawSetShadow		(poker_coinSelectionBG[5], 1);
	TextDrawUseBox			(poker_coinSelectionBG[5], 1);
	TextDrawBoxColor		(poker_coinSelectionBG[5], 255);
	TextDrawTextSize		(poker_coinSelectionBG[5], 458.000000, 0.000000);
	TextDrawSetSelectable	(poker_coinSelectionBG[5], 0);

	poker_coinSelectionText[0] = TextDrawCreate(78.000000, 56.000000, "ROYAL FLUSH~n~STRAIGHT FLUSH~n~FOUR OF A KIND~n~FULL HOUSE~n~FLUSH~n~STRAIGHT~n~THREE OF A KIND~n~TWO PAIRS~n~ONE PAIR");
	TextDrawBackgroundColor	(poker_coinSelectionText[0], 255);
	TextDrawFont			(poker_coinSelectionText[0], 1);
	TextDrawLetterSize		(poker_coinSelectionText[0], 0.399998, 2.000000);
	TextDrawColor			(poker_coinSelectionText[0], -65281);
	TextDrawSetOutline		(poker_coinSelectionText[0], 1);
	TextDrawSetProportional	(poker_coinSelectionText[0], 1);
	TextDrawSetSelectable	(poker_coinSelectionText[0], 0);

	poker_coinSelectionText[1] = TextDrawCreate(237.000000, 56.000000, "$25k~n~$5k~n~$2.5K~n~$900~n~$600~n~$400~n~$300~n~$200~n~$100~n~");//"250~n~50~n~25~n~9~n~6~n~4~n~3~n~2~n~1~n~");
	TextDrawAlignment		(poker_coinSelectionText[1], 3);
	TextDrawBackgroundColor	(poker_coinSelectionText[1], 255);
	TextDrawFont			(poker_coinSelectionText[1], 1);
	TextDrawLetterSize		(poker_coinSelectionText[1], 0.399998, 2.000000);
	TextDrawColor			(poker_coinSelectionText[1], -65281);
	TextDrawSetOutline		(poker_coinSelectionText[1], 1);
	TextDrawSetProportional	(poker_coinSelectionText[1], 1);
	TextDrawSetSelectable	(poker_coinSelectionText[1], 0);

	poker_coinSelectionText[2] = TextDrawCreate(283.000000, 56.000000, "$50k~n~$10k~n~$5k~n~$1.8k~n~$1.2k~n~$800~n~$600~n~$400~n~$200~n~");//"500~n~100~n~50~n~18~n~12~n~8~n~6~n~4~n~2~n~");
	TextDrawAlignment		(poker_coinSelectionText[2], 3);
	TextDrawBackgroundColor	(poker_coinSelectionText[2], 255);
	TextDrawFont			(poker_coinSelectionText[2], 1);
	TextDrawLetterSize		(poker_coinSelectionText[2], 0.399998, 2.000000);
	TextDrawColor			(poker_coinSelectionText[2], -65281);
	TextDrawSetOutline		(poker_coinSelectionText[2], 1);
	TextDrawSetProportional	(poker_coinSelectionText[2], 1);
	TextDrawSetSelectable	(poker_coinSelectionText[2], 0);

	poker_coinSelectionText[3] = TextDrawCreate(329.000000, 56.000000, "$75k~n~$15k~n~$7.5k~n~$2.7k~n~$1.8k~n~$1.2k~n~$900~n~$600~n~$300~n~"); //"750~n~150~n~75~n~27~n~18~n~12~n~9~n~6~n~3~n~");
	TextDrawAlignment		(poker_coinSelectionText[3], 3);
	TextDrawBackgroundColor	(poker_coinSelectionText[3], 255);
	TextDrawFont			(poker_coinSelectionText[3], 1);
	TextDrawLetterSize		(poker_coinSelectionText[3], 0.399998, 2.000000);
	TextDrawColor			(poker_coinSelectionText[3], -65281);
	TextDrawSetOutline		(poker_coinSelectionText[3], 1);
	TextDrawSetProportional	(poker_coinSelectionText[3], 1);
	TextDrawSetSelectable	(poker_coinSelectionText[3], 0);

	poker_coinSelectionText[4] = TextDrawCreate(385.000000, 56.000000, "$100k~n~$20k~n~$10k~n~$3.6k~n~$2.4k~n~$1.6k~n~$1.2k~n~$800~n~$400~n~"); //"1000~n~200~n~100~n~36~n~24~n~16~n~12~n~8~n~4~n~");
	TextDrawAlignment		(poker_coinSelectionText[4], 3);
	TextDrawBackgroundColor	(poker_coinSelectionText[4], 255);
	TextDrawFont			(poker_coinSelectionText[4], 1);
	TextDrawLetterSize		(poker_coinSelectionText[4], 0.399998, 2.000000);
	TextDrawColor			(poker_coinSelectionText[4], -65281);
	TextDrawSetOutline		(poker_coinSelectionText[4], 1);
	TextDrawSetProportional	(poker_coinSelectionText[4], 1);
	TextDrawSetSelectable	(poker_coinSelectionText[4], 0);

	poker_coinSelectionText[5] = TextDrawCreate(450.000000, 56.000000, "$400k~n~$25k~n~$12.5k~n~$4.5k~n~$3k~n~$2k~n~$1.5k~n~$1k~n~$500~n~"); //4000~n~250~n~125~n~45~n~30~n~20~n~15~n~10~n~5~n~");
	TextDrawAlignment		(poker_coinSelectionText[5], 3);
	TextDrawBackgroundColor	(poker_coinSelectionText[5], 255);
	TextDrawFont			(poker_coinSelectionText[5], 1);
	TextDrawLetterSize		(poker_coinSelectionText[5], 0.399998, 2.000000);
	TextDrawColor			(poker_coinSelectionText[5], -65281);
	TextDrawSetOutline		(poker_coinSelectionText[5], 1);
	TextDrawSetProportional	(poker_coinSelectionText[5], 1);
	TextDrawSetSelectable	(poker_coinSelectionText[5], 0);

	poker_coinHeadingText[0] = TextDrawCreate(78.000000, 36.000000, "MISE");
	TextDrawBackgroundColor	(poker_coinHeadingText[0], 255);
	TextDrawFont			(poker_coinHeadingText[0], 1);
	TextDrawLetterSize		(poker_coinHeadingText[0], 0.399998, 2.000000);
	TextDrawColor			(poker_coinHeadingText[0], -1);
	TextDrawSetOutline		(poker_coinHeadingText[0], 1);
	TextDrawSetProportional	(poker_coinHeadingText[0], 1);
	TextDrawSetSelectable	(poker_coinHeadingText[0], 0);

	poker_coinHeadingText[1] = TextDrawCreate(237.000000, 36.000000, "$100~n~");
	TextDrawAlignment		(poker_coinHeadingText[1], 3);
	TextDrawBackgroundColor	(poker_coinHeadingText[1], 255);
	TextDrawFont			(poker_coinHeadingText[1], 1);
	TextDrawLetterSize		(poker_coinHeadingText[1], 0.399998, 2.000000);
	TextDrawColor			(poker_coinHeadingText[1], -1);
	TextDrawSetOutline		(poker_coinHeadingText[1], 1);
	TextDrawSetProportional	(poker_coinHeadingText[1], 1);
	TextDrawSetSelectable	(poker_coinHeadingText[1], 0);

	poker_coinHeadingText[2] = TextDrawCreate(283.000000, 36.000000, "$200~n~");
	TextDrawAlignment		(poker_coinHeadingText[2], 3);
	TextDrawBackgroundColor	(poker_coinHeadingText[2], 255);
	TextDrawFont			(poker_coinHeadingText[2], 1);
	TextDrawLetterSize		(poker_coinHeadingText[2], 0.399998, 2.000000);
	TextDrawColor			(poker_coinHeadingText[2], -1);
	TextDrawSetOutline		(poker_coinHeadingText[2], 1);
	TextDrawSetProportional	(poker_coinHeadingText[2], 1);
	TextDrawSetSelectable	(poker_coinHeadingText[2], 0);

	poker_coinHeadingText[3] = TextDrawCreate(329.000000, 36.000000, "$300~n~");
	TextDrawAlignment		(poker_coinHeadingText[3], 3);
	TextDrawBackgroundColor	(poker_coinHeadingText[3], 255);
	TextDrawFont			(poker_coinHeadingText[3], 1);
	TextDrawLetterSize		(poker_coinHeadingText[3], 0.399998, 2.000000);
	TextDrawColor			(poker_coinHeadingText[3], -1);
	TextDrawSetOutline		(poker_coinHeadingText[3], 1);
	TextDrawSetProportional	(poker_coinHeadingText[3], 1);
	TextDrawSetSelectable	(poker_coinHeadingText[3], 0);

	poker_coinHeadingText[4] = TextDrawCreate(385.000000, 36.000000, "$400~n~");
	TextDrawAlignment		(poker_coinHeadingText[4], 3);
	TextDrawBackgroundColor	(poker_coinHeadingText[4], 255);
	TextDrawFont			(poker_coinHeadingText[4], 1);
	TextDrawLetterSize		(poker_coinHeadingText[4], 0.399998, 2.000000);
	TextDrawColor			(poker_coinHeadingText[4], -1);
	TextDrawSetOutline		(poker_coinHeadingText[4], 1);
	TextDrawSetProportional	(poker_coinHeadingText[4], 1);
	TextDrawSetSelectable	(poker_coinHeadingText[4], 0);

	poker_coinHeadingText[5] = TextDrawCreate(450.000000, 36.000000, "$500~n~");
	TextDrawAlignment		(poker_coinHeadingText[5], 3);
	TextDrawBackgroundColor	(poker_coinHeadingText[5], 255);
	TextDrawFont			(poker_coinHeadingText[5], 1);
	TextDrawLetterSize		(poker_coinHeadingText[5], 0.399998, 2.000000);
	TextDrawColor			(poker_coinHeadingText[5], -1);
	TextDrawSetOutline		(poker_coinHeadingText[5], 1);
	TextDrawSetProportional	(poker_coinHeadingText[5], 1);
	TextDrawSetSelectable	(poker_coinHeadingText[5], 0);

	poker_addCoin = TextDrawCreate(122.000000, 416.000000, "MISER");
	TextDrawAlignment		(poker_addCoin, 2);
	TextDrawBackgroundColor	(poker_addCoin, 255);
	TextDrawFont			(poker_addCoin, 2);
	TextDrawLetterSize		(poker_addCoin, 0.299997, 2.000000);
	TextDrawColor			(poker_addCoin, -1);
	TextDrawSetOutline		(poker_addCoin, 1);
	TextDrawSetProportional	(poker_addCoin, 1);
	TextDrawUseBox			(poker_addCoin, 1);
	TextDrawBoxColor		(poker_addCoin, -286331649);
	TextDrawTextSize		(poker_addCoin, 15.000000, 90.000000);
	TextDrawSetSelectable	(poker_addCoin, 1);

	poker_deal = TextDrawCreate(222.000000, 416.000000, "JOUER");
	TextDrawAlignment		(poker_deal, 2);
	TextDrawBackgroundColor	(poker_deal, 255);
	TextDrawFont			(poker_deal, 2);
	TextDrawLetterSize		(poker_deal, 0.299997, 2.000000);
	TextDrawColor			(poker_deal, -1);
	TextDrawSetOutline		(poker_deal, 1);
	TextDrawSetProportional	(poker_deal, 1);
	TextDrawUseBox			(poker_deal, 1);
	TextDrawBoxColor		(poker_deal, -286331649);
	TextDrawTextSize		(poker_deal, 15.000000, 90.000000);
	TextDrawSetSelectable	(poker_deal, 1);

	poker_coinValue = TextDrawCreate(510.000000, 136.000000, "MISE VALEUR~n~$100");
	TextDrawAlignment		(poker_coinValue, 2);
	TextDrawBackgroundColor	(poker_coinValue, 255);
	TextDrawFont			(poker_coinValue, 1);
	TextDrawLetterSize		(poker_coinValue, 0.399998, 2.000000);
	TextDrawColor			(poker_coinValue, -1);
	TextDrawSetOutline		(poker_coinValue, 1);
	TextDrawSetProportional	(poker_coinValue, 1);
	TextDrawSetSelectable	(poker_coinValue, 0);
	
	return 1;
}

cPoker_hidePlayerCard(playerid, _card) {
	if ((_card <0) || (_card >= 5))
		return 0;

	if (PlayerText:poker_card[playerid][_card] != PlayerText:INVALID_TEXT_DRAW) {
		PlayerTextDrawHide(playerid, poker_card[playerid][_card]);
		PlayerTextDrawDestroy(playerid, poker_card[playerid][_card]);
	}
	
	return 1;
}

cPoker_showPlayerCard(playerid, _card, _cardType=CARD_TYPE_NONE, _cardValue=1) {
	if ((_card <0) || (_card >= 5))
		return 0;

	cPoker_hidePlayerCard(playerid, _card);
	
	new cardText[20];
	switch (_cardType) {
		case CARD_TYPE_NONE: { format(cardText, 20, "ld_poke:cdback"); }
		case CARD_TYPE_CLUB: { format(cardText, 20, "ld_poke:cd%dc", _cardValue); }
		case CARD_TYPE_DIAMOND: { format(cardText, 20, "ld_poke:cd%dd", _cardValue); }
		case CARD_TYPE_HEART: { format(cardText, 20, "ld_poke:cd%dh", _cardValue); }
		case CARD_TYPE_SPADE: { format(cardText, 20, "ld_poke:cd%ds", _cardValue); }
	}
	
	poker_card[playerid][_card] = CreatePlayerTextDraw(playerid, cardPosX[_card], 262.000000, cardText);
	PlayerTextDrawBackgroundColor	(playerid, poker_card[playerid][_card], 255);
	PlayerTextDrawFont				(playerid, poker_card[playerid][_card], 4);
	PlayerTextDrawLetterSize		(playerid, poker_card[playerid][_card], 0.009999, 0.100000);
	PlayerTextDrawColor				(playerid, poker_card[playerid][_card], -1);
	PlayerTextDrawSetOutline		(playerid, poker_card[playerid][_card], 0);
	PlayerTextDrawSetProportional	(playerid, poker_card[playerid][_card], 1);
	PlayerTextDrawSetShadow			(playerid, poker_card[playerid][_card], 1);
	PlayerTextDrawUseBox			(playerid, poker_card[playerid][_card], 1);
	PlayerTextDrawBoxColor			(playerid, poker_card[playerid][_card], 255);
	PlayerTextDrawTextSize			(playerid, poker_card[playerid][_card], 93.000000, 149.000000);
	PlayerTextDrawSetSelectable		(playerid, poker_card[playerid][_card], 0);

	PlayerTextDrawShow	(playerid, poker_card[playerid][_card]);
	
	return 1;
}


cPoker_hidePlayerCoins(playerid) {
	if (PlayerText:poker_wager[playerid] != PlayerText:INVALID_TEXT_DRAW) {
		PlayerTextDrawHide(playerid, poker_wager[playerid]);
		PlayerTextDrawDestroy(playerid, poker_wager[playerid]);
	}
	
	return 1;
}

cPoker_showPlayerCoins(playerid) {
	cPoker_hidePlayerCoins(playerid);
	new _coins = GetPVarInt(playerid, "ss_pokerCoins");
	new txt[64];
	format(txt, 64, "PARIE~n~$%i", (_coins * 100));
	
	poker_wager[playerid] = CreatePlayerTextDraw(playerid, 510.000000, 176.000000, txt);
	PlayerTextDrawAlignment			(playerid, poker_wager[playerid], 2);
	PlayerTextDrawBackgroundColor	(playerid, poker_wager[playerid], 255);
	PlayerTextDrawFont				(playerid, poker_wager[playerid], 1);
	PlayerTextDrawLetterSize		(playerid, poker_wager[playerid], 0.399998, 2.000000);
	PlayerTextDrawColor				(playerid, poker_wager[playerid], -1);
	PlayerTextDrawSetOutline		(playerid, poker_wager[playerid], 1);
	PlayerTextDrawSetProportional	(playerid, poker_wager[playerid], 1);
	PlayerTextDrawSetSelectable		(playerid, poker_wager[playerid], 0);

	PlayerTextDrawShow	(playerid, poker_wager[playerid]);
}

cPoker_updateCoins(playerid) {
	if (PlayerText:poker_wager[playerid] != PlayerText:INVALID_TEXT_DRAW) {
	
		new _coins = GetPVarInt(playerid, "ss_pokerCoins");
		new txt[64];
		format(txt, 64, "PARIE~n~$%i", (_coins * 100));
		PlayerTextDrawSetString(playerid, poker_wager[playerid], txt);
		
	}
}

cPoker_hidePlayerHold(playerid, _hold) {
	if ((_hold <0) || (_hold >= 5))
		return 0;

	if (PlayerText:poker_hold[playerid][_hold] != PlayerText:INVALID_TEXT_DRAW) {
		PlayerTextDrawHide(playerid, poker_hold[playerid][_hold]);
		PlayerTextDrawDestroy(playerid, poker_hold[playerid][_hold]);
	}
	
	return 1;
}

cPoker_showPlayerHold(playerid, _hold, _buttonState=HOLD_BUTTON_DISABLED) {
	if ((_hold <0) || (_hold >= 5))
		return 0;

	cPoker_hidePlayerHold(playerid, _hold);
	
	poker_hold[playerid][_hold] = CreatePlayerTextDraw(playerid, holdPosX[_hold], 235.0, "Hold");
	PlayerTextDrawAlignment			(playerid, poker_hold[playerid][_hold], 2);
	PlayerTextDrawFont				(playerid, poker_hold[playerid][_hold], 2);
	PlayerTextDrawLetterSize		(playerid, poker_hold[playerid][_hold], 0.299998, 2.000000);
	PlayerTextDrawSetOutline		(playerid, poker_hold[playerid][_hold], 1);
	PlayerTextDrawSetProportional	(playerid, poker_hold[playerid][_hold], 1);
	PlayerTextDrawUseBox			(playerid, poker_hold[playerid][_hold], 1);
	PlayerTextDrawTextSize			(playerid, poker_hold[playerid][_hold], 15.000000, 50.000000);

	switch (_buttonState) {
		case HOLD_BUTTON_DISABLED: {
			PlayerTextDrawBackgroundColor	(playerid, poker_hold[playerid][_hold], 808464639);
			PlayerTextDrawColor				(playerid, poker_hold[playerid][_hold], 1077952767);
			PlayerTextDrawBoxColor			(playerid, poker_hold[playerid][_hold], 1077952767);
		}
		case HOLD_BUTTON_NORMAL: {
			PlayerTextDrawBackgroundColor	(playerid, poker_hold[playerid][_hold], 255);
			PlayerTextDrawColor				(playerid, poker_hold[playerid][_hold], -1);
			PlayerTextDrawBoxColor			(playerid, poker_hold[playerid][_hold], -286331649);
			PlayerTextDrawSetSelectable		(playerid, poker_hold[playerid][_hold], 1);
		}
		case HOLD_BUTTON_SELECTED: {
			PlayerTextDrawBackgroundColor	(playerid, poker_hold[playerid][_hold], 255);
			PlayerTextDrawColor				(playerid, poker_hold[playerid][_hold], -1);
			PlayerTextDrawBoxColor			(playerid, poker_hold[playerid][_hold], -7405313);
			PlayerTextDrawSetSelectable		(playerid, poker_hold[playerid][_hold], 1);
		}
	}
	
	PlayerTextDrawShow				(playerid, poker_hold[playerid][_hold]);
	
	return 1;
}

stock cPoker_openInterface(playerid) {
	SetPVarInt(playerid, "ss_pokerCoins", 1);
	TextDrawShowForPlayer(playerid, poker_background[0]);
	TextDrawShowForPlayer(playerid, poker_background[1]);
	for (new tdi=0; tdi<6; tdi++) {
		TextDrawShowForPlayer(playerid, poker_coinSelectionBG[tdi]);
		TextDrawShowForPlayer(playerid, poker_coinSelectionText[tdi]);
		TextDrawShowForPlayer(playerid, poker_coinHeadingText[tdi]);
	}
	for (new _p=0; _p<5; _p++) {
		cPoker_showPlayerCard(playerid, _p);
		cPoker_showPlayerHold(playerid, _p);
	}
	cPoker_freshGame(playerid);
	TextDrawShowForPlayer(playerid, poker_deal);
	TextDrawShowForPlayer(playerid, poker_addCoin);
	TextDrawShowForPlayer(playerid, poker_coinValue);
	cPoker_showPlayerCoins(playerid);
	
	SelectTextDraw(playerid, 0xFF0000FF);
	_gCasino_SetPlayerFreezeState(playerid, GC_FREEZESTATE_FROZEN);
	//setPlayerGameTDs(playerid, 1);

}

stock cPoker_closeInterface(playerid) {
	TextDrawHideForPlayer(playerid, poker_background[0]);
	TextDrawHideForPlayer(playerid, poker_background[1]);
	for (new tdi=0; tdi<6; tdi++) {
		TextDrawHideForPlayer(playerid, poker_coinSelectionBG[tdi]);
		TextDrawHideForPlayer(playerid, poker_coinSelectionText[tdi]);
		TextDrawHideForPlayer(playerid, poker_coinHeadingText[tdi]);
	}
	for (new _p=0; _p<5; _p++) {
		cPoker_hidePlayerCard(playerid, _p);
		cPoker_hidePlayerHold(playerid, _p);
	}
	TextDrawHideForPlayer(playerid, poker_deal);
	TextDrawHideForPlayer(playerid, poker_addCoin);
	TextDrawHideForPlayer(playerid, poker_coinValue);
	cPoker_hidePlayerCoins(playerid);

	CancelSelectTextDraw(playerid);
	_gCasino_SetPlayerFreezeState(playerid, GC_FREEZESTATE_UNFROZEN);
	//setPlayerGameTDs(playerid, 0);
}

cPoker_deal(playerid) {
	//printf("cPoker_deal(%i) [s]", playerid);
	for (new _c=0; _c<5; _c++) {
		//printf("cPoker_deal(%i) [card:%i] hold = %i", playerid, _c, cPokerGame[playerid][_c][2]);
		if (cPokerGame[playerid][_c][2] == 0) {
			new _c_suit = random(4) + 1;
			new _c_value = random(CARD_KING) + 1;
			
			new cardUsed = true;
			while (cardUsed) {
				//print ("card");
				if (cPoker_cardUsed(playerid, _c_suit, _c_value)) {
					_c_suit = random(4) + 1;
					_c_value = random(CARD_KING) + 1;
				} else {
					cardUsed = false;
				}
			}

			cPoker_showPlayerCard(playerid, _c, _c_suit, _c_value);
			cPokerGame[playerid][_c][0] = _c_suit;
			cPokerGame[playerid][_c][1] = _c_value;
		}
	}
	//printf("cPoker_deal(%i) [e]", playerid);
}

cPoker_freshGame(playerid) {
	//printf("cPoker_freshGame(%i) [s]", playerid);
	SetPVarInt(playerid, "ss_pokerState", 0);
	for (new _c=0; _c<5; _c++) {
		cPokerGame[playerid][_c][0] = 0;
		cPokerGame[playerid][_c][1] = 0;
		cPokerGame[playerid][_c][2] = 0;
	}
	//printf("cPoker_freshGame(%i) [e]", playerid);
}

cPoker_button(playerid, _button, _value=0) {
	//printf("cPoker_button(%i, %i, %i);", playerid, _button, _value);
	if (GetPVarInt(playerid, "ss_casino_use") == 1) {
		new _machineID = GetPVarInt(playerid, "ss_casino_using");
		new _playerGameState = GetPVarInt(playerid, "ss_pokerState");
		new _coinsWagered = GetPVarInt(playerid, "ss_pokerCoins");
		switch (_button) {
			case CASINO_POKER_BTN_DEAL: {
				if (_playerGameState == 0) {
					//print("cPoker_button -> _playerGameState(0) [S]");
					if (CasinoGetPlayerMoney(playerid) >= (100 * _coinsWagered)) {
						CallLocalFunction("OnCasinoMoney", "iiii", playerid, _machineID, 100 * _coinsWagered, CASINO_MONEY_CHARGE);
						cPoker_freshGame(playerid);
						cPoker_deal(playerid);
						for (new _c=0; _c<5; _c++) {
							cPokerGame[playerid][_c][2] = 0;
							cPoker_showPlayerHold(playerid, _c, HOLD_BUTTON_NORMAL);
						}
						SetPVarInt(playerid, "ss_pokerState", 1);
						//print("cPoker_button -> _playerGameState(0) [E]");
					} else {
						CallLocalFunction("OnCasinoMoney", "iiii", playerid, _machineID, 100 * _coinsWagered, CASINO_MONEY_NOTENOUGH);
					}
				} else if (_playerGameState == 1) {
					//print("cPoker_button -> _playerGameState(1) [S]");
					cPoker_deal(playerid);
					SetPVarInt(playerid, "ss_pokerState", 0);
					new res = cPoker_checkGame(playerid);
					
					new msg[128];
					format(msg, 128, "Résultat de la main: %s", cPoker_winningType[res]);
					CallLocalFunction("OnCasinoMessage", "iis", playerid, _machineID, msg);
					
					for (new _c=0; _c<5; _c++) {
						cPokerGame[playerid][_c][2] = 0;
						cPoker_showPlayerHold(playerid, _c, HOLD_BUTTON_DISABLED);
					}
					new winAmm = 0;
					if (res>0) {
						winAmm = cPoker_winningCoins(res, _coinsWagered);
					}
					CallLocalFunction("OnCasinoMoney", "iiii", playerid, _machineID, 100 * winAmm, CASINO_MONEY_WIN);
				}
			}
			case CASINO_POKER_BTN_ADDCOIN: {
				if (_playerGameState == 0) {
					_coinsWagered++;
					if (_coinsWagered > 5) {
						_coinsWagered = 1;
					}
					SetPVarInt(playerid, "ss_pokerCoins", _coinsWagered);
					cPoker_updateCoins(playerid);
				}
			}
			case CASINO_POKER_BTN_HOLD: {
				if (_playerGameState == 1) {
					if (cPokerGame[playerid][_value][2] == 0) {
						cPoker_showPlayerHold(playerid, _value, HOLD_BUTTON_SELECTED);
						cPokerGame[playerid][_value][2] = 1;
					} else {
						cPoker_showPlayerHold(playerid, _value, HOLD_BUTTON_NORMAL);
						cPokerGame[playerid][_value][2] = 0;
					}
				}
			}
		}
	}
	return 1;
}

cPoker_winningCoins(gameResult, coinsWagered) {
	//printf("cPoker_winningCoins(%i, %i, %i)", gameResult, coinsWagered);
	if ((gameResult>=1) && (gameResult<=9)) {
		if ((coinsWagered>=1) && (coinsWagered<=5)) {
			new win = cPoker_winningCoinsValue[gameResult-1][coinsWagered-1];
			//printf(" > %i", win);
			return win;
		}
	}
	return 0;
}

cPoker_cardUsed(playerid, _cardSuit, _cardValue) {
	for (new _c=0; _c<5; _c++) {
		if (cPokerGame[playerid][_c][0] == _cardSuit && cPokerGame[playerid][_c][1] == _cardValue) {
			return 1;
		}
	}
	return 0;
}

cPoker_checkGameContains(playerid, _card, _suit=CARD_TYPE_NONE, _mode=CPOKER_CHECKMODE_CARD) {
	for (new _c=0; _c<5; _c++) {
		switch (_mode) {
			case CPOKER_CHECKMODE_CARD: {
				if (cPokerGame[playerid][_c][1] == _card && cPokerGame[playerid][_c][0] == _suit) {
					return 1;
				}
			}
			case CPOKER_CHECKMODE_CARDSUIT: {
				if (cPokerGame[playerid][_c][1] == _card) {
					return cPokerGame[playerid][_c][0];
				}
			}
		}
	}
	return 0;
}

cPoker_checkGame(playerid) {
	
	new suit_a = cPoker_checkGameContains(playerid, CARD_ACE, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_a: %i", suit_a);
	new suit_2 = cPoker_checkGameContains(playerid, 2, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_2: %i", suit_2);
	new suit_3 = cPoker_checkGameContains(playerid, 3, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_3: %i", suit_3);
	new suit_4 = cPoker_checkGameContains(playerid, 4, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_4: %i", suit_4);
	new suit_5 = cPoker_checkGameContains(playerid, 5, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_5: %i", suit_5);

	if (c_suitsEqual(suit_a,suit_2,suit_3,suit_4,suit_5)) {
		////print("CHECK_ROYALFLUSH");
		return CHECK_ROYALFLUSH;
	}
	
	new suit_10 = cPoker_checkGameContains(playerid, 10, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_10: %i", suit_10);
	new suit_j = cPoker_checkGameContains(playerid, CARD_JACK, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_j: %i", suit_j);
	new suit_q = cPoker_checkGameContains(playerid, CARD_QUEEN, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_q: %i", suit_q);
	new suit_k = cPoker_checkGameContains(playerid, CARD_KING, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_k: %i", suit_k);
	
	if (c_suitsEqual(suit_10,suit_j,suit_q,suit_k,suit_a)) {
		////print("CHECK_ROYALFLUSH");
		return CHECK_ROYALFLUSH;
	}
	
	new suit_6 = cPoker_checkGameContains(playerid, 6, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_6: %i", suit_6);
	new suit_7 = cPoker_checkGameContains(playerid, 7, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_7: %i", suit_7);
	new suit_8 = cPoker_checkGameContains(playerid, 8, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_8: %i", suit_8);
	new suit_9 = cPoker_checkGameContains(playerid, 9, CARD_TYPE_NONE, CPOKER_CHECKMODE_CARDSUIT);
	////printf("suit_9: %i", suit_9);
	
	////print("CHECK_STRAIGHTFLUSH - START");
	if (c_suitsEqual(suit_2,suit_3,suit_4,suit_5,suit_6)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_3,suit_4,suit_5,suit_6,suit_7)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_4,suit_5,suit_6,suit_7,suit_8)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_5,suit_6,suit_7,suit_8,suit_9)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_6,suit_7,suit_8,suit_9,suit_10)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_7,suit_8,suit_9,suit_10,suit_j)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_8,suit_9,suit_10,suit_j,suit_q)) {
		return CHECK_STRAIGHTFLUSH;
	} else if (c_suitsEqual(suit_9,suit_10,suit_j,suit_q,suit_k)) {
		return CHECK_STRAIGHTFLUSH;
	}
	////print("CHECK_STRAIGHTFLUSH - END");
	
	new countC[13];
	////print("CHECK_FOUROFAKIND - START");
	for (new _c=0; _c<5; _c++) {
		new _n = cPokerGame[playerid][_c][1];
		////printf("_n: %i", _n);
		countC[_n-1]++;
		if (countC[_n-1]==4) {
			////print("CHECK_FOUROFAKIND");
			return CHECK_FOUROFAKIND;
		}
	}
	////print("CHECK_FOUROFAKIND - END");
	
	////print("CHECK_FULLHOUSE - START");
	for (new _card=1; _card<=13; _card++) {
		if (countC[_card-1]==3) {
			for (new _subCard=1; _subCard<=13; _subCard++) {
				if (_subCard != _card) {
					if (countC[_subCard-1]==2) {
						//print("CHECK_FULLHOUSE");
						return CHECK_FULLHOUSE;
					}
				}
			}
		}
	}
	////print("CHECK_FULLHOUSE - END");
	
	if (c_Equal(cPokerGame[playerid][0][0],cPokerGame[playerid][1][0],cPokerGame[playerid][2][0],cPokerGame[playerid][3][0],cPokerGame[playerid][4][0])) {
		////print("CHECK_FLUSH");
		return CHECK_FLUSH;
	}

	////print("CHECK_STRAIGHT - START");
	if (c_anySuits(suit_a,suit_2,suit_3,suit_4,suit_5)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_2,suit_3,suit_4,suit_5,suit_6)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_3,suit_4,suit_5,suit_6,suit_7)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_4,suit_5,suit_6,suit_7,suit_8)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_5,suit_6,suit_7,suit_8,suit_9)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_6,suit_7,suit_8,suit_9,suit_10)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_7,suit_8,suit_9,suit_10,suit_j)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_8,suit_9,suit_10,suit_j,suit_q)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_9,suit_10,suit_j,suit_q,suit_k)) {
		return CHECK_STRAIGHT;
	} else if (c_anySuits(suit_10,suit_j,suit_q,suit_k,suit_a)) {
		return CHECK_STRAIGHT;
	} 
	////print("CHECK_STRAIGHT - END");
	
	////print("CHECK_THREEOFAKIND - START");
	for (new _card=1; _card<=13; _card++) {
		if (countC[_card-1]==3) {
			for (new _subCard=1; _subCard<=13; _subCard++) {
				if (_subCard != _card) {
					if (countC[_subCard-1]==1) {
						for (new _subSubCard=1; _subSubCard<=13; _subSubCard++) {
							if (_subCard != _card && _subSubCard != _card && _subCard != _subSubCard) {
								if (countC[_subSubCard-1]==1) {
									return CHECK_THREEOFAKIND;
								}
							}
						}
					}
				}
			}
		}
	}
	////print("CHECK_THREEOFAKIND - END");
	
	////print("CHECK_TWOPAIRS - START");
	for (new _card=1; _card<=13; _card++) {
		////printf("_card: %i", _card);
		if (countC[_card-1]==2) {
			////printf("countC[_card-1]: %i", countC[_card-1]);
			for (new _subCard=1; _subCard<=13; _subCard++) {
				////printf("_subCard: %i", _subCard);
				if (_subCard != _card) {
					if (countC[_subCard-1]==2) {
						////printf("countC[_subCard-1]: %i", countC[_subCard-1]);
						return CHECK_TWOPAIRS;
					}
				}
			}
		}
	}
	////print("CHECK_TWOPAIRS - END");
	
	////print("CHECK_JACKORBETTER - START");
	for (new _card=1; _card<=13; _card++) {
		////printf("_card: %i", _card);
		if (countC[_card-1]==2) {
			////printf("countC[_card-1]: %i", countC[_card-1]);
			return CHECK_JACKORBETTER;
		}
	}				
	return CHECK_NONE;
}




/* HOOKS */
public OnGameModeInit() {
	cPoker_genTDs();

	if (funcidx("_gCasino_OGMI") != -1){
		return CallLocalFunction("_gCasino_OGMI", "");
	}
	return 1;
}

public OnPlayerConnect(playerid) {
	for (new _m=0; _m<5; _m++) {
		poker_card[playerid][_m] = PlayerText:INVALID_TEXT_DRAW;
		poker_hold[playerid][_m] = PlayerText:INVALID_TEXT_DRAW;
	}
	poker_wager[playerid] = PlayerText:INVALID_TEXT_DRAW;

	if (funcidx("_gCasino_OPC") != -1){
		return CallLocalFunction("_gCasino_OPC", "i", playerid);
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (_gCasino_PRESSED(_gCasino_KEY)) {
		new _machine = ClosestCasinoMachine(playerid);
		if (_machine != INVALID_CASINO_MACHINE_ID) {
			openPlayerCasinoInterface(playerid, _machine);
			return 0;
		}
	}

	if (funcidx("_gCasino_OPKSC") != -1){
		return CallLocalFunction("_gCasino_OPKSC", "iii", playerid, newkeys, oldkeys);
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) {
	if (GetPVarInt(playerid, "ss_casino_use") == 1) {
		new _machineID = GetPVarInt(playerid, "ss_casino_using");
		if (clickedid == Text:INVALID_TEXT_DRAW) {
			closePlayerCasinoInterface(playerid);
		} else {
			switch (_machines[_machineID][cm_type]) {
				case CASINO_MACHINE_POKER: {
					if (clickedid == poker_deal) {
						cPoker_button(playerid, CASINO_POKER_BTN_DEAL);
					} else if (clickedid == poker_addCoin) {
						cPoker_button(playerid, CASINO_POKER_BTN_ADDCOIN);
					}
				}
			}
		}
	}

	if (funcidx("_gCasino_OPCTD") != -1){
		return CallLocalFunction("_gCasino_OPCTD", "ii", playerid, _:clickedid);
	}
	return 1;
}
/*
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
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
}*/

#if defined _ALS_OnGameModeInit
  #undef OnGameModeInit
#else
  #define _ALS_OnGameModeInit
#endif

#if defined _ALS_OnPlayerConnect
  #undef OnPlayerConnect
#else
  #define _ALS_OnPlayerConnect
#endif

#if defined _ALS_OnPlayerKeyStateChange
  #undef OnPlayerKeyStateChange
#else
  #define _ALS_OnPlayerKeyStateChange
#endif

#if defined _ALS_OnPlayerClickTextDraw
  #undef OnPlayerClickTextDraw
#else
  #define _ALS_OnPlayerClickTextDraw
#endif
/*
#if defined _ALS_OnPlayerClickPlayerTextDra
  #undef OnPlayerClickPlayerTextDraw
#else
  #define _ALS_OnPlayerClickPlayerTextDra
#endif
*/
#define OnGameModeInit					_gCasino_OGMI
#define OnPlayerConnect					_gCasino_OPC
#define OnPlayerKeyStateChange			_gCasino_OPKSC
#define OnPlayerClickTextDraw			_gCasino_OPCTD
//#define OnPlayerClickPlayerTextDraw		_gCasino_OPCPTD

forward _gCasino_OGMI();
forward _gCasino_OPC(playerid);
forward _gCasino_OPKSC(playerid, newkeys, oldkeys);
forward _gCasino_OPCTD(playerid, Text:clickedid);
forward _gCasino_OPCPTD(playerid, PlayerText:playertextid);

/* _gCasino Callbacks */
forward OnCasinoMoney(playerid, machineid, amount, result);
forward OnCasinoStart(playerid, machineid);
forward OnCasinoEnd(playerid, machineid);
forward OnCasinoMessage(playerid, machineid, message[]);