/*
SQLyog Enterprise
MySQL - 8.0.30 : Database - si_absensi
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`si_absensi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `si_absensi`;

/*Table structure for table `absensi` */

DROP TABLE IF EXISTS `absensi`;

CREATE TABLE `absensi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `satpam_id` bigint unsigned NOT NULL,
  `tanggal` date NOT NULL,
  `shift` enum('P','S','M','L') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `jam_masuk` time DEFAULT NULL,
  `jam_keluar` time DEFAULT '00:00:00',
  `latitude_masuk` decimal(10,6) DEFAULT NULL,
  `longitude_masuk` decimal(10,6) DEFAULT NULL,
  `latitude_keluar` decimal(10,6) DEFAULT NULL,
  `longitude_keluar` decimal(10,6) DEFAULT NULL,
  `status` enum('hadir','terlambat','izin','sakit','alpha') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'hadir',
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `satpam_id` (`satpam_id`),
  CONSTRAINT `absensi_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `absensi` */

insert  into `absensi`(`id`,`satpam_id`,`tanggal`,`shift`,`jam_masuk`,`jam_keluar`,`latitude_masuk`,`longitude_masuk`,`latitude_keluar`,`longitude_keluar`,`status`,`keterangan`,`created_at`,`updated_at`) values 
(3,1,'2025-03-31','S','17:55:46','00:00:00',-7.744701,112.177540,NULL,NULL,'terlambat','','2025-03-31 17:55:46','2025-03-31 17:55:46'),
(5,1,'2025-03-30','P','17:55:46','00:00:00',-7.744701,112.177540,NULL,NULL,'hadir','','2025-03-31 17:55:46','2025-05-26 22:57:58'),
(6,7,'2025-05-25','S','23:05:13','00:00:00',NULL,NULL,NULL,NULL,'hadir',NULL,'2025-05-26 23:05:56','2025-05-26 23:05:56'),
(7,1,'2025-05-26','S','17:55:46','00:00:00',-7.744701,112.177540,NULL,NULL,'hadir','','2025-03-31 17:55:46','2025-06-07 14:11:19'),
(11,2,'2025-06-19','S','19:35:50','19:56:20',-7.946409,112.617332,-7.946398,112.617324,'terlambat','','2025-06-19 19:35:50','2025-06-19 19:56:20');

/*Table structure for table `cache` */

DROP TABLE IF EXISTS `cache`;

CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `cache` */

/*Table structure for table `cache_locks` */

DROP TABLE IF EXISTS `cache_locks`;

CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `cache_locks` */

/*Table structure for table `datasatpam` */

DROP TABLE IF EXISTS `datasatpam`;

