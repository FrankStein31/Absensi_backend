-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 17, 2025 at 02:46 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `si_absensi`
--

-- --------------------------------------------------------

--
-- Table structure for table `absensi`
--

CREATE TABLE `absensi` (
  `id` int(11) NOT NULL,
  `satpam_id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `shift` enum('P','S','M','L') DEFAULT NULL,
  `jam_masuk` time DEFAULT NULL,
  `jam_keluar` time DEFAULT '00:00:00',
  `latitude_masuk` decimal(10,6) DEFAULT NULL,
  `longitude_masuk` decimal(10,6) DEFAULT NULL,
  `latitude_keluar` decimal(10,6) DEFAULT NULL,
  `longitude_keluar` decimal(10,6) DEFAULT NULL,
  `status` enum('hadir','terlambat','izin','sakit','alpha') DEFAULT 'hadir',
  `keterangan` text DEFAULT NULL,
  `keterangan_pulang_awal` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `absensi`
--

INSERT INTO `absensi` (`id`, `satpam_id`, `tanggal`, `shift`, `jam_masuk`, `jam_keluar`, `latitude_masuk`, `longitude_masuk`, `latitude_keluar`, `longitude_keluar`, `status`, `keterangan`, `keterangan_pulang_awal`, `created_at`, `updated_at`) VALUES
(3, 1, '2025-03-31', 'S', '17:55:46', '00:00:00', '-7.744701', '112.177540', NULL, NULL, 'terlambat', '', NULL, '2025-03-31 10:55:46', '2025-03-31 10:55:46'),
(5, 1, '2025-03-30', 'P', '17:55:46', '00:00:00', '-7.744701', '112.177540', NULL, NULL, 'hadir', '', NULL, '2025-03-31 10:55:46', '2025-05-26 15:57:58'),
(6, 7, '2025-05-25', 'S', '23:05:13', '00:00:00', NULL, NULL, NULL, NULL, 'hadir', NULL, NULL, '2025-05-26 16:05:56', '2025-05-26 16:05:56'),
(7, 1, '2025-05-26', 'S', '17:55:46', '00:00:00', '-7.744701', '112.177540', NULL, NULL, 'hadir', '', NULL, '2025-03-31 10:55:46', '2025-06-07 07:11:19'),
(11, 2, '2025-06-19', 'S', '19:35:50', '19:56:20', '-7.946409', '112.617332', '-7.946398', '112.617324', 'terlambat', '', NULL, '2025-06-19 12:35:50', '2025-06-19 12:56:20'),
(17, 1, '2025-07-17', 'P', '10:05:43', '10:05:53', '-8.099251', '112.135840', '-8.099251', '112.135840', 'terlambat', '', 'anu ini coba dulu ya', '2025-07-17 03:05:43', '2025-07-17 03:05:53'),
(18, 1, '2025-07-17', 'S', '19:30:27', '19:30:33', '-8.099350', '112.135886', '-8.099350', '112.135886', 'terlambat', '', 'anu ini', '2025-07-17 12:30:27', '2025-07-17 12:30:33'),
(19, 1, '2025-07-12', 'P', '07:31:07', '14:31:07', NULL, NULL, NULL, NULL, 'hadir', NULL, NULL, '2025-07-17 12:32:30', '2025-07-17 12:32:30');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `datasatpam`
--

CREATE TABLE `datasatpam` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `kode_satpam` varchar(255) DEFAULT NULL,
  `nip` varchar(255) NOT NULL,
  `nik` varchar(255) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `nama` varchar(255) NOT NULL,
  `pekerjaan` enum('Satpam') DEFAULT 'Satpam',
  `status` enum('PKWT','PKWTT') DEFAULT NULL,
  `no_pkwt_pkwtt` varchar(255) DEFAULT NULL,
  `kontrak` varchar(255) DEFAULT NULL,
  `terhitung_mulai_tugas` date DEFAULT NULL,
  `jabatan` enum('Komandan Regu','Anggota') DEFAULT NULL,
  `lokasikerja_id` bigint(20) UNSIGNED DEFAULT NULL,
  `wilayah_kerja` varchar(255) DEFAULT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') DEFAULT NULL,
  `tempat_lahir` varchar(255) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `usia` int(11) DEFAULT NULL,
  `warga_negara` enum('WNI','WNA') DEFAULT 'WNI',
  `agama` varchar(255) DEFAULT NULL,
  `no_hp` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `kelurahan` varchar(255) DEFAULT NULL,
  `kecamatan` varchar(255) DEFAULT NULL,
  `kabupaten` varchar(255) DEFAULT NULL,
  `provinsi` varchar(255) DEFAULT NULL,
  `negara` varchar(255) DEFAULT NULL,
  `nama_ibu` varchar(255) DEFAULT NULL,
  `no_kontak_darurat` varchar(255) DEFAULT NULL,
  `nama_kontak_darurat` varchar(255) DEFAULT NULL,
  `nama_ahli_waris` varchar(255) DEFAULT NULL,
  `tempat_lahir_ahli_waris` varchar(255) DEFAULT NULL,
  `tanggal_lahir_ahli_waris` date DEFAULT NULL,
  `hub_ahli_waris` varchar(255) DEFAULT NULL,
  `status_nikah` enum('TK','K','K1','K2','K3','K4') DEFAULT NULL,
  `jumlah_anak` int(11) DEFAULT NULL,
  `npwp` varchar(255) DEFAULT NULL,
  `nama_bank` varchar(255) DEFAULT NULL,
  `no_rek` varchar(255) DEFAULT NULL,
  `nama_pemilik_rek` varchar(255) DEFAULT NULL,
  `no_dplk` varchar(255) DEFAULT NULL,
  `pend_terakhir` varchar(255) DEFAULT NULL,
  `sertifikasi_satpam` enum('Gada Pratama','Gada Madya','Gada Utama') DEFAULT NULL,
  `no_reg_kta` varchar(255) DEFAULT NULL,
  `no_kta` varchar(255) DEFAULT NULL,
  `polda` varchar(255) DEFAULT NULL,
  `polres` varchar(255) DEFAULT NULL,
  `no_bpjs_kesehatan` varchar(255) DEFAULT NULL,
  `no_bpjs_ketenagakerjaan` varchar(255) DEFAULT NULL,
  `ukuran_baju` enum('S','M','L','XL','XXL') DEFAULT NULL,
  `ukuran_celana` int(11) DEFAULT 30,
  `ukuran_sepatu` int(11) DEFAULT 30,
  `ukuran_topi` int(11) DEFAULT 30,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `datasatpam`
--

INSERT INTO `datasatpam` (`id`, `kode_satpam`, `nip`, `nik`, `foto`, `nama`, `pekerjaan`, `status`, `no_pkwt_pkwtt`, `kontrak`, `terhitung_mulai_tugas`, `jabatan`, `lokasikerja_id`, `wilayah_kerja`, `jenis_kelamin`, `tempat_lahir`, `tanggal_lahir`, `usia`, `warga_negara`, `agama`, `no_hp`, `email`, `alamat`, `kelurahan`, `kecamatan`, `kabupaten`, `provinsi`, `negara`, `nama_ibu`, `no_kontak_darurat`, `nama_kontak_darurat`, `nama_ahli_waris`, `tempat_lahir_ahli_waris`, `tanggal_lahir_ahli_waris`, `hub_ahli_waris`, `status_nikah`, `jumlah_anak`, `npwp`, `nama_bank`, `no_rek`, `nama_pemilik_rek`, `no_dplk`, `pend_terakhir`, `sertifikasi_satpam`, `no_reg_kta`, `no_kta`, `polda`, `polres`, `no_bpjs_kesehatan`, `no_bpjs_ketenagakerjaan`, `ukuran_baju`, `ukuran_celana`, `ukuran_sepatu`, `ukuran_topi`, `created_at`, `updated_at`) VALUES
(1, 'SAT0001', '12345', '12345', 'foto_satpam/1748747578_SAT0001.jpg', 'MISBACHUL HUDA', 'Satpam', 'PKWTT', '017/PKWTT-AMP/VII/2023', 'jatin', '2025-03-28', 'Anggota', 1, 'Kota Malang', 'Laki-laki', 'Malang', '2000-01-08', 25, 'WNI', 'Islam', '082333546365', 'huda@gmail.com', 'JL. DIPONEGORO NO. 2, RT. 2/2', 'JUNREJO', 'JUNREJO', 'Kota Batu', 'JAWA TIMUR', 'Indonesia', 'Lasemii', '081249213511', 'Sri Wijayanti', 'Sri Wijayanti', 'Malang', '2000-01-05', 'Istri', 'K3', 3, '231234', 'Mandiri', '1150006824272', 'EDY PURWITO', '1002301298308', 'SMA', 'Gada Pratama', '13.13.887.054', '2861/KTASATPAM-GP/II/2024/Ditbinmas', 'Polda Jawa Timur', 'Kota Batu', '8022429420', '1134336385', 'M', 30, 40, 55, '2025-03-30 04:07:02', '2025-05-31 20:12:58'),
(2, 'SAT0002', '54321', '54321', '1748161625_2.jpg', 'frankie steinlie', 'Satpam', NULL, NULL, NULL, NULL, 'Anggota', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '08883866931', 'frankie.steinlie@gmail.com', 'medan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, 'SAT0003', '123456', '123456', '1743322483_1.jpg', 'M. MISBAH', 'Satpam', 'PKWTT', '018/PKWTT-AMP/VII/2023', 'jatin', '2025-03-28', 'Anggota', 1, 'Kota Malang', 'Laki-laki', 'Malang', '2000-01-08', 25, 'WNI', 'Islam', '082333546366', 'misbah@gmail.com', 'JL. DIPONEGORO NO. 2, RT. 2/2', 'JUNREJO', 'JUNREJO', 'Kota Batu', 'JAWA TIMUR', 'Indonesia', 'Lasemii', '081249213511', 'Sri Wijayanti', 'Sri Wijayanti', 'Malang', '2000-01-05', 'Istri', 'K3', 3, '324234', 'Mandiri', '1150006824279', 'EDY PURWITO', '1002301298309', 'SMA', 'Gada Pratama', '13.13.887.056', '2866/KTASATPAM-GP/II/2024/Ditbinmas', 'Polda Jawa Timur', 'Kota Batu', '8022429421', '1134336386', 'M', 30, 40, 55, '2025-03-30 04:07:02', '2025-05-27 20:14:33'),
(15, 'SAT3501', '2309245002', '3502162509840003', 'foto_satpam/1749477000_6846e68898aba.png', 'Arifin', 'Satpam', 'PKWTT', '235/PKWTT-AMP/VIII/2023', 'Jatim', '2023-09-01', 'Anggota', 7, 'Kota Madiun', 'Laki-laki', 'Ponorogo', '1984-09-25', 40, 'WNI', 'Islam', '085655862538', 'arifin489125@gmail.com', 'Dsn. Lengkong, Rt. 1/4', 'Jatigedong', 'Ploso', 'Jombang', 'Jawa Timur', 'Indonesia', 'Musarofah', '085607040208', 'Pujianti', 'Pujianti', 'Madiun', '1987-07-18', 'Istri', 'K1', 12, '423833391621000', 'Mandiri', '1710000651441', 'Arifin', '1002301300526', 'SMK', 'Gada Pratama', '13.16.887.109', '2916/KTASATPAM-GP/II/2024/Ditbinmas', 'Jawa Timur', 'Kota Madiun', '15003587498', '1036744042', 'L', 34, 33, 57, '2025-06-08 23:50:00', '2025-06-12 02:37:47'),
(16, 'SAT8991', '2231730068', '3571090008493', 'foto_satpam/1749625368_68492a18287e4.png', 'Intan Dwi Septiani', 'Satpam', 'PKWT', '222/PKWT-AMP/VIII/2023', 'Jatim', '2023-09-01', 'Anggota', 9, 'Kota Kediri', 'Perempuan', 'Kediri', '2003-09-13', 21, NULL, 'Islam', '0895630599223', 'intandwi1309@gmail.com', 'kediri', 'banjaran', 'banjaran', 'Kediri', 'Jawa Timur', 'Indonesia', 'Rini', '089876543', 'Rini', 'Rini', 'Kediri', '1987-07-18', 'Ibu', 'TK', 0, '42383339198765', 'BRI', '34569987612345678', 'Intan Dwi', '098765432345', 'SMA', 'Gada Pratama', '13.16.887.110', '2025/KTASATPAM-GP/II/2024/Ditbinmas', 'Jawa Timur', 'Kota Kediri', '150035878764', '1036744356', 'S', 27, NULL, 45, '2025-06-10 17:02:48', '2025-06-10 17:02:48'),
(18, 'SAT6156', '230924546', '34567890654323', 'foto_satpam/1750255005_SAT6156.png', 'Rumah', 'Satpam', 'PKWT', '298/PKWTT-AMP/VIII/2023', 'Jatim', '2023-09-01', 'Komandan Regu', 8, 'Kota Kediri', 'Perempuan', 'Kediri', '2003-09-13', 21, 'WNI', 'Islam', '97989', 'intandwisept13@gmail.com', 'banjaran gg 2', 'banjaran', 'banjaran', 'Kediri', 'Jawa Timur', 'Indonesia', 'Rini', '085807444616', 'Rini', 'Rini', 'Kediri', '1987-07-15', 'Ibu', 'TK', 0, '4238333919845', 'Bca', '34569989876543', 'Intan Dwi', '098765432323', 'SMA', 'Gada Madya', '13.16.887.135', '2087/KTASATPAM-GP/II/2024/Ditbinmas', 'Jawa Timur', 'Kota Kediri', '15003587870u', '1036744876', 'S', 27, 37, 40, '2025-06-10 21:24:25', '2025-06-17 23:56:45'),
(19, 'SAT3267', '12345678', '09876543234567', 'foto_satpam/1751536471_SAT3267.jpg', 'Intan Dwi Septiani', 'Satpam', 'PKWTT', '123/PKWTT-AMP/VIII/2023', 'Jatim', '2025-06-02', 'Anggota', 8, 'Kota Kediri', 'Perempuan', 'Kediri', '2016-06-07', 9, 'WNI', 'Islam', '9798908610', 'intandwi01@gmail.com', 'banjaran gg 2', 'banjaran', 'Kota', 'Kediri', 'Jawa Timur', 'Indonesia', 'Musarofah', '085807444616', 'Pujianti', 'Pujianti', 'Madiun', '2007-03-14', 'Ibu', 'K', 0, '09876543234', 'Mandiri', '098765234567', 'Intan Dwi', '23456543', 'SMK', 'Gada Pratama', '13.13.887.653', '2011/KTASATPAM-GP/II/2024/Ditbinmas', 'Jawa Timur', 'Kota Kediri', '15003587870876', '2345789098', 'M', 34, NULL, 44, '2025-06-16 00:04:10', '2025-07-03 02:54:31'),
(20, 'STPM268', '1234512312', '12345123124', 'foto_satpam/1751538639_STPM268.jpg', 'dsf', 'Satpam', 'PKWT', '2', 'jatin', '2025-07-03', 'Anggota', 1, 'Kota Malang', 'Laki-laki', 'Malang', '2025-07-03', 0, 'WNI', 'Islam', '082333546365', 'frank2ie.steinlie@gmail.com', '22123', 'JUNREJO', 'JUNREJO', 'Kota Batu', 'JAWA TIMUR', 'Indonesia', 'Lasemii', '081249213511', 'Sri Wijayanti', 'Sri Wijayanti', 'Malang', '2025-07-03', 'Istri', 'TK', 3, '098765432343', 'Mandiri', '11500068242793', 'EDY PURWITO', '10023012983093', 'SMA', 'Gada Pratama', '13.13.887.0562', '2866/KTASATPAM-GP/II/2024/Ditbinmas2', 'Polda Jawa Timur', 'Kota Batu', '150035878708763', '23457890983', 'L', 30, 30, 55, '2025-07-03 03:30:39', '2025-07-03 03:30:39');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jadwal`
--

CREATE TABLE `jadwal` (
  `id` int(11) NOT NULL,
  `satpam_id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `shift` enum('P','S','M','L') NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal`
--

INSERT INTO `jadwal` (`id`, `satpam_id`, `tanggal`, `shift`, `keterangan`, `created_at`, `updated_at`) VALUES
(1, 1, '2025-03-31', 'S', NULL, '2025-03-30 07:33:57', '2025-03-31 10:16:16'),
(2, 1, '2025-03-30', 'P', NULL, '2025-05-25 09:30:31', '2025-05-25 09:30:31'),
(3, 1, '2025-05-26', 'S', 'masuk', '2025-05-26 00:54:01', '2025-05-26 08:22:37'),
(4, 1, '2025-05-27', 'M', NULL, '2025-05-26 00:54:01', '2025-05-26 00:54:01'),
(5, 1, '2025-05-28', 'L', NULL, '2025-05-26 00:54:01', '2025-05-26 00:54:01'),
(6, 1, '2025-05-29', 'P', NULL, '2025-05-26 00:54:01', '2025-05-26 00:54:01'),
(7, 1, '2025-05-30', 'S', NULL, '2025-05-26 00:54:01', '2025-05-26 00:54:01'),
(8, 1, '2025-05-31', 'M', NULL, '2025-05-26 00:54:01', '2025-05-26 00:54:01'),
(9, 7, '2025-05-25', 'S', NULL, '2025-05-26 09:04:05', '2025-05-26 09:04:05'),
(10, 7, '2025-05-26', 'M', NULL, '2025-05-26 09:04:05', '2025-05-26 09:04:05'),
(11, 7, '2025-05-27', 'L', NULL, '2025-05-26 09:04:05', '2025-05-26 09:04:05'),
(12, 7, '2025-05-28', 'P', NULL, '2025-05-26 09:04:05', '2025-05-26 09:04:05'),
(13, 7, '2025-05-29', 'S', NULL, '2025-05-26 10:22:52', '2025-05-26 10:22:52'),
(14, 2, '2025-05-27', 'S', NULL, '2025-05-27 09:50:51', '2025-05-27 09:50:51'),
(15, 2, '2025-05-28', 'M', NULL, '2025-05-27 09:51:06', '2025-05-27 09:51:06'),
(16, 2, '2025-05-29', 'L', NULL, '2025-05-27 09:51:34', '2025-05-27 09:51:34'),
(17, 2, '2025-05-30', 'L', NULL, '2025-05-27 09:51:34', '2025-05-27 09:51:34'),
(18, 1, '2025-06-01', 'S', NULL, '2025-06-02 03:24:05', '2025-06-02 03:24:05'),
(19, 1, '2025-06-01', 'M', NULL, '2025-06-02 03:24:05', '2025-06-02 03:24:05'),
(20, 1, '2025-06-02', 'P', NULL, '2025-06-02 03:24:05', '2025-06-02 03:24:05'),
(21, 1, '2025-06-03', 'S', NULL, '2025-06-02 03:24:05', '2025-06-02 03:24:05'),
(22, 1, '2025-06-03', 'M', NULL, '2025-06-02 03:24:05', '2025-06-02 03:24:05'),
(50, 2, '2025-06-19', 'S', NULL, '2025-06-29 08:16:05', '2025-06-29 08:16:05'),
(51, 2, '2025-06-19', 'M', NULL, '2025-06-29 08:16:05', '2025-06-29 08:16:05'),
(52, 2, '2025-06-20', 'S', NULL, '2025-06-29 08:16:05', '2025-06-29 08:16:05'),
(53, 2, '2025-06-29', 'L', NULL, '2025-06-29 08:16:05', '2025-06-29 08:16:05'),
(54, 20, '2025-07-10', 'S', NULL, '2025-07-03 04:07:27', '2025-07-03 04:07:27'),
(55, 20, '2025-07-11', 'S', NULL, '2025-07-03 04:07:27', '2025-07-03 04:07:27'),
(56, 1, '2025-07-10', 'P', NULL, '2025-07-03 04:10:44', '2025-07-03 04:10:44'),
(57, 1, '2025-07-11', 'P', NULL, '2025-07-03 04:10:44', '2025-07-03 04:10:44'),
(58, 1, '2025-07-12', 'P', NULL, '2025-07-03 04:10:44', '2025-07-03 04:10:44'),
(59, 20, '2025-07-12', 'S', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(60, 2, '2025-07-10', 'P', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(61, 2, '2025-07-10', 'S', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(62, 2, '2025-07-11', 'P', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(63, 2, '2025-07-11', 'S', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(64, 2, '2025-07-12', 'P', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(65, 2, '2025-07-12', 'S', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45'),
(66, 1, '2025-07-16', 'M', NULL, '2025-07-16 15:12:25', '2025-07-16 15:12:25'),
(67, 1, '2025-07-17', 'P', NULL, '2025-07-16 23:30:45', '2025-07-16 23:30:45'),
(68, 1, '2025-07-17', 'S', NULL, '2025-07-17 12:29:59', '2025-07-17 12:29:59'),
(69, 2, '2025-07-12', 'M', NULL, '2025-07-03 04:10:45', '2025-07-03 04:10:45');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lokasikerja`
--

CREATE TABLE `lokasikerja` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `kode_loker` varchar(255) DEFAULT NULL,
  `nama_lokasikerja` varchar(255) NOT NULL,
  `ultg_id` bigint(20) UNSIGNED NOT NULL,
  `latitude` decimal(10,6) NOT NULL,
  `longitude` decimal(10,6) NOT NULL,
  `radius` int(11) NOT NULL COMMENT 'Radius dalam meter',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lokasikerja`
--

INSERT INTO `lokasikerja` (`id`, `kode_loker`, `nama_lokasikerja`, `ultg_id`, `latitude`, `longitude`, `radius`, `created_at`, `updated_at`) VALUES
(1, 'LOK0001', 'GI 150KV LAWANG', 1, '-8.099390', '112.135940', 100, '2025-03-30 03:41:39', '2025-03-30 03:41:43'),
(2, 'LOK0002', 'GI GULUK-GULUK', 2, '-7.946278', '112.617388', 100, '2025-03-30 03:42:29', '2025-03-30 03:42:32'),
(6, 'LOK9323', 'sampangsasa', 2, '1.000000', '1.000000', 151, '2025-05-26 09:52:11', '2025-06-07 00:53:41'),
(7, 'LOK8886', 'GI 150kV & GI 70kV Manisrejo', 5, '-7.640358', '111.477771', 100, '2025-06-08 23:24:11', '2025-06-08 23:24:11'),
(8, 'LOK0450', 'GI 150KV & GI 70KV BANARAN', 6, '-7.818613', '112.023743', 100, '2025-06-08 23:26:39', '2025-06-08 23:26:39'),
(9, 'LOK1867', 'Kampus 2', 9, '-7.802433', '111.979264', 100, '2025-06-10 16:46:54', '2025-06-17 14:32:30');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_03_16_114842_buat_tabel_upt', 1),
(5, '2025_03_16_115757_buat_tabel_ultg', 2),
(6, '2025_03_16_115923_buat_tabel_lokasikerja', 3),
(7, '2025_03_18_150541_buat_tabel_dtsatpam', 4),
(8, '2025_03_25_151931_remove_latitude_longitude_radius_from_datasatpam', 5),
(9, '2024_05_15_create_validasi_laporan_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengajuan`
--

CREATE TABLE `pengajuan` (
  `id` int(11) NOT NULL,
  `satpam_id` bigint(20) UNSIGNED NOT NULL,
  `tanggal_pengajuan` datetime NOT NULL DEFAULT current_timestamp(),
  `jenis_pengajuan` enum('izin','sakit','cuti','pulang_cepat') NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `alasan` text NOT NULL,
  `bukti_foto` varchar(255) DEFAULT NULL,
  `status` enum('pending','disetujui','ditolak') NOT NULL DEFAULT 'pending',
  `catatan_admin` varchar(255) DEFAULT '-',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengajuan`
--

INSERT INTO `pengajuan` (`id`, `satpam_id`, `tanggal_pengajuan`, `jenis_pengajuan`, `tanggal_mulai`, `tanggal_selesai`, `alasan`, `bukti_foto`, `status`, `catatan_admin`, `created_at`, `updated_at`) VALUES
(2, 2, '2025-07-04 12:10:18', 'izin', '2025-07-04', '2025-07-04', 'ada acara', 'http://127.0.0.1/absensi/uploads_bukti_pengajuan/6867623ae7b99_h3.jpg', 'pending', '-', '2025-07-04 05:10:18', '2025-07-04 05:42:52'),
(4, 2, '2025-07-04 12:50:19', 'izin', '2025-07-04', '2025-07-05', 'coba', 'http://127.0.0.1/absensi/uploads_bukti_pengajuan/68676b9bb09d2_w3.jpg', 'pending', '-', '2025-07-04 05:50:19', '2025-07-04 05:50:19'),
(6, 1, '2025-07-17 19:03:26', 'sakit', '2025-07-16', '2025-07-16', 'anu ini sakit pak', '', 'pending', '-', '2025-07-17 12:03:26', '2025-07-17 12:03:26');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ultg`
--

CREATE TABLE `ultg` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `kode_ultg` varchar(255) DEFAULT NULL,
  `nama_ultg` varchar(255) NOT NULL,
  `upt_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ultg`
--

INSERT INTO `ultg` (`id`, `kode_ultg`, `nama_ultg`, `upt_id`, `created_at`, `updated_at`) VALUES
(1, 'ULTG0001', 'malangsa', 1, '2025-03-30 03:38:52', '2025-05-27 20:16:14'),
(2, 'ULTG0002', 'sampangsa', 2, '2025-03-30 03:39:03', '2025-05-27 20:16:20'),
(3, 'ULTG5092', 'Coba Ultraaa', 3, '2025-05-26 09:40:25', '2025-05-27 20:16:28'),
(4, 'ULTG2211', 'dicpba lagias', 3, '2025-05-26 09:40:41', '2025-05-27 20:16:35'),
(5, 'ULTG9707', 'ULTG Madiun', 4, '2025-06-08 23:19:27', '2025-06-08 23:19:27'),
(6, 'ULTG9849', 'ULTG Kediri', 4, '2025-06-08 23:19:35', '2025-06-08 23:19:35'),
(7, 'ULTG1953', 'ULTG Sampang', 5, '2025-06-08 23:19:43', '2025-06-08 23:19:43'),
(8, 'ULTG9137', 'ULTG Malang', 6, '2025-06-08 23:19:55', '2025-06-08 23:19:55'),
(9, 'ULTG2529', 'PSDKU Kediri', 7, '2025-06-10 15:42:52', '2025-06-10 15:42:52'),
(11, 'ULTG7860', 'ULTG Pacita', 4, '2025-06-18 06:08:32', '2025-06-18 06:09:42');

-- --------------------------------------------------------

--
-- Table structure for table `upt`
--

CREATE TABLE `upt` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `kode_upt` varchar(255) DEFAULT NULL,
  `nama_upt` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `upt`
--

INSERT INTO `upt` (`id`, `kode_upt`, `nama_upt`, `created_at`, `updated_at`) VALUES
(1, 'UPT0001', 'malangg', '2025-03-30 03:38:29', '2025-05-27 20:15:51'),
(2, 'UPT0002', 'gresikk', '2025-03-30 03:38:32', '2025-05-27 20:15:56'),
(3, 'UPT9873', 'coba diubah lagia', '2025-05-26 09:33:27', '2025-05-27 20:16:02'),
(4, 'UPT2336', 'UPT Madiun', '2025-06-08 23:18:59', '2025-06-08 23:18:59'),
(5, 'UPT1891', 'UPT Gresik', '2025-06-08 23:19:06', '2025-06-08 23:19:06'),
(6, 'UPT5221', 'UPT Malang', '2025-06-08 23:19:12', '2025-06-08 23:19:12'),
(7, 'UPT5123', 'Politeknik Negeri Malang', '2025-06-10 15:42:39', '2025-06-10 15:42:39');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2y$12$QkRMXuNYSFbHgB89GhqKJ.D2Uzs9DL.TNaxJQvVHp43GD3oDgi4UG', 'Admin', '2025-05-04 11:07:24', '2025-05-04 11:07:24'),
(2, 'pimpinan', '$2y$12$DN/3aKAcperzdQGCvLmPseKSNCcrx8uOnrgCt49U5zZB8j/Ok1f3e', 'Pimpinan', '2025-05-04 11:07:25', '2025-05-04 11:07:25'),
(1, 'admin', '$2y$12$QkRMXuNYSFbHgB89GhqKJ.D2Uzs9DL.TNaxJQvVHp43GD3oDgi4UG', 'Admin', '2025-05-04 11:07:24', '2025-05-04 11:07:24'),
(2, 'pimpinan', '$2y$12$DN/3aKAcperzdQGCvLmPseKSNCcrx8uOnrgCt49U5zZB8j/Ok1f3e', 'Pimpinan', '2025-05-04 11:07:25', '2025-05-04 11:07:25');

-- --------------------------------------------------------

--
-- Table structure for table `validasi_laporan`
--

CREATE TABLE `validasi_laporan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `upt_id` bigint(20) UNSIGNED NOT NULL,
  `ultg_id` bigint(20) UNSIGNED NOT NULL,
  `lokasikerja_id` bigint(20) UNSIGNED NOT NULL,
  `periode` date NOT NULL,
  `is_validated` tinyint(1) NOT NULL DEFAULT 0,
  `validated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `validasi_laporan`
--

INSERT INTO `validasi_laporan` (`id`, `upt_id`, `ultg_id`, `lokasikerja_id`, `periode`, `is_validated`, `validated_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '2025-05-01', 1, '2025-06-07 00:49:29', '2025-06-07 00:49:29', '2025-06-07 00:49:29');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absensi`
--
ALTER TABLE `absensi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `satpam_id` (`satpam_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `datasatpam`
--
ALTER TABLE `datasatpam`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `datasatpam_nip_unique` (`nip`),
  ADD UNIQUE KEY `datasatpam_nik_unique` (`nik`),
  ADD UNIQUE KEY `datasatpam_no_pkwt_pkwtt_unique` (`no_pkwt_pkwtt`),
  ADD UNIQUE KEY `datasatpam_no_rek_unique` (`no_rek`),
  ADD UNIQUE KEY `datasatpam_no_dplk_unique` (`no_dplk`),
  ADD UNIQUE KEY `datasatpam_no_reg_kta_unique` (`no_reg_kta`),
  ADD UNIQUE KEY `datasatpam_no_kta_unique` (`no_kta`),
  ADD UNIQUE KEY `datasatpam_no_bpjs_kesehatan_unique` (`no_bpjs_kesehatan`),
  ADD UNIQUE KEY `datasatpam_no_bpjs_ketenagakerjaan_unique` (`no_bpjs_ketenagakerjaan`),
  ADD KEY `datasatpam_lokasikerja_id_foreign` (`lokasikerja_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `satpam_id` (`satpam_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lokasikerja`
--
ALTER TABLE `lokasikerja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lokasikerja_ultg_id_foreign` (`ultg_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `pengajuan`
--
ALTER TABLE `pengajuan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `satpam_id` (`satpam_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `ultg`
--
ALTER TABLE `ultg`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ultg_upt_id_foreign` (`upt_id`);

--
-- Indexes for table `upt`
--
ALTER TABLE `upt`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `validasi_laporan`
--
ALTER TABLE `validasi_laporan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `validasi_laporan_upt_id_ultg_id_lokasikerja_id_periode_unique` (`upt_id`,`ultg_id`,`lokasikerja_id`,`periode`),
  ADD KEY `validasi_laporan_ultg_id_foreign` (`ultg_id`),
  ADD KEY `validasi_laporan_lokasikerja_id_foreign` (`lokasikerja_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absensi`
--
ALTER TABLE `absensi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `datasatpam`
--
ALTER TABLE `datasatpam`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jadwal`
--
ALTER TABLE `jadwal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lokasikerja`
--
ALTER TABLE `lokasikerja`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `pengajuan`
--
ALTER TABLE `pengajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ultg`
--
ALTER TABLE `ultg`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `upt`
--
ALTER TABLE `upt`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `validasi_laporan`
--
ALTER TABLE `validasi_laporan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absensi`
--
ALTER TABLE `absensi`
  ADD CONSTRAINT `absensi_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `datasatpam`
--
ALTER TABLE `datasatpam`
  ADD CONSTRAINT `datasatpam_lokasikerja_id_foreign` FOREIGN KEY (`lokasikerja_id`) REFERENCES `lokasikerja` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD CONSTRAINT `jadwal_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lokasikerja`
--
ALTER TABLE `lokasikerja`
  ADD CONSTRAINT `lokasikerja_ultg_id_foreign` FOREIGN KEY (`ultg_id`) REFERENCES `ultg` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pengajuan`
--
ALTER TABLE `pengajuan`
  ADD CONSTRAINT `pengajuan_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ultg`
--
ALTER TABLE `ultg`
  ADD CONSTRAINT `ultg_upt_id_foreign` FOREIGN KEY (`upt_id`) REFERENCES `upt` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `validasi_laporan`
--
ALTER TABLE `validasi_laporan`
  ADD CONSTRAINT `validasi_laporan_lokasikerja_id_foreign` FOREIGN KEY (`lokasikerja_id`) REFERENCES `lokasikerja` (`id`),
  ADD CONSTRAINT `validasi_laporan_ultg_id_foreign` FOREIGN KEY (`ultg_id`) REFERENCES `ultg` (`id`),
  ADD CONSTRAINT `validasi_laporan_upt_id_foreign` FOREIGN KEY (`upt_id`) REFERENCES `upt` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
