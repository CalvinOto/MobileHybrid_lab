-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 29, 2026 at 03:20 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `honkai_star_retail`
--

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `total_price` decimal(10,2) NOT NULL,
  `purchased_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `user_id`, `resource_id`, `quantity`, `total_price`, `purchased_at`) VALUES
(5, 1, 18, 3, 29700.00, '2026-05-29 12:38:13'),
(6, 1, 15, 2, 52000.00, '2026-05-29 12:38:26'),
(7, 1, 15, 1, 26000.00, '2026-05-29 12:38:39');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `type` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `name`, `type`, `description`, `stock`, `image`, `price`, `created_at`) VALUES
(1, 'A Secret Vow', 'Light Cone', 'Rarity	★★★★\nPath the destruction\nStar Rail - The Destruction The Destruction\nAbility	Spare No Effort\nIncreases DMG dealt by the wearer by 20%/25%/30%/35%/40%. The wearer also deals an extra 20%/25%/30%/35%/40% of DMG to enemies whose current HP percentage is equal to or higher than the wearer\'s current HP percentage.\nRating	\nStar Rail - S The Destruction', 5, '1779607408587.png', 199999.00, '2026-05-24 07:23:28'),
(3, 'Shattered home', 'Light Cone', 'Path the destrcution\nStar Rail - The Destruction The Destruction\nAbility	Eradication\nDeals 20%/25%/30%/35%/40% increased DMG to any enemies whose HP is above 50%.', 10, '1779607582036.png', 99000.00, '2026-05-24 07:26:22'),
(4, 'Woof! Walk Time!', 'Light Cone', 'Rarity	★★★★\nStar Rail - The Destruction The Destruction\nAbility	Run!\nIncreases the wearer\'s ATK by 10%/12.5%/15%/17.5%/20%, and increases their DMG to enemies afflicted with Burn or Bleed by 16%/20%/24%/28%/32%. This also applies to DoT.', 7, '1779607630413.png', 198000.00, '2026-05-24 07:27:10'),
(5, 'Brighter than the sun', 'Light Cone', 'Rarity	★★★★★\nPath the destruction\nStar Rail - The Destruction The Destruction\nAbility	Defiant Till Death\nIncreases the wearer\'s CRIT Rate by 18%/21%/24%/27%/30%. When the wearer uses Basic ATK, they will gain one stack of Dragon\'s Call for 2 turns. Each stack of Dragon\'s Call increases the wearer\'s ATK by 18%/21%/24%/27%/30% and Energy Regeneration Rate by 6%/7%/8%/9%/10%. Dragon\'s Call can be stacked up to 2 times.', 0, '1779607662805.png', 298000.00, '2026-05-24 07:27:43'),
(6, 'Nevermore', 'Other', 'Star Rail - Nevermore Item\nRarity	★★★\nDescription	A record that can be played on the Express\' phonograph. It might be a chance acquisition or a gift from someone else. All sorts of memories surge up when the music plays - the smiles, encounters, touches, and the excitement of battle. Maybe that is why people still collect records even as society rapidly advances.\nThe current record contains the track.', 99, '1779608016053.png', 39000.00, '2026-05-24 07:33:36'),
(7, 'Herta Bond', 'Other', 'Star Rail - Herta Bond Item\nRarity	★★★★★\nEffect	A reward from the Simulated Universe. Can be used to buy items from Herta\'s Store.', 30, '1779608056227.png', 99000.00, '2026-05-24 07:34:16'),
(8, 'Exorcismal Fulu', 'Other', 'Star Rail - Exorcismal Fulu Item\nRarity	★★★★\nEffect	Used to Superimpose the Light Cone \"Hey, Over Here\"', 48, '1779608090765.png', 59000.00, '2026-05-24 07:34:50'),
(10, 'Poet of Mourning Collapse', 'Relic', '2-Pc: Increases Quantum DMG by 10%.\n4-Pc: Decreases the wearer\'s SPD by 8%. Before entering battle, if the wearer\'s SPD is less than 110/95, increases the wearer\'s CRIT Rate by 20%/32%. This effect also applies to the wearer\'s memosprite.', 9, '1779608190317.png', 149000.00, '2026-05-24 07:36:30'),
(11, 'Pioneer Diver of Dead', 'Relic', '2-Piece Effect	Increases DMG dealt to enemies with debuff by 12%.\n4-Piece Effect	Increases CRIT Rate by 4%. The wearer deals 8%/12% increased CRIT DMG to enemies with at least 2/3 debuffs. After the wearer inflicts a debuff on enemy targets, the aforementioned effects increase by 100%, lasting for 1 turn(s).', 3, '1779608226179.png', 169000.00, '2026-05-24 07:37:06'),
(12, 'Wavestrider Captain', 'Relic', '2-Pc: CRIT DMG increases by 16%.\n4-Pc: When the wearer is the target of another ally target\'s ability, gains 1 stack of \"Help,\" stacking up to 2 times. When using Ultimate, if the unit possesses 2 stacks of \"Help,\" consumes all \"Help\" and increases the wearer\'s ATK by 48%, lasting 1 turn.', 2, '1779608287883.png', 199000.00, '2026-05-24 07:38:08'),
(13, 'Advanture Log', 'Material', 'Rarity	★★★\nEffect	Experience materials for characters. Provides 5000 Character EXP', 169, '1779608364663.png', 19000.00, '2026-05-24 07:39:24'),
(14, 'Endotherm Chitin', 'Material', 'Star Rail - Endotherm Chitin Item\nRarity	★★★★\nEffect	Hot, translucent substance almost like fire in the solid state. Can be used for the Ascension of Fire characters.', 152, '1779608393454.png', 25000.00, '2026-05-24 07:39:53'),
(15, 'Heavenly Melody', 'Material', 'Star Rail - Heavenly Melody Item\nRarity	★★★★\nEffect	Symphonic movements from the cosmos. Used to level up Traces significantly for Harmony characters.', 117, '1779608422532.png', 26000.00, '2026-05-24 07:40:22'),
(16, 'Key of Inspiration', 'Material', 'Star Rail - Key of Inspiration Item\nRarity	★★\nEffect	Fragmented saw teeth left behind by automatons. Can be use for the ascension of Physical Characters', 299, '1779608457037.png', 10900.00, '2026-05-24 07:40:57'),
(17, 'Lost Crystal', 'Material', 'Star Rail - Lost Crystal  Item\nRarity	★★★★\nEffect	Enhancement material for Relics. Provides 1000 Relic EXP.', 120, '1779608491307.png', 29000.00, '2026-05-24 07:41:31'),
(18, 'Sparse Aether', 'Material', 'Star Rail - Sparse Aether Item\nRarity	★★\nEffect	Enhancement material for Light Cones, provides 500 Light Cone EXP.', 198, '1779608522759.png', 9900.00, '2026-05-24 07:42:03');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `google_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `google_id`, `created_at`) VALUES
(1, 'user', 'user@gmail.com', '$2b$10$nL5WEDInKXPLoj9aiia9aOlr3vbsr9QEuqxAAqP8apDpbW1N3sF8e', 'user', NULL, '2026-05-24 07:19:06'),
(2, 'admin', 'admin@gmail.com', '$2b$10$4pu.qp17me/3CWH25z2txOt7S3QcCXvJtFJhsJGOwtg7gXu44EOc.', 'admin', NULL, '2026-05-24 07:19:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `resource_id` (`resource_id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
