USE movies;

#Loading stage_films
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stage_films.csv'
IGNORE INTO TABLE stage_films
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@release_year, @duration, @title, @genre, @director, @sales, @media_type)
SET release_year = NULLIF(@release_year, ''),
	duration = NULLIF(@duration, ''),
    title = movies.FORMAT_TITLE(@title),
    genre = NULLIF(@genre, ''),
    director = IF (@director = '', NULL, TRIM(',' FROM movies.TRANSFORM_DIRECTOR_REVERSED(@director))),
	sales = NULLIF(@sales, ''),
	media_type = NULLIF(@media_type, '');
    
    
#Loading stage_imdb
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stage_imdb.csv'
IGNORE INTO TABLE stage_imdb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(title, @director, @rating, @genre, @duration, @release_year)
SET director =  IF (@director = '', NULL, TRIM(',' FROM movies.TRANSFROM_DIRECTOR_PASCAL_CASE(@director))),
	rating = NULLIF(@rating, ''),
	genre = IF (@genre = '', NULL, CUT_GENRE(@genre)),
	duration = IF (@duration = '', NULL, CAST(SUBSTRING(@duration, 1, LENGTH(@duration) - 3) AS UNSIGNED)),
	release_year = NULLIF(@release_year, '');
    
	
#Loading stage_nsfw
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stage_nsfw.csv'
IGNORE INTO TABLE stage_nsfw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(title, @release_year, @rating, @genre, @duration, @media_type, @license, @nsfw)
SET release_year = NULLIF(@release_year, ''),
	rating = IF (@rating = 'No Rate', NULL, CAST(@rating AS DECIMAL(2, 1))),
	genre = IF (@genre = '', NULL, CUT_GENRE(@genre)),
    duration = IF (@duration = 'None', NULL, CAST(@duration AS DECIMAL(3, 0))),
	media_type = NULLIF(@media_type, ''),
	license = CASE
				WHEN @license IN ('None', 'Not Rated', 'Unrated', '') THEN NULL
                WHEN @license = 'Passed' THEN 'Approved'
                ELSE @license
			  END,
    nsfw = IF (@nsfw = 'No Rate' OR '', NULL, @nsfw);
    
    
#Loading stage_sales
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stage_sales.csv'
IGNORE INTO TABLE stage_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@title, @distributor, @release_year, @sales, @genre, @duration, @license)
SET title = SUBSTRING(@title, 1, LENGTH(@title) - 7),
	distributor = CASE
					WHEN @distributor = '' THEN NULL
                    WHEN @distributor = 'Warner Bros.' THEN 'Warner Bros'
                    ELSE @distributor
				  END,
	release_year = IF (@release_year IN ('NA', ''), 
						IF (SUBSTRING_INDEX(SUBSTRING_INDEX(@title, '(', -1), ')', 1) REGEXP '^[0-9]+$', CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(@title, '(', -1), ')', 1) AS UNSIGNED), NULL),
                        YEAR(STR_TO_DATE(@release_year, '%M %d, %Y'))),
	sales = NULLIF(@sales, ''),
	genre = IF (@genre = '', NULL, REPLACE(REPLACE(REPLACE(REPLACE(CUT_GENRE(@genre), '[', ''), ']', ''), '''', ''), ', ', ',')),
	duration = IF (@duration = '', NULL, movies.CONVERT_STRING_TIME(@duration)),
	license = CASE
				WHEN @license IN ('NA', '') THEN NULL
				ELSE @license
			  END;	