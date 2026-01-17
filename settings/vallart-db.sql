-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 13, 2025 at 12:45 PM
-- Server version: 11.8.3-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u582110486_anavitch`
--

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

CREATE TABLE `brand` (
  `id` int(11) NOT NULL,
  `brand_name` varchar(255) NOT NULL,
  `parentOf` int(11) DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `brand`
--

INSERT INTO `brand` (`id`, `brand_name`, `parentOf`, `added_by`, `date_created`) VALUES
(1, 'Raw Garden', NULL, 1, '2025-10-31 19:49:53'),
(2, 'Stiiizy', NULL, 1, '2025-10-31 19:49:53'),
(3, 'Chava Keller', 2, 1, '2025-10-31 19:49:53'),
(4, 'Jeeter', NULL, 1, '2025-10-31 19:49:53'),
(5, 'Kuame Farmer', 6, 1, '2025-10-31 19:49:54'),
(6, 'Heavy Hitters', NULL, 1, '2025-10-31 19:49:54'),
(7, 'Plug Play', NULL, 1, '2025-10-31 19:49:54'),
(8, 'Kurvana', NULL, 1, '2025-10-31 19:49:54'),
(9, 'Select', NULL, 1, '2025-10-31 19:49:54'),
(11, 'PAX', NULL, 1, '2025-10-31 19:49:55'),
(12, 'Kingpen', NULL, 1, '2025-10-31 19:49:55'),
(14, 'Gorilla Glue', NULL, 1, '2025-10-31 19:49:56'),
(15, 'Girl Scout Cookies', NULL, 1, '2025-10-31 19:49:56'),
(16, 'Nola Nichols', 8, 1, '2025-10-31 20:04:34'),
(17, 'Moana Garrett', 8, 1, '2025-10-31 20:05:14');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `movie_id`, `name`, `price`, `image`, `quantity`) VALUES
(2, 2, 2, 'Sour Diesel', 320.00, 'sour_diesel.jpg', 1),
(3, 3, 4, 'Live Resin Cart - Wedding Cake', 450.00, 'wedding_cake_cart.jpg', 2),
(4, 4, 5, 'Glass Water Pipe - 12 inch', 800.00, 'glass_bong.jpg', 1),
(6, 1, 3, 'Cookies THC Gummies', 250.00, '906_368_Chocolate 3 pack.png', 2);

-- --------------------------------------------------------

--
-- Table structure for table `cat`
--

CREATE TABLE `cat` (
  `id` int(11) NOT NULL,
  `cat_name` varchar(255) NOT NULL,
  `parentOf` int(11) DEFAULT NULL,
  `added_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat`
--

INSERT INTO `cat` (`id`, `cat_name`, `parentOf`, `added_by`) VALUES
(1, 'Flower', NULL, 1),
(2, 'Edibles', NULL, 1),
(3, 'Vapes', NULL, 1),
(4, 'Concentrates', NULL, 1),
(5, 'Accessories', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `grp`
--

CREATE TABLE `grp` (
  `id` int(11) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `parentOf` int(11) DEFAULT NULL,
  `added_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grp`
--

INSERT INTO `grp` (`id`, `group_name`, `parentOf`, `added_by`) VALUES
(1, 'Indica', NULL, 1),
(2, 'Sativa', NULL, 1),
(3, 'Hybrid', NULL, 1),
(4, 'CBD Products', NULL, 1),
(5, 'Premium', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qnt_add` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`user_id`, `product_id`, `qnt_add`, `date`) VALUES
(1, 1, 30, '2024-08-15 03:00:00'),
(1, 2, 25, '2024-08-15 03:15:00'),
(2, 3, 60, '2024-08-16 04:00:00'),
(2, 4, 20, '2024-08-16 04:30:00'),
(3, 5, 15, '2024-08-17 05:00:00'),
(8, 3, -1, '2025-09-25 23:33:43'),
(8, 5, 1, '2025-10-03 20:33:23'),
(8, 5, 1, '2025-10-03 20:34:11'),
(8, 5, -2, '2025-10-04 12:57:54'),
(8, 1, -2, '2025-10-04 13:21:45'),
(1, 3, 1, '2025-10-06 13:35:48'),
(1, 5, 1, '2025-10-06 13:35:48'),
(8, 5, 1, '2025-10-09 16:28:48'),
(8, 3, -1, '2025-10-09 16:28:48'),
(8, 4, -1, '2025-10-09 16:28:48'),
(8, 3, -2, '2025-10-09 16:34:29'),
(8, 3, -1, '2025-10-09 16:35:59'),
(8, 3, -1, '2025-10-12 15:33:47'),
(8, 4, -1, '2025-10-14 17:00:42'),
(8, 4, -1, '2025-10-14 17:02:12'),
(8, 5, 1, '2025-10-14 23:40:56'),
(8, 3, -1, '2025-10-14 23:40:56'),
(8, 1, -1, '2025-10-17 15:40:52');

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `region_id` int(11) NOT NULL,
  `short_desc` text DEFAULT NULL,
  `long_desc` longtext DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `video_type` tinyint(4) DEFAULT 1,
  `video` text DEFAULT NULL,
  `trailer` varchar(255) DEFAULT NULL,
  `ad_img` varchar(255) DEFAULT NULL,
  `ad_link` varchar(255) DEFAULT NULL,
  `added_by` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `unit` int(11) DEFAULT 0,
  `featured` tinyint(4) DEFAULT 0,
  `pin_unpin_time` timestamp NULL DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`movie_id`, `title`, `cat_id`, `group_id`, `brand_id`, `region_id`, `short_desc`, `long_desc`, `thumbnail`, `video_type`, `video`, `trailer`, `ad_img`, `ad_link`, `added_by`, `price`, `unit`, `featured`, `pin_unpin_time`, `date_created`) VALUES
