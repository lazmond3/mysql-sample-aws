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

conn.autocommit = True

# python3 hoge.py で実行すると、この部分が実行される。
if __name__ == "__main__":
    cur = conn.cursor()
    # id, name, priceを持つテーブルを（すでにあればいったん消してから）作成
    cur.execute("DROP TABLE IF EXISTS `sample_table`")
    cur.execute("""CREATE TABLE IF NOT EXISTS `sample_table` (
        `sample_table_id_str` varchar(100) NOT NULL,
        `text` varchar(128) COLLATE utf8mb4_bin NOT NULL,
        PRIMARY KEY (sample_table_id_str)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin""")

    挿入する値たち = [
        ("id1", "こんにちは！"),
        ("id2", "こんにち2！",)
    ]
    cur.executemany("""
    INSERT INTO sample_table (sample_table_id_str, text) VALUES (%s, %s)
    """, 挿入する値たち)

    cur.execute("""
    SELECT * FROM sample_table ORDER BY sample_table_id_str DESC
    """)
    for data in cur.fetchall():
        print(f"data: {data}")

    conn.close()
