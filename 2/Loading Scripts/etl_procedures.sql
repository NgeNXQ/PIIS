USE movies;

DROP PROCEDURE IF EXISTS SET_TITLES;
DROP PROCEDURE IF EXISTS FILL_TIME_DIM;
DROP PROCEDURE IF EXISTS BIND_TIME_DIM;
DROP PROCEDURE IF EXISTS SET_DURATION;
DROP PROCEDURE IF EXISTS SET_SALES;
DROP PROCEDURE IF EXISTS SET_RATING;
DROP PROCEDURE IF EXISTS FILL_DIRECTOR_DIM;
DROP PROCEDURE IF EXISTS BIND_DIRECTOR_DIM;
DROP PROCEDURE IF EXISTS FILL_LICENSE_DIM;
DROP PROCEDURE IF EXISTS BIND_LICENSE_DIM;
DROP PROCEDURE IF EXISTS FILL_MEDIA_DIM;
DROP PROCEDURE IF EXISTS BIND_MEDIA_DIM;
DROP PROCEDURE IF EXISTS FILL_NSFW_DIM;
DROP PROCEDURE IF EXISTS BIND_NSFW_DIM;
DROP PROCEDURE IF EXISTS FILL_DISTRIBUTOR_DIM;
DROP PROCEDURE IF EXISTS BIND_DISTRIBUTOR_DIM;
DROP PROCEDURE IF EXISTS FILL_GENRE_DIM;
DROP PROCEDURE IF EXISTS BIND_GENRE_DIM;

DELIMITER $$
CREATE PROCEDURE SET_TITLES ()		# Titles
BEGIN
	INSERT INTO fact_movie (title)
    SELECT title FROM
    (SELECT DISTINCT title, release_year FROM 
	((SELECT title, release_year FROM stage_nsfw AS nsfw) 
	UNION 
	(SELECT title, release_year FROM stage_sales AS sales)
	UNION 
	(SELECT title, release_year FROM stage_imdb AS imdb)
	UNION
	(SELECT title, release_year FROM stage_films AS films)) 
    AS union_subquery) 
    AS stage_data
    ORDER BY title;
END $$

DELIMITER $$
CREATE PROCEDURE FILL_TIME_DIM (IN start_year INT, IN end_year INT)		# Fill time
BEGIN
	DECLARE current_year INT DEFAULT start_year;
    WHILE current_year <= end_year DO
        INSERT INTO dim_time (release_year) VALUES (YEAR(DATE(CONCAT(current_year, '-01-01'))));
        SET current_year = current_year + 1;
    END WHILE;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_TIME_DIM ()		# Bind time
BEGIN
	UPDATE fact_movie
	INNER JOIN (
	SELECT release_year, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
    (SELECT DISTINCT title, release_year FROM 
	((SELECT title, release_year FROM stage_nsfw AS nsfw) 
	UNION 
	(SELECT title, release_year FROM stage_sales AS sales)
	UNION 
	(SELECT title, release_year FROM stage_imdb AS imdb)
	UNION
	(SELECT title, release_year FROM stage_films AS films)) 
    AS union_subquery)
    AS subquery) 
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.time_id = (SELECT time_id FROM dim_time WHERE release_year = stage_data.release_year);
END $$

