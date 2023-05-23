\copy musician FROM 'csv/musician.csv' WITH (FORMAT csv, HEADER true);
\copy track FROM 'csv/track.csv' WITH (FORMAT csv, HEADER true);
\copy music_group FROM 'csv/music_group.csv' WITH (FORMAT csv, HEADER true);
