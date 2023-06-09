\copy musician FROM 'csv/musician.csv' WITH (FORMAT csv, HEADER true);
\copy track FROM 'csv/track.csv' WITH (FORMAT csv, HEADER true);
\copy music_group FROM 'csv/music_group.csv' WITH (FORMAT csv, HEADER true);
\copy users FROM 'csv/users.csv' WITH (FORMAT csv, HEADER true);
\copy people FROM 'csv/people.csv' WITH (FORMAT csv, HEADER true);
\copy groups FROM 'csv/groups.csv' WITH (FORMAT csv, HEADER true);
\copy organizers FROM 'csv/organizers.csv' WITH (FORMAT csv, HEADER true);
\copy genre FROM 'csv/genre.csv' WITH (FORMAT csv, HEADER true);
\copy sub_genre FROM 'csv/sub_genre.csv' WITH (FORMAT csv, HEADER true);
\copy place FROM 'csv/place.csv' WITH (FORMAT csv, HEADER true);
\copy link_musician_music_group FROM 'csv/link_musician_music_group.csv' WITH (FORMAT csv, HEADER true);
\copy link_people_musician FROM 'csv/link_people_musician.csv' WITH (FORMAT csv, HEADER true);
\copy music_group_plays_track FROM 'csv/music_group_plays_track.csv' WITH (FORMAT csv, HEADER true);
\copy musician_plays_track FROM 'csv/musician_plays_track.csv' WITH (FORMAT csv, HEADER true);
\copy follows FROM 'csv/follows.csv' WITH (FORMAT csv, HEADER true);
\copy friendship FROM 'csv/friendship.csv' WITH (FORMAT csv, HEADER true);
\copy future_concert FROM 'csv/future_concert.csv' WITH (FORMAT csv, HEADER true);
\copy future_concert_music_group_lineup FROM 'csv/future_concert_music_group_lineup.csv' WITH (FORMAT csv, HEADER true);
\copy future_concert_musicians_lineup FROM 'csv/future_concert_musicians_lineup.csv' WITH (FORMAT csv, HEADER true);
\copy future_concert_genre FROM 'csv/future_concert_genre.csv' WITH (FORMAT csv, HEADER true);
\copy future_concert_sub_genre FROM 'csv/future_concert_sub_genre.csv' WITH (FORMAT csv, HEADER true);
\copy finished_concert FROM 'csv/finished_concert.csv' WITH (FORMAT csv, HEADER true);
\copy finished_concert_music_group_lineup FROM 'csv/finished_concert_music_group_lineup.csv' WITH (FORMAT csv, HEADER true);
\copy finished_concert_musicians_lineup FROM 'csv/finished_concert_musicians_lineup.csv' WITH (FORMAT csv, HEADER true);
\copy finished_concert_genre FROM 'csv/finished_concert_genre.csv' WITH (FORMAT csv, HEADER true);
\copy finished_concert_sub_genre FROM 'csv/finished_concert_sub_genre.csv' WITH (FORMAT csv, HEADER true);
\copy review FROM 'csv/review.csv' WITH (FORMAT csv, HEADER true);
\copy track_review FROM 'csv/track_review.csv' WITH (FORMAT csv, HEADER true);
\copy group_review FROM 'csv/group_review.csv' WITH (FORMAT csv, HEADER true);
\copy place_review FROM 'csv/place_review.csv' WITH (FORMAT csv, HEADER true);
\copy concert_review FROM 'csv/concert_review.csv' WITH (FORMAT csv, HEADER true);
\copy post FROM 'csv/post.csv' WITH (FORMAT csv, HEADER true);
\copy media FROM 'csv/media.csv' WITH (FORMAT csv, HEADER true);
\copy tag FROM 'csv/tag.csv' WITH (FORMAT csv, HEADER true);
\copy post_tag FROM 'csv/post_tag.csv' WITH (FORMAT csv, HEADER true);
\copy review_tag FROM 'csv/review_tag.csv' WITH (FORMAT csv, HEADER true);
\copy place_tag FROM 'csv/place_tag.csv' WITH (FORMAT csv, HEADER true);
\copy future_concert_tag FROM 'csv/future_concert_tag.csv' WITH (FORMAT csv, HEADER true);
\copy finished_concert_tag FROM 'csv/finished_concert_tag.csv' WITH (FORMAT csv, HEADER true);
\copy music_group_tag FROM 'csv/music_group_tag.csv' WITH (FORMAT csv, HEADER true);
\copy genre_tag FROM 'csv/genre_tag.csv' WITH (FORMAT csv, HEADER true);
\copy sub_genre_tag FROM 'csv/sub_genre_tag.csv' WITH (FORMAT csv, HEADER true);
\copy playlist FROM 'csv/playlist.csv' WITH (FORMAT csv, HEADER true);
\copy playlist_track FROM 'csv/playlist_track.csv' WITH (FORMAT csv, HEADER true);
\copy track_genre FROM 'csv/track_genre.csv' WITH (FORMAT csv, HEADER true);
\copy track_sub_genre FROM 'csv/track_sub_genre.csv' WITH (FORMAT csv, HEADER true);
\copy organizers_announce_concert FROM 'csv/organizers_announce_concert.csv' WITH (FORMAT csv, HEADER true);
\copy user_attends_concert FROM 'csv/user_attends_concert.csv' WITH (FORMAT csv, HEADER true);
