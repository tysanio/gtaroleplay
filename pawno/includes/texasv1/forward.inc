forward OnJailAccount(index);
forward OnBillboardCreated(bizid);
forward Billboard_Load();
forward OnViewBillboards(extraid, name[]);
forward DestroyWater(objectid);
forward RandomFire();
forward BreakCuffs(playerid, userid);
forward SpawnTimer(playerid);
forward RemoveAttachedObject(playerid, slot);
forward MineTime(playerid);
forward WoodTime(playerid);
forward DestroyBlood(objectid);
forward ExpireMarker(playerid);
forward HidePlayerBox(playerid, PlayerText:boxid);
forward Advertise(playerid);
forward KickHouse(playerid, id);
forward KickBusiness(playerid, id);
forward UpdateBooth(playerid, id);
forward CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ);
forward SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z);
forward RefillUpdate(playerid, vehicleid);
forward Detector_Load();
forward Graffiti_Load();
forward Speed_Load();
forward Rack_Load();
forward Vendor_Load();
forward Garbage_Load();
forward ATM_Load();
forward Impound_Load();
forward Backpack_Load();
forward Gate_Load();
forward Arrest_Load();
forward Faction_Load();
forward Plant_Load();
forward Crate_Load();
forward Job_Load();
forward Entrance_Load();
forward Dropped_Load();
forward Business_Load();
forward House_Load();
forward Car_Load();
forward HarvestPlant(playerid, plantid);
forward OpenCrate(playerid, crateid);
forward CraftParts(playerid, crateid);
forward FirstAidUpdate(playerid);
forward RepairCarMoteur(playerid, vehicleid);
forward RepairCarCaro(playerid, vehicleid);
forward Business_LoadCars(bizid);
forward OnLoadFurniture(houseid);
forward OnLoadCarStorage(carid);
forward OnLoadStorage(houseid);
forward OnLoadBackpack(id);
forward Pump_Load(bizid);
forward OpenInventory(playerid);
forward SelectTD(playerid);
forward DragUpdate(playerid, targetid);
forward KickTimer(playerid);
forward HidePlayerFooter(playerid);
forward OnQueryFinished(extraid, threadid);
forward OnQueryExecute(playerid, query[]);
forward OnViewCharges(extraid, name[]);
forward AccountCheck(playerid);
forward OnResolveUsername(extraid, character[]);
forward OnLoginDate(extraid, username[]);
forward OnCarStorageAdd(carid, itemid);
forward OnStorageAdd(houseid, itemid);
forward OnDealerCarCreated(bizid, slotid);
forward OnFurnitureCreated(furnitureid);
forward OnContactAdd(playerid, id);
forward OnInventoryAdd(playerid, itemid);
forward OnBanLookup(playerid, username[]);
forward OnVerifyNameChange(playerid, newname[]);
forward OnDeleteCharacter(playerid, name[]);
forward OnDeleteAccount(playerid, name[]);
forward OnNameChange(playerid, userid, newname[]);
forward OnTicketCreated(playerid, ticketid);
forward OnRackCreated(rackid);
forward OnGateCreated(gateid);
forward batiement_Load();
forward OnbatiementCreated(batiementid);
forward OnBusinessCreated(bizid);
forward OnEntranceCreated(entranceid);
forward OnCarCreated(carid);
forward OnPumpCreated(pumpid);
forward OnArrestCreated(arrestid);
forward OnPlantCreated(plantid);
forward OnCrateCreated(crateid);
forward OnFactionCreated(factionid);
forward OnBackpackCreated(id);
forward OnATMCreated(atmid);
forward OnImpoundCreated(impoundid);
forward OnGraffitiCreated(id);
forward OnDetectorCreated(id);
forward OnGarbageCreated(garbageid);
forward OnVendorCreated(vendorid);
forward OnSpeedCreated(speedid);
forward OnHouseCreated(houseid);
forward OnDroppedItem(itemid);
forward OnJobCreated(jobid);
forward OnCharacterLookup(extraid, id, character[]);
forward OnCharacterCheck(extraid, character[]);
forward FlashShowTextDrawEx(playerid, PlayerText:textid, amount);
forward HideTextDrawEx(playerid, PlayerText:textid, amount);
forward FlashShowTextDraw(playerid, PlayerText:textid);
forward MinuteCheck();
forward PlayerCheck();
forward UpdateTime1();
forward RefuelCheck();
forward FuelUpdate();
forward OnPlayerUseItem(playerid, itemid, name[]);
forward PutInsideVehicle(playerid, vehicleid);
forward WeatherRotator();
forward LotteryUpdate();
forward ResprayCar(playerid, vehicleid, color);
forward ForkliftUpdate(playerid, vehid);
forward CheckPlayer(playerid,number);
forward OnPlayerEnterDynamicArea(playerid,areaid);
//job meuble
forward CantidadTroncos();
forward Tronco(playerid);
forward Camion();
forward TerminarMueble(playerid);
//argent entreprise
forward moneyentreprisesave(moneyentrepriseid);
forward moneyentrepriseload();
//camera helico
forward THERMALON( playerid, veh );
forward THERMALOFF(playerid);
//pour les  mixe
forward OnPlayerCommandPerformed(playerid, cmdtext[], success);
forward OnPlayerCommandTextEx(playerid, cmdtext[]);
//anti toit
forward NoRoof(playerid);
forward anim2(playerid);
//gouvernement
forward gouvernementinfosave(gouvernementinfoid);
forward gouvernementinfoload();
//gouvernement
forward salairepetitlivreur(rank);
forward salairepetitlivreurload();
forward salairemairie(rank);
forward salairemairieload();
forward salairefbi(rank);
forward salairefbiload();
forward salairejournaliste(rank);
forward salairejournalisteload();
forward salairelivreurbiz(rank);
forward salairelivreurbizload();
forward salairepolice(rank);
forward salairepoliceload();
forward salaireswat(rank);
forward salaireswatload();
forward salaireurgentiste(rank);
forward salaireurgentisteload();
forward salairevendeurrue(rank);
forward salairevendeurrueload();
forward salairemecano3(rank);
forward salairemecano3load();
forward salairemecano4(rank);
forward salairemecano4load();
forward salairetaxi(rank);
forward salairetaxiload();
//cv des entreprise
forward cvfbiidload();
forward cvjournalisteidload();
forward cvlivraisonbizidload();
forward cvmairieidload();
forward cvmecanozone3idload();
forward cvmecanozone4idload();
forward cvpoliceidload();
forward cvswatidload();
forward cvtaxiidload();
forward cvvendeurrueidload();
forward cvurgentisteidload();
//aidemnue
forward jagawaa(playerid);
//limitation de vitesse sur un véhicule abimer
forward BadEngine();
//Usure du moteur
forward SystemPolomka();
//job
forward Gunjobanim(playerid);
//Job boucher
forward meattimer(playerid);
//bots
forward LoadActors();
//anti bunny
forward SlapPlayer(playerid);
forward TimerBunnyHop(playerid);
//job usine
forward UnivPub(playerid);
//job generator
forward ThreeSecondTimer();
//job petrolier
forward PreWoodLoaded(playerid);
//job electricien
forward ElektrikbyLev(playerid);
//info faction
forward IsACop(playerid); //toute les faction gouvernement
forward IsACops(playerid); //juste la police
forward IsACopm(playerid); //la police et urgentiste
forward IsACopf(playerid); //la police et le fbi
forward IsAGang(playerid);
//stock job
forward stockjobinfoload();
forward stockjobinfosave(stockjobinfoid);
//slot machine
forward slotmachineload();
//inside track
forward GameTimeTimeTimer();
//job conteur
forward jobchargement(playerid);
//salaire job
forward salairejobinfoload();
forward salairejobinfosave(salairejobinfoid);
//tuning
forward GetKeys(playerid);
forward tuningload();
forward tuningsave(tuningid);
//afk
forward AFK();
//serveur setting
forward serveursettinginfoload();
forward serveursettinginfosave(serveursettinginfoid);
//dynamite
forward DynamiteTime();
//braquage banque
forward volok();
forward vaultdoors(playerid);
forward startonboom(playerid);
forward remplissagesac(playerid);
//slot machine
forward UpdateMachineTD(playerid);
//vole veh
forward TrafiqueFils(playerid);
//roulette
forward StartRulet(playerid);
forward StopRulet(playerid);
//airbreak v2
forward AntiCheat();
//baterie telephone
forward Timephone();
//bots
forward commandlunch(playerid);
forward commandlunchkevlar(playerid);
forward commandlunchsoins(playerid);
forward commandlunchnos(playerid);
forward commandlunchpaint(playerid);
forward commandlunchoutils(playerid);
//machine slot
forward SpinSpinners(playerid);
forward Prespin(playerid);
forward GiveResult(playerid);
forward SetPlayerWonPaid(playerid);
//bowling
forward PinsWaitTimer(playerid);
forward PinsWaitEnd(playerid);
forward BowlingCountDown(playerid);
forward BallGoingTimer(playerid);
forward BallRunTimer(playerid);
//caisse
forward caisse_Load();
forward OncaisseCreated(caisseid);
//GYM
forward DUMB_START(playerid);
forward BIKE_START(playerid);
forward TREAM_START(playerid);
forward BENCH_START(playerid,OBJ_INDEX);
forward GYM_CHECK(playerid);
forward DUMB_SET_AIMSTOP(playerid);
forward BENCH_SET_AIMSTOP(playerid);
forward REST_PLAYER(playerid);
//starter
forward starter(playerid);
//horse
forward GameTimeTimer2();
forward GameTimeTimeTimer2();
forward HorseStartTimer();
forward HorseAnimTimer();
forward HorseStartHideTimer();
//telphone bg
forward UpdateIphone();
//lowrider
forward SendNoteForPlayer(playerid);
//remove
forward CreateRemoveLS(playerid);
//blackjack
forward blackjackstart1(playerid);
forward blackjackstart2(playerid);
forward blackjackstart3(playerid);
forward blackjackcarte1(playerid);
forward blackjackcarte2(playerid);
forward blackjackcarte3(playerid);
forward blackjackcroupier(playerid);
forward finducroupier(playerid);