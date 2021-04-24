<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;


require '/home8/lowtancq/public_html/s270964/PHPMailer-master/src/Exception.php';
require '/home8/lowtancq/public_html/s270964/PHPMailer-master/src/PHPMailer.php';
require '/home8/lowtancq/public_html/s270964/PHPMailer-master/src/SMTP.php';

include_once("dbconnect.php");

$email = $_POST['email'];

$password = $_POST['password'];

$passha1 = sha1($password);

$otp = rand(1000,9999);



$sqlregister = "INSERT INTO tbl_user(user_email,password,otp) VALUES('$email','$passha1','$otp')";

if ($conn->query($sqlregister) === TRUE){
echo "success";
sendEmail($otp,$email);
}else{
echo "failed";
}

function sendEmail($otp,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                      //Enable verbose debug output
    $mail->isSMTP();                                               //Send using SMTP
    $mail->Host       = 'mail.lowtancqx.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'mhlfishmarket@lowtancqx.com';                     //SMTP username
    $mail->Password   = 'S3~25}rTI7IO';                               //SMTP password
    $mail->SMTPSecure = 'tls';         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;     

    $from = "mhlfishmarket@lowtancqx.com";
    $to = $email;
    $subject = "From MHL Fresh Fish Market. Please Verify your account";
    $message = "<p>Click the following link to verify your account<br><br><a href='https://lowtancqx.com/s270964/FishMarket/php/verify_account.php?email=".$email."&key=".$otp."'>Click Here to verify your account</a>";
    
    $mail->setFrom($from,"MHL Fresh Fish Market");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}
?>