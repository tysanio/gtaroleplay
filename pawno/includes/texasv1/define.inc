#pragma dynamic 																400000

//Information MYSQL
#define SQL_HOSTNAME 															"127.0.0.1"
//#define SQL_USERNAME 															"root"
#define SQL_USERNAME 															"root"
#define SQL_DATABASE 															"samp2"
//#define SQL_DATABASE 															"test"
#define SQL_PASSWORD															"louvna29"
//#define SQL_PASSWORD															""

//Information serveur
#define SERVER_NAME 	 														"[0.3.dl] In Real Life [RP]" //pour le nom du serveur
#define SERVER_URL 		 														"----------"
#define SERVER_REVISION  														"Vice city build"
#define LANGUAGE																"Français"
#define PASSWORD																"0" // a mettre 0 pour pas de mot de passe

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
#define MODEL_SELECTION_FRONTBUMPERS                                            (17)
#define MODEL_SELECTION_REARBUMPERS                                             (18)
#define MODEL_SELECTION_ROOFS                                                   (19)
#define MODEL_SELECTION_HOODS                                                   (20)
#define MODEL_SELECTION_SPOILERS                                                (21)
#define MODEL_SELECTION_SIDESKIRTS1                                             (22)
#define MODEL_SELECTION_SIDESKIRTS2                                             (23)
#define MODEL_SELECTION_ROUE                                                    (24)
#define MODEL_SELECTION_VET														(25)

//Job
#define JOB_CHOMEUR																(0)
#define JOB_COURIER 															(1)//itawiwi
#define JOB_UNLOADER 															(4)//fait livreur
#define JOB_MINER 																(5)//fait livreur
#define JOB_GARBAGE 															(7)//mairie
#define JOB_SORTER 																(8)//fait livreur
#define JOB_WEAPON_SMUGGLER 													(9)//mafia4
#define JOB_MEUBLE 																(10)//fait livreur
#define JOB_FRABRIEARME                                                         (11)//fait livreur
#define JOB_BUCHERON                                                         	(12)//fait livreur
#define JOB_BOUCHER                                                         	(13)//fait livreur
#define JOB_GENERATEUR                                                        	(15)//fait livreur
#define JOB_PETROLIER                                                        	(16)
#define JOB_ELECTRICIEN                                                        	(17)//fait
#define JOB_DOC                                                        			(18)
#define JOB_USINE                                                               (19)

//Maximum par joueur
#define MAX_BILLBOARDS 															(50)
#define MAX_REPORTS 															(25)
#define MAX_INVENTORY 															(24)
#define MAX_HOUSES 																(750)
#define MAX_HOUSE_STORAGE 														(10)
#define MAX_BUSINESSES 															(150)
#define MAX_DROPPED_ITEMS 														(4000)
#define MAX_ENTRANCES 															(100)
#define MAX_DEALERSHIP_CARS 													(40)
#define MAX_DYNAMIC_CARS 														(1500)
#define MAX_GAS_PUMPS 															(50)
#define MAX_FURNITURE 															(15555)
#define MAX_HOUSE_FURNITURE 													(100)
#define MAX_DYNAMIC_JOBS 														(20)
#define MAX_CONTACTS 															(20)
#define MAX_GPS_LOCATIONS 														(20)
#define MAX_CAR_STORAGE 														(10)
#define MAX_CRATES 																(100)
#define MAX_DRUG_PLANTS 														(100)
#define MAX_FACTIONS 															(30)
#define MAX_ARREST_POINTS 														(5)
#define MAX_PLAYER_TICKETS 														(10)
#define MAX_BARRICADES 															(25)
#define MAX_BOOTHS 																(8)
#define MAX_GATES 																(200)
#define MAX_batiementS															(250)
#define MAX_IMPOUND_LOTS 														(150)
#define MAX_ATM_MACHINES 														(75)
#define MAX_GARBAGE_BINS 														(150)
#define MAX_VENDORS 															(75)
#define MAX_WEAPON_RACKS 														(500)
#define MAX_SPEED_CAMERAS 														(75)
#define MAX_LISTED_ITEMS 														(10)
#define MAX_GRAFFITI_POINTS 													(20)
#define MAX_METAL_DETECTORS 													(20)
#define MAX_OWNABLE_CARS 														(5)
#define MAX_OWNABLE_HOUSES 														(3)
#define MAX_OWNABLE_BUSINESSES 													(3)
#define MAX_BACKPACKS 															(2000)
#define MAX_BACKPACK_ITEMS 														(4000)
#define MAX_BACKPACK_CAPACITY 													(5)
#undef MAX_PLAYERS
#define MAX_PLAYERS 															(50)
#define MAXACTORS               												(100) //Max bots
#define MAX_MACHINES 															(10)
#define MAX_caisseS 															(250)
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
	
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
//limitation de vitesse sur un véhicule abimer
#define BE_MIN_HLS 																500.00 // Santé en dessous de laquelle la machine est considéré comme cassé
#define BE_MAX_SPD_VAR 															50 // la vitesse maximale peut être changée
#define BE_MAX_SPD 																BE_MAX_SPD_VAR*0.005
#define GCASH                                                                   30
//slot machine
#define MONEY_COST 																10
#define MONEY_WIN 																10*MONEY_COST
//braquage
#define COP_MIN_COPS_BRAQUAGE 													-1     // Minimum de flics pour un braquage DE biz
#define SWAT_MIN_COPS_BRAQUAGE 													6     // Minimum de flics pour un braquage DE BANQUE
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
#define ORANGE 0xF97804FF
#define TimerTextDrawLocX 547
#define TimerTextDrawLocY 2
#define CashLowerBounds 100
#define CashHigherBounds 50000
//lowrider
#define CameraAngles
//define forward fuck you
#define script%0(%1) forward%0(%1); public%0(%1)