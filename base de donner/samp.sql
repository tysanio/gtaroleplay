-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : ven. 08 août 2025 à 05:39
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `u2_pcrwkusd98`
--

-- --------------------------------------------------------

--
-- Structure de la table `accounts`
--

CREATE TABLE `accounts` (
  `ID` int(11) NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Password` varchar(129) DEFAULT NULL,
  `RegisterDate` varchar(36) DEFAULT NULL,
  `LoginDate` varchar(36) DEFAULT NULL,
  `IP` varchar(16) DEFAULT 'n/a',
  `WL` int(11) NOT NULL DEFAULT 0,
  `Language` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `accounts`
--

-- --------------------------------------------------------

--
-- Structure de la table `actors`
--

CREATE TABLE `actors` (
  `ID` int(11) NOT NULL,
  `Skinid` int(11) NOT NULL DEFAULT 2,
  `Float` varchar(220) NOT NULL DEFAULT '0,0,0',
  `actorint` int(11) NOT NULL DEFAULT 0,
  `actorvw` int(11) NOT NULL DEFAULT 0,
  `actorsetting` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- --------------------------------------------------------

--
-- Structure de la table `arrestpoints`
--

CREATE TABLE `arrestpoints` (
  `arrestID` int(11) NOT NULL,
  `arrestX` float NOT NULL,
  `arrestY` float NOT NULL,
  `arrestZ` float NOT NULL,
  `arrestInterior` int(11) NOT NULL,
  `arrestWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `arrestpoints`
--

INSERT INTO `arrestpoints` (`arrestID`, `arrestX`, `arrestY`, `arrestZ`, `arrestInterior`, `arrestWorld`) VALUES
(1, 2281.73, 2430, 3.2734, 0, 0),
(2, 201.895, 168.194, 1003.02, 3, 1911),
(3, 248.706, 1361.08, 10.5859, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `atm`
--

CREATE TABLE `atm` (
  `atmID` int(11) NOT NULL,
  `atmX` float NOT NULL,
  `atmY` float NOT NULL,
  `atmZ` float NOT NULL,
  `atmA` float NOT NULL,
  `atmInterior` int(11) NOT NULL,
  `atmWorld` int(11) NOT NULL,
  `destroy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `backpackitems`
--

CREATE TABLE `backpackitems` (
  `ID` int(11) DEFAULT 0,
  `itemID` int(11) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(11) DEFAULT 0,
  `itemQuantity` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `backpacks`
--

CREATE TABLE `backpacks` (
  `backpackID` int(11) NOT NULL,
  `backpackPlayer` int(11) DEFAULT 0,
  `backpackX` float DEFAULT 0,
  `backpackY` float DEFAULT 0,
  `backpackZ` float DEFAULT 0,
  `backpackInterior` int(11) DEFAULT 0,
  `backpackWorld` int(11) DEFAULT 0,
  `backpackHouse` int(11) DEFAULT 0,
  `backpackVehicle` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `bankers`
--

CREATE TABLE `bankers` (
  `ID` int(11) NOT NULL,
  `Skin` smallint(6) NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `PosA` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Déchargement des données de la table `bankers`
--

INSERT INTO `bankers` (`ID`, `Skin`, `PosX`, `PosY`, `PosZ`, `PosA`) VALUES
(0, 150, 1425.67, -987.556, 996.105, 208.778),
(1, 147, 1425.88, -984.623, 996.11, 324.376);

-- --------------------------------------------------------

--
-- Structure de la table `bank_accounts`
--

CREATE TABLE `bank_accounts` (
  `ID` int(11) NOT NULL,
  `Owner` varchar(24) NOT NULL,
  `Password` varchar(32) NOT NULL,
  `Balance` int(11) NOT NULL,
  `CreatedOn` int(11) NOT NULL,
  `LastAccess` int(11) NOT NULL,
  `Disabled` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-

-- --------------------------------------------------------

--
-- Structure de la table `bank_atms`
--

CREATE TABLE `bank_atms` (
  `ID` int(11) NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `RotX` float NOT NULL,
  `RotY` float NOT NULL,
  `RotZ` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `bank_logs`
--

CREATE TABLE `bank_logs` (
  `ID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `ToAccountID` int(11) NOT NULL DEFAULT -1,
  `Type` smallint(6) NOT NULL,
  `Player` varchar(24) NOT NULL,
  `Amount` int(11) NOT NULL,
  `Date` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- --------------------------------------------------------

--
-- Structure de la table `banqueentreprise`
--

CREATE TABLE `banqueentreprise` (
  `id` int(11) NOT NULL,
  `mecanozone` int(11) NOT NULL,
  `livraisonzone1` int(11) NOT NULL,
  `mafiazone1` int(11) NOT NULL,
  `mafiazone4` int(11) NOT NULL,
  `police` int(11) NOT NULL,
  `fbi` int(11) NOT NULL,
  `swat` int(11) NOT NULL,
  `mairiels` int(11) NOT NULL,
  `medecin` int(11) NOT NULL,
  `fermier` int(11) NOT NULL,
  `vendeur` int(11) NOT NULL,
  `journaliste` int(11) NOT NULL,
  `banque` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- --------------------------------------------------------

--
-- Structure de la table `batiements`
--

CREATE TABLE `batiements` (
  `batiementID` int(11) NOT NULL,
  `batiementModel` int(11) DEFAULT 0,
  `batiementX` float DEFAULT 0,
  `batiementY` float DEFAULT 0,
  `batiementZ` float DEFAULT 0,
  `batiementRX` float DEFAULT 0,
  `batiementRY` float DEFAULT 0,
  `batiementRZ` float DEFAULT 0,
  `batiementInterior` int(11) DEFAULT 0,
  `batiementWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `billboards`
--

CREATE TABLE `billboards` (
  `bbID` int(11) NOT NULL,
  `bbExists` int(11) DEFAULT 0,
  `bbName` varchar(32) DEFAULT NULL,
  `bbOwner` int(11) NOT NULL DEFAULT 0,
  `bbPrice` int(11) NOT NULL DEFAULT 0,
  `bbRange` int(11) DEFAULT 10,
  `bbPosX` float DEFAULT 0,
  `bbPosY` float DEFAULT 0,
  `bbPosZ` float DEFAULT 0,
  `bbMessage` varchar(230) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- --------------------------------------------------------

--
-- Structure de la table `blacklist`
--

CREATE TABLE `blacklist` (
  `IP` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `Username` varchar(24) NOT NULL DEFAULT '',
  `BannedBy` varchar(24) DEFAULT NULL,
  `Reason` varchar(128) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `businesses`
--

CREATE TABLE `businesses` (
  `bizID` int(11) NOT NULL,
  `bizName` varchar(32) DEFAULT NULL,
  `bizOwner` int(11) DEFAULT 0,
  `bizType` int(11) DEFAULT 0,
  `bizPrice` int(11) DEFAULT 0,
  `bizPosX` float DEFAULT 0,
  `bizPosY` float DEFAULT 0,
  `bizPosZ` float DEFAULT 0,
  `bizPosA` float DEFAULT 0,
  `bizIntX` float DEFAULT 0,
  `bizIntY` float DEFAULT 0,
  `bizIntZ` float DEFAULT 0,
  `bizIntA` float DEFAULT 0,
  `bizInterior` int(11) DEFAULT 0,
  `bizInteriorVW` int(11) NOT NULL DEFAULT 0,
  `bizExterior` int(11) DEFAULT 0,
  `bizExteriorVW` int(11) DEFAULT 0,
  `bizLocked` int(11) DEFAULT 0,
  `bizVault` int(11) DEFAULT 0,
  `bizProducts` int(11) DEFAULT 0,
  `bizPrice1` int(11) DEFAULT 0,
  `bizPrice2` int(11) DEFAULT 0,
  `bizPrice3` int(11) DEFAULT 0,
  `bizPrice4` int(11) DEFAULT 0,
  `bizPrice5` int(11) DEFAULT 0,
  `bizPrice6` int(11) DEFAULT 0,
  `bizPrice7` int(11) DEFAULT 0,
  `bizPrice8` int(11) DEFAULT 0,
  `bizPrice9` int(11) DEFAULT 0,
  `bizPrice10` int(11) DEFAULT 0,
  `bizSpawnX` float DEFAULT 0,
  `bizSpawnY` float DEFAULT 0,
  `bizSpawnZ` float DEFAULT 0,
  `bizSpawnA` float DEFAULT 0,
  `bizDeliverX` float DEFAULT 0,
  `bizDeliverY` float DEFAULT 0,
  `bizDeliverZ` float DEFAULT 0,
  `bizMessage` varchar(128) DEFAULT NULL,
  `bizPrice11` int(11) DEFAULT 0,
  `bizPrice12` int(11) DEFAULT 0,
  `bizPrice13` int(11) DEFAULT 0,
  `bizPrice14` int(11) DEFAULT 0,
  `bizPrice15` int(11) DEFAULT 0,
  `bizPrice16` int(11) DEFAULT 0,
  `bizPrice17` int(11) DEFAULT 0,
  `bizPrice18` int(11) DEFAULT 0,
  `bizPrice19` int(11) DEFAULT 0,
  `bizPrice20` int(11) DEFAULT 0,
  `bizShipment` int(11) DEFAULT 0,
  `time1` int(11) NOT NULL DEFAULT -1,
  `time2` int(11) NOT NULL DEFAULT -1,
  `chancevole` int(11) NOT NULL DEFAULT 0,
  `defoncer` int(11) NOT NULL,
  `bizitemname1` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname2` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname3` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname4` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemname5` varchar(32) NOT NULL DEFAULT 'Aucun',
  `bizitemmodel1` int(11) NOT NULL DEFAULT -1,
  `bizitemmodel2` int(11) NOT NULL DEFAULT -1,
  `bizitemmodel3` int(11) NOT NULL DEFAULT -1,
  `bizitemmodel4` int(11) NOT NULL DEFAULT -1,
  `bizitemmodel5` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `caisses`
--

CREATE TABLE `caisses` (
  `caisseID` int(11) NOT NULL,
  `caisseX` float DEFAULT 0,
  `caisseY` float DEFAULT 0,
  `caisseZ` float DEFAULT 0,
  `caisseRX` float DEFAULT 0,
  `caisseRY` float DEFAULT 0,
  `caisseRZ` float DEFAULT 0,
  `caisseInterior` int(11) DEFAULT 0,
  `caisseWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `cars`
--

CREATE TABLE `cars` (
  `carID` int(11) NOT NULL,
  `carModel` int(11) DEFAULT 0,
  `carOwner` int(11) DEFAULT 0,
  `carPosX` float DEFAULT 0,
  `carPosY` float DEFAULT 0,
  `carPosZ` float DEFAULT 0,
  `carPosR` float DEFAULT 0,
  `carColor1` int(11) DEFAULT 0,
  `carColor2` int(11) DEFAULT 0,
  `carPaintjob` int(11) DEFAULT -1,
  `carLocked` int(11) DEFAULT 0,
  `carMod1` int(11) DEFAULT 0,
  `carMod2` int(11) DEFAULT 0,
  `carMod3` int(11) DEFAULT 0,
  `carMod4` int(11) DEFAULT 0,
  `carMod5` int(11) DEFAULT 0,
  `carMod6` int(11) DEFAULT 0,
  `carMod7` int(11) DEFAULT 0,
  `carMod8` int(11) DEFAULT 0,
  `carMod9` int(11) DEFAULT 0,
  `carMod10` int(11) DEFAULT 0,
  `carMod11` int(11) DEFAULT 0,
  `carMod12` int(11) DEFAULT 0,
  `carMod13` int(11) DEFAULT 0,
  `carMod14` int(11) DEFAULT 0,
  `carImpounded` int(11) DEFAULT 0,
  `carWeapon1` int(11) DEFAULT 0,
  `carAmmo1` int(11) DEFAULT 0,
  `carWeapon2` int(11) DEFAULT 0,
  `carAmmo2` int(11) DEFAULT 0,
  `carWeapon3` int(11) DEFAULT 0,
  `carAmmo3` int(11) DEFAULT 0,
  `carWeapon4` int(11) DEFAULT 0,
  `carAmmo4` int(11) DEFAULT 0,
  `carWeapon5` int(11) DEFAULT 0,
  `carAmmo5` int(11) DEFAULT 0,
  `carImpoundPrice` int(11) DEFAULT 0,
  `carFaction` int(11) DEFAULT 0,
  `carLoca` int(11) NOT NULL DEFAULT -1,
  `carLocaID` int(11) NOT NULL DEFAULT -1,
  `carDouble` int(11) NOT NULL DEFAULT -1,
  `carSabot` int(11) NOT NULL DEFAULT -1,
  `carSabPri` int(11) NOT NULL DEFAULT -1,
  `vkilometres` float NOT NULL DEFAULT 0,
  `vmetre` int(11) NOT NULL DEFAULT 0,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `carvie` float NOT NULL DEFAULT 1000,
  `alarme` int(11) NOT NULL DEFAULT 1,
  `boitier` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `cars`
--


CREATE TABLE `carstorage` (
  `ID` int(11) DEFAULT 0,
  `itemID` int(11) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(11) DEFAULT 0,
  `itemQuantity` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `characters`
--

CREATE TABLE `characters` (
  `ID` int(11) NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Character` varchar(24) DEFAULT NULL,
  `Created` int(11) DEFAULT 0,
  `Gender` int(11) DEFAULT 0,
  `Birthdate` varchar(32) DEFAULT '01/01/1970',
  `Origin` varchar(32) DEFAULT 'Not Specified',
  `Skin` int(11) DEFAULT 0,
  `Glasses` int(11) DEFAULT 0,
  `Hat` int(11) DEFAULT 0,
  `Bandana` int(11) DEFAULT 0,
  `PosX` float DEFAULT 0,
  `PosY` float DEFAULT 0,
  `PosZ` float DEFAULT 0,
  `PosA` float DEFAULT 0,
  `Interior` int(11) DEFAULT 0,
  `World` int(11) DEFAULT 0,
  `GlassesPos` varchar(100) DEFAULT NULL,
  `HatPos` varchar(100) DEFAULT NULL,
  `BandanaPos` varchar(100) DEFAULT NULL,
  `Hospital` int(11) DEFAULT -1,
  `HospitalInt` int(11) DEFAULT 0,
  `Money` int(11) DEFAULT 0,
  `BankMoney` int(11) DEFAULT 0,
  `OwnsBillboard` int(11) DEFAULT -1,
  `Savings` int(11) DEFAULT 0,
  `Admin` int(11) DEFAULT 0,
  `JailTime` int(11) DEFAULT 0,
  `Muted` int(11) DEFAULT 0,
  `CreateDate` int(11) DEFAULT 0,
  `LastLogin` int(11) DEFAULT 0,
  `Tester` int(11) DEFAULT 0,
  `Gun1` int(11) DEFAULT 0,
  `Gun2` int(11) DEFAULT 0,
  `Gun3` int(11) DEFAULT 0,
  `Gun4` int(11) DEFAULT 0,
  `Gun5` int(11) DEFAULT 0,
  `Gun6` int(11) DEFAULT 0,
  `Gun7` int(11) DEFAULT 0,
  `Gun8` int(11) DEFAULT 0,
  `Gun9` int(11) DEFAULT 0,
  `Gun10` int(11) DEFAULT 0,
  `Gun11` int(11) DEFAULT 0,
  `Gun12` int(11) DEFAULT 0,
  `Gun13` int(11) DEFAULT 0,
  `Ammo1` int(11) DEFAULT 0,
  `Ammo2` int(11) DEFAULT 0,
  `Ammo3` int(11) DEFAULT 0,
  `Ammo4` int(11) DEFAULT 0,
  `Ammo5` int(11) DEFAULT 0,
  `Ammo6` int(11) DEFAULT 0,
  `Ammo7` int(11) DEFAULT 0,
  `Ammo8` int(11) DEFAULT 0,
  `Ammo9` int(11) DEFAULT 0,
  `Ammo10` int(11) DEFAULT 0,
  `Ammo11` int(11) DEFAULT 0,
  `Ammo12` int(11) DEFAULT 0,
  `Ammo13` int(11) DEFAULT 0,
  `House` int(11) DEFAULT -1,
  `Business` int(11) DEFAULT -1,
  `Phone` int(11) DEFAULT 0,
  `Lottery` int(11) DEFAULT 0,
  `Hunger` int(11) DEFAULT 100,
  `Thirst` int(11) DEFAULT 100,
  `PlayingHours` int(11) DEFAULT 0,
  `Minutes` int(11) DEFAULT 0,
  `ArmorStatus` float DEFAULT 0,
  `Entrance` int(11) DEFAULT 0,
  `Job` int(11) DEFAULT 0,
  `Faction` int(11) DEFAULT -1,
  `FactionRank` int(11) DEFAULT 0,
  `Prisoned` int(11) DEFAULT 0,
  `Warrants` int(11) DEFAULT 0,
  `Injured` int(11) DEFAULT 0,
  `Health` float DEFAULT 0,
  `Channel` int(11) DEFAULT 0,
  `Accent` varchar(24) DEFAULT NULL,
  `Bleeding` int(11) DEFAULT 0,
  `Warnings` int(11) DEFAULT 0,
  `Warn1` varchar(32) DEFAULT NULL,
  `Warn2` varchar(32) DEFAULT NULL,
  `MaskID` int(11) DEFAULT 0,
  `FactionMod` int(11) DEFAULT 0,
  `Capacity` int(11) DEFAULT 35,
  `AdminHide` int(11) DEFAULT 0,
  `LotteryB` int(11) DEFAULT NULL,
  `SpawnPoint` int(11) DEFAULT NULL,
  `connecter` int(11) NOT NULL DEFAULT 0,
  `bracelet` int(11) NOT NULL DEFAULT 0,
  `braceletdist` int(11) NOT NULL DEFAULT 0,
  `LocaID` int(11) NOT NULL DEFAULT 0,
  `CarD` int(11) NOT NULL DEFAULT -1,
  `LocaMaisonID` int(11) NOT NULL DEFAULT 0,
  `baterietel` int(11) NOT NULL DEFAULT 20,
  `BestScore` int(11) NOT NULL DEFAULT 0,
  `Strike` int(11) NOT NULL DEFAULT 0,
  `Repetition` int(11) NOT NULL DEFAULT 0,
  `Parcouru` int(11) NOT NULL DEFAULT 0,
  `Noob` int(11) NOT NULL DEFAULT 1,
  `ZombieKill` int(11) NOT NULL DEFAULT 0,
  `skill0` int(11) NOT NULL DEFAULT 0,
  `skill1` int(11) NOT NULL DEFAULT 0,
  `skill2` int(11) NOT NULL DEFAULT 0,
  `skill3` int(11) NOT NULL DEFAULT 0,
  `skill4` int(11) NOT NULL DEFAULT 0,
  `skill5` int(11) NOT NULL DEFAULT 0,
  `skill6` int(11) NOT NULL DEFAULT 0,
  `skill7` int(11) NOT NULL DEFAULT 0,
  `skill8` int(11) NOT NULL DEFAULT 0,
  `skill9` int(11) NOT NULL DEFAULT 0,
  `skill10` int(11) NOT NULL DEFAULT 0,
  `DA` int(11) NOT NULL DEFAULT 0,
  `Death` int(11) NOT NULL DEFAULT 0,
  `Role` varchar(20) NOT NULL DEFAULT '0',
  `Combat` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


--
-- Structure de la table `contacts`
--

CREATE TABLE `contacts` (
  `ID` int(11) DEFAULT 0,
  `contactID` int(11) NOT NULL,
  `contactName` varchar(32) DEFAULT NULL,
  `contactNumber` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `crates`
--

CREATE TABLE `crates` (
  `crateID` int(11) NOT NULL,
  `crateType` int(11) DEFAULT 0,
  `crateX` float DEFAULT 0,
  `crateY` float DEFAULT 0,
  `crateZ` float DEFAULT 0,
  `crateA` float DEFAULT 0,
  `crateInterior` int(11) DEFAULT 0,
  `crateWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `dealervehicles`
--

CREATE TABLE `dealervehicles` (
  `ID` int(11) DEFAULT 0,
  `vehID` int(11) NOT NULL,
  `vehModel` int(11) DEFAULT 0,
  `vehPrice` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `death`
--

CREATE TABLE `death` (
  `dID` int(11) NOT NULL,
  `dName` varchar(32) NOT NULL,
  `dDate` varchar(36) NOT NULL DEFAULT '10/10/2020'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `detectors`
--

CREATE TABLE `detectors` (
  `detectorID` int(11) NOT NULL,
  `detectorX` float DEFAULT 0,
  `detectorY` float DEFAULT 0,
  `detectorZ` float DEFAULT 0,
  `detectorAngle` float DEFAULT 0,
  `detectorInterior` int(11) DEFAULT 0,
  `detectorWorld` int(11) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- --------------------------------------------------------

--
-- Structure de la table `dropped`
--

CREATE TABLE `dropped` (
  `ID` int(11) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(11) DEFAULT 0,
  `itemX` float DEFAULT 0,
  `itemY` float DEFAULT 0,
  `itemZ` float DEFAULT 0,
  `itemInt` int(11) DEFAULT 0,
  `itemWorld` int(11) DEFAULT 0,
  `itemQuantity` int(11) DEFAULT 0,
  `itemAmmo` int(11) DEFAULT 0,
  `itemWeapon` int(11) DEFAULT 0,
  `itemPlayer` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- --------------------------------------------------------

--
-- Structure de la table `entrances`
--

CREATE TABLE `entrances` (
  `entranceID` int(11) NOT NULL,
  `entranceName` varchar(32) DEFAULT NULL,
  `entranceIcon` int(11) DEFAULT 0,
  `entrancePosX` float DEFAULT 0,
  `entrancePosY` float DEFAULT 0,
  `entrancePosZ` float DEFAULT 0,
  `entrancePosA` float DEFAULT 0,
  `entranceIntX` float DEFAULT 0,
  `entranceIntY` float DEFAULT 0,
  `entranceIntZ` float DEFAULT 0,
  `entranceIntA` float DEFAULT 0,
  `entranceInterior` int(11) DEFAULT 0,
  `entranceExterior` int(11) DEFAULT 0,
  `entranceExteriorVW` int(11) DEFAULT 0,
  `entranceType` int(11) DEFAULT 0,
  `entrancePass` varchar(32) DEFAULT NULL,
  `entranceLocked` int(11) DEFAULT 0,
  `entranceCustom` int(11) DEFAULT 0,
  `entranceWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `entrances`
--

INSERT INTO `entrances` (`entranceID`, `entranceName`, `entranceIcon`, `entrancePosX`, `entrancePosY`, `entrancePosZ`, `entrancePosA`, `entranceIntX`, `entranceIntY`, `entranceIntZ`, `entranceIntA`, `entranceInterior`, `entranceExterior`, `entranceExteriorVW`, `entranceType`, `entrancePass`, `entranceLocked`, `entranceCustom`, `entranceWorld`) VALUES
(1, 'Auto-Ecole', 55, 8275.33, 6775.67, 26.1309, 98.3338, -2029.55, -118.8, 1035.17, 0, 3, 0, 0, 1, '', 1, 0, 7002),
(2, 'Mairie', 35, 8345.08, 7287.44, 29.1442, 183.128, -501.114, 286.605, 2001.09, 3.6551, 1, 0, 0, 4, '', 0, 1, 7005),
(3, 'Abatoire', 0, 9556, 7441.25, 14.5812, 105.241, 964.355, 2107.85, 1011.03, 90.1714, 1, 0, 0, 0, '', 0, 1, 7027),
(4, 'Cariste', 0, 9717.27, 7560.78, 11.3857, 105.241, 1291.82, 5.8713, 1001.01, 180, 18, 0, 0, 3, '', 0, 1, 7028),
(5, 'Usine', 0, 9745.11, 7565.16, 11.3848, 105.241, 2569.84, -1301.05, 1044.95, 109.236, 2, 0, 0, 0, '', 0, 1, -1),
(6, 'Salle des machines', 0, 9782.14, 7482.69, 11.3815, 105.241, -959.501, 1954.76, 9, 183.219, 17, 0, 0, 0, '', 0, 1, 0),
(7, 'Central éléctrique', 0, 9462.82, 7346.25, 14.6616, 105.241, 813.416, -69.8078, 1000.78, 75.4156, 1, 0, 0, 0, '', 0, 1, 7031),
(8, 'Banque Riche', 52, 8221.88, 7577.17, 26.0303, 349.522, 1456.19, -987.942, 996.105, 90, 6, 0, 0, 2, '', 0, 0, 0),
(9, 'Casino', 25, 8711.65, 6835.81, 26.0984, 309.799, -251.957, -21.1578, 1004.69, 90, 3, 0, 0, 6, '', 0, 1, 7034),
(10, 'Taxi', 0, 9506.99, 7509.53, 14.7214, 151.389, -1972.14, -897.436, 757.898, 270.44, 1, 0, 0, 0, '', 0, 1, 7035),
(11, 'Shooting Range', 0, 9512.36, 7306.96, 14.9311, 185.643, 304.017, -141.989, 1004.06, 90, 7, 0, 0, 5, '', 0, 0, 7036),
(12, 'Bowling', 0, 9234.94, 7557.16, 14.9299, 275.624, -1992.71, 407.999, 2.5009, 262.852, 1, 0, 0, 9, '', 0, 1, 7038),
(13, 'Entrepôt', 0, 9553.94, 7417.83, 14.5807, 151.389, 2606.47, -1233.46, 1022.03, 272.707, 1, 0, 0, 0, '', 0, 1, 7039),
(14, 'Gymnase', 0, 8340.34, 7238.82, 26.1047, 175.819, 772.428, -5.4299, 1000.73, 356.914, 5, 0, 0, 0, '', 0, 0, 7051),
(15, 'PMU', 0, 8230.22, 7293.32, 26.1045, 173.566, 833.491, 7.3242, 1003.52, 90, 3, 0, 0, 7, '', 0, 0, 7059),
(16, 'Usine de meubles', 0, 9354.84, 7280.02, 14.889, 178.563, 1626.63, -1811.32, 1013.43, 90.6977, 210, 0, 0, 0, '', 0, 0, 7064),
(17, 'Fabrique d\'arme', 0, 9444.31, 7208.75, 14.8057, 328.117, 2332.91, 5.5956, 1026.5, 92.287, 1, 0, 0, 0, '', 0, 1, 1),
(18, 'Bureau de la Fourriere', 0, 9521.96, 8158.29, 14.8414, 4.9436, 441.11, 132.703, 1008.4, 171.598, 0, 0, 0, 0, '', 0, 0, 7092),
(19, 'Event 1', 0, 8231.24, 8030.5, 29.7867, 357.473, 2742.59, -1743.47, 822.821, 160.122, 0, 0, 0, 0, '', 0, 2, 100),
(20, 'San News', 36, 9255.23, 8200.64, 7.4053, 260.089, 304.122, 1894.16, 904.376, 182.331, 15, 0, 0, 0, '', 0, 0, 7095),
(21, 'LCPD', 0, 8590.55, 7130.44, 25.9407, 357.448, 238.924, 139.68, 1003.02, 3.6593, 3, 0, 0, 8, '', 0, 0, 1911),
(22, 'A.N.P.E', 0, 8275.31, 6761.53, 26.1309, 96.4279, 316.874, 119.304, 1011.76, 9.612, 1, 0, 0, 10, '', 0, 1, 0),

-- --------------------------------------------------------

--
-- Structure de la table `factions`
--

CREATE TABLE `factions` (
  `factionID` int(11) NOT NULL,
  `factionName` varchar(32) DEFAULT NULL,
  `factionRanks` int(11) DEFAULT 0,
  `factionLockerX` float DEFAULT 0,
  `factionLockerY` float DEFAULT 0,
  `factionLockerZ` float DEFAULT 0,
  `factionLockerInt` int(11) DEFAULT 0,
  `factionLockerWorld` int(11) DEFAULT 0,
  `factioncoffre` int(11) NOT NULL DEFAULT 0,
  `factiondiscord` varchar(20) NOT NULL DEFAULT '0',
  `factionrole` varchar(20) NOT NULL DEFAULT '0',
  `factionaction1X` float NOT NULL DEFAULT 0,
  `factionaction1Y` float NOT NULL DEFAULT 0,
  `factionaction1Z` float NOT NULL DEFAULT 0,
  `factionaction1R` float NOT NULL DEFAULT 0,
  `factionaction2X` float NOT NULL DEFAULT 0,
  `factionaction2Y` float NOT NULL DEFAULT 0,
  `factionaction2Z` float NOT NULL DEFAULT 0,
  `factionaction2R` float DEFAULT 0,
  `factionaction3X` float NOT NULL DEFAULT 0,
  `factionaction3Y` float NOT NULL DEFAULT 0,
  `factionaction3Z` float NOT NULL DEFAULT 0,
  `factionaction3R` float NOT NULL DEFAULT 0,
  `factionWeapon1` int(11) DEFAULT 0,
  `factionAmmo1` int(11) DEFAULT 0,
  `factionWeapon2` int(11) DEFAULT 0,
  `factionAmmo2` int(11) DEFAULT 0,
  `factionWeapon3` int(11) DEFAULT 0,
  `factionAmmo3` int(11) DEFAULT 0,
  `factionWeapon4` int(11) DEFAULT 0,
  `factionAmmo4` int(11) DEFAULT 0,
  `factionWeapon5` int(11) DEFAULT 0,
  `factionAmmo5` int(11) DEFAULT 0,
  `factionWeapon6` int(11) DEFAULT 0,
  `factionAmmo6` int(11) DEFAULT 0,
  `factionWeapon7` int(11) DEFAULT 0,
  `factionAmmo7` int(11) DEFAULT 0,
  `factionWeapon8` int(11) DEFAULT 0,
  `factionAmmo8` int(11) DEFAULT 0,
  `factionWeapon9` int(11) DEFAULT 0,
  `factionAmmo9` int(11) DEFAULT 0,
  `factionWeapon10` int(11) DEFAULT 0,
  `factionAmmo10` int(11) DEFAULT 0,
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
  `factionSkin1` int(11) DEFAULT 0,
  `factionSkin2` int(11) DEFAULT 0,
  `factionSkin3` int(11) DEFAULT 0,
  `factionSkin4` int(11) DEFAULT 0,
  `factionSkin5` int(11) DEFAULT 0,
  `factionSkin6` int(11) DEFAULT 0,
  `factionSkin7` int(11) DEFAULT 0,
  `factionSkin8` int(11) DEFAULT 0,
  `factionacces1` int(11) NOT NULL DEFAULT 0,
  `factionacces2` int(11) NOT NULL DEFAULT 0,
  `factionacces3` int(11) NOT NULL DEFAULT 0,
  `factionacces4` int(11) NOT NULL DEFAULT 0,
  `factionacces5` int(11) NOT NULL DEFAULT 0,
  `factionacces6` int(11) NOT NULL DEFAULT 0,
  `factionacces7` int(11) NOT NULL DEFAULT 0,
  `factionacces8` int(11) NOT NULL DEFAULT 0,
  `factionacces9` int(11) NOT NULL DEFAULT 0,
  `factionacces10` int(11) NOT NULL DEFAULT 0,
  `factionacces11` int(11) NOT NULL DEFAULT 0,
  `factionacces12` int(11) NOT NULL DEFAULT 0,
  `factionacces13` int(11) NOT NULL DEFAULT 0,
  `factionacces14` int(11) NOT NULL DEFAULT 0,
  `factionacces15` int(11) NOT NULL DEFAULT 0,
  `SalaireRank1` int(11) NOT NULL DEFAULT 0,
  `SalaireRank2` int(11) NOT NULL DEFAULT 0,
  `SalaireRank3` int(11) NOT NULL DEFAULT 0,
  `SalaireRank4` int(11) NOT NULL DEFAULT 0,
  `SalaireRank5` int(11) NOT NULL DEFAULT 0,
  `SalaireRank6` int(11) NOT NULL DEFAULT 0,
  `SalaireRank7` int(11) NOT NULL DEFAULT 0,
  `SalaireRank8` int(11) NOT NULL DEFAULT 0,
  `SalaireRank9` int(11) NOT NULL DEFAULT 0,
  `SalaireRank10` int(11) NOT NULL DEFAULT 0,
  `SalaireRank11` int(11) NOT NULL DEFAULT 0,
  `SalaireRank12` int(11) NOT NULL DEFAULT 0,
  `SalaireRank13` int(11) NOT NULL DEFAULT 0,
  `SalaireRank14` int(11) NOT NULL DEFAULT 0,
  `SalaireRank15` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- --------------------------------------------------------

--
-- Structure de la table `factorystock`
--

CREATE TABLE `factorystock` (
  `id` int(11) NOT NULL,
  `bois` int(11) NOT NULL,
  `viande` int(11) NOT NULL,
  `meuble` int(11) NOT NULL,
  `central1` int(11) NOT NULL,
  `central2` int(11) NOT NULL,
  `central3` int(11) NOT NULL,
  `central4` int(11) NOT NULL,
  `central5` int(11) NOT NULL,
  `electronic` int(11) NOT NULL,
  `petrol` int(11) NOT NULL,
  `essencegenerator` int(11) NOT NULL,
  `boismeuble` int(11) NOT NULL,
  `magasinstock` int(11) NOT NULL,
  `dockstock` int(11) NOT NULL,
  `manutentionnairestock` int(11) NOT NULL,
  `caristestock` int(11) NOT NULL,
  `minerstock` int(11) NOT NULL,
  `armesstock` int(11) NOT NULL,
  `frontbumper` int(11) NOT NULL,
  `rearbumper` int(11) NOT NULL,
  `roof` int(11) NOT NULL,
  `hood` int(11) NOT NULL,
  `spoiler` int(11) NOT NULL,
  `sideskirt` int(11) NOT NULL,
  `hydrolic` int(11) NOT NULL,
  `roue` int(11) NOT NULL,
  `caro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `factorystock`
--

INSERT INTO `factorystock` (`id`, `bois`, `viande`, `meuble`, `central1`, `central2`, `central3`, `central4`, `central5`, `electronic`, `petrol`, `essencegenerator`, `boismeuble`, `magasinstock`, `dockstock`, `manutentionnairestock`, `caristestock`, `minerstock`, `armesstock`, `frontbumper`, `rearbumper`, `roof`, `hood`, `spoiler`, `sideskirt`, `hydrolic`, `roue`, `caro`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `furniture`
--

CREATE TABLE `furniture` (
  `ID` int(11) DEFAULT 0,
  `furnitureID` int(11) NOT NULL,
  `furnitureName` varchar(32) DEFAULT NULL,
  `furnitureModel` int(11) DEFAULT 0,
  `furnitureX` float DEFAULT 0,
  `furnitureY` float DEFAULT 0,
  `furnitureZ` float DEFAULT 0,
  `furnitureRX` float DEFAULT 0,
  `furnitureRY` float DEFAULT 0,
  `furnitureRZ` float DEFAULT 0,
  `furnitureType` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `furnitures`
--

CREATE TABLE `furnitures` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `model` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `rot_x` float NOT NULL,
  `rot_y` float NOT NULL,
  `rot_z` float NOT NULL,
  `interior` int(11) NOT NULL,
  `object_id` int(11) NOT NULL,
  `world` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `garages`
--

CREATE TABLE `garages` (
  `ID` int(11) NOT NULL DEFAULT 1,
  `Owner` varchar(24) DEFAULT NULL,
  `Owned` tinyint(4) NOT NULL DEFAULT 0,
  `eX` float NOT NULL DEFAULT 0,
  `eY` float NOT NULL DEFAULT 0,
  `eZ` float NOT NULL DEFAULT 0,
  `Price` int(11) NOT NULL DEFAULT 0,
  `Size` tinyint(4) NOT NULL,
  `portes` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `garbage`
--

CREATE TABLE `garbage` (
  `garbageID` int(11) NOT NULL,
  `garbageModel` int(11) DEFAULT 1236,
  `garbageCapacity` int(11) DEFAULT 0,
  `garbageX` float DEFAULT 0,
  `garbageY` float DEFAULT 0,
  `garbageZ` float DEFAULT 0,
  `garbageA` float DEFAULT 0,
  `garbageInterior` int(11) DEFAULT 0,
  `garbageWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gates`
--

CREATE TABLE `gates` (
  `gateID` int(11) NOT NULL,
  `gateModel` int(11) DEFAULT 0,
  `gateSpeed` float DEFAULT 0,
  `gateTime` int(11) DEFAULT 0,
  `gateX` float DEFAULT 0,
  `gateY` float DEFAULT 0,
  `gateZ` float DEFAULT 0,
  `gateRX` float DEFAULT 0,
  `gateRY` float DEFAULT 0,
  `gateRZ` float DEFAULT 0,
  `gateInterior` int(11) DEFAULT 0,
  `gateWorld` int(11) DEFAULT 0,
  `gateMoveX` float DEFAULT 0,
  `gateMoveY` float DEFAULT 0,
  `gateMoveZ` float DEFAULT 0,
  `gateMoveRX` float DEFAULT 0,
  `gateMoveRY` float DEFAULT 0,
  `gateMoveRZ` float DEFAULT 0,
  `gateLinkID` int(11) DEFAULT 0,
  `gateFaction` int(11) DEFAULT 0,
  `gatePass` varchar(32) DEFAULT NULL,
  `gateRadius` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gouvernement`
--

CREATE TABLE `gouvernement` (
  `id` int(11) NOT NULL,
  `taxe` int(11) NOT NULL,
  `taxerevenue` int(11) NOT NULL,
  `taxeentreprise` int(11) NOT NULL,
  `chomage` int(11) NOT NULL,
  `subventionpolice` int(11) NOT NULL,
  `subventionfbi` int(11) NOT NULL,
  `subventionmedecin` int(11) NOT NULL,
  `subventionswat` int(11) NOT NULL,
  `aidebanque` int(11) NOT NULL,
  `bizhouse` int(11) NOT NULL,
  `maison` int(11) NOT NULL,
  `magasin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `gouvernement`
--

INSERT INTO `gouvernement` (`id`, `taxe`, `taxerevenue`, `taxeentreprise`, `chomage`, `subventionpolice`, `subventionfbi`, `subventionmedecin`, `subventionswat`, `aidebanque`, `bizhouse`, `maison`, `magasin`) VALUES
(1, 10, 15, 85, 200, 0, 0, 0, 0, 0, 50, 45, 45);

-- --------------------------------------------------------

--
-- Structure de la table `gps`
--

CREATE TABLE `gps` (
  `ID` int(11) DEFAULT 0,
  `locationID` int(11) NOT NULL,
  `locationName` varchar(32) DEFAULT NULL,
  `locationX` float DEFAULT 0,
  `locationY` float DEFAULT 0,
  `locationZ` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `graffiti`
--

CREATE TABLE `graffiti` (
  `graffitiID` int(11) NOT NULL,
  `graffitiX` float DEFAULT 0,
  `graffitiY` float DEFAULT 0,
  `graffitiZ` float DEFAULT 0,
  `graffitiAngle` float DEFAULT 0,
  `graffitiColor` int(11) DEFAULT 0,
  `graffitiText` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `gunracks`
--

CREATE TABLE `gunracks` (
  `rackID` int(11) NOT NULL,
  `rackHouse` int(11) DEFAULT 0,
  `rackX` float DEFAULT 0,
  `rackY` float DEFAULT 0,
  `rackZ` float DEFAULT 0,
  `rackA` float DEFAULT 0,
  `rackInterior` int(11) DEFAULT 0,
  `rackWorld` int(11) DEFAULT 0,
  `rackWeapon1` int(11) DEFAULT 0,
  `rackAmmo1` int(11) DEFAULT 0,
  `rackWeapon2` int(11) DEFAULT 0,
  `rackAmmo2` int(11) DEFAULT 0,
  `rackWeapon3` int(11) DEFAULT 0,
  `rackAmmo3` int(11) DEFAULT 0,
  `rackWeapon4` int(11) DEFAULT 0,
  `rackAmmo4` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `houses`
--

CREATE TABLE `houses` (
  `houseID` int(11) NOT NULL,
  `houseOwner` int(11) DEFAULT 0,
  `housePrice` int(11) DEFAULT 0,
  `houseAddress` varchar(32) DEFAULT NULL,
  `housePosX` float DEFAULT 0,
  `housePosY` float DEFAULT 0,
  `housePosZ` float DEFAULT 0,
  `housePosA` float DEFAULT 0,
  `houseIntX` float DEFAULT 0,
  `houseIntY` float DEFAULT 0,
  `houseIntZ` float DEFAULT 0,
  `houseIntA` float DEFAULT 0,
  `houseInterior` int(11) DEFAULT 0,
  `houseInteriorVW` int(11) NOT NULL DEFAULT 0,
  `houseExterior` int(11) DEFAULT 0,
  `houseExteriorVW` int(11) DEFAULT 0,
  `houseLocked` int(11) DEFAULT 0,
  `houseWeapon1` int(11) DEFAULT 0,
  `houseAmmo1` int(11) DEFAULT 0,
  `houseWeapon2` int(11) DEFAULT 0,
  `houseAmmo2` int(11) DEFAULT 0,
  `houseWeapon3` int(11) DEFAULT 0,
  `houseAmmo3` int(11) DEFAULT 0,
  `houseWeapon4` int(11) DEFAULT 0,
  `houseAmmo4` int(11) DEFAULT 0,
  `houseWeapon5` int(11) DEFAULT 0,
  `houseAmmo5` int(11) DEFAULT 0,
  `houseWeapon6` int(11) DEFAULT 0,
  `houseAmmo6` int(11) DEFAULT 0,
  `houseWeapon7` int(11) DEFAULT 0,
  `houseAmmo7` int(11) DEFAULT 0,
  `houseWeapon8` int(11) DEFAULT 0,
  `houseAmmo8` int(11) DEFAULT 0,
  `houseWeapon9` int(11) DEFAULT 0,
  `houseAmmo9` int(11) DEFAULT 0,
  `houseWeapon10` int(11) DEFAULT 0,
  `houseAmmo10` int(11) DEFAULT 0,
  `houseMoney` int(11) DEFAULT 0,
  `houseLocation` int(11) NOT NULL DEFAULT 0,
  `houseMaxLoc` int(11) NOT NULL DEFAULT 0,
  `houseLocNum` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Structure de la table `housestorage`
--

CREATE TABLE `housestorage` (
  `ID` int(11) DEFAULT 0,
  `itemID` int(11) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(11) DEFAULT 0,
  `itemQuantity` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `impoundlots`
--

CREATE TABLE `impoundlots` (
  `impoundID` int(11) NOT NULL,
  `impoundLotX` float DEFAULT 0,
  `impoundLotY` float DEFAULT 0,
  `impoundLotZ` float DEFAULT 0,
  `impoundReleaseX` float DEFAULT 0,
  `impoundReleaseY` float DEFAULT 0,
  `impoundReleaseZ` float DEFAULT 0,
  `impoundReleaseInt` int(11) DEFAULT 0,
  `impoundReleaseWorld` int(11) DEFAULT 0,
  `impoundReleaseA` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `inventory`
--

CREATE TABLE `inventory` (
  `ID` int(11) DEFAULT 0,
  `invID` int(11) NOT NULL,
  `invItem` varchar(32) DEFAULT NULL,
  `invModel` int(11) DEFAULT 0,
  `invQuantity` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `jobID` int(11) NOT NULL,
  `jobPosX` float DEFAULT 0,
  `jobPosY` float DEFAULT 0,
  `jobPosZ` float DEFAULT 0,
  `jobPointX` float DEFAULT 0,
  `jobPointY` float DEFAULT 0,
  `jobPointZ` float DEFAULT 0,
  `jobDeliverX` float DEFAULT 0,
  `jobDeliverY` float DEFAULT 0,
  `jobDeliverZ` float DEFAULT 0,
  `jobInterior` int(11) DEFAULT 0,
  `jobWorld` int(11) DEFAULT 0,
  `jobType` int(11) DEFAULT 0,
  `jobPointInt` int(11) DEFAULT 0,
  `jobPointWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
-- --------------------------------------------------------

--
-- Structure de la table `namechanges`
--

CREATE TABLE `namechanges` (
  `ID` int(11) NOT NULL,
  `OldName` varchar(24) DEFAULT NULL,
  `NewName` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `news`
--

CREATE TABLE `news` (
  `news_id` int(11) NOT NULL,
  `news_name` text NOT NULL,
  `news_desc` text NOT NULL,
  `news_postedby` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `openworldmaison`
--

CREATE TABLE `openworldmaison` (
  `OpenWorldMID` int(11) NOT NULL,
  `OpenWorldMModel` int(11) NOT NULL DEFAULT 2000,
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
  `OpenWorldMOwner` int(11) DEFAULT -1,
  `OpenWorldMAddress` varchar(32) NOT NULL,
  `OpenWorldMPrice` int(11) NOT NULL DEFAULT 1000,
  `OpenWorldMBoom` int(11) NOT NULL DEFAULT 0,
  `OpenWorldMCommandX` float DEFAULT NULL,
  `OpenWorldMCommandY` float DEFAULT NULL,
  `OpenWorldMCommandZ` float DEFAULT NULL,
  `OpenWorldMCommandR` float DEFAULT NULL,
  `OpenWorldMLocked` int(11) DEFAULT NULL,
  `OpenWorldMSpeed` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `plants`
--

CREATE TABLE `plants` (
  `plantID` int(11) NOT NULL,
  `plantType` int(11) DEFAULT 0,
  `plantDrugs` int(11) DEFAULT 0,
  `plantX` float DEFAULT 0,
  `plantY` float DEFAULT 0,
  `plantZ` float DEFAULT 0,
  `plantA` float DEFAULT 0,
  `plantInterior` int(11) DEFAULT 0,
  `plantWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `pumps`
--

CREATE TABLE `pumps` (
  `ID` int(11) DEFAULT 0,
  `pumpID` int(11) NOT NULL,
  `pumpPosX` float DEFAULT 0,
  `pumpPosY` float DEFAULT 0,
  `pumpPosZ` float DEFAULT 0,
  `pumpPosA` float DEFAULT 0,
  `pumpFuel` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `salairefbi`
--

CREATE TABLE `salairefbi` (
  `idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT 0,
  `salairerang2` int(11) DEFAULT 0,
  `salairerang3` int(11) DEFAULT 0,
  `salairerang4` int(11) DEFAULT 0,
  `salairerang5` int(11) DEFAULT 0,
  `salairerang6` int(11) DEFAULT 0,
  `salairerang7` int(11) DEFAULT 0,
  `salairerang8` int(11) DEFAULT 0,
  `salairerang9` int(11) DEFAULT 0,
  `salairerang10` int(11) DEFAULT 0,
  `salairerang11` int(11) DEFAULT 0,
  `salairerang12` int(11) DEFAULT 0,
  `salairerang13` int(11) DEFAULT 0,
  `salairerang14` int(11) DEFAULT 0,
  `salairerang15` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `salairefbi`
--

INSERT INTO `salairefbi` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salairejob`
--

CREATE TABLE `salairejob` (
  `id` int(11) DEFAULT 50,
  `salairecariste` int(11) DEFAULT 50,
  `salairemanutentionnaire` int(11) DEFAULT 50,
  `salairedock` int(11) DEFAULT 50,
  `salairelaitier` int(11) DEFAULT 50,
  `salaireminer` int(11) DEFAULT 50,
  `salaireusineelectronic` int(11) DEFAULT 50,
  `salairebucheron` int(11) DEFAULT 50,
  `salairemenuisier` int(11) DEFAULT 50,
  `salairegenerateur` int(11) DEFAULT 50,
  `salaireelectricien` int(11) DEFAULT 50,
  `salairearme` int(11) DEFAULT 50,
  `salairepetrolier` int(11) DEFAULT 50,
  `salaireboucher` int(11) DEFAULT 50
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `salairejob`
--

INSERT INTO `salairejob` (`id`, `salairecariste`, `salairemanutentionnaire`, `salairedock`, `salairelaitier`, `salaireminer`, `salaireusineelectronic`, `salairebucheron`, `salairemenuisier`, `salairegenerateur`, `salaireelectricien`, `salairearme`, `salairepetrolier`, `salaireboucher`) VALUES
(1, 30, 60, 50, 18, 50, 50, 75, 50, 20, 75, 50, 75, 50);

-- --------------------------------------------------------

--
-- Structure de la table `salairemairie`
--

CREATE TABLE `salairemairie` (
  `idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT 0,
  `salairerang2` int(11) DEFAULT 0,
  `salairerang3` int(11) DEFAULT 0,
  `salairerang4` int(11) DEFAULT 0,
  `salairerang5` int(11) DEFAULT 0,
  `salairerang6` int(11) DEFAULT 0,
  `salairerang7` int(11) DEFAULT 0,
  `salairerang8` int(11) DEFAULT 0,
  `salairerang9` int(11) DEFAULT 0,
  `salairerang10` int(11) DEFAULT 0,
  `salairerang11` int(11) DEFAULT 0,
  `salairerang12` int(11) DEFAULT 0,
  `salairerang13` int(11) DEFAULT 0,
  `salairerang14` int(11) DEFAULT 0,
  `salairerang15` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `salairemairie`
--

INSERT INTO `salairemairie` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salairepolice`
--

CREATE TABLE `salairepolice` (
  `idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT 0,
  `salairerang2` int(11) DEFAULT 0,
  `salairerang3` int(11) DEFAULT 0,
  `salairerang4` int(11) DEFAULT 0,
  `salairerang5` int(11) DEFAULT 0,
  `salairerang6` int(11) DEFAULT 0,
  `salairerang7` int(11) DEFAULT 0,
  `salairerang8` int(11) DEFAULT 0,
  `salairerang9` int(11) DEFAULT 0,
  `salairerang10` int(11) DEFAULT 0,
  `salairerang11` int(11) DEFAULT 0,
  `salairerang12` int(11) DEFAULT 0,
  `salairerang13` int(11) DEFAULT 0,
  `salairerang14` int(11) DEFAULT 0,
  `salairerang15` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `salairepolice`
--

INSERT INTO `salairepolice` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salaireswat`
--

CREATE TABLE `salaireswat` (
  `idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT 0,
  `salairerang2` int(11) DEFAULT 0,
  `salairerang3` int(11) DEFAULT 0,
  `salairerang4` int(11) DEFAULT 0,
  `salairerang5` int(11) DEFAULT 0,
  `salairerang6` int(11) DEFAULT 0,
  `salairerang7` int(11) DEFAULT 0,
  `salairerang8` int(11) DEFAULT 0,
  `salairerang9` int(11) DEFAULT 0,
  `salairerang10` int(11) DEFAULT 0,
  `salairerang11` int(11) DEFAULT 0,
  `salairerang12` int(11) DEFAULT 0,
  `salairerang13` int(11) DEFAULT 0,
  `salairerang14` int(11) DEFAULT 0,
  `salairerang15` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `salaireswat`
--

INSERT INTO `salaireswat` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salaireurgentiste`
--

CREATE TABLE `salaireurgentiste` (
  `idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT 0,
  `salairerang2` int(11) DEFAULT 0,
  `salairerang3` int(11) DEFAULT 0,
  `salairerang4` int(11) DEFAULT 0,
  `salairerang5` int(11) DEFAULT 0,
  `salairerang6` int(11) DEFAULT 0,
  `salairerang7` int(11) DEFAULT 0,
  `salairerang8` int(11) DEFAULT 0,
  `salairerang9` int(11) DEFAULT 0,
  `salairerang10` int(11) DEFAULT 0,
  `salairerang11` int(11) DEFAULT 0,
  `salairerang12` int(11) DEFAULT 0,
  `salairerang13` int(11) DEFAULT 0,
  `salairerang14` int(11) DEFAULT 0,
  `salairerang15` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `salaireurgentiste`
--

INSERT INTO `salaireurgentiste` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `serveursetting`
--

CREATE TABLE `serveursetting` (
  `id` int(11) NOT NULL,
  `motd` varchar(128) NOT NULL DEFAULT '00',
  `afkactive` int(11) DEFAULT 1,
  `afktime` int(11) DEFAULT 0,
  `braquagenpcactive` int(11) DEFAULT 0,
  `braquagebanqueactive` int(11) DEFAULT 0,
  `oocactive` int(11) DEFAULT 0,
  `pmactive` int(11) DEFAULT 0,
  `villeactive` int(11) NOT NULL DEFAULT 1,
  `nouveau` int(11) NOT NULL,
  `police` int(11) NOT NULL DEFAULT 0,
  `swat` int(11) NOT NULL DEFAULT 0,
  `whiteliste` int(11) NOT NULL DEFAULT 0,
  `discord` varchar(128) NOT NULL DEFAULT '0',
  `verifier` varchar(20) NOT NULL DEFAULT '0',
  `admin1` varchar(20) NOT NULL DEFAULT '0',
  `admin2` varchar(20) NOT NULL DEFAULT '0',
  `admin3` varchar(20) NOT NULL DEFAULT '0',
  `admin4` varchar(20) NOT NULL DEFAULT '0',
  `spawnpos1` float NOT NULL,
  `spawnpos2` float NOT NULL,
  `spawnpos3` float NOT NULL,
  `settingdelouer1` float NOT NULL DEFAULT 0,
  `settingdelouer2` float NOT NULL DEFAULT 0,
  `settingdelouer3` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `serveursetting`
--

INSERT INTO `serveursetting` (`id`, `motd`, `afkactive`, `afktime`, `braquagenpcactive`, `braquagebanqueactive`, `oocactive`, `pmactive`, `villeactive`, `nouveau`, `police`, `swat`, `whiteliste`, `discord`, `verifier`, `admin1`, `admin2`, `admin3`, `admin4`, `spawnpos1`, `spawnpos2`, `spawnpos3`, `settingdelouer1`, `settingdelouer2`, `settingdelouer3`) VALUES
(1, 'Allo pédale', 1, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', '0', '0', '0', '0', 8345.92, 7291.9, 27.072, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `slotmachine`
--

CREATE TABLE `slotmachine` (
  `id` int(11) NOT NULL,
  `X` float DEFAULT 0,
  `Y` float DEFAULT 0,
  `Z` float DEFAULT 0,
  `RX` float DEFAULT 0,
  `RY` float DEFAULT 0,
  `RZ` float DEFAULT 0,
  `slotint` float DEFAULT 0,
  `slotvw` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- --------------------------------------------------------

--
-- Structure de la table `speedcameras`
--

CREATE TABLE `speedcameras` (
  `speedID` int(11) NOT NULL,
  `speedRange` float DEFAULT 0,
  `speedLimit` float DEFAULT 0,
  `speedX` float DEFAULT 0,
  `speedY` float DEFAULT 0,
  `speedZ` float DEFAULT 0,
  `speedAngle` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `tickets`
--

CREATE TABLE `tickets` (
  `ID` int(11) DEFAULT 0,
  `ticketID` int(11) NOT NULL,
  `ticketFee` int(11) DEFAULT 0,
  `ticketBy` varchar(24) DEFAULT NULL,
  `ticketDate` varchar(36) DEFAULT NULL,
  `ticketReason` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- --------------------------------------------------------

--
-- Structure de la table `vendors`
--

CREATE TABLE `vendors` (
  `vendorID` int(11) NOT NULL,
  `vendorType` int(11) DEFAULT 0,
  `vendorX` float DEFAULT 0,
  `vendorY` float DEFAULT 0,
  `vendorZ` float DEFAULT 0,
  `vendorA` float DEFAULT 0,
  `vendorInterior` int(11) DEFAULT 0,
  `vendorWorld` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


--
-- Structure de la table `votes`
--

CREATE TABLE `votes` (
  `Name` varchar(24) NOT NULL,
  `Votes` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `warrants`
--

CREATE TABLE `warrants` (
  `ID` int(11) NOT NULL,
  `Suspect` varchar(24) DEFAULT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL,
  `Description` varchar(128) DEFAULT NULL,
  `IDchar` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

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
-- Index pour la table `arrestpoints`
--
ALTER TABLE `arrestpoints`
  ADD PRIMARY KEY (`arrestID`);

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
-- Index pour la table `salairemairie`
--
ALTER TABLE `salairemairie`
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
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `actors`
--
ALTER TABLE `actors`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `arrestpoints`
--
ALTER TABLE `arrestpoints`
  MODIFY `arrestID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `backpackitems`
--
ALTER TABLE `backpackitems`
  MODIFY `itemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `backpacks`
--
ALTER TABLE `backpacks`
  MODIFY `backpackID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `bank_logs`
--
ALTER TABLE `bank_logs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `batiements`
--
ALTER TABLE `batiements`
  MODIFY `batiementID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `billboards`
--
ALTER TABLE `billboards`
  MODIFY `bbID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `bizID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `caisseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `cars`
--
ALTER TABLE `cars`
  MODIFY `carID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `carstorage`
--
ALTER TABLE `carstorage`
  MODIFY `itemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `characters`
--
ALTER TABLE `characters`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contactID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `crates`
--
ALTER TABLE `crates`
  MODIFY `crateID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `dealervehicles`
--
ALTER TABLE `dealervehicles`
  MODIFY `vehID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `death`
--
ALTER TABLE `death`
  MODIFY `dID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `detectors`
--
ALTER TABLE `detectors`
  MODIFY `detectorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `dropped`
--
ALTER TABLE `dropped`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `entranceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `factorystock`
--
ALTER TABLE `factorystock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `furnitureID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `garbage`
--
ALTER TABLE `garbage`
  MODIFY `garbageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `gates`
--
ALTER TABLE `gates`
  MODIFY `gateID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `gouvernement`
--
ALTER TABLE `gouvernement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `gps`
--
ALTER TABLE `gps`
  MODIFY `locationID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `graffiti`
--
ALTER TABLE `graffiti`
  MODIFY `graffitiID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `gunracks`
--
ALTER TABLE `gunracks`
  MODIFY `rackID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `houses`
--
ALTER TABLE `houses`
  MODIFY `houseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `housestorage`
--
ALTER TABLE `housestorage`
  MODIFY `itemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `impoundlots`
--
ALTER TABLE `impoundlots`
  MODIFY `impoundID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `invID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `jobID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `namechanges`
--
ALTER TABLE `namechanges`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `openworldmaison`
--
ALTER TABLE `openworldmaison`
  MODIFY `OpenWorldMID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `plants`
--
ALTER TABLE `plants`
  MODIFY `plantID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `pumps`
--
ALTER TABLE `pumps`
  MODIFY `pumpID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `salairefbi`
--
ALTER TABLE `salairefbi`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairemairie`
--
ALTER TABLE `salairemairie`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salairepolice`
--
ALTER TABLE `salairepolice`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salaireswat`
--
ALTER TABLE `salaireswat`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `salaireurgentiste`
--
ALTER TABLE `salaireurgentiste`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `slotmachine`
--
ALTER TABLE `slotmachine`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `speedcameras`
--
ALTER TABLE `speedcameras`
  MODIFY `speedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `ticketID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `vendorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT pour la table `warrants`
--
ALTER TABLE `warrants`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

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
