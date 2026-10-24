<?php
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) .'/libs/init.php');

header('Content-Type: application/json');

if (isset($_GET['action'])) {
    $action = $_GET['action'];

    if ($action == 'increment') {
        // Kiểm tra xem đã có row chưa
        $check = $db->get_row("SELECT * FROM `site_counters` WHERE `counter_key` = 'site_views'");
        if (!$check) {
            $db->query("INSERT INTO `site_counters` (`counter_key`, `counter_value`) VALUES ('site_views', 1)");
        } else {
            $db->query("UPDATE `site_counters` SET `counter_value` = `counter_value` + 1 WHERE `counter_key` = 'site_views'");
        }
    }

    // Lấy tổng lượt view hiện tại
    $row = $db->get_row("SELECT `counter_value` FROM `site_counters` WHERE `counter_key` = 'site_views'");
    $views = $row ? $row['counter_value'] : 0;

    echo json_encode(['status' => 'success', 'views' => number_format($views)]);
} else {
    echo json_encode(['status' => 'error', 'msg' => 'Invalid Action']);
}