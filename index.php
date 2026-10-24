<?php
$title = "Dashboard";
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) . '/cpanel/views/header.php');
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) . '/cpanel/views/sidebar.php');
active_license();
?>
<div class="main-content app-content">
    <div class="container-fluid">
        <div class="d-md-flex d-block align-items-center justify-content-between my-4 page-header-breadcrumb">
            <h1 class="page-title fw-semibold fs-18 mb-2"><i class="fa-solid fa-chart-line"></i> Dashboard</h1>
            <div class="float-right"></div>
        </div>
       
        <?php if (empty($db->site('email_smtp')) || empty($db->site('pass_email_smtp'))): ?>
        <div class="alert alert-warning alert-dismissible fade show custom-alert-icon shadow-sm" role="alert">
            <svg class="svg-warning" xmlns="http://www.w3.org/2000/svg" height="1.5rem" viewBox="0 0 24 24" width="1.5rem" fill="#000000">
                <path d="M0 0h24v24H0z" fill="none" />
                <path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z" />
            </svg>
            Vui lòng cấu hình <b>SMTP</b> để sử dụng toàn bộ tiện ích từ Mail:
            <a class="text-primary" href="https://help.cmsnt.co/huong-dan/huong-dan-cau-hinh-smtp-vao-website-shopclone7/" target="_blank">Xem Hướng Dẫn</a>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"><i class="bi bi-x"></i></button>
        </div>
        <?php endif; ?>

        <div class="row">
            <div class="col-12">
                <div class="text-right mb-3">
                    <img src="/cpanel/assets/images/gif-live.gif" width="60px">
                </div>
            </div>

            <!-- Thành viên - Toàn thời gian -->
            <div class="col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
                <div class="card custom-card hrm-main-card primary">
                    <div class="card-body">
                        <div class="d-flex align-items-top">
                            <div class="me-3">
                                <span class="avatar bg-primary">
                                    <i class="fa-solid fa-users fs-18"></i>
                                </span>
                            </div>
                            <div class="flex-fill">
                                <span class="fw-semibold text-muted d-block mb-2">Thành viên đăng ký</span>
                                <h5 class="fw-semibold mb-2"><?= usersTotal() ?></h5>
                                <p class="mb-0">
                                    <span class="badge bg-primary-transparent">Toàn thời gian</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đơn hàng - Toàn thời gian -->
            <div class="col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
                <div class="card custom-card hrm-main-card danger">
                    <div class="card-body">
                        <div class="d-flex align-items-top">
                            <div class="me-3">
                                <span class="avatar bg-danger">
                                    <i class="fa-solid fa-ticket fs-18"></i>
                                </span>
                            </div>
                            <div class="flex-fill">
                                <span class="fw-semibold text-muted d-block mb-2">Đơn hàng</span>
                                <h5 class="fw-semibold mb-2">
                                    <?php
                                        $row = $db->get_row("SELECT COUNT(*) as total FROM `orders`");
                                        echo $row['total'];
                                    ?> đơn
                                </h5>
                                <p class="mb-0">
                                    <span class="badge bg-danger-transparent">Toàn thời gian</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thành viên - Tháng -->
            <div class="col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
                <div class="card custom-card hrm-main-card primary">
                    <div class="card-body">
                        <div class="d-flex align-items-top">
                            <div class="me-3">
                                <span class="avatar bg-primary">
                                    <i class="fa-solid fa-users fs-18"></i>
                                </span>
                            </div>
                            <div class="flex-fill">
                                <span class="fw-semibold text-muted d-block mb-2">Thành viên đăng ký</span>
                                <h5 class="fw-semibold mb-2"><?= usersMonthTotal() ?></h5>
                                <p class="mb-0">
                                    <span class="badge bg-primary-transparent">Tháng <?= date('m') ?></span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đơn hàng - Tháng -->
            <div class="col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
                <div class="card custom-card hrm-main-card danger">
                    <div class="card-body">
                        <div class="d-flex align-items-top">
                            <div class="me-3">
                                <span class="avatar bg-danger">
                                    <i class="fa-solid fa-ticket fs-18"></i>
                                </span>
                            </div>
                            <div class="flex-fill">
                                <span class="fw-semibold text-muted d-block mb-2">Đơn hàng</span>
                                <h5 class="fw-semibold mb-2">
                                    <?php
                                        $row = $db->get_row("SELECT COUNT(*) as total FROM `orders` WHERE MONTH(order_date) = MONTH(NOW()) AND YEAR(order_date) = YEAR(NOW())");
                                        echo $row['total'];
                                    ?> đơn
                                </h5>
                                <p class="mb-0">
                                    <span class="badge bg-danger-transparent">Tháng <?= date('m') ?></span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thành viên - Hôm nay -->
            <div class="col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
                <div class="card custom-card hrm-main-card primary">
                    <div class="card-body">
                        <div class="d-flex align-items-top">
                            <div class="me-3">
                                <span class="avatar bg-primary">
                                    <i class="fa-solid fa-users fs-18"></i>
                                </span>
                            </div>
                            <div class="flex-fill">
                                <span class="fw-semibold text-muted d-block mb-2">Thành viên đăng ký</span>
                                <h5 class="fw-semibold mb-2"><?= usersDayTotal() ?></h5>
                                <p class="mb-0">
                                    <span class="badge bg-primary-transparent">Hôm nay</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Đơn hàng - Hôm nay -->
            <div class="col-xxl-3 col-xl-3 col-lg-6 col-md-6 col-sm-12">
                <div class="card custom-card hrm-main-card danger">
                    <div class="card-body">
                        <div class="d-flex align-items-top">
                            <div class="me-3">
                                <span class="avatar bg-danger">
                                    <i class="fa-solid fa-ticket fs-18"></i>
                                </span>
                            </div>
                            <div class="flex-fill">
                                <span class="fw-semibold text-muted d-block mb-2">Đơn hàng</span>
                                <h5 class="fw-semibold mb-2">
                                    <?php
                                        $row = $db->get_row("SELECT COUNT(*) as total FROM `orders` WHERE DATE(order_date) = CURDATE()");
                                        echo $row['total'];
                                    ?> đơn
                                </h5>
                                <p class="mb-0">
                                    <span class="badge bg-danger-transparent">Hôm nay</span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="row">
            <div class="col-xl-6">
                <div class="card custom-card">
                    <div class="card-header">
                        <div class="card-title">HOẠT ĐỘNG GẦN ĐÂY</div>
                        <div class="ms-auto">
                            <img class="text-right" src="/cpanel/assets/images/gif-live.gif" width="60px">
                        </div>
                    </div>
                </div>
                <ul class="timeline list-unstyled" style="height:500px;overflow-x:hidden;overflow-y:auto;">
                    <?php foreach ($db->get_list("SELECT * FROM `logs` ORDER BY `id` DESC LIMIT 20") as $log) : ?>
                        <li>
                            <div class="timeline-time text-end">
                                <span class="date"><?= timeAgo($log['create_time']) ?></span>
                            </div>
                            <div class="timeline-icon">
                                <a href="javascript:void(0);"></a>
                            </div>
                            <div class="timeline-body">
                                <div class="d-flex align-items-top timeline-main-content flex-wrap mt-0">
                                    <div class="flex-fill">
                                        <div class="d-flex align-items-center">
                                            <div class="mt-sm-0 mt-2">
                                                <p class="mb-0 text-muted"><b style="color: green;"><?= getRowUser($log['user_id'], 'username') ?></b>
                                                    vừa <b style="color: dark;"><?= $log['action'] ?></b> vào lúc <b style="color: red;"><?= $log['create_date'] ?></b>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    <?php endforeach; ?>
                </ul>
            </div>
