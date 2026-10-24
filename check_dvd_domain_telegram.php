<?php
/**
 * Check domain dvd.vn theo hướng dẫn Nhân Hòa:
 * https://vnwho.com/api/{domain}/
 *
 * Nếu API trả chuỗi "Domain Name not found !" thì domain được xem là chưa đăng ký.
 *
 * Chỉ chạy khi được cron ngoài gọi đúng cron_key.
 * Mỗi lần gọi script chỉ check 1 lần rồi dừng, không chạy vòng lặp ẩn.
 *
 * CLI cron:
 * php handle/cronjob/check_dvd_domain_telegram.php cron_key=dvdvn_2026_secret
 *
 * URL cron:
 * https://domain.com/handle/cronjob/check_dvd_domain_telegram.php?cron_key=dvdvn_2026_secret
 */

declare(strict_types=1);

date_default_timezone_set('Asia/Ho_Chi_Minh');

// ================== CẤU HÌNH ==================
const DOMAIN_TO_CHECK = 'dvd.vn';

// Lấy token từ BotFather: https://t.me/BotFather
const TELEGRAM_BOT_TOKEN = '7669413255:AAH54fDhlsunJjGcTrV8f_WRova0pkI7dds';

// Chat ID cá nhân/nhóm nhận thông báo
const TELEGRAM_CHAT_ID = '-1003962023999';

// Mã bảo vệ cron: chỉ cron có cron_key đúng mới được phép check và gửi Telegram.
const CRON_SECRET_KEY = 'dvdvn_2026_secret';

// true = gửi Telegram ở mọi lần check
// false = chỉ gửi khi domain tự do, lần đầu chạy, hoặc trạng thái thay đổi
const SEND_EVERY_CHECK = true;

// File lưu trạng thái lần check trước để tránh spam Telegram
const STATE_FILE = __DIR__ . '/dvd_domain_last_status.json';

// API theo bài hướng dẫn Nhân Hòa
const VNWHO_API_BASE_URL = 'https://vnwho.com/api/';

// Chuỗi nhận diện domain chưa đăng ký theo hướng dẫn Nhân Hòa/WHMCS
const AVAILABLE_TEXT = 'Domain Name not found !';
// ===============================================

function sendTelegramMessage(string $message): bool
{
    if (
        TELEGRAM_BOT_TOKEN === ''
        || TELEGRAM_CHAT_ID === ''
        || TELEGRAM_BOT_TOKEN === 'YOUR_TELEGRAM_BOT_TOKEN'
        || TELEGRAM_CHAT_ID === 'YOUR_TELEGRAM_CHAT_ID'
    ) {
        echo '[' . date('Y-m-d H:i:s') . "] Chưa cấu hình Telegram Bot Token hoặc Chat ID.\n";
        return false;
    }

    $url = 'https://api.telegram.org/bot' . TELEGRAM_BOT_TOKEN . '/sendMessage';

    $payload = [
        'chat_id' => TELEGRAM_CHAT_ID,
        'text' => $message,
        'parse_mode' => 'HTML',
        'disable_web_page_preview' => true,
    ];

    $ch = curl_init($url);

    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => http_build_query($payload),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_TIMEOUT => 20,
        CURLOPT_SSL_VERIFYPEER => true,
    ]);

    $response = curl_exec($ch);
    $error = curl_error($ch);
    $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);

    curl_close($ch);

    if ($response === false || $httpCode < 200 || $httpCode >= 300) {
        echo '[' . date('Y-m-d H:i:s') . "] Gửi Telegram thất bại. HTTP {$httpCode}. {$error}. Response: {$response}\n";
        return false;
    }

    return true;
}

function callVnwhoApi(string $domain): string
{
    $url = VNWHO_API_BASE_URL . rawurlencode($domain) . '/';

    $ch = curl_init($url);

    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_TIMEOUT => 25,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_SSL_VERIFYPEER => true,
        CURLOPT_USERAGENT => 'Mozilla/5.0 Domain Availability Checker',
        CURLOPT_HTTPHEADER => [
            'Accept: text/plain,text/html,application/json,*/*',
        ],
    ]);

    $body = curl_exec($ch);
    $error = curl_error($ch);
    $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);

    curl_close($ch);

    if ($body === false) {
        throw new RuntimeException("Không gọi được VNWHO API. HTTP {$httpCode}. {$error}");
    }

    $body = trim((string) $body);

    if ($body === '') {
        throw new RuntimeException("VNWHO API trả về dữ liệu rỗng. HTTP {$httpCode}. {$error}");
    }

    return $body;
}

