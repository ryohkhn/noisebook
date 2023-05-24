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