CREATE TABLE `datasatpam` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_satpam` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nik` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `foto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pekerjaan` enum('Satpam') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Satpam',
  `status` enum('PKWT','PKWTT') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_pkwt_pkwtt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `kontrak` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `terhitung_mulai_tugas` date DEFAULT NULL,
  `jabatan` enum('Komandan Regu','Anggota') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lokasikerja_id` bigint unsigned DEFAULT NULL,
  `wilayah_kerja` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempat_lahir` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `usia` int DEFAULT NULL,
  `warga_negara` enum('WNI','WNA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'WNI',
  `agama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_hp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alamat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `kelurahan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `kecamatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `kabupaten` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `provinsi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `negara` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_ibu` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_kontak_darurat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_kontak_darurat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_ahli_waris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempat_lahir_ahli_waris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tanggal_lahir_ahli_waris` date DEFAULT NULL,
  `hub_ahli_waris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_nikah` enum('TK','K','K1','K2','K3','K4') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `jumlah_anak` int DEFAULT NULL,
  `npwp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_bank` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_rek` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_pemilik_rek` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_dplk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pend_terakhir` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sertifikasi_satpam` enum('Gada Pratama','Gada Madya','Gada Utama') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_reg_kta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_kta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `polda` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `polres` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_bpjs_kesehatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_bpjs_ketenagakerjaan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ukuran_baju` enum('S','M','L','XL','XXL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ukuran_celana` int DEFAULT '30',
  `ukuran_sepatu` int DEFAULT '30',
  `ukuran_topi` int DEFAULT '30',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `datasatpam_nip_unique` (`nip`),
  UNIQUE KEY `datasatpam_nik_unique` (`nik`),
  UNIQUE KEY `datasatpam_no_pkwt_pkwtt_unique` (`no_pkwt_pkwtt`),
  UNIQUE KEY `datasatpam_no_rek_unique` (`no_rek`),
  UNIQUE KEY `datasatpam_no_dplk_unique` (`no_dplk`),
  UNIQUE KEY `datasatpam_no_reg_kta_unique` (`no_reg_kta`),
  UNIQUE KEY `datasatpam_no_kta_unique` (`no_kta`),
  UNIQUE KEY `datasatpam_no_bpjs_kesehatan_unique` (`no_bpjs_kesehatan`),
  UNIQUE KEY `datasatpam_no_bpjs_ketenagakerjaan_unique` (`no_bpjs_ketenagakerjaan`),
  KEY `datasatpam_lokasikerja_id_foreign` (`lokasikerja_id`),
  CONSTRAINT `datasatpam_lokasikerja_id_foreign` FOREIGN KEY (`lokasikerja_id`) REFERENCES `lokasikerja` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `datasatpam` */

insert  into `datasatpam`(`id`,`kode_satpam`,`nip`,`nik`,`foto`,`nama`,`pekerjaan`,`status`,`no_pkwt_pkwtt`,`kontrak`,`terhitung_mulai_tugas`,`jabatan`,`lokasikerja_id`,`wilayah_kerja`,`jenis_kelamin`,`tempat_lahir`,`tanggal_lahir`,`usia`,`warga_negara`,`agama`,`no_hp`,`email`,`alamat`,`kelurahan`,`kecamatan`,`kabupaten`,`provinsi`,`negara`,`nama_ibu`,`no_kontak_darurat`,`nama_kontak_darurat`,`nama_ahli_waris`,`tempat_lahir_ahli_waris`,`tanggal_lahir_ahli_waris`,`hub_ahli_waris`,`status_nikah`,`jumlah_anak`,`npwp`,`nama_bank`,`no_rek`,`nama_pemilik_rek`,`no_dplk`,`pend_terakhir`,`sertifikasi_satpam`,`no_reg_kta`,`no_kta`,`polda`,`polres`,`no_bpjs_kesehatan`,`no_bpjs_ketenagakerjaan`,`ukuran_baju`,`ukuran_celana`,`ukuran_sepatu`,`ukuran_topi`,`created_at`,`updated_at`) values 
(1,'SAT0001','12345','12345','foto_satpam/1748747578_SAT0001.jpg','MISBACHUL HUDA','Satpam','PKWTT','017/PKWTT-AMP/VII/2023','jatin','2025-03-28','Anggota',1,'Kota Malang','Laki-laki','Malang','2000-01-08',25,'WNI','Islam','082333546365','huda@gmail.com','JL. DIPONEGORO NO. 2, RT. 2/2','JUNREJO','JUNREJO','Kota Batu','JAWA TIMUR','Indonesia','Lasemii','081249213511','Sri Wijayanti','Sri Wijayanti','Malang','2000-01-05','Istri','K3',3,'231234','Mandiri','1150006824272','EDY PURWITO','1002301298308','SMA','Gada Pratama','13.13.887.054','2861/KTASATPAM-GP/II/2024/Ditbinmas','Polda Jawa Timur','Kota Batu','8022429420','1134336385','M',30,40,55,'2025-03-30 11:07:02','2025-06-01 03:12:58'),
(2,'SAT0002','54321','54321','1748161625_2.jpg','frankie steinlie','Satpam',NULL,NULL,NULL,NULL,'Anggota',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'08883866931','frankie.steinlie@gmail.com','medan',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,'SAT0003','123456','123456','1743322483_1.jpg','M. MISBAH','Satpam','PKWTT','018/PKWTT-AMP/VII/2023','jatin','2025-03-28','Anggota',1,'Kota Malang','Laki-laki','Malang','2000-01-08',25,'WNI','Islam','082333546366','misbah@gmail.com','JL. DIPONEGORO NO. 2, RT. 2/2','JUNREJO','JUNREJO','Kota Batu','JAWA TIMUR','Indonesia','Lasemii','081249213511','Sri Wijayanti','Sri Wijayanti','Malang','2000-01-05','Istri','K3',3,'324234','Mandiri','1150006824279','EDY PURWITO','1002301298309','SMA','Gada Pratama','13.13.887.056','2866/KTASATPAM-GP/II/2024/Ditbinmas','Polda Jawa Timur','Kota Batu','8022429421','1134336386','M',30,40,55,'2025-03-30 11:07:02','2025-05-28 03:14:33'),
(15,'SAT3501','2309245002','3502162509840003','foto_satpam/1749477000_6846e68898aba.png','Arifin','Satpam','PKWTT','235/PKWTT-AMP/VIII/2023','Jatim','2023-09-01','Anggota',7,'Kota Madiun','Laki-laki','Ponorogo','1984-09-25',40,'WNI','Islam','085655862538','arifin489125@gmail.com','Dsn. Lengkong, Rt. 1/4','Jatigedong','Ploso','Jombang','Jawa Timur','Indonesia','Musarofah','085607040208','Pujianti','Pujianti','Madiun','1987-07-18','Istri','K1',12,'423833391621000','Mandiri','1710000651441','Arifin','1002301300526','SMK','Gada Pratama','13.16.887.109','2916/KTASATPAM-GP/II/2024/Ditbinmas','Jawa Timur','Kota Madiun','15003587498','1036744042','L',34,33,57,'2025-06-09 06:50:00','2025-06-12 09:37:47'),
(16,'SAT8991','2231730068','3571090008493','foto_satpam/1749625368_68492a18287e4.png','Intan Dwi Septiani','Satpam','PKWT','222/PKWT-AMP/VIII/2023','Jatim','2023-09-01','Anggota',9,'Kota Kediri','Perempuan','Kediri','2003-09-13',21,NULL,'Islam','0895630599223','intandwi1309@gmail.com','kediri','banjaran','banjaran','Kediri','Jawa Timur','Indonesia','Rini','089876543','Rini','Rini','Kediri','1987-07-18','Ibu','TK',0,'42383339198765','BRI','34569987612345678','Intan Dwi','098765432345','SMA','Gada Pratama','13.16.887.110','2025/KTASATPAM-GP/II/2024/Ditbinmas','Jawa Timur','Kota Kediri','150035878764','1036744356','S',27,NULL,45,'2025-06-11 00:02:48','2025-06-11 00:02:48'),
(18,'SAT6156','230924546','34567890654323','foto_satpam/1750255005_SAT6156.png','Rumah','Satpam','PKWT','298/PKWTT-AMP/VIII/2023','Jatim','2023-09-01','Komandan Regu',8,'Kota Kediri','Perempuan','Kediri','2003-09-13',21,'WNI','Islam','97989','intandwisept13@gmail.com','banjaran gg 2','banjaran','banjaran','Kediri','Jawa Timur','Indonesia','Rini','085807444616','Rini','Rini','Kediri','1987-07-15','Ibu','TK',0,'4238333919845','Bca','34569989876543','Intan Dwi','098765432323','SMA','Gada Madya','13.16.887.135','2087/KTASATPAM-GP/II/2024/Ditbinmas','Jawa Timur','Kota Kediri','15003587870u','1036744876','S',27,37,40,'2025-06-11 04:24:25','2025-06-18 06:56:45'),
(19,'SAT3267','12345678','09876543234567','foto_satpam/1751536471_SAT3267.jpg','Intan Dwi Septiani','Satpam','PKWTT','123/PKWTT-AMP/VIII/2023','Jatim','2025-06-02','Anggota',8,'Kota Kediri','Perempuan','Kediri','2016-06-07',9,'WNI','Islam','9798908610','intandwi01@gmail.com','banjaran gg 2','banjaran','Kota','Kediri','Jawa Timur','Indonesia','Musarofah','085807444616','Pujianti','Pujianti','Madiun','2007-03-14','Ibu','K',0,'09876543234','Mandiri','098765234567','Intan Dwi','23456543','SMK','Gada Pratama','13.13.887.653','2011/KTASATPAM-GP/II/2024/Ditbinmas','Jawa Timur','Kota Kediri','15003587870876','2345789098','M',34,NULL,44,'2025-06-16 07:04:10','2025-07-03 09:54:31'),
(20,'STPM268','1234512312','12345123124','foto_satpam/1751538639_STPM268.jpg','dsf','Satpam','PKWT','2','jatin','2025-07-03','Anggota',1,'Kota Malang','Laki-laki','Malang','2025-07-03',0,'WNI','Islam','082333546365','frank2ie.steinlie@gmail.com','22123','JUNREJO','JUNREJO','Kota Batu','JAWA TIMUR','Indonesia','Lasemii','081249213511','Sri Wijayanti','Sri Wijayanti','Malang','2025-07-03','Istri','TK',3,'098765432343','Mandiri','11500068242793','EDY PURWITO','10023012983093','SMA','Gada Pratama','13.13.887.0562','2866/KTASATPAM-GP/II/2024/Ditbinmas2','Polda Jawa Timur','Kota Batu','150035878708763','23457890983','L',30,30,55,'2025-07-03 10:30:39','2025-07-03 10:30:39');

/*Table structure for table `failed_jobs` */

DROP TABLE IF EXISTS `failed_jobs`;

CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `failed_jobs` */

/*Table structure for table `jadwal` */

DROP TABLE IF EXISTS `jadwal`;

CREATE TABLE `jadwal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `satpam_id` bigint unsigned NOT NULL,
  `tanggal` date NOT NULL,
  `shift` enum('P','S','M','L') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `keterangan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `satpam_id` (`satpam_id`),
  CONSTRAINT `jadwal_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `jadwal` */

insert  into `jadwal`(`id`,`satpam_id`,`tanggal`,`shift`,`keterangan`,`created_at`,`updated_at`) values 
(1,1,'2025-03-31','S',NULL,'2025-03-30 14:33:57','2025-03-31 17:16:16'),
(2,1,'2025-03-30','P',NULL,'2025-05-25 16:30:31','2025-05-25 16:30:31'),
(3,1,'2025-05-26','S','masuk','2025-05-26 07:54:01','2025-05-26 15:22:37'),
(4,1,'2025-05-27','M',NULL,'2025-05-26 07:54:01','2025-05-26 07:54:01'),
(5,1,'2025-05-28','L',NULL,'2025-05-26 07:54:01','2025-05-26 07:54:01'),
(6,1,'2025-05-29','P',NULL,'2025-05-26 07:54:01','2025-05-26 07:54:01'),
(7,1,'2025-05-30','S',NULL,'2025-05-26 07:54:01','2025-05-26 07:54:01'),
(8,1,'2025-05-31','M',NULL,'2025-05-26 07:54:01','2025-05-26 07:54:01'),
(9,7,'2025-05-25','S',NULL,'2025-05-26 16:04:05','2025-05-26 16:04:05'),
(10,7,'2025-05-26','M',NULL,'2025-05-26 16:04:05','2025-05-26 16:04:05'),
(11,7,'2025-05-27','L',NULL,'2025-05-26 16:04:05','2025-05-26 16:04:05'),
(12,7,'2025-05-28','P',NULL,'2025-05-26 16:04:05','2025-05-26 16:04:05'),
(13,7,'2025-05-29','S',NULL,'2025-05-26 17:22:52','2025-05-26 17:22:52'),
(14,2,'2025-05-27','S',NULL,'2025-05-27 16:50:51','2025-05-27 16:50:51'),
(15,2,'2025-05-28','M',NULL,'2025-05-27 16:51:06','2025-05-27 16:51:06'),
(16,2,'2025-05-29','L',NULL,'2025-05-27 16:51:34','2025-05-27 16:51:34'),
(17,2,'2025-05-30','L',NULL,'2025-05-27 16:51:34','2025-05-27 16:51:34'),
(18,1,'2025-06-01','S',NULL,'2025-06-02 10:24:05','2025-06-02 10:24:05'),
(19,1,'2025-06-01','M',NULL,'2025-06-02 10:24:05','2025-06-02 10:24:05'),
(20,1,'2025-06-02','P',NULL,'2025-06-02 10:24:05','2025-06-02 10:24:05'),
(21,1,'2025-06-03','S',NULL,'2025-06-02 10:24:05','2025-06-02 10:24:05'),
(22,1,'2025-06-03','M',NULL,'2025-06-02 10:24:05','2025-06-02 10:24:05'),
(50,2,'2025-06-19','S',NULL,'2025-06-29 15:16:05','2025-06-29 15:16:05'),
(51,2,'2025-06-19','M',NULL,'2025-06-29 15:16:05','2025-06-29 15:16:05'),
(52,2,'2025-06-20','S',NULL,'2025-06-29 15:16:05','2025-06-29 15:16:05'),
(53,2,'2025-06-29','L',NULL,'2025-06-29 15:16:05','2025-06-29 15:16:05'),
(54,20,'2025-07-10','S',NULL,'2025-07-03 11:07:27','2025-07-03 11:07:27'),
(55,20,'2025-07-11','S',NULL,'2025-07-03 11:07:27','2025-07-03 11:07:27'),
(56,1,'2025-07-10','P',NULL,'2025-07-03 11:10:44','2025-07-03 11:10:44'),
(57,1,'2025-07-11','P',NULL,'2025-07-03 11:10:44','2025-07-03 11:10:44'),
(58,1,'2025-07-12','P',NULL,'2025-07-03 11:10:44','2025-07-03 11:10:44'),
(59,20,'2025-07-12','S',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45'),
(60,2,'2025-07-10','P',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45'),
(61,2,'2025-07-10','S',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45'),
(62,2,'2025-07-11','P',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45'),
(63,2,'2025-07-11','S',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45'),
(64,2,'2025-07-12','P',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45'),
(65,2,'2025-07-12','S',NULL,'2025-07-03 11:10:45','2025-07-03 11:10:45');

/*Table structure for table `job_batches` */

DROP TABLE IF EXISTS `job_batches`;

CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `job_batches` */

/*Table structure for table `jobs` */

DROP TABLE IF EXISTS `jobs`;

CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `jobs` */

/*Table structure for table `lokasikerja` */

DROP TABLE IF EXISTS `lokasikerja`;

CREATE TABLE `lokasikerja` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_loker` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_lokasikerja` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ultg_id` bigint unsigned NOT NULL,
  `latitude` decimal(10,6) NOT NULL,
  `longitude` decimal(10,6) NOT NULL,
  `radius` int NOT NULL COMMENT 'Radius dalam meter',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lokasikerja_ultg_id_foreign` (`ultg_id`),
  CONSTRAINT `lokasikerja_ultg_id_foreign` FOREIGN KEY (`ultg_id`) REFERENCES `ultg` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `lokasikerja` */

insert  into `lokasikerja`(`id`,`kode_loker`,`nama_lokasikerja`,`ultg_id`,`latitude`,`longitude`,`radius`,`created_at`,`updated_at`) values 
(1,'LOK0001','GI 150KV LAWANG',1,-7.744757,112.177116,100,'2025-03-30 10:41:39','2025-03-30 10:41:43'),
(2,'LOK0002','GI GULUK-GULUK',2,-7.946278,112.617388,100,'2025-03-30 10:42:29','2025-03-30 10:42:32'),
(6,'LOK9323','sampangsasa',2,1.000000,1.000000,151,'2025-05-26 16:52:11','2025-06-07 07:53:41'),
(7,'LOK8886','GI 150kV & GI 70kV Manisrejo',5,-7.640358,111.477771,100,'2025-06-09 06:24:11','2025-06-09 06:24:11'),
(8,'LOK0450','GI 150KV & GI 70KV BANARAN',6,-7.818613,112.023743,100,'2025-06-09 06:26:39','2025-06-09 06:26:39'),
(9,'LOK1867','Kampus 2',9,-7.802433,111.979264,100,'2025-06-10 23:46:54','2025-06-17 21:32:30');

/*Table structure for table `migrations` */

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `migrations` */

insert  into `migrations`(`id`,`migration`,`batch`) values 
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2025_03_16_114842_buat_tabel_upt',1),
(5,'2025_03_16_115757_buat_tabel_ultg',2),
(6,'2025_03_16_115923_buat_tabel_lokasikerja',3),
(7,'2025_03_18_150541_buat_tabel_dtsatpam',4),
(8,'2025_03_25_151931_remove_latitude_longitude_radius_from_datasatpam',5),
(9,'2024_05_15_create_validasi_laporan_table',6);

/*Table structure for table `password_reset_tokens` */

DROP TABLE IF EXISTS `password_reset_tokens`;

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `password_reset_tokens` */

/*Table structure for table `sessions` */

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `sessions` */

/*Table structure for table `ultg` */

DROP TABLE IF EXISTS `ultg`;

CREATE TABLE `ultg` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_ultg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_ultg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `upt_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ultg_upt_id_foreign` (`upt_id`),
  CONSTRAINT `ultg_upt_id_foreign` FOREIGN KEY (`upt_id`) REFERENCES `upt` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `ultg` */

insert  into `ultg`(`id`,`kode_ultg`,`nama_ultg`,`upt_id`,`created_at`,`updated_at`) values 
(1,'ULTG0001','malangsa',1,'2025-03-30 10:38:52','2025-05-28 03:16:14'),
(2,'ULTG0002','sampangsa',2,'2025-03-30 10:39:03','2025-05-28 03:16:20'),
(3,'ULTG5092','Coba Ultraaa',3,'2025-05-26 16:40:25','2025-05-28 03:16:28'),
(4,'ULTG2211','dicpba lagias',3,'2025-05-26 16:40:41','2025-05-28 03:16:35'),
(5,'ULTG9707','ULTG Madiun',4,'2025-06-09 06:19:27','2025-06-09 06:19:27'),
(6,'ULTG9849','ULTG Kediri',4,'2025-06-09 06:19:35','2025-06-09 06:19:35'),
(7,'ULTG1953','ULTG Sampang',5,'2025-06-09 06:19:43','2025-06-09 06:19:43'),
(8,'ULTG9137','ULTG Malang',6,'2025-06-09 06:19:55','2025-06-09 06:19:55'),
(9,'ULTG2529','PSDKU Kediri',7,'2025-06-10 22:42:52','2025-06-10 22:42:52'),
(11,'ULTG7860','ULTG Pacita',4,'2025-06-18 13:08:32','2025-06-18 13:09:42');

/*Table structure for table `upt` */

DROP TABLE IF EXISTS `upt`;

CREATE TABLE `upt` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `kode_upt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nama_upt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `upt` */

insert  into `upt`(`id`,`kode_upt`,`nama_upt`,`created_at`,`updated_at`) values 
(1,'UPT0001','malangg','2025-03-30 10:38:29','2025-05-28 03:15:51'),
(2,'UPT0002','gresikk','2025-03-30 10:38:32','2025-05-28 03:15:56'),
(3,'UPT9873','coba diubah lagia','2025-05-26 16:33:27','2025-05-28 03:16:02'),
(4,'UPT2336','UPT Madiun','2025-06-09 06:18:59','2025-06-09 06:18:59'),
(5,'UPT1891','UPT Gresik','2025-06-09 06:19:06','2025-06-09 06:19:06'),
(6,'UPT5221','UPT Malang','2025-06-09 06:19:12','2025-06-09 06:19:12'),
(7,'UPT5123','Politeknik Negeri Malang','2025-06-10 22:42:39','2025-06-10 22:42:39');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`username`,`password`,`role`,`created_at`,`updated_at`) values 
(1,'admin','$2y$12$QkRMXuNYSFbHgB89GhqKJ.D2Uzs9DL.TNaxJQvVHp43GD3oDgi4UG','Admin','2025-05-04 18:07:24','2025-05-04 18:07:24'),
(2,'pimpinan','$2y$12$DN/3aKAcperzdQGCvLmPseKSNCcrx8uOnrgCt49U5zZB8j/Ok1f3e','Pimpinan','2025-05-04 18:07:25','2025-05-04 18:07:25'),
(1,'admin','$2y$12$QkRMXuNYSFbHgB89GhqKJ.D2Uzs9DL.TNaxJQvVHp43GD3oDgi4UG','Admin','2025-05-04 18:07:24','2025-05-04 18:07:24'),
(2,'pimpinan','$2y$12$DN/3aKAcperzdQGCvLmPseKSNCcrx8uOnrgCt49U5zZB8j/Ok1f3e','Pimpinan','2025-05-04 18:07:25','2025-05-04 18:07:25');

