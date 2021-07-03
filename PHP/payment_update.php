<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-Tp-gZbtwyTtGZWD2jnu1Xw');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){ //payment success
        
        $sqlcart = "SELECT prid,qty FROM tbl_carts WHERE email = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $prid = $row["prid"];
            $qty = $row["qty"]; //cart qty
            $sqlinsertcarthistory = "INSERT INTO tbl_carthistory(email,orderid,prid,qty) VALUES ('$userid','$receiptid','$prid','$qty')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM tbl_products WHERE prid = '$prid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prqty = $rowp["prqty"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prqty - $qty; //quantity in store - quantity ordered by user
                    $sqlupdatequantity = "UPDATE tbl_products SET prqty = '$newquantity' WHERE prid = '$prid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqlinsertpurchased = "INSERT INTO tbl_purchased(orderid,email,paid,status) VALUES('$receiptid','$userid', '$amount','paid')";
       $sqldeletecart = "DELETE FROM tbl_carts WHERE email='$userid'";
       
       
        $stmt = $conn->prepare($sqlinsertpurchased);
        $stmt->execute();
        $stmtdel = $conn->prepare($sqldeletecart);
        $stmtdel->execute();
    }
        echo '<br><br><body><div><h2><br><br><center>Your Receipt</center>
     </h1>
     <table border=1 width=80% align=center>
     <tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td>
     <td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press back button to return to your app</center></p></div></body>';
    } 
    else 
    {
    echo 'Payment Failed!';
    }
}

?>