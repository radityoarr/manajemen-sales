-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 03, 2024 at 12:23 PM
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
-- Database: `db_store`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `lihatPenjualan` (`barang` INT(11))   BEGIN
SELECT * FROM detail_transaksi where id_barang=barang;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lihatTransaksi` (`tgl` DATE)   BEGIN
select * from transaksi where Tanggal_Transaksi=tgl;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lihatTransaksiBarang` (`id_barang` INT(11))   BEGIN
select * from detail_transaksi where id_barang=id_barang;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectTransaksi` ()   BEGIN
SELECT transaksi.id_transaksi,detail_transaksi.id_barang, 
detail_transaksi.Jumlah, detail_transaksi.subtotal
from transaksi JOIN detail_transaksi on transaksi.id_transaksi=detail_transaksi.id_Transaksi
;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Tambah_Barang` (`name` VARCHAR(100), `hrg` INT(11), `stok` INT(11), `expired` DATE)   BEGIN
INSERT INTO barang set
nama_barang=name,
harga_barang=hrg,
stok_barang=stok,
kadaluarsa=expired;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(11) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `harga_barang` int(11) NOT NULL,
  `stok_barang` int(11) NOT NULL,
  `kadaluarsa` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `harga_barang`, `stok_barang`, `kadaluarsa`) VALUES
(1, 'Bimoli 2L', 36800, 21, '2025-01-08'),
(2, 'Buavita 1L', 21900, 29, '2025-02-04'),
(3, 'Frestea 500ml', 5900, 29, '2026-01-20'),
(4, 'Nutella 200g', 31900, 79, '2025-11-23'),
(5, 'Indomie 90g', 3200, 53, '2025-11-27'),
(6, 'Happytos 140g', 9900, 23, '2025-12-22'),
(7, 'Soyjoy 30g', 8400, 100, '2025-10-22'),
(8, 'Rejoice 450ml', 54900, 28, '2026-02-16'),
(9, 'Pillows 100g', 12800, 39, '2026-03-30'),
(10, 'Ultra 250ml', 7100, 36, '2026-01-18'),
(11, 'Happydent 65g', 17500, 50, '2026-04-22'),
(12, 'Good Time 72g', 9500, 40, '2025-09-28'),
(13, 'Pristine 600ml', 5200, 31, '2025-12-28'),
(14, 'Blue Band 200g', 10100, 48, '2025-12-01'),
(15, 'Lux 450ml', 25400, 19, '2025-11-11');

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `before_barang_update` BEFORE UPDATE ON `barang` FOR EACH ROW BEGIN
INSERT INTO log_harga
set id_barang=OLD.id_barang,
harga_baru=new.harga_barang,
harga_lama=old.harga_barang,
waktu_perubahan = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barangterhapus`
--

CREATE TABLE `barangterhapus` (
  `id_barang` int(11) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `harga_barang` int(11) NOT NULL,
  `stok` int(11) NOT NULL,
  `kadaluarsa` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_Transaksi` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `subtotal` int(11) NOT NULL,
  `Jumlah` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_Transaksi`, `id_barang`, `subtotal`, `Jumlah`) VALUES
(1, 1, 110400, 3),
(1, 15, 50800, 2),
(2, 1, 36800, 1),
(3, 2, 65700, 3),
(4, 10, 28400, 4),
(4, 4, 127600, 4),
(4, 6, 29700, 3),
(4, 3, 11800, 2),
(4, 2, 21900, 1),
(4, 5, 3200, 1),
(4, 9, 12800, 1);

--
-- Triggers `detail_transaksi`
--
DELIMITER $$
CREATE TRIGGER `update_stok_tansaksi` AFTER INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
UPDATE barang set
stok_barang=stok_barang-new.Jumlah
where id_barang=new.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_transaksi` AFTER INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
UPDATE transaksi set
Total_Pembelian=Total_Pembelian+new.subtotal
where id_transaksi=new.id_Transaksi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id`, `username`, `password`) VALUES
(1, 'Radityo', '1772f7f93e1f5f2ad7d3c6f195e89f086a280b91b5516515d539a4a871a5aa60'),
(2, 'Mitha', '0f89cf28dad5232e054f07c31bd8f7433bc637beacd0ad4c0763c59b0aa043ab');

-- --------------------------------------------------------

--
-- Table structure for table `keranjang`
--

CREATE TABLE `keranjang` (
  `id` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `harga_barang` int(11) NOT NULL,
  `jumlah_barang` int(11) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_harga`
