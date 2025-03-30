<?php
include 'koneksi.php';

header('Content-Type: application/json');

$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';

if (empty($satpam_id)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam harus diisi"
    ]);
    exit();
}

$query = "SELECT ds.*, lk.nama_lokasikerja, lk.latitude, lk.longitude, lk.radius, u.nama_ultg, up.nama_upt 
          FROM datasatpam ds
          LEFT JOIN lokasikerja lk ON ds.lokasikerja_id = lk.id 
          LEFT JOIN ultg u ON lk.ultg_id = u.id 
          LEFT JOIN upt up ON u.upt_id = up.id 
          WHERE ds.id = ?";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $satpam_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $profile = $result->fetch_assoc();
    
    echo json_encode([
        "success" => true,
        "message" => "Data profile berhasil diambil",
        "data" => [
            "id" => $profile['id'],
            "nik" => $profile['nik'],
            "nip" => $profile['nip'],
            "nama" => $profile['nama'],
            "jabatan" => $profile['jabatan'],
            "foto" => $profile['foto'],
            "jenis_kelamin" => $profile['jenis_kelamin'],
            "tempat_lahir" => $profile['tempat_lahir'],
            "tanggal_lahir" => $profile['tanggal_lahir'],
            "usia" => $profile['usia'],
            "no_hp" => $profile['no_hp'],
            "email" => $profile['email'],
            "alamat" => $profile['alamat'],
            "lokasikerja" => [
                "id" => $profile['lokasikerja_id'],
                "nama" => $profile['nama_lokasikerja'],
                "ultg" => $profile['nama_ultg'],
                "upt" => $profile['nama_upt'],
                "latitude" => $profile['latitude'],
                "longitude" => $profile['longitude'],
                "radius" => $profile['radius']
            ]
        ]
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Data satpam tidak ditemukan"
    ]);
}

$stmt->close();
$conn->close();
?>