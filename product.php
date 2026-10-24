<?php
ob_start();
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) . '/libs/init.php');

error_reporting(0);
ini_set('display_errors', 0);

header('Content-Type: application/json');

/* ================= POST ONLY ================= */

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    ob_clean();
    echo json_encode([
        'status' => 'error',
        'msg' => 'Access Denied'
    ]);
    exit;
}

/* ================= CSRF ================= */

if (!isset($_POST["csrf_token"], $_SESSION["csrf_token"]) || $_POST["csrf_token"] !== $_SESSION["csrf_token"]) {
    ob_clean();
    echo json_encode([
        'status' => 'error',
        'msg' => 'Invalid CSRF Token'
    ]);
    exit;
}

/* ================= KIỂM TRA ĐĂNG NHẬP ================= */

if (!$user) {
    ob_clean();
    echo JsonMsg('error', 'Vui lòng đăng nhập để thực hiện');
    exit;
}

/* ================= VALIDATE PRODUCT ID ================= */

$product_id = (int)($_POST['product_id'] ?? 0);

if ($product_id <= 0) {
    ob_clean();
    echo JsonMsg('error', 'Vui lòng nhập đủ thông tin');
    exit;
}

/* ================= LẤY SẢN PHẨM ================= */

$product = $db->get_row("
    SELECT * FROM `products`
    WHERE `product_id` = {$product_id}
    AND `status` = 1
");

if (!$product) {
    ob_clean();
    echo JsonMsg('error', 'Sản phẩm không tồn tại');
    exit;
}

/* ================= LẤY USER ================= */

$username = Anti_xss($data_user['username'] ?? '');

$getUser = $db->get_row("
    SELECT * FROM `users`
    WHERE `username` = '{$username}'
    AND `banned` = 0
");

if (!$getUser) {
    ob_clean();
    echo JsonMsg('error', 'Không tìm thấy người dùng');
    exit;
}

/* ================= ĐÃ MUA CHƯA ================= */
// Đã loại bỏ để lưu mỗi lần tải

/* ================= KIỂM TRA RANK ================= */

if (!canPurchase($getUser['id'], $product['product_id'])) {

    $requiredRank = $db->get_row("SELECT name FROM ranks WHERE id='{$product['rank_id']}'");
    $currentRank  = $db->get_row("SELECT name FROM ranks WHERE id='{$getUser['rank_id']}'");

    $requiredRankName = $requiredRank ? $requiredRank['name'] : 'Không xác định';
    $currentRankName  = $currentRank  ? $currentRank['name']  : 'Không xác định';

    ob_clean();
    echo JsonMsg(
        'error',
        'Cấp bậc hiện tại của bạn là ' . $currentRankName . ' nhưng cần ' . $requiredRankName
    );
    exit;
}

/* ================= TÍNH GIÁ ================= */

$total    = (float)$product['sale_price'];
$price    = (float)$product['sale_price'];
$discount = 0;

if (!empty($_POST['coupon'])) {
    $couponCode = Anti_xss($_POST['coupon']);
    $discount   = (float)checkCoupon($couponCode, $getUser['id'], $total);
}

if ($discount > 0) {
    $total = $total - ($total * $discount / 100);
}

if (!is_numeric($total) || $total < 0) {
    ob_clean();
    echo JsonMsg('error', 'Dữ liệu không hợp lệ');
    exit;
}

/* ================= KIỂM TRA TIỀN ================= */

if ($total > (float)$getUser['money']) {
    ob_clean();
    echo JsonMsg(
        'error',
        'Số dư không đủ ' . format_cash($total) . 'đ, vui lòng nạp thêm'
    );
    exit;
}

/* ================= HOA HỒNG SELLER ================= */

$ck             = (float)$db->site('ck_product');
$seller_earning = $total - ($total * $ck / 100);

/* ================= TRỪ TIỀN ================= */

$isMoney = RemoveCredits(
    $getUser['id'],
    $total,
    "Thanh toán đơn hàng mua code <b>" . $product['title'] . "</b>"
);

if ($isMoney !== true) {
    ob_clean();
    echo JsonMsg('error', 'Thanh toán thất bại');
    exit;
}

/* ================= CẬP NHẬT COUPON ================= */

if ($discount > 0 && !empty($_POST['coupon'])) {

    $couponCode = Anti_xss($_POST['coupon']);

    $coupon = $db->get_row("
        SELECT `used` FROM tbl_coupons
        WHERE `code` = '{$couponCode}'
    ");

    if ($coupon) {
        $db->update("tbl_coupons", [
            'used' => $coupon['used'] + 1
        ], "code = '{$couponCode}'");
    }
}

/* ================= TẠO ĐƠN ================= */

$orderData = [
    'user_id'     => $getUser['id'],
    'product_id'  => $product['product_id'],
    'total_price' => $total
];

if (!$db->insert('orders', $orderData)) {
    PlusCredits($getUser['id'], $total, "Hoàn tiền do lỗi tạo đơn hàng mua code <b>" . $product['title'] . "</b>");
    ob_clean();
    echo JsonMsg('error', 'Lỗi tạo đơn hàng');
    exit;
}

$order_id = $db->get_id_insert();

$orderItem = [
    'order_id'       => $order_id,
    'product_id'     => $product['product_id'],
    'purchase_code'  => getPurchaseCode(),
    'user_id'        => $getUser['id'],
    'seller_id'      => $product['seller_id'],
    'product_price'  => $price,
    'quantity'       => 1,
    'seller_earning' => $seller_earning,
    'created_at'     => gettime(),
    'updated_at'     => gettime()
];

if (!$db->insert('order_items', $orderItem)) {
    $db->query("DELETE FROM `orders` WHERE `id` = '{$order_id}'");
    PlusCredits($getUser['id'], $total, "Hoàn tiền do lỗi tạo chi tiết đơn hàng mua code <b>" . $product['title'] . "</b>");
    ob_clean();
    echo JsonMsg('error', 'Lỗi tạo chi tiết đơn hàng');
    exit;
}

$db->update("products", [
    'sales_count' => $product['sales_count'] + 1
], "product_id = '{$product['product_id']}'");

$db->cong('users', 'product_amount', $seller_earning, "id = '{$product['seller_id']}'");
$db->cong('users', 'product_total_amount', $seller_earning, "id = '{$product['seller_id']}'");

/* ================= GỬI THÔNG BÁO ADMIN ================= */

if ($db->site("noti_action") != "") {

    $my_text = $db->site("noti_action");

    $domain = $domain ?? $db->site('domain') ?? $_SERVER['HTTP_HOST'];

    $replacements = [
        '{domain}'   => $domain,
        '{username}' => $data_user["username"],
        '{action}'   => "Thanh toán đơn hàng mua code : " . $product["title"],
        '{ip}'       => myip(),
        '{time}'     => gettime()
    ];

    $my_text = str_replace(
        array_keys($replacements),
        array_values($replacements),
        $my_text
    );

    sendMessAdmin($my_text);
}

ob_clean();
echo JsonMsg('success', 'Mua sản phẩm thành công');
exit;