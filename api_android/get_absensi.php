<?php
include 'koneksi.php';

header('Content-Type: application/json');

$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';
$bulan = isset($_POST['bulan']) ? $_POST['bulan'] : date('m');
$tahun = isset($_POST['tahun']) ? $_POST['tahun'] : date('Y');

if (empty($satpam_id)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam harus diisi"
    ]);
    exit();
}

// Ambil data satpam
$query_satpam = "SELECT id, nama, jabatan FROM datasatpam WHERE id = ?";
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

// Ambil riwayat absensi satpam
$query = "SELECT a.* 
          FROM absensi a
          WHERE a.satpam_id = ? 
          AND MONTH(a.tanggal) = ? 
          AND YEAR(a.tanggal) = ?
          ORDER BY a.tanggal DESC, a.created_at DESC";
$stmt = $conn->prepare($query);
$stmt->bind_param("iii", $satpam_id, $bulan, $tahun);
$stmt->execute();
$result = $stmt->get_result();

$absensi = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Hitung durasi kerja
        $durasi = "";
        if (!empty($row['jam_masuk']) && !empty($row['jam_keluar'])) {
            $masuk = strtotime($row['tanggal'] . ' ' . $row['jam_masuk']);
            $keluar = strtotime($row['tanggal'] . ' ' . $row['jam_keluar']);
            
            // Handling untuk shift malam yang melewati tengah malam
            if ($keluar < $masuk) {
                $keluar = strtotime('+1 day', $keluar);
            }
            
            $diff_seconds = $keluar - $masuk;
            $hours = floor($diff_seconds / 3600);
            $minutes = floor(($diff_seconds % 3600) / 60);
            
            $durasi = sprintf("%02d:%02d", $hours, $minutes);
        }
        
        // Tentukan shift jika tidak ada di jadwal
        $shift = $row['shift'] ?? "-";
        
        $absensi[] = [
            "id" => $row['id'],
            "tanggal" => $row['tanggal'],
            "jam_masuk" => $row['jam_masuk'],
            "jam_keluar" => $row['jam_keluar'],
            "status" => $row['status'],
            "shift" => $shift,
            "durasi" => $durasi,
            "keterangan" => $row['keterangan'],
            "created_at" => $row['created_at']
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

// Statistik absensi bulan ini
$stats = [
    "total" => count($absensi),
    "hadir" => 0,
    "terlambat" => 0,
    "izin" => 0,
    "sakit" => 0,
    "alpha" => 0
];

foreach ($absensi as $a) {
    if (isset($stats[$a['status']])) {
        $stats[$a['status']]++;
    }
}

echo json_encode([
    "success" => true,
    "message" => "Data absensi berhasil diambil",
    "data" => [
        "satpam" => $satpam,
        "bulan" => $bulan,
        "tahun" => $tahun,
        "absensi" => $absensi,
        "shift_info" => $shift_info,
        "statistik" => $stats
    ]
]);

$stmt->close();
$conn->close();
?> 