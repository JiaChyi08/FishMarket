<?php

$servername = "localhost";

$username = "lowtancq_fishmarketadmin";

$password = "_OwS&}7*}8xr";

$dbname = "lowtancq_fishmarketdb";



$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {

die("Connection failed: " . $conn->connect_error);

}

?>
