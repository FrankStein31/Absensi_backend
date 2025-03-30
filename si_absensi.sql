/*
SQLyog Enterprise v13.1.1 (64 bit)
MySQL - 8.0.30 : Database - si_absensi
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`si_absensi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `si_absensi`;

/*Table structure for table `absensi` */

DROP TABLE IF EXISTS `absensi`;

CREATE TABLE `absensi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `satpam_id` bigint unsigned NOT NULL,
  `tanggal` date NOT NULL,
  `jam_masuk` time DEFAULT NULL,
  `jam_keluar` time DEFAULT NULL,
  `latitude_masuk` decimal(10,6) DEFAULT NULL,
  `longitude_masuk` decimal(10,6) DEFAULT NULL,
  `latitude_keluar` decimal(10,6) DEFAULT NULL,
  `longitude_keluar` decimal(10,6) DEFAULT NULL,
  `status` enum('hadir','terlambat','izin','sakit','alpha') DEFAULT 'hadir',
  `keterangan` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `satpam_id` (`satpam_id`),
  CONSTRAINT `absensi_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `absensi` */

/*Table structure for table `cache` */

DROP TABLE IF EXISTS `cache`;

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cache` */

/*Table structure for table `cache_locks` */

DROP TABLE IF EXISTS `cache_locks`;

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cache_locks` */

/*Table structure for table `datasatpam` */

DROP TABLE IF EXISTS `datasatpam`;