DELIMITER $$
CREATE PROCEDURE SET_DURATION ()		# Duration
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT duration, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, ROUND(AVG(duration)) AS duration FROM 
    (SELECT title, release_year, duration FROM stage_nsfw
    UNION
    SELECT title, release_year, duration FROM stage_sales
    UNION
    SELECT title, release_year, duration FROM stage_imdb
    UNION
    SELECT title, release_year, duration FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.duration = stage_data.duration;	
END $$

DELIMITER $$
CREATE PROCEDURE SET_SALES ()			# Sales
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT sales, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, MAX(sales) AS sales FROM 
    (SELECT title, release_year, NULL AS sales FROM stage_nsfw
    UNION
    SELECT title, release_year, sales FROM stage_sales
    UNION
    SELECT title, release_year, NULL AS sales FROM stage_imdb
    UNION
    SELECT title, release_year, sales FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.sales = stage_data.sales;
END $$

DELIMITER $$
CREATE PROCEDURE SET_RATING ()			# Rating
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT rating, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, FORMAT(ROUND(AVG(rating), 1), 1) AS rating FROM 
    (SELECT title, release_year, rating FROM stage_nsfw
    UNION
    SELECT title, release_year, NULL AS rating FROM stage_sales
    UNION
    SELECT title, release_year, rating FROM stage_imdb
    UNION
    SELECT title, release_year, NULL AS rating FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.rating = stage_data.rating;
END $$

DELIMITER $$
CREATE PROCEDURE FILL_DIRECTOR_DIM ()		# Fill director
BEGIN
	INSERT IGNORE INTO dim_director (director)
	SELECT DISTINCT director FROM 
    (SELECT director FROM stage_films WHERE director IS NOT NULL
	UNION
	SELECT director FROM stage_imdb WHERE director IS NOT NULL)
	AS subquery
    ORDER BY director;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_DIRECTOR_DIM ()		# Director
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT director, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, MAX(director) AS director FROM 
    (SELECT title, release_year, NULL AS director FROM stage_nsfw
    UNION
    SELECT title, release_year, NULL AS director FROM stage_sales
    UNION
    SELECT title, release_year, director FROM stage_imdb
    UNION
    SELECT title, release_year, director FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year)
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.director_id = (SELECT director_id FROM dim_director WHERE director = stage_data.director);
END $$

DELIMITER $$
CREATE PROCEDURE FILL_LICENSE_DIM ()	# Fill license
BEGIN
	INSERT IGNORE INTO dim_license (license)
	SELECT DISTINCT license FROM 
	(SELECT license FROM stage_nsfw WHERE license IS NOT NULL
	UNION
	SELECT license FROM stage_sales WHERE license IS NOT NULL)
	AS subquery
    ORDER BY license;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_LICENSE_DIM ()	# Bind license
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT license, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, MAX(license) AS license FROM 
    (SELECT title, release_year, license FROM stage_nsfw
    UNION
    SELECT title, release_year, license FROM stage_sales
    UNION
    SELECT title, release_year, NULL AS license FROM stage_imdb
    UNION
    SELECT title, release_year, NULL AS license FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.license_id = (SELECT license_id FROM dim_license WHERE license = stage_data.license);
END $$

DELIMITER $$
CREATE PROCEDURE FILL_MEDIA_DIM ()		# Fill media-type
BEGIN
	INSERT IGNORE INTO dim_media_type (media_type)
	SELECT DISTINCT media_type FROM 
    (SELECT media_type FROM stage_films WHERE media_type IS NOT NULL
	UNION
	SELECT media_type FROM stage_nsfw WHERE media_type IS NOT NULL)
	AS subquery;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_MEDIA_DIM ()		# Bind media-type
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT media_type, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, MAX(media_type) AS media_type FROM 
    (SELECT title, release_year, media_type FROM stage_nsfw
    UNION
    SELECT title, release_year, NULL AS media_type FROM stage_sales
    UNION
    SELECT title, release_year, NULL AS media_type FROM stage_imdb
    UNION
    SELECT title, release_year, media_type FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.media_type_id = (SELECT media_type_id FROM dim_media_type WHERE media_type = stage_data.media_type);
END $$

CREATE PROCEDURE FILL_NSFW_DIM ()		# Fill nsfw
BEGIN
	INSERT IGNORE INTO dim_nsfw (nsfw)
	SELECT DISTINCT nsfw FROM stage_nsfw
    WHERE nsfw IS NOT NULL;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_NSFW_DIM ()		# Bind nsfw
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT nsfw, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, MAX(nsfw) AS nsfw FROM 
    (SELECT title, release_year, nsfw FROM stage_nsfw
    UNION
    SELECT title, release_year, NULL AS nsfw FROM stage_sales
    UNION
    SELECT title, release_year, NULL AS nsfw FROM stage_imdb
    UNION
    SELECT title, release_year, NULL AS nsfw FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.nsfw_id = (SELECT nsfw_id FROM dim_nsfw WHERE nsfw = stage_data.nsfw);
END $$

CREATE PROCEDURE FILL_DISTRIBUTOR_DIM ()	# Fill distributor
BEGIN
	INSERT IGNORE INTO dim_distributor (distributor)
    SELECT DISTINCT distributor FROM stage_sales WHERE distributor IS NOT NULL
    ORDER BY distributor;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_DISTRIBUTOR_DIM ()	# Bind distributor
BEGIN
	UPDATE fact_movie
	INNER JOIN 
    (SELECT distributor, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
        (SELECT title, release_year, MAX(distributor) AS distributor FROM 
            (SELECT title, release_year, NULL AS distributor FROM stage_nsfw
            UNION
            SELECT title, release_year, distributor FROM stage_sales
            UNION
            SELECT title, release_year, NULL AS distributor FROM stage_imdb
            UNION
            SELECT title, release_year, NULL AS distributor FROM stage_films) 
        AS union_subquery
        GROUP BY title, release_year) 
		AS subquery)
	AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.distributor_id = (SELECT distributor_id FROM dim_distributor WHERE distributor = stage_data.distributor);
END $$

CREATE PROCEDURE FILL_GENRE_DIM ()			# Fill genre
BEGIN
    INSERT IGNORE INTO dim_genre (genre)
    SELECT DISTINCT genre FROM
		(SELECT title, release_year, genre FROM stage_nsfw WHERE genre IS NOT NULL 
		UNION
		SELECT title, release_year, genre FROM stage_sales WHERE genre IS NOT NULL 
		UNION
		SELECT title, release_year, genre FROM stage_imdb WHERE genre IS NOT NULL 
		UNION
		SELECT title, release_year, genre FROM stage_films WHERE genre IS NOT NULL)
		AS records
	ORDER BY genre;
END $$

DELIMITER $$
CREATE PROCEDURE BIND_GENRE_DIM ()			# Bind genre
BEGIN
	UPDATE fact_movie
	INNER JOIN (
    SELECT genre, ROW_NUMBER() OVER (ORDER BY title) AS number FROM
	(SELECT title, release_year, MAX(genre) AS genre FROM 
    (SELECT title, release_year, genre FROM stage_nsfw
    UNION
    SELECT title, release_year, genre FROM stage_sales
    UNION
    SELECT title, release_year, genre FROM stage_imdb
    UNION
    SELECT title, release_year, genre FROM stage_films) 
    AS union_subquery
	GROUP BY title, release_year) 
    AS subquery)
    AS stage_data
	ON fact_movie.fact_id = stage_data.number
	SET fact_movie.genre_id = (SELECT genre_id FROM dim_genre WHERE genre = stage_data.genre);
END $$