/*Table structure for table `validasi_laporan` */

DROP TABLE IF EXISTS `validasi_laporan`;

CREATE TABLE `validasi_laporan` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `upt_id` bigint unsigned NOT NULL,
  `ultg_id` bigint unsigned NOT NULL,
  `lokasikerja_id` bigint unsigned NOT NULL,
  `periode` date NOT NULL,
  `is_validated` tinyint(1) NOT NULL DEFAULT '0',
  `validated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `validasi_laporan_upt_id_ultg_id_lokasikerja_id_periode_unique` (`upt_id`,`ultg_id`,`lokasikerja_id`,`periode`),
  KEY `validasi_laporan_ultg_id_foreign` (`ultg_id`),
  KEY `validasi_laporan_lokasikerja_id_foreign` (`lokasikerja_id`),
  CONSTRAINT `validasi_laporan_lokasikerja_id_foreign` FOREIGN KEY (`lokasikerja_id`) REFERENCES `lokasikerja` (`id`),
  CONSTRAINT `validasi_laporan_ultg_id_foreign` FOREIGN KEY (`ultg_id`) REFERENCES `ultg` (`id`),
  CONSTRAINT `validasi_laporan_upt_id_foreign` FOREIGN KEY (`upt_id`) REFERENCES `upt` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `validasi_laporan` */

insert  into `validasi_laporan`(`id`,`upt_id`,`ultg_id`,`lokasikerja_id`,`periode`,`is_validated`,`validated_at`,`created_at`,`updated_at`) values 
(1,1,1,1,'2025-05-01',1,'2025-06-07 07:49:29','2025-06-07 07:49:29','2025-06-07 07:49:29');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