--

CREATE TABLE `log_harga` (
  `id_log` int(11) NOT NULL,
  `id_barang` int(11) DEFAULT NULL,
  `harga_lama` int(11) DEFAULT NULL,
  `harga_baru` int(11) DEFAULT NULL,
  `waktu_perubahan` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_harga`
--

INSERT INTO `log_harga` (`id_log`, `id_barang`, `harga_lama`, `harga_baru`, `waktu_perubahan`) VALUES
(69, 6, 500, 9900, '2024-06-01 09:40:56'),
(70, 7, 500, 8400, '2024-06-01 09:43:10'),
(71, 12, 3500, 9500, '2024-06-01 09:51:31'),
(72, 13, 500, 5200, '2024-06-01 09:51:59'),
(73, 14, 500, 10100, '2024-06-01 09:52:32'),
(74, 15, 1000, 25400, '2024-06-01 09:54:06'),
(75, 8, 2500, 54900, '2024-06-01 09:55:22'),
(76, 9, 500, 12800, '2024-06-01 09:56:17'),
(77, 10, 500, 7100, '2024-06-01 09:57:16'),
(78, 11, 3000, 17500, '2024-06-01 09:58:34'),
(79, 1, 36800, 36800, '2024-06-01 10:16:51'),
(80, 15, 25400, 25400, '2024-06-01 10:16:52'),
(81, 1, 36800, 36800, '2024-06-01 10:20:09'),
(82, 1, 36800, 36800, '2024-06-01 10:20:51'),
(83, 2, 21900, 21900, '2024-06-01 10:39:41'),
(84, 10, 7100, 7100, '2024-06-01 13:00:35'),
(85, 4, 31900, 31900, '2024-06-01 13:00:35'),
(86, 6, 9900, 9900, '2024-06-01 13:00:35'),
(87, 3, 5900, 5900, '2024-06-01 13:00:35'),
(88, 2, 21900, 21900, '2024-06-01 13:00:35'),
(89, 5, 3200, 3200, '2024-06-01 13:00:35'),
(90, 9, 12800, 12800, '2024-06-01 13:00:35');

-- --------------------------------------------------------

--
-- Table structure for table `tambah_stok`
--

CREATE TABLE `tambah_stok` (
  `id_tambah_stok` int(11) NOT NULL,
  `id_barang` int(11) DEFAULT NULL,
  `stok_tambahan` int(11) DEFAULT NULL,
  `waktu_penambahan` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tambah_stok`
--

INSERT INTO `tambah_stok` (`id_tambah_stok`, `id_barang`, `stok_tambahan`, `waktu_penambahan`) VALUES
(13, 1, 9, '0000-00-00 00:00:00');

--
-- Triggers `tambah_stok`
--
DELIMITER $$
CREATE TRIGGER `after_insert_tambah_stok` AFTER INSERT ON `tambah_stok` FOR EACH ROW BEGIN
UPDATE barang set
stok_barang=stok_barang+new.stok_tambahan
where id_barang=new.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `Total_Pembelian` int(11) NOT NULL,
  `Tanggal_Transaksi` date NOT NULL,
  `id_karyawan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `Total_Pembelian`, `Tanggal_Transaksi`, `id_karyawan`) VALUES
(1, 161200, '2024-06-01', 1),
(2, 36800, '2024-06-01', 1),
(3, 65700, '2024-06-01', 2),
(4, 235400, '2024-06-01', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD KEY `id_Transasksi` (`id_Transaksi`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_harga`
--
ALTER TABLE `log_harga`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `tambah_stok`
--
ALTER TABLE `tambah_stok`
  ADD PRIMARY KEY (`id_tambah_stok`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `keranjang`
--
ALTER TABLE `keranjang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `log_harga`
--
ALTER TABLE `log_harga`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `tambah_stok`
--
ALTER TABLE `tambah_stok`
  MODIFY `id_tambah_stok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`),
  ADD CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_Transaksi`) REFERENCES `transaksi` (`id_transaksi`);

--
-- Constraints for table `log_harga`
--
ALTER TABLE `log_harga`
  ADD CONSTRAINT `log_harga_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `tambah_stok`
--
ALTER TABLE `tambah_stok`
  ADD CONSTRAINT `tambah_stok_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
