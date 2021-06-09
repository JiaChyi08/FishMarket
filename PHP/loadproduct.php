<?php
include_once("dbconnect.php");
$prname = $_POST['prname'];

if ($prname == "all") {
    $sql = "SELECT * FROM tbl_products ORDER BY prid DESC";
} else {
    $sql = "SELECT * FROM tbl_products WHERE prname LIKE '%$prname%' ORDER BY prid DESC ";
}

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $products["products"] = array();
    while ($row = $result->fetch_assoc()) {
        $productlist['prid'] = $row['prid'];
        $productlist['prname'] = $row['prname'];
        $productlist['prprice'] = $row['prprice'];
        $productlist['prqty'] = $row['prqty'];
        array_push($products['products'], $productlist);
    }
    echo json_encode($products);
} else {
    echo "No Data";
}