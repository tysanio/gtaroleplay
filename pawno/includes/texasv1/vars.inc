new TruckingCheck[MAX_PLAYERS];
new Text3D:vehicle3Dtext[MAX_VEHICLES];
new vehiclecallsign[MAX_VEHICLES];
enum playerData {
	pID,
	pAccount,
	pLogged,
	pIP[16],
	pLoginDate[36],
	PlayerText:pTextdraws[97],
	pUsername[MAX_PLAYER_NAME + 1],
	pLoginAttempts,
	pCreated,
	pGender,
	pBirthdate[24],
	pOrigin[32],
	pSkin,
	pEditType,
	pGlasses,
	pHat,
	pBandana,
	Float:pPos[4],
	Float:pHealth,
	pInterior,
	pWorld,
	pCharacter,
	pHospital,
	pHospitalInt,
	pHospitalTime,
	pRepairTime,
	pKilled,
	pMoney,
	pBankMoney,
	pOwnsBillboard,
	pSavings,
	pAdmin,
	pShowFooter,
	pFooterTimer,
	pReportTime,
	pHelpTime,
	pSpectator,
	pJailTime,
	pKicked,
	pMuted,
	pDisplayStats,
	pCharacterMenu,
	pToggleGlasses,
	pToggleHat,
	pToggleBandana,
	pToggleArmor,
	pLastShot,
	pShotTime,
	pInventoryItem,
	pStorageItem,
	pStorageSelect,
	pProductModify,
 	pTester,
	pGuns[13],
	pAmmo[13],
	pTutorial,
	pTutorialTime,
	pTutorialStage,
	pTutorialObject,
	pHouse,
	pBusiness,
	pEntrance,
	pDealership,
	pContact,
	pGasPump,
	pGasStation,
	pEditPump,
	pEditFurniture,
	pEditGate,
	pEditbatiement,
	pEditRack,
	pSelectFurniture,
	pRefill,
	pRefillPrice,
	pDealerCar,
	pEditingItem[32 char],
	pHouseSeller,
	pHouseOffered,
	pHouseValue,
	pBusinessSeller,
	pBusinessOffered,
	pBusinessValue,
	pCarSeller,
	pCarOffered,
	pCarValue,
	pShakeOffer,
	pShakeType,
	pFriskOffer,
	pFoodSeller,
	pFoodType,
	pFoodPrice,
	pFactionOffer,
	pFactionOffered,
	pHouseLights,
	pPhone,
	pPhoneOff,
	pLottery,
	pLotteryB,
	pHunger,
	pThirst,
	pHungerTime,
	pThirstTime,
	pCooking,
	pCookingTime,
	pCookingHouse,
	pPlayingHours,
	pMinutes,
	Float:pArmorStatus,
	pArmorShown,
	pClothesType,
	pDrivingTest,
	pTestStage,
	pTestCar,
	pTestWarns,
	pFurnitureType,
	pJob,
	pTaxiFee,
	pTaxiTime,
	pTaxiPlayer,
	pTaxiDuty,
	pFirstAid,
	pAidTimer,
	pIncomingCall,
	pCallLine,
	pMining,
	pWoodcutting,
	pMineTime,
	pWoodTime,
	pMineCount,
	pWoodCount,
	pMinedRock,
	pWoodRock,
	pCarryTrash,
	pCarryCrate,
	pCrateVehicle,
	pCrafting,
	pOpeningCrate,
	pHarvesting,
	pFaction,
	pFactionID,
	pFactionRank,
	pFactionEdit,
	pSelectedSlot,
	pOnDuty,
	pTazer,
	pflashball,
	pStunned,
	pCuffed,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pWarrants,
	pMDCPlayer,
	pTrackTime,
	pCP,
	pPrisoned,
	pInjured,
	pBroadcast,
	pNewsGuest,
	pSpamCount,
	pCommandCount,
	pMuteTime,
	pTransfer,
	pWaypoint,
	pLocation[32],
	Float:pWaypointPos[3],
	pFuelCan,
	pDisableOOC,
	pDisablePM,
	pDisableFaction,
	pDisableTester,
	pDisableBC,
	pDisableSpeedo,
	pNameChange[32],
	pDrugUsed,
	pDrugTime,
	pFingerTime,
	pFingerItem,
	pHealthTime,
	pWeapon,
	pBackpackLoot,
	pGiveItem,
	pChannel,
	pEmergency,
	pPlaceAd,
	pAdTime,
	pRangeBooth,
	pTargets,
	pTargetLevel,
	pVendorTime,
	pLoopAnim,
	pExecute,
	pBoombox,
	pTakeItems,
	PlayerBar:pDrinkBar,
	pDrinking,
	pDrinkTime,
	pAdvertise[128 char],
	pTaxiCalled,
	pSpeedTime,
	pMarker,
	pBleeding,
	pBleedTime,
	pLoadType,
	pLoadCrate,
	pLoading,
	pUnloading,
	pUnloadVehicle,
	pShipment,
	pDeliverShipment,
	pHoldWeapon,
	pUsedMagazine,
	pTask,
	pBankTask,
	pStoreTask,
	pTestTask,
	pWarnings,
 	pWarn1[32],
	pWarn2[32],
	pSorting,
	pSortCrate,
	pTesterDuty,
	pAdminDuty,
	pSeekHelp,
	pHUD,
	pMaskID,
	pMaskOn,
	pHideTags,
	pFactionMod,
	pCapacity,
	pPlayRadio,
	pLeaveTime,
	pLeaveIP[16],
	pGraffiti,
	pGraffitiTime,
	pGraffitiColor,
	pGraffitiText[64 char],
	pEditGraffiti,
	pAdminHide,
	pDetectorTime,
	pPicking,
	pPickCar,
	pPickTime,
	pJetpack,
	pFreeze,
	pFreezeTimer,
	Text3D:pNameTag,
	pSpawnPoint,
	pMecanoSeller,
	pMecanoValue,
	//roulette
	PlayerText:TD[61],
	PlayerText:C_TD[50],	
	CType,
	Number,
	_3to1,
	_1st12,
	_2nd12,
	_3rd12,
	_1to18,
	_19to36,
	Color,
	EVOROOD,
	//bk
	pRequestingBackup,
	//bracelet electronic
	pBracelet,
	pBraceletProx,
	//loc veh
	pLocaID,
	//prêt veh
	pCarD,
	//baterie telephone
	pAcom,
	//bowling
	pBestScore,
	pStrike,
	//locationmaison
	pLocaMaisonID,
	//caise
	pEditcaisse,
	//musculation
	prepetitions,
	pparcouru,
	pck,
	//non faction payday de merde
	pNoob
};
enum prisonData {
	prisonDoors[3],
	prisonCells[24],
	prisonDoorOpened[3],
	prisonCellOpened[24]
};
enum reportData {
	rExists,
	rType,
	rPlayer,
	rText[128 char]
};
enum billboardData {
	bbID,
	bbExists,
	bbName[32],
	bbMessage[230],
	bbOwner,
	bbPrice,
	bbRange,
	Float:bbPos[4],
	Text3D:bbText3D
};
new BillBoardData[MAX_BILLBOARDS][billboardData];
new BillboardCheckout[MAX_PLAYERS];
enum inventoryData {
	invExists,
	invID,
	invItem[32 char],
	invModel,
	invQuantity
};
enum houseData {
	houseID,
	houseExists,
	houseOwner,
	housePrice,
	houseAddress[32],
	Float:housePos[4],
	Float:houseInt[4],
	houseInterior,
	houseInteriorVW,
	houseExterior,
	houseExteriorVW,
	houseLocked,
	houseMoney,
	houseMapIcon,
	Text3D:houseText3D,
	housePickup,
	houseLights,
	houseWeapons[10],
	houseAmmo[10],
	houseLocation,//Le prix de location (0 si non louable)
	houseMaxLoc,//Nombre max de locataire
	houseLocNum//Nombre de locataire
};
enum houseStorage {
	hItemID,
	hItemExists,
	hItemName[32 char],
	hItemModel,
	hItemQuantity
};
enum businessData {
	bizID,
	bizExists,
 	bizName[32],
	bizMessage[128],
	bizOwner,
	bizType,
	bizPrice,
	Float:bizPos[4],
	Float:bizInt[4],
	Float:bizSpawn[4],
	Float:bizDeliver[3],
	bizInterior,
	bizInteriorVW,
	bizExterior,
	bizExteriorVW,
	bizLocked,
	bizVault,
	bizProducts,
	bizPickup,
	bizShipment,
	bizPrices[20],
	Text3D:bizText3D,
	Text3D:bizDeliverText3D,
	bizDeliverPickup,
	biztime1,
	biztime2,
	bizchancevole,
	bizdefoncer
};
enum droppedItems {
	droppedID,
	droppedItem[32],
	droppedPlayer[24],
	droppedModel,
	droppedQuantity,
	Float:droppedPos[3],
	droppedWeapon,
	droppedAmmo,
	droppedInt,
	droppedWorld,
	droppedObject,
	Text3D:droppedText3D
};
enum entranceData {
	entranceID,
	entranceExists,
	entranceName[32],
	entrancePass[32],
	entranceIcon,
	entranceLocked,
	Float:entrancePos[4],
	Float:entranceInt[4],
	entranceInterior,
	entranceExterior,
	entranceExteriorVW,
	entranceType,
	entranceCustom,
	entranceWorld,
	entranceForklift[7],
	entrancePickup,
	entranceMapIcon,
	Text3D:entranceText3D
};
enum dealershipCars {
	vehID,
	vehModel,
	vehPrice
};
enum carData {
	carID,
	carExists,
	carModel,
	carOwner,
	Float:carPos[4],
	carColor1,
	carColor2,
	carPaintjob,
	carLocked,
	carMods[14],
	carImpounded,
	carImpoundPrice,
	carFaction,
	carWeapons[5],
	carAmmo[5],
	carLoca,
	carLocaID,
	carDouble,
	carSabot,
	carSabPri,
	carVehicle,
	carKilo,
	carMetre,
	carfuel,
	Float:carvie
};
enum carStorage {
	cItemID,
	cItemExists,
	cItemName[32 char],
	cItemModel,
	cItemQuantity
};
enum pumpData {
	pumpID,
	pumpExists,
	pumpBusiness,
	Float:pumpPos[4],
	pumpFuel,
	pumpObject,
	Text3D:pumpText3D
};
enum furnitureData {
	furnitureID,
	furnitureHouse,
	furnitureExists,
	furnitureModel,
	furnitureName[32],
	Float:furniturePos[3],
	Float:furnitureRot[3],
	furnitureObject
};
enum jobData {
	jobID,
	jobExists,
	jobType,
	Float:jobPos[3],
	Float:jobPoint[3],
	Float:jobDeliver[3],
	jobInterior,
	jobWorld,
	jobPointInt,
	jobPointWorld,
	jobPickups[3],
	Text3D:jobText3D[3]
};
enum contactData {
	contactID,
	contactExists,
	contactName[32],
	contactNumber
};
enum locationData {
	locationID,
	locationExists,
	locationName[32],
	Float:locationPos[3],
};
enum crateData {
	crateID,
	crateExists,
	crateType,
 	Float:cratePos[4],
	crateInterior,
	crateWorld,
	crateObject,
	crateVehicle,
	Text3D:crateText3D
};
enum plantData {
	plantID,
	plantExists,
	plantType,
	plantDrugs,
	Float:plantPos[4],
	plantInterior,
	plantWorld,
	plantObject,
	Text3D:plantText3D
};
enum factionData {
	factionID,
	factionExists,
	factionName[32],
	factionRanks,
	Float:factionLockerPos[3],
	factionLockerInt,
	factionLockerWorld,
	factionSkins[8],
	factionWeapons[10],
	factionAmmo[10],
	Text3D:factionText3D,
	factionPickup,
	factionacces[15]
};
enum arrestPoints {
	arrestID,
	arrestExists,
	Float:arrestPos[3],
	arrestInterior,
	arrestWorld,
	Text3D:arrestText3D,
	arrestPickup
};
enum ticketData {
	ticketID,
	ticketExists,
	ticketFee,
	ticketDate[36],
	ticketReason[64]
};
enum barricadeData {
	cadeExists,
	cadeType,
	Float:cadePos[3],
	cadeObject
};
enum BatiementData {
	batiementID,
	batiementExists,
	batiementModel,
	Float:batiementPos[6],
	batiementInterior,
	batiementWorld,
	batiementObject
};
enum gateData {
	gateID,
	gateExists,
	gateOpened,
	gateModel,
	Float:gateSpeed,
	Float:gateRadius,
	gateTime,
	Float:gatePos[6],
	gateInterior,
	gateWorld,
	Float:gateMove[6],
	gateLinkID,
	gateFaction,
	gatePass[32],
	gateTimer,
	gateObject
};
enum backpackData {
	backpackID,
	backpackExists,
	backpackPlayer,
	backpackHouse,
	backpackVehicle,
	Float:backpackPos[3],
	backpackInterior,
	backpackWorld,
	Text3D:backpackText3D,
	backpackObject
};
enum backpackItems {
	bItemID,
	bItemBackpack,
	bItemExists,
	bItemName[32],
	bItemModel,
	bItemQuantity
};
enum impoundData {
	impoundID,
	impoundExists,
	Float:impoundLot[3],
	Float:impoundRelease[4],
	Text3D:impoundText3D,
	impoundPickup
};
enum atmData {
	atmID,
	atmExists,
	Float:atmPos[4],
	atmInterior,
	atmWorld,
	atmObject,
	Text3D:atmText3D
};
enum garbageData {
	garbageID,
	garbageExists,
 	garbageModel,
	garbageCapacity,
	Float:garbagePos[4],
	garbageInterior,
	garbageWorld,
	Text3D:garbageText3D,
	garbageObject
};
enum vendorData {
	vendorID,
	vendorExists,
	vendorType,
	Float:vendorPos[4],
	vendorInterior,
	vendorWorld,
	Text3D:vendorText3D,
	vendorObject
};
enum boomboxData {
	boomboxPlaced,
	Float:boomboxPos[3],
	boomboxInterior,
	boomboxWorld,
	boomboxObject,
	boomboxURL[128 char],
	Text3D:boomboxText3D
};
enum rackData {
	rackID,
	rackExists,
	rackHouse,
	Float:rackPos[4],
	rackInterior,
	rackWorld,
	rackWeapons[4],
	rackAmmo[4],
	rackObjects[5],
	Text3D:rackText3D
};
enum speedData {
	speedID,
	speedExists,
	Float:speedPos[4],
	Float:speedRange,
	Float:speedLimit,
	speedObject,
	Text3D:speedText3D
};
enum graffitiData {
	graffitiID,
	graffitiExists,
	Float:graffitiPos[4],
	graffitiIcon,
	graffitiObject,
	graffitiColor,
	graffitiText[64]
};
enum detectorData {
	detectorID,
	detectorExists,
	Float:detectorPos[4],
	detectorInterior,
	detectorWorld,
	detectorObject[2]
};
new g_iHandle;
new g_ServerLocked;
new Text:gServerTextdraws[4];

