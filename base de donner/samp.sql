-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : mar. 29 juin 2021 à 21:36
-- Version du serveur :  8.0.23
-- Version de PHP : 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `accounts` (
  `ID` int NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Password` varchar(129) DEFAULT NULL,
  `RegisterDate` varchar(36) DEFAULT NULL,
  `LoginDate` varchar(36) DEFAULT NULL,
  `IP` varchar(16) DEFAULT 'n/a',
  `WL` int NOT NULL DEFAULT '0',
  `Language` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `actors` (
  `ID` int NOT NULL,
  `Skinid` int NOT NULL DEFAULT '2',
  `Float` varchar(220) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0,0,0',
  `actorint` int NOT NULL DEFAULT '0',
  `actorvw` int NOT NULL DEFAULT '0',
  `actorsetting` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `arrestpoints` (
  `arrestID` int NOT NULL,
  `arrestX` float NOT NULL,
  `arrestY` float NOT NULL,
  `arrestZ` float NOT NULL,
  `arrestInterior` int NOT NULL,
  `arrestWorld` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `atm` (
  `atmID` int NOT NULL,
  `atmX` float NOT NULL,
  `atmY` float NOT NULL,
  `atmZ` float NOT NULL,
  `atmA` float NOT NULL,
  `atmInterior` int NOT NULL,
  `atmWorld` int NOT NULL,
  `destroy` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `backpackitems` (
  `ID` int DEFAULT '0',
  `itemID` int NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int DEFAULT '0',
  `itemQuantity` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `backpacks` (
  `backpackID` int NOT NULL,
  `backpackPlayer` int DEFAULT '0',
  `backpackX` float DEFAULT '0',
  `backpackY` float DEFAULT '0',
  `backpackZ` float DEFAULT '0',
  `backpackInterior` int DEFAULT '0',
  `backpackWorld` int DEFAULT '0',
  `backpackHouse` int DEFAULT '0',
  `backpackVehicle` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `bankers` (
  `ID` int NOT NULL,
  `Skin` smallint NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `PosA` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `bank_accounts` (
  `ID` int NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `Password` varchar(32) NOT NULL,
  `Balance` int NOT NULL,
  `CreatedOn` int NOT NULL,
  `LastAccess` int NOT NULL,
  `Disabled` smallint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `bank_atms` (
  `ID` int NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `RotX` float NOT NULL,
  `RotY` float NOT NULL,
  `RotZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `bank_logs` (
  `ID` int NOT NULL,
  `AccountID` int NOT NULL,
  `ToAccountID` int NOT NULL DEFAULT '-1',
  `Type` smallint NOT NULL,
  `Player` varchar(24) NOT NULL,
  `Amount` int NOT NULL,
  `Date` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `banqueentreprise` (
  `id` int NOT NULL,
  `mecanozone` int NOT NULL,
  `livraisonzone1` int NOT NULL,
  `mafiazone1` int NOT NULL,
  `mafiazone4` int NOT NULL,
  `police` int NOT NULL,
  `fbi` int NOT NULL,
  `swat` int NOT NULL,
  `mairiels` int NOT NULL,
  `medecin` int NOT NULL,
  `fermier` int NOT NULL,
  `vendeur` int NOT NULL,
  `journaliste` int NOT NULL,
  `banque` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `banqueentreprise` (`id`, `mecanozone`, `livraisonzone1`, `mafiazone1`, `mafiazone4`, `police`, `fbi`, `swat`, `mairiels`, `medecin`, `fermier`, `vendeur`, `journaliste`, `banque`) VALUES
(1, 0, 1800, 0, 0, 26144600, 0, 0, 26144600, 26144600, 0, 3, 2500, 26144600);


CREATE TABLE `batiements` (
  `batiementID` int NOT NULL,
  `batiementModel` int DEFAULT '0',
  `batiementX` float DEFAULT '0',
  `batiementY` float DEFAULT '0',
  `batiementZ` float DEFAULT '0',
  `batiementRX` float DEFAULT '0',
  `batiementRY` float DEFAULT '0',
  `batiementRZ` float DEFAULT '0',
  `batiementInterior` int DEFAULT '0',
  `batiementWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `billboards` (
  `bbID` int NOT NULL,
  `bbExists` int DEFAULT '0',
  `bbName` varchar(32) DEFAULT NULL,
  `bbOwner` int NOT NULL DEFAULT '0',
  `bbPrice` int NOT NULL DEFAULT '0',
  `bbRange` int DEFAULT '10',
  `bbPosX` float DEFAULT '0',
  `bbPosY` float DEFAULT '0',
  `bbPosZ` float DEFAULT '0',
  `bbMessage` varchar(230) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `blacklist` (
  `IP` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `Username` varchar(24) NOT NULL DEFAULT '',
  `BannedBy` varchar(24) DEFAULT NULL,
  `Reason` varchar(128) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `businesses` (
  `bizID` int NOT NULL,
  `bizName` varchar(32) DEFAULT NULL,
  `bizOwner` int DEFAULT '0',
  `bizType` int DEFAULT '0',
  `bizPrice` int DEFAULT '0',
  `bizPosX` float DEFAULT '0',
  `bizPosY` float DEFAULT '0',
  `bizPosZ` float DEFAULT '0',
  `bizPosA` float DEFAULT '0',
  `bizIntX` float DEFAULT '0',
  `bizIntY` float DEFAULT '0',
  `bizIntZ` float DEFAULT '0',
  `bizIntA` float DEFAULT '0',
  `bizInterior` int DEFAULT '0',
  `bizInteriorVW` int NOT NULL DEFAULT '0',
  `bizExterior` int DEFAULT '0',
  `bizExteriorVW` int DEFAULT '0',
  `bizLocked` int DEFAULT '0',
  `bizVault` int DEFAULT '0',
  `bizProducts` int DEFAULT '0',
  `bizPrice1` int DEFAULT '0',
  `bizPrice2` int DEFAULT '0',
  `bizPrice3` int DEFAULT '0',
  `bizPrice4` int DEFAULT '0',
  `bizPrice5` int DEFAULT '0',
  `bizPrice6` int DEFAULT '0',
  `bizPrice7` int DEFAULT '0',
  `bizPrice8` int DEFAULT '0',
  `bizPrice9` int DEFAULT '0',
  `bizPrice10` int DEFAULT '0',
  `bizSpawnX` float DEFAULT '0',
  `bizSpawnY` float DEFAULT '0',
  `bizSpawnZ` float DEFAULT '0',
  `bizSpawnA` float DEFAULT '0',
  `bizDeliverX` float DEFAULT '0',
  `bizDeliverY` float DEFAULT '0',
  `bizDeliverZ` float DEFAULT '0',
  `bizMessage` varchar(128) DEFAULT NULL,
  `bizPrice11` int DEFAULT '0',
  `bizPrice12` int DEFAULT '0',
  `bizPrice13` int DEFAULT '0',
  `bizPrice14` int DEFAULT '0',
  `bizPrice15` int DEFAULT '0',
  `bizPrice16` int DEFAULT '0',
  `bizPrice17` int DEFAULT '0',
  `bizPrice18` int DEFAULT '0',
  `bizPrice19` int DEFAULT '0',
  `bizPrice20` int DEFAULT '0',
  `bizShipment` int DEFAULT '0',
  `time1` int NOT NULL DEFAULT '-1',
  `time2` int NOT NULL DEFAULT '-1',
  `chancevole` int NOT NULL DEFAULT '0',
  `defoncer` int NOT NULL,
  `bizitemname1` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname2` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname3` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname4` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname5` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemmodel1` int NOT NULL DEFAULT '-1',
  `bizitemmodel2` int NOT NULL DEFAULT '-1',
  `bizitemmodel3` int NOT NULL DEFAULT '-1',
  `bizitemmodel4` int NOT NULL DEFAULT '-1',
  `bizitemmodel5` int NOT NULL DEFAULT '-1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `caisses` (
  `caisseID` int NOT NULL,
  `caisseX` float DEFAULT '0',
  `caisseY` float DEFAULT '0',
  `caisseZ` float DEFAULT '0',
  `caisseRX` float DEFAULT '0',
  `caisseRY` float DEFAULT '0',
  `caisseRZ` float DEFAULT '0',
  `caisseInterior` int DEFAULT '0',
  `caisseWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cars` (
  `carID` int NOT NULL,
  `carModel` int DEFAULT '0',
  `carOwner` int DEFAULT '0',
  `carPosX` float DEFAULT '0',
  `carPosY` float DEFAULT '0',
  `carPosZ` float DEFAULT '0',
  `carPosR` float DEFAULT '0',
  `carColor1` int DEFAULT '0',
  `carColor2` int DEFAULT '0',
  `carPaintjob` int DEFAULT '-1',
  `carLocked` int DEFAULT '0',
  `carMod1` int DEFAULT '0',
  `carMod2` int DEFAULT '0',
  `carMod3` int DEFAULT '0',
  `carMod4` int DEFAULT '0',
  `carMod5` int DEFAULT '0',
  `carMod6` int DEFAULT '0',
  `carMod7` int DEFAULT '0',
  `carMod8` int DEFAULT '0',
  `carMod9` int DEFAULT '0',
  `carMod10` int DEFAULT '0',
  `carMod11` int DEFAULT '0',
  `carMod12` int DEFAULT '0',
  `carMod13` int DEFAULT '0',
  `carMod14` int DEFAULT '0',
  `carImpounded` int DEFAULT '0',
  `carWeapon1` int DEFAULT '0',
  `carAmmo1` int DEFAULT '0',
  `carWeapon2` int DEFAULT '0',
  `carAmmo2` int DEFAULT '0',
  `carWeapon3` int DEFAULT '0',
  `carAmmo3` int DEFAULT '0',
  `carWeapon4` int DEFAULT '0',
  `carAmmo4` int DEFAULT '0',
  `carWeapon5` int DEFAULT '0',
  `carAmmo5` int DEFAULT '0',
  `carImpoundPrice` int DEFAULT '0',
  `carFaction` int DEFAULT '0',
  `carLoca` int NOT NULL DEFAULT '-1',
  `carLocaID` int NOT NULL DEFAULT '-1',
  `carDouble` int NOT NULL DEFAULT '-1',
  `carSabot` int NOT NULL DEFAULT '-1',
  `carSabPri` int NOT NULL DEFAULT '-1',
  `vkilometres` float NOT NULL DEFAULT '0',
  `vmetre` int NOT NULL DEFAULT '0',
  `fuel` int NOT NULL DEFAULT '100',
  `carvie` float NOT NULL DEFAULT '1000',
  `alarme` int NOT NULL DEFAULT '1',
  `boitier` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `carstorage` (
  `ID` int DEFAULT '0',
  `itemID` int NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int DEFAULT '0',
  `itemQuantity` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `characters` (
  `ID` int NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Character` varchar(24) DEFAULT NULL,
  `Created` int DEFAULT '0',
  `Gender` int DEFAULT '0',
  `Birthdate` varchar(32) DEFAULT '01/01/1970',
  `Origin` varchar(32) DEFAULT 'Not Specified',
  `Skin` int DEFAULT '0',
  `Glasses` int DEFAULT '0',
  `Hat` int DEFAULT '0',
  `Bandana` int DEFAULT '0',
  `PosX` float DEFAULT '0',
  `PosY` float DEFAULT '0',
  `PosZ` float DEFAULT '0',
  `PosA` float DEFAULT '0',
  `Interior` int DEFAULT '0',
  `World` int DEFAULT '0',
  `GlassesPos` varchar(100) DEFAULT NULL,
  `HatPos` varchar(100) DEFAULT NULL,
  `BandanaPos` varchar(100) DEFAULT NULL,
  `Hospital` int DEFAULT '-1',
  `HospitalInt` int DEFAULT '0',
  `Money` int DEFAULT '0',
  `BankMoney` int DEFAULT '0',
  `OwnsBillboard` int DEFAULT '-1',
  `Savings` int DEFAULT '0',
  `Admin` int DEFAULT '0',
  `JailTime` int DEFAULT '0',
  `Muted` int DEFAULT '0',
  `CreateDate` int DEFAULT '0',
  `LastLogin` int DEFAULT '0',
  `Tester` int DEFAULT '0',
  `Gun1` int DEFAULT '0',
  `Gun2` int DEFAULT '0',
  `Gun3` int DEFAULT '0',
  `Gun4` int DEFAULT '0',
  `Gun5` int DEFAULT '0',
  `Gun6` int DEFAULT '0',
  `Gun7` int DEFAULT '0',
  `Gun8` int DEFAULT '0',
  `Gun9` int DEFAULT '0',
  `Gun10` int DEFAULT '0',
  `Gun11` int DEFAULT '0',
  `Gun12` int DEFAULT '0',
  `Gun13` int DEFAULT '0',
  `Ammo1` int DEFAULT '0',
  `Ammo2` int DEFAULT '0',
  `Ammo3` int DEFAULT '0',
  `Ammo4` int DEFAULT '0',
  `Ammo5` int DEFAULT '0',
  `Ammo6` int DEFAULT '0',
  `Ammo7` int DEFAULT '0',
  `Ammo8` int DEFAULT '0',
  `Ammo9` int DEFAULT '0',
  `Ammo10` int DEFAULT '0',
  `Ammo11` int DEFAULT '0',
  `Ammo12` int DEFAULT '0',
  `Ammo13` int DEFAULT '0',
  `House` int DEFAULT '-1',
  `Business` int DEFAULT '-1',
  `Phone` int DEFAULT '0',
  `Lottery` int DEFAULT '0',
  `Hunger` int DEFAULT '100',
  `Thirst` int DEFAULT '100',
  `PlayingHours` int DEFAULT '0',
  `Minutes` int DEFAULT '0',
  `ArmorStatus` float DEFAULT '0',
  `Entrance` int DEFAULT '0',
  `Job` int DEFAULT '0',
  `Faction` int DEFAULT '-1',
  `FactionRank` int DEFAULT '0',
  `Prisoned` int DEFAULT '0',
  `Warrants` int DEFAULT '0',
  `Injured` int DEFAULT '0',
  `Health` float DEFAULT '0',
  `Channel` int DEFAULT '0',
  `Accent` varchar(24) DEFAULT NULL,
  `Bleeding` int DEFAULT '0',
  `Warnings` int DEFAULT '0',
  `Warn1` varchar(32) DEFAULT NULL,
  `Warn2` varchar(32) DEFAULT NULL,
  `MaskID` int DEFAULT '0',
  `FactionMod` int DEFAULT '0',
  `Capacity` int DEFAULT '35',
  `AdminHide` int DEFAULT '0',
  `LotteryB` int DEFAULT NULL,
  `SpawnPoint` int DEFAULT NULL,
  `connecter` int NOT NULL DEFAULT '0',
  `bracelet` int NOT NULL DEFAULT '0',
  `braceletdist` int NOT NULL DEFAULT '0',
  `LocaID` int NOT NULL DEFAULT '0',
  `CarD` int NOT NULL DEFAULT '-1',
  `LocaMaisonID` int NOT NULL DEFAULT '0',
  `baterietel` int NOT NULL DEFAULT '20',
  `BestScore` int NOT NULL DEFAULT '0',
  `Strike` int NOT NULL DEFAULT '0',
  `Repetition` int NOT NULL DEFAULT '0',
  `Parcouru` int NOT NULL DEFAULT '0',
  `Noob` int NOT NULL DEFAULT '1',
  `ZombieKill` int NOT NULL DEFAULT '0',
  `skill0` int NOT NULL DEFAULT '0',
  `skill1` int NOT NULL DEFAULT '0',
  `skill2` int NOT NULL DEFAULT '0',
  `skill3` int NOT NULL DEFAULT '0',
  `skill4` int NOT NULL DEFAULT '0',
  `skill5` int NOT NULL DEFAULT '0',
  `skill6` int NOT NULL DEFAULT '0',
  `skill7` int NOT NULL DEFAULT '0',
  `skill8` int NOT NULL DEFAULT '0',
  `skill9` int NOT NULL DEFAULT '0',
  `skill10` int NOT NULL DEFAULT '0',
  `DA` int NOT NULL DEFAULT '0',
  `Death` int NOT NULL DEFAULT '0',
  `Role` varchar(20) NOT NULL DEFAULT '0',
  `Combat` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `contacts` (
  `ID` int DEFAULT '0',
  `contactID` int NOT NULL,
  `contactName` varchar(32) DEFAULT NULL,
  `contactNumber` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `crates` (
  `crateID` int NOT NULL,
  `crateType` int DEFAULT '0',
  `crateX` float DEFAULT '0',
  `crateY` float DEFAULT '0',
  `crateZ` float DEFAULT '0',
  `crateA` float DEFAULT '0',
  `crateInterior` int DEFAULT '0',
  `crateWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dealervehicles` (
  `ID` int DEFAULT '0',
  `vehID` int NOT NULL,
  `vehModel` int DEFAULT '0',
  `vehPrice` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




CREATE TABLE `death` (
  `dID` int NOT NULL,
  `dName` varchar(32) NOT NULL,
  `dDate` varchar(36) NOT NULL DEFAULT '10/10/2020'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `detectors` (
  `detectorID` int NOT NULL,
  `detectorX` float DEFAULT '0',
  `detectorY` float DEFAULT '0',
  `detectorZ` float DEFAULT '0',
  `detectorAngle` float DEFAULT '0',
  `detectorInterior` int DEFAULT '0',
  `detectorWorld` int DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



CREATE TABLE `dropped` (
  `ID` int NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int DEFAULT '0',
  `itemX` float DEFAULT '0',
  `itemY` float DEFAULT '0',
  `itemZ` float DEFAULT '0',
  `itemInt` int DEFAULT '0',
  `itemWorld` int DEFAULT '0',
  `itemQuantity` int DEFAULT '0',
  `itemAmmo` int DEFAULT '0',
  `itemWeapon` int DEFAULT '0',
  `itemPlayer` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `entrances` (
  `entranceID` int NOT NULL,
  `entranceName` varchar(32) DEFAULT NULL,
  `entranceIcon` int DEFAULT '0',
  `entrancePosX` float DEFAULT '0',
  `entrancePosY` float DEFAULT '0',
  `entrancePosZ` float DEFAULT '0',
  `entrancePosA` float DEFAULT '0',
  `entranceIntX` float DEFAULT '0',
  `entranceIntY` float DEFAULT '0',
  `entranceIntZ` float DEFAULT '0',
  `entranceIntA` float DEFAULT '0',
  `entranceInterior` int DEFAULT '0',
  `entranceExterior` int DEFAULT '0',
  `entranceExteriorVW` int DEFAULT '0',
  `entranceType` int DEFAULT '0',
  `entrancePass` varchar(32) DEFAULT NULL,
  `entranceLocked` int DEFAULT '0',
  `entranceCustom` int DEFAULT '0',
  `entranceWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `entrances` (`entranceID`, `entranceName`, `entranceIcon`, `entrancePosX`, `entrancePosY`, `entrancePosZ`, `entrancePosA`, `entranceIntX`, `entranceIntY`, `entranceIntZ`, `entranceIntA`, `entranceInterior`, `entranceExterior`, `entranceExteriorVW`, `entranceType`, `entrancePass`, `entranceLocked`, `entranceCustom`, `entranceWorld`) VALUES
(2, 'Auto-Ecole', 55, 1166.24, -1858.82, 506.589, 86.3585, -2029.55, -118.8, 1035.17, 0, 3, 0, 0, 1, '', 0, 0, 7002),
(5, 'Mairie', 35, 2088.2, -1760.32, 13.4048, 196.125, -501.114, 286.605, 2001.09, 3.6551, 1, 0, 0, 4, '', 0, 1, 7005),
(25, 'A.N.P.E', 13, 2147.54, -1757.27, 13.392, 270.047, 316.874, 119.304, 1011.76, 9.612, 1, 0, 0, 10, '', 0, 1, 0),
(27, 'Abatoire', 0, 2113.97, -1765.5, 13.3965, 117.085, 964.355, 2107.85, 1011.03, 90.1714, 1, 0, 0, 0, '', 0, 1, 7027),
(28, 'Cariste', 0, 2134.96, -1726.19, 13.5392, 276.902, 1291.82, 5.8713, 1001.01, 180, 18, 0, 0, 3, '', 0, 1, 7028),
(29, 'Usine', 0, 2058.43, -1747.74, 13.3865, 102.449, 2569.84, -1301.05, 1044.95, 109.236, 2, 0, 0, 0, '', 0, 1, -1),
(30, 'Salle des machines', 0, 2016.18, -1754.86, 13.3828, 71.6902, -959.683, 1954.82, 1009, 179.966, 17, 0, 0, 0, '', 0, 1, 0),
(31, 'Central éléctrique', 0, 2008.16, -1709.52, 13.5468, 343.63, 813.416, -69.8078, 1000.78, 75.4156, 1, 0, 0, 0, '', 0, 1, 7031),
(32, 'Banque Riche', 52, 2029.12, -1679.64, 13.5468, 275.662, 1101.17, -1290.47, 507.843, 89.8749, 0, 0, 0, 2, '', 0, 0, 0),
(34, 'Casino', 25, 2078.09, -1656.56, 13.3906, 312.374, -251.957, -21.1578, 1004.69, 90, 3, 0, 0, 6, '', 0, 1, 7034),
(35, 'Taxi', 0, 2127.31, -1673.89, 14.8699, 243.166, -1972.14, -897.436, 757.898, 270.44, 1, 0, 0, 0, '', 0, 1, 7035),
(36, 'Shooting Range', 0, 2171.01, -1692.8, 15.0784, 177.183, 304.017, -141.989, 1004.06, 90, 7, 0, 0, 5, '', 0, 0, 7036),
(38, 'Bowling', 0, 2180.56, -1727.68, 13.375, 187.353, -1992.7, 407.879, 802.501, 268.706, 1, 0, 0, 9, '', 0, 1, 7038),
(39, 'Entrepôt', 0, 2181.34, -1752.13, 13.375, 153.121, 2606.47, -1233.46, 1022.03, 272.707, 1, 0, 0, 0, '', 0, 1, 7039),
(51, 'Gymnase', 0, 2185.3, -1796.48, 13.3672, 176.19, 772.428, -5.4299, 1000.73, 356.914, 5, 0, 0, 0, '', 0, 0, 7051),
(59, 'PMU', 0, 2162.53, -1801.13, 13.3747, 107.726, 833.491, 7.3242, 1003.52, 90, 3, 0, 0, 7, '', 0, 0, 7059),
(64, 'Usine de meubles', 0, 2190.85, -1706.98, 13.5884, 3.0458, 1626.63, -1811.32, 1013.43, 90.6977, 210, 0, 0, 0, '', 0, 0, 7064),
(73, 'Fabrique d\'arme', 0, 2149.71, -1703.18, 15.0784, 90.6104, 2332.91, 5.5956, 1026.5, 92.287, 1, 0, 0, 0, '', 0, 1, 1),
(92, 'Bureau de la Fourriere', 0, 2106.74, -1702.59, 13.3828, 90.6104, 441.11, 132.703, 1008.4, 171.598, 0, 0, 0, 0, '', 0, 0, 7092),
(94, 'Event 1', 0, 2089.07, -1705.84, 13.539, 180.407, 2744.15, -1741.82, 422.822, 129.705, 0, 0, 0, 0, '', 0, 2, 100),
(95, 'San News', 36, 2070.56, -1732.15, 13.5546, 205.957, 304.122, 1894.16, 904.376, 182.331, 15, 0, 0, 0, '', 0, 0, 7095);


CREATE TABLE `factions` (
  `factionID` int NOT NULL,
  `factionName` varchar(32) DEFAULT NULL,
  `factionRanks` int DEFAULT '0',
  `factionLockerX` float DEFAULT '0',
  `factionLockerY` float DEFAULT '0',
  `factionLockerZ` float DEFAULT '0',
  `factionLockerInt` int DEFAULT '0',
  `factionLockerWorld` int DEFAULT '0',
  `factioncoffre` int NOT NULL DEFAULT '0',
  `factiondiscord` varchar(20) NOT NULL DEFAULT '0',
  `factionrole` varchar(20) NOT NULL DEFAULT '0',
  `factionaction1X` float NOT NULL DEFAULT '0',
  `factionaction1Y` float NOT NULL DEFAULT '0',
  `factionaction1Z` float NOT NULL DEFAULT '0',
  `factionaction1R` float NOT NULL DEFAULT '0',
  `factionaction2X` float NOT NULL DEFAULT '0',
  `factionaction2Y` float NOT NULL DEFAULT '0',
  `factionaction2Z` float NOT NULL DEFAULT '0',
  `factionaction2R` float DEFAULT '0',
  `factionaction3X` float NOT NULL DEFAULT '0',
  `factionaction3Y` float NOT NULL DEFAULT '0',
  `factionaction3Z` float NOT NULL DEFAULT '0',
  `factionaction3R` float NOT NULL DEFAULT '0',
  `factionWeapon1` int DEFAULT '0',
  `factionAmmo1` int DEFAULT '0',
  `factionWeapon2` int DEFAULT '0',
  `factionAmmo2` int DEFAULT '0',
  `factionWeapon3` int DEFAULT '0',
  `factionAmmo3` int DEFAULT '0',
  `factionWeapon4` int DEFAULT '0',
  `factionAmmo4` int DEFAULT '0',
  `factionWeapon5` int DEFAULT '0',
  `factionAmmo5` int DEFAULT '0',
  `factionWeapon6` int DEFAULT '0',
  `factionAmmo6` int DEFAULT '0',
  `factionWeapon7` int DEFAULT '0',
  `factionAmmo7` int DEFAULT '0',
  `factionWeapon8` int DEFAULT '0',
  `factionAmmo8` int DEFAULT '0',
  `factionWeapon9` int DEFAULT '0',
  `factionAmmo9` int DEFAULT '0',
  `factionWeapon10` int DEFAULT '0',
  `factionAmmo10` int DEFAULT '0',
  `factionRank1` varchar(32) DEFAULT NULL,
  `factionRank2` varchar(32) DEFAULT NULL,
  `factionRank3` varchar(32) DEFAULT NULL,
  `factionRank4` varchar(32) DEFAULT NULL,
  `factionRank5` varchar(32) DEFAULT NULL,
  `factionRank6` varchar(32) DEFAULT NULL,
  `factionRank7` varchar(32) DEFAULT NULL,
  `factionRank8` varchar(32) DEFAULT NULL,
  `factionRank9` varchar(32) DEFAULT NULL,
  `factionRank10` varchar(32) DEFAULT NULL,
  `factionRank11` varchar(32) DEFAULT NULL,
  `factionRank12` varchar(32) DEFAULT NULL,
  `factionRank13` varchar(32) DEFAULT NULL,
  `factionRank14` varchar(32) DEFAULT NULL,
  `factionRank15` varchar(32) DEFAULT NULL,
  `factionSkin1` int DEFAULT '0',
  `factionSkin2` int DEFAULT '0',
  `factionSkin3` int DEFAULT '0',
  `factionSkin4` int DEFAULT '0',
  `factionSkin5` int DEFAULT '0',
  `factionSkin6` int DEFAULT '0',
  `factionSkin7` int DEFAULT '0',
  `factionSkin8` int DEFAULT '0',
  `factionacces1` int NOT NULL DEFAULT '0',
  `factionacces2` int NOT NULL DEFAULT '0',
  `factionacces3` int NOT NULL DEFAULT '0',
  `factionacces4` int NOT NULL DEFAULT '0',
  `factionacces5` int NOT NULL DEFAULT '0',
  `factionacces6` int NOT NULL DEFAULT '0',
  `factionacces7` int NOT NULL DEFAULT '0',
  `factionacces8` int NOT NULL DEFAULT '0',
  `factionacces9` int NOT NULL DEFAULT '0',
  `factionacces10` int NOT NULL DEFAULT '0',
  `factionacces11` int NOT NULL DEFAULT '0',
  `factionacces12` int NOT NULL DEFAULT '0',
  `factionacces13` int NOT NULL DEFAULT '0',
  `factionacces14` int NOT NULL DEFAULT '0',
  `factionacces15` int NOT NULL DEFAULT '0',
  `SalaireRank1` int NOT NULL DEFAULT '0',
  `SalaireRank2` int NOT NULL DEFAULT '0',
  `SalaireRank3` int NOT NULL DEFAULT '0',
  `SalaireRank4` int NOT NULL DEFAULT '0',
  `SalaireRank5` int NOT NULL DEFAULT '0',
  `SalaireRank6` int NOT NULL DEFAULT '0',
  `SalaireRank7` int NOT NULL DEFAULT '0',
  `SalaireRank8` int NOT NULL DEFAULT '0',
  `SalaireRank9` int NOT NULL DEFAULT '0',
  `SalaireRank10` int NOT NULL DEFAULT '0',
  `SalaireRank11` int NOT NULL DEFAULT '0',
  `SalaireRank12` int NOT NULL DEFAULT '0',
  `SalaireRank13` int NOT NULL DEFAULT '0',
  `SalaireRank14` int NOT NULL DEFAULT '0',
  `SalaireRank15` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `factorystock` (
  `id` int NOT NULL,
  `bois` int NOT NULL,
  `viande` int NOT NULL,
  `meuble` int NOT NULL,
  `central1` int NOT NULL,
  `central2` int NOT NULL,
  `central3` int NOT NULL,
  `central4` int NOT NULL,
  `central5` int NOT NULL,
  `electronic` int NOT NULL,
  `petrol` int NOT NULL,
  `essencegenerator` int NOT NULL,
  `boismeuble` int NOT NULL,
  `magasinstock` int NOT NULL,
  `dockstock` int NOT NULL,
  `manutentionnairestock` int NOT NULL,
  `caristestock` int NOT NULL,
  `minerstock` int NOT NULL,
  `armesstock` int NOT NULL,
  `frontbumper` int NOT NULL,
  `rearbumper` int NOT NULL,
  `roof` int NOT NULL,
  `hood` int NOT NULL,
  `spoiler` int NOT NULL,
  `sideskirt` int NOT NULL,
  `hydrolic` int NOT NULL,
  `roue` int NOT NULL,
  `caro` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



INSERT INTO `factorystock` (`id`, `bois`, `viande`, `meuble`, `central1`, `central2`, `central3`, `central4`, `central5`, `electronic`, `petrol`, `essencegenerator`, `boismeuble`, `magasinstock`, `dockstock`, `manutentionnairestock`, `caristestock`, `minerstock`, `armesstock`, `frontbumper`, `rearbumper`, `roof`, `hood`, `spoiler`, `sideskirt`, `hydrolic`, `roue`, `caro`) VALUES
(1, 98801, 98801,98801, 98801, 98801, 98801, 98801, 98801, 98801, 98801, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);



CREATE TABLE `furniture` (
  `ID` int DEFAULT '0',
  `furnitureID` int NOT NULL,
  `furnitureName` varchar(32) DEFAULT NULL,
  `furnitureModel` int DEFAULT '0',
  `furnitureX` float DEFAULT '0',
  `furnitureY` float DEFAULT '0',
  `furnitureZ` float DEFAULT '0',
  `furnitureRX` float DEFAULT '0',
  `furnitureRY` float DEFAULT '0',
  `furnitureRZ` float DEFAULT '0',
  `furnitureType` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `furnitures` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `model` int NOT NULL,
  `price` int NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `rot_x` float NOT NULL,
  `rot_y` float NOT NULL,
  `rot_z` float NOT NULL,
  `interior` int NOT NULL,
  `object_id` int NOT NULL,
  `world` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `garages` (
  `ID` int NOT NULL DEFAULT '1',
  `Owner` varchar(24) DEFAULT NULL,
  `Owned` tinyint NOT NULL DEFAULT '0',
  `eX` float NOT NULL DEFAULT '0',
  `eY` float NOT NULL DEFAULT '0',
  `eZ` float NOT NULL DEFAULT '0',
  `Price` int NOT NULL DEFAULT '0',
  `Size` tinyint NOT NULL,
  `portes` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `garbage` (
  `garbageID` int NOT NULL,
  `garbageModel` int DEFAULT '1236',
  `garbageCapacity` int DEFAULT '0',
  `garbageX` float DEFAULT '0',
  `garbageY` float DEFAULT '0',
  `garbageZ` float DEFAULT '0',
  `garbageA` float DEFAULT '0',
  `garbageInterior` int DEFAULT '0',
  `garbageWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `gates` (
  `gateID` int NOT NULL,
  `gateModel` int DEFAULT '0',
  `gateSpeed` float DEFAULT '0',
  `gateTime` int DEFAULT '0',
  `gateX` float DEFAULT '0',
  `gateY` float DEFAULT '0',
  `gateZ` float DEFAULT '0',
  `gateRX` float DEFAULT '0',
  `gateRY` float DEFAULT '0',
  `gateRZ` float DEFAULT '0',
  `gateInterior` int DEFAULT '0',
  `gateWorld` int DEFAULT '0',
  `gateMoveX` float DEFAULT '0',
  `gateMoveY` float DEFAULT '0',
  `gateMoveZ` float DEFAULT '0',
  `gateMoveRX` float DEFAULT '0',
  `gateMoveRY` float DEFAULT '0',
  `gateMoveRZ` float DEFAULT '0',
  `gateLinkID` int DEFAULT '0',
  `gateFaction` int DEFAULT '0',
  `gatePass` varchar(32) DEFAULT NULL,
  `gateRadius` float DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `gouvernement` (
  `id` int NOT NULL,
  `taxe` int NOT NULL,
  `taxerevenue` int NOT NULL,
  `taxeentreprise` int NOT NULL,
  `chomage` int NOT NULL,
  `subventionpolice` int NOT NULL,
  `subventionfbi` int NOT NULL,
  `subventionmedecin` int NOT NULL,
  `subventionswat` int NOT NULL,
  `aidebanque` int NOT NULL,
  `bizhouse` int NOT NULL,
  `maison` int NOT NULL,
  `magasin` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `gouvernement` (`id`, `taxe`, `taxerevenue`, `taxeentreprise`, `chomage`, `subventionpolice`, `subventionfbi`, `subventionmedecin`, `subventionswat`, `aidebanque`, `bizhouse`, `maison`, `magasin`) VALUES
(1, 10, 15, 85, 200, 0, 0, 0, 0, 0, 50, 45, 45);



CREATE TABLE `gps` (
  `ID` int DEFAULT '0',
  `locationID` int NOT NULL,
  `locationName` varchar(32) DEFAULT NULL,
  `locationX` float DEFAULT '0',
  `locationY` float DEFAULT '0',
  `locationZ` float DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



CREATE TABLE `graffiti` (
  `graffitiID` int NOT NULL,
  `graffitiX` float DEFAULT '0',
  `graffitiY` float DEFAULT '0',
  `graffitiZ` float DEFAULT '0',
  `graffitiAngle` float DEFAULT '0',
  `graffitiColor` int DEFAULT '0',
  `graffitiText` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;



--
-- Structure de la table `gunracks`
--

CREATE TABLE `gunracks` (
  `rackID` int NOT NULL,
  `rackHouse` int DEFAULT '0',
  `rackX` float DEFAULT '0',
  `rackY` float DEFAULT '0',
  `rackZ` float DEFAULT '0',
  `rackA` float DEFAULT '0',
  `rackInterior` int DEFAULT '0',
  `rackWorld` int DEFAULT '0',
  `rackWeapon1` int DEFAULT '0',
  `rackAmmo1` int DEFAULT '0',
  `rackWeapon2` int DEFAULT '0',
  `rackAmmo2` int DEFAULT '0',
  `rackWeapon3` int DEFAULT '0',
  `rackAmmo3` int DEFAULT '0',
  `rackWeapon4` int DEFAULT '0',
  `rackAmmo4` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `houses`
--

CREATE TABLE `houses` (
  `houseID` int NOT NULL,
  `houseOwner` int DEFAULT '0',
  `housePrice` int DEFAULT '0',
  `houseAddress` varchar(32) DEFAULT NULL,
  `housePosX` float DEFAULT '0',
  `housePosY` float DEFAULT '0',
  `housePosZ` float DEFAULT '0',
  `housePosA` float DEFAULT '0',
  `houseIntX` float DEFAULT '0',
  `houseIntY` float DEFAULT '0',
  `houseIntZ` float DEFAULT '0',
  `houseIntA` float DEFAULT '0',
  `houseInterior` int DEFAULT '0',
  `houseInteriorVW` int NOT NULL DEFAULT '0',
  `houseExterior` int DEFAULT '0',
  `houseExteriorVW` int DEFAULT '0',
  `houseLocked` int DEFAULT '0',
  `houseWeapon1` int DEFAULT '0',
  `houseAmmo1` int DEFAULT '0',
  `houseWeapon2` int DEFAULT '0',
  `houseAmmo2` int DEFAULT '0',
  `houseWeapon3` int DEFAULT '0',
  `houseAmmo3` int DEFAULT '0',
  `houseWeapon4` int DEFAULT '0',
  `houseAmmo4` int DEFAULT '0',
  `houseWeapon5` int DEFAULT '0',
  `houseAmmo5` int DEFAULT '0',
  `houseWeapon6` int DEFAULT '0',
  `houseAmmo6` int DEFAULT '0',
  `houseWeapon7` int DEFAULT '0',
  `houseAmmo7` int DEFAULT '0',
  `houseWeapon8` int DEFAULT '0',
  `houseAmmo8` int DEFAULT '0',
  `houseWeapon9` int DEFAULT '0',
  `houseAmmo9` int DEFAULT '0',
  `houseWeapon10` int DEFAULT '0',
  `houseAmmo10` int DEFAULT '0',
  `houseMoney` int DEFAULT '0',
  `houseLocation` int NOT NULL DEFAULT '0',
  `houseMaxLoc` int NOT NULL DEFAULT '0',
  `houseLocNum` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `housestorage`
--

CREATE TABLE `housestorage` (
  `ID` int DEFAULT '0',
  `itemID` int NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int DEFAULT '0',
  `itemQuantity` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `impoundlots`
--

CREATE TABLE `impoundlots` (
  `impoundID` int NOT NULL,
  `impoundLotX` float DEFAULT '0',
  `impoundLotY` float DEFAULT '0',
  `impoundLotZ` float DEFAULT '0',
  `impoundReleaseX` float DEFAULT '0',
  `impoundReleaseY` float DEFAULT '0',
  `impoundReleaseZ` float DEFAULT '0',
  `impoundReleaseInt` int DEFAULT '0',
  `impoundReleaseWorld` int DEFAULT '0',
  `impoundReleaseA` float DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `inventory`
--

CREATE TABLE `inventory` (
  `ID` int DEFAULT '0',
  `invID` int NOT NULL,
  `invItem` varchar(32) DEFAULT NULL,
  `invModel` int DEFAULT '0',
  `invQuantity` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `jobID` int NOT NULL,
  `jobPosX` float DEFAULT '0',
  `jobPosY` float DEFAULT '0',
  `jobPosZ` float DEFAULT '0',
  `jobPointX` float DEFAULT '0',
  `jobPointY` float DEFAULT '0',
  `jobPointZ` float DEFAULT '0',
  `jobDeliverX` float DEFAULT '0',
  `jobDeliverY` float DEFAULT '0',
  `jobDeliverZ` float DEFAULT '0',
  `jobInterior` int DEFAULT '0',
  `jobWorld` int DEFAULT '0',
  `jobType` int DEFAULT '0',
  `jobPointInt` int DEFAULT '0',
  `jobPointWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `namechanges`
--

CREATE TABLE `namechanges` (
  `ID` int NOT NULL,
  `OldName` varchar(24) DEFAULT NULL,
  `NewName` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `news`
--

CREATE TABLE `news` (
  `news_id` int NOT NULL,
  `news_name` text NOT NULL,
  `news_desc` text NOT NULL,
  `news_postedby` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `openworldmaison`
--

CREATE TABLE `openworldmaison` (
  `OpenWorldMID` int NOT NULL,
  `OpenWorldMModel` int NOT NULL DEFAULT '2000',
  `OpenWorldMX` float DEFAULT NULL,
  `OpenWorldMY` float DEFAULT NULL,
  `OpenWorldMZ` float DEFAULT NULL,
  `OpenWorldMRX` float DEFAULT NULL,
  `OpenWorldMRY` float DEFAULT NULL,
  `OpenWorldMRZ` float DEFAULT NULL,
  `OpenWorldMX1` float DEFAULT NULL,
  `OpenWorldMY1` float DEFAULT NULL,
  `OpenWorldMZ1` float DEFAULT NULL,
  `OpenWorldMRX1` float DEFAULT NULL,
  `OpenWorldMRY1` float DEFAULT NULL,
  `OpenWorldMRZ1` float DEFAULT NULL,
  `OpenWorldMOwner` int DEFAULT '-1',
  `OpenWorldMAddress` varchar(32) NOT NULL,
  `OpenWorldMPrice` int NOT NULL DEFAULT '1000',
  `OpenWorldMBoom` int NOT NULL DEFAULT '0',
  `OpenWorldMCommandX` float DEFAULT NULL,
  `OpenWorldMCommandY` float DEFAULT NULL,
  `OpenWorldMCommandZ` float DEFAULT NULL,
  `OpenWorldMCommandR` float DEFAULT NULL,
  `OpenWorldMLocked` int DEFAULT NULL,
  `OpenWorldMSpeed` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `plants`
--

CREATE TABLE `plants` (
  `plantID` int NOT NULL,
  `plantType` int DEFAULT '0',
  `plantDrugs` int DEFAULT '0',
  `plantX` float DEFAULT '0',
  `plantY` float DEFAULT '0',
  `plantZ` float DEFAULT '0',
  `plantA` float DEFAULT '0',
  `plantInterior` int DEFAULT '0',
  `plantWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




--
-- Structure de la table `pumps`
--

CREATE TABLE `pumps` (
  `ID` int DEFAULT '0',
  `pumpID` int NOT NULL,
  `pumpPosX` float DEFAULT '0',
  `pumpPosY` float DEFAULT '0',
  `pumpPosZ` float DEFAULT '0',
  `pumpPosA` float DEFAULT '0',
  `pumpFuel` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `salairefbi`
--

CREATE TABLE `salairefbi` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairefbi`
--

INSERT INTO `salairefbi` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);



--
-- Structure de la table `salairejob`
--

CREATE TABLE `salairejob` (
  `id` int DEFAULT '50',
  `salairecariste` int DEFAULT '50',
  `salairemanutentionnaire` int DEFAULT '50',
  `salairedock` int DEFAULT '50',
  `salairelaitier` int DEFAULT '50',
  `salaireminer` int DEFAULT '50',
  `salaireusineelectronic` int DEFAULT '50',
  `salairebucheron` int DEFAULT '50',
  `salairemenuisier` int DEFAULT '50',
  `salairegenerateur` int DEFAULT '50',
  `salaireelectricien` int DEFAULT '50',
  `salairearme` int DEFAULT '50',
  `salairepetrolier` int DEFAULT '50',
  `salaireboucher` int DEFAULT '50'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairejob`
--

INSERT INTO `salairejob` (`id`, `salairecariste`, `salairemanutentionnaire`, `salairedock`, `salairelaitier`, `salaireminer`, `salaireusineelectronic`, `salairebucheron`, `salairemenuisier`, `salairegenerateur`, `salaireelectricien`, `salairearme`, `salairepetrolier`, `salaireboucher`) VALUES
(1, 30, 60, 50, 18, 50, 50, 75, 50, 20, 75, 50, 75, 50);



--
-- Structure de la table `salairejournaliste`
--

CREATE TABLE `salairejournaliste` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairejournaliste`
--

INSERT INTO `salairejournaliste` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 700, 800, 1000, 1200, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);



--
-- Structure de la table `salairelivreurbiz`
--

CREATE TABLE `salairelivreurbiz` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairelivreurbiz`
--

INSERT INTO `salairelivreurbiz` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1000, 0, 1100, 1150, 1200, 1250, 1, 0, 0, 0, 0, 0, 0, 0, 0);



--
-- Structure de la table `salairemairie`
--

CREATE TABLE `salairemairie` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairemairie`
--

INSERT INTO `salairemairie` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 800, 850, 900, 950, 1050, 1100, 1150, 1200, 2500, 2500, 1350, 2400, 2500, 1200, 2500);



--
-- Structure de la table `salairemecano`
--

CREATE TABLE `salairemecano` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairemecano`
--

INSERT INTO `salairemecano` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 2000, 0, 0, 0, 0);



--
-- Structure de la table `salairepolice`
--

CREATE TABLE `salairepolice` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairepolice`
--

INSERT INTO `salairepolice` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1000, 1250, 1500, 1750, 2000, 2125, 2250, 2500, 2500, 2500, 2500, 2250, 2250, 2500, 2500);



--
-- Structure de la table `salaireswat`
--

CREATE TABLE `salaireswat` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salaireswat`
--

INSERT INTO `salaireswat` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);



--
-- Structure de la table `salaireurgentiste`
--

CREATE TABLE `salaireurgentiste` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salaireurgentiste`
--

INSERT INTO `salaireurgentiste` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1100, 1100, 1200, 1200, 1300, 1300, 1450, 1450, 1600, 1600, 1750, 1750, 1900, 1900, 2000);



--
-- Structure de la table `salairevendeurrue`
--

CREATE TABLE `salairevendeurrue` (
  `idfaction` int NOT NULL,
  `salairerang1` int DEFAULT '0',
  `salairerang2` int DEFAULT '0',
  `salairerang3` int DEFAULT '0',
  `salairerang4` int DEFAULT '0',
  `salairerang5` int DEFAULT '0',
  `salairerang6` int DEFAULT '0',
  `salairerang7` int DEFAULT '0',
  `salairerang8` int DEFAULT '0',
  `salairerang9` int DEFAULT '0',
  `salairerang10` int DEFAULT '0',
  `salairerang11` int DEFAULT '0',
  `salairerang12` int DEFAULT '0',
  `salairerang13` int DEFAULT '0',
  `salairerang14` int DEFAULT '0',
  `salairerang15` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `salairevendeurrue`
--

INSERT INTO `salairevendeurrue` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);



--
-- Structure de la table `serveursetting`
--

CREATE TABLE `serveursetting` (
  `id` int NOT NULL,
  `motd` varchar(128) NOT NULL DEFAULT '00',
  `afkactive` int DEFAULT '1',
  `afktime` int DEFAULT '0',
  `braquagenpcactive` int DEFAULT '0',
  `braquagebanqueactive` int DEFAULT '0',
  `oocactive` int DEFAULT '0',
  `pmactive` int DEFAULT '0',
  `villeactive` int NOT NULL DEFAULT '1',
  `nouveau` int NOT NULL,
  `police` int NOT NULL DEFAULT '0',
  `swat` int NOT NULL DEFAULT '0',
  `whiteliste` int NOT NULL DEFAULT '0',
  `discord` varchar(128) NOT NULL DEFAULT '0',
  `verifier` varchar(20) NOT NULL DEFAULT '0',
  `admin1` varchar(20) NOT NULL DEFAULT '0',
  `admin2` varchar(20) NOT NULL DEFAULT '0',
  `admin3` varchar(20) NOT NULL DEFAULT '0',
  `admin4` varchar(20) NOT NULL DEFAULT '0',
  `spawnpos1` float NOT NULL,
  `spawnpos2` float NOT NULL,
  `spawnpos3` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `serveursetting`
--

INSERT INTO `serveursetting` (`id`, `motd`, `afkactive`, `afktime`, `braquagenpcactive`, `braquagebanqueactive`, `oocactive`, `pmactive`, `villeactive`, `nouveau`, `police`, `swat`, `whiteliste`, `discord`, `verifier`, `admin1`, `admin2`, `admin3`, `admin4`, `spawnpos1`, `spawnpos2`, `spawnpos3`) VALUES
(1, 'Allo pédale', 1, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, '823231678008262677', '850527688048377856', '833499786866327552', '833499765555200070', '833499739294924840', '833499716616323083', 6089.5, -8328.9, 9.835);



--
-- Structure de la table `slotmachine`
--

CREATE TABLE `slotmachine` (
  `id` int NOT NULL,
  `X` float DEFAULT '0',
  `Y` float DEFAULT '0',
  `Z` float DEFAULT '0',
  `RX` float DEFAULT '0',
  `RY` float DEFAULT '0',
  `RZ` float DEFAULT '0',
  `slotint` float DEFAULT '0',
  `slotvw` float DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




--
-- Structure de la table `speedcameras`
--

CREATE TABLE `speedcameras` (
  `speedID` int NOT NULL,
  `speedRange` float DEFAULT '0',
  `speedLimit` float DEFAULT '0',
  `speedX` float DEFAULT '0',
  `speedY` float DEFAULT '0',
  `speedZ` float DEFAULT '0',
  `speedAngle` float DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `tickets`
--

CREATE TABLE `tickets` (
  `ID` int DEFAULT '0',
  `ticketID` int NOT NULL,
  `ticketFee` int DEFAULT '0',
  `ticketBy` varchar(24) DEFAULT NULL,
  `ticketDate` varchar(36) DEFAULT NULL,
  `ticketReason` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `vendors`
--

CREATE TABLE `vendors` (
  `vendorID` int NOT NULL,
  `vendorType` int DEFAULT '0',
  `vendorX` float DEFAULT '0',
  `vendorY` float DEFAULT '0',
  `vendorZ` float DEFAULT '0',
  `vendorA` float DEFAULT '0',
  `vendorInterior` int DEFAULT '0',
  `vendorWorld` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `votes`
--

CREATE TABLE `votes` (
  `Name` varchar(24) NOT NULL,
  `Votes` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Structure de la table `warrants`
--

CREATE TABLE `warrants` (
  `ID` int NOT NULL,
  `Suspect` varchar(24) DEFAULT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL,
  `Description` varchar(128) DEFAULT NULL,
  `IDchar` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `actors`
--
ALTER TABLE `actors`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Index pour la table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`atmID`);

--
-- Index pour la table `backpackitems`
--
ALTER TABLE `backpackitems`
  ADD PRIMARY KEY (`itemID`);

--
-- Index pour la table `backpacks`
--
ALTER TABLE `backpacks`
  ADD PRIMARY KEY (`backpackID`);

--
-- Index pour la table `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Index pour la table `bank_logs`
--
ALTER TABLE `bank_logs`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`),
  ADD KEY `bank_logs_ibfk_1` (`AccountID`);

--
-- Index pour la table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `batiements`
--
ALTER TABLE `batiements`
  ADD PRIMARY KEY (`batiementID`),
  ADD UNIQUE KEY `batiementID` (`batiementID`);

--
-- Index pour la table `billboards`
--
ALTER TABLE `billboards`
  ADD PRIMARY KEY (`bbID`);

--
-- Index pour la table `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`Username`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- Index pour la table `businesses`
--
ALTER TABLE `businesses`
  ADD UNIQUE KEY `bizID` (`bizID`),
  ADD UNIQUE KEY `bizID_2` (`bizID`);

--
-- Index pour la table `caisses`
--
ALTER TABLE `caisses`
  ADD PRIMARY KEY (`caisseID`),
  ADD KEY `caisseID` (`caisseID`);

--
-- Index pour la table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`carID`);

--
-- Index pour la table `carstorage`
--
ALTER TABLE `carstorage`
  ADD PRIMARY KEY (`itemID`);

--
-- Index pour la table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contactID`);

--
-- Index pour la table `crates`
--
ALTER TABLE `crates`
  ADD PRIMARY KEY (`crateID`);

--
-- Index pour la table `dealervehicles`
--
ALTER TABLE `dealervehicles`
  ADD PRIMARY KEY (`vehID`);

--
-- Index pour la table `death`
--
ALTER TABLE `death`
  ADD PRIMARY KEY (`dID`);

--
-- Index pour la table `detectors`
--
ALTER TABLE `detectors`
  ADD PRIMARY KEY (`detectorID`);

--
-- Index pour la table `dropped`
--
ALTER TABLE `dropped`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `entrances`
--
ALTER TABLE `entrances`
  ADD PRIMARY KEY (`entranceID`);

--
-- Index pour la table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`factionID`);

--
-- Index pour la table `factorystock`
--
ALTER TABLE `factorystock`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`furnitureID`);

--
-- Index pour la table `furnitures`
--
ALTER TABLE `furnitures`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `garages`
--
ALTER TABLE `garages`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Index pour la table `garbage`
--
ALTER TABLE `garbage`
  ADD PRIMARY KEY (`garbageID`);

--
-- Index pour la table `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`gateID`);

--
-- Index pour la table `gouvernement`
--
ALTER TABLE `gouvernement`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `gps`
--
ALTER TABLE `gps`
  ADD PRIMARY KEY (`locationID`);

--
-- Index pour la table `graffiti`
--
ALTER TABLE `graffiti`
  ADD PRIMARY KEY (`graffitiID`);

--
-- Index pour la table `gunracks`
--
ALTER TABLE `gunracks`
  ADD PRIMARY KEY (`rackID`);

--
-- Index pour la table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`houseID`);

--
-- Index pour la table `housestorage`
--
ALTER TABLE `housestorage`
  ADD PRIMARY KEY (`itemID`);

--
-- Index pour la table `impoundlots`
--
ALTER TABLE `impoundlots`
  ADD PRIMARY KEY (`impoundID`);

--
-- Index pour la table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`invID`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`jobID`);

--
-- Index pour la table `namechanges`
--
ALTER TABLE `namechanges`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`);

--
-- Index pour la table `openworldmaison`
--
ALTER TABLE `openworldmaison`
  ADD PRIMARY KEY (`OpenWorldMID`);

--
-- Index pour la table `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`plantID`);

--
-- Index pour la table `pumps`
--
ALTER TABLE `pumps`
  ADD PRIMARY KEY (`pumpID`);

--
-- Index pour la table `salairefbi`
--
ALTER TABLE `salairefbi`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairejob`
--
ALTER TABLE `salairejob`
  ADD KEY `id` (`id`);

--
-- Index pour la table `salairejournaliste`
--
ALTER TABLE `salairejournaliste`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairelivreurbiz`
--
ALTER TABLE `salairelivreurbiz`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairemairie`
--
ALTER TABLE `salairemairie`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairemecano`
--
ALTER TABLE `salairemecano`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairepolice`
--
ALTER TABLE `salairepolice`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salaireswat`
--
ALTER TABLE `salaireswat`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salaireurgentiste`
--
ALTER TABLE `salaireurgentiste`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairevendeurrue`
--
ALTER TABLE `salairevendeurrue`
  ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `serveursetting`
--
ALTER TABLE `serveursetting`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `verifier` (`verifier`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `slotmachine`
--
ALTER TABLE `slotmachine`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `speedcameras`
--
ALTER TABLE `speedcameras`
  ADD PRIMARY KEY (`speedID`);

--
-- Index pour la table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`ticketID`);

--
-- Index pour la table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`vendorID`);

--
-- Index pour la table `votes`
--
ALTER TABLE `votes`
  ADD UNIQUE KEY `Names` (`Name`);

--
-- Index pour la table `warrants`
--
ALTER TABLE `warrants`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `actors`
--
ALTER TABLE `actors`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `backpackitems`
--
ALTER TABLE `backpackitems`
  MODIFY `itemID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `backpacks`
--
ALTER TABLE `backpacks`
  MODIFY `backpackID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `bank_logs`
--
ALTER TABLE `bank_logs`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `batiements`
--
ALTER TABLE `batiements`
  MODIFY `batiementID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `billboards`
--
ALTER TABLE `billboards`
  MODIFY `bbID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `caisseID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `cars`
--
ALTER TABLE `cars`
  MODIFY `carID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `carstorage`
--
ALTER TABLE `carstorage`
  MODIFY `itemID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `characters`
--
ALTER TABLE `characters`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contactID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `crates`
--
ALTER TABLE `crates`
  MODIFY `crateID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `dealervehicles`
--
ALTER TABLE `dealervehicles`
  MODIFY `vehID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `death`
--
ALTER TABLE `death`
  MODIFY `dID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `detectors`
--
ALTER TABLE `detectors`
  MODIFY `detectorID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `dropped`
--
ALTER TABLE `dropped`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `entranceID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `factorystock`
--
ALTER TABLE `factorystock`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `furnitureID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `garbage`
--
ALTER TABLE `garbage`
  MODIFY `garbageID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gates`
--
ALTER TABLE `gates`
  MODIFY `gateID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gouvernement`
--
ALTER TABLE `gouvernement`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gps`
--
ALTER TABLE `gps`
  MODIFY `locationID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `graffiti`
--
ALTER TABLE `graffiti`
  MODIFY `graffitiID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `gunracks`
--
ALTER TABLE `gunracks`
  MODIFY `rackID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `houses`
--
ALTER TABLE `houses`
  MODIFY `houseID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `housestorage`
--
ALTER TABLE `housestorage`
  MODIFY `itemID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `impoundlots`
--
ALTER TABLE `impoundlots`
  MODIFY `impoundID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `invID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `jobID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `namechanges`
--
ALTER TABLE `namechanges`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `openworldmaison`
--
ALTER TABLE `openworldmaison`
  MODIFY `OpenWorldMID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `plants`
--
ALTER TABLE `plants`
  MODIFY `plantID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `pumps`
--
ALTER TABLE `pumps`
  MODIFY `pumpID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `salairefbi`
--
ALTER TABLE `salairefbi`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairejournaliste`
--
ALTER TABLE `salairejournaliste`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairelivreurbiz`
--
ALTER TABLE `salairelivreurbiz`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairemairie`
--
ALTER TABLE `salairemairie`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairemecano`
--
ALTER TABLE `salairemecano`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairepolice`
--
ALTER TABLE `salairepolice`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salaireswat`
--
ALTER TABLE `salaireswat`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salaireurgentiste`
--
ALTER TABLE `salaireurgentiste`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairevendeurrue`
--
ALTER TABLE `salairevendeurrue`
  MODIFY `idfaction` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `slotmachine`
--
ALTER TABLE `slotmachine`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `speedcameras`
--
ALTER TABLE `speedcameras`
  MODIFY `speedID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `ticketID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `vendorID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `warrants`
--
ALTER TABLE `warrants`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `bank_logs`
--
ALTER TABLE `bank_logs`
  ADD CONSTRAINT `bank_logs_ibfk_1` FOREIGN KEY (`AccountID`) REFERENCES `bank_accounts` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
