<?php
/**
 * UnlockLink API v3 — api.php
 * Hỗ trợ nhiều kênh riêng cho từng link
 */

define('DB_HOST', 'localhost');
define('DB_NAME', 'tcodevipfun_123');
define('DB_USER', 'tcodevipfun_123');
define('DB_PASS', 'tcodevipfun_123');
define('ADMIN_PASS', 'admin123');

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

// ── DB ──────────────────────────────
try {
    $pdo = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME.";charset=utf8mb4", DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'DB connection failed: '.$e->getMessage()]); exit;
}

// ── AUTO MIGRATE ────────────────────
$pdo->exec("
CREATE TABLE IF NOT EXISTS youtube_channels (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  url VARCHAR(500) NOT NULL,
  sort_order INT DEFAULT 0,
  is_required TINYINT(1) DEFAULT 1,
  is_active TINYINT(1) DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS unlock_links (
  id INT AUTO_INCREMENT PRIMARY KEY,
  display_name VARCHAR(200) NOT NULL,
  target_url VARCHAR(1000) NOT NULL,
  locked_text VARCHAR(200) DEFAULT '🔒 Đăng ký để tiếp tục',
  unlocked_text VARCHAR(200) DEFAULT '🔓 Truy cập link gốc',
  description VARCHAR(500) DEFAULT '',
  is_active TINYINT(1) DEFAULT 1,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS link_channels (
  id INT AUTO_INCREMENT PRIMARY KEY,
  link_id INT NOT NULL,
  channel_id INT NOT NULL,
  sort_order INT DEFAULT 0,
  UNIQUE KEY uq_link_channel (link_id, channel_id),
  INDEX idx_link_id (link_id),
  INDEX idx_channel_id (channel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS site_settings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  setting_key VARCHAR(100) UNIQUE NOT NULL,
  setting_value TEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS visit_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  link_id INT DEFAULT NULL,
  ip VARCHAR(64),
  user_agent VARCHAR(500),
  referer VARCHAR(500),
  event VARCHAR(50) DEFAULT 'pageview',
  channel_id INT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_link_id (link_id),
  INDEX idx_event (event),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
");

// Seed defaults
$cnt = $pdo->query("SELECT COUNT(*) FROM site_settings")->fetchColumn();
if ($cnt == 0) {
    $pdo->exec("INSERT INTO site_settings (setting_key,setting_value) VALUES
        ('page_title','Unlock Link'),
        ('page_desc','Hoàn thành các bước để mở khóa link'),
        ('btn_color','#ff1e1e'),
        ('task_delay','5')
    ");
}
$cntC = $pdo->query("SELECT COUNT(*) FROM youtube_channels")->fetchColumn();
if ($cntC == 0) {
    $pdo->exec("INSERT INTO youtube_channels (name,url,sort_order) VALUES
        ('Đăng ký kênh YouTube1','https://www.youtube.com/@modgameviet2025',1),
        ('Đăng ký kênh YouTube2','https://www.youtube.com/@tienwtee',2),
        ('Đăng ký kênh YouTube3','https://www.youtube.com/@supportgamee',3)
    ");
}


// ── AUTH ────────────────────────────
$auth   = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
$token  = str_replace('Bearer ', '', $auth);
$isAuth = ($token === md5(ADMIN_PASS));

function requireAuth() {
    global $isAuth;
    if (!$isAuth) { http_response_code(401); echo json_encode(['error'=>'Unauthorized']); exit; }
}
function ok($d=[])      { echo json_encode(array_merge(['ok'=>true],$d)); }
function err($m,$c=400) { http_response_code($c); echo json_encode(['error'=>$m]); exit; }

// ── ROUTER ──────────────────────────
$method   = $_SERVER['REQUEST_METHOD'];
$path     = trim($_GET['path'] ?? '', '/');
$parts    = explode('/', $path);
$resource = $parts[0] ?? '';
$id       = isset($parts[1]) && is_numeric($parts[1]) ? (int)$parts[1] : null;
$sub      = $parts[2] ?? '';
$body     = json_decode(file_get_contents('php://input'), true) ?? [];

function getIP() {
    foreach (['HTTP_CF_CONNECTING_IP','HTTP_X_FORWARDED_FOR','HTTP_X_REAL_IP','REMOTE_ADDR'] as $k)
        if (!empty($_SERVER[$k])) return explode(',', $_SERVER[$k])[0];
    return '0.0.0.0';
}

// ══ LOGIN ════════════════════════════
if ($resource === 'login') {
    if ($method !== 'POST') err('Method not allowed', 405);
    if (($body['password'] ?? '') === ADMIN_PASS) ok(['token' => md5(ADMIN_PASS)]);
    else err('Sai mật khẩu', 401);
    exit;
}

// ══ CHANNELS ═════════════════════════
if ($resource === 'channels') {
    if ($method === 'GET') {
        $activeOnly = isset($_GET['active']);
        if ($activeOnly) {
            $rows = $pdo->query("SELECT id,name,url,sort_order,is_required FROM youtube_channels WHERE is_active=1 ORDER BY sort_order")->fetchAll();
        } else {
            requireAuth();
            $rows = $pdo->query("SELECT * FROM youtube_channels ORDER BY sort_order")->fetchAll();
        }
        echo json_encode($rows);
    } elseif ($method === 'POST') {
        requireAuth();
        if (empty($body['name'])||empty($body['url'])) err('Thiếu name/url');
        $s = $pdo->prepare("INSERT INTO youtube_channels (name,url,sort_order,is_required,is_active) VALUES(?,?,?,?,?)");
        $s->execute([$body['name'],$body['url'],$body['sort_order']??0,$body['is_required']??1,$body['is_active']??1]);
        ok(['id'=>$pdo->lastInsertId()]);
    } elseif ($method === 'PUT' && $id) {
        requireAuth();
        $s = $pdo->prepare("UPDATE youtube_channels SET name=?,url=?,sort_order=?,is_required=?,is_active=? WHERE id=?");
        $s->execute([$body['name'],$body['url'],$body['sort_order']??0,$body['is_required']??1,$body['is_active']??1,$id]);
        ok();
    } elseif ($method === 'DELETE' && $id) {
        requireAuth();
        $pdo->prepare("DELETE FROM youtube_channels WHERE id=?")->execute([$id]);
        $pdo->prepare("DELETE FROM link_channels WHERE channel_id=?")->execute([$id]);
        ok();
    } else err('Not found',404);
    exit;
}

// ══ LINKS ════════════════════════════
if ($resource === 'links') {

    // GET /links/{id}/channels — lấy kênh của link cụ thể (public, dùng cho index.html)
    if ($method === 'GET' && $id && $sub === 'channels') {
        $rows = $pdo->prepare("
            SELECT c.id, c.name, c.url, c.is_required, lc.sort_order
            FROM link_channels lc
            JOIN youtube_channels c ON c.id = lc.channel_id
            WHERE lc.link_id = ? AND c.is_active = 1
            ORDER BY lc.sort_order, c.sort_order
        ");
        $rows->execute([$id]);
        echo json_encode($rows->fetchAll());
        exit;
    }

    // POST /links/{id}/channels — gán kênh cho link (admin)
    if ($method === 'POST' && $id && $sub === 'channels') {
        requireAuth();
        // body: { channel_ids: [1,2,3] }
        $channelIds = $body['channel_ids'] ?? [];
        // Xóa cũ rồi insert mới
        $pdo->prepare("DELETE FROM link_channels WHERE link_id=?")->execute([$id]);
        $s = $pdo->prepare("INSERT INTO link_channels (link_id,channel_id,sort_order) VALUES(?,?,?)");
        foreach ($channelIds as $i => $cid) {
            $s->execute([$id, (int)$cid, $i]);
        }
        ok();
        exit;
    }

    if ($method === 'GET') {
        $activeOnly = isset($_GET['active']);
        if ($activeOnly) {
            $rows = $pdo->query("
                SELECT l.id,l.display_name,l.target_url,l.locked_text,l.unlocked_text,l.description,l.sort_order,
                    (SELECT COUNT(*) FROM visit_logs v WHERE v.link_id=l.id AND v.event='unlock') AS unlock_count,
                    (SELECT COUNT(*) FROM link_channels lc WHERE lc.link_id=l.id) AS channel_count
                FROM unlock_links l WHERE l.is_active=1 ORDER BY l.sort_order
            ")->fetchAll();
        } else {
            requireAuth();
            $rows = $pdo->query("
                SELECT l.*,
                    (SELECT COUNT(*) FROM visit_logs v WHERE v.link_id=l.id AND v.event='pageview') AS views,
                    (SELECT COUNT(*) FROM visit_logs v WHERE v.link_id=l.id AND v.event='unlock') AS unlocks,
                    (SELECT COUNT(*) FROM link_channels lc WHERE lc.link_id=l.id) AS channel_count
                FROM unlock_links l ORDER BY l.sort_order
            ")->fetchAll();
        }
        echo json_encode($rows);
    } elseif ($method === 'POST') {
        requireAuth();
        if (empty($body['display_name'])||empty($body['target_url'])) err('Thiếu thông tin');
        $s = $pdo->prepare("INSERT INTO unlock_links (display_name,target_url,locked_text,unlocked_text,description,is_active,sort_order) VALUES(?,?,?,?,?,?,?)");
        $s->execute([$body['display_name'],$body['target_url'],$body['locked_text']??'🔒 Đăng ký để tiếp tục',$body['unlocked_text']??'🔓 Truy cập link gốc',$body['description']??'',$body['is_active']??1,$body['sort_order']??0]);
        $newId = $pdo->lastInsertId();
        // Gán kênh nếu có
        if (!empty($body['channel_ids'])) {
            $s2 = $pdo->prepare("INSERT INTO link_channels (link_id,channel_id,sort_order) VALUES(?,?,?)");
            foreach ($body['channel_ids'] as $i => $cid) $s2->execute([$newId,(int)$cid,$i]);
        }
        ok(['id'=>$newId]);
    } elseif ($method === 'PUT' && $id) {
        requireAuth();
        $s = $pdo->prepare("UPDATE unlock_links SET display_name=?,target_url=?,locked_text=?,unlocked_text=?,description=?,is_active=?,sort_order=? WHERE id=?");
        $s->execute([$body['display_name'],$body['target_url'],$body['locked_text'],$body['unlocked_text'],$body['description']??'',$body['is_active']??1,$body['sort_order']??0,$id]);
        // Cập nhật kênh nếu có
        if (isset($body['channel_ids'])) {
            $pdo->prepare("DELETE FROM link_channels WHERE link_id=?")->execute([$id]);
            $s2 = $pdo->prepare("INSERT INTO link_channels (link_id,channel_id,sort_order) VALUES(?,?,?)");
            foreach ($body['channel_ids'] as $i => $cid) $s2->execute([$id,(int)$cid,$i]);
        }
        ok();
    } elseif ($method === 'DELETE' && $id) {
        requireAuth();
        $pdo->prepare("DELETE FROM unlock_links WHERE id=?")->execute([$id]);
        $pdo->prepare("DELETE FROM visit_logs WHERE link_id=?")->execute([$id]);
        $pdo->prepare("DELETE FROM link_channels WHERE link_id=?")->execute([$id]);
        ok();
    } else err('Not found',404);
    exit;
}

// ══ SETTINGS ═════════════════════════
if ($resource === 'settings') {
    if ($method === 'GET') {
        $rows = $pdo->query("SELECT setting_key,setting_value FROM site_settings")->fetchAll(PDO::FETCH_KEY_PAIR);
        echo json_encode($rows);
    } elseif ($method === 'POST') {
        requireAuth();
        $s = $pdo->prepare("INSERT INTO site_settings (setting_key,setting_value) VALUES(?,?) ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value)");
        foreach ($body as $k=>$v) $s->execute([$k,$v]);
        ok();
    } else err('Not found',404);
    exit;
}

// ══ TRACK ════════════════════════════
if ($resource === 'track') {
    if ($method !== 'POST') err('POST only',405);
    $event     = $body['event'] ?? 'pageview';
    $linkId    = $body['link_id'] ?? null;
    $channelId = $body['channel_id'] ?? null;
    $allowed   = ['pageview','click_channel','unlock'];
    if (!in_array($event,$allowed)) err('Invalid event');
    $s = $pdo->prepare("INSERT INTO visit_logs (link_id,ip,user_agent,referer,event,channel_id) VALUES(?,?,?,?,?,?)");
    $s->execute([$linkId, getIP(), substr($_SERVER['HTTP_USER_AGENT']??'',0,500), substr($_SERVER['HTTP_REFERER']??'',0,500), $event, $channelId]);
    ok(['logged'=>true]);
    exit;
}

// ══ STATS ════════════════════════════
if ($resource === 'stats') {
    requireAuth();
    if ($method !== 'GET') err('GET only',405);
    $period = (int)($_GET['period'] ?? 7);

    $total_views   = $pdo->query("SELECT COUNT(*) FROM visit_logs WHERE event='pageview'")->fetchColumn();
    $total_unlocks = $pdo->query("SELECT COUNT(*) FROM visit_logs WHERE event='unlock'")->fetchColumn();
    $total_clicks  = $pdo->query("SELECT COUNT(*) FROM visit_logs WHERE event='click_channel'")->fetchColumn();
    $uniq_ips      = $pdo->query("SELECT COUNT(DISTINCT ip) FROM visit_logs WHERE event='pageview'")->fetchColumn();

    $daily = $pdo->query("
        SELECT DATE(created_at) as day,
            SUM(event='pageview') as views,
            SUM(event='unlock') as unlocks
        FROM visit_logs
        WHERE created_at >= DATE_SUB(NOW(), INTERVAL {$period} DAY)
        GROUP BY DATE(created_at)
        ORDER BY day ASC
    ")->fetchAll();

    $top_channels = $pdo->query("
        SELECT c.name, COUNT(v.id) as clicks
        FROM visit_logs v
        JOIN youtube_channels c ON v.channel_id=c.id
        WHERE v.event='click_channel'
        GROUP BY v.channel_id
        ORDER BY clicks DESC LIMIT 10
    ")->fetchAll();

    $link_stats = $pdo->query("
        SELECT l.id, l.display_name,
            (SELECT COUNT(*) FROM link_channels lc WHERE lc.link_id=l.id) as channel_count,
            SUM(v.event='pageview') as views,
            SUM(v.event='unlock') as unlocks,
            ROUND(SUM(v.event='unlock')/NULLIF(SUM(v.event='pageview'),0)*100,1) as rate
        FROM unlock_links l
        LEFT JOIN visit_logs v ON v.link_id=l.id
        GROUP BY l.id
        ORDER BY views DESC
    ")->fetchAll();

    $today     = $pdo->query("SELECT COUNT(*) FROM visit_logs WHERE event='pageview' AND DATE(created_at)=CURDATE()")->fetchColumn();
    $yesterday = $pdo->query("SELECT COUNT(*) FROM visit_logs WHERE event='pageview' AND DATE(created_at)=DATE_SUB(CURDATE(),INTERVAL 1 DAY)")->fetchColumn();

    echo json_encode(compact('total_views','total_unlocks','total_clicks','uniq_ips','daily','top_channels','link_stats','today','yesterday'));
    exit;
}

http_response_code(404);
echo json_encode(['error'=>'Route not found']);