new g_ServerRestart;
new g_RestartTime;
new g_BoothUsed[MAX_BOOTHS];
new g_BoothObject[MAX_BOOTHS] = {-1, ...};

new g_aFireObjects[36] = {INVALID_OBJECT_ID, ...};
new g_aFireExtinguished[36];

new GraffitiData[MAX_GRAFFITI_POINTS][graffitiData];
new MetalDetectors[MAX_METAL_DETECTORS][detectorData];
new BarricadeData[MAX_BARRICADES][barricadeData];

new VendorData[MAX_VENDORS][vendorData];
new SpeedData[MAX_SPEED_CAMERAS][speedData];

new BoomboxData[MAX_PLAYERS][boomboxData];
new RackData[MAX_WEAPON_RACKS][rackData];

new ATMData[MAX_ATM_MACHINES][atmData];
new GarbageData[MAX_GARBAGE_BINS][garbageData];

new BackpackData[MAX_BACKPACKS][backpackData];
new BackpackItems[MAX_BACKPACK_ITEMS][backpackItems];

new BackpackListed[MAX_PLAYERS][MAX_BACKPACK_CAPACITY];
new ImpoundData[MAX_IMPOUND_LOTS][impoundData];

new PlayerData[MAX_PLAYERS][playerData];
new Float:AccessoryData[MAX_PLAYERS][3][9];
new TicketData[MAX_PLAYERS][MAX_PLAYER_TICKETS][ticketData];
new ListedVehicles[MAX_PLAYERS][MAX_OWNABLE_CARS];

new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
new ContactData[MAX_PLAYERS][MAX_CONTACTS][contactData];
new LocationData[MAX_PLAYERS][MAX_GPS_LOCATIONS][locationData];

new ListedFurniture[MAX_PLAYERS][MAX_HOUSE_FURNITURE];
new NearestItems[MAX_PLAYERS][MAX_LISTED_ITEMS];
new ListedContacts[MAX_PLAYERS][MAX_CONTACTS];

new ReportData[MAX_REPORTS][reportData];
new ArrestData[MAX_ARREST_POINTS][arrestPoints];

new BusinessData[MAX_BUSINESSES][businessData];
new PumpData[MAX_GAS_PUMPS][pumpData];
new DealershipCars[MAX_BUSINESSES][MAX_DEALERSHIP_CARS][dealershipCars];

new DroppedItems[MAX_DROPPED_ITEMS][droppedItems];
new EntranceData[MAX_ENTRANCES][entranceData];

new CarData[MAX_DYNAMIC_CARS][carData];
new CarStorage[MAX_DYNAMIC_CARS][MAX_CAR_STORAGE][carStorage];

new HouseData[MAX_HOUSES][houseData];
new HouseStorage[MAX_HOUSES][MAX_HOUSE_STORAGE][houseStorage];
new FurnitureData[MAX_FURNITURE][furnitureData];

new JobData[MAX_DYNAMIC_JOBS][jobData];
new CrateData[MAX_CRATES][crateData];
new PlantData[MAX_DRUG_PLANTS][plantData];

new FactionData[MAX_FACTIONS][factionData];
new FactionRanks[MAX_FACTIONS][15][32];
new GateData[MAX_GATES][gateData];
new PrisonData[prisonData];
new Float:PrisonCells[24][3];
new batiementData[MAX_batiementS][BatiementData];
/*
	0 to 10: Character textdraws
	11 to 22: ID card
	23 to 33: Character customization
	34 to 38: Speedometer
	39: Footer textdraw
	40 to 49: Stats textdraw
	50 to 57: Character textdraw
	58 to 61: Tutorial textdraws
	62: House light
	63 to 64: Hunger and thirst (percent)
	65 to 66: Hunger and thirst (model icons)
	67 to 68: Armor
	69: GPS
	84 to 94: speedo
*/
new PlayerCharacters[MAX_PLAYERS][3][MAX_PLAYER_NAME + 1];

enum coreVehicles {
	vehFuel,
	vehWindowsDown,
	vehTemporary,
	vehLoads,
	vehLoadType,
	vehCrate,
	vehTrash,
	vehRepairing,
	vehSirenOn,
	vehSirenObject,
	vehRadio,
	vehURL[128 char],
	Float:vehLoadHealth,
 	Float:vehLoadPos[3]
};
new CoreVehicles[MAX_VEHICLES][coreVehicles];

stock const g_aWeatherRotations[] = {
	14, 1, 7, 3, 5, 12, 15
};

enum e_InventoryItems {
	e_InventoryItem[32],
	e_InventoryModel
};

new const g_aInventoryItems[][e_InventoryItems] = {
	{"Marijuana", 1578},
	{"Cocaine", 1575},
	{"Heroin", 1577},
	{"Steroids", 1241},
	{"Graine marijuana", 1578},
	{"Graine cocaine", 1575},
	{"Graine Heroin Opium", 1577},
	{"Golf Club", 333},
	{"Couteau", 335},
	{"Pelle", 337},
	{"Katana", 339},
	{"Colt 45", 346},
	{"Desert Eagle", 348},
	{"Micro SMG", 352},
	{"Tec-9", 372},
	{"MP5", 353},
	{"Shotgun", 349},
	{"Spas-12", 351},
	{"AK-47", 355},
	{"M4",356},
	{"chainsaw",341},
	{"Sawn Off",350},
	{"Rifle", 357},
	{"Sniper", 358},
	{"Chargeur", 19995},
	{"Boite de matos", 2040},
	{"Burger cuit", 2703},
	{"Pizza cuite", 2702},
	{"permis de conduire", 1581},
	{"License arme", 19792},
	{"Telephone", 330},
	{"Systeme GPS", 18875},
	{"Bombe de peinture", 365},
	{"eau", 2958},
	{"Soda", 1543},
    {"Jerrican", 1650},
	{"Pied de biche", 18634},
	{"Boombox", 2226},
	{"Masque", 19036},
	{"Trousse de soin", 1580},
	{"Boite a outils", 19921},
	{"Bonbonne de NOS", 1010},
	{"Pizza surgele", 2814},
	{"Burger surgele", 2768},
	{"Munition", 2358},
	{"Gilet par balles", 19142},
	{"Bouteille vide", 1484},
	{"Boite de carton", 928},
	{"Poulet", 2663},
	{"Talkie-Walkie", 18868},
	{"Dynamite",1654},
	{"Decodeur",2886},
	{"Cocktail Molotov",344},
	{"Chargeur telephone",19087},
	{"alcool",1486},
	{"camera",19623},
	{"Tournevis",18644},
	{"briquet",19998},
	{"paquet de cigarette ck",19897},
	{"paquet de cigarette cs",19896},
	{"cigarette",19625},
	{"Menottes",19418},
	{"Clef de maison",11746},
	{"Clef de vehicule",11746},
	{"Clef de magasin",11746},
	{"poisson",19630},
	{"canne a peche",18632},
	{"jambon cuit",19847},
	{"kebab",2769},
	{"jambon",2804},
	{"orange",19574},
	{"jus de pomme",19564},
	{"jus dorange",19563},
	{"donuts",2222},
	{"des",1851},
	{"carte de quelque chose",19792},
	{"argent sale",1212},
	{"gold bar",19941},
	{"montre en or",19039},
	{"roche",905},
	{"Permis de chasse",19792},
	{"cafe",19835},
	{"piece de Sawn Off-1",2034},
	{"piece de Sawn Off-2",2033},
	{"douille de shotgun",2038},
	{"sandwich au poulet",2880},
	{"pain",19579},
	{"tranche de pain",19883},
	{"steak cru",19882},
	{"steak cuit",19882},
	{"sandwich a la viande",2880},
	{"sandwich au jambon",2880}
	
};
/*new const Float:arrHospitalDeliver[2][3] = { //vc
    {1866.9421,-1930.9034,4.9235},
    {1129.1644,-1415.9628,5.5596}
};

new const Float:arrHospitalSpawns[2][4] = {
	{1860.8811,-1931.9686,4.9228,103.7289},
	{1112.8402,-1420.6786,7.5683,81.7151}
};*/
new const Float:arrHospitalDeliver[6][3] = { //autre
    {-2692.6580, 635.4608, 14.4531},
    {-334.9757, 1063.0171, 19.7392},
	{1579.9666, 1767.1462, 10.8203},
	{1177.8599, -1308.3982, 13.8301},
	{2024.4246, -1404.1580, 17.2020},
	{1243.9304, 331.4186, 19.5547}
};

