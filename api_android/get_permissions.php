<?php
include 'koneksi.php';

// Set header sebagai JSON
header('Content-Type: application/json');
// Set timezone
date_default_timezone_set('Asia/Jakarta');

// --- 1. Ambil Parameter dari POST ---
// Ambil ID satpam, serta bulan dan tahun untuk filter
$satpam_id = isset($_POST['satpam_id']) ? $_POST['satpam_id'] : '';
$bulan = isset($_POST['bulan']) ? $_POST['bulan'] : date('m'); // Default bulan ini
$tahun = isset($_POST['tahun']) ? $_POST['tahun'] : date('Y'); // Default tahun ini

// Validasi ID Satpam
if (empty($satpam_id)) {
    echo json_encode([
        "success" => false,
        "message" => "Parameter satpam_id wajib diisi."
    ]);
    exit();
}

// --- 2. Buat dan Eksekusi Query SQL ---
// Query untuk mengambil data dari tabel 'pengajuan'
// difilter berdasarkan satpam_id, bulan, dan tahun dari tanggal_pengajuan
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
        ORDER BY 
            tanggal_pengajuan DESC";

$stmt = $conn->prepare($sql);
if ($stmt === false) {
    // Jika prepare statement gagal
    echo json_encode([
        "success" => false,
        "message" => "Query SQL tidak valid: " . $conn->error
    ]);
    exit();
}

// Bind parameter ke query
$stmt->bind_param("iii", $satpam_id, $bulan, $tahun);

// Eksekusi query
$stmt->execute();
$result = $stmt->get_result();

// --- 3. Format Hasil ke dalam Array ---
$permissions_list = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Tambahkan setiap baris data ke dalam array
        $permissions_list[] = $row;
    }
}

// Tutup statement dan koneksi
$stmt->close();
$conn->close();

// --- 4. Kirim Respons JSON ---
// Cek apakah ada data yang ditemukan
if (empty($permissions_list)) {
    // Jika tidak ada data
    echo json_encode([
        "success" => true, // Operasi berhasil, namun data kosong
        "message" => "Tidak ada data pengajuan untuk periode ini.",
        "data" => [] // Kirim array kosong
    ]);
} else {
    // Jika data ditemukan
    echo json_encode([
        "success" => true,
        "message" => "Data riwayat pengajuan berhasil diambil.",
        "data" => $permissions_list
    ]);
}
?>
