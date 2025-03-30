<?php
include 'koneksi.php';

header('Content-Type: application/json');

$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';
$nama = isset($_POST['nama']) ? $_POST['nama'] : '';
$no_hp = isset($_POST['no_hp']) ? $_POST['no_hp'] : '';
$email = isset($_POST['email']) ? $_POST['email'] : '';
$alamat = isset($_POST['alamat']) ? $_POST['alamat'] : '';

if (empty($satpam_id)) {
    echo json_encode([
        "success" => false,
        "message" => "ID Satpam harus diisi"
    ]);
    exit();
}

// Upload foto jika ada
$foto = null;
if (isset($_FILES['foto']) && $_FILES['foto']['size'] > 0) {
    $target_dir = "../uploads/";
    
    // Buat direktori jika belum ada
    if (!is_dir($target_dir)) {
        mkdir($target_dir, 0755, true);
    }
    
    $imageFileType = strtolower(pathinfo($_FILES["foto"]["name"], PATHINFO_EXTENSION));
    $foto_name = time() . "_" . $satpam_id . "." . $imageFileType;
    $target_file = $target_dir . $foto_name;
    
    // Periksa jenis file
    $allowed_types = ["jpg", "jpeg", "png"];
    if (!in_array($imageFileType, $allowed_types)) {
        echo json_encode([
            "success" => false,
            "message" => "Hanya file JPG, JPEG, dan PNG yang diperbolehkan"
        ]);
        exit();
    }
    
    if (move_uploaded_file($_FILES["foto"]["tmp_name"], $target_file)) {
        $foto = $foto_name;
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Gagal mengupload foto"
        ]);
        exit();
    }
}

// Buat query update sesuai dengan field yang diisi
$query = "UPDATE datasatpam SET ";
$params = [];
$types = "";

if (!empty($nama)) {
    $query .= "nama = ?, ";
    $params[] = $nama;
    $types .= "s";
}

if (!empty($no_hp)) {
    $query .= "no_hp = ?, ";
    $params[] = $no_hp;
    $types .= "s";
}

if (!empty($email)) {
    $query .= "email = ?, ";
    $params[] = $email;
    $types .= "s";
}

if (!empty($alamat)) {
    $query .= "alamat = ?, ";
    $params[] = $alamat;
    $types .= "s";
}

if ($foto !== null) {
    $query .= "foto = ?, ";
    $params[] = $foto;
    $types .= "s";
}

// Hapus koma terakhir
$query = rtrim($query, ", ");
$query .= " WHERE id = ?";
$params[] = $satpam_id;
$types .= "i";

// Jika tidak ada yang diupdate, langsung kembalikan sukses
if (empty($params) || count($params) == 1) {
    echo json_encode([
        "success" => true,
        "message" => "Tidak ada perubahan data"
    ]);
    exit();
}

$stmt = $conn->prepare($query);
$stmt->bind_param($types, ...$params);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Profile berhasil diupdate"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal mengupdate profile: " . $conn->error
    ]);
}

$stmt->close();
$conn->close();
?> 