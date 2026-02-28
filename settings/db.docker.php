<?php
/**
 * Database connection for Docker environment.
 * Reads credentials from environment variables.
 * Copy to db.php for local dev, or use as-is in Docker (see Dockerfile).
 */
$host = getenv('DB_HOST') ?: 'db';
$user = getenv('DB_USER') ?: 'vallarta';
$pass = getenv('DB_PASS') ?: 'vallarta';
$name = getenv('DB_NAME') ?: 'vallarta';

$con = new mysqli($host, $user, $pass, $name);

if ($con->connect_errno) {
    echo "Failed to connect to MySQL: " . $con->connect_error;
    exit();
}
?>
