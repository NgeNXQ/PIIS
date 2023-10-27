-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: movies
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dim_distributor`
--

DROP TABLE IF EXISTS `dim_distributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_distributor` (
  `distributor_id` int NOT NULL AUTO_INCREMENT,
  `distributor` varchar(100) NOT NULL,
  PRIMARY KEY (`distributor_id`),
  UNIQUE KEY `distributor` (`distributor`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_distributor`
--

LOCK TABLES `dim_distributor` WRITE;
/*!40000 ALTER TABLE `dim_distributor` DISABLE KEYS */;
INSERT INTO `dim_distributor` VALUES (1,'20th Century Studios'),(2,'Artisan Entertainment'),(3,'Columbia Pictures'),(4,'Dimension Films'),(5,'DreamWorks'),(6,'DreamWorks Distribution'),(7,'FilmDistrict'),(8,'Focus Features'),(9,'Fox Searchlight Pictures'),(10,'IFC Films'),(11,'Lionsgate'),(12,'Metro-Goldwyn-Mayer (MGM)'),(13,'Miramax'),(14,'New Line Cinema'),(15,'Newmarket Films'),(16,'Orion Pictures'),(17,'Paramount Pictures'),(18,'Relativity Media'),(19,'Revolution Studios'),(20,'Roadside Attractions'),(21,'Screen Gems'),(22,'Sony Pictures Classics'),(23,'Sony Pictures Entertainment (SPE)'),(24,'STX Entertainment'),(25,'Summit Entertainment'),(26,'The Weinstein Company'),(27,'TriStar Pictures'),(28,'Twentieth Century Fox'),(29,'United Artists'),(30,'United Artists Releasing'),(31,'Universal Pictures'),(32,'USA Films'),(33,'Walt Disney Studios Motion Pictures'),(34,'Warner Bros');
/*!40000 ALTER TABLE `dim_distributor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-05  3:20:04
