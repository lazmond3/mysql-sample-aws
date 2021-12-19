import mysql.connector
from dataclasses import dataclass
import json
from glob import glob
from typing import Optional

conn = mysql.connector.connect(
    host='main.cdx787qeoakd.ap-northeast-1.rds.amazonaws.com',
    port='3306',
    user='root',
    password=os.getenv("PASSWORD"),
    database='twitter_db'
)


@dataclass
class Tweet:
    tweet_id_str: str
    user_id_str: str
    user_screen_name: str
    user_name: str
    content: str
    favorited_count: int
    retweeted_count: int
    created_at: str
    image_url_1: Optional[str] = None
    image_url_2: Optional[str] = None
    image_url_3: Optional[str] = None
    image_url_4: Optional[str] = None
    video_url: Optional[str] = None


def tweet_data():
    js_files = glob("data/dump_tweet_of_user/dump_user_*.json")

    i = 0
    # DB操作用にカーソルを作成
    cur = conn.cursor()
    for jsfile in js_files:
        with open(jsfile) as f:
            tweets = json.load(f)
        twlist = []
        for tweet in tweets:
            try:
                print(f"tweet: {tweet['id_str']}")
            except Exception as e:
                print(f"tw: {tweet} jsfile: {jsfile}", e)
                break
                # print("duplicate: ", twlist[-1][0])
                # print(twlist[-1])
            tw = Tweet(
                tweet_id_str=tweet["id_str"],
                user_id_str=tweet["user"]["id_str"],
                user_screen_name=tweet["user"]["screen_name"],
                user_name=tweet["user"]["name"],
                content=tweet["full_text"],
                favorited_count=tweet["favorite_count"],
                retweeted_count=tweet["retweet_count"],
                created_at=tweet["created_at"]
            )
            # twlist.append(tw)
            twlist.append((
                tw.tweet_id_str,
                tw.user_id_str,
                tw.user_screen_name,
                tw.user_name,
                tw.content,
                tw.favorited_count,
                tw.retweeted_count,
                tw.created_at,
            ))

            try:
                # print(f"tweet: {tweet['id_str']}")

                cur.execute(
                    """
                    INSERT INTO tweet (
                        tweet_id_str,
                        user_id_str,
                        user_screen_name,
                        user_name,
                        content,
                        favorited_count,
                        retweeted_count,
                        created_at
                    ) 
                    VALUES (%s,%s,%s,%s, %s,%s,%s,%s)
                    """,
                    twlist[-1]
                )
            except mysql.connector.errors.IntegrityError:
                pass
            except Exception as e:
                print(f"tw: {tweet} ", e)
                print("duplicate: ", twlist[-1][0])
                print(twlist[-1])

        conn.commit()

    conn.close()


if __name__ == "__main__":
    tweet_data()
