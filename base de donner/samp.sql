-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u3
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Sam 05 Janvier 2019 à 23:22
-- Version du serveur :  5.5.60-0+deb8u1
-- Version de PHP :  5.6.38-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `samp2`
--

-- --------------------------------------------------------

--
-- Structure de la table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
`ID` int(12) NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Password` varchar(129) DEFAULT NULL,
  `RegisterDate` varchar(36) DEFAULT NULL,
  `LoginDate` varchar(36) DEFAULT NULL,
  `IP` varchar(16) DEFAULT 'n/a'
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=latin1;

--
-- Structure de la table `actors`
--

CREATE TABLE IF NOT EXISTS `actors` (
  `ID` int(11) NOT NULL,
  `Skinid` int(3) NOT NULL,
  `Float` varchar(220) NOT NULL,
  `actorint` int(4) NOT NULL DEFAULT '0',
  `actorvw` int(4) NOT NULL DEFAULT '0',
  `actorsetting` int(4) NOT NULL DEFAULT '0',
  `Text` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Structure de la table `arrestpoints`
--

CREATE TABLE IF NOT EXISTS `arrestpoints` (
  `arrestID` int(11) NOT NULL,
  `arrestX` float NOT NULL,
  `arrestY` float NOT NULL,
  `arrestZ` float NOT NULL,
  `arrestInterior` int(11) NOT NULL,
  `arrestWorld` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `atm`
--

CREATE TABLE IF NOT EXISTS `atm` (
`atmID` int(11) NOT NULL,
  `atmX` float NOT NULL,
  `atmY` float NOT NULL,
  `atmZ` float NOT NULL,
  `atmA` float NOT NULL,
  `atmInterior` int(11) NOT NULL,
  `atmWorld` int(11) NOT NULL,
  `destroy` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=latin1;


--
-- Structure de la table `backpackitems`
--

CREATE TABLE IF NOT EXISTS `backpackitems` (
  `ID` int(12) DEFAULT '0',
`itemID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT '0',
  `itemQuantity` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;

--
-- Structure de la table `backpacks`
--

