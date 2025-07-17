<?php
include 'koneksi.php';

// Set header sebagai JSON
header('Content-Type: application/json');
// Set timezone
date_default_timezone_set('Asia/Jakarta');

// --- 1. Ambil Parameter dari POST ---
$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';
$bulan = isset($_POST['bulan']) ? $_POST['bulan'] : date('m');
$tahun = isset($_POST['tahun']) ? $_POST['tahun'] : date('Y');

if (empty($satpam_id)) {
    echo json_encode([
        "success" => false,
        "message" => "Parameter satpam_id wajib diisi."
    ]);
    exit();
}

// --- 2. Buat dan Eksekusi Query SQL ---
$sql = "SELECT 
            id, 
            tanggal_pengajuan, 
            jenis_pengajuan, 
            tanggal_mulai, 
            tanggal_selesai, 
            alasan, 
            bukti_foto, 
            status,
            catatan_admin
        FROM 
            pengajuan 
        WHERE 
            satpam_id = ? 
            AND MONTH(tanggal_pengajuan) = ? 
            AND YEAR(tanggal_pengajuan) = ?
            AND jenis_pengajuan IN ('sakit', 'izin', 'cuti', 'pulang cepat') -- <-- Baris ini ditambahkan
        ORDER BY 
            tanggal_pengajuan DESC";

$stmt = $conn->prepare($sql);
if ($stmt === false) {
    echo json_encode([
        "success" => false,
        "message" => "Query SQL tidak valid: " . $conn->error
    ]);
    exit();
}

$stmt->bind_param("iii", $satpam_id, $bulan, $tahun);
$stmt->execute();
$result = $stmt->get_result();

// --- 3. Format Hasil ke dalam Array ---
$permissions_list = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $permissions_list[] = $row;
    }
}

$stmt->close();
$conn->close();

// --- 4. Kirim Respons JSON ---
if (empty($permissions_list)) {
    echo json_encode([
        "success" => true,
        "message" => "Tidak ada data pengajuan untuk periode ini.",
        "data" => []
    ]);
} else {
    echo json_encode([
        "success" => true,
        "message" => "Data riwayat pengajuan berhasil diambil.",
        "data" => $permissions_list
    ]);
}
?>