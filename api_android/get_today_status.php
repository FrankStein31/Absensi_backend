<?php
include 'koneksi.php';

// Set timezone ke Asia/Jakarta
date_default_timezone_set('Asia/Jakarta');

header('Content-Type: application/json');

$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';

if (empty($satpam_id)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam harus diisi"
    ]);
    exit();
}

// Ambil tanggal hari ini
$tanggal = date('Y-m-d');
$jam_sekarang = date('H:i:s');

// Ambil data satpam
$query_satpam = "SELECT ds.*, lk.nama_lokasikerja, lk.latitude, lk.longitude, lk.radius 
                FROM datasatpam ds
                JOIN lokasikerja lk ON ds.lokasikerja_id = lk.id 
                WHERE ds.id = ?";
$stmt_satpam = $conn->prepare($query_satpam);
$stmt_satpam->bind_param("i", $satpam_id);
$stmt_satpam->execute();
$result_satpam = $stmt_satpam->get_result();

if ($result_satpam->num_rows == 0) {
    echo json_encode([
        "success" => false,
        "message" => "Data satpam tidak ditemukan"
    ]);
    exit();
}

$satpam = $result_satpam->fetch_assoc();
$stmt_satpam->close();

// Ambil jadwal hari ini
$query_jadwal = "SELECT * FROM jadwal WHERE satpam_id = ? AND tanggal = ?";
$stmt_jadwal = $conn->prepare($query_jadwal);
$stmt_jadwal->bind_param("is", $satpam_id, $tanggal);
$stmt_jadwal->execute();
$result_jadwal = $stmt_jadwal->get_result();

$jadwal = null;
if ($result_jadwal->num_rows > 0) {
    $jadwal = $result_jadwal->fetch_assoc();
}
$stmt_jadwal->close();

// Ambil absensi hari ini
$query_absensi = "SELECT * FROM absensi WHERE satpam_id = ? AND tanggal = ?";
$stmt_absensi = $conn->prepare($query_absensi);
$stmt_absensi->bind_param("is", $satpam_id, $tanggal);
$stmt_absensi->execute();
$result_absensi = $stmt_absensi->get_result();

$absensi = null;
if ($result_absensi->num_rows > 0) {
    $absensi = $result_absensi->fetch_assoc();
}
$stmt_absensi->close();

// Tentukan status absensi dan jadwal
$status = [
    "check_in" => false,
    "check_out" => false,
    "ada_jadwal" => $jadwal !== null,
    "shift" => $jadwal !== null ? $jadwal['shift'] : "-",
    "jam_masuk" => null,
    "jam_keluar" => null,
    "status_kehadiran" => "belum_absen"
];

if ($absensi !== null) {
    $status["check_in"] = !empty($absensi['jam_masuk']);
    $status["check_out"] = !empty($absensi['jam_keluar']);
    $status["jam_masuk"] = $absensi['jam_masuk'];
    $status["jam_keluar"] = $absensi['jam_keluar'];
    $status["status_kehadiran"] = $absensi['status'];
}

// Keterangan shift
$shift_info = [
    "P" => "07.00 - 15.00",
    "S" => "15.00 - 23.00",
    "M" => "23.00 - 07.00",
    "L" => "Libur"
];

echo json_encode([
    "success" => true,
    "message" => "Data status hari ini berhasil diambil",
    "data" => [
        "tanggal" => $tanggal,
        "waktu_server" => $jam_sekarang,
        "satpam" => [
            "id" => $satpam['id'],
            "nama" => $satpam['nama'],
            "jabatan" => $satpam['jabatan']
        ],
        "lokasi_kerja" => [
            "nama" => $satpam['nama_lokasikerja'],
            "latitude" => $satpam['latitude'],
            "longitude" => $satpam['longitude'],
            "radius" => $satpam['radius']
        ],
        "jadwal" => $jadwal !== null ? [
            "shift" => $jadwal['shift'],
            "keterangan" => $jadwal['keterangan'],
            "jam_kerja" => isset($shift_info[$jadwal['shift']]) ? $shift_info[$jadwal['shift']] : "-"
        ] : null,
        "absensi" => $absensi !== null ? [
            "jam_masuk" => $absensi['jam_masuk'],
            "jam_keluar" => $absensi['jam_keluar'],
            "status" => $absensi['status'],
            "keterangan" => $absensi['keterangan']
        ] : null,
        "status" => $status
    ]
]);

$conn->close();
?> 