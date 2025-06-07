<?php
include 'koneksi.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

try {
    $conn->begin_transaction();

    try {
        $email = isset($_POST['email']) ? $_POST['email'] : '';
        $nip = isset($_POST['nip']) ? $_POST['nip'] : '';
        $nama = isset($_POST['nama']) ? $_POST['nama'] : '';
        $lokasikerja_id = isset($_POST['lokasikerja_id']) ? $_POST['lokasikerja_id'] : null;
        
        if (empty($email) || empty($nip) || empty($nama)) {
            throw new Exception("Email, NIP, dan Nama harus diisi");
        }

        // Periksa apakah Email sudah terdaftar
        $checkEmailQuery = "SELECT email FROM datasatpam WHERE email = ?";
        $stmt = $conn->prepare($checkEmailQuery);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            throw new Exception("Email sudah terdaftar");
        }
        $stmt->close();

        // Periksa apakah NIP sudah terdaftar
        $checkNIPQuery = "SELECT nip FROM datasatpam WHERE nip = ?";
        $stmt = $conn->prepare($checkNIPQuery);
        $stmt->bind_param("s", $nip);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            throw new Exception("NIP sudah terdaftar");
        }
        $stmt->close();

        // Default jabatan adalah Anggota
        $jabatan = "Anggota";

        $query = "INSERT INTO datasatpam (email, nip, nama, jabatan, lokasikerja_id) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("ssssi", $email, $nip, $nama, $jabatan, $lokasikerja_id);
        
        if (!$stmt->execute()) {
            throw new Exception("Gagal melakukan registrasi: " . $conn->error);
        }
        
        $satpam_id = $conn->insert_id;
        $stmt->close();

        $conn->commit();

        echo json_encode([
            "success" => true,
            "message" => "Registrasi berhasil",
            "data" => [
                "id" => $satpam_id,
                "email" => $email,
                "nip" => $nip,
                "nama" => $nama,
                "jabatan" => $jabatan,
                "lokasikerja_id" => $lokasikerja_id
            ]
        ]);

    } catch (Exception $e) {
        $conn->rollback();
        throw $e;
    }

} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?>