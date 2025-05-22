CREATE DATABASE  IF NOT EXISTS `gerenciamento_projetos` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gerenciamento_projetos`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: gerenciamento_projetos
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `membro`
--

DROP TABLE IF EXISTS `membro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membro` (
  `id_membro` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `cargo` varchar(100) NOT NULL,
  PRIMARY KEY (`id_membro`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membro`
--

LOCK TABLES `membro` WRITE;
/*!40000 ALTER TABLE `membro` DISABLE KEYS */;
INSERT INTO `membro` VALUES (1,'Guilherme Soares','guihhsoaress@gmail.com','Lider'),(2,'Kaique Santos','kaique@gmail.com','Supervisor'),(3,'Henrique Linhares','hlinhares@gmail.com','Analista de TI'),(4,'Jean Vinicius','jean@gmail.com','Desenvolvedor Front-ChatGPT');
/*!40000 ALTER TABLE `membro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projeto`
--

DROP TABLE IF EXISTS `projeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projeto` (
  `id_projeto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(1000) NOT NULL,
  `descricao` text,
  `data_inicio` date DEFAULT NULL,
  `data_fim` date DEFAULT NULL,
  PRIMARY KEY (`id_projeto`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projeto`
--

LOCK TABLES `projeto` WRITE;
/*!40000 ALTER TABLE `projeto` DISABLE KEYS */;
INSERT INTO `projeto` VALUES (1,'FixNow','Sistema de gerenciamento de solicitações de manutenção Empresarial','2025-02-01',NULL),(2,'SafeBox','Sistema de encomendas para condominios','2025-05-12',NULL),(4,'CiaEstagios','Sistema de gerenciamento de estagiarios','2025-05-22',NULL);
/*!40000 ALTER TABLE `projeto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarefa`
--

DROP TABLE IF EXISTS `tarefa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarefa` (
  `id_tarefa` int NOT NULL AUTO_INCREMENT,
  `descricao` text,
  `data_inicio` date DEFAULT NULL,
  `data_fim` date DEFAULT NULL,
  `status` enum('Em andamento','Concluída','Atrasada') DEFAULT NULL,
  `projeto_id_projeto` int NOT NULL,
  `membro_id_membro` int NOT NULL,
  PRIMARY KEY (`id_tarefa`,`projeto_id_projeto`,`membro_id_membro`),
  KEY `fk_tarefa_projeto_idx` (`projeto_id_projeto`),
  KEY `fk_tarefa_membro1_idx` (`membro_id_membro`),
  CONSTRAINT `fk_tarefa_membro1` FOREIGN KEY (`membro_id_membro`) REFERENCES `membro` (`id_membro`),
  CONSTRAINT `fk_tarefa_projeto` FOREIGN KEY (`projeto_id_projeto`) REFERENCES `projeto` (`id_projeto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarefa`
--

LOCK TABLES `tarefa` WRITE;
/*!40000 ALTER TABLE `tarefa` DISABLE KEYS */;
INSERT INTO `tarefa` VALUES (1,'Criar Banco de dados','2025-05-14',NULL,'Em andamento',1,1),(2,'Criar APIS','2025-05-13',NULL,'Em andamento',1,2),(3,'Criar Documentação','2025-05-16',NULL,'Atrasada',1,1),(4,'Montar hardware','2025-05-21',NULL,'Atrasada',2,2),(6,'Perguntar pro chat como que faz','2025-05-20',NULL,'Atrasada',4,4);
/*!40000 ALTER TABLE `tarefa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gerenciamento_projetos'
--

--
-- Dumping routines for database 'gerenciamento_projetos'
--
/*!50003 DROP PROCEDURE IF EXISTS `cadastrar_membro` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_membro`(
    nome_colab VARCHAR(100),
    email_colab VARCHAR(100),
    cargo_colab VARCHAR(100),
    OUT saida VARCHAR(80),
    OUT saida_rotulo VARCHAR(80)
)
BEGIN
    IF EXISTS (SELECT * FROM membro WHERE email = email_colab) THEN
        BEGIN
            SET saida_rotulo = "OPS!!";
            SET saida = "Este membro já está cadastrado!";
        END;
    ELSE
        INSERT INTO membro (nome, email, cargo)
        VALUES (nome_colab, email_colab, cargo_colab);

        IF ROW_COUNT() = 0 THEN
            SET saida_rotulo = "ERRO!";
            SET saida = "O membro não foi cadastrado!";
        ELSE
            SET saida_rotulo = "Tudo Certo!";
            SET saida = "O membro foi cadastrado!";
        END IF;
    END IF;
SELECT saida_rotulo, saida;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cadastrar_projeto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_projeto`(nome_colab varchar(100), descricao_colab TEXT, data_inicio_colab DATE, data_fim_colab DATE,
OUT saida VARCHAR(80), saida_rotulo VARCHAR(80))
BEGIN
	IF EXISTS (SELECT * FROM projeto WHERE nome = nome_colab) THEN
		BEGIN
			SET saida_rotulo = "OPS!!";
			SET saida  = "Este projeto ja está cadastrado!!";
		END;
    ELSE
		INSERT INTO projeto (nome, descricao, data_inicio, data_fim) 
        VALUES(nome_colab, descricao_colab, data_inicio_colab, data_fim_colab);
        
        IF ROW_COUNT() = 0 THEN
			SET saida_rotulo = "ERRO!";
            SET saida = "O projeto não Foi Cadastrado!";
		ELSE 
			SET saida_rotulo = "Tudo Certo!";
            SET saida = "O projeto foi Cadastrado!";
		END IF;
	END IF;
    SELECT saida_rotulo, saida;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cadastrar_tarefa` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cadastrar_tarefa`(
    descricao_colab TEXT,
    data_inicio_colab DATE,
    data_fim_colab DATE,
    status_colab ENUM('Em andamento', 'Concluída', 'Atrasada'),
    id_projeto_colab INT,
    id_membro_colab INT,
    OUT saida VARCHAR(80),
    OUT saida_rotulo VARCHAR(80)
)
BEGIN
    IF (SELECT COUNT(*) FROM projeto WHERE id_projeto = id_projeto_colab) = 0 THEN
        SET saida_rotulo = "Erro!";
        SET saida = "O projeto informado não existe!";
    ELSEIF (SELECT COUNT(*) FROM membro WHERE id_membro = id_membro_colab) = 0 THEN
        SET saida_rotulo = "Erro!";
        SET saida = "O membro informado não existe!";
    ELSE
        INSERT INTO tarefa (descricao, data_inicio, data_fim, status, projeto_id_projeto, membro_id_membro)
        VALUES (descricao_colab, data_inicio_colab, data_fim_colab, status_colab, id_projeto_colab, id_membro_colab);

        IF ROW_COUNT() = 0 THEN
            SET saida_rotulo = "ERRO!";
            SET saida = "A tarefa não foi cadastrada!";
        ELSE
            SET saida_rotulo = "Tudo Certo!";
            SET saida = "A tarefa foi cadastrada!";
        END IF;
    END IF;
SELECT saida_rotulo, saida;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-22 10:48:05
