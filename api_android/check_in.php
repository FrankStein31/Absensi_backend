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

// Cek apakah sudah pernah check-in hari ini
$tanggal = date('Y-m-d');
$query_check = "SELECT * FROM absensi WHERE satpam_id = ? AND tanggal = ?";
$stmt_check = $conn->prepare($query_check);
$stmt_check->bind_param("is", $satpam_id, $tanggal);
$stmt_check->execute();
$result_check = $stmt_check->get_result();

if ($result_check->num_rows > 0) {
    $absensi = $result_check->fetch_assoc();
    
    if (!empty($absensi['jam_masuk'])) {
        echo json_encode([
            "success" => false,
            "message" => "Anda sudah melakukan check-in hari ini"
        ]);
        exit();
    }
}
$stmt_check->close();

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

// Jam masuk
$jam_masuk = date('H:i:s');

// Cek status keterlambatan
$status = 'hadir';
$shift = '';

// Ambil jadwal hari ini
$query_jadwal = "SELECT shift FROM jadwal WHERE satpam_id = ? AND tanggal = ?";
$stmt_jadwal = $conn->prepare($query_jadwal);
$stmt_jadwal->bind_param("is", $satpam_id, $tanggal);
$stmt_jadwal->execute();
$result_jadwal = $stmt_jadwal->get_result();

if ($result_jadwal->num_rows > 0) {
    $jadwal = $result_jadwal->fetch_assoc();
    $shift = $jadwal['shift'];
    
    // Cek keterlambatan berdasarkan shift
    $jam_shift = 0;
    switch ($shift) {
        case 'P':
            $jam_shift = 7; // 07:00
            break;
        case 'S':
            $jam_shift = 15; // 15:00
            break;
        case 'M':
            $jam_shift = 23; // 23:00
            break;
    }
    
    $jam_sekarang = intval(date('H'));
    if ($jam_sekarang > $jam_shift && $shift != 'L') {
        $status = 'terlambat';
    }
}
$stmt_jadwal->close();

// Jika belum ada data absensi hari ini, buat baru
if ($result_check->num_rows == 0) {
    $query_insert = "INSERT INTO absensi (satpam_id, tanggal, jam_masuk, latitude_masuk, longitude_masuk, status, keterangan) 
                    VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt_insert = $conn->prepare($query_insert);
    $stmt_insert->bind_param("issddsss", $satpam_id, $tanggal, $jam_masuk, $latitude, $longitude, $status, $keterangan);
    
    if ($stmt_insert->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Check-in berhasil",
            "data" => [
                "tanggal" => $tanggal,
                "jam_masuk" => $jam_masuk,
                "status" => $status,
                "shift" => $shift,
                "lokasi" => $lokasi['nama_lokasikerja'],
                "distance" => round($distance, 2)
            ]
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Gagal melakukan check-in: " . $conn->error
        ]);
    }
    $stmt_insert->close();
} else {
    // Update data absensi yang sudah ada (mungkin sudah di-insert tapi belum ada jam masuk)
    $query_update = "UPDATE absensi SET jam_masuk = ?, latitude_masuk = ?, longitude_masuk = ?, status = ?, keterangan = ? 
                    WHERE satpam_id = ? AND tanggal = ?";
    $stmt_update = $conn->prepare($query_update);
    $stmt_update->bind_param("sddssis", $jam_masuk, $latitude, $longitude, $status, $keterangan, $satpam_id, $tanggal);
    
    if ($stmt_update->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Check-in berhasil",
            "data" => [
                "tanggal" => $tanggal,
                "jam_masuk" => $jam_masuk,
                "status" => $status,
                "shift" => $shift,
                "lokasi" => $lokasi['nama_lokasikerja'],
                "distance" => round($distance, 2)
            ]
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Gagal melakukan check-in: " . $conn->error
        ]);
    }
    $stmt_update->close();
}

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