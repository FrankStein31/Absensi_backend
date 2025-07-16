<?php
include 'koneksi.php';

// Set timezone ke Asia/Jakarta
date_default_timezone_set('Asia/Jakarta');

header('Content-Type: application/json');

// Enable error reporting untuk debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Validasi parameter yang diterima
$satpam_id = isset($_POST['satpam_id']) ? intval($_POST['satpam_id']) : 0;
$latitude = isset($_POST['latitude']) ? floatval($_POST['latitude']) : 0;
$longitude = isset($_POST['longitude']) ? floatval($_POST['longitude']) : 0;
$shift = isset($_POST['shift']) ? trim($_POST['shift']) : '';
$keterangan_pulang_awal = isset($_POST['keterangan']) ? trim($_POST['keterangan']) : '';

// Debug log untuk melihat nilai yang diterima
error_log("Check-out request: satpam_id=$satpam_id, lat=$latitude, lon=$longitude, shift=$shift, time=" . date('Y-m-d H:i:s'));

// Validasi input
if ($satpam_id <= 0 || $latitude == 0 || $longitude == 0 || empty($shift)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam, latitude, longitude, dan shift harus diisi dengan benar"
    ]);
    exit();
}

try {
    // Ambil data lokasi kerja satpam
    $query_lokasi = "SELECT l.latitude, l.longitude, l.radius, l.nama_lokasikerja
                    FROM datasatpam d 
                    JOIN lokasikerja l ON d.lokasikerja_id = l.id
                    WHERE d.id = ?";
    $stmt_lokasi = $conn->prepare($query_lokasi);
    
    if (!$stmt_lokasi) {
        throw new Exception("Prepare statement failed: " . $conn->error);
    }
    
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

    // Validasi data lokasi kerja
    if (empty($lokasi['latitude']) || empty($lokasi['longitude'])) {
        echo json_encode([
            "success" => false,
            "message" => "Data koordinat lokasi kerja tidak valid"
        ]);
        exit();
    }

    // Pastikan radius tidak terlalu kecil
    if (empty($lokasi['radius']) || $lokasi['radius'] < 50) {
        $lokasi['radius'] = 100; // Default radius minimal 100 meter
        error_log("Radius terlalu kecil, menggunakan nilai default 100 meter");
    }

    // Debug log untuk lokasi dari database
    error_log("Lokasi kerja dari DB: lat={$lokasi['latitude']}, lon={$lokasi['longitude']}, radius={$lokasi['radius']}");

    // Hitung jarak dengan metode Haversine
    $distance = calculateDistance(
        $latitude,
        $longitude,
        $lokasi['latitude'],
        $lokasi['longitude']
    );

    // Debug log untuk hasil perhitungan
    error_log("Jarak yang dihitung: $distance meter");

    // Validasi jarak (bisa disesuaikan untuk testing)
    if ($distance > $lokasi['radius']) {
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

    // Cek apakah sudah check-in untuk shift ini hari ini
    $tanggal = date('Y-m-d');
    $jam_keluar_sekarang = date('H:i:s');

    // Definisikan array shift_info
    $shift_info = [
        "P" => "07:00 - 15:00",
        "S" => "15:00 - 23:00", 
        "M" => "23:00 - 07:00",
        "L" => "Libur"
    ];

    // Validasi shift
    if (!isset($shift_info[$shift]) || $shift == 'L') {
        echo json_encode([
            "success" => false, 
            "message" => "Kode shift tidak valid atau Anda tidak bisa checkout saat libur."
        ]);
        exit();
    }

    // Ambil jam selesai shift
    $time_range = $shift_info[$shift];
    $times = explode(' - ', $time_range);
    $jam_selesai_shift = $times[1] . ':00';

    // Cek data absensi
    $query = "SELECT * FROM absensi WHERE satpam_id = ? AND tanggal = ? AND shift = ?";
    $stmt = $conn->prepare($query);
    
    if (!$stmt) {
        throw new Exception("Prepare statement failed: " . $conn->error);
    }
    
    $stmt->bind_param("iss", $satpam_id, $tanggal, $shift);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 0) {
        echo json_encode([
            "success" => false,
            "message" => "Anda belum melakukan check-in untuk shift $shift hari ini"
        ]);
        exit();
    }

    $absensi = $result->fetch_assoc();

    // Cek apakah sudah check-out
    if (!empty($absensi['jam_keluar']) && $absensi['jam_keluar'] != '00:00:00') {
        echo json_encode([
            "success" => false,
            "message" => "Anda sudah melakukan check-out untuk shift $shift hari ini"
        ]);
        exit();
    }

    // Cek apakah pulang awal
    $is_pulang_awal = ($jam_keluar_sekarang < $jam_selesai_shift);
    
    // Penanganan khusus untuk shift malam
    if ($shift == 'M' && $jam_keluar_sekarang > '12:00:00') {
        $is_pulang_awal = false;
    }

    $keterangan_final = null;

    if ($is_pulang_awal) {
        if (empty($keterangan_pulang_awal)) {
            echo json_encode([
                "success" => false, 
                "message" => "Keterangan wajib diisi karena Anda checkout lebih awal."
            ]);
            exit();
        }
        $keterangan_final = $keterangan_pulang_awal;
    } else {
        // Jika tidak pulang awal, keterangan tetap disimpan jika ada
        if (!empty($keterangan_pulang_awal)) {
            $keterangan_final = $keterangan_pulang_awal;
            error_log("Checkout normal dengan keterangan: '$keterangan_final'");
        } else {
            $keterangan_final = null;
            error_log("Checkout normal tanpa keterangan");
        }
    }

    error_log("Akan update dengan keterangan: " . ($keterangan_final === null ? "NULL" : "'$keterangan_final'"));

    // Update data absensi
    $query_update = "UPDATE absensi SET jam_keluar = ?, latitude_keluar = ?, longitude_keluar = ?, keterangan_pulang_awal = ? WHERE id = ?";
    $stmt_update = $conn->prepare($query_update);
    
    if (!$stmt_update) {
        throw new Exception("Prepare statement failed: " . $conn->error);
    }
    
    $stmt_update->bind_param("sddsi", $jam_keluar_sekarang, $latitude, $longitude, $keterangan_final, $absensi['id']);

    if ($stmt_update->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Check-out berhasil",
            "data" => [
                "tanggal" => $tanggal,
                "shift" => $shift,
                "jam_masuk" => $absensi['jam_masuk'],
                "jam_keluar" => $jam_keluar_sekarang,
                "status" => $absensi['status'],
                "lokasi" => $lokasi['nama_lokasikerja'],
                "distance" => round($distance, 2)
            ]
        ]);
    } else {
        throw new Exception("Gagal melakukan check-out: " . $stmt_update->error);
    }

    $stmt->close();
    $stmt_update->close();

} catch (Exception $e) {
    error_log("Error in check_out.php: " . $e->getMessage());
    echo json_encode([
        "success" => false,
        "message" => "Terjadi kesalahan: " . $e->getMessage()
    ]);
} finally {
    if (isset($conn)) {
        $conn->close();
    }
}

