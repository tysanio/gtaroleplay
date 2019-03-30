#pragma dynamic 																400000

//Information MYSQL
#define SQL_HOSTNAME 															"127.0.0.1"
//#define SQL_USERNAME 															"root"
#define SQL_USERNAME 															"root"
#define SQL_DATABASE 															"samp2"
//#define SQL_DATABASE 															"test"
#define SQL_PASSWORD															""
//#define SQL_PASSWORD															""

//Information serveur
#define SERVER_NAME 	 														"[0.3.dl] Serveur Roleplay [RP]" //pour le nom du serveur
#define SERVER_URL 		 														"----"
#define SERVER_REVISION  														"Build 76"
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
#define MODEL_SELECTION_VET														(17)

//Job
#define JOB_CHOMEUR																(0)
#define JOB_COURIER 															(1)//itawiwi
#define JOB_UNLOADER 															(2)//fait livreur
#define JOB_MINER 																(3)//fait livreur
#define JOB_SORTER 																(4)//fait livreur
#define JOB_WEAPON_SMUGGLER 													(5)//mafia4
#define JOB_MEUBLE 																(6)//fait livreur
#define JOB_FRABRIEARME                                                         (7)//fait livreur
#define JOB_BUCHERON                                                         	(8)//fait livreur
#define JOB_BOUCHER                                                         	(9)//fait livreur
#define JOB_GENERATEUR                                                        	(10)//fait livreur
#define JOB_PETROLIER                                                        	(11)
#define JOB_ELECTRICIEN                                                        	(12)//fait
#define JOB_DOC                                                        			(13)
#define JOB_USINE                                                               (14)
#define JOB_GARBAGE																(15)

//Maximum par joueur/serveur
#define MAX_REPORTS 															(20)
#define MAX_INVENTORY 															(24)
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
#define MAX_PLAYERS 															(551)
#define MAX_MACHINES 															(10)
#define MAX_caisseS 															(250)
#define MAX_PHONE																(100)

#define MAX_OWNABLE_SOMETHING													(4)
#define MAX_DYNAMIC_OBJ															(125)
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
//discord chat
#define channelstaff "0"
#define channelaide "0"
#define channelnormal "0"
//phrase long test
#define menuclick1 "Skin du joueur\nAnniversaire\nFaim\nSoif\nBras\nJambes\nReset Vehicule Location\nReset Location Maison\nJobs\nHeure de jeux\nMinute de jeux\nOrigine\nSex du joueur"
#define menuclick2 "Vérifier ses stats\nRemettre intérieur et monde a 0\nListe des armes\nReset les armes\nSon IP\nSes Warn(s)\nNettoyer ses warn(s)\nNettoyer son inventaire\nRestaurer Faim et Soif\nDernier Tireur\nVie du joueur\nArmure du joueur\nInterieur du joueur\nVirtual World du joueur\nWarn ce joueur\nChanger son nom\nMettre dans une faction\nMettre le rang d'une faction\nMettre leader d'une faction\nModifier le niveau admin\nAutre Modification"
#define menuclick3 "Bannir se joueur\nFreeze\nUnfreeze\nKick se joueur\nSe téléporter a se joueur\nTéléport ce joueur a toi\nRéanimer se joueur\nMute / Un mute se joueur\nSlap se joueur\nFaire saigner ou pas se joueur\nMettre ou Enlever Helpeur\nMettre ou Enlever FactionModo\nModifier les stats de se joueur"
#define serveursetting1 "OOC\t%d\nPM\t%d\nBraquage NPC\t%d\nBraquage Banque\t%d\nAFK\t%d\nTemps AFK\t%d\nMOTD \t%s$\nVille choisie\t%d\nNouveau chat \t%d\nPolice \t%d\nSwat \t%d"
//truc pour stats et bar de progression
#define PRESSED123(%0) (newkeys & (%0) && !(oldkeys & (%0)))
#define RELEASED123(%0) (!(newkeys & (%0)) && oldkeys & (%0))