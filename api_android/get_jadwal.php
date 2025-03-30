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

// Ambil jadwal satpam
$query = "SELECT * FROM jadwal WHERE satpam_id = ? AND MONTH(tanggal) = ? AND YEAR(tanggal) = ? ORDER BY tanggal ASC";
$stmt = $conn->prepare($query);
$stmt->bind_param("iii", $satpam_id, $bulan, $tahun);
$stmt->execute();
$result = $stmt->get_result();

// Ambil jumlah hari dalam bulan
$jumlah_hari = cal_days_in_month(CAL_GREGORIAN, $bulan, $tahun);

// Buat array jadwal selama sebulan
$jadwal = [];
for ($i = 1; $i <= $jumlah_hari; $i++) {
    $tanggal = sprintf("%04d-%02d-%02d", $tahun, $bulan, $i);
    $jadwal[$i] = [
        "tanggal" => $tanggal,
        "shift" => "L", // Default Libur
        "keterangan" => ""
    ];
}

// Isi jadwal yang ada di database
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $tanggal = intval(date('j', strtotime($row['tanggal'])));
        $jadwal[$tanggal] = [
            "tanggal" => $row['tanggal'],
            "shift" => $row['shift'],
            "keterangan" => $row['keterangan']
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

echo json_encode([
    "success" => true,
    "message" => "Data jadwal berhasil diambil",
    "data" => [
        "satpam" => $satpam,
        "bulan" => $bulan,
        "tahun" => $tahun,
        "jadwal" => array_values($jadwal),
        "shift_info" => $shift_info
    ]
]);

$stmt->close();
$conn->close();
?> 