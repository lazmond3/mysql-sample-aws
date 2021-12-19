CREATE TABLE `user` (
    `id_str` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `screen_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `followers_count` int NOT NULL,
    `friends_count` int NOT NULL,
    `created_at` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `profile_image_url_https` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    PRIMARY KEY (`id_str`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_bin