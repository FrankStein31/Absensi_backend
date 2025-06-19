<?php
include 'koneksi.php';

// Set timezone ke Asia/Jakarta
date_default_timezone_set('Asia/Jakarta');

header('Content-Type: application/json');

$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';
$latitude = isset($_POST['latitude']) ? $_POST['latitude'] : '';
$longitude = isset($_POST['longitude']) ? $_POST['longitude'] : '';
$keterangan = isset($_POST['keterangan']) ? $_POST['keterangan'] : '';
$bypass = isset($_POST['bypass']) && $_POST['bypass'] == 'true' ? true : false;
$shift = isset($_POST['shift']) ? $_POST['shift'] : '';

// Debug log untuk melihat nilai yang diterima
error_log("Check-in request: satpam_id=$satpam_id, lat=$latitude, lon=$longitude, bypass=$bypass, shift=$shift, time=".date('Y-m-d H:i:s'));

if (empty($satpam_id) || empty($latitude) || empty($longitude) || empty($shift)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam, latitude, longitude, dan shift harus diisi"
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

// Pastikan radius tidak terlalu kecil
if (empty($lokasi['radius']) || $lokasi['radius'] < 50) {
    $lokasi['radius'] = 100; // Default radius minimal 100 meter
    error_log("Radius terlalu kecil, menggunakan nilai default 100 meter");
}

// Update radius untuk sementara (troubleshooting)
$lokasi['radius'] = 1000; // Memberi radius yang lebih besar untuk testing (1 km)

// Debug log untuk lokasi dari database
error_log("Lokasi kerja dari DB: lat={$lokasi['latitude']}, lon={$lokasi['longitude']}, radius={$lokasi['radius']}");

// Hitung jarak dengan metode Haversine sederhana
$distance = calculateDistance(
    $latitude, 
    $longitude, 
    $lokasi['latitude'], 
    $lokasi['longitude']
);

// Debug log untuk hasil perhitungan
error_log("Jarak yang dihitung: $distance meter");

// Cek apakah sudah pernah check-in untuk shift ini hari ini
$tanggal = date('Y-m-d');
$query_check = "SELECT * FROM absensi WHERE satpam_id = ? AND tanggal = ? AND shift = ?";
$stmt_check = $conn->prepare($query_check);
$stmt_check->bind_param("iss", $satpam_id, $tanggal, $shift);
$stmt_check->execute();
$result_check = $stmt_check->get_result();

if ($result_check->num_rows > 0) {
    $absensi = $result_check->fetch_assoc();
    
    if (!empty($absensi['jam_masuk'])) {
        echo json_encode([
            "success" => false,
            "message" => "Anda sudah melakukan check-in untuk shift $shift hari ini"
        ]);
        exit();
    }
}
$stmt_check->close();

// Validasi jarak kecuali jika bypass=true
if ($distance > $lokasi['radius'] && !$bypass) {
    echo json_encode([
        "success" => false,
        "message" => "Anda berada di luar area kerja. Jarak Anda " . round($distance) . " meter dari lokasi kerja",
        "data" => [
            "distance" => round($distance, 2),
            "lokasi_kerja" => $lokasi['nama_lokasikerja'],
            "radius" => $lokasi['radius'],
            "user_lat" => $latitude,
            "user_long" => $longitude,
            "lokasi_lat" => $lokasi['latitude'],
            "lokasi_long" => $lokasi['longitude']
        ]
    ]);
    exit();
}

// Jam masuk
$jam_masuk = date('H:i:s');

// Cek status keterlambatan
$status = 'hadir';

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

// Jika belum ada data absensi hari ini untuk shift ini, buat baru
if ($result_check->num_rows == 0) {
    $query_insert = "INSERT INTO absensi (satpam_id, tanggal, shift, jam_masuk, latitude_masuk, longitude_masuk, status, keterangan) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt_insert = $conn->prepare($query_insert);
    $stmt_insert->bind_param("isssddss", $satpam_id, $tanggal, $shift, $jam_masuk, $latitude, $longitude, $status, $keterangan);
    
    if ($stmt_insert->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Check-in berhasil",
            "data" => [
                "tanggal" => $tanggal,
                "shift" => $shift,
                "jam_masuk" => $jam_masuk,
                "status" => $status,
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
    // Update data absensi yang sudah ada
    $query_update = "UPDATE absensi SET jam_masuk = ?, latitude_masuk = ?, longitude_masuk = ?, status = ?, keterangan = ? 
                    WHERE satpam_id = ? AND tanggal = ? AND shift = ?";
    $stmt_update = $conn->prepare($query_update);
    $stmt_update->bind_param("sddssis", $jam_masuk, $latitude, $longitude, $status, $keterangan, $satpam_id, $tanggal, $shift);
    
    if ($stmt_update->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Check-in berhasil",
            "data" => [
                "tanggal" => $tanggal,
                "shift" => $shift,
                "jam_masuk" => $jam_masuk,
                "status" => $status,
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

// Fungsi untuk menghitung jarak antara dua koordinat dalam meter (versi paling sederhana)
function calculateDistance($lat1, $lon1, $lat2, $lon2) {
    // Pastikan semua nilai adalah float dan valid
    $lat1 = floatval($lat1);
    $lon1 = floatval($lon1);
    $lat2 = floatval($lat2);
    $lon2 = floatval($lon2);
    
    // Debug
    error_log("Calculating distance between: ($lat1, $lon1) and ($lat2, $lon2)");
    
    // Validasi koordinat
    if ($lat1 < -90 || $lat1 > 90 || $lat2 < -90 || $lat2 > 90 || 
        $lon1 < -180 || $lon1 > 180 || $lon2 < -180 || $lon2 > 180) {
        error_log("ERROR: Invalid coordinate values detected!");
        return 99999; // Return nilai besar jika koordinat tidak valid
    }
    
    // Rumus Haversine sederhana
    $earthRadius = 6371; // Radius bumi dalam kilometer
    
    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);
    
    $a = sin($dLat/2) * sin($dLat/2) + 
         cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * 
         sin($dLon/2) * sin($dLon/2);
    $c = 2 * atan2(sqrt($a), sqrt(1-$a));
    
    // Jarak dalam kilometer, dikonversi ke meter
    $distance = $earthRadius * $c * 1000;
    
    error_log("Final distance calculated: $distance meters");
    return $distance;
}
?> 