(1, 'OG Kush Premium', 1, 1, NULL, 1, 'Classic Indica strain with earthy flavors', '<p>OG Kush is a legendary strain with a complex terpene profile. Perfect for evening relaxation with potent effects and distinctive pine aroma.</p>', '393_294_Snowflake strain sativa.png', 1, 'Qui cumque voluptatu', '', '', '', 1, 350.00, 19, 1, '2025-08-21 02:29:05', '2025-08-21 02:29:05'),
(2, 'Sour Diesel', 1, 2, NULL, 2, 'Energizing Sativa for daytime use', '<p>Sour Diesel delivers an energizing cerebral high perfect for creative activities. Known for its         \r\n  pungent diesel aroma and uplifting effects.</p>', 'sour_diesel.jpg', 1, '', '', '', '', 1, 320.00, 18, 0, NULL, '2025-08-21 02:29:05'),
(3, 'Cookies THC Gummies', 2, 4, 3, 3, '10mg THC per gummy, 10 pack', '<p>Premium cannabis gummies with precise dosing. Each gummy contains 10mg of THC for consistent and reliable effects. Perfect for microdosing.</p>', '906_368_Chocolate 3 pack.png', 1, 'Qui cumque voluptatu', '', '398_ad_78_choco oreo RK.pngjpg', '', 2, 250.00, 34, 1, '2025-08-21 02:29:05', '2025-08-21 02:29:05'),
(4, 'Live Resin Cart - Wedding Cake', 3, 3, NULL, 4, '1g premium live resin cartridge', '<p>Wedding Cake live resin cartridge delivers exceptional flavor and potency. Made        \r\n  with fresh frozen cannabis for superior terpene retention.</p>', 'wedding_cake_cart.jpg', 1, '', '', '', '', 2, 450.00, 8, 0, NULL, '2025-08-21 02:29:05'),
(5, 'Glass Water Pipe - 12 inch', 5, 5, NULL, 5, 'Borosilicate glass bong', '<p>High-quality borosilicate glass water pipe with percolator for smooth hits. Includes bowl piece and easy-clean design.</p>', '898_218_Sour punch straws THC.png', 1, 'dfgsd', '', '', '', 3, 800.00, 4, 0, NULL, '2025-08-21 02:29:05'),
(6, 'Nihil adipisci qui p', 2, 3, NULL, 1, 'Et quis ut similique', '', '594_', 2, '571_184_Delux Vape n Puff Pack.png', 'Velit perspiciatis ', '819_ad_', 'Rerum aliqua Dignis', 1, 894.00, 0, 0, NULL, '2025-08-22 06:20:02');

