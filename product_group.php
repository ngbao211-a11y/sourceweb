<?php
/**
 * Product Group Admin API
 * Handles CRUD operations for product version groups
 */
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) . '/libs/init.php');

$action = isset($_POST['action']) ? Anti_xss($_POST['action']) : '';

if (!@$user || $data_user['level'] != 'admin') {
    die(json_encode(['status' => 'error', 'msg' => 'Unauthorized']));
}

switch ($action) {
    case 'create_group':
        $name = Anti_xss($_POST['name']);
        $description = Anti_xss($_POST['description'] ?? '');
        $slug = create_slug($name);
        $status = isset($_POST['status']) ? (int)$_POST['status'] : 1;

        if (empty($name)) {
            die(json_encode(['status' => 'error', 'msg' => 'Tên nhóm không được để trống']));
        }

        // Check duplicate slug
        $exists = $db->get_row("SELECT id FROM product_groups WHERE slug = '$slug'");
        if ($exists) {
            $slug .= '-' . time();
        }

        $data = [
            'name' => $name,
            'slug' => $slug,
            'description' => $description,
            'status' => $status,
            'created_at' => gettime(),
        ];

        if ($db->insert('product_groups', $data)) {
            $group_id = $db->get_id_insert();
            insert_log($data_user['id'], "Đã tạo nhóm phiên bản: $name (ID: $group_id)");
            die(json_encode(['status' => 'success', 'msg' => 'Tạo nhóm phiên bản thành công', 'group_id' => $group_id]));
        } else {
            die(json_encode(['status' => 'error', 'msg' => 'Có lỗi khi tạo nhóm phiên bản']));
        }
        break;

    case 'update_group':
        $id = (int)Anti_xss($_POST['id']);
        $name = Anti_xss($_POST['name']);
        $description = Anti_xss($_POST['description'] ?? '');
        $slug = create_slug($name);
        $status = isset($_POST['status']) ? (int)$_POST['status'] : 1;

        if (empty($name) || $id <= 0) {
            die(json_encode(['status' => 'error', 'msg' => 'Dữ liệu không hợp lệ']));
        }

        // Check duplicate slug excluding current
        $exists = $db->get_row("SELECT id FROM product_groups WHERE slug = '$slug' AND id != $id");
        if ($exists) {
            $slug .= '-' . $id;
        }

        $data = [
            'name' => $name,
            'slug' => $slug,
            'description' => $description,
            'status' => $status,
        ];

        if ($db->update('product_groups', $data, "id = $id")) {
            insert_log($data_user['id'], "Đã cập nhật nhóm phiên bản: $name (ID: $id)");
            die(json_encode(['status' => 'success', 'msg' => 'Cập nhật nhóm phiên bản thành công']));
        } else {
            die(json_encode(['status' => 'error', 'msg' => 'Có lỗi khi cập nhật nhóm phiên bản']));
        }
        break;

    case 'delete_group':
        $id = (int)Anti_xss($_POST['id']);

        if ($id <= 0) {
            die(json_encode(['status' => 'error', 'msg' => 'ID không hợp lệ']));
        }

        $group = $db->get_row("SELECT * FROM product_groups WHERE id = $id");
        if (!$group) {
            die(json_encode(['status' => 'error', 'msg' => 'Không tìm thấy nhóm phiên bản']));
        }

        // Unlink products from this group
        $db->query("UPDATE products SET group_id = NULL, version_name = NULL, is_latest = 0, sort_order = 0 WHERE group_id = $id");

        if ($db->remove('product_groups', "id = $id")) {
            insert_log($data_user['id'], "Đã xóa nhóm phiên bản: {$group['name']} (ID: $id)");
            die(json_encode(['status' => 'success', 'msg' => 'Xóa nhóm phiên bản thành công']));
        } else {
            die(json_encode(['status' => 'error', 'msg' => 'Có lỗi khi xóa nhóm phiên bản']));
        }
        break;

    case 'update_product_version':
        $product_id = (int)Anti_xss($_POST['product_id']);
        $group_id = isset($_POST['group_id']) && $_POST['group_id'] !== '' ? (int)$_POST['group_id'] : null;
        $version_name = Anti_xss($_POST['version_name'] ?? '');
        $is_latest = isset($_POST['is_latest']) ? (int)$_POST['is_latest'] : 0;
        $sort_order = isset($_POST['sort_order']) ? (int)$_POST['sort_order'] : 0;

        if ($product_id <= 0) {
            die(json_encode(['status' => 'error', 'msg' => 'ID sản phẩm không hợp lệ']));
        }

        // If setting as latest, unset other products in the same group
        if ($is_latest == 1 && $group_id) {
            $db->query("UPDATE products SET is_latest = 0 WHERE group_id = $group_id AND product_id != $product_id");
        }

        $data = [
            'group_id' => $group_id,
            'version_name' => $version_name,
            'is_latest' => $is_latest,
            'sort_order' => $sort_order,
        ];

        if ($db->update('products', $data, "product_id = $product_id")) {
            die(json_encode(['status' => 'success', 'msg' => 'Cập nhật phiên bản sản phẩm thành công']));
        } else {
            die(json_encode(['status' => 'error', 'msg' => 'Có lỗi khi cập nhật phiên bản sản phẩm']));
        }
        break;

    case 'get_group_products':
        $group_id = (int)Anti_xss($_POST['group_id']);
        $products = $db->get_list("SELECT product_id, title, group_id, version_name, is_latest, sort_order FROM products ORDER BY title ASC");
        die(json_encode(['status' => 'success', 'products' => $products]));
        break;

    default:
        die(json_encode(['status' => 'error', 'msg' => 'Action không hợp lệ']));
        break;
}