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
$username = Anti_xss($_POST['username']);
$password = sha1(Anti_xss($_POST['password']));
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
if (empty($username)) {
    die(JsonMsg('error', 'Vui lòng nhập tên đăng nhập'));
} elseif (empty($password)) {
    die(JsonMsg('error', 'Vui lòng nhập mật khẩu'));
} elseif (!$getUser = $db->get_row(" SELECT * FROM `users` WHERE `username` = '$username' ")) {
    die(JsonMsg('error', 'Tài khoản hoặc mật khẩu không chính xác'));
} elseif (!$users = $db->get_row("SELECT * FROM `users` WHERE `username` = '{$username}' AND `password` = '{$password}'")) {
    $login_attempts = isset($getUser['login_attempts']) ? (int)$getUser['login_attempts'] : 0;
    if ($login_attempts >= 5) {
        $db->update("users", array(
            'banned' => 1,
            'device' => $_SERVER['HTTP_USER_AGENT']
        ), " `id` = '" . $getUser['id'] . "' ");
        $db->insert("logs", [
            'user_id' => $getUser['id'],
            'ip' => myip(),
            'device' => $_SERVER['HTTP_USER_AGENT'],
            'create_date' => gettime(),
            'action' => "Tài khoản của bạn đã bị tạm khoá do đang nhập sai nhiều lần",
        ]);
        die(JsonMsg('error', 'Tài khoản của bạn đã bị tạm khoá do đang nhập sai nhiều lần'));
    }
    $db->cong('users', 'login_attempts', 1, " `id` = '" . $getUser['id'] . "' ");
    die(JsonMsg('error', 'Tài khoản hoặc mật khẩu không chính xác'));
} else {
    if ($users['banned'] == 1) {
        die(JsonMsg('error', 'Tài khoản của bạn đã bị tạm khoá, liên hệ admin để hỗ trợ'));
    }
    if ($users['status_2fa'] == 1) {
        die(json_encode([
            'status'    => 'verify',
            'url'       => '/verify/' . ($users['token']),
            'msg'       => 'Vui lòng xác minh 2FA để hoàn thành đăng nhập'
        ]));
    }
    $db->update("users", array(
        'login_attempts' => 0,
        'device' => $_SERVER['HTTP_USER_AGENT'],
        'time_session' => time()
    ), " `id` = '" . $getUser['id'] . "' ");
    if (function_exists('insert_log')) {
        insert_log($users['id'], "Đăng nhập vào hệ thống bằng phương thức tài khoản");
    }
    $session->send($username);
    die(JsonMsg('success', 'Đăng nhập thành công!'));
    
}
