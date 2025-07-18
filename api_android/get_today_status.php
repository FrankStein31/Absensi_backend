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

// Tentukan shift aktif berdasarkan jadwal yang ada
$current_shift = '';
$jam = intval(date('H'));

// Jika ada jadwal, tentukan shift aktif berdasarkan waktu
if (!empty($jadwal_list)) {
    if ($jam >= 7 && $jam < 15) {
        $current_shift = 'P';
    } elseif ($jam >= 15 && $jam < 23) {
        $current_shift = 'S';
    } else {
        $current_shift = 'M';
    }
    
    // Cek apakah shift aktif ada di jadwal
    $shift_ada_di_jadwal = false;
    foreach ($jadwal_list as $jadwal) {
        if ($jadwal['shift'] == $current_shift) {
            $shift_ada_di_jadwal = true;
            break;
        }
    }
    
    // Jika shift aktif tidak ada di jadwal, ambil shift pertama dari jadwal
    if (!$shift_ada_di_jadwal && !empty($jadwal_list)) {
        $current_shift = $jadwal_list[0]['shift'];
    }
}

// Status untuk shift yang ada di jadwal saja
$shift_status = [];
foreach ($jadwal_list as $jadwal) {
    $shift = $jadwal['shift'];
    $absensi = isset($absensi_list[$shift]) ? $absensi_list[$shift] : null;
    
    $shift_status[$shift] = [
    "check_in" => false,
    "check_out" => false,
    "jam_masuk" => null,
    "jam_keluar" => null,
    "status_kehadiran" => "belum_absen"
];

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

// Jika tidak ada jadwal, pastikan shift_status adalah objek kosong
if (empty($shift_status)) {
    $shift_status = (object)[];
}

// Keterangan shift
$shift_info = [
    "P" => "06.00 - 15.00",
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
if (!empty($current_shift) && isset($shift_status[$current_shift])) {
    $status = array_merge($status, $shift_status[$current_shift]);
}

// Inisialisasi status boleh checkout
$can_check_out = false;

// Hanya proses jika ada shift yang sedang aktif
if (!empty($current_shift) && isset($shift_info[$current_shift])) {
    try {
        // Ambil rentang waktu dari shift_info, contoh: "15.00 - 23.00"
        $time_range = $shift_info[$current_shift];
        
        // Pisahkan jam mulai dan jam selesai
        $times = explode(' - ', $time_range);
        
        // Ambil jam selesai dan ganti titik dengan titik dua, contoh: "23.00" -> "23:00"
        $end_time_str = str_replace('.', ':', $times[1]);

        // Buat objek DateTime untuk waktu sekarang dan waktu selesai shift
        $now = new DateTime();
        $shift_end_time = new DateTime($end_time_str);

        // Kasus khusus untuk shift malam (M) yang melewati tengah malam
        if ($current_shift === 'M' && $now->format('H') < 12) {
            // Jika sekarang adalah jam 00:00 - 07:00, berarti shift berakhir hari ini
        } elseif ($current_shift === 'M') {
            // Jika sekarang adalah jam 23:00, berarti shift berakhir besok
            $shift_end_time->add(new DateInterval('P1D'));
        }

        // Hitung waktu 30 menit sebelum shift berakhir
        $checkout_window_start = (clone $shift_end_time)->modify('-30 minutes');

        // Cek apakah waktu sekarang berada di dalam jendela waktu checkout
        if ($now >= $checkout_window_start && $now <= $shift_end_time) {
            $can_check_out = true;
        }

    } catch (Exception $e) {
        // Jika terjadi error, anggap tidak bisa checkout
        $can_check_out = false;
    }
}

// Tambahkan flag 'can_check_out' ke dalam array status
$status['can_check_out'] = $can_check_out;

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