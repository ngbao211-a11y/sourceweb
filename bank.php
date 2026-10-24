<?php
require_once realpath($_SERVER["DOCUMENT_ROOT"]) . '/libs/init.php';
if($db->site('bank_status') == 0){
 die(JsonMsg('error', 'Nạp ngân hàng đang bảo trì'));
}
if (isset($_GET['type']) || !empty($_GET['type'])) {
    $type = Anti_xss($_GET['type']);
    if (!$bank = $db->get_row("SELECT * FROM `bank` WHERE `short_name` = '" . $type . "'")) {
        die(JsonMsg('error', 'Ngân hàng không tồn tại'));
    }
    if (empty($bank['url_api'])) {
        die(JsonMsg('error', 'Vui lòng nhập api ở cấu hình'));
    }
    $url =  $bank['url_api'];
    $MEMO_PREFIX = $db->site('prefix_autobank');

    $result = curl_get("$url");
    $result = json_decode($result, true);
    print_r($result);
    if (!isset($result['transactions'])) {
        die(JsonMsg('error', 'Không thể lấy được dữ liệu'));
    }
    foreach ($result['transactions'] as $data) {
        if ($data['type'] == "OUT") continue;
        $des = $data['description'];
        $amount = $data['amount'];
        $tid = $data['transactionID'];
        $id = parse_order_id($des, $MEMO_PREFIX);
        if ($id) {
            $row = $db->get_row(" SELECT * FROM `users` WHERE `id` = '$id' ");
            if ($row) {
                if ($db->num_rows(" SELECT * FROM `invoices` WHERE `trans_id` = '$tid' ") == 0) {
                    $debt = max(0, (float)$row['wallet']);
                    $debtPaid = min((float)$amount, $debt);
                    $topupAmount = (float)$amount - $debtPaid;
                    $received = $topupAmount > 0 ? checkPromotion($topupAmount) : 0;

                    $create = $db->insert("invoices", array(
                        'trans_id' => $tid,
                        'payment_method' => $type,
                        'description' => $des,
                        'amount' => $received,
                        'create_time' => time(),
                        'user_id' => $row['id']
                    ));

                    if ($create) {
                        if ($debtPaid > 0) {
                            $db->tru("users", "wallet", $debtPaid, " `id` = '" . $row['id'] . "' ");
                        }

                        $isCheckMoney = true;
                        if ($received > 0) {
                            $reason = 'Nạp tiền tự động ngân hàng (' . $type . ' | ' . $tid . ')';
                            if ($debtPaid > 0) {
                                $reason .= ' và trừ tiền ghi nợ trước đó';
                            }
                            $isCheckMoney = PlusCredits($row['id'], $received, $reason);
                        }

                        if ($isCheckMoney) {
                            if ($received > 0) {
                                $db->cong("users", "total_money", $received, " `id` = '" . $row['id'] . "' ");
                                addRef($row['id'], $topupAmount, 'Hoa hồng khách nạp tiền');
                            }

                            $arr_res = array(
                                'status' => '200',
                                'msg' => $received > 0
                                    ? "Tài khoản của bạn đã được cộng " . format_cash($received) . " thành công!"
                                    : "Giao dịch của bạn đã được dùng để trừ ghi nợ thành công!"
                            );
                            pusher($row['username'], $arr_res);

                            $my_text = $db->site("noti_recharge");
                            $replacements = [
                                '{domain}' => $_SERVER["SERVER_NAME"],
                                '{username}' => $row["username"],
                                '{method}' => $type,
                                '{amount}' => format_cash($amount),
                                '{price}' => format_cash($received),
                                '{time}' => gettime()
                            ];
                            $my_text = str_replace(array_keys($replacements), array_values($replacements), $my_text);
                            sendMessAdmin($my_text);
                            echo '[<b style="color:green">-</b>] Xử lý thành công 1 hoá đơn.' . PHP_EOL;
                        } else {
                            if ($debtPaid > 0) {
                                $db->cong("users", "wallet", $debtPaid, " `id` = '" . $row['id'] . "' ");
                            }
                            echo '[<b style="color:red">!</b>] Xử lý không thành công 1 hoá đơn do lỗi nạp tiền.' . PHP_EOL;
                        }
                    }
                }
            }
        }
    }
}