CREATE TABLE IF NOT EXISTS `backpacks` (
`backpackID` int(12) NOT NULL,
  `backpackPlayer` int(12) DEFAULT '0',
  `backpackX` float DEFAULT '0',
  `backpackY` float DEFAULT '0',
  `backpackZ` float DEFAULT '0',
  `backpackInterior` int(12) DEFAULT '0',
  `backpackWorld` int(12) DEFAULT '0',
  `backpackHouse` int(12) DEFAULT '0',
  `backpackVehicle` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;


--
-- Structure de la table `banqueentreprise`
--

CREATE TABLE IF NOT EXISTS `banqueentreprise` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `banqueentreprise`
--

INSERT INTO `banqueentreprise` (`id`, `mecanozone3`, `mecanozone4`, `livraisonzone1`, `mafiazone1`, `mafiazone4`, `police`, `fbi`, `swat`, `mairiels`, `medecin`, `fermier`, `vendeur`, `journaliste`, `banque`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `batiements`
--

CREATE TABLE IF NOT EXISTS `batiements` (
`batiementID` int(12) NOT NULL,
  `batiementModel` int(12) DEFAULT '0',
  `batiementX` float DEFAULT '0',
  `batiementY` float DEFAULT '0',
  `batiementZ` float DEFAULT '0',
  `batiementRX` float DEFAULT '0',
  `batiementRY` float DEFAULT '0',
  `batiementRZ` float DEFAULT '0',
  `batiementInterior` int(12) DEFAULT '0',
  `batiementWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;

--
-- Structure de la table `billboards`
--

CREATE TABLE IF NOT EXISTS `billboards` (
`bbID` int(12) NOT NULL,
  `bbExists` int(12) DEFAULT '0',
  `bbName` varchar(32) DEFAULT NULL,
  `bbOwner` int(12) NOT NULL DEFAULT '0',
  `bbPrice` int(12) NOT NULL DEFAULT '0',
  `bbRange` int(12) DEFAULT '10',
  `bbPosX` float DEFAULT '0',
  `bbPosY` float DEFAULT '0',
  `bbPosZ` float DEFAULT '0',
  `bbMessage` varchar(230) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;


--
-- Structure de la table `blacklist`
--

CREATE TABLE IF NOT EXISTS `blacklist` (
  `IP` varchar(16) NOT NULL DEFAULT '0.0.0.0',
  `Username` varchar(24) NOT NULL DEFAULT '',
  `BannedBy` varchar(24) DEFAULT NULL,
  `Reason` varchar(128) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Structure de la table `businesses`
--

CREATE TABLE IF NOT EXISTS `businesses` (
`bizID` int(12) NOT NULL,
  `bizName` varchar(32) DEFAULT NULL,
  `bizOwner` int(12) DEFAULT '0',
  `bizType` int(12) DEFAULT '0',
  `bizPrice` int(12) DEFAULT '0',
  `bizPosX` float DEFAULT '0',
  `bizPosY` float DEFAULT '0',
  `bizPosZ` float DEFAULT '0',
  `bizPosA` float DEFAULT '0',
  `bizIntX` float DEFAULT '0',
  `bizIntY` float DEFAULT '0',
  `bizIntZ` float DEFAULT '0',
  `bizIntA` float DEFAULT '0',
  `bizInterior` int(12) DEFAULT '0',
  `bizInteriorVW` int(4) NOT NULL DEFAULT '0',
  `bizExterior` int(12) DEFAULT '0',
  `bizExteriorVW` int(12) DEFAULT '0',
  `bizLocked` int(4) DEFAULT '0',
  `bizVault` int(12) DEFAULT '0',
  `bizProducts` int(12) DEFAULT '0',
  `bizPrice1` int(12) DEFAULT '0',
  `bizPrice2` int(12) DEFAULT '0',
  `bizPrice3` int(12) DEFAULT '0',
  `bizPrice4` int(12) DEFAULT '0',
  `bizPrice5` int(12) DEFAULT '0',
  `bizPrice6` int(12) DEFAULT '0',
  `bizPrice7` int(12) DEFAULT '0',
  `bizPrice8` int(12) DEFAULT '0',
  `bizPrice9` int(12) DEFAULT '0',
  `bizPrice10` int(12) DEFAULT '0',
  `bizSpawnX` float DEFAULT '0',
  `bizSpawnY` float DEFAULT '0',
  `bizSpawnZ` float DEFAULT '0',
  `bizSpawnA` float DEFAULT '0',
  `bizDeliverX` float DEFAULT '0',
  `bizDeliverY` float DEFAULT '0',
  `bizDeliverZ` float DEFAULT '0',
  `bizMessage` varchar(128) DEFAULT NULL,
  `bizPrice11` int(12) DEFAULT '0',
  `bizPrice12` int(12) DEFAULT '0',
  `bizPrice13` int(12) DEFAULT '0',
  `bizPrice14` int(12) DEFAULT '0',
  `bizPrice15` int(12) DEFAULT '0',
  `bizPrice16` int(12) DEFAULT '0',
  `bizPrice17` int(12) DEFAULT '0',
  `bizPrice18` int(12) DEFAULT '0',
  `bizPrice19` int(12) DEFAULT '0',
  `bizPrice20` int(12) DEFAULT '0',
  `bizShipment` int(4) DEFAULT '0',
  `time1` int(4) NOT NULL DEFAULT '-1',
  `time2` int(4) NOT NULL DEFAULT '-1',
  `chancevole` int(4) NOT NULL DEFAULT '0',
  `defoncer` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=latin1;

--
-- Structure de la table `caisses`
--

CREATE TABLE IF NOT EXISTS `caisses` (
`caisseID` int(12) NOT NULL,
  `caisseX` float DEFAULT '0',
  `caisseY` float DEFAULT '0',
  `caisseZ` float DEFAULT '0',
  `caisseRX` float DEFAULT '0',
  `caisseRY` float DEFAULT '0',
  `caisseRZ` float DEFAULT '0',
  `caisseInterior` int(12) DEFAULT '0',
  `caisseWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;


--
-- Structure de la table `cars`
--

CREATE TABLE IF NOT EXISTS `cars` (
`carID` int(12) NOT NULL,
  `carModel` int(12) DEFAULT '0',
  `carOwner` int(12) DEFAULT '0',
  `carPosX` float DEFAULT '0',
  `carPosY` float DEFAULT '0',
  `carPosZ` float DEFAULT '0',
  `carPosR` float DEFAULT '0',
  `carColor1` int(12) DEFAULT '0',
  `carColor2` int(12) DEFAULT '0',
  `carPaintjob` int(12) DEFAULT '-1',
  `carLocked` int(4) DEFAULT '0',
  `carMod1` int(12) DEFAULT '0',
  `carMod2` int(12) DEFAULT '0',
  `carMod3` int(12) DEFAULT '0',
  `carMod4` int(12) DEFAULT '0',
  `carMod5` int(12) DEFAULT '0',
  `carMod6` int(12) DEFAULT '0',
  `carMod7` int(12) DEFAULT '0',
  `carMod8` int(12) DEFAULT '0',
  `carMod9` int(12) DEFAULT '0',
  `carMod10` int(12) DEFAULT '0',
  `carMod11` int(12) DEFAULT '0',
  `carMod12` int(12) DEFAULT '0',
  `carMod13` int(12) DEFAULT '0',
  `carMod14` int(12) DEFAULT '0',
  `carImpounded` int(12) DEFAULT '0',
  `carWeapon1` int(12) DEFAULT '0',
  `carAmmo1` int(12) DEFAULT '0',
  `carWeapon2` int(12) DEFAULT '0',
  `carAmmo2` int(12) DEFAULT '0',
  `carWeapon3` int(12) DEFAULT '0',
  `carAmmo3` int(12) DEFAULT '0',
  `carWeapon4` int(12) DEFAULT '0',
  `carAmmo4` int(12) DEFAULT '0',
  `carWeapon5` int(12) DEFAULT '0',
  `carAmmo5` int(12) DEFAULT '0',
  `carImpoundPrice` int(12) DEFAULT '0',
  `carFaction` int(12) DEFAULT '0',
  `carLoca` int(11) NOT NULL DEFAULT '-1',
  `carLocaID` int(11) NOT NULL DEFAULT '-1',
  `carDouble` int(11) NOT NULL,
  `carSabot` int(11) NOT NULL,
  `carSabPri` int(11) NOT NULL,
  `vkilometres` float NOT NULL DEFAULT '0',
  `vmetre` int(11) NOT NULL DEFAULT '0',
  `fuel` int(11) NOT NULL DEFAULT '100',
  `carvie` float NOT NULL,
  `alarme` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=latin1;


--
-- Structure de la table `carstorage`
--

CREATE TABLE IF NOT EXISTS `carstorage` (
  `ID` int(12) DEFAULT '0',
`itemID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT '0',
  `itemQuantity` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `characters`
--

CREATE TABLE IF NOT EXISTS `characters` (
`ID` int(12) NOT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Character` varchar(24) DEFAULT NULL,
  `Created` int(4) DEFAULT '0',
  `Gender` int(4) DEFAULT '0',
  `Birthdate` varchar(32) DEFAULT '01/01/1970',
  `Origin` varchar(32) DEFAULT 'Not Specified',
  `Skin` int(12) DEFAULT '0',
  `Glasses` int(12) DEFAULT '0',
  `Hat` int(12) DEFAULT '0',
  `Bandana` int(12) DEFAULT '0',
  `PosX` float DEFAULT '0',
  `PosY` float DEFAULT '0',
  `PosZ` float DEFAULT '0',
  `PosA` float DEFAULT '0',
  `Interior` int(12) DEFAULT '0',
  `World` int(12) DEFAULT '0',
  `GlassesPos` varchar(100) DEFAULT NULL,
  `HatPos` varchar(100) DEFAULT NULL,
  `BandanaPos` varchar(100) DEFAULT NULL,
  `Hospital` int(12) DEFAULT '-1',
  `HospitalInt` int(12) DEFAULT '0',
  `Money` int(12) DEFAULT '0',
  `BankMoney` int(12) DEFAULT '0',
  `OwnsBillboard` int(12) DEFAULT '-1',
  `Savings` int(12) DEFAULT '0',
  `Admin` int(12) DEFAULT '0',
  `JailTime` int(12) DEFAULT '0',
  `Muted` int(4) DEFAULT '0',
  `CreateDate` int(12) DEFAULT '0',
  `LastLogin` int(12) DEFAULT '0',
  `Tester` int(4) DEFAULT '0',
  `Gun1` int(12) DEFAULT '0',
  `Gun2` int(12) DEFAULT '0',
  `Gun3` int(12) DEFAULT '0',
  `Gun4` int(12) DEFAULT '0',
  `Gun5` int(12) DEFAULT '0',
  `Gun6` int(12) DEFAULT '0',
  `Gun7` int(12) DEFAULT '0',
  `Gun8` int(12) DEFAULT '0',
  `Gun9` int(12) DEFAULT '0',
  `Gun10` int(12) DEFAULT '0',
  `Gun11` int(12) DEFAULT '0',
  `Gun12` int(12) DEFAULT '0',
  `Gun13` int(12) DEFAULT '0',
  `Ammo1` int(12) DEFAULT '0',
  `Ammo2` int(12) DEFAULT '0',
  `Ammo3` int(12) DEFAULT '0',
  `Ammo4` int(12) DEFAULT '0',
  `Ammo5` int(12) DEFAULT '0',
  `Ammo6` int(12) DEFAULT '0',
  `Ammo7` int(12) DEFAULT '0',
  `Ammo8` int(12) DEFAULT '0',
  `Ammo9` int(12) DEFAULT '0',
  `Ammo10` int(12) DEFAULT '0',
  `Ammo11` int(12) DEFAULT '0',
  `Ammo12` int(12) DEFAULT '0',
  `Ammo13` int(12) DEFAULT '0',
  `House` int(12) DEFAULT '-1',
  `Business` int(12) DEFAULT '-1',
  `Phone` int(12) DEFAULT '0',
  `Lottery` int(12) DEFAULT '0',
  `Hunger` int(12) DEFAULT '100',
  `Thirst` int(12) DEFAULT '100',
  `PlayingHours` int(12) DEFAULT '0',
  `Minutes` int(12) DEFAULT '0',
  `ArmorStatus` float DEFAULT '0',
  `Entrance` int(12) DEFAULT '0',
  `Job` int(12) DEFAULT '0',
  `Faction` int(12) DEFAULT '-1',
  `FactionRank` int(12) DEFAULT '0',
  `Prisoned` int(4) DEFAULT '0',
  `Warrants` int(12) DEFAULT '0',
  `Injured` int(4) DEFAULT '0',
  `Health` float DEFAULT '0',
  `Channel` int(12) DEFAULT '0',
  `Accent` varchar(24) DEFAULT NULL,
  `Bleeding` int(4) DEFAULT '0',
  `Warnings` int(12) DEFAULT '0',
  `Warn1` varchar(32) DEFAULT NULL,
  `Warn2` varchar(32) DEFAULT NULL,
  `MaskID` int(12) DEFAULT '0',
  `FactionMod` int(12) DEFAULT '0',
  `Capacity` int(12) DEFAULT '35',
  `AdminHide` int(4) DEFAULT '0',
  `LotteryB` int(11) NOT NULL,
  `SpawnPoint` int(11) NOT NULL,
  `connecter` int(4) NOT NULL DEFAULT '0',
  `bracelet` int(4) NOT NULL DEFAULT '0',
  `braceletdist` int(4) NOT NULL DEFAULT '0',
  `LocaID` int(4) NOT NULL DEFAULT '0',
  `CarD` int(4) NOT NULL DEFAULT '-1',
  `LocaMaisonID` int(4) NOT NULL DEFAULT '0',
  `baterietel` int(4) NOT NULL DEFAULT '20',
  `BestScore` int(4) NOT NULL DEFAULT '0',
  `Strike` int(4) NOT NULL DEFAULT '0',
  `Repetition` int(8) NOT NULL DEFAULT '0',
  `Parcouru` int(8) NOT NULL DEFAULT '0',
  `Noob` int(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB AUTO_INCREMENT=299 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `contacts`
--

CREATE TABLE IF NOT EXISTS `contacts` (
  `ID` int(12) DEFAULT '0',
`contactID` int(12) NOT NULL,
  `contactName` varchar(32) DEFAULT NULL,
  `contactNumber` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `crates`
--

CREATE TABLE IF NOT EXISTS `crates` (
`crateID` int(12) NOT NULL,
  `crateType` int(12) DEFAULT '0',
  `crateX` float DEFAULT '0',
  `crateY` float DEFAULT '0',
  `crateZ` float DEFAULT '0',
  `crateA` float DEFAULT '0',
  `crateInterior` int(12) DEFAULT '0',
  `crateWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvfbi`
--

CREATE TABLE IF NOT EXISTS `cvfbi` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `cvjournaliste`
--

CREATE TABLE IF NOT EXISTS `cvjournaliste` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvlivraisonbiz`
--

CREATE TABLE IF NOT EXISTS `cvlivraisonbiz` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `cvmairie`
--

CREATE TABLE IF NOT EXISTS `cvmairie` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvmecanozone3`
--

CREATE TABLE IF NOT EXISTS `cvmecanozone3` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvmecanozone4`
--

CREATE TABLE IF NOT EXISTS `cvmecanozone4` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvpetitlivreur`
--

CREATE TABLE IF NOT EXISTS `cvpetitlivreur` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvpolice`
--

CREATE TABLE IF NOT EXISTS `cvpolice` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvswat`
--

CREATE TABLE IF NOT EXISTS `cvswat` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `cvtaxi`
--

CREATE TABLE IF NOT EXISTS `cvtaxi` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;



-- --------------------------------------------------------

--
-- Structure de la table `cvurgentiste`
--

CREATE TABLE IF NOT EXISTS `cvurgentiste` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `cvvendeurrue`
--

CREATE TABLE IF NOT EXISTS `cvvendeurrue` (
`id` int(11) NOT NULL,
  `pseudo` varchar(24) NOT NULL,
  `telephone` int(12) NOT NULL,
  `naissance` varchar(32) NOT NULL,
  `sexe` int(4) NOT NULL,
  `origine` varchar(32) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `dealervehicles`
--

CREATE TABLE IF NOT EXISTS `dealervehicles` (
  `ID` int(12) DEFAULT '0',
`vehID` int(12) NOT NULL,
  `vehModel` int(12) DEFAULT '0',
  `vehPrice` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=latin1;


--
-- Structure de la table `detectors`
--

CREATE TABLE IF NOT EXISTS `detectors` (
`detectorID` int(12) NOT NULL,
  `detectorX` float DEFAULT '0',
  `detectorY` float DEFAULT '0',
  `detectorZ` float DEFAULT '0',
  `detectorAngle` float DEFAULT '0',
  `detectorInterior` int(12) DEFAULT '0',
  `detectorWorld` int(12) DEFAULT '0'
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `dropped`
--

CREATE TABLE IF NOT EXISTS `dropped` (
`ID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT '0',
  `itemX` float DEFAULT '0',
  `itemY` float DEFAULT '0',
  `itemZ` float DEFAULT '0',
  `itemInt` int(12) DEFAULT '0',
  `itemWorld` int(12) DEFAULT '0',
  `itemQuantity` int(12) DEFAULT '0',
  `itemAmmo` int(12) DEFAULT '0',
  `itemWeapon` int(12) DEFAULT '0',
  `itemPlayer` varchar(24) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=520 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `entrances`
--

CREATE TABLE IF NOT EXISTS `entrances` (
`entranceID` int(12) NOT NULL,
  `entranceName` varchar(32) DEFAULT NULL,
  `entranceIcon` int(12) DEFAULT '0',
  `entrancePosX` float DEFAULT '0',
  `entrancePosY` float DEFAULT '0',
  `entrancePosZ` float DEFAULT '0',
  `entrancePosA` float DEFAULT '0',
  `entranceIntX` float DEFAULT '0',
  `entranceIntY` float DEFAULT '0',
  `entranceIntZ` float DEFAULT '0',
  `entranceIntA` float DEFAULT '0',
  `entranceInterior` int(12) DEFAULT '0',
  `entranceExterior` int(12) DEFAULT '0',
  `entranceExteriorVW` int(12) DEFAULT '0',
  `entranceType` int(12) DEFAULT '0',
  `entrancePass` varchar(32) DEFAULT NULL,
  `entranceLocked` int(12) DEFAULT '0',
  `entranceCustom` int(4) DEFAULT '0',
  `entranceWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `entrances`
--

INSERT INTO `entrances` (`entranceID`, `entranceName`, `entranceIcon`, `entrancePosX`, `entrancePosY`, `entrancePosZ`, `entrancePosA`, `entranceIntX`, `entranceIntY`, `entranceIntZ`, `entranceIntA`, `entranceInterior`, `entranceExterior`, `entranceExteriorVW`, `entranceType`, `entrancePass`, `entranceLocked`, `entranceCustom`, `entranceWorld`) VALUES
(2, 'Auto-Ecole', 55, 2045.04, -1908.06, 13.5467, 100.882, -2029.55, -118.8, 1035.17, 0, 3, 0, 0, 1, '', 0, 0, 7002),
(5, 'Mairie', 35, 1309.98, -1367.57, 13.5374, 352.201, -501.114, 286.605, 2001.09, 3.6551, 1, 0, 0, 4, '', 0, 1, 7005),
(25, 'A.N.P.E', 13, 1699.2, -1667.9, 20.1949, 268.779, 316.874, 119.304, 1011.76, 9.612, 1, 0, 0, 10, '', 0, 1, 0),
(27, 'Abatoire', 0, 1111.52, -976.441, 42.7656, 181.98, 964.355, 2107.85, 1011.03, 90.1714, 1, 0, 0, 0, '', 0, 1, 7027),
(28, 'Cariste', 0, 998.808, -1246.43, 19.3977, 275.553, 1291.82, 5.8713, 1001.01, 180, 18, 0, 0, 3, '', 0, 1, 7028),
(29, 'Usine', 0, 2657.46, -1589.32, 13.9792, 33.1244, 2570.17, -1301.73, 1044.12, 349.603, 2, 0, 0, 0, '', 0, 1, 7029),
(30, 'Salle des machines', 0, 2490.97, -2468.47, 17.8828, 58.3809, -959.683, 1954.82, 9, 179.966, 17, 0, 0, 0, '', 0, 1, 7030),
(31, 'Central éléctrique', 0, 2466.93, -2495.67, 13.6509, 312.305, 813.416, -69.8078, 1000.78, 75.4156, 1, 0, 0, 0, '', 0, 1, 7031),
(32, 'Banque Riche', 52, 597.049, -1249.52, 18.2972, 354.704, 1455.83, -987.753, 996.105, 83.7797, 6, 0, 0, 2, '', 0, 0, 7010),
(34, 'Casino', 25, 1284.34, -1585.31, 13.5466, 155.66, -251.957, -21.1578, 1004.69, 90, 3, 0, 0, 6, '', 0, 1, 7034),
(35, 'Taxi', 0, 1275.05, -1662.61, 19.7343, 80.6309, -1972.14, -897.436, 757.898, 270.44, 1, 0, 0, 0, '', 0, 1, 7035),
(36, 'Shooting Range', 0, 1368.91, -1279.8, 13.5468, 289.02, 304.017, -141.989, 1004.06, 90, 7, 0, 0, 5, '', 0, 0, 7036),
(38, 'Bowling', 0, 1007.27, -1342.73, 13.3608, 181.6, -1992.7, 407.879, 2.5009, 268.706, 1, 0, 0, 9, '', 0, 1, 7038),
(39, 'Entrepôt', 0, 1083.02, -1226.58, 15.8203, 93.8062, 2606.47, -1233.46, 1022.03, 272.707, 1, 0, 0, 0, '', 0, 1, 7039),
(51, 'Gymnase', 0, 2229.89, -1721.25, 13.5611, 324.435, 772.428, -5.4299, 1000.73, 356.914, 5, 0, 0, 0, '', 0, 0, 7051),
(55, 'HCLI', 0, 2460.17, -2132.67, 17.2712, 351.867, 1280.18, -867.876, 1085.62, 92.5365, 0, 0, 0, 0, '', 0, 0, 0),
(58, 'Hall de la tour', 0, 1571.17, -1337.04, 16.4843, 118.575, 1395.28, -1586.44, 1087.09, 104.783, 6, 0, 0, 0, '', 0, 0, 3000),
(59, 'PMU', 0, 1631.93, -1172.93, 24.0842, 176.667, 833.491, 7.3242, 1003.52, 90, 3, 0, 0, 7, '', 0, 0, 7059),
(64, 'Usine de meubles', 0, 614.623, -1529.62, 15.1874, 80.4841, 1626.63, -1811.32, 1013.43, 90.6977, 210, 0, 0, 0, '', 0, 0, 7064),
(73, 'Fabrique d''arme', 0, 1616.25, -1897.09, 13.5491, 157.742, 2332.91, 5.5956, 1026.5, 92.287, 1, 0, 0, 0, '', 0, 1, 1),
(79, 'Los Santos Police Departement', 0, 1555.46, -1675.62, 16.1951, 276.081, 1561.44, -1675.98, 16.1898, 263.661, 0, 0, 0, 8, '', 0, 2, 0),
(80, 'Los Santos Custom', 0, 1069.18, -1681.58, 13.5303, 11.2569, 1068.88, -1679.88, 13.5401, 3.146, 0, 0, 0, 0, '', 0, 0, 7080),
(83, 'Banque', 0, 2751.88, -1438.14, 30.4531, 262.264, 1456.19, -987.942, 996.105, 90, 6, 0, 0, 2, '', 0, 0, 7083),
(84, 'Stationnement', 0, 1524.56, -1677.86, 6.2186, 93.2238, 1571.47, -1667.98, 16.1898, 278.766, 0, 0, 0, 0, '', 0, 2, 0),
(86, 'Stationnement', 0, 1570.9, -1668, 16.1899, 269.366, 1524.48, -1677.81, 6.2187, 91.5085, 0, 0, 0, 0, '', 0, 2, 0),
(87, 'Sortie', 0, 1560.98, -1675.63, 16.1899, 85.2128, 1554.62, -1675.76, 16.1953, 87.1788, 0, 0, 0, 0, '', 0, 2, 0),
(90, 'Toit', 0, 1562.56, -1654.79, 16.1909, 274.513, 1557.59, -1675.55, 28.3954, 101.731, 0, 0, 0, 0, '', 0, 2, 0),
(91, 'Retour => Bureau', 0, 1557.55, -1675.51, 28.3954, 266.457, 1562.56, -1654.77, 16.1909, 153.996, 0, 0, 0, 0, '', 0, 2, 0),
(92, 'Bureau de la Fourriere', 0, 2232.6, -2218.11, 13.5468, 41.7055, 441.11, 132.703, 1008.4, 171.598, 0, 0, 0, 0, '', 0, 0, 7092),
(94, 'Event 1', 0, 2695.67, -1704.61, 11.8437, 211.046, 2744.15, -1741.82, 422.822, 129.705, 0, 0, 0, 0, '', 0, 2, 100),
(95, 'San News', 36, 756.778, -1374.83, 14.2329, 221.52, 304.122, 1894.16, 904.376, 182.331, 15, 0, 0, 0, '', 0, 0, 7095),
(96, 'Interieur San News', 0, 723.481, -1371.16, 24.047, 357.9, 324.565, 1891.08, 907.896, 91.1101, 15, 0, 0, 0, '', 0, 0, 7095),
(97, 'Toît San News', 0, 324.184, 1891.07, 907.896, 91.1101, 723.481, -1371.16, 24.047, 0, 0, 15, 7095, 0, '', 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `factions`
--

CREATE TABLE IF NOT EXISTS `factions` (
`factionID` int(12) NOT NULL,
  `factionName` varchar(32) DEFAULT NULL,
  `factionRanks` int(12) DEFAULT '0',
  `factionLockerX` float DEFAULT '0',
  `factionLockerY` float DEFAULT '0',
  `factionLockerZ` float DEFAULT '0',
  `factionLockerInt` int(12) DEFAULT '0',
  `factionLockerWorld` int(12) DEFAULT '0',
  `factioncoffre` int(12) DEFAULT '0',
  `factionWeapon1` int(12) DEFAULT '0',
  `factionAmmo1` int(12) DEFAULT '0',
  `factionWeapon2` int(12) DEFAULT '0',
  `factionAmmo2` int(12) DEFAULT '0',
  `factionWeapon3` int(12) DEFAULT '0',
  `factionAmmo3` int(12) DEFAULT '0',
  `factionWeapon4` int(12) DEFAULT '0',
  `factionAmmo4` int(12) DEFAULT '0',
  `factionWeapon5` int(12) DEFAULT '0',
  `factionAmmo5` int(12) DEFAULT '0',
  `factionWeapon6` int(12) DEFAULT '0',
  `factionAmmo6` int(12) DEFAULT '0',
  `factionWeapon7` int(12) DEFAULT '0',
  `factionAmmo7` int(12) DEFAULT '0',
  `factionWeapon8` int(12) DEFAULT '0',
  `factionAmmo8` int(12) DEFAULT '0',
  `factionWeapon9` int(12) DEFAULT '0',
  `factionAmmo9` int(12) DEFAULT '0',
  `factionWeapon10` int(12) DEFAULT '0',
  `factionAmmo10` int(12) DEFAULT '0',
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
  `factionSkin1` int(12) DEFAULT '0',
  `factionSkin2` int(12) DEFAULT '0',
  `factionSkin3` int(12) DEFAULT '0',
  `factionSkin4` int(12) DEFAULT '0',
  `factionSkin5` int(12) DEFAULT '0',
  `factionSkin6` int(12) DEFAULT '0',
  `factionSkin7` int(12) DEFAULT '0',
  `factionSkin8` int(12) DEFAULT '0',
  `factionacces1` int(4) NOT NULL DEFAULT '0',
  `factionacces2` int(4) NOT NULL DEFAULT '0',
  `factionacces3` int(4) NOT NULL DEFAULT '0',
  `factionacces4` int(4) NOT NULL DEFAULT '0',
  `factionacces5` int(4) NOT NULL DEFAULT '0',
  `factionacces6` int(4) NOT NULL DEFAULT '0',
  `factionacces7` int(4) NOT NULL DEFAULT '0',
  `factionacces8` int(4) NOT NULL DEFAULT '0',
  `factionacces9` int(4) NOT NULL DEFAULT '0',
  `factionacces10` int(4) NOT NULL DEFAULT '0',
  `factionacces11` int(4) NOT NULL DEFAULT '0',
  `factionacces12` int(4) NOT NULL DEFAULT '0',
  `factionacces13` int(4) NOT NULL DEFAULT '0',
  `factionacces14` int(4) NOT NULL DEFAULT '0',
  `factionacces15` int(4) NOT NULL DEFAULT '0',
  `SalaireRank1` int(4) NOT NULL DEFAULT '0',
  `SalaireRank2` int(4) NOT NULL DEFAULT '0',
  `SalaireRank3` int(4) NOT NULL DEFAULT '0',
  `SalaireRank4` int(4) NOT NULL DEFAULT '0',
  `SalaireRank5` int(4) NOT NULL DEFAULT '0',
  `SalaireRank6` int(4) NOT NULL DEFAULT '0',
  `SalaireRank7` int(4) NOT NULL DEFAULT '0',
  `SalaireRank8` int(4) NOT NULL DEFAULT '0',
  `SalaireRank9` int(4) NOT NULL DEFAULT '0',
  `SalaireRank10` int(4) NOT NULL DEFAULT '0',
  `SalaireRank11` int(4) NOT NULL DEFAULT '0',
  `SalaireRank12` int(4) NOT NULL DEFAULT '0',
  `SalaireRank13` int(4) NOT NULL DEFAULT '0',
  `SalaireRank14` int(4) NOT NULL DEFAULT '0',
  `SalaireRank15` int(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `factorystock`
--

CREATE TABLE IF NOT EXISTS `factorystock` (
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
  `sideskirt1` int(11) NOT NULL,
  `sideskirt2` int(11) NOT NULL,
  `wheel` int(11) NOT NULL,
  `hydrolic` int(11) NOT NULL,
  `roue` int(11) NOT NULL,
  `caro` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `factorystock`
--

INSERT INTO `factorystock` (`id`, `bois`, `viande`, `meuble`, `central1`, `central2`, `central3`, `central4`, `central5`, `electronic`, `petrol`, `essencegenerator`, `boismeuble`, `magasinstock`, `dockstock`, `manutentionnairestock`, `caristestock`, `minerstock`, `armesstock`, `frontbumper`, `rearbumper`, `roof`, `hood`, `spoiler`, `sideskirt1`, `sideskirt2`, `wheel`, `hydrolic`, `roue`, `caro`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `furniture`
--

CREATE TABLE IF NOT EXISTS `furniture` (
  `ID` int(12) DEFAULT '0',
`furnitureID` int(12) NOT NULL,
  `furnitureName` varchar(32) DEFAULT NULL,
  `furnitureModel` int(12) DEFAULT '0',
  `furnitureX` float DEFAULT '0',
  `furnitureY` float DEFAULT '0',
  `furnitureZ` float DEFAULT '0',
  `furnitureRX` float DEFAULT '0',
  `furnitureRY` float DEFAULT '0',
  `furnitureRZ` float DEFAULT '0',
  `furnitureType` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=latin1;

--
-- Structure de la table `furnitures`
--

CREATE TABLE IF NOT EXISTS `furnitures` (
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
-- Structure de la table `garbage`
--

CREATE TABLE IF NOT EXISTS `garbage` (
`garbageID` int(12) NOT NULL,
  `garbageModel` int(12) DEFAULT '1236',
  `garbageCapacity` int(12) DEFAULT '0',
  `garbageX` float DEFAULT '0',
  `garbageY` float DEFAULT '0',
  `garbageZ` float DEFAULT '0',
  `garbageA` float DEFAULT '0',
  `garbageInterior` int(12) DEFAULT '0',
  `garbageWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=253 DEFAULT CHARSET=latin1;

--
-- Structure de la table `gates`
--

CREATE TABLE IF NOT EXISTS `gates` (
`gateID` int(12) NOT NULL,
  `gateModel` int(12) DEFAULT '0',
  `gateSpeed` float DEFAULT '0',
  `gateTime` int(12) DEFAULT '0',
  `gateX` float DEFAULT '0',
  `gateY` float DEFAULT '0',
  `gateZ` float DEFAULT '0',
  `gateRX` float DEFAULT '0',
  `gateRY` float DEFAULT '0',
  `gateRZ` float DEFAULT '0',
  `gateInterior` int(12) DEFAULT '0',
  `gateWorld` int(12) DEFAULT '0',
  `gateMoveX` float DEFAULT '0',
  `gateMoveY` float DEFAULT '0',
  `gateMoveZ` float DEFAULT '0',
  `gateMoveRX` float DEFAULT '0',
  `gateMoveRY` float DEFAULT '0',
  `gateMoveRZ` float DEFAULT '0',
  `gateLinkID` int(12) DEFAULT '0',
  `gateFaction` int(12) DEFAULT '0',
  `gatePass` varchar(32) DEFAULT NULL,
  `gateRadius` float DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;

--
-- Structure de la table `gouvernement`
--

CREATE TABLE IF NOT EXISTS `gouvernement` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `gouvernement`
--

INSERT INTO `gouvernement` (`id`, `taxe`, `taxerevenue`, `taxeentreprise`, `chomage`, `subventionpolice`, `subventionfbi`, `subventionmedecin`, `subventionswat`, `aidebanque`, `bizhouse`, `maison`, `magasin`) VALUES
(1, 10, 15, 85, 800, 5000, 0, 0, 600, 450, 50, 45, 45);

-- --------------------------------------------------------

--
-- Structure de la table `gps`
--

CREATE TABLE IF NOT EXISTS `gps` (
  `ID` int(12) DEFAULT '0',
`locationID` int(12) NOT NULL,
  `locationName` varchar(32) DEFAULT NULL,
  `locationX` float DEFAULT '0',
  `locationY` float DEFAULT '0',
  `locationZ` float DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `graffiti`
--

CREATE TABLE IF NOT EXISTS `graffiti` (
`graffitiID` int(12) NOT NULL,
  `graffitiX` float DEFAULT '0',
  `graffitiY` float DEFAULT '0',
  `graffitiZ` float DEFAULT '0',
  `graffitiAngle` float DEFAULT '0',
  `graffitiColor` int(12) DEFAULT '0',
  `graffitiText` varchar(64) DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `gunracks`
--

CREATE TABLE IF NOT EXISTS `gunracks` (
`rackID` int(12) NOT NULL,
  `rackHouse` int(12) DEFAULT '0',
  `rackX` float DEFAULT '0',
  `rackY` float DEFAULT '0',
  `rackZ` float DEFAULT '0',
  `rackA` float DEFAULT '0',
  `rackInterior` int(12) DEFAULT '0',
  `rackWorld` int(12) DEFAULT '0',
  `rackWeapon1` int(12) DEFAULT '0',
  `rackAmmo1` int(12) DEFAULT '0',
  `rackWeapon2` int(12) DEFAULT '0',
  `rackAmmo2` int(12) DEFAULT '0',
  `rackWeapon3` int(12) DEFAULT '0',
  `rackAmmo3` int(12) DEFAULT '0',
  `rackWeapon4` int(12) DEFAULT '0',
  `rackAmmo4` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `houses`
--

CREATE TABLE IF NOT EXISTS `houses` (
`houseID` int(12) NOT NULL,
  `houseOwner` int(12) DEFAULT '0',
  `housePrice` int(12) DEFAULT '0',
  `houseAddress` varchar(32) DEFAULT NULL,
  `housePosX` float DEFAULT '0',
  `housePosY` float DEFAULT '0',
  `housePosZ` float DEFAULT '0',
  `housePosA` float DEFAULT '0',
  `houseIntX` float DEFAULT '0',
  `houseIntY` float DEFAULT '0',
  `houseIntZ` float DEFAULT '0',
  `houseIntA` float DEFAULT '0',
  `houseInterior` int(12) DEFAULT '0',
  `houseInteriorVW` int(4) NOT NULL DEFAULT '0',
  `houseExterior` int(12) DEFAULT '0',
  `houseExteriorVW` int(12) DEFAULT '0',
  `houseLocked` int(4) DEFAULT '0',
  `houseWeapon1` int(12) DEFAULT '0',
  `houseAmmo1` int(12) DEFAULT '0',
  `houseWeapon2` int(12) DEFAULT '0',
  `houseAmmo2` int(12) DEFAULT '0',
  `houseWeapon3` int(12) DEFAULT '0',
  `houseAmmo3` int(12) DEFAULT '0',
  `houseWeapon4` int(12) DEFAULT '0',
  `houseAmmo4` int(12) DEFAULT '0',
  `houseWeapon5` int(12) DEFAULT '0',
  `houseAmmo5` int(12) DEFAULT '0',
  `houseWeapon6` int(12) DEFAULT '0',
  `houseAmmo6` int(12) DEFAULT '0',
  `houseWeapon7` int(12) DEFAULT '0',
  `houseAmmo7` int(12) DEFAULT '0',
  `houseWeapon8` int(12) DEFAULT '0',
  `houseAmmo8` int(12) DEFAULT '0',
  `houseWeapon9` int(12) DEFAULT '0',
  `houseAmmo9` int(12) DEFAULT '0',
  `houseWeapon10` int(12) DEFAULT '0',
  `houseAmmo10` int(12) DEFAULT '0',
  `houseMoney` int(12) DEFAULT '0',
  `houseLocation` int(4) NOT NULL DEFAULT '0',
  `houseMaxLoc` int(4) NOT NULL DEFAULT '0',
  `houseLocNum` int(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=804 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `housestorage`
--

CREATE TABLE IF NOT EXISTS `housestorage` (
  `ID` int(12) DEFAULT '0',
`itemID` int(12) NOT NULL,
  `itemName` varchar(32) DEFAULT NULL,
  `itemModel` int(12) DEFAULT '0',
  `itemQuantity` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `impoundlots`
--

CREATE TABLE IF NOT EXISTS `impoundlots` (
`impoundID` int(12) NOT NULL,
  `impoundLotX` float DEFAULT '0',
  `impoundLotY` float DEFAULT '0',
  `impoundLotZ` float DEFAULT '0',
  `impoundReleaseX` float DEFAULT '0',
  `impoundReleaseY` float DEFAULT '0',
  `impoundReleaseZ` float DEFAULT '0',
  `impoundReleaseInt` int(12) DEFAULT '0',
  `impoundReleaseWorld` int(12) DEFAULT '0',
  `impoundReleaseA` float DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `impoundlots`
--

INSERT INTO `impoundlots` (`impoundID`, `impoundLotX`, `impoundLotY`, `impoundLotZ`, `impoundReleaseX`, `impoundReleaseY`, `impoundReleaseZ`, `impoundReleaseInt`, `impoundReleaseWorld`, `impoundReleaseA`) VALUES
(1, 2236.73, -2247.28, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(2, 2229.74, -2254.99, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(3, 2222.54, -2262.47, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(4, 2214.72, -2269.56, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(5, 2207.59, -2277.14, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(6, 2188.57, -2228.6, 13.5015, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(7, 2191.96, -2225.35, 13.5387, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(8, 2195.91, -2220.55, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(9, 2198.7, -2217.68, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(10, 2203.15, -2213.61, 13.5546, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(11, 2206.45, -2210.27, 13.5468, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(12, 2200.14, -2281.21, 13.5468, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(13, 2197.69, -2284.74, 13.5468, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(14, 2194.79, -2288.32, 13.5468, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(15, 2192.31, -2291.27, 13.5468, 2235.25, -2210.07, 13.5468, 0, 0, 227.569),
(16, 2189.84, -2293.79, 13.5468, 2235.25, -2210.07, 13.5468, 0, 0, 227.569);

-- --------------------------------------------------------

--
-- Structure de la table `inventory`
--

CREATE TABLE IF NOT EXISTS `inventory` (
  `ID` int(12) DEFAULT '0',
`invID` int(12) NOT NULL,
  `invItem` varchar(32) DEFAULT NULL,
  `invModel` int(12) DEFAULT '0',
  `invQuantity` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2136 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE IF NOT EXISTS `jobs` (
`jobID` int(12) NOT NULL,
  `jobPosX` float DEFAULT '0',
  `jobPosY` float DEFAULT '0',
  `jobPosZ` float DEFAULT '0',
  `jobPointX` float DEFAULT '0',
  `jobPointY` float DEFAULT '0',
  `jobPointZ` float DEFAULT '0',
  `jobDeliverX` float DEFAULT '0',
  `jobDeliverY` float DEFAULT '0',
  `jobDeliverZ` float DEFAULT '0',
  `jobInterior` int(12) DEFAULT '0',
  `jobWorld` int(12) DEFAULT '0',
  `jobType` int(12) DEFAULT '0',
  `jobPointInt` int(12) DEFAULT '0',
  `jobPointWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `namechanges`
--

CREATE TABLE IF NOT EXISTS `namechanges` (
`ID` int(12) NOT NULL,
  `OldName` varchar(24) DEFAULT NULL,
  `NewName` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `news`
--

CREATE TABLE IF NOT EXISTS `news` (
`news_id` int(4) NOT NULL,
  `news_name` text NOT NULL,
  `news_desc` text NOT NULL,
  `news_postedby` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `plants`
--

CREATE TABLE IF NOT EXISTS `plants` (
`plantID` int(12) NOT NULL,
  `plantType` int(12) DEFAULT '0',
  `plantDrugs` int(12) DEFAULT '0',
  `plantX` float DEFAULT '0',
  `plantY` float DEFAULT '0',
  `plantZ` float DEFAULT '0',
  `plantA` float DEFAULT '0',
  `plantInterior` int(12) DEFAULT '0',
  `plantWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `pumps`
--

CREATE TABLE IF NOT EXISTS `pumps` (
  `ID` int(12) DEFAULT '0',
`pumpID` int(12) NOT NULL,
  `pumpPosX` float DEFAULT '0',
  `pumpPosY` float DEFAULT '0',
  `pumpPosZ` float DEFAULT '0',
  `pumpPosA` float DEFAULT '0',
  `pumpFuel` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `salairefbi`
--

CREATE TABLE IF NOT EXISTS `salairefbi` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salairefbi`
--

INSERT INTO `salairefbi` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salairejob`
--

CREATE TABLE IF NOT EXISTS `salairejob` (
  `id` int(12) DEFAULT '50',
  `salairecariste` int(12) DEFAULT '50',
  `salairemanutentionnaire` int(12) DEFAULT '50',
  `salairedock` int(12) DEFAULT '50',
  `salairelaitier` int(12) DEFAULT '50',
  `salaireminer` int(12) DEFAULT '50',
  `salaireusineelectronic` int(12) DEFAULT '50',
  `salairebucheron` int(12) DEFAULT '50',
  `salairemenuisier` int(12) DEFAULT '50',
  `salairegenerateur` int(12) DEFAULT '50',
  `salaireelectricien` int(12) DEFAULT '50',
  `salairearme` int(12) DEFAULT '50',
  `salairepetrolier` int(12) DEFAULT '50',
  `salaireboucher` int(12) DEFAULT '50'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salairejob`
--

INSERT INTO `salairejob` (`id`, `salairecariste`, `salairemanutentionnaire`, `salairedock`, `salairelaitier`, `salaireminer`, `salaireusineelectronic`, `salairebucheron`, `salairemenuisier`, `salairegenerateur`, `salaireelectricien`, `salairearme`, `salairepetrolier`, `salaireboucher`) VALUES
(1, 50, 60, 50, 18, 50, 50, 75, 50, 100, 75, 50, 75, 50);

-- --------------------------------------------------------


--
-- Structure de la table `salairemairie`
--

CREATE TABLE IF NOT EXISTS `salairemairie` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salairemairie`
--

INSERT INTO `salairemairie` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 800, 850, 900, 950, 1050, 1100, 1150, 1200, 2500, 2500, 1350, 2400, 2500, 1200, 2500);

-- --------------------------------------------------------

--
-- Structure de la table `salairemecano3`
--

CREATE TABLE IF NOT EXISTS `salairemecano3` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salairemecano3`
--

INSERT INTO `salairemecano3` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1, 550, 700, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salairemecano4`
--

CREATE TABLE IF NOT EXISTS `salairemecano4` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salairemecano4`
--

INSERT INTO `salairemecano4` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 1000, 1, 0, 0, 0, 0, 0, 2000, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salairepolice`
--

CREATE TABLE IF NOT EXISTS `salairepolice` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salairepolice`
--

INSERT INTO `salairepolice` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1000, 1250, 1500, 1750, 2000, 2125, 2250, 2500, 2500, 2500, 2500, 2250, 2250, 2500, 2500);

-- --------------------------------------------------------

--
-- Structure de la table `salaireswat`
--

CREATE TABLE IF NOT EXISTS `salaireswat` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salaireswat`
--

INSERT INTO `salaireswat` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `salaireurgentiste`
--

CREATE TABLE IF NOT EXISTS `salaireurgentiste` (
`idfaction` int(11) NOT NULL,
  `salairerang1` int(11) DEFAULT '0',
  `salairerang2` int(11) DEFAULT '0',
  `salairerang3` int(11) DEFAULT '0',
  `salairerang4` int(11) DEFAULT '0',
  `salairerang5` int(11) DEFAULT '0',
  `salairerang6` int(11) DEFAULT '0',
  `salairerang7` int(11) DEFAULT '0',
  `salairerang8` int(11) DEFAULT '0',
  `salairerang9` int(11) DEFAULT '0',
  `salairerang10` int(11) DEFAULT '0',
  `salairerang11` int(11) DEFAULT '0',
  `salairerang12` int(11) DEFAULT '0',
  `salairerang13` int(11) DEFAULT '0',
  `salairerang14` int(11) DEFAULT '0',
  `salairerang15` int(11) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `salaireurgentiste`
--

INSERT INTO `salaireurgentiste` (`idfaction`, `salairerang1`, `salairerang2`, `salairerang3`, `salairerang4`, `salairerang5`, `salairerang6`, `salairerang7`, `salairerang8`, `salairerang9`, `salairerang10`, `salairerang11`, `salairerang12`, `salairerang13`, `salairerang14`, `salairerang15`) VALUES
(1, 1100, 1100, 1200, 1200, 1300, 1300, 1450, 1450, 1600, 1600, 1750, 1750, 1900, 1900, 2000);


-- --------------------------------------------------------

--
-- Structure de la table `serveursetting`
--

CREATE TABLE IF NOT EXISTS `serveursetting` (
  `id` int(11) NOT NULL,
  `motd` varchar(128) NOT NULL DEFAULT '00',
  `afkactive` int(11) DEFAULT '1',
  `afktime` int(11) DEFAULT '0',
  `braquagenpcactive` int(11) DEFAULT '0',
  `braquagebanqueactive` int(11) DEFAULT '0',
  `oocactive` int(11) DEFAULT '0',
  `pmactive` int(11) DEFAULT '0',
  `villeactive` int(4) NOT NULL DEFAULT '1',
  `nouveau` int(11) NOT NULL,
  `police` int(4) NOT NULL DEFAULT '0',
  `swat` int(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `serveursetting`
--

INSERT INTO `serveursetting` (`id`, `motd`, `afkactive`, `afktime`, `braquagenpcactive`, `braquagebanqueactive`, `oocactive`, `pmactive`, `villeactive`, `nouveau`, `police`, `swat`) VALUES
(1, 'Notre discord : https://discord.gg/YCrBKxr', 0, 15, 1, 1, 1, 0, 5, 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `slotmachine`
--

CREATE TABLE IF NOT EXISTS `slotmachine` (
`id` int(4) NOT NULL,
  `X` float DEFAULT '0',
  `Y` float DEFAULT '0',
  `Z` float DEFAULT '0',
  `RX` float DEFAULT '0',
  `RY` float DEFAULT '0',
  `RZ` float DEFAULT '0',
  `slotint` float DEFAULT '0',
  `slotvw` float DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `slotmachine`
--

INSERT INTO `slotmachine` (`id`, `X`, `Y`, `Z`, `RX`, `RY`, `RZ`, `slotint`, `slotvw`) VALUES
(1, -236.548, -11.1281, 1004.75, 0, 0, 0, 3, 7034),
(2, -241.584, -11.1802, 1004.73, 0, 0, 0, 3, 7034),
(3, 2790.09, -1950.58, 12.8148, 0, 0, 178.619, 0, 0),
(4, -496.879, 311.501, 2004.59, 0, 0, 0, 1, 7005),
(5, -494.986, 310.011, 2004.59, 0, 0, 178.619, 1, 7005),
(6, 1119.75, -2037.39, 69.8942, 0, 0, 0, 0, 0),
(7, 1120.42, -2037.38, 69.8873, 0, 0, 178.619, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `speedcameras`
--

CREATE TABLE IF NOT EXISTS `speedcameras` (
`speedID` int(12) NOT NULL,
  `speedRange` float DEFAULT '0',
  `speedLimit` float DEFAULT '0',
  `speedX` float DEFAULT '0',
  `speedY` float DEFAULT '0',
  `speedZ` float DEFAULT '0',
  `speedAngle` float DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `speedcameras`
--

INSERT INTO `speedcameras` (`speedID`, `speedRange`, `speedLimit`, `speedX`, `speedY`, `speedZ`, `speedAngle`) VALUES
(242, 30, 121, 1286.11, -1609.02, 12.3468, 91.2798),
(243, 30, 121, 1330.55, -1530.17, 12.3468, 249.809),
(244, 30, 81, 1443.59, -1451.11, 12.3504, 88.2413),
(246, 30, 81, 1862.58, -1293.38, 12.3468, 269.283),
(250, 30, 81, 1640.29, -1721.41, 12.3468, 359.756),
(252, 30, 121, 1368.05, -1250.81, 12.3468, 178.854),
(253, 30, 81, 1527.41, -1173.49, 22.8781, 180.367),
(257, 30, 81, 2071.95, -1840.45, 12.3468, 89.5216),
(258, 30, 81, 2030.1, -1921.93, 12.3468, 359.402),
(262, 30, 81, 2011.43, -1763.46, 12.339, 179.434),
(263, 30, 81, 2231.33, -1687, 12.9507, 266.277),
(266, 30, 81, 2463.72, -1745.18, 12.3468, 176.331),
(269, 30, 81, 2129.03, -1762.97, 12.3625, 180.681),
(270, 30, 81, 1345.31, -1721.77, 12.3682, 357.613),
(271, 30, 81, 1379, -1774.78, 12.3468, 90.7976),
(274, 30, 81, 1540.3, -1882.95, 12.3468, 179.184),
(275, 30, 121, 1367.82, -1164.06, 22.8656, 269.303),
(276, 30, 121, 1331.54, -1291.24, 12.3468, 90.8161),
(278, 30, 81, 2160.31, -1905.21, 12.3424, 178.414),
(279, 30, 81, 2251.16, -1721.9, 12.3468, 358.872),
(281, 30, 81, 1950.62, -2008.56, 12.3468, 86.3519),
(282, 30, 81, 2354.67, -1469.35, 22.7999, 268.352),
(283, 30, 81, 1810.58, -1806.87, 12.3606, 88.8594),
(284, 30, 81, 1704.3, -1581.37, 12.347, 3.3527),
(286, 30, 81, 2092.8, -1942.01, 12.3441, 266.555),
(287, 30, 81, 1048.67, -1561.77, 12.3447, 267.404),
(288, 30, 81, 896.372, -1337.37, 12.3468, 176.103),
(289, 30, 81, 953.539, -1269.49, 14.3185, 269.676),
(290, 30, 81, 1009.94, -1028.69, 30.8111, 0.8602),
(292, 30, 81, 1465.13, -1312.02, 12.3585, 180.666),
(294, 30, 81, 1711.92, -1451.25, 12.3468, 179.209),
(337, 50, 81, -128.247, -1318.04, 1.3775, 339.52),
(341, 50, 121, 601.446, -1733.45, 12.4057, 258.438),
(342, 50, 81, 1223.06, -1862.28, 12.3468, 93.3102),
(349, 30, 81, 1802.77, -1170.32, 22.6281, 244.024),
(350, 30, 81, -83.9878, -418.446, 0.1412, 238.392);

-- --------------------------------------------------------

--
-- Structure de la table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `ID` int(12) DEFAULT '0',
`ticketID` int(12) NOT NULL,
  `ticketFee` int(12) DEFAULT '0',
  `ticketBy` varchar(24) DEFAULT NULL,
  `ticketDate` varchar(36) DEFAULT NULL,
  `ticketReason` varchar(32) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=latin1;


--
-- Structure de la table `tuning`
--

CREATE TABLE IF NOT EXISTS `tuning` (
`id` int(12) NOT NULL,
  `vehicule` int(11) NOT NULL,
  `FrontBumperID` int(11) NOT NULL,
  `FrontBumperX` float NOT NULL,
  `FrontBumperY` float NOT NULL,
  `FrontBumperZ` float NOT NULL,
  `FrontBumperRX` float NOT NULL,
  `FrontBumperRY` float NOT NULL,
  `FrontBumperRZ` float NOT NULL,
  `RearBumperID` int(11) NOT NULL,
  `RearBumperX` float NOT NULL,
  `RearBumperY` float NOT NULL,
  `RearBumperZ` float NOT NULL,
  `RearBumperRX` float NOT NULL,
  `RearBumperRY` float NOT NULL,
  `RearBumperRZ` float NOT NULL,
  `RoofID` int(11) NOT NULL,
  `RoofX` float NOT NULL,
  `RoofY` float NOT NULL,
  `RoofZ` float NOT NULL,
  `RoofRX` float NOT NULL,
  `RoofRY` float NOT NULL,
  `RoofRZ` float NOT NULL,
  `HoodID` int(11) NOT NULL,
  `HoodX` float NOT NULL,
  `HoodY` float NOT NULL,
  `HoodZ` float NOT NULL,
  `HoodRX` float NOT NULL,
  `HoodRY` float NOT NULL,
  `HoodRZ` float NOT NULL,
  `SpoilerID` int(11) NOT NULL,
  `SpoilerX` float NOT NULL,
  `SpoilerY` float NOT NULL,
  `SpoilerZ` float NOT NULL,
  `SpoilerRX` float NOT NULL,
  `SpoilerRY` float NOT NULL,
  `SpoilerRZ` float NOT NULL,
  `WheelID` int(11) NOT NULL,
  `WheelX` float NOT NULL,
  `WheelY` float NOT NULL,
  `WheelZ` float NOT NULL,
  `WheelRX` float NOT NULL,
  `WheelRY` float NOT NULL,
  `WheelRZ` float NOT NULL,
  `SideSkirt1ID` int(11) NOT NULL,
  `SideSkirt1X` float NOT NULL,
  `SideSkirt1Y` float NOT NULL,
  `SideSkirt1Z` float NOT NULL,
  `SideSkirt1RX` float NOT NULL,
  `SideSkirt1RY` float NOT NULL,
  `SideSkirt1RZ` float NOT NULL,
  `SideSkirt2ID` int(11) NOT NULL,
  `SideSkirt2X` float NOT NULL,
  `SideSkirt2Y` float NOT NULL,
  `SideSkirt2Z` float NOT NULL,
  `SideSkirt2RX` float NOT NULL,
  `SideSkirt2RY` float NOT NULL,
  `SideSkirt2RZ` float NOT NULL,
  `EditingPart` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `vendors`
--

CREATE TABLE IF NOT EXISTS `vendors` (
`vendorID` int(12) NOT NULL,
  `vendorType` int(12) DEFAULT '0',
  `vendorX` float DEFAULT '0',
  `vendorY` float DEFAULT '0',
  `vendorZ` float DEFAULT '0',
  `vendorA` float DEFAULT '0',
  `vendorInterior` int(12) DEFAULT '0',
  `vendorWorld` int(12) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=latin1;



-- --------------------------------------------------------

--
-- Structure de la table `votes`
--

CREATE TABLE IF NOT EXISTS `votes` (
  `Name` varchar(24) NOT NULL,
  `Votes` int(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `warrants`
--

CREATE TABLE IF NOT EXISTS `warrants` (
`ID` int(12) NOT NULL,
  `Suspect` varchar(24) DEFAULT NULL,
  `Username` varchar(24) DEFAULT NULL,
  `Date` varchar(36) DEFAULT NULL,
  `Description` varchar(128) DEFAULT NULL,
  `IDchar` int(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--------------------------------------------------------

--
-- Structure de la table `zones`
--

CREATE TABLE IF NOT EXISTS `zones` (
  `zID` int(12) NOT NULL,
  `zName` int(12) DEFAULT '0',
  `zMinX` float DEFAULT '0',
  `zMinY` float DEFAULT '0',
  `zMaxX` float DEFAULT '0',
  `zMaxY` float DEFAULT '0',
  `zCPX` float DEFAULT '0',
  `zCPY` float DEFAULT '0',
  `zCPZ` float DEFAULT '0',
  `zTeam` int(12) DEFAULT '0',
  `zMoney` int(12) DEFAULT '0',
  `zEXP` int(12) DEFAULT '0',
  `zTime` int(12) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `accounts`
--
ALTER TABLE `accounts`
 ADD PRIMARY KEY (`ID`);

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
-- Index pour la table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `batiements`
--
ALTER TABLE `batiements`
 ADD PRIMARY KEY (`batiementID`), ADD UNIQUE KEY `batiementID` (`batiementID`);

--
-- Index pour la table `billboards`
--
ALTER TABLE `billboards`
 ADD PRIMARY KEY (`bbID`);

--
-- Index pour la table `blacklist`
--
ALTER TABLE `blacklist`
 ADD PRIMARY KEY (`Username`), ADD UNIQUE KEY `Username` (`Username`);

--
-- Index pour la table `businesses`
--
ALTER TABLE `businesses`
 ADD PRIMARY KEY (`bizID`);

--
-- Index pour la table `caisses`
--
ALTER TABLE `caisses`
 ADD PRIMARY KEY (`caisseID`), ADD KEY `caisseID` (`caisseID`);

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
-- Index pour la table `cvfbi`
--
ALTER TABLE `cvfbi`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvjournaliste`
--
ALTER TABLE `cvjournaliste`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvlivraisonbiz`
--
ALTER TABLE `cvlivraisonbiz`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvmairie`
--
ALTER TABLE `cvmairie`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvmecanozone3`
--
ALTER TABLE `cvmecanozone3`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvmecanozone4`
--
ALTER TABLE `cvmecanozone4`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvpetitlivreur`
--
ALTER TABLE `cvpetitlivreur`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvpolice`
--
ALTER TABLE `cvpolice`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvswat`
--
ALTER TABLE `cvswat`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvtaxi`
--
ALTER TABLE `cvtaxi`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvurgentiste`
--
ALTER TABLE `cvurgentiste`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `cvvendeurrue`
--
ALTER TABLE `cvvendeurrue`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `dealervehicles`
--
ALTER TABLE `dealervehicles`
 ADD PRIMARY KEY (`vehID`);

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
-- Index pour la table `salairemecano3`
--
ALTER TABLE `salairemecano3`
 ADD PRIMARY KEY (`idfaction`);

--
-- Index pour la table `salairemecano4`
--
ALTER TABLE `salairemecano4`
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
-- Index pour la table `salairetaxi`
--
ALTER TABLE `salairetaxi`
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
 ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

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
-- Index pour la table `tuning`
--
ALTER TABLE `tuning`
 ADD PRIMARY KEY (`id`), ADD KEY `id` (`id`);

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
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `accounts`
--
ALTER TABLE `accounts`
MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=251;
--
-- AUTO_INCREMENT pour la table `atm`
--
ALTER TABLE `atm`
MODIFY `atmID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=209;
--
-- AUTO_INCREMENT pour la table `backpackitems`
--
ALTER TABLE `backpackitems`
MODIFY `itemID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT pour la table `backpacks`
--
ALTER TABLE `backpacks`
MODIFY `backpackID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=42;
--
-- AUTO_INCREMENT pour la table `banqueentreprise`
--
ALTER TABLE `banqueentreprise`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `batiements`
--
ALTER TABLE `batiements`
MODIFY `batiementID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=73;
--
-- AUTO_INCREMENT pour la table `billboards`
--
ALTER TABLE `billboards`
MODIFY `bbID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=47;
--
-- AUTO_INCREMENT pour la table `businesses`
--
ALTER TABLE `businesses`
MODIFY `bizID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=74;
--
-- AUTO_INCREMENT pour la table `caisses`
--
ALTER TABLE `caisses`
MODIFY `caisseID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT pour la table `cars`
--
ALTER TABLE `cars`
MODIFY `carID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=218;
--
-- AUTO_INCREMENT pour la table `carstorage`
--
ALTER TABLE `carstorage`
MODIFY `itemID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=174;
--
-- AUTO_INCREMENT pour la table `characters`
--
ALTER TABLE `characters`
MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=299;
--
-- AUTO_INCREMENT pour la table `contacts`
--
ALTER TABLE `contacts`
MODIFY `contactID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=55;
--
-- AUTO_INCREMENT pour la table `crates`
--
ALTER TABLE `crates`
MODIFY `crateID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `cvfbi`
--
ALTER TABLE `cvfbi`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `cvjournaliste`
--
ALTER TABLE `cvjournaliste`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `cvlivraisonbiz`
--
ALTER TABLE `cvlivraisonbiz`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `cvmairie`
--
ALTER TABLE `cvmairie`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `cvmecanozone3`
--
ALTER TABLE `cvmecanozone3`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `cvmecanozone4`
--
ALTER TABLE `cvmecanozone4`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `cvpetitlivreur`
--
ALTER TABLE `cvpetitlivreur`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `cvpolice`
--
ALTER TABLE `cvpolice`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `cvswat`
--
ALTER TABLE `cvswat`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `cvtaxi`
--
ALTER TABLE `cvtaxi`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT pour la table `cvurgentiste`
--
ALTER TABLE `cvurgentiste`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `cvvendeurrue`
--
ALTER TABLE `cvvendeurrue`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `dealervehicles`
--
ALTER TABLE `dealervehicles`
MODIFY `vehID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=89;
--
-- AUTO_INCREMENT pour la table `detectors`
--
ALTER TABLE `detectors`
MODIFY `detectorID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `dropped`
--
ALTER TABLE `dropped`
MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=520;
--
-- AUTO_INCREMENT pour la table `entrances`
--
ALTER TABLE `entrances`
MODIFY `entranceID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=98;
--
-- AUTO_INCREMENT pour la table `factions`
--
ALTER TABLE `factions`
MODIFY `factionID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT pour la table `factorystock`
--
ALTER TABLE `factorystock`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `furniture`
--
ALTER TABLE `furniture`
MODIFY `furnitureID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=126;
--
-- AUTO_INCREMENT pour la table `garbage`
--
ALTER TABLE `garbage`
MODIFY `garbageID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=253;
--
-- AUTO_INCREMENT pour la table `gates`
--
ALTER TABLE `gates`
MODIFY `gateID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT pour la table `gouvernement`
--
ALTER TABLE `gouvernement`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `gps`
--
ALTER TABLE `gps`
MODIFY `locationID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT pour la table `graffiti`
--
ALTER TABLE `graffiti`
MODIFY `graffitiID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT pour la table `gunracks`
--
ALTER TABLE `gunracks`
MODIFY `rackID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT pour la table `houses`
--
ALTER TABLE `houses`
MODIFY `houseID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=804;
--
-- AUTO_INCREMENT pour la table `housestorage`
--
ALTER TABLE `housestorage`
MODIFY `itemID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=59;
--
-- AUTO_INCREMENT pour la table `impoundlots`
--
ALTER TABLE `impoundlots`
MODIFY `impoundID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT pour la table `inventory`
--
ALTER TABLE `inventory`
MODIFY `invID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2136;
--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
MODIFY `jobID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT pour la table `namechanges`
--
ALTER TABLE `namechanges`
MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=41;
--
-- AUTO_INCREMENT pour la table `news`
--
ALTER TABLE `news`
MODIFY `news_id` int(4) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT pour la table `plants`
--
ALTER TABLE `plants`
MODIFY `plantID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=60;
--
-- AUTO_INCREMENT pour la table `pumps`
--
ALTER TABLE `pumps`
MODIFY `pumpID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT pour la table `salairefbi`
--
ALTER TABLE `salairefbi`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairejournaliste`
--
ALTER TABLE `salairejournaliste`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairelivreurbiz`
--
ALTER TABLE `salairelivreurbiz`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairemairie`
--
ALTER TABLE `salairemairie`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairemecano3`
--
ALTER TABLE `salairemecano3`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairemecano4`
--
ALTER TABLE `salairemecano4`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairepolice`
--
ALTER TABLE `salairepolice`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salaireswat`
--
ALTER TABLE `salaireswat`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairetaxi`
--
ALTER TABLE `salairetaxi`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salaireurgentiste`
--
ALTER TABLE `salaireurgentiste`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `salairevendeurrue`
--
ALTER TABLE `salairevendeurrue`
MODIFY `idfaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `slotmachine`
--
ALTER TABLE `slotmachine`
MODIFY `id` int(4) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT pour la table `speedcameras`
--
ALTER TABLE `speedcameras`
MODIFY `speedID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=351;
--
-- AUTO_INCREMENT pour la table `tickets`
--
ALTER TABLE `tickets`
MODIFY `ticketID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=426;
--
-- AUTO_INCREMENT pour la table `tuning`
--
ALTER TABLE `tuning`
MODIFY `id` int(12) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `vendors`
--
ALTER TABLE `vendors`
MODIFY `vendorID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=224;
--
-- AUTO_INCREMENT pour la table `warrants`
--
ALTER TABLE `warrants`
MODIFY `ID` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
