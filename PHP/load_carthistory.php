<?php
error_reporting(0);
include_once ("dbconnect.php");
$receiptid = $_POST['orderid'];

$sql = "SELECT tbl_products.prid, tbl_products.prname, tbl_products.prprice, tbl_products.prqty, tbl_carthistory.qty FROM tbl_products INNER JOIN tbl_carthistory ON tbl_carthistory.prid = tbl_products.prid WHERE  tbl_carthistory.orderid = '$receiptid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["prid"] = $row["prid"];
        $cartlist["prname"] = $row["prname"];
        $cartlist["prprice"] = $row["prprice"];
        $cartlist["qty"] = $row["qty"];
        $cartlist['picture'] = '/s270964/FishMarket/images/' . $row['picture'];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>