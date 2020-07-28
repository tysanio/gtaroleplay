#pragma dynamic 																400000

//Information MYSQL
#define SQL_HOSTNAME 															"localhost"
#define SQL_USERNAME 															"Hayden"
#define SQL_DATABASE 															"samp"
#define SQL_PASSWORD															"iNzp1g0A5!"

//Information serveur
#define SERVER_NAME 	 														"[0.3.dl] Roleplay Life [RP]" //pour le nom du serveur
#define SERVER_URL 		 														"roleplay-life.fr"
#define SERVER_REVISION  														"Version 1"
#define LANGUAGE																"Français"
#define PASSWORD																"12345" // a mettre 0 pour pas de mot de passe

//Couleur
#define COLOR_CLIENT      														(0xAAC4E5BB)
#define COLOR_WHITE       														(0xFFFFFFBB)
#define COLOR_RED         														(0xFF0000BB)
#define COLOR_CYAN        														(0x33CCFFBB)
#define COLOR_LIGHTRED    														(0xFF6347BB)
#define COLOR_LIGHTGREEN  														(0x9ACD32BB)
#define COLOR_YELLOW      														(0xFFFF00BB)
#define COLOR_GREY        														(0xAFAFAFBB)
#define COLOR_HOSPITAL    														(0xFF8282BB)
#define COLOR_PURPLE      														(0xD0AEEBBB)
#define COLOR_LIGHTYELLOW 														(0xF5DEB3BB)
#define COLOR_DARKBLUE    														(0x1394BFBB)
#define COLOR_ORANGE      														(0xFFA500BB)
#define COLOR_LIME        														(0x00FF00BB)
#define COLOR_GREEN       														(0x33CC33BB)
#define COLOR_BLUE        														(0x2641FEBB)
#define COLOR_FACTION     														(0xBDF38BBB)
#define COLOR_RADIO       														(0x8D8DFFBB)
#define COLOR_LIGHTBLUE   														(0x007FFFBB)
#define COLOR_SERVER      														(0xFFFF90BB) // 6688FF
#define COLOR_DEPARTMENT  														(0xF0CC00BB)
#define COLOR_ADMINCHAT   														(0x33EE33BB)
#define DEFAULT_COLOR     														(0xFFFFFF00)
#define COLOR_LEV 																(0xFF9900AA)
#define COLOR_PINK 																(0xFFC0CBAA)

//Personnage
#define THREAD_CREATE_CHAR 														(1)
#define THREAD_CHECK_ACCOUNT 													(2)
#define THREAD_LOGIN 															(3)
#define THREAD_CHARACTERS 														(4)
#define THREAD_LOAD_CHARACTER 													(5)
#define THREAD_VERIFY_PASS 														(6)
#define THREAD_FIND_USERNAME 													(7)
#define THREAD_LOAD_INVENTORY 													(8)
#define THREAD_BAN_LOOKUP 														(9)
#define THREAD_LOAD_CONTACTS 													(10)
#define THREAD_LOAD_LOCATIONS 													(11)
#define THREAD_LOAD_TICKETS 													(12)
#define THREAD_SHOW_CHARACTER 													(13)

//Selection d'object
#define MODEL_SELECTION_GLASSES 												(1)
#define MODEL_SELECTION_HATS 													(2)
#define MODEL_SELECTION_BANDANAS 												(3)
#define MODEL_SELECTION_SKIN 													(4)
#define MODEL_SELECTION_INVENTORY 												(5)
#define MODEL_SELECTION_CLOTHES 												(6)
#define MODEL_SELECTION_DEALER 													(7)
#define MODEL_SELECTION_DEALER_ADD 												(8)
#define MODEL_SELECTION_BUY_CAR 												(9)
#define MODEL_SELECTION_FURNITURE 												(10)
#define MODEL_SELECTION_COLOR 													(11)
#define MODEL_SELECTION_SKINS 													(12)
#define MODEL_SELECTION_ADD_SKIN 												(13)
#define MODEL_SELECTION_FACTION_SKIN 											(14)
#define MODEL_SELECTION_WHEELS 													(15)
#define MODEL_SELECTION_FRISK 													(16)
#define MODEL_SELECTION_VET														(17)

//Job
#define JOB_CHOMEUR																(0)
#define JOB_COURIER 															(1)
#define JOB_UNLOADER 															(2)
#define JOB_MINER 																(3)
#define JOB_SORTER 																(4)
#define JOB_MEUBLE 																(5)
#define JOB_FRABRIEARME                                                         (6)
#define JOB_BUCHERON                                                         	(7)
#define JOB_BOUCHER                                                         	(8)
#define JOB_GENERATEUR                                                        	(9)
#define JOB_PETROLIER                                                        	(10)
#define JOB_ELECTRICIEN                                                        	(11)
#define JOB_DOC                                                        			(12)
#define JOB_USINE                                                               (13)
#define JOB_GARBAGE																(14)

