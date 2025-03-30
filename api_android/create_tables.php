<?php
include 'koneksi.php';

// Buat tabel jadwal
$sql_jadwal = "CREATE TABLE IF NOT EXISTS jadwal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    satpam_id BIGINT UNSIGNED NOT NULL,
    tanggal DATE NOT NULL,
    shift ENUM('P', 'S', 'M', 'L') NOT NULL,
    keterangan VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (satpam_id) REFERENCES datasatpam(id) ON DELETE CASCADE
)";

// Buat tabel absensi
$sql_absensi = "CREATE TABLE IF NOT EXISTS absensi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    satpam_id BIGINT UNSIGNED NOT NULL,
    tanggal DATE NOT NULL,
    jam_masuk TIME,
    jam_keluar TIME,
    latitude_masuk DECIMAL(10,6),
    longitude_masuk DECIMAL(10,6),
    latitude_keluar DECIMAL(10,6),
    longitude_keluar DECIMAL(10,6),
    status ENUM('hadir', 'terlambat', 'izin', 'sakit', 'alpha') DEFAULT 'hadir',
    keterangan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (satpam_id) REFERENCES datasatpam(id) ON DELETE CASCADE
)";

if ($conn->query($sql_jadwal) === TRUE) {
    echo "Tabel jadwal berhasil dibuat<br>";
} else {
    echo "Error membuat tabel jadwal: " . $conn->error . "<br>";
}

if ($conn->query($sql_absensi) === TRUE) {
    echo "Tabel absensi berhasil dibuat<br>";
} else {
    echo "Error membuat tabel absensi: " . $conn->error . "<br>";
}

$conn->close();
?> 