-- Top 5 tracks with highest average grade, with at least 5 reviews, and their max grade.
-- Une requête qui porte sur au moins trois tables
SELECT AVG(r.review_grade) AS average_grade, MAX(r.review_grade) as max_grade, t.track_id, t.title
FROM review r JOIN track_review tr ON r.review_id = tr.review_id
JOIN track t ON tr.track_id = t.track_id
GROUP BY t.track_id, t.title
HAVING COUNT(r.review_id) >= 5
ORDER BY average_grade DESC
LIMIT 5;


-- People who follow each other.
-- Une ’auto jointure’ ou ’jointure réflexive’ (jointure de deux copies d’une même table)
SELECT f1.follower_id AS user_id1, f2.follower_id AS user_id2
FROM follows f1 JOIN follows f2
ON f1.follower_id = f2.followed_id AND f2.follower_id = f1.followed_id
WHERE f1.follower_id  < f2.follower_id;


-- Find the top 3 cities with the highest number of concerts.
-- Une sous-requête dans le FROM
SELECT p.city, COUNT(*) AS concert_count
FROM (
    SELECT concert_id, place_id FROM finished_concert
    UNION ALL
    SELECT concert_id, place_id FROM future_concert
) AS all_concerts
JOIN place p ON all_concerts.place_id = p.place_id
GROUP BY p.city
ORDER BY concert_count DESC
LIMIT 3;


-- Music groups that have an above average number of followers.
-- Une sous-requête corrélée
WITH average_followers AS(
    SELECT AVG(avg.follower_count) as average
    FROM (
        SELECT COUNT(*) AS follower_count
        FROM follows
        GROUP BY followed_id
    ) avg
)
SELECT g.group_name, COUNT(f.follower_id) AS follower_count
FROM groups g
JOIN follows f
ON g.user_id = f.followed_id
GROUP BY g.user_id, g.group_name
HAVING COUNT(f.follower_id) >= (SELECT average FROM average_followers);


-- Find the places that have not yet hosted any concert.
-- Une sous-requête dans le WHERE
SELECT place_id, place_name FROM place p
WHERE NOT EXISTS(
    SELECT place_id FROM finished_concert
    WHERE place_id = p.place_id
);


-- List the music groups that have performed in more than three different cities.
-- Deux agrégats nécessitant GROUP BY et HAVING
SELECT m.group_name, l.music_group_id, COUNT(DISTINCT place_id) as place_number
FROM finished_concert f
JOIN finished_concert_music_group_lineup l ON f.concert_id = l.concert_id
JOIN music_group m ON m.music_group_id = l.music_group_id
GROUP BY l.music_group_id, m.group_name
HAVING COUNT(DISTINCT place_id) >= 3;


-- Find the music group with the highest average number of attendees per concert.
-- Une requête impliquant le calcul de deux agrégats
WITH average_attendance_per_group AS(
    SELECT AVG(f.attendance) AS average_attendance
    FROM finished_concert f
    JOIN finished_concert_music_group_lineup l ON f.concert_id = l.concert_id
    GROUP BY l.music_group_id
)
SELECT MAX(average_attendance) FROM average_attendance_per_group;


-- Retrieve all music groups and the venues where they have performed
-- including those groups who have not yet performed.
-- Une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN)
SELECT m.artist_name, p.place_name
FROM musician m
LEFT JOIN finished_concert_musicians_lineup l ON m.musician_id = l.musician_id
LEFT JOIN finished_concert c ON c.concert_id = l.concert_id
LEFT JOIN place p ON c.place_id = p.place_id;


-- Find the top 3 music groups playing in concerts with the maximum capacity each month in 2023.
-- Une requête utilisant du fenêtrage
WITH monthly_ranks AS (
    SELECT m.group_name, c.concert_date, p.max_capacity,
      RANK() OVER(PARTITION BY DATE_TRUNC('month', c.concert_date) ORDER BY p.max_capacity DESC) as rank
    FROM music_group m
    JOIN future_concert_music_group_lineup fl ON m.music_group_id = fl.music_group_id
    JOIN future_concert c ON fl.concert_id = c.concert_id
    JOIN place p ON p.place_id = c.place_id
    WHERE DATE_PART('year', c.concert_date) = 2023
)
SELECT group_name, concert_date, max_capacity, rank
FROM monthly_ranks
WHERE rank <= 3;


-- Find the number of concerts organized by each organizer.
-- Une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN)
SELECT o.organizer_id, o.organizer_name, COUNT(fc.concert_id) AS concert_count
FROM organizers o
LEFT JOIN organizers_announce_concert oac ON oac.organizer_id = o.organizer_id
LEFT JOIN finished_concert fc ON oac.concert_id = fc.concert_id
GROUP BY o.organizer_id, o.organizer_name;


-- Find all the music groups that have organized more than 10 concerts.
-- Deux requêtes équivalentes exprimant une condition de totalité,
-- l’une avec des sous requêtes corrélées et
-- l’autre avec de l’agrégation ;
SELECT m.group_name
FROM music_group m
JOIN future_concert_music_group_lineup c ON m.music_group_id = c.music_group_id
GROUP BY m.group_name
HAVING COUNT(c.concert_id) >= 1;

SELECT m.group_name
FROM music_group m
WHERE (
  SELECT COUNT(*)
  FROM future_concert_music_group_lineup c
  WHERE m.music_group_id = c.music_group_id
) >= 1;


-- Deux requêtes qui renverraient le même résultat
-- si vos tables ne contenaient pas de nulls,
-- mais qui renvoient des résultats différents ici
SELECT username, bio
FROM users;

SELECT username, bio
FROM users
WHERE bio IS NOT NULL;


-- Find the the series of follows from user 1
-- Une requête récursive
WITH RECURSIVE following_hierarchy AS (
    SELECT followed_id AS user_id,1 AS level,follower_id
    FROM follows WHERE follower_id = 1
    UNION
    SELECT f.followed_id AS user_id,fh.level + 1 AS level,f.follower_id
    FROM follows f JOIN following_hierarchy fh ON f.follower_id = fh.user_id
)
SELECT u.user_id,u.username,fh.level,fh.follower_id
FROM following_hierarchy fh
JOIN users u ON u.user_id = fh.user_id;

-- Autres requêtes

-- Users who have given more than 5 reviews to finished concerts with an average review grade greater than 4.
SELECT cr.user_id, u.username, COUNT(cr.concert_id) AS review_count, AVG(r.review_grade) AS avg_review_grade
FROM concert_review cr
JOIN users u ON cr.user_id = u.user_id
JOIN review r ON cr.review_id = r.review_id
GROUP BY cr.user_id, u.username
HAVING COUNT(r.review_id) >= 5 AND AVG(r.review_grade) > 4;


-- Number of members for each group
SELECT DISTINCT m.music_group_id, m.group_name,
  COUNT(*) OVER (PARTITION BY m.music_group_id) AS num_members
FROM music_group m JOIN link_musician_music_group l ON m.music_group_id = l.music_group_id
ORDER BY m.music_group_id;


-- 15 requêtes

-- END