// Fungsi untuk menghitung jarak antara dua koordinat dalam meter
function calculateDistance($lat1, $lon1, $lat2, $lon2)
{
    try {
        // Pastikan semua nilai adalah float dan valid
        $lat1 = floatval($lat1);
        $lon1 = floatval($lon1);
        $lat2 = floatval($lat2);
        $lon2 = floatval($lon2);

        // Debug
        error_log("Calculating distance between: ($lat1, $lon1) and ($lat2, $lon2)");

        // Validasi koordinat
        if (
            $lat1 < -90 || $lat1 > 90 || $lat2 < -90 || $lat2 > 90 ||
            $lon1 < -180 || $lon1 > 180 || $lon2 < -180 || $lon2 > 180
        ) {
            error_log("ERROR: Invalid coordinate values detected!");
            return 99999; // Return nilai besar jika koordinat tidak valid
        }

        // Rumus Haversine
        $earthRadius = 6371; // Radius bumi dalam kilometer

        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);

        $a = sin($dLat / 2) * sin($dLat / 2) +
            cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
            sin($dLon / 2) * sin($dLon / 2);
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        // Jarak dalam kilometer, dikonversi ke meter
        $distance = $earthRadius * $c * 1000;

        error_log("Final distance calculated: $distance meters");
        return $distance;
        
    } catch (Exception $e) {
        error_log("Error in calculateDistance: " . $e->getMessage());
        return 99999;
    }
}
?>