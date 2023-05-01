CREATE TABLE User (
  user_id INT PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  password VARCHAR(50),
  email VARCHAR(50),
  bio VARCHAR(255),
  -- other attributes of User
  CONSTRAINT user_has_subentity CHECK (
    EXISTS (SELECT * FROM Person WHERE Person.user_id = User.user_id)
    OR EXISTS (SELECT * FROM Group WHERE Group.user_id = User.user_id)
    OR EXISTS (SELECT * FROM Ortganizateur WHERE Organizer.user_id = User.user_id)
  )
);

CREATE TABLE Person (
  person_id INT PRIMARY KEY,
  user_id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  birth_date DATE,
  -- other attributes of Person
  FOREIGN KEY (user_id) REFERENCES User (user_id)
);

CREATE TABLE Group (
  group_id INT PRIMARY KEY,
  user_id INT,
  group_name VARCHAR(50),
  -- other attributes of Group
  FOREIGN KEY (user_id) REFERENCES User (user_id)
);

CREATE TABLE Organizer (
  ortganizateur_id INT PRIMARY KEY,
  user_id INT,
  ortganizateur_name VARCHAR(50),
  location VARCHAR(50),
  -- other attributes of ortganizateur
  FOREIGN KEY (user_id) REFERENCES User (user_id)
);

CREATE TABLE Follows (
  follower_id INT NOT NULL,
  followed_id INT NOT NULL,
  PRIMARY KEY (follower_id, followed_id),
  FOREIGN KEY (follower_id) REFERENCES User (user_id),
  FOREIGN KEY (followed_id) REFERENCES User (user_id)
);

CREATE TABLE Friendship (
  user1_id INT NOT NULL,
  user2_id INT NOT NULL,
  PRIMARY KEY (user1_id, user1_id),
  FOREIGN KEY (user1_id) REFERENCES User (user_id),
  FOREIGN KEY (user2_id) REFERENCES User (user_id)
);

CREATE TABLE Playlist (
  playlist_id INT PRIMARY KEY,
  playlist_name VARCHAR(50),
  description VARCHAR(255),
  -- other attributes of Playlist
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES User (user_id),
  CONSTRAINT user_playlist_limit CHECK (
    (SELECT COUNT(*) FROM Playlist WHERE user_id = user_id) <= 10
  )
  -- todo peut etre un compteur de playlists crees dans User est une meilleure idee
);



CREATE TABLE UserCreatesPlaylist (
  user_id INT NOT NULL,
  playlist_id INT NOT NULL,
  PRIMARY KEY (user_id),
  FOREIGN KEY (user_id) REFERENCES User (user_id),
  FOREIGN KEY (playlist_id) REFERENCES Playlist (playlist_id)
);
