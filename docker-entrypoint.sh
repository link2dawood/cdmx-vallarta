#!/bin/bash
set -e

# Generate settings/db.php from environment so the app can connect to the container DB
cat > /var/www/html/settings/db.php << 'DBCONF'
<?php
$host = getenv('DB_HOST') ?: 'db';
$user = getenv('DB_USER') ?: 'vallarta';
$pass = getenv('DB_PASS') ?: 'vallarta';
$name = getenv('DB_NAME') ?: 'vallarta';
$con = new mysqli($host, $user, $pass, $name);
if ($con->connect_errno) {
    echo "Failed to connect to MySQL: " . $con->connect_error;
    exit();
}
DBCONF

exec apache2-foreground