//Maximum par joueur/serveur
#define MAX_REPORTS 															(20)
#define MAX_INVENTORY 															(35)
#define MAX_HOUSES 																(750)
#define MAX_HOUSE_STORAGE 														(10)
#define MAX_BUSINESSES 															(150)
#define MAX_DROPPED_ITEMS 														(3500)
#define MAX_DEALERSHIP_CARS 													(40)
#define MAX_DYNAMIC_CARS 														(1500)
#define MAX_FURNITURE 															(7500)
#define MAX_HOUSE_FURNITURE 													(100)
#define MAX_DYNAMIC_JOBS 														(20)
#define MAX_CONTACTS 															(20)
#define MAX_GPS_LOCATIONS 														(20)
#define MAX_CAR_STORAGE 														(10)
#define MAX_DRUG_PLANTS 														(100)
#define MAX_FACTIONS 															(20)
#define MAX_ARREST_POINTS 														(5)
#define MAX_PLAYER_TICKETS 														(10)
#define MAX_BARRICADES 															(15)
#define MAX_BOOTHS 																(8)
#define MAX_batiementS															(250)
#define MAX_WEAPON_RACKS 														(500)
#define MAX_LISTED_ITEMS 														(10)
#define MAX_GRAFFITI_POINTS 													(20)
#define MAX_METAL_DETECTORS 													(20)
#define MAX_BACKPACKS 															(2000)
#define MAX_BACKPACK_CAPACITY 													(5)
#undef MAX_PLAYERS
#define MAX_PLAYERS 															(251)
#define MAX_MACHINES 															(10)
#define MAX_caisseS 															(250)
#define MAX_PHONE																(100)

#define MAX_OWNABLE_SOMETHING													(4)
#define MAX_DYNAMIC_OBJ															(125)
#define MAX_DYNAMIC_TRASH														(225)
//Prison
#define PRISON_WORLD 															(10000)
//Diver
#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_SERVER, "[SERVEUR]:{FFFFFF} "%1)
#define SendSyntaxMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_GREY, "[SYNTAX]:{FFFFFF} "%1) // COLOR_YELLOW
#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ERREUR]:{FFFFFF} "%1)
#define SendAdminAction(%0,%1) \
	SendClientMessageEx(%0, COLOR_ADMINCHAT, "[ADMIN]:{FFFFFF} "%1) // COLOR_YELLOW
#define SendVehiculeMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_LEV, "[VEHICULE]:{FFFFFF} "%1)
#define SendEntrepriseMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_CYAN,"[ENTREPRISE]:{FFFFFF}"%1)
#define SendANPEMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_PURPLE,"[ANPE]:{FFFFFF}" %1)
#define SendJOBMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_GREEN,"[JOB]:{FFFFFF}" %1)
#define SendSalaireMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_ORANGE,"[SALAIRE]:{FFFFFF}" %1)
#define SendPermisMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_LIGHTGREEN,"[PERMIS DE CONDUIRE]:{FFFFFF}" %1)
#define SendAnnonceMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_ADMINCHAT,"[Annonce]:{FFFFFF}" %1)
#define SendTelephoneMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_YELLOW,"[Téléphone]:{FFFFFF}" %1)
#define SendBlackJackMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_LIME,"[Croupier]: {FFFFFF}" %1)
#define SendTutorialMessage(%0,%1) \
	SendClientMessageEx(%0,COLOR_PINK,"[TUTORIEL]: {FFFFFF}" %1)
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
//limitation de vitesse sur un véhicule abimer
#define BE_MIN_HLS 																500.00 // Santé en dessous de laquelle la machine est considéré comme cassé
#define BE_MAX_SPD_VAR 															50 // la vitesse maximale peut être changée
#define BE_MAX_SPD 																BE_MAX_SPD_VAR*0.005
#define GCASH                                                                   30
//slot machine
#define MONEY_COST 																10
#define MONEY_WIN 																10*MONEY_COST
//nouveau mesage box
#define TSM 																	TD_SendMessage
//roulette
#define Frist_Bet_Value 														10
#define Second_Bet_Value 														5
//barriere
#define MAX_CADES 20
//bowling
#define MAX_PINS 10
#define MAX_BOWLING_ROADS 5
#define PIN_GOAWAY 	0
#define PIN_LAST 	1
#define F_BOWLING_THROW 0
#define S_BOWLING_THROW 1
#define N_BOWLING_THROW 2
#define ROAD_EMPTY 0
#define ROAD_BUSY 1
#define ROAD_NONE 255
#define Y_ROAD_2 1.43993652586
#define Y_ROAD_3 3.11993652586
#define Y_ROAD_4 4.55993652586
#define Y_ROAD_5 6.10243269586
#define BALL_SPEED 5.0
#define BALL_RUN_TIME 1950
//horse
#define TimerTextDrawLocX 547
#define TimerTextDrawLocY 2
#define CashLowerBounds 100
#define CashHigherBounds 50000
//lowrider
#define CameraAngles
//define forward fuck you
#define script%0(%1) forward%0(%1); public%0(%1)
//discord chat A CHANGER POUR LES BONNE VALEUR
#define channelstaff " "
#define channelaide " "
#define channelnormal  " "
//phrase long
#define serveursetting1 "OOC\t%d\nPM\t%d\nBraquage NPC\t%d\nBraquage Banque\t%d\nAFK\t%d\nTemps AFK\t%d\nMOTD \t%s$\nVille choisie\t%d\nNouveau chat \t%d\nPolice \t%d\nSwat \t%d\nWhiteListe \t%d\nID discord\nID Vérifier\nID admin 1\nID admin 2\nID admin 4"
//truc pour stats et bar de progression
#define PRESSED123(%0) (newkeys & (%0) && !(oldkeys & (%0)))
#define RELEASED123(%0) (!(newkeys & (%0)) && oldkeys & (%0))