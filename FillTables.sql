\copy musician FROM 'csv/musician.csv' WITH (FORMAT csv, HEADER true);
\copy track FROM 'csv/track.csv' WITH (FORMAT csv, HEADER true);
\copy music_group FROM 'csv/music_group.csv' WITH (FORMAT csv, HEADER true);
\copy users FROM 'csv/users.csv' WITH (FORMAT csv, HEADER true);
\copy people FROM 'csv/people.csv' WITH (FORMAT csv, HEADER true);
\copy groups FROM 'csv/groups.csv' WITH (FORMAT csv, HEADER true);
\copy organizers FROM 'csv/organizers.csv' WITH (FORMAT csv, HEADER true);
