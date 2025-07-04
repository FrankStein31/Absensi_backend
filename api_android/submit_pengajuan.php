<?php
require_once 'koneksi.php';

header('Content-Type: application/json');

$response = array();

try {
    // Validasi input
    if (!isset($_POST['satpam_id']) || !isset($_POST['jenis_pengajuan']) || 
        !isset($_POST['tanggal_mulai']) || !isset($_POST['tanggal_selesai']) || 
        !isset($_POST['alasan'])) {
        throw new Exception('Parameter tidak lengkap');
    }

    $satpam_id = $_POST['satpam_id'];
    $jenis_pengajuan = $_POST['jenis_pengajuan'];
    $tanggal_mulai = $_POST['tanggal_mulai'];
    $tanggal_selesai = $_POST['tanggal_selesai'];
    $alasan = $_POST['alasan'];
    $bukti_foto = '';

    // Handle upload foto
    if (isset($_FILES['bukti_foto'])) {
        $file = $_FILES['bukti_foto'];
        $fileName = uniqid() . '_' . $file['name'];
        $targetPath = '../uploads_bukti_pengajuan/' . $fileName;

        // Buat direktori jika belum ada
        if (!file_exists('../uploads_bukti_pengajuan/')) {
            mkdir('../uploads_bukti_pengajuan/', 0777, true);
        }

        if (move_uploaded_file($file['tmp_name'], $targetPath)) {
            $bukti_foto = 'http://127.0.0.1/absensi/uploads_bukti_pengajuan/' . $fileName;
        } else {
            throw new Exception('Gagal upload file');
        }
    }

    // Insert ke database
    $query = "INSERT INTO pengajuan (satpam_id, jenis_pengajuan, tanggal_mulai, tanggal_selesai, alasan, bukti_foto) 
              VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("isssss", $satpam_id, $jenis_pengajuan, $tanggal_mulai, $tanggal_selesai, $alasan, $bukti_foto);

    if ($stmt->execute()) {
        $response['success'] = true;
        $response['message'] = 'Pengajuan berhasil disimpan';
    } else {
        throw new Exception('Gagal menyimpan pengajuan');
    }

} catch (Exception $e) {
    $response['success'] = false;
    $response['message'] = $e->getMessage();
}

echo json_encode($response); 