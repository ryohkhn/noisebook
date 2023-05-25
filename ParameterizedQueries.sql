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


-- Upcoming concerts on a given city
DROP VIEW IF EXISTS upcoming_concerts_view;
CREATE VIEW upcoming_concerts_view AS
SELECT fc.concert_id, fc.concert_name, fc.concert_date, fc.start_time, g.genre_title, sg.sub_genre_title, fc.place_id
FROM future_concert fc
LEFT JOIN future_concert_genre fcg ON fc.concert_id = fcg.concert_id
LEFT JOIN future_concert_sub_genre fcsg ON fc.concert_id = fcsg.concert_id
LEFT JOIN genre g ON fcg.genre_id = g.genre_id
LEFT JOIN sub_genre sg ON fcsg.sub_genre_id = sg.sub_genre_id;

PREPARE upcoming_concert_in_city(TEXT) AS
SELECT v.concert_id, v.concert_name, v.concert_date, v.start_time, v.genre_title, v.sub_genre_title
FROM upcoming_concerts_view v
JOIN place p ON v.place_id = p.place_id
WHERE p.city = $1;


PREPARE user_playlists(INT) AS
WITH user_playlists AS (
    SELECT pl.playlist_id, pl.playlist_name, pl.description, u.username, u.user_id
    FROM playlist pl
    JOIN users u ON u.user_id = pl.user_id
)
SELECT up.playlist_name, up.description
FROM user_playlists up
WHERE up.user_id = $1;

--EXECUTE following_hierarchy(1);
--EXECUTE upcoming_concert_in_city('Barcelona');
