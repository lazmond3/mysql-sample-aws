CREATE TABLE `tweet` (
    `tweet_id_str` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `user_id_str` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `user_screen_name` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `user_name` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `content` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    `favorited_count` bigint NOT NULL,
    `retweeted_count` bigint NOT NULL,
    `image_url_1` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `image_url_2` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `image_url_3` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `image_url_4` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `video_url` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    PRIMARY KEY (`tweet_id_str`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_bin