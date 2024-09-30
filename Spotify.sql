select * from spotify
LIMIT 100

--EDA

SELECT COUNT (*) FROM spotify

	
SELECT COUNT (DISTINCT album) FROM spotify

SELECT DISTINCT album_type FROM spotify
	
SELECT MAX(duration_min) FROM spotify

DELETE FROM spotify 
WHERE duration_min = 0;

SELECT DISTINCT most_played_on FROM spotify

-------------------------
--- DATA ANALYSIS EASY --
-------------------------

/*Easy Level
1)Retrieve the names of all tracks that have more than 1 billion streams.
2)List all albums along with their respective artists.
3)Get the total number of comments for tracks where licensed = TRUE.
4)Find all tracks that belong to the album type single.
5)Count the total number of tracks by each artist.
*/


SELECT * FROM spotify
WHERE stream > 1000000
ORDER BY 

SELECT album,artist
FROM spotify

SELECT SUM(comments) as Total_Comments
FROM spotify
WHERE licensed = 'TRUE'

SELECT * FROM spotify
WHERE album_type = 'single'

SELECT 
    artist,---1
    Count(*) AS total_no_songs---2 
FROM spotify
GROUP BY artist

/*
Medium Level
1)Calculate the average danceability of tracks in each album.
2)Find the top 5 tracks with the highest energy values.
3)List all tracks along with their views and likes where official_video = TRUE.
4)For each album, calculate the total views of all associated tracks.
5)Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

SELECT 
    album,
    avg(danceability) AS avg_danceability

FROM Spotify
GROUP BY 1
ORDER by 2 DESC

SELECT track, MAX(energy) AS MAX_ENERGY
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT track, SUM(views) as total_views, SUM(likes) as total_likes
FROM Spotify
WHERE official_video = TRUE
GROUP BY 1


SELECT album, SUM(views) as Total_views
FROM Spotify
GROUP BY 1
ORDER BY 2 DESC;


SELECT * FROM
(SELECT track,
        SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END) as streamed_on_youtube,
        SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END) as streamed_on_spotify
FROM spotify
GROUP BY 1) as t1
WHERE streamed_on_spotify > streamed_on_youtube AND streamed_on_youtube <> streamed_on_spotify




/*
Advanced Level

1)Find the top 3 most-viewed tracks for each artist using window functions.
2)Write a query to find tracks where the liveness score is above the average.
3)Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
*/

WITH ranking_artist as
(
SELECT artist, track,
        SUM(views) as total_view,
        DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
from spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC)
SELECT * FROM ranking_artist
WHERE rank <= 3        



SELECT artist, track, liveness 
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)


WITH cte
AS

(SELECT  album,
        MAX(energy) as highest_energy,
        MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
        album,
        highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 2 DESC               