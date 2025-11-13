-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 13, 2025 at 10:59 AM
-- Server version: 8.0.43-0ubuntu0.22.04.2
-- PHP Version: 8.1.2-1ubuntu2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gestion_don_sang`
--

-- --------------------------------------------------------

--
-- Table structure for table `besoins`
--

CREATE TABLE `besoins` (
  `id_besoin` int NOT NULL,
  `groupe_sanguin` enum('A','B','AB','O') NOT NULL,
  `niveau_alerte` enum('NORMAL','URGENT','CRITIQUE') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `centres_collecte`
--

CREATE TABLE `centres_collecte` (
  `id_centre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `donneurs`
--

CREATE TABLE `donneurs` (
  `id_donneur` int NOT NULL,
  `cin` int NOT NULL,
  `groupe_sanguin` enum('A','B','AB','O') NOT NULL,
  `rhesus` enum('+','-') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dons`
--

CREATE TABLE `dons` (
  `id_don` int NOT NULL,
  `statut` enum('EN STOCK','UTILISÉ','REJETÉ') NOT NULL DEFAULT 'EN STOCK',
  `id_donneur` int NOT NULL,
  `id_centre` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tests_don`
--

CREATE TABLE `tests_don` (
  `id_test` int NOT NULL,
  `id_don` int NOT NULL,
  `est_conforme` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transfusions`
--

CREATE TABLE `transfusions` (
  `id_transfusion` int NOT NULL,
  `id_don` int NOT NULL,
  `hopital_recepteur` varchar(255) DEFAULT NULL,
  `date_transfusion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `utilisateurs`
--

CREATE TABLE `utilisateurs` (
  `id_utilisateur` int NOT NULL,
  `id_centre` int NOT NULL,
  `role` enum('Admin','Médecin','Secrétaire') NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `besoins`
--
ALTER TABLE `besoins`
  ADD PRIMARY KEY (`id_besoin`);

--
-- Indexes for table `centres_collecte`
--
ALTER TABLE `centres_collecte`
  ADD PRIMARY KEY (`id_centre`);

--
-- Indexes for table `donneurs`
--
ALTER TABLE `donneurs`
  ADD PRIMARY KEY (`id_donneur`),
  ADD UNIQUE KEY `cin` (`cin`);

--
-- Indexes for table `dons`
--
ALTER TABLE `dons`
  ADD PRIMARY KEY (`id_don`),
  ADD KEY `fk_donneur_dons` (`id_donneur`),
  ADD KEY `fk_centre_dons` (`id_centre`);

--
-- Indexes for table `tests_don`
--
ALTER TABLE `tests_don`
  ADD PRIMARY KEY (`id_test`),
  ADD UNIQUE KEY `id_don` (`id_don`);

--
-- Indexes for table `transfusions`
--
ALTER TABLE `transfusions`
  ADD PRIMARY KEY (`id_transfusion`),
  ADD UNIQUE KEY `id_don` (`id_don`),
  ADD UNIQUE KEY `id_don_2` (`id_don`),
  ADD UNIQUE KEY `id_transfusion` (`id_transfusion`);

--
-- Indexes for table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD PRIMARY KEY (`id_utilisateur`),
  ADD KEY `id_centre` (`id_centre`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `besoins`
--
ALTER TABLE `besoins`
  MODIFY `id_besoin` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `centres_collecte`
--
ALTER TABLE `centres_collecte`
  MODIFY `id_centre` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `donneurs`
--
ALTER TABLE `donneurs`
  MODIFY `id_donneur` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dons`
--
ALTER TABLE `dons`
  MODIFY `id_don` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tests_don`
--
ALTER TABLE `tests_don`
  MODIFY `id_test` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transfusions`
--
ALTER TABLE `transfusions`
  MODIFY `id_transfusion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  MODIFY `id_utilisateur` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `dons`
--
ALTER TABLE `dons`
  ADD CONSTRAINT `fk_centre_dons` FOREIGN KEY (`id_centre`) REFERENCES `centres_collecte` (`id_centre`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donneur_dons` FOREIGN KEY (`id_donneur`) REFERENCES `donneurs` (`id_donneur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tests_don`
--
ALTER TABLE `tests_don`
  ADD CONSTRAINT `tests_don_ibfk_1` FOREIGN KEY (`id_don`) REFERENCES `dons` (`id_don`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transfusions`
--
ALTER TABLE `transfusions`
  ADD CONSTRAINT `transfusions_ibfk_1` FOREIGN KEY (`id_don`) REFERENCES `dons` (`id_don`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `utilisateurs`
--
ALTER TABLE `utilisateurs`
  ADD CONSTRAINT `id_centre` FOREIGN KEY (`id_centre`) REFERENCES `centres_collecte` (`id_centre`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
