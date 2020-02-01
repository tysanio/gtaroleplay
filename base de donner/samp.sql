-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 01, 2020 at 07:38 AM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vice`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `ID` int(12) NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Password` varchar(129) DEFAULT NULL,
  `RegisterDate` varchar(36) DEFAULT NULL,
  `LoginDate` varchar(36) DEFAULT NULL,
  `IP` varchar(16) DEFAULT 'n/a',
  `WL` int(4) NOT NULL DEFAULT 0,
  `Language` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- --------------------------------------------------------

--
-- Table structure for table `actors`
--

CREATE TABLE `actors` (
  `ID` int(11) NOT NULL,
  `Skinid` int(3) NOT NULL,
  `Float` varchar(220) NOT NULL,
  `actorint` int(4) NOT NULL DEFAULT 0,
  `actorvw` int(4) NOT NULL DEFAULT 0,
  `actorsetting` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `arrestpoints`
--

CREATE TABLE `arrestpoints` (
  `arrestID` int(11) NOT NULL,
  `arrestX` float NOT NULL,
  `arrestY` float NOT NULL,
  `arrestZ` float NOT NULL,
  `arrestInterior` int(11) NOT NULL,
  `arrestWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `atm`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Table structure for table `backpackitems`
--

CREATE TABLE `backpackitems` (
  `ID` int(12) DEFAULT 0,
  `itemID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT 0,
  `itemQuantity` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `backpacks`
--

CREATE TABLE `backpacks` (
  `backpackID` int(12) NOT NULL,
  `backpackPlayer` int(12) DEFAULT 0,
  `backpackX` float DEFAULT 0,
  `backpackY` float DEFAULT 0,
  `backpackZ` float DEFAULT 0,
  `backpackInterior` int(12) DEFAULT 0,
  `backpackWorld` int(12) DEFAULT 0,
  `backpackHouse` int(12) DEFAULT 0,
  `backpackVehicle` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `banqueentreprise`
--

CREATE TABLE `banqueentreprise` (
  `id` int(11) NOT NULL,
  `mecanozone3` int(11) NOT NULL,
  `mecanozone4` int(11) NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `banqueentreprise`
--

INSERT INTO `banqueentreprise` (`id`, `mecanozone3`, `mecanozone4`, `livraisonzone1`, `mafiazone1`, `mafiazone4`, `police`, `fbi`, `swat`, `mairiels`, `medecin`, `fermier`, `vendeur`, `journaliste`, `banque`) VALUES
(1, 0, 0, 1800, 0, 0, 24587600, 0, 0, 1121122, 2964700, 0, 3, 2500, 1585014);

-- --------------------------------------------------------

--
-- Table structure for table `batiements`
--

CREATE TABLE `batiements` (
  `batiementID` int(12) NOT NULL,
  `batiementModel` int(12) DEFAULT 0,
  `batiementX` float DEFAULT 0,
  `batiementY` float DEFAULT 0,
  `batiementZ` float DEFAULT 0,
  `batiementRX` float DEFAULT 0,
  `batiementRY` float DEFAULT 0,
  `batiementRZ` float DEFAULT 0,
  `batiementInterior` int(12) DEFAULT 0,
  `batiementWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `billboards`
--

CREATE TABLE `billboards` (
  `bbID` int(12) NOT NULL,
  `bbExists` int(12) DEFAULT 0,
  `bbName` varchar(32) DEFAULT NULL,
  `bbOwner` int(12) NOT NULL DEFAULT 0,
  `bbPrice` int(12) NOT NULL DEFAULT 0,
  `bbRange` int(12) DEFAULT 10,
  `bbPosX` float DEFAULT 0,
  `bbPosY` float DEFAULT 0,
  `bbPosZ` float DEFAULT 0,
  `bbMessage` varchar(230) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `blacklist`
--

CREATE TABLE `blacklist` (
  `IP` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `Username` varchar(24) NOT NULL DEFAULT '',
  `BannedBy` varchar(24) DEFAULT NULL,
  `Reason` varchar(128) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Table structure for table `businesses`
--

CREATE TABLE `businesses` (
  `bizID` int(12) NOT NULL,
  `bizName` varchar(32) DEFAULT NULL,
  `bizOwner` int(12) DEFAULT 0,
  `bizType` int(12) DEFAULT 0,
  `bizPrice` int(12) DEFAULT 0,
  `bizPosX` float DEFAULT 0,
  `bizPosY` float DEFAULT 0,
  `bizPosZ` float DEFAULT 0,
  `bizPosA` float DEFAULT 0,
  `bizIntX` float DEFAULT 0,
  `bizIntY` float DEFAULT 0,
  `bizIntZ` float DEFAULT 0,
  `bizIntA` float DEFAULT 0,
  `bizInterior` int(12) DEFAULT 0,
  `bizInteriorVW` int(4) NOT NULL DEFAULT 0,
  `bizExterior` int(12) DEFAULT 0,
  `bizExteriorVW` int(12) DEFAULT 0,
  `bizLocked` int(4) DEFAULT 0,
  `bizVault` int(12) DEFAULT 0,
  `bizProducts` int(12) DEFAULT 0,
  `bizPrice1` int(12) DEFAULT 0,
  `bizPrice2` int(12) DEFAULT 0,
  `bizPrice3` int(12) DEFAULT 0,
  `bizPrice4` int(12) DEFAULT 0,
  `bizPrice5` int(12) DEFAULT 0,
  `bizPrice6` int(12) DEFAULT 0,
  `bizPrice7` int(12) DEFAULT 0,
  `bizPrice8` int(12) DEFAULT 0,
  `bizPrice9` int(12) DEFAULT 0,
  `bizPrice10` int(12) DEFAULT 0,
  `bizSpawnX` float DEFAULT 0,
  `bizSpawnY` float DEFAULT 0,
  `bizSpawnZ` float DEFAULT 0,
  `bizSpawnA` float DEFAULT 0,
  `bizDeliverX` float DEFAULT 0,
  `bizDeliverY` float DEFAULT 0,
  `bizDeliverZ` float DEFAULT 0,
  `bizMessage` varchar(128) DEFAULT NULL,
  `bizPrice11` int(12) DEFAULT 0,
  `bizPrice12` int(12) DEFAULT 0,
  `bizPrice13` int(12) DEFAULT 0,
  `bizPrice14` int(12) DEFAULT 0,
  `bizPrice15` int(12) DEFAULT 0,
  `bizPrice16` int(12) DEFAULT 0,
  `bizPrice17` int(12) DEFAULT 0,
  `bizPrice18` int(12) DEFAULT 0,
  `bizPrice19` int(12) DEFAULT 0,
  `bizPrice20` int(12) DEFAULT 0,
  `bizShipment` int(4) DEFAULT 0,
  `time1` int(4) NOT NULL DEFAULT -1,
  `time2` int(4) NOT NULL DEFAULT -1,
  `chancevole` int(4) NOT NULL DEFAULT 0,
  `defoncer` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `caisses`
--

CREATE TABLE `caisses` (
  `caisseID` int(12) NOT NULL,
  `caisseX` float DEFAULT 0,
  `caisseY` float DEFAULT 0,
  `caisseZ` float DEFAULT 0,
  `caisseRX` float DEFAULT 0,
  `caisseRY` float DEFAULT 0,
  `caisseRZ` float DEFAULT 0,
  `caisseInterior` int(12) DEFAULT 0,
  `caisseWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `carID` int(12) NOT NULL,
  `carModel` int(12) DEFAULT 0,
  `carOwner` int(12) DEFAULT 0,
  `carPosX` float DEFAULT 0,
  `carPosY` float DEFAULT 0,
  `carPosZ` float DEFAULT 0,
  `carPosR` float DEFAULT 0,
  `carColor1` int(12) DEFAULT 0,
  `carColor2` int(12) DEFAULT 0,
  `carPaintjob` int(12) DEFAULT -1,
  `carLocked` int(4) DEFAULT 0,
  `carMod1` int(12) DEFAULT 0,
  `carMod2` int(12) DEFAULT 0,
  `carMod3` int(12) DEFAULT 0,
  `carMod4` int(12) DEFAULT 0,
  `carMod5` int(12) DEFAULT 0,
  `carMod6` int(12) DEFAULT 0,
  `carMod7` int(12) DEFAULT 0,
  `carMod8` int(12) DEFAULT 0,
  `carMod9` int(12) DEFAULT 0,
  `carMod10` int(12) DEFAULT 0,
  `carMod11` int(12) DEFAULT 0,
  `carMod12` int(12) DEFAULT 0,
  `carMod13` int(12) DEFAULT 0,
  `carMod14` int(12) DEFAULT 0,
  `carImpounded` int(12) DEFAULT 0,
  `carWeapon1` int(12) DEFAULT 0,
  `carAmmo1` int(12) DEFAULT 0,
  `carWeapon2` int(12) DEFAULT 0,
  `carAmmo2` int(12) DEFAULT 0,
  `carWeapon3` int(12) DEFAULT 0,
  `carAmmo3` int(12) DEFAULT 0,
  `carWeapon4` int(12) DEFAULT 0,
  `carAmmo4` int(12) DEFAULT 0,
  `carWeapon5` int(12) DEFAULT 0,
  `carAmmo5` int(12) DEFAULT 0,
  `carImpoundPrice` int(12) DEFAULT 0,
  `carFaction` int(12) DEFAULT 0,
  `carLoca` int(11) NOT NULL DEFAULT -1,
  `carLocaID` int(11) NOT NULL DEFAULT -1,
  `carDouble` int(11) NOT NULL,
  `carSabot` int(11) NOT NULL,
  `carSabPri` int(11) NOT NULL,
  `vkilometres` float NOT NULL DEFAULT 0,
  `vmetre` int(11) NOT NULL DEFAULT 0,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `carvie` float NOT NULL,
  `alarme` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `carstorage`
--

CREATE TABLE `carstorage` (
  `ID` int(12) DEFAULT 0,
  `itemID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT 0,
  `itemQuantity` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `ID` int(12) NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Character` varchar(24) DEFAULT NULL,
  `Created` int(4) DEFAULT 0,
  `Gender` int(4) DEFAULT 0,
  `Birthdate` varchar(32) DEFAULT '01/01/1970',
  `Origin` varchar(32) DEFAULT 'Not Specified',
  `Skin` int(12) DEFAULT 0,
  `Glasses` int(12) DEFAULT 0,
  `Hat` int(12) DEFAULT 0,
  `Bandana` int(12) DEFAULT 0,
  `PosX` float DEFAULT 0,
  `PosY` float DEFAULT 0,
  `PosZ` float DEFAULT 0,
  `PosA` float DEFAULT 0,
  `Interior` int(12) DEFAULT 0,
  `World` int(12) DEFAULT 0,
  `GlassesPos` varchar(100) DEFAULT NULL,
  `HatPos` varchar(100) DEFAULT NULL,
  `BandanaPos` varchar(100) DEFAULT NULL,
  `Hospital` int(12) DEFAULT -1,
  `HospitalInt` int(12) DEFAULT 0,
  `Money` int(12) DEFAULT 0,
  `BankMoney` int(12) DEFAULT 0,
  `OwnsBillboard` int(12) DEFAULT -1,
  `Savings` int(12) DEFAULT 0,
  `Admin` int(12) DEFAULT 0,
  `JailTime` int(12) DEFAULT 0,
  `Muted` int(4) DEFAULT 0,
  `CreateDate` int(12) DEFAULT 0,
  `LastLogin` int(12) DEFAULT 0,
  `Tester` int(4) DEFAULT 0,
  `Gun1` int(12) DEFAULT 0,
  `Gun2` int(12) DEFAULT 0,
  `Gun3` int(12) DEFAULT 0,
  `Gun4` int(12) DEFAULT 0,
  `Gun5` int(12) DEFAULT 0,
  `Gun6` int(12) DEFAULT 0,
  `Gun7` int(12) DEFAULT 0,
  `Gun8` int(12) DEFAULT 0,
  `Gun9` int(12) DEFAULT 0,
  `Gun10` int(12) DEFAULT 0,
  `Gun11` int(12) DEFAULT 0,
  `Gun12` int(12) DEFAULT 0,
  `Gun13` int(12) DEFAULT 0,
  `Ammo1` int(12) DEFAULT 0,
  `Ammo2` int(12) DEFAULT 0,
  `Ammo3` int(12) DEFAULT 0,
  `Ammo4` int(12) DEFAULT 0,
  `Ammo5` int(12) DEFAULT 0,
  `Ammo6` int(12) DEFAULT 0,
  `Ammo7` int(12) DEFAULT 0,
  `Ammo8` int(12) DEFAULT 0,
  `Ammo9` int(12) DEFAULT 0,
  `Ammo10` int(12) DEFAULT 0,
  `Ammo11` int(12) DEFAULT 0,
  `Ammo12` int(12) DEFAULT 0,
  `Ammo13` int(12) DEFAULT 0,
  `House` int(12) DEFAULT -1,
  `Business` int(12) DEFAULT -1,
  `Phone` int(12) DEFAULT 0,
  `Lottery` int(12) DEFAULT 0,
  `Hunger` int(12) DEFAULT 100,
  `Thirst` int(12) DEFAULT 100,
  `PlayingHours` int(12) DEFAULT 0,
  `Minutes` int(12) DEFAULT 0,
  `ArmorStatus` float DEFAULT 0,
  `Entrance` int(12) DEFAULT 0,
  `Job` int(12) DEFAULT 0,
  `Faction` int(12) DEFAULT -1,
  `FactionRank` int(12) DEFAULT 0,
  `Prisoned` int(4) DEFAULT 0,
  `Warrants` int(12) DEFAULT 0,
  `Injured` int(4) DEFAULT 0,
  `Health` float DEFAULT 0,
  `Channel` int(12) DEFAULT 0,
  `Accent` varchar(24) DEFAULT NULL,
  `Bleeding` int(4) DEFAULT 0,
  `Warnings` int(12) DEFAULT 0,
  `Warn1` varchar(32) DEFAULT NULL,
  `Warn2` varchar(32) DEFAULT NULL,
  `MaskID` int(12) DEFAULT 0,
  `FactionMod` int(12) DEFAULT 0,
  `Capacity` int(12) DEFAULT 35,
  `AdminHide` int(4) DEFAULT 0,
  `LotteryB` int(11) NOT NULL,
  `SpawnPoint` int(11) NOT NULL,
  `connecter` int(4) NOT NULL DEFAULT 0,
  `bracelet` int(4) NOT NULL DEFAULT 0,
  `braceletdist` int(4) NOT NULL DEFAULT 0,
  `LocaID` int(4) NOT NULL DEFAULT 0,
  `CarD` int(4) NOT NULL DEFAULT -1,
  `LocaMaisonID` int(4) NOT NULL DEFAULT 0,
  `baterietel` int(4) NOT NULL DEFAULT 20,
  `BestScore` int(4) NOT NULL DEFAULT 0,
  `Strike` int(4) NOT NULL DEFAULT 0,
  `Repetition` int(8) NOT NULL DEFAULT 0,
  `Parcouru` int(8) NOT NULL DEFAULT 0,
  `Noob` int(4) NOT NULL DEFAULT 1,
  `ZombieKill` int(4) NOT NULL DEFAULT 0,
  `skill0` int(4) NOT NULL DEFAULT 0,
  `skill1` int(4) NOT NULL DEFAULT 0,
  `skill2` int(4) NOT NULL DEFAULT 0,
  `skill3` int(4) NOT NULL DEFAULT 0,
  `skill4` int(4) NOT NULL DEFAULT 0,
  `skill5` int(4) NOT NULL DEFAULT 0,
  `skill6` int(4) NOT NULL DEFAULT 0,
  `skill7` int(4) NOT NULL DEFAULT 0,
  `skill8` int(4) NOT NULL DEFAULT 0,
  `skill9` int(4) NOT NULL DEFAULT 0,
  `skill10` int(4) NOT NULL DEFAULT 0,
  `DA` int(4) NOT NULL DEFAULT 0,
  `Death` int(4) NOT NULL DEFAULT 0,
  `Role` varchar(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `ID` int(12) DEFAULT 0,
  `contactID` int(12) NOT NULL,
  `contactName` varchar(32) DEFAULT NULL,
  `contactNumber` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `crates`
--

CREATE TABLE `crates` (
  `crateID` int(12) NOT NULL,
  `crateType` int(12) DEFAULT 0,
  `crateX` float DEFAULT 0,
  `crateY` float DEFAULT 0,
  `crateZ` float DEFAULT 0,
  `crateA` float DEFAULT 0,
  `crateInterior` int(12) DEFAULT 0,
  `crateWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvfbi`
--

CREATE TABLE `cvfbi` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvjournaliste`
--

CREATE TABLE `cvjournaliste` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvlivraisonbiz`
--

CREATE TABLE `cvlivraisonbiz` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvmairie`
--

CREATE TABLE `cvmairie` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvmecanozone3`
--

CREATE TABLE `cvmecanozone3` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvmecanozone4`
--

CREATE TABLE `cvmecanozone4` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvpetitlivreur`
--

CREATE TABLE `cvpetitlivreur` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvpolice`
--

CREATE TABLE `cvpolice` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvswat`
--

CREATE TABLE `cvswat` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvtaxi`
--

CREATE TABLE `cvtaxi` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvurgentiste`
--

CREATE TABLE `cvurgentiste` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cvvendeurrue`
--

CREATE TABLE `cvvendeurrue` (
  `id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dealervehicles`
--

CREATE TABLE `dealervehicles` (
  `ID` int(12) DEFAULT 0,
  `vehID` int(12) NOT NULL,
  `vehModel` int(12) DEFAULT 0,
  `vehPrice` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `death`
--

CREATE TABLE `death` (
  `dID` int(4) NOT NULL,
  `dName` varchar(32) NOT NULL,
  `dDate` varchar(36) NOT NULL DEFAULT '10/10/2020'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `death`
--

-- --------------------------------------------------------

--
-- Table structure for table `detectors`
--

CREATE TABLE `detectors` (
  `detectorID` int(12) NOT NULL,
  `detectorX` float DEFAULT 0,
  `detectorY` float DEFAULT 0,
  `detectorZ` float DEFAULT 0,
  `detectorAngle` float DEFAULT 0,
  `detectorInterior` int(12) DEFAULT 0,
  `detectorWorld` int(12) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dropped`
--

CREATE TABLE `dropped` (
  `ID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT 0,
  `itemX` float DEFAULT 0,
  `itemY` float DEFAULT 0,
  `itemZ` float DEFAULT 0,
  `itemInt` int(12) DEFAULT 0,
  `itemWorld` int(12) DEFAULT 0,
  `itemQuantity` int(12) DEFAULT 0,
  `itemAmmo` int(12) DEFAULT 0,
  `itemWeapon` int(12) DEFAULT 0,
  `itemPlayer` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `entrances`
--

CREATE TABLE `entrances` (
  `entranceID` int(12) NOT NULL,
  `entranceName` varchar(32) DEFAULT NULL,
  `entranceIcon` int(12) DEFAULT 0,
  `entrancePosX` float DEFAULT 0,
  `entrancePosY` float DEFAULT 0,
  `entrancePosZ` float DEFAULT 0,
  `entrancePosA` float DEFAULT 0,
  `entranceIntX` float DEFAULT 0,
  `entranceIntY` float DEFAULT 0,
  `entranceIntZ` float DEFAULT 0,
  `entranceIntA` float DEFAULT 0,
  `entranceInterior` int(12) DEFAULT 0,
  `entranceExterior` int(12) DEFAULT 0,
  `entranceExteriorVW` int(12) DEFAULT 0,
  `entranceType` int(12) DEFAULT 0,
  `entrancePass` varchar(32) DEFAULT NULL,
  `entranceLocked` int(12) DEFAULT 0,
  `entranceCustom` int(4) DEFAULT 0,
  `entranceWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `entrances`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `factions`
--

CREATE TABLE `factions` (
  `factionID` int(12) NOT NULL,
  `factionName` varchar(32) DEFAULT NULL,
  `factionRanks` int(12) DEFAULT 0,
  `factionLockerX` float DEFAULT 0,
  `factionLockerY` float DEFAULT 0,
  `factionLockerZ` float DEFAULT 0,
  `factionLockerInt` int(12) DEFAULT 0,
  `factionLockerWorld` int(12) DEFAULT 0,
  `factioncoffre` int(12) NOT NULL DEFAULT 0,
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
  `factionWeapon1` int(12) DEFAULT 0,
  `factionAmmo1` int(12) DEFAULT 0,
  `factionWeapon2` int(12) DEFAULT 0,
  `factionAmmo2` int(12) DEFAULT 0,
  `factionWeapon3` int(12) DEFAULT 0,
  `factionAmmo3` int(12) DEFAULT 0,
  `factionWeapon4` int(12) DEFAULT 0,
  `factionAmmo4` int(12) DEFAULT 0,
  `factionWeapon5` int(12) DEFAULT 0,
  `factionAmmo5` int(12) DEFAULT 0,
  `factionWeapon6` int(12) DEFAULT 0,
  `factionAmmo6` int(12) DEFAULT 0,
  `factionWeapon7` int(12) DEFAULT 0,
  `factionAmmo7` int(12) DEFAULT 0,
  `factionWeapon8` int(12) DEFAULT 0,
  `factionAmmo8` int(12) DEFAULT 0,
  `factionWeapon9` int(12) DEFAULT 0,
  `factionAmmo9` int(12) DEFAULT 0,
  `factionWeapon10` int(12) DEFAULT 0,
  `factionAmmo10` int(12) DEFAULT 0,
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
  `factionSkin1` int(12) DEFAULT 0,
  `factionSkin2` int(12) DEFAULT 0,
  `factionSkin3` int(12) DEFAULT 0,
  `factionSkin4` int(12) DEFAULT 0,
  `factionSkin5` int(12) DEFAULT 0,
  `factionSkin6` int(12) DEFAULT 0,
  `factionSkin7` int(12) DEFAULT 0,
  `factionSkin8` int(12) DEFAULT 0,
  `factionacces1` int(4) NOT NULL DEFAULT 0,
  `factionacces2` int(4) NOT NULL DEFAULT 0,
  `factionacces3` int(4) NOT NULL DEFAULT 0,
  `factionacces4` int(4) NOT NULL DEFAULT 0,
  `factionacces5` int(4) NOT NULL DEFAULT 0,
  `factionacces6` int(4) NOT NULL DEFAULT 0,
  `factionacces7` int(4) NOT NULL DEFAULT 0,
  `factionacces8` int(4) NOT NULL DEFAULT 0,
  `factionacces9` int(4) NOT NULL DEFAULT 0,
  `factionacces10` int(4) NOT NULL DEFAULT 0,
  `factionacces11` int(4) NOT NULL DEFAULT 0,
  `factionacces12` int(4) NOT NULL DEFAULT 0,
  `factionacces13` int(4) NOT NULL DEFAULT 0,
  `factionacces14` int(4) NOT NULL DEFAULT 0,
  `factionacces15` int(4) NOT NULL DEFAULT 0,
  `SalaireRank1` int(4) NOT NULL DEFAULT 0,
  `SalaireRank2` int(4) NOT NULL DEFAULT 0,
  `SalaireRank3` int(4) NOT NULL DEFAULT 0,
  `SalaireRank4` int(4) NOT NULL DEFAULT 0,
  `SalaireRank5` int(4) NOT NULL DEFAULT 0,
  `SalaireRank6` int(4) NOT NULL DEFAULT 0,
  `SalaireRank7` int(4) NOT NULL DEFAULT 0,
  `SalaireRank8` int(4) NOT NULL DEFAULT 0,
  `SalaireRank9` int(4) NOT NULL DEFAULT 0,
  `SalaireRank10` int(4) NOT NULL DEFAULT 0,
  `SalaireRank11` int(4) NOT NULL DEFAULT 0,
  `SalaireRank12` int(4) NOT NULL DEFAULT 0,
  `SalaireRank13` int(4) NOT NULL DEFAULT 0,
  `SalaireRank14` int(4) NOT NULL DEFAULT 0,
  `SalaireRank15` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- --------------------------------------------------------

--
-- Table structure for table `factorystock`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `factorystock`
--

INSERT INTO `factorystock` (`id`, `bois`, `viande`, `meuble`, `central1`, `central2`, `central3`, `central4`, `central5`, `electronic`, `petrol`, `essencegenerator`, `boismeuble`, `magasinstock`, `dockstock`, `manutentionnairestock`, `caristestock`, `minerstock`, `armesstock`, `frontbumper`, `rearbumper`, `roof`, `hood`, `spoiler`, `sideskirt`, `hydrolic`, `roue`, `caro`) VALUES
(1, 3, 2, 0, 98884, 98884, 98884, 98884, 98884, 6, 10, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `ID` int(12) DEFAULT 0,
  `furnitureID` int(12) NOT NULL,
  `furnitureName` varchar(32) DEFAULT NULL,
  `furnitureModel` int(12) DEFAULT 0,
  `furnitureX` float DEFAULT 0,
  `furnitureY` float DEFAULT 0,
  `furnitureZ` float DEFAULT 0,
  `furnitureRX` float DEFAULT 0,
  `furnitureRY` float DEFAULT 0,
  `furnitureRZ` float DEFAULT 0,
  `furnitureType` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `furnitures`
--

CREATE TABLE `furnitures` (
  `id` int(12) NOT NULL,
  `name` varchar(100) NOT NULL,
  `model` int(12) NOT NULL,
  `price` int(12) NOT NULL,
  `pos_x` float NOT NULL,
  `pos_y` float NOT NULL,
  `pos_z` float NOT NULL,
  `rot_x` float NOT NULL,
  `rot_y` float NOT NULL,
  `rot_z` float NOT NULL,
  `interior` int(12) NOT NULL,
  `object_id` int(12) NOT NULL,
  `world` int(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `garbage`
--

CREATE TABLE `garbage` (
  `garbageID` int(12) NOT NULL,
  `garbageModel` int(12) DEFAULT 1236,
  `garbageCapacity` int(12) DEFAULT 0,
  `garbageX` float DEFAULT 0,
  `garbageY` float DEFAULT 0,
  `garbageZ` float DEFAULT 0,
  `garbageA` float DEFAULT 0,
  `garbageInterior` int(12) DEFAULT 0,
  `garbageWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gates`
--

CREATE TABLE `gates` (
  `gateID` int(12) NOT NULL,
  `gateModel` int(12) DEFAULT 0,
  `gateSpeed` float DEFAULT 0,
  `gateTime` int(12) DEFAULT 0,
  `gateX` float DEFAULT 0,
  `gateY` float DEFAULT 0,
  `gateZ` float DEFAULT 0,
  `gateRX` float DEFAULT 0,
  `gateRY` float DEFAULT 0,
  `gateRZ` float DEFAULT 0,
  `gateInterior` int(12) DEFAULT 0,
  `gateWorld` int(12) DEFAULT 0,
  `gateMoveX` float DEFAULT 0,
  `gateMoveY` float DEFAULT 0,
  `gateMoveZ` float DEFAULT 0,
  `gateMoveRX` float DEFAULT 0,
  `gateMoveRY` float DEFAULT 0,
  `gateMoveRZ` float DEFAULT 0,
  `gateLinkID` int(12) DEFAULT 0,
  `gateFaction` int(12) DEFAULT 0,
  `gatePass` varchar(32) DEFAULT NULL,
  `gateRadius` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gouvernement`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gouvernement`
--

INSERT INTO `gouvernement` (`id`, `taxe`, `taxerevenue`, `taxeentreprise`, `chomage`, `subventionpolice`, `subventionfbi`, `subventionmedecin`, `subventionswat`, `aidebanque`, `bizhouse`, `maison`, `magasin`) VALUES
(1, 10, 15, 85, 800, 5000, 0, 0, 600, 450, 50, 45, 45);

-- --------------------------------------------------------

--
-- Table structure for table `gps`
--

CREATE TABLE `gps` (
  `ID` int(12) DEFAULT 0,
  `locationID` int(12) NOT NULL,
  `locationName` varchar(32) DEFAULT NULL,
  `locationX` float DEFAULT 0,
  `locationY` float DEFAULT 0,
  `locationZ` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `graffiti`
--

CREATE TABLE `graffiti` (
  `graffitiID` int(12) NOT NULL,
  `graffitiX` float DEFAULT 0,
  `graffitiY` float DEFAULT 0,
  `graffitiZ` float DEFAULT 0,
  `graffitiAngle` float DEFAULT 0,
  `graffitiColor` int(12) DEFAULT 0,
  `graffitiText` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gunracks`
--

CREATE TABLE `gunracks` (
  `rackID` int(12) NOT NULL,
  `rackHouse` int(12) DEFAULT 0,
  `rackX` float DEFAULT 0,
  `rackY` float DEFAULT 0,
  `rackZ` float DEFAULT 0,
  `rackA` float DEFAULT 0,
  `rackInterior` int(12) DEFAULT 0,
  `rackWorld` int(12) DEFAULT 0,
  `rackWeapon1` int(12) DEFAULT 0,
  `rackAmmo1` int(12) DEFAULT 0,
  `rackWeapon2` int(12) DEFAULT 0,
  `rackAmmo2` int(12) DEFAULT 0,
  `rackWeapon3` int(12) DEFAULT 0,
  `rackAmmo3` int(12) DEFAULT 0,
  `rackWeapon4` int(12) DEFAULT 0,
  `rackAmmo4` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `houseID` int(12) NOT NULL,
  `houseOwner` int(12) DEFAULT 0,
  `housePrice` int(12) DEFAULT 0,
  `houseAddress` varchar(32) DEFAULT NULL,
  `housePosX` float DEFAULT 0,
  `housePosY` float DEFAULT 0,
  `housePosZ` float DEFAULT 0,
  `housePosA` float DEFAULT 0,
  `houseIntX` float DEFAULT 0,
  `houseIntY` float DEFAULT 0,
  `houseIntZ` float DEFAULT 0,
  `houseIntA` float DEFAULT 0,
  `houseInterior` int(12) DEFAULT 0,
  `houseInteriorVW` int(4) NOT NULL DEFAULT 0,
  `houseExterior` int(12) DEFAULT 0,
  `houseExteriorVW` int(12) DEFAULT 0,
  `houseLocked` int(4) DEFAULT 0,
  `houseWeapon1` int(12) DEFAULT 0,
  `houseAmmo1` int(12) DEFAULT 0,
  `houseWeapon2` int(12) DEFAULT 0,
  `houseAmmo2` int(12) DEFAULT 0,
  `houseWeapon3` int(12) DEFAULT 0,
  `houseAmmo3` int(12) DEFAULT 0,
  `houseWeapon4` int(12) DEFAULT 0,
  `houseAmmo4` int(12) DEFAULT 0,
  `houseWeapon5` int(12) DEFAULT 0,
  `houseAmmo5` int(12) DEFAULT 0,
  `houseWeapon6` int(12) DEFAULT 0,
  `houseAmmo6` int(12) DEFAULT 0,
  `houseWeapon7` int(12) DEFAULT 0,
  `houseAmmo7` int(12) DEFAULT 0,
  `houseWeapon8` int(12) DEFAULT 0,
  `houseAmmo8` int(12) DEFAULT 0,
  `houseWeapon9` int(12) DEFAULT 0,
  `houseAmmo9` int(12) DEFAULT 0,
  `houseWeapon10` int(12) DEFAULT 0,
  `houseAmmo10` int(12) DEFAULT 0,
  `houseMoney` int(12) DEFAULT 0,
  `houseLocation` int(4) NOT NULL DEFAULT 0,
  `houseMaxLoc` int(4) NOT NULL DEFAULT 0,
  `houseLocNum` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `housestorage`
--

CREATE TABLE `housestorage` (
  `ID` int(12) DEFAULT 0,
  `itemID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT 0,
  `itemQuantity` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `impoundlots`
--

CREATE TABLE `impoundlots` (
  `impoundID` int(12) NOT NULL,
  `impoundLotX` float DEFAULT 0,
  `impoundLotY` float DEFAULT 0,
  `impoundLotZ` float DEFAULT 0,
  `impoundReleaseX` float DEFAULT 0,
  `impoundReleaseY` float DEFAULT 0,
  `impoundReleaseZ` float DEFAULT 0,
  `impoundReleaseInt` int(12) DEFAULT 0,
  `impoundReleaseWorld` int(12) DEFAULT 0,
  `impoundReleaseA` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `ID` int(12) DEFAULT 0,
  `invID` int(12) NOT NULL,
  `invItem` varchar(32) DEFAULT NULL,
  `invModel` int(12) DEFAULT 0,
  `invQuantity` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `jobID` int(12) NOT NULL,
  `jobPosX` float DEFAULT 0,
  `jobPosY` float DEFAULT 0,
  `jobPosZ` float DEFAULT 0,
  `jobPointX` float DEFAULT 0,
  `jobPointY` float DEFAULT 0,
  `jobPointZ` float DEFAULT 0,
  `jobDeliverX` float DEFAULT 0,
  `jobDeliverY` float DEFAULT 0,
  `jobDeliverZ` float DEFAULT 0,
  `jobInterior` int(12) DEFAULT 0,
  `jobWorld` int(12) DEFAULT 0,
  `jobType` int(12) DEFAULT 0,
  `jobPointInt` int(12) DEFAULT 0,
  `jobPointWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `namechanges`
--

CREATE TABLE `namechanges` (
  `ID` int(12) NOT NULL,
  `OldName` varchar(24) DEFAULT NULL,
  `NewName` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `news_id` int(4) NOT NULL,
  `news_name` text NOT NULL,
  `news_desc` text NOT NULL,
  `news_postedby` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `openworldmaison`
--

CREATE TABLE `openworldmaison` (
  `OpenWorldMID` int(4) NOT NULL,
  `OpenWorldMModel` int(8) NOT NULL DEFAULT 2000,
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
  `OpenWorldMOwner` int(4) DEFAULT -1,
  `OpenWorldMAddress` varchar(32) NOT NULL,
  `OpenWorldMPrice` int(8) NOT NULL DEFAULT 1000,
  `OpenWorldMBoom` int(4) NOT NULL DEFAULT 0,
  `OpenWorldMCommandX` float DEFAULT NULL,
  `OpenWorldMCommandY` float DEFAULT NULL,
  `OpenWorldMCommandZ` float DEFAULT NULL,
  `OpenWorldMCommandR` float DEFAULT NULL,
  `OpenWorldMLocked` int(4) DEFAULT NULL,
  `OpenWorldMSpeed` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- --------------------------------------------------------

--
-- Table structure for table `plants`
--

CREATE TABLE `plants` (
  `plantID` int(12) NOT NULL,
  `plantType` int(12) DEFAULT 0,
  `plantDrugs` int(12) DEFAULT 0,
  `plantX` float DEFAULT 0,
  `plantY` float DEFAULT 0,
  `plantZ` float DEFAULT 0,
  `plantA` float DEFAULT 0,
  `plantInterior` int(12) DEFAULT 0,
  `plantWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pumps`
--

CREATE TABLE `pumps` (
  `ID` int(12) DEFAULT 0,
  `pumpID` int(12) NOT NULL,
  `pumpPosX` float DEFAULT 0,
  `pumpPosY` float DEFAULT 0,
  `pumpPosZ` float DEFAULT 0,
  `pumpPosA` float DEFAULT 0,
  `pumpFuel` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `salairefbi`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairefbi`
--

INSERT INTO `salairefbi` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salairejob`
--

CREATE TABLE `salairejob` (
  `id` int(12) DEFAULT 50,
  `salairecariste` int(12) DEFAULT 50,
  `salairemanutentionnaire` int(12) DEFAULT 50,
  `salairedock` int(12) DEFAULT 50,
  `salairelaitier` int(12) DEFAULT 50,
  `salaireminer` int(12) DEFAULT 50,
  `salaireusineelectronic` int(12) DEFAULT 50,
  `salairebucheron` int(12) DEFAULT 50,
  `salairemenuisier` int(12) DEFAULT 50,
  `salairegenerateur` int(12) DEFAULT 50,
  `salaireelectricien` int(12) DEFAULT 50,
  `salairearme` int(12) DEFAULT 50,
  `salairepetrolier` int(12) DEFAULT 50,
  `salaireboucher` int(12) DEFAULT 50
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairejob`
--

INSERT INTO `salairejob` (`id`, `salairecariste`, `salairemanutentionnaire`, `salairedock`, `salairelaitier`, `salaireminer`, `salaireusineelectronic`, `salairebucheron`, `salairemenuisier`, `salairegenerateur`, `salaireelectricien`, `salairearme`, `salairepetrolier`, `salaireboucher`) VALUES
(1, 50, 60, 50, 18, 50, 50, 75, 50, 100, 75, 50, 75, 50);

-- --------------------------------------------------------

--
-- Table structure for table `salairejournaliste`
--

CREATE TABLE `salairejournaliste` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairejournaliste`
--

INSERT INTO `salairejournaliste` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 700, 800, 1000, 1200, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salairelivreurbiz`
--

CREATE TABLE `salairelivreurbiz` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairelivreurbiz`
--

INSERT INTO `salairelivreurbiz` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1000, 0, 1100, 1150, 1200, 1250, 1, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salairemairie`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairemairie`
--

INSERT INTO `salairemairie` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 800, 850, 900, 950, 1050, 1100, 1150, 1200, 2500, 2500, 1350, 2400, 2500, 1200, 2500);

-- --------------------------------------------------------

--
-- Table structure for table `salairemecano3`
--

CREATE TABLE `salairemecano3` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairemecano3`
--

INSERT INTO `salairemecano3` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1, 550, 700, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salairemecano4`
--

CREATE TABLE `salairemecano4` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairemecano4`
--

INSERT INTO `salairemecano4` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 2000, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salairepolice`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairepolice`
--

INSERT INTO `salairepolice` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1000, 1250, 1500, 1750, 2000, 2125, 2250, 2500, 2500, 2500, 2500, 2250, 2250, 2500, 2500);

-- --------------------------------------------------------

--
-- Table structure for table `salaireswat`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salaireswat`
--

INSERT INTO `salaireswat` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `salaireurgentiste`
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salaireurgentiste`
--

INSERT INTO `salaireurgentiste` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1100, 1100, 1200, 1200, 1300, 1300, 1450, 1450, 1600, 1600, 1750, 1750, 1900, 1900, 2000);

-- --------------------------------------------------------

--
-- Table structure for table `salairevendeurrue`
--

CREATE TABLE `salairevendeurrue` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `salairevendeurrue`
--

INSERT INTO `salairevendeurrue` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `serveursetting`
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
  `villeactive` int(4) NOT NULL DEFAULT 1,
  `nouveau` int(11) NOT NULL,
  `police` int(4) NOT NULL DEFAULT 0,
  `swat` int(4) NOT NULL DEFAULT 0,
  `whiteliste` int(4) NOT NULL DEFAULT 0,
  `discord` varchar(128) NOT NULL DEFAULT '0',
  `verifier` varchar(20) NOT NULL DEFAULT '0',
  `admin1` varchar(20) NOT NULL DEFAULT '0',
  `admin2` varchar(20) NOT NULL DEFAULT '0',
  `admin3` varchar(20) NOT NULL DEFAULT '0',
  `admin4` varchar(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `serveursetting`
--

INSERT INTO `serveursetting` (`id`, `motd`, `afkactive`, `afktime`, `braquagenpcactive`, `braquagebanqueactive`, `oocactive`, `pmactive`, `villeactive`, `nouveau`, `police`, `swat`, `whiteliste`, `discord`, `verifier`, `admin1`, `admin2`, `admin3`, `admin4`) VALUES
(1, 'Sun Vice vous souhaites la bienvenue!', 1, 15, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `slotmachine`
--

CREATE TABLE `slotmachine` (
  `id` int(4) NOT NULL,
  `X` float DEFAULT 0,
  `Y` float DEFAULT 0,
  `Z` float DEFAULT 0,
  `RX` float DEFAULT 0,
  `RY` float DEFAULT 0,
  `RZ` float DEFAULT 0,
  `slotint` float DEFAULT 0,
  `slotvw` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `speedcameras`
--

CREATE TABLE `speedcameras` (
  `speedID` int(12) NOT NULL,
  `speedRange` float DEFAULT 0,
  `speedLimit` float DEFAULT 0,
  `speedX` float DEFAULT 0,
  `speedY` float DEFAULT 0,
  `speedZ` float DEFAULT 0,
  `speedAngle` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `ID` int(12) DEFAULT 0,
  `ticketID` int(12) NOT NULL,
  `ticketFee` int(12) DEFAULT 0,
  `ticketBy` varchar(24) DEFAULT NULL,
  `ticketDate` varchar(36) DEFAULT NULL,
  `ticketReason` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `vendorID` int(12) NOT NULL,
  `vendorType` int(12) DEFAULT 0,
  `vendorX` float DEFAULT 0,
  `vendorY` float DEFAULT 0,
  `vendorZ` float DEFAULT 0,
  `vendorA` float DEFAULT 0,
  `vendorInterior` int(12) DEFAULT 0,
  `vendorWorld` int(12) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `Name` varchar(24) NOT NULL,
  `Votes` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `warrants`
--

CREATE TABLE `warrants` (
  `ID` int(12) NOT NULL,
  `Suspect` varchar(24) DEFAULT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL,
  `Description` varchar(128) DEFAULT NULL,
  `IDchar` int(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `actors`
--
ALTER TABLE `actors`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `ID` (`ID`);

--
-- Indexes for table `atm`
--
ALTER TABLE `atm`
  ADD PRIMARY KEY (`atmID`);

--
-- Indexes for table `backpackitems`
--
ALTER TABLE `backpackitems`
  ADD PRIMARY KEY (`itemID`);

--
-- Indexes for table `backpacks`
--
ALTER TABLE `backpacks`
  ADD PRIMARY KEY (`backpackID`);

--
-- Indexes for table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `batiements`
--
ALTER TABLE `batiements`
  ADD PRIMARY KEY (`batiementID`),
  ADD UNIQUE KEY `batiementID` (`batiementID`);

--
-- Indexes for table `billboards`
--
ALTER TABLE `billboards`
  ADD PRIMARY KEY (`bbID`);

--
-- Indexes for table `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`Username`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- Indexes for table `businesses`
--
ALTER TABLE `businesses`
  ADD PRIMARY KEY (`bizID`);

--
-- Indexes for table `caisses`
--
ALTER TABLE `caisses`
  ADD PRIMARY KEY (`caisseID`),
  ADD KEY `caisseID` (`caisseID`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`carID`);

--
-- Indexes for table `carstorage`
--
ALTER TABLE `carstorage`
  ADD PRIMARY KEY (`itemID`);

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contactID`);

--
-- Indexes for table `crates`
--
ALTER TABLE `crates`
  ADD PRIMARY KEY (`crateID`);

--
-- Indexes for table `cvfbi`
--
ALTER TABLE `cvfbi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvjournaliste`
--
ALTER TABLE `cvjournaliste`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvlivraisonbiz`
--
ALTER TABLE `cvlivraisonbiz`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvmairie`
--
ALTER TABLE `cvmairie`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvmecanozone3`
--
ALTER TABLE `cvmecanozone3`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvmecanozone4`
--
ALTER TABLE `cvmecanozone4`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvpetitlivreur`
--
ALTER TABLE `cvpetitlivreur`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvpolice`
--
ALTER TABLE `cvpolice`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvswat`
--
ALTER TABLE `cvswat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvtaxi`
--
ALTER TABLE `cvtaxi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvurgentiste`
--
ALTER TABLE `cvurgentiste`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cvvendeurrue`
--
ALTER TABLE `cvvendeurrue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dealervehicles`
--
ALTER TABLE `dealervehicles`
  ADD PRIMARY KEY (`vehID`);

--
-- Indexes for table `death`
--
ALTER TABLE `death`
  ADD PRIMARY KEY (`dID`);

--
-- Indexes for table `detectors`
--
ALTER TABLE `detectors`
  ADD PRIMARY KEY (`detectorID`);

--
-- Indexes for table `dropped`
--
ALTER TABLE `dropped`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `entrances`
--
ALTER TABLE `entrances`
  ADD PRIMARY KEY (`entranceID`);

--
-- Indexes for table `factions`
--
ALTER TABLE `factions`
  ADD PRIMARY KEY (`factionID`);

--
-- Indexes for table `factorystock`
--
ALTER TABLE `factorystock`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`furnitureID`);

--
-- Indexes for table `furnitures`
--
ALTER TABLE `furnitures`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `garbage`
--
ALTER TABLE `garbage`
  ADD PRIMARY KEY (`garbageID`);

--
-- Indexes for table `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`gateID`);

--
-- Indexes for table `gouvernement`
--
ALTER TABLE `gouvernement`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gps`
--
ALTER TABLE `gps`
  ADD PRIMARY KEY (`locationID`);

--
-- Indexes for table `graffiti`
--
ALTER TABLE `graffiti`
  ADD PRIMARY KEY (`graffitiID`);

--
-- Indexes for table `gunracks`
--
ALTER TABLE `gunracks`
  ADD PRIMARY KEY (`rackID`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`houseID`);

--
-- Indexes for table `housestorage`
--
ALTER TABLE `housestorage`
  ADD PRIMARY KEY (`itemID`);

--
-- Indexes for table `impoundlots`
--
ALTER TABLE `impoundlots`
  ADD PRIMARY KEY (`impoundID`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`invID`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`jobID`);

--
-- Indexes for table `namechanges`
--
ALTER TABLE `namechanges`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`news_id`);

--
-- Indexes for table `openworldmaison`
--
ALTER TABLE `openworldmaison`
  ADD PRIMARY KEY (`OpenWorldMID`);

--
-- Indexes for table `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`plantID`);

--
-- Indexes for table `pumps`
--
ALTER TABLE `pumps`
  ADD PRIMARY KEY (`pumpID`);

--
-- Indexes for table `salairefbi`
--
ALTER TABLE `salairefbi`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairejob`
--
ALTER TABLE `salairejob`
  ADD KEY `id` (`id`);

--
-- Indexes for table `salairejournaliste`
--
ALTER TABLE `salairejournaliste`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairelivreurbiz`
--
ALTER TABLE `salairelivreurbiz`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairemairie`
--
ALTER TABLE `salairemairie`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairemecano3`
--
ALTER TABLE `salairemecano3`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairemecano4`
--
ALTER TABLE `salairemecano4`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairepolice`
--
ALTER TABLE `salairepolice`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salaireswat`
--
ALTER TABLE `salaireswat`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salaireurgentiste`
--
ALTER TABLE `salaireurgentiste`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `salairevendeurrue`
--
ALTER TABLE `salairevendeurrue`
  ADD PRIMARY KEY (`idfaction`);

--
-- Indexes for table `serveursetting`
--
ALTER TABLE `serveursetting`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `verifier` (`verifier`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `slotmachine`
--
ALTER TABLE `slotmachine`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `speedcameras`
--
ALTER TABLE `speedcameras`
  ADD PRIMARY KEY (`speedID`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`ticketID`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`vendorID`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD UNIQUE KEY `Names` (`Name`);

--
-- Indexes for table `warrants`
--
ALTER TABLE `warrants`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=380;

--
-- AUTO_INCREMENT for table `actors`
--
ALTER TABLE `actors`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `atm`
--
ALTER TABLE `atm`
  MODIFY `atmID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `backpackitems`
--
ALTER TABLE `backpackitems`
  MODIFY `itemID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `backpacks`
--
ALTER TABLE `backpacks`
  MODIFY `backpackID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `batiements`
--
ALTER TABLE `batiements`
  MODIFY `batiementID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `billboards`
--
ALTER TABLE `billboards`
  MODIFY `bbID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `businesses`
--
ALTER TABLE `businesses`
  MODIFY `bizID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `caisses`
--
ALTER TABLE `caisses`
  MODIFY `caisseID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `carID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT for table `carstorage`
--
ALTER TABLE `carstorage`
  MODIFY `itemID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `characters`
--
ALTER TABLE `characters`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=437;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contactID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crates`
--
ALTER TABLE `crates`
  MODIFY `crateID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cvfbi`
--
ALTER TABLE `cvfbi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvjournaliste`
--
ALTER TABLE `cvjournaliste`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvlivraisonbiz`
--
ALTER TABLE `cvlivraisonbiz`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvmairie`
--
ALTER TABLE `cvmairie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvmecanozone3`
--
ALTER TABLE `cvmecanozone3`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvmecanozone4`
--
ALTER TABLE `cvmecanozone4`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvpetitlivreur`
--
ALTER TABLE `cvpetitlivreur`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvpolice`
--
ALTER TABLE `cvpolice`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvswat`
--
ALTER TABLE `cvswat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvtaxi`
--
ALTER TABLE `cvtaxi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvurgentiste`
--
ALTER TABLE `cvurgentiste`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cvvendeurrue`
--
ALTER TABLE `cvvendeurrue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dealervehicles`
--
ALTER TABLE `dealervehicles`
  MODIFY `vehID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `death`
--
ALTER TABLE `death`
  MODIFY `dID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `detectors`
--
ALTER TABLE `detectors`
  MODIFY `detectorID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `dropped`
--
ALTER TABLE `dropped`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `entrances`
--
ALTER TABLE `entrances`
  MODIFY `entranceID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `factions`
--
ALTER TABLE `factions`
  MODIFY `factionID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `factorystock`
--
ALTER TABLE `factorystock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `furnitureID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `garbage`
--
ALTER TABLE `garbage`
  MODIFY `garbageID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT for table `gates`
--
ALTER TABLE `gates`
  MODIFY `gateID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `gouvernement`
--
ALTER TABLE `gouvernement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `gps`
--
ALTER TABLE `gps`
  MODIFY `locationID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `graffiti`
--
ALTER TABLE `graffiti`
  MODIFY `graffitiID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gunracks`
--
ALTER TABLE `gunracks`
  MODIFY `rackID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `houseID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `housestorage`
--
ALTER TABLE `housestorage`
  MODIFY `itemID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `impoundlots`
--
ALTER TABLE `impoundlots`
  MODIFY `impoundID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `invID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `jobID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `namechanges`
--
ALTER TABLE `namechanges`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `news_id` int(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `openworldmaison`
--
ALTER TABLE `openworldmaison`
  MODIFY `OpenWorldMID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `plants`
--
ALTER TABLE `plants`
  MODIFY `plantID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pumps`
--
ALTER TABLE `pumps`
  MODIFY `pumpID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `salairefbi`
--
ALTER TABLE `salairefbi`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairejournaliste`
--
ALTER TABLE `salairejournaliste`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairelivreurbiz`
--
ALTER TABLE `salairelivreurbiz`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairemairie`
--
ALTER TABLE `salairemairie`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairemecano3`
--
ALTER TABLE `salairemecano3`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairemecano4`
--
ALTER TABLE `salairemecano4`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairepolice`
--
ALTER TABLE `salairepolice`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salaireswat`
--
ALTER TABLE `salaireswat`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salaireurgentiste`
--
ALTER TABLE `salaireurgentiste`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `salairevendeurrue`
--
ALTER TABLE `salairevendeurrue`
  MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `slotmachine`
--
ALTER TABLE `slotmachine`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `speedcameras`
--
ALTER TABLE `speedcameras`
  MODIFY `speedID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `ticketID` int(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `vendorID` int(12) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `warrants`
--
ALTER TABLE `warrants`
  MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
