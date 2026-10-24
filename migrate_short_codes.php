<?php
/**
 * Script migrate short_code cho tất cả sản phẩm hiện có
 * Chạy: php migrations/migrate_short_codes.php
 */
require_once __DIR__ . '/../libs/init.php';

echo "=== Migrate short_code for existing products ===\n";

// Lấy tất cả sản phẩm chưa có short_code
$products = $db->get_list("SELECT product_id, title FROM products WHERE short_code IS NULL OR short_code = ''");

$count = 0;
foreach ($products as $product) {
    $short_code = generate_short_code();
    $attempts = 0;
    // Đảm bảo short_code là duy nhất
    while ($db->num_rows("SELECT short_code FROM products WHERE short_code = '$short_code'") > 0 && $attempts < 100) {
        $short_code = generate_short_code();
        $attempts++;
    }
    $db->query("UPDATE products SET short_code = '$short_code' WHERE product_id = {$product['product_id']}");
    echo "  [{$product['product_id']}] {$product['title']} => {$short_code}\n";
    $count++;
}

echo "\nDone! Migrated {$count} products.\n";