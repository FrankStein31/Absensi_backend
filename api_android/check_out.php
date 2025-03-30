<?php
include 'koneksi.php';

header('Content-Type: application/json');

$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';
$latitude = isset($_POST['latitude']) ? $_POST['latitude'] : '';
$longitude = isset($_POST['longitude']) ? $_POST['longitude'] : '';
$keterangan = isset($_POST['keterangan']) ? $_POST['keterangan'] : '';

if (empty($satpam_id) || empty($latitude) || empty($longitude)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam, latitude, dan longitude harus diisi"
    ]);
    exit();
}

// Ambil data lokasi kerja satpam
$query_lokasi = "SELECT l.latitude, l.longitude, l.radius, l.nama_lokasikerja
                FROM datasatpam d 
                JOIN lokasikerja l ON d.lokasikerja_id = l.id
                WHERE d.id = ?";
$stmt_lokasi = $conn->prepare($query_lokasi);
$stmt_lokasi->bind_param("i", $satpam_id);
$stmt_lokasi->execute();
$result_lokasi = $stmt_lokasi->get_result();

if ($result_lokasi->num_rows == 0) {
    echo json_encode([
        "success" => false,
        "message" => "Data lokasi kerja tidak ditemukan"
    ]);
    exit();
}

$lokasi = $result_lokasi->fetch_assoc();
$stmt_lokasi->close();

// Hitung jarak antara lokasi satpam dengan lokasi kerja
$distance = calculateDistance(
    floatval($latitude), 
    floatval($longitude), 
    floatval($lokasi['latitude']), 
    floatval($lokasi['longitude'])
);

// Validasi jarak
if ($distance > $lokasi['radius']) {
    echo json_encode([
        "success" => false,
        "message" => "Anda berada di luar area kerja. Jarak Anda " . round($distance) . " meter dari lokasi kerja",
        "data" => [
            "distance" => $distance,
            "lokasi_kerja" => $lokasi['nama_lokasikerja'],
            "radius" => $lokasi['radius']
        ]
    ]);
    exit();
}

// Cek apakah sudah check-in hari ini
$tanggal = date('Y-m-d');
$query = "SELECT * FROM absensi WHERE satpam_id = ? AND tanggal = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("is", $satpam_id, $tanggal);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows == 0) {
    echo json_encode([
        "success" => false,
        "message" => "Anda belum melakukan check-in hari ini"
    ]);
    exit();
}

$absensi = $result->fetch_assoc();

// Cek apakah sudah check-out
if (!empty($absensi['jam_keluar'])) {
    echo json_encode([
        "success" => false,
        "message" => "Anda sudah melakukan check-out hari ini"
    ]);
    exit();
}

// Jam keluar
$jam_keluar = date('H:i:s');

// Update data absensi
$query_update = "UPDATE absensi SET jam_keluar = ?, latitude_keluar = ?, longitude_keluar = ? WHERE id = ?";
$stmt_update = $conn->prepare($query_update);
$stmt_update->bind_param("sddi", $jam_keluar, $latitude, $longitude, $absensi['id']);

if ($stmt_update->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Check-out berhasil",
        "data" => [
            "tanggal" => $tanggal,
            "jam_masuk" => $absensi['jam_masuk'],
            "jam_keluar" => $jam_keluar,
            "status" => $absensi['status'],
            "lokasi" => $lokasi['nama_lokasikerja'],
            "distance" => round($distance, 2)
        ]
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal melakukan check-out: " . $conn->error
    ]);
}

$stmt->close();
$stmt_update->close();
$conn->close();

// Fungsi untuk menghitung jarak antara dua koordinat dalam meter
function calculateDistance($lat1, $lon1, $lat2, $lon2) {
    $earthRadius = 6371000; // Radius bumi dalam meter
    
    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);
    
    $a = sin($dLat/2) * sin($dLat/2) + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) * sin($dLon/2);
    $c = 2 * atan2(sqrt($a), sqrt(1-$a));
    $distance = $earthRadius * $c;
    
    return $distance;
}
?> 