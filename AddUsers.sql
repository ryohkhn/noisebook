-- Inserting 10 Person rows
INSERT INTO user (user_id, username, password, email, bio)
VALUES (1, 'JohnDoe', 'password1', 'john.doe@gmail.com', 'Bio for person1');
INSERT INTO person (person_id, user_id, first_name, last_name, birth_date)
VALUES (1, 1, 'John', 'Doe', '1990-01-01');

INSERT INTO user (user_id, username, password, email, bio)
VALUES (2, 'Janee91', 'password2', 'janedoe@gmail.com', 'Bio for person2');
INSERT INTO person (person_id, user_id, first_name, last_name, birth_date)
VALUES (2, 2, 'Jane', 'Doe', '1991-02-02');

-- ... 8 more rows

-- Inserting 10 Group rows
-- Assuming you have a music_group table
INSERT INTO user (user_id, username, password, email, bio)
VALUES (11, 'Metallica', 'password11', 'metallica@gmail.com', 'Rock');
INSERT INTO "group" (group_id, user_id, music_group_id, group_name)
VALUES (1, 11, 1, 'Music Group 1');

INSERT INTO user (user_id, username, password, email, bio)
VALUES (12, 'SOAD', 'password12', 'soad@gmail.com', 'Hard rock');
INSERT INTO "group" (group_id, user_id, music_group_id, group_name)
VALUES (2, 12, 2, 'System of a down');

-- ... 8 more rows

-- Inserting 10 Organizer rows
INSERT INTO user (user_id, username, password, email, bio)
VALUES (21, 'organizer1', 'password21', 'organizer1@gmail.com', 'Bio for organizer1');
INSERT INTO organizer (organizer_id, user_id, organizer_name, location)
VALUES (1, 21, 'Organizer 1', 'New York');

INSERT INTO user (user_id, username, password, email, bio) VALUES (22, 'organizer2', 'password22', 'organizer2@gmail.com', 'Bio for organizer2');
INSERT INTO organizer (organizer_id, user_id, organizer_name, location)
VALUES (2, 22, 'Organizer 2', 'Los Angeles');

-- ... 8 more rows
