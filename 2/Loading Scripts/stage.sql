DROP DATABASE IF EXISTS movies;
CREATE DATABASE movies;
USE movies;

DROP TABLE IF EXISTS stage_films;
/*==============================================================*/
/* Table: STAGE_FILMS                                           */
/*==============================================================*/
CREATE TABLE stage_films
(
   movie_id      	INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   title        	VARCHAR(100) NULL,
   media_type 		VARCHAR(6) NULL,
   genre        	VARCHAR(50) NULL,
   director			VARCHAR(100) NULL,
   release_year 	YEAR NULL,
   duration     	INT NULL,
   sales 			BIGINT NULL,
   UNIQUE KEY unique_films (title, release_year)
);

DROP TABLE IF EXISTS stage_imdb;
/*==============================================================*/
/* Table: STAGE_IMDB                                            */
/*==============================================================*/
CREATE TABLE stage_imdb
(
   movie_id         INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   title            VARCHAR(100) NOT NULL,
   genre            VARCHAR(50) NULL,
   director         VARCHAR(100) NULL,
   release_year		YEAR NULL,
   duration         INT NULL,
   rating           FLOAT NULL,
   UNIQUE KEY unique_imdb (title, release_year)
);

DROP TABLE IF EXISTS stage_nsfw;
/*==============================================================*/
/* Table: STAGE_EXPLICIT                                        */
/*==============================================================*/
create table stage_nsfw
(
   movie_id			INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   title            VARCHAR(100) NULL,
   media_type       VARCHAR(6) NULL,
   genre            VARCHAR(50) NULL,
   license          VARCHAR(9) NULL,
   nsfw           	VARCHAR(10) NULL,
   release_year		YEAR NULL,
   duration         INT NULL,
   rating           FLOAT NULL,
   UNIQUE KEY unique_nsfw (title, release_year)
);

DROP TABLE IF EXISTS stage_sales;
/*==============================================================*/
/* Table: STAGE_SALES                                           */
/*==============================================================*/
CREATE TABLE stage_sales
(
   movie_id			INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
   title            VARCHAR(100) NULL,
   genre            VARCHAR(50) NULL,
   distributor      VARCHAR(100) NULL,
   license          VARCHAR(9) NULL,
   release_year		YEAR NULL,
   duration         INT NULL,
   sales            BIGINT NULL,
   UNIQUE KEY unique_sales (title, release_year)
);