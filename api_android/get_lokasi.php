<?php
include 'koneksi.php';

header('Content-Type: application/json');

$query = "SELECT l.id, l.nama_lokasikerja, l.latitude, l.longitude, l.radius, u.nama_ultg, up.nama_upt 
            FROM lokasikerja l
            JOIN ultg u ON l.ultg_id = u.id
            JOIN upt up ON u.upt_id = up.id
            ORDER BY l.nama_lokasikerja ASC";

$result = $conn->query($query);

$lokasi = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Format latitude dan longitude dengan 6 desimal
        $formatted_lat = number_format($row['latitude'], 6);
        $formatted_lon = number_format($row['longitude'], 6);
        
        $lokasi[] = [
            "id" => $row['id'],
            "nama" => $row['nama_lokasikerja'],
            "ultg" => $row['nama_ultg'],
            "upt" => $row['nama_upt'],
            "latitude" => $row['latitude'],
            "longitude" => $row['longitude'],
            "formatted_lat" => $formatted_lat,
            "formatted_lon" => $formatted_lon,
            "coords" => "Lat: $formatted_lat, Lon: $formatted_lon",
            "radius" => $row['radius'],
            "radius_formatted" => number_format($row['radius'], 0) . " meter"
        ];
    }
    
    echo json_encode([
        "success" => true,
        "message" => "Data lokasi berhasil diambil",
        "data" => $lokasi
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Data lokasi kosong"
    ]);
}

$conn->close();
?> 