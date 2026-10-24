-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th6 28, 2026 lúc 12:02 PM
-- Phiên bản máy phục vụ: 10.5.29-MariaDB
-- Phiên bản PHP: 8.3.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `tvpslitecom_ccc`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `auth_tokens`
--

CREATE TABLE `auth_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `auth_tokens`
--

INSERT INTO `auth_tokens` (`id`, `user_id`, `token`, `ip`, `expires_at`) VALUES
(691, 1, '14004fb750bcad13114e8ef727a1a0eb3be706b4ead87b51d0c06eddf7070554', '116.98.245.19', '2025-06-19 12:23:23');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bank`
--

CREATE TABLE `bank` (
  `id` int(11) NOT NULL,
  `short_name` text NOT NULL,
  `accountNumber` text NOT NULL,
  `accountName` text NOT NULL,
  `url_api` text DEFAULT NULL,
  `status` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `bank`
--

INSERT INTO `bank` (`id`, `short_name`, `accountNumber`, `accountName`, `url_api`, `status`) VALUES
(5, 'MBBANK', '0707133155555', 'TRAN NGOC TIEN', '', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cards`
--

CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `trans_id` varchar(255) DEFAULT NULL,
  `telco` varchar(255) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `serial` text DEFAULT NULL,
  `pin` text DEFAULT NULL,
  `status` varchar(55) NOT NULL DEFAULT 'pending',
  `create_date` datetime NOT NULL,
  `update_date` datetime NOT NULL,
  `reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `cards`
--

INSERT INTO `cards` (`id`, `user_id`, `trans_id`, `telco`, `amount`, `price`, `serial`, `pin`, `status`, `create_date`, `update_date`, `reason`) VALUES
(1, 62, 'EQGWRU1750087973', 'MOBIFONE', 20000, 15000, '101253000091108', '237977345808', 'completed', '2025-06-16 22:32:53', '2025-06-16 22:33:36', '');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `parent_category_id` int(11) DEFAULT 0,
  `status` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `thumbnail` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `slug`, `parent_category_id`, `status`, `created_at`, `updated_at`, `thumbnail`) VALUES
(1, 'Html - Css - Js', 'html-css-js', 0, 1, '2025-04-15 19:24:40', '2025-04-15 19:24:40', '/upload/thumbnails/698f6ec766587e10b61b1eb8f8711696.webp'),
(2, 'Web Designs', 'web-designs', 0, 1, '2025-04-15 19:25:10', '2025-04-15 19:25:10', '/upload/thumbnails/f71f30fcda88eb4dd0b470aa658c598c.webp'),
(3, 'Design & Creative', 'design-creative', 0, 1, '2025-04-15 19:25:59', '2025-04-15 19:26:15', '/upload/thumbnails/0eac97d2b2648f859217d8cb20cce014.webp'),
(4, 'React & PHP', 'react-php', 0, 1, '2025-04-15 19:26:53', '2025-04-15 19:26:53', '/upload/thumbnails/73f74c259a425f8e6e152eab53d81115.png'),
(6, 'Php Script', 'php-script', 0, 1, '2025-04-15 21:11:16', '2025-04-15 21:11:16', '/upload/thumbnails/fa7ec361dc93c91b8bf0a434aa1cc397.webp');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cronjobs`
--

CREATE TABLE `cronjobs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `trans_id` text DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `method` enum('GET','POST') DEFAULT NULL,
  `cron_expression` varchar(100) DEFAULT NULL,
  `server_id` varchar(50) NOT NULL,
  `headers` text DEFAULT NULL,
  `body` text DEFAULT NULL,
  `month` int(11) DEFAULT 1,
  `payment` int(11) DEFAULT 0,
  `last_run` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `status` enum('active','paused','expired') DEFAULT 'active',
  `expires_at` timestamp NULL DEFAULT NULL,
  `status_code` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `design_config`
--

CREATE TABLE `design_config` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `short_description` text NOT NULL,
  `bonus_features` text DEFAULT NULL,
  `status` enum('0','1') DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `history_captcha`
--

CREATE TABLE `history_captcha` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `image` longtext DEFAULT NULL,
  `captcha` text DEFAULT NULL,
  `status` text DEFAULT NULL,
  `type_bank` text DEFAULT NULL,
  `create_time` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hosting_packages`
--

CREATE TABLE `hosting_packages` (
  `id` int(11) NOT NULL,
  `whm_id` int(11) NOT NULL DEFAULT 0,
  `package_name` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `disk_quota` varchar(255) NOT NULL,
  `bandwidth_limit` varchar(255) NOT NULL,
  `max_subdomains` varchar(255) NOT NULL,
  `max_parked_domains` varchar(255) NOT NULL,
  `max_addon_domains` varchar(255) NOT NULL,
  `language` varchar(50) DEFAULT NULL,
  `cpanel_module` varchar(50) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `user_id` text DEFAULT NULL,
  `trans_id` text DEFAULT NULL,
  `payment_method` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `amount` text DEFAULT NULL,
  `create_time` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `link_channels`
--

CREATE TABLE `link_channels` (
  `id` int(11) NOT NULL,
  `link_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `sort_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `list_vps`
--

CREATE TABLE `list_vps` (
  `id` int(11) NOT NULL,
  `package_name` varchar(100) NOT NULL,
  `product_id` int(11) NOT NULL COMMENT 'id: sản phẩm vps',
  `cpu` varchar(50) NOT NULL,
  `ram` varchar(50) NOT NULL,
  `disk` varchar(50) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `bandwidth` varchar(50) NOT NULL,
  `os` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `period` varchar(20) DEFAULT 'Tháng'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ip` text DEFAULT NULL,
  `device` text DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_time` text DEFAULT NULL,
  `action` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `log_balance`
--

CREATE TABLE `log_balance` (
  `id` int(11) NOT NULL,
  `money_before` text DEFAULT NULL,
  `money_change` text DEFAULT NULL,
  `money_after` text DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  `content` text DEFAULT NULL,
  `user_id` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `log_ref`
--

CREATE TABLE `log_ref` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT 0,
  `sotientruoc` int(11) DEFAULT 0,
  `sotienthaydoi` int(11) DEFAULT 0,
  `sotienhientai` int(11) DEFAULT 0,
  `reason` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `options`
--

CREATE TABLE `options` (
  `id` int(11) NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_vietnamese_ci ROW_FORMAT=DYNAMIC;

--
-- Đang đổ dữ liệu cho bảng `options`
--

INSERT INTO `options` (`id`, `key`, `value`) VALUES
(1, 'title', 'CODEVIP.FUN | THIẾT KẾ MÃ NGUỒN WEBSITE'),
(2, 'description', 'Trang web cung cấp mã nguồn'),
(3, 'keywords', 'codevip , codevip.fun , codewebfree , code vip'),
(4, 'author', 'TRANTIEN'),
(5, 'email_smtp', ''),
(6, 'pass_email_smtp', ''),
(10, 'page_design_description', 'PHA+Q01TVERFVi5DTyDEkeG6t2MgYmnhu4d0IGNoJnVhY3V0ZTsgdHLhu41uZyB0xrAgduG6pW4gY2hp4bq/biBsxrDhu6NjIMSR4buDIGtoJmFhY3V0ZTtjaCBoJmFncmF2ZTtuZyBoaeG7g3UgciZvdGlsZGU7IGzhu5kgdHImaWdyYXZlO25oIHThu6sga2gmYWNpcmM7dSDEkeG7i25oIGgmaWdyYXZlO25oICZ5YWN1dGU7IHTGsOG7n25nLCB4JmFhY3V0ZTtjIMSR4buLbmggxJHhu5FpIHTGsOG7o25nIG5nxrDhu51pIGQmdWdyYXZlO25nLCDEkeG6v24gdHJp4buDbiBraGFpIHYmYWdyYXZlOyBuJmFjaXJjO25nIGPhuqVwIGxpJmVjaXJjO24gdOG7pWMuIEjhu4cgc2luaCB0aCZhYWN1dGU7aSBnaeG6o2kgcGgmYWFjdXRlO3AgY+G7p2EgY2gmdWFjdXRlO25nIHQmb2NpcmM7aSBraCZvY2lyYztuZyBuZ+G7q25nIGPhuq1wIG5o4bqtdCBjJm9jaXJjO25nIG5naOG7hyBt4bubaSwgbmdoaSZlY2lyYztuIGPhu6l1IHh1IGjGsOG7m25nIHRo4buLIHRyxrDhu51uZyBuaOG6sW0gZ2kmdWFjdXRlO3AgZG9hbmggbmdoaeG7h3AgYuG7qXQgcGgmYWFjdXRlOyB0xINuZyB0csaw4bufbmcgZG9hbmggdGh1IHYmYWdyYXZlOyB4JmFjaXJjO3kgZOG7sW5nIHRoxrDGoW5nIGhp4buHdSBi4buBbiB24buvbmcuIENNU1RERVYuQ08gbWFuZyDEkeG6v24gZOG7i2NoIHbhu6UgdGhp4bq/dCBr4bq/IHdlYnNpdGUgY2h1eSZlY2lyYztuIG5naGnhu4dwLCBoaeG7h24gxJHhuqFpIHYmYWdyYXZlOyB04buRaSDGsHUgY2hvIHThu6tuZyBuZyZhZ3JhdmU7bmggbmdo4buBLjwvcD4NCg=='),
(13, 'anhbia', '/upload/theme/6GSXUZEC.png'),
(14, 'favicon', '/upload/theme/B9H4E5I.png'),
(17, 'logo', '/upload/theme/C4N2DLGJ.png'),
(29, 'facebook', 'no'),
(30, 'popup_home', '<p style=\"text-align:center\">&nbsp;</p>\r\n\r\n<p style=\"text-align:center\">&nbsp;</p>\r\n'),
(31, 'hotline', '0817129895'),
(32, 'email', 'brosc1000@gmail.com'),
(42, 'zalo', '0817129895'),
(44, 'card_partner_id', ''),
(45, 'card_partner_key', ''),
(46, 'card_url_api', 'https://doicardre.vn/chargingws/v2'),
(47, 'bank_status', '1'),
(48, 'telegram', '@tienw05'),
(53, 'status_captcha', '0'),
(63, 'card_status', '1'),
(64, 'card_ck', '25'),
(65, 'page_policy', '<h2>Ch&iacute;nh s&aacute;ch bảo h&agrave;nh</h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li>Ch&uacute;ng t&ocirc;i hỗ trợ fix lỗi nếu lỗi do m&atilde; nguồn g&acirc;y ra v&iacute; dụ như: code bug, code kh&ocirc;ng x&agrave;i được v.v</li>\r\n	<li>Ch&uacute;ng t&ocirc;i từ chối bảo h&agrave;nh trường hợp qu&yacute; kh&aacute;ch tự g&acirc;y ra lỗi v&iacute; dụ như: code th&ecirc;m 1 số chức năng xảy ra lỗi, edit giao diện xảy ra lỗi v.v.</li>\r\n	<li>M&atilde; nguồn sẽ được Update v&aacute; lỗi miễn ph&iacute; đến khi hết v&ograve;ng đời sản phẩm (đến khi ngừng b&aacute;n sản phẩm đ&oacute;).</li>\r\n	<li>Kh&ocirc;ng hỗ trợ v&agrave; bảo h&agrave;nh đối với trường hợp mua m&atilde; nguồn từ b&ecirc;n thứ 3 hoặc sử dụng m&atilde; nguồn được share v.v</li>\r\n	<li>Kh&ocirc;ng hỗ trợ trường hợp qu&yacute; kh&aacute;ch h&agrave;ng sử dụng m&atilde; nguồn để chiếm đoạt t&agrave;i sản, lừa đảo, vi phạm ph&aacute;p luật Việt Nam.</li>\r\n	<li>Kh&ocirc;ng hỗ trợ trường hợp qu&yacute; kh&aacute;ch chia sẻ m&atilde; nguồn, b&aacute;n lại m&atilde; nguồn cho người kh&aacute;c.</li>\r\n	<li>Kh&ocirc;ng hỗ trợ đối với người d&ugrave;ng mua code để tạo shop vượt qu&aacute; mức gi&aacute; tiền code ch&iacute;nh h&atilde;ng</li>\r\n</ul>\r\n\r\n<h3>Ch&iacute;nh s&aacute;ch hỗ trợ</h3>\r\n\r\n<ul>\r\n	<li>Ch&uacute;ng t&ocirc;i sẽ setup cho bạn lần đầu miễn ph&iacute; khi bạn mua m&atilde; nguồn của ch&uacute;ng t&ocirc;i, ch&uacute;ng t&ocirc;i sẽ đưa code bạn l&ecirc;n Hosting v&agrave; c&agrave;i đặt mọi thứ, bạn chỉ cần đưa v&agrave;o sử dụng n&oacute;.</li>\r\n	<li>Nếu bạn cần ch&uacute;ng t&ocirc;i setup lại lần 2 để đưa l&ecirc;n Hosting kh&aacute;c ch&uacute;ng t&ocirc;i sẽ lấy ph&iacute; 500.000đ 1 lần để tr&aacute;nh SPAM.</li>\r\n	<li>Chỉ hỗ trợ duy nhất 1 người mua, nếu người mua share, b&aacute;n lại giấy ph&eacute;p cho một người kh&aacute;c, người đ&oacute; sẽ kh&ocirc;ng được hỗ trợ từ ch&uacute;ng t&ocirc;i.</li>\r\n</ul>\r\n\r\n<h3>&nbsp;Ch&iacute;nh s&aacute;ch mua h&agrave;ng</h3>\r\n\r\n<ul>\r\n	<li>Ch&uacute;ng t&ocirc;i chỉ chấp nhận thanh to&aacute;n qua: ng&acirc;n h&agrave;ng nội địa, v&iacute; điện tử momo, thẻ si&ecirc;u rẻ</li>\r\n	<li>Ch&uacute;ng t&ocirc;i sẽ lấy ph&iacute; khi thanh to&aacute;n qua thẻ c&agrave;o, tiền ảo...</li>\r\n	<li>Mua m&atilde; nguồn vui l&ograve;ng thanh to&aacute;n trước 100%, thu&ecirc; code theo y&ecirc;u cầu vui l&ograve;ng thanh to&aacute;n trước 50%.</li>\r\n	<li>Qu&yacute; kh&aacute;ch h&agrave;ng muốn mua m&atilde; nguồn vui l&ograve;ng nhắn tin về Zalo cho&nbsp;<strong>CODEVIP.FUN&nbsp;</strong>để được hỗ trợ tốt nhất.</li>\r\n</ul>\r\n\r\n<h3>Ch&iacute;nh s&aacute;ch cộng t&aacute;c vi&ecirc;n</h3>\r\n\r\n<ul>\r\n	<li>C&aacute;c&nbsp;<strong>CTV</strong>&nbsp;khi giới thiệu th&agrave;nh c&ocirc;ng kh&aacute;ch h&agrave;ng sử dụng dịch vụ của&nbsp;<strong>CODEVIP.FUN&nbsp;</strong>sẽ được nhận 20% gi&aacute; trị của giao dịch đ&oacute;.</li>\r\n	<li>Nếu Sale A giới thiệu được 1 kh&aacute;ch B mua m&atilde; nguồn AB với gi&aacute; 1.000.000đ, bạn Sale A đ&oacute; sẽ nhận được 20% của 1.000.000đ tức 200.000đ khi kh&aacute;ch B ho&agrave;n th&agrave;nh qu&aacute; tr&igrave;nh thanh to&aacute;n cho <strong>CODEVIP.FUN</strong></li>\r\n	<li>Sau khi t&igrave;m kiếm th&agrave;nh c&ocirc;ng kh&aacute;ch h&agrave;ng,&nbsp;<strong>CTV</strong>&nbsp;đ&oacute; vui l&ograve;ng tạo nh&oacute;m li&ecirc;n hệ bao gồm&nbsp;<strong>Kh&aacute;ch H&agrave;ng</strong>&nbsp;-&nbsp;<strong>CTV</strong>&nbsp;để c&ugrave;ng thực hiện trao đổi giao dịch sao cho minh bạch nhất.</li>\r\n	<li>Thanh to&aacute;n sẽ được về tay&nbsp;<strong>CTV</strong>&nbsp;sau khi kh&aacute;ch h&agrave;ng đ&oacute; thanh to&aacute;n đủ gi&aacute; trị đơn h&agrave;ng.</li>\r\n	<li><strong>CTV</strong>&nbsp;chỉ &aacute;p dụng cho kh&aacute;ch h&agrave;ng từng sử dụng dịch vụ của <strong>CODEVIP.FUN</strong></li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><strong>CODEVIP.FUN&nbsp;</strong>kh&ocirc;ng chịu tr&aacute;ch nhiệm về ph&aacute;p l&yacute; khi qu&yacute; kh&aacute;ch h&agrave;ng sử dụng sai mục đ&iacute;ch sản phẩm.</p>\r\n\r\n<p>Cảm ơn qu&yacute; kh&aacute;ch h&agrave;ng tin d&ugrave;ng sản phẩm của <strong>CODEVIP.FUN</strong></p>\r\n'),
(74, 'card_notice', '<p><strong>Lưu &yacute;: Theo quy định của nh&agrave; mạng, nạp sai mệnh gi&aacute; sẽ bị mất thẻ.</strong></p>\r\n'),
(80, 'secret_key', ''),
(81, 'site_key', ''),
(83, 'ck_ref', '20'),
(84, 'notice_ref', '<ul>\r\n	<li>Chia sẻ&nbsp;li&ecirc;n kết n&agrave;y l&ecirc;n mạng x&atilde; hội hoặc bạn b&egrave; của bạn.</li>\r\n	<li>Bạn sẽ nhận được hoa hồng khi bạn b&egrave; được bạn giới thiệu sử dụng dịch vụ của CMSTDEV.CO</li>\r\n	<li>Nếu bạn A nhấn v&agrave;o link tiếp thị của bạn, bạn A nạp tiền v&agrave;o hệ thống 100.000đ, bạn sẽ được hoa hồng 20% của 100.000đ l&agrave; 20.000đ</li>\r\n	<li>Trường hợp người được bạn giới thiệu nạp tiền sai nội dung, hệ thống sẽ kh&ocirc;ng t&iacute;nh hoa hồng, chỉ t&iacute;nh hoa hồng khi người bạn giới thiệu nạp tiền th&agrave;nh c&ocirc;ng v&agrave;o hệ thống.</li>\r\n	<li>Hoa hồng sẽ t&iacute;nh m&atilde;i m&atilde;i, kh&ocirc;ng giới hạn thời gian n&ecirc;n bạn y&ecirc;n t&acirc;m nh&eacute;.</li>\r\n	<li>Nghi&ecirc;m cấm h&agrave;nh vi tự giới thiệu bản th&acirc;n để giảm gi&aacute; b&aacute;n, ph&aacute;t hiện sẽ kh&oacute;a t&agrave;i khoản v&agrave; kh&ocirc;ng duyệt r&uacute;t tiền.</li>\r\n</ul>\r\n'),
(85, 'minrut_ref', '100000'),
(86, 'listbank_ref', 'ACB\r\nMBBANK\r\nVCB\r\nTCB'),
(87, 'status_ref', '0'),
(88, 'prefix_autobank', 'muacode'),
(89, 'bank_min', '1000'),
(90, 'bank_max', '500000000'),
(91, 'bank_notice', '<p>123</p>\r\n'),
(92, 'google_app_id', '240636247540-dfi4i1p09vc8m5pc84jf4rtbmi0oh5qh.apps.googleusercontent.com'),
(93, 'google_app_secret', 'thay đi'),
(94, 'telegram_status', '1'),
(95, 'telegram_chat_id', ''),
(96, 'telegram_token', ''),
(97, 'noti_recharge', '[{time}] <b>{username}</b> vừa nạp {amount} vào {method} thực nhận {price}.'),
(98, 'noti_action', '[{time}] \r\n- <b>Domain</b>: <code>{domain}</code>\r\n- <b>Username</b>: <code>{username}</code>\r\n- <b>Action</b>:  <code>{action}</code>\r\n- <b>IP</b>: <code>{ip}</code>'),
(100, 'status_demo', '0'),
(103, 'terms', ''),
(104, 'listbank_product', NULL),
(105, 'minrut_product', NULL),
(106, 'notice_product', ''),
(107, 'ck_product', NULL),
(108, 'status_withdraw_product', '0'),
(112, 'status_login_google', '1'),
(113, 'cron_status', '1'),
(114, 'cron_notice', '<h4><strong>Quy định về việc sử dụng hệ thống CRON:</strong></h4>\r\n\r\n<p><strong>- Kh&ocirc;ng k&iacute;ch hoạt Firewall đối với c&aacute;c li&ecirc;n kết CRON</strong>: Việc bật Firewall c&oacute; thể g&acirc;y gi&aacute;n đoạn hệ thống v&agrave; ngăn cản CRON thực hiện nhiệm vụ.</p>\r\n\r\n<p><strong>- Sử dụng hệ thống CRON đ&uacute;ng mục đ&iacute;ch</strong>: Ch&uacute;ng t&ocirc;i c&oacute; quyền tạm ngưng hoặc hủy vĩnh viễn c&aacute;c li&ecirc;n kết CRON vi phạm, đặc biệt trong c&aacute;c trường hợp lạm dụng g&acirc;y ảnh hưởng đến hệ thống. C&aacute;c trường hợp n&agrave;y sẽ kh&ocirc;ng được ho&agrave;n tiền.</p>\r\n\r\n<p><strong>- Cung cấp ch&iacute;nh x&aacute;c li&ecirc;n kết CRON</strong>: Đảm bảo nhập đầy đủ v&agrave; ch&iacute;nh x&aacute;c đường dẫn li&ecirc;n kết, bao gồm tiền tố &quot;https://...&quot;</p>\r\n'),
(115, 'noti_affiliate_withdraw', '[{time}] \r\n- <b>Username</b>: <code>{username}</code>\r\n- <b>Action</b>:  <code>Tạo lệnh rút {amount} về ngân hàng {bank} | {account_number} | {account_name}</code>\r\n- <b>IP</b>: <code>{ip}</code>'),
(116, 'license', 'true'),
(117, 'vps_status', '1'),
(118, 'hosting_status', '1'),
(119, 'api_username', 'G8lDw0BShXaJWC1cPCCmE+bmlGbZAXy2/nwFhkAQM4c='),
(120, 'api_app', 'UkW9okixeVljtEGb3vcQL00msXpqn1xBxcOhPhAqluE='),
(121, 'api_secret', '9gu8mlvFsY+vrVF4V1CB4iOIU3vFH5BPHwgqFPEJrQ9O7NqgY30ywscjBnqFNep81GfJ4eyFEcdQuKtRGMU38jXRZUW9oHZ/mqBrbRdBpWZCmIskR2NNFzJuufnocCm17arjUfLLLcRIkbIsA8+98d7+RlEO/F39YAgWuC8gB31Lbgz1VfEZjqS979ezXgEg'),
(123, 'auth_token_vps', NULL),
(124, 'os_vps', '{\"error\":99999,\"message\":\"Auth Token kh\\u00f4ng t\\u1ed3n t\\u1ea1i.\"}'),
(128, 'api_username_cloudnest', 'minhphsdepchai@gmail.com'),
(129, 'api_app_cloudnest', 'XRbQQGpTkfph9h3fDCgXbsDN'),
(130, 'api_secret_cloudnest', 'dgM9fMW2AI4R80OsuKqRLBdlYxGj15cGdlASzVbkzzKL5mmqYQ8mtQwpbJzwkpnsrD9Xjm0ieB7vG89v7eWrjxu4eSNYD5N0y2PzZF4TfViVT9tdhf98mrQqybnv7Zen'),
(131, 'auth_token_vps_cloudnest', NULL),
(132, 'os_vps_cloudnest', '{\"error\":99999,\"message\":\"Auth Token kh\\u00f4ng t\\u1ed3n t\\u1ea1i.\"}'),
(133, 'api_username_h2cloud', 'uJ8jiyFGMhxRn5pdFcq7kvajR6enz+9UVje/rIJqV9E='),
(134, 'api_app_h2cloud', 'UkW9okixeVljtEGb3vcQL00msXpqn1xBxcOhPhAqluE='),
(135, 'api_secret_h2cloud', 'ZedHdBZCiy1HVa5qTK+aJ0yvAJC/6w0wn552eSjHMjb2j92byhA8s5x+DGyaGmxKJGHNCrINPR6Clj3met+Fa7qbotJN300HWysr2R2t3Z2ddXyraRGKtyo6uqOlMV3dkTd+HP7bD4vdYI6eoEP7YITRTT2dx1BVlpKnhrwib6kqRY4LWfhbQB/VR4ToR1PB'),
(136, 'auth_token_vps_h2cloud', 'K48hUDVUwsJvFQYSmaV3fiHaeXAq9kd1EmM70G8ro6LUeLxcZ5VAELAIzVVdhAKk3NnBcW1EC4oPZWvURCplfdWQtGO8XALWXFeojyRV8v2BwUgtx5kXuL29pCsXaVwHwMb7iS6TWiVcL6VlKbGLneWzv7R7jiUzAjv4w4Kdjct2AXGfBujx4w1yB6NkWa86a5O8XNCbHGbLpAdSwgh3PIygEeWUNpdSBOuzi1ki5IPnFGLTKjO3Rqio3C'),
(137, 'os_vps_h2cloud', '{\"error\":0,\"os-vps\":[{\"os-id\":1,\"os-name\":\"Windows Server 2012 R2\"},{\"os-id\":2,\"os-name\":\"Windows Server 2016\"},{\"os-id\":3,\"os-name\":\"Linux CentOS 7 64bit\"},{\"os-id\":4,\"os-name\":\"Windows Server 2019\"},{\"os-id\":5,\"os-name\":\"Windows 10 64bit\"},{\"os-id\":6,\"os-name\":\"Linux Ubuntu-20.04\"},{\"os-id\":7,\"os-name\":\"Linux Ubuntu-22.04\"},{\"os-id\":9,\"os-name\":\"AlmaLinux 8\"},{\"os-id\":10,\"os-name\":\"Debian 12\"}]}'),
(138, 'design_status', '1'),
(139, 'page_design_title', 'PHA+VGhp4bq/dCBL4bq/IFdlYnNpdGUgVGhlbyBZJmVjaXJjO3UgQ+G6p3UmbmJzcDsmYW1wOyBPdXRzb3VyY2UgVOG6oWkgQ01TVERFVi5DTzwvcD4NCg=='),
(140, 'ck_vncloud', '10'),
(141, 'ck_cloudnest', '10'),
(142, 'ck_h2cloud', '10'),
(144, 'vps_statush2', '1'),
(145, 'vps_statusnest', '1'),
(149, 'vps_statusvn', '0');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `order_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_captcha`
--

CREATE TABLE `order_captcha` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `license` text DEFAULT NULL,
  `captcha_used` int(11) DEFAULT 0,
  `ip` text DEFAULT NULL,
  `day` int(11) DEFAULT 0,
  `payment` int(11) DEFAULT 0,
  `expired` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `purchase_code` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `seller_id` int(11) NOT NULL DEFAULT 0,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_extended` tinyint(4) NOT NULL DEFAULT 0,
  `is_refunded` tinyint(4) NOT NULL DEFAULT 0,
  `extended_amount` decimal(28,8) DEFAULT 0.00000000,
  `product_price` decimal(28,8) DEFAULT 0.00000000,
  `seller_fee` decimal(28,8) NOT NULL DEFAULT 0.00000000,
  `buyer_fee` decimal(28,8) NOT NULL DEFAULT 0.00000000,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `license` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1=personal\r\n2=commercial\r\n',
  `downloads` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `seller_earning` decimal(28,8) NOT NULL DEFAULT 0.00000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_vps`
--

CREATE TABLE `order_vps` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `vps_id` int(11) DEFAULT 0,
  `billingcycle` text DEFAULT NULL,
  `plan_name` text DEFAULT NULL,
  `billingcycleday` int(11) DEFAULT 0,
  `info` longtext DEFAULT NULL,
  `status` text DEFAULT NULL,
  `price` int(11) DEFAULT 0,
  `cost` int(11) DEFAULT 0,
  `total_price` int(11) DEFAULT 0,
  `total_cost` int(11) DEFAULT 0,
  `notified` enum('no','yes') NOT NULL DEFAULT 'no',
  `notification_expired` enum('no','yes') NOT NULL DEFAULT 'no',
  `notification_delete` enum('no','yes') NOT NULL DEFAULT 'no',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `site` varchar(50) NOT NULL DEFAULT 'VNCLOUD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `os_vps`
--

CREATE TABLE `os_vps` (
  `id` int(11) NOT NULL,
  `os_id` int(11) NOT NULL,
  `os_name` text NOT NULL,
  `image` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `stt` int(11) NOT NULL DEFAULT 0,
  `category_id` int(11) NOT NULL DEFAULT 0,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `slug` text CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `view` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `stt`, `category_id`, `title`, `image`, `slug`, `content`, `status`, `view`, `created_at`) VALUES
(1, 65, 0, 1, 'Kiểm tra firewall trên Ubuntu 22.04', '/upload/blog/blog3AT6.png', 'kiem-tra-firewall-tren-ubuntu-22-04', 'PGgyPktp4buDbSB0cmEgZmlyZXdhbGwgdHImZWNpcmM7biBVYnVudHUgMjIuMDQ8L2gyPg0KDQo8cD5VYnVudHUgMjIuMDQgbeG6t2MgxJHhu4tuaCBz4butIGThu6VuZyZuYnNwOzxzdHJvbmc+VUZXIChVbmNvbXBsaWNhdGVkIEZpcmV3YWxsKTwvc3Ryb25nPiZuYnNwO8SR4buDIHF14bqjbiBsJnlhY3V0ZTsgdMaw4budbmcgbOG7rWEuIFRyxrDhu5tjIHRpJmVjaXJjO24sIGLhuqFuIGPhuqduIGtp4buDbSB0cmEgdHLhuqFuZyB0aCZhYWN1dGU7aSBmaXJld2FsbCBi4bqxbmcgbOG7h25oOjwvcD4NCg0KPHByZT4NCjxjb2RlPnN1ZG8gdWZ3IHN0YXR1cw0KPC9jb2RlPjwvcHJlPg0KDQo8dWw+DQoJPGxpPg0KCTxwPk7hur91IGvhur90IHF14bqjIGwmYWdyYXZlOyZuYnNwOzxjb2RlPmluYWN0aXZlPC9jb2RlPiZuYnNwO25naMSpYSBsJmFncmF2ZTsgZmlyZXdhbGwgxJFhbmcgdOG6r3Q8L3A+DQoJPC9saT4NCgk8bGk+DQoJPHA+TuG6v3UgbCZhZ3JhdmU7Jm5ic3A7PGNvZGU+YWN0aXZlPC9jb2RlPiZuYnNwO25naMSpYSBsJmFncmF2ZTsgZmlyZXdhbGwgxJFhbmcgYuG6rXQgdiZhZ3JhdmU7IGMmb2FjdXRlOyB0aOG7gyDEkWFuZyBjaOG6t24gcG9ydDwvcD4NCgk8L2xpPg0KPC91bD4NCg0KPGhyIC8+DQo8aDI+TeG7nyBwb3J0IGLhurFuZyBVRlcgKGtodXnhur9uIG5naOG7iyk8L2gyPg0KDQo8aDM+TeG7nyBt4buZdCBwb3J0IGPhu6UgdGjhu4M8L2gzPg0KDQo8cD5WJmlhY3V0ZTsgZOG7pSBt4bufIHBvcnQgODA4MDo8L3A+DQoNCjxwcmU+DQo8Y29kZT5zdWRvIHVmdyBhbGxvdyA4MDgwDQo8L2NvZGU+PC9wcmU+DQoNCjxoMz5N4bufIHBvcnQgdGhlbyBnaWFvIHRo4bupYyBUQ1AgaG/hurdjIFVEUDwvaDM+DQoNCjxwcmU+DQo8Y29kZT5zdWRvIHVmdyBhbGxvdyA4MDgwL3RjcA0Kc3VkbyB1ZncgYWxsb3cgODA4MC91ZHANCjwvY29kZT48L3ByZT4NCg0KPGgzPk3hu58gbmhp4buBdSBwb3J0IGMmdWdyYXZlO25nIGwmdWFjdXRlO2M8L2gzPg0KDQo8cHJlPg0KPGNvZGU+c3VkbyB1ZncgYWxsb3cgMzAwMDo0MDAwL3RjcA0KPC9jb2RlPjwvcHJlPg0KDQo8cD5M4buHbmggbiZhZ3JhdmU7eSB0aMaw4budbmcgZCZ1Z3JhdmU7bmcgY2hvIGdhbWUgc2VydmVyLCBib3QgaG/hurdjIGThu4tjaCB24bulIGPhuqduIG5oaeG7gXUgY+G7lW5nLjwvcD4NCg0KPGhyIC8+DQo8aDI+TeG7nyBjJmFhY3V0ZTtjIHBvcnQgcGjhu5UgYmnhur9uIHRoxrDhu51uZyBkJnVncmF2ZTtuZzwvaDI+DQoNCjxwPk3hu5l0IHPhu5EgcG9ydCB0aCZvY2lyYztuZyBk4bulbmcgdHImZWNpcmM7biBWUFM6PC9wPg0KDQo8dWw+DQoJPGxpPg0KCTxwPlNTSDogMjI8L3A+DQoJPC9saT4NCgk8bGk+DQoJPHA+SFRUUDogODA8L3A+DQoJPC9saT4NCgk8bGk+DQoJPHA+SFRUUFM6IDQ0MzwvcD4NCgk8L2xpPg0KCTxsaT4NCgk8cD5GVFA6IDIxPC9wPg0KCTwvbGk+DQoJPGxpPg0KCTxwPk15U1FMOiAzMzA2PC9wPg0KCTwvbGk+DQoJPGxpPg0KCTxwPlJlZGlzOiA2Mzc5PC9wPg0KCTwvbGk+DQoJPGxpPg0KCTxwPk5vZGVKUzogMzAwMDwvcD4NCgk8L2xpPg0KPC91bD4NCg0KPHA+ViZpYWN1dGU7IGThu6UgbeG7nyBTU0ggdiZhZ3JhdmU7IHdlYiBzZXJ2ZXI6PC9wPg0KDQo8cHJlPg0KPGNvZGU+c3VkbyB1ZncgYWxsb3cgMjINCnN1ZG8gdWZ3IGFsbG93IDgwDQpzdWRvIHVmdyBhbGxvdyA0NDMNCjwvY29kZT48L3ByZT4NCg0KPGhyIC8+DQo8aDI+QuG6rXQgVUZXIG7hur91IGZpcmV3YWxsIGNoxrBhIGhv4bqhdCDEkeG7mW5nPC9oMj4NCg0KPHA+U2F1IGtoaSBj4bqldSBoJmlncmF2ZTtuaCB4b25nIGMmYWFjdXRlO2MgcG9ydCBj4bqnbiB0aGnhur90LCBi4bqtdCBmaXJld2FsbCBi4bqxbmcgbOG7h25oOjwvcD4NCg0KPHByZT4NCjxjb2RlPnN1ZG8gdWZ3IGVuYWJsZQ0KPC9jb2RlPjwvcHJlPg0KDQo8cD7imqDvuI8mbmJzcDs8c3Ryb25nPkzGsHUgJnlhY3V0ZTsgcXVhbiB0cuG7jW5nOjwvc3Ryb25nPjxiciAvPg0KSCZhdGlsZGU7eSBjaOG6r2MgY2jhuq9uIGLhuqFuIMSRJmF0aWxkZTsgbeG7nyBwb3J0Jm5ic3A7PHN0cm9uZz4yMiAoU1NIKTwvc3Ryb25nPiZuYnNwO3RyxrDhu5tjIGtoaSBi4bqtdCBVRlcsIG7hur91IGtoJm9jaXJjO25nIGLhuqFuIGMmb2FjdXRlOyB0aOG7gyBi4buLIGtoJm9hY3V0ZTthIHRydXkgY+G6rXAgVlBTLjwvcD4NCg0KPGhyIC8+DQo8aDI+S2nhu4NtIHRyYSBs4bqhaSBkYW5oIHMmYWFjdXRlO2NoIHBvcnQgxJEmYXRpbGRlOyBt4bufPC9oMj4NCg0KPHA+xJDhu4MgeGVtIHRvJmFncmF2ZTtuIGLhu5kgcnVsZSBmaXJld2FsbDo8L3A+DQoNCjxwcmU+DQo8Y29kZT5zdWRvIHVmdyBzdGF0dXMgbnVtYmVyZWQNCjwvY29kZT48L3ByZT4NCg0KPHA+ViZpYWN1dGU7IGThu6Uga+G6v3QgcXXhuqM6PC9wPg0KDQo8cHJlPg0KPGNvZGU+WzFdIDIyL3RjcCBBTExPVyBBbnl3aGVyZQ0KWzJdIDgwL3RjcCBBTExPVyBBbnl3aGVyZQ0KWzNdIDQ0My90Y3AgQUxMT1cgQW55d2hlcmUNCjwvY29kZT48L3ByZT4NCg0KPGhyIC8+DQo8aDI+xJAmb2FjdXRlO25nIHBvcnQga2gmb2NpcmM7bmcgYyZvZ3JhdmU7biBz4butIGThu6VuZzwvaDI+DQoNCjxwPsSQ4buDIHTEg25nIGLhuqNvIG3huq10LCBi4bqhbiBuJmVjaXJjO24gxJEmb2FjdXRlO25nIGMmYWFjdXRlO2MgcG9ydCBraCZvY2lyYztuZyBj4bqnbiB0aGnhur90OjwvcD4NCg0KPHByZT4NCjxjb2RlPnN1ZG8gdWZ3IGRlbGV0ZSBhbGxvdyA4MDgwDQo8L2NvZGU+PC9wcmU+DQoNCjxwPkhv4bq3YyB4Jm9hY3V0ZTthIHRoZW8gc+G7kSB0aOG7qSB04buxOjwvcD4NCg0KPHByZT4NCjxjb2RlPnN1ZG8gdWZ3IGRlbGV0ZSAyDQo8L2NvZGU+PC9wcmU+DQoNCjxociAvPg0KPGgyPk3hu58gcG9ydCBi4bqxbmcgaXB0YWJsZXMgKHRyxrDhu51uZyBo4bujcCBuJmFjaXJjO25nIGNhbyk8L2gyPg0KDQo8cD5Ucm9uZyB0csaw4budbmcgaOG7o3AgVlBTIGtoJm9jaXJjO25nIHPhu60gZOG7pW5nIFVGVywgYuG6oW4gYyZvYWN1dGU7IHRo4buDIG3hu58gcG9ydCBi4bqxbmcgaXB0YWJsZXM6PC9wPg0KDQo8cHJlPg0KPGNvZGU+c3VkbyBpcHRhYmxlcyAtQSBJTlBVVCAtcCB0Y3AgLS1kcG9ydCA4MDgwIC1qIEFDQ0VQVA0KPC9jb2RlPjwvcHJlPg0KDQo8cD5MxrB1IGzhuqFpIHJ1bGUgxJHhu4Mga2gmb2NpcmM7bmcgYuG7iyBt4bqldCBzYXUga2hpIHJlYm9vdDo8L3A+DQoNCjxwcmU+DQo8Y29kZT5zdWRvIGFwdCBpbnN0YWxsIGlwdGFibGVzLXBlcnNpc3RlbnQNCnN1ZG8gbmV0ZmlsdGVyLXBlcnNpc3RlbnQgc2F2ZQ0KPC9jb2RlPjwvcHJlPg0KDQo8aHIgLz4NCjxoMj5LaeG7g20gdHJhIHBvcnQgdOG7qyBiJmVjaXJjO24gbmdvJmFncmF2ZTtpPC9oMj4NCg0KPHA+VHImZWNpcmM7biBWUFMsIGtp4buDbSB0cmEgc2VydmljZSDEkWFuZyBs4bqvbmcgbmdoZSBwb3J0OjwvcD4NCg0KPHByZT4NCjxjb2RlPnNzIC10dWxwbg0KPC9jb2RlPjwvcHJlPg0KDQo8cD5Ib+G6t2Mga2nhu4NtIHRyYSBvbmxpbmUgYuG6sW5nIGMmYWFjdXRlO2MgYyZvY2lyYztuZyBj4bulOjwvcD4NCg0KPHVsPg0KCTxsaT4NCgk8cD48YSBocmVmPSJodHRwOi8vY2FueW91c2VlbWUub3JnLyIgcmVsPSJub29wZW5lciBub3JlZmVycmVyIG5vZm9sbG93IiB0YXJnZXQ9Il9ibGFuayI+Y2FueW91c2VlbWUub3JnPC9hPjwvcD4NCgk8L2xpPg0KCTxsaT4NCgk8cD48YSBocmVmPSJodHRwOi8veW91Z2V0c2lnbmFsLmNvbS8iIHJlbD0ibm9vcGVuZXIgbm9yZWZlcnJlciBub2ZvbGxvdyIgdGFyZ2V0PSJfYmxhbmsiPnlvdWdldHNpZ25hbC5jb208L2E+PC9wPg0KCTwvbGk+DQo8L3VsPg0KDQo8aHIgLz4NCjxoMj5MxrB1ICZ5YWN1dGU7IGLhuqNvIG3huq10IGtoaSBt4bufIHBvcnQgVlBTPC9oMj4NCg0KPHVsPg0KCTxsaT4NCgk8cD5DaOG7iSBt4bufIG5o4buvbmcgcG9ydCB0aOG6rXQgc+G7sSBj4bqnbiB0aGnhur90PC9wPg0KCTwvbGk+DQoJPGxpPg0KCTxwPktoJm9jaXJjO25nIG3hu58gcG9ydCBkYXRhYmFzZSAoTXlTUUwsIFJlZGlzKSByYSBpbnRlcm5ldCBjJm9jaXJjO25nIGtoYWk8L3A+DQoJPC9saT4NCgk8bGk+DQoJPHA+xJDhu5VpIHBvcnQgU1NIIG3hurdjIMSR4buLbmggxJHhu4MgdHImYWFjdXRlO25oIHNjYW4gYm90PC9wPg0KCTwvbGk+DQoJPGxpPg0KCTxwPkvhur90IGjhu6NwIEZhaWwyQmFuLCBDbG91ZCBGaXJld2FsbCBu4bq/dSBjJm9hY3V0ZTs8L3A+DQoJPC9saT4NCjwvdWw+DQo=', 1, 131, '2026-05-16 04:22:19');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_category`
--

CREATE TABLE `post_category` (
  `id` int(11) NOT NULL,
  `name` text DEFAULT NULL,
  `slug` text NOT NULL,
  `content` longtext NOT NULL,
  `icon` text DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `post_category`
--

INSERT INTO `post_category` (`id`, `name`, `slug`, `content`, `icon`, `status`, `created_at`) VALUES
(1, 'Hướng Dẫn', 'huong-dan', '', '', 1, '2025-04-15 21:05:06');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `short_code` varchar(10) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `seller_id` int(11) NOT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `file_url` varchar(255) NOT NULL,
  `file_url_2` varchar(255) DEFAULT NULL,
  `use_secondary_link` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(11) DEFAULT 0,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `discount_percentage` int(11) DEFAULT NULL,
  `is_new` tinyint(1) DEFAULT 0,
  `is_cheap` tinyint(1) DEFAULT 0,
  `is_free` tinyint(1) DEFAULT 0,
  `sales_count` int(11) DEFAULT 0,
  `is_pinned` tinyint(1) DEFAULT 0,
  `security_tag` varchar(32) NOT NULL DEFAULT '',
  `rank_id` int(11) DEFAULT 0,
  `view` int(11) DEFAULT 0,
  `approved` int(11) DEFAULT 0 COMMENT 'ID of the admin who approved the product',
  `time_session` int(11) DEFAULT NULL,
  `ditme` int(11) DEFAULT 0,
  `group_id` int(11) DEFAULT NULL,
  `version_name` varchar(100) DEFAULT NULL,
  `is_latest` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_groups`
--

CREATE TABLE `product_groups` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_hashtags`
--

CREATE TABLE `product_hashtags` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `hashtag` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `image_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `image_url` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_withdraw`
--

CREATE TABLE `product_withdraw` (
  `id` int(11) NOT NULL,
  `trans_id` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `bank` text DEFAULT NULL,
  `stk` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `amount` int(11) DEFAULT 0,
  `status` int(11) DEFAULT 0,
  `create_gettime` datetime DEFAULT NULL,
  `update_gettime` datetime DEFAULT NULL,
  `reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `purchased_hosting`
--

CREATE TABLE `purchased_hosting` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `ip` text DEFAULT NULL,
  `start_date` int(11) NOT NULL,
  `end_date` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `domain_name` varchar(255) NOT NULL,
  `server_whm` text DEFAULT NULL,
  `info_package` text DEFAULT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `month` int(11) NOT NULL DEFAULT 1,
  `total` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','suspended','expired') NOT NULL,
  `trash` int(11) NOT NULL DEFAULT 0,
  `extend` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ranks`
--

CREATE TABLE `ranks` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `required_amount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `ranks`
--

INSERT INTO `ranks` (`id`, `name`, `required_amount`) VALUES
(1, 'Bronze', 100000.00),
(2, 'Silver', 500000.00),
(3, 'Gold', 2000000.00),
(4, 'Platinum', 10000000.00),
(5, 'Diamond', 50000000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `seller_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `rating` int(11) NOT NULL DEFAULT 0,
  `review` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `server_cronjobs`
--

CREATE TABLE `server_cronjobs` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `usage_limit` int(11) NOT NULL,
  `current_usage` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `discount_percent` int(11) DEFAULT 0,
  `discount_valid_until` timestamp NULL DEFAULT NULL,
  `status` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `site_counters`
--

CREATE TABLE `site_counters` (
  `id` int(11) NOT NULL,
  `counter_key` varchar(50) NOT NULL,
  `counter_value` bigint(20) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `site_counters`
--

INSERT INTO `site_counters` (`id`, `counter_key`, `counter_value`) VALUES
(1, 'site_views', 266274);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `site_settings`
--

CREATE TABLE `site_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `site_settings`
--

INSERT INTO `site_settings` (`id`, `setting_key`, `setting_value`, `updated_at`) VALUES
(1, 'page_title', 'Unlock Link', '2026-03-21 15:39:26'),
(2, 'page_desc', 'Hoàn thành các bước để mở khóa link', '2026-03-21 15:39:26'),
(3, 'btn_color', '#ff1e1e', '2026-03-21 15:39:26'),
(4, 'task_delay', '5', '2026-03-21 15:39:26');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `states`
--

CREATE TABLE `states` (
  `chat_id` bigint(20) NOT NULL,
  `state` varchar(50) NOT NULL,
  `temp_uid` varchar(100) DEFAULT NULL,
  `temp_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbl_addon_vps`
--

CREATE TABLE `tbl_addon_vps` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type_addon` varchar(255) DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `price` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `site` varchar(50) NOT NULL DEFAULT 'VNCLOUD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbl_cloudvps`
--

CREATE TABLE `tbl_cloudvps` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `detail` longtext DEFAULT NULL,
  `pricing` longtext DEFAULT NULL,
  `price` longtext DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `site` varchar(50) NOT NULL DEFAULT 'VNCLOUD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbl_coupons`
--

CREATE TABLE `tbl_coupons` (
  `id` int(11) NOT NULL,
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `used` int(11) NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  `min` int(11) NOT NULL DEFAULT 1000,
  `max` int(11) NOT NULL DEFAULT 10000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbl_coupon_used`
--

CREATE TABLE `tbl_coupon_used` (
  `id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `trans_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `createdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tbl_purchased_cloudvps`
--

CREATE TABLE `tbl_purchased_cloudvps` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `vps_id` int(11) DEFAULT 0,
  `billingcycle` text DEFAULT NULL,
  `billingcycleday` int(11) DEFAULT 0,
  `info` longtext DEFAULT NULL,
  `status` text DEFAULT NULL,
  `price` int(11) DEFAULT 0,
  `cost` int(11) DEFAULT 0,
  `total_price` int(11) DEFAULT 0,
  `total_cost` int(11) DEFAULT 0,
  `notified` enum('no','yes') DEFAULT 'no',
  `notification_expired` enum('no','yes') DEFAULT 'no',
  `notification_delete` enum('no','yes') DEFAULT 'no',
  `created_at` text DEFAULT NULL,
  `updated_at` text DEFAULT NULL,
  `site` varchar(50) DEFAULT 'VNCLOUD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Đang đổ dữ liệu cho bảng `tbl_purchased_cloudvps`
--

INSERT INTO `tbl_purchased_cloudvps` (`id`, `user_id`, `vps_id`, `billingcycle`, `billingcycleday`, `info`, `status`, `price`, `cost`, `total_price`, `total_cost`, `notified`, `notification_expired`, `notification_delete`, `created_at`, `updated_at`, `site`) VALUES
(1, 65, 1, 'monthly', 30, NULL, NULL, 200000, 200000, 200000, 200000, 'no', 'no', 'no', '2026/03/14 14:29:25', '2026/03/14 14:29:25', 'CLOUDNEST');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tb_pusher`
--

CREATE TABLE `tb_pusher` (
  `id` int(10) UNSIGNED NOT NULL,
  `pusher_app_id` varchar(255) NOT NULL,
  `pusher_cluster` varchar(255) NOT NULL,
  `pusher_key` varchar(255) NOT NULL,
  `pusher_secret` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tracking`
--

CREATE TABLE `tracking` (
  `id` int(11) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `uid` varchar(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `unlock_links`
--

CREATE TABLE `unlock_links` (
  `id` int(11) NOT NULL,
  `display_name` varchar(200) NOT NULL,
  `target_url` varchar(1000) NOT NULL,
  `locked_text` varchar(200) DEFAULT '? Đăng ký để tiếp tục',
  `unlocked_text` varchar(200) DEFAULT '? Truy cập link gốc',
  `description` varchar(500) DEFAULT '',
  `is_active` tinyint(1) DEFAULT 1,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `unlock_links`
--

INSERT INTO `unlock_links` (`id`, `display_name`, `target_url`, `locked_text`, `unlocked_text`, `description`, `is_active`, `sort_order`, `created_at`) VALUES
(11, 'Link tool sky children', 'https://codevip.fun/me/skygame.html', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download tool game', 1, 1, '2026-03-22 05:38:09'),
(12, 'Link tải menu 8 ball pool', 'https://codevip.fun/me/modmenu.html', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download menu hack', 1, 1, '2026-03-22 05:44:47'),
(13, 'Link Mod Menu Shadow Fight 2', 'https://link4m.com/TgWBd4k', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download Shadow Fight 2 mod', 1, 1, '2026-03-22 05:49:08'),
(14, 'Link mod Subway Surfers', 'https://link4m.com/HHnAd', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Dowload tool game', 1, 1, '2026-03-22 18:45:44'),
(15, 'Link Mod Block Blast! MOD APK v9.4.5', 'https://link4m.com/kd95yhy', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download Block Blast! MOD APK v9.4.5', 1, 1, '2026-03-24 06:27:17'),
(16, 'Link Mod Hill Climb Racing', 'https://link4m.net/zE1vxOj', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download Hill Climb Racing', 1, 1, '2026-03-26 07:01:10'),
(17, 'Link Mod Mod Car Simulator 2', 'https://link4m.com/JUTk6P', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download Mod Car Simulator 2 ', 1, 1, '2026-03-27 06:43:05'),
(18, 'Link tải Epic Stickman: Idle RPG War Apk', 'https://link4m.net/evPCZ', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download Epic Stickman: Idle RPG War Apk', 1, 1, '2026-04-01 08:41:30'),
(19, 'Link tải Heroes vs Hordes Mod APK v8.2.0', 'https://link4m.net/goWRso', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Link tải Heroes vs Hordes Mod APK v8.2.0', 1, 1, '2026-04-08 05:54:27'),
(20, 'link tải clone v7', 'https://link4m.com/taYkQU7u', '🔒 Đăng ký để tiếp tục', '🔓 Truy cập link gốc', 'Download clone v7', 1, 1, '2026-04-18 20:08:51');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` text DEFAULT NULL,
  `password` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `email` text DEFAULT NULL,
  `level` text DEFAULT NULL,
  `rank_id` int(11) NOT NULL DEFAULT 0,
  `ctv` int(11) DEFAULT 0,
  `token` text DEFAULT NULL,
  `ip` text DEFAULT NULL,
  `device` text DEFAULT NULL,
  `otp` text DEFAULT NULL,
  `token_password` text CHARACTER SET utf8 COLLATE utf8_vietnamese_ci DEFAULT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  `total_money` int(11) NOT NULL DEFAULT 0,
  `chietkhau` int(11) NOT NULL DEFAULT 0,
  `banned` int(11) NOT NULL DEFAULT 0,
  `telegram_id` text DEFAULT NULL,
  `telegram_token` text DEFAULT NULL,
  `status_telegram` int(11) NOT NULL DEFAULT 0,
  `create_date` text DEFAULT NULL,
  `time_session` text DEFAULT NULL,
  `time_request` int(11) DEFAULT 0,
  `login_attempts` int(11) DEFAULT 0,
  `provider` text DEFAULT NULL,
  `provider_id` text DEFAULT NULL,
  `secretkey` text DEFAULT NULL,
  `status_2fa` int(11) DEFAULT 0,
  `ref_id` int(11) DEFAULT 0,
  `ref_click` int(11) DEFAULT 0,
  `ref_money` int(11) DEFAULT 0,
  `ref_total_money` int(11) DEFAULT 0,
  `ref_amount` int(11) DEFAULT 0,
  `ref_ck` int(11) DEFAULT 0,
  `wallet` int(11) DEFAULT 0,
  `noti_extend` int(11) DEFAULT 0,
  `profile_picture` text DEFAULT NULL,
  `address` text DEFAULT NULL,
  `skill` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `contact_links` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `product_amount` int(11) NOT NULL DEFAULT 0,
  `product_total_amount` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `visitor_logs`
--

CREATE TABLE `visitor_logs` (
  `id` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `page_url` varchar(500) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `isp` varchar(200) DEFAULT NULL,
  `device_type` varchar(20) DEFAULT '',
  `os` varchar(100) DEFAULT '',
  `browser` varchar(100) DEFAULT '',
  `latitude` varchar(20) DEFAULT '',
  `longitude` varchar(20) DEFAULT '',
  `user_agent` text DEFAULT NULL,
  `visited_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `visitor_logs`
--

INSERT INTO `visitor_logs` (`id`, `ip_address`, `page_url`, `country`, `city`, `region`, `isp`, `device_type`, `os`, `browser`, `latitude`, `longitude`, `user_agent`, `visited_at`) VALUES
(1, '113.23.103.198', '/contact', 'Vietnam', 'Ho Chi Minh City', 'Ho Chi Minh', 'FPT Telecom Company', 'desktop', 'Windows 10/11', 'Chrome', '10.822', '106.6257', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-28 23:00:47');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `visit_logs`
--

CREATE TABLE `visit_logs` (
  `id` int(11) NOT NULL,
  `link_id` int(11) DEFAULT NULL COMMENT 'NULL = trang chủ',
  `ip` varchar(64) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `event` varchar(50) DEFAULT 'pageview' COMMENT 'pageview|click_channel|unlock',
  `channel_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `whm_info`
--

CREATE TABLE `whm_info` (
  `id` int(11) NOT NULL,
  `ip` text DEFAULT NULL,
  `username` text DEFAULT NULL,
  `password` text DEFAULT NULL,
  `status` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `withdraw_ref`
--

CREATE TABLE `withdraw_ref` (
  `id` int(11) NOT NULL,
  `trans_id` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `bank` text DEFAULT NULL,
  `stk` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `amount` int(11) DEFAULT 0,
  `status` int(11) DEFAULT 0,
  `create_gettime` datetime DEFAULT NULL,
  `update_gettime` datetime DEFAULT NULL,
  `reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `youtube_channels`
--

CREATE TABLE `youtube_channels` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `url` varchar(500) NOT NULL,
  `sort_order` int(11) DEFAULT 0,
  `is_required` tinyint(1) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `youtube_channels`
--

INSERT INTO `youtube_channels` (`id`, `name`, `url`, `sort_order`, `is_required`, `is_active`, `created_at`) VALUES
(1, 'Đăng ký kênh YouTube', 'https://www.youtube.com/@modgameviet2025', 1, 1, 1, '2026-03-21 15:39:26'),
(2, 'Đăng ký kênh YouTube', 'https://www.youtube.com/@tienwtee', 2, 1, 1, '2026-03-21 15:39:26'),
(3, 'Đăng ký kênh YouTube', 'https://www.youtube.com/@skygamemods', 3, 1, 1, '2026-03-21 15:39:26'),
(4, 'Đăng ký kênh YouTube', 'https://www.youtube.com/@Gamemodviet', 4, 1, 1, '2026-03-22 05:41:03'),
(5, 'Đăng ký kênh telegram', 'https://t.me/+n-R5qYtS6mQxMTBl', 1, 1, 1, '2026-04-18 20:09:28');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `auth_tokens`
--
ALTER TABLE `auth_tokens`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `bank`
--
ALTER TABLE `bank`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `trans_id` (`trans_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Chỉ mục cho bảng `cronjobs`
--
ALTER TABLE `cronjobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `design_config`
--
ALTER TABLE `design_config`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `history_captcha`
--
ALTER TABLE `history_captcha`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `hosting_packages`
--
ALTER TABLE `hosting_packages`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `link_channels`
--
ALTER TABLE `link_channels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_link_channel` (`link_id`,`channel_id`),
  ADD KEY `idx_link_id` (`link_id`),
  ADD KEY `idx_channel_id` (`channel_id`);

--
-- Chỉ mục cho bảng `list_vps`
--
ALTER TABLE `list_vps`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `log_balance`
--
ALTER TABLE `log_balance`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `log_ref`
--
ALTER TABLE `log_ref`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `options`
--
ALTER TABLE `options`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `order_vps`
--
ALTER TABLE `order_vps`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `os_vps`
--
ALTER TABLE `os_vps`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `post_category`
--
ALTER TABLE `post_category`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `idx_short_code` (`short_code`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_group_id` (`group_id`),
  ADD KEY `idx_is_latest` (`is_latest`);

--
-- Chỉ mục cho bảng `product_groups`
--
ALTER TABLE `product_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `product_hashtags`
--
ALTER TABLE `product_hashtags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `product_withdraw`
--
ALTER TABLE `product_withdraw`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `purchased_hosting`
--
ALTER TABLE `purchased_hosting`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `ranks`
--
ALTER TABLE `ranks`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `server_cronjobs`
--
ALTER TABLE `server_cronjobs`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `site_counters`
--
ALTER TABLE `site_counters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `counter_key` (`counter_key`);

--
-- Chỉ mục cho bảng `site_settings`
--
ALTER TABLE `site_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Chỉ mục cho bảng `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`chat_id`);

--
-- Chỉ mục cho bảng `tbl_addon_vps`
--
ALTER TABLE `tbl_addon_vps`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tbl_cloudvps`
--
ALTER TABLE `tbl_cloudvps`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tbl_coupon_used`
--
ALTER TABLE `tbl_coupon_used`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tbl_purchased_cloudvps`
--
ALTER TABLE `tbl_purchased_cloudvps`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tracking`
--
ALTER TABLE `tracking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uix_chat_uid` (`chat_id`,`uid`);

--
-- Chỉ mục cho bảng `unlock_links`
--
ALTER TABLE `unlock_links`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `visitor_logs`
--
ALTER TABLE `visitor_logs`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `visit_logs`
--
ALTER TABLE `visit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_link_id` (`link_id`),
  ADD KEY `idx_event` (`event`),
  ADD KEY `idx_created` (`created_at`);

--
-- Chỉ mục cho bảng `whm_info`
--
ALTER TABLE `whm_info`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `withdraw_ref`
--
ALTER TABLE `withdraw_ref`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `youtube_channels`
--
ALTER TABLE `youtube_channels`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `auth_tokens`
--
ALTER TABLE `auth_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=692;

--
-- AUTO_INCREMENT cho bảng `bank`
--
ALTER TABLE `bank`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `cards`
--
ALTER TABLE `cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `cronjobs`
--
ALTER TABLE `cronjobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT cho bảng `design_config`
--
ALTER TABLE `design_config`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `history_captcha`
--
ALTER TABLE `history_captcha`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `hosting_packages`
--
ALTER TABLE `hosting_packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT cho bảng `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `link_channels`
--
ALTER TABLE `link_channels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `list_vps`
--
ALTER TABLE `list_vps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `log_balance`
--
ALTER TABLE `log_balance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `log_ref`
--
ALTER TABLE `log_ref`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `options`
--
ALTER TABLE `options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=150;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `order_vps`
--
ALTER TABLE `order_vps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `os_vps`
--
ALTER TABLE `os_vps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `post_category`
--
ALTER TABLE `post_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_groups`
--
ALTER TABLE `product_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_hashtags`
--
ALTER TABLE `product_hashtags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `image_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `product_withdraw`
--
ALTER TABLE `product_withdraw`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `purchased_hosting`
--
ALTER TABLE `purchased_hosting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `ranks`
--
ALTER TABLE `ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `server_cronjobs`
--
ALTER TABLE `server_cronjobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `site_counters`
--
ALTER TABLE `site_counters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `site_settings`
--
ALTER TABLE `site_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `states`
--
ALTER TABLE `states`
  MODIFY `chat_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tbl_addon_vps`
--
ALTER TABLE `tbl_addon_vps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tbl_cloudvps`
--
ALTER TABLE `tbl_cloudvps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tbl_coupons`
--
ALTER TABLE `tbl_coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tbl_coupon_used`
--
ALTER TABLE `tbl_coupon_used`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tbl_purchased_cloudvps`
--
ALTER TABLE `tbl_purchased_cloudvps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tracking`
--
ALTER TABLE `tracking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `unlock_links`
--
ALTER TABLE `unlock_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `visitor_logs`
--
ALTER TABLE `visitor_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `visit_logs`
--
ALTER TABLE `visit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `whm_info`
--
ALTER TABLE `whm_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `withdraw_ref`
--
ALTER TABLE `withdraw_ref`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `youtube_channels`
--
ALTER TABLE `youtube_channels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ràng buộc đối với các bảng kết xuất
--

--
-- Ràng buộc cho bảng `cronjobs`
--
ALTER TABLE `cronjobs`
  ADD CONSTRAINT `cronjobs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Ràng buộc cho bảng `product_hashtags`
--
ALTER TABLE `product_hashtags`
  ADD CONSTRAINT `product_hashtags_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