<style>
.ip-item {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    padding: 14px;
    border-bottom: 1px solid #f1f1f1;
    transition: all 0.2s;
}
.ip-item:hover { background: #f9fafb; }

.ip-left { display: flex; gap: 10px; }

.ip-icon {
    width: 36px;
    height: 36px;
    background: #e7f1ff;
    color: #0d6efd;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.ip-meta { font-size: 13px; color: #6c757d; }
.ip-url { font-size: 12px; color: #999; word-break: break-all; }
.ip-time { font-size: 12px; color: #999; white-space: nowrap; }

.badge-device {
    font-size: 11px;
    padding: 3px 6px;
    border-radius: 6px;
    background: #eef2ff;
    color: #4f46e5;
}

.badge-country {
    font-size: 11px;
    padding: 3px 6px;
    border-radius: 6px;
    background: #ecfdf5;
    color: #059669;
}
</style>

<div class="col-xl-6"> 
    <div class="card custom-card">
        
        <div class="card-header">
            <div class="card-title">
                <i class="fa-solid fa-globe me-1"></i> IP TRUY CẬP GẦN ĐÂY
            </div>
        </div>

        <div class="card-body p-2">

            <?php
            // ===== THỐNG KÊ =====
            $today = date('Y-m-d');
            $yesterday = date('Y-m-d', strtotime('-1 day'));
            $month = date('Y-m');

            $count_today = $db->get_row("SELECT COUNT(DISTINCT ip_address) as total FROM visitor_logs WHERE DATE(visited_at) = '$today'")['total'] ?? 0;

            $count_yesterday = $db->get_row("SELECT COUNT(DISTINCT ip_address) as total FROM visitor_logs WHERE DATE(visited_at) = '$yesterday'")['total'] ?? 0;

            $count_month = $db->get_row("SELECT COUNT(DISTINCT ip_address) as total FROM visitor_logs WHERE DATE_FORMAT(visited_at, '%Y-%m') = '$month'")['total'] ?? 0;

            $count_total = $db->get_row("SELECT COUNT(DISTINCT ip_address) as total FROM visitor_logs")['total'] ?? 0;
            ?>

            <!-- ===== BOX THỐNG KÊ ===== -->
            <div class="row text-center mb-2">

                <div class="col-3">
                    <div class="p-2 border rounded">
                        <b><?= $count_today ?></b><br>
                        <small>Hôm nay</small>
                    </div>
                </div>

                <div class="col-3">
                    <div class="p-2 border rounded">
                        <b><?= $count_yesterday ?></b><br>
                        <small>Hôm qua</small>
                    </div>
                </div>

                <div class="col-3">
                    <div class="p-2 border rounded">
                        <b><?= $count_month ?></b><br>
                        <small>Tháng</small>
                    </div>
                </div>

                <div class="col-3">
                    <div class="p-2 border rounded bg-light">
                        <b><?= $count_total ?></b><br>
                        <small>Tổng</small>
                    </div>
                </div>

            </div>

            <?php
            // ===== LẤY LOG =====
            $logs = [];
            try {
                $logs = $db->get_list("SELECT * FROM visitor_logs ORDER BY visited_at DESC LIMIT 20");
            } catch (Exception $e) {
                echo '<div class="p-3 text-danger">Lỗi truy vấn DB</div>';
            }
            ?>

            <div style="max-height:450px;overflow-y:auto;">

                <?php if (!empty($logs)): ?>

                    <?php foreach ($logs as $log): 

                        $ip = htmlspecialchars($log['ip_address'] ?? '');
                        $city = htmlspecialchars($log['city'] ?? 'Unknown');
                        $country = htmlspecialchars($log['country'] ?? '');
                        $device = htmlspecialchars($log['device_type'] ?? '');
                        $browser = htmlspecialchars($log['browser'] ?? '');
                        $url = htmlspecialchars($log['page_url'] ?? '');
                        $time_raw = $log['visited_at'] ?? '';
                        $os = $log['os'] ?? '';
                        $region = $log['region'] ?? '';

                        // ===== FORMAT TIME =====
                        $time_display = '';
                        if (!empty($time_raw)) {
                            $timestamp = strtotime($time_raw);

                            if ($timestamp) {
                                $diff = time() - $timestamp;

                                if ($diff < 5) {
                                    $time_display = 'Vừa xong';
                                } elseif ($diff < 60) {
                                    $time_display = $diff . ' giây trước';
                                } elseif ($diff < 3600) {
                                    $time_display = floor($diff / 60) . ' phút trước';
                                } elseif ($diff < 86400) {
                                    $time_display = floor($diff / 3600) . ' giờ trước';
                                } elseif (date('Y-m-d', $timestamp) == date('Y-m-d', strtotime('-1 day'))) {
                                    $time_display = 'Hôm qua ' . date('H:i', $timestamp);
                                } else {
                                    $time_display = date('H:i d/m/Y', $timestamp);
                                }
                            } else {
                                $time_display = $time_raw;
                            }
                        }
                    ?>

                    <div class="ip-item">

                        <div class="ip-left">
                            <div class="ip-icon">🌐</div>

                            <div>
                                <b><?= $ip ?></b>

                                <div class="ip-meta">
                                    📍 <?= $city ?>, <?= $region ?>
                                    <span class="badge-country"><?= $country ?></span>
                                </div>

                                <div class="ip-meta">
                                    💻 <?= $os ?> | <?= $browser ?>
                                    <span class="badge-device"><?= $device ?></span>
                                </div>

                                <div class="ip-url">
                                    🔗 <?= $url ?>
                                </div>
                            </div>
                        </div>

                        <div class="ip-time">
                            <?= $time_display ?>
                        </div>

                    </div>

                    <?php endforeach; ?>

                <?php else: ?>

                    <div class="p-3 text-center text-muted">
                        Không có dữ liệu truy cập
                    </div>

                <?php endif; ?>

            </div>

        </div>
    </div>
</div>



</div>
</div>
</div>
</div>

</div>
</div>

<?php
require_once(realpath($_SERVER["DOCUMENT_ROOT"]) . '/cpanel/views/footer.php');
?>