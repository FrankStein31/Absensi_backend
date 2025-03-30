<?php
include 'koneksi.php';

header('Content-Type: application/json');

$nik = isset($_POST['nik']) ? $_POST['nik'] : '';
$nip = isset($_POST['nip']) ? $_POST['nip'] : '';

if (empty($nik) || empty($nip)) {
    echo json_encode([
        "success" => false,
        "message" => "NIK dan NIP harus diisi"
    ]);
    exit();
}

$query = "SELECT id, nama, nik, nip, jabatan, lokasikerja_id, foto FROM datasatpam WHERE nik = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $nik);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    if ($nip === $user['nip']) {
        // Get location info
        $query_location = "SELECT lk.nama_lokasikerja, lk.latitude, lk.longitude, lk.radius, u.nama_ultg, up.nama_upt 
                           FROM lokasikerja lk 
                           JOIN ultg u ON lk.ultg_id = u.id 
                           JOIN upt up ON u.upt_id = up.id 
                           WHERE lk.id = ?";
        $stmt_location = $conn->prepare($query_location);
        $stmt_location->bind_param("i", $user['lokasikerja_id']);
        $stmt_location->execute();
        $location = $stmt_location->get_result()->fetch_assoc();
        
        echo json_encode([
            "success" => true,
            "message" => "Login berhasil",
            "data" => [
                "id" => $user['id'],
                "nama" => $user['nama'],
                "nik" => $user['nik'],
                "nip" => $user['nip'],
                "jabatan" => $user['jabatan'],
                "foto" => $user['foto'],
                "lokasikerja" => [
                    "id" => $user['lokasikerja_id'],
                    "nama" => $location['nama_lokasikerja'],
                    "ultg" => $location['nama_ultg'],
                    "upt" => $location['nama_upt'],
                    "latitude" => $location['latitude'],
                    "longitude" => $location['longitude'],
                    "radius" => $location['radius']
                ]
            ]
        ]);
        
        $stmt_location->close();
    } else {
        echo json_encode([
            "success" => false,
            "message" => "NIP salah"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "NIK tidak terdaftar"
    ]);
}

$stmt->close();
$conn->close();
?>