<?php

require_once realpath($_SERVER['DOCUMENT_ROOT'] . '/libs/init.php');

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Cache-Control: no-cache, no-store, must-revalidate');

$q = isset($_GET['q']) ? trim($_GET['q']) : '';

if (mb_strlen($q) < 2) {
    echo json_encode(['results' => []]);
    exit;
}

// Manual escape (DB class has private $connect)
$safe_q = addslashes($q);
$safe_q = str_replace(['%', '_'], ['\%', '\_'], $safe_q);

$sql = "SELECT product_id, title, slug, thumbnail, sale_price, sales_count
        FROM `products`
        WHERE (`title` LIKE '%$safe_q%' OR `slug` LIKE '%$safe_q%')
          AND `status` = 1
        ORDER BY `is_pinned` DESC, `created_at` DESC
        LIMIT 8";

$results = $db->get_list($sql);

$items = [];
foreach ((array)$results as $row) {
    $items[] = [
        'id'       => $row['product_id'],
        'title'    => $row['title'],
        'slug'     => $row['slug'],
        'thumb'    => !empty($row['thumbnail']) ? $row['thumbnail'] : '/assets/images/lazyload.gif',
        'price'    => (float)$row['sale_price'],
        'sales'    => (int)$row['sales_count'],
        'url'      => '/product/' . urlencode($row['slug']),
    ];
}

echo json_encode(['results' => $items], JSON_UNESCAPED_UNICODE);