CREATE TABLE `datasatpam` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nik` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pekerjaan` enum('Satpam') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Satpam',
  `status` enum('PKWT','PKWTT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_pkwt_pkwtt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontrak` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terhitung_mulai_tugas` date DEFAULT NULL,
  `jabatan` enum('Komandan Regu','Anggota') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lokasikerja_id` bigint unsigned DEFAULT NULL,
  `wilayah_kerja` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tempat_lahir` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `usia` int DEFAULT NULL,
  `warga negara` enum('WNI','WNA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `agama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_hp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `kelurahan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kecamatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kabupaten` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provinsi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `negara` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama_ibu` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_kontak_darurat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama_kontak_darurat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama_ahli_waris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tempat_lahir_ahli_waris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_lahir_ahli_waris` date DEFAULT NULL,
  `hub_ahli_waris` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_nikah` enum('TK','K','K1','K2','K3','K4') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jumlah_anak` int DEFAULT NULL,
  `npwp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama_bank` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_rek` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama_pemilik_rek` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_dplk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pend_terakhir` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sertifikasi_satpam` enum('Gada Pratama','Gada Madya','Gada Utama') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_reg_kta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_kta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `polda` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `polres` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_bpjs_kesehatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_bpjs_ketenagakerjaan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ukuran_baju` enum('S','M','L','XL','XXL') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ukuran_celana` int DEFAULT NULL,
  `ukuran sepatu` int DEFAULT NULL,
  `ukuran_topi` int DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `datasatpam` */

insert  into `datasatpam`(`id`,`nip`,`nik`,`foto`,`nama`,`pekerjaan`,`status`,`no_pkwt_pkwtt`,`kontrak`,`terhitung_mulai_tugas`,`jabatan`,`lokasikerja_id`,`wilayah_kerja`,`jenis_kelamin`,`tempat_lahir`,`tanggal_lahir`,`usia`,`warga negara`,`agama`,`no_hp`,`email`,`alamat`,`kelurahan`,`kecamatan`,`kabupaten`,`provinsi`,`negara`,`nama_ibu`,`no_kontak_darurat`,`nama_kontak_darurat`,`nama_ahli_waris`,`tempat_lahir_ahli_waris`,`tanggal_lahir_ahli_waris`,`hub_ahli_waris`,`status_nikah`,`jumlah_anak`,`npwp`,`nama_bank`,`no_rek`,`nama_pemilik_rek`,`no_dplk`,`pend_terakhir`,`sertifikasi_satpam`,`no_reg_kta`,`no_kta`,`polda`,`polres`,`no_bpjs_kesehatan`,`no_bpjs_ketenagakerjaan`,`ukuran_baju`,`ukuran_celana`,`ukuran sepatu`,`ukuran_topi`,`created_at`,`updated_at`) values 
(1,'12345','12345','1743322483_1.jpg','MISBACHUL HUDA','Satpam','PKWTT','017/PKWTT-AMP/VII/2023','jatin','2025-03-28','Anggota',1,'Kota Malang','Laki-laki','Malang','2000-01-08',25,'WNI','Islam','082333546365','email@gmail.com','JL. DIPONEGORO NO. 2, RT. 2/2','JUNREJO','JUNREJO','Kota Batu','JAWA TIMUR','Indonesia','Lasemii','081249213511','Sri Wijayanti','Sri Wijayanti','Malang','2000-01-05','Istri','K3',3,NULL,'Mandiri','1150006824272','EDY PURWITO','1002301298308','SMA','Gada Pratama','13.13.887.054','2861/KTASATPAM-GP/II/2024/Ditbinmas','Polda Jawa Timur','Kota Batu','8022429420','1134336385','M',30,40,55,'2025-03-30 11:07:02','2025-03-30 11:07:05'),
(2,'54321','54321','1743322723_2.jpg','frankie steinlie','Satpam',NULL,NULL,NULL,NULL,'Anggota',2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'08883866931','frankie.steinlie@gmail.com','medann',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `failed_jobs` */

DROP TABLE IF EXISTS `failed_jobs`;

CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `failed_jobs` */

/*Table structure for table `jadwal` */

DROP TABLE IF EXISTS `jadwal`;

CREATE TABLE `jadwal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `satpam_id` bigint unsigned NOT NULL,
  `tanggal` date NOT NULL,
  `shift` enum('P','S','M','L') NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `satpam_id` (`satpam_id`),
  CONSTRAINT `jadwal_ibfk_1` FOREIGN KEY (`satpam_id`) REFERENCES `datasatpam` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `jadwal` */

insert  into `jadwal`(`id`,`satpam_id`,`tanggal`,`shift`,`keterangan`,`created_at`,`updated_at`) values 
(1,1,'2025-03-30','S',NULL,'2025-03-30 14:33:57','2025-03-30 14:55:14');

/*Table structure for table `job_batches` */

DROP TABLE IF EXISTS `job_batches`;

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `job_batches` */

/*Table structure for table `jobs` */

DROP TABLE IF EXISTS `jobs`;

CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `jobs` */

/*Table structure for table `lokasikerja` */

DROP TABLE IF EXISTS `lokasikerja`;

CREATE TABLE `lokasikerja` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nama_lokasikerja` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ultg_id` bigint unsigned NOT NULL,
  `latitude` decimal(10,6) NOT NULL,
  `longitude` decimal(10,6) NOT NULL,
  `radius` int NOT NULL COMMENT 'Radius dalam meter',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lokasikerja_ultg_id_foreign` (`ultg_id`),
  CONSTRAINT `lokasikerja_ultg_id_foreign` FOREIGN KEY (`ultg_id`) REFERENCES `ultg` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `lokasikerja` */

insert  into `lokasikerja`(`id`,`nama_lokasikerja`,`ultg_id`,`latitude`,`longitude`,`radius`,`created_at`,`updated_at`) values 
(1,'GI 150KV LAWANG',1,-7.744757,112.177116,1000,'2025-03-30 10:41:39','2025-03-30 10:41:43'),
(2,'GI GULUK-GULUK',2,-7.744757,112.177116,1000,'2025-03-30 10:42:29','2025-03-30 10:42:32');

/*Table structure for table `migrations` */

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `migrations` */

insert  into `migrations`(`id`,`migration`,`batch`) values 
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2025_03_16_114842_buat_tabel_upt',1),
(5,'2025_03_16_115757_buat_tabel_ultg',2),
(6,'2025_03_16_115923_buat_tabel_lokasikerja',3),
(7,'2025_03_18_150541_buat_tabel_dtsatpam',4),
(8,'2025_03_25_151931_remove_latitude_longitude_radius_from_datasatpam',5);

/*Table structure for table `password_reset_tokens` */

DROP TABLE IF EXISTS `password_reset_tokens`;

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `password_reset_tokens` */

/*Table structure for table `sessions` */

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `sessions` */

/*Table structure for table `ultg` */

DROP TABLE IF EXISTS `ultg`;

CREATE TABLE `ultg` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nama_ultg` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `upt_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ultg_upt_id_foreign` (`upt_id`),
  CONSTRAINT `ultg_upt_id_foreign` FOREIGN KEY (`upt_id`) REFERENCES `upt` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `ultg` */

insert  into `ultg`(`id`,`nama_ultg`,`upt_id`,`created_at`,`updated_at`) values 
(1,'malang',1,'2025-03-30 10:38:52','2025-03-30 10:38:55'),
(2,'sampang',2,'2025-03-30 10:39:03','2025-03-30 10:39:06');

/*Table structure for table `upt` */

DROP TABLE IF EXISTS `upt`;

CREATE TABLE `upt` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nama_upt` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `upt` */

insert  into `upt`(`id`,`nama_upt`,`created_at`,`updated_at`) values 
(1,'malang','2025-03-30 10:38:29','2025-03-30 10:38:35'),
(2,'gresik','2025-03-30 10:38:32','2025-03-30 10:38:38');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