-- --------------------------------------------------------

--
-- Table structure for table `ordere`
--

CREATE TABLE `ordere` (
  `id` int(11) NOT NULL,
  `client_number` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `number` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `method` varchar(100) NOT NULL,
  `adresse` text NOT NULL,
  `pin_code` varchar(50) DEFAULT NULL,
  `total_products` text NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `dat` timestamp NOT NULL DEFAULT current_timestamp(),
  `valid` varchar(50) DEFAULT 'pending',
  `valide_date` timestamp NULL DEFAULT NULL,
  `re_pro_date` timestamp NULL DEFAULT NULL,
  `confirm_date` timestamp NULL DEFAULT NULL,
  `rd_f_delv_date` timestamp NULL DEFAULT NULL,
  `in_delv_date` timestamp NULL DEFAULT NULL,
  `delivred_date` timestamp NULL DEFAULT NULL,
  `finalized_date` datetime DEFAULT NULL,
  `canceled_date` timestamp NULL DEFAULT NULL,
  `delayed_date` timestamp NULL DEFAULT NULL,
  `delivery_fee` decimal(10,2) DEFAULT 0.00,
  `discount` decimal(10,2) DEFAULT 0.00,
  `refund` decimal(10,2) DEFAULT 0.00,
  `final_total` decimal(10,2) DEFAULT 0.00,
  `eta` varchar(100) DEFAULT NULL,
  `complimentary_items` text DEFAULT NULL,
  `delivery_address_final` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ordere`
--

INSERT INTO `ordere` (`id`, `client_number`, `name`, `number`, `email`, `method`, `adresse`, `pin_code`, `total_products`, `total_price`, `dat`, `valid`, `valide_date`, `re_pro_date`, `confirm_date`, `rd_f_delv_date`, `in_delv_date`, `delivred_date`, `finalized_date`, `canceled_date`, `delayed_date`, `delivery_fee`, `discount`, `refund`, `final_total`, `eta`, `complimentary_items`, `delivery_address_final`) VALUES
(1, 101200, 'John Smith', '+52 322 123 4567', 'john.smith@email.com', 'Cash on Delivery', 'Hotel Zone Norte, Puerto Vallarta, Jalisco', 'PV001', 'OG Kush Premium (2g), Cookies      \r\n  THC Gummies (1 pack)', 950.00, '2024-08-20 05:30:00', 'delivered', '2024-08-20 06:00:00', '2024-08-20 06:30:00', '2024-08-20 07:00:00', '2024-08-20 09:00:00', '2024-08-20 10:00:00', '2024-08-20 11:30:00', NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(2, 101201, 'Sarah Johnson', '+52 322 234 5678', 'sarah.j@email.com', 'PayPal', 'Marina Vallarta, Puerto Vallarta, Jalisco', 'PV002', 'Sour Diesel (1g)', 320.00, '2024-08-20 09:15:00', 'in_delivery', '2024-08-20 09:30:00', '2024-08-20 10:00:00', '2024-08-20 10:30:00', '2024-08-20 12:00:00', '2024-08-20 12:30:00', NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(3, 101202, 'Mike Wilson', '+52 322 345 6789', 'mike.w@email.com', 'Bank Transfer', 'Nuevo Vallarta, Nayarit', 'PV003', 'Live Resin Cart - Wedding Cake (2 carts)', 900.00, '2024-08-21 04:00:00', 'confirmed', '2024-08-21 04:30:00', '2024-08-21 05:00:00', '2024-08-21 05:30:00', NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(4, 101203, 'Lisa Brown', '+52 322 456 7890', 'lisa.brown@email.com', 'Cash on Delivery', 'Centro Puerto Vallarta, Jalisco', 'PV004', 'Glass Water Pipe - 12 inch (1 piece)', 800.00, '2024-08-21 06:45:00', 'processing', '2024-08-21 07:00:00', '2024-08-21 07:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(5, 101204, 'David Davis', '+52 322 567 8901', 'david.d@email.com', 'Stripe', 'Zona Hotelera Sur, Puerto Vallarta, Jalisco', 'PV005', 'OG Kush Premium (1g), Cookies THC Gummies     \r\n   (2 packs)', 850.00, '2024-08-21 11:20:00', 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(6, 101205, 'Jason Gonzales', '942', 'gemysilij@mailinator.com', 'Visa MasterCard Via Stripe', 'Quia aut consequatur', 'Dolore nihil id et m', 'OG Kush Premium (2) , Cookies THC Gummies (1) ', 950.00, '2025-08-20 23:34:42', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(7, 101206, 'Robin Townsend', '517', 'myzokoco@mailinator.com', 'Cash', 'Modi in eum laboris ', 'Quo magnam omnis rer', 'Cookies THC Gummies (1) , Glass Water Pipe - 12 inch (1) ', 1050.00, '2025-08-22 03:27:54', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(8, 101207, 'Alika Ortega', '606', 'hironuqova@mailinator.com', 'Transfer Deposit', 'Aut quo reiciendis d', 'Deserunt doloribus e', 'Cookies THC Gummies (1) ', 250.00, '2025-09-04 21:04:40', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(9, 101208, 'ghjh', '879764521', 'dawood.dixeam@gmail.com', 'Oxxo', 'fddjdfdghdgfd', '43555', 'Cookies THC Gummies (2)', 250.00, '2025-09-25 11:02:36', 'Finalized', NULL, NULL, '2025-09-26 00:13:19', NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(10, 101209, 'Dawood Zafar', '3340102643', 'dawood.dixeam@gmail.com', 'Oxxo Transfer', 'house 109 Eagle City Sargodha', '40100', 'Cookies THC Gummies (1) , Live Resin Cart - Wedding Cake (1) , Glass Water Pipe - 12 inch (1) ', 1500.00, '2025-10-02 18:25:52', 'Finalized', NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-16 09:05:43', NULL, NULL, 0.00, 0.00, 0.00, 1500.00, '60 min', '{\"Rolling Papers\":\"Free\",\"Lighter\":\"Free\",\"Mints\":\"Free\"}', 'house 109 Eagle City Sargodha'),
(11, 101210, 'Dawood Zafar', '3340102643', 'dawood.dixeam@gmail.com', 'Visa/MasterCard/American Express', 'house 109 Eagle City Sargodha', '40100', 'Cookies THC Gummies (2) , Glass Water Pipe - 12 inch (1) ', 1300.00, '2025-10-02 18:27:08', 'NEW!!! (Validate)', '2025-10-14 05:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(12, 101211, 'Dawood Zafar', '3340102643', 'dawood.dixeam@gmail.com', 'ApplePay/Google Pay', 'house 109 Eagle City Sargodha', '40100', 'Cookies THC Gummies (1) ', 250.00, '2025-10-02 18:30:14', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(13, 101212, 'Dawood Zafar', '3340102643', 'dawood.dixeam@gmail.com', 'Visa/MasterCard/American Express', 'house 109 Eagle City Sargodh', '40100', 'Cookies THC Gummies (1), OG Kush Premium (2), Live Resin Cart - Wedding Cake (1)', 1050.00, '2025-10-02 18:36:03', 'Finalized', NULL, NULL, '2025-10-06 13:36:01', NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(14, 101213, 'Testing12', '65288856985', 'sales@test.com', 'Paypal', 'Yvfg de Distrito Esp 5', 'Tt', 'Cookies THC Gummies (3)', 750.00, '2025-10-09 16:34:29', 'In Delivery', NULL, NULL, '2025-10-09 16:48:03', '2025-10-09 00:00:00', '2025-10-09 00:00:00', NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(15, 101214, 'Farrah Patel', '701', 'dawood.dixeam@gmail.com', 'Paypal', 'house 109 Eagle City Sargodha', '40100', 'Cookies THC Gummies (1), Cookies THC Gummies (2)', 750.00, '2025-10-12 15:31:47', 'Finalized', NULL, NULL, '2025-10-14 16:20:39', '2025-10-14 05:00:00', NULL, NULL, '2025-10-17 11:27:25', NULL, NULL, 50.00, 0.00, 0.00, 800.00, '60 min', '{\"Rolling Papers\":\"Free\",\"Lighter\":\"Free\",\"Mints\":\"Free\"}', 'house 109 Eagle City Sargodha'),
(16, 101215, 'Emil Zapata', '7806166966', 'dez.slusher@gmail.com', 'Visa/MasterCard/American Express', 'Hyatt', 'New', 'Live Resin Cart - Wedding Cake (2)', 900.00, '2025-10-14 17:00:42', 'Finalized', NULL, '2025-10-14 17:32:28', '2025-10-14 17:06:58', '2025-10-14 17:32:05', '2025-10-14 17:33:02', '2025-10-14 17:54:48', '2025-10-14 13:25:02', NULL, NULL, 100.00, 50.00, 0.00, 950.00, '60 min', '{\"Rolling Papers\":\"Free\",\"Rolling sd\":\"Free\"}', 'Hyatt'),
(17, 101216, 'Dez', '3340102643', 'dez.slusher@gmail.com', 'Visa/MasterCard/American Express', 'Hyatt', 'New', 'Glass Water Pipe - 12 inch (1), Cookies THC Gummies (1)', 1050.00, '2025-10-14 23:39:47', 'Confirming', NULL, '2025-10-14 23:41:12', '2025-10-14 23:42:20', '2025-10-14 23:41:54', NULL, NULL, '2025-10-14 18:41:40', NULL, NULL, 100.00, 50.00, 0.00, 1100.00, '60 min', '{\"Rolling Papers\":\"Free\"}', 'Hyatt'),
(18, 101222, 'Dawood Zafar', '3340102643', 'dawood.dixeam@gmail.com', 'Oxxo Transfer', 'house 109 Eagle City Sargodha', '40100', 'OG Kush Premium (1) ', 350.00, '2025-10-17 15:40:52', 'Finalized', NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-20 15:33:56', NULL, NULL, 50.00, 0.00, 0.00, 400.00, '60 min', '{\"Rolling Papers\":\"Free\",\"Lighter\":\"Free\",\"Mints\":\"Free\"}', 'house 109 Eagle City Sargodha'),
(19, 101223, 'Dez', '55555885888', 'dez.slusher@gmail.com', 'Oxxo Transfer', 'Yvfg de Distrito Esp 5', 'Gg', 'OG Kush Premium (1) ', 350.00, '2025-11-12 14:53:28', 'Finalized', NULL, NULL, NULL, NULL, NULL, NULL, '2025-11-12 09:04:54', NULL, NULL, 100.00, 50.00, 0.00, 400.00, '60 min', '{\"Mints\":\"Free\"}', 'Yvfg de Distrito Esp 5');

-- --------------------------------------------------------

--
-- Table structure for table `receipt_log`
--

CREATE TABLE `receipt_log` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `receipt_id` varchar(50) NOT NULL,
  `email_sent` tinyint(4) DEFAULT 0,
  `custom_settings` text DEFAULT NULL,
  `generated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `receipt_log`
--

INSERT INTO `receipt_log` (`id`, `order_id`, `receipt_id`, `email_sent`, `custom_settings`, `generated_at`) VALUES
(1, 9, '420VTA-000009', 1, NULL, '2025-09-26 00:13:21'),
(2, 13, '420VTA-000013', 1, NULL, '2025-10-03 20:24:57'),
(3, 13, '420VTA-000013', 1, NULL, '2025-10-04 12:59:23'),
(4, 13, '420VTA-000013', 1, NULL, '2025-10-04 13:00:01'),
(5, 13, '420VTA-000013', 1, NULL, '2025-10-06 13:36:03'),
(6, 14, '420VTA-000014', 1, NULL, '2025-10-09 16:48:08'),
(7, 15, '420VTA-000015', 1, NULL, '2025-10-14 16:17:10'),
(8, 15, '420VTA-000015', 1, NULL, '2025-10-14 16:17:47'),
(9, 15, '420VTA-000015', 1, NULL, '2025-10-14 16:20:41'),
(10, 16, '420VTA-000016', 1, NULL, '2025-10-14 17:07:01'),
(11, 15, '420VTA-000015', 1, NULL, '2025-10-14 17:29:22'),
(12, 16, '420VTA-000016', 1, NULL, '2025-10-14 17:29:47'),
(13, 16, '420VTA-000016', 1, NULL, '2025-10-14 18:02:33'),
(14, 16, '420VTA-000016', 1, NULL, '2025-10-14 18:25:08'),
(15, 17, '420VTA-000017', 1, NULL, '2025-10-14 23:41:42'),
(16, 15, '420VTA-000015', 1, NULL, '2025-10-16 13:51:21'),
(17, 10, '420VTA-000010', 1, NULL, '2025-10-16 14:05:49'),
(18, 18, '420VTA-000018', 1, NULL, '2025-10-17 15:41:50'),
(19, 18, '420VTA-000018', 1, NULL, '2025-10-17 15:46:25'),
(20, 18, '420VTA-000018', 1, NULL, '2025-10-17 15:48:44'),
(21, 18, '420VTA-000018', 1, NULL, '2025-10-17 15:51:04'),
(22, 18, '420VTA-000018', 1, NULL, '2025-10-17 16:12:29'),
(23, 18, '420VTA-000018', 1, NULL, '2025-10-17 16:15:30'),
(24, 15, '420VTA-000015', 1, NULL, '2025-10-17 16:27:32'),
(25, 18, '420VTA-000018', 1, NULL, '2025-10-20 20:33:59'),
(26, 19, '420VTA-000019', 1, NULL, '2025-11-12 15:04:57');

-- --------------------------------------------------------

--
-- Table structure for table `receipt_settings`
--

CREATE TABLE `receipt_settings` (
  `id` int(11) NOT NULL DEFAULT 1,
  `exchange_rate` decimal(10,4) DEFAULT 18.5000,
  `default_delivery_fee` decimal(10,2) DEFAULT 100.00,
  `default_eta` varchar(100) DEFAULT '60-90 minutes',
  `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `receipt_settings`
--

INSERT INTO `receipt_settings` (`id`, `exchange_rate`, `default_delivery_fee`, `default_eta`, `last_updated`) VALUES
(1, 17.0000, 0.00, '60 min', '2025-10-04 13:38:24');

-- --------------------------------------------------------

--
-- Table structure for table `reg`
--

CREATE TABLE `reg` (
  `id` int(11) NOT NULL,
  `region_name` varchar(255) NOT NULL,
  `parentOf` int(11) DEFAULT NULL,
  `dfee` varchar(255) DEFAULT NULL,
  `added_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reg`
--

INSERT INTO `reg` (`id`, `region_name`, `parentOf`, `dfee`, `added_by`) VALUES
(1, 'Puerto Vallarta Centro', NULL, NULL, 1),
(2, 'Zona Hotelera Norte', NULL, NULL, 1),
(3, 'Zona Hotelera Sur', NULL, NULL, 1),
(4, 'Nuevo Vallarta', NULL, NULL, 1),
(5, 'Marina Vallarta', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(32) NOT NULL,
  `name` varchar(255) NOT NULL,
  `admin?` enum('yes','no') DEFAULT 'no',
  `added_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `name`, `admin?`, `added_by`) VALUES
(1, 'admin', '0192023a7bbd73250516f069df18b500', 'System Administrator', 'yes', NULL),
(2, 'manager1', '0795151defba7a4b5dfa89170de46277', 'Carlos Rodriguez', 'yes', 1),
(3, 'staff1', 'de9bf5643eabf80f4a56fda3bbb84483', 'Maria Lopez', 'no', 1),
(4, 'inventory1', 'ffa092562a523e4ef5c61b9388b5446a', 'Jose Martinez', 'no', 2),
(5, 'cashier1', '84c8137f06fd53b0636e0818f3954cdb', 'Ana Garcia', 'no', 2),
(6, 'bajubadity', 'b341418fb3ee3a74af40009c4aac4312', 'Wanda Gates', 'yes', 1),
(7, 'demo', '25d55ad283aa400af464c76d713c07ad', 'demo user', 'no', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(32) NOT NULL,
  `role` tinyint(4) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`id`, `name`, `email`, `password`, `role`) VALUES
(1, 'John Smith', 'john.smith@email.com', '25d55ad283aa400af464c76d713c07ad', 0),
(2, 'Sarah Johnson', 'sarah.j@email.com', '25d55ad283aa400af464c76d713c07ad', 0),
(3, 'Mike Wilson', 'mike.w@email.com', '25d55ad283aa400af464c76d713c07ad', 0),
(4, 'Lisa Brown', 'lisa.brown@email.com', '25d55ad283aa400af464c76d713c07ad', 0),
(5, 'David Davis', 'david.d@email.com', '25d55ad283aa400af464c76d713c07ad', 0),
(6, 'staffi', 'staff@email.com', 'cc03e747a6afbbcbf8be7668acfebee5', 0),
(7, 'Staff User', 'staff@test.com', 'de9bf5643eabf80f4a56fda3bbb84483', 0),
(8, 'Sales Team', 'sales@test.com', '0ad80eb119d9bf7775aa23786b05b391', 1),
(9, 'Delivery Team', 'delivery@test.com', '6e5edd0c1a1acf48192850bf3ce85e33', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_parentOf` (`parentOf`),
  ADD KEY `idx_added_by` (`added_by`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `cart_ibfk_1` (`user_id`);

--
-- Indexes for table `cat`
--
ALTER TABLE `cat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `added_by` (`added_by`),
  ADD KEY `parentOf` (`parentOf`);

--
-- Indexes for table `grp`
--
ALTER TABLE `grp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `added_by` (`added_by`),
  ADD KEY `parentOf` (`parentOf`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`movie_id`),
  ADD KEY `cat_id` (`cat_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `region_id` (`region_id`),
  ADD KEY `added_by` (`added_by`),
  ADD KEY `idx_brand_id` (`brand_id`);

--
-- Indexes for table `ordere`
--
ALTER TABLE `ordere`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client_number` (`client_number`);

--
-- Indexes for table `receipt_log`
--
ALTER TABLE `receipt_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_receipt_id` (`receipt_id`);

--
-- Indexes for table `receipt_settings`
--
ALTER TABLE `receipt_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reg`
--
ALTER TABLE `reg`
  ADD PRIMARY KEY (`id`),
  ADD KEY `added_by` (`added_by`),
  ADD KEY `parentOf` (`parentOf`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `added_by` (`added_by`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brand`
--
ALTER TABLE `brand`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cat`
--
ALTER TABLE `cat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `grp`
--
ALTER TABLE `grp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `movie_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ordere`
--
ALTER TABLE `ordere`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `receipt_log`
--
ALTER TABLE `receipt_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `reg`
--
ALTER TABLE `reg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE CASCADE;

--
-- Constraints for table `cat`
--
ALTER TABLE `cat`
  ADD CONSTRAINT `cat_ibfk_1` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `cat_ibfk_2` FOREIGN KEY (`parentOf`) REFERENCES `cat` (`id`);

--
-- Constraints for table `grp`
--
ALTER TABLE `grp`
  ADD CONSTRAINT `grp_ibfk_1` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `grp_ibfk_2` FOREIGN KEY (`parentOf`) REFERENCES `grp` (`id`);

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`),
  ADD CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `movies` (`movie_id`);

--
-- Constraints for table `movies`
--
ALTER TABLE `movies`
  ADD CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`),
  ADD CONSTRAINT `movies_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `grp` (`id`),
  ADD CONSTRAINT `movies_ibfk_3` FOREIGN KEY (`region_id`) REFERENCES `reg` (`id`),
  ADD CONSTRAINT `movies_ibfk_4` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `reg`
--
ALTER TABLE `reg`
  ADD CONSTRAINT `reg_ibfk_1` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `reg_ibfk_2` FOREIGN KEY (`parentOf`) REFERENCES `reg` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