function checkDomainAvailability(string $domain): array
{
    $raw = callVnwhoApi($domain);
    $normalized = mb_strtolower($raw, 'UTF-8');

    $apiErrorAvailableKeywords = [
        mb_strtolower(AVAILABLE_TEXT, 'UTF-8'),
        'undefined offset',
        'brivium/vnwho/controllerpublic/vnwho.php',
        'xenforo_application::handlephperror',
    ];

    foreach ($apiErrorAvailableKeywords as $keyword) {
        if (str_contains($normalized, $keyword)) {
            return [
                'available' => true,
                'status' => 'free',
                'raw' => $raw,
                'source' => 'VNWHO API',
            ];
        }
    }

    $registeredKeywords = [
        'domain name',
        'registrar',
        'registrant',
        'creation date',
        'expiration date',
        'expiry date',
        'name server',
        'nameserver',
        'dnssec',
    ];

    foreach ($registeredKeywords as $keyword) {
        if (str_contains($normalized, $keyword)) {
            return [
                'available' => false,
                'status' => 'registered',
                'raw' => $raw,
                'source' => 'VNWHO API',
            ];
        }
    }

    return [
        'available' => false,
        'status' => 'unknown',
        'raw' => $raw,
        'source' => 'VNWHO API',
    ];
}

function getLastStatus(): ?string
{
    if (!is_file(STATE_FILE)) {
        return null;
    }

    $json = file_get_contents(STATE_FILE);
    if ($json === false || $json === '') {
        return null;
    }

    $data = json_decode($json, true);

    return is_array($data) && isset($data['status']) ? (string) $data['status'] : null;
}

function saveLastStatus(string $status): void
{
    file_put_contents(
        STATE_FILE,
        json_encode(
            [
                'domain' => DOMAIN_TO_CHECK,
                'status' => $status,
                'checked_at' => date('Y-m-d H:i:s'),
                'source' => 'VNWHO API',
            ],
            JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE
        )
    );
}

function translateJsonToVietnamese(string $raw): string
{
    $data = json_decode($raw, true);

    if (!is_array($data)) {
        return $raw;
    }

    $labels = [
        'error' => 'Lỗi',
        'traceHtml' => 'Chi tiết lỗi hệ thống',
        'domain' => 'Tên miền',
        'domainName' => 'Tên miền',
        'domain_name' => 'Tên miền',
        'status' => 'Trạng thái',
        'registrar' => 'Nhà đăng ký',
        'registrant' => 'Chủ thể đăng ký',
        'creationDate' => 'Ngày đăng ký',
        'creation_date' => 'Ngày đăng ký',
        'expirationDate' => 'Ngày hết hạn',
        'expiration_date' => 'Ngày hết hạn',
        'expiryDate' => 'Ngày hết hạn',
        'expiry_date' => 'Ngày hết hạn',
        'nameServer' => 'Máy chủ DNS',
        'name_server' => 'Máy chủ DNS',
        'nameserver' => 'Máy chủ DNS',
        'nameServers' => 'Máy chủ DNS',
        'name_servers' => 'Máy chủ DNS',
        'dnssec' => 'DNSSEC',
        'available' => 'Có thể đăng ký',
        'registered' => 'Đã đăng ký',
        'free' => 'Đang tự do',
        'message' => 'Thông báo',
    ];

    $lines = [];

    foreach ($data as $key => $value) {
        $label = $labels[$key] ?? ucwords(str_replace(['_', '-'], ' ', (string) $key));

        if ($key === 'traceHtml') {
            $value = trim(strip_tags((string) $value));
            $value = preg_replace('/\s+/', ' ', $value);
        } elseif (is_array($value)) {
            $value = implode(', ', array_map(static fn($item) => is_scalar($item) ? (string) $item : json_encode($item, JSON_UNESCAPED_UNICODE), $value));
        } elseif (is_bool($value)) {
            $value = $value ? 'Có' : 'Không';
        } elseif ($value === null) {
            $value = 'Không có dữ liệu';
        } else {
            $value = (string) $value;
        }

        if ($key === 'error' && str_contains(mb_strtolower($value, 'UTF-8'), 'undefined offset')) {
            $value = 'API VNWHO không tìm thấy dữ liệu tên miền này';
        }

        $lines[] = "• {$label}: {$value}";
    }

    return implode("\n", $lines);
}

