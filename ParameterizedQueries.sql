-- Following hierarchy with a parameterized inital user id
PREPARE following_hierarchy(INT) AS
WITH RECURSIVE following_hierarchy AS (
    SELECT followed_id AS user_id,1 AS level,follower_id
    FROM follows WHERE follower_id = $1
    UNION
    SELECT f.followed_id AS user_id,fh.level + 1 AS level,f.follower_id
    FROM follows f JOIN following_hierarchy fh ON f.follower_id = fh.user_id)
SELECT u.user_id, u.username, fh.follower_id, fh.level
FROM following_hierarchy fh
JOIN users u ON u.user_id = fh.user_id;

EXECUTE following_hierarchy(1);


SELECT v.concert_id, v.concert_name, v.concert_date, v.start_time, v.genre_title, v.sub_genre_title
FROM upcoming_concerts_view v
JOIN place p ON v.place_id = p.place_id
WHERE p.city = [city_name];
