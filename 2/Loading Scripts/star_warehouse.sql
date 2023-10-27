USE movies;

DROP TABLE IF EXISTS dim_time;
/*==============================================================*/
/* Table: DIM_TIME                                              */
/*==============================================================*/
CREATE TABLE dim_time
(
   time_id          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   release_year		YEAR UNIQUE NOT NULL
);

DROP TABLE IF EXISTS dim_media_type;
/*==============================================================*/
/* Table: DIM_MEDIA_TYPE                                        */
/*==============================================================*/
CREATE TABLE dim_media_type
(
   media_type_id		INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   media_type           VARCHAR(6) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS dim_license;
/*==============================================================*/
/* Table: DIM_LICENSE                                           */
/*==============================================================*/
CREATE TABLE dim_license
(
   license_id		INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   license          VARCHAR(9) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS dim_genre;
/*==============================================================*/
/* Table: DIM_GENRE                                             */
/*==============================================================*/
CREATE TABLE dim_genre
(
   genre_id		INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   genre        VARCHAR(50) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS dim_distributor;
/*==============================================================*/
/* Table: DIM_DISTRIBUTOR                                       */
/*==============================================================*/
CREATE TABLE dim_distributor
(
   distributor_id		INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   distributor          VARCHAR(100) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS dim_nsfw;
/*==============================================================*/
/* Table: DIM_NSFW                                              */
/*==============================================================*/
CREATE TABLE dim_nsfw
(
   nsfw_id		INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   nsfw       	VARCHAR(10) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS dim_director;
/*==============================================================*/
/* Table: DIM_NSFW                                              */
/*==============================================================*/
CREATE TABLE dim_director
(
   director_id		INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   director       	VARCHAR(100) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS fact_movie;
/*==============================================================*/
/* Table: FACTS_MOVIES                                          */
/*==============================================================*/
CREATE TABLE fact_movie
(
   fact_id              INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   time_id              INT NULL,
   media_type_id        INT NULL,
   director_id			INT NULL,
   genre_id             INT NULL,
   distributor_id		INT NULL,
   license_id           INT NULL,
   nsfw_id              INT NULL,
   title                VARCHAR(100) NOT NULL,
   sales                BIGINT NULL,
   rating               FLOAT NULL,
   duration             INT NULL,
   UNIQUE KEY unique_key (title, time_id),
   FOREIGN KEY (time_id) REFERENCES dim_time(time_id),
   FOREIGN KEY (media_type_id) REFERENCES dim_media_type(media_type_id),
   FOREIGN KEY (license_id) REFERENCES dim_license(license_id),
   FOREIGN KEY (genre_id) REFERENCES dim_genre(genre_id),
   FOREIGN KEY (distributor_id) REFERENCES dim_distributor(distributor_id),
   FOREIGN KEY (nsfw_id) REFERENCES dim_nsfw(nsfw_id),
   FOREIGN KEY (director_id) REFERENCES dim_director(director_id)
);