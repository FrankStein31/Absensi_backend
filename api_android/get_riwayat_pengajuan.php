<?php
require_once 'koneksi.php';

header('Content-Type: application/json');

$response = array();

try {
    if (!isset($_POST['satpam_id'])) {
        throw new Exception('Parameter satpam_id tidak ditemukan');
    }

    $satpam_id = $_POST['satpam_id'];

    $query = "SELECT * FROM pengajuan WHERE satpam_id = ? ORDER BY tanggal_pengajuan DESC";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $satpam_id);
    
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        $data = array();
        
        while ($row = $result->fetch_assoc()) {
            $data[] = array(
                'id' => $row['id'],
                'jenis_pengajuan' => $row['jenis_pengajuan'],
                'tanggal_mulai' => $row['tanggal_mulai'],
                'tanggal_selesai' => $row['tanggal_selesai'],
                'alasan' => $row['alasan'],
                'status' => $row['status'],
                'bukti_foto' => $row['bukti_foto'],
                'catatan_admin' => $row['catatan_admin']
            );
        }
        
        $response['success'] = true;
        $response['data'] = $data;
    } else {
        throw new Exception('Gagal mengambil data pengajuan');
    }

} catch (Exception $e) {
    $response['success'] = false;
    $response['message'] = $e->getMessage();
}

echo json_encode($response); 