new const Float:arrHospitalSpawns[6][4] = {
	{-2655.1240, 638.6232, 14.4531, 180.0000},
	{-318.8799, 1049.2433, 20.3403, 0.0000},
	{1607.4869, 1816.0693, 10.8203, 0.0000},
	{1172.8372, -1325.3186, 15.4000, 270.0000},
	{2034.0670, -1402.6815, 17.2938, 180.0000},
	{1241.6802, 326.4038, 19.7555, 335.0000}
};
new const Float:g_arrWeaponDamage[] = {
	1.32, 1.32, 4.62, 4.62, 2.64, 4.62, 4.62, 4.62, 2.64, 13.53,
	4.62, 2.64, 4.62, 2.64, 4.62, 2.64, 0.00, 0.00, 0.00, 0.00,
	0.00, 0.00, 8.25, 13.2, 46.2, 49.5, 49.5, 39.6, 6.60, 8.25,
	9.90, 9.90, 6.60, 24.75, 41.25, 0.00, 0.00, 0.00, 46.2, 0.00,
	0.00, 2.64, 2.64, 0.00, 0.00, 0.00, 1.32
};

new const g_aWeaponSlots[] = {
	0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, 0, 0, 0, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11
};

new const g_aPreloadLibs[][] =
{
	"AIRPORT",      "ATTRACTORS",   "BAR",          "BASEBALL",     "BD_FIRE",
	"BEACH",        "BENCHPRESS",   "BF_INJECTION", "BIKE_DBZ",     "BIKED",
	"BIKEH",        "BIKELEAP",     "BIKES",        "BIKEV",        "BLOWJOBZ",
	"BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
	"BUS",          "CAMERA",       "CAR",          "CAR_CHAT",     "CARRY",
	"CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
	"COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
	"DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
	"DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
	"FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
	"FLOWERS",      "FOOD",         "FREEWEIGHTS",  "GANGS",        "GFUNK",
	"GHANDS",       "GHETTO_DB",    "GOGGLES",      "GRAFFITI",     "GRAVEYARD",
	"GRENADE",      "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",
	"INT_OFFICE",   "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",
	"KNIFE",        "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",
	"MD_CHASE",     "MD_END",       "MEDIC",        "MISC",         "MTB",
	"MUSCULAR",     "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",
	"PARK",         "PAULNMAC",     "PED",          "PLAYER_DVBYS", "PLAYIDLES",
	"POLICE",       "POOL",         "POOR",         "PYTHON",       "QUAD",
	"QUAD_DBZ",     "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",
	"ROCKET",       "RUNNINGMAN",   "RUSTLER",      "RYDER",        "SCRATCHING",
	"SEX",          "SHAMAL",       "SHOP",         "SHOTGUN",      "SILENCED",
	"SKATE",        "SMOKING",      "SNIPER",       "SNM",          "SPRAYCAN",
	"STRIP",        "SUNBATHE",     "SWAT",         "SWEET",        "SWIM",
	"SWORD",        "TANK",         "TATTOOS",      "TEC",          "TRAIN",
	"TRUCK",        "UZI",          "VAN",          "VENDING",      "VORTEX",
	"WAYFARER",     "WEAPONS",      "WOP",          "WUZI"
};

enum houseInteriors {
	eHouseInterior,
	Float:eHouseX,
	Float:eHouseY,
	Float:eHouseZ,
	Float:eHouseAngle
};

new const Float:arrHouseInteriors[16][houseInteriors] = {
	{12,-17.7247,1493.8525,994.3759,0.0},	
	{10,1364.9424,-807.2983,1090.8774,0.0},
	{3,321.1324,1933.6772,900.9559,0.0},	
	{4,1901.4923,-1853.2520,1501.5160,0.0},
	{1,2478.8179,-1675.4286,599.3259,0.0},
	{3,324.4288,-1579.0096,1010.1469,0.0},
	{7,41.1230, -61.8689, 1107.7460,0.0},
	{13,1958.5941, -289.7225, 4846.3477,0.0},
	{16,1497.8046, -1721.1125, 1361.9089,0.0},
	{10,-35.6880, -98.1513, 1078.0999,0.0},
	{6,2448.8196, -1763.2864, 977.0966,0.0},
	{1,-2294.8784, 364.7219, -86.4309,0.0},
	{1,-317.7882, 837.7614, 601.3861,0.0},
	{1,2511.8999, -1729.8052, 778.1525,0.0},
	{5,248.0204, -1848.2983, 3332.9683,0.0},
	{1,2334.9458, -1047.7510,1043.7659,0.0}
};

new const Float:arrBoothPositions[MAX_BOOTHS][3] = {
    {300.5000, -138.5660, 1004.0625},
	{300.5000, -137.0286, 1004.0625},
	{300.5000, -135.5336, 1004.0625},
	{300.5000, -134.0436, 1004.0625},
	{300.5000, -132.5637, 1004.0625},
	{300.5000, -131.0782, 1004.0625},
	{300.5000, -129.5582, 1004.0625},
	{300.5000, -128.0786, 1004.0625}
};

new stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

enum e_InteriorData {
	e_InteriorName[32],
	e_InteriorID,
	Float:e_InteriorX,
	Float:e_InteriorY,
	Float:e_InteriorZ
};

new const g_arrInteriorData[][e_InteriorData] = {
	{"LS Gym", 5, 772.111999, -3.898649, 1000.728820},
    {"SF Gym", 6, 774.213989, -48.924297, 1000.585937},
    {"LV Gym", 7, 773.579956, -77.096694, 1000.655029},
	{"Ammunation Custom", 10,-317.4820, 1477.0231, 1084.5541},
	{"Gym + Autre", 5,441.0187, 129.5129, 1008.2059},
	{"City Hall", 15,292.2256, 1876.7339, 907.3895},
	{"Petit appartement luxe", 12,-17.7247,1493.8525,994.3759},	
	{"Petit studio", 10,1364.9424,-807.2983,1090.8774},
	{"Petit studio x2", 3,321.1324,1933.6772,900.9559},	
	{"Appartement", 4,1901.4923,-1853.2520,1501.5160},
	{"Appartement x2", 1,2478.8179,-1675.4286,599.3259},
	{"Appartement x3 grand", 3,324.4288,-1579.0096,1010.1469},
	{"Appartement Brun", 7,41.123001098633, -61.868999481201, 1107.7460205078},
	{"Appartement Gris", 13,1958.5941, -289.7225, 4846.3477},
	{"Warehouse", 19,1620.6233, -3557.1165, 1394.0111},
	{"Maison", 16,1497.8046, -1721.1125, 1361.9089},
	{"Auto École", 13,-404.5512, -109.4231, 1278.4432},
	{"Maison 2", 10,-35.6880, -98.1513, 1078.0999},
	{"Église", 1,-1991.9131, 1118.6000, 457.4883},
	{"Auto École 2", 3,862.9678, 4584.6729, 362.9966},
	{"City Hall 2", 0,1467.4575,-1726.5452,1052.5127},
	{"Maison 3", 6,2448.8196, -1763.2864, -77.0966},
	{"HLM étage 1", 6,1394.8495, -1586.3341, 1087.7266},
	{"HLM étage 2", 7,1348.3359, -1587.1244, 1097.6431},
	{"Boucherie", 1,963.9811, 2107.9419, 1011.4445},
	{"Usine", 2,2570.1716, -1301.7283, 1044.1682},
	{"Generateur", 17,-959.5922,1952.5701,9.0000},
	{"Electricien", 1,813.7492, -69.8948, 1001.0178},
	{"Appartement 1 chambre", 1,-2294.8784, 364.7219, -86.4309},
	{"Anpe2", 1,317.0559, 119.6714, 1011.8937},
	{"Camioneur",10,370.1430, -98.5499, 1001.38408},
	{"trafic arme", 1,2606.1594, -1233.1519, 1022.2629},
	{"Usine",2,2477.0940, -1638.7336, 1007.9998},
	{"Casino2",3,-251.9572, -21.1579, 1004.6884},
	{"Mairie2",10,-1821.6859,43.7851,1445.9305},
	{"Taxi", 1,-1971.7341, -897.5184, 758.2221},
	{"maison 3 pieces", 1,-317.7882, 837.7614, 601.3861},
	{"Caravan FIX", 1,2511.8999, -1729.8052, 778.1525},
	{"Maison modern",5,248.0204, -1848.2983, 3332.9683},
	{"Mairie cool",1,-501.2894, 286.9146, 2000.7405},
	{"Trailer park boys",1,2334.9458, -1047.7510,1043.7659},
	{"Pompier",1,361.2743, 878.6762, 1033.5049},
	{"Bureau Moderne",5,1543.1100,-1355.8649,226.4853},
	{"WareHouse",10,1471.0497, -520.2286, 992.0684}
};

