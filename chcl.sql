-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Ven 26 Novembre 2021 à 20:54
-- Version du serveur :  5.7.14
-- Version de PHP :  5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `chcl`
--

-- --------------------------------------------------------

--
-- Structure de la table `annee_academique`
--

CREATE TABLE `annee_academique` (
  `id` int(11) NOT NULL,
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `academicY` varchar(9) NOT NULL,
  `annee_debut` int(4) NOT NULL,
  `annee_fin` int(4) NOT NULL,
  `etat` varchar(30) NOT NULL DEFAULT 'F'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `annee_academique`
--

INSERT INTO `annee_academique` (`id`, `date_debut`, `date_fin`, `academicY`, `annee_debut`, `annee_fin`, `etat`) VALUES
(1, '2021-10-04', '2022-09-08', '2021-2022', 2021, 2022, 'F'),
(2, '2020-09-07', '2021-09-06', '2020-2021', 2020, 2021, 'F'),
(3, '2022-09-05', '2023-11-06', '2022-2023', 2022, 2023, 'O');

-- --------------------------------------------------------

--
-- Structure de la table `bultin`
--

CREATE TABLE `bultin` (
  `idBultin` int(14) NOT NULL,
  `id_note` int(11) NOT NULL,
  `codeCours` int(11) NOT NULL,
  `codeEtudiant` int(11) NOT NULL,
  `session` varchar(14) NOT NULL,
  `noteSur100` int(11) NOT NULL,
  `noteParCoefficient` double NOT NULL,
  `annee-academique` varchar(9) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Contenu de la table `bultin`
--

INSERT INTO `bultin` (`idBultin`, `id_note`, `codeCours`, `codeEtudiant`, `session`, `noteSur100`, `noteParCoefficient`, `annee-academique`) VALUES
(1, 1, 1, 123456789, '1', 0, 0, '2020-2021'),
(2, 2, 1, 123456790, '1', 0, 0, '2020-2021');

-- --------------------------------------------------------

--
-- Structure de la table `cours`
--

CREATE TABLE `cours` (
  `codeCours` int(14) NOT NULL,
  `nomCours` varchar(40) NOT NULL,
  `niveau` varchar(40) NOT NULL DEFAULT 'EUF',
  `session` varchar(14) NOT NULL,
  `coefficient` varchar(40) NOT NULL,
  `professeur_titulaire` int(11) NOT NULL,
  `professeur_supleant` int(11) DEFAULT NULL,
  `etat` varchar(40) NOT NULL DEFAULT 'Actif',
  `filiere` varchar(40) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `cours`
--

INSERT INTO `cours` (`codeCours`, `nomCours`, `niveau`, `session`, `coefficient`, `professeur_titulaire`, `professeur_supleant`, `etat`, `filiere`) VALUES
(17, 'Analyse 1', 'EUF', '1', '4', 7, 6, 'Actif', 'Sciences Informatiques'),
(18, 'Dessin Technic', 'EUF', '1', '2', 1, NULL, 'Actif', 'Beaux-Arts'),
(22, 'Introduction a la psycologie', 'EUF', '1', '1', 9, NULL, 'Actif', 'Psychologie'),
(20, 'Espagnole', 'EUF', '1', '1', 10, NULL, 'Actif', 'Science de l\'Education'),
(21, 'Analyse 1', 'EUF', '1', '1', 7, NULL, 'Actif', 'Faculte d\'Agronomie'),
(23, 'Biologie', 'EUF', '2', '1', 11, NULL, 'Actif', 'Psychologie'),
(24, 'Geologie', 'EUF', '1', '1', 12, NULL, 'Actif', 'Aménagement du Territoire'),
(25, 'Physique', 'EUF', '1', '1', 8, NULL, 'Actif', 'Science de l\'Environement'),
(26, 'Statistique 1', 'EUF', '1', '1', 10, NULL, 'Actif', 'Science Politique'),
(27, 'Introduction a la psycologie', 'EUF', '1', '1', 1, NULL, 'Actif', 'Psycho-Education'),
(28, 'Statistique 1', 'EUF', '1', '1', 1, NULL, 'Actif', 'Travail Social'),
(29, 'Introduction a la sociologie', 'EUF', '1', '1', 1, NULL, 'Actif', 'Sociologie'),
(30, 'Anatomie', 'EUF', '1', '1', 9, NULL, 'Actif', 'Faculte de Médecine'),
(31, 'Analyse 1', 'EUF', '1', '1', 13, NULL, 'Actif', 'Faculte des Sciences et de Génie'),
(32, 'Introduction a la sociologie', 'EUF', '2', '1', 1, NULL, 'Actif', 'Science Politique'),
(34, 'Informatique Bureautique 2', 'EUF', '2', '1', 7, NULL, 'Actif', 'Sciences Informatiques'),
(35, 'Analyse 2', 'EUF', '2', '1', 6, NULL, 'Actif', 'Science de l\'Education'),
(36, 'Optique', 'EUF', '2', '1', 8, 7, 'Actif', 'Faculte d\'Agronomie'),
(37, 'Phisiologie', 'EUF', '2', '1', 6, NULL, 'Actif', 'Faculte de Médecine'),
(42, 'Optique', 'EUF', '2', '1', 8, NULL, 'Actif', 'Faculte des Sciences et de Génie'),
(43, 'Analyse 2', 'EUF', '2', '1', 12, NULL, 'Actif', 'Science de l\'Environement'),
(44, 'Geographie', 'EUF', '2', '1', 12, NULL, 'Actif', 'Aménagement du Territoire'),
(46, 'Optique', 'EUF', '2', '1', 8, NULL, 'Actif', 'Psycho-Education'),
(47, 'Statistique 2', 'EUF', '2', '1', 11, NULL, 'Actif', 'Travail Social'),
(48, 'Statistique 2', 'EUF', '2', '1', 11, NULL, 'Actif', 'Sociologie'),
(49, 'Photographie', 'EUF', '2', '1', 10, NULL, 'Actif', 'Beaux-Arts');

-- --------------------------------------------------------

--
-- Structure de la table `etudiant`
--

CREATE TABLE `etudiant` (
  `idEtudiant` int(11) NOT NULL,
  `codeEtudiant` varchar(9) NOT NULL,
  `nomEtudiant` varchar(40) NOT NULL,
  `prenomEtudiant` varchar(40) NOT NULL,
  `profil` varchar(255) DEFAULT NULL,
  `sexe` varchar(14) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `lieu_naissance` varchar(50) NOT NULL,
  `date_naissance` date NOT NULL,
  `telephone` varchar(14) NOT NULL,
  `email` varchar(40) NOT NULL,
  `annee_academique` int(9) NOT NULL,
  `filiere` varchar(100) NOT NULL,
  `niveau` varchar(40) NOT NULL,
  `nif_cin` varchar(20) NOT NULL,
  `personne_ref` varchar(50) NOT NULL,
  `tel_ref` varchar(14) NOT NULL,
  `etat` varchar(30) NOT NULL DEFAULT 'Actif',
  `memo` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `etudiant`
--

INSERT INTO `etudiant` (`idEtudiant`, `codeEtudiant`, `nomEtudiant`, `prenomEtudiant`, `profil`, `sexe`, `adresse`, `lieu_naissance`, `date_naissance`, `telephone`, `email`, `annee_academique`, `filiere`, `niveau`, `nif_cin`, `personne_ref`, `tel_ref`, `etat`, `memo`) VALUES
(1, 'RL-003994', 'Lubris', 'Rose Katie', '1637613767308.jpeg', 'femme', '#40, Ruel Lapaix, Champin, Cap-Haitien, Nord, Haiti', 'Port-Margot', '2000-10-31', '+509 44055050', '+509 45342345', 1, 'Science de l\'Environement', 'L1', '', 'Mimose Lubris', '+509 45342345', 'Actif', ''),
(2, 'JP-34567', 'Jamal', 'Paul', NULL, 'homme', '#45, Ruel capois, Vertiere, Cap-Haitien, Haiti', 'Port-Margot', '1999-07-06', '+509 44055050', 'jamal@gmal.com', 1, 'Sciences Informatiques', 'L1', '34556', 'Louis Jean Josue', '+509 34453667', 'Actif', ''),
(123456801, 'BL-97-024', 'Lori', 'Britanie', NULL, 'femme', '#5 rue 5 Boulvard', 'Port-Margot', '2001-11-01', '+509 44055050', 'bri@gmail.com', 1, 'Science de l\'Education', 'L1', '123 654 765 1', 'Lucie Lori', '+509 45342345', 'Actif', ''),
(123456802, 'CL-20-025', 'Louis', 'Carlos', NULL, 'femme', 'Vertiere, Cap-Haitien,', 'Port-de-Paix', '2003-11-03', '+509 44183270', 'caloslouis@gmail.com', 1, 'Faculte de Médecine', 'L1', '123 455 096 0', 'Rachel Louis', '+509 34453667', 'Actif', ''),
(123456803, 'RL-01-025', 'Louis', 'Rutshel', NULL, 'femme', '#19 ruel Chalmagne, Cap-Haitien', 'Cap-Haitien', '2002-11-15', '+509 34343536', 'rutshel@gmail.com', 1, 'Faculte d\'Agronomie', 'L1', '567 789 901 8', 'Pluviose Jean', '+509 34566786', 'Actif', ''),
(123456804, '', 'Marie', 'Ducatel ', NULL, 'femme', 'Limonade', 'Milot', '2000-11-01', '+509 ', 'mariejose@gmail.com', 1, 'Science Politique', 'L1', '008 653 634 6', 'Marise Ducatel', '+509 34453667', 'Actif', ''),
(123456805, 'ML-0987', 'Mirma', 'Lincifort', NULL, 'femme', 'Cap-Haitien', 'Cap-Haitien', '2000-05-03', '+509 34455556', 'miyou@gmail.com', 1, 'Faculte des Sciences et de Génie', 'L1', '234 567 890 1', 'Bibiana Ducatel', '+509 34455667', 'Actif', ''),
(123456806, 'DL-1345', 'Luckenley', 'Doudou', NULL, 'femme', 'Cap-Haitien', 'Cap-Haitien', '2000-06-24', '+509 44055050', 'doudou@gmail.com', 1, 'Sociologie', 'L1', '123 123 098 0', 'Luchson DouDou', '+509 45342349', 'Actif', ''),
(123456807, 'LR-765', 'Livenson', 'Richemon', NULL, 'homme', 'Caracol', 'Cap-Haitien', '2000-05-10', '+509 44183277', 'richemon@gmai.com', 1, 'Aménagement du Territoire', 'L1', '123 654 765 8', 'Madeline Jean', '+509 34455668', 'Actif', ''),
(123456808, 'CJ-7654', 'Chebania', 'Jean', NULL, 'femme', 'P13L, vilage EKAM, Caracol, Nord\'est, Haiti', '', '2000-03-15', '+509 45678956', 'cheche@gmail.com', 1, 'Sciences Informatiques', 'L1', '123 455 006 0', 'Mirlene Jean', '+509 45342393', 'Actif', ''),
(123456809, 'DD-3454', 'Dudley', 'Doudou', NULL, 'homme', 'P23F, vilage EKAM, Caracol, Nord\'est, Haiti', 'Cap-Haitien', '2003-05-22', '+509 46465224', 'doudouley@gmail.com', 1, 'Psychologie', 'L1', '123-123-123-9', 'Luchson DouDou', '+509 34455668', 'Actif', ''),
(123456810, 'LJ-795', 'Jahleel Jr', 'Lincifort', NULL, 'homme', 'Cap-Haitien', 'Cap-Haitien', '1998-11-18', '+509 34455556', 'jLincifort@gmal.com', 1, 'Beaux-Arts', 'L1', '234 568 890 5', 'Bibiana Ducatel', '+509 34453666', 'Actif', ''),
(123456811, 'AA-456', 'Amelia', 'Aldena', NULL, 'femme', 'Caracol', 'Cap-Haitien', '2002-04-16', '+509 34455333', 'Amelia@gmail.com', 1, 'Psycho-Education', 'L1', '234 567 891 2', 'Alma Ducatel', '+509 ', 'Actif', ''),
(123456812, 'SJ-0004', 'Shebania', 'Jean', NULL, 'femme', 'P42F, vilage EKAM, Caracol, Nord\'est, Haiti', 'Cap-Haitien', '2000-11-07', '+509 44055050', 'sheshe@gmail.com', 1, 'Travail Social', 'L1', '234 567 840 1', 'Siselande Jean', '+509 45342333', 'Actif', ''),
(123456817, 'PJ-260000', 'Pierre', 'Jean-Louis', NULL, 'femme', 'Rue Godin, Fort-liberte, Nort\'Est', 'Limbe', '2002-11-05', '+509 4633-4554', 'jlp@gmail.com', 3, 'Psychologie', 'EUF', '123-123-123-8', 'Pierre Jean', '+509 4564-7643', 'Actif', ''),
(123456816, 'AD-000024', 'Jean', 'Prisca', NULL, 'Femme', '#5 Rue 7 A, Cap-Haitien', 'Cap-Haitien', '1999-04-21', '4.6030267E7', 'priska@gmail.com', 1, 'Science de l\'Environement', 'L1', '123-123-123-2', ' Noel Paula', '4.8344872E7', 'Actif', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `horaire`
--

CREATE TABLE `horaire` (
  `id` int(11) NOT NULL,
  `idCours` int(11) NOT NULL,
  `jour` varchar(10) NOT NULL,
  `heure_debut` varchar(6) NOT NULL,
  `heure_fin` varchar(6) NOT NULL,
  `type` varchar(15) NOT NULL DEFAULT 'cours magistral'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

--
-- Contenu de la table `horaire`
--

INSERT INTO `horaire` (`id`, `idCours`, `jour`, `heure_debut`, `heure_fin`, `type`) VALUES
(26, 21, 'Lundi', '08:00', '12:00', 'cours magistral'),
(25, 35, 'Vendredi', '08:00', '12:00', 'tp'),
(24, 35, 'Jeudi', '08:00', '12:00', 'cours magistral'),
(23, 20, 'Jeudi', '15:00', '17:00', 'cours magistral'),
(21, 17, 'Mardi', '09:00', '11:00', 'cours magistral'),
(20, 17, 'Lundi', '13:00', '15:00', 'tp'),
(19, 26, 'Lundi', '10:00', '12:00', 'cours magistral'),
(18, 17, 'Lundi', '08:00', '10:00', 'cours magistral'),
(27, 21, 'Lundi', '12:00', '17:00', 'tp'),
(28, 36, 'Lundi', '09:00', '12:00', 'cours magistral'),
(29, 36, 'Lundi', '13:00', '16:00', 'tp'),
(30, 30, 'Mardi', '08:00', '10:00', 'cours magistral'),
(31, 31, 'Mercredi', '08:00', '12:00', 'cours magistral'),
(32, 31, 'Mercredi', '13:00', '17:00', 'tp'),
(33, 37, 'Mercredi', '08:00', '10:00', 'cours magistral'),
(36, 25, 'Vendredi', '09:00', '12:00', 'cours magistral'),
(37, 25, 'Vendredi', '13:00', '17:00', 'tp'),
(39, 42, 'Mardi', '11:00', '16:00', 'cours magistral'),
(40, 43, 'Lundi', '08:00', '16:00', 'cours magistral'),
(41, 24, 'Lundi', '13:00', '15:00', 'cours magistral'),
(42, 44, 'Lundi', '11:00', '14:00', 'cours magistral'),
(43, 44, 'Lundi', '11:00', '15:00', 'cours magistral'),
(44, 22, 'Lundi', '09:00', '11:00', 'cours magistral'),
(45, 32, 'Vendredi', '11:00', '14:00', 'cours magistral'),
(46, 34, 'Mercredi', '22:00', '15:00', 'cours magistral'),
(47, 23, 'Jeudi', '09:00', '11:00', 'cours magistral'),
(48, 27, 'Jeudi', '09:00', '11:00', 'cours magistral'),
(49, 34, 'Lundi', '', '11:00', 'cours magistral'),
(50, 46, 'Lundi', '08:00', '12:00', 'cours magistral'),
(51, 47, 'Vendredi', '11:00', '16:00', 'cours magistral'),
(52, 29, 'Vendredi', '08:00', '10:00', 'cours magistral'),
(53, 48, 'Mercredi', '09:00', '12:00', 'cours magistral'),
(54, 18, 'Jeudi', '08:00', '10:00', 'tp'),
(55, 49, 'Vendredi', '12:00', '15:00', 'tp'),
(56, 28, 'Lundi', '09:00', '11:00', 'cours magistral');

-- --------------------------------------------------------

--
-- Structure de la table `notes`
--

CREATE TABLE `notes` (
  `id_note` int(14) NOT NULL,
  `idEtudiant` int(14) NOT NULL,
  `codeCours` int(14) NOT NULL,
  `noteSur100` int(14) NOT NULL,
  `annee_academique` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `notes`
--

INSERT INTO `notes` (`id_note`, `idEtudiant`, `codeCours`, `noteSur100`, `annee_academique`) VALUES
(16, 1, 25, 78, 1),
(15, 123456805, 31, 80, 1),
(14, 123456802, 30, 70, 1),
(13, 123456803, 21, 70, 1),
(12, 123456801, 20, 67, 1),
(7, 2, 17, 70, 1),
(11, 123456804, 26, 67, 1),
(10, 1, 21, 75, 1),
(17, 123456807, 24, 79, 1),
(18, 123456809, 22, 90, 1),
(19, 123456811, 27, 70, 1),
(20, 123456812, 28, 90, 1),
(21, 123456806, 29, 78, 1),
(22, 123456810, 18, 87, 1),
(23, 2, 34, 78, 1),
(24, 123456804, 32, 78, 1),
(25, 123456801, 35, 65, 1),
(26, 123456803, 36, 68, 1),
(27, 123456802, 37, 78, 1),
(28, 123456805, 42, 78, 1),
(29, 1, 43, 71, 1),
(30, 123456807, 44, 69, 1),
(31, 123456809, 23, 75, 1),
(32, 123456811, 46, 64, 1),
(33, 123456812, 47, 67, 1),
(34, 123456806, 48, 68, 1),
(35, 123456810, 49, 73, 1),
(36, 123456808, 17, 70, 1),
(37, 123456808, 34, 68, 1),
(38, 123456816, 25, 64, 1),
(39, 123456816, 43, 70, 1);

-- --------------------------------------------------------

--
-- Structure de la table `professeur`
--

CREATE TABLE `professeur` (
  `idProfesseur` int(11) NOT NULL,
  `codeProfesseur` varchar(10) NOT NULL,
  `nom` varchar(40) NOT NULL,
  `prenom` varchar(40) NOT NULL,
  `profil` varchar(255) DEFAULT NULL,
  `sexe` varchar(14) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `telephone` varchar(40) NOT NULL,
  `statut_matrimonial` varchar(40) NOT NULL,
  `lieu_naissance` varchar(40) NOT NULL,
  `date_naissance` date NOT NULL,
  `niveau` varchar(40) NOT NULL,
  `filiere_affecte` varchar(50) NOT NULL,
  `poste` varchar(40) NOT NULL,
  `salaire` double NOT NULL,
  `email` varchar(40) NOT NULL,
  `nif_cin` varchar(40) NOT NULL,
  `etat` varchar(40) NOT NULL DEFAULT 'Actif',
  `memo` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `professeur`
--

INSERT INTO `professeur` (`idProfesseur`, `codeProfesseur`, `nom`, `prenom`, `profil`, `sexe`, `adresse`, `telephone`, `statut_matrimonial`, `lieu_naissance`, `date_naissance`, `niveau`, `filiere_affecte`, `poste`, `salaire`, `email`, `nif_cin`, `etat`, `memo`) VALUES
(1, '1-MJ', 'Moricet', 'Jean', '1637363100575.jpeg', 'homme', 'limonade', '+509 45464632', 'Celibatair', 'limbe', '1980-04-30', 'Master', 'Science de l\'Environement', 'Professeur titulaire', 455567, 'jeanlucien@gmail.com', '546445', 'inactif', ''),
(6, 'AM-14680', 'Morice', 'Anita B.', '1637619170499.jpeg', 'femme', '4, Rue Capoise, Vertiere, Cap-Haitien, Haiti', '+509 33455665', 'Celibatair', 'Limbe', '1990-11-03', 'Master', 'Science de l\'environement', 'Professeur', 1468, 'Anita@gmail.com', '34667', 'Actif', ''),
(7, 'FP-123456', 'Pierre', 'Philis', '1637619829055.jpeg', 'femme', '#20, rue 20 k, cap-haitien, nord, Haiti', '+509 45464645', 'Celibatair', 'Pilate', '1994-02-12', 'Licence', 'Science de l\'environement', 'Assistante', 3456, 'philis509@gmail.com', '1234', 'Actif', ''),
(8, 'JS-2345', 'Jean', 'Silly', NULL, 'homme', 'Limonade', '48326734', 'Celibatair', 'Limonade', '1990-06-19', '2', 'Science de l\'Environement', 'Professeur', 12345, 'silly@gmail.com', '222-333-111-0', 'Actif', ''),
(9, '', 'Nojean', 'Presley', '1637776323710.jpeg', 'homme', 'Limonade', '+509 45464645', 'Celibatair', 'limonade', '1988-11-15', 'Master', 'Sciences Informatiques', 'Professeur', 1234, 'nojean@gmail.com', '444-444-444-0', 'Actif', ''),
(10, '', 'Philipe', 'Wisli', '1637776518790.jpeg', 'homme', 'Limonade', '+509 33455665', 'Celibatair', 'Fort-liberte', '1987-11-11', 'Master', 'Science de l\'Environement', 'Professeur', 123, 'phil@gmail.cim', '444-444-444-1', 'Actif', ''),
(11, '', 'Jean', 'Briniol', NULL, 'homme', 'Limonade', '+509 43454676', 'Celibatair', 'Fort-liberte', '1987-11-04', 'Master', 'Science de l\'Environement', 'Professeur', 1234, 'briniol@gmail.com', '444-444-444-2', 'Actif', ''),
(12, '', 'Jules', 'Wilson', NULL, 'homme', 'Limonade', '+509 46563626', 'Celibatair', 'Limbe', '1994-11-24', 'Master', 'Science de l\'Environement', 'Professeur', 1234, 'jules@gmail.com', '444-444-444-4', 'Actif', ''),
(13, 'PM', 'Paul', 'Milouri', NULL, 'homme', '', '+509 32355443', 'marie', 'Cap-Haitien', '1988-01-20', 'Master', 'Travail Social', 'Professeur ', 12345, 'Paul', '123 123 222 0', 'Actif', '');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `idUtilisateur` int(14) NOT NULL,
  `nomUser` varchar(255) NOT NULL,
  `prenomUser` varchar(255) NOT NULL,
  `profil` varchar(255) DEFAULT NULL,
  `poste` varchar(50) NOT NULL,
  `pseudo` varchar(40) NOT NULL,
  `pass` varchar(30) NOT NULL,
  `privilege` text NOT NULL,
  `etat` varchar(40) NOT NULL DEFAULT 'Actif'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `utilisateur`
--

INSERT INTO `utilisateur` (`idUtilisateur`, `nomUser`, `prenomUser`, `profil`, `poste`, `pseudo`, `pass`, `privilege`, `etat`) VALUES
(6, 'Ducatel', 'Alma', NULL, 'Assistant(e)', 'Amal Clouney', '1234', 'Annee academique,Etudiant,Professeur,Cours,Horaire,Utilisateur,Note', 'Actif'),
(7, 'Lincoln', 'Haricot CompÃ¨re', NULL, 'Professeur(e)', 'Lincoln', '1234', 'Etudiant,Cours,Horaire,Note', 'Actif');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `annee_academique`
--
ALTER TABLE `annee_academique`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `bultin`
--
ALTER TABLE `bultin`
  ADD PRIMARY KEY (`idBultin`),
  ADD KEY `fkIdnote` (`id_note`),
  ADD KEY `fkcodeCours` (`codeCours`),
  ADD KEY `fkcodeEtudiant` (`codeEtudiant`);

--
-- Index pour la table `cours`
--
ALTER TABLE `cours`
  ADD PRIMARY KEY (`codeCours`);

--
-- Index pour la table `etudiant`
--
ALTER TABLE `etudiant`
  ADD PRIMARY KEY (`idEtudiant`),
  ADD UNIQUE KEY `nif_cin` (`nif_cin`),
  ADD UNIQUE KEY `codeEtudiant` (`codeEtudiant`);

--
-- Index pour la table `horaire`
--
ALTER TABLE `horaire`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cours` (`idCours`);

--
-- Index pour la table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`id_note`),
  ADD UNIQUE KEY `uk_etu_cours` (`idEtudiant`,`codeCours`),
  ADD KEY `fk_annee` (`annee_academique`),
  ADD KEY `fk_cours` (`codeCours`);

--
-- Index pour la table `professeur`
--
ALTER TABLE `professeur`
  ADD PRIMARY KEY (`idProfesseur`),
  ADD UNIQUE KEY `nif_cin` (`nif_cin`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`idUtilisateur`),
  ADD UNIQUE KEY `pseudo` (`pseudo`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `annee_academique`
--
ALTER TABLE `annee_academique`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT pour la table `bultin`
--
ALTER TABLE `bultin`
  MODIFY `idBultin` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `cours`
--
ALTER TABLE `cours`
  MODIFY `codeCours` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;
--
-- AUTO_INCREMENT pour la table `etudiant`
--
ALTER TABLE `etudiant`
  MODIFY `idEtudiant` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123456818;
--
-- AUTO_INCREMENT pour la table `horaire`
--
ALTER TABLE `horaire`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;
--
-- AUTO_INCREMENT pour la table `notes`
--
ALTER TABLE `notes`
  MODIFY `id_note` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;
--
-- AUTO_INCREMENT pour la table `professeur`
--
ALTER TABLE `professeur`
  MODIFY `idProfesseur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `idUtilisateur` int(14) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
