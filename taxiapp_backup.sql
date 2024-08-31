-- MySQL dump 10.13  Distrib 8.0.37, for Linux (x86_64)
--
-- Host: localhost    Database: TaxiApp
-- ------------------------------------------------------
-- Server version	8.0.37-0ubuntu0.22.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `DriverProfiles`
--

DROP TABLE IF EXISTS `DriverProfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DriverProfiles` (
  `driver_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `vehicle_details` varchar(255) NOT NULL,
  PRIMARY KEY (`driver_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `DriverProfiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DriverProfiles`
--

LOCK TABLES `DriverProfiles` WRITE;
/*!40000 ALTER TABLE `DriverProfiles` DISABLE KEYS */;
INSERT INTO `DriverProfiles` VALUES (2,2,'Jane Smith','987-654-3210','AB1234567','Toyota Prius'),(3,1,'John Doe','555-1234','DL12345678','Sedan, ABC-1234'),(4,1,'John Doe','555-1234','DL12345678','{\"type\": \"Sedan\", \"registration\": \"ABC-1234\"}'),(5,1,'John Doe','555-1234','DL12345678','Sedan, ABC-1234'),(6,1,'John Doe','555-1234','DL12345678','Sedan, ABC-1234');
/*!40000 ALTER TABLE `DriverProfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DriverRatings`
--

DROP TABLE IF EXISTS `DriverRatings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DriverRatings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `driver_id` int DEFAULT NULL,
  `passenger_id` int DEFAULT NULL,
  `ride_id` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comments` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  KEY `driver_id` (`driver_id`),
  KEY `passenger_id` (`passenger_id`),
  KEY `ride_id` (`ride_id`),
  CONSTRAINT `DriverRatings_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `Drivers` (`driver_id`),
  CONSTRAINT `DriverRatings_ibfk_2` FOREIGN KEY (`passenger_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `DriverRatings_ibfk_3` FOREIGN KEY (`ride_id`) REFERENCES `Rides` (`ride_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DriverRatings`
--

LOCK TABLES `DriverRatings` WRITE;
/*!40000 ALTER TABLE `DriverRatings` DISABLE KEYS */;
/*!40000 ALTER TABLE `DriverRatings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Drivers`
--

DROP TABLE IF EXISTS `Drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Drivers` (
  `driver_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `vehicle_type` varchar(50) DEFAULT NULL,
  `vehicle_registration_number` varchar(50) DEFAULT NULL,
  `availability_status` varchar(20) DEFAULT 'available',
  `average_rating` float DEFAULT '0',
  `total_rides` int DEFAULT '0',
  `earnings` float DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`driver_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Drivers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Drivers`
--

LOCK TABLES `Drivers` WRITE;
/*!40000 ALTER TABLE `Drivers` DISABLE KEYS */;
INSERT INTO `Drivers` VALUES (1,8,'Car','driver','available',0,0,0,'2024-08-20 17:31:21','2024-08-20 17:31:21'),(2,9,'Sedan','ABC1234','available',0,0,0,'2024-08-20 17:31:25','2024-08-20 17:31:25'),(3,10,'','','available',0,0,0,'2024-08-20 17:33:21','2024-08-20 17:33:21'),(4,11,'','','available',0,0,0,'2024-08-20 17:33:26','2024-08-20 17:33:26'),(5,12,'','','available',0,0,0,'2024-08-20 17:33:26','2024-08-20 17:33:26'),(6,13,'','','available',0,0,0,'2024-08-21 20:20:00','2024-08-21 20:20:00'),(7,14,'batmobil','iambatman','available',0,0,0,'2024-08-23 00:47:05','2024-08-23 00:47:05'),(8,15,'batmobil','iambatman','available',0,0,0,'2024-08-23 01:00:48','2024-08-23 01:00:48'),(9,1,'Sedan','ABC123','available',0,0,0,'2024-08-23 15:30:15','2024-08-23 15:30:15');
/*!40000 ALTER TABLE `Drivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PassengerProfiles`
--

DROP TABLE IF EXISTS `PassengerProfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PassengerProfiles` (
  `passenger_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  PRIMARY KEY (`passenger_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `PassengerProfiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PassengerProfiles`
--

LOCK TABLES `PassengerProfiles` WRITE;
/*!40000 ALTER TABLE `PassengerProfiles` DISABLE KEYS */;
INSERT INTO `PassengerProfiles` VALUES (1,1,'John Doe','123-456-7890','123 Main St'),(2,1,'John Doe','123-456-7890','123 Main St'),(3,1,'John Doe','123-456-7890','123 Main St'),(4,1,'John Doe','123-456-7890','123 Main St'),(5,1,'John Doe','123-456-7890','123 Main St');
/*!40000 ALTER TABLE `PassengerProfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payments`
--

DROP TABLE IF EXISTS `Payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `ride_id` int DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('CreditCard','DigitalWallet','Cash') NOT NULL,
  `payment_status` enum('Pending','Completed','Failed') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `ride_id` (`ride_id`),
  CONSTRAINT `Payments_ibfk_1` FOREIGN KEY (`ride_id`) REFERENCES `Rides` (`ride_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payments`
--

LOCK TABLES `Payments` WRITE;
/*!40000 ALTER TABLE `Payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `Payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `ride_id` int DEFAULT NULL,
  `reviewer_id` int DEFAULT NULL,
  `reviewee_id` int DEFAULT NULL,
  `rating` int NOT NULL,
  `comments` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `ride_id` (`ride_id`),
  KEY `reviewer_id` (`reviewer_id`),
  KEY `reviewee_id` (`reviewee_id`),
  CONSTRAINT `Reviews_ibfk_1` FOREIGN KEY (`ride_id`) REFERENCES `Rides` (`ride_id`),
  CONSTRAINT `Reviews_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `Reviews_ibfk_3` FOREIGN KEY (`reviewee_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reviews`
--

LOCK TABLES `Reviews` WRITE;
/*!40000 ALTER TABLE `Reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `Reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RideRequests`
--

DROP TABLE IF EXISTS `RideRequests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RideRequests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `passenger_id` int DEFAULT NULL,
  `driver_id` int DEFAULT NULL,
  `pickup_location` point DEFAULT NULL,
  `destination_location` point DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `fare_estimate` float DEFAULT NULL,
  `scheduled_time` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `passenger_id` (`passenger_id`),
  KEY `driver_id` (`driver_id`),
  CONSTRAINT `RideRequests_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `RideRequests_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `Drivers` (`driver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RideRequests`
--

LOCK TABLES `RideRequests` WRITE;
/*!40000 ALTER TABLE `RideRequests` DISABLE KEYS */;
INSERT INTO `RideRequests` VALUES (1,2,NULL,_binary '\0\0\0\0\0\0\0^K\È=[D@ª\ñ\ÒMb€RÀ',_binary '\0\0\0\0\0\0\0%±¤\Ü}dD@E\r¦aø}RÀ','pending',15,NULL,'2024-08-23 15:38:45','2024-08-23 15:38:45'),(2,2,NULL,_binary '\0\0\0\0\0\0\0^K\È=[D@ª\ñ\ÒMb€RÀ',_binary '\0\0\0\0\0\0\0%±¤\Ü}dD@E\r¦aø}RÀ','pending',15,NULL,'2024-08-23 15:38:45','2024-08-23 15:38:45'),(3,2,NULL,_binary '\0\0\0\0\0\0\0^K\È=[D@ª\ñ\ÒMb€RÀ',_binary '\0\0\0\0\0\0\0%±¤\Ü}dD@E\r¦aø}RÀ','pending',15,NULL,'2024-08-23 15:52:25','2024-08-23 15:52:25'),(4,2,NULL,_binary '\0\0\0\0\0\0\0^K\È=[D@ª\ñ\ÒMb€RÀ',_binary '\0\0\0\0\0\0\0%±¤\Ü}dD@E\r¦aø}RÀ','pending',15,NULL,'2024-08-23 15:52:25','2024-08-23 15:52:25');
/*!40000 ALTER TABLE `RideRequests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rides`
--

DROP TABLE IF EXISTS `Rides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rides` (
  `ride_id` int NOT NULL AUTO_INCREMENT,
  `passenger_id` int DEFAULT NULL,
  `driver_id` int DEFAULT NULL,
  `start_location` varchar(255) NOT NULL,
  `end_location` varchar(255) NOT NULL,
  `distance` decimal(5,2) NOT NULL,
  `duration` time NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `status` enum('Requested','Accepted','Completed','Cancelled') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ride_id`),
  KEY `passenger_id` (`passenger_id`),
  KEY `driver_id` (`driver_id`),
  CONSTRAINT `Rides_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `PassengerProfiles` (`passenger_id`),
  CONSTRAINT `Rides_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `DriverProfiles` (`driver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rides`
--

LOCK TABLES `Rides` WRITE;
/*!40000 ALTER TABLE `Rides` DISABLE KEYS */;
INSERT INTO `Rides` VALUES (8,1,2,'123 Main St','456 Elm St',10.00,'00:25:00',20.75,'Completed','2024-08-18 16:19:43'),(9,1,2,'123 Main St','456 Elm St',10.00,'00:25:00',20.75,'Completed','2024-08-18 16:20:28'),(10,1,2,'123 Main St','456 Elm St',10.00,'00:25:00',20.75,'Completed','2024-08-18 16:20:28'),(15,2,5,'Main Street','Central Park',5.00,'00:00:10',15.00,'Completed','2024-08-23 15:46:32');
/*!40000 ALTER TABLE `Rides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserSessions`
--

DROP TABLE IF EXISTS `UserSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserSessions` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `logout_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `UserSessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserSessions`
--

LOCK TABLES `UserSessions` WRITE;
/*!40000 ALTER TABLE `UserSessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserSessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('Passenger','Driver') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'johndoe','$2a$10$/y40./lZR5T1tyhLqfXUZ.9X6Qag3UYlZ7Wo2usp99HC9rJKtJ0nm','newuser@example.com','Passenger','2024-08-01 09:54:29'),(2,'newuser','$2a$10$oc7lU38niifpb90sGIBreu3WSRMuNtqIogSRm9aGTLMracjxzxY9W','newuser@example.com','Passenger','2024-08-01 09:57:05'),(3,'Greeksouvlaki','$2a$10$eNgeKGROKWk7tsh41oQXB.WtOqnZzbU/ctSzvQ0rv0chEvu5XHFTG','test','Passenger','2024-08-01 12:22:40'),(4,'user2','$2a$10$cgF7awwNyleTW7.0Cvv8.unm5bL3D7X.2f3Y1Fkt5F7Gbw6gcYrE.','user','Passenger','2024-08-18 15:20:46'),(5,'','$2a$10$assZ7KXiRjlmuI7ucKD56u6wsNDLOsJaVhF9ddGeGYbahM5AyJk0u','','Passenger','2024-08-18 18:53:36'),(6,'user','$2a$10$u314epCAEOhktTmCNvgpCO0wpo3389UFHu3OZqAHQn7e/kpui5F6G','user@example.com','Passenger','2024-08-18 18:53:56'),(7,'test2','$2a$10$pe8l9rvsAu2HOrlOj.0s1O3PpCWptGi2EhfaA6TX1Mwq1TcddvX9O','test2','Passenger','2024-08-20 16:00:36'),(8,'driver','$2a$10$E.KzpwnYxE3bEYKyoS5y1Ous9q5h5Flxjtz5VMF.ffm3Rru9orLPK','driver','Driver','2024-08-20 17:31:21'),(9,'driver123','$2a$10$YpvlWb6V4036pxnLMRFUAOzkDUv/L33uXyBUN46lWCnhbNKDcFbEa','driver123@example.com','Driver','2024-08-20 17:31:25'),(10,'','$2a$10$p5TUYiGow5ARcYUVYLGYMuely44V7ztFPnZZ/Am.UauzZ.IGohFjW','','Driver','2024-08-20 17:33:21'),(11,'','$2a$10$G7q07ZsNeXXSbEljRaXVN.PrS5WEe9N8j4ktBt3En5nrLdsZBozYa','','Driver','2024-08-20 17:33:26'),(12,'','$2a$10$SNWJGuq9rXriOGbX7sr4weyRzufcAznqYEYrqjrBwb6AaFUFPs2cu','','Driver','2024-08-20 17:33:26'),(13,'','$2a$10$.VpiMVMSI41ocHcPeYIijuW05VIg8YfzFEsxRWD1ViL3xiTW5ObNC','','Driver','2024-08-21 20:20:00'),(14,'driver','$2a$10$vB5gkY4QLbN04z0Oyj4qkeII0PKdn4D.Aq.bDl.afZvN28MjL4L1K','driver','Driver','2024-08-23 00:47:05'),(15,'batman','$2a$10$Gu0dHGYkob.j1SyFnIY4w.maaaqSFohzeawfXxi0ifEIuSB0waIPa','batman','Driver','2024-08-23 01:00:48');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-08-24 20:33:04