/*new const Float:g_arrDrivingCheckpoints[][] = { //version vc
	{838.4772, -1857.6447, 9.3189},
	{808.1030, -1856.6355, 9.3118},
	{765.4256, -1731.1732, 9.1473},
	{744.7988, -1639.2249, 9.1472},
	{653.5010, -1507.5724, 2.3447},
	{232.6170, -1507.7679, 2.2152},
	{217.1171, -1638.9281, 9.1409},
	{467.4848, -1643.9578, 9.1449},
	{729.2664, -1642.9778, 9.1447},
	{739.4445, -1712.5991, 9.1445},
	{795.0760, -1830.1807, 9.1452},
	{1089.0588, -2026.2975, 9.1467},
	{1192.2772, -1987.6564, 5.3570},
	{1190.0566, -1603.3804, 5.3528},
	{1161.1075, -1238.3096, 5.3565},
	{1293.3932, -666.3306, 5.3620},
	{1202.4142, -640.2392, 5.6341},
	{1164.1431, -735.5897, 3.7634},
	{1081.6809, -780.5712, 3.6574},
	{984.4327, -772.9549, 5.6455},
	{928.3727, -938.7454, 5.7214},
	{1010.5467, -991.5014, 4.9613},
	{1013.3333, -1086.2922, 5.5397},
	{1018.4999, -1221.3152, 5.0193},
	{966.8968, -1277.5364, 5.1267},
	{994.7571, -1392.4344, 5.2286},
	{1121.5922, -1393.3153, 5.7595},
	{1164.6766, -1588.7415, 5.3739},
	{1031.8920, -1611.9347, 5.6738},
	{866.6468, -1635.4377, 6.0601},
	{1087.5450, -2022.9705, 9.1502},
	{1045.2740, -2265.2505, 6.3425},
	{1205.3615, -2339.0530, 5.7114},
	{1176.9789, -2008.2104, 5.3789},
	{1089.3822, -2022.6223, 9.1517},
	{892.3224, -2025.4310, 9.1488},
	{801.0313, -1972.5394, 9.1452},
	{809.7178, -1858.3007, 9.3227},
	{841.6575, -1855.1837, 9.3135},
	{843.7513, -1854.9791, 9.3216}
};*/
new const Float:g_arrDrivingCheckpoints[][] = { //version autre
    {-2064.9561, -67.7125, 34.8247},
    {-2110.5261, -67.8857, 34.8247},
    {-2154.2473, -67.6854, 34.8231},
    {-2169.3850, -82.5202, 34.8302},
    {-2169.8767, -114.5743, 34.8188},
    {-2170.6482, -162.7804, 34.8249},
    {-2215.5796, -187.5162, 34.8745},
    {-2244.0376, -187.6771, 34.8235},
    {-2259.1860, -202.9163, 34.9007},
    {-2259.7864, -253.0544, 39.7875},
    {-2260.3638, -300.5378, 48.1640},
    {-2259.5361, -339.2552, 50.5190},
    {-2258.4385, -371.1333, 50.5193},
    {-2236.2454, -416.2657, 50.5155},
    {-2195.2356, -459.0606, 49.3517},
    {-2155.1711, -497.7458, 41.1217},
    {-2117.1301, -536.1792, 34.2394},
    {-2059.1565, -577.5410, 29.0998},
    {-1984.6453, -582.2720, 25.5633},
    {-1925.5862, -583.2345, 24.0926},
    {-1885.5591, -583.6432, 24.0940},
    {-1821.1207, -583.9514, 15.9855},
    {-1816.3672, -559.6774, 15.8619},
    {-1821.3180, -527.9517, 14.6263},
    {-1819.6934, -462.3056, 14.6151},
    {-1809.8923, -396.5690, 16.1884},
    {-1798.9331, -317.3351, 24.3122},
    {-1796.9186, -239.6917, 17.8804},
    {-1797.0546, -168.9667, 9.4126},
    {-1797.6467, -125.6053, 5.1712},
    {-1811.8171, -114.1203, 5.1504},
    {-1841.5179, -114.4944, 5.1483},
    {-1882.5660, -106.9792, 14.5634},
    {-1911.3077, -79.0253, 24.6949},
    {-1938.0209, -62.3110, 25.2069},
    {-1975.7996, -64.1764, 27.7167},
    {-2014.0769, -67.5033, 34.8182},
    {-2040.5736, -67.4500, 34.8250},
    {-2046.2883, -84.8129, 34.8103},
    {-2068.5259, -84.6942, 34.8201}
};
new const Float:g_arrPrisonSpawns[][] = {
	{1217.8539,-1344.5790,796.7456,90.0000},
    {1217.8678,-1341.3213,796.7456,90.0000},
    {1217.2465,-1337.8044,796.7456,90.0000},
    {1217.9287,-1334.7639,796.7456,90.0000},
    {1217.8746,-1331.4298,796.7456,90.0000},
    {1217.5286,-1328.4138,796.7456,90.0000},
    {1202.8230,-1327.8770,796.7505,270.0000},
    {1203.4220,-1331.0464,796.7505,270.0000},
    {1203.0822,-1334.2010,796.7505,270.0000},
    {1203.3068,-1337.5503,796.7505,270.0000},
    {1203.2917,-1340.3719,796.7505,270.0000},
    {1203.1689,-1343.8762,796.7505,270.0000},
    {1203.0190,-1343.8212,800.2859,270.0000},
    {1203.1254,-1340.6129,800.2859,270.0000},
    {1203.5780,-1337.3750,800.2859,270.0000},
    {1203.7159,-1334.1960,800.2859,270.0000},
    {1203.6014,-1331.0227,800.2859,270.0000},
    {1203.2318,-1327.8788,800.2859,270.0000},
    {1217.8292,-1328.4882,800.2859,90.0000},
    {1217.6486,-1331.5758,800.2859,90.0000},
    {1217.9084,-1335.0168,800.2859,90.0000},
    {1217.6915,-1338.0559,800.2859,90.0000},
    {1217.5966,-1341.0157,800.2859,90.0000},
    {1217.3633,-1344.3766,800.2859,90.0000}
};

