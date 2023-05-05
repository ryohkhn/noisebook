-- Top 5 users with the highest number of followers.
SELECT u.user_id, u.username, COUNT(f.followed_id) AS follower_count
FROM user u
JOIN follows f ON u.user_id = f.followed_id
GROUP BY u.user_id, u.username
ORDER BY follower_count DESC
LIMIT 5;

-- Top 5 musicians who played in the most number of tracks.
SELECT m.musician_id, m.name, COUNT(pt.track_id) AS track_count
FROM musician m

-- Average ticket price of all finished concerts grouped by place.
SELECT p.place_id, p.place_name, AVG(fc.ticket_price) AS avg_ticket_price
FROM finished_concert fc
JOIN place p ON fc.place_id = p.place_id
GROUP BY p.place_id, p.place_name;

-- 3 most popular genres based on the number of sub-genres.
SELECT g.genre_id, g.genre_title, COUNT(sg.sub_genre_title) AS sub_genre_count
FROM genre g
JOIN sub_genre sg ON g.genre_id = sg.parent_genre
GROUP BY g.genre_id, g.genre_title
ORDER BY sub_genre_count DESC
LIMIT 3;

-- Top 5 tracks with the highest average review grade.
SELECT t.track_id, t.title, AVG(tr.review_grade) AS avg_review_grade
FROM track t
JOIN track_review tr ON t.track_id = tr.track_id
GROUP BY t.track_id, t.title
ORDER BY avg_review_grade DESC
LIMIT 5;

-- Top 3 cities with the highest number of concerts.
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

-- Number of concerts organized by each organizer.
SELECT o.ortganizateur_id, o.ortganizateur_name, COUNT(fc.concert_id) + COUNT(fnc.concert_id) AS concert_count
FROM organizer o
LEFT JOIN finished_concert fc ON o.user_id = fc.place_id
LEFT JOIN future_concert fnc ON o.user_id = fnc.place_id
GROUP BY o.ortganizateur_id, o.ortganizateur_name;

-- Users who follow more than 10 other users but have no followers themselves.
SELECT u1.user_id, u1.username
FROM user u1
WHERE (
  SELECT COUNT(*)
  FROM follows f
  WHERE f.follower_id = u1.user_id
) > 10
AND NOT EXISTS (
  SELECT 1
  FROM follows f
  WHERE f.followed_id = u1.user_id
);

-- Top 3 places with the highest number of future concerts.
SELECT p.place_id, p.place_name, COUNT(fc.concert_id) AS future_concert_count
FROM place p
JOIN future_concert fc ON p.place_id = fc.place_id
GROUP BY p.place_id, p.place_name
ORDER BY future_concert_count DESC
LIMIT 3;

-- Users who have given more than 5 reviews to finished concerts with an average review grade greater than 4.
SELECT cr.user_id, u.username, COUNT(cr.concert_id) AS review_count, AVG(cr.review_grade) AS avg_review_grade
FROM concert_review cr
JOIN user u ON cr.user_id = u.user_id
GROUP BY cr.user_id, u.username
HAVING COUNT(cr.concert_id) > 5 AND AVG(cr.review_grade) > 4;