function buildMessage(string $domain, array $result): string
{
    $icon = match ($result['status']) {
        'free' => '✅',
        'registered' => '❌',
        default => '⚠️',
    };

    $statusText = match ($result['status']) {
        'free' => 'ĐANG TỰ DO / CÓ THỂ ĐĂNG KÝ',
        'registered' => 'ĐÃ ĐƯỢC ĐĂNG KÝ',
        default => 'KHÔNG XÁC ĐỊNH',
    };

    $rawPreview = translateJsonToVietnamese(trim((string) $result['raw']));

    if (mb_strlen($rawPreview, 'UTF-8') > 1200) {
        $rawPreview = mb_substr($rawPreview, 0, 1200, 'UTF-8') . '...';
    }

    return "{$icon} <b>THÔNG BÁO CHECK DOMAIN</b>\n"
        . "━━━━━━━━━━━━━━━━━━━━\n"
        . "🌐 Tên miền: <b>{$domain}</b>\n"
        . "📡 Nguồn kiểm tra: <b>{$result['source']}</b>\n"
        . "📌 Trạng thái: <b>{$statusText}</b>\n"
        . '⏰ Thời gian: <b>' . date('Y-m-d H:i:s') . "</b>\n"
        . "━━━━━━━━━━━━━━━━━━━━\n"
        . "📋 <b>Thông tin trả về:</b>\n"
        . '<pre>' . htmlspecialchars($rawPreview, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '</pre>';
}

function runCheck(): void
{
    try {
        $result = checkDomainAvailability(DOMAIN_TO_CHECK);
        $lastStatus = getLastStatus();

        echo '[' . date('Y-m-d H:i:s') . '] ' . DOMAIN_TO_CHECK . ' => ' . $result['status'] . ' via ' . $result['source'] . "\n";

        $shouldSend = SEND_EVERY_CHECK
            || $result['status'] === 'free'
            || $lastStatus === null
            || $lastStatus !== $result['status'];

        if ($shouldSend) {
            sendTelegramMessage(buildMessage(DOMAIN_TO_CHECK, $result));
        }

        saveLastStatus($result['status']);
    } catch (Throwable $e) {
        $message = '⚠️ <b>Lỗi check domain ' . DOMAIN_TO_CHECK . "</b>\n"
            . "Nguồn check: <b>VNWHO API</b>\n"
            . 'Thời gian: <b>' . date('Y-m-d H:i:s') . "</b>\n"
            . 'Lỗi: <pre>' . htmlspecialchars($e->getMessage(), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') . '</pre>';

        echo '[' . date('Y-m-d H:i:s') . '] ERROR: ' . $e->getMessage() . "\n";
        sendTelegramMessage($message);
    }
}

function getCronKeyFromRequest(array $argv = []): string
{
    if (PHP_SAPI === 'cli') {
        foreach ($argv as $arg) {
            if (str_starts_with($arg, 'cron_key=')) {
                return substr($arg, strlen('cron_key='));
            }

            if (str_starts_with($arg, '--cron-key=')) {
                return substr($arg, strlen('--cron-key='));
            }
        }

        return '';
    }

    return isset($_GET['cron_key']) ? (string) $_GET['cron_key'] : '';
}

function isValidCronRequest(array $argv = []): bool
{
    $cronKey = getCronKeyFromRequest($argv);

    return $cronKey !== '' && hash_equals(CRON_SECRET_KEY, $cronKey);
}

if (!isValidCronRequest($argv ?? [])) {
    if (PHP_SAPI !== 'cli') {
        header('Content-Type: text/plain; charset=utf-8');
        http_response_code(403);
    }

    echo "Forbidden: chỉ cron có cron_key hợp lệ mới được phép check và gửi Telegram.\n";
    exit;
}

echo 'Checking ' . DOMAIN_TO_CHECK . " via VNWHO API...\n";
runCheck();