new const g_aLegalMods[][] = {
    {400, 1024, 1021, 1020, 1019, 1018, 1013, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {401, 1145, 1144, 1143, 1142, 1020, 1019, 1017, 1013, 1007, 1006, 1005, 1004, 1003, 1001, 0000, 0000, 0000, 0000},
    {404, 1021, 1020, 1019, 1017, 1016, 1013, 1007, 1002, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {405, 1023, 1021, 1020, 1019, 1018, 1014, 1001, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {410, 1024, 1023, 1021, 1020, 1019, 1017, 1013, 1007, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {415, 1023, 1019, 1018, 1017, 1007, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {418, 1021, 1020, 1016, 1006, 1002, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {420, 1021, 1019, 1005, 1004, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {421, 1023, 1021, 1020, 1019, 1018, 1016, 1014, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {422, 1021, 1020, 1019, 1017, 1013, 1007, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {426, 1021, 1019, 1006, 1005, 1004, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {436, 1022, 1021, 1020, 1019, 1017, 1013, 1007, 1006, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {439, 1145, 1144, 1143, 1142, 1023, 1017, 1013, 1007, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {477, 1021, 1020, 1019, 1018, 1017, 1007, 1006, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {478, 1024, 1022, 1021, 1020, 1013, 1012, 1005, 1004, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {489, 1024, 1020, 1019, 1018, 1016, 1013, 1006, 1005, 1004, 1002, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {491, 1145, 1144, 1143, 1142, 1023, 1021, 1020, 1019, 1018, 1017, 1014, 1007, 1003, 0000, 0000, 0000, 0000, 0000},
    {492, 1016, 1006, 1005, 1004, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {496, 1143, 1142, 1023, 1020, 1019, 1017, 1011, 1007, 1006, 1003, 1002, 1001, 0000, 0000, 0000, 0000, 0000, 0000},
    {500, 1024, 1021, 1020, 1019, 1013, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {516, 1021, 1020, 1019, 1018, 1017, 1016, 1015, 1007, 1004, 1002, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {517, 1145, 1144, 1143, 1142, 1023, 1020, 1019, 1018, 1017, 1016, 1007, 1003, 1002, 0000, 0000, 0000, 0000, 0000},
    {518, 1145, 1144, 1143, 1142, 1023, 1020, 1018, 1017, 1013, 1007, 1006, 1005, 1003, 1001, 0000, 0000, 0000, 0000},
    {527, 1021, 1020, 1018, 1017, 1015, 1014, 1007, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {529, 1023, 1020, 1019, 1018, 1017, 1012, 1011, 1007, 1006, 1003, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {534, 1185, 1180, 1179, 1178, 1127, 1126, 1125, 1124, 1123, 1122, 1106, 1101, 1100, 0000, 0000, 0000, 0000, 0000},
    {535, 1121, 1120, 1119, 1118, 1117, 1116, 1115, 1114, 1113, 1110, 1109, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {536, 1184, 1183, 1182, 1181, 1128, 1108, 1107, 1105, 1104, 1103, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {540, 1145, 1144, 1143, 1142, 1024, 1023, 1020, 1019, 1018, 1017, 1007, 1006, 1004, 1001, 0000, 0000, 0000, 0000},
    {542, 1145, 1144, 1021, 1020, 1019, 1018, 1015, 1014, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {546, 1145, 1144, 1143, 1142, 1024, 1023, 1019, 1018, 1017, 1007, 1006, 1004, 1002, 1001, 0000, 0000, 0000, 0000},
    {547, 1143, 1142, 1021, 1020, 1019, 1018, 1016, 1003, 1000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {549, 1145, 1144, 1143, 1142, 1023, 1020, 1019, 1018, 1017, 1012, 1011, 1007, 1003, 1001, 0000, 0000, 0000, 0000},
    {550, 1145, 1144, 1143, 1142, 1023, 1020, 1019, 1018, 1006, 1005, 1004, 1003, 1001, 0000, 0000, 0000, 0000, 0000},
    {551, 1023, 1021, 1020, 1019, 1018, 1016, 1006, 1005, 1003, 1002, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {558, 1168, 1167, 1166, 1165, 1164, 1163, 1095, 1094, 1093, 1092, 1091, 1090, 1089, 1088, 0000, 0000, 0000, 0000},
    {559, 1173, 1162, 1161, 1160, 1159, 1158, 1072, 1071, 1070, 1069, 1068, 1067, 1066, 1065, 0000, 0000, 0000, 0000},
    {560, 1170, 1169, 1141, 1140, 1139, 1138, 1033, 1032, 1031, 1030, 1029, 1028, 1027, 1026, 0000, 0000, 0000, 0000},
    {561, 1157, 1156, 1155, 1154, 1064, 1063, 1062, 1061, 1060, 1059, 1058, 1057, 1056, 1055, 1031, 1030, 1027, 1026},
    {562, 1172, 1171, 1149, 1148, 1147, 1146, 1041, 1040, 1039, 1038, 1037, 1036, 1035, 1034, 0000, 0000, 0000, 0000},
    {565, 1153, 1152, 1151, 1150, 1054, 1053, 1052, 1051, 1050, 1049, 1048, 1047, 1046, 1045, 0000, 0000, 0000, 0000},
    {567, 1189, 1188, 1187, 1186, 1133, 1132, 1131, 1130, 1129, 1102, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {575, 1177, 1176, 1175, 1174, 1099, 1044, 1043, 1042, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {576, 1193, 1192, 1191, 1190, 1137, 1136, 1135, 1134, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {580, 1023, 1020, 1018, 1017, 1007, 1006, 1001, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {589, 1145, 1144, 1024, 1020, 1018, 1017, 1016, 1013, 1007, 1006, 1005, 1004, 1000, 0000, 0000, 0000, 0000, 0000},
    {600, 1022, 1020, 1018, 1017, 1013, 1007, 1006, 1005, 1004, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000, 0000},
    {603, 1145, 1144, 1143, 1142, 1024, 1023, 1020, 1019, 1018, 1017, 1007, 1006, 1001, 0000, 0000, 0000, 0000, 0000}
};
new g_aMaleSkins[188] = {
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	30, 32, 33, 34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60,
	61, 62, 66, 68, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102,
	103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
	121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146,
	147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170, 171, 173, 174, 175, 176,
	177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 200, 202, 203, 204, 206,
	208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240,
	241, 242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289,
	290, 291, 292, 293, 294, 295, 296, 297, 299, 303, 304, 305//10
};
new g_aFemaleSkins[77] = {
    9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69,
    75, 76, 77, 85, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 141,
    145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195,
    196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225,
    226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263,
    298
};
enum e_FurnitureData {
	e_FurnitureType,
	e_FurnitureName[32],
	e_FurnitureModel
};

new const g_aFurnitureTypes[][] = {
	{"Cadres"},
	{"Tables"},
	{"Chaisse"},
	{"Lits"},
	{"Armoires"},
	{"Television"},
	{"Cuisine"},
	{"Salle de bains"},
	{"Mobilier divers"}
};

new const g_aFurnitureData[][e_FurnitureData] = {
	{1, "Cadres 1", 2289},
	{1, "Cadres 2", 2288},
	{1, "Cadres 3", 2287},
	{1, "Cadres 4", 2286},
	{1, "Cadres 5", 2285},
	{1, "Cadres 6", 2284},
    {1, "Cadres 7", 2283},
    {1, "Cadres 8", 2282},
    {1, "Cadres 9", 2281},
    {1, "Cadres 10", 2280},
    {1, "Cadres 11", 2279},
	{1, "Cadres 12", 2278},
	{1, "Cadres 13", 2277},
	{1, "Cadres 14", 2276},
	{1, "Cadres 15", 2275},
	{1, "Cadres 16", 2274},
    {1, "Cadres 17", 2273},
    {1, "Cadres 18", 2272},
    {1, "Cadres 19", 2271},
    {1, "Cadres 20", 2270},
    {2, "Table 1", 1433},
	{2, "Table 2", 1998},
	{2, "Table 3", 2008},
	{2, "Table 4", 2180},
	{2, "Table 5", 2185},
    {2, "Table 6", 2205},
    {2, "Table 7", 2314},
    {2, "Table 8", 2635},
    {2, "Table 9", 2637},
    {2, "Table 10", 2644},
	{2, "Table 11", 2747},
	{2, "Table 12", 2764},
	{2, "Table 13", 2763},
	{2, "Table 14", 2762},
	{2, "Table 15", 936},
	{2, "Table 16", 937},
	{2, "Table 17", 941},
	{2, "Table 18", 2115},
	{2, "Table 19", 2116},
	{2, "Table 20", 2112},
	{2, "Table 21", 2111},
	{2, "Table 22", 2110},
	{2, "Table 23", 2109},
	{2, "Table 24", 2085},
	{2, "Table 25", 2032},
	{2, "Table 26", 2031},
	{2, "Table 27", 2030},
	{2, "Table 28", 2029},
    {3, "Chaisse 1", 1671},
    {3, "Chaisse 2", 1704},
    {3, "Chaisse 3", 1705},
    {3, "Chaisse 4", 1708},
    {3, "Chaisse 5", 1711},
    {3, "Chaisse 6", 1715},
    {3, "Chaisse 7", 1721},
    {3, "Chaisse 8", 1724},
    {3, "Chaisse 9", 1727},
    {3, "Chaisse 10", 1729},
    {3, "Chaisse 11", 1735},
    {3, "Chaisse 12", 1739},
    {3, "Chaisse 13", 1805},
    {3, "Chaisse 14", 1806},
    {3, "Chaisse 15", 1810},
    {3, "Chaisse 16", 1811},
    {3, "Chaisse 17", 2079},
    {3, "Chaisse 18", 2120},
    {3, "Chaisse 19", 2124},
    {3, "Chaisse 20", 2356},
    {3, "Chaisse 21", 1768},
    {3, "Chaisse 22", 1766},
    {3, "Chaisse 23", 1764},
    {3, "Chaisse 24", 1763},
    {3, "Chaisse 25", 1761},
    {3, "Chaisse 26", 1760},
    {3, "Chaisse 27", 1757},
    {3, "Chaisse 28", 1756},
    {3, "Chaisse 29", 1753},
    {3, "Chaisse 30", 1713},
    {3, "Chaisse 31", 1712},
    {3, "Chaisse 32", 1706},
    {3, "Chaisse 33", 1703},
    {3, "Chaisse 34", 1702},
    {3, "Chaisse 35", 1754},
    {3, "Chaisse 36", 1755},
    {3, "Chaisse 37", 1758},
    {3, "Chaisse 38", 1759},
    {3, "Chaisse 39", 1762},
    {3, "Chaisse 40", 1765},
    {3, "Chaisse 41", 1767},
    {3, "Chaisse 42", 1769},
	{4, "Lits 1", 1700},
	{4, "Lits 2", 1701},
	{4, "Lits 3", 1725},
	{4, "Lits 4", 1745},
	{4, "Lits 5", 1793},
	{4, "Lits 6", 1794},
	{4, "Lits 7", 1795},
	{4, "Lits 8", 1796},
	{4, "Lits 9", 1797},
	{4, "Lits 10", 1771},
	{4, "Lits 11", 1798},
	{4, "Lits 12", 1799},
    {4, "Lits 13", 1800},
    {4, "Lits 14", 1801},
    {4, "Lits 15", 1802},
    {4, "Lits 16", 1812},
    {4, "Lits 17", 2090},
    {4, "Lits 18", 2299},
    {5, "Armoires 1", 1416},
	{5, "Armoires 2", 1417},
	{5, "Armoires 3", 1741},
	{5, "Armoires 4", 1742},
	{5, "Armoires 5", 1743},
	{5, "Armoires 6", 2025},
	{5, "Armoires 7", 2065},
	{5, "Armoires 8", 2066},
	{5, "Armoires 9", 2067},
	{5, "Armoires 10", 2087},
    {5, "Armoires 11", 2088},
    {5, "Armoires 12", 2094},
    {5, "Armoires 13", 2095},
    {5, "Armoires 14", 2306},
    {5, "Armoires 15", 2307},
	{5, "Armoires 16", 2323},
	{5, "Armoires 17", 2328},
	{5, "Armoires 18", 2329},
	{5, "Armoires 19", 2330},
	{5, "Armoires 20", 2708},
	{6, "Television 1", 1518},
	{6, "Television 2", 1717},
	{6, "Television 3", 1747},
	{6, "Television 4", 1748},
	{6, "Television 5", 1749},
	{6, "Television 6", 1750},
	{6, "Television 7", 1752},
	{6, "Television 8", 1781},
	{6, "Television 9", 1791},
	{6, "Television 10", 1792},
    {6, "Television 11", 2312},
	{6, "Television 12", 2316},
	{6, "Television 13", 2317},
	{6, "Television 14", 2318},
	{6, "Television 15", 2320},
	{6, "Television 16", 2595},
	{6, "Television 17", 16377},
	{7, "Cuisine 1", 2013},
	{7, "Cuisine 2", 2017},
	{7, "Cuisine 3", 2127},
	{7, "Cuisine 4", 2130},
	{7, "Cuisine 5", 2131},
	{7, "Cuisine 6", 2132},
	{7, "Cuisine 7", 2135},
	{7, "Cuisine 8", 2136},
	{7, "Cuisine 9", 2144},
	{7, "Cuisine 10", 2147},
    {7, "Cuisine 11", 2149},
    {7, "Cuisine 12", 2150},
    {7, "Cuisine 13", 2415},
    {7, "Cuisine 14", 2417},
    {7, "Cuisine 15", 2421},
    {7, "Cuisine 16", 2426},
    {7, "Cuisine 17", 2014},
    {7, "Cuisine 18", 2015},
    {7, "Cuisine 19", 2016},
    {7, "Cuisine 20", 2018},
    {7, "Cuisine 21", 2019},
    {7, "Cuisine 22", 2022},
    {7, "Cuisine 23", 2133},
    {7, "Cuisine 24", 2134},
	{7, "Cuisine 25", 2137},
	{7, "Cuisine 26", 2138},
	{7, "Cuisine 27", 2139},
	{7, "Cuisine 28", 2140},
	{7, "Cuisine 29", 2141},
	{7, "Cuisine 30", 2142},
	{7, "Cuisine 31", 2143},
	{7, "Cuisine 32", 2145},
	{7, "Cuisine 33", 2148},
	{7, "Cuisine 34", 2151},
	{7, "Cuisine 35", 2152},
	{7, "Cuisine 36", 2153},
	{7, "Cuisine 37", 2154},
	{7, "Cuisine 38", 2155},
	{7, "Cuisine 39", 2156},
	{7, "Cuisine 40", 2157},
	{7, "Cuisine 41", 2158},
	{7, "Cuisine 42", 2159},
	{7, "Cuisine 43", 2160},
	{7, "Cuisine 44", 2134},
	{7, "Cuisine 45", 2135},
	{7, "Cuisine 46", 2338},
	{7, "Cuisine 47", 2341},
	{8, "Salle de bains 1", 2514},
	{8, "Salle de bains 2", 2516},
	{8, "Salle de bains 3", 2517},
	{8, "Salle de bains 4", 2518},
	{8, "Salle de bains 5", 2520},
	{8, "Salle de bains 6", 2521},
	{8, "Salle de bains 7", 2522},
	{8, "Salle de bains 8", 2523},
	{8, "Salle de bains 9", 2524},
	{8, "Salle de bains 10", 2525},
    {8, "Salle de bains 11", 2526},
    {8, "Salle de bains 12", 2527},
    {8, "Salle de bains 13", 2528},
    {8, "Salle de bains 14", 2738},
    {8, "Salle de bains 15", 2739},
	{9, "Machine a laver", 1208},
	{9, "Ventilateur", 1661},
	{9, "Tete orignial", 1736},
	{9, "Radiateur", 1738},
	{9, "Balais et seau", 1778},
	{9, "Refroidisseur eau", 1808},
	{9, "Refroidisseur eau 2", 2002},
	{9, "Coffre fort", 1829},
	{9, "Imprimante", 2186},
	{9, "Ordinateur", 2190},
	{9, "Tapis de course", 2627},
	{9, "Banc de musculation", 2629},
	{9, "Velo exercise", 2630},
	{9, "Tapis entrainement 1", 2631},
	{9, "Tapis entrainement 2", 2632},
	{9, "Tapis entrainement 3", 2817},
	{9, "Tapis entrainement 4", 2818},
	{9, "Tapis entrainement 5", 2833},
	{9, "Tapis entrainement 6", 2834},
	{9, "Tapis entrainement 7", 2835},
	{9, "Tapis entrainement 8", 2836},
	{9, "Tapis entrainement 9", 2841},
	{9, "Tapis entrainement 10", 2842},
	{9, "Tapis entrainement 11", 2847},
	{9, "Pile du livre 1", 2824},
	{9, "Pile du livre 2", 2826},
	{9, "Pile du livre 3", 2827},
	{9, "Basketball", 2114},
	{9, "Lampe 1", 2108},
	{9, "Lampe 2", 2106},
	{9, "Lampe 3", 2069},
	{9, "Petit mobilier 1", 2569},
	{9, "Petit mobilier 2", 2570},
	{9, "Petit mobilier 3", 2573},
	{9, "Petit mobilier 4", 2574},
	{9, "Petit mobilier 5", 2576},
	{9, "Livre", 2894},
	{9, "Vitre",19466},
	{9, "Table de poker",19474}
};
new zone1,zone2,zone3,zone4;
//job meuble
new Mueble[MAX_PLAYERS];
new MueblesCreados[MAX_PLAYERS];
//new Text3D:carpintero;
new ObjetoIDs[]={1814,1817,2082};
new Cantidad = 100;
new SkinAntes[MAX_PLAYERS];
//banque entreprise
enum afinfo
{
	argentid,
	argentpolice,
	argentfbi,
	argentswat,
	argentmedecin,
	argentpompier,
	argentmairie,
	argentjournaliste,
	argentmecanozone3,
	argentmecanozone4,
	argentmafiazone1,
	argentmafiazone4,
	argentcamionneur,
	argentconvoyeur,
	argentfermier,
	argentvendeur,
	argentpilote,
	argentbanque,
	argentcourier
}
new argent_entreprise[MAX_PLAYERS][afinfo];
//camera helico
new objectIDs[MAX_VEHICLES];
new Text:crosshair[MAX_PLAYERS];
new playerveh[MAX_PLAYERS];
//job entreprise coursier
new check[MAX_PLAYERS];
new check2[MAX_PLAYERS];
new check3[MAX_PLAYERS];
new check4[MAX_PLAYERS];
new check5[MAX_PLAYERS];
new check8[MAX_PLAYERS];
new check9[MAX_PLAYERS];
new check10[MAX_PLAYERS];
new check11[MAX_PLAYERS];
new check12[MAX_PLAYERS];
new check13[MAX_PLAYERS];
new check14[MAX_PLAYERS];
//gouvernement
enum gouvernementinfo
{
	gouvernementidd,
	gouvernementtaxe,
	gouvernementtaxerevenue,
	gouvernementtaxeentreprise,
	gouvernementchomage,
	gouvernementsubventionpolice,
	gouvernementsubventionfbi,
	gouvernementsubventionswat,
	gouvernementsubventionmedecin,
	gouvernementaidebanque,
	gouvernementbizhouse,
	gouvernementhouse,
	gouvernementbiz
}
new info_gouvernementinfo[MAX_PLAYERS][gouvernementinfo];
//salaire rank
/*
enum salairerang
{
	factioniddd,	
	salairerang1,
	salairerang2,
	salairerang3,
	salairerang4,
	salairerang5,
	salairerang6,
	salairerang7,
	salairerang8,
	salairerang9,
	salairerang10,
	salairerang11,
	salairerang12,
	salairerang13,
	salairerang14,
	salairerang15
}
new info_salairerang[MAX_FACTIONS][salairerang];*/
//cv des entreprise
enum cvfbii
{
	cvid,
	pseudo[32],
	origine[32],
	telephone,
	naissance[24],
	sexe
}
new info_fbicv[MAX_FACTIONS][cvfbii];
enum cvjournaliste
{
	cvjournalisteidd,
	cvjournalistepseudo[32],
	cvjournalistetelephone,
	cvjournalistenaissance[24],
	cvjournalistesexe,
	cvjournalisteorigine[32]
}
new info_cvjournaliste[MAX_FACTIONS][cvjournaliste];
enum cvlivraisonbiz
{
	cvlivraisonbizidd,
	cvlivraisonbizpseudo[32],
	cvlivraisonbiztelephone,
	cvlivraisonbiznaissance[24],
	cvlivraisonbizsexe,
	cvlivraisonbizorigine[32]
}
new info_cvlivraisonbiz[MAX_FACTIONS][cvlivraisonbiz];
enum cvmairie
{
	cvmairieidd,
	cvmairiepseudo[32],
	cvmairietelephone,
	cvmairienaissance[24],
	cvmairiesexe,
	cvmairieorigine[32]
}
new info_cvmairie[MAX_FACTIONS][cvmairie];
enum cvmecanozone3
{
	cvmecanozone3idd,
	cvmecanozone3pseudo[32],
	cvmecanozone3telephone,
	cvmecanozone3naissance[24],
	cvmecanozone3sexe,
	cvmecanozone3origine[32]
}
new info_cvmecanozone3[MAX_FACTIONS][cvmecanozone3];
enum cvmecanozone4
{
	cvmecanozone4idd,
	cvmecanozone4pseudo[32],
	cvmecanozone4telephone,
	cvmecanozone4naissance[24],
	cvmecanozone4sexe,
	cvmecanozone4origine[32]
}
new info_cvmecanozone4[MAX_FACTIONS][cvmecanozone4];
enum cvpolice
{
	cvpoliceidd,
	cvpolicepseudo[32],
	cvpolicetelephone,
	cvpolicenaissance[24],
	cvpolicesexe,
	cvpoliceorigine[32]
}
new info_cvpolice[MAX_FACTIONS][cvpolice];
enum cvswat
{
	cvswatidd,
	cvswatpseudo[32],
	cvswattelephone,
	cvswatnaissance[24],
	cvswatsexe,
	cvswatorigine[32]
}
new info_cvswat[MAX_FACTIONS][cvswat];
enum cvtaxi
{
	cvtaxiidd,
	cvtaxipseudo[32],
	cvtaxitelephone,
	cvtaxinaissance[24],
	cvtaxisexe,
	cvtaxiorigine[32]
}
new info_cvtaxi[MAX_FACTIONS][cvtaxi];
enum cvvendeurrue
{
	cvvendeurrueidd,
	cvvendeurruepseudo[32],
	cvvendeurruetelephone,
	cvvendeurruenaissance[24],
	cvvendeurruesexe,
	cvvendeurrueorigine[32]
}
new info_cvvendeurrue[MAX_FACTIONS][cvvendeurrue];
enum cvurgentiste
{
	cvurgentisteidd,
	cvurgentistepseudo[32],
	cvurgentistetelephone,
	cvurgentistenaissance[24],
	cvurgentistesexe,
	cvurgentisteorigine[32]
}
new info_cvurgentiste[MAX_FACTIONS][cvurgentiste];
//clignotant
new Indicators_xqz[MAX_VEHICLES][6];
//salaire gouve
enum salairemairied
{
	salairemairieiddd,	
	salairemairie1,
	salairemairie2,
	salairemairie3,
	salairemairie4,
	salairemairie5,
	salairemairie6,
	salairemairie7,
	salairemairie8,
	salairemairie9,
	salairemairie10,
	salairemairie11,
	salairemairie12,
	salairemairie13,
	salairemairie14,
	salairemairie15
}
new info_salairemairie[MAX_FACTIONS][salairemairied];
//salaire fbi
enum salairefbid
{
	salairefbiiddd,	
	salairefbi1,
	salairefbi2,
	salairefbi3,
	salairefbi4,
	salairefbi5,
	salairefbi6,
	salairefbi7,
	salairefbi8,
	salairefbi9,
	salairefbi10,
	salairefbi11,
	salairefbi12,
	salairefbi13,
	salairefbi14,
	salairefbi15
}
new info_salairefbi[MAX_FACTIONS][salairefbid];
//salaire journaliste
enum salairejournalisted
{
	salairejournalisteiddd,	
	salairejournaliste1,
	salairejournaliste2,
	salairejournaliste3,
	salairejournaliste4,
	salairejournaliste5,
	salairejournaliste6,
	salairejournaliste7,
	salairejournaliste8,
	salairejournaliste9,
	salairejournaliste10,
	salairejournaliste11,
	salairejournaliste12,
	salairejournaliste13,
	salairejournaliste14,
	salairejournaliste15
}
new info_salairejournaliste[MAX_FACTIONS][salairejournalisted];
enum salairelivreurbizd
{
	salairelivreurbiziddd,	
	salairelivreurbiz1,
	salairelivreurbiz2,
	salairelivreurbiz3,
	salairelivreurbiz4,
	salairelivreurbiz5,
	salairelivreurbiz6,
	salairelivreurbiz7,
	salairelivreurbiz8,
	salairelivreurbiz9,
	salairelivreurbiz10,
	salairelivreurbiz11,
	salairelivreurbiz12,
	salairelivreurbiz13,
	salairelivreurbiz14,
	salairelivreurbiz15
}
new info_salairelivreurbiz[MAX_FACTIONS][salairelivreurbizd];
enum salairepoliced
{
	salairepoliceiddd,	
	salairepolice1,
	salairepolice2,
	salairepolice3,
	salairepolice4,
	salairepolice5,
	salairepolice6,
	salairepolice7,
	salairepolice8,
	salairepolice9,
	salairepolice10,
	salairepolice11,
	salairepolice12,
	salairepolice13,
	salairepolice14,
	salairepolice15
}
new info_salairepolice[MAX_FACTIONS][salairepoliced];
enum salaireswatd
{
	salaireswatiddd,	
	salaireswat1,
	salaireswat2,
	salaireswat3,
	salaireswat4,
	salaireswat5,
	salaireswat6,
	salaireswat7,
	salaireswat8,
	salaireswat9,
	salaireswat10,
	salaireswat11,
	salaireswat12,
	salaireswat13,
	salaireswat14,
	salaireswat15
}
new info_salaireswat[MAX_FACTIONS][salaireswatd];
enum salaireurgentisted
{
	salaireurgentisteiddd,	
	salaireurgentiste1,
	salaireurgentiste2,
	salaireurgentiste3,
	salaireurgentiste4,
	salaireurgentiste5,
	salaireurgentiste6,
	salaireurgentiste7,
	salaireurgentiste8,
	salaireurgentiste9,
	salaireurgentiste10,
	salaireurgentiste11,
	salaireurgentiste12,
	salaireurgentiste13,
	salaireurgentiste14,
	salaireurgentiste15
}
new info_salaireurgentiste[MAX_FACTIONS][salaireurgentisted];
enum salairevendeurrued
{
	salairevendeurrueiddd,	
	salairevendeurrue1,
	salairevendeurrue2,
	salairevendeurrue3,
	salairevendeurrue4,
	salairevendeurrue5,
	salairevendeurrue6,
	salairevendeurrue7,
	salairevendeurrue8,
	salairevendeurrue9,
	salairevendeurrue10,
	salairevendeurrue11,
	salairevendeurrue12,
	salairevendeurrue13,
	salairevendeurrue14,
	salairevendeurrue15
}
new info_salairevendeurrue[MAX_FACTIONS][salairevendeurrued];
enum salairemecano3d
{
	salairemecano3iddd,	
	salairemecano31,
	salairemecano32,
	salairemecano33,
	salairemecano34,
	salairemecano35,
	salairemecano36,
	salairemecano37,
	salairemecano38,
	salairemecano39,
	salairemecano310,
	salairemecano311,
	salairemecano312,
	salairemecano313,
	salairemecano314,
	salairemecano315
}
new info_salairemecano3[MAX_FACTIONS][salairemecano3d];
enum salairemecano4d
{
	salairemecano4iddd,	
	salairemecano41,
	salairemecano42,
	salairemecano43,
	salairemecano44,
	salairemecano45,
	salairemecano46,
	salairemecano47,
	salairemecano48,
	salairemecano49,
	salairemecano410,
	salairemecano411,
	salairemecano412,
	salairemecano413,
	salairemecano414,
	salairemecano415
}
new info_salairemecano4[MAX_FACTIONS][salairemecano4d];
enum salairetaxid
{
	salairetaxiiddd,	
	salairetaxi1,
	salairetaxi2,
	salairetaxi3,
	salairetaxi4,
	salairetaxi5,
	salairetaxi6,
	salairetaxi7,
	salairetaxi8,
	salairetaxi9,
	salairetaxi10,
	salairetaxi11,
	salairetaxi12,
	salairetaxi13,
	salairetaxi14,
	salairetaxi15
}
new info_salairetaxi[MAX_FACTIONS][salairetaxid];
enum salairepetitlivreurd
{
	petitlivreuriddd,	
	petitlivreur1,
	petitlivreur2,
	petitlivreur3,
	petitlivreur4,
	petitlivreur5,
	petitlivreur6,
	petitlivreur7,
	petitlivreur8,
	petitlivreur9,
	petitlivreur10,
	petitlivreur11,
	petitlivreur12,
	petitlivreur13,
	petitlivreur14,
	petitlivreur15
}
new info_salairepetitlivreur[MAX_FACTIONS][salairepetitlivreurd];
//giro mecano
new UCL[MAX_VEHICLES];
new gelblicht1[MAX_VEHICLES];
new gelblicht2[MAX_VEHICLES];
//aidemenu
new Showing[MAX_PLAYERS];
new Text:AideMenu0;
new Text:AideMenu1;
new Text:AideMenu2;
new Text:AideMenu3;
new Text:AideMenu4;
new Text:AideMenu5;
new Text:AideMenu6;
new Text:AideMenu7;
new Text:AideMenu8;
new Text:AideMenu9;
//limitation de vitesse sur un véhicule abimer
new const BE_Bad_Vehs[] = {
460, 464, 476, 511, 512, 513, 519, 520, 539, 553, 577, 592, 593, // planes
417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563 // heli
};
new bool: BE_Play_Check[MAX_PLAYERS];
//Job fab arme
new gunjob;
//Job boucher
new meats[MAX_PLAYERS];// Quantité article
new meatprocces[MAX_PLAYERS];// vérifier Checkpoint
new AnimTimer;// ??????
new PlayerInJob[MAX_PLAYERS];
new OldSkin[MAX_PLAYERS];
//bots
new TotalActors;
enum ainfo
{
    aID,
    aSkinModel,
    Float:aFloat[4],
    Text3D:aLabel,
    aLabelText,
    actorint,
    actorvw,
	actorsetting
}
new ActorInfo[MAXACTORS][ainfo];
//ceinture
new SeatbeltStatus[MAX_PLAYERS]; // Variable qui est va tenir le statut de la ceinture de sécurité.
new Float:CarHealth[MAX_PLAYERS];
//anti bunny
new BunnyHop[MAX_PLAYERS];
//job usine
new Sklad;
new brat[9];
new rabot[11];
new ZavodObj[MAX_PLAYERS];
new Zavod[MAX_PLAYERS];
new ZavodIn[MAX_PLAYERS];
new ZavodIn1[MAX_PLAYERS];
//new killertimerusine;
//job generator
new OnGener[MAX_PLAYERS]; //
new gen1 = 300; // Nombre de combustible dans le générateur au serveur N1.
new gen1m = 0; // Générateur de l'argent Max N1 au démarrage.
new OnGen1 = 0; // 0 - ne sont pas desservis, 1 - est servi.
new Text3D: gen1text; // 3d générateur de texte
new Text3D: gen1money; // 3d argent texte obtenu.
new gen2 = 300;
new gen2m = 0;
new OnGen2 = 0;
new Text3D: gen2text;
new Text3D: gen2money;
new gen3 = 300;
new gen3m = 0;
new OnGen3 = 0;
new Text3D: gen3text;
new Text3D: gen3money;
new gen4 = 300;
new gen4m = 0;
new OnGen4 = 0;
new Text3D: gen4text;
new Text3D: gen4money;
new gen5 = 300;
new gen5m = 0;
new OnGen5 = 0;
new Text3D: gen5text;
new Text3D: gen5money;
new OnBenz[MAX_PLAYERS]; // Max litres de carburant dans le lecteur de cartouche.
new gaspickup; // Pick-up bidons pour le carburant.
new genpickup[5]; // Pick-up générateurs.
//new dambapickup[2]; // Entrée / Sortie (DAM).
new threesecondtimer;
//job petrolier
new forestJobPickUP;
new Float:cForestJob[][3] = {
    {566.6660,1302.2390,11.2688},
    {623.7001,1347.3214,13.1828},
    {589.8292,1337.8979,11.1876},
    {437.6178,1265.3094,9.7191},
    {359.7181,1289.8901,12.5948},
    {377.4219,1330.1702,11.1634},
    {413.4158,1400.4098,8.4903},
    {398.1038,1450.2870,8.4903},
    {497.4951,1385.3673,4.5352},
    {572.7404,1414.1298,11.3772},
    {539.3063,1458.6689,4.9281},
    {594.8780,1488.6691,8.2965},
    {646.0396,1474.8594,9.1250},
    {488.9308,1523.2081,0.9138},
    {438.9430,1553.5026,11.3975},
    {421.0933,1508.3016,11.5126},
    {494.6349,1300.1104,10.0656}
};
//job electicien
new Elektrik[4];
//job doc fortcarson
new port;
new bool:PlayerDok[MAX_PLAYERS];
new doks[][1] = {{0}, {1}, {2}};
//new portdok = 25;
new prod,topl,boe;
//mission
new mission[MAX_PLAYERS];
new missionactor;
new mission1[MAX_PLAYERS];
new missionactor1;
new mission2[MAX_PLAYERS];
new missionactor2;
//stock job
enum stockjobinfo
{
	stockjobinfoidd,
	stockjobinfobois,
	stockjobinfoviande,
	stockjobinfomeuble,
	stockjobinfocentral1,
	stockjobinfocentral2,
	stockjobinfocentral3,
	stockjobinfocentral4,
	stockjobinfocentral5,
	stockjobinfoelectronic,
	stockjobinfopetrol,
	stockjobinfoessencegenerator,
	stockjobinfoboismeuble,
	stockjobinfostockmagasin,
	stockjobinfostockdock,
	stockjobinfostocksorter,
	stockjobinfostockcariste,
	stockjobinfostockminer,
	stockjobinfostockarmes,
	stocktunningfrontbumper,
	stocktunningrearbumper,
	stocktunningroof,
	stocktunninghood,
	stocktunningspoiler,
	stocktunningsideskirt1,
	stocktunningsideskirt2,
	stocktunningwheel,
	stocktunninghydrolic,
	stocktunningroue,
	stocktunningcaro
}
new info_stockjobinfo[MAX_PLAYERS][stockjobinfo];
//slot machine
enum info
{
	iidd,
	created,
	object,
	Float: pospos[6],
	slotint,
	slotvw,
	Text3D: text3d
}
new machine[MAX_MACHINES][info];
new PlayerText:machineTD[4][MAX_PLAYERS];
new TDslots[][] = {
"LD_SLOT:r_69", "LD_SLOT:grapes", "LD_SLOT:cherry",
"LD_SLOT:bell", "LD_SLOT:bar1_o"
};
new repeats[MAX_PLAYERS];
new modelidslot;
new timerslot[MAX_PLAYERS];
//new slots;
//joob livraison
new livraisonjob[MAX_PLAYERS];
new quantiterdejob[MAX_PLAYERS];
//salaire des job
enum salairejobinfo
{
	salairejobinfoidd,
	salairejobinfocariste,
	salairejobinfomanutentionnaire,
	salairejobinfodock,
	salairejobinfominer,
	salairejobinfoelectronic,
	salairejobinfobucheron,
	salairejobinfomenuisier,
	salairejobinfogenerateur,
	salairejobinfoelectricien,
	salairejobinfoarme,
	salairejobinfopetrolier,
	salairejobinfoboucher
}
new info_salairejobinfo[MAX_PLAYERS][salairejobinfo];
new stockmagasininfo;
new stockinfobucheron;
new stockinfocariste;
new stockinfomanutentionnaire;
new stockinfoboismenuiserie;
new stockinfomeublemenuiserie;
new stockinfopetrol;
new stockinfoessencegenerator;
new stockinfodock;
new stockinfoboucherie;
new stockinfousineelectronic;
new stockinfominer;
new stockinfoarme;
new infojobsalaire;
new infojobsalaire2;
//tuning
new FrontBumperID1[MAX_VEHICLES];
new RearBumperID1[MAX_VEHICLES];
new RoofID1[MAX_VEHICLES];
new HoodID1[MAX_VEHICLES];
new SpoilerID1[MAX_VEHICLES];
new WheelID1[MAX_VEHICLES];
new SideSkirt1ID1[MAX_VEHICLES];
new SideSkirt2ID1[MAX_VEHICLES];
enum tuning_info
{
	tuningidid,
	Float:AddSpeed,
	Float:FrontBumperX,
	Float:FrontBumperY,
	Float:FrontBumperZ,
	Float:FrontBumperRX,
	Float:FrontBumperRY,
	Float:FrontBumperRZ,
	FrontBumperID,
	FrontBumper,
	Float:RearBumperX,
	Float:RearBumperY,
	Float:RearBumperZ,
	Float:RearBumperRX,
	Float:RearBumperRY,
	Float:RearBumperRZ,
	RearBumperID,
	RearBumper,
	Float:RoofX,
	Float:RoofY,
	Float:RoofZ,
	Float:RoofRX,
	Float:RoofRY,
	Float:RoofRZ,
	RoofID,
	Roof,
	Float:HoodX,
	Float:HoodY,
	Float:HoodZ,
	Float:HoodRX,
	Float:HoodRY,
	Float:HoodRZ,
	HoodID,
	Hood,
	Float:SpoilerX,
	Float:SpoilerY,
	Float:SpoilerZ,
	Float:SpoilerRX,
	Float:SpoilerRY,
	Float:SpoilerRZ,
	SpoilerID,
	Spoiler,
	Float:WheelX,
	Float:WheelY,
	Float:WheelZ,
	Float:WheelRX,
	Float:WheelRY,
	Float:WheelRZ,
	WheelID,
	Wheel,
	Float:SideSkirt1X,
	Float:SideSkirt1Y,
	Float:SideSkirt1Z,
	Float:SideSkirt1RX,
	Float:SideSkirt1RY,
	Float:SideSkirt1RZ,
	SideSkirt1ID,
	SideSkirt1,
	Float:SideSkirt2X,
	Float:SideSkirt2Y,
	Float:SideSkirt2Z,
	Float:SideSkirt2RX,
	Float:SideSkirt2RY,
	Float:SideSkirt2RZ,
	SideSkirt2ID,
	SideSkirt2,
	EditingPart,
	PlayerVehicle,
	LeftRight,
	EditStatus,
	EditingTimer,
}
new Tuning[MAX_PLAYERS][tuning_info];
new g_FrontBumpers[24] = {
	1115,
	1116,
	1117,
	1152,
	1153,
	1155,
	1157,
	1160,
	1165,
	1166,
	1170,
	1171,
	1172,
	1173,
	1174,
	1176,
	1179,
	1181,
	1182,
	1185,
	1188,
	1189,
	1190,
	1191
};
new g_RearBumpers[24] = {
	1109,
	1110,
	1140,
	1141,
	1148,
	1149,
	1150,
	1151,
	1154,
	1156,
	1159,
	1161,
	1167,
	1168,
	1175,
	1177,
	1178,
	1180,
	1183,
	1184,
	1186,
	1187,
	1192,
	1193
};
new g_Roofs[17] = {
	1006,
	1032,
	1033,
	1035,
	1038,
	1053,
	1054,
	1055,
	1061,
	1067,
	1068,
	1088,
	1091,
	1103,
	1128,
	1130,
	1131
};
new g_Hoods[4] = {
	1004,
	1005,
	1011,
	1012
};
new g_Spoiler[20] = {
	1000,
	1001,
	1002,
	1003,
	1014,
	1015,
	1016,
	1023,
	1049,
	1050,
	1058,
	1060,
	1138,
	1139,
	1146,
	1147,
	1158,
	1162,
	1163,
	1164
};
new g_SideSkirt1[40] = {
	1007,
	1017,
	1026,
	1027,
	1030,
	1031,
	1036,
	1039,
	1040,
	1041,
	1042,
	1047,
	1048,
	1051,
	1052,
	1056,
	1057,
	1062,
	1063,
	1069,
	1070,
	1071,
	1072,
	1090,
	1093,
	1094,
	1095,
	1099,
	1106,
	1107,
	1108,
	1118,
	1119,
	1120,
	1121,
	1122,
	1124,
	1133,
	1134,
	1137
};
new g_SideSkirt2[40] = {
	1007,
	1017,
	1026,
	1027,
	1030,
	1031,
	1036,
	1039,
	1040,
	1041,
	1042,
	1047,
	1048,
	1051,
	1052,
	1056,
	1057,
	1062,
	1063,
	1069,
	1070,
	1071,
	1072,
	1090,
	1093,
	1094,
	1095,
	1099,
	1106,
	1107,
	1108,
	1118,
	1119,
	1120,
	1121,
	1122,
	1124,
	1133,
	1134,
	1137
};
new g_roue[17] = {
	1025,
	1073,
	1074,
	1075,
	1076,
	1077,
	1078,
	1079,
	1080,
	1081,
	1082,
	1083,
	1084,
	1085,
	1096,
	1097,
	1098
};
//afk
new AFKTimer;
new AFKMin[MAX_PLAYERS];
new Float:AFKPos[MAX_PLAYERS][3];
/* PARAMETRE */
new AFKMaxMin; //Nombre de minutes avant le kick pour AFK (valeur par defaut mais peux être modifier IG par un admin via la commande /afkmaxmin)
new AFKActiver; //1 = Anti AFK activé 0 = afk desactivé (valeur par defaut mais peux être modifier IG par un admin via la commande /afksystem)
//dynamite boom
new dynamite_Timer;
new dynamiteobject;
new Float:dx, Float:dy, Float:dz;
//braquage
new cop_nbrCops=0;                              // Nombre de flics connectés.
new swat_nbrCops=0; 								// swat co
//bank
new objectbank[MAX_PLAYERS];
new vaultdoor;
new start1[MAX_PLAYERS];
new timerrob[MAX_PLAYERS];
new portevol;
//serveur setting
enum serveursettinginfo
{
	serveursettinginfoidd,
	settingafkactive,
	settingafktime,
	settingbraquagenpcactive,
	settingbraquagebankactive,
	settingoocactive,
	settingpmactive,
	settingmotd[128],
	settingvilleactive,
	settingnouveau,
	settingpolice,
	settingswat
}
new info_serveursettinginfo[MAX_PLAYERS][serveursettinginfo];
//location du vehicule
//new DernieVehLoc[MAX_PLAYERS];
new DernieVehLocID[MAX_PLAYERS];
//mecano appelle
new MecanoApel = -1;
//micro
new micro[MAX_PLAYERS];
new micropl[MAX_PLAYERS];
//vole veh
new TrafiqueFilsTimer[MAX_PLAYERS];
new TrafiqueFilsKillTimer[MAX_PLAYERS];
//bot action
new actorvendeuramendes[1];
new actorvendeurpermis[1];
new actorvendeurmairie[1];
new actorvendeurbanque[4];
new actorvendeurbanquef[4];
new actorvendeuranpe[1];
new HelpPic1[2];
//roulette
new idy=-1;
new bool:C_Created[MAX_PLAYERS][60];
new bool:test[50];
new Actived[MAX_PLAYERS];
new pBet[MAX_PLAYERS][60];
new LastNumber[MAX_PLAYERS];
new StartTimery[MAX_PLAYERS];
new StopTimery[MAX_PLAYERS];
new Float:cPos[37][2] ={
{220.000000, 144.000000},
{242.000000, 203.000000},
{242.000000, 174.000000},
{242.000000, 145.000000},
{267.000000, 203.000000},
{267.000000, 174.000000},
{267.000000, 145.000000},
{292.000000, 203.000000},
{292.000000, 174.000000},
{292.000000, 145.000000},
{317.000000, 203.000000},
{317.000000, 174.000000},
{317.000000, 145.000000},
{342.000000, 203.000000},
{342.000000, 174.000000},
{342.000000, 145.000000},
{367.000000, 203.000000},
{367.000000, 174.000000},
{367.000000, 145.000000},
{392.000000, 203.000000},
{392.000000, 174.000000},
{392.000000, 145.000000},
{417.000000, 203.000000},
{417.000000, 174.000000},
{417.000000, 145.000000},
{442.000000, 203.000000},
{442.000000, 174.000000},
{442.000000, 145.000000},
{467.000000, 203.000000},
{467.000000, 174.000000},
{467.000000, 145.000000},
{492.000000, 203.000000},
{492.000000, 174.000000},
{492.000000, 145.000000},
{517.000000, 203.000000},
{517.000000, 174.000000},
{517.000000, 145.000000}
};
//candidat vote
const MAX_CANDIDATES = 10; // Le nombre maximum de candidats (20) | Le plus petit est le nombre, moins de mémoire sera alloué.
const SERVER_SLOTS = 1000; // Nombre de serveur de fentes
new Sphere[3];
new Candidates1[MAX_CANDIDATES][MAX_PLAYER_NAME];
new bool: Voting[SERVER_SLOTS+1]; // Vérifiez la newsletter
new Votes[MAX_CANDIDATES], // Nombre de votes pour chaque candidat
        NumberOfCandidates; // Le nombre de candidats (en partant de la base de données)
//limiteur
new seb[MAX_PLAYERS];
//bot
new piececaisse;
new mercco=0;
new soinbot;
new armespolice;
new armedbody_pTick[MAX_PLAYERS];
//barriere
new cade[MAX_CADES];
new Float:Position[4];
//bowling
new BowlingPins[MAX_BOWLING_ROADS][MAX_PINS];//pins
new BowlingMinutes[MAX_PLAYERS];
new BowlingSeconds[MAX_PLAYERS];
new BowlingPinsWaitEndTimer[MAX_PLAYERS];
new BowlingPinsWaitTimer[MAX_PLAYERS];
new BowlingTimer[MAX_BOWLING_ROADS];//timer
new BowlingStatus[MAX_PLAYERS];//statusof playing player
new PinsLeft[MAX_BOWLING_ROADS][MAX_PLAYERS];//how much pins left after first try
new LastPin[MAX_BOWLING_ROADS][MAX_PINS][MAX_PLAYERS];//how much pins left after second try
new AbleToPlay[MAX_PLAYERS];//players able to play
new PlayersBowlingRoad[MAX_PLAYERS];//road what player using
new BowlingRoadStatus[MAX_BOWLING_ROADS];//status of th road
new Text3D:BowlingRoadScreen[MAX_BOWLING_ROADS];//the screens
new BowlingBall[MAX_BOWLING_ROADS];
new BallGoing[MAX_PLAYERS];
new BallRun[MAX_PLAYERS];
new PlayersBowlingScore[MAX_PLAYERS];
new HelpBowlingRoadPickup[MAX_BOWLING_ROADS];//pickups of bowling
//caisse
enum regData {
	caisseID,
	caisseExists,
	caisseOpened,
	Float:caissePos[6],
	caisseInterior,
	caisseWorld,
	caisseObject
};
new caisseMachineData[MAX_caisseS][regData];
//gym
new Bar:player_gym_progress[MAX_PLAYERS];
new Text:gym_power[ MAX_PLAYERS ];
new Text:gym_des[MAX_PLAYERS];
new Text:gym_deslabel[MAX_PLAYERS];
new Text:gym_repslabel[MAX_PLAYERS];
new PLAYER_TREAD_TIMER[MAX_PLAYERS];
new PLAYER_BIKE_TIMER[MAX_PLAYERS];
new PLAYER_BENCH_TIMER[MAX_PLAYERS];
new PLAYER_DUMB_TIMER[MAX_PLAYERS];
new PLAYER_TREAM_DIS_COUNT[MAX_PLAYERS];
new PLAYER_BIKE_DIS_COUNT[MAX_PLAYERS];
new PLAYER_BENCH_COUNT[MAX_PLAYERS];
new PLAYER_DUMB_COUNT[MAX_PLAYERS];
//atmData
new PlayerText:atmklik[MAX_PLAYERS][19];
//horse
new Text:Horse1, Text:Horse2, Text:Horse3, Text:Horse4, Text:BG1, Text:BG2, Text:Start, Text:Finish, Text:Start2, Text:Finish2, HorseCD, Text:CDTextDraw, Text:HorseNum1, Text:HorseNum2, Text:HorseNum3, Text:HorseNum4, HorseAnimCount;
new Float:HorsePosX1, Float:HorsePosX2, Float:HorsePosX3, Float:HorsePosX4, HorseStop;
new MoneyBet[MAX_PLAYERS], BetOnHorse[MAX_PLAYERS], RaceStarted, Watching[MAX_PLAYERS], Prepared, Horsemsg;
//lowrider
new bool:InContest[MAX_PLAYERS], CurrentNote[MAX_PLAYERS], Text:ContestText, PointGagner[MAX_PLAYERS],bool:JustJoined[MAX_PLAYERS],Float:Pos[4],organisateur[MAX_PLAYERS];
//bus
new IsInBus[MAX_PLAYERS];
//blackjack
enum blackjack {
	somme1,somme2,somme3,somme4,somme5,somme6,
	somme7,somme8,somme9,somme10,sommejouer,
	dealercarte1,dealercarte2,dealercarte3
}
new BlackJack[MAX_PLAYERS][blackjack];
new PlayerText:BlackJackTD[21][MAX_PLAYERS];
//event
new event=0;