DROP TABLE
    IF EXISTS genre, sub_genre,
    musician, music_group, track,
    track_genre, track_sub_genre,
    users, people, groups, organizers,
    follows, friendship, playlist, playlist_track,
    music_group_plays_track, musician_plays_track,
    place, future_concert, finished_concert,
    future_concert_genre, finished_concert_genre,
    future_concert_sub_genre, finished_concert_sub_genre,
    future_concert_musicians_lineup, future_concert_music_group_lineup,
    finished_concert_musicians_lineup, finished_concert_music_group_lineup,
    group_review, track_review, place_review,
    concert_review, post, media,
    tag, post_tag, review_tag, future_concert_tag,
    finished_concert_tag, place_tag, music_group_tag,
    genre_tag, sub_genre_tag, review,
    link_people_musician, link_musician_music_group,
    organizers_announce_concert, user_attends_concert CASCADE;

-- GENRES (2 tables)

CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    genre_title VARCHAR(40) NOT NULL,
    genre_description VARCHAR(255) NOT NULL
);

CREATE TABLE sub_genre (
    sub_genre_id SERIAL PRIMARY KEY,
    sub_genre_title VARCHAR(40) NOT NULL,
    sub_genre_description VARCHAR(255) NOT NULL,
    parent_genre INT,
    FOREIGN KEY (parent_genre) REFERENCES genre (genre_id)
);

-- BASE DATA ENTITIES (5 tables)

CREATE TABLE musician (
    musician_id SERIAL PRIMARY KEY,
    artist_name VARCHAR(40) NOT NULL
);

CREATE TABLE music_group (
    music_group_id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL
);

CREATE TABLE track (
    track_id SERIAL PRIMARY KEY,
    title VARCHAR(40) NOT NULL
);

CREATE TABLE track_genre(
    track_id INT,
    genre_id INT,
    FOREIGN KEY (track_id) REFERENCES track (track_id),
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id),
    PRIMARY KEY (track_id, genre_id)
);

CREATE TABLE track_sub_genre(
    track_id INT,
    sub_genre_id INT,
    FOREIGN KEY (track_id) REFERENCES track (track_id),
    FOREIGN KEY (sub_genre_id) REFERENCES sub_genre (sub_genre_id),
    PRIMARY KEY (track_id, sub_genre_id)
);

-- BASIC ENTITIES (4 tables)

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(40) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    bio VARCHAR(255),
    CHECK (email LIKE '%@%.%' AND email NOT LIKE '%@%@%' AND email NOT LIKE '%..%')
);

CREATE TABLE people (
    person_id SERIAL PRIMARY KEY,
    user_id INT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    birth_date DATE NOT NULL,
    sex CHARACTER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (birth_date <= (CURRENT_DATE - INTERVAL '13 years')),
    CHECK (sex IN ('M', 'F', 'O'))
);

CREATE TABLE groups (
    group_id SERIAL PRIMARY KEY,
    user_id INT,
    music_group_id INT,
    group_name VARCHAR(40) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (music_group_id) REFERENCES music_group (music_group_id) ON DELETE CASCADE
);

