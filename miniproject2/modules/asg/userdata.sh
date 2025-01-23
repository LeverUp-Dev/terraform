#!/bin/bash

sudo dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel

sudo systemctl enable --now httpd

cat << \EOF > /var/www/html/index.php
<?php
// 데이터베이스 연결 설정
$servername = "${db_address}";
$username = "${db_username}";
$password = "${db_password}";
$dbname = "PhoneBookDB";

// MySQL 연결 생성
$conn = new mysqli($servername, $username, $password, $dbname);

// 연결 확인
if ($conn->connect_error) {
    die("연결 실패: " . $conn->connect_error);
}

// SQL 쿼리 실행
$sql = "SELECT ContactID, Name, PhoneNumber, DATE_FORMAT(CreatedAt, '%Y-%m-%d %H:%i:%s') AS CreatedAt FROM Contacts ORDER BY CreatedAt DESC";
$result = $conn->query($sql);

// HTML 출력 시작
echo "<!DOCTYPE html>
<html lang='ko'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>전화기록부</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f4f4f4; }
        body { font-family: Arial, sans-serif; margin: 20px; }
    </style>
</head>
<body>
    <h1>전화기록부</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>전화번호</th>
                <th>등록일</th>
            </tr>
        </thead>
        <tbody>";

// 결과 출력
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>{$row['ContactID']}</td>
                <td>{$row['Name']}</td>
                <td>{$row['PhoneNumber']}</td>
                <td>{$row['CreatedAt']}</td>
              </tr>";
    }
} else {
    echo "<tr><td colspan='4'>데이터가 없습니다.</td></tr>";
}

// HTML 출력 종료
echo "      </tbody>
    </table>
</body>
</html>";

// 연결 종료
$conn->close();
?>
EOF