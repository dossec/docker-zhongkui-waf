ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '6CsIaDsfRike';

--
-- Current Database: `zhongkui_waf`
--

CREATE DATABASE IF NOT EXISTS `zhongkui_waf` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `zhongkui_waf`;

--
-- Table structure for table `attack_log`
--

CREATE TABLE IF NOT EXISTS `attack_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `request_id` char(20) NOT NULL COMMENT '请求id',
  `ip` varchar(39) NOT NULL COMMENT 'ip地址',
  `ip_country_code` char(2) DEFAULT NULL COMMENT 'ip所属国家代码',
  `ip_country_cn` varchar(255) DEFAULT NULL COMMENT 'ip所属国家_中文',
  `ip_country_en` varchar(255) DEFAULT NULL COMMENT 'ip所属国家_英文',
  `ip_province_code` varchar(50) DEFAULT NULL COMMENT 'ip所属省份代码',
  `ip_province_cn` varchar(255) DEFAULT NULL COMMENT 'ip所属省份_中文',
  `ip_province_en` varchar(255) DEFAULT NULL COMMENT 'ip所属省份_英文',
  `ip_city_code` varchar(50) DEFAULT NULL COMMENT 'ip所属城市代码',
  `ip_city_cn` varchar(255) DEFAULT NULL COMMENT 'ip所属城市_中文',
  `ip_city_en` varchar(255) DEFAULT NULL COMMENT 'ip所属城市_英文',
  `ip_longitude` decimal(10,7) DEFAULT NULL COMMENT 'ip地理位置经度',
  `ip_latitude` decimal(10,7) DEFAULT NULL COMMENT 'ip地理位置纬度',
  `http_method` varchar(20) DEFAULT NULL COMMENT '请求http方法',
  `server_name` varchar(100) DEFAULT NULL COMMENT '请求域名',
  `user_agent` varchar(255) DEFAULT NULL COMMENT '请求客户端ua',
  `referer` varchar(2048) DEFAULT NULL COMMENT 'referer',
  `request_protocol` varchar(50) DEFAULT NULL COMMENT '请求协议',
  `request_uri` varchar(2048) DEFAULT NULL COMMENT '请求uri',
  `request_body` mediumtext COMMENT '请求体',
  `http_status` smallint unsigned NOT NULL COMMENT 'http响应状态码',
  `response_body` mediumtext COMMENT '响应体',
  `request_time` datetime NOT NULL,
  `attack_type` varchar(200) DEFAULT NULL COMMENT '攻击类型',
  `severity_level` varchar(20) DEFAULT NULL COMMENT '危险级别',
  `security_module` varchar(255) DEFAULT NULL COMMENT '安全模块',
  `hit_rule` varchar(500) DEFAULT NULL COMMENT '命中规则',
  `action` varchar(100) DEFAULT NULL COMMENT '处置动作',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=654 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `ip_block_log`
--

CREATE TABLE IF NOT EXISTS `ip_block_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `request_id` char(20) DEFAULT NULL COMMENT '请求id',
  `ip` varchar(39) NOT NULL COMMENT 'ip地址',
  `ip_country_code` char(2) DEFAULT NULL COMMENT 'ip所属国家代码',
  `ip_country_cn` varchar(255) DEFAULT NULL COMMENT 'ip所属国家_中文',
  `ip_country_en` varchar(255) DEFAULT NULL COMMENT 'ip所属国家_英文',
  `ip_province_code` varchar(50) DEFAULT NULL COMMENT 'ip所属省份代码',
  `ip_province_cn` varchar(255) DEFAULT NULL COMMENT 'ip所属省份_中文',
  `ip_province_en` varchar(255) DEFAULT NULL COMMENT 'ip所属省份_英文',
  `ip_city_code` varchar(50) DEFAULT NULL COMMENT 'ip所属城市代码',
  `ip_city_cn` varchar(255) DEFAULT NULL COMMENT 'ip所属城市_中文',
  `ip_city_en` varchar(255) DEFAULT NULL COMMENT 'ip所属城市_英文',
  `ip_longitude` decimal(10,7) DEFAULT NULL COMMENT 'ip地理位置经度',
  `ip_latitude` decimal(10,7) DEFAULT NULL COMMENT 'ip地理位置纬度',
  `block_reason` varchar(200) DEFAULT NULL COMMENT '封禁原因',
  `start_time` datetime NOT NULL COMMENT '封禁开始时间',
  `block_duration` int DEFAULT NULL COMMENT '封禁时长',
  `end_time` datetime DEFAULT NULL COMMENT '封禁结束时间',
  `block_times` int DEFAULT NULL COMMENT '封禁请求次数',
  `action` varchar(100) DEFAULT NULL COMMENT '处置动作',
  `unblock_time` datetime DEFAULT NULL COMMENT '解封时间',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_ip_block_log_ip_start_time` (`ip`,`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Table structure for table `traffic_stats`
--

CREATE TABLE IF NOT EXISTS `traffic_stats` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ip_country_code` char(2) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属国家代码',
  `ip_country_cn` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属国家_中文',
  `ip_country_en` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属国家_英文',
  `ip_province_code` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属省份代码',
  `ip_province_cn` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属省份_中文',
  `ip_province_en` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属省份_英文',
  `ip_city_code` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属城市代码',
  `ip_city_cn` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属城市_中文',
  `ip_city_en` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip所属城市_英文',
  `request_times` int unsigned NOT NULL DEFAULT '0' COMMENT '请求数',
  `attack_times` int unsigned NOT NULL DEFAULT '0' COMMENT '攻击请求数',
  `block_times` int unsigned NOT NULL DEFAULT '0' COMMENT '拦截数',
  `request_date` char(10) COLLATE utf8mb4_bin NOT NULL COMMENT '日期',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_traffic_stats_request_date` (`ip_country_code`,`ip_province_en`,`ip_city_en`,`request_date`)
) ENGINE=InnoDB AUTO_INCREMENT=202769 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Table structure for table `waf_status`
--

CREATE TABLE IF NOT EXISTS `waf_status` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `http4xx` int unsigned NOT NULL DEFAULT '0' COMMENT 'http状态码4xx数',
  `http5xx` int unsigned NOT NULL DEFAULT '0' COMMENT 'http状态码5xx数',
  `request_times` int unsigned NOT NULL DEFAULT '0' COMMENT '请求数',
  `attack_times` int unsigned NOT NULL DEFAULT '0' COMMENT '攻击请求数',
  `block_times` int unsigned NOT NULL DEFAULT '0' COMMENT '拦截数',
  `request_date` char(10) NOT NULL COMMENT '日期',
  `update_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_waf_status_request_date` (`request_date`)
) ENGINE=InnoDB AUTO_INCREMENT=171165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
