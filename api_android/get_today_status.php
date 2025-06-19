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
$query_jadwal = "SELECT * FROM jadwal WHERE satpam_id = ? AND tanggal = ? ORDER BY FIELD(shift, 'P', 'S', 'M', 'L')";
$stmt_jadwal = $conn->prepare($query_jadwal);
$stmt_jadwal->bind_param("is", $satpam_id, $tanggal);
$stmt_jadwal->execute();
$result_jadwal = $stmt_jadwal->get_result();

$jadwal_list = [];
while ($row = $result_jadwal->fetch_assoc()) {
    $jadwal_list[] = $row;
}
$stmt_jadwal->close();

// Ambil absensi hari ini
$query_absensi = "SELECT * FROM absensi WHERE satpam_id = ? AND tanggal = ? ORDER BY FIELD(shift, 'P', 'S', 'M', 'L')";
$stmt_absensi = $conn->prepare($query_absensi);
$stmt_absensi->bind_param("is", $satpam_id, $tanggal);
$stmt_absensi->execute();
$result_absensi = $stmt_absensi->get_result();

$absensi_list = [];
while ($row = $result_absensi->fetch_assoc()) {
    $absensi_list[$row['shift']] = $row;
}
$stmt_absensi->close();

// Tentukan shift aktif saat ini
$jam = intval(date('H'));
$current_shift = '';
if ($jam >= 7 && $jam < 15) {
    $current_shift = 'P';
} elseif ($jam >= 15 && $jam < 23) {
    $current_shift = 'S';
} else {
    $current_shift = 'M';
}

// Default status untuk setiap shift
$default_shifts = ['P', 'S', 'M'];
$shift_status = [];
foreach ($default_shifts as $s) {
    $shift_status[$s] = [
        "check_in" => false,
        "check_out" => false,
        "jam_masuk" => null,
        "jam_keluar" => null,
        "status_kehadiran" => "belum_absen"
    ];
}

// Update status untuk shift yang ada di jadwal
foreach ($jadwal_list as $jadwal) {
    $shift = $jadwal['shift'];
    $absensi = isset($absensi_list[$shift]) ? $absensi_list[$shift] : null;
    
    if ($absensi !== null) {
        $shift_status[$shift] = [
            "check_in" => !empty($absensi['jam_masuk']),
            "check_out" => !empty($absensi['jam_keluar']) && $absensi['jam_keluar'] != "00:00:00",
            "jam_masuk" => $absensi['jam_masuk'],
            "jam_keluar" => $absensi['jam_keluar'],
            "status_kehadiran" => $absensi['status']
        ];
    }
}

// Keterangan shift
$shift_info = [
    "P" => "07.00 - 15.00",
    "S" => "15.00 - 23.00",
    "M" => "23.00 - 07.00",
    "L" => "Libur"
];

// Status untuk response
$status = [
    "check_in" => false,
    "check_out" => false,
    "ada_jadwal" => !empty($jadwal_list),
    "shift" => $current_shift,
    "jam_masuk" => null,
    "jam_keluar" => null,
    "status_kehadiran" => "belum_absen"
];

// Update status berdasarkan shift aktif
if (isset($shift_status[$current_shift])) {
    $status = array_merge($status, $shift_status[$current_shift]);
}

echo json_encode([
    "success" => true,
    "message" => "Data status hari ini berhasil diambil",
    "data" => [
        "tanggal" => $tanggal,
        "waktu_server" => $jam_sekarang,
        "current_shift" => $current_shift,
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
        "jadwal" => $jadwal_list,
        "shift_status" => $shift_status,
        "shift_info" => $shift_info,
        "status" => $status
    ]
]);

$conn->close();
?> 