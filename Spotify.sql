-- Advanced SQL project -- Spotify Dataset

-- ----------------------------------------------------------------------------------------
-- create table
-- ----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


-- ----------------------------------------------------------------------------------------
-- EDA (Exploratory Data Analysis)
-- ----------------------------------------------------------------------------------------

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

-- Here we found the song having 0 min duration which is not possible actually
SELECT * FROM spotify
WHERE duration_min = 0;

-- Here we have deleted the song having the duration = 0
DELETE FROM spotify
WHERE duration_min = 0;
SELECT * FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

-- ----------------------------------------------------------------------------------------
-- DATA ANALYSIS - Easy Category
-- ----------------------------------------------------------------------------------------

/*
Q1 Retrieve the names of all the tracks that have more than 1 billion streams.
Q2 List all the albums along with their respective artists.
Q3 Get the total number of comments for tracks where licensed = TRUE.
Q4 Find all tracks that belong to the album type single.
Q5 Count the total number of tracks by each artists.
*/


-- QUESTION 1 Retrieve the names of all the tracks that have more than 1 billion streams.

SELECT * FROM spotify;

SELECT album FROM spotify
WHERE stream > 1000000000

-- FINAL ANSWER OF QUESTION 1
SELECT * FROM spotify
WHERE stream > 1000000000;


-- QUESTION 2 List all the albums along with their respective artists.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 2
SELECT DISTINCT album, artist
FROM spotify;

-- QUESTION 3 Get the total number of comments for tracks where licensed = TRUE.

-- FINAL ANSWER OF QUESTION 3
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';


-- QUESTION 4 Find all tracks that belong to the album type single.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 4
SELECT * FROM spotify
WHERE album_type = 'single';


-- QUESTION 5 Count the total number of tracks by each artist.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 5
SELECT DISTINCT artist, COUNT(*) AS total_no_songs
FROM spotify
GROUP BY artist;



-- ----------------------------------------------------------------------------------------
-- DATA ANALYSIS - Medium Category
-- ----------------------------------------------------------------------------------------

/*
Q6 Calculate the average danceability of tracks in each album
Q7 Find the top 5 tracks with the highest enery values.
Q8 List all tracks along with their views and likes where official_video = TRUE.
Q9 For each album, calculate the total views of all associated tracks.
Q10 Retrieve the track names that have been streamed on spotify more than YouTube.
*/

-- QUESTION 6 Calculate the average danceability of tracks in each album.

SELECT * FROM spotify;

-- FINAL ANSWER FOR QUESTION 6
SELECT album, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;


-- QUESTION 7 Find the top 5 tracks with the highest energy values.

SELECT * FROM spotify;


-- FINAL ANSWER OF QUESTION 7
SELECT track, MAX(energy) AS track_energy
FROM spotify
GROUP BY track
ORDER BY track_energy DESC
LIMIT 5;


-- QUESTION 8 List all the tracks along with their views and likes where official_video = TRUE.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 8
SELECT 
	track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY track
ORDER BY total_views DESC
LIMIT 5;


-- QUESTION 9 For each album, calculate the total views of all associated tracks.

SELECT * FROM spotify;


-- FINAL ANSWER OF QUESTION 9
SELECT
	album,
	track,
	SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;


-- QUESTION 10 Retrieve the track names that have been streamed on spotify more than YouTube.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 10
SELECT * FROM 
(SELECT 
	track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) as streamed_on_spotify
FROM spotify
GROUP BY track
) AS t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0


-- ----------------------------------------------------------------------------------------
-- DATA ANALYSIS - Advanced Category
-- ----------------------------------------------------------------------------------------

/*
Q11 Find the top 3 most-viewed tracks for each artists using windows functions.
Q12 Write a query to find tracks where the liveness score is above the average.
Q13 Use a WITH clause to calculate the difference between the highest and lowest energy values for track in each album.
Q14 Find tracks where the energy-to-liveness ratio is greater than 1.2.
Q15 Calculate the cumlative sum of likes for tracks ordered by the number of views, using window functions.
*/


-- QUESTION 11 Find the top 3 most-viewed tracks for each artists using windows function.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 11
WITH ranking_artist
AS
(SELECT
	artist,
	track,
	SUM(views) AS total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY artist, track
ORDER BY artist, total_view DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3


--QUESTION 12 Write a query to find tracks where the liveness score is above the average


SELECT * FROM spotify;

SELECT AVG(liveness)
FROM spotify;

-- FINAL ANSWER OF QUESTION 12
SELECT
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness)FROM spotify);



-- QUESTION 13 Use a WITH clause to calculate the difference between the highest and the lowest energy values for track in each album.

SELECT * FROM spotify;

-- FINAL ANSWER OF QUESTION 13
WITH cte
AS 
(SELECT
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY album
)
SELECT 
	album,
	highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY energy_diff DESC