CREATE TABLE organizers (
    organizer_id SERIAL PRIMARY KEY,
    user_id INT,
    organizer_name VARCHAR(40) NOT NULL,
    location VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

-- PEOPLE, GROUP AND MUSICIAN RELATIONSHIP (2 tables)

CREATE TABLE link_people_musician (
    person_id INT,
    musician_id INT,
    FOREIGN KEY (person_id) REFERENCES people(person_id) ON DELETE CASCADE,
    FOREIGN KEY (musician_id) REFERENCES musician(musician_id) ON DELETE CASCADE,
    PRIMARY KEY (person_id,musician_id)
);

CREATE TABLE link_musician_music_group (
    musician_id INT,
    music_group_id INT,
    FOREIGN KEY (musician_id) REFERENCES musician(musician_id) ON DELETE CASCADE,
    FOREIGN KEY (music_group_id) REFERENCES music_group(music_group_id) ON DELETE CASCADE,
    PRIMARY KEY (musician_id,music_group_id)
);

-- FOLLOW AND FRIENDSHIP RELATIONSHIP (2 tables)

CREATE TABLE follows (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (followed_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CHECK(follower_id <> followed_id)
);

CREATE TABLE friendship (
    user1_id INT NOT NULL,
    user2_id INT NOT NULL,
    PRIMARY KEY (user1_id, user2_id),
    FOREIGN KEY (user1_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (user2_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CHECK(user1_id <> user2_id)
);

-- TRACKS AND PLAYLISTS (4 tables)

CREATE TABLE playlist (
    playlist_id SERIAL PRIMARY KEY,
    playlist_name VARCHAR(40) NOT NULL,
    description VARCHAR(255) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT,
    FOREIGN KEY (playlist_id) REFERENCES playlist (playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES track (track_id) ON DELETE CASCADE,
    PRIMARY KEY (playlist_id,track_id)
);

CREATE TABLE musician_plays_track (
    musician_id INT,
    track_id INT,
    FOREIGN KEY (musician_id) REFERENCES musician (musician_id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES track (track_id) ON DELETE CASCADE,
    PRIMARY KEY (musician_id, track_id)
);

CREATE TABLE music_group_plays_track (
    music_group_id INT,
    track_id INT,
    FOREIGN KEY (music_group_id) REFERENCES music_group(music_group_id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES track (track_id) ON DELETE CASCADE,
    PRIMARY KEY (music_group_id, track_id)
);

-- CONCERTS AND PLACES (12 tables)

CREATE TABLE place (
    place_id SERIAL PRIMARY KEY,
    place_name VARCHAR(40) NOT NULL,
    address VARCHAR(40) NOT NULL,
    city VARCHAR(40) NOT NULL,
    country VARCHAR(40) NOT NULL,
    exterior BOOLEAN NOT NULL,
    max_capacity INT NOT NULL,
    CHECK (max_capacity > 0)
);

CREATE TABLE future_concert (
    concert_id SERIAL PRIMARY KEY,
    concert_name VARCHAR(40) NOT NULL,
    concert_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    start_time TIME NOT NULL,
    ticket_price INT NOT NULL,
    children_allowed BOOLEAN NOT NULL DEFAULT false,
    place_id INT,
    FOREIGN KEY (place_id) REFERENCES place (place_id) ON DELETE CASCADE,
    CHECK(ticket_price >= 0)
);

CREATE TABLE finished_concert (
    concert_id SERIAL PRIMARY KEY,
    concert_name VARCHAR(40) NOT NULL,
    concert_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    start_time TIME NOT NULL,
    ticket_price INT NOT NULL,
    children_allowed BOOLEAN NOT NULL DEFAULT false,
    attendance INT NOT NULL,
    place_id INT,
    FOREIGN KEY (place_id) REFERENCES place (place_id) ON DELETE CASCADE,
    CHECK(ticket_price >= 0),
    CHECK(attendance >= 0)
);

CREATE TABLE future_concert_musicians_lineup (
    musician_id INT,
    concert_id INT,
    FOREIGN KEY (musician_id) REFERENCES musician (musician_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY (musician_id,concert_id)
);

CREATE TABLE future_concert_music_group_lineup (
    music_group_id INT,
    concert_id INT,
    FOREIGN KEY (music_group_id) REFERENCES music_group (music_group_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY (music_group_id,concert_id)
);

CREATE TABLE finished_concert_musicians_lineup (
    musician_id INT,
    concert_id INT,
    FOREIGN KEY (musician_id) REFERENCES musician (musician_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES finished_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY (musician_id,concert_id)
);

CREATE TABLE finished_concert_music_group_lineup (
    music_group_id INT,
    concert_id INT,
    FOREIGN KEY (music_group_id) REFERENCES music_group (music_group_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES finished_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY (music_group_id,concert_id)
);

CREATE TABLE organizers_announce_concert (
    organizer_id INT,
    concert_id INT,
    FOREIGN KEY (organizer_id) REFERENCES organizers (organizer_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY (organizer_id,concert_id)
);

CREATE TABLE user_attends_concert(
    user_id INT,
    concert_id INT,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id,concert_id)
);

CREATE TABLE future_concert_genre(
  concert_id INT,
  genre_id INT,
  FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
  PRIMARY KEY (concert_id, genre_id)
);

CREATE TABLE future_concert_sub_genre(
  concert_id INT,
  sub_genre_id INT,
  FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
  FOREIGN KEY (sub_genre_id) REFERENCES sub_genre (sub_genre_id) ON DELETE CASCADE,
  PRIMARY KEY (concert_id, sub_genre_id)
);

CREATE TABLE finished_concert_genre(
  concert_id INT,
  genre_id INT,
  FOREIGN KEY (concert_id) REFERENCES finished_concert (concert_id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
  PRIMARY KEY (concert_id, genre_id)
);

CREATE TABLE finished_concert_sub_genre(
  concert_id INT,
  sub_genre_id INT,
  FOREIGN KEY (concert_id) REFERENCES finished_concert (concert_id) ON DELETE CASCADE,
  FOREIGN KEY (sub_genre_id) REFERENCES sub_genre (sub_genre_id) ON DELETE CASCADE,
  PRIMARY KEY (concert_id, sub_genre_id)
);

-- REVIEWS (avis) (5 tables)

CREATE TABLE review (
    review_id SERIAL PRIMARY KEY,
    review_timestamp TIMESTAMP NOT NULL,
    review_grade INT NOT NULL,
    review_comment VARCHAR(255) NOT NULL,
    CHECK (review_grade >= 0 AND review_grade <= 10)
);

CREATE TABLE group_review (
    review_id INT,
    user_id INT,
    group_id INT,
    FOREIGN KEY (review_id) REFERENCES review (review_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES groups (group_id) ON DELETE CASCADE,
    UNIQUE(user_id, group_id),
    PRIMARY KEY (review_id, user_id, group_id)
);

CREATE TABLE track_review (
    review_id INT,
    user_id INT,
    track_id INT,
    FOREIGN KEY (review_id) REFERENCES review (review_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES track (track_id) ON DELETE CASCADE,
    UNIQUE(user_id, track_id),
    PRIMARY KEY (review_id, user_id, track_id)
);

CREATE TABLE place_review (
    review_id INT,
    user_id INT,
    place_id INT,
    FOREIGN KEY (review_id) REFERENCES review (review_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (place_id) REFERENCES place (place_id) ON DELETE CASCADE,
    UNIQUE(user_id, place_id),
    PRIMARY KEY (review_id, user_id, place_id)
);

CREATE TABLE concert_review (
    review_id INT,
    user_id INT,
    concert_id INT,
    FOREIGN KEY (review_id) REFERENCES review (review_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES finished_concert (concert_id) ON DELETE CASCADE,
    UNIQUE(user_id, concert_id),
    PRIMARY KEY (review_id, user_id, concert_id)
);

-- POSTS (2 tables)

CREATE TABLE post (
    post_id SERIAL PRIMARY KEY,
    post_timestamp TIMESTAMP NOT NULL,
    post_content VARCHAR(255) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE media (
    media_id SERIAL PRIMARY KEY,
    media_link VARCHAR(255) NOT NULL,
    post_id INT,
    FOREIGN KEY (post_id) REFERENCES post (post_id) ON DELETE CASCADE
);

-- TAGS (9 tables)

CREATE TABLE tag (
    tag_id SERIAL PRIMARY KEY,
    tag_content VARCHAR(255)
);

CREATE TABLE post_tag(
    tag_id INT,
    post_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post (post_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, post_id)
);

CREATE TABLE review_tag(
    tag_id INT,
    review_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (review_id) REFERENCES review (review_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, review_id)
);

CREATE TABLE future_concert_tag(
    tag_id INT,
    concert_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES future_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, concert_id)
);

CREATE TABLE finished_concert_tag(
    tag_id INT,
    concert_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (concert_id) REFERENCES finished_concert (concert_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, concert_id)
);

CREATE TABLE place_tag(
    tag_id INT,
    place_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (place_id) REFERENCES place (place_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, place_id)
);

CREATE TABLE music_group_tag(
    tag_id INT,
    group_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES music_group (music_group_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, group_id)
);

CREATE TABLE genre_tag(
    tag_id INT,
    genre_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, genre_id)
);

CREATE TABLE sub_genre_tag(
    tag_id INT,
    sub_genre_id INT,
    FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE,
    FOREIGN KEY (sub_genre_id) REFERENCES sub_genre (sub_genre_id) ON DELETE CASCADE,
    PRIMARY KEY(tag_id, sub_genre_id)
  );

-- TRIGGERS

-- TRIGGER TO VERIFY THAT A USER ONLY HAS 10 PLAYLISTS OR LESS
CREATE OR REPLACE FUNCTION check_user_playlist_limit()
RETURNS TRIGGER AS $$
BEGIN
   IF (SELECT COUNT(*) FROM playlist WHERE user_id = NEW.user_id) >= 10 THEN
      RAISE EXCEPTION 'A user cannot have more than 10 playlists.';
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_playlist_limit
BEFORE INSERT ON playlist
FOR EACH ROW
EXECUTE FUNCTION check_user_playlist_limit();


-- TRIGGER TO VERIFY THAT A REVIEW IS UNIQUE
CREATE OR REPLACE FUNCTION verify_unique_review() RETURNS TRIGGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF TG_TABLE_NAME = 'group_review' THEN
        SELECT COUNT(*) INTO v_count
        FROM (
            SELECT review_id FROM track_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM place_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM concert_review WHERE review_id = NEW.review_id
        ) AS reviews;
    ELSIF TG_TABLE_NAME = 'track_review' THEN
        SELECT COUNT(*) INTO v_count
        FROM (
            SELECT review_id FROM group_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM place_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM concert_review WHERE review_id = NEW.review_id
        ) AS reviews;
    ELSIF TG_TABLE_NAME = 'place_review' THEN
        SELECT COUNT(*) INTO v_count
        FROM (
            SELECT review_id FROM group_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM track_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM concert_review WHERE review_id = NEW.review_id
        ) AS reviews;
    ELSE
        SELECT COUNT(*) INTO v_count
        FROM (
            SELECT review_id FROM group_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM track_review WHERE review_id = NEW.review_id
            UNION ALL
            SELECT review_id FROM place_review WHERE review_id = NEW.review_id
        ) AS reviews;
    END IF;

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Review ID % is already associated with another review.', NEW.review_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER TO VERIFY THAT THE ATTENDANCE OF FINISHED CONCERT IS LOWER THAN THE PLACE MAX CAPACITY
CREATE OR REPLACE FUNCTION check_capacity_finished_concert()
RETURNS TRIGGER AS $$
DECLARE
place_capacity INT;
BEGIN
SELECT max_capacity INTO place_capacity FROM place WHERE place_id = NEW.place_id;
IF NEW.attendance > place_capacity THEN
RAISE EXCEPTION 'Attendance cannot exceed the place maximum capacity.';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER group_review_trigger
BEFORE INSERT ON group_review
FOR EACH ROW
EXECUTE PROCEDURE verify_unique_review();

CREATE TRIGGER track_review_trigger
BEFORE INSERT ON track_review
FOR EACH ROW
EXECUTE PROCEDURE verify_unique_review();

CREATE TRIGGER place_review_trigger
BEFORE INSERT ON place_review
FOR EACH ROW
EXECUTE PROCEDURE verify_unique_review();

CREATE TRIGGER concert_review_trigger
BEFORE INSERT ON concert_review
FOR EACH ROW
EXECUTE PROCEDURE verify_unique_review();

CREATE TRIGGER check_capacity_finished_concert_trigger
BEFORE INSERT ON finished_concert
FOR EACH ROW
EXECUTE FUNCTION check_capacity_finished_concert();

-- END
