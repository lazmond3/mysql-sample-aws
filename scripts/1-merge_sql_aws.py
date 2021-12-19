import mysql.connector
import json
import os
from glob import glob

conn = mysql.connector.connect(
    host='main.cdx787qeoakd.ap-northeast-1.rds.amazonaws.com',
    port='3306',
    user='root',
    password=os.getenv("PASSWORD"),
    database='twitter_db'
)


def merge():
    js_files = glob("data/dump_following/*.json")

    users = []
    for j_file in js_files:
        with open(j_file) as f:
            js = json.load(f)
        for user in js["users"]:
            users.append(user)
        print(f"({j_file}) count of users : {len(js['users'])}")

    print("----------------")
    print(f"total count of users: {len(users)}")

    with open("dump_following.json", "w") as f:
        dic = {
            "users": users
        }
        json.dump(dic, f)


def insert():
    # DB操作用にカーソルを作成
    cur = conn.cursor()
    # id, name, priceを持つテーブルを（すでにあればいったん消してから）作成
    cur.execute("DROP TABLE IF EXISTS `user`")
    cur.execute("""CREATE TABLE IF NOT EXISTS `user` (
        `id_str` varchar(100) NOT NULL,
        `name` varchar(128) COLLATE utf8mb4_bin NOT NULL,
        `screen_name` varchar(128) COLLATE utf8mb4_bin NOT NULL,
        `description` varchar(500) COLLATE utf8mb4_bin NOT NULL,
        `followers_count` int(11) COLLATE utf8mb4_bin NOT NULL,
        `friends_count` int(11) COLLATE utf8mb4_bin NOT NULL,
        `created_at` varchar(55) COLLATE utf8mb4_bin NOT NULL,
        `profile_image_url_https` varchar(255) COLLATE utf8mb4_bin NOT NULL,
        PRIMARY KEY (id_str)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin""")

    with open("data/dump_following.json") as f:
        js = json.load(f)
    users = js["users"]
    users = list(map(lambda x: (
        x["id_str"],
        x["name"],
        x["screen_name"],
        x["description"],
        x["followers_count"],
        x["friends_count"],
        x["created_at"],
        x["profile_image_url_https"]
    ), users))

    cur.executemany(
        "INSERT INTO user (id_str, name, screen_name, description, followers_count, friends_count, created_at, profile_image_url_https) VALUES (%s,%s,%s,%s, %s,%s,%s,%s)", users)
    conn.commit()
    conn.close()


if __name__ == "__main__":
    merge()
    insert()
