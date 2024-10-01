-- MySQL dump 10.13  Distrib 8.3.0, for macos14 (x86_64)
--
-- Host: 127.0.0.1    Database: HospitalRecordsApp
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `Doctors`
--

DROP TABLE IF EXISTS `Doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Doctors` (
  `Doctor_ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(20) DEFAULT NULL,
  `Last_Name` varchar(20) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Specialty` varchar(20) DEFAULT NULL,
  `Sub_Specialty` varchar(20) DEFAULT NULL,
  `Email` varchar(30) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Primary_Hospital_ID` int DEFAULT NULL,
  PRIMARY KEY (`Doctor_ID`),
  KEY `Primary_Hospital_ID` (`Primary_Hospital_ID`),
  CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`Primary_Hospital_ID`) REFERENCES `Hospitals` (`Hospital_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Doctors`
--

LOCK TABLES `Doctors` WRITE;
/*!40000 ALTER TABLE `Doctors` DISABLE KEYS */;
INSERT INTO `Doctors` VALUES (1,'Person','A',31,'AB','GH','PersonA@gmail.com','1234567890',1),(2,'Person','B',39,'AB','HI','PersonB@gmail.com','2345678901',2),(3,'Person','C',24,'BC','GH','PersonC@gmail.com','3456789012',1),(4,'Person','D',30,'CD','GH','PersonD@gmail.com','4567890123',3),(5,'Person','E',43,'CD','IJ','PersonE@gmail.com','5678901234',4),(6,'Person','F',30,'DE','JK','PersonF@gmail.com','6789012345',5),(7,'Person','G',23,'EF','KL','PersonG@gmail.com','7890123456',6),(8,'Person','H',47,'AB','LM','PersonH@gmail.com','8901234567',7),(9,'Person','I',45,'DE','MN','PersonI@gmail.com','9012345678',7),(10,'Person','J',32,'BC','NO','PersonJ@gmail.com','0123456789',8);
/*!40000 ALTER TABLE `Doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Hospitals`
--

DROP TABLE IF EXISTS `Hospitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Hospitals` (
  `Hospital_ID` int NOT NULL AUTO_INCREMENT,
  `Hospital_Name` varchar(20) DEFAULT NULL,
  `Region` varchar(20) DEFAULT NULL,
  `State` varchar(20) DEFAULT NULL,
  `Address` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`Hospital_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Hospitals`
--

LOCK TABLES `Hospitals` WRITE;
/*!40000 ALTER TABLE `Hospitals` DISABLE KEYS */;
INSERT INTO `Hospitals` VALUES (1,'Hospital_A','A','A','1234 ABCD'),(2,'Hospital_B','A','A','2345 BCDE'),(3,'Hospital_C','A','B','3456 CDEF'),(4,'Hospital_D','B','C','4567 DEFG'),(5,'Hospital_E','B','D','5678 EFGH'),(6,'Hospital_F','C','D','6789 FGHI'),(7,'Hospital_G','C','E','7890 GHIJ'),(8,'Hospital_H','C','E','8901 HIJK');
/*!40000 ALTER TABLE `Hospitals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `Invoice_ID` int NOT NULL AUTO_INCREMENT,
  `Date` datetime DEFAULT NULL,
  `Patient_ID` int DEFAULT NULL,
  `Hospital_ID` int DEFAULT NULL,
  `CoPay_Amt` double DEFAULT NULL,
  `Purpose` varchar(350) DEFAULT NULL,
  PRIMARY KEY (`Invoice_ID`),
  KEY `Hospital_ID` (`Hospital_ID`),
  KEY `idx_invoice_patient_id` (`Patient_ID`),
  CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `Patients` (`Patient_ID`),
  CONSTRAINT `invoices_ibfk_2` FOREIGN KEY (`Hospital_ID`) REFERENCES `Hospitals` (`Hospital_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,'2024-04-18 00:00:00',1,1,139,'A'),(2,'2024-04-19 00:00:00',2,2,148,'A'),(3,'2024-04-20 00:00:00',3,1,144,'A'),(4,'2024-04-21 00:00:00',4,3,36,'B'),(5,'2024-04-22 00:00:00',5,4,48,'B'),(6,'2024-04-23 00:00:00',6,5,174,'C'),(7,'2024-04-24 00:00:00',7,6,97,'D'),(8,'2024-04-25 00:00:00',8,7,197,'C'),(9,'2024-04-26 00:00:00',9,7,167,'E'),(10,'2024-04-27 00:00:00',10,8,158,'E');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Patients`
--

DROP TABLE IF EXISTS `Patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Patients` (
  `Patient_ID` int NOT NULL AUTO_INCREMENT,
  `Insurance_Number` varchar(20) DEFAULT NULL,
  `First_Name` varchar(20) DEFAULT NULL,
  `Last_Name` varchar(20) DEFAULT NULL,
  `Username` varchar(20) DEFAULT NULL,
  `Password` varchar(20) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Email` varchar(20) DEFAULT NULL,
  `Phone_Number` varchar(20) DEFAULT NULL,
  `Blood_Type` varchar(5) DEFAULT NULL,
  `Primary_Doctor_ID` int DEFAULT NULL,
  `Is_Deleted` int DEFAULT '0',
  PRIMARY KEY (`Patient_ID`),
  KEY `Primary_Doctor_ID` (`Primary_Doctor_ID`),
  CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`Primary_Doctor_ID`) REFERENCES `Doctors` (`Doctor_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Patients`
--

LOCK TABLES `Patients` WRITE;
/*!40000 ALTER TABLE `Patients` DISABLE KEYS */;
INSERT INTO `Patients` VALUES (1,'1234','Person','K','PersonK','K',25,'NEWpersonK@gmail.com','0987654321','A',1,0),(2,'2345','Person','L','PersonL','L',31,'PersonL@gmail.com','9876543210','B',2,0),(3,'3456','Person','M','PersonM','M',50,'PersonM@gmail.com','8765432109','A+',3,1),(4,'4567','Person','N','PersonN','N',26,'PersonN@gmail.com','7654321098','A-',4,0),(5,'5678','Person','O','PersonO','O',34,'PersonO@gmail.com','6543210987','O',5,0),(6,'6789','Person','P','PersonP','P',43,'PersonP@gmail.com','5432109876','B+',6,0),(7,'7890','Person','Q','PersonQ','Q',50,'PersonQ@gmail.com','4321098765','B+',7,0),(8,'8901','Person','R','PersonR','R',40,'PersonR@gmail.com','3210987654','O-',8,0),(9,'9012','Person','S','PersonS','S',44,'PersonS@gmail.com','2109876543','O-',9,0),(10,'0123','Person','T','PersonT','T',39,'PersonT@gmail.com','1098765432','A',10,0),(11,NULL,NULL,NULL,'Caroline','123',NULL,'robinson@email.com','123456789',NULL,NULL,0),(12,'1','aoic','b','a','c',34,'a','23','A',1,0),(13,'1','acs','b','a','c',34,'a','23','A',1,0),(14,'1','aac','b','a','c',34,'a','23','A',1,0),(15,'1','ac','b','a','c',34,'a','23','A',2,0),(16,'1','aec','b','a','c',34,'a','23','A',2,0),(17,'1','arc','b','a','c',34,'a','23','A',3,0),(18,'1','ack','b','a','c',34,'a','23','A',10,0);
/*!40000 ALTER TABLE `Patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_patient_invoices`
--

DROP TABLE IF EXISTS `view_patient_invoices`;
/*!50001 DROP VIEW IF EXISTS `view_patient_invoices`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_patient_invoices` AS SELECT 
 1 AS `InvoiceID`,
 1 AS `Patient_ID`,
 1 AS `Date`,
 1 AS `CoPay_Amount`,
 1 AS `Visit_Purpose`,
 1 AS `Hospital_Name`,
 1 AS `Address`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Visits`
--

DROP TABLE IF EXISTS `Visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Visits` (
  `Visit_ID` int NOT NULL,
  `Date` datetime DEFAULT NULL,
  `Patient_ID` int DEFAULT NULL,
  `Doctor_ID` int DEFAULT NULL,
  `Purpose` varchar(350) DEFAULT NULL,
  `Visit_Completed` tinyint(1) DEFAULT '0',
  `Is_Deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`Visit_ID`),
  KEY `Patient_ID` (`Patient_ID`),
  KEY `Doctor_ID` (`Doctor_ID`),
  CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`Patient_ID`) REFERENCES `Patients` (`Patient_ID`),
  CONSTRAINT `visits_ibfk_2` FOREIGN KEY (`Doctor_ID`) REFERENCES `Doctors` (`Doctor_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Visits`
--

LOCK TABLES `Visits` WRITE;
/*!40000 ALTER TABLE `Visits` DISABLE KEYS */;
INSERT INTO `Visits` VALUES (1,'2024-04-18 00:00:00',1,1,'A',1,0),(2,'2024-04-19 00:00:00',2,2,'A',1,0),(3,'2024-04-20 00:00:00',3,3,'B',1,0),(4,'2024-04-21 00:00:00',4,4,'C',1,0),(5,'2024-04-22 00:00:00',5,5,'D',1,0),(6,'2024-04-23 00:00:00',6,6,'D',1,0),(7,'2024-04-24 00:00:00',7,7,'E',1,0),(8,'2024-04-25 00:00:00',8,8,'E',1,0),(9,'2024-04-26 00:00:00',9,9,'F',1,0),(10,'2024-04-27 00:00:00',10,10,'F',1,0);
/*!40000 ALTER TABLE `Visits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `view_patient_invoices`
--

/*!50001 DROP VIEW IF EXISTS `view_patient_invoices`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_patient_invoices` AS select `invoices`.`Invoice_ID` AS `InvoiceID`,`invoices`.`Patient_ID` AS `Patient_ID`,`invoices`.`Date` AS `Date`,`invoices`.`CoPay_Amt` AS `CoPay_Amount`,`invoices`.`Purpose` AS `Visit_Purpose`,`hospitals`.`Hospital_Name` AS `Hospital_Name`,`hospitals`.`Address` AS `Address` from (`invoices` join `hospitals` on((`invoices`.`Hospital_ID` = `hospitals`.`Hospital_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-17 23:13:15
