<?php
// Đảm bảo output buffer sạch và set header JSON
while (ob_get_level()) {
    ob_end_clean();
}

// Set header trước khi require để tránh output
if (!headers_sent()) {
    header('Content-Type: application/json; charset=utf-8');
}

// Error handler để đảm bảo luôn trả về JSON
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    if (error_reporting() === 0) return false;
    while (ob_get_level()) ob_end_clean();
    die(json_encode(['status' => 'error', 'msg' => 'Lỗi hệ thống: ' . $errstr]));
});

// Exception handler
set_exception_handler(function($exception) {
    while (ob_get_level()) ob_end_clean();
    die(json_encode(['status' => 'error', 'msg' => 'Lỗi: ' . $exception->getMessage()]));
});

use PragmaRX\Google2FA\Google2FA;
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) . '/libs/init.php');
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
die(JsonMsg('error', 'Access Denied'));
}
if (!isset($_POST["csrf_token"])) {
    die(jsonMsg('error', 'CSRF token không được gửi'));
}
if (!isset($_SESSION["csrf_token"])) {
    die(jsonMsg('error', 'CSRF token chưa được tạo trong session'));
}
if ($_POST["csrf_token"] != $_SESSION["csrf_token"]) {
    die(jsonMsg('error', 'CSRF token không khớp'));
}
if($db->site('status_demo') == '1' || $db->site('status_demo') == 1){
        die(JsonMsg('error', 'Đây là trang website demo, bạn không thể thực hiện chức năng này'));
    }
    $username = Anti_xss($_POST['username']);
    $password = Anti_xss($_POST['password']);
    $email = Anti_xss($_POST['email']);

    // Regex patterns
    $emailRegex = '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
    // Tổng độ dài 6-15 ký tự: 1 ký tự đầu + 5-14 ký tự tiếp theo
    $usernameRegex = '/^[a-zA-Z][a-zA-Z0-9_]{5,14}$/';
    $passwordRegex = '/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$/';

    $ipRegister = myip();
   
    // Validate email
    if ($db->site('status_captcha') == '1' || $db->site('status_captcha') == 1) {
    if (empty($_POST['captcha'])) {
        die(JsonMsg('error', 'Vui lòng xác thực captcha'));
    }
    $secret = $db->site('secret_key');
    $ip = $_SERVER['REMOTE_ADDR'];
    $response = Anti_xss($_POST['captcha']);
    $url = "https://www.google.com/recaptcha/api/siteverify?secret=$secret&response=$response&remoteip=$ip";
    $fire = curl_get($url);
    $data = json_decode($fire);
    if (!$data || !isset($data->success) || $data->success == false) {
        die(JsonMsg('error', 'Vui lòng xác thực captcha'));
    }
}
    if (empty($email)) {
        die(JsonMsg('error', 'Vui lòng điền email'));
    } elseif (!preg_match($emailRegex, $email)) {
        die(JsonMsg('error', 'Email không đúng định dạng'));
    } elseif ($db->num_rows("SELECT * FROM `users` WHERE `email` = '{$email}'") > 0) {
        die(JsonMsg('error', 'Email này đã tồn tại trên hệ thống'));
    } elseif (empty($username)) {
        die(JsonMsg('error', 'Vui lòng điền tên đăng nhập'));
    } elseif (!preg_match($usernameRegex, $username)) {
        die(JsonMsg('error', 'Tên người dùng phải dài từ 6-15 ký tự, bắt đầu bằng chữ cái, và có thể chứa chữ cái, số và dấu gạch dưới.'));
    } elseif (strlen($username) <= 4) {
        die(JsonMsg('error', 'Tên đăng nhập có nhiều hơn 6 ký tự trở lên'));
    } elseif ($db->num_rows("SELECT * FROM `users` WHERE `username` = '{$username}'") > 0) {
        die(JsonMsg('error', 'Tên đăng nhập này đã tồn tại trên hệ thống'));
    } elseif (empty($password)) {
        die(JsonMsg('error', 'Vui lòng nhập mật khẩu'));
    } else {
        $realPass = sha1($password);
        try {
            $google2fa = new Google2FA();
            $secretkey = $google2fa->generateSecretKey();
        } catch (Exception $e) {
            // Nếu Google2FA không khả dụng, tạo secret key đơn giản
            $secretkey = md5(random('QWERTYUIOPASDGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm0123456789', 16) . time());
        }
        $isInsert = $db->insert("users", array(
            'username' => $username,
            'password' => $realPass,
            'email' => $email,
            'device' => $_SERVER['HTTP_USER_AGENT'],
            'ip' => myip(),
            'time_session' => time(),
            'ref_id' => !empty($_SESSION['ref']) ? $_SESSION['ref'] : 0,
            'token' => md5(random('QWERTYUIOPASDGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm0123456789', 6) . time()),
            'secretkey' => $secretkey,
            'provider' => 'account',
            'level' => 'member',
            'create_date' => gettime()
        ));
        if($isInsert){
            $newUser = $db->get_row("SELECT * FROM `users` WHERE `username` = '$username' ");
            if ($newUser && isset($newUser['id']) && function_exists('insert_log')) {
                insert_log($newUser['id'], "Tham gia hệ thống bằng phương thức tài khoản");
            }
            // Tự động đăng nhập người dùng vừa tạo
            if ($newUser && isset($newUser['username'])) {
                $session->send($newUser['username']);
            }
            die(JsonMsg('success', 'Đăng ký thành công'));
        }
        $error_msg = !empty($db->last_error) ? $db->last_error : 'Đã xảy ra lỗi khi đăng ký tài khoản';
        die(JsonMsg('error', $error_msg));
    }
    