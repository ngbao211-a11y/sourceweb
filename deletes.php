<?php
// Wrapper để tương thích ngược.
// Một số trang/JS gọi nhầm /model/admin/deletes hoặc delete.php include deletes.php.
// Tập trung xử lý xoá tại models/admin/delete.php.

require_once realpath($_SERVER["DOCUMENT_ROOT"]) . '/models/admin/delete.php';
